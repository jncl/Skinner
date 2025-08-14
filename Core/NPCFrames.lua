local _, aObj = ...

local _G = _G

local ftype = "n"

if not aObj.isClscERA then
	aObj.blizzLoDFrames[ftype].AuctionHouseUI = function(self)
		if not self.prdb.AuctionHouseUI or self.initialized.AuctionHouseUI then return end

		if not _G.AuctionHouseFrame then
			_G.C_Timer.After(0.1, function()
				self.blizzLoDFrames[ftype].AuctionHouseUI(self)
			end)
			return
		end

		self.initialized.AuctionHouseUI = true

		self:SecureHookScript(_G.AuctionHouseFrame, "OnShow", function(this)
			self:removeInset(this.MoneyFrameInset) -- MerchantMoneyInset
			self:removeNineSlice(this.MoneyFrameBorder)
			self:skinObject("tabs", {obj=this, tabs=this.Tabs, fType=ftype, lod=self.isTT and true, track=false})
			if self.isTT then
				self:SecureHook(this, "SetDisplayMode", function(fObj, displayMode)
					for i, tab in _G.ipairs(fObj.Tabs) do
						self:setInactiveTab(tab.sf)
						if i == fObj.tabsForDisplayMode[displayMode] then
							self:setActiveTab(tab.sf)
						end
					end
					if _G.C_AddOns.IsAddOnLoaded("Auctionator") then
						for _, tab in _G.ipairs(_G.AuctionatorAHTabsContainer.Tabs) do
							self:setInactiveTab(tab.sf)
						end
					end
				end)
			end
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, rns=true, cb=true, x2=3, y2=0})

			self:SecureHookScript(this.SearchBar, "OnShow", function(fObj)
				self:skinObject("editbox", {obj=fObj.SearchBox, fType=ftype, si=true})
				self:skinObject("ddbutton", {obj=fObj.FilterButton, fType=ftype, filter=true, filtercb="ClearFiltersButton"})
				if self.modBtns then
					self:skinStdButton{obj=fObj.FavoritesSearchButton, fType=ftype, ofs=-2}
					self:skinStdButton{obj=fObj.SearchButton, fType=ftype}
				end

				self:Unhook(fObj, "OnShow")
			end)

			self:SecureHookScript(this.CategoriesList, "OnShow", function(fObj)
				fObj:DisableDrawLayer("BACKGROUND")
				self:removeNineSlice(fObj.NineSlice)
				self:skinObject("scrollbar", {obj=fObj.ScrollBar, fType=ftype})
				local function skinCategories(...)
					local _, element, elementData, new
					if _G.select("#", ...) == 2 then
						element, elementData = ...
					elseif _G.select("#", ...) == 3 then
						element, elementData, new = ...
					else
						_, element, elementData, new = ...
					end
					if new ~= false then
						aObj:keepRegions(element, {3, 4, 5}) -- N.B. region 3 is highlight, 4 is selected, 5 is text
						aObj.modUIBtns:skinStdButton{obj=element, fType=ftype, ignoreHLTex=true}
					end
					element.sb:Show()
					element.sb:ClearAllPoints()
					element.sb:SetPoint("BOTTOMRIGHT", element, "BOTTOMRIGHT", -4, -1)
					if elementData.type == "category" then
						element.sb:SetPoint("TOPLEFT", element, "TOPLEFT", -1, 1)
					elseif elementData.type == "subCategory" then
						element.sb:SetPoint("TOPLEFT", element, "TOPLEFT", 10, 1)
					elseif elementData.type == "subSubCategory" then
						element.sb:Hide()
					end
				end
				_G.ScrollUtil.AddAcquiredFrameCallback(fObj.ScrollBox, skinCategories, aObj, true)

				self:Unhook(fObj, "OnShow")
			end)

			local function skinItemList(frame)
				aObj:removeNineSlice(frame.NineSlice)
				frame.Background:SetTexture(nil)
				local function skinHeaders(fObj)
					if fObj.tableBuilder then
						for hdr in fObj.tableBuilder.headerPoolCollection:EnumerateActive() do
							aObj:removeRegions(hdr, {1, 2, 3})
							aObj:skinObject("frame", {obj=hdr, fType=ftype, ofs=1})
						end
					end
				end
				skinHeaders(frame)
				aObj:SecureHook(frame, "RefreshScrollFrame", function(fObj)
					skinHeaders(fObj)
				end)
				aObj:skinObject("scrollbar", {obj=frame.ScrollBar, fType=ftype})
				if aObj.modBtns then
					aObj:skinStdButton{obj=frame.RefreshFrame.RefreshButton, fType=ftype, ofs=-2, clr="gold"}
				end
			end
			local function skinBidAmt(frame)
				aObj:skinObject("editbox", {obj=frame.gold, fType=ftype, ofs=0})
				aObj:skinObject("editbox", {obj=frame.silver, fType=ftype, ofs=0})
				aObj:skinObject("editbox", {obj=frame.copper, fType=ftype, ofs=0})
				if self.isClscERA then
					frame.silver:SetWidth(38)
					frame.copper:SetWidth(38)
				end
				if not self.isMnln then
					aObj:moveObject{obj=frame.silver.texture, x=10}
					aObj:moveObject{obj=frame.copper.texture, x=10}
				end
			end
			self:SecureHookScript(this.BrowseResultsFrame, "OnShow", function(fObj)
				skinItemList(fObj.ItemList)

				self:Unhook(fObj, "OnShow")
			end)

			self:SecureHookScript(this.WoWTokenResults, "OnShow", function(fObj)
				fObj.Background:SetTexture(nil)
				self:removeNineSlice(fObj.NineSlice)
				self:SecureHookScript(fObj.GameTimeTutorial, "OnShow", function(frame)
					self:removeInset(frame.Inset)
					frame.LeftDisplay.Label:SetTextColor(self.HT:GetRGB())
					frame.LeftDisplay.Tutorial1:SetTextColor(self.BT:GetRGB())
					frame.RightDisplay.Label:SetTextColor(self.HT:GetRGB())
					frame.RightDisplay.Tutorial1:SetTextColor(self.BT:GetRGB())
					self:skinObject("frame", {obj=frame, fType=ftype, kfs=true, cb=true, y2=220})
					if self.modBtns then
						self:skinStdButton{obj=frame.RightDisplay.StoreButton, fType=ftype, x1=14, y1=2, x2=-14, y2=2, clr="gold"}
					end

					self:Unhook(frame, "OnShow")
				end)
				self:removeRegions(fObj.TokenDisplay, {3}) -- background texture
				self:skinObject("scrollbar", {obj=fObj.DummyScrollBar, fType=ftype})
				if self.modBtns then
					self:skinStdButton{obj=fObj.Buyout, fType=ftype, sechk=true}
				end

				self:Unhook(fObj, "OnShow")
			end)

			self:SecureHookScript(this.CommoditiesBuyFrame, "OnShow", function(fObj)
				self:removeNineSlice(fObj.BuyDisplay.NineSlice)
				fObj.BuyDisplay.Background:SetTexture(nil)
				self:removeRegions(fObj.BuyDisplay.ItemDisplay, {3})
				self:skinObject("editbox", {obj=fObj.BuyDisplay.QuantityInput.InputBox, fType=ftype, ofs=-2})
				self:adjHeight{obj=fObj.BuyDisplay.QuantityInput.InputBox, adj=-3}
				skinItemList(fObj.ItemList)
				if self.modBtns then
					self:skinStdButton{obj=fObj.BackButton, fType=ftype}
					self:skinStdButton{obj=fObj.BuyDisplay.QuantityInput.MaxButton, fType=ftype}
					self:skinStdButton{obj=fObj.BuyDisplay.BuyButton, fType=ftype, sechk=true}
				end

				self:Unhook(fObj, "OnShow")
			end)

			self:SecureHookScript(this.ItemBuyFrame, "OnShow", function(fObj)
				self:removeNineSlice(fObj.ItemDisplay.NineSlice)
				self:removeRegions(fObj.ItemDisplay, {1})
				if self.isClsc then
					fObj.ItemDisplay.ItemButton.EmptyBackground:SetAlpha(0) -- N.B. Texture changed in code
				end
				skinBidAmt(fObj.BidFrame.BidAmount)
				skinItemList(fObj.ItemList)
				if self.modBtns then
					self:skinStdButton{obj=fObj.BackButton, fType=ftype}
					self:skinStdButton{obj=fObj.BuyoutFrame.BuyoutButton, fType=ftype, sechk=true}
					self:skinStdButton{obj=fObj.BidFrame.BidButton, fType=ftype, sechk=true}
				end
				if self.modBtnBs then
					self:addButtonBorder{obj=fObj.ItemDisplay.ItemButton, fType=ftype, ibt=true, ofs=0}
					local itemKeyInfo =_G.C_AuctionHouse.GetItemKeyInfo(fObj.ItemDisplay.itemKey)
					self:setBtnClr(fObj.ItemDisplay.ItemButton, itemKeyInfo.quality)
				end

				self:Unhook(fObj, "OnShow")
			end)

			local function skinPriceInp(frame)
				aObj:skinObject("editbox", {obj=frame.CopperBox, fType=ftype, ofs=0, y1=-4, y2=4})
				aObj:skinObject("editbox", {obj=frame.SilverBox, fType=ftype, ofs=0, y1=-4, y2=4})
				aObj:skinObject("editbox", {obj=frame.GoldBox, fType=ftype, ofs=0, y1=-4, y2=4})
			end
			local function skinSellFrame(frame)
				aObj:removeNineSlice(frame.NineSlice)
				frame.Background:SetTexture(nil)
				aObj:keepFontStrings(frame)
				aObj:removeNineSlice(frame.ItemDisplay.NineSlice)
				aObj:removeRegions(frame.ItemDisplay, {3})
				aObj:skinObject("editbox", {obj=frame.QuantityInput.InputBox, fType=ftype, ofs=0, y1=-4, y2=4})
				skinPriceInp(frame.PriceInput.MoneyInputFrame)
				aObj:skinObject("ddbutton", {obj=frame.Duration.Dropdown, fType=ftype})
				if aObj.modBtns then
					aObj:skinStdButton{obj=frame.QuantityInput.MaxButton, fType=ftype, sechk=true}
					aObj:skinStdButton{obj=frame.PostButton, fType=ftype, sechk=true}
				end
				if aObj.modBtnBs then
					aObj:addButtonBorder{obj=frame.ItemDisplay.ItemButton, ftype=ftype, gibt=true, ofs=0}
				end
			end
			self:SecureHookScript(this.ItemSellFrame, "OnShow", function(fObj)
				skinSellFrame(fObj)
				if self.modChkBtns then
					self:skinCheckButton{obj=fObj.BuyoutModeCheckButton}
				end
				skinPriceInp(fObj.SecondaryPriceInput.MoneyInputFrame)

				self:Unhook(fObj, "OnShow")
			end)

			self:SecureHookScript(this.ItemSellList, "OnShow", function(fObj)
				skinItemList(fObj)

				self:Unhook(fObj, "OnShow")
			end)

			self:SecureHookScript(this.CommoditiesSellFrame, "OnShow", function(fObj)
				skinSellFrame(fObj)

				self:Unhook(fObj, "OnShow")
			end)

			self:SecureHookScript(this.CommoditiesSellList, "OnShow", function(fObj)
				skinItemList(fObj)

				self:Unhook(fObj, "OnShow")
			end)

			self:SecureHookScript(this.WoWTokenSellFrame, "OnShow", function(fObj)
				self:removeNineSlice(fObj.ItemDisplay.NineSlice)
				self:removeRegions(fObj.ItemDisplay, {3})
				self:removeNineSlice(fObj.DummyItemList.NineSlice)
				fObj.DummyItemList.Background:SetTexture(nil)
				fObj.DummyItemList.DummyScrollBar:DisableDrawLayer("BACKGROUND")
				fObj.DummyItemList.DummyScrollBar.Background:DisableDrawLayer("ARTWORK")
				if self.modBtns then
					self:skinStdButton{obj=fObj.PostButton, fType=ftype, sechk=true}
				end

				self:Unhook(fObj, "OnShow")
			end)

			self:SecureHookScript(this.AuctionsFrame, "OnShow", function(fObj)
				-- Top Tabs
				self:skinObject("tabs", {obj=fObj, tabs=fObj.Tabs, fType=ftype, lod=self.isTT and true, upwards=true, offsets={x1=4, y1=-8, x2=-4,  y2=-1}, track=false})
				if self.isTT then
					self:SecureHook(fObj, "SetDisplayMode", function(frame, displayMode)
						for i, tab in _G.pairs(frame.Tabs) do
							if i == displayMode then
								self:setActiveTab(tab.sf)
							else
								self:setInactiveTab(tab.sf)
							end
						end
					end)
				end
				skinBidAmt(fObj.BidFrame.BidAmount)
				self:removeInset(fObj.SummaryList)
				self:removeNineSlice(fObj.SummaryList.NineSlice)
				fObj.SummaryList.Background:SetTexture(nil)
				self:skinObject("scrollbar", {obj=fObj.SummaryList.ScrollBar, fType=ftype})
				self:removeNineSlice(fObj.ItemDisplay.NineSlice)
				self:removeRegions(fObj.ItemDisplay, {3})
				skinItemList(fObj.AllAuctionsList)
				skinItemList(fObj.BidsList)
				skinItemList(fObj.ItemList)
				skinItemList(fObj.CommoditiesList)
				self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, fb=true, x1=-5, y1=-28, x2=0, y2=-25})
				-- N.B. workaround for BidsTab having 'useParentLevel' attribute set to true
				_G.RaiseFrameLevelByTwo(fObj)
				_G.LowerFrameLevel(fObj.sf)
				if self.modBtns then
					self:skinStdButton{obj=fObj.CancelAuctionButton, fType=ftype, sechk=true}
					self:skinStdButton{obj=fObj.BuyoutFrame.BuyoutButton, fType=ftype, sechk=true}
					self:skinStdButton{obj=fObj.BidFrame.BidButton, fType=ftype, sechk=true}
				end

				self:Unhook(fObj, "OnShow")
			end)

			self:SecureHookScript(this.BuyDialog, "OnShow", function(fObj)
				self:skinObject("frame", {obj=fObj.Border, fType=ftype, kfs=true, ofs=-10})
				if self.modBtns then
					self:skinStdButton{obj=fObj.BuyNowButton, fType=ftype, sechk=true}
					self:skinStdButton{obj=fObj.CancelButton, fType=ftype, sechk=true}
				end

				self:Unhook(fObj, "OnShow")
			end)

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.AuctionHouseFrame)

	end

	aObj.blizzLoDFrames[ftype].BlackMarketUI = function(self)
		if not self.prdb.BlackMarketUI or self.initialized.BlackMarketUI then return end
		self.initialized.BlackMarketUI = true

		self:SecureHookScript(_G.BlackMarketFrame, "OnShow", function(this)
			self:moveObject{obj=self:getRegion(this, 22), y=-4} -- title
			self:keepFontStrings(this.HotDeal)
			for _, type in _G.pairs{"Name", "Level", "Type", "Duration", "HighBidder", "CurrentBid"} do
				self:skinObject("frame", {obj=this["Column" .. type], fType=ftype, kfs=true, bd=5, ofs=0})
			end
			self:skinObject("scrollbar", {obj=this.ScrollBar, fType=ftype})
			local function skinItem(...)
				local _, element
				if _G.select("#", ...) == 2 then
					element, _ = ...
				else
					_, element, _ = ...
				end
				aObj:removeRegions(element, {1, 2, 3})
				element.Item:GetNormalTexture():SetTexture(nil)
				element.Item:GetPushedTexture():SetTexture(nil)
				if aObj.modBtnBs then
					aObj:addButtonBorder{obj=element.Item, clr=element.Item.IconBorder:GetVertexColor()}
				end
			end
			_G.ScrollUtil.AddInitializedFrameCallback(this.ScrollBox, skinItem, aObj, true)
			this.MoneyFrameBorder:DisableDrawLayer("BACKGROUND")
			self:skinObject("moneyframe", {obj=_G.BlackMarketBidPrice})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, cb=true, x2=1})
			if self.modBtns then
				self:skinStdButton{obj=this.BidButton, sechk=true}
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=this.HotDeal.Item, clr=this.HotDeal.Item.IconBorder:GetVertexColor()}
			end

			self:Unhook(this, "OnShow")
		end)

	end

