local aName, aObj = ...
local _G = _G
local obj, objName, tex, texName, btn, btnName, tab, tabSF, tabName, objHeight, prdb, c, opts, kRegions

do
	-- check to see if required libraries are loaded
	assert(LibStub, aName.." requires LibStub")
	for _, lib in pairs{"CallbackHandler-1.0", "AceAddon-3.0", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0", "AceLocale-3.0", "LibSharedMedia-3.0", "AceDB-3.0", "AceDBOptions-3.0", "AceGUI-3.0",  "AceConfig-3.0", "AceConfigCmd-3.0", "AceConfigRegistry-3.0", "AceConfigDialog-3.0", "LibDataBroker-1.1", "LibDBIcon-1.0",} do
		assert(LibStub(lib, true), aName.." requires "..lib)
	end

	-- create the addon
	_G[aName] = LibStub("AceAddon-3.0"):NewAddon(aObj, aName, "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")

	-- specify where debug messages go
	aObj.debugFrame = ChatFrame10

	-- Get Locale
	aObj.L = LibStub("AceLocale-3.0"):GetLocale(aName)

	-- pointer to LibSharedMedia-3.0 library
	aObj.LSM = LibStub("LibSharedMedia-3.0")

	-- player class
	aObj.uCls = select(2, UnitClass("player"))

	local portal = GetCVar("portal") or nil
	--check to see if running on PTR versionm
	aObj.isPTR = portal == "public-test" and true or false
	-- check to see if running on Beta version
	aObj.isBeta = portal == "public-beta" and true or false
	-- check build number, if > Live then it's a patch
	local buildInfo = {GetBuildInfo()}
	aObj.isPatch = tonumber(buildInfo[2]) > 14545 and true or false

end

function aObj.round2(num, ndp)

  return tonumber(("%." .. (ndp or 0) .. "f"):format(num))

end

function aObj:OnInitialize()

--@debug@
	self:Print("Debugging is enabled")
	self:Debug("Debugging is enabled")
--@end-debug@

--@alpha@
	if self.isPatch then self:Debug("Patch detected") end
	if self.isPTR then self:Debug("PTR detected") end
	if self.isBeta then self:Debug("Beta detected") end
--@end-alpha@

	-- setup the default DB values and register them
	self:checkAndRun("Defaults", true)
	prdb = self.db.profile

	-- convert any old settings
	if type(self.db.profile.MinimapButtons) == "boolean" then
		self.db.profile.MinimapButtons = {skin = true, style = false}
	end

	-- setup the Addon's options
	self:checkAndRun("Options")

	-- register the default background texture
	self.LSM:Register("background", "Blizzard ChatFrame Background", [[Interface\ChatFrame\ChatFrameBackground]])
	-- register the inactive tab texture
	self.LSM:Register("background", aName.." Inactive Tab", [[Interface\AddOns\]]..aName..[[\textures\inactive]])
	-- register the texture used for EditBoxes & ScrollBars
	self.LSM:Register("border", aName.." Border", [[Interface\AddOns\]]..aName..[[\textures\krsnik]])
	-- register the statubar texture used by Nameplates
	self.LSM:Register("statusbar", "Blizzard2", [[Interface\TargetingFrame\UI-TargetingFrame-BarFill]])
	-- register any User defined textures used
	if prdb.BdFile and prdb.BdFile ~= "None" then
		self.LSM:Register("background", aName.." User Backdrop", prdb.BdFile)
	end
	if prdb.BdEdgeFile and prdb.BdEdgeFile ~= "None" then
		self.LSM:Register("border", aName.." User Border", prdb.BdEdgeFile)
	end
	if prdb.BgFile and prdb.BgFile ~= "None" then
		self.LSM:Register("background", aName.." User Background", prdb.BgFile)
	end
	if prdb.TabDDFile and prdb.TabDDFile ~= "None" then
		self.LSM:Register("background", aName.." User TabDDTexture", prdb.TabDDFile)
	end

	-- Heading and Body Text colours
	c = prdb.HeadText
	self.HTr, self.HTg, self.HTb = c.r, c.g, c.b
	c = prdb.BodyText
	self.BTr, self.BTg, self.BTb = c.r, c.g, c.b

	-- Frame multipliers (still used in older skins)
	self.FxMult, self.FyMult = 0.9, 0.87
	-- EditBox regions to keep
	self.ebRegions = {1, 2, 3, 4, 5} -- 1 is text, 2-5 are textures

	-- Gradient settings
	self.gradientTab = {prdb.Gradient.rotate and "HORIZONTAL" or "VERTICAL", .5, .5, .5, 1, .25, .25, .25, 0}
	self.gradientCBar = {prdb.Gradient.rotate and "HORIZONTAL" or "VERTICAL", .25, .25, .55, 1, 0, 0, 0, 1}
	self.gradientTex = self.LSM:Fetch("background", prdb.Gradient.texture)

	-- backdrop for Frames etc
	self.bdTex = "Blizzard ChatFrame Background"
	self.bdbTex = "Blizzard Tooltip"
	if prdb.BdDefault then
		self.backdrop = {
			bgFile = self.LSM:Fetch("background", self.bdTex),
			tile = true, tileSize = 16,
			edgeFile = self.LSM:Fetch("border", self.bdbTex),
			edgeSize = 16,
			insets = {left = 4, right = 4, top = 4, bottom = 4},
		}
	else
		if prdb.BdFile and prdb.BdFile ~= "None" then
			self.bdTex = aName.." User Backdrop"
		else
			self.bdTex = prdb.BdTexture
		end
		if prdb.BdEdgeFile and prdb.BdEdgeFile ~= "None" then
			self.bdbTex = aName.." User Border"
		else
			self.bdbTex = prdb.BdBorderTexture
		end
		local bdi = prdb.BdInset
		local bdt = prdb.BdTileSize > 0 and true or false
		self.backdrop = {
			bgFile = self.LSM:Fetch("background", self.bdTex),
			tile = bdt, tileSize = prdb.BdTileSize,
			edgeFile = self.LSM:Fetch("border", self.bdbTex),
			edgeSize = prdb.BdEdgeSize,
			insets = {left = bdi, right = bdi, top = bdi, bottom = bdi},
		}
	end
	self.Backdrop = {}
	self.Backdrop[1] = CopyTable(self.backdrop)
	-- wide backdrop for ScrollBars & EditBoxes (16,16,4)
	self.Backdrop[2] = CopyTable(self.backdrop)
	self.Backdrop[2].edgeFile = self.LSM:Fetch("border", aName.." Border")
	-- medium backdrop for ScrollBars (12,12,3)
	self.Backdrop[3] = CopyTable(self.Backdrop[2])
	self.Backdrop[3].tileSize = 12
	self.Backdrop[3].edgeSize = 12
	self.Backdrop[3].insets = {left = 3, right = 3, top = 3, bottom = 3}
	-- narrow backdrop for ScrollBars (8,8,2)
	self.Backdrop[4] = CopyTable(self.Backdrop[2])
	self.Backdrop[4].tileSize = 8
	self.Backdrop[4].edgeSize = 8
	self.Backdrop[4].insets = {left = 2, right = 2, top = 2, bottom = 2}
	-- these backdrops are for small UI buttons, e.g. minus/plus in QuestLog/IOP/Skills etc
	self.Backdrop[5] = CopyTable(self.backdrop)
	self.Backdrop[5].tileSize = 12
	self.Backdrop[5].edgeSize = 12
	self.Backdrop[5].insets = {left = 3, right = 3, top = 3, bottom = 3}
	self.Backdrop[6] = CopyTable(self.backdrop)
	self.Backdrop[6].tileSize = 10
	self.Backdrop[6].edgeSize = 10
	self.Backdrop[6].insets = {left = 3, right = 3, top = 3, bottom = 3}
	self.Backdrop[7] = CopyTable(self.backdrop)
	self.Backdrop[7].edgeSize = 10
	-- this backdrop is for the BattlefieldMinimap frame
	self.Backdrop[8] = CopyTable(self.backdrop)
	self.Backdrop[8].bgFile = nil
	self.Backdrop[8].tile = false
	self.Backdrop[8].tileSize = 0
	-- setup background texture
	if prdb.BgUseTex then
		if prdb.BgFile and prdb.BgFile ~= "None" then
			self.bgTex = aName.." User Background"
		else
			self.bgTex = prdb.BgTexture
		end
	end

	-- these are used to disable frames from being skinned, LoD frames are entered here
	-- other frames are added when their code is loaded
	self.charKeys1 = {"GlyphUI", "TalentUI", "TradeSkillUI", "RaidUI", "ArchaeologyUI", "GuildUI", "GuildControlUI"} -- LoD frames
	self.charKeys2 = {"AchievementUI"}
	self.npcKeys = {"TrainerUI", "AuctionUI", "BarbershopUI", "ReforgingUI"} -- LoD frames
	self.uiKeys1 = {"GMSurveyUI", "InspectUI", "BattlefieldMm", "TimeManager", "Calendar", "BindingUI", "MacroUI", "ItemSocketingUI", "GuildBankUI", "GMChatUI", "DebugTools", "LookingForGuildUI"} -- LoD frames
	self.uiKeys2 = {}
	if self.isPTR then
		self:add2Table(self.uiKeys1, "FeedbackUI")
	end
	if self.isPatch then
		self:add2Table(self.charKeys1, "EncounterJournal")
		self:add2Table(self.npcKeys, "ItemAlterationUI")
		self:add2Table(self.npcKeys, "VoidStorageUI")
		self:add2Table(self.uiKeys1, "MovePad")
	end
	-- these are used to disable the gradient
	self.gradFrames = {["c"] = {}, ["u"] = {}, ["n"] = {}, ["s"] = {}}

	-- TooltipBorder colours
	c = prdb.ClassColours and RAID_CLASS_COLORS[self.uCls] or prdb.TooltipBorder
	self.tbColour = {c.r, c.g, c.b, c.a or 1}
	-- StatusBar colours
	c = prdb.StatusBar
	self.sbColour = {c.r, c.g, c.b, c.a}
	-- StatusBar texture
	self.sbTexture = self.LSM:Fetch("statusbar", prdb.StatusBar.texture)
	-- Backdrop colours
	c = prdb.Backdrop
	self.bColour = {c.r, c.g, c.b, c.a or 1}
	-- BackdropBorder colours
	c = prdb.ClassColours and RAID_CLASS_COLORS[self.uCls] or prdb.BackdropBorder
	self.bbColour = {c.r, c.g, c.b, c.a or 1}
	-- Inactive Tab & DropDowns texture
	if prdb.TabDDFile and prdb.TabDDFile ~= "None" then
		self.itTex = self.LSM:Fetch("background", aName.." User TabDDTexture")
	else
		self.itTex = self.LSM:Fetch("background", prdb.TabDDTexture)
	end
	-- Empty Slot texture
	self.esTex = [[Interface\Buttons\UI-Quickslot2]]

	-- class table
	self.classTable = {"Druid", "Priest", "Paladin", "Hunter", "Rogue", "Shaman", "Mage", "Warlock", "Warrior", "DeathKnight"}

	-- store Addons managed by LoadManagers
	self.lmAddons = {}

	-- table to hold which functions have been actioned
	self.initialized = {}

	-- table to hold objects which have been skinned
	-- with a metatable having weak keys and automatically adding an entry if it doesn't exist
	self.skinned = setmetatable({}, {__mode = "k", __index = function(t, k) t[k] = true end})

	-- table to hold frames that have been added, with weak keys
	self.skinFrame = setmetatable({}, {__mode = "k"})

--	-- table to hold buttons that have been added, with weak keys
	self.sBtn = setmetatable({}, {__mode = "k"})

	-- table to hold StatusBars that have been glazed, with weak keys
	self.sbGlazed = setmetatable({}, {__mode = "k"})

	-- shorthand for the TexturedTab profile setting
	self.isTT = prdb.TexturedTab and true or false

	-- hook to handle textured tabs on Blizzard & other Frames
	self.tabFrames = {}
	if self.isTT then
		self:SecureHook("PanelTemplates_SetTab", function(obj, id)
			-- self:Debug("PT_ST: [%s, %s, %s, %s]", obj, id, obj.numTabs or "nil", obj.selectedTab or "nil")
			if not self.tabFrames[obj] then return end -- ignore frame if not monitored
			-- self:Debug("PT_ST#2")
			local tabSF
			for i = 1, obj.numTabs do
				tabSF = self.skinFrame[_G[obj:GetName().."Tab"..i]]
				if i == id then
					self:setActiveTab(tabSF)
				else
					self:setInactiveTab(tabSF)
				end
			end
		end)
	end

	-- handle InCombat issues
	self.oocTab = {}
	self:RegisterEvent("PLAYER_REGEN_ENABLED", function()
		for _, v in pairs(self.oocTab) do
			v[1](v[2])
		end
		wipe(self.oocTab)
	end)

end

function aObj:OnEnable()

	-- add support for UIButton skinning
	local btnModDB = self.db:GetNamespace("UIButtons", true)
	self.modUIBtns = self:GetModule("UIButtons", true)
	if self.modUIBtns:IsEnabled() then
		if btnModDB.profile.UIButtons then
			self.modBtns = true
		end
		if btnModDB.profile.ButtonBorders then
			self.modBtnBs = true
		end
	end
	self.checkTex = self.modBtns and self.modUIBtns.checkTex or function() end
	self.skinButton = self.modBtns and self.modUIBtns.skinButton or function() end
	self.isButton = self.modBtns and self.modUIBtns.isButton or function() end
	self.skinAllButtons = self.modBtns and self.modUIBtns.skinAllButtons or function() end
	self.addButtonBorder = self.modBtnBs and self.modUIBtns.addButtonBorder or function() end

	-- track when Auction House is opened
	self:RegisterEvent("AUCTION_HOUSE_SHOW")
	-- track when Trade Skill is opened (used by MrTrader_SkillWindow)
	self:RegisterEvent("TRADE_SKILL_SHOW")
	-- register for event after a slight delay as registering ADDON_LOADED any earlier causes it not to be registered if LoD modules are loaded on startup (e.g. SimpleSelfRebuff/LightHeaded)
	self:ScheduleTimer(function() self:RegisterEvent("ADDON_LOADED") end, self.db.profile.Delay.Init)
	-- skin the Blizzard frames
	self:ScheduleTimer("BlizzardFrames", self.db.profile.Delay.Init)
	-- skin the loaded AddOns frames
	self:ScheduleTimer("AddonFrames", self.db.profile.Delay.Init + self.db.profile.Delay.Addons + 0.1)

	-- handle profile changes
	self.db.RegisterCallback(self, "OnProfileChanged", "ReloadAddon")
	self.db.RegisterCallback(self, "OnProfileCopied", "ReloadAddon")
	self.db.RegisterCallback(self, "OnProfileReset", "ReloadAddon")

	-- handle statusbar changes
	self.LSM.RegisterCallback(self, "LibSharedMedia_SetGlobal", function(mtype, override)
		if mtype == "statusbar" then
			self.db.profile.StatusBar.texture = override
			self:updateSBTexture()
		elseif mtype == "background" then
			self.db.profile.BdTexture = override
		elseif mtype == "border" then
			self.db.profile.BdBorderTexture = override
		end
	end)

--@debug@
	self:SetupCmds()
--@end-debug@

end

do
	StaticPopupDialogs[aName.."_Reload_UI"] = {
		text = aObj.L["Confirm reload of UI to activate profile changes"],
		button1 = OKAY,
		button2 = CANCEL,
		OnAccept = function()
			ReloadUI()
		end,
		OnCancel = function(this, data, reason)
			if reason == "timeout" or reason == "clicked" then
				aObj:CustomPrint(1, 1, 0, "The profile '"..aObj.db:GetCurrentProfile().."' will be activated next time you Login or Reload the UI")
			end
		end,
		timeout = 0,
		whileDead = 1,
		exclusive = 1,
		hideOnEscape = 1
	}
end
function aObj:ReloadAddon(callback)

	StaticPopup_Show(aName.."_Reload_UI")

end

function aObj:getGradientInfo(invert, rotate)

	c = prdb.GradientMin
	local MinR, MinG, MinB, MinA = c.r, c.g, c.b, c.a
	c = prdb.GradientMax
	local MaxR, MaxG, MaxB, MaxA = c.r, c.g, c.b, c.a

	if prdb.Gradient.enable then
		if invert then
			return rotate and "HORIZONTAL" or "VERTICAL", MaxR, MaxG, MaxB, MaxA, MinR, MinG, MinB, MinA
		else
			return rotate and "HORIZONTAL" or "VERTICAL", MinR, MinG, MinB, MinA, MaxR, MaxG, MaxB, MaxA
		end
	else
		return rotate and "HORIZONTAL" or "VERTICAL", 0, 0, 0, 1, 0, 0, 0, 1
	end

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
		ofs = offset value to use
		x1 = X offset for TOPLEFT
		y1 = Y offset for TOPLEFT
		x2 = X offset for BOTTOMRIGHT
		y2 = Y offset for BOTTOMRIGHT
--]]
--@alpha@
	assert(opts.obj, "Missing object __aSB\n"..debugstack())
