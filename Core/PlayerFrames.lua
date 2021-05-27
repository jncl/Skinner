local aName, aObj = ...

local _G = _G

local ftype = "p"

aObj.blizzLoDFrames[ftype].AchievementUI = function(self)
	if not self.prdb.AchievementUI.skin or self.initialized.AchievementUI then return end
	self.initialized.AchievementUI = true

	-- handle Overachiever hijacking OnShow script first time through
	if _G.IsAddOnLoaded("Overachiever") then
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
			for _, btn in _G.pairs(_G.AchievementFrameCategoriesContainer.buttons) do
				btn.background:SetAlpha(0)
			end
		end
		local function skinComparisonStats()
			for _, btn in _G.pairs(_G.AchievementFrameComparisonStatsContainer.button) do
				if btn.isHeader then
					btn.background:SetAlpha(0)
				end
				btn.left:SetAlpha(0)
				btn.left2:SetAlpha(0)
				btn.middle:SetAlpha(0)
				btn.middle2:SetAlpha(0)
				btn.right:SetAlpha(0)
				btn.right2:SetAlpha(0)
			end
		end
		local function skinBtn(btn)
			btn:DisableDrawLayer("BACKGROUND")
			btn:DisableDrawLayer("BORDER")
			btn:DisableDrawLayer("ARTWORK")
			if btn.hiddenDescription then
				btn.hiddenDescription:SetTextColor(aObj.BT:GetRGB())
			end
			aObj:nilTexture(btn.icon.frame, true)
			aObj:secureHook(btn, "Desaturate", function(this)
				if this.sbb then
					this.sbb:SetBackdropBorderColor(this:GetBackdropBorderColor())
					this.icon.sbb:SetBackdropBorderColor(this:GetBackdropBorderColor())
				end
			end)
			aObj:secureHook(btn, "Saturate", function(this)
				if this.sbb then
					this.sbb:SetBackdropBorderColor(this:GetBackdropBorderColor())
					this.icon.sbb:SetBackdropBorderColor(this:GetBackdropBorderColor())
				end
				if this.description then
					this.description:SetTextColor(aObj.BT:GetRGB())
				end
			end)
			-- if aObj.modBtns then
				-- TODO: PlusMinus is really a texture NOT a button
				-- aObj:SecureHook("AchievementButton_UpdatePlusMinusTexture", function(btn)
					-- if not btn.id then return end
					-- if btn:IsShown() then
						-- btn.collapsed
						-- btn.saturatedStyle
						-- check for both, one of each and none to determine colour
						-- testure used is: Interface\AchievementFrame\UI-Achievement-PlusMinus
					-- end
				-- end)
			-- end
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=btn.icon, relTo=btn.texture, x1=4, y1=-1, x2=-4, y2=6}
				aObj:addButtonBorder{obj=btn, ofs=0}
			end
			if aObj.modChkBtns
			and btn.tracked
			then
				aObj:skinCheckButton{obj=btn.tracked, fType=ftype}
			end
		end
		local function cleanButtons(frame, type)
			if aObj.prdb.AchievementUI.style == 1 then return end -- don't remove textures if option not chosen
			-- remove textures etc from buttons
			local btnName
			for _, btn in _G.pairs(frame.buttons) do
				btnName = btn:GetName() .. (type == "Comparison" and "Player" or "")
				skinBtn(_G[btnName])
				if type == "Achievements" then
					-- set textures to nil and prevent them from being changed as guildview changes the textures
					-- self:nilTexture(_G[btnName .. "TopTsunami1"], true)
					-- self:nilTexture(_G[btnName .. "BottomTsunami1"], true)
				elseif type == "Summary" then
					if not _G[btnName].tooltipTitle then
						_G[btnName]:Saturate()
					end
				elseif type == "Comparison" then
					-- force update to colour the Player button
					if _G[btnName].completed then
						_G[btnName]:Saturate()
					end
					-- Friend
					btn = _G[btnName:gsub("Player", "Friend")]
					skinBtn(btn)
					-- force update to colour the Friend button
					if btn.completed then
						btn:Saturate()
					end
				end
			end
			btnName = nil
		end
		self:keepFontStrings(_G.AchievementFrameHeader)
		self:moveObject{obj=_G.AchievementFrameHeaderTitle, x=-60, y=-25}
		self:moveObject{obj=_G.AchievementFrameHeaderPoints, x=40, y=-5}
		_G.AchievementFrameHeaderShield:SetAlpha(1)

		self:skinObject("frame", {obj=_G.AchievementFrameCategories, fType=ftype, kfs=true, fb=true, y1=0})
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
		self:getChild(_G.AchievementFrameAchievements, 2):ClearBackdrop()
		self:skinObject("frame", {obj=_G.AchievementFrameAchievements, fType=ftype, kfs=true, fb=true, y2=-2})
		self:skinObject("slider", {obj=_G.AchievementFrameAchievementsContainerScrollBar, fType=ftype})
		if self.prdb.AchievementUI.style == 2 then
			-- remove textures etc from buttons
			cleanButtons(_G.AchievementFrameAchievementsContainer, "Achievements")
			-- hook this to handle objectives text colour changes
			self:SecureHookScript(_G.AchievementFrameAchievementsObjectives, "OnShow", function(this)
				if this.completed then
					for _, child in _G.ipairs{this:GetChildren()} do
						for _, reg in _G.ipairs{child:GetChildren()} do
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
				if self.modBtnBs then
					self:addButtonBorder{obj=obj, es=12, relTo=obj.icon}
				end
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
		self:SecureHook("AchievementObjectives_DisplayCriteria", function(objectivesFrame, _)
			for _, child in _G.ipairs{objectivesFrame:GetChildren()} do
				if child.shield then -- miniAchievement
					-- do nothing
				elseif child.label then -- metaCriteria
					if _G.select(2, child.label:GetTextColor()) == 0 then -- completed criteria
						child.label:SetTextColor(_G.HIGHLIGHT_FONT_COLOR:GetRGB())
					end
				elseif child.name then -- criteria
					if _G.select(2, child.name:GetTextColor()) == 0 then -- completed criteria
						child.name:SetTextColor(_G.HIGHLIGHT_FONT_COLOR:GetRGB())
					end
				end
				if child.sbb then
					self:clrBtnBdr(child.sbb, not child.check:IsShown() and "disabled")
				end
			end
		end)

		self:skinObject("slider", {obj=_G.AchievementFrameStatsContainerScrollBar, fType=ftype})
		_G.AchievementFrameStatsBG:SetAlpha(0)
		self:getChild(_G.AchievementFrameStats, 3):ClearBackdrop()
		self:skinObject("frame", {obj=_G.AchievementFrameStats, fType=ftype, kfs=true, fb=true, y1=0, y2=-2})
		-- hook this to skin buttons
		self:SecureHook("AchievementFrameStats_Update", function()
			skinStats()
		end)
		skinStats()
		self:keepFontStrings(_G.AchievementFrameSummary)
		_G.AchievementFrameSummaryBackground:SetAlpha(0)
		_G.AchievementFrameSummaryAchievementsEmptyText:SetText() -- remove 'No recently completed Achievements' text
		_G.AchievementFrameSummaryAchievementsHeaderHeader:SetAlpha(0)
		self:skinObject("slider", {obj=_G.AchievementFrameAchievementsContainerScrollBar, fType=ftype})
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
		self:getChild(_G.AchievementFrameSummary, 1):ClearBackdrop()
		self:skinObject("frame", {obj=_G.AchievementFrameSummary, fType=ftype, kfs=true, fb=true, y1=-1, y2=-2})
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
		self:skinObject("slider", {obj=_G.AchievementFrameComparisonContainerScrollBar, fType=ftype})
		-- Summary Panel
		self:getChild(_G.AchievementFrameComparison, 5):ClearBackdrop()
		self:skinObject("frame", {obj=_G.AchievementFrameComparison, fType=ftype, kfs=true, fb=true, y1=0, y2=-2})
		for _, type in _G.pairs{"Player", "Friend"} do
			_G["AchievementFrameComparisonSummary" .. type]:ClearBackdrop()
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
		self:skinObject("slider", {obj=_G.AchievementFrameComparisonStatsContainerScrollBar, fType=ftype})
		self:SecureHook("AchievementFrameComparison_UpdateStats", function()
			skinComparisonStats()
		end)
		self:SecureHook(_G.AchievementFrameComparisonStatsContainer, "Show", function()
			skinComparisonStats()
		end)
		self:moveObject{obj=_G.AchievementFrameCloseButton, y=6}
		-- this is not a standard dropdown
		self:moveObject{obj=_G.AchievementFrameFilterDropDown, y=-7}
		-- skin the dropdown frame
		if self.prdb.TexturedDD then
			local tex = _G.AchievementFrameFilterDropDown:CreateTexture(nil, "BORDER")
			tex:SetTexture(self.itTex)
			tex:SetSize(110, 19)
			tex:SetPoint("RIGHT", _G.AchievementFrameFilterDropDown, "RIGHT", -3, 4)
			tex = nil
			self:addSkinFrame{obj=_G.AchievementFrameFilterDropDown, ft=ftype, aso={ng=true}, x1=-7, y1=1, x2=1, y2=7}
			if self.modBtnBs then
			    self:addButtonBorder{obj=_G.AchievementFrameFilterDropDownButton, es=12, ofs=-2, x1=_G.IsAddOnLoaded("Overachiever") and 102 or 1}
			end
		end
		-- Search function
		self:skinObject("editbox", {obj=this.searchBox, fType=ftype, ofs=-2, si=true, six=5})
		self:moveObject{obj=this.searchBox, y=-8}
		local spc = this.searchPreviewContainer
		self:adjHeight{obj=spc, adj=((4 * 27) + 30)}
		self:skinObject("frame", {obj=spc, fType=ftype, kfs=true, y1=4, y2=2})
		_G.LowerFrameLevel(spc.sf)
		for i = 1, 5 do
			spc["searchPreview" .. i]:SetNormalTexture(nil)
			spc["searchPreview" .. i]:SetPushedTexture(nil)
			spc["searchPreview" .. i].iconFrame:SetTexture(nil)
			if self.modBtnBs then
				self:addButtonBorder{obj=spc["searchPreview" .. i], relTo=spc["searchPreview" .. i].icon}
			end
		end
		spc.showAllSearchResults:SetNormalTexture(nil)
		spc.showAllSearchResults:SetPushedTexture(nil)
		spc = nil
		self:skinStatusBar{obj=this.searchProgressBar, fi=0, bgTex=this.searchProgressBar.bg}
		self:skinObject("slider", {obj=this.searchResults.scrollFrame.scrollBar, fType=ftype})
		self:skinObject("frame", {obj=this.searchResults, fType=ftype, kfs=true, cb=true, x1=-8, y1=-1, x2=1})
		for i = 1, #this.searchResults.scrollFrame.buttons do
			this.searchResults.scrollFrame.buttons[i]:SetNormalTexture(nil)
			this.searchResults.scrollFrame.buttons[i]:SetPushedTexture(nil)
			this.searchResults.scrollFrame.buttons[i].iconFrame:SetTexture(nil)
			if self.modBtnBs then
				self:addButtonBorder{obj=this.searchResults.scrollFrame.buttons[i], relTo=this.searchResults.scrollFrame.buttons[i].icon}
			end
		end
		self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true, ignoreHLTex=false, regions={7, 8, 9, 10}, offsets={x1=11, y1=self.isTT and 2 or -2, x2=-12, y2=-7}})
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, y1=7, x2=0, y2=-2})

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
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true, x1=30, x2=2.5}

		self:keepFontStrings(this.summaryPage) -- remove title textures
		_G.ArchaeologyFrameSummaryPageTitle:SetTextColor(self.HT:GetRGB())
		for i = 1, _G.ARCHAEOLOGY_MAX_RACES do
			this.summaryPage["race" .. i].raceName:SetTextColor(self.BT:GetRGB())
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=this.summaryPage.prevPageButton, ofs=0, clr="disabled"}
			self:addButtonBorder{obj=this.summaryPage.nextPageButton, ofs=0, clr="disabled"}
		end
		self:SecureHook(this.summaryPage, "UpdateFrame", function(this)
			self:clrPNBtns(this:GetName())
		end)

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
			if self.modBtnBs then
				self:addButtonBorder{obj=this.completedPage["artifact" .. i], relTo=this.completedPage["artifact" .. i].icon}
			end
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=this.completedPage.prevPageButton, ofs=0, clr="disabled"}
			self:addButtonBorder{obj=this.completedPage.nextPageButton, ofs=0, clr="disabled"}
		end
		self:SecureHook(this.completedPage, "UpdateFrame", function(this)
			self:clrPNBtns(this:GetName())
		end)

		self:removeRegions(this.artifactPage, {2, 3, 7, 9}) -- title textures, backgrounds
		if self.modBtns then
			self:skinStdButton{obj=this.artifactPage.backButton}
			self:skinStdButton{obj=this.artifactPage.solveFrame.solveButton}
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=this.artifactPage, relTo=this.artifactPage.icon, ofs=1}
		end
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

-- N.B. ArenaUI managed in UnitFrames module

aObj.blizzLoDFrames[ftype].ArtifactUI = function(self)
	if not self.prdb.ArtifactUI or self.initialized.ArtifactUI then return end
	self.initialized.ArtifactUI = true

	self:SecureHookScript(_G.ArtifactFrame, "OnShow", function(this)
		self:keepFontStrings(this.BorderFrame)
		this.ForgeBadgeFrame:DisableDrawLayer("OVERLAY") -- this hides the frame
		this.ForgeBadgeFrame.ForgeLevelLabel:SetDrawLayer("ARTWORK") -- this shows the artifact level
		self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true, offsets={x1=8, y1=self.isTT and 7 or 2, x2=-8, y2=2}})
		self:skinObject("frame", {obj=this, fType=ftype, cb=true, ofs=5, y1=4, y2=-6})
		-- Perks
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
					aObj:changeTandC(this.PerksTab.PowerButtons[i].RankBorder)
					aObj:changeTandC(this.PerksTab.PowerButtons[i].RankBorderFinal)
				end
			end
		end
		skinPowerBtns()
		-- hook this to skin new buttons
		self:SecureHook(this.PerksTab, "RefreshPowers", function(this, _)
			skinPowerBtns()
		end)
		-- Appearances
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
		for i, slot in _G.ipairs(this.Slots) do
			-- print("Slot", i, slot)
			for j, stateFrame in _G.ipairs(slot.StateFrames) do
				-- print("StateFrames", j, stateFrame, stateFrame:GetNumRegions())
				if i == 1 then -- Major Milestone
					stateFrame.Glow:SetAlpha(0)
					stateFrame.Shadow:SetAlpha(0)
					stateFrame.Ring:SetAlpha(0)
					stateFrame.HighlightRing:SetAlpha(0)
				elseif j == 1
				and stateFrame:GetNumRegions() == 7
				then -- Minor Milestone
					stateFrame.Ring:SetAlpha(0)
					stateFrame.HighlightRing:SetAlpha(0)
				end
			end
		end
		-- RHS
		self:removeInset(this.RightInset)
		self:skinSlider{obj=this.EssenceList.ScrollBar, size=2}
		if self.modBtnBs then
			local function clrBB(sf)
				for _, btn in _G.ipairs(sf.buttons) do
					btn.sbb:SetBackdropBorderColor(btn.Name:GetTextColor())
				end
			end
			-- self:skinStdButton{obj=this.ScrollFrame.HeaderButton}
			for _, btn in _G.ipairs(this.EssenceList.buttons) do
				self:nilTexture(btn.Background, true)
				self:addButtonBorder{obj=btn, relTo=btn.Icon, reParent={btn.IconCover, btn.Glow, btn.Glow2, btn.Glow3}, clr="grey"}
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

	AEIUI = nil

end

aObj.blizzFrames[ftype].Buffs = function(self)
	if not self.prdb.Buffs or self.initialized.Buffs then return end
	self.initialized.Buffs = true

	if self.modBtnBs then
		local function skinBuffBtn(btn)
			if btn
			and not btn.sbb
			then
				aObj:addButtonBorder{obj=btn, reParent={btn.count, btn.duration}, ofs=3, clr="grey"}
			end
		end
		-- skin current Buffs
		local btn
		for i = 1, _G.BUFF_MAX_DISPLAY do
			skinBuffBtn(_G["BuffButton" .. i])
		end
		btn = nil
		-- if not all buff buttons created yet
		if not _G.BuffButton32 then
			-- hook this to skin new Buffs
			self:SecureHook("AuraButton_Update", function(buttonName, index, _)
				-- aObj:Debug("AuraButton_Update: [%s, %s, %s]", buttonName, index, filter)
				if buttonName == "BuffButton" then
					skinBuffBtn(_G[buttonName .. index])
				end
			end)
		end
	end

	-- Debuffs already have a coloured border
	-- Temp Enchants already have a coloured border

end

