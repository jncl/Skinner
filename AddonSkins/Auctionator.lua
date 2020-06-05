local _, aObj = ...
if not aObj:isAddonEnabled("Auctionator") then return end
local _G = _G

aObj.addonsToSkin.Auctionator = function(self) -- v 8.3.1.2/100.0.7

	-- get first part of the version number
	local verNoPrefix = _G.tonumber(_G.GetAddOnMetadata("Auctionator", "Version"):match("(%d+)%..*"))

	self.RegisterCallback("Auctionator", "Auction_House_Show", function(this)

		if _G.tonumber(verNoPrefix) < 100 then
			-- Retail version
			if _G.Auctionator.State.SplashScreenRef then
				_G.Auctionator.State.SplashScreenRef.Bg:SetTexture(nil)
				self:removeNineSlice(_G.Auctionator.State.SplashScreenRef.NineSlice)
				self:skinSlider{obj=_G.Auctionator.State.SplashScreenRef.ScrollFrame.ScrollBar}
				self:addSkinFrame{obj=_G.Auctionator.State.SplashScreenRef, ft="a", kfs=true, nb=true, ri=true}
				if self.modBtns then
					self:skinCloseButton{obj=_G.Auctionator.State.SplashScreenRef.Close}
				end
				if self.modChkBtns then
					self:skinCheckButton{obj=_G.Auctionator.State.SplashScreenRef.HideCheckbox.CheckBox}
				end
			end

			-- Tabs
			if _G.Auctionator.State.TabFrameRef then
				for key, tab in pairs(_G.Auctionator.State.TabFrameRef.Tabs) do
					aObj:Debug("Auctionator Tab: [%s, %s, %s, %s]", key, tab, tab.displayMode, tab.ahTabIndex)
					self:keepRegions(tab, {7, 8})
					self:addSkinFrame{obj=tab, ft=ftype, kfs=true, nb=true, noBdr=self.isTT, x1=6, y1=0, x2=-6, y2=2}
					if self.isTT then
						self:setInactiveTab(tab.sf)
						-- add to table to display tab textures (handle mismatched index)
						_G.AuctionHouseFrame.tabsForDisplayMode[tab.displayMode] = tab.ahTabIndex == 4 and tab.ahTabIndex or tab.ahTabIndex - 1
					end
					-- change highlight texture
					local ht = tab:GetHighlightTexture()
					ht:SetTexture([[Interface\PaperDollInfoFrame\UI-Character-Tab-Highlight]])
					ht:ClearAllPoints()
					ht:SetPoint("TOPLEFT", 8, 2)
					ht:SetPoint("BOTTOMRIGHT", -8, 0)
					ht = nil
				end
			end

			_G.AuctionatorShoppingListFrame.Bg:SetTexture(nil)
			self:removeNineSlice(_G.AuctionatorShoppingListFrame.NineSlice)
			self:skinDropDown{obj=_G.AuctionatorShoppingListFrame.ListDropdown}
			_G.AuctionatorShoppingListFrame.ScrollList.ScrollFrame.ArtOverlay:DisableDrawLayer("OVERLAY")
			self:removeInset(_G.AuctionatorShoppingListFrame.ScrollList.InsetFrame)
			self:skinSlider{obj=_G.AuctionatorShoppingListFrame.ScrollList.ScrollFrame.scrollBar, wdth=-4}
			self:skinSlider{obj=_G.AuctionatorShoppingListFrame.ResultsListing.ScrollFrame.scrollBar, wdth=-4}
			self:getChild(_G.AuctionatorShoppingListFrame, 8).Bg:SetTexture(nil) -- Background for Add & Search buttons
			for _, child in ipairs{_G.AuctionatorShoppingListFrame.ResultsListing.HeaderContainer:GetChildren()} do
				self:keepRegions(child, {4, 5, 6}) -- N.B. regions 4 is text, 5 is highlight, 6 is arrow
				self:addSkinFrame{obj=child, ft="a", kfs=true, nb=true, ofs=1, x1=-2, x2=2}
			end
			if self.modBtns then
				self:skinStdButton{obj=_G.AuctionatorShoppingListFrame.CreateList}
				self:skinStdButton{obj=_G.AuctionatorShoppingListFrame.DeleteList}
				self:skinStdButton{obj=_G.AuctionatorShoppingListFrame.Rename}
				self:skinStdButton{obj=_G.AuctionatorShoppingLists_AddItem}
				self:skinStdButton{obj=_G.AuctionatorShoppingListFrame.ManualSearch}
			end

			_G.AuctionatorCancellingFrame.Bg:SetTexture(nil)
			self:removeNineSlice(_G.AuctionatorCancellingFrame.NineSlice)
			_G.AuctionatorCancellingFrame.ResultsListing.ScrollFrame.scrollBar.Background:SetTexture(nil)
			self:skinSlider{obj=_G.AuctionatorCancellingFrame.ResultsListing.ScrollFrame.scrollBar, rt="artwork", wdth=-4}
			for _, child in ipairs{_G.AuctionatorCancellingFrame.ResultsListing.HeaderContainer:GetChildren()} do
				self:keepRegions(child, {4, 5, 6}) -- N.B. regions 4 is text, 5 is highlight, 6 is arrow
				self:addSkinFrame{obj=child, ft="a", kfs=true, nb=true, ofs=1, x1=-2, x2=2}
			end
			local frame = self:getChild(_G.AuctionatorCancellingFrame, 4) -- Anon frame using AuctionatorUndercutScanMixin
			frame.Bg:SetTexture(nil)
			if self.modBtns then
				self:skinStdButton{obj=frame.StartScanButton}
				self:skinStdButton{obj=frame.CancelNextButton}
			end
			frame = nil

			_G.AuctionatorConfigFrame.Bg:SetTexture(nil)
			self:removeNineSlice(_G.AuctionatorConfigFrame.NineSlice)
			self:skinEditBox{obj=_G.AuctionatorConfigFrame.DiscordLink.InputBox, regs={6}} -- 6 is text
			self:skinEditBox{obj=_G.AuctionatorConfigFrame.BugReportLink.InputBox, regs={6}} -- 6 is text
			self:skinEditBox{obj=_G.AuctionatorConfigFrame.TechnicalRoadmap.InputBox, regs={6}} -- 6 is text
			if self.modBtns then
				self:skinStdButton{obj=_G.AuctionatorConfigFrame.ScanButton}
				self:skinStdButton{obj=_G.AuctionatorConfigFrame.OptionsButton}
			end
		else
			-- Classic version
			-- Buy Tab
			self:skinDropDown{obj=_G.Atr_DropDownSL}
			self:skinEditBox{obj=_G.Atr_Search_Box, regs={6}} -- 6 is text
			-- Atr_Hlist_ScrollFrame
			self:addSkinFrame{obj=_G.Atr_Hlist, ft="a", kfs=true, nb=true, x2=24}
			_G.Atr_HeadingsBarMiddle:SetTexture(nil)
			self:applySkin{obj=_G.Atr_Col1_Heading_Button}
			self:applySkin{obj=_G.Atr_Col3_Heading_Button}
			if self.modBtns then
				self:skinStdButton{obj=_G.Atr_Search_Button}
				self:skinStdButton{obj=_G.Auctionator1Button, y2=0}
				self:skinStdButton{obj=_G.Atr_FullScanButton, y1=0}
				self:skinStdButton{obj=_G.Atr_AddToSListButton, x2=0}
				self:skinStdButton{obj=_G.Atr_RemFromSListButton, x1=0, x2=0}
				self:skinStdButton{obj=_G.Atr_SrchSListButton}
				self:skinStdButton{obj=_G.Atr_MngSListsButton}
				self:skinStdButton{obj=_G.Atr_NewSListButton}
				self:skinStdButton{obj=_G.Atr_Buy1_Button, x2=-1}
				self:skinStdButton{obj=_G.Atr_CancelSelectionButton, x1=1, x2=0}
				self:skinStdButton{obj=_G.AuctionatorCloseButton, x1=0}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=_G.Atr_Adv_Search_Button}
				self:skinCheckButton{obj=_G.Atr_Exact_Search_Button}
			end
			-- Sell Tab
			self:skinMoneyFrame{obj=_G.Atr_StackPrice}
			self:skinMoneyFrame{obj=_G.Atr_ItemPrice}
			self:skinMoneyFrame{obj=_G.Atr_StartingPrice}
			self:skinEditBox{obj=_G.Atr_Batch_NumAuctions, regs={6}} -- 6 is text
			self:skinEditBox{obj=_G.Atr_Batch_Stacksize, regs={6}} -- 6 is text
			self:skinDropDown{obj=_G.Atr_Duration}
			self:moveObject{obj=_G.Atr_Duration, x=40}
			self:addSkinFrame{obj=_G.Atr_Hilite1, ft="a", kfs=true, nb=true, x1=10}
			self:skinTabs{obj=_G.Atr_ListTabs, ignore=true, up=true, lod=true, x1=0, y1=-4, x2=0, y2=-2}
			if self.modBtns then
				self:skinStdButton{obj=_G.Atr_CreateAuctionButton}
			end
			-- More... Tab
			if self.modBtns then
				self:skinStdButton{obj=_G.Atr_CheckActiveButton}
			end

		end

		self.UnregisterCallback("Auctionator", "Auction_House_Show")
	end)

	-- skin Config panels as required
	local pCnt = 0
	if verNoPrefix < 100 then
		self.RegisterCallback("Auctionator_Config", "IOFPanel_Before_Skinning", function(this, panel)
			if self:hasTextInName(panel, "AuctionatorConfig")
			and not self.iofSkinnedPanels[panel]
			then
				self.iofSkinnedPanels[panel] = true
				pCnt = pCnt + 1
			end
			if pCnt == 6 then
				self.UnregisterCallback("Auctionator_Config", "IOFPanel_Before_Skinning")
			end
		end)
		-- register callback to skin elements
		self.RegisterCallback("Auctionator_Config", "IOFPanel_After_Skinning", function(this, panel)
			local function skinKids(panel)

				for _, child in _G.ipairs{panel:GetChildren()} do
					if child:IsObjectType("CheckButton")
					and aObj.modChkBtns
					then
						aObj:skinCheckButton{obj=child}
					elseif child:IsObjectType("EditBox") then
						aObj:skinEditBox{obj=child, regs={1, 6}} --1 & 6 are text
					elseif child:IsObjectType("Frame") then
						skinKids(child)
					end
				end

			end

			if self:hasTextInName(panel, "AuctionatorConfig")
			and not panel.sknd
			then
				skinKids(panel)
				panel.sknd = true
			end
			if pCnt == 6 then
				self.UnregisterCallback("Auctionator_Config", "IOFPanel_After_Skinning")
				pCnt = nil
			end
		end)
	else
		self.RegisterCallback("Auctionator", "IOFPanel_Before_Skinning", function(this, panel)
			if panel.parent ~= "Auctionator" then return end
			if not self.iofSkinnedPanels[panel] then
				self.iofSkinnedPanels[panel] = true
				pCnt = pCnt + 1
				panel:SetBackdrop(nil)
				if panel.name == "Basic Options" then
					self:skinDropDown{obj=_G.AuctionatorOption_Deftab, x1=17, x2=109}
					if self.modChkBtns then
						self:skinCheckButton{obj=_G.AuctionatorOption_Enable_Alt_CB}
						self:skinCheckButton{obj=_G.AuctionatorOption_Enable_Autocomplete_CB}
						self:skinCheckButton{obj=_G.AuctionatorOption_Show_StartingPrice_CB}
						self:skinCheckButton{obj=_G.AuctionatorOption_Enable_Debug_CB}
					end
				elseif panel.name == "Tooltips" then
					self:skinDropDown{obj=_G.Atr_tipsShiftDD, x1=17, x2=109}
					self:skinDropDown{obj=_G.Atr_deDetailsDD, x2=29}
					if self.modChkBtns then
						self:skinCheckButton{obj=_G.ATR_tipsVendorOpt_CB}
						self:skinCheckButton{obj=_G.ATR_tipsAuctionOpt_CB}
						self:skinCheckButton{obj=_G.ATR_tipsAuctionWeekOpt_CB}
						self:skinCheckButton{obj=_G.ATR_tipsAuctionMonthOpt_CB}
						self:skinCheckButton{obj=_G.ATR_tipsDisenchantOpt_CB}
						self:skinCheckButton{obj=_G.ATR_tipsReagentOpt_CB}
					end
				elseif panel.name == "Undercutting" then
					self:skinMoneyFrame{obj=_G.UC_5000000_MoneyInput}
					self:skinMoneyFrame{obj=_G.UC_1000000_MoneyInput}
					self:skinMoneyFrame{obj=_G.UC_200000_MoneyInput}
					self:skinMoneyFrame{obj=_G.UC_50000_MoneyInput}
					self:skinMoneyFrame{obj=_G.UC_10000_MoneyInput}
					self:skinMoneyFrame{obj=_G.UC_2000_MoneyInput}
					self:skinMoneyFrame{obj=_G.UC_500_MoneyInput}
					self:skinEditBox{obj=_G.Atr_Starting_Discount, regs={6}} -- 6 is text
					if self.modBtns then
						self:skinStdButton{obj=_G.Atr_UCConfigFrame_Reset}
					end
				elseif panel.name == "Selling" then
					self:addSkinFrame{obj=_G.Atr_Stacking_List, ft="a", kfs=true, nb=true}
					if self.modBtns then
						self:skinStdButton{obj=_G.Atr_StackingOptionsFrame_Edit}
						self:skinStdButton{obj=_G.Atr_StackingOptionsFrame_New}
					end
					self:skinEditBox{obj=_G.Atr_Mem_EB_itemName, regs={6}} -- 6 is text
					self:skinDropDown{obj=_G.Atr_Mem_DD_numStacks}
					self:skinEditBox{obj=_G.Atr_Mem_EB_stackSize, regs={6}} -- 6 is text
					self:addSkinFrame{obj=_G.Atr_MemorizeFrame, ft="a", kfs=true, nb=true}
					if self.modBtns then
						self:skinStdButton{obj=_G.Atr_Mem_Forget}
						self:skinStdButton{obj=_G.Atr_Mem_Cancel}
						self:skinStdButton{obj=self:getPenultimateChild(_G.Atr_MemorizeFrame)} -- OKAY button
					end
				elseif panel.name == "Database" then
					self:skinDropDown{obj=_G.Atr_scanLevelDD, x2=-71}
					self:skinEditBox{obj=_G.Atr_ScanOpts_MaxHistAge, regs={6}} -- 6 is text
				elseif panel.name == "Pulizia" then
					if self.modBtns then
						for _, btn in pairs{panel:GetChildren()} do
							self:skinStdButton{obj=btn}
						end
					end
					self:addSkinFrame{obj=_G.Atr_ConfirmClear_Frame, ft="a", kfs=true, nb=true}
					if self.modBtns then
						self:skinStdButton{obj=_G.Atr_ClearConfirm_Cancel}
						self:skinStdButton{obj=self:getPenultimateChild(_G.Atr_ConfirmClear_Frame)}
					end
				elseif panel.name == "Shopping Lists" then
					self:addSkinFrame{obj=_G.Atr_ShpList_Frame, ft="a", kfs=true, nb=true}
					if self.modBtns then
						self:skinStdButton{obj=_G.Atr_ShpList_DeleteButton}
						self:skinStdButton{obj=_G.Atr_ShpList_EditButton}
						self:skinStdButton{obj=_G.Atr_ShpList_RenameButton}
						self:skinStdButton{obj=_G.Atr_ShpList_ImportButton}
						self:skinStdButton{obj=self:getPenultimateChild(panel)} -- duplicate object name
						self:skinStdButton{obj=_G.Atr_ShpList_ExportButton}
					end
					_G.Atr_ShpList_Edit_FrameScrollFrame:SetBackdrop(nil)
					self:skinSlider{obj=_G.Atr_ShpList_Edit_FrameScrollFrame.ScrollBar, rt="artwork"}
					self:addSkinFrame{obj=_G.Atr_ShpList_Edit_Frame, ft="a", kfs=true, nb=true}
					if self.modBtns then
						self:skinStdButton{obj=self:getChild(_G.Atr_ShpList_Edit_Frame, _G.Atr_ShpList_Edit_Frame:GetNumChildren() - 4)} -- cancel button
						self:skinStdButton{obj=_G.Atr_ShpList_ImportSaveBut}
						self:skinStdButton{obj=_G.Atr_ShpList_SaveBut}
						self:skinStdButton{obj=_G.Atr_ShpList_SelectAllBut}
					end
				-- About
				end
			end

			if pCnt == 8 then
				self.UnregisterCallback("Auctionator", "IOFPanel_Before_Skinning")
			end
		end)
	end

end
