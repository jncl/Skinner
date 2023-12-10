local _, aObj = ...

local _G = _G
-- luacheck: ignore 631 (line is too long)

local ftype = "p"

if not aObj.isClscERA then
	aObj.blizzLoDFrames[ftype].Collections = function(self)
		if not self.prdb.Collections or self.initialized.Collections then return end
		self.initialized.Collections = true

		self:SecureHookScript(_G.CollectionsJournal, "OnShow", function(this)
			self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true, selectedTab=this.selectedTab})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, rns=true, cb=true, x2=self.Rtl and 3 or 1, y2=-2})

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.MountJournal, "OnShow", function(this)
			self:removeInset(this.LeftInset)
			if self.isRtl then
				self:removeInset(this.BottomLeftInset)
				self:removeRegions(this.SlotButton, {1, 3})
			end
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
				if self.isRtl then
					self:skinStdButton{obj=this.BottomLeftInset.SuppressedMountEquipmentButton, fType=ftype}
					self:skinCloseButton{obj=_G.MountJournalFilterButton.ResetButton, fType=ftype, noSkin=true}
				end
				self:skinStdButton{obj=_G.MountJournalFilterButton, fType=ftype, clr="grey"}
				self:skinStdButton{obj=this.MountButton, fType=ftype, sechk=true}
			end
			if self.modBtnBs then
				if self.isRtl then
					self:addButtonBorder{obj=this.SlotButton, relTo=this.SlotButton.ItemIcon, reParent={this.SlotButton.SlotBorder, this.SlotButton.SlotBorderOpen}, clr="grey", ca=0.85}
					self:addButtonBorder{obj=this.SummonRandomFavoriteButton, ofs=3}
				else
					self:addButtonBorder{obj=this.MountDisplay.ModelScene.RotateLeftButton, ofs=-3, clr="grey"}
					self:addButtonBorder{obj=this.MountDisplay.ModelScene.RotateRightButton, ofs=-3, clr="grey"}
				end
				self:addButtonBorder{obj=this.MountDisplay.InfoButton, relTo=this.MountDisplay.InfoButton.Icon, clr="white"}
			end
			if self.modChkBtns
			and self.isRtl
			then
				self:skinCheckButton{obj=this.MountDisplay.ModelScene.TogglePlayer}
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.PetJournal, "OnShow", function(this)
			self:removeInset(this.PetCount)
			if self.isRtl then
				this.MainHelpButton.Ring:SetTexture(nil)
				self:moveObject{obj=this.MainHelpButton, y=-4}
				_G.PetJournalHealPetButtonBorder:SetTexture(nil)
			end
			self:removeInset(this.LeftInset)
			if self.isRtl then
				self:removeInset(this.PetCardInset)
			else
				self:removeMagicBtnTex(this.SummonButton)
			end
			self:removeInset(this.RightInset)
			self:skinObject("editbox", {obj=this.searchBox, fType=ftype, si=true})
			if self.modBtns then
				self:skinStdButton{obj=_G.PetJournalFilterButton, fType=ftype, clr="grey"}
				if self.isRtl then
					self:skinCloseButton{obj=_G.PetJournalFilterButton.ResetButton, fType=ftype, noSkin=true}
				else
					self:skinStdButton{obj=this.SummonButton}
				end
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
					if aObj.isRtl then
						aObj:changeTandC(element.dragButton.levelBG)
					end
					if aObj.modBtnBs then
						if aObj.isRtl then
							aObj:addButtonBorder{obj=element, relTo=element.icon, reParent={element.dragButton.levelBG, element.dragButton.level, element.dragButton.favorite}}
						else
							aObj:addButtonBorder{obj=element, relTo=element.icon}
						end
					end
				end
				if aObj.modBtnBs then
					_G.C_Timer.After(0.05, function()
						aObj:clrButtonFromBorder(element)
					end)
				end
			end
			_G.ScrollUtil.AddAcquiredFrameCallback(this.ScrollBox, skinElement, aObj, true)
			if self.isRtl then
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
			else
				this.PetCard.PetBackground:SetAlpha(0)
				this.PetCard.ShadowOverlay:SetAlpha(0)
				if self.modBtnBs then
					self:addButtonBorder{obj=this.PetCard.PetInfo, relTo=this.PetCard.PetInfo.icon, reParent={this.PetCard.PetInfo.favorite}}
					self:addButtonBorder{obj=this.PetCard.modelScene.RotateLeftButton, ofs=-3, clr="grey"}
					self:addButtonBorder{obj=this.PetCard.modelScene.RotateRightButton, ofs=-3, clr="grey"}
				end
			end

			self:Unhook(this, "OnShow")
		end)

		if self.isRtl then
			local function skinTTip(tip)
				tip.Delimiter1:SetTexture(nil)
				tip.Delimiter2:SetTexture(nil)
				tip:DisableDrawLayer("BACKGROUND")
				aObj:skinObject("frame", {obj=tip, fType=ftype, ofs=0})
			end
			skinTTip(_G.PetJournalPrimaryAbilityTooltip)
			skinTTip(_G.PetJournalSecondaryAbilityTooltip)
		end

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
				if self.isRtl then
					self:skinCloseButton{obj=_G.ToyBoxFilterButton.ResetButton, fType=ftype, noSkin=true}
				end
			end
			self:removeInset(this.iconsFrame)
			self:keepFontStrings(this.iconsFrame)
			local btn
			for i = 1, 18 do
				btn = this.iconsFrame["spellButton" .. i]
				btn.slotFrameCollected:SetTexture(nil)
				btn.slotFrameUncollected:SetTexture(nil)
				if self.modBtnBs then
					self:addButtonBorder{obj=btn, reParent={btn.new}, sft=true, ofs=0}
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
				if self.isRtl then
					self:skinCloseButton{obj=this.FilterButton.ResetButton, fType=ftype, noSkin=true}
				end
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
					-- ignore btn.levelBackground as its texture is changed when upgraded
					if self.modBtnBs then
						self:addButtonBorder{obj=frame, sft=true, ofs=0, reParent={frame.new, frame.levelBackground, frame.level}}
						skinCollectionBtn(frame)
					end
				end
			end)
			if self.modBtnBs then
				skinPageBtns(this)
				if self.isRtl then
					self:SecureHook(this, "UpdateButton", function(_, button)
						skinCollectionBtn(button)
						if button.levelBackground:GetAtlas() == "collections-levelplate-black" then
							self:changeTandC(button.levelBackground)
						end
					end)
				end
			end

			self:Unhook(this, "OnShow")
		end)

		if not self.isClsc then
			self:SecureHookScript(_G.WardrobeCollectionFrame, "OnShow", function(this)
				self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true, upwards=true, offsets={x1=2, y1=-4, x2=-2, y2=-4}})
				this.InfoButton.Ring:SetTexture(nil)
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

				if self:isAddOnLoaded("BetterWardrobe") then
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

					local SetsDataProvider = _G.CreateFromMixins(_G.WardrobeSetsDataProviderMixin)
					self:SecureHookScript(this.SetsCollectionFrame, "OnShow", function(fObj)
						self:removeInset(fObj.LeftInset)
						self:keepFontStrings(fObj.RightInset)
						self:removeNineSlice(fObj.RightInset.NineSlice)
						self:skinObject("scrollbar", {obj=fObj.ListContainer.ScrollBar, fType=ftype})
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
								element:DisableDrawLayer("BACKGROUND")
								if aObj.modBtnBs then
									 aObj:addButtonBorder{obj=element, relTo=element.Icon, reParent={element.Favorite}}
								end
							end
							local displayData = elementData
							if elementData.hiddenUntilCollected and not elementData.collected then
								local variantSets = _G.C_TransmogSets.GetVariantSets(elementData.setID);
								if variantSets then
									displayData = variantSets[1]
								end
							end
							local topSourcesCollected, topSourcesTotal = SetsDataProvider:GetSetSourceTopCounts(displayData.setID)
							local setCollected = displayData.collected or topSourcesCollected == topSourcesTotal
							if element.sbb then
								if setCollected then
									aObj:clrBtnBdr(element, "gold")
								else
									aObj:clrBtnBdr(element, topSourcesCollected == 0 and "grey")
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

		if self.isClsc
		and self:isAddOnLoaded("MountsJournal")
		then
			self.callbacks:Fire("Collections_Skinned")
		end

	end
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
		if not self.isRtl then
			self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true, selectedTab=5})
		end
		-- tabs (side)
		local tabs = {"ChatTab", "RosterTab"}
		if self.isRtl then
			aObj:add2Table(tabs, "GuildBenefitsTab")
			aObj:add2Table(tabs, "GuildInfoTab")
		end
		for _, tabName in _G.pairs(tabs) do
			this[tabName]:DisableDrawLayer("BORDER")
			if self.modBtnBs then
				self:addButtonBorder{obj=this[tabName]}
			end
		end
		self:moveObject{obj=this.ChatTab, x=1}
		self:skinObject("dropdown", {obj=this.StreamDropDownMenu, fType=ftype})
		self:skinObject("dropdown", {obj=this.CommunitiesListDropDownMenu, fType=ftype})
		self:skinObject("editbox", {obj=this.ChatEditBox, fType=ftype, y1=-6, y2=6})
		self:moveObject{obj=this.AddToChatButton, x=-6, y=-6}
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true, x1=-5})
		if self.modBtns then
			self:skinStdButton{obj=this.InviteButton, fType=ftype, sechk=true}
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=this.AddToChatButton, ofs=1, clr="gold"}
		end

		self:SecureHookScript(this.MaximizeMinimizeFrame, "OnShow", function(fObj)
			fObj:DisableDrawLayer("BACKGROUND")
			if self.modBtns then
				self:skinOtherButton{obj=fObj.MaximizeButton, font=self.fontS, text=self.nearrow}
				self:skinOtherButton{obj=fObj.MinimizeButton, font=self.fontS, disfont=self.fontDS, text=self.swarrow}
				if self.isRtl then
					self:SecureHook(this, "UpdateMaximizeMinimizeButton", function(frame)
						self:clrBtnBdr(frame.MaximizeMinimizeFrame.MinimizeButton)
					end)
				end
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
			if self.isRtl then
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
			else
				self:skinObject("slider", {obj=fObj.ListScrollFrame.scrollBar, fType=ftype})
				for _, btn in _G.pairs(fObj.ListScrollFrame.buttons) do
					btn.IconRing:SetTexture(nil)
				end
			end

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.CommunitiesList)

		self:SecureHookScript(this.MemberList, "OnShow", function(fObj)
			self:SecureHookScript(fObj.ColumnDisplay, "OnShow", function(frame)
				skinColumnDisplay(frame)
			end)
			self:checkShown(fObj.ColumnDisplay)
			if self.modChkBtns then
				 self:skinCheckButton{obj=fObj.ShowOfflineButton, hf=true}
			end
			self:skinObject("dropdown", {obj=fObj.DropDown, fType=ftype})
			self:removeInset(fObj.InsetFrame)
			if self.isRtl then
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
			else
				self:skinObject("slider", {obj=fObj.ListScrollFrame.scrollBar, fType=ftype})
			end

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.MemberList)

		self:SecureHookScript(this.Chat, "OnShow", function(fObj)
			self:removeInset(fObj.InsetFrame)
			if aObj.isRtl then
				self:skinObject("scrollbar", {obj=fObj.ScrollBar, fType=ftype})
			else
				self:skinObject("slider", {obj=fObj.MessageFrame.ScrollBar, fType=ftype})
			end
			if self.modBtns then
				self:skinStdButton{obj=_G.JumpToUnreadButton, fType=ftype}
			end

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.Chat)

		self:SecureHookScript(this.InvitationFrame, "OnShow", function(fObj)
			self:removeInset(fObj.InsetFrame)
			fObj.IconRing:SetTexture(nil)
			self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, ofs=0})
			if self.modBtns then
				self:skinStdButton{obj=fObj.AcceptButton, fType=ftype}
				self:skinStdButton{obj=fObj.DeclineButton, fType=ftype}
			end

			self:Unhook(fObj, "OnShow")
		end)

		self:SecureHookScript(this.TicketFrame, "OnShow", function(fObj)
			self:removeInset(fObj.InsetFrame)
			fObj.IconRing:SetTexture(nil)
			self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, ofs=0})
			if self.modBtns then
				self:skinStdButton{obj=fObj.AcceptButton, fType=ftype}
				self:skinStdButton{obj=fObj.DeclineButton, fType=ftype}
			end

			self:Unhook(fObj, "OnShow")
		end)

		self:SecureHookScript(this.EditStreamDialog, "OnShow", function(fObj)
			if self.isRtl then
				self:removeNineSlice(fObj.BG)
			end
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
			if self.isRtl then
				self:skinObject("scrollbar", {obj=fObj.ScrollFrame.ScrollBar, fType=ftype})
				self:removeNineSlice(fObj.Selector)
			else
				self:skinObject("slider", {obj=fObj.ScrollFrame.ScrollBar, fType=ftype})
			end
			self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, ofs=-6, x2=-4})
			if self.modBtns then
				self:skinStdButton{obj=fObj.ScrollFrame.Child.NoneButton}
				self:skinStdButton{obj=fObj.ScrollFrame.Child.AllButton}
				if self.isRtl then
					self:skinStdButton{obj=fObj.Selector.CancelButton}
					self:skinStdButton{obj=fObj.Selector.OkayButton}
				else
					self:skinStdButton{obj=fObj.CancelButton}
					self:skinStdButton{obj=fObj.OkayButton}
				end
			end
			if self.modChkBtns then
				 self:skinCheckButton{obj=fObj.ScrollFrame.Child.QuickJoinButton}
			end

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.NotificationSettingsDialog)

		self:SecureHookScript(this.CommunitiesControlFrame, "OnShow", function(fObj)
			if self.modBtns then
				self:skinStdButton{obj=fObj.CommunitiesSettingsButton, fType=ftype}
				if self.isRtl then
					self:skinStdButton{obj=fObj.GuildRecruitmentButton, fType=ftype, sechk=true}
					self:skinStdButton{obj=fObj.GuildControlButton, fType=ftype}
				end
			end

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.CommunitiesControlFrame)

		if self.isRtl then
			self:skinObject("dropdown", {obj=this.GuildMemberListDropDownMenu, fType=ftype})
			self:skinObject("dropdown", {obj=this.CommunityMemberListDropDownMenu, fType=ftype})
			if self.modBtns then
				self:skinStdButton{obj=this.GuildLogButton, fType=ftype}
			end

			self:SecureHookScript(this.ApplicantList, "OnShow", function(fObj)
				fObj:DisableDrawLayer("BACKGROUND")
				fObj:DisableDrawLayer("ARTWORK")
				self:SecureHookScript(fObj.ColumnDisplay, "OnShow", function(frame)
					skinColumnDisplay(frame)
				end)
				self:checkShown(fObj.ColumnDisplay)
				self:skinObject("scrollbar", {obj=fObj.ScrollBar, fType=ftype})
				self:skinObject("dropdown", {obj=fObj.DropDown, fType=ftype})
				self:removeNineSlice(fObj.InsetFrame.NineSlice)
				fObj.InsetFrame.Bg:SetTexture(nil)
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

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.ApplicantList)

			local function skinReqToJoin(frame)
				frame.MessageFrame:DisableDrawLayer("BACKGROUND")
				frame.MessageFrame.MessageScroll:DisableDrawLayer("BACKGROUND")
				aObj:skinObject("frame", {obj=frame.MessageFrame, fType=ftype, kfs=true, fb=true, ofs=4})
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

			self:SecureHookScript(this.ClubFinderInvitationFrame, "OnShow", function(fObj)
				fObj.WarningDialog.BG.Bg:SetTexture(nil)
				self:removeNineSlice(fObj.WarningDialog.BG)
				self:skinObject("frame", {obj=fObj.WarningDialog, fType=ftype, kfs=true, ofs=0})
				if self.modBtns then
					self:skinStdButton{obj=fObj.WarningDialog.Accept, fType=ftype}
					self:skinStdButton{obj=fObj.WarningDialog.Cancel, fType=ftype}
				end
				self:removeInset(fObj.InsetFrame)
				fObj.IconRing:SetTexture(nil)
				self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, ofs=0})
				if self.modBtns then
					self:skinStdButton{obj=fObj.AcceptButton, fType=ftype}
					self:skinStdButton{obj=fObj.ApplyButton, fType=ftype}
					self:skinStdButton{obj=fObj.DeclineButton, fType=ftype}
				end

				self:Unhook(fObj, "OnShow")

			end)

			self:SecureHookScript(this.GuildBenefitsFrame, "OnShow", function(fObj)
				fObj:DisableDrawLayer("OVERLAY")
				self:keepFontStrings(fObj.Perks)
				self:skinObject("scrollbar", {obj=fObj.Perks.ScrollBar, fType=ftype})
				local function skinPerk(...)
					local _, element
					if _G.select("#", ...) == 2 then
						element, _ = ...
					else
						_, element, _ = ...
					end
					aObj:keepFontStrings(element)
					element.Icon:SetAlpha(1)
					if aObj.modBtnBs then
						aObj:addButtonBorder{obj=element, fType=ftype, relTo=element.Icon, clr="grey"}
					end
					aObj:keepFontStrings(element.NormalBorder)
					aObj:keepFontStrings(element.DisabledBorder)
				end
				_G.ScrollUtil.AddInitializedFrameCallback(fObj.Perks.ScrollBox, skinPerk, aObj, true)
				self:keepFontStrings(fObj.Rewards)
				self:skinObject("scrollbar", {obj=fObj.Rewards.ScrollBar, fType=ftype})
				local function skinReward(...)
					local _, element
					if _G.select("#", ...) == 2 then
						element, _ = ...
					else
						_, element, _ = ...
					end
					aObj:skinObject("frame", {obj=element, fType=ftype, kfs=true, clr="sepia"})
					element.Icon:SetAlpha(1)
					if aObj.modBtnBs then
						aObj:addButtonBorder{obj=element, fType=ftype, relTo=element.Icon, clr="grey"}
					end
				end
				_G.ScrollUtil.AddInitializedFrameCallback(fObj.Rewards.ScrollBox, skinReward, aObj, true)
				fObj.FactionFrame.Bar:DisableDrawLayer("BORDER")
				fObj.FactionFrame.Bar.Progress:SetTexture(self.sbTexture)

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.GuildBenefitsFrame)

			self:SecureHookScript(this.GuildDetailsFrame, "OnShow", function(fObj)
				fObj:DisableDrawLayer("OVERLAY")
				self:removeRegions(fObj.Info, {2, 3, 4, 5, 6, 7, 8, 9, 10})
				self:skinObject("scrollbar", {obj=fObj.Info.MOTDScrollFrame.ScrollBar, fType=ftype})
				self:skinObject("scrollbar", {obj=fObj.Info.DetailsFrame.ScrollBar, fType=ftype})
				fObj.News:DisableDrawLayer("BACKGROUND")
				self:skinObject("scrollbar", {obj=fObj.News.ScrollBar, fType=ftype})
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
				_G.ScrollUtil.AddAcquiredFrameCallback(fObj.News.ScrollBox, skinElement, aObj, true)
				self:skinObject("dropdown", {obj=fObj.News.DropDown, fType=ftype})
				self:keepFontStrings(fObj.News.BossModel)
				self:removeRegions(fObj.News.BossModel.TextFrame, {2, 3, 4, 5, 6}) -- border textures

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.GuildDetailsFrame)

			self:SecureHookScript(this.GuildNameAlertFrame, "OnShow", function(fObj)
				self:skinObject("glowbox", {obj=fObj, fType=ftype})

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.GuildNameAlertFrame)

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

			self:SecureHookScript(this.CommunityNameChangeFrame, "OnShow", function(fObj)
				self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, cbns=true, ofs=0})
				if self.modBtns then
					self:skinStdButton{obj=fObj.Button, fType=ftype}
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.CommunityNameChangeFrame)

			self:SecureHookScript(this.GuildPostingChangeFrame, "OnShow", function(fObj)
				self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, cbns=true, ofs=0})
				if self.modBtns then
					self:skinStdButton{obj=fObj.Button, fType=ftype}
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.GuildPostingChangeFrame)

			self:SecureHookScript(this.CommunityPostingChangeFrame, "OnShow", function(fObj)
				self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, cbns=true, ofs=0})
				if self.modBtns then
					self:skinStdButton{obj=fObj.Button, fType=ftype}
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.CommunityPostingChangeFrame)

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

		end

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.CommunitiesFrame)

	self:SecureHookScript(_G.CommunitiesSettingsDialog, "OnShow", function(this)
		this.IconPreviewRing:SetAlpha(0)
		self:skinObject("editbox", {obj=this.NameEdit, fType=ftype})
		self:skinObject("editbox", {obj=this.ShortNameEdit, fType=ftype})
		self:skinObject("frame", {obj=this.MessageOfTheDay, fType=ftype, kfs=true, fb=true, ofs=8, clr="grey"})
		self:skinObject("frame", {obj=this.Description, fType=ftype, kfs=true, fb=true, ofs=8, clr="grey"})
		self:skinObject("frame", {obj=this, fType=ftype, ofs=-10})
		if self.modBtns then
			self:skinStdButton{obj=this.ChangeAvatarButton}
			self:skinStdButton{obj=this.Delete}
			self:skinStdButton{obj=this.Accept}
			self:skinStdButton{obj=this.Cancel}
		end
		if self.isRtl then
			self:keepFontStrings(this.BG)
			self:skinObject("editbox", {obj=this.MinIlvlOnly.EditBox, fType=ftype})
			this.MinIlvlOnly.EditBox.Text:ClearAllPoints()
			this.MinIlvlOnly.EditBox.Text:SetPoint("Left", this.MinIlvlOnly.EditBox, "Left", 6, 0)
			self:skinObject("dropdown", {obj=this.ClubFocusDropdown, fType=ftype})
			self:skinObject("dropdown", {obj=this.LookingForDropdown, fType=ftype})
			self:skinObject("dropdown", {obj=this.LanguageDropdown, fType=ftype})
			if self.modChkBtns then
				self:skinCheckButton{obj=this.CrossFactionToggle.CheckButton, fType=ftype}
				self:skinCheckButton{obj=this.ShouldListClub.Button, fType=ftype}
				self:skinCheckButton{obj=this.AutoAcceptApplications.Button, fType=ftype}
				self:skinCheckButton{obj=this.MaxLevelOnly.Button, fType=ftype}
				self:skinCheckButton{obj=this.MinIlvlOnly.Button, fType=ftype}
			end
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.CommunitiesAvatarPickerDialog, "OnShow", function(this)
		if self.isRtl then
			self:removeNineSlice(this.Selector)
			self:skinObject("scrollbar", {obj=this.ScrollBar, fType=ftype})
			local function skinElement(...)
				local _, element
				if _G.select("#", ...) == 2 then
					element, _ = ...
				else
					_, element, _ = ...
				end
				if self.modBtnBs then
					self:addButtonBorder{obj=element, fType=ftype, clr="grey"}
				end
			end
			_G.ScrollUtil.AddInitializedFrameCallback(this.ScrollBox, skinElement, aObj, true)
			if self.modBtns then
				self:skinStdButton{obj=this.Selector.CancelButton}
				self:skinStdButton{obj=this.Selector.OkayButton}
			end
		else
			this.ScrollFrame:DisableDrawLayer("BACKGROUND")
			if self.modBtnBs then
				for i = 1, 5 do
					for j = 1, 6 do
						self:addButtonBorder{obj=this.ScrollFrame.avatarButtons[i][j], fType=ftype, clr="grey"}
					end
				end
			end
			if self.modBtns then
				self:skinStdButton{obj=this.CancelButton}
				self:skinStdButton{obj=this.OkayButton}
			end
		end
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ofs=-4})

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

	if self.isRtl then
		self:SecureHookScript(_G.CommunitiesGuildTextEditFrame, "OnShow", function(this)
			self:skinObject("scrollbar", {obj=this.Container.ScrollFrame.ScrollBar, fType=ftype})
			self:skinObject("frame", {obj=this.Container, fType=ftype, kfs=true, fb=true})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, ofs=-7})
			if self.modBtns then
				self:skinStdButton{obj=_G.CommunitiesGuildTextEditFrameAcceptButton}
				self:skinStdButton{obj=self:getChild(_G.CommunitiesGuildTextEditFrame, 4)} -- bottom close button, uses same name as previous CB
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.CommunitiesGuildLogFrame, "OnShow", function(this)
			self:skinObject("scrollbar", {obj=this.Container.ScrollFrame.ScrollBar, fType=ftype})
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

