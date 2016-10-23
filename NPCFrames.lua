local aName, aObj = ...
local _G = _G
local ftype = "n"

local pairs = _G.pairs

function aObj:AuctionUI() -- LoD
	if not self.db.profile.AuctionUI or self.initialized.AuctionUI then return end
	self.initialized.AuctionUI = true

	local btnName, obj

	-- hide filter texture when filter is clicked
	self:SecureHook("FilterButton_SetUp", function(button, ...)
		_G[button:GetName() .. "NormalTexture"]:SetAlpha(0)
	end)

	self:skinTabs{obj=_G.AuctionFrame, lod=true}
	self:addSkinFrame{obj=_G.AuctionFrame, ft=ftype, kfs=true, hdr=true, bgen=0, x1=10, y1=-11, y2=5} -- N.B. bgen=1 to prevent other AddOns buttons being skinned
-->>--	Browse Frame
	for i = 1, _G.NUM_FILTERS_TO_DISPLAY do
		self:keepRegions(_G["AuctionFilterButton" .. i], {3, 4}) -- N.B. region 3 is the highlight, 4 is the text
		self:addSkinFrame{obj=_G["AuctionFilterButton" .. i], ft=ftype, nb=true, aso={bd=5}}
	end
	if not self.isPTR then
		self:skinScrollBar{obj=_G.BrowseFilterScrollFrame}
		self:skinScrollBar{obj=_G.BrowseScrollFrame}
	else
		self:skinSlider{obj=_G.BrowseFilterScrollFrame.ScrollBar, size=3, rt="artwork"}
		self:skinSlider{obj=_G.BrowseScrollFrame.ScrollBar, size=3, rt="artwork"}
	end
	-- BrowseWowTokenResults
	_G.BrowseWowTokenResults.Token:DisableDrawLayer("BACKGROUND")
	self:skinButton{obj=_G.BrowseWowTokenResults.Buyout}
	-- WowTokenGameTimeTutorial
	_G.WowTokenGameTimeTutorial.LeftDisplay.Label:SetTextColor(self.HTr, self.HTg, self.HTb)
	_G.WowTokenGameTimeTutorial.LeftDisplay.Tutorial1:SetTextColor(self.BTr, self.Tg, self.Tb)
	_G.WowTokenGameTimeTutorial.RightDisplay.Label:SetTextColor(self.HTr, self.HTg, self.HTb)
	_G.WowTokenGameTimeTutorial.RightDisplay.Tutorial1:SetTextColor(self.BTr, self.Tg, self.Tb)
	self:skinButton{obj=_G.StoreButton, x1=14, y1=2, x2=-14, y2=2}
	self:addSkinFrame{obj=_G.WowTokenGameTimeTutorial, ft=ftype, kfs=true, ri=true, ofs=1, y1=2, y2=220}
	for _, v in pairs{"Quality", "Level", "Duration", "HighBidder", "CurrentBid"} do
		obj = _G["Browse" .. v .. "Sort"]
		self:keepRegions(obj, {4, 5, 6}) -- N.B. region 4 is the text, 5 is the arrow, 6 is the highlight
		self:addSkinFrame{obj=obj, ft=ftype, nb=true, aso={bd=5}}
	end
	for i = 1, _G.NUM_BROWSE_TO_DISPLAY do
		btnName = "BrowseButton" .. i
		if _G[btnName].Orig then break end -- Auctioneer CompactUI loaded
		self:keepFontStrings(_G[btnName])
		if _G[btnName .. "Highlight"] then _G[btnName .. "Highlight"]:SetAlpha(1) end
		self:addButtonBorder{obj=_G[btnName .. "Item"], auit=true}
	end
	for _, v in pairs{"Name", "MinLevel", "MaxLevel"} do
		obj = _G["Browse" .. v]
		self:skinEditBox{obj=obj, regs={6, v == "Name" and 7 or nil}, mi=true} -- 6 is text, 7 is icon
		self:moveObject{obj=obj, x=v == "MaxLevel" and -6 or -4, y=v ~= "MaxLevel" and 3 or 0}
	end
	self:skinDropDown{obj=_G.BrowseDropDown, x2=110}
	self:addButtonBorder{obj=_G.IsUsableCheckButton, es=14, ofs=-2}
	self:addButtonBorder{obj=_G.ShowOnPlayerCheckButton, es=14, ofs=-2}
	self:addButtonBorder{obj=_G.BrowsePrevPageButton, ofs=-2, y1=-3, x2=-3}
	self:addButtonBorder{obj=_G.BrowseNextPageButton, ofs=-2, y1=-3, x2=-3}
	self:skinMoneyFrame{obj=_G.BrowseBidPrice, moveSEB=true}
	self:skinButton{obj=_G.BrowseSearchButton}
	self:skinButton{obj=_G.BrowseResetButton}
	self:addButtonBorder{obj=_G.ExactMatchCheckButton, es=14, ofs=-2}
	_G.BrowseCloseButton:DisableDrawLayer("BORDER")
	_G.BrowseBuyoutButton:DisableDrawLayer("BORDER")
	_G.BrowseBidButton:DisableDrawLayer("BORDER")
	self:skinButton{obj=_G.BrowseBidButton}
	self:skinButton{obj=_G.BrowseBuyoutButton}
	self:skinButton{obj=_G.BrowseCloseButton}

