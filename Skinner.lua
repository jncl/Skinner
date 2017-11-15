local aName, aObj = ...
local _G = _G

local assert, CopyTable, debugstack, ipairs, pairs, rawget, select, type, unpack, Round = _G.assert, _G.CopyTable, _G.debugstack, _G.ipairs, _G.pairs, _G.rawget, _G.select, _G.type, _G.unpack, _G.Round
local LibStub = _G.LibStub

do
	-- check to see if required libraries are loaded
	assert(LibStub, aName .. " requires LibStub")
	local lTab = {"CallbackHandler-1.0", "AceAddon-3.0", "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0", "AceLocale-3.0", "LibSharedMedia-3.0", "AceDB-3.0", "AceDBOptions-3.0", "AceGUI-3.0",  "AceConfig-3.0", "AceConfigCmd-3.0", "AceConfigRegistry-3.0", "AceConfigDialog-3.0", "LibDataBroker-1.1", "LibDBIcon-1.0"}
	for i = 1, #lTab do
		assert(LibStub:GetLibrary(lTab[i], true), aName .. " requires " .. lTab[i])
	end
	lTab = nil

	-- create the addon
	_G[aName] = LibStub:GetLibrary("AceAddon-3.0"):NewAddon(aObj, aName, "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")

	-- add callbacks
	aObj.callbacks = LibStub:GetLibrary("CallbackHandler-1.0"):New(aObj)

	-- Get Locale
	aObj.L = LibStub:GetLibrary("AceLocale-3.0"):GetLocale(aName)

	-- pointer to LibSharedMedia-3.0 library
	aObj.LSM = LibStub:GetLibrary("LibSharedMedia-3.0")

	-- player class
	aObj.uCls = select(2, _G.UnitClass("player"))
	-- player level
	aObj.uLvl = _G.UnitLevel("player")

	local ptrInfo = {"7.3.2", 25497}
	local liveInfo = {"7.3.2", 25497}
	local betaInfo = {"8.0.0", 99999}
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
	aObj.blizzFrames = {p = {}, n = {}, u = {}, opt = {}}
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
	self:checkAndRun("SetupDefaults", "opt", false, true)
	-- store shortcut
	self.prdb = self.db.profile
	local dflts = self.db.defaults.profile

	-- convert any old settings
	if type(self.prdb.MinimapButtons) == "boolean" then
		self.prdb.MinimapButtons = {skin = true, style = false}
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
	-- register any User defined textures used
	if self.prdb.BdFile and self.prdb.BdFile ~= "None" then
		self.LSM:Register("background", aName .. " User Backdrop", self.prdb.BdFile)
	end
	if self.prdb.BdEdgeFile and self.prdb.BdEdgeFile ~= "None" then
		self.LSM:Register("border", aName .. " User Border", self.prdb.BdEdgeFile)
	end
	if self.prdb.BgFile and self.prdb.BgFile ~= "None" then
		self.LSM:Register("background", aName .. " User Background", self.prdb.BgFile)
	end
	if self.prdb.TabDDFile and self.prdb.TabDDFile ~= "None" then
		self.LSM:Register("background", aName .. " User TabDDTexture", self.prdb.TabDDFile)
	end

	-- Heading, Body & Ignored Text colours
	local c = self.prdb.HeadText
	self.HTr, self.HTg, self.HTb = c.r, c.g, c.b
	c = self.prdb.BodyText
	self.BTr, self.BTg, self.BTb = c.r, c.g, c.b
	c = self.prdb.IgnoredText
	self.ITr, self.ITg, self.ITb = c.r, c.g, c.b

	-- Frame multipliers (still used in older skins)
	self.FxMult, self.FyMult = 0.9, 0.87
	-- EditBox regions to keep
	self.ebRgns = {1, 2} -- 1 is text, 2 is a texture

	-- Gradient settings
	self.gradientTab = {self.prdb.Gradient.rotate and "HORIZONTAL" or "VERTICAL", .5, .5, .5, 1, .25, .25, .25, 0}
	self.gradientCBar = {self.prdb.Gradient.rotate and "HORIZONTAL" or "VERTICAL", .25, .25, .55, 1, 0, 0, 0, 1}
	self.gradientTex = self.LSM:Fetch("background", self.prdb.Gradient.texture)

	-- backdrop for Frames etc
	self.bdTexName = dflts.BdTexture
	self.bdbTexName = dflts.BdBorderTexture
	if self.prdb.BdDefault then
		self.backdrop = {
			bgFile = self.LSM:Fetch("background", self.bdTexName),
			tile = dflts.BdTileSize > 0 and true or false, tileSize = dflts.BdTileSize,
			edgeFile = self.LSM:Fetch("border", self.bdbTexName),
			edgeSize = dflts.BdEdgeSize,
			insets = {left = dflts.BdInset, right = dflts.BdInset, top = dflts.BdInset, bottom = dflts.BdInset},
		}
	else
		if self.prdb.BdFile and self.prdb.BdFile ~= "None" then
			self.bdTexName = aName .. " User Backdrop"
		else
			self.bdTexName = self.prdb.BdTexture
		end
		if self.prdb.BdEdgeFile and self.prdb.BdEdgeFile ~= "None" then
			self.bdbTexName = aName .. " User Border"
		else
			self.bdbTexName = self.prdb.BdBorderTexture
		end
		self.backdrop = {
			bgFile = self.LSM:Fetch("background", self.bdTexName),
			tile = self.prdb.BdTileSize > 0 and true or false, tileSize = self.prdb.BdTileSize,
			edgeFile = self.LSM:Fetch("border", self.bdbTexName),
			edgeSize = self.prdb.BdEdgeSize,
			insets = {left = self.prdb.BdInset, right = self.prdb.BdInset, top = self.prdb.BdInset, bottom = self.prdb.BdInset},
		}
	end

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
		if self.prdb.BgFile and self.prdb.BgFile ~= "None" then
			self.bgTexName = aName .. " User Background"
		else
			self.bgTexName = self.prdb.BgTexture
		end
	end

	-- these are used to disable the gradient
	self.gradFrames = {["p"] = {}, ["u"] = {}, ["n"] = {}, ["s"] = {}, a = {}}

	-- TooltipBorder colours
	c = self.prdb.ClassColour and _G.RAID_CLASS_COLORS[self.uCls] or self.prdb.TooltipBorder
	self.tbColour = {c.r, c.g, c.b, c.a or 1}
	-- StatusBar colours
	c = self.prdb.StatusBar
	self.sbColour = {c.r, c.g, c.b, c.a}
	-- StatusBar texture
	self.sbTexture = self.LSM:Fetch("statusbar", c.texture)
	-- Backdrop colours
	c = self.prdb.ClassClrsBg and _G.RAID_CLASS_COLORS[self.uCls] or self.prdb.Backdrop
	self.bColour = {c.r, c.g, c.b, c.a or 1}
	-- BackdropBorder colours
	c = self.prdb.ClassColour and _G.RAID_CLASS_COLORS[self.uCls] or self.prdb.BackdropBorder
	self.bbColour = {c.r, c.g, c.b, c.a or 1}
	-- Inactive Tab & DropDowns texture
	if self.prdb.TabDDFile and self.prdb.TabDDFile ~= "None" then
		self.itTex = self.LSM:Fetch("background", aName .. " User TabDDTexture")
	else
		self.itTex = self.LSM:Fetch("background", self.prdb.TabDDTexture)
	end
	-- Empty Slot texture
	self.esTex = [[Interface\Buttons\UI-Quickslot2]]

	-- class table
	self.classTable = {"DeathKnight", "DemonHunter", "Druid", "Hunter", "Mage", "Monk", "Paladin", "Priest", "Rogue", "Shaman", "Warlock", "Warrior"}

	-- store Addons managed by LoadManagers
	self.lmAddons = {}

	-- table to hold which functions have been actioned
	self.initialized = {}

	-- shorthand for the TexturedTab profile setting
	self.isTT = self.prdb.TexturedTab and true or false

	-- table to hold minimap buttons from other AddOn skins
	self.mmButs = {}

	dflts, c = nil, nil