end

aObj.blizzFrames[ftype].CompactFrames = function(self)
	if not self.prdb.CompactFrames or self.initialized.CompactFrames then return end
	self.initialized.CompactFrames = true

	if self:isAddOnLoaded("Tukui")
	or self:isAddOnLoaded("ElvUI")
	then
		self.blizzFrames[ftype].CompactFrames = nil
		return
	end

	-- handle AddOn being disabled
	if not self:checkLoadable("Blizzard_CompactRaidFrames") then
		return
	end

	-- Compact RaidFrame Manager
	self:SecureHookScript(_G.CompactRaidFrameManager, "OnShow", function(this)
		self:moveObject{obj=this.toggleButton, x=5}
		this.toggleButton:SetSize(12, 32)
		this.toggleButton.nt = this.toggleButton:GetNormalTexture()
		this.toggleButton.nt:SetTexCoord(0.22, 0.5, 0.33, 0.67)
		-- hook this to trim the texture
		self:RawHook(this.toggleButton.nt, "SetTexCoord", function(tObj, x1, x2, _)
			self.hooks[tObj].SetTexCoord(tObj, x1 == 0 and x1 + 0.22 or x1 + 0.26, x2, 0.33, 0.67)
		end, true)
		-- Display Frame
		self:keepFontStrings(this.displayFrame)
		this.displayFrame.filterOptions:DisableDrawLayer("BACKGROUND")
		if not self.isRtl then
			self:skinObject("dropdown", {obj=this.displayFrame.profileSelector, fType=ftype})
			self:skinObject("frame", {obj=this.containerResizeFrame, fType=ftype, kfs=true})
			if self.modBtns then
				self:skinStdButton{obj=this.displayFrame.lockedModeToggle, fType=ftype}
			end
		else
			if self.modBtns then
				self:skinStdButton{obj=this.displayFrame.editMode, fType=ftype, sechk=true}
			end
		end
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ofs=0})
		if self.modBtns then
			for i = 1, 8 do
				self:skinStdButton{obj=this.displayFrame.filterOptions["filterGroup" .. i]}
			end
			self:skinStdButton{obj=this.displayFrame.hiddenModeToggle, fType=ftype}
			self:skinStdButton{obj=this.displayFrame.convertToRaid, fType=ftype}
			self:skinStdButton{obj=this.displayFrame.leaderOptions.readyCheckButton, fType=ftype}
			if not self.isClscERA then
				self:skinStdButton{obj=this.displayFrame.leaderOptions.rolePollButton, fType=ftype}
			end
			if self.isRtl then
				for _, type in _G.pairs{"Tank", "Healer", "Damager"} do
					self:skinStdButton{obj=this.displayFrame.filterOptions["filterRole" .. type]}
				end
				this.displayFrame.leaderOptions.countdownButton:DisableDrawLayer("ARTWORK") -- alpha values are changed in code
				this.displayFrame.leaderOptions.countdownButton.Text:SetDrawLayer("OVERLAY") -- move draw layer so it is displayed
				self:skinStdButton{obj=this.displayFrame.leaderOptions.countdownButton, fType=ftype}
				self:skinStdButton{obj=_G.CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton, fType=ftype}
				_G.CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:GetNormalTexture():SetAlpha(1) -- icon
			end
			self:SecureHook("CompactRaidFrameManager_UpdateOptionsFlowContainer", function()
				local fObj = _G.CompactRaidFrameManager
				-- handle button skin frames not being created yet
				if fObj.displayFrame.leaderOptions.readyCheckButton.sb then
					self:clrBtnBdr(fObj.displayFrame.leaderOptions.readyCheckButton)
					if not self.isClscERA then
						self:clrBtnBdr(fObj.displayFrame.leaderOptions.rolePollButton)
					end
					if self.isRtl then
						self:clrBtnBdr(fObj.displayFrame.leaderOptions.countdownButton)
					end
				end
			end)
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=this.displayFrame.everyoneIsAssistButton}
			_G.RaiseFrameLevel(this.displayFrame.everyoneIsAssistButton) -- so button border is visible
			if self.isRtl then
				self:skinCheckButton{obj=this.displayFrame.RestrictPingsButton, fType=ftype}
			end
		end

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.CompactRaidFrameManager)

	local function skinUnit(unit)
		-- handle in combat
		if _G.InCombatLockdown() then
		    aObj:add2Table(aObj.oocTab, {skinUnit, {unit}})
		    return
		end
		if aObj:hasTextInTexture(unit.healthBar:GetStatusBarTexture(), "RaidFrame")
		or unit.healthBar:GetStatusBarTexture():GetTexture() == 423819 -- interface/raidframe/raid-bar-hp-fill.blp
		then
			unit:DisableDrawLayer("BACKGROUND")
			unit.horizDivider:SetTexture(nil)
			unit.horizTopBorder:SetTexture(nil)
			unit.horizBottomBorder:SetTexture(nil)
			unit.vertLeftBorder:SetTexture(nil)
			unit.vertRightBorder:SetTexture(nil)
			aObj:skinObject("statusbar", {obj=unit.healthBar, fi=0, bg=unit.healthBar.background})
			aObj:skinObject("statusbar", {obj=unit.powerBar, fi=0, bg=unit.powerBar.background})
		end
	end
	local grpName
	local function skinGrp(grp)
		aObj:skinObject("frame", {obj=grp.borderFrame, fType=ftype, kfs=true}) --, ofs=1, y1=-1, x2=-4, y2=4})
		grpName = grp:GetName()
		if grpName ~= "CompactPartyFrame" then
			for i = 1, _G.MEMBERS_PER_RAID_GROUP do
				skinUnit(_G[grpName .. "Member" .. i])
			end
		end
	end
	-- hook this to skin any new CompactRaidGroup(s)
	self:SecureHook("CompactRaidGroup_UpdateLayout", function(frame)
		skinGrp(frame)
	end)

	-- Compact RaidFrame Container
	local function skinCRFCframes()
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

