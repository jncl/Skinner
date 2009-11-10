-- check to see if LibStub is loaded
assert(LibStub, "Skinner requires LibStub")
assert(LibStub:GetLibrary("CallbackHandler-1.0", true), "Skinner requires CallbackHandler-1.0")
-- check to see if AceAddon-3.0 is loaded
assert(LibStub:GetLibrary("AceAddon-3.0", true), "Skinner requires AceAddon-3.0")
-- create the addon
Skinner = LibStub("AceAddon-3.0"):NewAddon("Skinner", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")
-- check to see if we were created successfully
assert(Skinner, "Skinner creation failed, missing Libraries")

-- specify where debug messages go
Skinner.debugFrame = ChatFrame7

-- Get Locale
assert(LibStub:GetLibrary("AceLocale-3.0", true), "Skinner requires AceLocale-3.0")
Skinner.L = LibStub("AceLocale-3.0"):GetLocale("Skinner")

-- check to see if LibSharedMedia-3.0 is loaded
assert(LibStub:GetLibrary("LibSharedMedia-3.0", true), "Skinner requires LibSharedMedia-3.0")
Skinner.LSM = LibStub("LibSharedMedia-3.0")

--check to see if running on PTR
Skinner.isPTR = FeedbackUI and true or false
--check to see if running on patch 0.3.0
Skinner.isPatch = QuestInfoFrame and true or false
-- store player class
Skinner.uCls = select(2, UnitClass("player"))
-- store player name
Skinner.uName = UnitName("player")

-- local defs (for speed)
local _G = _G
local assert = assert
local ceil = math.ceil
local floor = math.floor
local geterrorhandler = geterrorhandler
local ipairs = ipairs
local pairs = pairs
local pcall = pcall
local rawget = rawget
local select = select
local strfind = string.find
local tcon = table.concat
local tinsert = table.insert
local tonumber = tonumber
local tostring = tostring
local type = type
local unpack = unpack
local xpcall = xpcall
local CreateFrame = CreateFrame
local LowerFrameLevel = LowerFrameLevel
local RaiseFrameLevel = RaiseFrameLevel
local IsAddOnLoaded = IsAddOnLoaded
local IsAddOnLoadOnDemand = IsAddOnLoadOnDemand
local EnumerateFrames = EnumerateFrames
local Model_RotateLeft = Model_RotateLeft
local Model_RotateRight = Model_RotateRight
local PanelTemplates_TabResize = PanelTemplates_TabResize
local GetCVarBool = GetCVarBool

local function makeString(t)

	if type(t) == "table" then
		if type(rawget(t, 0)) == "userdata" and type(t.GetObjectType) == "function" then
			return ("<%s:%s>"):format(t:GetObjectType(), t:GetName() or "(Anon)")
		end
	end

	return tostring(t)

end

local function makeText(a1, ...)

	local tmpTab = {}
	local output = ""

	if a1:find("%%") and select('#', ...) >= 1 then
		for i = 1, select('#', ...) do
			tmpTab[i] = makeString(select(i, ...))
		end
		output = output .. " " .. a1:format(unpack(tmpTab))
	else
		tmpTab[1] = output
		tmpTab[2] = a1
		for i = 1, select('#', ...) do
			tmpTab[i+2] = makeString(select(i, ...))
		end
		output = tcon(tmpTab, " ")
	end

	return output

end

local function print(text, frame, r, g, b)

	(frame or DEFAULT_CHAT_FRAME):AddMessage(text, r, g, b, 1, 5)

end

function Skinner:OnInitialize()
--	self:Debug("OnInitialize")

--@debug@
	self:Print("Debugging is enabled")
	self:Debug("Debugging is enabled")
--@end-debug@

--@alpha@
	if self.isPTR then self:Debug("PTR detected") end
	if self.isPatch then self:Debug("Patch detected") end
--@end-alpha@

	-- setup the default DB values and register them
	self:Defaults()
	-- setup the Addon's options
	self:Options()

	-- change the TrackerFrame SV from a boolean to a table
	if type(self.db.profile.TrackerFrame) == "boolean" then
		self.db.profile.TrackerFrame = {skin = true, clean = true, glazesb = true}
	end
	-- remove TooltipBorder alpha value, not required anymore
	if self.db.profile.TooltipBorder.a then self.db.profile.TooltipBorder.a = nil end
	-- change the QuestLog SV from a table into a boolean
	if type(self.db.profile.QuestLog) == "table" then
		self.db.profile.QuestLog = self.db.profile.QuestLog.skin
	end

	-- register the default background texture
	self.LSM:Register("background", "Blizzard ChatFrame Background", [[Interface\ChatFrame\ChatFrameBackground]])
	-- register the inactive tab texture
	self.LSM:Register("background", "Inactive Tab", [[Interface\AddOns\Skinner\textures\inactive]])
	-- register the texture used for EditBoxes & ScrollBars
	self.LSM:Register("border", "Skinner Border", [[Interface\AddOns\Skinner\textures\krsnik]])

	-- Heading and Body Text colours
	local c = self.db.profile.HeadText
	self.HTr, self.HTg, self.HTb = c.r, c.g, c.b
	local c = self.db.profile.BodyText
	self.BTr, self.BTg, self.BTb = c.r, c.g, c.b

	-- Frame multipliers
	self.FxMult, self.FyMult = 0.9, 0.87
	-- Frame Tab multipliers
	self.FTxMult, self.FTyMult = 0.5, 0.75
	-- EditBox regions to keep
	self.ebRegions = {1, 2, 3, 4, 5} -- 1 is text, 2-5 are textures

	-- Gradient settings
	local c = self.db.profile.GradientMin
	self.MinR, self.MinG, self.MinB, self.MinA = c.r, c.g, c.b, c.a
	local c = self.db.profile.GradientMax
	self.MaxR, self.MaxG, self.MaxB, self.MaxA = c.r, c.g, c.b, c.a
	local orientation = self.db.profile.Gradient.rotate and "HORIZONTAL" or "VERTICAL"
	self.gradientOn = self.db.profile.Gradient.invert and {orientation, self.MaxR, self.MaxG, self.MaxB, self.MaxA, self.MinR, self.MinG, self.MinB, self.MinA} or {orientation, self.MinR, self.MinG, self.MinB, self.MinA, self.MaxR, self.MaxG, self.MaxB, self.MaxA}
	self.gradientOff = {orientation, 0, 0, 0, 1, 0, 0, 0, 1}
	self.gradientTab = {orientation, .5, .5, .5, 1, .25, .25, .25, 0}
	self.gradientCBar = {orientation, .25, .25, .55, 1, 0, 0, 0, 1}
	self.gradientTexture = self.LSM:Fetch("background", self.db.profile.Gradient.texture)

	-- backdrop for Frames etc
	local bdtex = self.LSM:Fetch("background", "Blizzard ChatFrame Background")
	local bdbtex = self.LSM:Fetch("border", "Blizzard Tooltip")
	if self.db.profile.BdDefault then
		self.backdrop = {
			bgFile = bdtex, tile = true, tileSize = 16,
			edgeFile = bdbtex, edgeSize = 16,
			insets = {left = 4, right = 4, top = 4, bottom = 4},
		}
	else
		if self.db.profile.BdFile and self.db.profile.BdFile ~= "None" then
			bdtex = self.db.profile.BdFile
		else
			bdtex = self.LSM:Fetch("background", self.db.profile.BdTexture)
		end
		if self.db.profile.BdEdgeFile and self.db.profile.BdEdgeFile ~= "None" then
			bdbtex = self.db.profile.BdEdgeFile
		else
			bdbtex = self.LSM:Fetch("border", self.db.profile.BdBorderTexture)
		end
		local bdi = self.db.profile.BdInset
		local bdt = self.db.profile.BdTileSize > 0 and true or false
		self.backdrop = {
			bgFile = bdtex, tile = bdt, tileSize = self.db.profile.BdTileSize,
			edgeFile = bdbtex, edgeSize = self.db.profile.BdEdgeSize,
			insets = {left = bdi, right = bdi, top = bdi, bottom = bdi},
		}
	end
	self.Backdrop = {}
	self.Backdrop[1] = self.backdrop
	-- backdrop for ScrollBars & EditBoxes
	local edgetex = self.LSM:Fetch("border", "Skinner Border")
	-- wide backdrop for ScrollBars (16,16,4)
	self.Backdrop[2] = {
		bgFile = bdtex, tile = true, tileSize = 16,
		edgeFile = edgetex, edgeSize = 16,
		insets = {left = 4, right = 4, top = 4, bottom = 4},
	}
	-- medium backdrop for ScrollBars (12,12,3)
	self.Backdrop[3] = {
		bgFile = bdtex, tile = true, tileSize = 12,
		edgeFile = edgetex, edgeSize = 12,
		insets = {left = 3, right = 3, top = 3, bottom = 3},
	}
	-- narrow backdrop for ScrollBars (8,8,2)
	self.Backdrop[4] = {
		bgFile = bdtex, tile = true, tileSize = 8,
		edgeFile = edgetex, edgeSize = 8,
		insets = {left = 2, right = 2, top = 2, bottom = 2},
	}
	-- these backdrops are for small UI buttons, e.g. minus/plus in QuestLog/IOP/Skills etc
	self.Backdrop[5] = CopyTable(self.backdrop)
	self.Backdrop[5].tileSize = 12
	self.Backdrop[5].edgeSize = 12
	self.Backdrop[5].insets = {left = 3, right = 3, top = 3, bottom = 3}
	self.Backdrop[6] = CopyTable(self.backdrop)
	self.Backdrop[6].tileSize = 10
	self.Backdrop[6].edgeSize = 10
	self.Backdrop[6].insets = {left = 3, right = 3, top = 3, bottom = 3}

	-- these are used to disable frames from being skinned
	self.charKeys1 = {"CharacterFrames", "PVPFrame", "PetStableFrame", "SpellBookFrame", "TalentUI", "DressUpFrame", "FriendsFrame", "TradeSkillUI", "TradeFrame", "RaidUI", "ReadyCheck", "Buffs", "AchieveFrame", "AchieveAlert", "VehicleMenuBar", "GearManager"}
	self.charKeys2 = {"QuestLog", "TrackerFrame"}
	self.npcKeys = {"MerchantFrames", "GossipFrame", "TrainerUI", "TaxiFrame", "QuestFrame", "Battlefields", "ArenaFrame", "ArenaRegistrar", "GuildRegistrar", "Petition", "Tabard", "BarbershopUI"}
	self.uiKeys1 = {"StaticPopups", "ChatMenus", "ChatConfig", "ChatTabs", "ChatFrames", "CombatLogQBF", "DebugTools", "LootFrame", "StackSplit", "ItemText", "Colours", "HelpFrame", "Tutorial", "GMSurveyUI", "InspectUI", "BattleScore", "BattlefieldMm", "DropDowns", "MinimapButtons", "MinimapGloss", "TimeManager", "Calendar", "MenuFrames", "BankFrame", "MailFrame", "AuctionUI", "CoinPickup", "LFGFrame", "ItemSocketingUI", "GuildBankUI", "Nameplates", "GMChatUI"}
	if IsMacClient() then tinsert(self.uiKeys1, "MovieProgress") end
	if self.isPTR then tinsert(self.uiKeys1, "Feedback") end
	self.uiKeys2 = {"Tooltips", "MirrorTimers", "CastingBar", "ChatEditBox", "GroupLoot", "ContainerFrames", "WorldMap", "MainMenuBar"}
	-- these are used to disable the gradient
	self.gradFrames = {["c"] = {}, ["u"] = {}, ["n"] = {}, ["s"] = {}}

	-- list of Tooltips to check to see whether we should colour the Tooltip Border or not
	-- use strings as the objects may not exist when we start
	self.ttCheck = {"GameTooltip", "ShoppingTooltip1", "ShoppingTooltip2", "ShoppingTooltip3", "ItemRefTooltip", "ItemRefShoppingTooltip1", "ItemRefShoppingTooltip2", "ItemRefShoppingTooltip3"}
	-- list of Tooltips used when the Tooltip style is 3
	self.ttList = CopyTable(self.ttCheck)
	tinsert(self.ttList, "SmallTextTooltip")
	-- Set the Tooltip Border
	self.ttBorder = true
	-- TooltipBorder colours
	local c = self.db.profile.TooltipBorder
	self.tbColour = {c.r, c.g, c.b, c.a}
	-- StatusBar colours
	local c = self.db.profile.StatusBar
	self.sbColour = {c.r, c.g, c.b, c.a}
	self.sbTexture = self.LSM:Fetch("statusbar", self.db.profile.StatusBar.texture)
	-- Backdrop colours
	local c = self.db.profile.Backdrop
	self.bColour = {c.r, c.g, c.b, c.a}
	-- BackdropBorder colours
	local c = self.db.profile.BackdropBorder
	self.bbColour = {c.r, c.g, c.b, c.a}
	-- Inactive Tab texture
	self.itTex = self.LSM:Fetch("background", "Inactive Tab")

	-- class table
	self.classTable = {"Druid", "Priest", "Paladin", "Hunter", "Rogue", "Shaman", "Mage", "Warlock", "Warrior", "DeathKnight"}

	-- store Addons managed by LoadManagers
	self.lmAddons = {}

	-- table to hold which functions have been actioned
	self.initialized = {}

	-- define a metatable to have weak keys and to automatically add an entry if it doesn't exist
	local mt = {__mode = "k", __index = function (t, k) t[k] = true end}
	-- table to hold objects which have been skinned
	self.skinned = setmetatable({}, mt)

	-- table to hold frames that have been added, with weak keys
	self.skinFrame = setmetatable({}, {__mode = "k"})

	-- table to hold buttons that have been added, with weak keys
	self.sBut = setmetatable({}, {__mode = "k"})

	-- table to hold StatusBars that have been glazed, with weak keys
	self.sbGlazed = setmetatable({}, {__mode = "k"})

	-- shorthand for the TexturedTab profile setting
	self.isTT = self.db.profile.TexturedTab and true or false

end

function Skinner:OnEnable()
--	self:Debug("OnEnable")

	self:RegisterEvent("ADDON_LOADED")
	self:RegisterEvent("AUCTION_HOUSE_SHOW")

	self:ScheduleTimer("BlizzardFrames", self.db.profile.Delay.Init)
	self:ScheduleTimer("SkinnerFrames", self.db.profile.Delay.Init + 0.1)
	self:ScheduleTimer("AddonFrames", self.db.profile.Delay.Init + self.db.profile.Delay.Addons + 0.1)

	-- handle profile changes
	self.db.RegisterCallback(self, "OnProfileChanged", "ReloadAddon")
	self.db.RegisterCallback(self, "OnProfileCopied", "ReloadAddon")
	self.db.RegisterCallback(self, "OnProfileReset", "ReloadAddon")

end

function Skinner:ReloadAddon(callback)
-- 	self:Debug("ReloadAddon:[%s]", callback)

	StaticPopupDialogs["Skinner_Reload_UI"] = {
		text = self.L["Confirm reload of UI to activate profile changes"],
		button1 = OKAY,
		button2 = CANCEL,
		OnAccept = function()
			ReloadUI()
		end,
		OnCancel = function(this, data, reason)
			if reason == "timeout" or reason == "clicked" then
				self:CustomPrint(1, 1, 0, "The profile '"..Skinner.db:GetCurrentProfile().."' will be activated next time you Login or Reload the UI")
			end
		end,
		timeout = 0,
		whileDead = 1,
		exclusive = 1,
		hideOnEscape = 1
	}
	StaticPopup_Show("Skinner_Reload_UI")

end

--@debug@
function Skinner:Debug(a1, ...)

	local output = ("|cff7fff7f(DBG) %s:[%s.%3d]|r"):format("Skinner", date("%H:%M:%S"), (GetTime() % 1) * 1000)

	print(output.." "..makeText(a1, ...), self.debugFrame)

end
--@end-debug@
--[===[@non-debug@
function Skinner:Debug() end
--@end-non-debug@]===]

function Skinner:CustomPrint(r, g, b, a1, ...)

	local output = ("|cffffff78Skinner:|r")

	print(output.." "..makeText(a1, ...), nil, r, g, b)

end

-- Skinning functions
local function __addSkinButton(opts)
--[[
	Calling parameters:
		obj = object (Mandatory)
		parent = object to parent to, default is the object's parent
		hook = object to hook Show/Hide methods, defaults to object
		hide = Hide button skin
		sap = SetAllPoints
		bg = set FrameStrata to "BACKGROUND"
		kfs = Remove all textures, only keep font strings
		aso = applySkin options
		x1 = X offset for TOPLEFT, default -4
		y1 = Y offset for TOPLEFT, default 4
		x2 = X offset for BOTTOMRIGHT, default 4
		y2 = Y offset for BOTTOMRIGHT, default -4
--]]
--@alpha@
	assert(opts.obj, "Unknown object __aSB\n"..debugstack())
--@end-alpha@

	-- remove all textures, if required
	if opts.kfs then Skinner:keepFontStrings(opts.obj) end

	opts.parent = opts.parent or opts.obj:GetParent()
	opts.hook = opts.hook or opts.obj

	local btn = CreateFrame("Button", nil, opts.parent)
	LowerFrameLevel(btn)
	btn:EnableMouse(false) -- allow clickthrough
	Skinner.sBut[opts.hook] = btn
	-- hook Show/Hide methods
	if not Skinner:IsHooked(opts.hook, "Show") then
		Skinner:SecureHook(opts.hook, "Show", function(this) Skinner.sBut[this]:Show() end)
		Skinner:SecureHook(opts.hook, "Hide", function(this) Skinner.sBut[this]:Hide() end)
	end
	-- position the button skin
	if opts.sap then
		btn:SetAllPoints(opts.obj)
	else
		-- setup offset values
		local xOfs1 = opts.x1 or -4
		local yOfs1 = opts.y1 or 4
		local xOfs2 = opts.x2 or 4
		local yOfs2 = opts.y2 or -4
		btn:SetPoint("TOPLEFT", opts.obj, "TOPLEFT", xOfs1, yOfs1)
		btn:SetPoint("BOTTOMRIGHT", opts.obj, "BOTTOMRIGHT", xOfs2, yOfs2)
	end
	-- setup applySkin options
	opts.aso = opts.aso or {}
	opts.aso.obj = btn
	Skinner:applySkin(opts.aso)

	-- hide button skin, if required or not shown
	if opts.hide or not opts.obj:IsShown() then btn:Hide() end

	 -- make sure it's lower than its parent's Frame Strata
	if opts.bg then	btn:SetFrameStrata("BACKGROUND") end

	-- change the draw layer of the Icon and Count, if necessary
	if opts.obj.GetNumRegions then
		for i = 1, opts.obj:GetNumRegions() do
			local reg = select(i, opts.obj:GetRegions())
			local regOT = reg:GetObjectType()
			if regOT == "Texture" or regOT == "FontString" then
				local regName = reg:GetName()
				local regDL = reg:GetDrawLayer()
				local regTex = regOT == "Texture" and reg:GetTexture() or nil
				-- change the DrawLayer to make the Icon show if required
				if (regName and (regName:find("[Ii]con") or regName:find("[Cc]ount")))
				or (regTex and regTex:find("[Ii]con")) then
					if regDL == "BACKGROUND" then reg:SetDrawLayer("ARTWORK") end
				end
			end
		end
	end

end

function Skinner:addSkinButton(...)

	local opts = select(1, ...)

--@alpha@
	assert(opts, "Unknown object aSB\n"..debugstack())
--@end-alpha@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if type(rawget(opts, 0)) == "userdata" and type(opts.GetObjectType) == "function" then
		-- old style call
--		self:addSkinButton_old(...)
		opts = {}
		opts.obj = select(1, ...) and select(1, ...) or nil
		opts.parent = select(2, ...) and select(2, ...) or nil
		opts.hook = select(3, ...) and select(3, ...) or nil
		opts.hide = select(4, ...) and select(4, ...) or nil
--	else
--		-- new style call
	end
	__addSkinButton(opts)

end

local hdrTexNames = {"Header", "_Header", "_HeaderBox", "FrameHeader", "HeaderTexture", "HeaderFrame"}
local function hideHeader(obj)

	-- hide the Header Texture and move the Header text, if required
	for _, htex in pairs(hdrTexNames) do
		local hdr = _G[obj:GetName()..htex]
		if hdr then
			hdr:Hide()
			hdr:SetPoint("TOP", obj, "TOP", 0, 7)
			break
		end
	end

end

local function __addSkinFrame(opts)
--[[
	Calling parameters:
		obj = object (Mandatory)
		ft = Frame Type (Skinner classification)
		kfs = Remove all textures, only keep font strings
		hat = Hide all textures
		hdr = Header Texture to be hidden
		bg = set FrameStrata to "BACKGROUND"
		noBdr = no border
		aso = applySkin options
		x1 = X offset for TOPLEFT
		y1 = Y offset for TOPLEFT
		x2 = X offset for BOTTOMRIGHT
		y2 = Y offset for BOTTOMRIGHT
--]]
--@alpha@
	assert(opts.obj, "Unknown object __aSF\n"..debugstack())
--@end-alpha@

	-- remove the object's Backdrop if it has one
	if opts.obj:GetBackdrop() then opts.obj:SetBackdrop(nil) end

	-- store frame obj, if required
	if opts.ft then tinsert(Skinner.gradFrames[opts.ft], opts.obj) end

	-- remove all textures, if required
	if opts.kfs or opts.hat then Skinner:keepFontStrings(opts.obj, opts.hat) end

	-- setup offset values
	local xOfs1 = opts.x1 or 0
	local yOfs1 = opts.y1 or 0
	local xOfs2 = opts.x2 or 0
	local yOfs2 = opts.y2 or 0

	-- add a frame around the current object
	local skinFrame = CreateFrame("Frame", nil, opts.obj)
	skinFrame:ClearAllPoints()
	if xOfs1 == 0 and yOfs1 == 0 and xOfs2 == 0 and yOfs2 == 0 then
	 	skinFrame:SetAllPoints(opts.obj)
	else
		skinFrame:SetPoint("TOPLEFT", opts.obj, "TOPLEFT", xOfs1, yOfs1)
		skinFrame:SetPoint("BOTTOMRIGHT", opts.obj, "BOTTOMRIGHT", xOfs2, yOfs2)
	end

	-- store reference to the frame
	Skinner.skinFrame[opts.obj] = skinFrame

	-- handle header, if required
	if opts.hdr then hideHeader(opts.obj) end

	-- setup applySkin options
	opts.aso = opts.aso or {}
	opts.aso.obj = skinFrame

	-- handle no Border, if required
	if opts.noBdr then opts.aso.bba = 0	end

	-- skin the frame using supplied options
	Skinner:applySkin(opts.aso)

	-- adjust frame level
	local success, err = pcall(LowerFrameLevel, skinFrame) -- catch any error, doesn't matter if already 0
	if not success then RaiseFrameLevel(opts.obj) end -- raise parent's Frame Level if 0

	 -- make sure it's lower than its parent's Frame Strata
	if opts.bg then	skinFrame:SetFrameStrata("BACKGROUND") end

end

function Skinner:addSkinFrame(...)

	local opts = select(1, ...)

--@alpha@
	assert(opts, "Unknown object aSF\n"..debugstack())
--@end-alpha@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if type(rawget(opts, 0)) == "userdata" and type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = select(1, ...) and select(1, ...) or nil
		opts.x1 = select(2, ...) and select(2, ...) or -3
		opts.y1 = select(3, ...) and select(3, ...) or 3
		opts.x2 = select(4, ...) and select(4, ...) or 3
		opts.y2 = select(5, ...) and select(5, ...) or -3
		opts.ft = select(6, ...) and select(6, ...) or nil
		opts.noBdr = select(7, ...) and select(7, ...) or nil
	end
	__addSkinFrame(opts)

end

function Skinner:applyGradient(frame, fh)

	-- don't apply a gradient if required
	if not self.db.profile.Gradient.char then
		for _, v in pairs(self.gradFrames["c"]) do
			if v == frame then return end
		end
	end
	if not self.db.profile.Gradient.ui then
		for _, v in pairs(self.gradFrames["u"]) do
			if v == frame then return end
		end
	end
	if not self.db.profile.Gradient.npc then
		for _, v in pairs(self.gradFrames["n"]) do
			if v == frame then return end
		end
	end
	if not self.db.profile.Gradient.skinner then
		for _, v in pairs(self.gradFrames["s"]) do
			if v == frame then return end
		end
	end

	if not frame.tfade then frame.tfade = frame:CreateTexture(nil, "BORDER") end
	frame.tfade:SetTexture(self.gradientTexture)

	if self.db.profile.FadeHeight.enable and (self.db.profile.FadeHeight.force or not fh) then
		-- set the Fade Height if not already passed to this function or 'forced'
		-- making sure that it isn't greater than the frame height
		fh = self.db.profile.FadeHeight.value <= ceil(frame:GetHeight()) and self.db.profile.FadeHeight.value or ceil(frame:GetHeight())
	end
--	self:Debug("aG Fade Height: [%s, %s, %s]", frame:GetName(), frame:GetHeight(), fh)

	if self.db.profile.Gradient.invert then
		frame.tfade:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 4, 4)
		if fh then frame.tfade:SetPoint("TOPRIGHT", frame, "BOTTOMRIGHT", -4, -(fh - 4))
		else frame.tfade:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -4, -4) end
	else
		frame.tfade:SetPoint("TOPLEFT", frame, "TOPLEFT", 4, -4)
		if fh then frame.tfade:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", -4, -(fh - 4))
		else frame.tfade:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -4, 4) end
	end

	frame.tfade:SetBlendMode("ADD")
	frame.tfade:SetGradientAlpha(unpack(self.db.profile.Gradient.enable and self.gradientOn or self.gradientOff))

