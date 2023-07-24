local aName, aObj = ...

local _G = _G
-- luacheck: ignore 631 (line is too long)

local module = aObj:NewModule("ViewPort")

local db
local defaults = {
	profile = {
		shown = false,
		overlay = false,
		top = 64,
		bottom = 64,
		left = 128,
		right = 128,
		colour = {r = 0, g = 0, b = 0, a = 1},
		XRes = 768,
		YRes = 1050,
	}
}


function module:OnInitialize()

	-- check to see if any other Viewport Addons are enabled
	if aObj:isAddonEnabled("Aperture")
	or aObj:isAddonEnabled("Btex")
	or aObj:isAddonEnabled("CT_Viewport")
	or aObj:isAddonEnabled("SunnArt")
	then
		self:Disable() -- disable ourself
		return
	end

	self.db = aObj.db:RegisterNamespace("ViewPort", defaults)
	db = self.db.profile

	-- convert any old settings
	if aObj.db.profile.ViewPort then
		for k, v in _G.pairs(aObj.db.profile.ViewPort) do
			db[k] = v
		end
		aObj.db.profile.ViewPort = nil
	end

	if not db.shown then self:Disable() end -- disable ourself

end

function module:OnDisable() -- luacheck: ignore 212 (unused argument)

	_G.CinematicFrame_OnShow = module.CinematicFrame_OnShow and module.CinematicFrame_OnShow
	_G.CinematicFrame_OnHide = module.CinematicFrame_OnHide and module.CinematicFrame_OnHide
	_G.WorldFrame:SetUserPlaced(false)

end

function module:OnEnable()

	if db.shown then
		module.CinematicFrame_OnShow = _G.CinematicFrame_OnShow
		module.CinematicFrame_OnHide = _G.CinematicFrame_OnHide
		_G.CinematicFrame_OnShow = _G.nop
		_G.CinematicFrame_OnHide = _G.nop
		self:adjustViewPort("init")
		_G.WorldFrame:SetUserPlaced(true)
	end

	-- handle Viewport being reset when certain cutscenes are shown
	aObj:RegisterEvent("CINEMATIC_STOP", function(_, _)
		module:adjustViewPort("shown")
	end)
	aObj:SecureHook("GameMovieFinished", function()
		module:adjustViewPort("shown")
	end)

end

local texAreas, vpoF = {"top", "btm", "left", "right"}
local function checkOverlay(scale)
	if db.shown then
		if db.overlay then
			if not vpoF then
				vpoF = _G.CreateFrame("Frame", nil)
				vpoF:SetAllPoints(_G.UIParent)
				vpoF:SetFrameLevel(0)
				vpoF:SetFrameStrata("BACKGROUND")
				vpoF:EnableMouse(false)
				vpoF:SetMovable(false)
				for _, area in _G.pairs(texAreas) do
					vpoF[area] = vpoF:CreateTexture(nil, "BACKGROUND")
				end
			end
			vpoF.top:ClearAllPoints()
			vpoF.top:SetPoint("TOPLEFT")
			vpoF.top:SetPoint("BOTTOMRIGHT", vpoF, "TOPRIGHT", 0, -(db.top * scale))
			vpoF.btm:ClearAllPoints()
			vpoF.btm:SetPoint("BOTTOMLEFT")
			vpoF.btm:SetPoint("TOPRIGHT", vpoF, "BOTTOMRIGHT", 0, (db.bottom * scale))
			vpoF.left:ClearAllPoints()
			vpoF.left:SetPoint("TOPLEFT", 0, -(db.top * scale))
			vpoF.left:SetPoint("BOTTOMRIGHT", vpoF, "BOTTOMLEFT", (db.left * scale), (db.bottom * scale))
			vpoF.right:ClearAllPoints()
			vpoF.right:SetPoint("TOPRIGHT", 0, -(db.top * scale))
			vpoF.right:SetPoint("BOTTOMLEFT", vpoF, "BOTTOMRIGHT", -(db.right * scale), (db.bottom * scale))
			-- use Texture file or Colour
			if (db.texfile
			and db.texfile ~= "None")
			or (db.texture
			and db.texture ~= "None")
			then
				local tex = aObj.LSM:Fetch("background", db.texfile ~= "None" and db.texfile or db.texture ~= "None" and db.texture)
				for _, area in _G.pairs(texAreas) do
					-- the texture will be stretched if the following tiling methods are set to false
					vpoF[area]:SetHorizTile(db.tile and true)
					vpoF[area]:SetVertTile(db.tile and true)
					vpoF[area]:SetTexture(tex, db.tile, db.tile)
				end
			else
				for _, area in _G.pairs(texAreas) do
					vpoF[area]:SetColorTexture(db.colour.r, db.colour.g, db.colour.b, db.colour.a)
				end
			end
			-- show the overlay frame
			vpoF:Show()
		elseif vpoF then
			vpoF:Hide()
		end
	elseif vpoF then
		vpoF:Hide()
	end
