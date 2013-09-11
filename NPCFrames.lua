local aName, aObj = ...
local _G = _G
local ftype = "n"

-- Add locals to see if it speeds things up
local pairs = _G.pairs

function aObj:AuctionUI() -- LoD
	if not self.db.profile.AuctionUI or self.initialized.AuctionUI then return end
	self.initialized.AuctionUI = true

	-- hide filter texture when filter is clicked
	self:SecureHook("FilterButton_SetType", function(button, type, text, isLast)
		_G[button:GetName() .. "NormalTexture"]:SetAlpha(0)
	end)

	self:skinTabs{obj=_G.AuctionFrame, lod=true}
	self:addSkinFrame{obj=_G.AuctionFrame, ft=ftype, kfs=true, hdr=true, bgen=1, x1=10, y1=-11, y2=5} -- N.B. bgen=1 to prevent other addons buttons being skinned
-->>--	Browse Frame
	for k, v in pairs{"Name", "MinLevel", "MaxLevel"} do
		local obj = _G["Browse" .. v]
		self:skinEditBox{obj=obj, regs={9}}
		self:moveObject{obj=obj, x=v=="MaxLevel" and -6 or -4, y=v~="MaxLevel" and 3 or 0}
	end
	self:skinDropDown{obj=_G.BrowseDropDown, x2=110}
	for _, v in pairs{"Quality", "Level", "Duration", "HighBidder", "CurrentBid"} do
		local obj = _G["Browse" .. v .. "Sort"]
		self:keepRegions(obj, {4, 5, 6}) -- N.B. region 4 is the text, 5 is the arrow, 6 is the highlight
		self:addSkinFrame{obj=obj, ft=ftype, nb=true}
	end
	self:skinScrollBar{obj=_G.BrowseFilterScrollFrame}
	for i = 1, _G.NUM_FILTERS_TO_DISPLAY do
		self:keepRegions(_G["AuctionFilterButton" .. i], {3, 4}) -- N.B. region 3 is the highlight, 4 is the text
		self:addSkinFrame{obj=_G["AuctionFilterButton" .. i], ft=ftype, nb=true}
	end
	self:skinScrollBar{obj=_G.BrowseScrollFrame}
	for i = 1, _G.NUM_BROWSE_TO_DISPLAY do
		local btnName = "BrowseButton" .. i
		if _G[btnName].Orig then break end -- Auctioneer CompactUI loaded
		self:keepFontStrings(_G[btnName])
		if _G[btnName .. "Highlight"] then _G[btnName .. "Highlight"]:SetAlpha(1) end
		_G[btnName .. "ItemCount"]:SetDrawLayer("ARTWORK") -- fix for 3.3.3 bug
		self:addButtonBorder{obj=_G[btnName .. "Item"], ibt=true}
	end
	self:skinMoneyFrame{obj=_G.BrowseBidPrice, moveSEB=true}
	self:addButtonBorder{obj=_G.BrowsePrevPageButton, ofs=-2, y1=-3, x2=-3}
	self:addButtonBorder{obj=_G.BrowseNextPageButton, ofs=-2, y1=-3, x2=-3}

-->>--	Bid Frame
	for _, v in pairs{"Quality", "Level", "Duration", "Buyout", "Status", "Bid"} do
		local obj = _G["Bid" .. v .. "Sort"]
		self:keepRegions(obj, {4, 5, 6}) -- N.B. region 4 is the text, 5 is the arrow, 6 is the highlight
		self:addSkinFrame{obj=obj, ft=ftype, nb=true}
	end
	for i = 1, _G.NUM_BIDS_TO_DISPLAY do
		local btnName = "BidButton" .. i
		self:keepFontStrings(_G[btnName])
		if _G[btnName .. "Highlight"] then _G[btnName .. "Highlight"]:SetAlpha(1) end
		self:addButtonBorder{obj=_G[btnName .. "Item"], ibt=true}
	end
	self:skinScrollBar{obj=_G.BidScrollFrame}
	self:skinMoneyFrame{obj=_G.BidBidPrice, moveSEB=true}

