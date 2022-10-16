local _, aObj = ...

local _G = _G

aObj.SetupDragonflight_PlayerFrames = function()
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
							bObj.Icon.sbb:SetBackdropBorderColor(bObj:GetBackdropBorderColor())
						end
					end)
					aObj:SecureHook(btn, "Saturate", function(bObj)
						if bObj.sf then
							bObj.sf:SetBackdropBorderColor(bObj:GetBackdropBorderColor())
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
			self:skinObject("editbox", {obj=this.SearchBox, fType=ftype, si=true, y1=-4, y2=4})
			self:moveObject{obj=this.SearchBox, y=-8}
			self:skinObject("statusbar", {obj=this.searchProgressBar, fi=0, bg=this.searchProgressBar.bg})
			self:moveObject{obj=_G.AchievementFrameCloseButton, x=1, y=8}
			self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true, ignoreHLTex=false, regions={7, 8, 9, 10}, offsets={x1=6, x2=-2, y2=-7}})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, y1=7, x2=0, y2=-2})

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
				local function skinElement(element, _, new)
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
				local function skinElement(element, _, new)
					if new ~= false then
						skinAchievement(element)
					end
				end
				_G.ScrollUtil.AddAcquiredFrameCallback(fObj.ScrollBox, skinElement, aObj, true)

				self:Unhook(fObj, "OnShow")
			end)

			self:SecureHookScript(_G.AchievementFrameStats, "OnShow", function(fObj)
				self:getChild(fObj, 1):DisableDrawLayer("BACKGROUND")
				self:skinObject("scrollbar", {obj=fObj.ScrollBar, fType=ftype})
				self:removeNineSlice(self:getChild(fObj, 4).NineSlice)
				self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, fb=true, ofs=0, x1=2, y2=-2})
				local function skinElement(element, _, new)
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
				local function skinAchieve(element, _, new)
					if new ~= false then
						skinAchievement(element.Player)
						aObj:removeNineSlice(element.Friend.NineSlice)
						skinAchievement(element.Friend)
					end
				end
				_G.ScrollUtil.AddAcquiredFrameCallback(fObj.AchievementContainer.ScrollBox, skinAchieve, aObj, true)
				self:skinObject("scrollbar", {obj=fObj.StatContainer.ScrollBar, fType=ftype})
				local function skinStat(element, _, new)
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
				local function skinElement(element, _, new)
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

	aObj.blizzLoDFrames[ftype].ClassTalentUI = function(self)
		if not self.prdb.ClassTalentUI or self.initialized.ClassTalentUI then return end
		self.initialized.ClassTalentUI = true

		self:SecureHookScript(_G.ClassTalentFrame, "OnShow", function(this)
			this.PortraitOverlay.Portrait:SetTexture(nil)
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
					local function skinSearch(element, _, new)
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
					local function skinElement(element, elementData, new)
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

	aObj.blizzFrames[ftype].LootFrames = function(self)
		if not self.prdb.LootFrames.skin or self.initialized.LootFrames then return end
		self.initialized.LootFrames = true

		self:SecureHookScript(_G.LootFrame, "OnShow", function(this)
			this.Bg:SetTexture(nil)
			self:skinObject("scrollbar", {obj=this.ScrollBar, fType=ftype})
			local function skinElement(element, _, new)
				if new ~= false then
					if element.Item then
						element.Item.NameFrame:SetTexture(nil)
						if aObj.modBtnBs then
							aObj:addButtonBorder{obj=element.Item, fType=ftype, ibt=true}
						end
					end
				end
			end
			-- FIXME: Do I need to do this ?
			-- self:keepFontStrings(this.ScrollBox.Shadows)
			_G.ScrollUtil.AddAcquiredFrameCallback(this.ScrollBox, skinElement, aObj, true)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, rns=true})
			if self.modBtns then
				self:skinCloseButton{obj=this.ClosePanelButton, fType=ftype}
			end
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
			aObj:SecureHook(frame, "Init", function(fObj, recipeInfo)
				local slots = fObj:GetSlots()
				aObj:Debug("SchematicForm Init: [%s, %s, %s]", recipeInfo, #slots)
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
				local function skinElement(element, _, new)
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

			self:RawHook("OpenProfessionsItemFlyout", function(owner, parent)
				local flyout = self.hooks.OpenProfessionsItemFlyout(owner, parent)
				aObj:Debug("OpenProfessionsItemFlyout: [%s, %s, %s, %s]", owner, parent, flyout)
				self:skinObject("frame", {obj=flyout, fType=ftype, kfs=true, rns=true})
				local function skinElement(element, _, new)
					if new ~= false then
						if aObj.modBtnBs then
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
				self:Unhook(this, "OpenProfessionsItemFlyout")
				return flyout
			end, true)

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.ProfessionsFrame)

	end

	-- TODO: skin ProfessionsCrafterOrders frame
	aObj.blizzLoDFrames[ftype].ProfessionsCrafterOrders = function(self)
		if not self.prdb.Professions or self.initialized.ProfessionsCrafterOrders then return end
		self.initialized.ProfessionsCrafterOrders = true

		self:SecureHookScript(_G.ProfessionsCrafterOrdersFrame, "OnShow", function(this)

			-- so-f

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.ProfessionsCrafterOrdersFrame)

	end

	-- TODO: skin ProfessionsCustomerOrders frame
	aObj.blizzLoDFrames[ftype].ProfessionsCustomerOrders = function(self)
		if not self.prdb.Professions or self.initialized.ProfessionsCustomerOrders then return end
		self.initialized.ProfessionsCustomerOrders = true

		self:SecureHookScript(_G.ProfessionsCustomerOrdersFrame, "OnShow", function(this)

			-- so-f

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.ProfessionsCustomerOrdersFrame)

	end

end

aObj.SetupDragonflight_PlayerFramesOptions = function(self)

	local optTab = {
		["Class Talent UI"] = true,
		["Professions"]     = true,
	}
	self:setupFramesOptions(optTab, "Player")
	_G.wipe(optTab)

end
