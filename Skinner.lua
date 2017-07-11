local aName, aObj = ...
local _G = _G

local assert, CopyTable, debugstack, ipairs, pairs, rawget, select, type, unpack = _G.assert, _G.CopyTable, _G.debugstack, _G.ipairs, _G.pairs, _G.rawget, _G.select, _G.type, _G.unpack
local LibStub = _G.LibStub

do
	-- check to see if required libraries are loaded
	assert(LibStub, aName .. " requires LibStub")
	for _, lib in pairs{"CallbackHandler-1.0", "AceAddon-3.0", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0", "AceLocale-3.0", "LibSharedMedia-3.0", "AceDB-3.0", "AceDBOptions-3.0", "AceGUI-3.0",  "AceConfig-3.0", "AceConfigCmd-3.0", "AceConfigRegistry-3.0", "AceConfigDialog-3.0", "LibDataBroker-1.1", "LibDBIcon-1.0"} do
		assert(LibStub(lib, true), aName .. " requires " .. lib)
	end

	-- create the addon
	_G[aName] = LibStub("AceAddon-3.0"):NewAddon(aObj, aName, "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")

	-- add callbacks
	aObj.callbacks = LibStub("CallbackHandler-1.0"):New(aObj)

	-- Get Locale
	aObj.L = LibStub("AceLocale-3.0"):GetLocale(aName)

	-- pointer to LibSharedMedia-3.0 library
	aObj.LSM = LibStub("LibSharedMedia-3.0")

	-- player class
	aObj.uCls = select(2, _G.UnitClass("player"))
	-- player level
	aObj.uLvl = _G.UnitLevel("player")

	local ptrInfo = {"7.2.5", 24393}
	local liveInfo = {"7.2.5", 24415}
	local betaInfo = {"7.0.0", 99999}
	local buildInfo, portal = {_G.GetBuildInfo()}, _G.GetCVar("portal") or nil
--@alpha@
	aObj:Debug(liveInfo[1], liveInfo[2], buildInfo[1], buildInfo[2], buildInfo[3], buildInfo[4], portal)
--@end-alpha@
	-- check to see if running on Beta servers
	aObj.isBeta = portal == "public-beta" and true or false
	aObj.isBeta = aObj.isBeta or buildInfo[1] == betaInfo[1] and _G.tonumber(buildInfo[2]) == betaInfo[2] and true or false
	--check to see if running on PTR servers
	aObj.isPTR = portal == "public-test" and true or false
	aObj.isPTR = aObj.isPTR or buildInfo[1] == ptrInfo[1] and _G.tonumber(buildInfo[2]) == ptrInfo[2] and true or false
	-- check build number, if > Live then it's a patch
	aObj.isPatch = _G.tonumber(buildInfo[2]) > liveInfo[2] and true or false
--@alpha@
	if aObj.isPatch then
		if aObj.isPTR then
			_G.DEFAULT_CHAT_FRAME:AddMessage("Version No. updated, any PTR changes to be applied?", 1, 0, 0, nil, true)
		else
			_G.DEFAULT_CHAT_FRAME:AddMessage("Version No. updated, any Patch changes to be applied?", 1, 0, 0, nil, true)
		end
	end
--@end-alpha@
	liveInfo, ptrInfo, betaInfo, buildInfo, portal = nil, nil, nil, nil, nil

	-- define tables to hold skin functions
	aObj.blizzFrames = {p = {}, n = {}, u = {}, o = {}}
	aObj.blizzLoDFrames = {p = {}, n = {}, u = {}}

end

function aObj:OnInitialize()
--@debug@
	self:Print("Debugging is enabled")
	self:Debug("Debugging is enabled")
--@end-debug@

--@alpha@
	if self.isBeta then self:Debug("Beta detected") end
	if self.isPTR then self:Debug("PTR detected") end
	if self.isPatch then self:Debug("Patch detected") end
--@end-alpha@
	-- if patch detected then enable PTR/Beta code changes, handles PTR/Beta changes going Live
	if self.isPatch then
		self.isPTR = true
		self.isBeta = true
	end

	-- setup the default DB values and register them
	self:checkAndRun("SetupDefaults", "o", false, true)
	local prdb = self.db.profile
	local dflts = self.db.defaults.profile

	-- convert any old settings
	if type(prdb.MinimapButtons) == "boolean" then
		prdb.MinimapButtons = {skin = true, style = false}
	end

	-- setup the Addon's options
	self:checkAndRun("SetupOptions", "o")

	-- register the default background texture
	self.LSM:Register("background", dflts.BdTexture, [[Interface\ChatFrame\ChatFrameBackground]])
	-- register the inactive tab texture
	self.LSM:Register("background", aName .. " Inactive Tab", [[Interface\AddOns\]] .. aName .. [[\Textures\inactive]])
	-- register the texture used for EditBoxes & ScrollBars
	self.LSM:Register("border", aName .. " Border", [[Interface\AddOns\]] .. aName .. [[\Textures\krsnik]])
	-- register the statubar texture used by Nameplates
	self.LSM:Register("statusbar", "Blizzard2", [[Interface\TargetingFrame\UI-TargetingFrame-BarFill]])
	-- register any User defined textures used
	if prdb.BdFile and prdb.BdFile ~= "None" then
		self.LSM:Register("background", aName .. " User Backdrop", prdb.BdFile)
	end
	if prdb.BdEdgeFile and prdb.BdEdgeFile ~= "None" then
		self.LSM:Register("border", aName .. " User Border", prdb.BdEdgeFile)
	end
	if prdb.BgFile and prdb.BgFile ~= "None" then
		self.LSM:Register("background", aName .. " User Background", prdb.BgFile)
	end
	if prdb.TabDDFile and prdb.TabDDFile ~= "None" then
		self.LSM:Register("background", aName .. " User TabDDTexture", prdb.TabDDFile)
	end

	-- Heading, Body & Ignored Text colours
	local c = prdb.HeadText
	self.HTr, self.HTg, self.HTb = c.r, c.g, c.b
	c = prdb.BodyText
	self.BTr, self.BTg, self.BTb = c.r, c.g, c.b
	c = prdb.IgnoredText
	self.ITr, self.ITg, self.ITb = c.r, c.g, c.b

	-- Frame multipliers (still used in older skins)
	self.FxMult, self.FyMult = 0.9, 0.87
	-- EditBox regions to keep
	self.ebRgns = {1, 2} -- 1 is text, 2 is a texture

	-- Gradient settings
	self.gradientTab = {prdb.Gradient.rotate and "HORIZONTAL" or "VERTICAL", .5, .5, .5, 1, .25, .25, .25, 0}
	self.gradientCBar = {prdb.Gradient.rotate and "HORIZONTAL" or "VERTICAL", .25, .25, .55, 1, 0, 0, 0, 1}
	self.gradientTex = self.LSM:Fetch("background", prdb.Gradient.texture)

	-- backdrop for Frames etc
	local bdTexName = dflts.BdTexture
	local bdbTexName = dflts.BdBorderTexture
	if prdb.BdDefault then
		self.backdrop = {
			bgFile = self.LSM:Fetch("background", bdTexName),
			tile = dflts.BdTileSize > 0 and true or false, tileSize = dflts.BdTileSize,
			edgeFile = self.LSM:Fetch("border", bdbTexName),
			edgeSize = dflts.BdEdgeSize,
			insets = {left = dflts.BdInset, right = dflts.BdInset, top = dflts.BdInset, bottom = dflts.BdInset},
		}
	else
		if prdb.BdFile and prdb.BdFile ~= "None" then
			bdTexName = aName .. " User Backdrop"
		else
			bdTexName = prdb.BdTexture
		end
		if prdb.BdEdgeFile and prdb.BdEdgeFile ~= "None" then
			bdbTexName = aName .. " User Border"
		else
			bdbTexName = prdb.BdBorderTexture
		end
		self.backdrop = {
			bgFile = self.LSM:Fetch("background", bdTexName),
			tile = prdb.BdTileSize > 0 and true or false, tileSize = prdb.BdTileSize,
			edgeFile = self.LSM:Fetch("border", bdbTexName),
			edgeSize = prdb.BdEdgeSize,
			insets = {left = prdb.BdInset, right = prdb.BdInset, top = prdb.BdInset, bottom = prdb.BdInset},
		}
	end
	bdTexName, bdbTexName = nil, nil

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

	-- setup background texture name
	if prdb.BgUseTex then
		if prdb.BgFile and prdb.BgFile ~= "None" then
			self.bgTexName = aName .. " User Background"
		else
			self.bgTexName = prdb.BgTexture
		end
	end

	-- these are used to disable the gradient
	self.gradFrames = {["p"] = {}, ["u"] = {}, ["n"] = {}, ["s"] = {}}

	-- TooltipBorder colours
	c = prdb.ClassColour and _G.RAID_CLASS_COLORS[self.uCls] or prdb.TooltipBorder
	self.tbColour = {c.r, c.g, c.b, c.a or 1}
	-- StatusBar colours
	c = prdb.StatusBar
	self.sbColour = {c.r, c.g, c.b, c.a}
	-- StatusBar texture
	self.sbTexture = self.LSM:Fetch("statusbar", c.texture)
	-- Backdrop colours
	c = prdb.ClassClrsBg and _G.RAID_CLASS_COLORS[self.uCls] or prdb.Backdrop
	self.bColour = {c.r, c.g, c.b, c.a or 1}
	-- BackdropBorder colours
	c = prdb.ClassColour and _G.RAID_CLASS_COLORS[self.uCls] or prdb.BackdropBorder
	self.bbColour = {c.r, c.g, c.b, c.a or 1}
	-- Inactive Tab & DropDowns texture
	if prdb.TabDDFile and prdb.TabDDFile ~= "None" then
		self.itTex = self.LSM:Fetch("background", aName .. " User TabDDTexture")
	else
		self.itTex = self.LSM:Fetch("background", prdb.TabDDTexture)
	end
	-- Empty Slot texture
	self.esTex = [[Interface\Buttons\UI-Quickslot2]]

	-- class table
	self.classTable = {"DeathKnight", "DemonHunter", "Druid", "Hunter", "Mage", "Monk", "Paladin", "Priest", "Rogue", "Shaman", "Warlock", "Warrior"}

	-- store Addons managed by LoadManagers
	self.lmAddons = {}

	-- table to hold which functions have been actioned
	self.initialized = {}

	-- table to hold buttons that have been added, with weak keys
	self.sBtn = _G.setmetatable({}, {__mode = "k"})

	-- table to hold StatusBars that have been glazed, with weak keys
	self.sbGlazed = _G.setmetatable({}, {__mode = "k"})

	-- shorthand for the TexturedTab profile setting
	self.isTT = prdb.TexturedTab and true or false

	-- ignore objects when skinning IOF elements
	self.ignoreIOF = {}

	-- ignore buttons when skinning frames
	self.ignoreBtns = {}

end

function aObj:OnEnable()

--@debug@
	self:SetupCmds()
--@end-debug@

	-- handle InCombat issues
	self.oocTab = {}
	self:RegisterEvent("PLAYER_REGEN_ENABLED", function()
		for _, v in pairs(self.oocTab) do
			v[1](unpack(v[2]))
		end
		_G.wipe(self.oocTab)
	end)

	local prdb = self.db.profile

	-- change option name
	if prdb.ClassColours then
		self.db.profile.ClassColour = self.db.profile.ClassColours
		self.db.profile.ClassColours = nil
	end
	-- treat GossipFrame & QuestFrame as one
	-- as they both change the quest text colours
	if not prdb.GossipFrame == prdb.QuestFrame then
		if not self.db.profile.QuestFrame then
			self.db.profile.GossipFrame = false
		else
			self.db.profile.QuestFrame = false
		end
	end

	-- aObj:Debug("btn clrs: [%s, %s, %s, %s, %s, %s, %s, %s, %s]", _G.LE_ITEM_QUALITY_POOR, _G.LE_ITEM_QUALITY_COMMON, _G.LE_ITEM_QUALITY_UNCOMMON, _G.LE_ITEM_QUALITY_RARE, _G.LE_ITEM_QUALITY_EPIC, _G.LE_ITEM_QUALITY_LEGENDARY, _G.LE_ITEM_QUALITY_ARTIFACT, _G.LE_ITEM_QUALITY_HEIRLOOM, _G.LE_ITEM_QUALITY_WOW_TOKEN)
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
			self:SecureHook("SetItemButtonQuality", function(button, quality, itemIDOrLink)
				-- show Artifact Relic Item border
				if itemIDOrLink and _G.IsArtifactRelicItem(itemIDOrLink) then
					button.IconBorder:SetAlpha(1)
				else
					button.IconBorder:SetAlpha(0)
				end
				if button.sbb then
					if quality then
						if quality > _G.LE_ITEM_QUALITY_COMMON and _G.BAG_ITEM_QUALITY_COLORS[quality] then
							button.sbb:SetBackdropBorderColor(_G.BAG_ITEM_QUALITY_COLORS[quality].r, _G.BAG_ITEM_QUALITY_COLORS[quality].g, _G.BAG_ITEM_QUALITY_COLORS[quality].b, 1)
						elseif quality == _G.LE_ITEM_QUALITY_POOR then
							button.sbb:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
						else
							button.sbb:SetBackdropBorderColor(self.bbColour[1], self.bbColour[2], self.bbColour[3], self.bbColour[4])
						end
					else
						button.sbb:SetBackdropBorderColor(0.5, 0.5, 0.5, 0.35)
					end
				end
			end)
		end
	else
		self.modBtns = false
		self.modBtnBs = false
	end

	self.checkTex        = self.modBtns and self.modUIBtns.checkTex or _G.nop
	self.skinButton      = self.modBtns and self.modUIBtns.skinButton or _G.nop
	self.isButton        = self.modBtns and self.modUIBtns.isButton or _G.nop
	self.skinAllButtons  = self.modBtns and self.modUIBtns.skinAllButtons or _G.nop
	self.addButtonBorder = self.modBtnBs and self.modUIBtns.addButtonBorder or _G.nop

	-- track when Auction House is opened
	self:RegisterEvent("AUCTION_HOUSE_SHOW")
	-- track when Player enters World (used for texture updates and UIParent child processing)
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	-- track when Trade Skill is opened (used by MrTrader_SkillWindow)
	self:RegisterEvent("TRADE_SKILL_SHOW")
	-- track when trade frame is opened (used by ProfessionTabs)
	self:RegisterEvent("TRADE_SHOW")
	-- register for event after a slight delay as registering ADDON_LOADED any earlier causes it not to be registered if LoD modules are loaded on startup (e.g. SimpleSelfRebuff/LightHeaded)
	_G.C_Timer.After(0.5, function() self:RegisterEvent("ADDON_LOADED") end)
	-- skin the Blizzard frames
	_G.C_Timer.After(prdb.Delay.Init, function() self:BlizzardFrames() end)
	-- skin the loaded AddOns frames
	_G.C_Timer.After(prdb.Delay.Init + prdb.Delay.Addons, function() self:AddonFrames() end)
	-- schedule scan of UIParent's Children after all AddOns have been loaded
	_G.C_Timer.After(prdb.Delay.Init + prdb.Delay.Addons + 10, function() self:scanUIParentsChildren() end)

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

	-- hook to handle textured tabs on Blizzard & other Frames
	self.tabFrames = {}
	if self.isTT then
		self:SecureHook("PanelTemplates_UpdateTabs", function(frame)
			-- aObj:Debug("PanelTemplates_UpdateTabs: [%s, %s, %s]", frame, frame.selectedTab, frame.numTabs)
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
	local function reloadAddon() _G.StaticPopup_Show(aName .. "_Reload_UI") end

	-- handle profile changes
	self.db.RegisterCallback(self, "OnProfileChanged", reloadAddon)
	self.db.RegisterCallback(self, "OnProfileCopied", reloadAddon)
	self.db.RegisterCallback(self, "OnProfileReset", reloadAddon)

end

function aObj:getGradientInfo(invert, rotate)

	local c = self.db.profile.GradientMin
	local MinR, MinG, MinB, MinA = c.r, c.g, c.b, c.a
	c = self.db.profile.GradientMax
	local MaxR, MaxG, MaxB, MaxA = c.r, c.g, c.b, c.a

	if self.db.profile.Gradient.enable then
		if invert then
			return rotate and "HORIZONTAL" or "VERTICAL", MaxR, MaxG, MaxB, MaxA, MinR, MinG, MinB, MinA
		else
			return rotate and "HORIZONTAL" or "VERTICAL", MinR, MinG, MinB, MinA, MaxR, MaxG, MaxB, MaxA
		end
	else
		return rotate and "HORIZONTAL" or "VERTICAL", 0, 0, 0, 1, 0, 0, 0, 1
	end
	MinR, MinG, MinB, MinA, MaxR, MaxG, MaxB, MaxA = nil, nil, nil, nil, nil, nil, nil, nil

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
		rp = re-parent, reverse the parent child relationship
		sec = use the "SecureUnitButtonTemplate"
		nohooks = don't hook methods
--]]
--@alpha@
	assert(opts.obj, "Missing object __aSB\n" .. debugstack())