end

function aObj:OnEnable()

--@debug@
	self:SetupCmds()
--@end-debug@

	-- handle InCombat issues
	self.oocTab = {}
	self:RegisterEvent("PLAYER_REGEN_ENABLED", function()
		for i = 1, #self.oocTab do
			self.oocTab[i][1](unpack(self.oocTab[i][2]))
		end
		_G.wipe(self.oocTab)
	end)

	-- change option name
	if self.prdb.ClassColours then
		self.prdb.ClassColour = self.prdb.ClassColours
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
				if itemIDOrLink
				and _G.IsArtifactRelicItem(itemIDOrLink)
				then
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
	self.skinStdButton       = self.modBtns and self.modUIBtns.skinStdButton or _G.nop
	self.skinButton       = self.modBtns and self.modUIBtns.skinButton or _G.nop
	self.isButton         = self.modBtns and self.modUIBtns.isButton or _G.nop
	self.skinAllButtons   = self.modBtns and self.modUIBtns.skinAllButtons or _G.nop
	self.fontSBX          = self.modBtns and self.modUIBtns.fontSBX or _G.nop
	self.fontP            = self.modBtns and self.modUIBtns.fontP or _G.nop
	self.fontS            = self.modBtns and self.modUIBtns.fontS or _G.nop
	self.addButtonBorder  = self.modBtnBs and self.modUIBtns.addButtonBorder or _G.nop
	self.skinCheckButton  = self.modChkBtns and self.modUIBtns.skinCheckButton or _G.nop

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
	assert(opts.obj, "Missing object __aSB\n" .. debugstack(2, 3, 2))
