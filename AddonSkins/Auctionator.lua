local _, aObj = ...
if not aObj:isAddonEnabled("Auctionator") then return end
local _G = _G

aObj.addonsToSkin.Auctionator = function(self) -- v  9.1.8.1

	self.RegisterMessage("Auctionator", "Auction_House_Show", function(_)
		local function skinBuyFrame(frame)
			frame.Inset.Bg:SetTexture(nil)
			aObj:removeInset(aObj:getChild(frame.Inset, 1))
			aObj:skinObject("slider", {obj=frame.SearchResultsListing.ScrollFrame.scrollBar, rpTex="background"})
			for _, child in _G.ipairs{frame.SearchResultsListing.HeaderContainer:GetChildren()} do
				aObj:keepRegions(child, {4, 5, 6}) -- N.B. regions 4 is text, 5 is highlight, 6 is arrow
				aObj:skinObject("frame", {obj=child, kfs=true, ofs=1, x1=-2, x2=2})
			end
			aObj:skinObject("slider", {obj=frame.HistoryResultsListing.ScrollFrame.scrollBar, rpTex="background"})
			for _, child in _G.ipairs{frame.HistoryResultsListing.HeaderContainer:GetChildren()} do
				aObj:keepRegions(child, {4, 5, 6}) -- N.B. regions 4 is text, 5 is highlight, 6 is arrow
				aObj:skinObject("frame", {obj=child, kfs=true, ofs=1, x1=-2, x2=2})
			end
			aObj:skinObject("frame", {obj=frame.BuyDialog, kfs=true, ofs=0})
			if aObj.modBtns then
				aObj:skinStdButton{obj=frame.HistoryButton}
				aObj:skinStdButton{obj=frame.RefreshButton}
				aObj:skinStdButton{obj=frame.BuyButton}
				aObj:skinStdButton{obj=frame.CancelButton}
				aObj:SecureHook(frame.HistoryButton, "Disable", function(bObj, _)
					aObj:clrBtnBdr(bObj)
				end)
				aObj:SecureHook(frame.HistoryButton, "Enable", function(bObj, _)
					aObj:clrBtnBdr(bObj)
				end)
				aObj:SecureHook(frame.RefreshButton, "Disable", function(bObj, _)
					aObj:clrBtnBdr(bObj)
				end)
				aObj:SecureHook(frame.RefreshButton, "Enable", function(bObj, _)
					aObj:clrBtnBdr(bObj)
				end)
				aObj:SecureHook(frame, "UpdateButtons", function(this)
					aObj:clrBtnBdr(this.BuyButton)
				end)
				aObj:SecureHook(frame.CancelButton, "SetEnabled", function(bObj)
					aObj:clrBtnBdr(bObj)
				end)
				aObj:skinStdButton{obj=frame.BuyDialog.Cancel}
				aObj:skinStdButton{obj=frame.BuyDialog.BuyStack}
			end
		end
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
		if _G.Auctionator.State.SplashScreenRef then
			aObj:removeNineSlice(_G.Auctionator.State.SplashScreenRef.Border)
			if aObj.isClsc then
				aObj:removeInset(aObj:getChild(_G.Auctionator.State.SplashScreenRef.Inset, 1))
			else
				_G.Auctionator.State.SplashScreenRef.Bg:SetTexture(nil)
			end
			aObj:skinObject("slider", {obj=_G.Auctionator.State.SplashScreenRef.ScrollFrame.ScrollBar})
			aObj:skinObject("frame", {obj=_G.Auctionator.State.SplashScreenRef, kfs=true, ri=true, rns=true, cb=true, ofs=0, y1=-2, x2=-1})
			if aObj.modChkBtns then
				aObj:skinCheckButton{obj=_G.Auctionator.State.SplashScreenRef.HideCheckbox.CheckBox}
			end
		end

		if _G.Auctionator.State.TabFrameRef then
			-- _G.Spew("", _G.Auctionator.State.TabFrameRef)
			aObj:skinObject("tabs", {obj=_G.Auctionator.State.TabFrameRef, tabs=_G.Auctionator.State.TabFrameRef.Tabs, track=aObj.isClsc and false})
			if aObj.isTT then
				for key, tab in _G.ipairs(_G.Auctionator.State.TabFrameRef.Tabs) do
					aObj:setInactiveTab(tab.sf)
					if not aObj.isClsc then
						-- add to table to display tab textures
						_G.AuctionHouseFrame.tabsForDisplayMode[tab.displayMode] = key + 3
					end
				end
				if aObj.isClsc then
					aObj:SecureHook("AuctionFrameTab_OnClick", function(tabButton, ...)
					    for _, tab in ipairs(_G.Auctionator.State.TabFrameRef.Tabs) do
							aObj:setInactiveTab(tab.sf)
							if tabButton == tab then
								aObj:setActiveTab(tab.sf)
							end
					    end
					end)
				end
			end
		end

		local aslFrame = _G.AuctionatorShoppingListFrame
		aObj:SecureHookScript(aslFrame, "OnShow", function(this)
			this:DisableDrawLayer("BACKGROUND")
			aObj:skinObject("editbox", {obj=this.OneItemSearchBox})
			aObj:skinObject("dropdown", {obj=this.ListDropdown})
			aObj:removeInset(this.ScrollListShoppingList.InsetFrame)
			aObj:skinObject("slider", {obj=this.ScrollListShoppingList.ScrollFrame.scrollBar, y1=-2, y2=2})
			aObj:skinObject("frame", {obj=this.ScrollListShoppingList, kfs=true, fb=true, x2=-1})
			aObj:removeInset(this.ScrollListRecents.InsetFrame)
			aObj:skinObject("slider", {obj=this.ScrollListRecents.ScrollFrame.scrollBar, y1=-2, y2=2})
			aObj:skinObject("frame", {obj=this.ScrollListRecents, kfs=true, fb=true, x2=-1})
			aObj:skinObject("slider", {obj=this.ResultsListing.ScrollFrame.scrollBar, y1=-2, y2=2})
			this.RecentsTabsContainer.Tabs = {this.RecentsTabsContainer.ListTab, this.RecentsTabsContainer.RecentsTab}
			aObj:skinObject("tabs", {obj=this.RecentsTabsContainer, tabs=this.RecentsTabsContainer.Tabs, lod=self.isTT and true, selectedTab=2 , offsets={x1=7, y1=-2, x2=-7, y2=-3}})
			aObj:removeInset(this.ShoppingResultsInset)
			if aObj.isClsc then
				aObj:removeInset(aObj:getChild(this.ShoppingResultsInset, 1))
			end
			for _, child in _G.ipairs{this.ResultsListing.HeaderContainer:GetChildren()} do
				aObj:keepRegions(child, {4, 5, 6}) -- N.B. regions 4 is text, 5 is highlight, 6 is arrow
				aObj:skinObject("frame", {obj=child, kfs=true, ofs=1, x1=-2, x2=2})
			end
			if aObj.modBtns then
				aObj:skinStdButton{obj=this.OneItemSearchButton}
				aObj:skinStdButton{obj=this.OneItemSearchExtendedButton}
				aObj:skinStdButton{obj=this.Export}
				aObj:skinStdButton{obj=this.Import}
				aObj:skinStdButton{obj=this.AddItem}
				aObj:skinStdButton{obj=this.SortItems}
				aObj:skinStdButton{obj=this.ManualSearch}
				aObj:skinStdButton{obj=this.ExportCSV}
				aObj:SecureHook(this, "ReceiveEvent", function(_, _)
					aObj:clrBtnBdr(this.Export)
					aObj:clrBtnBdr(this.Import)
					aObj:clrBtnBdr(this.AddItem)
					aObj:clrBtnBdr(this.SortItems)
					aObj:clrBtnBdr(this.ManualSearch)
					aObj:clrBtnBdr(this.ExportCSV)
				end)
			end

			aObj:Unhook(this, "OnShow")
		end)

		if aslFrame.itemDialog then
			aObj:SecureHookScript(aslFrame.itemDialog, "OnShow", function(this)
				aObj:removeNineSlice(this.Border)
				if aObj.isClsc then
					aObj:removeInset(aObj:getChild(this.Inset, 1))
				end
				aObj:skinObject("editbox", {obj=this.SearchContainer.SearchString})
				aObj:skinObject("dropdown", {obj=this.FilterKeySelector})
				for _, level in _G.pairs{"LevelRange", "ItemLevelRange", "PriceRange", "CraftedLevelRange"} do
					aObj:skinObject("editbox", {obj=this[level].MinBox})
					aObj:skinObject("editbox", {obj=this[level].MaxBox})
				end
				aObj:skinObject("frame", {obj=this, kfs=true, ri=true, rns=true})
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
		end

		if aslFrame.exportDialog then
			aObj:SecureHookScript(aslFrame.exportDialog, "OnShow", function(this)
				aObj:removeNineSlice(this.Border)
				if aObj.isClsc then
					aObj:removeInset(aObj:getChild(this.Inset, 1))
				end
				aObj:skinObject("slider", {obj=this.ScrollFrame.ScrollBar, rpTex="artwork"})
				aObj:skinObject("frame", {obj=this, kfs=true, ri=true, rns=true})
				if aObj.modBtns then
					 aObj:skinCloseButton{obj=this.CloseDialog}
					 aObj:skinStdButton{obj=this.SelectAll}
					 aObj:skinStdButton{obj=this.UnselectAll}
					 aObj:skinStdButton{obj=this.Export}
				end
				if aObj.modChkBtns then
					local function skinCBs()
						for _, frame in _G.ipairs(this.checkBoxPool) do
							aObj:skinCheckButton{obj=frame.CheckBox}
						end
					end
					aObj:SecureHook(this, "RefreshLists", function(_)
						skinCBs()
					end)
					skinCBs()
				end

				aObj:Unhook(this, "OnShow")
			end)
			aObj:SecureHookScript(aslFrame.exportDialog.copyTextDialog, "OnShow", function(this)
				aObj:removeNineSlice(this.Border)
				if aObj.isClsc then
					aObj:removeInset(aObj:getChild(this.Inset, 1))
				end
				aObj:skinObject("slider", {obj=this.ScrollFrame.ScrollBar})
				aObj:skinObject("frame", {obj=this, kfs=true, ri=true, rns=true})
				if aObj.modBtns then
					aObj:skinStdButton{obj=this.Close}
				end

				aObj:Unhook(this, "OnShow")
			end)
		end

		if aslFrame.importDialog then
			aObj:SecureHookScript(aslFrame.importDialog, "OnShow", function(this)
				aObj:removeNineSlice(this.Border)
				if aObj.isClsc then
					aObj:removeInset(aObj:getChild(this.Inset, 1))
				end
				aObj:skinObject("slider", {obj=this.ScrollFrame.ScrollBar, rpTex="artwork"})
				aObj:skinObject("frame", {obj=this, kfs=true, ri=true, rns=true})
				if aObj.modBtns then
					 aObj:skinCloseButton{obj=this.CloseDialog}
					 aObj:skinStdButton{obj=this.Import}
				end

				aObj:Unhook(this, "OnShow")
			end)
		end

		if aslFrame.exportCSVDialog then
			aObj:SecureHookScript(aslFrame.exportCSVDialog, "OnShow", function(this)
				aObj:removeNineSlice(this.Border)
				if aObj.isClsc then
					aObj:removeInset(aObj:getChild(this.Inset, 1))
				end
				aObj:skinObject("slider", {obj=this.ScrollFrame.ScrollBar})
				aObj:skinObject("frame", {obj=this, kfs=true, ri=true, rns=true})
				if aObj.modBtns then
					aObj:skinStdButton{obj=this.Close}
				end

				aObj:Unhook(this, "OnShow")
			end)
		end

		if aslFrame.itemHistoryDialog then
			aObj:SecureHookScript(aslFrame.itemHistoryDialog, "OnShow", function(this)
				aObj:removeNineSlice(this.Border)
				if aObj.isClsc then
					aObj:removeInset(aObj:getChild(this.Inset, 1))
				end
				for _, child in _G.ipairs{this.ResultsListing.HeaderContainer:GetChildren()} do
					aObj:keepRegions(child, {4, 5, 6}) -- N.B. regions 4 is text, 5 is highlight, 6 is arrow
					aObj:skinObject("frame", {obj=child, kfs=true, ofs=1, x1=-2, x2=2})
				end
				aObj:skinObject("slider", {obj=this.ResultsListing.ScrollFrame.scrollBar, rpTex="background"})
				aObj:skinObject("frame", {obj=this, ri=true, rns=true})
				if aObj.modBtns then
					aObj:skinStdButton{obj=this.Dock}
					aObj:skinStdButton{obj=this.Close}
				end

				aObj:Unhook(this, "OnShow")
			end)
		end

		aObj:SecureHookScript(_G.AuctionatorSellingFrame, "OnShow", function(this)
			local asi = this.AuctionatorSaleItem
			asi.Icon.EmptySlot:SetTexture(nil)
			aObj.modUIBtns:addButtonBorder{obj=asi.Icon, relTo=asi.Icon.Icon, clr="white"}
			aObj:SecureHook(asi.Icon, "SetItemInfo", function(bObj, _)
				aObj:clrButtonFromBorder(bObj)
			end)
			aObj:skinObject("slider", {obj=this.BagListing.ScrollFrame.ScrollBar, rpTex={"background", "artwork"}})
			for _, child in _G.pairs{this.BagListing.ScrollFrame.ItemListingFrame:GetChildren()} do
				aObj:keepRegions(child.SectionTitle, {3, 4, 5}) -- N.B. region 3 is highlight, 4 is selected, 5 is text
				aObj:skinObject("frame", {obj=child.SectionTitle, kfs=true, bd=5, ofs=0, x1=-2, x2=2})
			end
			if aObj.modBtns then
				aObj:skinStdButton{obj=asi.PostButton}
				aObj:SecureHook(asi, "UpdatePostButtonState", function(bObj)
					aObj:clrBtnBdr(bObj.PostButton)
				end)
			end
			if not aObj.isClsc then
				aObj:removeInset(this.BagInset)
				aObj:skinObject("editbox", {obj=asi.Quantity.InputBox, y2=4})
				aObj:skinObject("editbox", {obj=asi.Price.MoneyInput.GoldBox, ofs=-4, y2=8})
				aObj:skinObject("editbox", {obj=asi.Price.MoneyInput.SilverBox, ofs=-4, y2=8})
				aObj:skinObject("slider", {obj=this.CurrentItemListing.ScrollFrame.scrollBar, rpTex="artwork"})
				skinHdrs(this.CurrentItemListing)
				aObj:removeInset(this.CurrentItemInset)
				aObj:skinObject("slider", {obj=this.HistoricalPriceListing.ScrollFrame.scrollBar, rpTex="artwork"})
				skinHdrs(this.HistoricalPriceListing)
				aObj:skinObject("slider", {obj=this.PostingHistoryListing.ScrollFrame.scrollBar, rpTex="artwork"})
				skinHdrs(this.PostingHistoryListing)
				aObj:removeInset(this.HistoricalPriceInset)
				aObj:skinObject("tabs", {obj=this.HistoryTabsContainer, tabs=this.HistoryTabsContainer.Tabs, ignoreSize=true, lod=true, upwards=true})
				aObj:skinObject("frame", {obj=this.BagListing, fb=true, ofs=5, x2=6})
				aObj:skinObject("frame", {obj=this.CurrentItemListing, fb=true, ofs=-2, x1=-10, y2=-6})
				aObj:skinObject("frame", {obj=this.HistoricalPriceListing, fb=true, ofs=-2, x1=-10, y2=-6})
				aObj:skinObject("frame", {obj=this.PostingHistoryListing, fb=true, ofs=-2, x1=-10, y2=-6})
				if aObj.modBtns then
					aObj:skinStdButton{obj=asi.MaxButton}
					aObj:SecureHookScript(asi, "OnUpdate", function(bObj)
						aObj:clrBtnBdr(bObj.MaxButton)
					end)
					aObj:SecureHook(asi, "UpdateForNoItem", function(bObj)
						aObj:clrBtnBdr(bObj.MaxButton)
					end)
				end
				if aObj.modBtnBs then
					aObj:addButtonBorder{obj=aObj:getPenultimateChild(asi), ofs=-2, x1=1, clr="gold"} -- RefreshButton
				end
			else
				aObj:skinObject("editbox", {obj=asi.UnitPrice.MoneyInput.GoldBox, ofs=-4, y2=8})
				aObj:skinObject("editbox", {obj=asi.UnitPrice.MoneyInput.SilverBox, ofs=-4, y2=8})
				aObj:skinObject("editbox", {obj=asi.UnitPrice.MoneyInput.CopperBox, ofs=-4, y2=8})
				aObj:skinObject("editbox", {obj=asi.StackPrice.MoneyInput.GoldBox, ofs=-4, y2=8})
				aObj:skinObject("editbox", {obj=asi.StackPrice.MoneyInput.SilverBox, ofs=-4, y2=8})
				aObj:skinObject("editbox", {obj=asi.StackPrice.MoneyInput.CopperBox, ofs=-4, y2=8})
				aObj:skinObject("editbox", {obj=asi.Stacks.NumStacks, ofs=0})
				aObj:skinObject("editbox", {obj=asi.Stacks.StackSize, ofs=0})
				this.BagInset.Bg:SetTexture(nil)
				aObj:removeInset(aObj:getChild(this.BagInset, 1))
				skinBuyFrame(this.BuyFrame)
				if aObj.modBtns then
					aObj:skinStdButton{obj=asi.SkipButton}
					aObj:SecureHook(asi, "UpdateSkipButtonState", function(bObj)
						aObj:clrBtnBdr(bObj.SkipButton)
					end)
				end
			end

			aObj:Unhook(this, "OnShow")
		end)

		aObj:SecureHookScript(_G.AuctionatorCancellingFrame, "OnShow", function(this)
			aObj:skinObject("editbox", {obj=this.SearchFilter, si=true})
			this.ResultsListing.ScrollFrame.scrollBar.Background:SetTexture(nil)
			aObj:skinObject("slider", {obj=this.ResultsListing.ScrollFrame.scrollBar, rpTex="artwork"})
			for _, child in _G.ipairs{this.ResultsListing.HeaderContainer:GetChildren()} do
				aObj:keepRegions(child, {4, 5, 6}) -- N.B. regions 4 is text, 5 is highlight, 6 is arrow
				aObj:skinObject("frame", {obj=child, kfs=true, ofs=1, x1=-2, x2=2})
			end
			if not aObj.isClsc then
				local frame = aObj:getPenultimateChild(this) -- UndercutScan
				if aObj.modBtns then
					aObj:skinStdButton{obj=frame.StartScanButton}
					aObj:SecureHook(frame.StartScanButton, "SetEnabled", function(bObj)
						aObj:clrBtnBdr(bObj)
					end)
					aObj:skinStdButton{obj=frame.CancelNextButton}
					aObj:SecureHook(frame.CancelNextButton, "SetEnabled", function(bObj)
						aObj:clrBtnBdr(bObj)
					end)
				end
				if aObj.modBtnBs then
					aObj:addButtonBorder{obj=aObj:getLastChild(this), ofs=-2, x1=1, clr="gold"} -- RefreshButton
				end
				aObj:removeInset(this.HistoricalPriceInset)
			else
				this.HistoricalPriceInset.Bg:SetTexture(nil)
				aObj:removeInset(aObj:getChild(this.HistoricalPriceInset, 1))
				if aObj.modBtns then
					local ucsFrame = aObj:getLastChild(this)
					aObj:skinStdButton{obj=ucsFrame.CancelNextButton}
					aObj:skinStdButton{obj=ucsFrame.StartScanButton}
					aObj:SecureHook(ucsFrame.CancelNextButton, "SetEnabled", function(bObj)
						aObj:clrBtnBdr(bObj)
					end)
					aObj:SecureHook(ucsFrame.CancelNextButton, "Disable", function(bObj, _)
						aObj:clrBtnBdr(bObj)
					end)
					aObj:SecureHook(ucsFrame.CancelNextButton, "Enable", function(bObj, _)
						aObj:clrBtnBdr(bObj)
					end)
					aObj:SecureHook(ucsFrame.StartScanButton, "SetEnabled", function(bObj)
						aObj:clrBtnBdr(bObj)
					end)
				end
			end

			aObj:Unhook(this, "OnShow")
		end)

		aObj:SecureHookScript(_G.AuctionatorConfigFrame, "OnShow", function(this)
			if not aObj.isClsc then
				aObj:removeInset(this)
			else
				this.Bg:SetTexture(nil)
				aObj:removeInset(aObj:getChild(this, 1))
			end
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

		if _G.Auctionator.State.PageStatusFrameRef then
			aObj:SecureHookScript(_G.Auctionator.State.PageStatusFrameRef, "OnShow", function(this)
				aObj:skinObject("frame", {obj=this, kfs=true, rns=true})

				aObj:Unhook(this, "OnShow")
			end)
		end

		if _G.Auctionator.State.BuyFrameRef then
			aObj:SecureHookScript(_G.Auctionator.State.BuyFrameRef, "OnShow", function(this)
				skinBuyFrame(this)
				if aObj.modBtns then
					aObj:skinStdButton{obj=this.ReturnButton}
				end
				if aObj.modBtnBs then
					local btn = aObj:getLastChild(this)
					aObj:addButtonBorder{obj=btn, fType=ftype, relTo=btn.Icon, clr="grey"}
				end

				aObj:Unhook(this, "OnShow")
			end)
		end

		self.UnregisterMessage("Auctionator", "Auction_House_Show")
	end)

	local function skinKids(panel)
		for _, child in _G.ipairs{panel:GetChildren()} do
			if child:IsObjectType("EditBox") then
				if _G.Round(child:GetHeight()) == 33 then
					aObj:skinObject("editbox", {obj=child, ofs=-4, y2=8})
				else
					aObj:skinObject("editbox", {obj=child, ofs=-12, y1=aObj.isRtl and 4 or 0, y2=0})
				end
			elseif aObj:isDropDown(child) then
				aObj:skinObject("dropdown", {obj=child})
			elseif child:IsObjectType("CheckButton")
			and aObj.modChkBtns
			then
				aObj:skinCheckButton{obj=child}
			elseif child:IsObjectType("Button")
			and aObj.modBtns
			and not child:GetText():find("Max:")
			then
				aObj:skinStdButton{obj=child}
			elseif child:IsObjectType("Frame") then
				skinKids(child)
			end
		end
	end
	local pCnt = 0
	self.RegisterMessage("Auctionator_Config", "IOFPanel_Before_Skinning", function(_, panel)
		if panel.parent == "Auctionator"
		and not aObj.iofSkinnedPanels[panel]
		then
			aObj.iofSkinnedPanels[panel] = true
			pCnt = pCnt + 1
			skinKids(panel)
		end
		if pCnt == 11 then
			aObj.UnregisterMessage("Auctionator_Config", "IOFPanel_Before_Skinning")
		end
	end)

end