--@end-alpha@

	-- remove the object's Backdrop if it has one
	if opts.obj.GetBackdrop and opts.obj:GetBackdrop() then opts.obj:SetBackdrop(nil) end

	-- make all textures transparent, if required
	if opts.kfs then aObj:keepFontStrings(opts.obj) end

	opts.parent = opts.parent or opts.obj:GetParent()
	opts.hook = opts.hook or opts.obj

	btn = CreateFrame("Button", nil, opts.parent)
	-- lower frame level
	LowerFrameLevel(btn)
	btn:EnableMouse(false) -- allow clickthrough
	aObj.sBtn[opts.hook] = btn
	-- hook Show/Hide methods
	if not aObj:IsHooked(opts.hook, "Show") then
		aObj:SecureHook(opts.hook, "Show", function(this) aObj.sBtn[this]:Show() end)
		aObj:SecureHook(opts.hook, "Hide", function(this) aObj.sBtn[this]:Hide() end)
		if opts.obj:IsObjectType("Button") then -- hook Enable/Disable methods
			aObj:SecureHook(opts.hook, "Enable", function(this) aObj.sBtn[this]:Enable() end)
			aObj:SecureHook(opts.hook, "Disable", function(this) aObj.sBtn[this]:Disable() end)
		end
	end
	-- position the button skin
	if opts.sap then
		btn:SetAllPoints(opts.obj)
	else
		-- setup offset values
		opts.ofs = opts.ofs or 4
		local xOfs1 = opts.x1 or opts.ofs * -1
		local yOfs1 = opts.y1 or opts.ofs
		local xOfs2 = opts.x2 or opts.ofs
		local yOfs2 = opts.y2 or opts.ofs * -1
		btn:SetPoint("TOPLEFT", opts.obj, "TOPLEFT", xOfs1, yOfs1)
		btn:SetPoint("BOTTOMRIGHT", opts.obj, "BOTTOMRIGHT", xOfs2, yOfs2)
	end
	-- setup applySkin options
	opts.aso = opts.aso or {}
	opts.aso.obj = btn
	aObj:applySkin(opts.aso)

	-- hide button skin, if required or not shown
	if opts.hide or not opts.obj:IsShown() then btn:Hide() end

	 -- make sure it's lower than its parent's Frame Strata
	if opts.bg then btn:SetFrameStrata("BACKGROUND") end

	-- change the draw layer of the Icon and Count, if necessary
	if opts.obj.GetNumRegions then
		local regOT, regName, regDL, regTex
		for _, reg in pairs{opts.obj:GetRegions()} do
			regOT = reg:GetObjectType()
			if regOT == "Texture" or regOT == "FontString" then
				regName = reg:GetName()
				regDL = reg:GetDrawLayer()
				regTex = regOT == "Texture" and reg:GetTexture() or nil
				-- change the DrawLayer to make the Icon show if required
				if (regName and (regName:find("[Ii]con") or regName:find("[Cc]ount")))
				or (regTex and regTex:find("[Ii]con")) then
					if regDL == "BACKGROUND" then reg:SetDrawLayer("ARTWORK") end
				end
			end
		end
	end

	return btn

