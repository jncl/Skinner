local aName, aObj = ...
if not aObj:isAddonEnabled("Armory") then return end

function aObj:Armory()

	-- Armory frame
	self:moveObject{obj=ArmoryBuffFrame, y=-2} -- buff buttons, top of frame
	self:moveObject{obj=ArmoryFramePortrait, x=6, y=-10}
	self:moveObject{obj=ArmoryFramePortraitButton, x=6, y=-10}
	-- move character selection buttons to top of portrait
	self:moveObject{obj=ArmoryFrameLeftButton, x=-2, y=64}
	self:moveObject{obj=ArmoryFrameRightButton, x=-2, y=64}
	self:removeInset(ArmoryFrame.Inset)
	self:removeInset(ArmoryFrameInsetRight)
	self:addSkinFrame{obj=ArmoryFrame, kfs=true, nb=true, y1=2, x2=1, y2=-5}
	self:skinButton{obj=ArmoryFrameCloseButton, cb=true}
	self:addButtonBorder{obj=ArmorySelectCharacter, ofs=0, y1=-1, x2=-1}
	ArmoryFramePortrait:SetAlpha(1) -- used to delete characters
	-- Tabs
	self:skinTabs{obj=ArmoryFrame, lod=true}

	-- Tabs (RHS)
	for i = 1, ARMORY_MAX_LINE_TABS do
		local tabName = _G["ArmoryFrameLineTab" .. i]
		self:removeRegions(tabName, {1}) -- N.B. region 2 is the icon, 3 is the text
		-- Move the first entry as all the others are positioned from it
		if i == 1 then self:moveObject{obj=tabName, x=-2} end
	end

-->>-- DropDown Menus
	for i = 1, 2 do
		local ddM = "ArmoryDropDownList" .. i
		_G[ddM .. "Backdrop"]:SetAlpha(0)
		_G[ddM .. "MenuBackdrop"]:SetAlpha(0)
		self:addSkinFrame{obj=_G[ddM], kfs=true}
	end

-->>--	PaperDoll Frame
	self:keepFontStrings(ArmoryPaperDollFrame)
	self:addButtonBorder{obj=ArmoryGearSetToggleButton, x1=0, x2=0}
	for i = 1, MAX_EQUIPMENT_SETS_PER_PLAYER do
		local btn = _G["ArmoryGearSetButton" .. i]
		btn:DisableDrawLayer("BACKGROUND")
		self:addButtonBorder{obj=btn, relTo=btn.icon, reParent={btn.text}}
	end
	self:addSkinFrame{obj=ArmoryGearSetFrame, kfs=true}
	self:keepFontStrings(ArmoryPaperDollTalent)
	for i = 1, 2 do
		local sBar = "ArmoryPaperDollTradeSkillFrame" .. i
		self:glazeStatusBar(_G[sBar .. "Bar"])
		self:glazeStatusBar(_G[sBar .. "BackgroundBar"])
		_G[sBar .. "BackgroundBar"]:SetStatusBarColor(unpack(self.sbColour))
	end
	self:keepFontStrings(ArmoryPaperDollTradeSkill)
	self:skinDropDown{obj=ArmoryAttributesFramePlayerStatDropDown}
	ArmoryAttributesFrame:DisableDrawLayer("BACKGROUND")
	-- slots
	for _, child in ipairs{ArmoryPaperDollItemsFrame:GetChildren()} do
		child:DisableDrawLayer("BACKGROUND")
		self:addButtonBorder{obj=child}
	end