aObj.blizzFrames[ftype].CastingBar = function(self)
	if not self.prdb.CastingBar.skin or self.initialized.CastingBar then return end
	self.initialized.CastingBar = true

	if _G.IsAddOnLoaded("Quartz")
	or _G.IsAddOnLoaded("Dominos_Cast")
	then
		self.blizzFrames[ftype].CastingBar = nil
		return
	end

	for _, type in _G.pairs{"", "Pet"} do
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

	self:SecureHookScript(_G.CharacterFrame, "OnShow", function(this)
		self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true, offsets={x1=8, y1=self.isTT and 2 or -3, x2=-8, y2=2}})
		self:removeInset(this.InsetRight)
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true, x2=3})

		self:Unhook(this, "OnShow")
	end)

	-- other adddons reparent this (e.g. DejaCharacterStats)
	self:SecureHookScript(_G.CharacterStatsPane, "OnShow", function(this)
		this.ClassBackground:SetTexture(nil)
		this.ItemLevelFrame.Background:SetTexture(nil)
		this.ItemLevelCategory:DisableDrawLayer("BACKGROUND")
		this.AttributesCategory:DisableDrawLayer("BACKGROUND")
		this.EnhancementsCategory:DisableDrawLayer("BACKGROUND")
		self:SecureHook("PaperDollFrame_UpdateStats", function()
			for statLine in _G.CharacterStatsPane.statsFramePool:EnumerateActive() do
				statLine:DisableDrawLayer("BACKGROUND")
			end
		end)
		_G.PaperDollFrame_UpdateStats()

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.PaperDollFrame, "OnShow", function(this)
		_G.PaperDollSidebarTabs.DecorLeft:SetAlpha(0)
		_G.PaperDollSidebarTabs.DecorRight:SetAlpha(0)
		for i = 1, #_G.PAPERDOLL_SIDEBARS do
			_G["PaperDollSidebarTab" .. i].TabBg:SetAlpha(0)
			_G["PaperDollSidebarTab" .. i].Hider:SetAlpha(0)
			-- use a button border to indicate the active tab
			self.modUIBtns:addButtonBorder{obj=_G["PaperDollSidebarTab" .. i], relTo=_G["PaperDollSidebarTab" .. i].Icon, ofs=i==1 and 3 or 1, clr="selected"} -- use module function here to force creation
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
			for _, btn in _G.pairs(this.buttons) do
				btn:DisableDrawLayer("BACKGROUND")
				if self.modBtnBs then
					self:addButtonBorder{obj=btn, relTo=btn.icon}
				end
			end
			if self.modBtns then
				self:skinStdButton{obj=this.EquipSet}
				self:skinStdButton{obj=this.SaveSet}
				self:SecureHook("PaperDollEquipmentManagerPane_Update", function()
					self:clrBtnBdr(_G.PaperDollEquipmentManagerPane.EquipSet)
					self:clrBtnBdr(_G.PaperDollEquipmentManagerPane.SaveSet)
				end)
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
				aObj:addButtonBorder{obj=btn, ibt=true, reParent={btn.ignoreTexture}, clr="grey"}
				-- force quality border update
				_G.PaperDollItemSlotButton_Update(btn)
				-- RankFrame
				aObj:changeTandC(btn.RankFrame.Texture)
				btn.RankFrame.Texture:SetSize(20, 20)
				btn.RankFrame.Label:ClearAllPoints()
				btn.RankFrame.Label:SetPoint("CENTER", btn.RankFrame.Texture)
			end
		end
		if self.modBtnBs then
			self:SecureHook("PaperDollItemSlotButton_Update", function(btn)
				if not _G.GetInventoryItemTexture("player", btn:GetID()) then
					self:clrBtnBdr(btn, "grey")
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

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.GearManagerDialogPopup, "OnShow", function(this)
		self:adjHeight{obj=_G.GearManagerDialogPopupScrollFrame, adj=20}
		self:skinObject("slider", {obj=_G.GearManagerDialogPopupScrollFrame.ScrollBar, fType=ftype, rpTex="background"})
		self:removeRegions(this.BorderBox, {1, 2, 3, 4, 5, 6, 7, 8})
		self:adjHeight{obj=this, adj=20}
		for i = 1, #this.buttons do
			this.buttons[i]:DisableDrawLayer("BACKGROUND")
			if self.modBtnBs then
				self:addButtonBorder{obj=this.buttons[i]}
			end
		end
		self:skinObject("editbox", {obj=_G.GearManagerDialogPopupEditBox, fType=ftype})
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, x1=4, y1=-2, x2=-1, y2=3})
		if self.modBtns then
			self:skinStdButton{obj=_G.GearManagerDialogPopupCancel}
			self:skinStdButton{obj=_G.GearManagerDialogPopupOkay}
			self:SecureHook("GearManagerDialogPopupOkay_Update", function()
				self:clrBtnBdr(_G.GearManagerDialogPopupOkay)
			end)
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.ReputationFrame, "OnShow", function(this)
		self:keepFontStrings(this)
		for i = 1, _G.NUM_FACTIONS_DISPLAYED do
			self:skinStatusBar{obj=_G["ReputationBar" .. i .. "ReputationBar"], fi=0}
			_G["ReputationBar" .. i .. "Background"]:SetAlpha(0)
			_G["ReputationBar" .. i .. "ReputationBarLeftTexture"]:SetAlpha(0)
			_G["ReputationBar" .. i .. "ReputationBarRightTexture"]:SetAlpha(0)
			if self.modBtns then
				self:skinExpandButton{obj=_G["ReputationBar" .. i .. "ExpandOrCollapseButton"], onSB=true}
				self:checkTex(_G["ReputationBar" .. i .. "ExpandOrCollapseButton"])
			end
		end
		self:skinObject("slider", {obj=_G.ReputationListScrollFrame.ScrollBar, fType=ftype, rpTex="background"})
		-- ReputationDetailFrame
		self:removeNineSlice(_G.ReputationDetailFrame.Border)
		self:skinObject("frame", {obj=_G.ReputationDetailFrame, fType=ftype, kfs=true, ofs=-6})
		if self.modBtns then
			self:skinCloseButton{obj=_G.ReputationDetailCloseButton}
			-- hook to manage changes to button textures
			self:SecureHook("ReputationFrame_Update", function()
				for i = 1, _G.NUM_FACTIONS_DISPLAYED do
					self:checkTex(_G["ReputationBar" .. i .. "ExpandOrCollapseButton"])
				end
			end)
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.ReputationDetailAtWarCheckBox}
			self:skinCheckButton{obj=_G.ReputationDetailInactiveCheckBox}
			self:skinCheckButton{obj=_G.ReputationDetailMainScreenCheckBox}
		end

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.ReputationFrame)

	 -- Currency Tab
	self:SecureHookScript(_G.TokenFrame, "OnShow", function(this)
		self:keepFontStrings(this)
		self:skinObject("slider", {obj=_G.TokenFrameContainerScrollBar, fType=ftype})
		-- remove background & header textures
		for i = 1, #_G.TokenFrameContainer.buttons do
			self:removeRegions(_G.TokenFrameContainer.buttons[i], {1, 6, 7, 8})
		end
		-- TokenFramePopup
		_G.TokenFramePopup.Border:DisableDrawLayer("BACKGROUND")
		self:skinObject("frame", {obj=_G.TokenFramePopup, fType=ftype, kfs=true, cb=true, ofs=-6, x1=0})
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.TokenFramePopupInactiveCheckBox}
			self:skinCheckButton{obj=_G.TokenFramePopupBackpackCheckBox}
		end

		self:Unhook(_G.TokenFrame, "OnShow")
	end)

end

