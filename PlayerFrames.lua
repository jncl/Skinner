local aName, aObj = ...
local _G = _G
local ftype = "p"

-- Add locals to see if it speeds things up
local ipairs, pairs, unpack = _G.ipairs, _G.pairs, _G.unpack

function aObj:AchievementUI() -- LoD
	if not self.db.profile.AchievementUI.skin or self.initialized.AchievementUI then return end
	self.initialized.AchievementUI = true

	local prdbA = self.db.profile.AchievementUI

	if prdbA.style == 2 then
		_G.ACHIEVEMENTUI_REDBORDER_R = self.bbColour[1]
		_G.ACHIEVEMENTUI_REDBORDER_G = self.bbColour[2]
		_G.ACHIEVEMENTUI_REDBORDER_B = self.bbColour[3]
		_G.ACHIEVEMENTUI_REDBORDER_A = self.bbColour[4]
	end

	local function skinSB(statusBar, type)

		aObj:moveObject{obj=_G[statusBar .. type], y=-3}
		aObj:moveObject{obj=_G[statusBar .. "Text"], y=-3}
		_G[statusBar .. "Left"]:SetAlpha(0)
		_G[statusBar .. "Right"]:SetAlpha(0)
		_G[statusBar .. "Middle"]:SetAlpha(0)
		self:glazeStatusBar(_G[statusBar], 0, _G[statusBar .. "FillBar"])

	end
	local function skinStats()

		for i = 1, #_G.AchievementFrameStatsContainer.buttons do
			local btn = _G.AchievementFrameStatsContainer.buttons[i]
			btn.background:SetTexture(nil)
			btn.left:SetAlpha(0)
			btn.middle:SetAlpha(0)
			btn.right:SetAlpha(0)
		end

	end
	local function glazeProgressBar(pBar)

		if not aObj.sbGlazed[pBar] then
			_G[pBar .. "BorderLeft"]:SetAlpha(0)
			_G[pBar .. "BorderRight"]:SetAlpha(0)
			_G[pBar .. "BorderCenter"]:SetAlpha(0)
			aObj:glazeStatusBar(_G[pBar], 0, _G[pBar .. "BG"])
		end

	end
	local function skinCategories()

		for i = 1, #_G.AchievementFrameCategoriesContainer.buttons do
			_G.AchievementFrameCategoriesContainer.buttons[i].background:SetAlpha(0)
		end

	end
	local function skinComparisonStats()

		for i = 1, #_G.AchievementFrameComparisonStatsContainer.buttons do
			local btn = _G.AchievementFrameComparisonStatsContainer.buttons[i]
			if btn.isHeader then btn.background:SetAlpha(0) end
			btn.left:SetAlpha(0)
			btn.left2:SetAlpha(0)
			btn.middle:SetAlpha(0)
			btn.middle2:SetAlpha(0)
			btn.right:SetAlpha(0)
			btn.right2:SetAlpha(0)
		end

	end
	local function cleanButtons(frame, type)

		if prdbA.style == 1 then return end -- don't remove textures if option not chosen

		-- remove textures etc from buttons
		for i = 1, #frame.buttons do
			local btnName = frame.buttons[i]:GetName() .. (type == "Comparison" and "Player" or "")
			local btn = _G[btnName]
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
				_G[btnName .. "TopTsunami1"]:SetTexture(nil)
				_G[btnName .. "TopTsunami1"].SetTexture = function() end
				_G[btnName .. "BottomTsunami1"]:SetTexture(nil)
				_G[btnName .. "BottomTsunami1"].SetTexture = function() end
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
	self:moveObject{obj=_G.AchievementFrameFilterDropDown, y=-7}
	if self.db.profile.TexturedDD then
		local tex = _G.AchievementFrameFilterDropDown:CreateTexture(nil, "BORDER")
		tex:SetTexture(self.itTex)
		tex:SetWidth(110)
		tex:SetHeight(19)
		tex:SetPoint("RIGHT", _G.AchievementFrameFilterDropDown, "RIGHT", -3, 4)
	end
	-- skin the frame
	if self.db.profile.DropDownButtons then
		self:addSkinFrame{obj=_G.AchievementFrameFilterDropDown, ft=ftype, aso={ng=true}, x1=-8, y1=2, x2=2, y2=7}
	end
	self:skinTabs{obj=_G.AchievementFrame, regs={9, 10}, ignore=true, lod=true, x1=9, y1=2, x2=-9, y2=-10}
	self:addSkinFrame{obj=_G.AchievementFrame, ft=ftype, kfs=true, bgen=1, y1=8, y2=-3}

-->>-- move Header info
	self:keepFontStrings(_G.AchievementFrameHeader)
	self:moveObject{obj=_G.AchievementFrameHeaderTitle, x=-60, y=-25}
	self:moveObject{obj=_G.AchievementFrameHeaderPoints, x=40, y=-5}
	self:moveObject{obj=_G.AchievementFrameCloseButton, y=6}
	_G.AchievementFrameHeaderShield:SetAlpha(1)

-->>-- Categories Panel (on the Left)
	self:skinSlider{obj=_G.AchievementFrameCategoriesContainerScrollBar, adj=-4}
	self:addSkinFrame{obj=_G.AchievementFrameCategories, ft=ftype, y2=-2}
	self:SecureHook("AchievementFrameCategories_Update", function()
		skinCategories()
	end)
	skinCategories()

