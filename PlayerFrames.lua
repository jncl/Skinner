local aName, aObj = ...

local _G = _G
local ftype = "p"

local ipairs, pairs, unpack = _G.ipairs, _G.pairs, _G.unpack
local IsAddOnLoaded = _G.IsAddOnLoaded

aObj.blizzLoDFrames[ftype].AchievementUI = function(self)
	if not self.prdb.AchievementUI.skin or self.initialized.AchievementUI then return end
	self.initialized.AchievementUI = true

	if self.prdb.AchievementUI.style == 2 then
		_G.ACHIEVEMENTUI_REDBORDER_R = self.bbClr.r
		_G.ACHIEVEMENTUI_REDBORDER_G = self.bbClr.g
		_G.ACHIEVEMENTUI_REDBORDER_B = self.bbClr.b
		_G.ACHIEVEMENTUI_REDBORDER_A = self.bbClr.a
	end

	-- handle Overachiever hijacking OnShow script first time through
	if IsAddOnLoaded("Overachiever") then
		self:SecureHook("AchievementFrame_OnShow", function(this)
			_G.AchievementFrame:Hide()
			_G.AchievementFrame:Show()
			self:Unhook(this, "AchievementFrame_OnShow")
		end)
	end

	self:SecureHookScript(_G.AchievementFrame, "OnShow", function(this)
		local function skinSB(statusBar, type)

			aObj:moveObject{obj=_G[statusBar .. type], y=-3}
			aObj:moveObject{obj=_G[statusBar .. "Text"], y=-3}
			_G[statusBar .. "Left"]:SetAlpha(0)
			_G[statusBar .. "Right"]:SetAlpha(0)
			_G[statusBar .. "Middle"]:SetAlpha(0)
			aObj:skinStatusBar{obj=_G[statusBar], fi=0, bgTex=_G[statusBar .. "FillBar"]}

		end
		local function skinStats()

			for i = 1, #_G.AchievementFrameStatsContainer.buttons do
				_G.AchievementFrameStatsContainer.buttons[i].background:SetTexture(nil)
				_G.AchievementFrameStatsContainer.buttons[i].left:SetAlpha(0)
				_G.AchievementFrameStatsContainer.buttons[i].middle:SetAlpha(0)
				_G.AchievementFrameStatsContainer.buttons[i].right:SetAlpha(0)
			end

		end
		local function glazeProgressBar(pBar)

			if not aObj.sbGlazed[pBar] then
				_G[pBar .. "BorderLeft"]:SetAlpha(0)
				_G[pBar .. "BorderRight"]:SetAlpha(0)
				_G[pBar .. "BorderCenter"]:SetAlpha(0)
				aObj:skinStatusBar{obj=_G[pBar], fi=0, bgTex=_G[pBar .. "BG"]}
			end

		end
		local function skinCategories()

			-- handle case where buttons don't exist
			if _G.AchievementFrameCategoriesContainer.buttons then
				for i = 1, #_G.AchievementFrameCategoriesContainer.buttons do
					_G.AchievementFrameCategoriesContainer.buttons[i].background:SetAlpha(0)
				end
			end

		end
		local function skinComparisonStats()

			for i = 1, #_G.AchievementFrameComparisonStatsContainer.buttons do
				if _G.AchievementFrameComparisonStatsContainer.buttons[i].isHeader then _G.AchievementFrameComparisonStatsContainer.buttons[i].background:SetAlpha(0) end
				_G.AchievementFrameComparisonStatsContainer.buttons[i].left:SetAlpha(0)
				_G.AchievementFrameComparisonStatsContainer.buttons[i].left2:SetAlpha(0)
				_G.AchievementFrameComparisonStatsContainer.buttons[i].middle:SetAlpha(0)
				_G.AchievementFrameComparisonStatsContainer.buttons[i].middle2:SetAlpha(0)
				_G.AchievementFrameComparisonStatsContainer.buttons[i].right:SetAlpha(0)
				_G.AchievementFrameComparisonStatsContainer.buttons[i].right2:SetAlpha(0)
			end

		end
		local function skinBtn(btn)

			btn:DisableDrawLayer("BACKGROUND")
			-- don't DisableDrawLayer("BORDER") as the button border won't show if skinned
			btn:DisableDrawLayer("ARTWORK")
			aObj:applySkin{obj=btn, bd=10, ng=true} -- use applySkin to allow border colour to be changed and icon borders to be visible
			-- TODO: show plusMinus as plus/minus without background
			if btn.plusMinus then btn.plusMinus:SetAlpha(0) end
			btn.icon:DisableDrawLayer("BACKGROUND")
			btn.icon:DisableDrawLayer("BORDER")
			btn.icon:DisableDrawLayer("OVERLAY")
			-- set textures to nil and prevent them from being changed as guildview changes the textures
			aObj:nilTexture(btn.icon.frame, true)
			-- colour text and button border
			if btn.description then btn.description:SetTextColor(aObj.BT:GetRGB()) end
			if btn.hiddenDescription then btn.hiddenDescription:SetTextColor(aObj.BT:GetRGB()) end

			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=btn.icon, x1=4, y1=-1, x2=-4, y2=6}
				btn.icon.sbb:SetBackdropBorderColor(btn:GetBackdropBorderColor())
				btn.icon.sbb:SetBackdropBorderColor(btn:GetBackdropBorderColor())
				-- hook these to handle description text  & button border colour changes
				aObj:SecureHook(btn, "Desaturate", function(this)
					this.icon.sbb:SetBackdropBorderColor(this:GetBackdropBorderColor())
				end)
			end
			aObj:SecureHook(btn, "Saturate", function(this)
				if this.description then
					this.description:SetTextColor(aObj.BT:GetRGB())
				end
				if this.icon.sbb then
					this.icon.sbb:SetBackdropBorderColor(this:GetBackdropBorderColor())
				end
			end)

			if aObj.modChkBtns
			and btn.tracked
			then
				aObj:skinCheckButton{obj=btn.tracked, hf=true}
			end

		end
		local function cleanButtons(frame, type)

			if aObj.prdb.AchievementUI.style == 1 then return end -- don't remove textures if option not chosen

			-- remove textures etc from buttons
			local btnName, btn
			for i = 1, #frame.buttons do
				btnName = frame.buttons[i]:GetName() .. (type == "Comparison" and "Player" or "")
				skinBtn(_G[btnName])
				if type == "Achievements" then
					-- set textures to nil and prevent them from being changed as guildview changes the textures
					self:nilTexture(_G[btnName .. "TopTsunami1"], true)
					self:nilTexture(_G[btnName .. "BottomTsunami1"], true)
				elseif type == "Summary" then
					if not _G[btnName].tooltipTitle then _G[btnName]:Saturate() end
				elseif type == "Comparison" then
					-- force update to colour the Player button
					if _G[btnName].completed then _G[btnName]:Saturate() end
					-- Friend
					btn = _G[btnName:gsub("Player", "Friend")]
					skinBtn(btn)
					-- force update to colour the Friend button
					if btn.completed then btn:Saturate() end
				end
			end
			btnName, btn = nil, nil

		end

		self:keepFontStrings(_G.AchievementFrameHeader)
		self:moveObject{obj=_G.AchievementFrameHeaderTitle, x=-60, y=-25}
		self:moveObject{obj=_G.AchievementFrameHeaderPoints, x=40, y=-5}
		_G.AchievementFrameHeaderShield:SetAlpha(1)

		self:skinSlider{obj=_G.AchievementFrameCategoriesContainerScrollBar, wdth=-4}
		self:addSkinFrame{obj=_G.AchievementFrameCategories, ft=ftype, y1=0, x2=22}
		-- hook these to stop Categories skinFrame from changing
		self:SecureHook(_G.AchievementFrameCategoriesContainerScrollBar, "Show", function(this)
			_G.AchievementFrameCategories.sf:SetPoint("BOTTOMRIGHT", _G.AchievementFrameCategories, "BOTTOMRIGHT", 22, -2)
		end)
		self:SecureHook(_G.AchievementFrameCategoriesContainerScrollBar, "Hide", function(this)
			_G.AchievementFrameCategories.sf:SetPoint("BOTTOMRIGHT", _G.AchievementFrameCategories, "BOTTOMRIGHT", 0, -2)
		end)
		self:SecureHook("AchievementFrameCategories_Update", function()
			skinCategories()
		end)
		skinCategories()

		self:keepFontStrings(_G.AchievementFrameAchievements)
		self:addSkinFrame{obj=self:getChild(_G.AchievementFrameAchievements, 2), ft=ftype, aso={bd=10, ng=true}, y1=0, x2=29}
		self:skinSlider{obj=_G.AchievementFrameAchievementsContainerScrollBar, wdth=-4}
		if self.prdb.AchievementUI.style == 2 then
			-- remove textures etc from buttons
			cleanButtons(_G.AchievementFrameAchievementsContainer, "Achievements")
			-- hook this to handle objectives text colour changes
			self:SecureHookScript(_G.AchievementFrameAchievementsObjectives, "OnShow", function(this)
				if this.completed then
					for _, child in ipairs{this:GetChildren()} do
						for _, reg in ipairs{child:GetChildren()} do
							if reg:IsObjectType("FontString") then
								reg:SetTextColor(self.BT:GetRGB())
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
			if _G["AchievementFrameProgressBar" .. i] then glazeProgressBar("AchievementFrameProgressBar" .. i) end
		end
		-- hook this to skin StatusBars used by the Objectives mini panels
		self:RawHook("AchievementButton_GetProgressBar", function(...)
			local obj = self.hooks.AchievementButton_GetProgressBar(...)
			glazeProgressBar(obj:GetName())
			return obj
		end, true)
		-- hook this to colour the metaCriteria & Criteria text
		self:SecureHook("AchievementObjectives_DisplayCriteria", function(objectivesFrame, id, renderOffScreen)
			local r, g, b, a
			for _, child in ipairs{objectivesFrame:GetChildren()} do
				if child.shield then -- miniAchievement
					-- do nothing
				elseif child.label then -- metaCriteria
					r, g, b, a = child.label:GetTextColor()
					if g == 0 then -- completed criteria
						child.label:SetTextColor(_G.HIGHLIGHT_FONT_COLOR:GetRGB())
						child.label:SetShadowOffset(1, -1)
					end
				elseif child.name then -- criteria
					r, g, b, a = child.name:GetTextColor()
					if g == 0 then -- completed criteria
						child.name:SetTextColor(_G.HIGHLIGHT_FONT_COLOR:GetRGB())
						child.name:SetShadowOffset(1, -1)
					end
				end
			end
			r, g, b, a = nil, nil, nil, nil
		end)

		self:keepFontStrings(_G.AchievementFrameStats)
		self:skinSlider{obj=_G.AchievementFrameStatsContainerScrollBar, wdth=-4}
		_G.AchievementFrameStatsBG:SetAlpha(0)
		self:getChild(_G.AchievementFrameStats, 3):SetBackdrop(nil)
		self:addSkinFrame{obj=_G.AchievementFrameStats, ft=ftype, aso={bd=10, ng=true}, y1=0, x2=29}
		-- hook these to stop Categories skinFrame from changing
		self:SecureHook(_G.AchievementFrameStatsContainerScrollBar, "Show", function(this)
			_G.AchievementFrameStats.sf:SetPoint("BOTTOMRIGHT", _G.AchievementFrameStats, "BOTTOMRIGHT", 29, -2)
		end)
		self:SecureHook(_G.AchievementFrameStatsContainerScrollBar, "Hide", function(this)
			_G.AchievementFrameStats.sf:SetPoint("BOTTOMRIGHT", _G.AchievementFrameStats, "BOTTOMRIGHT", 3, -2)
		end)

		-- hook this to skin buttons
		self:SecureHook("AchievementFrameStats_Update", function()
			skinStats()
		end)
		skinStats()

		self:keepFontStrings(_G.AchievementFrameSummary)
		_G.AchievementFrameSummaryBackground:SetAlpha(0)
		_G.AchievementFrameSummaryAchievementsEmptyText:SetText() -- remove 'No recently completed Achievements' text
		_G.AchievementFrameSummaryAchievementsHeaderHeader:SetAlpha(0)
		self:skinSlider(_G.AchievementFrameAchievementsContainerScrollBar)
		-- remove textures etc from buttons
		if self.prdb.AchievementUI.style == 2 then
			if not _G.AchievementFrameSummary:IsVisible() then
				self:SecureHookScript(_G.AchievementFrameSummary, "OnShow", function()
					cleanButtons(_G.AchievementFrameSummaryAchievements, "Summary")
					self:Unhook(_G.AchievementFrameSummary, "OnShow")
				end)
			else
				cleanButtons(_G.AchievementFrameSummaryAchievements, "Summary")
			end
		end
		-- Categories SubPanel
		self:keepFontStrings(_G.AchievementFrameSummaryCategoriesHeader)
		for i = 1, 12 do
			skinSB("AchievementFrameSummaryCategoriesCategory" .. i, "Label")
		end
		self:addSkinFrame{obj=self:getChild(_G.AchievementFrameSummary, 1), ft=ftype, aso={bd=10, ng=true}, y1=-1}
		skinSB("AchievementFrameSummaryCategoriesStatusBar", "Title")

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
		self:getChild(_G.AchievementFrameComparison, 5):SetBackdrop(nil)
		self:addSkinFrame{obj=_G.AchievementFrameComparison, ft=ftype, aso={bd=10, ng=true}, y1=0, x2=31}
		for _, type in pairs{"Player", "Friend"} do
			_G["AchievementFrameComparisonSummary" .. type]:SetBackdrop(nil)
			_G["AchievementFrameComparisonSummary" .. type .. "Background"]:SetAlpha(0)
			skinSB("AchievementFrameComparisonSummary" .. type .. "StatusBar", "Title")
		end
		-- remove textures etc from buttons
		if not _G.AchievementFrameComparison:IsVisible() and self.prdb.AchievementUI.style == 2 then
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

		self:moveObject{obj=_G.AchievementFrameCloseButton, y=6}
		self:skinTabs{obj=this, regs={9, 10}, ignore=true, lod=true, x1=9, y1=2, x2=-9, y2=-10}

		-- this is not a standard dropdown
		self:moveObject{obj=_G.AchievementFrameFilterDropDown, y=-7}
		-- skin the dropdown frame
		if self.prdb.DropDownButtons then
			if self.prdb.TexturedDD then
				local tex = _G.AchievementFrameFilterDropDown:CreateTexture(nil, "BORDER")
				tex:SetTexture(self.itTex)
				tex:SetSize(110, 19)
				tex:SetPoint("RIGHT", _G.AchievementFrameFilterDropDown, "RIGHT", -3, 4)
				tex = nil
			end
			if self.modBtnBs then
				local xOfs = 1
				if IsAddOnLoaded("Overachiever") then xOfs = 102 end
			    self:addButtonBorder{obj=_G.AchievementFrameFilterDropDownButton, es=12, ofs=-2, x1=xOfs}
				xOfs = nil
			end
			self:addSkinFrame{obj=_G.AchievementFrameFilterDropDown, ft=ftype, aso={ng=true}, x1=-8, y1=2, x2=2, y2=7}
		end

		-- Search function
		self:skinEditBox{obj=this.searchBox, regs={6, 7}, mi=true} -- 6 is text, 7 is icon
		self:moveObject{obj=_G.AchievementFrame.searchBox, y=-10}
		self:adjHeight{obj=this.searchPreviewContainer, adj=((4 * 27) + 30)}
		self:addSkinFrame{obj=this.searchPreviewContainer, ft=ftype, kfs=true, y1=4, y2=2}
		_G.LowerFrameLevel(this.searchPreviewContainer.sf)
		self:skinStatusBar{obj=this.searchProgressBar, fi=0, bgTex=this.searchProgressBar.bg}
		for i = 1, #this.searchPreview do
			this.searchPreview[i]:SetNormalTexture(nil)
			this.searchPreview[i]:SetPushedTexture(nil)
			this.searchPreview[i].iconFrame:SetTexture(nil)
			self:addButtonBorder{obj=this.searchPreview[i], relTo=this.searchPreview[i].icon}
		end
		this.showAllSearchResults:SetNormalTexture(nil)
		this.showAllSearchResults:SetPushedTexture(nil)
		self:addSkinFrame{obj=this.searchResults, ft=ftype, kfs=true, x1=-8, y1=-1}
		self:skinSlider{obj=this.searchResults.scrollFrame.scrollBar, wdth=-4}
		for i = 1, #this.searchResults.scrollFrame.buttons do
			this.searchResults.scrollFrame.buttons[i]:SetNormalTexture(nil)
			this.searchResults.scrollFrame.buttons[i]:SetPushedTexture(nil)
			this.searchResults.scrollFrame.buttons[i].iconFrame:SetTexture(nil)
			self:addButtonBorder{obj=this.searchResults.scrollFrame.buttons[i], relTo=this.searchResults.scrollFrame.buttons[i].icon}
		end

		self:addSkinFrame{obj=this, ft=ftype, kfs=true, y1=7, x2=0, y2=-2}

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzLoDFrames[ftype].ArchaeologyUI = function(self)
	if not self.prdb.ArchaeologyUI or self.initialized.ArchaeologyUI then return end
	self.initialized.ArchaeologyUI = true

	self:SecureHookScript(_G.ArchaeologyFrame, "OnShow", function(this)
		self:moveObject{obj=this.infoButton, x=-25}
		self:skinDropDown{obj=this.raceFilterDropDown}
		_G.ArchaeologyFrameRankBarBackground:SetAllPoints(this.rankBar)
		_G.ArchaeologyFrameRankBarBorder:Hide()
		self:skinStatusBar{obj=this.rankBar, fi=0, bgTex=_G.ArchaeologyFrameRankBarBackground}
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true, x1=30}
		self:keepFontStrings(this.summaryPage) -- remove title textures
		_G.ArchaeologyFrameSummaryPageTitle:SetTextColor(self.HT:GetRGB())
		for i = 1, _G.ARCHAEOLOGY_MAX_RACES do
			this.summaryPage["race" .. i].raceName:SetTextColor(self.BT:GetRGB())
		end
		self:addButtonBorder{obj=this.summaryPage.prevPageButton, ofs=0}
		self:addButtonBorder{obj=this.summaryPage.nextPageButton, ofs=0}
		self:keepFontStrings(this.completedPage) -- remove title textures
		this.completedPage.infoText:SetTextColor(self.BT:GetRGB())
		this.completedPage.titleBig:SetTextColor(self.HT:GetRGB())
		this.completedPage.titleTop:SetTextColor(self.BT:GetRGB())
		this.completedPage.titleMid:SetTextColor(self.BT:GetRGB())
		this.completedPage.pageText:SetTextColor(self.BT:GetRGB())
		for i = 1, _G.ARCHAEOLOGY_MAX_COMPLETED_SHOWN do
			this.completedPage["artifact" .. i].artifactName:SetTextColor(self.HT:GetRGB())
			this.completedPage["artifact" .. i].artifactSubText:SetTextColor(self.BT:GetRGB())
			this.completedPage["artifact" .. i].border:Hide()
			_G["ArchaeologyFrameCompletedPageArtifact" .. i .. "Bg"]:Hide()
			self:addButtonBorder{obj=this.completedPage["artifact" .. i], relTo=this.completedPage["artifact" .. i].icon}
		end
		self:addButtonBorder{obj=this.completedPage.prevPageButton, ofs=0}
		self:addButtonBorder{obj=this.completedPage.nextPageButton, ofs=0}
		self:removeRegions(this.artifactPage, {2, 3, 7, 9}) -- title textures, backgrounds
		self:addButtonBorder{obj=this.artifactPage, relTo=this.artifactPage.icon, ofs=1}
		self:skinStdButton{obj=this.artifactPage.backButton}
		self:skinStdButton{obj=this.artifactPage.solveFrame.solveButton}
		self:getRegion(this.artifactPage.solveFrame.statusBar, 1):Hide() -- BarBG texture
		self:skinStatusBar{obj=this.artifactPage.solveFrame.statusBar, fi=0}
		this.artifactPage.solveFrame.statusBar:SetStatusBarColor(0.75, 0.45, 0, 0.7)
		this.artifactPage.historyTitle:SetTextColor(self.HT:GetRGB())
		this.artifactPage.historyScroll.child.text:SetTextColor(self.BT:GetRGB())
		self:skinSlider{obj=this.artifactPage.historyScroll.ScrollBar, wdth=-4}
		self:removeRegions(this.helpPage, {2, 3}) -- title textures
		this.helpPage.titleText:SetTextColor(self.HT:GetRGB())
		_G.ArchaeologyFrameHelpPageDigTex:SetTexCoord(0.05, 0.885, 0.055, 0.9) -- remove texture surrounds
		_G.ArchaeologyFrameHelpPageDigTitle:SetTextColor(self.HT:GetRGB())
		_G.ArchaeologyFrameHelpPageHelpScrollHelpText:SetTextColor(self.BT:GetRGB())
		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.ArcheologyDigsiteProgressBar, "OnShow", function(this)
		this:DisableDrawLayer("BACKGROUND")
		this.BarBorderAndOverlay:SetTexture(nil)
		self:skinStatusBar{obj=this.FillBar, fi=0}
		self:Unhook(this, "OnShow")
	end)

	-- N.B. DigsiteCompleteToastFrame is managed as part of the Alert Frames skin

end

