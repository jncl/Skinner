local _, aObj = ...

local _G = _G

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
		self:skinSlider{obj=this.RaceInfoFrame.ScrollFrame.ScrollBar, rt="background", wdth=-5}
		this.RaceInfoFrame.ScrollFrame.ScrollBar.ScrollUpBorder:ClearBackdrop()
		this.RaceInfoFrame.ScrollFrame.ScrollBar.ScrollDownBorder:ClearBackdrop()
		this.RaceInfoFrame.ScrollFrame.ScrollBar.Border:ClearBackdrop()
		this.RaceInfoFrame.AlliedRacesRaceName:SetTextColor(self.HT:GetRGB())
		self:addSkinFrame{obj=this, ft=ftype, kfs=true}
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

	self:SecureHookScript(_G.AuctionHouseFrame, "OnShow", function(this)
		local function skinItemList(frame)
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=frame.RefreshFrame.RefreshButton, ofs=-2, x1=1, clr="gold"}
			end
			aObj:removeNineSlice(frame.NineSlice)
			frame.Background:SetTexture(nil)
			aObj:skinSlider{obj=frame.ScrollFrame.scrollBar, rt="background", wdth=-5}
			aObj:SecureHook(frame, "RefreshScrollFrame", function(this)
				if this.tableBuilder then
					for hdr in this.tableBuilder.headerPoolCollection:EnumerateActive() do
						aObj:removeRegions(hdr, {1, 2, 3})
						aObj:addSkinFrame{obj=hdr, ft=ftype, nb=true, ofs=1}
					end
				end
			end)
		end
		local function skinBidAmt(frame)
			aObj:skinEditBox{obj=frame.gold, regs={6, 7}, noHeight=true, noWidth=true} -- 6 is text, 7 is icon
			aObj:skinEditBox{obj=frame.silver, regs={6, 7}, noHeight=true, noWidth=true} -- 6 is text, 7 is icon
			frame.silver:SetWidth(38)
			aObj:moveObject{obj=frame.silver.texture, x=10}
			aObj:skinEditBox{obj=frame.copper, regs={6, 7}, noHeight=true, noWidth=true} -- 6 is text, 7 is icon
			frame.copper:SetWidth(38)
			aObj:moveObject{obj=frame.copper.texture, x=10}
		end
		self:removeNineSlice(this.NineSlice)
		self:removeInset(self:getChild(this, 3)) -- MerchantMoneyInset
		this.MoneyFrameBorder:DisableDrawLayer("BACKGROUND")
		this.MoneyFrameBorder:DisableDrawLayer("BORDER")
		-- .FavoriteDropDown ?
		if self.modBtnBs then
			self:addButtonBorder{obj=this.SearchBar.FavoritesSearchButton, ofs=-2, x1=1}
		end
		-- Browsing frames
		self:skinEditBox{obj=this.SearchBar.SearchBox, regs={6, 7}, mi=true} -- 6 is text, 7 is icon
		self:skinEditBox{obj=this.SearchBar.FilterButton.LevelRangeFrame.MinLevel, regs={6}} -- 6 is text
		self:skinEditBox{obj=this.SearchBar.FilterButton.LevelRangeFrame.MaxLevel, regs={6}, x=-5} -- 6 is text
		if self.modBtns then
			self:skinStdButton{obj=this.SearchBar.FilterButton}
			self:skinStdButton{obj=this.SearchBar.SearchButton}
		end
		this.CategoriesList:DisableDrawLayer("BACKGROUND")
		self:removeNineSlice(this.CategoriesList.NineSlice)
		for i = 1, _G.NUM_FILTERS_TO_DISPLAY do
			self:keepRegions(this.CategoriesList.FilterButtons[i], {3, 4, 5}) -- N.B. region 3 is highlight, 4 is selected, 5 is text
			self:addSkinFrame{obj=this.CategoriesList.FilterButtons[i], ft=ftype, nb=true, aso={bd=5}, y2=-1}
		end
		self:SecureHook("FilterButton_SetUp", function(button, _)
			button.NormalTexture:SetAlpha(0)
		end)
		self:skinSlider{obj=this.CategoriesList.ScrollFrame.ScrollBar, rt="border"}
		this.CategoriesList.ScrollFrame:DisableDrawLayer("BACKGROUND")
		this.CategoriesList.Background:SetTexture(nil)
		skinItemList(this.BrowseResultsFrame.ItemList)
		this.WoWTokenResults.Background:SetTexture(nil)
		self:removeNineSlice(this.WoWTokenResults.NineSlice)
		self:SecureHookScript(this.WoWTokenResults.GameTimeTutorial, "OnShow", function(this)
			self:removeInset(this.Inset)
			this.LeftDisplay.Label:SetTextColor(self.HT:GetRGB())
			this.LeftDisplay.Tutorial1:SetTextColor(self.BT:GetRGB())
			this.RightDisplay.Label:SetTextColor(self.HT:GetRGB())
			this.RightDisplay.Tutorial1:SetTextColor(self.BT:GetRGB())
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, y2=220}
			if self.modBtns then
				self:skinStdButton{obj=this.RightDisplay.StoreButton, x1=14, y1=2, x2=-14, y2=2, clr="gold"}
			end

			self:Unhook(this, "OnShow")
		end)
		self:removeRegions(this.WoWTokenResults.TokenDisplay, {3}) -- background texture
		local btn = this.WoWTokenResults.TokenDisplay.ItemButton
		btn.IconBorder:SetTexture(nil)
		if self.modBtnBs then
			self:addButtonBorder{obj=btn, relTo=btn.Icon, reParent={btn.Count}}
			self:clrButtonFromBorder(btn)
		end
		btn = nil
		if self.modBtns then
			self:skinStdButton{obj=this.WoWTokenResults.Buyout}
			self:SecureHook(this.WoWTokenResults.Buyout, "SetEnabled", function(this)
				self:clrBtnBdr(this)
			end)
		end
		this.WoWTokenResults.DummyScrollBar:DisableDrawLayer("BACKGROUND")
		this.WoWTokenResults.DummyScrollBar:DisableDrawLayer("ARTWORK")
		-- Buy frames
		self:removeNineSlice(this.CommoditiesBuyFrame.BuyDisplay.NineSlice)
		this.CommoditiesBuyFrame.BuyDisplay.Background:SetTexture(nil)
		self:removeRegions(this.CommoditiesBuyFrame.BuyDisplay.ItemDisplay, {3})
		self:skinEditBox{obj=this.CommoditiesBuyFrame.BuyDisplay.QuantityInput.InputBox, regs={6}} -- 6 is text
		if self.modBtns then
			self:skinStdButton{obj=this.CommoditiesBuyFrame.BackButton}
			self:skinStdButton{obj=this.CommoditiesBuyFrame.BuyDisplay.QuantityInput.MaxButton}
			self:skinStdButton{obj=this.CommoditiesBuyFrame.BuyDisplay.BuyButton}
			self:SecureHook(this.CommoditiesBuyFrame.BuyDisplay.BuyButton, "SetEnabled", function(this)
				self:clrBtnBdr(this)
			end)
		end
		skinItemList(this.CommoditiesBuyFrame.ItemList)
		self:removeNineSlice(this.ItemBuyFrame.ItemDisplay.NineSlice)
		self:removeRegions(this.ItemBuyFrame.ItemDisplay, {1})
		skinBidAmt(this.ItemBuyFrame.BidFrame.BidAmount)
		skinItemList(this.ItemBuyFrame.ItemList)
		if self.modBtns then
			self:skinStdButton{obj=this.ItemBuyFrame.BackButton}
			self:skinStdButton{obj=this.ItemBuyFrame.BuyoutFrame.BuyoutButton}
			self:SecureHook(this.ItemBuyFrame.BuyoutFrame.BuyoutButton, "SetEnabled", function(this)
				self:clrBtnBdr(this)
			end)
			self:skinStdButton{obj=this.ItemBuyFrame.BidFrame.BidButton}
			self:SecureHook(this.ItemBuyFrame.BidFrame.BidButton, "SetEnabled", function(this)
				self:clrBtnBdr(this)
			end)
		end
		-- Sell frames
		local function skinPriceInp(frame)
			aObj:skinEditBox{obj=frame.CopperBox, regs={6}, noHeight=true, noWidth=true} -- 6 is text
			aObj:skinEditBox{obj=frame.SilverBox, regs={6}, noHeight=true, noWidth=true} -- 6 is text
			aObj:skinEditBox{obj=frame.GoldBox, regs={6}, noHeight=true, noWidth=true} -- 6 is text
		end
		local function skinSellFrame(frame)
			aObj:removeNineSlice(frame.NineSlice)
			frame.Background:SetTexture(nil)
			aObj:keepFontStrings(frame)
			aObj:removeNineSlice(frame.ItemDisplay.NineSlice)
			aObj:removeRegions(frame.ItemDisplay, {3})
			aObj:skinEditBox{obj=frame.QuantityInput.InputBox, regs={6}, noHeight=true, noWidth=true} -- 6 is text
			skinPriceInp(frame.PriceInput.MoneyInputFrame)
			aObj:skinDropDown{obj=frame.DurationDropDown.DropDown, lrg=true, x1=0, y1=1, x2=-1, y2=3}
			if aObj.modBtns then
				aObj:skinStdButton{obj=frame.QuantityInput.MaxButton}
				aObj:skinStdButton{obj=frame.PostButton}
				self:SecureHook(frame.PostButton, "SetEnabled", function(this)
					self:clrBtnBdr(this)
				end)
			end
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=frame.ItemDisplay.ItemButton, gibt=true}
			end
		end
		skinSellFrame(this.ItemSellFrame)
		if self.modChkBtns then
			self:skinCheckButton{obj=this.ItemSellFrame.BuyoutModeCheckButton}
		end
		skinPriceInp(this.ItemSellFrame.SecondaryPriceInput.MoneyInputFrame)
		skinItemList(this.ItemSellList)
		skinSellFrame(this.CommoditiesSellFrame)
		skinItemList(this.CommoditiesSellList)
		-- .WoWTokenSellFrame
		self:removeNineSlice(this.WoWTokenSellFrame.ItemDisplay.NineSlice)
		self:removeRegions(this.WoWTokenSellFrame.ItemDisplay, {3})
		self:removeNineSlice(this.WoWTokenSellFrame.DummyItemList.NineSlice)
		this.WoWTokenSellFrame.DummyItemList.Background:SetTexture(nil)
		this.WoWTokenSellFrame.DummyItemList.DummyScrollBar:DisableDrawLayer("BACKGROUND")
		this.WoWTokenSellFrame.DummyItemList.DummyScrollBar:DisableDrawLayer("ARTWORK")
		if self.modBtns then
			self:skinStdButton{obj=this.WoWTokenSellFrame.PostButton}
			self:SecureHook(this.WoWTokenSellFrame.PostButton, "SetEnabled", function(this)
				self:clrBtnBdr(this)
			end)
		end
		-- Auctions frames
		self:skinObject("tabs", {obj=this.AuctionsFrame, tabs=this.AuctionsFrame.Tabs, fType=ftype, ignoreSize=true, lod=true, offsets={x1=6, y1=-4, x2=-6, y2=-4}, ignoreHLTex=true, offsetsHL={x1=8, y1=-8, x2=-8, y2=-4}, track=false})
		if self.isTT then
			self:SecureHook(this.AuctionsFrame, "SetDisplayMode", function(this, displayMode)
				-- aObj:Debug("AuctionsFrame SetDisplayMode: [%s, %s]", this, displayMode)
				if self.displayMode == displayMode then return end
				for i, tab in _G.ipairs(this.Tabs) do
					if i == displayMode then
						self:setActiveTab(tab.sf)
					else
						self:setInactiveTab(tab.sf)
					end
				end
			end)
		end
		skinBidAmt(this.AuctionsFrame.BidFrame.BidAmount)
		self:removeNineSlice(this.AuctionsFrame.SummaryList.NineSlice)
		this.AuctionsFrame.SummaryList.Background:SetTexture(nil)
		self:skinSlider{obj=this.AuctionsFrame.SummaryList.ScrollFrame.scrollBar, rt="background"}
		self:removeInset(this.AuctionsFrame.SummaryList)
		self:removeNineSlice(this.AuctionsFrame.ItemDisplay.NineSlice)
		self:removeRegions(this.AuctionsFrame.ItemDisplay, {3})
		skinItemList(this.AuctionsFrame.AllAuctionsList)
		skinItemList(this.AuctionsFrame.BidsList)
		skinItemList(this.AuctionsFrame.ItemList)
		skinItemList(this.AuctionsFrame.CommoditiesList)
		self:addSkinFrame{obj=this.AuctionsFrame, ft=ftype, kfs=true, nb=true, x1=-5, y1=-30, x2=1, y2=-2} -- add frame for tabs
		if self.modBtns then
			self:skinStdButton{obj=this.AuctionsFrame.CancelAuctionButton}
			self:SecureHook(this.AuctionsFrame.CancelAuctionButton, "SetEnabled", function(this)
				self:clrBtnBdr(this)
			end)
			self:skinStdButton{obj=this.AuctionsFrame.BuyoutFrame.BuyoutButton}
			self:SecureHook(this.AuctionsFrame.BuyoutFrame.BuyoutButton, "SetEnabled", function(this)
				self:clrBtnBdr(this)
			end)
			self:skinStdButton{obj=this.AuctionsFrame.BidFrame.BidButton}
			self:SecureHook(this.AuctionsFrame.BidFrame.BidButton, "SetEnabled", function(this)
				self:clrBtnBdr(this)
			end)
		end
		-- Dialogs
		self:addSkinFrame{obj=this.BuyDialog.Border, ft=ftype, kfs=true, nb=true, ofs=-10}
		if self.modBtns then
			self:skinStdButton{obj=this.BuyDialog.BuyNowButton}
			self:SecureHook(this.BuyDialog.BuyNowButton, "SetEnabled", function(this)
				self:clrBtnBdr(this)
			end)
			self:skinStdButton{obj=this.BuyDialog.CancelButton}
			self:SecureHook(this.BuyDialog.CancelButton, "SetEnabled", function(this)
				self:clrBtnBdr(this)
			end)
		end
		self:skinObject("tabs", {obj=this, tabs=this.Tabs, fType=ftype, lod=true, track=false})
		if self.isTT then
			self:SecureHook(this, "SetDisplayMode", function(this, displayMode)
				if not this.tabsForDisplayMode[displayMode] then return end
				for i, tab in _G.ipairs(this.Tabs) do
					if i == this.tabsForDisplayMode[displayMode] then
						self:setActiveTab(tab.sf)
					else
						self:setInactiveTab(tab.sf)
					end
				end
			end)
		end
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, x2=3, y2=-3}

		self:Unhook(this, "OnShow")
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
		self:addSkinFrame{obj=this, ft=ftype, kfs=true}
		if self.modBtns then
			self:skinStdButton{obj=this.ButtonFrame.AzeriteRespecButton}
			self:SecureHook(this, "UpdateAzeriteRespecButtonState", function(this)
				self:clrBtnBdr(this.ButtonFrame.AzeriteRespecButton)
			end)
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].BankFrame = function(self)
	if not self.prdb.BankFrame or self.initialized.BankFrame then return end
	self.initialized.BankFrame = true

	self:SecureHookScript(_G.BankFrame, "OnShow", function(this)
		self:skinEditBox{obj=_G.BankItemSearchBox, regs={6, 7}, mi=true, noHeight=true, noMove=true} -- 6 is text, 7 is icon
		if self.modBtns then
			 self:skinStdButton{obj=_G.BankFramePurchaseButton}
		end
		self:removeInset(_G.BankFrameMoneyFrameInset)
		_G.BankFrameMoneyFrameBorder:DisableDrawLayer("BACKGROUND")
		self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype})
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, y2=-4}
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
			-- add button borders to bags
			for i = 1, _G.NUM_BANKBAGSLOTS do
				self:addButtonBorder{obj=_G.BankSlotsFrame["Bag" .. i], ibt=true}
				_G.BankSlotsFrame["Bag" .. i].sbb:SetBackdropBorderColor(_G.BankSlotsFrame["Bag" .. i].icon:GetVertexColor())
			end
		end
		-- ReagentBankFrame
		_G.ReagentBankFrame:DisableDrawLayer("ARTWORK") -- bank slots texture
		_G.ReagentBankFrame:DisableDrawLayer("BACKGROUND") -- bank slots shadow texture
		_G.ReagentBankFrame:DisableDrawLayer("BORDER") -- shadow textures
		_G.ReagentBankFrame.UnlockInfo:DisableDrawLayer("BORDER")
		_G.RaiseFrameLevelByTwo(_G.ReagentBankFrame.UnlockInfo) -- hide the slot button textures
		if self.modBtns then
			self:skinStdButton{obj=_G.ReagentBankFrameUnlockInfoPurchaseButton}
			self:skinStdButton{obj=_G.ReagentBankFrame.DespositButton}
			self:SecureHook(_G.ReagentBankFrame.DespositButton, "Disable", function(this, _)
				self:clrBtnBdr(this)
			end)
			self:SecureHook(_G.ReagentBankFrame.DespositButton, "Enable", function(this, _)
				self:clrBtnBdr(this)
			end)
		end
		if self.modBtnBs then
			-- add button borders to reagent bank items
			self:SecureHookScript(_G.ReagentBankFrame, "OnShow", function(this)
				for i = 1, this.size do
					self:addButtonBorder{obj=this["Item" .. i], ibt=true, reParent={this["Item" .. i].IconQuestTexture}}
					-- force quality border update
					_G.BankFrameItemButton_Update(this["Item" .. i])
				end

				self:Unhook(this, "OnShow")
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
			self:addSkinFrame{obj=this["Column" .. type], ft=ftype, kfs=true, aso={bd=5}, ofs=0}
		end
		self:skinSlider{obj=_G.BlackMarketScrollFrameScrollBar, wdth=-4}
		this.MoneyFrameBorder:DisableDrawLayer("BACKGROUND")
		self:skinMoneyFrame{obj=_G.BlackMarketBidPrice}
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true, x2=1}
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
		self:SecureHook("BlackMarketScrollFrame_Update", function(this)
			skinSFButtons(_G.BlackMarketScrollFrame)
		end)

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzLoDFrames[ftype].ChromieTimeUI = function(self)
	if not self.prdb.ChromieTimeUI or self.initialized.ChromieTimeUI then return end
	self.initialized.ChromieTimeUI = true

	self:SecureHookScript(_G.ChromieTimeFrame, "OnShow", function(this)
		self:removeNineSlice(this.NineSlice)
		this.Background:DisableDrawLayer("BACKGROUND")
		self:keepFontStrings(this.Title)
		this.CloseButton.Border:SetTexture(nil)
		this.CurrentlySelectedExpansionInfoFrame:DisableDrawLayer("BACKGROUND")
		this.CurrentlySelectedExpansionInfoFrame:DisableDrawLayer("ARTWORK")
		this.CurrentlySelectedExpansionInfoFrame.Name:SetTextColor(self.HT:GetRGB())
		this.CurrentlySelectedExpansionInfoFrame.Description:SetTextColor(self.BT:GetRGB())
		for btn in this.ExpansionOptionsPool:EnumerateActive() do
			btn:GetNormalTexture():SetTexture(nil) -- remove border texture
			self:SecureHook(btn, "SetNormalAtlas", function(this, name, _)
				if name == "ChromieTime-Button-Frame" then
					this:GetNormalTexture():SetTexture(nil) -- remove border texture
				end
			end)
			if self.modBtnBs then
				self:addButtonBorder{obj=btn, ofs=-4, es=20, clr="gold", ca=0.4}
			end
		end
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ofs=0, y1=-1}
		if self.modBtns then
			self:skinStdButton{obj=this.SelectButton}
			self:SecureHook(this.SelectButton, "UpdateButtonState", function(this, _)
				self:clrBtnBdr(this)
			end)
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzLoDFrames[ftype].CovenantPreviewUI = function(self)
	if not self.prdb.CovenantPreviewUI or self.initialized.CovenantPreviewUI then return end
	self.initialized.CovenantPreviewUI = true

	self:SecureHookScript(_G.CovenantPreviewFrame, "OnShow", function(this)
		this.BorderFrame:DisableDrawLayer("BORDER")
		this.Background.BackgroundTile:SetTexture(nil)
		this.Title:DisableDrawLayer("BACKGROUND")
		this.ModelSceneContainer.ModelSceneBorder:SetTexture(nil)
		self:addFrameBorder{obj=this.ModelSceneContainer, ft=ftype, aso={bbclr="sepia"}}
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
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true, aso={bbclr="sepia"}}
		if self.modBtns then
			self:skinCloseButton{obj=this.CloseButton, noSkin=true}
			self:skinStdButton{obj=this.SelectButton, clr="grey"}
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzLoDFrames[ftype].CovenantRenown = function(self)
	if not self.prdb.CovenantRenown or self.initialized.CovenantRenown then return end
	self.initialized.CovenantRenown = true

	self:SecureHook(_G.CovenantRenownFrame, "SetUpCovenantData", function(this)
		if this.sf then
			self:clrCovenantBdr(this.sf)
		end
	end)

	local function skinRewards(frame)
		for reward in frame.rewardsPool:EnumerateActive() do
			aObj:addFrameBorder{obj=reward, ft="a", ofs=-14, aso={bbclr="sepia"}}
			reward.Icon:SetAlpha(1) -- make Icon visible
		end
	end
	self:SecureHookScript(_G.CovenantRenownFrame, "OnShow", function(this)
		self:removeNineSlice(this.NineSlice)
		this.HeaderFrame.Background:SetTexture(nil)
		self:moveObject{obj=this.HeaderFrame, y=-6}
		-- .CelebrationModelScene
		-- .TrackFrame
			-- N.B. the level background is part of the border atlas and CANNOT be changed ;(
		-- .FinalToast
		-- .FinalToast.IconSwirlModelScene
		-- .FinalToast.SlabTexture
		self:SecureHook(this, "SetRewards", function(this, level)
			skinRewards(this)
		end)
		skinRewards(this)
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true}
		self:clrCovenantBdr(this.sf)
		if self.modBtns then
			self:skinCloseButton{obj=this.CloseButton , noSkin=true}
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzLoDFrames[ftype].CovenantSanctum = function(self)
	if not self.prdb.CovenantSanctum or self.initialized.CovenantSanctum then return end
	self.initialized.CovenantSanctum = true

	self:SecureHook(_G.CovenantSanctumFrame, "SetCovenantInfo", function(this)
		if this.sf then
			self:clrCovenantBdr(this.sf)
		end
	end)

	self:SecureHookScript(_G.CovenantSanctumFrame, "OnShow", function(this)
		this.LevelFrame.Background:SetTexture(nil)
		local list = this.UpgradesTab.TalentsList
		list:DisableDrawLayer("BACKGROUND")
		list:DisableDrawLayer("BORDER")
		list.IntroBox:DisableDrawLayer("BORDER")
		local function skinTalents(list)
			for talentFrame in list.talentPool:EnumerateActive() do
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
		self:SecureHook(list, "Refresh", function(this)
			skinTalents(this)
			if self.modBtns then
				self:clrBtnBdr(this.UpgradeButton, "sepia")
			end
		end)
		skinTalents(list)
		list = nil
		for _, frame in _G.pairs(this.UpgradesTab.Upgrades) do
			if frame.Border then
				self:nilTexture(frame.Border, true)
			end
			if frame.TierBorder then
				self:changeTandC(frame.TierBorder)
			end
		end
		this.UpgradesTab.CurrencyBackground:SetTexture(nil)
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cbns=true, ofs=-3})
		self:clrCovenantBdr(this.sf)
		if self.modBtns then
			self:skinStdButton{obj=this.UpgradesTab.TalentsList.UpgradeButton}
			self:skinStdButton{obj=this.UpgradesTab.DepositButton, sec=true}
			self:SecureHook(this.UpgradesTab, "UpdateDepositButton", function(this)
				self:clrBtnBdr(this.DepositButton)
			end)
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzLoDFrames[ftype].FlightMap = function(self)
	if not self.prdb.FlightMap or self.initialized.FlightMap then return end
	self.initialized.FlightMap = true

	self:addSkinFrame{obj=_G.FlightMapFrame.BorderFrame, ft=ftype, kfs=true, y2=-3}
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

