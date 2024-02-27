local _, aObj = ...

local _G = _G
-- luacheck: ignore 631 (line is too long)

aObj.SetupRetail_PlayerFrames = function()
	local ftype = "p"

	aObj.blizzLoDFrames[ftype].AchievementUI = function(self)
		if not self.prdb.AchievementUI.skin or self.initialized.AchievementUI then return end
		self.initialized.AchievementUI = true

		local afao = _G.AchievementFrameAchievementsObjectives
		local function skinAchievementsObjectives()
			for frame in afao.pools:EnumerateActiveByTemplate("AchievementCriteriaTemplate") do
				if frame.Check:IsShown() then
					frame.Name:SetTextColor(_G.HIGHLIGHT_FONT_COLOR:GetRGB())
				end
			end
			for bar in afao.pools:EnumerateActiveByTemplate("AchievementProgressBarTemplate") do
				aObj:skinObject("statusbar", {obj=bar, regions={1, 3, 4, 5}, fi=0})
			end
			for frame in afao.pools:EnumerateActiveByTemplate("MiniAchievementTemplate") do
				frame.Border:SetTexture(nil)
				if aObj.modBtnBs then
					aObj:addButtonBorder{obj=frame, fType=ftype, relTo=frame.Icon, reParent={frame.Shield, frame.Points}, clr=frame.saturatedStyle and "sepia" or "grey"}
				end
			end
			for btn in afao.pools:EnumerateActiveByTemplate("MetaCriteriaTemplate") do
				btn.Border:SetTexture(nil)
				if btn.Check:IsShown() then
					btn.Label:SetTextColor(_G.HIGHLIGHT_FONT_COLOR:GetRGBA())
				end
				if aObj.modBtnBs then
					aObj:addButtonBorder{obj=btn, fType=ftype, relTo=btn.Icon, clr=btn.Check:IsShown() and "sepia" or "grey"}
				end
			end
		end
		self:SecureHookScript(afao, "OnShow", function(_)
			skinAchievementsObjectives()
		end)

		self:SecureHookScript(_G.AchievementFrame, "OnShow", function(this)
			local function skinAchievement(btn)
				if not btn.sf then
					btn:DisableDrawLayer("BACKGROUND")
					btn:DisableDrawLayer("BORDER")
					btn:DisableDrawLayer("ARTWORK")
					if btn.HiddenDescription then
						btn.HiddenDescription:SetTextColor(_G.HIGHLIGHT_FONT_COLOR:GetRGB())
					end
					if btn.Description then
						if btn.saturatedStyle then
							btn.Description:SetTextColor(_G.HIGHLIGHT_FONT_COLOR:GetRGB())
						else
							btn.Description:SetTextColor(.6, .6, .6, 1)
						end
					end
					aObj:skinObject("frame", {obj=btn, fType=ftype, rns=true, fb=true, ofs=0})
					btn.sf:SetBackdropBorderColor(btn:GetBackdropBorderColor())
					aObj:nilTexture(btn.Icon.frame, true)
					if aObj.modBtnBs then
						aObj:addButtonBorder{obj=btn.Icon, fType=ftype, ofs=-3, y1=0, y2=6}
						btn.Icon.sbb:SetBackdropBorderColor(btn:GetBackdropBorderColor())
					end
					if aObj.modChkBtns
					and btn.Tracked
					then
						aObj:skinCheckButton{obj=btn.Tracked, fType=ftype}
						btn.Tracked:SetSize(20, 20)
					end
					aObj:SecureHook(btn, "Desaturate", function(bObj)
						if bObj.sf then
							bObj.sf:SetBackdropBorderColor(bObj:GetBackdropBorderColor())
						end
						if bObj.Icon.sbb then
							bObj.Icon.sbb:SetBackdropBorderColor(bObj:GetBackdropBorderColor())
						end
					end)
					aObj:SecureHook(btn, "Saturate", function(bObj)
						if bObj.sf then
							bObj.sf:SetBackdropBorderColor(bObj:GetBackdropBorderColor())
						end
						if bObj.Icon.sbb then
							bObj.Icon.sbb:SetBackdropBorderColor(bObj:GetBackdropBorderColor())
						end
						if bObj.Description then
							bObj.Description:SetTextColor(_G.HIGHLIGHT_FONT_COLOR:GetRGB())
						end
					end)
					if btn.Expand then
						aObj:SecureHook(btn, "Expand", function(bObj, height)
							if not bObj.collapsed
							and bObj:GetHeight() == height
							then
								return
							end
							skinAchievementsObjectives()
						end)
					end
				end
				skinAchievementsObjectives()
			end
			local function skinSB(statusBar, moveText)
				if moveText then
					aObj:moveObject{obj=_G[statusBar].Label, y=-3}
					aObj:moveObject{obj=_G[statusBar].Text, y=-3}
				end
				aObj:skinObject("statusbar", {obj=_G[statusBar], regions={3, 4, 5}, fi=0, bg=_G[statusBar .. "FillBar"]})
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=_G.AchievementFrameFilterDropDownButton, fType=ftype, es=12, ofs=-2, x1=1}
			end
			self:skinObject("editbox", {obj=this.SearchBox, fType=ftype, si=true, y1=-4, y2=4})
			self:moveObject{obj=this.SearchBox, y=-8}
			self:skinObject("statusbar", {obj=this.searchProgressBar, fi=0, bg=this.searchProgressBar.bg})
			self:moveObject{obj=_G.AchievementFrameCloseButton, x=1, y=8}
			self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true, ignoreHLTex=false, regions={7, 8, 9, 10}, offsets={x1=6, x2=-2, y2=-7}})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, y1=7, x2=0, y2=-1})

			self:SecureHookScript(this.Header, "OnShow", function(fObj)
				self:keepFontStrings(fObj)
				self:moveObject{obj=fObj.Title, x=-60, y=-25}
				self:moveObject{obj=fObj.Points, x=40, y=-5}
				fObj.Shield:SetAlpha(1)

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.Header)

			self:SecureHookScript(this.Categories, "OnShow", function(fObj)
				self:skinObject("scrollbar", {obj=fObj.ScrollBar, fType=ftype})
				self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, rns=true, fb=true, y1=0})
				local function skinElement(...)
					local _, element, new
					if _G.select("#", ...) == 2 then
						element, _ = ...
					elseif _G.select("#", ...) == 3 then
						element, _, new = ...
					else
						_, element, _, new = ...
					end
					if new ~= false then
						element.Button:DisableDrawLayer("BACKGROUND")
					end
				end
				_G.ScrollUtil.AddAcquiredFrameCallback(fObj.ScrollBox, skinElement, aObj, true)

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.Categories)

			self:SecureHookScript(_G.AchievementFrameAchievements, "OnShow", function(fObj)
				fObj.Background:SetTexture(nil)
				self:skinObject("scrollbar", {obj=fObj.ScrollBar, fType=ftype})
				self:removeNineSlice(self:getChild(fObj, 3).NineSlice)
				self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, rns=true, fb=true, ofs=0, y2=-2})
				local function skinElement(...)
					local _, element, new
					if _G.select("#", ...) == 2 then
						element, _ = ...
					elseif _G.select("#", ...) == 3 then
						element, _, new = ...
					else
						_, element, _, new = ...
					end
					if new ~= false then
						skinAchievement(element)
					end
				end
				_G.ScrollUtil.AddAcquiredFrameCallback(fObj.ScrollBox, skinElement, aObj, true)

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(_G.AchievementFrameAchievements)

			self:SecureHookScript(_G.AchievementFrameStats, "OnShow", function(fObj)
				self:getChild(fObj, 1):DisableDrawLayer("BACKGROUND")
				self:skinObject("scrollbar", {obj=fObj.ScrollBar, fType=ftype})
				self:removeNineSlice(self:getChild(fObj, 4).NineSlice)
				self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, fb=true, ofs=0, x1=2, y2=-2})
				local function skinElement(...)
					local _, element, new
					if _G.select("#", ...) == 2 then
						element, _ = ...
					elseif _G.select("#", ...) == 3 then
						element, _, new = ...
					else
						_, element, _, new = ...
					end
					if new ~= false then
						element.Background:SetTexture(nil)
						aObj:removeRegions(element, {2, 3, 4})
					end
				end
				_G.ScrollUtil.AddAcquiredFrameCallback(fObj.ScrollBox, skinElement, aObj, true)

				self:Unhook(fObj, "OnShow")
			end)

			local function skinSummaryAchievements()
				for i = 1, _G.ACHIEVEMENTUI_MAX_SUMMARY_ACHIEVEMENTS do
					skinAchievement(_G.AchievementFrameSummaryAchievements.buttons[i])
				end
			end
			self:SecureHookScript(_G.AchievementFrameSummary, "OnShow", function(fObj)
				fObj:DisableDrawLayer("BACKGROUND")
				self:skinObject("frame", {obj=self:getChild(fObj, 1), fType=ftype, kfs=true, fb=true, ofs=0, x1=2, y2=-2})
				_G.AchievementFrameSummaryAchievementsHeaderHeader:SetTexture(nil)
				self:SecureHook("AchievementFrameSummary_UpdateAchievements", function(...)
					skinSummaryAchievements()
					if _G.select("#", ...) == 0 then
						_G.AchievementFrameSummaryAchievementsEmptyText:Hide()
					end
				end)
				skinSummaryAchievements()
				_G.AchievementFrameSummaryAchievementsEmptyText:Hide()
				local catName = "AchievementFrameSummaryCategories"
				_G[catName .. "HeaderTexture"]:SetTexture(nil)
				self:moveObject{obj=_G[catName .. "StatusBarTitle"], y=-3}
				self:moveObject{obj=_G[catName .. "StatusBarText"], y=-3}
				skinSB(catName .. "StatusBar")
				for i = 1, 12 do
					skinSB(catName .. "Category" .. i, true)
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(_G.AchievementFrameSummary)

			self:SecureHookScript(_G.AchievementFrameComparison, "OnShow", function(fObj)
				fObj:DisableDrawLayer("BACKGROUND")
				fObj:DisableDrawLayer("ARTWORK")
				self:removeRegions(_G.AchievementFrameComparisonHeader, {1, 2, 3})
				_G.AchievementFrameComparisonHeader.Shield:ClearAllPoints()
				_G.AchievementFrameComparisonHeader.Shield:SetPoint("RIGHT", _G.AchievementFrameCloseButton, "LEFT", -10, -3)
				_G.AchievementFrameComparisonHeader.Points:ClearAllPoints()
				_G.AchievementFrameComparisonHeader.Points:SetPoint("RIGHT", _G.AchievementFrameComparisonHeader.Shield, "LEFT", -10, 0)
				_G.AchievementFrameComparisonHeaderName:ClearAllPoints()
				_G.AchievementFrameComparisonHeaderName:SetPoint("RIGHT", _G.AchievementFrameComparisonHeader.Points, "LEFT", -20, 0)
				self:removeNineSlice(self:getChild(fObj, 5).NineSlice)
				self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, rns=true, fb=true, ofs=0, x2=-20, y2=-2})
				for _, type in _G.pairs{"Player", "Friend"} do
					self:removeNineSlice(fObj.Summary[type].NineSlice)
					self:removeRegions(fObj.Summary[type], {1})
					self:moveObject{obj=fObj.Summary[type].StatusBar.Title, y=-3}
					self:moveObject{obj=fObj.Summary[type].StatusBar.Text, y=-3}
					self:skinObject("statusbar", {obj=fObj.Summary[type].StatusBar, regions={3, 4, 5}, fi=0})
				end
				self:skinObject("scrollbar", {obj=fObj.AchievementContainer.ScrollBar, fType=ftype})
				local function skinAchieve(...)
					local _, element, new
					if _G.select("#", ...) == 2 then
						element, _ = ...
					elseif _G.select("#", ...) == 3 then
						element, _, new = ...
					else
						_, element, _, new = ...
					end
					if new ~= false then
						skinAchievement(element.Player)
						aObj:removeNineSlice(element.Friend.NineSlice)
						skinAchievement(element.Friend)
					end
				end
				_G.ScrollUtil.AddAcquiredFrameCallback(fObj.AchievementContainer.ScrollBox, skinAchieve, aObj, true)
				self:skinObject("scrollbar", {obj=fObj.StatContainer.ScrollBar, fType=ftype})
				local function skinStat(...)
					local _, element, new
					if _G.select("#", ...) == 2 then
						element, _ = ...
					elseif _G.select("#", ...) == 3 then
						element, _, new = ...
					else
						_, element, _, new = ...
					end
					if new ~= false then
						element.Background:SetTexture(nil)
						aObj:removeRegions(element, {2, 3, 4, 5 ,6, 7})
					end
				end
				_G.ScrollUtil.AddAcquiredFrameCallback(fObj.StatContainer.ScrollBox, skinStat, aObj, true)

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(_G.AchievementFrameComparison)

			self:SecureHookScript(_G.AchievementFrameFilterDropDown, "OnShow", function(fObj)
				self:moveObject{obj=fObj, y=-7}
				if self.prdb.TabDDTextures.textureddd then
					fObj.ddTex = fObj:CreateTexture(nil, "ARTWORK", nil, -5)
					fObj.ddTex:SetTexture(self.itTex)
					fObj.ddTex:SetSize(110, 19)
					fObj.ddTex:SetPoint("RIGHT", fObj, "RIGHT", -3, 4)
					self:skinObject("frame", {obj=fObj, fType=ftype, ng=true, x1=-7, y1=1, x2=1, y2=7})
					if self.modBtnBs then
					    self:addButtonBorder{obj=_G.AchievementFrameFilterDropDownButton, es=12, ofs=-2, x1=1}
					end
				end

				self:Unhook(fObj, "OnShow")
			end)

			self:SecureHookScript(this.SearchPreviewContainer, "OnShow", function(fObj)
				self:adjHeight{obj=fObj, adj=((4 * 27) + 30)}
				for _, btn in pairs(fObj.searchPreviews) do
					self:removeRegions(btn, {5, 6})
					btn.IconFrame:SetTexture(nil)
					if self.modBtnBs then
						self:addButtonBorder{obj=btn, relTo=btn.Icon}
					end
				end
				fObj.ShowAllSearchResults:SetNormalTexture("")
				fObj.ShowAllSearchResults:SetPushedTexture("")
				self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, ofs=4, y2=2})
				_G.LowerFrameLevel(fObj.sf)

				self:Unhook(fObj, "OnShow")
			end)

			self:SecureHookScript(this.SearchResults, "OnShow", function(fObj)
				self:skinObject("scrollbar", {obj=fObj.ScrollBar, fType=ftype})
				local function skinElement(...)
					local _, element, new
					if _G.select("#", ...) == 2 then
						element, _ = ...
					elseif _G.select("#", ...) == 3 then
						element, _, new = ...
					else
						_, element, _, new = ...
					end
					if new ~= false then
						aObj:removeRegions(element, {6, 7,})
						element.IconFrame:SetTexture(nil)
						if aObj.modBtnBs then
							aObj:addButtonBorder{obj=element, relTo=element.Icon}
						end
					end
				end
				_G.ScrollUtil.AddAcquiredFrameCallback(fObj.ScrollBox, skinElement, aObj, true)

				self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, cb=true, x1=-8, y1=-1, x2=4})

				self:Unhook(fObj, "OnShow")
			end)

			-- let AddOn skins know when when UI is skinned (used by AchieveIt skin)
			self.callbacks:Fire("AchievementUI_Skinned", self)
			-- remove all callbacks for this event
			self.callbacks.events["AchievementUI_Skinned"] = nil

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzLoDFrames[ftype].ArchaeologyUI = function(self)
		if not self.prdb.ArchaeologyUI or self.initialized.ArchaeologyUI then return end
		self.initialized.ArchaeologyUI = true

		self:SecureHookScript(_G.ArchaeologyFrame, "OnShow", function(this)
			self:moveObject{obj=this.infoButton, x=-25}
			self:skinObject("dropdown", {obj=this.raceFilterDropDown, fType=ftype})
			_G.ArchaeologyFrameRankBarBackground:SetAllPoints(this.rankBar)
			_G.ArchaeologyFrameRankBarBorder:Hide()
			self:skinObject("statusbar", {obj=this.rankBar, fi=0, bg=_G.ArchaeologyFrameRankBarBackground})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true, x1=30, x2=3})

			self:keepFontStrings(this.summaryPage) -- remove title textures
			_G.ArchaeologyFrameSummaryPageTitle:SetTextColor(self.HT:GetRGB())
			for i = 1, _G.ARCHAEOLOGY_MAX_RACES do
				this.summaryPage["race" .. i].raceName:SetTextColor(self.BT:GetRGB())
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=this.summaryPage.prevPageButton, ofs=0, clr="disabled"}
				self:addButtonBorder{obj=this.summaryPage.nextPageButton, ofs=0, clr="disabled"}
				self:SecureHook(this.summaryPage, "UpdateFrame", function(fObj)
					self:clrPNBtns(fObj:GetName())
				end)
			end

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
				self:SecureHook(this.completedPage, "UpdateFrame", function(fObj)
					self:clrPNBtns(fObj:GetName())
				end)
			end

			self:removeRegions(this.artifactPage, {2, 3, 7, 9}) -- title textures, backgrounds
			if self.modBtns then
				self:skinStdButton{obj=this.artifactPage.backButton}
				self:skinStdButton{obj=this.artifactPage.solveFrame.solveButton}
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=this.artifactPage, relTo=this.artifactPage.icon, ofs=1}
			end
			self:getRegion(this.artifactPage.solveFrame.statusBar, 1):Hide() -- BarBG texture
			self:skinObject("statusbar", {obj=this.artifactPage.solveFrame.statusBar, fi=0})
			this.artifactPage.solveFrame.statusBar:SetStatusBarColor(0.75, 0.45, 0, 0.7)
			this.artifactPage.historyTitle:SetTextColor(self.HT:GetRGB())
			this.artifactPage.historyScroll.child.text:SetTextColor(self.BT:GetRGB())
			self:skinObject("scrollbar", {obj=this.artifactPage.historyScroll.ScrollBar, fType=ftype})

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
			self:skinObject("statusbar", {obj=this.FillBar, fi=0})

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
			self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true})
			self:skinObject("frame", {obj=this, fType=ftype, cb=true, ofs=5, y1=4, y2=-11})
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
			self:SecureHook(this.PerksTab, "RefreshPowers", function(_, _)
				skinPowerBtns()
			end)
			-- Appearances
			self:SecureHook(this.AppearancesTab, "Refresh", function(fObj)
				for appearanceSet in fObj.appearanceSetPool:EnumerateActive() do
					appearanceSet:DisableDrawLayer("BACKGROUND")
				end
				for appearanceSlot in fObj.appearanceSlotPool:EnumerateActive() do
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
			self:skinObject("scrollbar", {obj=this.EssenceList.ScrollBar, fType=ftype})
			local function skinElement(...)
				local _, element, new
				if _G.select("#", ...) == 2 then
					element, _ = ...
				elseif _G.select("#", ...) == 3 then
					element, _, new = ...
				else
					_, element, _, new = ...
				end
				if new ~= false then
					aObj:nilTexture(element.Background, true)
					if aObj.modBtnBs then
						aObj:addButtonBorder{obj=element, relTo=element.Icon, reParent={element.IconCover, element.Glow, element.Glow2, element.Glow3}, clr="grey"}
					end
				else
					if aObj.modBtnBs then
						element.sbb:SetBackdropBorderColor(element.Name:GetTextColor())
					end
				end
			end
			_G.ScrollUtil.AddAcquiredFrameCallback(this.EssenceList.ScrollBox, skinElement, aObj, true)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true})

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.AzeriteEssenceUI)

		-- AzeriteEssenceLearnAnimFrame

	end

	aObj.blizzLoDFrames[ftype].AzeriteUI = function(self)
		if not self.prdb.AzeriteUI or self.initialized.AzeriteUI then return end
		self.initialized.AzeriteUI = true

		self:SecureHookScript(_G.AzeriteEmpoweredItemUI, "OnShow", function(this)
			self:keepFontStrings(this)
			self:skinObject("frame", {obj=this.BorderFrame, fType=ftype, bg=true})
			this.ClipFrame.BackgroundFrame:DisableDrawLayer("BACKGROUND")
			this.ClipFrame.BackgroundFrame.KeyOverlay:DisableDrawLayer("ARTWORK")
			for i = 1, #this.ClipFrame.BackgroundFrame.RankFrames do
				this.ClipFrame.BackgroundFrame.RankFrames[i]:DisableDrawLayer("BORDER")
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].Buffs = function(self)
		if not self.prdb.Buffs or self.initialized.Buffs then return end
		self.initialized.Buffs = true

		if self.modBtnBs then
			local function skinBuffBtn(btn)
				-- ignore privateAuraAnchor(s)
				if not btn:GetDebugName():find("AuraContainer") then
					return
				end
				if btn.symbol then
					-- handle DebuffButtonTemplate
					aObj:addButtonBorder{obj=btn, relTo=btn.Icon, reParent={btn.count, btn.duration, btn.symbol}, ofs=3}
				elseif btn.count then
					aObj:addButtonBorder{obj=btn, relTo=btn.Icon, reParent={btn.count, btn.duration}, ofs=3}
				else
					-- handle ExampleAuraTemplate buttons
					aObj:addButtonBorder{obj=btn, relTo=btn.Icon, reParent={btn.duration}, ofs=3}
				end
				-- TempEnchant, Debuff
				if btn.Border then
					btn.sbb:SetBackdropBorderColor(btn.Border:GetVertexColor())
					btn.Border:SetAlpha(0)
				else
					aObj:clrBtnBdr(btn, "grey")
				end
			end
			local function skinBuffs(frame)
				for _, buff in _G.pairs(frame.auraFrames) do
					skinBuffBtn(buff)
				end
			end
			for _, frame in _G.pairs{_G.BuffFrame, _G.DebuffFrame} do
				skinBuffs(frame)
				self:SecureHook(frame, "UpdateAuraButtons", function(this)
					skinBuffs(this)
				end)
			end
			self:SecureHookScript(_G.DeadlyDebuffFrame, "OnShow", function(this)
				skinBuffBtn(this.Debuff)

				self:Unhook(this, "OnShow")
			end)
		end

	end

	aObj.blizzFrames[ftype].CastingBar = function(self)
		if not self.prdb.CastingBar.skin or self.initialized.CastingBar then return end
		self.initialized.CastingBar = true

		if self:isAddOnLoaded("Quartz")
		or self:isAddOnLoaded("Dominos_Cast")
		then
			self.blizzFrames[ftype].CastingBar = nil
			return
		end

		local cbFrame
		-- OverlayPlayerCastingBarFrame used by ClassTalents
		for _, type in _G.pairs{"Player", "Pet", "OverlayPlayer"} do
			cbFrame = _G[type .. "CastingBarFrame"]
			self:nilTexture(cbFrame.TextBorder, true)
			self:changeShield(cbFrame.BorderShield, cbFrame.Icon)
			self:nilTexture(cbFrame.Border, true)
			self:nilTexture(cbFrame.Flash, true)
			self:skinObject("statusbar", {obj=cbFrame--[[, fi=0]], bg=cbFrame.Background, hookFunc=true})
		end

	end

	aObj.blizzFrames[ftype].CharacterFrames = function(self)
		if not self.prdb.CharacterFrames or self.initialized.CharacterFrames then return end
		self.initialized.CharacterFrames = true

		self:SecureHookScript(_G.CharacterFrame, "OnShow", function(this)
			self:removeInset(this.InsetRight)
			self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, rp=true, cb=true, x2=3})

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
			end
			-- hook this to manage the active tab
			self:SecureHook("PaperDollFrame_UpdateSidebarTabs", function()
				for i = 1, #_G.PAPERDOLL_SIDEBARS do
					if _G["PaperDollSidebarTab" .. i]
					and _G["PaperDollSidebarTab" .. i].sbb
					then
						_G["PaperDollSidebarTab" .. i].sbb:SetShown(_G.GetPaperDollSideBarFrame(i):IsShown())
					end
				end
			end)
			-- handle in combat
			if _G.InCombatLockdown() then
			    self:add2Table(self.oocTab, {_G.PaperDollFrame_UpdateSidebarTabs, {nil}})
			else
				_G.PaperDollFrame_UpdateSidebarTabs()
			end
			self:SecureHookScript(this.TitleManagerPane, "OnShow", function(fObj)
				self:skinObject("scrollbar", {obj=fObj.ScrollBar, fType=ftype})
				local function skinElement(...)
					local _, element, new
					if _G.select("#", ...) == 2 then
						element, _ = ...
					elseif _G.select("#", ...) == 3 then
						element, _, new = ...
					else
						_, element, _, new = ...
					end
					if new ~= false then
						element:DisableDrawLayer("BACKGROUND")
					end
				end
				_G.ScrollUtil.AddAcquiredFrameCallback(fObj.ScrollBox, skinElement, aObj, true)

				self:Unhook(fObj, "OnShow")
			end)
			self:SecureHookScript(this.EquipmentManagerPane, "OnShow", function(fObj)
				self:skinObject("scrollbar", {obj=fObj.ScrollBar, fType=ftype})
				local function skinElement(...)
					local _, element, new
					if _G.select("#", ...) == 2 then
						element, _ = ...
					elseif _G.select("#", ...) == 3 then
						element, _, new = ...
					else
						_, element, _, new = ...
					end
					if new ~= false then
						element:DisableDrawLayer("BACKGROUND")
						if aObj.modBtnBs then
							aObj:addButtonBorder{obj=element, relTo=element.icon}
						end
					end
				end
				_G.ScrollUtil.AddAcquiredFrameCallback(fObj.ScrollBox, skinElement, aObj, true)
				if self.modBtns then
					self:skinStdButton{obj=fObj.EquipSet}
					self:skinStdButton{obj=fObj.SaveSet, schk=true}
					self:SecureHook("PaperDollEquipmentManagerPane_Update", function()
						self:clrBtnBdr(fObj.EquipSet)
						self:clrBtnBdr(fObj.SaveSet)
					end)
				end

				self:Unhook(fObj, "OnShow")
			end)
			_G.CharacterModelScene:DisableDrawLayer("BACKGROUND")
			_G.CharacterModelScene:DisableDrawLayer("BORDER")
			_G.CharacterModelScene:DisableDrawLayer("OVERLAY")
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
					if btn.sbb then
						if not _G.GetInventoryItemTexture("player", btn:GetID()) then
							self:clrBtnBdr(btn, "grey")
							btn.icon:SetTexture(nil)
						end
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

		self:SecureHookScript(_G.GearManagerPopupFrame, "OnShow", function(this)
			self:skinIconSelector(this)

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.ReputationFrame, "OnShow", function(this)
			self:keepFontStrings(this)
			self:skinObject("scrollbar", {obj=this.ScrollBar, fType=ftype})
			local function skinElement(...)
				local _, element, new
				if _G.select("#", ...) == 2 then
					element, _ = ...
				elseif _G.select("#", ...) == 3 then
					element, _, new = ...
				else
					_, element, _, new = ...
				end
				if new ~= false then
					element.Container.Background:SetAlpha(0)
					element.Container.ReputationBar.LeftTexture:SetAlpha(0)
					element.Container.ReputationBar.RightTexture:SetAlpha(0)
					aObj:skinObject("statusbar", {obj=element.Container.ReputationBar, fi=0})
					if aObj.modBtns then
						aObj:skinExpandButton{obj=element.Container.ExpandOrCollapseButton, fType=ftype, onSB=true}
					end
				end
			end
			_G.ScrollUtil.AddAcquiredFrameCallback(this.ScrollBox, skinElement, aObj, true)
			-- ReputationDetailFrame
			self:removeNineSlice(_G.ReputationDetailFrame.Border)
			self:skinObject("frame", {obj=_G.ReputationDetailFrame, fType=ftype, kfs=true, ofs=-3})
			if self.modBtns then
				self:skinCloseButton{obj=_G.ReputationDetailCloseButton}
				self:skinStdButton{obj=_G.ReputationDetailViewRenownButton, fType=ftype, clr="gold"}
				self:adjHeight{obj=_G.ReputationDetailViewRenownButton, adj=4}
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
			self:skinObject("scrollbar", {obj=this.ScrollBar, fType=ftype})
			local function skinElement(...)
				local _, element, new
				if _G.select("#", ...) == 2 then
					element, _ = ...
				elseif _G.select("#", ...) == 3 then
					element, _, new = ...
				else
					_, element, _, new = ...
				end
				if new ~= false then
					aObj:removeRegions(element, {1, 6, 7, 8})
				end
			end
			_G.ScrollUtil.AddAcquiredFrameCallback(this.ScrollBox, skinElement, aObj, true)
			_G.TokenFramePopup.Border:DisableDrawLayer("BACKGROUND")
			self:skinObject("frame", {obj=_G.TokenFramePopup, fType=ftype, kfs=true, cb=true, ofs=-3, x1=0})
			if self.modBtns then
				-- FIXME: CloseButton skinned here as it has a prefix of $parent, bug in Blizzard XML file
				self:skinCloseButton{obj=self:getChild(_G.TokenFramePopup, 4), fType=ftype}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=_G.TokenFramePopup.InactiveCheckBox, fType=ftype}
				self:skinCheckButton{obj=_G.TokenFramePopup.BackpackCheckBox, fType=ftype}
			end

			self:Unhook(_G.TokenFrame, "OnShow")
		end)

	end

	aObj.blizzLoDFrames[ftype].CharacterCustomize = function(self)
		if not self.prdb.CharacterCustomize or self.initialized.CharacterCustomize then return end
		self.initialized.CharacterCustomize = true

		self:SecureHookScript(_G.CharCustomizeFrame, "OnShow", function(this)
			self:SecureHook(_G.BarberShopFrame, "UpdateSex", function(fObj)
				for btn in fObj.sexButtonPool:EnumerateActive() do
					btn.Ring:SetTexture(nil)
					btn.BlackBG:SetTexture(nil)
				end
			end)
			self:SecureHook(this, "UpdateAlteredFormButtons", function(fObj)
				for btn in fObj.alteredFormsPools:EnumerateActive() do
					btn.Ring:SetTexture(nil)
				end
			end)
			-- Categories
			-- Options
			self:SecureHook(this, "UpdateOptionButtons", function(fObj, _)
				for btn in fObj.pools:GetPool("CharCustomizeCategoryButtonTemplate"):EnumerateActive() do
					btn.Ring:SetTexture(nil)
				end
				for frame in fObj.pools:GetPool("CharCustomizeOptionCheckButtonTemplate"):EnumerateActive() do
					if self.modChkBtns then
						self:skinCheckButton{obj=frame.Button, fType=ftype}
					end
				end
				for btn in fObj.pools:GetPool("CharCustomizeConditionalModelButtonTemplate"):EnumerateActive() do
					btn.Ring:SetTexture(nil)
				end
				for frame in fObj.selectionPopoutPool:EnumerateActive() do
					self:removeNineSlice(frame.Button.Popout.Border)
					self:skinObject("frame", {obj=frame.Button.Popout, fType=ftype, kfs=true, ofs=-6, y2=10})
					_G.RaiseFrameLevelByTwo(frame.Button.Popout) -- appear above other buttons
					-- resize frame
					frame.Button.Popout:Show()
					frame.Button.Popout:Hide()
					if self.modBtns then
						self:skinStdButton{obj=frame.Button, ofs=-5}
						-- ensure button skin is displayed first time
						frame.Button:Hide()
						frame.Button:Show()
					end
					if self.modBtnBs then
						self:addButtonBorder{obj=frame.IncrementButton, ofs=-2, x1=3, y1=-3, clr="gold"}
						self:addButtonBorder{obj=frame.DecrementButton, ofs=-2, x1=3, y1=-3, clr="gold"}
						self:secureHook(frame, "UpdateButtons", function(_)
							self:clrBtnBdr(frame.IncrementButton, "gold")
							self:clrBtnBdr(frame.DecrementButton, "gold")
						end)
					end
				end
			end)
			if self.modBtns then
				self:skinStdButton{obj=_G.BarberShopFrame.CancelButton, ofs=0}
				self:skinStdButton{obj=_G.BarberShopFrame.ResetButton, sechk=true, ofs=0}
				self:skinStdButton{obj=_G.BarberShopFrame.AcceptButton, sechk=true, ofs=0}
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=this.RandomizeAppearanceButton, ofs=-4, x1=5, y2=5, clr="gold"}
				self:addButtonBorder{obj=this.SmallButtons.ResetCameraButton, ofs=-4, x1=5, y2=5, clr="gold"}
				self:addButtonBorder{obj=this.SmallButtons.ZoomOutButton, ofs=-4, x1=5, y2=5, clr="gold"}
				self:addButtonBorder{obj=this.SmallButtons.ZoomInButton, ofs=-4, x1=5, y2=5, clr="gold"}
				self:addButtonBorder{obj=this.SmallButtons.RotateLeftButton, ofs=-4, x1=5, y2=5, clr="gold"}
				self:addButtonBorder{obj=this.SmallButtons.RotateRightButton, ofs=-4, x1=5, y2=5, clr="gold"}
				self:SecureHook(this, "UpdateZoomButtonStates", function(fObj)
					self:clrBtnBdr(fObj.SmallButtons.ZoomOutButton, "gold")
					self:clrBtnBdr(fObj.SmallButtons.ZoomInButton, "gold")
				end)
			end

			self:Unhook(this, "OnShow")
		end)

		_G.C_Timer.After(0.1, function()
			self:add2Table(self.ttList, _G.CharCustomizeTooltip)
			self:add2Table(self.ttList, _G.CharCustomizeNoHeaderTooltip)
		end)

	end

	aObj.blizzLoDFrames[ftype].ClassTalentUI = function(self)
		if not self.prdb.ClassTalentUI or self.initialized.ClassTalentUI then return end
		self.initialized.ClassTalentUI = true

		self:SecureHookScript(_G.ClassTalentFrame, "OnShow", function(this)
			this.PortraitContainer.portrait:SetAlpha(0)
			self:skinObject("tabs", {obj=this.TabSystem,  pool=true, fType=ftype, ignoreSize=true, track=false})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, rns=true, cb=true})

			self:SecureHookScript(this.SpecTab, "OnShow", function(fObj)
				fObj.Background:SetTexture(nil)
				fObj.BlackBG:SetTexture(nil)
				local function skinSpecFrames()
					for specContentFrame in fObj.SpecContentFramePool:EnumerateActive() do
						specContentFrame:DisableDrawLayer("BORDER")
						specContentFrame:DisableDrawLayer("OVERLAY")
						-- add border around SpecImage
						aObj.modUIBtns:addButtonBorder{obj=specContentFrame, fType=ftype, relTo=specContentFrame.SpecImage}
						self:skinObject("frame", {obj=specContentFrame, fType=ftype, fb=true, y2=-4})
						if specContentFrame.specIndex == fObj:GetCurrentSpecIndex() then
							self:clrBtnBdr(specContentFrame, "orange")
							self:clrBBC(specContentFrame.sf, "orange")
						else
							self:clrBtnBdr(specContentFrame, "grey")
							self:clrBBC(specContentFrame.sf, "grey")
						end
						if aObj.modBtns then
							aObj:skinStdButton{obj=specContentFrame.ActivateButton, fType=ftype, schk=true}
						end
					end
				end
				skinSpecFrames()
				self:SecureHook(fObj, "UpdateSpecFrame", function(_)
					if not _G.C_SpecializationInfo.IsInitialized() then
						return
					end
					skinSpecFrames()
				end)
				self:SecureHook(fObj, "UpdateSpecContents", function(_)
					if _G.GetNumSpecializations(false, false) == 0 then
						return
					end
					skinSpecFrames()
				end)

				self:Unhook(fObj, "OnShow")
			end)

			self:SecureHookScript(this.TalentsTab, "OnShow", function(fObj)
				fObj.BlackBG:SetTexture(nil)
				fObj.BottomBar:SetTexture(nil)
				self:skinObject("dropdown", {obj=fObj.LoadoutDropDown.DropDownControl.DropDownMenu, fType=ftype})
				self:skinObject("editbox", {obj=fObj.SearchBox, fType=ftype, si=true, y1=-4, y2=4})
				fObj.WarmodeButton.Ring:SetAlpha(0)
				if self.modBtns then
					self:skinStdButton{obj=fObj.ApplyButton, fType=ftype, sechk=true, ofs=2}
					self:skinStdButton{obj=fObj.InspectCopyButton, fType=ftype}
				end

				self:SecureHookScript(fObj.SearchPreviewContainer, "OnShow", function(frame)
					local function skinSearch(...)
						local _, element, new
						if _G.select("#", ...) == 2 then
							element, _ = ...
						elseif _G.select("#", ...) == 3 then
							element, _, new = ...
						else
							_, element, _, new = ...
						end
						if new ~= false then
							element.IconFrame:SetTexture(nil)
							if aObj.modBtnBs then
								aObj:addButtonBorder{obj=element, fType=ftype, relTo=element.Icon}
							end
						end
					end
					_G.ScrollUtil.AddAcquiredFrameCallback(frame.ScrollBox, skinSearch, aObj, true)
					self:skinObject("frame", {obj=frame, fType=ftype, kfs=true, ofs=5, y2=-2})

					self:Unhook(frame, "OnShow")
				end)

				self:SecureHookScript(fObj.PvPTalentList, "OnShow", function(frame)
					local function skinElement(...)
						local _, element, elementData, new
						if _G.select("#", ...) == 2 then
							element, elementData = ...
						elseif _G.select("#", ...) == 3 then
							element, elementData, new = ...
						else
							_, element, elementData, new = ...
						end
						if new ~= false then
							element.Border:SetTexture(nil)
							element.Selected:SetTexture(nil)
							element.SelectedOtherCheck:SetTexture(nil)
							if aObj.modBtnBs then
								aObj:addButtonBorder{obj=element, fType=ftype, relTo=element.Icon}
								aObj:clrBtnBdr(element, (elementData.selectedHere or elementData.selectedOther) and "yellow" or "green")
							end
						end
					end
					_G.ScrollUtil.AddAcquiredFrameCallback(frame.ScrollBox, skinElement, aObj, true)
					self:skinObject("frame", {obj=frame, fType=ftype, kfs=true, ofs=6})

					self:Unhook(frame, "OnShow")
				end)

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.TalentsTab)

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.ClassTalentLoadoutCreateDialog, "OnShow", function(fObj)
			self:removeNineSlice(fObj.Border)
			self:skinObject("editbox", {obj=fObj.NameControl.EditBox, fType=ftype, y1=-10, y2=10})
			self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, ofs=-3})
			if self.modBtns then
				self:skinStdButton{obj=fObj.AcceptButton, fType=ftype, sechk=true}
				self:skinStdButton{obj=fObj.CancelButton, fType=ftype}
			end

			self:Unhook(fObj, "OnShow")
		end)

		self:SecureHookScript(_G.ClassTalentLoadoutImportDialog, "OnShow", function(fObj)
			self:removeNineSlice(fObj.Border)
			self:skinObject("frame", {obj=fObj.ImportControl.InputContainer, fType=ftype, kfs=true, fb=true, ofs=6})
			self:skinObject("editbox", {obj=fObj.NameControl.EditBox, fType=ftype, y1=-10, y2=10})
			self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, ofs=-3})
			if self.modBtns then
				self:skinStdButton{obj=fObj.AcceptButton, fType=ftype, sechk=true}
				self:skinStdButton{obj=fObj.CancelButton, fType=ftype}
			end

			self:Unhook(fObj, "OnShow")
		end)

		self:SecureHookScript(_G.ClassTalentLoadoutEditDialog, "OnShow", function(fObj)
			self:removeNineSlice(fObj.Border)
			self:skinObject("editbox", {obj=fObj.NameControl.EditBox, fType=ftype, y1=-10, y2=10})
			self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, ofs=-3})
			if self.modBtns then
				self:skinStdButton{obj=fObj.AcceptButton, fType=ftype, sechk=true}
				self:skinStdButton{obj=fObj.DeleteButton, fType=ftype}
				self:skinStdButton{obj=fObj.CancelButton, fType=ftype}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=fObj.UsesSharedActionBars.CheckButton, fType=ftype}
			end

			self:Unhook(fObj, "OnShow")
		end)

		-- N.B. OverlayPlayerCastingBarFrame skinned in CastingBar function

	end

	aObj.blizzFrames[ftype].ContainerFrames = function(self)
		if not self.prdb.ContainerFrames.skin or self.initialized.ContainerFrames then return end
		self.initialized.ContainerFrames = true

		if self:isAddOnLoaded("LiteBag") then
			self.blizzFrames[ftype].ContainerFrames = nil
			return
		end

		local function skinBag(frame, id)
			aObj:skinObject("frame", {obj=frame, fType=ftype, kfs=true, cbns=true})
			-- Add gear texture to portrait button for settings
			local cfpb = frame.PortraitButton
			cfpb.gear = cfpb:CreateTexture(nil, "artwork")
			cfpb.gear:SetAllPoints()
			cfpb.gear:SetTexture(self.tFDIDs.gearWhl)
			cfpb:SetSize(18, 18)
			cfpb.Highlight:ClearAllPoints()
			cfpb.Highlight:SetPoint("center")
			cfpb.Highlight:SetSize(22, 22)
			if aObj.modBtnBs then
				for _, btn in frame:EnumerateValidItems() do
					aObj:addButtonBorder{obj=btn, fType=ftype, ibt=true, reParent={btn.UpgradeIcon, btn.flash, btn.NewItemTexture, btn.BattlepayItemTexture, btn.BagIndicator, btn.JunkIcon}, ofs=3}
					btn.ExtendedSlot:SetTexture(nil)
					btn.NormalTexture:SetAlpha(0)
				end
				-- remove button slot texture when empty
				aObj:SecureHook(frame, "UpdateItems", function(fObj)
					for _, btn in fObj:EnumerateValidItems() do
						if not btn.hasItem then
							btn:SetItemButtonTexture("")
						end
						if btn.ItemSlotBackground then
							btn.ItemSlotBackground:SetTexture("")
						end
						aObj:clrButtonFromBorder(btn)
					end
				end)
				frame:UpdateItems()
			end
			-- Backpack
			if id == 0 then
				aObj:skinObject("editbox", {obj=_G.BagItemSearchBox, fType=ftype, si=true, ca=true})
				frame.MoneyFrame.Border:DisableDrawLayer("BACKGROUND")
				if aObj.modBtnBs then
					aObj:addButtonBorder{obj=_G.BagItemAutoSortButton, ofs=0, y1=1, clr="grey"}
				end
			end
		end

		self:SecureHook("ContainerFrame_GenerateFrame", function(frame, _, id)
			-- skin the frame if required
			if not frame.sf then
				skinBag(frame, id)
			end
		end)

		if _G.ContainerFrameSettingsManager.TokenTracker then
			_G.ContainerFrameSettingsManager.TokenTracker.Border:DisableDrawLayer("BACKGROUND")
		end

	end

	aObj.blizzFrames[ftype].DressUpFrame = function(self)
		if not self.prdb.DressUpFrame or self.initialized.DressUpFrame then return end
		self.initialized.DressUpFrame = true

		if self:isAddOnLoaded("DressUp") then
			self.blizzFrames[ftype].DressUpFrame = nil
			return
		end

		self:SecureHookScript(_G.SideDressUpFrame, "OnShow", function(this)
			self:removeRegions(_G.SideDressUpFrameCloseButton, {5}) -- corner texture
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, x1=-3, y1=-3, x2=-2})
			_G.LowerFrameLevel(this) -- make it appear behind parent frame
			if self.modBtns then
				self:skinStdButton{obj=_G.SideDressUpFrame.ResetButton}
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.DressUpFrame, "OnShow", function(this)
			self:skinObject("dropdown", {obj=this.OutfitDropDown, fType=ftype, y2=-4})
			self:skinObject("frame", {obj=this.OutfitDetailsPanel, fType=ftype, kfs=true, ofs=-7})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true, y2=-4})
			if self.prdb.DUTexture then
				this.ModelBackground:SetDrawLayer("ARTWORK")
				this.ModelBackground:SetAlpha(1)
			else
				this.ModelBackground:SetAlpha(0)
			end
			if self.modBtns then
				self:skinStdButton{obj=this.OutfitDropDown.SaveButton}
				self:skinOtherButton{obj=this.MaximizeMinimizeFrame.MaximizeButton, font=self.fontS, text=self.nearrow}
				self:skinOtherButton{obj=this.MaximizeMinimizeFrame.MinimizeButton, font=self.fontS, text=self.swarrow}
				self:skinStdButton{obj=_G.DressUpFrameCancelButton}
				self:skinStdButton{obj=this.ResetButton}
				self:skinStdButton{obj=this.LinkButton, x1=4}
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=this.ToggleOutfitDetailsButton, fType=ftype, clr="grey"}
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.TransmogAndMountDressupFrame, "OnShow", function(this)
			if self.modChkBtns then
				self:skinCheckButton{obj=this.ShowMountCheckButton}
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzLoDFrames[ftype].EncounterJournal = function(self) -- a.k.a. Adventure Guide
		if not self.prdb.EncounterJournal or self.initialized.EncounterJournal then return end
		self.initialized.EncounterJournal = true

		-- used by both Encounters & Loot sub frames
		local function skinFilterBtn(btn)
			btn:DisableDrawLayer("BACKGROUND")
			btn:GetNormalTexture():SetTexture(nil)
			btn:GetPushedTexture():SetTexture(nil)
			aObj.modUIBtns:skinStdButton{obj=btn, x1=-11, y1=-2, x2=11, y2=2, clr="gold"} -- use module function so button appears
		end
		self:SecureHookScript(_G.EncounterJournal, "OnShow", function(this)
			this.navBar:DisableDrawLayer("BACKGROUND")
			this.navBar:DisableDrawLayer("BORDER")
			this.navBar.overlay:DisableDrawLayer("OVERLAY")
			self:skinNavBarButton(this.navBar.home)
			this.navBar.home.text:SetPoint("RIGHT", -20, 0)
			self:skinObject("editbox", {obj=this.searchBox, fType=ftype, si=true})
			self:skinObject("dropdown", {obj=this.LootJournalViewDropDown, fType=ftype, x2=-7})
			self:skinObject("tabs", {obj=this, tabs=this.Tabs, selectedTab=this.selectedTab, fType=ftype, lod=self.isTT and true, offsets={x1=-1, y1=2, x2=1, y2=1}, regions={7, 8, 9, 10, 11}, track=false, func=function(tab) tab:SetFrameLevel(20) end})
			if self.isTT then
				self:SecureHook("EJ_ContentTab_Select", function(id)
					for i, tab in _G.pairs(this.Tabs) do
						if i == id then
							self:setActiveTab(tab.sf)
						else
							self:setInactiveTab(tab.sf)
						end
					end
				end)
			end
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true})

			self:SecureHookScript(this.searchBox.searchPreviewContainer, "OnShow", function(fObj)
				local btn
				for i = 1, 5 do
					btn = fObj:GetParent()["sbutton" .. i]
					btn:SetNormalTexture(nil)
					btn:SetPushedTexture(nil)
				end
				fObj:GetParent().showAllResults:SetNormalTexture(nil)
				fObj:GetParent().showAllResults:SetPushedTexture(nil)
				self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true})
				-- adjust skinframe as parent frame is resized when populated
				fObj.sf:SetPoint("TOPLEFT", fObj.topBorder, "TOPLEFT", 0, 2)
				fObj.sf:SetPoint("BOTTOMRIGHT", fObj.botRightCorner, "BOTTOMRIGHT", 0, 4)

				self:Unhook(fObj, "OnShow")
			end)

			self:SecureHookScript(this.searchResults, "OnShow", function(fObj)
				self:skinObject("scrollbar", {obj=fObj.ScrollBar, fType=ftype})
				local function skinElement(...)
					local _, element, new
					if _G.select("#", ...) == 2 then
						element, _ = ...
					elseif _G.select("#", ...) == 3 then
						element, _, new = ...
					else
						_, element, _, new = ...
					end
					if new ~= false then
						aObj:removeRegions(element, {1})
						element:GetNormalTexture():SetAlpha(0)
						element:GetPushedTexture():SetAlpha(0)
						if aObj.modBtnBs then
							 aObj:addButtonBorder{obj=element, relTo=element.icon}
						end
					end
					end
				_G.ScrollUtil.AddAcquiredFrameCallback(this.ScrollBox, skinElement, aObj, true)
				fObj:SetFrameLevel(25) -- make it appear above tabs
				self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, cb=true, ofs=6, y1=-1, x2=4})

				self:Unhook(fObj, "OnShow")
			end)

			self:SecureHookScript(this.instanceSelect, "OnShow", function(fObj)
				fObj.bg:SetAlpha(0)
				self:skinObject("dropdown", {obj=fObj.tierDropDown, fType=ftype})
				self:SecureHook("EncounterJournal_EnableTierDropDown", function()
					self:checkDisabledDD(fObj.tierDropDown)
				end)
				self:SecureHook("EncounterJournal_DisableTierDropDown", function()
					self:checkDisabledDD(fObj.tierDropDown)
				end)
				self:skinObject("scrollbar", {obj=fObj.ScrollBar, fType=ftype})
				local function skinElement(...)
					local _, element, new
					if _G.select("#", ...) == 2 then
						element, _ = ...
					elseif _G.select("#", ...) == 3 then
						element, _, new = ...
					else
						_, element, _, new = ...
					end
					if new ~= false then
						if aObj.modBtnBs then
							aObj:addButtonBorder{obj=element, fType=ftype, relTo=element.bgImage, ofs=1}
						end
					end
				end
				_G.ScrollUtil.AddAcquiredFrameCallback(fObj.ScrollBox, skinElement, aObj, true)

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.instanceSelect)

			self:SecureHookScript(this.encounter, "OnShow", function(fObj)
				-- Instance frame
				fObj.instance.loreBG:SetTexCoord(0.06, 0.70, 0.08, 0.58)
				fObj.instance.loreBG:SetSize(370, 308)
				fObj.instance:DisableDrawLayer("ARTWORK")
				self:moveObject{obj=fObj.instance.mapButton, x=-20, y=-18}
				if self.modBtnBs then
					self:addButtonBorder{obj=fObj.instance.mapButton, relTo=fObj.instance.mapButton.texture, x1=2, y1=-1, x2=-2, y2=1}
				end
				self:skinObject("scrollbar", {obj=fObj.instance.LoreScrollBar, fType=ftype})
				fObj.instance.LoreScrollingFont:GetFontString():SetTextColor(self.BT:GetRGB())
				-- Info frame
				fObj.info:DisableDrawLayer("BACKGROUND")
				fObj.info.encounterTitle:SetTextColor(self.HT:GetRGB())
				fObj.info.instanceButton:GetNormalTexture():SetTexture(nil)
				fObj.info.instanceButton:SetHighlightTexture(self.tFDIDs.ejt)
				fObj.info.instanceButton:GetHighlightTexture():SetTexCoord(0.68945313, 0.81054688, 0.33300781, 0.39257813)
				self:skinObject("scrollbar", {obj=fObj.info.BossesScrollBar, fType=ftype})
				local function skinBossesElement(...)
					local _, element, new
					if _G.select("#", ...) == 2 then
						element, _ = ...
					elseif _G.select("#", ...) == 3 then
						element, _, new = ...
					else
						_, element, _, new = ...
					end
					if new ~= false then
						element:GetNormalTexture():SetTexture(nil)
						element:GetPushedTexture():SetTexture(nil)
					end
				end
				_G.ScrollUtil.AddAcquiredFrameCallback(fObj.info.BossesScrollBox, skinBossesElement, aObj, true)
				skinFilterBtn(fObj.info.difficulty)
				fObj.info.reset:GetNormalTexture():SetTexture(nil)
				fObj.info.reset:GetPushedTexture():SetTexture(nil)
				if self.modBtns then
					self:skinStdButton{obj=fObj.info.reset, y2=2, clr="gold"}
				end
				fObj.info.overviewScroll.child.overviewDescription.Text:SetTextColor("P", self.BT:GetRGB())
				fObj.info.detailsScroll.child.description:SetTextColor(self.BT:GetRGB())
				fObj.info.overviewScroll.child.loreDescription:SetTextColor(self.BT:GetRGB())
				fObj.info.overviewScroll.child.header:SetTexture(nil)
				-- Hook this to skin headers
				local function skinHeader(header)
					header.button:DisableDrawLayer("BACKGROUND")
					header.overviewDescription.Text:SetTextColor("H1", aObj.HT:GetRGB())
					if header.description:GetText() then
						local newText, upd = aObj:removeColourCodes(header.description:GetText()) -- handle embedded colour code
						if upd then
							header.description:SetText(newText)
						end
						header.description:SetTextColor(aObj.BT:GetRGB())
					end
					header.descriptionBG:SetTexture(nil)
					header.descriptionBGBottom:SetTexture(nil)
					aObj:getRegion(header.button.portrait, 2):SetTexture(nil)
					for _, bObj in _G.pairs(header.Bullets) do
						bObj.Text:SetTextColor("P", aObj.BT:GetRGB())
					end
				end
				self:SecureHook("EncounterJournal_ToggleHeaders", function(ejH, _)
					if ejH.isOverview then
						for _, header in _G.ipairs(fObj.overviewFrame.overviews) do
							skinHeader(header)
						end
					else
						for _, header in _G.ipairs(fObj.usedHeaders) do
							skinHeader(header)
						end
					end
				end)
				-- Loot Frame
				self:skinObject("scrollbar", {obj=fObj.info.LootContainer.ScrollBar, fType=ftype})
				skinFilterBtn(fObj.info.LootContainer.filter)
				skinFilterBtn(fObj.info.LootContainer.slotFilter)
				fObj.info.LootContainer.classClearFilter:DisableDrawLayer("BACKGROUND")
				local function skinLootElement(...)
					local _, element, new
					if _G.select("#", ...) == 2 then
						element, _ = ...
					elseif _G.select("#", ...) == 3 then
						element, _, new = ...
					else
						_, element, _, new = ...
					end
					if new ~= false then
						if element.armorType then -- ignore divider(s)
							element:DisableDrawLayer("BORDER")
							element.armorType:SetTextColor(self.BT:GetRGB())
							element.slot:SetTextColor(self.BT:GetRGB())
							element.boss:SetTextColor(self.BT:GetRGB())
							if aObj.modBtnBs then
								aObj:addButtonBorder{obj=element, relTo=element.icon}
							end
						end
					end
				end
				_G.ScrollUtil.AddAcquiredFrameCallback(fObj.info.LootContainer.ScrollBox, skinLootElement, aObj, true)
				-- Model Frame
				self:keepFontStrings(fObj.info.model)
				local function skinCreatureBtn(cBtn)
					local hTex
					if cBtn
					and not cBtn.sknd
					then
						cBtn.sknd = true
						cBtn:GetNormalTexture():SetTexture(nil)
						hTex = cBtn:GetHighlightTexture()
						hTex:SetTexture(aObj.tFDIDs.ejt)
						hTex:SetTexCoord(0.68945313, 0.81054688, 0.33300781, 0.39257813)
					end
				end
				-- creature(s)
				for _, cBtn in _G.ipairs(fObj.info.creatureButtons) do
					skinCreatureBtn(cBtn)
				end
				-- hook this to skin additional buttons
				self:SecureHook("EncounterJournal_GetCreatureButton", function(index)
					if index > 9 then return end -- MAX_CREATURES_PER_ENCOUNTER
					skinCreatureBtn(_G.EncounterJournal.encounter.info.creatureButtons[index])
				end)
				-- Tabs (side)
				self:skinObject("tabs", {obj=fObj.info, tabs={fObj.info.overviewTab, fObj.info.lootTab, fObj.info.bossTab, fObj.info.modelTab}, fType=ftype, ignoreHLTex=false, ng=true, regions={4, 5, 6}, offsets={x1=9, y1=-6, x2=-6, y2=6}, track=false})
				self:moveObject{obj=fObj.info.overviewTab, x=7}

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.encounter)

			-- a.k.a. Traveler's Log
			local function changeHCI(bObj)
				if bObj:GetElementData():IsCollapsed() then
					bObj.HeaderCollapseIndicator:SetAtlas("ui-hud-minimap-zoom-in")
				else
					bObj.HeaderCollapseIndicator:SetAtlas("ui-hud-minimap-zoom-out")
				end
			end
			self:SecureHookScript(this.MonthlyActivitiesFrame, "OnShow", function(fObj)
				fObj:DisableDrawLayer("BACKGROUND")
				fObj:DisableDrawLayer("BORDER")
				fObj.HelpButton.Ring:SetTexture(nil)
				fObj.ThresholdBar:DisableDrawLayer("BORDER")
				-- TODO: Remove RewardItem border
				fObj.FilterList:DisableDrawLayer("BACKGROUND")
				self:skinObject("scrollbar", {obj=fObj.ScrollBar, fType=ftype})
				aObj:skinObject("scrollbar", {obj=fObj.ScrollBar, fType=ftype})
				local function skinActivities(...)
					-- aObj:Debug("skinActivities: [%s, %s, %s, %s]", ...)
					local _, element
					if _G.select("#", ...) == 2 then
						element, _ = ...
					elseif _G.select("#", ...) == 3 then
						_, element, _ = ...
					end
					element:GetNormalTexture():SetAlpha(0)
					element.TextContainer.NameText:SetTextColor(aObj.BT:GetRGB())
					if element.HeaderCollapseIndicator then
						changeHCI(element)
						aObj:secureHook(element, "UpdateButtonState", function(bObj)
							changeHCI(bObj)
						end)
					end
					aObj:skinObject("frame", {obj=element, fType=ftype, ofs=-3, y2=4, fb=true})
				end
				_G.ScrollUtil.AddInitializedFrameCallback(fObj.ScrollBox, skinActivities, aObj, true)

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.MonthlyActivitiesFrame)

			self:SecureHookScript(this.suggestFrame, "OnShow", function(fObj)
				local ejsfs
				for i = 1, _G.AJ_MAX_NUM_SUGGESTIONS do
					ejsfs = fObj["Suggestion" .. i]
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
						end)
					end
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.suggestFrame)

			self:SecureHookScript(this.LootJournal, "OnShow", function(fObj)
				self:skinObject("scrollbar", {obj=fObj.ScrollBar, fType=ftype})
				local function skinElement(...)
					local _, element, new
					if _G.select("#", ...) == 2 then
						element, _ = ...
					elseif _G.select("#", ...) == 3 then
						element, _, new = ...
					else
						_, element, _, new = ...
					end
					if new ~= false then
						element.Background:SetTexture(nil)
						element.BackgroundOverlay:SetAlpha(0)
					end
				end
				_G.ScrollUtil.AddAcquiredFrameCallback(fObj.ScrollBox, skinElement, aObj, true)
				self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, fb=true, x1=-8, y1=6, x2=8, y2=-5})
				skinFilterBtn(fObj.ClassDropDownButton)
				skinFilterBtn(fObj.RuneforgePowerFilterDropDownButton)

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.LootJournal)

			self:SecureHookScript(this.LootJournalItems, "OnShow", function(fObj)
				fObj:DisableDrawLayer("BACKGROUND")
				self:skinObject("scrollbar", {obj=fObj.ItemSetsFrame.ScrollBar, fType=ftype})
				local function skinElement(...)
					local _, element, new
					if _G.select("#", ...) == 2 then
						element, _ = ...
					elseif _G.select("#", ...) == 3 then
						element, _, new = ...
					else
						_, element, _, new = ...
					end
					if new ~= false then
						element.Background:SetTexture(nil)
					end
				end
				_G.ScrollUtil.AddAcquiredFrameCallback(fObj.ItemSetsFrame.ScrollBox, skinElement, aObj, true)
				self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, fb=true, x1=-8, y1=6, x2=8, y2=-5})
				skinFilterBtn(fObj.ItemSetsFrame.ClassButton)

				self:Unhook(fObj, "OnShow")
			end)
			-- let AddOn skins know when when UI is skinned (used by Atlas skin)
			self.callbacks:Fire("EncounterJournal_Skinned", self)
			-- remove all callbacks for this event
			self.callbacks.events["EncounterJournal_Skinned"] = nil

			self:Unhook(this, "OnShow")
		end)

		-- this is a frame NOT a GameTooltip
		self:SecureHookScript(_G.EncounterJournalTooltip, "OnShow", function(this)
			self:skinObject("frame", {obj=this, fType=ftype})
			-- TODO: .Item1.tooltip

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
				for _, btn in _G.pairs(_G.EquipmentFlyoutFrame.buttons) do
					self:addButtonBorder{obj=btn, ibt=true, reParent={btn.UpgradeIcon}}
					-- change 'Place In Bags' button border alpha & stop it changing
					if btn:GetID() == 1 then
						self:clrBtnBdr(btn, "grey")
						btn.sbb.SetBackdropBorderColor = _G.nop
					end
				end
			end
		end)

		self:SecureHookScript(_G.EquipmentFlyoutFrame, "OnShow", function(this)
			self:skinObject("frame", {obj=this.buttonFrame, fType=ftype, ofs=2, x2=5, clr="grey"})

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].FriendsFrame = function(self)
		if not self.prdb.FriendsFrame or self.initialized.FriendsFrame then return end
		self.initialized.FriendsFrame = true

		local function addTabBorder(frame)
			aObj:skinObject("frame", {obj=frame, fType=ftype, fb=true, x1=0, y1=-81, x2=1, y2=0})
		end
		self:SecureHookScript(_G.FriendsFrame, "OnShow", function(this)
			self:skinObject("dropdown", {obj=_G.FriendsDropDown, fType=ftype})
			self:skinObject("dropdown", {obj=_G.TravelPassDropDown, fType=ftype})
			self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true, x2=3, y2=-2})
			-- tooltip
			_G.C_Timer.After(0.1, function()
				self:add2Table(self.ttList, _G.FriendsTooltip)
			end)

			self:SecureHookScript(_G.FriendsTabHeader, "OnShow", function(fTH)
				_G.FriendsFrameBattlenetFrame:DisableDrawLayer("BACKGROUND")
				if self.modBtnBs then
					self:addButtonBorder{obj=_G.FriendsFrameBattlenetFrame.BroadcastButton, ofs=-2, x1=1}
				end
				-- .UnavailableInfoButton
				self:SecureHookScript(_G.FriendsFrameBattlenetFrame.BroadcastFrame, "OnShow", function(fObj)
					self:keepFontStrings(fObj.Border)
					fObj.EditBox:DisableDrawLayer("BACKGROUND")
					self:skinObject("editbox", {obj=fObj.EditBox, fType=ftype})
					self:moveObject{obj=fObj.EditBox.PromptText, x=5}
					self:adjHeight{obj=fObj.EditBox, adj=-6}
					self:skinObject("frame", {obj=fObj, fType=ftype, ofs=-10})
					if self.modBtns then
						self:skinStdButton{obj=fObj.UpdateButton}
						self:skinStdButton{obj=fObj.CancelButton}
					end

					self:Unhook(fObj, "OnShow")
				end)
				self:SecureHookScript(_G.FriendsFrameBattlenetFrame.UnavailableInfoFrame, "OnShow", function(fObj)
					self:skinObject("frame", {obj=fObj, fType=ftype, rns=true})

					self:Unhook(fObj, "OnShow")
				end)
				self:skinObject("dropdown", {obj=_G.FriendsFrameStatusDropDown, fType=ftype})
				_G.FriendsFrameStatusDropDownStatus:SetAlpha(1) -- display status icon
				-- Top Tabs
				self:skinObject("tabs", {obj=fTH, prefix=fTH:GetName(), fType=ftype, lod=self.isTT and true, upwards=true, offsets={x1=1, y1=self.isTT and -4 or -8, x2=-1, y2=-4}})
				_G.RaiseFrameLevel(fTH)

				self:Unhook(fTH, "OnShow")
			end)
			self:checkShown(_G.FriendsTabHeader)

			self:SecureHookScript(_G.FriendsListFrame, "OnShow", function(fObj)
				self:skinObject("scrollbar", {obj=fObj.ScrollBar, fType=ftype})
				local function skinElement(...)
					local _, element, new
					if _G.select("#", ...) == 2 then
						element, _ = ...
					elseif _G.select("#", ...) == 3 then
						element, _, new = ...
					else
						_, element, _, new = ...
					end
					if new ~= false then
						if element.background then
							element.background:SetAlpha(0)
							if aObj.modBtnBs then
								aObj:addButtonBorder{obj=element, relTo=element.gameIcon, ofs=0, clr="grey"}
								aObj:SecureHook(element.gameIcon, "Show", function(bObj)
									bObj:GetParent().sbb:Show()
								end)
								aObj:SecureHook(element.gameIcon, "Hide", function(bObj)
									bObj:GetParent().sbb:Hide()
								end)
								aObj:SecureHook(element.gameIcon, "SetShown", function(bObj, show)
									bObj:GetParent().sbb:SetShown(bObj, show)
								end)
								element.sbb:SetShown(element.gameIcon:IsShown())
								aObj:addButtonBorder{obj=element.travelPassButton, schk=true, ofs=0, y1=3, y2=-2}
								aObj:addButtonBorder{obj=element.summonButton, schk=true}
							end
						end
					end
				end
				_G.ScrollUtil.AddAcquiredFrameCallback(fObj.ScrollBox, skinElement, aObj, true)
				addTabBorder(fObj)
				if self.modBtns then
					self:skinStdButton{obj=_G.FriendsFrameAddFriendButton, fType=ftype, x1=1}
					self:skinStdButton{obj=_G.FriendsFrameSendMessageButton, fType=ftype}
					self:skinStdButton{obj=self:getChild(fObj.RIDWarning, 1), fType=ftype}
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(_G.FriendsListFrame)

			self:SecureHookScript(_G.IgnoreListFrame, "OnShow", function(fObj)
				self:skinObject("scrollbar", {obj=fObj.ScrollBar, fType=ftype})
				addTabBorder(fObj)
				if self.modBtns then
					self:skinStdButton{obj=_G.FriendsFrameIgnorePlayerButton, x1=1}
					self:skinStdButton{obj=_G.FriendsFrameUnsquelchButton}
					self:SecureHook("IgnoreList_Update", function()
						self:clrBtnBdr(_G.FriendsFrameUnsquelchButton)
					end)
				end

				self:Unhook(fObj, "OnShow")
			end)

			self:SecureHookScript(_G.WhoFrame, "OnShow", function(fObj)
				self:removeInset(_G.WhoFrameListInset)
				for i = 1, 4 do
					_G["WhoFrameColumnHeader" .. i]:DisableDrawLayer("BACKGROUND")
					if i ~= 2 then -- column2 is really a dropdown
						self:skinObject("frame", {obj=_G["WhoFrameColumnHeader" .. i], fType=ftype, ofs=0})
					end
				end
				self:moveObject{obj=_G.WhoFrameColumnHeader4, x=4}
				self:skinObject("dropdown", {obj=_G.WhoFrameDropDown, fType=ftype})
				self:removeInset(_G.WhoFrameEditBoxInset)
				self:skinObject("editbox", {obj=_G.WhoFrameEditBox, fType=ftype})
				self:adjHeight{obj=_G.WhoFrameEditBox, adj=-8}
				self:moveObject{obj=_G.WhoFrameEditBox, y=6}
				self:skinObject("scrollbar", {obj=fObj.ScrollBar, fType=ftype})
				if self.modBtns then
					self:skinStdButton{obj=_G.WhoFrameGroupInviteButton}
					self:skinStdButton{obj=_G.WhoFrameAddFriendButton}
					self:skinStdButton{obj=_G.WhoFrameWhoButton}
					self:SecureHook("WhoList_Update", function()
						self:clrBtnBdr(_G.WhoFrameGroupInviteButton)
						self:clrBtnBdr(_G.WhoFrameAddFriendButton)
					end)
				end

				self:Unhook(fObj, "OnShow")
			end)

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
			self:skinObject("scrollbar", {obj=this.ScrollBar, fType=ftype})
			self:skinObject("frame", {obj=this, fType=ftype})
			if self.modBtns then
				self:skinStdButton{obj=this.SendRequestButton}
				self:skinStdButton{obj=this.CloseButton}
				self:SecureHook(this, "Update", function(fObj)
					self:clrBtnBdr(fObj.SendRequestButton)
				end)
				self:SecureHook(this, "Reset", function(fObj)
					self:clrBtnBdr(fObj.SendRequestButton)
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
			self:skinObject("scrollbar", {obj=this.RecruitList.ScrollBar, fType=ftype})
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
			self:skinObject("frame", {obj=this.Border, fType=ftype, kfs=true, ofs=-4})
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
			self:skinObject("frame", {obj=this.Border, fType=ftype, kfs=true, ofs=-4})
			if self.modBtns then
				self:skinCloseButton{obj=this.CloseButton}
				self:skinStdButton{obj=this.GenerateOrCopyLinkButton, schk=true, sechk=true}
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.QuickJoinFrame, "OnShow", function(this)
			self:skinObject("dropdown", {obj=_G.QuickJoinFrameDropDown, fType=ftype})
			self:skinObject("scrollbar", {obj=this.ScrollBar, fType=ftype})
			self:removeMagicBtnTex(this.JoinQueueButton)
			if self.modBtns then
				self:skinStdButton{obj=this.JoinQueueButton, x2=0}
				self:SecureHook(this, "UpdateJoinButtonState", function(fOBj)
					self:clrBtnBdr(fOBj.JoinQueueButton)
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
			self:skinObject("dropdown", {obj=this.dropdown, fType=ftype})
			_G.UIDropDownMenu_SetButtonWidth(this.dropdown, 24)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, ofs=-10, y2=3})
			self:moveObject{obj=this, x=-25, y=12}

			-- Guild Ranks
			if self.modBtns then
				self:skinStdButton{obj=this.orderFrame.newButton}
				self:moveObject{obj=this.orderFrame.newButton, y=-7}
				self:skinStdButton{obj=this.orderFrame.dupButton}
				self:moveObject{obj=this.orderFrame.dupButton, y=-7}
			end

			local function skinROFrames()
				for i = 1, _G.MAX_GUILDRANKS do
					if _G["GuildControlUIRankOrderFrameRank" .. i]
					and not _G["GuildControlUIRankOrderFrameRank" .. i].sknd
					then
						_G["GuildControlUIRankOrderFrameRank" .. i].sknd = true
						aObj:skinObject("editbox", {obj=_G["GuildControlUIRankOrderFrameRank" .. i].nameBox, fType=ftype, y1=-4, y2=4})
						if aObj.modBtnBs then
							aObj:addButtonBorder{obj=_G["GuildControlUIRankOrderFrameRank" .. i].downButton, ofs=0}
							aObj:addButtonBorder{obj=_G["GuildControlUIRankOrderFrameRank" .. i].upButton, ofs=0}
							aObj:addButtonBorder{obj=_G["GuildControlUIRankOrderFrameRank" .. i].deleteButton, ofs=0}
						end
					end
				end
			end
			self:SecureHook("GuildControlUI_RankOrder_Update", function(_)
				skinROFrames()
			end)
			skinROFrames()

			self:SecureHookScript(this.rankPermFrame, "OnShow", function(fObj)
				fObj:DisableDrawLayer("BACKGROUND")
				self:skinObject("dropdown", {obj=fObj.dropdown, fType=ftype})
				_G.UIDropDownMenu_SetButtonWidth(fObj.dropdown, 24)
				self:skinObject("editbox", {obj=fObj.goldBox, fType=ftype, y1=-4, y2=4})
				if self.modChkBtns then
					for _, child in _G.ipairs{fObj:GetChildren()} do
						if child:IsObjectType("CheckButton") then
							self:skinCheckButton{obj=child}
						end
					end
				end

				self:Unhook(fObj, "OnShow")
			end)

			self:SecureHookScript(this.bankTabFrame, "OnShow", function(fObj)
				self:skinObject("dropdown", {obj=fObj.dropdown, fType=ftype})
				_G.UIDropDownMenu_SetButtonWidth(fObj.dropdown, 24)
				fObj.inset:DisableDrawLayer("BACKGROUND")
				fObj.inset:DisableDrawLayer("BORDER")
				self:skinObject("scrollbar", {obj=fObj.inset.scrollFrame.ScrollBar, fType=ftype, rpTex="artwork"})

				self:Unhook(fObj, "OnShow")
			end)
			-- hook this as buttons are created as required, done here as inside the HookScript function is too late
			self:SecureHook("GuildControlUI_BankTabPermissions_Update", function(_)
				for i = 1, _G.MAX_GUILDBANK_TABS do
					if _G["GuildControlBankTab" .. i]
					and not _G["GuildControlBankTab" .. i].sknd
					then
						_G["GuildControlBankTab" .. i].sknd = true
						_G["GuildControlBankTab" .. i]:DisableDrawLayer("BACKGROUND")
						self:skinObject("editbox", {obj=_G["GuildControlBankTab" .. i].owned.editBox, fType=ftype})
						if self.modBtns then
							self:skinStdButton{obj=_G["GuildControlBankTab" .. i].buy.button, as=true}
						end
						if self.modBtnBs then
							self:addButtonBorder{obj=_G["GuildControlBankTab" .. i].owned, relTo=_G["GuildControlBankTab" .. i].owned.tabIcon, es=10}
						end
						if self.modChkBtns then
							self:skinCheckButton{obj=_G["GuildControlBankTab" .. i].owned.viewCB}
							self:skinCheckButton{obj=_G["GuildControlBankTab" .. i].owned.depositCB}
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
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true})
			if self.modBtns then
				self:skinStdButton{obj=_G.GuildInviteFrameJoinButton}
				self:skinStdButton{obj=_G.GuildInviteFrameDeclineButton}
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzLoDFrames[ftype].InspectUI = function(self)
		if not self.prdb.InspectUI or self.initialized.InspectUI then return end
		self.initialized.InspectUI = true

		self:SecureHookScript(_G.InspectFrame, "OnShow", function(this)
			self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true})

			-- let AddOn skins know when when UI is skinned (used by oGlow skin)
			self.callbacks:Fire("InspectUI_Skinned", self)
			self.callbacks.events["InspectUI_Skinned"] = nil

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
					if btn ~= _G.InspectPaperDollItemsFrame.InspectTalents then
						self:addButtonBorder{obj=btn, ibt=true, clr="grey"}
					else
						self:skinStdButton{obj=btn, fType=ftype, sechk=true}
					end
				end
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.InspectPVPFrame, "OnShow", function(this)
			this.BG:SetTexture(nil)
			for _, slot in _G.ipairs(this.Slots) do
				slot.Border:SetTexture(nil)
				self:makeIconSquare(slot, "Texture", "gold")
			end

			self:Unhook(this, "OnShow")
		end)

		-- N.B. InspectTalentFrame now replaced by new TalentUI

		self:SecureHookScript(_G.InspectGuildFrame, "OnShow", function(this)
			_G.InspectGuildFrameBG:SetAlpha(0)
			this.Points:DisableDrawLayer("BACKGROUND")

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].LootFrames = function(self)
		if not self.prdb.LootFrames.skin or self.initialized.LootFrames then return end
		self.initialized.LootFrames = true

		self:SecureHookScript(_G.LootFrame, "OnShow", function(this)
			self:skinObject("scrollbar", {obj=this.ScrollBar, fType=ftype})
			local function skinElement(...)
				local _, element, new
				if _G.select("#", ...) == 2 then
					element, _ = ...
				elseif _G.select("#", ...) == 3 then
					element, _, new = ...
				else
					_, element, _, new = ...
				end
				if new ~= false then
					if element.Item then
						element.NameFrame:SetTexture(nil)
						element.BorderFrame:SetAlpha(0)
						element.HighlightNameFrame:SetTexture(nil)
						element.PushedNameFrame:SetTexture(nil)
						if element.QualityStripe then
							element.QualityStripe:SetTexture(nil)
						end
						if aObj.modBtnBs then
							aObj:addButtonBorder{obj=element.Item, fType=ftype, ibt=true, ofs=3, y2=-2}
						end
					end
				end
			end
			_G.ScrollUtil.AddAcquiredFrameCallback(this.ScrollBox, skinElement, aObj, true)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, rns=true})
			if self.modBtns then
				self:skinCloseButton{obj=this.ClosePanelButton, fType=ftype}
			end

			self:Unhook(this, "OnShow")
		end)

		local function skinGroupLoot(frame)
			frame:DisableDrawLayer("BACKGROUND")
			frame:DisableDrawLayer("BORDER")
			aObj:skinObject("statusbar", {obj=frame.Timer, fi=0, bg=frame.Timer.Background})
			-- hook this to show the Timer
			aObj:SecureHook(frame, "Show", function(fObj)
				fObj.Timer:SetFrameLevel(fObj:GetFrameLevel() + 1)
			end)
			frame:SetScale(aObj.prdb.LootFrames.size ~= 1 and 0.75 or 1)
			frame.IconFrame.Border:SetAlpha(0)
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=frame.IconFrame, fType=ftype, relTo=frame.IconFrame.Icon}
				-- TODO: colour the item border
			end
			-- if aObj.modBtns then
			-- 	aObj:skinCloseButton{obj=frame.PassButton}
			-- end
			if aObj.prdb.LootFrames.size ~= 3 then -- Normal or small
				aObj:skinObject("frame", {obj=frame, fType=ftype, kfs=true, x1=-3, y2=-3})
			else -- Micro
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
				aObj:skinObject("frame", {obj=frame, fType=ftype, kfs=true, x1=97, y2=8})
			end
		end
		for i = 1, 4 do
			self:SecureHookScript(_G["GroupLootFrame" .. i], "OnShow", function(this)
				skinGroupLoot(this)

				self:Unhook(this, "OnShow")
			end)
		end

		self:SecureHookScript(_G.GroupLootHistoryFrame, "OnShow", function(this)
			this.Bg:DisableDrawLayer("BACKGROUND")
			self:skinObject("dropdown", {obj=this.EncounterDropDown, fType=ftype})
			self:skinObject("scrollbar", {obj=this.ScrollBar, fType=ftype})
			local function skinHistory(...)
				local _, element, elementData
				if _G.select("#", ...) == 2 then
					element, elementData = ...
				else
					_, element, elementData = ...
				end
				if elementData.lootListID then
					element.BackgroundArtFrame.NameFrame:SetTexture(nil)
					element.BackgroundArtFrame.BorderFrame:SetAlpha(0)
					aObj:skinObject("frame", {obj=element, fType=ftype, kfs=true})
					if aObj.modBtnBs then
						aObj:addButtonBorder{obj=element.Item, fType=ftype, ibt=true}
					end
				end
			end
			_G.ScrollUtil.AddInitializedFrameCallback(this.ScrollBox, skinHistory, aObj, true)
			this.Timer.Background:SetTexture(self.sbTexture)
			this.Timer.Background:SetVertexColor(self.sbClr:GetRGBA())
			this.Timer.Fill:SetTexture(self.sbTexture)
			this.Timer.Border:SetTexture(nil)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ofs=0, y1=-1})
			if self.modBtns then
				self:skinCloseButton{obj=this.ClosePanelButton, fType=ftype}
			end

			self:Unhook(this, "OnShow")
		end)

		-- BonusRollFrame
		self:SecureHookScript(_G.BonusRollFrame, "OnShow", function(this)
			self:removeRegions(this, {1, 2, 3, 5})
			self:skinObject("statusbar", {obj=this.PromptFrame.Timer, fi=0})
			self:skinObject("frame", {obj=this, fType=ftype, bg=true})
			if self.modBtnBs then
				 self:addButtonBorder{obj=this.PromptFrame, relTo=this.PromptFrame.Icon, reParent={this.SpecIcon}}
			end

			self:Unhook(this, "OnShow")
		end)

		-- TODO: check to see if these frames are skinned by the AlertSystem skin
		-- BonusRollLootWonFrame
		-- BonusRollMoneyWonFrame

		self:SecureHookScript(_G.MasterLooterFrame, "OnShow", function(this)
			self:removeRegions(this.Item, {2, 3, 4, 5})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true})
			if self.modBtns then
				 self:skinCloseButton{obj=self:getChild(this, 3)} -- unamed close button
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=this.Item, relTo=this.Item.Icon}
				-- TODO: colour the item border
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].ObjectiveTracker = function(self)
		if not self.prdb.ObjectiveTracker.skin
		and not self.prdb.ObjectiveTracker.popups
		and not self.prdb.ObjectiveTracker.animapowers
		and not self.prdb.ObjectiveTracker.headers
		then
			return
		end
		self.initialized.ObjectiveTracker = true

		-- ObjectiveTrackerFrame BlocksFrame
		if self.prdb.ObjectiveTracker.skin then
			self:skinObject("frame", {obj=_G.ObjectiveTrackerFrame.BlocksFrame, fType=ftype, kfs=true, ofs=-1, x1=-30, x2=10})
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
							block = owningModule:GetBlock(questID .. popUpType, "ScrollFrame", "AutoQuestPopUpBlockTemplate")
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
				self:SecureHook(this.Container, "UpdateListState", function(bObj, _)
					self:clrBtnBdr(bObj)
				end)

				self:Unhook(this, "OnShow")
			end)
			self:checkShown(_G.ScenarioBlocksFrame.MawBuffsBlock)
		end

		if not self.prdb.ObjectiveTracker.headers then
			return
		end

		local skinMinBtn = _G.nop
		if self.modBtnBs then
			 function skinMinBtn(btn)
				aObj:addButtonBorder{obj=btn, es=12, ofs=1, x1=-1, clr="grey"}
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
			updTrackerModules()
			if _G.ObjectiveTrackerFrame.BlocksFrame.sf then
				_G.ObjectiveTrackerFrame.BlocksFrame.sf:SetShown(_G.ObjectiveTrackerFrame.HeaderMenu:IsShown())
			end
		end)

		self:skinObject("dropdown", {obj=_G.ObjectiveTrackerFrame.BlockDropDown, fType=ftype})

		if self.modBtnBs then
			skinMinBtn(_G.ObjectiveTrackerFrame.HeaderMenu.MinimizeButton)
			-- hook this to skin QuestObjective Block Button(s)
			local function aBB2rB(btn)
				if btn.HotKey then -- QuestItem
					aObj:addButtonBorder{obj=btn, clr="grey"}
				else -- GroupFinder
					aObj:addButtonBorder{obj=btn, ofs=-2, x1=0, clr="gold"}
				end
			end
			self:SecureHook("QuestObjectiveSetupBlockButton_AddRightButton", function(_, button, _)
				aBB2rB(button)
			end)
			-- skin existing buttons
			for _, mod in _G.pairs(_G.ObjectiveTrackerFrame.MODULES) do
				if _G.strfind(mod.friendlyName, "QUEST_TRACKER_MODULE")
				and mod.poolCollection:GetNumActive() > 0
				then
					for blk in mod.poolCollection:EnumerateActiveByTemplate("ObjectiveTrackerBlockTemplate") do
						if blk.rightButton then
							-- aObj:Debug("OTBT rightButton found")
							aBB2rB(blk.rightButton)
						end
					end
					for blk in mod.poolCollection:EnumerateActiveByTemplate("BonusObjectiveTrackerBlockTemplate") do
						if blk.rightButton then
							-- aObj:Debug("BOTBT rightButton found")
							aBB2rB(blk.rightButton)
						end
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
					aObj:skinObject("statusbar", {obj=bar.Bar, fi=0, bg=self:getRegion(bar.Bar, bar.Bar.Label and 5 or 4)})
				else
					-- BonusTrackerProgressBarTemplate bars
					bar.Bar.BarFrame:SetTexture(nil)
					bar.Bar.IconBG:SetTexture(nil)
					bar.Bar.BarFrame2:SetTexture(nil)
					bar.Bar.BarFrame3:SetTexture(nil)
					aObj:skinObject("statusbar", {obj=bar.Bar, fi=0, bg=bar.Bar.BarBG})
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
			for _, reward in _G.pairs(frame.Rewards) do
				reward.ItemBorder:SetTexture(nil)
				if aObj.modBtnBs then
					aObj:addButtonBorder{obj=reward, relTo=reward.ItemIcon}
				end
			end
		end
		self:SecureHook("BonusObjectiveTracker_AddReward", function(_, block, _, _)
			if block.module.rewardsFrame.storedData.rewards
			and #block.module.rewardsFrame.storedData.rewards > 0 then
				skinRewards(block.module.rewardsFrame)
			end
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
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ofs=0, y1=-1, x2=41, y2=5})

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.ScenarioStageBlock)

		self:SecureHookScript(_G.ScenarioChallengeModeBlock, "OnShow", function(this)
			self:skinObject("statusbar", {obj=this.StatusBar, fi=0, bg=this.TimerBG, other={this.TimerBGBack}})
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
			self:skinObject("statusbar", {obj=this.StatusBar, fi=0})
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
		_G.ObjectiveTrackerFrame.BlocksFrame.CampaignQuestHeader.Background:SetTexture(nil)
		_G.ObjectiveTrackerFrame.BlocksFrame.QuestHeader.Background:SetTexture(nil)
		_G.ObjectiveTrackerFrame.BlocksFrame.ProfessionHeader.Background:SetTexture(nil)
		_G.ObjectiveTrackerFrame.BlocksFrame.AchievementHeader.Background:SetTexture(nil)
		_G.ObjectiveTrackerFrame.BlocksFrame.ScenarioHeader.Background:SetTexture(nil)
		_G.ObjectiveTrackerFrame.BlocksFrame.UIWidgetsHeader.Background:SetTexture(nil)
		_G.ObjectiveTrackerFrame.BlocksFrame.MonthlyActivitiesHeader.Background:SetTexture(nil)
		_G.ObjectiveTrackerFrame.BlocksFrame.AdventureHeader.Background:SetTexture(nil)
		_G.BONUS_OBJECTIVE_TRACKER_MODULE.Header.Background:SetTexture(nil)
		_G.WORLD_QUEST_TRACKER_MODULE.Header.Background:SetTexture(nil)

		_G.ObjectiveTrackerBonusRewardsFrame:DisableDrawLayer("ARTWORK")
		_G.ObjectiveTrackerBonusRewardsFrame.RewardsShadow:SetTexture(nil)

		_G.ObjectiveTrackerWorldQuestRewardsFrame:DisableDrawLayer("ARTWORK")
		_G.ObjectiveTrackerWorldQuestRewardsFrame.RewardsShadow:SetTexture(nil)

		_G.ObjectiveTrackerBonusBannerFrame.BG1:SetTexture(nil)
		_G.ObjectiveTrackerBonusBannerFrame.BG2:SetTexture(nil)

	end

	local function skinNISpinner(ebObj)
		ebObj:DisableDrawLayer("BACKGROUND")
		aObj:skinObject("editbox", {obj=ebObj, fType=ftype, chginset=false, ofs=0, x1=-6})
		if aObj.modBtnBs then
			aObj:addButtonBorder{obj=ebObj.IncrementButton, ofs=0, x2=-1, sechk=true, clr="gold"}
			aObj:addButtonBorder{obj=ebObj.DecrementButton, ofs=0, x2=-1, sechk=true, clr="gold"}
		end
	end
	local function skinReagentBtn(btn, ignTex)
		if not aObj.modBtnBs then
			skinReagentBtn = _G.nop
			return
		end
		ignTex = ignTex or false
		if btn.CropFrame then
			btn.CropFrame:SetTexture(nil)
			-- show Normal/Pushed texture if CropFrame shown
			if btn.CropFrame:IsShown() then
				ignTex = true
			end
		end
		if btn.SlotBackground then
			btn.SlotBackground:SetTexture(nil)
		end
		if not btn.sbb then
			aObj:addButtonBorder{obj=btn, fType=ftype, ibt=true, relTo=btn.Icon, reParent={btn.QualityOverlay}, ignTex=ignTex}
			if btn:GetParent().Update then
				aObj:SecureHook(btn:GetParent(), "Update", function(sObj)
					aObj:clrButtonFromBorder(sObj.Button)
				end)
			end
		else
			aObj:clrButtonFromBorder(btn)
		end
	end
	local function skinHdrs(frame)
		for hdr in frame.tableBuilder:EnumerateHeaders() do
			hdr:DisableDrawLayer("BACKGROUND")
			aObj:skinObject("frame", {obj=hdr, fType=ftype, ofs=1})
		end
	end
	local function skinRecraftSlot(frame)
		frame.Background:SetAlpha(0)
		frame.InputSlot.BorderTexture:SetAlpha(0)
		skinReagentBtn(frame.InputSlot, true)
		frame.OutputSlot.ItemFrame:SetTexture(nil)
		skinReagentBtn(frame.OutputSlot)
		aObj:rawHook("OpenProfessionsItemFlyout", function(owner, parent)
			local flyout = aObj.hooks.OpenProfessionsItemFlyout(owner, parent)
			aObj:skinObject("frame", {obj=flyout, fType=ftype, kfs=true, rns=true, ofs=0})
			if aObj.modBtnBs then
				local function skinElement(...)
					local _, element, new
					if _G.select("#", ...) == 2 then
						element, _ = ...
					elseif _G.select("#", ...) == 3 then
						element, _, new = ...
					else
						_, element, _, new = ...
					end
					if new ~= false then
						-- TODO: sort out item colour issue
						if not element.sbb then
							aObj:addButtonBorder{obj=element, fType=ftype, ibt=true, relTo=element.Icon}
						else
							aObj:clrButtonFromBorder(element)
						end
					end
				end
				_G.ScrollUtil.AddAcquiredFrameCallback(flyout.ScrollBox, skinElement, aObj, true)
			end
			if aObj.modChkBtns then
				aObj:skinCheckButton{obj=flyout.HideUnownedCheckBox, fType=ftype}
			end
			aObj:Unhook("OpenProfessionsItemFlyout")
			return flyout
		end, true)
	end
	aObj.blizzLoDFrames[ftype].Professions = function(self)
		if not self.prdb.Professions or self.initialized.Professions then return end
		self.initialized.Professions = true

		local function skinSchematicForm(frame)
			skinRecraftSlot(frame.recraftSlot)
			aObj:removeRegions(frame.RecipeLevelBar, {1, 2, 3})
			aObj:skinObject("statusbar", {obj=frame.RecipeLevelBar, fi=0})
			aObj:skinObject("frame", {obj=frame.Details.QualityMeter.Border, fType=ftype, kfs=true, fb=true, clr="grey", x2=0, y2=3})
			aObj:skinObject("frame", {obj=frame.Details, fType=ftype, kfs=true, fb=true, x1=3, y1=-14, x2=-5, y2=21, clr="grey"})
			if aObj.modBtns then
				aObj:skinStdButton{obj=frame.RecipeLevelSelector, fType=ftype, ofs=0, clr="grey"}
			end
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=frame.OutputIcon, fType=ftype, cgibt=true, relTo=frame.OutputIcon.Icon}
				local function skinReagentBtns(sfFrame)
					for slot in sfFrame.reagentSlotPool:EnumerateActive() do
						skinReagentBtn(slot.Button)
					end
					for _, slot in _G.pairs(sfFrame.extraSlotFrames) do
						if slot.Button
						and (slot == sfFrame.salvageSlot
						or slot == sfFrame.enchantSlot)
						then
							skinReagentBtn(slot.Button)
						end
					end
				end
				aObj:SecureHook(frame, "Init", function(fObj, _)
					skinReagentBtns(fObj)
				end)
				skinReagentBtns(frame)
			else
				skinReagentBtn = _G.nop
			end
			if aObj.modChkBtns then
				aObj:skinCheckButton{obj=frame.TrackRecipeCheckBox, fType=ftype}
				aObj:skinCheckButton{obj=frame.AllocateBestQualityCheckBox, fType=ftype}
			end
		end
		local function skinProfFrame()
			local this = _G.ProfessionsFrame
			self:skinObject("tabs", {obj=this.TabSystem,  pool=true, fType=ftype, ignoreSize=true, track=false})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true})
			if self.modBtns then
				self:skinOtherButton{obj=this.MaximizeMinimize.MaximizeButton, font=self.fontS, text=self.nearrow}
				self:skinOtherButton{obj=this.MaximizeMinimize.MinimizeButton, font=self.fontS, text=self.swarrow}
			end

			self:SecureHookScript(this.CraftingPage, "OnShow", function(fObj)
				fObj.TutorialButton.Ring:SetTexture(nil)
				self:removeNineSlice(fObj.RecipeList.BackgroundNineSlice)
				self:skinObject("editbox", {obj=fObj.RecipeList.SearchBox, fType=ftype, si=true})
				self:skinObject("dropdown", {obj=fObj.RecipeList.ContextMenu, fType=ftype})
				self:skinObject("scrollbar", {obj=fObj.RecipeList.ScrollBar, fType=ftype})
				local function skinElement(...)
					local _, element, new
					if _G.select("#", ...) == 2 then
						element, _ = ...
					elseif _G.select("#", ...) == 3 then
						element, _, new = ...
					else
						_, element, _, new = ...
					end
					if new ~= false then
						element:DisableDrawLayer("BACKGROUND")
						if element.RankBar then
							aObj:skinObject("statusbar", {obj=element.RankBar, regions={1, 2, 3}, fi=0})
						end
					end
				end
				_G.ScrollUtil.AddAcquiredFrameCallback(fObj.RecipeList.ScrollBox, skinElement, aObj, true)
				self:skinObject("frame", {obj=fObj.RecipeList, fType=ftype, kfs=true, fb=true, ofs=4, x2=0})
				fObj.SchematicForm.Background:SetAlpha(0)
				fObj.SchematicForm.MinimalBackground:SetAlpha(0)
				self:removeNineSlice(fObj.SchematicForm.NineSlice)
				skinSchematicForm(fObj.SchematicForm)
				aObj:skinObject("frame", {obj=fObj.SchematicForm, fType=ftype, fb=true, ofs=4, x2=5, y2=0})
				fObj.RankBar.Border:SetTexture(nil)
				-- DON'T skin RankBar
				skinNISpinner(fObj.CreateMultipleInputBox)
				self:skinObject("scrollbar", {obj=fObj.GuildFrame.Container.ScrollBar, fType=ftype})
				self:skinObject("frame", {obj=fObj.GuildFrame.Container, fType=ftype, kfs=true, rns=true, fb=true})
				if self.modBtns then
					self:skinStdButton{obj=fObj.RecipeList.FilterButton, fType=ftype, ofs=0, clr="grey"}
					self:skinCloseButton{obj=fObj.RecipeList.FilterButton.ResetButton, fType=ftype, noSkin=true}
					self:skinStdButton{obj=fObj.CreateAllButton, fType=ftype, sechk=true}
					self:skinStdButton{obj=fObj.CreateButton, fType=ftype, sechk=true}
					self:skinStdButton{obj=fObj.ViewGuildCraftersButton, fType=ftype, sechk=true}
				end
				if self.modBtnBs then
					for _, btn in _G.pairs(fObj.InventorySlots) do
						btn.NormalTexture:SetTexture(nil)
						self:addButtonBorder{obj=btn, fType=ftype, ibt=true, clr="grey"}
					end
					self:addButtonBorder{obj=fObj.LinkButton, fType=ftype, clr="grey", ofs=-2, x1=0, y1=-4}
				end

				self:Unhook(fObj, "OnShow")
			end)

			self:SecureHookScript(this.CraftingPage.CraftingOutputLog, "OnShow", function(frame)
				self:keepFontStrings(frame.ScrollBox.Shadows)
				self:skinObject("scrollbar", {obj=frame.ScrollBar, fType=ftype})
				local function skinLine(...)
					local _, element
					if _G.select("#", ...) == 2 then
						element, _ = ...
					else
						_, element, _ = ...
					end
					element.ItemContainer.NameFrame:SetTexture(nil)
					element.ItemContainer.BorderFrame:SetAlpha(0)
					if aObj.modBtnBs then
						aObj:addButtonBorder{obj=element.ItemContainer.Item, fType=ftype, ibt=true}
					end
				end
				-- _G.ScrollUtil.AddInitializedFrameCallback(frame.ScrollBox, skinLine, aObj, true)
				_G.ScrollUtil.AddAcquiredFrameCallback(frame.ScrollBox, skinLine, aObj, true)
				self:skinObject("frame", {obj=frame, fType=ftype, kfs=true, rns=true})
				if self.modBtns then
					self:skinCloseButton{obj=frame.ClosePanelButton, fType=ftype}
				end

				self:Unhook(frame, "OnShow")
			end)

			self:SecureHookScript(this.CraftingPage.SchematicForm.QualityDialog, "OnShow", function(frame)
				self:skinObject("frame", {obj=frame, fType=ftype, kfs=true, rns=true})
				for i = 1, 3 do
					skinReagentBtn(frame["Container" .. i].Button)
					skinNISpinner(frame["Container" .. i].EditBox)
				end
				if self.modBtns then
					self:skinCloseButton{obj=frame.ClosePanelButton, fType=ftype}
					self:skinStdButton{obj=frame.CancelButton, fType=ftype}
					self:skinStdButton{obj=frame.AcceptButton, fType=ftype, sechk=true}
				end

				self:Unhook(frame, "OnShow")
			end)

			self:SecureHookScript(this.SpecPage, "OnShow", function(fObj)
				local function skinTabs(tabsPool)
					for tab in tabsPool:EnumerateActive() do
						aObj:keepFontStrings(tab)
						if not aObj.isTT then
							aObj:skinObject("frame", {obj=tab, fType=ftype})
						else
							aObj:skinObject("frame", {obj=tab, fType=ftype, noBdr=true, y2=0})
							if tab.isSelected then
								aObj:setActiveTab(tab.sf)
							else
								aObj:setInactiveTab(tab.sf)
							end
						end
						tab.sf.ignore = true
					end
				end
				self:SecureHook(fObj, "InitializeTabs", function(frame, _)
						skinTabs(frame.tabsPool)
				end)
				skinTabs(fObj.tabsPool)
				if self.isTT then
					local function TabSelectedCallback(_, selectedID)
						for tab in fObj.tabsPool:EnumerateActive() do
							if tab.sf then
								aObj:setInactiveTab(tab.sf)
								if tab.traitTreeID == selectedID then
									aObj:setActiveTab(tab.sf)
								end
							end
						end
					end
					_G.EventRegistry:RegisterCallback("ProfessionsSpecializations.TabSelected", TabSelectedCallback, self)
				end
				fObj.PanelFooter:DisableDrawLayer("OVERLAY")
				self:skinObject("frame", {obj=fObj.TreeView, fType=ftype, kfs=true, rns=true, fb=true, y1=4, x2=-38})
				fObj.DetailedView.UnspentPoints.CurrencyBackground:SetAlpha(0)
				self:skinObject("frame", {obj=fObj.DetailedView, fType=ftype, kfs=true, rns=true, fb=true, y1=4})
				fObj.VerticalDivider:DisableDrawLayer("OVERLAY")
				fObj.TopDivider:DisableDrawLayer("OVERLAY")
				fObj.TreePreview.PathIcon.Ring:SetTexture(nil)
				self:skinObject("frame", {obj=fObj.TreePreview, fType=ftype, fb=true, y1=5})
				if self.modBtns then
					self:skinStdButton{obj=fObj.ApplyButton, fType=ftype, sechk=true, ofs=2}
					self:skinStdButton{obj=fObj.UnlockTabButton, fType=ftype, sechk=true, ofs=2}
					self:skinStdButton{obj=fObj.ViewTreeButton, fType=ftype, ofs=2}
					self:skinStdButton{obj=fObj.BackToPreviewButton, fType=ftype, ofs=2}
					self:skinStdButton{obj=fObj.ViewPreviewButton, fType=ftype, ofs=2}
					self:skinStdButton{obj=fObj.BackToFullTreeButton, fType=ftype, ofs=2}
					self:skinStdButton{obj=fObj.DetailedView.UnlockPathButton, fType=ftype, sechk=true}
					self:skinStdButton{obj=fObj.DetailedView.SpendPointsButton, fType=ftype, sechk=true}
				end

				self:Unhook(fObj, "OnShow")
			end)

			self:SecureHookScript(this.OrdersPage, "OnShow", function(fObj)
				self:SecureHook(fObj, "SetupTable", function(frame, _)
					skinHdrs(frame)
				end)
				skinHdrs(fObj)
				self:SecureHookScript(fObj.BrowseFrame, "OnShow", function(frame)
					self:skinObject("tabs", {obj=frame, tabs=frame.orderTypeTabs, fType=ftype, ignoreSize=true, lod=self.isTT and true, offsets={y2=-4}, track=false})
					if self.isTT then
						self:SecureHook(fObj, "SetCraftingOrderType", function(frmObj, orderType)
							for _, typeTab in _G.ipairs(frmObj.BrowseFrame.orderTypeTabs) do
								if typeTab.orderType == orderType then
									self:setActiveTab(typeTab.sf)
								else
									self:setInactiveTab(typeTab.sf)
								end
							end
						end)
					end
					self:skinObject("frame", {obj=frame, fType=ftype, kfs=true, fb=true, ofs=-1, y1=-90})
					frame.RecipeList.Background:SetTexture(nil) -- TODO: Backgroud is spelt incorrectly
					self:removeNineSlice(frame.RecipeList.BackgroundNineSlice)
					self:skinObject("editbox", {obj=frame.RecipeList.SearchBox, fType=ftype, si=true})
					self:skinObject("scrollbar", {obj=frame.RecipeList.ScrollBar, fType=ftype})
					local function skinRecipeElement(...)
						local _, element, new
						if _G.select("#", ...) == 2 then
							element, _ = ...
						elseif _G.select("#", ...) == 3 then
							element, _, new = ...
						else
							_, element, _, new = ...
						end
						if new ~= false then
							element:DisableDrawLayer("BACKGROUND")
							if element.RankBar then
								aObj:skinObject("statusbar", {obj=element.RankBar, regions={1, 2, 3}, fi=0})
							end
						end
					end
					_G.ScrollUtil.AddAcquiredFrameCallback(frame.RecipeList.ScrollBox, skinRecipeElement, aObj, true)
					if self.modBtns then
						self:skinCloseButton{obj=frame.RecipeList.FilterButton.ResetButton, fType=ftype, noSkin=true}
						self:skinStdButton{obj=frame.RecipeList.FilterButton, fType=ftype, clr="grey"}
						self:skinStdButton{obj=frame.FavoritesSearchButton, fType=ftype, ofs=-2, clr="gold"}
						self:skinStdButton{obj=frame.SearchButton, fType=ftype}
						self:skinStdButton{obj=frame.BackButton, fType=ftype}
					end
					frame.OrderList.Background:SetTexture(nil)
					self:removeNineSlice(frame.OrderList.NineSlice)
					self:skinObject("scrollbar", {obj=frame.OrderList.ScrollBar, fType=ftype})
					frame.OrdersRemainingDisplay.Background:SetTexture(nil)

					self:Unhook(frame, "OnShow")
				end)
				self:checkShown(fObj.BrowseFrame)

				self:SecureHookScript(fObj.OrderView, "OnShow", function(frame)
					self:removeNineSlice(frame.OrderInfo.NineSlice)
					frame.OrderInfo.NoteBox.Background.Border:SetTexture(nil)
					self:skinObject("frame", {obj=frame.OrderInfo.NoteBox, fType=ftype, fb=true, y1=-18})
					self:skinObject("frame", {obj=frame.OrderInfo, fType=ftype, kfs=true, fb=true, x1=-5})
					self:removeNineSlice(frame.OrderDetails.NineSlice)
					skinSchematicForm(frame.OrderDetails.SchematicForm)
					self:skinObject("frame", {obj=frame.OrderDetails.FulfillmentForm.NoteEditBox, fType=ftype, kfs=true, fb=true, x1=20, y1=-18, x2=-20})
					self:skinObject("frame", {obj=frame.OrderDetails, fType=ftype, kfs=true, fb=true, x2=4})
					frame.RankBar.Border:SetTexture(nil)
					-- DON'T skin RankBar
					self:skinObject("frame", {obj=frame.DeclineOrderDialog.NoteEditBox, fType=ftype, kfs=true, fb=true, x1=30, y1=-28, x2=-30})
					self:skinObject("frame", {obj=frame.DeclineOrderDialog, fType=ftype, kfs=true})
					self:skinObject("frame", {obj=frame.CraftingOutputLog, fType=ftype, kfs=true})
					if self.modBtns then
						self:skinStdButton{obj=frame.OrderInfo.BackButton, fType=ftype}
						self:skinStdButton{obj=frame.OrderInfo.StartOrderButton, fType=ftype}
						self:skinStdButton{obj=frame.OrderInfo.DeclineOrderButton, fType=ftype}
						self:skinStdButton{obj=frame.OrderInfo.ReleaseOrderButton, fType=ftype}
						self:skinStdButton{obj=frame.DeclineOrderDialog.CancelButton, fType=ftype}
						self:skinStdButton{obj=frame.DeclineOrderDialog.ConfirmButton, fType=ftype}
						self:skinCloseButton{obj=frame.CraftingOutputLog.ClosePanelButton, fType=ftype}
					end
					if self.modBtnBs then
						self:addButtonBorder{obj=frame.OrderInfo.SocialDropdownButton, fType=ftype, clr="gold", y1=1, y2=-1}
					end

					self:Unhook(frame, "OnShow")
				end)

				self:Unhook(fObj, "OnShow")
			end)

			_G.EventRegistry:UnregisterCallback("ProfessionsFrame.Show", self)
		end
		_G.EventRegistry:RegisterCallback("ProfessionsFrame.Show", skinProfFrame, self)

	end

	aObj.blizzLoDFrames[ftype].ProfessionsCustomerOrders = function(self)
		if not self.prdb.Professions or self.initialized.ProfessionsCustomerOrders then return end

		if not _G.ProfessionsCustomerOrdersFrame then
			_G.C_Timer.After(0.1, function()
				self.blizzLoDFrames[ftype].ProfessionsCustomerOrders(self)
			end)
			return
		end

		self.initialized.ProfessionsCustomerOrders = true

		self:SecureHookScript(_G.ProfessionsCustomerOrdersFrame, "OnShow", function(this)
			self:removeInset(this.MoneyFrameInset)
			self:removeNineSlice(this.MoneyFrameBorder)
			self:skinObject("tabs", {obj=this, tabs={this.BrowseTab, this.OrdersTab}, fType=ftype, lod=self.isTT and true, track=false})
			-- TODO: identify selected Textured Tab
			-- if self.isTT then
			-- 	self:SecureHook(this, "SetDisplayMode", function(fObj, displayMode)
			-- 		if not fObj.tabsForDisplayMode[displayMode] then return end
			-- 		for i, tab in _G.ipairs(fObj.Tabs) do
			-- 			if i == fObj.tabsForDisplayMode[displayMode] then
			-- 				self:setActiveTab(tab.sf)
			-- 			else
			-- 				self:setInactiveTab(tab.sf)
			-- 			end
			-- 		end
			-- 	end)
			-- end
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, rns=true, cb=true, y2=1})

			self:SecureHookScript(this.Form, "OnShow", function(fObj)
				self:removeRegions(fObj, {1}) -- RecipeHeader
				self:skinObject("frame", {obj=fObj.LeftPanelBackground, fType=ftype, kfs=true, rns=true, fb=true, x1=-5})
				self:skinObject("frame", {obj=fObj.RightPanelBackground, fType=ftype, kfs=true, rns=true, fb=true, x2=5})
				self:skinObject("dropdown", {obj=fObj.MinimumQuality.DropDown, fType=ftype})
				self:skinObject("dropdown", {obj=fObj.OrderRecipientDropDown, fType=ftype})
				self:skinObject("editbox", {obj=fObj.OrderRecipientTarget, fType=ftype})
				self:skinObject("frame", {obj=fObj.PaymentContainer.NoteEditBox, fType=ftype, kfs=true, fb=true, clr="grey", ofs=-16})
				self:skinObject("editbox", {obj=fObj.PaymentContainer.TipMoneyInputFrame.CopperBox, fType=ftype, y2=4})
				self:skinObject("editbox", {obj=fObj.PaymentContainer.TipMoneyInputFrame.SilverBox, fType=ftype, y2=4})
				self:skinObject("editbox", {obj=fObj.PaymentContainer.TipMoneyInputFrame.GoldBox, fType=ftype, y2=4})
				self:skinObject("dropdown", {obj=fObj.PaymentContainer.DurationDropDown, fType=ftype, lrgTpl=true, x1=-1, y1=2, x2=0, y2=2})
				if self.modBtns then
					self:skinStdButton{obj=fObj.BackButton, fType=ftype}
					self:skinStdButton{obj=fObj.PaymentContainer.ListOrderButton, fType=ftype}
				end
				if self.modBtnBs then
					self:addButtonBorder{obj=fObj.OutputIcon, fType=ftype, cgibt=true, relTo=fObj.OutputIcon.Icon}
					self:addButtonBorder{obj=fObj.OrderRecipientDisplay.SocialDropdownButton, fType=ftype, ofs=1, x1=-1, clr="grey"}
					skinRecraftSlot(fObj.RecraftSlot)
					local function skinReagentBtns(sfFrame)
						for slot in sfFrame.reagentSlotPool:EnumerateActive() do
							skinReagentBtn(slot.Button)
							if aObj.modChkBtns then
								aObj:skinCheckButton{obj=slot.Checkbox, fType=ftype}
							end
						end
					end
					self:SecureHook(fObj, "UpdateReagentSlots", function(frame)
						skinReagentBtns(frame)
					end)
					skinReagentBtns(fObj)
				end
				if self.modChkBtns then
					self:skinCheckButton{obj=fObj.TrackRecipeCheckBox.Checkbox, fType=ftype}
					self:skinCheckButton{obj=fObj.AllocateBestQualityCheckBox, fType=ftype}
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:SecureHookScript(this.Form.QualityDialog, "OnShow", function(fObj)
				self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, rns=true})
				for i = 1, 3 do
					skinReagentBtn(fObj["Container" .. i].Button)
					skinNISpinner(fObj["Container" .. i].EditBox)
				end
				if self.modBtns then
					self:skinCloseButton{obj=fObj.ClosePanelButton, fType=ftype}
					self:skinStdButton{obj=fObj.CancelButton, fType=ftype}
					self:skinStdButton{obj=fObj.AcceptButton, fType=ftype, sechk=true}
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:SecureHookScript(this.Form.CurrentListings, "OnShow", function(fObj)
				skinHdrs(fObj)
				self:skinObject("scrollbar", {obj=fObj.OrderList.ScrollBar, fType=ftype})
				-- local function skinElement(...)
				-- 	local _, element, elementData, new
				-- 	if _G.select("#", ...) == 2 then
				-- 		element, elementData = ...
				-- 	elseif _G.select("#", ...) == 3 then
				-- 		element, elementData, new = ...
				-- 	else
				-- 		_, element, elementData, new = ...
				-- 	end
				-- 	if new ~= false then
				-- 	end
				-- end
				-- _G.ScrollUtil.AddAcquiredFrameCallback(fObj.OrderList.ScrollBox, skinElement, aObj, true)
				fObj.OrderList.Background:SetTexture(nil)
				self:removeNineSlice(fObj.OrderList.NineSlice)
				self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, rns=true, ofs=0})
				if self.modBtns then
					self:skinStdButton{obj=fObj.CloseButton, fType=ftype}
				end

				self:Unhook(fObj, "OnShow")
			end)

			self:SecureHookScript(this.BrowseOrders, "OnShow", function(fObj)
				self:skinObject("editbox", {obj=fObj.SearchBar.SearchBox, fType=ftype, si=true})
				self:skinObject("editbox", {obj=fObj.SearchBar.FilterButton.LevelRangeFrame.MinLevel, fType=ftype})
				self:skinObject("editbox", {obj=fObj.SearchBar.FilterButton.LevelRangeFrame.MaxLevel, fType=ftype})
				if self.modBtns then
					self:skinStdButton{obj=fObj.SearchBar.FavoritesSearchButton, fType=ftype, ofs=-2, clr="grey"}
					self:skinStdButton{obj=fObj.SearchBar.FilterButton, fType=ftype, clr="grey"}
					self:skinCloseButton{obj=fObj.SearchBar.FilterButton.ClearFiltersButton, fType=ftype, noSkin=true}
					self:skinStdButton{obj=fObj.SearchBar.SearchButton, fType=ftype}
				end

				self:SecureHook(fObj, "SetupTable", function(frame, _)
					skinHdrs(frame)
				end)
				skinHdrs(fObj)

				self:SecureHookScript(fObj.CategoryList, "OnShow", function(frame)
					frame:DisableDrawLayer("BACKGROUND")
					self:removeNineSlice(frame.NineSlice)
					self:skinObject("scrollbar", {obj=frame.ScrollBar, fType=ftype})
					local function skinCategory(...)
						local _, element
						if _G.select("#", ...) == 2 then
							element, _ = ...
						else
							_, element, _ = ...
						end
						if element.isSpacer then
							for _, region in ipairs(element.spacerRegions) do
								region:SetShown(false)
							end
							return
						end
						aObj:keepRegions(element, {3, 4, 6}) -- N.B. region 3 is highlight, 4 is selected, 6 is text
						if element.categoryInfo then
							aObj.modUIBtns:skinStdButton{obj=element, fType=ftype, ignoreHLTex=true}
							element.sb:ClearAllPoints()
							if element.categoryInfo.type == _G.Enum.CraftingOrderCustomerCategoryType.Primary then
								element.sb:SetPoint("TOPLEFT", element, "TOPLEFT", -2, 2)
								element.sb:SetPoint("BOTTOMRIGHT", element, "BOTTOMRIGHT", -4, -1)
							elseif element.categoryInfo.type == _G.Enum.CraftingOrderCustomerCategoryType.Secondary  then
								element.sb:SetPoint("TOPLEFT", element, "TOPLEFT", 10, 1)
								element.sb:SetPoint("BOTTOMRIGHT", element, "BOTTOMRIGHT", -4, -1)
							end
							element.sb:SetShown(element.categoryInfo.type ~= _G.Enum.CraftingOrderCustomerCategoryType.Tertiary)
						else -- Start Recrafting Order button
							aObj.modUIBtns:skinStdButton{obj=element, fType=ftype, ignoreHLTex=true, ofs=2, x2=-4}
						end
					end
					_G.ScrollUtil.AddInitializedFrameCallback(frame.ScrollBox, skinCategory, aObj, true)

					self:Unhook(frame, "OnShow")
				end)
				self:checkShown(fObj.CategoryList)

				self:SecureHookScript(fObj.RecipeList, "OnShow", function(frame)
					frame.Background:SetTexture(nil)
					self:removeNineSlice(frame.NineSlice)
					self:skinObject("scrollbar", {obj=frame.ScrollBar, fType=ftype})
					-- local function skinElement(...)
					-- 	local _, element, elementData, new
					-- 	if _G.select("#", ...) == 2 then
					-- 		element, elementData = ...
					-- 	elseif _G.select("#", ...) == 3 then
					-- 		element, elementData, new = ...
					-- 	else
					-- 		_, element, elementData, new = ...
					-- 	end
					-- 	if new ~= false then
					-- 	end
					-- end
					-- _G.ScrollUtil.AddAcquiredFrameCallback(frame.ScrollBox, skinElement, aObj, true)

					self:Unhook(frame, "OnShow")
				end)
				self:checkShown(fObj.RecipeList)

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.BrowseOrders)

			self:SecureHookScript(this.MyOrdersPage, "OnShow", function(fObj)
				fObj.OrderList.Background:SetTexture(nil)
				skinHdrs(fObj)
				self:removeNineSlice(fObj.OrderList.NineSlice)
				self:skinObject("scrollbar", {obj=fObj.OrderList.ScrollBar, fType=ftype})
				-- local function skinOrderElement(...)
				-- 	local _, element, elementData, new
				-- 	if _G.select("#", ...) == 2 then
				-- 		element, elementData = ...
				-- 	elseif _G.select("#", ...) == 3 then
				-- 		element, elementData, new = ...
				-- 	else
				-- 		_, element, elementData, new = ...
				-- 	end
				-- 	if new ~= false then
				-- 	end
				-- end
				-- _G.ScrollUtil.AddAcquiredFrameCallback(fObj.OrderList.ScrollBox, skinOrderElement, aObj, true)
				if self.modBtnBs then
					self:addButtonBorder{obj=fObj.RefreshButton, ofs=-2, x1=1, clr="gold", sechk=true}
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.MyOrdersPage)

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.ProfessionsCustomerOrdersFrame)

	end

	aObj.blizzFrames[ftype].PVPHonorSystem = function(self)
		if not self.prdb.PVPUI or self.initialized.PVPHonorSystem then return end
		self.initialized.PVPHonorSystem = true

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
				self:changeTex(this["CategoryButton" .. i]:GetHighlightTexture())
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
						self:changeTex(this["CategoryButton" .. i].Background, true)
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
				self:SecureHook(hld, "Update", function(fObj)
					if fObj.NextRewardLevel.RewardIcon:IsDesaturated() then
						self:clrBtnBdr(fObj.NextRewardLevel, "disabled")
					else
						self:clrBtnBdr(fObj.NextRewardLevel, "white", 0.75)
					end

				end)
			end
			this.HonorInset.RatedPanel.WeeklyChest.FlairTexture:SetTexture(nil)
			local srf =this.HonorInset.RatedPanel.SeasonRewardFrame
			srf.Ring:SetTexture(nil)
			if self.modBtnBs then
				self:addButtonBorder{obj=srf, relTo=srf.Icon, clr="white", ca=0.75}
				self:SecureHook(srf, "Update", function(fObj)
					if fObj.Icon:IsDesaturated() then
						self:clrBtnBdr(fObj, "disabled")
					else
						self:clrBtnBdr(fObj, "white", 0.75)
					end
				end)
			end
			self:SecureHookScript(this.NewSeasonPopup, "OnShow", function(fObj)
				fObj.NewSeason:SetTextColor(self.HT:GetRGB())
				fObj.SeasonRewardText:SetTextColor(self.BT:GetRGB())
				fObj.SeasonDescriptionHeader:SetTextColor(self.BT:GetRGB())
				for _, line in _G.pairs(fObj.SeasonDescriptions) do
					line:SetTextColor(self.BT:GetRGB())
				end
				fObj.SeasonRewardFrame.Ring:SetTexture(nil)
				self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, ofs=-13})
				if self.modBtns then
					self:skinStdButton{obj=fObj.Leave}
				end

				self:Unhook(fObj, "OnShow")
			end)

			self:Unhook(this, "OnShow")
		end)

		local function skinCommon(frame)
			aObj:removeInset(frame.Inset)
			frame.ConquestBar:DisableDrawLayer("BORDER")
			aObj:skinObject("statusbar", {obj=frame.ConquestBar, fi=0, bg=frame.ConquestBar.Background})
			local btn = frame.ConquestBar.Reward
			btn.Ring:SetTexture(nil)
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=btn, relTo=btn.Icon, reParent={btn.CheckMark}, clr="silver"}
			end
			if aObj.modChkBtns then
				aObj:skinCheckButton{obj=frame.HealerIcon.checkButton}
				aObj:skinCheckButton{obj=frame.TankIcon.checkButton}
				aObj:skinCheckButton{obj=frame.DPSIcon.checkButton}
			end
		end
		self:SecureHookScript(_G.HonorFrame, "OnShow", function(this)
			skinCommon(this)
			self:skinObject("dropdown", {obj=_G.HonorFrameTypeDropDown, fType=ftype})
			self:skinObject("scrollbar", {obj=this.SpecificScrollBar, fType=ftype})
			local function skinElement(...)
				local _, element, new
				if _G.select("#", ...) == 2 then
					element, _ = ...
				elseif _G.select("#", ...) == 3 then
					element, _, new = ...
				else
					_, element, _, new = ...
				end
				if new ~= false then
					element.Bg:SetTexture(nil)
					element.Border:SetTexture(nil)
					if aObj.modBtnBs then
						aObj:addButtonBorder{obj=element, fType=ftype, relTo=element.Icon, clr="grey"}
					end
				end
			end
			_G.ScrollUtil.AddAcquiredFrameCallback(this.SpecificScrollBox, skinElement, aObj, true)
			local btn
			for _, bName in _G.pairs{"RandomBG", "RandomEpicBG", "Arena1", "Brawl", "SpecialEvent"} do
				if bName == "SpecialEvent" then
					btn = this.BonusFrame["BrawlButton2"]
				else
					btn = this.BonusFrame[bName .. "Button"]
				end
				btn.NormalTexture:SetTexture(nil)
				btn:GetPushedTexture():SetTexture(nil)
				btn.Reward.Border:SetTexture(nil)
				btn.Reward.EnlistmentBonus:DisableDrawLayer("ARTWORK") -- ring texture
				if self.modBtnBs then
					self:addButtonBorder{obj=btn.Reward, relTo=btn.Reward.Icon, reParent={btn.Reward.EnlistmentBonus}}
				end
			end
			if self.modBtnBs then
				self:SecureHook("HonorFrameBonusFrame_Update", function()
					self:clrBtnBdr(_G.HonorFrame.BonusFrame.RandomBGButton.Reward, "gold")
					self:clrBtnBdr(_G.HonorFrame.BonusFrame.RandomEpicBGButton.Reward, "gold")
					self:clrBtnBdr(_G.HonorFrame.BonusFrame.Arena1Button.Reward, "gold")
					self:clrBtnBdr(_G.HonorFrame.BonusFrame.BrawlButton.Reward, "gold")
					self:clrBtnBdr(_G.HonorFrame.BonusFrame.BrawlButton2.Reward, "gold")
				end)
			end
			this.BonusFrame:DisableDrawLayer("BACKGROUND")
			this.BonusFrame.ShadowOverlay:DisableDrawLayer("OVERLAY")
			self:removeMagicBtnTex(this.QueueButton)
			if self.modBtns then
				self:skinStdButton{obj=this.QueueButton, schk=true}
			end

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.HonorFrame)

		self:SecureHookScript(_G.ConquestFrame, "OnShow", function(this)
			skinCommon(this)
			this:DisableDrawLayer("BACKGROUND")
			this:DisableDrawLayer("BORDER")
			for _, btn in _G.pairs(_G.CONQUEST_BUTTONS) do
				btn.NormalTexture:SetTexture(nil)
				btn.Reward.Border:SetTexture(nil)
				if self.modBtnBs then
					self:addButtonBorder{obj=btn.Reward, relTo=btn.Reward.Icon, reParent={btn.Reward.EnlistmentBonus}}
				end
			end
			if self.modBtnBs then
				self:SecureHook("ConquestFrame_Update", function(_)
					for _, btn in _G.pairs(_G.CONQUEST_BUTTONS) do
						self:clrBtnBdr(btn.Reward, "gold")
					end
				end)
			end
			this.ShadowOverlay:DisableDrawLayer("OVERLAY")
			self:skinObject("glowbox", {obj=this.NoSeason, fType=ftype})
			self:skinObject("glowbox", {obj=this.Disabled, fType=ftype})
			self:skinObject("dropdown", {obj=this.ArenaInviteMenu, fType=ftype})
			self:removeMagicBtnTex(this.JoinButton)
			if self.modBtns then
				 self:skinStdButton{obj=this.JoinButton}
			end

			self:Unhook(this, "OnShow")
		end)

		_G.C_Timer.After(0.1, function()
			self:add2Table(self.ttList, _G.ConquestTooltip)
		end)

	end

	aObj.blizzFrames[ftype].SpellBookFrame = function(self)
		if not self.prdb.SpellBookFrame or self.initialized.SpellBookFrame then return end
		self.initialized.SpellBookFrame = true

		self:SecureHookScript(_G.SpellBookFrame, "OnShow", function(this)
			this.MainHelpButton.Ring:SetTexture(nil)
			self:moveObject{obj=this.MainHelpButton, y=-4}
			this.numTabs = 5
			self:skinObject("tabs", {obj=this, prefix=this:GetName(), suffix="Button", fType=ftype, track=false})
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
				end
				-- hook to handle tabs
				self:SecureHook("ToggleSpellBook", function(bookType)
					setTab(bookType)
				end)
				-- set correct tab
				setTab(this.bookType)
			end
			-- Spellbook Panel
			local spellString, subSpellString
			local function updBtn(btn)
				-- handle in combat
				if _G.InCombatLockdown() then
				    aObj:add2Table(aObj.oocTab, {updBtn, {btn}})
				    return
				end
				spellString, subSpellString = _G[btn:GetName() .. "SpellName"], _G[btn:GetName() .. "SubSpellName"]
				if _G[btn:GetName() .. "IconTexture"]:IsDesaturated() then -- player level too low, see Trainer, or offSpec
					spellString:SetTextColor(_G.DISABLED_FONT_COLOR:GetRGB())
					subSpellString:SetTextColor(_G.DISABLED_FONT_COLOR:GetRGB())
					btn.RequiredLevelString:SetTextColor(_G.DISABLED_FONT_COLOR:GetRGB())
					btn.SeeTrainerString:SetTextColor(_G.DISABLED_FONT_COLOR:GetRGB())
				else
					spellString:SetTextColor(aObj.HT:GetRGB())
					subSpellString:SetTextColor(aObj.BT:GetRGB())
				end
				 -- allow for not skinned during combat
				if btn.sbb then
					if btn:IsEnabled() then
						btn.sbb:Show()
					else
						btn.sbb:Hide()
						return
					end
					if _G[btn:GetName() .. "IconTexture"]:IsDesaturated() then -- player level too low, see Trainer, or offSpec
						aObj:clrBtnBdr(btn, "disabled")
					else
						aObj:clrBtnBdr(btn)
					end
				end
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
					self:addButtonBorder{obj=btn, sft=true, reParent={btn.FlyoutArrow, _G["SpellButton" .. i .. "AutoCastable"]}}
					btn.sbb:SetShown(btn:IsEnabled())
				end
				updBtn(btn)
				self:SecureHook(btn, "UpdateButton", function(bObj)
					updBtn(bObj)
				end)
			end
			-- Tabs (side)
			local tBtn
			for i = 1, _G.MAX_SKILLLINE_TABS do
				tBtn = _G["SpellBookSkillLineTab" .. i]
				tBtn:DisableDrawLayer("BACKGROUND")
				if self.modBtnBs then
					self:addButtonBorder{obj=tBtn, clr=tBtn.isOffSpec and "grey"}
				end
				if i == 1 then
					self:moveObject{obj=tBtn, x=2}
				end
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
					local pBtn
					for j = 1, 2 do
						pBtn = obj["SpellButton" .. j]
						pBtn:DisableDrawLayer("BACKGROUND")
						pBtn.subSpellString:SetTextColor(aObj.BT:GetRGB())
						if aObj.modBtnBs then
							aObj:addButtonBorder{obj=pBtn, sft=true}
						end
					end
					aObj:removeRegions(obj.statusBar, {2, 3, 4, 5, 6})
					aObj:skinObject("statusbar", {obj=obj.statusBar, fi=0})
					obj.statusBar:SetStatusBarColor(0, 1, 0, 1)
					obj.statusBar:SetHeight(12)
					obj.statusBar.rankText:SetPoint("CENTER", 0, 0)
					aObj:moveObject{obj=obj.statusBar, x=-12}
				end
			end
			-- Primary professions
			skinProf("Primary", 2)
			-- Secondary professions
			skinProf("Secondary", 3)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true, x2=2, y2=-3})
			if self.modBtnBs then
				self:addButtonBorder{obj=_G.SpellBookPrevPageButton, ofs=-2, y1=-3, x2=-3}
				self:addButtonBorder{obj=_G.SpellBookNextPageButton, ofs=-2, y1=-3, x2=-3}
				self:clrPNBtns("SpellBook")
				self:SecureHook("SpellBookFrame_UpdatePages", function()
					self:clrPNBtns("SpellBook")
				end)
				self:SecureHook("SpellBookFrame_UpdateSkillLineTabs", function()
					for i = 1, _G.MAX_SKILLLINE_TABS do
						self:clrBtnBdr(_G["SpellBookSkillLineTab" .. i], _G["SpellBookSkillLineTab" .. i].isOffSpec and "grey")
					end
				end)
				self:SecureHook("SpellBook_UpdateProfTab", function()
					local prof1, prof2, _, _, _ = _G.GetProfessions()
					self:clrBtnBdr(_G.PrimaryProfession1, not prof1 and "disabled")
					self:clrBtnBdr(_G.PrimaryProfession2, not prof2 and "disabled")
				end)
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].WardrobeOutfits = function(self)
		if not self.prdb.Collections or self.initialized.WardrobeOutfits then return end
		self.initialized.WardrobeOutfits = true

		self:SecureHookScript(_G.WardrobeOutfitFrame, "OnShow", function(this)
			self:removeNineSlice(this.Border)
			self:skinObject("frame", {obj=this, fType=ftype})

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.WardrobeOutfitEditFrame, "OnShow", function(this)
			self:removeNineSlice(this.Border)
			self:skinObject("editbox", {obj=this.EditBox, fType=ftype})
			if self.modBtns then
				self:skinStdButton{obj=this.AcceptButton}
				self:skinStdButton{obj=this.CancelButton}
				self:skinStdButton{obj=this.DeleteButton}
			end
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true})

			self:Unhook(this, "OnShow")
		end)

	end

