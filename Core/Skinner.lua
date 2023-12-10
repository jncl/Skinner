local aName, aObj = ...

local _G = _G
-- luacheck: ignore 631 (line is too long)

do
	-- check to see if required libraries are loaded
	_G.assert(_G.LibStub, aName .. " requires LibStub")
	local lTab = {"AceAddon-3.0", "AceConfig-3.0", "AceConfigCmd-3.0", "AceConfigDialog-3.0", "AceConfigRegistry-3.0", "AceConsole-3.0", "AceDB-3.0", "AceDBOptions-3.0", "AceEvent-3.0", "AceGUI-3.0", "AceHook-3.0", "AceLocale-3.0", "CallbackHandler-1.0", "LibDataBroker-1.1", "LibDBIcon-1.0", "LibSharedMedia-3.0"}
	local hasError
	for _, lib in _G.pairs(lTab) do
		hasError = not _G.assert(_G.LibStub:GetLibrary(lib, true), aName .. " requires " .. lib)
	end
	if hasError then
		return
	end

	-- create the addon and make it available in the Global namespace (Ara-Broker-... addons use it by name if available)
	_G.Skinner = _G.LibStub:GetLibrary("AceAddon-3.0"):NewAddon(aObj, aName, "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0")

	aObj:checkVersion()

	-- define tables to hold skin functions
	aObj.blizzFrames = {p = {}, n = {}, u = {}, opt = {}}
	aObj.blizzLoDFrames = {p = {}, n = {}, u = {}}

	-- pointer to LibSharedMedia-3.0 library (done here for TukUI & ElvUI)
	aObj.LSM = _G.LibStub:GetLibrary("LibSharedMedia-3.0")

	-- store player name (done here to fix enabled addon check)
	aObj.uName = _G.UnitName("player")

	-- setup callback registry
	aObj.callbacks = _G.LibStub:GetLibrary("CallbackHandler-1.0"):New(aObj)

	--@alpha@
	local function handleEvent(event, addonName, addonFunc)
		aObj:Debug(event, addonName, addonFunc, _G.debugstack(3))
	end
	aObj:RegisterEvent("ADDON_ACTION_BLOCKED", function(...)
		handleEvent(...)
	end)
	aObj:RegisterEvent("ADDON_ACTION_FORBIDDEN", function(...)
		handleEvent(...)
	end)
	--@end-alpha@

end

