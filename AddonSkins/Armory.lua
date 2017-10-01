local aName, aObj = ...
if not aObj:isAddonEnabled("Armory") then return end
local _G = _G

aObj.addonsToSkin.Armory = function(self) -- v 14.4.1

-->>-- Static Popup
	self:addSkinFrame{obj=_G.ArmoryStaticPopup, kfs=true}

-->>-- Armory frame
	self:moveObject{obj=_G.ArmoryBuffFrame, y=-2} -- buff buttons, top of frame
	self:moveObject{obj=_G.ArmoryFramePortrait, x=6, y=-10}
	self:moveObject{obj=_G.ArmoryFramePortraitButton, x=6, y=-10}
	self:moveObject{obj=self:getRegion(_G.ArmoryFramePortraitButton, 1), x=-5, y=8}
	-- move character selection buttons to top of portrait
	self:moveObject{obj=_G.ArmoryFrameLeftButton, x=-2, y=64}
	self:moveObject{obj=_G.ArmoryFrameRightButton, x=-2, y=64}
	self:addSkinFrame{obj=_G.ArmoryFrame, kfs=true, nb=true, ri=true, y1=2, x2=1, y2=-5}
	self:skinButton{obj=_G.ArmoryFrameCloseButton, cb=true}
	self:addButtonBorder{obj=_G.ArmorySelectCharacter, ofs=0, y1=-1, x2=-1}
	_G.ArmoryFramePortrait:SetAlpha(1) -- used to delete characters
	-- Tabs (bottom)
	self:skinTabs{obj=_G.ArmoryFrame, lod=true}
	-- Tabs (RHS)
	for i = 1, _G.ARMORY_MAX_LINE_TABS do
		local tabName = _G["ArmoryFrameLineTab" .. i]
		self:removeRegions(tabName, {1}) -- N.B. region 2 is the icon, 3 is the text
		-- Move the first entry as all the others are positioned from it
		if i == 1 then self:moveObject{obj=tabName, x=-2} end
	end
	-- DropDown Menus
	for i = 1, 2 do
		local ddM = "ArmoryDropDownList" .. i
		_G[ddM .. "Backdrop"]:SetAlpha(0)
		_G[ddM .. "MenuBackdrop"]:SetAlpha(0)
		self:addSkinFrame{obj=_G[ddM], kfs=true}
	end

-->>-- Character Tab
	self:keepFontStrings(_G.ArmoryPaperDollFrame)
	self:addButtonBorder{obj=_G.ArmoryGearSetToggleButton, x1=0, x2=0}
	for i = 1, _G.MAX_EQUIPMENT_SETS_PER_PLAYER do
		local btn = _G["ArmoryGearSetButton" .. i]
		btn:DisableDrawLayer("BACKGROUND")
		self:addButtonBorder{obj=btn, relTo=btn.icon, reParent={btn.text}}
	end
	self:addSkinFrame{obj=_G.ArmoryGearSetFrame, kfs=true}
	self:keepFontStrings(_G.ArmoryPaperDollTalent)
	for i = 1, 2 do
		local sBar = "ArmoryPaperDollTradeSkillFrame" .. i
		self:glazeStatusBar(_G[sBar .. "Bar"])
		self:glazeStatusBar(_G[sBar .. "BackgroundBar"])
		_G[sBar .. "BackgroundBar"]:SetStatusBarColor(_G.unpack(self.sbColour))
	end
	self:keepFontStrings(_G.ArmoryPaperDollTradeSkill)
	self:skinDropDown{obj=_G.ArmoryAttributesFramePlayerStatDropDown}
	_G.ArmoryAttributesFrame:DisableDrawLayer("BACKGROUND")
	-- slots
	for _, child in _G.ipairs{_G.ArmoryPaperDollItemsFrame:GetChildren()} do
		child:DisableDrawLayer("BACKGROUND")
		self:addButtonBorder{obj=child}
	end
	self:keepFontStrings(_G.ArmoryPaperDollTalentOverlay)
	for i = 1, 2 do
		local sBar = "ArmoryPaperDollTradeSkillOverlayFrame" .. i
		self:glazeStatusBar(_G[sBar .. "Bar"])
		self:glazeStatusBar(_G[sBar .. "BackgroundBar"])
		_G[sBar .. "BackgroundBar"]:SetStatusBarColor(_G.unpack(self.sbColour))
	end
	self:keepFontStrings(_G.ArmoryPaperDollTradeSkillOverlay)
	self:skinDropDown{obj=_G.ArmoryAttributesOverlayTopFramePlayerStatDropDown}
	_G.ArmoryAttributesOverlayTopFrame:DisableDrawLayer("BACKGROUND")
	self:skinDropDown{obj=_G.ArmoryAttributesOverlayBottomFramePlayerStatDropDown}
	_G.ArmoryAttributesOverlayBottomFrame:DisableDrawLayer("BACKGROUND")