end

local function __applySkin(opts)
--[[
	Calling parameters:
		obj = object (Mandatory)
		ft = Frame Type (Skinner classification)
		kfs = Remove all textures, only keep font strings
		hdr = Header Texture to be hidden
		bba = Backdrop Border Alpha value
		ba = Backdrop Alpha value
		fh = Fade Height
		bd = Backdrop table to use, default is 1
		ng = No Gradient effect
--]]
--@alpha@
	assert(opts.obj, "Unknown object __aS\n"..debugstack())
--@end-alpha@

	local hasIOT = assert(opts.obj.IsObjectType, "The Object passed isn't a Frame") -- throw an error here to get its original location reported
	if hasIOT and not opts.obj:IsObjectType("Frame") then
		if Skinner.db.profile.Errors then
			Skinner:CustomPrint(1, 0, 0, "Error skinning", opts.obj.GetName and opts.obj:GetName() or opts.obj, "not a Frame or subclass of Frame: ", opts.obj:GetObjectType())
			return
		end
	end

	-- store frame obj, if required
	if opts.ft then tinsert(Skinner.gradFrames[opts.ft], opts.obj) end

	-- remove all textures, if required
	if opts.kfs then Skinner:keepFontStrings(opts.obj) end

	-- setup the backdrop
	opts.obj:SetBackdrop(opts.bd or Skinner.Backdrop[1])
	local r, g, b, a = unpack(Skinner.bColour)
	opts.obj:SetBackdropColor(r, g, b, opts.ba or a)
	local r, g, b, a = unpack(Skinner.bbColour)
	opts.obj:SetBackdropBorderColor(r, g, b, opts.bba or a)

	-- handle header, if required
	if opts.hdr then hideHeader(opts.obj) end

	-- apply the 'Skinner' effect
	if not opts.ng then Skinner:applyGradient(opts.obj, opts.fh) end

