local aName, aObj = ...
if not aObj:isAddonEnabled("Armory") then return end
local _G = _G

aObj.addonsToSkin.Armory = function(self) -- v 15.1.0

	-- Static Popup
	self:addSkinFrame{obj=_G.ArmoryStaticPopup, ft="a", kfs=true, nb=true}

	-- Armory frame
	self:moveObject{obj=_G.ArmoryBuffFrame, y=-2} -- buff buttons, top of frame
	self:moveObject{obj=_G.ArmoryFramePortrait, x=6, y=-10}
	self:moveObject{obj=_G.ArmoryFramePortraitButton, x=6, y=-10}
	self:moveObject{obj=self:getRegion(_G.ArmoryFramePortraitButton, 1), x=-5, y=8}
	-- move character selection buttons to top of portrait
	self:moveObject{obj=_G.ArmoryFrameLeftButton, x=-2, y=64}
	self:moveObject{obj=_G.ArmoryFrameRightButton, x=-2, y=64}
	self:addSkinFrame{obj=_G.ArmoryFrame, ft="a", kfs=true, nb=true, ri=true, y1=2, x2=3, y2=-5}
	if self.modBtns then
		self:skinCloseButton{obj=_G.ArmoryFrameCloseButton}
	end
	if self.modBtnBs then
		self:addButtonBorder{obj=_G.ArmorySelectCharacter, ofs=0, y1=-1, x2=-1}
	end
	_G.ArmoryFramePortrait:SetAlpha(1) -- used to delete characters
	-- Tabs (bottom)
	self:skinTabs{obj=_G.ArmoryFrame, lod=true}
	-- Tabs (RHS)
	local tabName
	for i = 1, _G.ARMORY_MAX_LINE_TABS do
		tabName = _G["ArmoryFrameLineTab" .. i]
		self:removeRegions(tabName, {1}) -- N.B. region 2 is the icon, 3 is the text
		-- Move the first entry as all the others are positioned from it
		if i == 1 then self:moveObject{obj=tabName, x=-2} end
	end
	tabName = nil
	-- DropDown Menus
	local ddM
	for i = 1, 2 do
		ddM = "ArmoryDropDownList" .. i
		_G[ddM .. "Backdrop"]:SetAlpha(0)
		_G[ddM .. "MenuBackdrop"]:SetAlpha(0)
		self:addSkinFrame{obj=_G[ddM], ft="a", kfs=true, nb=true}
	end
	ddM = nil

	-- Character Tab
	self:keepFontStrings(_G.ArmoryPaperDollFrame)
	if self.modBtnBs then
		self:addButtonBorder{obj=_G.ArmoryGearSetToggleButton, x1=0, x2=0}
	end
	local btn
	for i = 1, _G.MAX_EQUIPMENT_SETS_PER_PLAYER do
		btn = _G["ArmoryGearSetButton" .. i]
		btn:DisableDrawLayer("BACKGROUND")
		if self.modBtnBs then
			self:addButtonBorder{obj=btn, relTo=btn.icon, reParent={btn.text}}
		end
	end
	btn = nil
	self:addSkinFrame{obj=_G.ArmoryGearSetFrame, ft="a", kfs=true, nb=true}
	self:keepFontStrings(_G.ArmoryPaperDollTalent)
	local sBar
	for i = 1, 2 do
		sBar = "ArmoryPaperDollTradeSkillFrame" .. i
		self:skinStatusBar{obj=_G[sBar .. "Bar"]}
		self:skinStatusBar{obj=_G[sBar .. "BackgroundBar"]}
		_G[sBar .. "BackgroundBar"]:SetStatusBarColor(self.sbClr:GetRGBA())
	end
	self:keepFontStrings(_G.ArmoryPaperDollTradeSkill)
	self:skinDropDown{obj=_G.ArmoryAttributesFramePlayerStatDropDown}
	_G.ArmoryAttributesFrame:DisableDrawLayer("BACKGROUND")
	-- slots
	for _, child in _G.ipairs{_G.ArmoryPaperDollItemsFrame:GetChildren()} do
		child:DisableDrawLayer("BACKGROUND")
		if self.modBtnBs then
			self:addButtonBorder{obj=child}
		end
	end
	self:keepFontStrings(_G.ArmoryPaperDollTalentOverlay)
	for i = 1, 2 do
		sBar = "ArmoryPaperDollTradeSkillOverlayFrame" .. i
		self:skinStatusBar{obj=_G[sBar .. "Bar"]}
		self:skinStatusBar{obj=_G[sBar .. "BackgroundBar"]}
		_G[sBar .. "BackgroundBar"]:SetStatusBarColor(self.sbClr:GetRGBA())
	end
	sBar = nil

	self:keepFontStrings(_G.ArmoryPaperDollTradeSkillOverlay)
	self:skinDropDown{obj=_G.ArmoryAttributesOverlayTopFramePlayerStatDropDown}
	_G.ArmoryAttributesOverlayTopFrame:DisableDrawLayer("BACKGROUND")
	self:skinDropDown{obj=_G.ArmoryAttributesOverlayBottomFramePlayerStatDropDown}
	_G.ArmoryAttributesOverlayBottomFrame:DisableDrawLayer("BACKGROUND")

	-- Pet Tab
	if self.modBtnBs then
		self:addButtonBorder{obj=_G.ArmoryPetFramePetInfo, relTo=_G.ArmoryPetFrameSelectedPetIcon}
	end
	_G.ArmoryPetSpecFrame.ring:SetAlpha(0)
	-- Specs
	for i = 1, 6 do
		_G["ArmoryPetAbility" .. i].ring:SetAlpha(0)
	end
	-- Stats
	local frame
	for i = 1, 7 do
		frame = _G["ArmoryPetStatsPaneCategory" .. i]
		frame.BgTop:SetAlpha(0)
		frame.BgBottom:SetAlpha(0)
		frame.BgMiddle:SetAlpha(0)
		frame.BgMinimized:SetAlpha(0)
	end
	frame = nil
	-- Pets buttons
	for i = 1, 5 do
		_G["ArmoryPetFramePet" .. i .. "Background"]:SetAlpha(0)
		if self.modBtnBs then
			self:addButtonBorder{obj=_G["ArmoryPetFramePet" .. i]}
		end
	end
	if self.modBtnBs then
		self:addButtonBorder{obj=_G.ArmoryPetFrameNextPageButton, ofs=0, clr="gold"}
	self:addButtonBorder{obj=_G.ArmoryPetFramePrevPageButton, ofs=0, clr="gold"}
	end

	-- Talents Tab
	self:removeRegions(_G.ArmoryTalentFrame, {2}) -- horizontal line
	_G.ArmoryTalentFrame.Spec.ring:SetAlpha(0)

	-- PVP Tab
	-- Tabs (top of frame)
	local tab
	for i = 1, 2 do
		tab = _G["ArmoryPVPFrameTab" .. i]
		tab:DisableDrawLayer("BACKGROUND")
		self:addSkinFrame{obj=tab, ft="a", nb=true, x1=4, y1=-6, x2=0, y2=-4}
	end
	-- Player vs. Player
	self:keepFontStrings(_G.ArmoryPVPFrame)
	local function skinConquestBtn(btn)
		btn.SelectedTexture:SetTexture(nil)
		btn:SetNormalTexture(nil)
		btn:SetPushedTexture(nil)
	end
	skinConquestBtn(_G.ArmoryConquestFrame.Arena2v2)
	skinConquestBtn(_G.ArmoryConquestFrame.Arena3v3)
	skinConquestBtn(_G.ArmoryConquestFrame.RatedBG)
	-- Honor Talents
	_G.ArmoryPVPHonorXPBar.Frame:SetTexture(nil)
	self:skinStatusBar{obj=_G.ArmoryPVPHonorXPBar.Bar, fi=0}
	-- tooltip
	_G.C_Timer.After(0.1, function()
		self:add2Table(self.ttList, _G.ArmoryConquestTooltip)
	end)
	-- self:addSkinFrame{obj=_G.ArmoryConquestTooltip}