aObj.blizzLoDFrames[ftype].ArtifactUI = function(self)
	if not self.prdb.ArtifactUI or self.initialized.ArtifactUI then return end
	self.initialized.ArtifactUI = true

	self:SecureHookScript(_G.ArtifactFrame, "OnShow", function(this)
		self:keepFontStrings(this.BorderFrame)
		this.ForgeBadgeFrame:DisableDrawLayer("OVERLAY") -- this hides the frame
		this.ForgeBadgeFrame.ForgeLevelLabel:SetDrawLayer("ARTWORK") -- this shows the artifact level
		self:skinGlowBox(this.KnowledgeLevelHelpBox, ftype)
		self:skinGlowBox(this.AppearanceTabHelpBox, ftype)

		self:skinTabs{obj=this, regs={}, ignore=true, lod=true, x1=6, y1=9, x2=-6, y2=-4}
		self:addSkinFrame{obj=this, ft=ftype, ofs=5, y1=4}

		this.PerksTab:DisableDrawLayer("BORDER")
		this.PerksTab:DisableDrawLayer("OVERLAY")
		this.PerksTab.TitleContainer.Background:SetAlpha(0) -- title underline texture
		self:removeRegions(this.PerksTab.DisabledFrame, {1})
		this.PerksTab.Model:DisableDrawLayer("OVERLAY")
		for i = 1, 14 do
			this.PerksTab.CrestFrame["CrestRune" .. i]:SetAtlas(nil)
		end
		-- hook this to stop Background being Refreshed
		_G.ArtifactPerksMixin.RefreshBackground = _G.nop
		local function skinPowerBtns()

			if this.PerksTab.PowerButtons then
				for i = 1, #this.PerksTab.PowerButtons do
					aObj:changeTandC(this.PerksTab.PowerButtons[i].RankBorder, aObj.lvlBG)
					aObj:changeTandC(this.PerksTab.PowerButtons[i].RankBorderFinal, aObj.lvlBG)
				end
			end

		end
		skinPowerBtns()
		-- hook this to skin new buttons
		self:SecureHook(this.PerksTab, "RefreshPowers", function(this, newItem)
			skinPowerBtns()
		end)

		self:SecureHook(this.AppearancesTab, "Refresh", function(this)
			for appearanceSet in this.appearanceSetPool:EnumerateActive() do
				appearanceSet:DisableDrawLayer("BACKGROUND")
			end
			for appearanceSlot in this.appearanceSlotPool:EnumerateActive() do
				appearanceSlot:DisableDrawLayer("BACKGROUND")
				appearanceSlot.Border:SetTexture(nil)
			end
		end)

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzLoDFrames[ftype].AzeriteEssenceUI = function(self)
	if not self.prdb.AzeriteEssenceUI or self.initialized.AzeriteEssenceUI then return end
	self.initialized.AzeriteEssenceUI = true

	self:SecureHookScript(_G.AzeriteEssenceUI, "OnShow", function(this)
		-- LHS
		self:keepFontStrings(this.PowerLevelBadgeFrame)
		self:removeInset(this.LeftInset)
		this.OrbGlass:SetTexture(nil)
		-- remove revolving circles & stop them from re-appearing
		this.ItemModelScene:ClearScene()
		-- remove revolving stars
		this.StarsAnimationFrame1:DisableDrawLayer("BORDER")
		this.StarsAnimationFrame2:DisableDrawLayer("BORDER")
		this.StarsAnimationFrame3:DisableDrawLayer("BORDER")
		-- remove ring etc from milestones
		for i, slot in ipairs(this.Slots) do
			-- print("Slot", i, slot)
			for j, stateFrame in ipairs(slot.StateFrames) do
				-- print("StateFrames", j, stateFrame, stateFrame:GetNumRegions())
				if i == 1 then -- Major Milestone
					stateFrame.Glow:SetAlpha(0)
					stateFrame.Shadow:SetAlpha(0)
					stateFrame.Ring:SetAlpha(0)
					stateFrame.HighlightRing:SetAlpha(0)
				elseif j == 1 then -- Minor Milestone
					stateFrame.Ring:SetAlpha(0)
					stateFrame.HighlightRing:SetAlpha(0)
				end
			end
		end
		-- RHS
		self:removeInset(this.RightInset)
		self:skinSlider{obj=this.EssenceList.ScrollBar, size=2}
		self:skinGlowBox(this.EssenceList.Tutorial, ftype, true)
		if self.modBtnBs then
			local function clrBB(sf)
				for i, btn in ipairs(sf.buttons) do
					btn.sbb:SetBackdropBorderColor(btn.Name:GetTextColor())
				end
			end
			-- self:skinStdButton{obj=this.ScrollFrame.HeaderButton}
			for i, btn in ipairs(this.EssenceList.buttons) do
				self:nilTexture(btn.Background, true)
				self:addButtonBorder{obj=btn, relTo=btn.Icon, reParent={btn.IconCover, btn.Glow, btn.Glow2, btn.Glow3}, grey=true}
			end
			clrBB(this.EssenceList)
			self:SecureHook(this.EssenceList, "UpdateMouseOverTooltip", function(this)
				clrBB(this)
			end)
		end
		self:addSkinFrame{obj=this, ft=ftype, kfs=true}

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.AzeriteEssenceUI)

	-- AzeriteEssenceLearnAnimFrame

end

aObj.blizzLoDFrames[ftype].AzeriteUI = function(self)
	if not self.prdb.AzeriteUI or self.initialized.AzeriteUI then return end
	self.initialized.AzeriteUI = true

	local AEIUI = _G.AzeriteEmpoweredItemUI

	self:keepFontStrings(AEIUI)
	self:addSkinFrame{obj=AEIUI.BorderFrame, ft=ftype, kfs=true, bg=true}
	AEIUI.ClipFrame.BackgroundFrame:DisableDrawLayer("BACKGROUND")
	AEIUI.ClipFrame.BackgroundFrame.KeyOverlay:DisableDrawLayer("ARTWORK")
	for i = 1, #AEIUI.ClipFrame.BackgroundFrame.RankFrames do
		AEIUI.ClipFrame.BackgroundFrame.RankFrames[i]:DisableDrawLayer("BORDER")
	end
	self:skinGlowBox(AEIUI.FirstPowerLockedInHelpBox, ftype)

	AEIUI = nil

end

aObj.blizzFrames[ftype].Buffs = function(self)
	if not self.prdb.Buffs or self.initialized.Buffs then return end
	self.initialized.Buffs = true

	if self.modBtnBs then
		-- skin current Buffs
		local btn
		for i = 1, _G.BUFF_MAX_DISPLAY do
			btn = _G["BuffButton" .. i]
			if btn
			and not btn.sbb
			then
				self:addButtonBorder{obj=btn, reParent={btn.count, btn.duration}}
			end
		end
		btn = nil
		-- if not all buff buttons created yet
		if not _G.BuffButton32 then
			-- hook this to skin new Buffs
			self:SecureHook("AuraButton_Update", function(buttonName, index, filter)
				-- aObj:Debug("AuraButton_Update: [%s, %s, %s]", buttonName, index, filter)
				if buttonName == "BuffButton" then
					local btn = _G[buttonName .. index]
					if btn
					and not btn.sbb
					then
						self:addButtonBorder{obj=btn, reParent={btn.count, btn.duration}}
					end
				end
			end)
		end
	end

	-- Debuffs already have a coloured border
	-- Temp Enchants already have a coloured border

end

aObj.blizzFrames[ftype].CastingBar = function(self)
	if IsAddOnLoaded("Quartz")
	or IsAddOnLoaded("Dominos_Cast")
	then
		aObj.blizzFrames[ftype].CastingBar = nil
		return
	end

	if not self.prdb.CastingBar.skin or self.initialized.CastingBar then return end
	self.initialized.CastingBar = true

	for _, type in pairs{"", "Pet"} do
		_G[type .. "CastingBarFrame"].Border:SetAlpha(0)
		self:changeShield(_G[type .. "CastingBarFrame"].BorderShield, _G[type .. "CastingBarFrame"].Icon)
		_G[type .. "CastingBarFrame"].Flash:SetAllPoints()
		_G[type .. "CastingBarFrame"].Flash:SetTexture([[Interface\Buttons\WHITE8X8]])
		if self.prdb.CastingBar.glaze then
			self:skinStatusBar{obj=_G[type .. "CastingBarFrame"], fi=0, bgTex=self:getRegion(_G[type .. "CastingBarFrame"], 1)}
		end
		-- adjust text and spark in Classic mode
		if not _G[type .. "CastingBarFrame"].ignoreFramePositionManager then
			_G[type .. "CastingBarFrame"].Text:SetPoint("TOP", 0, 2)
			_G[type .. "CastingBarFrame"].Spark.offsetY = -1
		end
	end

	-- hook this to handle the CastingBar being attached to the Unitframe and then reset
	self:SecureHook("CastingBarFrame_SetLook", function(castBar, look)
		castBar.Border:SetAlpha(0)
		castBar.Flash:SetAllPoints()
		castBar.Flash:SetTexture([[Interface\Buttons\WHITE8X8]])
		if look == "CLASSIC" then
			castBar.Text:SetPoint("TOP", 0, 2)
			castBar.Spark.offsetY = -1
		end
	end)

end

aObj.blizzFrames[ftype].CharacterFrames = function(self)
	if not self.prdb.CharacterFrames or self.initialized.CharacterFrames then return end
	self.initialized.CharacterFrames = true

	_G.CharacterStatsPane.ClassBackground:SetTexture(nil) -- other adddons reparent this (e.g. DejaCharacterStats)
	_G.CharacterStatsPane.ItemLevelFrame.Background:SetTexture(nil)
	_G.CharacterStatsPane.ItemLevelCategory:DisableDrawLayer("BACKGROUND")
	_G.CharacterStatsPane.AttributesCategory:DisableDrawLayer("BACKGROUND")
	_G.CharacterStatsPane.EnhancementsCategory:DisableDrawLayer("BACKGROUND")
	self:SecureHook("PaperDollFrame_UpdateStats", function()
		for statLine in _G.CharacterStatsPane.statsFramePool:EnumerateActive() do
			statLine:DisableDrawLayer("BACKGROUND")
		end
	end)
	_G.PaperDollFrame_UpdateStats()

	self:SecureHookScript(_G.CharacterFrame, "OnShow", function(this)
		self:skinTabs{obj=this, lod=true}
		self:skinGlowBox(this.ReputationTabHelpBox, ftype)
		self:removeInset(_G.CharacterFrameInsetRight)
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true, x1=-5, y2=-5}

		-- Sidebar Tabs
		_G.PaperDollSidebarTabs.DecorLeft:SetAlpha(0)
		_G.PaperDollSidebarTabs.DecorRight:SetAlpha(0)
		for i = 1, #_G.PAPERDOLL_SIDEBARS do
			_G["PaperDollSidebarTab" .. i].TabBg:SetAlpha(0)
			_G["PaperDollSidebarTab" .. i].Hider:SetAlpha(0)
			-- use a button border to indicate the active tab
			self.modUIBtns:addButtonBorder{obj=_G["PaperDollSidebarTab" .. i], relTo=_G["PaperDollSidebarTab" .. i].Icon, ofs=i==1 and 3 or 1} -- use module function here to force creation
			_G["PaperDollSidebarTab" .. i].sbb:SetBackdropBorderColor(1, 0.6, 0, 1)
			_G["PaperDollSidebarTab" .. i].sbb:SetShown(_G[_G.PAPERDOLL_SIDEBARS[i].frame]:IsShown())
		end
		-- hook this to manage the active tab
		self:SecureHook("PaperDollFrame_UpdateSidebarTabs", function()
			for i = 1, #_G.PAPERDOLL_SIDEBARS do
				if _G["PaperDollSidebarTab" .. i]
				and _G["PaperDollSidebarTab" .. i].sbb
				then
					_G["PaperDollSidebarTab" .. i].sbb:SetShown(_G[_G.PAPERDOLL_SIDEBARS[i].frame]:IsShown())
				end
			end
		end)
		self:SecureHookScript(_G.PaperDollTitlesPane, "OnShow", function(this)
			self:skinSlider{obj=this.scrollBar, wdth=-4}
			for i = 1, #this.buttons do
				this.buttons[i]:DisableDrawLayer("BACKGROUND")
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.PaperDollEquipmentManagerPane, "OnShow", function(this)
			self:skinSlider{obj=this.scrollBar, wdth=-4}
			self:skinStdButton{obj=this.EquipSet}
			this.EquipSet:DisableDrawLayer("BACKGROUND")
			self:skinStdButton{obj=this.SaveSet}
			for i = 1, #this.buttons do
				this.buttons[i]:DisableDrawLayer("BACKGROUND")
				self:addButtonBorder{obj=this.buttons[i], relTo=this.buttons[i].icon}
			end

			self:Unhook(this, "OnShow")
		end)

		_G.CharacterModelFrame:DisableDrawLayer("BACKGROUND")
		_G.CharacterModelFrame:DisableDrawLayer("BORDER")
		_G.CharacterModelFrame:DisableDrawLayer("OVERLAY")
		_G.CharacterModelFrame.controlFrame:DisableDrawLayer("BACKGROUND")

		local function skinSlot(btn)
			btn:DisableDrawLayer("BACKGROUND")
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=btn, ibt=true, reParent={btn.ignoreTexture}, grey=true}
				-- force quality border update
				_G.PaperDollItemSlotButton_Update(btn)
				-- RankFrame
				aObj:changeTandC(btn.RankFrame.Texture, self.lvlBG)
				btn.RankFrame.Texture:SetSize(20, 20)
				btn.RankFrame.Label:ClearAllPoints()
				btn.RankFrame.Label:SetPoint("CENTER", btn.RankFrame.Texture)
			end
		end
		if self.modBtnBs then
			self:SecureHook("PaperDollItemSlotButton_Update", function(btn)
				if not _G.GetInventoryItemTexture("player", btn:GetID()) then
					btn.sbb:SetBackdropBorderColor(0.498, 0.498, 0.498, 0.5) -- grey border, 50% alpha
					btn.icon:SetTexture(nil)
				end
			end)
		end

		for i = 1, #_G.PaperDollItemsFrame.EquipmentSlots do
			skinSlot(_G.PaperDollItemsFrame.EquipmentSlots[i])
		end
		for i = 1, #_G.PaperDollItemsFrame.WeaponSlots do
			skinSlot(_G.PaperDollItemsFrame.WeaponSlots[i])
		end
		self:skinGlowBox(_G.PaperDollItemsFrame.HelpTipBox, ftype)
		-- fixupNotificationFrame (anchored to CharacterMainHandSlot)
		if this.fixupNotificationFrame then
			self:skinGlowBox(this.fixupNotificationFrame, ftype)
		end

		self:SecureHookScript(_G.GearManagerDialogPopup, "OnShow", function(this)
			self:adjHeight{obj=_G.GearManagerDialogPopupScrollFrame, adj=20}
			self:skinSlider{obj=_G.GearManagerDialogPopupScrollFrame.ScrollBar, size=3, rt="background"}
			self:removeRegions(this.BorderBox, {1, 2, 3, 4, 5, 6, 7, 8})
			self:adjHeight{obj=this, adj=20}
			for i = 1, #this.buttons do
				this.buttons[i]:DisableDrawLayer("BACKGROUND")
				self:addButtonBorder{obj=this.buttons[i]}
			end
			self:skinEditBox{obj=_G.GearManagerDialogPopupEditBox, regs={6}}
			self:skinStdButton{obj=_G.GearManagerDialogPopupCancel}
			self:skinStdButton{obj=_G.GearManagerDialogPopupOkay}
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, x1=4, y1=-2, x2=-1, y2=3}

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.TokenFrame, "OnShow", function(this) -- a.k.a Currency Tab
			self:keepFontStrings(this)
			self:skinSlider{obj=_G.TokenFrameContainerScrollBar, wdth=-4}
			-- remove background & header textures
			for i = 1, #_G.TokenFrameContainer.buttons do
				self:removeRegions(_G.TokenFrameContainer.buttons[i], {1, 6, 7, 8})
			end
			-- TokenFramePopup
			_G.TokenFramePopup.Border:DisableDrawLayer("BACKGROUND")
			self:skinCheckButton{obj=_G.TokenFramePopupInactiveCheckBox}
			self:skinCheckButton{obj=_G.TokenFramePopupBackpackCheckBox}
			self:addSkinFrame{obj=_G.TokenFramePopup,ft=ftype, kfs=true, y1=-6, x2=-6, y2=6}

			self:Unhook(_G.TokenFrame, "OnShow")
		end)

		self:SecureHookScript(_G.ReputationFrame, "OnShow", function(this)
			self:keepFontStrings(this)
			for i = 1, _G.NUM_FACTIONS_DISPLAYED do
				self:skinExpandButton{obj=_G["ReputationBar" .. i .. "ExpandOrCollapseButton"], sap=true}
				_G["ReputationBar" .. i .. "Background"]:SetAlpha(0)
				_G["ReputationBar" .. i .. "ReputationBarLeftTexture"]:SetAlpha(0)
				_G["ReputationBar" .. i .. "ReputationBarRightTexture"]:SetAlpha(0)
				self:skinStatusBar{obj=_G["ReputationBar" .. i .. "ReputationBar"], fi=0}
			end
			if self.modBtns then
				-- hook to manage changes to button textures
				self:SecureHook("ReputationFrame_Update", function()
					for i = 1, _G.NUM_FACTIONS_DISPLAYED do
						if _G["ReputationBar" .. i].isCollapsed then
							_G["ReputationBar" .. i .. "ExpandOrCollapseButton"]:SetText("+")
						else
							_G["ReputationBar" .. i .. "ExpandOrCollapseButton"]:SetText("-")
						end
						if _G["ReputationBar" .. i .. "ExpandOrCollapseButton"]:IsShown() then
							_G["ReputationBar" .. i .. "ExpandOrCollapseButton"].sb:Show()
						else
							_G["ReputationBar" .. i .. "ExpandOrCollapseButton"].sb:Hide()
						end
					end
					-- colour checkbox borders
					if self.modChkBtns then
						local r, g, b
						for _, type in pairs{"AtWar", "Inactive"} do
							r, g, b = _G["ReputationDetail" .. type .. "CheckBoxText"]:GetTextColor()
							if self:round2(r, 2) ~= _G.GRAY_FONT_COLOR.r then
								_G["ReputationDetail" .. type .. "CheckBox"].sb:SetBackdropBorderColor(self.bbClr:GetRGBA())
							else
								_G["ReputationDetail" .. type .. "CheckBox"].sb:SetBackdropBorderColor(r ,g, b)
							end
						end
						r, g, b = nil, nil, nil
					end
				end)
			end
			self:skinSlider{obj=_G.ReputationListScrollFrame.ScrollBar, size=3, rt="background"}
			-- ReputationDetailFrame
			self:removeNineSlice(_G.ReputationDetailFrame.Border)
			if self.modBtns then
				self:skinCloseButton{obj=_G.ReputationDetailCloseButton}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=_G.ReputationDetailAtWarCheckBox}
				self:skinCheckButton{obj=_G.ReputationDetailInactiveCheckBox}
				self:skinCheckButton{obj=_G.ReputationDetailMainScreenCheckBox}
				self:skinCheckButton{obj=_G.ReputationDetailLFGBonusReputationCheckBox}
			end
			self:addSkinFrame{obj=_G.ReputationDetailFrame, ft=ftype, kfs=true, x1=6, y1=-6, x2=-6, y2=6}

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.ReputationFrame)

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzLoDFrames[ftype].Collections = function(self)
	if not self.prdb.Collections or self.initialized.Collections then return end
	self.initialized.Collections = true

	self:SecureHookScript(_G.CollectionsJournal, "OnShow", function(this)
		self:skinTabs{obj=this, lod=true}
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, y2=-5}

		self:skinGlowBox(this.HeirloomTabHelpBox, ftype)
		self:skinGlowBox(this.WardrobeTabHelpBox, ftype)

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.MountJournal, "OnShow", function(this)
		self:removeInset(this.LeftInset)
		self:removeInset(this.BottomLeftInset)
		local btn = this.BottomLeftInset.SlotButton
		self:removeRegions(btn, {1, 3})
		if self.modBtnBs then
			self:addButtonBorder{obj=btn, relTo=btn.ItemIcon, reParent={btn.SlotBorder, btn.SlotBorderOpen}, grey=true, ga=0.85}
		end
		btn = nil
		if self.modBtns then
			self:skinStdButton{obj=this.BottomLeftInset.SuppressedMountEquipmentButton}
		end
		self:skinDropDown{obj=this.mountOptionsMenu}
		self:removeInset(this.RightInset)
		self:skinEditBox{obj=this.searchBox, regs={6, 7}, mi=true, noHeight=true, noInsert=true, x=-6, y=-2} -- 6 is text, 7 is icon
		self:removeInset(this.MountCount)
		self:keepFontStrings(this.MountDisplay)
		self:keepFontStrings(this.MountDisplay.ShadowOverlay)
		local updBtnClr
		if self.modBtnBs then
			self:addButtonBorder{obj=this.SummonRandomFavoriteButton, ofs=3}
			self:addButtonBorder{obj=this.MountDisplay.InfoButton, relTo=this.MountDisplay.InfoButton.Icon}
			this.MountDisplay.InfoButton.sbb:SetBackdropBorderColor(1, 1, 1, 1)
			self:addButtonBorder{obj=this.MountDisplay.ModelScene.RotateLeftButton, ofs=-4, y2=5}
			self:addButtonBorder{obj=this.MountDisplay.ModelScene.RotateRightButton, ofs=-4, y2=5}
			function updBtnClr(btn)
				-- aObj:Debug("updBtnClr: [%s, %s, %s, %s, %s]", btn.name:GetText(), btn.icon:GetAlpha(), btn.icon:GetVertexColor())
				local r, g, b = btn.icon:GetVertexColor()
				btn.sbb:SetBackdropBorderColor(r, g, b, btn.icon:GetAlpha())
				r, g, b = nil, nil, nil
			end
			self:SecureHook(this.ListScrollFrame, "update", function(this)
				for i = 1, #this.buttons do
					btn =
					updBtnClr(this.buttons[i])
				end
			end)
		end
		self:skinSlider{obj=this.ListScrollFrame.scrollBar, wdth=-4}
		local btn
		for i = 1, #this.ListScrollFrame.buttons do
			this.ListScrollFrame.buttons[i]:DisableDrawLayer("BACKGROUND")
			if self.modBtnBs then
				btn = this.ListScrollFrame.buttons[i]
				self:addButtonBorder{obj=btn, relTo=btn.icon, reParent={btn.favorite}}
				updBtnClr(btn)
			end
		end
		btn = nil
		self:removeMagicBtnTex(this.MountButton)
		if self.modBtns then
			self:skinStdButton{obj=_G.MountJournalFilterButton}
			self:skinDropDown{obj=_G.MountJournalFilterDropDown}
			self:skinStdButton{obj=this.MountButton}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.PetJournal, "OnShow", function(this)
		self:removeInset(this.PetCount)
		this.MainHelpButton.Ring:SetTexture(nil)
		self:moveObject{obj=this.MainHelpButton, y=-4}
		_G.PetJournalHealPetButtonBorder:SetTexture(nil)
		local updBtnClr
		if self.modBtnBs then
			self:addButtonBorder{obj=this.HealPetButton, sec=true}
			self:addButtonBorder{obj=this.SummonRandomFavoritePetButton, ofs=3}
			function updBtnClr(btn)
				local r, g, b
				if btn.iconBorder:IsShown() then
					r, g, b = btn.iconBorder:GetVertexColor()
					btn.sbb:SetBackdropBorderColor(r, g, b, 1)
				else
					btn.sbb:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
				end
				r, g, b = nil, nil, nil
			end
			self:SecureHook(this.listScroll, "update", function(this)
				for i = 1, #this.buttons do
					updBtnClr(this.buttons[i])
				end
			end)
		end
		self:removeInset(this.LeftInset)
		self:removeInset(this.PetCardInset)
		self:removeInset(this.RightInset)
		self:skinEditBox{obj=this.searchBox, regs={6, 7}, mi=true, noHeight=true, noInsert=true, x=-6, y=-2} -- 6 is text, 7 is icon
		if self.modBtns then
			 self:skinStdButton{obj=_G.PetJournalFilterButton}
		end
		self:skinDropDown{obj=_G.PetJournalFilterDropDown}

		-- PetList
		self:skinSlider{obj=this.listScroll.scrollBar, wdth=-4}
		local btn
		for i = 1, #this.listScroll.buttons do
			btn = this.listScroll.buttons[i]
			self:removeRegions(btn, {1, 4}) -- background, iconBorder
			self:changeTandC(btn.dragButton.levelBG, self.lvlBG)
			if self.modBtnBs then
				self:addButtonBorder{obj=btn, relTo=btn.icon, reParent={btn.dragButton.levelBG, btn.dragButton.level, btn.dragButton.favorite}}
				updBtnClr(btn)
			end
		end
		btn = nil


		self:keepFontStrings(this.loadoutBorder)
		self:moveObject{obj=this.loadoutBorder, y=8} -- battle pet slots title

		-- Pet LoadOut Plates
		local lop
		for i = 1, 3 do
			lop = this.Loadout["Pet" .. i]
			self:removeRegions(lop, {1, 2, 5})
			-- add button border for empty slots
	        self.modUIBtns:addButtonBorder{obj=lop, relTo=lop.icon, reParent={lop.levelBG, lop.level, lop.favorite}} -- use module function here to force creation
			self:changeTandC(lop.levelBG, self.lvlBG)
			self:keepFontStrings(lop.helpFrame)
			lop.healthFrame.healthBar:DisableDrawLayer("OVERLAY")
			self:skinStatusBar{obj=lop.healthFrame.healthBar, fi=0}
			self:removeRegions(lop.xpBar, {2, 3, 4, 5, 6, 7, 8, 9, 10, 11})
			self:skinStatusBar{obj=lop.xpBar, fi=0}
			self:addSkinFrame{obj=lop, ft=ftype, aso={bd=8, ng=true}, x1=-4, y2=-4} -- use asf here as button already has a border
			for i = 1, 3 do
				self:removeRegions(lop["spell" .. i], {1, 3}) -- background, blackcover
				if self.modBtnBs then
					self:addButtonBorder{obj=lop["spell" .. i], relTo=lop["spell" .. i].icon, reParent={lop["spell" .. i].FlyoutArrow}, grey=true, ga=0.85}
				end
			end
		end
		lop = nil

		-- PetCard
		local pc = this.PetCard
		self:changeTandC(pc.PetInfo.levelBG, self.lvlBG)
		pc.PetInfo.qualityBorder:SetAlpha(0)
		if self.modBtnBs then
			self:addButtonBorder{obj=pc.PetInfo, relTo=pc.PetInfo.icon, reParent={pc.PetInfo.levelBG, pc.PetInfo.level, pc.PetInfo.favorite}}
		end
		self:removeRegions(pc.HealthFrame.healthBar, {1, 2, 3})
		self:skinStatusBar{obj=pc.HealthFrame.healthBar, fi=0}
		self:removeRegions(pc.xpBar, {2, 3, 4, 5, 6, 7, 8, 9, 10, 11})
		self:skinStatusBar{obj=pc.xpBar, fi=0}
		self:keepFontStrings(pc)
		self:addSkinFrame{obj=pc, ft=ftype, aso={bd=8, ng=true}, ofs=4}
		for i = 1, 6 do
			pc["spell" .. i].BlackCover:SetAlpha(0) -- N.B. texture is changed in code
			if self.modBtnBs then
				self:addButtonBorder{obj=pc["spell" .. i], relTo=pc["spell" .. i].icon, grey=true, ga=0.85}
			end
		end
		pc = nil

		if self.modBtnBs then
			local r, g, b
			local function skinPetIcon(pet, petID)
				if pet.qualityBorder:IsShown() then
					r, g, b = pet.qualityBorder:GetVertexColor()
					pet.sbb:SetBackdropBorderColor(r, g, b, 1)
					r, g, b = nil, nil, nil
				else
					pet.sbb:SetBackdropBorderColor(0.5, 0.5, 0.5, 1) -- disabled
				end
			end
			self:SecureHook("PetJournal_UpdatePetLoadOut", function()
				for i = 1, 3 do
					skinPetIcon(_G.PetJournal.Loadout["Pet" .. i], _G.PetJournal.Loadout["Pet" .. i].petID)
				end
			end)
			self:SecureHook("PetJournal_UpdatePetCard", function(this)
				skinPetIcon(this.PetInfo, this.TypeInfo.petID)
			end)
		end

		self:removeMagicBtnTex(this.FindBattleButton)
		self:removeMagicBtnTex(this.SummonButton)
		if self.modBtns then
			self:skinStdButton{obj=this.FindBattleButton}
			self:skinStdButton{obj=this.SummonButton}
		end
		self:removeRegions(this.AchievementStatus, {1, 2})
		if self.modChkBtns then
			-- .icon
			self:skinCheckButton{obj=this.SpellSelect.Spell1}
			self:skinCheckButton{obj=this.SpellSelect.Spell2}
		end
		self:skinDropDown{obj=this.petOptionsMenu}

		self:Unhook(this, "OnShow")
	end)

	-- Tooltips
	local function skinTTip(tip)
		tip.Delimiter1:SetTexture(nil)
		tip.Delimiter2:SetTexture(nil)
		tip:DisableDrawLayer("BACKGROUND")
		aObj:addSkinFrame{obj=tip, ft=ftype}
	end
	skinTTip(_G.PetJournalPrimaryAbilityTooltip)
	skinTTip(_G.PetJournalSecondaryAbilityTooltip)

	local skinPageBtns, skinCollectionBtn, colourBtns
	if self.modBtnBs then
		function skinPageBtns(frame)
			aObj:addButtonBorder{obj=frame.PagingFrame.PrevPageButton, ofs=-2, y1=-3, x2=-3}
			aObj:addButtonBorder{obj=frame.PagingFrame.NextPageButton, ofs=-2, y1=-3, x2=-3}
		end
		function skinCollectionBtn(btn)
			if btn.sbb then
				if btn.slotFrameUncollected:IsShown() then
					btn.sbb:SetBackdropBorderColor(0.498, 0.498, 0.498, 1) -- grey border
				else
					btn.sbb:SetBackdropBorderColor(aObj.bbClr:GetRGBA())
				end
			end
		end
		function colourBtns(sFrame)
			local btn
			for i = 1, #sFrame.buttons do
				btn = sFrame.buttons[i]
				btn:DisableDrawLayer("BACKGROUND")
				if btn.Icon:IsDesaturated()
				and btn.IconCover:IsShown()
				then
					btn.sbb:SetBackdropBorderColor(0.498, 0.498, 0.498, 1) -- grey border
				else
					btn.sbb:SetBackdropBorderColor(aObj.bbClr:GetRGBA())
				end
			end
			btn = nil
		end
	end

	self:SecureHookScript(_G.ToyBox, "OnShow", function(this)
		self:skinStatusBar{obj=this.progressBar, fi=0}
		self:removeRegions(this.progressBar, {2, 3})
		self:skinEditBox{obj=this.searchBox, regs={6, 7}, mi=true, noHeight=true, noInsert=true, y=-2} -- 6 is text, 7 is icon
		if self.modBtns then
			self:skinStdButton{obj=_G.ToyBoxFilterButton}
		end
		self:skinDropDown{obj=_G.ToyBoxFilterDropDown}
		self:removeInset(this.iconsFrame)
		this.iconsFrame:DisableDrawLayer("OVERLAY")
		this.iconsFrame:DisableDrawLayer("ARTWORK")
		this.iconsFrame:DisableDrawLayer("BORDER")
		this.iconsFrame:DisableDrawLayer("BACKGROUND")
		for i = 1, 18 do
			this.iconsFrame["spellButton" .. i].slotFrameCollected:SetTexture(nil)
			this.iconsFrame["spellButton" .. i].slotFrameUncollected:SetTexture(nil)
			if self.modBtnBs then
				self:addButtonBorder{obj=this.iconsFrame["spellButton" .. i], sec=true, ofs=0}
			end
		end
		self:skinDropDown{obj=this.toyOptionsMenu}

		if self.modBtnBs then
			skinPageBtns(this)
			self:SecureHook("ToySpellButton_UpdateButton", function(this)
				skinCollectionBtn(this)
			end)
		end

		self:skinGlowBox(this.favoriteHelpBox, ftype)
		self:skinGlowBox(this.mousewheelPagingHelpBox, ftype)

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.HeirloomsJournal, "OnShow", function(this)
		self:skinStatusBar{obj=this.progressBar, fi=0}
		self:removeRegions(this.progressBar, {2, 3})
		self:skinEditBox{obj=this.SearchBox, regs={6, 7}, mi=true, noHeight=true, noInsert=true, y=-2} -- 6 is text, 7 is icon
		if self.modBtns then
			self:skinStdButton{obj=_G.HeirloomsJournalFilterButton}
		end
		self:skinDropDown{obj=_G.HeirloomsJournalFilterDropDown}
		self:skinDropDown{obj=_G.HeirloomsJournalClassDropDown}
		self:removeInset(this.iconsFrame)
		this.iconsFrame:DisableDrawLayer("OVERLAY")
		this.iconsFrame:DisableDrawLayer("ARTWORK")
		this.iconsFrame:DisableDrawLayer("BORDER")
		this.iconsFrame:DisableDrawLayer("BACKGROUND")
		-- 18 icons per page ?
		self:SecureHook(this, "LayoutCurrentPage", function(this)
			for i = 1, #this.heirloomHeaderFrames do
				this.heirloomHeaderFrames[i]:DisableDrawLayer("BACKGROUND")
				this.heirloomHeaderFrames[i].text:SetTextColor(self.HT:GetRGB())
			end
			local heirloom
			for i = 1, #this.heirloomEntryFrames do
				heirloom = this.heirloomEntryFrames[i]
				heirloom.slotFrameCollected:SetTexture(nil)
				heirloom.slotFrameUncollected:SetTexture(nil)
				-- ignore btn.levelBackground as its textures is changed when upgraded
				if self.modBtnBs then
					self:addButtonBorder{obj=heirloom, sec=true, ofs=0, reParent={heirloom.new, heirloom.levelBackground, heirloom.level}}
					skinCollectionBtn(heirloom)
				end
			end
			heirloom = nil
		end)

		self:SecureHookScript(this.UpgradeLevelHelpBox, "OnShow", function(this)
			self:skinGlowBox(this, ftype)

			self:Unhook(this, "OnShow")
		end)

		if self.modBtnBs then
			skinPageBtns(this)
			self:SecureHook(this, "UpdateButton", function(this, button)
				skinCollectionBtn(button)
				if button.levelBackground:GetAtlas() == "collections-levelplate-black" then
					self:changeTandC(button.levelBackground, self.lvlBG)
				end
			end)
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.WardrobeCollectionFrame, "OnShow", function(this)

		self:skinTabs{obj=this, up=true, lod=true, x1=2, y1=-4, x2=-2, y2=-4}
		self:skinEditBox{obj=this.searchBox, regs={6, 7}, mi=true, noHeight=true, noInsert=true} -- 6 is text, 7 is icon
		_G.RaiseFrameLevelByTwo(this.searchBox) -- raise above SetsCollectionFrame when displayed on it
		self:skinStatusBar{obj=this.progressBar, fi=0}
		self:removeRegions(this.progressBar, {2, 3})
		self:skinDropDown{obj=this.FilterDropDown}

		if self.modBtns then
			self:skinStdButton{obj=this.FilterButton}
			_G.RaiseFrameLevelByTwo(this.FilterButton) -- raise above SetsCollectionFrame when displayed on it
		end
		self:skinGlowBox(this.SetsTabHelpBox, ftype)

		self:SecureHookScript(this.searchProgressFrame, "OnShow", function(this)
			this:DisableDrawLayer("BACKGROUND")
			this:DisableDrawLayer("ARTWORK")
			self:skinStatusBar{obj=this.searchProgressBar, 0, bgTex=this.searchProgressBar.barBackground}
			this.searchProgressBar:DisableDrawLayer("ARTWORK")
			self:addSkinFrame{obj=this, ft=ftype}

			self:Unhook(this, "OnShow")
		end)

		local x1Ofs, y1Ofs, x2Ofs, y2Ofs = -5, 3, 7, -8

		self:SecureHookScript(this.ItemsCollectionFrame, "OnShow", function(this)
			-- this:DisableDrawLayer("BACKGROUND")
			self:skinDropDown{obj=this.RightClickDropDown}
			self:skinDropDown{obj=this.WeaponDropDown}
			-- add skin frame, so tabs look better than without a frame
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true, aso={bd=10, ng=true}, x1=x1Ofs, y1=y1Ofs, x2=x2Ofs, y2=y2Ofs}
			local updBtnClr
			if self.modBtnBs then
				skinPageBtns(this)
				local function updBtnClr(btn)
					local atlas = btn.Border:GetAtlas()
					aObj:Debug("ItemsCollectionFrame updBtnClr: [%s, %s]", atlas)
					if atlas:find("uncollected", 1, true) then
						btn.sbb:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
					elseif atlas:find("unusable", 1, true) then
						btn.sbb:SetBackdropBorderColor(0.8, 0.2, 0.2, 1)
					else
						btn.sbb:SetBackdropBorderColor(0.8, 0.6, 0, 0.85)
					end
				end
				local btn
				for i = 1, #this.Models do
					btn = this.Models[i]
					self:removeRegions(btn, {2}) -- background & border
					self:addButtonBorder{obj=btn, reParent={btn.Favorite.Icon, btn.HideVisual.Icon}, ofs=6}
					updBtnClr(btn)
				end
				btn = nil
				self:SecureHook(this, "UpdateItems", function(this)
					for i = 1, #this.Models do
						updBtnClr(this.Models[i])
					end
				end)
			end

			self:skinGlowBox(this.HelpBox, ftype)

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(this.ItemsCollectionFrame)

		self:SecureHookScript(this.SetsCollectionFrame, "OnShow", function(this)
			self:removeInset(this.LeftInset)
			self:keepFontStrings(this.RightInset)
			self:removeNineSlice(this.RightInset.NineSlice)
			self:skinSlider{obj=this.ScrollFrame.scrollBar, wdth=-4, size=3}
			self:skinDropDown{obj=this.ScrollFrame.FavoriteDropDown}
			for i = 1, #this.ScrollFrame.buttons do
				this.ScrollFrame.buttons[i]:DisableDrawLayer("BACKGROUND")
				if self.modBtnBs then
					 self:addButtonBorder{obj=this.ScrollFrame.buttons[i], relTo=this.ScrollFrame.buttons[i].Icon}
				end
			end
			this.DetailsFrame:DisableDrawLayer("BACKGROUND")
			this.DetailsFrame:DisableDrawLayer("BORDER")
			self:skinDropDown{obj=this.DetailsFrame.VariantSetsDropDown}
			if self.modBtns then
				 self:skinStdButton{obj=this.DetailsFrame.VariantSetsButton}
			end
			if self.modBtnBs then
				colourBtns(this.ScrollFrame)
				self:SecureHook(this.ScrollFrame, "update", function(this) -- use lowercase for scrollframe function
					colourBtns(this)
				end)
			end

			-- add skin frame, so tabs look better than without a frame
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true, aso={bd=10, ng=true}, x1=x1Ofs, y1=y1Ofs, x2=x2Ofs, y2=y2Ofs}

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(this.SetsTransmogFrame, "OnShow", function(this)
			self:skinDropDown{obj=this.RightClickDropDown}
			if self.modBtnBs then
				skinPageBtns(this)
			end

			-- add skin frame, so tabs look better than without a frame
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true, aso={bd=10, ng=true}, x1=x1Ofs, y1=y1Ofs, x2=x2Ofs, y2=y2Ofs}

			self:Unhook(this, "OnShow")
		end)

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.WardrobeFrame, "OnShow", function(this)
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, y2=-5}

		self:Unhook(this, "OnShow")
	end)

	-- used by Transmog as well as Appearance
	self:SecureHookScript(_G.WardrobeTransmogFrame, "OnShow", function(this)
		this:DisableDrawLayer("ARTWORK")
		self:removeInset(this.Inset)
		self:skinDropDown{obj=this.OutfitDropDown, y2=-4}
		for i = 1, #this.Model.SlotButtons do
			this.Model.SlotButtons[i].Border:SetTexture(nil)
			if self.modBtnBs then
				 self:addButtonBorder{obj=this.Model.SlotButtons[i], ofs=-2}
			end
		end
		this.Model.controlFrame:DisableDrawLayer("BACKGROUND")
		self:skinDropDown{obj=this.SpecDropDown}

		if self.modBtns then
			self:skinStdButton{obj=this.OutfitDropDown.SaveButton}
			self:skinStdButton{obj=this.ApplyButton, ofs=0}
		end
		if self.modBtnBs then
			 self:addButtonBorder{obj=this.Model.ClearAllPendingButton, ofs=1, x2=0, relTo=this.Model.ClearAllPendingButton.Icon}
			 self:addButtonBorder{obj=this.SpecButton, ofs=0}
		end

		self:SecureHookScript(this.OutfitHelpBox, "OnShow", function(this)
			self:skinGlowBox(this, ftype)

			self:Unhook(this, "OnShow")
		end)
		self:SecureHookScript(this.SpecHelpBox, "OnShow", function(this)
			self:skinGlowBox(this, ftype)

			self:Unhook(this, "OnShow")
		end)

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].CompactFrames = function(self)
	if IsAddOnLoaded("Tukui")
	or IsAddOnLoaded("ElvUI")
	then
		aObj.blizzFrames[ftype].CompactFrames = nil
		return
	end

	if not self.prdb.CompactFrames or self.initialized.CompactFrames then return end
	self.initialized.CompactFrames = true

	local function skinUnit(unit)

		-- handle Raid Profile changes and new unit(s)
		if aObj:hasTextInTexture(unit.healthBar:GetStatusBarTexture(), "RaidFrame") then
			unit:DisableDrawLayer("BACKGROUND")
			unit.horizDivider:SetTexture(nil)
			unit.horizTopBorder:SetTexture(nil)
			unit.horizBottomBorder:SetTexture(nil)
			unit.vertLeftBorder:SetTexture(nil)
			unit.vertRightBorder:SetTexture(nil)
			aObj:skinStatusBar{obj=unit.healthBar, fi=0, bgTex=unit.healthBar.background}
			aObj:skinStatusBar{obj=unit.powerBar, fi=0, bgTex=unit.powerBar.background}
		end

	end
	local function skinGrp(grp)

		local grpName = grp:GetName()
		for i = 1, _G.MEMBERS_PER_RAID_GROUP do
			skinUnit(_G[grpName .. "Member" .. i])
		end
		grpName = nil
		if not grp.borderFrame.sf then
			aObj:addSkinFrame{obj=grp.borderFrame, ft=ftype, kfs=true, y1=-1, x2=-3, y2=3}
		end

	end

	-- Compact Party Frame
	self:SecureHook("CompactPartyFrame_OnLoad", function()
		self:addSkinFrame{obj=_G.CompactPartyFrame.borderFrame, ft=ftype, kfs=true, y1=-1, x2=-3, y2=3}
		self:Unhook("CompactPartyFrame_OnLoad")
	end)
	-- hook this to skin any new CompactRaidGroup(s)
	self:SecureHook("CompactRaidGroup_UpdateLayout", function(frame)
		skinGrp(frame)
	end)

	-- Compact RaidFrame Container
	-- handle AddOn being disabled
	if not self:checkLoadable("Blizzard_CompactRaidFrames") then return end

	local function skinCRFCframes()

		-- handle in combat as UnitFrame uses SecureUnitButtonTemplate
		if _G.InCombatLockdown() then
			aObj:add2Table(aObj.oocTab, {skinCRFCframes, {nil}})
			return
		end

		for type, fTab in pairs(_G.CompactRaidFrameContainer.frameUpdateList) do
			local frame
			for i = 1, #fTab do
				frame = fTab[i]
				if type == "normal" then
					if frame.borderFrame then -- group or party
						skinGrp(frame)
					else
						skinUnit(frame)
					end
				elseif type == "mini" then
					skinUnit(frame)
				end
			end
			frame = nil
		end

	end
	-- hook this to skin any new CompactRaidFrameContainer entries
	self:SecureHook("FlowContainer_AddObject", function(container, object)
		if container == _G.CompactRaidFrameContainer then -- only for compact raid frame objects
			skinCRFCframes()
		end
	end)
	-- skin any existing unit(s) [mini, normal]
	skinCRFCframes()
	self:addSkinFrame{obj=_G.CompactRaidFrameContainer.borderFrame, ft=ftype, kfs=true, y1=-1, x2=-5, y2=5}

	-- Compact RaidFrame Manager
	self:SecureHookScript(_G.CompactRaidFrameManager, "OnShow", function(this)
		-- Toggle button
		self:moveObject{obj=this.toggleButton, x=5}
		this.toggleButton:SetSize(12, 32)
		this.toggleButton.nt = this.toggleButton:GetNormalTexture()
		this.toggleButton.nt:SetTexCoord(0.22, 0.5, 0.33, 0.67)
		-- hook this to trim the texture
		self:RawHook(this.toggleButton.nt, "SetTexCoord", function(this, x1, x2, y1, y2)
			self.hooks[this].SetTexCoord(this, x1 == 0 and x1 + 0.22 or x1 + 0.26, x2, 0.33, 0.67)
		end, true)

		-- Display Frame
		_G.CompactRaidFrameManagerDisplayFrameHeaderBackground:SetTexture(nil)
		_G.CompactRaidFrameManagerDisplayFrameHeaderDelineator:SetTexture(nil)
		-- Buttons
		for _, type in pairs{"Tank", "Healer", "Damager"} do
			self:skinStdButton{obj=this.displayFrame.filterOptions["filterRole" .. type]}
		end
		for i = 1, 8 do
			self:skinStdButton{obj=this.displayFrame.filterOptions["filterGroup" .. i]}
		end
		this.displayFrame.filterOptions:DisableDrawLayer("BACKGROUND")
		self:skinDropDown{obj=this.displayFrame.profileSelector}
		self:skinStdButton{obj=this.displayFrame.lockedModeToggle}
		self:skinStdButton{obj=this.displayFrame.hiddenModeToggle}
		self:skinStdButton{obj=this.displayFrame.convertToRaid}
		-- Leader Options
		self:skinStdButton{obj=this.displayFrame.leaderOptions.rolePollButton}
		self:skinStdButton{obj=this.displayFrame.leaderOptions.readyCheckButton}
		self:skinStdButton{obj=_G.CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton}
		_G.CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:GetNormalTexture():SetAlpha(1) -- icon
		if self.modChkBtns then
			self:skinCheckButton{obj=this.displayFrame.everyoneIsAssistButton}
			_G.RaiseFrameLevel(this.displayFrame.everyoneIsAssistButton) -- so button border is visible
		end
		-- Resize Frame
		self:addSkinFrame{obj=this.containerResizeFrame, ft=ftype, kfs=true, x1=-2, y1=-1, y2=4}
		-- Raid Frame Manager Frame
		self:addSkinFrame{obj=this, ft=ftype, kfs=true}

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.CompactRaidFrameManager)