-->>-- Pet Tab
	self:addButtonBorder{obj=_G.ArmoryPetFramePetInfo, relTo=_G.ArmoryPetFrameSelectedPetIcon}
	_G.ArmoryPetSpecFrame.ring:SetAlpha(0)
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
	self:addButtonBorder{obj=_G.ArmoryPetFrameNextPageButton, ofs=0}
	self:addButtonBorder{obj=_G.ArmoryPetFramePrevPageButton, ofs=0}

-->>-- Talents Tab
	self:removeRegions(_G.ArmoryTalentFrame, {2}) -- horizontal line
	_G.ArmoryTalentFrame.Spec.ring:SetAlpha(0)

-->>-- PVP Tab
	-- Tabs (top of frame)
	for i = 1, 2 do
		local tab = _G["ArmoryPVPFrameTab" .. i]
		tab:DisableDrawLayer("BACKGROUND")
		self:addSkinFrame{obj=tab, x1=4, y1=-6, x2=0, y2=-4}
	end
	-- Player vs. Player
	self:keepFontStrings(_G.ArmoryPVPFrame)
	self:skinButton{obj=_G.ArmoryConquestFrame.Arena2v2}
	self:skinButton{obj=_G.ArmoryConquestFrame.Arena3v3}
	self:skinButton{obj=_G.ArmoryConquestFrame.RatedBG}
	-- Honor Talents
	_G.ArmoryPVPHonorXPBar.Frame:SetTexture(nil)
	self:glazeStatusBar(_G.ArmoryPVPHonorXPBar.Bar, 0,  nil)
	-- ArmoryConquest Tooltip
	self:addSkinFrame{obj=_G.ArmoryConquestTooltip}