end

aObj.blizzLoDFrames[ftype].ItemSocketingUI = function(self)
	if not self.prdb.ItemSocketingUI or self.initialized.ItemSocketingUI then return end
	self.initialized.ItemSocketingUI = true

	-- copy of GEM_TYPE_INFO from Blizzard_ItemSocketingUI.lua
	local gemTypeInfo = {
		["Yellow"]          = {textureKit = "yellow", r = 0.97, g = 0.82, b = 0.29},
		["Red"]             = {textureKit = "red", r = 1, g = 0.47, b = 0.47},
		["Blue"]            = {textureKit = "blue", r = 0.47, g = 0.67, b = 1},
		["Meta"]            = {textureKit = "meta", r = 1, g = 1, b = 1},
		["Prismatic"]       = {textureKit = "prismatic", r = 1, g = 1, b = 1},
	}
	if self.isRtl then
		gemTypeInfo["Hydraulic"]       = {textureKit = "hydraulic", r = 1, g = 1, b = 1}
		gemTypeInfo["Cogwheel"]        = {textureKit = "cogwheel", r = 1, g = 1, b = 1}
		gemTypeInfo["PunchcardRed"]    = {textureKit = "punchcard-red", r = 1, g = 0.47, b = 0.47}
		gemTypeInfo["PunchcardYellow"] = {textureKit = "punchcard-yellow", r = 0.97, g = 0.82, b = 0.29}
		gemTypeInfo["PunchcardBlue"]   = {textureKit = "punchcard-blue", r = 0.47, g = 0.67, b = 1}
		gemTypeInfo["Domination"]      = {textureKit = "domination", r = 1, g = 1, b = 1}
		gemTypeInfo["Cypher"]          = {textureKit = "meta", r = 1, g = 1, b = 1}
		gemTypeInfo["Tinker"]          = {textureKit = "punchcard-red", r = 1, g = 0.47, b = 0.47}
		gemTypeInfo["Primordial"]      = {textureKit = "meta", r = 1, g = 1, b = 1}
	end
	self:SecureHookScript(_G.ItemSocketingFrame, "OnShow", function(this)
		if self.isRtl then
			self:skinObject("scrollbar", {obj=_G.ItemSocketingScrollFrame.ScrollBar, fType=ftype})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true, x2=3})
		else
			self:skinObject("slider", {obj=_G.ItemSocketingScrollFrame.ScrollBar, fType=ftype, rpTex="artwork"})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, x1=10, y1=-12, x2=-4, y2=30})
			if self.modBtns then
				self:skinCloseButton{obj=_G.ItemSocketingCloseButton, fType=ftype}
			end
		end
		if self.modBtns then
			self:skinStdButton{obj=_G.ItemSocketingSocketButton, fType=ftype, schk=true}
			this.Sockets = this.Sockets or {_G.ItemSocketingSocket1, _G.ItemSocketingSocket2, _G.ItemSocketingSocket3}
			for _, socket in _G.ipairs(this.Sockets) do
				socket:DisableDrawLayer("BACKGROUND")
				socket:DisableDrawLayer("BORDER")
				self:skinObject("button", {obj=socket, fType=ftype, bd=10, ng=true}) -- ≈ fb option for frame
			end
			local function colourSockets()
				local numSockets = _G.GetNumSockets()
				for i, socket in _G.ipairs(_G.ItemSocketingFrame.Sockets) do
					if i <= numSockets then
						local clr = gemTypeInfo[_G.GetSocketTypes(i)]
						socket.sb:SetBackdropBorderColor(clr.r, clr.g, clr.b)
					end
				end
			end
			-- hook this to colour the button border
			self:SecureHook("ItemSocketingFrame_Update", function()
				colourSockets()
			end)
			colourSockets()
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].MirrorTimers = function(self)
	if not self.prdb.MirrorTimers.skin or self.initialized.MirrorTimers then return end
	self.initialized.MirrorTimers = true

	local objName, obj, objBG, objSB
	if not self.isRtl then
		for i = 1, 3 do
			objName = "MirrorTimer" .. i
			obj = _G[objName]
			self:removeRegions(obj, {3})
			obj:SetHeight(obj:GetHeight() * 1.25)
			self:moveObject{obj=_G[objName .. "Text"], y=-2}
			objBG = self:getRegion(obj, 1)
			objBG:SetWidth(objBG:GetWidth() * 0.75)
			objSB = _G[objName .. "StatusBar"]
			objSB:SetWidth(objSB:GetWidth() * 0.75)
			if self.prdb.MirrorTimers.glaze then
				self:skinObject("statusbar", {obj=objSB, fi=0, bg=objBG})
			end
		end
	else
		for _, timer in _G.pairs(_G.MirrorTimerContainer.mirrorTimers) do
			if timer.StatusBar then
				self:nilTexture(timer.TextBorder, true)
				self:nilTexture(timer.Border, true)
				if self.prdb.MirrorTimers.glaze then
					self:skinObject("statusbar", {obj=timer.StatusBar, fi=0, bg=self:getRegion(timer, 2), hookFunc=true})
				end
			end
		end
		if self.prdb.MirrorTimers.glaze then
			self:SecureHook(_G.MirrorTimerContainer, "SetupTimer", function(this, timer, _)
				local actTimer = this:GetActiveTimer(timer)
				if timer == "EXHAUSTION" then
					actTimer.StatusBar:SetStatusBarColor(self:getColourByName("yellow"))
				elseif timer == "BREATH" then
					actTimer.StatusBar:SetStatusBarColor(self:getColourByName("light_blue"))
				elseif timer == "DEATH" then
					actTimer.StatusBar:SetStatusBarColor(self:getColourByName("blue"))
				else -- FEIGNDEATH
					actTimer.StatusBar:SetStatusBarColor(self:getColourByName("yellow"))
				end
			end)
		end
		-- Battleground/Arena/Island Expeditions Start Timer
		local function skinTT(timer)
			_G[timer.bar:GetName() .. "Border"]:SetTexture(nil) -- animations
			if aObj.prdb.MirrorTimers.glaze then
				if not aObj.sbGlazed[timer.bar]	then
					aObj:skinObject("statusbar", {obj=timer.bar, fi=0, bg=aObj:getRegion(timer.bar, 1)})
				end
				timer.bar:SetStatusBarColor(aObj:getColourByName("red"))
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
		if not self.isRtl then
			_G["RaidGroupButton" .. i]:SetNormalTexture("")
		else
			_G["RaidGroupButton" .. i]:GetNormalTexture():SetTexture(nil)
		end
		self:skinObject("button", {obj=_G["RaidGroupButton" .. i], fType=ftype, subt=true--[[, bd=7]], ofs=1})
	end
	-- Raid Class Tabs (side)
	for i = 1, _G.MAX_RAID_CLASS_BUTTONS do
		self:removeRegions(_G["RaidClassButton" .. i], {1}) -- 2 is icon, 3 is text
	end

	if not self.isRtl then
		if self.modBtns then
			self:skinStdButton{obj=_G.RaidFrameReadyCheckButton, fType=ftype}
		end
	end

