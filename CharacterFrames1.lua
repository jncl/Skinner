local _G = _G
local ftype = "c"

function Skinner:CharacterFrames()
	if not self.db.profile.CharacterFrames or self.initialized.CharacterFrames then return end
	self.initialized.CharacterFrames = true

	self:add2Table(self.charKeys1, "CharacterFrames")

	-- skin each sub frame
	self:checkAndRun("CharacterFrame")
	for _, v in pairs{"PaperDollFrame", "PetPaperDollFrame", "ReputationFrame", "TokenFrame"} do
		self:checkAndRun(v)
	end

end

function Skinner:CharacterFrame()

	CharacterFrameInsetRight:DisableDrawLayer("BACKGROUND")
	CharacterFrameInsetRight:DisableDrawLayer("BORDER")
	self:addSkinFrame{obj=CharacterFrame, ft=ftype, kfs=true, ri=true, bgen=2, y1=2, x2=1, y2=-6}

--	CharacterFrameTab1-5
	for i = 1, #CHARACTERFRAME_SUBFRAMES do
		local tabName = _G["CharacterFrameTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		local tabSF = self:addSkinFrame{obj=tabName, ft=ftype, noBdr=self.isTT, x1=6, x2=-6, y2=2}
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end
	self.tabFrames[CharacterFrame] = true

end

function Skinner:PaperDollFrame()

	self:keepFontStrings(PaperDollFrame)
	self:skinDropDown{obj=PlayerTitleFrame}
	self:moveObject{obj=PlayerTitleFrameButton, y=1}
	self:skinScrollBar{obj=PlayerTitlePickerScrollFrame}
	self:addSkinFrame{obj=PlayerTitlePickerFrame, kfs=true, ft=ftype}
	self:makeMFRotatable(CharacterModelFrame)
	for _, child in ipairs{PaperDollItemsFrame:GetChildren()} do
		child:DisableDrawLayer("BACKGROUND")
		if self.modBtnBs then
			if child:IsObjectType("Button") and child:GetName():find("Slot") then
				self:addButtonBorder{obj=child}
			end
		end
	end
	CharacterModelFrame:DisableDrawLayer("BACKGROUND")
	CharacterModelFrame:DisableDrawLayer("BORDER")
	CharacterModelFrame:DisableDrawLayer("OVERLAY")
	CharacterStatsPane:DisableDrawLayer("ARTWORK")
	self:skinSlider{obj=CharacterStatsPaneScrollBar, size=3}
	-- hide ItemFlyout background textures
	local btnFrame = PaperDollFrameItemFlyout.buttonFrame
	self:addSkinFrame{obj=btnFrame, ft=ftype, x1=-3, y1=2, x2=5, y2=-3}
	self:SecureHook("PaperDollFrameItemFlyout_Show", function(paperDollItemSlot)
--		self:Debug("PDFIF_S: [%s]", paperDollItemSlot)
		for i = 1, btnFrame["numBGs"] do
			btnFrame["bg" .. i]:SetAlpha(0)
		end
		if self.modBtnBs then
			for i = 1, #PaperDollFrameItemFlyout.buttons do
				local btn = PaperDollFrameItemFlyout.buttons[i]
				if not btn.sknrBdr then self:addButtonBorder{obj=btn, ibt=true} end
			end
		end
	end)
	self:addButtonBorder{obj=GearManagerToggleButton, x1=1, x2=-1}

end

function Skinner:PetPaperDollFrame()

-->>-- Pet Frame
	PetPaperDollPetModelBg:SetAlpha(0) -- changed in blizzard code
	PetModelFrameShadowOverlay:Hide()
	self:removeRegions(PetPaperDollFrameExpBar, {1, 2})
	self:glazeStatusBar(PetPaperDollFrameExpBar, 0)
	self:makeMFRotatable(PetModelFrame)
	-- up the Frame level otherwise the tooltip doesn't work
	RaiseFrameLevel(PetPaperDollPetInfo)

-->>-- Tabs
	self:skinFFToggleTabs("PetPaperDollFrameTab")

end

function Skinner:ReputationFrame()

	if self.modBtns then
		-- hook to manage changes to button textures
		self:SecureHook("ReputationFrame_Update", function()
			for i = 1, NUM_FACTIONS_DISPLAYED do
				self:checkTex(_G["ReputationBar"..i.."ExpandOrCollapseButton"])
			end
		end)
	end

	self:keepFontStrings(ReputationFrame)
	self:skinScrollBar{obj=ReputationListScrollFrame}

	for i = 1, NUM_FACTIONS_DISPLAYED do
		local bar = "ReputationBar"..i
		self:skinButton{obj=_G[bar.."ExpandOrCollapseButton"], mp=true} -- treat as just a texture
		_G[bar.."Background"]:SetAlpha(0)
		_G[bar.."ReputationBarLeftTexture"]:SetAlpha(0)
		_G[bar.."ReputationBarRightTexture"]:SetAlpha(0)
		self:glazeStatusBar(_G[bar.."ReputationBar"], 0)
	end

-->>-- Reputation Detail Frame
	self:addSkinFrame{obj=ReputationDetailFrame, ft=ftype, kfs=true, x1=6, y1=-6, x2=-6, y2=6}

end

function Skinner:TokenFrame() -- a.k.a. Currency Frame

	if self.db.profile.ContainerFrames.skin then
		BACKPACK_TOKENFRAME_HEIGHT = BACKPACK_TOKENFRAME_HEIGHT - 6
		BackpackTokenFrame:DisableDrawLayer("BACKGROUND")
	end

	self:keepFontStrings(TokenFrame)
	self:skinAllButtons{obj=TokenFrame}
	self:skinScrollBar{obj=TokenFrameContainer}

	self:SecureHookScript(TokenFrame, "OnShow", function(this)
		-- remove header textures
		for i = 1, #TokenFrameContainer.buttons do
			self:removeRegions(TokenFrameContainer.buttons[i], {6, 7, 8})
		end
		self:Unhook(TokenFrame, "OnShow")
	end)
-->>-- Popup Frame
	self:addSkinFrame{obj=TokenFramePopup,ft=ftype, kfs=true, y1=-6, x2=-6, y2=6}

end

function Skinner:PVPFrame()
	if not self.db.profile.PVPFrame or self.initialized.PVPFrame then return end
	self.initialized.PVPFrame = true

	PVPFrame.topInset:DisableDrawLayer("BACKGROUND")
	PVPFrame.topInset:DisableDrawLayer("BORDER")
	self:glazeStatusBar(PVPFrameConquestBar, 0,	 PVPFrameConquestBarBG)
	PVPFrameConquestBarBorder:Hide()
	self:addSkinFrame{obj=PVPFrame, ft=ftype, kfs=true, ri=true, x1=-2, y1=2, x2=1, y2=-8}
	-- Magic Button textures
	for _, v in pairs{"Left", "Right"} do
		local btn = "PVPFrame"..v.."Button"
		if _G[btn.."_LeftSeparator"] then _G[btn.."_LeftSeparator"]:SetAlpha(0) end
		if _G[btn.."_RightSeparator"] then _G[btn.."_RightSeparator"]:SetAlpha(0) end
	end
-->>-- Honor frame
	self:keepFontStrings(PVPFrame.panel1)
	self:skinScrollBar{obj=PVPFrame.panel1.bgTypeScrollFrame}
	self:skinSlider{obj=PVPHonorFrameInfoScrollFrameScrollBar}
	PVPHonorFrameInfoScrollFrameChildFrameDescription:SetTextColor(self.BTr, self.BTg, self.BTb)
	PVPHonorFrameInfoScrollFrameChildFrameRewardsInfo.description:SetTextColor(self.BTr, self.BTg, self.BTb)
	PVPHonorFrameInfoScrollFrameChildFrameRewardsInfo.winReward:DisableDrawLayer("BACKGROUND")
	PVPHonorFrameInfoScrollFrameChildFrameRewardsInfo.lossReward:DisableDrawLayer("BACKGROUND")
	-- Magic Button textures
	local btn = "PVPHonorFrameWarGameButton"
	if _G[btn.."_LeftSeparator"] then _G[btn.."_LeftSeparator"]:SetAlpha(0) end
	if _G[btn.."_RightSeparator"] then _G[btn.."_RightSeparator"]:SetAlpha(0) end
-->>-- Conquest frame
	self:keepFontStrings(PVPFrame.panel2)
	PVPFrame.panel2.winReward:DisableDrawLayer("BACKGROUND")
	PVPFrame.panel2.infoButton:DisableDrawLayer("BORDER")
-->>-- Team Management frame
	self:keepFontStrings(PVPFrame.panel3)
	self:keepFontStrings(PVPTeamManagementFrameWeeklyDisplay)
	self:skinUsingBD{obj=PVPTeamManagementFrameWeeklyDisplay}
	PVPFrame.panel3.flag2.NormalHeader:SetAlpha(0)
	PVPFrame.panel3.flag3.NormalHeader:SetAlpha(0)
	PVPFrame.panel3.flag5.NormalHeader:SetAlpha(0)
	self:skinFFColHeads("PVPTeamManagementFrameHeader", 4)
	self:skinScrollBar{obj=PVPFrame.panel3.teamMemberScrollFrame}
	self:skinDropDown{obj=PVPTeamManagementFrameTeamDropDown}
	-- Glow boxes
	self:addSkinFrame{obj=PVPFrame.panel3.noTeams, ft=ftype, kfs=true}
	self:addSkinFrame{obj=PVPFrame.panel3.invalidTeam, ft=ftype, kfs=true}
	self:addSkinFrame{obj=PVPFrame.lowLevelFrame, ft=ftype, kfs=true}

-->>-- Tabs
	for i = 1, PVPFrame.numTabs do
		local tabName = _G["PVPFrameTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		local tabSF = self:addSkinFrame{obj=tabName, ft=ftype, noBdr=self.isTT, x1=6, x2=-6, y2=2}
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end
	self.tabFrames[PVPFrame] = true
-->>-- Static Popup Special frame
	self:addSkinFrame{obj=PVPFramePopup, ft=ftype, kfs=true, x1=9, y1=-9, x2=-7, y2=9}

end

function Skinner:PetStableFrame()
	if not self.db.profile.PetStableFrame or self.initialized.PetStableFrame then return end
	self.initialized.PetStableFrame = true

	self:add2Table(self.charKeys1, "PetStableFrame")

	self:makeMFRotatable(PetStableModel)

	PetStableFrameModelBg:Hide()
	PetStableModelShadow:Hide()
	PetStableFrame.LeftInset:DisableDrawLayer("BORDER")
	PetStableActiveBg:Hide()
	self:addButtonBorder{obj=PetStablePetInfo, relTo=PetStableSelectedPetIcon}
	for i = 1, NUM_PET_ACTIVE_SLOTS do
		local btn = _G["PetStableActivePet"..i]
		btn.Border:Hide()
		if not self.modBtnBs then
			self:resizeEmptyTexture(btn.Background)
		else
			btn.Background:Hide()
			self:addButtonBorder{obj=btn}
		end
	end
	for i = 1, NUM_PET_STABLE_SLOTS do
		local btn = _G["PetStableStabledPet"..i]
		if not self.modBtnBs then
			self:resizeEmptyTexture(btn.Background)
		else
			btn.Background:Hide()
			self:addButtonBorder{obj=btn}
		end
	end
	PetStableFrame.BottomInset:DisableDrawLayer("BORDER")
	PetStableFrameStableBg:Hide()
	self:addSkinFrame{obj=PetStableFrame, ft=ftype, kfs=true, ri=true, y1=2, x2=1}

end

function Skinner:SpellBookFrame()
	if not self.db.profile.SpellBookFrame or self.initialized.SpellBookFrame then return end
	self.initialized.SpellBookFrame = true

	self:add2Table(self.charKeys1, "SpellBookFrame")

	if self.isTT then
		-- hook to handle tabs
		self:SecureHook("ToggleSpellBook", function(bookType)
			for i = 1, 5 do
				local tabName = _G["SpellBookFrameTabButton"..i]
				local tabSF = self.skinFrame[tabName]
				if tabName.bookType == bookType then
					self:setActiveTab(tabSF, true)
				else
					self:setInactiveTab(tabSF)
				end
			end
		end)
	end

	self:addSkinFrame{obj=SpellBookFrame, ft=ftype, kfs=true, ri=true, y1=2, x2=1, y2=-6}
-->>- Spellbook Panel
	SpellBookPageText:SetTextColor(self.BTr, self.BTg, self.BTb)
	-- hook this to change text colour as required
	self:SecureHook("SpellButton_UpdateButton", function(this)
		if this.UnlearnedFrame and this.UnlearnedFrame:IsShown() then -- level too low
			this.SpellName:SetTextColor(self.HTr, self.HTg, self.HTb)
			this.RequiredLevelString:SetTextColor(self.BTr, self.BTg, self.BTb)
		end
		if this.TrainFrame and this.TrainFrame:IsShown() then -- see Trainer
			this.SpellName:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
			this.SpellSubName:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
		end
		if this.SpellName then
			this.SpellName:SetTextColor(self.HTr, self.HTg, self.HTb)
			this.SpellSubName:SetTextColor(self.BTr, self.BTg, self.BTb)
		end
	end)
-->>-- Professions Panel
	-- Primary professions
	for i = 1, 2 do
		local prof = "PrimaryProfession"..i
		_G[prof.."IconBorder"]:Hide()
		if not _G[prof].missingHeader:IsShown() then
			_G[prof].icon:SetDesaturated(nil) -- show in colour
		end
		_G[prof].missingText:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G[prof].button1:DisableDrawLayer("BACKGROUND")
		_G[prof].button1.subSpellString:SetTextColor(self.BTr, self.BTg, self.BTb)
		self:addButtonBorder{obj=_G[prof].button1, sec=true}
		_G[prof].button2:DisableDrawLayer("BACKGROUND")
		_G[prof].button2.subSpellString:SetTextColor(self.BTr, self.BTg, self.BTb)
		self:addButtonBorder{obj=_G[prof].button2, sec=true}
		_G[prof.."StatusBar"]:DisableDrawLayer("BACKGROUND")
	end
	-- Secondary professions
	for i = 1, 4 do
		local sec = "SecondaryProfession"..i
		_G[sec].missingHeader:SetTextColor(self.HTr, self.HTg, self.HTb)
		_G[sec].missingText:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G[sec].button1:DisableDrawLayer("BACKGROUND")
		_G[sec].button1.subSpellString:SetTextColor(self.BTr, self.BTg, self.BTb)
		self:addButtonBorder{obj=_G[sec].button1, sec=true}
		_G[sec].button2:DisableDrawLayer("BACKGROUND")
		_G[sec].button2.subSpellString:SetTextColor(self.BTr, self.BTg, self.BTb)
		self:addButtonBorder{obj=_G[sec].button2, sec=true}
		_G[sec.."StatusBar"]:DisableDrawLayer("BACKGROUND")
	end
-->>-- Companions/Mounts Panel
	SpellBookCompanionsModelFrame:Hide()
	SpellBookCompanionModelFrameShadowOverlay:Hide()
	self:makeMFRotatable(SpellBookCompanionModelFrame)
	for i = 1, NUM_COMPANIONS_PER_PAGE do
		local btn = _G["SpellBookCompanionButton"..i]
		btn.Background:Hide()
		btn.TextBackground:Hide()
		btn.IconTextureBg:Hide()
		self:addButtonBorder{obj=btn, sec=true}
	end
	-- colour the spell name text
	for i = 1, SPELLS_PER_PAGE do
		local btnName = "SpellButton"..i
		local btn = _G[btnName]
		btn:DisableDrawLayer("BACKGROUND")
		btn:DisableDrawLayer("BORDER")
		_G[btnName.."SlotFrame"]:SetAlpha(0)
		btn.UnlearnedFrame:SetAlpha(0)
		btn.TrainFrame:SetAlpha(0)
		self:addButtonBorder{obj=_G[btnName], sec=true}
	end
-->>-- Tabs (side)
	for i = 1, MAX_SKILLLINE_TABS do
		local tabName = _G["SpellBookSkillLineTab"..i]
		self:removeRegions(tabName, {1}) -- N.B. other regions are icon and highlight
		self:addButtonBorder{obj=tabName}
	end
-->>-- Tabs (bottom)
	local x1, y1, x2, y2
	if self.isPTR then
		x1, y1, x2, y2 = 8, 1, -8, 2
	else
		x1, y1, x2, y2 = 6, 1, -6, 2
	end
	for i = 1, 5 do -- actually only 2, but 3 exist in xml file
		local tabName = _G["SpellBookFrameTabButton"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 1 is the Text, 3 is the highlight
		local tabSF = self:addSkinFrame{obj=tabName, ft=ftype, noBdr=self.isTT, x1=x1, y1=y1, x2=x2, y2=y2}
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end

end

function Skinner:GlyphUI()
	if not self.db.profile.TalentUI or self.initialized.GlyphUI then return end
	self.initialized.GlyphUI = true

	GlyphFrame:DisableDrawLayer("BACKGROUND")
--[=[
	-- Removing the ring texture also removes the empty slots
	for i = 1, NUM_GLYPH_SLOTS do
		_G["GlyphFrameGlyph"..i].ring:SetAlpha(0)
	end
--]=]
	GlyphFrame.sideInset:DisableDrawLayer("BACKGROUND")
	GlyphFrame.sideInset:DisableDrawLayer("BORDER")
	self:skinEditBox{obj=GlyphFrameSearchBox, regs={9}}
	self:moveObject{obj=GlyphFrameSearchBox.searchIcon, x=3}
	self:skinDropDown{obj=GlyphFrameFilterDropDown}
	for i = 1, #GLYPH_STRING do
		self:removeRegions(_G["GlyphFrameHeader"..i], {1, 2, 3})
		self:applySkin{obj=_G["GlyphFrameHeader"..i], ft=ftype, nb=true} -- use applySkin so text is seen
	end
	-- remove Glyph item textures
	for i = 1, #GlyphFrame.scrollFrame.buttons do
		local btn = GlyphFrame.scrollFrame.buttons[i]
		btn:GetNormalTexture():SetAlpha(0)
		btn.selectedTex:SetAlpha(0)
		btn.disabledBG:SetAlpha(0)
		self:addButtonBorder{obj=btn, relTo=btn.icon}
	end
	self:skinSlider{obj=GlyphFrameScrollFrameScrollBar, size=2}
	self:addButtonBorder{obj=GlyphFrameClearInfoFrame}

end

function Skinner:TalentUI() -- LoD
	if not self.db.profile.TalentUI or self.initialized.TalentUI then return end
	self.initialized.TalentUI = true

	self:addSkinFrame{obj=PlayerTalentFrame, ft=ftype, kfs=true, ri=true, y1=2, x2=1, y2=-6}
-->>-- Talents Frame
	for i = 1, 3 do
		local panelName = "PlayerTalentFramePanel"..i
		local panel = _G[panelName]
		-- Summary panel(s)
		panel.Summary.IconBorder:SetAlpha(0) -- so linked item is still position properly
		local sAB1 = panelName.."SummaryActiveBonus1"
		_G[sAB1].IconBorder:Hide()
		self:addButtonBorder{obj=_G[sAB1], relTo=_G[sAB1].Icon}
		for j = 1, 5 do
			local sB = panelName.."SummaryBonus"..j
			_G[sB].IconBorder:Hide()
			self:addButtonBorder{obj=_G[sB], es=12, relTo=_G[sB].Icon}
		end
		self:skinScrollBar{obj=panel.Summary.Description}
		-- talent info panel(s)
		panel:DisableDrawLayer("BORDER")
		panel.HeaderBackground:SetAlpha(0)
		panel.HeaderBorder:SetAlpha(0)
		panel.HeaderIcon:DisableDrawLayer("ARTWORK")
		panel.HeaderIcon.PointsSpentBgGold:SetAlpha(0)
		panel.HeaderIcon.PointsSpentBgSilver:SetAlpha(0)
		if self.modBtnBs then
			self:addButtonBorder{obj=panel.HeaderIcon, relTo=panel.HeaderIcon.Icon}
			panel.HeaderIcon.PointsSpent:SetParent(panel.HeaderIcon.sknrBdr) -- reparent points spent
			panel.HeaderIcon.LockIcon:SetParent(panel.HeaderIcon.sknrBdr) -- reparent lock icon
			-- add button borders
			for i = 1, MAX_NUM_TALENTS do
				self:addButtonBorder{obj=_G[panelName.."Talent"..i], tibt=true}
			end
			RaiseFrameLevel(_G[panelName.."Arrow"]) -- so arrows appear above border
			RaiseFrameLevel(panel.InactiveShadow) -- so arrows appear below the InactiveShadow
			RaiseFrameLevel(panel.Summary) -- so summary panel appears above the InactiveShadow
			RaiseFrameLevel(panel.SelectTreeButton) -- so button can be clicked
		end
	end
	-- Magic Button textures
	for _, v in pairs{"Reset", "Learn", "ToggleSummaries"} do
		local btn = "PlayerTalentFrame"..v.."Button"
		if _G[btn.."_LeftSeparator"] then _G[btn.."_LeftSeparator"]:SetAlpha(0) end
		if _G[btn.."_RightSeparator"] then _G[btn.."_RightSeparator"]:SetAlpha(0) end
	end
-->>-- Pet Talents Panel
	PlayerTalentFramePetPanel:DisableDrawLayer("BORDER")
	PlayerTalentFramePetModelBg:Hide()
	PlayerTalentFramePetShadowOverlay:Hide()
	self:makeMFRotatable(PlayerTalentFramePetModel)
	PlayerTalentFramePetIconBorder:Hide()
	PlayerTalentFramePetPanel.HeaderBackground:Hide()
	PlayerTalentFramePetPanel.HeaderBorder:Hide()
	PlayerTalentFramePetPanel.HeaderIcon.Border:Hide()
	PlayerTalentFramePetPanel.HeaderIcon.PointsSpentBgGold:Hide()
	self:moveObject{obj=PlayerTalentFramePetPanel.HeaderIcon.PointsSpent, x=8}
	if self.modBtnBs then
		self:addButtonBorder{obj=PlayerTalentFramePetInfo, relTo=PlayerTalentFramePetIcon}
		self:addButtonBorder{obj=PlayerTalentFramePetPanel.HeaderIcon}
		for i = 1, 24 do
			local btnName = "PlayerTalentFramePetPanelTalent"..i
			local btn = _G[btnName]
			self:addButtonBorder{obj=btn, tibt=true}
		end
	end
-->>-- Glyph Panel
-- see GlyphUI above
-->>-- Glow boxes
	self:addSkinFrame{obj=PlayerTalentFrameHeaderHelpBox, ft=ftype, kfs=true}
	self:addSkinFrame{obj=PlayerTalentFrameLearnButtonTutorial, ft=ftype, kfs=true, y1=3, x2=3}

-->>-- Tabs (side)
	for i = 1, 2 do
		local tabName = _G["PlayerSpecTab"..i]
		self:removeRegions(tabName, {1}) -- N.B. other regions are icon and highlight
		self:addButtonBorder{obj=tabName}
	end
-->>-- Tabs (bottom)
	for i = 1, PlayerTalentFrame.numTabs do
		local tabName = _G["PlayerTalentFrameTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		local tabSF = self:addSkinFrame{obj=tabName, ft=ftype, noBdr=self.isTT, x1=6, x2=-6, y2=2}
		-- panel opens to last access tab not the first one every time
		if i == PlayerTalentFrame.selectedTab then
			if self.isTT then self:setActiveTab(tabSF, true) end -- done here as Beta only has 1 Tab atm
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end
	self.tabFrames[PlayerTalentFrame] = true

end

function Skinner:DressUpFrame()
	if not self.db.profile.DressUpFrame or self.initialized.DressUpFrame then return end
	self.initialized.DressUpFrame = true

	self:add2Table(self.charKeys1, "DressUpFrame")

	self:removeRegions(DressUpFrame, {1, 2, 3, 4, 5}) -- N.B. regions 6 & 7 are text, 8-11 are the background picture
	self:makeMFRotatable(DressUpModel)
	self:addSkinFrame{obj=DressUpFrame, ft=ftype, x1=10, y1=-12, x2=-33, y2=73}

end

function Skinner:AchievementUI() -- LoD
	if not self.db.profile.AchievementUI.skin or self.initialized.AchievementUI then return end
	self.initialized.AchievementUI = true

	local prdbA = self.db.profile.AchievementUI

	if prdbA.style == 2 then
		ACHIEVEMENTUI_REDBORDER_R = self.bbColour[1]
		ACHIEVEMENTUI_REDBORDER_G = self.bbColour[2]
		ACHIEVEMENTUI_REDBORDER_B = self.bbColour[3]
		ACHIEVEMENTUI_REDBORDER_A = self.bbColour[4]
	end

	local function skinSB(statusBar, type)

		Skinner:moveObject{obj=_G[statusBar..type], y=-3}
		Skinner:moveObject{obj=_G[statusBar.."Text"], y=-3}
		_G[statusBar.."Left"]:SetAlpha(0)
		_G[statusBar.."Right"]:SetAlpha(0)
		_G[statusBar.."Middle"]:SetAlpha(0)
		self:glazeStatusBar(_G[statusBar], 0, _G[statusBar.."FillBar"])

	end
	local function skinStats()

		for i = 1, #AchievementFrameStatsContainer.buttons do
			local button = _G["AchievementFrameStatsContainerButton"..i]
			if button.isHeader then button.background:SetAlpha(0) end
			if button.background:GetAlpha() == 1 then button.background:SetAlpha(0) end
			button.left:SetAlpha(0)
			button.middle:SetAlpha(0)
			button.right:SetAlpha(0)
		end

	end
	local function glazeProgressBar(pBar)

		if not Skinner.sbGlazed[pBaro] then
			_G[pBar.."BorderLeft"]:SetAlpha(0)
			_G[pBar.."BorderRight"]:SetAlpha(0)
			_G[pBar.."BorderCenter"]:SetAlpha(0)
			Skinner:glazeStatusBar(_G[pBar], 0, _G[pBar.."BG"])
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
	local btnObj, btnName
	local function cleanButtons(frame, type)

		if prdbA.style == 1 then return end -- don't remove textures if option not chosen

		-- remove textures etc from buttons
		for i = 1, #frame.buttons do
			btnName = frame.buttons[i]:GetName()..(type == "Comparison" and "Player" or "")
			btnObj = _G[btnName]
			btnObj:DisableDrawLayer("BACKGROUND")
			-- don't DisableDrawLayer("BORDER") as the button border won't show if skinned
			btnObj:DisableDrawLayer("ARTWORK")
			if btnObj.plusMinus then btnObj.plusMinus:SetAlpha(0) end
			btnObj.icon:DisableDrawLayer("BACKGROUND")
			btnObj.icon:DisableDrawLayer("BORDER")
			btnObj.icon:DisableDrawLayer("OVERLAY")
			self:addButtonBorder{obj=btnObj.icon, x1=4, y1=-1, x2=-4, y2=6}
			-- hook this to handle description text colour changes
			self:SecureHook(btnObj, "Saturate", function(this)
				this.description:SetTextColor(self.BTr, self.BTg, self.BTb)
			end)
			if type == "Achievements" then
				-- set textures to nil and prevent them from being changed as guildview changes the textures
				_G[btnName.."TopTsunami1"]:SetTexture(nil)
				_G[btnName.."TopTsunami1"].SetTexture = function() end
				_G[btnName.."BottomTsunami1"]:SetTexture(nil)
				_G[btnName.."BottomTsunami1"].SetTexture = function() end
				btnObj.hiddenDescription:SetTextColor(self.BTr, self.BTg, self.BTb)
			elseif type == "Summary" then
				if not btnObj.tooltipTitle then btnObj:Saturate() end
			elseif type == "Comparison" then
				-- force update to colour the button
				if btnObj.completed then btnObj:Saturate() end
				-- Friend
				btnObj = _G[btnName:gsub("Player", "Friend")]
				btnObj:DisableDrawLayer("BACKGROUND")
				-- don't DisableDrawLayer("BORDER") as the button border won't show if skinned
				btnObj:DisableDrawLayer("ARTWORK")
				btnObj.icon:DisableDrawLayer("BACKGROUND")
				btnObj.icon:DisableDrawLayer("BORDER")
				btnObj.icon:DisableDrawLayer("OVERLAY")
				self:addButtonBorder{obj=btnObj.icon, x1=4, y1=-1, x2=-4, y2=6}
				-- force update to colour the button
				if btnObj.completed then btnObj:Saturate() end
			end
		end

	end

	local bbR, bbG, bbB, bbA = unpack(self.bbColour)

	self:moveObject{obj=AchievementFrameFilterDropDown, y=-10}
	if self.db.profile.TexturedDD then
		local tex = AchievementFrameFilterDropDown:CreateTexture(nil, "BORDER")
		tex:SetTexture(self.itTex)
		tex:SetWidth(110)
		tex:SetHeight(19)
		tex:SetPoint("RIGHT", AchievementFrameFilterDropDown, "RIGHT", -3, 4)
	end
	self:addSkinFrame{obj=AchievementFrame, ft=ftype, kfs=true, y1=1, y2=-3}

-->>-- move Header info
	self:keepFontStrings(AchievementFrameHeader)
	self:moveObject{obj=AchievementFrameHeaderTitle, x=-60, y=-29}
	self:moveObject{obj=AchievementFrameHeaderPoints, x=40, y=-9}
	AchievementFrameHeaderShield:SetAlpha(1)

-->>-- Categories Panel (on the Left)
	self:skinSlider(AchievementFrameCategoriesContainerScrollBar)
	self:addSkinFrame{obj=AchievementFrameCategories, ft=ftype, y2=-2}
	self:SecureHook("AchievementFrameCategories_Update", function()
		skinCategories()
	end)
	skinCategories()

-->>-- Achievements Panel (on the right)
	self:keepFontStrings(AchievementFrameAchievements)
	self:getChild(AchievementFrameAchievements, 2):SetBackdropBorderColor(bbR, bbG, bbB, bbA) -- frame border
	self:skinSlider(AchievementFrameAchievementsContainerScrollBar)
	if prdbA.style == 2 then
		-- remove textures etc from buttons
		cleanButtons(AchievementFrameAchievementsContainer, "Achievements")
		-- hook this to handle objectives text colour changes
		self:SecureHookScript(AchievementFrameAchievementsObjectives, "OnShow", function(this)
			if this.completed then
				for _, child in ipairs{this:GetChildren()} do
					for _, reg in ipairs{child:GetRegions()} do
						if reg:IsObjectType("FontString") then
							reg:SetTextColor(self.BTr, self.BTg, self.BTb)
						end
					end
				end
			end
		end)
		-- hook this to remove icon border used by the Objectives mini panels
		self:RawHook("AchievementButton_GetMeta", function(index)
			local frame = self.hooks["AchievementButton_GetMeta"](index)
			frame:DisableDrawLayer("BORDER")
			self:addButtonBorder{obj=frame, es=12, relTo=frame.icon}
			return frame
		end, true)
	end
	-- glaze any existing progress bars
	for i = 1, 10 do
		local pBar = "AchievementFrameProgressBar"..i
		if _G[pBar] then glazeProgressBar(pBar) end
	end
	-- hook this to skin StatusBars used by the Objectives mini panels
	self:RawHook("AchievementButton_GetProgressBar", function(index)
		local pBaro = self.hooks["AchievementButton_GetProgressBar"](index)
		glazeProgressBar(pBaro:GetName())
		return pBaro
	end, true)

-->>-- Stats
	self:keepFontStrings(AchievementFrameStats)
	self:skinSlider(AchievementFrameStatsContainerScrollBar)
	AchievementFrameStatsBG:SetAlpha(0)
	self:getChild(AchievementFrameStats, 3):SetBackdropBorderColor(bbR, bbG, bbB, bbA) -- frame border
	-- hook this to skin buttons
	self:SecureHook("AchievementFrameStats_Update", function()
		skinStats()
	end)
	skinStats()

-->>-- Summary Panel
	self:keepFontStrings(AchievementFrameSummary)
	AchievementFrameSummaryBackground:SetAlpha(0)
	AchievementFrameSummaryAchievementsHeaderHeader:SetAlpha(0)
	self:skinSlider(AchievementFrameAchievementsContainerScrollBar)
	-- remove textures etc from buttons
	if not AchievementFrameSummary:IsShown() and prdbA.style == 2 then
		self:SecureHookScript(AchievementFrameSummary, "OnShow", function()
			cleanButtons(AchievementFrameSummaryAchievements, "Summary")
			self:Unhook(AchievementFrameSummary, "OnShow")
		end)
	else
		cleanButtons(AchievementFrameSummaryAchievements, "Summary")
	end
	-- Categories SubPanel
	self:keepFontStrings(AchievementFrameSummaryCategoriesHeader)
	for i = 1, 8 do
		skinSB("AchievementFrameSummaryCategoriesCategory"..i, "Label")
	end
	self:getChild(AchievementFrameSummary, 1):SetBackdropBorderColor(bbR, bbG, bbB, bbA) -- frame border
	skinSB("AchievementFrameSummaryCategoriesStatusBar", "Title")

-->>-- Comparison Panel
	AchievementFrameComparisonBackground:SetAlpha(0)
	AchievementFrameComparisonDark:SetAlpha(0)
	AchievementFrameComparisonWatermark:SetAlpha(0)
	-- Header
	self:keepFontStrings(AchievementFrameComparisonHeader)
	AchievementFrameComparisonHeaderShield:SetAlpha(1)
	-- move header info
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
	for _, type in pairs{"Player", "Friend"} do
		_G["AchievementFrameComparisonSummary"..type]:SetBackdrop(nil)
		_G["AchievementFrameComparisonSummary"..type.."Background"]:SetAlpha(0)
		skinSB("AchievementFrameComparisonSummary"..type.."StatusBar", "Title")
	end
	-- remove textures etc from buttons
	if not AchievementFrameComparison:IsShown() and prdbA.style == 2 then
		self:SecureHookScript(AchievementFrameComparison, "OnShow", function()
			cleanButtons(AchievementFrameComparisonContainer, "Comparison")
			self:Unhook(AchievementFrameSummary, "OnShow")
		end)
	else
		cleanButtons(AchievementFrameComparisonContainer, "Comparison")
	end
	-- Stats Panel
	self:skinSlider(AchievementFrameComparisonStatsContainerScrollBar)
	self:SecureHook("AchievementFrameComparison_UpdateStats", function()
		skinComparisonStats()
	end)
	self:SecureHook(AchievementFrameComparisonStatsContainer, "Show", function()
		skinComparisonStats()
	end)
	if achievementFunctions == COMPARISON_STAT_FUNCTIONS then skinComparisonStats() end

-->>-- Tabs
	for i = 1, AchievementFrame.numTabs do
		local tabName = _G["AchievementFrameTab"..i]
		tabName.text.SetPoint = function() end -- stop text moving
		self:keepRegions(tabName, {7, 8, 9, 10}) -- N.B. region 7, 8 & 9 are highlights, 10 is text
		local tabSF = self:addSkinFrame{obj=tabName, ft=ftype, noBdr=self.isTT, x1=9, y1=2, x2=-9, y2=-10}
		if i == AchievementFrame.selectedTab then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end
	self.tabFrames[AchievementFrame] = true

end

function Skinner:AlertFrames()
	if not self.db.profile.AlertFrames or self.initialized.AlertFrames then return end
	self.initialized.AlertFrames = true

	self:add2Table(self.charKeys1, "AlertFrames")

	local aafName = "AchievementAlertFrame"

	local function skinAlertFrames()

		for i = 1, MAX_ACHIEVEMENT_ALERTS do
			local aaFrame = _G[aafName..i]
			if aaFrame and not Skinner.skinFrame[aaFrame] then
				_G[aafName..i.."Background"]:Hide() -- hide this as Alpha value is changed in Bliz code (3.1.2)
				_G[aafName..i.."Unlocked"]:SetTextColor(Skinner.BTr, Skinner.BTg, Skinner.BTb)
				local icon = _G[aafName..i.."Icon"]
				icon:DisableDrawLayer("BACKGROUND")
				icon:DisableDrawLayer("BORDER")
				icon:DisableDrawLayer("OVERLAY")
				Skinner:addButtonBorder{obj=icon, relTo=_G[aafName..i.."IconTexture"]}
				Skinner:addSkinFrame{obj=aaFrame, ft=ftype, anim=true, x1=7, y1=-13, x2=-7, y2=16}
			end
		end

	end
	-- check for both Achievement Alert frames now, (3.1.2) as the Bliz code changed
	if not AchievementAlertFrame1 or AchievementAlertFrame2 then
		self:SecureHook(aafName.."_GetAlertFrame", function()
			skinAlertFrames()
			if AchievementAlertFrame2 then
				self:Unhook(aafName.."_GetAlertFrame")
			end
		end)
	end
	-- skin any existing Achievement Alert Frames
	skinAlertFrames()

	-- hook dungeon rewards function
	self:SecureHook("DungeonCompletionAlertFrameReward_SetReward", function(frame, index)
		frame:DisableDrawLayer("OVERLAY") -- border texture
	end)

	-- dungeon completion alert frame will already exist, only 1 atm (0.3.0.10772)
	DungeonCompletionAlertFrame1:DisableDrawLayer("BORDER") -- border textures
	_G["DungeonCompletionAlertFrame1Reward1"]:DisableDrawLayer("OVERLAY") -- border texture
	self:addSkinFrame{obj=DungeonCompletionAlertFrame1, ft=ftype, anim=true, x1=5, y1=-13, x2=-5, y2=4}

end