-->>-- Achievements Panel (on the right)
	self:keepFontStrings(_G.AchievementFrameAchievements)
	self:addSkinFrame{obj=self:getChild(_G.AchievementFrameAchievements, 2), ft=ftype, aso={ba=0, ng=true}}
	self:skinSlider{obj=_G.AchievementFrameAchievementsContainerScrollBar, adj=-4}
	if prdbA.style == 2 then
		-- remove textures etc from buttons
		cleanButtons(_G.AchievementFrameAchievementsContainer, "Achievements")
		-- hook this to handle objectives text colour changes
		self:SecureHookScript(_G.AchievementFrameAchievementsObjectives, "OnShow", function(this)
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
		local objName = "AchievementFrameProgressBar" .. i
		if _G[objName] then glazeProgressBar(objName) end
	end
	-- hook this to skin StatusBars used by the Objectives mini panels
	self:RawHook("AchievementButton_GetProgressBar", function(...)
		local obj = self.hooks.AchievementButton_GetProgressBar(...)
		glazeProgressBar(obj:GetName())
		return obj
	end, true)

-->>-- Stats
	self:keepFontStrings(_G.AchievementFrameStats)
	self:skinSlider{obj=_G.AchievementFrameStatsContainerScrollBar, adj=-4}
	_G.AchievementFrameStatsBG:SetAlpha(0)
	self:addSkinFrame{obj=self:getChild(_G.AchievementFrameStats, 3), ft=ftype, aso={ba=0, ng=true}}
	-- hook this to skin buttons
	self:SecureHook("AchievementFrameStats_Update", function()
		skinStats()
	end)
	skinStats()

-->>-- Summary Panel
	self:keepFontStrings(_G.AchievementFrameSummary)
	_G.AchievementFrameSummaryBackground:SetAlpha(0)
	_G.AchievementFrameSummaryAchievementsHeaderHeader:SetAlpha(0)
	self:skinSlider(_G.AchievementFrameAchievementsContainerScrollBar)
	-- remove textures etc from buttons
	if not _G.AchievementFrameSummary:IsVisible() and prdbA.style == 2 then
		self:SecureHookScript(_G.AchievementFrameSummary, "OnShow", function()
			cleanButtons(_G.AchievementFrameSummaryAchievements, "Summary")
			self:Unhook(_G.AchievementFrameSummary, "OnShow")
		end)
	else
		cleanButtons(_G.AchievementFrameSummaryAchievements, "Summary")
	end
	-- Categories SubPanel
	self:keepFontStrings(_G.AchievementFrameSummaryCategoriesHeader)
	for i = 1, #_G.ACHIEVEMENTUI_SUMMARYCATEGORIES do
		skinSB("AchievementFrameSummaryCategoriesCategory" .. i, "Label")
	end
	self:addSkinFrame{obj=self:getChild(_G.AchievementFrameSummary, 1), ft=ftype, aso={ba=0, ng=true}}
	skinSB("AchievementFrameSummaryCategoriesStatusBar", "Title")

-->>-- Comparison Panel
	_G.AchievementFrameComparisonBackground:SetAlpha(0)
	_G.AchievementFrameComparisonDark:SetAlpha(0)
	_G.AchievementFrameComparisonWatermark:SetAlpha(0)
	-- Header
	self:keepFontStrings(_G.AchievementFrameComparisonHeader)
	_G.AchievementFrameComparisonHeaderShield:SetAlpha(1)
	-- move header info
	_G.AchievementFrameComparisonHeaderShield:ClearAllPoints()
	_G.AchievementFrameComparisonHeaderShield:SetPoint("RIGHT", _G.AchievementFrameCloseButton, "LEFT", -10, -1)
	_G.AchievementFrameComparisonHeaderPoints:ClearAllPoints()
	_G.AchievementFrameComparisonHeaderPoints:SetPoint("RIGHT", _G.AchievementFrameComparisonHeaderShield, "LEFT", -10, 1)
	_G.AchievementFrameComparisonHeaderName:ClearAllPoints()
	_G.AchievementFrameComparisonHeaderName:SetPoint("RIGHT", _G.AchievementFrameComparisonHeaderPoints, "LEFT", -10, 0)
	-- Container
	self:skinSlider(_G.AchievementFrameComparisonContainerScrollBar)
	-- Summary Panel
	self:addSkinFrame{obj=self:getChild(_G.AchievementFrameComparison, 5), ft=ftype, aso={ba=0, ng=true}}
	for _, type in pairs{"Player", "Friend"} do
		_G["AchievementFrameComparisonSummary" .. type]:SetBackdrop(nil)
		_G["AchievementFrameComparisonSummary" .. type .. "Background"]:SetAlpha(0)
		skinSB("AchievementFrameComparisonSummary" .. type .. "StatusBar", "Title")
	end
	-- remove textures etc from buttons
	if not _G.AchievementFrameComparison:IsVisible() and prdbA.style == 2 then
		self:SecureHookScript(_G.AchievementFrameComparison, "OnShow", function()
			cleanButtons(_G.AchievementFrameComparisonContainer, "Comparison")
			self:Unhook(_G.AchievementFrameSummary, "OnShow")
		end)
	else
		cleanButtons(_G.AchievementFrameComparisonContainer, "Comparison")
	end
	-- Stats Panel
	self:skinSlider(_G.AchievementFrameComparisonStatsContainerScrollBar)
	self:SecureHook("AchievementFrameComparison_UpdateStats", function()
		skinComparisonStats()
	end)
	self:SecureHook(_G.AchievementFrameComparisonStatsContainer, "Show", function()
		skinComparisonStats()
	end)

end

function aObj:ArchaeologyUI() -- LoD
	if not self.db.profile.ArchaeologyUI or self.initialized.ArchaeologyUI then return end
	self.initialized.ArchaeologyUI = true

	self:moveObject{obj=_G.ArchaeologyFrame.infoButton, x=-25}
	self:skinDropDown{obj=_G.ArchaeologyFrame.raceFilterDropDown}
	_G.ArchaeologyFrameRankBarBackground:SetAllPoints(_G.ArchaeologyFrame.rankBar)
	_G.ArchaeologyFrameRankBarBorder:Hide()
	self:glazeStatusBar(_G.ArchaeologyFrame.rankBar, 0,  _G.ArchaeologyFrameRankBarBackground)
	self:addSkinFrame{obj=_G.ArchaeologyFrame, ft=ftype, kfs=true, ri=true, x1=30, y1=2, x2=1}
-->>-- Summary Page
	self:keepFontStrings(_G.ArchaeologyFrame.summaryPage) -- remove title textures
	_G.ArchaeologyFrameSummaryPageTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
	for i = 1, _G.ARCHAEOLOGY_MAX_RACES do
		_G.ArchaeologyFrame.summaryPage["race" .. i].raceName:SetTextColor(self.BTr, self.BTg, self.BTb)
	end
-->>-- Completed Page
	self:keepFontStrings(_G.ArchaeologyFrame.completedPage) -- remove title textures
	_G.ArchaeologyFrame.completedPage.infoText:SetTextColor(self.BTr, self.BTg, self.BTb)
	_G.ArchaeologyFrame.completedPage.titleBig:SetTextColor(self.HTr, self.HTg, self.HTb)
	_G.ArchaeologyFrame.completedPage.titleTop:SetTextColor(self.BTr, self.BTg, self.BTb)
	_G.ArchaeologyFrame.completedPage.titleMid:SetTextColor(self.BTr, self.BTg, self.BTb)
	_G.ArchaeologyFrame.completedPage.pageText:SetTextColor(self.BTr, self.BTg, self.BTb)
	for i = 1, _G.ARCHAEOLOGY_MAX_COMPLETED_SHOWN do
		local btn = _G.ArchaeologyFrame.completedPage["artifact" .. i]
		btn.artifactName:SetTextColor(self.HTr, self.HTg, self.HTb)
		btn.artifactSubText:SetTextColor(self.BTr, self.BTg, self.BTb)
		btn.border:Hide()
		_G["ArchaeologyFrameCompletedPageArtifact" .. i .. "Bg"]:Hide()
		self:addButtonBorder{obj=btn, relTo=btn.icon}
	end
	self:addButtonBorder{obj=_G.ArchaeologyFrame.completedPage.prevPageButon, ofs=0} -- N.B. spelling!
	self:addButtonBorder{obj=_G.ArchaeologyFrame.completedPage.nextPageButon, ofs=0} -- N.B. spelling!
-->>-- Artifact Page
	self:removeRegions(_G.ArchaeologyFrame.artifactPage, {2, 3, 7, 9}) -- title textures, backgrounds
	self:addButtonBorder{obj=_G.ArchaeologyFrame.artifactPage, relTo=_G.ArchaeologyFrame.artifactPage.icon, ofs=0}
	_G.ArchaeologyFrame.artifactPage.historyTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
	_G.ArchaeologyFrame.artifactPage.historyScroll.child.text:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:skinScrollBar{obj=_G.ArchaeologyFrame.artifactPage.historyScroll}
	-- Solve Frame
	_G.ArchaeologyFrameArtifactPageSolveFrameStatusBarBarBG:Hide()
	self:glazeStatusBar(_G.ArchaeologyFrame.artifactPage.solveFrame.statusBar, 0, nil)
	_G.ArchaeologyFrame.artifactPage.solveFrame.statusBar:SetStatusBarColor(0.75, 0.45, 0, 0.7)
-->>-- Help Page
	self:removeRegions(_G.ArchaeologyFrame.helpPage, {2, 3}) -- title textures
	_G.ArchaeologyFrame.helpPage.titleText:SetTextColor(self.HTr, self.HTg, self.HTb)
	_G.ArchaeologyFrameHelpPageDigTex:SetTexCoord(0.05, 0.885, 0.055, 0.9) -- remove texture surrounds
	_G.ArchaeologyFrameHelpPageDigTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
	_G.ArchaeologyFrameHelpPageHelpScrollHelpText:SetTextColor(self.BTr, self.BTg, self.BTb)

	-- ArcheologyDigsiteProgressBar
	self:removeRegions(_G.ArcheologyDigsiteProgressBar, {1, 2, 3})
	self:glazeStatusBar(_G.ArcheologyDigsiteProgressBar.FillBar, 0)
	-- N.B. DigsiteCompleteToastFrame is managed as part of the Alert Frames skin

end

function aObj:Buffs()
	if not self.db.profile.Buffs or self.initialized.Buffs then return end
	self.initialized.Buffs = true

	if self.modBtnBs then
		local function skinBuffs()

			-- handle in combat
			if _G.InCombatLockdown() then
				aObj:add2Table(aObj.oocTab, {skinBuffs, {nil}})
				return
			end

			for i= 1, _G.BUFF_MAX_DISPLAY do
				local btn = _G["BuffButton" .. i]
				if btn and not btn.sbb then
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
		_G.ConsolidatedBuffsIcon:SetTexCoord(0.128, 0.37, 0.235, 0.7375)
		_G.ConsolidatedBuffsIcon:SetWidth(30)
		_G.ConsolidatedBuffsIcon:SetHeight(30)
		self:addButtonBorder{obj=_G.ConsolidatedBuffs}
	end
	self:addSkinFrame{obj=_G.ConsolidatedBuffsTooltip}

end

function aObj:CastingBar()
	if not self.db.profile.CastingBar.skin or self.initialized.CastingBar then return end
	self.initialized.CastingBar = true

	for _, prefix in pairs{"", "Pet"} do

		local obj = _G[prefix .. "CastingBarFrame"]
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

	-- Character Frame
	self:removeInset(_G.CharacterFrameInsetRight)
	self:skinTabs{obj=_G.CharacterFrame}
	self:addSkinFrame{obj=_G.CharacterFrame, ft=ftype, kfs=true, ri=true, nb=true, x1=-3, y1=2, x2=1, y2=-5} -- don't skin buttons here
	self:skinButton{obj=_G.CharacterFrameCloseButton, cb=true}
	self:addButtonBorder{obj=_G.CharacterFrameExpandButton, ofs=-2, y1=-3, x2=-3}

	-- PaperDoll Frame
	self:keepFontStrings(_G.PaperDollFrame)
	_G.CharacterModelFrame.controlFrame:DisableDrawLayer("BACKGROUND")
	-- skin slots
	for _, child in ipairs{_G.PaperDollItemsFrame:GetChildren()} do
		child:DisableDrawLayer("BACKGROUND")
		if child:IsObjectType("Button") and self:hasTextInName(child, "Slot") then
			self:addButtonBorder{obj=child}
		end
	end
	_G.CharacterModelFrame:DisableDrawLayer("BACKGROUND")
	_G.CharacterModelFrame:DisableDrawLayer("BORDER")
	_G.CharacterModelFrame:DisableDrawLayer("OVERLAY")
	-- Sidebar Tabs
	_G.PaperDollSidebarTabs.DecorLeft:SetAlpha(0)
	_G.PaperDollSidebarTabs.DecorRight:SetAlpha(0)
	for i = 1, #_G.PAPERDOLL_SIDEBARS do
		local tab = _G["PaperDollSidebarTab" .. i]
		tab.TabBg:SetAlpha(0)
		tab.Hider:SetAlpha(0)
		-- use a button border to indicate the active tab
		self.modUIBtns:addButtonBorder{obj=tab, relTo=tab.Icon, ofs=i==1 and 3 or 1} -- use module function here to force creation
		tab.sbb:SetBackdropBorderColor(1, 0.6, 0, 1)
		tab.sbb:SetShown(_G[_G.PAPERDOLL_SIDEBARS[i].frame]:IsShown())
	end
	-- hook this to manage the active tab
	self:SecureHook("PaperDollFrame_UpdateSidebarTabs", function()
		for i = 1, #_G.PAPERDOLL_SIDEBARS do
			local tab = _G["PaperDollSidebarTab" .. i]
			if tab and tab.sbb then
				tab.sbb:SetShown(_G[_G.PAPERDOLL_SIDEBARS[i].frame]:IsShown())
			end
		end
	end)
	-- Stats
	_G.CharacterStatsPane:DisableDrawLayer("ARTWORK")
	self:skinSlider{obj=_G.CharacterStatsPaneScrollBar, size=3}
	for i = 1, 7 do
		local grp = _G["CharacterStatsPaneCategory" .. i]
		grp.BgTop:SetAlpha(0)
		grp.BgBottom:SetAlpha(0)
		grp.BgMiddle:SetAlpha(0)
		grp.BgMinimized:SetAlpha(0)
	end
	-- hook this to remove background texture from stat lines
	self:SecureHook("PaperDollFrame_UpdateStatCategory", function(catFrame)
		for i = 1, 12 do -- based upon PAPERDOLL_STATCATEGORIES #stats
			local statFrame = _G[catFrame:GetName() .. "Stat" .. i]
			if statFrame and statFrame.Bg then statFrame.Bg:SetAlpha(0) end
		end
	end)
	-- Titles
	self:SecureHookScript(_G.PaperDollTitlesPane, "OnShow", function(this)
		for i = 1, #this.buttons do
			local btn = this.buttons[i]
			btn:DisableDrawLayer("BACKGROUND")
		end
		self:Unhook(_G.PaperDollTitlesPane, "OnShow")
	end)
	self:skinSlider{obj=_G.PaperDollTitlesPane.scrollBar, adj=-4}
	-- Equipment Manager
	self:SecureHookScript(_G.PaperDollEquipmentManagerPane, "OnShow", function(this)
		for i = 1, #this.buttons do
			local btn = this.buttons[i]
			btn:DisableDrawLayer("BACKGROUND")
			self:addButtonBorder{obj=btn, relTo=btn.icon}
		end
		self:Unhook(_G.PaperDollEquipmentManagerPane, "OnShow")
	end)
	self:skinSlider{obj=_G.PaperDollEquipmentManagerPane.scrollBar, adj=-4}
	self:skinButton{obj=_G.PaperDollEquipmentManagerPane.EquipSet}
	_G.PaperDollEquipmentManagerPane.EquipSet.ButtonBackground:SetAlpha(0)
	self:skinButton{obj=_G.PaperDollEquipmentManagerPane.SaveSet}

	-- GearManagerDialog Popup Frame
	self:skinScrollBar{obj=_G.GearManagerDialogPopupScrollFrame}
	self:skinEditBox{obj=_G.GearManagerDialogPopupEditBox, regs={9}}
	for i = 1, _G.NUM_GEARSET_ICONS_SHOWN do
		local btn = _G["GearManagerDialogPopupButton" .. i]
		btn:DisableDrawLayer("BACKGROUND")
		self:addButtonBorder{obj=btn}
	end
	self:addSkinFrame{obj=_G.GearManagerDialogPopup, ft=ftype, kfs=true, x1=4, y1=-2, x2=-1, y2=3}

	-- PetPaperDoll Frame
	_G.PetPaperDollPetModelBg:SetAlpha(0) -- changed in blizzard code
	_G.PetModelFrameShadowOverlay:Hide()
	self:makeMFRotatable(_G.PetModelFrame)
	-- up the Frame level otherwise the tooltip doesn't work
	_G.RaiseFrameLevel(_G.PetPaperDollPetInfo)

	-- Reputation Frame
	if self.modBtns then
		-- hook to manage changes to button textures
		self:SecureHook("ReputationFrame_Update", function()
			for i = 1, _G.NUM_FACTIONS_DISPLAYED do
				self:checkTex(_G["ReputationBar" .. i .. "ExpandOrCollapseButton"])
			end
		end)
	end

	self:keepFontStrings(_G.ReputationFrame)
	self:skinScrollBar{obj=_G.ReputationListScrollFrame}

	for i = 1, _G.NUM_FACTIONS_DISPLAYED do
		local obj = "ReputationBar" .. i
		self:skinButton{obj=_G[obj .. "ExpandOrCollapseButton"], mp=true} -- treat as just a texture
		_G[obj .. "Background"]:SetAlpha(0)
		_G[obj .. "ReputationBarLeftTexture"]:SetAlpha(0)
		_G[obj .. "ReputationBarRightTexture"]:SetAlpha(0)
		self:glazeStatusBar(_G[obj .. "ReputationBar"], 0)
	end

	self:addSkinFrame{obj=_G.ReputationDetailFrame, ft=ftype, kfs=true, x1=6, y1=-6, x2=-6, y2=6}

	-- TokenFrame (a.k.a Currency Tab)
	if self.db.profile.ContainerFrames.skin then
		_G.BACKPACK_TOKENFRAME_HEIGHT = _G.BACKPACK_TOKENFRAME_HEIGHT - 6
		_G.BackpackTokenFrame:DisableDrawLayer("BACKGROUND")
	end

	self:keepFontStrings(_G.TokenFrame)
	self:skinScrollBar{obj=_G.TokenFrameContainer}

	self:SecureHookScript(_G.TokenFrame, "OnShow", function(this)
		-- remove background & header textures
		for i = 1, #_G.TokenFrameContainer.buttons do
			self:removeRegions(_G.TokenFrameContainer.buttons[i], {1, 6, 7, 8})
		end
		self:Unhook(_G.TokenFrame, "OnShow")
	end)

	self:addSkinFrame{obj=_G.TokenFramePopup,ft=ftype, kfs=true, y1=-6, x2=-6, y2=6}

end

function aObj:CompactFrames()
	if not self.db.profile.CompactFrames or self.initialized.CompactFrames then return end
	self.initialized.CompactFrames = true

	local function skinUnit(unit)

		-- handle in combat
		if _G.InCombatLockdown() then
			aObj:add2Table(aObj.oocTab, {skinUnit, {unit}})
			return
		end

		unit:DisableDrawLayer("BACKGROUND")
		unit:DisableDrawLayer("BORDER")

	end
	local function skinGrp(grp)

		grp.borderFrame:SetAlpha(0)
		local grpName = grp:GetName()
		for i = 1, _G.MEMBERS_PER_RAID_GROUP do
			skinUnit(_G[grpName .. "Member" .. i])
		end

	end

-->>-- Compact Party Frame
	self:SecureHook("CompactPartyFrame_OnLoad", function()
		self:addSkinFrame{obj=_G.CompactPartyFrame, ft=ftype, x1=2, y1=-10, x2=-3, y2=3}
		self:Unhook("CompactPartyFrame_OnLoad")
	end)
	-- hook this to skin any new CompactRaidGroup(s)
	self:SecureHook("CompactRaidGroup_UpdateBorder", function(frame)
		skinGrp(frame)
	end)

-->>-- Compact RaidFrame Container
	-- hook this to skin any new CompactRaidFrameContainer entries
	self:SecureHook("FlowContainer_AddObject", function(container, object)
		if container == _G.CompactRaidFrameContainer then -- only for compact raid frame objects
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
	for type, frame in ipairs(_G.CompactRaidFrameContainer.frameUpdateList) do
		if type == "group" then
			skinGrp(frame)
		else
			skinUnit(frame)
		end
	end
	self:addSkinFrame{obj=_G.CompactRaidFrameContainer.borderFrame, ft=ftype, kfs=true, bg=true, y1=-1, x2=-5, y2=4}

-->>-- Compact RaidFrame Manager
	local function skinButton(btn)

		aObj:removeRegions(btn, {1, 2, 3})
		aObj:skinButton{obj=btn}

	end
	-- Buttons
	for _, v in pairs{"Tank", "Healer", "Damager"} do
		skinButton(_G.CompactRaidFrameManager.displayFrame.filterOptions["filterRole" .. v])
	end
	for i = 1, 8 do
		skinButton(_G.CompactRaidFrameManager.displayFrame.filterOptions["filterGroup" .. i])
	end
	_G.CompactRaidFrameManager.displayFrame.filterOptions:DisableDrawLayer("BACKGROUND")
	self:skinDropDown{obj=_G.CompactRaidFrameManager.displayFrame.profileSelector}
	skinButton(_G.CompactRaidFrameManagerDisplayFrameLockedModeToggle)
	skinButton(_G.CompactRaidFrameManagerDisplayFrameHiddenModeToggle)
	-- Leader Options
	skinButton(_G.CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton)
	_G.CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:GetNormalTexture():SetAlpha(1) -- icon
	skinButton(_G.CompactRaidFrameManager.displayFrame.leaderOptions.readyCheckButton)
	skinButton(_G.CompactRaidFrameManager.displayFrame.leaderOptions.rolePollButton)
	skinButton(_G.CompactRaidFrameManager.displayFrame.convertToRaid)
	-- Display Frame
	self:keepFontStrings(_G.CompactRaidFrameManager.displayFrame)
	-- Resize Frame
	self:addSkinFrame{obj=_G.CompactRaidFrameManager.containerResizeFrame, ft=ftype, kfs=true, x1=-2, y1=-1, y2=4}
	-- Raid Frame Manager Frame
	self:addSkinFrame{obj=_G.CompactRaidFrameManager, ft=ftype, kfs=true}
	-- Toggle button
	self:moveObject{obj=_G.CompactRaidFrameManager.toggleButton, x=5}
	_G.CompactRaidFrameManager.toggleButton:SetSize(12, 32)
	_G.CompactRaidFrameManager.toggleButton.nt = _G.CompactRaidFrameManager.toggleButton:GetNormalTexture()
	_G.CompactRaidFrameManager.toggleButton.nt:SetTexCoord(0.22, 0.5, 0.33, 0.67)
	-- hook this to trim the texture
	self:RawHook(_G.CompactRaidFrameManager.toggleButton.nt, "SetTexCoord", function(this, x1, x2, y1, y2)
		self.hooks[this].SetTexCoord(this, x1 == 0 and x1 + 0.22 or x1 + 0.26, x2, 0.33, 0.67)
	end, true)

end

function aObj:ContainerFrames()
	if not self.db.profile.ContainerFrames.skin or self.initialized.ContainerFrames then return end
	self.initialized.ContainerFrames = true

	for i = 1, _G.NUM_CONTAINER_FRAMES do
		local objName = "ContainerFrame" .. i
		self:addSkinFrame{obj=_G[objName], ft=ftype, kfs=true, x1=8, y1=-4, x2=-3}
		-- resize and move the bag name to make it more readable
		local obj = _G[objName .. "Name"]
		obj:SetWidth(145)
		self:moveObject{obj=obj, x=-30}
		-- add button borders
		for j = 1, _G.MAX_CONTAINER_ITEMS do
			self:addButtonBorder{obj=_G[objName .. "Item" .. j]}
		end
	end
	self:skinEditBox{obj=_G.BagItemSearchBox, regs={9}, mi=true, noHeight=true, noMove=true}

end

function aObj:DressUpFrame()
	if not self.db.profile.DressUpFrame or self.initialized.DressUpFrame then return end
	self.initialized.DressUpFrame = true

	self:removeRegions(_G.DressUpFrame, {1, 2, 3, 4, 5}) -- N.B. regions 6 & 7 are text, 8-11 are the background picture
	_G.DressUpModel.controlFrame:DisableDrawLayer("BACKGROUND")
	self:addSkinFrame{obj=_G.DressUpFrame, ft=ftype, x1=10, y1=-12, x2=-33, y2=73}

end

function aObj:EncounterJournal() -- LoD
	if not self.db.profile.EncounterJournal or self.initialized.EncounterJournal then return end
	self.initialized.EncounterJournal = true

	self:removeInset(_G.EncounterJournal.inset)
	self:addSkinFrame{obj=_G.EncounterJournal, ft=ftype, kfs=true, y1=2, x2=1}

-->>-- Search EditBox, dropdown and results frame
	self:skinEditBox{obj=_G.EncounterJournal.searchBox, regs={9}, mi=true, noHeight=true, noMove=true}
	_G.EncounterJournal.searchBox.sbutton1:DisableDrawLayer("OVERLAY")
	self:addSkinFrame{obj=_G.EncounterJournal.searchResults, ft=ftype, kfs=true, ofs=6, y1=-1, x2=4}
	self:skinSlider{obj=_G.EncounterJournal.searchResults.scrollFrame.scrollBar, adj=-4}
	for i = 1, #_G.EncounterJournal.searchResults.scrollFrame.buttons do
		local btn = _G.EncounterJournal.searchResults.scrollFrame.buttons[i]
		self:removeRegions(btn, {1})
		btn:GetNormalTexture():SetAlpha(0)
		btn:GetPushedTexture():SetAlpha(0)
		self:addButtonBorder{obj=btn, relTo=btn.icon}
	end
-->>-- Nav Bar
	_G.EncounterJournal.navBar:DisableDrawLayer("BACKGROUND")
	_G.EncounterJournal.navBar:DisableDrawLayer("BORDER")
	_G.EncounterJournal.navBar.overlay:DisableDrawLayer("OVERLAY")
	_G.EncounterJournal.navBar.home:DisableDrawLayer("OVERLAY")
	_G.EncounterJournal.navBar.home:GetNormalTexture():SetAlpha(0)
	_G.EncounterJournal.navBar.home:GetPushedTexture():SetAlpha(0)
	_G.EncounterJournal.navBar.home.text:SetPoint("RIGHT", -20, 0)
-->>-- InstanceSelect frame
	_G.EncounterJournal.instanceSelect.bg:SetAlpha(0)
	self:skinDropDown{obj=_G.EJTierDropDown}
	self:skinSlider{obj=_G.EncounterJournal.instanceSelect.scroll.ScrollBar, adj=-6}
	self:addSkinFrame{obj=_G.EncounterJournal.instanceSelect.scroll, ft=ftype, ofs=6, x2=4}
	self:addButtonBorder{obj=_G.EncounterJournalInstanceSelectScrollDownButton, ofs=-2}
	-- Instance buttons
	for i = 1, 30 do
		local btn = _G.EncounterJournal.instanceSelect.scroll.child["instance" .. i]
		if btn then
			self:addButtonBorder{obj=btn, relTo=btn.bgImage, ofs=0}
		end
	end
	-- Tabs
	_G.EncounterJournal.instanceSelect.raidsTab:DisableDrawLayer("BACKGROUND")
	_G.EncounterJournal.instanceSelect.dungeonsTab:DisableDrawLayer("BACKGROUND")
-->>-- Encounter frame
	-- Instance frame
	local obj = _G.EncounterJournal.encounter.instance
	obj.loreBG:SetTexCoord(0.06, 0.70, 0.08, 0.58)
	obj.loreBG:SetWidth(370)
	obj.loreBG:SetHeight(315)
	self:moveObject{obj=obj.title, y=40}
	_G.EncounterJournal.encounter.instance:DisableDrawLayer("ARTWORK")
	self:moveObject{obj=obj.mapButton, x=-20, y=-20}
	self:addButtonBorder{obj=obj.mapButton, relTo=obj.mapButton.texture, x1=2, y1=-1, x2=-2, y2=1}
	self:skinSlider{obj=obj.loreScroll.ScrollBar, adj=-4}
	obj.loreScroll.child.lore:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:skinSlider{obj=_G.EncounterJournal.encounter.info.bossesScroll.ScrollBar, adj=-4}
	-- Boss/Creature buttons
	local function skinBossBtns()
		for i = 1, 30 do
			local btn = _G["EncounterJournalBossButton" .. i]
			if btn then
				btn:SetNormalTexture(nil)
				btn:SetPushedTexture(nil)
			end
		end
	end
	self:SecureHook("EncounterJournal_DisplayInstance", function(instanceID, noButton)
		skinBossBtns()
	end)
	-- skin any existing Boss Buttons
	skinBossBtns()
	-- Info frame
	_G.EncounterJournal.encounter.info:DisableDrawLayer("BACKGROUND")
	_G.EncounterJournal.encounter.info.encounterTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
	self:skinSlider{obj=_G.EncounterJournal.encounter.info.detailsScroll.ScrollBar, adj=-4}
	_G.EncounterJournal.encounter.info.detailsScroll.child.description:SetTextColor(self.BTr, self.BTg, self.BTb)
	_G.EncounterJournalEncounterFrameInfoResetButton:SetNormalTexture(nil)
	_G.EncounterJournalEncounterFrameInfoResetButton:SetPushedTexture(nil)
	_G.EncounterJournal.encounter.info.difficulty:SetNormalTexture(nil)
	_G.EncounterJournal.encounter.info.difficulty:SetPushedTexture(nil)
	_G.EncounterJournal.encounter.info.difficulty:DisableDrawLayer("BACKGROUND")
	-- Hook this to skin headers
	self:SecureHook("EncounterJournal_ToggleHeaders", function(this, doNotShift)
		for i = 1, 25 do
			local obj = _G["EncounterJournalInfoHeader" .. i]
			if obj then
				obj.button:DisableDrawLayer("BACKGROUND")
				obj.description:SetTextColor(self.BTr, self.BTg, self.BTb)
				obj.descriptionBG:SetAlpha(0)
				obj.descriptionBGBottom:SetAlpha(0)
				_G["EncounterJournalInfoHeader" .. i .. "HeaderButtonPortraitFrame"]:SetAlpha(0)
			end
		end
	end)
	-- Loot
	self:skinSlider{obj=_G.EncounterJournal.encounter.info.lootScroll.scrollBar, adj=-4}
	_G.EncounterJournal.encounter.info.lootScroll.filter:DisableDrawLayer("BACKGROUND")
	_G.EncounterJournal.encounter.info.lootScroll.filter:SetNormalTexture(nil)
	_G.EncounterJournal.encounter.info.lootScroll.filter:SetPushedTexture(nil)
	_G.EncounterJournal.encounter.info.lootScroll.classClearFilter:DisableDrawLayer("BACKGROUND")
	-- hook this to skin loot entries
	self:SecureHook("EncounterJournal_LootUpdate", function()
		for i = 1, #_G.EncounterJournal.encounter.info.lootScroll.buttons do
			local btn = _G.EncounterJournal.encounter.info.lootScroll.buttons[i]
			btn:DisableDrawLayer("BORDER")
			btn.armorType:SetTextColor(self.BTr, self.BTg, self.BTb)
			btn.slot:SetTextColor(self.BTr, self.BTg, self.BTb)
			btn.boss:SetTextColor(self.BTr, self.BTg, self.BTb)
			self:addButtonBorder{obj=btn, relTo=btn.icon}
		end

	end)
	-- Model Frame
	_G.EncounterJournal.encounter.info.model:DisableDrawLayer("BACKGROUND") -- dungeonBG (updated with dungeon type change)
	self:rmRegionsTex(_G.EncounterJournal.encounter.info.model, {2, 3}) -- Shadow, TitleBG
	local function skinCreatureBtn(idx)
		local btn = _G.EncounterJournal.encounter.info.creatureButtons[idx]
		if btn
		and not aObj.skinned[btn]
		then
			btn:SetNormalTexture(nil)
			local hTex = btn:GetHighlightTexture()
			hTex:SetTexture([[Interface\EncounterJournal\UI-EncounterJournalTextures]])
			hTex:SetTexCoord(0.68945313, 0.81054688, 0.33300781, 0.39257813)
		end
	end
	for i = 1, #_G.EncounterJournal.encounter.info.creatureButtons do
		skinCreatureBtn(i)
	end
	-- hook this to skin additional buttons
	self:SecureHook("EncounterJournal_GetCreatureButton", function(index)
		if index > 9 then return end -- MAX_CREATURES_PER_ENCOUNTER
		skinCreatureBtn(index)
	end)

	-- Tabs (side)
	for _, v in pairs{"bossTab", "lootTab", "modelTab"} do
		local obj = _G.EncounterJournal.encounter.info[v]
		obj:SetNormalTexture(nil)
		obj:SetPushedTexture(nil)
		if v ~= "modelTab" then
			obj:SetDisabledTexture(nil)
		else
			obj:GetDisabledTexture():SetAlpha(0) -- model tab texture is modified
		end
		self:addSkinFrame{obj=obj, ft=ftype, noBdr=true, ofs=-3, aso={rotate=true}} -- gradient is right to left
	end
	self:moveObject{obj=_G.EncounterJournal.encounter.info.bossTab, x=10}
	-- hide/show the texture to realign it on the tab
	_G.EncounterJournal.encounter.info.bossTab.unselected:Hide()
	_G.EncounterJournal.encounter.info.bossTab.unselected:Show()

end

function aObj:EquipmentFlyout()
	if not self.db.profile.EquipmentFlyout or self.initialized.EquipmentFlyout then return end
	self.initialized.EquipmentFlyout = true

	local btnFrame = _G.EquipmentFlyoutFrame.buttonFrame
	self:addSkinFrame{obj=btnFrame, ft=ftype, x1=-3, y1=2, x2=5, y2=-3}
	self:SecureHook("EquipmentFlyout_Show", function(...)
		for i = 1, btnFrame["numBGs"] do
			btnFrame["bg" .. i]:SetAlpha(0)
		end
		for i = 1, #_G.EquipmentFlyoutFrame.buttons do
			local btn = _G.EquipmentFlyoutFrame.buttons[i]
			if not btn.sbb then
				self:addButtonBorder{obj=btn, ibt=true}
				_G.RaiseFrameLevelByTwo(btn) -- make it appear above frame
			end
		end
	end)

end

function aObj:FriendsFrame()
	if not self.db.profile.FriendsFrame or self.initialized.FriendsFrame then return end
	self.initialized.FriendsFrame = true

	self:skinTabs{obj=_G.FriendsFrame, lod=true}
	self:addSkinFrame{obj=_G.FriendsFrame, ft=ftype, kfs=true, ri=true, y1=2, x2=1, y2=-5}

	self:skinDropDown{obj=_G.FriendsDropDown}
	self:skinDropDown{obj=_G.TravelPassDropDown}
	-- FriendsTabHeader Frame
	_G.FriendsFrameBattlenetFrame:DisableDrawLayer("BACKGROUND")
	self:addButtonBorder{obj=_G.FriendsFrameBattlenetFrame.BroadcastButton, ofs=-2}
	self:addSkinFrame{obj=_G.FriendsFrameBattlenetFrame.BroadcastFrame.ScrollFrame, kfs=true, ofs=4}
	self:addSkinFrame{obj=_G.FriendsFrameBattlenetFrame.BroadcastFrame, ofs=-10}
	self:addSkinFrame{obj=_G.FriendsFrameBattlenetFrame.UnavailableInfoFrame}
	self:skinDropDown{obj=_G.FriendsFrameStatusDropDown}
	_G.FriendsFrameStatusDropDownStatus:SetAlpha(1) -- display status icon
	self:skinEditBox{obj=_G.FriendsFrameBroadcastInput, regs={9, 10}, mi=true, noWidth=true, noHeight=true, noMove=true} -- region 10 is icon
	_G.FriendsFrameBroadcastInputFill:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:skinTabs{obj=_G.FriendsTabHeader, up=true, lod=true, x1=0, y1=-5, x2=0, y2=-5}
	self:addButtonBorder{obj=_G.FriendsTabHeaderRecruitAFriendButton}
	self:addButtonBorder{obj=_G.FriendsTabHeaderSoRButton}

	-- FriendsList Frame
	-- adjust width of FFFSF so it looks right (too thin by default)
	_G.FriendsFrameFriendsScrollFrameScrollBar:SetPoint("BOTTOMLEFT", _G.FriendsFrameFriendsScrollFrame, "BOTTOMRIGHT", -4, 14)
	self:skinScrollBar{obj=_G.FriendsFrameFriendsScrollFrame}

	for i = 1, _G.FRIENDS_FRIENDS_TO_DISPLAY do
		local btn = _G["FriendsFrameFriendsScrollFrameButton" .. i]
		btn.background:SetAlpha(0)
		self:addButtonBorder{obj=btn, relTo=btn.gameIcon, hide=true, ofs=0}
		self:addButtonBorder{obj=btn.travelPassButton, hide=true, disable=true, ofs=0, y1=3, y2=-2}
		self:addButtonBorder{obj=btn.summonButton, hide=true, disable=true}
	end

	-- Friends Tooltip
	self:addSkinFrame{obj=_G.FriendsTooltip}

-->>-- Add Friend Frame
	self:addSkinFrame{obj=_G.AddFriendFrame, kfs=true}
	self:skinEditBox{obj=_G.AddFriendNameEditBox, regs={9}}
	self:addSkinFrame{obj=_G.AddFriendNoteFrame, kfs=true}
	self:skinScrollBar{obj=_G.AddFriendNoteFrameScrollFrame}

-->>-- FriendsFriends Frame
	self:skinDropDown{obj=_G.FriendsFriendsFrameDropDown}
	self:addSkinFrame{obj=_G.FriendsFriendsList, ft=ftype}
	self:skinScrollBar{obj=_G.FriendsFriendsScrollFrame}
	self:addSkinFrame{obj=_G.FriendsFriendsNoteFrame, kfs=true, ft=ftype}
	self:addSkinFrame{obj=_G.FriendsFriendsFrame, ft=ftype}

-->>--	IgnoreList Frame
	self:keepFontStrings(_G.IgnoreListFrame)
	self:skinScrollBar{obj=_G.FriendsFrameIgnoreScrollFrame}

-->>--	PendingList Frame
	self:keepFontStrings(_G.PendingListFrame)
	self:skinDropDown{obj=_G.PendingListFrameDropDown}
	self:skinSlider{obj=_G.FriendsFramePendingScrollFrame.scrollBar}
	for i = 1, _G.PENDING_INVITES_TO_DISPLAY do
		local btn = "FriendsFramePendingButton" .. i
		-- use ApplySkin otherwise panel & buttons are hidden
		self:removeRegions(_G[btn .. "AcceptButton"], {1, 2, 3})
		self:applySkin{obj=_G[btn .. "AcceptButton"]}
		self:removeRegions(_G[btn .. "DeclineButton"], {1, 2, 3})
		self:applySkin{obj=_G[btn .. "DeclineButton"]}
		self:applySkin{obj=_G[btn]}
	end

-->>--	Who Tab Frame
	self:removeInset(_G.WhoFrameListInset)
	self:skinFFColHeads("WhoFrameColumnHeader")
	self:removeInset(_G.WhoFrameEditBoxInset)
	self:skinDropDown{obj=_G.WhoFrameDropDown, noSkin=true}
	self:addButtonBorder{obj=_G.WhoFrameDropDownButton, es=12, ofs=-1}
	self:moveObject{obj=_G.WhoFrameDropDownButton, x=5}
	self:skinScrollBar{obj=_G.WhoListScrollFrame}
	self:skinEditBox{obj=_G.WhoFrameEditBox, move=true}
	_G.WhoFrameEditBox:SetWidth(_G.WhoFrameEditBox:GetWidth() +  24)
	self:moveObject{obj=_G.WhoFrameEditBox, x=12}

-->>--	Channel Tab Frame
	self:keepFontStrings(_G.ChannelFrame)
	self:removeInset(_G.ChannelFrameLeftInset)
	self:removeInset(_G.ChannelFrameRightInset)
	self:skinButton{obj=_G.ChannelFrameNewButton}
	-- hook this to skin channel buttons
	self:SecureHook("ChannelList_Update", function()
		for i = 1, _G.MAX_CHANNEL_BUTTONS do
			_G["ChannelButton" .. i .. "NormalTexture"]:SetAlpha(0)
		end
	end)
	self:skinScrollBar{obj=_G.ChannelListScrollFrame}
	self:skinScrollBar{obj=_G.ChannelRosterScrollFrame}
	-- Channel Pullout Tab & Frame
	self:keepRegions(_G.ChannelPulloutTab, {4, 5}) -- N.B. region 4 is text, 5 is highlight
	self:addSkinFrame{obj=_G.ChannelPulloutTab, ft=ftype, noBdr=aObj.isTT, y1=-8, y2=-5}
	self:addSkinFrame{obj=_G.ChannelPulloutBackground, ft=ftype, nb=true}
	self:skinButton{obj=_G.ChannelPulloutCloseButton, cb=true}
	_G.RaiseFrameLevel(_G.ChannelPulloutCloseButton) -- bring above Background frame
	self:addButtonBorder{obj=_G.ChannelPulloutRosterScrollUpBtn, ofs=-2}
	self:addButtonBorder{obj=_G.ChannelPulloutRosterScrollDownBtn, ofs=-2}
-->>--	Daughter Frame
	self:skinEditBox{obj=_G.ChannelFrameDaughterFrameChannelName, regs={9}, noWidth=true}
	self:skinEditBox{obj=_G.ChannelFrameDaughterFrameChannelPassword, regs={9, 10}, noWidth=true}
	self:moveObject{obj=_G.ChannelFrameDaughterFrameOkayButton, x=-2}
	self:addSkinFrame{obj=_G.ChannelFrameDaughterFrame, ft=ftype, kfs=true, x1=2, y1=-6, x2=-5}
	self:skinDropDown{obj=_G.ChannelListDropDown}
	self:skinDropDown{obj=_G.ChannelRosterDropDown}

-->>--	Raid Tab Frame
	self:skinButton{obj=_G.RaidFrameConvertToRaidButton}
	self:skinButton{obj=_G.RaidFrameRaidInfoButton}
	if _G.IsAddOnLoaded("Blizzard_RaidUI") then self:RaidUI() end

-->>--	RaidInfo Frame
	self:addSkinFrame{obj=_G.RaidInfoInstanceLabel, kfs=true}
	self:addSkinFrame{obj=_G.RaidInfoIDLabel, kfs=true}
	self:skinSlider{obj=_G.RaidInfoScrollFrame.scrollBar}
	self:addSkinFrame{obj=_G.RaidInfoFrame, ft=ftype, kfs=true, hdr=true}

-->>-- BattleTagInvite Frame
	self:addSkinFrame{obj=_G.BattleTagInviteFrame}

end

function aObj:GhostFrame()
	if not self.db.profile.GhostFrame or self.initialized.GhostFrame then return end
	self.initialized.GhostFrame = true

	self:addButtonBorder{obj=_G.GhostFrameContentsFrame, relTo=_G.GhostFrameContentsFrameIcon}
	self:addSkinButton{obj=_G.GhostFrame, parent=_G.GhostFrame, kfs=true, sap=true, hide=true, ft=ftype}
	_G.GhostFrame:SetFrameStrata("HIGH") -- make it appear above other frames (i.e. Corkboard)

end

function aObj:GlyphUI() -- LoD
	if not self.db.profile.TalentUI or self.initialized.GlyphUI then return end
	self.initialized.GlyphUI = true

	_G.GlyphFrame:DisableDrawLayer("BACKGROUND")
	_G.GlyphFrame.specRing:SetTexture(nil)
	self:removeInset(_G.GlyphFrame.sideInset)
	self:skinEditBox{obj=_G.GlyphFrameSearchBox, regs={9}, mi=true, noHeight=true, noMove=true}
	self:skinDropDown{obj=_G.GlyphFrameFilterDropDown}
	-- Headers
	for i = 1, #_G.GLYPH_STRING do
		self:removeRegions(_G["GlyphFrameHeader" .. i], {1, 2, 3})
		self:applySkin{obj=_G["GlyphFrameHeader" .. i], ft=ftype, nb=true} -- use applySkin so text is seen
	end
	-- remove Glyph item textures
	for i = 1, #_G.GlyphFrame.scrollFrame.buttons do
		local btn = _G.GlyphFrame.scrollFrame.buttons[i]
		btn:GetNormalTexture():SetAlpha(0)
		btn.selectedTex:SetAlpha(0)
		btn.disabledBG:SetAlpha(0)
		self:addButtonBorder{obj=btn, relTo=btn.icon}
	end
	self:skinSlider{obj=_G.GlyphFrameScrollFrameScrollBar, adj=-4}
	self:addButtonBorder{obj=_G.GlyphFrameClearInfoFrame}

end

function aObj:GuildControlUI() -- LoD
	if not self.db.profile.GuildControlUI or self.initialized.GuildControlUI then return end
	self.initialized.GuildControlUI = true

	_G.GuildControlUI:DisableDrawLayer("BACKGROUND")
	_G.GuildControlUIHbar:SetAlpha(0)
	self:skinDropDown{obj=_G.GuildControlUI.dropdown}
	_G.UIDropDownMenu_SetButtonWidth(_G.GuildControlUI.dropdown, 24)
	self:addSkinFrame{obj=_G.GuildControlUI, ft=ftype, kfs=true, x1=10, y1=-10, x2=-10, y2=10}
	-- Guild Ranks Panel
	local function skinROFrames()

		local obj
		for i = 1, _G.MAX_GUILDRANKS do
			local obj = _G["GuildControlUIRankOrderFrameRank" .. i]
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
	_G.GuildControlUI.rankPermFrame:DisableDrawLayer("BACKGROUND")
	self:skinDropDown{obj=_G.GuildControlUI.rankPermFrame.dropdown}
	_G.UIDropDownMenu_SetButtonWidth(_G.GuildControlUI.rankPermFrame.dropdown, 24)
	self:skinEditBox{obj=_G.GuildControlUI.rankPermFrame.goldBox, regs={9}}
	-- Bank Tab Permissions panel
	self:keepFontStrings(_G.GuildControlUI.bankTabFrame.scrollFrame)
	self:skinSlider{obj=_G.GuildControlUIRankBankFrameInsetScrollFrameScrollBar}
	self:skinDropDown{obj=_G.GuildControlUI.bankTabFrame.dropdown}
	_G.UIDropDownMenu_SetButtonWidth(_G.GuildControlUI.bankTabFrame.dropdown, 24)
	_G.GuildControlUI.bankTabFrame.inset:DisableDrawLayer("BACKGROUND")
	_G.GuildControlUI.bankTabFrame.inset:DisableDrawLayer("BORDER")
	-- hook this as buttons are created as required
	self:SecureHook("GuildControlUI_BankTabPermissions_Update", function(this)
		-- self:Debug("GuildControlUI_BankTabPermissions_Update: [%s]", this)
		for i = 1, _G.MAX_BUY_GUILDBANK_TABS do
			local btn = _G["GuildControlBankTab" .. i]
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
	self:removeInset(_G.GuildFrameBottomInset)
	self:skinDropDown{obj=_G.GuildDropDown}
	_G.GuildLevelFrame:DisableDrawLayer("BACKGROUND")
	-- XP Bar
	_G.GuildXPBar:DisableDrawLayer("BORDER")
	_G.GuildXPBarProgress:SetTexture(self.sbTexture)
	_G.GuildXPBarShadow:SetAlpha(0)
	_G.GuildXPBarCap:SetTexture(self.sbTexture)
	_G.GuildXPBarCapMarker:SetAlpha(0)
	-- Faction Bar
	_G.GuildFactionBar:DisableDrawLayer("BORDER")
	_G.GuildFactionBarProgress:SetTexture(self.sbTexture)
	_G.GuildFactionBarShadow:SetAlpha(0)
	_G.GuildFactionBarCap:SetTexture(self.sbTexture)
	_G.GuildFactionBarCapMarker:SetAlpha(0)
	self:keepRegions(_G.GuildFrame, {8, 19, 20, 18, 21, 22}) -- regions 8, 19, 20 are text, 18, 21 & 22 are tabard
	self:moveObject{obj=_G.GuildFrameTabardBackground, x=8, y=-11}
	self:moveObject{obj=_G.GuildFrameTabardEmblem, x=9, y=-12}
	self:moveObject{obj=_G.GuildFrameTabardBorder, x=7, y=-10}
	self:skinTabs{obj=_G.GuildFrame, lod=true}
	self:addSkinFrame{obj=_G.GuildFrame, ft=ftype, ri=true, x1=-3, y1=2, x2=1, y2=-5}
	self:removeMagicBtnTex(_G.GuildAddMemberButton)
	self:removeMagicBtnTex(_G.GuildControlButton)
	self:removeMagicBtnTex(_G.GuildViewLogButton)
	-- GuildMain Frame
	_G.GuildPerksToggleButton:DisableDrawLayer("BACKGROUND")
	_G.GuildNewPerksFrame:DisableDrawLayer("BACKGROUND")
	_G.GuildUpdatesNoNews:SetTextColor(self.BTr, self.BTg, self.BTb)
	_G.GuildUpdatesDivider:SetAlpha(0)
	_G.GuildUpdatesNoEvents:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:removeRegions(_G.GuildLatestPerkButton, {2, 5, 6}) -- region 2 is NameFrame, 5-6 are borders
	self:addButtonBorder{obj=_G.GuildLatestPerkButton, libt=true}
	_G.GuildNextPerkButtonNameFrame:SetTexture(nil)
	self:addButtonBorder{obj=_G.GuildNextPerkButton, libt=true, reParent={_G.GuildNextPerkButtonLockTexture}}
	_G.GuildAllPerksFrame:DisableDrawLayer("BACKGROUND")
	self:skinSlider{obj=_G.GuildPerksContainer.ScrollBar, adj=-6}
	for i = 1, #_G.GuildPerksContainer.buttons do
		-- can't use DisableDrawLayer as the update code uses it
		local btn = _G.GuildPerksContainer.buttons[i]
		self:removeRegions(btn, {1, 2, 3, 4, 5, 6})
		self:addButtonBorder{obj=btn, relTo=btn.icon, reParent={btn.lock}}
	end
	self:skinEditBox{obj=_G.GuildNameChangeFrame.editBox, regs={9}}

-->>-- GuildRoster Frame
	self:skinDropDown{obj=_G.GuildRosterViewDropdown}
	self:skinFFColHeads("GuildRosterColumnButton", 5)
	self:skinSlider{obj=_G.GuildRosterContainerScrollBar, adj=-4}
	for i = 1, #_G.GuildRosterContainer.buttons do
		local btn = _G.GuildRosterContainer.buttons[i]
		btn:DisableDrawLayer("BACKGROUND")
		btn.barTexture:SetTexture(self.sbTexture)
		btn.header.leftEdge:SetAlpha(0)
		btn.header.rightEdge:SetAlpha(0)
		btn.header.middle:SetAlpha(0)
		self:applySkin{obj=btn.header}
		self:addButtonBorder{obj=btn, relTo=btn.icon, hide=true, es=12}
	end
	self:skinDropDown{obj=_G.GuildMemberRankDropdown}
	-- adjust text position & font so it overlays correctly
	self:moveObject{obj=_G.GuildMemberRankDropdown, x=-6, y=2}
	_G.GuildMemberRankDropdownText:SetFontObject(_G.GameFontHighlight)
	self:addSkinFrame{obj=_G.GuildMemberNoteBackground, ft=ftype}
	self:addSkinFrame{obj=_G.GuildMemberOfficerNoteBackground, ft=ftype}
	self:addSkinFrame{obj=_G.GuildMemberDetailFrame, ft=ftype, kfs=true, nb=true, ofs=-6}

-->>-- GuildNews Frame
	_G.GuildNewsFrame:DisableDrawLayer("BACKGROUND")
	self:skinSlider{obj=_G.GuildNewsContainerScrollBar, adj=-6}
	for i = 1, #_G.GuildNewsContainer.buttons do
		_G.GuildNewsContainer.buttons[i].header:SetAlpha(0)
	end
	self:skinDropDown{obj=_G.GuildNewsDropDown}
	self:addSkinFrame{obj=_G.GuildNewsFiltersFrame, ft=ftype, kfs=true, ofs=-7}
	self:keepFontStrings(_G.GuildNewsBossModelTextFrame)
	self:addSkinFrame{obj=_G.GuildNewsBossModel, ft=ftype, kfs=true, ofs=4, y2=-81} -- similar to QuestNPCModel
	-- Rewards Panel
	_G.GuildRewardsFrame:DisableDrawLayer("BACKGROUND")
	self:skinSlider{obj=_G.GuildRewardsContainerScrollBar, adj=-4}
	for i = 1, #_G.GuildRewardsContainer.buttons do
		local btn = _G.GuildRewardsContainer.buttons[i]
		btn:GetNormalTexture():SetAlpha(0)
		btn.disabledBG:SetAlpha(0)
		self:addButtonBorder{obj=btn, relTo=btn.icon, reParent={btn.lock}}
	end
	self:skinDropDown{obj=_G.GuildRewardsDropDown}

-->>-- GuildInfo Frame
	self:removeRegions(_G.GuildInfoFrame, {1, 2, 3, 4, 5, 6 ,7, 8}) -- Background textures and bars
	self:skinTabs{obj=_G.GuildInfoFrame, up=true, lod=true, x1=2, y1=-5, x2=2, y2=-5}
	-- GuildInfoFrameInfo Frame
	self:keepFontStrings(_G.GuildInfoFrameInfo)
	self:skinSlider{obj=_G.GuildInfoDetailsFrameScrollBar, adj=-4}
	-- GuildInfoFrameRecruitment Frame
	_G.GuildRecruitmentInterestFrameBg:SetAlpha(0)
	_G.GuildRecruitmentAvailabilityFrameBg:SetAlpha(0)
	_G.GuildRecruitmentRolesFrameBg:SetAlpha(0)
	_G.GuildRecruitmentLevelFrameBg:SetAlpha(0)
	_G.GuildRecruitmentCommentFrameBg:SetAlpha(0)
	self:skinSlider{obj=_G.GuildRecruitmentCommentInputFrameScrollFrame.ScrollBar}
	_G.GuildRecruitmentCommentEditBoxFill:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:addSkinFrame{obj=_G.GuildRecruitmentCommentInputFrame, ft=ftype, kfs=true}
	self:removeMagicBtnTex(_G.GuildRecruitmentListGuildButton)
	-- GuildInfoFrameApplicants Frame
	for i = 1, #_G.GuildInfoFrameApplicantsContainer.buttons do
		local btn = _G.GuildInfoFrameApplicantsContainer.buttons[i]
		self:applySkin{obj=btn}
		btn.ring:SetAlpha(0)
		btn.PointsSpentBgGold:SetAlpha(0)
		self:moveObject{obj=btn.PointsSpentBgGold, x=6, y=-6}
	end
	self:skinSlider{obj=_G.GuildInfoFrameApplicantsContainerScrollBar, adj=-4}
	self:removeMagicBtnTex(_G.GuildRecruitmentInviteButton)
	self:removeMagicBtnTex(_G.GuildRecruitmentDeclineButton)
	self:removeMagicBtnTex(_G.GuildRecruitmentMessageButton)
	-- Guild Text Edit frame
	self:skinSlider{obj=_G.GuildTextEditScrollFrameScrollBar, adj=-6}
	self:addSkinFrame{obj=_G.GuildTextEditContainer, ft=ftype, nb=true}
	self:addSkinFrame{obj=_G.GuildTextEditFrame, ft=ftype, kfs=true, nb=true, ofs=-7}
	-- Guild Log Frame
	self:skinSlider{obj=_G.GuildLogScrollFrame.ScrollBar, adj=-6}
	self:addSkinFrame{obj=_G.GuildLogContainer, ft=ftype, nb=true}
	self:addSkinFrame{obj=_G.GuildLogFrame, ft=ftype, kfs=true, nb=true, ofs=-7}

end

function aObj:GuildInvite()
	if not self.db.profile.GuildInvite or self.initialized.GuildInvite then return end
	self.initialized.GuildInvite = true

	self:keepFontStrings(_G.GuildInviteFrameLevel)
	_G.GuildInviteFrame:DisableDrawLayer("BACKGROUND")
	_G.GuildInviteFrame:DisableDrawLayer("BORDER")
	_G.GuildInviteFrameTabardBorder:SetTexture(nil)
	_G.GuildInviteFrame:DisableDrawLayer("OVERLAY")
	self:addSkinFrame{obj=_G.GuildInviteFrame, ft=ftype}

end

function aObj:InspectUI() -- LoD
	if not self.db.profile.InspectUI or self.initialized.InspectUI then return end
	self.initialized.InspectUI = true

	self:skinTabs{obj=_G.InspectFrame, lod=true}
	self:addSkinFrame{obj=_G.InspectFrame, ft=ftype, kfs=true, ri=true, y1=2, x2=1, y2=-5}

-->>-- Inspect PaperDoll frame
	-- Inspect Model Frame
	_G.InspectModelFrame.controlFrame:DisableDrawLayer("BACKGROUND")
	for _, child in ipairs{_G.InspectPaperDollItemsFrame:GetChildren()} do
		child:DisableDrawLayer("BACKGROUND")
		-- add button borders
		if child:IsObjectType("Button") and self:hasTextInName(child, "Slot") then
			self:addButtonBorder{obj=child, ibt=true}
		end
	end
	_G.InspectModelFrame:DisableDrawLayer("BACKGROUND")
	_G.InspectModelFrame:DisableDrawLayer("BORDER")
	_G.InspectModelFrame:DisableDrawLayer("OVERLAY")

-->>-- PVP Frame
	self:keepFontStrings(_G.InspectPVPFrame)

-->>-- Talent Frame
	self:keepFontStrings(_G.InspectTalentFrame)
	-- Specialization
	_G.InspectTalentFrame.InspectSpec.ring:SetTexture(nil)
	-- Talents
	for i = 1, 6 do
		for j = 1, 3 do
			local btn = _G.InspectTalentFrame.InspectTalents["tier" .. i]["talent" .. j]
			btn.border:SetTexture(nil)
			self:addButtonBorder{obj=btn, relTo=btn.icon}
		end
	end
	-- Glyphs
	for i = 1, 6 do
		_G.InspectTalentFrame.InspectGlyphs["Glyph" .. i].ring:SetTexture(nil)
	end

-->>-- Guild Frame
	_G.InspectGuildFrameBG:SetAlpha(0)

	-- send message when UI is skinned (used by oGlow skin)
	self:SendMessage("InspectUI_Skinned", self)

end

function aObj:ItemSocketingUI() -- LoD
	if not self.db.profile.ItemSocketingUI or self.initialized.ItemSocketingUI then return end
	self.initialized.ItemSocketingUI = true

	local colour
	local function colourSockets()

		for i = 1, _G.GetNumSockets() do
			local c = _G.GEM_TYPE_INFO[_G.GetSocketTypes(i)]
			_G["ItemSocketingSocket" .. i].sb:SetBackdropBorderColor(c.r, c.g, c.b)
		end

	end
	-- hook this to colour the button border
	self:SecureHook("ItemSocketingFrame_Update", function()
		colourSockets()
	end)

	self:addSkinFrame{obj=_G.ItemSocketingFrame, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-2}
	self:skinScrollBar{obj=_G.ItemSocketingScrollFrame}

	for i = 1, _G.MAX_NUM_SOCKETS do
		local objName = "ItemSocketingSocket" .. i
		_G[objName .. "Left"]:SetAlpha(0)
		_G[objName .. "Right"]:SetAlpha(0)
		local obj = _G[objName]
		self:getRegion(obj, 3):SetAlpha(0) -- button texture
		self:addSkinButton{obj=obj, ft=ftype}
	end
	-- now colour the sockets
	colourSockets()

end

function aObj:LookingForGuildUI() -- LoD
	if not self.db.profile.LookingForGuildUI or self.initialized.LookingForGuildUI then return end
	self.initialized.LookingForGuildUI = true

	self:skinTabs{obj=_G.LookingForGuildFrame, up=true, lod=true, x1=0, y1=-5, x2=3, y2=-5}
	self:addSkinFrame{obj=_G.LookingForGuildFrame, ft=ftype, kfs=true, ri=true, y1=2, x2=1}

	-- Start Frame (Settings)
	_G.LookingForGuildInterestFrameBg:SetAlpha(0)
	_G.LookingForGuildAvailabilityFrameBg:SetAlpha(0)
	_G.LookingForGuildRolesFrameBg:SetAlpha(0)
	_G.LookingForGuildCommentFrameBg:SetAlpha(0)
	self:skinScrollBar{obj=_G.LookingForGuildCommentInputFrameScrollFrame}
	self:addSkinFrame{obj=_G.LookingForGuildCommentInputFrame, ft=ftype, kfs=true, ofs=-1}
	_G.LookingForGuildCommentEditBoxFill:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:removeMagicBtnTex(_G.LookingForGuildBrowseButton)

	-- Browse Frame
	self:skinSlider{obj=_G.LookingForGuildBrowseFrameContainerScrollBar, adj=-4}
	for i = 1, #_G.LookingForGuildBrowseFrameContainer.buttons do
		local btn = _G.LookingForGuildBrowseFrameContainer.buttons[i]
		self:applySkin{obj=btn}
		_G[btn:GetName() .. "Ring"]:SetAlpha(0)
		btn.PointsSpentBgGold:SetAlpha(0)
		self:moveObject{obj=btn.PointsSpentBgGold, x=6, y=-6}
	end
	self:removeMagicBtnTex(_G.LookingForGuildRequestButton)

	-- Apps Frame (Requests)
	self:skinSlider{obj=_G.LookingForGuildAppsFrameContainerScrollBar}
	for i = 1, #_G.LookingForGuildAppsFrameContainer.buttons do
		local btn = _G.LookingForGuildAppsFrameContainer.buttons[i]
		self:applySkin{obj=btn}
	end

	-- Request Membership Frame
	_G.GuildFinderRequestMembershipEditBoxFill:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:skinScrollBar{obj=_G._G.GuildFinderRequestMembershipFrameInputFrameScrollFrame}
	self:addSkinFrame{obj=_G.GuildFinderRequestMembershipFrameInputFrame, ft=ftype, x1=-2, x2=2, y2=-2}
	self:addSkinFrame{obj=_G.GuildFinderRequestMembershipFrame, ft=ftype}

end

function aObj:LootFrames()
	if not self.db.profile.LootFrames.skin or self.initialized.LootFrames then return end
	self.initialized.LootFrames = true

	-- Add another loot button and move them all up to fit if FramesResized isn't loaded
	if not _G.IsAddOnLoaded("FramesResized") then
		local yOfs = -27
		for i = 1, _G.LOOTFRAME_NUMBUTTONS do
			local btn = _G["LootButton" .. i]
			btn:ClearAllPoints()
			btn:SetPoint("TOPLEFT", 9, yOfs)
			yOfs = yOfs - 41
		end
		_G.CreateFrame("Button", "LootButton5", _G.LootFrame, "LootButtonTemplate")
		_G.LootButton5:SetPoint("TOPLEFT", 9, yOfs)
		_G.LootButton5.id = 5
		_G.LOOTFRAME_NUMBUTTONS = 5
	end

	for i = 1, _G.LOOTFRAME_NUMBUTTONS do
		_G["LootButton" .. i .. "NameFrame"]:SetTexture(nil)
		self:addButtonBorder{obj=_G["LootButton" .. i], ibt=true}
	end
	self:addSkinFrame{obj=_G.LootFrame, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-2}
	self:addButtonBorder{obj=_G.LootFrameDownButton, ofs=-2}
	self:addButtonBorder{obj=_G.LootFrameUpButton, ofs=-2}

-->>-- GroupLoot frames
	for i = 1, _G.NUM_GROUP_LOOT_FRAMES do

		local obj = _G["GroupLootFrame" .. i]
		self:keepFontStrings(obj)
		obj.Timer.Background:SetAlpha(0)
		self:glazeStatusBar(obj.Timer, 0,  nil)
		-- hook this to show the Timer
		self:SecureHook(obj, "Show", function(this)
			this.Timer:SetFrameLevel(this:GetFrameLevel() + 1)
		end)

		if self.db.profile.LootFrames.size == 1 then

			obj.IconFrame.Border:SetAlpha(0)
			self:addSkinFrame{obj=obj, ft=ftype, x1=-3, y2=-3} -- adjust for Timer

		elseif self.db.profile.LootFrames.size == 2 then

			obj.IconFrame.Border:SetAlpha(0)
			obj:SetScale(0.75)
			self:addSkinFrame{obj=obj, ft=ftype, x1=-3, y2=-3} -- adjust for Timer

		elseif self.db.profile.LootFrames.size == 3 then

			obj:SetScale(0.75)
			self:moveObject{obj=obj.IconFrame, x=95, y=5}
			obj.Name:SetAlpha(0)
			obj.NeedButton:ClearAllPoints()
			obj.NeedButton:SetPoint("TOPRIGHT", "$parent", "TOPRIGHT", -34, -4)
			obj.PassButton:ClearAllPoints()
			obj.PassButton:SetPoint("LEFT", obj.NeedButton, "RIGHT", 0, 2)
			obj.GreedButton:ClearAllPoints()
			obj.GreedButton:SetPoint("RIGHT", obj.NeedButton, "LEFT")
			obj.DisenchantButton:ClearAllPoints()
			obj.DisenchantButton:SetPoint("RIGHT", obj.GreedButton, "LEFT", 2, 0)
			self:adjWidth{obj=obj.Timer, adj=-30}
			obj.Timer:ClearAllPoints()
			obj.Timer:SetPoint("BOTTOMRIGHT", "$parent", "BOTTOMRIGHT", -10, 13)
			self:addSkinFrame{obj=obj, ft=ftype--[=[, bg=true--]=], x1=97, y2=8}

		end

	end

-->>-- BonusRoll Frame
	self:removeRegions(_G.BonusRollFrame, {1, 2, 3, 5})
	self:glazeStatusBar(_G.BonusRollFrame.PromptFrame.Timer, 0,  nil)
	self:addSkinFrame{obj=_G.BonusRollFrame, ft=ftype, bg=true}
	self:addButtonBorder{obj=_G.BonusRollFrame.PromptFrame, relTo=_G.BonusRollFrame.PromptFrame.Icon, reParent={_G.BonusRollFrame.SpecIcon}}

	-- N.B. BonusRollLootWonFrame & BonusRollMoneyWonFrame are managed as part of the Alert Frames skin

-->>-- MissingLoot frame
	self:addSkinFrame{obj=_G.MissingLootFrame, ft=ftype, kfs=true, x1=0, y1=-4, x2=-4, y2=-5}
	for i = 1, _G.MissingLootFrame.numShownItems do
		_G["MissingLootFrameItem" .. i .. "NameFrame"]:SetAlpha(0)
		self:addButtonBorder{obj=_G["MissingLootFrameItem" .. i], ibt=true}
	end

-->>-- MasterLooter Frame
	_G.MasterLooterFrame.Item.NameBorderLeft:SetTexture(nil)
	_G.MasterLooterFrame.Item.NameBorderRight:SetTexture(nil)
	_G.MasterLooterFrame.Item.NameBorderMid:SetTexture(nil)
	_G.MasterLooterFrame.Item.IconBorder:SetTexture(nil)
	self:addButtonBorder{obj=_G.MasterLooterFrame, relTo=_G.MasterLooterFrame.Icon}
	_G.MasterLooterFrame.player1.Bg:SetTexture(nil)
	_G.MasterLooterFrame:DisableDrawLayer("BACKGROUND")
	self:addSkinFrame{obj=_G.MasterLooterFrame, ft=ftype, kfs=true, nb=true}
	self:skinButton{obj=self:getChild(_G.MasterLooterFrame, 3), cb=true}

end

function aObj:LootHistory()
	if not self.db.profile.LootHistory or self.initialized.LootHistory then return end
	self.initialized.LootHistory = true

	local function skinItemFrames(obj)

		for i = 1, #obj.itemFrames do
			local item = obj.itemFrames[i]
			item.Divider:SetTexture(nil)
			item.NameBorderLeft:SetTexture(nil)
			item.NameBorderRight:SetTexture(nil)
			item.NameBorderMid:SetTexture(nil)
			item.ActiveHighlight:SetTexture(nil)
			if aObj.modBtns then
				if not item.ToggleButton.sb then
					aObj:skinButton{obj=item.ToggleButton, ft=ftype, mp=true, plus=true}
					aObj:SecureHook(item.ToggleButton, "SetNormalTexture", function(this, nTex)
						aObj.modUIBtns:checkTex{obj=this, nTex=nTex}
					end)
				end
			end
		end

	end
	self:skinScrollBar{obj=_G.LootHistoryFrame.ScrollFrame}
	_G.LootHistoryFrame.ScrollFrame.ScrollBarBackground:SetTexture(nil)
	_G.LootHistoryFrame.Divider:SetTexture(nil)
	_G.LootHistoryFrame:DisableDrawLayer("BACKGROUND")
	self:addSkinFrame{obj=_G.LootHistoryFrame, ft=ftype, kfs=true}
	-- hook this to skin loot history items
	self:SecureHook("LootHistoryFrame_FullUpdate", function(this)
		skinItemFrames(this)
	end)
	-- skin existing itemFrames
	skinItemFrames(_G.LootHistoryFrame)

	-- LootHistoryDropDown
	self:skinDropDown{obj=_G.LootHistoryDropDown}

end

function aObj:MirrorTimers()
	if not self.db.profile.MirrorTimers.skin or self.initialized.MirrorTimers then return end
	self.initialized.MirrorTimers = true

	for i = 1, _G.MIRRORTIMER_NUMTIMERS do
		local objName = "MirrorTimer" .. i
		local obj = _G[objName]
		local objBG = self:getRegion(obj, 1)
		local objSB = _G[objName .. "StatusBar"]
		self:removeRegions(obj, {3})
		obj:SetHeight(obj:GetHeight() * 1.25)
		self:moveObject{obj=_G[objName .. "Text"], y=-2}
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
				_G[timer.bar:GetName() .. "Border"]:SetTexture(nil) -- animations
				aObj:glazeStatusBar(timer.bar, 0, bg)
				aObj:moveObject{obj=bg, y=2} -- align bars
			end
		end

	end
	self:SecureHookScript(_G.TimerTracker, "OnEvent", function(this, event, ...)
		-- self:Debug("TT_OE: [%s, %s]", this, event)
		if event == "START_TIMER" then
			skinTT(this)
		end
	end)
	-- skin existing timers
	skinTT(_G.TimerTracker)

end

function aObj:OverrideActionBar()
	if not self.db.profile.OverrideActionBar  or self.initialized.OverrideActionBar then return end
	self.initialized.OverrideActionBar = true

	local sf
	local function skinOverrideActionBar(opts)

		local oabW = _G.OverrideActionBar:GetWidth()
		-- aObj:Debug("sOAB: [%s, %s, %s]", opts.src, opts.st or "nil", oabW)

		local xOfs1 = 144
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
		local yOfs1 = 6
		local yOfs2 = -2
		local xOfs2 = (xOfs1 * -1) + 2

		-- remove all textures
		_G.OverrideActionBar:DisableDrawLayer("OVERLAY")
		_G.OverrideActionBar:DisableDrawLayer("BACKGROUND")
		_G.OverrideActionBar:DisableDrawLayer("BORDER")

		-- PitchFrame
		_G.OverrideActionBar.pitchFrame.Divider1:SetTexture(nil)
		_G.OverrideActionBar.pitchFrame.PitchOverlay:SetTexture(nil)
		_G.OverrideActionBar.pitchFrame.PitchButtonBG:SetTexture(nil)

		-- LeaveFrame
		_G.OverrideActionBar.leaveFrame.Divider3:SetTexture(nil)
		_G.OverrideActionBar.leaveFrame.ExitBG:SetTexture(nil)

		-- ExpBar
		_G.OverrideActionBar.xpBar.XpMid:SetTexture(nil)
		_G.OverrideActionBar.xpBar.XpL:SetTexture(nil)
		_G.OverrideActionBar.xpBar.XpR:SetTexture(nil)
		for i = 1, 19 do
			_G.OverrideActionBar.xpBar["XpDiv" .. i]:SetTexture(nil)
		end
		aObj:glazeStatusBar(_G.OverrideActionBar.xpBar, 0,  self:getRegion(_G.OverrideActionBar.xpBar, 1))

		sf = sf or aObj:addSkinFrame{obj=_G.OverrideActionBar, ft=ftype}
		sf:ClearAllPoints()
		sf:SetPoint("TOPLEFT", _G.OverrideActionBar, "TOPLEFT", xOfs1, yOfs1)
		sf:SetPoint("BOTTOMRIGHT", _G.OverrideActionBar, "BOTTOMRIGHT", xOfs2, yOfs2)

	end

	self:SecureHook(_G.OverrideActionBar, "Show", function(this, ...)
		skinOverrideActionBar{src=1}
	end)
	self:SecureHook("OverrideActionBar_SetSkin", function(skin)
		skinOverrideActionBar{src=2, st=skin}
	end)

	if _G.OverrideActionBar:IsShown() then skinOverrideActionBar{src=3} end

	self:addButtonBorder{obj=_G.OverrideActionBar.leaveFrame.LeaveButton}
	for i = 1, 6 do
		self:addButtonBorder{obj=_G.OverrideActionBar["SpellButton" .. i], abt=true, sec=true, es=20}
	end

end

function aObj:PetJournal() -- LoD
	if not self.db.profile.PetJournal or self.initialized.PetJournal then return end
	self.initialized.PetJournal = true

	self:addSkinFrame{obj=_G.PetJournalParent, ft=ftype, kfs=true, x1=-3, y1=2, x2=1, y2=-5}
	self:skinTabs{obj=_G.PetJournalParent, lod=true}

	-- MountJournal
	self:removeInset(_G.MountJournal.LeftInset)
	self:removeInset(_G.MountJournal.RightInset)
	self:removeInset(_G.MountJournal.MountCount)
	self:skinEditBox{obj=_G.MountJournal.searchBox, regs={9}, mi=true}
	self:keepFontStrings(_G.MountJournal.MountDisplay)
	self:keepFontStrings(_G.MountJournal.MountDisplay.ShadowOverlay)
	self:makeMFRotatable(_G.MountJournal.MountDisplay.ModelFrame)
	self:skinSlider{obj=_G.MountJournal.ListScrollFrame.scrollBar, adj=-4}
	self:removeMagicBtnTex(_G.MountJournalMountButton)
	for i = 1, #_G.MountJournal.ListScrollFrame.buttons do
		local btn = _G.MountJournal.ListScrollFrame.buttons[i]
		btn:DisableDrawLayer("BACKGROUND")
	end
	-- PetJournal
	self:removeInset(_G.PetJournal.PetCount)
	_G.PetJournal.MainHelpButton.Ring:SetTexture(nil)
	self:moveObject{obj=_G.PetJournal.MainHelpButton, y=-4}
	self:addButtonBorder{obj=_G.PetJournal.HealPetButton, sec=true}
	_G.PetJournalHealPetButtonBorder:SetTexture(nil)
	self:removeInset(_G.PetJournal.LeftInset)
	self:removeInset(_G.PetJournal.RightInset)
	self:skinEditBox{obj=_G.PetJournal.searchBox, regs={9}, mi=true}
	self:skinButton{obj=_G.PetJournalFilterButton}
	self:skinDropDown{obj=_G.PetJournalFilterDropDown}
	self:skinSlider{obj=_G.PetJournal.listScroll.scrollBar, adj=-4}
	self:removeMagicBtnTex(_G.PetJournal.FindBattleButton)
	self:removeMagicBtnTex(_G.PetJournal.SummonButton)
	self:skinDropDown{obj=_G.PetJournal.petOptionsMenu}
	for i = 1, #_G.PetJournal.listScroll.buttons do
		local btn = _G.PetJournal.listScroll.buttons[i]
		self:removeRegions(btn, {1}) -- background
		self:changeTandC(btn.dragButton.levelBG, self.lvlBG)
	end
	self:removeRegions(_G.PetJournal.AchievementStatus, {1})
	self:keepFontStrings(_G.PetJournal.loadoutBorder)
	self:moveObject{obj=_G.PetJournal.loadoutBorder, y=8} -- battle pet slots title
	-- Pet LoadOut Plates
	for i = 1, 3 do
		local obj = _G.PetJournal.Loadout["Pet" .. i]
		self:removeRegions(obj, {1, 2, 5})
		-- add button border for empty slots
        self.modUIBtns:addButtonBorder{obj=obj, relTo=obj.icon} -- use module function here to force creation
		self:changeTandC(obj.levelBG, self.lvlBG)
		self:keepFontStrings(obj.helpFrame)
		obj.healthFrame.healthBar:DisableDrawLayer("OVERLAY")
		self:glazeStatusBar(obj.healthFrame.healthBar, 0,  nil)
		self:removeRegions(obj.xpBar, {2, 3, 4, 5, 6, 7, 8, 9, 10, 11})
		self:glazeStatusBar(obj.xpBar, 0,  nil)
		self:makeMFRotatable(obj.model)
		self:addSkinFrame{obj=obj, aso={bd=8, ng=true}, x1=-4, y2=-4} -- use asf here as button already has a border
		for i = 1, 3 do
			local btn = obj["spell" .. i]
			self:removeRegions(btn, {1, 3}) -- background, blackcover
			self:addButtonBorder{obj=btn, relTo=btn.icon, reParent={btn.FlyoutArrow}}
		end
	end
	-- only show button border if layoutPlate is available but empty
	self:SecureHook("PetJournal_UpdatePetLoadOut", function()
		for i = 1, 3 do
			local obj = _G.PetJournal.Loadout["Pet" .. i]
			obj.sbb:SetShown(obj.emptyslot:IsShown())
		end
	end)
	-- PetCard
	self:removeInset(_G.PetJournal.PetCardInset)
	local obj = _G.PetJournal.PetCard
	self:changeTandC(obj.PetInfo.levelBG, self.lvlBG)
	self:removeRegions(obj.HealthFrame.healthBar, {1, 2, 3})
	self:glazeStatusBar(obj.HealthFrame.healthBar, 0,  nil)
	self:removeRegions(obj.xpBar, {2, 3, 4, 5, 6, 7, 8, 9, 10, 11})
	self:glazeStatusBar(obj.xpBar, 0,  nil)
	self:makeMFRotatable(obj.model)
	self:keepFontStrings(obj)
	self:addSkinFrame{obj=obj, aso={bd=8, ng=true}, ofs=4}
	-- spell buttons
	for i = 1, 6 do
		local btn = obj["spell" .. i]
		btn.BlackCover:SetAlpha(0) -- N.B. texture is changed in code
		self:addButtonBorder{obj=btn, relTo=btn.icon}
	end
	-- Tooltips
	if self.db.profile.Tooltips.skin then
		_G.PetJournalPrimaryAbilityTooltip.Delimiter1:SetTexture(nil)
		_G.PetJournalPrimaryAbilityTooltip.Delimiter2:SetTexture(nil)
		_G.PetJournalPrimaryAbilityTooltip:DisableDrawLayer("BACKGROUND")
		self:addSkinFrame{obj=_G.PetJournalPrimaryAbilityTooltip, ft=ftype}
		_G.PetJournalSecondaryAbilityTooltip.Delimiter1:SetTexture(nil)
		_G.PetJournalSecondaryAbilityTooltip.Delimiter2:SetTexture(nil)
		_G.PetJournalSecondaryAbilityTooltip:DisableDrawLayer("BACKGROUND")
		self:addSkinFrame{obj=_G.PetJournalSecondaryAbilityTooltip, ft=ftype}
	end

end

function aObj:PVPUI()
	if not self.db.profile.PVPFrame or self.initialized.PVPFrame then return end
	self.initialized.PVPFrame = true

	self:removeInset(_G.PVPUIFrame.LeftInset)
	self:addSkinFrame{obj=_G.PVPUIFrame, ft=ftype, kfs=true, x1=-3, y1=2, x2=1, y2=-5}
	for i = 1, 3 do
		local btn = _G.PVPQueueFrame["CategoryButton" .. i]
		btn.Background:SetTexture(nil)
		btn.Ring:SetTexture(nil)
		self:changeRecTex(btn:GetHighlightTexture())
	end
	-- hook this to change selected texture
	self:SecureHook("PVPQueueFrame_SelectButton", function(index)
		for i = 1, 3 do
			local btn = _G.PVPQueueFrame["CategoryButton" .. i]
			if i == index then
				self:changeRecTex(btn.Background, true)
			else
				btn.Background:SetTexture(nil)
			end
		end
	end)
	_G.PVPQueueFrame_SelectButton(1) -- select Honor button
	_G.PVPUIFrame.Shadows:DisableDrawLayer("OVERLAY")
	-- Honor Frame
	self:skinDropDown{obj=_G.HonorFrameTypeDropDown}
	self:removeInset(_G.HonorFrame.RoleInset)
	self:removeInset(_G.HonorFrame.Inset)
	self:skinSlider{obj=_G.HonorFrameSpecificFrameScrollBar, adj=-4}
	for i = 1, #_G.HonorFrame.SpecificFrame.buttons do
		local btn = _G.HonorFrame.SpecificFrame.buttons[i]
		btn.Bg:SetTexture(nil)
		btn.Border:SetTexture(nil)
	end
	_G.HonorFrame.BonusFrame.RandomBGButton.NormalTexture:SetTexture(nil)
	_G.HonorFrame.BonusFrame.CallToArmsButton.NormalTexture:SetTexture(nil)
	_G.HonorFrame.BonusFrame.WorldPVP1Button.NormalTexture:SetTexture(nil)
	_G.HonorFrame.BonusFrame.WorldPVP2Button.NormalTexture:SetTexture(nil)
	_G.HonorFrame.BonusFrame:DisableDrawLayer("BACKGROUND")
	_G.HonorFrame.BonusFrame:DisableDrawLayer("BORDER")
	_G.HonorFrame.BonusFrame.ShadowOverlay:DisableDrawLayer("OVERLAY")
	self:removeMagicBtnTex(_G.HonorFrame.SoloQueueButton)
	self:removeMagicBtnTex(_G.HonorFrame.GroupQueueButton)
	-- Conquest Frame
	_G.ConquestFrame:DisableDrawLayer("BACKGROUND")
	_G.ConquestFrame:DisableDrawLayer("BORDER")
	_G.ConquestFrame.ShadowOverlay:DisableDrawLayer("OVERLAY")
	local bar = _G.ConquestFrame.ConquestBar
	bar:DisableDrawLayer("BORDER")
	bar.progress:SetTexture(self.sbTexture)
	bar.cap1:SetTexture(self.sbTexture)
	bar.cap2:SetTexture(self.sbTexture)
	self:removeInset(_G.ConquestFrame.Inset)
	_G.ConquestFrame.Arena2v2.NormalTexture:SetTexture(nil)
	_G.ConquestFrame.Arena3v3.NormalTexture:SetTexture(nil)
	_G.ConquestFrame.Arena5v5.NormalTexture:SetTexture(nil)
	_G.ConquestFrame.RatedBG.NormalTexture:SetTexture(nil)
	self:removeMagicBtnTex(_G.ConquestFrame.JoinButton)
	self:skinDropDown{obj=_G.ConquestFrame.ArenaInviteMenu}
	-- War Games Frame
	_G.WarGamesFrame.InfoBG:SetTexture(nil)
	self:removeInset(_G.WarGamesFrame.RightInset)
	self:skinSlider{obj=_G.WarGamesFrameScrollFrameScrollBar, adj=-4}
	for i = 1, #_G.WarGamesFrame.scrollFrame.buttons do
		local btn = _G.WarGamesFrame.scrollFrame.buttons[i]
		self:skinButton{obj=btn.Header, mp=true}
		btn.Entry.Bg:SetTexture(nil)
		btn.Entry.Border:SetTexture(nil)
	end
	self:skinSlider{obj=_G.WarGamesFrameInfoScrollFrameScrollBar}
	_G.WarGamesFrame.HorizontalBar:DisableDrawLayer("ARTWORK")
	self:removeMagicBtnTex(_G.WarGameStartButton)

	-- PVPFramePopup
	_G.PVPFramePopup:DisableDrawLayer("BORDER")
	_G.PVPFramePopupRing:SetTexture(nil)
	self:addSkinFrame{obj=_G.PVPFramePopup, ft=ftype}
	-- PVPRoleCheckPopup
	self:addSkinFrame{obj=_G.PVPRoleCheckPopup, ft=ftype}
	-- PVPReadyDialog
	-- _G.PVPReadyDialog.background:SetAlpha(0)
	-- _G.PVPReadyDialog.filigree:SetAlpha(0)
	-- _G.PVPReadyDialog.bottomArt:SetAlpha(0)
	-- _G.PVPReadyDialog.instanceInfo.underline:SetAlpha(0)
	self:addSkinFrame{obj=_G.PVPReadyDialog, ft=ftype, kfs=true}

end

function aObj:QuestLog()
	if not self.db.profile.QuestLog or self.initialized.QuestLog then return end
	self.initialized.QuestLog = true

	self:keepFontStrings(_G.QuestLogCount)
	self:keepFontStrings(_G.EmptyQuestLogFrame)

	if self.modBtns then
		local function qlUpd()

			-- handle in combat
			if _G.InCombatLockdown() then
				aObj:add2Table(aObj.oocTab, {qlUpd, {nil}})
				return
			end

			for i = 1, #_G.QuestLogScrollFrame.buttons do
				aObj:checkTex(_G.QuestLogScrollFrame.buttons[i])
			end

		end
		-- hook to manage changes to button textures
		self:SecureHook("QuestLog_Update", function()
			qlUpd()
		end)
		-- hook this as well as it's a copy of QuestLog_Update
		self:SecureHook(_G.QuestLogScrollFrame, "update", function()
			qlUpd()
		end)
		-- skin minus/plus buttons
		for i = 1, #_G.QuestLogScrollFrame.buttons do
			self:skinButton{obj=_G.QuestLogScrollFrame.buttons[i], mp=true}
		end
	end
	self:skinSlider{obj=_G.QuestLogScrollFrame.scrollBar, adj=-4}
	self:addButtonBorder{obj=_G.QuestLogFrameShowMapButton, relTo=_G.QuestLogFrameShowMapButton.texture, x1=2, y1=-1, x2=-2, y2=1}
	self:removeRegions(_G.QuestLogScrollFrame, {1, 2, 3, 4})
	self:skinAllButtons{obj=_G.QuestLogControlPanel, ft=ftype}
	self:addSkinFrame{obj=_G.QuestLogFrame, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-2}
	self:removeMagicBtnTex(_G.QuestLogFrameCompleteButton)

-->>-- QuestLogDetail Frame
	_G.QuestLogDetailTitleText:SetTextColor(self.HTr, self.HTg, self.HTb)
	self:skinScrollBar{obj=_G.QuestLogDetailScrollFrame}
	self:addSkinFrame{obj=_G.QuestLogDetailFrame, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-2}
	_G.RaiseFrameLevelByTwo(_G.QuestLogDetailScrollFrame) -- make Quest text appear above frame

-->>-- QuestInfo
	self:QuestInfo() -- NPC Frames

end

function aObj:RaidUI() -- LoD
	if not self.db.profile.RaidUI or self.initialized.RaidUI then return end
	self.initialized.RaidUI = true

	local function skinPulloutFrames()

		for i = 1, _G.NUM_RAID_PULLOUT_FRAMES	do
			local objName = "RaidPullout" .. i
			if not _G[objName].sf then
				aObj:skinDropDown{obj=_G[objName .. "DropDown"]}
				_G[objName .. "MenuBackdrop"]:SetBackdrop(nil)
				aObj:addSkinFrame{obj=_G[objName], ft=ftype, kfs=true, x1=3, y1=-1, x2=-1, y2=1}
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
		for i = 1, pullOutFrame.numPulloutButtons do
			local objName = pfName .. "Button" .. i
			if not _G[objName].sf then
				for _, v in pairs{"HealthBar", "ManaBar", "Target", "TargetTarget"} do
					local barName = objName .. v
					self:removeRegions(_G[barName], {2})
					self:glazeStatusBar(_G[barName], 0, _G[barName .. "Background"])
				end
				self:addSkinFrame{obj=_G[objName .. "TargetTargetFrame"], ft=ftype, x1=4, x2=-4, y2=2}
				self:addSkinFrame{obj=_G[objName], ft=ftype, kfs=true, x1=-4, y1=-6, x2=4, y2=-6}
			end
		end
	end)

	self:moveObject{obj=_G.RaidGroup1, x=2}

	-- Raid Groups
	for i = 1, _G.MAX_RAID_GROUPS do
		self:addSkinFrame{obj=_G["RaidGroup" .. i], ft=ftype, kfs=true, x1=-2, y1=2, x2=1, y2=-1}
	end
	-- Raid Group Buttons
	for i = 1, _G.MAX_RAID_GROUPS * 5 do
		local btn = _G["RaidGroupButton" .. i]
		self:removeRegions(btn, {4})
		self:addSkinFrame{obj=btn, ft=ftype, aso={bd=5}, x1=-2, y1=2, x2=1, y2=-1}
	end
	-- Raid Class Tabs (side)
	for i = 1, _G.MAX_RAID_CLASS_BUTTONS do
		self:removeRegions(_G["RaidClassButton" .. i], {1}) -- N.B. region 2 is the icon, 3 is the text
	end

	-- skin existing frames
	skinPulloutFrames()

end

function aObj:ReadyCheck()
	if not self.db.profile.ReadyCheck or self.initialized.ReadyCheck then return end
	self.initialized.ReadyCheck = true

	self:addSkinFrame{obj=_G.ReadyCheckListenerFrame, ft=ftype, kfs=true}

end

function aObj:RolePollPopup()
	if not self.db.profile.RolePollPopup or self.initialized.RolePollPopup then return end
	self.initialized.RolePollPopup = true

	self:addSkinFrame{obj=_G.RolePollPopup, ft=ftype, x1=5, y1=-5, x2=-5, y2=5}

end

function aObj:ScrollOfResurrection()
	if not self.db.profile.ScrollOfResurrection or self.initialized.ScrollOfResurrection then return end
	self.initialized.ScrollOfResurrection = true

	self:skinEditBox{obj=_G.ScrollOfResurrectionFrame.targetEditBox, regs={9}}
	_G.ScrollOfResurrectionFrame.targetEditBox.fill:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:addSkinFrame{obj=_G.ScrollOfResurrectionFrame.noteFrame, ft=ftype, kfs=true}
	self:skinScrollBar{obj=_G.ScrollOfResurrectionFrame.noteFrame.scrollFrame}
	_G.ScrollOfResurrectionFrame.noteFrame.scrollFrame.editBox.fill:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:addSkinFrame{obj=_G.ScrollOfResurrectionFrame, ft=ftype, kfs=true}
	-- Selection frame
	self:skinEditBox{obj=_G.ScrollOfResurrectionSelectionFrame.targetEditBox, regs={9}}
	self:skinSlider{obj=_G.ScrollOfResurrectionSelectionFrame.list.scrollFrame.scrollBar, size=4}
	self:addSkinFrame{obj=_G.ScrollOfResurrectionSelectionFrame.list, ft=ftype, kfs=true}
	self:addSkinFrame{obj=_G.ScrollOfResurrectionSelectionFrame, ft=ftype, kfs=true}

end

function aObj:SpellBookFrame()
	if not self.db.profile.SpellBookFrame or self.initialized.SpellBookFrame then return end
	self.initialized.SpellBookFrame = true

	_G.SpellBookFrame.numTabs = 5
	if self.isTT then
		-- hook to handle tabs
		self:SecureHook("ToggleSpellBook", function(bookType)
			for i = 1, _G.SpellBookFrame.numTabs do
				local tab = _G["SpellBookFrameTabButton" .. i]
				if tab.bookType == bookType then
					self:setActiveTab(tab.sf)
				else
					self:setInactiveTab(tab.sf)
				end
			end
		end)
	end

	_G.SpellBookFrame.MainHelpButton.Ring:SetTexture(nil)
	self:moveObject{obj=_G.SpellBookFrame.MainHelpButton, y=-4}
	self:skinTabs{obj=_G.SpellBookFrame, suffix="Button", x1=8, y1=1, x2=-8, y2=2}
	self:addSkinFrame{obj=_G.SpellBookFrame, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-5}
	self:addButtonBorder{obj=_G.SpellBookPrevPageButton, ofs=-2, y1=-3, x2=-3}
	self:addButtonBorder{obj=_G.SpellBookNextPageButton, ofs=-2, y1=-3, x2=-3}
-->>- Spellbook Panel
	_G.SpellBookPageText:SetTextColor(self.BTr, self.BTg, self.BTb)
	-- hook this to change text colour as required
	self:SecureHook("SpellButton_UpdateButton", function(this)
		if this.UnlearnedFrame and this.UnlearnedFrame:IsShown() then -- level too low
			this.SpellName:SetTextColor(self.HTr, self.HTg, self.HTb)
		end
		if this.RequiredLevelString then this.RequiredLevelString:SetTextColor(self.BTr, self.BTg, self.BTb) end
		if this.TrainFrame and this.TrainFrame:IsShown() then -- see Trainer
			this.SpellName:SetTextColor(_G.HIGHLIGHT_FONT_COLOR.r, _G.HIGHLIGHT_FONT_COLOR.g, _G.HIGHLIGHT_FONT_COLOR.b)
			this.SpellSubName:SetTextColor(_G.HIGHLIGHT_FONT_COLOR.r, _G.HIGHLIGHT_FONT_COLOR.g, _G.HIGHLIGHT_FONT_COLOR.b)
		end
		if this.SeeTrainerString then this.SeeTrainerString:SetTextColor(self.BTr, self.BTg, self.BTb) end
		if this.SpellName then
			this.SpellName:SetTextColor(self.HTr, self.HTg, self.HTb)
			this.SpellSubName:SetTextColor(self.BTr, self.BTg, self.BTb)
		end
	end)
-->>-- Professions Panel
	local function skinProf(type, times)

		for i = 1, times do
			local objName = type .. "Profession" .. i
			local obj =_G[objName]
			if type == "Primary" then
				_G[objName .. "IconBorder"]:Hide()
				if not obj.missingHeader:IsShown() then
					obj.icon:SetDesaturated(nil) -- show in colour
				end
			else
				obj.missingHeader:SetTextColor(aObj.HTr, aObj.HTg, aObj.HTb)
			end
			obj.missingText:SetTextColor(aObj.BTr, aObj.BTg, aObj.BTb)
			for i = 1, 2 do
				local btn = obj["button" .. i]
				btn:DisableDrawLayer("BACKGROUND")
				btn.subSpellString:SetTextColor(aObj.BTr, aObj.BTg, aObj.BTb)
				aObj:addButtonBorder{obj=btn, sec=true}
			end
			_G[objName .. "StatusBar"]:DisableDrawLayer("BACKGROUND")
		end

	end
	-- Primary professions
	skinProf("Primary", 2)
	-- Secondary professions
	skinProf("Secondary", 4)
	-->>-- Core Abilities Panel
	_G.SpellBookCoreAbilitiesFrame.SpecName:SetTextColor(self.HTr, self.HTg, self.HTb)
	self:SecureHook("SpellBook_UpdateCoreAbilitiesTab", function()
		for i = 1, #_G.SpellBookCoreAbilitiesFrame.Abilities do
			local btn = _G.SpellBookCoreAbilitiesFrame.Abilities[i]
			if not btn.sbb then
				btn.EmptySlot:SetAlpha(0)
				btn.ActiveTexture:SetAlpha(0)
				btn.FutureTexture:SetAlpha(0)
				btn.Name:SetTextColor(self.HTr, self.HTg, self.HTb)
				btn.InfoText:SetTextColor(self.BTr, self.BTg, self.BTb)
				btn.RequiredLevel:SetTextColor(self.BTr, self.BTg, self.BTb)
				self:addButtonBorder{obj=btn}
			end
		end
		for i = 1, #_G.SpellBookCoreAbilitiesFrame.SpecTabs do
			local tab = _G.SpellBookCoreAbilitiesFrame.SpecTabs[i]
			if not tab.sbb then
				self:removeRegions(tab, {1}) -- N.B. other regions are icon and highlight
				self:addButtonBorder{obj=tab}
			end
		end
	end)
	-->>-- What has changed? panel
	_G.SpellBookWhatHasChanged.ClassName:SetTextColor(self.HTr, self.HTg, self.HTb)
	self:SecureHook("SpellBook_UpdateWhatHasChangedTab", function()
		for i = 1, #_G.SpellBookWhatHasChanged.ChangedItems do
			local btn = _G.SpellBookWhatHasChanged.ChangedItems[i]
			btn.Ring:SetTexture(nil)
			btn:DisableDrawLayer("BACKGROUND")
			btn.Title:SetTextColor(self.HTr, self.HTg, self.HTb)
			btn:SetTextColor(self.BTr, self.BTg, self.BTb)
		end
		self:Unhook("SpellBook_UpdateWhatHasChangedTab")
	end)

	-- colour the spell name text
	for i = 1, _G.SPELLS_PER_PAGE do
		local btnName = "SpellButton" .. i
		local btn = _G[btnName]
		btn:DisableDrawLayer("BACKGROUND")
		btn:DisableDrawLayer("BORDER")
		_G[btnName .. "SlotFrame"]:SetAlpha(0)
		btn.UnlearnedFrame:SetAlpha(0)
		btn.TrainFrame:SetAlpha(0)
		self:addButtonBorder{obj=_G[btnName], sec=true, reParent={btn.FlyoutArrow, _G[btnName .. "AutoCastable"]}}
	end
-->>-- Tabs (side)
	for i = 1, _G.MAX_SKILLLINE_TABS do
		local obj = _G["SpellBookSkillLineTab" .. i]
		self:removeRegions(obj, {1}) -- N.B. other regions are icon and highlight
		self:addButtonBorder{obj=obj}
	end

end

function aObj:SpellFlyout()
	if not self.db.profile.SpellFlyout or self.initialized.SpellFlyout then return end
	self.initialized.SpellFlyout = true

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

	-- handle different addons being loaded
	if _G.IsAddOnLoaded("EnhancedStackSplit") then
		self:addSkinFrame{obj=_G.StackSplitFrame, ft=ftype, kfs=true, y2=-24}
	else
		self:addSkinFrame{obj=_G.StackSplitFrame, ft=ftype, kfs=true, x1=9, y1=-12, x2=-6, y2=12}
	end

end

function aObj:TalentUI() -- LoD
	if not self.db.profile.TalentUI or self.initialized.TalentUI then return end
	self.initialized.TalentUI = true

	self:skinTabs{obj=_G.PlayerTalentFrame, lod=true}
	self:addSkinFrame{obj=_G.PlayerTalentFrame, ft=ftype, kfs=true, ri=true, nb=true, x1=-3, y1=2, x2=1, y2=-5}
	self:skinButton{obj=_G.PlayerTalentFrameCloseButton, cb=true}
	self:skinButton{obj=_G.PlayerTalentFrameActivateButton}
	self:skinButton{obj=_G.PlayerTalentFrameSpecialization.learnButton, anim=true, parent=_G.PlayerTalentFrameSpecialization}
	self:skinButton{obj=_G.PlayerTalentFrameTalents.learnButton, anim=true, parent=_G.PlayerTalentFrameTalents}
	self:skinButton{obj=_G.PlayerTalentFramePetSpecialization.learnButton, anim=true, parent=_G.PlayerTalentFramePetSpecialization}

	local function skinAbilities(obj)
		for i = 1, obj:GetNumChildren() do
			local btn = obj["abilityButton" .. i]
			btn.ring:SetTexture(nil)
			if btn.subText
			and not btn.disabled
			then
				btn.subText:SetTextColor(self.BTr, self.BTg, self.BTb)
			end
		end
	end
	local function skinSpec(frame)
		aObj:removeRegions(frame, {1, 2, 3, 4, 5, 6})
		frame.MainHelpButton.Ring:SetTexture(nil)
		aObj:moveObject{obj=frame.MainHelpButton, y=-4}
		aObj:removeMagicBtnTex(frame.learnButton)
		for i = 1, 4 do
			local btn = frame["specButton" .. i]
			btn.bg:SetTexture(nil)
			btn.ring:SetTexture(nil)
			aObj:changeRecTex(btn.selectedTex, true)
			btn.learnedTex:SetTexture(nil)
			aObj:changeRecTex(btn:GetHighlightTexture())
		end
		-- shadow frame (LHS)
		aObj:keepFontStrings(self:getChild(frame, 7))
		-- spellsScroll (RHS)
		aObj:skinSlider{obj=frame.spellsScroll.ScrollBar}
		local scrollChild = frame.spellsScroll.child
		aObj:removeRegions(scrollChild, {1, 2, 3, 4, 5, 6, 12})
		-- abilities
		skinAbilities(scrollChild)
	end
	-- Tab1 (Specialization)
	skinSpec(_G.PlayerTalentFrameSpecialization)
	-- handle extra abilities (Player and Pet)
	self:SecureHook("PlayerTalentFrame_CreateSpecSpellButton", function(this, index)
		this.spellsScroll.child["abilityButton" .. index].ring:SetTexture(nil)
	end)
	-- hook this as subText text colour is changed
	self:SecureHook("PlayerTalentFrame_UpdateSpecFrame", function(this, spec)
		skinAbilities(this.spellsScroll.child)
	end)
	-- Tab2 (Talents)
	self:removeRegions(_G.PlayerTalentFrameTalents, {1, 2, 3, 4, 5, 6, 7})
	_G.PlayerTalentFrameTalents.MainHelpButton.Ring:SetTexture(nil)
	self:moveObject{obj=_G.PlayerTalentFrameTalents.MainHelpButton, y=-4}
	self:removeMagicBtnTex(_G.PlayerTalentFrameTalents.learnButton)
	self:addButtonBorder{obj=_G.PlayerTalentFrameTalents.clearInfo, relTo=_G.PlayerTalentFrameTalents.clearInfo.icon}
	-- Talent rows
	for i = 1, 6 do
		local obj = _G.PlayerTalentFrameTalents["tier" .. i]
		self:removeRegions(obj, {1, 2 ,3, 4, 5, 6})
		for j = 1, 3 do
			local btn = obj["talent" .. j]
			btn.Slot:SetTexture(nil)
			btn.knownSelection:SetTexCoord(0.00390625, 0.78515625, 0.25000000, 0.36914063)
			btn.knownSelection:SetVertexColor(0, 1, 0, 1)
			self:addButtonBorder{obj=btn, relTo=btn.icon}
		end
	end
	-- Tab3 (Glyphs), skinned in GlyphUI
	-- Tab4 (Pet Specialization)
	skinSpec(_G.PlayerTalentFramePetSpecialization)
	-- Dual Spec Tabs
	for i = 1, 2 do
		local tab = _G["PlayerSpecTab" .. i]
		self:removeRegions(tab, {1}) -- N.B. other regions are icon and highlight
		self:addButtonBorder{obj=tab}
	end

end

function aObj:TradeFrame()
	if not self.db.profile.TradeFrame or self.initialized.TradeFrame then return end
	self.initialized.TradeFrame = true

	for i = 1, _G.MAX_TRADE_ITEMS do
		for _, v in pairs{"Player", "Recipient"} do
			local btnName = "Trade" .. v .. "Item" .. i
			_G[btnName .. "SlotTexture"]:SetTexture(nil)
			_G[btnName .. "NameFrame"]:SetTexture(nil)
			self:addButtonBorder{obj=_G[btnName .. "ItemButton"], ibt=true}
		end
	end
	self:removeInset(_G.TradeRecipientItemsInset)
	self:removeInset(_G.TradeRecipientEnchantInset)
	self:removeInset(_G.TradePlayerItemsInset)
	self:removeInset(_G.TradePlayerEnchantInset)
	self:removeInset(_G.TradePlayerInputMoneyInset)
	self:skinMoneyFrame{obj=_G.TradePlayerInputMoneyFrame, moveSEB=true}
	self:removeInset(_G.TradeRecipientMoneyInset)
	_G.TradeRecipientMoneyBg:DisableDrawLayer("BACKGROUND")

	self:addSkinFrame{obj=_G.TradeFrame, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-2}

end

function aObj:TradeSkillUI() -- LoD
	if not self.db.profile.TradeSkillUI or self.initialized.TradeSkillUI then return end
	self.initialized.TradeSkillUI = true

	if self.modBtns then
		-- hook to manage changes to button textures
		self:SecureHook("TradeSkillFrame_Update", function()
			for i = 1, _G.TRADE_SKILLS_DISPLAYED do
				self:checkTex(_G["TradeSkillSkill" .. i])
			end
			self:checkTex(_G.TradeSkillCollapseAllButton)
		end)
	end

	local objName = "TradeSkillRankFrame"
	local obj = _G[objName]
	_G[objName .. "Border"]:SetAlpha(0)
	self:glazeStatusBar(obj, 0, _G[objName .. "Background"])
	self:moveObject{obj=obj, x=-2}
	self:skinEditBox{obj=_G.TradeSkillFrameSearchBox, regs={9}, mi=true, noHeight=true, noMove=true}
	self:skinButton{obj=_G.TradeSkillFilterButton}
	self:addButtonBorder{obj=_G.TradeSkillLinkButton, x1=1, y1=-5, x2=-3, y2=2}
	self:removeRegions(_G.TradeSkillExpandButtonFrame)
	self:skinButton{obj=_G.TradeSkillCollapseAllButton, mp=true}
	for i = 1, _G.TRADE_SKILLS_DISPLAYED do
		local btn = _G["TradeSkillSkill" .. i]
		self:skinButton{obj=btn, mp=true}
		btn.SubSkillRankBar.BorderLeft:SetTexture(nil)
		btn.SubSkillRankBar.BorderRight:SetTexture(nil)
		btn.SubSkillRankBar.BorderMid:SetTexture(nil)
		self:glazeStatusBar(btn.SubSkillRankBar, 0)
	end
	self:skinScrollBar{obj=_G.TradeSkillListScrollFrame}
	self:skinScrollBar{obj=_G.TradeSkillDetailScrollFrame}
	self:keepFontStrings(_G.TradeSkillDetailScrollChildFrame)
	self:addButtonBorder{obj=_G.TradeSkillSkillIcon}
	self:skinEditBox{obj=_G.TradeSkillInputBox, noHeight=true, x=-5}
	self:addSkinFrame{obj=_G.TradeSkillFrame, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-5}
	self:removeMagicBtnTex(_G.TradeSkillCreateAllButton)
	self:removeMagicBtnTex(_G.TradeSkillCancelButton)
	self:removeMagicBtnTex(_G.TradeSkillCreateButton)
	self:removeMagicBtnTex(_G.TradeSkillViewGuildCraftersButton)
	self:addButtonBorder{obj=_G.TradeSkillDecrementButton, ofs=-2, es=10}
	self:addButtonBorder{obj=_G.TradeSkillIncrementButton, ofs=-2, es=10}
	-- Guild sub frame
	self:addSkinFrame{obj=_G.TradeSkillGuildFrameContainer, ft=ftype}
	self:addSkinFrame{obj=_G.TradeSkillGuildFrame, ft=ftype, kfs=true, ofs=-7}

	for i = 1, _G.MAX_TRADE_SKILL_REAGENTS do
		_G["TradeSkillReagent" .. i .. "NameFrame"]:SetTexture(nil)
		self:addButtonBorder{obj=_G["TradeSkillReagent" .. i], libt=true}
	end

	if self.modBtns then _G.TradeSkillFrame_Update() end -- force update for button textures

end

function aObj:WatchFrame()
	if not self.db.profile.WatchFrame.skin
	and not self.db.profile.WatchFrame.popups
	or self.initialized.WatchFrame
	then
		return
	end
	self.initialized.WatchFrame = true

	if self.modBtnBs then
		local function skinWFBtns()

			for i = 1, _G.WATCHFRAME_NUM_ITEMS do
				local btn = _G["WatchFrameItem" .. i]
				if not btn.sbb then
					aObj:addButtonBorder{obj=btn, ibt=true}
				end
			end

		end
		-- use hooksecurefunc as it may be hooked again if skinned
		_G.hooksecurefunc("WatchFrame_Update", function(this)
			skinWFBtns()
		end)
		skinWFBtns() -- skin any existing buttons
	end

	if self.db.profile.WatchFrame.skin then
		self:addSkinFrame{obj=_G.WatchFrameLines, ft=ftype, x1=-30, y1=4, x2=10}
		-- hook this to handle displaying of the WatchFrameLines skin frame
		self:SecureHook("WatchFrame_Update", function(this)
			_G.WatchFrameLines.sf:SetShown(_G.WatchFrameHeader:IsShown())
		end)
	end
	if self.db.profile.WatchFrame.popups then
		local function skinAutoPopUps()

			for i = 1, _G.GetNumAutoQuestPopUps() do
				local obj = _G["WatchFrameAutoQuestPopUp" .. i] and _G["WatchFrameAutoQuestPopUp" .. i].ScrollChild
				if obj and not aObj.skinned[obj] then
					for k, reg in ipairs{obj:GetRegions()} do
						if k < 11 or k > 16 then reg:SetTexture(nil) end -- Animated textures
						 -- move Quest Icons right
						if k == 11 or k == 12 then self:moveObject{obj=reg, x=16} end
					end
					obj.Flash:DisableDrawLayer("OVERLAY") -- hide IconBg flash texture
					aObj:applySkin{obj=obj, ft=ftype}
				end
			end

		end
		_G.WatchFrameLinesShadow:SetTexture(nil) -- shadow texture above popup
		-- hook this to skin the AutoPopUps
		self:SecureHook("WatchFrameAutoQuest_GetOrCreateFrame", function(parent, index)
			skinAutoPopUps()
		end)
		skinAutoPopUps()
	end

	-- skin the Scenario Frame(s)
	_G.WatchFrameScenarioFrame.ScrollChild.BlockHeader:SetSize(201, 77)
	self:applySkin{obj=_G.WatchFrameScenarioFrame.ScrollChild.BlockHeader, ft=ftype, kfs=true}
	_G.WatchFrameScenarioBonusHeader.Background:SetTexture(nil)
	self:applySkin{obj=_G.WatchFrameScenarioBonusHeader, ft=ftype}

end