function aObj:OnInitialize()

	self:Debug("Debugging is enabled")

	self.callbacks:Fire("AddOn_OnInitialize")
	-- remove all callbacks for this event
	self.callbacks.events["AddOn_OnInitialize"] = nil

	-- get Locale
	self.L = _G.LibStub:GetLibrary("AceLocale-3.0"):GetLocale(aName)
	-- pointer to LibDBIcon-1.0 library
	self.DBIcon = _G.LibStub:GetLibrary("LibDBIcon-1.0")
	-- store player class as English Spelling
	self.uCls = _G.select(2, _G.UnitClass("player"))

	-- get FileDataIDs for Textures
	self:setupTextures()

	-- setup the default DB values and register them
	self:checkAndRun("SetupDefaults", "opt", false, true)

	-- store shortcut
	self.prdb = self.db.profile
	local dflts = self.db.defaults.profile

	-- disable functions/modules which cause ADDON_ACTION_BLOCKED/ADDON_ACTION_FORBIDDEN errors (Dragonflight changes)
	if self.isRtl then
		self.prdb.ContainerFrames.skin = false
		self.prdb.MainMenuBar.actbtns  = false
		self.prdb.Nameplates           = false
		self:DisableModule("UnitFrames")
	end
	-- self.prdb.OverrideActionBar    = false

	-- handle changes to TabDDTextures options
	if self.prdb.TexturedTab then
		self.prdb.TabDDTextures.texturedtab = self.prdb.TexturedTab
		self.prdb.TabDDTextures.textureddd  = self.prdb.TexturedDD
		self.prdb.TabDDTextures.tabddfile   = self.prdb.TabDDFile
		self.prdb.TabDDTextures.tabddtex    = self.prdb.TabDDTexture
	end
	--@debug@
	self.prdb.TexturedTab  = nil
	self.prdb.TexturedDD   = nil
	self.prdb.TabDDFile    = nil
	self.prdb.TabDDTexture = nil
	--@end-debug@
	--[===[@non-debug@
	self.prdb.TexturedTab  = self.prdb.TabDDTextures.texturedtab
	self.prdb.TexturedDD   = self.prdb.TabDDTextures.textureddd
	--@end-non-debug@]===]

	-- setup the Addon's core options
	self:checkAndRun("SetupOptions", "opt")

	-- setup Retail/Classic Options as required
	if self.isRtl then
		self:SetupRetail_NPCFramesOptions()
		self:SetupRetail_PlayerFramesOptions()
		self:SetupRetail_UIFramesOptions()
	else
		self:SetupClassic_NPCFramesOptions()
		self:SetupClassic_PlayerFramesOptions()
		self:SetupClassic_UIFramesOptions()
	end

	-- register the default background texture
	self.LSM:Register("background", dflts.BdTexture, self.tFDIDs.cfBg)
	-- register the inactive tab texture
	self.LSM:Register("background", aName .. " Inactive Tab", self.tFDIDs.inactTab)
	-- register the texture used for EditBoxes & ScrollBars
	self.LSM:Register("border", aName .. " Border", self.tFDIDs.skinBdr)
	-- register the statubar texture used by Nameplates
	self.LSM:Register("statusbar", "Blizzard2", self.tFDIDs.tfBF)

	-- EditBox regions to keep
	self.ebRgns = {1, 2} -- 1 is text, 2 is the cursor texture

	-- Gradient settings
	self.gradientTab = {self.prdb.Gradient.rotate and "HORIZONTAL" or "VERTICAL", .5, .5, .5, 1, .25, .25, .25, 0}
	self.gradientCBar = {self.prdb.Gradient.rotate and "HORIZONTAL" or "VERTICAL", .25, .25, .55, 1, 0, 0, 0, 1}
	self.gradientTex = self.LSM:Fetch("background", self.prdb.Gradient.texture)
	-- these are used to disable the gradient
	self.gradFrames = {p = {}, u = {}, n = {}, s = {}, a = _G.setmetatable({}, {__mode = "k"})}

	-- backdrop for Frames etc
	self:setupBackdrop()

	self.Backdrop = {}
	self.Backdrop[1] = _G.CopyTable(self.backdrop)
	-- -- wide backdrop for ScrollBars & EditBoxes (16,16,4)
	-- self.Backdrop[2] = _G.CopyTable(self.backdrop)
	-- -- medium backdrop for ScrollBars & EditBoxes (12,12,3)
	-- self.Backdrop[3] = _G.CopyTable(self.backdrop)
	-- self.Backdrop[3].tileSize = 12
	-- self.Backdrop[3].edgeSize = 12
	-- self.Backdrop[3].insets = {left = 3, right = 3, top = 3, bottom = 3}
	-- narrow backdrop for ScrollBars & EditBoxes (8,8,2)
	self.Backdrop[4] = _G.CopyTable(self.backdrop)
	self.Backdrop[4].tileSize = 8
	self.Backdrop[4].edgeSize = 8
	self.Backdrop[4].insets = {left = 2, right = 2, top = 2, bottom = 2}
	-- these backdrops are for small UI buttons, e.g. minus/plus in QuestLog/IOP/Skills etc
	self.Backdrop[5] =_G. CopyTable(self.backdrop)
	self.Backdrop[5].tileSize = 12
	self.Backdrop[5].edgeSize = 12
	self.Backdrop[5].insets = {left = 3, right = 3, top = 3, bottom = 3}
	self.Backdrop[6] = _G.CopyTable(self.Backdrop[5])
	self.Backdrop[6].tileSize = 10
	self.Backdrop[6].edgeSize = 10
	self.Backdrop[7] = _G.CopyTable(self.Backdrop[4])
	self.Backdrop[7].insets = {left = 4, right = 4, top = 4, bottom = 4}
	-- this backdrop is for the BattlefieldMinimap/Minimap/Pet LoadOut frames
	self.Backdrop[8] = _G.CopyTable(self.backdrop)
	self.Backdrop[8].bgFile = nil
	self.Backdrop[8].tile = false
	self.Backdrop[8].tileSize = 0
	-- this backdrop is for vertical sliders frame
	self.Backdrop[9] = _G.CopyTable(self.backdrop)
	self.Backdrop[9].bgFile = nil
	self.Backdrop[9].tile = false
	self.Backdrop[9].tileSize = 0
	self.Backdrop[9].edgeSize = 12
	-- this backdrop has no background
	self.Backdrop[10] = _G.CopyTable(self.backdrop)
	self.Backdrop[10].bgFile = nil
	-- this backdrop has no border
	self.Backdrop[11] = _G.CopyTable(self.backdrop)
	self.Backdrop[11].edgeFile = nil
	-- this backdrop is for smaller CheckButtons
	self.Backdrop[12] = _G.CopyTable(self.backdrop)
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

	-- Heading, Body & Ignored Text colours
	local c = self.prdb.HeadText
	self.HT = _G.CreateColor(c.r, c.g, c.b)
	c = self.prdb.BodyText
	self.BT = _G.CreateColor(c.r, c.g, c.b)
	c = self.prdb.IgnoredText
	self.IT = _G.CreateColor(c.r, c.g, c.b)

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

	-- highlight outdated colour variables use when testing
	--[===[@non-debug@
	self.HTr, self.HTg, self.HTb = self.HT:GetRGB()
	self.BTr, self.BTg, self.BTb = self.BT:GetRGB()
	self.bColour = {self.bClr:GetRGBA()}
	self.bbColour = {self.bbClr:GetRGBA()}
	--@end-non-debug@]===]

	-- Inactive Tab & DropDowns texture
	if self.prdb.TabDDTextures.tabddfile
	and self.prdb.TabDDTextures.tabddfile ~= "None"
	then
		self.LSM:Register("background", aName .. " User TabDDTexture", self.prdb.TabDDTextures.tabddfile)
		self.itTex = self.LSM:Fetch("background", aName .. " User TabDDTexture")
	else
		self.itTex = self.LSM:Fetch("background", self.prdb.TabDDTextures.tabddtex)
	end

	-- store Addons managed by LoadManagers
	self.lmAddons = {}

	-- table to hold which functions have been actioned
	self.initialized = {}

	-- shorthand for the TexturedTab profile setting
	self.isTT = self.prdb.TabDDTextures.texturedtab and true or false

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

	-- table to hold StatusBars that have been glazed, with weak keys
	self.sbGlazed = _G.setmetatable({}, {__mode = "k"})

	if self.isRtl then
		-- Load Retail Support, if required (done here for ElvUI/TukUI)
		self:checkAndRun("SetupRetail_NPCFrames", "opt", nil, true)
		self:checkAndRun("SetupRetail_PlayerFrames", "opt", nil, true)
		self:checkAndRun("SetupRetail_UIFrames", "opt", nil, true)
	else
		-- Load Classic Support, if required (done here for ElvUI/TukUI)
		self:checkAndRun("SetupClassic", "opt", nil, true)
		self:checkAndRun("SetupClassic_NPCFrames", "opt", nil, true)
		self:checkAndRun("SetupClassic_PlayerFrames", "opt", nil, true)
		self:checkAndRun("SetupClassic_UIFrames", "opt", nil, true)
	end