--@end-alpha@

	aObj:Debug2("__addSkinButton: [%s, %s]", opts.obj, opts.obj:GetName())

	-- don't skin it twice
	if opts.obj.sb then return end

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
		aObj:hookScript(opts.hook, "OnShow", function(this) opts.obj.sb:Show() end)
		aObj:hookScript(opts.hook, "OnHide", function(this) opts.obj.sb:Hide() end)
		if opts.obj:IsObjectType("Button") then -- hook Enable/Disable methods
			aObj:secureHook(opts.hook, "Enable", function(this) opts.obj.sb:Enable() end)
			aObj:secureHook(opts.hook, "Disable", function(this) opts.obj.sb:Disable() end)
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
		local regOT
		for _, reg in ipairs{opts.obj:GetRegions()} do
			regOT = reg:GetObjectType()
			if regOT == "Texture" or regOT == "FontString" then
				-- change the DrawLayer to make the Icon show if required
				if aObj:hasAnyTextInName(reg, {"[Ii]con", "[Cc]ount"})
				or aObj:hasTextInTexture(reg, "[Ii]con") then
					if reg:GetDrawLayer() == "BACKGROUND" then reg:SetDrawLayer("ARTWORK") end
				end
			end
		end
		regOT = nil
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

	btn = nil
	return opts.obj.sb

end
function aObj:addSkinButton(...)

	local opts = select(1, ...)

--@alpha@
	assert(opts, "Missing object aSB\n" .. debugstack(2, 3, 2))
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
	for _, suff in pairs{"Header", "_Header", "_HeaderBox", "_FrameHeader", "FrameHeader", "HeaderTexture", "HeaderFrame"} do
		if _G[obj:GetName() .. suff] then
			_G[obj:GetName() .. suff]:Hide()
			_G[obj:GetName() .. suff]:SetPoint("TOP", obj, "TOP", 0, 7)
			break
		end
	end
	if obj.header then
		obj.header:DisableDrawLayer("BACKGROUND")
		obj.header:DisableDrawLayer("BORDER")
		aObj:moveObject{obj=obj.header.text, y=-6}
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
	assert(opts.obj, "Missing object __aSF\n" .. debugstack(2, 3, 2))
	-- CHANGED: show AddOn skins still using skinAllButtons
	if not opts.ft and not opts.nb then
		aObj:CustomPrint(1, 0, 0, "Not using nb=true", opts.obj)
		if not opts.obj:GetName() then _G.print("No Name supplied __aSF\n", debugstack(2, 3, 2)) end
	end
	-- FIXME: use ft="a" when AddOn skin has been changed to manually skin buttons