--@end-alpha@

	-- remove the object's Backdrop if it has one
	if opts.obj.GetBackdrop and opts.obj:GetBackdrop() then opts.obj:SetBackdrop(nil) end

	-- make all textures transparent, if required
	if opts.kfs then aObj:keepFontStrings(opts.obj) end

	opts.parent = opts.parent or opts.obj:GetParent()

	-- store button object within original button
	opts.obj.sb = _G.CreateFrame("Button", nil, opts.parent, opts.sec and "SecureUnitButtonTemplate" or nil)
	local btn = opts.obj.sb
	_G.LowerFrameLevel(btn)
	btn:EnableMouse(false) -- allow clickthrough

	if not opts.nohooks then
		opts.hook = opts.hook or opts.obj
		-- hook Show/Hide methods
        -- changed to hook scripts as functions don't always work
		aObj:secureHookScript(opts.hook, "OnShow", function(this) opts.obj.sb:Show() end)
		aObj:secureHookScript(opts.hook, "OnHide", function(this) opts.obj.sb:Hide() end)
		if opts.obj:IsObjectType("Button") then -- hook Enable/Disable methods
			aObj:secureHook(opts.hook, "Enable", function(this) opts.obj.sb:Enable() end)
			aObj:secureHook(opts.hook, "Disable", function(this) opts.obj.sb:Disable() end)
		end
		-- store reference to the button (used by addons, until they are all updated)
		if not opts.ft then aObj.sBtn[opts.hook] = btn end
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
		xOfs1, yOfs1, xOfs2, yOfs2 = nil, nil, nil, nil
	end
	-- setup applySkin options
	opts.aso = opts.aso or {}
	opts.aso.obj = btn
	aObj:applySkin(opts.aso)

	-- hide button skin, if required or not shown
	btn:SetShown(opts.obj:IsShown() and not opts.hide)

	 -- make sure it's lower than its parent's Frame Strata
	if opts.bg then btn:SetFrameStrata("BACKGROUND") end

	-- change the draw layer of the Icon and Count, if necessary
	if opts.obj.GetNumRegions then
		for _, reg in pairs{opts.obj:GetRegions()} do
			local regOT = reg:GetObjectType()
			if regOT == "Texture" or regOT == "FontString" then
				-- change the DrawLayer to make the Icon show if required
				if aObj:hasAnyTextInName(reg, {"[Ii]con", "[Cc]ount"})
				or aObj:hasTextInTexture(reg, "[Ii]con") then
					if reg:GetDrawLayer() == "BACKGROUND" then reg:SetDrawLayer("ARTWORK") end
				end
			end
			regOT = nil
		end
	end

	-- reverse parent child relationship
	if opts.rp then
		btn:SetParent(opts.obj:GetParent())
		opts.obj:SetParent(btn)
		opts.obj.SetParent_orig = opts.obj.SetParent
		opts.obj.SetParent = function(this, parent)
			this.sb:SetParent(parent)
			this:SetParent_orig(this.sb)
		end
	end

	return btn

