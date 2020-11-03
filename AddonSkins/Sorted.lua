local _, aObj = ...
if not aObj:isAddonEnabled("Sorted") then return end
local _G = _G

aObj.addonsToSkin.Sorted = function(self) -- v 1.2.17

	local function skinItemList(frame)
		frame.foregroundFrame:DisableDrawLayer("OVERLAY") -- this disables the column seperator textures
		frame:DisableDrawLayer("BACKGROUND")
		frame:DisableDrawLayer("BORDER")
		aObj:skinSlider{obj=frame.scrollBar, rt="artwork", wdth=-4}
		-- TODO: remove background texture ?
		-- for _, btn in pairs(frame.itemButtons) do
		-- end
	end

	self:addSkinFrame{obj=_G.SortedIconSelectionMenu, ft="a", kfs=true, nb=true}

	-- SortedFrame
	self:SecureHookScript(_G.SortedFrame, "OnShow", function(this)
		self:removeNineSlice(this.NineSlice)
		_G.SortedFrameTitleBarMinimizeButtonDiv.texture:SetTexture(nil)
		_G.SortedFrameTitleBarAltsButtonDiv.texture:SetTexture(nil)
		-- ?TODO: SortedAltsDropdownButton, make it look like a dropdown
		self:addSkinFrame{obj=_G.SortedAltsDropdownButtonMenu, ft="a", kfs=true, nb=true}
		-- ?TODO: SortedEquipmentSetsDropdownButton, make it look like a dropdown
		self:addSkinFrame{obj=_G.SortedEquipmentSetsDropdownButtonMenu, ft="a", kfs=true, nb=true}
		_G.SortedEquipmentSetsDropdownButtonEquipmentSetsButtonDiv.texture:SetTexture(nil)
		_G.SortedFramePortraitButton:SetScale(0.8)
		self:moveObject{obj=_G.SortedFramePortraitButton, x=6, y=-10}
		-- SortedTabsFrame
		local tab
		for _, tab in _G.pairs(_G.SortedTabsFrame.tabs) do
			tab:DisableDrawLayer("BACKGROUND")
			tab:DisableDrawLayer("ARTWORK")
			self:addSkinFrame{obj=tab, ft="a", noBdr=self.isTT, x1=3, y1=name=="Bank" and -5 or -7, x2=3, y2=name=="Bank" and 4 or 7}
			if self.isTT then
				if tab.selected then
					self:setActiveTab(tab.sf)
				else
					self:setInactiveTab(tab.sf)
				end
			end
		end
		if self.isTT then
			self:SecureHook(_G.SortedTabsFrame, "ToggleTab", function(this, _)
				for _, tab in _G.pairs(this.tabs) do
					if tab.selected then
						self:setActiveTab(tab.sf)
					else
						self:setInactiveTab(tab.sf)
					end
				end
			end)
		end
		-- SortedFrameFoot
		self:removeInset(_G.SortedFrameFootSlots)
		self:removeInset(_G.SortedFrameFootBags)
		self:removeInset(_G.SortedFrameMoneyFrame)
		_G.SortedFrameMoneyInnerFrame:DisableDrawLayer("BACKGROUND")
		self:removeInset(_G.SortedFrameFootCenter)
		self:removeInset(_G.SortedFrameFootRight)
		_G.SortedFrameResizeHandle:GetNormalTexture():SetTexCoord(0, 1, 0, 1)
		_G.SortedFrameResizeHandle:SetNormalTexture([[Interface\ChatFrame\UI-ChatIM-SizeGrabber-Up]])
		_G.SortedFrameResizeHandle:GetPushedTexture():SetTexCoord(0, 1, 0, 1)
		_G.SortedFrameResizeHandle:SetPushedTexture([[Interface\ChatFrame\UI-ChatIM-SizeGrabber-Highlight]])
		_G.SortedFrameResizeHandle:GetHighlightTexture():SetTexCoord(0, 1, 0, 1)
		_G.SortedFrameResizeHandle:SetHighlightTexture([[Interface\ChatFrame\UI-ChatIM-SizeGrabber-Down]])
		_G.SortedCurrencyFrame:DisableDrawLayer("BACKGROUND")
		-- SortedFrameMain
		self:removeInset(_G.SortedFrameMain)
		-- SortedFrameRight
		self:addFrameBorder{obj=_G.SortedFrameFilterButtons, ft="a", ri=true, x1=-1, x2=2}
		local btn
		for _, btn in _G.pairs(_G.Sorted_CategoryButtons) do
			self:skinStdButton{obj=btn}
			btn.newItemsIndicator.borderR:SetTexture(nil)
			btn.newItemsIndicator.borderL:SetTexture(nil)
			self:changeTandC(btn.newItemsIndicator.borderC)
			-- N.B. minibutton appears when Side panel is hidden
			btn.miniButton.bg:SetTexture(nil)
			self:changeTandC(btn.miniButton.newItemsIndicator.border)
		end
		btn = nil
		self:skinSlider{obj=_G.SortedSubcategoryFrameScrollBar, rt="artwork"}
		self:addFrameBorder{obj=_G.SortedSubcategoryFrameParent, ft="a", ri=true, x1=-1, x2=2, y2=-3}
		if self.modChkBtns then
			local function skinSCcBtns()
				for _, cb in _G.pairs(_G.SortedSubcategoryFrameScrollChild.checkButtons) do
					aObj:skinCheckButton{obj=cb}
				end
			end
			self:SecureHook("SortedSubcategoryFrame_Update", function()
				skinSCcBtns()
			end)
			skinSCcBtns()
		end
		-- SortedFrameLeft
		self:removeInset(_G.SortedFrameSearchBoxFrame)
		self:skinEditBox{obj=_G.SortedFrameSearchBox, regs={6, 7}, mi=true} -- 6 is text, 7 is the icon
		self:removeInset(_G.SortedFrameSortButtons)
		for _, frame in _G.pairs(_G.Sorted_sortButtons) do
			frame.button:DisableDrawLayer("BACKGROUND")
			self:addSkinFrame{obj=frame.button, ft="a", nb=true, ofs=2}
		end
		self:addSkinFrame{obj=_G.SortedFrameTabsMenu, ft="a", kfs=true, nb=true}
		if self.modChkBtns then
			for i = 1, #_G.SortedFrameTabsMenu.checkButtons do
				self:skinCheckButton{obj=_G.SortedFrameTabsMenu.checkButtons[i]}
			end
		end
		-- SortedFrameItemList
		-- TODO: .itemDropButton, alter texture coords to remove border (found in main panel, side panel & bag frame(s))
		skinItemList(_G.SortedFrameItemList)
		self:addSkinFrame{obj=this, ft="a", kfs=true}
		if self.modBtns then
			self:skinStdButton{obj=_G.SortedFrameSellGreysButton}
			self:skinOtherButton{obj=_G.SortedMinimizeButton, font=self.fontS, text=self.leftdc}
			self:skinOtherButton{obj=_G.SortedMaximizeButton, font=self.fontS, text=self.rightdc}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.SortedBankSidePanel, "OnShow", function(this)
		self:removeInset(_G.SortedBankSidePanelFootSlots)
		self:removeInset(_G.SortedBankSidePanelFootBags)
		self:removeInset(_G.SortedBankSidePanelFootCenter)
		self:removeInset(_G.SortedBankSidePanelLeftFrame)
		skinItemList(_G.SortedBankItemList)
		self:addSkinFrame{obj=this, ft="a", kfs=true, nb=true}
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.SortedBankSidePanelFootBagsPurchaseSlotButton, ofs=-2, x1=1, clr="gold"}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.SortedReagentSidePanel, "OnShow", function(this)
		self:removeInset(_G.SortedReagentSidePanelFootSlots)
		self:removeInset(_G.SortedReagentSidePanelFootCenter)
		self:removeInset(_G.SortedReagentSidePanelLeftFrame)
		skinItemList(_G.SortedReagentItemList)
		-- TODO: .CostMoneyFrame
		self:addSkinFrame{obj=this, ft="a", kfs=true, nb=true}
		if self.modBtns then
			self:skinStdButton{obj=_G.SortedReagentSidePanelFootCenterDepositButton}
			self:SecureHook(_G.SortedReagentSidePanelFootCenterDepositButton, "Disable", function(this, _)
				self:clrBtnBdr(this)
			end)
			self:SecureHook(_G.SortedReagentSidePanelFootCenterDepositButton, "Enable", function(this, _)
				self:clrBtnBdr(this)
			end)
			self:skinStdButton{obj=_G.SortedReagentItemList.PurchaseButton}
		end

		self:Unhook(this, "OnShow")
	end)

	local function skinOptions(frame)
		for _, child in pairs{frame:GetChildren()} do
			if child:IsObjectType("Slider") then
				aObj:skinSlider{obj=child}--, rt="artwork", wdth=-4, size=3, hgt=-10}
			elseif child:IsObjectType("CheckButton")
			and aObj.modChkBtns
			then
				aObj:skinCheckButton{obj=child}
			end
		end
		aObj:addFrameBorder{obj=frame, ft="a"}
	end
	self:SecureHookScript(_G.SortedConfigFrame, "OnShow", function(this)
		self:removeInset(_G.SortedConfigFrameTabs)
		for _, tab in _G.pairs(_G.SortedConfigFrame.tabs) do
			self:keepRegions(tab, {7, 8})
			self:addSkinFrame{obj=tab, ft="a", noBdr=self.isTT, x1=2, y1=-6, x2=2, y2=-4}
			tab.sf.up = true -- tabs grow upwards
			if self.isTT then
				if tab.selected then
					self:setActiveTab(tab.sf)
				else
					self:setInactiveTab(tab.sf)
				end
			end
		end
		if self.isTT then
			self:SecureHook("SortedConfigFrame_ToggleTab", function(tab)
				for _, tabFrame in _G.pairs(_G.SortedConfigFrame.tabs) do
					if tabFrame.selected then
						self:setActiveTab(tabFrame.sf)
					else
						self:setInactiveTab(tabFrame.sf)
					end
				end
			end)
		end
		_G.SortedConfigFrameContents:DisableDrawLayer("BACKGROUND")
		_G.SortedConfigFrameContents:DisableDrawLayer("BORDER")
		self:addFrameBorder{obj=_G.SortedConfigFrameContents, ft="a", ofs=3}
		self:addSkinFrame{obj=this, ft="a", kfs=true, x2=1}
		-- Appearance Tab
		skinOptions(_G.SortedConfigFrameContentsAppearanceBox1)
		skinOptions(_G.SortedConfigFrameContentsAppearanceBox2)
		self:skinDropDown{obj=_G.SortedConfigFont}
		skinOptions(_G.SortedConfigFrameContentsAppearanceBox3)
		-- Behaviour
		skinOptions(_G.SortedConfigFrameContentsBehaviorBox1)
		skinOptions(_G.SortedConfigFrameContentsBehaviorBox2)
		skinOptions(_G.SortedConfigFrameContentsBehaviorBox3)
		skinOptions(_G.SortedConfigFrameContentsBehaviorBox4)
		-- Categories Tab
		self:addFrameBorder{obj=_G.SortedConfigCategories, ft="a", ofs=1, x1=-3}
		for _, btn in _G.pairs(_G.SortedConfigCategories.buttons) do
			self:addSkinFrame{obj=btn, ft="a", kfs=true, nb=true}
			self:skinCloseButton{obj=btn.deleteButton }
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.SortedConfigCategories.addButton, ofs=-2, x1=1, clr="gold"}
		end
		self:removeInset(_G.SortedConfigCategoryName)
		self:skinEditBox{obj=_G.SortedConfigCategoryName.editBox, regs={6}} -- 6 is text
		_G.SortedConfigCategoryIcon:DisableDrawLayer("BACKGROUND")
		self:skinDropDown{obj=_G.SortedConfigCategoryGroups}
		self:removeInset(_G.SortedConfigCategoryFilters)
		self:removeInset(_G._G.SortedConfigFrameContentsCategoriesLeftBottomRight)
		self:addFrameBorder{obj=_G.SortedConfigCategorySubfiltersScrollFrame, ft="a", ofs=3}
		self:skinSlider{obj=_G.SortedConfigCategorySubfiltersScrollFrameScrollBar, rt="artwork"}
		self:SecureHook(_G.SortedConfigCategorySubfilters, "Update", function(this)
			if self.modChkBtns then
				for _, cb in _G.pairs(this.checkButtons) do
					self:skinCheckButton{obj=cb}
				end
			end
			for _, nr in _G.pairs(this.numberRanges) do
				self:skinEditBox{obj=nr.min, regs={6}} -- 6 is text
				self:skinEditBox{obj=nr.max, regs={6}} -- 6 is text
			end
			for _, si in _G.pairs(this.specificItems) do
				self:skinEditBox{obj=si.editBoxID, regs={6}} -- 6 is text
				self:skinEditBox{obj=si.editBoxName, regs={6}} -- 6 is text
			end
			for _, eb in _G.pairs(this.editBoxes) do
				self:skinEditBox{obj=eb, regs={6}} -- 6 is text
			end
		end)
		-- Profile Tab
		self:skinDropDown{obj=_G.SortedConfigProfileDropdown}
		if self.modBtns then
			self:skinStdButton{obj=_G.SortedConfigProfileNew}
			self:skinStdButton{obj=_G.SortedConfigProfileCopy}
			self:skinStdButton{obj=_G.SortedConfigProfileDelete}
			self:SecureHook(_G.SortedConfigProfileDelete, "Update", function(this)
				self:clrBtnBdr(this)
			end)
		end
		self:removeInset(_G.SortedConfigProfileName)
		self:skinEditBox{obj=_G.SortedConfigProfileName.editBox, regs={6}} -- 6 is text

		self:Unhook(this, "OnShow")
	end)

	-- Sorted Bag Frame(s)
	local i, bFrame = 1
	while true do
		bFrame = _G["SortedBag" .. i .. "Frame"]
		if bFrame then
			self:SecureHookScript(bFrame, "OnShow", function(this)
				local fName = this:GetName()
				self:removeInset(_G[fName .. "Slots"])
				_G[fName .. "Head"]:DisableDrawLayer("BACKGROUND")
				self:removeNineSlice(this.NineSlice)
				skinItemList(this.ItemList)
				self:addSkinFrame{obj=this, ft="a", kfs=true, nb=true}
				fName = nil

				self:Unhook(this, "OnShow")
			end)
			i = i + 1
		else
			break
		end
	end
	i, bFrame = nil, nil

	-- tooltip
	_G.C_Timer.After(0.1, function()
		self:add2Table(self.ttList, self:getChild(_G.GameTooltip, 3))
	end)

end
