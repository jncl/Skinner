local _G = _G
local ftype = "c"

function Skinner:CharacterFrames()
	if not self.db.profile.CharacterFrames or self.initialized.CharacterFrames then return end
	self.initialized.CharacterFrames = true

	-- skin each sub frame
	self:checkAndRun("CharacterFrame")
	for _, v in pairs{"PaperDollFrame", "PetPaperDollFrame", "ReputationFrame", "SkillFrame", "TokenFrame"} do
		self:checkAndRun(v)
	end

end

function Skinner:CharacterFrame()

	if not self.isBeta then
		self:addSkinFrame{obj=CharacterFrame, ft=ftype, kfs=true, bgen=2, x1=10, y1=-12, x2=-31, y2=71} -- only allow 2 generations of button children, Outfitter adds extra generations that we don't want to handle here
	else
		CharacterFrameInsetRight:DisableDrawLayer("BACKGROUND")
		CharacterFrameInsetRight:DisableDrawLayer("BORDER")
		self:addSkinFrame{obj=CharacterFrame, ft=ftype, kfs=true, ri=true, bgen=2, y1=2, x2=1, y2=-4}
	end

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

	if self.isBeta then
		for _, child in ipairs{PaperDollItemsFrame:GetChildren()} do
			child:DisableDrawLayer("BACKGROUND")
		end
		CharacterModelFrame:DisableDrawLayer("BACKGROUND")
		CharacterModelFrame:DisableDrawLayer("BORDER")
		CharacterModelFrame:DisableDrawLayer("OVERLAY")
	end
	self:keepFontStrings(PaperDollFrame)
	self:skinDropDown{obj=PlayerTitleFrame}
	self:moveObject{obj=PlayerTitleFrameButton, y=1}
	self:skinScrollBar{obj=PlayerTitlePickerScrollFrame}
	self:addSkinFrame{obj=PlayerTitlePickerFrame, kfs=true, ft=ftype}
	self:makeMFRotatable(CharacterModelFrame)
	if not self.isBeta then
	   self:keepFontStrings(CharacterAttributesFrame)
	else
		CharacterStatsPane:DisableDrawLayer("ARTWORK")
		self:skinSlider{obj=CharacterStatsPaneScrollBar, size=3}
	end
    if not self.isBeta then
    	self:skinDropDown{obj=PlayerStatFrameLeftDropDown, moveTex=true}
	    self:skinDropDown{obj=PlayerStatFrameRightDropDown, moveTex=true}
	    self:removeRegions(CharacterAmmoSlot, {1})
    end
	-- hide ItemFlyout background textures
	local bA = PaperDollFrameItemFlyout.buttonFrame
	self:addSkinFrame{obj=bA, ft=ftype, x1=-3, y1=2, x2=5, y2=-3}
	self:SecureHook("PaperDollFrameItemFlyout_Show", function(paperDollItemSlot)
--		self:Debug("PDFIF_S: [%s]", paperDollItemSlot)
		for i = 1, bA["numBGs"] do
			bA["bg" .. i]:SetAlpha(0)
		end
	end)

end

function Skinner:PetPaperDollFrame()

-->>-- Pet Frame
	if not self.isBeta then
	   self:keepFontStrings(PetPaperDollFrame)
	   self:skinAllButtons{obj=PetPaperDollFrame}
	   self:keepFontStrings(PetAttributesFrame)
	else
		PetPaperDollPetModelBg:SetAlpha(0) -- changed in code
		PetModelFrameShadowOverlay:Hide()
	end
	self:removeRegions(PetPaperDollFrameExpBar, {1, 2})
	self:glazeStatusBar(PetPaperDollFrameExpBar, 0)
	self:makeMFRotatable(PetModelFrame)
	-- up the Frame level otherwise the tooltip doesn't work
	RaiseFrameLevel(PetPaperDollPetInfo)

    if not self.isBeta then
        -->>-- Companion Frame
    	self:keepFontStrings(PetPaperDollFrameCompanionFrame)
    	self:makeMFRotatable(CompanionModelFrame)
    end
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