end

function Skinner:applySkin(...)

	local opts = select(1, ...)

--@alpha@
	assert(opts, "Unknown object aS\n"..debugstack())
--@end-alpha@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if type(rawget(opts, 0)) == "userdata" and type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = select(1, ...) and select(1, ...) or nil
		opts.hdr = select(2, ...) and select(2, ...) or nil
		opts.bba = select(3, ...) and select(3, ...) or nil
		opts.ba = select(4, ...) and select(4, ...) or nil
		opts.fh = select(5, ...) and select(5, ...) or nil
		opts.bd = select(6, ...) and select(6, ...) or nil
	end
	__applySkin(opts)

end

local function __adjHeight(opts)
--[[
	Calling parameters:
		obj = object (Mandatory)
		adj = value to adjust height by
--]]
--@alpha@
	assert(opts.obj, "Unknown object __aH\n"..debugstack())
--@end-alpha@
	if opts.adj == 0 then return end

	if not strfind(tostring(opts.adj), "+") then -- if not negative value
		opts.obj:SetHeight(opts.obj:GetHeight() + opts.adj)
	else
		opts.adj = opts.adj * -1 -- make it positive
		opts.obj:SetHeight(opts.obj:GetHeight() - opts.adj)
	end

end

function Skinner:adjHeight(...)

	local opts = select(1, ...)