-->>--	Bid Frame
	for _, v in pairs{"Quality", "Level", "Duration", "Buyout", "Status", "Bid"} do
		obj = _G["Bid" .. v .. "Sort"]
		self:keepRegions(obj, {4, 5, 6}) -- N.B. region 4 is the text, 5 is the arrow, 6 is the highlight
		self:addSkinFrame{obj=obj, ft=ftype, nb=true, aso={bd=5}}
	end
	for i = 1, _G.NUM_BIDS_TO_DISPLAY do
		btnName = "BidButton" .. i
		self:keepFontStrings(_G[btnName])
		if _G[btnName .. "Highlight"] then _G[btnName .. "Highlight"]:SetAlpha(1) end
		self:addButtonBorder{obj=_G[btnName .. "Item"], auit=true}
	end
	if not self.isPTR then
		self:skinScrollBar{obj=_G.BidScrollFrame}
	else
		self:skinSlider{obj=_G.BidScrollFrame.ScrollBar, size=3, rt="artwork"}
	end
	self:skinMoneyFrame{obj=_G.BidBidPrice, moveSEB=true}
	_G.BidCloseButton:DisableDrawLayer("BORDER")
	_G.BidBuyoutButton:DisableDrawLayer("BORDER")
	_G.BidBidButton:DisableDrawLayer("BORDER")
	self:skinButton{obj=_G.BidBidButton}
	self:skinButton{obj=_G.BidBuyoutButton}
	self:skinButton{obj=_G.BidCloseButton}

-->>--	Auctions Frame
	for _, v in pairs{"Quality", "Duration", "HighBidder", "Bid"} do
		obj = _G["Auctions" .. v .. "Sort"]
		self:keepRegions(obj, {4, 5, 6}) -- N.B. region 4 is the text, 5 is the arrow, 6 is the highlight
		self:addSkinFrame{obj=obj, ft=ftype, nb=true, aso={bd=5}}
	end
	if not self.isPTR then
		self:skinScrollBar{obj=_G.AuctionsScrollFrame}
	else
		self:skinSlider{obj=_G.AuctionsScrollFrame.ScrollBar, size=3, rt="artwork"}
	end
	for i = 1, _G.NUM_AUCTIONS_TO_DISPLAY do
		btnName = "AuctionsButton" .. i
		self:keepFontStrings(_G[btnName])
		if _G[btnName .. "Highlight"] then _G[btnName .. "Highlight"]:SetAlpha(1) end
		self:addButtonBorder{obj=_G[btnName .. "Item"], auit=true}
	end
	if not self.modBtnBs then
		self:resizeEmptyTexture(self:getRegion(_G.AuctionsItemButton, 2))
	else
		self:getRegion(_G.AuctionsItemButton, 2):SetAlpha(0) -- texture is changed in blizzard code
		self:addButtonBorder{obj=_G.AuctionsItemButton}
	end
	self:skinEditBox{obj=_G.AuctionsStackSizeEntry, regs={6}, noWidth=true} -- 6 is text
	self:skinEditBox{obj=_G.AuctionsNumStacksEntry, regs={6}, noWidth=true} -- 6 is text
	self:skinDropDown{obj=_G.PriceDropDown}
	self:skinMoneyFrame{obj=_G.StartPrice, moveSEB=true}
	self:skinMoneyFrame{obj=_G.BuyoutPrice, moveSEB=true}
	self:skinDropDown{obj=_G.DurationDropDown}
	self:skinButton{obj=_G.AuctionsCreateAuctionButton}
	self:skinButton{obj=_G.AuctionsCancelAuctionButton}
	self:skinButton{obj=_G.AuctionsCloseButton}

-->>-- AuctionProgress Frame
	_G.AuctionProgressFrame:DisableDrawLayer("BACKGROUND")
	_G.AuctionProgressFrame:DisableDrawLayer("ARTWORK")
	self:keepFontStrings(_G.AuctionProgressBar)
	self:moveObject{obj=_G.AuctionProgressBar.Text, y=-2}
	self:glazeStatusBar(_G.AuctionProgressBar, 0)

	btnName, obj = nil, nil

end

function aObj:BankFrame()
	if not self.db.profile.BankFrame or self.initialized.BankFrame then return end
	self.initialized.BankFrame = true

	self:skinEditBox{obj=_G.BankItemSearchBox, regs={6, 7}, mi=true, noHeight=true, noMove=true} -- 6 is text, 7 is icon
	self:removeInset(_G.BankFrameMoneyFrameInset)
	_G.BankFrameMoneyFrameBorder:DisableDrawLayer("BACKGROUND")
	self:addSkinFrame{obj=_G.BankFrame, ft=ftype, kfs=true, x1=-3, y1=2, x2=1, y2=-4}
	self:skinTabs{obj=_G.BankFrame, x1=6, y1=0, x2=-6, y2=2}
	self:keepFontStrings(_G.BankSlotsFrame)
	-- ReagentBankFrame
	self:addSkinFrame{obj=_G.ReagentBankFrame.UnlockInfo, ft=ftype, kfs=true, ofs=-4}
	_G.ReagentBankFrame:DisableDrawLayer("ARTWORK")
	_G.ReagentBankFrame:DisableDrawLayer("BACKGROUND")
	_G.ReagentBankFrame:DisableDrawLayer("BORDER")

	if self.modBtnBs then
		self:addButtonBorder{obj=_G.BankItemAutoSortButton, ofs=0, y1=1}
		local btn
		-- add button borders to bank items
		for i = 1, 28 do
			btn = _G["BankFrameItem" .. i]
			self:addButtonBorder{obj=btn, ibt=true, reParent={btn.IconQuestTexture}}
			if not btn.hasItem then
				btn.sbb:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
			end
		end
		btn = nil
		-- add button borders to bags
		for i = 1, _G.NUM_BANKBAGSLOTS do
			self:addButtonBorder{obj=_G.BankSlotsFrame["Bag" .. i], ibt=true}
		end
		-- add button borders to reagent bank items
		self:SecureHookScript(_G.ReagentBankFrame, "OnShow", function(this)
			local btn
			for i = 1, 7 * 7 * 2 do
				btn = this["Item" .. i]
				self:addButtonBorder{obj=btn, ibt=true, reParent={btn.IconQuestTexture}}
				if not btn.hasItem then
					btn.sbb:SetBackdropBorderColor(0.5, 0.5, 0.5, 0.25)
				end
			end
			btn = nil
		end)
	end