end

function aObj:addSkinButton(...)

	local opts = select(1, ...)

--@alpha@
	assert(opts, "Missing object aSB\n" .. debugstack())
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

local function hideHeader(obj)

	-- hide the Header Texture and move the Header text, if required
	local hdr
	for _, htex in pairs{"Header", "_Header", "_HeaderBox", "_FrameHeader", "FrameHeader", "HeaderTexture", "HeaderFrame"} do
		hdr = _G[obj:GetName() .. htex]
		if hdr then
			hdr:Hide()
			hdr:SetPoint("TOP", obj, "TOP", 0, 7)
			break
		end
	end
	if obj.header then
		obj.header:DisableDrawLayer("BACKGROUND")
		obj.header:DisableDrawLayer("BORDER")
		aObj:moveObject{obj=obj.header.text, x=0, y=-6}
	end

end

local function __addSkinFrame(opts)
--[[
	Calling parameters:
		obj = object (Mandatory)
		ft = Frame Type (Skinner classification)
		kfs = Remove all textures, only keep font strings
		hat = Hide all textures
		rt = remove Textures
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
		rp = re-parent, reverse the parent child relationship
		sec = use the "SecureFrameTemplate"
--]]
--@alpha@
	assert(opts.obj, "Missing object __aSF\n" .. debugstack())
