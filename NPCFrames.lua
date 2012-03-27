local aName, aObj = ...
local _G = _G
local ftype = "n"
local obj, objName, tex, texName, btn, btnName, tab, tabSF

function aObj:MerchantFrames()
	if not self.db.profile.MerchantFrames or self.initialized.MerchantFrames then return end
	self.initialized.MerchantFrames = true

	self:add2Table(self.npcKeys, "MerchantFrames")

	-- display limited availability item's stock count even when zero
	self:SecureHook("SetItemButtonStock", function(button, numInStock)
		if numInStock == 0 and not button == MerchantBuyBackItemItemButton then
			_G[button:GetName().."Stock"]:SetFormattedText(MERCHANT_STOCK, numInStock)
			_G[button:GetName().."Stock"]:Show()
		end
	end)
	-- Items/Buyback Items
	for i = 1, max(MERCHANT_ITEMS_PER_PAGE, BUYBACK_ITEMS_PER_PAGE) do
		btnName = "MerchantItem"..i
		_G[btnName.."NameFrame"]:SetTexture(nil)
		if not self.modBtnBs then
			_G[btnName.."SlotTexture"]:SetTexture(self.esTex)
		else
			_G[btnName.."SlotTexture"]:SetTexture(nil)
			self:addButtonBorder{obj=_G[btnName.."ItemButton"], ibt=true}
		end
	end
	btnName = "MerchantBuyBackItem"
	_G[btnName.."NameFrame"]:SetTexture(nil)
	if self.modBtnBs then
		_G[btnName.."SlotTexture"]:SetTexture(nil)
		self:addButtonBorder{obj=_G[btnName.."ItemButton"], ibt=true}
		-- remove surrounding border (diff=0.01375)
		self:getRegion(MerchantRepairItemButton, 1):SetTexCoord(0.01375, 0.2675, 0.01375, 0.54875)
		MerchantRepairAllIcon:SetTexCoord(0.295, 0.54875, 0.01375, 0.54875)
		MerchantGuildBankRepairButtonIcon:SetTexCoord(0.57375, 0.83, 0.01375, 0.54875)
		self:addButtonBorder{obj=MerchantRepairAllButton}
		self:addButtonBorder{obj=MerchantRepairItemButton}
		self:addButtonBorder{obj=MerchantGuildBankRepairButton}
	else
		_G[btnName.."SlotTexture"]:SetTexture(self.esTex)
	end
	self:removeRegions(MerchantPrevPageButton, {2})
	self:removeRegions(MerchantNextPageButton, {2})
	self:skinTabs{obj=MerchantFrame}
	self:addSkinFrame{obj=MerchantFrame, ft=ftype, kfs=true, x1=10, y1=-11, x2=-33, y2=55}

end

function aObj:GossipFrame()
	if not self.db.profile.GossipFrame or self.initialized.GossipFrame then return end
	self.initialized.GossipFrame = true

	self:add2Table(self.npcKeys, "GossipFrame")

	-- setup Quest display colours here
	local QTHex = self:RGBPercToHex(self.HTr, self.HTg, self.HTb)
	NORMAL_QUEST_DISPLAY = "|cff"..QTHex.."%s|r"
	TRIVIAL_QUEST_DISPLAY = "|cff"..QTHex.."%s (low level)|r"

	self:keepFontStrings(GossipFrameGreetingPanel)
	GossipGreetingText:SetTextColor(self.HTr, self.HTg, self.HTb)
	self:skinScrollBar{obj=GossipGreetingScrollFrame}
	for i = 1, NUMGOSSIPBUTTONS do
		obj = self:getRegion(_G["GossipTitleButton"..i], 3)
		obj:SetTextColor(self.BTr, self.BTg, self.BTb)
	end

	self:addSkinFrame{obj=GossipFrame, ft=ftype, kfs=true, x1=12, y1=-18, x2=-29, y2=66}

end

