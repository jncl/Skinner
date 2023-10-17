local _, aObj = ...
if not aObj:isAddonEnabled("MountsJournal") then return end
local _G = _G

aObj.addonsToSkin.MountsJournal = function(self) -- v 10.1.12/3.4.34

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
		aObj:Debug("MountsJournalFrame init")
		local this = mjFrame.bgFrame
		self:removeInset(this.mountCount)
		if not self.isClsc then
			this.achiev:DisableDrawLayer("BACKGROUND")
			this.slotButton:DisableDrawLayer("BACKGROUND")
		end
		this.navBar:DisableDrawLayer("BACKGROUND")
		this.navBar:DisableDrawLayer("BORDER")
		this.navBar.overlay:DisableDrawLayer("OVERLAY")
		self:skinNavBarButton(this.navBar.home)
		this.navBar.home.text:SetPoint("RIGHT", -20, 0)
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
		self:removeInset(this.shownPanel)
		self:removeInset(this.leftInset)
		self:skinObject("scrollbar", {obj=this.scrollBar})
		local function skinMount(...)
			local _, element, new
			if _G.select("#", ...) == 2 then
				element, _ = ...
			elseif _G.select("#", ...) == 3 then
				element, _, new = ...
			else
				_, element, _, new = ...
			end
			if new ~= false then
				if element.mounts then
					if self.modBtnBs then
						for _, btn in _G.pairs(element.mounts) do
							self:addButtonBorder{obj=btn, relTo=btn.icon, reParent={btn.favorite}, clr="grey"}
						end
					end
				else
					element.background:SetTexture(nil)
					if self.modBtnBs then
						self:addButtonBorder{obj=element.dragButton, relTo=element.dragButton.Icon, reParent={element.dragButton.favorite}, clr="grey"}
					end
				end
			end
		end
		_G.ScrollUtil.AddAcquiredFrameCallback(this.scrollBox, skinMount, aObj, true)
		self:removeInset(this.rightInset)
		this.mountDisplay:DisableDrawLayer("BACKGROUND")
		this.mountDisplay.shadowOverlay:DisableDrawLayer("OVERLAY")
		self:skinObject("dropdown", {obj=this.mountDisplay.modelScene.animationsCombobox, x1=1, y1=2, x2=-1, y2=0})
		if not self.isClsc then
			this.mountDisplay.modelScene.playerToggle.border:SetTexture(nil)
			this.mountDisplay.info.petSelectionBtn.infoFrame.levelBG:SetTexture(nil)
		end
		this.mountDisplay.info.petSelectionBtn.bg:SetTexture(nil)
		this.mountDisplay.info.petSelectionBtn.border:SetTexture(nil)
		self:SecureHookScript(this.mountDisplay.info.petSelectionBtn, "onClick", function(fObj)
			local psl = fObj.petSelectionList
			self:removeInset(psl.controlPanel)
			self:skinObject("editbox", {obj=psl.searchBox, si=true})
			if not aObj.isClsc then
				self:removeInset(psl.filtersPanel)
			end
			self:removeInset(psl.controlButtons)
			self:removeInset(psl.petListFrame)
			if not self.isClsc then
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
					end
				end
				_G.ScrollUtil.AddAcquiredFrameCallback(psl.petListFrame.scrollBox, skinPet, aObj, true)
			else
				self:skinObject("slider", {obj=psl.listScroll.scrollBar})
				for _, btn in _G.pairs(psl.listScroll.buttons) do
					btn.background:SetTexture(nil)
				end
			end
			this.randomFavoritePet.background:SetTexture(nil)
			this.randomPet.background:SetTexture(nil)
			this.noPet.background:SetTexture(nil)
			self:skinObject("frame", {obj=this, kfs=true, cb=true, x1=-1, y2=self.isClsc and -1 or -2})
			-- TODO: skin button borders

			self:Unhook(fObj, "oOnClick")
		end)
		self:removeInset(this.worldMap)
		self:skinObject("dropdown", {obj=this.worldMap.navigation, x1=1, y1=2, x2=-1, y2=-2})
		self:removeInset(this.mapSettings)
		self:removeInset(this.mapSettings.mapControl)
		self:skinObject("editbox", {obj=this.mapSettings.existingLists.searchBox, si=true})
		self:skinObject("scrollbar", {obj=this.mapSettings.existingLists.scrollFrame.ScrollBar})
		self:skinObject("frame", {obj=this.mapSettings.existingLists, kfs=true, x1=-1, y2=self.isClsc and -1 or -2})
		if self.isClsc then
			self:skinObject("editbox", {obj=this.mountsWeight.edit})
			self:skinObject("slider", {obj=this.mountsWeight.slider})
		end
		self:skinObject("frame", {obj=this, kfs=true, cb=true, x2=3, y2=-1})
		if self.modBtns then
			self:skinStdButton{obj=this.summonButton}
			self:skinStdButton{obj=this.btnConfig}
			self:skinStdButton{obj=this.profilesMenu, clr="grey"}
			self:skinStdButton{obj=mjFrame.filtersButton, clr="grey"}
			self:skinStdButton{obj=this.mapSettings.dnr, clr="grey"}
			self:skinStdButton{obj=this.mapSettings.CurrentMap}
			-- TODO: skin frame.mapSettings.existingLists.lists (.toggle checkbutton)
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
			self:addButtonBorder{obj=this.navBarBtn, clr="grey", ofs=0, x1=3, x2=-3} -- map / model toggle
			if not self.isClsc then
				self:addButtonBorder{obj=this.mountDisplay.info.mountDescriptionToggle, ofs=0}
				self:addButtonBorder{obj=this.slotButton, relTo=this.slotButton.ItemIcon, reParent={this.slotButton.SlotBorder, this.slotButton.SlotBorderOpen}, clr="grey", ca=0.85}
			end
			self:addButtonBorder{obj=this.summon2, sabt=true, ofs=3}
			self:addButtonBorder{obj=this.summon1, sabt=true, ofs=3}
			self:addButtonBorder{obj=this.filtersPanel.btnToggle, ofs=1, clr="grey"}
			self:addButtonBorder{obj=this.filtersPanel.gridToggleButton, ofs=1, clr="grey"}
			self:addButtonBorder{obj=this.mountDisplay.info, relTo=this.mountDisplay.info.icon, clr="white"}
			self:addButtonBorder{obj=this.mountDisplay.info.petSelectionBtn, relTo=this.mountDisplay.info.petSelectionBtn, clr="grey"}
			self:addButtonBorder{obj=this.mapSettings.existingListsToggle, ofs=0}
		end
		if self.modChkBtns then
			if not self.isClsc then
				self:skinCheckButton{obj=mjFrame.useMountsJournalButton}
				self:skinCheckButton{obj=this.mapSettings.HerbGathering}
			end
			self:skinCheckButton{obj=this.mapSettings.Flags}
			self:skinCheckButton{obj=this.mapSettings.Ground}
			self:skinCheckButton{obj=this.mapSettings.WaterWalk}
		end

		self:Unhook(this, "init")
	end)

	self:SecureHookScript(_G.MJTooltipModel, "OnShow", function(this)
		self:skinObject("frame", {obj=this, kfs=true, ofs=0})

		self:Unhook(this, "OnShow")
	end)

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
				self:skinObject("dropdown", {obj=panel.modifierCombobox, x1=1, y1=2, x2=-1, y2=0})
				self:skinObject("frame", {obj=leftFrame, kfs=true, fb=true})
				local rightPanelScroll = self:getChild(rightFrame, 1)
				self:skinObject("scrollbar", {obj=rightPanelScroll.ScrollBar})
				self:skinObject("dropdown", {obj=panel.repairMountsCombobox, x1=1, y1=2, x2=-1, y2=0})
				-- TODO: change colour of Combobox when disabled
				self:skinObject("frame", {obj=rightFrame, kfs=true, fb=true})
				if self.modBtns then
					self:skinStdButton{obj=panel.createMacroBtn}
					self:skinStdButton{obj=panel.bindMount, seca=true}
					self:skinStdButton{obj=panel.createSecondMacroBtn}
					self:skinStdButton{obj=panel.bindSecondMount, seca=true}
					if not self.isClsc then
						self:skinStdButton{obj=panel.resetHelp, schk=true}
					end
					self:skinStdButton{obj=panel.applyBtn, schk=true}
					self:skinStdButton{obj=panel.cancelBtn, schk=true}
				end
				if self.modChkBtns then
					if not self.isClsc then
						self:skinCheckButton{obj=panel.waterJump}
						self:skinCheckButton{obj=panel.useHerbMounts}
						self:skinCheckButton{obj=panel.herbMountsOnZones}
						self:skinCheckButton{obj=panel.useUnderlightAngler}
						self:skinCheckButton{obj=panel.autoUseUnderlightAngler}
						self:skinCheckButton{obj=panel.showWowheadLink}
					else
						self:skinCheckButton{obj=panel.showMinimapButton}
						self:skinCheckButton{obj=panel.lockMinimapButton}
					end
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
				if not self.isClsc then
					for frame in panel.sliderPool:EnumerateActive() do
						self:skinObject("editbox", {obj=frame.edit})
						self:skinObject("slider", {obj=frame.slider})
					end
				end
				self:SecureHook(panel, "showClassSettings", function(this, _)
					if not self.isClsc then
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