--@alpha@
	assert(opts, "Unknown object aH\n"..debugstack())
--@end-alpha@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if type(rawget(opts, 0)) == "userdata" and type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = select(1, ...) and select(1, ...) or nil
		opts.adj = select(2, ...) and select(2, ...) or 0
	end
	__adjHeight(opts)

end

local function errorhandler(err)
	return geterrorhandler()(err)
end

local function safecall(funcName, LoD)
	-- handle errors from internal functions
	local success, err = xpcall(function() return Skinner[funcName](Skinner, LoD) end, errorhandler)
	if not success then
		if Skinner.db.profile.Errors then
			Skinner:CustomPrint(1, 0, 0, "Error running", funcName)
		end
	end
end

function Skinner:checkAndRun(funcName)
--	self:Debug("checkAndRun:[%s]", funcName or "<Anon>")

	if type(self[funcName]) == "function" then
		safecall(funcName)
	else
		if self.db.profile.Warnings then
			self:CustomPrint(1, 0, 0, "function ["..funcName.."] not found in Skinner")
		end
	end

end

function Skinner:checkAndRunAddOn(addonName, LoD, addonFunc)

	if not addonFunc then addonFunc = addonName end

--	self:Debug("checkAndRunAddOn:[%s, %s, %s, %s, %s]", addonName, LoD, IsAddOnLoaded(addonName), IsAddOnLoadOnDemand(addonName), type(self[addonFunc]))

	if not IsAddOnLoaded(addonName) then
		-- deal with Addons under the control of an LoadManager
		if IsAddOnLoadOnDemand(addonName) and not LoD then
--			self:Debug(addonName, "is managed by a LoadManager, converting to LoD status")
			self.lmAddons[addonName] = addonFunc
		-- Nil out loaded Skins for Addons that aren't loaded
		elseif self[addonFunc] then
			self[addonFunc] = nil
--			self:Debug(addonName, "skin unloaded as Addon not loaded")
		end
	else
		-- check to see if AddonSkin is loaded when Addon is loaded
		if not LoD and not self[addonFunc] then
			if self.db.profile.Warnings then
				self:CustomPrint(1, 0, 0, addonName, "loaded but skin not found in the SkinMe directory")
			end
		elseif type(self[addonFunc]) == "function" then
--			self:Debug("checkAndRunAddOn#2:[%s, %s]", addonFunc, self[addonFunc])
			safecall(addonFunc, LoD)
		else
			if self.db.profile.Warnings then
				self:CustomPrint(1, 0, 0, "function ["..addonFunc.."] not found in Skinner")
			end
		end
	end

end

local function __checkTex(opts)
--[[
	Calling parameters:
		obj = object (Mandatory)
		nTex = Texture
		mp2 = minus/plus type 2
--]]
--@alpha@
	assert(opts.obj, "Unknown object __cT\n"..debugstack())
--@end-alpha@

	local nTex = opts.nTex or opts.obj:GetNormalTexture() and opts.obj:GetNormalTexture():GetTexture() or nil
	local btn = opts.mp2 and opts.obj or Skinner.sBut[opts.obj]
	if not btn then return end -- allow for unskinned buttons

--	Skinner:Debug("__checkTex: [%s, %s, %s]", btn:GetName(), nTex, opts.mp2)

	if not opts.mp2 then btn:Show() end

	if nTex then
		if nTex:find("MinusButton") then
			btn:SetText(Skinner.minus)
		elseif nTex:find("PlusButton") then
			btn:SetText(Skinner.plus)
		end
	else -- not a header line
		btn:SetText("")
		if not opts.mp2 then btn:Hide() end
	end

end

function Skinner:checkTex(...)

	local opts = select(1, ...)

--@alpha@
	assert(opts, "Unknown object cT\n"..debugstack())
--@end-alpha@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if type(rawget(opts, 0)) == "userdata" and type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = select(1, ...) and select(1, ...) or nil
		opts.nTex = select(2, ...) and select(2, ...) or nil
		opts.mp2 = select(3, ...) and select(3, ...) or nil
	end
	__checkTex(opts)

end

function Skinner:findFrame(height, width, children)

	local frame
	local obj = EnumerateFrames()

	while obj do

		if obj:IsObjectType("Frame") then
			if obj:GetName() == nil then
				if obj:GetParent() == nil then
--					self:Debug("UnNamed Frame's H, W: [%s, %s]", obj:GetHeight(), obj:GetWidth())
					if ceil(obj:GetHeight()) == height and ceil(obj:GetWidth()) == width then
						local kids = {}
						for i = 1, obj:GetNumChildren() do
							local v = select(i, obj:GetChildren())
--							self:Debug("UnNamed Frame's Children's Type: [%s]", v:GetObjectType())
							kids[i] = v:GetObjectType()
						end
						local matched = 0
						for _, c in pairs(children) do
							for _, k in pairs(kids) do
								if c == k then matched = matched + 1 end
							end
						end
						if matched == #children then
							frame = obj
							break
						end
					end
				end
			end
		end

		obj = EnumerateFrames(obj)
	end

	return frame

end

function Skinner:findFrame2(parent, objType, ...)
--@alpha@
	assert(parent, "Unknown object\n"..debugstack())
--@end-alpha@

	if not parent then return end

--	self:Debug("findFrame2: [%s, %s, %s, %s, %s, %s, %s]", parent, objType, select(1, ...) or nil, select(2, ...) or nil, select(3, ...) or nil, select(4, ...) or nil, select(5, ...) or nil)

	local frame

	for i = 1, parent:GetNumChildren() do
		local obj = select(i, parent:GetChildren())
		if obj:GetName() == nil then
			if obj:IsObjectType(objType) then
				if select("#", ...) > 2 then
					-- base checks on position
					local point, relativeTo, relativePoint, xOfs, yOfs = obj:GetPoint()
					xOfs = ceil(xOfs)
					yOfs = ceil(yOfs)
--					self:Debug("UnNamed Object's Point: [%s, %s, %s, %s, %s]", point, relativeTo, relativePoint, xOfs, yOfs)
					if  point         == select(1, ...)
					and relativeTo    == select(2, ...)
					and relativePoint == select(3, ...)
					and xOfs          == select(4, ...)
					and yOfs          == select(5, ...) then
						frame = obj
						break
					end
				else
					-- base checks on size
					local height, width = ceil(obj:GetHeight()), ceil(obj:GetWidth())
-- 					self:Debug("UnNamed Object's H, W: [%s, %s]", height, width)
					if  height == select(1, ...)
					and width  == select(2, ...) then
						frame = obj
						break
					end
				end
			end
		end
	end

	return frame

end

function Skinner:findFrame3(name, element)
--@alpha@
	assert(name, "Unknown object\n"..debugstack())
--@end-alpha@

--	self:Debug("findFrame3: [%s, %s]", name, element)

	local frame

	local kids = {UIParent:GetChildren()}
	for _, child in ipairs(kids) do
		if child:GetName() == name then
			if child[element] then
				frame = child
				break
			end
		end
	end
	kids = nil

	return frame

end

function Skinner:getChild(obj, childNo)
--@alpha@
	assert(obj, "Unknown object\n"..debugstack())
--@end-alpha@

	local child
	if obj and childNo then child = select(childNo, obj:GetChildren()) end
	return child

end

function Skinner:getRegion(obj, regNo)
--@alpha@
	assert(obj, "Unknown object\n"..debugstack())
--@end-alpha@

	local region
	if obj and regNo then region = select(regNo, obj:GetRegions()) end
	return region

end

local sbBG, sbFS, sbFL
function Skinner:glazeStatusBar(statusBar, fi, texture)
--@alpha@
	assert(statusBar and statusBar:IsObjectType("StatusBar"), "Not a StatusBar\n"..debugstack())