end

aObj.blizzFrames[ftype].GossipFrame = function(self)
	if not self.prdb.GossipFrame or self.initialized.GossipFrame then return end
	self.initialized.GossipFrame = true

	local skinGossip = _G.nop
	if not (self:isAddonEnabled("Quester")
	and _G.QuesterDB.gossipColor)
	then
		local text, hasCC
		if not self.isMnln then
			function skinGossip(...)
				local _, element, elementData
				if _G.select("#", ...) == 2 then
					element, elementData = ...
				elseif _G.select("#", ...) == 3 then
					_, element, elementData = ...
				end
				if elementData.buttonType == 1 then -- Greeting
					element.GreetingText:SetTextColor(aObj.HT:GetRGB())
				elseif elementData.buttonType ~= 2 then -- Divider
					text, hasCC = self:removeColourCodes(element:GetFontString():GetText())
					if hasCC then
						element:GetFontString():SetText(text)
					end
					element:GetFontString():SetTextColor(aObj.BT:GetRGB())
				end
			end
		else
			self:SecureHook(_G.GossipFrame, "UpdateFontStrings", function(this, _)
				for fontString in _G.pairs(this.fontStrings) do
					if fontString:GetParentKey() == "GreetingText" then
						fontString:SetTextColor(aObj.HT:GetRGB())
					else
						text, hasCC = self:removeColourCodes(fontString:GetText())
						if hasCC then
							fontString:SetText(text)
						end
						fontString:SetTextColor(aObj.BT:GetRGB())
					end
				end
			end)
		end
	end

	self:SecureHookScript(_G.GossipFrame, "OnShow", function(this)
		self:keepFontStrings(this.GreetingPanel)
		self:skinObject("scrollbar", {obj=this.GreetingPanel.ScrollBar, fType=ftype})
		if not self.isMnln then
			_G.ScrollUtil.AddInitializedFrameCallback(this.GreetingPanel.ScrollBox, skinGossip, aObj, true)
		end
		if not self.isClsc then
			local sBar = self.isMnln and this.FriendshipStatusBar or _G.NPCFriendshipStatusBar
			self:removeRegions(sBar, {1, 2, 5, 6, 7, 8 ,9})
			self:skinObject("statusbar", {obj=sBar, fi=0, bg=self:getRegion(sBar, 10)})
		end
		if not self.isClscERA then
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true, x2=3})
		else
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, x1=14, y1=-18, x2=-29, y2=66})
		end
		if self.modBtns then
			self:skinStdButton{obj=this.GreetingPanel.GoodbyeButton}
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].GuildRegistrar = function(self)
	if not self.prdb.GuildRegistrar or self.initialized.GuildRegistrar then return end
	self.initialized.GuildRegistrar = true

	self:SecureHookScript(_G.GuildRegistrarFrame, "OnShow", function(this)
		self:keepFontStrings(_G.GuildRegistrarGreetingFrame)
		if self.isMnln then
			_G.AvailableServicesText:SetTextColor(self.HT:GetRGB())
		else
			_G.GuildAvailableServicesText:SetTextColor(self.HT:GetRGB())
		end
		self:getRegion(_G.GuildRegistrarButton1, 3):SetTextColor(self.BT:GetRGB())
		self:getRegion(_G.GuildRegistrarButton2, 3):SetTextColor(self.BT:GetRGB())
		_G.GuildRegistrarPurchaseText:SetTextColor(self.BT:GetRGB())
		self:skinObject("editbox", {obj=_G.GuildRegistrarFrameEditBox, fType=ftype})
		if self.isMnln then
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true})
		else
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, x1=10, y1=-17, x2=-29, y2=62})
		end
		if self.modBtns then
			self:skinStdButton{obj=_G.GuildRegistrarFrameGoodbyeButton}
			self:skinStdButton{obj=_G.GuildRegistrarFrameCancelButton}
			self:skinStdButton{obj=_G.GuildRegistrarFramePurchaseButton}
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].MerchantFrame = function(self)
	if not self.prdb.MerchantFrame or self.initialized.MerchantFrame then return end
	self.initialized.MerchantFrame = true

	self:SecureHookScript(_G.MerchantFrame, "OnShow", function(this)
		self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true})
		self:removeInset(_G.MerchantMoneyInset)
		_G.MerchantMoneyBg:DisableDrawLayer("BACKGROUND")
		-- Items/Buyback Items
		for i = 1, _G.math.max(_G.MERCHANT_ITEMS_PER_PAGE, _G.BUYBACK_ITEMS_PER_PAGE) do
			_G["MerchantItem" .. i .. "NameFrame"]:SetTexture(nil)
			if not self.modBtnBs then
				_G["MerchantItem" .. i .. "SlotTexture"]:SetTexture(self.tFDIDs.esTex)
			else
				_G["MerchantItem" .. i .. "SlotTexture"]:SetTexture(nil)
				self:addButtonBorder{obj=_G["MerchantItem" .. i].ItemButton, fType=ftype, ibt=true}
			end
		end
		_G.MerchantBuyBackItemNameFrame:SetTexture(nil)
		if self.isMnln then
			self:skinObject("ddbutton", {obj=this.FilterDropdown, fType=ftype})
			self:removeInset(_G.MerchantExtraCurrencyInset)
			_G.MerchantExtraCurrencyBg:DisableDrawLayer("BACKGROUND")
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true, y2=-2})
		else
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, cb=true, x2=1, y2=-3})
		end
		if self.modBtnBs then
			self:removeRegions(_G.MerchantPrevPageButton, {2})
			self:removeRegions(_G.MerchantNextPageButton, {2})
			self:addButtonBorder{obj=_G.MerchantPrevPageButton, ofs=-2, y1=-3, x2=-3}
			self:addButtonBorder{obj=_G.MerchantNextPageButton, ofs=-2, y1=-3, x2=-3}
			self:SecureHook("MerchantFrame_UpdateMerchantInfo", function()
				self:clrPNBtns("Merchant")
			end)
			self:SecureHook("MerchantFrameItem_UpdateQuality", function(item, _, _)
				self:clrButtonFromBorder(item.ItemButton)
			end)
			local btn
			for _, type in _G.pairs{"SellAllJunk", "RepairAll", "RepairItem", "GuildBankRepair"} do
				btn = _G["Merchant" .. type .. "Button"]
				if btn then
					btn:DisableDrawLayer("BACKGROUND") -- Retail EmptySlot texture
					self:addButtonBorder{obj=btn, fType=ftype, clr="gold", sechk=true}
				end
			end
			self:SecureHook("MerchantFrame_UpdateCanRepairAll", function()
				self:clrBtnBdr(_G.MerchantRepairAllButton, "gold")
			end)
			if self.isMnln then
				self:SecureHook("MerchantFrame_UpdateGuildBankRepair", function()
					self:clrBtnBdr(_G.MerchantGuildBankRepairButton, "gold")
				end)
			end
			_G.MerchantBuyBackItemSlotTexture:SetTexture(nil)
			self:addButtonBorder{obj=_G.MerchantBuyBackItem.ItemButton, fType=ftype, ibt=true}
		else
			_G.MerchantBuyBackItemSlotTexture:SetTexture(self.tFDIDs.esTex)
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].Petition = function(self)
	if not self.prdb.Petition or self.initialized.Petition then return end
	self.initialized.Petition = true

	self:SecureHookScript(_G.PetitionFrame, "OnShow", function(this)
		_G.PetitionFrameCharterTitle:SetTextColor(self.HT:GetRGB())
		_G.PetitionFrameCharterName:SetTextColor(self.BT:GetRGB())
		_G.PetitionFrameMasterTitle:SetTextColor(self.HT:GetRGB())
		_G.PetitionFrameMasterName:SetTextColor(self.BT:GetRGB())
		_G.PetitionFrameMemberTitle:SetTextColor(self.HT:GetRGB())
		for i = 1, 9 do
			_G["PetitionFrameMemberName" .. i]:SetTextColor(self.BT:GetRGB())
		end
		_G.PetitionFrameInstructions:SetTextColor(self.BT:GetRGB())
		if self.isMnln then
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true})
		else
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, x1=10, y1=-17, x2=-29, y2=62})
		end
		if self.modBtns then
			self:skinStdButton{obj=_G.PetitionFrameCancelButton}
			self:skinStdButton{obj=_G.PetitionFrameSignButton}
			self:skinStdButton{obj=_G.PetitionFrameRequestButton, x2=-1}
			self:skinStdButton{obj=_G.PetitionFrameRenameButton, x1=1, x2=-1}
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].QuestFrame = function(self)
	if not self.prdb.QuestFrame or self.initialized.QuestFrame then return end
	self.initialized.QuestFrame = true

	self:SecureHookScript(_G.QuestFrame, "OnShow", function(this)
		self:keepFontStrings(_G.QuestFrameRewardPanel)
		_G.QuestRewardScrollFrame:DisableDrawLayer("ARTWORK")
		self:keepFontStrings(_G.QuestFrameProgressPanel)
		if self.isMnln then
			self:skinObject("scrollbar", {obj=_G.QuestProgressScrollFrame.ScrollBar, fType=ftype})
		else
			self:skinObject("slider", {obj=_G.QuestProgressScrollFrame.ScrollBar, fType=ftype, rpTex="artwork"})
		end
		_G.QuestProgressTitleText:SetTextColor(self.HT:GetRGB())
		_G.QuestProgressText:SetTextColor(self.BT:GetRGB())
		_G.QuestProgressRequiredMoneyText:SetTextColor(self.BT:GetRGB())
		_G.QuestProgressRequiredItemsText:SetTextColor(self.HT:GetRGB())
		local btnName
		for i = 1, _G.MAX_REQUIRED_ITEMS do
			btnName = "QuestProgressItem" .. i
			_G[btnName .. "NameFrame"]:SetTexture(nil)
			if self.modBtns then
				 self:addButtonBorder{obj=_G[btnName], fType=ftype, libt=true}
			end
		end
		self:keepFontStrings(_G.QuestFrameDetailPanel)
		if self.isMnln then
			self:skinObject("scrollbar", {obj=_G.QuestDetailScrollFrame.ScrollBar, fType=ftype})
		else
			self:skinObject("slider", {obj=_G.QuestDetailScrollFrame.ScrollBar, fType=ftype, rpTex="artwork"})
		end
		self:keepFontStrings(_G.QuestFrameGreetingPanel)
		self:keepFontStrings(_G.QuestGreetingScrollChildFrame) -- hide Horizontal Break texture
		if _G.QuestFrameGreetingPanel:IsShown() then
			_G.GreetingText:SetTextColor(self.BT:GetRGB())
			_G.CurrentQuestsText:SetTextColor(self.HT:GetRGB())
			_G.AvailableQuestsText:SetTextColor(self.HT:GetRGB())
		end
		if self.isMnln then
			self:skinObject("scrollbar", {obj=_G.QuestGreetingScrollFrame.ScrollBar, fType=ftype})
		else
			self:skinObject("slider", {obj=_G.QuestGreetingScrollFrame.ScrollBar, fType=ftype, rpTex="artwork"})
			for i = 1, _G.MAX_NUM_QUESTS do
				self:hookQuestText(_G["QuestTitleButton" .. i])
			end
			-- force recolouring of quest text
			self:checkShown(_G.QuestFrameGreetingPanel)
		end
		if not self.isClscERA then
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true})
		else
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, x1=10, y1=-18, x2=-29, y2=65})
		end
		if self.modBtns then
			self:skinCloseButton{obj=_G.QuestFrameCloseButton, fType=ftype, schk=true}
			self:skinStdButton{obj=_G.QuestFrameCompleteQuestButton, fType=ftype, schk=true}
			self:skinStdButton{obj=_G.QuestFrameGoodbyeButton, fType=ftype}
			self:skinStdButton{obj=_G.QuestFrameCompleteButton, fType=ftype, schk=true}
			self:skinStdButton{obj=_G.QuestFrameDeclineButton, fType=ftype}
			self:skinStdButton{obj=_G.QuestFrameAcceptButton, fType=ftype, schk=true}
			self:skinStdButton{obj=_G.QuestFrameGreetingGoodbyeButton, fType=ftype}
			if not self.isMnln then
				self:skinStdButton{obj=_G.QuestFrameCancelButton, fType=ftype}
			end
		end

		self:Unhook(this, "OnShow")
	end)

	if self.isMnln then
		if not (self:isAddonEnabled("Quester")
		and _G.QuesterDB.gossipColor)
		then
			-- hook this to colour quest button text
			self:RawHook(_G.QuestFrameGreetingPanel.titleButtonPool, "Acquire", function(this)
				local btn = self.hooks[this].Acquire(this)
				self:hookQuestText(btn)
				return btn
			end, true)
		end
	end

	self:RawHook("QuestFrame_SetTitleTextColor", function(fontString, _)
		fontString:SetTextColor(self.HT:GetRGB())
	end, true)
	self:RawHook("QuestFrame_SetTextColor", function(fontString, _)
		fontString:SetTextColor(self.BT:GetRGB())
	end, true)
	self:SecureHook("QuestFrameProgressItems_Update", function()
		local br, bg, bb = self.BT:GetRGB()
		local r, g ,b = _G.QuestProgressRequiredMoneyText:GetTextColor()
		-- aObj:Debug("QFPT_U: [%s, %s, %s]", r, g, b)
		-- if red colour is less than 0.2 then it needs to be coloured
		if r < 0.2 then
			_G.QuestProgressRequiredMoneyText:SetTextColor(br - r, bg - g, bb - b)
		else
			_G.QuestProgressRequiredMoneyText:SetTextColor(self.BT:GetRGB())
		end
	end)

	self:SecureHookScript(_G.QuestModelScene or _G.QuestNPCModel , "OnShow", function(this)
		if self.isMnln then
			self:skinObject("scrollbar", {obj=_G.QuestNPCModelTextScrollFrame.ScrollBar, fType=ftype})
		else
			self:skinObject("slider", {obj=_G.QuestNPCModelTextScrollFrame.ScrollBar, fType=ftype})
		end
		self:skinObject("frame", {obj=this.ModelTextFrame or _G.QuestNPCModelTextFrame, fType=ftype, kfs=true, x1=-2, y1=1, x2=6, y2=0})
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ofs=4, y1=-24, y2=-24})

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].QuestInfo = function(self)
	if not self.prdb.QuestInfo or self.initialized.QuestInfo then return end
	self.initialized.QuestInfo = true

	local function skinRewards(frame)
		if frame.Header:IsObjectType("FontString") then
			frame.Header:SetTextColor(aObj.HT:GetRGB())
		end
		frame.ItemChooseText:SetTextColor(aObj.BT:GetRGB())
		frame.ItemReceiveText:SetTextColor(aObj.BT:GetRGB())
		if not aObj.isClsc then
			frame.PlayerTitleText:SetTextColor(aObj.BT:GetRGB())
		end
		if frame.XPFrame.ReceiveText then
			frame.XPFrame.ReceiveText:SetTextColor(aObj.BT:GetRGB())
		end
		for _, btn in _G.pairs(frame.RewardButtons) do
			btn.NameFrame:SetTexture(nil)
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=btn, fType=ftype, libt=true, clr=btn.IconBorder:GetVertexColor()}
			end
		end
		for spellBtn in frame.spellRewardPool:EnumerateActive() do
			spellBtn.NameFrame:SetTexture(nil)
			spellBtn:DisableDrawLayer("OVERLAY")
			if aObj.modBtnBs then
				 aObj:addButtonBorder{obj=spellBtn, relTo=spellBtn.Icon}
			end
		end
		for flwrBtn in frame.followerRewardPool:EnumerateActive() do
			flwrBtn.BG:SetTexture(nil)
			flwrBtn.PortraitFrame.PortraitRing:SetTexture(nil)
			flwrBtn.PortraitFrame.LevelBorder:SetAlpha(0) -- texture changed
			if flwrBtn.PortraitFrame.PortraitRingCover then
				flwrBtn.PortraitFrame.PortraitRingCover:SetTexture(nil)
			end
		end
		for spellLine in frame.spellHeaderPool:EnumerateActive() do
			spellLine:SetVertexColor(aObj.BT:GetRGB())
		end
		if aObj.isMnln then
			for rep in frame.reputationRewardPool:EnumerateActive() do
				rep.NameFrame:SetTexture(nil)
				if aObj.modBtnBs then
					aObj:addButtonBorder{obj=rep, fType=ftype, relTo=rep.Icon, reParent={rep.RewardAmount}}
				end
			end
		end
	end
	local br, bg, bb, r, g, b, newText, upd
	local function updateQIDisplay(_)
		_G.QuestInfoTitleHeader:SetTextColor(aObj.HT:GetRGB())
		_G.QuestInfoDescriptionHeader:SetTextColor(aObj.HT:GetRGB())
		_G.QuestInfoObjectivesHeader:SetTextColor(aObj.HT:GetRGB())
		_G.QuestInfoQuestType:SetTextColor(aObj.BT:GetRGB())
		_G.QuestInfoObjectivesText:SetTextColor(aObj.BT:GetRGB())
		_G.QuestInfoRewardText:SetTextColor(aObj.BT:GetRGB())
		br, bg, bb = aObj.BT:GetRGB()
		r, g, b = _G.QuestInfoRequiredMoneyText:GetTextColor()
		_G.QuestInfoRequiredMoneyText:SetTextColor(br - r, bg - g, bb - b)
		_G.QuestInfoGroupSize:SetTextColor(aObj.BT:GetRGB())
		_G.QuestInfoAnchor:SetTextColor(aObj.BT:GetRGB())
		-- remove any embedded colour codes
		newText, upd = aObj:removeColourCodes(_G.QuestInfoDescriptionText:GetText())
		if upd then
			_G.QuestInfoDescriptionText:SetText(newText)
		end
		_G.QuestInfoDescriptionText:SetTextColor(aObj.BT:GetRGB())
		for _, obj in _G.pairs(_G.QuestInfoObjectivesFrame.Objectives) do
			r, g ,b = obj:GetTextColor()
			-- aObj:Debug("updateQIDisplay: [%s, %s, %s]", r, g, b)
			-- if red colour is less than 0.25 then it needs to be coloured
			if r < 0.25 then
				obj:SetTextColor(br - r, bg - g, bb - b)
			else
				obj:SetTextColor(aObj.BT:GetRGB())
			end
		end
		_G.QuestInfoSpellObjectiveLearnLabel:SetTextColor(aObj.BT:GetRGB())
		_G.QuestInfoSpellObjectiveFrameNameFrame:SetTexture(nil)
		if not aObj.isClsc then
			_G.QuestInfoSpellObjectiveFrameSpellBorder:SetTexture(nil)
		end
		if aObj.modBtnBs then
			 aObj:addButtonBorder{obj=_G.QuestInfoSpellObjectiveFrame, relTo=_G.QuestInfoSpellObjectiveFrame.Icon}
		end
		if _G.QuestInfoSealFrame:IsShown()
		and _G.QuestInfoSealFrame.theme
		then
			_G.QuestInfoSealFrame.Text:SetText(aObj.HT:WrapTextInColorCode(aObj:removeColourCodes(_G.QuestInfoSealFrame.theme.signature)))
		end
		skinRewards(_G.QuestInfoFrame.rewardsFrame)
	end

	self:SecureHook("QuestInfo_Display", function(...)
		updateQIDisplay(...)
	end)

	self:SecureHookScript(_G.QuestInfoFrame, "OnShow", function(this)
		updateQIDisplay()

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.QuestInfoTimerFrame, "OnShow", function(this)
		_G.QuestInfoTimerText:SetTextColor(self.BT:GetRGB())
		_G.QuestInfoAnchor:SetTextColor(self.BT:GetRGB())

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.QuestInfoRequiredMoneyFrame, "OnShow", function(this)
		self:SecureHook("QuestInfo_ShowRequiredMoney", function()
			br, bg, bb = self.BT:GetRGB()
			r, g ,b = _G.QuestInfoRequiredMoneyText:GetTextColor()
			-- if red value is less than 0.2 then it needs to be coloured
			if r < 0.2 then
				_G.QuestInfoRequiredMoneyText:SetTextColor(br - r, bg - g, bb - b)
			end
		end)

		self:Unhook(this, "OnShow")
	end)

	local function skinRewardsTypes(frame, type)
		type = type .. "Frame"
		if frame[type].NameFrame then
			frame[type].NameFrame:SetTexture(nil)
		elseif type == "TitleFrame" then
			aObj:removeRegions(frame[type].TitleFrame, {2, 3, 4}) -- NameFrame textures
		end
		if frame[type].ReceiveText then
			frame[type].ReceiveText:SetTextColor(aObj.BT:GetRGB())
		end
		if aObj.modBtnBs then
			aObj:addButtonBorder{obj=frame[type], fType=ftype, sibt=true, relTo=frame[type].Icon, reParent=type == "SkillPointFrame" and {frame[type].CircleBackground, frame[type].CircleBackgroundGlow, frame[type].ValueText} or nil}
		end
	end
	self:SecureHookScript(_G.QuestInfoRewardsFrame, "OnShow", function(this)
		for _, type in _G.pairs{"SkillPoint", "ArtifactXP", aObj.isMnln and "WarModeBonus" or nil} do
			skinRewardsTypes(this, type)
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.MapQuestInfoRewardsFrame, "OnShow", function(this)
		for _, type in _G.pairs{"XP", "Honor", "ArtifactXP", "Money", "SkillPoint", "Title", aObj.isMnln and "WarModeBonus" or nil} do
			skinRewardsTypes(this, type)
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].Tabard = function(self)
	if not self.prdb.Tabard or self.initialized.Tabard then return end
	self.initialized.Tabard = true

	self:SecureHookScript(_G.TabardFrame, "OnShow", function(this)
		self:removeNineSlice(_G.TabardFrameCostFrame.NineSlice)
		self:keepFontStrings(_G.TabardFrameCustomizationFrame)
		for i = 1, 5 do
			self:keepFontStrings(_G["TabardFrameCustomization" .. i])
			if self.modBtnBs then
				self:addButtonBorder{obj=_G["TabardFrameCustomization" .. i .. "LeftButton"], ofs=-3, x1=1, clr="gold"}
				self:addButtonBorder{obj=_G["TabardFrameCustomization" .. i .. "RightButton"], ofs=-3, x1=1, clr="gold"}
			end
		end
		if self.isClscERA then
			self:removeInset(_G.TabardFrameMoneyInset)
			_G.TabardFrameMoneyBg:DisableDrawLayer("BACKGROUND")
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true})
		else
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, x1=10, y1=-11, x2=-32, y2=71})
		end
		if self.modBtns then
			self:skinStdButton{obj=_G.TabardFrameAcceptButton}
			self:skinStdButton{obj=_G.TabardFrameCancelButton}
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.TabardCharacterModelRotateLeftButton, ofs=-4, y2=5, clr="gold"}
			self:addButtonBorder{obj=_G.TabardCharacterModelRotateRightButton, ofs=-4, y2=5, clr="gold"}
		end

		self:Unhook(this, "OnShow")
	end)

end