--@end-alpha@

	aObj:Debug2("__addSkinFrame: [%s, %s]", opts.obj, opts.obj.GetName and opts.obj:GetName() or "<Anon>")

	-- don't skin it twice
	if opts.obj.sf then return end

	-- remove the object's Backdrop if it has one
	if opts.obj.GetBackdrop and opts.obj:GetBackdrop() then opts.obj:SetBackdrop(nil) end

	-- store frame obj, if required
	if opts.ft then aObj:add2Table(aObj.gradFrames[opts.ft], opts.obj) end

	-- make all textures transparent, if required
	if opts.kfs or opts.hat then aObj:keepFontStrings(opts.obj, opts.hat) end

	-- remove all textures, if required
	if opts.rt then
		for _, reg in ipairs{opts.obj:GetRegions()} do
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
	opts.obj.sf = _G.CreateFrame("Frame", nil, opts.obj, opts.sec and "SecureFrameTemplate" or nil)
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

	-- CHANGED: skinAllButtons only used for AddOn skins, until all are converted (use ft="a" when converting)
	if not opts.nb then
		if not opts.ft then
			aObj:skinAllButtons{obj=opts.obj, bgen=opts.bgen, anim=opts.anim, as=opts.bas, ft=opts.ft}
		else
			-- skin the CloseButton if it exists
			local cBtn = opts.obj.CloseButton or opts.obj:GetName() and _G[opts.obj:GetName() .. "CloseButton"]
			if cBtn then
				aObj:skinCloseButton{obj=cBtn}
			end
			cBtn = nil
		end
	end

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

	skinFrame = nil
	return opts.obj.sf

end
function aObj:addSkinFrame(...)

	local opts = select(1, ...)

--@alpha@
	assert(opts, "Missing object aSF\n" .. debugstack(2, 3, 2))
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
	if not self.prdb.Gradient.char then
		for i = 1, #self.gradFrames["p"] do
			if self.gradFrames["p"][i] == obj then return end
		end
	end
	if not self.prdb.Gradient.ui then
		for i = 1, #self.gradFrames["u"] do
			if self.gradFrames["u"][i] == obj then return end
		end
	end
	if not self.prdb.Gradient.npc then
		for i = 1, #self.gradFrames["n"] do
			if self.gradFrames["n"][i] == obj then return end
		end
	end
	if not self.prdb.Gradient.skinner then
		for i = 1, #self.gradFrames["s"] do
			if self.gradFrames["s"][i] == obj then return end
		end
	end

	invert = invert or self.prdb.Gradient.invert
	rotate = rotate or self.prdb.Gradient.rotate

	if not obj.tfade then
		obj.tfade = obj:CreateTexture(nil, "BORDER", nil, -1)
		obj.tfade:SetTexture(self.gradientTex)
		obj.tfade:SetBlendMode("ADD")
		obj.tfade:SetGradientAlpha(self:getGradientInfo(invert, rotate))
	end

	if self.prdb.FadeHeight.enable
	and (self.prdb.FadeHeight.force or not fh)
	and Round(obj:GetHeight()) ~= obj.hgt
	then
		-- set the Fade Height if not already passed to this function or 'forced'
		-- making sure that it isn't greater than the frame height
		obj.hgt = Round(obj:GetHeight())
		fh = self.prdb.FadeHeight.value <= obj.hgt and self.prdb.FadeHeight.value or obj.hgt
	end

	obj.tfade:ClearAllPoints()
	if not invert -- fade from top
	and not rotate
	then
		obj.tfade:SetPoint("TOPLEFT", obj, "TOPLEFT", 4, -4)
		if fh then
			obj.tfade:SetPoint("BOTTOMRIGHT", obj, "TOPRIGHT", -4, -(fh - 4))
		else
			obj.tfade:SetPoint("BOTTOMRIGHT", obj, "BOTTOMRIGHT", -4, 4)
		end
	elseif invert -- fade from bottom
	and not rotate
	then
		obj.tfade:SetPoint("BOTTOMLEFT", obj, "BOTTOMLEFT", 4, 4)
		if fh then
			obj.tfade:SetPoint("TOPRIGHT", obj, "BOTTOMRIGHT", -4, (fh - 4))
		else
			obj.tfade:SetPoint("TOPRIGHT", obj, "TOPRIGHT", -4, -4)
		end
	elseif not invert -- fade from right
	and rotate
	then
		obj.tfade:SetPoint("TOPRIGHT", obj, "TOPRIGHT", -4, -4)
		if fh then
			obj.tfade:SetPoint("BOTTOMLEFT", obj, "BOTTOMRIGHT", -(fh - 4), 4)
		else
			obj.tfade:SetPoint("BOTTOMLEFT", obj, "BOTTOMLEFT", 4, 4)
		end
	elseif invert -- fade from left
	and rotate
	then
		obj.tfade:SetPoint("TOPLEFT", obj, "TOPLEFT", 4, -4)
		if fh then
			obj.tfade:SetPoint("BOTTOMRIGHT", obj, "BOTTOMLEFT", fh - 4, 4)
		else
			obj.tfade:SetPoint("BOTTOMRIGHT", obj, "BOTTOMRIGHT", -4, 4)
		end
	end