end

function aObj:addSkinButton(...)

	opts = select(1, ...)

--@alpha@
	assert(opts, "Missing object aSB\n"..debugstack())
--@end-alpha@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if type(rawget(opts, 0)) == "userdata" and type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = select(1, ...) and select(1, ...) or nil
		opts.parent = select(2, ...) and select(2, ...) or nil
		opts.hook = select(3, ...) and select(3, ...) or nil
		opts.hide = select(4, ...) and select(4, ...) or nil
	end
	-- new style call
	return __addSkinButton(opts)

end

local hdrTexNames = {"Header", "_Header", "_HeaderBox", "_FrameHeader", "FrameHeader", "HeaderTexture", "HeaderFrame"}
local function hideHeader(obj)

	local hdr
	-- hide the Header Texture and move the Header text, if required
	for _, htex in pairs(hdrTexNames) do
		hdr = _G[obj:GetName()..htex]
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
		ofs = offset value to use
		x1 = X offset for TOPLEFT
		y1 = Y offset for TOPLEFT
		x2 = X offset for BOTTOMRIGHT
		y2 = Y offset for BOTTOMRIGHT
		nb = don't skin UI buttons
		bgen = generations of button children to traverse
		anim = reparent skinFrame to avoid whiteout issues caused by animations
		ri = Disable Inset DrawLayers
		bas = use applySkin for buttons
		rt = remove Textures
