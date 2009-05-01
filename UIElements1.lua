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
	local GTSBevt
	local function checkGTHeight(cHeight)

		counts = counts + 1

--		Skinner:Debug("checkGTHeight: [%s, %s, %s]", cHeight, evt, math.ceil(GameTooltip:GetHeight()))
		if cHeight ~= math.ceil(GameTooltip:GetHeight()) then
			Skinner:skinTooltip(GameTooltip)
			Skinner:CancelTimer(GTSBevt, true)
			GTSBevt = nil
			counts = 0
		end

		if counts == 10 or GameTooltipStatusBar:IsShown() then
			Skinner:CancelTimer(GTSBevt, true)
			GTSBevt = nil
			counts = 0
		end

	end

	-- Hook this to deal with GameTooltip FadeHeight issues
	self:SecureHookScript(GameTooltipStatusBar, "OnHide", function(this)
--		self:Debug("GameTooltipStatusBar_OnHide: [%s]", this:GetName())
		if GameTooltip:IsShown() then
			cHeight = math.ceil(GameTooltip:GetHeight())
--			self:Debug("GTSB_OnHide: [%s]", cHeight)
			if not GTSBevt then
				GTSBevt = self:ScheduleRepeatingTimer(checkGTHeight, 0.2, cHeight)
			end
		end
		end)

	-- MUST hook to OnShow script rather than the Show method otherwise not every tooltip is skinned properly everytime
	for _, tooltip in pairs(self.ttList) do
		local ttip = _G[tooltip]
--		self:Debug("Tooltip:[%s, %s]", tooltip, ttip)
		self:SecureHookScript(ttip, "OnShow", function(this)
--			self:Debug("Tooltip OnShow: [%s]", this:GetName())
			self:skinTooltip(this)
			if this == GameTooltip and self.db.profile.Tooltips.glazesb then
				self:glazeStatusBar(GameTooltipStatusBar, 0)
			end
			end)
	end

end

function Skinner:MirrorTimers()
	if not self.db.profile.MirrorTimers.skin or self.initialized.MirrorTimers then return end
	self.initialized.MirrorTimers = true

	for i = 1, MIRRORTIMER_NUMTIMERS do
		local mTimer = _G["MirrorTimer"..i]
		local mTimerText = _G["MirrorTimer"..i.."Text"]
		local mTimerSB = _G["MirrorTimer"..i.."StatusBar"]
		self:keepFontStrings(mTimer)
		mTimer:SetHeight(mTimer:GetHeight() * 1.2)
		mTimerSB:SetWidth(mTimerSB:GetWidth() * 0.7)
		self:moveObject(mTimerText, nil, nil, "-", 2)
		if self.db.profile.MirrorTimers.glaze then self:glazeStatusBar(mTimerSB, 0) end
	end

end

--[[
function Skinner:QuestTimers()
	if not self.db.profile.MirrorTimers or self.initialized.QuestTimers then return end
	self.initialized.QuestTimers = true

	self:keepFontStrings(QuestTimerFrame)
	QuestTimerFrame:SetWidth(QuestTimerFrame:GetWidth() - 40)
	QuestTimerFrame:SetHeight(QuestTimerFrame:GetHeight() - 20)
	self:moveObject(QuestTimerHeader, nil, nil, "-", 4)
	self:storeAndSkin(ftype, QuestTimerFrame)

end
--]]

function Skinner:CastingBar()
	if not self.db.profile.CastingBar.skin or self.initialized.CastingBar then return end
	self.initialized.CastingBar = true

	for _, prefix in pairs({"", "Pet"}) do
		local cbfName = prefix.."CastingBarFrame"
		if cbfName == "CastingBarFrame" then
			self:SecureHook("CastingBarFrame_OnUpdate", function()
				self:moveObject(cbfs, nil, nil, "-", 3)
			end)
		end

		local cbft = _G[cbfName.."Text"]
		local cbfs = _G[cbfName.."Spark"]
		local cbff = _G[cbfName.."Flash"]
		local cbfObj = _G[cbfName]

		self:keepFontStrings(cbfObj)
		-- adjust size/placement of the casting frame and associated textures
		cbfObj:SetWidth(cbfObj:GetWidth() * 0.7)
		cbfObj:SetHeight(cbfObj:GetHeight() * 1.2)
		cbfs:SetHeight(cbfs:GetHeight() * 1.5)
		cbff:SetWidth(cbfObj:GetWidth())
		cbff:SetHeight(cbfObj:GetHeight())
		cbff:SetTexture(self.sbTexture)
		self:moveObject(cbft, nil, nil, "-", 3)
		self:moveObject(cbff, nil, nil, "-", 28)
		
		if self.db.profile.CastingBar.glaze then self:glazeStatusBar(cbfObj, 0) end

	end

end

function Skinner:StaticPopups()
	if not self.db.profile.StaticPopups or self.initialized.StaticPopups then return end
	self.initialized.StaticPopups = true

	for i = 1, STATICPOPUP_NUMDIALOGS do
		self:skinEditBox(_G["StaticPopup"..i.."EditBox"])
		self:skinEditBox(_G["StaticPopup"..i.."WideEditBox"])
		self:skinMoneyFrame(_G["StaticPopup"..i.."MoneyInputFrame"])
		_G["StaticPopup"..i]:SetBackdrop(nil)
		self:addSkinFrame(_G["StaticPopup"..i], 10, 3, -10, 3, ftype)
	end

end