end

aObj.blizzLoDFrames[ftype].Communities = function(self)
	if not self.prdb.CommunitiesUI or self.initialized.CommunitiesUI then return end

	if not _G.CommunitiesFrame then
		_G.C_Timer.After(0.1, function()
			self.blizzLoDFrames[ftype].Communities(self)
		end)
		return
	end

	self.initialized.CommunitiesUI = true

	local function skinColumnDisplay(frame)
		frame:DisableDrawLayer("BACKGROUND")
		frame:DisableDrawLayer("BORDER")
		frame:DisableDrawLayer("ARTWORK")
		for header in frame.columnHeaders:EnumerateActive() do
			header:DisableDrawLayer("BACKGROUND")
			aObj:addSkinFrame{obj=header, ft=ftype}
		end
	end

	local cFrame = _G.CommunitiesFrame

	-->> N.B. Currently can't be skinned, as the XML has a ScopedModifier element saying forbidden="true"
		-- CommunitiesAddDialog
		-- CommunitiesCreateDialog

	self:keepFontStrings(cFrame.PortraitOverlay)

	cFrame.MaximizeMinimizeFrame:DisableDrawLayer("BACKGROUND")
	if self.modBtns then
		self:skinOtherButton{obj=cFrame.MaximizeMinimizeFrame.MaximizeButton, font=self.fontS, text="↕"}
		self:skinOtherButton{obj=cFrame.MaximizeMinimizeFrame.MinimizeButton, font=self.fontS, text="↕"}
	end

	self:SecureHookScript(cFrame.CommunitiesList, "OnShow", function(this)
		this:DisableDrawLayer("BORDER")
		this:DisableDrawLayer("ARTWORK")
		self:skinSlider{obj=this.ListScrollFrame.ScrollBar, wdth=-4}
		self:skinDropDown{obj=this.EntryDropDown}
		this.FilligreeOverlay:DisableDrawLayer("ARTWORK")
		this.FilligreeOverlay:DisableDrawLayer("OVERLAY")
		this.FilligreeOverlay:DisableDrawLayer("BORDER")
		self:removeInset(this.InsetFrame)
		for i = 1, #this.ListScrollFrame.buttons do
			self:removeRegions(this.ListScrollFrame.buttons[i], {1})
			self:changeRecTex(this.ListScrollFrame.buttons[i].Selection, true)
			this.ListScrollFrame.buttons[i].Selection:SetHeight(60)
			self:changeRecTex(this.ListScrollFrame.buttons[i]:GetHighlightTexture())
			this.ListScrollFrame.buttons[i]:GetHighlightTexture():SetHeight(60)
		end
		self:SecureHook(this, "Update", function(cList)
			for i = 1, #cList.ListScrollFrame.buttons do
				self:removeRegions(cList.ListScrollFrame.buttons[i], {1})
				self:changeRecTex(cList.ListScrollFrame.buttons[i].Selection, true)
				cList.ListScrollFrame.buttons[i].Selection:SetHeight(60)
			end
		end)
		self:Unhook(this, "OnShow")
	end)

	for _, tabName in pairs{"ChatTab", "RosterTab", "GuildBenefitsTab", "GuildInfoTab"} do
		cFrame[tabName]:DisableDrawLayer("BORDER")
		if self.modBtnBs then
			self:addButtonBorder{obj=cFrame[tabName]}
		end
	end

	self:skinDropDown{obj=cFrame.StreamDropDownMenu}
	self:skinDropDown{obj=cFrame.GuildMemberListDropDownMenu}
	self:skinDropDown{obj=cFrame.CommunitiesListDropDownMenu}

	-- VoiceChatHeadset
	-- CommunitiesCalendarButton

	self:SecureHookScript(cFrame.MemberList.ColumnDisplay, "OnShow", function(this)
		skinColumnDisplay(this)
	end)
	if self.modChkBtns then
		 self:skinCheckButton{obj=cFrame.MemberList.ShowOfflineButton, hf=true}
	end
	self:skinSlider{obj=cFrame.MemberList.ListScrollFrame.scrollBar, wdth=-4}
	self:skinDropDown{obj=cFrame.MemberList.DropDown}
	self:removeInset(cFrame.MemberList.InsetFrame)
	self:SecureHook(cFrame.MemberList, "RefreshListDisplay", function(this)
		if not this:IsDisplayingProfessions() then return end
		local btn
		for i = 1, #this.ListScrollFrame.buttons do
			btn = this.ListScrollFrame.buttons[i]
			self:removeRegions(btn.ProfessionHeader, {1, 2, 3}) -- header textures
		end
	end)

	self:skinSlider{obj=cFrame.Chat.MessageFrame.ScrollBar, wdth=-4}
	if self.modBtns then
		 self:skinStdButton{obj=_G.JumpToUnreadButton}
	end
	self:removeInset(cFrame.Chat.InsetFrame)

	self:skinEditBox{obj=cFrame.ChatEditBox, regs={6}} -- 6 is text

	self:SecureHookScript(cFrame.InvitationFrame, "OnShow", function(this)
		this:DisableDrawLayer("BACKGROUND")
		this:DisableDrawLayer("ARTWORK")
		self:removeInset(this.InsetFrame)
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true}
		if self.modBtns then
			self:skinStdButton{obj=this.AcceptButton}
			self:skinStdButton{obj=this.DeclineButton}
		end
		self:Unhook(this, "OnShow")
	end)

	-- TicketFrame
	self:removeNineSlice(cFrame.TicketFrame.InsetFrame.NineSlice)
	if self.modBtns then
		self:skinStdButton{obj=cFrame.TicketFrame.AcceptButton}
		self:skinStdButton{obj=cFrame.TicketFrame.DeclineButton}
	end

	cFrame.GuildFinderFrame:DisableDrawLayer("BACKGROUND")
	self:removeNineSlice(cFrame.GuildFinderFrame.InsetFrame.NineSlice)
	if self.modBtns then
		self:skinStdButton{obj=cFrame.GuildFinderFrame.FindAGuildButton}
	end

	self:SecureHookScript(cFrame.GuildBenefitsFrame, "OnShow", function(this)
		this:DisableDrawLayer("OVERLAY") -- inset textures
		self:removeRegions(this.Perks, {1})
		self:skinSlider{obj=self:getChild(this.Perks.Container, 2), wdth=-4}
		local btn
		for i = 1, #this.Perks.Container.buttons do
			btn = this.Perks.Container.buttons[i]
			self:removeRegions(btn, {1, 2, 3, 4})
			btn.NormalBorder:DisableDrawLayer("BACKGROUND")
			btn.DisabledBorder:DisableDrawLayer("BACKGROUND")
			if self.modBtnBs then
				 self:addButtonBorder{obj=btn, relTo=btn.Icon}
			end
		end
		btn = nil
		this.Rewards.Bg:SetTexture(nil)
		self:skinSlider{obj=this.Rewards.RewardsContainer.scrollBar, rt="artwork", wdth=-4}
		local btn
		for i = 1, #this.Rewards.RewardsContainer.buttons do
			btn = this.Rewards.RewardsContainer.buttons[i]
			btn:GetNormalTexture():SetAlpha(0)
			btn.DisabledBG:SetAlpha(0)
			if self.modBtnBs then
				 self:addButtonBorder{obj=btn, relTo=btn.Icon, reParent={btn.Lock}}
			end
		end
		btn = nil
		self:skinDropDown{obj=this.Rewards.DropDown}
		this.FactionFrame.Bar:DisableDrawLayer("BORDER")
		this.FactionFrame.Bar.Progress:SetTexture(self.sbTexture)
		this.FactionFrame.Bar.Shadow:SetTexture(nil)

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(cFrame.GuildDetailsFrame, "OnShow", function(this)
		self:removeRegions(this.Info, {2, 3, 4, 5, 6, 7, 8, 9, 10})
		self:skinSlider{obj=this.Info.MOTDScrollFrame.ScrollBar, wdth=-4}
		for i = 1, #this.Info.Challenges do
			-- this.Info.Challenges[i]
		end
		self:skinSlider{obj=this.Info.DetailsFrame.ScrollBar, wdth=-6}
		this.News:DisableDrawLayer("BACKGROUND")
		if self.modBtns then
			self:skinStdButton{obj=this.Info.EditMOTDButton}
			self:skinStdButton{obj=this.Info.EditDetailsButton}
			self:skinStdButton{obj=this.News.SetFiltersButton}
			self:skinStdButton{obj=this.News.GMImpeachButton}
		end
		self:skinSlider{obj=this.News.Container.ScrollBar, wdth=-4}
		for i = 1, #this.News.Container.buttons do
			this.News.Container.buttons[i].header:SetTexture(nil)
		end
		self:skinDropDown{obj=this.News.DropDown}
		self:keepFontStrings(this.News.BossModel)
		self:removeRegions(this.News.BossModel.TextFrame, {2, 3, 4, 5, 6}) -- border textures
		this:DisableDrawLayer("OVERLAY")

		self:Unhook(this, "OnShow")
	end)

	self:skinGlowBox(cFrame.GuildNameAlertFrame, ftype, true)

	self:SecureHookScript(cFrame.GuildNameChangeFrame, "OnShow", function(this)
		this:DisableDrawLayer("BACKGROUND")
		self:skinEditBox{obj=this.EditBox, regs={6}} -- 6 is text
		if self.modBtns then
			self:skinStdButton{obj=this.Button}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=this.CloseButton}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(cFrame.EditStreamDialog, "OnShow", function(this)
		self:removeNineSlice(this.BG)
		self:skinEditBox{obj=this.NameEdit, regs={6}} -- 6 is text
		this.NameEdit:SetPoint("TOPLEFT", this.NameLabel, "BOTTOMLEFT", -4, 0)
		self:addSkinFrame{obj=this.Description, ft=ftype, kfs=true, nb=true, ofs=7}
		self:skinCheckButton{obj=this.TypeCheckBox}
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true}
		self:skinStdButton{obj=this.Accept}
		self:skinStdButton{obj=this.Delete}
		self:skinStdButton{obj=this.Cancel}

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(cFrame.NotificationSettingsDialog, "OnShow", function(this)
		self:skinDropDown{obj=this.CommunitiesListDropDownMenu}
		self:skinSlider{obj=this.ScrollFrame.ScrollBar, wdth=-4}
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true, ofs=-6, x2=-4}
		if self.modBtns then
			self:skinStdButton{obj=this.ScrollFrame.Child.NoneButton}
			self:skinStdButton{obj=this.ScrollFrame.Child.AllButton}
			self:skinStdButton{obj=this.CancelButton}
			self:skinStdButton{obj=this.OkayButton}
		end
		if self.modChkBtns then
			 self:skinCheckButton{obj=this.ScrollFrame.Child.QuickJoinButton}
		end

		self:Unhook(this, "OnShow")
	end)

	self:moveObject{obj=cFrame.AddToChatButton, x=-6, y=-6}

	if self.modBtns then
		self:skinStdButton{obj=cFrame.AddToChatButton}
		self:skinStdButton{obj=cFrame.InviteButton}
		self:skinStdButton{obj=cFrame.CommunitiesControlFrame.CommunitiesSettingsButton}
		self:skinStdButton{obj=cFrame.CommunitiesControlFrame.GuildRecruitmentButton}
		self:skinStdButton{obj=cFrame.CommunitiesControlFrame.GuildControlButton}
		self:skinStdButton{obj=cFrame.GuildLogButton}
	end

	-- N.B. hook DisplayMember rather than OnShow script
	self:SecureHook(cFrame.GuildMemberDetailFrame, "DisplayMember", function(this, ...)
		self:removeNineSlice(this.Border)
		self:skinDropDown{obj=this.RankDropdown}
		self:addSkinFrame{obj=this.NoteBackground, ft=ftype}
		self:addSkinFrame{obj=this.OfficerNoteBackground, ft=ftype}
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ofs=-6}
		if self.modBtns then
			self:skinStdButton{obj=this.RemoveButton}
			self:skinStdButton{obj=this.GroupInviteButton}
		end

		self:Unhook(this, "DisplayMember")
	end)

	self:addSkinFrame{obj=cFrame, ft=ftype, kfs=true, ri=true, x1=-5}

	cFrame = nil

	self:SecureHookScript(_G.CommunitiesAvatarPickerDialog, "OnShow", function(this)
		self:skinSlider{obj=this.ScrollFrame.ScrollBar, rt="background"}
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true}
		if self.modBtns then
			self:skinStdButton{obj=this.CancelButton}
			self:skinStdButton{obj=this.OkayButton}
		end
		if self.modBtnBs then
			for i = 1, 5 do
				for j = 1, 6 do
					self:addButtonBorder{obj=this.ScrollFrame.avatarButtons[i][j]}
				end
			end
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.CommunitiesTicketManagerDialog, "OnShow", function(this)
		self:skinDropDown{obj=this.UsesDropDownMenu}
		this.InviteManager.ArtOverlay:DisableDrawLayer("OVERLAY")
		this.InviteManager.ListScrollFrame:DisableDrawLayer("BACKGROUND")
		self:skinSlider{obj=this.InviteManager.ListScrollFrame.scrollBar, wdth=-4}
		skinColumnDisplay(this.InviteManager.ColumnDisplay)
		if self.modBtns then
			for i = 1, #this.InviteManager.ListScrollFrame.buttons do
				self:skinStdButton{obj=this.InviteManager.ListScrollFrame.buttons[i].CopyLinkButton}
				if self.modBtnBs then
					 self:addButtonBorder{obj=this.InviteManager.ListScrollFrame.buttons[i].RevokeButton, ofs=0}
				end
			end
		end
		self:addSkinFrame{obj=this.InviteManager, ft=ftype, kfs=true, nb=true, x1=8, y1=-8, x2=-12, y2=-4}
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true, y1=-8, y2=6}
		if self.modBtns then
			self:skinStdButton{obj=this.LinkToChat}
			self:skinStdButton{obj=this.Copy}
			self:skinStdButton{obj=this.GenerateLinkButton}
			self:skinDropDown{obj=this.ExpiresDropDownMenu}
			self:skinStdButton{obj=this.Close}
		end
		if self.modBtnBs then
			 self:addButtonBorder{obj=this.MaximizeButton, ofs=0}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.CommunitiesSettingsDialog, "OnShow", function(this)
		self:skinEditBox{obj=this.NameEdit, regs={6}} -- 6 is text
		self:skinEditBox{obj=this.ShortNameEdit, regs={6}} -- 6 is text
		self:addSkinFrame{obj=this.MessageOfTheDay, ft=ftype, kfs=true, nb=true, ofs=8}
		self:addSkinFrame{obj=this.Description, ft=ftype, kfs=true, nb=true, ofs=8}
		if self.modBtns then
			self:skinStdButton{obj=this.ChangeAvatarButton}
			self:skinStdButton{obj=this.Delete}
			self:skinStdButton{obj=this.Accept}
			self:skinStdButton{obj=this.Cancel}
		end
		self:addSkinFrame{obj=this, ft=ftype, nb=true, ofs=-10}

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.CommunitiesGuildRecruitmentFrame, "OnShow", function(this)
		-- Recruitment
		this.Recruitment.InterestFrame:DisableDrawLayer("BACKGROUND")
		this.Recruitment.AvailabilityFrame:DisableDrawLayer("BACKGROUND")
		this.Recruitment.RolesFrame:DisableDrawLayer("BACKGROUND")
		this.Recruitment.LevelFrame:DisableDrawLayer("BACKGROUND")
		this.Recruitment.CommentFrame:DisableDrawLayer("BACKGROUND")
		self:skinSlider{obj=this.Recruitment.CommentFrame.CommentInputFrame.ScrollFrame.ScrollBar}
		this.Recruitment.CommentFrame.CommentInputFrame.ScrollFrame.CommentEditBox.Fill:SetTextColor(self.BT:GetRGB())
		if self.modChkBtns then
			self:skinCheckButton{obj=this.Recruitment.InterestFrame.QuestButton}
			self:skinCheckButton{obj=this.Recruitment.InterestFrame.RaidButton}
			self:skinCheckButton{obj=this.Recruitment.InterestFrame.DungeonButton}
			self:skinCheckButton{obj=this.Recruitment.InterestFrame.PvPButton}
			self:skinCheckButton{obj=this.Recruitment.InterestFrame.RPButton}
			self:skinCheckButton{obj=this.Recruitment.AvailabilityFrame.WeekdaysButton}
			self:skinCheckButton{obj=this.Recruitment.AvailabilityFrame.WeekendsButton}
			self:skinCheckButton{obj=this.Recruitment.RolesFrame.TankButton.checkButton}
			self:skinCheckButton{obj=this.Recruitment.RolesFrame.HealerButton.checkButton}
			self:skinCheckButton{obj=this.Recruitment.RolesFrame.DamagerButton.checkButton}
		end
		self:addSkinFrame{obj=this.Recruitment.CommentFrame.CommentInputFrame, ft=ftype, kfs=true}
		self:removeMagicBtnTex(this.Recruitment.ListGuildButton)
		if self.modBtns then
			 self:skinStdButton{obj=this.Recruitment.ListGuildButton}
		end
		-- Applicants
		for i = 1, #this.Applicants.Container.buttons do
			self:applySkin{obj=this.Applicants.Container.buttons[i]}
			this.Applicants.Container.buttons[i].ring:SetAlpha(0)
			this.Applicants.Container.buttons[i].PointsSpentBgGold:SetAlpha(0)
			self:moveObject{obj=this.Applicants.Container.buttons[i].PointsSpentBgGold, x=6, y=-6}
		end
		self:skinSlider{obj=this.Applicants.Container.scrollBar, wdth=-4}
		self:removeMagicBtnTex(this.Applicants.InviteButton)
		self:removeMagicBtnTex(this.Applicants.MessageButton)
		self:removeMagicBtnTex(this.Applicants.DeclineButton)
		if self.modBtns then
			self:skinStdButton{obj=this.Applicants.InviteButton}
			self:skinStdButton{obj=this.Applicants.MessageButton}
			self:skinStdButton{obj=this.Applicants.DeclineButton}
		end
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true}
		self:skinTabs{obj=this, up=true, lod=true, x1=2, y1=-5, x2=2, y2=-5}

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.CommunitiesGuildTextEditFrame, "OnShow", function(this)
		self:skinSlider{obj=_G.CommunitiesGuildTextEditFrame.Container.ScrollFrame.ScrollBar, wdth=-6}
		self:addSkinFrame{obj=_G.CommunitiesGuildTextEditFrame.Container, ft=ftype}
		if self.modBtns then
			self:skinStdButton{obj=_G.CommunitiesGuildTextEditFrameAcceptButton}
			self:skinStdButton{obj=self:getChild(_G.CommunitiesGuildTextEditFrame, 4)} -- bottom close button
		end
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ofs=-7}

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.CommunitiesGuildLogFrame, "OnShow", function(this)
		self:skinSlider{obj=this.Container.ScrollFrame.ScrollBar, wdth=-6}
		self:addSkinFrame{obj=this.Container, ft=ftype}
		if self.modBtns then
			 self:skinStdButton{obj=self:getChild(this, 3)} -- bottom close button
		end
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ofs=-7}

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.CommunitiesGuildNewsFiltersFrame, "OnShow", function(this)
		if self.modChkBtns then
			self:skinCheckButton{obj=this.GuildAchievement}
			self:skinCheckButton{obj=this.Achievement}
			self:skinCheckButton{obj=this.DungeonEncounter}
			self:skinCheckButton{obj=this.EpicItemLooted}
			self:skinCheckButton{obj=this.EpicItemPurchased}
			self:skinCheckButton{obj=this.EpicItemCrafted}
			self:skinCheckButton{obj=this.LegendaryItemLooted}
		end
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ofs=-7}

		self:Unhook(this, "OnShow")
	end)

