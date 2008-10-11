local ftype = "u"

function Skinner:Tooltips()
	if not self.db.profile.Tooltips.skin or self.initialized.Tooltips then return end
	self.initialized.Tooltips = true

	-- 	change the default Tooltip Border colour here
	TOOLTIP_DEFAULT_COLOR = self.db.profile.TooltipBorder

	-- fix for TinyTip tooltip becoming 'fractured'
	if self.db.profile.Tooltips.style == 3 then
		TOOLTIP_DEFAULT_BACKGROUND_COLOR = self.db.profile.Backdrop
		self:setTTBackdrop(true)
	end

	local counts = 0
	local function checkGTHeight(cHeight)

		counts = counts + 1

--		Skinner:Debug("checkGTHeight: [%s, %s, %s]", cHeight, evt, math.ceil(GameTooltip:GetHeight()))
		if cHeight ~= math.ceil(GameTooltip:GetHeight()) then
			Skinner:skinTooltip(GameTooltip)
			Skinner:CancelScheduledEvent("GTSBevt")
			counts = 0
		end

		if counts == 10 or GameTooltipStatusBar:IsShown() then
			Skinner:CancelScheduledEvent("GTSBevt")
			counts = 0
		end

	end

	-- Hook this to deal with GameTooltip FadeHeight issues
	self:HookScript(GameTooltipStatusBar, "OnHide", function(this)
--		self:Debug("GameTooltipStatusBar_OnHide: [%s]", this:GetName())
		self.hooks[this].OnHide()
		if GameTooltip:IsShown() then
			cHeight = math.ceil(GameTooltip:GetHeight())
--			self:Debug("GTSB_OnHide: [%s]", cHeight)
			self:ScheduleRepeatingEvent("GTSBevt", checkGTHeight, 0.2, self, cHeight)
		end
		end)

	-- MUST hook to OnShow script rather than the Show method otherwise not every tooltip is skinned
	-- properly everytime
	for _, tooltip in pairs(self.ttList) do
		local ttip = _G[tooltip]
--		self:Debug("Tooltip:[%s, %s]", tooltip, ttip)
		self:HookScript(ttip, "OnShow", function(this)
--			self:Debug("Tooltip OnShow: [%s]", this:GetName())
			self:skinTooltip(this)
			if this == GameTooltip and self.db.profile.Tooltips.glazesb then
				self:glazeStatusBar(GameTooltipStatusBar, 0)
			end
			self.hooks[this].OnShow(this)
			end)
	end

end

function Skinner:MirrorTimers()
	if not self.db.profile.MirrorTimers.skin or self.initialized.MirrorTimers then return end
	self.initialized.MirrorTimers = true

	for i = 1, MIRRORTIMER_NUMTIMERS do
		local mTimer = _G["MirrorTimer"..i]
		local mTimerSB = _G["MirrorTimer"..i.."StatusBar"]
		self:keepFontStrings(mTimer)
		mTimer:SetHeight(mTimer:GetHeight() * 1.1)
		mTimerSB:SetWidth(mTimerSB:GetWidth() * 0.75)
		self:moveObject(_G[mTimer:GetName().."Text"], nil, nil, "-", 2)
		if self.db.profile.MirrorTimers.glaze then self:glazeStatusBar(mTimerSB, 0) end
	end

end

function Skinner:QuestTimers()
	if not self.db.profile.MirrorTimers or self.initialized.QuestTimers then return end
	self.initialized.QuestTimers = true

	self:keepFontStrings(QuestTimerFrame)
	QuestTimerFrame:SetWidth(QuestTimerFrame:GetWidth() - 40)
	QuestTimerFrame:SetHeight(QuestTimerFrame:GetHeight() - 20)
	self:moveObject(QuestTimerHeader, nil, nil, "-", 4)
	self:storeAndSkin(ftype, QuestTimerFrame)

end

function Skinner:CastingBar()
	if not self.db.profile.CastingBar.skin or self.initialized.CastingBar then return end
	self.initialized.CastingBar = true

	for _, prefix in pairs({"", "Pet"}) do
		local cbfName = prefix.."CastingBarFrame"
		local cbft = _G[cbfName.."Text"]
		local cbfs = _G[cbfName.."Spark"]
		local cbff = _G[cbfName.."Flash"]
		local cbfObj = _G[cbfName]
		self:keepFontStrings(cbfObj)
		cbfObj:SetWidth(cbfObj:GetWidth() * 0.75)
		cbfObj:SetHeight(cbfObj:GetHeight() * 1.1)
		cbfs:SetHeight(cbfs:GetHeight() * 1.5)
		cbff:SetWidth(cbfObj:GetWidth())
		cbff:SetHeight(cbfObj:GetHeight())
		cbff:SetTexture(self.sbTexture)
		self:moveObject(cbft, nil, nil, "-", 4)
		self:moveObject(cbff, nil, nil, "-", 28)
		if self.db.profile.CastingBar.glaze then self:glazeStatusBar(cbfObj, 0) end
		if cbfName == "CastingBarFrame" then
			self:SecureHook("CastingBarFrame_OnUpdate", function()
				self:moveObject(cbfs, nil, nil, "-", 3)
			end)
		end
	end

end

function Skinner:StaticPopups()
	if not self.db.profile.StaticPopups or self.initialized.StaticPopups then return end
	self.initialized.StaticPopups = true

	for i = 1, STATICPOPUP_NUMDIALOGS do
		self:storeAndSkin(ftype, _G["StaticPopup"..i])
		self:skinEditBox(_G["StaticPopup"..i.."EditBox"])
		self:skinEditBox(_G["StaticPopup"..i.."WideEditBox"])
		self:skinMoneyFrame(_G["StaticPopup"..i.."MoneyInputFrame"])
	end

end

function Skinner:ChatMenus()
	if not self.db.profile.ChatMenus or self.initialized.ChatMenus then return end
	self.initialized.ChatMenus = true

	self:storeAndSkin(ftype, ChatMenu)
	self:storeAndSkin(ftype, EmoteMenu)
	self:storeAndSkin(ftype, LanguageMenu)
	self:storeAndSkin(ftype, VoiceMacroMenu)
	self:Hook(ChatMenu, "SetBackdropColor", function() end, true)

end