--]]
--@alpha@
	assert(opts.obj, "Missing object __aSF\n"..debugstack())
--@end-alpha@

	-- remove the object's Backdrop if it has one
	if opts.obj.GetBackdrop and opts.obj:GetBackdrop() then opts.obj:SetBackdrop(nil) end

	-- store frame obj, if required
	if opts.ft then aObj:add2Table(aObj.gradFrames[opts.ft], opts.obj) end

	-- make all textures transparent, if required
	if opts.kfs or opts.hat then aObj:keepFontStrings(opts.obj, opts.hat) end

	-- remove all textures, if required
	if opts.rt then aObj:removeTextures(opts.obj) end

	-- setup offset values
	opts.ofs = opts.ofs or 0
	local xOfs1 = opts.x1 or opts.ofs * -1
	local yOfs1 = opts.y1 or opts.ofs
	local xOfs2 = opts.x2 or opts.ofs
	local yOfs2 = opts.y2 or opts.ofs * -1

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
	aObj.skinFrame[opts.obj] = skinFrame

	-- handle header, if required
	if opts.hdr then hideHeader(opts.obj) end

	-- setup applySkin options
	opts.aso = opts.aso or {}
	opts.aso.obj = skinFrame

	-- handle no Border, if required
	if opts.noBdr then opts.aso.bba = 0 end

	-- skin the frame using supplied options
	aObj:applySkin(opts.aso)

	-- adjust frame level
	local success, err = pcall(LowerFrameLevel, skinFrame) -- catch any error, doesn't matter if already 0
	if not success then RaiseFrameLevel(opts.obj) end -- raise parent's Frame Level if 0

	 -- make sure it's lower than its parent's Frame Strata
	if opts.bg then skinFrame:SetFrameStrata("BACKGROUND") end

	-- skin the buttons unless not required
	if not opts.nb then aObj:skinAllButtons{obj=opts.obj, bgen=opts.bgen, anim=opts.anim, as=opts.bas} end

	-- reparent skinFrame to avoid whiteout issues caused by animations
	if opts.anim then
		aObj.skinFrame[opts.obj]:SetParent(UIParent)
		-- hook Show and Hide methods
		aObj:SecureHook(opts.obj, "Show", function(this) aObj.skinFrame[this]:Show() end)
		aObj:SecureHook(opts.obj, "Hide", function(this) aObj.skinFrame[this]:Hide() end)
		if not opts.obj:IsShown() then aObj.skinFrame[opts.obj]:Hide() end
	end

	-- remove inset textures
	if opts.ri then aObj:removeInset(opts.obj.Inset) end

	return skinFrame

end

function aObj:addSkinFrame(...)

	opts = select(1, ...)

--@alpha@
	assert(opts, "Missing object aSF\n"..debugstack())
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

	return __addSkinFrame(opts)

end

function aObj:applyGradient(obj, fh, invert, rotate)

	-- don't apply a gradient if required
	if not prdb.Gradient.char then
		for _, v in pairs(self.gradFrames["c"]) do
			if v == obj then return end
		end
	end
	if not prdb.Gradient.ui then
		for _, v in pairs(self.gradFrames["u"]) do
			if v == obj then return end
		end
	end
	if not prdb.Gradient.npc then
		for _, v in pairs(self.gradFrames["n"]) do
			if v == obj then return end
		end
	end
	if not prdb.Gradient.skinner then
		for _, v in pairs(self.gradFrames["s"]) do
			if v == obj then return end
		end
	end

	invert = invert or aObj.db.profile.Gradient.invert
	rotate = rotate or aObj.db.profile.Gradient.rotate

	if not obj.tfade then obj.tfade = obj:CreateTexture(nil, "BORDER") end
	obj.tfade:SetTexture(self.gradientTex)

	objHeight = ceil(obj:GetHeight())
	if prdb.FadeHeight.enable and (prdb.FadeHeight.force or not fh) then
		-- set the Fade Height if not already passed to this function or 'forced'
		-- making sure that it isn't greater than the frame height
		fh = prdb.FadeHeight.value <= objHeight and prdb.FadeHeight.value or objHeight
	end

	obj.tfade:ClearAllPoints()
	if not invert -- fade from top
	and not rotate
	then
		obj.tfade:SetPoint("TOPLEFT", obj, "TOPLEFT", 4, -4)
		if fh then obj.tfade:SetPoint("BOTTOMRIGHT", obj, "TOPRIGHT", -4, -(fh - 4))
		else obj.tfade:SetPoint("BOTTOMRIGHT", obj, "BOTTOMRIGHT", -4, 4) end
	elseif invert -- fade from bottom
	and not rotate
	then
		obj.tfade:SetPoint("BOTTOMLEFT", obj, "BOTTOMLEFT", 4, 4)
		if fh then obj.tfade:SetPoint("TOPRIGHT", obj, "BOTTOMRIGHT", -4, (fh - 4))
		else obj.tfade:SetPoint("TOPRIGHT", obj, "TOPRIGHT", -4, -4) end
	elseif not invert -- fade from right
	and rotate
	then
		obj.tfade:SetPoint("TOPRIGHT", obj, "TOPRIGHT", -4, -4)
		if fh then obj.tfade:SetPoint("BOTTOMLEFT", obj, "BOTTOMRIGHT", -(fh - 4), 4)
		else obj.tfade:SetPoint("BOTTOMLEFT", obj, "BOTTOMLEFT", 4, 4) end
	elseif invert -- fade from left
	and rotate
	then
		obj.tfade:SetPoint("TOPLEFT", obj, "TOPLEFT", 4, -4)
		if fh then obj.tfade:SetPoint("BOTTOMRIGHT", obj, "BOTTOMLEFT", fh - 4, 4)
		else obj.tfade:SetPoint("BOTTOMRIGHT", obj, "BOTTOMRIGHT", -4, 4) end
	end

	obj.tfade:SetBlendMode("ADD")
	obj.tfade:SetGradientAlpha(self:getGradientInfo(invert, rotate))

end

function aObj:applyTexture(obj)

	obj.tbg = obj:CreateTexture(nil, "BORDER")
	obj.tbg:SetTexture(self.LSM:Fetch("background", self.bgTex), true) -- have to use true for tiling to work
	obj.tbg:SetBlendMode("ADD") -- use existing frame alpha setting
	-- allow for border inset
	local bdi = self.db.profile.BdInset
	obj.tbg:SetPoint("TOPLEFT", obj, "TOPLEFT", bdi, -bdi)
	obj.tbg:SetPoint("BOTTOMRIGHT", obj, "BOTTOMRIGHT", -bdi, bdi)
	-- the texture will be stretched if the following tiling methods are set to false
	obj.tbg:SetHorizTile(self.db.profile.BgTile)
	obj.tbg:SetVertTile(self.db.profile.BgTile)

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
		invert = invert gradient
		rotate = rotate gradient
		ebc = Use EditBox Colours