end
function module:adjustViewPort(opt)

	-- handle in combat
	if _G.InCombatLockdown() then
	    aObj:add2Table(aObj.oocTab, {self.adjustViewPort, {opt}})
	    return
	end

	local scale = _G.UIParent:GetEffectiveScale()

	if db.shown then
		_G.WorldFrame:ClearAllPoints()
		_G.WorldFrame:SetPoint("TOPLEFT", (db.left * scale), -(db.top * scale))
		_G.WorldFrame:SetPoint("BOTTOMRIGHT", -(db.right * scale), (db.bottom * scale))
		checkOverlay(scale)
	else
		_G.WorldFrame:ClearAllPoints()
		_G.WorldFrame:SetPoint("TOPLEFT")
		_G.WorldFrame:SetPoint("BOTTOMRIGHT")
		checkOverlay(scale)
	end

end

function module:GetOptions() -- luacheck: ignore 212 (unused argument)

	local c
	local options = {
		type = "group",
		order = 1,
		name = aObj.L["View Port"],
		desc = aObj.L["Change the ViewPort settings"],
		get = function(info)
			if info[#info] == "colour" then
				c = module.db.profile[info[#info]]
				return c.r, c.g, c.b, c.a
			else
				return module.db.profile[info[#info]]
			end
		end,
		set = function(info, r, g, b, a)
			if info[#info] ~= "shown" then
				module.db.profile.shown = true -- always enable if any option other than show is changed
			end
			if info[#info] == "colour"
			or info[#info] == "texfile"
			or info[#info] == "texture"
			or info[#info] == "tile"
			then
				module.db.profile.overlay = true
			end
			if info[#info] == "colour" then
				c = module.db.profile[info[#info]]
				c.r, c.g, c.b, c.a = r, g, b, a
			else
				module.db.profile[info[#info]] = r
			end
			if module.db.profile.texfile
			and module.db.profile.texfile ~= "None"
			then
				aObj.LSM:Register("background", aName .. " Viewport Background", module.db.profile.texfile)
			end
			if not module:IsEnabled() then
				module:Enable()
			else
				module:adjustViewPort(info[#info])
			end
		end,
		args = {
			shown = {
				type = "toggle",
				order = 1,
				-- width = "full",
				name = aObj.L["ViewPort Show"],
				desc = aObj.L["Toggle the ViewPort"],
			},
			overlay = {
				type = "toggle",
				order = 3,
				name = aObj.L["ViewPort Overlay"],
				desc = aObj.L["Toggle the ViewPort Overlay"],
			},
			overlaysettings = {
				type = "group",
				order = 5,
				inline = true,
				name = aObj.L["Overlay Settings"],
				disabled = function() return not module.db.profile.overlay end,
				args = {
					colour = {
						type = "color",
						order = 1,
						name = aObj.L["ViewPort Colour"],
						desc = aObj.L["Set ViewPort Colour"],
						hasAlpha = true,
					},
					texfile = {
						type = "input",
						order = 3,
						width = "full",
						name = aObj.L["Viewport Texture File"],
						desc = aObj.L["Set Viewport Texture Filename"],
					},
					texture = _G.AceGUIWidgetLSMlists and {
						type = "select",
						order = 5,
						width = "double",
						name = aObj.L["Viewport Texture"],
						desc = aObj.L["Choose the Texture for the Viewport"],
						dialogControl = "LSM30_Background",
						values = _G.AceGUIWidgetLSMlists.background,
					},
					tile = {
						type = "select",
						order = 7,
						name = "  " .. aObj.L["Tile Type"],
						desc = aObj.L["Tile or Stretch the Texture"],
						values = {["None"] = aObj.L["No Tiling"], ["Mirror"] = aObj.L["Mirror Texture"], ["Repeat"] = aObj.L["Repeat Texture"]},
					},
				},
			},
			top = {
				type = "range",
				order = 10,
				name = aObj.L["VP Top"],
				desc = aObj.L["Change Height of the Top Band"],
				min = 0, max = 256, step = 1,
			},
			bottom = {
				type = "range",
				order = 11,
				name = aObj.L["VP Bottom"],
				desc = aObj.L["Change Height of the Bottom Band"],
				min = 0, max = 256, step = 1,
			},
			left = {
				type = "range",
				order = 12,
				name = aObj.L["VP Left"],
				desc = aObj.L["Change Width of the Left Band"],
				min = 0, max = 1800, step = 1,
			},
			right = {
				type = "range",
				order = 13,
				name = aObj.L["VP Right"],
				desc = aObj.L["Change Width of the Right Band"],
				min = 0, max = 1800, step = 1,
			},
		}
	}
	return options

end