aObj.blizzFrames[ftype].GossipFrame = function(self)
	if not self.prdb.GossipFrame or self.initialized.GossipFrame then return end
	self.initialized.GossipFrame = true

	if aObj:isAddonEnabled("Quester")
	and _G.QuesterDB.gossipColor
	then
		-- DON'T colour the gossip text
	else
		self:SecureHook("GossipFrameUpdate", function()
			if not self.isClsc then
				for i = 1, _G.GossipFrame_GetTitleButtonCount() do
					local newText, upd = self:removeColourCodes(_G.GossipFrame.buttons[i]:GetText())
					if upd then
						_G.GossipFrame.buttons[i]:SetText(newText)
					end
					_G.GossipFrame.buttons[i]:GetFontString():SetTextColor(self.BT:GetRGB())
				end
			else
				for i = 1, _G.NUMGOSSIPBUTTONS do
					local newText, upd = self:removeColourCodes(_G["GossipTitleButton" .. i]:GetText())
					if upd then
						_G["GossipTitleButton" .. i]:SetText(newText)
					end
					_G["GossipTitleButton" .. i]:GetFontString():SetTextColor(self.BT:GetRGB())
				end
			end
		end)
	end

	self:SecureHookScript(_G.GossipFrame, "OnShow", function(this)
		self:keepFontStrings(_G.GossipFrameGreetingPanel)
		_G.GossipGreetingText:SetTextColor(self.HT:GetRGB())
		self:skinSlider{obj=_G.GossipGreetingScrollFrame.ScrollBar, rt="artwork"}
		if not self.isClsc then
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true}
		else
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, x1=10, y1=-18, x2=-29, y2=60}
		end
		if self.modBtns then
			self:skinStdButton{obj=_G.GossipFrameGreetingGoodbyeButton}
		end

		-- NPCFriendshipStatusBar
		self:removeRegions(_G.NPCFriendshipStatusBar, {1, 3, 4, 5 ,6})
		self:skinStatusBar{obj=_G.NPCFriendshipStatusBar, fi=0, bgTex=self:getRegion(_G.NPCFriendshipStatusBar, 7)}

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].GuildRegistrar = function(self)
	if not self.prdb.GuildRegistrar or self.initialized.GuildRegistrar then return end
	self.initialized.GuildRegistrar = true

	self:SecureHookScript(_G.GuildRegistrarFrame, "OnShow", function(this)
		self:keepFontStrings(_G.GuildRegistrarGreetingFrame)
		_G.AvailableServicesText:SetTextColor(self.HT:GetRGB())
		self:getRegion(_G.GuildRegistrarButton1, 3):SetTextColor(self.BT:GetRGB())
		self:getRegion(_G.GuildRegistrarButton2, 3):SetTextColor(self.BT:GetRGB())
		_G.GuildRegistrarPurchaseText:SetTextColor(self.BT:GetRGB())
		self:skinEditBox{obj=_G.GuildRegistrarFrameEditBox}
		if not self.isClsc then
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true}
		else
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, x1=10, y1=-17, x2=-29, y2=62}
		end
		if self.modBtns then
			self:skinStdButton{obj=_G.GuildRegistrarFrameGoodbyeButton}
			self:skinStdButton{obj=_G.GuildRegistrarFrameCancelButton}
			self:skinStdButton{obj=_G.GuildRegistrarFramePurchaseButton}
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzLoDFrames[ftype].ItemInteractionUI = function(self) -- a.k.a. Titanic Purification
	if not self.prdb.ItemInteractionUI or self.initialized.ItemInteractionUI then return end
	self.initialized.ItemInteractionUI = true

	self:SecureHookScript(_G.ItemInteractionFrame, "OnShow", function(this)
		-- use module to make button slot visible
		self.modUIBtns:addButtonBorder{obj=this.ItemSlot, relTo=this.ItemSlot.Icon, clr="grey"}
		this.ButtonFrame:DisableDrawLayer("BORDER")
		this.ButtonFrame.MoneyFrameEdge:DisableDrawLayer("BACKGROUND")
		self:addSkinFrame{obj=this, ft=ftype, kfs=true}
		if self.modBtns then
			self:skinStdButton{obj=this.ButtonFrame.ActionButton}
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzLoDFrames[ftype].ItemUpgradeUI = function(self)
	if not self.prdb.ItemUpgradeUI or self.initialized.ItemUpgradeUI then return end
	self.initialized.ItemUpgradeUI = true

	self:SecureHookScript(_G.ItemUpgradeFrame, "OnShow", function(this)
		this.Inset.Bg:SetTexture(nil)
		self:removeNineSlice(this.Inset.NineSlice)
		this.HorzBar:SetTexture(nil)
		this.MissingDescription:SetTextColor(self.BT:GetRGB())
		this.ItemUpgradedNotification:SetTextColor(self.BT:GetRGB())
		this.FeedbackMessage:SetTextColor(self.BT:GetRGB())
		this.TitleTextLeft:SetTextColor(self.BT:GetRGB())
		this.TitleTextRight:SetTextColor(self.BT:GetRGB())
		this.ItemButton.IconTexture:SetAlpha(0)
		this.ItemButton:DisableDrawLayer("BACKGROUND")
		this.ItemButton.Frame:SetTexture(nil)
		this.ItemButton.ItemName:SetTextColor(self.BT:GetRGB())
		-- use module to make it visible all the time
		self.modUIBtns:addButtonBorder{obj=this.ItemButton, relTo=this.ItemButton.IconTexture, clr="grey", ofs=1, y1=2}
		self:removeRegions(this.TextFrame, {1, 2, 3, 4, 5, 6})
		this.TextFrame.MissingText:SetTextColor(self.BT:GetRGB())
		this.ButtonFrame:DisableDrawLayer("BORDER", 2)
		_G.ItemUpgradeFrameMoneyFrame:DisableDrawLayer("BACKGROUND")
		self:removeMagicBtnTex(_G.ItemUpgradeFrameUpgradeButton)
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, x2=3})
		if self.modBtns then
			self:skinStdButton{obj=_G.ItemUpgradeFrameUpgradeButton}
			self:SecureHook(_G.ItemUpgradeFrameUpgradeButton, "Disable", function(this)
				self:clrBtnBdr(this)
			end)
			self:SecureHook(_G.ItemUpgradeFrameUpgradeButton, "Enable", function(this)
				self:clrBtnBdr(this)
			end)
		end
		-- hook this to hide the ItemButton texture if empty
		self:SecureHook("ItemUpgradeFrame_Update", function()
			local icon, _, quality = _G.GetItemUpgradeItemInfo()
			if icon then
				_G.ItemUpgradeFrame.ItemButton.IconTexture:SetAlpha(1)
				_G.ItemUpgradeFrame.ItemButton.sbb:SetBackdropBorderColor(_G.BAG_ITEM_QUALITY_COLORS[quality].r, _G.BAG_ITEM_QUALITY_COLORS[quality].g, _G.BAG_ITEM_QUALITY_COLORS[quality].b, 1)
			else
				_G.ItemUpgradeFrame.ItemButton.IconTexture:SetAlpha(0)
				self:clrBtnBdr(_G.ItemUpgradeFrame.ItemButton, "grey")
			end
			icon, quality = nil, nil
		end)
		-- hook this to remove background texture from stat lines
		self:SecureHook("ItemUpgradeFrame_GetStatRow", function(index, _)
			if _G.ItemUpgradeFrame.LeftStat[index] then
				 _G.ItemUpgradeFrame.LeftStat[index].BG:SetTexture(nil)
			 end
			if _G.ItemUpgradeFrame.RightStat[index] then
				_G.ItemUpgradeFrame.RightStat[index].BG:SetTexture(nil)
			end
		end)

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].MerchantFrame = function(self)
	if not self.prdb.MerchantFrame or self.initialized.MerchantFrame then return end
	self.initialized.MerchantFrame = true

	self:SecureHookScript(_G.MerchantFrame, "OnShow", function(this)
		self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, ignoreSize=self.isClsc and true, lod=true})
		self:removeInset(_G.MerchantMoneyInset)
		_G.MerchantMoneyBg:DisableDrawLayer("BACKGROUND")
		if not self.isClsc then
			self:skinDropDown{obj=_G.MerchantFrameLootFilter}
			self:removeInset(_G.MerchantExtraCurrencyInset)
			_G.MerchantExtraCurrencyBg:DisableDrawLayer("BACKGROUND")
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true, y2=-6}
		else
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true, x2=1, y2=-6}
		end
		if self.modBtnBs then
			self:removeRegions(_G.MerchantPrevPageButton, {2})
			self:removeRegions(_G.MerchantNextPageButton, {2})
			self:addButtonBorder{obj=_G.MerchantPrevPageButton, ofs=-2, y1=-3, x2=-3}
			self:addButtonBorder{obj=_G.MerchantNextPageButton, ofs=-2, y1=-3, x2=-3}
			self:SecureHook("MerchantFrame_UpdateMerchantInfo", function()
				self:clrPNBtns("Merchant")
			end)
		end
		-- Items/Buyback Items
		for i = 1, _G.math.max(_G.MERCHANT_ITEMS_PER_PAGE, _G.BUYBACK_ITEMS_PER_PAGE) do
			_G["MerchantItem" .. i .. "NameFrame"]:SetTexture(nil)
			if not self.modBtnBs then
				_G["MerchantItem" .. i .. "SlotTexture"]:SetTexture(self.esTex)
			else
				_G["MerchantItem" .. i .. "SlotTexture"]:SetTexture(nil)
				self:addButtonBorder{obj=_G["MerchantItem" .. i].ItemButton, ibt=true}
			end
		end
		_G.MerchantBuyBackItemNameFrame:SetTexture(nil)
		if self.modBtnBs then
			_G.MerchantBuyBackItemSlotTexture:SetTexture(nil)
			self:addButtonBorder{obj=_G.MerchantBuyBackItem.ItemButton, ibt=true}
			-- remove surrounding border (diff=0.01375)
			self:getRegion(_G.MerchantRepairItemButton, 1):SetTexCoord(0.01375, 0.2675, 0.01375, 0.54875)
			_G.MerchantRepairAllIcon:SetTexCoord(0.295, 0.54875, 0.01375, 0.54875)
			_G.MerchantGuildBankRepairButtonIcon:SetTexCoord(0.57375, 0.83, 0.01375, 0.54875)
			self:addButtonBorder{obj=_G.MerchantRepairAllButton, clr="gold", ca=0.5}
			self:addButtonBorder{obj=_G.MerchantRepairItemButton, clr="gold", ca=0.5}
			self:addButtonBorder{obj=_G.MerchantGuildBankRepairButton, clr="gold", ca=0.5}
			self:SecureHook("MerchantFrame_UpdateCanRepairAll", function()
				self:clrBtnBdr(_G.MerchantRepairAllButton, "gold", 0.5)
			end)
			if not self.isClsc then
				self:SecureHook("MerchantFrame_UpdateGuildBankRepair", function()
					self:clrBtnBdr(_G.MerchantGuildBankRepairButton, "gold", 0.5)
				end)
			else
				self:SecureHook(_G.MerchantGuildBankRepairButton, "Disable", function(this, _)
					self:clrBtnBdr(this)
				end)
				self:SecureHook(_G.MerchantGuildBankRepairButton, "Enable", function(this, _)
					self:clrBtnBdr(this)
				end)
			end
		else
			_G.MerchantBuyBackItemSlotTexture:SetTexture(self.esTex)
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzLoDFrames[ftype].NewPlayerExperienceGuide = function(self)
	if not self.prdb.NewPlayerExperienceGuide or self.initialized.NewPlayerExperienceGuide then return end
	self.initialized.NewPlayerExperienceGuide = true

	self:SecureHookScript(_G.GuideFrame, "OnShow", function(this)
		self:removeNineSlice(this.NineSlice)
		this:DisableDrawLayer("BACKGROUND")
		this.Title:SetTextColor(self.HT:GetRGB())
		this.ScrollFrame.Child.Text:SetTextColor(self.BT:GetRGB())
		this.ScrollFrame.Child.ObjectivesFrame:DisableDrawLayer("BORDER")
		this.ScrollFrame.Child.ObjectivesFrame:DisableDrawLayer("BACKGROUND")
		this.ScrollFrame.ScrollBar.ScrollUpBorder:SetBackdrop(nil)
		this.ScrollFrame.ScrollBar.ScrollDownBorder:SetBackdrop(nil)
		this.ScrollFrame.ScrollBar.Border:SetBackdrop(nil)
		self:skinSlider{obj=this.ScrollFrame.ScrollBar, wdth=-4}
		self:addSkinFrame{obj=this, ft=ftype, kfs=true}
		if self.modBtns then
			self:skinStdButton{obj=this.ScrollFrame.ConfirmationButton}
			self:SecureHook(this, "SetStateInternal", function(this)
				self:clrBtnBdr(this.ScrollFrame.ConfirmationButton)
			end)
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
		if not self.isClsc then
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true}
		else
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, x1=10, y1=-17, x2=-29, y2=62}
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
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true}
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

