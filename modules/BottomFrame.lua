local _, aObj = ...

local _G = _G

local ftype = "s"

local module = aObj:NewModule("BottomFrame")

local db
local defaults = {
	profile = {
		shown = false,
		height = 200,
		width = 1920,
		fheight = 200,
		fixedfh = false,
		xyOff = true,
		borderOff = false,
		alpha = 0.9,
		invert = false,
		rotate = false,
	}
}

function module:OnInitialize()

	self.db = aObj.db:RegisterNamespace("BottomFrame", defaults)
	db = self.db.profile

	-- convert any old settings
	if aObj.db.profile.BottomFrame then
		for k, v in _G.pairs(aObj.db.profile.BottomFrame) do
			db[k] = v
		end
		aObj.db.profile.BottomFrame = nil
	end

	if not db.shown then self:Disable() end -- disable ourself

end

function module:OnEnable()

	if db.shown then self:adjustBottomFrame() end

end

local btmframe
function module:adjustBottomFrame()

	if db.shown then
		btmframe = btmframe or _G.CreateFrame("Frame", nil, _G.UIParent)
		btmframe:SetFrameStrata("BACKGROUND")
		btmframe:SetFrameLevel(0)
		btmframe:EnableMouse(false)
		btmframe:SetMovable(false)
		btmframe:SetSize(db.width, db.height)
		btmframe:ClearAllPoints()
		if db.xyOff or db.borderOff then
			btmframe:SetPoint("BOTTOMLEFT", _G.UIParent, "BOTTOMLEFT", -6, -6)
		else
			btmframe:SetPoint("BOTTOMLEFT", _G.UIParent, "BOTTOMLEFT", -3, -3)
		end
		-- set the fade height
		local fh = nil
		if not aObj.db.profile.FadeHeight.enable
		and db.fixedfh
		then
			fh = db.fheight <= _G.Round(btmframe:GetHeight()) and db.fheight or _G.Round(btmframe:GetHeight())
		end
		aObj:skinObject("skin", {obj=btmframe, fType=ftype, bba=db.borderOff and 0 or 1, ba=db.alpha, fh=fh, invert=db.invert or nil, rotate=db.rotate or nil})
		btmframe:Show()
	elseif btmframe then
		btmframe:Hide()
	end

end

function module:GetOptions()

	local options = {
		type = "group",
		order = 4,
		name = aObj.L["Bottom Frame"],
		get = function(info) return module.db.profile[info[#info]] end,
		set = function(info, value)
			if not module:IsEnabled() then module:Enable() end
			module.db.profile.shown = true -- always enable if any option is changed
			module.db.profile[info[#info]] = value
			module:adjustBottomFrame()
		end,
		args = {
			shown = {
				type = "toggle",
				order = 1,
				name = aObj.L["BottomFrame Show"],
			},
			height = {
				type = "range",
				order = 6,
				name = aObj.L["BF Height"],
				min = 0, max = 500, step = 1,
			},
			width = {
				type = "range",
				order = 7,
				name = aObj.L["BF Width"],
				min = 0, max = 2600, step = 1,
			},
			fheight = {
				type = "range",
				order = 9,
				name = aObj.L["BF Fade Height"],
				min = 0, max = 500, step = 1,
			},
			fixedfh = {
				type = "toggle",
				order = 10,
				name = aObj.L["Fixed Fade Height"],
			},
			xyOff = {
				type = "toggle",
				order = 2,
				width = "double",
				name = aObj.L["BF Move Origin offscreen"],
			},
			borderOff = {
				type = "toggle",
				order = 3,
				name = aObj.L["BF Toggle Border"],
			},
			alpha = {
				type = "range",
				order = 8,
				name = aObj.L["BF Alpha"],
				min = 0, max = 1, step = 0.1,
			},
			invert = {
				type = "toggle",
				order = 4,
				name = aObj.L["BF Invert Gradient"],
			},
			rotate = {
				type = "toggle",
				order = 5,
				name = aObj.L["BF Rotate Gradient"],
			},
		},
	}
	return options

end