--@end-alpha@

	if not statusBar or not statusBar:IsObjectType("StatusBar") then return end

	statusBar:SetStatusBarTexture(self.sbTexture)
	if not self.sbGlazed[statusBar] then
		self.sbGlazed[statusBar] = {glzd=true}
	end

	if fi then
		if not self.sbGlazed[statusBar].bg then
			if texture then
				sbBG = statusBar:CreateTexture(nil, "BORDER")
				sbBG:SetTexture(self.sbTexture)
				sbBG:SetVertexColor(unpack(self.sbColour))
			else
				sbBG = CreateFrame("StatusBar", nil, statusBar)
				sbFS = statusBar:GetFrameStrata()
				sbBG:SetFrameStrata(sbFS ~= "UNKNOWN" and sbFS or "BACKGROUND")
				sbFL = statusBar:GetFrameLevel()
				sbBG:SetFrameLevel(sbFL > 0 and sbFL - 1 or 0)
				sbBG:SetStatusBarTexture(self.sbTexture)
				sbBG:SetStatusBarColor(unpack(self.sbColour))
			end
			sbBG:SetPoint("TOPLEFT", statusBar, "TOPLEFT", fi, -fi)
			sbBG:SetPoint("BOTTOMRIGHT", statusBar, "BOTTOMRIGHT", -fi, fi)
			self.sbGlazed[statusBar].bg = sbBG
		end
	end

end

function Skinner:isDropDown(obj)
--@alpha@
	assert(obj, "Unknown object\n"..debugstack())
--@end-alpha@

	local objTexName
	if obj:GetName() then objTexName = _G[obj:GetName().."Left"] end

	if obj:IsObjectType("Frame")
	and objTexName
	and objTexName.GetTexture
	and objTexName:GetTexture():find("CharacterCreate") then
		return true
	else
		return false
	end

end

function Skinner:isVersion(addonName, verNoReqd, actualVerNo)
--	self:Debug("isVersion: [%s, %s, %s]", addonName, verNoReqd, actualVerNo)

	local hasMatched = false

	if type(verNoReqd) == "table" then
		for _, v in pairs(verNoReqd) do
			if v == actualVerNo then
				hasMatched = true
				break
			end
		end
	else
		if verNoReqd == actualVerNo then hasMatched = true end
	end

	if not hasMatched and self.db.profile.Warnings then
		local addText = ""
		if type(verNoReqd) ~= "table" then addText = "Version "..verNoReqd.." is required" end
		self:CustomPrint(1, 0.25, 0.25, "Version", actualVerNo, "of", addonName, "is unsupported.", addText)
	end

	return hasMatched

end

function Skinner:keepFontStrings(frame, hide)
--@alpha@
	assert(frame, "Unknown object\n"..debugstack())
--@end-alpha@

	if not frame then return end

--	self:Debug("keepFontStrings: [%s]", frame:GetName() or "???")

	for i = 1, frame:GetNumRegions() do
		local reg = select(i, frame:GetRegions())
		if not reg:IsObjectType("FontString") then
			if not hide then reg:SetAlpha(0) else reg:Hide() end
		end
	end

end

local function revTable(curTab)

	if not curTab then return end
	local revTab = {}

	for _, v in pairs(curTab) do
		revTab[v] = true
	end

	return revTab

end

function Skinner:keepRegions(frame, regions)
--@alpha@
	assert(frame, "Unknown object\n"..debugstack())
--@end-alpha@

	if not frame then return end
	regions	= revTable(regions)

--	self:Debug("keepRegions: [%s]", frame:GetName() or "<Anon>")
	for i = 1, frame:GetNumRegions() do
		local reg = select(i, frame:GetRegions())
		-- if we have a list, hide the regions not in that list
		if regions and not regions[i] then
--			self:Debug("hide region: [%s, %s]", i, reg:GetName() or "<Anon>")
			reg:SetAlpha(0)
--@debug@
			if reg:IsObjectType("FontString") then self:Debug("kr FS: [%s, %s]", frame:GetName() or "<Anon>", i) end
--@end-debug@
		end
	end

end

function Skinner:makeMFRotatable(frame)
--@alpha@
	assert(frame, "Unknown object\n"..debugstack())
--@end-alpha@

	-- Don't make Model Frames Rotatable if CloseUp is loaded
	if IsAddOnLoaded("CloseUp") then return end

	--frame:EnableMouseWheel(true)
	frame:EnableMouse(true)
	frame.draggingDirection = nil
	frame.cursorPosition = {}

	if not self:IsHooked(frame, "OnUpdate") then
		self:SecureHookScript(frame, "OnUpdate", function(...)
			if this.dragging then
				local x,y = GetCursorPosition()
				if this.cursorPosition.x > x then
					Model_RotateLeft(frame, (this.cursorPosition.x - x) * arg1)
				elseif this.cursorPosition.x < x then
					Model_RotateRight(frame, (x - this.cursorPosition.x) * arg1)
				end
				this.cursorPosition.x, this.cursorPosition.y = GetCursorPosition()
			end
		end)
		self:SecureHookScript(frame, "OnMouseDown", function()
			if arg1 == "LeftButton" then
				this.dragging = true
				this.cursorPosition.x, this.cursorPosition.y = GetCursorPosition()
			end
		end)
		self:SecureHookScript(frame, "OnMouseUp", function()
			if this.dragging then
				this.dragging = false
				this.cursorPosition.x, this.cursorPosition.y = nil
			end
		end)
	end

	--[[ MouseWheel to zoom Modelframe - in/out works, but needs to be fleshed out
	frame:SetScript("OnMouseWheel", function()
		local xPos, yPos, zPos = frame:GetPosition()
		if arg1 == 1 then
			frame:SetPosition(xPos+00.1, 0, 0)
		else
			frame:SetPosition(xPos-00.1, 0, 0)
		end
	end) ]]

end

local function __moveObject(opts)
--[[
	Calling parameters:
		obj = object (Mandatory)
		x = left/right adjustment
		y = up/down adjustment
		relTo = object to move relative to
--]]
--@alpha@
	assert(opts.obj, "Unknown object __mO\n"..debugstack())
--@end-alpha@

	local point, relTo, relPoint, xOfs, yOfs = opts.obj:GetPoint()

	relTo = opts.relTo or relTo
--@alpha@
	assert(relTo, "__moveObject relTo is nil\n"..debugstack())
--@end-alpha@
	-- Workaround for relativeTo crash
	if not relTo then
		if Skinner.db.profile.Warnings then
			Skinner:CustomPrint(1, 0, 0, "moveObject (relativeTo) is nil:", tostring(objName))
		end
		return
	end

	-- apply the adjustment
	xOfs = opts.x and xOfs + opts.x or xOfs
	yOfs = opts.y and yOfs + opts.y or yOfs

	-- now move it
	opts.obj:ClearAllPoints()
	opts.obj:SetPoint(point, relTo, relPoint, xOfs, yOfs)

end

function Skinner:moveObject(...)

	local opts = select(1, ...)

--@alpha@
	assert(opts, "Unknown object mO\n"..debugstack())
--@end-alpha@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if type(rawget(opts, 0)) == "userdata" and type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = select(1, ...) and select(1, ...) or nil
		opts.x = select(3, ...) and select(3, ...) or nil
		if select(2, ...) and select(2, ...) == "-" then opts.x = opts.x * -1 end
		opts.y = select(5, ...) and select(5, ...) or nil
		if select(4, ...) and select(4, ...) == "-" then opts.y = opts.y * -1 end
		opts.relTo = select(6, ...) and select(6, ...) or nil
	end
	__moveObject(opts)

end

function Skinner:removeRegions(frame, regions)
--@alpha@
	assert(frame, "Unknown object\n"..debugstack())
--@end-alpha@

	if not frame then return end

	regions	= revTable(regions)

--	self:Debug("removeRegions: [%s]", frame:GetName() or "<Anon>")
	for i = 1, frame:GetNumRegions() do
		local reg = select(i, frame:GetRegions())
		if not regions or regions and regions[i] then
--			self:Debug("hide region: [%s, %s]", i, reg:GetName() or "<Anon>")
			reg:SetAlpha(0)
--@debug@
			if reg:IsObjectType("FontString") then self:Debug("rr FS: [%s, %s]", frame:GetName() or "<Anon>", i) end
--@end-debug@
		end
	end

end

function Skinner:resizeTabs(frame)

	local fN = frame:GetName()
	local tabName = fN.."Tab"
	local nT
	-- get the number of tabs
	nT = ((fN == "CharacterFrame" and not CharacterFrameTab2:IsShown()) and 4 or frame.numTabs)
--	self:Debug("rT: [%s, %s]", tabName, nT)
	-- accumulate the tab text widths
	local tTW = 0
	for i = 1, nT do
		tTW = tTW + _G[tabName..i.."Text"]:GetWidth()
	end
	-- add the tab side widths
	local tTW = tTW + (40 * nT)
	-- get the frame width
	local fW = frame:GetWidth()
	-- calculate the Tab left width
	local tlw = (tTW > fW and (40 - (tTW - fW) / nT) / 2 or 20)
	-- set minimum left width
	tlw = ("%.2f"):format(tlw >= 6 and tlw or 5.5)
-- 	self:Debug("resizeTabs: [%s, %s, %s, %s, %s]", fN, nT, tTW, fW, tlw)
	-- update each tab
	for i = 1, nT do
		_G[tabName..i.."Left"]:SetWidth(tlw)
		PanelTemplates_TabResize(_G[tabName..i], 0)
	end

end

function Skinner:setActiveTab(tabName)
--@alpha@
	assert(tabName, "Unknown object\n"..debugstack())
--@end-alpha@

	if not tabName then return end
	if not tabName.tfade then return end

