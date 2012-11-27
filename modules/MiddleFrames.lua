local aName, aObj = ...
local _G = _G
local module = aObj:NewModule("MiddleFrames")
local ftype = "s"

local db
local defaults = {
	profile = {
		fheight = 100,
		fixedfh = false,
		borderOff = false,
		lock = false,
		colour = {r = 0, g = 0, b = 0, a = 0.9},
	}
}
local MAX_MIDDLEFRAMES = 9
for i = 1, MAX_MIDDLEFRAMES do
	defaults.profile["mf" .. i] = {shown = false, height = 100, width = 100, xOfs = -400, yOfs = 400, flevel = 0, fstrata = "BACKGROUND"}
end

local function OnMouseDown(self, mBtn)

	if mBtn == "LeftButton" and _G.IsAltKeyDown() then
		self.isMoving = true
		self:StartMoving()
		self:Raise()
	end

	if mBtn == "LeftButton" and _G.IsControlKeyDown() then
		self.isMoving = true
		self:StartSizing("BOTTOMRIGHT")
		self:Raise()
	end

end
local function OnMouseUp(self, mBtn)

	if mBtn == "LeftButton" then
		if self.isMoving then
			self:StopMovingOrSizing()
			self.isMoving = nil
			self:Lower()
			local x, y = self:GetCenter()
			local px, py = self:GetParent():GetCenter()
			self.db[self.key].xOfs = x - px
			self.db[self.key].yOfs = y - py
			self.db[self.key].width = aObj:getInt(self:GetWidth())
			self.db[self.key].height = aObj:getInt(self:GetHeight())
			aObj:applyGradient(self)
		end
	end

end
local function OnHide(self)

	if self.isMoving then
		self:StopMovingOrSizing()
		self.isMoving = nil
	end

end
local function OnEnter(self)

	_G.GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
	_G.GameTooltip:AddLine(aObj.L[self.name])
	_G.GameTooltip:AddLine(aObj.L["Alt-Drag to move"], 1, 1, 1)
	_G.GameTooltip:AddLine(aObj.L["Ctrl-Drag to resize"], 1, 1, 1)
	_G.GameTooltip:Show()

end
local function OnLeave(self)

	_G.GameTooltip:Hide()

end
local frames = {}
local function adjustFrame(key)

	if db[key].shown then
		local frame = frames[key] or _G.CreateFrame("Frame", db.name and aName .. "MF" .. key:sub(-1) or nil, _G.UIParent)
		frame.db = db
		frame.key = key
		frame.name = db.name and aName .. "MF" .. key:sub(-1) or "Middle Frame" .. key:sub(-1)
		frame:SetFrameStrata(db[key].fstrata)
		frame:SetFrameLevel(db[key].flevel)
		frame:SetMovable(true)
		frame:SetResizable(true)
		frame:SetWidth(db[key].width)
		frame:SetHeight(db[key].height)
		frame:SetPoint("CENTER", _G.UIParent, "CENTER", db[key].xOfs, db[key].yOfs)
		frame:RegisterForDrag("LeftButtonUp")
		 -- set scripts here as IsMouseEnabled is set to true by them (patch 4.0.1)
		frame:SetScript("OnMouseUp", OnMouseUp)
		frame:SetScript("OnHide", OnHide)
		frame:SetScript("OnEnter", OnEnter)
		frame:SetScript("OnLeave", OnLeave)
		if db.lock then
			frame:SetScript("OnMouseDown", function() end)
			frame:EnableMouse(false)
		else
			frame:SetScript("OnMouseDown", OnMouseDown)
			frame:EnableMouse(true)
		end
		-- set the fade height
		local fh = nil
		if not aObj.db.profile.FadeHeight.enable
		and db.fixedfh
		then
			fh = db.fheight <= aObj:getInt(frame:GetHeight()) and db.fheight or aObj:getInt(frame:GetHeight())
		end
		aObj:applySkin{obj=frame, ftype=ftype, bba=db.borderOff and 0 or 1, fh=fh}
		frame:SetBackdropColor(db.colour.r, db.colour.g, db.colour.b, db.colour.a)
		frame:Show()
		frames[key] = frame
	elseif frames[key] then
		frames[key]:Hide()
	end

end

function module:OnInitialize()

	self.db = aObj.db:RegisterNamespace("MiddleFrames", defaults)
	db = self.db.profile

	-- convert any old settings
	if aObj.db.profile.MiddleFrame then
		for k, v in _G.pairs(aObj.db.profile.MiddleFrame) do
			db[k] = v
		end
		aObj.db.profile.MiddleFrame = nil
	end
	for i = 1, MAX_MIDDLEFRAMES do
		if aObj.db.profile["MiddleFrame" .. i] then
			for k, v in _G.pairs(aObj.db.profile["MiddleFrame" .. i]) do
				db["mf" .. i][k] = v
			end
			aObj.db.profile["MiddleFrame" .. i] = nil
		end
	end

	local enable
	for i = 1, MAX_MIDDLEFRAMES do
		if db["mf" .. i].shown then
			enable = true
			break
		end
	end
	if not enable then self:Disable() end -- disable ourself

