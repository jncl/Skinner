local aName, aObj = ...
local _G = _G
local ftype = "u"
local obj, objName, tex, texName, btn, btnName, tab, tabSF, asopts

do
	-- list of Tooltips to check to see whether we should colour the Tooltip Border or not
	-- use strings as the objects may not exist when we start
	aObj.ttCheck = {"GameTooltip", "ShoppingTooltip1", "ShoppingTooltip2", "ShoppingTooltip3", "ItemRefTooltip", "ItemRefShoppingTooltip1", "ItemRefShoppingTooltip2", "ItemRefShoppingTooltip3"}
	-- list of Tooltips used when the Tooltip style is 3
	-- using a metatable to manage tooltips when they are added in different functions
	aObj.ttList = setmetatable({}, {__newindex = function(t, k, v)
	--	  aObj:Debug("ttList newindex: [%s, %s, %s]", t, k, v)
		rawset(t, k, v)
		-- set the backdrop if required
		if aObj.db.profile.Tooltips.style == 3 then
			_G[v]:SetBackdrop(aObj.Backdrop[1])
		end
		-- hook the OnShow method
		aObj:HookScript(_G[v], "OnShow", function(this)
			aObj:skinTooltip(this)
			if this == GameTooltip and aObj.db.profile.Tooltips.glazesb then
				aObj:glazeStatusBar(GameTooltipStatusBar, 0)
			end
		end)
		aObj:skinTooltip(_G[v]) -- skin here so tooltip initially skinnned when logged on
	end})
	-- Set the Tooltip Border
	aObj.ttBorder = true
end

function aObj:Tooltips()
	if not self.db.profile.Tooltips.skin or self.initialized.Tooltips then return end
	self.initialized.Tooltips = true

	self:add2Table(self.uiKeys2, "Tooltips")

	if not self.isCata then
		--	change the default Tooltip Border colour here
		local r, g, b, a = self:setTTBBC()
		TOOLTIP_DEFAULT_COLOR = {r=r, g=g, b=b}
	end

	if not self.isCata then
		-- fix for TinyTip tooltip becoming 'fractured'
		if self.db.profile.Tooltips.style == 3 then
			local c = self.db.profile.Backdrop
			TOOLTIP_DEFAULT_BACKGROUND_COLOR = {r = c.r, g = c.g, b = c.b}
			-- self:setTTBackdrop(true)
		end
	end
	-- skin Item Ref Tooltip's close button
	self:skinButton{obj=ItemRefCloseButton, cb=true}

	local counts = 0
	local GTSBevt
	local function checkGTHeight(cHeight)

		counts = counts + 1

		if cHeight ~= ceil(GameTooltip:GetHeight()) then
			aObj:skinTooltip(GameTooltip)
			aObj:CancelTimer(GTSBevt, true)
			GTSBevt = nil
			counts = 0
		end

		if counts == 10 or GameTooltipStatusBar:IsShown() then
			aObj:CancelTimer(GTSBevt, true)
			GTSBevt = nil
			counts = 0
		end

	end

	-- Hook this to deal with GameTooltip FadeHeight issues
	self:HookScript(GameTooltipStatusBar, "OnHide", function(this)
		if GameTooltip:IsShown() then
			if not GTSBevt then
				GTSBevt = self:ScheduleRepeatingTimer(checkGTHeight, 0.1, ceil(GameTooltip:GetHeight()))
			end
		end
	end)

	-- add tooltips to table to set backdrop and hook OnShow method
	for _, tooltip in pairs(self.ttCheck) do
		self:add2Table(self.ttList, tooltip)
	end
	self:add2Table(self.ttList, "SmallTextTooltip")

	-- Hook this to skin the GameTooltip StatusBars
	self:SecureHook("GameTooltip_ShowStatusBar", function(this, ...)
		if GameTooltipStatusBar1 then
			self:removeRegions(GameTooltipStatusBar1, {2})
			if aObj.db.profile.Tooltips.glazesb then
				self:glazeStatusBar(GameTooltipStatusBar1, 0)
			end
		end
		if GameTooltipStatusBar2 then
			self:removeRegions(GameTooltipStatusBar2, {2})
			if aObj.db.profile.Tooltips.glazesb then
				self:glazeStatusBar(GameTooltipStatusBar2, 0)
			end
			self:Unhook("GameTooltip_ShowStatusBar")
		end
	end)

end

function aObj:MirrorTimers()
	if not self.db.profile.MirrorTimers.skin or self.initialized.MirrorTimers then return end
	self.initialized.MirrorTimers = true

	self:add2Table(self.uiKeys2, "MirrorTimers")

	local objBG, objSB
	for i = 1, MIRRORTIMER_NUMTIMERS do
		objName = "MirrorTimer"..i
		obj = _G[objName]
		objBG = self:getRegion(obj, 1)
		objSB = _G[objName.."StatusBar"]
		self:removeRegions(obj, {3})
		obj:SetHeight(obj:GetHeight() * 1.25)
		self:moveObject{obj=_G[objName.."Text"], y=-2}
		objBG:SetWidth(objBG:GetWidth() * 0.75)
		objSB:SetWidth(objSB:GetWidth() * 0.75)
		if self.db.profile.MirrorTimers.glaze then
			self:glazeStatusBar(objSB, 0, objBG)
		end
	end

end

function aObj:CastingBar()
	if not self.db.profile.CastingBar.skin or self.initialized.CastingBar then return end
	self.initialized.CastingBar = true

	self:add2Table(self.uiKeys2, "CastingBar")

	local modUF = self:GetModule("UnitFrames", true):IsEnabled() and self:GetModule("UnitFrames", true)
	-- hook this to move the spark down on the casting bar
	self:SecureHook("CastingBarFrame_OnUpdate", function(this, ...)
		local obj = _G[this:GetName().."Spark"]
		local yOfs = -3
		if this == CastingBarFrame then
		elseif this == TargetFrameSpellBar
		and modUF
		and modUF.db.profile.target
		then
		elseif this == FocusFrameSpellBar
		and modUF
		and modUF.db.profile.focus
		then
		else yOfs = 0
		end
		self:moveObject{obj=obj, y=yOfs}
	end)

	for _, prefix in pairs{"", "Pet"} do

		objName = prefix.."CastingBarFrame"
		_G[objName.."Border"]:SetAlpha(0)
		self:changeShield(_G[objName.."BorderShield"], _G[objName.."Icon"])
		_G[objName.."Flash"]:SetAllPoints()
		self:moveObject{obj=_G[objName.."Text"], y=-3}
		if self.db.profile.CastingBar.glaze then
			self:glazeStatusBar(_G[objName], 0, self:getRegion(_G[objName], 1), {_G[objName.."Flash"]})
		end

	end

end

