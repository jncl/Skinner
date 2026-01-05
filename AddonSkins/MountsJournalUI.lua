local _, aObj = ...
if not aObj:isAddonEnabled("MountsJournalUI") then return end
local _G = _G

aObj.addonsToSkin.MountsJournalUI= function(self) -- v v11.2.26/5.5.15

	-- skin check button on Mount Collections frame
	if self.modChkBtns then
		self.RegisterCallback("MountsJournalUI", "AddOn_Loaded", function(_, addonName)
			if addonName == "Blizzard_Collections"
			and _G.select(2, _G.C_AddOns.IsAddOnLoaded("MountsJournalUI"))
			or addonName == "MountsJournalUI"
			and _G.select(2, _G.C_AddOns.IsAddOnLoaded("Blizzard_Collections"))
			then
				_G.C_Timer.After(0.05, function()
					self:skinCheckButton{obj=_G.MountsJournalFrame.useMountsJournalButton}
					self.UnregisterCallback("MountsJournalUI", "AddOn_Loaded")
				end)
			end
		end)
	end

	self:SecureHook(_G.MountsJournalFrame, "init", function(mjFrame)
		-- summonPanel settings
		self:skinObject("slider", {obj=_G.MountsJournal.summonPanel.fade.slider})
		self:skinObject("slider", {obj=_G.MountsJournal.summonPanel.resize.slider})
		-- mount model settings
		self:skinObject("slider", {obj=mjFrame.xInitialAcceleration.slider})
		self:skinObject("slider", {obj=mjFrame.xAcceleration.slider})
		self:skinObject("slider", {obj=mjFrame.xMinSpeed.slider})
		self:skinObject("slider", {obj=mjFrame.yInitialAcceleration.slider})
		self:skinObject("slider", {obj=mjFrame.yAcceleration.slider})
		self:skinObject("slider", {obj=mjFrame.yMinSpeed.slider})

		self:SecureHookScript(mjFrame.bgFrame, "OnShow", function(this)
			self:removeInset(this.mountCount)
			if self.isMnln then
				this.slotButton:DisableDrawLayer("BACKGROUND")
				this.achiev:DisableDrawLayer("BACKGROUND")
				this.achiev.highlight:SetTexture(nil)
			end
			self:skinNavBar(this.navBar)
			this.navBar.homeButton.text:SetPoint("RIGHT", -20, 0)
			self:removeInset(this.filtersPanel)
			self:skinObject("editbox", {obj=this.filtersPanel.searchBox, si=true})
			self:skinObject("ddbutton", {obj=mjFrame.filtersButton, filter=true})
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
			if not aObj.isMnln then
				self:skinObject("dropdown", {obj=this.mountDisplay.modelScene.animationsCombobox, x1=1, y1=2, x2=-1, y2=0})
			else
				self:skinObject("ddbutton", {obj=this.mountDisplay.modelScene.animationsCombobox})
			end
			local psb = this.mountDisplay.info.petSelectionBtn
			if self.isMnln then
				this.mountDisplay.modelScene.playerToggle.border:SetTexture(nil)
				psb.infoFrame.levelBG:SetTexture(nil)
			end
			psb.bg:SetTexture(nil)
			self.modUIBtns:addButtonBorder{obj=psb} -- use module to display button border
			psb.border:SetTexture(nil)
			self:SecureHookScript(psb, "onClick", function(fObj)
				local psl = fObj.petSelectionList
				self:removeInset(psl.controlPanel)
				self:skinObject("editbox", {obj=psl.searchBox, si=true})
				if self.isMnln then
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
				if self.isMnln then
					self:addButtonBorder{obj=this.slotButton, relTo=this.slotButton.ItemIcon, reParent={this.slotButton.SlotBorder, this.slotButton.SlotBorderOpen}}
					self:addButtonBorder{obj=this.OpenDynamicFlightSkillTreeButton, ofs=3}
					self:addButtonBorder{obj=this.DynamicFlightModeButton, ofs=3}
					self:addButtonBorder{obj=this.mountDisplay.info.mountDescriptionToggle, ofs=0}
				end
				self:addButtonBorder{obj=this.targetMount}
				self:addButtonBorder{obj=this.summon2, sabt=true, ofs=3}
				self:addButtonBorder{obj=this.summon1, sabt=true, ofs=3}
				self:addButtonBorder{obj=this.filtersPanel.btnToggle, ofs=1}
				self:addButtonBorder{obj=this.filtersPanel.gridToggleButton, ofs=1}
				self:addButtonBorder{obj=this.mountDisplay.info, relTo=this.mountDisplay.info.icon, clr="white"}
				self:addButtonBorder{obj=psb.infoFrame, relTo=psb.infoFrame.icon, reParent={psb.infoFrame.isDead, psb.infoFrame.level, psb.infoFrame.favorite}}
			end

			self:SecureHookScript(this.worldMap, "OnShow", function(fObj)
				self:removeInset(fObj)
				if not aObj.isMnln then
					self:skinObject("dropdown", {obj=fObj.navigation, x1=1, y1=2, x2=-1, y2=0})
				else
					self:skinObject("ddbutton", {obj=fObj.navigation})
				end

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
					-- .relationMap
					self:skinStdButton{obj=this.mapSettings.dnr}
					self:skinStdButton{obj=this.mapSettings.CurrentMap}
					self:skinStdButton{obj=this.mapSettings.listFromMap, sechk=true}
				end
				if self.modBtnBs then
					self:addButtonBorder{obj=this.mapSettings.existingListsToggle, ofs=0}
				end
				if self.modChkBtns then
					if self.isMnln then
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
				self:skinObject("tabs", {obj=fObj, tabs=fObj.Tabs, lod=self.isTT and true, offsets={x1=3, y1=-1, x2=-3, y2=-4}})
				self:skinObject("frame", {obj=fObj, kfs=true, ri=true, fb=true})

				self:SecureHookScript(_G.MountsJournalConfig, "OnShow", function(frame)
					-- Global settings
					self:skinObject("ddbutton", {obj=frame.modifierCombobox})
					self:skinObject("frame", {obj=frame.leftPanel, kfs=true, fb=true})
					self:skinObject("scrollbar", {obj=frame.rightPanelScroll.ScrollBar})
					self:skinObject("frame", {obj=frame.rightPanel, kfs=true, fb=true})
					if self.isMnln then
						self:skinObject("ddbutton", {obj=frame.repairMountsCombobox})
						self:skinObject("frame", {obj=frame.herbGroup, kfs=true, fb=true})
						self:skinObject("ddbutton", {obj=frame.magicBroomCombobox})
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
					self:skinObject("frame", {obj=frame.mountListGroup, kfs=true, fb=true})
					self:skinObject("frame", {obj=frame.tooltipGroup, kfs=true, fb=true})
					if self.modBtns then
						self:skinStdButton{obj=frame.bindSummon1Key1}
						self:skinStdButton{obj=frame.bindSummon1Key2}
						self:skinStdButton{obj=frame.bindSummon2Key1}
						self:skinStdButton{obj=frame.bindSummon2Key2}
						self:skinStdButton{obj=frame.bindMount}
						self:skinStdButton{obj=frame.bindSecondMount}
						if self.isMnln then
							self:skinStdButton{obj=frame.resetHelp}
						else
							self:skinStdButton{obj=frame.createMacroBtn}
							self:skinStdButton{obj=frame.createSecondMacroBtn}
						end
						self:skinStdButton{obj=frame.cancelBtn, schk=true}
						self:skinStdButton{obj=frame.applyBtn, schk=true}
					end
					if self.modBtnBs then
						self:addButtonBorder{obj=frame.summon1Icon, ofs=3}
						self:addButtonBorder{obj=frame.summon2Icon, ofs=3}
					end
					if self.modChkBtns then
						self:skinCheckButton{obj=frame.waterJump}
						if self.isMnln then
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
						if self.isMnln then
							self:skinCheckButton{obj=frame.coloredMountNames}
						end
						self:skinCheckButton{obj=frame.arrowButtons}
						self:skinCheckButton{obj=frame.showTypeSelBtn}
						self:skinCheckButton{obj=frame.copyMountTarget}
						self:skinCheckButton{obj=frame.openLinks}
						self:skinCheckButton{obj=frame.showWowheadLink}
						self:skinCheckButton{obj=frame.statisticCollection}
						self:skinCheckButton{obj=frame.tooltipMount}
						self:skinCheckButton{obj=frame.tooltipItems}
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

				self:SecureHookScript(_G.MountsJournalConfigRules, "OnShow", function(frame)
					self:skinObject("editbox", {obj=frame.searchBox, si=true})
					self:skinObject("ddbutton", {obj=frame.snippetToggle, filter=true})
					if not aObj.isMnln then
						self:skinObject("dropdown", {obj=frame.summons, x1=1, y1=2, x2=-1, y2=0})
					else
						self:skinObject("ddbutton", {obj=frame.summons})
					end
					if self.modBtns then
						self:skinStdButton{obj=frame.ruleSets}
						self:skinStdButton{obj=frame.addRuleBtn}
						self:skinStdButton{obj=frame.importRuleBtn}
						self:skinStdButton{obj=frame.resetRulesBtn}
					end
					if self.modChkBtns then
						self:skinCheckButton{obj=frame.altMode}
					end

					local skinOptionBtn = _G.nop
					if self.modBtns then
						local function skinOptionBtn(btn)
							aObj:removeBackdrop(btn)
							aObj:skinStdButton{obj=btn, ofs=-2, x1=-2, x2=2}
							btn:GetNormalTexture():SetAlpha(1)
						end
					end
					local function skinOptionEB(eBox)
						aObj:removeBackdrop(eBox)
						aObj:removeInset(eBox.border)
						aObj:skinObject("editbox", {obj=eBox, y1=-4, y2=4})
					end
					self:SecureHookScript(frame.ruleEditor, "OnShow", function(ruleEditor)
						self:skinObject("frame", {obj=ruleEditor.panel, kfs=true, fb=true})
					    self:skinObject("frame", {obj=ruleEditor, kfs=true})
					    if self.modBtns then
					    	self:skinStdButton{obj=ruleEditor.cancel}
					    	self:skinStdButton{obj=ruleEditor.ok, schk=true}
					    end
					    self:skinObject("scrollbar", {obj=ruleEditor.scrollBar, fType=ftype})
					    local function skinElement(...)
					    	local _, element, elementData
					    	if _G.select("#", ...) == 2 then
					    		element, elementData = ...
					    	else
					    		_, element, elementData = ...
					    	end
					    	aObj:removeBackdrop(element)
					    	if aObj.modChkBtns then
					    		aObj:skinCheckButton{obj=element.notCheck}
					    	end
					    end
					    _G.ScrollUtil.AddInitializedFrameCallback(ruleEditor.scrollBox, skinElement, aObj, true)

						skinOptionBtn(ruleEditor.actionPanel.optionType)
						self:SecureHook(ruleEditor, "setCondValueOption", function(rEd, panel, btnData)
							skinOptionBtn(panel.optionType)
							if panel.optionValue then
								if panel.optionValue.border then
									skinOptionEB(panel.optionValue)
								else
									skinOptionBtn(panel.optionValue)
								end
							end
						end)
						local panel
						self:SecureHook(frame.ruleEditor, "setActionValueOption", function(rEd)
							if panel.optionValue then
								if panel.optionValue == panel.macro then
									self:skinObject("scrollbar", {obj=panel.macro.scrollBar})
									self:skinObject("frame", {obj=panel.macro, kfs=true, fb=true})
								elseif panel.optionValue.border then
									skinOptionEB(panel.optionValue)
								else
									skinOptionBtn(panel.optionValue)
								end
							end
						end)

					    self:Unhook(ruleEditor, "OnShow")
					end)

					self:Unhook(frame, "OnShow")
				end)

				self:SecureHook(_G.MountsJournalConfigClasses, "showClassSettings", function(frame, _)
					-- N.B. no sliders currently used (Retail ONLY)
					-- for slider in frame.sliderPool:EnumerateActive() do
					-- end
					if self.modChkBtns then
						for cBox in frame.checkPool:EnumerateActive() do
							self:skinCheckButton{obj=cBox}
						end
					end

				end)

				self:Unhook(fObj, "OnShow")
			end)

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(mjFrame.bgFrame)

		self:Unhook(mjFrame, "init")
	end)

	self:SecureHookScript(_G.MountsJournalSnippets, "OnShow", function(snippets)
		if not aObj.isMnln then
			snippets.TitleContainer.TitleBg:SetTexture(nil)
		end
		self:skinObject("editbox", {obj=snippets.searchBox, si=true})
		self:skinObject("frame", {obj=snippets.bg, kfs=true, fb=true, ofs=0})
	    self:skinObject("frame", {obj=snippets, kfs=true, ofs=1, x1=4})
	    if self.modBtns then
	    	self:skinStdButton{obj=snippets.addSnipBtn}
	    	self:skinStdButton{obj=snippets.importBtn}
	    end
		self:skinObject("scrollbar", {obj=snippets.scrollBar, fType=ftype})
		local function skinElement(...)
			local _, element, elementData
			if _G.select("#", ...) == 2 then
				element, elementData = ...
			else
				_, element, elementData = ...
			end
			aObj:keepFontStrings(element)
			element.codeBG:SetTexture(nil)
		end
		_G.ScrollUtil.AddInitializedFrameCallback(snippets.scrollBox, skinElement, aObj, true)


	    self:Unhook(snippets, "OnShow")
	end)

	self:SecureHookScript(_G.MountsJournalCodeEdit, "OnShow", function(this)
		self:skinObject("editbox", {obj=this.nameEdit})
		self:skinObject("editbox", {obj=this.line})
		self:skinObject("frame", {obj=this.codeBtn, kfs=true, fb=true})
	    self:skinObject("frame", {obj=this, kfs=true, cb=true})
	    if self.modBtns then
	    	self:skinStdButton{obj=this.examples}
	    	self:skinStdButton{obj=this.settings}
	    	self:skinStdButton{obj=this.completeBtn}
	    	self:skinStdButton{obj=this.cancelBtn}
	    end
	    if self.modBtnBs then
	    	self:addButtonBorder{obj=this.nextBtn, bd=5, ofs=0, y1=-1, y2=2}
	    	self:addButtonBorder{obj=this.backBtn, bd=5, ofs=0, y1=-1, y2=2}
	    end

	    self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.MountsJournalDataDialog, "OnShow", function(this)
		if not aObj.isMnln then
			this.TitleContainer.TitleBg:SetTexture(nil)
		end
		self:skinObject("frame", {obj=this.codeBtn, kfs=true, fb=true, ofs=0})
		self:skinObject("scrollbar", {obj=this.scrollBar})
	    self:skinObject("frame", {obj=this, kfs=true, cb=true})
	    if self.modBtns then
	    	self:skinStdButton{obj=this.btn1, schk=true}
	    	self:skinStdButton{obj=this.btn2}
	    end

	    self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.MJTooltipModel, "OnShow", function(this)
		self:skinObject("frame", {obj=this, kfs=true, ofs=0})

		self:Unhook(this, "OnShow")
	end)

	if self.isMnln then
		_G.C_Timer.After(0.1, function()
		    self:add2Table(self.ttList, _G.MountsJournalUITooltip)
		end)
	end

end
