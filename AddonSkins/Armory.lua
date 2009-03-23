
function Skinner:Armory()

-->>--	Main Frame
	ArmoryFrame:SetWidth(ArmoryFrame:GetWidth() * self.FxMult)
	ArmoryFrame:SetHeight(ArmoryFrame:GetHeight() * self.FyMult)
	self:keepFontStrings(ArmoryFrame)
	ArmoryFramePortrait:SetAlpha(1) -- used to delete characters from the database
	self:moveObject(ArmoryNameFrame, nil, nil, "-", 24)
	self:moveObject(ArmoryFrameCloseButton, "+", 28, "+", 8)
	self:skinDropDown(ArmoryNameDropDown)
	ArmoryNameDropDownMiddle:SetAlpha(0)
	self:moveObject(ArmoryNameDropDown, nil, nil, "+", 10)
	self:moveObject(ArmoryFrameLeftButton, "-", 10, "+", 50)
	self:moveObject(ArmoryFrameRightButton, "-", 10, "+", 50)
	self:applySkin(ArmoryFrame)

-->>--	Frame Tabs
	for i = 1, 5 do
		local tabName = _G["ArmoryFrameTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		if self.db.profile.TexturedTab then self:applySkin(tabName, nil, 0, 1)
		else self:applySkin(tabName) end
		if self.db.profile.TexturedTab then self:setInactiveTab(tabName) end
		if i == 1 then
			self:moveObject(tabName, "-", 12, "-", 70)
			if self.db.profile.TexturedTab then self:setActiveTab(tabName) end
		else
			self:moveObject(tabName, "+", 11, nil, nil)
		end
	end
	if self.db.profile.TexturedTab then
		-- hook this for Tabs
		self:SecureHook("ArmoryFrame_ShowSubFrame", function(frameName)
--			self:Debug("AF_SSF: [%s, %s]", frameName, ArmoryFrame.selectedTab)
			for i = 1, 5 do
				local tabName = _G["ArmoryFrameTab"..i]
				if i == ArmoryFrame.selectedTab then self:setActiveTab(tabName)
				else self:setInactiveTab(tabName) end
			end
		end)
	end

	self:resizeTabs(ArmoryFrame)
	
	-- hook this to manage tabs when character has a pet
	self:SecureHook("ArmoryPetTab_Update", function()
		self:Debug("APT_U")
		if ArmoryFrameTab2:IsShown() then
			self:Debug("APT_U - Move")
			ArmoryFrameTab3:SetPoint("LEFT", "ArmoryFrameTab2", "RIGHT", -6, 0)
		end
	end)

-->>--	Frame Line Tabs
	for i = 1, ARMORY_MAX_LINE_TABS do
		local tabName = _G["ArmoryFrameLineTab"..i]
		self:removeRegions(tabName, {1}) -- N.B. region 2 is the icon, 3 is the text
		-- Move the first entry as all the others are positioned from it
		if i == 1 then self:moveObject(tabName, "+", 30, "-", 0) end
	end

-->>-- DropDown Menus
	for i = 1, 2 do
		local ddM = _G["ArmoryDropDownList"..i]
		_G["ArmoryDropDownList"..i.."Backdrop"]:SetAlpha(0)
		_G["ArmoryDropDownList"..i.."MenuBackdrop"]:SetAlpha(0)
		self:keepFontStrings(ddM)
		self:applySkin(ddM)
	end

-->>--	PaperDoll Frame
	self:keepFontStrings(ArmoryPaperDollFrame)
	self:moveObject(ArmoryHeadSlot, "-", 10, nil, nil)
	self:moveObject(ArmoryPaperDollTalentFrame, "-", 10, nil, nil)
	self:moveObject(ArmoryHandsSlot, "-", 10, nil, nil)
	self:moveObject(ArmoryResistanceFrame, "-", 10, nil, nil)
	self:moveObject(ArmoryAttributesFrame, "-", 10, nil, nil)
	self:moveObject(ArmoryMainHandSlot, "-", 10, "-", 71)
	self:keepFontStrings(ArmoryPaperDollTalentFrame)
	self:applySkin(ArmoryPaperDollTalentFrame)
	self:keepFontStrings(ArmoryPaperDollTradeSkillFrame)
	self:glazeStatusBar(ArmoryPaperDollTradeSkillFrame1Bar)
	self:glazeStatusBar(ArmoryPaperDollTradeSkillFrame1BackgroundBar)
	ArmoryPaperDollTradeSkillFrame1BackgroundBar:SetStatusBarColor(unpack(self.sbColour))
	self:glazeStatusBar(ArmoryPaperDollTradeSkillFrame2Bar)
	self:glazeStatusBar(ArmoryPaperDollTradeSkillFrame2BackgroundBar)
	ArmoryPaperDollTradeSkillFrame2BackgroundBar:SetStatusBarColor(unpack(self.sbColour))
	self:applySkin(ArmoryPaperDollTradeSkillFrame)
	ArmoryHealthFrame:SetHeight(ArmoryHealthFrame:GetHeight() + 4)
	self:keepFontStrings(ArmoryHealthFrame)
	self:glazeStatusBar(ArmoryHealthBar)
	self:glazeStatusBar(ArmoryHealthBackgroundBar)
	ArmoryHealthBackgroundBar:SetStatusBarColor(unpack(self.sbColour))
	self:glazeStatusBar(ArmoryManaBar)
	self:glazeStatusBar(ArmoryManaBackgroundBar)
	ArmoryManaBackgroundBar:SetStatusBarColor(unpack(self.sbColour))
	self:applySkin(ArmoryHealthFrame)
	ArmoryAttributesFrame:SetHeight(ArmoryAttributesFrame:GetHeight() + 10)
	self:keepFontStrings(ArmoryAttributesFrame)
	self:applySkin(ArmoryAttributesFrame)
	self:keepFontStrings(ArmoryPlayerStatFrameLeftDropDown)
	self:keepFontStrings(ArmoryPlayerStatFrameRightDropDown)

-->>-- Pet Frame
	self:keepFontStrings(ArmoryPetFrame)
	self:moveObject(ArmoryPetNameText, nil, nil, "-", 24)
	ArmoryPetAttributesFrame:SetHeight(ArmoryPetAttributesFrame:GetHeight() + 10)
	self:keepFontStrings(ArmoryPetAttributesFrame)
	self:applySkin(ArmoryPetAttributesFrame)
	self:moveObject(ArmoryPetFramePet1, nil, nil, "-", 65)

-->>--	Talents Frame
	self:keepRegions(ArmoryTalentFrame, {5, 6, 7, 8}) -- N.B. 5, 6, 7 & 8 are the background picture
	self:moveObject(ArmoryTalentFrameBackgroundTopLeft, nil, nil, "+", 10)
	ArmoryTalentFrameBackgroundBottomLeft:SetHeight(144)
	ArmoryTalentFrameBackgroundBottomRight:SetHeight(144)
	self:moveObject(ArmoryTalentFrameScrollFrame, "+", 36, "+", 10)
	self:keepFontStrings(ArmoryTalentFrameScrollFrame)
	self:skinScrollBar(ArmoryTalentFrameScrollFrame)

	for i = 1, 5 do
		local tabName = _G["ArmoryTalentFrameTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		self:applySkin(tabName)
		self:moveObject(_G["ArmoryTalentFrameTab"..i.."HighlightTexture"], "-", 2, "+", 5)
		if i == 1 then self:moveObject(tabName, nil, nil, "+", 10)
		else self:moveObject(tabName, "+", 4, nil, nil) end
	end

-->>--	PVP Frame
	self:keepFontStrings(ArmoryPVPFrame)
	self:moveObject(ArmoryPVPFrameHonorLabel, "-", 25, nil, nil)
	self:moveObject(ArmoryPVPFrameHonorPoints, "+", 30, nil, nil)
	self:moveObject(ArmoryPVPFrameArenaLabel, "-", 25, nil, nil)
	self:moveObject(ArmoryPVPFrameArenaPoints, "+", 30, nil, nil)
	self:moveObject(ArmoryPVPHonorTodayLabel, "+", 10, nil, nil)
	self:moveObject(ArmoryPVPTeam1Standard, "-", 10, "+", 10)
	self:moveObject(ArmoryPVPTeam2Standard, "-", 10, "+", 10)
	self:moveObject(ArmoryPVPTeam3Standard, "-", 10, "+", 10)

-->>--	PVP Team Details Frame
	self:keepFontStrings(ArmoryPVPTeamDetails)
	self:moveObject(ArmoryPVPTeamDetails, "+", 25, nil, nil)
	self:applySkin(ArmoryPVPTeamDetails)

-->>--	Other Frame (parent for the Reputation, Skills, RaidInfo & Currency Frames)
	self:keepFontStrings(ArmoryOtherFrame)
	for i = 1, 5 do
		local tabName = _G["ArmoryOtherFrameTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		self:applySkin(tabName)
		self:moveObject(_G["ArmoryOtherFrameTab"..i.."HighlightTexture"], "-", 2, "+", 5)
		if i == 1 then self:moveObject(tabName, "-", 5, "+", 10)
		else self:moveObject(tabName, "+", 4, nil, nil) end
	end

-->>-- Reputation SubFrame
	self:keepFontStrings(ArmoryReputationFrame)
	self:moveObject(ArmoryReputationBar1, "-", 15, "+", 20)
	self:moveObject(ArmoryReputationListScrollFrame, "+", 35, "+", 10)
	self:removeRegions(ArmoryReputationListScrollFrame)
	self:skinScrollBar(ArmoryReputationListScrollFrame)

	for i = 1, ARMORY_NUM_FACTIONS_DISPLAYED do
		if i == 1 then self:moveObject(_G["ArmoryReputationBar"..i], "+", 40, nil, nil) end
		self:glazeStatusBar(_G["ArmoryReputationBar"..i.."ReputationBar"], 0)
		_G["ArmoryReputationBar"..i.."Background"]:SetAlpha(0)
		_G["ArmoryReputationBar"..i.."ReputationBarLeftTexture"]:SetAlpha(0)
		_G["ArmoryReputationBar"..i.."ReputationBarRightTexture"]:SetAlpha(0)
	end
	-- hook these to stop rows being moved
	self:RawHookScript(ArmoryReputationListScrollFrame, "OnShow", function(this) end, true)
	self:RawHookScript(ArmoryReputationListScrollFrame, "OnHide", function(this) end, true)

-->>--	Skills SubFrame
	self:keepFontStrings(ArmorySkillFrame)
	local xOfs, yOfs = 5, 10
	self:moveObject(ArmorySkillTypeLabel1, "-", xOfs, "+", yOfs)
	self:moveObject(ArmorySkillRankFrame1, "-", xOfs, "+", yOfs)
	self:moveObject(ArmorySkillListScrollFrame, "+", 35, "+", yOfs)
	self:removeRegions(ArmorySkillListScrollFrame)
	self:skinScrollBar(ArmorySkillListScrollFrame)

	for i = 1, ARMORY_NUM_SKILLS_DISPLAYED do
		self:removeRegions(_G["ArmorySkillRankFrame"..i.."Border"], {1}) -- N.B. region 2 is highlight
		self:glazeStatusBar(_G["ArmorySkillRankFrame"..i], 0)
	end

-->>--	RaidInfo SubFrame
	self:keepFontStrings(ArmoryRaidInfoFrame)
	self:keepFontStrings(ArmoryRaidInfoScrollFrame)
	self:skinScrollBar(ArmoryRaidInfoScrollFrame)

-->>-- Currency SubFrame
	self:keepFontStrings(ArmoryTokenFrame)
	self:moveObject(ArmoryTokenFrameContainer, "-", 10, "+", yOfs)
	self:skinSlider(ArmoryTokenFrameContainerScrollBar)

-->>--	Inventory Frame
	ArmoryInventoryFrame:SetWidth(ArmoryInventoryFrame:GetWidth() * self.FxMult)
	ArmoryInventoryFrame:SetHeight(ArmoryInventoryFrame:GetHeight() * self.FyMult)
	self:moveObject(ArmoryInventoryFrame, "+", 30, nil, nil)
	self:moveObject(ArmoryInventoryFrameTitleText, nil, nil, "+", 10)
	self:keepFontStrings(ArmoryInventoryMoneyBackgroundFrame)
	self:moveObject(ArmoryInventoryMoneyBackgroundFrame, "-", 40, "+", 20)
	self:skinEditBox(ArmoryInventoryFrameEditBox, {9})
	self:moveObject(ArmoryInventoryFrameEditBox, nil, nil, "+", 24)
	self:moveObject(ArmoryInventoryExpandButtonFrame, "-", 15, "+", 10)
	self:keepFontStrings(ArmoryInventoryExpandButtonFrame)
 	self:moveObject(ArmoryInventoryFrameCloseButton, "+", 29, "+", 8)
	self:keepFontStrings(ArmoryInventoryFrame)
	self:applySkin(ArmoryInventoryFrame)
	-- Icon View SubFrame
	self:moveObject(ArmoryInventoryIconViewFrame, "+", 24, "+", 10)
	self:keepFontStrings(ArmoryInventoryIconViewFrame)
	self:skinScrollBar(ArmoryInventoryIconViewFrame)
	-- List View SubFrame
	self:moveObject(ArmoryInventoryListViewFrame, "+", 24, "+", 10)
	self:keepFontStrings(ArmoryInventoryListViewScrollFrame)
	self:skinScrollBar(ArmoryInventoryListViewScrollFrame)
-->>-- Inventory Frame Tabs
	for i = 1, 2 do
		local tabName = _G["ArmoryInventoryFrameTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		if self.db.profile.TexturedTab then
			self:applySkin(tabName, nil, 0, 1)
			self:setInactiveTab(tabName)
		else self:applySkin(tabName) end
		if i == 1 then
			self:moveObject(tabName, nil, nil, "-", 70)
			if self.db.profile.TexturedTab then self:setActiveTab(tabName) end
		else
			self:moveObject(tabName, "+", 12, nil, nil)
		end
	end
	if self.db.profile.TexturedTab then
		-- hook this for Tabs
		self:SecureHook("ArmoryInventoryFrameTab_OnClick", function(selectedTab)
--			self:Debug("AIFT_OC: [%s, %s]", selectedTab, selectedTab:GetName() or "<Anon>")
			for i = 1, 2 do
				local tabName = _G["ArmoryInventoryFrameTab"..i]
				if tabName == selectedTab then self:setActiveTab(tabName)
				else self:setInactiveTab(tabName) end
			end
		end)
	end

-->>--	QuestLog
	self:SecureHook("ArmoryQuestLog_UpdateQuestDetails", function(doNotScroll)
--		self:Debug("ArmoryQuestLog_UpdateQuestDetails")
		for i = 1, 10 do
			local r, g, b, a = _G["ArmoryQuestLogObjective"..i]:GetTextColor()
			_G["ArmoryQuestLogObjective"..i]:SetTextColor(self.BTr - r, self.BTg - g, self.BTb)
		end
		local r, g, b, a = ArmoryQuestLogRequiredMoneyText:GetTextColor()
		ArmoryQuestLogRequiredMoneyText:SetTextColor(self.BTr - r, self.BTg - g, self.BTb)
		ArmoryQuestLogRewardTitleText:SetTextColor(self.HTr, self.HTg, self.HTb)
	end)

	ArmoryQuestLogFrame:SetWidth(ArmoryQuestLogFrame:GetWidth() * self.FxMult)
	ArmoryQuestLogFrame:SetHeight(ArmoryQuestLogFrame:GetHeight() * self.FyMult)
	self:moveObject(ArmoryQuestLogFrame, "+", 30, nil, nil)
	self:keepRegions(ArmoryQuestLogFrame, {1, 7, 11}) -- N.B. region 1 is dummy, regions 7 & 11 are text
	self:moveObject(ArmoryQuestLogTitleText, nil, nil, "+", 10)
	self:keepFontStrings(ArmoryQuestLogCount)
	self:moveObject(ArmoryQuestLogCount, "+", 230, "+", 324)
	self:moveObject(ArmoryQuestLogFrameCloseButton, "+", 30, "+", 8)

	-- movement values
	local xOfs, yOfs = 8, 24
	self:moveObject(ArmoryQuestLogExpandButtonFrame, "-", xOfs, "+", yOfs)
	self:removeRegions(ArmoryQuestLogCollapseAllButton, {5, 6, 7})
	self:moveObject(ArmoryQuestLogQuestCount, nil, nil, "-", 20)
	self:moveObject(ArmoryQuestLogTitle1, "-", xOfs, "+", yOfs)
	self:moveObject(ArmoryQuestLogListScrollFrame, "-", xOfs, "+", yOfs)
	self:keepFontStrings(ArmoryEmptyQuestLogFrame)

	ArmoryQuestLogQuestTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
	ArmoryQuestLogObjectivesText:SetTextColor(self.BTr, self.BTg, self.BTb)
	for i = 1, 10 do
		local r, g, b, a = _G["ArmoryQuestLogObjective"..i]:GetTextColor()
		_G["ArmoryQuestLogObjective"..i]:SetTextColor(self.BTr - r, self.BTg - g, self.BTb)
	end
	ArmoryQuestLogSuggestedGroupNum:SetTextColor(self.HTr, self.HTg, self.HTb)
	ArmoryQuestLogDescriptionTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
	ArmoryQuestLogQuestDescription:SetTextColor(self.BTr, self.BTg, self.BTb)

	self:skinScrollBar(ArmoryQuestLogListScrollFrame)
	self:skinScrollBar(ArmoryQuestLogDetailScrollFrame)
	self:applySkin(ArmoryQuestLogFrame)

-->>--	Spellbook
	ArmorySpellBookFrame:SetWidth(ArmorySpellBookFrame:GetWidth() * self.FxMult)
	ArmorySpellBookFrame:SetHeight(ArmorySpellBookFrame:GetHeight() * self.FyMult)
	self:moveObject(ArmorySpellBookFrame, "+", 30, nil, nil)
	self:keepFontStrings(ArmorySpellBookFrame)
	self:moveObject(ArmoryShowAllSpellRanksCheckBox, nil, nil, "+", 15)
	self:moveObject(ArmorySpellBookTitleText, "-", 6, "-", 20)
	self:moveObject(ArmorySpellBookCloseButton, "+", 28, "+", 9)
	self:moveObject(ArmorySpellBookPageText, nil, nil, "-", 70)
	self:moveObject(ArmorySpellBookPrevPageButton, nil, nil, "-", 70)
	self:moveObject(ArmorySpellBookNextPageButton, nil, nil, "-", 70)
	self:applySkin(ArmorySpellBookFrame)

	for i = 1, SPELLS_PER_PAGE do
		self:removeRegions(_G["ArmorySpellButton"..i], {1})
		if i == 1 then self:moveObject(_G["ArmorySpellButton"..i], "-" , 10, "+", 20) end
		_G["ArmorySpellButton"..i.."SpellName"]:SetTextColor(self.HTr, self.HTg, self.HTb)
		_G["ArmorySpellButton"..i.."SubSpellName"]:SetTextColor(self.BTr, self.BTg, self.BTb)
	end

	for i = 1, MAX_SKILLLINE_TABS do
		local tabName = _G["ArmorySpellBookSkillLineTab"..i]
		self:removeRegions(tabName, {1}) -- N.B. other regions are icon and highlight
--		self:Debug("SBSLT: [%s, %s]", tabName:GetWidth(), tabName:GetHeight())
		tabName:SetWidth(tabName:GetWidth() * 1.25)
		tabName:SetHeight(tabName:GetHeight() * 1.25)
		if i == 1 then self:moveObject(tabName, "+", 30, nil, nil) end
		self:applySkin(tabName)
	end

-->>-- Glyphs SubFrame
	self:removeRegions(ArmoryGlyphFrame, {1, 2})
	ArmoryGlyphFrameTitleText:SetAlpha(0)
--	self:moveObject(ArmoryGlyphFrameTitleText, "-", 20, "+", 8)
	for i = 1, ARMORY_NUM_GLYPH_SLOTS do
		local glyphBtn = _G["ArmoryGlyphFrameGlyph"..i]
		self:moveObject(glyphBtn, "-", 10, nil, nil)
	end

-->>-- Spellbook Frame Tabs
	for i = 1, 3 do
		local tabName = _G["ArmorySpellBookFrameTabButton"..i]
		self:keepRegions(tabName, {1, 3}) -- N.B. region 1 is the Text, 3 is the highlight
		tabName:SetWidth(tabName:GetWidth() * self.FTyMult)
		tabName:SetHeight(tabName:GetHeight() * self.FTxMult)
		local left, right, top, bottom = tabName:GetHitRectInsets()
--		self:Debug("ASBFTB: [%s, %s, %s, %s, %s]", i, left, right, top, bottom)
		tabName:SetHitRectInsets(left * self.FTyMult, right * self.FTyMult, top * self.FTxMult, bottom * self.FTxMult)
		if self.db.profile.TexturedTab then
			self:applySkin(tabName, nil, 0, 1)
			self:setInactiveTab(tabName)
		else self:applySkin(tabName) end
		if i == 1 then
			self:moveObject(tabName, "-", 12, "-", 70)
			if self.db.profile.TexturedTab then self:setActiveTab(tabName) end
		else
			self:moveObject(tabName, "+", 15, nil, nil)
		end
	end
	if self.db.profile.TexturedTab then
		-- hook this for Tabs
		self:SecureHook("ArmoryToggleSpellBook", function(bookType)
			for i = 1, 3 do
				local tabName = _G["ArmorySpellBookFrameTabButton"..i]
				if tabName.bookType == bookType then self:setActiveTab(tabName)
				else self:setInactiveTab(tabName) end
			end
		end)
	end

-->>-- Achievements
	ArmoryAchievementFrame:SetWidth(ArmoryAchievementFrame:GetWidth() * self.FxMult)
	ArmoryAchievementFrame:SetHeight(ArmoryAchievementFrame:GetHeight() * self.FyMult)
	self:moveObject(ArmoryAchievementFrame, "+", 30, nil, nil)
	self:keepFontStrings(ArmoryAchievementFrame)
	self:moveObject(ArmoryAchievementFrameTitleText, nil, nil, "+", 12)
	self:moveObject(ArmoryAchievementFrameCloseButton, "+", 28, "+", 8)
	self:moveObject(AchievementFramePoints, "-", 10, "+", 15)
	self:skinEditBox(ArmoryAchievementFrameEditBox, {9})
	self:moveObject(ArmoryAchievementFrameEditBox, nil, nil, "+", 15)
	self:moveObject(ArmoryAchievementExpandButtonFrame, "-", 15, nil, nil)
	self:removeRegions(ArmoryAchievementCollapseAllButton, {1, 2, 3}) -- textures
	self:moveObject(ArmoryAchievementListScrollFrame, "+", 35, "+", 12)
	self:keepFontStrings(ArmoryAchievementListScrollFrame)
	self:skinScrollBar(ArmoryAchievementListScrollFrame)

	for i = 1, ARMORY_NUM_FACTIONS_DISPLAYED do
--		if i == 1 then self:moveObject(_G["ArmoryAchievementBar"..i], "+", 30, nil, nil) end
		self:glazeStatusBar(_G["ArmoryAchievementBar"..i.."AchievementBar"], 0)
		_G["ArmoryAchievementBar"..i.."Background"]:SetAlpha(0)
		_G["ArmoryAchievementBar"..i.."AchievementBarLeftTexture"]:SetAlpha(0)
		_G["ArmoryAchievementBar"..i.."AchievementBarRightTexture"]:SetAlpha(0)
	end
	self:applySkin(ArmoryAchievementFrame)
	
	local function moveRow(row)
		Skinner:Debug("moveRow")
		Skinner:moveObject(row, "+", 40, "+", 10)
		moveRow = nil
	end
	-- hook this to manage displaying the rows
	self:SecureHook("ArmoryAchievementFrame_SetRowType", function(achievementRow, rowType, hasQuantity)
		self:Debug("AAF_SRT: [%s]", achievementRow:GetName())
		if achievementRow == ArmoryAchievementBar1 and moveRow then moveRow(achievementRow) end
		local achievementRowName = achievementRow:GetName()
		local sBar = _G[achievementRowName.."AchievementBar"]
		if sBar:GetValue() == 0 then sBar.bg:Hide() else sBar.bg:Show() end
	end)
	-- hook these to stop rows being moved
	self:RawHookScript(ArmoryAchievementListScrollFrame, "OnShow", function(this) end, true)
	self:RawHookScript(ArmoryAchievementListScrollFrame, "OnHide", function(this) end, true)


-->>-- Achievements Frame Tabs
	for i = 1, ArmoryAchievementFrame.numTabs do
		local tabName = _G["ArmoryAchievementFrameTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		if self.db.profile.TexturedTab then
			self:applySkin(tabName, nil, 0, 1)
			self:setInactiveTab(tabName)
		else self:applySkin(tabName) end
		if i == 1 then
			self:moveObject(tabName, nil, nil, "-", 70)
			if self.db.profile.TexturedTab then self:setActiveTab(tabName) end
		else
			self:moveObject(tabName, "+", 12, nil, nil)
		end
	end
	if self.db.profile.TexturedTab then
		-- hook this for Tabs
		self:SecureHook("ArmoryAchievementFrameTab_OnClick", function(selectedTab)
			for i = 1, ArmoryAchievementFrame.numTabs do
				local tabName = _G["ArmoryAchievementFrameTab"..i]
				if tabName == selectedTab then self:setActiveTab(tabName)
				else self:setInactiveTab(tabName) end
			end
		end)
	end

-->>--	Tradeskills
	ArmoryTradeSkillFrame:SetWidth(ArmoryTradeSkillFrame:GetWidth() * self.FxMult)
	ArmoryTradeSkillFrame:SetHeight(ArmoryTradeSkillFrame:GetHeight() * self.FyMult)
	self:moveObject(ArmoryTradeSkillFrame, "+", 30, nil, nil)
	self:keepFontStrings(ArmoryTradeSkillFrame)
	self:moveObject(ArmoryTradeSkillFrameTitleText, nil, nil, "+", 12)
	self:moveObject(ArmoryTradeSkillFrameCloseButton, "+", 28, "+", 8)
	self:moveObject(ArmoryTradeSkillRankFrame, "-", 40, "+", 14)
	self:removeRegions(ArmoryTradeSkillRankFrameBorder, {1}) -- N.B. region 2 is bar texture
	self:glazeStatusBar(ArmoryTradeSkillRankFrame, 0)
	self:skinEditBox(ArmoryTradeSkillFrameEditBox, {9})
	self:removeRegions(ArmoryTradeSkillExpandButtonFrame)
	self:moveObject(ArmoryTradeSkillExpandButtonFrame, "-", 6, "+", 12)
	self:skinDropDown(ArmoryTradeSkillSubClassDropDown)
	self:skinDropDown(ArmoryTradeSkillInvSlotDropDown)
	self:moveObject(ArmoryTradeSkillInvSlotDropDown, "+", 20, "+", 12)
	self:moveObject(ArmoryTradeSkillSkill1, "-", 6, "+", 12)
	self:moveObject(ArmoryTradeSkillListScrollFrame, "+", 35, "+", 12)
	self:keepFontStrings(ArmoryTradeSkillListScrollFrame)
	self:skinScrollBar(ArmoryTradeSkillListScrollFrame)
	self:moveObject(ArmoryTradeSkillDetailScrollFrame, "+", 2, "+", 12)
	self:keepFontStrings(ArmoryTradeSkillDetailScrollFrame)
	self:skinScrollBar(ArmoryTradeSkillDetailScrollFrame)
	for i = 1, 8 do
		self:moveObject(_G["ArmoryTradeSkillReagent"..i.."Count"], "+", 4, nil, nil)
	end
	self:applySkin(ArmoryTradeSkillFrame)

end