function aObj:StaticPopups()
	if not self.db.profile.StaticPopups or self.initialized.StaticPopups then return end
	self.initialized.StaticPopups = true

	self:add2Table(self.uiKeys1, "StaticPopups")

	if self.modBtns then
		-- hook this to handle close button texture changes
		self:SecureHook("StaticPopup_Show", function(...)
			local obj, tex
			for i = 1, STATICPOPUP_NUMDIALOGS do
				obj = _G["StaticPopup"..i.."CloseButton"]
				tex = obj:GetNormalTexture() and obj:GetNormalTexture():GetTexture() or nil
				if tex then
					if tex:find("HideButton") then
						obj:SetText(self.modUIBtns.minus)
					elseif tex:find("MinimizeButton") then
						obj:SetText(self.modUIBtns.mult)
					end
				end
			end
		end)
	end

	for i = 1, STATICPOPUP_NUMDIALOGS do
		objName = "StaticPopup"..i
		obj = _G[objName]
		self:skinEditBox{obj=_G[objName.."EditBox"]}
		self:skinMoneyFrame{obj=_G[objName.."MoneyInputFrame"]}
		_G[objName.."ItemFrameNameFrame"]:SetTexture(nil)
		self:addButtonBorder{obj=_G[objName.."ItemFrame"], ibt=true}
		self:addSkinFrame{obj=obj, ft=ftype, x1=6, y1=-6, x2=-6, y2=6}
		-- prevent FrameLevel from being changed (LibRock does this)
		self.skinFrame[obj].SetFrameLevel = function() end
	end

end

function aObj:ChatMenus()
	if not self.db.profile.ChatMenus or self.initialized.ChatMenus then return end
	self.initialized.ChatMenus = true

	self:add2Table(self.uiKeys1, "ChatMenus")

	self:addSkinFrame{obj=ChatMenu, ft=ftype}
	self:addSkinFrame{obj=EmoteMenu, ft=ftype}
	self:addSkinFrame{obj=LanguageMenu, ft=ftype}
	self:addSkinFrame{obj=VoiceMacroMenu, ft=ftype}
	self:addSkinFrame{obj=GeneralDockManagerOverflowButtonList, ft=ftype}

end

function aObj:ChatTabs()
	if not self.db.profile.ChatTabs or self.initialized.ChatTabs then return end
	self.initialized.ChatTabs = true

	self:add2Table(self.uiKeys1, "ChatTabs")

	-- hook this to handle Tab alpha changes as they have been reparented
	self:SecureHook("FCFTab_UpdateAlpha", function(this)
--		print("FCFTab_UpdateAlpha", this, this:GetName())
		local tab = _G[this:GetName().."Tab"]
		local tabSF = self.skinFrame[tab]
		tabSF:SetAlpha(tab:GetAlpha())
	end)

	for i = 1, NUM_CHAT_WINDOWS do
		tab = _G["ChatFrame"..i.."Tab"]
		self:keepRegions(tab, {7, 8, 9, 10, 11}) --N.B. region 7 is glow, 8-10 are highlight, 11 is text
		tabSF = self:addSkinFrame{obj=tab, ft=ftype, noBdr=self.isTT, y1=-8, y2=-5}
		-- hook this to fix tab gradient texture overlaying text & highlight
		self:SecureHook(tab, "SetParent", function(this, parent)
			local tabSF = self.skinFrame[this]
			if parent == GeneralDockManager.scrollFrame.child then
				tabSF:SetParent(GeneralDockManager)
			else
				tabSF:SetParent(this)
				tabSF:SetFrameLevel(1) -- reset frame level so that the texture is behind text etc
			end
		end)
	end

end

function aObj:ChatFrames()
	if not self.db.profile.ChatFrames or self.initialized.ChatFrames then return end
	self.initialized.ChatFrames = true

	self:add2Table(self.uiKeys1, "ChatFrames")

	local clqbf = "CombatLogQuickButtonFrame"
	local clqbf_c = clqbf.."_Custom"
	local yOfs1 = 4
	for i = 1, NUM_CHAT_WINDOWS do
		obj = _G["ChatFrame"..i]
		if obj == COMBATLOG
		and _G[clqbf_c]:IsShown()
		then
			yOfs1 = 31
		else
			yOfs1 = 4
		end
		self:addSkinFrame{obj=obj, ft=ftype, x1=-4, y1=yOfs1, x2=4, y2=-8}
	end

	-- CombatLog Quick Button Frame & Progress Bar
	if self.db.profile.CombatLogQBF then
		if _G[clqbf_c] then
			self:keepFontStrings(_G[clqbf_c])
			self:addSkinFrame{obj=_G[clqbf_c], ft=ftype, x1=-4, x2=4}
			self:adjHeight{obj=_G[clqbf_c], adj=4}
			self:glazeStatusBar(_G[clqbf_c.."ProgressBar"], 0, _G[clqbf_c.."Texture"])
		else
			self:glazeStatusBar(_G[clqbf.."ProgressBar"], 0, _G[clqbf.."Texture"])
		end
	end

	-- minimized chat frames
	self:SecureHook("FCF_CreateMinimizedFrame", function(chatFrame)
		local obj = _G[chatFrame:GetName().."Minimized"]
		self:removeRegions(obj, {1, 2, 3})
		self:addSkinFrame{obj=obj, ft=ftype, x1=1, y1=-2, x2=-1, y2=2}
	end)

end

function aObj:ChatConfig()
	if not self.db.profile.ChatConfig or self.initialized.ChatConfig then return end
	self.initialized.ChatConfig = true

	self:add2Table(self.uiKeys1, "ChatConfig")

	self:addSkinFrame{obj=ChatConfigFrame, ft=ftype, kfs=true, hdr=true}
	self:addSkinFrame{obj=ChatConfigCategoryFrame, ft=ftype}
	self:addSkinFrame{obj=ChatConfigBackgroundFrame, ft=ftype}

-->>--	Chat Settings
	for i = 1, #CHAT_CONFIG_CHAT_LEFT do
		_G["ChatConfigChatSettingsLeftCheckBox"..i]:SetBackdrop(nil)
	end
	self:addSkinFrame{obj=ChatConfigChatSettingsLeft, ft=ftype}

	self:addSkinFrame{obj=ChatConfigChatSettingsClassColorLegend, ft=ftype}

-->>--	Channel Settings
	self:SecureHook(ChatConfigChannelSettings, "Show", function(this, ...)
		for i = 1, #ChatConfigChannelSettingsLeft.checkBoxTable do
			_G["ChatConfigChannelSettingsLeftCheckBox"..i]:SetBackdrop(nil)
		end
	end)
	self:addSkinFrame{obj=ChatConfigChannelSettingsLeft, ft=ftype}
	self:addSkinFrame{obj=ChatConfigChannelSettingsClassColorLegend, ft=ftype}

-->>--	Other Settings
	for i = 1, #CHAT_CONFIG_OTHER_COMBAT do
		_G["ChatConfigOtherSettingsCombatCheckBox"..i]:SetBackdrop(nil)
	end
	self:addSkinFrame{obj=ChatConfigOtherSettingsCombat, ft=ftype}

	for i = 1, #CHAT_CONFIG_OTHER_PVP do
		_G["ChatConfigOtherSettingsPVPCheckBox"..i]:SetBackdrop(nil)
	end
	self:addSkinFrame{obj=ChatConfigOtherSettingsPVP, ft=ftype}

	for i = 1, #CHAT_CONFIG_OTHER_SYSTEM do
		_G["ChatConfigOtherSettingsSystemCheckBox"..i]:SetBackdrop(nil)
	end
	self:addSkinFrame{obj=ChatConfigOtherSettingsSystem, ft=ftype}

	for i = 1, #CHAT_CONFIG_CHAT_CREATURE_LEFT do
		_G["ChatConfigOtherSettingsCreatureCheckBox"..i]:SetBackdrop(nil)
	end
	self:addSkinFrame{obj=ChatConfigOtherSettingsCreature, ft=ftype}