end

local gearTex = [[Interface\AddOns\]] .. aName .. [[\Textures\gear]]
aObj.blizzFrames[ftype].ContainerFrames = function(self)
	if not self.prdb.ContainerFrames.skin or self.initialized.ContainerFrames then return end
	self.initialized.ContainerFrames = true

	if not IsAddOnLoaded("LiteBag") then
		local objName, cfpb
		local function skinBag(frame, id)

			objName = frame:GetName()

			aObj:addSkinFrame{obj=frame, ft=ftype, kfs=true, x1=8, y1=-4, x2=-3}
			-- resize and move the bag name to make it more readable
			_G[objName .. "Name"]:SetWidth(137)
			aObj:moveObject{obj=_G[objName .. "Name"], x=-17}
			-- Add gear texture to portrait button for settings
			local cfpb = frame.PortraitButton
			cfpb.gear = cfpb:CreateTexture(nil, "artwork")
			cfpb.gear:SetAllPoints()
			cfpb.gear:SetTexture(gearTex)
			cfpb:SetSize(18, 18)
			cfpb.Highlight:ClearAllPoints()
			cfpb.Highlight:SetPoint("center")
			cfpb.Highlight:SetSize(22, 22)
			aObj:moveObject{obj=cfpb, x=7, y=-5}
			cfpb = nil
			if aObj.modBtnBs then
				-- skin the item buttons
				local bo
				for i = 1, _G.MAX_CONTAINER_ITEMS do
					bo = _G[objName .. "Item" .. i]
					aObj:addButtonBorder{obj=bo, ibt=true, reParent={_G[objName .. "Item" .. i .. "IconQuestTexture"], bo.JunkIcon, bo.UpgradeIcon, bo.flash, bo.NewItemTexture, bo.BattlepayItemTexture}}
				end
				bo = nil
				-- update Button quality borders
				_G.ContainerFrame_Update(frame)
			end

			-- Backpack
			if id == 0 then
				aObj:skinEditBox{obj=_G.BagItemSearchBox, regs={6, 7}, mi=true, noInsert=true} -- 6 is text, 7 is icon
				if aObj.modBtnBs then
					aObj:addButtonBorder{obj=_G.BagItemAutoSortButton, ofs=0, y1=1}
				end
				-- TokenFrame
				_G.BackpackTokenFrame:DisableDrawLayer("BACKGROUND")
			end

			if aObj.modBtns then
				_G[objName .. "AddSlotsButton"]:DisableDrawLayer("OVERLAY")
				aObj:skinStdButton{obj=_G[objName .. "AddSlotsButton"]}
				aObj:skinCloseButton{obj=frame.ExtraBagSlotsHelpBox.CloseButton, noSkin=true}
			end
			objName = nil

		end

		-- Hook this to skinhide/show the gear button
		self:SecureHook("ContainerFrame_GenerateFrame", function(frame, size, id)
			-- skin the frame if required
			if not frame.sf then
				skinBag(frame, id)
			end

		end)

		-- hook this to move the Search Box to the left, away from the AutoSort button
		self:RawHook(_G.BagItemSearchBox, "SetPoint", function(this, point, relTo, relPoint, xOfs, yOfs)
			self.hooks[this].SetPoint(this, point, relTo, relPoint, 50, -35)
		end, true)
	end

	self:SecureHookScript(_G.ArtifactRelicHelpBox, "OnShow", function(this)
		self:skinGlowBox(this, ftype)

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.BagHelpBox, "OnShow", function(this)
		self:skinGlowBox(this, ftype)

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.AzeriteItemInBagHelpBox, "OnShow", function(this)
		self:skinGlowBox(this, ftype)

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].DressUpFrame = function(self)
	if not self.prdb.DressUpFrame or self.initialized.DressUpFrame then return end
	self.initialized.DressUpFrame = true

	if IsAddOnLoaded("DressUp") then
		aObj.blizzFrames[ftype].DressUpFrame = nil
		return
	end

	self:SecureHookScript(_G.SideDressUpFrame, "OnShow", function(this)
		self:removeRegions(this, {1, 2, 3, 4})
		_G.SideDressUpModel.controlFrame:DisableDrawLayer("BACKGROUND") -- model controls background
		self:skinStdButton{obj=_G.SideDressUpModelResetButton}
		self:removeRegions(_G.SideDressUpModelCloseButton, {5}) -- corner texture
		self:skinCloseButton{obj=_G.SideDressUpModelCloseButton}
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true, x1=-2, y1=-3, x2=-2}
		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.DressUpFrame, "OnShow", function(this)
		self:skinDropDown{obj=this.OutfitDropDown, y2=-4}
		this.MaxMinButtonFrame:DisableDrawLayer("BACKGROUND") -- button texture
		if self.modBtns then
			self:skinStdButton{obj=this.OutfitDropDown.SaveButton}
			self:skinOtherButton{obj=this.MaxMinButtonFrame.MaximizeButton, font=self.fontS, text="↕"} -- up-down arrow
			self:skinOtherButton{obj=this.MaxMinButtonFrame.MinimizeButton, font=self.fontS, text="↕"} -- up-down arrow
			self:skinStdButton{obj=_G.DressUpFrameCancelButton}
			self:skinStdButton{obj=this.ResetButton}
		end
		this.DressUpModel.controlFrame:DisableDrawLayer("BACKGROUND")
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true, y2=-4}
		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzLoDFrames[ftype].EncounterJournal = function(self) -- a.k.a. Adenture Guide
	if not self.prdb.EncounterJournal or self.initialized.EncounterJournal then return end
	self.initialized.EncounterJournal = true

	-- used by both Encounters & Loot sub frames
	local function skinFilterBtn(btn)

		btn:DisableDrawLayer("BACKGROUND")
		btn:SetNormalTexture(nil)
		btn:SetPushedTexture(nil)
		aObj:skinStdButton{obj=btn, x1=-11, y1=-2, x2=11, y2=2}

	end
	self:SecureHookScript(_G.EncounterJournal, "OnShow", function(this)
		self:skinEditBox{obj=this.searchBox, regs={6, 7}, mi=true} -- 6 is text, 7 is icon
		self:addSkinFrame{obj=this.searchBox.searchPreviewContainer, ft=ftype, kfs=true}
		-- adjust skinframe as parent frame is resized when populated
		this.searchBox.searchPreviewContainer.sf:SetPoint("TOPLEFT", this.searchBox.searchPreviewContainer.topBorder, "TOPLEFT", 0, 1)
		this.searchBox.searchPreviewContainer.sf:SetPoint("BOTTOMRIGHT", this.searchBox.searchPreviewContainer.botRightCorner, "BOTTOMRIGHT", 0, 4)
		_G.LowerFrameLevel(this.searchBox.searchPreviewContainer.sf)
		for i = 1, #this.searchBox.searchPreview do
			this.searchBox.searchPreview[i]:SetNormalTexture(nil)
			this.searchBox.searchPreview[i]:SetPushedTexture(nil)
		end
		this.searchBox.showAllResults:SetNormalTexture(nil)
		this.searchBox.showAllResults:SetPushedTexture(nil)
		self:addSkinFrame{obj=this.searchResults, ft=ftype, kfs=true, ofs=6, y1=-1, x2=4}
		self:skinSlider{obj=this.searchResults.scrollFrame.scrollBar, wdth=-4}
		for i = 1, #this.searchResults.scrollFrame.buttons do
			self:removeRegions(this.searchResults.scrollFrame.buttons[i], {1})
			this.searchResults.scrollFrame.buttons[i]:GetNormalTexture():SetAlpha(0)
			this.searchResults.scrollFrame.buttons[i]:GetPushedTexture():SetAlpha(0)
			self:addButtonBorder{obj=this.searchResults.scrollFrame.buttons[i], relTo=this.searchResults.scrollFrame.buttons[i].icon}
		end

		this.navBar:DisableDrawLayer("BACKGROUND")
		this.navBar:DisableDrawLayer("BORDER")
		this.navBar.overlay:DisableDrawLayer("OVERLAY")
		this.navBar.overflow:GetNormalTexture():SetAlpha(0)
		this.navBar.overflow:GetPushedTexture():SetAlpha(0)
		this.navBar.home:DisableDrawLayer("OVERLAY")
		this.navBar.home:GetNormalTexture():SetAlpha(0)
		this.navBar.home:GetPushedTexture():SetAlpha(0)
		this.navBar.home.text:SetPoint("RIGHT", -20, 0)
		self:removeInset(this.inset)
		self:addSkinFrame{obj=this, ft=ftype, kfs=true}

		this.instanceSelect.bg:SetAlpha(0)
		self:skinDropDown{obj=this.instanceSelect.tierDropDown}
		self:skinSlider{obj=this.instanceSelect.scroll.ScrollBar, wdth=-6}
		self:addSkinFrame{obj=this.instanceSelect.scroll, ft=ftype, kfs=true, nb=true, aso={bd=10, ng=true}, x1=-9, y1=6, x2=6, y2=-8}
		self:SecureHook("EncounterJournal_ListInstances", function()
			local btn
			for i = 1, 30 do
				btn = this.instanceSelect.scroll.child["instance" .. i]
				if btn then
					self:addButtonBorder{obj=btn, relTo=btn.bgImage, ofs=0}
				end
			end
			btn = nil
		end)
		for i = 1, #this.instanceSelect.Tabs do
			this.instanceSelect.Tabs[i]:DisableDrawLayer("BACKGROUND") -- background textures
			this.instanceSelect.Tabs[i]:DisableDrawLayer("OVERLAY") -- selected textures
			self:addSkinFrame{obj=this.instanceSelect.Tabs[i], ft=ftype, noBdr=self.isTT, x1=-11, y1=-2, x2=11, y2=-4}
			this.instanceSelect.Tabs[i].sf.ignore = true
			if i == 1 then
				if self.isTT then self:setActiveTab(this.instanceSelect.Tabs[i].sf) end
			else
				if self.isTT then self:setInactiveTab(this.instanceSelect.Tabs[i].sf) end
			end
		end
		if self.isTT then
			self:SecureHook("EJ_ContentTab_Select", function(id)
				for i = 1, #_G.EncounterJournal.instanceSelect.Tabs do
					if i == id then
						self:setActiveTab(_G.EncounterJournal.instanceSelect.Tabs[i].sf)
					else
						self:setInactiveTab(_G.EncounterJournal.instanceSelect.Tabs[i].sf)
					end
				end
			end)
		end

		self:SecureHookScript(this.encounter, "OnShow", function(this)

			-- Instance frame
			this.instance.loreBG:SetTexCoord(0.06, 0.70, 0.08, 0.58)
			this.instance.loreBG:SetSize(370, 308)
			this.instance:DisableDrawLayer("ARTWORK")
			self:moveObject{obj=this.instance.mapButton, x=-20, y=-18}
			self:addButtonBorder{obj=this.instance.mapButton, relTo=this.instance.mapButton.texture, x1=2, y1=-1, x2=-2, y2=1}
			self:skinSlider{obj=this.instance.loreScroll.ScrollBar, wdth=-4}
			this.instance.loreScroll.child.lore:SetTextColor(self.BT:GetRGB())
			-- Boss/Creature buttons
			local function skinBossBtns()
				for i = 1, 30 do
					if _G["EncounterJournalBossButton" .. i] then
						_G["EncounterJournalBossButton" .. i]:SetNormalTexture(nil)
						_G["EncounterJournalBossButton" .. i]:SetPushedTexture(nil)
					end
				end
			end
			self:SecureHook("EncounterJournal_DisplayInstance", function(instanceID, noButton)
				skinBossBtns()
			end)
			-- skin any existing Boss Buttons
			skinBossBtns()

			-- Info frame
			this.info:DisableDrawLayer("BACKGROUND")
			this.info.encounterTitle:SetTextColor(self.HT:GetRGB())
			this.info.instanceButton:SetNormalTexture(nil)
			this.info.instanceButton:SetPushedTexture(nil)
			this.info.instanceButton:SetHighlightTexture([[Interface\EncounterJournal\UI-EncounterJournalTextures]])
			this.info.instanceButton:GetHighlightTexture():SetTexCoord(0.68945313, 0.81054688, 0.33300781, 0.39257813)
			self:skinSlider{obj=this.info.bossesScroll.ScrollBar, wdth=-4}
			skinFilterBtn(this.info.difficulty)
			this.info.reset:SetNormalTexture(nil)
			this.info.reset:SetPushedTexture(nil)
			self:skinStdButton{obj=this.info.reset, y2=2}
			self:skinSlider{obj=this.info.detailsScroll.ScrollBar, wdth=-4}
			this.info.detailsScroll.child.description:SetTextColor(self.BT:GetRGB())
			self:skinSlider{obj=this.info.overviewScroll.ScrollBar, wdth=-4}
			this.info.overviewScroll.child.loreDescription:SetTextColor(self.BT:GetRGB())
			this.info.overviewScroll.child.header:SetTexture(nil)
			this.info.overviewScroll.child.overviewDescription.Text:SetTextColor(self.BT:GetRGB())
			-- Hook this to skin headers
			self:SecureHook("EncounterJournal_ToggleHeaders", function(this, doNotShift)
				local objName = "EncounterJournalInfoHeader"
				if this.isOverview then
					objName = "EncounterJournalOverviewInfoHeader"
				end
				for i = 1, 25 do
					if _G[objName .. i] then
						_G[objName .. i].button:DisableDrawLayer("BACKGROUND")
						_G[objName .. i].overviewDescription.Text:SetTextColor(self.BT:GetRGB())
						for j = 1, #_G[objName .. i].Bullets do
							_G[objName .. i].Bullets[j].Text:SetTextColor(self.BT:GetRGB())
						end
						_G[objName .. i].description:SetTextColor(self.BT:GetRGB())
						_G[objName .. i].descriptionBG:SetAlpha(0)
						_G[objName .. i].descriptionBGBottom:SetAlpha(0)
						_G[objName .. i .. "HeaderButtonPortraitFrame"]:SetAlpha(0)
					end
				end
				objName = nil
			end)

			-- Loot Frame
			self:skinSlider{obj=this.info.lootScroll.scrollBar, wdth=-4}
			skinFilterBtn(this.info.lootScroll.filter)
			skinFilterBtn(this.info.lootScroll.slotFilter)
			this.info.lootScroll.classClearFilter:DisableDrawLayer("BACKGROUND")
			-- hook this to skin loot entries
			self:SecureHook("EncounterJournal_LootUpdate", function()
				for i = 1, #this.info.lootScroll.buttons do
					this.info.lootScroll.buttons[i]:DisableDrawLayer("BORDER")
					this.info.lootScroll.buttons[i].armorType:SetTextColor(self.BT:GetRGB())
					this.info.lootScroll.buttons[i].slot:SetTextColor(self.BT:GetRGB())
					this.info.lootScroll.buttons[i].boss:SetTextColor(self.BT:GetRGB())
					self:addButtonBorder{obj=this.info.lootScroll.buttons[i], relTo=this.info.lootScroll.buttons[i].icon}
				end
			end)

			-- Model Frame
			this.info.model:DisableDrawLayer("BACKGROUND") -- dungeonBG (updated with dungeon type change)
			self:rmRegionsTex(this.info.model, {2, 3}) -- Shadow, TitleBG
			local function skinCreatureBtn(cBtn)
				local hTex
				if cBtn
				and not cBtn.sknd
				then
					cBtn.sknd = true
					cBtn:SetNormalTexture(nil)
					hTex = cBtn:GetHighlightTexture()
					hTex:SetTexture([[Interface\EncounterJournal\UI-EncounterJournalTextures]])
					hTex:SetTexCoord(0.68945313, 0.81054688, 0.33300781, 0.39257813)
				end
				hTex = nil
			end
			-- creature(s)
			for _, cBtn in ipairs(this.info.creatureButtons) do
				skinCreatureBtn(cBtn)
			end
			-- hook this to skin additional buttons
			self:SecureHook("EncounterJournal_GetCreatureButton", function(index)
				if index > 9 then return end -- MAX_CREATURES_PER_ENCOUNTER
				skinCreatureBtn(_G.EncounterJournal.encounter.info.creatureButtons[index])
			end)

			-- Tabs (side)
			self:moveObject{obj=this.info.overviewTab, x=10}
			for _, type in pairs{"overviewTab", "lootTab", "bossTab", "modelTab"} do
				this.info[type]:SetNormalTexture(nil)
				this.info[type]:SetPushedTexture(nil)
				this.info[type]:GetDisabledTexture():SetAlpha(0) -- tab texture is modified
				self:addSkinFrame{obj=this.info[type], ft=ftype, noBdr=true, ofs=-3, aso={rotate=true}} -- gradient is right to left
			end

			self:Unhook(this, "OnShow")
		end)

		local ejsfs = this.suggestFrame.Suggestion1
		ejsfs.bg:SetTexture(nil)
		ejsfs.iconRing:SetTexture(nil)
		ejsfs.centerDisplay.title.text:SetTextColor(self.HT:GetRGB())
		ejsfs.centerDisplay.description.text:SetTextColor(self.BT:GetRGB())
		ejsfs.reward.text:SetTextColor(self.BT:GetRGB())
		ejsfs.reward.iconRing:SetTexture(nil)
		self:skinStdButton{obj=ejsfs.button}
		self:addButtonBorder{obj=ejsfs.prevButton, ofs=-2, y1=-3, x2=-3}
		self:addButtonBorder{obj=ejsfs.nextButton, ofs=-2, y1=-3, x2=-3}
		ejsfs = this.suggestFrame.Suggestion2
		ejsfs.bg:SetTexture(nil)
		ejsfs.iconRing:SetTexture(nil)
		ejsfs.centerDisplay.title.text:SetTextColor(self.HT:GetRGB())
		ejsfs.centerDisplay.description.text:SetTextColor(self.BT:GetRGB())
		self:skinStdButton{obj=ejsfs.centerDisplay.button}
		ejsfs.reward.iconRing:SetTexture(nil)
		ejsfs = this.suggestFrame.Suggestion3
		ejsfs.bg:SetTexture(nil)
		ejsfs.iconRing:SetTexture(nil)
		ejsfs.centerDisplay.title.text:SetTextColor(self.HT:GetRGB())
		ejsfs.centerDisplay.description.text:SetTextColor(self.BT:GetRGB())
		self:skinStdButton{obj=ejsfs.centerDisplay.button}
		ejsfs.reward.iconRing:SetTexture(nil)
		ejsfs = nil

		-- add skin frame to surround all the Suggestions, so tabs look better than without a frame
		self:addSkinFrame{obj=this.suggestFrame, ft=ftype, kfs=true, nb=true, aso={bd=10, ng=true}, x1=-9, y1=6, x2=7, y2=-5}

		self:Unhook(this, "OnShow")
	end)

	-- this is a frame NOT a GameTooltip
	self:SecureHookScript(_G.EncounterJournalTooltip, "OnShow", function(this)
		self:addSkinFrame{obj=this, ft=ftype}
		self:Unhook(this, "OnShow")
	end)

	-- LootJournal panel
	self:SecureHookScript(_G.EncounterJournal.LootJournal, "OnShow", function(this)
		self:skinDropDown{obj=this.ClassDropDown}
		-- ItemSetsFrame
		self:skinSlider{obj=self:getChild(this.ItemSetsFrame, 2), wdth=-4, size=3}
		skinFilterBtn(this.ItemSetsFrame.ClassButton)
		for i = 1 , #this.ItemSetsFrame.buttons do
			this.ItemSetsFrame.buttons[i].Background:SetTexture(nil)
		end
		-- add skin frame to surround the Loot Journal, so tabs look better than without a frame
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true, aso={bd=10, ng=true}, x1=-8, y1=6, x2=8, y2=-5}
		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].EquipmentFlyout = function(self)
	if not self.prdb.EquipmentFlyout or self.initialized.EquipmentFlyout then return end
	self.initialized.EquipmentFlyout = true

	self:SecureHookScript(_G.EquipmentFlyoutFrame, "OnShow", function(this)
		self:addSkinFrame{obj=this.buttonFrame, ft=ftype, ofs=2, x2=5}
		self:SecureHook("EquipmentFlyout_Show", function(...)
			for i = 1, _G.EquipmentFlyoutFrame.buttonFrame.numBGs do
				_G.EquipmentFlyoutFrame.buttonFrame["bg" .. i]:SetAlpha(0)
			end
			if self.modBtnBs then
				local btn
				for i = 1, #_G.EquipmentFlyoutFrame.buttons do
					btn = _G.EquipmentFlyoutFrame.buttons[i]
					self:addButtonBorder{obj=btn, ibt=true, reParent={btn.UpgradeIcon}}
					-- change 'Place In Bags' button border alpha & stop it changing
					if i == 1 then
						btn.sbb:SetBackdropBorderColor(0.498, 0.498, 0.498, 1) -- grey border
						btn.sbb.SetBackdropBorderColor = _G.nop
					end
				end
				btn = nil
			end
		end)
		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].FriendsFrame = function(self)
	if not self.prdb.FriendsFrame or self.initialized.FriendsFrame then return end
	self.initialized.FriendsFrame = true

	local function addTabFrame(frame)
		aObj:addSkinFrame{obj=frame, ft=ftype, kfs=true, nb=true, ofs=0, y1=-81, y2=-2, aso={bd=10, ng=true}}
	end

	self:SecureHookScript(_G.FriendsFrame, "OnShow", function(this)
		self:skinTabs{obj=this, lod=true}
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true, y2=-5}

		self:skinDropDown{obj=_G.FriendsDropDown}
		self:skinDropDown{obj=_G.TravelPassDropDown}

		self:SecureHookScript(_G.FriendsTabHeader, "OnShow", function(this)
			_G.FriendsFrameBattlenetFrame:DisableDrawLayer("BACKGROUND")
			if self.modBtnBs then
				self:addButtonBorder{obj=_G.FriendsFrameBattlenetFrame.BroadcastButton, ofs=-2}
			end
			self:addSkinFrame{obj=_G.FriendsFrameBattlenetFrame.BroadcastFrame.ScrollFrame, ft=ftype, kfs=true, nb=true, ofs=4}
			if self.modBtns then
				self:skinStdButton{obj=_G.FriendsFrameBattlenetFrame.BroadcastFrame.ScrollFrame.UpdateButton}
				self:skinStdButton{obj=_G.FriendsFrameBattlenetFrame.BroadcastFrame.ScrollFrame.CancelButton}
			end
			_G.FriendsFrameBattlenetFrame.BroadcastFrame.ScrollFrame.EditBox.PromptText:SetTextColor(self.BT:GetRGB())
			self:addSkinFrame{obj=_G.FriendsFrameBattlenetFrame.BroadcastFrame, ft=ftype, ofs=-10}
			self:removeNineSlice(_G.FriendsFrameBattlenetFrame.UnavailableInfoFrame)
			self:addSkinFrame{obj=_G.FriendsFrameBattlenetFrame.UnavailableInfoFrame, ft=ftype}
			self:skinDropDown{obj=_G.FriendsFrameStatusDropDown}
			_G.FriendsFrameStatusDropDownStatus:SetAlpha(1) -- display status icon
			self:skinEditBox{obj=_G.FriendsFrameBroadcastInput, regs={6, 7}, mi=true, noWidth=true, noHeight=true, noMove=true} -- 6 is text, 7 is icon
			_G.FriendsFrameBroadcastInputFill:SetTextColor(self.BT:GetRGB())
			_G.PanelTemplates_SetNumTabs(this, 3) -- adjust for Friends, QuickJoin & Ignore
			self:skinTabs{obj=this, up=true, lod=true, x1=0, y1=-5, x2=0, y2=-5}
			self:skinGlowBox(this.FriendsFrameQuickJoinHelpTip, ftype)
			if self.modBtnBs then
				self:addButtonBorder{obj=_G.FriendsTabHeaderRecruitAFriendButton}
				self:addButtonBorder{obj=_G.FriendsTabHeaderSoRButton}
			end
			_G.RaiseFrameLevel(this)
			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.FriendsTabHeader)

		self:SecureHookScript(_G.FriendsListFrame, "OnShow", function(this)
			if self.modBtns then
				self:skinStdButton{obj=_G.FriendsFrameAddFriendButton, x1=1}
				self:skinStdButton{obj=_G.FriendsFrameSendMessageButton}
				self:skinStdButton{obj=self:getChild(this.RIDWarning, 1)} -- unnamed parent frame
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=_G.FriendsFrameFriendsScrollFrame.PendingInvitesHeaderButton}
			end
			_G.FriendsFrameFriendsScrollFrame.PendingInvitesHeaderButton.BG:SetTexture(nil)
			if self.modBtns then
				for invite in _G.FriendsFrameFriendsScrollFrame.invitePool:EnumerateActive() do
					self:skinStdButton{obj=invite.DeclineButton}
					self:skinStdButton{obj=invite.AcceptButton}
				end
			end
			self:skinSlider{obj=_G.FriendsFrameFriendsScrollFrame.scrollBar, rt="background"}
			-- adjust width of FFFSF so it looks right (too thin by default)
			_G.FriendsFrameFriendsScrollFrame.scrollBar:ClearAllPoints()
			_G.FriendsFrameFriendsScrollFrame.scrollBar:SetPoint("TOPRIGHT", "FriendsFrame", "TOPRIGHT", -8, -101)
			_G.FriendsFrameFriendsScrollFrame.scrollBar:SetPoint("BOTTOMLEFT", "FriendsFrame", "BOTTOMRIGHT", -24, 40)
			local btn
			for i = 1, _G.FRIENDS_FRIENDS_TO_DISPLAY do
				btn = _G["FriendsFrameFriendsScrollFrameButton" .. i]
				btn.background:SetAlpha(0)
				if self.modBtnBs then
					self:addButtonBorder{obj=btn, relTo=btn.gameIcon, ofs=0}
					self:SecureHook(btn.gameIcon, "Show", function(this)
						this:GetParent().sbb:Show()
					end)
					self:SecureHook(btn.gameIcon, "Hide", function(this)
						this:GetParent().sbb:Hide()
					end)
					self:SecureHook(btn.gameIcon, "SetShown", function(this, show)
						this:GetParent().sbb:SetShown(this, show)
					end)
					btn.sbb:SetShown(btn.gameIcon:IsShown())
					self:addButtonBorder{obj=btn.travelPassButton, ofs=0, y1=3, y2=-2}
					self:SecureHook(btn.travelPassButton, "Enable", function(this)
						this.sbb:SetBackdropBorderColor(self.bbClr:GetRGBA())
					end)
					self:SecureHook(btn.travelPassButton, "Disable", function(this)
						this.sbb:SetBackdropBorderColor(0.5, 0.5, 0.5)
					end)
					if not btn.travelPassButton:IsEnabled() then btn.travelPassButton.sbb:SetBackdropBorderColor(0.5, 0.5, 0.5, 1) end
					self:addButtonBorder{obj=btn.summonButton}
					self:SecureHook(btn.summonButton, "Enable", function(this)
						this.sbb:SetBackdropBorderColor(self.bbClr:GetRGBA())
					end)
					self:SecureHook(btn.summonButton, "Disable", function(this)
						this.sbb:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
					end)
					if not btn.summonButton:IsEnabled() then btn.summonButton.sbb:SetBackdropBorderColor(0.5, 0.5, 0.5) end
				end
			end
			btn = nil
			addTabFrame(this)
			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.FriendsListFrame)

		self:SecureHookScript(_G.IgnoreListFrame, "OnShow", function(this)
			this:DisableDrawLayer("BACKGROUND")
			if self.modBtns then
				self:skinStdButton{obj=_G.FriendsFrameIgnorePlayerButton, x1=1}
				self:skinStdButton{obj=_G.FriendsFrameUnsquelchButton}
			end
			self:skinSlider{obj=_G.FriendsFrameIgnoreScrollFrame.ScrollBar}
			addTabFrame(this)
			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.WhoFrame, "OnShow", function(this)
			self:removeInset(_G.WhoFrameListInset)
			self:skinColHeads("WhoFrameColumnHeader")
			self:skinDropDown{obj=_G.WhoFrameDropDown}
			-- remove col head 2 as it is really a dropdown
			_G.WhoFrameColumnHeader2.sf.tfade:SetTexture(nil)
			_G.WhoFrameColumnHeader2.sf:SetBackdrop(nil)
			_G.WhoFrameColumnHeader2.sf:Hide()
			self:moveObject{obj=_G.WhoFrameColumnHeader4, x=4}
			if self.modBtns then
				self:skinStdButton{obj=_G.WhoFrameGroupInviteButton}
				self:skinStdButton{obj=_G.WhoFrameAddFriendButton}
				self:skinStdButton{obj=_G.WhoFrameWhoButton}
			end
			self:removeInset(_G.WhoFrameEditBoxInset)
			self:skinEditBox{obj=_G.WhoFrameEditBox}--, move=true}
			_G.WhoFrameEditBox:SetWidth(_G.WhoFrameEditBox:GetWidth() + 24)
			self:moveObject{obj=_G.WhoFrameEditBox, x=11, y=6}
			self:skinSlider{obj=_G.WhoListScrollFrame.ScrollBar, rt="background"}
			self:Unhook(this, "OnShow")
		end)

		-- tooltip
		_G.C_Timer.After(0.1, function()
			self:add2Table(self.ttList, _G.FriendsTooltip)
		end)

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.AddFriendFrame, "OnShow", function(this)
		self:removeNineSlice(this.Border)
		if self.modBtns then
			self:skinStdButton{obj=_G.AddFriendInfoFrameContinueButton}
			self:skinStdButton{obj=_G.AddFriendEntryFrameAcceptButton}
			self:skinStdButton{obj=_G.AddFriendEntryFrameCancelButton}
		end
		self:skinEditBox{obj=_G.AddFriendNameEditBox, regs={6}} -- 6 is text
		self:skinSlider{obj=_G.AddFriendNoteFrameScrollFrame.ScrollBar}
		self:addSkinFrame{obj=_G.AddFriendNoteFrame, ft=ftype, kfs=true}
		self:addSkinFrame{obj=this, ft=ftype, kfs=true}

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.FriendsFriendsFrame, "OnShow", function(this)
		self:removeNineSlice(this.Border)
		self:skinDropDown{obj=_G.FriendsFriendsFrameDropDown}
		self:addSkinFrame{obj=_G.FriendsFriendsList, ft=ftype}
		self:skinSlider{obj=_G.FriendsFriendsScrollFrame.ScrollBar}
		if self.modBtns then
			self:skinStdButton{obj=_G.FriendsFriendsSendRequestButton}
			self:skinStdButton{obj=_G.FriendsFriendsCloseButton}
		end
		self:addSkinFrame{obj=this, ft=ftype}

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.BattleTagInviteFrame, "OnShow", function(this)
		self:removeNineSlice(this.Border)
		if self.modBtns then
			self:skinStdButton{obj=self:getChild(this, 1)} -- Send Request
			self:skinStdButton{obj=self:getChild(this, 2)} -- Cancel
		end
		self:addSkinFrame{obj=this, ft=ftype}

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.RecruitAFriendFrame, "OnShow", function(this)
		self:skinEditBox{obj=_G.RecruitAFriendNameEditBox, regs={6}} -- 6 is text
		_G.RecruitAFriendNameEditBox.Fill:SetTextColor(self.BT:GetRGB())
		self:addSkinFrame{obj=_G.RecruitAFriendNoteFrame, ft=ftype, kfs=true}
		_G.RecruitAFriendNoteEditBox.Fill:SetTextColor(self.BT:GetRGB())
		self:skinStdButton{obj=_G.RecruitAFriendFrame.SendButton}
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ofs=-6, y1=-7}
		-- RecruitAFriendSentFrame
		self:skinStdButton{obj=_G.RecruitAFriendSentFrame.OKButton}
		self:addSkinFrame{obj=_G.RecruitAFriendSentFrame, ft=ftype, ofs=-7, y2=4}
		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.QuickJoinFrame, "OnShow", function(this)
		self:skinDropDown{obj=_G.QuickJoinFrameDropDown}
		self:skinSlider{obj=_G.QuickJoinFrame.ScrollFrame.scrollBar, rt="background"}
		-- adjust width of QJSF so it looks right (too thin by default)
		_G.QuickJoinFrame.ScrollFrame.scrollBar:ClearAllPoints()
		_G.QuickJoinFrame.ScrollFrame.scrollBar:SetPoint("TOPRIGHT", "FriendsFrame", "TOPRIGHT", -8, -101)
		_G.QuickJoinFrame.ScrollFrame.scrollBar:SetPoint("BOTTOMLEFT", "FriendsFrame", "BOTTOMRIGHT", -24, 40)
		self:addSkinFrame{obj=_G.QuickJoinScrollFrame, ft=ftype, kfs=true, nb=true, x1=-8, y1=7, x2=28, y2=-32, aso={bd=10, ng=true}}
		self:removeMagicBtnTex(_G.QuickJoinFrame.JoinQueueButton)
		if self.modBtns then
			self:skinStdButton{obj=_G.QuickJoinFrame.JoinQueueButton, x2=0}
		end

		-- QuickJoinRoleSelectionFrame
		self:removeNineSlice(_G.QuickJoinRoleSelectionFrame.Border)
		for i = 1, #_G.QuickJoinRoleSelectionFrame.Roles do
			self:skinCheckButton{obj=_G.QuickJoinRoleSelectionFrame.Roles[i].CheckButton}
		end
		if self.modBtns then
			self:skinStdButton{obj=_G.QuickJoinRoleSelectionFrame.AcceptButton}
			self:skinStdButton{obj=_G.QuickJoinRoleSelectionFrame.CancelButton}
		end
		self:addSkinFrame{obj=_G.QuickJoinRoleSelectionFrame, ft=ftype, ofs=-5}
		addTabFrame(this)

		self:Unhook(this, "OnShow")
	end)


	self:SecureHookScript(_G.ChannelFrame, "OnShow", function(this)
		self:removeInset(this.LeftInset)
		self:removeInset(this.RightInset)
		if self.modBtns then
			self:skinStdButton{obj=this.NewButton}
			self:skinStdButton{obj=this.SettingsButton}
		end
		self:skinGlowBox(this.Tutorial, ftype)
		self:skinSlider{obj=this.ChannelList.ScrollBar, wdth=-4}
		self:skinSlider{obj=this.ChannelRoster.ScrollFrame.scrollBar, wdth=-4}
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true, x1=-5, y2=-1}
		-- Create Channel Popup
		self:removeNineSlice(_G.CreateChannelPopup.BG)
		self:skinEditBox{obj=_G.CreateChannelPopup.Name, regs={6}} -- 6 is text
		self:skinEditBox{obj=_G.CreateChannelPopup.Password, regs={6}} -- 6 is text
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.CreateChannelPopup.UseVoiceChat}
		end
		if self.modBtns then
			self:skinStdButton{obj=_G.CreateChannelPopup.OKButton}
			self:skinStdButton{obj=_G.CreateChannelPopup.CancelButton}
		end
		self:addSkinFrame{obj=_G.CreateChannelPopup, ft=ftype, kfs=true}

		self:Unhook(this, "OnShow")
	end)

	self:SecureHook(_G.ChannelFrame.ChannelList, "Update", function(this)
		for header in this.headerButtonPool:EnumerateActive() do
			header:GetNormalTexture():SetTexture(nil)
		end
		for textChannel in this.textChannelButtonPool:EnumerateActive() do
		end
		for voiceChannel in this.voiceChannelButtonPool:EnumerateActive() do
		end
		for communityChannel in this.communityChannelButtonPool:EnumerateActive() do
		end
	end)

	self:SecureHookScript(_G.VoiceChatPromptActivateChannel, "OnShow", function(this)
		self:skinCloseButton{obj=this.CloseButton, font=self.fontSBX, aso={bd=5, bba=0}, onSB=true, storeOnParent=true}
		self:skinStdButton{obj=this.AcceptButton}
		self:addSkinFrame{obj=this, ft=ftype, nb=true}
		self:hookSocialToastFuncs(this)

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.VoiceChatChannelActivatedNotification, "OnShow", function(this)
		self:skinCloseButton{obj=this.CloseButton, font=self.fontSBX, aso={bd=5, bba=0}, onSB=true, storeOnParent=true}
		self:addSkinFrame{obj=this, ft=ftype, nb=true}
		self:hookSocialToastFuncs(this)

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzLoDFrames[ftype].GuildControlUI = function(self)
	if not self.prdb.GuildControlUI or self.initialized.GuildControlUI then return end
	self.initialized.GuildControlUI = true

	self:SecureHookScript(_G.GuildControlUI, "OnShow", function(this)
		this:DisableDrawLayer("BACKGROUND")
		_G.GuildControlUIHbar:SetAlpha(0)
		self:skinDropDown{obj=this.dropdown}
		_G.UIDropDownMenu_SetButtonWidth(this.dropdown, 24)
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, x1=10, y1=-10, x2=-10, y2=3}
		self:moveObject{obj=this, x=-25, y=12}

		-- Guild Ranks
		self:skinStdButton{obj=this.orderFrame.newButton}
		self:moveObject{obj=this.orderFrame.newButton, y=-7}
		self:skinStdButton{obj=this.orderFrame.dupButton}
		self:moveObject{obj=this.orderFrame.dupButton, y=-7}

		local function skinROFrames()

			for i = 1, _G.MAX_GUILDRANKS do
				if _G["GuildControlUIRankOrderFrameRank" .. i]
				and not _G["GuildControlUIRankOrderFrameRank" .. i].sknd
				then
					_G["GuildControlUIRankOrderFrameRank" .. i].sknd = true
					aObj:skinEditBox{obj=_G["GuildControlUIRankOrderFrameRank" .. i].nameBox, regs={6}, x=-5}
					aObj:addButtonBorder{obj=_G["GuildControlUIRankOrderFrameRank" .. i].downButton, ofs=0}
					aObj:addButtonBorder{obj=_G["GuildControlUIRankOrderFrameRank" .. i].upButton, ofs=0}
					aObj:addButtonBorder{obj=_G["GuildControlUIRankOrderFrameRank" .. i].deleteButton, ofs=0}
				end
			end

		end
		self:SecureHook("GuildControlUI_RankOrder_Update", function(...)
			skinROFrames()
		end)
		skinROFrames()

		self:SecureHookScript(this.rankPermFrame, "OnShow", function(this)
			this:DisableDrawLayer("BACKGROUND")
			self:skinDropDown{obj=this.dropdown}
			_G.UIDropDownMenu_SetButtonWidth(this.dropdown, 24)
			self:skinEditBox{obj=this.goldBox, regs={6}}
			if self.modChkBtns then
				for _, child in ipairs{this:GetChildren()} do
					if child:IsObjectType("CheckButton") then
						self:skinCheckButton{obj=child}
					end
				end
			end
			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(this.bankTabFrame, "OnShow", function(this)
			self:skinSlider{obj=this.inset.scrollFrame.ScrollBar, rt="artwork"}
			self:skinDropDown{obj=this.dropdown}
			_G.UIDropDownMenu_SetButtonWidth(this.dropdown, 24)
			this.inset:DisableDrawLayer("BACKGROUND")
			this.inset:DisableDrawLayer("BORDER")
			self:Unhook(this, "OnShow")
		end)
		-- hook this as buttons are created as required, done here as inside the HookScript function is too late
		self:SecureHook("GuildControlUI_BankTabPermissions_Update", function(this)
			for i = 1, _G.MAX_GUILDBANK_TABS do
				if _G["GuildControlBankTab" .. i]
				and not _G["GuildControlBankTab" .. i].sknd
				then
					_G["GuildControlBankTab" .. i].sknd = true
					_G["GuildControlBankTab" .. i]:DisableDrawLayer("BACKGROUND")
					self:skinEditBox{obj=_G["GuildControlBankTab" .. i].owned.editBox, regs={6}}
					self:skinStdButton{obj=_G["GuildControlBankTab" .. i].buy.button, as=true}
					self:addButtonBorder{obj=_G["GuildControlBankTab" .. i].owned, relTo=_G["GuildControlBankTab" .. i].owned.tabIcon, es=10}
					if self.modChkBtns then
						self:skinCheckButton{obj=_G["GuildControlBankTab" .. i].owned.viewCB}
						self:skinCheckButton{obj=_G["GuildControlBankTab" .. i].owned.depositCB}
						self:skinCheckButton{obj=_G["GuildControlBankTab" .. i].owned.infoCB}
					end
				end
			end
		end)

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzLoDFrames[ftype].GuildUI = function(self)
	if not self.prdb.GuildUI or self.initialized.GuildUI then return end
	self.initialized.GuildUI = true

	self:SecureHookScript(_G.GuildFrame, "OnShow", function(this)
		self:keepRegions(this, {8, 19, 20, 18, 21, 22}) -- regions 8, 19, 20 are text, 18, 21 & 22 are tabard
		self:moveObject{obj=_G.GuildFrameTabardBackground, x=8, y=-11}
		self:moveObject{obj=_G.GuildFrameTabardEmblem, x=9, y=-12}
		self:moveObject{obj=_G.GuildFrameTabardBorder, x=7, y=-10}
		self:skinTabs{obj=this, lod=true}
		self:removeInset(_G.GuildFrameBottomInset)
		self:skinDropDown{obj=_G.GuildDropDown}
		_G.GuildPointFrame.LeftCap:SetTexture(nil)
		_G.GuildPointFrame.RightCap:SetTexture(nil)
		_G.GuildFactionBar:DisableDrawLayer("BORDER")
		_G.GuildFactionBarProgress:SetTexture(self.sbTexture)
		_G.GuildFactionBarShadow:SetAlpha(0)
		_G.GuildFactionBarCap:SetTexture(self.sbTexture)
		_G.GuildFactionBarCapMarker:SetAlpha(0)
		self:skinEditBox{obj=_G.GuildNameChangeFrame.editBox, regs={6}}
		self:addSkinFrame{obj=this, ft=ftype, ri=true, y2=-5}
		if self.modBtns then
			-- N.B. NO CloseButton for GuildNameChangeAlertFrame
			self:skinStdButton{obj=_G.GuildNameChangeFrame.button}
		end
		self:skinGlowBox(_G.GuildNameChangeAlertFrame, ftype)
		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.GuildPerksFrame, "OnShow", function(this)
		_G.GuildAllPerksFrame:DisableDrawLayer("BACKGROUND")
		for i = 1, #_G.GuildPerksContainer.buttons do
			-- can't use DisableDrawLayer as the update code uses it
			self:removeRegions(_G.GuildPerksContainer.buttons[i], {1, 2, 3, 4})
			_G.GuildPerksContainer.buttons[i].normalBorder:DisableDrawLayer("BACKGROUND")
			_G.GuildPerksContainer.buttons[i].disabledBorder:DisableDrawLayer("BACKGROUND")
			self:addButtonBorder{obj=_G.GuildPerksContainer.buttons[i], relTo=_G.GuildPerksContainer.buttons[i].icon, reParent={_G.GuildPerksContainer.buttons[i].lock}}
		end
		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.GuildRosterFrame, "OnShow", function(this)
		self:skinDropDown{obj=_G.GuildRosterViewDropdown}
		self:skinColHeads("GuildRosterColumnButton", 5)
		self:skinSlider{obj=_G.GuildRosterContainerScrollBar, wdth=-4}
		for i = 1, #_G.GuildRosterContainer.buttons do
			_G.GuildRosterContainer.buttons[i]:DisableDrawLayer("BACKGROUND")
			_G.GuildRosterContainer.buttons[i].barTexture:SetTexture(self.sbTexture)
			_G.GuildRosterContainer.buttons[i].header.leftEdge:SetAlpha(0)
			_G.GuildRosterContainer.buttons[i].header.rightEdge:SetAlpha(0)
			_G.GuildRosterContainer.buttons[i].header.middle:SetAlpha(0)
			self:applySkin{obj=_G.GuildRosterContainer.buttons[i].header} -- hide underlaying text
		end
		self:skinCheckButton{obj=_G.GuildRosterShowOfflineButton}
		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.GuildMemberDetailFrame, "OnShow", function(this)
		self:skinDropDown{obj=_G.GuildMemberRankDropdown}
		-- adjust text position & font so it overlays correctly
		self:moveObject{obj=_G.GuildMemberRankDropdown, x=-6, y=2}
		_G.GuildMemberRankDropdownText:SetFontObject(_G.GameFontHighlight)
		self:addSkinFrame{obj=_G.GuildMemberNoteBackground, ft=ftype}
		self:addSkinFrame{obj=_G.GuildMemberOfficerNoteBackground, ft=ftype}
		self:skinStdButton{obj=_G.GuildMemberRemoveButton}
		self:skinStdButton{obj=_G.GuildMemberGroupInviteButton}
		self:skinCloseButton{obj=_G.GuildMemberDetailCloseButton}
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ofs=-6}
		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.GuildNewsFrame, "OnShow", function(this)
		this:DisableDrawLayer("BACKGROUND")
		self:skinSlider{obj=_G.GuildNewsContainerScrollBar, wdth=-6}
		for i = 1, #_G.GuildNewsContainer.buttons do
			_G.GuildNewsContainer.buttons[i].header:SetAlpha(0)
		end
		-- hook this to stop tooltip flickering
		self:SecureHook("GuildNewsButton_OnEnter", function(btn)
			if btn.UpdateTooltip then btn.UpdateTooltip = nil end
		end)
		self:skinDropDown{obj=_G.GuildNewsDropDown}
		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.GuildNewsFiltersFrame, "OnShow", function(this)
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ofs=-7}
		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.GuildNewsBossModel, "OnShow", function(this)
		self:keepFontStrings(_G.GuildNewsBossModelTextFrame)
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ofs=4, y2=-81} -- similar to QuestNPCModel
		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.GuildRewardsFrame, "OnShow", function(this)
		this:DisableDrawLayer("BACKGROUND")
		self:skinSlider{obj=_G.GuildRewardsContainerScrollBar, wdth=-4}
		for i = 1, #_G.GuildRewardsContainer.buttons do
			_G.GuildRewardsContainer.buttons[i]:GetNormalTexture():SetAlpha(0)
			_G.GuildRewardsContainer.buttons[i].disabledBG:SetAlpha(0)
			self:addButtonBorder{obj=_G.GuildRewardsContainer.buttons[i], relTo=_G.GuildRewardsContainer.buttons[i].icon, reParent={_G.GuildRewardsContainer.buttons[i].lock}}
		end
		self:skinDropDown{obj=_G.GuildRewardsDropDown}
		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.GuildInfoFrame, "OnShow", function(this)
		self:removeRegions(this, {1, 2, 3, 4, 5, 6 ,7, 8}) -- Background textures and bars
		self:skinTabs{obj=this, up=true, lod=true, x1=2, y1=-5, x2=2, y2=-5}
		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.GuildInfoFrameInfo, "OnShow", function(this)
		self:keepFontStrings(this)
		self:skinSlider{obj=_G.GuildInfoDetailsFrame.ScrollBar, wdth=-4}
		self:removeMagicBtnTex(_G.GuildAddMemberButton)
		self:skinStdButton{obj=_G.GuildAddMemberButton}
		self:removeMagicBtnTex(_G.GuildControlButton)
		self:skinStdButton{obj=_G.GuildControlButton}
		self:removeMagicBtnTex(_G.GuildViewLogButton)
		self:skinStdButton{obj=_G.GuildViewLogButton}
		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.GuildInfoFrameRecruitment, "OnShow", function(this)
		_G.GuildRecruitmentInterestFrameBg:SetAlpha(0)
		self:skinCheckButton{obj=_G.GuildRecruitmentQuestButton}
		self:skinCheckButton{obj=_G.GuildRecruitmentRaidButton}
		self:skinCheckButton{obj=_G.GuildRecruitmentDungeonButton}
		self:skinCheckButton{obj=_G.GuildRecruitmentPvPButton}
		self:skinCheckButton{obj=_G.GuildRecruitmentRPButton}
		_G.GuildRecruitmentAvailabilityFrameBg:SetAlpha(0)
		self:skinCheckButton{obj=_G.GuildRecruitmentWeekdaysButton}
		self:skinCheckButton{obj=_G.GuildRecruitmentWeekendsButton}
		_G.GuildRecruitmentRolesFrameBg:SetAlpha(0)
		self:skinCheckButton{obj=_G.GuildRecruitmentTankButton.checkButton}
		self:skinCheckButton{obj=_G.GuildRecruitmentHealerButton.checkButton}
		self:skinCheckButton{obj=_G.GuildRecruitmentDamagerButton.checkButton}
		_G.GuildRecruitmentLevelFrameBg:SetAlpha(0)
		_G.GuildRecruitmentCommentFrameBg:SetAlpha(0)
		self:skinSlider{obj=_G.GuildRecruitmentCommentInputFrameScrollFrame.ScrollBar}
		_G.GuildRecruitmentCommentEditBoxFill:SetTextColor(self.BT:GetRGB())
		self:addSkinFrame{obj=_G.GuildRecruitmentCommentInputFrame, ft=ftype, kfs=true}
		self:removeMagicBtnTex(_G.GuildRecruitmentListGuildButton)
		self:skinStdButton{obj=_G.GuildRecruitmentListGuildButton}
		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.GuildInfoFrameApplicants, "OnShow", function(this)
		for i = 1, #_G.GuildInfoFrameApplicantsContainer.buttons do
			self:applySkin{obj=_G.GuildInfoFrameApplicantsContainer.buttons[i]}
			_G.GuildInfoFrameApplicantsContainer.buttons[i].ring:SetAlpha(0)
			_G.GuildInfoFrameApplicantsContainer.buttons[i].PointsSpentBgGold:SetAlpha(0)
			self:moveObject{obj=_G.GuildInfoFrameApplicantsContainer.buttons[i].PointsSpentBgGold, x=6, y=-6}
		end
		self:skinSlider{obj=_G.GuildInfoFrameApplicantsContainerScrollBar, wdth=-4}
		self:removeMagicBtnTex(_G.GuildRecruitmentInviteButton)
		self:skinStdButton{obj=_G.GuildRecruitmentInviteButton}
		self:removeMagicBtnTex(_G.GuildRecruitmentMessageButton)
		self:skinStdButton{obj=_G.GuildRecruitmentMessageButton}
		self:removeMagicBtnTex(_G.GuildRecruitmentDeclineButton)
		self:skinStdButton{obj=_G.GuildRecruitmentDeclineButton}
		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.GuildTextEditFrame, "OnShow", function(this)
		self:skinSlider{obj=_G.GuildTextEditScrollFrame.ScrollBar, wdth=-6}
		self:addSkinFrame{obj=_G.GuildTextEditContainer, ft=ftype}
		self:skinStdButton{obj=_G.GuildTextEditFrameAcceptButton}
		self:skinStdButton{obj=self:getChild(_G.GuildTextEditFrame, 4)} -- bottom close button
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true, ofs=-7}
		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.GuildLogFrame, "OnShow", function(this)
		self:skinSlider{obj=_G.GuildLogScrollFrame.ScrollBar, wdth=-6}
		self:addSkinFrame{obj=_G.GuildLogContainer, ft=ftype}
		self:skinStdButton{obj=self:getChild(this, 3)} -- bottom close button
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ofs=-7}
		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].GuildInvite = function(self)
	if not self.prdb.GuildInvite or self.initialized.GuildInvite then return end
	self.initialized.GuildInvite = true

	self:SecureHookScript(_G.GuildInviteFrame, "OnShow", function(this)
		_G.GuildInviteFrameTabardBorder:SetTexture(nil)
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true}
		self:skinStdButton{obj=_G.GuildInviteFrameJoinButton}
		self:skinStdButton{obj=_G.GuildInviteFrameDeclineButton}
		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzLoDFrames[ftype].InspectUI = function(self)
	if not self.prdb.InspectUI or self.initialized.InspectUI then return end
	self.initialized.InspectUI = true

	self:SecureHookScript(_G.InspectFrame, "OnShow", function(this)
		if self.modBtnBs then
			self:SecureHook("InspectPaperDollItemSlotButton_Update", function(btn)
				if not btn.hasItem then
					btn.sbb:SetBackdropBorderColor(0.498, 0.498, 0.498, 0.5) -- grey border, 50% alpha
					btn.icon:SetTexture(nil)
				end
			end)
		end
		self:skinTabs{obj=this, lod=true}
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true, y2=-5}
		self:Unhook(this, "OnShow")

		-- send message when UI is skinned (used by oGlow skin)
		self:SendMessage("InspectUI_Skinned", self)
	end)

	self:SecureHookScript(_G.InspectPaperDollFrame, "OnShow", function(this)
		self:skinStdButton{obj=this.ViewButton}
		_G.InspectModelFrame:DisableDrawLayer("BACKGROUND")
		_G.InspectModelFrame:DisableDrawLayer("BORDER")
		_G.InspectModelFrame:DisableDrawLayer("OVERLAY")
		_G.InspectModelFrame.controlFrame:DisableDrawLayer("BACKGROUND")
		for _, btn in ipairs{_G.InspectPaperDollItemsFrame:GetChildren()} do
			btn:DisableDrawLayer("BACKGROUND")
			if self.modBtnBs then
				self:addButtonBorder{obj=btn, ibt=true, grey=true}
			end
		end
		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.InspectPVPFrame, "OnShow", function(this)
		self:keepFontStrings(this)
		for i, slot in ipairs(this.Slots) do
			slot.Border:SetTexture(nil)
			self:makeIconSquare(slot, "Texture", true)
		end
		self:moveObject{obj=this.PortraitBackground, x=8, y=-10}
		self:SecureHook(this, "Hide", function(this)
			_G.InspectFrame.portrait:SetAlpha(0)
		end)
		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.InspectTalentFrame, "OnShow", function(this)
		self:keepFontStrings(this)
		this.InspectSpec.ring:SetTexture(nil)
		self:makeIconSquare(this.InspectSpec, "specIcon", true)
		for i = 1, _G.MAX_TALENT_TIERS do
			for j = 1, _G.NUM_TALENT_COLUMNS do
				this.InspectTalents["tier" .. i]["talent" .. j].Slot:SetTexture(nil)
				if self.modBtnBs then
					this.InspectTalents["tier" .. i]["talent" .. j].border:SetAlpha(0)
					self:addButtonBorder{obj=this.InspectTalents["tier" .. i]["talent" .. j], relTo=this.InspectTalents["tier" .. i]["talent" .. j].icon}
				end
			end
		end
		self:Unhook(this, "OnShow")
		if self.modBtnBs then
			-- run function again to correct button border colours
			this:Hide()
			this:Show()
		end
	end)

	self:SecureHookScript(_G.InspectGuildFrame, "OnShow", function(this)
		_G.InspectGuildFrameBG:SetAlpha(0)
		this.Points:DisableDrawLayer("BACKGROUND")
		self:Unhook(this, "OnShow")
	end)

