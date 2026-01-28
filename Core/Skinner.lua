local aName, aObj = ...

local _G = _G

do
	if aObj:checkLibraries({"LibSharedMedia-3.0", "LibDBIcon-1.0"}) then
		-- create the addon and make it available in the Global namespace (Ara-Broker-... addons use it by name if available)
		aObj:createAddOn(true)
	else
		return
	end

	-- define tables to hold skin functions
	aObj.blizzFrames = {p = {}, n = {}, u = {}, opt = {}}
	aObj.blizzLoDFrames = {p = {}, n = {}, u = {}}

	-- pointer to LibSharedMedia-3.0 library (done here for TukUI & ElvUI)
	aObj.LSM = _G.LibStub:GetLibrary("LibSharedMedia-3.0")

	-- store player name (done here to fix enabled addon check)
	aObj.uName = _G.UnitName("player")

end

function aObj:OnInitialize()

	self:Debug("debugging is enabled")

	-- get Locale strings
	self.L = _G.LibStub:GetLibrary("AceLocale-3.0"):GetLocale(aName)

	--@debug@
	self:checkLocaleStrings()
	--@end-debug@

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

	-- disable functions/modules which cause ADDON_ACTION_BLOCKED/ADDON_ACTION_FORBIDDEN errors (Dragonflight onwards changes)
	if self.isMnln then
		self.prdb.MainMenuBar.actbtns = false
		self.prdb.Nameplates          = false
		self:DisableModule("UnitFrames")
	end

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
	if self.isMnln then
		self:SetupMainline_NPCFramesOptions()
		self:SetupMainline_PlayerFramesOptions()
		self:SetupMainline_UIFramesOptions()
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
	self.Backdrop[1] = _G.CopyTable(self.backdrop, true)
	-- -- wide backdrop for ScrollBars & EditBoxes (16,16,4)
	-- self.Backdrop[2] = _G.CopyTable(self.backdrop, true)
	-- -- medium backdrop for ScrollBars & EditBoxes (12,12,3)
	-- self.Backdrop[3] = _G.CopyTable(self.backdrop, true)
	-- self.Backdrop[3].tileSize = 12
	-- self.Backdrop[3].edgeSize = 12
	-- self.Backdrop[3].insets = {left = 3, right = 3, top = 3, bottom = 3}
	-- backdrop with alternate backdrop texture
	self.Backdrop[3] = _G.CopyTable(self.backdrop, true)
	self.Backdrop[3].bgFile = self.LSM:Fetch("background", self.bdTexName2 or self.bdTexName)
	-- narrow backdrop for ScrollBars & EditBoxes (8,8,2)
	self.Backdrop[4] = _G.CopyTable(self.Backdrop[3], true)
	self.Backdrop[4].tileSize = 8
	self.Backdrop[4].edgeSize = 8
	self.Backdrop[4].insets = {left = 2, right = 2, top = 2, bottom = 2}
	-- these backdrops are for small UI buttons, e.g. minus/plus in QuestLog/IOP/Skills etc
	self.Backdrop[5] =_G. CopyTable(self.Backdrop[3], true)
	self.Backdrop[5].tileSize = 12
	self.Backdrop[5].edgeSize = 12
	self.Backdrop[5].insets = {left = 3, right = 3, top = 3, bottom = 3}
	self.Backdrop[6] = _G.CopyTable(self.Backdrop[5], true)
	self.Backdrop[6].tileSize = 10
	self.Backdrop[6].edgeSize = 10
	self.Backdrop[7] = _G.CopyTable(self.Backdrop[4], true)
	self.Backdrop[7].insets = {left = 4, right = 4, top = 4, bottom = 4}
	-- this backdrop is for the BattlefieldMinimap/Minimap/Pet LoadOut frames
	self.Backdrop[8] = _G.CopyTable(self.backdrop, true)
	self.Backdrop[8].bgFile = nil
	self.Backdrop[8].tile = false
	self.Backdrop[8].tileSize = 0
	-- this backdrop is for vertical sliders frame
	self.Backdrop[9] = _G.CopyTable(self.backdrop, true)
	self.Backdrop[9].bgFile = nil
	self.Backdrop[9].tile = false
	self.Backdrop[9].tileSize = 0
	self.Backdrop[9].edgeSize = 12
	-- this backdrop has no background
	self.Backdrop[10] = _G.CopyTable(self.backdrop, true)
	self.Backdrop[10].bgFile = nil
	-- this backdrop has no border
	self.Backdrop[11] = _G.CopyTable(self.backdrop, true)
	self.Backdrop[11].edgeFile = nil
	-- this backdrop is for smaller CheckButtons
	self.Backdrop[12] = _G.CopyTable(self.backdrop, true)
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

	-- Heading, Body, Ignored & Disabled Text colours
	local c = self.prdb.HeadText
	self.HT = _G.CreateColor(c.r, c.g, c.b)
	c = self.prdb.BodyText
	self.BT = _G.CreateColor(c.r, c.g, c.b)
	c = self.prdb.IgnoredText
	self.IT = _G.CreateColor(c.r, c.g, c.b)
	c = self.prdb.DisabledText
	self.DT = _G.CreateColor(c.r, c.g, c.b)

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

	if self.isMnln then
		-- Load Retail Support, if required (done here for ElvUI/TukUI)
		self:checkAndRun("SetupMainline_NPCFrames", "opt", nil, true)
		self:checkAndRun("SetupMainline_PlayerFrames", "opt", nil, true)
		self:checkAndRun("SetupMainline_UIFrames", "opt", nil, true)
	else
		-- Load Classic Support, if required (done here for ElvUI/TukUI)
		self:checkAndRun("SetupClassic", "opt", nil, true)
		self:checkAndRun("SetupClassic_NPCFrames", "opt", nil, true)
		self:checkAndRun("SetupClassic_PlayerFrames", "opt", nil, true)
		self:checkAndRun("SetupClassic_UIFrames", "opt", nil, true)
	end

	self.callbacks:Fire("AddOn_OnInitialize")
	-- remove all callbacks for this event
	self.callbacks.events["AddOn_OnInitialize"] = nil

