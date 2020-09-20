local _, aObj = ...
if not aObj:isAddonEnabled("Auctionator") then return end
local _G = _G

aObj.addonsToSkin.Auctionator = function(self) -- v 8.3.3.2/100.0.9

	local skinFrames, skinConfigFrames
	local pCnt = 0

	if self.isClsc then
		function skinFrames()
			-- Classic version
			-- Buy Tab
			aObj:skinDropDown{obj=_G.Atr_DropDownSL}
			aObj:skinEditBox{obj=_G.Atr_Search_Box, regs={6}} -- 6 is text
			-- Atr_Hlist_ScrollFrame
			aObj:addSkinFrame{obj=_G.Atr_Hlist, ft="a", kfs=true, nb=true, x2=24}
			_G.Atr_HeadingsBarMiddle:SetTexture(nil)
			aObj:applySkin{obj=_G.Atr_Col1_Heading_Button}
			aObj:applySkin{obj=_G.Atr_Col3_Heading_Button}
			if aObj.modBtns then
				aObj:skinStdButton{obj=_G.Atr_Search_Button}
				aObj:skinStdButton{obj=_G.Auctionator1Button, y2=0}
				aObj:skinStdButton{obj=_G.Atr_FullScanButton, y1=0}
				aObj:skinStdButton{obj=_G.Atr_Back_Button}
				aObj:skinStdButton{obj=_G.Atr_AddToSListButton, x2=0}
				aObj:skinStdButton{obj=_G.Atr_RemFromSListButton, x1=0, x2=0}
				aObj:skinStdButton{obj=_G.Atr_SrchSListButton}
				aObj:skinStdButton{obj=_G.Atr_MngSListsButton}
				aObj:skinStdButton{obj=_G.Atr_NewSListButton}
				aObj:skinStdButton{obj=_G.Atr_Buy1_Button, x2=-1}
				aObj:skinStdButton{obj=_G.Atr_CancelSelectionButton, x1=1, x2=0}
				aObj:skinStdButton{obj=_G.AuctionatorCloseButton, x1=0}
				aObj:SecureHook("Atr_Search_Onclick", function()
					aObj:clrBtnBdr(_G.Atr_Search_Button)
					aObj:clrBtnBdr(_G.Atr_Buy1_Button)
					aObj:clrBtnBdr(_G.Atr_AddToSListButton)
					aObj:clrBtnBdr(_G.Atr_RemFromSListButton)
				end)
				aObj:SecureHook("Atr_Shop_OnFinishScan", function()
					aObj:clrBtnBdr(_G.Atr_Search_Button)
				end)
				aObj:SecureHook(Auctionator.SearchUI, "Disable", function()
					aObj:clrBtnBdr(_G.Atr_Buy1_Button)
					aObj:clrBtnBdr(_G.Atr_AddToSListButton)
					aObj:clrBtnBdr(_G.Atr_RemFromSListButton)
				end)
				aObj:SecureHook("Atr_Shop_UpdateUI", function()
					aObj:clrBtnBdr(_G.Atr_AddToSListButton)
					aObj:clrBtnBdr(_G.Atr_RemFromSListButton)
					aObj:clrBtnBdr(_G.Atr_SrchSListButton)
				end)
				aObj:SecureHook("Atr_AuctionFrameTab_OnClick", function()
					aObj:clrBtnBdr(_G.Atr_Buy1_Button)
				end)
				aObj:SecureHook("Atr_HighlightEntry", function(_)
					aObj:clrBtnBdr(_G.Atr_Buy1_Button)
					aObj:clrBtnBdr(_G.Atr_CancelSelectionButton)
				end)
			end
			if aObj.modChkBtns then
				aObj:skinCheckButton{obj=_G.Atr_Adv_Search_Button}
				aObj:skinCheckButton{obj=_G.Atr_Exact_Search_Button}
			end
			-- Sell Tab
			aObj:skinMoneyFrame{obj=_G.Atr_StackPrice}
			aObj:skinMoneyFrame{obj=_G.Atr_ItemPrice}
			aObj:skinMoneyFrame{obj=_G.Atr_StartingPrice}
			aObj:skinEditBox{obj=_G.Atr_Batch_NumAuctions, regs={6}} -- 6 is text
			aObj:skinEditBox{obj=_G.Atr_Batch_Stacksize, regs={6}} -- 6 is text
			aObj:skinDropDown{obj=_G.Atr_Duration}
			aObj:moveObject{obj=_G.Atr_Duration, x=40}
			aObj:addSkinFrame{obj=_G.Atr_Hilite1, ft="a", kfs=true, nb=true, x1=10}
			aObj:skinTabs{obj=_G.Atr_ListTabs, ignore=true, up=true, lod=true, x1=0, y1=-4, x2=0, y2=-2}
			if aObj.modBtns then
				aObj:skinStdButton{obj=_G.Atr_CreateAuctionButton}
				aObj:SecureHook("Atr_UpdateUI_SellPane", function()
					aObj:clrBtnBdr(_G.Atr_CreateAuctionButton)
				end)
			end
			-- More... Tab
			if aObj.modBtns then
				aObj:skinStdButton{obj=_G.Atr_CheckActiveButton}
			end

		end
		function skinConfigFrames(panel)
			if panel.parent ~= "Auctionator" then return end
			if not aObj.iofSkinnedPanels[panel] then
				aObj.iofSkinnedPanels[panel] = true
				pCnt = pCnt + 1
				panel:SetBackdrop(nil)
				if panel.name == "Basic Options" then
					aObj:skinDropDown{obj=_G.AuctionatorOption_Deftab, x1=17, x2=109}
					if aObj.modChkBtns then
						aObj:skinCheckButton{obj=_G.AuctionatorOption_Enable_Alt_CB}
						aObj:skinCheckButton{obj=_G.AuctionatorOption_Enable_Autocomplete_CB}
						aObj:skinCheckButton{obj=_G.AuctionatorOption_Show_StartingPrice_CB}
						aObj:skinCheckButton{obj=_G.AuctionatorOption_Enable_Debug_CB}
					end
				elseif panel.name == "Tooltips" then
					aObj:skinDropDown{obj=_G.Atr_tipsShiftDD, x1=17, x2=109}
					aObj:skinDropDown{obj=_G.Atr_deDetailsDD, x2=29}
					if aObj.modChkBtns then
						aObj:skinCheckButton{obj=_G.ATR_tipsVendorOpt_CB}
						aObj:skinCheckButton{obj=_G.ATR_tipsAuctionOpt_CB}
						aObj:skinCheckButton{obj=_G.ATR_tipsAuctionWeekOpt_CB}
						aObj:skinCheckButton{obj=_G.ATR_tipsAuctionMonthOpt_CB}
						aObj:skinCheckButton{obj=_G.ATR_tipsDisenchantOpt_CB}
						aObj:skinCheckButton{obj=_G.ATR_tipsReagentOpt_CB}
					end
				elseif panel.name == "Undercutting" then
					aObj:skinMoneyFrame{obj=_G.UC_5000000_MoneyInput}
					aObj:skinMoneyFrame{obj=_G.UC_1000000_MoneyInput}
					aObj:skinMoneyFrame{obj=_G.UC_200000_MoneyInput}
					aObj:skinMoneyFrame{obj=_G.UC_50000_MoneyInput}
					aObj:skinMoneyFrame{obj=_G.UC_10000_MoneyInput}
					aObj:skinMoneyFrame{obj=_G.UC_2000_MoneyInput}
					aObj:skinMoneyFrame{obj=_G.UC_500_MoneyInput}
					aObj:skinEditBox{obj=_G.Atr_Starting_Discount, regs={6}} -- 6 is text
					if aObj.modBtns then
						aObj:skinStdButton{obj=_G.Atr_UCConfigFrame_Reset}
					end
				elseif panel.name == "Selling" then
					aObj:addSkinFrame{obj=_G.Atr_Stacking_List, ft="a", kfs=true, nb=true}
					aObj:skinEditBox{obj=_G.Atr_Mem_EB_itemName, regs={6}} -- 6 is text
					aObj:skinDropDown{obj=_G.Atr_Mem_DD_numStacks}
					aObj:skinEditBox{obj=_G.Atr_Mem_EB_stackSize, regs={6}} -- 6 is text
					aObj:addSkinFrame{obj=_G.Atr_MemorizeFrame, ft="a", kfs=true, nb=true}
					if aObj.modBtns then
						aObj:skinStdButton{obj=_G.Atr_StackingOptionsFrame_Edit}
						aObj:skinStdButton{obj=_G.Atr_StackingOptionsFrame_New}
						aObj:skinStdButton{obj=_G.Atr_Mem_Forget}
						aObj:skinStdButton{obj=_G.Atr_Mem_Cancel}
						aObj:skinStdButton{obj=aObj:getPenultimateChild(_G.Atr_MemorizeFrame)} -- OKAY button
						aObj:SecureHook("Atr_StackingList_Display", function()
							aObj:clrBtnBdr(_G.Atr_StackingOptionsFrame_Edit)
						end)
					end
				elseif panel.name == "Database" then
					aObj:skinDropDown{obj=_G.Atr_scanLevelDD, x2=-71}
					aObj:skinEditBox{obj=_G.Atr_ScanOpts_MaxHistAge, regs={6}} -- 6 is text
				elseif panel.name == "Pulizia" then
					if aObj.modBtns then
						for _, btn in pairs{panel:GetChildren()} do
							aObj:skinStdButton{obj=btn}
						end
					end
					aObj:addSkinFrame{obj=_G.Atr_ConfirmClear_Frame, ft="a", kfs=true, nb=true}
					if aObj.modBtns then
						aObj:skinStdButton{obj=_G.Atr_ClearConfirm_Cancel}
						aObj:skinStdButton{obj=aObj:getPenultimateChild(_G.Atr_ConfirmClear_Frame)}
					end
				elseif panel.name == "Shopping Lists" then
					aObj:addSkinFrame{obj=_G.Atr_ShpList_Frame, ft="a", kfs=true, nb=true}
					if aObj.modBtns then
						aObj:skinStdButton{obj=_G.Atr_ShpList_DeleteButton}
						aObj:skinStdButton{obj=_G.Atr_ShpList_EditButton}
						aObj:skinStdButton{obj=_G.Atr_ShpList_RenameButton}
						aObj:skinStdButton{obj=_G.Atr_ShpList_ImportButton}
						aObj:skinStdButton{obj=aObj:getPenultimateChild(panel)} -- duplicate object name
						aObj:skinStdButton{obj=_G.Atr_ShpList_ExportButton}
						aObj:SecureHook("Atr_ShpLists_Display", function()
							aObj:clrBtnBdr(_G.Atr_ShpList_DeleteButton)
							aObj:clrBtnBdr(_G.Atr_ShpList_EditButton)
							aObj:clrBtnBdr(_G.Atr_ShpList_RenameButton)
						end)
					end
					_G.Atr_ShpList_Edit_FrameScrollFrame:SetBackdrop(nil)
					aObj:skinSlider{obj=_G.Atr_ShpList_Edit_FrameScrollFrame.ScrollBar, rt="artwork"}
					aObj:addSkinFrame{obj=_G.Atr_ShpList_Edit_Frame, ft="a", kfs=true, nb=true}
					if aObj.modBtns then
						aObj:skinStdButton{obj=aObj:getChild(_G.Atr_ShpList_Edit_Frame, _G.Atr_ShpList_Edit_Frame:GetNumChildren() - 4)} -- cancel button
						aObj:skinStdButton{obj=_G.Atr_ShpList_ImportSaveBut}
						aObj:skinStdButton{obj=_G.Atr_ShpList_SaveBut}
						aObj:skinStdButton{obj=_G.Atr_ShpList_SelectAllBut}
					end
				-- About
				end
			end

			if pCnt == 8 then
				aObj.UnregisterCallback("Auctionator", "IOFPanel_Before_Skinning")
			end
		end
	else
		local function skinHdrs(frame)
			aObj:SecureHook(frame, "UpdateTable", function(this)
				if this.tableBuilder then
					for hdr in this.tableBuilder.headerPoolCollection:EnumerateActive() do
						aObj:removeRegions(hdr, {1, 2, 3})
						aObj:addSkinFrame{obj=hdr, ft=ftype, nb=true, ofs=1}
					end
				end
			end)
		end
		function skinFrames()
			-- Retail version
			if _G.Auctionator.State.SplashScreenRef then
				_G.Auctionator.State.SplashScreenRef.Bg:SetTexture(nil)
				aObj:removeNineSlice(_G.Auctionator.State.SplashScreenRef.NineSlice)
				aObj:skinSlider{obj=_G.Auctionator.State.SplashScreenRef.ScrollFrame.ScrollBar}
				aObj:addSkinFrame{obj=_G.Auctionator.State.SplashScreenRef, ft="a", kfs=true, nb=true, ri=true}
				if aObj.modBtns then
					aObj:skinCloseButton{obj=_G.Auctionator.State.SplashScreenRef.Close}
				end
				if aObj.modChkBtns then
					aObj:skinCheckButton{obj=_G.Auctionator.State.SplashScreenRef.HideCheckbox.CheckBox}
				end
			end

			-- Tabs
			if _G.Auctionator.State.TabFrameRef then
				for key, tab in _G.pairs(_G.Auctionator.State.TabFrameRef.Tabs) do
					-- aObj:Debug("Auctionator Tab: [%s, %s, %s, %s]", key, tab, tab.displayMode, tab.ahTabIndex)
					aObj:keepRegions(tab, {7, 8})
					aObj:addSkinFrame{obj=tab, ft=ftype, kfs=true, nb=true, noBdr=aObj.isTT, x1=6, y1=0, x2=-6, y2=2}
					if aObj.isTT then
						aObj:setInactiveTab(tab.sf)
						-- add to table to display tab textures
						_G.AuctionHouseFrame.tabsForDisplayMode[tab.displayMode] = tab.ahTabIndex
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

			local aslf = _G.AuctionatorShoppingListFrame
			aslf.Bg:SetTexture(nil)
			aObj:removeNineSlice(aslf.NineSlice)
			aObj:skinDropDown{obj=aslf.ListDropdown}
			aslf.ScrollList.ScrollFrame.ArtOverlay:DisableDrawLayer("OVERLAY")
			aObj:removeInset(aslf.ScrollList.InsetFrame)
			aObj:skinSlider{obj=aslf.ScrollList.ScrollFrame.scrollBar, wdth=-4}
			aObj:skinSlider{obj=aslf.ResultsListing.ScrollFrame.scrollBar, wdth=-4}
			aObj:getChild(aslf, 8).Bg:SetTexture(nil) -- Background for Add & Search buttons
			for _, child in ipairs{aslf.ResultsListing.HeaderContainer:GetChildren()} do
				aObj:keepRegions(child, {4, 5, 6}) -- N.B. regions 4 is text, 5 is highlight, 6 is arrow
				aObj:addSkinFrame{obj=child, ft="a", kfs=true, nb=true, ofs=1, x1=-2, x2=2}
			end
			if aObj.modBtns then
				aObj:skinStdButton{obj=aslf.CreateList}
				aObj:skinStdButton{obj=aslf.DeleteList}
				aObj:SecureHook(aslf.DeleteList, "UpdateDisabled", function(this)
					aObj:clrBtnBdr(this)
				end)
				aObj:skinStdButton{obj=aslf.Rename}
				aObj:skinStdButton{obj=aslf.AddItem}
				aObj:skinStdButton{obj=aslf.ManualSearch}
				for _, btn in _G.pairs{"AddItem", "Rename", "ManualSearch"} do
					aObj:SecureHook(aslf[btn], "Disable", function(this, _)
						aObj:clrBtnBdr(this)
					end)
					aObj:SecureHook(aslf[btn], "Enable", function(this, _)
						aObj:clrBtnBdr(this)
					end)
				end
			end
			aslf = nil

			local aaif = _G.AuctionatorAddItemFrame
			aObj:skinEditBox{obj=aaif.SearchContainer.SearchString, regs={6}} -- 6 is text
			aObj:skinDropDown{obj=aaif.FilterKeySelector}
			for _, level in pairs{"LevelRange", "ItemLevelRange", "PriceRange", "CraftedLevelRange"} do
				aObj:skinEditBox{obj=aaif[level].MinBox, regs={6}} -- 6 is text
				aObj:skinEditBox{obj=aaif[level].MaxBox, regs={6}} -- 6 is text
			end
			aObj:addSkinFrame{obj=aaif, ft="a", kfs=true, nb=true, ri=true}
			if aObj.modBtns then
				aObj:skinStdButton{obj=aaif.AddItem}
				aObj:skinStdButton{obj=aaif.Cancel}
				aObj:skinStdButton{obj=aaif.ResetAllButton}
			end
			if aObj.modChkBtns then
				aObj:skinCheckButton{obj=aaif.SearchContainer.IsExact}
			end
			aaif = nil

			_G.AuctionatorSellingFrame.Bg:SetTexture(nil)
			aObj:removeNineSlice(_G.AuctionatorSellingFrame.NineSlice)
			local asi = _G.AuctionatorSellingFrame.AuctionatorSaleItem
			asi.Icon.EmptySlot:SetTexture(nil)
			aObj.modUIBtns:addButtonBorder{obj=asi.Icon, relTo=asi.Icon.Icon}
			aObj:SecureHook(asi.Icon, "SetItemInfo", function(this, _)
				aObj:clrButtonFromBorder(this)
			end)
			aObj:skinEditBox{obj=asi.Quantity.InputBox, regs={6}} -- 6 is text
			if aObj.modBtns then
				aObj:skinStdButton{obj=asi.MaxButton}
				aObj:SecureHookScript(asi, "OnUpdate", function(this)
					aObj:clrBtnBdr(this.MaxButton)
				end)
				aObj:SecureHook(asi, "UpdateForNoItem", function(this)
					aObj:clrBtnBdr(this.MaxButton)
				end)
				aObj:skinStdButton{obj=asi.PostButton}
				aObj:SecureHook(asi, "UpdatePostButtonState", function(this)
					aObj:clrBtnBdr(this.PostButton)
				end)
			end
			aObj:skinEditBox{obj= asi.Price.MoneyInput.GoldBox, regs={6}} -- 6 is text
			aObj:skinEditBox{obj= asi.Price.MoneyInput.SilverBox, regs={6}} -- 6 is text
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=aObj:getPenultimateChild(asi), ofs=-2, x1=1, clr="gold"} -- RefreshButton
			end
			asi = nil
			aObj:skinSlider{obj=_G.AuctionatorSellingFrame.BagListing.ScrollFrame.ScrollBar, rt="artwork", wdth=-4}--, size=3, hgt=-10}
			local ilf = _G.AuctionatorSellingFrame.BagListing.ScrollFrame.ItemListingFrame
			local kids, child = {ilf:GetChildren()}
			for i = 1, #kids do
				child = kids[i]
				aObj:keepRegions(child.SectionTitle, {3, 4, 5}) -- N.B. region 3 is highlight, 4 is selected, 5 is text
				aObj:addSkinFrame{obj=child.SectionTitle, ft=ftype, kfs=true, nb=true, aso={bd=5}, ofs=0, x1=-2, x2=2}
			end
			ilf, kids, child = nil, nil, nil
			aObj:skinSlider{obj=_G.AuctionatorSellingFrame.CurrentItemListing.ScrollFrame.scrollBar, rt="artwork", wdth=-4}
			skinHdrs(_G.AuctionatorSellingFrame.CurrentItemListing)
			aObj:skinSlider{obj=_G.AuctionatorSellingFrame.HistoricalPriceListing.ScrollFrame.scrollBar, rt="artwork", wdth=-4}
			skinHdrs(_G.AuctionatorSellingFrame.HistoricalPriceListing)

			_G.AuctionatorCancellingFrame.Bg:SetTexture(nil)
			aObj:removeNineSlice(_G.AuctionatorCancellingFrame.NineSlice)
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=aObj:getChild(_G.AuctionatorCancellingFrame, 2), ofs=-2, x1=1, clr="gold"} -- RefreshButton
			end
			_G.AuctionatorCancellingFrame.ResultsListing.ScrollFrame.scrollBar.Background:SetTexture(nil)
			aObj:skinSlider{obj=_G.AuctionatorCancellingFrame.ResultsListing.ScrollFrame.scrollBar, rt="artwork", wdth=-4}
			for _, child in _G.ipairs{_G.AuctionatorCancellingFrame.ResultsListing.HeaderContainer:GetChildren()} do
				aObj:keepRegions(child, {4, 5, 6}) -- N.B. regions 4 is text, 5 is highlight, 6 is arrow
				aObj:addSkinFrame{obj=child, ft="a", kfs=true, nb=true, ofs=1, x1=-2, x2=2}
			end
			local frame = self:getLastChild(_G.AuctionatorCancellingFrame)
			frame.Bg:SetTexture(nil)
			if aObj.modBtns then
				aObj:skinStdButton{obj=frame.StartScanButton}
				aObj:SecureHook(frame.StartScanButton, "SetEnabled", function(this)
					aObj:clrBtnBdr(this)
				end)
				aObj:skinStdButton{obj=frame.CancelNextButton}
				aObj:SecureHook(frame.CancelNextButton, "SetEnabled", function(this)
					aObj:clrBtnBdr(this)
				end)
			end
			frame = nil

			_G.AuctionatorConfigFrame.Bg:SetTexture(nil)
			aObj:removeNineSlice(_G.AuctionatorConfigFrame.NineSlice)
			aObj:skinEditBox{obj=_G.AuctionatorConfigFrame.DiscordLink.InputBox, regs={6}} -- 6 is text
			aObj:skinEditBox{obj=_G.AuctionatorConfigFrame.BugReportLink.InputBox, regs={6}} -- 6 is text
			aObj:skinEditBox{obj=_G.AuctionatorConfigFrame.TechnicalRoadmap.InputBox, regs={6}} -- 6 is text
			if aObj.modBtns then
				aObj:skinStdButton{obj=_G.AuctionatorConfigFrame.ScanButton}
				aObj:skinStdButton{obj=_G.AuctionatorConfigFrame.OptionsButton}
			end
		end
		local function skinKids(panel)
			for _, child in _G.ipairs{panel:GetChildren()} do
				if child:IsObjectType("CheckButton")
				and aObj.modChkBtns
				then
					aObj:skinCheckButton{obj=child}
				elseif child:IsObjectType("EditBox") then
					aObj:skinEditBox{obj=child, regs={1, 6}} --1 & 6 are text
				elseif aObj:isDropDown(child) then
					aObj:skinDropDown{obj=child}
				elseif child:IsObjectType("Frame") then
					skinKids(child)
				end
			end
		end
		function skinConfigFrames(panel)
			if aObj:hasTextInName(panel, "AuctionatorConfig")
			and not aObj.iofSkinnedPanels[panel]
			then
				aObj.iofSkinnedPanels[panel] = true
				pCnt = pCnt + 1
				skinKids(panel)
			end
			if pCnt == 7 then
				aObj.UnregisterCallback("Auctionator_Config", "IOFPanel_Before_Skinning")
			end
		end
	end

	self.RegisterCallback("Auctionator", "Auction_House_Show", function(this)
		_G.C_Timer.After(0.25, function()
			skinFrames()
		end)

		self.UnregisterCallback("Auctionator", "Auction_House_Show")
	end)

	self.RegisterCallback("Auctionator_Config", "IOFPanel_Before_Skinning", function(this, panel)
		skinConfigFrames(panel)
	end)

end