function Skinner:ChatTabs()
	if not self.db.profile.ChatTabs or self.initialized.ChatTabs then return end
	self.initialized.ChatTabs = true

	if self.db.profile.TexturedTab then
		self:SecureHook("FCF_SetTabPosition", function(chatFrame, x)
--		self:Debug("FCF_SetTabPosition: [%s, %s]", chatFrame:GetName(), x)
		self:moveObject(_G[chatFrame:GetName().."Tab"], nil, nil, "-", 4)
	end)

		for i = 1, NUM_CHAT_WINDOWS do
			local tabName = _G["ChatFrame"..i.."Tab"]
			self:keepRegions(tabName, {4, 5}) --N.B. region 4 is text, 5 is highlight
			self:moveObject(tabName, nil, nil, "-", 4)
			self:moveObject(_G[tabName:GetName().."Flash"], nil, nil, "+", 4)
			local textObj
			-- move text and highlight area and resize highlight
			self:moveObject(self:getRegion(tabName, 4), "+", 5, "+", 4)
			textObj = self:getRegion(tabName, 4)
			self:moveObject(self:getRegion(tabName, 5), "+", 5, "+", 5)
			self:getRegion(tabName, 5):SetWidth(textObj:GetWidth()  + 30)
			self:storeAndSkin(ftype, tabName, nil, 0)
			self:setActiveTab(tabName)
		end
	else
		for i=1, NUM_CHAT_WINDOWS do
			local tabName = _G["ChatFrame"..i.."Tab"]
			self:keepRegions(tabName, {4, 5}) --N.B. region 4 is text, 5 is highlight
			self:addSkinFrame(tabName, 0, -8, 0, -5, ftype)
			tabName.skinFrame:SetFrameLevel(0)
		end
	end

end

function Skinner:ChatFrames()
	if not self.db.profile.ChatFrames or self.initialized.ChatFrames then return end
	self.initialized.ChatFrames = true

	self:SecureHook("FCF_StopResize", function()
--		self:Debug("FCF_StopResize: [%s, %s]", this:GetName(), this:GetParent():GetName())
		local frame = _G["Skinner"..this:GetParent():GetName()]
		if frame and frame.tfade then frame.tfade:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", -4, -math.ceil(frame:GetHeight())) end
		end)

	local clqbf = CombatLogQuickButtonFrame_Custom
	local xOfs1, yOfs1, xOfs2, yOfs2 = -4, nil, 4, -8
	for i=1, NUM_CHAT_WINDOWS do
		local cf = (_G["ChatFrame"..i])
		local cfName = (_G["ChatFrame"..i]:GetName())
		if SIMPLE_CHAT ~= "1" and CHAT_LOCKED ~= "1" and cfName == "ChatFrame2" and clqbf:IsShown() then
			yOfs1 = 31
		else
			yOfs1 = 4
		end
		self:addSkinFrame(cf, xOfs1, yOfs1, xOfs2, yOfs2, ftype)
		-- make sure chat frame is above the bottomframe
		cf.skinFrame:SetFrameLevel(1)
	end

	-- CombatLog Quick Button Frame & Progress Bar
	if SIMPLE_CHAT ~= "1" and CHAT_LOCKED ~= "1" and self.db.profile.CombatLogQBF then
		if clqbf then
			self:keepFontStrings(clqbf)
			self:storeAndSkin(ftype, clqbf)
			clqbf:SetHeight(clqbf:GetHeight() + 4)
--			clqbf:SetWidth(clqbf:GetWidth() + 4)
		end
		self:glazeStatusBar(CombatLogQuickButtonFrameProgressBar, 0)
	end

end

function Skinner:ChatConfig()
	if not self.db.profile.ChatConfig or self.initialized.ChatConfig then return end
	self.initialized.ChatConfig = true

	self:storeAndSkin(ftype, ChatConfigCategoryFrame)
	self:storeAndSkin(ftype, ChatConfigBackgroundFrame)
	self:storeAndSkin(ftype, ChatConfigFrame, true)

-->>--	Chat Settings
	for i = 1, #CHAT_CONFIG_CHAT_LEFT do
		self:storeAndSkin(ftype, _G["ChatConfigChatSettingsLeftCheckBox"..i])
	end
	self:storeAndSkin(ftype, ChatConfigChatSettingsLeft)
	for i = 1, #CHAT_CONFIG_CHAT_RIGHT do
		self:storeAndSkin(ftype, _G["ChatConfigChatSettingsRightCheckBox"..i])
	end
	self:storeAndSkin(ftype, ChatConfigChatSettingsRight)
	for i = 1, #CHAT_CONFIG_CHAT_CREATURE_LEFT do
		self:storeAndSkin(ftype, _G["ChatConfigChatSettingsCreatureLeftCheckBox"..i])
	end
	self:storeAndSkin(ftype, ChatConfigChatSettingsCreatureLeft)

-->>--	Channel Settings
	self:SecureHook(ChatConfigChannelSettings, "Show", function(this)
		for i = 1, #ChatConfigChannelSettingsLeft.checkBoxTable do
			local cccslcb = _G["ChatConfigChannelSettingsLeftCheckBox"..i]
			if not cccslcb.skinned then
				self:storeAndSkin(ftype, cccslcb)
				cccslcb.skinned = true
			end
		end
	end)
	self:storeAndSkin(ftype, ChatConfigChannelSettingsLeft)

-->>--	Other Settings
	for i = 1, #CHAT_CONFIG_OTHER_COMBAT do
		self:storeAndSkin(ftype, _G["ChatConfigOtherSettingsCombatCheckBox"..i])
	end
	self:storeAndSkin(ftype, ChatConfigOtherSettingsCombat)
	for i = 1, #CHAT_CONFIG_OTHER_PVP do
		self:storeAndSkin(ftype, _G["ChatConfigOtherSettingsPVPCheckBox"..i])
	end
	self:storeAndSkin(ftype, ChatConfigOtherSettingsPVP)
	for i = 1, #CHAT_CONFIG_OTHER_SYSTEM do
		self:storeAndSkin(ftype, _G["ChatConfigOtherSettingsSystemCheckBox"..i])
	end
	self:storeAndSkin(ftype, ChatConfigOtherSettingsSystem)

-->>--	Combat Settings
	-- Filters
	ChatConfigCombatSettingsFiltersScrollFrameScrollBarBorder:Hide()
	self:skinScrollBar(ChatConfigCombatSettingsFiltersScrollFrame)
	self:storeAndSkin(ftype, ChatConfigCombatSettingsFilters)
	-- Message Sources
	if COMBAT_CONFIG_MESSAGESOURCES_BY then
		for i = 1, #COMBAT_CONFIG_MESSAGESOURCES_BY do
			self:storeAndSkin(ftype, _G["CombatConfigMessageSourcesDoneByCheckBox"..i])
		end
		self:storeAndSkin(ftype, CombatConfigMessageSourcesDoneBy)
	end
	if COMBAT_CONFIG_MESSAGESOURCES_TO then
		for i = 1, #COMBAT_CONFIG_MESSAGESOURCES_TO do
			self:storeAndSkin(ftype, _G["CombatConfigMessageSourcesDoneToCheckBox"..i])
		end
		self:storeAndSkin(ftype, CombatConfigMessageSourcesDoneTo)
	end
	-- Colors
	for i = 1, #COMBAT_CONFIG_UNIT_COLORS do
		self:storeAndSkin(ftype, _G["CombatConfigColorsUnitColorsSwatch"..i])
	end
	self:storeAndSkin(ftype, CombatConfigColorsUnitColors)
	self:storeAndSkin(ftype, CombatConfigColorsHighlighting)
	self:storeAndSkin(ftype, CombatConfigColorsColorizeUnitName)
	self:storeAndSkin(ftype, CombatConfigColorsColorizeSpellNames)
	self:storeAndSkin(ftype, CombatConfigColorsColorizeDamageNumber)
	self:storeAndSkin(ftype, CombatConfigColorsColorizeDamageSchool)
	self:storeAndSkin(ftype, CombatConfigColorsColorizeEntireLine)
	-- Settings
	self:skinEditBox(CombatConfigSettingsNameEditBox , {9})
	-- Tabs
	for i = 1, #COMBAT_CONFIG_TABS do
		local tabName = _G["CombatConfigTab"..i]
		local tabText = _G["CombatConfigTab"..i.."Text"]
		local tabHighlight = self:getRegion(tabName, 5)
		self:keepRegions(tabName, {4, 5}) -- N.B. region 4 is the Text, 5 is the highlight
		self:moveObject(tabText, nil, nil, "+", 5)
		self:moveObject(tabHighlight, "+", 5, "+", 7)
		tabHighlight:SetWidth(tabText:GetWidth() + 20)
		self:storeAndSkin(ftype, tabName)
	end
	self:moveObject(CombatConfigTab1, "+", 4, "-", 4)