aObj.blizzLoDFrames[ftype].Collections = function(self)
	if not self.prdb.Collections or self.initialized.Collections then return end
	self.initialized.Collections = true

	self:SecureHookScript(_G.CollectionsJournal, "OnShow", function(this)
		self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true, selectedTab=this.selectedTab, offsets={x1=9, y1=self.isTT and 3 or -2, x2=-9, y2=2}})
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, rns=true, cb=true, x2=3, y2=-1})

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.MountJournal, "OnShow", function(this)
		local function updBtnClr(btn)
			-- aObj:Debug("updBtnClr: [%s, %s, %s, %s, %s]", btn.name:GetText(), btn.icon:GetAlpha(), btn.icon:GetVertexColor())
			local r, g, b = btn.icon:GetVertexColor()
			btn.sbb:SetBackdropBorderColor(r, g, b, btn.icon:GetAlpha())
			r, g, b = nil, nil, nil
		end
		self:removeInset(this.LeftInset)
		self:removeInset(this.BottomLeftInset)
		self:removeRegions(this.SlotButton, {1, 3})
		self:removeInset(this.RightInset)
		self:skinObject("editbox", {obj=this.searchBox, fType=ftype, si=true})
		self:removeInset(this.MountCount)
		self:keepFontStrings(this.MountDisplay)
		self:keepFontStrings(this.MountDisplay.ShadowOverlay)
		self:skinObject("slider", {obj=this.ListScrollFrame.scrollBar, fType=ftype})
		for _, btn in _G.pairs(this.ListScrollFrame.buttons) do
			btn:DisableDrawLayer("BACKGROUND")
			if self.modBtnBs then
				self:addButtonBorder{obj=btn, relTo=btn.icon, reParent={btn.favorite}}
				updBtnClr(btn)
			end
		end
		self:removeMagicBtnTex(this.MountButton)
		if self.modBtns then
			self:skinStdButton{obj=this.BottomLeftInset.SuppressedMountEquipmentButton}
			self:skinStdButton{obj=_G.MountJournalFilterButton}
			self:skinStdButton{obj=this.MountButton}
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=this.SlotButton, relTo=this.SlotButton.ItemIcon, reParent={this.SlotButton.SlotBorder, this.SlotButton.SlotBorderOpen}, clr="grey", ca=0.85}
			self:addButtonBorder{obj=this.SummonRandomFavoriteButton, ofs=3}
			self:addButtonBorder{obj=this.MountDisplay.InfoButton, relTo=this.MountDisplay.InfoButton.Icon, clr="white"}
			self:addButtonBorder{obj=this.MountDisplay.ModelScene.RotateLeftButton, ofs=-3, clr="grey"}
			self:addButtonBorder{obj=this.MountDisplay.ModelScene.RotateRightButton, ofs=-3, clr="grey"}
			self:SecureHook(this.ListScrollFrame, "update", function(this)
				for _, btn in _G.pairs(this.buttons) do
					updBtnClr(btn)
				end
			end)
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=this.MountDisplay.ModelScene.TogglePlayer}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.PetJournal, "OnShow", function(this)
		self:removeInset(this.PetCount)
		this.MainHelpButton.Ring:SetTexture(nil)
		self:moveObject{obj=this.MainHelpButton, y=-4}
		_G.PetJournalHealPetButtonBorder:SetTexture(nil)
		if self.modBtnBs then
			self:addButtonBorder{obj=this.HealPetButton, sec=true, clr="grey", ca=1}
			self:addButtonBorder{obj=this.SummonRandomFavoritePetButton, ofs=3, clr="grey", ca=1}
			self:SecureHook(this.listScroll, "update", function(this)
				for i = 1, #this.buttons do
					self:clrButtonFromBorder(this.buttons[i])
				end
			end)
		end
		self:removeInset(this.LeftInset)
		self:removeInset(this.PetCardInset)
		self:removeInset(this.RightInset)
		self:skinObject("editbox", {obj=this.searchBox, fType=ftype, si=true})
		if self.modBtns then
			 self:skinStdButton{obj=_G.PetJournalFilterButton}
		end
		-- PetList
		self:skinObject("slider", {obj=this.listScroll.scrollBar, fType=ftype, y1=-2, y2=2})
		for _, btn in _G.pairs(this.listScroll.buttons) do
			self:removeRegions(btn, {1, 4}) -- background, iconBorder
			self:changeTandC(btn.dragButton.levelBG)
			if self.modBtnBs then
				self:addButtonBorder{obj=btn, relTo=btn.icon, reParent={btn.dragButton.levelBG, btn.dragButton.level, btn.dragButton.favorite}}
			end
		end
		if self.modBtnBs then
			self:SecureHook("PetJournal_UpdatePetList", function()
				for _, btn in _G.pairs(_G.PetJournal.listScroll.buttons) do
					self:clrButtonFromBorder(btn, "iconBorder")
				end
			end)
		end
		self:keepFontStrings(this.loadoutBorder)
		self:moveObject{obj=this.loadoutBorder, y=8} -- battle pet slots title
		-- Pet LoadOut Plates
		local lop
		for i = 1, 3 do
			lop = this.Loadout["Pet" .. i]
			self:removeRegions(lop, {1, 2, 5})
			-- use module function here to force creation
	        self.modUIBtns:addButtonBorder{obj=lop, relTo=lop.icon, reParent={lop.levelBG, lop.level, lop.favorite}, clr="disabled"}
			self:changeTandC(lop.levelBG)
			self:keepFontStrings(lop.helpFrame)
			lop.healthFrame.healthBar:DisableDrawLayer("OVERLAY")
			self:skinStatusBar{obj=lop.healthFrame.healthBar, fi=0}
			self:keepRegions(lop.xpBar, {1, 12})
			self:skinStatusBar{obj=lop.xpBar, fi=0}
			self:skinObject("frame", {obj=lop, fType=ftype, fb=true, x1=-4, y1=0, y2=-4})
			for j = 1, 3 do
				self:removeRegions(lop["spell" .. j], {1, 3}) -- background, blackcover
				if self.modBtnBs then
					self:addButtonBorder{obj=lop["spell" .. j], relTo=lop["spell" .. j].icon, reParent={lop["spell" .. j].FlyoutArrow}, clr="disabled"}
				end
			end
		end
		lop = nil
		-- PetCard
		local pc = this.PetCard
		self:changeTandC(pc.PetInfo.levelBG)
		pc.PetInfo.qualityBorder:SetAlpha(0)
		if self.modBtnBs then
			self:addButtonBorder{obj=pc.PetInfo, relTo=pc.PetInfo.icon, reParent={pc.PetInfo.levelBG, pc.PetInfo.level, pc.PetInfo.favorite}}
		end
		self:removeRegions(pc.HealthFrame.healthBar, {1, 2, 3})
		self:skinStatusBar{obj=pc.HealthFrame.healthBar, fi=0}
		self:keepRegions(pc.xpBar, {1, 12}) -- text & background
		self:skinStatusBar{obj=pc.xpBar, fi=0}
		self:keepFontStrings(pc)
		self:skinObject("frame", {obj=pc, fType=ftype, fb=true, ofs=4})
		for i = 1, 6 do
			pc["spell" .. i].BlackCover:SetAlpha(0) -- N.B. texture is changed in code
			if self.modBtnBs then
				self:addButtonBorder{obj=pc["spell" .. i], relTo=pc["spell" .. i].icon, clr="grey", ca=0.85}
			end
		end
		pc = nil
		if self.modBtnBs then
			self:SecureHook("PetJournal_UpdatePetLoadOut", function()
				for i = 1, 3 do
					self:clrButtonFromBorder(_G.PetJournal.Loadout["Pet" .. i], "qualityBorder")
				end
			end)
			self:SecureHook("PetJournal_UpdatePetCard", function(this)
				self:clrButtonFromBorder(this.PetInfo, "qualityBorder")
			end)
		end
		self:removeMagicBtnTex(this.FindBattleButton)
		self:removeMagicBtnTex(this.SummonButton)
		if self.modBtns then
			self:skinStdButton{obj=this.FindBattleButton}
			self:skinStdButton{obj=this.SummonButton}
		end
		self:removeRegions(this.AchievementStatus, {1, 2})

		local function skinTTip(tip)
			tip.Delimiter1:SetTexture(nil)
			tip.Delimiter2:SetTexture(nil)
			tip:DisableDrawLayer("BACKGROUND")
			aObj:skinObject("frame", {obj=tip, fType=ftype, ofs=0})
		end
		skinTTip(_G.PetJournalPrimaryAbilityTooltip)
		skinTTip(_G.PetJournalSecondaryAbilityTooltip)

		self:Unhook(this, "OnShow")
	end)

	local skinPageBtns, skinCollectionBtn
	if self.modBtnBs then
		function skinPageBtns(frame)
			aObj:addButtonBorder{obj=frame.PagingFrame.PrevPageButton, ofs=-2, y1=-3, x2=-3}
			aObj:addButtonBorder{obj=frame.PagingFrame.NextPageButton, ofs=-2, y1=-3, x2=-3}
			aObj:clrPNBtns(frame.PagingFrame, true)
			aObj:SecureHook(frame.PagingFrame, "Update", function(this)
				aObj:clrPNBtns(this, true)
			end)
		end
		function skinCollectionBtn(btn)
			if btn.sbb then
				if btn.slotFrameUncollected:IsShown() then
					aObj:clrBtnBdr(btn, "grey")
				else
					aObj:clrBtnBdr(btn)
				end
			end
		end
	end

	self:SecureHookScript(_G.ToyBox, "OnShow", function(this)
		self:removeRegions(this.progressBar, {2, 3})
		self:skinStatusBar{obj=this.progressBar, fi=0}
		self:skinObject("editbox", {obj=this.searchBox, fType=ftype, si=true})
		if self.modBtns then
			self:skinStdButton{obj=_G.ToyBoxFilterButton, fType=ftype}
		end
		self:removeInset(this.iconsFrame)
		self:keepFontStrings(this.iconsFrame)
		for i = 1, 18 do
			this.iconsFrame["spellButton" .. i].slotFrameCollected:SetTexture(nil)
			this.iconsFrame["spellButton" .. i].slotFrameUncollected:SetTexture(nil)
			if self.modBtnBs then
				self:addButtonBorder{obj=this.iconsFrame["spellButton" .. i], sec=true, ofs=0}
			end
		end
		if self.modBtnBs then
			skinPageBtns(this)
			self:SecureHook("ToySpellButton_UpdateButton", function(this)
				skinCollectionBtn(this)
			end)
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.HeirloomsJournal, "OnShow", function(this)
		self:skinStatusBar{obj=this.progressBar, fi=0}
		self:removeRegions(this.progressBar, {2, 3})
		self:skinObject("editbox", {obj=this.SearchBox, fType=ftype, si=true})
		if self.modBtns then
			self:skinStdButton{obj=_G.HeirloomsJournalFilterButton, fType=ftype}
		end
		self:skinObject("dropdown", {obj=this.classDropDown, fType=ftype})
		self:removeInset(this.iconsFrame)
		self:keepFontStrings(this.iconsFrame)
		-- 18 icons per page ?
		self:SecureHook(this, "LayoutCurrentPage", function(this)
			for _, frame in _G.pairs(this.heirloomHeaderFrames) do
				frame:DisableDrawLayer("BACKGROUND")
				frame.text:SetTextColor(self.HT:GetRGB())
			end
			for _, frame in _G.pairs(this.heirloomEntryFrames) do
				frame.slotFrameCollected:SetTexture(nil)
				frame.slotFrameUncollected:SetTexture(nil)
				-- ignore btn.levelBackground as its textures is changed when upgraded
				if self.modBtnBs then
					self:addButtonBorder{obj=frame, sec=true, ofs=0, reParent={frame.new, frame.levelBackground, frame.level}}
					skinCollectionBtn(frame)
				end
			end
		end)
		if self.modBtnBs then
			skinPageBtns(this)
			self:SecureHook(this, "UpdateButton", function(this, button)
				skinCollectionBtn(button)
				if button.levelBackground:GetAtlas() == "collections-levelplate-black" then
					self:changeTandC(button.levelBackground)
				end
			end)
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.WardrobeCollectionFrame, "OnShow", function(this)
		self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true, upwards=true, offsets={x1=2, y1=-4, x2=-2, y2=self.isTT and -4 or 0}})
		self:skinObject("editbox", {obj=this.searchBox, fType=ftype, si=true})
		_G.RaiseFrameLevelByTwo(this.searchBox) -- raise above SetsCollectionFrame when displayed on it
		self:skinStatusBar{obj=this.progressBar, fi=0}
		self:removeRegions(this.progressBar, {2, 3})
		if self.modBtns then
			self:skinStdButton{obj=this.FilterButton}
			_G.RaiseFrameLevelByTwo(this.FilterButton) -- raise above SetsCollectionFrame when displayed on it
		end
		if not aObj.isRetPTR then
			self:SecureHookScript(this.searchProgressFrame, "OnShow", function(this)
				this:DisableDrawLayer("BACKGROUND")
				this:DisableDrawLayer("ARTWORK")
				self:skinStatusBar{obj=this.searchProgressBar, 0, bgTex=this.searchProgressBar.barBackground}
				this.searchProgressBar:DisableDrawLayer("ARTWORK")
				self:skinObject("frame", {obj=this, fType=ftype})

				self:Unhook(this, "OnShow")
			end)
		end
		local x1Ofs, y1Ofs, x2Ofs, y2Ofs = -4, 2, 7, -4

		local function updBtnClr(btn)
			local atlas = btn.Border:GetAtlas()
			if atlas:find("uncollected", 1, true) then
				aObj:clrBtnBdr(btn, "grey")
			elseif atlas:find("unusable", 1, true) then
				aObj:clrBtnBdr(btn, "unused")
			else
				aObj:clrBtnBdr(btn, "gold", 0.75)
			end
		end

		self:SecureHookScript(this.ItemsCollectionFrame, "OnShow", function(this)
			self:skinObject("dropdown", {obj=this.WeaponDropDown, fType=ftype})
			self:skinObject("frame", {obj=this, fType=ftype, fb=true, kfs=true, rns=true, x1=x1Ofs, y1=y1Ofs, x2=x2Ofs, y2=y2Ofs})
			if self.modBtnBs then
				skinPageBtns(this)
				for _, btn in _G.pairs(this.Models) do
					self:removeRegions(btn, {2}) -- background & border
					self:addButtonBorder{obj=btn, reParent={btn.NewString, btn.Favorite.Icon, btn.HideVisual.Icon}, ofs=6}
					updBtnClr(btn)
				end
				self:SecureHook(this, "UpdateItems", function(this)
					for _, btn in _G.pairs(this.Models) do
						updBtnClr(btn)
					end
				end)
			end

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(this.ItemsCollectionFrame)

		self:SecureHookScript(this.SetsCollectionFrame, "OnShow", function(this)
			self:removeInset(this.LeftInset)
			self:keepFontStrings(this.RightInset)
			self:removeNineSlice(this.RightInset.NineSlice)
			self:skinObject("slider", {obj=this.ScrollFrame.scrollBar, fType=ftype})
			for _, btn in _G.pairs(this.ScrollFrame.buttons) do
				btn:DisableDrawLayer("BACKGROUND")
				if self.modBtnBs then
					 self:addButtonBorder{obj=btn, relTo=btn.Icon, reParent={btn.Favorite}}
				end
			end
			this.DetailsFrame:DisableDrawLayer("BACKGROUND")
			this.DetailsFrame:DisableDrawLayer("BORDER")
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, fb=true, x1=x1Ofs, y1=y1Ofs, x2=x2Ofs, y2=y2Ofs})
			if self.modBtns then
				 self:skinStdButton{obj=this.DetailsFrame.VariantSetsButton}
			end
			if self.modBtnBs then
				local function colourBtns(sFrame)
					for _, btn in _G.pairs(sFrame.buttons) do
						btn:DisableDrawLayer("BACKGROUND")
						aObj:clrBtnBdr(btn, btn.Icon:IsDesaturated() and "grey")
					end
				end
				colourBtns(this.ScrollFrame)
				self:SecureHook(this.ScrollFrame, "update", function(this) -- use lowercase for scrollframe function
					colourBtns(this)
				end)
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(this.SetsTransmogFrame, "OnShow", function(this)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, rns=true, fb=true, x1=x1Ofs, y1=y1Ofs, x2=x2Ofs, y2=y2Ofs})
			if self.modBtnBs then
				skinPageBtns(this)
				for _, btn in _G.pairs(this.Models) do
					self:removeRegions(btn, {2}) -- background & border
					self:addButtonBorder{obj=btn, reParent={btn.Favorite.Icon}, ofs=6}
					updBtnClr(btn)
				end
			end

			self:Unhook(this, "OnShow")
		end)

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.WardrobeFrame, "OnShow", function(this)
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, rns=true, cb=true, x2=3})

		self:Unhook(this, "OnShow")
	end)

	-- used by Transmog as well as Appearance
	self:SecureHookScript(_G.WardrobeTransmogFrame, "OnShow", function(this)
		this:DisableDrawLayer("ARTWORK")
		self:removeInset(this.Inset)
		self:skinObject("dropdown", {obj=this.OutfitDropDown, fType=ftype, y2=-3})
		for _, btn in _G.pairs(aObj.isRetPTR and this.SlotButtons or this.ModelScene.SlotButtons) do
			btn.Border:SetTexture(nil)
			if self.modBtnBs then
				 self:addButtonBorder{obj=btn, ofs=-2}
			end
		end
		this.ModelScene.ControlFrame:DisableDrawLayer("BACKGROUND")
		if self.modBtns then
			self:skinStdButton{obj=this.OutfitDropDown.SaveButton}
			self:skinStdButton{obj=this.ApplyButton, ofs=0}
			self:SecureHook(this.OutfitDropDown, "UpdateSaveButton", function(this)
				self:clrBtnBdr(this.SaveButton)
			end)
			if not aObj.isRetPTR then
				self:SecureHook("WardrobeTransmogFrame_UpdateApplyButton", function()
					self:clrBtnBdr(_G.WardrobeTransmogFrame.ApplyButton)
				end)
			else
				self:SecureHook(_G.WardrobeTransmogFrame, "UpdateApplyButton", function(this)
					self:clrBtnBdr(this.ApplyButton)
				end)
			end
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=this.ModelScene.ClearAllPendingButton, ofs=1, x2=0, relTo=this.ModelScene.ClearAllPendingButton.Icon}
			self:addButtonBorder{obj=this.SpecButton, ofs=0}
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzLoDFrames[ftype].Communities = function(self)
	if not self.prdb.Communities or self.initialized.Communities then return end

	if not _G.CommunitiesFrame then
		_G.C_Timer.After(0.1, function()
			self.blizzLoDFrames[ftype].Communities(self)
		end)
		return
	end

	self.initialized.Communities = true

	local function skinColumnDisplay(frame)
		frame:DisableDrawLayer("BACKGROUND")
		frame:DisableDrawLayer("BORDER")
		frame:DisableDrawLayer("ARTWORK")
		for header in frame.columnHeaders:EnumerateActive() do
			header:DisableDrawLayer("BACKGROUND")
			aObj:addSkinFrame{obj=header, ft=ftype, x2=-2}
		end
	end

	local cFrame = _G.CommunitiesFrame
	self:removeNineSlice(cFrame.NineSlice)

	-->> N.B. Currently can't be skinned, as the XML has a ScopedModifier element saying forbidden=""
		-- CommunitiesAddDialog
		-- CommunitiesCreateDialog

	self:keepFontStrings(cFrame.PortraitOverlay)

	cFrame.MaximizeMinimizeFrame:DisableDrawLayer("BACKGROUND")
	if self.modBtns then
		self:skinOtherButton{obj=cFrame.MaximizeMinimizeFrame.MaximizeButton, font=self.fontS, text=self.nearrow}
		self:skinOtherButton{obj=cFrame.MaximizeMinimizeFrame.MinimizeButton, font=self.fontS, disfont=self.fontDS, text=self.swarrow}
		self:SecureHook(cFrame, "UpdateMaximizeMinimizeButton", function(this)
			self:clrBtnBdr(this.MaximizeMinimizeFrame.MinimizeButton)
		end)
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
			this.ListScrollFrame.buttons[i].IconRing:SetAlpha(0) -- texture changed in code
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

	-- tabs (side)
	for _, tabName in _G.pairs{"ChatTab", "RosterTab", "GuildBenefitsTab", "GuildInfoTab"} do
		cFrame[tabName]:DisableDrawLayer("BORDER")
		if self.modBtnBs then
			self:addButtonBorder{obj=cFrame[tabName]}
		end
	end
	self:moveObject{obj=cFrame.ChatTab, x=1}

	self:skinDropDown{obj=cFrame.StreamDropDownMenu}
	self:skinDropDown{obj=cFrame.GuildMemberListDropDownMenu}
	self:skinDropDown{obj=cFrame.CommunityMemberListDropDownMenu}
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

	cFrame.ApplicantList:DisableDrawLayer("BACKGROUND")
	cFrame.ApplicantList:DisableDrawLayer("ARTWORK")
	self:SecureHookScript(cFrame.ApplicantList.ColumnDisplay, "OnShow", function(this)
		skinColumnDisplay(this)
	end)
	self:skinSlider{obj=cFrame.ApplicantList.ListScrollFrame.scrollBar, rt="background", wdth=-4}
	self:skinDropDown{obj=cFrame.ApplicantList.DropDown}
	self:removeNineSlice(cFrame.ApplicantList.InsetFrame.NineSlice)
	cFrame.ApplicantList.InsetFrame.Bg:SetTexture(nil)
	if self.modBtns then
		self:SecureHook(cFrame.ApplicantList, "RefreshLayout", function(this)
			for _, btn in _G.pairs(this.ListScrollFrame.buttons) do
				self:skinStdButton{obj=btn.CancelInvitationButton}
				self:skinStdButton{obj=btn.InviteButton}
			end

			self:Unhook(this, "RefreshLayout")
		end)
	end

	local function skinReqToJoin(frame)
		frame.MessageFrame:DisableDrawLayer("BACKGROUND")
		frame.MessageFrame.MessageScroll:DisableDrawLayer("BACKGROUND")
		aObj:skinObject("frame", {obj=frame.MessageFrame, fType=ftype, kfs=true, fb=true, ofs=2})
		aObj:skinObject("frame", {obj=frame.BG, fType=ftype, kfs=true})
		if aObj.modBtns then
			 aObj:skinStdButton{obj=frame.Apply}
			 aObj:skinStdButton{obj=frame.Cancel}
			 aObj:SecureHook(frame, "EnableOrDisableApplyButton", function(this)
				 aObj:clrBtnBdr(frame.Apply, "", 1)
			 end)
		end
		if aObj.modChkBtns then
			aObj:SecureHook(frame, "Initialize", function(this)
				for spec in this.SpecsPool:EnumerateActive() do
					aObj:skinCheckButton{obj=spec.CheckBox}
				end
			end)
		end
	end
	local function skinCFGaCF(frame)
		frame:DisableDrawLayer("BACKGROUND")
		aObj:skinDropDown{obj=frame.OptionsList.ClubFilterDropdown}
		aObj:skinDropDown{obj=frame.OptionsList.ClubSizeDropdown}
		aObj:skinDropDown{obj=frame.OptionsList.SortByDropdown}
		aObj:skinEditBox{obj=frame.OptionsList.SearchBox, regs={6, 7}, mi=true} -- 6 is text, 7 is icon
		aObj:moveObject{obj=frame.OptionsList.Search, x=3, y=-4}
		if aObj.modBtns then
			aObj:skinStdButton{obj=frame.OptionsList.Search}
		end
		if aObj.modChkBtns then
			aObj:skinCheckButton{obj=frame.OptionsList.TankRoleFrame.CheckBox}
			aObj:skinCheckButton{obj=frame.OptionsList.HealerRoleFrame.CheckBox}
			aObj:skinCheckButton{obj=frame.OptionsList.DpsRoleFrame.CheckBox}
		end

		local btn
 		for i = 1, #frame.GuildCards.Cards do
			btn = frame.GuildCards.Cards[i]
			btn:DisableDrawLayer("BACKGROUND")
			aObj:addSkinFrame{obj=btn, ft=ftype, nb=true, y1=5}
			if aObj.modBtns then
				aObj:skinStdButton{obj=btn.RequestJoin}
			end
			aObj:SecureHook(btn, "SetDisabledState", function(this, shouldDisable)
				if shouldDisable then
					aObj:clrBBC(this.sf, "disabled")
				else
					aObj:clrBBC(this.sf, "gold")
				end
			end)
		end
		if aObj.modBtnBs then
			aObj:addButtonBorder{obj=frame.GuildCards.PreviousPage, ofs=-2, y1=-3, x2=-3, clr="disabled"}
			aObj:addButtonBorder{obj=frame.GuildCards.NextPage, ofs=-2, y1=-3, x2=-3, clr="disabled"}
		end

		aObj:skinSlider{obj=frame.CommunityCards.ListScrollFrame.scrollBar, wdth=-4}
		for i = 1, #frame.CommunityCards.ListScrollFrame.buttons do
			btn = frame.CommunityCards.ListScrollFrame.buttons[i]
			btn.LogoBorder:SetTexture(nil)
			aObj:addSkinFrame{obj=btn, ft=ftype, nb=true, ofs=3}
			aObj:SecureHook(btn, "SetDisabledState", function(this, shouldDisable)
				if shouldDisable then
					aObj:clrBBC(this.sf, "disabled")
				else
					aObj:clrBBC(this.sf, "common")
				end
			end)
		end

 		for i = 1, #frame.PendingGuildCards.Cards do
			btn = frame.PendingGuildCards.Cards[i]
			btn:DisableDrawLayer("BACKGROUND")
			aObj:addSkinFrame{obj=btn, ft=ftype, nb=true, y1=5}
			if aObj.modBtns then
				aObj:skinStdButton{obj=btn.RequestJoin}
			end
			aObj:SecureHook(btn, "SetDisabledState", function(this, shouldDisable)
				if shouldDisable then
					aObj:clrBBC(this.sf, "disabled")
				else
					aObj:clrBBC(this.sf, "gold")
				end
			end)
		end
		if aObj.modBtnBs then
			aObj:addButtonBorder{obj=frame.PendingGuildCards.PreviousPage, ofs=-2, y1=-3, x2=-3, clr="gold"}
			aObj:addButtonBorder{obj=frame.PendingGuildCards.NextPage, ofs=-2, y1=-3, x2=-3, clr="gold"}
		end

		aObj:skinSlider{obj=frame.PendingCommunityCards.ListScrollFrame.scrollBar, wdth=-4}
		for i = 1, #frame.PendingCommunityCards.ListScrollFrame.buttons do
			btn = frame.PendingCommunityCards.ListScrollFrame.buttons[i]
			btn.LogoBorder:SetTexture(nil)
			aObj:addSkinFrame{obj=btn, ft=ftype, nb=true}
			aObj:SecureHook(btn, "SetDisabledState", function(this, shouldDisable)
				if shouldDisable then
					aObj:clrBBC(this.sf, "disabled")
				else
					aObj:clrBBC(this.sf)
				end
			end)
		end
		btn = nil

		skinReqToJoin(frame.RequestToJoinFrame)

		aObj:removeNineSlice(frame.InsetFrame.NineSlice)
		frame.InsetFrame.Bg:SetTexture(nil)

		frame.DisabledFrame:DisableDrawLayer("BACKGROUND")
		aObj:removeNineSlice(frame.DisabledFrame.NineSlice)

		-- Tabs (RHS)
		aObj:moveObject{obj=frame.ClubFinderSearchTab, x=1}
		aObj:removeRegions(frame.ClubFinderSearchTab, {1})
		aObj:removeRegions(frame.ClubFinderPendingTab, {1})
		if aObj.modBtnBs then
			aObj:addButtonBorder{obj=frame.ClubFinderSearchTab}
			aObj:addButtonBorder{obj=frame.ClubFinderPendingTab}
			aObj:SecureHook(frame, "UpdatePendingTab", function(this)
				aObj:clrBtnBdr(this.ClubFinderPendingTab)
			end)
		end
	end

	skinCFGaCF(cFrame.GuildFinderFrame)
	if self.modBtnBs then
		self:secureHook(cFrame.GuildFinderFrame.GuildCards, "RefreshLayout", function(this, _)
			self:clrBtnBdr(this.PreviousPage, "gold")
			self:clrBtnBdr(this.NextPage, "gold")
		end)
	end

	skinCFGaCF(cFrame.CommunityFinderFrame)

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

	self:SecureHookScript(cFrame.ClubFinderInvitationFrame, "OnShow", function(this)
		this:DisableDrawLayer("BACKGROUND")
		self:removeInset(this.InsetFrame)
		self:removeNineSlice(this.InsetFrame.NineSlice)
		self:skinObject("frame", {obj=this.WarningDialog.BG, fType=ftype, kfs=true, fb=true})
		if self.modBtns then
			self:skinStdButton{obj=this.WarningDialog.Accept}
			self:skinStdButton{obj=this.WarningDialog.Cancel}
			self:skinStdButton{obj=this.AcceptButton}
			self:skinStdButton{obj=this.ApplyButton}
			self:skinStdButton{obj=this.DeclineButton}
			self:SecureHook(this, "DisplayInvitation", function(this, _)
				self:clrBtnBdr(this.ApplyButton)
			end)
			self:SecureHook(this.AcceptButton, "SetEnabled", function(this, _)
				self:clrBtnBdr(this)
			end)
		end
		skinReqToJoin(this.RequestToJoinFrame)

		self:Unhook(this, "OnShow")
	end)

	self:removeNineSlice(cFrame.TicketFrame.InsetFrame.NineSlice)
	if self.modBtns then
		self:skinStdButton{obj=cFrame.TicketFrame.AcceptButton}
		self:skinStdButton{obj=cFrame.TicketFrame.DeclineButton}
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
				 self:addButtonBorder{obj=btn, relTo=btn.Icon, clr="grey"}
			end
		end
		btn = nil
		this.Rewards.Bg:SetTexture(nil)
		self:skinSlider{obj=this.Rewards.RewardsContainer.scrollBar, rt="artwork", wdth=-4}
		local btn
		for i = 1, #this.Rewards.RewardsContainer.buttons do
			btn = this.Rewards.RewardsContainer.buttons[i]
			btn:GetNormalTexture():SetAlpha(0)
			if self.modBtnBs then
				 self:addButtonBorder{obj=btn, relTo=btn.Icon, reParent={btn.Lock}}
			end
		end
		if self.modBtnBs then
			self:SecureHook("CommunitiesGuildRewards_Update", function(this)
				local btn
				for i = 1, #this.RewardsContainer.buttons do
					btn = this.RewardsContainer.buttons[i]
					btn.sbb:SetBackdropBorderColor(btn.Icon:GetVertexColor())
				end
				btn = nil
			end)
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
		self:addFrameBorder{obj=this.Description, ft=ftype, ofs=7}
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true}
		if self.modBtns then
			self:skinStdButton{obj=this.Accept}
			self:skinStdButton{obj=this.Delete}
			self:skinStdButton{obj=this.Cancel}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=this.TypeCheckBox}
		end

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

	self:SecureHookScript(cFrame.RecruitmentDialog, "OnShow", function(this)
		self:skinDropDown{obj=this.ClubFocusDropdown}
		self:skinDropDown{obj=this.LookingForDropdown}
		self:skinDropDown{obj=this.LanguageDropdown}
		this.RecruitmentMessageFrame:DisableDrawLayer("BACKGROUND")
		self:addFrameBorder{obj=this.RecruitmentMessageFrame.RecruitmentMessageInput, ft=ftype, ofs=6}
		self:skinEditBox{obj=this.MinIlvlOnly.EditBox, regs={6}} -- 6 is text
		this.MinIlvlOnly.EditBox.Text:ClearAllPoints()
		this.MinIlvlOnly.EditBox.Text:SetPoint("Left", this.MinIlvlOnly.EditBox, "Left", 6, 0)
		self:addSkinFrame{obj=this.BG, ft=ftype, kfs=true, nb=true}
		if self.modBtns then
			self:skinStdButton{obj=this.Accept}
			self:skinStdButton{obj=this.Cancel}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=this.ShouldListClub.Button}
			self:skinCheckButton{obj=this.MaxLevelOnly.Button}
			self:skinCheckButton{obj=this.MinIlvlOnly.Button}
		end

		self:Unhook(this, "OnShow")
	end)

	self:moveObject{obj=cFrame.AddToChatButton, x=-6, y=-6}

	if self.modBtns then
		self:skinStdButton{obj=cFrame.InviteButton}
		self:SecureHook(cFrame.InviteButton, "SetEnabled", function(this)
			self:clrBtnBdr(this)
		end)
		self:skinStdButton{obj=cFrame.CommunitiesControlFrame.CommunitiesSettingsButton}
		self:skinStdButton{obj=cFrame.CommunitiesControlFrame.GuildRecruitmentButton}
		self:SecureHook(cFrame.CommunitiesControlFrame.GuildRecruitmentButton, "SetEnabled", function(this)
			self:clrBtnBdr(this)
		end)
		self:skinStdButton{obj=cFrame.CommunitiesControlFrame.GuildControlButton}
		self:skinStdButton{obj=cFrame.GuildLogButton}
	end
	if self.modBtnBs then
		self:addButtonBorder{obj=cFrame.AddToChatButton, ofs=1, clr="gold"}
	end

	-- N.B. hook DisplayMember rather than OnShow script
	self:SecureHook(cFrame.GuildMemberDetailFrame, "DisplayMember", function(this, _)
		self:removeNineSlice(this.Border)
		self:skinDropDown{obj=this.RankDropdown}
		self:addFrameBorder{obj=this.NoteBackground, ft=ftype}
		self:addFrameBorder{obj=this.OfficerNoteBackground, ft=ftype}
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ofs=0, x2=6}
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
					 self:addButtonBorder{obj=this.InviteManager.ListScrollFrame.buttons[i].RevokeButton, ofs=0, clr="grey"}
				end
			end
		end
		self:addFrameBorder{obj=this.InviteManager, ft=ftype, ofs=-4, x2=-7, y2=-5}
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true, y1=-8, y2=6}
		if self.modBtns then
			self:skinStdButton{obj=this.LinkToChat}
			self:skinStdButton{obj=this.Copy}
			self:skinStdButton{obj=this.GenerateLinkButton}
			self:skinDropDown{obj=this.ExpiresDropDownMenu}
			self:skinStdButton{obj=this.Close}
		end
		if self.modBtnBs then
			 self:addButtonBorder{obj=this.MaximizeButton, ofs=0, clr="gold"}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.CommunitiesSettingsDialog, "OnShow", function(this)
		self:keepFontStrings(this.BG)
		self:skinEditBox{obj=this.NameEdit, regs={6}} -- 6 is text
		self:skinEditBox{obj=this.ShortNameEdit, regs={6}} -- 6 is text
		self:addFrameBorder{obj=this.MessageOfTheDay, ft=ftype, ofs=8}
		self:skinEditBox{obj=this.MinIlvlOnly.EditBox, regs={6}} -- 6 is text
		this.MinIlvlOnly.EditBox.Text:ClearAllPoints()
		this.MinIlvlOnly.EditBox.Text:SetPoint("Left", this.MinIlvlOnly.EditBox, "Left", 6, 0)
		self:skinDropDown{obj=this.ClubFocusDropdown}
		self:skinDropDown{obj=this.LookingForDropdown}
		self:skinDropDown{obj=this.LanguageDropdown}
		self:addFrameBorder{obj=this.Description, ft=ftype, ofs=8}
		self:addSkinFrame{obj=this, ft=ftype, nb=true, ofs=-10}
		if self.modBtns then
			self:skinStdButton{obj=this.ChangeAvatarButton}
			self:skinStdButton{obj=this.Delete}
			self:skinStdButton{obj=this.Accept}
			self:skinStdButton{obj=this.Cancel}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=this.ShouldListClub.Button}
			self:skinCheckButton{obj=this.AutoAcceptApplications.Button}
			self:skinCheckButton{obj=this.MaxLevelOnly.Button}
			self:skinCheckButton{obj=this.MinIlvlOnly.Button}
		end

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
		self:removeMagicBtnTex(this.Recruitment.ListGuildButton)
		self:addFrameBorder{obj=this.Recruitment.CommentFrame.CommentInputFrame, ft=ftype}
		if self.modBtns then
			 self:skinStdButton{obj=this.Recruitment.ListGuildButton}
		end
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
		-- Applicants
		for _, btn in _G.pairs(this.Applicants.Container.buttons) do
			btn.ring:SetAlpha(0)
			btn.PointsSpentBgGold:SetAlpha(0)
			self:moveObject{obj=btn.PointsSpentBgGold, x=6, y=-6}
			-- self:applySkin{obj=btn}
		end
		self:skinObject("slider", {obj=this.Applicants.Container.scrollBar, fType=ftype})
		self:removeMagicBtnTex(this.Applicants.InviteButton)
		self:removeMagicBtnTex(this.Applicants.MessageButton)
		self:removeMagicBtnTex(this.Applicants.DeclineButton)
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, cb=true})
		if self.modBtns then
			self:skinStdButton{obj=this.Applicants.InviteButton}
			self:skinStdButton{obj=this.Applicants.MessageButton}
			self:skinStdButton{obj=this.Applicants.DeclineButton}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.CommunitiesGuildTextEditFrame, "OnShow", function(this)
		self:skinSlider{obj=_G.CommunitiesGuildTextEditFrame.Container.ScrollFrame.ScrollBar, wdth=-6}
		self:addFrameBorder{obj=_G.CommunitiesGuildTextEditFrame.Container, ft=ftype}
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ofs=-7}
		if self.modBtns then
			self:skinStdButton{obj=_G.CommunitiesGuildTextEditFrameAcceptButton}
			self:skinStdButton{obj=self:getChild(_G.CommunitiesGuildTextEditFrame, 4)} -- bottom close button
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.CommunitiesGuildLogFrame, "OnShow", function(this)
		self:skinSlider{obj=this.Container.ScrollFrame.ScrollBar, wdth=-6}
		self:addFrameBorder{obj=this.Container, ft=ftype}
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ofs=-7}
		if self.modBtns then
			 self:skinStdButton{obj=self:getChild(this, 3)} -- bottom close button
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.CommunitiesGuildNewsFiltersFrame, "OnShow", function(this)
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ofs=-7}
		if self.modChkBtns then
			self:skinCheckButton{obj=this.GuildAchievement}
			self:skinCheckButton{obj=this.Achievement}
			self:skinCheckButton{obj=this.DungeonEncounter}
			self:skinCheckButton{obj=this.EpicItemLooted}
			self:skinCheckButton{obj=this.EpicItemPurchased}
			self:skinCheckButton{obj=this.EpicItemCrafted}
			self:skinCheckButton{obj=this.LegendaryItemLooted}
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].CompactFrames = function(self)
	if not self.prdb.CompactFrames or self.initialized.CompactFrames then return end
	self.initialized.CompactFrames = true

	if _G.IsAddOnLoaded("Tukui")
	or _G.IsAddOnLoaded("ElvUI")
	then
		self.blizzFrames[ftype].CompactFrames = nil
		return
	end

	local function skinUnit(unit)
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
		aObj:skinObject("frame", {obj=grp.borderFrame, fType=ftype, kfs=true, ofs=1, y1=-1, x2=-4, y2=4})
		local grpName = grp:GetName()
		for i = 1, _G.MEMBERS_PER_RAID_GROUP do
			skinUnit(_G[grpName .. "Member" .. i])
		end
		grpName = nil
	end

	-- Compact Party Frame
	self:SecureHook("CompactPartyFrame_OnLoad", function()
		self:skinObject("frame", {obj=_G.CompactPartyFrame.borderFrame, fType=ftype, kfs=true})

		self:Unhook("CompactPartyFrame_OnLoad")
	end)
	-- hook this to skin any new CompactRaidGroup(s)
	self:SecureHook("CompactRaidGroup_UpdateLayout", function(frame)
		skinGrp(frame)
	end)

	-- Compact RaidFrame Container
	-- handle AddOn being disabled
	if not self:checkLoadable("Blizzard_CompactRaidFrames") then
		return
	end

	local function skinCRFCframes()
		-- handle in combat as UnitFrame uses SecureUnitButtonTemplate
		if _G.InCombatLockdown() then
			aObj:add2Table(aObj.oocTab, {skinCRFCframes, {nil}})
			return
		end
		for type, fTab in _G.pairs(_G.CompactRaidFrameContainer.frameUpdateList) do
			for _, frame in _G.pairs(fTab) do
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
		end
	end
	-- hook this to skin any new CompactRaidFrameContainer entries
	self:SecureHook("FlowContainer_AddObject", function(container, _)
		if container == _G.CompactRaidFrameContainer then -- only for compact raid frame objects
			skinCRFCframes()
		end
	end)
	-- skin any existing unit(s) [mini, normal]
	skinCRFCframes()
	self:skinObject("frame", {obj=_G.CompactRaidFrameContainer.borderFrame, fType=ftype, kfs=true, ofs=1, y1=-1, x2=-4, y2=4})

	-- Compact RaidFrame Manager
	self:SecureHookScript(_G.CompactRaidFrameManager, "OnShow", function(this)
		self:moveObject{obj=this.toggleButton, x=5}
		this.toggleButton:SetSize(12, 32)
		this.toggleButton.nt = this.toggleButton:GetNormalTexture()
		this.toggleButton.nt:SetTexCoord(0.22, 0.5, 0.33, 0.67)
		-- hook this to trim the texture
		self:RawHook(this.toggleButton.nt, "SetTexCoord", function(this, x1, x2, _)
			self.hooks[this].SetTexCoord(this, x1 == 0 and x1 + 0.22 or x1 + 0.26, x2, 0.33, 0.67)
		end, true)
		-- Display Frame
		_G.CompactRaidFrameManagerDisplayFrameHeaderBackground:SetTexture(nil)
		_G.CompactRaidFrameManagerDisplayFrameHeaderDelineator:SetTexture(nil)
		this.displayFrame.filterOptions:DisableDrawLayer("BACKGROUND")
		self:skinObject("dropdown", {obj=this.displayFrame.profileSelector, fType=ftype})
		if self.modBtns then
			for i = 1, 8 do
				self:skinStdButton{obj=this.displayFrame.filterOptions["filterGroup" .. i]}
			end
			self:skinStdButton{obj=this.displayFrame.lockedModeToggle, fType=ftype}
			self:skinStdButton{obj=this.displayFrame.hiddenModeToggle, fType=ftype}
			self:skinStdButton{obj=this.displayFrame.convertToRaid, fType=ftype}
			self:skinStdButton{obj=this.displayFrame.leaderOptions.readyCheckButton, fType=ftype}
			if not self.isClsc then
				for _, type in _G.pairs{"Tank", "Healer", "Damager"} do
					self:skinStdButton{obj=this.displayFrame.filterOptions["filterRole" .. type]}
				end
				self:skinStdButton{obj=this.displayFrame.leaderOptions.rolePollButton, fType=ftype}
				this.displayFrame.leaderOptions.countdownButton:DisableDrawLayer("ARTWORK") -- alpha values are changed in code
				this.displayFrame.leaderOptions.countdownButton.Text:SetDrawLayer("OVERLAY") -- move draw layer so it is displayed
				self:skinStdButton{obj=this.displayFrame.leaderOptions.countdownButton, fType=ftype}
				self:skinStdButton{obj=_G.CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton, fType=ftype}
				_G.CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:GetNormalTexture():SetAlpha(1) -- icon
			end
			self:SecureHook("CompactRaidFrameManager_UpdateOptionsFlowContainer", function(this)
				self:clrBtnBdr(this.displayFrame.leaderOptions.readyCheckButton)
				if not self.isClsc then
					self:clrBtnBdr(this.displayFrame.leaderOptions.rolePollButton)
					self:clrBtnBdr(this.displayFrame.leaderOptions.countdownButton)
				end
			end)
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=this.displayFrame.everyoneIsAssistButton}
			_G.RaiseFrameLevel(this.displayFrame.everyoneIsAssistButton) -- so button border is visible
		end
		self:skinObject("frame", {obj=this.containerResizeFrame, fType=ftype, kfs=true})
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ofs=0})

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.CompactRaidFrameManager)