function Skinner:ChatMenus()
	if not self.db.profile.ChatMenus or self.initialized.ChatMenus then return end
	self.initialized.ChatMenus = true

	ChatMenu:SetBackdrop(nil)
	self:addSkinFrame(ChatMenu, 0, 0, 0, 0, ftype)
	EmoteMenu:SetBackdrop(nil)
	self:addSkinFrame(EmoteMenu, 0, 0, 0, 0, ftype)
	LanguageMenu:SetBackdrop(nil)
	self:addSkinFrame(LanguageMenu, 0, 0, 0, 0, ftype)
	VoiceMacroMenu:SetBackdrop(nil)
	self:addSkinFrame(VoiceMacroMenu, 0, 0, 0, 0, ftype)

end

function Skinner:ChatTabs()
	if not self.db.profile.ChatTabs or self.initialized.ChatTabs then return end
	self.initialized.ChatTabs = true

	for i = 1, NUM_CHAT_WINDOWS do
		local tabName = _G["ChatFrame"..i.."Tab"]
		self:keepRegions(tabName, {4, 5}) --N.B. region 4 is text, 5 is highlight
		self:addSkinFrame(tabName, 0, -8, 0, -5, ftype, self.isTT)
		self.skinFrame[tabName]:SetFrameLevel(0)
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

	local clqbf_c = CombatLogQuickButtonFrame_Custom
	local xOfs1, yOfs1, xOfs2, yOfs2 = -4, nil, 4, -8
	for i = 1, NUM_CHAT_WINDOWS do
		local cf = _G["ChatFrame"..i]
		if SIMPLE_CHAT ~= "1" and CHAT_LOCKED ~= "1" and cf:GetName() == "ChatFrame2" and clqbf_c:IsShown() then
			yOfs1 = 31
		else
			yOfs1 = 4
		end
		self:addSkinFrame(cf, xOfs1, yOfs1, xOfs2, yOfs2, ftype)
	end

	-- CombatLog Quick Button Frame & Progress Bar
	if SIMPLE_CHAT ~= "1" and CHAT_LOCKED ~= "1" and self.db.profile.CombatLogQBF then
		if clqbf_c then
			self:keepFontStrings(clqbf_c)
			self:addSkinFrame(clqbf_c, 0, 0, 0, 0, ftype)
			
			clqbf_c:SetHeight(clqbf_c:GetHeight() + 4)
			self:glazeStatusBar(CombatLogQuickButtonFrame_CustomProgressBar, 0)
		else
			self:glazeStatusBar(CombatLogQuickButtonFrameProgressBar, 0)
		end
	end

end

function Skinner:ChatConfig()
	if not self.db.profile.ChatConfig or self.initialized.ChatConfig then return end
	self.initialized.ChatConfig = true

	self:keepFontStrings(ChatConfigFrame)
	ChatConfigFrame:SetBackdrop(nil)
	self:moveObject(ChatConfigFrameHeaderText, nil, nil, "-", 6)
	self:addSkinFrame(ChatConfigFrame, 0, 0, 0, 0, ftype)
	ChatConfigCategoryFrame:SetBackdrop(nil)
	self:addSkinFrame(ChatConfigCategoryFrame, 0, 0, 0, 0, ftype)
	ChatConfigBackgroundFrame:SetBackdrop(nil)
	self:addSkinFrame(ChatConfigBackgroundFrame, 0, 0, 0, 0, ftype)

-->>--	Chat Settings
	for i = 1, #CHAT_CONFIG_CHAT_LEFT do
		_G["ChatConfigChatSettingsLeftCheckBox"..i]:SetBackdrop(nil)
	end
	ChatConfigChatSettingsLeft:SetBackdrop(nil)
	self:addSkinFrame(ChatConfigChatSettingsLeft, 0, 0, 0, 0, ftype)
	
	for i = 1, #CHAT_CONFIG_CHAT_RIGHT do
		_G["ChatConfigChatSettingsRightCheckBox"..i]:SetBackdrop(nil)
	end
	ChatConfigChatSettingsRight:SetBackdrop(nil)
	self:addSkinFrame(ChatConfigChatSettingsRight, 0, 0, 0, 0, ftype)
	
	for i = 1, #CHAT_CONFIG_CHAT_CREATURE_LEFT do
		_G["ChatConfigChatSettingsCreatureLeftCheckBox"..i]:SetBackdrop(nil)
	end
	ChatConfigChatSettingsCreatureLeft:SetBackdrop(nil)
	self:addSkinFrame(ChatConfigChatSettingsCreatureLeft, 0, 0, 0, 0, ftype)
	
-->>--	Channel Settings
	self:SecureHook(ChatConfigChannelSettings, "Show", function(this)
		for i = 1, #ChatConfigChannelSettingsLeft.checkBoxTable do
			local cccslcb = _G["ChatConfigChannelSettingsLeftCheckBox"..i]
			if not self.skinFrame[cccslcb] then
				self:addSkinFrame(cccslcb, 0, 0, 0, 0, ftype)
			end
		end
	end)
	ChatConfigChannelSettingsLeft:SetBackdrop(nil)
	self:addSkinFrame(ChatConfigChannelSettingsLeft, 0, 0, 0, 0, ftype)

-->>--	Other Settings
	for i = 1, #CHAT_CONFIG_OTHER_COMBAT do
		_G["ChatConfigOtherSettingsCombatCheckBox"..i]:SetBackdrop(nil)
	end
	ChatConfigOtherSettingsCombat:SetBackdrop(nil)
	self:addSkinFrame(ChatConfigOtherSettingsCombat, 0, 0, 0, 0, ftype)
	
	for i = 1, #CHAT_CONFIG_OTHER_PVP do
		_G["ChatConfigOtherSettingsPVPCheckBox"..i]:SetBackdrop(nil)
	end
	ChatConfigOtherSettingsPVP:SetBackdrop(nil)
	self:addSkinFrame(ChatConfigOtherSettingsPVP, 0, 0, 0, 0, ftype)
	
	for i = 1, #CHAT_CONFIG_OTHER_SYSTEM do
		_G["ChatConfigOtherSettingsSystemCheckBox"..i]:SetBackdrop(nil)
	end
	ChatConfigOtherSettingsSystem:SetBackdrop(nil)
	self:addSkinFrame(ChatConfigOtherSettingsSystem, 0, 0, 0, 0, ftype)

