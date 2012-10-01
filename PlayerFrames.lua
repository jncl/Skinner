local aName, aObj = ...

local _G = _G
local ftype = "p"
local obj, objName, tex, texName, btn, btnName, tab, tabSF

function aObj:AchievementUI() -- LoD
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

		aObj:moveObject{obj=_G[statusBar..type], y=-3}
		aObj:moveObject{obj=_G[statusBar.."Text"], y=-3}
		_G[statusBar.."Left"]:SetAlpha(0)
		_G[statusBar.."Right"]:SetAlpha(0)
		_G[statusBar.."Middle"]:SetAlpha(0)
		self:glazeStatusBar(_G[statusBar], 0, _G[statusBar.."FillBar"])

	end
	local function skinStats()

		local btn
		for i = 1, #AchievementFrameStatsContainer.buttons do
			btn = _G["AchievementFrameStatsContainerButton"..i]
			btn.background:SetTexture(nil)
			btn.left:SetAlpha(0)
			btn.middle:SetAlpha(0)
			btn.right:SetAlpha(0)
		end

	end
	local function glazeProgressBar(pBar)

		if not aObj.sbGlazed[pBaro] then
			_G[pBar.."BorderLeft"]:SetAlpha(0)
			_G[pBar.."BorderRight"]:SetAlpha(0)
			_G[pBar.."BorderCenter"]:SetAlpha(0)
			aObj:glazeStatusBar(_G[pBar], 0, _G[pBar.."BG"])
		end

	end
	local function skinCategories()

		for i = 1, #AchievementFrameCategoriesContainer.buttons do
			_G["AchievementFrameCategoriesContainerButton"..i.."Background"]:SetAlpha(0)
		end

	end
	local function skinComparisonStats()

		local btnName
		for i = 1, #AchievementFrameComparisonStatsContainer.buttons do
			btnName = "AchievementFrameComparisonStatsContainerButton"..i
			if _G[btnName].isHeader then _G[btnName.."BG"]:SetAlpha(0) end
			_G[btnName.."HeaderLeft"]:SetAlpha(0)
			_G[btnName.."HeaderLeft2"]:SetAlpha(0)
			_G[btnName.."HeaderMiddle"]:SetAlpha(0)
			_G[btnName.."HeaderMiddle2"]:SetAlpha(0)
			_G[btnName.."HeaderRight"]:SetAlpha(0)
			_G[btnName.."HeaderRight2"]:SetAlpha(0)
		end

	end
	local function cleanButtons(frame, type)

		if prdbA.style == 1 then return end -- don't remove textures if option not chosen

		local btn, btnName
		-- remove textures etc from buttons
		for i = 1, #frame.buttons do
			btnName = frame.buttons[i]:GetName()..(type == "Comparison" and "Player" or "")
			btn = _G[btnName]
			btn:DisableDrawLayer("BACKGROUND")
			-- don't DisableDrawLayer("BORDER") as the button border won't show if skinned
			btn:DisableDrawLayer("ARTWORK")
			if btn.plusMinus then btn.plusMinus:SetAlpha(0) end
			btn.icon:DisableDrawLayer("BACKGROUND")
			btn.icon:DisableDrawLayer("BORDER")
			btn.icon:DisableDrawLayer("OVERLAY")
			self:addButtonBorder{obj=btn.icon, x1=4, y1=-1, x2=-4, y2=6}
			-- hook this to handle description text colour changes
			self:SecureHook(btn, "Saturate", function(this)
				this.description:SetTextColor(self.BTr, self.BTg, self.BTb)
			end)
			if type == "Achievements" then
				-- set textures to nil and prevent them from being changed as guildview changes the textures
				_G[btnName.."TopTsunami1"]:SetTexture(nil)
				_G[btnName.."TopTsunami1"].SetTexture = function() end
				_G[btnName.."BottomTsunami1"]:SetTexture(nil)
				_G[btnName.."BottomTsunami1"].SetTexture = function() end
				btn.hiddenDescription:SetTextColor(self.BTr, self.BTg, self.BTb)
			elseif type == "Summary" then
				if not btn.tooltipTitle then btn:Saturate() end
			elseif type == "Comparison" then
				-- force update to colour the button
				if btn.completed then btn:Saturate() end
				-- Friend
				btn = _G[btnName:gsub("Player", "Friend")]
				btn:DisableDrawLayer("BACKGROUND")
				-- don't DisableDrawLayer("BORDER") as the button border won't show if skinned
				btn:DisableDrawLayer("ARTWORK")
				btn.icon:DisableDrawLayer("BACKGROUND")
				btn.icon:DisableDrawLayer("BORDER")
				btn.icon:DisableDrawLayer("OVERLAY")
				self:addButtonBorder{obj=btn.icon, x1=4, y1=-1, x2=-4, y2=6}
				-- force update to colour the button
				if btn.completed then btn:Saturate() end
			end
		end

	end

	-- this is not a standard dropdown
	self:moveObject{obj=AchievementFrameFilterDropDown, y=-7}
	if self.db.profile.TexturedDD then
		tex = AchievementFrameFilterDropDown:CreateTexture(nil, "BORDER")
		tex:SetTexture(self.itTex)
		tex:SetWidth(110)
		tex:SetHeight(19)
		tex:SetPoint("RIGHT", AchievementFrameFilterDropDown, "RIGHT", -3, 4)
	end
	-- skin the frame
	if self.db.profile.DropDownButtons then
		self:addSkinFrame{obj=AchievementFrameFilterDropDown, ft=ftype, aso={ng=true}, x1=-8, y1=2, x2=2, y2=7}
	end
	self:skinTabs{obj=AchievementFrame, regs={9, 10}, ignore=true, lod=true, x1=9, y1=2, x2=-9, y2=-10}
	self:addSkinFrame{obj=AchievementFrame, ft=ftype, kfs=true, bgen=1, y1=8, y2=-3}

-->>-- move Header info
	self:keepFontStrings(AchievementFrameHeader)
	self:moveObject{obj=AchievementFrameHeaderTitle, x=-60, y=-25}
	self:moveObject{obj=AchievementFrameHeaderPoints, x=40, y=-5}
	self:moveObject{obj=AchievementFrameCloseButton, y=6}
	AchievementFrameHeaderShield:SetAlpha(1)

-->>-- Categories Panel (on the Left)
	self:skinSlider{obj=AchievementFrameCategoriesContainerScrollBar, adj=-4}
	self:addSkinFrame{obj=AchievementFrameCategories, ft=ftype, y2=-2}
	self:SecureHook("AchievementFrameCategories_Update", function()
		skinCategories()
	end)
	skinCategories()

	local bbR, bbG, bbB, bbA = unpack(self.bbColour)

-->>-- Achievements Panel (on the right)
	self:keepFontStrings(AchievementFrameAchievements)
	self:getChild(AchievementFrameAchievements, 2):SetBackdropBorderColor(bbR, bbG, bbB, bbA) -- frame border
	self:skinSlider{obj=AchievementFrameAchievementsContainerScrollBar, adj=-4}
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
		self:RawHook("AchievementButton_GetMeta", function(...)
			local obj = self.hooks.AchievementButton_GetMeta(...)
			obj:DisableDrawLayer("BORDER")
			self:addButtonBorder{obj=obj, es=12, relTo=obj.icon}
			return obj
		end, true)
	end
	-- glaze any existing progress bars
	for i = 1, 10 do
		objName = "AchievementFrameProgressBar"..i
		if _G[objName] then glazeProgressBar(objName) end
	end
	-- hook this to skin StatusBars used by the Objectives mini panels
	self:RawHook("AchievementButton_GetProgressBar", function(...)
		local obj = self.hooks.AchievementButton_GetProgressBar(...)
		glazeProgressBar(obj:GetName())
		return obj
	end, true)

-->>-- Stats
	self:keepFontStrings(AchievementFrameStats)
	self:skinSlider{obj=AchievementFrameStatsContainerScrollBar, adj=-4}
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
	if not AchievementFrameSummary:IsVisible() and prdbA.style == 2 then
		self:SecureHookScript(AchievementFrameSummary, "OnShow", function()
			cleanButtons(AchievementFrameSummaryAchievements, "Summary")
			self:Unhook(AchievementFrameSummary, "OnShow")
		end)
	else
		cleanButtons(AchievementFrameSummaryAchievements, "Summary")
	end
	-- Categories SubPanel
	self:keepFontStrings(AchievementFrameSummaryCategoriesHeader)
	for i = 1, #ACHIEVEMENTUI_SUMMARYCATEGORIES do
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
	if not AchievementFrameComparison:IsVisible() and prdbA.style == 2 then
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

end

function aObj:ArchaeologyUI() -- LoD
	if not self.db.profile.ArchaeologyUI or self.initialized.ArchaeologyUI then return end
	self.initialized.ArchaeologyUI = true

	self:moveObject{obj=ArchaeologyFrame.infoButton, x=-25}
	self:skinDropDown{obj=ArchaeologyFrame.raceFilterDropDown}
	ArchaeologyFrameRankBarBackground:SetAllPoints(ArchaeologyFrame.rankBar)
	ArchaeologyFrameRankBarBorder:Hide()
	self:glazeStatusBar(ArchaeologyFrame.rankBar, 0,  ArchaeologyFrameRankBarBackground)
	self:addSkinFrame{obj=ArchaeologyFrame, ft=ftype, kfs=true, ri=true, x1=30, y1=2, x2=1}
-->>-- Summary Page
	self:keepFontStrings(ArchaeologyFrame.summaryPage) -- remove title textures
	ArchaeologyFrameSummaryPageTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
	for i = 1, ARCHAEOLOGY_MAX_RACES do
		ArchaeologyFrame.summaryPage["race"..i].raceName:SetTextColor(self.BTr, self.BTg, self.BTb)
	end
-->>-- Completed Page
	self:keepFontStrings(ArchaeologyFrame.completedPage) -- remove title textures
	ArchaeologyFrame.completedPage.infoText:SetTextColor(self.BTr, self.BTg, self.BTb)
	ArchaeologyFrame.completedPage.titleBig:SetTextColor(self.HTr, self.HTg, self.HTb)
	ArchaeologyFrame.completedPage.titleTop:SetTextColor(self.BTr, self.BTg, self.BTb)
	ArchaeologyFrame.completedPage.titleMid:SetTextColor(self.BTr, self.BTg, self.BTb)
	ArchaeologyFrame.completedPage.pageText:SetTextColor(self.BTr, self.BTg, self.BTb)
	for i = 1, ARCHAEOLOGY_MAX_COMPLETED_SHOWN do
		ArchaeologyFrame.completedPage["artifact"..i].artifactName:SetTextColor(self.HTr, self.HTg, self.HTb)
		ArchaeologyFrame.completedPage["artifact"..i].artifactSubText:SetTextColor(self.BTr, self.BTg, self.BTb)
		ArchaeologyFrame.completedPage["artifact"..i].border:Hide()
		_G["ArchaeologyFrameCompletedPageArtifact"..i.."Bg"]:Hide()
	end
	self:addButtonBorder{obj=ArchaeologyFrame.completedPage.prevPageButon, ofs=0} -- N.B. spelling!
	self:addButtonBorder{obj=ArchaeologyFrame.completedPage.nextPageButon, ofs=0} -- N.B. spelling!
-->>-- Artifact Page
	self:removeRegions(ArchaeologyFrame.artifactPage, {2, 3}) -- title textures
	ArchaeologyFrame.artifactPage:DisableDrawLayer("BACKGROUND")
	ArchaeologyFrame.artifactPage:DisableDrawLayer("BORDER")
	ArchaeologyFrame.artifactPage.historyTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
	ArchaeologyFrame.artifactPage.historyScroll.child.text:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:skinScrollBar{obj=ArchaeologyFrame.artifactPage.historyScroll}
	-- Solve Frame
	ArchaeologyFrameArtifactPageSolveFrameStatusBarBarBG:Hide()
	self:glazeStatusBar(ArchaeologyFrame.artifactPage.solveFrame.statusBar, 0, nil)
	ArchaeologyFrame.artifactPage.solveFrame.statusBar:SetStatusBarColor(0.75, 0.45, 0, 0.7)
-->>-- Help Page
	self:removeRegions(ArchaeologyFrame.helpPage, {2, 3}) -- title textures
	ArchaeologyFrame.helpPage.titleText:SetTextColor(self.HTr, self.HTg, self.HTb)
	ArchaeologyFrameHelpPageDigTex:SetTexCoord(0.05, 0.885, 0.055, 0.9) -- remove texture surrounds
	ArchaeologyFrameHelpPageDigTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
	ArchaeologyFrameHelpPageHelpScrollHelpText:SetTextColor(self.BTr, self.BTg, self.BTb)

end

function aObj:Buffs()
	if not self.db.profile.Buffs or self.initialized.Buffs then return end
	self.initialized.Buffs = true

	self:add2Table(self.pKeys1, "Buffs")

	if self.modBtnBs then
		local function skinBuffs()

			-- handle in combat
			if InCombatLockdown() then
				aObj:add2Table(aObj.oocTab, {skinBuffs, {nil}})
				return
			end

			local btn
			for i= 1, BUFF_MAX_DISPLAY do
				btn = _G["BuffButton"..i]
				if btn and not btn.sknrBdr then
					-- add button borders
					aObj:addButtonBorder{obj=btn}
					aObj:moveObject{obj=btn.duration, y=-1}
				end
			end

		end
		-- hook this to skin new Buffs
		self:SecureHook("BuffFrame_Update", function()
			skinBuffs()
		end)
		-- skin any current Buffs/Debuffs
		skinBuffs()

	end

	-- Debuffs already have a coloured border
	-- Temp Enchants already have a coloured border