-->>-- Other Tab (parent for the Reputation, RaidInfo & Currency Frames)
	self:keepFontStrings(_G.ArmoryOtherFrame)
	-- Tabs (top of frame)
	for i = 1, 4 do
		local tab = _G["ArmoryOtherFrameTab" .. i]
		tab:DisableDrawLayer("BACKGROUND")
		self:addSkinFrame{obj=tab, ft="a", nb=true, x1=4, y1=0, x2=-1, y2=-4}
	end
	tab = nil
	-- Reputation SubFrame
	self:keepFontStrings(_G.ArmoryReputationFrame)
	_G.ArmoryReputationListScrollFrame:DisableDrawLayer("BACKGROUND")
	self:skinSlider{obj=_G.ArmoryReputationListScrollFrame.ScrollBar}
	local bar
	for i = 1, _G.ARMORY_NUM_FACTIONS_DISPLAYED do
		bar = "ArmoryReputationBar" .. i
		_G[bar .. "ExpandOrCollapseButton"]:SetSize(16, 16)
		self:skinExpandButton{obj=_G[bar .. "ExpandOrCollapseButton"], onSB=true}
		_G[bar .. "ReputationBarLeftTexture"]:SetAlpha(0)
		_G[bar .. "ReputationBarRightTexture"]:SetAlpha(0)
		 _G[bar .. "Background"]:SetAlpha(0)
		 self:skinStatusBar{obj=_G[bar .. "ReputationBar"], fi=0}
	end
	bar = nil
	if self.modBtns then
		-- hook to manage changes to button textures
		self:SecureHook("ArmoryReputationFrame_Update", function()
			for i = 1, _G._G.ARMORY_NUM_FACTIONS_DISPLAYED do
				self:checkTex(_G["ArmoryReputationBar" .. i .. "ExpandOrCollapseButton"])
			end
		end)
	end
	--	RaidInfo SubFrame
	self:keepFontStrings(_G.ArmoryRaidInfoFrame)
	self:skinSlider{obj=_G.ArmoryRaidInfoScrollFrame.scrollBar}
	-- Currency SubFrame
	self:keepFontStrings(_G.ArmoryTokenFrame)
	self:skinSlider(_G.ArmoryTokenFrameContainerScrollBar)
	-- remove header textures
	for i = 1, #_G.ArmoryTokenFrameContainer.buttons do
		_G.ArmoryTokenFrameContainer.buttons[i].categoryLeft:SetAlpha(0)
		_G.ArmoryTokenFrameContainer.buttons[i].categoryRight:SetAlpha(0)
		_G.ArmoryTokenFrameContainer.buttons[i].categoryMiddle:SetAlpha(0)
	end

