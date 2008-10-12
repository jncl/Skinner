local ftype = "c"
local cfSubframes = {"PaperDollFrame", "PetPaperDollFrame", "ReputationFrame", "SkillFrame"}
if not Skinner.isWotLK then
	table.insert(cfSubframes, "PVPFrame")
else
	table.insert(cfSubframes, "TokenFrame")
end
function Skinner:CharacterFrames()
	if not self.db.profile.CharacterFrames or self.initialized.CharacterFrames then return end
	self.initialized.CharacterFrames = true

	if self.db.profile.TexturedTab then
--		-- hook this to adjust the widths of the Tabs
		self:SecureHook("CharacterFrame_ShowSubFrame",function(frameName)
--			self:Debug("CF_SSF: [%s]", frameName)
			if self.db.profile.TexturedTab then
				-- change the texture for the Active and Inactive tabs
				for i, v in pairs(cfSubframes) do
					if v == frameName then
						self:setActiveTab(_G["CharacterFrameTab"..i])
					else
						self:setInactiveTab(_G["CharacterFrameTab"..i])
					end
				end
			end
		end)
	end
	local hookFunc
	if not self.isWotLK then
		hookFunc = "PetTab_Update"
	else
		hookFunc = "PetPaperDollFrame_UpdateTabs"
	end
	-- hook this to move tabs when Pet is called
	self:SecureHook(hookFunc, function()
		-- check to see if the Pet Tab has been shown
		local xOfs = select(4, CharacterFrameTab3:GetPoint())
--		self:Debug("CF_PetTab_Update: [%s]", math.floor(xOfs))
		if math.floor(xOfs) == -17 then
			self:moveObject(CharacterFrameTab3, "+", 11, nil, nil)
		elseif math.floor(xOfs) == -16 then
			self:moveObject(CharacterFrameTab3, "+", 12, nil, nil)
		end
		self:resizeTabs(CharacterFrame)
		end)

	-- handle each frame
	self:checkAndRun("CharacterFrame")
	for _, v in pairs(cfSubframes) do
		self:checkAndRun(v)
	end

end

function Skinner:CharacterFrame()

	self:keepFontStrings(CharacterFrame)

	CharacterFrame:SetWidth(CharacterFrame:GetWidth() * self.FxMult)
	CharacterFrame:SetHeight(CharacterFrame:GetHeight() * self.FyMult)

	self:moveObject(CharacterNameText, nil, nil, "-", 30)
	self:moveObject(CharacterFrameCloseButton, "+", 28, "+", 8)

	self:skinDropDown(PlayerTitleDropDown)
	self:skinDropDown(PlayerStatFrameLeftDropDown, true)
	self:skinDropDown(PlayerStatFrameRightDropDown, true)

	self:storeAndSkin(ftype, CharacterFrame)