-->>-- Consolidated Buffs
	if self.modBtnBs then
		-- remove surrounding border & resize
		ConsolidatedBuffsIcon:SetTexCoord(0.128, 0.37, 0.235, 0.7375)
		ConsolidatedBuffsIcon:SetWidth(30)
		ConsolidatedBuffsIcon:SetHeight(30)
		self:addButtonBorder{obj=ConsolidatedBuffs}
	end
	self:addSkinFrame{obj=ConsolidatedBuffsTooltip, x1=4, y1=-3, x2=-5, y2=4}

end

function aObj:CastingBar()
	if not self.db.profile.CastingBar.skin or self.initialized.CastingBar then return end
	self.initialized.CastingBar = true

	self:add2Table(self.pKeys2, "CastingBar")

	for _, prefix in pairs{"", "Pet"} do

		obj = _G[prefix.."CastingBarFrame"]
		obj.border:SetAlpha(0)
		self:changeShield(obj.borderShield, obj.icon)
		obj.barFlash:SetAllPoints()
		obj.barFlash:SetTexture([[Interface\Buttons\WHITE8X8]])
		if self.db.profile.CastingBar.glaze then
			self:glazeStatusBar(obj, 0, self:getRegion(obj, 1))
		end
		-- adjust text and spark in Classic mode
		if prefix == ""
		and not obj.ignoreFramePositionManager then
			obj.text:SetPoint("TOP", 0, 2)
			obj.barSpark.offsetY = -1
		end

	end
	-- hook this to handle the CastingBar being attached to the Unitframe and then reset
	self:SecureHook("CastingBarFrame_SetLook", function(castBar, look)
		castBar.border:SetAlpha(0)
		castBar.barFlash:SetAllPoints()
		castBar.barFlash:SetTexture([[Interface\Buttons\WHITE8X8]])
		if look == "CLASSIC" then
			castBar.text:SetPoint("TOP", 0, 2)
			castBar.barSpark.offsetY = -1
		end
	end)

end

function aObj:CharacterFrames()
	if not self.db.profile.CharacterFrames or self.initialized.CharacterFrames then return end
	self.initialized.CharacterFrames = true

	self:add2Table(self.pKeys1, "CharacterFrames")

	-- Character Frame
	self:removeInset(CharacterFrameInsetRight)
	self:skinTabs{obj=CharacterFrame}
	self:addSkinFrame{obj=CharacterFrame, ft=ftype, kfs=true, ri=true, bgen=2, x1=-3, y1=2, x2=1, y2=-5}
	self:addButtonBorder{obj=CharacterFrameExpandButton, ofs=-2}

	-- PaperDoll Frame
	self:keepFontStrings(PaperDollFrame)
	CharacterModelFrame.controlFrame:DisableDrawLayer("BACKGROUND")
	-- skin slots
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
	-- Sidebar Tabs
	PaperDollSidebarTabs.DecorLeft:SetAlpha(0)
	PaperDollSidebarTabs.DecorRight:SetAlpha(0)
	for i = 1, #PAPERDOLL_SIDEBARS do
		tab = _G["PaperDollSidebarTab"..i]
		tab.TabBg:SetAlpha(0)
		tab.Hider:SetAlpha(0)
		-- use a button border to indicate the active tab
		self.modUIBtns:addButtonBorder{obj=tab, relTo=tab.Icon} -- use module function here to force creation
		tab.sknrBdr:SetBackdropBorderColor(1, 0.6, 0, 1)
	end
	-- hook this to manage the active tab
	self:SecureHook("PaperDollFrame_UpdateSidebarTabs", function()
		for i = 1, #PAPERDOLL_SIDEBARS do
			local tab = _G["PaperDollSidebarTab"..i]
			if (_G[PAPERDOLL_SIDEBARS[i].frame]:IsShown()) then
				tab.sknrBdr:Show()
			else
				tab.sknrBdr:Hide()
			end
		end
	end)
	-- Stats
	for i = 1, 7 do
		local grp = _G["CharacterStatsPaneCategory"..i]
		grp.BgTop:SetAlpha(0)
		grp.BgBottom:SetAlpha(0)
		grp.BgMiddle:SetAlpha(0)
		grp.BgMinimized:SetAlpha(0)
	end
	-- Titles
	self:SecureHookScript(PaperDollTitlesPane, "OnShow", function(this)
		for i = 1, #this.buttons do
			btn = this.buttons[i]
			btn:DisableDrawLayer("BACKGROUND")
		end
		self:Unhook(PaperDollTitlesPane, "OnShow")
	end)
	self:skinSlider{obj=PaperDollTitlesPane.scrollBar, adj=-4}
	-- Equipment Manager
	self:SecureHookScript(PaperDollEquipmentManagerPane, "OnShow", function(this)
		for i = 1, #this.buttons do
			btn = this.buttons[i]
			btn:DisableDrawLayer("BACKGROUND")
			self:addButtonBorder{obj=btn, relTo=btn.icon}
		end
		self:Unhook(PaperDollEquipmentManagerPane, "OnShow")
	end)
	self:skinSlider{obj=PaperDollEquipmentManagerPane.scrollBar, adj=-4}
	PaperDollEquipmentManagerPane.EquipSet.ButtonBackground:SetAlpha(0)

	-- GearManagerDialog Popup Frame
	self:skinScrollBar{obj=GearManagerDialogPopupScrollFrame}
	self:skinEditBox{obj=GearManagerDialogPopupEditBox, regs={9}}
	for i = 1, NUM_GEARSET_ICONS_SHOWN do
		btn = _G["GearManagerDialogPopupButton"..i]
		btn:DisableDrawLayer("BACKGROUND")
		self:addButtonBorder{obj=btn}
	end
	self:addSkinFrame{obj=GearManagerDialogPopup, ft=ftype, kfs=true, x1=4, y1=-2, x2=-1, y2=3}

	-- PetPaperDoll Frame
	PetPaperDollPetModelBg:SetAlpha(0) -- changed in blizzard code
	PetModelFrameShadowOverlay:Hide()
	self:removeRegions(PetPaperDollFrameExpBar, {1, 2})
	self:glazeStatusBar(PetPaperDollFrameExpBar, 0)
	self:makeMFRotatable(PetModelFrame)
	-- up the Frame level otherwise the tooltip doesn't work
	RaiseFrameLevel(PetPaperDollPetInfo)

	-- Reputation Frame
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
		obj = "ReputationBar"..i
		self:skinButton{obj=_G[obj.."ExpandOrCollapseButton"], mp=true} -- treat as just a texture
		_G[obj.."Background"]:SetAlpha(0)
		_G[obj.."ReputationBarLeftTexture"]:SetAlpha(0)
		_G[obj.."ReputationBarRightTexture"]:SetAlpha(0)
		self:glazeStatusBar(_G[obj.."ReputationBar"], 0)
	end

	self:addSkinFrame{obj=ReputationDetailFrame, ft=ftype, kfs=true, x1=6, y1=-6, x2=-6, y2=6}

	-- TokenFrame
	if self.db.profile.ContainerFrames.skin then
		BACKPACK_TOKENFRAME_HEIGHT = BACKPACK_TOKENFRAME_HEIGHT - 6
		BackpackTokenFrame:DisableDrawLayer("BACKGROUND")
	end

	self:keepFontStrings(TokenFrame)
	self:skinScrollBar{obj=TokenFrameContainer}

	self:SecureHookScript(TokenFrame, "OnShow", function(this)
		-- remove header textures
		for i = 1, #TokenFrameContainer.buttons do
			self:removeRegions(TokenFrameContainer.buttons[i], {6, 7, 8})
		end
		self:Unhook(TokenFrame, "OnShow")
	end)

	self:addSkinFrame{obj=TokenFramePopup,ft=ftype, kfs=true, y1=-6, x2=-6, y2=6}

end

function aObj:CompactFrames()
	if not self.db.profile.CompactFrames or self.initialized.CompactFrames then return end
	self.initialized.CompactFrames = true

	self:add2Table(self.pKeys1, "CompactFrames")

	local function skinUnit(unit)

		-- handle in combat
		if InCombatLockdown() then
			aObj:add2Table(aObj.oocTab, {skinUnit, {unit}})
			return
		end

		unit:DisableDrawLayer("BACKGROUND")
		unit:DisableDrawLayer("BORDER")

	end
	local function skinGrp(grp)

		grp.borderFrame:SetAlpha(0)
		local grpName = grp:GetName()
		for i = 1, MEMBERS_PER_RAID_GROUP do
			skinUnit(_G[grpName.."Member"..i])
		end

	end

-->>-- Compact Party Frame
	self:SecureHook("CompactPartyFrame_OnLoad", function()
		self:addSkinFrame{obj=CompactPartyFrame, ft=ftype, x1=2, y1=-10, x2=-3, y2=3}
		self:Unhook("CompactPartyFrame_OnLoad")
	end)
	-- hook this to skin any new CompactRaidGroup(s)
	self:SecureHook("CompactRaidGroup_UpdateBorder", function(frame)
		skinGrp(frame)
	end)

-->>-- Compact RaidFrame Container
	-- hook this to skin any new CompactRaidFrameContainer entries
	self:SecureHook("FlowContainer_AddObject", function(container, object)
		if container == CompactRaidFrameContainer then -- only for compact raid frame objects
			if container.frameUpdateList
			and container.frameUpdateList.group
			and container.frameUpdateList.group[object] then
				skinGrp(object)
			else
				skinUnit(object)
			end
		end
	end)
	-- skin any existing unit(s) [group, mini, normal]
	for type, frame in ipairs(CompactRaidFrameContainer.frameUpdateList) do
		if type == "group" then
			skinGrp(frame)
		else
			skinUnit(frame)
		end
	end
	self:addSkinFrame{obj=CompactRaidFrameContainer.borderFrame, ft=ftype, kfs=true, bg=true, y1=-1, x2=-5, y2=4}

-->>-- Compact RaidFrame Manager
	local function skinButton(btn)

		aObj:removeRegions(btn, {1, 2, 3})
		aObj:skinButton{obj=btn}

	end
	-- Buttons
	for _, v in pairs{"Tank", "Healer", "Damager"} do
		skinButton(CompactRaidFrameManager.displayFrame.filterOptions["filterRole"..v])
	end
	for i = 1, 8 do
		skinButton(CompactRaidFrameManager.displayFrame.filterOptions["filterGroup"..i])
	end
	CompactRaidFrameManager.displayFrame.filterOptions:DisableDrawLayer("BACKGROUND")
	self:skinDropDown{obj=CompactRaidFrameManager.displayFrame.profileSelector}
	skinButton(CompactRaidFrameManagerDisplayFrameLockedModeToggle)
	skinButton(CompactRaidFrameManagerDisplayFrameHiddenModeToggle)
	-- Leader Options
	skinButton(CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton)
	CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:GetNormalTexture():SetAlpha(1) -- icon
	skinButton(CompactRaidFrameManager.displayFrame.leaderOptions.readyCheckButton)
	skinButton(CompactRaidFrameManager.displayFrame.leaderOptions.rolePollButton)
	skinButton(CompactRaidFrameManager.displayFrame.convertToRaid)
	-- Display Frame
	self:keepFontStrings(CompactRaidFrameManager.displayFrame)
	-- Resize Frame
	self:addSkinFrame{obj=CompactRaidFrameManager.containerResizeFrame, ft=ftype, kfs=true, x1=-2, y1=-1, y2=4}
	-- Raid Frame Manager Frame
	self:addSkinFrame{obj=CompactRaidFrameManager, ft=ftype, kfs=true}

end

function aObj:ContainerFrames()
	if not self.db.profile.ContainerFrames.skin or self.initialized.ContainerFrames then return end
	self.initialized.ContainerFrames = true

	self:add2Table(self.pKeys2, "ContainerFrames")

	for i = 1, NUM_CONTAINER_FRAMES do
		objName = "ContainerFrame"..i
		self:addSkinFrame{obj=_G[objName], ft=ftype, kfs=true, x1=8, y1=-4, x2=-3}
		-- resize and move the bag name to make it more readable
		obj = _G[objName.."Name"]
		obj:SetWidth(145)
		self:moveObject{obj=obj, x=-30}
		-- add button borders
		for j = 1, MAX_CONTAINER_ITEMS do
			self:addButtonBorder{obj=_G[objName.."Item"..j]}
		end
	end
	self:skinEditBox{obj=BagItemSearchBox, regs={9}, mi=true, noHeight=true, noMove=true}

end

function aObj:DressUpFrame()
	if not self.db.profile.DressUpFrame or self.initialized.DressUpFrame then return end
	self.initialized.DressUpFrame = true

	self:add2Table(self.pKeys1, "DressUpFrame")

	self:removeRegions(DressUpFrame, {1, 2, 3, 4, 5}) -- N.B. regions 6 & 7 are text, 8-11 are the background picture
	DressUpModel.controlFrame:DisableDrawLayer("BACKGROUND")
	self:addSkinFrame{obj=DressUpFrame, ft=ftype, x1=10, y1=-12, x2=-33, y2=73}

end

function aObj:EncounterJournal() -- LoD
	if not self.db.profile.EncounterJournal or self.initialized.EncounterJournal then return end
	self.initialized.EncounterJournal = true

	self:removeInset(EncounterJournal.inset)
	self:addSkinFrame{obj=EncounterJournal, ft=ftype, kfs=true, y1=2, x2=1}

-->>-- Search EditBox, dropdown and results frame
	self:skinEditBox{obj=EncounterJournal.searchBox, regs={9}, mi=true, noHeight=true, noMove=true}
	EncounterJournal.searchBox.sbutton1:DisableDrawLayer("OVERLAY")
	self:addSkinFrame{obj=EncounterJournal.searchResults, ft=ftype, kfs=true, ofs=6, y1=-1, x2=4}
	self:skinSlider{obj=EncounterJournal.searchResults.scrollFrame.scrollBar, adj=-4}
	for i = 1, #EncounterJournal.searchResults.scrollFrame.buttons do
		btn = EncounterJournal.searchResults.scrollFrame.buttons[i]
		self:removeRegions(btn, {1})
		btn:GetNormalTexture():SetAlpha(0)
		btn:GetPushedTexture():SetAlpha(0)
		self:addButtonBorder{obj=btn, relTo=btn.icon}
	end