-->>--	Combat Settings
	-- Filters
	ChatConfigCombatSettingsFiltersScrollFrameScrollBarBorder:Hide()
	self:skinScrollBar{obj=ChatConfigCombatSettingsFiltersScrollFrame} --, noRR=true}
	self:addSkinFrame{obj=ChatConfigCombatSettingsFilters, ft=ftype}

	-- Message Sources
	if COMBAT_CONFIG_MESSAGESOURCES_BY then
		for i = 1, #COMBAT_CONFIG_MESSAGESOURCES_BY do
			_G["CombatConfigMessageSourcesDoneByCheckBox"..i]:SetBackdrop(nil)
		end
		self:addSkinFrame{obj=CombatConfigMessageSourcesDoneBy, ft=ftype}
	end
	if COMBAT_CONFIG_MESSAGESOURCES_TO then
		for i = 1, #COMBAT_CONFIG_MESSAGESOURCES_TO do
			_G["CombatConfigMessageSourcesDoneToCheckBox"..i]:SetBackdrop(nil)
		end
		self:addSkinFrame{obj=CombatConfigMessageSourcesDoneTo, ft=ftype}
	end

	-- Colors
	for i = 1, #COMBAT_CONFIG_UNIT_COLORS do
		_G["CombatConfigColorsUnitColorsSwatch"..i]:SetBackdrop(nil)
	end
	self:addSkinFrame{obj=CombatConfigColorsUnitColors, ft=ftype}

	local clrize
	for i, v in ipairs{"Highlighting", "UnitName", "SpellNames", "DamageNumber", "DamageSchool", "EntireLine"} do
		clrize = i > 1 and "Colorize" or ""
		obj = _G["CombatConfigColors"..clrize..v]
		self:addSkinFrame{obj=obj, ft=ftype}
	end

	-- Settings
	self:skinEditBox{obj=CombatConfigSettingsNameEditBox , regs={9}}

	-- Tabs
	for i = 1, #COMBAT_CONFIG_TABS do
		obj = _G["CombatConfigTab"..i]
		self:keepRegions(obj, {4, 5}) -- N.B. region 4 is the Text, 5 is the highlight
		self:addSkinFrame{obj=obj, ft=ftype, y1=-8, y2=-4}
	end

end

function aObj:ChatEditBox()
	-- don't use an initialized value to allow for dynamic changes
	if not self.db.profile.ChatEditBox.skin then return end

	self:add2Table(self.uiKeys2, "ChatEditBox")

	-- these addons replace the Chat Edit Box
	if IsAddOnLoaded("NeonChat") or IsAddOnLoaded("Chatter") or IsAddOnLoaded("Prat-3.0") then return end

	for i = 1, NUM_CHAT_WINDOWS do
		obj = _G["ChatFrame"..i.."EditBox"]
		if self.db.profile.ChatEditBox.style == 1 then -- Frame
			local kRegions = CopyTable(self.ebRegions)
			table.insert(kRegions, 12)
			self:keepRegions(obj, kRegions)
			self:addSkinFrame{obj=obj, ft=ftype, x1=2, y1=-2, x2=-2}
		elseif self.db.profile.ChatEditBox.style == 2 then -- Editbox
			self:skinEditBox{obj=obj, regs={12}, noHeight=true}
		else -- Borderless
			self:removeRegions(obj, {6, 7, 8})
			self:addSkinFrame{obj=obj, ft=ftype, noBdr=true, x1=5, y1=-4, x2=-5, y2=2}
		end
	end

end

function aObj:LootFrame()
	if not self.db.profile.LootFrame or self.initialized.LootFrame then return end
	self.initialized.LootFrame = true

	self:add2Table(self.uiKeys1, "LootFrame")

	-- shrink the size of the LootFrame
	-- move the title and close button and reduce the height of the skinFrame by 34
	self:moveObject{obj=self:getRegion(LootFrame, 3), x=-12, y=-34} -- title
	self:moveObject{obj=LootCloseButton, y=-34}
	for i = 1, LOOTFRAME_NUMBUTTONS do
		_G["LootButton"..i.."NameFrame"]:SetTexture(nil)
		self:addButtonBorder{obj=_G["LootButton"..i], ibt=true}
	end
	self:addSkinFrame{obj=LootFrame, ft=ftype, kfs=true, x1=8, y1=-47, x2=-68}

end

function aObj:GroupLoot()
	if not self.db.profile.GroupLoot.skin or self.initialized.GroupLoot then return end
	self.initialized.GroupLoot = true

	self:add2Table(self.uiKeys2, "GroupLoot")

	self:skinDropDown{obj=GroupLootDropDown}

	for i = 1, NUM_GROUP_LOOT_FRAMES do

		objName = "GroupLootFrame"..i
		obj = _G[objName]
		self:keepFontStrings(obj)
		_G[objName.."SlotTexture"]:SetTexture(nil)
		_G[objName.."NameFrame"]:SetTexture(nil)
		self:addButtonBorder{obj=_G[objName.."IconFrame"]}
		self:removeRegions(_G[objName.."Timer"], {1})
		self:glazeStatusBar(_G[objName.."Timer"], 0)
		-- hook this to skin the group loot frame
		self:SecureHook(obj, "Show", function(this)
			this:SetBackdrop(nil)
		end)

		if self.db.profile.GroupLoot.size == 1 then

			self:addSkinFrame{obj=obj, ft=ftype, x1=4, y1=-5, x2=-4, y2=5}

		elseif self.db.profile.GroupLoot.size == 2 then

			obj:SetScale(0.75)
			self:addSkinFrame{obj=obj, ft=ftype, x1=4, y1=-5, x2=-4, y2=5}

		elseif self.db.profile.GroupLoot.size == 3 then

			obj:SetScale(0.75)
			self:moveObject{obj=_G[objName.."SlotTexture"], x=95, y=4} -- Loot item icon
			_G[objName.."Name"]:SetAlpha(0)
			_G[objName.."RollButton"]:ClearAllPoints()
			_G[objName.."RollButton"]:SetPoint("RIGHT", _G[objName.."PassButton"], "LEFT", 5, -5)
			_G[objName.."GreedButton"]:ClearAllPoints()
			_G[objName.."GreedButton"]:SetPoint("RIGHT", _G[objName.."RollButton"], "LEFT", 0, 0)
			_G[objName.."DisenchantButton"]:ClearAllPoints()
			_G[objName.."DisenchantButton"]:SetPoint("RIGHT", _G[objName.."GreedButton"], "LEFT", 0, 0)
			self:adjWidth{obj=_G[objName.."Timer"], adj=-28}
			self:moveObject{obj=_G[objName.."Timer"], x=-3}
			self:addSkinFrame{obj=obj, ft=ftype, x1=102, y1=-5, x2=-4, y2=16}

		end

	end

