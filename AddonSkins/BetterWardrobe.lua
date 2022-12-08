local _, aObj = ...
if not aObj:isAddonEnabled("BetterWardrobe") then return end
local _G = _G

aObj.addonsToSkin.BetterWardrobe = function(self) -- v 4.4.9

	local function skinDDL(frame)
		if frame
		and not frame.sf
		then
			if frame.Border then
				aObj:removeNineSlice(frame.Border)
			end
			if frame.Backdrop then
				aObj:removeBackdrop(frame.Backdrop)
			end
			aObj:removeNineSlice(_G[frame:GetName() .. "MenuBackdrop"].NineSlice )
			aObj:skinObject("frame", {obj=frame, ofs=-4})
		end
	end
	skinDDL(_G["BW_DropDownList" .. 1])
	skinDDL(_G["BW_DropDownList" .. 2])
	self:SecureHook("BW_UIDropDownMenu_CreateFrames", function(_, level)
		for i = 1, level do
			skinDDL(_G["BW_DropDownList" .. i])
		end
	end)

	local skinPageBtns
	if self.modBtnBs then
		function skinPageBtns(frame)
			aObj:addButtonBorder{obj=frame.PagingFrame.PrevPageButton, ofs=-2, y1=-3, x2=-3}
			aObj:addButtonBorder{obj=frame.PagingFrame.NextPageButton, ofs=-2, y1=-3, x2=-3}
			aObj:clrPNBtns(frame.PagingFrame, true)
			aObj:SecureHook(frame.PagingFrame, "Update", function(this)
				aObj:clrPNBtns(this, true)
			end)
		end
	end

	local x1Ofs, y1Ofs, x2Ofs, y2Ofs = -4, 2, 7, -4
	self.RegisterCallback("BetterWardrobe", "WardrobeCollectionFrame_OnShow", function(_)
		-- WardrobeTransmogFrame
		self:skinObject("dropdown", {obj=_G.BetterWardrobeOutfitDropDown, y2=-3})
		if self.modBtns then
			self:skinStdButton{obj=_G.BetterWardrobeOutfitDropDown.SaveButton}
			self:SecureHook(_G.BetterWardrobeOutfitDropDown.SaveButton, "SetEnabled", function(this)
				self:clrBtnBdr(this)
			end)
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.BW_LoadQueueButton, ofs=0, x1=-1, clr="gold"}
			self:addButtonBorder{obj=_G.BW_RandomizeButton, ofs=0, x1=-1, clr="gold"}
			self:addButtonBorder{obj=_G.BW_SlotHideButton, ofs=0, x1=-1, clr="gold"}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.WardrobeTransmogFrame.ToggleSecondaryAppearanceCheckbox}
		end

		self:SecureHookScript(_G.BetterWardrobeCollectionFrame, "OnShow", function(fObj)
			self:skinObject("tabs", {obj=fObj, tabs=fObj.Tabs, lod=self.isTT and true, upwards=true, offsets={x1=2, y1=-4, x2=-2, y2=self.isTT and -4 or 0}})
			self:skinObject("editbox", {obj=fObj.SearchBox, si=true})
			self:skinObject("statusbar", {obj=fObj.progressBar, regions={2, 3}, fi=0})
			self:skinObject("dropdown", {obj=_G.BW_SortDropDown})
			self:skinObject("dropdown", {obj=_G.BW_CollectionList_Dropdown, x2=109})
			self:skinObject("dropdown", {obj=_G.BW_DBSavedSetDropdown})
			if self.modBtns then
				self:skinStdButton{obj=fObj.FilterButton}
				self:SecureHook(fObj.FilterButton, "SetEnabled", function(bObj, _)
					self:clrBtnBdr(bObj)
				end)
				self:skinStdButton{obj=fObj.TransmogOptionsButton}
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=fObj.BW_SetsHideSlotButton, ofs=-2, x1=1, clr="gold"}
				self:addButtonBorder{obj=_G.BW_CollectionListButton, ofs=2, x1=-1, y1=1}
				self:addButtonBorder{obj=_G.BW_CollectionListOptionsButton, ofs=-2, x1=1, clr="gold"}
			end

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(_G.BetterWardrobeCollectionFrame)

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
		self:SecureHookScript(_G.BetterWardrobeCollectionFrame.ItemsCollectionFrame, "OnShow", function(this)
			self:skinObject("dropdown", {obj=this.WeaponDropDown})
			self:skinObject("frame", {obj=this, kfs=true, rns=true, fb=true, x1=x1Ofs, y1=y1Ofs, x2=x2Ofs, y2=y2Ofs})
			if self.modBtnBs then
				skinPageBtns(this)
				for _, btn in _G.pairs(this.Models) do
					self:removeRegions(btn, {2}) -- background & border
					self:addButtonBorder{obj=btn, reParent={btn.NewString, btn.Favorite.Icon, btn.HideVisual.Icon}, ofs=6}
					updBtnClr(btn)
				end
				self:SecureHook(this, "UpdateItems", function(frame)
					for _, btn in _G.pairs(frame.Models) do
						updBtnClr(btn)
					end
				end)
			end

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.BetterWardrobeCollectionFrame.ItemsCollectionFrame)

		self:SecureHookScript(_G.BetterWardrobeCollectionFrame.SetsCollectionFrame, "OnShow", function(this)
			self:removeInset(this.LeftInset)
			self:keepFontStrings(this.RightInset)
			self:removeNineSlice(this.RightInset.NineSlice)
			self:skinObject("scrollbar", {obj=this.ListContainer.ScrollBar})
			local function skinElement(...)
				local _, element
				if _G.select("#", ...) == 2 then
					element, _ = ...
				elseif _G.select("#", ...) == 3 then
					_, element, _ = ...
				end
				element:DisableDrawLayer("BACKGROUND")
				if self.modBtnBs then
					 self:addButtonBorder{obj=element, relTo=element.Icon, reParent={element.Favorite}}
					 self:clrBtnBdr(element, element.Icon:IsDesaturated() and "grey")
				end
			end
			_G.ScrollUtil.AddInitializedFrameCallback(this.ListContainer.ScrollBox, skinElement, aObj, true)
			this.DetailsFrame:DisableDrawLayer("BACKGROUND")
			this.DetailsFrame:DisableDrawLayer("BORDER")
			if self.modBtns then
				self:skinStdButton{obj=this.DetailsFrame.VariantSetsButton}
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=this.DetailsFrame.BW_LinkSetButton, ofs=-2, x1=1, clr="gold"}
			end
			self:skinObject("frame", {obj=this, kfs=true, fb=true, x1=x1Ofs, y1=y1Ofs, x2=x2Ofs, y2=y2Ofs})

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.BetterWardrobeCollectionFrame.SetsTransmogFrame, "OnShow", function(this)
			self:skinObject("frame", {obj=this, kfs=true, rns=true, fb=true, x1=x1Ofs, y1=y1Ofs, x2=x2Ofs, y2=y2Ofs})
			if self.modBtnBs then
				self:addButtonBorder{obj=this.PagingFrame.PrevPageButton, ofs=-2, y1=-3, x2=-3}
				self:addButtonBorder{obj=this.PagingFrame.NextPageButton, ofs=-2, y1=-3, x2=-3}
				self:clrPNBtns(this.PagingFrame, true)
				self:SecureHook(this.PagingFrame, "Update", function(frame)
					self:clrPNBtns(frame, true)
				end)
				for _, btn in _G.pairs(this.Models) do
					self:removeRegions(btn, {2}) -- background & border
					self:addButtonBorder{obj=btn, reParent={btn.Favorite.Icon}, ofs=6}
					local atlas = btn.Border:GetAtlas()
					if atlas:find("uncollected", 1, true) then
						aObj:clrBtnBdr(btn, "grey")
					elseif atlas:find("unusable", 1, true) then
						aObj:clrBtnBdr(btn, "unused")
					else
						aObj:clrBtnBdr(btn, "gold", 0.75)
					end
				end
			end

			self:Unhook(this, "OnShow")
		end)

		self.UnregisterCallback("BetterWardrobe", "WardrobeCollectionFrame_OnShow")
	end)

	-- SavedOutfits
	self:SecureHookScript(_G.BetterWardrobeOutfitFrame, "OnShow", function(this)
		self:keepFontStrings(this.Border)
		self:skinObject("slider", {obj=this.scrollbar})
		self:skinObject("frame", {obj=this, ofs=0})

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.BetterWardrobeOutfitEditFrame, "OnShow", function(this)
		self:keepFontStrings(this.Border)
		this.Separator:SetTexture(nil)
		self:skinObject("editbox", {obj=this.EditBox, y1=-4, y2=4})
		self:skinObject("frame", {obj=this, ofs=0})
		if self.modBtns then
			self:skinStdButton{obj=this.AcceptButton}
			self:skinStdButton{obj=this.CancelButton}
			self:skinStdButton{obj=this.DeleteButton}
		end

		self:Unhook(this, "OnShow")
	end)

end