end

function aObj:applyTexture(obj)

	obj.tbg = obj:CreateTexture(nil, "BORDER")
	obj.tbg:SetTexture(self.LSM:Fetch("background", self.bgTexName), true) -- have to use true for tiling to work
	obj.tbg:SetBlendMode("ADD") -- use existing frame alpha setting
	-- allow for border inset
	obj.tbg:SetPoint("TOPLEFT", obj, "TOPLEFT", self.prdb.BdInset, -self.prdb.BdInset)
	obj.tbg:SetPoint("BOTTOMRIGHT", obj, "BOTTOMRIGHT", -self.prdb.BdInset, self.prdb.BdInset)
	-- the texture will be stretched if the following tiling methods are set to false
	obj.tbg:SetHorizTile(self.prdb.BgTile)
	obj.tbg:SetVertTile(self.prdb.BgTile)

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
	assert(opts.obj, "Missing object __aS\n" .. debugstack(2, 3, 2))
--@end-alpha@

	aObj:Debug2("__applySkin: [%s, %s]", opts.obj, opts.obj:GetName())

	local hasIOT = assert(opts.obj.IsObjectType, "The Object passed isn't a Frame") -- throw an error here to get its original location reported
	if hasIOT and not opts.obj:IsObjectType("Frame") then
		if aObj.db.profile.Errors then
			aObj:CustomPrint(1, 0, 0, "Error skinning", opts.obj.GetName and opts.obj:GetName() or opts.obj, "not a Frame or subclass of Frame:", opts.obj:GetObjectType())
			return
		end
	end
	hasIOT = nil

	-- don't skin it twice
	if opts.obj.sknd then
		return
	else
		opts.obj.sknd = true
	end

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
	assert(opts, "Missing object aS\n" .. debugstack(2, 3, 2))
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

function aObj:skinColHeads(buttonName, noCols)

	local btn
	noCols = noCols or 4
	for i = 1, noCols do
		btn = _G[buttonName .. i]
		if not btn.sb then -- only do if not already skinned as a button
			self:removeRegions(btn, {1, 2, 3})
			-- CHANGED: ft="a" is used to stop buttons being skinned automatically
			self:addSkinFrame{obj=btn, ft="a"}
		end
	end
	btn = nil

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
	assert(opts.obj, "Missing object __sDD\n" .. debugstack(2, 3, 2))
--@end-alpha@

	aObj:Debug2("__skinDropDown: [%s, %s]", opts.obj, opts.obj:GetName())

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
	opts.obj.ddTex:SetHeight(17)

	local xOfs1 = opts.x1 or 16
	local yOfs1 = opts.y1 or -1
	local xOfs2 = opts.x2 or -16
	local yOfs2 = opts.y2 or 7
	-- skin the frame
	if aObj.db.profile.DropDownButtons then
		-- CHANGED: ft ... or "a" is used to stop buttons being skinned automatically
		aObj:addSkinFrame{obj=opts.obj, ft=opts.ftype or "a", aso={ng=true, bd=5}, rp=opts.rp, x1=xOfs1, y1=yOfs1, x2=xOfs2, y2=yOfs2}
	end
	-- add a button border around the dd button
	if not opts.noBB then
		aObj:addButtonBorder{obj=opts.obj.Button or _G[opts.obj:GetName() .. "Button"], es=12, ofs=-2, x1=1}
	end

	xOfs1, yOfs1, xOfs2, yOfs2 = nil, nil, nil, nil

end
function aObj:skinDropDown(...)

	local opts = select(1, ...)

--@alpha@
	assert(opts, "Missing object sDD\n" .. debugstack(2, 3, 2))
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
	assert(opts.obj, "Missing object __sEB\n" .. debugstack(2, 3, 2))
	assert(opts.obj:IsObjectType("EditBox"), "Not an EditBox\n" .. debugstack(2, 3, 2))