function Skinner:SkillFrame()

	if not self.isBeta then
    	if self.modBtns then
    		-- hook to manage changes to button textures
    		self:SecureHook("SkillFrame_UpdateSkills", function()
    			for i = 1, SKILLS_TO_DISPLAY do
    				self:checkTex(_G["SkillTypeLabel"..i])
    			end
    			self:checkTex(SkillFrameCollapseAllButton)
    		end)
    	end
	   self:keepFontStrings(SkillFrame)
	   self:skinAllButtons{obj=SkillFrame}
	   self:removeRegions(SkillFrameExpandButtonFrame)
	   self:skinScrollBar{obj=SkillListScrollFrame}
    	-- m/p buttons
    	for i = 1, SKILLS_TO_DISPLAY do
    		local bar = "SkillRankFrame"..i
    		_G[bar.."BorderNormal"]:SetAlpha(0)
    		self:glazeStatusBar(_G[bar], 0, _G[bar.."Background"], {_G[bar.."FillBar"]})
    		self:skinButton{obj=_G["SkillTypeLabel"..i], mp=true}
    	end
    	self:skinButton{obj=SkillFrameCollapseAllButton, mp=true}
    	-- detail frame
    	self:skinScrollBar{obj=SkillDetailScrollFrame}
    	local bar = "SkillDetailStatusBar"
    	_G[bar.."Border"]:SetAlpha(0)
    	self:glazeStatusBar(_G[bar], 0, _G[bar.."Background"], {_G[bar.."FillBar"]})
	end

end

function Skinner:TokenFrame() -- a.k.a. Currency Frame

	if self.db.profile.ContainerFrames.skin then
		BACKPACK_TOKENFRAME_HEIGHT = BACKPACK_TOKENFRAME_HEIGHT - 6
		BackpackTokenFrame:DisableDrawLayer("BACKGROUND")
	end

	self:keepFontStrings(TokenFrame)
	self:skinAllButtons{obj=TokenFrame}
	-- hide the close button
	if not self.isBeta then
	   self:getChild(TokenFrame, 4):Hide()
	end
	self:skinScrollBar{obj=TokenFrameContainer}

    if not self.isBeta then
    	-- remove header textures
    	for i = 1, #TokenFrameContainer.buttons do
    		TokenFrameContainer.buttons[i].categoryLeft:SetAlpha(0)
    		TokenFrameContainer.buttons[i].categoryRight:SetAlpha(0)
    	end
	else
		self:SecureHookScript(TokenFrame, "OnShow", function(this)
	    	-- remove header textures
	    	for i = 1, #TokenFrameContainer.buttons do
				self:removeRegions(TokenFrameContainer.buttons[i], {6, 7, 8})
	    	end
			self:Unhook(TokenFrame, "OnShow")
		end)
    end
-->>-- Popup Frame
	self:addSkinFrame{obj=TokenFramePopup,ft=ftype, kfs=true, y1=-6, x2=-6, y2=6}

end

function Skinner:PVPFrame()
	if not self.db.profile.PVPFrame or self.initialized.PVPFrame then return end
	self.initialized.PVPFrame = true

	if not self.isBeta then
        self:keepFontStrings(PVPFrame)
        self:addSkinFrame{obj=PVPParentFrame, ft=ftype, kfs=true, x1=10, y1=-12, x2=-32, y2=71}
        -->>-- PVP Battleground Frame
    	self:keepFontStrings(PVPBattlegroundFrame)
    	self:skinSlider{obj=PVPBattlegroundFrameInfoScrollFrameScrollBar}
    	PVPBattlegroundFrameInfoScrollFrameChildFrameDescription:SetTextColor(self.BTr, self.BTg, self.BTb)
    	PVPBattlegroundFrameInfoScrollFrameChildFrameRewardsInfo.description:SetTextColor(self.BTr, self.BTg, self.BTb)
    	self:skinScrollBar{obj=PVPBattlegroundFrameTypeScrollFrame}
    	self:moveObject{obj=PVPBattlegroundFrameCancelButton, x=-2}
    -->>-- PVP Team Details Frame
    	self:skinDropDown{obj=PVPDropDown}
    	self:skinFFColHeads("PVPTeamDetailsFrameColumnHeader", 5)
    	self:addSkinFrame{obj=PVPTeamDetails, ft=ftype, kfs=true, x1=8, y1=-2, x2=-2, y2=12}
    -->>-- Tabs
    	for i = 1, PVPParentFrame.numTabs do
    		local tabName = _G["PVPParentFrameTab"..i]
    		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is text, 8 is highlight
    		local tabSF = self:addSkinFrame{obj=tabName, ft=ftype, noBdr=self.isTT, x1=6, x2=-6, y2=2}
    		if i == 1 then
    			if self.isTT then self:setActiveTab(tabSF) end
    		else
    			if self.isTT then self:setInactiveTab(tabSF) end
    		end
    	end
    	self.tabFrames[PVPParentFrame] = true
	else
		PVPFrame.topInset:DisableDrawLayer("BACKGROUND")
		PVPFrame.topInset:DisableDrawLayer("BORDER")
		self:glazeStatusBar(PVPFrameConquestBar, 0,  PVPFrameConquestBarBG)
		PVPFrameConquestBarBorder:Hide()
        self:addSkinFrame{obj=PVPFrame, ft=ftype, kfs=true, ri=true, x1=-2, y1=2, x2=1, y2=-8}
	-->>-- Honor frame
		self:keepFontStrings(PVPHonorFrame)
		self:skinScrollBar{obj=PVPHonorFrame.bgTypeScrollFrame}
		PVPHonorFrameInfoScrollFrameChildFrameDescription:SetTextColor(self.BTr, self.BTg, self.BTb)
		PVPHonorFrameInfoScrollFrameChildFrameRewardsInfo.description:SetTextColor(self.BTr, self.BTg, self.BTb)
	-->>-- Conquest frame
		self:keepFontStrings(PVPConquestFrame)
	-->>-- Team Management frame
		self:keepFontStrings(PVPTeamManagementFrame)
		PVPTeamManagementFrame.flag2.NormalHeader:SetAlpha(0)
		PVPTeamManagementFrame.flag3.NormalHeader:SetAlpha(0)
		PVPTeamManagementFrame.flag5.NormalHeader:SetAlpha(0)
		self:keepFontStrings(PVPTeamManagementFrameWeeklyDisplay)
		self:skinUsingBD{obj=PVPTeamManagementFrameWeeklyDisplay}
		self:skinScrollBar{obj=PVPTeamManagementFrameTeamScrollFrame}
		self:skinDropDown{obj=PVPTeamManagementFrameTeamDropDown}
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
    end