-->>-- Inventory Tab
	self:keepFontStrings(_G.ArmoryInventoryMoneyBackgroundFrame)
	self:skinEditBox(_G.ArmoryInventoryFrameEditBox, {6})
	self:keepFontStrings(_G.ArmoryInventoryExpandButtonFrame)
	self:addSkinFrame{obj=_G.ArmoryInventoryFrame, ft="a", kfs=true, x1=10, y1=-11, x2=-32, y2=71}
	if self.modBtns then
		self:skinExpandButton{obj=_G.ArmoryInventoryCollapseAllButton, onSB=true}
		-- m/p buttons
		for i = 1, #_G.ArmoryInventoryContainers do
			self:skinExpandButton{obj=_G["ArmoryInventoryContainer" .. i .. "Label"], onSB=true}
		end
		-- hook to manage changes to button textures
		self:SecureHook("ArmoryInventoryIconViewFrame_Update", function()
			for i = 1, #_G.ArmoryInventoryContainers do
				self:checkTex(_G["ArmoryInventoryContainer" .. i .. "Label"])
			end
			self:checkTex(_G.ArmoryInventoryCollapseAllButton)
		end)
	end
	-- Tabs
	self:skinTabs{obj=_G.ArmoryInventoryFrame}
	-- Icon View Tab
	_G.ArmoryInventoryIconViewFrame:DisableDrawLayer("ARTWORK")
	self:skinSlider{obj=_G.ArmoryInventoryIconViewFrame.ScrollBar}
	if self.modChkBtns then
		self:skinCheckButton{obj=_G.ArmoryInventoryIconViewFrameLayoutCheckButton}
	end
	-- List View Tab
	_G.ArmoryInventoryListViewScrollFrame:DisableDrawLayer("BACKGROUND")
	self:skinSlider{obj=_G.ArmoryInventoryListViewScrollFrame.ScrollBar}
	if self.modChkBtns then
		self:skinCheckButton{obj=_G.ArmoryInventoryListViewFrameSearchAllCheckButton}
	end
	if self.modBtns then
		-- m/p buttons
		for i = 1, _G.ARMORY_INVENTORY_LINES_DISPLAYED do
			self:skinExpandButton{obj=_G["ArmoryInventoryLine" .. i], onSB=true}
		end
		-- hook to manage changes to button textures
		self:SecureHook("ArmoryInventoryListViewFrame_Update", function()
			local btn
			for i = 1, _G.ARMORY_INVENTORY_LINES_DISPLAYED do
				btn = _G["ArmoryInventoryLine" .. i]
				self:checkTex(btn)
				if btn.link then -- not a header line
					btn:GetNormalTexture():SetAlpha(1) -- show item icon
				end
			end
			btn = nil
			self:checkTex(_G.ArmoryInventoryCollapseAllButton)
		end)
	end
	-- Guild Bank Tab
	if self:isAddOnLoaded("ArmoryGuildBank") then
		_G.ArmoryInventoryGuildBankScrollFrame:DisableDrawLayer("BACKGROUND")
		self:skinSlider{obj=_G.ArmoryInventoryGuildBankScrollFrame.ScrollBar}
		if self.modBtns then
		-- m/p buttons
			for i = 1, _G.ARMORY_GUILDBANK_LINES_DISPLAYED do
				self:skinExpandButton{obj=_G["ArmoryInventoryGuildBankLine" .. i], onSB=true}
			end
			-- hook to manage changes to button textures
			self:SecureHook("ArmoryInventoryGuildBankFrame_Update", function()
				local btn
				for i = 1, _G.ARMORY_GUILDBANK_LINES_DISPLAYED do
					btn = _G["ArmoryInventoryGuildBankLine" .. i]
					self:checkTex(btn)
					if btn.link then -- not a header line
						btn:GetNormalTexture():SetAlpha(1) -- show item icon
					end
				end
				btn = nil
				self:checkTex(_G.ArmoryInventoryCollapseAllButton)
			end)
		end
	end

