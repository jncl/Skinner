local ftype = "c"

local cfSubframes = {"PaperDollFrame", "PetPaperDollFrame", "ReputationFrame", "SkillFrame", "PVPFrame"}
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
	if not self.isPTR then
		-- hook this to move tabs when Pet is called
		self:SecureHook("PetTab_Update", function()
			-- check to see if the Pet Tab has been shown
			local _,_,_,xOfs,_ = CharacterFrameTab3:GetPoint()
	--		self:Debug("CF_PetTab_Update: [%s]", math.floor(xOfs))
			if math.floor(xOfs) == -17 then
				self:moveObject(CharacterFrameTab3, "+", 11, nil, nil)
			elseif math.floor(xOfs) == -16 then
				self:moveObject(CharacterFrameTab3, "+", 12, nil, nil)
			end
			self:resizeTabs(CharacterFrame)
			end)
	end

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
		self:moveObject(tabName, "+", ((i == 3 and not HasPetUI()) and 0 or 11), nil, nil)
	end
	if self.db.profile.TexturedTab then self:applySkin(tabName, nil, 0, 1)
		else self:storeAndSkin(ftype, tabName) end

	end

	-- Hook this to resize the Tabs
	self:SecureHook(CharacterFrame, "Show", function()
		self:resizeTabs(CharacterFrame)
		end)

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
	self:moveObject(CharacterAmmoSlotCount, "+", 5, nil, nil)

end

function Skinner:PetPaperDollFrame()

	self:keepFontStrings(PetPaperDollFrame)
	self:keepFontStrings(PetAttributesFrame)

	PetModelFrameRotateLeftButton:Hide()
	PetModelFrameRotateRightButton:Hide()
	self:makeMFRotatable(PetModelFrame)

	self:moveObject(PetNameText, nil, nil, "-", 26)

	local xOfs, yOfs = 10, 10
	self:moveObject(PetModelFrame, "-", xOfs, nil, nil)
	self:moveObject(PetAttributesFrame, "-", xOfs, "-", yOfs)
	self:moveObject(PetResistanceFrame, "-", xOfs, "-", yOfs)

	-- up the Frame level otherwise the tooltip doesn't work
	RaiseFrameLevel(PetPaperDollPetInfo)

	self:keepRegions(PetPaperDollFrameExpBar, {3, 4}) -- N.B. region 3 is text
	self:moveObject(PetPaperDollFrameExpBar, "-", 10, "-", 72)
	self:glazeStatusBar(PetPaperDollFrameExpBar, 0)

	self:moveObject(PetTrainingPointText, nil, nil, "-", 72)
	self:moveObject(PetPaperDollCloseButton, "-", 8, "-", 6)

end

function Skinner:ReputationFrame()

	self:keepFontStrings(ReputationFrame)

	local xOfs, yOfs = 5, 20
	self:moveObject(ReputationFrameFactionLabel, "-", xOfs, "+", yOfs)
	self:moveObject(ReputationFrameStandingLabel, "-", xOfs, "+", yOfs)
	self:moveObject(ReputationBar1, "-", xOfs, "+", yOfs)

	for i = 1 , NUM_FACTIONS_DISPLAYED do
		self:keepFontStrings(_G["ReputationBar"..i])
		self:glazeStatusBar(_G["ReputationBar"..i], 0)
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

function Skinner:PVPFrame()

	self:keepFontStrings(PVPFrame)
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

local spellbooktypes = {BOOKTYPE_SPELL, BOOKTYPE_PET, nil}
function Skinner:SpellBookFrame()
	if not self.db.profile.SpellBookFrame or self.initialized.SpellBookFrame then return end
	self.initialized.SpellBookFrame = true

	if self.db.profile.TexturedTab then
		-- hook to handle tabs
		self:SecureHook("ToggleSpellBook", function(bookType)
--		self:Debug("ToggleSpellBook: [%s, %s]", bookType, SpellBookFrame.bookType)
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
		tabName:SetHeight(tabName:GetHeight() * self.FTxMult)
		local left, right, top, bottom = tabName:GetHitRectInsets()
--		self:Debug("SBFTB: [%s, %s, %s, %s, %s]", i, left, right, top, bottom)
		tabName:SetHitRectInsets(left * self.FTyMult, right * self.FTyMult, top * self.FTxMult, bottom * self.FTxMult)
		if self.db.profile.TexturedTab then self:applySkin(tabName, nil, 0)
		else self:storeAndSkin(ftype, tabName) end
		if i == 1 then
			self:moveObject(tabName, nil, nil, "-", 70)
			if self.db.profile.TexturedTab then self:setActiveTab(tabName) end
		else
			self:moveObject(tabName, "+", 15, nil, nil)
			if self.db.profile.TexturedTab then self:setInactiveTab(tabName) end
		end

	end

	self:storeAndSkin(ftype, SpellBookFrame)

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
	self:moveObject(PlayerTalentFrameSpentPoints, "-", 35, "+", 15)
	self:moveObject(PlayerTalentFrameTalentPointsText, "-", 10, "-", 70)
	self:moveObject(PlayerTalentFrameBackgroundTopLeft, "-", 10, nil, nil)
	self:moveObject(PlayerTalentFrameCancelButton, "-", 10, "-", 8)
	self:moveObject(PlayerTalentFrameScrollFrame, "+", 35, nil, nil)
	PlayerTalentFrameScrollFrame:SetHeight(PlayerTalentFrameScrollFrame:GetHeight() - 2)
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
