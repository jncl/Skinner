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

	-- Battleground/Arena Start Timer (4.1)
	local function skinTT(tT)

		-- aObj:Debug("skinTT: [%s, %s]", tT, #tT.timerList)
		for _, timer in pairs(tT.timerList) do
			-- aObj:Debug("skinTT#2: [%s]", timer)
			if not aObj.sbGlazed[timer.bar] then
				local bg = aObj:getRegion(timer.bar, 1)
				_G[timer.bar:GetName().."Border"]:SetTexture(nil) -- animations
				aObj:glazeStatusBar(timer.bar, 0, bg)
				aObj:moveObject{obj=bg, y=2} -- align bars
			end
		end

	end
	self:SecureHookScript(TimerTracker, "OnEvent", function(this, event, ...)
		-- self:Debug("TT_OE: [%s, %s]", this, event)
		if event == "START_TIMER" then
			skinTT(this)
		end
	end)
	-- skin existing timers
	skinTT(TimerTracker)

end

function aObj:CastingBar()
	if not self.db.profile.CastingBar.skin or self.initialized.CastingBar then return end
	self.initialized.CastingBar = true

	self:add2Table(self.uiKeys2, "CastingBar")

	local modUF = self:GetModule("UnitFrames", true):IsEnabled() and self:GetModule("UnitFrames", true)
	-- hook this to move the spark down on the casting bar
	self:SecureHook("CastingBarFrame_OnUpdate", function(this, ...)
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
		self:moveObject{obj=this.barSpark, y=yOfs}
	end)

	for _, prefix in pairs{"", "Pet"} do

		obj = _G[prefix.."CastingBarFrame"]
		obj.border:SetAlpha(0)
		self:changeShield(obj.borderShield, obj.icon)
		obj.barFlash:SetAllPoints()
		obj.barFlash:SetTexture([[Interface\Buttons\WHITE8X8]])
		self:moveObject{obj=obj.text, y=obj.ignoreFramePositionManager and 0 or -2}
		if self.db.profile.CastingBar.glaze then
			self:glazeStatusBar(obj, 0, self:getRegion(obj, 1))
		end

	end
	-- hook this to handle the CastingBar being attached to the Unitframe and then reset
	self:SecureHook("CastingBarFrame_SetLook", function(castBar, look)
		castBar.border:SetAlpha(0)
		castBar.barFlash:SetAllPoints()
		castBar.barFlash:SetTexture([[Interface\Buttons\WHITE8X8]])
		if look == "CLASSIC" then
			self:moveObject{obj=castBar.text, y=-2}
		end
	end)

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

local function skinChatTab(objName)

	tab = _G[objName.."Tab"]
	aObj:keepRegions(tab, {7, 8, 9, 10, 11, 12}) --N.B. region 7 is glow, 8-10 are highlight, 11 is text, 12 is icon
	tabSF = aObj:addSkinFrame{obj=tab, ft=ftype, noBdr=aObj.isTT, y1=-8, y2=-5}
	tabSF:SetAlpha(0.2)
	-- hook this to fix tab gradient texture overlaying text & highlight
	aObj:SecureHook(tab, "SetParent", function(this, parent)
		local tabSF = aObj.skinFrame[this]
		if parent == GeneralDockManager.scrollFrame.child then
			tabSF:SetParent(GeneralDockManager)
		else
			tabSF:SetParent(this)
			tabSF:SetFrameLevel(1) -- reset frame level so that the texture is behind text etc
		end
	end)
	-- hook this to manage alpha changes when chat frame fades in and out
	aObj:SecureHook(tab, "SetAlpha", function(this, alpha)
		aObj.skinFrame[this]:SetAlpha(alpha)
	end)

end
function aObj:ChatTabs()
	if not self.db.profile.ChatTabs or self.initialized.ChatTabs then return end
	self.initialized.ChatTabs = true

	self:add2Table(self.uiKeys1, "ChatTabs")

	for i = 1, NUM_CHAT_WINDOWS do
		skinChatTab("ChatFrame"..i)
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

local function skinChatEB(obj)

	if aObj.db.profile.ChatEditBox.style == 1 then -- Frame
		local kRegions = CopyTable(aObj.ebRegions)
		table.insert(kRegions, 12)
		table.insert(kRegions, 13)
		aObj:keepRegions(obj, kRegions)
		aObj:addSkinFrame{obj=obj, ft=ftype, x1=2, y1=-2, x2=-2}
		aObj.skinFrame[obj]:SetAlpha(obj:GetAlpha())
	elseif aObj.db.profile.ChatEditBox.style == 2 then -- Editbox
		aObj:skinEditBox{obj=obj, regs={12, 13}, noHeight=true}
	else -- Borderless
		aObj:removeRegions(obj, {6, 7, 8})
		aObj:addSkinFrame{obj=obj, ft=ftype, noBdr=true, x1=5, y1=-4, x2=-5, y2=2}
		aObj.skinFrame[obj]:SetAlpha(obj:GetAlpha())
	end
	aObj.skinned[obj] = true


end
function aObj:ChatEditBox()
	-- don't use an initialized value to allow for dynamic changes
	if not self.db.profile.ChatEditBox.skin then return end

	self:add2Table(self.uiKeys2, "ChatEditBox")

	-- these addons replace the Chat Edit Box
	if IsAddOnLoaded("NeonChat")
	or IsAddOnLoaded("Chatter")
	or IsAddOnLoaded("Prat-3.0")
	then
		return
	end

	for i = 1, NUM_CHAT_WINDOWS do
		skinChatEB(_G["ChatFrame"..i].editBox)
	end
	-- if editBox has a skin frame then hook these to manage its Alpha setting
	if self.db.profile.ChatEditBox.style ~= 2
	and not self:IsHooked("ChatEdit_ActivateChat")
	then
		self:SecureHook("ChatEdit_ActivateChat", function(editBox)
			if editBox
			and self.skinFrame[editBox]
			then
				self.skinFrame[editBox]:SetAlpha(editBox:GetAlpha())
			end
		end)
		self:SecureHook("ChatEdit_DeactivateChat", function(editBox)
			if editBox
			and self.skinFrame[editBox]
			then
				self.skinFrame[editBox]:SetAlpha(editBox:GetAlpha())
			end
		end)
	end

end

function aObj:ChatTemporaryWindow()
	if not self.db.profile.ChatTabs
	and not self.db.profile.ChatFrames
	and not self.db.profile.ChatEditBox.skin
	then return end

	-- self:add2Table(self.uiKeys1, "ChatTemporaryWindow") -- N.B. no option for this, internal function only

	-- hook this to handle Temporary windows (BN Conversations)
	self:RawHook("FCF_OpenTemporaryWindow", function(...)
		-- print("FCF_OpenTemporaryWindow, before", ChatFrame11)
		local obj = self.hooks.FCF_OpenTemporaryWindow(...)
		-- print("FCF_OpenTemporaryWindow, after", obj:GetName())
		if self.db.profile.ChatTabs
		and not self.skinFrame[obj]
		then
			skinChatTab(obj:GetName())
		end
		if self.db.profile.ChatFrames
		and not self.skinFrame[obj]
		then
			self:addSkinFrame{obj=obj, ft=ftype, x1=-4, y1=4, x2=4, y2=-8}
		end
		if self.db.profile.ChatEditBox.skin
		and not self.skinned[obj.editBox]
			then skinChatEB(obj.editBox)
		end
		return obj
	end, true)

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
	self:skinEditBox{obj=BagItemSearchBox, regs={9}, mi=true, noHeight=true, noMove=true}

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

			x1, y1, x2, y2 = 0, 2, 0, 0
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
		self:SecureHook("WorldMapFrame_ToggleWindowSize", function()
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
	self:skinSlider{obj=WorldMapQuestScrollFrame.ScrollBar}
	self:skinSlider{obj=WorldMapQuestDetailScrollFrame.ScrollBar, adj=-6}
	self:skinSlider{obj=WorldMapQuestRewardScrollFrame.ScrollBar, adj=-6}
	self:skinDropDown{obj=WorldMapShowDropDown}

-->>-- Tooltip(s)
	if self.db.profile.Tooltips.skin
	-- and self.db.profile.Tooltips.style == 3
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

	self:keepFontStrings(HelpFrame.header)
	self:moveObject{obj=HelpFrame.header, y=-12}
	self:removeInset(HelpFrame.leftInset)
	self:removeInset(HelpFrame.mainInset)
	self:addSkinFrame{obj=HelpFrame, ft=ftype, kfs=true, ofs=-10}

-->>-- Knowledgebase panel
	self:keepFontStrings(HelpFrame.kbase)
	self:skinEditBox{obj=HelpFrame.kbase.searchBox, regs={9}, mi=true, noHeight=true, noMove=true}
	self:skinSlider{obj=HelpFrame.kbase.scrollFrame.ScrollBar, adj=-4}
	self:skinSlider{obj=HelpFrame.kbase.scrollFrame2.ScrollBar, adj=-6}
	-- Nav Bar
	HelpFrame.kbase.navBar:DisableDrawLayer("BACKGROUND")
	HelpFrame.kbase.navBar.overlay:DisableDrawLayer("OVERLAY")
	HelpFrame.kbase.navBar.home:DisableDrawLayer("OVERLAY")
	HelpFrame.kbase.navBar.home:GetNormalTexture():SetAlpha(0)
	HelpFrame.kbase.navBar.home:GetPushedTexture():SetAlpha(0)
	HelpFrame.kbase.navBar.home.text:SetPoint("RIGHT", -20, 0) -- allow text to be fully displayed

-->>-- Character Stuck panel
	self:addButtonBorder{obj=HelpFrameCharacterStuckHearthstone, es=20}

-->>--	Ticket panel
	self:skinSlider{obj=HelpFrameTicketScrollFrame.ScrollBar}
	self:addSkinFrame{obj=self:getChild(HelpFrame.ticket, 4), ft=ftype}

-->>--	Ticket Status Frame
	self:addSkinFrame{obj=TicketStatusFrameButton, ft=ftype}

-->>-- HelpOpenTicketButton
	HelpOpenTicketButton.tutorial:DisableDrawLayer("BACKGROUND")
	self:addSkinFrame{obj=HelpOpenTicketButton.tutorial, ft=ftype, y1=3, x2=3}

	-- hook this to handle navbar buttons
	self:SecureHook("NavBar_AddButton", function(this, buttonData)
		-- self:Debug("NavBar_AddButton: [%s, %s]", this, buttonData)
		for i = 1, #this.navList do
			local btn = this.navList[i]
			btn:DisableDrawLayer("OVERLAY")
			btn:GetNormalTexture():SetAlpha(0)
			btn:GetPushedTexture():SetAlpha(0)
		end
	end)

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

	self:skinTabs{obj=InspectFrame, lod=true}
	self:addSkinFrame{obj=InspectFrame, ft=ftype, kfs=true, ri=true, y1=2, x2=1, y2=-6}

-->>-- Inspect PaperDoll frame
	-- Inspect Model Frame
	InspectModelFrame.controlFrame:DisableDrawLayer("BACKGROUND")
	for _, child in ipairs{InspectPaperDollItemsFrame:GetChildren()} do
		child:DisableDrawLayer("BACKGROUND")
		if self.modBtnBs then
			-- add button borders
			if child:IsObjectType("Button") and child:GetName():find("Slot") then
				self:addButtonBorder{obj=child, ibt=true}
			end
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
	self:skinScrollBar{obj=InspectTalentFrameScrollFrame}
	self:keepFontStrings(InspectTalentFramePointsBar)
	if self.modBtnBs then
		-- add button borders
		for i = 1, MAX_NUM_TALENTS do
			btnName = "InspectTalentFrameTalent"..i
			_G[btnName.."Slot"]:SetAlpha(0)
			self:addButtonBorder{obj=_G[btnName], tibt=true}
		end
	end
	self:skinTabs{obj=InspectTalentFrame, up=true, lod=true, x1=0, y1=-3, x2=0, y2=-3, hx=-2, hy=3}

-->>-- Guild Frame
	InspectGuildFrameBG:SetAlpha(0)

end

function aObj:BattleScore() -- a.k.a. WorldStateScoreFrame
	if not self.db.profile.BattleScore or self.initialized.BattleScore then return end
	self.initialized.BattleScore = true

	self:add2Table(self.uiKeys1, "BattleScore")

	self:skinDropDown{obj=ScorePlayerDropDown}
	self:skinScrollBar{obj=WorldStateScoreScrollFrame}
	self:skinTabs{obj=WorldStateScoreFrame}
	self:addSkinFrame{obj=WorldStateScoreFrame, ft=ftype, kfs=true, ri=true, y1=2, x2=1, y2=-6}

end

function aObj:BattlefieldMinimap() -- LoD
	if not self.db.profile.BattlefieldMm or self.initialized.BattlefieldMm then return end
	self.initialized.BattlefieldMm = true

-->>--	Minimap Tab
	self:keepRegions(BattlefieldMinimapTab, {4, 5}) -- N.B. region 4 is the Text, 5 is the highlight
	asopts = self.isTT and {ba=1} or nil
	self:addSkinFrame{obj=BattlefieldMinimapTab, ft=ftype, noBdr=self.isTT, aso=asopts, y1=-7, y2=-7}
	self:moveObject{obj=BattlefieldMinimapTabText, y=-1} -- move text down

	-- use a backdrop with no Texture and no Gradient otherwise the map tiles are obscured
	self:addSkinFrame{obj=BattlefieldMinimap, ft=ftype, aso={bd=8, ng=true}, x1=-4, y1=4, x2=-1, y2=-1}
	BattlefieldMinimapCorner:SetTexture(nil)
	BattlefieldMinimapBackground:SetTexture(nil)

	-- change the skinFrame's opacity as required
	self:SecureHook("BattlefieldMinimap_UpdateOpacity", function(opacity)
		local alpha = 1.0 - BattlefieldMinimapOptions.opacity
		alpha = (alpha >= 0.15) and alpha - 0.15 or alpha
		self.skinFrame[BattlefieldMinimap]:SetAlpha(alpha)
	end)

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
	-- World Map Button
	MiniMapWorldMapButton:ClearAllPoints()
	MiniMapWorldMapButton:SetPoint("LEFT", MinimapZoneTextButton, "RIGHT", -4, 0)
	self:skinButton{obj=MiniMapWorldMapButton, ob="M"}

-->>-- Minimap
	Minimap:SetMaskTexture([[Interface\Buttons\WHITE8X8]]) -- needs to be a square texture
	self.minimapskin = self:addSkinFrame{obj=Minimap, ofs=5}
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
	self:moveObject{obj=BuffFrame, x=-40}

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
			-- print(objName, objType)
			if not aObj.sBtn[obj]
			and not aObj.skinFrame[obj]
			and objType == "Button"
			or (objType == "Frame" and objName == "MiniMapMailFrame")
			then
				-- print("Checking Regions")
				for _, reg in ipairs{obj:GetRegions()} do
					if reg:GetObjectType() == "Texture" then
						texName = reg:GetName()
						tex = reg:GetTexture()
						-- print(texName, tex)
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
		btn = self.sBtn[obj]
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
			["FlightMapEnhanced"] = FlightMapEnhancedMinimapButton,
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

		local bbR, bbG, bbB, bbA = unpack(self.bbColour)

		self:keepFontStrings(FeedbackUITitleFrm)
		FeedbackUIWelcomeFrame:SetBackdrop(nil)
		self:skinDropDown{obj=FeedbackUI_ModifierKeyDropDown}
		self:addSkinFrame{obj=FeedbackUI_ModifierKeyDropDownList, ft=ftype}
		self:skinDropDown{obj=FeedbackUI_MouseButtonDropDown}
		self:addSkinFrame{obj=FeedbackUI_MouseButtonDropDownList, ft=ftype}
		self:addSkinFrame{obj=FeedbackUI, ft=ftype, kfs=true}
		self:add2Table(UISpecialFrames, "FeedbackUI") -- make it closeable with Esc key

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

		-- Minimap Button
		if self.db.profile.MinimapButtons.skin then
			for _, reg in ipairs{FeedbackUIButton:GetRegions()} do
				reg:SetWidth(26)
				reg:SetHeight(26)
			end
		end

	end
end