-->>-- Quest Log Tab
	self:SecureHook("ArmoryQuestInfo_Display", function(...)
		-- headers
		_G.ArmoryQuestInfoTitleHeader:SetTextColor(self.HT:GetRGB())
		_G.ArmoryQuestInfoDescriptionHeader:SetTextColor(self.HT:GetRGB())
		_G.ArmoryQuestInfoObjectivesHeader:SetTextColor(self.HT:GetRGB())
		_G.ArmoryQuestInfoRewardsFrame.Header:SetTextColor(self.HT:GetRGB())
		-- other text
		_G.ArmoryQuestInfoDescriptionText:SetTextColor(self.BT:GetRGB())
		_G.ArmoryQuestInfoObjectivesText:SetTextColor(self.BT:GetRGB())
		_G.ArmoryQuestInfoGroupSize:SetTextColor(self.BT:GetRGB())
		_G.ArmoryQuestInfoRewardText:SetTextColor(self.BT:GetRGB())
		-- reward frame text
		_G.ArmoryQuestInfoRewardsFrame.ItemChooseText:SetTextColor(self.BT:GetRGB())
        _G.ArmoryQuestInfoRewardsFrame.ItemReceiveText:SetTextColor(self.BT:GetRGB())
        _G.ArmoryQuestInfoRewardsFrame.PlayerTitleText:SetTextColor(self.BT:GetRGB())
        _G.ArmoryQuestInfoRewardsFrame.XPFrame.ReceiveText:SetTextColor(self.BT:GetRGB())
		-- objective(s)
		local br, bg, bb = self.BT:GetRGB()
		local r, g, b
		for i = 1, #_G.ArmoryQuestInfoObjectivesFrame.Objectives do
			r, g, b = _G.ArmoryQuestInfoObjectivesFrame.Objectives[i]:GetTextColor()
			 _G.ArmoryQuestInfoObjectivesFrame.Objectives[i]:SetTextColor(br - r, bg - g, bb - b)
		end
		br, bg, bb, r, g, b = nil, nil, nil, nil, nil, nil
		-- spell line(s)
		for spellLine in _G.ArmoryQuestInfoRewardsFrame.spellHeaderPool:EnumerateActive() do
			spellLine:SetVertexColor(self.BT:GetRGB())
		end
	end)
	_G.ArmoryQuestInfoTimerText:SetTextColor(self.BT:GetRGB())
	_G.ArmoryQuestInfoAnchor:SetTextColor(self.BT:GetRGB())
	self:skinEditBox{obj=_G.ArmoryQuestFrameEditBox, regs={6}}
	-- QuestLog frame
	self:removeRegions(_G.ArmoryQuestLogCollapseAllButton, {5, 6, 7})
	self:keepFontStrings(_G.ArmoryQuestLogFrame)
	self:keepFontStrings(_G.ArmoryEmptyQuestLogFrame)
	if self.modBtns then
		self:skinExpandButton{obj=_G.ArmoryQuestLogCollapseAllButton, onSB=true}
		-- m/p buttons
		for i = 1, _G.ARMORY_QUESTS_DISPLAYED do
			self:skinExpandButton{obj=_G["ArmoryQuestLogTitle" .. i], onSB=true}
		end
		-- hook to manage changes to button textures
		self:SecureHook("ArmoryQuestLog_Update", function()
			for i = 1, _G.ARMORY_QUESTS_DISPLAYED do
				self:checkTex(_G["ArmoryQuestLogTitle" .. i])
			end
			self:checkTex(_G.ArmoryQuestLogCollapseAllButton)
		end)
	end
	self:skinSlider{obj=_G.ArmoryQuestLogListScrollFrame.ScrollBar}
	self:skinSlider{obj=_G.ArmoryQuestLogDetailScrollFrame.ScrollBar}
	self:addSkinFrame{obj=_G.ArmoryQuestFrame, ft="a", kfs=true, x1=10, y1=-11, x2=-33, y2=52}