end

local gearTex = [[Interface\AddOns\]] .. aName .. [[\Textures\gear]]
aObj.blizzFrames[ftype].ContainerFrames = function(self)
	if not self.prdb.ContainerFrames.skin or self.initialized.ContainerFrames then return end
	self.initialized.ContainerFrames = true

	if _G.IsAddOnLoaded("LiteBag") then
		self.blizzFrames[ftype].ContainerFrames = nil
		return
	end

	local function skinBag(frame, id)
		local objName = frame:GetName()
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
			for i = 1, 36 do
				bo = _G[objName .. "Item" .. i]
				aObj:addButtonBorder{obj=bo, ibt=true, reParent={_G[objName .. "Item" .. i .. "IconQuestTexture"], bo.JunkIcon, bo.UpgradeIcon, bo.flash, bo.NewItemTexture, bo.BattlepayItemTexture}}
			end
			bo = nil
			-- update Button quality borders
			_G.ContainerFrame_Update(frame)
		end
		-- Backpack
		if id == 0 then
			aObj:skinObject("editbox", {obj=_G.BagItemSearchBox, fType=ftype, si=true, ca=true})
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=_G.BagItemAutoSortButton, ofs=0, y1=1, clr="grey"}
			end
			-- TokenFrame
			_G.BackpackTokenFrame:DisableDrawLayer("BACKGROUND")
		end
		if aObj.modBtns then
			_G[objName .. "AddSlotsButton"]:DisableDrawLayer("OVERLAY")
			aObj:skinStdButton{obj=_G[objName .. "AddSlotsButton"]}
		end
		objName = nil
	end

	-- Hook this to skinhide/show the gear button
	self:SecureHook("ContainerFrame_GenerateFrame", function(frame, _, id)
		-- skin the frame if required
		if not frame.sf then
			skinBag(frame, id)
		end

	end)

	-- hook this to move the Search Box to the left, away from the AutoSort button
	self:RawHook(_G.BagItemSearchBox, "SetPoint", function(this, point, relTo, relPoint, _)
		self.hooks[this].SetPoint(this, point, relTo, relPoint, 50, -35)
	end, true)

end