--	self:Debug("setActiveTab : [%s]", tabName:GetName())

	tabName.tfade:SetTexture(self.gradientTexture)
	tabName.tfade:SetGradientAlpha(unpack(self.db.profile.Gradient.enable and self.gradientOn or self.gradientOff))

end

function Skinner:setInactiveTab(tabName)
--@alpha@
	assert(tabName, "Unknown object\n"..debugstack())
--@end-alpha@

	if not tabName then return end
	if not tabName.tfade then return end

--	self:Debug("setInactiveTab : [%s]", tabName:GetName())

	tabName.tfade:SetTexture(self.itTex)
	tabName.tfade:SetGradientAlpha(unpack(self.db.profile.Gradient.enable and self.gradientOn or self.gradientTab))

end

function Skinner:setTTBackdrop(bdReqd)
--	self:Debug("setTTBackdrop: [%s]", bdReqd)

	for _, tooltip in pairs(self.ttList) do
--		self:Debug("sTTB: [%s]", tooltip)
		local ttip = _G[tooltip]
		if ttip then
			if bdReqd then ttip:SetBackdrop(self.Backdrop[1])
			else ttip:SetBackdrop(nil) end
		end
	end

end

function Skinner:setTTBBC()
-- 	self:Debug("setTTBBC: [%s, %s, %s, %s]", unpack(self.tbColour))

	if self.db.profile.Tooltips.border == 1 then
		return unpack(self.bbColour)
	else
		return unpack(self.tbColour)
	end

end

function Skinner:shrinkBag(frame, bpMF)
--@alpha@
	assert(frame, "Unknown object\n"..debugstack())
--@end-alpha@

	if not frame then return end

	local frameName = frame:GetName()
	local bgTop = _G[frameName.."BackgroundTop"]
	if floor(bgTop:GetHeight()) == 256 then -- this is the backpack
--		self:Debug("Backpack found")
		if bpMF then -- is this a backpack Money Frame
			local yOfs = select(5, _G[frameName.."MoneyFrame"]:GetPoint())
--			self:Debug("Backpack Money Frame found: [%s, %s]", yOfs, floor(yOfs))
			if floor(yOfs) == -216 or floor(yOfs) == -217 then -- is it still in its original position
--				self:Debug("Backpack Money Frame moved")
				self:moveObject(_G[frameName.."MoneyFrame"], nil, nil, "+", 22)
			end
		end
		self:moveObject(_G[frameName.."Item1"], nil, nil, "+", 19)
	end
	if ceil(bgTop:GetHeight()) == 94 then self:adjHeight{obj=frame , adj=-20} end
	if ceil(bgTop:GetHeight()) == 86 then self:adjHeight{obj=frame , adj=-20} end
	if ceil(bgTop:GetHeight()) == 72 then self:adjHeight{obj=frame , adj=2} end -- 6, 10 or 14 slot bag

	frame:SetWidth(frame:GetWidth() - 10)
	self:moveObject(_G[frameName.."Item1"], "+", 3)

	-- use default fade height
	local fh = self.db.profile.ContainerFrames.fheight <= ceil(frame:GetHeight()) and self.db.profile.ContainerFrames.fheight or ceil(frame:GetHeight())

	if self.db.profile.FadeHeight.enable and self.db.profile.FadeHeight.force then
	-- set the Fade Height
	-- making sure that it isn't greater than the frame height
		fh = self.db.profile.FadeHeight.value <= ceil(frame:GetHeight()) and self.db.profile.FadeHeight.value or ceil(frame:GetHeight())
	end
--	self:Debug("sB - Frame, Fade Height: [%s, %s]", frame:GetName(), fh)

	if fh and frame.tfade then frame.tfade:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", -4, -fh) end

end

-- characters used on buttons
Skinner.mult = "×"
Skinner.plus = "+"
Skinner.minus = "−"
-- create font to use for Close Buttons
Skinner.fontX= CreateFont("fontX")
Skinner.fontX:SetFont([[Fonts\FRIZQT__.TTF]], 22)
Skinner.fontX:SetTextColor(1.0, 0.82, 0)
-- create font to use for Minus/Plus Buttons
Skinner.fontP= CreateFont("fontP")
Skinner.fontP:SetFont([[Fonts\ARIALN.TTF]], 16)
Skinner.fontP:SetTextColor(1.0, 0.82, 0)
function Skinner:skinButton(opts)
--[[
	as = use applySkin rather than addSkinButton
	cb = close button
	cb2 = close button style 2 (based upon OptionsButtonTemplate)
	mp = minus/plus button
	mp2 = minus/plus button style 2 (on RHS)
	plus = use plus sign
	tx = x offset for button text
	ty = y offset for button text
	other options as per addSkinButton
--]]
	if not self.db.profile.Buttons then return end

--@alpha@
	assert(opts.obj, "Unknown object skinButton\n"..debugstack())
--@end-alpha@

	if not opts.obj then return end

	if opts.obj:GetNormalTexture() then -- [UIPanelButtonTemplate/UIPanelCloseButton/... or derivatives]
		opts.obj:GetNormalTexture():SetAlpha(0)
		if opts.obj:GetPushedTexture() then opts.obj:GetPushedTexture():SetAlpha(0) end
		if opts.obj:GetDisabledTexture() then opts.obj:GetDisabledTexture():SetAlpha(0) end
	else -- [UIPanelButtonTemplate2/... or derivatives]
		local objName = opts.obj:GetName()
		_G[objName.."Left"]:SetAlpha(0)
		_G[objName.."Right"]:SetAlpha(0)
		_G[objName.."Middle"]:SetAlpha(0)
	end

	local x1, x2, y1, y2, tx, ty, btn, xOfs, bHgt
	if opts.cb then -- it's a close button
		opts.obj:SetNormalFontObject(self.fontX)
		opts.obj:SetText(self.mult)
		opts.obj:SetPushedTextOffset(-1, -1)
		tx = opts.tx or -1
		ty = opts.ty or 0
		if tx ~= 0 or ty ~= 0 then self:moveObject{obj=opts.obj:GetFontString(), x=tx, y=ty} end -- move text
		if opts.sap then
			self:addSkinButton{obj=opts.obj, parent=opts.obj, sap=true}
		else
			x1 = opts.x1 or 6
			y1 = opts.y1 or -6
			x2 = opts.x2 or -6
			y2 = opts.y2 or 6
			self:addSkinButton{obj=opts.obj, parent=opts.obj, x1=x1, y1=y1, x2=x2, y2=y2}
		end
	elseif opts.cb2 then -- it's pretending to be a close button (ArkInventory)
		self:addSkinButton{obj=opts.obj, parent=opts.obj, x1=-2, y1=2, x2=2, y2=-2}
		btn = self.sBut[opts.obj]
		btn:SetNormalFontObject(self.fontX)
		btn:SetText(self.mult)
	elseif opts.mp then -- it's a minus/plus texture on a larger button
		self:addSkinButton{obj=opts.obj, parent=opts.obj, aso={bd=self.Backdrop[6]}}
		btn = self.sBut[opts.obj]
		xOfs = opts.noMove and 0 or 3
		btn:ClearAllPoints()
		btn:SetPoint("LEFT", opts.obj, "LEFT", xOfs, 0)
		btn:SetWidth(16)
		btn:SetHeight(16)
		btn:SetNormalFontObject(self.fontP)
		btn:SetText(opts.plus and self.plus or self.minus)
		tx = opts.tx or 0
		ty = opts.ty or -1
		if tx ~= 0 or ty ~= 0 then self:moveObject{obj=btn:GetFontString(), x=tx, y=ty} end -- move text
	elseif opts.mp2 then -- it's a minus/plus button
		opts.obj:SetNormalFontObject(self.fontP)
		opts.obj:SetText(opts.plus and self.plus or self.minus)
		opts.obj:SetPushedTextOffset(-1, -1)
		self:addSkinButton{obj=opts.obj, parent=opts.obj, aso={bd=self.Backdrop[6]}, sap=true}
		self:SecureHook(opts.obj, "SetNormalTexture", function(this, nTex)
			self:checkTex{obj=this, nTex=nTex, mp2=true}
		end)
		tx = opts.tx or 0
		ty = opts.ty or -1
		if tx ~= 0 or ty ~= 0 then self:moveObject{obj=opts.obj:GetFontString(), x=tx, y=ty} end -- move text
	else -- standard button (UIPanelButtonTemplate/UIPanelButtonTemplate2 and derivatives)
		bHgt = opts.obj:GetHeight()
		aso = {bd=self.Backdrop[bHgt > 18 and 5 or 6]} -- use narrower backdrop if required
		if not opts.as then
			x1 = opts.x1 or 1
			y1 = opts.y1 or -1
			x2 = opts.x2 or -1
			y2 = opts.y2 or -1
			self:addSkinButton{obj=opts.obj, parent=opts.obj, aso=aso, bg=opts.bg, x1=x1, y1=y1, x2=x2, y2=y2}
			if opts.obj:GetFontString() then -- StaticPopup buttons don't have a FontString
				tx = opts.tx or 0
				ty = opts.ty or -1
				if tx ~= 0 or ty ~= 0 then self:moveObject{obj=opts.obj:GetFontString(), x=tx, y=ty} end -- move text
			end
		else
			self:applySkin{obj=opts.obj, bd=aso.bd}
		end
	end

end