-->>-- Spellbook Tab
	if self.modBtns then
		self:skinCloseButton{obj=_G._G.ArmorySpellBookCloseButton}
	end
	self:addSkinFrame{obj=_G.ArmorySpellBookFrame, ft="a", kfs=true, nb=true, x1=10, y1=-12, x2=-31, y2=71}
	-- Tabs (bottom)
	_G.PanelTemplates_SetNumTabs(_G.ArmorySpellBookFrame, 3)
	self:skinTabs{obj=_G.ArmorySpellBookFrame, suffix="Button", lod=true, regs={1}, x1=14, y1=-16, x2=-10, y2=18}
	if self.isTT then
		-- hook to handle tabs
		self:SecureHook("ArmoryToggleSpellBook", function(bookType)
			for i = 1, 3 do
				if _G["ArmorySpellBookFrameTabButton" .. i].bookType == bookType then
					self:setActiveTab(_G["ArmorySpellBookFrameTabButton" .. i].sf)
				else
					self:setInactiveTab(_G["ArmorySpellBookFrameTabButton" .. i].sf)
				end
			end
		end)
	end
	-- hook this to manage Inscription Title
	self:SecureHook("ArmorySpellBookFrame_Update", function(showing)
		if _G.ArmorySpellBookFrame.bookType ~= _G.INSCRIPTION then
			_G.ArmorySpellBookTitleText:Show()
		else
			_G.ArmorySpellBookTitleText:Hide() -- hide Inscriptions title
		end
	end)
	-- Spellbook Tab
	for i = 1, _G.SPELLS_PER_PAGE do
		_G["ArmorySpellButton" .. i]:DisableDrawLayer("BACKGROUND")
		_G["ArmorySpellButton" .. i].SpellSubName:SetTextColor(self.BT:GetRGB())
		_G["ArmorySpellButton" .. i].RequiredLevelString:SetTextColor(self.BT:GetRGB())
		if self.modBtnBs then
			self:addButtonBorder{obj=_G["ArmorySpellButton" .. i]}
		end
	end
	if self.modBtnBs then
		self:addButtonBorder{obj=_G.ArmorySpellBookPrevPageButton, ofs=-2, y1=-3, x2=-3, clr="gold"}
	self:addButtonBorder{obj=_G.ArmorySpellBookNextPageButton, ofs=-2, y1=-3, x2=-3, clr="gold"}
	end

	self:SecureHook("ArmorySpellButton_UpdateButton", function(this)
		this.SpellName:SetTextColor(self.HT:GetRGB())
		this.RequiredLevelString:SetTextColor(self.BT:GetRGB())
	end)
	-- Tabs (side)
	for i = 1, _G.MAX_SKILLLINE_TABS do
		self:removeRegions(_G["ArmorySpellBookSkillLineTab" .. i], {1}) -- N.B. other regions are icon and highlight
	end

