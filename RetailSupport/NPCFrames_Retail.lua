local _, aObj = ...

local _G = _G

aObj.SetupRetail_NPCFrames = function()
	local ftype = "n"

	aObj.blizzLoDFrames[ftype].AlliedRacesUI = function(self)
		if not self.prdb.AlliedRacesUI or self.initialized.AlliedRacesUI then return end
		self.initialized.AlliedRacesUI = true

		self:SecureHookScript(_G.AlliedRacesFrame, "OnShow", function(this)
			this.ModelFrame:DisableDrawLayer("BORDER")
			this.ModelFrame:DisableDrawLayer("ARTWORK")
			this.RaceInfoFrame.ScrollFrame.Child.RaceDescriptionText:SetTextColor(self.BT:GetRGB())
			this.RaceInfoFrame.ScrollFrame.Child.ObjectivesFrame.Description:SetTextColor(self.BT:GetRGB())
			this.RaceInfoFrame.ScrollFrame.Child.RacialTraitsLabel:SetTextColor(self.HT:GetRGB())
			this.RaceInfoFrame.ScrollFrame.Child.ObjectivesFrame.HeaderBackground:SetTexture(nil)
			this.RaceInfoFrame.ScrollFrame.Child.ObjectivesFrame:DisableDrawLayer("BACKGROUND")
			self:skinObject("slider", {obj=this.RaceInfoFrame.ScrollFrame.ScrollBar, fType=ftype, rpTex="background"})
			this.RaceInfoFrame.ScrollFrame.ScrollBar.ScrollUpBorder:ClearBackdrop()
			this.RaceInfoFrame.ScrollFrame.ScrollBar.ScrollDownBorder:ClearBackdrop()
			this.RaceInfoFrame.ScrollFrame.ScrollBar.Border:ClearBackdrop()
			this.RaceInfoFrame.AlliedRacesRaceName:SetTextColor(self.HT:GetRGB())
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true})
			if self.modBtnBs then
				self:addButtonBorder{obj=this.ModelFrame.AlliedRacesMaleButton, ofs=0}
				self:addButtonBorder{obj=this.ModelFrame.AlliedRacesFemaleButton, ofs=0}
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHook(_G.AlliedRacesFrame, "LoadRaceData", function(this, _)
			for ability in this.abilityPool:EnumerateActive() do
				ability.Text:SetTextColor(self.BT:GetRGB())
				self:getRegion(ability, 3):SetTexture(nil) -- Border texture
				if self.modBtnBs then
					self:addButtonBorder{obj=ability, relTo=ability.Icon}
				end
			end
		end)

	end

	aObj.blizzLoDFrames[ftype].AuctionHouseUI = function(self)
		if not self.prdb.AuctionHouseUI or self.initialized.AuctionHouseUI then return end
		self.initialized.AuctionHouseUI = true

		-- FIXME: split subframes into separate OnShow functions

		function skinAuctionHouseFrames()
			local ahf = _G.AuctionHouseFrame
			if not aObj.isRtlPTR then
				self:removeInset(self:getChild(ahf, 3)) -- MerchantMoneyInset
			else
				self:removeInset(ahf.MoneyFrameInset) -- MerchantMoneyInset
			end
			ahf.MoneyFrameBorder:DisableDrawLayer("BACKGROUND")
			ahf.MoneyFrameBorder:DisableDrawLayer("BORDER")
			self:skinObject("tabs", {obj=ahf, tabs=ahf.Tabs, fType=ftype, lod=self.isTT and true, track=false, offsets={x1=8, y1=self.isTT and 2 or -3, x2=-8, y2=2}})
			if self.isTT then
				self:SecureHook(ahf, "SetDisplayMode", function(fObj, displayMode)
					if not fObj.tabsForDisplayMode[displayMode] then return end
					for i, tab in _G.ipairs(fObj.Tabs) do
						if i == fObj.tabsForDisplayMode[displayMode] then
							self:setActiveTab(tab.sf)
						else
							self:setInactiveTab(tab.sf)
						end
					end
				end)
			end
			self:skinObject("frame", {obj=ahf, fType=ftype, kfs=true, rns=true, cb=true, x2=3, y2=0})

			local function skinItemList(frame)
				if aObj.modBtnBs then
					aObj:addButtonBorder{obj=frame.RefreshFrame.RefreshButton, ofs=-2, x1=1, clr="gold"}
				end
				aObj:removeNineSlice(frame.NineSlice)
				frame.Background:SetTexture(nil)
				if not aObj.isRtlPTR then
					aObj:skinObject("slider", {obj=frame.ScrollFrame.scrollBar, fType=ftype, y1=-2, y2=2})
				else
					aObj:skinObject("scrollbar", {obj=frame.ScrollBar, fType=ftype})
				end
				local function skinHeaders(fObj)
					if fObj.tableBuilder then
						for hdr in fObj.tableBuilder.headerPoolCollection:EnumerateActive() do
							aObj:removeRegions(hdr, {1, 2, 3})
							aObj:skinObject("frame", {obj=hdr, fType=ftype, ofs=0, x1=1, x2=-1})
						end
					end
				end
				skinHeaders(frame)
				aObj:SecureHook(frame, "RefreshScrollFrame", function(fObj)
					skinHeaders(fObj)
				end)
			end
			local function skinBidAmt(frame)
				aObj:skinObject("editbox", {obj=frame.gold, fType=ftype, ofs=0})
				aObj:skinObject("editbox", {obj=frame.silver, fType=ftype, ofs=0})
				aObj:skinObject("editbox", {obj=frame.copper, fType=ftype, ofs=0})
				frame.silver:SetWidth(38)
				aObj:moveObject{obj=frame.silver.texture, x=10}
				frame.copper:SetWidth(38)
				aObj:moveObject{obj=frame.copper.texture, x=10}
			end
			-- Browsing frames
			self:skinObject("editbox", {obj=ahf.SearchBar.SearchBox, fType=ftype, si=true})
			self:skinObject("editbox", {obj=ahf.SearchBar.FilterButton.LevelRangeFrame.MinLevel, fType=ftype})
			self:skinObject("editbox", {obj=ahf.SearchBar.FilterButton.LevelRangeFrame.MaxLevel, fType=ftype})
			if self.modBtnBs then
				self:addButtonBorder{obj=ahf.SearchBar.FavoritesSearchButton, ofs=-2, x1=1, clr="grey"}
			end
			ahf.CategoriesList:DisableDrawLayer("BACKGROUND")
			self:removeNineSlice(ahf.CategoriesList.NineSlice)
			if not aObj.isRtlPTR then
				for _, btn in _G.pairs(ahf.CategoriesList.FilterButtons) do
					self:keepRegions(btn, {3, 4, 5}) -- N.B. region 3 is highlight, 4 is selected, 5 is text
					self.modUIBtns:skinStdButton{obj=btn, fType=ftype, ignoreHLTex=true, ofs=1}
				end
				self:SecureHook("FilterButton_SetUp", function(button, _)
					button.NormalTexture:SetAlpha(0)
				end)
				self:skinObject("slider", {obj=ahf.CategoriesList.ScrollFrame.ScrollBar, fType=ftype, rpTex="border"})
				ahf.CategoriesList.ScrollFrame:DisableDrawLayer("BACKGROUND")
				ahf.CategoriesList.Background:SetTexture(nil)
			else
				self:skinObject("scrollbar", {obj=ahf.CategoriesList.ScrollBar, fType=ftype})
				local function skinCategoryButton(btn)
					aObj:keepRegions(btn, {3, 4, 5}) -- N.B. region 3 is highlight, 4 is selected, 5 is text
					aObj.modUIBtns:skinStdButton{obj=btn, fType=ftype, ignoreHLTex=true}
					btn.sb:Show()
					btn.sb:ClearAllPoints()
					if btn.type == "category" then
						btn.sb:SetPoint("TOPLEFT", btn, "TOPLEFT", -1, 1)
						btn.sb:SetPoint("BOTTOMRIGHT", btn, "BOTTOMRIGHT", -4, -1)
					elseif btn.type == "subCategory" then
						btn.sb:SetPoint("TOPLEFT", btn, "TOPLEFT", 10, 1)
						btn.sb:SetPoint("BOTTOMRIGHT", btn, "BOTTOMRIGHT", -4, -1)
					elseif btn.type == "subSubCategory" then
						btn.sb:Hide()
					end
				end
				_G.ScrollUtil.AddInitializedFrameCallback(ahf.CategoriesList.ScrollBox, skinCategoryButton, aObj, true)
			end
			skinItemList(ahf.BrowseResultsFrame.ItemList)
			ahf.WoWTokenResults.Background:SetTexture(nil)
			self:removeNineSlice(ahf.WoWTokenResults.NineSlice)
			self:SecureHookScript(ahf.WoWTokenResults.GameTimeTutorial, "OnShow", function(fObj)
				self:removeInset(fObj.Inset)
				fObj.LeftDisplay.Label:SetTextColor(self.HT:GetRGB())
				fObj.LeftDisplay.Tutorial1:SetTextColor(self.BT:GetRGB())
				fObj.RightDisplay.Label:SetTextColor(self.HT:GetRGB())
				fObj.RightDisplay.Tutorial1:SetTextColor(self.BT:GetRGB())
				self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, y2=220})
				if self.modBtns then
					if aObj.isRtlPTR then
						self:skinCloseButton{obj=self:getChild(fObj, 4), fType=ftype} -- CloseButton is named AuctionHouseFrameCloseButton ?
					end
					self:skinStdButton{obj=fObj.RightDisplay.StoreButton, fType=ftype, x1=14, y1=2, x2=-14, y2=2, clr="gold"}
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:removeRegions(ahf.WoWTokenResults.TokenDisplay, {3}) -- background texture
			if self.modBtns then
				self:skinCloseButton{obj=ahf.SearchBar.FilterButton.ClearFiltersButton, fType=ftype, noSkin=true}
				self:skinStdButton{obj=ahf.SearchBar.FilterButton, fType=ftype, clr="grey"}
				self:skinStdButton{obj=ahf.SearchBar.SearchButton, fType=ftype}
				self:skinStdButton{obj=ahf.WoWTokenResults.Buyout, fType=ftype, sechk=true}
			end
			local btn = ahf.WoWTokenResults.TokenDisplay.ItemButton
			btn.IconBorder:SetTexture(nil)
			if self.modBtnBs then
				self:addButtonBorder{obj=btn, relTo=btn.Icon, reParent={btn.Count}}
				self:clrButtonFromBorder(btn)
			end
			ahf.WoWTokenResults.DummyScrollBar:DisableDrawLayer("BACKGROUND")
			if not aObj.isRtlPTR then
				ahf.WoWTokenResults.DummyScrollBar:DisableDrawLayer("ARTWORK")
			else
				ahf.WoWTokenResults.DummyScrollBar.Background:DisableDrawLayer("ARTWORK")
			end
			-- Buy frames
			self:removeNineSlice(ahf.CommoditiesBuyFrame.BuyDisplay.NineSlice)
			ahf.CommoditiesBuyFrame.BuyDisplay.Background:SetTexture(nil)
			self:removeRegions(ahf.CommoditiesBuyFrame.BuyDisplay.ItemDisplay, {3})
			self:skinObject("editbox", {obj=ahf.CommoditiesBuyFrame.BuyDisplay.QuantityInput.InputBox, fType=ftype, ofs=-2})
			self:adjHeight{obj=ahf.CommoditiesBuyFrame.BuyDisplay.QuantityInput.InputBox, adj=-3}
			skinItemList(ahf.CommoditiesBuyFrame.ItemList)
			self:removeNineSlice(ahf.ItemBuyFrame.ItemDisplay.NineSlice)
			self:removeRegions(ahf.ItemBuyFrame.ItemDisplay, {1})
			skinBidAmt(ahf.ItemBuyFrame.BidFrame.BidAmount)
			skinItemList(ahf.ItemBuyFrame.ItemList)
			if self.modBtns then
				self:skinStdButton{obj=ahf.CommoditiesBuyFrame.BackButton, fType=ftype}
				self:skinStdButton{obj=ahf.CommoditiesBuyFrame.BuyDisplay.QuantityInput.MaxButton, fType=ftype}
				self:skinStdButton{obj=ahf.CommoditiesBuyFrame.BuyDisplay.BuyButton, fType=ftype, sechk=true}
				self:skinStdButton{obj=ahf.ItemBuyFrame.BackButton, fType=ftype}
				self:skinStdButton{obj=ahf.ItemBuyFrame.BuyoutFrame.BuyoutButton, fType=ftype, sechk=true}
				self:skinStdButton{obj=ahf.ItemBuyFrame.BidFrame.BidButton, fType=ftype, sechk=true}
			end
			-- Sell frames
			local function skinPriceInp(frame)
				aObj:skinObject("editbox", {obj=frame.CopperBox, fType=ftype, ofs=0})
				aObj:skinObject("editbox", {obj=frame.SilverBox, fType=ftype, ofs=0})
				aObj:skinObject("editbox", {obj=frame.GoldBox, fType=ftype, ofs=0})
			end
			local function skinSellFrame(frame)
				aObj:removeNineSlice(frame.NineSlice)
				frame.Background:SetTexture(nil)
				aObj:keepFontStrings(frame)
				aObj:removeNineSlice(frame.ItemDisplay.NineSlice)
				aObj:removeRegions(frame.ItemDisplay, {3})
				aObj:skinObject("editbox", {obj=frame.QuantityInput.InputBox, fType=ftype, ofs=0})
				skinPriceInp(frame.PriceInput.MoneyInputFrame)
				aObj:skinObject("dropdown", {obj=frame.DurationDropDown.DropDown, fType=ftype, lrgTpl=true, x1=0, y1=1, x2=-1, y2=3})
				if aObj.modBtns then
					aObj:skinStdButton{obj=frame.QuantityInput.MaxButton, fType=ftype, sechk=true}
					aObj:skinStdButton{obj=frame.PostButton, fType=ftype, sechk=true}
				end
				if aObj.modBtnBs then
					aObj:addButtonBorder{obj=frame.ItemDisplay.ItemButton, ftype=ftype, gibt=true, ofs=0}
				end
			end
			skinSellFrame(ahf.ItemSellFrame)
			if self.modChkBtns then
				self:skinCheckButton{obj=ahf.ItemSellFrame.BuyoutModeCheckButton}
			end
			skinPriceInp(ahf.ItemSellFrame.SecondaryPriceInput.MoneyInputFrame)
			skinItemList(ahf.ItemSellList)
			skinSellFrame(ahf.CommoditiesSellFrame)
			skinItemList(ahf.CommoditiesSellList)
			-- .WoWTokenSellFrame
			self:removeNineSlice(ahf.WoWTokenSellFrame.ItemDisplay.NineSlice)
			self:removeRegions(ahf.WoWTokenSellFrame.ItemDisplay, {3})
			self:removeNineSlice(ahf.WoWTokenSellFrame.DummyItemList.NineSlice)
			ahf.WoWTokenSellFrame.DummyItemList.Background:SetTexture(nil)
			ahf.WoWTokenSellFrame.DummyItemList.DummyScrollBar:DisableDrawLayer("BACKGROUND")
			if not aObj.isRtlPTR then
				ahf.WoWTokenSellFrame.DummyItemList.DummyScrollBar:DisableDrawLayer("ARTWORK")
			else
				ahf.WoWTokenSellFrame.DummyItemList.DummyScrollBar.Background:DisableDrawLayer("ARTWORK")
			end
			if self.modBtns then
				self:skinStdButton{obj=ahf.WoWTokenSellFrame.PostButton, fType=ftype, sechk=true}
			end
			-- Auctions frames
			self:skinObject("tabs", {obj=ahf.AuctionsFrame, tabs=ahf.AuctionsFrame.Tabs, fType=ftype, lod=self.isTT and true, upwards=true, offsets={x1=6, y1=-4, x2=-6, y2=self.isTT and -1 or 0}, track=false})
			if self.isTT then
				self:SecureHook(ahf.AuctionsFrame, "SetDisplayMode", function(fObj, displayMode)
					for i, tab in _G.pairs(fObj.Tabs) do
						if i == displayMode then
							self:setActiveTab(tab.sf)
						else
							self:setInactiveTab(tab.sf)
						end
					end
				end)
			end
			skinBidAmt(ahf.AuctionsFrame.BidFrame.BidAmount)
			self:removeInset(ahf.AuctionsFrame.SummaryList)
			self:removeNineSlice(ahf.AuctionsFrame.SummaryList.NineSlice)
			ahf.AuctionsFrame.SummaryList.Background:SetTexture(nil)
			if not aObj.isRtlPTR then
				self:skinObject("slider", {obj=ahf.AuctionsFrame.SummaryList.ScrollFrame.scrollBar, fType=ftype, rpTex="background"})
			else
				self:skinObject("scrollbar", {obj=ahf.AuctionsFrame.SummaryList.ScrollBar, fType=ftype})
			end
			self:removeNineSlice(ahf.AuctionsFrame.ItemDisplay.NineSlice)
			self:removeRegions(ahf.AuctionsFrame.ItemDisplay, {3})
			skinItemList(ahf.AuctionsFrame.AllAuctionsList)
			skinItemList(ahf.AuctionsFrame.BidsList)
			skinItemList(ahf.AuctionsFrame.ItemList)
			skinItemList(ahf.AuctionsFrame.CommoditiesList)
			self:skinObject("frame", {obj=ahf.AuctionsFrame, fType=ftype, kfs=true, fb=true, x1=-5, y1=-28, x2=0, y2=-25})
			-- N.B. workaround for BidsTab having 'useParentLevel' attribute set to true
			_G.RaiseFrameLevelByTwo(ahf.AuctionsFrame)
			_G.LowerFrameLevel(ahf.AuctionsFrame.sf)
			if self.modBtns then
				self:skinStdButton{obj=ahf.AuctionsFrame.CancelAuctionButton, fType=ftype, sechk=true}
				self:skinStdButton{obj=ahf.AuctionsFrame.BuyoutFrame.BuyoutButton, fType=ftype, sechk=true}
				self:skinStdButton{obj=ahf.AuctionsFrame.BidFrame.BidButton, fType=ftype, sechk=true}
			end
			-- Dialogs
			self:skinObject("frame", {obj=ahf.BuyDialog.Border, fType=ftype, kfs=true, ofs=-10})
			if self.modBtns then
				self:skinStdButton{obj=ahf.BuyDialog.BuyNowButton, fType=ftype, sechk=true}
				self:skinStdButton{obj=ahf.BuyDialog.CancelButton, fType=ftype, sechk=true}
			end

		end

		self.RegisterCallback("AuctionHouseUI", "Auction_House_Show", function(_)
			skinAuctionHouseFrames()
		end)

	end

	aObj.blizzLoDFrames[ftype].AzeriteRespecUI = function(self)
		if not self.prdb.AzeriteRespecUI or self.initialized.AzeriteRespecUI then return end
		self.initialized.AzeriteRespecUI = true

		self:SecureHookScript(_G.AzeriteRespecFrame, "OnShow", function(this)
			self.modUIBtns:addButtonBorder{obj=this.ItemSlot, clr="grey"} -- use module function
			this.ButtonFrame:DisableDrawLayer("BORDER")
			self:removeMagicBtnTex(this.ButtonFrame.AzeriteRespecButton)
			this.ButtonFrame.MoneyFrameEdge:DisableDrawLayer("BACKGROUND")
			this.ButtonFrame.AzeriteRespecButton:SetPoint("BOTTOMRIGHT", -6, 5)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true})
			if self.modBtns then
				self:skinStdButton{obj=this.ButtonFrame.AzeriteRespecButton}
				self:SecureHook(this, "UpdateAzeriteRespecButtonState", function(fObj)
					self:clrBtnBdr(fObj.ButtonFrame.AzeriteRespecButton)
				end)
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].BankFrame = function(self)
		if not self.prdb.BankFrame or self.initialized.BankFrame then return end
		self.initialized.BankFrame = true

		self:SecureHookScript(_G.BankFrame, "OnShow", function(this)
			self:skinObject("editbox", {obj=_G.BankItemSearchBox, fType=ftype, si=true})
			if self.modBtns then
				 self:skinStdButton{obj=_G.BankFramePurchaseButton}
			end
			self:removeInset(_G.BankFrameMoneyFrameInset)
			_G.BankFrameMoneyFrameBorder:DisableDrawLayer("BACKGROUND")
			self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, offsets={x1=8, y1=self.isTT and 2 or 0, x2=-8, y2=2}})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, rns=true, cb=true})
			self:keepFontStrings(_G.BankSlotsFrame)
			if self.modBtnBs then
				self:SecureHook("BankFrameItemButton_Update", function(btn)
					if btn.sbb -- ReagentBank buttons may not be skinned yet
					and not btn.hasItem then
						self:clrBtnBdr(btn, "grey")
					end
				end)
				self:addButtonBorder{obj=_G.BankItemAutoSortButton, ofs=0, y1=1, clr="grey"}
				-- add button borders to bank items
				for i = 1, _G.NUM_BANKGENERIC_SLOTS do
					self:addButtonBorder{obj=_G.BankSlotsFrame["Item" .. i], ibt=true, reParent={_G["BankFrameItem" .. i].IconQuestTexture}}
					-- force quality border update
					_G.BankFrameItemButton_Update(_G.BankSlotsFrame["Item" .. i])
				end
				self:SecureHook("UpdateBagSlotStatus", function()
					for i = 1, _G.NUM_BANKBAGSLOTS do
						_G.BankSlotsFrame["Bag" .. i].sbb:SetBackdropBorderColor(_G.BankSlotsFrame["Bag" .. i].icon:GetVertexColor())
					end
				end)
				-- add button borders to bags
				for i = 1, _G.NUM_BANKBAGSLOTS do
					self:addButtonBorder{obj=_G.BankSlotsFrame["Bag" .. i], ibt=true}
				end
				-- colour button borders
				_G.UpdateBagSlotStatus()
			end
			-- ReagentBankFrame
			_G.ReagentBankFrame:DisableDrawLayer("ARTWORK") -- bank slots texture
			_G.ReagentBankFrame:DisableDrawLayer("BACKGROUND") -- bank slots shadow texture
			_G.ReagentBankFrame:DisableDrawLayer("BORDER") -- shadow textures
			_G.ReagentBankFrame.UnlockInfo:DisableDrawLayer("BORDER")
			_G.RaiseFrameLevelByTwo(_G.ReagentBankFrame.UnlockInfo) -- hide the slot button textures
			if self.modBtns then
				self:skinStdButton{obj=_G.ReagentBankFrameUnlockInfoPurchaseButton, fType=ftype}
				self:skinStdButton{obj=_G.ReagentBankFrame.DespositButton, fType=ftype, schk=true}
			end
			if self.modBtnBs then
				-- add button borders to reagent bank items
				self:SecureHookScript(_G.ReagentBankFrame, "OnShow", function(fObj)
					for i = 1, fObj.size do
						self:addButtonBorder{obj=fObj["Item" .. i], ibt=true, reParent={fObj["Item" .. i].IconQuestTexture}}
						-- force quality border update
						_G.BankFrameItemButton_Update(fObj["Item" .. i])
					end

					self:Unhook(fObj, "OnShow")
				end)
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzLoDFrames[ftype].BlackMarketUI = function(self)
		if not self.prdb.BlackMarketUI or self.initialized.BlackMarketUI then return end
		self.initialized.BlackMarketUI = true

		self:SecureHookScript(_G.BlackMarketFrame, "OnShow", function(this)
			-- move title text
			self:moveObject{obj=self:getRegion(this, 22), y=-4}
			-- column headings
			for _, type in _G.pairs{"Name", "Level", "Type", "Duration", "HighBidder", "CurrentBid"} do
				self:skinObject("frame", {obj=this["Column" .. type], fType=ftype, kfs=true, bd=5, ofs=0})
			end
			self:skinObject("slider", {obj=_G.BlackMarketScrollFrameScrollBar, fType=ftype})
			this.MoneyFrameBorder:DisableDrawLayer("BACKGROUND")
			self:skinObject("moneyframe", {obj=_G.BlackMarketBidPrice})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, cb=true, x2=1})
			if self.modBtns then
				self:skinStdButton{obj=this.BidButton}
			end
			-- HotDeal frame
			self:keepFontStrings(this.HotDeal)
			if self.modBtnBs then
				self:addButtonBorder{obj=this.HotDeal.Item, reParent={this.HotDeal.Item.Count, this.HotDeal.Item.Stock}}
			end

			local function skinSFButtons(scrollFrame)
				for _, btn in _G.pairs(scrollFrame.buttons) do
					aObj:removeRegions(btn, {1, 2, 3})
					btn.Item:GetNormalTexture():SetTexture(nil)
					btn.Item:GetPushedTexture():SetTexture(nil)
					if aObj.modBtnBs then
						aObj:addButtonBorder{obj=btn.Item, reParent={btn.Item.Count, btn.Item.Stock}}
						aObj:clrButtonFromBorder(btn.Item)
					end
				end
			end
			self:SecureHook("BlackMarketScrollFrame_Update", function()
				skinSFButtons(_G.BlackMarketScrollFrame)
			end)

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzLoDFrames[ftype].ChromieTimeUI = function(self)
		if not self.prdb.ChromieTimeUI or self.initialized.ChromieTimeUI then return end
		self.initialized.ChromieTimeUI = true

		self:SecureHookScript(_G.ChromieTimeFrame, "OnShow", function(this)
			this.Background:DisableDrawLayer("BACKGROUND")
			self:keepFontStrings(this.Title)
			this.CloseButton.Border:SetTexture(nil)
			this.CurrentlySelectedExpansionInfoFrame:DisableDrawLayer("BACKGROUND")
			this.CurrentlySelectedExpansionInfoFrame:DisableDrawLayer("ARTWORK")
			this.CurrentlySelectedExpansionInfoFrame.Name:SetTextColor(self.HT:GetRGB())
			this.CurrentlySelectedExpansionInfoFrame.Description:SetTextColor(self.BT:GetRGB())
			for btn in this.ExpansionOptionsPool:EnumerateActive() do
				btn:GetNormalTexture():SetTexture(nil) -- remove border texture
				self:SecureHook(btn, "SetNormalAtlas", function(bObj, name, _)
					if name == "ChromieTime-Button-Frame" then
						bObj:GetNormalTexture():SetTexture(nil) -- remove border texture
					end
				end)
				if self.modBtnBs then
					self:addButtonBorder{obj=btn, ofs=-4, es=20, clr="gold", ca=0.4}
				end
			end
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, rns=true, cb=true, ofs=0, y1=-1})
			if self.modBtns then
				self:skinStdButton{obj=this.SelectButton}
				self:SecureHook(this.SelectButton, "UpdateButtonState", function(bObj, _)
					self:clrBtnBdr(bObj)
				end)
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzLoDFrames[ftype].CovenantPreviewUI = function(self)
		if not self.prdb.CovenantPreviewUI or self.initialized.CovenantPreviewUI then return end
		self.initialized.CovenantPreviewUI = true

		self:SecureHook(_G.CovenantPreviewFrame, "SetupFramesWithTextureKit", function(this)
			if this.sf then
				self:clrCovenantBdr(this.ModelSceneContainer, this.uiTextureKit)
				self:clrCovenantBdr(this, this.uiTextureKit)
			end
		end)

		self:SecureHookScript(_G.CovenantPreviewFrame, "OnShow", function(this)
			this.BorderFrame:DisableDrawLayer("BORDER")
			this.Background.BackgroundTile:SetTexture(nil)
			this.Title:DisableDrawLayer("BACKGROUND")
			this.ModelSceneContainer.ModelSceneBorder:SetTexture(nil)
			self:skinObject("frame", {obj=this.ModelSceneContainer, fType=ftype, fb=true})
			self:clrCovenantBdr(this.ModelSceneContainer, this.uiTextureKit)
			_G.RaiseFrameLevelByTwo(this.ModelSceneContainer.sf) -- make sure it covers border of background
			this.ModelSceneContainer.Background:SetAlpha(1) -- make it visible
			this.InfoPanel:DisableDrawLayer("BACKGROUND")
			this.InfoPanel.Name:SetTextColor(self.HT:GetRGB())
			this.InfoPanel.Location:SetTextColor(self.BT:GetRGB())
			this.InfoPanel.Description:SetTextColor(self.BT:GetRGB())
			this.InfoPanel.AbilitiesFrame.AbilitiesLabel:SetTextColor(self.HT:GetRGB())
			self:nilTexture(this.InfoPanel.AbilitiesFrame.Border, true)
			this.InfoPanel.SoulbindsFrame.SoulbindsLabel:SetTextColor(self.HT:GetRGB())
			this.InfoPanel.CovenantFeatureFrame.Label:SetTextColor(self.HT:GetRGB())
			self:nilTexture(this.InfoPanel.CovenantFeatureFrame.CovenantFeatureButton:GetNormalTexture(), true)
			for btn in this.AbilityButtonsPool:EnumerateActive() do
				btn.IconBorder:SetTexture(nil)
				if self.modBtnBs then
					self:addButtonBorder{obj=btn, ofs=3.5, clr="white"}
				end
			end
			for btn in this.SoulbindButtonsPool:EnumerateActive() do
				btn.Border:SetTexture(nil)
				if self.modBtnBs then
					self:addButtonBorder{obj=btn, ofs=-8, clr="grey"}
				end
			end
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true})
			self:clrCovenantBdr(this, this.uiTextureKit)
			if self.modBtns then
				self:skinCloseButton{obj=this.CloseButton, noSkin=true}
				self:skinStdButton{obj=this.SelectButton}

			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzLoDFrames[ftype].CovenantRenown = function(self)
		if not self.prdb.CovenantRenown or self.initialized.CovenantRenown then return end
		self.initialized.CovenantRenown = true

		self:SecureHook(_G.CovenantRenownFrame, "SetUpCovenantData", function(this)
			if this.sf then
				self:clrCovenantBdr(this)
			end
		end)

		local function skinRewards(frame)
			for reward in frame.rewardsPool:EnumerateActive() do
				aObj:skinObject("frame", {obj=reward, fType=ftype, kfs=true, fb=true, ofs=-14, clr="sepia"})
				reward.Check:SetAlpha(1) -- make Checkmark visible
				reward.Icon:SetAlpha(1) -- make Icon visible
			end
		end
		self:SecureHookScript(_G.CovenantRenownFrame, "OnShow", function(this)
			this.HeaderFrame.Background:SetTexture(nil)
			self:moveObject{obj=this.HeaderFrame, y=-6}
			-- .CelebrationModelScene
			-- .TrackFrame
				-- N.B. the level background is part of the border atlas and CANNOT be changed ;(
			-- .FinalToast
			-- .FinalToast.IconSwirlModelScene
			-- .FinalToast.SlabTexture
			self:SecureHook(this, "SetRewards", function(fObj, _)
				skinRewards(fObj)
			end)
			skinRewards(this)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, rns=true, cbns=true, ofs=0})
			self:clrCovenantBdr(this)

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzLoDFrames[ftype].CovenantSanctum = function(self)
		if not self.prdb.CovenantSanctum or self.initialized.CovenantSanctum then return end
		self.initialized.CovenantSanctum = true

		self:SecureHookScript(_G.CovenantSanctumFrame, "OnShow", function(this)
			this.LevelFrame.Background:SetTexture(nil)
			local list = this.UpgradesTab.TalentsList
			list:DisableDrawLayer("BACKGROUND")
			list:DisableDrawLayer("BORDER")
			list.IntroBox:DisableDrawLayer("BORDER")
			local function skinTalents(tList)
				for talentFrame in tList.talentPool:EnumerateActive() do
					aObj:removeRegions(talentFrame, {1, 2})
					if talentFrame.TierBorder then
						aObj:changeTandC(talentFrame.TierBorder)
					end
					aObj:skinObject("frame", {obj=talentFrame, fType=ftype, ofs=2.5, y2=-2, clr="gold"})
					if aObj.modBtnBs then
						aObj:addButtonBorder{obj=talentFrame, relTo=talentFrame.Icon, reParent={talentFrame.TierBorder}}
						aObj:clrBtnBdr(talentFrame, talentFrame.Icon:IsDesaturated() and "disabled" or "gold")
					end
				end
			end
			-- hook this as the talentPool is released and refilled
			self:SecureHook(list, "Refresh", function(fObj)
				skinTalents(fObj)
				if self.modBtns then
					self:clrBtnBdr(fObj.UpgradeButton, "sepia")
				end
			end)
			skinTalents(list)
			for _, frame in _G.pairs(this.UpgradesTab.Upgrades) do
				if frame.Border then
					self:nilTexture(frame.Border, true)
				end
				if frame.TierBorder then
					self:changeTandC(frame.TierBorder)
				end
			end
			this.UpgradesTab.CurrencyBackground:SetTexture(nil)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, rns=true, cbns=true, ofs=-3})
			self:clrCovenantBdr(this)
			if self.modBtns then
				self:skinStdButton{obj=this.UpgradesTab.TalentsList.UpgradeButton, fType=ftype}
				self:skinStdButton{obj=this.UpgradesTab.DepositButton, fType=ftype}
				self:SecureHook(this.UpgradesTab, "UpdateDepositButton", function(fObj)
					self:clrBtnBdr(fObj.DepositButton)
				end)
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHook(_G.CovenantSanctumFrame, "SetCovenantInfo", function(this)
			if this.sf then
				self:clrCovenantBdr(this)
			end
		end)

	end

	aObj.blizzLoDFrames[ftype].FlightMap = function(self)
		if not self.prdb.FlightMap or self.initialized.FlightMap then return end
		self.initialized.FlightMap = true

		self:skinObject("frame", {obj=_G.FlightMapFrame.BorderFrame, fType=ftype, kfs=true, rns=true, cb=true, ofs=3, y1=2})
		_G.FlightMapFrame.BorderFrame.sf:SetFrameStrata("LOW") -- allow map textures to be visible

		-- remove ZoneLabel background texture
		for dP, _ in _G.pairs(_G.FlightMapFrame.dataProviders) do
			if dP.ZoneLabel then
				dP.ZoneLabel.TextBackground:SetTexture(nil)
				dP.ZoneLabel.TextBackground.SetTexture = _G.nop
				break
			end
		end

	end

	aObj.blizzLoDFrames[ftype].ItemInteractionUI = function(self) -- a.k.a. Titanic Purification/Runecarver reclaim soulessence/Creation Catalyst
		if not self.prdb.ItemInteractionUI or self.initialized.ItemInteractionUI then return end
		self.initialized.ItemInteractionUI = true

		self:SecureHookScript(_G.ItemInteractionFrame, "OnShow", function(this)
			-- use module to make button slot visible
			self.modUIBtns:addButtonBorder{obj=this.ItemSlot, relTo=this.ItemSlot.Icon, clr="grey"}
			this.ItemConversionFrame.ItemConversionInputSlot.ButtonFrame:SetAlpha(0) -- N.B. Texture changed in code
			this.ButtonFrame:DisableDrawLayer("BORDER")
			this.ButtonFrame.MoneyFrameEdge:DisableDrawLayer("BACKGROUND")
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, cb=true, x2=3})
			if self.modBtns then
				self:skinStdButton{obj=this.ButtonFrame.ActionButton}
				self:SecureHook(this, "UpdateActionButtonState", function(fObj)
					self:clrBtnBdr(fObj.ButtonFrame.ActionButton)
				end)
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzLoDFrames[ftype].ItemUpgradeUI = function(self)
		if not self.prdb.ItemUpgradeUI or self.initialized.ItemUpgradeUI then return end
		self.initialized.ItemUpgradeUI = true

		self:SecureHookScript(_G.ItemUpgradeFrame, "OnShow", function(this)
			this.UpgradeItemButton.ButtonFrame:SetTexture(nil)
			self:skinObject("dropdown", {obj=this.ItemInfo.Dropdown, fType=ftype})
			self:skinObject("frame", {obj=this.LeftItemPreviewFrame, fType=ftype, fb=true, clr="grey"})
			self:skinObject("frame", {obj=this.RightItemPreviewFrame, fType=ftype, fb=true, clr="grey"})
			this.PlayerCurrenciesBorder:DisableDrawLayer("background")
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true, x2=3})
			if self.modBtns then
				self:skinStdButton{obj=this.UpgradeButton, fType=ftype}
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=this.UpgradeItemButton, fType=ftype}
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzLoDFrames[ftype].NewPlayerExperienceGuide = function(self)
		if not self.prdb.NewPlayerExperienceGuide or self.initialized.NewPlayerExperienceGuide then return end
		self.initialized.NewPlayerExperienceGuide = true

		self:SecureHookScript(_G.GuideFrame, "OnShow", function(this)
			this:DisableDrawLayer("BACKGROUND")
			this.Title:SetTextColor(self.HT:GetRGB())
			this.ScrollFrame.Child.Text:SetTextColor(self.BT:GetRGB())
			this.ScrollFrame.Child.ObjectivesFrame:DisableDrawLayer("BORDER")
			this.ScrollFrame.Child.ObjectivesFrame:DisableDrawLayer("BACKGROUND")
			self:removeNineSlice(this.ScrollFrame.ScrollBar.ScrollUpBorder.NineSlice)
			self:removeNineSlice(this.ScrollFrame.ScrollBar.ScrollDownBorder.NineSlice)
			self:removeNineSlice(this.ScrollFrame.ScrollBar.Border.NineSlice)
			self:skinObject("slider", {obj=this.ScrollFrame.ScrollBar, fType=ftype})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, rns=true, cb=true})
			if self.modBtns then
				self:skinStdButton{obj=this.ScrollFrame.ConfirmationButton}
				self:SecureHook(this, "SetStateInternal", function(fObj)
					self:clrBtnBdr(fObj.ScrollFrame.ConfirmationButton)
				end)
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].PetStableFrame = function(self)
		if not self.prdb.PetStableFrame or self.initialized.PetStableFrame then return end
		self.initialized.PetStableFrame = true

		self:SecureHookScript(_G.PetStableFrame, "OnShow", function(this)
			_G.PetStableFrameModelBg:Hide()
			self:removeInset(this.LeftInset)
			self:removeInset(this.BottomInset)
			_G.PetStableActiveBg:Hide()
			_G.PetStableFrameStableBg:Hide()
			self:makeMFRotatable(_G.PetStableModel)
			_G.PetStableModelShadow:Hide()
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true})
			if self.modBtnBs then
				self:addButtonBorder{obj=_G.PetStablePetInfo, relTo=_G.PetStableSelectedPetIcon, clr="grey", ca=0.85}
				self:addButtonBorder{obj=_G.PetStableDiet, ofs=1, x2=0, clr="gold"}
				self:addButtonBorder{obj=_G.PetStableNextPageButton, ofs=0, clr="grey"}
				self:addButtonBorder{obj=_G.PetStablePrevPageButton, ofs=0, clr="grey"}
				self:SecureHook("PetStable_Update", function(_)
					self:clrBtnBdr(_G.PetStableNextPageButton, "gold")
					self:clrBtnBdr(_G.PetStablePrevPageButton, "gold")
				end)
			end
			-- slots
			for i = 1, _G.NUM_PET_ACTIVE_SLOTS do
				_G["PetStableActivePet" .. i].Border:Hide()
				if not self.modBtnBs then
					self:resizeEmptyTexture(_G["PetStableActivePet" .. i].Background)
				else
					_G["PetStableActivePet" .. i].Background:Hide()
					self:addButtonBorder{obj=_G["PetStableActivePet" .. i], clr="gold"}
				end
			end
			for i = 1, _G.NUM_PET_STABLE_SLOTS do
				if not self.modBtnBs then
					self:resizeEmptyTexture(_G["PetStableStabledPet" .. i].Background)
				else
					_G["PetStableStabledPet" .. i].Background:Hide()
					self:addButtonBorder{obj=_G["PetStableStabledPet" .. i], clr="grey", ca=0.85}
				end
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzLoDFrames[ftype].RuneForgeUI = function(self)
		if not self.prdb.RuneForgeUI or self.initialized.RuneForgeUI then return end
		self.initialized.RuneForgeUI = true

		self:SecureHookScript(_G.RuneforgeFrame, "OnShow", function(this)
			self:skinObject("frame", {obj=this.CraftingFrame.ModifierFrame.Selector, fType=ftype, kfs=true, ofs=-10, y1=-20, y2=20})
			self:skinObject("frame", {obj=this.CraftingFrame.PowerFrame, fType=ftype, kfs=true, ofs=0, y1=-10, y2=10})
			this.BackgroundModelScene:Hide()
			self:removeBackdrop(this.ResultTooltip.PulseOverlay)
			this.CloseButton.CustomBorder:SetTexture(nil)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cbns=true, ofs=-40, y1=-75, y2=100})
			if self.modBtns then
				self:skinStdButton{obj=this.CreateFrame.CraftItemButton}
				self:SecureHook(this.CreateFrame.CraftItemButton, "SetCraftState", function(bObj, _)
					self:clrBtnBdr(bObj)
				end)
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=this.CraftingFrame.PowerFrame.PageControl.BackwardButton, clr="gold", ofs=-2, y1=-3, x2=-3}
				self:addButtonBorder{obj=this.CraftingFrame.PowerFrame.PageControl.ForwardButton, clr="gold", ofs=-2, y1=-3, x2=-3}
				self:SecureHook(this.CraftingFrame.PowerFrame.PageControl, "RefreshPaging", function(fObj)
					self:clrBtnBdr(fObj.BackwardButton, "gold")
					self:clrBtnBdr(fObj.ForwardButton, "gold")
				end)
			end

			_G.C_Timer.After(0.1, function()
				self:add2Table(self.ttList, this.ResultTooltip)
				this.ResultTooltip.TopOverlay:SetAlpha(1)
			end)

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].TaxiFrame = function(self)
		if not self.prdb.TaxiFrame or self.initialized.TaxiFrame then return end
		self.initialized.TaxiFrame = true

		self:SecureHookScript(_G.TaxiFrame, "OnShow", function(this)
			this:DisableDrawLayer("BORDER")
			self:removeRegions(this, {1, 2, 3}) -- 1st 3 overlay textures
			-- resize map to fit skin frame
			this.InsetBg:SetPoint("TOPLEFT", 0, -24)
			this.InsetBg:SetPoint("BOTTOMRIGHT", 0 ,0)
			self:skinObject("frame", {obj=this, fType=ftype, cb=true})

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzLoDFrames[ftype].TrainerUI = function(self)
		if not self.prdb.TrainerUI or self.initialized.TrainerUI then return end
		self.initialized.TrainerUI = true

		self:SecureHookScript(_G.ClassTrainerFrame, "OnShow", function(this)
			_G.ClassTrainerStatusBarLeft:SetAlpha(0)
			_G.ClassTrainerStatusBarRight:SetAlpha(0)
			_G.ClassTrainerStatusBarMiddle:SetAlpha(0)
			_G.ClassTrainerStatusBarSkillRank:SetPoint("CENTER", _G.ClassTrainerStatusBar) -- Blizzard bug
			self:skinObject("statusbar", {obj=_G.ClassTrainerStatusBar, fi=0, bg=_G.ClassTrainerStatusBarBackground})
			self:skinObject("dropdown", {obj=_G.ClassTrainerFrameFilterDropDown, fType=ftype})
			self:removeMagicBtnTex(_G.ClassTrainerTrainButton)
			this.skillStepButton:GetNormalTexture():SetTexture(nil)
			self:skinObject("slider", {obj=_G.ClassTrainerScrollFrameScrollBar, fType=ftype})
			for _, btn in _G.pairs(this.scrollFrame.buttons) do
				btn:GetNormalTexture():SetTexture(nil)
				if self.modBtnBs then
					self:addButtonBorder{obj=btn, relTo=btn.icon}
				end
			end
			self:removeInset(this.bottomInset)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true})
			if self.modBtns then
				self:skinStdButton{obj=_G.ClassTrainerTrainButton, fType=ftype, schk=true}
			end
			if self.modBtnBs then
				 self:addButtonBorder{obj=this.skillStepButton, relTo=this.skillStepButton.icon}
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzLoDFrames[ftype].VoidStorageUI = function(self)
		if not self.prdb.VoidStorageUI or self.initialized.VoidStorageUI then return end
		self.initialized.VoidStorageUI = true

		self:SecureHookScript(_G.VoidStorageFrame, "OnShow", function(this)
			for _, type in _G.pairs{"Deposit", "Withdraw", "Storage", "Cost"} do
				self:removeNineSlice(_G["VoidStorage" .. type .. "Frame"].NineSlice)
				_G["VoidStorage" .. type .. "Frame"]:DisableDrawLayer("BACKGROUND")
			end
			self:keepFontStrings(_G.VoidStorageBorderFrame)
			self:skinObject("editbox", {obj=_G.VoidItemSearchBox, fType=ftype, si=true})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, x2=1})
			if self.modBtns then
				self:skinStdButton{obj=_G.VoidStorageTransferButton, fType=ftype, schk=true}
				self:skinCloseButton{obj=_G.VoidStorageBorderFrame.CloseButton, fType=ftype}
				self:skinStdButton{obj=_G.VoidStoragePurchaseButton, fType=ftype}
				self:SecureHook("VoidStorageFrame_Update", function()
					self:clrBtnBdr(_G.VoidStoragePurchaseButton)
				end)
			end
			if self.modBtnBs then
				for i = 1, 9 do
					self:addButtonBorder{obj=_G["VoidStorageDepositButton" .. i], fType=ftype, clr="grey"}
					self:addButtonBorder{obj=_G["VoidStorageWithdrawButton" .. i], fType=ftype, clr="grey"}
				end
				for i = 1, 80 do
					self:addButtonBorder{obj=_G["VoidStorageStorageButton" .. i], fType=ftype, clr="grey"}
				end
			end
			self:skinObject("frame", {obj=_G.VoidStoragePurchaseFrame, fType=ftype, kfs=true, ofs=0})
			-- Tabs
			for i = 1, 2 do
				_G.VoidStorageFrame["Page" .. i]:DisableDrawLayer("BACKGROUND")
				if self.modBtns then
					self:addButtonBorder{obj=_G.VoidStorageFrame["Page" .. i]}
				end
			end

			self:Unhook(this, "OnShow")
		end)

	end

end

aObj.SetupRetail_NPCFramesOptions = function(self)

	local optTab = {
		["Allied Races UI"]             = true,
		["Auction House UI"]            = true,
		["Azerite Respec UI"]           = true,
		["Black Market UI"]             = true,
		["Chromie Time UI"]             = true,
		["Covenant Preview UI"]         = true,
		["Covenant Renown"]             = true,
		["Covenant Sanctum"]            = true,
		["Flight Map"]                  = true,
		["Item Interaction UI"]         = true,
		["Item Upgrade UI"]             = true,
		["New Player Experience Guide"] = {suff = "Frame"},
		["Rune Forge UI"]               = true,
		["Void Storage UI"]             = true,
	}
	self:setupFramesOptions(optTab, "NPC")
	_G.wipe(optTab)

end