--	CharacterFrameTab1-5
	for i = 1, #CHARACTERFRAME_SUBFRAMES do
		local tabName = _G["CharacterFrameTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		if i == 1 then
			self:moveObject(tabName, "-", 6, "-", 71)
		else
			-- handle no pet out or not a pet class
			if not self.isWotLK then 
				self:moveObject(tabName, "+", ((i == 3 and not HasPetUI()) and 0 or 11), nil, nil)
			else
				self:moveObject(tabName, "+", ((i == 3 and not CharacterFrameTab2:IsShown()) and 0 or 11), nil, nil)
			end
		end
		if self.db.profile.TexturedTab then self:applySkin(tabName, nil, 0, 1)
			else self:storeAndSkin(ftype, tabName) end
	end

	-- Hook this to resize the Tabs
	self:SecureHook(CharacterFrame, "Show", function()
		self:resizeTabs(CharacterFrame)
		end)
		
	self:resizeTabs(CharacterFrame)

end

function Skinner:PaperDollFrame()

	self:keepFontStrings(PaperDollFrame)

	CharacterModelFrameRotateLeftButton:Hide()
	CharacterModelFrameRotateRightButton:Hide()
	self:makeMFRotatable(CharacterModelFrame)
	self:keepFontStrings(CharacterAttributesFrame)

	local xOfs, yOfs = 9, 10
	self:moveObject(CharacterModelFrame, "-", xOfs, "+", yOfs)
	self:moveObject(CharacterHeadSlot, "-", xOfs, "+", yOfs)
	self:moveObject(CharacterHandsSlot, "-", xOfs, "+", yOfs)
	self:moveObject(CharacterResistanceFrame, "-", xOfs, "+", yOfs)
	self:moveObject(CharacterAttributesFrame, "-", xOfs, nil, nil)

	self:moveObject(CharacterMainHandSlot, "-", xOfs, "-", 70)

	self:removeRegions(CharacterAmmoSlot, {1})
	if not self.isWotLK then self:moveObject(CharacterAmmoSlotCount, "+", 5, nil, nil)
	else self:moveObject(CharacterAmmoSlotCount, "+", 3, "-", 2) end

end

function Skinner:PetPaperDollFrame()

	self:keepFontStrings(PetPaperDollFrame)
	self:moveObject(PetNameText, nil, nil, "-", 26)

-->>-- Pet Frame
	self:keepFontStrings(PetAttributesFrame)
	PetModelFrameRotateLeftButton:Hide()
	PetModelFrameRotateRightButton:Hide()
	self:makeMFRotatable(PetModelFrame)

	local xOfs, yOfs = 10, 10
	if not self.isWotLK then
		self:moveObject(PetModelFrame, "-", xOfs, nil, nil)
		self:moveObject(PetAttributesFrame, "-", xOfs, "-", yOfs)
		self:moveObject(PetPaperDollFrameExpBar, "-", 10, "-", 72)
		self:moveObject(PetTrainingPointText, nil, nil, "-", 72)
		self:moveObject(PetPaperDollCloseButton, "-", 8, "-", 6)
	else
		self:moveObject(PetModelFrame, "-", xOfs, "+", 30)
		self:moveObject(PetTrainingPointText, nil, nil, "-", 92)
		self:moveObject(PetAttributesFrame, "-", xOfs, "+", 30)
		self:moveObject(PetPaperDollFrameExpBar, "-", 10, "-", 52)
		self:moveObject(PetPaperDollCloseButton, "-", 8, nil, nil)
	end
	self:moveObject(PetResistanceFrame, "-", xOfs, "-", yOfs)

	-- up the Frame level otherwise the tooltip doesn't work
	RaiseFrameLevel(PetPaperDollPetInfo)

	self:keepRegions(PetPaperDollFrameExpBar, {3, 4}) -- N.B. region 3 is text
	self:glazeStatusBar(PetPaperDollFrameExpBar, 0)
	
-->>-- Companion Frame
	if self.isWotLK then 
		self:keepFontStrings(PetPaperDollFrameCompanionFrame)
		CompanionModelFrameRotateLeftButton:Hide()
		CompanionModelFrameRotateRightButton:Hide()
		self:makeMFRotatable(CompanionModelFrame)
		local xOfs = 10
		self:moveObject(CompanionModelFrame, "+", xOfs, nil, nil)
		self:moveObject(CompanionSelectedName, "+", xOfs, "-", 20)
		self:moveObject(CompanionSummonButton, "+", xOfs, "-", 20)
		self:moveObject(CompanionButton1, "-", xOfs, "+", 20)
		self:moveObject(CompanionPrevPageButton, "-", xOfs, "-", 70)
		self:moveObject(CompanionPageNumber, "+", xOfs, "-", 40)
	end

-->>-- Tabs
	if self.isWotLK then self:skinFFToggleTabs("PetPaperDollFrameTab", 3) end

end

function Skinner:ReputationFrame()

	self:keepFontStrings(ReputationFrame)

	local xOfs, yOfs = 5, 20
	self:moveObject(ReputationFrameFactionLabel, "-", xOfs, "+", yOfs)
	self:moveObject(ReputationFrameStandingLabel, "-", xOfs, "+", yOfs)
	self:moveObject(ReputationBar1, "-", xOfs, "+", yOfs)

	for i = 1, NUM_FACTIONS_DISPLAYED do
		if not self.isWotLK then
			self:keepFontStrings(_G["ReputationBar"..i])
			self:glazeStatusBar(_G["ReputationBar"..i], 0)
		else
			_G["ReputationBar"..i.."Background"]:SetAlpha(0)
			_G["ReputationBar"..i.."ReputationBarLeftTexture"]:SetAlpha(0)
			_G["ReputationBar"..i.."ReputationBarRightTexture"]:SetAlpha(0)
			self:glazeStatusBar(_G["ReputationBar"..i.."ReputationBar"], 0)
		end
	end

	self:moveObject(ReputationListScrollFrame, "+", 35, "+", 20)
	self:removeRegions(ReputationListScrollFrame)
	self:skinScrollBar(ReputationListScrollFrame)

	self:moveObject(ReputationDetailFrame, "+", 30, nil, nil)
	self:keepFontStrings(ReputationDetailFrame)
	self:storeAndSkin(ftype, ReputationDetailFrame)

end

function Skinner:SkillFrame()

	self:keepFontStrings(SkillFrame)

	local xOfs, yOfs = 5, 20
	self:removeRegions(SkillFrameExpandButtonFrame)
	self:moveObject(SkillFrameExpandButtonFrame, "-", 57, "+", yOfs)
	self:moveObject(SkillTypeLabel1, "-", xOfs, "+", yOfs)
	self:moveObject(SkillRankFrame1, "-", xOfs, "+", yOfs)
	self:moveObject(SkillListScrollFrame, "+", 35, "+", 20)
	self:removeRegions(SkillListScrollFrame)
	self:skinScrollBar(SkillListScrollFrame)

	for i = 1, SKILLS_TO_DISPLAY do
		self:keepRegions(_G["SkillRankFrame"..i.."Border"], {2}) -- N.B. region 2 is highlight
		self:glazeStatusBar(_G["SkillRankFrame"..i], 0)
	end

	self:removeRegions(SkillDetailScrollFrame)
	self:skinScrollBar(SkillDetailScrollFrame)
	self:keepFontStrings(SkillDetailStatusBar)
	self:glazeStatusBar(SkillDetailStatusBar, 0)
	self:moveObject(SkillFrameCancelButton, "-", 8, "-", 6)

end

function Skinner:TokenFrame()

	if self.isWotLK and self.db.profile.ContainerFrames.skin then
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
	self:moveObject(TokenFrameContainer, "-", 10, "+", 20)
	self:removeRegions(TokenFrameContainer)
	self:skinScrollBar(TokenFrameContainer)
	self:moveObject(TokenFrameMoneyFrame, nil, nil, "-", 72)
	self:moveObject(TokenFrameCancelButton, "-", 8, "-", 6)
	self:getChild(TokenFrame, 4):Hide()
	
-->>-- Popup Frame
	self:keepFontStrings(TokenFramePopup)
	self:applySkin(TokenFramePopup)
	self:moveObject(TokenFramePopup, "+", 30, nil, nil)
	
end

function Skinner:PVPFrame()

	self:keepFontStrings(PVPFrame)
	if self.isWotLK then
		PVPFrame:SetWidth(PVPFrame:GetWidth() * self.FxMult)
		PVPFrame:SetHeight(PVPFrame:GetHeight() * self.FyMult)
		self:moveObject(PVPFrameCloseButton, "+", 28, "+", 8)
	end
	self:moveObject(PVPFrameHonorLabel, "-", 25, nil, nil)
	self:moveObject(PVPFrameHonorPoints, "+", 30, nil, nil)
	self:moveObject(PVPFrameArenaLabel, "-", 25, nil, nil)
	self:moveObject(PVPFrameArenaPoints, "+", 30, nil, nil)
	self:moveObject(PVPHonorTodayLabel, "+", 10, nil, nil)
	self:moveObject(PVPHonorTodayHonor, "+", 22, nil, nil)
	self:moveObject(PVPTeam1Standard, "-", 10, "+", 10)
	self:moveObject(PVPTeam2Standard, "-", 10, "+", 10)
	self:moveObject(PVPTeam3Standard, "-", 10, "+", 10)
	self:moveObject(PVPFrameToggleButton, "+", 30, "-", 74)
	if self.isWotLK then self:storeAndSkin(ftype, PVPFrame) end
	
-->>-- PVP Team Details Frame
	self:keepFontStrings(PVPTeamDetails)
	self:skinDropDown(PVPDropDown)
	self:moveObject(PVPTeamDetails, "+", 25, nil, nil)
	self:moveObject(PVPTeamDetailsAddTeamMember, "-", 10, "-", 10)
	self:moveObject(PVPTeamDetailsToggleButton, "+", 10, "-", 10)
	self:storeAndSkin(ftype, PVPTeamDetails)

end

function Skinner:PetStableFrame()
	if not self.db.profile.PetStableFrame or self.initialized.PetStableFrame then return end
	self.initialized.PetStableFrame = true

	self:keepFontStrings(PetStableFrame)

	PetStableFrame:SetWidth(PetStableFrame:GetWidth() * self.FxMult)
	PetStableFrame:SetHeight(PetStableFrame:GetHeight() * self.FyMult)

	self:moveObject(PetStableFrameCloseButton, "+", 28, "+", 8)

	PetStableModelRotateLeftButton:Hide()
	PetStableModelRotateRightButton:Hide()
	self:makeMFRotatable(PetStableModel)

	self:moveObject(PetStableTitleLabel, nil, nil, "+", 6)
	local xOfs, yOfs = 0, 75
	self:moveObject(PetStableCurrentPet, "-", xOfs, "-", yOfs)
	self:moveObject(PetStableSlotText, "-", xOfs, "-", yOfs)
	self:moveObject(PetStableCostLabel, "-", xOfs, "-", yOfs)
	self:moveObject(PetStablePurchaseButton, "-", xOfs, "-", yOfs)
	self:moveObject(PetStableMoneyFrame, "-", xOfs, "-", yOfs)

	-- up the Frame level otherwise the tooltip doesn't work
	RaiseFrameLevel(PetStablePetInfo)

	self:storeAndSkin(ftype, PetStableFrame)

end

local spellbooktypes = {BOOKTYPE_SPELL}
local hasPetSpells = select(1, HasPetSpells())
if hasPetSpells then table.insert(spellbooktypes, BOOKTYPE_PET) end
if Skinner.isWotLK then table.insert(spellbooktypes, INSCRIPTION) end
function Skinner:SpellBookFrame()
	if not self.db.profile.SpellBookFrame or self.initialized.SpellBookFrame then return end
	self.initialized.SpellBookFrame = true

	if self.isWotLK then
		self:SecureHook("SpellBookFrame_Update", function(...)
			if SpellBookFrame.bookType ~= INSCRIPTION then
				SpellBookTitleText:Show()
			else
				SpellBookTitleText:Hide() -- hide Inscriptions title
			end
		end)
	end
	if self.db.profile.TexturedTab then
		-- hook to handle tabs
		self:SecureHook("ToggleSpellBook", function(bookType)
--			self:Debug("ToggleSpellBook: [%s, %s]", bookType, SpellBookFrame.bookType)
			local sbfbt = SpellBookFrame.bookType
			if sbfbt == bookType then return end
			for i, v in pairs(spellbooktypes) do
--				self:Debug("sbt : [%s]", v)
				if v == bookType then
					self:setActiveTab(_G["SpellBookFrameTabButton"..i])
				else
					self:setInactiveTab(_G["SpellBookFrameTabButton"..i])
				end
			end
		end)
	end

	self:keepFontStrings(SpellBookFrame)

	SpellBookFrame:SetWidth(SpellBookFrame:GetWidth() * self.FxMult)
	SpellBookFrame:SetHeight(SpellBookFrame:GetHeight() * self.FyMult)

	self:moveObject(SpellBookCloseButton, "+", 28, "+", 8)
	self:moveObject(SpellBookTitleText, nil, nil, "-", 25)
	if self.isWotLK then self:moveObject(ShowAllSpellRanksCheckBox, nil, nil, "+", 15) end
	
	self:moveObject(SpellBookPageText, nil, nil, "-", 70)
	self:moveObject(SpellBookPrevPageButton, "-", 20, "-", 70)
	self:moveObject(SpellBookNextPageButton, nil, nil, "-", 70)

	for i = 1, SPELLS_PER_PAGE do
		self:removeRegions(_G["SpellButton"..i], {1})
		if i == 1 then self:moveObject(_G["SpellButton"..i], "-" , 10, "+", 20) end
		_G["SpellButton"..i.."SpellName"]:SetTextColor(self.HTr, self.HTg, self.HTb)
		_G["SpellButton"..i.."SubSpellName"]:SetTextColor(self.BTr, self.BTg, self.BTb)
	end

	for i = 1, MAX_SKILLLINE_TABS do
		local tabName = _G["SpellBookSkillLineTab"..i]
		self:removeRegions(tabName, {1}) -- N.B. other regions are icon and highlight
--		self:Debug("SBSLT: [%s, %s]", tabName:GetWidth(), tabName:GetHeight())
		tabName:SetWidth(tabName:GetWidth() * 1.25)
		tabName:SetHeight(tabName:GetHeight() * 1.25)
		if i == 1 then self:moveObject(tabName, "+", 30, nil, nil) end
	end

	for i = 1, 3 do
		local tabName = _G["SpellBookFrameTabButton"..i]
		self:keepRegions(tabName, {1, 3}) -- N.B. region 1 is the Text, 3 is the highlight
		tabName:SetWidth(tabName:GetWidth() * self.FTyMult)
		tabName:SetHeight(tabName:GetHeight() * self.FTxMult)
--		local tabHL = self:getRegion(tabName, 3)
--		tabHL:SetWidth(tabHL:GetWidth() * 1.50)
--		tabHL:SetHeight(tabHL:GetHeight() * 2)
		local left, right, top, bottom = tabName:GetHitRectInsets()
--		self:Debug("SBFTB: [%s, %s, %s, %s, %s]", i, left, right, top, bottom)
		tabName:SetHitRectInsets(left * self.FTyMult, right * self.FTyMult, top * self.FTxMult, bottom * self.FTxMult)
		if self.db.profile.TexturedTab then self:applySkin(tabName, nil, 0)
		else self:storeAndSkin(ftype, tabName) end
		if i == 1 then
			self:moveObject(tabName, "-", 20, "-", 70)
			if self.db.profile.TexturedTab then self:setActiveTab(tabName) end
		else
			self:moveObject(tabName, "+", 15, nil, nil)
			if self.db.profile.TexturedTab then self:setInactiveTab(tabName) end
		end

	end

	self:storeAndSkin(ftype, SpellBookFrame)

end

function Skinner:GlyphUI()
	if not self.db.profile.SpellBookFrame then return end

	self:removeRegions(GlyphFrame, {1, 2})
	self:moveObject(GlyphFrameTitleText, "-", 20, "+", 8)
	for i = 1, 5 do
		local glyphButton = _G["GlyphFrameGlyph"..i]
		self:moveObject(glyphButton, "-", 10, nil, nil)
	end

end

function Skinner:TalentUI()
	if not self.db.profile.TalentFrame or self.initialized.TalentUI then return end
	self.initialized.TalentUI = true

	self:SecureHook("TalentFrame_Update", function(this)
--		self:Debug("TalentFrame_Update: [%s]", this:GetName())
		if this == PlayerTalentFrame then
			for i = 1, MAX_TALENT_TABS do
				local tabName = _G["PlayerTalentFrameTab"..i]
				tabName:SetWidth(tabName:GetWidth() * self.FTyMult)
				if self.db.profile.TexturedTab then
					if i == PlayerTalentFrame.currentSelectedTab then
						self:setActiveTab(tabName)
					else
						self:setInactiveTab(tabName)
					end
				end
			end
		end
		end)

	self:keepRegions(PlayerTalentFrame, {6, 7, 8, 9, 10, 14, 15, 16}) -- N.B. 6-9 are the background picture, 10, 14-16 are text regions
	PlayerTalentFrame:SetWidth(PlayerTalentFrame:GetWidth() * self.FxMult)
	PlayerTalentFrame:SetHeight(PlayerTalentFrame:GetHeight() * self.FyMult)
	self:moveObject(PlayerTalentFrameTitleText, nil, nil, "+", 6)
	self:moveObject(PlayerTalentFrameCloseButton, "+", 28, "+", 8)
	self:moveObject(PlayerTalentFrameSpentPoints, "-", 35, "+", 12)
	self:moveObject(PlayerTalentFrameTalentPointsText, "-", 10, "-", 75)
	self:moveObject(PlayerTalentFrameBackgroundTopLeft, "-", 10, "+", 12)
	PlayerTalentFrameBackgroundBottomLeft:SetHeight(130)
	PlayerTalentFrameBackgroundBottomRight:SetHeight(130)
	self:moveObject(PlayerTalentFrameCancelButton, "-", 10, "-", 8)
	self:moveObject(PlayerTalentFrameScrollFrame, "+", 35, "+", 12)
	self:removeRegions(PlayerTalentFrameScrollFrame)
	self:skinScrollBar(PlayerTalentFrameScrollFrame)
	self:storeAndSkin(ftype, PlayerTalentFrame)

	for i = 1, MAX_TALENT_TABS do
		local tabName = _G["PlayerTalentFrameTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		tabName:SetWidth(tabName:GetWidth() * self.FTyMult)
		if self.db.profile.TexturedTab then self:applySkin(tabName, nil, 0)
		else self:storeAndSkin(ftype, tabName) end
		if i == 1 then
			self:moveObject(tabName, "-", 8, "-", 71)
			if self.db.profile.TexturedTab then self:setActiveTab(tabName) end
		else
			self:moveObject(tabName, "+", 10, nil, nil)
			if self.db.profile.TexturedTab then self:setInactiveTab(tabName) end
		end
	end

	if self.isWotLK then
		for i = 1, 2 do
			local tabName = _G["PlayerTalentFrameType"..i]
			self:removeRegions(tabName, {1}) -- N.B. other regions are icon and highlight
--			self:Debug("PTFT: [%s, %s]", tabName:GetWidth(), tabName:GetHeight())
			tabName:SetWidth(tabName:GetWidth() * 1.25)
			tabName:SetHeight(tabName:GetHeight() * 1.25)
			if i == 1 then self:moveObject(tabName, "+", 30, nil, nil) end
		end
	end
end

function Skinner:DressUpFrame()
	if not self.db.profile.DressUpFrame or self.initialized.DressUpFrame then return end
	self.initialized.DressUpFrame = true

	self:removeRegions(DressUpFrame, {1, 2, 3, 4, 5}) -- N.B. regions 6 & 7 are text, 8- 11 are the background picture
	DressUpFrame:SetWidth(DressUpFrame:GetWidth() * self.FxMult)
	DressUpFrame:SetHeight(DressUpFrame:GetHeight() * self.FyMult)

	DressUpModelRotateLeftButton:Hide()
	DressUpModelRotateRightButton:Hide()
	self:makeMFRotatable(DressUpModel)

	self:moveObject(DressUpFrameTitleText, nil, nil, "+", 6)
	self:moveObject(DressUpFrameDescriptionText, nil, nil, "+", 6)
	self:moveObject(DressUpFrameCloseButton, "+", 28, "+", 8)
	self:moveObject(DressUpBackgroundTopLeft, "-", 8, "+", 15)
	self:moveObject(DressUpModel, nil, nil, "-", 60)
	self:moveObject(DressUpFrameCancelButton, "-", 10, nil, nil)

	self:storeAndSkin(ftype, DressUpFrame)

end

function Skinner:AchievementUI()
	if not self.db.profile.Achievements or self.initialized.Achievements then return end
	self.initialized.Achievements = true
	
	local bbR, bbG, bbB, bbA = unpack(self.bbColour)

	-- Hook this to skin the GameTooltip StatusBars
	self:SecureHook("GameTooltip_ShowStatusBar", function(...)
--		self:Debug("GT_SSB:[%s]", ...)
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
	
	-- hook this to skin StatusBars used by the Objectives mini panels
	self:Hook("AchievementButton_GetProgressBar", function(index)
--		self:Debug("AB_GPB:[%s]", index)
		local statusBar = self.hooks["AchievementButton_GetProgressBar"](index)
		if not statusBar.skinned then
			self:removeRegions(statusBar, {2})
			self:glazeStatusBar(statusBar)
			statusBar.skinned = true
		end
		return statusBar
	end, true)

	self:keepFontStrings(AchievementFrame)
	self:moveObject(AchievementFrameCloseButton, "+", 1, nil, nil)
	self:storeAndSkin(ftype, AchievementFrame)
	
-->>-- Header
	self:keepFontStrings(AchievementFrameHeader)
	self:moveObject(AchievementFrameHeaderTitle, "-", 60, "-", 28)
	self:moveObject(AchievementFrameHeaderPoints, "+", 40, "-", 8)
	AchievementFrameHeaderShield:SetAlpha(1)
	
-->>-- Categories Panel (on the Left)
	self:skinHybridScrollBar(AchievementFrameCategoriesContainerScrollBar)
	self:storeAndSkin(ftype, AchievementFrameCategories)
	local function skinCategories()
		for i = 1, #AchievementFrameCategoriesContainer.buttons do
			_G["AchievementFrameCategoriesContainerButton"..i.."Background"]:SetAlpha(0)
		end
	end
	self:SecureHook("AchievementFrameCategories_Update", function()
--		self:Debug("AFC_U")
		skinCategories()
	end)
	skinCategories()
	
-->>-- Achievements Panel (on the right)
	self:getChild(AchievementFrameAchievements, 2):SetBackdropBorderColor(bbR, bbG, bbB, bbA)
	self:skinHybridScrollBar(AchievementFrameAchievementsContainerScrollBar)
	AchievementFrameAchievementsBackground:SetAlpha(0)
	
-->>-- Stats
	self:keepFontStrings(AchievementFrameStats)
	self:getChild(AchievementFrameStats, 2):SetBackdropBorderColor(bbR, bbG, bbB, bbA)
	self:skinHybridScrollBar(AchievementFrameStatsContainerScrollBar)
	local function skinStats()
		for i = 1, #AchievementFrameStatsContainer.buttons do
			local buttonName = "AchievementFrameStatsContainerButton"..i
			local button = _G[buttonName]
			if button.isHeader then _G[buttonName.."BG"]:SetAlpha(0) end
			_G[buttonName.."HeaderLeft"]:SetAlpha(0)
			_G[buttonName.."HeaderMiddle"]:SetAlpha(0)
			_G[buttonName.."HeaderRight"]:SetAlpha(0)
		end
	end
	self:SecureHook("AchievementFrameStats_Update", function()
--		self:Debug("AFS_U")
		skinStats()
	end)
	skinStats()
	
-->>-- Summary Panel
	self:keepFontStrings(AchievementFrameSummary)
	AchievementFrameSummaryBackground:SetAlpha(0)
	self:removeRegions(AchievementFrameSummaryStatusBar, {3, 4, 5})
	self:glazeStatusBar(AchievementFrameSummaryStatusBar, 0)
	self:moveObject(self:getRegion(AchievementFrameSummaryStatusBar, 1), nil, nil, "-", 3)
	self:moveObject(self:getRegion(AchievementFrameSummaryStatusBar, 2), nil, nil, "-", 3)
	self:skinHybridScrollBar(AchievementFrameAchievementsContainerScrollBar)
	AchievementFrameSummaryAchievementsHeaderHeader:SetAlpha(0)
	self:keepFontStrings(AchievementFrameSummaryStatsHeader)
	self:getChild(AchievementFrameSummary, 2):SetBackdropBorderColor(bbR, bbG, bbB, bbA)
	
-->>-- Comparison Panel
	AchievementFrameComparisonBackground:SetAlpha(0)
	AchievementFrameComparisonDark:SetAlpha(0)
	AchievementFrameComparisonWatermark:SetAlpha(0)
	-- Header
	self:keepFontStrings(AchievementFrameComparisonHeader)
	AchievementFrameComparisonHeaderShield:SetAlpha(1)
	AchievementFrameComparisonHeaderShield:ClearAllPoints()
	AchievementFrameComparisonHeaderShield:SetPoint("RIGHT", AchievementFrameCloseButton, "LEFT", -10, 0)
	AchievementFrameComparisonHeaderPoints:ClearAllPoints()
	AchievementFrameComparisonHeaderPoints:SetPoint("RIGHT", AchievementFrameComparisonHeaderShield, "LEFT", -10, 0)
	AchievementFrameComparisonHeaderName:ClearAllPoints()
	AchievementFrameComparisonHeaderName:SetPoint("RIGHT", AchievementFrameComparisonHeaderPoints, "LEFT", -10, 0)
	-- Container
	self:skinHybridScrollBar(AchievementFrameComparisonContainerScrollBar)
	
	-- Summary Panel
	self:getChild(AchievementFrameComparison, 5):SetBackdropBorderColor(bbR, bbG, bbB, bbA)
	local types = {"Player", "Friend"}
	for _, type in next, types do
		_G["AchievementFrameComparisonSummary"..type]:SetBackdrop(nil)
		_G["AchievementFrameComparisonSummary"..type.."Background"]:SetAlpha(0)
		local statusBar = _G["AchievementFrameComparisonSummary"..type.."StatusBar"]
		self:removeRegions(statusBar, {3, 4, 5})
		self:glazeStatusBar(statusBar, 0)
		self:moveObject(self:getRegion(statusBar, 1), nil, nil, "-", 3)
		self:moveObject(self:getRegion(statusBar, 2), nil, nil, "-", 3)
	end
	
	-- Stats Panel
	self:skinHybridScrollBar(AchievementFrameComparisonStatsContainerScrollBar)
	local function skinComparisonStats()
		for i = 1, #AchievementFrameComparisonStatsContainer.buttons do
			local buttonName = "AchievementFrameComparisonStatsContainerButton"..i
			local button = _G[buttonName]
			if button.isHeader then _G[buttonName.."BG"]:SetAlpha(0) end
			_G[buttonName.."HeaderLeft"]:SetAlpha(0)
			_G[buttonName.."HeaderLeft2"]:SetAlpha(0)
			_G[buttonName.."HeaderMiddle"]:SetAlpha(0)
			_G[buttonName.."HeaderMiddle2"]:SetAlpha(0)
			_G[buttonName.."HeaderRight"]:SetAlpha(0)
			_G[buttonName.."HeaderRight2"]:SetAlpha(0)
		end
	end
	self:SecureHook("AchievementFrameComparison_UpdateStats", function()
--		self:Debug("AFC_US")
		skinComparisonStats()
	end)
	self:SecureHook(AchievementFrameComparisonStatsContainer, "Show", function()
--		self:Debug("AFCSC_OS")
		skinComparisonStats()
	end)
	if achievementFunctions == COMPARISON_STAT_FUNCTIONS then skinComparisonStats() end
	
-->>-- Tabs
	for i = 1, 2 do
		local tabObj = _G["AchievementFrameTab"..i]
		if i == 1 then
			self:moveObject(tabObj, nil, nil, "+", 4)
		else
			self:moveObject(tabObj, "+", 2, nil, nil)
		end 
		self:keepFontStrings(tabObj)
		self:moveObject(tabObj.text, nil, nil, "+", 3)
		self:HookScript(tabObj, "OnClick", function(this)
			AchievementFrameTab_OnClick(this:GetID())
			PlaySound("igCharacterInfoTab")
		end)
		if self.db.profile.TexturedTab then
			self:applySkin(tabObj, nil, 0, 1)
			if i == 1 then self:setActiveTab(tabObj)
			else self:setInactiveTab(tabObj) end
		else self:applySkin(tabObj) end
	end
	if self.db.profile.TexturedTab then 
		self:SecureHook("AchievementFrameTab_OnClick", function()
--			self:Debug("AFT_OC")
			for i = 1, 2 do
				local tabObj = _G["AchievementFrameTab"..i]
				if i == AchievementFrame.selectedTab then self:setActiveTab(tabObj)
				else self:setInactiveTab(tabObj) end
			end
		end)
		self:SecureHook("AchievementFrameComparisonTab_OnClick", function(id)
--			self:Debug("AFCT_OC:[%s]", id)
			for i = 1, 2 do
				local tabObj = _G["AchievementFrameTab"..i]
				if i == AchievementFrame.selectedTab then self:setActiveTab(tabObj)
				else self:setInactiveTab(tabObj) end
			end
		end)
	end
	
end
