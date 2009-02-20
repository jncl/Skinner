
function Skinner:Armory()

-->>--	Main Frame
	ArmoryFrame:SetWidth(ArmoryFrame:GetWidth() * self.FxMult)
	ArmoryFrame:SetHeight(ArmoryFrame:GetHeight() * self.FyMult)
	self:keepFontStrings(ArmoryFrame)
	self:moveObject(ArmoryNameFrame, nil, nil, "-", 24)
	self:moveObject(ArmoryFrameCloseButton, "+", 28, "+", 8)
	self:keepFontStrings(ArmoryNameDropDown)
	self:moveObject(ArmoryFrameLeftButton, "-", 10, "+", 40)
	self:moveObject(ArmoryFrameRightButton, "-", 10, "+", 40)
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
	self:resizeTabs(ArmoryFrame)

-->>--	Frame Line Tabs
	for i = 1, 7 do
		local tabName = _G["ArmoryFrameLineTab"..i]
		self:removeRegions(tabName, {1}) -- N.B. region 2 is the icon, 3 is the text
		-- Move the first entry as all the others are positioned from it
		if i == 1 then self:moveObject(tabName, "+", 30, "-", 0) end
	end

	if self.db.profile.TexturedTab then
		-- Hook this for Tabs
		self:SecureHook("ArmoryFrame_ShowSubFrame", function(frameName)
--			self:Debug("AF_SSF: [%s, %s]", frameName, ArmoryFrame.selectedTab)
			for i = 1, 5 do
				local tabName = _G["ArmoryFrameTab"..i]
				if i == ArmoryFrame.selectedTab then self:setActiveTab(tabName)
				else self:setInactiveTab(tabName) end
			end
		end)
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
	self:applySkin(ArmoryPaperDollTradeSkillFrame)
	ArmoryHealthFrame:SetHeight(ArmoryHealthFrame:GetHeight() + 4)
	self:keepFontStrings(ArmoryHealthFrame)
	self:applySkin(ArmoryHealthFrame)
	ArmoryAttributesFrame:SetHeight(ArmoryAttributesFrame:GetHeight() + 10)
	self:keepFontStrings(ArmoryAttributesFrame)
	self:applySkin(ArmoryAttributesFrame)
	self:keepFontStrings(ArmoryPlayerStatFrameLeftDropDown)
	self:keepFontStrings(ArmoryPlayerStatFrameRightDropDown)

-->>--	Talents Frame
	self:keepRegions(ArmoryTalentFrame, {5, 6, 7, 8}) -- N.B. 5, 6, 7 & 8 are the background picture
	self:moveObject(ArmoryTalentFrameBackgroundTopLeft, nil, nil, "+", 10)
	ArmoryTalentFrameBackgroundBottomLeft:SetHeight(168)
	ArmoryTalentFrameBackgroundBottomRight:SetHeight(168)
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
	self:moveObject(ArmoryPVPHonorTodayHonor, "+", 22, nil, nil)
	self:moveObject(ArmoryPVPTeam1Standard, "-", 10, "+", 10)
	self:moveObject(ArmoryPVPTeam2Standard, "-", 10, "+", 10)
	self:moveObject(ArmoryPVPTeam3Standard, "-", 10, "+", 10)
	self:moveObject(ArmoryPVPFrameToggleButton, "+", 30, "-", 74)

-->>--	PVP Team Details Frame
	self:keepFontStrings(ArmoryPVPTeamDetails)
	self:keepFontStrings(ArmoryPVPDropDown)
	self:moveObject(ArmoryPVPTeamDetails, "+", 25, nil, nil)
	self:moveObject(ArmoryPVPTeamDetailsAddTeamMember, "-", 10, "-", 10)
	self:moveObject(ArmoryPVPTeamDetailsToggleButton, "+", 10, "-", 10)
	self:applySkin(ArmoryPVPTeamDetails)

