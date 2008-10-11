local ftype = "n"

function Skinner:MerchantFrames()
	if not self.db.profile.MerchantFrames or self.initialized.MerchantFrames then return end
	self.initialized.MerchantFrames = true

	self:SecureHook("MerchantFrame_UpdateRepairButtons", function()
		self:moveObject(MerchantRepairText, nil, nil, "-", 63)
		self:moveObject(MerchantRepairAllButton, nil, nil, "-", 63)
		end)

	if self.db.profile.TexturedTab then
		-- hook this to update tabs
		self:SecureHook("MerchantFrame_Update", function()
--		self:Debug("MerchantFrame_Update: [%s]", PanelTemplates_GetSelectedTab(MerchantFrame))
			for i = 1, MerchantFrame.numTabs do
				local tabName = _G["MerchantFrameTab"..i]
				if i == MerchantFrame.selectedTab then
					self:setActiveTab(tabName)
				else
					self:setInactiveTab(tabName)
				end
			end
			end)
	end

	local yOfs = 60
	self:keepFontStrings(MerchantFrame)
	MerchantFrame:SetWidth(MerchantFrame:GetWidth() * self.FxMult)
	MerchantFrame:SetHeight(MerchantFrame:GetHeight() * self.FyMult)
	self:moveObject(MerchantNameText, nil, nil, "+", 6)
	self:moveObject(MerchantFrameCloseButton, "+", 28, "+", 8)
	self:moveObject(MerchantItem1, "-", 6, "+", 15)
	self:moveObject(MerchantPageText, "+", 12, "-", yOfs)
	self:moveObject(MerchantPrevPageButton, "-", 5, "-", yOfs)
	self:moveObject(MerchantNextPageButton, "-", 5, "-", yOfs)