aObj.blizzFrames[ftype].DressUpFrame = function(self)
	if not self.prdb.DressUpFrame or self.initialized.DressUpFrame then return end
	self.initialized.DressUpFrame = true

	if _G.IsAddOnLoaded("DressUp") then
		self.blizzFrames[ftype].DressUpFrame = nil
		return
	end

	self:SecureHookScript(_G.SideDressUpFrame, "OnShow", function(this)
		self:removeRegions(this, {1, 2, 3, 4})
		self:removeRegions(_G.SideDressUpFrameCloseButton, {5}) -- corner texture
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true, x1=-2, y1=-3, x2=-2}
		if self.modBtns then
			self:skinStdButton{obj=_G.SideDressUpFrame.ResetButton}
			self:skinCloseButton{obj=_G.SideDressUpFrameCloseButton}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.DressUpFrame, "OnShow", function(this)
		self:skinDropDown{obj=this.OutfitDropDown, y2=-4}
		this.MaxMinButtonFrame:DisableDrawLayer("BACKGROUND") -- button texture
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true, y2=-4}
		if self.modBtns then
			self:skinStdButton{obj=this.OutfitDropDown.SaveButton}
			self:skinOtherButton{obj=this.MaxMinButtonFrame.MaximizeButton, font=self.fontS, text=self.nearrow}
			self:skinOtherButton{obj=this.MaxMinButtonFrame.MinimizeButton, font=self.fontS, text=self.swarrow}
			self:skinStdButton{obj=_G.DressUpFrameCancelButton}
			self:skinStdButton{obj=this.ResetButton}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.TransmogAndMountDressupFrame, "OnShow", function(this)
		if self.modBtns then
			self:skinStdButton{obj=this.ResetButton}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=this.ShowMountCheckButton}
		end

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
		aObj.modUIBtns:skinStdButton{obj=btn, x1=-11, y1=-2, x2=11, y2=2, clr="gold"} -- use module function so button appears
	end
	self:SecureHookScript(_G.EncounterJournal, "OnShow", function(this)
		this.navBar:DisableDrawLayer("BACKGROUND")
		this.navBar:DisableDrawLayer("BORDER")
		this.navBar.overlay:DisableDrawLayer("OVERLAY")
		self:skinNavBarButton(this.navBar.home)
		this.navBar.home.text:SetPoint("RIGHT", -20, 0)
		self:skinObject("editbox", {obj=this.searchBox, fType=ftype, si=true})
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true})
		self:SecureHookScript(this.searchBox.searchPreviewContainer, "OnShow", function(this)
			local btn
			for i = 1, 5 do
				btn = this:GetParent()["sbutton" .. i]
				btn:SetNormalTexture(nil)
				btn:SetPushedTexture(nil)
			end
			btn = nil
			this:GetParent().showAllResults:SetNormalTexture(nil)
			this:GetParent().showAllResults:SetPushedTexture(nil)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true})
			-- adjust skinframe as parent frame is resized when populated
			this.sf:SetPoint("TOPLEFT", this.topBorder, "TOPLEFT", 0, 2)
			this.sf:SetPoint("BOTTOMRIGHT", this.botRightCorner, "BOTTOMRIGHT", 0, 4)

			self:Unhook(this, "OnShow")
		end)
		self:SecureHookScript(this.searchResults, "OnShow", function(this)
			self:skinObject("slider", {obj=this.scrollFrame.scrollBar, fType=ftype, y1=-2, y2=2})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, ofs=6, y1=-1, x2=4})
			for _, btn in _G.pairs(this.scrollFrame.buttons) do
				self:removeRegions(btn, {1})
				btn:GetNormalTexture():SetAlpha(0)
				btn:GetPushedTexture():SetAlpha(0)
				if self.modBtnBs then
					 self:addButtonBorder{obj=btn, relTo=btn.icon}
				end
			end

			self:Unhook(this, "OnShow")
		end)
		self:SecureHookScript(this.suggestFrame, "OnShow", function(this)
			local ejsfs
			for i = 1, _G.AJ_MAX_NUM_SUGGESTIONS do
				ejsfs = this["Suggestion" .. i]
				ejsfs.bg:SetTexture(nil)
				ejsfs.iconRing:SetTexture(nil)
				ejsfs.centerDisplay.title.text:SetTextColor(self.HT:GetRGB())
				ejsfs.centerDisplay.description.text:SetTextColor(self.BT:GetRGB())
				if i == 1 then
					ejsfs.reward.text:SetTextColor(self.BT:GetRGB())
				end
				ejsfs.reward.iconRing:SetTexture(nil)
				if self.modBtns then
					if i ~= 1 then
						self:skinStdButton{obj=ejsfs.centerDisplay.button}
					else
						self:skinStdButton{obj=ejsfs.button}
					end
				end
				if self.modBtnBs
				and i == 1
				then
					self:addButtonBorder{obj=ejsfs.prevButton, ofs=-2, y1=-3, x2=-3, clr="gold"}
					self:addButtonBorder{obj=ejsfs.nextButton, ofs=-2, y1=-3, x2=-3, clr="gold"}
					self:SecureHook("EJSuggestFrame_RefreshDisplay", function()
						local frame = _G.EncounterJournal.suggestFrame.Suggestion1
						self:clrBtnBdr(frame.prevButton, "gold")
						self:clrBtnBdr(frame.nextButton, "gold")
						frame = nil
					end)
				end
			end
			ejsfs = nil
			self:skinObject("frame", {obj=this, fType=ftype, fb=true, x1=-9, y1=6, x2=7, y2=-5})

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(this.suggestFrame)
		self:SecureHookScript(this.instanceSelect, "OnShow", function(this)
			self:skinObject("tabs", {obj=this, tabs=this.Tabs, selectedTab=_G.EncounterJournal.selectedTab, fType=ftype, lod=self.isTT and true, ignoreHLTex=false, offsets={x1=-11, y1=-1, x2=11, y2=self.isTT and -4 or 1}, regions={8, 9, 10, 11}, track=false, func=function(tab) tab:SetFrameLevel(20) end})
			if self.isTT then
				self:SecureHook("EJ_ContentTab_Select", function(id)
					for i, tab in _G.pairs(_G.EncounterJournal.instanceSelect.Tabs) do
						if i == id then
							self:setActiveTab(tab.sf)
						else
							self:setInactiveTab(tab.sf)
						end
					end
				end)
			end
			this.bg:SetAlpha(0)
			self:skinObject("dropdown", {obj=this.tierDropDown, fType=ftype})
			self:SecureHook("EncounterJournal_EnableTierDropDown", function()
				self:checkDisabledDD(this.tierDropDown)
			end)
			self:SecureHook("EncounterJournal_DisableTierDropDown", function()
				self:checkDisabledDD(this.tierDropDown)
			end)
			self:skinObject("slider", {obj=this.scroll.ScrollBar, fType=ftype})
			self:skinObject("frame", {obj=this.scroll, fType=ftype, fb=true, x1=-9, y1=6, x2=6, y2=-8})
			if self.modBtnBs then
				self:SecureHook("EncounterJournal_ListInstances", function()
					local btn
					for i = 1, 30 do
						btn = this.scroll.child["instance" .. i]
						if btn then
							self:addButtonBorder{obj=btn, relTo=btn.bgImage, ofs=0}
						end
					end
					btn = nil
				end)
			end

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(this.instanceSelect)
		self:SecureHookScript(this.encounter, "OnShow", function(this)
			-- Instance frame
			this.instance.loreBG:SetTexCoord(0.06, 0.70, 0.08, 0.58)
			this.instance.loreBG:SetSize(370, 308)
			this.instance:DisableDrawLayer("ARTWORK")
			self:moveObject{obj=this.instance.mapButton, x=-20, y=-18}
			if self.modBtnBs then
				self:addButtonBorder{obj=this.instance.mapButton, relTo=this.instance.mapButton.texture, x1=2, y1=-1, x2=-2, y2=1}
			end
			self:skinObject("slider", {obj=this.instance.loreScroll.ScrollBar, fType=ftype, x2=-4})
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
			self:SecureHook("EncounterJournal_DisplayInstance", function(_)
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
			self:skinObject("slider", {obj=this.info.bossesScroll.ScrollBar, fType=ftype, x2=-4})
			skinFilterBtn(this.info.difficulty)
			this.info.reset:SetNormalTexture(nil)
			this.info.reset:SetPushedTexture(nil)
			if self.modBtns then
				self:skinStdButton{obj=this.info.reset, y2=2, clr="gold"}
			end
			self:skinObject("slider", {obj=this.info.detailsScroll.ScrollBar, x2=-4})
			this.info.detailsScroll.child.description:SetTextColor(self.BT:GetRGB())
			self:skinObject("slider", {obj=this.info.overviewScroll.ScrollBar, fType=ftype, x2=-4})
			this.info.overviewScroll.child.loreDescription:SetTextColor(self.BT:GetRGB())
			this.info.overviewScroll.child.header:SetTexture(nil)
			this.info.overviewScroll.child.overviewDescription.Text:SetTextColor(self.BT:GetRGB())
			-- Hook this to skin headers
			self:SecureHook("EncounterJournal_ToggleHeaders", function(this, _)
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
			self:skinObject("slider", {obj=this.info.lootScroll.scrollBar, fType=ftype, x2=-4})
			skinFilterBtn(this.info.lootScroll.filter)
			skinFilterBtn(this.info.lootScroll.slotFilter)
			this.info.lootScroll.classClearFilter:DisableDrawLayer("BACKGROUND")
			-- hook this to skin loot entries
			self:SecureHook("EncounterJournal_LootUpdate", function()
				for _, btn in _G.pairs(this.info.lootScroll.buttons) do
					btn:DisableDrawLayer("BORDER")
					btn.armorType:SetTextColor(self.BT:GetRGB())
					btn.slot:SetTextColor(self.BT:GetRGB())
					btn.boss:SetTextColor(self.BT:GetRGB())
					self:addButtonBorder{obj=btn, relTo=btn.icon}
				end
			end)
			-- Model Frame
			self:keepFontStrings(this.info.model)
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
			for _, cBtn in _G.ipairs(this.info.creatureButtons) do
				skinCreatureBtn(cBtn)
			end
			-- hook this to skin additional buttons
			self:SecureHook("EncounterJournal_GetCreatureButton", function(index)
				if index > 9 then return end -- MAX_CREATURES_PER_ENCOUNTER
				skinCreatureBtn(_G.EncounterJournal.encounter.info.creatureButtons[index])
			end)
			-- Tabs (side)
			self:skinObject("tabs", {obj=this.info, tabs={this.info.overviewTab, this.info.lootTab, this.info.bossTab, this.info.modelTab}, fType=ftype, ignoreHLTex=false, ng=true, regions={4, 5, 6}, offsets={x1=9, y1=-6, x2=-6, y2=6}, track=false})
			self:moveObject{obj=this.info.overviewTab, x=12}

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(this.encounter)
		self:SecureHookScript(this.LootJournal, "OnShow", function(this)
			self:skinObject("slider", {obj=this.PowersFrame.ScrollBar, fType=ftype, x2=-4})
			for _, btn in _G.pairs(this.PowersFrame.elements) do
				btn.Background:SetTexture(nil)
			end
	 		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, fb=true, x1=-8, y1=6, x2=8, y2=-5})
			skinFilterBtn(this.ClassDropDownButton)
			skinFilterBtn(this.RuneforgePowerFilterDropDownButton)

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(this.LootJournal)

		self:Unhook(this, "OnShow")
	end)

	-- this is a frame NOT a GameTooltip
	self:SecureHookScript(_G.EncounterJournalTooltip, "OnShow", function(this)
		self:addSkinFrame{obj=this, ft=ftype}
		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].EquipmentFlyout = function(self)
	if not self.prdb.EquipmentFlyout or self.initialized.EquipmentFlyout then return end
	self.initialized.EquipmentFlyout = true

	-- Used by RuneForgeUI amongst others
	self:SecureHook("EquipmentFlyout_Show", function(_)
		for i = 1, _G.EquipmentFlyoutFrame.buttonFrame.numBGs do
			_G.EquipmentFlyoutFrame.buttonFrame["bg" .. i]:SetAlpha(0)
		end
		if self.modBtnBs then
			local btn
			for i = 1, #_G.EquipmentFlyoutFrame.buttons do
				btn = _G.EquipmentFlyoutFrame.buttons[i]
				self:addButtonBorder{obj=btn, shsh=true, ibt=true, reParent={btn.UpgradeIcon}}
				-- change 'Place In Bags' button border alpha & stop it changing
				if i == 1 then
					self:clrBtnBdr(btn, "grey")
					btn.sbb.SetBackdropBorderColor = _G.nop
				end
			end
			btn = nil
		end
	end)

	self:SecureHookScript(_G.EquipmentFlyoutFrame, "OnShow", function(this)
		self:skinObject("frame", {obj=this.buttonFrame, fType=ftype, ofs=2, x2=5, clr="white"})

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].FriendsFrame = function(self)
	if not self.prdb.FriendsFrame or self.initialized.FriendsFrame then return end
	self.initialized.FriendsFrame = true

	local function addTabBorder(frame)
		aObj:skinObject("frame", {obj=frame, fType=ftype, fb=true, x1=0, y1=-81, x2=1, y2=-1})
	end
	self:SecureHookScript(_G.FriendsFrame, "OnShow", function(this)
		self:skinObject("dropdown", {obj=_G.FriendsDropDown, fType=ftype})
		self:skinObject("dropdown", {obj=_G.TravelPassDropDown, fType=ftype})
		self:SecureHookScript(_G.FriendsTabHeader, "OnShow", function(this)
			_G.FriendsFrameBattlenetFrame:DisableDrawLayer("BACKGROUND")
			if self.modBtnBs then
				self:addButtonBorder{obj=_G.FriendsFrameBattlenetFrame.BroadcastButton, ofs=-2, x1=1}
			end
			-- .UnavailableInfoButton
			self:SecureHookScript(_G.FriendsFrameBattlenetFrame.BroadcastFrame, "OnShow", function(this)
				self:keepFontStrings(this.Border)
				this.EditBox:DisableDrawLayer("BACKGROUND")
				self:skinObject("editbox", {obj=this.EditBox, fType=ftype})
				self:moveObject{obj=this.EditBox.PromptText, x=5}
				self:adjHeight{obj=this.EditBox, adj=-6}
				self:skinObject("frame", {obj=this, fType=ftype, ofs=-10})
				if self.modBtns then
					self:skinStdButton{obj=this.UpdateButton}
					self:skinStdButton{obj=this.CancelButton}
				end

				self:Unhook(this, "OnShow")
			end)
			self:SecureHookScript(_G.FriendsFrameBattlenetFrame.UnavailableInfoFrame, "OnShow", function(this)
				self:removeNineSlice(this)
				self:skinObject("frame", {obj=this, fType=ftype})

				self:Unhook(this, "OnShow")
			end)
			self:skinObject("dropdown", {obj=_G.FriendsFrameStatusDropDown, fType=ftype})
			_G.FriendsFrameStatusDropDownStatus:SetAlpha(1) -- display status icon
			self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true, upwards=true, offsets={x1=1, y1=self.isTT and -4 or -8, x2=-1, y2=self.isTT and -4 or 1}})
			_G.RaiseFrameLevel(this)

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.FriendsTabHeader)
		self:SecureHookScript(_G.FriendsListFrame, "OnShow", function(this)
			_G.FriendsListFrameScrollFrame.PendingInvitesHeaderButton.BG:SetTexture(nil)
			self:skinObject("slider", {obj=_G.FriendsListFrameScrollFrame.Slider, fType=ftype})
			for _, btn in _G.pairs(_G.FriendsListFrameScrollFrame.buttons) do
				btn.background:SetAlpha(0)
				if self.modBtnBs then
					self:addButtonBorder{obj=btn, relTo=btn.gameIcon, ofs=0, clr="grey"}
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
					self:addButtonBorder{obj=btn.summonButton}
					for _, btn in _G.pairs{btn.travelPassButton, btn.summonButton} do
						self:SecureHook(btn, "Disable", function(this, _)
							self:clrBtnBdr(this)
						end)
						self:SecureHook(btn, "Enable", function(this, _)
							self:clrBtnBdr(this)
						end)
					end
				end
			end
			addTabBorder(this)
			if self.modBtns then
				self:skinStdButton{obj=_G.FriendsFrameAddFriendButton, x1=1}
				self:skinStdButton{obj=_G.FriendsFrameSendMessageButton}
				self:skinStdButton{obj=self:getChild(this.RIDWarning, 1)} -- unnamed parent frame
				for invite in _G.FriendsListFrameScrollFrame.invitePool:EnumerateActive() do
					self:skinStdButton{obj=invite.DeclineButton}
					self:skinStdButton{obj=invite.AcceptButton}
				end
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=_G.FriendsListFrameScrollFrame.PendingInvitesHeaderButton}
			end

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.FriendsListFrame)
		self:SecureHookScript(_G.IgnoreListFrame, "OnShow", function(this)
			self:skinObject("slider", {obj=_G.IgnoreListFrameScrollFrame.Slider, fType=ftype})
			addTabBorder(this)
			if self.modBtns then
				self:skinStdButton{obj=_G.FriendsFrameIgnorePlayerButton, x1=1}
				self:skinStdButton{obj=_G.FriendsFrameUnsquelchButton}
				self:SecureHook("IgnoreList_Update", function()
					self:clrBtnBdr(_G.FriendsFrameUnsquelchButton)
				end)
			end

			self:Unhook(this, "OnShow")
		end)
		self:SecureHookScript(_G.WhoFrame, "OnShow", function(this)
			self:removeInset(_G.WhoFrameListInset)
			self:skinColHeads("WhoFrameColumnHeader", nil, ftype)
			self:moveObject{obj=_G.WhoFrameColumnHeader4, x=4}
			self:skinObject("dropdown", {obj=_G.WhoFrameDropDown, fType=ftype})
			self:removeInset(_G.WhoFrameEditBoxInset)
			self:skinObject("editbox", {obj=_G.WhoFrameEditBox, fType=ftype})
			self:adjHeight{obj=_G.WhoFrameEditBox, adj=-8}
			self:moveObject{obj=_G.WhoFrameEditBox, y=6}
			self:skinObject("slider", {obj=_G.WhoListScrollFrame.Slider, fType=ftype})
			if self.modBtns then
				self:skinStdButton{obj=_G.WhoFrameGroupInviteButton}
				self:skinStdButton{obj=_G.WhoFrameAddFriendButton}
				self:skinStdButton{obj=_G.WhoFrameWhoButton}
				self:SecureHook("WhoList_Update", function()
					self:clrBtnBdr(_G.WhoFrameGroupInviteButton)
					self:clrBtnBdr(_G.WhoFrameAddFriendButton)
				end)
			end

			self:Unhook(this, "OnShow")
		end)
		self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true, offsets={x1=8, y1=self.isTT and 1 or -4, x2=-8, y2=4}})
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true, x2=3, y2=-3})
		self:add2Table(self.ttList, _G.FriendsTooltip)

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.AddFriendFrame, "OnShow", function(this)
		self:removeNineSlice(this.Border)
		self:skinObject("editbox", {obj=_G.AddFriendNameEditBox, fType=ftype})
		self:moveObject{obj=_G.AddFriendNameEditBoxFill, x=5}
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true})
		if self.modBtns then
			self:skinStdButton{obj=_G.AddFriendInfoFrameContinueButton}
			self:skinStdButton{obj=_G.AddFriendEntryFrameAcceptButton}
			self:skinStdButton{obj=_G.AddFriendEntryFrameCancelButton}
			self:SecureHookScript(_G.AddFriendNameEditBox, "OnTextChanged", function(_)
				self:clrBtnBdr(_G.AddFriendEntryFrameAcceptButton)
			end)
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.FriendsFriendsFrame, "OnShow", function(this)
		self:removeNineSlice(this.Border)
		self:skinObject("dropdown", {obj=_G.FriendsFriendsFrameDropDown, fType=ftype})
		self:removeBackdrop(this.ScrollFrameBorder)
		self:skinObject("slider", {obj=_G.FriendsFriendsScrollFrame.Slider, fType=ftype})
		self:skinObject("frame", {obj=this, fType=ftype})
		if self.modBtns then
			self:skinStdButton{obj=this.SendRequestButton}
			self:skinStdButton{obj=this.CloseButton}
			self:SecureHook(this, "Update", function(this)
				self:clrBtnBdr(this.SendRequestButton)
			end)
			self:SecureHook(this, "Reset", function(this)
				self:clrBtnBdr(this.SendRequestButton)
			end)
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.BattleTagInviteFrame, "OnShow", function(this)
		self:removeNineSlice(this.Border)
		self:skinObject("frame", {obj=this, fType=ftype, cb=true})
		if self.modBtns then
			self:skinStdButton{obj=self:getChild(this, 2)} -- SEND_REQUEST
			self:skinStdButton{obj=self:getChild(this, 3)} -- CANCEL
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.RecruitAFriendFrame, "OnShow", function(this)
		self:skinObject("dropdown", {obj=this.DropDown, fType=ftype, noSkin=true, x1=0, y1=0, x2=0, y2=0})
		this.RewardClaiming:DisableDrawLayer("BACKGROUND")
		self:nilTexture(this.RewardClaiming.NextRewardButton.IconBorder, true)
		self:removeInset(this.RewardClaiming.Inset)
		this.RecruitList.Header:DisableDrawLayer("BACKGROUND")
		self:removeInset(this.RecruitList.ScrollFrameInset)
		self:skinObject("slider", {obj=this.RecruitList.ScrollFrame.Slider, fType=ftype})
		this.SplashFrame.Description:SetTextColor(self.BT:GetRGB())
		self:skinObject("frame", {obj=this.SplashFrame, fType=ftype, ofs=2, y1=4, y2=-5})
		addTabBorder(this)
		if self.modBtns then
			self:skinStdButton{obj=this.RewardClaiming.ClaimOrViewRewardButton}
			self:skinStdButton{obj=this.RecruitmentButton}
			self:skinStdButton{obj=this.SplashFrame.OKButton}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.RecruitAFriendRewardsFrame, "OnShow", function(this)
		this:DisableDrawLayer("BACKGROUND")
		self:skinObject("frame", {obj=this.Border, fType=ftype, kfs=true, ofs=-8})
		if self.modBtns then
			self:skinCloseButton{obj=this.CloseButton}
		end
		if self.modBtnBs then
			for reward in this.rewardPool:EnumerateActive() do
				self:addButtonBorder{obj=reward.Button, clr="sepia"}
			end
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.RecruitAFriendRecruitmentFrame, "OnShow", function(this)
		self:skinObject("editbox", {obj=this.EditBox, fType=ftype})
		self:adjHeight{obj=this.EditBox, adj=-6}
		self:skinObject("frame", {obj=this.Border, fType=ftype, kfs=true, ofs=-8})
		if self.modBtns then
			self:skinCloseButton{obj=this.CloseButton}
			self:skinStdButton{obj=this.GenerateOrCopyLinkButton}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.QuickJoinFrame, "OnShow", function(this)
		self:skinObject("dropdown", {obj=_G.QuickJoinFrameDropDown, fType=ftype})
		self:skinObject("slider", {obj=this.ScrollFrame.scrollBar, fType=ftype, rpTex="background"})
		self:removeMagicBtnTex(this.JoinQueueButton)
		if self.modBtns then
			self:skinStdButton{obj=this.JoinQueueButton, x2=0}
			self:SecureHook(this, "UpdateJoinButtonState", function(this)
				self:clrBtnBdr(this.JoinQueueButton)
			end)
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.QuickJoinRoleSelectionFrame, "OnShow", function(this)
		self:removeNineSlice(this.Border)
		self:skinObject("frame", {obj=this, fType=ftype, cb=true, ofs=-5})
		if self.modBtns then
			self:skinStdButton{obj=this.AcceptButton}
			self:skinStdButton{obj=this.CancelButton}
		end
		if self.modChkBtns then
			for _, btn in _G.pairs(_G.QuickJoinRoleSelectionFrame.Roles) do
				self:skinCheckButton{obj=btn.CheckButton}
			end
		end

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
		self:SecureHook("GuildControlUI_RankOrder_Update", function(_)
			skinROFrames()
		end)
		skinROFrames()

		self:SecureHookScript(this.rankPermFrame, "OnShow", function(this)
			this:DisableDrawLayer("BACKGROUND")
			self:skinDropDown{obj=this.dropdown}
			_G.UIDropDownMenu_SetButtonWidth(this.dropdown, 24)
			self:skinEditBox{obj=this.goldBox, regs={6}}
			if self.modChkBtns then
				for _, child in _G.ipairs{this:GetChildren()} do
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

aObj.blizzLoDFrames[ftype].GuildUI = function(self)
	if not self.prdb.GuildUI or self.initialized.GuildUI then return end
	self.initialized.GuildUI = true

	-- N.B. use command /groster to show frames

	self:SecureHookScript(_G.GuildFrame, "OnShow", function(this)
		this.TopTileStreaks:SetTexture(nil)
		self:moveObject{obj=_G.GuildFrameTabardBackground, x=8, y=-11}
		self:moveObject{obj=_G.GuildFrameTabardEmblem, x=9, y=-12}
		self:moveObject{obj=_G.GuildFrameTabardBorder, x=7, y=-10}
		self:skinObject("dropdown", {obj=_G.GuildDropDown, fType=ftype})
		_G.GuildPointFrame.LeftCap:SetTexture(nil)
		_G.GuildPointFrame.RightCap:SetTexture(nil)
		_G.GuildFactionBar:DisableDrawLayer("BORDER")
		_G.GuildFactionBarProgress:SetTexture(self.sbTexture)
		_G.GuildFactionBarShadow:SetAlpha(0)
		_G.GuildFactionBarCap:SetTexture(self.sbTexture)
		_G.GuildFactionBarCapMarker:SetAlpha(0)
		self:skinObject("editbox", {obj=_G.GuildNameChangeFrame.editBox, fType=ftype})
		if self.modBtns then
			-- N.B. NO CloseButton for GuildNameChangeAlertFrame
			self:skinStdButton{obj=_G.GuildNameChangeFrame.button}
		end
		self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true, offsets={x1=8, y1=self.isTT and 2 or -4, x2=-8, y2=2}})
		if self.isTT then
			_G.PanelTemplates_UpdateTabs(this)
		end
		self:skinObject("frame", {obj=this, fType=ftype, ri=true, rns=true, cb=true, ofs=3, y1=2, y2=-2})

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.GuildPerksFrame, "OnShow", function(this)
		_G.GuildAllPerksFrame:DisableDrawLayer("BACKGROUND")
		for _, btn in _G.pairs(_G.GuildPerksContainer.buttons) do
			-- can't use DisableDrawLayer as the update code uses it
			self:removeRegions(btn, {1, 2, 3, 4})
			btn.normalBorder:DisableDrawLayer("BACKGROUND")
			btn.disabledBorder:DisableDrawLayer("BACKGROUND")
			if self.modBtnBs then
				self:addButtonBorder{obj=btn, relTo=btn.icon, reParent={btn.lock}}
			end
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.GuildRosterFrame, "OnShow", function(this)
		self:skinObject("dropdown", {obj=_G.GuildRosterViewDropdown, fType=ftype})
		self:skinColHeads("GuildRosterColumnButton", 5, ftype)
		self:skinObject("slider", {obj=_G.GuildRosterContainerScrollBar, fType=ftype})
		for _, btn in _G.pairs(_G.GuildRosterContainer.buttons) do
			btn:DisableDrawLayer("BACKGROUND")
			btn.barTexture:SetTexture(self.sbTexture)
			btn.header.leftEdge:SetAlpha(0)
			btn.header.rightEdge:SetAlpha(0)
			btn.header.middle:SetAlpha(0)
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.GuildRosterShowOfflineButton, fType=ftype}
		end
		self:SecureHook("GuildRoster_UpdateTradeSkills", function()
			for _, btn in _G.pairs(_G.GuildRosterContainer.buttons) do
				if btn.header:IsShown() then
					btn.string1:Hide()
					btn.string2:Hide()
					btn.string3:Hide()
				else
					btn.string1:Show()
					btn.string2:Show()
					btn.string3:Show()
				end
			end
		end)
		-- GuildMemberDetailFrame
		self:skinObject("dropdown", {obj=_G.GuildMemberRankDropdown, fType=ftype})
		self:skinObject("frame", {obj=_G.GuildMemberNoteBackground, fType=ftype, kfs=true, fb=true, ofs=0})
		self:skinObject("frame", {obj=_G.GuildMemberOfficerNoteBackground, fType=ftype, kfs=true, fb=true, ofs=0})
		self:skinObject("frame", {obj=_G.GuildMemberDetailFrame, fType=ftype, kfs=true, ofs=-6})
		if self.modBtns then
			self:skinStdButton{obj=_G.GuildMemberRemoveButton, fType=ftype}
			self:skinStdButton{obj=_G.GuildMemberGroupInviteButton, fType=ftype}
			self:skinCloseButton{obj=_G.GuildMemberDetailCloseButton, fType=ftype}
			self:SecureHook("GuildRoster_Update", function()
				self:clrBtnBdr(_G.GuildMemberRemoveButton)
				self:clrBtnBdr(_G.GuildMemberGroupInviteButton)
			end)
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.GuildNewsFrame, "OnShow", function(this)
		this:DisableDrawLayer("BACKGROUND")
		self:skinObject("slider", {obj=_G.GuildNewsContainerScrollBar, fType=ftype})
		for _, btn in _G.pairs(_G.GuildNewsContainer.buttons) do
			btn.header:SetAlpha(0)
		end
		self:skinObject("dropdown", {obj=_G.GuildNewsDropDown, fType=ftype})
		-- hook this to stop tooltip flickering
		self:SecureHook("GuildNewsButton_OnEnter", function(btn)
			if btn.UpdateTooltip then
				btn.UpdateTooltip = nil
			end
		end)

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.GuildNewsFiltersFrame, "OnShow", function(this)
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, ofs=-7})
		if self.modChkBtns then
			self:skinCheckButton{obj=this.GuildAchievement, fType=ftype}
			self:skinCheckButton{obj=this.Achievement, fType=ftype}
			self:skinCheckButton{obj=this.DungeonEncounter, fType=ftype}
			self:skinCheckButton{obj=this.EpicItemLooted, fType=ftype}
			self:skinCheckButton{obj=this.EpicItemPurchased, fType=ftype}
			self:skinCheckButton{obj=this.EpicItemCrafted, fType=ftype}
			self:skinCheckButton{obj=this.LegendaryItemLooted, fType=ftype}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.GuildNewsBossModel, "OnShow", function(this)
		self:keepFontStrings(_G.GuildNewsBossModelTextFrame)
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ofs=4, y2=-81})

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.GuildRewardsFrame, "OnShow", function(this)
		this:DisableDrawLayer("BACKGROUND")
		self:skinObject("slider", {obj=_G.GuildRewardsContainerScrollBar, fType=ftype})
		for i = 1, #_G.GuildRewardsContainer.buttons do
			_G.GuildRewardsContainer.buttons[i]:GetNormalTexture():SetAlpha(0)
			_G.GuildRewardsContainer.buttons[i].disabledBG:SetAlpha(0)
			if self.modBtnBs then
				self:addButtonBorder{obj=_G.GuildRewardsContainer.buttons[i], relTo=_G.GuildRewardsContainer.buttons[i].icon, reParent={_G.GuildRewardsContainer.buttons[i].lock}}
			end
		end
		self:skinObject("dropdown", {obj=_G.GuildRewardsDropDown, fType=ftype})

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.GuildInfoFrame, "OnShow", function(this)
		self:removeRegions(this, {1, 2, 3, 4, 5, 6 ,7, 8}) -- Background textures and bars
		self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true, upwards=true, offsets={x1=2, y1=-5, x2=2, y2=self.isTT and -5 or 0}})
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, fb=true, x1=-4, y1=1, x2=7, y2=0})

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.GuildInfoFrameInfo, "OnShow", function(this)
		self:keepFontStrings(this)
		self:skinObject("slider", {obj=_G.GuildInfoDetailsFrame.ScrollBar, fType=ftype})
		self:removeMagicBtnTex(_G.GuildAddMemberButton)
		self:removeMagicBtnTex(_G.GuildControlButton)
		self:removeMagicBtnTex(_G.GuildViewLogButton)
		if self.modBtns then
			self:skinStdButton{obj=_G.GuildAddMemberButton, fType=ftype}
			self:skinStdButton{obj=_G.GuildControlButton, fType=ftype}
			self:skinStdButton{obj=_G.GuildViewLogButton, fType=ftype}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.GuildInfoFrameRecruitment, "OnShow", function(this)
		_G.GuildRecruitmentInterestFrameBg:SetAlpha(0)
		_G.GuildRecruitmentAvailabilityFrameBg:SetAlpha(0)
		_G.GuildRecruitmentRolesFrameBg:SetAlpha(0)
		_G.GuildRecruitmentLevelFrameBg:SetAlpha(0)
		_G.GuildRecruitmentCommentFrameBg:SetAlpha(0)
		self:skinObject("slider", {obj=_G.GuildRecruitmentCommentInputFrameScrollFrame.ScrollBar, fType=ftype})
		self:skinObject("frame", {obj=_G.GuildRecruitmentCommentInputFrame, fType=ftype, kfs=true, fb=true, ofs=0})
		self:removeMagicBtnTex(_G.GuildRecruitmentListGuildButton)
		if self.modBtns then
			self:skinStdButton{obj=_G.GuildRecruitmentListGuildButton, fType=ftype}
			self:SecureHook("GuildRecruitmentListGuildButton_Update", function()
				self:clrBtnBdr(_G.GuildRecruitmentListGuildButton)
			end)
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.GuildRecruitmentQuestButton, fType=ftype}
			self:skinCheckButton{obj=_G.GuildRecruitmentRaidButton, fType=ftype}
			self:skinCheckButton{obj=_G.GuildRecruitmentDungeonButton, fType=ftype}
			self:skinCheckButton{obj=_G.GuildRecruitmentPvPButton, fType=ftype}
			self:skinCheckButton{obj=_G.GuildRecruitmentRPButton, fType=ftype}
			self:skinCheckButton{obj=_G.GuildRecruitmentWeekdaysButton, fType=ftype}
			self:skinCheckButton{obj=_G.GuildRecruitmentWeekendsButton, fType=ftype}
			self:skinCheckButton{obj=_G.GuildRecruitmentTankButton.checkButton, fType=ftype}
			self:skinCheckButton{obj=_G.GuildRecruitmentHealerButton.checkButton, fType=ftype}
			self:skinCheckButton{obj=_G.GuildRecruitmentDamagerButton.checkButton, fType=ftype}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.GuildInfoFrameApplicants, "OnShow", function(this)
		for _, btn in _G.pairs(_G.GuildInfoFrameApplicantsContainer.buttons) do
			-- self:applySkin{obj=btn}
			btn.ring:SetAlpha(0)
			btn.PointsSpentBgGold:SetAlpha(0)
			-- self:moveObject{obj=btn.PointsSpentBgGold, x=6, y=-6}
		end
		self:skinObject("slider", {obj=_G.GuildInfoFrameApplicantsContainerScrollBar, fType=ftype})
		self:removeMagicBtnTex(_G.GuildRecruitmentInviteButton)
		self:removeMagicBtnTex(_G.GuildRecruitmentMessageButton)
		self:removeMagicBtnTex(_G.GuildRecruitmentDeclineButton)
		if self.modBtns then
			self:skinStdButton{obj=_G.GuildRecruitmentInviteButton, fType=ftype}
			self:skinStdButton{obj=_G.GuildRecruitmentMessageButton, fType=ftype}
			self:skinStdButton{obj=_G.GuildRecruitmentDeclineButton, fType=ftype}
			self:SecureHook("GuildInfoFrameApplicants_Update", function()
				self:clrBtnBdr(_G.GuildRecruitmentInviteButton)
				self:clrBtnBdr(_G.GuildRecruitmentMessageButton)
				self:clrBtnBdr(_G.GuildRecruitmentDeclineButton)
			end)
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.GuildTextEditFrame, "OnShow", function(this)
		self:skinObject("slider", {obj=_G.GuildTextEditScrollFrame.ScrollBar, fType=ftype})
		self:skinObject("frame", {obj=_G.GuildTextEditContainer, fType=ftype, kfs=true, fb=true})
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, ofs=-7})
		if self.modBtns then
			self:skinStdButton{obj=_G.GuildTextEditFrameAcceptButton, fType=ftype}
			self:skinStdButton{obj=self:getChild(_G.GuildTextEditFrame, 4), fType=ftype} -- bottom close button
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.GuildLogFrame, "OnShow", function(this)
		self:skinObject("slider", {obj=_G.GuildLogScrollFrame.ScrollBar, fType=ftype})
		self:skinObject("frame", {obj=_G.GuildLogContainer, fType=ftype, kfs=true, fb=true})
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, ofs=-7})
		if self.modBtns then
			self:skinStdButton{obj=self:getChild(this, 3), fType=ftype} -- bottom close button
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzLoDFrames[ftype].InspectUI = function(self)
	if not self.prdb.InspectUI or self.initialized.InspectUI then return end
	self.initialized.InspectUI = true

	self:SecureHookScript(_G.InspectFrame, "OnShow", function(this)
		self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true, offsets={x1=9, y1=self.isTT and 2 or -3, x2=-9, y2=2}})
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true})
		-- send message when UI is skinned (used by oGlow skin)
		self:SendMessage("InspectUI_Skinned", self)

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.InspectPaperDollFrame, "OnShow", function(this)
		_G.InspectModelFrame:DisableDrawLayer("BACKGROUND")
		_G.InspectModelFrame:DisableDrawLayer("BORDER")
		_G.InspectModelFrame:DisableDrawLayer("OVERLAY")
		_G.InspectModelFrame.controlFrame:DisableDrawLayer("BACKGROUND")
		if self.modBtns then
			self:skinStdButton{obj=this.ViewButton}
		end
		if self.modBtnBs then
			self:SecureHook("InspectPaperDollItemSlotButton_Update", function(btn)
				if not btn.hasItem then
					self:clrBtnBdr(btn, "grey")
					btn.icon:SetTexture(nil)
				end
			end)
		end
		for _, btn in _G.ipairs{_G.InspectPaperDollItemsFrame:GetChildren()} do
			btn:DisableDrawLayer("BACKGROUND")
			if self.modBtnBs then
				self:addButtonBorder{obj=btn, ibt=true, clr="grey"}
			end
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.InspectPVPFrame, "OnShow", function(this)
		self:keepFontStrings(this)
		for _, slot in _G.ipairs(this.Slots) do
			slot.Border:SetTexture(nil)
			self:makeIconSquare(slot, "Texture")
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
		self:makeIconSquare(this.InspectSpec, "specIcon")
		for i = 1, _G.MAX_TALENT_TIERS do
			for j = 1, _G.NUM_TALENT_COLUMNS do
				this.InspectTalents["tier" .. i]["talent" .. j].Slot:SetTexture(nil)
				if self.modBtnBs then
					this.InspectTalents["tier" .. i]["talent" .. j].border:SetAlpha(0)
					self:addButtonBorder{obj=this.InspectTalents["tier" .. i]["talent" .. j], relTo=this.InspectTalents["tier" .. i]["talent" .. j].icon, clr="grey"}
				end
			end
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.InspectGuildFrame, "OnShow", function(this)
		_G.InspectGuildFrameBG:SetAlpha(0)
		this.Points:DisableDrawLayer("BACKGROUND")

		self:Unhook(this, "OnShow")
	end)