--@end-alpha@

	aObj:Debug2("__skinEditBox: [%s, %s]", opts.obj, opts.obj:GetName())

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
		for i = 1, #opts.regs do
			aObj:add2Table(kRegions, opts.regs[i])
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
	if opts.mi then
		if opts.obj.searchIcon then
			aObj:moveObject{obj=opts.obj.searchIcon, x=4} -- e.g. BagItemSearchBox
		elseif opts.obj.Instructions then -- e.g. InputBoxInstructionsTemplate (WoD)
			opts.obj.Instructions:ClearAllPoints()
			opts.obj.Instructions:SetPoint("Left", opts.obj, "Left", 6, 0)
		elseif opts.obj.icon then
			aObj:moveObject{obj=opts.obj.icon, x=4} -- e.g. FriendsFrameBroadcastInput
		elseif _G[opts.obj:GetName() .. "SearchIcon"] then
			aObj:moveObject{obj=_G[opts.obj:GetName() .. "SearchIcon"], x=4} -- e.g. TradeSkillFrameSearchBox
		else -- e.g. WeakAurasFilterInput
			for _, reg in ipairs{opts.obj:GetRegions()} do
				if aObj:hasTextInTexture(reg, "UI-Searchbox-Icon") then
					aObj:moveObject{obj=reg, x=4}
				end
			end
		end
	end

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
	assert(opts, "Missing object sEB\n" .. debugstack(2, 3, 2))
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
	assert(opts.obj, "Missing object __sMF\n" .. debugstack(2, 3, 2))
--@end-alpha@

	aObj:Debug2("__skinMoneyFrame: [%s, %s]", opts.obj, opts.obj:GetName())

	-- don't skin it twice
	if opts.obj.sknd then
		return
	else
		opts.obj.sknd = true
	end

	local obj
	for _, type in pairs{"Gold", "Silver", "Copper"} do
		obj = _G[opts.obj:GetName() .. type]
		aObj:skinEditBox{obj=obj, regs={6, 7}, noHeight=true, noWidth=true, ign=true} -- N.B. region 6 is the icon, 7 is text
		-- move label to the right for colourblind mode
		if i ~= 1 or opts.moveGIcon then
			aObj:moveObject{obj=obj.texture, x=10}
			aObj:moveObject{obj=obj.label, x=10}
		end
		if not opts.noWidth and i ~= 1 then
			aObj:adjWidth{obj=obj, adj=5}
		end
		if type == "Gold" and opts.moveGEB then
			aObj:moveObject{obj=obj, x=-8}
		end
		if type == "Silver" and opts.moveSEB then
			aObj:moveObject{obj=obj, x=-10}
		end
	end
	obj = nil

end
function aObj:skinMoneyFrame(...)

	local opts = select(1, ...)

--@alpha@
	assert(opts, "Missing object sMF\n" .. debugstack(2, 3, 2))
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
	assert(opts.obj, "Missing object __sSB\n" .. debugstack(2, 3, 2))
	assert(opts.obj:IsObjectType("Frame"), "Not a ScrollFrame\n" .. debugstack(2, 3, 2))
	assert(_G[opts.obj:GetName() .. "ScrollBar"]:IsObjectType("Slider"), "Not a Slider\n" .. debugstack(2, 3, 2))
	-- handle AddOn skins still using this code rather than skinSlider
	aObj:CustomPrint(1, 0, 0, "Using deprecated function - skinScrollBar, use skinSlider instead", opts.obj)
--@end-alpha@

	aObj:Debug2("__skinScrollBar: [%s, %s]", opts.obj, opts.obj:GetName())

	-- don't skin it twice
	if opts.obj.sknd then
		return
	else
		opts.obj.sknd = true
	end

	-- remove all the object's regions except text ones, if required
	if not opts.noRR then aObj:keepFontStrings(opts.obj) end

	-- skin it
	aObj:skinUsingBD{obj=_G[opts.obj:GetName() .. "ScrollBar"], size=opts.size}

end
function aObj:skinScrollBar(...)

	local opts = select(1, ...)

--@alpha@
	assert(opts, "Missing object sSB\n" .. debugstack(2, 3, 2))
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
	assert(opts.obj, "Missing object __sS\n" .. debugstack(2, 3, 2))
	assert(opts.obj:IsObjectType("Slider"), "Not a Slider\n" .. debugstack(2, 3, 2))