-->>-- Nav Bar
	EncounterJournal.navBar:DisableDrawLayer("BACKGROUND")
	EncounterJournal.navBar:DisableDrawLayer("BORDER")
	EncounterJournal.navBar.overlay:DisableDrawLayer("OVERLAY")
	EncounterJournal.navBar.home:DisableDrawLayer("OVERLAY")
	EncounterJournal.navBar.home:GetNormalTexture():SetAlpha(0)
	EncounterJournal.navBar.home:GetPushedTexture():SetAlpha(0)
	EncounterJournal.navBar.home.text:SetPoint("RIGHT", -20, 0)
-->>-- InstanceSelect frame
	EncounterJournal.instanceSelect.bg:SetAlpha(0)
	self:skinDropDown{obj=EJTierDropDown}
	self:skinSlider{obj=EncounterJournal.instanceSelect.scroll.ScrollBar, adj=-6}
	self:addSkinFrame{obj=EncounterJournal.instanceSelect.scroll, ft=ftype, ofs=6, x2=4}
	self:addButtonBorder{obj=EncounterJournalInstanceSelectScrollDownButton, ofs=-2}
	-- Instance buttons
	if self.modBtnBs then
		for i = 1, 30 do
			btn = EncounterJournal.instanceSelect.scroll.child["instance"..i]
			if btn then
				self:addButtonBorder{obj=btn, relTo=btn.bgImage, ofs=0}
			end
		end
	end
	-- Tabs
	EncounterJournal.instanceSelect.raidsTab:DisableDrawLayer("BACKGROUND")
	EncounterJournal.instanceSelect.dungeonsTab:DisableDrawLayer("BACKGROUND")
-->>-- Encounter frame
	-- Instance frame
	obj = EncounterJournal.encounter.instance
	obj.loreBG:SetTexCoord(0.06, 0.70, 0.08, 0.58)
	obj.loreBG:SetWidth(370)
	obj.loreBG:SetHeight(315)
	self:moveObject{obj=obj.title, y=40}
	EncounterJournalEncounterFrameInstanceFrameTitleBG:SetAlpha(0)
	self:moveObject{obj=obj.mapButton, x=-20, y=-20}
	self:addButtonBorder{obj=obj.mapButton, relTo=obj.mapButton.texture, x1=2, y1=-1, x2=-2, y2=1}
	self:skinSlider{obj=obj.loreScroll.ScrollBar, adj=-4}
	obj.loreScroll.child.lore:SetTextColor(self.BTr, self.BTg, self.BTb)
	-- Model frame
	self:makeMFRotatable(EncounterJournal.encounter.model)
	self:getRegion(EncounterJournal.encounter.model, 1):SetAlpha(0) -- TitleBG
	-- Boss/Creature buttons
	self:SecureHook("EncounterJournal_DisplayInstance", function(instanceID, noButton)
		for i = 1, 10 do
			btn = _G["EncounterJournalBossButton"..i]
			if btn then
				btn:SetNormalTexture(nil)
				btn:SetPushedTexture(nil)
			end
		end
	end)
	self:SecureHook("EncounterJournal_DisplayEncounter", function(encounterID, noButton)
		for i = 1, 6 do
			EncounterJournal.encounter["creatureButton"..i]:SetNormalTexture(nil)
			local hTex = EncounterJournal.encounter["creatureButton"..i]:GetHighlightTexture()
			hTex:SetTexture([[Interface\EncounterJournal\UI-EncounterJournalTextures]])
			hTex:SetTexCoord(0.68945313, 0.81054688, 0.33300781, 0.39257813)
		end
	end)
	-- Info frame
	self:getRegion(EncounterJournal.encounter.info, 1):SetAlpha(0) -- BG
	EncounterJournal.encounter.info.dungeonBG:SetAlpha(0)
	EncounterJournal.encounter.info.encounterTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
	self:skinSlider{obj=EncounterJournal.encounter.info.detailsScroll.ScrollBar, adj=-4}
	EncounterJournal.encounter.info.detailsScroll.child.description:SetTextColor(self.BTr, self.BTg, self.BTb)
	EncounterJournalEncounterFrameInfoResetButton:SetNormalTexture(nil)
	EncounterJournalEncounterFrameInfoResetButton:SetPushedTexture(nil)
	EncounterJournal.encounter.info.difficulty:SetNormalTexture(nil)
	EncounterJournal.encounter.info.difficulty:SetPushedTexture(nil)
	EncounterJournal.encounter.info.difficulty:DisableDrawLayer("BACKGROUND")
	-- Hook this to skin headers
	self:SecureHook("EncounterJournal_ToggleHeaders", function(this, doNotShift)
		for i = 1, 25 do
			obj = _G["EncounterJournalInfoHeader"..i]
			if obj then
				obj.button:DisableDrawLayer("BACKGROUND")
				obj.description:SetTextColor(self.BTr, self.BTg, self.BTb)
				obj.descriptionBG:SetAlpha(0)
				obj.descriptionBGBottom:SetAlpha(0)
				_G["EncounterJournalInfoHeader"..i.."HeaderButtonPortraitFrame"]:SetAlpha(0)
			end
		end
	end)
	-- Loot
	self:skinSlider{obj=EncounterJournal.encounter.info.lootScroll.scrollBar, adj=-4}
	EncounterJournal.encounter.info.lootScroll.filter:DisableDrawLayer("BACKGROUND")
	EncounterJournal.encounter.info.lootScroll.filter:SetNormalTexture(nil)
	EncounterJournal.encounter.info.lootScroll.filter:SetPushedTexture(nil)
	EncounterJournal.encounter.info.lootScroll.classClearFilter:DisableDrawLayer("BACKGROUND")
	-- hook this to skin loot entries
	self:SecureHook("EncounterJournal_LootUpdate", function()
		for i = 1, #EncounterJournal.encounter.info.lootScroll.buttons do
			btn = EncounterJournal.encounter.info.lootScroll.buttons[i]
			btn:DisableDrawLayer("BORDER")
			btn.armorType:SetTextColor(self.BTr, self.BTg, self.BTb)
			btn.slot:SetTextColor(self.BTr, self.BTg, self.BTb)
			btn.boss:SetTextColor(self.BTr, self.BTg, self.BTb)
			self:addButtonBorder{obj=btn, relTo=btn.icon}
		end

	end)
	-- Tabs (side)
	for _, v in pairs{"bossTab", "lootTab"} do
		EncounterJournal.encounter.info[v]:SetNormalTexture(nil)
		EncounterJournal.encounter.info[v]:SetPushedTexture(nil)
		EncounterJournal.encounter.info[v]:SetDisabledTexture(nil)
		self:addSkinFrame{obj=EncounterJournal.encounter.info[v], ft=ftype, noBdr=true, ofs=-3, aso={rotate=true}} -- gradient is right to left
	end
	self:moveObject{obj=EncounterJournal.encounter.info.bossTab, x=10}
	-- hide/show the texture to realign it on the tab
	EncounterJournal.encounter.info.bossTab.unselected:Hide()
	EncounterJournal.encounter.info.bossTab.unselected:Show()

end

function aObj:EquipmentFlyout()
	if not self.db.profile.EquipmentFlyout or self.initialized.EquipmentFlyout then return end
	self.initialized.EquipmentFlyout = true

	self:add2Table(self.pKeys1, "EquipmentFlyout")

	local btnFrame = EquipmentFlyoutFrame.buttonFrame
	self:addSkinFrame{obj=btnFrame, ft=ftype, x1=-3, y1=2, x2=5, y2=-3}
	self:SecureHook("EquipmentFlyout_Show", function(...)
		for i = 1, btnFrame["numBGs"] do
			btnFrame["bg" .. i]:SetAlpha(0)
		end
		if self.modBtnBs then
			for i = 1, #EquipmentFlyoutFrame.buttons do
				btn = EquipmentFlyoutFrame.buttons[i]
				if not btn.sknrBdr then self:addButtonBorder{obj=btn, ibt=true} end
			end
		end
	end)

end

function aObj:FriendsFrame()
	if not self.db.profile.FriendsFrame or self.initialized.FriendsFrame then return end
	self.initialized.FriendsFrame = true

	self:add2Table(self.pKeys1, "FriendsFrame")

	self:skinTabs{obj=FriendsFrame, lod=true}
	self:addSkinFrame{obj=FriendsFrame, ft=ftype, kfs=true, ri=true, y1=2, x2=1, y2=-5}

	self:skinDropDown{obj=FriendsDropDown}
	self:skinDropDown{obj=TravelPassDropDown}
	-- FriendsTabHeader Frame
	FriendsFrameBattlenetFrame:DisableDrawLayer("BACKGROUND")
	self:addButtonBorder{obj=FriendsFrameBattlenetFrame.BroadcastButton, ofs=-2}
	self:addSkinFrame{obj=FriendsFrameBattlenetFrame.BroadcastFrame.ScrollFrame, kfs=true, ofs=4}
	self:addSkinFrame{obj=FriendsFrameBattlenetFrame.BroadcastFrame, ofs=-10}
	self:addSkinFrame{obj=FriendsFrameBattlenetFrame.UnavailableInfoFrame}
	self:skinDropDown{obj=FriendsFrameStatusDropDown}
	FriendsFrameStatusDropDownStatus:SetAlpha(1) -- display status icon
	self:skinEditBox{obj=FriendsFrameBroadcastInput, regs={9, 10}, mi=true, noWidth=true, noHeight=true, noMove=true} -- region 10 is icon
	FriendsFrameBroadcastInputFill:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:skinTabs{obj=FriendsTabHeader, up=true, lod=true, x1=0, y1=-5, x2=0, y2=-5}
	self:addButtonBorder{obj=FriendsTabHeaderSoRButton}

	--	FriendsList Frame
	-- adjust width of FFFSF so it looks right (too thin by default)
	FriendsFrameFriendsScrollFrameScrollBar:SetPoint("BOTTOMLEFT", FriendsFrameFriendsScrollFrame, "BOTTOMRIGHT", -4, 14)
	self:skinScrollBar{obj=FriendsFrameFriendsScrollFrame}

	for i = 1, FRIENDS_FRIENDS_TO_DISPLAY do
		btn = _G["FriendsFrameFriendsScrollFrameButton"..i]
		btn.background:SetAlpha(0)
		self:addButtonBorder{obj=btn, relTo=btn.gameIcon, hide=true, ofs=0}
	end

	-- Friends Tooltip
	self:addSkinFrame{obj=FriendsTooltip}

-->>-- Add Friend Frame
	self:addSkinFrame{obj=AddFriendFrame, kfs=true}
	self:skinEditBox{obj=AddFriendNameEditBox, regs={9}}
	self:addSkinFrame{obj=AddFriendNoteFrame, kfs=true}
	self:skinScrollBar{obj=AddFriendNoteFrameScrollFrame}

-->>-- FriendsFriends Frame
	self:skinDropDown{obj=FriendsFriendsFrameDropDown}
	self:addSkinFrame{obj=FriendsFriendsList, ft=ftype}
	self:skinScrollBar{obj=FriendsFriendsScrollFrame}
	self:addSkinFrame{obj=FriendsFriendsNoteFrame, kfs=true, ft=ftype}
	self:addSkinFrame{obj=FriendsFriendsFrame, ft=ftype}

-->>--	IgnoreList Frame
	self:keepFontStrings(IgnoreListFrame)
	self:skinScrollBar{obj=FriendsFrameIgnoreScrollFrame}

-->>--	PendingList Frame
	self:keepFontStrings(PendingListFrame)
	self:skinDropDown{obj=PendingListFrameDropDown}
	self:skinSlider{obj=FriendsFramePendingScrollFrame.scrollBar}
	for i = 1, PENDING_INVITES_TO_DISPLAY do
		btn = "FriendsFramePendingButton"..i
		self:applySkin{obj=_G[btn]}
		self:applySkin{obj=_G[btn.."AcceptButton"]}
		self:applySkin{obj=_G[btn.."DeclineButton"]}
	end

-->>--	Who Tab Frame
	self:removeInset(WhoFrameListInset)
	self:removeInset(WhoFrameEditBoxInset)
	self:skinDropDown{obj=WhoFrameDropDown, noSkin=true}
	self:moveObject{obj=WhoFrameDropDownButton, x=5, y=1}
	self:skinScrollBar{obj=WhoListScrollFrame}
	self:skinEditBox{obj=WhoFrameEditBox, move=true}
	WhoFrameEditBox:SetWidth(WhoFrameEditBox:GetWidth() +  24)
	self:moveObject{obj=WhoFrameEditBox, x=12}

-->>--	Channel Tab Frame
	self:keepFontStrings(ChannelFrame)
	self:removeInset(ChannelFrameLeftInset)
	self:removeInset(ChannelFrameRightInset)
	self:skinButton{obj=ChannelFrameNewButton}
	-- hook this to skin channel buttons
	self:SecureHook("ChannelList_Update", function()
		for i = 1, MAX_CHANNEL_BUTTONS do
			_G["ChannelButton"..i.."NormalTexture"]:SetAlpha(0)
		end
	end)
	self:skinScrollBar{obj=ChannelListScrollFrame}
	self:skinScrollBar{obj=ChannelRosterScrollFrame}
	-- Channel Pullout Tab & Frame
	self:keepRegions(ChannelPulloutTab, {4, 5}) -- N.B. region 4 is text, 5 is highlight
	self:addSkinFrame{obj=ChannelPulloutTab, ft=ftype}
	self:addSkinFrame{obj=ChannelPullout, ft=ftype}