end

-- copy of GEM_TYPE_INFO from Blizzard_ItemSocketingUI.xml
aObj.GEM_TYPE_INFO = {
	Yellow          = {r=0.97 , g=0.82 , b=0.29},
	Red             = {r=1 , g=0.47 , b=0.47},
	Blue            = {r=0.47 , g=0.67 , b=1},
	PunchcardYellow = {r=0.97 , g=0.82 , b=0.29},
	PunchcardRed    = {r=1 , g=0.47 , b=0.47},
	PunchcardBlue   = {r=0.47 , g=0.67 , b=1},
	Hydraulic       = {r=1, g=1, b=1},
	Cogwheel        = {r=1, g=1, b=1},
	Meta            = {r=1, g=1, b=1},
	Prismatic       = {r=1, g=1, b=1},
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

	self:skinObject("tabs", {obj=_G.LookingForGuildFrame, prefix="LookingForGuildFrame", fType=ftype, lod=self.isTT and true, upwards=true, offsets={x1=0, y1=-5, x2=3, y2=-5}, func=function(tab) _G.RaiseFrameLevelByTwo(tab) end})
	self:addSkinFrame{obj=_G.LookingForGuildFrame, ft=ftype, kfs=true, ri=true}

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
		self:addFrameBorder{obj=this, ft=ftype, x1=-5, y1=2, x2=7, y2=-28}

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
		self:addFrameBorder{obj=this, ft=ftype, x1=-5, y1=2, x2=7, y2=-28}

		self:Unhook(this, "OnShow")
	end)

	-- Requests
	self:SecureHookScript(_G.LookingForGuildAppsFrame, "OnShow", function(this)
		self:skinSlider{obj=_G.LookingForGuildAppsFrameContainerScrollBar}
		for i = 1, #_G.LookingForGuildAppsFrameContainer.buttons do
			self:applySkin{obj=_G.LookingForGuildAppsFrameContainer.buttons[i]}
		end
		self:addFrameBorder{obj=this, ft=ftype, x1=-5, y1=2, x2=7, y2=-28}

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
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true}
		if self.modBtnBs then
			self:SecureHook("LootFrame_Update", function()
				for i = 1, _G.LOOTFRAME_NUMBUTTONS do
					if _G["LootButton" .. i].quality then
						_G.SetItemButtonQuality(_G["LootButton" .. i], _G["LootButton" .. i].quality)
					end
				end
			end)
			self:addButtonBorder{obj=_G.LootFrameDownButton, ofs=-2, clr="gold"}
			self:addButtonBorder{obj=_G.LootFrameUpButton, ofs=-2, clr="gold"}
		end

		self:Unhook(this, "OnShow")
	end)

	local function skinGroupLoot(frame)

		frame:DisableDrawLayer("BACKGROUND")
		frame:DisableDrawLayer("BORDER")
		if aObj.isClsc then
			local fName = frame:GetName()
			_G[fName .. "SlotTexture"]:SetTexture(nil)
			_G[fName .. "NameFrame"]:SetTexture(nil)
			_G[fName .. "Corner"]:SetAlpha(0)
			frame.Timer:DisableDrawLayer("ARTWORK")
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=frame, relTo=frame.Icon, reParent={frame.Count}}
			end
			fName = nil
		end
		aObj:skinStatusBar{obj=frame.Timer, fi=0, bgTex=frame.Timer.Background}
		-- hook this to show the Timer
		aObj:secureHook(frame, "Show", function(this)
			this.Timer:SetFrameLevel(this:GetFrameLevel() + 1)
		end)

		frame:SetScale(aObj.prdb.LootFrames.size ~= 1 and 0.75 or 1)
		if not aObj.isClsc then
			frame.IconFrame.Border:SetAlpha(0)
		end
		if aObj.modBtns then
			aObj:skinCloseButton{obj=frame.PassButton}
		end
		if aObj.prdb.LootFrames.size ~= 3 then -- Normal or small
			aObj:addSkinFrame{obj=frame, ft=ftype, x1=-3, y2=-3} -- adjust for Timer
		else -- Micro
			aObj:moveObject{obj=frame.IconFrame, x=95, y=5}
			frame.Name:SetAlpha(0)
			frame.NeedButton:ClearAllPoints()
			frame.NeedButton:SetPoint("TOPRIGHT", "$parent", "TOPRIGHT", -34, -4)
			frame.PassButton:ClearAllPoints()
			frame.PassButton:SetPoint("LEFT", frame.NeedButton, "RIGHT", 0, 2)
			frame.GreedButton:ClearAllPoints()
			frame.GreedButton:SetPoint("RIGHT", frame.NeedButton, "LEFT")
			if not self.isClsc then
				frame.DisenchantButton:ClearAllPoints()
				frame.DisenchantButton:SetPoint("RIGHT", frame.GreedButton, "LEFT", 2, 0)
			end
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

	self:SecureHookScript(_G.MasterLooterFrame, "OnShow", function(this)
		this:DisableDrawLayer("BACKGROUND")
		this.Item.NameBorderLeft:SetTexture(nil)
		this.Item.NameBorderRight:SetTexture(nil)
		this.Item.NameBorderMid:SetTexture(nil)
		this.Item.IconBorder:SetTexture(nil)
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true}
		if self.modBtns then
			 self:skinCloseButton{obj=self:getChild(this, 3)} -- unamed close button
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=this.Item, relTo=this.Item.Icon}
		end

		self:Unhook(this, "OnShow")
	end)

	if not self.isClsc then
		self:SecureHookScript(_G.BonusRollFrame, "OnShow", function(this)
			self:removeRegions(this, {1, 2, 3, 5})
			self:skinStatusBar{obj=this.PromptFrame.Timer, fi=0}
			self:addSkinFrame{obj=this, ft=ftype, bg=true}
			if self.modBtnBs then
				 self:addButtonBorder{obj=this.PromptFrame, relTo=this.PromptFrame.Icon, reParent={this.SpecIcon}}
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
	end

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

	if not self.isClsc then
		-- Battleground/Arena/Island Expeditions Start Timer
		local function skinTT(timer)

			if not aObj.sbGlazed[timer.bar] then
				_G[timer.bar:GetName() .. "Border"]:SetTexture(nil) -- animations
				aObj:skinStatusBar{obj=timer.bar, fi=0}
			end

		end
		self:SecureHook("StartTimer_SetGoTexture", function(timer)
			skinTT(timer)
		end)
		-- skin existing timers
		for _, timer in _G.pairs(_G.TimerTracker.timerList) do
			skinTT(timer)
		end
	end

end

aObj.blizzFrames[ftype].ObjectiveTracker = function(self)
	if not self.prdb.ObjectiveTracker.skin
	and not self.prdb.ObjectiveTracker.popups
	and not self.prdb.ObjectiveTracker.headers
	then
		return
	end
	self.initialized.ObjectiveTracker = true

	-- ObjectiveTrackerFrame BlocksFrame
	if self.prdb.ObjectiveTracker.skin then
		self:skinObject("frame", {obj=_G.ObjectiveTrackerFrame.BlocksFrame, fType=ftype, kfs=true, x1=-30, x2=4})
	end

	-- AutoPopup frames
	if self.prdb.ObjectiveTracker.popups then
		local function skinAutoPopUps(owningModule)
			if _G.SplashFrame:IsShown() then
				return
			end
			local questID, popUpType, questTitle, block
			for i = 1, _G.GetNumAutoQuestPopUps() do
				questID, popUpType = _G.GetAutoQuestPopUp(i)
				if not _G.C_QuestLog.IsQuestBounty(questID)
				and owningModule:ShouldDisplayQuest(_G.QuestCache:Get(questID))
				then
					questTitle = _G.C_QuestLog.GetTitleForQuestID(questID)
					if questTitle
					and questTitle ~= ""
					then
						block = owningModule:GetBlock(questID, "ScrollFrame", "AutoQuestPopUpBlockTemplate")
						if not block.module.hasSkippedBlocks then
							if block.init then
								aObj:skinObject("frame", {obj=block.ScrollChild, kfs=true, fType=ftype, ofs=0, x1=33})
								block.ScrollChild.Exclamation:SetAlpha(1)
								block.ScrollChild.QuestionMark:SetAlpha(1)
							end
						end
						if popUpType == "COMPLETE" then
							block.ScrollChild.QuestionMark:Show()
						else
							block.ScrollChild.Exclamation:Show()
						end
					end
				end
			end
			questID, popUpType, questTitle, block = nil, nil, nil, nil
		end
		self:SecureHook("AutoQuestPopupTracker_Update", function(owningModule)
			skinAutoPopUps(owningModule)
		end)
		skinAutoPopUps(_G.QUEST_TRACKER_MODULE)
	end

	-- Toghast Anima Powers frame
	if self.prdb.ObjectiveTracker.animapowers then
		self:SecureHookScript(_G.ScenarioBlocksFrame.MawBuffsBlock, "OnShow", function(this)
			self:skinObject("frame", {obj=this.Container.List, fType=ftype, kfs=true, ofs=-4, y1=-10, y2=10})
			self.modUIBtns:skinStdButton{obj=this.Container, ignoreHLTex=true, ofs=-9, x1=12, x2=-2} -- use module, treat like a frame
			this.Container.SetWidth = _G.nop
			this.Container.SetHighlightAtlas = _G.nop
			self:SecureHook(this.Container, "UpdateListState", function(this, _)
				self:clrBtnBdr(this)
			end)

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.ScenarioBlocksFrame.MawBuffsBlock)
	end

	if not self.prdb.ObjectiveTracker.headers then
		return
	end

	local skinMinBtn
	if self.modBtnBs then
		 function skinMinBtn(btn)
			-- FIXME: adding a button border to the minimize button causes ADDON_ACTION_FORBIDDEN event [16.04.21]
			-- aObj:addButtonBorder{obj=btn, es=12, ofs=1, x1=-1}
		end
	end
	-- remove Glow/Sheen textures from WorldQuest modules
	local function updTrackerModules()
		for _, module in _G.pairs(_G.ObjectiveTrackerFrame.MODULES) do
			if module.ShowWorldQuests then
				for _, blk in _G.pairs(module.usedBlocks) do
					if blk.ScrollContents then
						for _, child in _G.pairs{blk.ScrollContents:GetChildren()} do
							if child.Glow then
								child.Glow:SetTexture(nil)
								child.Sheen:SetTexture(nil)
							end
						end
					end
				end
			end
			if aObj.modBtnBs then
				if module.Header
				and module.Header.MinimizeButton
				then
					skinMinBtn(module.Header.MinimizeButton)
				end
			end
		end
	end
	updTrackerModules() -- update any existing modules
	-- hook this to handle new modules & displaying the ObjectiveTrackerFrame BlocksFrame skin frame
	self:SecureHook("ObjectiveTracker_Update", function(_)
		-- aObj:Debug("ObjectiveTracker_Update: [%s, %s]", reason, id)
		updTrackerModules()
		if _G.ObjectiveTrackerFrame.BlocksFrame.sf then
			_G.ObjectiveTrackerFrame.BlocksFrame.sf:SetShown(_G.ObjectiveTrackerFrame.HeaderMenu:IsShown())
		end
	end)

	self:skinDropDown{obj=_G.ObjectiveTrackerFrame.BlockDropDown}

	if self.modBtnBs then
		skinMinBtn(_G.ObjectiveTrackerFrame.HeaderMenu.MinimizeButton)
		-- hook this to skin QuestObjective Block Button(s)
		local function aBB2rB(btn)
			aObj:addButtonBorder{obj=btn, shsh=true, ofs=btn.Icon and -2 or nil, x1=btn.Icon and 0 or nil, reParent=btn.Count and {btn.Count} or nil, clr="gold"}
		end
		self:SecureHook("QuestObjectiveSetupBlockButton_AddRightButton", function(_, button, _)
			aBB2rB(button)
		end)
		-- skin existing buttons
		for _, mod in _G.pairs(_G.ObjectiveTrackerFrame.MODULES) do
			for _, blk in _G.pairs(mod.usedBlocks) do
				if blk.rightButton then
					aBB2rB(blk.rightButton)
				end
			end
		end
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
	local function skinBars(table)
		for _, block in _G.pairs(table) do
			for _, line in _G.pairs(block) do
				skinBar(line)
			end
		end
	end
	-- skin existing Timer & Progress bars
	for _, module in _G.pairs(_G.ObjectiveTrackerFrame.MODULES) do
		if module.usedTimerBars then
			skinBars(module.usedTimerBars)
			if module.AddTimerBar then
				self:SecureHook(module, "AddTimerBar", function(this, block, line, _)
					skinBar(this.usedTimerBars[block] and this.usedTimerBars[block][line])
				end)
			end
		end
		if module.usedProgressBars then
			skinBars(module.usedProgressBars)
			if module.AddProgressBar then
				self:SecureHook(module, "AddProgressBar", function(this, block, line, _)
					skinBar(this.usedProgressBars[block] and this.usedProgressBars[block][line])
				end)
			end
		end
	end

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
	self:SecureHook("ScenarioObjectiveTracker_AnimateReward", function(_)
		_G.ObjectiveTrackerScenarioRewardsFrame:DisableDrawLayer("ARTWORK")
		_G.ObjectiveTrackerScenarioRewardsFrame:DisableDrawLayer("BORDER")
		skinRewards(_G.ObjectiveTrackerScenarioRewardsFrame)
	end)

	-- ScenarioObjectiveBlock
	skinBars(_G.SCENARIO_TRACKER_MODULE.usedProgressBars)
	self:SecureHook(_G.SCENARIO_TRACKER_MODULE, "AddProgressBar", function(this, block, line, _)
		skinBar(this.usedProgressBars[block] and this.usedProgressBars[block][line])
	end)

	self:SecureHookScript(_G.ScenarioStageBlock, "OnShow", function(this)
		self:nilTexture(this.NormalBG, true)
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, y1=-1, x2=41, y2=7})

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.ScenarioStageBlock)

	self:SecureHookScript(_G.ScenarioChallengeModeBlock, "OnShow", function(this)
		self:skinStatusBar{obj=this.StatusBar, fi=0, bgTex=this.TimerBG, otherTex={this.TimerBGBack}}
		self:removeRegions(this, {3}) -- challengemode-timer atlas
		self:skinObject("frame", {obj=this, fType=ftype, y2=7})
		self:SecureHook("Scenario_ChallengeMode_SetUpAffixes", function(block, _)
			for _, affix in _G.pairs(block.Affixes) do
				affix.Border:SetTexture(nil)
			end
		end)

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.ScenarioChallengeModeBlock)

	self:SecureHookScript(_G.ScenarioProvingGroundsBlock, "OnShow", function(this)
		this.BG:SetTexture(nil)
		this.GoldCurlies:SetTexture(nil)
		self:skinStatusBar{obj=this.StatusBar, fi=0}
		self:removeRegions(this.StatusBar, {1}) -- border
		_G.ScenarioProvingGroundsBlockAnim.BorderAnim:SetTexture(nil)
		self:skinObject("frame", {obj=this, fType=ftype, x2=41})

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.ScenarioProvingGroundsBlock)

	-- remove Shadow texture
	_G.BONUS_OBJECTIVE_TRACKER_MODULE.Header:DisableDrawLayer("BACKGROUND")
	_G.WORLD_QUEST_TRACKER_MODULE.Header:DisableDrawLayer("BACKGROUND")
	-- remove Header backgrounds
	_G.ObjectiveTrackerFrame.BlocksFrame.AchievementHeader.Background:SetTexture(nil)
	_G.ObjectiveTrackerFrame.BlocksFrame.CampaignQuestHeader.Background:SetTexture(nil)
	_G.ObjectiveTrackerFrame.BlocksFrame.QuestHeader.Background:SetTexture(nil)
	_G.ObjectiveTrackerFrame.BlocksFrame.ScenarioHeader.Background:SetTexture(nil)
	_G.BONUS_OBJECTIVE_TRACKER_MODULE.Header.Background:SetTexture(nil)
	_G.WORLD_QUEST_TRACKER_MODULE.Header.Background:SetTexture(nil)

	_G.ObjectiveTrackerBonusRewardsFrame:DisableDrawLayer("ARTWORK")
	_G.ObjectiveTrackerBonusRewardsFrame.RewardsShadow:SetTexture(nil)

	_G.ObjectiveTrackerWorldQuestRewardsFrame:DisableDrawLayer("ARTWORK")
	_G.ObjectiveTrackerWorldQuestRewardsFrame.RewardsShadow:SetTexture(nil)

	_G.ObjectiveTrackerBonusBannerFrame.BG1:SetTexture(nil)
	_G.ObjectiveTrackerBonusBannerFrame.BG2:SetTexture(nil)

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

		self:SecureHook(this, "Show", function(this, _)
			skinOverrideActionBar(this)
		end)
		if this:IsShown() then
			skinOverrideActionBar(this)
		end
		self:SecureHook("OverrideActionBar_SetSkin", function(_)
			skinOverrideActionBar(this)
		end)

		self:Unhook(this, "OnShow")

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