aObj.blizzFrames[ftype].QuestFrame = function(self)
	if not self.prdb.QuestFrame or self.initialized.QuestFrame then return end
	self.initialized.QuestFrame = true

	if not self.isClsc then
		if aObj:isAddonEnabled("Quester")
		and _G.QuesterDB.gossipColor
		then
			-- DON'T colour the gossip text
		else
			-- hook this to colour quest button text
			self:RawHook(_G.QuestFrameGreetingPanel.titleButtonPool, "Acquire", function(this)
				local btn = self.hooks[this].Acquire(this)
				self:hookQuestText(btn)
				return btn
			end, true)
		end
	end

	self:SecureHookScript(_G.QuestFrame, "OnShow", function(this)
		self:RawHook("QuestFrame_SetTitleTextColor", function(fontString, _)
			fontString:SetTextColor(self.HT:GetRGB())
		end, true)
		self:RawHook("QuestFrame_SetTextColor", function(fontString, _)
			fontString:SetTextColor(self.BT:GetRGB())
		end, true)

		if not self.isClsc then
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true}
		else
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, x1=10, y1=-18, x2=-29, y2=65}
		end

		--	Reward Panel
		self:keepFontStrings(_G.QuestFrameRewardPanel)
		self:skinSlider{obj=_G.QuestRewardScrollFrame.ScrollBar, rt="artwork"}

		--	Progress Panel
		self:keepFontStrings(_G.QuestFrameProgressPanel)
		_G.QuestProgressTitleText:SetTextColor(self.HT:GetRGB())
		_G.QuestProgressText:SetTextColor(self.BT:GetRGB())
		_G.QuestProgressRequiredMoneyText:SetTextColor(self.BT:GetRGB())
		_G.QuestProgressRequiredItemsText:SetTextColor(self.HT:GetRGB())
		self:skinSlider{obj=_G.QuestProgressScrollFrame.ScrollBar, rt="artwork"}
		local btnName
		for i = 1, _G.MAX_REQUIRED_ITEMS do
			btnName = "QuestProgressItem" .. i
			_G[btnName .. "NameFrame"]:SetTexture(nil)
			if self.modBtns then
				 self:addButtonBorder{obj=_G[btnName], libt=true, clr="grey"}
			end
		end
		btnName = nil
		self:SecureHook("QuestFrameProgressItems_Update", function()
			local br, bg, bb = self.BT:GetRGB()
			local r, g ,b = _G.QuestProgressRequiredMoneyText:GetTextColor()
			-- if red colour is less than 0.2 then it needs to be coloured
			if r < 0.2 then
				_G.QuestProgressRequiredMoneyText:SetTextColor(br - r, bg - g, bb - b)
			end
			br, bg, bb, r, g, b = nil, nil, nil, nil, nil, nil
		end)

		--	Detail Panel
		self:keepFontStrings(_G.QuestFrameDetailPanel)
		self:skinSlider{obj=_G.QuestDetailScrollFrame.ScrollBar, rt="artwork"}

		--	Greeting Panel
		self:keepFontStrings(_G.QuestFrameGreetingPanel)
		self:keepFontStrings(_G.QuestGreetingScrollChildFrame) -- hide Horizontal Break texture
		self:skinSlider{obj=_G.QuestGreetingScrollFrame.ScrollBar, rt="artwork"}
		if _G.QuestFrameGreetingPanel:IsShown() then
			_G.GreetingText:SetTextColor(self.BT:GetRGB())
			_G.CurrentQuestsText:SetTextColor(self.HT:GetRGB())
			_G.AvailableQuestsText:SetTextColor(self.HT:GetRGB())
		end
		if self.isClsc then
			for i = 1, _G.MAX_NUM_QUESTS do
				self:hookQuestText(_G["QuestTitleButton" .. i])
			end
			-- force recolouring of quest text
			self:checkShown(_G.QuestFrameGreetingPanel)
		end

		if self.modBtns then
			self:SecureHook(_G.QuestFrameCloseButton, "Disable", function(this, _)
				self:clrBtnBdr(this)
			end)
			self:SecureHook(_G.QuestFrameCloseButton, "Enable", function(this, _)
				self:clrBtnBdr(this)
			end)
			self:skinStdButton{obj=_G.QuestFrameCompleteQuestButton}
			self:SecureHook(_G.QuestFrameCompleteQuestButton, "Disable", function(this, _)
				self:clrBtnBdr(this)
			end)
			self:SecureHook(_G.QuestFrameCompleteQuestButton, "Enable", function(this, _)
				self:clrBtnBdr(this)
			end)
			self:skinStdButton{obj=_G.QuestFrameGoodbyeButton}
			self:skinStdButton{obj=_G.QuestFrameCompleteButton}
			self:SecureHookScript(_G.QuestFrameProgressPanel, "OnShow", function(this)
				self:clrBtnBdr(_G.QuestFrameCompleteButton)
			end)
			self:skinStdButton{obj=_G.QuestFrameDeclineButton}
			self:skinStdButton{obj=_G.QuestFrameAcceptButton}
			self:skinStdButton{obj=_G.QuestFrameGreetingGoodbyeButton}
			if self.isClsc then
				self:skinStdButton{obj=_G.QuestFrameCancelButton}
			end
		end

		self:Unhook(this, "OnShow")
	end)

	-- parentFrame, portraitDisplayID, mountPortraitDisplayID, text, name, x, y
	self:SecureHook("QuestFrame_ShowQuestPortrait", function(...)
		local frame
		if not self.isClsc then
			frame = _G.QuestModelScene
		else
			frame = _G.QuestNPCModel
		end
		if not frame.sf then
			self:keepFontStrings(_G.QuestNPCModelTextFrame)
			self:addSkinFrame{obj=frame, ft=ftype, kfs=true, nb=true, x2=5, y2=-81}
		end
		local parentFrame, _, _, _, _, x, y = ...
		frame:SetPoint("TOPLEFT", parentFrame, "TOPRIGHT", x + 4, y)
		frame, parentFrame, x, y = nil, nil, nil, nil
	end)