--@end-alpha@

	-- don't skin already skinned object
	if opts.obj.sf then return end

	-- remove the object's Backdrop if it has one
	if opts.obj.GetBackdrop and opts.obj:GetBackdrop() then opts.obj:SetBackdrop(nil) end

	-- store frame obj, if required
	if opts.ft then aObj:add2Table(aObj.gradFrames[opts.ft], opts.obj) end

	-- make all textures transparent, if required
	if opts.kfs or opts.hat then aObj:keepFontStrings(opts.obj, opts.hat) end

	-- remove all textures, if required
	if opts.rt then
		for _, reg in pairs{opts.obj:GetRegions()} do
			if not reg:IsObjectType("FontString") then
				reg:SetTexture(nil)
			end
		end
	end

	-- setup offset values
	opts.ofs = opts.ofs or 0
	local xOfs1 = opts.x1 or opts.ofs * -1
	local yOfs1 = opts.y1 or opts.ofs
	local xOfs2 = opts.x2 or opts.ofs
	local yOfs2 = opts.y2 or opts.ofs * -1

	-- add a frame around the current object
	opts.obj.sf = opts.obj.sf or _G.CreateFrame("Frame", nil, opts.obj, opts.sec and "SecureFrameTemplate" or nil)
	local skinFrame = opts.obj.sf
	skinFrame:ClearAllPoints()
	skinFrame:SetPoint("TOPLEFT", opts.obj, "TOPLEFT", xOfs1, yOfs1)
	skinFrame:SetPoint("BOTTOMRIGHT", opts.obj, "BOTTOMRIGHT", xOfs2, yOfs2)
	xOfs1, yOfs1, xOfs2, yOfs2 = nil, nil, nil, nil

	skinFrame:EnableMouse(false) -- allow clickthrough

	-- handle header, if required
	if opts.hdr then hideHeader(opts.obj) end

	-- setup applySkin options
	opts.aso = opts.aso or {}
	opts.aso.obj = skinFrame

	-- handle no Border, if required
	if opts.noBdr then opts.aso.bd = 11 end

	-- skin the frame using supplied options
	aObj:applySkin(opts.aso)

	-- adjust frame level
	local success, err = _G.pcall(_G.LowerFrameLevel, skinFrame) -- catch any error, doesn't matter if already 0
	if not success then _G.RaiseFrameLevel(opts.obj) end -- raise parent's Frame Level if 0
	success, err = nil, nil

	 -- make sure it's lower than its parent's Frame Strata
	if opts.bg then skinFrame:SetFrameStrata("BACKGROUND") end

	-- skin the buttons unless not required
	if not opts.nb then aObj:skinAllButtons{obj=opts.obj, bgen=opts.bgen, anim=opts.anim, as=opts.bas, ft=opts.ft} end

	-- remove inset textures
	if opts.ri then aObj:removeInset(opts.obj.Inset) end

	-- reverse parent child relationship
	if opts.rp
	and not opts.obj.SetParent_orig
	then
		skinFrame:SetParent(opts.obj:GetParent())
		opts.obj:SetParent(skinFrame)
		opts.obj.SetParent_orig = opts.obj.SetParent
		opts.obj.SetParent = function(this, parent)
			opts.obj.sf:SetParent(parent)
			this:SetParent_orig(opts.obj.sf)
		end
		-- hook Show and Hide methods
		aObj:SecureHook(opts.obj, "Show", function(this) this.sf:Show() end)
		aObj:SecureHook(opts.obj, "Hide", function(this) this.sf:Hide() end)
	end

	return skinFrame

end

function aObj:addSkinFrame(...)

	local opts = select(1, ...)

--@alpha@
	assert(opts, "Missing object aSF\n" .. debugstack())
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

	local prdb = self.db.profile
	-- don't apply a gradient if required
	if not prdb.Gradient.char then
		for _, v in pairs(self.gradFrames["p"]) do
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

	local invert = invert or prdb.Gradient.invert
	local rotate = rotate or prdb.Gradient.rotate

	obj.tfade = obj.tfade or obj:CreateTexture(nil, "BORDER", nil, -1)
	obj.tfade:SetTexture(self.gradientTex)
	obj.tfade:SetBlendMode("ADD")
	obj.tfade:SetGradientAlpha(self:getGradientInfo(invert, rotate))

	if prdb.FadeHeight.enable and (prdb.FadeHeight.force or not fh) then
		local objHeight = self:getInt(obj:GetHeight())
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

end

function aObj:applyTexture(obj)

	obj.tbg = obj:CreateTexture(nil, "BORDER")
	obj.tbg:SetTexture(self.LSM:Fetch("background", self.bgTexName), true) -- have to use true for tiling to work
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
	assert(opts.obj, "Missing object __aS\n" .. debugstack())
--@end-alpha@

	local hasIOT = assert(opts.obj.IsObjectType, "The Object passed isn't a Frame") -- throw an error here to get its original location reported
	if hasIOT and not opts.obj:IsObjectType("Frame") then
		if aObj.db.profile.Errors then
			aObj:CustomPrint(1, 0, 0, "Error skinning", opts.obj.GetName and opts.obj:GetName() or opts.obj, "not a Frame or subclass of Frame:", opts.obj:GetObjectType())
			return
		end
	end
	hasIOT = nil

	-- store frame obj, if required
	if opts.ft then aObj:add2Table(aObj.gradFrames[opts.ft], opts.obj) end

	-- make all textures transparent, if required
	if opts.kfs then aObj:keepFontStrings(opts.obj) end

	-- setup the backdrop
	opts.obj:SetBackdrop(aObj.Backdrop[opts.bd or 1])
	if not opts.ebc then
		-- colour the backdrop if required
		local r, g, b, a = aObj.bColour[1], aObj.bColour[2], aObj.bColour[3], aObj.bColour[4]
		opts.obj:SetBackdropColor(r, g, b, opts.ba or a)
		r, g, b, a = aObj.bbColour[1], aObj.bbColour[2], aObj.bbColour[3], aObj.bbColour[4]
		opts.obj:SetBackdropBorderColor(r, g, b, opts.bba or a)
		r, g, b, a = nil, nil, nil, nil
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

	local opts = select(1, ...)

--@alpha@
	assert(opts, "Missing object aS\n" .. debugstack())
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
	opts = nil

end

local function __adjHeight(opts)
--[[
	Calling parameters:
		obj = object (Mandatory)
		adj = value to adjust height by
--]]
--@alpha@
	assert(opts.obj, "Missing object __aH\n" .. debugstack())
--@end-alpha@
	if opts.adj == 0 then return end

	if not _G.strfind(_G.tostring(opts.adj), "+") then -- if not negative value
		opts.obj:SetHeight(opts.obj:GetHeight() + opts.adj)
	else
		opts.adj = opts.adj * -1 -- make it positive
		opts.obj:SetHeight(opts.obj:GetHeight() - opts.adj)
	end

end

function aObj:adjHeight(...)

	local opts = select(1, ...)

--@alpha@
	assert(opts, "Missing object aH\n" .. debugstack())
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
	opts = nil

end

local function __adjWidth(opts)
--[[
	Calling parameters:
		obj = object (Mandatory)
		adj = value to adjust width by
--]]
--@alpha@
	assert(opts.obj, "Missing object __aW\n" .. debugstack())
--@end-alpha@
	if opts.adj == 0 then return end

	if not _G.strfind(_G.tostring(opts.adj), "+") then -- if not negative value
		opts.obj:SetWidth(opts.obj:GetWidth() + opts.adj)
	else
		opts.adj = opts.adj * -1 -- make it positive
		opts.obj:SetWidth(opts.obj:GetWidth() - opts.adj)
	end

end

function aObj:adjWidth(...)

	local opts = select(1, ...)

--@alpha@
	assert(opts, "Missing object aW\n" .. debugstack())
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
	opts = nil

end

function aObj:glazeStatusBar(statusBar, fi, bgTex, otherTex, hookFunc)
--@alpha@
	assert(statusBar, "Missing object __gSB\n" .. debugstack())
	assert(statusBar:IsObjectType("StatusBar"), "Not a StatusBar\n" .. debugstack())