-->>--	Combat Settings
	-- Filters
	ChatConfigCombatSettingsFiltersScrollFrameScrollBarBorder:Hide()
	self:skinScrollBar(ChatConfigCombatSettingsFiltersScrollFrame)
	ChatConfigCombatSettingsFilters:SetBackdrop(nil)
	self:addSkinFrame(ChatConfigCombatSettingsFilters, 0, 0, 0, 0, ftype)
	
	-- Message Sources
	if COMBAT_CONFIG_MESSAGESOURCES_BY then
		for i = 1, #COMBAT_CONFIG_MESSAGESOURCES_BY do
			_G["CombatConfigMessageSourcesDoneByCheckBox"..i]:SetBackdrop(nil)
		end
		CombatConfigMessageSourcesDoneBy:SetBackdrop(nil)
		self:addSkinFrame(CombatConfigMessageSourcesDoneBy, 0, 0, 0, 0, ftype)
	end
	if COMBAT_CONFIG_MESSAGESOURCES_TO then
		for i = 1, #COMBAT_CONFIG_MESSAGESOURCES_TO do
			_G["CombatConfigMessageSourcesDoneToCheckBox"..i]:SetBackdrop(nil)
		end
		CombatConfigMessageSourcesDoneTo:SetBackdrop(nil)
		self:addSkinFrame(CombatConfigMessageSourcesDoneTo, 0, 0, 0, 0, ftype)
	end
	
	-- Colors
	for i = 1, #COMBAT_CONFIG_UNIT_COLORS do
		_G["CombatConfigColorsUnitColorsSwatch"..i]:SetBackdrop(nil)
	end
	CombatConfigColorsUnitColors:SetBackdrop(nil)
	self:addSkinFrame(CombatConfigColorsUnitColors, 0, 0, 0, 0, ftype)
	
	local clrize, ccccObj
	for i, v in ipairs({"Highlighting", "UnitName", "SpellNames", "DamageNumber", "DamageSchool", "EntireLine"}) do
		clrize = i > 1 and "Colorize" or ""
		ccccObj = _G["CombatConfigColors"..clrize..v]
		ccccObj:SetBackdrop(nil)
		self:addSkinFrame(ccccObj, 0, 0, 0, 0, ftype)
	end
	
	-- Settings
	self:skinEditBox(CombatConfigSettingsNameEditBox , {9})
	
	-- Tabs
	for i = 1, #COMBAT_CONFIG_TABS do
		local tabName = _G["CombatConfigTab"..i]
		self:keepRegions(tabName, {4, 5}) -- N.B. region 4 is the Text, 5 is the highlight
		self:addSkinFrame(tabName, 0, -8, 0, -4, ftype)
	end

end

function Skinner:ChatEditBox()
	-- don't use an initialized value to allow for dynamic changes
	if not self.db.profile.ChatEditBox.skin then return end

	-- these addons replace the Chat Edit Box
	if IsAddOnLoaded("NeonChat") or IsAddOnLoaded("Chatter") then return end

	if self.db.profile.ChatEditBox.style == 1 then
		local kRegions = CopyTable(self.ebRegions)
		table.insert(kRegions, 9)
		self:keepRegions(ChatFrameEditBox, kRegions)
		ChatFrameEditBox:SetBackdrop(nil)
		self:addSkinFrame(ChatFrameEditBox, 0, 0, 0, 0, ftype)
		
	else
		self:skinEditBox(ChatFrameEditBox, {9}, nil, true)
	end

end

function Skinner:LootFrame()
	if not self.db.profile.LootFrame or self.initialized.LootFrame then return end
	self.initialized.LootFrame = true

	self:keepFontStrings(LootFrame)
	self:moveObject(self:getRegion(LootFrame, 3), "-", 12) -- title
	self:addSkinFrame(LootFrame, 8, -13, -68, 0, ftype)
	
end

function Skinner:GroupLoot()
	if not self.db.profile.GroupLoot.skin or self.initialized.GroupLoot then return end
	self.initialized.GroupLoot = true

	local f = GameFontNormalSmall:GetFont()
	local xMult, yMult = 0.75, 0.75

	self:skinDropDown(GroupLootDropDown)

	for i = 1, NUM_GROUP_LOOT_FRAMES do

		local glf = "GroupLootFrame"..i