end

function aObj:BarbershopUI() -- LoD
	if not self.db.profile.BarbershopUI or self.initialized.Barbershop then return end
	self.initialized.Barbershop = true

	self:keepFontStrings(_G.BarberShopFrameMoneyFrame)
	self:addSkinFrame{obj=_G.BarberShopFrame, ft=ftype, kfs=true, x1=35, y1=-32, x2=-32, y2=42}
	for i = 1, #_G.BarberShopFrame.Selector do
		 self:addButtonBorder{obj=self:getChild(_G.BarberShopFrame.Selector[i], 1), ofs=-2}
		 self:addButtonBorder{obj=self:getChild(_G.BarberShopFrame.Selector[i], 2), ofs=-2}
	end
	-- Banner Frame
	self:keepFontStrings(_G.BarberShopBannerFrame)
	_G.BarberShopBannerFrameCaption:ClearAllPoints()
	_G.BarberShopBannerFrameCaption:SetPoint("CENTER", _G.BarberShopFrame, "TOP", 0, -46)
	_G.BarberShopBannerFrame:SetParent(_G.BarberShopFrame) -- make text appear above skinFrame

end

function aObj:BlackMarketUI() -- LoD
	if not self.db.profile.BlackMarketUI or self.initialized.BlackMarketUI then return end
	self.initialized.BlackMarketUI = true

	-- move title text
	self:moveObject{obj=self:getRegion(_G.BlackMarketFrame, 22), y=-4}
	-- HotDeal frame
	self:keepFontStrings(_G.BlackMarketFrame.HotDeal)
	self:addButtonBorder{obj=_G.BlackMarketFrame.HotDeal.Item, bmit=true}

	-- column headings
	local obj
	for _, v in pairs{"Name", "Level", "Type", "Duration", "HighBidder", "CurrentBid"} do
		obj = _G.BlackMarketFrame["Column" .. v]
		self:keepFontStrings(obj)
		self:addSkinFrame{obj=obj, ft=ftype, nb=true, aso={bd=5}}
	end
	self:skinSlider{obj=_G.BlackMarketScrollFrame.ScrollBar, adj=-4}
	_G.BlackMarketFrame.MoneyFrameBorder:DisableDrawLayer("BACKGROUND")
	self:skinMoneyFrame{obj=_G.BlackMarketBidPrice}
	self:addSkinFrame{obj=_G.BlackMarketFrame, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-2}

	local function skinSFButtons(scrollFrame)
		local btn
		for i = 1, #scrollFrame.buttons do
			btn = scrollFrame.buttons[i]
			self:keepFontStrings(btn)
			-- btn.Item.IconBorder:SetTexture(nil)
			self:addButtonBorder{obj=btn.Item, bmit=true}
		end
	end
	if not self.isPTR then
		self:SecureHook(_G.BlackMarketScrollFrame, "update", function(this)
			skinSFButtons(this)
		end)
		-- skin existing buttons
		skinSFButtons(_G.BlackMarketScrollFrame)
	else
		self:SecureHook("BlackMarketScrollFrame_Update", function(this)
			skinSFButtons(_G.BlackMarketScrollFrame)
		end)
	end

end

function aObj:FlightMap() -- LoD
	if not self.db.profile.FlightMap or self.initialized.FlightMap then return end
	self.initialized.FlightMap = true

	self:keepFontStrings(_G.FlightMapFrame.BorderFrame)
	self:addSkinFrame{obj=_G.FlightMapFrame, ft=ftype, ofs=3, x2=2}
	_G.FlightMapFrame.sf:SetFrameStrata("LOW") -- allow map textures to be visible

	-- hook this to remove ZoneLabel background texture
	for dataProvider in pairs(_G.FlightMapFrame.dataProviders) do
		if dataProvider.ZoneLabel then
			dataProvider.ZoneLabel.TextBackground:SetTexture(nil)
			-- hook this to handle when Map re-opened
			self:SecureHook(dataProvider.ZoneLabel.dataProvider, "RefreshAllData", function(this, fromOnShow)
				this.ZoneLabel.TextBackground:SetTexture(nil)
			end)
		end
	end

end

local function setupQuestDisplayColours()

	_G.NORMAL_QUEST_DISPLAY = "|cff" .. aObj:RGBPercToHex(aObj.HTr, aObj.HTg, aObj.HTb) .. "%s|r"
	_G.TRIVIAL_QUEST_DISPLAY = "|cff" .. aObj:RGBPercToHex(aObj.BTr, aObj.BTg, aObj.BTb) .. "%s (low level)|r"
	_G.IGNORED_QUEST_DISPLAY = "|cff" .. aObj:RGBPercToHex(aObj.ITr, aObj.ITg, aObj.ITb) .. "%s (ignored)|r"

end
function aObj:GossipFrame()
	if not self.db.profile.GossipFrame or self.initialized.GossipFrame then return end
	self.initialized.GossipFrame = true

	setupQuestDisplayColours()

	self:keepFontStrings(_G.GossipFrameGreetingPanel)
	_G.GossipGreetingText:SetTextColor(self.HTr, self.HTg, self.HTb)
	if not self.isPTR then
		self:skinScrollBar{obj=_G.GossipGreetingScrollFrame}
	else
		self:skinSlider{obj=_G.GossipGreetingScrollFrame.ScrollBar, size=3, rt="artwork"}
	end
	for i = 1, _G.NUMGOSSIPBUTTONS do
		self:getRegion(_G["GossipTitleButton" .. i], 3):SetTextColor(self.BTr, self.BTg, self.BTb)
	end
	self:addSkinFrame{obj=_G.GossipFrame, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-2}

	-- NPCFriendshipStatusBar
	self:removeRegions(_G.NPCFriendshipStatusBar, {1, 3, 4, 5 ,6})
	self:glazeStatusBar(_G.NPCFriendshipStatusBar, 0,  self:getRegion(_G.NPCFriendshipStatusBar, 7))