end

function aObj:ContainerFrames()
	if not self.db.profile.ContainerFrames.skin or self.initialized.ContainerFrames then return end
	self.initialized.ContainerFrames = true

	self:add2Table(self.uiKeys2, "ContainerFrames")

	for i = 1, NUM_CONTAINER_FRAMES do
		objName = "ContainerFrame"..i
		self:addSkinFrame{obj=_G[objName], ft=ftype, kfs=true, x1=8, y1=-4, x2=-3}
		-- resize and move the bag name to make it more readable
		obj = _G[objName.."Name"]
		obj:SetWidth(145)
		self:moveObject{obj=obj, x=-30}
		-- add button borders
		for j = 1, MAX_CONTAINER_ITEMS do
			self:addButtonBorder{obj=_G[objName.."Item"..j]}
		end
	end

end

function aObj:StackSplit()
	if not self.db.profile.StackSplit or self.initialized.StackSplit then return end
	self.initialized.StackSplit = true

	self:add2Table(self.uiKeys1, "StackSplit")

	-- handle different addons being loaded
	if IsAddOnLoaded("EnhancedStackSplit") then
		self:addSkinFrame{obj=StackSplitFrame, ft=ftype, kfs=true, y2=-24}
	else
		self:addSkinFrame{obj=StackSplitFrame, ft=ftype, kfs=true, x1=9, y1=-12, x2=-6, y2=12}
	end

end

function aObj:ItemText()
	if not self.db.profile.ItemText or self.initialized.ItemText then return end
	self.initialized.ItemText = true

	self:add2Table(self.uiKeys1, "ItemText")

	self:SecureHookScript(ItemTextFrame, "OnShow", function(this)
		ItemTextPageText:SetTextColor(self.BTr, self.BTg, self.BTb)
	end)

	self:skinScrollBar{obj=ItemTextScrollFrame}
	self:glazeStatusBar(ItemTextStatusBar, 0)
	self:moveObject{obj=ItemTextPrevPageButton, x=-55} -- move prev button left
	self:addSkinFrame{obj=ItemTextFrame, ft=ftype, kfs=true, x1=10, y1=-13, x2=-32, y2=71}

end

function aObj:ColorPicker()
	if not self.db.profile.Colours or self.initialized.Colours then return end
	self.initialized.Colours = true

	self:add2Table(self.uiKeys1, "Colours")

	ColorPickerFrame:SetBackdrop(nil)
	ColorPickerFrameHeader:SetAlpha(0)
	self:skinSlider(OpacitySliderFrame, 4)
	self:addSkinFrame{obj=ColorPickerFrame, ft=ftype, y1=6}

-->>-- Opacity Frame, used by BattlefieldMinimap amongst others
	OpacityFrame:SetBackdrop(nil)
	self:skinSlider{obj=OpacityFrameSlider, size=3}
	self:addSkinFrame{obj=OpacityFrame, ft=ftype}

end

function aObj:WorldMap()
	if not self.db.profile.WorldMap.skin or self.initialized.WorldMap then return end
	self.initialized.WorldMap = true

	self:add2Table(self.uiKeys2, "WorldMap")

	if not IsAddOnLoaded("Mapster")
	and not IsAddOnLoaded("AlleyMap")
	then
		local function sizeUp()

			self.skinFrame[WorldMapFrame]:ClearAllPoints()
			self.skinFrame[WorldMapFrame]:SetPoint("TOPLEFT", WorldMapFrame, "TOPLEFT", 102, 1)
			self.skinFrame[WorldMapFrame]:SetPoint("BOTTOMRIGHT", WorldMapFrame, "BOTTOMRIGHT", -102, 1)

		end
		local function sizeDown()

			if not WORLDMAP_SETTINGS.advanced then -- frame not moveable
				x1, y1, x2, y2 = 12, -12, -20, -10
			else -- frame moveable
				x1, y1, x2, y2 = 0, 2, 0, 0
			end
			self.skinFrame[WorldMapFrame]:ClearAllPoints()
			self.skinFrame[WorldMapFrame]:SetPoint("TOPLEFT", WorldMapFrame, "TOPLEFT", x1, y1)
			self.skinFrame[WorldMapFrame]:SetPoint("BOTTOMRIGHT", WorldMapFrame, "BOTTOMRIGHT", x2, y2)

		end
		-- handle size change
		self:SecureHook("WorldMap_ToggleSizeUp", function()
			sizeUp()
		end)
		self:SecureHook("WorldMap_ToggleSizeDown", function()
			sizeDown()
		end)
		self:SecureHook("WorldMapFrame_ToggleAdvanced", function()
			if WORLDMAP_SETTINGS.size == WORLDMAP_WINDOWED_SIZE -- Patch
			then
				sizeDown()
			end
		end)
		-- handle different map addons being loaded or fullscreen required
		if self.db.profile.WorldMap.size == 2 then
			self:addSkinFrame{obj=WorldMapFrame, ft=ftype, kfs=true, y1=1, x2=1}
		elseif not IsAddOnLoaded("MetaMap") and not IsAddOnLoaded("Cartographer_LookNFeel") then
			self:addSkinFrame{obj=WorldMapFrame, ft=ftype, kfs=true}
			if WORLDMAP_SETTINGS.size == WORLDMAP_WINDOWED_SIZE -- Patch
			then
				sizeDown()
			else
				sizeUp()
			end
		end
	end

	-- textures removed as they are shown and alphas are changed
	WorldMapFrameMiniBorderLeft:SetTexture(nil)
	WorldMapFrameMiniBorderRight:SetTexture(nil)

	self:skinDropDown{obj=WorldMapContinentDropDown}
	self:skinDropDown{obj=WorldMapZoneDropDown}
	self:skinDropDown{obj=WorldMapZoneMinimapDropDown}
	self:skinDropDown{obj=WorldMapLevelDropDown}
	self:skinButton{obj=WorldMapFrameCloseButton, cb=true}
	self:skinScrollBar{obj=WorldMapQuestScrollFrame}
	self:skinScrollBar{obj=WorldMapQuestDetailScrollFrame}
	self:skinScrollBar{obj=WorldMapQuestRewardScrollFrame}

-->>-- Tooltip(s)
	if self.db.profile.Tooltips.skin
	and self.db.profile.Tooltips.style == 3
	then
		self:add2Table(self.ttList, "WorldMapTooltip")
		self:add2Table(self.ttList, "WorldMapCompareTooltip1")
		self:add2Table(self.ttList, "WorldMapCompareTooltip2")
		self:add2Table(self.ttList, "WorldMapCompareTooltip3")
	end

end