--@end-alpha@

	aObj:Debug2("__skinSlider: [%s, %s]", opts.obj, opts.obj:GetName())

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
			for i = 1, #opts.rt do
				opts.obj:GetParent():DisableDrawLayer(opts.rt[i])
			end
		else
			opts.obj:GetParent():DisableDrawLayer(opts.rt)
		end
	end

end
function aObj:skinSlider(...)

	local opts = select(1, ...)

--@alpha@
	assert(opts, "Missing object sS\n" .. debugstack(2, 3, 2))
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

-- table to hold StatusBars that have been glazed, with weak keys
aObj.sbGlazed = _G.setmetatable({}, {__mode = "k"})
local function __skinStatusBar(opts)
--[[
	Calling parameters:
		obj = object (Mandatory)
		fi = frame inset
		bgTex = existing background texture
		otherTex = other Textures table
		hookFunc = hook the change texture function
--]]
--@alpha@
	assert(opts.obj, "Missing object __sSB\n" .. debugstack(2, 3, 2))
	assert(opts.obj:IsObjectType("StatusBar"), "Not a StatusBar\n" .. debugstack(2, 3, 2))
--@end-alpha@

	aObj:Debug2("__skinStatusBar: [%s, %s]", opts.obj, opts.obj:GetName())

	opts.obj:SetStatusBarTexture(aObj.sbTexture)

	-- don't skin it twice
	if not aObj.sbGlazed[opts.obj] then
		aObj.sbGlazed[opts.obj] = {}
	else
		return
	end
	local sbG = aObj.sbGlazed[opts.obj]

	if opts.fi then
		if not sbG.bg then
			-- create background texture on a lower sublevel
			sbG.bg = opts.bgTex or opts.obj:CreateTexture(nil, "BACKGROUND", nil, -1)
			sbG.bg:SetTexture(aObj.sbTexture)
			sbG.bg:SetVertexColor(aObj.sbColour[1], aObj.sbColour[2], aObj.sbColour[3])
			if not opts.bgTex then
				sbG.bg:SetPoint("TOPLEFT", opts.obj, "TOPLEFT", opts.fi, -opts.fi)
				sbG.bg:SetPoint("BOTTOMRIGHT", opts.obj, "BOTTOMRIGHT", -opts.fi, opts.fi)
			end
		end
	end
	-- apply texture to and store other texture objects
	if opts.otherTex
	and type(opts.otherTex) == "table"
	then
		local tex
		for i = 1, #opts.otherTex do
			tex = opts.otherTex[i]
			tex:SetTexture(aObj.sbTexture)
			tex:SetVertexColor(aObj.sbColour[1], aObj.sbColour[2], aObj.sbColour[3])
			sbG[#sbG + 1] = tex
		end
		tex = nil
	end
	if opts.hookFunc then
		aObj:RawHook(opts.obj, "SetStatusBarTexture", function(this, tex)
			if not tex == aObj.sbTexture then
				aObj.hooks[this].SetStatusBarTexture(this, aObj.sbTexture)
			end
		end, true)
	end

	sBG = nil

end
function aObj:skinStatusBar(...)

	local opts = select(1, ...)

--@alpha@
	assert(opts, "Missing object gSB\n" .. debugstack(2, 3, 2))
--@end-alpha@

	-- handle missing object (usually when addon changes)
	if not opts then return end

	if type(rawget(opts, 0)) == "userdata" and type(opts.GetObjectType) == "function" then
	--@alpha@
		-- handle AddOn skins still using this code rather than skinSlider
		aObj:CustomPrint(1, 0, 0, "Using old style call - skinStatusBar", select(1, ...), debugstack(2, 3, 2))
	--@end-alpha@
		-- old style call
		opts = {}
		opts.obj = select(1, ...) and select(1, ...) or nil
		opts.fi = select(2, ...) and select(2, ...) or nil
		opts.bgTex = select(3, ...) and select(3, ...) or nil
		opts.otherTex = select(4, ...) and select(4, ...) or nil
		opts.hookFunc = select(5, ...) and select(5, ...) or nil
	end

	__skinStatusBar(opts)
	opts = nil

end
-- previous name for the above function (statusBar, fi, bgTex, otherTex, hookFunc)
function aObj:glazeStatusBar(...)
--@alpha@
	-- handle AddOn skins still using this code rather than skinStatusBar
	aObj:CustomPrint(1, 0, 0, "Using deprecated function - glazeStatusBar, use skinStatusBar instead", select(1, ...),  debugstack(2, 3, 2))
--@end-alpha@

	self:skinStatusBar(...)

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
		nc = don't check to see if already skinned
--]]
--@alpha@
	assert(opts.obj, "Missing object __sT\n" .. debugstack(2, 3, 2))
	assert(opts.obj:IsObjectType("Frame"), "Not a Frame\n" .. debugstack(2, 3, 2))
