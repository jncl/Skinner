local _, aObj = ...

local _G = _G

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
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, y1=7, x2=0, y2=0})

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

			self:SecureHookScript(_G.AchievementFrameSummary, "OnShow", function(fObj)
				fObj:DisableDrawLayer("BACKGROUND")
				self:skinObject("frame", {obj=self:getChild(fObj, 1), fType=ftype, kfs=true, fb=true, ofs=0, x1=2, y2=-2})
				_G.AchievementFrameSummaryAchievementsHeaderHeader:SetTexture(nil)
				self:SecureHook("AchievementFrameSummary_UpdateAchievements", function(...)
					for i = 1, _G.ACHIEVEMENTUI_MAX_SUMMARY_ACHIEVEMENTS do
						skinAchievement(_G.AchievementFrameSummaryAchievements.buttons[i])
					end
					if _G.select("#", ...) == 0 then
						_G.AchievementFrameSummaryAchievementsEmptyText:Hide()
					end
				end)
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
			self:skinObject("statusbar", {obj=this.artifactPage.solveFrame.statusbar, fi=0})
			this.artifactPage.solveFrame.statusBar:SetStatusBarColor(0.75, 0.45, 0, 0.7)
			this.artifactPage.historyTitle:SetTextColor(self.HT:GetRGB())
			this.artifactPage.historyScroll.child.text:SetTextColor(self.BT:GetRGB())
			self:skinObject("slider", {obj=this.artifactPage.historyScroll.ScrollBar, fType=ftype})

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
			self:skinObject("slider", {obj=this.EssenceList.ScrollBar, fType=ftype})
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
				self:SecureHook(this.EssenceList, "UpdateMouseOverTooltip", function(fObj)
					clrBB(fObj)
				end)
			end
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
				for buff in frame.auraPool:EnumerateActiveByTemplate(frame.auraTemplate) do
					skinBuffBtn(buff)
				end
				for buff in frame.auraPool:EnumerateActiveByTemplate(frame.exampleAuraTemplate) do
					skinBuffBtn(buff)
				end
				if frame == _G.BuffFrame then
					for buff in frame.auraPool:EnumerateActiveByTemplate("TempEnchantButtonTemplate") do
						skinBuffBtn(buff)
					end
				else
					for buff in frame.auraPool:EnumerateActiveByTemplate("DeadlyDebuffButtonTemplate") do
						skinBuffBtn(buff)
					end
				end
			end
			for _, frame in _G.pairs{_G.BuffFrame, _G.DebuffFrame} do
				skinBuffs(frame)
				self:SecureHook(frame, "UpdateAuraButtons", function(this)
					skinBuffs(this)
				end)
			end
		end

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
					self:skinStdButton{obj=fObj.SaveSet}
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

		if not self.isRtl then
			self:SecureHookScript(_G.GearManagerDialogPopup, "OnShow", function(this)
				self:adjHeight{obj=_G.GearManagerDialogPopupScrollFrame, adj=20}
				self:skinObject("slider", {obj=_G.GearManagerDialogPopupScrollFrame.ScrollBar, fType=ftype, rpTex="background"})
				self:removeRegions(this.BorderBox, {1, 2, 3, 4, 5, 6, 7, 8})
				self:adjHeight{obj=this, adj=20}
				for _, btn in _G.pairs(this.buttons) do
					btn:DisableDrawLayer("BACKGROUND")
					if self.modBtnBs then
						self:addButtonBorder{obj=btn}
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
		else
			self:SecureHookScript(_G.GearManagerPopupFrame, "OnShow", function(this)
				self:skinIconSelector(this)

				self:Unhook(this, "OnShow")
			end)
		end

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
			self:skinObject("frame", {obj=_G.ReputationDetailFrame, fType=ftype, kfs=true, ofs=-6})
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
			self:skinObject("frame", {obj=_G.TokenFramePopup, fType=ftype, kfs=true, cb=true, ofs=-6, x1=0})
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
				for btn in fObj.pools:GetPool("CharCustomizeShapeshiftFormButtonTemplate"):EnumerateActive() do
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
			this.PortraitOverlay.Portrait:SetAlpha(0)
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
						-- .SpellButtonPool
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
				end

				self:SecureHookScript(fObj.SearchPreviewContainer, "OnShow", function(frame)
					self:skinObject("scrollbar", {obj=frame.ScrollBar, fType=ftype})
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
					self:skinObject("scrollbar", {obj=frame.ScrollBar, fType=ftype})
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
								aObj:Debug("eData: [%s, %s, %s]", elementData.selectedHere, elementData.selectedOther)
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

	aObj.blizzLoDFrames[ftype].Collections = function(self)
		if not self.prdb.Collections or self.initialized.Collections then return end
		self.initialized.Collections = true

		self:SecureHookScript(_G.CollectionsJournal, "OnShow", function(this)
			self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true, selectedTab=this.selectedTab})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, rns=true, cb=true, x2=3, y2=-2})

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.MountJournal, "OnShow", function(this)
			self:removeInset(this.LeftInset)
			self:removeInset(this.BottomLeftInset)
			self:removeRegions(this.SlotButton, {1, 3})
			self:removeInset(this.RightInset)
			self:skinObject("editbox", {obj=this.searchBox, fType=ftype, si=true})
			self:removeInset(this.MountCount)
			self:keepFontStrings(this.MountDisplay)
			self:keepFontStrings(this.MountDisplay.ShadowOverlay)
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
					element:DisableDrawLayer("BACKGROUND")
					if aObj.modBtnBs then
						aObj:addButtonBorder{obj=element, fType=ftype, relTo=element.icon, reParent={element.favorite}}
					end
				end
				if aObj.modBtnBs then
					_G.C_Timer.After(0.05, function()
						element.sbb:SetBackdropBorderColor(element.icon:GetVertexColor())
					end)
				end
			end
			_G.ScrollUtil.AddAcquiredFrameCallback(this.ScrollBox, skinElement, aObj, true)
			self:removeMagicBtnTex(this.MountButton)
			if self.modBtns then
				self:skinStdButton{obj=this.BottomLeftInset.SuppressedMountEquipmentButton, fType=ftype}
				self:skinStdButton{obj=_G.MountJournalFilterButton, fType=ftype, clr="grey"}
				self:skinCloseButton{obj=_G.MountJournalFilterButton.ResetButton, fType=ftype, noSkin=true}
				self:skinStdButton{obj=this.MountButton, fType=ftype, sechk=true}
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=this.SlotButton, relTo=this.SlotButton.ItemIcon, reParent={this.SlotButton.SlotBorder, this.SlotButton.SlotBorderOpen}, clr="grey", ca=0.85}
				self:addButtonBorder{obj=this.SummonRandomFavoriteButton, ofs=3}
				self:addButtonBorder{obj=this.MountDisplay.InfoButton, relTo=this.MountDisplay.InfoButton.Icon, clr="white"}
				self:addButtonBorder{obj=this.MountDisplay.ModelScene.RotateLeftButton, ofs=-3, clr="grey"}
				self:addButtonBorder{obj=this.MountDisplay.ModelScene.RotateRightButton, ofs=-3, clr="grey"}
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
			self:removeInset(this.LeftInset)
			self:removeInset(this.PetCardInset)
			self:removeInset(this.RightInset)
			self:skinObject("editbox", {obj=this.searchBox, fType=ftype, si=true})
			if self.modBtns then
				self:skinStdButton{obj=_G.PetJournalFilterButton, fType=ftype, clr="grey"}
				self:skinCloseButton{obj=_G.PetJournalFilterButton.ResetButton, fType=ftype, noSkin=true}
			end
			-- PetList
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
					aObj:removeRegions(element, {1, 4}) -- background, iconBorder
					aObj:changeTandC(element.dragButton.levelBG)
					if aObj.modBtnBs then
						aObj:addButtonBorder{obj=element, relTo=element.icon, reParent={element.dragButton.levelBG, element.dragButton.level, element.dragButton.favorite}}
					end
				end
				if aObj.modBtnBs then
					_G.C_Timer.After(0.05, function()
						aObj:clrButtonFromBorder(element)
					end)
				end
			end
			_G.ScrollUtil.AddAcquiredFrameCallback(this.ScrollBox, skinElement, aObj, true)
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
				self:skinObject("statusbar", {obj=lop.healthFrame.healthBar, fi=0})
				self:skinObject("statusbar", {obj=lop.xpBar, regions={2, 3, 4, 5, 6, 7, 8, 9, 10, 11}, fi=0})
				self:skinObject("frame", {obj=lop, fType=ftype, fb=true, x1=-4, y1=0, y2=-4})
				for j = 1, 3 do
					self:removeRegions(lop["spell" .. j], {1, 3}) -- background, blackcover
					if self.modBtnBs then
						self:addButtonBorder{obj=lop["spell" .. j], relTo=lop["spell" .. j].icon, reParent={lop["spell" .. j].FlyoutArrow}, clr="disabled"}
					end
				end
			end
			-- PetCard
			local pc = this.PetCard
			self:changeTandC(pc.PetInfo.levelBG)
			pc.PetInfo.qualityBorder:SetAlpha(0)
			if self.modBtnBs then
				self:addButtonBorder{obj=pc.PetInfo, relTo=pc.PetInfo.icon, reParent={pc.PetInfo.levelBG, pc.PetInfo.level, pc.PetInfo.favorite}}
			end
			self:skinObject("statusbar", {obj=pc.HealthFrame.healthBar, regions={1, 2, 3}, fi=0})
			self:skinObject("statusbar", {obj=pc.xpBar, regions={2, 3, 4, 5, 6, 7, 8, 9, 10, 11}, fi=0})
			self:keepFontStrings(pc)
			self:skinObject("frame", {obj=pc, fType=ftype, fb=true, ofs=4})
			for i = 1, 6 do
				pc["spell" .. i].BlackCover:SetAlpha(0) -- N.B. texture is changed in code
				if self.modBtnBs then
					self:addButtonBorder{obj=pc["spell" .. i], relTo=pc["spell" .. i].icon, clr="grey", ca=0.85}
				end
			end
			if self.modBtnBs then
				self:SecureHook("PetJournal_UpdatePetLoadOut", function()
					for i = 1, 3 do
						self:clrButtonFromBorder(_G.PetJournal.Loadout["Pet" .. i], "qualityBorder")
					end
				end)
				self:SecureHook("PetJournal_UpdatePetCard", function(fObj)
					self:clrButtonFromBorder(fObj.PetInfo, "qualityBorder")
				end)
			end
			self:removeMagicBtnTex(this.FindBattleButton)
			self:removeMagicBtnTex(this.SummonButton)
			self:removeRegions(this.AchievementStatus, {1, 2})
			if self.modBtns then
				self:skinStdButton{obj=this.FindBattleButton}
				self:skinStdButton{obj=this.SummonButton, sechk=true}
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=this.HealPetButton, sft=true, clr="grey", ca=1}
				self:addButtonBorder{obj=this.SummonRandomFavoritePetButton, ofs=3, clr="grey", ca=1}
			end

			self:Unhook(this, "OnShow")
		end)

		local function skinTTip(tip)
			tip.Delimiter1:SetTexture(nil)
			tip.Delimiter2:SetTexture(nil)
			tip:DisableDrawLayer("BACKGROUND")
			aObj:skinObject("frame", {obj=tip, fType=ftype, ofs=0})
		end
		skinTTip(_G.PetJournalPrimaryAbilityTooltip)
		skinTTip(_G.PetJournalSecondaryAbilityTooltip)

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
			self:skinObject("statusbar", {obj=this.progressBar, fi=0})
			self:skinObject("editbox", {obj=this.searchBox, fType=ftype, si=true})
			if self.modBtns then
				self:skinStdButton{obj=_G.ToyBoxFilterButton, ftype=ftype, clr="grey"}
				self:skinCloseButton{obj=_G.ToyBoxFilterButton.ResetButton, fType=ftype, noSkin=true}
			end
			self:removeInset(this.iconsFrame)
			self:keepFontStrings(this.iconsFrame)
			for i = 1, 18 do
				this.iconsFrame["spellButton" .. i].slotFrameCollected:SetTexture(nil)
				this.iconsFrame["spellButton" .. i].slotFrameUncollected:SetTexture(nil)
				if self.modBtnBs then
					self:addButtonBorder{obj=this.iconsFrame["spellButton" .. i], sft=true, ofs=0}
				end
			end
			if self.modBtnBs then
				skinPageBtns(this)
				self:SecureHook("ToySpellButton_UpdateButton", function(fObj)
					skinCollectionBtn(fObj)
				end)
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.HeirloomsJournal, "OnShow", function(this)
			self:skinObject("statusbar", {obj=this.progressBar, fi=0})
			self:removeRegions(this.progressBar, {2, 3})
			self:skinObject("editbox", {obj=this.SearchBox, fType=ftype, si=true})
			if self.modBtns then
				self:skinStdButton{obj=this.FilterButton, ftype=ftype, clr="grey"}
				self:skinCloseButton{obj=this.FilterButton.ResetButton, fType=ftype, noSkin=true}
			end
			self:skinObject("dropdown", {obj=this.classDropDown, fType=ftype})
			self:removeInset(this.iconsFrame)
			self:keepFontStrings(this.iconsFrame)
			-- 18 icons per page ?
			self:SecureHook(this, "LayoutCurrentPage", function(fObj)
				for _, frame in _G.pairs(fObj.heirloomHeaderFrames) do
					frame:DisableDrawLayer("BACKGROUND")
					frame.text:SetTextColor(self.HT:GetRGB())
				end
				for _, frame in _G.pairs(fObj.heirloomEntryFrames) do
					frame.slotFrameCollected:SetTexture(nil)
					frame.slotFrameUncollected:SetTexture(nil)
					-- ignore btn.levelBackground as its textures is changed when upgraded
					if self.modBtnBs then
						self:addButtonBorder{obj=frame, sft=true, ofs=0, reParent={frame.new, frame.levelBackground, frame.level}}
						skinCollectionBtn(frame)
					end
				end
			end)
			if self.modBtnBs then
				skinPageBtns(this)
				self:SecureHook(this, "UpdateButton", function(_, button)
					skinCollectionBtn(button)
					if button.levelBackground:GetAtlas() == "collections-levelplate-black" then
						self:changeTandC(button.levelBackground)
					end
				end)
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.WardrobeCollectionFrame, "OnShow", function(this)
			self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true, upwards=true, offsets={x1=2, y1=-4, x2=-2, y2=-4}})
			self:skinObject("editbox", {obj=this.searchBox, fType=ftype, si=true})
			_G.RaiseFrameLevelByTwo(this.searchBox) -- raise above SetsCollectionFrame when displayed on it
			self:skinObject("statusbar", {obj=this.progressBar, fi=0})
			self:removeRegions(this.progressBar, {2, 3})
			if self.modBtns then
				self:skinStdButton{obj=this.FilterButton, ftype=ftype, clr="grey"}
				_G.RaiseFrameLevelByTwo(this.FilterButton) -- raise above SetsCollectionFrame when displayed on it
				self:skinCloseButton{obj=this.FilterButton.ResetButton, fType=ftype, noSkin=true}
			end
			local x1Ofs, y1Ofs, x2Ofs, y2Ofs = -4, 2, 7, -5

			if _G.IsAddOnLoaded("BetterWardrobe") then
				self.callbacks:Fire("WardrobeCollectionFrame_OnShow")
			else
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
				self:SecureHookScript(this.ItemsCollectionFrame, "OnShow", function(fObj)
					self:skinObject("dropdown", {obj=fObj.WeaponDropDown, fType=ftype})
					self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, rns=true, fb=true, x1=x1Ofs, y1=y1Ofs, x2=x2Ofs, y2=y2Ofs})
					if self.modBtnBs then
						skinPageBtns(fObj)
						for _, btn in _G.pairs(fObj.Models) do
							self:removeRegions(btn, {2}) -- background & border
							self:addButtonBorder{obj=btn, reParent={btn.NewString, btn.Favorite.Icon, btn.HideVisual.Icon}, ofs=6}
							updBtnClr(btn)
						end
						self:SecureHook(fObj, "UpdateItems", function(icF)
							for _, btn in _G.pairs(icF.Models) do
								updBtnClr(btn)
							end
						end)
					end

					self:Unhook(fObj, "OnShow")
				end)
				self:checkShown(this.ItemsCollectionFrame)
				self:SecureHookScript(this.SetsCollectionFrame, "OnShow", function(fObj)
					self:removeInset(fObj.LeftInset)
					self:keepFontStrings(fObj.RightInset)
					self:removeNineSlice(fObj.RightInset.NineSlice)
					self:skinObject("scrollbar", {obj=fObj.ListContainer.ScrollBar, fType=ftype})
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
								 aObj:addButtonBorder{obj=element, relTo=element.Icon, reParent={element.Favorite}}
								 aObj:clrBtnBdr(element, element.Icon:IsDesaturated() and "grey")
							end
						end
					end
					_G.ScrollUtil.AddAcquiredFrameCallback(fObj.ListContainer.ScrollBox, skinElement, aObj, true)
					fObj.DetailsFrame:DisableDrawLayer("BACKGROUND")
					fObj.DetailsFrame:DisableDrawLayer("BORDER")
					self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, fb=true, x1=x1Ofs, y1=y1Ofs, x2=x2Ofs, y2=y2Ofs})
					if self.modBtns then
						 self:skinStdButton{obj=fObj.DetailsFrame.VariantSetsButton}
					end

					self:Unhook(fObj, "OnShow")
				end)
				self:SecureHookScript(this.SetsTransmogFrame, "OnShow", function(fObj)
					self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, rns=true, fb=true, x1=x1Ofs, y1=y1Ofs, x2=x2Ofs, y2=y2Ofs})
					if self.modBtnBs then
						skinPageBtns(fObj)
						for _, btn in _G.pairs(fObj.Models) do
							self:removeRegions(btn, {2}) -- background & border
							self:addButtonBorder{obj=btn, reParent={btn.Favorite.Icon}, ofs=6}
							updBtnClr(btn)
						end
					end

					self:Unhook(fObj, "OnShow")
				end)
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.WardrobeFrame, "OnShow", function(this)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, rns=true, cb=true, x2=3, y2=-1})

			self:Unhook(this, "OnShow")
		end)

		-- used by Transmog as well as Appearance
		self:SecureHookScript(_G.WardrobeTransmogFrame, "OnShow", function(this)
			this:DisableDrawLayer("ARTWORK")
			self:removeInset(this.Inset)
			self:skinObject("dropdown", {obj=this.OutfitDropDown, fType=ftype, y2=-3})
			for _, btn in _G.pairs(this.SlotButtons) do
				btn.Border:SetTexture(nil)
				if self.modBtnBs then
					 self:addButtonBorder{obj=btn, ofs=-2}
				end
			end
			this.ModelScene.ControlFrame:DisableDrawLayer("BACKGROUND")
			if self.modBtns then
				self:skinStdButton{obj=this.OutfitDropDown.SaveButton}
				self:skinStdButton{obj=this.ApplyButton, ofs=0}
				self:SecureHook(this.OutfitDropDown, "UpdateSaveButton", function(fObj)
					self:clrBtnBdr(fObj.SaveButton)
				end)
				self:SecureHook(_G.WardrobeTransmogFrame, "UpdateApplyButton", function(fObj)
						self:clrBtnBdr(fObj.ApplyButton)
					end)
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=this.ModelScene.ClearAllPendingButton, ofs=1, x2=0, relTo=this.ModelScene.ClearAllPendingButton.Icon}
				self:addButtonBorder{obj=this.SpecButton, ofs=0}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=this.ToggleSecondaryAppearanceCheckbox}
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzLoDFrames[ftype].Communities = function(self)
		if not self.prdb.Communities or self.initialized.Communities then return end

		--> N.B.these frames can't be skinned, as the XML has a ScopedModifier element saying forbidden="true"
			-- CommunitiesAddDialog
			-- CommunitiesCreateDialog

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
				aObj:skinObject("frame", {obj=header, fType=ftype, x2=-2})
			end
		end

		self:SecureHookScript(_G.CommunitiesFrame, "OnShow", function(this)
			self:keepFontStrings(this.PortraitOverlay)
			-- tabs (side)
			for _, tabName in _G.pairs{"ChatTab", "RosterTab", "GuildBenefitsTab", "GuildInfoTab"} do
				this[tabName]:DisableDrawLayer("BORDER")
				if self.modBtnBs then
					self:addButtonBorder{obj=this[tabName]}
				end
			end
			self:moveObject{obj=this.ChatTab, x=1}
			self:skinObject("dropdown", {obj=this.StreamDropDownMenu, fType=ftype})
			self:skinObject("dropdown", {obj=this.GuildMemberListDropDownMenu, fType=ftype})
			self:skinObject("dropdown", {obj=this.CommunityMemberListDropDownMenu, fType=ftype})
			self:skinObject("dropdown", {obj=this.CommunitiesListDropDownMenu, fType=ftype})
			self:skinObject("editbox", {obj=this.ChatEditBox, fType=ftype, y1=-6, y2=6})
			self:moveObject{obj=this.AddToChatButton, x=-6, y=-6}
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true, x1=-5})
			if self.modBtns then
				self:skinStdButton{obj=_G.JumpToUnreadButton, fType=ftype}
				self:skinStdButton{obj=this.InviteButton, fType=ftype, sechk=true}
				self:skinStdButton{obj=this.GuildLogButton, fType=ftype}
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=this.AddToChatButton, ofs=1, clr="gold"}
			end

			self:SecureHookScript(this.MaximizeMinimizeFrame, "OnShow", function(fObj)
				fObj:DisableDrawLayer("BACKGROUND")
				if self.modBtns then
					self:skinOtherButton{obj=fObj.MaximizeButton, font=self.fontS, text=self.nearrow}
					self:skinOtherButton{obj=fObj.MinimizeButton, font=self.fontS, disfont=self.fontDS, text=self.swarrow}
					self:SecureHook(this, "UpdateMaximizeMinimizeButton", function(frame)
						self:clrBtnBdr(frame.MaximizeMinimizeFrame.MinimizeButton)
					end)
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.MaximizeMinimizeFrame)

			self:SecureHookScript(this.CommunitiesList, "OnShow", function(fObj)
				fObj:DisableDrawLayer("BORDER")
				fObj:DisableDrawLayer("ARTWORK")
				self:skinObject("dropdown", {obj=fObj.EntryDropDown, fType=ftype})
				fObj.FilligreeOverlay:DisableDrawLayer("ARTWORK")
				fObj.FilligreeOverlay:DisableDrawLayer("OVERLAY")
				fObj.FilligreeOverlay:DisableDrawLayer("BORDER")
				self:removeInset(fObj.InsetFrame)
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
						aObj:changeTex(element.Selection, true)
						element.Selection:SetHeight(60)
						element.IconRing:SetAlpha(0) -- texture changed in code
						aObj:changeTex(element:GetHighlightTexture())
						element:GetHighlightTexture():SetHeight(60)
					end
				end
				_G.ScrollUtil.AddAcquiredFrameCallback(fObj.ScrollBox, skinElement, aObj, true)

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.CommunitiesList)

			self:SecureHookScript(this.MemberList, "OnShow", function(fObj)
				skinColumnDisplay(fObj.ColumnDisplay)
				if self.modChkBtns then
					 self:skinCheckButton{obj=fObj.ShowOfflineButton, hf=true}
				end
				self:skinObject("dropdown", {obj=fObj.DropDown, fType=ftype})
				self:removeInset(fObj.InsetFrame)
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
						aObj:removeRegions(element.ProfessionHeader, {1, 2, 3}) -- header textures
					end
				end
				_G.ScrollUtil.AddAcquiredFrameCallback(fObj.ScrollBox, skinElement, aObj, true)

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.MemberList)

			self:SecureHookScript(this.ApplicantList, "OnShow", function(fObj)
				fObj:DisableDrawLayer("BACKGROUND")
				fObj:DisableDrawLayer("ARTWORK")
				self:SecureHookScript(fObj.ColumnDisplay, "OnShow", function(frame)
					skinColumnDisplay(frame)
				end)
				self:checkShown(fObj.ColumnDisplay)
				self:skinObject("slider", {obj=fObj.ListScrollFrame.scrollBar, fType=ftype, rpTex="background"})
				self:skinObject("dropdown", {obj=fObj.DropDown, fType=ftype})
				self:removeNineSlice(fObj.InsetFrame.NineSlice)
				fObj.InsetFrame.Bg:SetTexture(nil)
				if self.modBtns then
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
							if aObj.modBtns then
								aObj:skinStdButton{obj=element.CancelInvitationButton}
								aObj:skinStdButton{obj=element.InviteButton}
							end
						end
					end
					_G.ScrollUtil.AddAcquiredFrameCallback(fObj.ScrollBox, skinElement, aObj, true)
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.ApplicantList)

			local function skinReqToJoin(frame)
				frame.MessageFrame:DisableDrawLayer("BACKGROUND")
				frame.MessageFrame.MessageScroll:DisableDrawLayer("BACKGROUND")
				aObj:skinObject("frame", {obj=frame.MessageFrame, fType=ftype, kfs=true, fb=true, ofs=2})
				aObj:skinObject("frame", {obj=frame.BG, fType=ftype, kfs=true})
				if aObj.modBtns then
					 aObj:skinStdButton{obj=frame.Apply}
					 aObj:skinStdButton{obj=frame.Cancel}
					 aObj:SecureHook(frame, "EnableOrDisableApplyButton", function(fObj)
						 aObj:clrBtnBdr(fObj.Apply, "", 1)
					 end)
				end
				if aObj.modChkBtns then
					aObj:SecureHook(frame, "Initialize", function(fObj)
						for spec in fObj.SpecsPool:EnumerateActive() do
							aObj:skinCheckButton{obj=spec.CheckBox}
						end
					end)
				end
			end
			local function skinCFGaCF(frame)
				frame:DisableDrawLayer("BACKGROUND")
				aObj:skinObject("dropdown", {obj=frame.OptionsList.ClubFilterDropdown, fType=ftype})
				aObj:skinObject("dropdown", {obj=frame.OptionsList.ClubSizeDropdown, fType=ftype})
				aObj:skinObject("dropdown", {obj=frame.OptionsList.SortByDropdown, fType=ftype})
				aObj:skinObject("editbox", {obj=frame.OptionsList.SearchBox, fType=ftype, si=true, y1=-6, y2=6})
				aObj:moveObject{obj=frame.OptionsList.Search, x=3, y=-4}
				if aObj.modBtns then
					aObj:skinStdButton{obj=frame.OptionsList.Search}
				end
				if aObj.modChkBtns then
					aObj:skinCheckButton{obj=frame.OptionsList.TankRoleFrame.CheckBox}
					aObj:skinCheckButton{obj=frame.OptionsList.HealerRoleFrame.CheckBox}
					aObj:skinCheckButton{obj=frame.OptionsList.DpsRoleFrame.CheckBox}
				end

				for _, btn in _G.pairs(frame.GuildCards.Cards) do
					btn:DisableDrawLayer("BACKGROUND")
					aObj:skinObject("frame", {obj=btn, fType=ftype, y1=5})
					if aObj.modBtns then
						aObj:skinStdButton{obj=btn.RequestJoin}
					end
					aObj:SecureHook(btn, "SetDisabledState", function(fObj, shouldDisable)
						if shouldDisable then
							aObj:clrBBC(fObj.sf, "disabled")
						else
							aObj:clrBBC(fObj.sf, "gold")
						end
					end)
				end
				if aObj.modBtnBs then
					aObj:addButtonBorder{obj=frame.GuildCards.PreviousPage, ofs=-2, y1=-3, x2=-3, clr="disabled"}
					aObj:addButtonBorder{obj=frame.GuildCards.NextPage, ofs=-2, y1=-3, x2=-3, clr="disabled"}
				end

				self:skinObject("scrollbar", {obj=frame.CommunityCards.ScrollBar, fType=ftype})
				local function skinCardElement(...)
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
						element.LogoBorder:SetTexture(nil)
						aObj:skinObject("frame", {obj=element, fType=ftype, ofs=3, x2=-10})
					end
				end
				_G.ScrollUtil.AddAcquiredFrameCallback(frame.CommunityCards.ScrollBox, skinCardElement, aObj, true)

				for _, btn in _G.pairs(frame.PendingGuildCards.Cards) do
					btn:DisableDrawLayer("BACKGROUND")
					aObj:skinObject("frame", {obj=btn, fType=ftype, y1=5})
					if aObj.modBtns then
						aObj:skinStdButton{obj=btn.RequestJoin}
					end
					aObj:SecureHook(btn, "SetDisabledState", function(fObj, shouldDisable)
						if shouldDisable then
							aObj:clrBBC(fObj.sf, "disabled")
						else
							aObj:clrBBC(fObj.sf, "gold")
						end
					end)
				end
				if aObj.modBtnBs then
					aObj:addButtonBorder{obj=frame.PendingGuildCards.PreviousPage, ofs=-2, y1=-3, x2=-3, clr="gold"}
					aObj:addButtonBorder{obj=frame.PendingGuildCards.NextPage, ofs=-2, y1=-3, x2=-3, clr="gold"}
				end

				self:skinObject("scrollbar", {obj=frame.PendingCommunityCards.ScrollBar, fType=ftype})
				local function skinPendingElement(...)
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
						element.LogoBorder:SetTexture(nil)
						aObj:skinObject("frame", {obj=element, fType=ftype, ofs=3, x2=-10})
					end
				end
				_G.ScrollUtil.AddAcquiredFrameCallback(frame.PendingCommunityCards.ScrollBox, skinPendingElement, aObj, true)

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
					aObj:SecureHook(frame, "UpdatePendingTab", function(fObj)
						aObj:clrBtnBdr(fObj.ClubFinderPendingTab)
					end)
				end
			end

			self:SecureHookScript(this.GuildFinderFrame, "OnShow", function(fObj)
				skinCFGaCF(fObj)
				if self.modBtnBs then
					self:secureHook(fObj.GuildCards, "RefreshLayout", function(frame, _)
						self:clrBtnBdr(frame.PreviousPage, "gold")
						self:clrBtnBdr(frame.NextPage, "gold")
					end)
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.GuildFinderFrame)

			self:SecureHookScript(this.CommunityFinderFrame, "OnShow", function(fObj)
				skinCFGaCF(fObj)

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.CommunityFinderFrame)
			self:checkShown(this.GuildDetailsFrame)

			self:SecureHookScript(this.GuildDetailsFrame, "OnShow", function(fObj)
				self:removeRegions(fObj.Info, {2, 3, 4, 5, 6, 7, 8, 9, 10})
				self:skinObject("slider", {obj=fObj.Info.MOTDScrollFrame.ScrollBar, fType=ftype})
				self:skinObject("slider", {obj=fObj.Info.DetailsFrame.ScrollBar, fType=ftype})
				fObj.News:DisableDrawLayer("BACKGROUND")
				self:skinObject("scrollbar", {obj=this.News.ScrollBar, fType=ftype})
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
						element.header:SetTexture(nil)
					end
				end
				_G.ScrollUtil.AddAcquiredFrameCallback(this.News.ScrollBox, skinElement, aObj, true)
				self:skinObject("dropdown", {obj=fObj.News.DropDown, fType=ftype})
				self:keepFontStrings(fObj.News.BossModel)
				self:removeRegions(fObj.News.BossModel.TextFrame, {2, 3, 4, 5, 6}) -- border textures
				fObj:DisableDrawLayer("OVERLAY")

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.GuildDetailsFrame)

			self:SecureHookScript(this.GuildNameChangeFrame, "OnShow", function(fObj)
				fObj:DisableDrawLayer("BACKGROUND")
				self:skinObject("editbox", {obj=fObj.EditBox, fType=ftype})
				if self.modBtns then
					self:skinStdButton{obj=fObj.Button}
				end
				if self.modChkBtns then
					self:skinCheckButton{obj=fObj.CloseButton}
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.GuildNameChangeFrame)

			self:SecureHookScript(this.EditStreamDialog, "OnShow", function(fObj)
				self:removeNineSlice(fObj.BG)
				self:skinObject("editbox", {obj=fObj.NameEdit, fType=ftype, y1=-4, y2=4})
				fObj.NameEdit:SetPoint("TOPLEFT", fObj.NameLabel, "BOTTOMLEFT", -4, 0)
				self:skinObject("frame", {obj=fObj.Description, fType=ftype, kfs=true, fb=true, ofs=7})
				self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true})
				if self.modBtns then
					self:skinStdButton{obj=fObj.Accept, fType=ftype, sechk=true}
					self:skinStdButton{obj=fObj.Delete, fType=ftype}
					self:skinStdButton{obj=fObj.Cancel, fType=ftype}
				end
				if self.modChkBtns then
					self:skinCheckButton{obj=fObj.TypeCheckBox}
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.EditStreamDialog)

			self:SecureHookScript(this.NotificationSettingsDialog, "OnShow", function(fObj)
				self:skinObject("dropdown", {obj=fObj.CommunitiesListDropDownMenu, fType=ftype})
				self:skinObject("slider", {obj=fObj.ScrollFrame.ScrollBar, fType=ftype})
				self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, ofs=-6, x2=-4})
				if self.modBtns then
					self:skinStdButton{obj=fObj.ScrollFrame.Child.NoneButton}
					self:skinStdButton{obj=fObj.ScrollFrame.Child.AllButton}
					self:skinStdButton{obj=fObj.CancelButton}
					self:skinStdButton{obj=fObj.OkayButton}
				end
				if self.modChkBtns then
					 self:skinCheckButton{obj=fObj.ScrollFrame.Child.QuickJoinButton}
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.NotificationSettingsDialog)

			self:SecureHookScript(this.RecruitmentDialog, "OnShow", function(fObj)
				self:skinObject("dropdown", {obj=fObj.ClubFocusDropdown, fType=ftype})
				self:skinObject("dropdown", {obj=fObj.LookingForDropdown, fType=ftype})
				self:skinObject("dropdown", {obj=fObj.LanguageDropdown, fType=ftype})
				fObj.RecruitmentMessageFrame:DisableDrawLayer("BACKGROUND")
				fObj.RecruitmentMessageFrame.RecruitmentMessageInput:DisableDrawLayer("BACKGROUND")
				self:skinObject("frame", {obj=fObj.RecruitmentMessageFrame, fType=ftype, kfs=true, fb=true, ofs=3})
				self:skinObject("editbox", {obj=fObj.MinIlvlOnly.EditBox, fType=ftype})
				fObj.MinIlvlOnly.EditBox.Text:ClearAllPoints()
				fObj.MinIlvlOnly.EditBox.Text:SetPoint("Left", fObj.MinIlvlOnly.EditBox, "Left", 6, 0)
				self:skinObject("frame", {obj=fObj.BG, fType=ftype, kfs=true, ofs=0})
				if self.modBtns then
					self:skinStdButton{obj=fObj.Accept}
					self:skinStdButton{obj=fObj.Cancel}
				end
				if self.modChkBtns then
					self:skinCheckButton{obj=fObj.ShouldListClub.Button}
					self:skinCheckButton{obj=fObj.MaxLevelOnly.Button}
					self:skinCheckButton{obj=fObj.MinIlvlOnly.Button}
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.RecruitmentDialog)

			self:SecureHookScript(this.CommunitiesControlFrame, "OnShow", function(fObj)
				if self.modBtns then
					self:skinStdButton{obj=fObj.CommunitiesSettingsButton, fType=ftype}
					self:skinStdButton{obj=fObj.GuildRecruitmentButton, fType=ftype, sechk=true}
					self:skinStdButton{obj=fObj.GuildControlButton, fType=ftype}
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.CommunitiesControlFrame)

			-- N.B. hook DisplayMember rather than OnShow script
			self:SecureHook(this.GuildMemberDetailFrame, "DisplayMember", function(fObj, _)
				self:removeNineSlice(fObj.Border)
				self:skinObject("dropdown", {obj=fObj.RankDropdown, fType=ftype})
				self:skinObject("frame", {obj=fObj.NoteBackground, fType=ftype, fb=true, ofs=0})
				self:skinObject("frame", {obj=fObj.OfficerNoteBackground, fType=ftype, fb=true, ofs=0})
				self:adjWidth{obj=fObj.RemoveButton, adj=-4}
				self:adjWidth{obj=fObj.GroupInviteButton, adj=-4}
				self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, cb=true, ofs=-7, x2=0})
				if self.modBtns then
					self:skinStdButton{obj=fObj.RemoveButton, fType=ftype, sechk=true}
					self:skinStdButton{obj=fObj.GroupInviteButton, fType=ftype, sechk=true}
				end

				self:Unhook(fObj, "DisplayMember")
			end)
			self:checkShown(this.GuildMemberDetailFrame)

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.CommunitiesFrame)

		self:SecureHookScript(_G.CommunitiesAvatarPickerDialog, "OnShow", function(this)
			self:skinObject("slider", {obj=this.ScrollFrame.ScrollBar, fType=ftype, rpTex="background"})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, y1=-12})
			if self.modBtns then
				self:skinStdButton{obj=this.CancelButton}
				self:skinStdButton{obj=this.OkayButton}
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.CommunitiesTicketManagerDialog, "OnShow", function(this)
			self:skinObject("dropdown", {obj=this.UsesDropDownMenu, fType=ftype})
			this.InviteManager.ArtOverlay:DisableDrawLayer("OVERLAY")
			skinColumnDisplay(this.InviteManager.ColumnDisplay)
			self:skinObject("scrollbar", {obj=this.InviteManager.ScrollBar, fType=ftype})
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
					aObj:skinStdButton{obj=element.CopyLinkButton}
					if aObj.modBtnBs then
						 aObj:addButtonBorder{obj=element.RevokeButton, ofs=0, clr="grey"}
					end
				end
			end
			_G.ScrollUtil.AddAcquiredFrameCallback(this.InviteManager.ScrollBox, skinElement, aObj, true)
			self:skinObject("dropdown", {obj=this.ExpiresDropDownMenu, fType=ftype})
			self:skinObject("frame", {obj=this.InviteManager, fType=ftype, kfs=true, fb=true, ofs=-4, x2=-7, y2=-5})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, y1=-8, y2=6})
			if self.modBtns then
				self:skinStdButton{obj=this.LinkToChat, fType=ftype, sechk=true}
				self:skinStdButton{obj=this.Copy, fType=ftype, sechk=true}
				self:skinStdButton{obj=this.GenerateLinkButton}
				self:skinStdButton{obj=this.Close}
			end
			if self.modBtnBs then
				 self:addButtonBorder{obj=this.MaximizeButton, ofs=0, clr="gold"}
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.CommunitiesSettingsDialog, "OnShow", function(this)
			self:keepFontStrings(this.BG)
			self:skinObject("editbox", {obj=this.NameEdit, fType=ftype})
			self:skinObject("editbox", {obj=this.ShortNameEdit, fType=ftype})
			self:skinObject("frame", {obj=this.MessageOfTheDay, fType=ftype, kfs=true, fb=true, ofs=8})
			this.IconPreviewRing:SetTexture(nil)
			self:skinObject("editbox", {obj=this.MinIlvlOnly.EditBox, fType=ftype})
			this.MinIlvlOnly.EditBox.Text:ClearAllPoints()
			this.MinIlvlOnly.EditBox.Text:SetPoint("Left", this.MinIlvlOnly.EditBox, "Left", 6, 0)
			self:skinObject("dropdown", {obj=this.ClubFocusDropdown, fType=ftype})
			self:skinObject("dropdown", {obj=this.LookingForDropdown, fType=ftype})
			self:skinObject("dropdown", {obj=this.LanguageDropdown, fType=ftype})
			self:skinObject("frame", {obj=this.Description, fType=ftype, kfs=true, fb=true, ofs=8})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ofs=-10})
			if self.modBtns then
				self:skinStdButton{obj=this.ChangeAvatarButton}
				self:skinStdButton{obj=this.Delete}
				self:skinStdButton{obj=this.Accept}
				self:skinStdButton{obj=this.Cancel}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=this.CrossFactionToggle.CheckButton, fType=ftype}
				self:skinCheckButton{obj=this.ShouldListClub.Button, fType=ftype}
				self:skinCheckButton{obj=this.AutoAcceptApplications.Button, fType=ftype}
				self:skinCheckButton{obj=this.MaxLevelOnly.Button, fType=ftype}
				self:skinCheckButton{obj=this.MinIlvlOnly.Button, fType=ftype}
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.CommunitiesGuildTextEditFrame, "OnShow", function(this)
			self:skinObject("slider", {obj=this.Container.ScrollFrame.ScrollBar, fType=ftype})
			self:skinObject("frame", {obj=this.Container, fType=ftype, kfs=true, fb=true})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, ofs=-7})
			if self.modBtns then
				self:skinStdButton{obj=_G.CommunitiesGuildTextEditFrameAcceptButton}
				self:skinStdButton{obj=self:getChild(_G.CommunitiesGuildTextEditFrame, 4)} -- bottom close button, uses same name as previous CB
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.CommunitiesGuildLogFrame, "OnShow", function(this)
			self:skinObject("slider", {obj=this.Container.ScrollFrame.ScrollBar, fType=ftype})
			self:skinObject("frame", {obj=this.Container, fType=ftype, kfs=true, fb=true})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, ofs=-7})
			if self.modBtns then
				 self:skinStdButton{obj=self:getChild(this, 3)} -- bottom close button
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.CommunitiesGuildNewsFiltersFrame, "OnShow", function(this)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, ofs=-7})
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

	aObj.blizzFrames[ftype].ContainerFrames = function(self)
		if not self.prdb.ContainerFrames.skin or self.initialized.ContainerFrames then return end
		self.initialized.ContainerFrames = true

		if _G.IsAddOnLoaded("LiteBag") then
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
					aObj:addButtonBorder{obj=btn, fType=ftype, ibt=true, reParent={btn.IconQuestTexture, btn.UpgradeIcon, btn.NewItemTexture, btn.BattlepayItemTexture, btn.JunkIcon}, ofs=3}
					btn.NormalTexture:SetAlpha(0)
					btn.ExtendedSlot:SetTexture(nil)
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
					end
				end)
				frame:UpdateItems()
			end
			-- Backpack
			if id == 0 then
				aObj:skinObject("editbox", {obj=_G.BagItemSearchBox, fType=ftype, si=true, ca=true})
				if aObj.modBtnBs then
					aObj:addButtonBorder{obj=_G.BagItemAutoSortButton, ofs=0, y1=1, clr="grey"}
				end
				frame.MoneyFrame.Border:DisableDrawLayer("BACKGROUND")
				_G.BackpackTokenFrame:DisableDrawLayer("BACKGROUND")
			end
		end

		self:SecureHook("ContainerFrame_GenerateFrame", function(frame, _, id)
			-- skin the frame if required
			if not frame.sf then
				skinBag(frame, id)
			end
		end)

	end

	aObj.blizzFrames[ftype].DressUpFrame = function(self)
		if not self.prdb.DressUpFrame or self.initialized.DressUpFrame then return end
		self.initialized.DressUpFrame = true

		if _G.IsAddOnLoaded("DressUp") then
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
			this.MaxMinButtonFrame:DisableDrawLayer("BACKGROUND") -- corner texture
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
				self:skinOtherButton{obj=this.MaxMinButtonFrame.MaximizeButton, font=self.fontS, text=self.nearrow}
				self:skinOtherButton{obj=this.MaxMinButtonFrame.MinimizeButton, font=self.fontS, text=self.swarrow}
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
			self:skinObject("slider", {obj=_G.EncounterJournalScrollBar, fType=ftype})
			self:skinObject("tabs", {obj=this, tabs=this.Tabs, selectedTab=this.selectedTab, fType=ftype, lod=self.isTT and true, offsets={x1=-1, y1=2, x2=1, y2=1}, regions={7, 8, 9, 10, 11}, track=false, func=function(tab) tab:SetFrameLevel(20) end})
			-- for _, tab in _G.pairs(this.Tabs) do
			-- 	tab.grayBox:DisableDrawLayer("BACKGROUND")
			-- end
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
				self:skinObject("frame", {obj=fObj, fType=ftype, fb=true, x1=-9, y1=6, x2=7, y2=-5})

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.suggestFrame)

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
				-- FIXME: the frame isn't appearing when using offsets !
				-- self:skinObject("frame", {obj=fObj.ScrollBox, fType=ftype, kfs=true, fb=true, ofs=6, x1=-9, y2=-8})
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
				self:skinObject("slider", {obj=fObj.info.detailsScroll.ScrollBar, fType=ftype, x2=-4})
				self:skinObject("slider", {obj=fObj.info.overviewScroll.ScrollBar, fType=ftype, x2=-4})
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
				local function skinItemSets()
					for _, set in _G.pairs(fObj.ItemSetsFrame.buttons) do
						set.Background:SetTexture(nil)
					end
				end
				self:SecureHook(fObj.ItemSetsFrame, "UpdateList", function(_)
					skinItemSets()
				end)
				skinItemSets()
				fObj:DisableDrawLayer("BACKGROUND")
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
			self:skinObject("slider", {obj=_G.FriendsFriendsScrollFrame.Slider, fType=ftype})
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
				self:skinObject("slider", {obj=fObj.inset.scrollFrame.ScrollBar, fType=ftype, rpTex="artwork"})
				self:skinObject("dropdown", {obj=fObj.dropdown, fType=ftype})
				_G.UIDropDownMenu_SetButtonWidth(fObj.dropdown, 24)
				fObj.inset:DisableDrawLayer("BACKGROUND")
				fObj.inset:DisableDrawLayer("BORDER")

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
			self:changeTex2SB(_G.GuildFactionBarProgress)
			_G.GuildFactionBarShadow:SetAlpha(0)
			self:changeTex2SB(_G.GuildFactionBarCap)
			_G.GuildFactionBarCapMarker:SetAlpha(0)
			self:skinObject("editbox", {obj=_G.GuildNameChangeFrame.editBox, fType=ftype})
			if self.modBtns then
				-- N.B. NO CloseButton for GuildNameChangeAlertFrame
				self:skinStdButton{obj=_G.GuildNameChangeFrame.button}
			end
			self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true})
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
			for i = 1, 5 do
				_G["GuildRosterColumnButton" .. i]:DisableDrawLayer("BACKGROUND")
				self:skinObject("frame", {obj=_G["GuildRosterColumnButton" .. i], fType=ftype, ofs=0})
			end
			self:skinObject("slider", {obj=_G.GuildRosterContainerScrollBar, fType=ftype})
			for _, btn in _G.pairs(_G.GuildRosterContainer.buttons) do
				btn:DisableDrawLayer("BACKGROUND")
				self:changeTex2SB(btn.barTexture)
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
			for _, btn in _G.pairs(_G.GuildRewardsContainer.buttons) do
				btn:GetNormalTexture():SetAlpha(0)
				btn.disabledBG:SetAlpha(0)
				if self.modBtnBs then
					self:addButtonBorder{obj=btn, relTo=btn.icon, reParent={btn.lock}}
				end
			end
			self:skinObject("dropdown", {obj=_G.GuildRewardsDropDown, fType=ftype})

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.GuildInfoFrame, "OnShow", function(this)
			self:removeRegions(this, {1, 2, 3, 4, 5, 6 ,7, 8}) -- Background textures and bars
			self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true, upwards=true, offsets={x1=2, y1=-5, x2=2, y2=self.isTT and -5 or 0}})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, fb=true, x1=-5, y1=1, x2=7, y2=0})

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
			self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true})
			-- let AddOn skins know when when UI is skinned (used by oGlow skin)
			self.callbacks:Fire("InspectUI_Skinned", self)
			-- remove all callbacks for this event
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
			self:SecureHook(this, "Hide", function(_)
				_G.InspectFrame.portrait:SetAlpha(0)
			end)

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.InspectTalentFrame, "OnShow", function(this)
			-- self:keepFontStrings(this)
			this:DisableDrawLayer("border")
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
						element.HighlightNameFrame:SetTexture(nil)
						element.BorderFrame:SetTexture(nil)
						if element.QualityStripe then
							element.QualityStripe:SetTexture(nil)
						end
						if aObj.modBtnBs then
							aObj:addButtonBorder{obj=element.Item, fType=ftype, relTo=element.Item.icon, ibt=true, ofs=3, y2=-2}

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
				aObj:addButtonBorder{obj=frame.IconFrame, fType=ftype, relTo=frame.IconFrame.Icon, reParent={frame.IconFrame.Count}}
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
		for i = 1, _G.NUM_GROUP_LOOT_FRAMES do
			self:SecureHookScript(_G["GroupLootFrame" .. i], "OnShow", function(this)
				skinGroupLoot(this)

				self:Unhook(this, "OnShow")
			end)
		end

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
					aObj:addButtonBorder{obj=btn, reParent={btn.Count}, clr="grey"}
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

	aObj.blizzLoDFrames[ftype].Professions = function(self)
		if not self.prdb.Professions or self.initialized.Professions then return end
		self.initialized.Professions = true

		local function skinReagentBtn(btn)
			if aObj.modBtnBs then
				if not btn.sbb then
					aObj:addButtonBorder{obj=btn, fType=ftype, ibt=true, relTo=btn.Icon}
				else
					aObj:clrButtonFromBorder(btn)
				end
			end
		end
		local function skinNISpinner(ebObj)
			ebObj:DisableDrawLayer("BACKGROUND")
			aObj:skinObject("editbox", {obj=ebObj, fType=ftype, chginset=false, ofs=0, x1=-6})
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=ebObj.IncrementButton, ofs=0, x2=-1, sechk=true, clr="gold"}
				aObj:addButtonBorder{obj=ebObj.DecrementButton, ofs=0, x2=-1, sechk=true, clr="gold"}
			end
		end
		local function skinSchematicForm(frame)
			frame.Background:SetAlpha(0)
			for i = 1, 3 do
				skinReagentBtn(frame.QualityDialog["Container" .. i].Button)
				skinNISpinner(frame.QualityDialog["Container" .. i].EditBox)
			end
			aObj:skinObject("frame", {obj=frame.QualityDialog, fType=ftype, kfs=true, rns=true})
			if aObj.modBtns then
				aObj:skinCloseButton{obj=frame.QualityDialog.ClosePanelButton, fType=ftype}
				aObj:skinStdButton{obj=frame.QualityDialog.CancelButton, fType=ftype}
				aObj:skinStdButton{obj=frame.QualityDialog.AcceptButton, fType=ftype}
			end
			aObj:SecureHook(frame, "Init", function(fObj, _)
				local slots = fObj:GetSlots()
				-- aObj:Debug("SchematicForm Init: [%s, %s, %s]", recipeInfo, #slots)
				for _, slot in _G.pairs(slots) do
					if slot.InputSlot then -- Recraft slot
					else -- Reagent, Optional, Salvage, Enchant
						skinReagentBtn(slot.Button)
					end
				end
			end)
			aObj:removeRegions(frame.RecipeLevelBar, {1, 2, 3})
			aObj:skinObject("statusbar", {obj=frame.RecipeLevelBar, fi=0})
			if aObj.modBtns then
				 aObj:skinStdButton{obj=frame.RecipeLevelSelector, fType=ftype, ofs=0, clr="grey"}
			end
			-- TODO: skin .Details frame
			aObj:skinObject("frame", {obj=frame, fType=ftype, rns=true, fb=true, ofs=4})
			if aObj.modChkBtns then
				aObj:skinCheckButton{obj=frame.TrackRecipeCheckBox, fType=ftype}
				aObj:skinCheckButton{obj=frame.AllocateBestQualityCheckBox, fType=ftype}
			end
		end
		self:SecureHookScript(_G.ProfessionsFrame, "OnShow", function(this)
			self:skinObject("tabs", {obj=this.TabSystem,  pool=true, fType=ftype, ignoreSize=true, track=false})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true})

			self:SecureHookScript(this.CraftingPage, "OnShow", function(fObj)
				fObj.TutorialButton.Ring:SetTexture(nil)
				self:removeNineSlice(fObj.RecipeList.BackgroundNineSlice)
				if self.modBtns then
					self:skinStdButton{obj=fObj.RecipeList.FilterButton, fType=ftype, ofs=0, clr="grey"}
					self:skinCloseButton{obj=fObj.RecipeList.FilterButton.ResetButton, fType=ftype, noSkin=true}
				end
				self:skinObject("editbox", {obj=fObj.RecipeList.SearchBox, fType=ftype, si=true})
				self:skinObject("dropdown", {obj=fObj.RecipeList.ContextMenu, fType=ftype})
				-- fObj.RecipeList.ScrollBar [DON'T skin (MinimalScrollBar)]
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
				skinSchematicForm(fObj.SchematicForm)
				fObj.RankBar.Background:SetTexture(nil)
				fObj.RankBar.Border:SetTexture(nil)
				-- FIXME: skin RankBar ?
				skinNISpinner(fObj.CreateMultipleInputBox)
				-- fObj.GuildFrame.Container.ScrollBar  [DON'T skin (MinimalScrollBar)]
				self:skinObject("frame", {obj=fObj.GuildFrame.Container, fType=ftype, kfs=true, rns=true, fb=true})
				-- fObj.CraftingOutputLog.ScrollBar [DON'T skin (MinimalScrollBar)]
				-- TODO: skin ScrollBox elements
				self:skinObject("frame", {obj=fObj.CraftingOutputLog, fType=ftype, kfs=true, rns=true, fb=true})
				if self.modBtns then
					self:skinStdButton{obj=fObj.CreateAllButton, fType=ftype, sechk=true}
					self:skinStdButton{obj=fObj.CreateButton, fType=ftype, sechk=true}
					self:skinStdButton{obj=fObj.ViewGuildCraftersButton, fType=ftype, sechk=true}
					self:skinStdButton{obj=fObj.CraftingOutputLog.ClosePanelButton, fType=ftype}
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

			-- TODO: finish skinning .SpecPage
			self:SecureHookScript(this.SpecPage, "OnShow", function(fObj)
				self:skinObject("frame", {obj=fObj.TreeView, fType=ftype, kfs=true, rns=true, fb=true})
					-- .Path
					-- .SpendPointsButton
					-- .UnlockPathButton
					-- .UnspentPoints
				self:skinObject("frame", {obj=fObj.DetailedView, fType=ftype, kfs=true, rns=true, fb=true})
				if self.modBtns then
					self:skinStdButton{obj=fObj.ApplyButton, fType=ftype}
					self:skinStdButton{obj=fObj.UnlockTabButton, fType=ftype}
				end

				self:Unhook(fObj, "OnShow")
			end)

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.ProfessionsFrame)

	end

	aObj.blizzLoDFrames[ftype].ProfessionsCrafterOrders = function(self)
		if not self.prdb.Professions or self.initialized.ProfessionsCrafterOrders then return end
		self.initialized.ProfessionsCrafterOrders = true

		self:SecureHookScript(_G.ProfessionsCrafterOrdersFrame, "OnShow", function(this)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, rns=true, cb=true})

			self:SecureHookScript(this.BrowseOrders, "OnShow", function(fObj)
				self:skinObject("editbox", {obj=fObj.SearchBar.SearchBox, fType=ftype, si=true})
				self:skinObject("dropdown", {obj=fObj.OrderRecipientDropDown, fType=ftype, lrgTpl=true, x1=-1, y1=2, x2=0, y2=2})
				if self.modBtns then
					self:skinStdButton{obj=fObj.SearchBar.FavoritesSearchButton, fType=ftype, ofs=-2, clr="gold"}
					self:skinStdButton{obj=fObj.SearchBar.SearchButton, fType=ftype}
					self:skinCloseButton{obj=fObj.FilterButton.ResetButton, fType=ftype, noSkin=true}
					self:skinStdButton{obj=fObj.FilterButton, fType=ftype, clr="grey"}
				end
				self:skinObject("scrollbar", {obj=fObj.RecipeList.ScrollBar, fType=ftype})
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
				_G.ScrollUtil.AddAcquiredFrameCallback(fObj.RecipeList.ScrollBox, skinRecipeElement, aObj, true)
				-- hook this to skin headers
				self:SecureHook(fObj, "SetupTable", function(frame, _)
					for hdr in frame.tableBuilder:EnumerateHeaders() do
						hdr:DisableDrawLayer("BACKGROUND")
						self:skinObject("frame", {obj=hdr, fType=ftype, ofs=0})
				end
				end)
				self:skinObject("scrollbar", {obj=fObj.OrderList.ScrollBar, fType=ftype})
				local function skinOrderElement(...)
					local _, element, elementData, new
					if _G.select("#", ...) == 2 then
						element, elementData = ...
					elseif _G.select("#", ...) == 3 then
						element, elementData, new = ...
					else
						_, element, elementData, new = ...
				end
					if new ~= false then
						-- TODO: skin Order elements
					end
				end
				_G.ScrollUtil.AddAcquiredFrameCallback(fObj.OrderList.ScrollBox, skinOrderElement, aObj, true)

				self:Unhook(fObj, "OnShow")
		end)
			self:checkShown(this.BrowseOrders)

			self:SecureHookScript(this.Form, "OnShow", function(fObj)
				-- .CustomerDetails
					-- .BackButton
					-- .ScrollBoxContainer
					-- .TipMoneyDisplayFrame
					-- .CancelOrderButton
					-- .DeclineOrderButton

				-- .StartOrderButton
				-- .CreateOrderButton

				-- .CraftingOutputDialog
				-- .SchematicForm

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.Form)

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.ProfessionsCrafterOrdersFrame)

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
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, rns=true, cb=true, y2=0})

			self:SecureHookScript(this.Form, "OnShow", function(fObj)
				fObj:DisableDrawLayer("ARTWORK")
				self:skinObject("dropdown", {obj=fObj.MinimumQualityDropDown, fType=ftype, lrgTpl=true, x1=-1, y1=2, x2=0, y2=2})
				self:skinObject("dropdown", {obj=fObj.OrderRecipientDropDown, fType=ftype, lrgTpl=true, x1=-1, y1=2, x2=0, y2=2})
				self:skinObject("frame", {obj=fObj.ReagentContainer, fType=ftype, kfs=true, fb=true, ofs=4})
				-- TODO: skin Reagent buttons
				self:skinObject("frame", {obj=fObj.PaymentContainer, fType=ftype, kfs=true, fb=true, ofs=4})
				self:skinObject("frame", {obj=fObj.PaymentContainer.ScrollBoxContainer, fType=ftype, kfs=true, fb=true})
				self:skinObject("editbox", {obj=fObj.PaymentContainer.TipMoneyInputFrame.CopperBox, fType=ftype, y2=4})
				self:skinObject("editbox", {obj=fObj.PaymentContainer.TipMoneyInputFrame.SilverBox, fType=ftype, y2=4})
				self:skinObject("editbox", {obj=fObj.PaymentContainer.TipMoneyInputFrame.GoldBox, fType=ftype, y2=4})
				self:skinObject("dropdown", {obj=fObj.PaymentContainer.DurationDropDown, fType=ftype, lrgTpl=true, x1=-1, y1=2, x2=0, y2=2})
				-- .QualityDialog
				if self.modBtns then
					self:skinStdButton{obj=fObj.BackButton, fType=ftype}
					self:skinStdButton{obj=fObj.PaymentContainer.ListOrderButton, fType=ftype}
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

				local function skinHdrs(frame)
					for hdr in frame.tableBuilder:EnumerateHeaders() do
						hdr:DisableDrawLayer("BACKGROUND")
						self:skinObject("frame", {obj=hdr, fType=ftype, ofs=0})
					end
				end
				self:SecureHook(fObj, "SetupTable", function(frame, _)
					skinHdrs(frame)
				end)
				skinHdrs(fObj)

				self:SecureHookScript(fObj.CategoryList, "OnShow", function(frame)
					frame:DisableDrawLayer("BACKGROUND")
					self:removeNineSlice(frame.NineSlice)
					self:skinObject("scrollbar", {obj=frame.ScrollBar, fType=ftype})
					local function skinElement(...)
						local _, element
						if _G.select("#", ...) == 2 then
							element, _ = ...
						elseif _G.select("#", ...) == 3 then
							_, element, _ = ...
						end
						aObj:keepRegions(element, {3, 4, 5}) -- N.B. region 3 is highlight, 4 is selected, 5 is text
						aObj.modUIBtns:skinStdButton{obj=element, fType=ftype, ignoreHLTex=true}
						element.sb:Show()
						element.sb:ClearAllPoints()
						if element.categoryInfo.type == _G.Enum.CraftingOrderCustomerCategoryType.Primary then
							element.sb:SetPoint("TOPLEFT", element, "TOPLEFT", -1, 1)
							element.sb:SetPoint("BOTTOMRIGHT", element, "BOTTOMRIGHT", -4, -1)
						elseif element.categoryInfo.type == _G.Enum.CraftingOrderCustomerCategoryType.Secondary  then
							element.sb:SetPoint("TOPLEFT", element, "TOPLEFT", 10, 1)
							element.sb:SetPoint("BOTTOMRIGHT", element, "BOTTOMRIGHT", -4, -1)
						elseif element.categoryInfo.type == _G.Enum.CraftingOrderCustomerCategoryType.Tertiary then
							element.sb:Hide()
						end
					end
					_G.ScrollUtil.AddInitializedFrameCallback(frame.ScrollBox, skinElement, aObj, true)

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
				self:skinObject("scrollbar", {obj=fObj.CategoryList.ScrollBar, fType=ftype})
				local function skinCategoryElement(...)
					local _, element, elementData, new
					if _G.select("#", ...) == 2 then
						element, elementData = ...
					elseif _G.select("#", ...) == 3 then
						element, elementData, new = ...
					else
						_, element, elementData, new = ...
					end
					if new ~= false then
					end
				end
				_G.ScrollUtil.AddAcquiredFrameCallback(fObj.CategoryList.ScrollBox, skinCategoryElement, aObj, true)
				self:skinObject("scrollbar", {obj=fObj.OrderList.ScrollBar, fType=ftype})
				local function skinOrderElement(...)
					local _, element, elementData, new
					if _G.select("#", ...) == 2 then
						element, elementData = ...
					elseif _G.select("#", ...) == 3 then
						element, elementData, new = ...
					else
						_, element, elementData, new = ...
					end
					if new ~= false then
					end
				end
				_G.ScrollUtil.AddAcquiredFrameCallback(fObj.OrderList.ScrollBox, skinOrderElement, aObj, true)

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.MyOrdersPage)

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.ProfessionsCustomerOrdersFrame)

	end

	aObj.blizzFrames[ftype].ProfessionsRecipeFlyout = function(self)
		if not self.prdb.Professions or self.initialized.ProfessionsRecipeFlyout then return end
		self.initialized.ProfessionsRecipeFlyout = true

		self:RawHook("ToggleProfessionsItemFlyout", function(owner, parent)
			local flyout = self.hooks.ToggleProfessionsItemFlyout(owner, parent)
			aObj:Debug("ToggleProfessionsItemFlyout: [%s, %s, %s, %s]", owner, parent, flyout)
			self:skinObject("frame", {obj=flyout, fType=ftype, kfs=true, rns=true})
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
						-- TODO: sort out item colour issue
						if not element.sbb then
							aObj:addButtonBorder{obj=element, fType=ftype, ibt=true, relTo=element.Icon}
						else
							aObj:clrButtonFromBorder(element)
						end
					end
				end
			end
			_G.ScrollUtil.AddAcquiredFrameCallback(flyout.ScrollBox, skinElement, aObj, true)
			if self.modChkBtns then
				self:skinCheckButton{obj=flyout.HideUnownedCheckBox, fType=ftype}
			end
			self:Unhook("ToggleProfessionsItemFlyout")
			return flyout
		end, true)

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
					self:clrBtnBdr(_G.HonorFrame.BonusFrame.Arena1Button.Reward, "gold")
					self:clrBtnBdr(_G.HonorFrame.BonusFrame.RandomEpicBGButton.Reward, "gold")
					self:clrBtnBdr(_G.HonorFrame.BonusFrame.BrawlButton.Reward, "gold")
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
			for _, bName in _G.pairs{"Arena2v2", "Arena3v3", "RatedBG", "RatedSoloShuffle"} do
				this[bName].NormalTexture:SetTexture(nil)
				this[bName].Reward.Border:SetTexture(nil)
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

	aObj.blizzFrames[ftype].RolePollPopup = function(self)
		if not self.prdb.RolePollPopup or self.initialized.RolePollPopup then return end
		self.initialized.RolePollPopup = true

		self:SecureHookScript(_G.RolePollPopup, "OnShow", function(this)
			self:removeNineSlice(this.Border)
			self:skinObject("frame", {obj=this, fType=ftype, ofs=5})
			if self.modBtns then
				self:skinStdButton{obj=this.acceptButton}
				self:SecureHook("RolePollPopup_UpdateChecked", function(fObj)
					self:clrBtnBdr(fObj.acceptButton)
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
			local function updBtn(btn)
				-- handle in combat
				if _G.InCombatLockdown() then
				    aObj:add2Table(aObj.oocTab, {updBtn, {btn}})
				    return
				end
				if aObj.modBtnBs
				and btn.sbb -- allow for not skinned during combat
				then
					if btn:IsEnabled() then
						btn.sbb:Show()
					else
						btn.sbb:Hide()
						return
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

	if not aObj.isRtl then
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
					end
				end
				self:SecureHook("TalentFrame_Update", function(fObj, _)
					for tier = 1, _G.MAX_TALENT_TIERS do
						for column = 1, _G.NUM_TALENT_COLUMNS do
							skinBtnBBC(fObj, fObj["tier" .. tier]["talent" .. column])
						end
					end
				end)
			end

			self:SecureHookScript(_G.PlayerTalentFrame, "OnShow", function(this)
				self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true})
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
				self:SecureHook("PlayerTalentFrame_CreateSpecSpellButton", function(fObj, index)
					fObj.spellsScroll.child["abilityButton" .. index].ring:SetTexture(nil)
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
				end
				for i = 1, _G.MAX_TALENT_TABS do
					frame["specButton" .. i].bg:SetTexture(nil)
					frame["specButton" .. i].ring:SetTexture(nil)
					aObj:changeTex(frame["specButton" .. i].selectedTex, true)
					frame["specButton" .. i].learnedTex:SetTexture(nil)
					if not aObj.isElvUI
					and frame["specButton" .. i]:GetHighlightTexture()
					then
						aObj:changeTex(frame["specButton" .. i]:GetHighlightTexture())
					end
					-- make specIcon square
					aObj:makeIconSquare(frame["specButton" .. i], "specIcon")
				end
				-- shadow frame (LHS)
				aObj:keepFontStrings(aObj:getChild(frame, 8))
				-- spellsScroll (RHS)
				aObj:skinObject("slider", {obj=frame.spellsScroll.ScrollBar, fType=ftype})
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
				self:keepFontStrings(this)
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
					self:addButtonBorder{obj=_G.PlayerTalentFrameTalentsPvpTalentButton, ofs=1, clr="grey"}
				end
				local frame = this.PvpTalentFrame
				frame:DisableDrawLayer("BACKGROUND")
				frame:DisableDrawLayer("OVERLAY")
				self:nilTexture(frame.Ring, true) -- warmode button ring texture
				for _, slot in _G.pairs(frame.Slots) do
					self:nilTexture(slot.Border, true) -- PvP talent ring texture
					self:makeIconSquare(slot, "Texture", "gold")
				end
				frame.WarmodeIncentive.IconRing:SetTexture(nil)
				self:skinObject("slider", {obj=frame.TalentList.ScrollFrame.ScrollBar, fType=ftype})
				self:removeMagicBtnTex(self:getChild(frame.TalentList, 4))
				self:skinObject("frame", {obj=frame.TalentList, fType=ftype, kfs=true, ri=true, x2=-4})
				for _, btn in _G.pairs(frame.TalentList.ScrollFrame.buttons) do
					btn:DisableDrawLayer("BACKGROUND")
					if self.modBtnBs then
						 self:addButtonBorder{obj=btn, relTo=btn.Icon}
						 self:SecureHook(btn, "Update", function(bObj)
							 self:clrBtnBdr(bObj, "white")
						 end)
					end
				end
				if self.modBtns then
					self:skinStdButton{obj=self:getChild(frame.TalentList, 4)}
				end

				frame.UpdateModelScenes = _G.nop
				frame.OrbModelScene:Hide()
				frame.FireModelScene:Hide()

				self:Unhook(this, "OnShow")
			end)

		end

		aObj.blizzLoDFrames[ftype].TradeSkillUI = function(self)
			if not self.prdb.TradeSkillUI or self.initialized.TradeSkillUI then return end
			self.initialized.TradeSkillUI = true

			self:SecureHookScript(_G.TradeSkillFrame, "OnShow", function(this)
				self:removeInset(this.RecipeInset)
				self:removeInset(this.DetailsInset)
				self:skinObject("statusbar", {obj=this.RankFrame, fi=0, bg=this.RankFrameBackground})
				self:removeRegions(this.RankFrame, {1, 2, 3})
				self:skinObject("editbox", {obj=this.SearchBox, fType=ftype, si=true})
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, rns=true, cb=true})
				if self.modBtns then
					 self:skinStdButton{obj=this.FilterButton, ftype=ftype, clr="grey", ofs=0}
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
					self:SecureHook(_G.TradeSkillFrame.RecipeList, "OnLearnedTabClicked", function(fObj)
						changeTabTex(fObj)
					end)
					self:SecureHook(_G.TradeSkillFrame.RecipeList, "OnUnlearnedTabClicked", function(fObj)
						changeTabTex(fObj)
					end)
				end
				self:skinObject("slider", {obj=self:getChild(this.RecipeList, 4), fType=ftype})
				self:skinObject("frame", {obj=this.RecipeList, fType=ftype, kfs=true, fb=true, ofs=8, x1=-7, y1=5, x2=24})
				for _, btn in _G.pairs(this.RecipeList.buttons) do
					btn.SubSkillRankBar.BorderLeft:SetTexture(nil)
					btn.SubSkillRankBar.BorderRight:SetTexture(nil)
					btn.SubSkillRankBar.BorderMid:SetTexture(nil)
					self:skinObject("statusbar", {obj=btn.SubSkillRankBar, fi=0})
					if self.modBtns then
						 self:skinExpandButton{obj=btn, fType=ftype, onSB=true, noHook=true}
					end
				end
				if self.modBtns then
					local function checkTex(fObj)
						for _, btn in _G.pairs(fObj.buttons) do
							if not btn.isHeader then
								btn.sb:Hide()
							else
								if btn.tradeSkillInfo.collapsed then
									btn.sb:SetText("+")
								else
									btn.sb:SetText("-")
								end
								btn.sb:Show()
							end
						end
					end
					self:SecureHook(this.RecipeList, "RefreshDisplay", function(fObj)
						checkTex(fObj)
					end)
					self:SecureHook(this.RecipeList, "update", function(fObj)
						checkTex(fObj)
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
					self:SecureHook(cmib, "SetEnabled", function(fObj, _)
						self:clrBtnBdr(fObj.IncrementButton, "gold")
						self:clrBtnBdr(fObj.DecrementButton, "gold")
					end)
				end
				local cnts = this.DetailsFrame.Contents
				if self.modBtnBs then
					self:addButtonBorder{obj=cnts.ResultIcon, reParent={cnts.ResultIcon.Count}}
				end
				cnts.ResultIcon.ResultBorder:SetTexture(nil)
				cnts.RecipeLevel.BorderLeft:SetTexture(nil)
				cnts.RecipeLevel.BorderRight:SetTexture(nil)
				cnts.RecipeLevel.BorderMid:SetTexture(nil)
				self:skinObject("statusbar", {obj=cnts.RecipeLevel, fi=0})
				if self.modBtns then
					self:skinStdButton{obj=cnts.RecipeLevelSelector, fType=ftype, ofs=0}
				end
				for _, btn in _G.pairs(cnts.Reagents) do
					btn.NameFrame:SetTexture(nil)
					if self.modBtnBs then
						 self:addButtonBorder{obj=btn, libt=true, relTo=btn.Icon, reParent={btn.Count}, clr="common"}
					end
				end
				-- TODO: Find out why border colour changes when optional reagent chosen and revert when removed
				for _, btn in _G.pairs(cnts.OptionalReagents) do
					btn.NameFrame:SetTexture(nil)
					if self.modBtnBs then
						 self:addButtonBorder{obj=btn, libt=true, relTo=btn.Icon, reParent={btn.Count}, clr="green"}
					end
				end
				if self.modBtns then
					self:skinStdButton{obj=this.DetailsFrame.ViewGuildCraftersButton, fType=ftype}
					self:skinStdButton{obj=this.DetailsFrame.ExitButton, fType=ftype}
					self:skinStdButton{obj=this.DetailsFrame.CreateAllButton, fType=ftype}
					self:skinStdButton{obj=this.DetailsFrame.CreateButton, fType=ftype}
					self:SecureHook(this.DetailsFrame, "RefreshButtons", function(fObj)
						self:clrBtnBdr(fObj.CreateAllButton)
						self:clrBtnBdr(fObj.CreateButton)
					end)
				end
				-- Guild Crafters
				self:SecureHookScript(this.DetailsFrame.GuildFrame, "OnShow", function(fObj)
					self:skinObject("slider", {obj=fObj.Container.ScrollFrame.scrollBar, fType=ftype})
					self:skinObject("frame", {obj=fObj.Container, fType=ftype, ofs=2, x2=-2})
					self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, cb=true, ofs=-7})

					self:Unhook(fObj, "OnShow")
				end)
				-- OptionalReagentList
				self:SecureHookScript(this.OptionalReagentList, "OnShow", function(fObj)
					self:removeInset(fObj.ScrollList.InsetFrame)
					self:skinObject("slider", {obj=fObj.ScrollList.ScrollFrame.scrollBar, fType=ftype, rpTex="background"})
					local btn
					for i = 1, fObj.ScrollList:GetNumElementFrames() do
						btn = fObj.ScrollList:GetElementFrame(i)
						btn.NameFrame:SetTexture(nil)
						if self.modBtnBs then
							self:addButtonBorder{obj=btn, libt=true}
						end
					end
					-- apply button changes
					fObj:RefreshScrollFrame()
					self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, ri=true, rns=true, ofs=0})
					if self.modBtns then
						self:skinStdButton{obj=fObj.CloseButton, fType=ftype}
					end
					if self.modChkBtns then
						self:skinCheckButton{obj=fObj.HideUnownedButton, fType=ftype}
					end

					self:Unhook(fObj, "OnShow")
				end)
				-- let AddOn skins know when when UI is skinned (used by oGlow skin)
				self.callbacks:Fire("TradeSkillUI_Skinned", self)
				-- remove all callbacks for this event
				self.callbacks.events["TradeSkillUI_Skinned"] = nil

				self:Unhook(this, "OnShow")
			end)

		end
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
		["Collections"]          = {suff = "Journal"},
		["Communities"]			 = {suff = "UI"},
		["Encounter Journal"]    = {desc = "Adventure Guide"},
		["Equipment Flyout"]     = true,
		["Guild Control UI"]     = true,
		["Guild Invite"]         = {suff = "Frame"},
		["Guild UI"]             = true,
		["Looking For Guild UI"] = {desc = "Looking for Guild UI"},
		["Professions"]          = true,
		["PVP UI"]               = {desc = "PVP Frame"},
		["Role Poll Popup"]      = true,
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