end

function aObj:GuildRegistrar()
	if not self.db.profile.GuildRegistrar or self.initialized.GuildRegistrar then return end
	self.initialized.GuildRegistrar = true

	self:keepFontStrings(_G.GuildRegistrarGreetingFrame)
	_G.AvailableServicesText:SetTextColor(self.HTr, self.HTg, self.HTb)
	_G.GuildRegistrarPurchaseText:SetTextColor(self.BTr, self.BTg, self.BTb)
	for i = 1, 2 do
		self:getRegion(_G["GuildRegistrarButton" .. i], 3):SetTextColor(self.BTr, self.BTg, self.BTb)
	end
	self:skinEditBox{obj=_G.GuildRegistrarFrameEditBox}

	self:addSkinFrame{obj=_G.GuildRegistrarFrame, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-2}

end

function aObj:ItemUpgradeUI() -- LoD
	if not self.db.profile.ItemUpgradeUI or self.initialized.ItemUpgradeUI then return end
	self.initialized.ItemUpgradeUI = true

	_G.ItemUpgradeFrame.HorzBar:SetTexture(nil)
	_G.ItemUpgradeFrame.ItemButton.IconTexture:SetAlpha(0)
	_G.ItemUpgradeFrame.ItemButton.Grabber:SetTexture(nil)
	_G.ItemUpgradeFrame.ItemButton.TextFrame:SetTexture(nil)
	_G.ItemUpgradeFrame.ItemButton.TextGrabber:SetTexture(nil)
	_G.ItemUpgradeFrame.MissingDescription:SetTextColor(self.BTr, self.BTg, self.BTb)
	_G.ItemUpgradeFrame.NoMoreUpgrades:SetTextColor(self.BTr, self.BTg, self.BTb)
	_G.ItemUpgradeFrame.TitleTextLeft:SetTextColor(self.BTr, self.BTg, self.BTb)
	_G.ItemUpgradeFrame.TitleTextRight:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:addButtonBorder{obj=_G.ItemUpgradeFrame.ItemButton, relTo=_G.ItemUpgradeFrame.ItemButton.IconTexture, ofs=1}
	_G.ItemUpgradeFrame.ItemButton.Frame:SetTexture(nil)
	_G.ItemUpgradeFrame.ItemButton.ItemName:SetTextColor(self.BTr, self.BTg, self.BTb)
	_G.ItemUpgradeFrame.ItemButton.MissingText:SetTextColor(self.BTr, self.BTg, self.BTb)
	_G.ItemUpgradeFrameMoneyFrame:DisableDrawLayer("BACKGROUND")
	_G.ItemUpgradeFrame.ButtonFrame.ButtonBorder:SetTexture(nil)
	_G.ItemUpgradeFrame.ButtonFrame.ButtonBottomBorder:SetTexture(nil)
	self:addSkinFrame{obj=_G.ItemUpgradeFrame, ft=ftype, kfs=true, rmbt=true, ofs=2, x2=1}

	-- hook this to hide the ItemButton texture if empty
	self:SecureHook("ItemUpgradeFrame_Update", function()
		local icon = _G.GetItemUpgradeItemInfo()
		if icon then
			_G.ItemUpgradeFrame.ItemButton.IconTexture:SetAlpha(1)
		else
			_G.ItemUpgradeFrame.ItemButton.IconTexture:SetAlpha(0)
		end
	end)
	-- hook this to remove background texture from stat lines
	self:SecureHook("ItemUpgradeFrame_GetStatRow", function(index, tryAdd)
		if _G.ItemUpgradeFrame.LeftStat[index] then _G.ItemUpgradeFrame.LeftStat[index].BG:SetTexture(nil) end
		if _G.ItemUpgradeFrame.RightStat[index] then _G.ItemUpgradeFrame.RightStat[index].BG:SetTexture(nil) end
	end)

end

function aObj:MerchantFrame()
	if not self.db.profile.MerchantFrame or self.initialized.MerchantFrame then return end
	self.initialized.MerchantFrame = true

	-- display limited availability item's stock count even when zero
	self:SecureHook("SetItemButtonStock", function(button, numInStock)
		if numInStock == 0 and not button == _G.MerchantBuyBackItemItemButton then
			_G[button:GetName() .. "Stock"]:SetFormattedText(_G.MERCHANT_STOCK, numInStock)
			_G[button:GetName() .. "Stock"]:Show()
		end
	end)
	-- Items/Buyback Items
	local btnName
	for i = 1, _G.math.max(_G.MERCHANT_ITEMS_PER_PAGE, _G.BUYBACK_ITEMS_PER_PAGE) do
		btnName = "MerchantItem" .. i
		_G[btnName .. "NameFrame"]:SetTexture(nil)
		if not self.modBtnBs then
			_G[btnName .. "SlotTexture"]:SetTexture(self.esTex)
		else
			_G[btnName .. "SlotTexture"]:SetTexture(nil)
			self:addButtonBorder{obj=_G[btnName .. "ItemButton"], ibt=true}
		end
	end
	btnName = "MerchantBuyBackItem"
	_G[btnName .. "NameFrame"]:SetTexture(nil)
	if self.modBtnBs then
		_G[btnName .. "SlotTexture"]:SetTexture(nil)
		self:addButtonBorder{obj=_G[btnName .. "ItemButton"], ibt=true}
		-- remove surrounding border (diff=0.01375)
		self:getRegion(_G.MerchantRepairItemButton, 1):SetTexCoord(0.01375, 0.2675, 0.01375, 0.54875)
		_G.MerchantRepairAllIcon:SetTexCoord(0.295, 0.54875, 0.01375, 0.54875)
		_G.MerchantGuildBankRepairButtonIcon:SetTexCoord(0.57375, 0.83, 0.01375, 0.54875)
		self:addButtonBorder{obj=_G.MerchantRepairAllButton}
		self:addButtonBorder{obj=_G.MerchantRepairItemButton}
		self:addButtonBorder{obj=_G.MerchantGuildBankRepairButton}
	else
		_G[btnName .. "SlotTexture"]:SetTexture(self.esTex)
	end
	btnName = nil
	self:removeRegions(_G.MerchantPrevPageButton, {2})
	self:addButtonBorder{obj=_G.MerchantPrevPageButton, ofs=-2, y1=-3, x2=-3}
	self:removeRegions(_G.MerchantNextPageButton, {2})
	self:addButtonBorder{obj=_G.MerchantNextPageButton, ofs=-2, y1=-3, x2=-3}
	self:skinTabs{obj=_G.MerchantFrame}
	self:skinDropDown{obj=_G.MerchantFrameLootFilter}
	self:removeInset(_G.MerchantExtraCurrencyInset)
	_G.MerchantExtraCurrencyBg:DisableDrawLayer("BACKGROUND")
	self:removeInset(_G.MerchantMoneyInset)
	_G.MerchantMoneyBg:DisableDrawLayer("BACKGROUND")
	self:addSkinFrame{obj=_G.MerchantFrame, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-6}

