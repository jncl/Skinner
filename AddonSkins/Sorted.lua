local _, aObj = ...
if not aObj:isAddonEnabled("Sorted") then return end
local _G = _G

aObj.addonsToSkin.Sorted = function(self) -- v 1.2.20

	local function skinItemList(frame)
		frame.foregroundFrame:DisableDrawLayer("OVERLAY") -- this disables the column seperator textures
		frame:DisableDrawLayer("BACKGROUND")
		frame:DisableDrawLayer("BORDER")
		aObj:skinObject("slider", {obj=frame.scrollBar, rpTex="artwork", y1=-2, y2=2})
	end

	self:skinObject("frame", {obj=_G.SortedIconSelectionMenu, kfs=true})

	-- SortedFrame
	self:SecureHookScript(_G.SortedFrame, "OnShow", function(this)
		self:removeNineSlice(this.NineSlice)
		_G.SortedFrameTitleBarMinimizeButtonDiv.texture:SetTexture(nil)
		_G.SortedFrameTitleBarBlizzardButtonDiv.texture:SetTexture(nil)
		_G.SortedFrameTitleBarAltsButtonDiv.texture:SetTexture(nil)
		self:skinObject("frame", {obj=_G.SortedAltsDropdownButtonMenu, kfs=true})
		self:skinObject("frame", {obj=_G.SortedEquipmentSetsDropdownButtonMenu, fType=ftype, kfs=true})
		_G.SortedEquipmentSetsDropdownButtonDiv.texture:SetTexture(nil)
		_G.SortedFramePortraitButton:SetScale(0.8)
		self:moveObject{obj=_G.SortedFramePortraitButton, x=6, y=-10}
		-- SortedTabsFrame
		self:skinObject("tabs", {obj=_G.SortedTabsFrame, tabs=_G.SortedTabsFrame.tabs, ignoreSize=true, lod=true, regions={10}, offsets={x1=3, y1=-6, x2=3, y2=6}})
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
		self:skinObject("frame", {obj=_G.SortedFrameFilterButtons, kfs=true, ri=true, fb=true, x1=-1, x2=2})
		for _, btn in _G.pairs(_G.Sorted_CategoryButtons) do
			self:skinStdButton{obj=btn}
			btn.newItemsIndicator.borderR:SetTexture(nil)
			btn.newItemsIndicator.borderL:SetTexture(nil)
			self:changeTandC(btn.newItemsIndicator.borderC)
			-- N.B. minibutton appears when Side panel is hidden
			btn.miniButton.bg:SetTexture(nil)
			self:changeTandC(btn.miniButton.newItemsIndicator.border)
		end
		self:skinObject("slider", {obj=_G.SortedSubcategoryFrameScrollBar, rpTex="artwork", y1=-2, y2=2})
		self:skinObject("frame", {obj=_G.SortedSubcategoryFrameParent, kfs=true, ri=true, fb=true, x1=-1, x2=2, y2=-3})
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
		self:skinObject("editbox", {obj=_G.SortedFrameSearchBox, si=true})
		self:removeInset(_G.SortedFrameSortButtons)
		for _, frame in _G.pairs(_G.Sorted_sortButtons) do
			frame.button:DisableDrawLayer("BACKGROUND")
			self:skinObject("frame", {obj=frame.button, ofs=2})
		end
		self:skinObject("frame", {obj=_G.SortedFrameTabsMenu, kfs=true, ofs=0})
		if self.modChkBtns then
			for i = 1, #_G.SortedFrameTabsMenu.checkButtons do
				self:skinCheckButton{obj=_G.SortedFrameTabsMenu.checkButtons[i]}
			end
		end
		-- SortedFrameItemList
		-- TODO: .itemDropButton, alter texture coords to remove border (found in main panel, side panel & bag frame(s))
		skinItemList(_G.SortedFrameItemList)
		self:skinObject("frame", {obj=this, kfs=true, cb=true, x2=2.5})
		if self.modBtns then
			self:skinOtherButton{obj=_G.SortedBlizzardButton, text="B"}
			self:skinStdButton{obj=_G.ContainerFrame1SortedButton}
			self:skinStdButton{obj=_G.SortedFrameSellGreysButton}
			self:skinOtherButton{obj=_G.SortedFrameMinimizeButton, font=self.fontS, text=self.leftdc}
			self:skinOtherButton{obj=_G.SortedFrameMaximizeButton, font=self.fontS, text=self.rightdc}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.SortedBankSidePanel, "OnShow", function(this)
		self:removeInset(_G.SortedBankSidePanelFootSlots)
		self:removeInset(_G.SortedBankSidePanelFootBags)
		self:removeInset(_G.SortedBankSidePanelFootCenter)
		self:removeInset(_G.SortedBankSidePanelLeftFrame)
		skinItemList(_G.SortedBankItemList)
		self:skinObject("frame", {obj=this, kfs=true})
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
		self:skinObject("frame", {obj=this, kfs=true})
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
				aObj:skinObject("slider", {obj=child})
			elseif aObj:isDropDown(child) then
				aObj:skinObject("dropdown", {obj=child})
			elseif child:IsObjectType("CheckButton")
			and aObj.modChkBtns
			then
				aObj:skinCheckButton{obj=child}
			end
		end
		-- aObj:skinObject("frame", {obj=frame, kfs=true, fb=true})
		aObj:skinObject("frame", {obj=frame, kfs=true, fb=true})
	end
	self:SecureHookScript(_G.SortedConfigFrame, "OnShow", function(this)
		self:removeInset(_G.SortedConfigFrameTabs)
		self:skinObject("tabs", {obj=_G.SortedConfigFrameTabs, tabs=_G.SortedConfigFrame.tabs, ignoreSize=true, lod=true, offsets={x1=2, y1=-6, x2=2, y2=-4}})
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
		self:skinObject("frame", {obj=_G.SortedConfigFrameContents, kfs=true, fb=true, ofs=3, x1=-2})
		self:skinObject("frame", {obj=this, kfs=true, cb=true, x2=1})
		-- Appearance Tab
		skinOptions(_G.SortedConfigFrameContentsAppearanceBox1)
		skinOptions(_G.SortedConfigFrameContentsAppearanceBox2)
		skinOptions(_G.SortedConfigFrameContentsAppearanceBox3)
		skinOptions(_G.SortedConfigFrameContentsAppearanceBox4)
		-- Behaviour Tab
		skinOptions(_G.SortedConfigFrameContentsBehaviorBox1)
		skinOptions(_G.SortedConfigFrameContentsBehaviorBox2)
		skinOptions(_G.SortedConfigFrameContentsBehaviorBox3)
		skinOptions(_G.SortedConfigFrameContentsBehaviorBox4)
		skinOptions(_G.SortedConfigFrameContentsBehaviorBox5)
		skinOptions(_G.SortedConfigFrameContentsBehaviorBox5Sorting)
		skinOptions(_G.SortedConfigFrameContentsBehaviorBox5Filtering)
		-- Categories Tab
		self:skinObject("frame", {obj=_G.SortedConfigCategories, kfs=true, fb=true, ofs=1, x1=-3})
		for _, btn in _G.pairs(_G.SortedConfigCategories.buttons) do
			self:skinObject("frame", {obj=btn, kfs=true})
			self:skinCloseButton{obj=btn.deleteButton }
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.SortedConfigCategories.addButton, ofs=-2, x1=1, clr="gold"}
		end
		self:removeInset(_G.SortedConfigCategoryName)
		self:skinObject("editbox", {obj=_G.SortedConfigCategoryName.editBox, ofs=0})
		_G.SortedConfigCategoryIcon:DisableDrawLayer("BACKGROUND")
		self:removeInset(_G.SortedConfigCategoryFilters)
		self:removeInset(_G._G.SortedConfigFrameContentsCategoriesLeftBottomRight)
		self:skinObject("frame", {obj=_G.SortedConfigCategorySubfiltersScrollFrame, kfs=true, fb=true, ofs=3})
		self:skinObject("slider", {obj=_G.SortedConfigCategorySubfiltersScrollFrameScrollBar, rpTex="artwork", x2=-4})
		self:SecureHook(_G.SortedConfigCategorySubfilters, "Update", function(this)
			if self.modChkBtns then
				for _, cb in _G.pairs(this.checkButtons) do
					self:skinCheckButton{obj=cb}
				end
			end
			for _, nr in _G.pairs(this.numberRanges) do
				self:skinObject("editbox", {obj=nr.min, ofs=0})
				self:skinObject("editbox", {obj=nr.max, ofs=0})
			end
			for _, si in _G.pairs(this.specificItems) do
				self:skinObject("editbox", {obj=si.editBoxID, ofs=0})
				self:skinObject("editbox", {obj=si.editBoxName, ofs=0})
			end
			for _, eb in _G.pairs(this.editBoxes) do
				self:skinObject("editbox", {obj=eb, ofs=0})
			end
		end)
		-- Profile Tab
		self:skinObject("dropdown", {obj=_G.SortedConfigProfileDropdown})
		if self.modBtns then
			self:skinStdButton{obj=_G.SortedConfigProfileNew}
			self:skinStdButton{obj=_G.SortedConfigProfileCopy}
			self:skinStdButton{obj=_G.SortedConfigProfileDelete}
			self:SecureHook(_G.SortedConfigProfileDelete, "Update", function(this)
				self:clrBtnBdr(this)
			end)
		end
		self:removeInset(_G.SortedConfigProfileName)
		self:skinObject("editbox", {obj=_G.SortedConfigProfileName.editBox, ofs=0})

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
				self:skinObject("frame", {obj=this, kfs=true, cb=true})
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