function aObj:TrainerUI() -- LoD
	if not self.db.profile.TrainerUI or self.initialized.TrainerUI then return end
	self.initialized.TrainerUI = true

	ClassTrainerStatusBarLeft:SetAlpha(0)
	ClassTrainerStatusBarRight:SetAlpha(0)
	ClassTrainerStatusBarMiddle:SetAlpha(0)
	ClassTrainerStatusBarSkillRank:SetPoint("CENTER", ClassTrainerStatusBar) -- Blizzard bug
	self:glazeStatusBar(ClassTrainerStatusBar, 0,  ClassTrainerStatusBarBackground)
	btn = ClassTrainerFrame.skillStepButton
	btn.disabledBG:SetAlpha(0)
	btn:GetNormalTexture():SetAlpha(0)
	self:addButtonBorder{obj=btn, relTo=btn.icon}
	self:skinSlider{obj=ClassTrainerScrollFrameScrollBar}
	self:removeInset(ClassTrainerFrame.bottomInset)
	self:addSkinFrame{obj=ClassTrainerFrame, ft=ftype, kfs=true, ri=true, y1=2, x2=1, y2=-2}
	for i = 1, #ClassTrainerFrame.scrollFrame.buttons do
		btn = ClassTrainerFrame.scrollFrame.buttons[i]
		btn.disabledBG:SetAlpha(0)
		btn:GetNormalTexture():SetAlpha(0)
		self:addButtonBorder{obj=btn, relTo=btn.icon}
	end
	self:removeMagicBtnTex(ClassTrainerTrainButton)
	self:skinDropDown{obj=ClassTrainerFrameFilterDropDown}

end

function aObj:TaxiFrame()
	if not self.db.profile.TaxiFrame or self.initialized.TaxiFrame then return end
	self.initialized.TaxiFrame = true

	self:add2Table(self.npcKeys, "TaxiFrame")

	self:keepRegions(TaxiFrame, {6, 13})-- N.B. region 6 is Title, 13 is the Map background
	self:addSkinFrame{obj=TaxiFrame, ft=ftype, x1=-3, y1=2, x2=1, y2=-2}


end

function aObj:QuestFrame()
	if not self.db.profile.QuestFrame or self.initialized.QuestFrame then return end
	self.initialized.QuestFrame = true

	self:add2Table(self.npcKeys, "QuestFrame")

	-- setup Quest display colours here
	local QTHex = self:RGBPercToHex(self.HTr, self.HTg, self.HTb)
	NORMAL_QUEST_DISPLAY = "|cff"..QTHex.."%s|r"
	TRIVIAL_QUEST_DISPLAY = "|cff"..QTHex.."%s (low level)|r"

	self:RawHook("QuestFrame_SetTitleTextColor", function(fontString, ...)
		fontString:SetTextColor(self.HTr, self.HTg, self.HTb)
	end, true)
	self:RawHook("QuestFrame_SetTextColor", function(fontString, ...)
		fontString:SetTextColor(self.BTr, self.BTg, self.BTb)
	end, true)

	self:addSkinFrame{obj=QuestFrame, ft=ftype, kfs=true, x1=12, y1=-18, x2=-29, y2=66}

-->>--	Reward Panel
	self:keepFontStrings(QuestFrameRewardPanel)
	self:skinScrollBar{obj=QuestRewardScrollFrame}

-->>--	Progress Panel
	self:keepFontStrings(QuestFrameProgressPanel)
	QuestProgressTitleText:SetTextColor(self.HTr, self.HTg, self.HTb)
	QuestProgressText:SetTextColor(self.BTr, self.BTg, self.BTb)
	QuestProgressRequiredMoneyText:SetTextColor(self.BTr, self.BTg, self.BTb)
	QuestProgressRequiredItemsText:SetTextColor(self.HTr, self.HTg, self.HTb)
	self:skinScrollBar{obj=QuestProgressScrollFrame}
	for i = 1, MAX_REQUIRED_ITEMS do
		btnName = "QuestProgressItem"..i
		_G[btnName.."NameFrame"]:SetTexture(nil)
		self:addButtonBorder{obj=_G[btnName], libt=true}
	end

