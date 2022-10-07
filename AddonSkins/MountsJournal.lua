local _, aObj = ...
if not aObj:isAddonEnabled("MountsJournal") then return end
local _G = _G

aObj.addonsToSkin.MountsJournal = function(self) -- v 9.1.16

	self:SecureHook(_G.MountsJournalFrame, "init", function(this)
		local frame = _G.MountsJournalFrame.bgFrame
		self:removeInset(frame.mountCount)
		frame.achiev:DisableDrawLayer("BACKGROUND")
		frame.navBar:DisableDrawLayer("BACKGROUND")
		frame.navBar:DisableDrawLayer("BORDER")
		frame.navBar.overlay:DisableDrawLayer("OVERLAY")
		self:skinNavBarButton(frame.navBar.home)
		frame.navBar.home.text:SetPoint("RIGHT", -20, 0)
		self:removeInset(frame.filtersPanel)
		self:skinObject("editbox", {obj=frame.filtersPanel.searchBox, si=true})
		self:skinObject("tabs", {obj=frame.filtersPanel.filtersBar, tabs=frame.filtersPanel.filtersBar.tabs, ignoreSize= true, lod=self.isTT and true, regions={4, 5, 6, 7, 8}, offsets={x1=3, y1=0, x2=-3, y2=0}, track=false, func=self.isTT and function(tab)
			tab.selected:DisableDrawLayer("ARTWORK")
			self:SecureHook(tab.selected, "Show", function(this)
				self:setActiveTab(this:GetParent().sf)
			end)
			self:SecureHook(tab.selected, "Hide", function(this)
				self:setInactiveTab(this:GetParent().sf)
			end)
		end})
		self:skinObject("frame", {obj=frame.filtersPanel.filtersBar, kfs=true})
		self:removeInset(frame.shownPanel)
		self:removeInset(frame.leftInset)
		self:skinObject("slider", {obj=frame.scrollFrame.scrollBar, ofs=0, clr="grey"})
		for _, btn in _G.pairs(frame.scrollFrame.buttons) do
			btn.defaultList.btn.background:SetTexture(nil)
		end
		self:removeInset(frame.rightInset)
		frame.mountDisplay.info.petSelectionBtn.infoFrame.levelBG:SetTexture(nil)
		frame.mountDisplay:DisableDrawLayer("BACKGROUND")
		frame.mountDisplay.shadowOverlay:DisableDrawLayer("OVERLAY")
		self:skinObject("dropdown", {obj=frame.mountDisplay.modelScene.animationsCombobox, x1=1, y1=2, x2=-1, y2=0})
		frame.mountDisplay.modelScene.playerToggle.border:SetTexture(nil)
		self:SecureHookScript(frame.mountDisplay.info.petSelectionBtn, "OnClick", function(this)
			self:removeInset(this.petSelectionList.controlPanel)
			self:skinObject("editbox", {obj=this.petSelectionList.searchBox, si=true})
			self:removeInset(this.petSelectionList.filtersPanel)
			self:removeInset(this.petSelectionList.controlButtons)
			self:removeInset(this.petSelectionList.petListFrame)
			self:skinObject("slider", {obj=this.petSelectionList.listScroll.scrollBar})
			for _, btn in _G.pairs(this.petSelectionList.listScroll.buttons) do
				btn.background:SetTexture(nil)
			end
			this.petSelectionList.randomFavoritePet.background:SetTexture(nil)
			this.petSelectionList.randomPet.background:SetTexture(nil)
			this.petSelectionList.noPet.background:SetTexture(nil)
			self:skinObject("frame", {obj=this.petSelectionList, kfs=true, cb=true, x1=-1, y2=-1})

			self:Unhook(this, "OnClick")
		end)
		self:removeInset(frame.worldMap)
		self:skinObject("dropdown", {obj=frame.worldMap.navigation, x1=1, y1=2, x2=-1, y2=0})
		self:removeInset(frame.mapSettings)
		self:removeInset(frame.mapSettings.mapControl)
		self:skinObject("editbox", {obj=frame.mapSettings.existingLists.searchBox, si=true})
		self:skinObject("slider", {obj=frame.mapSettings.existingLists.scrollFrame.ScrollBar})
		self:skinObject("frame", {obj=frame.mapSettings.existingLists, kfs=true, x1=-1, y2=-1})
		self:skinObject("slider", {obj=frame.mountsWeight.slider})
		self:skinObject("frame", {obj=frame, kfs=true, cb=true, x2=3, y2=-1})
		if self.modBtns then
			self:skinStdButton{obj=frame.summonButton}
			self:skinStdButton{obj=frame.btnConfig}
			self:skinStdButton{obj=self:getLastChild(frame.filtersPanel)}
			self:skinStdButton{obj=frame.profilesMenu}
			self:skinStdButton{obj=self:getLastChild(frame.mapSettings)}
			self:skinStdButton{obj=frame.mapSettings.CurrentMap}
			-- TODO: skin frame.mapSettings.existingLists.lists (minusplus frames)
			local function skinFilterBtn(btn)
				aObj:skinObject("frame", {obj=btn, kfs=true})
				btn.icon:SetAlpha(1)
				btn.icon:SetParent(btn.sf)
				btn.icon:SetDrawLayer("ARTWORK")
			end
			for _, btn in _G.pairs(frame.filtersPanel.filtersBar.types.childs) do
				skinFilterBtn(btn)
			end
			for _, btn in _G.pairs(frame.filtersPanel.filtersBar.selected.childs) do
				skinFilterBtn(btn)
			end
			for _, btn in _G.pairs(frame.filtersPanel.filtersBar.sources.childs) do
				skinFilterBtn(btn)
			end
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=frame.navBarBtn, clr="grey", ofs=0, x1=3, x2=-3} -- map / model toggle
			self:addButtonBorder{obj=frame.summon2, sabt=true, ofs=3}
			self:addButtonBorder{obj=frame.summon1, sabt=true, ofs=3}
			self:addButtonBorder{obj=frame.filtersPanel.btnToggle, ofs=1}
			self:addButtonBorder{obj=frame.filtersPanel.gridToggleButton, ofs=1}
			self:addButtonBorder{obj=frame.mountDisplay.info, relTo=frame.mountDisplay.info.icon, clr="white"}
			self:addButtonBorder{obj=frame.mountDisplay.info.mountDescriptionToggle, ofs=0}
			-- TODO: add button border to frame.mountDisplay.info.petSelectionBtn.infoFrame
			self:addButtonBorder{obj=frame.mapSettings.existingListsToggle, ofs=0}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.MountsJournalFrame.useMountsJournalButton}
			self:skinCheckButton{obj=frame.mapSettings.Flags}
			self:skinCheckButton{obj=frame.mapSettings.Ground}
			self:skinCheckButton{obj=frame.mapSettings.WaterWalk}
			self:skinCheckButton{obj=frame.mapSettings.HerbGathering}
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
					self:skinStdButton{obj=self:getChild(leftFrame, 2)} -- summons 1 create macro
					self:skinStdButton{obj=self:getChild(leftFrame, 6)} -- summons 2 create macro
					self:skinStdButton{obj=panel.applyBtn}
					self:SecureHook(panel.applyBtn, "Disable", function(bObj, _)
						self:clrBtnBdr(bObj)
					end)
					self:SecureHook(panel.applyBtn, "Enable", function(bObj, _)
						self:clrBtnBdr(bObj)
					end)
					self:skinStdButton{obj=panel.bindMount, seca=true}
					self:skinStdButton{obj=panel.bindSecondMount, seca=true}
					self:skinStdButton{obj=self:getLastChild(rightPanelScroll.child)} -- reset tutorials
				end
				if self.modChkBtns then
					self:skinCheckButton{obj=panel.arrowButtons}
					self:skinCheckButton{obj=panel.copyMountTarget}
					self:skinCheckButton{obj=panel.herbMountsOnZones}
					self:skinCheckButton{obj=panel.noPetInGroup}
					self:skinCheckButton{obj=panel.noPetInRaid}
					self:skinCheckButton{obj=panel.repairFlyable}
					self:skinCheckButton{obj=panel.useHerbMounts}
					self:skinCheckButton{obj=panel.useMagicBroom}
					self:skinCheckButton{obj=panel.useRepairMounts}
					self:skinCheckButton{obj=panel.waterJump}
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
					self:skinCheckButton{obj=self:getLastChild(self:getPenultimateChild(panel))} -- current character
				end
			end
		end

		if pCnt == 2 then
			self.UnregisterCallback("MountsJournal", "IOFPanel_Before_Skinning")
		end
	end)

end