--		self:Debug("skinned GLF: [%s]", glf)
		local glfo = _G[glf]
		self:keepFontStrings(glfo)
		self:removeRegions(_G[glf.."Timer"], {1})
		self:glazeStatusBar(_G[glf.."Timer"], 0)
		-- hook this to skin the group loot frame
		self:SecureHook(glfo, "Show", function(this)
			self:Debug("GLF_S(f): [%s, %s]", this, this:GetName())
			this:SetBackdrop(nil)
		end)

		if self.db.profile.GroupLoot.size == 1 then

			self:addSkinFrame(glfo, 4, -5, -4, 5, ftype)

		elseif self.db.profile.GroupLoot.size == 2 then

			glfo:SetScale(0.75)
		
			self:addSkinFrame(glfo, 4, -5, -4, 5, ftype)
			
		elseif self.db.profile.GroupLoot.size == 3 then

			glfo:SetScale(0.75)

			self:moveObject(_G[glf.."SlotTexture"], "+", 95, "+", 4)
			_G[glf.."NameFrame"]:Hide()
			_G[glf.."Name"]:Hide()
			_G[glf.."RollButton"]:ClearAllPoints()
			_G[glf.."RollButton"]:SetPoint("RIGHT", _G[glf.."PassButton"], "LEFT", 5, -5)
			_G[glf.."GreedButton"]:ClearAllPoints()
			_G[glf.."GreedButton"]:SetPoint("RIGHT", _G[glf.."RollButton"], "LEFT", 0, 0)
			_G[glf.."Timer"]:SetWidth(_G[glf.."Timer"]:GetWidth() - 28)
			self:moveObject(_G[glf.."Timer"], "-", 3)

			self:addSkinFrame(glfo, 102, -5, -4, 16, ftype)
			
		end

	end

end

function Skinner:ContainerFrames()
	if not self.db.profile.ContainerFrames.skin or self.initialized.ContainerFrames then return end
	self.initialized.ContainerFrames = true

	for i = 1, NUM_CONTAINER_FRAMES do
		local frameObj = _G["ContainerFrame"..i]
		self:keepFontStrings(frameObj)
		self:addSkinFrame(frameObj, 8, -4, -4, 0, ftype)
		-- resize and move the bag name to make it more readable
		local frameName = _G["ContainerFrame"..i.."Name"]
		frameName:SetWidth(145)
		self:moveObject(frameName, "-", 30)
	end

end

function Skinner:StackSplit()
	if not self.db.profile.StackSplit or self.initialized.StackSplit then return end
	self.initialized.StackSplit = true

	self:keepFontStrings(StackSplitFrame)
	self:addSkinFrame(StackSplitFrame, 9, -12, -6, 12, ftype)

end

function Skinner:ItemText()
	if not self.db.profile.ItemText or self.initialized.ItemText then return end
	self.initialized.ItemText = true

	self:SecureHookScript(ItemTextFrame, "OnShow", function(this)
		ItemTextPageText:SetTextColor(self.BTr, self.BTg, self.BTb)
	end)
	self:keepFontStrings(ItemTextFrame)
	self:removeRegions(ItemTextScrollFrame)
	self:skinScrollBar(ItemTextScrollFrame)
	self:glazeStatusBar(ItemTextStatusBar, 0)
	self:moveObject(ItemTextPrevPageButton, "-", 55)
	self:addSkinFrame(ItemTextFrame, 10, -13, -32, 71, ftype)

end

function Skinner:ColorPicker()
	if not self.db.profile.Colours or self.initialized.Colours then return end
	self.initialized.Colours = true

	ColorPickerFrame:SetBackdrop(nil)
	ColorPickerFrameHeader:SetAlpha(0)
	self:skinSlider(OpacitySliderFrame, 4)
	self:addSkinFrame(ColorPickerFrame, 6, 6, -6, nil, ftype)
	
-->>-- Opacity Frame, used by BattlefieldMinimap amongst others
	OpacityFrame:SetBackdrop(nil)
	self:skinSlider(OpacityFrameSlider)
	self:addSkinFrame(OpacityFrame, 0, 0, 0, 0, ftype)

end

function Skinner:WorldMap()
	if not self.db.profile.WorldMap or self.initialized.WorldMap then return end
	self.initialized.WorldMap = true

	self:keepFontStrings(WorldMapFrame)
	self:skinDropDown(WorldMapContinentDropDown)
	self:skinDropDown(WorldMapZoneDropDown)
	self:skinDropDown(WorldMapZoneMinimapDropDown)
	self:skinDropDown(WorldMapLevelDropDown)

	if not IsAddOnLoaded("MetaMap") then
		self:addSkinFrame(WorldMapFrame, 99, 0, -101, 18, ftype)
	end
-->>-- Tooltip
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

	local hfTitle = self:getRegion(HelpFrame, 8)
	local kbTitle = self:getRegion(KnowledgeBaseFrame, 2)
	-- hook these to manage frame titles
	self:SecureHook("HelpFrame_ShowFrame", function(key)
--		self:Debug("HF_SF: [%s]", key)
		hfTitle:SetAlpha(0)
		kbTitle:SetAlpha(0)
		if key == "KBase" then
			kbTitle:SetAlpha(1)
		else
			hfTitle:SetAlpha(1)
		end
	end)
	self:SecureHook("HelpFrame_PopFrame", function()
--		self:Debug("HF_PF: [%s]", HelpFrame.openFrame and HelpFrame.openFrame:GetName() or "<Anon>")
		if HelpFrame.openFrame and HelpFrame.openFrame:GetName() == "KnowledgeBaseFrame" then
			hfTitle:SetAlpha(0)
			kbTitle:SetAlpha(1)
		end
	end)
	
-->>--	Help Frame
	self:keepFontStrings(HelpFrame)
	self:moveObject(hfTitle, nil, nil, "-", 8)
	self:addSkinFrame(HelpFrame, 6, -6, -45, 14, ftype)

-->>--	Open Ticket Frame
	HelpFrameOpenTicketDivider:Hide()
	self:removeRegions(HelpFrameOpenTicketScrollFrame)
	self:skinScrollBar(HelpFrameOpenTicketScrollFrame)

-->>--	Ticket Status Frame
	local tsfC = self:getChild(TicketStatusFrame, 2) -- skin this unnamed child
	tsfC:SetBackdrop(nil)
	self:addSkinFrame(tsfC, 0, 0, 0, 0, ftype)
	