-->>--	Detail Panel
	self:keepFontStrings(QuestFrameDetailPanel)
	self:skinScrollBar{obj=QuestDetailScrollFrame}

-->>--	Greeting Panel
	self:keepFontStrings(QuestFrameGreetingPanel)
	self:keepFontStrings(QuestGreetingScrollChildFrame) -- hide Horizontal Break texture
	self:skinScrollBar{obj=QuestGreetingScrollFrame}
	if QuestFrameGreetingPanel:IsShown() then
		GreetingText:SetTextColor(self.BTr, self.BTg, self.BTb)
		CurrentQuestsText:SetTextColor(self.HTr, self.HTg, self.HTb)
		AvailableQuestsText:SetTextColor(self.HTr, self.HTg, self.HTb)
	end

-->>-- QuestNPCModel
	self:keepFontStrings(QuestNPCModelTextFrame)
	self:skinScrollBar{obj=QuestNPCModelTextScrollFrame}
	self:addSkinFrame{obj=QuestNPCModel, ft=ftype, kfs=true, ofs=4, y2=-81} -- similar to GuildNewsBossModel
	self:QuestInfo()

end

function aObj:AuctionUI() -- LoD
	if not self.db.profile.AuctionUI or self.initialized.AuctionUI then return end
	self.initialized.AuctionUI = true

	-- hide filter texture when filter is clicked
	self:SecureHook("FilterButton_SetType", function(button, type, text, isLast)
		_G[button:GetName().."NormalTexture"]:SetAlpha(0)
	end)

	self:skinTabs{obj=AuctionFrame, lod=true}
	self:addSkinFrame{obj=AuctionFrame, ft=ftype, kfs=true, hdr=true, x1=10, y1=-11, y2=4}

-->>--	Browse Frame
	for k, v in pairs{"Name", "MinLevel", "MaxLevel"} do
		obj = _G["Browse"..v]
		self:skinEditBox{obj=obj, regs={9}}
		self:moveObject{obj=obj, x=v=="MaxLevel" and -6 or -4, y=v~="MaxLevel" and 3 or 0}
	end
	self:skinDropDown{obj=BrowseDropDown, x2=110}
	for _, v in pairs{"Quality", "Level", "Duration", "HighBidder", "CurrentBid"} do
		obj = _G["Browse"..v.."Sort"]
		self:keepRegions(obj, {4, 5, 6}) -- N.B. region 4 is the text, 5 is the arrow, 6 is the highlight
		self:addSkinFrame{obj=obj, ft=ftype, nb=true}
	end
	self:skinScrollBar{obj=BrowseFilterScrollFrame}
	for i = 1, NUM_FILTERS_TO_DISPLAY do
		self:keepRegions(_G["AuctionFilterButton"..i], {3, 4}) -- N.B. region 3 is the highlight, 4 is the text
		self:addSkinFrame{obj=_G["AuctionFilterButton"..i], ft=ftype, nb=true}
	end
	self:skinScrollBar{obj=BrowseScrollFrame}
	for i = 1, NUM_BROWSE_TO_DISPLAY do
		btnName = "BrowseButton"..i
		if _G[btnName].Orig then break end -- Auctioneer CompactUI loaded
		self:keepFontStrings(_G[btnName])
		if _G[btnName.."Highlight"] then _G[btnName.."Highlight"]:SetAlpha(1) end
		_G[btnName.."ItemCount"]:SetDrawLayer("ARTWORK") -- fix for 3.3.3 bug
		self:addButtonBorder{obj=_G[btnName.."Item"], ibt=true}
	end
	self:skinMoneyFrame{obj=BrowseBidPrice, moveSEB=true}

