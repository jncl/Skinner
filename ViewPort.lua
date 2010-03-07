local Skinner = LibStub("AceAddon-3.0"):GetAddon("Skinner")
local module = Skinner:NewModule("ViewPort")

local defaults = {
	profile = {
		shown = false,
		overlay = false,
		top = 64,
		bottom = 64,
		left = 128,
		right = 128,
		colour = {r = 0, g = 0,	b = 0, a = 1},
		XRes = 768,
		YRes = 1050,
	}
}
function module:OnInitialize()

--	print("VP OnInitialize")
	self.db = Skinner.db:RegisterNamespace("ViewPort", defaults)

end

function module:OnEnable()

--	print("VP OnEnable", self.db.profile.shown)
	if self.db.profile.shown then self:adjustViewPort("init") end

end

local vpOverlay
local function checkOverlay(db)

	print("VP checkOverlay", db.overlay, vpOverlay, db.colour.r, db.colour.g, db.colour.b, db.colour.a)
	if db.overlay then
		vpOverlay = vpOverlay or WorldFrame:CreateTexture(nil, "BACKGROUND")
		vpOverlay:SetTexture(db.colour.r, db.colour.g, db.colour.b, db.colour.a)
--		vpOverlay:SetAllPoints("UIParent")
		vpOverlay:SetPoint("TOPLEFT", UIParent, -1, 1)
		vpOverlay:SetPoint("BOTTOMRIGHT", UIParent, 1, -1)
	elseif vpOverlay then
		vpOverlay = nil
	end
	
end
function module:adjustViewPort(opt)

	print("VP adjustViewPort", opt)
	Spew("vp", self.db.profile)

	local db = self.db.profile
	local xScale = db.XRes / 1050
	local yScale = 768 / db.YRes
	local c = db.colour
	
	if (opt == "init" and db.shown)
	or (opt == "shown" and db.shown)
	or (opt == "left" and db.shown)
	or (opt == "right" and db.shown)
	or (opt == "XRes" and db.shown)
	or (opt == "YRes" and db.shown)
	then
		WorldFrame:SetPoint("TOPLEFT", (db.left * xScale), -(db.top * yScale))
		WorldFrame:SetPoint("BOTTOMRIGHT", -(db.right * xScale), (db.bottom * yScale))
		checkOverlay(db)
	elseif opt == "overlay"
	or opt == "colour"
	then
		checkOverlay(db)
	elseif opt == "top" then
		WorldFrame:SetPoint("TOPLEFT", (db.left * xScale), -(db.top * yScale))
		WorldFrame:SetPoint("TOPRIGHT", -(db.right * xScale), -(db.top * yScale))
	elseif opt == "bottom" then
		WorldFrame:SetPoint("BOTTOMLEFT", (db.left * xScale), (db.bottom * yScale))
		WorldFrame:SetPoint("BOTTOMRIGHT", -(db.right * xScale), (db.bottom * yScale))
	elseif opt == "shown" and not db.shown
	then
		WorldFrame:ClearAllPoints()
		WorldFrame:SetPoint("TOPLEFT")
		WorldFrame:SetPoint("BOTTOMRIGHT")
	end

end


function module:GetOptions()

	local options = {
		type = "group",
		order = 1,
		name = Skinner.L["View Port"],
		desc = Skinner.L["Change the ViewPort settings"],
		get = function(info) return module.db.profile[info[#info]] end,
		set = function(info, value) module.db.profile[info[#info]] = value
			module:adjustViewPort(info[#info])
		end,
		args = {
			shown = {
				type = "toggle",
				order = 1,
				width = "full",
				name = Skinner.L["ViewPort Show"],
				desc = Skinner.L["Toggle the ViewPort"],
			},
			top = {
				type = "range",
				order = 4,
				name = Skinner.L["VP Top"],
				desc = Skinner.L["Change Height of the Top Band"],
				min = 0, max = 256, step = 1,
			},
			bottom = {
				type = "range",
				order = 5,
				name = Skinner.L["VP Bottom"],
				desc = Skinner.L["Change Height of the Bottom Band"],
				min = 0, max = 256, step = 1,
			},
			left = {
				type = "range",
				order = 6,
				name = Skinner.L["VP Left"],
				desc = Skinner.L["Change Width of the Left Band"],
				min = 0, max = 1800, step = 1,
			},
			right = {
				type = "range",
				order = 7,
				name = Skinner.L["VP Right"],
				desc = Skinner.L["Change Width of the Right Band"],
				min = 0, max = 1800, step = 1,
			},
			XRes = {
				type = "range",
				order = 8,
				name = Skinner.L["VP XResolution"],
				desc = Skinner.L["Change X Resolution"],
				min = 0, max = 1600, step = 2,
			},
			YRes = {
				type = "range",
				order = 9,
				name = Skinner.L["VP YResolution"],
				desc = Skinner.L["Change Y Resolution"],
				min = 0, max = maxwidth, step = 2,
			},
			overlay = {
				type = "toggle",
				order = 2,
				name = Skinner.L["ViewPort Overlay"],
				desc = Skinner.L["Toggle the ViewPort Overlay"],
			},
			colour = {
				type = "color",
				order = 3,
				width = "double",
				name = Skinner.L["ViewPort Colors"],
				desc = Skinner.L["Set ViewPort Colors"],
				hasAlpha = true,
				get = function(info)
					local c = module.db.profile[info[#info]]
					return c.r, c.g, c.b, c.a
				end,
				set = function(info, r, g, b, a)
					local c = module.db.profile[info[#info]]
					c.r, c.g, c.b, c.a = r, g, b, a
					module.db.profile.overlay = true
					module:adjustViewPort("colour")
				end,
			},
		}
	}
	return options
	
end
