-- luacheck: ignore 631 (line is too long)
local _, aObj = ...
if not aObj:isAddonEnabled("MountsJournal") then return end
local _G = _G

aObj.addonsToSkin.MountsJournal = function(self) -- v 11.0.10/4.4.15

	if self.isClsc
	and self.modChkBtns
	then
		self.RegisterCallback("MountsJournal", "Collections_Skinned", function(_, _)
			-- wait for check button to be created
			_G.C_Timer.After(0.05, function()
				self:skinCheckButton{obj=_G.MountsJournalFrame.useMountsJournalButton}
			end)
			self.UnregisterCallback("MountsJournal", "Collections_Skinned")
		end)
	end

	self:SecureHook(_G.MountsJournalFrame, "init", function(mjFrame)
		self:skinObject("slider", {obj=mjFrame.xInitialAcceleration.slider})
		self:skinObject("slider", {obj=mjFrame.xAcceleration.slider})
		self:skinObject("slider", {obj=mjFrame.xMinSpeed.slider})
		self:skinObject("slider", {obj=mjFrame.yInitialAcceleration.slider})
		self:skinObject("slider", {obj=mjFrame.yAcceleration.slider})
		self:skinObject("slider", {obj=mjFrame.yMinSpeed.slider})
		if self.modBtns then
			self:skinStdButton{obj=mjFrame.filtersButton}
		end

		local skinMountBtn = _G.nop
		if self.modBtnBs then
			function skinMountBtn(btn)
				-- aObj:Debug("skinMountBtn#1: [%s, %s, %s]", btn, btn.sbb, btn.icon:GetAlpha())
				-- _G.C_Timer.After(0.5, function()
					aObj:addButtonBorder{obj=btn, relTo=btn.icon, reParent={btn.mountWeight, btn.mountWeightBG, btn.favorite}}
					btn.sbb:SetAlpha(1)
					btn.sbb:SetBackdropBorderColor(btn.qualityBorder:GetVertexColor())
					btn.sbb:SetAlpha(btn.icon:GetAlpha())
					btn.qualityBorder:Hide()
				-- end)
			end
		end
		self:SecureHookScript(mjFrame.bgFrame, "OnShow", function(this)
			self:removeInset(this.mountCount)
			if self.isRtl then
				this.slotButton:DisableDrawLayer("BACKGROUND")
				this.achiev:DisableDrawLayer("BACKGROUND")
				this.achiev.highlight:SetTexture(nil)
			end
			this.navBar:DisableDrawLayer("BACKGROUND")
			this.navBar:DisableDrawLayer("BORDER")
			this.navBar.overlay:DisableDrawLayer("OVERLAY")
			self:skinNavBarButton(this.navBar.homeButton)
			this.navBar.homeButton.text:SetPoint("RIGHT", -20, 0)
			self:removeInset(this.filtersPanel)
			self:skinObject("editbox", {obj=this.filtersPanel.searchBox, si=true})
			self:skinObject("tabs", {obj=this.filtersPanel.filtersBar, tabs=this.filtersPanel.filtersBar.tabs, ignoreSize= true, lod=self.isTT and true, regions={4, 5, 6, 7, 8}, offsets={x1=3, y1=-1, x2=-3, y2=0}, track=false, func=self.isTT and function(tab)
				tab.selected:DisableDrawLayer("ARTWORK")
				self:SecureHook(tab.selected, "Show", function(tObj)
					self:setActiveTab(tObj:GetParent().sf)
				end)
				self:SecureHook(tab.selected, "Hide", function(tObj)
					self:setInactiveTab(tObj:GetParent().sf)
				end)
			end})
			self:skinObject("frame", {obj=this.filtersPanel.filtersBar, kfs=true,})
			self:removeInset(this.leftInset)
			self:skinObject("scrollbar", {obj=this.leftInset.scrollBar})
			local function skinMount(...)
				local _, element, new
				if _G.select("#", ...) == 2 then
					element, _ = ...
				elseif _G.select("#", ...) == 3 then
					_, element, _ = ...
				else
					_, element, _, new = ...
				end
				if new ~= false then
					if element.background then
						element.background:SetTexture(nil)
					end
					-- TODO: skin button borders
				end
			end
			_G.ScrollUtil.AddAcquiredFrameCallback(this.leftInset.scrollBox, skinMount, aObj, true)

			self:removeInset(this.rightInset)
			this.mountDisplay:DisableDrawLayer("BACKGROUND")
			this.mountDisplay.shadowOverlay:DisableDrawLayer("OVERLAY")
			self:skinObject("dropdown", {obj=this.mountDisplay.modelScene.animationsCombobox, x1=1, y1=2, x2=-1, y2=0})
			local psb = this.mountDisplay.info.petSelectionBtn
			if self.isRtl then
				this.mountDisplay.modelScene.playerToggle.border:SetTexture(nil)
				psb.infoFrame.levelBG:SetTexture(nil)
			end
			psb.bg:SetTexture(nil)
			psb.border:SetTexture(nil)
			self:SecureHookScript(psb, "onClick", function(fObj)
				local psl = fObj.petSelectionList
				self:removeInset(psl.controlPanel)
				self:skinObject("editbox", {obj=psl.searchBox, si=true})
				if self.isRtl then
					self:removeInset(psl.filtersPanel)
				end
				self:removeInset(psl.controlButtons)
				psl.randomFavoritePet.background:SetTexture(nil)
				psl.randomPet.background:SetTexture(nil)
				psl.noPet.background:SetTexture(nil)
				self:removeInset(psl.petListFrame)
				self:skinObject("scrollbar", {obj=psl.petListFrame.scrollBar})
				local function skinPet(...)
					local _, element, new
					if _G.select("#", ...) == 2 then
						element, _ = ...
					elseif _G.select("#", ...) == 3 then
						element, _, new = ...
					else
						_, element, _, new = ...
					end
					if new ~= false then
						element.background:SetTexture(nil)
						-- TODO: skin button borders
					end
				end
				_G.ScrollUtil.AddAcquiredFrameCallback(psl.petListFrame.scrollBox, skinPet, aObj, true)
				self:skinObject("frame", {obj=psl, kfs=true, cb=true, x1=-1, y2=-1})

				self:Unhook(fObj, "oOnClick")
			end)
			self:skinObject("slider", {obj=this.percentSlider.slider})
			-- TODO: skin tabs
			self:skinObject("tabs", {obj=this, tabs=this.Tabs, lod=self.isTT and true, selectedTab=3})
			self:skinObject("frame", {obj=this, kfs=true, cb=true, x2=3, y2=-1})
			if self.modBtns then
				self:skinStdButton{obj=this.summonButton, schk=true, sechk=true}
				self:skinStdButton{obj=this.mountSpecial}
				self:skinStdButton{obj=this.profilesMenu}
				local function skinFilterBtn(btn)
					aObj:skinObject("frame", {obj=btn, kfs=true})
					btn.icon:SetAlpha(1)
					btn.icon:SetParent(btn.sf)
					btn.icon:SetDrawLayer("ARTWORK")
				end
				for _, btn in _G.pairs(this.filtersPanel.filtersBar.types.childs) do
					skinFilterBtn(btn)
				end
				for _, btn in _G.pairs(this.filtersPanel.filtersBar.selected.childs) do
					skinFilterBtn(btn)
				end
				for _, btn in _G.pairs(this.filtersPanel.filtersBar.sources.childs) do
					skinFilterBtn(btn)
				end
			end
			if self.modBtnBs then
				if self.isRtl then
					self:addButtonBorder{obj=this.slotButton, relTo=this.slotButton.ItemIcon, reParent={this.slotButton.SlotBorder, this.slotButton.SlotBorderOpen}}
					self:addButtonBorder{obj=this.OpenDynamicFlightSkillTreeButton, ofs=3}
					self:addButtonBorder{obj=this.DynamicFlightModeButton, ofs=3}
					self:addButtonBorder{obj=this.mountDisplay.info.mountDescriptionToggle, ofs=0}
				end
				self:addButtonBorder{obj=this.summon2, sabt=true, ofs=3}
				self:addButtonBorder{obj=this.summon1, sabt=true, ofs=3}
				self:addButtonBorder{obj=this.filtersPanel.btnToggle, ofs=1}
				self:addButtonBorder{obj=this.filtersPanel.gridToggleButton, ofs=1}
				self:addButtonBorder{obj=this.mountDisplay.info, relTo=this.mountDisplay.info.icon, clr="white"}
				self:addButtonBorder{obj=psb.infoFrame, relTo=psb.infoFrame.icon, reParent={psb.infoFrame.isDead, psb.infoFrame.level, psb.infoFrame.favorite}}
			end
			if self.modChkBtns then
				if self.isRtl then
					self:skinCheckButton{obj=mjFrame.useMountsJournalButton}
				end
			end

			self:SecureHookScript(this.worldMap, "OnShow", function(fObj)
				self:removeInset(this.worldMap)
				self:skinObject("dropdown", {obj=this.worldMap.navigation, y2=-2})

				self:Unhook(fObj, "OnShow")
			end)
			self:SecureHookScript(this.mapSettings, "OnShow", function(fObj)
				self:removeInset(fObj)
				self:removeInset(fObj.mapControl)
				self:skinObject("editbox", {obj=fObj.existingLists.searchBox, si=true})
				self:skinObject("scrollbar", {obj=fObj.existingLists.scrollBar})
				-- TODO: skin .existingLists expand buttons
				self:skinObject("frame", {obj=fObj.existingLists, kfs=true, x1=-1, y2=self.isClsc and -1 or -2})
				if self.modBtns then
					self:skinStdButton{obj=this.mapSettings.dnr}
					self:skinStdButton{obj=this.mapSettings.CurrentMap}
					self:skinStdButton{obj=this.mapSettings.listFromMap, sechk=true}
				end
				if self.modBtnBs then
					self:addButtonBorder{obj=this.mapSettings.existingListsToggle, ofs=0}
				end
				if self.modChkBtns then
					if self.isRtl then
						self:skinCheckButton{obj=this.mapSettings.HerbGathering, sechk=true}
					end
					self:skinCheckButton{obj=this.mapSettings.Flags, sechk=true}
					self:skinCheckButton{obj=this.mapSettings.Ground, sechk=true}
					self:skinCheckButton{obj=this.mapSettings.WaterWalk, sechk=true}
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:SecureHookScript(this.calendarFrame, "OnShow", function(fObj)
				fObj.monthBackground:SetTexture(nil)
				fObj.yearBackground:SetTexture(nil)
				if self.modBtnBs then
					self:addButtonBorder{obj=fObj.prevMonthButton, ofs=-2, y1=-3, x2=-3, clr="gold"}
					self:addButtonBorder{obj=fObj.nextMonthButton, ofs=-2, y1=-3, x2=-3, clr="gold"}
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:SecureHookScript(this.settingsBackground, "OnShow", function(fObj)
				self:skinObject("tabs", {obj=fObj, tabs=fObj.Tabs, lod=self.isTT and true--[[, selectedTab=3--]], offsets={x1=3, y1=-1, x2=-3, y2=-4}})
				self:skinObject("frame", {obj=fObj, kfs=true, ri=true, fb=true})

				self:SecureHookScript(_G.MountsJournalConfig, "OnShow", function(frame)
					-- Global settings
					self:skinObject("frame", {obj=frame.leftPanel, kfs=true, fb=true})
					self:skinObject("frame", {obj=frame.rightPanel, kfs=true, fb=true})
					if self.isRtl then
						self:skinObject("frame", {obj=frame.herbGroup, kfs=true, fb=true})
						self:skinObject("frame", {obj=frame.magicBroomGroup, kfs=true, fb=true})
					else
						self:skinObject("frame", {obj=frame.minimapGroup, kfs=true, fb=true})
					end
					self:skinObject("editbox", {obj=frame.repairPercent})
					self:skinObject("editbox", {obj=frame.repairFlyablePercent})
					self:skinObject("editbox", {obj=frame.freeSlotsNum})
					self:skinObject("frame", {obj=frame.repairGroup, kfs=true, fb=true})
					if frame.underlightAnglerGroup then
						self:skinObject("frame", {obj=frame.underlightAnglerGroup, kfs=true, fb=true})
					end
					self:skinObject("editbox", {obj=frame.summonPetEveryN})
					self:skinObject("frame", {obj=frame.petGroup, kfs=true, fb=true})
					self:skinObject("frame", {obj=frame.rightPanel, kfs=true, fb=true})
					self:skinObject("frame", {obj=frame.rightPanel, kfs=true, fb=true})
					if self.modBtns then
						self:skinStdButton{obj=frame.bindMount}
						self:skinStdButton{obj=frame.bindSecondMount}
						if self.isRtl then
							self:skinStdButton{obj=frame.resetHelp}
						else
							self:skinStdButton{obj=frame.createMacroBtn}
							self:skinStdButton{obj=frame.createSecondMacroBtn}
						end
						self:skinStdButton{obj=frame.cancelBtn, schk=true}
						self:skinStdButton{obj=frame.applyBtn, schk=true}
					end
					if self.modChkBtns then
						self:skinCheckButton{obj=frame.waterJump}
						if self.isRtl then
							self:skinCheckButton{obj=frame.useHerbMounts}
							self:skinCheckButton{obj=frame.herbMountsOnZones, sechk=true}
						else
							self:skinCheckButton{obj=frame.showMinimapButton}
						end
						self:skinCheckButton{obj=frame.useRepairMounts}
						self:skinCheckButton{obj=frame.repairFlyable, sechk=true}
						self:skinCheckButton{obj=frame.freeSlots}
						self:skinCheckButton{obj=frame.useMagicBroom}
						if frame.underlightAnglerGroup then
							self:skinCheckButton{obj=frame.useUnderlightAngler}
							self:skinCheckButton{obj=frame.autoUseUnderlightAngler, sechk=true}
						end
						self:skinCheckButton{obj=frame.summonPetEvery}
						self:skinCheckButton{obj=frame.summonPetOnlyFavorites, sechk=true}
						self:skinCheckButton{obj=frame.noPetInRaid}
						self:skinCheckButton{obj=frame.noPetInGroup}
						self:skinCheckButton{obj=frame.copyMountTarget}
						if self.isRtl then
							self:skinCheckButton{obj=frame.coloredMountNames}
						end
						self:skinCheckButton{obj=frame.arrowButtons}
						self:skinCheckButton{obj=frame.openLinks}
						self:skinCheckButton{obj=frame.showWowheadLink}
					end

					self:Unhook(frame, "OnShow")
				end)
				self:SecureHookScript(_G.MountsJournalConfigClasses, "OnShow", function(frame)
					self:skinObject("frame", {obj=frame.leftPanel, kfs=true, fb=true})
					self:skinObject("scrollbar", {obj=frame.rightPanelScroll.ScrollBar})
					self:skinObject("scrollbar", {obj=frame.moveFallMF.scrollBar})
					self:skinObject("frame", {obj=frame.moveFallMF.background, kfs=true, fb=true, ofs=0})
					self:skinObject("frame", {obj=frame.combatMF.background, kfs=true, fb=true, ofs=0})
					self:skinObject("frame", {obj=frame.rightPanel, kfs=true, fb=true})
					if self.modBtns then
						self:skinStdButton{obj=frame.moveFallMF.defaultBtn}
						self:skinStdButton{obj=frame.moveFallMF.saveBtn, sechk=true}
						self:skinStdButton{obj=frame.moveFallMF.cancelBtn, sechk=true}
						self:skinStdButton{obj=frame.combatMF.defaultBtn}
						self:skinStdButton{obj=frame.combatMF.saveBtn, sechk=true}
						self:skinStdButton{obj=frame.combatMF.cancelBtn, sechk=true}
					end
					if self.modChkBtns then
						self:skinCheckButton{obj=frame.charCheck}
						self:skinCheckButton{obj=frame.moveFallMF.enable}
						self:skinCheckButton{obj=frame.combatMF.enable}
					end

					self:Unhook(frame, "OnShow")
				end)
				self:SecureHook(_G.MountsJournalConfigClasses, "showClassSettings", function(frame, _)
					-- N.B. no sliders currently used (Retail ONLY)
					-- for slider in frame.sliderPool:EnumerateActive() do
					-- end
					for cBox in frame.checkPool:EnumerateActive() do
						if self.modChkBtns then
							self:skinCheckButton{obj=cBox}
							self:clrBtnBdr(cBox)
						end
					end

				end)
				-- MountsJournalConfigAbout

				self:Unhook(fObj, "OnShow")
			end)

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(mjFrame.bgFrame)

		self:Unhook(mjFrame, "init")
	end)

	self:SecureHookScript(_G.MJTooltipModel, "OnShow", function(this)
		self:skinObject("frame", {obj=this, kfs=true, ofs=0})

		self:Unhook(this, "OnShow")
	end)

	if self.isRtl then
		self:SecureHookScript(_G.MountsJournal.summonPanel, "OnShow", function(this)
			self:skinObject("frame", {obj=this, kfs=true, fb=true})
			if self.modBtns then
				self:addButtonBorder{obj=this.summon1, ofs=3, reParent={this.summon1.FlyoutArrowNormal, this.summon1.FlyoutArrowPushed, this.summon1.FlyoutArrowHighlight}}
				self:addButtonBorder{obj=this.summon2, ofs=3, reParent={this.summon2.FlyoutArrowNormal, this.summon2.FlyoutArrowPushed, this.summon2.FlyoutArrowHighlight}}
			end

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.MountsJournal.summonPanel)
	end

	local pCnt = 0
	self.RegisterCallback("MountsJournal", "IOFPanel_Before_Skinning", function(_, panel)
		if panel:GetName() ~= "MountsJournalConfig"
		and panel:GetName() ~= "MountsJournalConfigClasses"
		then
			return
		end
		if not self.iofSkinnedPanels[panel] then
			self.iofSkinnedPanels[panel] = true
			pCnt = pCnt + 1
			if panel:GetName() == "MountsJournalConfig" then
				local leftFrame = self:getChild(panel, 1)
				local rightFrame = self:getChild(panel, 2)
				self:skinObject("frame", {obj=leftFrame, kfs=true, fb=true})
				local rightPanelScroll = self:getChild(rightFrame, 1)
				self:skinObject("scrollbar", {obj=rightPanelScroll.ScrollBar})
				self:skinObject("frame", {obj=rightFrame, kfs=true, fb=true})
				if self.modBtns then
					self:skinStdButton{obj=panel.createMacroBtn}
					self:skinStdButton{obj=panel.bindMount}
					self:skinStdButton{obj=panel.createSecondMacroBtn}
					self:skinStdButton{obj=panel.bindSecondMount}
					if self.isRtl then
						self:skinStdButton{obj=panel.createThirdMacroBtn}
						self:skinStdButton{obj=panel.bindThirdMount}
						self:skinStdButton{obj=panel.resetHelp, schk=true}
					end
					self:skinStdButton{obj=panel.applyBtn, schk=true}
					self:skinStdButton{obj=panel.cancelBtn, schk=true}
				end
				if self.modChkBtns then
					if self.isRtl then
						self:skinCheckButton{obj=panel.useHerbMounts}
						self:skinCheckButton{obj=panel.herbMountsOnZones}
						self:skinCheckButton{obj=panel.useUnderlightAngler}
						self:skinCheckButton{obj=panel.autoUseUnderlightAngler}
					else
						self:skinCheckButton{obj=panel.showMinimapButton}
						self:skinCheckButton{obj=panel.lockMinimapButton}
					end
					self:skinCheckButton{obj=panel.waterJump}
					self:skinCheckButton{obj=panel.useRepairMounts}
					self:skinCheckButton{obj=panel.repairFlyable}
					self:skinCheckButton{obj=panel.useMagicBroom}
					self:skinCheckButton{obj=panel.summonPetEvery}
					self:skinCheckButton{obj=panel.summonPetOnlyFavorites}
					self:skinCheckButton{obj=panel.noPetInRaid}
					self:skinCheckButton{obj=panel.noPetInGroup}
					self:skinCheckButton{obj=panel.copyMountTarget}
					self:skinCheckButton{obj=panel.arrowButtons}
					self:skinCheckButton{obj=panel.openLinks}
					self:skinCheckButton{obj=panel.showWowheadLink}
				end
			elseif panel:GetName() == "MountsJournalConfigClasses" then
				local leftFrame = self:getChild(panel, 1)
				self:skinObject("frame", {obj=leftFrame, kfs=true, fb=true})
				local rightPanelScroll = self:getChild(panel.rightPanel, 1)
				self:skinObject("scrollbar", {obj=rightPanelScroll.ScrollBar})
				self:skinObject("scrollbar", {obj=panel.moveFallMF.scrollBar})
				self:skinObject("frame", {obj=panel.moveFallMF.background, kfs=true, fb=true})
				self:skinObject("frame", {obj=panel.combatMF.background, kfs=true, fb=true})
				self:skinObject("frame", {obj=panel.rightPanel, kfs=true, fb=true})
				if self.isRtl then
					for frame in panel.sliderPool:EnumerateActive() do
						self:skinObject("editbox", {obj=frame.edit})
						self:skinObject("slider", {obj=frame.slider})
					end
				end
				self:SecureHook(panel, "showClassSettings", function(this, _)
					if self.isRtl then
						for frame in this.sliderPool:EnumerateActive() do
							self:skinObject("editbox", {obj=frame.edit})
							self:skinObject("slider", {obj=frame.slider})
						end
					end
					if self.modChkBtns then
						for cBtn in this.checkPool:EnumerateActive() do
							self:skinCheckButton{obj=cBtn}
						end
					end
				end)
				if self.modBtns then
					self:skinStdButton{obj=panel.moveFallMF.defaultBtn}
					self:skinStdButton{obj=panel.moveFallMF.saveBtn, schk=true}
					self:skinStdButton{obj=panel.moveFallMF.cancelBtn, schk=true}
					self:skinStdButton{obj=panel.combatMF.defaultBtn}
					self:skinStdButton{obj=panel.combatMF.saveBtn, schk=true}
					self:skinStdButton{obj=panel.combatMF.cancelBtn, schk=true}
				end
				if self.modChkBtns then
					self:skinCheckButton{obj=panel.moveFallMF.enable}
					self:skinCheckButton{obj=panel.combatMF.enable}
					for cBtn in panel.checkPool:EnumerateActive() do
						self:skinCheckButton{obj=cBtn}
					end
					self:skinCheckButton{obj=panel.charCheck}
				end
			end
		end

		if pCnt == 2 then
			self.UnregisterCallback("MountsJournal", "IOFPanel_Before_Skinning")
		end
	end)

end