--]]
--@alpha@
	assert(opts.obj, "Missing object __aS\n"..debugstack())
--@end-alpha@

	local hasIOT = assert(opts.obj.IsObjectType, "The Object passed isn't a Frame") -- throw an error here to get its original location reported
	if hasIOT and not opts.obj:IsObjectType("Frame") then
		if aObj.db.profile.Errors then
			aObj:CustomPrint(1, 0, 0, "Error skinning", opts.obj.GetName and opts.obj:GetName() or opts.obj, "not a Frame or subclass of Frame: ", opts.obj:GetObjectType())
			return
		end
	end

	-- store frame obj, if required
	if opts.ft then aObj:add2Table(aObj.gradFrames[opts.ft], opts.obj) end

	-- make all textures transparent, if required
	if opts.kfs then aObj:keepFontStrings(opts.obj) end

	-- setup the backdrop
	opts.obj:SetBackdrop(aObj.Backdrop[opts.bd or 1])
	if not opts.ebc then
		-- colour the backdrop if required
		local r, g, b, a = unpack(aObj.bColour)
		opts.obj:SetBackdropColor(r, g, b, opts.ba or a)
		r, g, b, a = unpack(aObj.bbColour)
		opts.obj:SetBackdropBorderColor(r, g, b, opts.bba or a)
	else
		opts.obj:SetBackdropBorderColor(.2, .2, .2, 1)
		opts.obj:SetBackdropColor(.1, .1, .1, 1)
	end

	-- fix for backdrop textures not tiling vertically
	-- using info from here: http://boss.wowinterface.com/forums/showthread.php?p=185868
	if aObj.db.profile.BgUseTex then
		if not opts.obj.tbg then aObj:applyTexture(opts.obj) end
	elseif opts.obj.tbg then
		opts.obj.tbg = nil -- remove background texture if it exists
	end

	-- handle header, if required
	if opts.hdr then hideHeader(opts.obj) end

	-- apply the Gradient, if required
	if not opts.ng then
		aObj:applyGradient(opts.obj, opts.fh, opts.invert, opts.rotate)
	end

end

function aObj:applySkin(...)

	opts = select(1, ...)

--@alpha@
	assert(opts, "Missing object aS\n"..debugstack())
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
	assert(opts.obj, "Missing object __aH\n"..debugstack())
--@end-alpha@
	if opts.adj == 0 then return end

	if not strfind(tostring(opts.adj), "+") then -- if not negative value
		opts.obj:SetHeight(opts.obj:GetHeight() + opts.adj)
	else
		opts.adj = opts.adj * -1 -- make it positive
		opts.obj:SetHeight(opts.obj:GetHeight() - opts.adj)
	end

end

function aObj:adjHeight(...)

	opts = select(1, ...)

--@alpha@
	assert(opts, "Missing object aH\n"..debugstack())
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

local function __adjWidth(opts)
--[[
	Calling parameters:
		obj = object (Mandatory)
		adj = value to adjust width by
--]]
--@alpha@
	assert(opts.obj, "Missing object __aW\n"..debugstack())
--@end-alpha@
	if opts.adj == 0 then return end

	if not strfind(tostring(opts.adj), "+") then -- if not negative value
		opts.obj:SetWidth(opts.obj:GetWidth() + opts.adj)
	else
		opts.adj = opts.adj * -1 -- make it positive
		opts.obj:SetWidth(opts.obj:GetWidth() - opts.adj)
	end

end

function aObj:adjWidth(...)

	opts = select(1, ...)

--@alpha@
	assert(opts, "Missing object aW\n"..debugstack())
--@end-alpha@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if type(rawget(opts, 0)) == "userdata" and type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = select(1, ...) and select(1, ...) or nil
		opts.adj = select(2, ...) and select(2, ...) or 0
	end
	__adjWidth(opts)

end

function aObj:glazeStatusBar(statusBar, fi, bgTex, otherTex)
--@alpha@
	assert(statusBar and statusBar:IsObjectType("StatusBar"), "Not a StatusBar\n"..debugstack())
--@end-alpha@