-->>--	Auctions Frame
	if not self.modBtnBs then
		self:resizeEmptyTexture(self:getRegion(_G.AuctionsItemButton, 2))
	else
		self:getRegion(_G.AuctionsItemButton, 2):SetAlpha(0) -- texture is changed in blizzard code
		self:addButtonBorder{obj=_G.AuctionsItemButton}
	end
	for _, v in pairs{"Quality", "Duration", "HighBidder", "Bid"} do
		local obj = _G["Auctions" .. v .. "Sort"]
		self:keepRegions(obj, {4, 5, 6}) -- N.B. region 4 is the text, 5 is the arrow, 6 is the highlight
		self:addSkinFrame{obj=obj, ft=ftype, nb=true}
	end
	for i = 1, _G.NUM_AUCTIONS_TO_DISPLAY do
		local btnName = "AuctionsButton" .. i
		self:keepFontStrings(_G[btnName])
		if _G[btnName .. "Highlight"] then _G[btnName .. "Highlight"]:SetAlpha(1) end
		self:addButtonBorder{obj=_G[btnName .. "Item"], ibt=true}
	end
	self:skinScrollBar{obj=_G.AuctionsScrollFrame}
	self:skinEditBox{obj=_G.AuctionsStackSizeEntry, regs={9}, noWidth=true}
	self:skinEditBox{obj=_G.AuctionsNumStacksEntry, regs={9}, noWidth=true}
	self:skinDropDown{obj=_G.PriceDropDown}
	self:skinDropDown{obj=_G.DurationDropDown}
	_G.AuctionProgressFrame:DisableDrawLayer("BACKGROUND")
	_G.AuctionProgressFrame:DisableDrawLayer("ARTWORK")
	self:keepFontStrings(_G.AuctionProgressBar)
	self:moveObject{obj=_G["AuctionProgressBar" .. "Text"], y=-2}
	self:glazeStatusBar(_G.AuctionProgressBar, 0)
	self:skinMoneyFrame{obj=_G.StartPrice, moveSEB=true}
	self:skinMoneyFrame{obj=_G.BuyoutPrice, moveSEB=true}

end

function aObj:BankFrame()
	if not self.db.profile.BankFrame or self.initialized.BankFrame then return end
	self.initialized.BankFrame = true

	self:skinEditBox{obj=_G.BankItemSearchBox, regs={9}, mi=true, noHeight=true, noMove=true}
	self:removeInset(_G.BankFrameMoneyFrameInset)
	_G.BankFrameMoneyFrameBorder:DisableDrawLayer("BACKGROUND")
	self:addSkinFrame{obj=_G.BankFrame, ft=ftype, kfs=true, x1=-3, y1=2, x2=1, y2=-2}
	-- add button borders
	for i = 1, _G.NUM_BANKGENERIC_SLOTS do
		self:addButtonBorder{obj=_G["BankFrameItem" .. i], ibt=true}
	end
	for i = 1, _G.NUM_BANKBAGSLOTS do
		self:addButtonBorder{obj=_G["BankFrameBag" .. i], ibt=true}
	end

end

function aObj:BarbershopUI() -- LoD
	if not self.db.profile.BarbershopUI or self.initialized.Barbershop then return end
	self.initialized.Barbershop = true

	self:keepFontStrings(_G.BarberShopFrameMoneyFrame)
	self:addSkinFrame{obj=_G.BarberShopFrame, ft=ftype, kfs=true, x1=35, y1=-32, x2=-32, y2=42}
	 for i = 1, 4 do
		 self:addButtonBorder{obj=_G["BarberShopFrameSelector" .. i .. "Prev"], ofs=-2}
		 self:addButtonBorder{obj=_G["BarberShopFrameSelector" .. i .. "Next"], ofs=-2}
	 end
	-- Banner Frame
	self:keepFontStrings(_G.BarberShopBannerFrame)
	_G.BarberShopBannerFrameCaption:ClearAllPoints()
	_G.BarberShopBannerFrameCaption:SetPoint("CENTER", _G.BarberShopFrame, "TOP", 0, -46)