-->>--	Bid Frame
	for _, v in pairs{"Quality", "Level", "Duration", "Buyout", "Status", "Bid"} do
		obj = _G["Bid"..v.."Sort"]
		self:keepRegions(obj, {4, 5, 6}) -- N.B. region 4 is the text, 5 is the arrow, 6 is the highlight
		self:addSkinFrame{obj=obj, ft=ftype, nb=true}
	end
	for i = 1, NUM_BIDS_TO_DISPLAY do
		btnName = "BidButton"..i
		self:keepFontStrings(_G[btnName])
		if _G[btnName.."Highlight"] then _G[btnName.."Highlight"]:SetAlpha(1) end
		self:addButtonBorder{obj=_G[btnName.."Item"], ibt=true}
	end
	self:skinScrollBar{obj=BidScrollFrame}
	self:skinMoneyFrame{obj=BidBidPrice, moveSEB=true}

-->>--	Auctions Frame
	if not self.modBtnBs then
		self:resizeEmptyTexture(self:getRegion(AuctionsItemButton, 2))
	else
		self:getRegion(AuctionsItemButton, 2):SetAlpha(0) -- texture is changed in blizzard code
		self:addButtonBorder{obj=AuctionsItemButton}
	end
	for _, v in pairs{"Quality", "Duration", "HighBidder", "Bid"} do
		obj = _G["Auctions"..v.."Sort"]
		self:keepRegions(obj, {4, 5, 6}) -- N.B. region 4 is the text, 5 is the arrow, 6 is the highlight
		self:addSkinFrame{obj=obj, ft=ftype, nb=true}
	end
	for i = 1, NUM_AUCTIONS_TO_DISPLAY do
		btnName = "AuctionsButton"..i
		self:keepFontStrings(_G[btnName])
		if _G[btnName.."Highlight"] then _G[btnName.."Highlight"]:SetAlpha(1) end
		self:addButtonBorder{obj=_G[btnName.."Item"], ibt=true}
	end
	self:skinScrollBar{obj=AuctionsScrollFrame}
	self:skinEditBox{obj=AuctionsStackSizeEntry, regs={9}, noWidth=true}
	self:skinEditBox{obj=AuctionsNumStacksEntry, regs={9}, noWidth=true}
	self:skinDropDown{obj=PriceDropDown}
	self:skinDropDown{obj=DurationDropDown}
	AuctionProgressFrame:DisableDrawLayer("BACKGROUND")
	AuctionProgressFrame:DisableDrawLayer("ARTWORK")
	self:keepFontStrings(AuctionProgressBar)
	self:moveObject{obj=_G["AuctionProgressBar".."Text"], y=-2}
	self:glazeStatusBar(AuctionProgressBar, 0)
	self:skinMoneyFrame{obj=StartPrice, moveSEB=true}
	self:skinMoneyFrame{obj=BuyoutPrice, moveSEB=true}

end

function aObj:BankFrame()
	if not self.db.profile.BankFrame or self.initialized.BankFrame then return end
	self.initialized.BankFrame = true

	self:add2Table(self.npcKeys, "BankFrame")

	self:skinEditBox{obj=BankItemSearchBox, regs={9}, mi=true, noHeight=true, noMove=true}
	self:addSkinFrame{obj=BankFrame, ft=ftype, kfs=true, x1=10, y1=-11, x2=-25, y2=91}

	if self.modBtnBs then
		-- add button borders
		for i = 1, NUM_BANKGENERIC_SLOTS do
			self:addButtonBorder{obj=_G["BankFrameItem"..i], ibt=true}
		end
		for i = 1, NUM_BANKBAGSLOTS do
			self:addButtonBorder{obj=_G["BankFrameBag"..i], ibt=true}
		end
	end
end