-->>--	Other Frame (parent for the Reputation, Skills & RaidInfo Frames)
	self:keepFontStrings(ArmoryOtherFrame)

	for i = 1, 5 do
		local tabName = _G["ArmoryOtherFrameTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		self:applySkin(tabName)
		self:moveObject(_G["ArmoryOtherFrameTab"..i.."HighlightTexture"], "-", 2, "+", 5)
		if i == 1 then self:moveObject(tabName, nil, nil, "+", 10)
		else self:moveObject(tabName, "+", 4, nil, nil) end
	end

-->>--	Reputation Frame
	self:keepFontStrings(ArmoryReputationFrame)
	local xOfs, yOfs = 5, 20
	self:moveObject(ArmoryReputationFrameFactionLabel, "-", xOfs, "+", yOfs)
	self:moveObject(ArmoryReputationFrameStandingLabel, "-", xOfs, "+", yOfs)
	self:moveObject(ArmoryReputationBar1, "-", xOfs, "+", yOfs)

	for i = 1, ARMORY_NUM_FACTIONS_DISPLAYED do
		self:keepFontStrings(_G["ArmoryReputationBar"..i])
		self:glazeStatusBar(_G["ArmoryReputationBar"..i], 0)
	end

	self:removeRegions(ArmoryReputationListScrollFrame)
	self:moveObject(ArmoryReputationListScrollFrame, "+", 35, "+", 10)
	self:skinScrollBar(ArmoryReputationListScrollFrame)

-->>--	Skills Frame
	self:keepFontStrings(ArmorySkillFrame)

	local xOfs, yOfs = 5, 10
	self:removeRegions(ArmorySkillFrameExpandButtonFrame)
	self:moveObject(ArmorySkillFrameExpandButtonFrame, "-", 57, "+", yOfs)
	self:moveObject(ArmorySkillTypeLabel1, "-", xOfs, "+", yOfs)
	self:moveObject(ArmorySkillRankFrame1, "-", xOfs, "+", yOfs)
	self:removeRegions(ArmorySkillListScrollFrame)
	self:moveObject(ArmorySkillListScrollFrame, "+", 35, "+", yOfs)
	self:skinScrollBar(ArmorySkillListScrollFrame)

	for i = 1, ARMORY_NUM_SKILLS_DISPLAYED do
		self:removeRegions(_G["ArmorySkillRankFrame"..i.."Border"], {1}) -- N.B. region 2 is highlight
		self:glazeStatusBar(_G["ArmorySkillRankFrame"..i], 0)
	end

	self:removeRegions(ArmorySkillDetailScrollFrame)
	self:skinScrollBar(ArmorySkillDetailScrollFrame)
	self:keepFontStrings(ArmorySkillDetailStatusBar)
	self:glazeStatusBar(ArmorySkillDetailStatusBar, 0)
	self:moveObject(ArmorySkillFrameCancelButton, "-", 8, "-", 6)

-->>--	RaidInfo Frame
	self:keepFontStrings(ArmoryRaidInfoFrame)
	self:keepFontStrings(ArmoryRaidInfoScrollFrame)
	self:skinScrollBar(ArmoryRaidInfoScrollFrame)

-->>--	Inventory Frame
	self:moveObject(ArmoryInventoryFrame, "+", 30, nil, nil)
	ArmoryInventoryFrame:SetWidth(ArmoryInventoryFrame:GetWidth() * self.FxMult)
	ArmoryInventoryFrame:SetHeight(ArmoryInventoryFrame:GetHeight() * self.FyMult)
	self:moveObject(ArmoryInventoryFrameTitleText, nil, nil, "+", 10)
	self:moveObject(ArmoryInventoryFrameCloseButton, "+", 29, "+", 8)
	self:moveObject(ArmoryInventoryMoneyBackgroundFrame, "-", 40, "+", 20)
	self:keepFontStrings(ArmoryInventoryMoneyBackgroundFrame)
	self:moveObject(ArmoryInventoryExpandButtonFrame, "+", 10, "+", 20)
	self:keepFontStrings(ArmoryInventoryExpandButtonFrame)
	self:moveObject(ArmoryInventoryFrameListViewCheckButton, nil, nil, "+", 20)
	self:keepFontStrings(ArmoryInventoryFrame)
	self:applySkin(ArmoryInventoryFrame)
	-- Icon View Frame
	self:moveObject(ArmoryInventoryIconViewFrame, "+", 24, "+", 20)
	self:keepFontStrings(ArmoryInventoryIconViewFrame)
	self:skinScrollBar(ArmoryInventoryIconViewFrame)
	-- List View Frame
	self:moveObject(ArmoryInventoryListViewFrame, "+", 26, "+", 20)
	self:keepFontStrings(ArmoryInventoryListViewScrollFrame)
	self:skinScrollBar(ArmoryInventoryListViewScrollFrame)
	self:skinEditBox(ArmoryInventoryListViewFrameEditBox, {9})

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

	self:moveObject(ArmoryQuestLogFrame, "+", 30, nil, nil)
	ArmoryQuestLogFrame:SetWidth(ArmoryQuestLogFrame:GetWidth() * self.FxMult)
	ArmoryQuestLogFrame:SetHeight(ArmoryQuestLogFrame:GetHeight() * self.FyMult)
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
	self:moveObject(ArmoryQuestLogFrameAbandonButton, "-", 12, "-", 47)
	self:moveObject(ArmoryQuestFrameExitButton, "+", 32, "-", 47)
	self:applySkin(ArmoryQuestLogFrame)

-->>--	Spellbook
	self:moveObject(ArmorySpellBookFrame, "+", 30, nil, nil)
	self:keepFontStrings(ArmorySpellBookFrame)
	ArmorySpellBookFrame:SetWidth(ArmorySpellBookFrame:GetWidth() * self.FxMult)
	ArmorySpellBookFrame:SetHeight(ArmorySpellBookFrame:GetHeight() * self.FyMult)
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

	for i = 1, 3 do
		local tabName = _G["ArmorySpellBookFrameTabButton"..i]
		self:keepRegions(tabName, {1, 3}) -- N.B. region 1 is the Text, 3 is the highlight
		tabName:SetHeight(tabName:GetHeight() * self.FTxMult)
		local left, right, top, bottom = tabName:GetHitRectInsets()
--		self:Debug("SBFTB: [%s, %s, %s, %s, %s]", i, left, right, top, bottom)
		tabName:SetHitRectInsets(left * self.FTyMult, right * self.FTyMult, top * self.FTxMult, bottom * self.FTxMult)

		if self.db.profile.TexturedTab then self:applySkin(tabName, nil, 0)
		else self:applySkin(tabName) end
		if i == 1 then
			self:moveObject(tabName, nil, nil, "-", 70)
			if self.db.profile.TexturedTab then self:setActiveTab(tabName) end
		else
			self:moveObject(tabName, "+", 15, nil, nil)
			if self.db.profile.TexturedTab then self:setInactiveTab(tabName) end
		end

	end

-->>--	Tradeskills
	self:moveObject(ArmoryTradeSkillFrame, "+", 30, nil, nil)
	self:keepFontStrings(ArmoryTradeSkillFrame)
	ArmoryTradeSkillFrame:SetWidth(ArmoryTradeSkillFrame:GetWidth() * self.FxMult)
	ArmoryTradeSkillFrame:SetHeight(ArmoryTradeSkillFrame:GetHeight() * self.FyMult)
	self:moveObject(ArmoryTradeSkillFrameTitleText, nil, nil, "+", 12)
	self:moveObject(ArmoryTradeSkillFrameCloseButton, "+", 28, "+", 8)
	self:moveObject(ArmoryTradeSkillRankFrame, "-", 40, "+", 14)
	self:removeRegions(ArmoryTradeSkillRankFrameBorder, {1}) -- N.B. region 2 is bar texture
	self:glazeStatusBar(ArmoryTradeSkillRankFrame, 0)
	self:moveObject(ArmoryTradeSkillFrameAvailableFilterCheckButton, "-", 38, "+", 12)
	self:skinEditBox(ArmoryTradeSkillFrameEditBox, {9})
	self:removeRegions(ArmoryTradeSkillExpandButtonFrame)
	self:moveObject(ArmoryTradeSkillExpandButtonFrame, "-", 6, "+", 12)
	self:keepFontStrings(ArmoryTradeSkillSubClassDropDown)
	self:keepFontStrings(ArmoryTradeSkillInvSlotDropDown)
	self:moveObject(ArmoryTradeSkillInvSlotDropDown, "+", 20, "+", 12)
	self:moveObject(ArmoryTradeSkillSkill1, "-", 6, "+", 12)
	self:keepFontStrings(ArmoryTradeSkillListScrollFrame)
	self:moveObject(ArmoryTradeSkillListScrollFrame, "+", 35, "+", 12)
	self:skinScrollBar(ArmoryTradeSkillListScrollFrame)
	self:keepFontStrings(ArmoryTradeSkillDetailScrollFrame)
	self:moveObject(ArmoryTradeSkillDetailScrollFrame, "+", 2, "+", 12)
	self:skinScrollBar(ArmoryTradeSkillDetailScrollFrame)
	self:moveObject(ArmoryTradeSkillInputBox, "-", 5, nil, nil)
	self:skinEditBox(ArmoryTradeSkillInputBox)
	self:moveObject(ArmoryTradeSkillCreateButton, "-", 10, "-", 5)
	self:moveObject(ArmoryTradeSkillCancelButton, "-", 7, "-", 5)
	for i = 1, 8 do
		self:moveObject(_G["ArmoryTradeSkillReagent"..i.."Count"], "+", 4, nil, nil)
	end
	self:applySkin(ArmoryTradeSkillFrame)

end