-->>-- PaperDollOverlay Frame
	self:keepFontStrings(ArmoryPaperDollTalentOverlay)
	for i = 1, 2 do
		local sBar = "ArmoryPaperDollTradeSkillOverlayFrame" .. i
		self:glazeStatusBar(_G[sBar .. "Bar"])
		self:glazeStatusBar(_G[sBar .. "BackgroundBar"])
		_G[sBar .. "BackgroundBar"]:SetStatusBarColor(unpack(self.sbColour))
	end
	self:keepFontStrings(ArmoryPaperDollTradeSkillOverlay)
	self:skinDropDown{obj=ArmoryAttributesOverlayTopFramePlayerStatDropDown}
	ArmoryAttributesOverlayTopFrame:DisableDrawLayer("BACKGROUND")
	self:skinDropDown{obj=ArmoryAttributesOverlayBottomFramePlayerStatDropDown}
	ArmoryAttributesOverlayBottomFrame:DisableDrawLayer("BACKGROUND")

-->>-- Pet Frame
	self:addButtonBorder{obj=ArmoryPetFramePetInfo, relTo=ArmoryPetFrameSelectedPetIcon}
	ArmoryPetSpecFrame.ring:SetAlpha(0)
	-- Specs
	for i = 1, 6 do
		_G["ArmoryPetAbility" .. i].ring:SetAlpha(0)
	end
	-- Stats
	for i = 1, 7 do
		local frame = _G["ArmoryPetStatsPaneCategory" .. i]
		frame.BgTop:SetAlpha(0)
		frame.BgBottom:SetAlpha(0)
		frame.BgMiddle:SetAlpha(0)
		frame.BgMinimized:SetAlpha(0)
	end
	-- Pets buttons
	for i = 1, 5 do
		_G["ArmoryPetFramePet" .. i .. "Background"]:SetAlpha(0)
		self:addButtonBorder{obj=_G["ArmoryPetFramePet" .. i]}
	end
	self:addButtonBorder{obj=ArmoryPetFrameNextPageButton, ofs=0}
	self:addButtonBorder{obj=ArmoryPetFramePrevPageButton, ofs=0}

-->>--	Talents Frame
	self:removeRegions(ArmoryTalentFrame, {2}) -- horizontal line
	ArmoryTalentFrame.Spec.ring:SetAlpha(0)
	for i = 1, 6 do
		ArmoryTalentFrame.Glyphs["Glyph" .. i].ring:SetAlpha(0)
	end

-->>--	PVP Frame
	self:keepFontStrings(ArmoryPVPFrame)
	ArmoryPVPTeam1TeamType:SetDrawLayer("OVERLAY")
	ArmoryPVPTeam1:DisableDrawLayer("BACKGROUND")
	ArmoryPVPTeam2TeamType:SetDrawLayer("OVERLAY")
	ArmoryPVPTeam2:DisableDrawLayer("BACKGROUND")
	ArmoryPVPTeam3TeamType:SetDrawLayer("OVERLAY")
	ArmoryPVPTeam3:DisableDrawLayer("BACKGROUND")

-->>--	PVP Team Details Frame
	self:addSkinFrame{obj=ArmoryPVPTeamDetails, kfs=true}

-->>--	Other Frame (parent for the Reputation, RaidInfo & Currency Frames)
	self:keepFontStrings(ArmoryOtherFrame)
	-- Tabs (top of frame)
	for i = 1, 4 do
		local tab = _G["ArmoryOtherFrameTab" .. i]
		tab:DisableDrawLayer("BACKGROUND")
		self:addSkinFrame{obj=tab, x1=3, x2=-3}
	end
	-- Reputation SubFrame
	self:keepFontStrings(ArmoryReputationFrame)
	self:skinScrollBar{obj=ArmoryReputationListScrollFrame}
	for i = 1, ARMORY_NUM_FACTIONS_DISPLAYED do
		local bar = "ArmoryReputationBar" .. i
		self:skinButton{obj=_G[bar .. "ExpandOrCollapseButton"], mp=true, ty=0} -- treat as just a texture
		_G[bar .. "ReputationBarLeftTexture"]:SetAlpha(0)
		_G[bar .. "ReputationBarRightTexture"]:SetAlpha(0)
		 _G[bar .. "Background"]:SetAlpha(0)
		self:glazeStatusBar(_G[bar .. "ReputationBar"], 0)
	end
	if self.modBtns then
		-- hook to manage changes to button textures
		self:SecureHook("ArmoryReputationFrame_Update", function()
			for i = 1, ARMORY_NUM_FACTIONS_DISPLAYED do
				self:checkTex(_G["ArmoryReputationBar" .. i .. "ExpandOrCollapseButton"])
			end
		end)
	end
	--	RaidInfo SubFrame
	self:keepFontStrings(ArmoryRaidInfoFrame)
	self:skinScrollBar{obj=ArmoryRaidInfoScrollFrame}
	-- Currency SubFrame
	self:keepFontStrings(ArmoryTokenFrame)
	self:skinSlider(ArmoryTokenFrameContainerScrollBar)
	-- remove header textures
	for i = 1, #ArmoryTokenFrameContainer.buttons do
		ArmoryTokenFrameContainer.buttons[i].categoryLeft:SetAlpha(0)
		ArmoryTokenFrameContainer.buttons[i].categoryRight:SetAlpha(0)
		ArmoryTokenFrameContainer.buttons[i].categoryMiddle:SetAlpha(0)
	end