end

function module:OnEnable()

	self:adjustMiddleFrames("init")

end

function module:adjustMiddleFrames(opt, key)

	if not key then
		for i = 1, MAX_MIDDLEFRAMES do
			local key = "mf" .. i
			adjustFrame(key)
		end
	else
		adjustFrame(key)
	end

end

function module:GetOptions()

	local options = {
		type = "group",
		order = 3,
		name = aObj.L["Middle Frame(s)"],
		desc = aObj.L["Change the MiddleFrame(s) settings"],
		get = function(info) return module.db.profile[info[#info]]	end,
		set = function(info, value)
			if not module:IsEnabled() then module:Enable() end
			module.db.profile[info[#info]] = value
			module:adjustMiddleFrames(info[#info])
		end,
		args = {
			fheight = {
				type = "range",
				name = aObj.L["MF Fade Height"],
				desc = aObj.L["Change the Height of the Fade Effect"],
				min = 0, max = 500, step = 1,
			},
			fixedfh = {
				type = "toggle",
				name = aObj.L["Fixed Fade Height"],
				desc = aObj.L["Fix the Height of the Fade Effect"],
			},
			borderOff = {
				type = "toggle",
				name = aObj.L["MF Toggle Border"],
				desc = aObj.L["Toggle the Border"],
			},
			colour = {
				type = "color",
				name = aObj.L["MF Colour"],
				desc = aObj.L["Change the Colour of the MiddleFrame(s)"],
				hasAlpha = true,
				get = function(info)
					local c = module.db.profile[info[#info]]
					return c.r, c.g, c.b, c.a
				end,
				set = function(info, r, g, b, a)
					if not module:IsEnabled() then module:Enable() end
					local c = module.db.profile[info[#info]]
					c.r, c.g, c.b, c.a = r, g, b, a
					module:adjustMiddleFrames("colour")
				end,
			},
			lock = {
				type = "toggle",
				order = 1,
				name = aObj.L["MF Lock Frames"],
				desc = aObj.L["Toggle the Frame Lock"],
			},
			name = {
				type = "toggle",
				name = aObj.L["MF Names"],
				desc = aObj.L["Toggle the Frame Name(s)"],
			},
		},
	}

	local FrameStrata = {
		BACKGROUND = "Background",
		LOW = "Low",
		MEDIUM = "Medium",
		HIGH = "High",
		DIALOG = "Dialog",
		FULLSCREEN = "Fullscreen",
		FULLSCREEN_DIALOG = "Fullscreen_Dialog",
		TOOLTIP = "Tooltip",
	}

	-- setup middleframe(s) options
	for i = 1, MAX_MIDDLEFRAMES do
		local mfkey = {}
		mfkey.type = "group"
		mfkey.inline = true
		mfkey.name = aObj.L["Middle Frame" .. i]
		mfkey.desc = aObj.L["Change MiddleFrame" .. i .. " settings"]
		mfkey.get = function(info)
			return module.db.profile[info[#info - 1]][info[#info]]
		end
		mfkey.set = function(info, value)
			if not module:IsEnabled() then module:Enable() end
			module.db.profile[info[#info - 1]].shown = true -- always enable if any option is changed
			module.db.profile[info[#info - 1]][info[#info]] = value
			module:adjustMiddleFrames(info[#info], info[#info - 1])
		end
		mfkey.args = {}
		mfkey.args.shown = {}
		mfkey.args.shown.type = "toggle"
		mfkey.args.shown.order = 1
		mfkey.args.shown.name = aObj.L["MiddleFrame" .. i .. " Show"]
		mfkey.args.shown.desc = aObj.L["Toggle the MiddleFrame" .. i]
		mfkey.args.flevel = {}
		mfkey.args.flevel.type = "range"
		mfkey.args.flevel.name = aObj.L["MF" .. i .. " Frame Level"]
		mfkey.args.flevel.desc = aObj.L["Change the MF" .. i .. " Frame Level"]
		mfkey.args.flevel.min = 0
		mfkey.args.flevel.max = 20
		mfkey.args.flevel.step = 1
		mfkey.args.fstrata = {}
		mfkey.args.fstrata.type = "select"
		mfkey.args.fstrata.name = aObj.L["MF" .. i .. " Frame Strata"]
		mfkey.args.fstrata.desc = aObj.L["Change the MF" .. i .. " Frame Strata"]
		mfkey.args.fstrata.values = FrameStrata
		options.args["mf" .. i] = mfkey
	end

	return options

end