end

function aObj:BlackMarketUI() -- LoD
	if not self.db.profile.BlackMarketUI or self.initialized.BlackMarketUI then return end
	self.initialized.BlackMarketUI = true

	-- move title text
	self:moveObject{obj=self:getRegion(_G.BlackMarketFrame, 22), y=-4}
	-- HotDeal frame
	self:keepFontStrings(_G.BlackMarketFrame.HotDeal)
	self:addButtonBorder{obj=_G.BlackMarketFrame.HotDeal.Item, ibt=true, relTo=_G.BlackMarketFrame.HotDeal.Item.IconTexture}
	self:skinAllButtons{obj=_G.BlackMarketFrame.HotDeal, ft=ftype}

	-- column headings
	for _, v in pairs{"Name", "Level", "Type", "Duration", "HighBidder", "CurrentBid"} do
		local obj = _G.BlackMarketFrame["Column" .. v]
		self:keepFontStrings(obj)
		self:addSkinFrame{obj=obj, ft=ftype, nb=true}
	end
	self:SecureHook("BlackMarketScrollFrame_Update", function(this)
		for i = 1, #_G.BlackMarketScrollFrame.buttons do
			local btn = _G.BlackMarketScrollFrame.buttons[i]
			if btn and not self.skinned[btn] then
				self:keepFontStrings(btn)
				btn:GetHighlightTexture():SetAlpha(1)
				self:addButtonBorder{obj=btn.Item, ibt=true, relTo=btn.Item.IconTexture}
			end
		end
		self:Unhook("BlackMarketScrollFrame_Update")
	end)
	self:skinSlider{obj=_G.BlackMarketScrollFrame.ScrollBar, adj=-4}
	_G.BlackMarketFrame.MoneyFrameBorder:DisableDrawLayer("BACKGROUND")
	self:skinMoneyFrame{obj=_G.BlackMarketBidPrice}
	self:addSkinFrame{obj=_G.BlackMarketFrame, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-2}

end

function aObj:GossipFrame()
	if not self.db.profile.GossipFrame or self.initialized.GossipFrame then return end
	self.initialized.GossipFrame = true

	-- setup Quest display colours here
	local QTHex = self:RGBPercToHex(self.HTr, self.HTg, self.HTb)
	_G.NORMAL_QUEST_DISPLAY = "|cff"..QTHex .. "%s|r"
	_G.TRIVIAL_QUEST_DISPLAY = "|cff"..QTHex .. "%s (low level)|r"

	self:keepFontStrings(_G.GossipFrameGreetingPanel)
	_G.GossipGreetingText:SetTextColor(self.HTr, self.HTg, self.HTb)
	self:skinScrollBar{obj=_G.GossipGreetingScrollFrame}
	for i = 1, _G.NUMGOSSIPBUTTONS do
		local obj = self:getRegion(_G["GossipTitleButton" .. i], 3)
		obj:SetTextColor(self.BTr, self.BTg, self.BTb)
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
		local obj = self:getRegion(_G["GuildRegistrarButton" .. i], 3)
		obj:SetTextColor(self.BTr, self.BTg, self.BTb)
	end
	self:skinEditBox{obj=_G.GuildRegistrarFrameEditBox}

	self:addSkinFrame{obj=_G.GuildRegistrarFrame, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-2}

end