end

aObj.blizzFrames[ftype].QuestInfo = function(self)
	if self.initialized.QuestInfo then return end
	self.initialized.QuestInfo = true

	local function skinRewards(frame)
		if frame.Header:IsObjectType("FontString") then -- QuestInfoRewardsFrame
			frame.Header:SetTextColor(aObj.HT:GetRGB())
		end
		frame.ItemChooseText:SetTextColor(aObj.BT:GetRGB())
		frame.ItemReceiveText:SetTextColor(aObj.BT:GetRGB())
		frame.PlayerTitleText:SetTextColor(aObj.BT:GetRGB())
		if frame.XPFrame.ReceiveText then -- QuestInfoRewardsFrame
			frame.XPFrame.ReceiveText:SetTextColor(aObj.BT:GetRGB())
		end
		-- RewardButtons
		for _, btn in _G.pairs(frame.RewardButtons) do
			btn.NameFrame:SetTexture(nil)
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=btn, libt=true}
				aObj:clrButtonFromBorder(btn)
			end
		end
		-- SpellReward
		for spellBtn in frame.spellRewardPool:EnumerateActive() do
			spellBtn.NameFrame:SetTexture(nil)
			spellBtn:DisableDrawLayer("OVERLAY")
			if aObj.modBtnBs then
				 aObj:addButtonBorder{obj=spellBtn, relTo=spellBtn.Icon, clr="grey"}
			end
		end
		-- FollowerReward
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
	end
	local function updateQIDisplay(_)
		-- aObj:Debug("updateQIDisplay")
		local br, bg, bb = aObj.BT:GetRGB()
		-- headers
		_G.QuestInfoTitleHeader:SetTextColor(aObj.HT:GetRGB())
		_G.QuestInfoDescriptionHeader:SetTextColor(aObj.HT:GetRGB())
		_G.QuestInfoObjectivesHeader:SetTextColor(aObj.HT:GetRGB())
		-- other text
		_G.QuestInfoQuestType:SetTextColor(aObj.BT:GetRGB())
		_G.QuestInfoObjectivesText:SetTextColor(aObj.BT:GetRGB())
		_G.QuestInfoRewardText:SetTextColor(aObj.BT:GetRGB())
		local r, g, b = _G.QuestInfoRequiredMoneyText:GetTextColor()
		_G.QuestInfoRequiredMoneyText:SetTextColor(br - r, bg - g, bb - b)
		_G.QuestInfoGroupSize:SetTextColor(aObj.BT:GetRGB())
		_G.QuestInfoAnchor:SetTextColor(aObj.BT:GetRGB())
		-- remove any embedded colour codes
		_G.QuestInfoDescriptionText:SetText(aObj:removeColourCodes(_G.QuestInfoDescriptionText:GetText()))
		_G.QuestInfoDescriptionText:SetTextColor(aObj.BT:GetRGB())
		-- skin rewards
		skinRewards(_G.QuestInfoFrame.rewardsFrame)
		-- Objectives
		local obj
		for i = 1, #_G.QuestInfoObjectivesFrame.Objectives do
			obj = _G.QuestInfoObjectivesFrame.Objectives[i]
			r, g ,b = obj:GetTextColor()
			-- if red colour is less than 0.2 then it needs to be coloured
			if r < 0.2 then
				obj:SetTextColor(br - r, bg - g, bb - b)
			end
		end
		obj, r, g, b, br, bg, bb = nil, nil, nil, nil, nil, nil ,nil
		-- QuestInfoSpecialObjectives Frame
		_G.QuestInfoSpellObjectiveLearnLabel:SetTextColor(aObj.BT:GetRGB())
		_G.QuestInfoSpellObjectiveFrameNameFrame:SetTexture(nil)
		_G.QuestInfoSpellObjectiveFrameSpellBorder:SetTexture(nil)
		if aObj.modBtnBs then
			 aObj:addButtonBorder{obj=_G.QuestInfoSpellObjectiveFrame, relTo=_G.QuestInfoSpellObjectiveFrame.Icon, clr="grey"}
		end
		-- QuestInfoSeal Frame text colour
		-- TODO: can this be replaced with removeColourCodes function ?
		if _G.QuestInfoSealFrame:IsShown()
		and _G.QuestInfoSealFrame.theme
		then
			local sealText = aObj:unwrapTextFromColourCode(_G.QuestInfoSealFrame.theme.signature)
			_G.QuestInfoSealFrame.Text:SetText(aObj.HT:WrapTextInColorCode(sealText)) -- re-colour text
			sealText = nil
		end
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
			local br, bg, bb = self.BT:GetRGB()
			local r, g ,b = _G.QuestInfoRequiredMoneyText:GetTextColor()
			-- if red value is less than 0.2 then it needs to be coloured
			if r < 0.2 then
				_G.QuestInfoRequiredMoneyText:SetTextColor(br - r, bg - g, bb - b)
			end
			br, bg, bb, r, g, b = nil, nil, nil, nil, nil, nil
		end)

		self:Unhook(this, "OnShow")
	end)

	local function skinRewardBtns(frame, btnType)
		for _, type in _G.pairs{"HonorFrame", "ArtifactXPFrame", "WarModeBonusFrame", "SkillPointFrame", "TitleFrame"} do
			-- Classic DOESN'T have a WarModeBonusFrame
			if frame[type] then
				-- QIRF's TitleFrame DOESN'T have a NameFrame
				if frame[type].NameFrame then
					frame[type].NameFrame:SetTexture(nil)
				end
				if aObj.modBtnBs then
					aObj:addButtonBorder{obj=frame[type], btnType=true, relTo=frame[type].Icon, reParent=type == "SkillPointFrame" and {frame[type].CircleBackground, frame[type].CircleBackgroundGlow, frame[type].ValueText}, clr="grey"}
				end
			end
		end
	end
	self:SecureHookScript(_G.QuestInfoRewardsFrame, "OnShow", function(this)
		skinRewardBtns(this, "libt")
		this.XPFrame.ReceiveText:SetTextColor(self.BT:GetRGB())
		self:removeRegions(_G.QuestInfoPlayerTitleFrame, {2, 3, 4}) -- NameFrame textures

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.MapQuestInfoRewardsFrame, "OnShow", function(this)
		skinRewardBtns(this, "sibt")
		for _, type in _G.pairs{"XPFrame", "MoneyFrame"} do
			this[type].NameFrame:SetTexture(nil)
			if self.modBtnBs then
				self:addButtonBorder{obj=this[type], sibt=true, relTo=this[type].Icon, clr="grey"}
			end
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzLoDFrames[ftype].RuneForgeUI = function(self)
	if not self.prdb.RuneForgeUI or self.initialized.RuneForgeUI then return end
	self.initialized.RuneForgeUI = true

	self:SecureHookScript(_G.RuneforgeFrame, "OnShow", function(this)
		-- .CraftingFrame
			-- .BaseItemSlot
			-- .UpgradeItemSlot
			-- .ModifierFrame
			-- .PowerSlot
			-- .PowerFrame
		-- .CreateFrame
		if self.modBtns then
			self:skinStdButton{obj=this.CreateFrame.CraftItemButton}
			self:SecureHook(this.CreateFrame.CraftItemButton, "SetCraftState", function(this, ...)
				self:clrBtnBdr(this)
			end)
		end
		-- .CurrencyDisplay
		this.CloseButton.CustomBorder:SetTexture(nil)
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true, ofs=-20, y2=30}
		if self.modBtns then
			self:skinCloseButton{obj=this.CloseButton, noSkin=true}
		end
		-- tooltip
		_G.C_Timer.After(0.1, function()
			self:add2Table(self.ttList, this.ResultTooltip)
		end)

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].Tabard = function(self)
	if not self.prdb.Tabard or self.initialized.Tabard then return end
	self.initialized.Tabard = true

	self:SecureHookScript(_G.TabardFrame, "OnShow", function(this)
		self:keepRegions(this, {4, 17, 18, 19, 20, 21, 22}) -- N.B. regions 4, 21 & 22 are text, 17-20 are icon textures
		self:removeNineSlice(this.NineSlice)
		self:removeBackdrop(_G.TabardFrameCostFrame)
		self:keepFontStrings(_G.TabardFrameCustomizationFrame)
		for i = 1, 5 do
			self:keepFontStrings(_G["TabardFrameCustomization" .. i])
			if self.modBtnBs then
				self:addButtonBorder{obj=_G["TabardFrameCustomization" .. i .. "LeftButton"], ofs=-2, x1=1, clr="gold"}
				self:addButtonBorder{obj=_G["TabardFrameCustomization" .. i .. "RightButton"], ofs=-2, x1=1, clr="gold"}
			end
		end
		if not self.isClsc then
			self:removeInset(_G.TabardFrameMoneyInset)
			_G.TabardFrameMoneyBg:DisableDrawLayer("BACKGROUND")
			self:addSkinFrame{obj=this, ft=ftype, ri=true}
		else
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, x1=10, y1=-11, x2=-32, y2=71}
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