-->>-- Achievements Tab
	self:skinEditBox{obj=_G.ArmoryAchievementFrameEditBox, regs={6}}
	_G.ArmoryAchievementCollapseAllButton:DisableDrawLayer("BACKGROUND")
	_G.ArmoryAchievementListScrollFrame:DisableDrawLayer("BACKGROUND")
	self:skinSlider{obj=_G.ArmoryAchievementListScrollFrame.ScrollBar}
	if self.modBtns then
		self:skinCloseButton{obj=_G.ArmoryAchievementFrameCloseButton}
	end
	self:addSkinFrame{obj=_G.ArmoryAchievementFrame, ft="a", kfs=true, nb=true, x1=10, y1=-11, x2=-33, y2=71}
	-- Tabs
	self:skinTabs{obj=_G.ArmoryAchievementFrame, lod=true}
	if self.modBtns then
		self:skinExpandButton{obj=_G.ArmoryAchievementCollapseAllButton, onSB=true}
		-- m/p buttons
		for i = 1, _G.ARMORY_NUM_ACHIEVEMENTS_DISPLAYED do
			self:removeRegions(_G["ArmoryAchievementBar" .. i], {1, 2, 3}) -- textures
			self:skinExpandButton{obj=_G["ArmoryAchievementBar" .. i .. "ExpandOrCollapseButton"], onSB=true}
			self:skinStatusBar{obj=_G["ArmoryAchievementBar" .. i .. "AchievementBar"], fi=0}
			self:removeRegions(_G["ArmoryAchievementBar" .. i .. "AchievementBar"], {1, 2}) -- textures
		end
		-- hook to manage changes to button textures
		self:SecureHook("ArmoryAchievementFrame_Update", function()
			for i = 1, _G.ARMORY_NUM_ACHIEVEMENTS_DISPLAYED do
				self:checkTex(_G["ArmoryAchievementBar" .. i .. "ExpandOrCollapseButton"])
			end
			self:checkTex(_G.ArmoryAchievementCollapseAllButton)
		end)
	end