end

function aObj:Petition()
	if not self.db.profile.Petition or self.initialized.Petition then return end
	self.initialized.Petition = true

	_G.PetitionFrameCharterTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
	_G.PetitionFrameCharterName:SetTextColor(self.BTr, self.BTg, self.BTb)
	_G.PetitionFrameMasterTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
	_G.PetitionFrameMasterName:SetTextColor(self.BTr, self.BTg, self.BTb)
	_G.PetitionFrameMemberTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
	for i = 1, 9 do
		_G["PetitionFrameMemberName" .. i]:SetTextColor(self.BTr, self.BTg, self.BTb)
	end
	_G.PetitionFrameInstructions:SetTextColor(self.BTr, self.BTg, self.BTb)

	self:addSkinFrame{obj=_G.PetitionFrame, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-2}

end

function aObj:PetStableFrame()
	if not self.db.profile.PetStableFrame or self.initialized.PetStableFrame then return end
	self.initialized.PetStableFrame = true

	self:makeMFRotatable(_G.PetStableModel)

	_G.PetStableFrameModelBg:Hide()
	_G.PetStableModelShadow:Hide()
	_G.PetStableFrame.LeftInset:DisableDrawLayer("BORDER")
	_G.PetStableActiveBg:Hide()
	self:addButtonBorder{obj=_G.PetStablePetInfo, relTo=_G.PetStableSelectedPetIcon}
	local btn
	for i = 1, _G.NUM_PET_ACTIVE_SLOTS do
		btn = _G["PetStableActivePet" .. i]
		btn.Border:Hide()
		if not self.modBtnBs then
			self:resizeEmptyTexture(btn.Background)
		else
			btn.Background:Hide()
			self:addButtonBorder{obj=btn}
		end
	end
	for i = 1, _G.NUM_PET_STABLE_SLOTS do
		btn = _G["PetStableStabledPet" .. i]
		if not self.modBtnBs then
			self:resizeEmptyTexture(btn.Background)
		else
			btn.Background:Hide()
			self:addButtonBorder{obj=btn}
		end
	end
	_G.PetStableFrame.BottomInset:DisableDrawLayer("BORDER")
	_G.PetStableFrameStableBg:Hide()
	self:addSkinFrame{obj=_G.PetStableFrame, ft=ftype, kfs=true, ri=true, y1=2, x2=1}
	self:addButtonBorder{obj=_G.PetStableNextPageButton, ofs=0}
	self:addButtonBorder{obj=_G.PetStablePrevPageButton, ofs=0}

end

function aObj:QuestChoice() -- LoD
	if not self.db.profile.QuestChoice or self.initialized.QuestChoice then return end
	self.initialized.QuestChoice = true

	_G.QuestChoiceFrame.DummyString:SetTextColor(self.BTr, self.BTg, self.BTb)
	for i = 1, 4 do
		_G.QuestChoiceFrame["Option" .. i].OptionText:SetTextColor(self.HTr, self.HTg, self.HTb)
		self:addButtonBorder{obj=_G.QuestChoiceFrame["Option" .. i].Rewards.Item, relTo=_G.QuestChoiceFrame["Option" .. i].Rewards.Item.Icon}
		_G.QuestChoiceFrame["Option" .. i].Rewards.Item.Name:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G.QuestChoiceFrame["Option" .. i].Rewards.ReputationsFrame.Reputation1.Faction:SetTextColor(self.BTr, self.BTg, self.BTb)
	end
	self:addSkinFrame{obj=_G.QuestChoiceFrame, ft=ftype, kfs=true, ofs=-13, y1=-12}

end

function aObj:QuestFrame()
	if not self.db.profile.QuestFrame or self.initialized.QuestFrame then return end
	self.initialized.QuestFrame = true

	setupQuestDisplayColours()

	self:RawHook("QuestFrame_SetTitleTextColor", function(fontString, ...)
		fontString:SetTextColor(self.HTr, self.HTg, self.HTb)
	end, true)
	self:RawHook("QuestFrame_SetTextColor", function(fontString, ...)
		fontString:SetTextColor(self.BTr, self.BTg, self.BTb)
	end, true)

	self:addSkinFrame{obj=_G.QuestFrame, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-2}