--@end-alpha@

	aObj:Debug2("__skinTabs: [%s, %s]", opts.obj, opts.obj:GetName())

	-- don't skin it twice unless required (Ace3)
	if not opts.nc
	and opts.obj.sknd
	then
		return
	else
		opts.obj.sknd = true
	end

	-- use supplied name or existing name (Ace3 TabGroup fix)
	local tabName = opts.name or opts.obj:GetName()
	tabName =  tabName .. "Tab" .. (opts.suffix or "")

	local kRegions = {7, 8} -- N.B. region 7 is text, 8 is highlight for some tabs
	if opts.regs then
		for i = 1, #opts.regs do
			aObj:add2Table(kRegions, opts.regs[i])
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
		-- CHANGED: ft ... or "a" is used to stop buttons being skinned automatically
		aObj:addSkinFrame{obj=tab, ft=opts.ftype or "a", noBdr=aObj.isTT, bg=opts.bg or false, x1=xOfs1, y1=yOfs1, x2=xOfs2, y2=yOfs2}
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
	assert(opts, "Missing object sT\n" .. debugstack(2, 3, 2))
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
			-- CHANGED: ft="a" is used to stop buttons being skinned automatically
			self:addSkinFrame{obj=togTab, ft="a", y1=-2, x2=2, y2=-2}
		end
	end
	togTab = nil

end

function aObj:skinTooltip(tooltip)
	if not self.prdb.Tooltips.skin then return end
--@alpha@
	assert(tooltip, "Missing object sT\n" .. debugstack(2, 3, 2))
--@end-alpha@

	-- aObj:Debug2("skinTooltip: [%s, %s, %s]", tooltip, tooltip:GetName(), tooltip.sf)

	if not tooltip then return end

	if not tooltip.sf then
		-- Bugfix for ElvUI
		local ttSB
		if _G.IsAddOnLoaded("ElvUI") then
			ttSB = tooltip.SetBackdrop
			tooltip.SetBackdrop = _G.nop
		end
		self:addSkinFrame{obj=tooltip, ft="a", kfs=true, aso={ng=true}}
		if _G.IsAddOnLoaded("ElvUI") then
			tooltip.SetBackdrop = ttSB
		end
		ttSB = nil
	end

	if self.prdb.Tooltips.style == 1 then -- Rounded
		self:applyGradient(tooltip.sf, 32)
	elseif self.prdb.Tooltips.style == 2 then -- Flat
		self:applyGradient(tooltip.sf)
	elseif self.prdb.Tooltips.style == 3 then -- Custom
		self:applyGradient(tooltip.sf, self.prdb.FadeHeight.value <= Round(tooltip:GetHeight()) and self.prdb.FadeHeight.value or Round(tooltip:GetHeight()))
	end

end

local function __skinUsingBD(opts)
--[[
	Calling parameters:
		obj = object (Mandatory)
		size = backdrop size to use (2 - wide, 3 - medium, 4 - narrow)
--]]
--@alpha@
	assert(opts.obj, "Missing object __sUBD\n" .. debugstack(2, 3, 2))
--@end-alpha@

	opts.size = opts.size or 3 -- default to medium

	opts.obj:SetBackdrop(aObj.Backdrop[opts.size])
	opts.obj:SetBackdropBorderColor(.2, .2, .2, 1)
	opts.obj:SetBackdropColor(.1, .1, .1, 1)

end
function aObj:skinUsingBD(...)

	local opts = select(1, ...)

--@alpha@
	assert(opts, "Missing object sUBD\n" .. debugstack(2, 3, 2))
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