--	if not statusBar or not statusBar:IsObjectType("StatusBar") then return end

	statusBar:SetStatusBarTexture(self.sbTexture)

	if not self.sbGlazed[statusBar] then
		self.sbGlazed[statusBar] = {}
	end
	local sbG = self.sbGlazed[statusBar]

	-- change StatusBar Texture's draw layer if required
	local sbTex = statusBar:GetStatusBarTexture()
	local sbDL = sbTex:GetDrawLayer()
	if sbDL == "BACKGROUND" then sbTex:SetDrawLayer("BORDER") end
	-- fix for tiling introduced in 3.3.3 (Thanks to foreverphk)
	sbTex:SetHorizTile(false)
	sbTex:SetVertTile(false)

	if fi then
		if not sbG.bg then
			sbG.bg = bgTex or statusBar:CreateTexture(nil, "BACKGROUND")
			sbG.bg:SetTexture(self.sbTexture)
			sbG.bg:SetVertexColor(unpack(self.sbColour))
			if not bgTex then
				sbG.bg:SetPoint("TOPLEFT", statusBar, "TOPLEFT", fi, -fi)
				sbG.bg:SetPoint("BOTTOMRIGHT", statusBar, "BOTTOMRIGHT", -fi, fi)
			end
		end
	end
	-- apply texture and store other texture objects
	if otherTex
	and type(otherTex) == "table"
	then
		for _, tex in pairs(otherTex) do
			tex:SetTexture(self.sbTexture)
			tex:SetVertexColor(unpack(self.sbColour))
			sbG[#sbG + 1] = tex
		end
	end

end

function aObj:keepFontStrings(obj, hide)
--@alpha@
	assert(obj, "Missing object kFS\n"..debugstack())
--@end-alpha@

--	if not frame then return end

	for _, reg in pairs{obj:GetRegions()} do
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

function aObj:keepRegions(obj, regions)
--@alpha@
	assert(obj, "Missing object kR\n"..debugstack())
--@end-alpha@

--	if not frame then return end
	regions = revTable(regions)

	for k, reg in pairs{obj:GetRegions()} do
		-- if we have a list, hide the regions not in that list
		if regions
		and not regions[k]
		then
			reg:SetAlpha(0)
--@debug@
			if reg:IsObjectType("FontString") then self:Debug("kr FS: [%s, %s]", obj:GetName() or "<Anon>", k) end
--@end-debug@
		end
	end

end

function aObj:makeMFRotatable(modelFrame)
--@alpha@
	assert(modelFrame and modelFrame:IsObjectType("PlayerModel"), "Not a PlayerModel\n"..debugstack())
--@end-alpha@

	-- Don't make Model Frames Rotatable if CloseUp is loaded
	if IsAddOnLoaded("CloseUp") then return end

	--frame:EnableMouseWheel(true)
	modelFrame:EnableMouse(true)
	modelFrame.draggingDirection = nil
	modelFrame.cursorPosition = {}

	-- hide rotation buttons
	for _, child in pairs{modelFrame:GetChildren()} do
		objName = child:GetName()
		if objName and objName:find("Rotate") then
			child:Hide()
		end
	end

	if not self:IsHooked(modelFrame, "OnUpdate") then
		self:SecureHookScript(modelFrame, "OnUpdate", function(this, elapsedTime, ...)
			if this.dragging then
				local x, y = GetCursorPosition()
				if this.cursorPosition.x > x then
					Model_RotateLeft(this, (this.cursorPosition.x - x) * elapsedTime * 2)
				elseif this.cursorPosition.x < x then
					Model_RotateRight(this, (x - this.cursorPosition.x) * elapsedTime * 2)
				end
				this.cursorPosition.x, this.cursorPosition.y = GetCursorPosition()
			end
		end)
		self:SecureHookScript(modelFrame, "OnMouseDown", function(this, button)
			if button == "LeftButton" then
				this.dragging = true
				this.cursorPosition.x, this.cursorPosition.y = GetCursorPosition()
			end
		end)
		self:SecureHookScript(modelFrame, "OnMouseUp", function(this, button)
			if this.dragging then
				this.dragging = false
				this.cursorPosition.x, this.cursorPosition.y = nil
			end
		end)
	end

	--[[ MouseWheel to zoom Modelframe - in/out works, but needs to be fleshed out
	modelFrame:SetScript("OnMouseWheel", function()
		local xPos, yPos, zPos = frame:GetPosition()
		if arg1 == 1 then
			modelFrame:SetPosition(xPos+00.1, 0, 0)
		else
			modelFrame:SetPosition(xPos-00.1, 0, 0)
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
	assert(opts.obj, "Missing object __mO\n"..debugstack())
--@end-alpha@

	if not opts.obj then return end

	local point, relTo, relPoint, xOfs, yOfs = opts.obj:GetPoint()

	-- aObj:Debug("__mO: [%s, %s, %s, %s, %s]", point, relTo, relPoint, xOfs, yOfs)

	-- handle no Point info
	if not point then return end

	relTo = opts.relTo or relTo
--@alpha@
	assert(relTo, "__moveObject relTo is nil\n"..debugstack())
--@end-alpha@
	-- Workaround for relativeTo crash
	if not relTo then
		if aObj.db.profile.Warnings then
			aObj:CustomPrint(1, 0, 0, "moveObject (relativeTo) is nil: %s", opts.obj)
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

function aObj:moveObject(...)

	opts = select(1, ...)

--@alpha@
	assert(opts, "Missing object mO\n"..debugstack())
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

function aObj:removeRegions(obj, regions)
--@alpha@
	assert(obj, "Missing object rR\n"..debugstack())
--@end-alpha@

--	if not frame then return end

	regions = revTable(regions)

	for k, reg in pairs{obj:GetRegions()} do
		if not regions
		or regions
		and regions[k]
		then
			reg:SetAlpha(0)
--@debug@
			if reg:IsObjectType("FontString") then self:Debug("rr FS: [%s, %s]", obj:GetName() or "<Anon>", k) end
--@end-debug@
		end
	end

end

function aObj:removeTextures(obj)
--@alpha@
	assert(obj, "Missing object rT\n"..debugstack())
--@end-alpha@

	for _, reg in pairs{obj:GetRegions()} do
		if not reg:IsObjectType("FontString") then
			reg:SetTexture(nil)
		end
	end

end

function aObj:setActiveTab(tabSF)
--@alpha@
	assert(tabSF, "Missing object sAT\n"..debugstack())
--@end-alpha@

	if not tabSF then return end
	if not tabSF.tfade then return end

	tabSF.tfade:SetTexture(self.gradientTex)
	tabSF.tfade:SetGradientAlpha(self:getGradientInfo(prdb.Gradient.invert, prdb.Gradient.rotate))

	if not tabSF.ignore and not tabSF.grown then
		local point, relativeTo, relativePoint, xOfs, yOfs
		if not tabSF.up then
			point, relativeTo, relativePoint, xOfs, yOfs = tabSF:GetPoint(2)
			tabSF:SetPoint("BOTTOMRIGHT", relativeTo, "BOTTOMRIGHT", xOfs, yOfs - 6)
		else
			point, relativeTo, relativePoint, xOfs, yOfs = tabSF:GetPoint(1)
			tabSF:SetPoint("TOPLEFT", relativeTo, "TOPLEFT", xOfs, yOfs + 6)
		end
		tabSF.grown = true
	end

end

function aObj:setInactiveTab(tabSF)
--@alpha@
	assert(tabSF, "Missing object sIT\n"..debugstack())
--@end-alpha@

	if not tabSF then return end
	if not tabSF.tfade then return end

	tabSF.tfade:SetTexture(self.itTex)
	tabSF.tfade:SetAlpha(1)
	if not tabSF.ignore and tabSF.grown then
		local point, relativeTo, relativePoint, xOfs, yOfs
		if not tabSF.up then
			point, relativeTo, relativePoint, xOfs, yOfs = tabSF:GetPoint(2)
			tabSF:SetPoint("BOTTOMRIGHT", relativeTo, "BOTTOMRIGHT", xOfs, yOfs + 6)
		else
			point, relativeTo, relativePoint, xOfs, yOfs = tabSF:GetPoint(1)
			tabSF:SetPoint("TOPLEFT", relativeTo, "TOPLEFT", xOfs, yOfs - 6)
		end
		tabSF.grown = nil
	end

end

function aObj:setTTBBC()

	if self.db.profile.Tooltips.border == 1 then
		return unpack(self.tbColour)
	else
		return unpack(self.bbColour)
	end

end

function aObj:shrinkBag(obj, bpMF)
--@alpha@
	assert(obj, "Missing object sB\n"..debugstack())
--@end-alpha@

	if not obj then return end

	objName = obj:GetName()
	local bgTop = _G[objName.."BackgroundTop"]
	if floor(bgTop:GetHeight()) == 256 then -- this is the backpack
		if bpMF then -- is this a backpack Money Frame
			local yOfs = select(5, _G[objName.."MoneyFrame"]:GetPoint())
			if floor(yOfs) == -216 or floor(yOfs) == -217 then -- is it still in its original position
				self:moveObject(_G[objName.."MoneyFrame"], nil, nil, "+", 22)
			end
		end
		self:moveObject(_G[objName.."Item1"], nil, nil, "+", 19)
	end
	if ceil(bgTop:GetHeight()) == 94 then self:adjHeight{obj=obj, adj=-20} end
	if ceil(bgTop:GetHeight()) == 86 then self:adjHeight{obj=obj, adj=-20} end
	if ceil(bgTop:GetHeight()) == 72 then self:adjHeight{obj=obj, adj=2} end -- 6, 10 or 14 slot bag

	self:adjWidth{obj=obj, adj=-10}
	self:moveObject{obj=_G[objName.."Item1"], x=3}

	objHeight = ceil(obj:GetHeight())
	-- use default fade height
	local fh = prdb.ContainerFrames.fheight <= objHeight and prdb.ContainerFrames.fheight or objHeight

	if prdb.FadeHeight.enable and prdb.FadeHeight.force then
	-- set the Fade Height
	-- making sure that it isn't greater than the frame height
		fh = prdb.FadeHeight.value <= objHeight and prdb.FadeHeight.value or objHeight
	end

	if fh and obj.tfade then obj.tfade:SetPoint("BOTTOMRIGHT", obj, "TOPRIGHT", -4, -fh) end

end

local function __skinDropDown(opts)
--[[
	Calling parameters:
		obj = object (Mandatory)
		noSkin = don't skin the DropDown
		noMove = don't move button & Text
		moveTex = move Texture up
		mtx = move Texture left/right
		mty = move Texture up/down
--]]
--@alpha@
	assert(opts.obj, "Missing object __sDD\n"..debugstack())
--@end-alpha@

	if opts.obj and opts.obj.GetName and opts.obj:GetName() then -- if named object
		if opts.obj:GetName():find("tekKonfigDropdown") -- ignore tekKonfigDropdown
		or not _G[opts.obj:GetName().."Left"] -- ignore Az DropDowns
		and not opts.obj.leftTexture -- handle FeedbackUI ones
		then
			return
		end
	else
		return
	end

	-- don't skin it twice
	if aObj.skinned[opts.obj] then return end

	if not aObj.db.profile.TexturedDD or opts.noSkin then aObj:keepFontStrings(opts.obj) return end

	local mTex, btn, txt
	if opts.obj.leftTexture then
		opts.obj.leftTexture:SetAlpha(0)
		opts.obj.rightTexture:SetAlpha(0)
		mTex = opts.obj.middleTexture
		btn = opts.obj.button
		txt = opts.obj.label
	else
		_G[opts.obj:GetName().."Left"]:SetAlpha(0)
		_G[opts.obj:GetName().."Right"]:SetAlpha(0)
		mTex = _G[opts.obj:GetName().."Middle"]
		btn = _G[opts.obj:GetName().."Button"]
		txt = _G[opts.obj:GetName().."Text"]
	end
	mTex:SetTexture(aObj.itTex)
	mTex:SetHeight(19)

	-- move Button Left and down, Text down
	if not opts.noMove then
		aObj:moveObject{obj=btn, x=-6, y=-2}
		aObj:moveObject{obj=txt, y=-2}
	end

	local mtx = opts.mtx or 0
	local mty = opts.moveTex and 2 or (opts.mty or 0)
	if mtx ~= 0 or mty ~= 0 then aObj:moveObject{obj=mTex, x=mtx, y=mty} end

end

function aObj:skinDropDown(...)

	opts = select(1, ...)

--@alpha@
	assert(opts, "Missing object sDD\n"..debugstack())
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
		noInsert = don't change the Inserts
		move = move the edit box, left and up
		x = move the edit box left/right
		y = move the edit box up/down
		mi = move icon to the right
--]]
--@alpha@
	assert(opts.obj and opts.obj:IsObjectType("EditBox"), "Not an EditBox\n"..debugstack())
--@end-alpha@

	-- don't skin it twice
	if aObj.skinned[opts.obj] then return end

	opts.x = opts.x or 0
	opts.y = opts.y or 0

	kRegions = CopyTable(aObj.ebRegions)
	if opts.regs then
		for _, v in pairs(opts.regs) do
			aObj:add2Table(kRegions, v)
		end
	end
	aObj:keepRegions(opts.obj, kRegions)

	if not opts.noInsert then
		-- adjust the left & right text inserts
		local l, r, t, b = opts.obj:GetTextInsets()
		opts.obj:SetTextInsets(l + 5, r + 5, t, b)
	end

	-- change height, if required
	if not (opts.noHeight or opts.obj:IsMultiLine()) then opts.obj:SetHeight(24) end

	-- change width, if required
	if not opts.noWidth then opts.obj:SetWidth(opts.obj:GetWidth() + 5) end

	-- apply the backdrop
	if not opts.noSkin then aObj:skinUsingBD{obj=opts.obj} end

	-- move to the left & up, if required
	if opts.move then opts.x, opts.y = -2, 2 end

	-- move left/right & up/down, if required
	if opts.x ~= 0 or opts.y ~= 0 then aObj:moveObject{obj=opts.obj, x=opts.x, y=opts.y} end

	-- move the search icon to the right, if required
	if opts.mi then
		if opts.obj.searchIcon then
			aObj:moveObject{obj=opts.obj.searchIcon, x=3} -- e.g. BagItemSearchBox
		elseif opts.obj.icon then
			aObj:moveObject{obj=opts.obj.icon, x=3} -- e.g. FriendsFrameBroadcastInput
		else
			aObj:moveObject{obj=_G[opts.obj:GetName().."SearchIcon"], x=3} -- e.g. TradeSkillFrameSearchBox
		end
	end


end

function aObj:skinEditBox(...)

	opts = select(1, ...)

--@alpha@
	assert(opts, "Missing object sEB\n"..debugstack())
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

function aObj:skinFFToggleTabs(tabName, tabCnt, noHeight)

	local togTab
	for i = 1, tabCnt or 3 do
		togTab = _G[tabName..i]
		if not togTab then break end -- handle missing Tabs (e.g. Muted)
		if not self.skinned[togTab] then -- don't skin it twice
			self:keepRegions(togTab, {7, 8}) -- N.B. regions 7 & 8 are text & highlight
			if not noHeight then self:adjHeight{obj=togTab, adj=-5}	end
			self:addSkinFrame{obj=togTab, y1=-2, x2=2, y2=-2}
		end
	end

end

function aObj:skinFFColHeads(buttonName, noCols)

	noCols = noCols or 4
	for i = 1, noCols do
		self:removeRegions(_G[buttonName..i], {1, 2, 3})
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
	assert(opts.obj, "Missing object __sMF\n"..debugstack())
--@end-alpha@

	-- don't skin it twice
	if aObj.skinned[opts.obj] then return end

	local cbMode = GetCVarBool("colorblindMode")

	local obj
	for k, v in pairs{"Gold", "Silver", "Copper"} do
		obj = _G[opts.obj:GetName()..v]
		aObj:skinEditBox{obj=obj, regs={9, 10}, noHeight=true, noWidth=true} -- N.B. region 9 is the icon, 10 is text
		-- move label to the right for colourblind mode
		if k ~= 1 or opts.moveGIcon then
			aObj:moveObject{obj=obj.texture, x=10}
			aObj:moveObject{obj=obj.label, x=10}
--			aObj:moveObject{obj=aObj:getRegion(fName, 9), x=10}
		end
		if not opts.noWidth and k ~= 1 then
			aObj:adjWidth{obj=obj, adj=5}
		end
		if v == "Gold" and opts.moveGEB then
			aObj:moveObject{obj=obj, x=-8}
		end
		if v == "Silver" and opts.moveSEB then
			aObj:moveObject{obj=obj, x=-10}
		end
	end

end

function aObj:skinMoneyFrame(...)

	opts = select(1, ...)

--@alpha@
	assert(opts, "Missing object sMF\n"..debugstack())
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
	if aObj.skinned[opts.obj] then return end

	-- remove all the object's regions except text ones, if required
	if not opts.noRR then aObj:keepFontStrings(opts.obj) end

	-- get the actual ScrollBar object
	local sBar = opts.sbObj and opts.sbObj or _G[opts.obj:GetName()..(opts.sbPrefix or "").."ScrollBar"]

	-- skin it
	aObj:skinUsingBD{obj=sBar, size=opts.size}

end

function aObj:skinScrollBar(...)

	opts = select(1, ...)

--@alpha@
	assert(opts, "Missing object sSB\n"..debugstack())
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
		size = backdrop size to use (2 - wide, 3 - medium, 4 - narrow) [default is 3]
		adj = width reduction required
--]]
--@alpha@
	assert(opts.obj and opts.obj:IsObjectType("Slider"), "Not a Slider\n"..debugstack())