-->>--	Reward Panel
	self:keepFontStrings(_G.QuestFrameRewardPanel)
	if not self.isPTR then
		self:skinScrollBar{obj=_G.QuestRewardScrollFrame}
	else
		self:skinSlider{obj=_G.QuestRewardScrollFrame.ScrollBar, size=3, rt="artwork"}
	end
-->>--	Progress Panel
	self:keepFontStrings(_G.QuestFrameProgressPanel)
	_G.QuestProgressTitleText:SetTextColor(self.HTr, self.HTg, self.HTb)
	_G.QuestProgressText:SetTextColor(self.BTr, self.BTg, self.BTb)
	_G.QuestProgressRequiredMoneyText:SetTextColor(self.BTr, self.BTg, self.BTb)
	_G.QuestProgressRequiredItemsText:SetTextColor(self.HTr, self.HTg, self.HTb)
	if not self.isPTR then
		self:skinScrollBar{obj=_G.QuestProgressScrollFrame}
	else
		self:skinSlider{obj=_G.QuestProgressScrollFrame.ScrollBar, size=3, rt="artwork"}
	end
	local btnName
	for i = 1, _G.MAX_REQUIRED_ITEMS do
		btnName = "QuestProgressItem" .. i
		_G[btnName .. "NameFrame"]:SetTexture(nil)
		self:addButtonBorder{obj=_G[btnName], libt=true}
	end
	btnName = nil
	self:SecureHook("QuestFrameProgressItems_Update", function()
		local r, g ,b = _G.QuestProgressRequiredMoneyText:GetTextColor()
		-- if red colour is less than 0.2 then it needs to be coloured
		if r < 0.2 then
			_G.QuestProgressRequiredMoneyText:SetTextColor(self.BTr - r, self.BTg - g, self.BTb - b)
		end
	end)

-->>--	Detail Panel
	self:keepFontStrings(_G.QuestFrameDetailPanel)
	if not self.isPTR then
		self:skinScrollBar{obj=_G.QuestDetailScrollFrame}
	else
		self:skinSlider{obj=_G.QuestDetailScrollFrame.ScrollBar, size=3, rt="artwork"}
	end

-->>--	Greeting Panel
	self:keepFontStrings(_G.QuestFrameGreetingPanel)
	self:keepFontStrings(_G.QuestGreetingScrollChildFrame) -- hide Horizontal Break texture
	if not self.isPTR then
		self:skinScrollBar{obj=_G.QuestGreetingScrollFrame}
	else
		self:skinSlider{obj=_G.QuestGreetingScrollFrame.ScrollBar, size=3, rt="artwork"}
	end
	if _G.QuestFrameGreetingPanel:IsShown() then
		_G.GreetingText:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G.CurrentQuestsText:SetTextColor(self.HTr, self.HTg, self.HTb)
		_G.AvailableQuestsText:SetTextColor(self.HTr, self.HTg, self.HTb)
	end

-->>-- QuestNPCModel
	self:keepFontStrings(_G.QuestNPCModelTextFrame)
	if not self.isPTR then
		self:skinScrollBar{obj=_G.QuestNPCModelTextScrollFrame}
	else
		self:skinSlider{obj=_G.QuestNPCModelTextScrollFrame.ScrollBar, size=3}
	end
	self:addSkinFrame{obj=_G.QuestNPCModel, ft=ftype, kfs=true, ofs=4, y2=-81} -- similar to GuildNewsBossModel

	self:QuestInfo()

end