--@end-alpha@

	statusBar:SetStatusBarTexture(self.sbTexture)

	if not self.sbGlazed[statusBar] then
		self.sbGlazed[statusBar] = {}
	end
	local sbG = self.sbGlazed[statusBar]

	-- local sbTex = statusBar:GetStatusBarTexture()
	-- -- fix for tiling introduced in 3.3.3 (Thanks to foreverphk)
	-- sbTex:SetHorizTile(false)
	-- sbTex:SetVertTile(false)

	if fi then
		if not sbG.bg then
			-- create background texture on a lower sublevel
			sbG.bg = bgTex or statusBar:CreateTexture(nil, "BACKGROUND", nil, -1)
			sbG.bg:SetTexture(self.sbTexture)
			sbG.bg:SetVertexColor(self.sbColour[1], self.sbColour[2], self.sbColour[3])
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
			tex:SetVertexColor(self.sbColour[1], self.sbColour[2], self.sbColour[3])
			sbG[#sbG + 1] = tex
		end
	end

	if hookFunc then
		self:RawHook(statusBar, "SetStatusBarTexture", function(this, tex)
			-- self.hooks[this].SetStatusBarTexture(this, self.sbTexture)
		end, true)
		-- this is used by PVPHonorXPBar
		if statusBar.SetStatusBarAtlas then
			self:RawHook(statusBar, "SetStatusBarAtlas", function(this, tex)
			end, true)
		end
	end

end

function aObj:keepFontStrings(obj, hide)
--@alpha@
	assert(obj, "Missing object kFS\n" .. debugstack())
--@end-alpha@

	local regs = {obj:GetRegions()}
	for _, reg in ipairs(regs) do
		if not reg:IsObjectType("FontString") then
			if not hide then reg:SetAlpha(0) else reg:Hide() end
		end
	end
	regs = nil

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
	assert(obj, "Missing object kR\n" .. debugstack())
--@end-alpha@

	local regions = revTable(regions)

	local regs = {obj:GetRegions()}
	for k, reg in ipairs(regs) do
		-- if we have a list, hide the regions not in that list
		if regions
		and not regions[k]
		then
			reg:SetAlpha(0)
--@debug@
			if reg:IsObjectType("FontString") then
				self:Debug("kr FS: [%s, %s]", obj, k)
				self:Print(debugstack(1, 5, 2))
			end
--@end-debug@
		end
	end
	regions, regs = nil, nil

end

function aObj:makeMFRotatable(modelFrame)
--@alpha@
	assert(modelFrame and modelFrame:IsObjectType("PlayerModel"), "Not a PlayerModel\n" .. debugstack())
--@end-alpha@

	-- Don't make Model Frames Rotatable if CloseUp is loaded
	if _G.IsAddOnLoaded("CloseUp") then return end

	--frame:EnableMouseWheel(true)
	modelFrame:EnableMouse(true)
	modelFrame.draggingDirection = nil
	modelFrame.cursorPosition = {}

	-- hide rotation buttons
	for _, child in pairs{modelFrame:GetChildren()} do
		if self:hasTextInName(child, "Rotate") then
			child:Hide()
		end
	end
	if modelFrame.RotateLeftButton then
		modelFrame.RotateLeftButton:Hide()
		modelFrame.RotateRightButton:Hide()
	end

	self:secureHookScript(modelFrame, "OnUpdate", function(this, elapsedTime, ...)
		if this.dragging then
			local x, y = _G.GetCursorPosition()
			if this.cursorPosition.x > x then
				_G.Model_RotateLeft(this, (this.cursorPosition.x - x) * elapsedTime * 2)
			elseif this.cursorPosition.x < x then
				_G.Model_RotateRight(this, (x - this.cursorPosition.x) * elapsedTime * 2)
			end
			this.cursorPosition.x, this.cursorPosition.y = _G.GetCursorPosition()
			x, y = nil, nil
		end
	end)
	self:secureHookScript(modelFrame, "OnMouseDown", function(this, button)
		if button == "LeftButton" then
			this.dragging = true
			this.cursorPosition.x, this.cursorPosition.y = _G.GetCursorPosition()
		end
	end)
	self:secureHookScript(modelFrame, "OnMouseUp", function(this, button)
		if this.dragging then
			this.dragging = false
			this.cursorPosition.x, this.cursorPosition.y = nil
		end
	end)

	--[[ MouseWheel to zoom Modelframe - in/out works, but needs to be fleshed out
	modelFrame:SetScript("OnMouseWheel", function()
		local xPos, yPos, zPos = frame:GetPosition()
		if arg1 == 1 then
			modelFrame:SetPosition(xPos+00.1, 0, 0)
		else
			modelFrame:SetPosition(xPos-00.1, 0, 0)
		end
	end) ]]

	if modelFrame.controlFrame then
		modelFrame.controlFrame:DisableDrawLayer("BACKGROUND")
	end

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
	assert(opts.obj, "Missing object __mO\n" .. debugstack())
--@end-alpha@

	if not opts.obj then return end

--@debug@
	if opts.obj:GetNumPoints() > 1 then
		aObj:CustomPrint(1, 0, 0, "moveObject: %s, GetNumPoints = %d", opts.obj, opts.obj:GetNumPoints())
		return
	end
--@end-debug@

	local point, relTo, relPoint, xOfs, yOfs = opts.obj:GetPoint()

	-- handle no Point info
	if not point then return end

	relTo = opts.relTo or relTo
--@alpha@
	assert(relTo, "__moveObject relTo is nil\n" .. debugstack())
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

	point, relTo, relPoint, xOfs, yOfs = nil, nil, nil, nil, nil

end

function aObj:moveObject(...)

	local opts = select(1, ...)

--@alpha@
	assert(opts, "Missing object mO\n" .. debugstack())
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
	opts = nil

end

function aObj:removeRegions(obj, regions)
--@alpha@
	assert(obj, "Missing object rR\n" .. debugstack())
--@end-alpha@

	local regions = revTable(regions)

	local regs = {obj:GetRegions()}
	for k, reg in ipairs(regs) do
		if not regions
		or regions
		and regions[k]
		then
			reg:SetAlpha(0)
--@debug@
			if reg:IsObjectType("FontString") then
				self:Debug("rr FS: [%s, %s]", obj, k)
				self:Print(debugstack(1, 5, 2))
			end
--@end-debug@
		end
	end
	regions, regs = nil, nil

end

function aObj:rmRegionsTex(obj, regions)
--@alpha@
	assert(obj, "Missing object rRT\n" .. debugstack())
--@end-alpha@

	local regions = revTable(regions)

	local regs = {obj:GetRegions()}
	for k, reg in ipairs(regs) do
		if not regions
		or regions
		and regions[k]
		then
			if reg:IsObjectType("Texture") then
				reg:SetTexture(nil)
--@debug@
			elseif reg:IsObjectType("FontString") then
				self:Debug("rRT FS: [%s, %s]", obj:GetName() or "<Anon>", k)
				self:Print(debugstack(1, 5, 2))
--@end-debug@
			end
		end
	end
	regions, regs = nil, nil

end

function aObj:setActiveTab(tabSF)
--@alpha@
	-- assert(tabSF, "Missing object sAT\n" .. debugstack())
--@end-alpha@

	if not tabSF then return end
	if not tabSF.tfade then return end

	tabSF.tfade:SetTexture(self.gradientTex)
	tabSF.tfade:SetGradientAlpha(self:getGradientInfo(self.db.profile.Gradient.invert, self.db.profile.Gradient.rotate))

	local point, relativeTo, relativePoint, xOfs, yOfs
	if not tabSF.ignore and not tabSF.grown then
		if not tabSF.up then
			point, relativeTo, relativePoint, xOfs, yOfs = tabSF:GetPoint(2)
			tabSF:SetPoint("BOTTOMRIGHT", relativeTo, "BOTTOMRIGHT", xOfs, yOfs - 6)
		else
			point, relativeTo, relativePoint, xOfs, yOfs = tabSF:GetPoint(1)
			tabSF:SetPoint("TOPLEFT", relativeTo, "TOPLEFT", xOfs, yOfs + 6)
		end
		tabSF.grown = true
	end
	point, relativeTo, relativePoint, xOfs, yOfs = nil, nil, nil, nil, nil

end

function aObj:setInactiveTab(tabSF)
--@alpha@
	assert(tabSF, "Missing object sIT\n" .. debugstack())
--@end-alpha@

	if not tabSF then return end
	if not tabSF.tfade then return end

	tabSF.tfade:SetTexture(self.itTex)
	tabSF.tfade:SetAlpha(1)
	local point, relativeTo, relativePoint, xOfs, yOfs
	if not tabSF.ignore and tabSF.grown then
		if not tabSF.up then
			point, relativeTo, relativePoint, xOfs, yOfs = tabSF:GetPoint(2)
			tabSF:SetPoint("BOTTOMRIGHT", relativeTo, "BOTTOMRIGHT", xOfs, yOfs + 6)
		else
			point, relativeTo, relativePoint, xOfs, yOfs = tabSF:GetPoint(1)
			tabSF:SetPoint("TOPLEFT", relativeTo, "TOPLEFT", xOfs, yOfs - 6)
		end
		tabSF.grown = nil
	end
	point, relativeTo, relativePoint, xOfs, yOfs = nil, nil, nil, nil, nil

end

function aObj:shrinkBag(obj, bpMF)
--@alpha@
	assert(obj, "Missing object sB\n" .. debugstack())
--@end-alpha@

	if not obj then return end

	local prdb = self.db.profile
	local objName = obj:GetName()
	local bgTop = _G[objName .. "BackgroundTop"]
	local bgtHgt = self:getInt(bgTop:GetHeight())
	if bgtHgt == 256 then -- this is the backpack
		if bpMF then -- is this a backpack Money Frame
			local yOfs = select(5, _G[objName .. "MoneyFrame"]:GetPoint())
			if self:getInt(yOfs) == -216 or self:getInt(yOfs) == -217 then -- is it still in its original position
				self:moveObject{obj=_G[objName .. "MoneyFrame"], y=22}
			end
			yOfs = nil
		end
		self:moveObject{obj=_G[objName .. "Item1"], y=19}
	end

	-- adjust bag height as required
	-- 8, 12, 16, 20, 24, 28, 32, 36 slots
	if bgtHgt == 94
	or bgtHgt == 86
	then
		self:adjHeight{obj=obj, adj=-20}
	elseif bgtHgt == 72	then -- 6, 10 or 14 slots
		self:adjHeight{obj=obj, adj=2}
	end

	self:adjWidth{obj=obj, adj=-10}
	self:moveObject{obj=_G[objName .. "Item1"], x=3}

	local objHeight = self:getInt(obj:GetHeight())
	-- use default fade height
	local fh = prdb.ContainerFrames.fheight <= objHeight and prdb.ContainerFrames.fheight or objHeight

	if prdb.FadeHeight.enable and prdb.FadeHeight.force then
	-- set the Fade Height
	-- making sure that it isn't greater than the frame height
		fh = prdb.FadeHeight.value <= objHeight and prdb.FadeHeight.value or objHeight
	end

	if fh and obj.tfade then obj.tfade:SetPoint("BOTTOMRIGHT", obj, "TOPRIGHT", -4, -fh) end

	objName, bgtHgt, objHeight, fh = nil, nil, nil, nil

end

function aObj:skinColHeads(buttonName, noCols)

	noCols = noCols or 4
	local btn
	for i = 1, noCols do
		btn = _G[buttonName .. i]
		if not btn.sb then -- only do if not already skinned
			self:removeRegions(btn, {1, 2, 3})
			self:addSkinFrame{obj=btn}
		end
	end

end

local function __skinDropDown(opts)
--[[
	Calling parameters:
		obj = object (Mandatory)
		noSkin = don't skin the DropDown
		x1 = X offset for TOPLEFT
		y1 = Y offset for TOPLEFT
		x2 = X offset for BOTTOMRIGHT
		y2 = Y offset for BOTTOMRIGHT
		rp = re-parent, reverse the parent child relationship (addSkinFrame option)
		ign = ignore this dropdown when skinning IOF panels
		noBB = don't add a border around the button
--]]
--@alpha@
	assert(opts.obj, "Missing object __sDD\n" .. debugstack())
--@end-alpha@

--@debug@
	if opts.noMove
	or opts.moveTex
	or opts.mtx
	or opts.mty
	then
		aObj:CustomPrint(1, 0, 0, "skinDropDown: %s, deprecated option used", opts.obj)
	end
--@end-debug@

	if aObj:hasAnyTextInName(opts.obj, {"tekKonfigDropdown", "Left"}) -- ignore tekKonfigDropdown/Az DropDowns
	and not opts.obj.LeftTexture -- handle MC2UIElementsLib ones (used by GroupCalendar5)
	then
		return
	end

	-- don't skin it twice
	if opts.obj.sknd then
		return
	else
		opts.obj.sknd = true
	end

	-- hide textures
	aObj:removeRegions(opts.obj, {1, 2, 3})

	-- return if not to be skinned
	if not aObj.db.profile.TexturedDD
	and not aObj.db.profile.DropDownButtons
	or opts.noSkin
	then
		return
	end

	-- add texture
	opts.obj.ddTex = opts.obj:CreateTexture(nil, "ARTWORK", -5) -- appear behind text
	opts.obj.ddTex:SetTexture(aObj.db.profile.TexturedDD and aObj.itTex or nil)
	-- align it to the middle texture
	opts.obj.ddTex:SetPoint("LEFT", opts.obj.Left or _G[opts.obj:GetName() .. "Left"], "RIGHT", -5, 2)
	opts.obj.ddTex:SetPoint("RIGHT", opts.obj.Right or _G[opts.obj:GetName() .. "Right"], "LEFT", 5, 2)
	opts.obj.ddTex:SetHeight(18)

	local xOfs1 = opts.x1 or 15
	local yOfs1 = opts.y1 or 0
	local xOfs2 = opts.x2 or -15
	local yOfs2 = opts.y2 or 6
	-- skin the frame
	if aObj.db.profile.DropDownButtons then
		aObj:addSkinFrame{obj=opts.obj, ft=opts.ftype, aso={ng=true}, rp=opts.rp, nb=true, x1=xOfs1, y1=yOfs1, x2=xOfs2, y2=yOfs2}
	end
	-- add a button border around the dd button
	if not opts.noBB then
		aObj:addButtonBorder{obj=opts.obj.Button or _G[opts.obj:GetName() .. "Button"], es=12, ofs=-2, x1=1}
	end

	-- stop dropdowns being skinned when IOF panel opened
	if opts.ign then aObj.ignoreIOF[opts.obj] = true end

	xOfs1, yOfs1, xOfs2, yOfs2 = nil, nil, nil, nil

end

function aObj:skinDropDown(...)

	local opts = select(1, ...)

--@alpha@
	assert(opts, "Missing object sDD\n" .. debugstack())
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
	opts = nil

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
		mi = move search icon/instructions to the right
		ign = ignore this editbox when skinning IOF panels
		nis = Numeric Input Spinner
--]]
--@alpha@
	assert(opts.obj, "Missing object __sEB\n" .. debugstack())
	assert(opts.obj:IsObjectType("EditBox"), "Not an EditBox\n" .. debugstack())