-->>-- Other Tab (parent for the Reputation, RaidInfo & Currency Frames)
	self:keepFontStrings(_G.ArmoryOtherFrame)
	-- Tabs (top of frame)
	for i = 1, 4 do
		local tab = _G["ArmoryOtherFrameTab" .. i]
		tab:DisableDrawLayer("BACKGROUND")
		self:addSkinFrame{obj=tab, x1=4, y1=0, x2=-1, y2=-4}
	end
	-- Reputation SubFrame
	self:keepFontStrings(_G.ArmoryReputationFrame)
	_G.ArmoryReputationListScrollFrame:DisableDrawLayer("BACKGROUND")
	self:skinSlider{obj=_G.ArmoryReputationListScrollFrame.ScrollBar}
	for i = 1, _G.ARMORY_NUM_FACTIONS_DISPLAYED do
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
			for i = 1, _G._G.ARMORY_NUM_FACTIONS_DISPLAYED do
				self:checkTex(_G["ArmoryReputationBar" .. i .. "ExpandOrCollapseButton"])
			end
		end)
	end
	--	RaidInfo SubFrame
	self:keepFontStrings(_G.ArmoryRaidInfoFrame)
	-- self:skinSlider{obj=_G.ArmoryRaidInfoScrollFrame.ScrollBar}
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
	self:skinButton{obj=_G.ArmoryInventoryCollapseAllButton, mp=true}
	self:addSkinFrame{obj=_G.ArmoryInventoryFrame, kfs=true, x1=10, y1=-11, x2=-32, y2=71}
	-- Tabs
	self:skinTabs{obj=_G.ArmoryInventoryFrame}
	-- Icon View Tab
	_G.ArmoryInventoryIconViewFrame:DisableDrawLayer("ARTWORK")
	self:skinSlider{obj=_G.ArmoryInventoryIconViewFrame.ScrollBar}
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
			self:checkTex(_G.ArmoryInventoryCollapseAllButton)
		end)
	end
	-- List View Tab
	_G.ArmoryInventoryListViewScrollFrame:DisableDrawLayer("BACKGROUND")
	self:skinSlider{obj=_G.ArmoryInventoryListViewScrollFrame.ScrollBar}
	-- m/p buttons
	for i = 1, _G.ARMORY_INVENTORY_LINES_DISPLAYED do
		self:skinButton{obj=_G["ArmoryInventoryLine" .. i], mp=true}
	end
	if self.modBtns then
		-- hook to manage changes to button textures
		self:SecureHook("ArmoryInventoryListViewFrame_Update", function()
			for i = 1, _G.ARMORY_INVENTORY_LINES_DISPLAYED do
				local btn = _G["ArmoryInventoryLine" .. i]
				self:checkTex(btn)
				if not self.sBtn[btn]:IsShown() then -- not a header line
					btn:GetNormalTexture():SetAlpha(1) -- show item icon
				end
			end
			self:checkTex(_G.ArmoryInventoryCollapseAllButton)
		end)
	end
	-- Guild Bank Tab
	if _G.IsAddOnLoaded("ArmoryGuildBank") then
		_G.ArmoryInventoryGuildBankScrollFrame:DisableDrawLayer("BACKGROUND")
		self:skinSlider{obj=_G.ArmoryInventoryGuildBankScrollFrame.ScrollBar}
		-- m/p buttons
		for i = 1, _G.ARMORY_INVENTORY_LINES_DISPLAYED do
			self:skinButton{obj=_G["ArmoryInventoryGuildBankLine" .. i], mp=true}
		end
		if self.modBtns then
			-- hook to manage changes to button textures
			self:SecureHook("ArmoryInventoryGuildBankFrame_Update", function()
				for i = 1, _G.ARMORY_INVENTORY_LINES_DISPLAYED do
					local btn = _G["ArmoryInventoryGuildBankLine" .. i]
					self:checkTex(btn)
					if not self.sBtn[btn]:IsShown() then -- not a header line
						btn:GetNormalTexture():SetAlpha(1) -- show item icon
					end
				end
				self:checkTex(_G.ArmoryInventoryCollapseAllButton)
			end)
		end
	end

-->>-- Quest Log Tab
	self:SecureHook("ArmoryQuestInfo_Display", function(...)
		-- headers
		_G.ArmoryQuestInfoTitleHeader:SetTextColor(self.HTr, self.HTg, self.HTb)
		_G.ArmoryQuestInfoDescriptionHeader:SetTextColor(self.HTr, self.HTg, self.HTb)
		_G.ArmoryQuestInfoObjectivesHeader:SetTextColor(self.HTr, self.HTg, self.HTb)
		_G.ArmoryQuestInfoRewardsFrame.Header:SetTextColor(self.HTr, self.HTg, self.HTb)
		-- other text
		_G.ArmoryQuestInfoDescriptionText:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G.ArmoryQuestInfoObjectivesText:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G.ArmoryQuestInfoGroupSize:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G.ArmoryQuestInfoRewardText:SetTextColor(self.BTr, self.BTg, self.BTb)
		-- reward frame text
		_G.ArmoryQuestInfoRewardsFrame.ItemChooseText:SetTextColor(self.BTr, self.BTg, self.BTb)
        _G.ArmoryQuestInfoRewardsFrame.ItemReceiveText:SetTextColor(self.BTr, self.BTg, self.BTb)
        _G.ArmoryQuestInfoRewardsFrame.PlayerTitleText:SetTextColor(self.BTr, self.BTg, self.BTb)
        _G.ArmoryQuestInfoRewardsFrame.XPFrame.ReceiveText:SetTextColor(self.BTr, self.BTg, self.BTb)
		-- objective(s)
		for i = 1, #_G.ArmoryQuestInfoObjectivesFrame.Objectives do
			local r, g, b = _G.ArmoryQuestInfoObjectivesFrame.Objectives[i]:GetTextColor()
			 _G.ArmoryQuestInfoObjectivesFrame.Objectives[i]:SetTextColor(self.BTr - r, self.BTg - g, self.BTb - b)
		end
		-- spell line(s)
		for spellLine in _G.ArmoryQuestInfoRewardsFrame.spellHeaderPool:EnumerateActive() do
			spellLine:SetVertexColor(aObj.BTr, aObj.BTg, aObj.BTb)
		end
	end)
	_G.ArmoryQuestInfoTimerText:SetTextColor(self.BTr, self.BTg, self.BTb)
	_G.ArmoryQuestInfoAnchor:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:skinEditBox{obj=_G.ArmoryQuestFrameEditBox, regs={6}}
	-- QuestLog frame
	self:removeRegions(_G.ArmoryQuestLogCollapseAllButton, {5, 6, 7})
	self:skinButton{obj=_G.ArmoryQuestLogCollapseAllButton, mp=true}
	self:keepFontStrings(_G.ArmoryQuestLogFrame)
	self:keepFontStrings(_G.ArmoryEmptyQuestLogFrame)
	-- m/p buttons
	for i = 1, _G.ARMORY_QUESTS_DISPLAYED do
		self:skinButton{obj=_G["ArmoryQuestLogTitle" .. i], mp=true}
	end
	if self.modBtns then
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
	self:addSkinFrame{obj=_G.ArmoryQuestFrame, kfs=true, x1=10, y1=-11, x2=-33, y2=52}

