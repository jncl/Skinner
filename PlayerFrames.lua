local aName, aObj = ...

local _G = _G
local ftype = "p"

local ipairs, pairs, unpack = _G.ipairs, _G.pairs, _G.unpack
local IsAddOnLoaded = _G.IsAddOnLoaded

do -- manage ButtonBorders for talents
	local function skinBtnBBC(frame, button)

		if button
		and button.sbb
		then
			local bnObj = button.name and button.name or button.Name and button.Name or nil
			if (button.knownSelection and button.knownSelection:IsShown())
			or (frame.inspect and button.border:IsShown()) -- inspect frame
			then
				button.sbb:SetBackdropBorderColor(aObj.bbColour[1], aObj.bbColour[2], aObj.bbColour[3], aObj.bbColour[4])
				if bnObj then bnObj:SetTextColor(aObj.BTr, aObj.BTg, aObj.BTb) end
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
	aObj:SecureHook("PVPTalentFrame_Update", function(this)
		if not aObj.modBtnBs then
			aObj:Unhook("PVPTalentFrame_Update")
			if skinBtnBBC then skinBtnBBC = nil end
			return
		end
		for tier = 1, _G.MAX_PVP_TALENT_TIERS do
			for column = 1, _G.MAX_PVP_TALENT_COLUMNS do
				skinBtnBBC(this, this.Talents["Tier" .. tier]["Talent" .. column])
			end
		end
	end)
end

aObj.blizzLoDFrames[ftype].AchievementUI = function(self)
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
		aObj:skinStatusBar{obj=_G[statusBar], fi=0, bgTex=_G[statusBar .. "FillBar"]}

	end
	local function skinStats()

		local btn
		for i = 1, #_G.AchievementFrameStatsContainer.buttons do
			btn = _G.AchievementFrameStatsContainer.buttons[i]
			btn.background:SetTexture(nil)
			btn.left:SetAlpha(0)
			btn.middle:SetAlpha(0)
			btn.right:SetAlpha(0)
		end
		btn = nil

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

		local btn
		for i = 1, #_G.AchievementFrameComparisonStatsContainer.buttons do
			btn = _G.AchievementFrameComparisonStatsContainer.buttons[i]
			if btn.isHeader then btn.background:SetAlpha(0) end
			btn.left:SetAlpha(0)
			btn.left2:SetAlpha(0)
			btn.middle:SetAlpha(0)
			btn.middle2:SetAlpha(0)
			btn.right:SetAlpha(0)
			btn.right2:SetAlpha(0)
		end
		btn = nil

	end
	local function skinBtn(btn)

		btn:DisableDrawLayer("BACKGROUND")
		-- don't DisableDrawLayer("BORDER") as the button border won't show if skinned
		btn:DisableDrawLayer("ARTWORK")
		aObj:applySkin{obj=btn, bd=10, ng=true}
		if btn.plusMinus then btn.plusMinus:SetAlpha(0) end
		btn.icon:DisableDrawLayer("BACKGROUND")
		btn.icon:DisableDrawLayer("BORDER")
		btn.icon:DisableDrawLayer("OVERLAY")
		-- set textures to nil and prevent them from being changed as guildview changes the textures
		self:nilTexture(btn.icon.frame, true)
		-- colour text and button border
		if btn.description then btn.description:SetTextColor(aObj.BTr, aObj.BTg, aObj.BTb) end
		if btn.hiddenDescription then btn.hiddenDescription:SetTextColor(aObj.BTr, aObj.BTg, aObj.BTb) end

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
			if this.description then this.description:SetTextColor(aObj.BTr, aObj.BTg, aObj.BTb) end
			if this.icon.sbb then
				this.icon.sbb:SetBackdropBorderColor(this:GetBackdropBorderColor())
			end
		end)

	end
	local function cleanButtons(frame, type)

		if aObj.db.profile.AchievementUI.style == 1 then return end -- don't remove textures if option not chosen

		-- remove textures etc from buttons
		local btnName, btn
		for i = 1, #frame.buttons do
			btnName = frame.buttons[i]:GetName() .. (type == "Comparison" and "Player" or "")
			btn = _G[btnName]
			skinBtn(btn)
			if type == "Achievements" then
				-- set textures to nil and prevent them from being changed as guildview changes the textures
				self:nilTexture(_G[btnName .. "TopTsunami1"], true)
				self:nilTexture(_G[btnName .. "BottomTsunami1"], true)
			elseif type == "Summary" then
				if not btn.tooltipTitle then btn:Saturate() end
			elseif type == "Comparison" then
				-- force update to colour the Player button
				if btn.completed then btn:Saturate() end
				-- Friend
				btn = _G[btnName:gsub("Player", "Friend")]
				skinBtn(btn)
				-- force update to colour the Friend button
				if btn.completed then btn:Saturate() end
			end
		end
		btnName, btn = nil, nil

	end

	-- this is not a standard dropdown
	self:moveObject{obj=_G.AchievementFrameFilterDropDown, y=-7}
	if self.db.profile.TexturedDD then
		local tex = _G.AchievementFrameFilterDropDown:CreateTexture(nil, "BORDER")
		tex:SetTexture(self.itTex)
		tex:SetSize(110, 19)
		tex:SetPoint("RIGHT", _G.AchievementFrameFilterDropDown, "RIGHT", -3, 4)
		tex = nil
	end
    self:addButtonBorder{obj=_G.AchievementFrameFilterDropDownButton, ofs=0}
	-- skin the frame
	if self.db.profile.DropDownButtons then
		self:addSkinFrame{obj=_G.AchievementFrameFilterDropDown, ft=ftype, aso={ng=true}, x1=-8, y1=2, x2=2, y2=7}
	end

	-- Search function
	self:skinEditBox{obj=_G.AchievementFrame.searchBox, regs={6, 7}, mi=true} -- 6 is text, 7 is icon
	self:adjHeight{obj=_G.AchievementFrame.searchPreviewContainer, adj=((4 * 27) + 30)}
	self:addSkinFrame{obj=_G.AchievementFrame.searchPreviewContainer, ft=ftype, kfs=true, y1=4, y2=2}
	_G.LowerFrameLevel(_G.AchievementFrame.searchPreviewContainer.sf)
	for i = 1, 5 do
		_G.AchievementFrame["searchPreview" .. i]:SetNormalTexture(nil)
		_G.AchievementFrame["searchPreview" .. i]:SetPushedTexture(nil)
	end
	_G.AchievementFrame.showAllSearchResults:SetNormalTexture(nil)
	_G.AchievementFrame.showAllSearchResults:SetPushedTexture(nil)
	self:skinStatusBar{obj=_G.AchievementFrame.searchProgressBar, fi=0, bgTex=_G.AchievementFrame.searchProgressBar.bg}
	self:addSkinFrame{obj=_G.AchievementFrame.searchResults, ft=ftype, kfs=true}
	self:skinSlider{obj=_G.AchievementFrame.searchResults.scrollFrame.scrollBar, wdth=-4, size=3}

	self:skinTabs{obj=_G.AchievementFrame, regs={9, 10}, ignore=true, lod=true, x1=9, y1=2, x2=-9, y2=-10}
	self:addSkinFrame{obj=_G.AchievementFrame, ft=ftype, kfs=true, bgen=1, y1=7, y2=-3}

-->>-- move Header info
	self:keepFontStrings(_G.AchievementFrameHeader)
	self:moveObject{obj=_G.AchievementFrameHeaderTitle, x=-60, y=-25}
	self:moveObject{obj=_G.AchievementFrameHeaderPoints, x=40, y=-5}
	self:moveObject{obj=_G.AchievementFrame.searchBox, y=-10}
	self:moveObject{obj=_G.AchievementFrameCloseButton, y=6}
	_G.AchievementFrameHeaderShield:SetAlpha(1)

-->>-- Categories Panel (on the Left)
	self:skinSlider{obj=_G.AchievementFrameCategoriesContainerScrollBar, wdth=-4}
	self:addSkinFrame{obj=_G.AchievementFrameCategories, ft=ftype, y1=-1}
	self:SecureHook("AchievementFrameCategories_Update", function()
		skinCategories()
	end)
	skinCategories()