end

-- copy of GEM_TYPE_INFO from Blizzard_ItemSocketingUI.xml
aObj.GEM_TYPE_INFO = {
	Yellow = {r=0.97 , g=0.82 , b=0.29},
	Red = {r=1 , g=0.47 , b=0.47},
	Blue = {r=0.47 , g=0.67 , b=1},
	PunchcardYellow = {r=0.97 , g=0.82 , b=0.29},
	PunchcardRed = {r=1 , g=0.47 , b=0.47},
	PunchcardBlue = {r=0.47 , g=0.67 , b=1},
	Hydraulic = {r=1, g=1, b=1},
	Cogwheel = {r=1, g=1, b=1},
	Meta = {r=1, g=1, b=1},
	Prismatic = {r=1, g=1, b=1},
}
aObj.blizzLoDFrames[ftype].ItemSocketingUI = function(self)
	if not self.prdb.ItemSocketingUI or self.initialized.ItemSocketingUI then return end
	self.initialized.ItemSocketingUI = true

	self:SecureHookScript(_G.ItemSocketingFrame, "OnShow", function(this)
		self:skinSlider{obj=_G.ItemSocketingScrollFrame.ScrollBar, size=3, rt="artwork"}
		self:skinStdButton{obj=_G.ItemSocketingSocketButton}
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true}

		if self.modBtns then
			for i = 1, _G.MAX_NUM_SOCKETS do
				_G["ItemSocketingSocket" .. i]:DisableDrawLayer("BACKGROUND")
				_G["ItemSocketingSocket" .. i]:DisableDrawLayer("BORDER")
				self:addSkinButton{obj=_G["ItemSocketingSocket" .. i], ft=ftype}
			end

			local function colourSockets()

				local clr
				for i = 1, _G.GetNumSockets() do
					clr = self.GEM_TYPE_INFO[_G.GetSocketTypes(i)]
					_G["ItemSocketingSocket" .. i].sb:SetBackdropBorderColor(clr.r, clr.g, clr.b)
				end
				clr = nil

			end
			-- hook this to colour the button border
			self:SecureHook("ItemSocketingFrame_Update", function()
				colourSockets()
			end)

			-- now colour the sockets
			colourSockets()
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzLoDFrames[ftype].LookingForGuildUI = function(self)
	if not self.prdb.LookingForGuildUI or self.initialized.LookingForGuildUI then return end

	if not _G.LookingForGuildFrame then
		_G.C_Timer.After(0.1, function()
			self.blizzLoDFrames[ftype].LookingForGuildUI(self)
		end)
		return
	end

	self.initialized.LookingForGuildUI = true

	local function addTabFrame(frame)
		-- add border around frame for tabs
		aObj:addSkinFrame{obj=frame, ft=ftype, kfs=true, nb=true, aso={bd=10, ng=true}, x1=-5, y1=2, x2=7, y2=-28}
	end

	self:skinTabs{obj=_G.LookingForGuildFrame, up=true, lod=true, x1=0, y1=-5, x2=3, y2=-5}
	self:addSkinFrame{obj=_G.LookingForGuildFrame, ft=ftype, kfs=true, ri=true, y2=-4}
	-- raise Tab level so they appear above Tab frames
	_G.RaiseFrameLevelByTwo(_G.LookingForGuildFrameTab1)
	_G.RaiseFrameLevelByTwo(_G.LookingForGuildFrameTab2)
	_G.RaiseFrameLevelByTwo(_G.LookingForGuildFrameTab3)

	self:SecureHookScript(_G.LookingForGuildStartFrame, "OnShow", function(this)
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.LookingForGuildQuestButton}
			self:skinCheckButton{obj=_G.LookingForGuildRaidButton}
			self:skinCheckButton{obj=_G.LookingForGuildDungeonButton}
			self:skinCheckButton{obj=_G.LookingForGuildPvPButton}
			self:skinCheckButton{obj=_G.LookingForGuildRPButton}
			self:skinCheckButton{obj=_G.LookingForGuildWeekdaysButton}
			self:skinCheckButton{obj=_G.LookingForGuildWeekendsButton}
			self:skinCheckButton{obj=_G.LookingForGuildTankButton.checkButton}
			self:skinCheckButton{obj=_G.LookingForGuildHealerButton.checkButton}
			self:skinCheckButton{obj=_G.LookingForGuildDamagerButton.checkButton}
		end
		_G.LookingForGuildInterestFrameBg:SetAlpha(0)
		_G.LookingForGuildAvailabilityFrameBg:SetAlpha(0)
		_G.LookingForGuildRolesFrameBg:SetAlpha(0)
		_G.LookingForGuildCommentFrameBg:SetAlpha(0)
		self:skinSlider{obj=_G.LookingForGuildCommentInputFrameScrollFrame.ScrollBar, size=3}
		self:addSkinFrame{obj=_G.LookingForGuildCommentInputFrame, ft=ftype, kfs=true, ofs=-1}
		_G.LookingForGuildCommentEditBoxFill:SetTextColor(self.BT:GetRGB())
		self:removeMagicBtnTex(_G.LookingForGuildBrowseButton)
		if self.modBtns then
			self:skinStdButton{obj=_G.LookingForGuildBrowseButton}
		end
		addTabFrame(this)

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.LookingForGuildStartFrame)

	self:SecureHookScript(_G.LookingForGuildBrowseFrame, "OnShow", function(this)
		self:skinSlider{obj=_G.LookingForGuildBrowseFrameContainerScrollBar, wdth=-4}
		for i = 1, #_G.LookingForGuildBrowseFrameContainer.buttons do
			self:applySkin{obj=_G.LookingForGuildBrowseFrameContainer.buttons[i]}
			_G[_G.LookingForGuildBrowseFrameContainer.buttons[i]:GetName() .. "Ring"]:SetAlpha(0)
		end
		self:removeMagicBtnTex(_G.LookingForGuildRequestButton)
		self:skinStdButton{obj=_G.LookingForGuildRequestButton}
		addTabFrame(this)

		self:Unhook(this, "OnShow")
	end)

	-- Requests
	self:SecureHookScript(_G.LookingForGuildAppsFrame, "OnShow", function(this)
		self:skinSlider{obj=_G.LookingForGuildAppsFrameContainerScrollBar}
		for i = 1, #_G.LookingForGuildAppsFrameContainer.buttons do
			self:applySkin{obj=_G.LookingForGuildAppsFrameContainer.buttons[i]}
		end
		addTabFrame(this)

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.GuildFinderRequestMembershipFrame, "OnShow", function(this)
		self:removeNineSlice(this.Border)
		self:skinSlider{obj=_G.GuildFinderRequestMembershipFrameInputFrameScrollFrame.ScrollBar, size=3}
		_G.GuildFinderRequestMembershipEditBoxFill:SetTextColor(self.BT:GetRGB())
		self:addSkinFrame{obj=_G.GuildFinderRequestMembershipFrameInputFrame, ft=ftype, x1=-2, x2=2, y2=-2}
		self:skinStdButton{obj=_G.GuildFinderRequestMembershipFrameAcceptButton}
		self:skinStdButton{obj=_G.GuildFinderRequestMembershipFrameCancelButton}
		self:addSkinFrame{obj=this, ft=ftype}
		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].LootFrames = function(self)
	if not self.prdb.LootFrames.skin or self.initialized.LootFrames then return end
	self.initialized.LootFrames = true

	self:SecureHookScript(_G.LootFrame, "OnShow", function(this)
		for i = 1, _G.LOOTFRAME_NUMBUTTONS do
			_G["LootButton" .. i .. "NameFrame"]:SetTexture(nil)
			if self.modBtnBs then
				self:addButtonBorder{obj=_G["LootButton" .. i]}
			end
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.LootFrameDownButton, ofs=-2}
			self:addButtonBorder{obj=_G.LootFrameUpButton, ofs=-2}
		end
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true}

		if self.modBtnBs then
			self:SecureHook("LootFrame_Update", function()
				for i = 1, _G.LOOTFRAME_NUMBUTTONS do
					if _G["LootButton" .. i].quality then
						_G.SetItemButtonQuality(_G["LootButton" .. i], _G["LootButton" .. i].quality)
					end
				end
			end)
		end

		self:Unhook(this, "OnShow")
	end)

	local function skinGroupLoot(frame)

		aObj:keepFontStrings(frame)
		frame.Timer.Background:SetAlpha(0)
		aObj:skinStatusBar{obj=frame.Timer, fi=0}
		-- hook this to show the Timer
		aObj:SecureHook(frame, "Show", function(this)
			this.Timer:SetFrameLevel(this:GetFrameLevel() + 1)
		end)

		if aObj.prdb.LootFrames.size == 1 then
			frame.IconFrame.Border:SetAlpha(0)
			aObj:addSkinFrame{obj=frame, ft=ftype, x1=-3, y2=-3} -- adjust for Timer
		elseif aObj.prdb.LootFrames.size == 2 then
			frame.IconFrame.Border:SetAlpha(0)
			frame:SetScale(0.75)
			aObj:addSkinFrame{obj=frame, ft=ftype, x1=-3, y2=-3} -- adjust for Timer
		elseif aObj.prdb.LootFrames.size == 3 then
			frame:SetScale(0.75)
			aObj:moveObject{obj=frame.IconFrame, x=95, y=5}
			frame.Name:SetAlpha(0)
			frame.NeedButton:ClearAllPoints()
			frame.NeedButton:SetPoint("TOPRIGHT", "$parent", "TOPRIGHT", -34, -4)
			frame.PassButton:ClearAllPoints()
			frame.PassButton:SetPoint("LEFT", frame.NeedButton, "RIGHT", 0, 2)
			frame.GreedButton:ClearAllPoints()
			frame.GreedButton:SetPoint("RIGHT", frame.NeedButton, "LEFT")
			frame.DisenchantButton:ClearAllPoints()
			frame.DisenchantButton:SetPoint("RIGHT", frame.GreedButton, "LEFT", 2, 0)
			aObj:adjWidth{obj=frame.Timer, adj=-30}
			frame.Timer:ClearAllPoints()
			frame.Timer:SetPoint("BOTTOMRIGHT", "$parent", "BOTTOMRIGHT", -10, 13)
			aObj:addSkinFrame{obj=frame, ft=ftype, x1=97, y2=8}
		end

	end
	for i = 1, _G.NUM_GROUP_LOOT_FRAMES do
		self:SecureHookScript(_G["GroupLootFrame" .. i], "OnShow", function(this)
			skinGroupLoot(this)
			self:Unhook(this, "OnShow")
		end)
	end

	self:SecureHookScript(_G.BonusRollFrame, "OnShow", function(this)
		self:removeRegions(this, {1, 2, 3, 5})
		self:skinStatusBar{obj=this.PromptFrame.Timer, fi=0}
		self:addSkinFrame{obj=this, ft=ftype, bg=true}
		if self.modBtnBs then
			 self:addButtonBorder{obj=this.PromptFrame, relTo=this.PromptFrame.Icon, reParent={this.SpecIcon}}
		end
		if self.modBtns then
			self:skinCloseButton{obj=this.PromptFrame.EncounterJournalLinkButtonHelp.CloseButton, noSkin=true}
		end
		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.BonusRollLootWonFrame, "OnShow", function(this)
		this:DisableDrawLayer("BACKGROUND")
		if this.SpecRing then this.SpecRing:SetTexture(nil) end
		self:addSkinFrame{obj=this, ft=ftype, ofs=-10, y2=8}
		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.BonusRollMoneyWonFrame, "OnShow", function(this)
		this:DisableDrawLayer("BACKGROUND")
		if this.SpecRing then this.SpecRing:SetTexture(nil) end
		self:addSkinFrame{obj=this, ft=ftype, ofs=-8, y2=8}
		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.MasterLooterFrame, "OnShow", function(this)
		this.Item.NameBorderLeft:SetTexture(nil)
		this.Item.NameBorderRight:SetTexture(nil)
		this.Item.NameBorderMid:SetTexture(nil)
		this.Item.IconBorder:SetTexture(nil)
		self:addButtonBorder{obj=this, relTo=this.Icon}
		this:DisableDrawLayer("BACKGROUND")
		self:skinCloseButton{obj=self:getChild(this, 3)} -- unamed close button
		self:addSkinFrame{obj=this, ft=ftype, kfs=true}
		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].LootHistory = function(self)
	if not self.prdb.LootHistory or self.initialized.LootHistory then return end
	self.initialized.LootHistory = true

	self:SecureHookScript(_G.LootHistoryFrame, "OnShow", function(this)
		local function skinItemFrames(obj)

			for i = 1, #obj.itemFrames do
				obj.itemFrames[i].Divider:SetTexture(nil)
				obj.itemFrames[i].NameBorderLeft:SetTexture(nil)
				obj.itemFrames[i].NameBorderRight:SetTexture(nil)
				obj.itemFrames[i].NameBorderMid:SetTexture(nil)
				obj.itemFrames[i].ActiveHighlight:SetTexture(nil)
				if aObj.modBtns then
					if not obj.itemFrames[i].ToggleButton.sb then
						aObj:skinExpandButton{obj=obj.itemFrames[i].ToggleButton, plus=true}
						aObj:SecureHook(obj.itemFrames[i].ToggleButton, "SetNormalTexture", function(this, nTex)
							aObj:checkTex{obj=this, nTex=nTex}
						end)
					end
				end
			end

		end
		self:skinSlider{obj=_G.LootHistoryFrame.ScrollFrame.ScrollBar, size=3}
		_G.LootHistoryFrame.ScrollFrame.ScrollBarBackground:SetTexture(nil)
		_G.LootHistoryFrame.Divider:SetTexture(nil)
		_G.LootHistoryFrame:DisableDrawLayer("BACKGROUND")
		self:addSkinFrame{obj=_G.LootHistoryFrame, ft=ftype, kfs=true, ofs=-1}
		-- hook this to skin loot history items
		self:SecureHook("LootHistoryFrame_FullUpdate", function(this)
			skinItemFrames(this)
		end)
		-- skin existing itemFrames
		skinItemFrames(_G.LootHistoryFrame)

		-- LootHistoryDropDown
		self:skinDropDown{obj=_G.LootHistoryDropDown}

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].MirrorTimers = function(self)
	if not self.prdb.MirrorTimers.skin or self.initialized.MirrorTimers then return end
	self.initialized.MirrorTimers = true

	local objName, obj, objBG, objSB
	for i = 1, _G.MIRRORTIMER_NUMTIMERS do
		objName = "MirrorTimer" .. i
		obj = _G[objName]
		objBG = self:getRegion(obj, 1)
		objSB = _G[objName .. "StatusBar"]
		self:removeRegions(obj, {3})
		obj:SetHeight(obj:GetHeight() * 1.25)
		self:moveObject{obj=_G[objName .. "Text"], y=-2}
		objBG:SetWidth(objBG:GetWidth() * 0.75)
		objSB:SetWidth(objSB:GetWidth() * 0.75)
		if self.prdb.MirrorTimers.glaze then
			self:skinStatusBar{obj=objSB, fi=0, bgTex=objBG}
		end
	end
	objName, obj, objBG, objSB = nil, nil, nil, nil

	-- Battleground/Arena/Island Expeditions Start Timer
	local function skinTT(timer)

		local bg
		if not aObj.sbGlazed[timer.bar] then
			_G[timer.bar:GetName() .. "Border"]:SetTexture(nil) -- animations
			aObj:skinStatusBar{obj=timer.bar, fi=0}
		end
		bg = nil

	end

	self:SecureHook("StartTimer_SetGoTexture", function(timer)
		skinTT(timer)
	end)
	-- skin existing timers
	for _, timer in pairs(_G.TimerTracker.timerList) do
		skinTT(timer)
	end

