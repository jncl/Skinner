local _, aObj = ...
if not aObj:isAddonEnabled("MountsJournal") then return end
local _G = _G

aObj.addonsToSkin.MountsJournal = function(self) -- v 9.2.12/3.4.18

	self:SecureHook(_G.MountsJournalFrame, "init", function(this)
		self:removeInset(this.mountCount)
		if not self.isClsc then
			this.achiev:DisableDrawLayer("BACKGROUND")
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
		self:skinObject("slider", {obj=this.scrollFrame.scrollBar, ofs=0, clr="grey"})
		for _, btn in _G.pairs(this.scrollFrame.buttons) do
			btn.defaultList.btn.background:SetTexture(nil)
		end
		if not self.isClsc then
			this.mountDisplay.info.petSelectionBtn.infoFrame.levelBG:SetTexture(nil)
		end
		self:removeInset(this.bgFrame.rightInset)
		this.mountDisplay:DisableDrawLayer("BACKGROUND")
		this.mountDisplay.shadowOverlay:DisableDrawLayer("OVERLAY")
		self:skinObject("dropdown", {obj=this.mountDisplay.modelScene.animationsCombobox, x1=1, y1=2, x2=-1, y2=0})
		if not self.isClsc then
			this.mountDisplay.modelScene.playerToggle.border:SetTexture(nil)
		end
		self:SecureHookScript(this.mountDisplay.info.petSelectionBtn, "onClick", function(fObj)
			self:removeInset(fObj.petSelectionList.controlPanel)
			self:skinObject("editbox", {obj=fObj.petSelectionList.searchBox, si=true})
			if not aObj.isClsc then
				self:removeInset(fObj.petSelectionList.filtersPanel)
			end
			self:removeInset(fObj.petSelectionList.controlButtons)
			self:removeInset(fObj.petSelectionList.petListFrame)
			self:skinObject("slider", {obj=fObj.petSelectionList.listScroll.scrollBar})
			for _, btn in _G.pairs(fObj.petSelectionList.listScroll.buttons) do
				btn.background:SetTexture(nil)
			end
			fObj.petSelectionList.randomFavoritePet.background:SetTexture(nil)
			fObj.petSelectionList.randomPet.background:SetTexture(nil)
			fObj.petSelectionList.noPet.background:SetTexture(nil)
			self:skinObject("frame", {obj=fObj.petSelectionList, kfs=true, cb=true, x1=-1, y2=-1})

			self:Unhook(fObj, "oOnClick")
		end)
		self:removeInset(this.worldMap)
		self:skinObject("dropdown", {obj=this.worldMap.navigation, x1=1, y1=2, x2=-1, y2=0})
		self:removeInset(this.mapSettings)
		self:removeInset(this.mapSettings.mapControl)
		self:skinObject("editbox", {obj=this.mapSettings.existingLists.searchBox, si=true})
		self:skinObject("slider", {obj=this.mapSettings.existingLists.scrollFrame.ScrollBar})
		self:skinObject("frame", {obj=this.mapSettings.existingLists, kfs=true, x1=-1, y2=-1})
		self:skinObject("slider", {obj=this.weightFrame.slider})
		self:skinObject("frame", {obj=this.bgFrame, kfs=true, cb=true, x2=3, y2=-1})
		if self.modBtns then
			self:skinStdButton{obj=this.summonButton}
			self:skinStdButton{obj=this.bgFrame.btnConfig}
			self:skinStdButton{obj=this.bgFrame.profilesMenu, clr="grey"}
			self:skinStdButton{obj=this.filtersButton, clr="grey"}
			self:skinStdButton{obj=this.mapSettings.dnr, clr="grey"}
			self:skinStdButton{obj=this.mapSettings.CurrentMap}
			-- TODO: skin frame.mapSettings.existingLists.lists (minusplus frames)
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
			end
			self:addButtonBorder{obj=this.bgFrame.summon2, sabt=true, ofs=3}
			self:addButtonBorder{obj=this.bgFrame.summon1, sabt=true, ofs=3}
			self:addButtonBorder{obj=this.filtersPanel.btnToggle, ofs=1, clr="grey"}
			self:addButtonBorder{obj=this.filtersPanel.gridToggleButton, ofs=1, clr="grey"}
			self:addButtonBorder{obj=this.mountDisplay.info, relTo=this.mountDisplay.info.icon, clr="white"}
			-- TODO: add button border to frame.mountDisplay.info.petSelectionBtn.infoFrame
			self:addButtonBorder{obj=this.mapSettings.existingListsToggle, ofs=0}
		end
		if self.modChkBtns then
			if not self.isClsc then
				self:skinCheckButton{obj=this.useMountsJournalButton}
				self:skinCheckButton{obj=this.mapSettings.HerbGathering}
			end
			self:skinCheckButton{obj=this.mapSettings.Flags}
			self:skinCheckButton{obj=this.mapSettings.Ground}
			self:skinCheckButton{obj=this.mapSettings.WaterWalk}
		end

		self:Unhook(this, "init")
	end)

	local pCnt = 0
	self.RegisterCallback("MountsJournal", "IOFPanel_Before_Skinning", function(_, panel)
		if panel.name ~= "MountsJournal"
		and panel.parent ~= "MountsJournal"
		then
			return
		end
		if not self.iofSkinnedPanels[panel] then
			if panel.name == "MountsJournal" then
				self.iofSkinnedPanels[panel] = true
				pCnt = pCnt + 1
				local leftFrame = self:getChild(panel, 1)
				local rightFrame = self:getChild(panel, 2)
				self:skinObject("dropdown", {obj=panel.modifierCombobox, x1=1, y1=2, x2=-1, y2=0})
				self:skinObject("frame", {obj=leftFrame, kfs=true, fb=true})
				local rightPanelScroll = self:getChild(rightFrame, 1)
				self:skinObject("slider", {obj=rightPanelScroll.ScrollBar})
				self:skinObject("dropdown", {obj=panel.repairMountsCombobox, x1=1, y1=2, x2=-1, y2=0})
				-- TODO: change colour of Combobox when disabled
				self:skinObject("frame", {obj=rightFrame, kfs=true, fb=true})
				if self.modBtns then
					self:skinStdButton{obj=panel.createMacroBtn}
					self:skinStdButton{obj=panel.bindMount, seca=true}
					self:skinStdButton{obj=panel.createSecondMacroBtn}
					self:skinStdButton{obj=panel.bindSecondMount, seca=true}
					if not self.isClsc then
						self:skinStdButton{obj=panel.resetHelp}
						-- self:skinStdButton{obj=self:getLastChild(rightPanelScroll.child)} -- reset tutorials
					end
					self:skinStdButton{obj=panel.applyBtn, schk=true}
				end
				if self.modChkBtns then
					if not self.isClsc then
						self:skinCheckButton{obj=panel.waterJump}
						self:skinCheckButton{obj=panel.useHerbMounts}
						self:skinCheckButton{obj=panel.herbMountsOnZones}
					else
						self:skinCheckButton{obj=panel.showMinimapButton}
						self:skinCheckButton{obj=panel.lockMinimapButton}
					end
					self:skinCheckButton{obj=panel.useRepairMounts}
					self:skinCheckButton{obj=panel.repairFlyable}
					self:skinCheckButton{obj=panel.useMagicBroom}
					self:skinCheckButton{obj=panel.noPetInRaid}
					self:skinCheckButton{obj=panel.noPetInGroup}
					self:skinCheckButton{obj=panel.copyMountTarget}
					self:skinCheckButton{obj=panel.arrowButtons}
					self:skinCheckButton{obj=panel.openLinks}
				end
			elseif panel.name == "Class settings" then
				self.iofSkinnedPanels[panel] = true
				pCnt = pCnt + 1
				local leftFrame = self:getChild(panel, 1)
				self:skinObject("frame", {obj=leftFrame, kfs=true, fb=true})
				local rightPanelScroll = self:getChild(panel.rightPanel, 1)
				self:skinObject("slider", {obj=rightPanelScroll.ScrollBar})
				self:skinObject("scrollbar", {obj=panel.moveFallMF.scrollBar})
				self:skinObject("frame", {obj=panel.moveFallMF.background, kfs=true, fb=true})
				self:skinObject("frame", {obj=panel.combatMF.background, kfs=true, fb=true})
				self:skinObject("frame", {obj=panel.rightPanel, kfs=true, fb=true})
				if self.modBtns then
					self:skinStdButton{obj=panel.moveFallMF.defaultBtn}
					self:skinStdButton{obj=panel.moveFallMF.saveBtn}
					self:skinStdButton{obj=panel.moveFallMF.cancelBtn}
					self:skinStdButton{obj=panel.combatMF.defaultBtn}
					self:skinStdButton{obj=panel.combatMF.saveBtn}
					self:skinStdButton{obj=panel.combatMF.cancelBtn}
				end
				if self.modChkBtns then
					self:skinCheckButton{obj=panel.moveFallMF.enable}
					self:skinCheckButton{obj=panel.combatMF.enable}
					if not self.isClsc then
						self:skinCheckButton{obj=self:getLastChild(self:getPenultimateChild(panel))} -- current character
					end
				end
			end
		end

		if pCnt == 2 then
			self.UnregisterCallback("MountsJournal", "IOFPanel_Before_Skinning")
		end
	end)

end