--@end-alpha@

	-- don't skin it twice
	if opts.obj.sknd then
		return
	else
		opts.obj.sknd = true
	end

	opts.x = opts.x or 0
	opts.y = opts.y or 0

	local kRegions = CopyTable(aObj.ebRgns)
	if opts.regs then
		for _, v in pairs(opts.regs) do
			aObj:add2Table(kRegions, v)
		end
	end
	aObj:keepRegions(opts.obj, kRegions)
	kRegions = nil

	if not opts.noInsert then
		-- adjust the left & right text inserts
		local l, r, t, b = opts.obj:GetTextInsets()
		opts.obj:SetTextInsets(l + 5, r + 5, t, b)
		l, r, t, b = nil, nil, nil, nil
	end

	-- change height, if required
	if not (opts.noHeight or opts.obj:IsMultiLine()) then opts.obj:SetHeight(24) end

	-- change width, if required
	if not opts.noWidth then opts.obj:SetWidth(opts.obj:GetWidth() + 8) end

	-- apply the backdrop
	if not opts.noSkin then aObj:skinUsingBD{obj=opts.obj} end

	-- move to the left & up, if required
	if opts.move then opts.x, opts.y = -2, 2 end

	-- move left/right & up/down, if required
	if opts.x ~= 0 or opts.y ~= 0 then aObj:moveObject{obj=opts.obj, x=opts.x or 0, y=opts.y or 0} end

	-- move the search icon to the right, if required
	local xOfs = 4
	if opts.mi then
		if opts.obj.searchIcon then
			aObj:moveObject{obj=opts.obj.searchIcon, x=xOfs} -- e.g. BagItemSearchBox
		elseif opts.obj.Instructions then -- e.g. InputBoxInstructionsTemplate (WoD)
			opts.obj.Instructions:ClearAllPoints()
			opts.obj.Instructions:SetPoint("Left", opts.obj, "Left", xOfs + 2, 0)
		elseif opts.obj.icon then
			aObj:moveObject{obj=opts.obj.icon, x=xOfs} -- e.g. FriendsFrameBroadcastInput
		elseif _G[opts.obj:GetName() .. "SearchIcon"] then
			aObj:moveObject{obj=_G[opts.obj:GetName() .. "SearchIcon"], x=xOfs} -- e.g. TradeSkillFrameSearchBox
		else -- e.g. WeakAurasFilterInput
			for _, reg in pairs{opts.obj:GetRegions()} do
				if aObj:hasTextInTexture(reg, "UI-Searchbox-Icon") then aObj:moveObject{obj=reg, x=xOfs} end
			end
		end
	end
	xOfs = nil

	-- stop editbox being skinned when IOF panel opened
	if opts.ign then aObj.ignoreIOF[opts.obj] = true end

	-- handle movement and buttons if it's a Numeric Input Spinner
	if opts.nis then
		aObj:moveObject{obj=opts.obj, x=-8}
		aObj:moveObject{obj=opts.obj.DecrementButton, x=6}
		aObj:addButtonBorder{obj=opts.obj.IncrementButton, ofs=-2, es=10}
		aObj:addButtonBorder{obj=opts.obj.DecrementButton, ofs=-2, es=10}
	end