function aObj:ArenaRegistrar()
	if not self.db.profile.ArenaRegistrar or self.initialized.ArenaRegistrar then return end
	self.initialized.ArenaRegistrar = true

	self:add2Table(self.npcKeys, "ArenaRegistrar")

	--	PVP Banner Frame
	self:skinEditBox{obj=PVPBannerFrameEditBox, regs={9}}
	self:keepRegions(PVPBannerFrame, {8, 29, 30, 31, 32, 33, 34, 35}) -- N.B. region 8 is the title, 29 - 32 are the emblem, 33 - 35 are the text
	self:addSkinFrame{obj=PVPBannerFrame, ft=ftype, ri=true, y1=2, x2=1, y2=-4}
	self:removeMagicBtnTex(PVPBannerFrameCancelButton)
	self:removeMagicBtnTex(PVPBannerFrameAcceptButton)
	self:removeRegions(PVPBannerFrameCustomizationFrame)
	self:keepFontStrings(PVPBannerFrameCustomization1)
	self:keepFontStrings(PVPBannerFrameCustomization2)

end

function aObj:GuildRegistrar()
	if not self.db.profile.GuildRegistrar or self.initialized.GuildRegistrar then return end
	self.initialized.GuildRegistrar = true

	self:add2Table(self.npcKeys, "GuildRegistrar")

	self:keepFontStrings(GuildRegistrarGreetingFrame)
	AvailableServicesText:SetTextColor(self.HTr, self.HTg, self.HTb)
	GuildRegistrarPurchaseText:SetTextColor(self.BTr, self.BTg, self.BTb)
	for i = 1, 2 do
		obj = self:getRegion(_G["GuildRegistrarButton"..i], 3)
		obj:SetTextColor(self.BTr, self.BTg, self.BTb)
	end
	self:skinEditBox{obj=GuildRegistrarFrameEditBox}

	self:addSkinFrame{obj=GuildRegistrarFrame, ft=ftype, kfs=true, x1=12, y1=-17, x2=-29, y2=65}

end

function aObj:Petition()
	if not self.db.profile.Petition or self.initialized.Petition then return end
	self.initialized.Petition = true

	self:add2Table(self.npcKeys, "Petition")

	PetitionFrameCharterTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
	PetitionFrameCharterName:SetTextColor(self.BTr, self.BTg, self.BTb)
	PetitionFrameMasterTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
	PetitionFrameMasterName:SetTextColor(self.BTr, self.BTg, self.BTb)
	PetitionFrameMemberTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
	for i = 1, 9 do
		_G["PetitionFrameMemberName"..i]:SetTextColor(self.BTr, self.BTg, self.BTb)
	end
	PetitionFrameInstructions:SetTextColor(self.BTr, self.BTg, self.BTb)

	self:addSkinFrame{obj=PetitionFrame, ft=ftype, kfs=true, x1=12, y1=-17, x2=-29, y2=65}

end

function aObj:Tabard()
	if not self.db.profile.Tabard or self.initialized.Tabard then return end
	self.initialized.Tabard = true

	self:add2Table(self.npcKeys, "Tabard")

	self:keepRegions(TabardFrame, {6, 17, 18, 19, 20, 21, 22}) -- N.B. region 6 is the background, 17 - 20 are the emblem, 21, 22 are the text

	self:makeMFRotatable(TabardModel)
	TabardFrameCostFrame:SetBackdrop(nil)
	self:keepFontStrings(TabardFrameCustomizationFrame)
	for i = 1, 5 do
		self:keepFontStrings(_G["TabardFrameCustomization"..i])
	end

	self:addSkinFrame{obj=TabardFrame, ft=ftype, kfs=true, x1=10, y1=-12, x2=-32, y2=74}

end

function aObj:BarbershopUI() -- LoD
	if not self.db.profile.BarbershopUI or self.initialized.Barbershop then return end
	self.initialized.Barbershop = true

	self:keepFontStrings(BarberShopFrameMoneyFrame)
	self:addSkinFrame{obj=BarberShopFrame, ft=ftype, kfs=true, x1=35, y1=-32, x2=-32, y2=42}
	-- Banner Frame
	self:keepFontStrings(BarberShopBannerFrame)
	BarberShopBannerFrameCaption:ClearAllPoints()
	BarberShopBannerFrameCaption:SetPoint("CENTER", BarberShopFrame, "TOP", 0, -46)

