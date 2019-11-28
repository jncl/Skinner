local aName, aObj = ...
local _G = _G

local CopyTable, LibStub = _G.CopyTable, _G.LibStub

do
	-- check to see if required libraries are loaded
	_G.assert(LibStub, aName .. " requires LibStub")
	local lTab = {"CallbackHandler-1.0", "LibDataBroker-1.1", "LibDBIcon-1.0", "AceAddon-3.0", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceDB-3.0", "AceDBOptions-3.0", "AceLocale-3.0", "AceGUI-3.0",  "AceConfig-3.0", "AceConfigRegistry-3.0", "AceConfigCmd-3.0", "AceConfigDialog-3.0", "LibSharedMedia-3.0"}
	local hasError
	for _, lib in _G.pairs(lTab) do
		hasError = not _G.assert(LibStub:GetLibrary(lib, true), aName .. " requires " .. lib)
	end
	lTab = nil
	if hasError then return end

	-- create the addon
	LibStub:GetLibrary("AceAddon-3.0"):NewAddon(aObj, aName, "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")

	local buildInfo = {
		beta    = {"9.0.0", 99999},
		classic = {"1.13.2", 32600},
		ptr     = {"8.3.0", 32593},
		retail  = {"8.2.5", 32638},
     	}

	buildInfo.curr = {_G.GetBuildInfo()}

	local agentUID = _G.GetCVar("agentUID")
	-- check to see which server we are running on
	aObj.isClassic = agentUID:find("wow_classic") and true or false
	aObj.isBeta    = agentUID:find("_beta") and true or false
	aObj.isPTR     = agentUID:find("wow_ptr") and true or false
	-- check current build number against live, if greater then it's a patch
	aObj.isPatch = not aObj.isClassic and not aObj.isBeta and not aObj.isPTR and _G.tonumber(buildInfo.curr[2]) > buildInfo.retail[2] and true or false

--@alpha@
	local vType = aObj.isClassic and "Classic" or aObj.isBeta and "Beta" or aObj.isPTR and "PTR" or "Retail"
	aObj:Printf("%s, %s, %s, %s, %s, %s, %s", buildInfo[vType:lower()][1], buildInfo[vType:lower()][2], buildInfo.curr[1], buildInfo.curr[2], buildInfo.curr[3], buildInfo.curr[4] , agentUID)
	vType = aObj.isPatch and "Patched" or vType
	_G.DEFAULT_CHAT_FRAME:AddMessage(aName .. ": Detected that we're running on a " .. vType .. " version", 0.75, 0.5, 0.25, nil, true)
	vType = nil
--@end-alpha@
	agentUID = nil

	-- handle PTR changes going Live
	if aObj.isPatch
	and buildInfo.curr[1] > buildInfo.retail[1]
	then
		aObj.isPTR = true
	end

	_G.wipe(buildInfo)

	-- define tables to hold skin functions
	aObj.blizzFrames = {p = {}, n = {}, u = {}, opt = {}}
	aObj.blizzLoDFrames = {p = {}, n = {}, u = {}}

end

function aObj:OnInitialize()
--@debug@
	self:Print("Debugging is enabled")
	self:Debug("Debugging is enabled")
--@end-debug@

--@alpha@
	if self.isClassic then
		self:Debug("Classic detected")
	elseif self.isBeta then
		self:Debug("Beta detected")
	elseif self.isPTR then
		self:Debug("PTR detected")
	elseif self.isPatch then
		self:Debug("Patch detected")
	end
--@end-alpha@

	-- add callbacks
	self.callbacks = LibStub:GetLibrary("CallbackHandler-1.0"):New(aObj)
	-- get Locale
	self.L = LibStub:GetLibrary("AceLocale-3.0"):GetLocale(aName)
	-- pointer to LibSharedMedia-3.0 library
	self.LSM = LibStub:GetLibrary("LibSharedMedia-3.0")
	-- pointer to LibDBIcon-1.0 library
	self.DBIcon = LibStub:GetLibrary("LibDBIcon-1.0")
	-- store player class
	self.uCls = _G.select(2, _G.UnitClass("player"))
	-- store player name
	self.uName = _G.UnitName("player")

	-- setup the default DB values and register them
	self:checkAndRun("SetupDefaults", "opt", false, true)
	-- store shortcut
	self.prdb = self.db.profile
	local dflts = self.db.defaults.profile

	-- convert any old settings
	if _G.type(self.prdb.MinimapButtons) == "boolean" then
		self.prdb.MinimapButtons = {skin = true, style = false}
	end
	-- change options name
	if self.prdb.ClassColour
	or self.prdb.ClassColours
	then
		self.prdb.ClassClrBd = self.prdb.ClassColour or self.prdb.ClassColours
		self.prdb.ClassColour = nil
		self.prdb.ClassColours = nil
	end
	-- treat GossipFrame & QuestFrame as one
	-- as they both change the quest text colours
	if not self.prdb.GossipFrame == self.prdb.QuestFrame then
		if not self.prdb.QuestFrame then
			self.prdb.GossipFrame = false
		else
			self.prdb.QuestFrame = false
		end
	end
	-- BattlefieldMm has been renamed BattlefieldMap
	if self.prdb.BattlefieldMm then
		self.prdb.BattlefieldMap = self.prdb.BattlefieldMm
		self.prdb.BattlefieldMm = nil
	end
	-- CommunitiesUI has been renamed to Communities
	if self.prdb.CommunitiesUI then
		self.prdb.Communities = self.prdb.CommunitiesUI
		self.prdb.CommunitiesUI = nil
	end
	-- PVPFrame has been renamed to PVPUI
	if self.prdb.PVPFrame then
		self.prdb.PVPUI = self.prdb.PVPFrame
		self.prdb.PVPFrame = nil
	end
	-- SideDressUpFrame is part of DressUpFrames
	if self.prdb.SideDressUpFrame then
		self.prdb.SideDressUpFrame = nil
	end
	-- ScriptErrors has been renamed to SharedBasicControls
	if self.prdb.ScriptErrors then
		self.prdb.SharedBasicControls = self.prdb.ScriptErrors
		self.prdb.ScriptErrors = nil
	end
	-- DropDownPanels renamed to UIDropDownMenu
	if self.prdb.DropDownPanels then
		self.prdb.UIDropDownMenu = self.prdb.DropDownPanels
		self.prdb.DropDownPanels = nil
	end
	-- DropDownButtons option has been removed
	if self.prdb.DropDownButttons then
		self.prdb.DropDownButtons = nil
	end

	-- setup the Addon's options
	self:checkAndRun("SetupOptions", "opt")

	-- register the default background texture
	self.LSM:Register("background", dflts.BdTexture, [[Interface\ChatFrame\ChatFrameBackground]])
	-- register the inactive tab texture
	self.LSM:Register("background", aName .. " Inactive Tab", [[Interface\AddOns\]] .. aName .. [[\Textures\inactive]])
	-- register the texture used for EditBoxes & ScrollBars
	self.LSM:Register("border", aName .. " Border", [[Interface\AddOns\]] .. aName .. [[\Textures\krsnik]])
	-- register the statubar texture used by Nameplates
	self.LSM:Register("statusbar", "Blizzard2", [[Interface\TargetingFrame\UI-TargetingFrame-BarFill]])

	-- Heading, Body & Ignored Text colours
	local c = self.prdb.HeadText
	self.HT = _G.CreateColor(c.r, c.g, c.b)
	c = self.prdb.BodyText
	self.BT = _G.CreateColor(c.r, c.g, c.b)
	c = self.prdb.IgnoredText
	self.IT = _G.CreateColor(c.r, c.g, c.b)
	-- The following variables are used by the GossipFrame & QuestFrame
	self.NORMAL_QUEST_DISPLAY = self.HT:WrapTextInColorCode("%s|r")
	self.TRIVIAL_QUEST_DISPLAY = self.BT:WrapTextInColorCode("%s (low level)|r")
	self.IGNORED_QUEST_DISPLAY = self.IT:WrapTextInColorCode("%s (ignored)|r")

	-- EditBox regions to keep
	self.ebRgns = {1, 2} -- 1 is text, 2 is a texture

	-- Gradient settings
	self.gradientTab = {self.prdb.Gradient.rotate and "HORIZONTAL" or "VERTICAL", .5, .5, .5, 1, .25, .25, .25, 0}
	self.gradientCBar = {self.prdb.Gradient.rotate and "HORIZONTAL" or "VERTICAL", .25, .25, .55, 1, 0, 0, 0, 1}
	self.gradientTex = self.LSM:Fetch("background", self.prdb.Gradient.texture)
	-- these are used to disable the gradient
	self.gradFrames = {["p"] = {}, ["u"] = {}, ["n"] = {}, ["s"] = {}, a = {}}

	-- backdrop for Frames etc
	self:setupBackdrop()

	self.Backdrop = {}
	self.Backdrop[1] = CopyTable(self.backdrop)
	-- wide backdrop for ScrollBars & EditBoxes (16,16,4)
	self.Backdrop[2] = CopyTable(self.backdrop)
	self.Backdrop[2].edgeFile = self.LSM:Fetch("border", aName .. " Border")
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
	-- this backdrop is for the BattlefieldMinimap/Minimap/Pet LoadOut frames
	self.Backdrop[8] = CopyTable(self.backdrop)
	self.Backdrop[8].bgFile = nil
	self.Backdrop[8].tile = false
	self.Backdrop[8].tileSize = 0
	-- this backdrop is for vertical sliders frame
	self.Backdrop[9] = CopyTable(self.backdrop)
	self.Backdrop[9].bgFile = nil
	self.Backdrop[9].tile = false
	self.Backdrop[9].tileSize = 0
	self.Backdrop[9].edgeSize = 12
	-- this backdrop has no background
	self.Backdrop[10] = CopyTable(self.backdrop)
	self.Backdrop[10].bgFile = nil
	-- this backdrop has no border
	self.Backdrop[11] = CopyTable(self.backdrop)
	self.Backdrop[11].edgeFile = nil
	self.Backdrop[11].edgeSize = 0
	-- this backdrop is for smaller CheckButtons
	self.Backdrop[12] = CopyTable(self.backdrop)
	self.Backdrop[12].tile = false
	self.Backdrop[12].tileSize = 9
	self.Backdrop[12].edgeSize = 9
	self.Backdrop[12].insets = {left = 2, right = 2, top = 2, bottom = 2}

	-- setup background texture name
	if self.prdb.BgUseTex then
		if self.prdb.BgFile
		and self.prdb.BgFile ~= "None"
		then
			self.bgTexName = aName .. " User Background"
			self.LSM:Register("background", self.bgTexName, self.prdb.BgFile)
		else
			self.bgTexName = self.prdb.BgTexture
		end
	end

	-- StatusBar texture
	c = self.prdb.StatusBar
	self.sbTexture = self.LSM:Fetch("statusbar", c.texture)
	-- StatusBar colours
	self.sbClr = _G.CreateColor(c.r, c.g, c.b, c.a)
	-- GradientMin colours
	c = self.prdb.GradientMin
	self.gminClr = _G.CreateColor(c.r, c.g, c.b, c.a)
	-- GradientMax colours
	c = self.prdb.ClassClrGr and _G.RAID_CLASS_COLORS[self.uCls] or self.prdb.GradientMax
	self.gmaxClr = _G.CreateColor(c.r, c.g, c.b, c.a or self.prdb.GradientMax.a)
	-- Backdrop colours
	c = self.prdb.ClassClrBg and _G.RAID_CLASS_COLORS[self.uCls] or self.prdb.Backdrop
	self.bClr = _G.CreateColor(c.r, c.g, c.b, c.a or self.prdb.Backdrop.a)
	-- BackdropBorder colours
	c = self.prdb.ClassClrBd and _G.RAID_CLASS_COLORS[self.uCls] or self.prdb.BackdropBorder
	self.bbClr = _G.CreateColor(c.r, c.g, c.b, c.a or self.prdb.BackdropBorder.a)
	-- TooltipBorder colours
	c = self.prdb.ClassClrTT and _G.RAID_CLASS_COLORS[self.uCls] or self.prdb.TooltipBorder
	self.tbClr = _G.CreateColor(c.r, c.g, c.b, c.a or self.prdb.TooltipBorder.a)

	dflts, c = nil, nil

	-- highlight outdated colour variables use when testing
--[===[@non-debug@
	self.bColour = {self.bClr:GetRGBA()}
	self.bbColour = {self.bbClr:GetRGBA()}
	self.HTr, self.HTg, self.HTb = self.HT:GetRGB()
	self.BTr, self.BTg, self.BTb = self.BT:GetRGB()
--@end-non-debug@]===]

	-- Inactive Tab & DropDowns texture
	if self.prdb.TabDDFile
	and self.prdb.TabDDFile ~= "None"
	then
		self.LSM:Register("background", aName .. " User TabDDTexture", self.prdb.TabDDFile)
		self.itTex = self.LSM:Fetch("background", aName .. " User TabDDTexture")
	else
		self.itTex = self.LSM:Fetch("background", self.prdb.TabDDTexture)
	end

	-- Empty Slot texture
	self.esTex = [[Interface\Buttons\UI-Quickslot2]]

	-- store Addons managed by LoadManagers
	self.lmAddons = {}

	-- table to hold which functions have been actioned
	self.initialized = {}

	-- shorthand for the TexturedTab profile setting
	self.isTT = self.prdb.TexturedTab and true or false

	-- table to hold minimap buttons from other AddOn skins
	self.mmButs = {}

	-- table to hold AddOn dropdown names that need to have their length adjusted
	self.iofDD = {}
	-- table to hold AddOn button objects to ignore
	self.iofBtn = {}

	-- table to hold Tooltips to skin
	self.ttList = {}
	-- table to hold Tooltips to hook Show function
	self.ttHook = {}

end

function aObj:OnEnable()

	-- handle InCombat issues
	self.oocTab = {}
	self:RegisterEvent("PLAYER_REGEN_ENABLED", function()
 		for i = 1, #self.oocTab do
			self.oocTab[i][1](_G.unpack(self.oocTab[i][2]))
		end
		_G.wipe(self.oocTab)
	end)

	-- add support for UIButton skinning
	local btnModDB = self.db:GetNamespace("UIButtons", true)
	self.modUIBtns = self:GetModule("UIButtons", true)
	if self.modUIBtns:IsEnabled() then
		if btnModDB.profile.UIButtons then
			self.modBtns = true
		end
		if btnModDB.profile.ButtonBorders then
			self.modBtnBs = true
			-- hook this to colour container item borders (inc. Bags, Bank, GuildBank, ReagentBank)
			self:SecureHook("SetItemButtonQuality", function(button, quality, itemIDOrLink, suppressOverlays)
				-- self:Debug("SetItemButtonQuality: [%s, %s, %s, %s, %s, %s]", button, button.IconBorder, button.sbb, quality, itemIDOrLink, suppressOverlays)
				-- self:Debug("SIBQ: [%s, %s]", button.IconBorder:IsShown(), button.IconOverlay:IsShown())
				-- show Artifact Relic Item border
				if itemIDOrLink
				and (_G.IsArtifactRelicItem and _G.IsArtifactRelicItem(itemIDOrLink))
				then
					button.IconBorder:SetAlpha(1)
				else
					button.IconBorder:SetAlpha(0)
				end
				if button.sbb then
					if quality then
						if quality >= _G.LE_ITEM_QUALITY_COMMON
						and _G.BAG_ITEM_QUALITY_COLORS[quality]
						then
							button.sbb:SetBackdropBorderColor(_G.BAG_ITEM_QUALITY_COLORS[quality].r, _G.BAG_ITEM_QUALITY_COLORS[quality].g, _G.BAG_ITEM_QUALITY_COLORS[quality].b, 1)
						else
							self:clrBtnBdr(button, "grey", 1)
						end
					else
						self:clrBtnBdr(button, "grey", 0.5)
						if _G.TradeSkillFrame
						and _G.TradeSkillFrame.DetailsFrame
						and button == _G.TradeSkillFrame.DetailsFrame.Contents.ResultIcon
						then
							self:clrBtnBdr(button, "normal", 1)
						end
					end
				end
			end)
		end
		if btnModDB.profile.CheckButtons then
			self.modChkBtns = true
		end
	else
		self.modBtns = false
		self.modBtnBs = false
		self.modChkBtns = false
	end
	btnModDB = nil

	self.checkTex         = self.modBtns and self.modUIBtns.checkTex or _G.nop
	self.skinCloseButton  = self.modBtns and self.modUIBtns.skinCloseButton or _G.nop
	self.skinOtherButton  = self.modBtns and self.modUIBtns.skinOtherButton or _G.nop
	self.skinExpandButton = self.modBtns and self.modUIBtns.skinExpandButton or _G.nop
	self.skinStdButton    = self.modBtns and self.modUIBtns.skinStdButton or _G.nop
	self.skinButton       = self.modBtns and self.modUIBtns.skinButton or _G.nop
	self.isButton         = self.modBtns and self.modUIBtns.isButton or _G.nop
	self.skinAllButtons   = self.modBtns and self.modUIBtns.skinAllButtons or _G.nop
	self.fontSBX          = self.modBtns and self.modUIBtns.fontSBX or _G.nop
	self.fontP            = self.modBtns and self.modUIBtns.fontP or _G.nop
	self.fontS            = self.modBtns and self.modUIBtns.fontS or _G.nop
	self.addButtonBorder  = self.modBtnBs and self.modUIBtns.addButtonBorder or _G.nop
	self.clrButtonBorder  = self.modBtnBs and self.modUIBtns.clrButtonBorder or _G.nop
	self.clrBtnBdr        = self.modBtnBs and self.modUIBtns.clrBtnBdr or _G.nop
	self.skinCheckButton  = self.modChkBtns and self.modUIBtns.skinCheckButton or _G.nop

	-- register for event after a slight delay as registering ADDON_LOADED any earlier causes it not to be registered if LoD modules are loaded on startup (e.g. SimpleSelfRebuff/LightHeaded)
	_G.C_Timer.After(0.5, function() self:RegisterEvent("ADDON_LOADED") end)
	-- track when Auction House is opened
	self:RegisterEvent("AUCTION_HOUSE_SHOW")
	-- track when Player enters World (used for texture updates and UIParent child processing)
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	-- track when Trade Skill is opened (used by MrTrader_SkillWindow)
	self:RegisterEvent("TRADE_SKILL_SHOW")

	if _G.UnitLevel("player") >= _G.MAX_PLAYER_LEVEL - 5
	and not _G.IsTrialAccount()
	then
		-- track when player levels up, to manage MainMenuBars' WatchBars' placement
		self:RegisterEvent("PLAYER_LEVEL_UP")
	end

	-- skin the Blizzard frames
	_G.C_Timer.After(self.prdb.Delay.Init, function() self:BlizzardFrames() end)
	-- skin the loaded AddOns frames
	_G.C_Timer.After(self.prdb.Delay.Init + self.prdb.Delay.Addons, function() self:AddonFrames() end)
	-- schedule scan of UIParent's Children after all AddOns have been loaded
	_G.C_Timer.After(self.prdb.Delay.Init + self.prdb.Delay.Addons + 1, function() self:scanUIParentsChildren() end)

	-- handle statusbar changes
	self.LSM.RegisterCallback(self, "LibSharedMedia_SetGlobal", function(mtype, override)
		if mtype == "statusbar" then
			self.prdb.StatusBar.texture = override
			self:updateSBTexture()
		elseif mtype == "background" then
			self.prdb.BdTexture = override
		elseif mtype == "border" then
			self.prdb.BdBorderTexture = override
		end
	end)
	self.RegisterCallback("OnEnable", "Player_Entering_World", function(this)
		self:updateSBTexture()
		self.UnregisterCallback("OnEnable", "Player_Entering_World")
	end)

	-- hook to handle textured tabs on Blizzard & other Frames
	self.tabFrames = {}
	if self.isTT then
		self:SecureHook("PanelTemplates_UpdateTabs", function(frame)
			-- self:Debug("PanelTemplates_UpdateTabs: [%s, %s, %s, %s]", frame, frame.selectedTab, frame.numTabs, _G.rawget(self.tabFrames, frame))
			if not self.tabFrames[frame] then return end -- ignore frame if not monitored
			if frame.selectedTab then
				for i = 1, frame.numTabs do
					if i == frame.selectedTab then
						self:setActiveTab(_G[frame:GetName() .. "Tab" .. i].sf)
					else
						self:setInactiveTab(_G[frame:GetName() .. "Tab" .. i].sf)
					end
				end
			end
		end)
	end

	-- handle profile changes
	_G.StaticPopupDialogs[aName .. "_Reload_UI"] = {
		text = aObj.L["Confirm reload of UI to activate profile changes"],
		button1 = _G.OKAY,
		button2 = _G.CANCEL,
		OnAccept = function()
			_G.ReloadUI()
		end,
		OnCancel = function(this, data, reason)
			if reason == "timeout" or reason == "clicked" then
				aObj:CustomPrint(1, 1, 0, "The profile '" .. aObj.db:GetCurrentProfile() .. "' will be activated next time you Login or Reload the UI")
			end
		end,
		timeout = 0,
		whileDead = 1,
		exclusive = 1,
		hideOnEscape = 1
	}
	local function reloadAddon()
		-- setup defaults for new profile
		aObj:checkAndRun("SetupDefaults", "opt", false, true)
		-- store shortcut
		aObj.prdb = aObj.db.profile
		-- prompt for reload
		_G.StaticPopup_Show(aName .. "_Reload_UI")
	end
	self.db.RegisterCallback(self, "OnProfileChanged", reloadAddon)
	self.db.RegisterCallback(self, "OnProfileCopied", reloadAddon)
	self.db.RegisterCallback(self, "OnProfileReset", reloadAddon)

--@debug@
	self:SetupCmds()
--@end-debug@

end

function aObj:OnDisable()

	self:UnregisterAllEvents()
	self.LSM.UnregisterAllCallbacks(self)
	self.UnregisterAllCallbacks(self)
	self.db.UnregisterAllCallbacks(self)

end