--	self:moveObject(MerchantRepairText, nil, nil, "-", 63)
--	self:moveObject(MerchantRepairAllButton, nil, nil, "-", 63)
	self:moveObject(MerchantBuyBackItem, nil, nil, "-", 10)
	self:moveObject(MerchantMoneyFrame, "+", 30, "-", yOfs)

	for i = 1, MerchantFrame.numTabs do
		local tabName = _G["MerchantFrameTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		if self.db.profile.TexturedTab then self:applySkin(tabName, nil, 0)
		else self:storeAndSkin(ftype, _G["MerchantFrameTab"..i]) end
		if i == 1 then
			self:moveObject(tabName, nil, nil, "-", 55)
			if self.db.profile.TexturedTab then self:setActiveTab(tabName) end
		else
			self:moveObject(tabName, "+", 12, nil, nil)
			if self.db.profile.TexturedTab then self:setInactiveTab(tabName) end
		end
	end

	self:storeAndSkin(ftype, MerchantFrame)

end

function Skinner:GossipFrame()
	if not self.db.profile.GossipFrame or self.initialized.GossipFrame then return end
	self.initialized.GossipFrame = true

--	setup ?_QUEST_DISPLAY to chosen Quest text colour
	local QTHex = self:RGBPercToHex(self.HTr, self.HTg, self.HTb)
--	self:Debug("Quest Text Hex: [%s]", QTHex)
	NORMAL_QUEST_DISPLAY = "|cff"..QTHex.."%s|r"
	TRIVIAL_QUEST_DISPLAY = "|cff"..QTHex.."%s (low level)|r"
--	self:Debug("Changed Quest Display Colours, "..NORMAL_QUEST_DISPLAY..", "..TRIVIAL_QUEST_DISPLAY, "Normal", "Trivial")

	self:keepFontStrings(GossipFrame)
	GossipFrame:SetWidth(GossipFrame:GetWidth() * self.FxMult)
	GossipFrame:SetHeight(GossipFrame:GetHeight() * self.FyMult)
	if not self.isWotLK then self:moveObject(GossipFrameNpcNameText, nil, nil, "+", 15)
	else self:moveObject(GossipFrameNpcNameText, "-", 10, "+", 15) end
	self:moveObject(GossipFrameCloseButton, "+", 24, "+", 12)
	self:keepFontStrings(GossipFrameGreetingPanel)
	self:moveObject(GossipFrameGreetingGoodbyeButton, "+", 28, "-", 64)
	GossipGreetingText:SetTextColor(self.HTr, self.HTg, self.HTb)

	for i = 1, NUMGOSSIPBUTTONS do
		if not self.isWotLK then
			_G["GossipTitleButton"..i]:SetTextColor(self.BTr, self.BTg, self.BTb)
		else
			local text = select(3, _G["GossipTitleButton"..i]:GetRegions())
			text:SetTextColor(self.BTr, self.BTg, self.BTb)
		end
	end

	self:moveObject(GossipGreetingScrollFrame, "-", 12, "+", 30)
	self:removeRegions(GossipGreetingScrollFrame)
	self:skinScrollBar(GossipGreetingScrollFrame)
	self:storeAndSkin(ftype, GossipFrame)

end

function Skinner:TrainerUI()
	if not self.db.profile.ClassTrainer or self.initialized.TrainerUI then return end
	self.initialized.TrainerUI = true

	self:keepFontStrings(ClassTrainerFrame)
	ClassTrainerFrame:SetWidth(ClassTrainerFrame:GetWidth()* self.FxMult)
	ClassTrainerFrame:SetHeight(ClassTrainerFrame:GetHeight() * self.FyMult)
	self:moveObject(ClassTrainerNameText, nil, nil, "+", 6)
	self:moveObject(ClassTrainerGreetingText, "-", 35, "+", 10)
	self:moveObject(ClassTrainerFrameCloseButton, "+", 29, "+", 8)
	self:keepFontStrings(ClassTrainerExpandButtonFrame)
	self:moveObject(ClassTrainerExpandButtonFrame, nil, nil, "+", 10)
	self:skinDropDown(ClassTrainerFrameFilterDropDown)
	self:moveObject(ClassTrainerFrameFilterDropDown, nil, nil, "+", 10)
	self:moveObject(ClassTrainerSkill1, nil, nil, "+", 10)
	self:moveObject(ClassTrainerListScrollFrame, "+", 35, "+", 10)
	self:removeRegions(ClassTrainerListScrollFrame)
	self:skinScrollBar(ClassTrainerListScrollFrame)
	self:removeRegions(ClassTrainerDetailScrollFrame)
	self:skinScrollBar(ClassTrainerDetailScrollFrame)
	self:moveObject(ClassTrainerMoneyFrame, nil, nil, "-", 74)
	self:moveObject(ClassTrainerTrainButton, "-", 10, "-", 6)
	self:moveObject(ClassTrainerCancelButton, "-", 10, "-", 6)
	self:storeAndSkin(ftype, ClassTrainerFrame)

end

function Skinner:TaxiFrame()
	if not self.db.profile.TaxiFrame or self.initialized.TaxiFrame then return end
	self.initialized.TaxiFrame = true

	self:keepRegions(TaxiFrame, {6, 7}) -- N.B. region 6 is TaxiMerchant, 7 is the TaxiMap overlay
	TaxiFrame:SetWidth(TaxiFrame:GetWidth() * self.FxMult)
	TaxiFrame:SetHeight(TaxiFrame:GetHeight() * self.FyMult)
	self:moveObject(TaxiMerchant, nil, nil, "+", 6)
	self:moveObject(TaxiCloseButton, "+", 28, "+", 8)
	self:moveObject(TaxiMap, "+", 12, "+", 25)
	self:moveObject(TaxiRouteMap, "+", 12, "+", 25)
	self:storeAndSkin(ftype, TaxiFrame)

end

function Skinner:QuestFrame()
	if not self.db.profile.QuestFrame or self.initialized.QuestFrame then return end
	self.initialized.QuestFrame = true

	-- hook OnShow methods to change text colour
	self:SecureHook("QuestFrameGreetingPanel_OnShow", function()
--		self:Debug("QFGP_OS")
		for i = 1, MAX_NUM_QUESTS do
			_G["QuestTitleButton"..i]:SetTextColor(self.BTr, self.BTg, self.BTb)
		end
		end)

	self:Hook("QuestFrame_SetTitleTextColor", function(fontString)
		fontString:SetTextColor(self.HTr, self.HTg, self.HTb)
		end, true)
	self:Hook("QuestFrame_SetTextColor", function(fontString)
		fontString:SetTextColor(self.BTr, self.BTg, self.BTb)
		end, true)

	self:keepFontStrings(QuestFrame)
	QuestFrame:SetWidth(QuestFrame:GetWidth() * self.FxMult)
	QuestFrame:SetHeight(QuestFrame:GetHeight() * self.FyMult)
	self:moveObject(QuestFrameNpcNameText, nil, nil, "+", 15)
	self:moveObject(QuestFrameCloseButton, "+", 24, "+", 12)

-->>--	Reward Panel
	self:keepFontStrings(QuestFrameRewardPanel)
	self:moveObject(QuestFrameCancelButton, "+", 28, "-", 64)
	self:moveObject(QuestFrameCompleteQuestButton, "-", 10, "-", 64)
	self:moveObject(QuestRewardScrollFrame, "-", 12, "+", 30)
	self:skinScrollBar(QuestRewardScrollFrame)

-->>--	Progress Panel
	self:keepFontStrings(QuestFrameProgressPanel)
	QuestProgressRequiredItemsText:SetTextColor(self.HTr, self.HTg, self.HTb)
	self:moveObject(QuestFrameGoodbyeButton, "+", 28, "-", 64)
	self:moveObject(QuestFrameCompleteButton, "-", 10, "-", 64)
	self:moveObject(QuestProgressScrollFrame, "-", 12, "+", 30)
	self:skinScrollBar(QuestProgressScrollFrame)

-->>--	Detail Panel
	self:keepFontStrings(QuestFrameDetailPanel)
	self:moveObject(QuestFrameDeclineButton, "+", 28, "-", 64)
	self:moveObject(QuestFrameAcceptButton, "-", 10, "-", 64)
	self:moveObject(QuestDetailScrollFrame, "-", 12, "+", 30)
	self:skinScrollBar(QuestDetailScrollFrame)

-->>--	Greeting Panel
	self:keepFontStrings(QuestFrameGreetingPanel)
	self:moveObject(QuestFrameGreetingGoodbyeButton, "+", 28, "-", 64)
	self:moveObject(QuestGreetingScrollFrame, "-", 12, "+", 30)
	self:skinScrollBar(QuestGreetingScrollFrame)

	self:storeAndSkin(ftype, QuestFrame)

end

function Skinner:Battlefields()
	if not self.db.profile.Battlefields or self.initialized.Battlefields then return end
	self.initialized.Battlefields = true

	self:keepFontStrings(BattlefieldFrame)
	BattlefieldFrame:SetWidth(BattlefieldFrame:GetWidth() * self.FxMult)
	BattlefieldFrame:SetHeight(BattlefieldFrame:GetHeight() * self.FyMult)
	self:moveObject(BattlefieldFrameFrameLabel, nil, nil, "+", 6)
	self:moveObject(BattlefieldFrameCloseButton, "+", 26, "+", 6)
	self:moveObject(BattlefieldFrameCancelButton, "-", 10, nil, nil)
	local xOfs, yOfs = 12, 20
	self:moveObject(BattlefieldFrameNameHeader, "-", xOfs, "+", yOfs)
	self:moveObject(BattlefieldZone1, "-", xOfs, "+", yOfs)
	self:moveObject(BattlefieldFrameZoneDescription, "-", xOfs, "+", yOfs)
	self:moveObject(BattlefieldListScrollFrame, "+", 32, "+", yOfs)
	self:removeRegions(BattlefieldListScrollFrame)
	self:skinScrollBar(BattlefieldListScrollFrame)
	BattlefieldFrameZoneDescription:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:storeAndSkin(ftype, BattlefieldFrame)

end

function Skinner:ArenaFrame()
	if not self.db.profile.ArenaFrame or self.initialized.ArenaFrame then return end
	self.initialized.ArenaFrame = true

	self:keepFontStrings(ArenaFrame)
	ArenaFrame:SetWidth(ArenaFrame:GetWidth() * self.FxMult)
	ArenaFrame:SetHeight(ArenaFrame:GetHeight() * self.FyMult)
	self:moveObject(ArenaFrameCloseButton, "+", 26, "+", 6)
	self:moveObject(ArenaFrameCancelButton, "-", 10, "-", 6)
	self:moveObject(ArenaFrameNameHeader2, "+", 40, "-", 40)
	ArenaFrameZoneDescription:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:storeAndSkin(ftype, ArenaFrame)

end

function Skinner:ArenaRegistrar()
	if not self.db.profile.ArenaRegistrar or self.initialized.ArenaRegistrar then return end
	self.initialized.ArenaRegistrar = true

-->>--	Arena Registrar Frame
	self:keepFontStrings(ArenaRegistrarFrame)
	ArenaRegistrarFrame:SetWidth(ArenaRegistrarFrame:GetWidth() * self.FxMult)
	ArenaRegistrarFrame:SetHeight(ArenaRegistrarFrame:GetHeight() * self.FyMult)
	self:moveObject(ArenaRegistrarFrameNpcNameText, nil, nil, "+", 15)
	self:moveObject(ArenaRegistrarFrameCloseButton, "+", 24, "+", 12)
	self:keepFontStrings(ArenaRegistrarGreetingFrame)
	AvailableServicesText:SetTextColor(self.HTr, self.HTg, self.HTb)
	RegistrationText:SetTextColor(self.HTr, self.HTg, self.HTb)
	ArenaRegistrarPurchaseText:SetTextColor(self.BTr, self.BTg, self.BTb)
	for i = 1, 5 do
		if not self.isWotLK then
			_G["ArenaRegistrarButton"..i]:SetTextColor(self.BTr, self.BTg, self.BTb)
		else
			local text = select(3, _G["ArenaRegistrarButton"..i]:GetRegions())
			text:SetTextColor(self.BTr, self.BTg, self.BTb)
		end
	end
	
	self:moveObject(ArenaRegistrarFrameGoodbyeButton, "+", 28, "-", 64)
	self:moveObject(ArenaRegistrarFrameCancelButton, "+", 30, "-", 64)
	self:moveObject(ArenaRegistrarFramePurchaseButton, "-", 10, "-", 64)
	self:skinEditBox(ArenaRegistrarFrameEditBox)
	self:storeAndSkin(ftype, ArenaRegistrarFrame)

-->>--	PVP Banner Frame
	self:keepRegions(PVPBannerFrame, {6, 17, 18, 19, 20, 21, 22}) -- N.B. region 6 is the background, 17 - 20 are the emblem, 21, 22 are the text

	PVPBannerFrame:SetWidth(PVPBannerFrame:GetWidth() * self.FxMult)
	PVPBannerFrame:SetHeight(PVPBannerFrame:GetHeight() * self.FyMult)

	self:moveObject(PVPBannerFrameCloseButton, "+", 28, "+", 8)
	self:moveObject(PVPBannerFrameEmblemTopRight, "-", 20, nil, nil)
	self:moveObject(PVPBannerFrameNameText, nil, nil, "-", 28)
	self:moveObject(PVPBannerFrameBackground, "-", 8, "+", 10)
	self:moveObject(PVPBannerFrameCostFrame, "-", 5, "+", 10)
	self:removeRegions(PVPBannerFrameCustomizationFrame)
	self:moveObject(PVPBannerFrameCustomization1, "+", 35, "-", 73)
	self:keepFontStrings(PVPBannerFrameCustomization1)
	self:keepFontStrings(PVPBannerFrameCustomization2)
	self:moveObject(PVPBannerFrameMoneyFrame, "-", 30, "-", 75)
	self:moveObject(PVPBannerFrameAcceptButton, "-", 10, "+", 10)
	-- N.B. there are two PVPBannerFrameCancelButton entries
	self:moveObject(self:getChild(PVPBannerFrame, 4), "-", 10, "+", 10)

	self:storeAndSkin(ftype, PVPBannerFrame)

end

function Skinner:GuildRegistrar()
	if not self.db.profile.GuildRegistrar or self.initialized.GuildRegistrar then return end
	self.initialized.GuildRegistrar = true

	self:keepFontStrings(GuildRegistrarFrame)
	GuildRegistrarFrame:SetWidth(GuildRegistrarFrame:GetWidth() * self.FxMult)
	GuildRegistrarFrame:SetHeight(GuildRegistrarFrame:GetHeight() * self.FyMult)
	self:moveObject(GuildRegistrarFrameNpcNameText, nil, nil, "+", 15)
	self:moveObject(GuildRegistrarFrameCloseButton, "+", 24, "+", 12)
	self:keepFontStrings(GuildRegistrarGreetingFrame)
	AvailableServicesText:SetTextColor(self.HTr, self.HTg, self.HTb)
	GuildRegistrarPurchaseText:SetTextColor(self.BTr, self.BTg, self.BTb)
	for i = 1, 2 do
		if not self.isWotLK then
			_G["GuildRegistrarButton"..i]:SetTextColor(self.BTr, self.BTg, self.BTb)
		else
			local text = select(3, _G["GuildRegistrarButton"..i]:GetRegions())
			text:SetTextColor(self.BTr, self.BTg, self.BTb)
		end
	end
	self:moveObject(GuildRegistrarFrameGoodbyeButton, "+", 28, "-", 64)
	self:moveObject(GuildRegistrarFrameCancelButton, "+", 30, "-", 64)
	self:moveObject(GuildRegistrarFramePurchaseButton, "-", 10, "-", 64)
	self:skinEditBox(GuildRegistrarFrameEditBox)
	self:storeAndSkin(ftype, GuildRegistrarFrame)

end

function Skinner:Petition()
	if not self.db.profile.Petition or self.initialized.Petition then return end
	self.initialized.Petition = true

	self:keepFontStrings(PetitionFrame)
	PetitionFrame:SetWidth(PetitionFrame:GetWidth() * self.FxMult)
	PetitionFrame:SetHeight(PetitionFrame:GetHeight() * self.FyMult)
	self:moveObject(PetitionFrameNpcNameText, nil, nil, "+", 15)
	self:moveObject(PetitionFrameCloseButton, "+", 24, "+", 12)
	self:moveObject(PetitionFrameCancelButton, "+", 28, "-", 64)
	self:moveObject(PetitionFrameSignButton, "-", 15, "-", 64)
	self:moveObject(PetitionFrameRequestButton, "-", 15, "-", 64)
	PetitionFrameCharterTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
	PetitionFrameCharterName:SetTextColor(self.BTr, self.BTg, self.BTb)
	PetitionFrameMasterTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
	PetitionFrameMasterName:SetTextColor(self.BTr, self.BTg, self.BTb)
	PetitionFrameMemberTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
	for i = 1, 9 do
		_G["PetitionFrameMemberName"..i]:SetTextColor(self.BTr, self.BTg, self.BTb)
	end
	PetitionFrameInstructions:SetTextColor(self.BTr, self.BTg, self.BTb)

	self:storeAndSkin(ftype, PetitionFrame)

end

function Skinner:Tabard()
	if not self.db.profile.Tabard or self.initialized.Tabard then return end
	self.initialized.Tabard = true

	self:keepRegions(TabardFrame, {6, 17, 18, 19, 20, 21, 22}) -- N.B. region 6 is the background, 17 - 20 are the emblem, 21, 22 are the text

	TabardFrame:SetWidth(TabardFrame:GetWidth() * self.FxMult)
	TabardFrame:SetHeight(TabardFrame:GetHeight() * self.FyMult)

	self:moveObject(TabardFrameCloseButton, "+", 28, "+", 8)
	self:moveObject(TabardFrameEmblemTopRight, "-", 20, "-", 6)
	self:moveObject(TabardFrameNameText, nil, nil, "-", 28)
	self:moveObject(TabardFrameBackground, "-", 8, "+", 4)
	self:moveObject(TabardModel, nil, nil, "-", 60)

	TabardCharacterModelRotateLeftButton:Hide()
	TabardCharacterModelRotateRightButton:Hide()
	self:makeMFRotatable(TabardModel)

	self:moveObject(TabardFrameCostFrame, "-", 5, "+", 4)
	self:storeAndSkin(ftype, TabardFrameCostFrame)
	self:keepFontStrings(TabardFrameCustomizationFrame)
	self:moveObject(TabardFrameCustomization1, "+", 35, "-", 66)
	for i = 1, 5 do
		self:keepFontStrings(_G["TabardFrameCustomization"..i])
	end
	self:moveObject(TabardFrameMoneyFrame, "-", 30, "-", 75)
	self:moveObject(TabardFrameAcceptButton, "-", 10, "-", 6)
	self:moveObject(TabardFrameCancelButton, "-", 10, "-", 6)

	self:storeAndSkin(ftype, TabardFrame)

end

function Skinner:BarbershopUI()
	if not self.db.profile.Barbershop or self.initialized.Barbershop then return end
	self.initialized.Barbershop = true

--	self:Debug("BarbershopUI loaded")

-->>-- Barbershop Banner Frame	
	self:keepFontStrings(BarberShopBannerFrame)
	BarberShopBannerFrameCaption:ClearAllPoints()
	BarberShopBannerFrameCaption:SetPoint("CENTER", BarberShopFrame, "TOP", 0, -14)
-->>-- Barbershop Frame	
	BarberShopFrame:SetWidth(BarberShopFrame:GetWidth() * self.FxMult - 20)
	BarberShopFrame:SetHeight(BarberShopFrame:GetHeight() * self.FyMult - 57)
	self:keepFontStrings(BarberShopFrame)
	local yOfs = 50
	self:moveObject(BarberShopFrameSelector1Category, nil, nil, "+", yOfs)
	self:moveObject(BarberShopFrameSelector2Category, nil, nil, "+", yOfs)
	self:moveObject(BarberShopFrameSelector3Category, nil, nil, "+", yOfs)
	self:keepFontStrings(BarberShopFrameMoneyFrame)
	self:moveObject(BarberShopFrameMoneyFrame, nil, nil, "+", yOfs)
	self:moveObject(BarberShopFrameOkayButton, nil, nil, "+", yOfs)
	self:moveObject(BarberShopFrameResetButton, nil, nil, "-", 40)
	self:storeAndSkin(ftype, BarberShopFrame)
	
end
