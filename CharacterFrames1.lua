local ftype = "c"

function Skinner:CharacterFrames()
	if not self.db.profile.CharacterFrames or self.initialized.CharacterFrames then return end
	self.initialized.CharacterFrames = true

	local cfSubframes = {"PaperDollFrame", "PetPaperDollFrame", "ReputationFrame", "SkillFrame", "TokenFrame"}

	if self.isTT then
		-- hook this to change the texture for the Active and Inactive tabs
		self:SecureHook("CharacterFrame_ShowSubFrame",function(frameName)
--			self:Debug("CF_SSF: [%s]", frameName)
			for i, v in pairs(cfSubframes) do
				local tabSF = self.skinFrame[_G["CharacterFrameTab"..i]]
				if v == frameName then
					self:setActiveTab(tabSF)
				else
					self:setInactiveTab(tabSF)
				end
			end
		end)
	end

	-- skin each sub frame
	self:checkAndRun("CharacterFrame")
	for _, v in pairs(cfSubframes) do
		self:checkAndRun(v)
	end

end

function Skinner:CharacterFrame()

	self:keepFontStrings(CharacterFrame)
	self:skinDropDown(PlayerTitleDropDown)
	self:skinDropDown(PlayerStatFrameLeftDropDown, true)
	self:skinDropDown(PlayerStatFrameRightDropDown, true)
	self:addSkinFrame(CharacterFrame, 10, -12, -32, 71, ftype)