function Skinner:isButton(obj)

	if obj:IsObjectType("Button")
	and obj.GetNormalTexture -- is it a true button
	and not obj.GetChecked -- and not a checkbutton
	and not obj.SetSlot -- and not a lootbutton
	then -- check textures are as expected
		local nTex = obj:GetNormalTexture() and obj:GetNormalTexture():GetTexture() or nil
		local oName = obj:GetName() or nil
		if nTex and nTex:find("UI-Panel-Button", 1, true)
		or oName and _G[oName.."Left"]
		and not (oName:find("AceConfig") or oName:find("AceGUI")) then -- ignore AceConfig/AceGui buttons
			return true
		end
	end

	return false

end

function Skinner:skinAllButtons(obj)

	local kids = {obj:GetChildren()}
	for _, child in ipairs(kids) do
		if self:isButton(child) then
			self:skinButton{obj=child}
		else
			local grandkids = {child:GetChildren()}
			for _, grandchild in ipairs(grandkids) do
				if self:isButton(grandchild) then
					self:skinButton{obj=grandchild}
				end
			end
			grandkids = nil
		end
	end
	kids = nil

end

local function __skinDropDown(opts)
--[[
	Calling parameters:
		obj = object (Mandatory)
		moveTex = move Texture up
		noSkin = don't skin the DropDown
		move = move Button Left and down, Text down
--]]
--@alpha@
	assert(opts.obj, "Unknown object__sDD\n"..debugstack())
--@end-alpha@

	if not (opts.obj and opts.obj.GetName and opts.obj:GetName() and _G[opts.obj:GetName().."Right"]) then return end -- ignore tekKonfig & Az dropdowns

	-- don't skin it twice
	if Skinner.skinned[opts.obj] then return end

	if not Skinner.db.profile.TexturedDD or opts.noSkin then Skinner:keepFontStrings(opts.obj) return end

	_G[opts.obj:GetName().."Left"]:SetAlpha(0)
	_G[opts.obj:GetName().."Right"]:SetAlpha(0)
	_G[opts.obj:GetName().."Middle"]:SetTexture(Skinner.itTex)
	_G[opts.obj:GetName().."Middle"]:SetHeight(19)

	if not opts.noMove then
		Skinner:moveObject{obj=_G[opts.obj:GetName().."Button"], x=-6, y=-2}
		Skinner:moveObject{obj=_G[opts.obj:GetName().."Text"], y=-2}
	end

	if opts.moveTex then Skinner:moveObject{obj=_G[opts.obj:GetName().."Middle"], y=2} end

end

function Skinner:skinDropDown(...)

	local opts = select(1, ...)

--@alpha@
	assert(opts, "Unknown object sDD\n"..debugstack())
--@end-alpha@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if type(rawget(opts, 0)) == "userdata" and type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = select(1, ...) and select(1, ...) or nil
		opts.moveTex = select(2, ...) and select(2, ...) or nil
		opts.noSkin = select(3, ...) and select(3, ...) or nil
		opts.noMove = select(4, ...) and select(4, ...) or nil
	end
	__skinDropDown(opts)

end

local function __skinEditBox(opts)
--[[
	Calling parameters:
		obj = object (Mandatory)
		regs = regions to keep
		noSkin = don't skin the frame
		noHeight = don't change the height
		noWidth = don't change the width
		move = move the edit box, left and up
		x = move the edit box left/right
		y = move the edit box up/down
--]]
--@alpha@
	assert(opts.obj and opts.obj:IsObjectType("EditBox"), "Not an EditBox\n"..debugstack())
--@end-alpha@

	if not opts.obj then return end

	-- don't skin it twice
	if Skinner.skinned[opts.obj] then return end

	opts.x = opts.x or 0
	opts.y = opts.y or 0

	local kRegions = CopyTable(Skinner.ebRegions)
	if opts.regs then
		for _, v in pairs(opts.regs) do
			tinsert(kRegions, v)
		end
	end
	Skinner:keepRegions(opts.obj, kRegions)

	-- adjust the left & right text inserts
	local l, r, t, b = opts.obj:GetTextInsets()
	opts.obj:SetTextInsets(l + 5, r + 5, t, b)

	-- change height, if required
	if not (opts.noHeight or opts.obj:IsMultiLine()) then opts.obj:SetHeight(24) end

	-- change width, if required
	if not opts.noWidth then opts.obj:SetWidth(opts.obj:GetWidth() + 5) end

	-- apply the backdrop
	if not opts.noSkin then Skinner:skinUsingBD{obj=opts.obj} end

	-- move to the left & up, if required
	if opts.move then opts.x, opts.y = -2, 2 end

	-- move left/right & up/down, if required
	if opts.x ~= 0 or opts.y ~= 0 then Skinner:moveObject{obj=opts.obj, x=opts.x, y=opts.y} end

end

function Skinner:skinEditBox(...)

	local opts = select(1, ...)

--@alpha@
	assert(opts, "Unknown object sEB\n"..debugstack())
--@end-alpha@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if type(rawget(opts, 0)) == "userdata" and type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = select(1, ...) and select(1, ...) or nil
		opts.regs = select(2, ...) and select(2, ...) or {}
		opts.noSkin = select(3, ...) and select(3, ...) or nil
		opts.noHeight = select(4, ...) and select(4, ...) or nil
		opts.noWidth = select(5, ...) and select(5, ...) or nil
		opts.move = select(6, ...) and select(6, ...) or nil
	end
	__skinEditBox(opts)

end

function Skinner:skinFFToggleTabs(tabName, tabCnt)
--	self:Debug("skinFFToggleTabs: [%s, %s]", tabName, tabCnt)

	for i = 1, tabCnt or 3 do
		local togTab = _G[tabName..i]
		if not togTab then break end -- handle missing Tabs (e.g. Muted)
		if not self.skinned[togTab] then -- don't skin it twice
			self:keepRegions(togTab, {7, 8}) -- N.B. regions 7 & 8 are text/scripts
			self:adjHeight{obj=togTab , adj=-5}
			if i == 1 then self:moveObject{obj=togTab, y=3} end
			self:moveObject{obj=_G[togTab:GetName().."Text"], x=-2, y=3}
			self:moveObject{obj=_G[togTab:GetName().."HighlightTexture"], x=-2, y=5}
			self:addSkinFrame{obj=togTab}
		end
	end

end

function Skinner:skinFFColHeads(buttonName, noCols)
-- 	self:Debug("skinFFColHeads: [%s]", buttonName)

	local numCols = noCols and noCols or 4
	for i = 1, numCols do
		self:keepRegions(_G[buttonName..i], {4, 5}) -- N.B 4 is text, 5 is highlight
		self:addSkinFrame{obj=_G[buttonName..i]}
	end

end

local function __skinMoneyFrame(opts)
--[[
	Calling parameters:
		obj = object (Mandatory)
		regs = regions to keep
		moveGIcon = move Gold Icon
		noWidth = don't change the width
		moveSEB = move the Silver edit box left
		moveGEB = move the Gold edit box left
--]]
--@alpha@
	assert(opts.obj, "Unknown object __sMF\n"..debugstack())
--@end-alpha@

	-- don't skin it twice
	if Skinner.skinned[opts.obj] then return end

	local cbMode = GetCVarBool("colorblindMode")

	for k, v in pairs{"Gold", "Silver", "Copper"} do
		local fName = _G[opts.obj:GetName()..v]
		Skinner:skinEditBox{obj=fName, regs={9, 10}, noHeight=true, noWidth=true} -- N.B. region 9 is the icon, 10 is text
		-- move label to the right for colourblind mode
		if k ~= 1 or opts.moveGIcon then
			Skinner:moveObject{obj=fName.texture, x=10}
			Skinner:moveObject{obj=fName.label, x=10}
--			Skinner:moveObject{obj=Skinner:getRegion(fName, 9), x=10}
		end
		if not opts.noWidth and k ~= 1 then
			fName:SetWidth(fName:GetWidth() + 5)
		end
		if v == "Gold" and opts.moveGEB then
			Skinner:moveObject{obj=fName, x=-8}
		end
		if v == "Silver" and opts.moveSEB then
			Skinner:moveObject{obj=fName, x=-10}
		end
	end

end

function Skinner:skinMoneyFrame(...)

	local opts = select(1, ...)

--@alpha@
	assert(opts, "Unknown object sMF\n"..debugstack())
--@end-alpha@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if type(rawget(opts, 0)) == "userdata" and type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = select(1, ...) and select(1, ...) or nil
		opts.moveGIcon = select(2, ...) and select(2, ...) or nil
		opts.noWidth = select(3, ...) and select(3, ...) or nil
		opts.moveSEB = select(4, ...) and select(4, ...) or nil
		opts.moveGEB = select(5, ...) and select(5, ...) or nil
	end
	__skinMoneyFrame(opts)

end

local function __skinScrollBar(opts)
--[[
	Calling parameters:
		obj = object (Mandatory)
		sbPrefix = Prefix to use
		sbObj = ScrollBar object to use
		size = backdrop size to use (2 - wide, 3 - medium, 4 - narrow)
		noRR = Don't remove regions
--]]
--@alpha@
	assert(opts.obj and opts.obj:IsObjectType("ScrollFrame"), "Not a ScrollFrame\n"..debugstack())