-->>--	Inventory Frame
	self:keepFontStrings(ArmoryInventoryMoneyBackgroundFrame)
	self:skinEditBox(ArmoryInventoryFrameEditBox, {9})
	self:keepFontStrings(ArmoryInventoryExpandButtonFrame)
	self:skinButton{obj=ArmoryInventoryCollapseAllButton, mp=true}
	self:addSkinFrame{obj=ArmoryInventoryFrame, kfs=true, x1=10, y1=-11, x2=-32, y2=71}
	-- Tabs
	self:skinTabs{obj=ArmoryInventoryFrame}
	-- Icon View SubFrame
	self:skinScrollBar{obj=ArmoryInventoryIconViewFrame}
	-- m/p buttons
	for i = 1, 19 do
		self:skinButton{obj=_G["ArmoryInventoryContainer" .. i .. "Label"], mp=true}
	end
	if self.modBtns then
		-- hook to manage changes to button textures
		self:SecureHook("ArmoryInventoryIconViewFrame_Update", function()
			for i = 1, 19 do
				self:checkTex(_G["ArmoryInventoryContainer" .. i .. "Label"])
			end
		end)
	end
	-- List View SubFrame
	self:skinScrollBar{obj=ArmoryInventoryListViewScrollFrame}
	-- m/p buttons
	for i = 1, ARMORY_INVENTORY_LINES_DISPLAYED do
		self:skinButton{obj=_G["ArmoryInventoryLine" .. i], mp=true}
	end
	if self.modBtns then
		-- hook to manage changes to button textures
		self:SecureHook("ArmoryInventoryListViewFrame_Update", function()
			for i = 1, ARMORY_INVENTORY_LINES_DISPLAYED do
				local btn = _G["ArmoryInventoryLine" .. i]
				self:checkTex(btn)
				if not self.sBtn[btn]:IsShown() then -- not a header line
					btn:GetNormalTexture():SetAlpha(1) -- show item icon
				end
			end
		end)
	end
	-- GuildBank SubFrame
	if IsAddOnLoaded("ArmoryGuildBank") and AGB:GetConfigIntegrate() then
		self:skinScrollBar{obj=ArmoryInventoryGuildBankScrollFrame}
		-- m/p buttons
		for i = 1, ARMORY_INVENTORY_LINES_DISPLAYED do
			self:skinButton{obj=_G["ArmoryInventoryGuildBankLine" .. i], mp=true}
		end
		if self.modBtns then
			-- hook to manage changes to button textures
			self:SecureHook("ArmoryInventoryGuildBankFrame_Update", function()
				for i = 1, ARMORY_INVENTORY_LINES_DISPLAYED do
					local btn = _G["ArmoryInventoryGuildBankLine" .. i]
					self:checkTex(btn)
					if not self.sBtn[btn]:IsShown() then -- not a header line
						btn:GetNormalTexture():SetAlpha(1) -- show item icon
					end
				end
			end)
		end
	end