-->>-- Social Tab
	self:skinToggleTabs("ArmorySocialFrameTab", 3, true)
	self:addSkinFrame{obj=_G.ArmorySocialFrame, ft="a", kfs=true, x1=10, y1=-11, x2=-33, y2=71}
	-- Friends ToggleTab
	_G.ArmoryFriendsListScrollFrame:DisableDrawLayer("BACKGROUND")
	self:skinSlider{obj=_G.ArmoryFriendsListScrollFrame.ScrollBar}
	-- Ignore ToggleTab
	_G.ArmoryIgnoreListScrollFrame:DisableDrawLayer("BACKGROUND")
	self:skinSlider{obj=_G.ArmoryIgnoreListScrollFrame.ScrollBar}
	-- Events ToggleTab
	_G.ArmoryEventsListScrollFrame:DisableDrawLayer("BACKGROUND")
	self:skinSlider{obj=_G.ArmoryEventsListScrollFrame.ScrollBar}

-->>-- Tradeskill Tabs
	self:removeRegions(_G.ArmoryTradeSkillFrame.RankFrame.Border, {1}) -- remove button texture
	self:skinStatusBar{obj=_G.ArmoryTradeSkillFrame.RankFrame, fi=0}
	self:skinEditBox{obj=_G.ArmoryTradeSkillFrame.SearchBox, regs={6, 7}, mi=true} -- 6 is text, 7 is icon
	self:moveObject{obj=_G.ArmoryTradeSkillFrame.SearchBox, y=1}
	self:removeRegions(_G.ArmoryTradeSkillFrame.ExpandButtonFrame)
	if self.modBtns then
		self:skinStdButton{obj=_G.ArmoryTradeSkillFrame.FilterButton}
	end
	self:moveObject{obj=_G.ArmoryTradeSkillFrame.FilterButton, y=2}
	self:skinSlider{obj=_G.ArmoryTradeSkillFrame.RecipeList.ScrollBar, adj=-4, size=3}
	self:skinSlider{obj=_G.ArmoryTradeSkillFrame.DetailsFrame.ScrollBar}
	self:removeRegions(_G.ArmoryTradeSkillFrame.DetailsFrame.Contents, {6, 7,}) -- textures
	local btn = _G.ArmoryTradeSkillFrame.DetailsFrame.Contents.ResultIcon
	if self.modBtnBs then
		self:addButtonBorder{obj=btn, reParent={btn.Count}}
	end
	for i = 1, 8 do
		btn = _G.ArmoryTradeSkillFrame.DetailsFrame.Contents["Reagent" .. i]
		if self.modBtnBs then
			self:addButtonBorder{obj=btn, libt=true}
		end
		btn.NameFrame:SetTexture(nil)
	end
	btn = nil
	self:addSkinFrame{obj=_G.ArmoryTradeSkillFrame, ft="a", kfs=true, nb=true, x1=10, y1=-11, x2=-32, y2=71} -- don't skin buttons, otherwise the CollapseAllbutton is skinned incorrectly
	if self.modBtns then
		self:skinCloseButton{obj=_G.ArmoryTradeSkillFrameCloseButton}
	end
	for i = 1, #_G.ArmoryTradeSkillFrame.RecipeList.buttons do
		self:skinExpandButton{obj=_G.ArmoryTradeSkillFrame.RecipeList.buttons[i]}
	end
	-- collapse all button
	self:skinExpandButton{obj=_G.ArmoryTradeSkillFrame.ExpandButtonFrame.CollapseAllButton} -- treat as just a texture
	if self.modBtns then
		local function manageTextures()
			for i = 1, #_G.ArmoryTradeSkillFrame.RecipeList.buttons do
				self:checkTex(_G.ArmoryTradeSkillFrame.RecipeList.buttons[i])
			end
			self:checkTex(_G.ArmoryTradeSkillFrame.ExpandButtonFrame.CollapseAllButton)
		end
		-- hook these to manage changes to button textures
		self:SecureHook(_G.ArmoryTradeSkillFrame.RecipeList, "RefreshDisplay", function()
			manageTextures()
		end)
		self:SecureHook(_G.ArmoryTradeSkillFrame.RecipeList, "update", function()
			manageTextures()
		end)
	end

	-- minimap button
	self.mmButs["Armory"] = _G.ArmoryMinimapButton