aObj.blizzLoDFrames[ftype].PVPUI = function(self)
	if not self.prdb.PVPUI or self.initialized.PVPUI then return end
	self.initialized.PVPUI = true

	self:SecureHookScript(_G.PVPQueueFrame, "OnShow", function(this)
		for i = 1, 3 do
			this["CategoryButton" .. i].Background:SetTexture(nil)
			this["CategoryButton" .. i].Ring:SetTexture(nil)
			self:changeRecTex(this["CategoryButton" .. i]:GetHighlightTexture())
			-- make Icon square
			self:makeIconSquare(this["CategoryButton" .. i], "Icon")
		end
		if self.modBtnBs then
			-- hook this to change button border colour
			self:SecureHook("PVPQueueFrame_SetCategoryButtonState", function(btn, _)
				self:clrBtnBdr(btn)
			end)
		end
		-- hook this to change selected texture
		self:SecureHook("PVPQueueFrame_SelectButton", function(index)
			for i = 1, 3 do
				if i == index then
					self:changeRecTex(this["CategoryButton" .. i].Background, true)
				else
					this["CategoryButton" .. i].Background:SetTexture(nil)
				end
			end
		end)
		_G.PVPQueueFrame_SelectButton(1) -- select Honor button
		self:removeInset(this.HonorInset)
		this.HonorInset:DisableDrawLayer("BACKGROUND")
		local hld = this.HonorInset.CasualPanel.HonorLevelDisplay
		hld:DisableDrawLayer("BORDER")
		self:removeRegions(hld.NextRewardLevel, {2, 4}) -- IconCover & RingBorder
		if self.modBtnBs then
			self:addButtonBorder{obj=hld.NextRewardLevel, relTo=hld.NextRewardLevel.RewardIcon, clr="white", ca=0.75}
			self:SecureHook(hld, "Update", function(this)
				if this.NextRewardLevel.RewardIcon:IsDesaturated() then
					self:clrBtnBdr(this.NextRewardLevel, "disabled")
				else
					self:clrBtnBdr(this.NextRewardLevel, "white", 0.75)
				end

			end)
		end
		this.HonorInset.RatedPanel.WeeklyChest.FlairTexture:SetTexture(nil)
		local srf =this.HonorInset.RatedPanel.SeasonRewardFrame
		srf.Ring:SetTexture(nil)
		if self.modBtnBs then
			self:addButtonBorder{obj=srf, relTo=srf.Icon, clr="white", ca=0.75}
			self:SecureHook(srf, "Update", function(this)
				if this.Icon:IsDesaturated() then
					self:clrBtnBdr(this, "disabled")
				else
					self:clrBtnBdr(this, "white", 0.75)
				end
			end)
		end
		hld, srf = nil, nil
		self:SecureHookScript(this.NewSeasonPopup, "OnShow", function(this)
			this.NewSeason:SetTextColor(self.HT:GetRGB())
			this.SeasonDescription:SetTextColor(self.BT:GetRGB())
			this.SeasonDescription2:SetTextColor(self.BT:GetRGB())
			this.SeasonRewardFrame.Ring:SetTexture(nil)
			this.SeasonRewardText:SetTextColor(self.BT:GetRGB())
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ofs=-13})
			if self.modBtns then
				self:skinStdButton{obj=this.Leave}
			end

			self:Unhook(this, "OnShow")
		end)

		self:Unhook(this, "OnShow")
	end)

	local function skinCommon(frame)
		aObj:removeInset(frame.Inset)
		frame.ConquestBar:DisableDrawLayer("BORDER")
		aObj:skinStatusBar{obj=frame.ConquestBar, fi=0, bgTex=frame.ConquestBar.Background}
		local btn = frame.ConquestBar.Reward
		btn.Ring:SetTexture(nil)
		if aObj.modBtnBs then
			aObj:addButtonBorder{obj=btn, relTo=btn.Icon, reParent={btn.CheckMark}, clr="silver"}
		end
		btn = nil
		if aObj.modChkBtns then
			aObj:skinCheckButton{obj=frame.HealerIcon.checkButton}
			aObj:skinCheckButton{obj=frame.TankIcon.checkButton}
			aObj:skinCheckButton{obj=frame.DPSIcon.checkButton}
		end
	end
	self:SecureHookScript(_G.HonorFrame, "OnShow", function(this)
		skinCommon(this)
		self:skinObject("dropdown", {obj=_G.HonorFrameTypeDropDown, fType=ftype})
		self:skinObject("slider", {obj=this.SpecificFrame.scrollBar, fType=ftype})
		for _, btn in _G.pairs(this.SpecificFrame.buttons) do
			btn.Bg:SetTexture(nil)
			btn.Border:SetTexture(nil)
		end
		local btn
		for _, bName in _G.pairs{"RandomBG", "RandomEpicBG", "Arena1", "Brawl", "SpecialEvent"} do
			btn = this.BonusFrame[bName .. "Button"]
			btn.NormalTexture:SetTexture(nil)
			btn:SetPushedTexture(nil)
			btn.Reward.Border:SetTexture(nil)
			btn.Reward.EnlistmentBonus:DisableDrawLayer("ARTWORK") -- ring texture
			if self.modBtnBs then
				self:addButtonBorder{obj=btn.Reward, relTo=btn.Reward.Icon, reParent={btn.Reward.EnlistmentBonus}}
			end
		end
		btn = nil
		if self.modBtnBs then
			self:SecureHook("HonorFrameBonusFrame_Update", function()
				self:clrBtnBdr(_G.HonorFrame.BonusFrame.RandomBGButton.Reward, "gold")
				self:clrBtnBdr(_G.HonorFrame.BonusFrame.Arena1Button.Reward, "gold")
				self:clrBtnBdr(_G.HonorFrame.BonusFrame.RandomEpicBGButton.Reward, "gold")
				self:clrBtnBdr(_G.HonorFrame.BonusFrame.BrawlButton.Reward, "gold")
			end)
			self:SecureHook(_G.HonorFrame.BonusFrame.SpecialEventButton.Reward, "Update", function(this)
				self:clrBtnBdr(this, this.Icon:IsDesaturated() and "disabled" or "gold")
			end)
		end
		this.BonusFrame:DisableDrawLayer("BACKGROUND")
		this.BonusFrame:DisableDrawLayer("BORDER")
		this.BonusFrame.ShadowOverlay:DisableDrawLayer("OVERLAY")
		self:removeMagicBtnTex(this.QueueButton)
		if self.modBtns then
			self:skinStdButton{obj=this.QueueButton, sec=true}
		end

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.HonorFrame)

	self:SecureHookScript(_G.ConquestFrame, "OnShow", function(this)
		skinCommon(this)
		this:DisableDrawLayer("BACKGROUND")
		this:DisableDrawLayer("BORDER")
		this.Arena2v2.Reward.Border:SetTexture(nil)
		this.Arena2v2.NormalTexture:SetTexture(nil)
		this.Arena3v3.Reward.Border:SetTexture(nil)
		this.Arena3v3.NormalTexture:SetTexture(nil)
		this.RatedBG.Reward.Border:SetTexture(nil)
		this.RatedBG.NormalTexture:SetTexture(nil)
		this.ShadowOverlay:DisableDrawLayer("OVERLAY")
		self:skinObject("glowbox", {obj=this.NoSeason, fType=ftype})
		self:skinObject("glowbox", {obj=this.Disabled, fType=ftype})
		self:skinObject("dropdown", {obj=this.ArenaInviteMenu, fType=ftype})
		self:removeMagicBtnTex(this.JoinButton)
		if self.modBtns then
			 self:skinStdButton{obj=this.JoinButton, sec=true}
		end

		self:Unhook(this, "OnShow")
	end)

	_G.C_Timer.After(0.1, function()
		self:add2Table(self.ttList, _G.ConquestTooltip)
	end)

end