end

function aObj:OnEnable()

	self.oocTab = {}
	self:RegisterEvent("PLAYER_REGEN_ENABLED", function()
		for _, entry in _G.ipairs(self.oocTab) do
			if entry
			and entry[1]
			then
				entry[1](_G.unpack(entry[2]))
			end
		end
		self.oocTab = {}
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
			if self.isRtl then
				self:SecureHook("SetItemButtonBorderVertexColor", function(button, r, g, b)
					-- aObj:Debug("SetItemButtonBorderVertexColor: [%s, %s, %s, %s, %s]", button, r, g, b)
					if button.sbb then
						button.sbb:SetBackdropBorderColor(r, g, b)
					end
				end)
				self:SecureHook(_G.ItemButtonMixin, "UpdateCraftedProfessionsQualityShown", function(button)
					-- aObj:Debug("IBM UpdateCraftedProfessionsQualityShown: [%s, %s]", button, button.ProfessionQualityOverlay)
					if not button.ProfessionQualityOverlay then
						return
					end
					if button.sbb then
						if button.ProfessionQualityOverlay then
							button.ProfessionQualityOverlay:SetParent(button.sbb)
						end
					end
				end)
			else
				self:SecureHook("SetItemButtonQuality", function(button, quality, itemIDOrLink, _)
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
					self:setBtnClr(button, quality)
				end)
			end
		end
		if btnModDB.profile.CheckButtons then
			self.modChkBtns = true
		end
	else
		self.modBtns = false
		self.modBtnBs = false
		self.modChkBtns = false
	end

	self.fontDP              = self.modBtns and self.modUIBtns.fontDP or _G.nop
	self.fontDS              = self.modBtns and self.modUIBtns.fontDS or _G.nop
	self.fontP               = self.modBtns and self.modUIBtns.fontP or _G.nop
	self.fontS               = self.modBtns and self.modUIBtns.fontS or _G.nop
	self.fontSBX             = self.modBtns and self.modUIBtns.fontSBX or _G.nop
	self.downarrow           = self.modBtns and self.modUIBtns.darrow or _G.nop
	self.larrow              = self.modBtns and self.modUIBtns.larrow or _G.nop
	self.nearrow             = self.modBtns and self.modUIBtns.nearrow or _G.nop
	self.nwarrow             = self.modBtns and self.modUIBtns.nwarrow or _G.nop
	self.rarrow              = self.modBtns and self.modUIBtns.rarrow or _G.nop
	self.searrow             = self.modBtns and self.modUIBtns.searrow or _G.nop
	self.swarrow             = self.modBtns and self.modUIBtns.swarrow or _G.nop
	self.uparrow             = self.modBtns and self.modUIBtns.uarrow or _G.nop
	self.checkTex            = self.modBtns and self.modUIBtns.checkTex or _G.nop
	self.isButton            = self.modBtns and self.modUIBtns.isButton or _G.nop
	self.skinAllButtons      = self.modBtns and self.modUIBtns.skinAllButtons or _G.nop
	self.skinButton          = self.modBtns and self.modUIBtns.skinButton or _G.nop
	self.skinCloseButton     = self.modBtns and self.modUIBtns.skinCloseButton or _G.nop
	self.skinExpandButton    = self.modBtns and self.modUIBtns.skinExpandButton or _G.nop
	self.skinOtherButton     = self.modBtns and self.modUIBtns.skinOtherButton or _G.nop
	self.skinStdButton       = self.modBtns and self.modUIBtns.skinStdButton or _G.nop

	self.addButtonBorder     = self.modBtnBs and self.modUIBtns.addButtonBorder or _G.nop
	self.clrButtonFromBorder = self.modBtnBs and self.modUIBtns.clrButtonFromBorder or _G.nop

	self.clrBtnBdr           = (self.modBtns or self.modBtnBs) and self.modUIBtns.clrBtnBdr or _G.nop
	self.setBtnClr           = (self.modBtns or self.modBtnBs) and self.modUIBtns.setBtnClr or _G.nop

	self.skinCheckButton     = self.modChkBtns and self.modUIBtns.skinCheckButton or _G.nop

	-- register for event after a slight delay as registering ADDON_LOADED any earlier causes it not to be registered if LoD modules are loaded on startup (e.g. SimpleSelfRebuff/LightHeaded)
	_G.C_Timer.After(0.5, function()
		self:RegisterEvent("ADDON_LOADED")
	end)
	-- track when Auction House is opened
	self:RegisterEvent("AUCTION_HOUSE_SHOW")
	-- track when Player enters World (used for texture updates and UIParent child processing)
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	-- track when Trade Skill is opened (used by MrTrader_SkillWindow)
	self:RegisterEvent("TRADE_SKILL_SHOW")
	-- track when player changes level, to manage MainMenuBars' WatchBars' placement
	if _G.UnitLevel("player") >= _G.MAX_PLAYER_LEVEL - 5
	and not _G.IsTrialAccount()
	then
		self:RegisterEvent("PLAYER_LEVEL_CHANGED")
	end

	-- handle statusbar changes
	self.LSM:RegisterCallback("LibSharedMedia_SetGlobal", function(mtype, override)
		if mtype == "statusbar" then
			self.prdb.StatusBar.texture = override
			self:updateSBTexture()
		elseif mtype == "background" then
			self.prdb.BdTexture = override
		elseif mtype == "border" then
			self.prdb.BdBorderTexture = override
		end
	end)
	self.RegisterCallback("OnEnable", "Player_Entering_World", function(_)
		self:updateSBTexture()
	end)

	-- hook to handle textured tabs on Blizzard & other Frames
	self.tabFrames = {}
	if self.isTT then
		self:SecureHook("PanelTemplates_UpdateTabs", function(frame)
			-- self:Debug("PanelTemplates_UpdateTabs: [%s, %s, %s, %s]", frame, frame.selectedTab, frame.numTabs, _G.rawget(self.tabFrames, frame))
			if not self.tabFrames[frame] then -- ignore frame if not monitored
				return
			end
			if frame.selectedTab then
				local tab
				for i = 1, frame.numTabs do
					tab = frame.Tabs and frame.Tabs[i] or _G[frame:GetName() .. "Tab" .. i]
					if tab.sf then
						if i == frame.selectedTab then
							self:setActiveTab(tab.sf)
						else
							self:setInactiveTab(tab.sf)
						end
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
		OnAccept = function(_)
			_G.C_UI.Reload()
		end,
		OnCancel = function(_, _, reason)
			if reason == "timeout"
			or reason == "clicked"
			then
				aObj:CustomPrint(1, 1, 0, aObj.L["The profile"] .. " '" .. aObj.db:GetCurrentProfile() .. "' " .. aObj.L["will be activated next time you Login or Reload the UI"])
				_G.UIErrorsFrame:AddMessage(aObj.L["The profile"] .. " '" .. aObj.db:GetCurrentProfile() .. "' " .. aObj.L["will be activated next time you Login or Reload the UI"], 1, 1, 0)
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
	self.db:RegisterCallback("OnProfileChanged", reloadAddon)
	self.db:RegisterCallback("OnProfileCopied", reloadAddon)
	self.db:RegisterCallback("OnProfileReset", reloadAddon)

	-- skin the Blizzard frames
	_G.C_Timer.After(self.prdb.Delay.Init, function() self:BlizzardFrames() end)
	-- skin the loaded AddOns frames
	_G.C_Timer.After(self.prdb.Delay.Init + self.prdb.Delay.Addons, function() self:AddonFrames() end)
	-- schedule scan of UIParent's Children after all AddOns have been loaded
	_G.C_Timer.After(self.prdb.Delay.Init + self.prdb.Delay.Addons + 1, function() self:scanUIParentsChildren() end)

	if self.isRtl then
		-- hook this (used by Blizzard_OrderHallTalents, PVPMatchResults, PVPMatchScoreboard & Blizzard_WarboardUI)
		-- N.B. use SecureHook as RawHook cause taint and INTERFACE_ACTION_BLOCKED message to be displayed
		self:SecureHook("UIPanelCloseButton_SetBorderAtlas", function(this, _, _, _, _)
			this.Border:SetTexture(nil)
		end)
	end

	--@alpha@
	self:SetupCmds()
	--@end-alpha@

end

function aObj:OnDisable()

	self:UnregisterAllEvents()
	self.LSM.UnregisterAllCallbacks(self)
	self.UnregisterAllCallbacks(self)
	self.db.UnregisterAllCallbacks(self)

end