end

function Skinner:PetStableFrame()
	if not self.db.profile.PetStableFrame or self.initialized.PetStableFrame then return end
	self.initialized.PetStableFrame = true

	self:makeMFRotatable(PetStableModel)
	-- up the Frame level otherwise the tooltip doesn't work
	if not self.isBeta then
		RaiseFrameLevel(PetStablePetInfo)
		self:addSkinFrame{obj=PetStableFrame, ft=ftype, kfs=true, x1=10, y1=-11, x2=-32, y2=71}
	else
		PetStableFrameModelBg:Hide()
		PetStableModelShadow:Hide()
		PetStableFrame.LeftInset:DisableDrawLayer("BORDER")
		PetStableActiveBg:Hide()
		for i = 1, NUM_PET_ACTIVE_SLOTS do
			_G["PetStableActivePet"..i.."Border"]:Hide()
			_G["PetStableActivePet"..i.."Background"]:Hide()
			self:addSkinButton{obj=_G["PetStableActivePet"..i], parent=_G["PetStableActivePet"..i], hook=_G["PetStableActivePet"..i]}
		end
		for i = 1, NUM_PET_STABLE_SLOTS do
			_G["PetStableStabledPet"..i.."Background"]:Hide()
			self:addSkinButton{obj=_G["PetStableStabledPet"..i], parent=_G["PetStableStabledPet"..i], hook=_G["PetStableStabledPet"..i]}
		end
		PetStableFrame.BottomInset:DisableDrawLayer("BORDER")
		PetStableFrameStableBg:Hide()
		self:addSkinFrame{obj=PetStableFrame, ft=ftype, kfs=true, ri=true, y1=2, x2=1}
	end

end