-->>--	Daughter Frame
	self:skinEditBox{obj=ChannelFrameDaughterFrameChannelName, regs={9}, noWidth=true}
	self:skinEditBox{obj=ChannelFrameDaughterFrameChannelPassword, regs={9, 10}, noWidth=true}
	self:moveObject{obj=ChannelFrameDaughterFrameOkayButton, x=-2}
	self:addSkinFrame{obj=ChannelFrameDaughterFrame, ft=ftype, kfs=true, x1=2, y1=-6, x2=-5}
	self:skinDropDown{obj=ChannelListDropDown}
	self:skinDropDown{obj=ChannelRosterDropDown}

-->>--	Raid Tab Frame
	self:skinButton{obj=RaidFrameConvertToRaidButton}
	self:skinButton{obj=RaidFrameRaidInfoButton}
	if IsAddOnLoaded("Blizzard_RaidUI") then self:RaidUI() end

-->>--	RaidInfo Frame
	self:addSkinFrame{obj=RaidInfoInstanceLabel, kfs=true}
	self:addSkinFrame{obj=RaidInfoIDLabel, kfs=true}
	self:skinSlider{obj=RaidInfoScrollFrame.scrollBar}
	self:addSkinFrame{obj=RaidInfoFrame, ft=ftype, kfs=true, hdr=true}

-->>-- BattleTagInvite Frame
	self:addSkinFrame{obj=BattleTagInviteFrame}

end

function aObj:GhostFrame()
	if not self.db.profile.GhostFrame or self.initialized.GhostFrame then return end
	self.initialized.GhostFrame = true

	self:add2Table(self.pKeys1, "GhostFrame")

	self:addButtonBorder{obj=GhostFrameContentsFrame, relTo=GhostFrameContentsFrameIcon}
	self:addSkinButton{obj=GhostFrame, parent=GhostFrame, kfs=true, sap=true, hide=true}
	GhostFrame:SetFrameStrata("HIGH") -- make it appear above other frames (i.e. Corkboard)

end

function aObj:GlyphUI() -- LoD
	if not self.db.profile.TalentUI or self.initialized.GlyphUI then return end
	self.initialized.GlyphUI = true

	GlyphFrame:DisableDrawLayer("BACKGROUND")
	GlyphFrame.specRing:SetTexture(nil)
	self:removeInset(GlyphFrame.sideInset)
	self:skinEditBox{obj=GlyphFrameSearchBox, regs={9}, mi=true, noHeight=true, noMove=true}
	self:skinDropDown{obj=GlyphFrameFilterDropDown}
	-- Headers
	for i = 1, #GLYPH_STRING do
		self:removeRegions(_G["GlyphFrameHeader"..i], {1, 2, 3})
		self:applySkin{obj=_G["GlyphFrameHeader"..i], ft=ftype, nb=true} -- use applySkin so text is seen
	end
	-- remove Glyph item textures
	for i = 1, #GlyphFrame.scrollFrame.buttons do
		btn = GlyphFrame.scrollFrame.buttons[i]
		btn:GetNormalTexture():SetAlpha(0)
		btn.selectedTex:SetAlpha(0)
		btn.disabledBG:SetAlpha(0)
		self:addButtonBorder{obj=btn, relTo=btn.icon}
	end
	self:skinSlider{obj=GlyphFrameScrollFrameScrollBar, adj=-4}
	self:addButtonBorder{obj=GlyphFrameClearInfoFrame}

end

function aObj:GuildControlUI() -- LoD
	if not self.db.profile.GuildControlUI or self.initialized.GuildControlUI then return end
	self.initialized.GuildControlUI = true

	GuildControlUI:DisableDrawLayer("BACKGROUND")
	GuildControlUIHbar:SetAlpha(0)
	self:skinDropDown{obj=GuildControlUI.dropdown}
	self:addSkinFrame{obj=GuildControlUI, ft=ftype, kfs=true, x1=10, y1=-10, x2=-10, y2=10}
	-- Guild Ranks Panel
	local function skinROFrames()

		local obj
		for i = 1, MAX_GUILDRANKS do
			obj = _G["GuildControlUIRankOrderFrameRank"..i]
			if obj and not aObj.skinned[obj] then
				aObj:skinEditBox{obj=obj.nameBox, regs={9}, x=-5}
				self:addButtonBorder{obj=obj.downButton, ofs=0}
				self:addButtonBorder{obj=obj.upButton, ofs=0}
				self:addButtonBorder{obj=obj.deleteButton, ofs=0}
			end
		end

	end
	self:SecureHook("GuildControlUI_RankOrder_Update", function(...)
		skinROFrames()
	end)
	skinROFrames()
	-- Rank Permissions Panel
	GuildControlUI.rankPermFrame:DisableDrawLayer("BACKGROUND")
	self:skinDropDown{obj=GuildControlUI.rankPermFrame.dropdown}
	self:skinEditBox{obj=GuildControlUI.rankPermFrame.goldBox, regs={9}}
	-- Bank Tab Permissions panel
	self:keepFontStrings(GuildControlUI.bankTabFrame.scrollFrame)
	self:skinSlider{obj=GuildControlUIRankBankFrameInsetScrollFrameScrollBar}
	self:skinDropDown{obj=GuildControlUI.bankTabFrame.dropdown}
	GuildControlUI.bankTabFrame.inset:DisableDrawLayer("BACKGROUND")
	GuildControlUI.bankTabFrame.inset:DisableDrawLayer("BORDER")
	-- hook this as buttons are created as required
	self:SecureHook("GuildControlUI_BankTabPermissions_Update", function(this)
		-- self:Debug("GuildControlUI_BankTabPermissions_Update: [%s]", this)
		for i = 1, MAX_BUY_GUILDBANK_TABS do
			btn = _G["GuildControlBankTab"..i]
			if btn and not self.skinned[btn] then
				btn:DisableDrawLayer("BACKGROUND")
				self:skinEditBox{obj=btn.owned.editBox, regs={9}}
				self:skinButton{obj=btn.buy.button, as=true}
				self:addButtonBorder{obj=btn.owned, relTo=btn.owned.tabIcon}
			end
		end
	end)

end

function aObj:GuildUI() -- LoD
	if not self.db.profile.GuildUI or self.initialized.GuildUI then return end
	self.initialized.GuildUI = true

-->>-- Guild Frame
	self:removeInset(GuildFrameBottomInset)
	self:skinDropDown{obj=GuildDropDown}
	GuildLevelFrame:DisableDrawLayer("BACKGROUND")
	-- XP Bar
	GuildXPBar:DisableDrawLayer("BORDER")
	GuildXPBarProgress:SetTexture(self.sbTexture)
	GuildXPBarShadow:SetAlpha(0)
	GuildXPBarCap:SetTexture(self.sbTexture)
	GuildXPBarCapMarker:SetAlpha(0)
	-- Faction Bar
	GuildFactionBar:DisableDrawLayer("BORDER")
	GuildFactionBarProgress:SetTexture(self.sbTexture)
	GuildFactionBarShadow:SetAlpha(0)
	GuildFactionBarCap:SetTexture(self.sbTexture)
	GuildFactionBarCapMarker:SetAlpha(0)
	self:keepRegions(GuildFrame, {8, 19, 20, 18, 21, 22}) -- regions 8, 19, 20 are text, 18, 21 & 22 are tabard
	self:moveObject{obj=GuildFrameTabardBackground, x=8, y=-11}
	self:moveObject{obj=GuildFrameTabardEmblem, x=9, y=-12}
	self:moveObject{obj=GuildFrameTabardBorder, x=7, y=-10}
	self:skinTabs{obj=GuildFrame, lod=true}
	self:addSkinFrame{obj=GuildFrame, ft=ftype, ri=true, x1=-3, y1=2, x2=1, y2=-5}
	self:removeMagicBtnTex(GuildAddMemberButton)
	self:removeMagicBtnTex(GuildControlButton)
	self:removeMagicBtnTex(GuildViewLogButton)
	-- GuildMain Frame
	GuildPerksToggleButton:DisableDrawLayer("BACKGROUND")
	GuildNewPerksFrame:DisableDrawLayer("BACKGROUND")
	GuildUpdatesNoNews:SetTextColor(self.BTr, self.BTg, self.BTb)
	GuildUpdatesDivider:SetAlpha(0)
	GuildUpdatesNoEvents:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:removeRegions(GuildLatestPerkButton, {2, 5, 6}) -- region 2 is NameFrame, 5-6 are borders
	self:addButtonBorder{obj=GuildLatestPerkButton, libt=true}
	GuildNextPerkButtonNameFrame:SetTexture(nil)
	self:addButtonBorder{obj=GuildNextPerkButton, libt=true, reParent={GuildNextPerkButtonLockTexture}}
	GuildAllPerksFrame:DisableDrawLayer("BACKGROUND")
	self:skinSlider{obj=GuildPerksContainer.ScrollBar, adj=-6}
	for i = 1, #GuildPerksContainer.buttons do
		-- can't use DisableDrawLayer as the update code uses it
		btn = GuildPerksContainer.buttons[i]
		self:removeRegions(btn, {1, 2, 3, 4, 5, 6})
		self:addButtonBorder{obj=btn, relTo=btn.icon, reParent={btn.lock}}
	end
	self:skinEditBox{obj=GuildNameChangeFrame.editBox, regs={9}}

-->>-- GuildRoster Frame
	self:skinDropDown{obj=GuildRosterViewDropdown}
	self:skinSlider{obj=GuildRosterContainerScrollBar, adj=-4}
	for i = 1, #GuildRosterContainer.buttons do
		btn = GuildRosterContainer.buttons[i]
		btn:DisableDrawLayer("BACKGROUND")
		btn.barTexture:SetTexture(self.sbTexture)
		btn.header.leftEdge:SetAlpha(0)
		btn.header.rightEdge:SetAlpha(0)
		btn.header.middle:SetAlpha(0)
		self:applySkin{obj=btn.header}
		self:addButtonBorder{obj=btn, relTo=btn.icon, hide=true, es=12}
	end
	self:skinDropDown{obj=GuildMemberRankDropdown}
	-- adjust text position & font so it overlays correctly
	self:moveObject{obj=GuildMemberRankDropdown, x=-6, y=2}
	GuildMemberRankDropdownText:SetFontObject(GameFontHighlight)
	self:addSkinFrame{obj=GuildMemberNoteBackground, ft=ftype}
	self:addSkinFrame{obj=GuildMemberOfficerNoteBackground, ft=ftype}
	self:addSkinFrame{obj=GuildMemberDetailFrame, ft=ftype, kfs=true, nb=true, ofs=-6}

-->>-- GuildNews Frame
	GuildNewsFrame:DisableDrawLayer("BACKGROUND")
	self:skinSlider{obj=GuildNewsContainerScrollBar, adj=-6}
	for i = 1, #GuildNewsContainer.buttons do
		GuildNewsContainer.buttons[i].header:SetAlpha(0)
	end
	self:skinDropDown{obj=GuildNewsDropDown}
	self:addSkinFrame{obj=GuildNewsFiltersFrame, ft=ftype, kfs=true, ofs=-7}
	self:keepFontStrings(GuildNewsBossModelTextFrame)
	self:addSkinFrame{obj=GuildNewsBossModel, ft=ftype, kfs=true, ofs=4, y2=-81} -- similar to QuestNPCModel
	-- Rewards Panel
	GuildRewardsFrame:DisableDrawLayer("BACKGROUND")
	self:skinSlider{obj=GuildRewardsContainerScrollBar, adj=-4}
	for i = 1, #GuildRewardsContainer.buttons do
		btn = GuildRewardsContainer.buttons[i]
		btn:GetNormalTexture():SetAlpha(0)
		btn.disabledBG:SetAlpha(0)
		self:addButtonBorder{obj=btn, relTo=btn.icon, reParent={btn.lock}}
	end
	self:skinDropDown{obj=GuildRewardsDropDown}

-->>-- GuildInfo Frame
	self:removeRegions(GuildInfoFrame, {1, 2, 3, 4, 5, 6 ,7, 8}) -- Background textures and bars
	self:skinTabs{obj=GuildInfoFrame, up=true, lod=true, x1=2, y1=-5, x2=2, y2=-5}
	-- GuildInfoFrameInfo Frame
	self:keepFontStrings(GuildInfoFrameInfo)
	self:skinSlider{obj=GuildInfoDetailsFrameScrollBar, adj=-4}
	-- GuildInfoFrameRecruitment Frame
	GuildRecruitmentInterestFrameBg:SetAlpha(0)
	GuildRecruitmentAvailabilityFrameBg:SetAlpha(0)
	GuildRecruitmentRolesFrameBg:SetAlpha(0)
	GuildRecruitmentLevelFrameBg:SetAlpha(0)
	GuildRecruitmentCommentFrameBg:SetAlpha(0)
	self:skinSlider{obj=GuildRecruitmentCommentInputFrameScrollFrame.ScrollBar}
	GuildRecruitmentCommentEditBoxFill:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:addSkinFrame{obj=GuildRecruitmentCommentInputFrame, ft=ftype, kfs=true}
	self:removeMagicBtnTex(GuildRecruitmentListGuildButton)
	-- GuildInfoFrameApplicants Frame
	for i = 1, #GuildInfoFrameApplicantsContainer.buttons do
		btn = GuildInfoFrameApplicantsContainer.buttons[i]
		self:applySkin{obj=btn}
		btn.ring:SetAlpha(0)
		btn.PointsSpentBgGold:SetAlpha(0)
		self:moveObject{obj=btn.PointsSpentBgGold, x=6, y=-6}
	end
	self:skinSlider{obj=GuildInfoFrameApplicantsContainerScrollBar, adj=-4}
	self:removeMagicBtnTex(GuildRecruitmentInviteButton)
	self:removeMagicBtnTex(GuildRecruitmentDeclineButton)
	self:removeMagicBtnTex(GuildRecruitmentMessageButton)
	-- Guild Text Edit frame
	self:skinSlider{obj=GuildTextEditScrollFrameScrollBar, adj=-6}
	self:addSkinFrame{obj=GuildTextEditContainer, ft=ftype, nb=true}
	self:addSkinFrame{obj=GuildTextEditFrame, ft=ftype, kfs=true, nb=true, ofs=-7}
	-- Guild Log Frame
	self:skinSlider{obj=GuildLogScrollFrame.ScrollBar, adj=-6}
	self:addSkinFrame{obj=GuildLogContainer, ft=ftype, nb=true}
	self:addSkinFrame{obj=GuildLogFrame, ft=ftype, kfs=true, nb=true, ofs=-7}