end

aObj.SetupRetail_PlayerFramesOptions = function(self)

	local optTab = {
		["Archaeology UI"]       = true,
		["Artifact UI"]          = true,
		["Azerite Essence UI"]   = true,
		["Azerite UI"]           = true,
		["Character Customize"]  = {suff = "Frame"},
		["Class Talent UI"]      = true,
		["Encounter Journal"]    = {desc = "Adventure Guide"},
		["Equipment Flyout"]     = true,
		["Guild Control UI"]     = true,
		["Guild Invite"]         = {suff = "Frame"},
		["Guild UI"]             = true,
		["Looking For Guild UI"] = {desc = "Looking for Guild UI"},
		["Professions"]          = true,
		["PVP UI"]               = {desc = "PVP Frame"},
	}
	self:setupFramesOptions(optTab, "Player")
	_G.wipe(optTab)

	local db = self.db.profile
	local dflts = self.db.defaults.profile

	dflts.ObjectiveTracker = {skin = false, popups = true, headers=true, animapowers=true}
	if db.ObjectiveTracker == nil then
		db.ObjectiveTracker = {skin = false, popups = true, headers=true, animapowers=true}
	else
		if db.ObjectiveTracker.popups == nil then
			db.ObjectiveTracker.popups = true
		end
		if db.ObjectiveTracker.headers == nil then
			db.ObjectiveTracker.headers = true
		end
		if db.ObjectiveTracker.animapowers == nil then
			db.ObjectiveTracker.animapowers = true
		end
	end
	self.optTables["Player Frames"].args.ObjectiveTracker = {
		type = "group",
		order = -1,
		inline = true,
		name = self.L["ObjectiveTracker Frame"],
		get = function(info) return db.ObjectiveTracker[info[#info]] end,
		set = function(info, value) db.ObjectiveTracker[info[#info]] = value end,
		args = {
			skin = {
				type = "toggle",
				order = 1,
				name = self.L["Skin Frame"],
				desc = _G.strjoin(" ", self.L["Toggle the skin of the"], self.L["ObjectiveTracker Frame"]),
			},
			popups = {
				type = "toggle",
				order = 2,
				name = self.L["AutoPopUp Frames"],
				desc = _G.strjoin(" ", self.L["Toggle the skin of the"], self.L["AutoPopUp Frames"]),
			},
			headers = {
				type = "toggle",
				order = 3,
				name = self.L["Header Blocks"],
				desc = _G.strjoin(" ", self.L["Toggle the skin of the"], self.L["Header Blocks"]),
			},
			animapowers = {
				type = "toggle",
				order = 4,
				name = self.L["Anima Powers"],
				desc = _G.strjoin(" ", self.L["Toggle the skin of the"], self.L["Anima Powers"]),
			},
		},
	}

end