function aObj:HelpFrame()
	if not self.db.profile.HelpFrame or self.initialized.HelpFrame then return end
	self.initialized.HelpFrame = true

	self:add2Table(self.uiKeys1, "HelpFrame")

	local hfTitle = self:getRegion(HelpFrame, 11)
	local kbTitle = self:getRegion(KnowledgeBaseFrame, 2)
	-- hook these to manage frame titles
	self:SecureHook("HelpFrame_ShowFrame", function(key)
		hfTitle:SetAlpha(0)
		kbTitle:SetAlpha(0)
		if key == "KBase" then
			kbTitle:SetAlpha(1)
		else
			hfTitle:SetAlpha(1)
		end
	end)
	self:SecureHook("HelpFrame_PopFrame", function()
		if HelpFrame.openFrame and HelpFrame.openFrame:GetName() == "KnowledgeBaseFrame" then
			hfTitle:SetAlpha(0)
			kbTitle:SetAlpha(1)
		end
	end)

-->>--	Ticket Status Frame
	self:addSkinFrame{obj=TicketStatusFrameButton, ft=ftype}

-->>--	Help Frame
	self:moveObject{obj=hfTitle, y=-8}
	 --> N.B. restrict button children traversal for KnowledgeBase button below
	self:addSkinFrame{obj=HelpFrame, ft=ftype, kfs=true, bgen=2, x1=6, y1=-6, x2=-45, y2=14}

-->>--	KnowledgeBase Frame
	self:keepFontStrings(KnowledgeBaseFrame)
	self:moveObject{obj=kbTitle, y=-8}
	self:skinButton{obj=GMChatOpenLog}
	self:skinEditBox{obj=KnowledgeBaseFrameEditBox}
	self:skinDropDown{obj=KnowledgeBaseFrameCategoryDropDown}
	self:skinDropDown{obj=KnowledgeBaseFrameSubCategoryDropDown}
	KnowledgeBaseFrameDivider:Hide()
	KnowledgeBaseFrameDivider2:Hide()
-->>-- Article Scroll Frame
	self:skinScrollBar{obj=KnowledgeBaseArticleScrollFrame}
	self:skinButton{obj=KnowledgeBaseArticleScrollChildFrameBackButton, as=true}
-->>-- Talk to a GM panel
-->>-- Report an Issue panel
-->>-- Character Stuck panel
	self:addButtonBorder{obj=HelpFrameStuckHearthstone, es=20}
-->>--	Open Ticket SubFrame
	HelpFrameOpenTicketDivider:Hide()
	self:skinScrollBar{obj=HelpFrameOpenTicketScrollFrame}
-->>-- View Response SubFrame
	self:skinScrollBar{obj=HelpFrameViewResponseIssueScrollFrame}
	HelpFrameViewResponseDivider:Hide()
	self:skinScrollBar{obj=HelpFrameViewResponseMessageScrollFrame}

end

function aObj:Tutorial()
	if not self.db.profile.Tutorial or self.initialized.Tutorial then return end
	self.initialized.Tutorial = true

	self:add2Table(self.uiKeys1, "Tutorial")

	local function resetSF()

		-- use the same frame level & strata as TutorialFrame so it appears above other frames
		self.skinFrame[TutorialFrame]:SetFrameLevel(TutorialFrame:GetFrameLevel())
		self.skinFrame[TutorialFrame]:SetFrameStrata(TutorialFrame:GetFrameStrata())

	end
	TutorialFrame:DisableDrawLayer("BACKGROUND")
	TutorialFrameTop:SetTexture(nil)
	TutorialFrameBottom:SetTexture(nil)
	for i = 1, 30 do
		_G["TutorialFrameLeft"..i]:SetTexture(nil)
		_G["TutorialFrameRight"..i]:SetTexture(nil)
	end
	TutorialTextBorder:SetAlpha(0)
	self:skinScrollBar{obj=TutorialFrameTextScrollFrame}
	-- stop animation before skinning, otherwise textures reappear
	AnimateMouse:Stop()
	AnimateCallout:Stop()
	self:addSkinFrame{obj=TutorialFrame, ft=ftype, anim=true, x1=10, y1=-11, x2=1}
	resetSF()
	-- hook this as the TutorialFrame frame level keeps changing
	self:SecureHookScript(self.skinFrame[TutorialFrame], "OnShow", function(this)
		resetSF()
	end)
	-- hook this to hide the skin frame if required (e.g. arrow keys tutorial)
	self:SecureHook("TutorialFrame_Update", function(...)
		resetSF()
		if TutorialFrameTop:IsShown() then
			self.skinFrame[TutorialFrame]:Show()
		else
			self.skinFrame[TutorialFrame]:Hide()
		end
	end)

-->>-- Alert button
	btn = TutorialFrameAlertButton
	btn:GetNormalTexture():SetAlpha(0)
	btn:SetNormalFontObject("ZoneTextFont")
	btn:SetText("?")
	self:moveObject{obj=btn:GetFontString(), x=4}
	self:addSkinButton{obj=btn, parent=btn, x1=30, y1=-1, x2=-25, y2=10}

end

function aObj:GMSurveyUI() -- LoD
	if not self.db.profile.GMSurveyUI or self.initialized.GMSurveyUI then return end
	self.initialized.GMSurveyUI = true

	self:keepFontStrings(GMSurveyHeader)
	self:moveObject{obj=GMSurveyHeaderText, y=-8}
	self:addSkinFrame{obj=GMSurveyFrame, ft=ftype, kfs=true, y1=-6, x2=-45}

	self:skinScrollBar{obj=GMSurveyScrollFrame}

	for i = 1, MAX_SURVEY_QUESTIONS do
		obj = _G["GMSurveyQuestion"..i]
		self:applySkin{obj=obj, ft=ftype} -- must use applySkin otherwise text is behind gradient
		obj.SetBackdropColor = function() end
		obj.SetBackdropBorderColor = function() end
	end

	self:skinScrollBar{obj=GMSurveyCommentScrollFrame}
	self:applySkin{obj=GMSurveyCommentFrame, ft=ftype} -- must use applySkin otherwise text is behind gradient

end

function aObj:InspectUI() -- LoD
	if not self.db.profile.InspectUI or self.initialized.InspectUI then return end
	self.initialized.InspectUI = true

	self:addSkinFrame{obj=InspectFrame, ft=ftype, kfs=true, ri=true, y1=2, x2=1, y2=-6}

-->>-- Inspect PaperDoll frame
	-- Inspect Model Frame
	self:makeMFRotatable(InspectModelFrame)
	for _, child in ipairs{InspectPaperDollItemsFrame:GetChildren()} do
		child:DisableDrawLayer("BACKGROUND")
		-- add button borders
		if child:IsObjectType("Button") and child:GetName():find("Slot") then
			self:addButtonBorder{obj=child, ibt=true}
		end
	end
	InspectModelFrame:DisableDrawLayer("BACKGROUND")
	InspectModelFrame:DisableDrawLayer("BORDER")
	InspectModelFrame:DisableDrawLayer("OVERLAY")

-->>--	PVP Frame
	self:keepFontStrings(InspectPVPFrame)
	for i = 1, MAX_ARENA_TEAMS do
		_G["InspectPVPTeam"..i.."StandardBar"]:Hide()
		self:addSkinFrame{obj=_G["InspectPVPTeam"..i], hat=true, x1=-40, y1=4, x2=-20}
	end