end

function aObj:GuildInvite()
	if not self.db.profile.GuildInvite or self.initialized.GuildInvite then return end
	self.initialized.GuildInvite = true

	self:add2Table(self.pKeys1, "GuildInvite")

	self:keepFontStrings(GuildInviteFrameLevel)
	GuildInviteFrame:DisableDrawLayer("BACKGROUND")
	GuildInviteFrame:DisableDrawLayer("BORDER")
	GuildInviteFrameTabardBorder:SetTexture(nil)
	GuildInviteFrame:DisableDrawLayer("OVERLAY")
	self:addSkinFrame{obj=GuildInviteFrame, ft=ftype}

end

function aObj:InspectUI() -- LoD
	if not self.db.profile.InspectUI or self.initialized.InspectUI then return end
	self.initialized.InspectUI = true

	self:skinTabs{obj=InspectFrame, lod=true}
	self:addSkinFrame{obj=InspectFrame, ft=ftype, kfs=true, ri=true, y1=2, x2=1, y2=-5}

-->>-- Inspect PaperDoll frame
	-- Inspect Model Frame
	InspectModelFrame.controlFrame:DisableDrawLayer("BACKGROUND")
	for _, child in ipairs{InspectPaperDollItemsFrame:GetChildren()} do
		child:DisableDrawLayer("BACKGROUND")
		if self.modBtnBs then
			-- add button borders
			if child:IsObjectType("Button") and child:GetName():find("Slot") then
				self:addButtonBorder{obj=child, ibt=true}
			end
		end
	end
	InspectModelFrame:DisableDrawLayer("BACKGROUND")
	InspectModelFrame:DisableDrawLayer("BORDER")
	InspectModelFrame:DisableDrawLayer("OVERLAY")

-->>--	PVP Frame
	self:keepFontStrings(InspectPVPFrame)
	for i = 1, MAX_ARENA_TEAMS do
		_G["InspectPVPTeam"..i.."StandardBar"]:Hide()
		self:addSkinFrame{obj=_G["InspectPVPTeam"..i], hat=true, x1=-40, y1=4, x2=-20}
	end

-->>--	Talent Frame
	self:keepFontStrings(InspectTalentFrame)
	-- Specialization
	InspectTalentFrame.InspectSpec.ring:SetTexture(nil)
	-- Talents
	for i = 1, 6 do
		for j = 1, 3 do
			btn = InspectTalentFrame.InspectTalents["tier"..i]["talent"..j]
			btn.border:SetTexture(nil)
			self:addButtonBorder{obj=btn, relTo=btn.icon}
		end
	end
	-- Glyphs
	for i = 1, 6 do
		InspectTalentFrame.InspectGlyphs["Glyph"..i].ring:SetTexture(nil)
	end

-->>-- Guild Frame
	InspectGuildFrameBG:SetAlpha(0)

	-- send message when UI is skinned (used by oGlow skin)
	self:SendMessage("InspectUI_Skinned", self)

end

function aObj:ItemSocketingUI() -- LoD
	if not self.db.profile.ItemSocketingUI or self.initialized.ItemSocketingUI then return end
	self.initialized.ItemSocketingUI = true

	local colour
	local function colourSockets()

		for i = 1, GetNumSockets() do
			colour = GEM_TYPE_INFO[GetSocketTypes(i)]
			self.sBtn[_G["ItemSocketingSocket"..i]]:SetBackdropBorderColor(colour.r, colour.g, colour.b)
		end

	end
	-- hook this to colour the button border
	self:SecureHook("ItemSocketingFrame_Update", function()
		colourSockets()
	end)

	self:addSkinFrame{obj=ItemSocketingFrame, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-2}
	self:skinScrollBar{obj=ItemSocketingScrollFrame}

	for i = 1, MAX_NUM_SOCKETS do
		objName = "ItemSocketingSocket"..i
		obj = _G[objName]
		_G[objName.."Left"]:SetAlpha(0)
		_G[objName.."Right"]:SetAlpha(0)
		self:getRegion(obj, 3):SetAlpha(0) -- button texture
		self:addSkinButton{obj=obj}
	end
	-- now colour the sockets
	colourSockets()

end

function aObj:LookingForGuildUI() -- LoD
	if not self.db.profile.LookingForGuildUI or self.initialized.LookingForGuildUI then return end
	self.initialized.LookingForGuildUI = true

	self:skinTabs{obj=LookingForGuildFrame, up=true, lod=true, x1=0, y1=-5, x2=3, y2=-5}
	self:addSkinFrame{obj=LookingForGuildFrame, ft=ftype, kfs=true, ri=true, y1=2, x2=1}

	-- Start Frame (Settings)
	LookingForGuildInterestFrameBg:SetAlpha(0)
	LookingForGuildAvailabilityFrameBg:SetAlpha(0)
	LookingForGuildRolesFrameBg:SetAlpha(0)
	LookingForGuildCommentFrameBg:SetAlpha(0)
	self:skinScrollBar{obj=LookingForGuildCommentInputFrameScrollFrame}
	self:addSkinFrame{obj=LookingForGuildCommentInputFrame, ft=ftype, kfs=true, ofs=-1}
	LookingForGuildCommentEditBoxFill:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:removeMagicBtnTex(LookingForGuildBrowseButton)

	-- Browse Frame
	self:skinSlider{obj=LookingForGuildBrowseFrameContainerScrollBar, adj=-4}
	for i = 1, #LookingForGuildBrowseFrameContainer.buttons do
		btn = LookingForGuildBrowseFrameContainer.buttons[i]
		self:applySkin{obj=btn}
		_G[btn:GetName().."Ring"]:SetAlpha(0)
		btn.PointsSpentBgGold:SetAlpha(0)
		self:moveObject{obj=btn.PointsSpentBgGold, x=6, y=-6}
	end
	self:removeMagicBtnTex(LookingForGuildRequestButton)

	-- Apps Frame (Requests)
	self:skinSlider{obj=LookingForGuildAppsFrameContainerScrollBar}
	for i = 1, #LookingForGuildAppsFrameContainer.buttons do
		btn = LookingForGuildAppsFrameContainer.buttons[i]
		self:applySkin{obj=btn}
	end

	-- Request Membership Frame
	GuildFinderRequestMembershipEditBoxFill:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:addSkinFrame{obj=GuildFinderRequestMembershipFrameInputFrame, ft=ftype}
	self:addSkinFrame{obj=GuildFinderRequestMembershipFrame, ft=ftype}

end

function aObj:LootFrames()
	if not self.db.profile.LootFrames.skin or self.initialized.LootFrames then return end
	self.initialized.LootFrames = true

	self:add2Table(self.pKeys2, "LootFrames")

	-- Add another loot button and move them all up to fit
	local yOfs = -27
	for i = 1, LOOTFRAME_NUMBUTTONS do
		btn = _G["LootButton"..i]
		btn:ClearAllPoints()
		btn:SetPoint("TOPLEFT", 9, yOfs)
		yOfs = yOfs - 41
	end
	CreateFrame("Button", "LootButton5", LootFrame, "LootButtonTemplate")
	LootButton5:SetPoint("TOPLEFT", 9, yOfs)
	LootButton5.id = 5
	LOOTFRAME_NUMBUTTONS = LOOTFRAME_NUMBUTTONS + 1

	for i = 1, LOOTFRAME_NUMBUTTONS do
		_G["LootButton"..i.."NameFrame"]:SetTexture(nil)
		self:addButtonBorder{obj=_G["LootButton"..i], ibt=true}
	end
	self:addSkinFrame{obj=LootFrame, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-2}
	self:addButtonBorder{obj=LootFrameDownButton, ofs=-2}
	self:addButtonBorder{obj=LootFrameUpButton, ofs=-2}

-->>-- BonusRoll Frame
	self:removeRegions(BonusRollFrame, {1, 2, 3, 4})
	self:glazeStatusBar(BonusRollFrame.PromptFrame.Timer, 0,  nil)
-->>-- BonusRollLootWon Frame
	BonusRollLootWonFrame.Background:SetTexture(nil)
	BonusRollLootWonFrame.IconBorder:SetTexture(nil)
	self:ScheduleTimer("addButtonBorder", 0.2, {obj=BonusRollLootWonFrame, relTo=BonusRollLootWonFrame.Icon}) -- wait for animation to finish
	self:addSkinFrame{obj=BonusRollLootWonFrame, ft=ftype, anim=true, ofs=-10}
-->>-- BonusRollMoneyWon Frame
	BonusRollMoneyWonFrame.Background:SetTexture(nil)
	BonusRollMoneyWonFrame.IconBorder:SetTexture(nil)
	self:ScheduleTimer("addButtonBorder", 0.2, {obj=BonusRollMoneyWonFrame, relTo=BonusRollMoneyWonFrame.Icon}) -- wait for animation to finish
	self:addSkinFrame{obj=BonusRollMoneyWonFrame, ft=ftype, anim=true, ofs=-10}
-->>-- MasterLooter Frame
	MasterLooterFrame.Item.NameBorderLeft:SetTexture(nil)
	MasterLooterFrame.Item.NameBorderRight:SetTexture(nil)
	MasterLooterFrame.Item.NameBorderMid:SetTexture(nil)
	MasterLooterFrame.Item.IconBorder:SetTexture(nil)
	self:addButtonBorder{obj=MasterLooterFrame, relTo=MasterLooterFrame.Icon}
	MasterLooterFrame.player1.Bg:SetTexture(nil)
	self:addSkinFrame{obj=MasterLooterFrame, ft=ftype, kfs=true, nb=true}
	self:skinButton{obj=self:getChild(MasterLooterFrame, 3), cb=true}

-->>-- MissingLoot frame
	self:addSkinFrame{obj=MissingLootFrame, ft=ftype, kfs=true, x1=0, y1=-4, x2=-4, y2=-5}
	for i = 1, MissingLootFrame.numShownItems do
		_G["MissingLootFrameItem"..index.."NameFrame"]:SetAlpha(0)
		if self.modBtnBs then
			self:addButtonBorder{obj=_G["MissingLootFrameItem"..index], ibt=true}
		end
	end

-->>-- GroupLoot frames
	for i = 1, NUM_GROUP_LOOT_FRAMES do

		objName = "GroupLootFrame"..i
		obj = _G[objName]
		self:keepFontStrings(obj)
		obj.Timer.Background:SetAlpha(0)
		self:glazeStatusBar(obj.Timer, 0,  nil)
			-- hook this to skin the group loot frame
		self:SecureHook(obj, "Show", function(this)
			this:SetBackdrop(nil)
		end)

		if self.db.profile.LootFrames.size == 1 then

			self:addSkinFrame{obj=obj, ft=ftype}--, x1=4, y1=-5, x2=-4, y2=5}

		elseif self.db.profile.LootFrames.size == 2 then

			obj:SetScale(0.75)
			self:addSkinFrame{obj=obj, ft=ftype}--, x1=4, y1=-5, x2=-4, y2=5}

		elseif self.db.profile.LootFrames.size == 3 then

			obj:SetScale(0.75)
			self:moveObject{obj=_G[objName.."SlotTexture"], x=95, y=4} -- Loot item icon
			_G[objName.."Name"]:SetAlpha(0)
			_G[objName.."RollButton"]:ClearAllPoints()
			_G[objName.."RollButton"]:SetPoint("RIGHT", _G[objName.."PassButton"], "LEFT", 5, -5)
			_G[objName.."GreedButton"]:ClearAllPoints()
			_G[objName.."GreedButton"]:SetPoint("RIGHT", _G[objName.."RollButton"], "LEFT", 0, 0)
			_G[objName.."DisenchantButton"]:ClearAllPoints()
			_G[objName.."DisenchantButton"]:SetPoint("RIGHT", _G[objName.."GreedButton"], "LEFT", 0, 0)
			self:adjWidth{obj=_G[objName.."Timer"], adj=-28}
			self:moveObject{obj=_G[objName.."Timer"], x=-3}
			self:addSkinFrame{obj=obj, ft=ftype, x1=102, y1=-5, x2=-4, y2=16}

		end

	end

end

function aObj:LootHistory()
	if not self.db.profile.LootHistory or self.initialized.LootHistory then return end
	self.initialized.LootHistory = true

	self:add2Table(self.pKeys1, "LootHistory")

	self:skinScrollBar{obj=LootHistoryFrame.ScrollFrame}
	LootHistoryFrame.ScrollFrame.ScrollBarBackground:SetTexture(nil)
	LootHistoryFrame.Divider:SetTexture(nil)
	self:addSkinFrame{obj=LootHistoryFrame, ft=ftype, kfs=true}
	-- hook this to skin loot history items
	self:SecureHook("LootHistoryFrame_FullUpdate", function(this)
		for i = 1, #this.itemFrames do
			local item = this.itemFrames[i]
			item.Divider:SetTexture(nil)
			item.NameBorderLeft:SetTexture(nil)
			item.NameBorderRight:SetTexture(nil)
			item.NameBorderMid:SetTexture(nil)
			self:skinButton{obj=item.ToggleButton, mp=true}
		end
	end)

	-- LootHistoryDropDown
	self:skinDropDown{obj=LootHistoryDropDown}

end

