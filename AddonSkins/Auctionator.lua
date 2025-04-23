local _, aObj = ...
if not aObj:isAddonEnabled("Auctionator") then return end
local _G = _G

aObj.addonsToSkin.Auctionator = function(self) -- v 272

	local function skinAuctionatorFrames()
		if not _G.AuctionatorSellingFrame then
			_G.C_Timer.After(0.5, function()
				skinAuctionatorFrames()
			end)
			return
		end

		if _G.Auctionator.State.SplashScreenRef then
			aObj:SecureHookScript(_G.Auctionator.State.SplashScreenRef, "OnShow", function(this)
				aObj:removeNineSlice(this.Border)
				if aObj.isMnln then
					this.Bg:SetTexture(nil)
				else
					aObj:removeInset(aObj:getChild(this.Inset, 1))
				end
				aObj:skinObject("scrollbar", {obj=this.ScrollBar})
				aObj:skinObject("frame", {obj=this, kfs=true, ri=true, rns=true, cb=true, ofs=0, x2=1})
				if aObj.modChkBtns then
					aObj:skinCheckButton{obj=this.HideCheckbox.CheckBox}
				end

				aObj:Unhook(this, "OnShow")
			end)
			aObj:checkShown(_G.Auctionator.State.SplashScreenRef)
		end

		if _G.Auctionator.State.TabFrameRef then
			aObj:SecureHookScript(_G.Auctionator.State.TabFrameRef, "OnShow", function(this)
				aObj:skinObject("tabs", {obj=this, tabs=this.Tabs, track=not aObj.isMnln and false})
				if aObj.isTT then
					for _, tab in _G.ipairs(this.Tabs) do
						aObj:setInactiveTab(tab.sf)
					end
					if not aObj.isMnln then
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
						    for _, tab in _G.ipairs(lObj.internalState.Tabs) do
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

		for _, name in _G.pairs{"PageStatus", "ThrottlingTimeout"} do
			if _G.Auctionator.State[name .. "FrameRef"] then
				aObj:SecureHookScript(_G.Auctionator.State[name .. "FrameRef"], "OnShow", function(this)
					aObj:skinObject("frame", {obj=this, kfs=true, rns=true, ofs=-4})

					aObj:Unhook(this, "OnShow")
				end)
			end
		end

		aObj:SecureHookScript(_G.AuctionatorShoppingFrame, "OnShow", function(this)
			this:DisableDrawLayer("BACKGROUND")
			aObj:skinObject("editbox", {obj=this.SearchOptions.SearchString})
			aObj:removeInset(this.ListsContainer.Inset)
			aObj:skinObject("scrollbar", {obj=this.ListsContainer.ScrollBar})
			aObj:removeInset(this.RecentsContainer.Inset)
			if not aObj.isMnln then
				aObj:getChild(this.RecentsContainer.Inset, 1):DisableDrawLayer("BORDER")
			end
			aObj:skinObject("scrollbar", {obj=this.RecentsContainer.ScrollBar})
			aObj:skinObject("frame", {obj=this.ListsContainer, kfs=true, fb=true, x1=0, x2=1})
			if not aObj.isMnln then
				aObj:getChild(this.ListsContainer.Inset, 1):DisableDrawLayer("BORDER")
			end
			aObj:removeInset(this.ShoppingResultsInset)
			aObj:skinObject("scrollbar", {obj=this.ResultsListing.ScrollArea.ScrollBar})
			aObj:skinObject("frame", {obj=this.RecentsContainer, kfs=true, fb=true, x2=1})
			aObj:skinObject("tabs", {obj=this.ContainerTabs, tabs=this.ContainerTabs.Tabs, lod=aObj.isTT and true, offsets={y1=-6, y2=-2}})
			if not aObj.isMnln then
				aObj:removeInset(aObj:getChild(this.ShoppingResultsInset, 1))
			else
				aObj:removeInset(this.ShoppingResultsInset)
			end
			for _, child in _G.ipairs{this.ResultsListing.HeaderContainer:GetChildren()} do
				aObj:keepRegions(child, {4, 5, 6}) -- N.B. regions 4 is text, 5 is highlight, 6 is arrow
				aObj:skinObject("frame", {obj=child, kfs=true, ofs=1, x1=-2, x2=2})
			end
			if aObj.modBtns then
				aObj:skinStdButton{obj=this.SearchOptions.SearchButton}
				aObj:skinStdButton{obj=this.SearchOptions.MoreButton}
				aObj:skinStdButton{obj=this.SearchOptions.AddToListButton, schk=true}
				aObj:skinStdButton{obj=this.NewListButton, schk=true}
				aObj:skinStdButton{obj=this.ImportButton, schk=true}
				aObj:skinStdButton{obj=this.ExportButton, schk=true}
				aObj:skinStdButton{obj=this.ExportCSV, schk=true}
			end

			aObj:Unhook(this, "OnShow")
		end)

		local asFrame = _G.AuctionatorShoppingFrame
		if asFrame.itemDialog then
			aObj:SecureHookScript(asFrame.itemDialog, "OnShow", function(this)
				aObj:skinObject("editbox", {obj=this.SearchContainer.SearchString})
				aObj:skinObject("ddbutton", {obj=this.FilterKeySelector.DropDown})
				for _, level in _G.pairs{"LevelRange", "ItemLevelRange", "PriceRange", "CraftedLevelRange"} do
					aObj:skinObject("editbox", {obj=this[level].MinBox})
					aObj:skinObject("editbox", {obj=this[level].MaxBox})
				end
				aObj:skinObject("editbox", {obj=this.PurchaseQuantity.InputBox, y1=4})
				aObj:skinObject("ddbutton", {obj=this.QualityContainer.DropDown.DropDown})
				aObj:skinObject("ddbutton", {obj=this.ExpansionContainer.DropDown.DropDown})
				aObj:skinObject("ddbutton", {obj=this.TierContainer.DropDown.DropDown})
				aObj:skinObject("frame", {obj=this, kfs=true, ri=true, rns=true, cb=true})
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
				if not aObj.isMnln then
					aObj:removeInset(aObj:getChild(this.Inset, 1))
				end
				aObj:skinObject("scrollbar", {obj=this.ScrollBar, rpTex="artwork"})
				aObj:skinObject("frame", {obj=this, kfs=true, ri=true, rns=true})
				if aObj.modBtns then
					 aObj:skinCloseButton{obj=this.CloseDialog}
					 aObj:skinStdButton{obj=this.Export}
					 aObj:skinStdButton{obj=this.SelectAll}
					 aObj:skinStdButton{obj=this.UnselectAll}
				end
				if aObj.modChkBtns then
					local function skinCBs()
						for frame in this.checkBoxPool:EnumerateActive() do
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
				if not aObj.isMnln then
					aObj:removeInset(aObj:getChild(this.Inset, 1))
				end
				aObj:skinObject("scrollbar", {obj=this.ScrollBar})
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
				if not aObj.isMnln then
					aObj:removeInset(aObj:getChild(this.Inset, 1))
				end
				aObj:skinObject("scrollbar", {obj=this.ScrollBar, rpTex="artwork"})
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
				if not aObj.isMnln then
					aObj:removeInset(aObj:getChild(this.Inset, 1))
				end
				aObj:skinObject("scrollbar", {obj=this.ScrollBar})
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
				if not aObj.isMnln then
					aObj:removeInset(aObj:getChild(this.Inset, 1))
				end
				for _, child in _G.ipairs{this.ResultsListing.HeaderContainer:GetChildren()} do
					aObj:keepRegions(child, {4, 5, 6}) -- N.B. regions 4 is text, 5 is highlight, 6 is arrow
					aObj:skinObject("frame", {obj=child, kfs=true, ofs=1, x1=-2, x2=2})
				end
				aObj:skinObject("scrollbar", {obj=this.ResultsListing.ScrollArea.ScrollBar, rpTex="background"})
				aObj:skinObject("frame", {obj=this, ri=true, rns=true})
				if aObj.modBtns then
					aObj:skinStdButton{obj=this.Dock}
					aObj:skinStdButton{obj=this.Close}
				end

				aObj:Unhook(this, "OnShow")
			end)
		end

		local function skinHeaders(fObj)
			for _, child in _G.ipairs{fObj.HeaderContainer:GetChildren()} do
				aObj:keepRegions(child, {4, 5, 6}) -- N.B. regions 4 is text, 5 is highlight, 6 is arrow
				aObj:skinObject("frame", {obj=child, kfs=true, ofs=1, x1=-2, x2=2})
			end
		end

		local function skinBuyFrame(frame)
			if aObj.modBtns then
				aObj:skinStdButton{obj=frame.HistoryButton, schk=true}
			end
			if not aObj.isMnln then
				frame.HistoryPrices.Inset.Bg:SetTexture(nil)
				aObj:removeInset(aObj:getChild(frame.HistoryPrices.Inset, 1))
				aObj:skinObject("scrollbar", {obj=frame.HistoryPrices.RealmHistoryResultsListing.ScrollArea.ScrollBar})
				skinHeaders(frame.HistoryPrices.RealmHistoryResultsListing)
				aObj:skinObject("scrollbar", {obj=frame.HistoryPrices.PostingHistoryResultsListing.ScrollArea.ScrollBar})
				skinHeaders(frame.HistoryPrices.PostingHistoryResultsListing)
				if aObj.modBtns then
					aObj:skinStdButton{obj=frame.HistoryPrices.PostingHistoryButton, schk=true}
					aObj:skinStdButton{obj=frame.HistoryPrices.RealmHistoryButton, schk=true}
				end
				if aObj.modChkBtns then
					aObj:skinCheckButton{obj=frame.CurrentPrices.BuyDialog.ChainBuy.CheckBox}
				end
				frame = frame.CurrentPrices
			else
				aObj:skinObject("scrollbar", {obj=frame.HistoryResultsListing.ScrollArea.ScrollBar})
				skinHeaders(frame.HistoryResultsListing)
			end
			frame.Inset.Bg:SetTexture(nil)
			aObj:removeInset(aObj:getChild(frame.Inset, 1))
			aObj:skinObject("scrollbar", {obj=frame.SearchResultsListing.ScrollArea.ScrollBar})
			skinHeaders(frame.SearchResultsListing)
			aObj:skinObject("frame", {obj=frame.BuyDialog, kfs=true, ofs=0})
			if aObj.modBtns then
				aObj:skinStdButton{obj=frame.RefreshButton, schk=true}
				aObj:skinStdButton{obj=frame.BuyButton, sechk=true}
				aObj:skinStdButton{obj=frame.CancelButton, sechk=true}
				aObj:skinStdButton{obj=frame.BuyDialog.Cancel}
				aObj:skinStdButton{obj=frame.BuyDialog.BuyStack, sechk=true}
			end
			aObj:SecureHookScript(frame.BuyDialog.WarningDialog, "OnShow", function(fObj)
				aObj:Debug("WarningDialog OnShow")
				aObj:skinObject("frame", {obj=fObj, kfs=true, ofs=0})
				if aObj.modBtns then
					aObj:skinStdButton{obj=fObj.Stop}
					aObj:skinStdButton{obj=fObj.BuyStack}
				end

				aObj:Unhook(fObj, "OnShow")
			end)
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
		local function skinView(fObj)
			for group in fObj.groupPool:EnumerateActive() do
				local hdr = group.GroupTitle
				if group.collapsable then
					-- SellingTab View
					aObj:removeRegions(hdr, {1, 2, 3})
					aObj:skinObject("frame", {obj=hdr, ofs=1, x1=-2})
				else
					-- CustomiseGroup View
					if group.isCustom then
						if group.Quantity.NumStacks then
							aObj:skinObject("editbox", {obj=group.Quantity.NumStacks, ofs=-2, x1=-5})
							aObj:skinObject("editbox", {obj=group.Quantity.StackSize, ofs=-2, x1=-5})
						else
							aObj:skinObject("editbox", {obj=group.Quantity.Quantity, ofs=-2})
						end
						if aObj.modBtns	then
							aObj:skinStdButton{obj=group.FocusButton, schk=true}
							aObj:skinStdButton{obj=group.RenameButton, schk=true}
							aObj:skinStdButton{obj=group.DeleteButton, schk=true}
							aObj:skinStdButton{obj=group.HideButton, schk=true}
							aObj:skinStdButton{obj=group.ShiftUpButton, schk=true}
							aObj:skinStdButton{obj=group.ShiftDownButton, schk=true}
						end
					end
				end
				if aObj.modBtnBs then
					for _, btn in _G.ipairs(group.buttons) do
						aObj:addButtonBorder{obj=btn, relTo=btn.Icon, reParent={btn.Text}}
						aObj:clrButtonFromBorder(btn)
					end
				end
			end
			fObj:UpdateGroupHeights()
		end
		aObj:SecureHookScript(_G.AuctionatorSellingFrame, "OnShow", function(this)
			aObj:skinObject("scrollbar", {obj=this.BagListing.View.ScrollBar})
			aObj:SecureHook(this.BagListing.View, "UpdateFromExisting", function(fObj)
				skinView(fObj)
			end)
			local asi = this.AuctionatorSaleItem
			asi.Icon.EmptySlot:SetTexture(nil)
			aObj.modUIBtns:addButtonBorder{obj=asi.Icon, relTo=asi.Icon.Icon, clr="white"}
			aObj:SecureHook(asi.Icon, "SetItemInfo", function(bObj, _)
				aObj:clrButtonFromBorder(bObj)
			end)
			if aObj.modBtns then
				aObj:skinStdButton{obj=asi.PostButton, schk=true, sechk=true}
			end
			if not aObj.isMnln then
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

		if _G.Auctionator.State.BuyItemFrameRef then
			aObj:SecureHookScript(_G.Auctionator.State.BuyItemFrameRef, "OnShow", function(this)
				skinHeaders(this.ResultsListing)
				aObj:skinObject("scrollbar", {obj=this.ResultsListing.ScrollArea.ScrollBar})
				aObj:removeInset(this.Inset)
				aObj:skinObject("frame", {obj=this.ResultsListing.ScrollArea, fb=true})
				if aObj.modBtns then
					aObj:skinStdButton{obj=this.BackButton}
				end
				if aObj.modBtnBs then
					aObj:addButtonBorder{obj=this.IconAndName, relTo=this.IconAndName.Icon, clr="grey"}
					this.IconAndName.sbb:SetBackdropBorderColor(this.IconAndName.QualityBorder:GetVertexColor())
					this.IconAndName.QualityBorder:SetAlpha(0)
					aObj:addButtonBorder{obj=aObj:getChild(this, 2), ofs=-2, x1=1, clr="gold"} -- RefreshButton
				end

				aObj:SecureHookScript(this.BuyDialog, "OnShow", function(fObj)
					aObj:skinObject("frame", {obj=fObj})
					if aObj.modBtns then
						aObj:skinStdButton{obj=fObj.Cancel}
						aObj:skinStdButton{obj=fObj.Buy}
					end
					if aObj.modBtnBs then
						aObj:addButtonBorder{obj=fObj.IconAndName, relTo=fObj.IconAndName.Icon, clr="grey"}
						fObj.IconAndName.sbb:SetBackdropBorderColor(fObj.IconAndName.QualityBorder:GetVertexColor())
						fObj.IconAndName.QualityBorder:SetAlpha(0)
					end

					aObj:Unhook(fObj, "OnShow")
				end)

				aObj:Unhook(this, "OnShow")
			end)
		end

		if _G.Auctionator.State.BuyCommodityFrameRef then
			aObj:SecureHookScript(_G.Auctionator.State.BuyCommodityFrameRef, "OnShow", function(this)
				aObj:skinObject("editbox", {obj=this.DetailsContainer.Quantity})
				skinHeaders(this.ResultsListing)
				aObj:skinObject("scrollbar", {obj=this.ResultsListing.ScrollArea.ScrollBar})
				aObj:removeInset(this.Inset)
				aObj:skinObject("frame", {obj=this.ResultsListing.ScrollArea, fb=true})
				if aObj.modBtns then
					aObj:skinStdButton{obj=this.BackButton}
					aObj:skinStdButton{obj=this.DetailsContainer.BuyButton, sechk=true}
				end
				if aObj.modBtnBs then
					aObj:addButtonBorder{obj=this.IconAndName, relTo=this.IconAndName.Icon, clr="grey"}
					this.IconAndName.sbb:SetBackdropBorderColor(this.IconAndName.QualityBorder:GetVertexColor())
					this.IconAndName.QualityBorder:SetAlpha(0)
					aObj:addButtonBorder{obj=aObj:getChild(this, 2), ofs=-2, x1=1, clr="gold"} -- RefreshButton
				end

				aObj:SecureHookScript(this.WidePriceRangeWarningDialog, "OnShow", function(fObj)
					aObj:skinObject("frame", {obj=fObj})
					if aObj.modBtns then
						aObj:skinStdButton{obj=fObj.CancelButton}
						aObj:skinStdButton{obj=fObj.ContinueButton}
					end

					aObj:Unhook(fObj, "OnShow")
				end)
				aObj:SecureHookScript(this.FinalConfirmationDialog, "OnShow", function(fObj)
					aObj:skinObject("frame", {obj=fObj})
					if aObj.modBtns then
						aObj:skinStdButton{obj=fObj.CancelButton}
						aObj:skinStdButton{obj=fObj.AcceptButton}
					end

					aObj:Unhook(fObj, "OnShow")
				end)
				aObj:SecureHookScript(this.QuantityCheckConfirmationDialog, "OnShow", function(fObj)
					aObj:skinObject("editbox", {obj=fObj.QuantityInput})
					aObj:skinObject("frame", {obj=fObj})
					if aObj.modBtns then
						aObj:skinStdButton{obj=fObj.CancelButton}
						aObj:skinStdButton{obj=fObj.AcceptButton}
					end

					aObj:Unhook(fObj, "OnShow")
				end)

				aObj:Unhook(this, "OnShow")
			end)
		end

		aObj:SecureHookScript(_G.AuctionatorCancellingFrame, "OnShow", function(this)
			aObj:skinObject("editbox", {obj=this.SearchFilter, si=true})
			self:skinObject("scrollbar", {obj=this.ResultsListing.ScrollArea.ScrollBar})
			skinHeaders(this.ResultsListing)
			if aObj.isMnln then
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
			if aObj.isMnln then
				aObj:removeInset(this)
			else
				this.Bg:SetTexture(nil)
				aObj:removeInset(aObj:getChild(this, 1))
			end
			this:DisableDrawLayer("BACKGROUND")
			aObj:skinObject("editbox", {obj=this.ContributeLink.InputBox})
			aObj:skinObject("editbox", {obj=this.DiscordLink.InputBox})
			aObj:skinObject("editbox", {obj=this.BugReportLink.InputBox})
			if aObj.modBtns then
				aObj:skinStdButton{obj=this.ScanButton}
				aObj:skinStdButton{obj=this.OptionsButton}
			end

			aObj:Unhook(this, "OnShow")
		end)

		if _G.Auctionator.Selling.ShowPopup then
			aObj:SecureHook(_G.Auctionator.Selling, "ShowPopup", function(this, _)
				aObj:removeNineSlice(_G.AuctionatorSellingPopupFrame.Border)
				aObj:skinObject("frame", {obj=_G.AuctionatorSellingPopupFrame, ofs=-4})

				aObj:Unhook(this, "ShowPopup")
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
					aObj:skinObject("editbox", {obj=child, ofs=-12, y1=aObj.isMnln and 4 or 0, y2=0})
				end
			elseif child.DropDown then
				aObj:skinObject("ddbutton", {obj=child.DropDown})
			elseif child.minThumbExtent then
				aObj:skinObject("scrollbar", {obj=child})
			elseif child:IsObjectType("CheckButton")
			and aObj.modChkBtns
			and child.GetPushedTexture
			and child:GetPushedTexture()
			then
				aObj:skinCheckButton{obj=child, ofs=-6}
			elseif child:IsObjectType("Button")
			and not child:IsObjectType("CheckButton")
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
		"ShoppingAlt",
	    "Selling",
	    "SellingAllItems",
	    "SellingShortcuts",
	    "Cancelling",
	    "Profile",
	    "Advanced",
	}
	if self.isMnln then
		self:add2Table(frameList, "Quantities")
	end
	for _, name in _G.pairs(frameList) do
		self:SecureHookScript(_G["AuctionatorConfig" .. name .. "Frame"], "OnShow", function(this)
			skinKids(this)

			self:Unhook(this, "OnShow")
		end)
	end

end