end

aObj.blizzFrames[ftype].ModelFrames = function(self)
	if IsAddOnLoaded("CloseUp") then
		aObj.blizzFrames[ftype].ModelFrames = nil
		return
	end

	if not self.prdb.CharacterFrames then return end

end

aObj.blizzFrames[ftype].ObjectiveTracker = function(self)
	if not self.prdb.ObjectiveTracker.skin and not self.prdb.ObjectiveTracker.popups then return end
	self.initialized.ObjectiveTracker = true

	-- ObjectiveTrackerFrame BlocksFrame
	if self.prdb.ObjectiveTracker.skin then
		self:addSkinFrame{obj=_G.ObjectiveTrackerFrame.BlocksFrame, ft=ftype, kfs=true, x1=-30, x2=4}
		--hook this to handle displaying of the ObjectiveTrackerFrame BlocksFrame skin frame
		self:SecureHook("ObjectiveTracker_Update", function(reason)
			_G.ObjectiveTrackerFrame.BlocksFrame.sf:SetShown(_G.ObjectiveTrackerFrame.HeaderMenu:IsShown())
		end)
	end

	self:skinDropDown{obj=_G.ObjectiveTrackerFrame.BlockDropDown}

	if self.modBtnBs then
		self:addButtonBorder{obj=_G.ObjectiveTrackerFrame.HeaderMenu.MinimizeButton, es=12, ofs=0, x1=-1}
		-- hook this to skin QuestObjective Block Button(s)
		self:SecureHook("QuestObjectiveSetupBlockButton_AddRightButton", function(block, button, iAO)
			-- aObj:Debug("QOSBB_ARB: [%s, %s]", block, button)
			if not button.sbb then
				aObj:addButtonBorder{obj=button, ofs=button.Icon and -2 or nil, x1=button.Icon and 0 or nil, reParent=button.Count and {button.Count} or nil} -- adjust x offset for FindGroup button(s), reparent Item Count if required
			end
		end)
		-- skin existing buttons
		local btn
		for _, mod in ipairs(_G.ObjectiveTrackerFrame.MODULES) do
			for _, blk in pairs(mod.usedBlocks) do
				if blk.rightButton then
					btn = blk.rightButton
					self:addButtonBorder{obj=btn, ofs=btn.Icon and -2 or nil, x1=btn.Icon and 0 or nil, reParent=btn.Count and {btn.Count} or nil} -- adjust x offset for FindGroup button(s), reparent Item Count if required
				end
			end
		end
		btn = nil
	end

	-- skin timerBar(s) & progressBar(s)
	local function skinBar(bar)

		if not aObj.sbGlazed[bar.Bar] then
			if bar.Bar.BorderLeft then
				bar.Bar.BorderLeft:SetTexture(nil)
				bar.Bar.BorderRight:SetTexture(nil)
				bar.Bar.BorderMid:SetTexture(nil)
				aObj:skinStatusBar{obj=bar.Bar, fi=0, bgTex=self:getRegion(bar.Bar, bar.Bar.Label and 5 or 4)}
			else
				-- BonusTrackerProgressBarTemplate bars
				bar.Bar.BarFrame:SetTexture(nil)
				bar.Bar.IconBG:SetTexture(nil)
				bar.Bar.BarFrame2:SetTexture(nil)
				bar.Bar.BarFrame3:SetTexture(nil)
				aObj:skinStatusBar{obj=bar.Bar, fi=0, bgTex=bar.Bar.BarBG}
				bar.Bar:DisableDrawLayer("OVERLAY")
				bar.FullBarFlare1.BarGlow:SetTexture(nil)
			end
		end

	end

	-- TimerBars
	self:SecureHook(_G.DEFAULT_OBJECTIVE_TRACKER_MODULE, "AddTimerBar", function(this, block, line, ...)
		-- aObj:Debug("DEFAULT_OBJECTIVE_TRACKER_MODULE AddTimerBar: [%s, %s, %s]", this, block, line)
		skinBar(this.usedTimerBars[block] and this.usedTimerBars[block][line])
	end)
	-- ProgressBars
	self:SecureHook(_G.DEFAULT_OBJECTIVE_TRACKER_MODULE, "AddProgressBar", function(this, block, line, ...)
		-- aObj:Debug("DEFAULT_OBJECTIVE_TRACKER_MODULE AddProgressBar: [%s, %s, %s]", this, block, line)
		skinBar(this.usedProgressBars[block] and this.usedProgressBars[block][line])
	end)
	self:SecureHook(_G.SCENARIO_TRACKER_MODULE, "AddProgressBar", function(this, block, line, ...)
		-- aObj:Debug("SCENARIO_TRACKER_MODULE AddProgressBar: [%s, %s, %s]", this, block, line)
		skinBar(this.usedProgressBars[block] and this.usedProgressBars[block][line])
	end)
	self:SecureHook(_G.BONUS_OBJECTIVE_TRACKER_MODULE, "AddProgressBar", function(this, block, line, ...)
		-- aObj:Debug("BONUS_OBJECTIVE_TRACKER_MODULE AddProgressBar: [%s, %s, %s]", this, block, line)
		skinBar(this.usedProgressBars[block] and this.usedProgressBars[block][line])
	end)
	self:SecureHook(_G.WORLD_QUEST_TRACKER_MODULE, "AddProgressBar", function(this, block, line, ...)
		-- aObj:Debug("WORLD_QUEST_TRACKER_MODULE AddProgressBar: [%s, %s, %s]", this, block, line)
		skinBar(this.usedProgressBars[block] and this.usedProgressBars[block][line])
	end)
	-- skin existing Timer & Progress bars
	local function skinBars(table)
		for _, block in pairs(table) do
				for _, line in pairs(block) do
				skinBar(line)
			end
		end
	end
	skinBars(_G.DEFAULT_OBJECTIVE_TRACKER_MODULE.usedTimerBars)
	skinBars(_G.DEFAULT_OBJECTIVE_TRACKER_MODULE.usedProgressBars)
	skinBars(_G.QUEST_TRACKER_MODULE.usedTimerBars)
	skinBars(_G.QUEST_TRACKER_MODULE.usedProgressBars)
	skinBars(_G.SCENARIO_TRACKER_MODULE.usedTimerBars)
	skinBars(_G.SCENARIO_TRACKER_MODULE.usedProgressBars)
	skinBars(_G.ACHIEVEMENT_TRACKER_MODULE.usedTimerBars)
	skinBars(_G.BONUS_OBJECTIVE_TRACKER_MODULE.usedProgressBars)
	skinBars(_G.WORLD_QUEST_TRACKER_MODULE.usedProgressBars)

	local function skinRewards(frame)

		for i = 1, #frame.Rewards do
			frame.Rewards[i].ItemBorder:SetTexture(nil)
			if aObj.modBtnBs then
				if not frame.Rewards[i].sbb then
					aObj:addButtonBorder{obj=frame.Rewards[i], relTo=frame.Rewards[i].ItemIcon, reParent={frame.Rewards[i].Count}}
				end
			end
		end

	end

	self:SecureHook("BonusObjectiveTracker_AnimateReward", function(block)
		skinRewards(block.module.rewardsFrame)
	end)

	-- ScenarioObjectiveBlock

	-- ScenarioStageBlock
	self:nilTexture(_G.ScenarioStageBlock.NormalBG, true)
	self:addSkinFrame{obj=_G.ScenarioStageBlock, ft=ftype, kfs=true, nb=true, y1=-1, x2=41, y2=7}

	-- ScenarioChallengeModeBlock
	self:skinStatusBar{obj=_G.ScenarioChallengeModeBlock.StatusBar, fi=0, bgTex=_G.ScenarioChallengeModeBlock.TimerBG, otherTex={_G.ScenarioChallengeModeBlock.TimerBGBack}}
	self:removeRegions(_G.ScenarioChallengeModeBlock, {3}) -- challengemode-timer atlas
	self:addSkinFrame{obj=_G.ScenarioChallengeModeBlock, ft=ftype, nb=true, y2=7}
	self:SecureHook("Scenario_ChallengeMode_SetUpAffixes", function(block, affixes)
		for i = 1, #block.Affixes do
			block.Affixes[i].Border:SetTexture(nil)
		end
	end)

	-- ScenarioProvingGroundsBlock
	_G.ScenarioProvingGroundsBlock.BG:SetTexture(nil)
	_G.ScenarioProvingGroundsBlock.GoldCurlies:SetTexture(nil)
	self:skinStatusBar{obj=_G.ScenarioProvingGroundsBlock.StatusBar, fi=0}
	self:removeRegions(_G.ScenarioProvingGroundsBlock.StatusBar, {1}) -- border
	self:addSkinFrame{obj=_G.ScenarioProvingGroundsBlock, ft=ftype, nb=true, x2=41}
	_G.ScenarioProvingGroundsBlockAnim.BorderAnim:SetTexture(nil)

	-- ScenarioWidgetContainerBlock

	self:SecureHook("ScenarioObjectiveTracker_AnimateReward", function(xp, money)
		_G.ObjectiveTrackerScenarioRewardsFrame:DisableDrawLayer("ARTWORK")
		_G.ObjectiveTrackerScenarioRewardsFrame:DisableDrawLayer("BORDER")
		skinRewards(_G.ObjectiveTrackerScenarioRewardsFrame)
	end)

	self:skinGlowBox(_G.ScenarioBlocksFrame.WarfrontHelpBox, ftype)

	-- tooltip
	_G.C_Timer.After(0.1, function()
		aObj:add2Table(aObj.ttList, _G.ScenarioStepRewardTooltip)
	end)

	-- remove Shadow texture
	_G.BONUS_OBJECTIVE_TRACKER_MODULE.Header:DisableDrawLayer("BACKGROUND")
	_G.WORLD_QUEST_TRACKER_MODULE.Header:DisableDrawLayer("BACKGROUND")
	-- remove Header backgrounds
	_G.ObjectiveTrackerFrame.BlocksFrame.QuestHeader.Background:SetTexture(nil)
	_G.ObjectiveTrackerFrame.BlocksFrame.AchievementHeader.Background:SetTexture(nil)
	_G.ObjectiveTrackerFrame.BlocksFrame.ScenarioHeader.Background:SetTexture(nil)
	_G.BONUS_OBJECTIVE_TRACKER_MODULE.Header.Background:SetTexture(nil)
	_G.WORLD_QUEST_TRACKER_MODULE.Header.Background:SetTexture(nil)

	_G.ObjectiveTrackerBonusRewardsFrame:DisableDrawLayer("ARTWORK")
	_G.ObjectiveTrackerBonusRewardsFrame.RewardsShadow:SetTexture(nil)

	_G.ObjectiveTrackerWorldQuestRewardsFrame:DisableDrawLayer("ARTWORK")
	_G.ObjectiveTrackerWorldQuestRewardsFrame.RewardsShadow:SetTexture(nil)

	_G.ObjectiveTrackerBonusBannerFrame.BG1:SetTexture(nil)
	_G.ObjectiveTrackerBonusBannerFrame.BG2:SetTexture(nil)

	-- AutoPopup frames
	if self.prdb.ObjectiveTracker.popups then
		local function skinAutoPopUps()
			local questID, popUpType, questTitle, block, blockContents
			for i = 1, _G.GetNumAutoQuestPopUps() do
				questID, popUpType = _G.GetAutoQuestPopUp(i)
				if not _G.IsQuestBounty(questID) then
					questTitle = _G.GetQuestLogTitle(_G.GetQuestLogIndexByID(questID))
					if questTitle
					and questTitle ~= ""
					then
						block = _G.AUTO_QUEST_POPUP_TRACKER_MODULE:GetBlock(questID)
						if not block.module.hasSkippedBlocks then
							if block.init
							and not block.ScrollChild.sf
							then
								blockContents = block.ScrollChild
								aObj:removeRegions(blockContents, {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 13, 17, 18}, true)
								-- blockContents.Bg:SetTexture(nil)
								-- blockContents.BorderTopLeft:SetTexture(nil)
								-- blockContents.BorderTopRight:SetTexture(nil)
								-- blockContents.BorderBotLeft:SetTexture(nil)
								-- blockContents.BorderBotRight:SetTexture(nil)
								-- blockContents.BorderLeft:SetTexture(nil)
								-- blockContents.BorderRight:SetTexture(nil)
								-- blockContents.BorderTop:SetTexture(nil)
								-- blockContents.BorderBottom:SetTexture(nil)
								-- blockContents.QuestIconBg:SetTexture(nil)
								-- blockContents.QuestIconBadgeBorder:SetTexture(nil)
								-- blockContents.Shine:SetTexture(nil)
								-- blockContents.IconShine:SetTexture(nil)
								blockContents.FlashFrame.IconFlash:SetTexture(nil)
								aObj:addSkinFrame{obj=blockContents, ft=ftype, x1=32}
								-- TODO: prevent Background being changed, causes border art to appear broken ?
							end
						end
					end
				end
			end
			questID, popUpType, questTitle, block, blockContents = nil, nil, nil, nil, nil
		end

		-- hook this to skin the AutoPopUps
		self:SecureHook(_G.AUTO_QUEST_POPUP_TRACKER_MODULE, "Update", function(this)
			if _G.SplashFrame:IsShown() then return end
			skinAutoPopUps()
		end)
		skinAutoPopUps()
	end

	-- remove Glow/Sheen textures from WorldQuest modules
	local function updTrackerModules()
		local module
		for i = 1, #_G.ObjectiveTrackerFrame.MODULES do
			module = _G.ObjectiveTrackerFrame.MODULES[i]
			if module.ShowWorldQuests then
				for k, blk in pairs(module.usedBlocks) do
					for l, child in pairs{blk.ScrollContents:GetChildren()} do
						-- _G.Spew("Module" .. i .. "-" .. k.. "-" .. l, child)
						if child.Glow then
							child.Glow:SetTexture(nil)
							child.Sheen:SetTexture(nil)
						end
					end
				end
			end
		end
		module = nil
	end
	updTrackerModules() -- update any existing modules
	-- hook this to handle new modules
	self:SecureHook("ObjectiveTracker_Update", function(reason, id)
		-- aObj:Debug("ObjectiveTracker_Update: [%s, %s]", reason, id)
		updTrackerModules()
	end)