end

function aObj:QuestInfo()
	if not self.db.profile.QuestFrame or self.initialized.QuestInfo then return end
	self.initialized.QuestInfo = true

	self:add2Table(self.npcKeys, "QuestInfo")

	local r, g, b
	self:SecureHook("QuestInfo_Display", function(...)
		-- headers
		QuestInfoTitleHeader:SetTextColor(self.HTr, self.HTg, self.HTb)
		QuestInfoDescriptionHeader:SetTextColor(self.HTr, self.HTg, self.HTb)
		QuestInfoObjectivesHeader:SetTextColor(self.HTr, self.HTg, self.HTb)
		QuestInfoRewardsHeader:SetTextColor(self.HTr, self.HTg, self.HTb)
		-- other text
		QuestInfoDescriptionText:SetTextColor(self.BTr, self.BTg, self.BTb)
		QuestInfoObjectivesText:SetTextColor(self.BTr, self.BTg, self.BTb)
		QuestInfoGroupSize:SetTextColor(self.BTr, self.BTg, self.BTb)
		QuestInfoRewardText:SetTextColor(self.BTr, self.BTg, self.BTb)
		-- reward frame text
		QuestInfoItemChooseText:SetTextColor(self.BTr, self.BTg, self.BTb)
		QuestInfoItemReceiveText:SetTextColor(self.BTr, self.BTg, self.BTb)
		QuestInfoSpellLearnText:SetTextColor(self.BTr, self.BTg, self.BTb)
		QuestInfoXPFrameReceiveText:SetTextColor(self.BTr, self.BTg, self.BTb)
		QuestInfoReputationText:SetTextColor(self.BTr, self.BTg, self.BTb)
		-- reputation rewards
		for i = 1, MAX_REPUTATIONS do
			_G["QuestInfoReputation"..i.."Faction"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		end
		r, g, b = QuestInfoRequiredMoneyText:GetTextColor()
		QuestInfoRequiredMoneyText:SetTextColor(self.BTr - r, self.BTg - g, self.BTb - b)
		-- Objectives
		for i = 1, MAX_OBJECTIVES do
			r, g, b = _G["QuestInfoObjective"..i]:GetTextColor()
			_G["QuestInfoObjective"..i]:SetTextColor(self.BTr - r, self.BTg - g, self.BTb - b)
		end
		QuestInfoSpellObjectiveLearnLabel:SetTextColor(self.BTr, self.BTg, self.BTb)
	end)

	QuestInfoTimerText:SetTextColor(self.BTr, self.BTg, self.BTb)
	QuestInfoAnchor:SetTextColor(self.BTr, self.BTg, self.BTb)

	for i = 1, MAX_NUM_ITEMS do
		btnName = "QuestInfoItem"..i
		_G[btnName.."NameFrame"]:SetTexture(nil)
		self:addButtonBorder{obj=_G[btnName], libt=true}
	end
	QuestInfoRewardSpellNameFrame:SetTexture(nil)
	QuestInfoRewardSpellSpellBorder:SetTexture(nil)

	btnName = "QuestInfoSkillPointFrame"
	_G[btnName.."NameFrame"]:SetTexture(nil)
	if self.modBtnBs then
		self:addButtonBorder{obj=_G[btnName], libt=true, reParent={_G[btnName.."SkillPointBg"], _G[btnName.."SkillPointBgGlow"], _G[btnName.."Points"]}}
	end

end

function aObj:ReforgingUI() -- LoD
	if not self.db.profile.ReforgingUI or self.initialized.ReforgingUI then return end
	self.initialized.ReforgingUI = true

	self:SecureHook(ReforgingFrameItemButtonIconTexture, "SetTexture", function(this, tex)
		if tex:find("UI-Slot-Background", 1, true) then
			this:SetAlpha(0)
		else
			this:SetAlpha(1)
		end
	end)
	ReforgingFrameItemButtonIconTexture:SetAlpha(0)
	ReforgingFrameItemButton:DisableDrawLayer("BACKGROUND")
	self:keepRegions(ReforgingFrameButtonFrame, {})
	self:addSkinFrame{obj=ReforgingFrame, ft=ftype, kfs=true, y1=2, x2=1, y2=-2}
	self:addSkinButton{obj=ReforgingFrameItemButton, aso={ng=true}}
	ReforgingFrameItemButton:DisableDrawLayer("OVERLAY")
	ReforgingFrameItemButton.missingText:SetTextColor(self.BTr, self.BTg, self.BTb)
	ReforgingFrame.missingDescription:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:moveObject{obj=ReforgingFrameRestoreButton, y=2}
	self:removeMagicBtnTex(ReforgingFrameRestoreButton)
	self:removeMagicBtnTex(ReforgingFrameReforgeButton)

end

function aObj:SideDressUpFrame()
	if not self.db.profile.SideDressUpFrame or self.initialized.SideDressUpFrame then return end
	self.initialized.SideDressUpFrame = true

	self:add2Table(self.npcKeys, "SideDressUpFrame")

	SideDressUpModel.controlFrame:DisableDrawLayer("BACKGROUND")
	SideDressUpModelCloseButton:DisableDrawLayer("BACKGROUND")
	SideDressUpFrame:DisableDrawLayer("BACKGROUND")
	self:addSkinFrame{obj=SideDressUpFrame, ft=ftype, bg=true, x1=-6, y1=-3, x2=-2}

end

function aObj:ItemAlterationUI() -- LoD
	if not self.db.profile.ItemAlterationUI or self.initialized.ItemAlterationUI then return end
	self.initialized.ItemAlterationUI = true

	for k, v in pairs{"Head", "Shoulder", "Back", "Chest", "Wrist", "Hands", "Waist", "Legs", "Feet", "MainHand", "SecondaryHand", TransmogrifyFrame.ranged and "Ranged" or nil} do
		local bName = "TransmogrifyFrame"..v.."Slot"
		_G[bName.."Grabber"]:SetAlpha(0)
		_G[bName]:DisableDrawLayer("BORDER")
	end
	TransmogrifyModelFrame:DisableDrawLayer("BACKGROUND")
	TransmogrifyModelFrame:DisableDrawLayer("BORDER")
	TransmogrifyModelFrame.controlFrame:DisableDrawLayer("BACKGROUND")
	self:keepRegions(TransmogrifyFrameButtonFrame, {})
	self:removeMagicBtnTex(TransmogrifyApplyButton)
	self:skinButton{obj=TransmogrifyApplyButton}
	self:addSkinFrame{obj=TransmogrifyArtFrame, ft=ftype, kfs=true, bg=true, y1=2, x2=1, y2=-2}

end

function aObj:VoidStorageUI() -- LoD
	if not self.db.profile.VoidStorageUI or self.initialized.VoidStorageUI then return end
	self.initialized.VoidStorageUI = true

	self:addSkinFrame{obj=VoidStoragePurchaseFrame, ft=ftype, kfs=true}
	self:keepRegions(VoidStorageBorderFrame, {6})
	for _, v in pairs{"Deposit", "Withdraw", "Storage", "Cost"} do
		local frame = _G["VoidStorage"..v.."Frame"]
		frame:DisableDrawLayer("BACKGROUND")
		frame:DisableDrawLayer("BORDER")
	end
	self:addSkinFrame{obj=VoidStorageFrame, ft=ftype, kfs=true, y1=2, x2=1}
	self:skinEditBox{obj=VoidItemSearchBox, regs={9}, mi=true, noHeight=true, noMove=true}

end