end

function Skinner:ChatEditBox()
	-- don't use an initialized value to allow for dynamic changes
	if not self.db.profile.ChatEditBox.skin then return end

	-- this addon replaces the Chat Edit Box
	if IsAddOnLoaded("NeonChat") or IsAddOnLoaded("Chatter") then return end

	if self.db.profile.ChatEditBox.style == 1 then
		self:keepRegions(ChatFrameEditBox, self.ebRegions)
		self:storeAndSkin(ftype, ChatFrameEditBox)
	else
		self:skinEditBox(ChatFrameEditBox, nil, nil, true)
	end

end

function Skinner:LootFrame()
	if not self.db.profile.LootFrame or self.initialized.LootFrame then return end
	self.initialized.LootFrame = true

	self:Hook("LootFrame_OnShow", function(this)
		self.hooks.LootFrame_OnShow(this)
--		self:Debug("LF_OS: [%s, %s]", this, this:GetName())
		if ( LOOT_UNDER_MOUSE == "1" ) then
			-- position loot window under mouse cursor
			local x, y = GetCursorPosition()
			x = x / this:GetEffectiveScale()
			y = y / this:GetEffectiveScale()

			local posX = x - 175
			local posY = y + 25

			if (this.numLootItems > 0) then
				posX = x - 30
				posY = y + 10
				posY = posY + 40
			end

			this:ClearAllPoints()
			this:SetPoint("TOPLEFT", nil, "BOTTOMLEFT", posX, posY)
		end
		end, true)

	self:keepFontStrings(LootFrame)
	LootFrame:SetWidth(LootFrame:GetWidth() * 0.66)
	LootFrame:SetHeight(LootFrame:GetHeight() * self.FyMult)
	self:moveObject(self:getRegion(LootFrame, 3), "+", 15, "-", 4) -- region 3 is the title
	self:moveObject(LootCloseButton, "+", 65, "+", 10)
	self:moveObject(LootButton1, "-", 13, "+", 50)
	self:moveObject(LootFramePrev, "-", 15, "-", 15)
	self:moveObject(LootFrameNext, "-", 10, "-", 15)
	self:moveObject(LootFrameUpButton, "-", 20, "-", 15)
	self:moveObject(LootFrameDownButton, "-", 10, "-", 15)
	self:storeAndSkin(ftype, LootFrame)

--	These are used by FramesResized
	self.LFHeight = math.floor(LootFrame:GetHeight())
	_, _, _, self.LFxOfs, self.LFyOfs = self:getRegion(LootFrame, 3):GetPoint()

end