--@end-alpha@

	-- don't skin it twice
	if aObj.skinned[opts.obj] then return end

	aObj:keepFontStrings(opts.obj)
	opts.obj:SetAlpha(1)
	opts.obj:GetThumbTexture():SetAlpha(1)

	aObj:skinUsingBD{obj=opts.obj, size=opts.size}

	-- adjust width if required
	if opts.adj then aObj:adjWidth{obj=opts.obj, adj=opts.adj} end

end

function aObj:skinSlider(...)

	opts = select(1, ...)

--@alpha@
	assert(opts, "Missing object sS\n"..debugstack())
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

local function __skinTabs(opts)
--[[
	Calling parameters:
		obj = object (Mandatory)
		suffix = tab name suffix
		regs = regions to keep
		ignore = ignore size changes
		up = tabs grow upwards
		lod = LoD, requires textures to be set 1st time through
		x1 = X offset for TOPLEFT
		y1 = Y offset for TOPLEFT
		x2 = X offset for BOTTOMRIGHT
		y2 = Y offset for BOTTOMRIGHT
		hx - X offset for Highlight
		hy - Y offset for Highlight

--]]
--@alpha@
	assert(opts.obj and opts.obj:IsObjectType("Frame"), "Not a Frame\n"..debugstack())
--@end-alpha@

	-- don't skin it twice
	if aObj.skinned[opts.obj] then return end

	tabName = opts.obj:GetName().."Tab"..(opts.suffix or "")

	kRegions = {7, 8} -- N.B. region 7 is text, 8 is highlight
	if opts.regs then
		for _, v in pairs(opts.regs) do
			aObj:add2Table(kRegions, v)
		end
	end

	local xOfs1 = opts.x1 or 6
	local yOfs1 = opts.y1 or 0
	local xOfs2 = opts.x2 or -6
	local yOfs2 = opts.y2 or 2

	for i = 1, opts.obj.numTabs do
		tab = _G[tabName..i]
		if opts.hx or opts.hy then -- if highlight texture needs to be moved (e.g. FriendsFrameTabHeader tabs)
			tex = _G[tabName..i.."HighlightTexture"]
			aObj:moveObject{obj=tex, x=opts.hx or 0, y=opts.hy or 0}
		end
		aObj:keepRegions(tab, kRegions)
		tabSF = aObj:addSkinFrame{obj=tab, ft=ftype, noBdr=aObj.isTT, x1=xOfs1, y1=yOfs1, x2=xOfs2, y2=yOfs2}
		tabSF.ignore = opts.ignore -- ignore size changes
		tabSF.up = opts.up -- tabs grow upwards
		if opts.lod then -- set textures here first time thru as it's LoD
			if i == 1 then
				if aObj.isTT then aObj:setActiveTab(tabSF) end
			else
				if aObj.isTT then aObj:setInactiveTab(tabSF) end
			end
		end
	end
	aObj.tabFrames[opts.obj] = true