--	CharacterFrameTab1-5
	for i = 1, #CHARACTERFRAME_SUBFRAMES do
		local tabName = _G["CharacterFrameTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		self:addSkinFrame(tabName, 6, 0, -6, 2, ftype, self.isTT)
		local tabSF = self.skinFrame[tabName]
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end

end

function Skinner:PaperDollFrame()

	self:keepFontStrings(PaperDollFrame)

	CharacterModelFrameRotateLeftButton:Hide()
	CharacterModelFrameRotateRightButton:Hide()
	self:makeMFRotatable(CharacterModelFrame)
	self:keepFontStrings(CharacterAttributesFrame)
	self:removeRegions(CharacterAmmoSlot, {1})

end

function Skinner:PetPaperDollFrame()

	self:keepFontStrings(PetPaperDollFrame)

-->>-- Pet Frame
	self:keepFontStrings(PetAttributesFrame)
	self:keepRegions(PetPaperDollFrameExpBar, {3, 4}) -- N.B. region 3 is text
	self:glazeStatusBar(PetPaperDollFrameExpBar, 0)
	PetModelFrameRotateLeftButton:Hide()
	PetModelFrameRotateRightButton:Hide()
	self:makeMFRotatable(PetModelFrame)
	-- up the Frame level otherwise the tooltip doesn't work
	RaiseFrameLevel(PetPaperDollPetInfo)

-->>-- Companion Frame
	self:keepFontStrings(PetPaperDollFrameCompanionFrame)
	CompanionModelFrameRotateLeftButton:Hide()
	CompanionModelFrameRotateRightButton:Hide()
	self:makeMFRotatable(CompanionModelFrame)

-->>-- Tabs
	self:skinFFToggleTabs("PetPaperDollFrameTab")

end

function Skinner:ReputationFrame()

	self:keepFontStrings(ReputationFrame)

	local yOfs = 20
	self:moveObject(ReputationFrameFactionLabel, nil, nil, "+", yOfs)
	self:moveObject(ReputationFrameStandingLabel, nil, nil, "+", yOfs)
	-- hook this to move ReputationBar1 up
	self:RawHook(ReputationBar1, "SetPoint", function(this, point, relTo, relPoint, xPosn, yPosn)
		self.hooks[this].SetPoint(this, point, relTo, relPoint, xPosn, yPosn + yOfs)
	end, true)
	self:moveObject(ReputationListScrollFrame, nil, nil, "+", yOfs)
	self:removeRegions(ReputationListScrollFrame)
	self:skinScrollBar(ReputationListScrollFrame)

	-- glaze all the rep bars
	for i = 1, NUM_FACTIONS_DISPLAYED do
		_G["ReputationBar"..i.."Background"]:SetAlpha(0)
		_G["ReputationBar"..i.."ReputationBarLeftTexture"]:SetAlpha(0)
		_G["ReputationBar"..i.."ReputationBarRightTexture"]:SetAlpha(0)
		self:glazeStatusBar(_G["ReputationBar"..i.."ReputationBar"], 0)
	end
	
-->>-- Reputation Detail Frame
	self:keepFontStrings(ReputationDetailFrame)
	ReputationDetailFrame:SetBackdrop(nil)
	self:addSkinFrame(ReputationDetailFrame, 0, 0, 0, 0, ftype)

end

function Skinner:SkillFrame()

	self:keepFontStrings(SkillFrame)

	self:removeRegions(SkillFrameExpandButtonFrame)
	self:removeRegions(SkillListScrollFrame)
	self:skinScrollBar(SkillListScrollFrame)

	for i = 1, SKILLS_TO_DISPLAY do
		self:keepRegions(_G["SkillRankFrame"..i.."Border"], {2}) -- N.B. region 2 is highlight
		self:glazeStatusBar(_G["SkillRankFrame"..i], 0)
	end

	self:removeRegions(SkillDetailScrollFrame)
	self:skinScrollBar(SkillDetailScrollFrame)
	self:keepFontStrings(SkillDetailStatusBar)
	SkillDetailStatusBarBackground:SetTexture(self.sbTexture)
	self:glazeStatusBar(SkillDetailStatusBar, 0)

end

function Skinner:TokenFrame() -- a.k.a. Currency Frame

	if self.db.profile.ContainerFrames.skin then
		BACKPACK_TOKENFRAME_HEIGHT = BACKPACK_TOKENFRAME_HEIGHT - 6
		self:SecureHook("ManageBackpackTokenFrame", function(backpack)
--			self:Debug("MBTF:[%s]", backpack or "nil")
			if not backpack then backpack = GetBackpackFrame() end
			if not backpack then return end
--			self:Debug("MBTF#2:[%s, %s]", backpack, backpack:GetName())
			if BackpackTokenFrame_IsShown() then
				self:keepFontStrings(BackpackTokenFrame)
				BackpackTokenFrame:SetPoint("BOTTOMLEFT", backpack, "BOTTOMLEFT", 0, -4)
			end
		end)
	end

	self:keepFontStrings(TokenFrame)
	self:removeRegions(TokenFrameContainer)
	self:skinScrollBar(TokenFrameContainer)
--	self:getChild(TokenFrame, 4):Hide() -- what is this ??

	-- remove header textures
	for i = 1, #TokenFrameContainer.buttons do
		TokenFrameContainer.buttons[i].categoryLeft:SetAlpha(0)
		TokenFrameContainer.buttons[i].categoryRight:SetAlpha(0)
	end

-->>-- Popup Frame
	self:keepFontStrings(TokenFramePopup)
	TokenFramePopup:SetBackdrop(nil)
	self:addSkinFrame(TokenFramePopup, 0, 0, 0, 0, ftype)

end

function Skinner:PVPFrame()
	if not self.db.profile.PVPFrame or self.initialized.PVPFrame then return end
	self.initialized.PVPFrame = true

	if self.isTT then
		self:SecureHookScript(PVPFrame, "OnShow", function(this)
			self:setActiveTab(self.skinFrame[PVPParentFrameTab1])
			self:setInactiveTab(self.skinFrame[PVPParentFrameTab2])
		end)
		self:SecureHookScript(PVPBattlegroundFrame, "OnShow", function(this)
			self:setActiveTab(self.skinFrame[PVPParentFrameTab2])
			self:setInactiveTab(self.skinFrame[PVPParentFrameTab1])
		end)
	end
	
	self:keepFontStrings(PVPFrame)
	self:keepFontStrings(PVPParentFrame)
	self:addSkinFrame(PVPParentFrame, 10, -12, -32, 71, ftype)
	
-->>-- PVP Battleground Frame
	self:keepFontStrings(PVPBattlegroundFrame)
	self:keepFontStrings(PVPBattlegroundFrameInstanceScrollFrame)
	self:skinScrollBar(PVPBattlegroundFrameInstanceScrollFrame)
	PVPBattlegroundFrameZoneDescription:SetTextColor(self.BTr, self.BTg, self.BTb)
-->>-- PVP Team Details Frame
	self:keepFontStrings(PVPTeamDetails)
	self:skinDropDown(PVPDropDown)
	self:skinFFColHeads("PVPTeamDetailsFrameColumnHeader", 5)
	self:addSkinFrame(PVPTeamDetails, 8, -2, -2, 12, ftype)
	
-->>-- Tabs
	for i = 1, PVPParentFrame.numTabs do
		local tabName = _G["PVPParentFrameTab"..i]
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

function Skinner:PetStableFrame()
	if not self.db.profile.PetStableFrame or self.initialized.PetStableFrame then return end
	self.initialized.PetStableFrame = true

	self:keepFontStrings(PetStableFrame)
	PetStableModelRotateLeftButton:Hide()
	PetStableModelRotateRightButton:Hide()
	self:makeMFRotatable(PetStableModel)
	-- up the Frame level otherwise the tooltip doesn't work
	RaiseFrameLevel(PetStablePetInfo)
	self:addSkinFrame(PetStableFrame, 10, -12, -32, 71, ftype)

end

function Skinner:SpellBookFrame()
	if not self.db.profile.SpellBookFrame or self.initialized.SpellBookFrame then return end
	self.initialized.SpellBookFrame = true

	self:SecureHook("SpellBookFrame_Update", function(showing)
--		self:Debug("SpellBookFrame_Update: [%s]", showing)
		if SpellBookFrame.bookType ~= INSCRIPTION then
			SpellBookTitleText:Show()
		else
			SpellBookTitleText:Hide() -- hide Inscriptions title
		end
	end)

	if self.isTT then
		-- hook to handle tabs
		self:SecureHook("ToggleSpellBook", function(bookType)
--			self:Debug("ToggleSpellBook: [%s, %s, %s]", bookType, SpellBookFrame.bookType, INSCRIPTION)
			for i = 1, 3 do
				local tabName = _G["SpellBookFrameTabButton"..i]
				local tabSF = self.skinFrame[tabName]
				if tabName.bookType == bookType then
					self:setActiveTab(tabSF)
				else
					self:setInactiveTab(tabSF)
				end
			end
		end)
	end

	self:keepFontStrings(SpellBookFrame)
	self:addSkinFrame(SpellBookFrame, 10, -12, -32, 70, ftype)
	-- colour the spell name text
	for i = 1, SPELLS_PER_PAGE do
		self:removeRegions(_G["SpellButton"..i], {1})
		_G["SpellButton"..i.."SpellName"]:SetTextColor(self.HTr, self.HTg, self.HTb)
		_G["SpellButton"..i.."SubSpellName"]:SetTextColor(self.BTr, self.BTg, self.BTb)
	end

-->>-- Tabs (bottom)
	for i = 1, 3 do -- actually only 2, but 3 exist in xml file
		local tabName = _G["SpellBookFrameTabButton"..i]
		self:keepRegions(tabName, {1, 3}) -- N.B. region 1 is the Text, 3 is the highlight
		self:addSkinFrame(tabName, 14, -16, -10, 18, ftype, self.isTT)
		local tabSF = self.skinFrame[tabName]
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end
-->>-- Tabs (side)
	for i = 1, MAX_SKILLLINE_TABS do
		local tabName = _G["SpellBookSkillLineTab"..i]
		self:removeRegions(tabName, {1}) -- N.B. other regions are icon and highlight
	end

end

function Skinner:GlyphUI()
	if not self.db.profile.TalentUI or self.initialized.GlyphUI then return end
	self.initialized.GlyphUI = true

	self:removeRegions(GlyphFrame, {1}) -- background texture

end

function Skinner:TalentUI()
	if not self.db.profile.TalentUI or self.initialized.TalentUI then return end
	self.initialized.TalentUI = true

	local numTabs = MAX_TALENT_TABS + 1 -- add 1 for the Glyph talent tab
	-- hook this to manage textured tabs
	if self.isTT then
		self:SecureHook("TalentFrame_Update", function(this)
			local curTab
			curTab = this.selectedTab
--			self:Debug("TalentFrame_Update: [%s, %s, %s]", this:GetName(), numTabs, curTab)
			if this == PlayerTalentFrame then
				for i = 1, numTabs do
					local tabSF = self.skinFrame[_G["PlayerTalentFrameTab"..i]]
					if i == curTab then
						self:setActiveTab(tabSF)
					else
						self:setInactiveTab(tabSF)
					end
					-- check to see if this is the glyph frame, if so, hide some objects
					if i == numTabs and i == curTab then
						PlayerTalentFrameTitleText:Hide()
						PlayerTalentFrameScrollFrame:Hide()
						PlayerTalentFramePointsBar:Hide()
					else
						PlayerTalentFrameTitleText:Show()
						PlayerTalentFrameScrollFrame:Show()
						PlayerTalentFramePointsBar:Show()
					end
				end
			end
		end)
	end

	self:keepRegions(PlayerTalentFrame, {2, 7}) -- N.B. 2 is Active Spec Tab Highlight, 7 is the title
	self:removeRegions(PlayerTalentFrameScrollFrame, {5, 6}) -- other regions are background textures
	self:skinScrollBar(PlayerTalentFrameScrollFrame)
	self:keepFontStrings(PlayerTalentFrameStatusFrame)
	self:keepFontStrings(PlayerTalentFramePointsBar)
	self:keepFontStrings(PlayerTalentFramePreviewBar)
	self:keepFontStrings(PlayerTalentFramePreviewBarFiller)
	self:addSkinFrame(PlayerTalentFrame, 10, -12, -32, 71, ftype)

-->>-- Tabs (bottom)
	for i = 1, numTabs do
		local tabName = _G["PlayerTalentFrameTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		self:addSkinFrame(tabName, 6, 0, -6, 2, ftype, self.isTT)
		local tabSF = self.skinFrame[tabName]
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end
-->>-- Tabs (side)
	for i = 1, 3 do
		local tabName = _G["PlayerSpecTab"..i]
		self:removeRegions(tabName, {1}) -- N.B. other regions are icon and highlight
	end


end

function Skinner:DressUpFrame()
	if not self.db.profile.DressUpFrame or self.initialized.DressUpFrame then return end
	self.initialized.DressUpFrame = true

	self:removeRegions(DressUpFrame, {1, 2, 3, 4, 5}) -- N.B. regions 6 & 7 are text, 8-11 are the background picture
	DressUpModelRotateLeftButton:Hide()
	DressUpModelRotateRightButton:Hide()
	self:makeMFRotatable(DressUpModel)
	self:addSkinFrame(DressUpFrame, 10, -12, -32, 71, ftype)

end

function Skinner:AchievementUI()
	if not self.db.profile.AchieveFrame or self.initialized.AchieveFrame then return end
	self.initialized.AchieveFrame = true

	-- hook this to manage textured tabs
	if self.isTT then
		local function changeTT(id)
		
			for i = 1, AchievementFrame.numTabs do
				local tabSF = self.skinFrame[_G["AchievementFrameTab"..i]]
				if i == id then
					self:setActiveTab(tabSF)
				else
					self:setInactiveTab(tabSF)
				end
			end
			
		end
		self:SecureHook("AchievementFrameTab_OnClick", function(id)
			self:Debug("AFT_OC: [%s]", id)
			changeTT(id)
		end)
		self:SecureHook("AchievementFrameBaseTab_OnClick", function(id)
			self:Debug("AFBT_OC: [%s]", id)
			changeTT(id)
		end)
		self:SecureHook("AchievementFrameComparisonTab_OnClick", function(id)
			self:Debug("AFCT_OC: [%s]", id)
			changeTT(id)
		end)
	end

	local function skinSB(statusBar)
	
		_G[statusBar.."Left"]:SetAlpha(0)
		_G[statusBar.."Right"]:SetAlpha(0)
		_G[statusBar.."Middle"]:SetAlpha(0)
		Skinner:glazeStatusBar(_G[statusBar], 0)

	end

	local function skinStats()
	
		for i = 1, #AchievementFrameStatsContainer.buttons do
			local button = _G["AchievementFrameStatsContainerButton"..i]
			if button.isHeader then button.background:SetAlpha(0) end
-- 			self:Debug("skinStats: [%s]", button.background:GetAlpha())
			if button.background:GetAlpha() == 1 then button.background:SetAlpha(0) end
			button.left:SetAlpha(0)
			button.middle:SetAlpha(0)
			button.right:SetAlpha(0)
		end
		
	end
	
	local function glazeProgressBar(pBaro)
	
		if not Skinner.skinned[pBaro] then
			local pBar = pBaro:GetName()
			local pBarBG = Skinner:getRegion(pBaro, 1)
			pBarBG:SetTexture(Skinner.sbTexture)
			pBarBG:SetVertexColor(unpack(Skinner.sbColour))
			_G[pBar.."BorderLeft"]:SetAlpha(0)
			_G[pBar.."BorderRight"]:SetAlpha(0)
			_G[pBar.."BorderCenter"]:SetAlpha(0)
			Skinner:glazeStatusBar(pBaro)
			pBaro.bg = pBarBG -- store this so it will get retextured as required
		end
			
	end

	local function skinCategories()
		for i = 1, #AchievementFrameCategoriesContainer.buttons do
			_G["AchievementFrameCategoriesContainerButton"..i.."Background"]:SetAlpha(0)
		end
	end

	local function skinComparisonStats()
	
		for i = 1, #AchievementFrameComparisonStatsContainer.buttons do
			local buttonName = "AchievementFrameComparisonStatsContainerButton"..i
			if _G[buttonName].isHeader then _G[buttonName.."BG"]:SetAlpha(0) end
			_G[buttonName.."HeaderLeft"]:SetAlpha(0)
			_G[buttonName.."HeaderLeft2"]:SetAlpha(0)
			_G[buttonName.."HeaderMiddle"]:SetAlpha(0)
			_G[buttonName.."HeaderMiddle2"]:SetAlpha(0)
			_G[buttonName.."HeaderRight"]:SetAlpha(0)
			_G[buttonName.."HeaderRight2"]:SetAlpha(0)
		end
		
	end

	local bbR, bbG, bbB, bbA = unpack(self.bbColour)

	-- Hook this to skin the GameTooltip StatusBars
	self:SecureHook("GameTooltip_ShowStatusBar", function(this, ...)
--		self:Debug("GT_SSB:[%s, %s]", this:GetName(), ...)
		if GameTooltipStatusBar1 then
			self:removeRegions(GameTooltipStatusBar1, {2})
			self:glazeStatusBar(GameTooltipStatusBar1, 0)
		end
		if GameTooltipStatusBar2 then
			self:removeRegions(GameTooltipStatusBar2, {2})
			self:glazeStatusBar(GameTooltipStatusBar2, 0)
			self:Unhook("GameTooltip_ShowStatusBar")
		end
	end)

	self:keepFontStrings(AchievementFrame)
	AchievementFrame:SetBackdrop(nil)
	self:moveObject(AchievementFrameFilterDropDown, nil, nil, "-", 10)
	self:addSkinFrame(AchievementFrame, 0, 0, 0, -6, ftype)

-->>-- move Header info
	self:keepFontStrings(AchievementFrameHeader)
	self:moveObject(AchievementFrameHeaderTitle, "-", 60, "-", 29)
	self:moveObject(AchievementFrameHeaderPoints, "+", 40, "-", 9)
	AchievementFrameHeaderShield:SetAlpha(1)

-->>-- Categories Panel (on the Left)
	self:skinSlider(AchievementFrameCategoriesContainerScrollBar)
	self:storeAndSkin(ftype, AchievementFrameCategories)
	self:SecureHook("AchievementFrameCategories_Update", function()
--		self:Debug("AFC_U")
		skinCategories()
	end)
	skinCategories()

-->>-- Achievements Panel (on the right)
	self:keepFontStrings(AchievementFrameAchievements)
	self:getChild(AchievementFrameAchievements, 2):SetBackdropBorderColor(bbR, bbG, bbB, bbA) -- frame border
	self:skinSlider(AchievementFrameAchievementsContainerScrollBar)
	-- glaze any existing progress bars
	for i = 1, 10 do
		local pBar = "AchievementFrameProgressBar"..i
		local pBaro = _G[pBar]
		if pBaro then glazeProgressBar(pBar, pBaro) end
	end
	-- hook this to skin StatusBars used by the Objectives mini panels
	self:RawHook("AchievementButton_GetProgressBar", function(index)
		local pBar = self.hooks["AchievementButton_GetProgressBar"](index)
--		self:Debug("AB_GPB:[%s, %s]", index, pBar:GetName() or "<Anon>")
		glazeProgressBar(pBar)
		return pBar
	end, true)

-->>-- Stats
	self:keepFontStrings(AchievementFrameStats)
	self:skinSlider(AchievementFrameStatsContainerScrollBar)
	AchievementFrameStatsBG:SetAlpha(0)
	self:getChild(AchievementFrameStats, 3):SetBackdropBorderColor(bbR, bbG, bbB, bbA) -- frame border
	
	self:SecureHook("AchievementFrameStats_Update", function()
-- 		self:Debug("AFS_U")
		skinStats()
	end)
	skinStats()

-->>-- Summary Panel
	self:keepFontStrings(AchievementFrameSummary)
	AchievementFrameSummaryBackground:SetAlpha(0)
	AchievementFrameSummaryAchievementsHeaderHeader:SetAlpha(0)
	self:skinSlider(AchievementFrameAchievementsContainerScrollBar)
	-- Categories SubPanel
	self:keepFontStrings(AchievementFrameSummaryCategoriesHeader)
	for i = 1, 8 do
		skinSB("AchievementFrameSummaryCategoriesCategory"..i)
	end
	self:getChild(AchievementFrameSummary, 1):SetBackdropBorderColor(bbR, bbG, bbB, bbA) -- frame border
	skinSB("AchievementFrameSummaryCategoriesStatusBar")

-->>-- Comparison Panel
	AchievementFrameComparisonBackground:SetAlpha(0)
	AchievementFrameComparisonDark:SetAlpha(0)
	AchievementFrameComparisonWatermark:SetAlpha(0)
	-- Header
	self:keepFontStrings(AchievementFrameComparisonHeader)
	AchievementFrameComparisonHeaderShield:SetAlpha(1)
	AchievementFrameComparisonHeaderShield:ClearAllPoints()
	AchievementFrameComparisonHeaderShield:SetPoint("RIGHT", AchievementFrameCloseButton, "LEFT", -10, -1)
	AchievementFrameComparisonHeaderPoints:ClearAllPoints()
	AchievementFrameComparisonHeaderPoints:SetPoint("RIGHT", AchievementFrameComparisonHeaderShield, "LEFT", -10, 1)
	AchievementFrameComparisonHeaderName:ClearAllPoints()
	AchievementFrameComparisonHeaderName:SetPoint("RIGHT", AchievementFrameComparisonHeaderPoints, "LEFT", -10, 0)
	-- Container
	self:skinSlider(AchievementFrameComparisonContainerScrollBar)

	-- Summary Panel
	self:getChild(AchievementFrameComparison, 5):SetBackdropBorderColor(bbR, bbG, bbB, bbA) -- frame border
	for _, type in pairs({"Player", "Friend"}) do
		_G["AchievementFrameComparisonSummary"..type]:SetBackdrop(nil)
		_G["AchievementFrameComparisonSummary"..type.."Background"]:SetAlpha(0)
		skinSB("AchievementFrameComparisonSummary"..type.."StatusBar")
	end

	-- Stats Panel
	self:skinSlider(AchievementFrameComparisonStatsContainerScrollBar)
	self:SecureHook("AchievementFrameComparison_UpdateStats", function()
-- 		self:Debug("AFC_US")
		skinComparisonStats()
	end)
	self:SecureHook(AchievementFrameComparisonStatsContainer, "Show", function()
--		self:Debug("AFCSC_OS")
		skinComparisonStats()
	end)
	if achievementFunctions == COMPARISON_STAT_FUNCTIONS then skinComparisonStats() end

-->>-- Tabs
	for i = 1, AchievementFrame.numTabs do
		local tabName = _G["AchievementFrameTab"..i]
		self:keepRegions(tabName, {7, 8, 9, 10}) -- N.B. region 7, 8 & 9 are highlights, 10 is text
		self:addSkinFrame(tabName, 9, 0, -9, -10, ftype, self.isTT)
		local tabSF = self.skinFrame[tabName]
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end

	-- skin the Alert frames
	self:checkAndRun("AchievementAlerts")

end

function Skinner:AchievementAlerts()
	if not self.db.profile.AchieveAlert or self.initialized.AchieveAlert then return end
	self.initialized.AchieveAlert = true

	local function skinAlertFrame()

		for i = 1, 2 do
			local aaFrame = _G["AchievementAlertFrame"..i]
			if aaFrame and not Skinner.skinFrame[aaFrame] then
				aaFrame:SetHeight(60)
				aaFrame:SetWidth(300)
				self:moveObject(aaFrame, nil, nil, "+", 10)
				_G["AchievementAlertFrame"..i.."Background"]:SetAlpha(0)
				local aaFN = _G["AchievementAlertFrame"..i.."Name"]
				aaFN:ClearAllPoints()
				aaFN:SetPoint("BOTTOM", aaFrame, 0, 12)
				local aaFI = _G["AchievementAlertFrame"..i.."Icon"]
				Skinner:keepRegions(aaFI, {3}) -- icon texture
				aaFI:ClearAllPoints()
				aaFI:SetPoint("LEFT", aaFrame, -32, -3)
				local aaFS = _G["AchievementAlertFrame"..i.."Shield"]
				aaFS:ClearAllPoints()
				aaFS:SetPoint("RIGHT", aaFrame, -10, -3)
				Skinner:addSkinFrame(aaFrame, 0, 0, 0, 0, ftype)
			end
		end

	end

	if not AchievementAlertFrame2 then
		self:SecureHook("AchievementAlertFrame_ShowAlert", function(id)
--			self:Debug("AAF_SA:[%s]", id)
			skinAlertFrame()
			if AchievementAlertFrame2 then
				self:Unhook("AchievementAlertFrame_ShowAlert")
			end
		end)
	end

	skinAlertFrame()

end