end

aObj.addonsToSkin.ArmoryGuildBank = function(self)

	-- ArmoryGuildBankFrame
	self:skinEditBox{obj=_G.ArmoryGuildBankFrameEditBox, regs={6}}
	self:skinDropDown{obj=_G.ArmoryGuildBankNameDropDown}
	self:removeRegions(_G.ArmoryGuildBankFrame, {10, 11, 12, 13}) -- remove frame textures
	self:addSkinFrame{obj=_G.ArmoryGuildBankFrame, ft="a", nb=true, bg=true, x1=6, y1=-11, x2=-32, y2=71}
	self:moveObject{obj=_G.ArmoryGuildBankFrameDeleteButton, x=3, y=-10}
	-- ArmoryListGuildBankFrame
	_G.ArmoryListGuildBankFrameMoneyBackgroundFrame:DisableDrawLayer("BACKGROUND")
	_G.ArmoryListGuildBankScrollFrame:DisableDrawLayer("BACKGROUND")
	self:skinSlider{obj=_G.ArmoryListGuildBankScrollFrame.ScrollBar}
	self:addSkinFrame{obj=_G.ArmoryListGuildBankFrame, ft="a", kfs=true, x1=10, y1=-11, x2=-32, y2=71}
	self:skinTabs{obj=_G.ArmoryListGuildBankFrame, lod=true}
	-- ArmoryIconGuildBankFrame
	self:keepFontStrings(_G.ArmoryIconGuildBankFrameEmblemFrame)
	-- columns
	for i = 1, _G.ARMORY_NUM_GUILDBANK_COLUMNS do
		_G["ArmoryIconGuildBankColumn" .. i]:DisableDrawLayer("BACKGROUND")
		local btn
		for j = 1, 14 do
			btn = _G["ArmoryIconGuildBankColumn" .. i .. "Button" .. j]
			self:addButtonBorder{obj=btn, ibt=true}
			if self.modBtnBs then
				self:SecureHook(btn.IconBorder, "Hide", function(this)
					this:GetParent().sbb:SetBackdropBorderColor(0.5, 0.5, 0.5, 0.35)
				end)
				self:SecureHook(btn.IconBorder, "SetVertexColor", function(this, r, g, b)
					this:GetParent().sbb:SetBackdropBorderColor(r, g, b, 1)
				end)
			end
		end
		btn = nil
	end
	if self.modChkBtns then
		self:skinCheckButton{obj=_G.ArmoryIconGuildBankFramePersonalCheckButton}
	end
	if self.modBtns then
		self:skinCloseButton{obj=self:getChild(_G.ArmoryIconGuildBankFrame, 11)}
	end
	self:addSkinFrame{obj=_G.ArmoryIconGuildBankFrame, ft="a", kfs=true, nb=true, y1=-10, y2=2}
	self:skinTabs{obj=_G.ArmoryIconGuildBankFrame, lod=true}
	-- Tabs (side)
	for i = 1, _G.MAX_GUILDBANK_TABS do
		_G["ArmoryIconGuildBankTab" .. i]:DisableDrawLayer("BACKGROUND")
		self:addButtonBorder{obj=_G["ArmoryIconGuildBankTab" .. i .. "Button"], relTo=_G["ArmoryIconGuildBankTab" .. i .. "ButtonIconTexture"]}
	end

end