end

function aObj:skinEditBox(...)

	local opts = select(1, ...)

--@alpha@
	assert(opts, "Missing object sEB\n" .. debugstack())
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
	opts = nil

end

if aObj.isPTR then
	function aObj:skinMaxMinFrame(obj, childNum)

		local mmf = self:getChild(obj, childNum) -- MaximizeMinimizeFrame
		self:skinButton{obj=mmf.MaximizeButton, ob3="↕"} -- up-down arrow
		self:skinButton{obj=mmf.MinimizeButton, ob3="↕"} -- up-down arrow
		mmf = nil

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
	assert(opts.obj, "Missing object __sMF\n" .. debugstack())
--@end-alpha@

	-- don't skin it twice
	if opts.obj.sknd then
		return
	else
		opts.obj.sknd = true
	end

	local obj
	for k, v in pairs{"Gold", "Silver", "Copper"} do
		obj = _G[opts.obj:GetName()..v]
		aObj:skinEditBox{obj=obj, regs={6, 7}, noHeight=true, noWidth=true, ign=true} -- N.B. region 6 is the icon, 7 is text
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

	local opts = select(1, ...)

--@alpha@
	assert(opts, "Missing object sMF\n" .. debugstack())
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
	opts = nil

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
	-- handle AddOn skins still using this code rather than skinSlider
	assert(opts.obj and opts.obj:IsObjectType("Frame"), "Not a ScrollFrame\n" .. debugstack())
	assert(opts.obj and _G[opts.obj:GetName() .. "ScrollBar"]:IsObjectType("Slider"), "Not a Slider\n" .. debugstack())
	aObj:CustomPrint(1, 0, 0, "Using deprecated function - skinScrollBar", opts.obj)
--@end-alpha@

	-- don't skin it twice
	if opts.obj.sknd then
		return
	else
		opts.obj.sknd = true
	end

	-- remove all the object's regions except text ones, if required
	if not opts.noRR then aObj:keepFontStrings(opts.obj) end

	-- get the actual ScrollBar object
	local sBar = _G[opts.obj:GetName() .. "ScrollBar"]
	-- local sBar = opts.sbObj and opts.sbObj or _G[opts.obj:GetName() .. (opts.sbPrefix or "") .. "ScrollBar"]

	-- skin it
	aObj:skinUsingBD{obj=sBar, size=opts.size}

end

function aObj:skinScrollBar(...)

	local opts = select(1, ...)

--@alpha@
	assert(opts, "Missing object sSB\n" .. debugstack())
--@end-alpha@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if type(rawget(opts, 0)) == "userdata" and type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = select(1, ...) and select(1, ...) or nil
		-- opts.sbPrefix = select(2, ...) and select(2, ...) or nil
		-- opts.sbObj = select(3, ...) and select(3, ...) or nil
		opts.size = select(4, ...) and select(4, ...) or 2
	end

	__skinScrollBar(opts)
	opts = nil

end

local function __skinSlider(opts)
--[[
	Calling parameters:
		obj = object (Mandatory)
		size = backdrop size to use (2 - wide, 3 - medium, 4 - narrow) [default is 3]
		-- adj = width reduction required ()
		wdth = width reduction required
		hgt = height reduction required
		rt = remove textures from parent
--]]
--@alpha@
	assert(opts.obj and opts.obj:IsObjectType("Slider"), "Not a Slider\n" .. debugstack())
--@end-alpha@

	-- don't skin it twice
	if opts.obj.sknd then
		return
	else
		opts.obj.sknd = true
	end

	aObj:keepFontStrings(opts.obj)
	opts.obj:SetAlpha(1)
	opts.obj:GetThumbTexture():SetAlpha(1)

	aObj:skinUsingBD{obj=opts.obj, size=opts.size}

	-- adjust width if required
	if opts.wdth then aObj:adjWidth{obj=opts.obj, adj=opts.wdth} end
	-- adjust height if required (horizontal orientation)
	if opts.hgt then aObj:adjHeight{obj=opts.obj, adj=opts.hgt} end

	-- remove parent's textures if required
	if opts.rt then
		if type(opts.rt) == "table" then
			for _, v in pairs(opts.rt) do
				opts.obj:GetParent():DisableDrawLayer(v)
			end
		else
			opts.obj:GetParent():DisableDrawLayer(opts.rt)
		end
	end

end

function aObj:skinSlider(...)

	local opts = select(1, ...)

--@alpha@
	assert(opts, "Missing object sS\n" .. debugstack())
--@end-alpha@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if type(rawget(opts, 0)) == "userdata" and type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = select(1, ...) and select(1, ...) or nil
		opts.size = select(2, ...) and select(2, ...) or 2
	end

	-- handle change of parameter name: adj -> wdth
	if opts.adj then
		opts.wdth = opts.adj
		opts.adj = nil
	end

	__skinSlider(opts)
	opts = nil

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
		bg = put in background so highlight is visible (e.g. Garrison LandingPage)
		x1 = X offset for TOPLEFT
		y1 = Y offset for TOPLEFT
		x2 = X offset for BOTTOMRIGHT
		y2 = Y offset for BOTTOMRIGHT
		ignht = don't change Highlight texture (AchievementUI)