end

aObj.blizzFrames[ftype].OverrideActionBar = function(self) -- a.k.a. Vehicle UI
	if not self.prdb.OverrideActionBar  or self.initialized.OverrideActionBar then return end
	self.initialized.OverrideActionBar = true

	self:SecureHookScript(_G.OverrideActionBar, "OnShow", function(this)
		local function skinOverrideActionBar(frame)

			-- remove all textures
			frame:DisableDrawLayer("OVERLAY")
			frame:DisableDrawLayer("BACKGROUND")
			frame:DisableDrawLayer("BORDER")

			-- PitchFrame
			frame.pitchFrame.Divider1:SetTexture(nil)
			frame.pitchFrame.PitchOverlay:SetTexture(nil)
			frame.pitchFrame.PitchButtonBG:SetTexture(nil)

			-- LeaveFrame
			frame.leaveFrame.Divider3:SetTexture(nil)
			frame.leaveFrame.ExitBG:SetTexture(nil)

			-- ExpBar
			frame.xpBar.XpMid:SetTexture(nil)
			frame.xpBar.XpL:SetTexture(nil)
			frame.xpBar.XpR:SetTexture(nil)
			for i = 1, 19 do
				frame.xpBar["XpDiv" .. i]:SetTexture(nil)
			end
			aObj:skinStatusBar{obj=frame.xpBar, fi=0, bgTex=aObj:getRegion(frame.xpBar, 1)}

			aObj:addSkinFrame{obj=frame, ft=ftype, x1=144, y1=6, x2=-142, y2=-2}

			if self.modBtnBs then
				self:addButtonBorder{obj=this.pitchFrame.PitchUpButton}
				self:addButtonBorder{obj=this.pitchFrame.PitchDownButton}
				self:addButtonBorder{obj=this.leaveFrame.LeaveButton}
				for i = 1, 6 do
					self:addButtonBorder{obj=this["SpellButton" .. i], abt=true}
				end
			end

		end

		self:SecureHook(this, "Show", function(this, ...)
			skinOverrideActionBar(this)
		end)
		if this:IsShown() then
			skinOverrideActionBar(this)
		end
		self:SecureHook("OverrideActionBar_SetSkin", function(skin)
			skinOverrideActionBar(this)
		end)

		self:Unhook(this, "OnShow")

	end)

end

aObj.blizzLoDFrames[ftype].PVPUI = function(self)
	if not self.prdb.PVPFrame or self.initialized.PVPFrame then return end
	self.initialized.PVPFrame = true

	self:SecureHookScript(_G.PVPUIFrame, "OnShow", function(this)

		-- N.B. Frame already skinned as it is now part of GroupFinder/PVE
		for i = 1, 3 do
			_G.PVPQueueFrame["CategoryButton" .. i].Background:SetTexture(nil)
			_G.PVPQueueFrame["CategoryButton" .. i].Ring:SetTexture(nil)
			self:changeRecTex(_G.PVPQueueFrame["CategoryButton" .. i]:GetHighlightTexture())
			-- make Icon square
			self:makeIconSquare(_G.PVPQueueFrame["CategoryButton" .. i], "Icon", true)
		end
		if self.modBtnBs then
			-- hook this to change button border colour
			self:SecureHook("PVPQueueFrame_SetCategoryButtonState", function(btn, enabled)
				if btn:IsEnabled() then
					btn.sbb:SetBackdropBorderColor(aObj.bbClr:GetRGBA())
				else
					btn.sbb:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
				end
			end)
		end

		-- hook this to change selected texture
		self:SecureHook("PVPQueueFrame_SelectButton", function(index)
			for i = 1, 3 do
				if i == index then
					self:changeRecTex(_G.PVPQueueFrame["CategoryButton" .. i].Background, true)
				else
					_G.PVPQueueFrame["CategoryButton" .. i].Background:SetTexture(nil)
				end
			end
		end)
		_G.PVPQueueFrame_SelectButton(1) -- select Honor button
		self:skinGlowBox(_G.PremadeGroupsPvPTutorialAlert, ftype)

		-- skin common elements (Honor & Conquest frames)
		local function skinCommon(frame)
			aObj:removeInset(frame.Inset)
			frame.ConquestBar:DisableDrawLayer("BORDER")
			aObj:skinStatusBar{obj=frame.ConquestBar, fi=0, bgTex=frame.ConquestBar.Background}
			frame.ConquestBar.Reward.Ring:SetTexture(nil)
			if self.modBtnBs then
				aObj:addButtonBorder{obj=frame.ConquestBar.Reward, relTo=frame.ConquestBar.Reward.Icon}
			end
			if aObj.modChkBtns then
				aObj:skinCheckButton{obj=frame.HealerIcon.checkButton}
				aObj:skinCheckButton{obj=frame.TankIcon.checkButton}
				aObj:skinCheckButton{obj=frame.DPSIcon.checkButton}
			end
		end

		-- Casual
		self:SecureHookScript(_G.HonorFrame, "OnShow", function(this)
			skinCommon(this)
			self:skinDropDown{obj=_G.HonorFrameTypeDropDown}
			self:skinSlider{obj=this.SpecificFrame.scrollBar, wdth=-4}
			for i = 1, #_G.HonorFrame.SpecificFrame.buttons do
				this.SpecificFrame.buttons[i].Bg:SetTexture(nil)
				this.SpecificFrame.buttons[i].Border:SetTexture(nil)
			end
			local btn
			for _, bName in pairs{"RandomBG", "RandomEpicBG", "Arena1", "Brawl"} do
				btn = this.BonusFrame[bName .. "Button"]
				btn.NormalTexture:SetTexture(nil)
				btn:SetPushedTexture(nil)
				btn.Reward.Border:SetTexture(nil)
				if self.modBtnBs then
					 self:addButtonBorder{obj=btn.Reward, relTo=btn.Reward.Icon, reParent={btn.Reward.EnlistmentBonus}}
				end
			end
			btn = nil
			this.BonusFrame:DisableDrawLayer("BACKGROUND")
			this.BonusFrame:DisableDrawLayer("BORDER")
			this.BonusFrame.ShadowOverlay:DisableDrawLayer("OVERLAY")
			self:removeMagicBtnTex(this.QueueButton)
			if self.modBtns then
				self:skinStdButton{obj=this.QueueButton}
			end
			self:skinGlowBox(this.BonusFrame.BrawlHelpBox, ftype)
			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.HonorFrame)

		-- Rated
		self:SecureHookScript(_G.ConquestFrame, "OnShow", function(this)
			skinCommon(this)
			this:DisableDrawLayer("BACKGROUND")
			this:DisableDrawLayer("BORDER")
			this.ShadowOverlay:DisableDrawLayer("OVERLAY")
			this.Arena2v2.Reward.Border:SetTexture(nil)
			this.Arena2v2.NormalTexture:SetTexture(nil)
			this.Arena3v3.Reward.Border:SetTexture(nil)
			this.Arena3v3.NormalTexture:SetTexture(nil)
			this.RatedBG.Reward.Border:SetTexture(nil)
			this.RatedBG.NormalTexture:SetTexture(nil)
			self:skinDropDown{obj=this.ArenaInviteMenu}
			self:removeMagicBtnTex(this.JoinButton)
			if self.modBtns then
				 self:skinStdButton{obj=this.JoinButton}
		 		-- N.B. NO CloseButton for NoSeason & Disabled
			end
			self:skinGlowBox(this.NoSeason, ftype, true)
			self:skinGlowBox(this.Disabled, ftype, true)
			self:Unhook(this, "OnShow")
		end)

		self:removeInset(_G.PVPQueueFrame.HonorInset)
		_G.PVPQueueFrame.HonorInset:DisableDrawLayer("BACKGROUND")
		local hld
		hld = _G.PVPQueueFrame.HonorInset.CasualPanel.HonorLevelDisplay
		hld:DisableDrawLayer("BORDER")
		self:removeRegions(hld.NextRewardLevel, {2, 4}) -- IconCover & RingBorder
		if self.modBtnBs then
			local function chkBtn(btn)
				if btn.RewardIcon:IsDesaturated()
				and btn.IconCover:IsShown()
				then
					btn.sbb:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
				else
					btn.sbb:SetBackdropBorderColor(aObj.bbClr:GetRGBA())
				end
			end
			self:addButtonBorder{obj=hld.NextRewardLevel, relTo=hld.NextRewardLevel.RewardIcon}
			chkBtn(hld.NextRewardLevel)
			self:SecureHook(hld, "Update", function(this)
				chkBtn(this.NextRewardLevel)
			end)
		end
		_G.PVPQueueFrame.HonorInset.RatedPanel.WeeklyChest.FlairTexture:SetTexture(nil)
		local srf = _G.PVPQueueFrame.HonorInset.RatedPanel.SeasonRewardFrame
		srf.Ring:SetTexture(nil)
		if self.modBtnBs then
			local function chkBtn(btn)
				if btn.Icon:IsDesaturated()	then
					btn.sbb:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
				else
					btn.sbb:SetBackdropBorderColor(aObj.bbClr:GetRGBA())
				end
			end
			self:addButtonBorder{obj=srf, relTo=srf.Icon}
			chkBtn(srf)
			self:SecureHook(srf, "Update", function(this)
				chkBtn(this)
			end)
		end
		hld, srf = nil, nil

		_G.PVPQueueFrame.NewSeasonPopup.NewSeason:SetTextColor(self.HT:GetRGB())
		_G.PVPQueueFrame.NewSeasonPopup.SeasonDescription:SetTextColor(self.BT:GetRGB())
		_G.PVPQueueFrame.NewSeasonPopup.SeasonDescription2:SetTextColor(self.BT:GetRGB())
		_G.SeasonRewardFrame.Ring:SetTexture(nil)
		self:getRegion(_G.SeasonRewardFrame, 3):SetTextColor(self.BT:GetRGB())
		self:addSkinFrame{obj=_G.PVPQueueFrame.NewSeasonPopup, ft=ftype, kfs=true, nb=true, ofs=-13}
		if self.modBtns then
			self:skinStdButton{obj=_G.PVPQueueFrame.NewSeasonPopup.Leave}
		end

		self:Unhook(this, "OnShow")
	end)

	-- tooltips
	_G.C_Timer.After(0.1, function()
		self:add2Table(self.ttList, _G.ConquestTooltip)
	end)

end

aObj.blizzFrames[ftype].PVPHonorSystem = function(self)

	self:SecureHookScript(_G.HonorLevelUpBanner, "OnShow", function(this)
		this:DisableDrawLayer("BORDER")
		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.PrestigeLevelUpBanner, "OnShow", function(this)
		this.BG1:SetTexture(nil)
		this.BG2:SetTexture(nil)
		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzLoDFrames[ftype].RaidUI = function(self)
	if not self.prdb.RaidUI or self.initialized.RaidUI then return end
	self.initialized.RaidUI = true

	local function skinPulloutFrames()

		for i = 1, _G.NUM_RAID_PULLOUT_FRAMES do
			if not _G["RaidPullout" .. i].sf then
				aObj:skinDropDown{obj=_G["RaidPullout" .. i .. "DropDown"]}
				_G["RaidPullout" .. i .. "MenuBackdrop"]:SetBackdrop(nil)
				aObj:addSkinFrame{obj=_G["RaidPullout" .. i], ft=ftype, kfs=true, x1=3, y1=-1, x2=-1, y2=1}
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
			if not _G[pfName .. "Button" .. i].sf then
				for _, bName in pairs{"HealthBar", "ManaBar", "Target", "TargetTarget"} do
					self:removeRegions(_G[pfName .. "Button" .. i .. bName], {2})
					self:skinStatusBar{obj=_G[pfName .. "Button" .. i .. bName], fi=0, bgTex=_G[pfName .. "Button" .. i .. bName .. "Background"]}
				end
				self:addSkinFrame{obj=_G[pfName .. "Button" .. i .. "TargetTargetFrame"], ft=ftype, x1=4, x2=-4, y2=2}
				self:addSkinFrame{obj=_G[pfName .. "Button" .. i], ft=ftype, kfs=true, x1=-4, y1=-6, x2=4, y2=-6}
			end
		end
		pfName = nil
	end)

	self:moveObject{obj=_G.RaidGroup1, x=2}

	-- Raid Groups
	for i = 1, _G.MAX_RAID_GROUPS do
		_G["RaidGroup" .. i]:DisableDrawLayer("BACKGROUND")
		self:addSkinFrame{obj=_G["RaidGroup" .. i], ft=ftype}
	end
	-- Raid Group Buttons
	for i = 1, _G.MAX_RAID_GROUPS * 5 do
		_G["RaidGroupButton" .. i]:SetNormalTexture(nil)
		self:addSkinFrame{obj=_G["RaidGroupButton" .. i], ft=ftype, aso={bd=5}}
	end
	-- Raid Class Tabs (side)
	for i = 1, _G.MAX_RAID_CLASS_BUTTONS do
		self:removeRegions(_G["RaidClassButton" .. i], {1}) -- 2 is icon, 3 is text
	end

	-- skin existing frames
	skinPulloutFrames()

end