-->>--	KnowledgeBase Frame
	self:keepFontStrings(KnowledgeBaseFrame)
	self:moveObject(kbTitle, nil, nil, "-", 8)
	self:skinEditBox(KnowledgeBaseFrameEditBox)
	self:skinDropDown(KnowledgeBaseFrameCategoryDropDown)
	self:skinDropDown(KnowledgeBaseFrameSubCategoryDropDown)
	KnowledgeBaseFrameDivider:Hide()
	KnowledgeBaseFrameDivider2:Hide()
	self:removeRegions(KnowledgeBaseArticleScrollFrame)
	self:skinScrollBar(KnowledgeBaseArticleScrollFrame)

end

function Skinner:InspectUI()
	if not self.db.profile.InspectUI or self.initialized.InspectUI then return end
	self.initialized.InspectUI = true

	if self.isTT then
		-- hook this to change the texture for the Active and Inactive tabs
		self:SecureHook("InspectSwitchTabs",function(newID)
			for i = 1, InspectFrame.numTabs do
				local tabSF = self.skinFrame[_G["InspectFrameTab"..i]]
				if i == newID then
					self:setActiveTab(tabSF)
				else
					self:setInactiveTab(tabSF)
				end
			end
		end)
	end
	
	self:keepFontStrings(InspectFrame)
	self:addSkinFrame(InspectFrame, 10, -12, -32, 69, ftype)
	
	self:keepRegions(InspectPaperDollFrame, {5, 6, 7}) -- N.B. regions 5-7 are text
	InspectModelRotateLeftButton:Hide()
	InspectModelRotateRightButton:Hide()
	self:makeMFRotatable(InspectModelFrame)

-->>--	PVP Frame
	self:keepFontStrings(InspectPVPFrame)

-->>--	Talent Frame
	self:keepRegions(InspectTalentFrame, {6, 7, 8, 9, 10}) -- N.B. 6, 7, 8 & 9 are the background picture, 10 is text
	InspectTalentFrameCloseButton:Hide()
	self:removeRegions(InspectTalentFrameScrollFrame)
	self:skinScrollBar(InspectTalentFrameScrollFrame)
	self:keepFontStrings(InspectTalentFramePointsBar)
	self:skinFFToggleTabs("InspectTalentFrameTab")

