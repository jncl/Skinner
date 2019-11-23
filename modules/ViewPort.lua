local _, aObj = ...

local _G = _G
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

local function checkOverlay()

	local vpoF

	if db.shown then
		if db.overlay then
			local scale = _G.UIParent:GetEffectiveScale()
			if not vpoF then
				vpoF = _G.CreateFrame("Frame", nil)
				vpoF:SetAllPoints(_G.UIParent)
				vpoF:SetFrameLevel(0)
				vpoF:SetFrameStrata("BACKGROUND")
				vpoF:EnableMouse(false)
				vpoF:SetMovable(false)
				vpoF.top = vpoF:CreateTexture(nil, "BACKGROUND")
				vpoF.btm = vpoF:CreateTexture(nil, "BACKGROUND")
				vpoF.left = vpoF:CreateTexture(nil, "BACKGROUND")
				vpoF.right = vpoF:CreateTexture(nil, "BACKGROUND")
			end
			vpoF.top:SetTexture(db.colour.r, db.colour.g, db.colour.b, db.colour.a)
			vpoF.btm:SetTexture(db.colour.r, db.colour.g, db.colour.b, db.colour.a)
			vpoF.left:SetTexture(db.colour.r, db.colour.g, db.colour.b, db.colour.a)
			vpoF.right:SetTexture(db.colour.r, db.colour.g, db.colour.b, db.colour.a)
			vpoF.top:ClearAllPoints()
			vpoF.top:SetPoint("TOPLEFT")
			vpoF.top:SetPoint("BOTTOMRIGHT", vpoF, "TOPRIGHT", 0, -(db.top * scale))
			vpoF.btm:ClearAllPoints()
			vpoF.btm:SetPoint("BOTTOMLEFT")
			vpoF.btm:SetPoint("TOPRIGHT", vpoF, "BOTTOMRIGHT", 0, (db.bottom * scale))
			vpoF.left:ClearAllPoints()
			vpoF.left:SetPoint("TOPLEFT", vpoF, "TOPLEFT", 0, -(db.top * scale))
			vpoF.left:SetPoint("BOTTOMRIGHT", vpoF, "BOTTOMLEFT", (db.left * scale), (db.bottom * scale))
			vpoF.right:ClearAllPoints()
			vpoF.right:SetPoint("TOPRIGHT", vpoF, "TOPRIGHT", 0, -(db.top * scale))
			vpoF.right:SetPoint("BOTTOMLEFT", vpoF, "BOTTOMRIGHT", -(db.right * scale), (db.bottom * scale))
			-- show the overlay frame
			vpoF:Show()
		elseif vpoF then
			vpoF:Hide()
		end
	elseif vpoF then
		vpoF:Hide()
	end

end

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

function module:OnEnable()

	if db.shown then self:adjustViewPort("init") end

end

function module:adjustViewPort(opt)

	local scale = _G.UIParent:GetEffectiveScale()

	if (opt == "init" and db.shown)
	or (opt == "shown" and db.shown)
	or (opt == "top" and db.shown)
	or (opt == "bottom" and db.shown)
	or (opt == "left" and db.shown)
	or (opt == "right" and db.shown)
	or (opt == "XRes" and db.shown)
	or (opt == "YRes" and db.shown)
	then
		_G.WorldFrame:ClearAllPoints()
		_G.WorldFrame:SetPoint("TOPLEFT", (db.left * scale), -(db.top * scale))
		_G.WorldFrame:SetPoint("BOTTOMRIGHT", -(db.right * scale), (db.bottom * scale))
		checkOverlay()
	elseif opt == "overlay"
	or opt == "colour"
	then
		checkOverlay()
	elseif opt == "shown" and not db.shown
	then
		_G.WorldFrame:ClearAllPoints()
		_G.WorldFrame:SetPoint("TOPLEFT")
		_G.WorldFrame:SetPoint("BOTTOMRIGHT")
		checkOverlay()
	end

end

function module:GetOptions()

	local options = {
		type = "group",
		order = 1,
		name = aObj.L["View Port"],
		desc = aObj.L["Change the ViewPort settings"],
		get = function(info) return module.db.profile[info[#info]] end,
		set = function(info, value)
			if not module:IsEnabled() then module:Enable() end
			module.db.profile.shown = true -- always enable if any option is changed
			module.db.profile[info[#info]] = value
			module:adjustViewPort(info[#info])
		end,
		args = {
			shown = {
				type = "toggle",
				order = 1,
				width = "full",
				name = aObj.L["ViewPort Show"],
				desc = aObj.L["Toggle the ViewPort"],
			},
			top = {
				type = "range",
				order = 4,
				name = aObj.L["VP Top"],
				desc = aObj.L["Change Height of the Top Band"],
				min = 0, max = 256, step = 1,
			},
			bottom = {
				type = "range",
				order = 5,
				name = aObj.L["VP Bottom"],
				desc = aObj.L["Change Height of the Bottom Band"],
				min = 0, max = 256, step = 1,
			},
			left = {
				type = "range",
				order = 6,
				name = aObj.L["VP Left"],
				desc = aObj.L["Change Width of the Left Band"],
				min = 0, max = 1800, step = 1,
			},
			right = {
				type = "range",
				order = 7,
				name = aObj.L["VP Right"],
				desc = aObj.L["Change Width of the Right Band"],
				min = 0, max = 1800, step = 1,
			},
			overlay = {
				type = "toggle",
				order = 2,
				name = aObj.L["ViewPort Overlay"],
				desc = aObj.L["Toggle the ViewPort Overlay"],
			},
			colour = {
				type = "color",
				order = 3,
				width = "double",
				name = aObj.L["ViewPort Colour"],
				desc = aObj.L["Set ViewPort Colour"],
				hasAlpha = true,
				get = function(info)
					local c = module.db.profile[info[#info]]
					return c.r, c.g, c.b, c.a
				end,
				set = function(info, r, g, b, a)
					local c = module.db.profile[info[#info]]
					c.r, c.g, c.b, c.a = r, g, b, a
					module.db.profile.shown = true -- enable viewport
					module.db.profile.overlay = true -- enable overlay
					module:adjustViewPort("colour")
				end,
			},
		}
	}
	return options

end