aObj.blizzFrames[ftype].ReadyCheck = function(self)
	if not self.prdb.ReadyCheck or self.initialized.ReadyCheck then return end
	self.initialized.ReadyCheck = true

	self:SecureHookScript(_G.ReadyCheckFrame, "OnShow", function(this)
		self:skinStdButton{obj=_G.ReadyCheckFrameYesButton}
		self:skinStdButton{obj=_G.ReadyCheckFrameNoButton}
		self:addSkinFrame{obj=_G.ReadyCheckListenerFrame, ft=ftype, kfs=true, nb=true, x1=32}
		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].RolePollPopup = function(self)
	if not self.prdb.RolePollPopup or self.initialized.RolePollPopup then return end
	self.initialized.RolePollPopup = true

	self:SecureHookScript(_G.RolePollPopup, "OnShow", function(this)
		self:removeNineSlice(this.Border)
		if self.modBtns then
			self:skinStdButton{obj=this.acceptButton}
		end
		self:addSkinFrame{obj=this, ft=ftype, x1=5, y1=-5, x2=-5, y2=5}
		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].ScrollOfResurrection = function(self)
	if not self.prdb.ScrollOfResurrection or self.initialized.ScrollOfResurrection then return end
	self.initialized.ScrollOfResurrection = true

	self:SecureHookScript(_G.ScrollOfResurrectionFrame, "OnShow", function(this)
		self:removeNineSlice(this.Border)
		self:skinEditBox{obj=this.targetEditBox, regs={6}} -- 6 is text
		this.targetEditBox.fill:SetTextColor(self.BT:GetRGB())
		self:addSkinFrame{obj=this.noteFrame, ft=ftype, kfs=true}
		self:skinSlider{obj=this.noteFrame.scrollFrame.ScrollBar, wdth=-4, size=3}
		this.noteFrame.scrollFrame.editBox.fill:SetTextColor(self.BT:GetRGB())
		self:addSkinFrame{obj=this, ft=ftype, kfs=true}
		-- Selection frame
		self:skinEditBox{obj=_G.ScrollOfResurrectionSelectionFrame.targetEditBox, regs={6}} -- 6 is text
		self:skinSlider{obj=_G.ScrollOfResurrectionSelectionFrame.list.scrollFrame.scrollBar, size=4}
		self:addSkinFrame{obj=_G.ScrollOfResurrectionSelectionFrame.list, ft=ftype, kfs=true}
		self:addSkinFrame{obj=_G.ScrollOfResurrectionSelectionFrame, ft=ftype, kfs=true}

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].SpellBookFrame = function(self)
	if not self.prdb.SpellBookFrame or self.initialized.SpellBookFrame then return end
	self.initialized.SpellBookFrame = true

	self:SecureHookScript(_G.SpellBookFrame, "OnShow", function(this)

		this.MainHelpButton.Ring:SetTexture(nil)
		self:moveObject{obj=this.MainHelpButton, y=-4}

		this.numTabs = 5
		self:skinTabs{obj=this, suffix="Button", lod=true, x1=8, y1=1, x2=-8, y2=2}
		if self.isTT then
			local function setTab(bookType)
				local tab
				for i = 1, this.numTabs do
					tab = _G["SpellBookFrameTabButton" .. i]
					if tab.bookType == bookType then
						self:setActiveTab(tab.sf)
					else
						self:setInactiveTab(tab.sf)
					end
				end
				tab = nil

			end
			-- hook to handle tabs
			self:SecureHook("ToggleSpellBook", function(bookType)
				setTab(bookType)
			end)
			-- set correct tab
			setTab(this.bookType)
		end
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true, y2=-5}
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.SpellBookPrevPageButton, ofs=-2, y1=-3, x2=-3}
			self:addButtonBorder{obj=_G.SpellBookNextPageButton, ofs=-2, y1=-3, x2=-3}
		end

		-- Spellbook Panel
		local function updBtn(btn)

            -- handle in combat
            if _G.InCombatLockdown() then
                aObj:add2Table(aObj.oocTab, {updBtn, {btn}})
                return
            end

			if aObj.modBtnBs
			and btn.sbb -- allow for not skinned during combat
			then
				if not btn:IsEnabled() then
					btn.sbb:Hide()
				else
					btn.sbb:Show()
				end
			end
			local spellString, subSpellString = _G[btn:GetName() .. "SpellName"], _G[btn:GetName() .. "SubSpellName"]
			if _G[btn:GetName() .. "IconTexture"]:IsDesaturated() then -- player level too low, see Trainer, or offSpec
				if btn.sbb then btn.sbb:SetBackdropBorderColor(0.5, 0.5, 0.5, 0.75) end
				spellString:SetTextColor(_G.DISABLED_FONT_COLOR:GetRGB())
				subSpellString:SetTextColor(_G.DISABLED_FONT_COLOR:GetRGB())
				btn.RequiredLevelString:SetTextColor(_G.DISABLED_FONT_COLOR:GetRGB())
				btn.SeeTrainerString:SetTextColor(_G.DISABLED_FONT_COLOR:GetRGB())
			else
				if btn.sbb then btn.sbb:SetBackdropBorderColor(aObj.bbClr:GetRGBA()) end
				spellString:SetTextColor(aObj.HT:GetRGB())
				subSpellString:SetTextColor(aObj.BT:GetRGB())
			end
			spellString, subSpellString = nil, nil
		end

		_G.SpellBookPageText:SetTextColor(self.BT:GetRGB())
		local btn
		for i = 1, _G.SPELLS_PER_PAGE do
			btn = _G["SpellButton" .. i]
			btn:DisableDrawLayer("BACKGROUND")
			btn:DisableDrawLayer("BORDER")
			_G["SpellButton" .. i .. "SlotFrame"]:SetAlpha(0)
			btn.UnlearnedFrame:SetAlpha(0)
			btn.TrainFrame:SetAlpha(0)
			if self.modBtnBs then
				self:addButtonBorder{obj=btn, sec=true, reParent={btn.FlyoutArrow, _G["SpellButton" .. i .. "AutoCastable"]}}
			end
			updBtn(btn)
		end
		btn = nil

		-- hook this to change text colour as required
		self:SecureHook("SpellButton_UpdateButton", function(this)
			updBtn(this)
		end)

		-- Tabs (side)
		for i = 1, _G.MAX_SKILLLINE_TABS do
			self:removeRegions(_G["SpellBookSkillLineTab" .. i], {1}) -- N.B. other regions are icon and highlight
			self:addButtonBorder{obj=_G["SpellBookSkillLineTab" .. i]}
		end

		-- Professions Panel
		local function skinProf(type, times)

			local objName, obj
			for i = 1, times do
				objName = type .. "Profession" .. i
				obj =_G[objName]
				if type == "Primary" then
					_G[objName .. "IconBorder"]:Hide()
					-- make icon square
					aObj:makeIconSquare(obj, "icon")
					if not obj.missingHeader:IsShown() then
						obj.icon:SetDesaturated(nil) -- show in colour
						if aObj.modBtnBs then
							obj.sbb:SetBackdropBorderColor(aObj.bbClr:GetRGBA())
						end
					else
						if aObj.modBtnBs then
							obj.sbb:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
						end
					end
				else
					obj.missingHeader:SetTextColor(aObj.HT:GetRGB())
				end
				obj.missingText:SetTextColor(aObj.BT:GetRGB())
				local btn
				for i = 1, 2 do
					btn = obj["button" .. i]
					btn:DisableDrawLayer("BACKGROUND")
					btn.subSpellString:SetTextColor(aObj.BT:GetRGB())
					if aObj.modBtnBs then
						aObj:addButtonBorder{obj=btn, sec=true}
					end
				end
				btn = nil
				aObj:rmRegionsTex(obj.statusBar, {2, 3, 4, 5, 6})
				aObj:skinStatusBar{obj=obj.statusBar, fi=0}
				obj.statusBar:SetStatusBarColor(0, 1, 0, 1)
				obj.statusBar:SetHeight(12)
				obj.statusBar.rankText:SetPoint("CENTER", 0, 0)
				aObj:moveObject{obj=obj.statusBar, x=-12}
				if obj.unlearn then
					aObj:moveObject{obj=obj.unlearn, x=18}
				end
			end
			objName, obj = nil, nil

		end
		-- Primary professions
		skinProf("Primary", 2)
		-- Secondary professions
		skinProf("Secondary", 3)

		self:skinGlowBox(_G.SpellLockedTooltip, ftype)

		if self.modBtnBs then
			-- hook this to change Primary Profession Button border colours if required
			self:SecureHook("SpellBook_UpdateProfTab", function()
				for i = 1, 2 do
					if _G["PrimaryProfession" .. i].unlearn:IsShown() then
						_G["PrimaryProfession" .. i].sbb:SetBackdropBorderColor(aObj.bbClr:GetRGBA())
					else
						_G["PrimaryProfession" .. i].sbb:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
					end
				end
			end)
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].StackSplit = function(self)
	if not self.prdb.StackSplit or self.initialized.StackSplit then return end
	self.initialized.StackSplit = true

	self:SecureHookScript(_G.StackSplitFrame, "OnShow", function(this)
		-- handle different addons being loaded
		if IsAddOnLoaded("EnhancedStackSplit") then
			if _G.Round(_G.EnhancedStackSplitBottomTextureFrame:GetHeight()) == 30 then
				self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true, y2=-45}
			else
				self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true, y2=-24}
			end
		else
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true, x1=9, y1=-12, x2=-6, y2=12}
		end
		if self.modBtns then
			self:skinStdButton{obj=_G.StackSplitFrame.OkayButton}
			self:skinStdButton{obj=_G.StackSplitFrame.CancelButton}
		end
		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzLoDFrames[ftype].TalentUI = function(self)
	if not self.prdb.TalentUI or self.initialized.TalentUI then return end
	self.initialized.TalentUI = true

	local function skinBtnBBC(frame, button)

		if button
		and button.sbb
		then
			local bnObj = button.name and button.name or button.Name and button.Name or nil
			if (button.knownSelection and button.knownSelection:IsShown())
			or (frame.inspect and button.border:IsShown()) -- inspect frame
			then
				button.sbb:SetBackdropBorderColor(aObj.bbClr:GetRGBA())
				if bnObj then bnObj:SetTextColor(aObj.BT:GetRGB()) end
			else
				button.sbb:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
				if bnObj then bnObj:SetTextColor(1, 1, 1, 0.9) end
			end
			bnObj = nil
		end

	end
	aObj:SecureHook("TalentFrame_Update", function(this, ...)
		if not aObj.modBtnBs then
			aObj:Unhook("TalentFrame_Update")
			if skinBtnBBC then skinBtnBBC = nil end
			return
		end
		for tier = 1, _G.MAX_TALENT_TIERS do
			for column = 1, _G.NUM_TALENT_COLUMNS do
				skinBtnBBC(this, this["tier" .. tier]["talent" .. column])
			end
		end
	end)

	self:SecureHookScript(_G.PlayerTalentFrame, "OnShow", function(this)
		self:skinTabs{obj=this, lod=true}
		-- Dual Spec Tabs
		for i = 1, _G.MAX_TALENT_GROUPS do
			self:removeRegions(_G["PlayerSpecTab" .. i], {1}) -- N.B. other regions are icon and highlight
			if self.modBtnBs then
				 self:addButtonBorder{obj=_G["PlayerSpecTab" .. i]}
			end
		end
		if self.modBtns then
			self:skinStdButton{obj=_G.PlayerTalentFrameActivateButton}
			self:skinCloseButton{obj=_G.PlayerTalentFrameCloseButton}
		end
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true, y2=-6}

		-- handle extra abilities (Player and Pet)
		self:SecureHook("PlayerTalentFrame_CreateSpecSpellButton", function(this, index)
			this.spellsScroll.child["abilityButton" .. index].ring:SetTexture(nil)
		end)
		self:Unhook(this, "OnShow")
	end)

	local function skinAbilities(obj)
		local sc = obj.spellsScroll.child
		if aObj.modBtnBs then
			if obj.disabled then
				sc.sbb:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
			else
				sc.sbb:SetBackdropBorderColor(aObj.bbClr:GetRGBA())
			end
		end
		local btn
		for i = 1, sc:GetNumChildren() do
			btn = sc["abilityButton" .. i]
			if btn then -- Bugfix for ElvUI
				btn.ring:SetTexture(nil)
				btn.subText:SetTextColor(aObj.BT:GetRGB())
				-- make icon square
				aObj:makeIconSquare(btn, "icon", true)
			end
		end
		sc, btn = nil, nil
	end
	-- hook this as subText text colour is changed
	self:SecureHook("PlayerTalentFrame_UpdateSpecFrame", function(this, spec)
		if self.modBtnBs then
			for i = 1, _G.MAX_TALENT_TABS do
				if this["specButton" .. i].disabled then
					this["specButton" .. i].sbb:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
				else
					this["specButton" .. i].sbb:SetBackdropBorderColor(aObj.bbClr:GetRGBA())
				end
			end
		end
		skinAbilities(this)
	end)
	local function skinSpec(frame)
		aObj:removeRegions(frame, {1, 2, 3, 4, 5, 6})
		frame.MainHelpButton.Ring:SetTexture(nil)
		aObj:moveObject{obj=frame.MainHelpButton, y=-4}
        aObj:skinStdButton{obj=frame.learnButton}
		for i = 1, _G.MAX_TALENT_TABS do
			frame["specButton" .. i].bg:SetTexture(nil)
			frame["specButton" .. i].ring:SetTexture(nil)
			aObj:changeRecTex(frame["specButton" .. i].selectedTex, true)
			frame["specButton" .. i].learnedTex:SetTexture(nil)
			aObj:changeRecTex(frame["specButton" .. i]:GetHighlightTexture())
			-- make specIcon square
			aObj:makeIconSquare(frame["specButton" .. i], "specIcon", true)
		end
		-- shadow frame (LHS)
		aObj:keepFontStrings(aObj:getChild(frame, 7))
		-- spellsScroll (RHS)
		aObj:skinSlider{obj=frame.spellsScroll.ScrollBar}
		frame.spellsScroll.child.gradient:SetTexture(nil)
		aObj:removeRegions(frame.spellsScroll.child, {2, 3, 4, 5, 6, 13})
		-- make specIcon square
		aObj:makeIconSquare(frame.spellsScroll.child, "specIcon", true)
		-- abilities
		skinAbilities(frame)
	end

	self:SecureHookScript(_G.PlayerTalentFrameSpecialization, "OnShow", function(this)
		skinSpec(this)
		self:removeMagicBtnTex(this.learnButton)
		self:skinStdButton{obj=this.learnButton}
		if this.learnButton.sb then -- anim fix
			this.learnButton.sb:SetParent(this)
		end
		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.PlayerTalentFramePetSpecialization, "OnShow", function(this)
		skinSpec(this)
		self:removeMagicBtnTex(this.learnButton)
		if self.modBtns then
			self:skinStdButton{obj=this.learnButton}
			this.learnButton.sb:SetParent(this)
		end
		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.PlayerTalentFrameTalents, "OnShow", function(this)
		self:removeRegions(this, {1, 2, 3, 4, 5, 6, 7})
		this.MainHelpButton.Ring:SetTexture(nil)
		self:moveObject{obj=this.MainHelpButton, y=-4}
		-- Talent rows
		for i = 1, _G.MAX_TALENT_TIERS do
			self:removeRegions(this["tier" .. i], {1, 2 ,3, 4, 5, 6})
			for j = 1, _G.NUM_TALENT_COLUMNS do
				this["tier" .. i]["talent" .. j].Slot:SetTexture(nil)
				if self.modBtnBs then
					this["tier" .. i]["talent" .. j].knownSelection:SetAlpha(0)
					self:addButtonBorder{obj=this["tier" .. i]["talent" .. j], relTo=this["tier" .. i]["talent" .. j].icon}
				else
					this["tier" .. i]["talent" .. j].knownSelection:SetTexCoord(0.14, 0.86, 0, 1)
					this["tier" .. i]["talent" .. j].knownSelection:SetVertexColor(0, 1, 0, 1)
				end
			end
		end

		if self.modBtnBs then
			self:addButtonBorder{obj=_G.PlayerTalentFrameTalentsPvpTalentButton, ofs=0}
		end
		local frame = this.PvpTalentFrame
		frame:DisableDrawLayer("BACKGROUND")
		frame:DisableDrawLayer("OVERLAY")
		self:nilTexture(frame.Ring, true) -- warmode button ring texture
		for i = 1, #frame.Slots do
			self:nilTexture(frame.Slots[i].Border, true) -- PvP talent ring texture
			self:makeIconSquare(frame.Slots[i], "Texture", true)
			if self.modBtnBs then
				self:SecureHook(frame.Slots[i], "Update", function(this)
					 if this:IsEnabled() then
					 	this.sbb:SetBackdropBorderColor(1, 1, 1, 1) -- white border
					else
					 	this.sbb:SetBackdropBorderColor(0.498, 0.498, 0.498, 0.5) -- grey border, 50% alpha
					end
				end)
			end
		end
		frame.WarmodeIncentive.IconRing:SetTexture(nil)
		-- increase width so CloseButton doesn't appear above text
		frame.WarmodeTutorialBox:SetWidth(frame.WarmodeTutorialBox.Text:GetWidth() + 30)
		self:skinGlowBox(frame.WarmodeTutorialBox, ftype)

		self:skinSlider{obj=frame.TalentList.ScrollFrame.ScrollBar, wdth=-4}
		self:removeMagicBtnTex(self:getChild(frame.TalentList, 4))
		self:addSkinFrame{obj=frame.TalentList, ft=ftype, kfs=true, ri=true, x2=-4}
		for i = 1, #frame.TalentList.ScrollFrame.buttons do
			frame.TalentList.ScrollFrame.buttons[i]:DisableDrawLayer("BACKGROUND")
			if self.modBtnBs then
				 self:addButtonBorder{obj=frame.TalentList.ScrollFrame.buttons[i], relTo=frame.TalentList.ScrollFrame.buttons[i].Icon}
				 self:SecureHook(frame.TalentList.ScrollFrame.buttons[i], "Update", function(this)
					 if this:IsEnabled() then
					 	this.sbb:SetBackdropBorderColor(1, 1, 1, 1) -- white border
					else
					 	this.sbb:SetBackdropBorderColor(0.5, 0.5, 0.5, 1) -- grey border
					end
				 end)
			end
		end
		if self.modBtns then
			self:skinStdButton{obj=self:getChild(frame.TalentList, 4)}
		end
		self:skinGlowBox(frame.TrinketSlot.HelpBox, ftype)

		frame.UpdateModelScenes = _G.nop
		frame.OrbModelScene:Hide()
		frame.FireModelScene:Hide()
		frame = nil

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].TradeFrame = function(self)
	if not self.prdb.TradeFrame or self.initialized.TradeFrame then return end
	self.initialized.TradeFrame = true

	self:SecureHookScript(_G.TradeFrame, "OnShow", function(this)
		self:removeInset(_G.TradeRecipientItemsInset)
		self:removeInset(_G.TradeRecipientEnchantInset)
		self:removeInset(_G.TradePlayerItemsInset)
		self:removeInset(_G.TradePlayerEnchantInset)
		self:skinStdButton{obj=_G.TradeFrameTradeButton}
		self:skinStdButton{obj=_G.TradeFrameCancelButton}
		self:removeInset(_G.TradePlayerInputMoneyInset)
		self:skinMoneyFrame{obj=_G.TradePlayerInputMoneyFrame, moveSEB=true}
		self:removeInset(_G.TradeRecipientMoneyInset)
		_G.TradeRecipientMoneyBg:DisableDrawLayer("BACKGROUND")

		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true, nb=true}

		if self.modUIBtns then
			for i = 1, _G.MAX_TRADE_ITEMS do
				for _, type in pairs{"Player", "Recipient"} do
					_G["Trade" .. type .. "Item" .. i .. "SlotTexture"]:SetTexture(nil)
					_G["Trade" .. type .. "Item" .. i .. "NameFrame"]:SetTexture(nil)
					self:addButtonBorder{obj=_G["Trade" .. type .. "Item" .. i .. "ItemButton"], ibt=true}
				end
			end
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzLoDFrames[ftype].TradeSkillUI = function(self)
	if not self.prdb.TradeSkillUI or self.initialized.TradeSkillUI then return end
	self.initialized.TradeSkillUI = true

	self:SecureHookScript(_G.TradeSkillFrame, "OnShow", function(this)
		self:removeInset(this.RecipeInset)
		self:removeInset(this.DetailsInset)
		self:skinStatusBar{obj=this.RankFrame, fi=0, bgTex=this.RankFrameBackground}
		self:removeRegions(this.RankFrame, {2, 3, 4})
		self:skinEditBox{obj=this.SearchBox, regs={6, 7}, mi=true} -- 6 is text, 7 is icon
		self:addSkinFrame{obj=this, ft=ftype, kfs=true}
		if self.modBtns then
			 self:skinStdButton{obj=this.FilterButton}
		end
		if self.modBtnBs then
			 self:addButtonBorder{obj=this.LinkToButton, x1=1, y1=-5, x2=-2, y2=2}
		end

		-- RecipeList
		local function skinTabs(frame)

			local tab
			for i = 1, frame.numTabs do
				tab = frame.Tabs[i]
				tab:DisableDrawLayer("BACKGROUND")
				aObj:addSkinFrame{obj=tab, ft=ftype, noBdr=aObj.isTT, x1=2, y1=-4, x2=2, y2=-4}
				tab.sf.up = true
				if i == 1 then
					if aObj.isTT then aObj:setActiveTab(tab.sf) end
				else
					if aObj.isTT then aObj:setInactiveTab(tab.sf) end
				end
			end
			tab = nil

		end
		if self.isTT then
			local function changeTabTex(frame)
				for i = 1, frame.numTabs do
					if i == frame.selectedTab then
						self:setActiveTab(frame.Tabs[i].sf)
					else
						self:setInactiveTab(frame.Tabs[i].sf)
					end
				end
			end
			self:SecureHook(_G.TradeSkillFrame.RecipeList, "OnLearnedTabClicked", function(this)
				changeTabTex(this)
			end)
			self:SecureHook(_G.TradeSkillFrame.RecipeList, "OnUnlearnedTabClicked", function(this)
				changeTabTex(this)
			end)
		end
		skinTabs(this.RecipeList)
		self:skinSlider{obj=self:getChild(this.RecipeList, 4), wdth=-4, size=3} -- unamed slider object
		self:addSkinFrame{obj=this.RecipeList, ft=ftype, kfs=true, nb=true, aso={bd=10, ng=true}, ofs=8, y1=6, x2=24}

		for i = 1, #this.RecipeList.buttons do
			if self.modBtns then
				 self:skinExpandButton{obj=this.RecipeList.buttons[i], onSB=true, noHook=true}
			end
			this.RecipeList.buttons[i].SubSkillRankBar.BorderLeft:SetTexture(nil)
			this.RecipeList.buttons[i].SubSkillRankBar.BorderRight:SetTexture(nil)
			this.RecipeList.buttons[i].SubSkillRankBar.BorderMid:SetTexture(nil)
			self:skinStatusBar{obj=this.RecipeList.buttons[i].SubSkillRankBar, fi=0}
		end
		if self.modBtns then
			local function checkTex(btn)
				if not btn.isHeader then btn.sb:Hide()
				else
					if btn.tradeSkillInfo.collapsed then
						btn.sb:SetText("+")
					else
						btn.sb:SetText("-")
					end
					btn.sb:Show()
				end
			end
			self:SecureHook(this.RecipeList, "RefreshDisplay", function(this)
				for i = 1, #this.buttons do
					checkTex(this.buttons[i])
				end
			end)
			self:SecureHook(this.RecipeList, "update", function(this)
				for i = 1, #this.buttons do
					checkTex(this.buttons[i])
				end
			end)
		end

		-- DetailsFrame
		this.DetailsFrame.Background:SetAlpha(0)
		self:skinSlider{obj=this.DetailsFrame.ScrollBar, wdth=-4, size=3}
		self:removeMagicBtnTex(this.DetailsFrame.CreateAllButton)
		self:removeMagicBtnTex(this.DetailsFrame.ViewGuildCraftersButton)
		self:removeMagicBtnTex(this.DetailsFrame.ExitButton)
		self:removeMagicBtnTex(this.DetailsFrame.CreateButton)
		self:skinEditBox{obj=this.DetailsFrame.CreateMultipleInputBox, noHeight=true, nis=true}
		this.DetailsFrame.Contents.ResultIcon.ResultBorder:SetTexture(nil)
		local btn
		for i = 1, #this.DetailsFrame.Contents.Reagents do
			btn = this.DetailsFrame.Contents.Reagents[i]
			btn.NameFrame:SetTexture(nil)
			if self.modBtnBs then
				 self:addButtonBorder{obj=btn, relTo=btn.Icon, reParent={btn.Count}}
				 -- BAG_ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_COMMON]
				 btn.sbb:SetBackdropBorderColor(0.65882, 0.65882, 0.65882) -- reagents are COMMON quality
			end
		end
		btn = nil

		if self.modBtns then
			self:skinStdButton{obj=this.DetailsFrame.CreateAllButton}
			self:skinStdButton{obj=this.DetailsFrame.ViewGuildCraftersButton}
			self:skinStdButton{obj=this.DetailsFrame.ExitButton}
			self:skinStdButton{obj=this.DetailsFrame.CreateButton}
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=this.DetailsFrame.Contents.ResultIcon, reParent={this.DetailsFrame.Contents.ResultIcon.Count}}
		end

		-- Guild Crafters
		self:SecureHookScript(this.DetailsFrame.GuildFrame, "OnShow", function(this)
			self:skinSlider{obj=this.Container.ScrollFrame.scrollBar, wdth=-4}
			self:addSkinFrame{obj=this.Container, ft=ftype, ofs=2, x2=-2}
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, ofs=-7}
			self:Unhook(this, "OnShow")
		end)

		-- send message when UI is skinned (used by oGlow skin)
		self:SendMessage("TradeSkillUIUI_Skinned", self)

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].WardrobeOutfits = function(self)

	self:SecureHookScript(_G.WardrobeOutfitFrame, "OnShow", function(this)
		self:removeNineSlice(this.Border)
		self:addSkinFrame{obj=this, ft=ftype, nb=true}

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.WardrobeOutfitEditFrame, "OnShow", function(this)
		self:removeNineSlice(this.Border)
		self:skinEditBox{obj=this.EditBox, regs={6}} -- 6 is text
		if self.modBtns then
			self:skinStdButton{obj=this.AcceptButton}
			self:skinStdButton{obj=this.CancelButton}
			self:skinStdButton{obj=this.DeleteButton}
		end
		self:addSkinFrame{obj=this, ft=ftype, kfs=true}

		self:Unhook(this, "OnShow")
	end)

end