end

function aObj:skinTabs(...)

	opts = select(1, ...)

--@alpha@
	assert(opts, "Missing object sS\n"..debugstack())
--@end-alpha@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if type(rawget(opts, 0)) == "userdata" and type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = select(1, ...) and select(1, ...) or nil
	end
	__skinTabs(opts)

end

function aObj:skinTooltip(obj)
	if not self.db.profile.Tooltips.skin then return end
--@alpha@
	assert(obj, "Missing object sT\n"..debugstack())
--@end-alpha@

	if not obj then return end

	if not prdb.Gradient.ui then return end

	-- add background texture if required
	if self.db.profile.Tooltips.style == 3 then
		if self.db.profile.BgUseTex then
			if not obj.tbg then self:applyTexture(obj) end
		elseif obj.tbg then
			obj.tbg = nil -- remove background texture if it exists
		end
	end

	objHeight = ceil(obj:GetHeight())

	if not obj.tfade then obj.tfade = obj:CreateTexture(nil, "BORDER") end
	obj.tfade:SetTexture(self.gradientTex)

	if prdb.Tooltips.style == 1 then
		obj.tfade:SetPoint("TOPLEFT", obj, "TOPLEFT", 6, -6)
		obj.tfade:SetPoint("BOTTOMRIGHT", obj, "TOPRIGHT", -6, -27)
	elseif prdb.Tooltips.style == 2 then
		obj.tfade:SetPoint("TOPLEFT", obj, "TOPLEFT", 4, -4)
		obj.tfade:SetPoint("BOTTOMRIGHT", obj, "BOTTOMRIGHT", -4, 4)
	else
		obj.tfade:SetPoint("TOPLEFT", obj, "TOPLEFT", 4, -4)
		-- set the Fade Height making sure that it isn't greater than the frame height
		local fh = prdb.FadeHeight.value <= objHeight and prdb.FadeHeight.value or objHeight
		obj.tfade:SetPoint("BOTTOMRIGHT", obj, "TOPRIGHT", -4, -(fh - 4))
		obj:SetBackdropColor(unpack(self.bColour))
	end

	obj.tfade:SetBlendMode("ADD")
	obj.tfade:SetGradientAlpha(self:getGradientInfo(prdb.Gradient.invert, prdb.Gradient.rotate))

	-- Check to see if we need to colour the Border
	if not self.ttBorder then
		local r, g, b, a
		for _, tip in pairs(self.ttCheck) do
			if tip == obj:GetName() then
				r, g, b, a = obj:GetBackdropBorderColor()
				r = ("%.2f"):format(r)
				g = ("%.2f"):format(g)
				b = ("%.2f"):format(b)
				a = ("%.2f"):format(a)
				if r ~= "1.00" or g ~= "1.00" or b ~= "1.00" or a ~= "1.00" then return end
			end
		end
	end

	obj:SetBackdropBorderColor(self:setTTBBC())

end

local function __skinUsingBD(opts)
--[[
	Calling parameters:
		obj = object (Mandatory)
		size = backdrop size to use (2 - wide, 3 - medium, 4 - narrow)
--]]
--@alpha@
	assert(opts.obj, "Missing object __sUBD\n"..debugstack())
--@end-alpha@

	opts.size = opts.size or 3 -- default to medium

	opts.obj:SetBackdrop(aObj.Backdrop[opts.size])
	opts.obj:SetBackdropBorderColor(.2, .2, .2, 1)
	opts.obj:SetBackdropColor(.1, .1, .1, 1)

end

function aObj:skinUsingBD(...)

	opts = select(1, ...)

--@alpha@
	assert(opts, "Missing object sUBD\n"..debugstack())
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

function aObj:skinUsingBD2(obj)

	self:skinUsingBD{obj=obj, size=2}

end