--@end-alpha@

	-- don't skin it twice
	if Skinner.skinned[opts.obj] then return end

	-- remove all the object's regions, if required
	if not opts.noRR then Skinner:removeRegions(opts.obj)end

	-- get the actual ScrollBar object
	local sBar = opts.sbObj and opts.sbObj or _G[opts.obj:GetName()..(opts.sbPrefix or "").."ScrollBar"]

	-- skin it
	Skinner:skinUsingBD{obj=sBar, size=opts.size}

end

function Skinner:skinScrollBar(...)

	local opts = select(1, ...)

--@alpha@
	assert(opts, "Unknown object sSB\n"..debugstack())
--@end-alpha@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if type(rawget(opts, 0)) == "userdata" and type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = select(1, ...) and select(1, ...) or nil
		opts.sbPrefix = select(2, ...) and select(2, ...) or nil
		opts.sbObj = select(3, ...) and select(3, ...) or nil
		opts.size = select(4, ...) and select(4, ...) or 2
	end
	__skinScrollBar(opts)

end

local function __skinSlider(opts)
--[[
	Calling parameters:
		obj = object (Mandatory)
		size = backdrop size to use (2 - wide, 3 - medium, 4 - narrow)
--]]
--@alpha@
	assert(opts.obj and opts.obj:IsObjectType("Slider"), "Not a Slider\n"..debugstack())
--@end-alpha@

	-- don't skin it twice
	if Skinner.skinned[opts.obj] then return end

	Skinner:keepFontStrings(opts.obj)
	opts.obj:SetAlpha(1)
	opts.obj:GetThumbTexture():SetAlpha(1)

	Skinner:skinUsingBD{obj=opts.obj, size=opts.size}

end

function Skinner:skinSlider(...)

	local opts = select(1, ...)

--@alpha@
	assert(opts, "Unknown object sS\n"..debugstack())
--@end-alpha@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if type(rawget(opts, 0)) == "userdata" and type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = select(1, ...) and select(1, ...) or nil
		opts.size = select(2, ...) and select(2, ...) or 2
	end
	__skinSlider(opts)

end

function Skinner:skinTooltip(frame)
	if not self.db.profile.Tooltips.skin then return end
--@alpha@
	assert(frame, "Unknown object\n"..debugstack())
--@end-alpha@

	if not frame then return end

	if not self.db.profile.Gradient.ui then return end

	local ttHeight = ceil(frame:GetHeight())

--	self:Debug("sT: [%s, %s, %s, %s]", frame, frame:GetName(), self.ttBorder, ttHeight)

	if not frame.tfade then frame.tfade = frame:CreateTexture(nil, "BORDER") end
	frame.tfade:SetTexture(self.gradientTexture)

	if self.db.profile.Tooltips.style == 1 then
		frame.tfade:SetPoint("TOPLEFT", frame, "TOPLEFT", 6, -6)
		frame.tfade:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", -6, -27)
	elseif self.db.profile.Tooltips.style == 2 then
		frame.tfade:SetPoint("TOPLEFT", frame, "TOPLEFT", 4, -4)
		frame.tfade:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -4, 4)
	else
		frame.tfade:SetPoint("TOPLEFT", frame, "TOPLEFT", 4, -4)
		-- set the Fade Height making sure that it isn't greater than the frame height
		local fh = self.db.profile.FadeHeight.value <= ttHeight and self.db.profile.FadeHeight.value or ttHeight
		frame.tfade:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", -4, -(fh - 4))
		frame:SetBackdropColor(unpack(self.bColour))
	end

	-- Check to see if we need to colour the Border
	if not self.ttBorder then
		for _, tooltip in pairs(self.ttCheck) do
			if tooltip == frame:GetName() then
				local r, g, b, a = frame:GetBackdropBorderColor()
				r = ("%.2f"):format(r)
				g = ("%.2f"):format(g)
				b = ("%.2f"):format(b)
				a = ("%.2f"):format(a)
--				self:Debug("checkTTBBC: [%s, %s, %s, %s, %s]", frame:GetName(), r, g, b, a)
				if r ~= "1.00" or g ~= "1.00" or b ~= "1.00" or a ~= "1.00" then return end
			end
		end
	end

	frame:SetBackdropBorderColor(self:setTTBBC())

	frame.tfade:SetBlendMode("ADD")
	frame.tfade:SetGradientAlpha(unpack(self.db.profile.Gradient.enable and self.gradientOn or self.gradientOff))

end

local function __skinUsingBD(opts)
--[[
	Calling parameters:
		obj = object (Mandatory)
		size = backdrop size to use (2 - wide, 3 - medium, 4 - narrow)
--]]
--@alpha@
	assert(opts.obj, "Unknown object __sUBD\n"..debugstack())
--@end-alpha@

	opts.size = opts.size or 3 -- default to medium

	opts.obj:SetBackdrop(Skinner.Backdrop[opts.size])
	opts.obj:SetBackdropBorderColor(.2, .2, .2, 1)
	opts.obj:SetBackdropColor(.1, .1, .1, 1)

end

function Skinner:skinUsingBD(...)

	local opts = select(1, ...)

--@alpha@
	assert(opts, "Unknown object sUBD\n"..debugstack())
--@end-alpha@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if type(rawget(opts, 0)) == "userdata" and type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = select(1, ...) and select(1, ...) or nil
		opts.size = select(2, ...) and select(2, ...) or 3
	end
	__skinUsingBD(opts)

end

function Skinner:skinUsingBD2(obj)

	self:skinUsingBD{obj=obj, size=2}

end

function Skinner:updateSBTexture()

	-- get updated colour/texture
	local c = self.db.profile.StatusBar
	self.sbColour = {c.r, c.g, c.b, c.a}
	self.sbTexture = self.LSM:Fetch("statusbar", self.db.profile.StatusBar.texture)

	for statusBar, tab in pairs(self.sbGlazed) do
		statusBar:SetStatusBarTexture(self.sbTexture)
		if tab.bg then
			if tab.bg:IsObjectType("StatusBar") then
				tab.bg:SetStatusBarTexture(self.sbTexture)
				tab.bg:SetStatusBarColor(unpack(self.sbColour))
			else
				tab.bg:SetTexture(self.sbTexture) -- handle backgrounds that aren't StatusBars
				tab.bg:SetVertexColor(unpack(self.sbColour))
			end
		end
		local flashTex = _G[statusBar:GetName()] and _G[statusBar:GetName().."Flash"]
		if flashTex and flashTex:IsObjectType("Texture") then flashTex:SetTexture(self.sbTexture) end -- handle CastingBar Flash
	end

end

-- This function was copied from WoWWiki
-- http://www.wowwiki.com/RGBPercToHex
function Skinner:RGBPercToHex(r, g, b)

--	Check to see if the passed values are strings, if so then use some default values
	if type(r) == "string" then r, g, b = 0.8, 0.8, 0.0 end

	r = r <= 1 and r >= 0 and r or 0
	g = g <= 1 and g >= 0 and g or 0
	b = b <= 1 and b >= 0 and b or 0

	return ("%02x%02x%02x"):format(r*255, g*255, b*255)

end

local function round2(num, ndp)

  return tonumber(("%." .. (ndp or 0) .. "f"):format(num))

end

function Skinner:ShowInfo(obj, showKids, noDepth)

--@alpha@
	assert(obj, "Unknown object ShowInfo\n"..debugstack())
--@end-alpha@

	if not obj then return end

	local showKids = showKids or false

	local function showIt(fmsg, ...)

		print("dbg:"..makeText(fmsg, ...), Skinner.debugFrame)

	end

	local function getRegions(object, lvl)

		for i = 1, object:GetNumRegions() do
			local v = select(i, object:GetRegions())
			showIt("[lvl%s-%s : %s : %s : %s : %s : %s]", lvl, i, v:GetName() or "<Anon>", v:GetObjectType() or "nil", v.GetWidth and round2(v:GetWidth(), 2) or "nil", v.GetHeight and round2(v:GetHeight(), 2) or "nil", v:GetObjectType() == "Texture" and ("%s : %s"):format(v:GetTexture() or "nil", v:GetDrawLayer() or "nil") or "nil")
		end

	end

	local function getChildren(frame, lvl)

		if not showKids then return end
		if type(lvl) == "string" and lvl:find("-") == 2 and noDepth then return end

		for i = 1, frame:GetNumChildren() do
			local v = select(i, frame:GetChildren())
			local objType = v:GetObjectType()
			showIt("[lvl%s-%s : %s : %s : %s : %s : %s : %s]", lvl, i, v:GetName() or "<Anon>", v.GetWidth and round2(v:GetWidth(), 2) or "nil", v.GetHeight and round2(v:GetHeight(), 2) or "nil", objType or "nil", v:GetFrameLevel() or "nil", v:GetFrameStrata() or "nil")
			if objType == "Frame" or objType == "Button" or objType == "StatusBar" or objType == "Slider" or objType == "ScrollFrame" then
				getRegions(v, lvl.."-"..i)
				getChildren(v, lvl.."-"..i)
			end
		end

	end

	showIt("%s : %s : %s : %s : %s : %s", obj:GetName() or "<Anon>", round2(obj:GetWidth(), 2) or "nil", round2(obj:GetHeight(), 2) or "nil", obj:GetObjectType() or "nil", obj:GetFrameLevel() or "nil", obj:GetFrameStrata() or "nil")

	showIt("Started Regions")
	getRegions(obj, 0)
	showIt("Finished Regions")
	showIt("Started Children")
	getChildren(obj, 0)
	showIt("Finished Children")

end
