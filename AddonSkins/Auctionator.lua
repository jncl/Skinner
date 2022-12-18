local _, aObj = ...
if not aObj:isAddonEnabled("Auctionator") then return end
local _G = _G

aObj.addonsToSkin.Auctionator = function(self) -- v 10.0.17/10.0.16/10.0.15

	local function skinAuctionatorFrames()
		if not _G.AuctionatorSellingFrame then
			_G.C_Timer.After(0.5, function()
				skinAuctionatorFrames()
			end)
			return
		end

		aObj:SecureHookScript(_G.AuctionatorShoppingFrame, "OnShow", function(this)
			this:DisableDrawLayer("BACKGROUND")
			aObj:skinObject("editbox", {obj=this.OneItemSearch.SearchBox})
			aObj:skinObject("dropdown", {obj=this.ListDropdown})
			aObj:removeInset(this.ScrollListShoppingList.Inset)
			aObj:skinObject("scrollbar", {obj=this.ScrollListShoppingList.ScrollBar})
			aObj:removeInset(this.ScrollListRecents.Inset)
			if not aObj.isRtl then
				aObj:getChild(this.ScrollListRecents.Inset, 1):DisableDrawLayer("BORDER")
			end
			aObj:skinObject("scrollbar", {obj=this.ScrollListRecents.ScrollBar})
			aObj:skinObject("frame", {obj=this.ScrollListShoppingList, kfs=true, fb=true, x2=1})
			if not aObj.isRtl then
				aObj:getChild(this.ScrollListShoppingList.Inset, 1):DisableDrawLayer("BORDER")
			end
			aObj:removeInset(this.ShoppingResultsInset)
			aObj:skinObject("scrollbar", {obj=this.ResultsListing.ScrollArea.ScrollBar})
			aObj:skinObject("frame", {obj=this.ScrollListRecents, kfs=true, fb=true, x2=1})
			this.RecentsTabsContainer.Tabs = {this.RecentsTabsContainer.ListTab, this.RecentsTabsContainer.RecentsTab}
			aObj:skinObject("tabs", {obj=this.RecentsTabsContainer, tabs=this.RecentsTabsContainer.Tabs, lod=aObj.isTT and true, selectedTab=2, offsets={y1=-6, y2=-2}})
			if not aObj.isRtl then
				aObj:removeInset(aObj:getChild(this.ShoppingResultsInset, 1))
			else
				aObj:removeInset(this.ShoppingResultsInset)
			end
			for _, child in _G.ipairs{this.ResultsListing.HeaderContainer:GetChildren()} do
				aObj:keepRegions(child, {4, 5, 6}) -- N.B. regions 4 is text, 5 is highlight, 6 is arrow
				aObj:skinObject("frame", {obj=child, kfs=true, ofs=1, x1=-2, x2=2})
			end
			if aObj.modBtns then
				aObj:skinStdButton{obj=this.OneItemSearch.SearchButton}
				aObj:skinStdButton{obj=this.OneItemSearch.ExtendedButton, schk=true}
				aObj:skinStdButton{obj=this.Export, schk=true}
				aObj:skinStdButton{obj=this.Import, schk=true}
				aObj:skinStdButton{obj=this.AddItem, schk=true}
				aObj:skinStdButton{obj=this.SortItems, schk=true}
				aObj:skinStdButton{obj=this.ManualSearch, schk=true}
				aObj:skinStdButton{obj=this.ExportCSV, schk=true}
			end

			aObj:Unhook(this, "OnShow")
		end)

		local asFrame = _G.AuctionatorShoppingFrame
		if asFrame.itemDialog then
			aObj:SecureHookScript(asFrame.itemDialog, "OnShow", function(this)
				aObj:removeNineSlice(this.Border)
				if not aObj.isRtl then
					aObj:removeInset(aObj:getChild(this.Inset, 1))
				end
				aObj:skinObject("editbox", {obj=this.SearchContainer.SearchString})
				aObj:skinObject("dropdown", {obj=this.FilterKeySelector})
				for _, level in _G.pairs{"LevelRange", "ItemLevelRange", "PriceRange", "CraftedLevelRange"} do
					aObj:skinObject("editbox", {obj=this[level].MinBox})
					aObj:skinObject("editbox", {obj=this[level].MaxBox})
				end
				aObj:skinObject("dropdown", {obj=this.QualityContainer.DropDown.DropDown})
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
		if asFrame.exportDialog then
			aObj:SecureHookScript(asFrame.exportDialog, "OnShow", function(this)
				aObj:removeNineSlice(this.Border)
				if not aObj.isRtl then
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
			aObj:SecureHookScript(asFrame.exportDialog.copyTextDialog, "OnShow", function(this)
				aObj:removeNineSlice(this.Border)
				if not aObj.isRtl then
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
		if asFrame.importDialog then
			aObj:SecureHookScript(asFrame.importDialog, "OnShow", function(this)
				aObj:removeNineSlice(this.Border)
				if not aObj.isRtl then
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
		if asFrame.exportCSVDialog then
			aObj:SecureHookScript(asFrame.exportCSVDialog, "OnShow", function(this)
				aObj:removeNineSlice(this.Border)
				if not aObj.isRtl then
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
		if asFrame.itemHistoryDialog then
			aObj:SecureHookScript(asFrame.itemHistoryDialog, "OnShow", function(this)
				aObj:removeNineSlice(this.Border)
				if not aObj.isRtl then
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

		local function skinBuyFrame(frame)
			if aObj.isRtl then
				frame.Inset.Bg:SetTexture(nil)
				aObj:removeInset(aObj:getChild(frame.Inset, 1))
				aObj:skinObject("scrollbar", {obj=frame.SearchResultsListing.ScrollArea.ScrollBar})
				for _, child in _G.ipairs{frame.SearchResultsListing.HeaderContainer:GetChildren()} do
					aObj:keepRegions(child, {4, 5, 6}) -- N.B. regions 4 is text, 5 is highlight, 6 is arrow
					aObj:skinObject("frame", {obj=child, kfs=true, ofs=1, x1=-2, x2=2})
				end
				aObj:skinObject("scrollbar", {obj=frame.HistoryResultsListing.ScrollArea.ScrollBar})
				for _, child in _G.ipairs{frame.HistoryResultsListing.HeaderContainer:GetChildren()} do
					aObj:keepRegions(child, {4, 5, 6}) -- N.B. regions 4 is text, 5 is highlight, 6 is arrow
					aObj:skinObject("frame", {obj=child, kfs=true, ofs=1, x1=-2, x2=2})
				end
				aObj:skinObject("frame", {obj=frame.BuyDialog, kfs=true, ofs=0})
				if aObj.modBtns then
					aObj:skinStdButton{obj=frame.HistoryButton, schk=true}
					aObj:skinStdButton{obj=frame.RefreshButton, schk=true}
					aObj:skinStdButton{obj=frame.BuyButton, sechk=true}
					aObj:skinStdButton{obj=frame.CancelButton, sechk=true}
					aObj:skinStdButton{obj=frame.BuyDialog.Cancel}
					aObj:skinStdButton{obj=frame.BuyDialog.BuyStack}
				end
			else
				frame.CurrentPrices.Inset.Bg:SetTexture(nil)
				aObj:removeInset(aObj:getChild(frame.CurrentPrices.Inset, 1))
				aObj:skinObject("scrollbar", {obj=frame.CurrentPrices.SearchResultsListing.ScrollArea.ScrollBar})
				for _, child in _G.ipairs{frame.CurrentPrices.SearchResultsListing.HeaderContainer:GetChildren()} do
					aObj:keepRegions(child, {4, 5, 6}) -- N.B. regions 4 is text, 5 is highlight, 6 is arrow
					aObj:skinObject("frame", {obj=child, kfs=true, ofs=1, x1=-2, x2=2})
				end
				aObj:skinObject("frame", {obj=frame.CurrentPrices.BuyDialog, kfs=true, ofs=0})
				frame.HistoryPrices.Inset.Bg:SetTexture(nil)
				aObj:removeInset(aObj:getChild(frame.HistoryPrices.Inset, 1))
				aObj:skinObject("scrollbar", {obj=frame.HistoryPrices.RealmHistoryResultsListing.ScrollArea.ScrollBar})
				for _, child in _G.ipairs{frame.HistoryPrices.RealmHistoryResultsListing.HeaderContainer:GetChildren()} do
					aObj:keepRegions(child, {4, 5, 6}) -- N.B. regions 4 is text, 5 is highlight, 6 is arrow
					aObj:skinObject("frame", {obj=child, kfs=true, ofs=1, x1=-2, x2=2})
				end
				aObj:skinObject("scrollbar", {obj=frame.HistoryPrices.PostingHistoryResultsListing.ScrollArea.ScrollBar})
				for _, child in _G.ipairs{frame.HistoryPrices.PostingHistoryResultsListing.HeaderContainer:GetChildren()} do
					aObj:keepRegions(child, {4, 5, 6}) -- N.B. regions 4 is text, 5 is highlight, 6 is arrow
					aObj:skinObject("frame", {obj=child, kfs=true, ofs=1, x1=-2, x2=2})
				end
			end
			if aObj.modBtns then
				aObj:skinStdButton{obj=frame.HistoryButton, schk=true}
				aObj:skinStdButton{obj=frame.CurrentPrices.CancelButton, sechk=true}
				aObj:skinStdButton{obj=frame.CurrentPrices.BuyButton, schk=true, sechk=true}
				aObj:skinStdButton{obj=frame.CurrentPrices.RefreshButton, schk=true}
				aObj:skinStdButton{obj=frame.CurrentPrices.BuyDialog.Cancel}
				aObj:skinStdButton{obj=frame.CurrentPrices.BuyDialog.BuyStack}
				aObj:skinStdButton{obj=frame.HistoryPrices.PostingHistoryButton, schk=true}
				aObj:skinStdButton{obj=frame.HistoryPrices.RealmHistoryButton, schk=true}
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
		aObj:SecureHookScript(_G.AuctionatorSellingFrame, "OnShow", function(this)
			local asi = this.AuctionatorSaleItem
			asi.Icon.EmptySlot:SetTexture(nil)
			aObj.modUIBtns:addButtonBorder{obj=asi.Icon, relTo=asi.Icon.Icon, clr="white"}
			aObj:SecureHook(asi.Icon, "SetItemInfo", function(bObj, _)
				aObj:clrButtonFromBorder(bObj)
			end)
			aObj:skinObject("scrollbar", {obj=this.BagListing.ScrollBar, fType=ftype})
			for _, child in _G.pairs{this.BagListing.ScrollBox.ItemListingFrame:GetChildren()} do
				aObj:keepRegions(child.SectionTitle, {3, 4, 5}) -- N.B. region 3 is highlight, 4 is selected, 5 is text
				aObj:skinObject("frame", {obj=child.SectionTitle, kfs=true, bd=5, ofs=0, x1=-2, x2=2})
			end
			if aObj.modBtns then
				aObj:skinStdButton{obj=asi.PostButton, schk=true}
			end
			if not aObj.isRtl then
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
					aObj:skinStdButton{obj=asi.SkipButton, sechk=true}
				end
			else
				aObj:removeInset(this.BagInset)
				aObj:skinObject("editbox", {obj=asi.Quantity.InputBox, y2=4})
				aObj:skinObject("editbox", {obj=asi.Price.MoneyInput.GoldBox, ofs=-4, y2=8})
				aObj:skinObject("editbox", {obj=asi.Price.MoneyInput.SilverBox, ofs=-4, y2=8})
				aObj:skinObject("frame", {obj=this.BagListing, fb=true, ofs=5, x2=6, y2=-4})
				for _, list in _G.pairs{"CurrentPricesListing", "HistoricalPriceListing", "PostingHistoryListing"} do
					self:skinObject("scrollbar", {obj=this[list].ScrollArea.ScrollBar})
					skinHdrs(this[list])
					aObj:skinObject("frame", {obj=this[list], fb=true, ofs=-2, x1=-10, x2=0, y2=-6})
				end
				aObj:removeInset(this.HistoricalPriceInset)
				aObj:skinObject("tabs", {obj=this.PricesTabsContainer, tabs=this.PricesTabsContainer.Tabs, ignoreSize=true, lod=true, upwards=true, offsets={y1=-3, y2=2}})
				if aObj.modBtns then
					aObj:skinStdButton{obj=asi.MaxButton, schk=true, sechk=true}
					aObj:skinStdButton{obj=aObj:getPenultimateChild(asi), ofs=-2, clr="gold"} -- RefreshButton
				end
			end

			aObj:Unhook(this, "OnShow")
		end)

		aObj:SecureHookScript(_G.AuctionatorCancellingFrame, "OnShow", function(this)
			aObj:skinObject("editbox", {obj=this.SearchFilter, si=true})
			self:skinObject("scrollbar", {obj=this.ResultsListing.ScrollArea.ScrollBar})
			for _, child in _G.ipairs{this.ResultsListing.HeaderContainer:GetChildren()} do
				aObj:keepRegions(child, {4, 5, 6}) -- N.B. regions 4 is text, 5 is highlight, 6 is arrow
				aObj:skinObject("frame", {obj=child, kfs=true, ofs=1, x1=-2, x2=2})
			end
			if aObj.isRtl then
				local frame = aObj:getPenultimateChild(this) -- UndercutScan
				if aObj.modBtns then
					aObj:skinStdButton{obj=frame.StartScanButton, sechk=true}
					aObj:skinStdButton{obj=frame.CancelNextButton, sechk=true}
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
					aObj:skinStdButton{obj=ucsFrame.CancelNextButton, schk=true, sechk=true}
					aObj:skinStdButton{obj=ucsFrame.StartScanButton, sechk=true}
				end
			end

			aObj:Unhook(this, "OnShow")
		end)

		aObj:SecureHookScript(_G.AuctionatorConfigFrame, "OnShow", function(this)
			if aObj.isRtl then
				aObj:removeInset(this)
			else
				this.Bg:SetTexture(nil)
				aObj:removeInset(aObj:getChild(this, 1))
			end
			this:DisableDrawLayer("BACKGROUND")
			aObj:skinObject("editbox", {obj=this.DiscordLink.InputBox})
			aObj:skinObject("editbox", {obj=this.BugReportLink.InputBox})
			-- aObj:skinObject("editbox", {obj=this.TechnicalRoadmap.InputBox})
			if aObj.modBtns then
				aObj:skinStdButton{obj=this.ScanButton}
				aObj:skinStdButton{obj=this.OptionsButton}
			end

			aObj:Unhook(this, "OnShow")
		end)

		if _G.Auctionator.State.SplashScreenRef then
			aObj:SecureHookScript(_G.Auctionator.State.SplashScreenRef, "OnShow", function(this)
				aObj:removeNineSlice(this.Border)
				if aObj.isRtl then
					this.Bg:SetTexture(nil)
				else
					aObj:removeInset(aObj:getChild(this.Inset, 1))
				end
				aObj:skinObject("slider", {obj=this.ScrollFrame.ScrollBar})
				aObj:skinObject("frame", {obj=this, kfs=true, ri=true, rns=true, cb=true, ofs=0, y1=-2, x2=-1})
				if aObj.modChkBtns then
					aObj:skinCheckButton{obj=this.HideCheckbox.CheckBox}
				end

				aObj:Unhook(this, "OnShow")
			end)
			aObj:checkShown(_G.Auctionator.State.SplashScreenRef)
		end

		if _G.Auctionator.State.TabFrameRef then
			aObj:SecureHookScript(_G.Auctionator.State.TabFrameRef, "OnShow", function(this)
				aObj:skinObject("tabs", {obj=this, tabs=this.Tabs, track=not aObj.isRtl and false})
				if aObj.isTT then
					for key, tab in _G.ipairs(this.Tabs) do
						aObj:setInactiveTab(tab.sf)
					end
					if not aObj.isRtl then
						aObj:SecureHook("AuctionFrameTab_OnClick", function(tabButton, _)
						    for _, tab in _G.ipairs(this.Tabs) do
								aObj:setInactiveTab(tab.sf)
								if tabButton == tab then
									aObj:setActiveTab(tab.sf)
								end
						    end
						end)
					else
						aObj:SecureHook(_G.LibStub:GetLibrary("LibAHTab-1-0", true), "SetSelected", function(lObj, tabID)
						    for _, tab in ipairs(lObj.internalState.Tabs) do
								aObj:setInactiveTab(tab.sf)
								if lObj:GetButton(tabID) == tab then
									aObj:setActiveTab(tab.sf)
								end
						    end
						end)
					end
				end

				aObj:Unhook(this, "OnShow")
			end)
			aObj:checkShown(_G.Auctionator.State.TabFrameRef)
		end

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
					aObj:addButtonBorder{obj=btn, relTo=btn.Icon, clr="grey"}
				end

				aObj:Unhook(this, "OnShow")
			end)
		end

	end

	self.RegisterCallback("Auctionator", "Auction_House_Show", function(_)
		skinAuctionatorFrames()
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
			then
				aObj:skinStdButton{obj=child}
			elseif child:IsObjectType("Frame") then
				skinKids(child)
			end
		end
	end
	local frameList = {
	    "BasicOptions",
	    "Tooltips",
	    "Selling",
	    "SellingShortcuts",
	    "SellingAllItems",
	    "Cancelling",
	    "Profile",
	    "Advanced",
	}
	if self.isRtl then
		self:add2Table(frameList, "Shopping")
		self:add2Table(frameList, "Quantities")
	else
		self:add2Table(frameList, "ShoppingAlt")
	end
	for _, name in _G.pairs(frameList) do
		self:SecureHookScript(_G["AuctionatorConfig" .. name .. "Frame"], "OnShow", function(this)
			skinKids(this)

			self:Unhook(this, "OnShow")
		end)
	end

end
