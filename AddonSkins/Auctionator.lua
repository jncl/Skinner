local _, aObj = ...
if not aObj:isAddonEnabled("Auctionator") then return end
local _G = _G

aObj.addonsToSkin.Auctionator = function(self) -- v 9.0.3.1/100.0.11

	local skinFrames, skinConfigFrames
	local pCnt = 0

	if self.isClsc then
		function skinFrames()
			-- Classic version
			-- Buy Tab
			aObj:skinObject("dropdown", {obj=_G.Atr_DropDownSL})
			aObj:skinObject("editbox", {obj=_G.Atr_Search_Box})
			aObj:skinObject("slider", {obj=_G.Atr_Hlist_ScrollFrame.ScrollBar})
			aObj:skinObject("frame", {obj=_G.Atr_Hlist, kfs=true, fb=true, x1=-5, x2=9})
			_G.Atr_Hlist.SetBackdrop = _G.nop
			_G.Atr_HeadingsBarMiddle:SetTexture(nil)
			aObj:skinObject("frame", {obj=_G.Atr_Col1_Heading_Button, ofs=0})
			aObj:skinObject("frame", {obj=_G.Atr_Col3_Heading_Button, ofs=0})
			aObj:skinObject("slider", {obj=_G.AuctionatorScrollFrame.ScrollBar})
			if aObj.modBtns then
				aObj:skinStdButton{obj=_G.Atr_Search_Button}
				aObj:skinStdButton{obj=_G.Auctionator1Button, y2=0}
				aObj:adjHeight{obj=_G.Auctionator1Button, adj=2}
				aObj:skinStdButton{obj=_G.Atr_FullScanButton, y1=0}
				aObj:adjHeight{obj=_G.Atr_FullScanButton, adj=2}
				aObj:skinStdButton{obj=_G.Atr_Back_Button}
				aObj:adjHeight{obj=_G.Atr_Back_Button, adj=2}
				aObj:skinStdButton{obj=_G.Atr_SaveThisList_Button}
				aObj:adjHeight{obj=_G.Atr_SaveThisList_Button, adj=2}
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
				aObj:SecureHook(_G.Auctionator.SearchUI, "Disable", function()
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
			aObj:skinObject("editbox", {obj=_G.Atr_Batch_NumAuctions})
			aObj:skinObject("editbox", {obj=_G.Atr_Batch_Stacksize})
			aObj:skinObject("dropdown", {obj=_G.Atr_Duration})
			aObj:moveObject{obj=_G.Atr_Duration, x=40}
			aObj:skinObject("frame", {obj=_G.Atr_Hilite1, kfs=true, fb=true})
			aObj:skinObject("tabs", {obj=_G.Atr_ListTabs, prefix=_G.Atr_ListTabs:GetName(), ignoreSize=true, lod=self.isTT and true, upwards=true,  offsets={x1=4, y1=-4, x2=-4, y2=-4}})
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
					aObj:skinObject("dropdown", {obj=_G.AuctionatorOption_Deftab, x1=17, x2=109})
					if aObj.modChkBtns then
						aObj:skinCheckButton{obj=_G.AuctionatorOption_Enable_Alt_CB}
						aObj:skinCheckButton{obj=_G.AuctionatorOption_Enable_Autocomplete_CB}
						aObj:skinCheckButton{obj=_G.AuctionatorOption_Show_StartingPrice_CB}
						aObj:skinCheckButton{obj=_G.AuctionatorOption_Enable_Debug_CB}
					end
				elseif panel.name == "Tooltips" then
					aObj:skinObject("dropdown", {obj=_G.Atr_tipsShiftDD, x1=17, x2=109})
					aObj:skinObject("dropdown", {obj=_G.Atr_deDetailsDD, x2=29})
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
					aObj:skinObject("editbox", {obj=_G.Atr_Starting_Discount})
					if aObj.modBtns then
						aObj:skinStdButton{obj=_G.Atr_UCConfigFrame_Reset}
					end
				elseif panel.name == "Selling" then
					aObj:skinObject("frame", {obj=_G.Atr_Stacking_List, kfs=true,fb=true, ofs=0})
					_G.Atr_Stacking_List.SetBackdrop = _G.nop
					aObj:skinObject("editbox", {obj=_G.Atr_Mem_EB_itemName})
					aObj:skinObject("dropdown", {obj=_G.Atr_Mem_DD_numStacks})
					aObj:skinObject("editbox", {obj=_G.Atr_Mem_EB_stackSize})
					aObj:skinObject("frame", {obj=_G.Atr_MemorizeFrame, kfs=true, ofs=0})
					if aObj.modBtns then
						aObj:skinStdButton{obj=_G.Atr_StackingOptionsFrame_Edit}
						aObj:adjHeight{obj=_G.Atr_StackingOptionsFrame_Edit, adj=2}
						aObj:skinStdButton{obj=_G.Atr_StackingOptionsFrame_New}
						aObj:adjHeight{obj=_G.Atr_StackingOptionsFrame_New, adj=2}
						aObj:skinStdButton{obj=_G.Atr_Mem_Forget}
						aObj:skinStdButton{obj=_G.Atr_Mem_Cancel}
						aObj:skinStdButton{obj=aObj:getPenultimateChild(_G.Atr_MemorizeFrame)} -- OKAY button
						aObj:SecureHook("Atr_StackingList_Display", function()
							aObj:clrBtnBdr(_G.Atr_StackingOptionsFrame_Edit)
						end)
					end
				elseif panel.name == "Database" then
					aObj:skinObject("dropdown", {obj=_G.Atr_scanLevelDD, x2=-71})
					aObj:skinObject("editbox", {obj=_G.Atr_ScanOpts_MaxHistAge})
				elseif panel.name == "Pulizia" then
					if aObj.modBtns then
						for _, btn in _G.pairs{panel:GetChildren()} do
							aObj:skinStdButton{obj=btn}
						end
					end
					aObj:skinObject("frame", {obj=_G.Atr_ConfirmClear_Frame, kfs=true})
					if aObj.modBtns then
						aObj:skinStdButton{obj=_G.Atr_ClearConfirm_Cancel}
						aObj:skinStdButton{obj=aObj:getPenultimateChild(_G.Atr_ConfirmClear_Frame)}
					end
				elseif panel.name == "Shopping Lists" then
					aObj:skinObject("frame", {obj=_G.Atr_ShpList_Frame, kfs=true, fb=true})
					_G.Atr_ShpList_Frame.SetBackdrop = _G.nop
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
					-- _G.Atr_ShpList_Edit_FrameScrollFrame:SetBackdrop(nil)
					aObj:skinObject("slider", {obj=_G.Atr_ShpList_Edit_FrameScrollFrame.ScrollBar, rpTex="artwork"})
					aObj:skinObject("frame", {obj=_G.Atr_ShpList_Edit_Frame, kfs=true, ofs=0})
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
						-- aObj:addSkinFrame{obj=hdr, ft="a", nb=true, ofs=1}
						aObj:skinObject("frame", {obj=hdr, ofs=1})
					end
				end
			end)
		end
		function skinFrames()
			-- Retail version
			if _G.Auctionator.State.SplashScreenRef then
				_G.Auctionator.State.SplashScreenRef.Bg:SetTexture(nil)
				aObj:removeNineSlice(_G.Auctionator.State.SplashScreenRef.NineSlice)
				aObj:skinObject("slider", {obj=_G.Auctionator.State.SplashScreenRef.ScrollFrame.ScrollBar})
				aObj:skinObject("frame", {obj=_G.Auctionator.State.SplashScreenRef, kfs=true, ri=true, ofs=0, y1=-2, x2=-1})
				if aObj.modBtns then
					aObj:skinCloseButton{obj=_G.Auctionator.State.SplashScreenRef.Close}
				end
				if aObj.modChkBtns then
					aObj:skinCheckButton{obj=_G.Auctionator.State.SplashScreenRef.HideCheckbox.CheckBox}
				end
			end

			if _G.Auctionator.State.TabFrameRef then
				aObj:skinObject("tabs", {obj=_G.Auctionator.State.TabFrameRef, tabs=_G.Auctionator.State.TabFrameRef.Tabs})
				for key, tab in _G.pairs(_G.Auctionator.State.TabFrameRef.Tabs) do
					if aObj.isTT then
						aObj:setInactiveTab(tab.sf)
						-- add to table to display tab textures
						_G.AuctionHouseFrame.tabsForDisplayMode[tab.displayMode] = key + 3
					end
				end
			end

			aObj:SecureHookScript(_G.AuctionatorShoppingListFrame, "OnShow", function(this)
				this:DisableDrawLayer("BACKGROUND")
				aObj:skinObject("dropdown", {obj=this.ListDropdown})
				this.ScrollList:DisableDrawLayer("BACKGROUND")
				aObj:removeInset(this.ScrollList.InsetFrame)
				aObj:skinObject("slider", {obj=this.ScrollList.ScrollFrame.scrollBar, y1=-2, y2=2})
				aObj:skinObject("slider", {obj=this.ResultsListing.ScrollFrame.scrollBar, y1=-2, y2=2})
				aObj:removeInset(this.ShoppingResultsInset)
				for _, child in _G.ipairs{this.ResultsListing.HeaderContainer:GetChildren()} do
					aObj:keepRegions(child, {4, 5, 6}) -- N.B. regions 4 is text, 5 is highlight, 6 is arrow
					aObj:skinObject("frame", {obj=child, kfs=true, ofs=1, x1=-2, x2=2})
				end
				if aObj.modBtns then
					aObj:skinStdButton{obj=this.CreateList}
					aObj:skinStdButton{obj=this.DeleteList}
					aObj:SecureHook(this.DeleteList, "UpdateDisabled", function(this)
						aObj:clrBtnBdr(this)
					end)
					aObj:skinStdButton{obj=this.Rename}
					aObj:skinStdButton{obj=this.Export}
					aObj:skinStdButton{obj=this.Import}
					aObj:skinStdButton{obj=this.AddItem}
					aObj:skinStdButton{obj=this.ManualSearch}
					aObj:skinStdButton{obj=this.ExportCSV}
					aObj:SecureHook(this, "ReceiveEvent", function(this, _)
						aObj:clrBtnBdr(this.Rename)
						aObj:clrBtnBdr(this.Export)
						aObj:clrBtnBdr(this.Import)
						aObj:clrBtnBdr(this.AddItem)
						aObj:clrBtnBdr(this.ManualSearch)
					end)
				end

				aObj:Unhook(this, "OnShow")
			end)

			aObj:SecureHookScript(_G.AuctionatorAddItemFrame, "OnShow", function(this)
				aObj:skinObject("editbox", {obj=this.SearchContainer.SearchString})
				aObj:skinObject("dropdown", {obj=this.FilterKeySelector})
				for _, level in _G.pairs{"LevelRange", "ItemLevelRange", "PriceRange", "CraftedLevelRange"} do
					aObj:skinObject("editbox", {obj=this[level].MinBox})
					aObj:skinObject("editbox", {obj=this[level].MaxBox})
				end
				aObj:skinObject("frame", {obj=this, kfs=true, ri=true})
				if aObj.modBtns then
					aObj:skinStdButton{obj=this.Finished}
					aObj:skinStdButton{obj=this.Cancel}
					aObj:skinStdButton{obj=this.ResetAllButton}
				end
				if aObj.modChkBtns then
					aObj:skinCheckButton{obj=this.SearchContainer.IsExact}
				end

				aObj:Unhook(this, "OnShow")
			end)

			aObj:SecureHookScript(_G.AuctionatorEditItemFrame, "OnShow", function(this)
				aObj:skinObject("editbox", {obj=this.SearchContainer.SearchString})
				aObj:skinObject("dropdown", {obj=this.FilterKeySelector})
				for _, level in _G.pairs{"LevelRange", "ItemLevelRange", "PriceRange", "CraftedLevelRange"} do
					aObj:skinObject("editbox", {obj=this[level].MinBox})
					aObj:skinObject("editbox", {obj=this[level].MaxBox})
				end
				aObj:skinObject("frame", {obj=this, kfs=true, ri=true})
				if aObj.modBtns then
					aObj:skinStdButton{obj=this.Finished}
					aObj:skinStdButton{obj=this.Cancel}
					aObj:skinStdButton{obj=this.ResetAllButton}
				end
				if aObj.modChkBtns then
					aObj:skinCheckButton{obj=this.SearchContainer.IsExact}
				end

				aObj:Unhook(this, "OnShow")
			end)

			aObj:SecureHookScript(_G.AuctionatorExportListFrame, "OnShow", function(this)
				aObj:skinObject("slider", {obj=this.ScrollFrame.ScrollBar, rpTex="artwork"})
				aObj:skinObject("frame", {obj=this, kfs=true, ri=true})
				if aObj.modBtns then
					 aObj:skinCloseButton{obj=this.CloseDialog}
					 aObj:skinStdButton{obj=this.SelectAll}
					 aObj:skinStdButton{obj=this.UnselectAll}
					 aObj:skinStdButton{obj=this.Export}
				end
				if aObj.modChkBtns then
					local function skinCBs()
						for idx, frame in _G.ipairs(this.checkBoxPool) do
							aObj:skinCheckButton{obj=frame.CheckBox}
						end
					end
					aObj:SecureHook(this, "RefreshLists", function(this)
						skinCBs()
					end)
					skinCBs()
				end

				aObj:Unhook(this, "OnShow")
			end)

			aObj:SecureHookScript(_G.AuctionatorImportListFrame, "OnShow", function(this)
				aObj:skinObject("slider", {obj=this.ScrollFrame.ScrollBar, rpTex="artwork"})
				aObj:skinObject("frame", {obj=this, kfs=true, ri=true})
				if aObj.modBtns then
					 aObj:skinCloseButton{obj=this.CloseDialog}
					 aObj:skinStdButton{obj=this.Import}
				end

				aObj:Unhook(this, "OnShow")
			end)

			aObj:SecureHookScript(_G.AuctionatorCopyTextFrame, "OnShow", function(this)
				aObj:skinObject("slider", {obj=this.ScrollFrame.ScrollBar})
				aObj:skinObject("frame", {obj=this, kfs=true, ri=true})
				if aObj.modBtns then
					aObj:skinStdButton{obj=this.Close}
				end

				aObj:Unhook(this, "OnShow")
			end)

			aObj:SecureHookScript(_G.AuctionatorSellingFrame, "OnShow", function(this)
				local asi = this.AuctionatorSaleItem
				asi.Icon.EmptySlot:SetTexture(nil)
				aObj.modUIBtns:addButtonBorder{obj=asi.Icon, relTo=asi.Icon.Icon, clr="white"}
				aObj:SecureHook(asi.Icon, "SetItemInfo", function(this, _)
					aObj:clrButtonFromBorder(this)
				end)
				aObj:skinObject("editbox", {obj=asi.Quantity.InputBox})
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
				aObj:skinObject("editbox", {obj=asi.Price.MoneyInput.GoldBox, ofs=-4})
				aObj:skinObject("editbox", {obj=asi.Price.MoneyInput.SilverBox, ofs=-4})
				if aObj.modBtnBs then
					aObj:addButtonBorder{obj=aObj:getPenultimateChild(asi), ofs=-2, x1=1, clr="gold"} -- RefreshButton
				end
				asi = nil
				aObj:skinObject("slider", {obj=this.BagListing.ScrollFrame.ScrollBar, rpTex="artwork"})
				for _, child in _G.pairs{this.BagListing.ScrollFrame.ItemListingFrame:GetChildren()} do
					aObj:keepRegions(child.SectionTitle, {3, 4, 5}) -- N.B. region 3 is highlight, 4 is selected, 5 is text
					aObj:skinObject("frame", {obj=child.SectionTitle, kfs=true, bd=5, ofs=0, x1=-2, x2=2})
				end
				aObj:removeInset(this.BagInset)
				aObj:skinObject("slider", {obj=this.CurrentItemListing.ScrollFrame.scrollBar, rpTex="artwork"})
				skinHdrs(this.CurrentItemListing)
				aObj:removeInset(this.CurrentItemInset)
				aObj:skinObject("slider", {obj=this.HistoricalPriceListing.ScrollFrame.scrollBar, rpTex="artwork"})
				skinHdrs(this.HistoricalPriceListing)
				aObj:skinObject("slider", {obj=this.PostingHistoryListing.ScrollFrame.scrollBar, rpTex="artwork"})
				skinHdrs(this.PostingHistoryListing)
				aObj:removeInset(this.HistoricalPriceInset)
				-- CurrentItemProvider
				-- HistoricalPriceProvider
				-- PostingHistoryProvider
				-- ConfirmDropDown
				aObj:skinObject("tabs", {obj=this.HistoryTabsContainer, tabs=this.HistoryTabsContainer.Tabs, ignoreSize=true, lod=true, upwards=true})

				aObj:Unhook(this, "OnShow")
			end)

			aObj:SecureHookScript(_G.AuctionatorCancellingFrame, "OnShow", function(this)
				if aObj.modBtnBs then
					aObj:addButtonBorder{obj=aObj:getChild(this, 1), ofs=-2, x1=1, clr="gold"} -- RefreshButton
				end
				this.ResultsListing.ScrollFrame.scrollBar.Background:SetTexture(nil)
				aObj:skinObject("slider", {obj=this.ResultsListing.ScrollFrame.scrollBar, rpTex="artwork"})
				for _, child in _G.ipairs{this.ResultsListing.HeaderContainer:GetChildren()} do
					aObj:keepRegions(child, {4, 5, 6}) -- N.B. regions 4 is text, 5 is highlight, 6 is arrow
					aObj:skinObject("frame", {obj=child, kfs=true, ofs=1, x1=-2, x2=2})
				end
				aObj:removeInset(this.HistoricalPriceInset)
				local frame = aObj:getLastChild(this) -- UndercutScan
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

				aObj:Unhook(this, "OnShow")
			end)

			aObj:SecureHookScript(_G.AuctionatorConfigFrame, "OnShow", function(this)
				aObj:removeInset(this)
				this:DisableDrawLayer("BACKGROUND")
				aObj:skinObject("editbox", {obj=this.DiscordLink.InputBox})
				aObj:skinObject("editbox", {obj=this.BugReportLink.InputBox})
				aObj:skinObject("editbox", {obj=this.TechnicalRoadmap.InputBox})
				if aObj.modBtns then
					aObj:skinStdButton{obj=this.ScanButton}
					aObj:skinStdButton{obj=this.OptionsButton}
				end

				aObj:Unhook(this, "OnShow")
			end)
		end

		local function skinKids(panel)
			for _, child in _G.ipairs{panel:GetChildren()} do
				if child:IsObjectType("CheckButton")
				and aObj.modChkBtns
				then
					aObj:skinCheckButton{obj=child}
				elseif child:IsObjectType("EditBox") then
					aObj:skinObject("editbox", {obj=child})
				elseif aObj:isDropDown(child) then
					aObj:skinObject("dropdown", {obj=child})
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
			if pCnt == 10 then
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