-->>-- Achievements Panel (on the right)
	self:keepFontStrings(_G.AchievementFrameAchievements)
	self:addSkinFrame{obj=self:getChild(_G.AchievementFrameAchievements, 2), ft=ftype, aso={ba=0, ng=true}, y1=-1}
	self:skinSlider{obj=_G.AchievementFrameAchievementsContainerScrollBar, wdth=-4}
	if prdbA.style == 2 then
		-- remove textures etc from buttons
		cleanButtons(_G.AchievementFrameAchievementsContainer, "Achievements")
		-- hook this to handle objectives text colour changes
		self:SecureHookScript(_G.AchievementFrameAchievementsObjectives, "OnShow", function(this)
			if this.completed then
				local kids = {this:GetChildren()}
				for i = 1, #kids do
					local kids2, reg = {kids[i]:GetChildren()}
					for j = 1, #kids2 do
						reg = kids2[j]
						if reg:IsObjectType("FontString") then
							reg:SetTextColor(self.BTr, self.BTg, self.BTb)
						end
					end
					kids2, reg = nil, nil
				end
				kids = nil
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
	local objName
	for i = 1, 10 do
		objName = "AchievementFrameProgressBar" .. i
		if _G[objName] then glazeProgressBar(objName) end
	end
	objName = nil
	-- hook this to skin StatusBars used by the Objectives mini panels
	self:RawHook("AchievementButton_GetProgressBar", function(...)
		local obj = self.hooks.AchievementButton_GetProgressBar(...)
		glazeProgressBar(obj:GetName())
		return obj
	end, true)
	-- hook this to colour the metaCriteria & Criteria text
	self:SecureHook("AchievementObjectives_DisplayCriteria", function(objectivesFrame, id, renderOffScreen)
		local r, g, b, a
		local kids, child = {objectivesFrame:GetChildren()}
		for i = 1, #kids do
			child = kids[i]
			if child.shield then -- miniAchievement
				-- do nothing
			elseif child.label then -- metaCriteria
				r, g, b, a = child.label:GetTextColor()
				if g == 0 then -- completed criteria
					child.label:SetTextColor(1, 1, 1, 1)
					child.label:SetShadowOffset(1, -1)
				end
			elseif child.name then -- criteria
				r, g, b, a = child.name:GetTextColor()
				if g == 0 then -- completed criteria
					child.name:SetTextColor(1, 1, 1, 1)
					child.name:SetShadowOffset(1, -1)
				end
			end
		end
		r, g, b, a = nil, nil, nil, nil
		kids, child = nil, nil
	end)

-->>-- Stats
	self:keepFontStrings(_G.AchievementFrameStats)
	self:skinSlider{obj=_G.AchievementFrameStatsContainerScrollBar, wdth=-4}
	_G.AchievementFrameStatsBG:SetAlpha(0)
	self:addSkinFrame{obj=self:getChild(_G.AchievementFrameStats, 3), ft=ftype, aso={ba=0, ng=true}, y1=1}
	-- hook this to skin buttons
	self:SecureHook("AchievementFrameStats_Update", function()
		skinStats()
	end)
	skinStats()

-->>-- Summary Panel
	self:keepFontStrings(_G.AchievementFrameSummary)
	_G.AchievementFrameSummaryBackground:SetAlpha(0)
	_G.AchievementFrameSummaryAchievementsEmptyText:SetText() -- remove 'No recently completed Achievements' text
	_G.AchievementFrameSummaryAchievementsHeaderHeader:SetAlpha(0)
	self:skinSlider(_G.AchievementFrameAchievementsContainerScrollBar)
	-- remove textures etc from buttons
	if prdbA.style == 2 then
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
	local nTab = {"Player", "Friend"}
	for i = 1, #nTab do
		_G["AchievementFrameComparisonSummary" .. nTab[i]]:SetBackdrop(nil)
		_G["AchievementFrameComparisonSummary" .. nTab[i] .. "Background"]:SetAlpha(0)
		skinSB("AchievementFrameComparisonSummary" .. nTab[i] .. "StatusBar", "Title")
	end
	nTab = nil
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

	prdbA = nil

end

aObj.blizzLoDFrames[ftype].ArchaeologyUI = function(self)
	if not self.db.profile.ArchaeologyUI or self.initialized.ArchaeologyUI then return end
	self.initialized.ArchaeologyUI = true

	self:moveObject{obj=_G.ArchaeologyFrame.infoButton, x=-25}
	self:skinDropDown{obj=_G.ArchaeologyFrame.raceFilterDropDown}
	_G.ArchaeologyFrameRankBarBackground:SetAllPoints(_G.ArchaeologyFrame.rankBar)
	_G.ArchaeologyFrameRankBarBorder:Hide()
	self:skinStatusBar{obj=_G.ArchaeologyFrame.rankBar, fi=0, bgTex=_G.ArchaeologyFrameRankBarBackground}
	self:addSkinFrame{obj=_G.ArchaeologyFrame, ft=ftype, kfs=true, ri=true, x1=30, y1=2, x2=1}
-->>-- Summary Page
	self:keepFontStrings(_G.ArchaeologyFrame.summaryPage) -- remove title textures
	_G.ArchaeologyFrameSummaryPageTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
	for i = 1, _G.ARCHAEOLOGY_MAX_RACES do
		_G.ArchaeologyFrame.summaryPage["race" .. i].raceName:SetTextColor(self.BTr, self.BTg, self.BTb)
	end
	self:addButtonBorder{obj=_G.ArchaeologyFrame.summaryPage.prevPageButton, ofs=0}
	self:addButtonBorder{obj=_G.ArchaeologyFrame.summaryPage.nextPageButton, ofs=0}
-->>-- Completed Page
	self:keepFontStrings(_G.ArchaeologyFrame.completedPage) -- remove title textures
	_G.ArchaeologyFrame.completedPage.infoText:SetTextColor(self.BTr, self.BTg, self.BTb)
	_G.ArchaeologyFrame.completedPage.titleBig:SetTextColor(self.HTr, self.HTg, self.HTb)
	_G.ArchaeologyFrame.completedPage.titleTop:SetTextColor(self.BTr, self.BTg, self.BTb)
	_G.ArchaeologyFrame.completedPage.titleMid:SetTextColor(self.BTr, self.BTg, self.BTb)
	_G.ArchaeologyFrame.completedPage.pageText:SetTextColor(self.BTr, self.BTg, self.BTb)
	local btn
	for i = 1, _G.ARCHAEOLOGY_MAX_COMPLETED_SHOWN do
		btn = _G.ArchaeologyFrame.completedPage["artifact" .. i]
		btn.artifactName:SetTextColor(self.HTr, self.HTg, self.HTb)
		btn.artifactSubText:SetTextColor(self.BTr, self.BTg, self.BTb)
		btn.border:Hide()
		_G["ArchaeologyFrameCompletedPageArtifact" .. i .. "Bg"]:Hide()
		self:addButtonBorder{obj=btn, relTo=btn.icon}
	end
	btn = nil
	self:addButtonBorder{obj=_G.ArchaeologyFrame.completedPage.prevPageButton, ofs=0}
	self:addButtonBorder{obj=_G.ArchaeologyFrame.completedPage.nextPageButton, ofs=0}
-->>-- Artifact Page
	local afap = _G.ArchaeologyFrame.artifactPage
	self:removeRegions(afap, {2, 3, 7, 9}) -- title textures, backgrounds
	self:addButtonBorder{obj=afap, relTo=afap.icon, ofs=1}
	afap.historyTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
	afap.historyScroll.child.text:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:skinSlider{obj=afap.historyScroll.ScrollBar, wdth=-4}
	-- Solve Frame
	self:getRegion(afap.solveFrame.statusBar, 1):Hide() -- BarBG texture
	self:skinStatusBar{obj=afap.solveFrame.statusBar, fi=0}
	afap.solveFrame.statusBar:SetStatusBarColor(0.75, 0.45, 0, 0.7)
	afap = nil
-->>-- Help Page
	self:removeRegions(_G.ArchaeologyFrame.helpPage, {2, 3}) -- title textures
	_G.ArchaeologyFrame.helpPage.titleText:SetTextColor(self.HTr, self.HTg, self.HTb)
	_G.ArchaeologyFrameHelpPageDigTex:SetTexCoord(0.05, 0.885, 0.055, 0.9) -- remove texture surrounds
	_G.ArchaeologyFrameHelpPageDigTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
	_G.ArchaeologyFrameHelpPageHelpScrollHelpText:SetTextColor(self.BTr, self.BTg, self.BTb)

	-- ArcheologyDigsiteProgressBar
	_G.ArcheologyDigsiteProgressBar:DisableDrawLayer("BACKGROUND")
	_G.ArcheologyDigsiteProgressBar.BarBorderAndOverlay:SetTexture(nil)
	self:skinStatusBar{obj=_G.ArcheologyDigsiteProgressBar.FillBar, fi=0}

	-- N.B. DigsiteCompleteToastFrame is managed as part of the Alert Frames skin

end

aObj.blizzFrames[ftype].Buffs = function(self)
	if not self.db.profile.Buffs or self.initialized.Buffs then return end
	self.initialized.Buffs = true

	if self.modBtnBs then
		local function skinBuffs()

			local btn
			for i = 1, _G.BUFF_MAX_DISPLAY do
				btn = _G["BuffButton" .. i]
				if btn
				and not btn.sbb
				then
					aObj:addButtonBorder{obj=btn, reParent={btn.count, btn.duration}}
				end
			end
			btn = nil

		end
		-- hook this to skin new Buffs
		self:SecureHook("BuffFrame_Update", function()
			skinBuffs()
		end)
		-- skin any current Buffs
		skinBuffs()

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

	if not self.db.profile.CastingBar.skin or self.initialized.CastingBar then return end
	self.initialized.CastingBar = true

	local nTab, frame = {"", "Pet"}
	for i = 1, #nTab do
		frame = _G[nTab[i] .. "CastingBarFrame"]
		frame.Border:SetAlpha(0)
		self:changeShield(frame.BorderShield, frame.Icon)
		frame.Flash:SetAllPoints()
		frame.Flash:SetTexture([[Interface\Buttons\WHITE8X8]])
		if self.db.profile.CastingBar.glaze then
			self:skinStatusBar{obj=frame, fi=0, bgTex=self:getRegion(frame, 1)}
		end
		-- adjust text and spark in Classic mode
		if nTab[i] == ""
		and not frame.ignoreFramePositionManager then
			frame.Text:SetPoint("TOP", 0, 2)
			frame.Spark.offsetY = -1
		end
	end
	nTab, frame = nil, nil
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
	if not self.db.profile.CharacterFrames or self.initialized.CharacterFrames then return end
	self.initialized.CharacterFrames = true

	if self.modBtnBs then
		self:SecureHook("PaperDollItemSlotButton_Update", function(btn)
			if btn.sbb
			and not btn.hasItem
			then
				btn.sbb:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
			end
		end)
	end
	-- Character Frame
	self:removeInset(_G.CharacterFrameInsetRight)
	self:skinTabs{obj=_G.CharacterFrame}
	self:addSkinFrame{obj=_G.CharacterFrame, ft=ftype, kfs=true, ri=true, nb=true, x1=-3, y1=2, x2=1, y2=-5} -- don't skin buttons here
	self:skinButton{obj=_G.CharacterFrameCloseButton, cb=true}

	self:skinButton{obj=_G.CharacterFrame.ReputationTabHelpBox.CloseButton, cb=true}

	-- PaperDoll Frame
	self:keepFontStrings(_G.PaperDollFrame)
	_G.CharacterModelFrame.controlFrame:DisableDrawLayer("BACKGROUND")
	-- skin slots
	local kids, btn = {_G.PaperDollItemsFrame:GetChildren()}
	for i = 1, #kids do
		btn = kids[i]
		btn:DisableDrawLayer("BACKGROUND")
		if self.modBtnBs then
			self:addButtonBorder{obj=btn, ibt=true, reParent={btn.ignoreTexture}}
			if not btn.hasItem then
				btn.sbb:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
			end
		end

	end
	kids, btn = nil, nil
	_G.CharacterModelFrame:DisableDrawLayer("BACKGROUND")
	_G.CharacterModelFrame:DisableDrawLayer("BORDER")
	_G.CharacterModelFrame:DisableDrawLayer("OVERLAY")
	-- Sidebar Tabs
	_G.PaperDollSidebarTabs.DecorLeft:SetAlpha(0)
	_G.PaperDollSidebarTabs.DecorRight:SetAlpha(0)
	local tab
	for i = 1, #_G.PAPERDOLL_SIDEBARS do
		tab = _G["PaperDollSidebarTab" .. i]
		tab.TabBg:SetAlpha(0)
		tab.Hider:SetAlpha(0)
		-- use a button border to indicate the active tab
		self.modUIBtns:addButtonBorder{obj=tab, relTo=tab.Icon, ofs=i==1 and 3 or 1} -- use module function here to force creation
		tab.sbb:SetBackdropBorderColor(1, 0.6, 0, 1)
		tab.sbb:SetShown(_G[_G.PAPERDOLL_SIDEBARS[i].frame]:IsShown())
	end
	tab = nil
	-- hook this to manage the active tab
	self:SecureHook("PaperDollFrame_UpdateSidebarTabs", function()
		local tab
		for i = 1, #_G.PAPERDOLL_SIDEBARS do
			tab = _G["PaperDollSidebarTab" .. i]
			if tab and tab.sbb then
				tab.sbb:SetShown(_G[_G.PAPERDOLL_SIDEBARS[i].frame]:IsShown())
			end
		end
		tab = nil
	end)
	-- Stats
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
	-- Titles
	self:SecureHookScript(_G.PaperDollTitlesPane, "OnShow", function(this)
		for i = 1, #this.buttons do
			this.buttons[i]:DisableDrawLayer("BACKGROUND")
		end
		self:Unhook(_G.PaperDollTitlesPane, "OnShow")
	end)
	self:skinSlider{obj=_G.PaperDollTitlesPane.scrollBar, wdth=-4}
	-- Equipment Manager
	self:SecureHookScript(_G.PaperDollEquipmentManagerPane, "OnShow", function(this)
		local btn
		for i = 1, #this.buttons do
			btn = this.buttons[i]
			btn:DisableDrawLayer("BACKGROUND")
			self:addButtonBorder{obj=btn, relTo=btn.icon}
		end
		btn = nil
		self:Unhook(_G.PaperDollEquipmentManagerPane, "OnShow")
	end)
	self:skinSlider{obj=_G.PaperDollEquipmentManagerPane.scrollBar, wdth=-4}
	self:skinButton{obj=_G.PaperDollEquipmentManagerPane.EquipSet}
	_G.PaperDollEquipmentManagerPane.EquipSet.ButtonBackground:SetAlpha(0)
	self:skinButton{obj=_G.PaperDollEquipmentManagerPane.SaveSet}

	-- GearManagerDialog Popup Frame
	self:adjHeight{obj=_G.GearManagerDialogPopupScrollFrame, adj=20}
	self:skinSlider{obj=_G.GearManagerDialogPopupScrollFrame.ScrollBar, size=3, rt="background"}
	self:removeRegions(self:getChild(_G.GearManagerDialogPopup, 1), {1, 2, 3, 4, 5, 6, 7, 8})
	self:adjHeight{obj=_G.GearManagerDialogPopup, adj=20}
	local btn
	for i = 1, #_G.GearManagerDialogPopup.buttons do
		btn = _G.GearManagerDialogPopup.buttons[i]
		btn:DisableDrawLayer("BACKGROUND")
		self:addButtonBorder{obj=btn}
	end
	btn = nil
	self:skinEditBox{obj=_G.GearManagerDialogPopupEditBox, regs={6}}
	self:addSkinFrame{obj=_G.GearManagerDialogPopup, ft=ftype, kfs=true, x1=4, y1=-2, x2=-1, y2=3}

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
	self:skinSlider{obj=_G.ReputationListScrollFrame.ScrollBar, size=3, rt="background"}

	local obj
	for i = 1, _G.NUM_FACTIONS_DISPLAYED do
		obj = "ReputationBar" .. i
		self:skinButton{obj=_G[obj .. "ExpandOrCollapseButton"], mp=true} -- treat as just a texture
		_G[obj .. "Background"]:SetAlpha(0)
		_G[obj .. "ReputationBarLeftTexture"]:SetAlpha(0)
		_G[obj .. "ReputationBarRightTexture"]:SetAlpha(0)
		self:skinStatusBar{obj=_G[obj .. "ReputationBar"], fi=0}
		-- N.B. Issue with faction standing text, after rep line 3 the text moves down with respect to the status bar
		-- self:moveObject{obj=_G[obj .. "ReputationBarFactionStanding"], y=2}
	end
	obj = nil

	self:addSkinFrame{obj=_G.ReputationDetailFrame, ft=ftype, kfs=true, x1=6, y1=-6, x2=-6, y2=6}

	-- ReputationParagon Tooltip
	if self.db.profile.Tooltips.skin then
		self:add2Table(self.ttList, "ReputationParagonTooltip")
	end
	self:addButtonBorder{obj=_G.ReputationParagonTooltip.ItemTooltip, relTo=_G.ReputationParagonTooltip.ItemTooltip.Icon, reParent={_G.ReputationParagonTooltip.ItemTooltip.Count}}
	self:removeRegions(_G.ReputationParagonTooltipStatusBar.Bar, {1, 2, 3, 4, 5}) -- 6 is text
	self:skinStatusBar{obj=_G.ReputationParagonTooltipStatusBar.Bar, fi=0, bgTex=self:getRegion(_G.ReputationParagonTooltipStatusBar.Bar, 7)}

	-- TokenFrame (a.k.a Currency Tab)
	if self.db.profile.ContainerFrames.skin then
		_G.BACKPACK_TOKENFRAME_HEIGHT = _G.BACKPACK_TOKENFRAME_HEIGHT - 6
		_G.BackpackTokenFrame:DisableDrawLayer("BACKGROUND")
	end

	self:keepFontStrings(_G.TokenFrame)
	self:skinSlider{obj=_G.TokenFrameContainerScrollBar, wdth=-4}

	self:SecureHookScript(_G.TokenFrame, "OnShow", function(this)
		-- remove background & header textures
		for i = 1, #_G.TokenFrameContainer.buttons do
			self:removeRegions(_G.TokenFrameContainer.buttons[i], {1, 6, 7, 8})
		end
		self:Unhook(_G.TokenFrame, "OnShow")
	end)

	self:addSkinFrame{obj=_G.TokenFramePopup,ft=ftype, kfs=true, y1=-6, x2=-6, y2=6}

end

aObj.blizzLoDFrames[ftype].Collections = function(self)
	if not self.db.profile.Collections or self.initialized.Collections then return end
	self.initialized.Collections = true

	self:addSkinFrame{obj=_G.CollectionsJournal, ft=ftype, kfs=true, x1=-3, y1=2, x2=1, y2=-5}
	self:skinTabs{obj=_G.CollectionsJournal, lod=true}

-->>-- Mounts
	local mj = _G.MountJournal
	self:addButtonBorder{obj=mj.SummonRandomFavoriteButton, ofs=3}
	self:removeInset(mj.LeftInset)
	self:removeInset(mj.RightInset)
	self:skinEditBox{obj=mj.searchBox, regs={6, 7}, mi=true, noHeight=true, noInsert=true, x=-6, y=-2} -- 6 is text, 7 is icon
	self:skinButton{obj=_G.MountJournalFilterButton}
	self:skinDropDown{obj=_G.MountJournalFilterDropDown}
	self:removeInset(mj.MountCount)
	self:keepFontStrings(mj.MountDisplay)
	self:keepFontStrings(mj.MountDisplay.ShadowOverlay)
	self:addButtonBorder{obj=mj.MountDisplay.InfoButton, relTo=mj.MountDisplay.InfoButton.Icon}
	self:addButtonBorder{obj=mj.MountDisplay.ModelScene.RotateLeftButton, ofs=-4, y2=5}
	self:addButtonBorder{obj=mj.MountDisplay.ModelScene.RotateRightButton, ofs=-4, y2=5}
	self:skinSlider{obj=mj.ListScrollFrame.scrollBar, wdth=-4}
	self:removeMagicBtnTex(mj.MountButton)
	local btn
	for i = 1, #mj.ListScrollFrame.buttons do
		btn = mj.ListScrollFrame.buttons[i]
		btn:DisableDrawLayer("BACKGROUND")
		self:addButtonBorder{obj=btn, relTo=btn.icon, reParent={btn.favorite}}
	end
	btn = nil
	mj = nil

-->>-- Pet Journal
	local pj = _G.PetJournal
	self:addButtonBorder{obj=pj.SummonRandomFavoritePetButton, ofs=3}
	self:removeInset(pj.PetCount)
	pj.MainHelpButton.Ring:SetTexture(nil)
	self:moveObject{obj=pj.MainHelpButton, y=-4}
	self:addButtonBorder{obj=pj.HealPetButton, sec=true}
	_G.PetJournalHealPetButtonBorder:SetTexture(nil)
	self:removeInset(pj.LeftInset)
	self:removeInset(pj.PetCardInset)
	self:removeInset(pj.RightInset)
	self:skinEditBox{obj=pj.searchBox, regs={6, 7}, mi=true, noHeight=true, noInsert=true, x=-6, y=-2} -- 6 is text, 7 is icon
	self:skinButton{obj=_G.PetJournalFilterButton}
	self:skinDropDown{obj=_G.PetJournalFilterDropDown}

	-- PetList
	self:skinSlider{obj=pj.listScroll.scrollBar, wdth=-4}
	local btn
	for i = 1, #pj.listScroll.buttons do
		btn = pj.listScroll.buttons[i]
		self:removeRegions(btn, {1}) -- background
		self:changeTandC(btn.dragButton.levelBG, self.lvlBG)
	end
	btn = nil
	-- skinPLBtns(pj.listScroll)
	self:keepFontStrings(pj.loadoutBorder)
	self:moveObject{obj=pj.loadoutBorder, y=8} -- battle pet slots title

	-- Pet LoadOut Plates
	local lop
	for i = 1, 3 do
		lop = pj.Loadout["Pet" .. i]
		self:removeRegions(lop, {1, 2, 5})
		-- add button border for empty slots
        self.modUIBtns:addButtonBorder{obj=lop, relTo=lop.icon, reParent={lop.levelBG, lop.level, lop.favorite}} -- use module function here to force creation
		self:changeTandC(lop.levelBG, self.lvlBG)
		self:keepFontStrings(lop.helpFrame)
		lop.healthFrame.healthBar:DisableDrawLayer("OVERLAY")
		self:skinStatusBar{obj=lop.healthFrame.healthBar, fi=0}
		self:removeRegions(lop.xpBar, {2, 3, 4, 5, 6, 7, 8, 9, 10, 11})
		self:skinStatusBar{obj=lop.xpBar, fi=0}
		self:addSkinFrame{obj=lop, aso={bd=8, ng=true}, x1=-4, y2=-4} -- use asf here as button already has a border
		local btn
		for i = 1, 3 do
			btn = lop["spell" .. i]
			self:removeRegions(btn, {1, 3}) -- background, blackcover
			self:addButtonBorder{obj=btn, relTo=btn.icon, reParent={btn.FlyoutArrow}}
		end
		btn = nil
	end
	lop = nil

	if self.modBtnBs then
		local function skinPetIcon(pet, petID)
			if pet.qualityBorder:IsShown() then
				local _, _, _, _, rarity = _G.C_PetJournal.GetPetStats(petID)
				pet.sbb:SetBackdropBorderColor(_G.ITEM_QUALITY_COLORS[rarity - 1].r, _G.ITEM_QUALITY_COLORS[rarity - 1].g, _G.ITEM_QUALITY_COLORS[rarity - 1].b, 1) -- alpha is 1
				rarity = nil
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
	-- PetCard
	local pc = pj.PetCard
	self:changeTandC(pc.PetInfo.levelBG, self.lvlBG)
	pc.PetInfo.qualityBorder:SetAlpha(0)
	self:addButtonBorder{obj=pc.PetInfo, relTo=pc.PetInfo.icon, reParent={pc.PetInfo.levelBG, pc.PetInfo.level, pc.PetInfo.favorite}}
	self:removeRegions(pc.HealthFrame.healthBar, {1, 2, 3})
	self:skinStatusBar{obj=pc.HealthFrame.healthBar, fi=0}
	self:removeRegions(pc.xpBar, {2, 3, 4, 5, 6, 7, 8, 9, 10, 11})
	self:skinStatusBar{obj=pc.xpBar, fi=0}
	self:keepFontStrings(pc)
	self:addSkinFrame{obj=pc, aso={bd=8, ng=true}, ofs=4}
	for i = 1, 6 do
		pc["spell" .. i].BlackCover:SetAlpha(0) -- N.B. texture is changed in code
		self:addButtonBorder{obj=pc["spell" .. i], relTo=pc["spell" .. i].icon}
	end
	self:removeMagicBtnTex(pj.FindBattleButton)
	self:removeMagicBtnTex(pj.SummonButton)
	self:removeRegions(pj.AchievementStatus, {1, 2})
	self:skinDropDown{obj=pj.petOptionsMenu}
	-- pj.SpellSelect ?
	pc, pj = nil, nil

	-- Tooltips
	if self.db.profile.Tooltips.skin then
		local nTab, tt = {"Primary", "Secondary"}
		for i = 1, #nTab do
			tt = _G["PetJournal" .. nTab[i] .. "AbilityTooltip"]
			tt.Delimiter1:SetTexture(nil)
			tt.Delimiter2:SetTexture(nil)
			tt:DisableDrawLayer("BACKGROUND")
			self:addSkinFrame{obj=tt, ft=ftype}
		end
		nTab, tt = nil, nil
	end

	if self.modBtnBs then
		local function skinCollectionBtn(btn)
			if btn.sbb then
				if btn.slotFrameUncollected:IsShown() then
					btn.sbb:SetBackdropBorderColor(0.5, 0.5, 0.5)
				else
					btn.sbb:SetBackdropBorderColor(self.bbColour[1], self.bbColour[2], self.bbColour[3], self.bbColour[4])
				end
			end
		end
		self:SecureHook("ToySpellButton_UpdateButton", function(this)
			skinCollectionBtn(this)
		end)
		self:SecureHook(_G.HeirloomsJournal, "UpdateButton", function(this, button)
			skinCollectionBtn(button)
			if button.levelBackground:GetAtlas() == "collections-levelplate-black" then
				self:changeTandC(button.levelBackground, self.lvlBG)
			end
		end)
	end
-->>-- Toy Box
	local tb = _G.ToyBox
	self:skinStatusBar{obj=tb.progressBar, fi=0}
	self:removeRegions(tb.progressBar, {2, 3})
	self:skinEditBox{obj=tb.searchBox, regs={6, 7}, mi=true, noHeight=true, noInsert=true, y=-2} -- 6 is text, 7 is icon
	self:skinButton{obj=_G.ToyBoxFilterButton}
	self:skinDropDown{obj=_G.ToyBoxFilterDropDown}
	self:removeInset(tb.iconsFrame)
	tb.iconsFrame:DisableDrawLayer("OVERLAY")
	tb.iconsFrame:DisableDrawLayer("ARTWORK")
	tb.iconsFrame:DisableDrawLayer("BORDER")
	tb.iconsFrame:DisableDrawLayer("BACKGROUND")
	local btn
	for i = 1, 18 do
		btn = tb.iconsFrame["spellButton" .. i]
		btn.slotFrameCollected:SetTexture(nil)
		btn.slotFrameUncollected:SetTexture(nil)
		self:addButtonBorder{obj=btn, sec=true, ofs=0}
	end
	btn = nil
	self:addButtonBorder{obj=tb.PagingFrame.PrevPageButton, ofs=-2, y1=-3, x2=-3}
	self:addButtonBorder{obj=tb.PagingFrame.NextPageButton, ofs=-2, y1=-3, x2=-3}
	self:skinDropDown{obj=tb.toyOptionsMenu}
	tb = nil

-->>-- Heirlooms
	local hj = _G.HeirloomsJournal
	self:skinStatusBar{obj=hj.progressBar, fi=0}
	self:removeRegions(hj.progressBar, {2, 3})
	self:skinEditBox{obj=hj.SearchBox, regs={6, 7}, mi=true, noHeight=true, noInsert=true, y=-2} -- 6 is text, 7 is icon
	self:skinButton{obj=_G.HeirloomsJournalFilterButton}
	self:skinDropDown{obj=_G.HeirloomsJournalFilterDropDown}
	self:skinDropDown{obj=_G.HeirloomsJournalClassDropDown}
	self:removeInset(hj.iconsFrame)
	hj.iconsFrame:DisableDrawLayer("OVERLAY")
	hj.iconsFrame:DisableDrawLayer("ARTWORK")
	hj.iconsFrame:DisableDrawLayer("BORDER")
	hj.iconsFrame:DisableDrawLayer("BACKGROUND")
	-- 18 icons per page ?
	self:SecureHook(_G.HeirloomsJournal, "LayoutCurrentPage", function(this)
		local frame
		for i = 1, #this.heirloomHeaderFrames do
			frame = this.heirloomHeaderFrames[i]
			frame:DisableDrawLayer("BACKGROUND")
			frame.text:SetTextColor(self.HTr, self.HTg, self.HTb)
		end
		frame = nil
		local btn
		for i = 1, #this.heirloomEntryFrames do
			btn = this.heirloomEntryFrames[i]
			btn.slotFrameCollected:SetTexture(nil)
			btn.slotFrameUncollected:SetTexture(nil)
			-- ignore btn.levelBackground as its textures is changed when upgraded
			self:addButtonBorder{obj=btn, sec=true, ofs=0, reParent={btn.levelBackground, btn.level}}
		end
		btn = nil
	end)
	self:addButtonBorder{obj=hj.PagingFrame.PrevPageButton, ofs=-2, y1=-3, x2=-3}
	self:addButtonBorder{obj=hj.PagingFrame.NextPageButton, ofs=-2, y1=-3, x2=-3}
	hj = nil

-->>-- Appearances
	local wcf = _G.WardrobeCollectionFrame
	self:skinEditBox{obj=wcf.searchBox, regs={6, 7}, mi=true, noHeight=true, noInsert=true} -- 6 is text, 7 is icon
	wcf.searchProgressFrame:DisableDrawLayer("BACKGROUND")
	wcf.searchProgressFrame:DisableDrawLayer("ARTWORK")
	self:skinStatusBar{obj=wcf.searchProgressFrame.searchProgressBar, 0, bgTex=wcf.searchProgressFrame.searchProgressBar.barBackground}
	wcf.searchProgressFrame.searchProgressBar:DisableDrawLayer("ARTWORK")
	self:addSkinFrame{obj=wcf.searchProgressFrame}
	self:skinStatusBar{obj=wcf.progressBar, fi=0}
	self:removeRegions(wcf.progressBar, {2, 3})
	self:skinButton{obj=wcf.FilterButton}
	self:skinDropDown{obj=wcf.FilterDropDown}
	self:skinTabs{obj=wcf, up=true, lod=true, x1=2, y1=-4, x2=-2, y2=-4}
	self:skinButton{obj=wcf.SetsTabHelpBox.CloseButton, cb=true}
	-- ItemsCollectionFrame
	self:removeRegions(wcf.ItemsCollectionFrame, {})
	wcf.ItemsCollectionFrame:DisableDrawLayer("BACKGROUND")
	wcf.ItemsCollectionFrame:DisableDrawLayer("BORDER")
	wcf.ItemsCollectionFrame:DisableDrawLayer("OVERLAY")
	wcf.ItemsCollectionFrame:DisableDrawLayer("ARTWORK", 1)
	wcf.ItemsCollectionFrame:DisableDrawLayer("ARTWORK", 2)
	self:skinDropDown{obj=wcf.ItemsCollectionFrame.WeaponDropDown}
	self:addButtonBorder{obj=wcf.ItemsCollectionFrame.PagingFrame.PrevPageButton, ofs=-2, y1=-3, x2=-3}
	self:addButtonBorder{obj=wcf.ItemsCollectionFrame.PagingFrame.NextPageButton, ofs=-2, y1=-3, x2=-3}
	self:skinButton{obj=wcf.ItemsCollectionFrame.HelpBox.CloseButton, cb=true}
	-- SetsCollectionFrame
	wcf.SetsCollectionFrame.RightInset:DisableDrawLayer("BACKGROUND")
	wcf.SetsCollectionFrame.RightInset:DisableDrawLayer("BORDER")
	wcf.SetsCollectionFrame.RightInset:DisableDrawLayer("OVERLAY")
	wcf.SetsCollectionFrame.RightInset:DisableDrawLayer("ARTWORK", 1)
	wcf.SetsCollectionFrame.RightInset:DisableDrawLayer("ARTWORK", 2)
	self:removeInset(wcf.SetsCollectionFrame.LeftInset)
	self:removeInset(wcf.SetsCollectionFrame.RightInset)
	self:skinSlider{obj=wcf.SetsCollectionFrame.ScrollFrame.scrollBar, wdth=-4, size=3}
	self:skinDropDown{obj=wcf.SetsCollectionFrame.ScrollFrame.FavoriteDropDown}
	local btn
	for i = 1, #wcf.SetsCollectionFrame.ScrollFrame.buttons do
		btn = wcf.SetsCollectionFrame.ScrollFrame.buttons[i]
		btn:DisableDrawLayer("BACKGROUND")
		self:addButtonBorder{obj=btn, relTo=btn.Icon}
	end
	btn = nil
	wcf.SetsCollectionFrame.DetailsFrame:DisableDrawLayer("BACKGROUND")
	wcf.SetsCollectionFrame.DetailsFrame:DisableDrawLayer("BORDER")
	self:skinButton{obj=wcf.SetsCollectionFrame.DetailsFrame.VariantSetsButton}
	self:skinDropDown{obj=wcf.SetsCollectionFrame.DetailsFrame.VariantSetsDropDown}
	-- SetsTransmogFrame
	wcf.SetsTransmogFrame:DisableDrawLayer("BACKGROUND")
	wcf.SetsTransmogFrame:DisableDrawLayer("BORDER")
	wcf.SetsTransmogFrame:DisableDrawLayer("OVERLAY")
	wcf.SetsTransmogFrame:DisableDrawLayer("ARTWORK", 1)
	wcf.SetsTransmogFrame:DisableDrawLayer("ARTWORK", 2)
	self:addButtonBorder{obj=wcf.SetsTransmogFrame.PagingFrame.PrevPageButton, ofs=-2, y1=-3, x2=-3}
	self:addButtonBorder{obj=wcf.SetsTransmogFrame.PagingFrame.NextPageButton, ofs=-2, y1=-3, x2=-3}
	wcf = nil

-->>-- WardrobeFrame a.k.a. Transmogrify
	local wtf = _G.WardrobeTransmogFrame
	self:removeInset(wtf.Inset)
	self:skinDropDown{obj=wtf.OutfitDropDown, y2=-4}
	self:addButtonBorder{obj=wtf.Model.ClearAllPendingButton, ofs=1, x2=0, relTo=wtf.Model.ClearAllPendingButton.Icon}
	local btn
	for i = 1, #wtf.Model.SlotButtons do
		btn = wtf.Model.SlotButtons[i]
		btn.Border:SetTexture(nil)
		self:addButtonBorder{obj=btn, ofs=-2}
	end
	btn = nil
	wtf:DisableDrawLayer("ARTWORK")
	wtf.Model.controlFrame:DisableDrawLayer("BACKGROUND")
	self:addButtonBorder{obj=wtf.SpecButton, ofs=0}
	self:addSkinFrame{obj=_G.WardrobeFrame, ft=ftype, kfs=true, ofs=2}
	wtf = nil

end

aObj.blizzFrames[ftype].CompactFrames = function(self)
	if IsAddOnLoaded("Tukui")
	or IsAddOnLoaded("ElvUI")
	then
		aObj.blizzFrames[ftype].CompactFrames = nil
		return
	end

	if not self.db.profile.CompactFrames or self.initialized.CompactFrames then return end
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

-->>-- Compact Party Frame
	self:SecureHook("CompactPartyFrame_OnLoad", function()
		self:addSkinFrame{obj=_G.CompactPartyFrame.borderFrame, ft=ftype, kfs=true, y1=-1, x2=-3, y2=3}
		self:Unhook("CompactPartyFrame_OnLoad")
	end)
	-- hook this to skin any new CompactRaidGroup(s)
	self:SecureHook("CompactRaidGroup_UpdateLayout", function(frame)
		skinGrp(frame)
	end)

-->>-- Compact RaidFrame Container
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

-->>-- Compact RaidFrame Manager
	-- Buttons
	local nTab = {"Tank", "Healer", "Damager"}
	for i = 1, #nTab do
		self:skinButton{obj=_G.CompactRaidFrameManager.displayFrame.filterOptions["filterRole" .. nTab[i]]}
	end
	nTab = nil
	for i = 1, 8 do
		self:skinButton{obj=_G.CompactRaidFrameManager.displayFrame.filterOptions["filterGroup" .. i]}
	end
	_G.CompactRaidFrameManager.displayFrame.filterOptions:DisableDrawLayer("BACKGROUND")
	self:skinDropDown{obj=_G.CompactRaidFrameManager.displayFrame.profileSelector}
	self:skinButton{obj=_G.CompactRaidFrameManager.displayFrame.lockedModeToggle}
	self:skinButton{obj=_G.CompactRaidFrameManager.displayFrame.hiddenModeToggle}
	self:skinButton{obj=_G.CompactRaidFrameManager.displayFrame.convertToRaid}
	-- Leader Options
	self:skinButton{obj=_G.CompactRaidFrameManager.displayFrame.leaderOptions.rolePollButton}
	self:skinButton{obj=_G.CompactRaidFrameManager.displayFrame.leaderOptions.readyCheckButton}
	self:skinButton{obj=_G.CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton}
	_G.CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:GetNormalTexture():SetAlpha(1) -- icon
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

aObj.blizzFrames[ftype].ContainerFrames = function(self)
	if not self.db.profile.ContainerFrames.skin or self.initialized.ContainerFrames then return end
	self.initialized.ContainerFrames = true

	local objName, obj, cfpb
	for i = 1, _G.NUM_CONTAINER_FRAMES do
		objName = "ContainerFrame" .. i
		obj = _G[objName]
		self:addSkinFrame{obj=obj, ft=ftype, kfs=true, x1=8, y1=-4, x2=-3}
		-- resize and move the bag name to make it more readable
		_G[objName .. "Name"]:SetWidth(137)
		self:moveObject{obj=_G[objName .. "Name"], x=-17}
		-- Add gear texture to portrait button for settings
		cfpb = obj.PortraitButton
		cfpb.gear = cfpb:CreateTexture(nil, "artwork")
		cfpb.gear:SetAllPoints()
		cfpb.gear:SetTexture([[Interface\AddOns\]] .. aName .. [[\Textures\gear]])
		cfpb:SetSize(18, 18)
		cfpb.Highlight:ClearAllPoints()
		cfpb.Highlight:SetPoint("center")
		cfpb.Highlight:SetSize(22, 22)
		self:moveObject{obj=cfpb, x=7, y=-5}
		if self.modBtnBs then
			-- skin the item buttons
			local bo
			for i = 1, _G.MAX_CONTAINER_ITEMS do
				bo = _G[objName .. "Item" .. i]
				self:addButtonBorder{obj=bo, ibt=true, reParent={_G[objName .. "Item" .. i .. "IconQuestTexture"], bo.JunkIcon, bo.UpgradeIcon, bo.flash, bo.NewItemTexture, bo.BattlepayItemTexture}}
			end
			bo = nil
		end
	end
	objName, obj, cfpb = nil, nil, nil

	self:skinEditBox{obj=_G.BagItemSearchBox, regs={6, 7}, mi=true, noInsert=true} -- 6 is text, 7 is icon
	-- Hook this to hide/show the gear button
	self:SecureHook("ContainerFrame_GenerateFrame", function(frame, size, id)
		-- if it's a profession bag
		if id ~= 0 -- ignore Backpack
		and _G.IsInventoryItemProfessionBag("player", _G.ContainerIDToInventoryID(id))
		then
			frame.PortraitButton.gear:Hide()
			frame.PortraitButton.Highlight:SetAlpha(0)
		else
			frame.PortraitButton.gear:Show()
			frame.PortraitButton.Highlight:SetAlpha(1)
		end
	end)
	-- hook this to move the Search Box to the left, away from the AutoSort button
	self:RawHook(_G.BagItemSearchBox, "SetPoint", function(this, point, relTo, relPoint, xOfs, yOfs)
		self.hooks[this].SetPoint(this, point, relTo, relPoint, 50, -35)
	end, true)
	self:addButtonBorder{obj=_G.BagItemAutoSortButton, ofs=0, y1=1}
	self:skinButton{obj=_G.BagHelpBox.CloseButton, cb=true}

end

aObj.blizzFrames[ftype].DressUpFrame = function(self)
	if not self.db.profile.DressUpFrame or self.initialized.DressUpFrame then return end
	self.initialized.DressUpFrame = true

	if IsAddOnLoaded("DressUp") then
		aObj.blizzFrames[ftype].DressUpFrame = nil
		return
	end

	self:skinDropDown{obj=_G.DressUpFrame.OutfitDropDown, y2=-4}
	_G.DressUpModel.controlFrame:DisableDrawLayer("BACKGROUND")
	local mmf = self:getChild(_G.DressUpFrame, 4) -- MaximizeMinimizeFrame
	mmf:DisableDrawLayer("BACKGROUND") -- button texture
	self:skinButton{obj=mmf.MaximizeButton, ob3="↕"} -- up-down arrow
	self:skinButton{obj=mmf.MinimizeButton, ob3="↕"} -- up-down arrow
	mmf = nil
	self:addSkinFrame{obj=_G.DressUpFrame, ft=ftype, kfs=true, ri=true, ofs=2, x2=1, y2=-4}

end

aObj.blizzLoDFrames[ftype].EncounterJournal = function(self)
	if not self.db.profile.EncounterJournal or self.initialized.EncounterJournal then return end
	self.initialized.EncounterJournal = true

	-- ignore first search button
	self.ignoreBtns[_G.EncounterJournal.searchBox.sbutton1] = true

	self:removeInset(_G.EncounterJournal.inset)
	self:addSkinFrame{obj=_G.EncounterJournal, ft=ftype, kfs=true, y1=2, x2=1}

-->>-- Search EditBox, dropdown and results frame
	self:skinEditBox{obj=_G.EncounterJournal.searchBox, regs={6, 7}, mi=true} -- 6 is text, 7 is icon
	self:addSkinFrame{obj=_G.EncounterJournal.searchBox.searchPreviewContainer, ft=ftype, kfs=true}
	-- adjust skinframe as parent frame is resized when populated
	_G.EncounterJournal.searchBox.searchPreviewContainer.sf:SetPoint("TOPLEFT", _G.EncounterJournal.searchBox.searchPreviewContainer.topBorder, "TOPLEFT", 0, 1)
	_G.EncounterJournal.searchBox.searchPreviewContainer.sf:SetPoint("BOTTOMRIGHT", _G.EncounterJournal.searchBox.searchPreviewContainer.botRightCorner, "BOTTOMRIGHT", 0, 4)
	_G.LowerFrameLevel(_G.EncounterJournal.searchBox.searchPreviewContainer.sf)
	for i = 1, #_G.EncounterJournal.searchBox.searchPreview do
		_G.EncounterJournal.searchBox.searchPreview[i]:SetNormalTexture(nil)
		_G.EncounterJournal.searchBox.searchPreview[i]:SetPushedTexture(nil)
	end
	_G.EncounterJournal.searchBox.showAllResults:SetNormalTexture(nil)
	_G.EncounterJournal.searchBox.showAllResults:SetPushedTexture(nil)

	self:addSkinFrame{obj=_G.EncounterJournal.searchResults, ft=ftype, kfs=true, ofs=6, y1=-1, x2=4}
	self:skinSlider{obj=_G.EncounterJournal.searchResults.scrollFrame.scrollBar, wdth=-4}
	local btn
	for i = 1, #_G.EncounterJournal.searchResults.scrollFrame.buttons do
		btn = _G.EncounterJournal.searchResults.scrollFrame.buttons[i]
		self:removeRegions(btn, {1})
		btn:GetNormalTexture():SetAlpha(0)
		btn:GetPushedTexture():SetAlpha(0)
		self:addButtonBorder{obj=btn, relTo=btn.icon}
	end
	btn = nil

-->>-- Nav Bar
	_G.EncounterJournal.navBar:DisableDrawLayer("BACKGROUND")
	_G.EncounterJournal.navBar:DisableDrawLayer("BORDER")
	_G.EncounterJournal.navBar.overlay:DisableDrawLayer("OVERLAY")
	_G.EncounterJournal.navBar.overflow:GetNormalTexture():SetAlpha(0)
	_G.EncounterJournal.navBar.overflow:GetPushedTexture():SetAlpha(0)
	_G.EncounterJournal.navBar.home:DisableDrawLayer("OVERLAY")
	_G.EncounterJournal.navBar.home:GetNormalTexture():SetAlpha(0)
	_G.EncounterJournal.navBar.home:GetPushedTexture():SetAlpha(0)
	_G.EncounterJournal.navBar.home.text:SetPoint("RIGHT", -20, 0)


-->>-- InstanceSelect frame
	_G.EncounterJournal.instanceSelect.bg:SetAlpha(0)
	self:skinDropDown{obj=_G.EncounterJournal.instanceSelect.tierDropDown}
	self:skinSlider{obj=_G.EncounterJournal.instanceSelect.scroll.ScrollBar, wdth=-6}
	self:addSkinFrame{obj=_G.EncounterJournal.instanceSelect.scroll, ft=ftype, ofs=6, x2=4}
	-- Hook this to skin the Instance buttons
	self:SecureHook("EncounterJournal_ListInstances", function()
		local btn
		for i = 1, 30 do
			btn = _G.EncounterJournal.instanceSelect.scroll.child["instance" .. i]
			if btn then
				self:addButtonBorder{obj=btn, relTo=btn.bgImage, ofs=0}
			end
		end
		btn = nil
	end)
	-- Tabs
	local tab
	for i = 1, #_G.EncounterJournal.instanceSelect.Tabs do
		tab = _G.EncounterJournal.instanceSelect.Tabs[i]
		tab:DisableDrawLayer("BACKGROUND") -- background textures
		tab:DisableDrawLayer("OVERLAY") -- selected textures
		aObj:addSkinFrame{obj=tab, ft=ftype, noBdr=aObj.isTT, x1=-11, y1=-2, x2=11, y2=-4}
		tab.sf.ignore = true
		if i == 1 then
			if aObj.isTT then aObj:setActiveTab(tab.sf) end
		else
			if aObj.isTT then aObj:setInactiveTab(tab.sf) end
		end
	end
	tab = nil
	if aObj.isTT then
		self:SecureHook("EJ_ContentTab_Select", function(id)
			for i = 1, #_G.EncounterJournal.instanceSelect.Tabs do
				if i == id then
					aObj:setActiveTab(_G.EncounterJournal.instanceSelect.Tabs[i].sf)
				else
					aObj:setInactiveTab(_G.EncounterJournal.instanceSelect.Tabs[i].sf)
				end
			end
		end)
	end
-->>-- Encounter frame
	local eje = _G.EncounterJournal.encounter

	-- Instance frame
	eje.instance.loreBG:SetTexCoord(0.06, 0.70, 0.08, 0.58)
	eje.instance.loreBG:SetSize(370, 308)
	-- self:moveObject{obj=eje.instance.title, y=40}
	eje.instance:DisableDrawLayer("ARTWORK")
	self:moveObject{obj=eje.instance.mapButton, x=-20, y=-18}
	self:addButtonBorder{obj=eje.instance.mapButton, relTo=eje.instance.mapButton.texture, x1=2, y1=-1, x2=-2, y2=1}
	self:skinSlider{obj=eje.instance.loreScroll.ScrollBar, wdth=-4}
	eje.instance.loreScroll.child.lore:SetTextColor(self.BTr, self.BTg, self.BTb)
	-- Boss/Creature buttons
	local function skinBossBtns()
		local btn
		for i = 1, 30 do
			btn = _G["EncounterJournalBossButton" .. i]
			if btn then
				-- btn:DisableDrawLayer("ARTWORK")
				btn:SetNormalTexture(nil)
				btn:SetPushedTexture(nil)
			end
		end
		btn = nil
	end
	self:SecureHook("EncounterJournal_DisplayInstance", function(instanceID, noButton)
		skinBossBtns()
	end)
	-- skin any existing Boss Buttons
	skinBossBtns()

	local function skinFilterBtn(btn)

		btn:DisableDrawLayer("BACKGROUND")
		btn:SetNormalTexture(nil)
		btn:SetPushedTexture(nil)
		aObj:skinButton{obj=btn, x1=-11, y1=-2, x2=11, y2=2}

	end
	-- Info frame
	eje.info:DisableDrawLayer("BACKGROUND")
	eje.info.encounterTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
	eje.info.instanceButton:SetNormalTexture(nil)
	eje.info.instanceButton:SetPushedTexture(nil)
	eje.info.instanceButton:SetHighlightTexture([[Interface\EncounterJournal\UI-EncounterJournalTextures]])
	eje.info.instanceButton:GetHighlightTexture():SetTexCoord(0.68945313, 0.81054688, 0.33300781, 0.39257813)
	self:skinSlider{obj=eje.info.bossesScroll.ScrollBar, wdth=-4}
	skinFilterBtn(eje.info.difficulty)
	-- self:skinDropDown{obj=eje.info.difficultyDD} -- DD already skinned
	eje.info.reset:SetNormalTexture(nil)
	eje.info.reset:SetPushedTexture(nil)
	self:skinButton{obj=eje.info.reset, y2=2}
	self:skinSlider{obj=eje.info.detailsScroll.ScrollBar, wdth=-4}
	eje.info.detailsScroll.child.description:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:skinSlider{obj=eje.info.overviewScroll.ScrollBar, wdth=-4}
	eje.info.overviewScroll.child.loreDescription:SetTextColor(self.BTr, self.BTg, self.BTb)
	eje.info.overviewScroll.child.header:SetTexture(nil)
	eje.info.overviewScroll.child.overviewDescription.Text:SetTextColor(self.BTr, self.BTg, self.BTb)
	-- Hook this to skin headers
	self:SecureHook("EncounterJournal_ToggleHeaders", function(this, doNotShift)
		local objName = "EncounterJournalInfoHeader"
		if this.isOverview then
			objName = "EncounterJournalOverviewInfoHeader"
		end
		for i = 1, 25 do
			if _G[objName .. i] then
				_G[objName .. i].button:DisableDrawLayer("BACKGROUND")
				_G[objName .. i].overviewDescription.Text:SetTextColor(self.BTr, self.BTg, self.BTb)
				for j = 1, #_G[objName .. i].Bullets do
					_G[objName .. i].Bullets[j].Text:SetTextColor(self.BTr, self.BTg, self.BTb)
				end
				_G[objName .. i].description:SetTextColor(self.BTr, self.BTg, self.BTb)
				_G[objName .. i].descriptionBG:SetAlpha(0)
				_G[objName .. i].descriptionBGBottom:SetAlpha(0)
				_G[objName .. i .. "HeaderButtonPortraitFrame"]:SetAlpha(0)
			end
		end
		objName = nil
	end)

	-- Loot Frame
	self:skinSlider{obj=eje.info.lootScroll.scrollBar, wdth=-4}
	skinFilterBtn(eje.info.lootScroll.filter)
	skinFilterBtn(eje.info.lootScroll.slotFilter)
	eje.info.lootScroll.classClearFilter:DisableDrawLayer("BACKGROUND")
	-- self:skinDropDown{obj=eje.info.lootScroll.lootFilter} -- DD already skinned
	-- hook this to skin loot entries
	self:SecureHook("EncounterJournal_LootUpdate", function()
		local btn
		for i = 1, #_G.EncounterJournal.encounter.info.lootScroll.buttons do
			btn = _G.EncounterJournal.encounter.info.lootScroll.buttons[i]
			btn:DisableDrawLayer("BORDER")
			btn.armorType:SetTextColor(self.BTr, self.BTg, self.BTb)
			btn.slot:SetTextColor(self.BTr, self.BTg, self.BTb)
			btn.boss:SetTextColor(self.BTr, self.BTg, self.BTb)
			self:addButtonBorder{obj=btn, relTo=btn.icon, x1=0}
		end
		btn = nil
	end)

	-- Model Frame
	eje.info.model:DisableDrawLayer("BACKGROUND") -- dungeonBG (updated with dungeon type change)
	self:rmRegionsTex(eje.info.model, {2, 3}) -- Shadow, TitleBG
	local function skinCreatureBtn(idx)
		local btn = _G.EncounterJournal.encounter.info.creatureButtons[idx]
		if btn and not btn.sknd then
			btn.sknd = true
			btn:SetNormalTexture(nil)
			local hTex = btn:GetHighlightTexture()
			hTex:SetTexture([[Interface\EncounterJournal\UI-EncounterJournalTextures]])
			hTex:SetTexCoord(0.68945313, 0.81054688, 0.33300781, 0.39257813)
		end
		btn = nil
	end
	-- creature(s)
	for i = 1, #eje.info.creatureButtons do
		skinCreatureBtn(eje.info.creatureButtons[i])
	end
	-- hook this to skin additional buttons
	self:SecureHook("EncounterJournal_GetCreatureButton", function(index)
		if index > 9 then return end -- MAX_CREATURES_PER_ENCOUNTER
		skinCreatureBtn(index)
	end)

	-- Tabs (side)
	local ejeTabs = {"overviewTab", "lootTab", "bossTab", "modelTab"}
	self:moveObject{obj=eje.info.overviewTab, x=10}
	local obj
	for i = 1, #ejeTabs do
		obj = eje.info[ejeTabs[i]]
		obj:SetNormalTexture(nil)
		obj:SetPushedTexture(nil)
		obj:GetDisabledTexture():SetAlpha(0) -- tab texture is modified
		self:addSkinFrame{obj=obj, ft=ftype, noBdr=true, ofs=-3, aso={rotate=true}} -- gradient is right to left
	end
	eje, ejeTabs, obj = nil, nil, nil

	-- EncounterJournalTooltip
	self:addSkinFrame{obj=_G.EncounterJournalTooltip, ft=ftype}

-->>-- Suggest frame
	local ejsf = _G.EncounterJournal.suggestFrame
	-- Suggestion1 panel
	ejsf.Suggestion1.bg:SetTexture(nil)
	ejsf.Suggestion1.iconRing:SetTexture(nil)
	ejsf.Suggestion1.centerDisplay.title.text:SetTextColor(self.HTr, self.HTg, self.HTb)
	ejsf.Suggestion1.centerDisplay.description.text:SetTextColor(self.BTr, self.BTg, self.BTb)
	ejsf.Suggestion1.reward.text:SetTextColor(self.BTr, self.BTg, self.BTb)
	ejsf.Suggestion1.reward.iconRing:SetTexture(nil)
	self:addButtonBorder{obj=ejsf.Suggestion1.prevButton, ofs=-2, y1=-3, x2=-3}
	self:addButtonBorder{obj=ejsf.Suggestion1.nextButton, ofs=-2, y1=-3, x2=-3}
	-- add skin frame to surround all the Suggestions, so tabs look better than without a frame
	self:addSkinFrame{obj=ejsf.Suggestion1, ft=ftype, x1=-34, y1=24, x2=426, y2=-28}
	-- Suggestion2 panel (Dungeons)
	ejsf.Suggestion2.bg:SetTexture(nil)
	ejsf.Suggestion2.iconRing:SetTexture(nil)
	ejsf.Suggestion2.centerDisplay.title.text:SetTextColor(self.HTr, self.HTg, self.HTb)
	ejsf.Suggestion2.centerDisplay.description.text:SetTextColor(self.BTr, self.BTg, self.BTb)
	ejsf.Suggestion2.reward.iconRing:SetTexture(nil)
	-- Suggestion3 panel (Raids)
	ejsf.Suggestion3.bg:SetTexture(nil)
	ejsf.Suggestion3.iconRing:SetTexture(nil)
	ejsf.Suggestion3.centerDisplay.title.text:SetTextColor(self.HTr, self.HTg, self.HTb)
	ejsf.Suggestion3.centerDisplay.description.text:SetTextColor(self.BTr, self.BTg, self.BTb)
	ejsf.Suggestion3.reward.iconRing:SetTexture(nil)
	ejsf = nil

	-- LootJournal panel
	local ejlj = _G.EncounterJournal.LootJournal
	ejlj:DisableDrawLayer("BACKGROUND")
	self:skinDropDown{obj=ejlj.ViewDropDown}
	self:skinDropDown{obj=ejlj.ClassDropDown}
	-- LegendariesFrame
	skinFilterBtn(ejlj.LegendariesFrame.SlotButton)
	self:skinDropDown{obj=ejlj.LegendariesFrame.SlotDropDown}
	skinFilterBtn(ejlj.LegendariesFrame.ClassButton)
	self:skinDropDown{obj=ejlj.LegendariesFrame.ClassDropDown}
	self:skinSlider{obj=ejlj.LegendariesFrame.ScrollBar, wdth=-4, size=3}
	self:addSkinFrame{obj=ejlj, ft=ftype, ofs=6, x1=-5, y2=-3}
	local btn
	for i = 1 , #ejlj.LegendariesFrame.buttons do
		btn = ejlj.LegendariesFrame.buttons[i]
		btn.Background:SetTexture(nil)
		self.modUIBtns:addButtonBorder{obj=btn, relTo=btn.Icon, es=14} -- use module function here to force creation
		btn.sbb:SetBackdropBorderColor(1.0, 0.5, 0, 1) -- legendary item colour #ff8000
		btn = ejlj.LegendariesFrame.rightSideButtons[i]
		btn.Background:SetTexture(nil)
		self.modUIBtns:addButtonBorder{obj=btn, relTo=btn.Icon, es=14} -- use module function here to force creation
		btn.sbb:SetBackdropBorderColor(1.0, 0.5, 0, 1) -- legendary item colour #ff8000
	end
	btn = nil
	-- ItemSetsFrame
	self:skinSlider{obj=ejlj.ItemSetsFrame.ScrollBar, wdth=-4, size=3}
	skinFilterBtn(ejlj.ItemSetsFrame.ClassButton)
	for i = 1 , #ejlj.ItemSetsFrame.buttons do
		ejlj.ItemSetsFrame.buttons[i].Background:SetTexture(nil)
	end
	ejlj = nil

end

aObj.blizzFrames[ftype].EquipmentFlyout = function(self)
	if not self.db.profile.EquipmentFlyout or self.initialized.EquipmentFlyout then return end
	self.initialized.EquipmentFlyout = true

	self:addSkinFrame{obj=_G.EquipmentFlyoutFrame.buttonFrame, ft=ftype, x1=-3, y1=2, x2=5, y2=-3}
	self:SecureHook("EquipmentFlyout_Show", function(...)
		for i = 1, _G.EquipmentFlyoutFrame.buttonFrame["numBGs"] do
			_G.EquipmentFlyoutFrame.buttonFrame["bg" .. i]:SetAlpha(0)
		end
	end)

end

aObj.blizzFrames[ftype].FriendsFrame = function(self)
	if not self.db.profile.FriendsFrame or self.initialized.FriendsFrame then return end
	self.initialized.FriendsFrame = true

	self:skinTabs{obj=_G.FriendsFrame, lod=true}
	self:addSkinFrame{obj=_G.FriendsFrame, ft=ftype, kfs=true, ri=true, y1=2, x2=1, y2=-5}

	self:skinDropDown{obj=_G.FriendsDropDown}
	self:skinDropDown{obj=_G.TravelPassDropDown}
	-- FriendsTabHeader Frame
	_G.FriendsFrameBattlenetFrame:DisableDrawLayer("BACKGROUND")
	self:addButtonBorder{obj=_G.FriendsFrameBattlenetFrame.BroadcastButton, ofs=-2}
	self:addSkinFrame{obj=_G.FriendsFrameBattlenetFrame.BroadcastFrame.ScrollFrame, ft=ftype, kfs=true, ofs=4}
	_G.FriendsFrameBattlenetFrame.BroadcastFrame.ScrollFrame.EditBox.PromptText:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:addSkinFrame{obj=_G.FriendsFrameBattlenetFrame.BroadcastFrame, ft=ftype, ofs=-10}
	self:addSkinFrame{obj=_G.FriendsFrameBattlenetFrame.UnavailableInfoFrame, ft=ftype}
	self:skinDropDown{obj=_G.FriendsFrameStatusDropDown}
	_G.FriendsFrameStatusDropDownStatus:SetAlpha(1) -- display status icon
	self:skinEditBox{obj=_G.FriendsFrameBroadcastInput, regs={6, 7}, mi=true, noWidth=true, noHeight=true, noMove=true} -- 6 is text, 7 is icon
	_G.FriendsFrameBroadcastInputFill:SetTextColor(self.BTr, self.BTg, self.BTb)
	_G.PanelTemplates_SetNumTabs(_G.FriendsTabHeader, 3) -- adjust for Friends, QuickJoin & Ignore
	self:skinTabs{obj=_G.FriendsTabHeader, up=true, lod=true, x1=0, y1=-5, x2=0, y2=-5}
	self:addButtonBorder{obj=_G.FriendsTabHeaderRecruitAFriendButton}
	self:addButtonBorder{obj=_G.FriendsTabHeaderSoRButton}

	-- RecruitAFriendFrame
	self:skinEditBox{obj=_G.RecruitAFriendNameEditBox, regs={6}} -- 6 is text
	_G.RecruitAFriendNameEditBox.Fill:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:addSkinFrame{obj=_G.RecruitAFriendNoteFrame, ft=ftype, kfs=true}
	_G.RecruitAFriendNoteEditBox.Fill:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:addSkinFrame{obj=_G.RecruitAFriendFrame, ft=ftype, kfs=true, ofs=-6, y1=-7}

	-- FriendsList Frame
	self:addButtonBorder{obj=_G.FriendsFrameFriendsScrollFrame.PendingInvitesHeaderButton}
	_G.FriendsFrameFriendsScrollFrame.PendingInvitesHeaderButton.BG:SetTexture(nil)
	for invite in _G.FriendsFrameFriendsScrollFrame.invitePool:EnumerateActive() do
		self:skinButton{obj=invite.DeclineButton}
		self:skinButton{obj=invite.AcceptButton}
	end
	local sBar = _G.FriendsFrameFriendsScrollFrame.scrollBar
	self:skinSlider{obj=sBar, rt="background"}
	-- adjust width of FFFSF so it looks right (too thin by default)
	sBar:ClearAllPoints()
	sBar:SetPoint("TOPRIGHT", "FriendsFrame", "TOPRIGHT", -8, -101)
	sBar:SetPoint("BOTTOMLEFT", "FriendsFrame", "BOTTOMRIGHT", -24, 40)
	sBar = nil
	local btn
	for i = 1, _G.FRIENDS_FRIENDS_TO_DISPLAY do
		btn = _G["FriendsFrameFriendsScrollFrameButton" .. i]
		btn.background:SetAlpha(0)
		self:addButtonBorder{obj=btn, relTo=btn.gameIcon, hide=true, ofs=0}
		self:addButtonBorder{obj=btn.travelPassButton, hide=true, disable=true, ofs=0, y1=3, y2=-2}
		self:addButtonBorder{obj=btn.summonButton, hide=true, disable=true}
	end
	btn = nil

	-- Friends Tooltip
	self:addSkinFrame{obj=_G.FriendsTooltip}

-->>-- Add Friend Frame
	self:addSkinFrame{obj=_G.AddFriendFrame, ft=ftype, kfs=true}
	self:skinEditBox{obj=_G.AddFriendNameEditBox, regs={6}} -- 6 is text
	self:addSkinFrame{obj=_G.AddFriendNoteFrame, ft=ftype, kfs=true}
	self:skinSlider{obj=_G.AddFriendNoteFrameScrollFrame.ScrollBar}

-->>-- FriendsFriends Frame
	self:skinDropDown{obj=_G.FriendsFriendsFrameDropDown}
	self:addSkinFrame{obj=_G.FriendsFriendsList, ft=ftype}
	self:skinSlider{obj=_G.FriendsFriendsScrollFrame.ScrollBar}
	self:addSkinFrame{obj=_G.FriendsFriendsFrame, ft=ftype}

-->>-- QuickJoin Frame
	self:skinDropDown{obj=_G.QuickJoinFrameDropDown}
	local sBar = _G.QuickJoinFrame.ScrollFrame.scrollBar
	self:skinSlider{obj=sBar, rt="background"}
	-- adjust width of QJSF so it looks right (too thin by default)
	sBar:ClearAllPoints()
	sBar:SetPoint("TOPRIGHT", "FriendsFrame", "TOPRIGHT", -8, -101)
	sBar:SetPoint("BOTTOMLEFT", "FriendsFrame", "BOTTOMRIGHT", -24, 40)
	sBar = nil
	self:removeMagicBtnTex(_G.QuickJoinFrame.JoinQueueButton)
	-- QuickJoinRoleSelectionFrame
	for i = 1, #_G.QuickJoinRoleSelectionFrame.Roles do
		self:skinCheckButton{obj=_G.QuickJoinRoleSelectionFrame.Roles[i].CheckButton}
	end
	self:addSkinFrame{obj=_G.QuickJoinRoleSelectionFrame, ft=ftype, ofs=-5}

-->>--	IgnoreList Frame
	self:keepFontStrings(_G.IgnoreListFrame)
	self:skinSlider{obj=_G.FriendsFrameIgnoreScrollFrame.ScrollBar}

-->>--	Who Tab Frame
	self:removeInset(_G.WhoFrameListInset)
	self:skinColHeads("WhoFrameColumnHeader")
	-- remove col head 2 as it is really a dropdown
	_G.WhoFrameColumnHeader2.sf.tfade:SetTexture(nil)
	_G.WhoFrameColumnHeader2.sf:SetBackdrop(nil)
	_G.WhoFrameColumnHeader2.sf:Hide()
	self:removeInset(_G.WhoFrameEditBoxInset)
	self:skinDropDown{obj=_G.WhoFrameDropDown}
	self:skinSlider{obj=_G.WhoListScrollFrame.ScrollBar}
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
	self:skinSlider{obj=_G.ChannelListScrollFrame.ScrollBar, rt="artwork"}
	self:skinSlider{obj=_G.ChannelRosterScrollFrame.ScrollBar, rt="background"}
	-- Channel Pullout Tab & Frame
	self:keepRegions(_G.ChannelPulloutTab, {4, 5}) -- N.B. region 4 is text, 5 is highlight
	self:addSkinFrame{obj=_G.ChannelPulloutTab, ft=ftype, noBdr=aObj.isTT, y1=-8, y2=-5}
	self:addSkinFrame{obj=_G.ChannelPulloutBackground, ft=ftype, nb=true}
	self:skinButton{obj=_G.ChannelPulloutCloseButton, cb=true}
	_G.RaiseFrameLevel(_G.ChannelPulloutCloseButton) -- bring above Background frame
	self:addButtonBorder{obj=_G.ChannelPulloutRosterScrollUpBtn, ofs=-2}
	self:addButtonBorder{obj=_G.ChannelPulloutRosterScrollDownBtn, ofs=-2}
-->>--	Daughter Frame
	self:skinEditBox{obj=_G.ChannelFrameDaughterFrameChannelName, regs={6}, noWidth=true} -- 6 is text
	self:skinEditBox{obj=_G.ChannelFrameDaughterFrameChannelPassword, regs={6, 7}, noWidth=true} -- 6 & 7 are text
	self:moveObject{obj=_G.ChannelFrameDaughterFrameOkayButton, x=-2}
	self:addSkinFrame{obj=_G.ChannelFrameDaughterFrame, ft=ftype, kfs=true, x1=2, y1=-6, x2=-5}
	self:skinDropDown{obj=_G.ChannelListDropDown}
	self:skinDropDown{obj=_G.ChannelRosterDropDown}

-->>--	Raid Tab Frame
	self:skinButton{obj=_G.RaidFrameConvertToRaidButton}
	self:skinButton{obj=_G.RaidFrameRaidInfoButton}

	if IsAddOnLoaded("Blizzard_RaidUI") then
		self:checkAndRun("RaidUI", "p", true)
	end

-->>--	RaidInfo Frame
	self:addSkinFrame{obj=_G.RaidInfoInstanceLabel, kfs=true}
	self:addSkinFrame{obj=_G.RaidInfoIDLabel, kfs=true}
	self:skinSlider{obj=_G.RaidInfoScrollFrame.scrollBar}
	self:addSkinFrame{obj=_G.RaidInfoFrame, ft=ftype, kfs=true, hdr=true}

-->>-- BattleTagInvite Frame
	self:addSkinFrame{obj=_G.BattleTagInviteFrame}

end

aObj.blizzLoDFrames[ftype].GuildControlUI = function(self)
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
			obj = _G["GuildControlUIRankOrderFrameRank" .. i]
			if obj and not obj.sknd then
				obj.sknd = true
				aObj:skinEditBox{obj=obj.nameBox, regs={6}, x=-5}
				aObj:addButtonBorder{obj=obj.downButton, ofs=0}
				aObj:addButtonBorder{obj=obj.upButton, ofs=0}
				aObj:addButtonBorder{obj=obj.deleteButton, ofs=0}
			end
		end
		obj = nil

	end
	self:SecureHook("GuildControlUI_RankOrder_Update", function(...)
		skinROFrames()
	end)
	skinROFrames()
	-- Rank Permissions Panel
	_G.GuildControlUI.rankPermFrame:DisableDrawLayer("BACKGROUND")
	self:skinDropDown{obj=_G.GuildControlUI.rankPermFrame.dropdown}
	_G.UIDropDownMenu_SetButtonWidth(_G.GuildControlUI.rankPermFrame.dropdown, 24)
	self:skinEditBox{obj=_G.GuildControlUI.rankPermFrame.goldBox, regs={6}}
	-- Bank Tab Permissions panel
	self:keepFontStrings(_G.GuildControlUI.bankTabFrame.scrollFrame)
	self:skinSlider{obj=_G.GuildControlUIRankBankFrameInsetScrollFrameScrollBar}
	self:skinDropDown{obj=_G.GuildControlUI.bankTabFrame.dropdown}
	_G.UIDropDownMenu_SetButtonWidth(_G.GuildControlUI.bankTabFrame.dropdown, 24)
	_G.GuildControlUI.bankTabFrame.inset:DisableDrawLayer("BACKGROUND")
	_G.GuildControlUI.bankTabFrame.inset:DisableDrawLayer("BORDER")
	-- hook this as buttons are created as required
	self:SecureHook("GuildControlUI_BankTabPermissions_Update", function(this)
		local btn
		for i = 1, _G.MAX_GUILDBANK_TABS do
			btn = _G["GuildControlBankTab" .. i]
			if btn and not btn.sknd then
				btn.sknd = true
				btn:DisableDrawLayer("BACKGROUND")
				self:skinEditBox{obj=btn.owned.editBox, regs={6}}
				self:skinButton{obj=btn.buy.button, as=true}
				self:addButtonBorder{obj=btn.owned, relTo=btn.owned.tabIcon, es=10}
			end
		end
		btn = nil
	end)

end

aObj.blizzLoDFrames[ftype].GuildUI = function(self)
	if not self.db.profile.GuildUI or self.initialized.GuildUI then return end
	self.initialized.GuildUI = true

-->>-- Guild Frame
	self:removeInset(_G.GuildFrameBottomInset)
	self:skinDropDown{obj=_G.GuildDropDown}
	-- GuildPoint Frame
	_G.GuildPointFrame.LeftCap:SetTexture(nil)
	_G.GuildPointFrame.RightCap:SetTexture(nil)
	-- GuildFaction Frame
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
	-- GuildNameChange Frame
	self:skinEditBox{obj=_G.GuildNameChangeFrame.editBox, regs={6}}

-->>-- GuildRoster Frame
	self:skinDropDown{obj=_G.GuildRosterViewDropdown}
	self:skinColHeads("GuildRosterColumnButton", 5)
	self:skinSlider{obj=_G.GuildRosterContainerScrollBar, wdth=-4}
	local btn
	for i = 1, #_G.GuildRosterContainer.buttons do
		btn = _G.GuildRosterContainer.buttons[i]
		btn:DisableDrawLayer("BACKGROUND")
		btn.barTexture:SetTexture(self.sbTexture)
		btn.header.leftEdge:SetAlpha(0)
		btn.header.rightEdge:SetAlpha(0)
		btn.header.middle:SetAlpha(0)
		self:applySkin{obj=btn.header}
		self:addButtonBorder{obj=btn, relTo=btn.icon, hide=true, es=12}
	end
	btn = nil
	self:skinDropDown{obj=_G.GuildMemberRankDropdown}
	-- adjust text position & font so it overlays correctly
	self:moveObject{obj=_G.GuildMemberRankDropdown, x=-6, y=2}
	_G.GuildMemberRankDropdownText:SetFontObject(_G.GameFontHighlight)
	self:addSkinFrame{obj=_G.GuildMemberNoteBackground, ft=ftype}
	self:addSkinFrame{obj=_G.GuildMemberOfficerNoteBackground, ft=ftype}
	self:addSkinFrame{obj=_G.GuildMemberDetailFrame, ft=ftype, kfs=true, nb=true, ofs=-6}

-->>-- GuildNews Frame
	_G.GuildNewsFrame:DisableDrawLayer("BACKGROUND")
	self:skinSlider{obj=_G.GuildNewsContainerScrollBar, wdth=-6}
	for i = 1, #_G.GuildNewsContainer.buttons do
		_G.GuildNewsContainer.buttons[i].header:SetAlpha(0)
	end
	-- hook this to stop tooltip flickering
	self:SecureHook("GuildNewsButton_OnEnter", function(btn)
		if btn.UpdateTooltip then btn.UpdateTooltip = nil end
	end)
	self:skinDropDown{obj=_G.GuildNewsDropDown}
	self:addSkinFrame{obj=_G.GuildNewsFiltersFrame, ft=ftype, kfs=true, ofs=-7}
	self:keepFontStrings(_G.GuildNewsBossModelTextFrame)
	self:addSkinFrame{obj=_G.GuildNewsBossModel, ft=ftype, kfs=true, ofs=4, y2=-81} -- similar to QuestNPCModel
	-- Rewards Panel
	_G.GuildRewardsFrame:DisableDrawLayer("BACKGROUND")
	self:skinSlider{obj=_G.GuildRewardsContainerScrollBar, wdth=-4}
	local btn
	for i = 1, #_G.GuildRewardsContainer.buttons do
		btn = _G.GuildRewardsContainer.buttons[i]
		btn:GetNormalTexture():SetAlpha(0)
		btn.disabledBG:SetAlpha(0)
		self:addButtonBorder{obj=btn, relTo=btn.icon, reParent={btn.lock}}
	end
	btn = nil
	self:skinDropDown{obj=_G.GuildRewardsDropDown}

-->>-- GuildPerks Frame
	_G.GuildAllPerksFrame:DisableDrawLayer("BACKGROUND")
	local btn
	for i = 1, #_G.GuildPerksContainer.buttons do
		btn = _G.GuildPerksContainer.buttons[i]
		-- can't use DisableDrawLayer as the update code uses it
		self:removeRegions(btn, {1, 2, 3, 4})
		btn.normalBorder:DisableDrawLayer("BACKGROUND")
		btn.disabledBorder:DisableDrawLayer("BACKGROUND")
		self:addButtonBorder{obj=btn, relTo=btn.icon, reParent={btn.lock}}
	end
	btn = nil

-->>-- GuildInfo Frame
	self:removeRegions(_G.GuildInfoFrame, {1, 2, 3, 4, 5, 6 ,7, 8}) -- Background textures and bars
	self:skinTabs{obj=_G.GuildInfoFrame, up=true, lod=true, x1=2, y1=-5, x2=2, y2=-5}
	self:removeMagicBtnTex(_G.GuildAddMemberButton)
	self:removeMagicBtnTex(_G.GuildControlButton)
	self:removeMagicBtnTex(_G.GuildViewLogButton)
	-- GuildInfoFrameInfo Frame
	self:keepFontStrings(_G.GuildInfoFrameInfo)
	self:skinSlider{obj=_G.GuildInfoDetailsFrameScrollBar, wdth=-4}
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
	local btn
	for i = 1, #_G.GuildInfoFrameApplicantsContainer.buttons do
		btn = _G.GuildInfoFrameApplicantsContainer.buttons[i]
		self:applySkin{obj=btn}
		btn.ring:SetAlpha(0)
		btn.PointsSpentBgGold:SetAlpha(0)
		self:moveObject{obj=btn.PointsSpentBgGold, x=6, y=-6}
	end
	btn = nil
	self:skinSlider{obj=_G.GuildInfoFrameApplicantsContainerScrollBar, wdth=-4}
	self:removeMagicBtnTex(_G.GuildRecruitmentInviteButton)
	self:removeMagicBtnTex(_G.GuildRecruitmentMessageButton)
	self:removeMagicBtnTex(_G.GuildRecruitmentInviteButton)
	-- Guild Text Edit frame
	self:skinSlider{obj=_G.GuildTextEditScrollFrameScrollBar, wdth=-6}
	self:addSkinFrame{obj=_G.GuildTextEditContainer, ft=ftype, nb=true}
	self:addSkinFrame{obj=_G.GuildTextEditFrame, ft=ftype, kfs=true, nb=true, ofs=-7}
	-- Guild Log Frame
	self:skinSlider{obj=_G.GuildLogScrollFrame.ScrollBar, wdth=-6}
	self:addSkinFrame{obj=_G.GuildLogContainer, ft=ftype, nb=true}
	self:addSkinFrame{obj=_G.GuildLogFrame, ft=ftype, kfs=true, nb=true, ofs=-7}

end

aObj.blizzFrames[ftype].GuildInvite = function(self)
	if not self.db.profile.GuildInvite or self.initialized.GuildInvite then return end
	self.initialized.GuildInvite = true

	_G.GuildInviteFrame:DisableDrawLayer("BACKGROUND")
	_G.GuildInviteFrame:DisableDrawLayer("BORDER")
	_G.GuildInviteFrameTabardBorder:SetTexture(nil)
	_G.GuildInviteFrame:DisableDrawLayer("OVERLAY")
	self:addSkinFrame{obj=_G.GuildInviteFrame, ft=ftype}

end

aObj.blizzLoDFrames[ftype].InspectUI = function(self)
	if not self.db.profile.InspectUI or self.initialized.InspectUI then return end
	self.initialized.InspectUI = true

	if self.modBtnBs then
		self:SecureHook("InspectPaperDollItemSlotButton_Update", function(btn)
			if not btn.hasItem then
				btn.sbb:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
			end
		end)
	end
	self:skinTabs{obj=_G.InspectFrame, lod=true}
	self:addSkinFrame{obj=_G.InspectFrame, ft=ftype, kfs=true, ri=true, bgen=1, y1=2, x2=1, y2=-5}

-->>-- Inspect PaperDoll frame
	-- Inspect Model Frame
	_G.InspectModelFrame.controlFrame:DisableDrawLayer("BACKGROUND")
	local kids, btn = {_G.InspectPaperDollItemsFrame:GetChildren()}
	for i = 1, #kids do
		btn = kids[i]
		btn:DisableDrawLayer("BACKGROUND")
		if self.modBtnBs then
			self:addButtonBorder{obj=btn, ibt=true}
			if not btn.hasItem then
				btn.sbb:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
			end
		end
	end
	kids, btn = nil, nil
	_G.InspectModelFrame:DisableDrawLayer("BACKGROUND")
	_G.InspectModelFrame:DisableDrawLayer("BORDER")
	_G.InspectModelFrame:DisableDrawLayer("OVERLAY")

-->>-- PVP Frame
	self:keepFontStrings(_G.InspectPVPFrame)
	local btn
	for i = 1, _G.MAX_PVP_TALENT_TIERS do
		for j = 1, _G.MAX_PVP_TALENT_COLUMNS do
			btn = _G.InspectPVPFrame.Talents["Tier" .. i]["Talent" .. j]
			btn.Slot:SetTexture(nil)
			if self.modBtnBs then
				btn.border:SetAlpha(0)
				self:addButtonBorder{obj=btn, relTo=btn.Icon}
			end
		end
	end
	btn = nil

-->>-- Talent Frame
	self:keepFontStrings(_G.InspectTalentFrame)
	-- Specialization
	_G.InspectTalentFrame.InspectSpec.ring:SetTexture(nil)
	-- Talents
	local btn
	for i = 1, _G.MAX_TALENT_TIERS do
		for j = 1, _G.NUM_TALENT_COLUMNS do
			btn = _G.InspectTalentFrame.InspectTalents["tier" .. i]["talent" .. j]
			btn.Slot:SetTexture(nil)
			if self.modBtnBs then
				btn.border:SetAlpha(0)
				self:addButtonBorder{obj=btn, relTo=btn.icon}
			end
		end
	end
	btn = nil
	-- PortraitMouseOverFrame
	self:moveObject{obj=_G.InspectPVPFrame.PortraitBackground, x=8, y=-10}
	self:SecureHook(_G.InspectPVPFrame, "Show", function(this)
		-- Show Portrait if prestige level is greater than 0
		if _G.UnitPrestige(_G.INSPECTED_UNIT) > 0 then
			_G.InspectFrame.portrait:SetAlpha(1)
		end
	end)
	self:SecureHook(_G.InspectPVPFrame, "Hide", function(this)
		_G.InspectFrame.portrait:SetAlpha(0)
	end)

-->>-- Guild Frame
	_G.InspectGuildFrameBG:SetAlpha(0)
	_G.InspectGuildFrame.Points:DisableDrawLayer("BACKGROUND")

	-- send message when UI is skinned (used by oGlow skin)
	self:SendMessage("InspectUI_Skinned", self)

end

aObj.blizzLoDFrames[ftype].ItemSocketingUI = function(self)
	if not self.db.profile.ItemSocketingUI or self.initialized.ItemSocketingUI then return end
	self.initialized.ItemSocketingUI = true

	local function colourSockets()

		local clr
		for i = 1, _G.GetNumSockets() do
			clr = _G.GEM_TYPE_INFO[_G.GetSocketTypes(i)]
			_G["ItemSocketingSocket" .. i].sb:SetBackdropBorderColor(clr.r, clr.g, clr.b)
		end
		clr = nil

	end
	-- hook this to colour the button border
	self:SecureHook("ItemSocketingFrame_Update", function()
		colourSockets()
	end)

	self:addSkinFrame{obj=_G.ItemSocketingFrame, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-2}
	self:skinSlider{obj=_G.ItemSocketingScrollFrame.ScrollBar, size=3, rt="artwork"}

	local objName
	for i = 1, _G.MAX_NUM_SOCKETS do
		objName = "ItemSocketingSocket" .. i
		_G[objName .. "Left"]:SetAlpha(0)
		_G[objName .. "Right"]:SetAlpha(0)
		self:getRegion(_G[objName], 3):SetAlpha(0) -- button texture
		self:addSkinButton{obj=_G[objName], ft=ftype}
	end
	objName = nil
	-- now colour the sockets
	colourSockets()

end

aObj.blizzLoDFrames[ftype].LookingForGuildUI = function(self)
	if not self.db.profile.LookingForGuildUI or self.initialized.LookingForGuildUI then return end
	self.initialized.LookingForGuildUI = true

	self:skinTabs{obj=_G.LookingForGuildFrame, up=true, lod=true, x1=0, y1=-5, x2=3, y2=-5}
	self:removeMagicBtnTex(_G.LookingForGuildBrowseButton)
	self:removeMagicBtnTex(_G.LookingForGuildRequestButton)
	self:addSkinFrame{obj=_G.LookingForGuildFrame, ft=ftype, kfs=true, ri=true, y1=2, x2=1, y2=-2}

	-- Start Frame (Settings)
	_G.LookingForGuildInterestFrameBg:SetAlpha(0)
	_G.LookingForGuildAvailabilityFrameBg:SetAlpha(0)
	_G.LookingForGuildRolesFrameBg:SetAlpha(0)
	_G.LookingForGuildCommentFrameBg:SetAlpha(0)
	self:skinSlider{obj=_G.LookingForGuildCommentInputFrameScrollFrame.ScrollBar, size=3}
	self:addSkinFrame{obj=_G.LookingForGuildCommentInputFrame, ft=ftype, kfs=true, ofs=-1}
	_G.LookingForGuildCommentEditBoxFill:SetTextColor(self.BTr, self.BTg, self.BTb)

	-- Browse Frame
	self:skinSlider{obj=_G.LookingForGuildBrowseFrameContainerScrollBar, wdth=-4}
	local btn
	for i = 1, #_G.LookingForGuildBrowseFrameContainer.buttons do
		btn = _G.LookingForGuildBrowseFrameContainer.buttons[i]
		self:applySkin{obj=btn}
		_G[btn:GetName() .. "Ring"]:SetAlpha(0)
	end
	btn = nil

	-- Apps Frame (Requests)
	self:skinSlider{obj=_G.LookingForGuildAppsFrameContainerScrollBar}
	for i = 1, #_G.LookingForGuildAppsFrameContainer.buttons do
		self:applySkin{obj=_G.LookingForGuildAppsFrameContainer.buttons[i]}
	end

	-- Request Membership Frame
	_G.GuildFinderRequestMembershipEditBoxFill:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:skinSlider{obj=_G.GuildFinderRequestMembershipFrameInputFrameScrollFrame.ScrollBar, size=3}
	self:addSkinFrame{obj=_G.GuildFinderRequestMembershipFrameInputFrame, ft=ftype, x1=-2, x2=2, y2=-2}
	self:addSkinFrame{obj=_G.GuildFinderRequestMembershipFrame, ft=ftype}

end

aObj.blizzFrames[ftype].LootFrames = function(self)
	if not self.db.profile.LootFrames.skin or self.initialized.LootFrames then return end
	self.initialized.LootFrames = true

	if self.modBtnBs then
		self:SecureHook("LootFrame_Update", function()
			local btn
			for i = 1, _G.LOOTFRAME_NUMBUTTONS do
				btn = _G["LootButton" .. i]
				if btn.quality then
					_G.SetItemButtonQuality(btn, btn.quality)
				end
			end
			btn =nil
		end)
	end

	for i = 1, _G.LOOTFRAME_NUMBUTTONS do
		_G["LootButton" .. i .. "NameFrame"]:SetTexture(nil)
		self:addButtonBorder{obj=_G["LootButton" .. i], ibt=true}
	end
	self:addSkinFrame{obj=_G.LootFrame, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-2}
	self:addButtonBorder{obj=_G.LootFrameDownButton, ofs=-2}
	self:addButtonBorder{obj=_G.LootFrameUpButton, ofs=-2}

-->>-- GroupLoot frames
	local obj
	for i = 1, _G.NUM_GROUP_LOOT_FRAMES do
		obj = _G["GroupLootFrame" .. i]
		self:keepFontStrings(obj)
		obj.Timer.Background:SetAlpha(0)
		self:skinStatusBar{obj=obj.Timer, fi=0}
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
			self:addSkinFrame{obj=obj, ft=ftype, x1=97, y2=8}
		end
	end
	obj = nil

-->>-- BonusRoll Frame
	self:removeRegions(_G.BonusRollFrame, {1, 2, 3, 5})
	self:skinStatusBar{obj=_G.BonusRollFrame.PromptFrame.Timer, fi=0}
	self:addSkinFrame{obj=_G.BonusRollFrame, ft=ftype, bg=true}
	self:addButtonBorder{obj=_G.BonusRollFrame.PromptFrame, relTo=_G.BonusRollFrame.PromptFrame.Icon, reParent={_G.BonusRollFrame.SpecIcon}}

	local function skinMWLWAlertFrame(frame, reqdOfs)

		frame:DisableDrawLayer("BACKGROUND")
		if frame.SpecRing then frame.SpecRing:SetTexture(nil) end -- Loot Won Alert Frame(s)
		aObj:addSkinFrame{obj=frame, ft=ftype, ofs=reqdOfs or -10, y2=8}

	end
	skinMWLWAlertFrame(_G.BonusRollLootWonFrame)
	skinMWLWAlertFrame(_G.BonusRollMoneyWonFrame, -8)

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

aObj.blizzFrames[ftype].LootHistory = function(self)
	if not self.db.profile.LootHistory or self.initialized.LootHistory then return end
	self.initialized.LootHistory = true

	local function skinItemFrames(obj)

		local frame
		for i = 1, #obj.itemFrames do
			frame = obj.itemFrames[i]
			frame.Divider:SetTexture(nil)
			frame.NameBorderLeft:SetTexture(nil)
			frame.NameBorderRight:SetTexture(nil)
			frame.NameBorderMid:SetTexture(nil)
			frame.ActiveHighlight:SetTexture(nil)
			if aObj.modBtns then
				if not frame.ToggleButton.sb then
					aObj:skinButton{obj=frame.ToggleButton, ft=ftype, mp=true, plus=true}
					aObj:SecureHook(frame.ToggleButton, "SetNormalTexture", function(this, nTex)
						aObj.modUIBtns:checkTex{obj=this, nTex=nTex}
					end)
				end
			end
		end
		frame = nil

	end
	self:skinSlider{obj=_G.LootHistoryFrame.ScrollFrame.ScrollBar, size=3}
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

aObj.blizzFrames[ftype].MirrorTimers = function(self)
	if not self.db.profile.MirrorTimers.skin or self.initialized.MirrorTimers then return end
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
		if self.db.profile.MirrorTimers.glaze then
			self:skinStatusBar{obj=objSB, fi=0, bgTex=objBG}
		end
	end
	objName, obj, objBG, objSB = nil, nil, nil, nil

	-- Battleground/Arena Start Timer (4.1)
	local function skinTT(tT)

		local timer, bg
		for i = 1, #tT.timerList do
			timer = tT.timerList[i]
			if not aObj.sbGlazed[timer.bar] then
				bg = aObj:getRegion(timer.bar, 1)
				_G[timer.bar:GetName() .. "Border"]:SetTexture(nil) -- animations
				aObj:skinStatusBar{obj=timer.bar, fi=0, bgTex=bg}
				aObj:moveObject{obj=bg, y=2} -- align bars
			end
		end
		timer, bg = nil, nil

	end
	self:SecureHookScript(_G.TimerTracker, "OnEvent", function(this, event, ...)
		if event == "START_TIMER" then
			skinTT(this)
		end
	end)
	-- skin existing timers
	skinTT(_G.TimerTracker)

end

aObj.blizzFrames[ftype].ModelFrames = function(self)
	if IsAddOnLoaded("CloseUp") then
		aObj.blizzFrames[ftype].ModelFrames = nil
		return
	end

	if not self.db.profile.CharacterFrames then return end

	-- these are hooked to suppress the sound the normal functions use
	self:SecureHook("Model_RotateLeft", function(model, rotationIncrement)
		if not rotationIncrement then
			rotationIncrement = 0.03
		end
		model.rotation = model.rotation - rotationIncrement
		model:SetRotation(model.rotation)
	end)
	self:SecureHook("Model_RotateRight", function(model, rotationIncrement)
		if not rotationIncrement then
			rotationIncrement = 0.03
		end
		model.rotation = model.rotation + rotationIncrement
		model:SetRotation(model.rotation)
	end)

end

aObj.blizzFrames[ftype].ObjectiveTracker = function(self)
	if not self.db.profile.ObjectiveTracker.skin and not self.db.profile.ObjectiveTracker.popups then return end
	self.initialized.ObjectiveTracker = true

	-- ObjectiveTrackerFrame BlocksFrame
	if self.db.profile.ObjectiveTracker.skin then
		self:addSkinFrame{obj=_G.ObjectiveTrackerFrame.BlocksFrame, ft=ftype, kfs=true, nb=true, x1=-30, x2=4}
		-- hook this to handle displaying of the ObjectiveTrackerFrame BlocksFrame skin frame
		self:SecureHook("ObjectiveTracker_Update", function(reason)
			_G.ObjectiveTrackerFrame.BlocksFrame.sf:SetShown(_G.ObjectiveTrackerFrame.HeaderMenu:IsShown())
		end)
	end

	self:addButtonBorder{obj=_G.ObjectiveTrackerFrame.HeaderMenu.MinimizeButton, es=12, ofs=0}
	-- remove child backgrounds
	local kids, child = {_G.ObjectiveTrackerFrame.BlocksFrame:GetChildren()}
	for i = 1, #kids do
		child = kids[i]
		if child:IsObjectType("Frame")
		and child.Background
		then
			child.Background:SetTexture(nil)
		end
	end
	kids, child = nil, nil
	-- hook this to skin QuestObjective Block Button(s)
	self:SecureHook("QuestObjectiveSetupBlockButton_AddRightButton", function(block, button, iAO)
		self:addButtonBorder{obj=button, ofs=button.Icon and -2 or nil, x1=button.Icon and 0 or nil, reParent=button.Count and {button.Count} or nil} -- adjust x offset for FindGroup button(s), reparent Item Count if required
	end)
	-- skin timerBar(s) & progressBar(s)
	local function skinBar(bar)

		if not aObj.sbGlazed[bar.Bar] then
			if bar.Bar.BorderLeft then
				bar.Bar.BorderLeft:SetTexture(nil)
				bar.Bar.BorderRight:SetTexture(nil)
				bar.Bar.BorderMid:SetTexture(nil)
				aObj:skinStatusBar{obj=bar.Bar, fi=0, bgTex=self:getRegion(bar.Bar, 5)}
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
		skinBar(this.usedTimerBars[block] and this.usedTimerBars[block][line])
	end)
	self:SecureHook(_G.ACHIEVEMENT_TRACKER_MODULE, "AddTimerBar", function(this, block, line, ...)
		skinBar(this.usedTimerBars[block] and this.usedTimerBars[block][line])
	end)
	self:SecureHook(_G.QUEST_TRACKER_MODULE, "AddTimerBar", function(this, block, line, ...)
		skinBar(this.usedTimerBars[block] and this.usedTimerBars[block][line])
	end)
	self:SecureHook(_G.SCENARIO_TRACKER_MODULE, "AddTimerBar", function(this, block, line, ...)
		skinBar(this.usedTimerBars[block] and this.usedTimerBars[block][line])
	end)
	-- ProgressBars
	self:SecureHook(_G.DEFAULT_OBJECTIVE_TRACKER_MODULE, "AddProgressBar", function(this, block, line, ...)
		skinBar(this.usedProgressBars[block] and this.usedProgressBars[block][line])
	end)
	self:SecureHook(_G.BONUS_OBJECTIVE_TRACKER_MODULE, "AddProgressBar", function(this, block, line, ...)
		skinBar(this.usedProgressBars[block] and this.usedProgressBars[block][line])
	end)
	self:SecureHook(_G.QUEST_TRACKER_MODULE, "AddProgressBar", function(this, block, line, ...)
		skinBar(this.usedProgressBars[block] and this.usedProgressBars[block][line])
	end)
	self:SecureHook(_G.SCENARIO_TRACKER_MODULE, "AddProgressBar", function(this, block, line, ...)
		skinBar(this.usedProgressBars[block] and this.usedProgressBars[block][line])
	end)
	self:SecureHook(_G.WORLD_QUEST_TRACKER_MODULE, "AddProgressBar", function(this, block, line, ...)
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
	skinBars(_G.BONUS_OBJECTIVE_TRACKER_MODULE.usedProgressBars)
	skinBars(_G.QUEST_TRACKER_MODULE.usedTimerBars)
	skinBars(_G.QUEST_TRACKER_MODULE.usedProgressBars)
	skinBars(_G.SCENARIO_TRACKER_MODULE.usedTimerBars)
	skinBars(_G.SCENARIO_TRACKER_MODULE.usedProgressBars)
	skinBars(_G.ACHIEVEMENT_TRACKER_MODULE.usedTimerBars)
	skinBars(_G.WORLD_QUEST_TRACKER_MODULE.usedProgressBars)

	-- BonusRewardsFrame Rewards
	_G.ObjectiveTrackerBonusRewardsFrame:DisableDrawLayer("ARTWORK")
	_G.ObjectiveTrackerBonusRewardsFrame.RewardsShadow:SetTexture(nil)
	self:SecureHook("BonusObjectiveTracker_AnimateReward", function(block)
		local btn
		for i = 1, #block.module.rewardsFrame.Rewards do
			btn = block.module.rewardsFrame.Rewards[i]
			self:addButtonBorder{obj=btn, relTo=btn.ItemIcon, reParent={btn.Count}}
			btn.ItemBorder:SetTexture(nil)
		end
		btn = nil
	end)

	-- ObjectiveTrackerBonusBanner Frame
	_G.ObjectiveTrackerBonusBannerFrame.BG1:SetTexture(nil)
	_G.ObjectiveTrackerBonusBannerFrame.BG2:SetTexture(nil)

	-- AutoPopup frames
	if self.db.profile.ObjectiveTracker.popups then
		local function skinAutoPopUps()

			local questID, questTitle, sChild
			for i = 1, _G.GetNumAutoQuestPopUps() do
				questID = _G.GetAutoQuestPopUp(i)
				questTitle = _G.GetQuestLogTitle(_G.GetQuestLogIndexByID(questID))
				if questTitle and questTitle ~= "" then
					sChild = _G.AUTO_QUEST_POPUP_TRACKER_MODULE:GetBlock(questID).ScrollChild
					if sChild
					and not sChild.sf
					then
						local regs, reg = {sChild:GetRegions()}
						for i = 1, #regs do
							reg = regs[i]
							if i < 11 or i > 17 then reg:SetTexture(nil) end -- Animated textures
							if i == 13 then reg:SetTexture(nil) end -- IconBadgeBorder

						end
						regs, reg = nil, nil
						aObj:addSkinFrame{obj=sChild, ft=ftype, x1=32}
						sChild.FlashFrame:DisableDrawLayer("OVERLAY") -- hide IconBg flash texture
                        -- TODO prevent Background being changed, causes border art to appear broken ?
					end
				end
			end
			questID, questTitle, sChild = nil, nil, nil
		end

		-- hook this to skin the AutoPopUps
		self:SecureHook(_G.AUTO_QUEST_POPUP_TRACKER_MODULE, "Update", function(this)
			skinAutoPopUps()
		end)
		skinAutoPopUps()
	end

	-- ScenarioObjectiveBlock

	-- ScenarioStageBlock
	_G.ScenarioStageBlock.NormalBG:SetAlpha(0) -- N.B. Texture is changed
	_G.ScenarioStageBlock.FinalBG:SetAlpha(0) -- N.B. Texture is changed
	self:addSkinFrame{obj=_G.ScenarioStageBlock, ft=ftype, y1=-1, x2=41, y2=7}

	-- ScenarioChallengeModeBlock
	_G.ScenarioChallengeModeBlock:DisableDrawLayer("BACKGROUND")
	self:removeRegions(_G.ScenarioChallengeModeBlock, {3}) -- "challengemode-timer" texture
	self:skinStatusBar{obj=_G.ScenarioChallengeModeBlock.StatusBar, fi=0}
	self:removeRegions(_G.ScenarioChallengeModeBlock.StatusBar, {1}) -- border
	self:addSkinFrame{obj=_G.ScenarioChallengeModeBlock, ft=ftype, y2=7}
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
	self:addSkinFrame{obj=_G.ScenarioProvingGroundsBlock, ft=ftype, x2=41}
	_G.ScenarioProvingGroundsBlockAnim.BorderAnim:SetTexture(nil)

	self:SecureHook("ScenarioObjectiveTracker_AnimateReward", function(xp, money)
		local rewardsFrame = _G.ObjectiveTrackerScenarioRewardsFrame
		rewardsFrame:DisableDrawLayer("ARTWORK")
		rewardsFrame:DisableDrawLayer("BORDER")
		local btn
		for i = 1, #rewardsFrame.Rewards do
			btn = rewardsFrame.Rewards[i]
			self:addButtonBorder{obj=btn, relTo=btn.ItemIcon, reParent={btn.Count}}
			btn.ItemBorder:SetTexture(nil)
		end
		btn = nil
		rewardsFrame = nil
	end)

end

aObj.blizzFrames[ftype].OverrideActionBar = function(self)
	if not self.db.profile.OverrideActionBar  or self.initialized.OverrideActionBar then return end
	self.initialized.OverrideActionBar = true

	local function skinOverrideActionBar(oab)

		local oabW = oab:GetWidth()

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
		oab:DisableDrawLayer("OVERLAY")
		oab:DisableDrawLayer("BACKGROUND")
		oab:DisableDrawLayer("BORDER")

		-- PitchFrame
		oab.pitchFrame.Divider1:SetTexture(nil)
		oab.pitchFrame.PitchOverlay:SetTexture(nil)
		oab.pitchFrame.PitchButtonBG:SetTexture(nil)

		-- LeaveFrame
		oab.leaveFrame.Divider3:SetTexture(nil)
		oab.leaveFrame.ExitBG:SetTexture(nil)

		-- ExpBar
		oab.xpBar.XpMid:SetTexture(nil)
		oab.xpBar.XpL:SetTexture(nil)
		oab.xpBar.XpR:SetTexture(nil)
		for i = 1, 19 do
			oab.xpBar["XpDiv" .. i]:SetTexture(nil)
		end
		aObj:skinStatusBar{obj=oab.xpBar, fi=0, bgTex=aObj:getRegion(oab.xpBar, 1)}

		aObj:addSkinFrame{obj=oab, ft=ftype, x1=xOfs1, y1=yOfs1, x2=xOfs2, y2=yOfs2}

		oabW, xOfs1, yOfs1, xOfs2, yOfs2 = nil, nil, nil, nil, nil

	end

	self:SecureHook(_G.OverrideActionBar, "Show", function(this, ...)
		skinOverrideActionBar(this)
	end)
	self:SecureHook("OverrideActionBar_SetSkin", function(skin)
		skinOverrideActionBar(_G.OverrideActionBar)
	end)

	if _G.OverrideActionBar:IsShown() then skinOverrideActionBar(_G.OverrideActionBar) end

	self:addButtonBorder{obj=_G.OverrideActionBar.leaveFrame.LeaveButton}
	for i = 1, 6 do
		self:addButtonBorder{obj=_G.OverrideActionBar["SpellButton" .. i], abt=true, sec=true, es=20}
	end

end

aObj.blizzLoDFrames[ftype].PVPUI = function(self)
	if not self.db.profile.PVPFrame or self.initialized.PVPFrame then return end
	self.initialized.PVPFrame = true

	local rTab = {"Tank", "Healer", "DPS"}
	local function skinCheckBtns(frame)
		for i = 1, #rTab do
			aObj:skinCheckButton{obj=frame[rTab[i] .. "Icon"].checkButton}
		end
	end

	-- N.B. Frame already skinned as it is now part of GroupFinder/PVE
	local btn
	for i = 1, 4 do
		btn = _G.PVPQueueFrame["CategoryButton" .. i]
		btn.Background:SetTexture(nil)
		btn.Ring:SetTexture(nil)
		self:changeRecTex(btn:GetHighlightTexture())
	end
	btn = nil
	self:skinButton{obj=_G.PremadeGroupsPvPTutorialAlert.CloseButton, cb=true}

	-- hook this to change selected texture
	self:SecureHook("PVPQueueFrame_SelectButton", function(index)
		local btn
		for i = 1, 4 do
			btn = _G.PVPQueueFrame["CategoryButton" .. i]
			if i == index then
				self:changeRecTex(btn.Background, true)
			else
				btn.Background:SetTexture(nil)
			end
		end
		btn = nil
	end)
	_G.PVPQueueFrame_SelectButton(1) -- select Honor button

	-- skin common elements (Honor & Conquest frames)
	local function skinCommon(frame)
		frame.XPBar.Frame:SetTexture(nil)
		aObj:skinStatusBar{obj=frame.XPBar.Bar, fi=0, bgTex=frame.XPBar.Bar.Background, hookFunc=true}
		frame.XPBar.Bar.OverlayFrame.Text:SetPoint("CENTER", 0, 0)
		frame.XPBar.NextAvailable.Frame:SetTexture(nil)
		aObj:addButtonBorder{obj=frame.XPBar.NextAvailable, relTo=frame.XPBar.NextAvailable.Icon}
		aObj:removeInset(frame.RoleInset)
		skinCheckBtns(frame.RoleInset)
		aObj:removeInset(frame.Inset)
	end

	-- Honor Frame a.k.a Casual
	skinCommon(_G.HonorFrame)
	self:skinDropDown{obj=_G.HonorFrameTypeDropDown}
	self:skinSlider{obj=_G.HonorFrame.SpecificFrame.scrollBar, wdth=-4}
	local btn
	for i = 1, #_G.HonorFrame.SpecificFrame.buttons do
		btn = _G.HonorFrame.SpecificFrame.buttons[i]
		btn.Bg:SetTexture(nil)
		btn.Border:SetTexture(nil)
	end
	btn = nil
	local hfbf =_G.HonorFrame.BonusFrame
	local nTab = {"RandomBG", "Arena1", "Ashran", "Brawl"}
	for i = 1, #nTab do
		hfbf[nTab[i] .. "Button"].NormalTexture:SetTexture(nil)
		hfbf[nTab[i] .. "Button"].Reward.Border:SetTexture(nil)
	end
	nTab = nil
	self:addButtonBorder{obj=hfbf.DiceButton, ofs=2, x1=-3}
	self:skinButton{obj=hfbf.BrawlHelpBox.CloseButton, cb=true}
	hfbf:DisableDrawLayer("BACKGROUND")
	hfbf:DisableDrawLayer("BORDER")
	hfbf.ShadowOverlay:DisableDrawLayer("OVERLAY")
	hfbf = nil
	self:removeMagicBtnTex(_G.HonorFrame.QueueButton)
	self:skinButton{obj=_G.HonorFrame.QueueButton}

	-- Conquest Frame a.k.a. Rated
	skinCommon(_G.ConquestFrame)
	_G.ConquestFrame:DisableDrawLayer("BACKGROUND")
	_G.ConquestFrame:DisableDrawLayer("BORDER")
	_G.ConquestFrame.ShadowOverlay:DisableDrawLayer("OVERLAY")
	_G.ConquestFrame.Arena2v2.Reward.Border:SetTexture(nil)
	_G.ConquestFrame.Arena2v2.NormalTexture:SetTexture(nil)
	_G.ConquestFrame.Arena3v3.Reward.Border:SetTexture(nil)
	_G.ConquestFrame.Arena3v3.NormalTexture:SetTexture(nil)
	_G.ConquestFrame.RatedBG.Reward.Border:SetTexture(nil)
	_G.ConquestFrame.RatedBG.NormalTexture:SetTexture(nil)
	self:removeMagicBtnTex(_G.ConquestFrame.JoinButton)
	self:skinButton{obj=_G.ConquestFrame.JoinButton}
	self:skinDropDown{obj=_G.ConquestFrame.ArenaInviteMenu}

	-- War Games Frame
	_G.WarGamesFrame.InfoBG:SetTexture(nil)
	self:removeInset(_G.WarGamesFrame.RightInset)
	self:moveObject{obj=_G.WarGamesFrame.scrollFrame, x=3}
	self:skinSlider{obj=_G.WarGamesFrame.scrollFrame.scrollBar, wdth=-4}
	local btn
	for i = 1, #_G.WarGamesFrame.scrollFrame.buttons do
		btn = _G.WarGamesFrame.scrollFrame.buttons[i]
		self:skinButton{obj=btn.Header, mp=true}
		btn.Entry.Bg:SetTexture(nil)
		btn.Entry.Border:SetTexture(nil)
	end
	btn = nil
	self:skinSlider{obj=_G.WarGamesFrameInfoScrollFrame.ScrollBar}
	_G.WarGamesFrame.HorizontalBar:DisableDrawLayer("ARTWORK")
	self:removeMagicBtnTex(_G.WarGameStartButton)
	self:skinButton{obj=_G.WarGameStartButton}
	self:skinCheckButton{obj=_G.WarGameTournamentModeCheckButton}

	-- Tooltips
	if self.db.profile.Tooltips.skin then
		self:add2Table(self.ttList, "PVPRewardTooltip")
		self:add2Table(self.ttList, "ConquestTooltip")
	end

end

aObj.blizzFrames[ftype].PVPHonorSystem = function(self)

	_G.HonorLevelUpBanner:DisableDrawLayer("BORDER")
	_G.PrestigeLevelUpBanner.BG1:SetTexture(nil)
	_G.PrestigeLevelUpBanner.BG2:SetTexture(nil)

end

aObj.blizzLoDFrames[ftype].RaidUI = function(self)
	if not self.db.profile.RaidUI or self.initialized.RaidUI then return end
	self.initialized.RaidUI = true

	local function skinPulloutFrames()

		local objName
		for i = 1, _G.NUM_RAID_PULLOUT_FRAMES do
			objName = "RaidPullout" .. i
			if not _G[objName].sf then
				aObj:skinDropDown{obj=_G[objName .. "DropDown"]}
				_G[objName .. "MenuBackdrop"]:SetBackdrop(nil)
				aObj:addSkinFrame{obj=_G[objName], ft=ftype, kfs=true, x1=3, y1=-1, x2=-1, y2=1}
			end
		end
		objName = nil

	end
	-- hook this to skin the pullout group frames
	self:SecureHook("RaidPullout_GetFrame", function(...)
		skinPulloutFrames()
	end)
	-- hook this to skin the pullout character frames
	self:SecureHook("RaidPullout_Update", function(pullOutFrame)
		local nTab, pfName = {"HealthBar", "ManaBar", "Target", "TargetTarget"}, pullOutFrame:GetName()
		local barName, objName
		for i = 1, pullOutFrame.numPulloutButtons do
			objName = pfName .. "Button" .. i
			if not _G[objName].sf then
				for i = 1, #nTab do
					barName = objName .. nTab[1]
					self:removeRegions(_G[barName], {2})
					self:skinStatusBar{obj=_G[barName], fi=0, bgTex=_G[barName .. "Background"]}
				end
				self:addSkinFrame{obj=_G[objName .. "TargetTargetFrame"], ft=ftype, x1=4, x2=-4, y2=2}
				self:addSkinFrame{obj=_G[objName], ft=ftype, kfs=true, x1=-4, y1=-6, x2=4, y2=-6}
			end
		end
		nTab, pfName, barName, objName = nil, nil, nil
	end)

	self:moveObject{obj=_G.RaidGroup1, x=2}

	-- Raid Groups
	for i = 1, _G.MAX_RAID_GROUPS do
		_G["RaidGroup" .. i]:DisableDrawLayer("BACKGROUND")
		self:addSkinFrame{obj=_G["RaidGroup" .. i], ft=ftype, x1=-2, y1=2, x2=1, y2=-1}
	end
	-- Raid Group Buttons
	for i = 1, _G.MAX_RAID_GROUPS * 5 do
		_G["RaidGroupButton" .. i]:SetNormalTexture(nil)
		self:addSkinFrame{obj=_G["RaidGroupButton" .. i], ft=ftype, aso={bd=5}, x1=-2, y1=2, x2=1, y2=-1}
	end
	-- Raid Class Tabs (side)
	for i = 1, _G.MAX_RAID_CLASS_BUTTONS do
		self:removeRegions(_G["RaidClassButton" .. i], {1}) -- 2 is icon, 3 is text
	end

	-- skin existing frames
	skinPulloutFrames()

end

aObj.blizzFrames[ftype].ReadyCheck = function(self)
	if not self.db.profile.ReadyCheck or self.initialized.ReadyCheck then return end
	self.initialized.ReadyCheck = true

	self:addSkinFrame{obj=_G.ReadyCheckListenerFrame, ft=ftype, kfs=true}

end

aObj.blizzFrames[ftype].RolePollPopup = function(self)
	if not self.db.profile.RolePollPopup or self.initialized.RolePollPopup then return end
	self.initialized.RolePollPopup = true

	self:addSkinFrame{obj=_G.RolePollPopup, ft=ftype, x1=5, y1=-5, x2=-5, y2=5}

end

aObj.blizzFrames[ftype].ScrollOfResurrection = function(self)
	if not self.db.profile.ScrollOfResurrection or self.initialized.ScrollOfResurrection then return end
	self.initialized.ScrollOfResurrection = true

	self:skinEditBox{obj=_G.ScrollOfResurrectionFrame.targetEditBox, regs={6}} -- 6 is text
	_G.ScrollOfResurrectionFrame.targetEditBox.fill:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:addSkinFrame{obj=_G.ScrollOfResurrectionFrame.noteFrame, ft=ftype, kfs=true}
	self:skinSlider{obj=_G.ScrollOfResurrectionFrame.noteFrame.scrollFrame.ScrollBar, wdth=-4, size=3}
	_G.ScrollOfResurrectionFrame.noteFrame.scrollFrame.editBox.fill:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:addSkinFrame{obj=_G.ScrollOfResurrectionFrame, ft=ftype, kfs=true}
	-- Selection frame
	self:skinEditBox{obj=_G.ScrollOfResurrectionSelectionFrame.targetEditBox, regs={6}} -- 6 is text
	self:skinSlider{obj=_G.ScrollOfResurrectionSelectionFrame.list.scrollFrame.scrollBar, size=4}
	self:addSkinFrame{obj=_G.ScrollOfResurrectionSelectionFrame.list, ft=ftype, kfs=true}
	self:addSkinFrame{obj=_G.ScrollOfResurrectionSelectionFrame, ft=ftype, kfs=true}

end

aObj.blizzFrames[ftype].SpellBookFrame = function(self)
	if not self.db.profile.SpellBookFrame or self.initialized.SpellBookFrame then return end
	self.initialized.SpellBookFrame = true

	_G.SpellBookFrame.numTabs = 5
	if self.isTT then
		-- hook to handle tabs
		self:SecureHook("ToggleSpellBook", function(bookType)
			local tab
			for i = 1, _G.SpellBookFrame.numTabs do
				tab = _G["SpellBookFrameTabButton" .. i]
				if tab.bookType == bookType then
					self:setActiveTab(tab.sf)
				else
					self:setInactiveTab(tab.sf)
				end
			end
			tab = nil
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

		local objName, obj
		for i = 1, times do
			objName = type .. "Profession" .. i
			obj =_G[objName]
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
		objName, obj = nil, nil

	end
	-- Primary professions
	skinProf("Primary", 2)
	-- Secondary professions
	skinProf("Secondary", 4)

	-- colour the spell name text
	local btnName, btn
	for i = 1, _G.SPELLS_PER_PAGE do
		btnName = "SpellButton" .. i
		btn = _G[btnName]
		btn:DisableDrawLayer("BACKGROUND")
		btn:DisableDrawLayer("BORDER")
		_G[btnName .. "SlotFrame"]:SetAlpha(0)
		btn.UnlearnedFrame:SetAlpha(0)
		btn.TrainFrame:SetAlpha(0)
		self:addButtonBorder{obj=_G[btnName], sec=true, reParent={btn.FlyoutArrow, _G[btnName .. "AutoCastable"]}}
	end
	btnName, btn = nil, nil
-->>-- Tabs (side)
	local tab
	for i = 1, _G.MAX_SKILLLINE_TABS do
		tab = _G["SpellBookSkillLineTab" .. i]
		self:removeRegions(tab, {1}) -- N.B. other regions are icon and highlight
		self:addButtonBorder{obj=tab}
	end
	tab = nil

end

aObj.blizzFrames[ftype].StackSplit = function(self)
	if not self.db.profile.StackSplit or self.initialized.StackSplit then return end
	self.initialized.StackSplit = true

	-- handle different addons being loaded
	if IsAddOnLoaded("EnhancedStackSplit") then
		self:addSkinFrame{obj=_G.StackSplitFrame, ft=ftype, kfs=true, y2=-24}
	else
		self:addSkinFrame{obj=_G.StackSplitFrame, ft=ftype, kfs=true, x1=9, y1=-12, x2=-6, y2=12}
	end

end

aObj.blizzLoDFrames[ftype].TalentUI = function(self)
	if not self.db.profile.TalentUI or self.initialized.TalentUI then return end
	self.initialized.TalentUI = true

	self:skinTabs{obj=_G.PlayerTalentFrame, lod=true}
	self:addSkinFrame{obj=_G.PlayerTalentFrame, ft=ftype, kfs=true, ri=true, nb=true, x1=-3, y1=2, x2=1, y2=-5}
	self:skinButton{obj=_G.PlayerTalentFrameCloseButton, cb=true}
	self:skinButton{obj=_G.PlayerTalentFrameActivateButton}
	self:removeMagicBtnTex(_G.PlayerTalentFrameSpecialization.learnButton)
	self:skinButton{obj=_G.PlayerTalentFrameSpecialization.learnButton, anim=true, parent=_G.PlayerTalentFrameSpecialization}
	self:removeMagicBtnTex(_G.PlayerTalentFramePetSpecialization.learnButton)
	self:skinButton{obj=_G.PlayerTalentFramePetSpecialization.learnButton, anim=true, parent=_G.PlayerTalentFramePetSpecialization}

	local function skinAbilities(obj)
		local btn
		for i = 1, obj:GetNumChildren() do
			btn = obj["abilityButton" .. i]
			btn.ring:SetTexture(nil)
			btn.subText:SetTextColor(aObj.BTr, aObj.BTg, aObj.BTb)
		end
		btn = nil
	end
	local function skinSpec(frame)
		aObj:removeRegions(frame, {1, 2, 3, 4, 5, 6})
		frame.MainHelpButton.Ring:SetTexture(nil)
		aObj:moveObject{obj=frame.MainHelpButton, y=-4}
        aObj:removeMagicBtnTex(frame.learnButton)
		local btn
		for i = 1, _G.MAX_TALENT_TABS do
			btn = frame["specButton" .. i]
			btn.bg:SetTexture(nil)
			btn.ring:SetTexture(nil)
			aObj:changeRecTex(btn.selectedTex, true)
			btn.learnedTex:SetTexture(nil)
			aObj:changeRecTex(btn:GetHighlightTexture())
		end
		btn = nil
		-- shadow frame (LHS)
		aObj:keepFontStrings(aObj:getChild(frame, 7))
		-- spellsScroll (RHS)
		aObj:skinSlider{obj=frame.spellsScroll.ScrollBar}
		local scrollChild = frame.spellsScroll.child
		scrollChild.gradient:SetTexture(nil)
		aObj:removeRegions(scrollChild, {2, 3, 4, 5, 6, 13})
		-- abilities
		skinAbilities(scrollChild)
		scrollChild = nil
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
	-- Talent rows
	local obj, btn
	for i = 1, _G.MAX_TALENT_TIERS do
		obj = _G.PlayerTalentFrameTalents["tier" .. i]
		self:removeRegions(obj, {1, 2 ,3, 4, 5, 6})
		for j = 1, _G.NUM_TALENT_COLUMNS do
			btn = obj["talent" .. j]
			btn.Slot:SetTexture(nil)
			if self.modBtnBs then
				btn.knownSelection:SetAlpha(0)
				self:addButtonBorder{obj=btn, relTo=btn.icon}
			else
				btn.knownSelection:SetTexCoord(0.00390625, 0.78515625, 0.25000000, 0.36914063)
				btn.knownSelection:SetVertexColor(0, 1, 0, 1)
			end
		end
	end
	obj, btn = nil, nil

	-- Tab3 (Honor Talents)
	local pvpt = _G.PlayerTalentFramePVPTalents
	pvpt.XPBar.Frame:SetTexture(nil)
	self:skinStatusBar{obj=pvpt.XPBar.Bar, fi=0, bgTex=pvpt.XPBar.Bar.Background, hookFunc=true}
	pvpt.XPBar.NextAvailable.Frame:SetTexture(nil)
	self:addButtonBorder{obj=pvpt.XPBar.NextAvailable, relTo=pvpt.XPBar.NextAvailable.Icon}
	self:skinDropDown{obj=pvpt.XPBar.DropDown}
	pvpt.Talents:DisableDrawLayer("BACKGROUND")
	pvpt.Talents:DisableDrawLayer("BORDER")
	local obj
	for i = 1, _G.MAX_PVP_TALENT_TIERS do
		obj = pvpt.Talents["Tier" .. i]
		self:removeRegions(obj, {1, 2 ,3})
		local btn
		for j = 1, _G.MAX_PVP_TALENT_COLUMNS do
			btn = obj["Talent" .. j]
			btn.LeftCap:SetTexture(nil)
			btn.RightCap:SetTexture(nil)
			btn.Slot:SetTexture(nil)
			btn.Cover:SetTexture(nil)
			if self.modBtnBs then
				btn.knownSelection:SetAtlas(nil)
				self:addButtonBorder{obj=btn, relTo=btn.Icon}
			else
				btn.knownSelection:SetTexCoord(0.00390625, 0.78515625, 0.25000000, 0.36914063)
				btn.knownSelection:SetVertexColor(0, 1, 0, 1)
			end
		end
		btn = nil
	end
	obj = nil
	-- TutorialBox
	self:skinButton{obj=pvpt.TutorialBox.CloseButton, cb=true}
	-- PrestigeLevelDialog
	self:addSkinFrame{obj=pvpt.PrestigeLevelDialog, ft=ftype}
	-- PortraitMouseOverFrame
	self:moveObject{obj=pvpt.PortraitBackground, x=8, y=-10}
	self:moveObject{obj=pvpt.SmallWreath, x=8, y=-10}
	self:SecureHook(pvpt, "Show", function(this)
		-- Show Portrait if prestige level is greater than 0
		if _G.UnitPrestige("player") > 0 then
			_G.PlayerTalentFrame.portrait:SetAlpha(1)
		end
	end)
	self:SecureHook(pvpt, "Hide", function(this)
		_G.PlayerTalentFrame.portrait:SetAlpha(0)
	end)
	pvpt = nil

	-- Tab4 (Pet Specialization)
	skinSpec(_G.PlayerTalentFramePetSpecialization)

	-- Dual Spec Tabs
	local tab
	for i = 1, _G.MAX_TALENT_GROUPS do
		tab = _G["PlayerSpecTab" .. i]
		self:removeRegions(tab, {1}) -- N.B. other regions are icon and highlight
		self:addButtonBorder{obj=tab}
	end
	tab = nil

end

aObj.blizzFrames[ftype].TradeFrame = function(self)
	if not self.db.profile.TradeFrame or self.initialized.TradeFrame then return end
	self.initialized.TradeFrame = true

	local nTab, btnName = {"Player", "Recipient"}
	for i = 1, _G.MAX_TRADE_ITEMS do
		for j = 1, #nTab do
			btnName = "Trade" .. nTab[j] .. "Item" .. i
			_G[btnName .. "SlotTexture"]:SetTexture(nil)
			_G[btnName .. "NameFrame"]:SetTexture(nil)
			self:addButtonBorder{obj=_G[btnName .. "ItemButton"], ibt=true}
		end
	end
	nTab, btnName = nil, nil
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

aObj.blizzLoDFrames[ftype].TradeSkillUI = function(self)
	if not self.db.profile.TradeSkillUI or self.initialized.TradeSkillUI then return end
	self.initialized.TradeSkillUI = true

	self:removeInset(_G.TradeSkillFrame.RecipeInset)
	self:removeInset(_G.TradeSkillFrame.DetailsInset)

	-- Recipe List
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
	if aObj.isTT then
		local function changeTabTex(frame)
			for i = 1, frame.numTabs do
				if i == frame.selectedTab then
					aObj:setActiveTab(frame.Tabs[i].sf)
				else
					aObj:setInactiveTab(frame.Tabs[i].sf)
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
	skinTabs(_G.TradeSkillFrame.RecipeList)
	self:skinSlider{obj=self:getChild(_G.TradeSkillFrame.RecipeList, 4), wdth=-4, size=3} -- unamed slider object

	local btn
	for i = 1, #_G.TradeSkillFrame.RecipeList.buttons do
		btn = _G.TradeSkillFrame.RecipeList.buttons[i]
		self:skinButton{obj=btn, mp=true}
		btn.SubSkillRankBar.BorderLeft:SetTexture(nil)
		btn.SubSkillRankBar.BorderRight:SetTexture(nil)
		btn.SubSkillRankBar.BorderMid:SetTexture(nil)
		self:skinStatusBar{obj=btn.SubSkillRankBar, fi=0}
	end
	btn = nil
	self:SecureHook(_G.TradeSkillFrame.RecipeList, "RefreshDisplay", function(this)
		for i = 1, #this.buttons do
			self:checkTex{obj=this.buttons[i]}
		end
	end)
	self:SecureHook(_G.TradeSkillFrame.RecipeList, "update", function(this)
		for i = 1, #this.buttons do
			self:checkTex{obj=this.buttons[i]}
		end
	end)

	-- Details frame
	_G.TradeSkillFrame.DetailsFrame.Background:SetAlpha(0)
	self:skinSlider{obj=_G.TradeSkillFrame.DetailsFrame.ScrollBar, wdth=-4, size=3}
	self:removeMagicBtnTex(_G.TradeSkillFrame.DetailsFrame.CreateAllButton)
	self:removeMagicBtnTex(_G.TradeSkillFrame.DetailsFrame.ViewGuildCraftersButton)
	self:removeMagicBtnTex(_G.TradeSkillFrame.DetailsFrame.ExitButton)
	self:removeMagicBtnTex(_G.TradeSkillFrame.DetailsFrame.CreateButton)
	self:skinEditBox{obj=_G.TradeSkillFrame.DetailsFrame.CreateMultipleInputBox, noHeight=true, nis=true}
	local btn = _G.TradeSkillFrame.DetailsFrame.Contents.ResultIcon
	btn.ResultBorder:SetTexture(nil)
	self:addButtonBorder{obj=btn, reParent={btn.Count}}
	for i = 1, #_G.TradeSkillFrame.DetailsFrame.Contents.Reagents do
		btn = _G.TradeSkillFrame.DetailsFrame.Contents.Reagents[i]
		btn.NameFrame:SetTexture(nil)
		self:addButtonBorder{obj=btn, relTo=btn.Icon, reParent={btn.Count}}
	end
	btn = nil

	-- _G.TradeSkillFrame.DetailsFrame.GuildFrame
	self:addSkinFrame{obj=_G.TradeSkillFrame.DetailsFrame.GuildFrame.Container, ft=ftype}
	self:addSkinFrame{obj=_G.TradeSkillFrame.DetailsFrame.GuildFrame, ft=ftype, kfs=true, ofs=-7}

	-- Rank frame
	self:skinStatusBar{obj=G.TradeSkillFrame.RankFrame, fi=0, bgTex=_G.TradeSkillFrame.RankFrameBackground}
	self:removeRegions(_G.TradeSkillFrame.RankFrame, {2, 3, 4})

	self:skinEditBox{obj=_G.TradeSkillFrame.SearchBox, regs={6, 7}, mi=true} -- 6 is text, 7 is icon
	self:addButtonBorder{obj=_G.TradeSkillFrame.LinkToButton, x1=1, y1=-5, x2=-3, y2=2}
	self:skinButton{obj=_G.TradeSkillFrame.FilterButton}
	self:addSkinFrame{obj=_G.TradeSkillFrame, ft=ftype, kfs=true, ofs=2, x2=1}

end

aObj.blizzFrames[ftype].WardrobeOutfits = function(self)

	self:addSkinFrame{obj=_G.WardrobeOutfitFrame, ft=ftype, nb=true}
	self:skinEditBox{obj=_G.WardrobeOutfitEditFrame.EditBox, regs={6}} -- 6 is text
	self:addSkinFrame{obj=_G.WardrobeOutfitEditFrame, ft=ftype, kfs=true}

end