end

function aObj:OnEnable()

	--@debug@
	if self.isPatch then
		_G.SetBasicMessageDialogText("Runnning as a Patched version, please update Shared_Funcs variable", true)
	end
	--@end-debug@

	self.oocTab, self.PRE = {}, false
	self:RegisterEvent("PLAYER_REGEN_ENABLED", function()
		for _, entry in _G.ipairs(self.oocTab) do
			entry[1](_G.unpack(entry[2]))
		end
		_G.wipe(self.oocTab)
		-- indicate that combat has occurred
		self.PRE = true
	end)

	-- register for event after a slight delay as registering ADDON_LOADED any earlier causes it not to be registered if LoD modules are loaded on startup (e.g. SimpleSelfRebuff/LightHeaded)
	_G.C_Timer.After(0.5, function()
		self:RegisterEvent("ADDON_LOADED")
	end)

	-- track when Auction House is opened
	self:RegisterEvent("AUCTION_HOUSE_SHOW")

	-- track when Player enters World (used for texture updates and UIParent child processing)
	self:RegisterEvent("PLAYER_ENTERING_WORLD")

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

	-- skin the Blizzard frames
	_G.C_Timer.After(self.prdb.Delay.Init, function() self:BlizzardFrames() end)
	-- skin the loaded AddOns frames
	_G.C_Timer.After(self.prdb.Delay.Init + self.prdb.Delay.Addons, function() self:AddonFrames() end)
	-- schedule scan of UIParent's Children after all AddOns have been loaded
	_G.C_Timer.After(self.prdb.Delay.Init + self.prdb.Delay.Addons + 1, function()
		self:scanChildren{obj=_G.UIParent, cbstr="UIParent_GetChildren"}
	end)

	if self.isMnln then
		-- hook this (used by Blizzard_OrderHallTalents, PVPMatchResults, PVPMatchScoreboard & Blizzard_WarboardUI)
		-- N.B. use SecureHook as RawHook causes taint and INTERFACE_ACTION_BLOCKED message to be displayed
		self:SecureHook("UIPanelCloseButton_SetBorderAtlas", function(this, _, _, _, _)
			this.Border:SetTexture(nil)
		end)
	end

	self:handleProfileChanges()

	--@debug@
	self:SetupCmds()

	-- Check to see which AddOns are using the deprecated IOFPanel_ callbacks
	_G.C_Timer.After(self.prdb.Delay.Init + self.prdb.Delay.Addons + 0.5, function()
		local depTab, cnt = {}, 0
		for event, evttable in _G.pairs(aObj.callbacks.events) do
			if event:find("IOFPanel_") then
				cnt = cnt + 1
				for addon, _ in _G.pairs(evttable) do
					depTab[addon] = event
				end
			end
		end
		if cnt > 0 then
			_G.SetBasicMessageDialogText(cnt .. " AddOns found using deprecated IOFPanel_ functions, please fix them")
			for addon, iofevent in _G.pairs(depTab) do
				_G.print(addon .. " is using a deprecated function: " .. iofevent .. " please update it")
			end
		end
	end)

	-- Register PLAYER_LOGOUT to save LocaleStrings
	self:RegisterEvent("PLAYER_LOGOUT", function()
		_G[aName .. "LocaleStrings"] = self.localeStrings
	end)
	--@end-debug@

end

function aObj:OnDisable()

	self:UnregisterAllEvents()
	self.LSM.UnregisterAllCallbacks(self)
	self.UnregisterAllCallbacks(self)
	self.db.UnregisterAllCallbacks(self)

end