function Skinner:GroupLoot()
	if not self.db.profile.GroupLoot.skin or self.initialized.GroupLoot then return end
	self.initialized.GroupLoot = true

	self:Hook("GroupLootFrame_OnShow", function()
		local texture, name, count, quality, bindOnPickUp = GetLootRollItemInfo(this.rollID)
		_G["GroupLootFrame"..this:GetID().."IconFrameIcon"]:SetTexture(texture)
		_G["GroupLootFrame"..this:GetID().."Name"]:SetText(name)
		local color = ITEM_QUALITY_COLORS[quality]
		_G["GroupLootFrame"..this:GetID().."Name"]:SetVertexColor(color.r, color.g, color.b)
		_G["GroupLootFrame"..this:GetID().."Timer"]:SetStatusBarColor(color.r, color.g, color.b)
		end, true)

	self:skinDropDown(GroupLootDropDown)
	local f = GameFontNormalSmall:GetFont()

	for i = 1, NUM_GROUP_LOOT_FRAMES do

		local glf = "GroupLootFrame"..i
		self:keepFontStrings(_G[glf])

		if self.db.profile.GroupLoot.size == 1 then

			_G[glf]:SetWidth(_G[glf]:GetWidth() * 0.95)
			_G[glf]:SetHeight(_G[glf]:GetHeight() * self.FyMult)

			self:moveObject(_G[glf.."SlotTexture"], "-", 3, "+", 5)
			self:moveObject(_G[glf.."RollButton"], "+", 6, "+", 6)

		elseif self.db.profile.GroupLoot.size == 2 then

			_G[glf]:SetWidth(_G[glf]:GetWidth() * 0.78)
			_G[glf]:SetHeight(_G[glf]:GetHeight() * 0.65)

			local xMult, yMult = 0.75, 0.75
			_G[glf.."SlotTexture"]:SetWidth(_G[glf.."SlotTexture"]:GetWidth() * xMult)
			_G[glf.."SlotTexture"]:SetHeight(_G[glf.."SlotTexture"]:GetHeight() * yMult)
			self:moveObject(_G[glf.."SlotTexture"], "-", 2, "+", 4)
			_G[glf.."NameFrame"]:SetWidth(_G[glf.."NameFrame"]:GetWidth() - 15)
			_G[glf.."NameFrame"]:SetHeight(_G[glf.."NameFrame"]:GetHeight() * yMult)
			self:moveObject(_G[glf.."NameFrame"], "+", 2, "+", 2)
			_G[glf.."Name"]:SetFont(f, 7)
			self:moveObject(_G[glf.."Name"], "+", 3, "-", 4)
			_G[glf.."PassButton"]:SetWidth(_G[glf.."PassButton"]:GetWidth() * xMult)
			_G[glf.."PassButton"]:SetHeight(_G[glf.."PassButton"]:GetHeight() * yMult)
			self:moveObject(_G[glf.."PassButton"], nil, nil, "+", 3)
			_G[glf.."RollButton"]:SetWidth(_G[glf.."RollButton"]:GetWidth() * xMult)
			_G[glf.."RollButton"]:SetHeight(_G[glf.."RollButton"]:GetHeight() * yMult)
			self:moveObject(_G[glf.."RollButton"], "+", 13, "+", 7)
			_G[glf.."GreedButton"]:SetWidth(_G[glf.."GreedButton"]:GetWidth() * xMult)
			_G[glf.."GreedButton"]:SetHeight(_G[glf.."GreedButton"]:GetHeight() * yMult)
			_G[glf.."IconFrame"]:SetWidth(_G[glf.."IconFrame"]:GetWidth() * xMult)
			_G[glf.."IconFrame"]:SetHeight(_G[glf.."IconFrame"]:GetHeight() * yMult)
			_G[glf.."IconFrameIcon"]:SetWidth(_G[glf.."IconFrameIcon"]:GetWidth() * 0.8)
			_G[glf.."IconFrameIcon"]:SetHeight(_G[glf.."IconFrameIcon"]:GetHeight() * 0.8)
			_G[glf.."IconFrameIcon"]:SetAlpha(1)
			self:moveObject(_G[glf.."IconFrameIcon"], "-", 5, "+", 5)
			_G[glf.."Timer"]:SetWidth(_G[glf.."Timer"]:GetWidth() * xMult)
			_G[glf.."Timer"]:SetHeight(_G[glf.."Timer"]:GetHeight() * yMult)
			self:moveObject(_G[glf.."Timer"], "-", 2, "-", 3)

		elseif self.db.profile.GroupLoot.size == 3 then

			_G[glf]:SetWidth(_G[glf]:GetWidth() * 0.35)
			_G[glf]:SetHeight(_G[glf]:GetHeight() * 0.65)

			local xMult, yMult = 0.75, 0.75
			_G[glf.."SlotTexture"]:SetWidth(_G[glf.."SlotTexture"]:GetWidth() * xMult)
			_G[glf.."SlotTexture"]:SetHeight(_G[glf.."SlotTexture"]:GetHeight() * yMult)
			self:moveObject(_G[glf.."SlotTexture"], "-", 5, "+", 5)
			_G[glf.."NameFrame"]:Hide()
			_G[glf.."Name"]:Hide()
			_G[glf.."PassButton"]:SetWidth(_G[glf.."PassButton"]:GetWidth() * xMult)
			_G[glf.."PassButton"]:SetHeight(_G[glf.."PassButton"]:GetHeight() * yMult)
			_G[glf.."RollButton"]:SetWidth(_G[glf.."RollButton"]:GetWidth() * xMult)
			_G[glf.."RollButton"]:SetHeight(_G[glf.."RollButton"]:GetHeight() * yMult)
			self:moveObject(_G[glf.."RollButton"], "+", 15, "+", 10)
			_G[glf.."GreedButton"]:SetWidth(_G[glf.."GreedButton"]:GetWidth() * xMult)
			_G[glf.."GreedButton"]:SetHeight(_G[glf.."GreedButton"]:GetHeight() * yMult)
			self:moveObject(_G[glf.."GreedButton"], nil, nil, "+", 3)
			_G[glf.."IconFrame"]:SetWidth(_G[glf.."IconFrame"]:GetWidth() * xMult)
			_G[glf.."IconFrame"]:SetHeight(_G[glf.."IconFrame"]:GetHeight() * yMult)
			self:moveObject(_G[glf.."IconFrame"], "-", 5, "+", 5)
			_G[glf.."IconFrameIcon"]:SetWidth(_G[glf.."IconFrameIcon"]:GetWidth() * xMult + 2)
			_G[glf.."IconFrameIcon"]:SetHeight(_G[glf.."IconFrameIcon"]:GetHeight() * yMult + 2)
			_G[glf.."IconFrameIcon"]:SetAlpha(1)
			_G[glf.."Timer"]:SetWidth(_G[glf.."Timer"]:GetWidth() * 0.35)
			_G[glf.."Timer"]:SetHeight(_G[glf.."Timer"]:GetHeight() * yMult)
			self:moveObject(_G[glf.."Timer"], "-", 2, "-", 4)

		end

		self:removeRegions(_G[glf.."Timer"], {1})
		self:glazeStatusBar(_G[glf.."Timer"], 0)

		self:storeAndSkin(ftype, _G[glf])
	end

end

function Skinner:ContainerFrames()
	if not self.db.profile.ContainerFrames.skin or self.initialized.ContainerFrames then return end
	self.initialized.ContainerFrames = true

	if self.isWotLK then BACKPACK_HEIGHT = BACKPACK_HEIGHT - 26 end
	
	self:SecureHook("ContainerFrame_GenerateFrame", function(frameObj, size, id)
--		self:Debug("CF_GF:[%s, %s, %s]", frameObj:GetName(), size, id)
		local frameName = _G[frameObj:GetName().."Name"]
		if ( id > NUM_BAG_FRAMES ) then
			frameName:SetTextColor(.3, .3, 1)
		elseif ( id == KEYRING_CONTAINER ) then
			frameName:SetTextColor(1, .7, 0)
		else
			frameName:SetTextColor(1, 1, 1)
		end
		self:shrinkBag(frameObj, true)
	end)

	for i = 1, NUM_CONTAINER_FRAMES do
		local frameObj = _G["ContainerFrame"..i]
		local frameName = _G["ContainerFrame"..i.."Name"]
		self:keepFontStrings(frameObj)
		frameName:SetWidth(145)
		self:moveObject(frameName, "-", 40, nil, nil)
		local CFfh = self.db.profile.ContainerFrames.fheight <= math.ceil(frameObj:GetHeight()) and self.db.profile.ContainerFrames.fheight or math.ceil(frameObj:GetHeight())
		self:storeAndSkin(ftype, frameObj, nil, nil, nil, CFfh)
		self:shrinkBag(frameObj, true)
	end

end

function Skinner:StackSplit()
	if not self.db.profile.StackSplit or self.initialized.StackSplit then return end
	self.initialized.StackSplit = true

	self:keepFontStrings(StackSplitFrame)
	StackSplitFrame:SetWidth(StackSplitFrame:GetWidth() - 12)
	StackSplitFrame:SetHeight(StackSplitFrame:GetHeight() - 28)
	self:moveObject(StackSplitText, nil, nil, "-", 5)
	self:moveObject(StackSplitLeftButton, "+", 5, "-", 5)
	self:moveObject(StackSplitRightButton, "-", 5, "-", 5)
	self:moveObject(StackSplitOkayButton, nil, nil, "-", 13)
	self:moveObject(StackSplitCancelButton, nil, nil, "-", 13)

	self:storeAndSkin(ftype, StackSplitFrame)

end