function Skinner:SpellBookFrame()
	if not self.db.profile.SpellBookFrame or self.initialized.SpellBookFrame then return end
	self.initialized.SpellBookFrame = true

	if self.isTT then
		-- hook to handle tabs
		self:SecureHook("ToggleSpellBook", function(bookType)
			for i = 1, self.isBeta and 5 or 3 do
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

	if not self.isBeta then
        self:SecureHook("SpellBookFrame_Update", function(showing)
    		if SpellBookFrame.bookType ~= INSCRIPTION then
    			SpellBookTitleText:Show()
    		else
    			SpellBookTitleText:Hide() -- hide Inscriptions title
    		end
	    end)
		self:addSkinFrame{obj=SpellBookFrame, ft=ftype, kfs=true, x1=10, y1=-12, x2=-31, y2=70}
	else
		self:addSkinFrame{obj=SpellBookFrame, ft=ftype, kfs=true, ri=true, y1=2, x2=1, y2=-4}
	-->>- Spellbook Panel
		SpellBookPageText:SetTextColor(self.BTr, self.BTg, self.BTb)
		-- hook this to change text colour as required
		self:SecureHook("SpellButton_UpdateButton", function(this)
			if this.UnlearnedFrame and this.UnlearnedFrame:IsShown() then -- level too low
				this.SpellName:SetTextColor(self.HTr, self.HTg, self.HTb)
				this.RequiredLevelString:SetTextColor(self.BTr, self.BTg, self.BTb)
			end
			if this.TrainFrame:IsShown() then -- see Trainer
				this.SpellName:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
				this.SpellSubName:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
			else
				this.SpellName:SetTextColor(self.HTr, self.HTg, self.HTb)
				this.SpellSubName:SetTextColor(self.BTr, self.BTg, self.BTb)
			end
		end)
	-->>-- Professions Panel
		-- Primary professions
		for i = 1, 2 do
			local prof = "PrimaryProfession"..i
			_G[prof.."IconBorder"]:Hide()
			_G[prof].missingText:SetTextColor(self.BTr, self.BTg, self.BTb)
			_G[prof].button1:DisableDrawLayer("BACKGROUND")
			_G[prof].button1.subSpellString:SetTextColor(self.BTr, self.BTg, self.BTb)
			_G[prof].button2:DisableDrawLayer("BACKGROUND")
			_G[prof].button2.subSpellString:SetTextColor(self.BTr, self.BTg, self.BTb)
			_G[prof.."StatusBar"]:DisableDrawLayer("BACKGROUND")
		end
		-- Secondary professions
		for i = 1, 4 do
			local sec = "SecondaryProfession"..i
			_G[sec].missingHeader:SetTextColor(self.HTr, self.HTg, self.HTb)
			_G[sec].missingText:SetTextColor(self.BTr, self.BTg, self.BTb)
			_G[sec].button1:DisableDrawLayer("BACKGROUND")
			_G[sec].button1.subSpellString:SetTextColor(self.BTr, self.BTg, self.BTb)
			_G[sec].button2:DisableDrawLayer("BACKGROUND")
			_G[sec].button2.subSpellString:SetTextColor(self.BTr, self.BTg, self.BTb)
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
			self:addSkinButton{obj=btn, parent=btn, hook=btn}
		end
	end
	-- colour the spell name text
	for i = 1, SPELLS_PER_PAGE do
		if not self.isBeta then
			_G["SpellButton"..i.."Background"]:SetAlpha(0)
			_G["SpellButton"..i.."SpellName"]:SetTextColor(self.HTr, self.HTg, self.HTb)
			_G["SpellButton"..i.."SubSpellName"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		else
			local btn = _G["SpellButton"..i]
			btn:DisableDrawLayer("BACKGROUND")
			btn:DisableDrawLayer("BORDER")
			btn:DisableDrawLayer("OVERLAY")
		end
	end
-->>-- Tabs (bottom)
	for i = 1, self.isBeta and 5 or 3 do -- actually only 2, but 3 exist in xml file
		local tabName = _G["SpellBookFrameTabButton"..i]
		self:keepRegions(tabName, {1, 3}) -- N.B. region 1 is the Text, 3 is the highlight
		local tabSF = self:addSkinFrame{obj=tabName, ft=ftype, noBdr=self.isTT, x1=14, y1=-16, x2=-10, y2=18}
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end
-->>-- Tabs (side)
	for i = 1, MAX_SKILLLINE_TABS do
		self:removeRegions(_G["SpellBookSkillLineTab"..i], {1}) -- N.B. other regions are icon and highlight
	end

end

function Skinner:GlyphUI()
	if not self.db.profile.TalentUI or self.initialized.GlyphUI then return end
	self.initialized.GlyphUI = true

	if not self.isBeta then
		self:removeRegions(GlyphFrame, {1}) -- background texture
	else
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
		self:skinDropDown{obj=GlyphFrameFilterDropDown}
		for i = 1, #GLYPH_STRING do
			self:removeRegions(_G["GlyphFrameHeader"..i], {1, 2, 3})
			self:applySkin{obj=_G["GlyphFrameHeader"..i], ft=ftype, nb=true} -- use applySkin so text is seen
		end
		self:skinSlider{obj=GlyphFrameScrollFrameScrollBar, size=2}
	end

end

function Skinner:TalentUI()
	if not self.db.profile.TalentUI or self.initialized.TalentUI then return end
	self.initialized.TalentUI = true

	if not self.isBeta then
			-- hook this to hide/show objects when glyph frame shown
		self:SecureHook("TalentFrame_Update", function(this)
			if this == PlayerTalentFrame then
				for i = 1, PlayerTalentFrame.numTabs do
					-- check to see if this is the glyph frame, if so, hide some objects
					if i == PlayerTalentFrame.numTabs and i == PlayerTalentFrame.selectedTab then
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

		self:keepRegions(PlayerTalentFrame, {2, 7}) -- N.B. 2 is Active Spec Tab Highlight, 7 is the title
		self:removeRegions(PlayerTalentFrameScrollFrame, {5, 6}) -- other regions are background textures
		self:skinScrollBar{obj=PlayerTalentFrameScrollFrame, noRR=true}
		self:keepFontStrings(PlayerTalentFrameStatusFrame)
		self:keepFontStrings(PlayerTalentFramePointsBar)
		self:keepFontStrings(PlayerTalentFramePreviewBar)
		self:keepFontStrings(PlayerTalentFramePreviewBarFiller)
		self:addSkinFrame{obj=PlayerTalentFrame, ft=ftype, x1=10, y1=-12, x2=-31, y2=71}

	else
		self:addSkinFrame{obj=PlayerTalentFrame, ft=ftype, kfs=true, ri=true, y1=2, x2=1, y2=-6}
	-->>-- Talents Panel
		for i = 1, 3 do
			local panel = _G["PlayerTalentFramePanel"..i]
			-- Summary panel(s)
			panel.Summary.IconBorder:SetAlpha(0) -- so linked item is still position properly
			_G["PlayerTalentFramePanel"..i.."SummaryActiveBonus1"].IconBorder:Hide()
			for j = 1, 5 do
				_G["PlayerTalentFramePanel"..i.."SummaryBonus"..j].IconBorder:Hide()
			end
			self:skinScrollBar{obj=panel.Summary.Description}
			-- talent info panel(s)
			panel:DisableDrawLayer("BORDER")
			panel.HeaderBackground:Hide()
			panel.HeaderBorder:Hide()
			panel.HeaderIcon.PrimaryBorder:Hide()
			panel.HeaderIcon.SecondaryBorder:Hide()
			panel.HeaderIcon.PointsSpentBgGold:Hide()
			panel.HeaderIcon.PointsSpentBgSilver:Hide()
		end
	-->>-- Pet Talents Panel
		PlayerTalentFramePetModelBg:Hide()
		PlayerTalentFramePetShadowOverlay:Hide()
		self:makeMFRotatable(PlayerTalentFramePetModel)
		PlayerTalentFramePetIconBorder:Hide()
		PlayerTalentFramePetPanel.HeaderBackground:Hide()
		PlayerTalentFramePetPanel.HeaderBorder:Hide()
		PlayerTalentFramePetPanel.HeaderIcon.Border:Hide()
		PlayerTalentFramePetPanel.HeaderIcon.PointsSpentBgGold:Hide()
		PlayerTalentFramePetPanel:DisableDrawLayer("BORDER")
	-->>-- Glyph Panel
	-- see GlyphUI above
	end

-->>-- Tabs (side)
	for i = 1, self.isBeta and 2 or 3 do
		local tabName = _G["PlayerSpecTab"..i]
		self:removeRegions(tabName, {1}) -- N.B. other regions are icon and highlight
	end
-->>-- Tabs (bottom)
	for i = 1, PlayerTalentFrame.numTabs do
		local tabName = _G["PlayerTalentFrameTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		local tabSF = self:addSkinFrame{obj=tabName, ft=ftype, noBdr=self.isTT, x1=6, x2=-6, y2=2}
		-- panel opens to last access tab not the first one every time
		if i == PlayerTalentFrame.selectedTab then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end
	self.tabFrames[PlayerTalentFrame] = true

end

function Skinner:DressUpFrame()
	if not self.db.profile.DressUpFrame or self.initialized.DressUpFrame then return end
	self.initialized.DressUpFrame = true

	self:removeRegions(DressUpFrame, {1, 2, 3, 4, 5}) -- N.B. regions 6 & 7 are text, 8-11 are the background picture
	self:makeMFRotatable(DressUpModel)
	self:addSkinFrame{obj=DressUpFrame, ft=ftype, x1=10, y1=-12, x2=-33, y2=73}

end

function Skinner:AchievementUI()
	if not self.db.profile.AchievementUI or self.initialized.AchievementUI then return end
	self.initialized.AchievementUI = true

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

	self:SecureHook("AchievementFrameStats_Update", function()
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
				Skinner:addSkinFrame{obj=aaFrame, ft=ftype, x1=7, y1=-13, x2=-7, y2=16}
				Skinner:reParentSF(aaFrame)
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
	self:addSkinFrame{obj=DungeonCompletionAlertFrame1, ft=ftype, x1=5, y1=-13, x2=-5, y2=4}
	Skinner:reParentSF(DungeonCompletionAlertFrame1)

end