function aObj:QuestInfo()
	if self.initialized.QuestInfo then return end
	self.initialized.QuestInfo = true

	local function skinRewards(frame)

		frame.ItemChooseText:SetTextColor(self.BTr, self.BTg, self.BTb)
		frame.ItemReceiveText:SetTextColor(self.BTr, self.BTg, self.BTb)
		frame.PlayerTitleText:SetTextColor(self.BTr, self.BTg, self.BTb)
		-- SpellReward
		for spellBtn in frame.spellRewardPool:EnumerateActive() do
			self:addButtonBorder{obj=spellBtn, relTo=spellBtn.Icon}
			spellBtn.NameFrame:SetTexture(nil)
			spellBtn:DisableDrawLayer("OVERLAY")
		end
		-- FollowerReward
		for flwrBtn in frame.followerRewardPool:EnumerateActive() do
			flwrBtn.BG:SetTexture(nil)
			flwrBtn.PortraitFrame.PortraitRing:SetTexture(nil)
			flwrBtn.PortraitFrame.LevelBorder:SetAlpha(0) -- texture changed
			if flwrBtn.PortraitFrame.PortraitRingCover then flwrBtn.PortraitFrame.PortraitRingCover:SetTexture(nil) end
		end
		for spellLine in frame.spellHeaderPool:EnumerateActive() do
			spellLine:SetVertexColor(aObj.BTr, aObj.BTg, aObj.BTb)
		end

	end
	local function updateQIDisplay()

		-- headers
		_G.QuestInfoTitleHeader:SetTextColor(aObj.HTr, aObj.HTg, aObj.HTb)
		_G.QuestInfoDescriptionHeader:SetTextColor(aObj.HTr, aObj.HTg, aObj.HTb)
		_G.QuestInfoObjectivesHeader:SetTextColor(aObj.HTr, aObj.HTg, aObj.HTb)
		_G.QuestInfoRewardsFrame.Header:SetTextColor(aObj.HTr, aObj.HTg, aObj.HTb)
		-- other text
		_G.QuestInfoDescriptionText:SetTextColor(aObj.BTr, aObj.BTg, aObj.BTb)
		if self.isPTR then
			_G.QuestInfoQuestType:SetTextColor(self.BTr, self.BTg, self.BTb)
		end
		_G.QuestInfoObjectivesText:SetTextColor(aObj.BTr, aObj.BTg, aObj.BTb)
		_G.QuestInfoGroupSize:SetTextColor(aObj.BTr, aObj.BTg, aObj.BTb)
		_G.QuestInfoRewardText:SetTextColor(aObj.BTr, aObj.BTg, aObj.BTb)
		local r, g, b = _G.QuestInfoRequiredMoneyText:GetTextColor()
		_G.QuestInfoRequiredMoneyText:SetTextColor(aObj.BTr - r, aObj.BTg - g, aObj.BTb - b)
		-- reward frame text
		_G.QuestInfoRewardsFrame.ItemChooseText:SetTextColor(aObj.BTr, aObj.BTg, aObj.BTb)
		_G.QuestInfoRewardsFrame.ItemReceiveText:SetTextColor(aObj.BTr, aObj.BTg, aObj.BTb)
		_G.QuestInfoRewardsFrame.PlayerTitleText:SetTextColor(aObj.BTr, aObj.BTg, aObj.BTb)
		_G.QuestInfoRewardsFrame.XPFrame.ReceiveText:SetTextColor(aObj.BTr, aObj.BTg, aObj.BTb)

		-- skin rewards
		skinRewards(_G.QuestInfoRewardsFrame)
		skinRewards(_G.MapQuestInfoRewardsFrame)

		-- change text colour for all spell rewards (spells, followers etc)
		for spellLine in _G.QuestInfoRewardsFrame.spellHeaderPool:EnumerateActive() do
			spellLine:SetVertexColor(aObj.BTr, aObj.BTg, aObj.BTb)
		end
		for spellLine in _G.MapQuestInfoRewardsFrame.spellHeaderPool:EnumerateActive() do
			spellLine:SetVertexColor(aObj.BTr, aObj.BTg, aObj.BTb)
		end

		-- Objectives
		local obj, r, g, b
		for i = 1, #_G.QuestInfoObjectivesFrame.Objectives do
			obj = _G.QuestInfoObjectivesFrame.Objectives[i]
			r, g ,b = obj:GetTextColor()
			-- if red colour is less than 0.2 then it needs to be coloured
			if r < 0.2 then
				obj:SetTextColor(aObj.BTr - r, aObj.BTg - g, aObj.BTb - b)
			end
		end
		r, g, b = nil, nil, nil

		-- QuestInfoSpecialObjectives Frame
		_G.QuestInfoSpellObjectiveLearnLabel:SetTextColor(aObj.BTr, aObj.BTg, aObj.BTb)
		_G.QuestInfoSpellObjectiveFrameNameFrame:SetTexture(nil)
		_G.QuestInfoSpellObjectiveFrameSpellBorder:SetTexture(nil)
		aObj:addButtonBorder{obj=_G.QuestInfoSpellObjectiveFrame, relTo=_G.QuestInfoSpellObjectiveFrame.Icon}
		obj = nil

	end
	self:SecureHook("QuestInfo_Display", function(...)
		updateQIDisplay()
	end)
	-- update any Quest Info that may be already displayed
	updateQIDisplay()

	_G.QuestInfoTimerText:SetTextColor(self.BTr, self.BTg, self.BTb)
	_G.QuestInfoAnchor:SetTextColor(self.BTr, self.BTg, self.BTb)

	-- QuestInfoRequiredMoneyFrame
	self:SecureHook("QuestInfo_ShowRequiredMoney", function()
		local r, g ,b = _G.QuestInfoRequiredMoneyText:GetTextColor()
		-- if red value is less than 0.2 then it needs to be coloured
		if r < 0.2 then
			_G.QuestInfoRequiredMoneyText:SetTextColor(self.BTr - r, self.BTg - g, self.BTb - b)
		end
		r, g, b = nil, nil, nil
	end)

	-->>-- QuestInfoRewardsFrame
	local frame = _G.QuestInfoRewardsFrame
	skinRewards(frame)
	_G.QuestInfoRewardsFrame.XPFrame.ReceiveText:SetTextColor(self.BTr, self.BTg, self.BTb)
	-- SkillPointFrame
	local spf = frame.SkillPointFrame
	spf.NameFrame:SetTexture(nil)
	self:addButtonBorder{obj=spf, relTo=spf.Icon, reParent={spf.CircleBackground, spf.CircleBackgroundGlow, spf.ValueText}}
	spf = nil
	-- HonorFrame
	local hf = frame.HonorFrame
	hf.NameFrame:SetTexture(nil)
	self:addButtonBorder{obj=hf, relTo=hf.Icon, reParent={hf.Count}}
	hf = nil
	-- ArtifactXPFrame
	local axp = frame.ArtifactXPFrame
	axp.NameFrame:SetTexture(nil)
	self:addButtonBorder{obj=axp, relTo=axp.Icon, reParent={axp.Count}}
	axp = nil
	-- QuestInfoPlayerTitleFrame
	self:addButtonBorder{obj=_G.QuestInfoPlayerTitleFrame, relTo=_G.QuestInfoPlayerTitleFrame.Icon}
	self:removeRegions(_G.QuestInfoPlayerTitleFrame, {2, 3, 4,}) -- NameFrame textures

	-->>-- MapQuestInfoRewards Frame
	frame = _G.MapQuestInfoRewardsFrame
	skinRewards(frame)
	-- other rewards
	for _, v in pairs{"XPFrame", "HonorFrame", "ArtifactXPFrame", "MoneyFrame", "SkillPointFrame", "TitleFrame"} do
		frame[v].NameFrame:SetTexture(nil)
		if not v == "SkillPointFrame" then
			self:addButtonBorder{obj=frame[v], relTo=frame[v].Icon}
		else
			self:addButtonBorder{obj=frame[v], relTo=frame[v].Icon, reParent={frame[v].CircleBackground, frame[v].CircleBackgroundGlow, frame[v].ValueText}}
		end
	end

	local function skinQIRB(rewardsFrame, index)
		-- aObj:Debug("skinQIRB: [%s, %s]", rewardsFrame, index)
		-- N.B. The MapQuestInfoRewardsFrame uses SmallItemButtonTemplate (libt works atm)
		if rewardsFrame
		and not rewardsFrame.RewardButtons[index].sbb
		then
			rewardsFrame.RewardButtons[index].NameFrame:SetTexture(nil)
			aObj:addButtonBorder{obj=rewardsFrame.RewardButtons[index], libt=true}
		end
	end
	self:SecureHook("QuestInfo_GetRewardButton", function(...)
		skinQIRB(...)
	end)
	-- skin any existing Reward button
	skinQIRB()