aObj.blizzLoDFrames[ftype].RaidUI = function(self)
	if not self.prdb.RaidUI or self.initialized.RaidUI then return end
	self.initialized.RaidUI = true

	-- N.B. accessed via Raid tab on Friends Frame

	-- N.B. Pullout functionality commented out, therefore code removed from this function

	self:moveObject{obj=_G.RaidGroup1, x=3}

	-- Raid Groups
	for i = 1, _G.MAX_RAID_GROUPS do
		_G["RaidGroup" .. i]:DisableDrawLayer("BACKGROUND")
		self:skinObject("frame", {obj=_G["RaidGroup" .. i], fType=ftype, fb=true})
	end
	-- Raid Group Buttons
	for i = 1, _G.MAX_RAID_GROUPS * 5 do
		_G["RaidGroupButton" .. i]:SetNormalTexture(nil)
		self:skinObject("frame", {obj=_G["RaidGroupButton" .. i], fType=ftype, bd=7, ofs=1})
	end
	-- Raid Class Tabs (side)
	for i = 1, _G.MAX_RAID_CLASS_BUTTONS do
		self:removeRegions(_G["RaidClassButton" .. i], {1}) -- 2 is icon, 3 is text
	end

	if self.isClsc then
		if self.modBtns then
			self:skinStdButton{obj=_G.RaidFrameReadyCheckButton, fType=ftype}
		end
	end

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
		self:addSkinFrame{obj=this, ft=ftype, x1=5, y1=-5, x2=-5, y2=5}
		if self.modBtns then
			self:skinStdButton{obj=this.acceptButton}
			self:SecureHook("RolePollPopup_UpdateChecked", function(this)
				self:clrBtnBdr(this.acceptButton)
			end)
		end

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
		self:skinObject("tabs", {obj=this, prefix=this:GetName(), suffix="Button", fType=ftype, track=false, offsets={x1=8, y1=self.isTT and 3 or 0, x2=-8, y2=2}})
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
		-- Spellbook Panel
		local function updBtn(btn)
			-- handle in combat
			if btn:IsProtected()
			and _G.InCombatLockdown()
			then
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
				if btn.sbb then
					aObj:clrBtnBdr(btn, "disabled")
				end
				spellString:SetTextColor(_G.DISABLED_FONT_COLOR:GetRGB())
				subSpellString:SetTextColor(_G.DISABLED_FONT_COLOR:GetRGB())
				btn.RequiredLevelString:SetTextColor(_G.DISABLED_FONT_COLOR:GetRGB())
				btn.SeeTrainerString:SetTextColor(_G.DISABLED_FONT_COLOR:GetRGB())
			else
				if btn.sbb then
					aObj:clrBtnBdr(btn)
				end
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
			if not self.isClsc then
				btn:DisableDrawLayer("BORDER")
				_G["SpellButton" .. i .. "SlotFrame"]:SetAlpha(0)
				btn.UnlearnedFrame:SetAlpha(0)
				btn.TrainFrame:SetAlpha(0)
			else
				btn:GetNormalTexture():SetTexture(nil)
			end
			if self.modBtnBs then
				if not self.isClsc then
					self:addButtonBorder{obj=btn, sec=true, reParent={btn.FlyoutArrow, _G["SpellButton" .. i .. "AutoCastable"]}}
				else
					self:addButtonBorder{obj=btn, sec=true, reParent={_G["SpellButton" .. i .. "AutoCastable"]}}
				end
			end
			updBtn(btn)
		end
		btn = nil
		-- hook this to change text colour as required
		self:SecureHook("SpellButton_UpdateButton", function(this)
			updBtn(this)
		end)
		-- Tabs (side)
		local btn
		for i = 1, _G.MAX_SKILLLINE_TABS do
			btn = _G["SpellBookSkillLineTab" .. i]
			btn:DisableDrawLayer("BACKGROUND")
			if self.modBtnBs then
				self:addButtonBorder{obj=btn, clr=btn.isOffSpec and "grey"}
			end
			if i == 1 then
				self:moveObject{obj=btn, x=2}
			end
		end
		btn = nil
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
							aObj:clrBtnBdr(obj)
						end
					else
						if aObj.modBtnBs then
							self:clrBtnBdr(obj, "disabled")
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
				aObj:removeRegions(obj.statusBar, {2, 3, 4, 5, 6})
				-- aObj:removeRegions(obj.statusBar, {2, 3, 4, 5, 6}, true)
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
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true, x2=2.5, y2=-2.5})
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.SpellBookPrevPageButton, ofs=-2, y1=-3, x2=-3}
			self:addButtonBorder{obj=_G.SpellBookNextPageButton, ofs=-2, y1=-3, x2=-3}
			self:clrPNBtns("SpellBook")
			self:SecureHook("SpellBookFrame_UpdatePages", function()
				self:clrPNBtns("SpellBook")
			end)
			self:SecureHook("SpellBookFrame_UpdateSkillLineTabs", function()
				local btn
				for i = 1, _G.MAX_SKILLLINE_TABS do
					btn = _G["SpellBookSkillLineTab" .. i]
					self:clrBtnBdr(btn, btn.isOffSpec and "grey")
				end
				btn = nil
			end)
			-- hook this to change Primary Profession Button border colours if required
			self:SecureHook("SpellBook_UpdateProfTab", function()
				for i = 1, 2 do
					if _G["PrimaryProfession" .. i].unlearn:IsShown() then
						self:clrBtnBdr(_G["PrimaryProfession" .. i])
					else
						self:clrBtnBdr(_G["PrimaryProfession" .. i], "disabled")
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
		if _G.IsAddOnLoaded("EnhancedStackSplit") then
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

	local skinBtnBBC
	if self.modBtnBs then
		function skinBtnBBC(frame, button)
			if button
			and button.sbb
			then
				local bnObj = button.name and button.name or button.Name and button.Name or nil
				if (button.knownSelection and button.knownSelection:IsShown())
				or (frame.inspect and button.border:IsShown()) -- inspect frame
				then
					aObj:clrBtnBdr(button, "gold")
					if bnObj then bnObj:SetTextColor(aObj.BT:GetRGB()) end
				else
					aObj:clrBtnBdr(button, "grey")
					if bnObj then bnObj:SetTextColor(1, 1, 1, 0.9) end
				end
				bnObj = nil
			end
		end
		self:SecureHook("TalentFrame_Update", function(this, _)
			for tier = 1, _G.MAX_TALENT_TIERS do
				for column = 1, _G.NUM_TALENT_COLUMNS do
					skinBtnBBC(this, this["tier" .. tier]["talent" .. column])
				end
			end
		end)
	end

	self:SecureHookScript(_G.PlayerTalentFrame, "OnShow", function(this)
		self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true, offsets={x1=8, y1=self.isTT and 3 or -2, x2=-8, y2=2}})
		-- Dual Spec Tabs
		for i = 1, _G.MAX_TALENT_GROUPS do
			self:removeRegions(_G["PlayerSpecTab" .. i], {1}) -- N.B. other regions are icon and highlight
			if self.modBtnBs then
				 self:addButtonBorder{obj=_G["PlayerSpecTab" .. i]}
			end
		end
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true, x1=-4, x2=3})
		if self.modBtns then
			self:skinStdButton{obj=_G.PlayerTalentFrameActivateButton}
			self:skinCloseButton{obj=_G.PlayerTalentFrameCloseButton}
		end
		-- handle extra abilities (Player and Pet)
		self:SecureHook("PlayerTalentFrame_CreateSpecSpellButton", function(this, index)
			this.spellsScroll.child["abilityButton" .. index].ring:SetTexture(nil)
		end)

		self:Unhook(this, "OnShow")
	end)

	local function skinAbilities(obj)
		local sc = obj.spellsScroll.child
		if aObj.modBtnBs then
			aObj:clrBtnBdr(sc, obj.disabled and "disabled" or "gold")
		end
		local btn
		for i = 1, sc:GetNumChildren() do
			btn = sc["abilityButton" .. i]
			if btn then -- Bugfix for ElvUI
				btn.ring:SetTexture(nil)
				btn.subText:SetTextColor(aObj.BT:GetRGB())
				-- make icon square
				aObj:makeIconSquare(btn, "icon")
				if aObj.modBtnBs then
					aObj:clrBtnBdr(btn, btn.icon:IsDesaturated() and "disabled" or "gold")
				end
			end
		end
		sc, btn = nil, nil
	end
	-- hook this as subText text colour is changed
	self:SecureHook("PlayerTalentFrame_UpdateSpecFrame", function(this, _)
		if self.modBtnBs then
			if this.disabled then
				self:clrBtnBdr(this.spellsScroll.child, "disabled")
			else
				self:clrBtnBdr(this.spellsScroll.child, "gold")
			end
			for i = 1, _G.MAX_TALENT_TABS do
				-- N.B. MUST check for disabled state here
				if this["specButton" .. i].disabled then
					self:clrBtnBdr(this["specButton" .. i], "disabled")
				else
					self:clrBtnBdr(this["specButton" .. i], "gold")
				end
			end
			self:clrBtnBdr(this.learnButton)
		end
		skinAbilities(this)
	end)
	local function skinSpec(frame)
		aObj:keepFontStrings(frame)
		frame.MainHelpButton.Ring:SetTexture(nil)
		aObj:removeMagicBtnTex(frame.learnButton)
		if aObj.modBtns then
			aObj:skinStdButton{obj=frame.learnButton}
			-- FIXME: Why was this done?
			-- frame.learnButton.sb:SetParent(frame)
		end
		for i = 1, _G.MAX_TALENT_TABS do
			frame["specButton" .. i].bg:SetTexture(nil)
			frame["specButton" .. i].ring:SetTexture(nil)
			aObj:changeRecTex(frame["specButton" .. i].selectedTex, true)
			frame["specButton" .. i].learnedTex:SetTexture(nil)
			if not aObj.isElvUI
			and frame["specButton" .. i]:GetHighlightTexture()
			then
				aObj:changeRecTex(frame["specButton" .. i]:GetHighlightTexture())
			end
			-- make specIcon square
			aObj:makeIconSquare(frame["specButton" .. i], "specIcon")
		end
		-- shadow frame (LHS)
		aObj:keepFontStrings(aObj:getChild(frame, 8))
		-- spellsScroll (RHS)
		aObj:skinSlider{obj=frame.spellsScroll.ScrollBar}
		frame.spellsScroll.child.gradient:SetTexture(nil)
		aObj:removeRegions(frame.spellsScroll.child, {2, 3, 4, 5, 6, 13})
		-- make specIcon square
		aObj:makeIconSquare(frame.spellsScroll.child, "specIcon")
		-- abilities
		skinAbilities(frame)
	end

	self:SecureHookScript(_G.PlayerTalentFrameSpecialization, "OnShow", function(this)
		skinSpec(this)

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.PlayerTalentFramePetSpecialization, "OnShow", function(this)
		skinSpec(this)

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.PlayerTalentFrameTalents, "OnShow", function(this)
		self:removeRegions(this, {1, 2, 3, 4, 5, 6, 7})
		this.MainHelpButton.Ring:SetTexture(nil)
		self:moveObject{obj=this.MainHelpButton, y=-4}
		-- Talent rows
		for i = 1, _G.MAX_TALENT_TIERS do
			self:removeRegions(this["tier" .. i], {1, 2, 3, 4, 5, 6})
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
			self:addButtonBorder{obj=_G.PlayerTalentFrameTalentsPvpTalentButton, ofs=1}
		end
		local frame = this.PvpTalentFrame
		frame:DisableDrawLayer("BACKGROUND")
		frame:DisableDrawLayer("OVERLAY")
		self:nilTexture(frame.Ring, true) -- warmode button ring texture
		for i = 1, #frame.Slots do
			self:nilTexture(frame.Slots[i].Border, true) -- PvP talent ring texture
			self:makeIconSquare(frame.Slots[i], "Texture")
		end
		frame.WarmodeIncentive.IconRing:SetTexture(nil)

		self:skinSlider{obj=frame.TalentList.ScrollFrame.ScrollBar, wdth=-4}
		self:removeMagicBtnTex(self:getChild(frame.TalentList, 4))
		self:addSkinFrame{obj=frame.TalentList, ft=ftype, kfs=true, ri=true, x2=-4}
		for i = 1, #frame.TalentList.ScrollFrame.buttons do
			frame.TalentList.ScrollFrame.buttons[i]:DisableDrawLayer("BACKGROUND")
			if self.modBtnBs then
				 self:addButtonBorder{obj=frame.TalentList.ScrollFrame.buttons[i], relTo=frame.TalentList.ScrollFrame.buttons[i].Icon}
				 self:SecureHook(frame.TalentList.ScrollFrame.buttons[i], "Update", function(this)
					 self:clrBtnBdr(this, "white")
				 end)
			end
		end
		if self.modBtns then
			self:skinStdButton{obj=self:getChild(frame.TalentList, 4)}
		end

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
		if not self.isClsc then
			this.RecipientOverlay.portrait:SetAlpha(0)
			this.RecipientOverlay.portraitFrame:SetTexture(nil)
		end
		self:removeInset(_G.TradeRecipientItemsInset)
		self:removeInset(_G.TradeRecipientEnchantInset)
		self:removeInset(_G.TradePlayerItemsInset)
		self:removeInset(_G.TradePlayerEnchantInset)
		self:removeInset(_G.TradePlayerInputMoneyInset)
		self:removeInset(_G.TradeRecipientMoneyInset)
		self:skinMoneyFrame{obj=_G.TradePlayerInputMoneyFrame, moveSEB=true}
		_G.TradeRecipientMoneyBg:DisableDrawLayer("BACKGROUND")
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true, x2=1}
		if self.modBtns then
			self:skinStdButton{obj=_G.TradeFrameTradeButton}
			self:skinStdButton{obj=_G.TradeFrameCancelButton}
		end
		if self.modBtnBs then
			for i = 1, _G.MAX_TRADE_ITEMS do
				for _, type in _G.pairs{"Player", "Recipient"} do
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
		self:removeRegions(this.RankFrame, {1, 2, 3})
		self:skinObject("editbox", {obj=this.SearchBox, fType=ftype, si=true})
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, rns=true, cb=true})
		if self.modBtns then
			 self:skinStdButton{obj=this.FilterButton, fType=ftype, ofs=0}
		end
		if self.modBtnBs then
			 self:addButtonBorder{obj=this.LinkToButton, x1=1, y1=-5, x2=-2, y2=2, clr="grey"}
		end
		-- RecipeList
		self:skinObject("tabs", {obj=this.RecipeList, tabs=this.RecipeList.Tabs, fType=ftype, lod=self.isTT and true, upwards=true, offsets={x1=2, y1=-8, x2=-2, y2=self.isTT and -4 or 0}, track=false})
		if self.isTT then
			local function changeTabTex(frame)
				for i, tab in _G.pairs(frame.Tabs) do
					if i == frame.selectedTab then
						self:setActiveTab(tab.sf)
					else
						self:setInactiveTab(tab.sf)
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
		self:skinObject("slider", {obj=self:getChild(this.RecipeList, 4), fType=ftype})
		self:skinObject("frame", {obj=this.RecipeList, fType=ftype, kfs=true, fb=true, ofs=8, x1=-7, y1=5, x2=24})
		for i = 1, #this.RecipeList.buttons do
			if self.modBtns then
				 self:skinExpandButton{obj=this.RecipeList.buttons[i], fType=ftype, onSB=true, noHook=true}
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
		self:skinObject("slider", {obj=this.DetailsFrame.ScrollBar, fType=ftype})
		self:removeMagicBtnTex(this.DetailsFrame.CreateAllButton)
		self:removeMagicBtnTex(this.DetailsFrame.ViewGuildCraftersButton)
		self:removeMagicBtnTex(this.DetailsFrame.ExitButton)
		self:removeMagicBtnTex(this.DetailsFrame.CreateButton)
		local cmib = this.DetailsFrame.CreateMultipleInputBox
		cmib:DisableDrawLayer("BACKGROUND")
		self:skinObject("editbox", {obj=cmib, fType=ftype, chginset=false, ofs=0, x1=-6})
		if self.modBtnBs then
			self:addButtonBorder{obj=cmib.IncrementButton, ofs=0, x2=-1}
			self:addButtonBorder{obj=cmib.DecrementButton, ofs=0, x2=-1}
			self:SecureHook(cmib, "SetEnabled", function(this, _)
				self:clrBtnBdr(this.IncrementButton, "gold")
				self:clrBtnBdr(this.DecrementButton, "gold")
			end)
		end
		cmib = nil
		local cnts = this.DetailsFrame.Contents
		if self.modBtnBs then
			self:addButtonBorder{obj=cnts.ResultIcon, reParent={cnts.ResultIcon.Count}}
		end
		cnts.ResultIcon.ResultBorder:SetTexture(nil)
		cnts.RecipeLevel.BorderLeft:SetTexture(nil)
		cnts.RecipeLevel.BorderRight:SetTexture(nil)
		cnts.RecipeLevel.BorderMid:SetTexture(nil)
		self:skinStatusBar{obj=cnts.RecipeLevel, fi=0}
		if self.modBtns then
			self:skinStdButton{obj=cnts.RecipeLevelSelector, fType=ftype, ofs=0}
		end
		local btn
		for i = 1, #cnts.Reagents do
			btn = cnts.Reagents[i]
			btn.NameFrame:SetTexture(nil)
			if self.modBtnBs then
				 self:addButtonBorder{obj=btn, relTo=btn.Icon, reParent={btn.Count}, clr="common"}
			end
		end
		for i = 1, #cnts.OptionalReagents do
			btn = cnts.OptionalReagents[i]
			btn.NameFrame:SetTexture(nil)
			if self.modBtnBs then
				 self:addButtonBorder{obj=btn, relTo=btn.Icon, reParent={btn.Count}, clr="green"}
			end
		end
		btn, cnts = nil, nil
		if self.modBtns then
			self:skinStdButton{obj=this.DetailsFrame.ViewGuildCraftersButton, fType=ftype}
			self:skinStdButton{obj=this.DetailsFrame.ExitButton, fType=ftype}
			self:skinStdButton{obj=this.DetailsFrame.CreateAllButton, fType=ftype}
			self:skinStdButton{obj=this.DetailsFrame.CreateButton, fType=ftype}
			self:SecureHook(this.DetailsFrame, "RefreshButtons", function(this)
				self:clrBtnBdr(this.CreateAllButton)
				self:clrBtnBdr(this.CreateButton)
			end)
		end
		-- Guild Crafters
		self:SecureHookScript(this.DetailsFrame.GuildFrame, "OnShow", function(this)
			self:skinObject("slider", {obj=this.Container.ScrollFrame.scrollBar, fType=ftype})
			self:skinObject("frame", {obj=this.Container, fType=ftype, ofs=2, x2=-2})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, ofs=-7})

			self:Unhook(this, "OnShow")
		end)
		-- OptionalReagentList
		self:SecureHookScript(this.OptionalReagentList, "OnShow", function(this)
			self:removeInset(this.ScrollList.InsetFrame)
			self:skinObject("slider", {obj=this.ScrollList.ScrollFrame.scrollBar, fType=ftype, rpTex="background"})
			local btn
			for i = 1, this.ScrollList:GetNumElementFrames() do
				btn = this.ScrollList:GetElementFrame(i)
				btn.NameFrame:SetTexture(nil)
				if self.modBtnBs then
					self:addButtonBorder{obj=btn, libt=true}
				end
			end
			btn = nil
			-- apply button changes
			this:RefreshScrollFrame()
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, ofs=0})
			if self.modBtns then
				self:skinStdButton{obj=this.CloseButton, fType=ftype}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=this.HideUnownedButton, fType=ftype}
			end

			self:Unhook(this, "OnShow")
		end)
		-- send message when UI is skinned (used by oGlow skin)
		self:SendMessage("TradeSkillUI_Skinned", self)

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