function aObj:MirrorTimers()
	if not self.db.profile.MirrorTimers.skin or self.initialized.MirrorTimers then return end
	self.initialized.MirrorTimers = true

	self:add2Table(self.pKeys2, "MirrorTimers")

	local objBG, objSB
	for i = 1, MIRRORTIMER_NUMTIMERS do
		objName = "MirrorTimer"..i
		obj = _G[objName]
		objBG = self:getRegion(obj, 1)
		objSB = _G[objName.."StatusBar"]
		self:removeRegions(obj, {3})
		obj:SetHeight(obj:GetHeight() * 1.25)
		self:moveObject{obj=_G[objName.."Text"], y=-2}
		objBG:SetWidth(objBG:GetWidth() * 0.75)
		objSB:SetWidth(objSB:GetWidth() * 0.75)
		if self.db.profile.MirrorTimers.glaze then
			self:glazeStatusBar(objSB, 0, objBG)
		end
	end

	-- Battleground/Arena Start Timer (4.1)
	local function skinTT(tT)

		-- aObj:Debug("skinTT: [%s, %s]", tT, #tT.timerList)
		for _, timer in pairs(tT.timerList) do
			-- aObj:Debug("skinTT#2: [%s]", timer)
			if not aObj.sbGlazed[timer.bar] then
				local bg = aObj:getRegion(timer.bar, 1)
				_G[timer.bar:GetName().."Border"]:SetTexture(nil) -- animations
				aObj:glazeStatusBar(timer.bar, 0, bg)
				aObj:moveObject{obj=bg, y=2} -- align bars
			end
		end

	end
	self:SecureHookScript(TimerTracker, "OnEvent", function(this, event, ...)
		-- self:Debug("TT_OE: [%s, %s]", this, event)
		if event == "START_TIMER" then
			skinTT(this)
		end
	end)
	-- skin existing timers
	skinTT(TimerTracker)

end

function aObj:OverrideActionBar()

	self:add2Table(self.pKeys1, "OverrideActionBar")

	local xOfs1, xOfs2, yOfs1, yOfs2, sf, oabW
	local function skinOverrideActionBar(opts)

		oabW = OverrideActionBar:GetWidth()
		aObj:Debug("sOAB: [%s, %s, %s]", opts.src, opts.st or "nil", oabW)

		xOfs1 = 144
		-- adjust skin width dependant upon frame width
		if oabW == 860 then -- no exit or pitch buttons
			-- xOfs1 = 144
		elseif oabW == 930 then -- exit but no pitch buttons
			-- xOfs1 = 144
		elseif oabW == 945 then -- pitch but no exit button
			-- xOfs1 = 144
		elseif oabW == 1020 then -- exit & pitch buttons
			-- xOfs1 = 98
		end
		yOfs1 = 6
		yOfs2 = -2
		xOfs2 = (xOfs1 * -1) + 2

		-- remove all textures
		OverrideActionBar:DisableDrawLayer("OVERLAY")
		OverrideActionBar:DisableDrawLayer("BACKGROUND")
		OverrideActionBar:DisableDrawLayer("BORDER")

		-- PitchFrame
		OverrideActionBar.pitchFrame.Divider1:SetTexture(nil)
		OverrideActionBar.pitchFrame.PitchOverlay:SetTexture(nil)
		OverrideActionBar.pitchFrame.PitchButtonBG:SetTexture(nil)

		-- LeaveFrame
		OverrideActionBar.leaveFrame.Divider3:SetTexture(nil)
		OverrideActionBar.leaveFrame.ExitBG:SetTexture(nil)

		-- ExpBar
		OverrideActionBar.xpBar.XpMid:SetTexture(nil)
		OverrideActionBar.xpBar.XpL:SetTexture(nil)
		OverrideActionBar.xpBar.XpR:SetTexture(nil)
		for i = 1, 19 do
			OverrideActionBar.xpBar["XpDiv"..i]:SetTexture(nil)
		end
		aObj:glazeStatusBar(OverrideActionBar.xpBar, 0,  self:getRegion(OverrideActionBar.xpBar, 1))

		if sf then
			sf:ClearAllPoints()
			sf:SetPoint("TOPLEFT", OverrideActionBar, "TOPLEFT", xOfs1, yOfs1)
			sf:SetPoint("BOTTOMRIGHT", OverrideActionBar, "BOTTOMRIGHT", xOfs2, yOfs2)
		else
			sf = aObj:addSkinFrame{obj=OverrideActionBar, ft=ftype, x1=xOfs1, y1=yOfs1, x2=xOfs2, y2=yOfs2}
		end

	end

	self:SecureHook(OverrideActionBar, "Show", function(this, ...)
		skinOverrideActionBar{src=1}
	end)
	self:SecureHook("OverrideActionBar_SetSkin", function(skin)
		skinOverrideActionBar{src=2, st=skin}
	end)

	if OverrideActionBar:IsShown() then skinOverrideActionBar{src=3} end

	if self.modBtnBs then
		self:addButtonBorder{obj=OverrideActionBar.leaveFrame.LeaveButton}
		for i = 1, 6 do
			self:addButtonBorder{obj=OverrideActionBar["SpellButton"..i], abt=true, sec=true, es=20}
		end
	end

end

function aObj:PetJournal() -- LoD
	if not self.db.profile.PetJournal or self.initialized.PetJournal then return end
	self.initialized.PetJournal = true

	self:addSkinFrame{obj=PetJournalParent, ft=ftype, kfs=true, x1=-3, y1=2, x2=1, y2=-5}
	self:skinTabs{obj=PetJournalParent, lod=true}

	-- MountJournal
	self:removeInset(MountJournal.LeftInset)
	self:removeInset(MountJournal.RightInset)
	self:removeInset(MountJournal.MountCount)
	self:keepFontStrings(MountJournal.MountDisplay)
	self:keepFontStrings(MountJournal.MountDisplay.ShadowOverlay)
	self:makeMFRotatable(MountJournal.MountDisplay.ModelFrame)
	self:skinSlider{obj=MountJournal.ListScrollFrame.scrollBar, adj=-4}
	self:removeMagicBtnTex(MountJournalMountButton)
	for i = 1, #MountJournal.ListScrollFrame.buttons do
		btn = MountJournal.ListScrollFrame.buttons[i]
		self:addButtonBorder{obj=btn, relTo=btn.icon}
		btn:DisableDrawLayer("BACKGROUND")
	end

	-- PetJournal
	self:removeInset(PetJournal.PetCount)
	PetJournal.MainHelpButton.Ring:SetTexture(nil)
	self:moveObject{obj=PetJournal.MainHelpButton, y=-4}
	self:addButtonBorder{obj=PetJournal.HealPetButton, sec=true}
	PetJournalHealPetButtonBorder:SetTexture(nil)
	self:removeInset(PetJournal.LeftInset)
	self:removeInset(PetJournal.RightInset)
	self:skinEditBox{obj=PetJournal.searchBox, regs={9}, mi=true}
	self:skinButton{obj=PetJournalFilterButton}
	self:skinDropDown{obj=PetJournalFilterDropDown}
	self:skinSlider{obj=PetJournal.listScroll.scrollBar, adj=-4}
	self:removeMagicBtnTex(PetJournal.FindBattleButton)
	self:removeMagicBtnTex(PetJournal.SummonButton)
	self:skinDropDown{obj=PetJournal.petOptionsMenu}
	for i = 1, #PetJournal.listScroll.buttons do
		btn = PetJournal.listScroll.buttons[i]
		self:addButtonBorder{obj=btn, relTo=btn.icon, reParent={btn.dragButton.levelBG, btn.dragButton.level}}
		self:removeRegions(btn, {1, 3})
		self:changeTandC(btn.dragButton.levelBG, self.lvlBG)
	end
	self:removeRegions(PetJournal.AchievementStatus, {1})
	self:keepFontStrings(PetJournal.loadoutBorder)
	self:moveObject{obj=PetJournal.loadoutBorder, y=8} -- battle pet slots title
	-- Battle Pet Slots
	for i = 1, 3 do
		obj	= PetJournal.Loadout["Pet"..i]
		self:removeRegions(obj, {1, 2, 5})
		self:addButtonBorder{obj=obj, relTo=obj.icon, reParent={obj.levelBG, obj.level}}
		obj.petTypeIcon:SetAlpha(0) -- N.B. texture is changed in code
		self:changeTandC(obj.levelBG, self.lvlBG)
		self:keepFontStrings(obj.helpFrame)
		obj.healthFrame.healthBar:DisableDrawLayer("OVERLAY")
		self:glazeStatusBar(obj.healthFrame.healthBar, 0,  nil)
		self:removeRegions(obj.xpBar, {2, 3, 4, 5, 6, 7, 8, 9, 10, 11})
		self:glazeStatusBar(obj.xpBar, 0,  nil)
		self:makeMFRotatable(obj.model)
		self:addButtonBorder{obj=obj, ofs=1}
		for i = 1, 3 do
			btn = obj["spell"..i]
			self:removeRegions(btn, {1, 3}) -- background, blackcover
			self:addButtonBorder{obj=btn, relTo=btn.icon, reParent={btn.FlyoutArrow}}
		end
	end
	-- PetCard
	self:removeInset(PetJournal.PetCardInset)
	obj = PetJournal.PetCard
	self:addButtonBorder{obj=obj.PetInfo, relTo=obj.PetInfo.icon, reParent={obj.PetInfo.levelBG, obj.PetInfo.level}}
	self:changeTandC(obj.PetInfo.levelBG, self.lvlBG)
	self:removeRegions(obj.HealthFrame.healthBar, {1, 2, 3})
	self:glazeStatusBar(obj.HealthFrame.healthBar, 0,  nil)
	self:removeRegions(obj.xpBar, {2, 3, 4, 5, 6, 7, 8, 9, 10, 11})
	self:glazeStatusBar(obj.xpBar, 0,  nil)
	self:makeMFRotatable(obj.model)
	self:keepFontStrings(obj)
	self:addButtonBorder{obj=obj}
	-- spell buttons
	for i = 1, 6 do
		btn = obj["spell"..i]
		btn.BlackCover:SetAlpha(0) -- N.B. texture is changed in code
		self:addButtonBorder{obj=btn, relTo=btn.icon}
	end
	-- Tooltips
	if self.db.profile.Tooltips.skin then
		PetJournalPrimaryAbilityTooltip.Delimiter2:SetTexture(nil)
		self:addSkinFrame{obj=PetJournalPrimaryAbilityTooltip, ft=ftype}
		PetJournalSecondaryAbilityTooltip.Delimiter1:SetTexture(nil)
		PetJournalSecondaryAbilityTooltip.Delimiter2:SetTexture(nil)
		self:addSkinFrame{obj=PetJournalSecondaryAbilityTooltip, ft=ftype}
	end

end

function aObj:PVPFrame()
	if not self.db.profile.PVPFrame or self.initialized.PVPFrame then return end
	self.initialized.PVPFrame = true

	self:add2Table(self.pKeys1, "PVPFrame")

	self:removeInset(PVPFrame.topInset)
	local bar = PVPFrameConquestBar
	bar.progress:SetTexture(self.sbTexture)
	bar.cap1:SetTexture(self.sbTexture)
	bar.cap2:SetTexture(self.sbTexture)
	bar:DisableDrawLayer("BORDER")
	self:skinTabs{obj=PVPFrame}
	self:addSkinFrame{obj=PVPFrame, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-5}
	self:removeMagicBtnTex(PVPFrameLeftButton)
	self:removeMagicBtnTex(PVPFrameRightButton)
-->>-- Honor frame
	self:keepFontStrings(PVPFrame.panel1)
	self:skinScrollBar{obj=PVPFrame.panel1.bgTypeScrollFrame}
	self:skinSlider{obj=PVPHonorFrameInfoScrollFrameScrollBar}
	PVPHonorFrameInfoScrollFrameChildFrameDescription:SetTextColor(self.BTr, self.BTg, self.BTb)
	PVPHonorFrameInfoScrollFrameChildFrameRewardsInfo.description:SetTextColor(self.BTr, self.BTg, self.BTb)
	PVPHonorFrameInfoScrollFrameChildFrameRewardsInfo.winReward:DisableDrawLayer("BACKGROUND")
	PVPHonorFrameInfoScrollFrameChildFrameRewardsInfo.lossReward:DisableDrawLayer("BACKGROUND")
-->>-- Conquest frame
	self:keepFontStrings(PVPFrame.panel2)
	PVPFrame.panel2.winReward:DisableDrawLayer("BACKGROUND")
	PVPFrame.panel2.infoButton:DisableDrawLayer("BORDER")
-->>-- Team Management frame a.k.a. Arena
	self:keepFontStrings(PVPFrame.panel3)
	self:keepFontStrings(PVPTeamManagementFrameWeeklyDisplay)
	self:skinUsingBD{obj=PVPTeamManagementFrameWeeklyDisplay}
	PVPFrame.panel3.flag2.NormalHeader:SetTexture(nil)
	PVPFrame.panel3.flag2.GlowHeader:SetTexture(nil)
	PVPFrame.panel3.flag3.NormalHeader:SetTexture(nil)
	PVPFrame.panel3.flag3.GlowHeader:SetTexture(nil)
	PVPFrame.panel3.flag5.NormalHeader:SetTexture(nil)
	PVPFrame.panel3.flag5.GlowHeader:SetTexture(nil)
	self:skinScrollBar{obj=PVPFrame.panel3.teamMemberScrollFrame}
	self:skinDropDown{obj=PVPTeamManagementFrameTeamDropDown}
	self:addButtonBorder{obj=PVPTeamManagementFrame.weeklyToggleRight, ofs=-2}
	self:addButtonBorder{obj=PVPTeamManagementFrame.weeklyToggleLeft, ofs=-2}
-->>-- WarGames frame
	PVPFrame.panel4:DisableDrawLayer("ARTWORK")
	self:skinSlider{obj=WarGamesFrameScrollFrameScrollBar, adj=-4}
	self:skinScrollBar{obj=WarGamesFrameInfoScrollFrame}
	WarGamesFrameBGTex:SetAlpha(0)
	WarGamesFrameInfoScrollFrame.scrollBarArtTop:SetAlpha(0)
	WarGamesFrameInfoScrollFrame.scrollBarArtBottom:SetAlpha(0)
	WarGamesFrameDescription:SetTextColor(self.BTr, self.BTg, self.BTb)
	for i = 1, #WarGamesFrame.scrollFrame.buttons do
		btn = WarGamesFrame.scrollFrame.buttons[i]
		self:skinButton{obj=btn.header, mp=true, plus=true}
		local btnName = btn.warGame:GetName()
		_G[btnName.."Bg"]:SetAlpha(0)
		_G[btnName.."Border"]:SetAlpha(0)
		self:addButtonBorder{obj=btn.warGame, relTo=btn.warGame.icon}
	end
	self:SecureHook("WarGamesFrame_Update", function()
		for i = 1, #WarGamesFrame.scrollFrame.buttons do
			btn = WarGamesFrame.scrollFrame.buttons[i]
			if btn then self:checkTex{obj=btn.header} end
		end
	end)
	self:removeMagicBtnTex(WarGameStartButton)

-->>-- Static Popup Special frame
	self:addSkinFrame{obj=PVPFramePopup, ft=ftype, kfs=true, x1=9, y1=-9, x2=-7, y2=9}

	-- Hook this to suppress the PVP Banner Header from being displayed when new team created
	self:SecureHook("CreateArenaTeam", function(size, name, ...)
		-- self:Debug("CreateArenaTeam: [%s, %s]", size,name)
		if size == 2 then
			PVPFrame.panel3.flag2.NormalHeader:SetTexture(nil)
			PVPFrame.panel3.flag2.GlowHeader:SetTexture(nil)
		elseif size == 3 then
			PVPFrame.panel3.flag3.NormalHeader:SetTexture(nil)
			PVPFrame.panel3.flag3.GlowHeader:SetTexture(nil)
		elseif size == 5 then
			PVPFrame.panel3.flag5.NormalHeader:SetTexture(nil)
			PVPFrame.panel3.flag5.GlowHeader:SetTexture(nil)
		end
	end)

	-- N.B. PVPBanner frame a.k.a. ArenaRegistrar

end

function aObj:QuestLog()
	if not self.db.profile.QuestLog or self.initialized.QuestLog then return end
	self.initialized.QuestLog = true

	self:add2Table(self.pKeys1, "QuestLog")

	self:keepFontStrings(QuestLogCount)
	self:keepFontStrings(EmptyQuestLogFrame)

	if self.modBtns then
		local function qlUpd()

			-- handle in combat
			if InCombatLockdown() then
				aObj:add2Table(aObj.oocTab, {qlUpd, {nil}})
				return
			end

			for i = 1, #QuestLogScrollFrame.buttons do
				aObj:checkTex(QuestLogScrollFrame.buttons[i])
			end

		end
		-- hook to manage changes to button textures
		self:SecureHook("QuestLog_Update", function()
			qlUpd()
		end)
		-- hook this as well as it's a copy of QuestLog_Update
		self:SecureHook(QuestLogScrollFrame, "update", function()
			qlUpd()
		end)
		-- skin minus/plus buttons
		for i = 1, #QuestLogScrollFrame.buttons do
			self:skinButton{obj=QuestLogScrollFrame.buttons[i], mp=true}
		end
	end
	self:skinSlider{obj=QuestLogScrollFrame.scrollBar, adj=-4}
	self:addButtonBorder{obj=QuestLogFrameShowMapButton, relTo=QuestLogFrameShowMapButton.texture, x1=2, y1=-1, x2=-2, y2=1}
	self:removeRegions(QuestLogScrollFrame, {1, 2, 3, 4})
	self:skinAllButtons{obj=QuestLogControlPanel}
	self:addSkinFrame{obj=QuestLogFrame, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-2}
	self:removeMagicBtnTex(QuestLogFrameCompleteButton)

-->>-- QuestLogDetail Frame
	QuestLogDetailTitleText:SetTextColor(self.HTr, self.HTg, self.HTb)
	self:skinScrollBar{obj=QuestLogDetailScrollFrame}
	self:addSkinFrame{obj=QuestLogDetailFrame, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-2}
	self:QuestInfo()

end

function aObj:RaidUI() -- LoD
	if not self.db.profile.RaidUI or self.initialized.RaidUI then return end
	self.initialized.RaidUI = true

	local function skinPulloutFrames()

		local obj, objName
		for i = 1, NUM_RAID_PULLOUT_FRAMES	do
			objName = "RaidPullout"..i
			obj = _G[objName]
			if not aObj.skinFrame[obj] then
				aObj:skinDropDown{obj=_G[objName.."DropDown"]}
				_G[objName.."MenuBackdrop"]:SetBackdrop(nil)
				aObj:addSkinFrame{obj=obj, ft=ftype, kfs=true, x1=3, y1=-1, x2=-1, y2=1}
			end
		end

	end
	-- hook this to skin the pullout group frames
	self:SecureHook("RaidPullout_GetFrame", function(...)
		skinPulloutFrames()
	end)
	-- hook this to skin the pullout character frames
	self:SecureHook("RaidPullout_Update", function(pullOutFrame)
		local pfName = pullOutFrame:GetName()
		local objName, barName
		for i = 1, pullOutFrame.numPulloutButtons do
			objName = pfName.."Button"..i
			if not self.skinFrame[obj] then
				for _, v in pairs{"HealthBar", "ManaBar", "Target", "TargetTarget"} do
					barName = objName..v
					self:removeRegions(_G[barName], {2})
					self:glazeStatusBar(_G[barName], 0, _G[barName.."Background"])
				end
				self:addSkinFrame{obj=_G[objName.."TargetTargetFrame"], ft=ftype, x1=4, x2=-4, y2=2}
				self:addSkinFrame{obj=_G[objName], ft=ftype, kfs=true, x1=-4, y1=-6, x2=4, y2=-6}
			end
		end
	end)

	self:skinButton{obj=RaidFrameReadyCheckButton}
	self:moveObject{obj=RaidGroup1, x=2}

	-- Raid Groups
	for i = 1, MAX_RAID_GROUPS do
		self:addSkinFrame{obj=_G["RaidGroup"..i], ft=ftype, kfs=true, x1=-2, y1=2, x2=1, y2=-1}
	end
	-- Raid Group Buttons
	for i = 1, MAX_RAID_GROUPS * 5 do
		btn = _G["RaidGroupButton"..i]
		self:removeRegions(btn, {4})
		self:addSkinFrame{obj=btn, ft=ftype, aso={bd=5}, x1=-2, y1=2, x2=1, y2=-1}
	end
	-- Raid Class Tabs (side)
	for i = 1, MAX_RAID_CLASS_BUTTONS do
		self:removeRegions(_G["RaidClassButton"..i], {1}) -- N.B. region 2 is the icon, 3 is the text
	end

	-- skin existing frames
	skinPulloutFrames()

end

function aObj:ReadyCheck()
	if not self.db.profile.ReadyCheck or self.initialized.ReadyCheck then return end
	self.initialized.ReadyCheck = true

	self:add2Table(self.pKeys1, "ReadyCheck")

	self:addSkinFrame{obj=ReadyCheckListenerFrame, ft=ftype, kfs=true}

end

function aObj:RolePollPopup()
	if not self.db.profile.RolePollPopup or self.initialized.RolePollPopup then return end
	self.initialized.RolePollPopup = true

	self:add2Table(self.pKeys1, "RolePollPopup")

	self:addSkinFrame{obj=RolePollPopup, ft=ftype, x1=5, y1=-5, x2=-5, y2=5}

end

function aObj:ScrollOfResurrection()
	if not self.db.profile.ScrollOfResurrection or self.initialized.ScrollOfResurrection then return end
	self.initialized.ScrollOfResurrection = true

	self:add2Table(self.pKeys1, "ScrollOfResurrection")

	self:skinEditBox{obj=ScrollOfResurrectionFrame.targetEditBox, regs={9}}
	ScrollOfResurrectionFrame.targetEditBox.fill:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:addSkinFrame{obj=ScrollOfResurrectionFrame.noteFrame, ft=ftype, kfs=true}
	self:skinScrollBar{obj=ScrollOfResurrectionFrame.noteFrame.scrollFrame}
	ScrollOfResurrectionFrame.noteFrame.scrollFrame.editBox.fill:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:addSkinFrame{obj=ScrollOfResurrectionFrame, ft=ftype, kfs=true}
	-- Selection frame
	self:skinEditBox{obj=ScrollOfResurrectionSelectionFrame.targetEditBox, regs={9}}
	self:skinSlider{obj=ScrollOfResurrectionSelectionFrame.list.scrollFrame.scrollBar}
	self:addSkinFrame{obj=ScrollOfResurrectionSelectionFrame.list, ft=ftype, kfs=true}
	self:addSkinFrame{obj=ScrollOfResurrectionSelectionFrame, ft=ftype, kfs=true}

end

function aObj:SpellBookFrame()
	if not self.db.profile.SpellBookFrame or self.initialized.SpellBookFrame then return end
	self.initialized.SpellBookFrame = true

	self:add2Table(self.pKeys1, "SpellBookFrame")

	SpellBookFrame.numTabs = 5
	if self.isTT then
		-- hook to handle tabs
		self:SecureHook("ToggleSpellBook", function(bookType)
			local tab, tabSF
			for i = 1, SpellBookFrame.numTabs do
				tab = _G["SpellBookFrameTabButton"..i]
				tabSF = self.skinFrame[tab]
				if tab.bookType == bookType then
					self:setActiveTab(tabSF)
				else
					self:setInactiveTab(tabSF)
				end
			end
		end)
	end

	SpellBookFrame.MainHelpButton.Ring:SetTexture(nil)
	self:moveObject{obj=SpellBookFrame.MainHelpButton, y=-4}
	self:skinTabs{obj=SpellBookFrame, suffix="Button", x1=8, y1=1, x2=-8, y2=2}
	self:addSkinFrame{obj=SpellBookFrame, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-5}
	self:addButtonBorder{obj=SpellBookPrevPageButton, ofs=-2}
	self:addButtonBorder{obj=SpellBookNextPageButton, ofs=-2}
-->>- Spellbook Panel
	SpellBookPageText:SetTextColor(self.BTr, self.BTg, self.BTb)
	-- hook this to change text colour as required
	self:SecureHook("SpellButton_UpdateButton", function(this)
		if this.UnlearnedFrame and this.UnlearnedFrame:IsShown() then -- level too low
			this.SpellName:SetTextColor(self.HTr, self.HTg, self.HTb)
		end
		if this.RequiredLevelString then this.RequiredLevelString:SetTextColor(self.BTr, self.BTg, self.BTb) end
		if this.TrainFrame and this.TrainFrame:IsShown() then -- see Trainer
			this.SpellName:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
			this.SpellSubName:SetTextColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
		end
		if this.SeeTrainerString then this.SeeTrainerString:SetTextColor(self.BTr, self.BTg, self.BTb) end
		if this.SpellName then
			this.SpellName:SetTextColor(self.HTr, self.HTg, self.HTb)
			this.SpellSubName:SetTextColor(self.BTr, self.BTg, self.BTb)
		end
	end)
-->>-- Professions Panel
	local function skinProf(type, times)

		local obj, objName
		for i = 1, times do
			objName = type.."Profession"..i
			obj =_G[objName]
			if type == "Primary" then
				_G[objName.."IconBorder"]:Hide()
				if not obj.missingHeader:IsShown() then
					obj.icon:SetDesaturated(nil) -- show in colour
				end
			else
				obj.missingHeader:SetTextColor(aObj.HTr, aObj.HTg, aObj.HTb)
			end
			obj.missingText:SetTextColor(aObj.BTr, aObj.BTg, aObj.BTb)
			for i = 1, 2 do
				btn = obj["button"..i]
				btn:DisableDrawLayer("BACKGROUND")
				btn.subSpellString:SetTextColor(aObj.BTr, aObj.BTg, aObj.BTb)
				aObj:addButtonBorder{obj=btn, sec=true}
			end
			_G[objName.."StatusBar"]:DisableDrawLayer("BACKGROUND")
		end

	end
	-- Primary professions
	skinProf("Primary", 2)
	-- Secondary professions
	skinProf("Secondary", 4)
	-->>-- Core Abilities Panel
	SpellBookCoreAbilitiesFrame.SpecName:SetTextColor(self.HTr, self.HTg, self.HTb)
	self:SecureHook("SpellBook_UpdateCoreAbilitiesTab", function()
		for i = 1, #SpellBookCoreAbilitiesFrame.Abilities do
			btn = SpellBookCoreAbilitiesFrame.Abilities[i]
			if not btn.sknrBdr then
				btn.EmptySlot:SetAlpha(0)
				btn.ActiveTexture:SetAlpha(0)
				btn.FutureTexture:SetAlpha(0)
				btn.Name:SetTextColor(self.HTr, self.HTg, self.HTb)
				btn.InfoText:SetTextColor(self.BTr, self.BTg, self.BTb)
				btn.RequiredLevel:SetTextColor(self.BTr, self.BTg, self.BTb)
				self:addButtonBorder{obj=btn}
			end
		end
		for i = 1, #SpellBookCoreAbilitiesFrame.SpecTabs do
			tab = SpellBookCoreAbilitiesFrame.SpecTabs[i]
			if not tab.sknrBdr then
				self:removeRegions(tab, {1}) -- N.B. other regions are icon and highlight
				self:addButtonBorder{obj=tab}
			end
		end
	end)
	-->>-- What has changed? panel
	SpellBookWhatHasChanged.ClassName:SetTextColor(self.HTr, self.HTg, self.HTb)
	self:SecureHook("SpellBook_UpdateWhatHasChangedTab", function()
		for i = 1, #SpellBookWhatHasChanged.ChangedItems do
			btn = SpellBookWhatHasChanged.ChangedItems[i]
			btn.Ring:SetTexture(nil)
			btn:DisableDrawLayer("BACKGROUND")
			btn.Title:SetTextColor(self.HTr, self.HTg, self.HTb)
			btn:SetTextColor(self.BTr, self.BTg, self.BTb)
		end
		self:Unhook("SpellBook_UpdateWhatHasChangedTab")
	end)

	-- colour the spell name text
	for i = 1, SPELLS_PER_PAGE do
		btnName = "SpellButton"..i
		btn = _G[btnName]
		btn:DisableDrawLayer("BACKGROUND")
		btn:DisableDrawLayer("BORDER")
		_G[btnName.."SlotFrame"]:SetAlpha(0)
		btn.UnlearnedFrame:SetAlpha(0)
		btn.TrainFrame:SetAlpha(0)
		self:addButtonBorder{obj=_G[btnName], sec=true}
	end
-->>-- Tabs (side)
	for i = 1, MAX_SKILLLINE_TABS do
		obj = _G["SpellBookSkillLineTab"..i]
		self:removeRegions(obj, {1}) -- N.B. other regions are icon and highlight
		self:addButtonBorder{obj=obj}
	end

end

function aObj:SpellFlyout()
	if not self.db.profile.SpellFlyout or self.initialized.SpellFlyout then return end
	self.initialized.SpellFlyout = true

	self:add2Table(self.pKeys1, "SpellFlyout")

	self:SecureHook("ActionButton_UpdateFlyout", function(this)
		if this.FlyoutBorder
		and not self.skinned[this]
		then
			this.FlyoutBorder:SetAlpha(0)
			this.FlyoutBorderShadow:SetAlpha(0)
		end
	end)

end

function aObj:StackSplit()
	if not self.db.profile.StackSplit or self.initialized.StackSplit then return end
	self.initialized.StackSplit = true

	self:add2Table(self.pKeys1, "StackSplit")

	-- handle different addons being loaded
	if IsAddOnLoaded("EnhancedStackSplit") then
		self:addSkinFrame{obj=StackSplitFrame, ft=ftype, kfs=true, y2=-24}
	else
		self:addSkinFrame{obj=StackSplitFrame, ft=ftype, kfs=true, x1=9, y1=-12, x2=-6, y2=12}
	end

end

function aObj:TalentUI() -- LoD
	if not self.db.profile.TalentUI or self.initialized.TalentUI then return end
	self.initialized.TalentUI = true

	self:skinTabs{obj=PlayerTalentFrame, lod=true}
	self:addSkinFrame{obj=PlayerTalentFrame, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-5}
	-- Tab1 (Specialization)
	self:removeRegions(PlayerTalentFrameSpecialization, {1, 2, 3, 4, 5, 6})
	PlayerTalentFrameSpecialization.MainHelpButton.Ring:SetTexture(nil)
	self:moveObject{obj=PlayerTalentFrameSpecialization.MainHelpButton, y=-4}
	self:removeMagicBtnTex(PlayerTalentFrameSpecialization.learnButton)
	-- specs
	for i = 1, 4 do
		btn = PlayerTalentFrameSpecialization["specButton"..i]
		btn.bg:SetTexture(nil)
		btn.ring:SetTexture(nil)
		btn.selectedTex:SetTexture([[Interface\HelpFrame\HelpButtons]])
		btn.selectedTex:SetTexCoord(0.00390625, 0.78125000, 0.66015625, 0.87109375)
		btn.learnedTex:SetTexture(nil)
		tex = btn:GetHighlightTexture()
		tex:SetTexture([[Interface\HelpFrame\HelpButtons]])
		tex:SetTexCoord(0.00390625, 0.78125000, 0.00390625, 0.21484375)
	end
	-- shadow frame (LHS)
	self:keepFontStrings(self:getChild(PlayerTalentFrameSpecialization, 7))
	-- spellsScroll (RHS)
	self:skinSlider{obj=PlayerTalentFrameSpecialization.spellsScroll.ScrollBar}
	local scrollChild = PlayerTalentFrameSpecialization.spellsScroll.child
	self:removeRegions(scrollChild, {1, 2, 3, 4, 5, 6, 12})
	-- abilities
	for i = 1, scrollChild:GetNumChildren() do
		btn = scrollChild["abilityButton"..i]
		if btn then btn.ring:SetTexture(nil) end
	end
	-- handle extra abilities (Player and Pet)
	self:RawHook("PlayerTalentFrame_CreateSpecSpellButton", function(...)
		local frame = self.hooks.PlayerTalentFrame_CreateSpecSpellButton(...)
		frame.ring:SetTexture(nil)
		return frame
	end, true)
	-- Tab2 (Talents)
	self:removeRegions(PlayerTalentFrameTalents, {1, 2, 3, 4, 5, 6, 7})
	PlayerTalentFrameTalents.MainHelpButton.Ring:SetTexture(nil)
	self:moveObject{obj=PlayerTalentFrameTalents.MainHelpButton, y=-4}
	self:removeMagicBtnTex(PlayerTalentFrameTalents.learnButton)
	self:addButtonBorder{obj=PlayerTalentFrameTalents.clearInfo, relTo=PlayerTalentFrameTalents.clearInfo.icon}
	-- Talent rows
	for i = 1, 6 do
		obj = PlayerTalentFrameTalents["tier"..i]
		self:removeRegions(obj, {1, 2 ,3, 4, 5, 6})
		for j = 1, 3 do
			btn = obj["talent"..j]
			btn.Slot:SetTexture(nil)
			btn.knownSelection:SetTexture([[Interface\HelpFrame\HelpButtons]])
			btn.knownSelection:SetTexCoord(0.00390625, 0.78125000, 0.66015625, 0.87109375)
			self:addButtonBorder{obj=btn, relTo=btn.icon}
		end
	end
	-- Tab3 (Glyphs), skinned in GlyphUI
	-- Tab4 (Pet Specialization)
	self:removeRegions(PlayerTalentFramePetSpecialization, {1, 2, 3, 4, 5, 6})
	PlayerTalentFramePetSpecialization.MainHelpButton.Ring:SetTexture(nil)
	self:moveObject{obj=PlayerTalentFramePetSpecialization.MainHelpButton, y=-4}
	self:removeMagicBtnTex(PlayerTalentFramePetSpecialization.learnButton)
	-- specs
	for i = 1, 4 do
		btn = PlayerTalentFramePetSpecialization["specButton"..i]
		btn.bg:SetTexture(nil)
		btn.ring:SetTexture(nil)
		btn.selectedTex:SetTexture([[Interface\HelpFrame\HelpButtons]])
		btn.selectedTex:SetTexCoord(0.00390625, 0.78125000, 0.66015625, 0.87109375)
		btn.learnedTex:SetTexture(nil)
	end
	-- shadow frame (LHS)
	self:keepFontStrings(self:getChild(PlayerTalentFramePetSpecialization, 7))
	-- spellsScroll (RHS)
	self:skinSlider{obj=PlayerTalentFramePetSpecialization.spellsScroll.ScrollBar}
	local scrollChild = PlayerTalentFramePetSpecialization.spellsScroll.child
	self:removeRegions(scrollChild, {1, 2, 3, 4, 5, 6, 12})
	-- abilities
	for i = 1, scrollChild:GetNumChildren() do
		btn = scrollChild["abilityButton"..i]
		if btn then btn.ring:SetTexture(nil) end
	end
	-- Spec Tabs (side)
	for i = 1, 2 do
		tab = _G["PlayerSpecTab"..i]
		self:removeRegions(tab, {1}) -- N.B. other regions are icon and highlight
		self:addButtonBorder{obj=tab}
	end

end

function aObj:TradeFrame()
	if not self.db.profile.TradeFrame or self.initialized.TradeFrame then return end
	self.initialized.TradeFrame = true

	self:add2Table(self.pKeys1, "TradeFrame")

	if self.modBtnBs then
		for i = 1, MAX_TRADE_ITEMS do
			for _, v in pairs{"Player", "Recipient"} do
				btnName = "Trade"..v.."Item"..i
				_G[btnName.."SlotTexture"]:SetTexture(nil)
				_G[btnName.."NameFrame"]:SetTexture(nil)
				self:addButtonBorder{obj=_G[btnName.."ItemButton"], ibt=true}
			end
		end
	end
	self:skinMoneyFrame{obj=TradePlayerInputMoneyFrame}
	self:removeInset(TradeRecipientItemsInset)
	self:removeInset(TradeRecipientEnchantInset)
	self:removeInset(TradePlayerItemsInset)
	self:removeInset(TradePlayerEnchantInset)
	self:removeInset(TradePlayerInputMoneyInset)
	self:removeInset(TradeRecipientItemsInset)
	TradeRecipientMoneyBg:DisableDrawLayer("BACKGROUND")
	self:addSkinFrame{obj=TradeFrame, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-2}

end

function aObj:TradeSkillUI() -- LoD
	if not self.db.profile.TradeSkillUI or self.initialized.TradeSkillUI then return end
	self.initialized.TradeSkillUI = true

	if self.modBtns then
		-- hook to manage changes to button textures
		self:SecureHook("TradeSkillFrame_Update", function()
			for i = 1, TRADE_SKILLS_DISPLAYED do
				self:checkTex(_G["TradeSkillSkill"..i])
			end
			self:checkTex(TradeSkillCollapseAllButton)
		end)
	end

	objName = "TradeSkillRankFrame"
	obj = _G[objName]
	_G[objName.."Border"]:SetAlpha(0)
	self:glazeStatusBar(obj, 0, _G[objName.."Background"])
	self:moveObject{obj=obj, x=-2}
	self:skinEditBox{obj=TradeSkillFrameSearchBox, regs={9}, mi=true, noHeight=true, noMove=true}
	self:skinButton{obj=TradeSkillFilterButton}
	self:addButtonBorder{obj=TradeSkillLinkButton, x1=1, y1=-5, x2=-3, y2=2}
	self:removeRegions(TradeSkillExpandButtonFrame)
	self:skinButton{obj=TradeSkillCollapseAllButton, mp=true}
	for i = 1, TRADE_SKILLS_DISPLAYED do
		btn = _G["TradeSkillSkill"..i]
		self:skinButton{obj=btn, mp=true}
		btn.SubSkillRankBar.BorderLeft:SetTexture(nil)
		btn.SubSkillRankBar.BorderRight:SetTexture(nil)
		btn.SubSkillRankBar.BorderMid:SetTexture(nil)
		self:glazeStatusBar(btn.SubSkillRankBar, 0)
	end
	self:skinScrollBar{obj=TradeSkillListScrollFrame}
	self:skinScrollBar{obj=TradeSkillDetailScrollFrame}
	self:keepFontStrings(TradeSkillDetailScrollChildFrame)
	self:addButtonBorder{obj=TradeSkillSkillIcon}
	self:skinEditBox{obj=TradeSkillInputBox, noHeight=true, x=-5}
	self:addSkinFrame{obj=TradeSkillFrame, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-5}
	self:removeMagicBtnTex(TradeSkillCreateAllButton)
	self:removeMagicBtnTex(TradeSkillCancelButton)
	self:removeMagicBtnTex(TradeSkillCreateButton)
	self:removeMagicBtnTex(TradeSkillViewGuildCraftersButton)
	self:addButtonBorder{obj=TradeSkillDecrementButton, ofs=-2}
	self:addButtonBorder{obj=TradeSkillIncrementButton, ofs=-2}
	-- Guild sub frame
	self:addSkinFrame{obj=TradeSkillGuildFrameContainer, ft=ftype}
	self:addSkinFrame{obj=TradeSkillGuildFrame, ft=ftype, kfs=true, ofs=-7}

	for i = 1, MAX_TRADE_SKILL_REAGENTS do
		_G["TradeSkillReagent"..i.."NameFrame"]:SetTexture(nil)
		self:addButtonBorder{obj=_G["TradeSkillReagent"..i], libt=true}
	end

	if self.modBtns then TradeSkillFrame_Update() end -- force update for button textures

end

function aObj:WatchFrame()
	if not self.db.profile.WatchFrame.skin
	and not self.db.profile.WatchFrame.popups
	or self.initialized.WatchFrame
	then
		return
	end
	self.initialized.WatchFrame = true

	self:add2Table(self.pKeys2, "WatchFrame")

	if self.modBtnBs then
		local btn
		local function skinWFBtns()

			for i = 1, WATCHFRAME_NUM_ITEMS do
				btn = _G["WatchFrameItem"..i]
				if not btn.sknrBdr then
					aObj:addButtonBorder{obj=btn, ibt=true}
				end
			end

		end
		-- use hooksecurefunc as it may be hooked again if skinned
		hooksecurefunc("WatchFrame_Update", function(this)
			skinWFBtns()
		end)
		skinWFBtns() -- skin any existing buttons
	end

	if self.db.profile.WatchFrame.skin then
		self:addSkinFrame{obj=WatchFrameLines, ft=ftype, x1=-30, y1=4, x2=10}
		-- hook this to handle displaying of the WatchFrameLines skin frame
		self:SecureHook("WatchFrame_Update", function(this)
			if not WatchFrameHeader:IsShown() then
				self.skinFrame[WatchFrameLines]:Hide()
			else
				self.skinFrame[WatchFrameLines]:Show()
			end
		end)
	end
	if self.db.profile.WatchFrame.popups then
		local function skinAutoPopUps()

			local obj
			for i = 1, GetNumAutoQuestPopUps() do
				obj = _G["WatchFrameAutoQuestPopUp"..i] and _G["WatchFrameAutoQuestPopUp"..i].ScrollChild
				if obj and not aObj.skinned[obj] then
					for key, reg in ipairs{obj:GetRegions()} do
						if key < 11 or key > 16 then reg:SetTexture(nil) end -- Animated textures
					end
					aObj:applySkin{obj=obj}
				end
			end

		end
		WatchFrameLinesShadow:SetTexture(nil) -- shadow texture above popup
		-- hook this to skin the AutoPopUps
		self:SecureHook("WatchFrameAutoQuest_GetOrCreateFrame", function(parent, index)
			skinAutoPopUps()
		end)
		skinAutoPopUps()
	end

end