end

function aObj:SideDressUpFrame()
	if not self.db.profile.SideDressUpFrame or self.initialized.SideDressUpFrame then return end
	self.initialized.SideDressUpFrame = true

	_G.SideDressUpModel.controlFrame:DisableDrawLayer("BACKGROUND")
	_G.SideDressUpModelCloseButton:DisableDrawLayer("BACKGROUND")
	_G.SideDressUpFrame:DisableDrawLayer("BACKGROUND")
	self:addSkinFrame{obj=_G.SideDressUpFrame, ft=ftype, bg=true, x1=-6, y1=-3, x2=-2}
	self:skinButton{obj=_G.SideDressUpModelCloseButton, cb=true}

end

function aObj:Tabard()
	if not self.db.profile.Tabard or self.initialized.Tabard then return end
	self.initialized.Tabard = true

	self:makeMFRotatable(_G.TabardModel)
	_G.TabardFrameCostFrame:SetBackdrop(nil)
	self:keepFontStrings(_G.TabardFrameCustomizationFrame)
	for i = 1, 5 do
		self:keepFontStrings(_G["TabardFrameCustomization" .. i])
		self:addButtonBorder{obj=_G["TabardFrameCustomization" .. i .. "LeftButton"], ofs=-2}
		self:addButtonBorder{obj=_G["TabardFrameCustomization" .. i .. "RightButton"], ofs=-2}
	end

	self:keepRegions(_G.TabardFrame, {8, 29, 30, 31 ,32, 33, 34}) -- N.B. region 8, 33 & 34 are text, 29-32 are icon texture
	self:removeInset(_G.TabardFrameMoneyInset)
	_G.TabardFrameMoneyBg:DisableDrawLayer("BACKGROUND")
	self:addSkinFrame{obj=_G.TabardFrame, ft=ftype, ri=true, x1=-3, y1=2, x2=1, y2=-2}

end

function aObj:TaxiFrame()
	if not self.db.profile.TaxiFrame or self.initialized.TaxiFrame then return end
	self.initialized.TaxiFrame = true

	_G.TaxiFrame:DisableDrawLayer("OVERLAY")
	_G.TaxiFrame:DisableDrawLayer("BORDER")
	self:addSkinFrame{obj=_G.TaxiFrame, ft=ftype, x1=-3, y1=2, x2=1, y2=-2}

end

function aObj:TrainerUI() -- LoD
	if not self.db.profile.TrainerUI or self.initialized.TrainerUI then return end
	self.initialized.TrainerUI = true

	self:skinDropDown{obj=_G.ClassTrainerFrameFilterDropDown}
	_G.ClassTrainerStatusBarLeft:SetAlpha(0)
	_G.ClassTrainerStatusBarRight:SetAlpha(0)
	_G.ClassTrainerStatusBarMiddle:SetAlpha(0)
	_G.ClassTrainerStatusBarSkillRank:SetPoint("CENTER", _G.ClassTrainerStatusBar) -- Blizzard bug
	self:glazeStatusBar(_G.ClassTrainerStatusBar, 0,  _G.ClassTrainerStatusBarBackground)
	local btn = _G.ClassTrainerFrame.skillStepButton
	btn:GetNormalTexture():SetTexture(nil)
	self:addButtonBorder{obj=btn, relTo=btn.icon}
	self:skinSlider{obj=_G.ClassTrainerScrollFrameScrollBar, adj=-4, size=3}
	self:removeInset(_G.ClassTrainerFrame.bottomInset)
	for i = 1, #_G.ClassTrainerFrame.scrollFrame.buttons do
		btn = _G.ClassTrainerFrame.scrollFrame.buttons[i]
		btn:GetNormalTexture():SetTexture(nil)
		self:addButtonBorder{obj=btn, relTo=btn.icon}
	end
	self:addSkinFrame{obj=_G.ClassTrainerFrame, ft=ftype, kfs=true, ri=true, rmbt=true, y1=2, x2=1, y2=-2}

end

function aObj:VoidStorageUI() -- LoD
	if not self.db.profile.VoidStorageUI or self.initialized.VoidStorageUI then return end
	self.initialized.VoidStorageUI = true

	self:addSkinFrame{obj=_G.VoidStoragePurchaseFrame, ft=ftype, kfs=true}
	self:keepFontStrings(_G.VoidStorageBorderFrame)
	local frame
	for _, v in pairs{"Deposit", "Withdraw", "Storage", "Cost"} do
		frame = _G["VoidStorage" .. v .. "Frame"]
		frame:DisableDrawLayer("BACKGROUND")
		frame:DisableDrawLayer("BORDER")
	end
	self:addSkinFrame{obj=_G.VoidStorageFrame, ft=ftype, kfs=true, y1=2, x2=1}
	self:skinEditBox{obj=_G.VoidItemSearchBox, regs={6, 7}, mi=true, noHeight=true, noMove=true} -- 6 is text, 7 is icon
	for i = 1, 2 do
		_G.VoidStorageFrame["Page" .. i]:DisableDrawLayer("BACKGROUND")
		self:addButtonBorder{obj=_G.VoidStorageFrame["Page" .. i]}
	end

end
