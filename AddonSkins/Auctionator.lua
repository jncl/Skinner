local _, aObj = ...
if not aObj:isAddonEnabled("Auctionator") then return end
local _G = _G

aObj.addonsToSkin.Auctionator = function(self) -- v  9.2.27

	local function skinAuctionatorFrames()
		if not _G.AuctionatorSellingFrame then
			_G.C_Timer.After(0.5, function()
				skinAuctionatorFrames(self)
			end)
			return
		end

		aObj:SecureHookScript(_G.AuctionatorShoppingListFrame, "OnShow", function(this)
			this:DisableDrawLayer("BACKGROUND")
			self:skinObject("editbox", {obj=this.OneItemSearchBox})
			self:skinObject("dropdown", {obj=this.ListDropdown})
			self:removeInset(this.ScrollListShoppingList.InsetFrame)
			self:skinObject("slider", {obj=this.ScrollListShoppingList.ScrollFrame.scrollBar, y1=-2, y2=2})
			self:skinObject("frame", {obj=this.ScrollListShoppingList, kfs=true, fb=true, x2=-1})
			self:removeInset(this.ScrollListRecents.InsetFrame)
			self:skinObject("slider", {obj=this.ScrollListRecents.ScrollFrame.scrollBar, y1=-2, y2=2})
			self:skinObject("frame", {obj=this.ScrollListRecents, kfs=true, fb=true, x2=-1})
			self:skinObject("slider", {obj=this.ResultsListing.ScrollFrame.scrollBar, y1=-2, y2=2})
			this.RecentsTabsContainer.Tabs = {this.RecentsTabsContainer.ListTab, this.RecentsTabsContainer.RecentsTab}
			self:skinObject("tabs", {obj=this.RecentsTabsContainer, tabs=this.RecentsTabsContainer.Tabs, lod=self.isTT and true, selectedTab=2 , offsets={y1=-2, y2=-3}})
			self:removeInset(this.ShoppingResultsInset)
			if not self.isRtl then
				self:removeInset(self:getChild(this.ShoppingResultsInset, 1))
			end
			for _, child in _G.ipairs{this.ResultsListing.HeaderContainer:GetChildren()} do
				self:keepRegions(child, {4, 5, 6}) -- N.B. regions 4 is text, 5 is highlight, 6 is arrow
				self:skinObject("frame", {obj=child, kfs=true, ofs=1, x1=-2, x2=2})
			end
			if self.modBtns then
				self:skinStdButton{obj=this.OneItemSearchButton}
				self:skinStdButton{obj=this.OneItemSearchExtendedButton}
				self:skinStdButton{obj=this.Export}
				self:skinStdButton{obj=this.Import}
				self:skinStdButton{obj=this.AddItem}
				self:skinStdButton{obj=this.SortItems}
				self:skinStdButton{obj=this.ManualSearch}
				self:skinStdButton{obj=this.ExportCSV}
				self:SecureHook(this, "ReceiveEvent", function(_, _)
					self:clrBtnBdr(this.Export)
					self:clrBtnBdr(this.Import)
					self:clrBtnBdr(this.AddItem)
					self:clrBtnBdr(this.SortItems)
					self:clrBtnBdr(this.ManualSearch)
					self:clrBtnBdr(this.ExportCSV)
				end)
			end

			self:Unhook(this, "OnShow")
		end)

		local aslFrame = _G.AuctionatorShoppingListFrame
		if aslFrame.itemDialog then
			aObj:SecureHookScript(aslFrame.itemDialog, "OnShow", function(this)
				self:removeNineSlice(this.Border)
				if not self.isRtl then
					self:removeInset(self:getChild(this.Inset, 1))
				end
				self:skinObject("editbox", {obj=this.SearchContainer.SearchString})
				self:skinObject("dropdown", {obj=this.FilterKeySelector})
				for _, level in _G.pairs{"LevelRange", "ItemLevelRange", "PriceRange", "CraftedLevelRange"} do
					self:skinObject("editbox", {obj=this[level].MinBox})
					self:skinObject("editbox", {obj=this[level].MaxBox})
				end
				self:skinObject("dropdown", {obj=this.QualityContainer.DropDown.DropDown})
				self:skinObject("frame", {obj=this, kfs=true, ri=true, rns=true})
				if self.modBtns then
					self:skinStdButton{obj=this.Finished}
					self:skinStdButton{obj=this.Cancel}
					self:skinStdButton{obj=this.ResetAllButton}
				end
				if self.modChkBtns then
					self:skinCheckButton{obj=this.SearchContainer.IsExact}
				end

				self:Unhook(this, "OnShow")
			end)
		end
		if aslFrame.exportDialog then
			aObj:SecureHookScript(aslFrame.exportDialog, "OnShow", function(this)
				self:removeNineSlice(this.Border)
				if not self.isRtl then
					self:removeInset(self:getChild(this.Inset, 1))
				end
				self:skinObject("slider", {obj=this.ScrollFrame.ScrollBar, rpTex="artwork"})
				self:skinObject("frame", {obj=this, kfs=true, ri=true, rns=true})
				if self.modBtns then
					 self:skinCloseButton{obj=this.CloseDialog}
					 self:skinStdButton{obj=this.SelectAll}
					 self:skinStdButton{obj=this.UnselectAll}
					 self:skinStdButton{obj=this.Export}
				end
				if self.modChkBtns then
					local function skinCBs()
						for _, frame in _G.ipairs(this.checkBoxPool) do
							self:skinCheckButton{obj=frame.CheckBox}
						end
					end
					self:SecureHook(this, "RefreshLists", function(_)
						skinCBs()
					end)
					skinCBs()
				end

				self:Unhook(this, "OnShow")
			end)
			aObj:SecureHookScript(aslFrame.exportDialog.copyTextDialog, "OnShow", function(this)
				self:removeNineSlice(this.Border)
				if not self.isRtl then
					self:removeInset(self:getChild(this.Inset, 1))
				end
				self:skinObject("slider", {obj=this.ScrollFrame.ScrollBar})
				self:skinObject("frame", {obj=this, kfs=true, ri=true, rns=true})
				if self.modBtns then
					self:skinStdButton{obj=this.Close}
				end

				self:Unhook(this, "OnShow")
			end)
		end
		if aslFrame.importDialog then
			aObj:SecureHookScript(aslFrame.importDialog, "OnShow", function(this)
				self:removeNineSlice(this.Border)
				if not self.isRtl then
					self:removeInset(self:getChild(this.Inset, 1))
				end
				self:skinObject("slider", {obj=this.ScrollFrame.ScrollBar, rpTex="artwork"})
				self:skinObject("frame", {obj=this, kfs=true, ri=true, rns=true})
				if self.modBtns then
					 self:skinCloseButton{obj=this.CloseDialog}
					 self:skinStdButton{obj=this.Import}
				end

				self:Unhook(this, "OnShow")
			end)
		end
		if aslFrame.exportCSVDialog then
			aObj:SecureHookScript(aslFrame.exportCSVDialog, "OnShow", function(this)
				self:removeNineSlice(this.Border)
				if not self.isRtl then
					self:removeInset(self:getChild(this.Inset, 1))
				end
				self:skinObject("slider", {obj=this.ScrollFrame.ScrollBar})
				self:skinObject("frame", {obj=this, kfs=true, ri=true, rns=true})
				if self.modBtns then
					self:skinStdButton{obj=this.Close}
				end

				self:Unhook(this, "OnShow")
			end)
		end
		if aslFrame.itemHistoryDialog then
			aObj:SecureHookScript(aslFrame.itemHistoryDialog, "OnShow", function(this)
				self:removeNineSlice(this.Border)
				if not self.isRtl then
					self:removeInset(self:getChild(this.Inset, 1))
				end
				for _, child in _G.ipairs{this.ResultsListing.HeaderContainer:GetChildren()} do
					self:keepRegions(child, {4, 5, 6}) -- N.B. regions 4 is text, 5 is highlight, 6 is arrow
					self:skinObject("frame", {obj=child, kfs=true, ofs=1, x1=-2, x2=2})
				end
				self:skinObject("slider", {obj=this.ResultsListing.ScrollFrame.scrollBar, rpTex="background"})
				self:skinObject("frame", {obj=this, ri=true, rns=true})
				if self.modBtns then
					self:skinStdButton{obj=this.Dock}
					self:skinStdButton{obj=this.Close}
				end

				self:Unhook(this, "OnShow")
			end)
		end

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
		aObj:SecureHookScript(_G.AuctionatorSellingFrame, "OnShow", function(this)
			local asi = this.AuctionatorSaleItem
			asi.Icon.EmptySlot:SetTexture(nil)
			self.modUIBtns:addButtonBorder{obj=asi.Icon, relTo=asi.Icon.Icon, clr="white"}
			self:SecureHook(asi.Icon, "SetItemInfo", function(bObj, _)
				self:clrButtonFromBorder(bObj)
			end)
			self:skinObject("slider", {obj=this.BagListing.ScrollFrame.ScrollBar, rpTex={"background", "artwork"}})
			for _, child in _G.pairs{this.BagListing.ScrollFrame.ItemListingFrame:GetChildren()} do
				self:keepRegions(child.SectionTitle, {3, 4, 5}) -- N.B. region 3 is highlight, 4 is selected, 5 is text
				self:skinObject("frame", {obj=child.SectionTitle, kfs=true, bd=5, ofs=0, x1=-2, x2=2})
			end
			if self.modBtns then
				self:skinStdButton{obj=asi.PostButton}
				self:SecureHook(asi, "UpdatePostButtonState", function(bObj)
					self:clrBtnBdr(bObj.PostButton)
				end)
			end
			if self.isRtl then
				self:removeInset(this.BagInset)
				self:skinObject("editbox", {obj=asi.Quantity.InputBox, y2=4})
				self:skinObject("editbox", {obj=asi.Price.MoneyInput.GoldBox, ofs=-4, y2=8})
				self:skinObject("editbox", {obj=asi.Price.MoneyInput.SilverBox, ofs=-4, y2=8})
				self:skinObject("frame", {obj=this.BagListing, fb=true, ofs=5, x2=6, y2=-4})
				for _, list in _G.pairs{"CurrentPricesListing", "HistoricalPriceListing", "PostingHistoryListing"} do
					self:skinObject("slider", {obj=this[list].ScrollFrame.scrollBar, rpTex="artwork"})
					skinHdrs(this[list])
					self:skinObject("frame", {obj=this[list], fb=true, ofs=-2, x1=-10, x2=0, y2=-6})
				end
				self:removeInset(this.HistoricalPriceInset)
				self:skinObject("tabs", {obj=this.PricesTabsContainer, tabs=this.PricesTabsContainer.Tabs, ignoreSize=true, lod=true, upwards=true, offsets={y1=-1}})
				if self.modBtns then
					self:skinStdButton{obj=asi.MaxButton}
					self:SecureHookScript(asi, "OnUpdate", function(bObj)
						self:clrBtnBdr(bObj.MaxButton)
					end)
					self:SecureHook(asi, "UpdateForNoItem", function(bObj)
						self:clrBtnBdr(bObj.MaxButton)
					end)
				end
				if self.modBtnBs then
					self:addButtonBorder{obj=self:getPenultimateChild(asi), ofs=-2, x1=1, clr="gold"} -- RefreshButton
				end
			else
				self:skinObject("editbox", {obj=asi.UnitPrice.MoneyInput.GoldBox, ofs=-4, y2=8})
				self:skinObject("editbox", {obj=asi.UnitPrice.MoneyInput.SilverBox, ofs=-4, y2=8})
				self:skinObject("editbox", {obj=asi.UnitPrice.MoneyInput.CopperBox, ofs=-4, y2=8})
				self:skinObject("editbox", {obj=asi.StackPrice.MoneyInput.GoldBox, ofs=-4, y2=8})
				self:skinObject("editbox", {obj=asi.StackPrice.MoneyInput.SilverBox, ofs=-4, y2=8})
				self:skinObject("editbox", {obj=asi.StackPrice.MoneyInput.CopperBox, ofs=-4, y2=8})
				self:skinObject("editbox", {obj=asi.Stacks.NumStacks, ofs=0})
				self:skinObject("editbox", {obj=asi.Stacks.StackSize, ofs=0})
				this.BagInset.Bg:SetTexture(nil)
				self:removeInset(self:getChild(this.BagInset, 1))
				skinBuyFrame(this.BuyFrame)
				if self.modBtns then
					self:skinStdButton{obj=asi.SkipButton}
					self:SecureHook(asi, "UpdateSkipButtonState", function(bObj)
						self:clrBtnBdr(bObj.SkipButton)
					end)
				end
			end

			self:Unhook(this, "OnShow")
		end)

		aObj:SecureHookScript(_G.AuctionatorCancellingFrame, "OnShow", function(this)
			self:skinObject("editbox", {obj=this.SearchFilter, si=true})
			this.ResultsListing.ScrollFrame.scrollBar.Background:SetTexture(nil)
			self:skinObject("slider", {obj=this.ResultsListing.ScrollFrame.scrollBar, rpTex="artwork"})
			for _, child in _G.ipairs{this.ResultsListing.HeaderContainer:GetChildren()} do
				self:keepRegions(child, {4, 5, 6}) -- N.B. regions 4 is text, 5 is highlight, 6 is arrow
				self:skinObject("frame", {obj=child, kfs=true, ofs=1, x1=-2, x2=2})
			end
			if self.isRtl then
				local frame = self:getPenultimateChild(this) -- UndercutScan
				if self.modBtns then
					self:skinStdButton{obj=frame.StartScanButton}
					self:SecureHook(frame.StartScanButton, "SetEnabled", function(bObj)
						self:clrBtnBdr(bObj)
					end)
					self:skinStdButton{obj=frame.CancelNextButton}
					self:SecureHook(frame.CancelNextButton, "SetEnabled", function(bObj)
						self:clrBtnBdr(bObj)
					end)
				end
				if self.modBtnBs then
					self:addButtonBorder{obj=self:getLastChild(this), ofs=-2, x1=1, clr="gold"} -- RefreshButton
				end
				self:removeInset(this.HistoricalPriceInset)
			else
				this.HistoricalPriceInset.Bg:SetTexture(nil)
				self:removeInset(self:getChild(this.HistoricalPriceInset, 1))
				if self.modBtns then
					local ucsFrame = self:getLastChild(this)
					self:skinStdButton{obj=ucsFrame.CancelNextButton}
					self:skinStdButton{obj=ucsFrame.StartScanButton}
					self:SecureHook(ucsFrame.CancelNextButton, "SetEnabled", function(bObj)
						self:clrBtnBdr(bObj)
					end)
					self:SecureHook(ucsFrame.CancelNextButton, "Disable", function(bObj, _)
						self:clrBtnBdr(bObj)
					end)
					self:SecureHook(ucsFrame.CancelNextButton, "Enable", function(bObj, _)
						self:clrBtnBdr(bObj)
					end)
					self:SecureHook(ucsFrame.StartScanButton, "SetEnabled", function(bObj)
						self:clrBtnBdr(bObj)
					end)
				end
			end

			self:Unhook(this, "OnShow")
		end)

		aObj:SecureHookScript(_G.AuctionatorConfigFrame, "OnShow", function(this)
			if self.isRtl then
				self:removeInset(this)
			else
				this.Bg:SetTexture(nil)
				self:removeInset(self:getChild(this, 1))
			end
			this:DisableDrawLayer("BACKGROUND")
			self:skinObject("editbox", {obj=this.DiscordLink.InputBox})
			self:skinObject("editbox", {obj=this.BugReportLink.InputBox})
			-- self:skinObject("editbox", {obj=this.TechnicalRoadmap.InputBox})
			if self.modBtns then
				self:skinStdButton{obj=this.ScanButton}
				self:skinStdButton{obj=this.OptionsButton}
			end

			self:Unhook(this, "OnShow")
		end)

		if _G.Auctionator.State.SplashScreenRef then
			aObj:SecureHookScript(_G.Auctionator.State.SplashScreenRef, "OnShow", function(this)
				self:removeNineSlice(this.Border)
				if self.isRtl then
					this.Bg:SetTexture(nil)
				else
					self:removeInset(self:getChild(this.Inset, 1))
				end
				self:skinObject("slider", {obj=this.ScrollFrame.ScrollBar})
				self:skinObject("frame", {obj=this, kfs=true, ri=true, rns=true, cb=true, ofs=0, y1=-2, x2=-1})
				if self.modChkBtns then
					self:skinCheckButton{obj=this.HideCheckbox.CheckBox}
				end

				self:Unhook(this, "OnShow")
			end)
			aObj:checkShown(_G.Auctionator.State.SplashScreenRef)
		end

		if _G.Auctionator.State.TabFrameRef then
			aObj:SecureHookScript(_G.Auctionator.State.TabFrameRef, "OnShow", function(this)
				self:skinObject("tabs", {obj=this, tabs=this.Tabs, offsets={x1=8, y1=self.isTT and 2 or -3, x2=-8}, track=not self.isRtl and false})
				if self.isTT then
					for key, tab in _G.ipairs(this.Tabs) do
						self:setInactiveTab(tab.sf)
						if self.isRtl then
							-- add to table to display tab textures
							_G.AuctionHouseFrame.tabsForDisplayMode[tab.displayMode] = key + 3
						end
					end
					if not self.isRtl then
						self:SecureHook("AuctionFrameTab_OnClick", function(tabButton, _)
						    for _, tab in ipairs(this.Tabs) do
								self:setInactiveTab(tab.sf)
								if tabButton == tab then
									self:setActiveTab(tab.sf)
								end
						    end
						end)
					end
				end

				self:Unhook(this, "OnShow")
			end)
			aObj:checkShown(_G.Auctionator.State.TabFrameRef)
		end

		if _G.Auctionator.State.PageStatusFrameRef then
			aObj:SecureHookScript(_G.Auctionator.State.PageStatusFrameRef, "OnShow", function(this)
				self:skinObject("frame", {obj=this, kfs=true, rns=true})

				self:Unhook(this, "OnShow")
			end)
		end

		if _G.Auctionator.State.BuyFrameRef then
			aObj:SecureHookScript(_G.Auctionator.State.BuyFrameRef, "OnShow", function(this)
				skinBuyFrame(this)
				if self.modBtns then
					self:skinStdButton{obj=this.ReturnButton}
				end
				if self.modBtnBs then
					local btn = self:getLastChild(this)
					self:addButtonBorder{obj=btn, relTo=btn.Icon, clr="grey"}
				end

				self:Unhook(this, "OnShow")
			end)
		end

	end

	self.RegisterMessage("Auctionator", "Auction_House_Show", function(_)
		skinAuctionatorFrames()

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
		and not self.iofSkinnedPanels[panel]
		then
			self.iofSkinnedPanels[panel] = true
			pCnt = pCnt + 1
			skinKids(panel)
		end
		if pCnt == 10 then
			self.UnregisterMessage("Auctionator_Config", "IOFPanel_Before_Skinning")
		end
	end)

end
