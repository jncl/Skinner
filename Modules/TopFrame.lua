local _, aObj = ...

local _G = _G

local ftype = "s"

local module = aObj:NewModule("TopFrame")

local db
local defaults = {
	profile = {
		shown = false,
		height = 64,
		width = 1920,
		fheight = 64,
		fixedfh = false,
		xyOff = true,
		borderOff = false,
		alpha = 0.9,
		invert = false,
		rotate = false,
	}
}

local function adjustTFOffset(dB, reset)

	--	Adjust the UIParent TOP-OFFSET attribute if required
	if dB.shown then
		local topOfs = -dB.height
		local UIPtopOfs = -104
		if topOfs < UIPtopOfs and not reset then
			_G.UIParent:SetAttribute("TOP_OFFSET", topOfs)
		elseif _G.UIParent:GetAttribute("TOP_OFFSET") < UIPtopOfs then
			_G.UIParent:SetAttribute("TOP_OFFSET", UIPtopOfs)
		end
	end

end

function module:OnInitialize()

	self.db = aObj.db:RegisterNamespace("TopFrame", defaults)
	db = self.db.profile

	-- convert any old settings
	if aObj.db.profile.TopFrame then
		for k, v in _G.pairs(aObj.db.profile.TopFrame) do
			db[k] = v
		end
		aObj.db.profile.TopFrame = nil
	end

	if not db.shown then self:Disable() end -- disable ourself

end

function module:OnEnable()

	if db.shown then self:adjustTopFrame() end

end

local topframe
function module:adjustTopFrame()

	if db.shown then
		topframe = topframe or _G.CreateFrame("Frame", nil, _G.UIParent)
		topframe:SetFrameStrata("BACKGROUND")
		topframe:SetFrameLevel(0)
		topframe:EnableMouse(false)
		topframe:SetMovable(false)
		topframe:SetSize(db.width, db.height)
		topframe:ClearAllPoints()
		if db.xyOff or db.borderOff then
			topframe:SetPoint("TOPLEFT", _G.UIParent, "TOPLEFT", -6, 6)
		else
			topframe:SetPoint("TOPLEFT", _G.UIParent, "TOPLEFT", -3, 3)
		end
		-- set the fade height
		local fh = nil
		if not aObj.db.profile.FadeHeight.enable
		and db.fixedfh
		then
			fh = db.fheight <= aObj:getInt(topframe:GetHeight()) and db.fheight or aObj:getInt(topframe:GetHeight())
		end
		aObj:skinObject("skin", {obj=topframe, fType=ftype, bba=db.borderOff and 0 or 1, ba=db.alpha, fh=fh, invert=db.invert or nil, rotate=db.rotate or nil})
		-- adjust the TopFrame offset
		adjustTFOffset(db)
		topframe:Show()
	elseif topframe then
		topframe:Hide()
	end

end

function module:GetOptions()

	local options = {
		type = "group",
		order = 2,
		name = aObj.L["Top Frame"],
		get = function(info) return module.db.profile[info[#info]] end,
		set = function(info, value)
			if not module:IsEnabled() then module:Enable() end
			module.db.profile.shown = true -- always enable if any option is changed
			module.db.profile[info[#info]] = value
			module:adjustTopFrame()
		end,
		args = {
			shown = {
				type = "toggle",
				order = 1,
				name = aObj.L["Show"],
			},
			height = {
				type = "range",
				order = 6,
				name = aObj.L["Height"],
				min = 0, max = 500, step = 1,
			},
			width = {
				type = "range",
				order = 7,
				name = aObj.L["Width"],
				min = 0, max = 2600, step = 1,
			},
			fheight = {
				type = "range",
				order = 9,
				name = aObj.L["Fade Height"],
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
				name = aObj.L["Move Origin offscreen"],
				desc = aObj.L["Hide Border on Left and Top"],
			},
			borderOff = {
				type = "toggle",
				order = 3,
				name = aObj.L["Toggle Border"],
			},
			alpha = {
				type = "range",
				order = 8,
				name = aObj.L["Alpha"],
				min = 0, max = 1, step = 0.1,
			},
			invert = {
				type = "toggle",
				order = 4,
				name = aObj.L["Invert Gradient"],
			},
			rotate = {
				type = "toggle",
				order = 5,
				name = aObj.L["Rotate Gradient"],
			},
		},
	}
	return options

end