-->>--	Frame Tabs
	for i = 1, InspectFrame.numTabs do
		local tabName = _G["InspectFrameTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		self:addSkinFrame(tabName, 6, 0, -6, 2, ftype, self.isTT)
		local tabSF = self.skinFrame[tabName]
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end
	
end

function Skinner:BattleScore()
	if not self.db.profile.BattleScore or self.initialized.BattleScore then return end
	self.initialized.BattleScore = true

	if self.isTT then
		-- hook this to change the texture for the Active and Inactive tabs
		self:SecureHook("WorldStateScoreFrameTab_OnClick",function(tab)
			for i = 1, 3 do
				local tabObj = _G["WorldStateScoreFrameTab"..i]
				local tabSF = self.skinFrame[tabObj]
				if tabObj == tab then
					self:setActiveTab(tabSF)
				else
					self:setInactiveTab(tabSF)
				end
			end
		end)
	end
	
	self:keepFontStrings(WorldStateScoreFrame)
	self:removeRegions(WorldStateScoreScrollFrame)
	self:skinScrollBar(WorldStateScoreScrollFrame)
	self:addSkinFrame(WorldStateScoreFrame, 10, -15, -113, 70, ftype)

-->>-- Tabs
	for i = 1, 3 do
		local tabName = _G["WorldStateScoreFrameTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		self:addSkinFrame(tabName, 7, 8, -7, 10, ftype, self.isTT)
		local tabSF = self.skinFrame[tabName]
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end
	
end

function Skinner:BattlefieldMinimap()
	if not self.db.profile.BattlefieldMm then return end

--	self:Debug("BMM")

	self:SecureHook("BattlefieldMinimap_UpdateOpacity", function(opacity)
		local alpha = 1.0 - BattlefieldMinimapOptions.opacity
		if ( alpha >= 0.15 ) then alpha = alpha - 0.15 end
		self.skinFrame[BattlefieldMinimap]:SetAlpha(alpha)
		self.skinFrame[BattlefieldMinimap].tfade:SetAlpha(alpha)
	end)

-->>--	Minimap Tab
	self:keepRegions(BattlefieldMinimapTab, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
	if self.db.profile.TexturedTab then self:applySkin(BattlefieldMinimapTab, nil, 0, 1)
	else self:storeAndSkin(ftype, BattlefieldMinimapTab) end
	self:moveObject(BattlefieldMinimapTabText, nil, nil, "+", 4)

-->>--	Minimap
	self:moveObject(BattlefieldMinimap, nil, nil, "+", 5)
	-- change the draw layer so that the map is visible

	-- Create a frame to skin as using the BattlefieldMinimap one causes issues with Capping
	self:addSkinFrame(BattlefieldMinimap, -4, 4, -2, 1, ftype)
	-- hide the textures as the alpha values are changed in game
	BattlefieldMinimapCorner:Hide()
	BattlefieldMinimapBackground:Hide()

	if IsAddOnLoaded("Capping") then
		if type(self["Capping_ModMap"]) == "function" then self:Capping_ModMap() end
	end

end

function Skinner:ScriptErrors()
	if not self.db.profile.ScriptErrors then return end

	ScriptErrors:SetBackdrop(nil)
	self:addSkinFrame(ScriptErrors, 0, 0, 0, 0, ftype)
	
end

function Skinner:Tutorial()
	if not self.db.profile.Tutorial then return end

	TutorialFrame:SetBackdrop(nil)
	self:addSkinFrame(TutorialFrame, 0, 0, 0, 0, ftype)

end

function Skinner:DropDowns()
	if not self.db.profile.DropDowns or self.initialized.DropDowns then return end
	self.initialized.DropDowns = true

	self:SecureHook("UIDropDownMenu_CreateFrames", function(level, index)
--		self:Debug("UIDDM_CF: [%s, %s]", level, index)
		for i = 1, UIDROPDOWNMENU_MAXLEVELS do
			local ddl = "DropDownList"..i
			local ddlObj = _G[ddl]
			if not self:IsHooked(ddlObj, "Show") then
--				self:Debug("DD's: [%s, %s]", i, UIDROPDOWNMENU_MAXLEVELS)
				self:SecureHook(ddlObj, "Show", function()
					self:keepFontStrings(ddlObj)
					_G[ddl.."Backdrop"]:Hide()
					_G[ddl.."MenuBackdrop"]:Hide()
					if not self.skinFrame[ddlObj] then
						self:addSkinFrame(ddlObj, 0, 0, 0, 0, ftype)
					end
				end)
			end
		end
	end)

end

function Skinner:MinimapButtons()
	if not self.db.profile.MinimapButtons or self.initialized.MinimapButtons then return end
	self.initialized.MinimapButtons = true

	local function mmKids(mmObj)

		local mmObjName = mmObj.GetName and mmObj:GetName() or "<Anon>"
--		Skinner:Debug("Checking %s kids", mmObjName)

		for i = 1, mmObj:GetNumChildren() do
			local obj = select(i, mmObj:GetChildren())
			local objName = obj:GetName()
			local objType = obj:GetObjectType()
--			Skinner:Debug("%s kids: [%s, %s, %s]", mmObjName, obj, objName, objType)
			if not Skinner.skinned[obj] and objName
			and (objType == "Button" or objType == "Frame" and objName == "MiniMapMailFrame") then
				for i = 1, obj:GetNumRegions() do
					local reg = select(i, obj:GetRegions())
					if reg:GetObjectType() == "Texture" then
						local regName = reg:GetName()
						local regTex = reg:GetTexture()
						local regDL = reg:GetDrawLayer()
--						Skinner:Debug("%s obj: [%s, %s, %s]", mmObjName, objName, regName, regTex)
						-- change the DrawLayer to make the Icon show if required
						if (regName and string.find(regName, "[Ii]con"))
						or (regTex and string.find(regTex, "[Ii]con")) then
--							Skinner:Debug("%s obj Icon: [%s, %s, %s, %s, %s]", mmObjName, objName, regName, regDL, math.ceil(reg:GetWidth()), math.ceil(reg:GetHeight()))
							if regDL == "BACKGROUND" then reg:SetDrawLayer("ARTWORK") end
							-- centre the icon
							reg:ClearAllPoints()
							reg:SetPoint("CENTER")
						elseif (regName and string.find(regName, "Border"))
						or (regTex and string.find(regTex, "TrackingBorder")) then
--							Skinner:Debug("%s obj skinned: [%s, %s, %s]", mmObjName, obj:GetName(), math.ceil(obj:GetWidth()), math.ceil(obj:GetHeight()))
							reg:SetTexture(nil)
							obj:SetWidth(32)
							obj:SetHeight(32)
							if objType == "Button" then
								Skinner:addSkinButton(obj, obj)
								Skinner.sBut[obj]:ClearAllPoints()
								Skinner.sBut[obj]:SetAllPoints(obj)
							else
								Skinner:addSkinFrame(obj, 0, 0 ,0, 0, ftype)
							end
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
	for _, obj in pairs({GameTimeFrame, MinimapZoomIn, MinimapZoomOut}) do
		self:addSkinButton(obj, obj)
		self.sBut[obj]:ClearAllPoints()
		self.sBut[obj]:SetAllPoints(obj)
	end
	-- resize other buttons
	MiniMapMailFrame:SetWidth(28)
	MiniMapMailFrame:SetHeight(28)
	GameTimeFrame:SetWidth(36)
	GameTimeFrame:SetHeight(36)
	MiniMapVoiceChatFrame:SetWidth(32)
	MiniMapVoiceChatFrame:SetHeight(32)
	MiniMapVoiceChatFrameIcon:ClearAllPoints()
	MiniMapVoiceChatFrameIcon:SetPoint("CENTER")

	-- MiniMap Tracking button
	MiniMapTrackingIcon:ClearAllPoints()
	MiniMapTrackingIcon:SetPoint("CENTER", MiniMapTrackingButton)
	MiniMapTrackingIcon:SetParent(MiniMapTrackingButton)
	-- hook this to stop the icon being moved
	self:RawHook(MiniMapTrackingIcon, "SetPoint", function(this, ...) end, true)

	-- move GameTime a.k.a. Calendar texture up a layer
	GameTimeFrame:GetNormalTexture():SetDrawLayer("BORDER")
	GameTimeFrame:GetPushedTexture():SetDrawLayer("BORDER")
	GameTimeFrame:GetFontString():SetDrawLayer("BORDER")

	-- skin any moved Minimap buttons if required
	if IsAddOnLoaded("MinimapButtonFrame") then mmKids(MinimapButtonFrame) end

	-- show the Bongos minimap icon if required
	if IsAddOnLoaded("Bongos") then Bongos3MinimapButton.icon:SetDrawLayer("ARTWORK") end

	-- skin other minimap buttons as required
	local mmButs = {
		["SmartBuff"] = SmartBuff_MiniMapButton,
		["WebDKP"] = WebDKP_MinimapButton,
		["GuildAds"] = GuildAdsMinimapButton,
		["Outfitter"] = OutfitterMinimapButton,
		["Perl_Config"] = PerlButton,
		["WIM"] = WIM3MinimapButton
	}
	for addon, obj in pairs(mmButs) do
		if IsAddOnLoaded(addon) then
			self:addSkinButton(obj, obj)
			self.sBut[obj]:ClearAllPoints()
			self.sBut[obj]:SetAllPoints(obj)
		end
	end
	mmButs = nil

end

function Skinner:MovieProgress()
	if not self.db.profile.MovieProgress or self.initialized.MovieProgress then return end
	self.initialized.MovieProgress = true

	if not MovieProgressFrame:IsShown() then
		self:SecureHook(MovieProgressFrame, "Show", function(this)
			self:getChild(MovieProgressBar, 1):SetBackdrop(nil)
			self:keepFontStrings(MovieProgressFrame)
			self:glazeStatusBar(MovieProgressBar, 0)
			self:Unhook(MovieProgressFrame, "Show")
		end)
	else
		self:getChild(MovieProgressBar, 1):SetBackdrop(nil)
		self:keepFontStrings(MovieProgressFrame)
		self:glazeStatusBar(MovieProgressBar, 0)
	end

end

function Skinner:TimeManager()
	if not self.db.profile.TimeManager or self.initialized.TimeManager then return end
	self.initialized.TimeManager = true

-->>--	Time Manager Frame
	self:keepFontStrings(TimeManagerFrame)
	TimeManagerFrameTicker:Hide()
	self:keepFontStrings(TimeManagerStopwatchFrame)
	self:skinDropDown(TimeManagerAlarmHourDropDown)
	TimeManagerAlarmHourDropDownMiddle:SetWidth(TimeManagerAlarmHourDropDownMiddle:GetWidth() + 8)
	self:skinDropDown(TimeManagerAlarmMinuteDropDown)
	TimeManagerAlarmMinuteDropDownMiddle:SetWidth(TimeManagerAlarmMinuteDropDownMiddle:GetWidth() + 8)
	self:skinDropDown(TimeManagerAlarmAMPMDropDown)
	self:skinEditBox(TimeManagerAlarmMessageEditBox, {9})
	self:addSkinFrame(TimeManagerFrame, 14, -11, -50, 9, ftype)
	

-->>--	Time Manager Clock Button
	self:removeRegions(TimeManagerClockButton, {1})
	self:addSkinFrame(TimeManagerClockButton, 7, -3, -7, 3, ftype)
	

-->>--	Stopwatch Frame
	self:keepFontStrings(StopwatchTabFrame)
	self:keepFontStrings(StopwatchFrame)
	self:addSkinFrame(StopwatchFrame, 0, -16, 0, 2, ftype)
	
end

function Skinner:Calendar()
	if not self.db.profile.Calendar or self.initialized.Calendar then return end
	self.initialized.Calendar = true

-->>--	Calendar Frame

	self:keepFontStrings(CalendarFrame)
	self:skinDropDown(CalendarFilterFrame, nil, nil, true)
	-- adjust non standard dropdown
	CalendarFilterFrameMiddle:SetHeight(16)
	self:moveObject(CalendarFilterButton, "-", 8)
	self:moveObject(CalendarFilterFrameText, "-", 8)
	-- move close button
	self:moveObject(CalendarCloseButton, nil, nil, "+", 14)
	CalendarFrame:SetBackdrop(nil)
	self:addSkinFrame(CalendarFrame, 1, nil, 1, -7, ftype)
	
-->>-- View Holiday Frame
	self:keepFontStrings(CalendarViewHolidayTitleFrame)
	self:moveObject(CalendarViewHolidayTitleFrame, nil, nil, "-", 6)
	self:keepFontStrings(CalendarViewHolidayFrame)
	self:removeRegions(CalendarViewHolidayCloseButton, {4})
	self:removeRegions(CalendarViewHolidayScrollFrame)
	self:skinScrollBar(CalendarViewHolidayScrollFrame)
	CalendarViewHolidayFrame:SetBackdrop(nil)
	self:addSkinFrame(CalendarViewHolidayFrame, 2, -3, -3, -2, ftype)
	
-->>-- View Raid Frame
	self:keepFontStrings(CalendarViewRaidTitleFrame)
	self:moveObject(CalendarViewRaidTitleFrame, nil, nil, "-", 6)
	self:keepFontStrings(CalendarViewRaidFrame)
	self:removeRegions(CalendarViewRaidCloseButton, {4})
	self:removeRegions(CalendarViewRaidScrollFrame)
	self:skinScrollBar(CalendarViewRaidScrollFrame)
	CalendarViewRaidFrame:SetBackdrop(nil)
	self:addSkinFrame(CalendarViewRaidFrame, 2, -3, -3, -2, ftype)
	
-->>-- View Event Frame
	self:keepFontStrings(CalendarViewEventTitleFrame)
	self:moveObject(CalendarViewEventTitleFrame, nil, nil, "-", 6)
	self:keepFontStrings(CalendarViewEventFrame)
	self:removeRegions(CalendarViewEventCloseButton, {4})
	CalendarViewEventDescriptionContainer:SetBackdrop(nil)
	self:addSkinFrame(CalendarViewEventDescriptionContainer, 0, 0, 0, 0, ftype)
	self:removeRegions(CalendarViewEventDescriptionScrollFrame)
	self:skinScrollBar(CalendarViewEventDescriptionScrollFrame)
	self:keepFontStrings(CalendarViewEventInviteListSection)
	CalendarViewEventInviteList:SetBackdrop(nil)
	self:addSkinFrame(CalendarViewEventInviteList, 0, 0, 0, 0, ftype)
	CalendarViewEventFrame:SetBackdrop(nil)
	self:addSkinFrame(CalendarViewEventFrame, 2, -3, -3, -2, ftype)
	
-->>-- Create Event Frame
	self:keepFontStrings(CalendarCreateEventFrame)
	CalendarCreateEventIcon:SetAlpha(1) -- show event icon
	self:keepFontStrings(CalendarCreateEventTitleFrame)
	self:moveObject(CalendarCreateEventTitleFrame, nil, nil, "-", 6)
	self:removeRegions(CalendarCreateEventCloseButton, {4})
	self:skinEditBox(CalendarCreateEventTitleEdit, {9})
	self:skinDropDown(CalendarCreateEventTypeDropDown)
	self:skinDropDown(CalendarCreateEventHourDropDown)
	CalendarCreateEventHourDropDownMiddle:SetWidth(CalendarCreateEventHourDropDownMiddle:GetWidth() + 8)
	self:skinDropDown(CalendarCreateEventMinuteDropDown)
	CalendarCreateEventMinuteDropDownMiddle:SetWidth(CalendarCreateEventMinuteDropDownMiddle:GetWidth() + 8)
	self:skinDropDown(CalendarCreateEventAMPMDropDown)
	self:skinDropDown(CalendarCreateEventRepeatOptionDropDown)
	CalendarCreateEventDescriptionContainer:SetBackdrop(nil)
	self:addSkinFrame(CalendarCreateEventDescriptionContainer, 0, 0, 0, 0, ftype)
	self:removeRegions(CalendarCreateEventDescriptionScrollFrame)
	self:skinScrollBar(CalendarCreateEventDescriptionScrollFrame)
	self:keepFontStrings(CalendarCreateEventInviteListSection)
	CalendarCreateEventInviteList:SetBackdrop(nil)
	self:addSkinFrame(CalendarCreateEventInviteList, 0, 0, 0, 0, ftype)
	self:skinEditBox(CalendarCreateEventInviteEdit, {9})
	CalendarCreateEventMassInviteButtonBorder:SetAlpha(0)
	-- TODO Fix this to be skinned properly when in a raid
	if CalendarCreateEventRaidInviteButtonBorder then CalendarCreateEventRaidInviteButtonBorder:SetAlpha(0) end
	CalendarCreateEventCreateButtonBorder:SetAlpha(0)
	CalendarCreateEventFrame:SetBackdrop(nil)
	self:addSkinFrame(CalendarCreateEventFrame, 2, -3, -3, -2, ftype)

-->>-- Mass Invite Frame
	self:keepFontStrings(CalendarMassInviteTitleFrame)
	self:moveObject(CalendarMassInviteTitleFrame, nil, nil, "-", 6)
	self:keepFontStrings(CalendarMassInviteFrame)
	self:removeRegions(CalendarMassInviteCloseButton, {4})
	self:skinEditBox(CalendarMassInviteGuildMinLevelEdit, {9})
	self:skinEditBox(CalendarMassInviteGuildMaxLevelEdit, {9})
	self:skinDropDown(CalendarMassInviteGuildRankMenu)
	CalendarMassInviteFrame:SetBackdrop(nil)
	self:addSkinFrame(CalendarMassInviteFrame, 4, -3, -3, 26, ftype)

-->>-- Event Picker Frame
	self:keepFontStrings(CalendarEventPickerTitleFrame)
	self:moveObject(CalendarEventPickerTitleFrame, nil, nil, "-", 6)
	self:keepFontStrings(CalendarEventPickerFrame)
	self:skinSlider(CalendarEventPickerScrollBar)
	self:removeRegions(CalendarEventPickerCloseButton, {7})
--[[
	self:moveObject(CalendarEventPickerCloseButton, nil, nil, "-", 4)
	self:storeAndSkin(ftype, CalendarEventPickerFrame)
--]]
	CalendarEventPickerFrame:SetBackdrop(nil)
	self:addSkinFrame(CalendarEventPickerFrame, 2, -3, -3, -2, ftype)

-->>-- Texture Picker Frame
	self:keepFontStrings(CalendarTexturePickerTitleFrame)
	self:moveObject(CalendarTexturePickerTitleFrame, nil, nil, "-", 6)
	self:keepFontStrings(CalendarTexturePickerFrame)
	self:skinSlider(CalendarTexturePickerScrollBar)
	CalendarTexturePickerCancelButtonBorder:SetAlpha(0)
	CalendarTexturePickerAcceptButtonBorder:SetAlpha(0)
	CalendarTexturePickerFrame:SetBackdrop(nil)
	self:addSkinFrame(CalendarTexturePickerFrame, 5, -3, -3, 2, ftype)

-->>-- Class Button Container
	for i = 1, MAX_CLASSES do -- allow for the total button
		self:removeRegions(_G["CalendarClassButton"..i], {1})
	end
	self:keepFontStrings(CalendarClassTotalsButton)
	-- Class Totals button, texture & size changes
	CalendarClassTotalsButtonBackgroundMiddle:SetTexture(self.itTex)
	self:moveObject(CalendarClassTotalsButtonBackgroundMiddle, "+", 2, nil, nil)
	CalendarClassTotalsButtonBackgroundMiddle:SetWidth(18)
	CalendarClassTotalsButtonBackgroundMiddle:SetHeight(18)
	CalendarClassTotalsButtonBackgroundMiddle:SetAlpha(1)

end