--]]
--@alpha@
	assert(opts.obj and opts.obj:IsObjectType("Frame"), "Not a Frame\n" .. debugstack())
--@end-alpha@

	-- don't skin it twice
	if aObj.tabFrames[opts.obj] then
		return
	end

	-- use supplied name or existing name (Ace3 TabGroup fix)
	local tabName = opts.name or opts.obj:GetName()
	tabName =  tabName .. "Tab" .. (opts.suffix or "")

	local kRegions = {7, 8} -- N.B. region 7 is text, 8 is highlight for some tabs
	if opts.regs then
		for _, v in pairs(opts.regs) do
			aObj:add2Table(kRegions, v)
		end
	end

	local xOfs1 = opts.x1 or 6
	local yOfs1 = opts.y1 or 0
	local xOfs2 = opts.x2 or -6
	local yOfs2 = opts.y2 or 2

	local tabID, tab = opts.obj.selectedTab or 1
	for i = 1, opts.obj.numTabs do
		tab = _G[tabName .. i]
		aObj:keepRegions(tab, kRegions)
		aObj:addSkinFrame{obj=tab, ft=opts.ftype, noBdr=aObj.isTT, bg=opts.bg or false, x1=xOfs1, y1=yOfs1, x2=xOfs2, y2=yOfs2}
		tab.sf.ignore = opts.ignore -- ignore size changes
		tab.sf.up = opts.up -- tabs grow upwards
		if opts.lod then -- set textures here first time thru as it's LoD
			if aObj.isTT then
				if i == tabID then
					aObj:setActiveTab(tab.sf)
				else
					aObj:setInactiveTab(tab.sf)
				end
			end
		end
		if not opts.ignht then
			-- change highlight texture
			local ht = tab:GetHighlightTexture()
			if ht then -- handle other AddOns using tabs without a highlight texture
				ht:SetTexture([[Interface\PaperDollInfoFrame\UI-Character-Tab-Highlight]])
				ht:ClearAllPoints()
				if opts.up then -- (GuildInfoFrame, LookingForGuild, MacroFrame, FriendsTabHeader)
					ht:SetPoint("TOPLEFT", 1, -5)
					ht:SetPoint("BOTTOMRIGHT", -1, -5)
				else
					ht:SetPoint("TOPLEFT", 8, 2)
					ht:SetPoint("BOTTOMRIGHT", -8, 0)
				end
			end
			ht = nil
		end
	end
	aObj.tabFrames[opts.obj] = true

	tabName, kRegions, xOfs1, yOfs1, xOfs2, yOfs2, tabID, tab = nil, nil, nil, nil, nil, nil, nil, nil

end

function aObj:skinTabs(...)

	local opts = select(1, ...)

--@alpha@
	assert(opts, "Missing object sS\n" .. debugstack())
--@end-alpha@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if type(rawget(opts, 0)) == "userdata" and type(opts.GetObjectType) == "function" then
		-- old style call
		opts = {}
		opts.obj = select(1, ...) and select(1, ...) or nil
	end

	__skinTabs(opts)
	opts = nil

end

function aObj:skinToggleTabs(tabName, tabCnt, noHeight)

	local togTab
	for i = 1, tabCnt or 3 do
		togTab = _G[tabName .. i]
		if not togTab then break end -- handle missing Tabs (e.g. Muted)
		if not togTab.sknd then -- don't skin it twice
			self:keepRegions(togTab, {7, 8}) -- N.B. regions 7 & 8 are text & highlight
			if not noHeight then self:adjHeight{obj=togTab, adj=-5}	end
			self:addSkinFrame{obj=togTab, y1=-2, x2=2, y2=-2}
		end
	end

end

function aObj:skinTooltip(obj)
	if not self.db.profile.Tooltips.skin then return end
--@alpha@
	assert(obj, "Missing object sT\n" .. debugstack())
--@end-alpha@

	if not obj then return end

 	local prdb = self.db.profile
	if not prdb.Gradient.ui then return end

	-- add background texture if required
	if prdb.Tooltips.style == 3 then
		if prdb.BgUseTex then
			if not obj.tbg then self:applyTexture(obj) end
		elseif obj.tbg then
			obj.tbg = nil -- remove background texture if it exists
		end
	end

	obj.tfade = obj.tfade or obj:CreateTexture(nil, "BORDER")
	obj.tfade:SetTexture(self.gradientTex)

	obj.tfade:ClearAllPoints()
	if prdb.Tooltips.style == 1 then -- Rounded
		obj.tfade:SetPoint("TOPLEFT", obj, "TOPLEFT", 6, -6)
		obj.tfade:SetPoint("BOTTOMRIGHT", obj, "TOPRIGHT", -6, -27)
	elseif prdb.Tooltips.style == 2 then -- Flat
		obj.tfade:SetPoint("TOPLEFT", obj, "TOPLEFT", 4, -4)
		obj.tfade:SetPoint("BOTTOMRIGHT", obj, "BOTTOMRIGHT", -4, 4)
	else -- Custom
		obj.tfade:SetPoint("TOPLEFT", obj, "TOPLEFT", 4, -4)
		-- set the Fade Height making sure that it isn't greater than the frame height
		local objHeight = self:getInt(obj:GetHeight())
		local fh = prdb.FadeHeight.value <= objHeight and prdb.FadeHeight.value or objHeight
		obj.tfade:SetPoint("BOTTOMRIGHT", obj, "TOPRIGHT", -4, -(fh - 4))
		obj:SetBackdropColor(self.bColour[1], self.bColour[2], self.bColour[3], self.bColour[4])
		objHeight, fh = nil, nil
	end

	obj.tfade:SetBlendMode("ADD")
	obj.tfade:SetGradientAlpha(self:getGradientInfo(prdb.Gradient.invert, prdb.Gradient.rotate))

	-- Check to see if we need to colour the Border
	if not self.ttBorder then
		local r, g, b, a
		for _, tip in pairs(self.ttCheck) do
			if tip == obj:GetName() then
				r, g, b, a = obj:GetBackdropBorderColor()
				if self:getInt(r) ~= 1
				or self:getInt(g) ~= 1
				or self:getInt(b) ~= 1
				or self:getInt(a) ~= 1
				then
					return
				end
			end
		end
		r, g, b, a = nil, nil, nil, nil
	end

	obj:SetBackdropBorderColor(prdb.Tooltips.border == 1 and self.tbColour[1], self.tbColour[2], self.tbColour[3], self.tbColour[4] or self.bbColour[1], self.bbColour[2], self.bbColour[3], self.bbColour[4])

	prdb = nil

end

local function __skinUsingBD(opts)
--[[
	Calling parameters:
		obj = object (Mandatory)
		size = backdrop size to use (2 - wide, 3 - medium, 4 - narrow)
--]]
--@alpha@
	assert(opts.obj, "Missing object __sUBD\n" .. debugstack())
--@end-alpha@

	opts.size = opts.size or 3 -- default to medium

	opts.obj:SetBackdrop(aObj.Backdrop[opts.size])
	opts.obj:SetBackdropBorderColor(.2, .2, .2, 1)
	opts.obj:SetBackdropColor(.1, .1, .1, 1)

end

function aObj:skinUsingBD(...)

	local opts = select(1, ...)

--@alpha@
	assert(opts, "Missing object sUBD\n" .. debugstack())
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
	opts = nil

end

function aObj:skinUsingBD2(obj)

	self:skinUsingBD{obj=obj, size=2}

end