function Skinner:ItemText()
	if not self.db.profile.ItemText or self.initialized.ItemText then return end
	self.initialized.ItemText = true

	self:SecureHook("ItemTextFrame_OnEvent", function(event)
--		self:Debug("ItemTextFrame_OnEvent: [%s]", event)
		if event == "ITEM_TEXT_BEGIN" then
			ItemTextPageText:SetTextColor(self.BTr, self.BTg, self.BTb)
		end
	end)

	self:keepFontStrings(ItemTextFrame)
	ItemTextFrame:SetWidth(ItemTextFrame:GetWidth() - 30)
	ItemTextFrame:SetHeight(ItemTextFrame:GetHeight() - 60)
	self:moveObject(ItemTextTitleText, nil, nil, "-", 24)
	self:moveObject(ItemTextScrollFrame, "+", 30, "+", 20)
	self:removeRegions(ItemTextScrollFrame)
	self:skinScrollBar(ItemTextScrollFrame)
	self:moveObject(ItemTextStatusBar, nil, nil, "-", 115)
	self:glazeStatusBar(ItemTextStatusBar, 0)
	self:moveObject(ItemTextPrevPageButton, "-", 45, "+", 10)
	self:moveObject(ItemTextNextPageButton, "+", 10, "+", 10)
	self:moveObject(ItemTextCloseButton, "+", 28, "+", 8)

	self:storeAndSkin(ftype, ItemTextFrame)

end

function Skinner:ColorPicker()
	if not self.db.profile.Colours or self.initialized.Colours then return end
	self.initialized.Colours = true

	self:storeAndSkin(ftype, ColorPickerFrame, 1)
	self:storeAndSkin(ftype, OpacityFrame)

end

function Skinner:WorldMap()
	if not self.db.profile.WorldMap or self.initialized.WorldMap then return end
	self.initialized.WorldMap = true

	self:keepFontStrings(WorldMapFrame)
	self:skinDropDown(WorldMapContinentDropDown)
	self:skinDropDown(WorldMapZoneDropDown)
	self:skinDropDown(WorldMapZoneMinimapDropDown)

	if not IsAddOnLoaded("MetaMap") then
		WorldMapFrameCloseButton:ClearAllPoints()
		WorldMapFrameCloseButton:SetPoint("TOPRIGHT", WorldMapFrame, "TOPRIGHT", -2, -2)
		self:storeAndSkin(ftype, WorldMapFrame)
	end

	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then WorldMapTooltip:SetBackdrop(self.backdrop) end
		self:SecureHook(WorldMapTooltip, "Show", function()
			self:skinTooltip(WorldMapTooltip)
		end)
	end

end

function Skinner:HelpFrame()
	if not self.db.profile.HelpFrame or self.initialized.HelpFrame then return end
	self.initialized.HelpFrame = true

-->>--	Help Frame
	self:keepFontStrings(HelpFrame)
	HelpFrame:SetWidth(HelpFrame:GetWidth() - 20)
	HelpFrame:SetHeight(HelpFrame:GetHeight() * 0.90)
	self:moveObject(HelpFrameCloseButton, "+", 42, "+", 2)
	self:storeAndSkin(ftype, HelpFrame, true)

-->>--	Cancel Buttons
	self:moveObject(HelpFrameGMTalkCancel, "+", 42, "-", 12)
	self:moveObject(HelpFrameReportIssueCancel, "+", 42, "-", 12)
	self:moveObject(HelpFrameStuckCancel, "+", 42, "-", 12)

-->>--	Open Ticket Frame
	self:moveObject(HelpFrameOpenTicketLabel, nil, nil, "+", 40)
	HelpFrameOpenTicketDivider:Hide()
	self:moveObject(HelpFrameOpenTicketDivider, "+", 6, "+", 40)
	self:removeRegions(HelpFrameOpenTicketScrollFrame)
	self:skinScrollBar(HelpFrameOpenTicketScrollFrame)
	self:moveObject(HelpFrameOpenTicketCancel, "+", 42, "-", 12)

-->>--	Ticket Status Frame
	self:storeAndSkin(ftype, TicketStatusFrame)

-->>--	KnowledgeBase Frame
	self:keepFontStrings(KnowledgeBaseFrame)
	KnowledgeBaseFrame:SetWidth(HelpFrame:GetWidth())
	KnowledgeBaseFrame:SetHeight(HelpFrame:GetHeight())
	KnowledgeBaseFrameHeader:Hide()
	KnowledgeBaseFrameHeader:SetPoint("TOP", KnowledgeBaseFrame, "TOP", 0, -5)
	self:skinEditBox(KnowledgeBaseFrameEditBox)
	self:skinDropDown(KnowledgeBaseFrameCategoryDropDown)
	self:skinDropDown(KnowledgeBaseFrameSubCategoryDropDown)
	KnowledgeBaseFrameDivider:Hide()
	KnowledgeBaseFrameDivider2:Hide()
	self:moveObject(KnowledgeBaseMotdLabel, nil, nil, "+", 10)
	self:moveObject(KnowledgeBaseFrameDivider, nil, nil, "+", 30)
	self:moveObject(KnowledgeBaseFrameDivider2, nil, nil, "+", 34)
	self:removeRegions(KnowledgeBaseArticleScrollFrame)
	self:skinScrollBar(KnowledgeBaseArticleScrollFrame)
	self:moveObject(KnowledgeBaseArticleListFrameNextButton, "+", 20, nil, nil)
	self:moveObject(KnowledgeBaseFrameGMTalk, nil, nil, "-", 12)
	self:moveObject(KnowledgeBaseFrameCancel, "+", 42, "-", 12)

end

function Skinner:InspectUI()
	if not self.db.profile.Inspect or self.initialized.InspectUI then return end
	self.initialized.InspectUI = true

	self:keepFontStrings(InspectFrame)
	self:keepRegions(InspectPaperDollFrame, {5, 6, 7}) -- N.B. regions 5-7 are text
	InspectModelRotateLeftButton:Hide()
	InspectModelRotateRightButton:Hide()
	self:makeMFRotatable(InspectModelFrame)
	LowerFrameLevel(InspectModelFrame)
	InspectFrame:SetWidth(InspectFrame:GetWidth() * self.FxMult)
	InspectFrame:SetHeight(InspectFrame:GetHeight() * self.FyMult)
	self:moveObject(InspectFrameCloseButton, "+", 28, "+", 8)
	self:moveObject(InspectNameText, nil, nil, "-", 32)
	self:moveObject(InspectModelFrame, nil, nil, "+", 20)
	self:moveObject(InspectHeadSlot, nil, nil, "+", 20)
	self:moveObject(InspectHandsSlot, "-", 15, "+", 20)
	self:moveObject(InspectMainHandSlot, nil, nil, "-", 38)

-->>--	PVP Frame
	self:keepFontStrings(InspectPVPFrame)
	self:moveObject(InspectPVPTeam1Standard, "-", 10, "+", 10)
	self:moveObject(InspectPVPTeam2Standard, "-", 10, "+", 10)
	self:moveObject(InspectPVPTeam3Standard, "-", 10, "+", 10)