function aObj:ItemAlterationUI() -- LoD (a.k.a TransmogrifyFrame)
	if not self.db.profile.ItemAlterationUI or self.initialized.ItemAlterationUI then return end
	self.initialized.ItemAlterationUI = true

	for _, v in pairs{"Head", "Shoulder", "Back", "Chest", "Wrist", "Hands", "Waist", "Legs", "Feet", "MainHand", "SecondaryHand"} do
		local btnName = "TransmogrifyFrame" .. v .. "Slot"
		_G[btnName .. "Grabber"]:SetAlpha(0)
		_G[btnName]:DisableDrawLayer("BORDER")
		self:addButtonBorder{obj=_G[btnName], reParent={_G[btnName].altTexture ,_G[btnName].undoIcon}}
	end
	_G.TransmogrifyModelFrame:DisableDrawLayer("BACKGROUND")
	_G.TransmogrifyModelFrame:DisableDrawLayer("BORDER")
	_G.TransmogrifyModelFrame.controlFrame:DisableDrawLayer("BACKGROUND")
	self:addSkinFrame{obj=_G.TransmogrifyArtFrame, ft=ftype, kfs=true, bg=true, y1=2, x2=1, y2=-2}
	self:keepRegions(_G.TransmogrifyFrameButtonFrame, {})
	self:removeMagicBtnTex(_G.TransmogrifyApplyButton)
	self:skinButton{obj=_G.TransmogrifyApplyButton}

	-- TransmogrifyConfirmation Popup used when items will be bound if altered
	self:removeRegions(_G.TransmogrifyConfirmationPopup.ItemFrame1, {8}) -- Name Frame texture
	self:addButtonBorder{obj=_G.TransmogrifyConfirmationPopup.ItemFrame1, ibt=true}
	self:removeRegions(_G.TransmogrifyConfirmationPopup.ItemFrame2, {8}) -- Name Frame texture
	self:addButtonBorder{obj=_G.TransmogrifyConfirmationPopup.ItemFrame2, ibt=true}
	self:addSkinFrame{obj=_G.TransmogrifyConfirmationPopup, ft=ftype}

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
	self:addButtonBorder{obj=_G.ItemUpgradeFrame.ItemButton, relTo=_G.ItemUpgradeFrame.ItemButton.IconTexture}
	_G.ItemUpgradeFrame.ItemButton.Frame:SetTexture(nil)
	_G.ItemUpgradeFrame.ItemButton.ItemName:SetTextColor(self.BTr, self.BTg, self.BTb)
	_G.ItemUpgradeFrame.ItemButton.MissingText:SetTextColor(self.BTr, self.BTg, self.BTb)
	_G.ItemUpgradeFrameMoneyFrame:DisableDrawLayer("BACKGROUND")
	self:removeMagicBtnTex(_G.ItemUpgradeFrameUpgradeButton)
	_G.ItemUpgradeFrame.ButtonFrame.ButtonBorder:SetTexture(nil)
	_G.ItemUpgradeFrame.ButtonFrame.ButtonBottomBorder:SetTexture(nil)
	self:addSkinFrame{obj=_G.ItemUpgradeFrame, ft=ftype, kfs=true, ofs=2, x2=1}

	-- hook this to hide the ItemButton texture if empty
	self:SecureHook(_G.ItemUpgradeFrame.ItemButton.IconTexture, "SetTexture", function(this, tex)
		if tex:find("UI-Slot-Background", 1, true) then
			this:SetAlpha(0)
		else
			this:SetAlpha(1)
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
	for i = 1, _G.math.max(_G.MERCHANT_ITEMS_PER_PAGE, _G.BUYBACK_ITEMS_PER_PAGE) do
		local btnName = "MerchantItem" .. i
		_G[btnName .. "NameFrame"]:SetTexture(nil)
		if not self.modBtnBs then
			_G[btnName .. "SlotTexture"]:SetTexture(self.esTex)
		else
			_G[btnName .. "SlotTexture"]:SetTexture(nil)
			self:addButtonBorder{obj=_G[btnName .. "ItemButton"], ibt=true}
		end
	end
	local btnName = "MerchantBuyBackItem"
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
	for i = 1, _G.NUM_PET_ACTIVE_SLOTS do
		local btn = _G["PetStableActivePet" .. i]
		btn.Border:Hide()
		if not self.modBtnBs then
			self:resizeEmptyTexture(btn.Background)
		else
			btn.Background:Hide()
			self:addButtonBorder{obj=btn}
		end
	end
	for i = 1, _G.NUM_PET_STABLE_SLOTS do
		local btn = _G["PetStableStabledPet" .. i]
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

	_G.QuestChoiceFrame.DummyString:SetTextColor(self.BTr, self.BTg, self.BTb)
	for i = 1, _G.MAX_NUM_OPTIONS do
		_G.QuestChoiceFrame["Option" .. i].OptionText:SetTextColor(self.HTr, self.HTg, self.HTb)
		self:addButtonBorder{obj=_G.QuestChoiceFrame["Option" .. i].Rewards.Item, relTo=_G.QuestChoiceFrame["Option" .. i].Rewards.Item.Icon}
		_G.QuestChoiceFrame["Option" .. i].Rewards.Item.Name:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G.QuestChoiceFrame["Option" .. i].Rewards.ReputationsFrame.Reputation1.Faction:SetTextColor(self.BTr, self.BTg, self.BTb)
	end
	self:addSkinFrame{obj=_G.QuestChoiceFrame, ft=ftype, kfs=true, ofs=-13}

end

function aObj:QuestFrame()
	if not self.db.profile.QuestFrame or self.initialized.QuestFrame then return end
	self.initialized.QuestFrame = true

	-- setup Quest display colours here
	local QTHex = self:RGBPercToHex(self.HTr, self.HTg, self.HTb)
	_G.NORMAL_QUEST_DISPLAY = "|cff"..QTHex .. "%s|r"
	_G.TRIVIAL_QUEST_DISPLAY = "|cff"..QTHex .. "%s (low level)|r"

	self:RawHook("QuestFrame_SetTitleTextColor", function(fontString, ...)
		fontString:SetTextColor(self.HTr, self.HTg, self.HTb)
	end, true)
	self:RawHook("QuestFrame_SetTextColor", function(fontString, ...)
		fontString:SetTextColor(self.BTr, self.BTg, self.BTb)
	end, true)

	self:addSkinFrame{obj=_G.QuestFrame, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-2}
-->>--	Reward Panel
	self:keepFontStrings(_G.QuestFrameRewardPanel)
	self:skinScrollBar{obj=_G.QuestRewardScrollFrame}
-->>--	Progress Panel
	self:keepFontStrings(_G.QuestFrameProgressPanel)
	_G.QuestProgressTitleText:SetTextColor(self.HTr, self.HTg, self.HTb)
	_G.QuestProgressText:SetTextColor(self.BTr, self.BTg, self.BTb)
	_G.QuestProgressRequiredMoneyText:SetTextColor(self.BTr, self.BTg, self.BTb)
	_G.QuestProgressRequiredItemsText:SetTextColor(self.HTr, self.HTg, self.HTb)
	self:skinScrollBar{obj=_G.QuestProgressScrollFrame}
	for i = 1, _G.MAX_REQUIRED_ITEMS do
		local btnName = "QuestProgressItem" .. i
		_G[btnName .. "NameFrame"]:SetTexture(nil)
		self:addButtonBorder{obj=_G[btnName], libt=true}
	end

-->>--	Detail Panel
	self:keepFontStrings(_G.QuestFrameDetailPanel)
	self:skinScrollBar{obj=_G.QuestDetailScrollFrame}

-->>--	Greeting Panel
	self:keepFontStrings(_G.QuestFrameGreetingPanel)
	self:keepFontStrings(_G.QuestGreetingScrollChildFrame) -- hide Horizontal Break texture
	self:skinScrollBar{obj=_G.QuestGreetingScrollFrame}
	if _G.QuestFrameGreetingPanel:IsShown() then
		_G.GreetingText:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G.CurrentQuestsText:SetTextColor(self.HTr, self.HTg, self.HTb)
		_G.AvailableQuestsText:SetTextColor(self.HTr, self.HTg, self.HTb)
	end

-->>-- QuestNPCModel
	self:keepFontStrings(_G.QuestNPCModelTextFrame)
	self:skinScrollBar{obj=_G.QuestNPCModelTextScrollFrame}
	self:addSkinFrame{obj=_G.QuestNPCModel, ft=ftype, kfs=true, ofs=4, y2=-81} -- similar to GuildNewsBossModel
	self:QuestInfo()

end

function aObj:QuestInfo()
	if self.initialized.QuestInfo then return end
	self.initialized.QuestInfo = true

	self:SecureHook("QuestInfo_Display", function(...)
		-- headers
		_G.QuestInfoTitleHeader:SetTextColor(self.HTr, self.HTg, self.HTb)
		_G.QuestInfoDescriptionHeader:SetTextColor(self.HTr, self.HTg, self.HTb)
		_G.QuestInfoObjectivesHeader:SetTextColor(self.HTr, self.HTg, self.HTb)
		_G.QuestInfoRewardsHeader:SetTextColor(self.HTr, self.HTg, self.HTb)
		-- other text
		_G.QuestInfoDescriptionText:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G.QuestInfoObjectivesText:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G.QuestInfoGroupSize:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G.QuestInfoRewardText:SetTextColor(self.BTr, self.BTg, self.BTb)
		-- reward frame text
		_G.QuestInfoItemChooseText:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G.QuestInfoItemReceiveText:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G.QuestInfoSpellLearnText:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G.QuestInfoXPFrameReceiveText:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G.QuestInfoReputationText:SetTextColor(self.BTr, self.BTg, self.BTb)
		-- reputation rewards
		for i = 1, _G.MAX_REPUTATIONS do
			_G["QuestInfoReputation" .. i .. "Faction"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		end
		local r, g, b = _G.QuestInfoRequiredMoneyText:GetTextColor()
		_G.QuestInfoRequiredMoneyText:SetTextColor(self.BTr - r, self.BTg - g, self.BTb - b)
		-- Objectives
		for i = 1, _G.MAX_OBJECTIVES do
			local r, g, b = _G["QuestInfoObjective" .. i]:GetTextColor()
			_G["QuestInfoObjective" .. i]:SetTextColor(self.BTr - r, self.BTg - g, self.BTb - b)
		end
		_G.QuestInfoSpellObjectiveLearnLabel:SetTextColor(self.BTr, self.BTg, self.BTb)
		-- QuestInfoSpecialObjectives Frame
		_G.QuestInfoSpellObjectiveFrameNameFrame:SetTexture(nil)
		_G.QuestInfoSpellObjectiveFrameSpellBorder:SetTexture(nil)
		self:addButtonBorder{obj=_G.QuestInfoSpellObjectiveFrame, relTo=_G.QuestInfoSpellObjectiveFrame.Icon}
	end)

	_G.QuestInfoTimerText:SetTextColor(self.BTr, self.BTg, self.BTb)
	_G.QuestInfoAnchor:SetTextColor(self.BTr, self.BTg, self.BTb)

	-- InfoRewards frame
	_G.QuestInfoRewardSpellNameFrame:SetTexture(nil)
	self:addButtonBorder{obj=_G.QuestInfoRewardSpell, relTo=_G.QuestInfoRewardSpell.Icon}
	_G.QuestInfoRewardSpellSpellBorder:SetTexture(nil)
	for i = 1, _G.MAX_NUM_ITEMS do
		local btnName = "QuestInfoItem" .. i
		_G[btnName .. "NameFrame"]:SetTexture(nil)
		self:addButtonBorder{obj=_G[btnName], libt=true}
	end

	-- Skill Point frame
	local btnName = "QuestInfoSkillPointFrame"
	_G[btnName .. "NameFrame"]:SetTexture(nil)
	self:addButtonBorder{obj=_G[btnName], libt=true, reParent={_G[btnName .. "SkillPointBg"], _G[btnName .. "SkillPointBgGlow"], _G[btnName .. "Points"]}}

	-- Spell Objective frame
	btnName = "QuestInfoSpellObjectiveFrame"
	_G[btnName .. "NameFrame"]:SetTexture(nil)
	_G[btnName .. "SpellBorder"]:SetTexture(nil)
	self:addButtonBorder{obj=_G[btnName], relTo=_G[btnName .. "IconTexture"]}

end

function aObj:ReforgingUI() -- LoD
	if not self.db.profile.ReforgingUI or self.initialized.ReforgingUI then return end
	self.initialized.ReforgingUI = true

	_G.ReforgingFrame.ItemButton.IconTexture:SetAlpha(0)
	_G.ReforgingFrame.ItemButton:DisableDrawLayer("BACKGROUND")
	_G.ReforgingFrame.ItemButton:DisableDrawLayer("OVERLAY")
	self:addButtonBorder{obj=_G.ReforgingFrame.ItemButton, ibt=true, ofs=1}
	_G.ReforgingFrame.ItemButton.MissingText:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:keepRegions(_G.ReforgingFrame.ButtonFrame, {})
	_G.ReforgingFrame.MissingDescription:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:addSkinFrame{obj=_G.ReforgingFrame, ft=ftype, kfs=true, x1=-3, y1=2, x2=1, y2=-2}
	self:moveObject{obj=_G.ReforgingFrameRestoreButton, y=2}
	self:removeMagicBtnTex(_G.ReforgingFrameRestoreButton)
	self:removeMagicBtnTex(_G.ReforgingFrameReforgeButton)

	-- hook this to hide the ItemButton texture if empty
	self:SecureHook(_G.ReforgingFrame.ItemButton.IconTexture, "SetTexture", function(this, tex)
		if tex:find("UI-Slot-Background", 1, true) then
			this:SetAlpha(0)
		else
			this:SetAlpha(1)
		end
	end)
	-- hook this to remove background texture from stat lines
	self:SecureHook("ReforgingFrame_GetStatRow", function(index, tryAdd)
		if _G.ReforgingFrame.LeftStat[index] then _G.ReforgingFrame.LeftStat[index].BG:SetTexture(nil) end
		if _G.ReforgingFrame.RightStat[index] then _G.ReforgingFrame.RightStat[index].BG:SetTexture(nil) end
	end)

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
	btn.disabledBG:SetAlpha(0)
	btn:GetNormalTexture():SetAlpha(0)
	self:addButtonBorder{obj=btn, relTo=btn.icon}
	self:skinSlider{obj=_G.ClassTrainerScrollFrameScrollBar}
	self:removeInset(_G.ClassTrainerFrame.bottomInset)
	for i = 1, #_G.ClassTrainerFrame.scrollFrame.buttons do
		local btn = _G.ClassTrainerFrame.scrollFrame.buttons[i]
		btn.disabledBG:SetAlpha(0)
		btn:GetNormalTexture():SetAlpha(0)
		self:addButtonBorder{obj=btn, relTo=btn.icon}
	end
	self:removeMagicBtnTex(_G.ClassTrainerTrainButton)
	self:addSkinFrame{obj=_G.ClassTrainerFrame, ft=ftype, kfs=true, ri=true, y1=2, x2=1, y2=-2}

end

function aObj:VoidStorageUI() -- LoD
	if not self.db.profile.VoidStorageUI or self.initialized.VoidStorageUI then return end
	self.initialized.VoidStorageUI = true

	self:addSkinFrame{obj=_G.VoidStoragePurchaseFrame, ft=ftype, kfs=true}
	self:keepFontStrings(_G.VoidStorageBorderFrame)
	for _, v in pairs{"Deposit", "Withdraw", "Storage", "Cost"} do
		local frame = _G["VoidStorage" .. v .. "Frame"]
		frame:DisableDrawLayer("BACKGROUND")
		frame:DisableDrawLayer("BORDER")
	end
	if self.modBtnBs then
		for i = 1, 9 do
			self:addButtonBorder{obj=_G["VoidStorageDepositButton" .. i]}
			self:addButtonBorder{obj=_G["VoidStorageWithdrawButton" .. i]}
		end
		for i = 1, 80 do
			self:addButtonBorder{obj=_G["VoidStorageStorageButton" .. i]}
		end
	end
	self:addSkinFrame{obj=_G.VoidStorageFrame, ft=ftype, kfs=true, y1=2, x2=1}
	self:skinEditBox{obj=_G.VoidItemSearchBox, regs={9}, mi=true, noHeight=true, noMove=true}

end