-->>-- Spellbook Tab
	self:addSkinFrame{obj=_G.ArmorySpellBookFrame, kfs=true, x1=10, y1=-12, x2=-31, y2=71}
	-- Tabs (bottom)
	_G.PanelTemplates_SetNumTabs(_G.ArmorySpellBookFrame, 3)
	self:skinTabs{obj=_G.ArmorySpellBookFrame, suffix="Button", lod=true, regs={1}, x1=14, y1=-16, x2=-10, y2=18}
	if self.isTT then
		-- hook to handle tabs
		self:SecureHook("ArmoryToggleSpellBook", function(bookType)
			for i = 1, 3 do
				local tabName = _G["ArmorySpellBookFrameTabButton" .. i]
				local tabSF = tabName.sf
				if tabName.bookType == bookType then
					self:setActiveTab(tabSF)
				else
					self:setInactiveTab(tabSF)
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
	-- Tabs (side)
	for i = 1, _G.MAX_SKILLLINE_TABS do
		self:removeRegions(_G["ArmorySpellBookSkillLineTab" .. i], {1}) -- N.B. other regions are icon and highlight
	end

-->>-- Achievements Tab
	self:skinEditBox{obj=_G.ArmoryAchievementFrameEditBox, regs={6}}
	self:skinButton{obj=_G.ArmoryAchievementCollapseAllButton, mp=true}
	_G.ArmoryAchievementCollapseAllButton:DisableDrawLayer("BACKGROUND")
	_G.ArmoryAchievementListScrollFrame:DisableDrawLayer("BACKGROUND")
	self:skinSlider{obj=_G.ArmoryAchievementListScrollFrame.ScrollBar}
	self:skinButton{obj=_G.ArmoryAchievementFrameCloseButton, cb=true}
	self:addSkinFrame{obj=_G.ArmoryAchievementFrame, kfs=true, nb=true, x1=10, y1=-11, x2=-33, y2=71}
	-- Tabs
	self:skinTabs{obj=_G.ArmoryAchievementFrame, lod=true}
	-- m/p buttons
	for i = 1, _G.ARMORY_NUM_ACHIEVEMENTS_DISPLAYED do
		self:removeRegions(_G["ArmoryAchievementBar" .. i], {1, 2, 3}) -- textures
		self:skinButton{obj=_G["ArmoryAchievementBar" .. i .. "ExpandOrCollapseButton"], mp=true}
		self:glazeStatusBar(_G["ArmoryAchievementBar" .. i .. "AchievementBar"], 0)
		self:removeRegions(_G["ArmoryAchievementBar" .. i .. "AchievementBar"], {1, 2}) -- textures
	end
	if self.modBtns then
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
	self:addSkinFrame{obj=_G.ArmorySocialFrame, kfs=true, x1=10, y1=-11, x2=-33, y2=71}
	-- Friends ToggleTab
	self:skinSlider{obj=_G.ArmoryFriendsListScrollFrame.ScrollBar}
	-- Ignore ToggleTab
	self:skinSlider{obj=_G.ArmoryIgnoreListScrollFrame.ScrollBar}
	-- Events ToggleTab
	self:skinSlider{obj=_G.ArmoryEventsListScrollFrame.ScrollBar}

-->>-- Tradeskill Tabs
	self:removeRegions(_G.ArmoryTradeSkillFrame.RankFrame.Border, {1}) -- remove button texture
	self:glazeStatusBar(_G.ArmoryTradeSkillFrame.RankFrame, 0)
	self:skinEditBox{obj=_G.ArmoryTradeSkillFrame.SearchBox, regs={6, 7}, mi=true} -- 6 is text, 7 is icon
	self:moveObject{obj=_G.ArmoryTradeSkillFrame.SearchBox, y=1}
	self:removeRegions(_G.ArmoryTradeSkillFrame.ExpandButtonFrame)
	self:skinButton{obj=_G.ArmoryTradeSkillFrame.FilterButton}
	self:moveObject{obj=_G.ArmoryTradeSkillFrame.FilterButton, y=2}
	self:skinSlider{obj=_G.ArmoryTradeSkillFrame.RecipeList.ScrollBar, adj=-4, size=3}
	self:skinSlider{obj=_G.ArmoryTradeSkillFrame.DetailsFrame.ScrollBar}
	self:removeRegions(_G.ArmoryTradeSkillFrame.DetailsFrame.Contents, {6, 7,}) -- textures
	local btn = _G.ArmoryTradeSkillFrame.DetailsFrame.Contents.ResultIcon
	self:addButtonBorder{obj=btn, reParent={btn.Count}}
	for i = 1, 8 do
		btn = _G.ArmoryTradeSkillFrame.DetailsFrame.Contents["Reagent" .. i]
		self:addButtonBorder{obj=btn, libt=true}
		btn.NameFrame:SetTexture(nil)
	end
	btn = nil
	self:addSkinFrame{obj=_G.ArmoryTradeSkillFrame, kfs=true, nb=true, x1=10, y1=-11, x2=-32, y2=71} -- don't skin buttons, otherwise the CollapseAllbutton is skinned incorrectly
	self:skinButton{obj=_G.ArmoryTradeSkillFrameCloseButton, cb=true}
	for i = 1, #_G.ArmoryTradeSkillFrame.RecipeList.buttons do
		self:skinButton{obj=_G.ArmoryTradeSkillFrame.RecipeList.buttons[i], mp=true}
	end
	-- collapse all button
	self:skinButton{obj=_G.ArmoryTradeSkillFrame.ExpandButtonFrame.CollapseAllButton, mp=true} -- treat as just a texture
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
	self:addSkinFrame{obj=_G.ArmoryGuildBankFrame, bg=true, x1=6, y1=-11, x2=-32, y2=71}
	self:moveObject{obj=_G.ArmoryGuildBankFrameDeleteButton, x=3, y=-10}
	-- ArmoryListGuildBankFrame
	_G.ArmoryListGuildBankFrameMoneyBackgroundFrame:DisableDrawLayer("BACKGROUND")
	_G.ArmoryListGuildBankScrollFrame:DisableDrawLayer("BACKGROUND")
	self:skinSlider{obj=_G.ArmoryListGuildBankScrollFrame.ScrollBar}
	self:addSkinFrame{obj=_G.ArmoryListGuildBankFrame, kfs=true, x1=10, y1=-11, x2=-32, y2=71}
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
	self:addSkinFrame{obj=_G.ArmoryIconGuildBankFrame, kfs=true, y1=-10, y2=2}
	self:skinTabs{obj=_G.ArmoryIconGuildBankFrame, lod=true}
	-- Tabs (side)
	local objName
	for i = 1, _G.MAX_GUILDBANK_TABS do
		objName = "ArmoryIconGuildBankTab" .. i
		_G[objName]:DisableDrawLayer("BACKGROUND")
		self:addButtonBorder{obj=_G[objName .. "Button"], relTo=_G[objName .. "ButtonIconTexture"]}
	end
	objName = nil

end