-->>--	Talent Frame
	self:keepRegions(InspectTalentFrame, {6, 7, 8, 9, 10}) -- N.B. 6, 7, 8 & 9 are the background picture, 10 is text
	InspectTalentFrameCloseButton:Hide()
	self:moveObject(InspectTalentFrameTitleText, nil, nil, "+", 6)
	self:moveObject(InspectTalentFrameBackgroundTopLeft, "-", 5, nil, nil)
	InspectTalentFrameScrollFrame:SetHeight(InspectTalentFrameScrollFrame:GetHeight() - 2)
	self:removeRegions(InspectTalentFrameScrollFrame)
	self:skinScrollBar(InspectTalentFrameScrollFrame)
	self:moveObject(InspectTalentFrameScrollFrame, "+", 35, nil, nil)
	self:moveObject(InspectTalentFrameSpentPoints, nil, nil, "-", 70)
	self:moveObject(InspectTalentFrameCancelButton, "-", 5, "-", 5)

	self:skinFFToggleTabs("InspectTalentFrameTab")

-->>--	Frame Tabs
	for i = 1, #INSPECTFRAME_SUBFRAMES do
		local tabName = _G["InspectFrameTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		if self.db.profile.TexturedTab then self:applySkin(tabName, nil, 0)
		else self:storeAndSkin(ftype, tabName) end
		if i == 1 then
			self:moveObject(tabName, nil, nil, "-", 70)
			if self.db.profile.TexturedTab then self:setActiveTab(tabName) end
		else
			self:moveObject(tabName, "+", 11, nil, nil)
			if self.db.profile.TexturedTab then self:setInactiveTab(tabName) end
		end

	end
	if self.db.profile.TexturedTab then
		-- hook to handle tabs
		self:SecureHook("InspectSwitchTabs", function(newID)
--			self:Debug("InspectSwitchTabs")
			for i = 1, #INSPECTFRAME_SUBFRAMES do
				if i == newID then
					self:setActiveTab(_G["InspectFrameTab"..i])
				else
					self:setInactiveTab(_G["InspectFrameTab"..i])
				end
			end
		end)
	end

	self:storeAndSkin(ftype, InspectFrame)

end

function Skinner:BattleScore()
	if not self.db.profile.BattleScore then return end

	self:SecureHook("WorldStateScoreFrame_Resize", function(width)
		WorldStateScoreFrame:SetWidth(WorldStateScoreFrame:GetWidth() * self.FxMult)
	end)

	self:SecureHook("WorldStateScoreFrameTab_OnClick", function(tab)
		self:setInactiveTab(WorldStateScoreFrameTab1)
		self:setInactiveTab(WorldStateScoreFrameTab2)
		self:setInactiveTab(WorldStateScoreFrameTab3)
		self:setActiveTab(tab)
	end)

	WorldStateScoreFrame:SetHeight(WorldStateScoreFrame:GetHeight() * self.FyMult)
	self:keepFontStrings(WorldStateScoreFrame)
	self:removeRegions(WorldStateScoreScrollFrame)
	self:skinScrollBar(WorldStateScoreScrollFrame)
	self:moveObject(WorldStateScoreScrollFrame, "+", 116, "+", 12)
	self:moveObject(WorldStateScoreFrameCloseButton, "+", 110, "+", 10)
	self:moveObject(WorldStateScoreFrameLeaveButton, "+", 30, "-", 65)
	self:moveObject(WorldStateScoreFrameTimerLabel, nil, nil, "-", 65)

	-- Tabs
	for i = 1, 3 do
		local tabName = _G["WorldStateScoreFrameTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		self:moveObject(_G[tabName:GetName().."Text"], nil, nil, "-", 8)
		self:moveObject(_G[tabName:GetName().."HighlightTexture"], "-", 5, "-", 9)
		if self.db.profile.TexturedTab then self:applySkin(tabName, nil, 0, 1)
		else self:storeAndSkin(ftype, tabName) end
		if i == 1 then
			self:moveObject(tabName, nil, nil, "-", 62)
			self:setActiveTab(tabName)
		else
			self:moveObject(tabName, "+", 11, nil, nil)
			self:setInactiveTab(tabName)
		end
	end
	self:storeAndSkin(ftype, WorldStateScoreFrame)

end

function Skinner:BattlefieldMinimap()
	if not self.db.profile.BattlefieldMm then return end

--	self:Debug("BMM")

-->>--	Minimap Tab
	self:keepRegions(BattlefieldMinimapTab, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
	if self.db.profile.TexturedTab then self:applySkin(BattlefieldMinimapTab, nil, 0, 1)
	else self:storeAndSkin(ftype, BattlefieldMinimapTab) end
	self:moveObject(BattlefieldMinimapTabText, nil, nil, "+", 4)

	-->>--	Minimap
	-- change the draw layer so that the map is visible
	for i = 1, 12 do
		_G["BattlefieldMinimap"..i]:SetDrawLayer("OVERLAY")
	end

	-- Create a frame to skin as using the BattlefieldMinimap one causes issues with Capping
	local skinFrame = CreateFrame("Frame", nil, BattlefieldMinimap)

	skinFrame:SetFrameStrata(BattlefieldMinimap:GetFrameStrata())
	skinFrame:SetFrameLevel(BattlefieldMinimap:GetFrameLevel())
	skinFrame:SetHeight(BattlefieldMinimap:GetHeight() + 6)
	skinFrame:SetWidth(BattlefieldMinimap:GetWidth() + 2)
	skinFrame:ClearAllPoints()
	skinFrame:SetPoint("TOPLEFT", BattlefieldMinimap, "TOPLEFT", 0, 0)
	self:storeAndSkin(ftype, skinFrame)

	BattlefieldMinimap.skinFrame = skinFrame
	BattlefieldMinimapCorner:Hide()
	BattlefieldMinimapBackground:Hide()

	if IsAddOnLoaded("Capping") then
		if type(self["Capping_ModMap"]) == "function" then self:Capping_ModMap() end
	else
		skinFrame:ClearAllPoints()
		skinFrame:SetPoint("TOPLEFT", BattlefieldMinimapTab, "BOTTOMLEFT", 0, 6)
		self:moveObject(BattlefieldMinimap1, "+", 4, "+", 6)
		self:moveObject(BattlefieldMinimapCloseButton, "+", 5, "+", 8)
	end

end

function Skinner:ScriptErrors()
	if not self.db.profile.ScriptErrors then return end

--	Skin the ScriptErrors Frame
	self:storeAndSkin(ftype, ScriptErrors)

end

function Skinner:Tutorial()
	if not self.db.profile.Tutorial then return end

--	Skin the TutorialFrame Frame
	self:storeAndSkin(ftype, TutorialFrame)

end

function Skinner:DropDowns()
	if not self.db.profile.DropDowns or self.initialized.DropDowns then return end
	self.initialized.DropDowns = true

	self:SecureHook("UIDropDownMenu_CreateFrames", function(level, index)
--		self:Debug("UIDDM_CF: [%s, %s]", level, index)
		for i = 1, UIDROPDOWNMENU_MAXLEVELS do
			local ddFrame = "DropDownList"..i
			if not self:IsHooked(_G[ddFrame], "Show") then
--				self:Debug("DD's: [%s, %s]", i, UIDROPDOWNMENU_MAXLEVELS)
				self:SecureHook(_G[ddFrame], "Show", function()
					self:keepFontStrings(_G[ddFrame])
					_G[ddFrame.."Backdrop"]:Hide()
					_G[ddFrame.."MenuBackdrop"]:Hide()
					self:storeAndSkin(ftype, _G[ddFrame])
					end)
			end
		end
	end)

end

function Skinner:MinimapButtons()
	if not self.db.profile.MinimapButtons or self.initialized.MinimapButtons then return end
	self.initialized.MinimapButtons = true

	local function mmKids(mmObj)

		local mmObjName = mmObj:GetName()
--		self:Debug("Checking %s kids", mmObjName)

		for i = 1, select("#", mmObj:GetChildren()) do
			local obj = select(i, mmObj:GetChildren())
			local objName = obj:GetName()
			local objType = obj:GetObjectType()
--			self:Debug("%s kids: [%s, %s, %s]", mmObjName, obj, objName, objType)
			if not obj.skinned and objName
			and (objType == "Button" or objType == "Frame" and objName == "MiniMapMailFrame") then
				for i = 1, select("#", obj:GetRegions()) do
					local reg = select(i, obj:GetRegions())
					if reg:GetObjectType() == "Texture" then
						local regName = reg:GetName()
						local regTex = reg:GetTexture()
						local regDL = reg:GetDrawLayer()
--						self:Debug("%s obj: [%s, %s, %s]", mmObjName, objName, regName, regTex)
						-- change the DrawLayer to make the Icon show if required
						if (regName and string.find(regName, "Icon"))
						or (regTex and string.find(regTex, "Icon")) then
--							self:Debug("%s obj Icon: [%s, %s, %s]", mmObjName, objName, regName, regDL)
							if regDL == "BACKGROUND" then reg:SetDrawLayer("ARTWORK") end
							-- centre the icon
							reg:ClearAllPoints()
							reg:SetPoint("CENTER")
						elseif (regName and string.find(regName, "Border"))
						or (regTex and string.find(regTex, "TrackingBorder")) then
--							self:Debug("%s obj skinned: [%s, %s, %s]", mmObjName, obj:GetName(), math.ceil(obj:GetWidth()), math.ceil(obj:GetHeight()))
							reg:SetTexture(nil)
							obj:SetWidth(32)
							obj:SetHeight(32)
							Skinner:storeAndSkin(ftype, obj)
							obj.skinned = true
							break
						end
					end
				end
			elseif objName and objType == "Frame" then
				mmKids(obj)
			end
		end

	end

	mmKids(Minimap)

	-- skin other Blizzard buttons
	self:applySkin(GameTimeFrame)
	self:applySkin(MinimapZoomIn)
	self:applySkin(MinimapZoomOut)
	-- resize other buttons
	GameTimeFrame:SetWidth(36)
	GameTimeFrame:SetHeight(36)
	MiniMapVoiceChatFrame:SetWidth(32)
	MiniMapVoiceChatFrame:SetHeight(32)
	MiniMapVoiceChatFrameIcon:ClearAllPoints()
	MiniMapVoiceChatFrameIcon:SetPoint("CENTER")
	if self.isWotLK then
		self:moveObject(MiniMapTrackingIcon, "-", 2, "+", 2)
		LowerFrameLevel(MiniMapTrackingButton)
	end
	
	-- skin any moved Minimap buttons if required
	if IsAddOnLoaded("MinimapButtonFrame") then mmKids(MinimapButtonFrame) end

	-- show the Bongos minimap icon if required
	if IsAddOnLoaded("Bongos") then Bongos3MinimapButton.icon:SetDrawLayer("ARTWORK") end

	-- skin other minimap buttons as required
	if IsAddOnLoaded("SmartBuff") then self:applySkin(SmartBuff_MiniMapButton) end
	if IsAddOnLoaded("WebDKP") then self:applySkin(WebDKP_MinimapButton) end
	if IsAddOnLoaded("Perl_Config") then self:applySkin(Perl_Config_ButtonFrame) end
	if IsAddOnLoaded("GuildAds") then self:applySkin(GuildAdsMinimapButton) end
	if IsAddOnLoaded("Outfitter") then self:applySkin(OutfitterMinimapButton) end
	if IsAddOnLoaded("WIM") then self:applySkin(WIM_IconFrame) end

end

function Skinner:MovieProgress()
	if not self.db.profile.MovieProgress or self.initialized.MovieProgress then return end
	self.initialized.MovieProgress = true

	self:SecureHook(MovieProgressFrame, "Show", function(this)
		self:getChild(MovieProgressBar, 1):SetBackdrop(nil)
		self:keepFontStrings(MovieProgressFrame)
		self:glazeStatusBar(MovieProgressBar, 0)
		self:Unhook(MovieProgressFrame, "Show")
	end)

end

function Skinner:TimeManager()
	if not self.db.profile.TimeManager or self.initialized.TimeManager then return end
	self.initialized.TimeManager = true

-->>--	Time Manager Frame
	TimeManagerFrame:SetWidth(200)
	TimeManagerFrame:ClearAllPoints()
	TimeManagerFrame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", 0, -170)
	self:keepFontStrings(TimeManagerFrame)
	self:moveObject(self:getRegion(TimeManagerFrame, 7), nil, nil, "+", 6)
	self:moveObject(TimeManagerCloseButton, "+", 45, "+", 8)
	TimeManagerFrameTicker:Hide()
	self:keepFontStrings(TimeManagerStopwatchFrame)
	self:moveObject(TimeManagerStopwatchFrame, "+", 40, nil, nil)
	self:moveObject(TimeManagerAlarmMessageFrame, "-", 14, nil, nil)
	self:skinDropDown(TimeManagerAlarmHourDropDown)
	TimeManagerAlarmHourDropDownMiddle:SetWidth(TimeManagerAlarmHourDropDownMiddle:GetWidth() + 10)
	self:skinDropDown(TimeManagerAlarmMinuteDropDown)
	TimeManagerAlarmMinuteDropDownMiddle:SetWidth(TimeManagerAlarmMinuteDropDownMiddle:GetWidth() + 10)
	self:skinDropDown(TimeManagerAlarmAMPMDropDown)
	self:skinEditBox(TimeManagerAlarmMessageEditBox, {9})
	self:moveObject(TimeManagerAlarmEnabledButton, "+", 20, nil, nil)
	self:applySkin(TimeManagerFrame)
	self:HookScript(TimeManagerAlarmAMPMDropDown, "OnShow", function() end, true)
	self:HookScript(TimeManagerAlarmAMPMDropDown, "OnHide", function() end, true)

-->>--	Time Manager Clock Button
	TimeManagerClockButton:SetWidth(36)
	TimeManagerClockButton:SetHeight(18)
	self:removeRegions(TimeManagerClockButton, {1})
	self:applySkin(TimeManagerClockButton)

-->>--	Stopwatch Frame
	StopwatchFrame:SetWidth(130)
	StopwatchFrame:SetHeight(26)
	self:keepFontStrings(StopwatchFrame)
	self:moveObject(StopwatchTicker, "-", 5, nil, nil)
	self:moveObject(StopwatchResetButton, "-", 5, nil, nil)
	self:applySkin(StopwatchFrame)
	self:keepFontStrings(StopwatchTabFrame)
	self:moveObject(StopwatchTabFrame, "-", 1, "+", 20)
	self:moveObject(StopwatchCloseButton, "-", 5, "-", 10)
	self:moveObject(StopwatchTitle, "-", 3, "-", 10)

end

function Skinner:Calendar()
	if not self.db.profile.Calendar or self.initialized.Calendar then return end
	self.initialized.Calendar = true

-->>--	Calendar Frame
	
	self:keepFontStrings(CalendarFrame)
	self:keepFontStrings(CalendarFilterFrame)
	CalendarFilterFrameMiddle:SetTexture(self.LSM:Fetch("background", "Inactive Tab"))
	CalendarFilterFrameMiddle:SetHeight(16)
	CalendarFilterFrameMiddle:SetAlpha(1)
	self:moveObject(CalendarCloseButton, "-", 1, "+", 17)
	self:storeAndSkin(ftype, CalendarFrame)

-->>-- View Holiday Frame
	self:keepFontStrings(CalendarViewHolidayTitleFrame)
	self:keepFontStrings(CalendarViewHolidayFrame)
	self:removeRegions(CalendarViewHolidayCloseButton, {4})
	self:removeRegions(CalendarViewHolidayScrollFrame)
	self:skinScrollBar(CalendarViewHolidayScrollFrame)
	self:storeAndSkin(ftype, CalendarViewHolidayFrame)
	
-->>-- View Raid Frame
	self:keepFontStrings(CalendarViewRaidTitleFrame)
	self:keepFontStrings(CalendarViewRaidFrame)
	self:removeRegions(CalendarViewRaidCloseButton, {4})
	self:removeRegions(CalendarViewRaidScrollFrame)
	self:skinScrollBar(CalendarViewRaidScrollFrame)
	self:storeAndSkin(ftype, CalendarViewRaidFrame)
	
-->>-- View Event Frame
	self:keepFontStrings(CalendarViewEventTitleFrame)
	self:keepFontStrings(CalendarViewEventFrame)
	self:removeRegions(CalendarViewEventCloseButton, {4})
	self:applySkin(CalendarViewEventDescriptionContainer)
	self:removeRegions(CalendarViewEventDescriptionScrollFrame)
	self:skinScrollBar(CalendarViewEventDescriptionScrollFrame)
	self:keepFontStrings(CalendarViewEventInviteListSection)
	self:storeAndSkin(ftype, CalendarViewEventFrame)
	
-->>-- Create Event Frame
	self:keepFontStrings(CalendarCreateEventTitleFrame)
	self:keepFontStrings(CalendarCreateEventFrame)
	self:removeRegions(CalendarCreateEventCloseButton, {4})
	self:skinEditBox(CalendarCreateEventTitleEdit, {9})
	self:skinDropDown(CalendarCreateEventTypeDropDown)
	self:skinDropDown(CalendarCreateEventHourDropDown)
	CalendarCreateEventHourDropDownMiddle:SetWidth(CalendarCreateEventHourDropDownMiddle:GetWidth() + 5)
	self:skinDropDown(CalendarCreateEventMinuteDropDown)
	CalendarCreateEventMinuteDropDownMiddle:SetWidth(CalendarCreateEventMinuteDropDownMiddle:GetWidth() + 5)
	self:skinDropDown(CalendarCreateEventAMPMDropDown)
	self:skinDropDown(CalendarCreateEventRepeatOptionDropDown)
	self:storeAndSkin(ftype, CalendarCreateEventDescriptionContainer)
	self:removeRegions(CalendarCreateEventDescriptionScrollFrame)
	self:skinScrollBar(CalendarCreateEventDescriptionScrollFrame)
	self:keepFontStrings(CalendarCreateEventInviteListSection)
	self:storeAndSkin(ftype, CalendarCreateEventInviteList)
	self:skinEditBox(CalendarCreateEventInviteEdit, {9})
	CalendarCreateEventMassInviteButtonBorder:SetAlpha(0)
	-- TODO Fix this to be skinned properly when in a raid
	if CalendarCreateEventRaidInviteButtonBorder then CalendarCreateEventRaidInviteButtonBorder:SetAlpha(0) end
	CalendarCreateEventCreateButtonBorder:SetAlpha(0)
	self:storeAndSkin(ftype, CalendarCreateEventFrame)
	
	
-->>-- Mass Invite Frame
	self:keepFontStrings(CalendarMassInviteTitleFrame)
	self:keepFontStrings(CalendarMassInviteFrame)
	self:removeRegions(CalendarMassInviteCloseButton, {4})
	self:skinEditBox(CalendarMassInviteGuildMinLevelEdit, {9})
	self:skinEditBox(CalendarMassInviteGuildMaxLevelEdit, {9})
	self:skinDropDown(CalendarMassInviteGuildRankMenu)
	self:storeAndSkin(ftype, CalendarMassInviteFrame)
	
-->>-- Event Picker Frame
	self:keepFontStrings(CalendarEventPickerTitleFrame)
	self:keepFontStrings(CalendarEventPickerFrame)
	self:skinHybridScrollBar(CalendarEventPickerScrollBar)
	self:removeRegions(CalendarEventPickerCloseButton, {7})
	self:moveObject(CalendarEventPickerCloseButton, nil, nil, "-", 4)
	self:storeAndSkin(ftype, CalendarEventPickerFrame)

-->>-- Texture Picker Frame
	self:keepFontStrings(CalendarTexturePickerTitleFrame)
	self:keepFontStrings(CalendarTexturePickerFrame)
	self:skinHybridScrollBar(CalendarTexturePickerScrollBar)
	CalendarTexturePickerCancelButtonBorder:SetAlpha(0)
	CalendarTexturePickerAcceptButtonBorder:SetAlpha(0)
	self:storeAndSkin(ftype, CalendarTexturePickerFrame)
	
-->>-- Class Button Container
	for i = 1, MAX_CLASSES do -- allow for the total button
		self:removeRegions(_G["CalendarClassButton"..i], {1})
	end
	self:keepFontStrings(CalendarClassTotalsButton)
	CalendarClassTotalsButtonBackgroundMiddle:SetTexture(self.LSM:Fetch("background", "Inactive Tab"))
	self:moveObject(CalendarClassTotalsButtonBackgroundMiddle, "+", 2, nil, nil)
	CalendarClassTotalsButtonBackgroundMiddle:SetWidth(18)
	CalendarClassTotalsButtonBackgroundMiddle:SetHeight(18)
	CalendarClassTotalsButtonBackgroundMiddle:SetAlpha(1)

end