-->>--	Quest Frame
	self:SecureHook("ArmoryQuestInfo_Display", function(...)
		-- headers
		ArmoryQuestInfoTitleHeader:SetTextColor(self.HTr, self.HTg, self.HTb)
		ArmoryQuestInfoDescriptionHeader:SetTextColor(self.HTr, self.HTg, self.HTb)
		ArmoryQuestInfoObjectivesHeader:SetTextColor(self.HTr, self.HTg, self.HTb)
		ArmoryQuestInfoRewardsHeader:SetTextColor(self.HTr, self.HTg, self.HTb)
		-- other text
		ArmoryQuestInfoDescriptionText:SetTextColor(self.BTr, self.BTg, self.BTb)
		ArmoryQuestInfoObjectivesText:SetTextColor(self.BTr, self.BTg, self.BTb)
		ArmoryQuestInfoGroupSize:SetTextColor(self.BTr, self.BTg, self.BTb)
		ArmoryQuestInfoRewardText:SetTextColor(self.BTr, self.BTg, self.BTb)
		-- reward frame text
		ArmoryQuestInfoItemChooseText:SetTextColor(self.BTr, self.BTg, self.BTb)
        ArmoryQuestInfoItemReceiveText:SetTextColor(self.BTr, self.BTg, self.BTb)
        ArmoryQuestInfoSpellLearnText:SetTextColor(self.BTr, self.BTg, self.BTb)
        ArmoryQuestInfoXPFrameReceiveText:SetTextColor(self.BTr, self.BTg, self.BTb)
        ArmoryQuestInfoReputationText:SetTextColor(self.BTr, self.BTg, self.BTb)
		-- reputation rewards
		for i = 1, ARMORY_MAX_REPUTATIONS do
			_G["ArmoryQuestInfoReputation" .. i .. "Faction"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		end
		local r, g, b = ArmoryQuestInfoRequiredMoneyText:GetTextColor()
		ArmoryQuestInfoRequiredMoneyText:SetTextColor(self.BTr - r, self.BTg - g, self.BTb - b)
		-- objectives
		for i = 1, ARMORY_MAX_OBJECTIVES do
			local r, g, b = _G["ArmoryQuestInfoObjective" .. i]:GetTextColor()
			_G["ArmoryQuestInfoObjective" .. i]:SetTextColor(self.BTr - r, self.BTg - g, self.BTb - b)
		end
	end)
	-- ArmoryQuestFrame:DisableDrawLayer("BACKGROUND")
	ArmoryQuestInfoTimerText:SetTextColor(self.BTr, self.BTg, self.BTb)
	ArmoryQuestInfoAnchor:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:skinEditBox{obj=ArmoryQuestFrameEditBox}
	-- QuestLog frame
	self:removeRegions(ArmoryQuestLogCollapseAllButton, {5, 6, 7})
	self:skinButton{obj=ArmoryQuestLogCollapseAllButton, mp=true}
	self:keepFontStrings(ArmoryQuestLogFrame)
	self:keepFontStrings(ArmoryEmptyQuestLogFrame)
	-- m/p buttons
	for i = 1, ARMORY_QUESTS_DISPLAYED do
		self:skinButton{obj=_G["ArmoryQuestLogTitle" .. i], mp=true}
	end
	if self.modBtns then
		-- hook to manage changes to button textures
		self:SecureHook("ArmoryQuestLog_Update", function()
			for i = 1, ARMORY_QUESTS_DISPLAYED do
				self:checkTex(_G["ArmoryQuestLogTitle" .. i])
			end
		end)
	end
	self:skinScrollBar{obj=ArmoryQuestLogListScrollFrame}
	self:skinScrollBar{obj=ArmoryQuestLogDetailScrollFrame}
	self:addSkinFrame{obj=ArmoryQuestFrame, kfs=true, x1=10, y1=-11, x2=-33, y2=52}
	for i = 1, ARMORY_MAX_NUM_ITEMS do
		_G["ArmoryQuestInfoItem" .. i .. "NameFrame"]:SetTexture(nil)
	end

-->>--	Spellbook
	self:addSkinFrame{obj=ArmorySpellBookFrame, kfs=true, x1=10, y1=-12, x2=-31, y2=71}

	self:SecureHook("ArmorySpellBookFrame_Update", function(showing)
		if ArmorySpellBookFrame.bookType ~= INSCRIPTION then
			ArmorySpellBookTitleText:Show()
		else
			ArmorySpellBookTitleText:Hide() -- hide Inscriptions title
		end
	end)
	-- Spellbook page
	for i = 1, SPELLS_PER_PAGE do
		local btn = _G["ArmorySpellButton" .. i]
		btn:DisableDrawLayer("BACKGROUND")
		btn.SpellSubName:SetTextColor(self.BTr, self.BTg, self.BTb)
		btn.RequiredLevelString:SetTextColor(self.BTr, self.BTg, self.BTb)
		self:addButtonBorder{obj=btn}
	end
	self:SecureHook("ArmorySpellButton_UpdateButton", function(this)
		this.SpellName:SetTextColor(self.HTr, self.HTg, self.HTb)
		this.RequiredLevelString:SetTextColor(self.BTr, self.BTg, self.BTb)
	end)
	-- Spellbook Tabs (side)
	for i = 1, MAX_SKILLLINE_TABS do
		self:removeRegions(_G["ArmorySpellBookSkillLineTab" .. i], {1}) -- N.B. other regions are icon and highlight
	end
	-- Core Abilities page
	self:SecureHook("ArmorySpellBook_UpdateCoreAbilitiesTab", function()
		for i = 1, #ArmorySpellBookCoreAbilitiesFrame.Abilities do
			local btn = ArmorySpellBookCoreAbilitiesFrame.Abilities[i]
			btn:DisableDrawLayer("BACKGROUND")
			btn.InfoText:SetTextColor(self.BTr, self.BTg, self.BTb)
			btn.RequiredLevel:SetTextColor(self.BTr, self.BTg, self.BTb)
			if not btn.sbb then self:addButtonBorder{obj=btn} end
		end
	end)
	-- Core AbilitiesTabs (side)
	self:SecureHook("ArmorySpellBookCoreAbilities_UpdateTabs", function()
		for i = 1, #ArmorySpellBookCoreAbilitiesFrame.SpecTabs do
			local tab = ArmorySpellBookCoreAbilitiesFrame.SpecTabs[i]
			self:removeRegions(tab, {1})
		end
	end)
	-- Tabs (bottom)
	for i = 1, 3 do
		tab = _G["ArmorySpellBookFrameTabButton" .. i]
		self:keepRegions(tab, {1, 3}) -- N.B. region 1 is text, 3 is highlight
		tabSF = self:addSkinFrame{obj=tab, noBdr=self.isTT, x1=14, y1=-16, x2=-10, y2=18}
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end
	if self.isTT then
		-- hook to handle tabs
		self:SecureHook("ArmoryToggleSpellBook", function(bookType)
			for i = 1, 3 do
				local tabName = _G["ArmorySpellBookFrameTabButton" .. i]
				local tabSF = self.skinFrame[tabName]
				if tabName.bookType == bookType then
					self:setActiveTab(tabSF)
				else
					self:setInactiveTab(tabSF)
				end
			end
		end)
	end

-->>-- Social Frame
	self:skinFFToggleTabs("ArmorySocialFrameTab", 3, true)
	self:addSkinFrame{obj=ArmorySocialFrame, kfs=true, x1=10, y1=-11, x2=-33, y2=71}
	-- Friends SubFrame
	self:skinScrollBar{obj=ArmoryFriendsListScrollFrame}
	-- Ignore SubFrame
	self:skinScrollBar{obj=ArmoryIgnoreListScrollFrame}
	-- Events SubFrame
	self:skinScrollBar{obj=ArmoryEventsListScrollFrame}

-->>--	Tradeskills
	self:removeRegions(ArmoryTradeSkillRankFrameBorder, {1}) -- N.B. region 2 is bar texture
	self:glazeStatusBar(ArmoryTradeSkillRankFrame, 0)
	self:skinEditBox(ArmoryTradeSkillFrameEditBox, {9})
	self:moveObject{obj=ArmoryTradeSkillFrameEditBox, y=2}
	self:removeRegions(ArmoryTradeSkillExpandButtonFrame)
	self:skinDropDown{obj=ArmoryTradeSkillSubClassDropDown}
	self:skinDropDown{obj=ArmoryTradeSkillInvSlotDropDown}
	self:moveObject{obj=ArmoryTradeSkillInvSlotDropDown, y=-2} -- shift for editbox visibility
	self:skinScrollBar{obj=ArmoryTradeSkillListScrollFrame}
	self:skinScrollBar{obj=ArmoryTradeSkillDetailScrollFrame}
	self:keepFontStrings(ArmoryTradeSkillDetailScrollChildFrame)
	self:addButtonBorder{obj=ArmoryTradeSkillSkillIcon}
	for i = 1, 8 do
		self:addButtonBorder{obj=_G["ArmoryTradeSkillReagent" .. i], libt=true}
	end
	self:addSkinFrame{obj=ArmoryTradeSkillFrame, kfs=true, nb=true, x1=10, y1=-11, x2=-32, y2=71} -- don't skin buttons, otherwise the CollapseAllbutton is skinned incorrectly
	self:skinButton{obj=ArmoryTradeSkillFrameCloseButton, cb=true}
	for i = 1, ARMORY_TRADE_SKILLS_DISPLAYED do
		self:skinButton{obj=_G["ArmoryTradeSkillSkill" .. i], mp=true}
	end
	-- collapse all button
	self:skinButton{obj=ArmoryTradeSkillCollapseAllButton, mp=true} -- treat as just a texture
	if self.modBtns then
		-- hook to manage changes to button textures
		self:SecureHook("ArmoryTradeSkillFrame_Update", function()
			for i = 1, ARMORY_TRADE_SKILLS_DISPLAYED do
				self:checkTex(_G["ArmoryTradeSkillSkill" .. i])
			end
			self:checkTex(ArmoryTradeSkillCollapseAllButton)
		end)
	end
	for i = 1, ARMORY_MAX_TRADE_SKILL_REAGENTS do
		_G["ArmoryTradeSkillReagent" .. i .. "NameFrame"]:SetTexture(nil)
	end

end

function aObj:ArmoryGuildBank()

	if AGB:GetConfigIntegrate() then return end

	self:keepFontStrings(ArmoryGuildBankMoneyBackgroundFrame)
	self:skinEditBox{obj=ArmoryGuildBankFrameEditBox, regs={9}}
	self:skinDropDown{obj=ArmoryGuildBankFilterDropDown}
	self:skinDropDown{obj=ArmoryGuildBankNameDropDown}
	self:skinScrollBar{obj=ArmoryGuildBankScrollFrame}
	self:skinButton{obj=ArmoryGuildBankFrameCloseButton, cb=true, tx=0}
	self:removeRegions(ArmoryGuildBankFrame, {10, 11, 12, 13}) -- remove frame textures
	self:addSkinFrame{obj=ArmoryGuildBankFrame, bg=true, x1=6, y1=-11, x2=-32, y2=71}
	-- move portrait and delete button
	self:moveObject{obj=ArmoryGuildBankFramePortrait, x=3, y=-10}
	self:moveObject{obj=ArmoryGuildBankFrameDeleteButton, x=3, y=-10}
	-- make portrait square and same size as guild tabard texture(s)
	ArmoryGuildBankFramePortrait:SetTexCoord(0.2, 0.8, 0.2, 0.8)
	ArmoryGuildBankFramePortrait:SetWidth(54)
	ArmoryGuildBankFramePortrait:SetHeight(52)

end