-->>--	Talent Frame
	self:keepRegions(InspectTalentFrame, {6, 7, 8, 9, 10}) -- N.B. 6, 7, 8 & 9 are the background picture, 10 is text
	self:skinScrollBar{obj=InspectTalentFrameScrollFrame}
	self:keepFontStrings(InspectTalentFramePointsBar)
	self:skinFFToggleTabs("InspectTalentFrameTab")
	self:moveObject{obj=InspectTalentFrameTab1, x=-30}
	-- add button borders
	for i = 1, MAX_NUM_TALENTS do
		btnName = "InspectTalentFrameTalent"..i
		_G[btnName.."Slot"]:SetAlpha(0)
		self:addButtonBorder{obj=_G[btnName], tibt=true}
	end

-->>-- Guild Frame
	InspectGuildFrameBG:SetAlpha(0)
-->>-- Tabs
	for i = 1, InspectFrame.numTabs do
		tab = _G["InspectFrameTab"..i]
		self:keepRegions(tab, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		tabSF = self:addSkinFrame{obj=tab, ft=ftype, noBdr=self.isTT, x1=6, y1=0, x2=-6, y2=2}
		-- set textures here first time thru as it's LoD
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end
	self.tabFrames[InspectFrame] = true

end

function aObj:BattleScore() -- a.k.a. WorldStateScoreFrame
	if not self.db.profile.BattleScore or self.initialized.BattleScore then return end
	self.initialized.BattleScore = true

	self:add2Table(self.uiKeys1, "BattleScore")

	self:skinDropDown{obj=ScorePlayerDropDown}
	self:skinScrollBar{obj=WorldStateScoreScrollFrame}
	self:addSkinFrame{obj=WorldStateScoreFrame, ft=ftype, kfs=true, ri=true, y1=2, x2=1, y2=-6}

-->>-- Tabs
	for i = 1, WorldStateScoreFrame.numTabs do
		tab = _G["WorldStateScoreFrameTab"..i]
		self:keepRegions(tab, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		tabSF = self:addSkinFrame{obj=tab, ft=ftype, noBdr=self.isTT, x1=6, y1=0, x2=-6, y2=2}
	end
	self.tabFrames[WorldStateScoreFrame] = true

end

function aObj:BattlefieldMinimap() -- LoD
	if not self.db.profile.BattlefieldMm or self.initialized.BattlefieldMm then return end
	self.initialized.BattlefieldMm = true

	-- change the skinFrame's opacity as required
	self:SecureHook("BattlefieldMinimap_UpdateOpacity", function(opacity)
		local alpha = 1.0 - BattlefieldMinimapOptions.opacity
		alpha = (alpha >= 0.15) and alpha - 0.15 or alpha
		self.skinFrame[BattlefieldMinimap]:SetAlpha(alpha)
		self.skinFrame[BattlefieldMinimap].tfade:SetAlpha(alpha)
	end)

-->>--	Minimap Tab
	self:keepRegions(BattlefieldMinimapTab, {4, 5}) -- N.B. region 4 is the Text, 5 is the highlight
	asopts = self.isTT and {ba=1} or nil
	self:addSkinFrame{obj=BattlefieldMinimapTab, ft=ftype, noBdr=self.isTT, aso=asopts, y1=-7, y2=-7}
	self:moveObject{obj=BattlefieldMinimapTabText, y=-1} -- move text down
-->>--	Minimap
	-- change the draw layer so that the map is visible
	for i = 1, NUM_WORLDMAP_DETAIL_TILES do
		_G["BattlefieldMinimap"..i]:SetDrawLayer("ARTWORK")
	end

	-- Create a frame to skin as using the BattlefieldMinimap one causes issues with Capping
	self:addSkinFrame{obj=BattlefieldMinimap, ft=ftype, bg=true, x1=-4, y1=4, x2=-2, y2=-1}
	-- hide the textures as the alpha values are changed in game
	BattlefieldMinimapCorner:Hide()
	BattlefieldMinimapBackground:Hide()

	if IsAddOnLoaded("Capping") then
		if type(self["Capping_ModMap"]) == "function" then self:Capping_ModMap() end
	end

end

function aObj:ScriptErrors()
	if not self.db.profile.ScriptErrors or self.initialized.ScriptErrors then return end
	self.initialized.ScriptErrors = true

	self:add2Table(self.uiKeys1, "ScriptErrors")

	-- skin Basic Script Errors Frame (BasicControls.xml)
	self:addSkinFrame{obj=BasicScriptErrors, kfs=true, ft=ftype}

end

function aObj:DropDowns()
	if not self.db.profile.DropDowns or self.initialized.DropDowns then return end
	self.initialized.DropDowns = true

	self:add2Table(self.uiKeys1, "DropDowns")

	self:SecureHook("UIDropDownMenu_CreateFrames", function(...)
		local obj, objName
		for i = 1, UIDROPDOWNMENU_MAXLEVELS do
			objName = "DropDownList"..i
			obj = _G[objName]
			if not self:IsHooked(obj, "Show") then
				self:SecureHook(obj, "Show", function(this)
					_G[this:GetName().."Backdrop"]:Hide()
					_G[this:GetName().."MenuBackdrop"]:Hide()
					if not self.skinFrame[this] then
						self:addSkinFrame{obj=this, ft=ftype, kfs=true}
					end
				end)
			end
		end
	end)

end

function aObj:Minimap()
	if not self.db.profile.Minimap.skin or self.initialized.Minimap then return end
	self.initialized.Minimap = true

	self:add2Table(self.uiKeys2, "Minimap")

-->>-- Cluster Frame
	MinimapBorderTop:Hide()
	MinimapZoneTextButton:ClearAllPoints()
	MinimapZoneTextButton:SetPoint("BOTTOMLEFT", Minimap, "TOPLEFT", 0, 5)
	MinimapZoneTextButton:SetPoint("BOTTOMRIGHT", Minimap, "TOPRIGHT", 0, 5)
	MinimapZoneText:ClearAllPoints()
	MinimapZoneText:SetPoint("CENTER")
	self:addSkinButton{obj=MinimapZoneTextButton, parent=MinimapZoneTextButton}

-->>-- Minimap
	Minimap:SetMaskTexture([[Interface\Buttons\WHITE8X8]]) -- needs to be a square texture
	self.minimapskin = self:addSkinFrame{obj=Minimap, x1=-5, y1=5, x2=5, y2=-5}
	if self.db.profile.Minimap.gloss then
		RaiseFrameLevel(self.minimapskin)
	else
		LowerFrameLevel(self.minimapskin)
	end

-->>-- Minimap Backdrop Frame
	MinimapBorder:SetAlpha(0)
	MinimapNorthTag:SetAlpha(0)
	MinimapCompassTexture:SetAlpha(0)

-->>-- Buttons
	MiniMapWorldMapButton:Hide()
	-- on LHS
	local xOfs, yOfs = 6, 4
	for _, v in pairs{MiniMapTracking, MiniMapLFGFrame, MiniMapRecordingButton, MiniMapVoiceChatFrame} do
		v:ClearAllPoints()
		v:SetPoint("TOPRIGHT", Minimap, "TOPLEFT", xOfs, yOfs)
		yOfs = yOfs - v:GetHeight() + 3
	end
	self:moveObject{obj=MiniMapInstanceDifficulty, x=-10}
	self:moveObject{obj=GuildInstanceDifficulty, x=-10}
	-- on RHS
	MiniMapMailFrame:ClearAllPoints()
	MiniMapMailFrame:SetPoint("LEFT", Minimap, "RIGHT", -10, 28)
	MinimapZoomIn:ClearAllPoints()
	MinimapZoomIn:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMRIGHT", -4, -3)
	MinimapZoomOut:ClearAllPoints()
	MinimapZoomOut:SetPoint("TOPRIGHT", Minimap, "BOTTOMRIGHT", 3, 4)
	-- on Bottom
	MiniMapBattlefieldFrame:ClearAllPoints()
	MiniMapBattlefieldFrame:SetPoint("TOPLEFT", Minimap, "BOTTOMLEFT", 10, 10)

	-- move BuffFrame
	self:moveObject{obj=BuffFrame, x=-10}
end

function aObj:MinimapButtons()
	if not self.db.profile.MinimapButtons.skin or self.initialized.MinimapButtons then return end
	self.initialized.MinimapButtons = true

	self:add2Table(self.uiKeys2, "MinimapButtons")

	local minBtn = self.db.profile.MinimapButtons.style
	local objName, objType, tex, texName

	local function mmKids(mmObj)

		local objName, objType, tex, texName
		for _, obj in ipairs{mmObj:GetChildren()} do
			objName = obj:GetName()
			objType = obj:GetObjectType()
--			print(objName, objType)
			if not aObj.sBut[obj]
			and not aObj.skinFrame[obj]
--			and objName
			and objType == "Button"
			or (objType == "Frame" and objName == "MiniMapMailFrame")
			then
--				print("Checking Regions")
				for _, reg in ipairs{obj:GetRegions()} do
					if reg:GetObjectType() == "Texture" then
						texName = reg:GetName()
						tex = reg:GetTexture()
--						print(texName, tex)
						-- change the DrawLayer to make the Icon show if required
						if (texName and texName:find("[Ii]con"))
						or (tex and tex:find("[Ii]con"))
						then
							if reg:GetDrawLayer() == "BACKGROUND" then reg:SetDrawLayer("ARTWORK") end
							-- centre the icon
							reg:ClearAllPoints()
							reg:SetPoint("CENTER")
						elseif (texName and texName:find("Border"))
						or (tex and tex:find("TrackingBorder"))
						then
							reg:SetTexture(nil)
							obj:SetWidth(32)
							obj:SetHeight(32)
							if not minBtn then
								if objType == "Button" then
									aObj:addSkinButton{obj=obj, parent=obj, sap=true}
								else
									aObj:addSkinFrame{obj=obj, ft=ftype}
								end
							end
						elseif (tex and tex:find("Background")) then
							reg:SetTexture(nil)
						end
					end
				end
			elseif objName and objType == "Frame" then
				mmKids(obj)
			end
		end

	end

	-- skin Minimap children
	mmKids(Minimap)

	-- skin other Blizzard buttons
	asopts = {ba=minBtn and 0 or 1, bba=minBtn and 0 or 1, ng=minBtn and true or nil}
	-- Calendar button
	obj = GameTimeFrame
	obj:SetWidth(26)
	obj:SetHeight(26)
	obj:GetNormalTexture():SetTexCoord(0.1, 0.31, 0.16, 0.6)
	obj:GetPushedTexture():SetTexCoord(0.6, 0.81, 0.16, 0.6)
	self:addSkinFrame{obj=obj, aso=asopts, x1=-4, y1=4, x2=4, y2=-4}
	-- make sure textures appear above skinFrame
	LowerFrameLevel(self.skinFrame[obj])

	-- MinimapZoomIn/Out buttons
	for k, obj in pairs{MinimapZoomIn, MinimapZoomOut} do
		obj:GetNormalTexture():SetTexture(nil)
		obj:GetPushedTexture():SetTexture(nil)
		if minBtn then
			obj:GetDisabledTexture():SetTexture([[Interface\Minimap\UI-Minimap-Background]])
		else
			obj:GetDisabledTexture():SetTexture(nil)
		end
		self:adjWidth{obj=obj, adj=-8}
		self:adjHeight{obj=obj, adj=-8}
		self:addSkinButton{obj=obj, parent=obj, aso=asopts}
		btn = self.sBut[obj]
		btn:SetAllPoints(obj:GetNormalTexture())
		btn:SetNormalFontObject(self.modUIBtns.fontX)
		btn:SetDisabledFontObject(self.modUIBtns.fontDX)
		btn:SetPushedTextOffset(1, 1)
		btn:SetText(k == 1 and self.modUIBtns.plus or self.modUIBtns.minus)
		if not obj:IsEnabled() then btn:Disable() end
	end
	-- change Mail icon
	MiniMapMailIcon:SetTexture([[Interface\Minimap\Tracking\Mailbox.blp]])
	-- resize other buttons
	MiniMapMailFrame:SetWidth(28)
	MiniMapMailFrame:SetHeight(28)
	MiniMapVoiceChatFrame:SetWidth(32)
	MiniMapVoiceChatFrame:SetHeight(32)
	MiniMapVoiceChatFrameIcon:ClearAllPoints()
	MiniMapVoiceChatFrameIcon:SetPoint("CENTER")
	-- MiniMap Tracking
	MiniMapTrackingBackground:SetTexture(nil)
	MiniMapTrackingIcon:SetParent(MiniMapTrackingButton)
	MiniMapTrackingIcon:ClearAllPoints()
	MiniMapTrackingIcon:SetPoint("CENTER")
	-- change this to stop the icon being moved
	MiniMapTrackingIcon.SetPoint = function() end
	if not minBtn then
		self:addSkinFrame{obj=MiniMapTracking, ft=ftype}
	end
	-- FeedbackUI Minimap Button
	if self.isPTR then
		for _, reg in ipairs{FeedbackUIButton:GetRegions()} do
			reg:SetWidth(26)
			reg:SetHeight(26)
		end
	end
	-- Instance Difficulty
	MiniMapInstanceDifficultyTexture:SetTexCoord(0.0, 0.25, 0.135, 0.5) -- remove top hanger texture
	self:moveObject{obj=MiniMapInstanceDifficulty, y=-5}
	-- Guild Instance Difficulty
	GuildInstanceDifficultyHanger:SetAlpha(0)

	-- skin any moved Minimap buttons if required
	if IsAddOnLoaded("MinimapButtonFrame") then mmKids(MinimapButtonFrame) end

	-- show the Bongos minimap icon if required
	if IsAddOnLoaded("Bongos") then Bongos3MinimapButton.icon:SetDrawLayer("ARTWORK") end

	-- skin other minimap buttons as required
	if not minBtn then
		local mmButs = {
			["SmartBuff"] = SmartBuff_MiniMapButton,
			["WebDKP"] = WebDKP_MinimapButton,
			["GuildAds"] = GuildAdsMinimapButton,
			["Outfitter"] = OutfitterMinimapButton,
			["Perl_Config"] = PerlButton,
			["WIM"] = WIM3MinimapButton,
			["DBM-Core"] = DBMMinimapButton,
		}
		for addon, obj in pairs(mmButs) do
			if IsAddOnLoaded(addon) then
				self:addSkinButton{obj=obj, parent=obj, sap=true}
			end
		end
		mmButs = nil
	end

end

if aObj.isPTR then
	function aObj:FeedbackUI() -- LoD
		if not self.db.profile.Feedback or self.initialized.Feedback then return end
		self.initialized.Feedback = true

		self:add2Table(self.uiKeys1, "FeedbackUI")

		local bbR, bbG, bbB, bbA = unpack(self.bbColour)

		self:keepFontStrings(FeedbackUITitleFrm)
		FeedbackUIWelcomeFrame:SetBackdrop(nil)
		self:skinDropDown{obj=FeedbackUI_ModifierKeyDropDown}
		self:addSkinFrame{obj=FeedbackUI_ModifierKeyDropDownList, ft=ftype}
		self:skinDropDown{obj=FeedbackUI_MouseButtonDropDown}
		self:addSkinFrame{obj=FeedbackUI_MouseButtonDropDownList, ft=ftype}
		self:addSkinFrame{obj=FeedbackUI, ft=ftype, kfs=true}
		tinsert(UISpecialFrames, "FeedbackUI") -- make it closeable with Esc key

	-->>-- Welcome Frame panels
		FeedbackUIWelcomeFrameSurveys:DisableDrawLayer("BORDER")
		self:addButtonBorder{obj=FeedbackUIWelcomeFrameSurveys, relTo=FeedbackUIWelcomeFrameSurveysIcon}
		FeedbackUIWelcomeFrameSuggestions:DisableDrawLayer("BORDER")
		self:addButtonBorder{obj=FeedbackUIWelcomeFrameSuggestions, relTo=FeedbackUIWelcomeFrameSuggestionsIcon}
		FeedbackUIWelcomeFrameBugs:DisableDrawLayer("BORDER")
		self:addButtonBorder{obj=FeedbackUIWelcomeFrameBugs, relTo=FeedbackUIWelcomeFrameBugsIcon}

	-->-- Survey Frame
		FeedbackUISurveyFrame:SetBackdrop(nil)
		self:skinDropDown{obj=FeedbackUISurveyFrameSurveysPanelDdlCategory}
		self:addSkinFrame{obj=FeedbackUISurveyFrameSurveysPanelDdlCategoryList, ft=ftype}
		self:skinDropDown{obj=FeedbackUISurveyFrameSurveysPanelDdlStatus}
		self:addSkinFrame{obj=FeedbackUISurveyFrameSurveysPanelDdlStatusList, ft=ftype}
		FeedbackUISurveyFrameSurveysPanelHeadersColumnUnderline:SetAlpha(0)
		for i = 1, 8 do
			self:skinButton{obj=_G["FeedbackUISurveyFrameSurveysPanelScrollButtonsOption"..i.."Btn"], mp2=true}
		end
		self:skinUsingBD{obj=FeedbackUISurveyFrameSurveysPanelScrollScrollControls, size=3}
		FeedbackUISurveyFrameSurveysPanelBorder:SetBackdropBorderColor(bbR, bbG, bbB, bbA)
		FeedbackUISurveyFrameStatusPanelBorder:SetBackdropBorderColor(bbR, bbG, bbB, bbA)
		FeedbackUISurveyFrameStatusPanelLine:SetAlpha(0)
		FeedbackUISurveyFrameStepThroughPanelBorder:SetBackdropBorderColor(bbR, bbG, bbB, bbA)
		self:addSkinFrame{obj=FeedbackUISurveyFrameStepThroughPanelHeader, ft=ftype, x1=1, y1=-1, x2=-1, y2=1}
		self:addSkinFrame{obj=FeedbackUISurveyFrameStepThroughPanelEdit, ft=ftype}
		self:skinScrollBar{obj=FeedbackUISurveyFrameStepThroughPanelEditInput}
		self:skinUsingBD{obj=FeedbackUISurveyFrameStepThroughPanelScrollScrollControls, size=3}
		if self.modBtnBs then
			-- skin the alert buttons
			for i = 1, 10 do
				obj = _G["FeedbackUISurveyFrameSurveysPanelAlertFrameButton"..i]
				self:addButtonBorder{obj=obj, ofs=0, x2=-2, y2=3}
			end
		end

	-->>-- Suggestion Frame
		FeedbackUISuggestFrame:SetBackdrop(nil)
		FeedbackUISuggestFrameInfoPanelBorder:SetBackdropBorderColor(bbR, bbG, bbB, bbA)
		FeedbackUISuggestFrameStatusPanelBorder:SetBackdropBorderColor(bbR, bbG, bbB, bbA)
		FeedbackUISuggestFrameStatusPanelLine:SetAlpha(0)
		FeedbackUISuggestFrameStepThroughPanelBorder:SetBackdropBorderColor(bbR, bbG, bbB, bbA)
		self:addSkinFrame{obj=FeedbackUISuggestFrameStepThroughPanelHeader, ft=ftype, x1=1, y1=-1, x2=-1, y2=1}
		self:addSkinFrame{obj=FeedbackUISuggestFrameStepThroughPanelEdit, ft=ftype}
		self:skinScrollBar{obj=FeedbackUISuggestFrameStepThroughPanelEditInput}
		self:skinUsingBD{obj=FeedbackUISuggestFrameStepThroughPanelScrollScrollControls, size=3}

	-->>-- Bug Frame
		FeedbackUIBugFrame:SetBackdrop(nil)
		FeedbackUIBugFrameInfoPanelBorder:SetBackdropBorderColor(bbR, bbG, bbB, bbA)
		FeedbackUIBugFrameStatusPanelBorder:SetBackdropBorderColor(bbR, bbG, bbB, bbA)
		FeedbackUIBugFrameStatusPanelLine:SetAlpha(0)
		FeedbackUIBugFrameStepThroughPanelBorder:SetBackdropBorderColor(bbR, bbG, bbB, bbA)
		self:addSkinFrame{obj=FeedbackUIBugFrameStepThroughPanelHeader, ft=ftype, x1=1, y1=-1, x2=-1, y2=1}
		self:addSkinFrame{obj=FeedbackUIBugFrameStepThroughPanelEdit, ft=ftype}
		self:skinScrollBar{obj=FeedbackUIBugFrameStepThroughPanelEditInput}
		self:skinUsingBD{obj=FeedbackUIBugFrameStepThroughPanelScrollScrollControls, size=3}

		-- make the QuestLog Tip Label text visible
		FeedbackUIQuestLogTipLabel:SetTextColor(self.BTr, self.BTg, self.BTb)

	end
end