aObj.blizzFrames[ftype].TaxiFrame = function(self)
	if not self.prdb.TaxiFrame or self.initialized.TaxiFrame then return end
	self.initialized.TaxiFrame = true

	self:SecureHookScript(_G.TaxiFrame, "OnShow", function(this)
		this:DisableDrawLayer("BORDER")
		self:removeRegions(this, {1, 2, 3}) -- 1st 3 overlay textures
		-- resize map to fit skin frame
		this.InsetBg:SetPoint("TOPLEFT", 0, -24)
		this.InsetBg:SetPoint("BOTTOMRIGHT", 0 ,0)
		self:addSkinFrame{obj=this, ft=ftype}

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
		self:skinStatusBar{obj=_G.ClassTrainerStatusBar, fi=0, bgTex=_G.ClassTrainerStatusBarBackground}
		self:skinDropDown{obj=_G.ClassTrainerFrameFilterDropDown}
		self:removeMagicBtnTex(_G.ClassTrainerTrainButton)
		if self.modBtns then
			self:skinStdButton{obj=_G.ClassTrainerTrainButton}
			self:SecureHook(_G.ClassTrainerTrainButton, "Disable", function(this, _)
				self:clrBtnBdr(this)
			end)
			self:SecureHook(_G.ClassTrainerTrainButton, "Enable", function(this, _)
				self:clrBtnBdr(this)
			end)
		end
		_G.ClassTrainerFrame.skillStepButton:GetNormalTexture():SetTexture(nil)
		if self.modBtnBs then
			 self:addButtonBorder{obj=this.skillStepButton, relTo=this.skillStepButton.icon}
		end
		self:skinSlider{obj=_G.ClassTrainerScrollFrameScrollBar, wdth=-4}
		for i = 1, #this.scrollFrame.buttons do
			this.scrollFrame.buttons[i]:GetNormalTexture():SetTexture(nil)
			if self.modBtnBs then
				self:addButtonBorder{obj=this.scrollFrame.buttons[i], relTo=this.scrollFrame.buttons[i].icon}
			end
		end
		self:removeInset(this.bottomInset)
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true}

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzLoDFrames[ftype].VoidStorageUI = function(self)
	if not self.prdb.VoidStorageUI or self.initialized.VoidStorageUI then return end
	self.initialized.VoidStorageUI = true

	self:SecureHookScript(_G.VoidStorageFrame, "OnShow", function(this)
		for _, type in _G.pairs{"Deposit", "Withdraw", "Storage", "Cost"} do
			self:removeNineSlice(_G["VoidStorage" .. type .. "Frame"].NineSlice)
		end
		self:keepFontStrings(_G.VoidStorageBorderFrame)
		self:skinEditBox{obj=_G.VoidItemSearchBox, regs={6, 7}, mi=true, noHeight=true, noMove=true} -- 6 is text, 7 is icon
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, x2=1}
		if self.modBtns then
			self:skinStdButton{obj=_G.VoidStorageTransferButton}
			self:SecureHook(_G.VoidStorageTransferButton, "Disable", function(this, _)
				self:clrBtnBdr(this)
			end)
			self:SecureHook(_G.VoidStorageTransferButton, "Enable", function(this, _)
				self:clrBtnBdr(this)
			end)
			self:skinCloseButton{obj=_G.VoidStorageBorderFrame.CloseButton}
			self:skinStdButton{obj=_G.VoidStoragePurchaseButton}
			self:SecureHook("VoidStorageFrame_Update", function()
				self:clrBtnBdr(_G.VoidStoragePurchaseButton)
			end)
		end
		self:addSkinFrame{obj=_G.VoidStoragePurchaseFrame, ft=ftype, kfs=true}
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