end

aObj.blizzFrames[ftype].ReadyCheck = function(self)
	if not self.prdb.ReadyCheck or self.initialized.ReadyCheck then return end
	self.initialized.ReadyCheck = true

	self:SecureHookScript(_G.ReadyCheckFrame, "OnShow", function(this)
		self:skinObject("frame", {obj=_G.ReadyCheckListenerFrame, fType=ftype, kfs=true, x1=32})
		if self.modBtns then
			self:skinStdButton{obj=_G.ReadyCheckFrameYesButton}
			self:skinStdButton{obj=_G.ReadyCheckFrameNoButton}
		end

		self:Unhook(this, "OnShow")
	end)

end

if not aObj.isClscERA then
	aObj.blizzFrames[ftype].RolePollPopup = function(self)
		if not self.prdb.RolePollPopup or self.initialized.RolePollPopup then return end
		self.initialized.RolePollPopup = true

		self:SecureHookScript(_G.RolePollPopup, "OnShow", function(this)
			self:removeNineSlice(this.Border)
			-- TODO: Retail - skin role button textures
			if not self.isRtl then
				local roleBtn
				for _, type in _G.pairs{"Healer", "Tank", "DPS"} do
					roleBtn = _G["RolePollPopupRoleButton" .. type]
					roleBtn:SetNormalTexture(aObj.tFDIDs.lfgIR)
					roleBtn.cover:SetTexture(aObj.tFDIDs.lfgIR)
				end
			end
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
end

aObj.blizzFrames[ftype].TradeFrame = function(self)
	if not self.prdb.TradeFrame or self.initialized.TradeFrame then return end
	self.initialized.TradeFrame = true

	self:SecureHookScript(_G.TradeFrame, "OnShow", function(this)
		if self.isRtl then
			this.RecipientOverlay.portrait:SetAlpha(0)
			this.RecipientOverlay.portraitFrame:SetTexture(nil)
		end
		self:removeInset(_G.TradeRecipientItemsInset)
		self:removeInset(_G.TradeRecipientEnchantInset)
		self:removeInset(_G.TradePlayerItemsInset)
		self:removeInset(_G.TradePlayerEnchantInset)
		self:removeInset(_G.TradePlayerInputMoneyInset)
		self:removeInset(_G.TradeRecipientMoneyInset)
		self:skinObject("moneyframe", {obj=_G.TradePlayerInputMoneyFrame, moveGEB=true})
		_G.TradeRecipientMoneyBg:DisableDrawLayer("BACKGROUND")
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true, x2=1})
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
