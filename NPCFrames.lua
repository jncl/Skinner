local ftype = "n"

function Skinner:MerchantFrames()
	if not self.db.profile.MerchantFrames or self.initialized.MerchantFrames then return end
	self.initialized.MerchantFrames = true

	if self.isTT then
		-- hook this to change the texture for the Active and Inactive tabs
		self:SecureHook("MerchantFrame_Update",function()
			for i = 1, MerchantFrame.numTabs do
				local tabSF = self.skinFrame[_G["MerchantFrameTab"..i]]
				if i == MerchantFrame.selectedTab then
					self:setActiveTab(tabSF)
				else
					self:setInactiveTab(tabSF)
				end
			end
		end)
	end
	
	self:keepFontStrings(MerchantFrame)
	self:addSkinFrame(MerchantFrame, 10, -12, -32, 55, ftype)
	
-->>-- Tabs
	for i = 1, MerchantFrame.numTabs do
		local tabName = _G["MerchantFrameTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		self:addSkinFrame(tabName, 6, 0, -6, 2, ftype, self.isTT)
		local tabSF = self.skinFrame[tabName]
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end
	
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
	self:keepFontStrings(GossipFrameGreetingPanel)
	GossipGreetingText:SetTextColor(self.HTr, self.HTg, self.HTb)
	self:removeRegions(GossipGreetingScrollFrame)
	self:skinScrollBar(GossipGreetingScrollFrame)
	for i = 1, NUMGOSSIPBUTTONS do
		local text = self:getRegion(_G["GossipTitleButton"..i], 3)
		text:SetTextColor(self.BTr, self.BTg, self.BTb)
	end
	self:addSkinFrame(GossipFrame, 12, -18, -29, 66, ftype)

end

function Skinner:TrainerUI()
	if not self.db.profile.TrainerUI or self.initialized.TrainerUI then return end
	self.initialized.TrainerUI = true

	self:keepFontStrings(ClassTrainerFrame)
	self:keepFontStrings(ClassTrainerExpandButtonFrame)
	self:skinDropDown(ClassTrainerFrameFilterDropDown)
	self:removeRegions(ClassTrainerListScrollFrame)
	self:skinScrollBar(ClassTrainerListScrollFrame)
	self:removeRegions(ClassTrainerDetailScrollFrame)
	self:skinScrollBar(ClassTrainerDetailScrollFrame)
	self:addSkinFrame(ClassTrainerFrame, 10, -12, -32, 74, ftype)
	
end

function Skinner:TaxiFrame()
	if not self.db.profile.TaxiFrame or self.initialized.TaxiFrame then return end
	self.initialized.TaxiFrame = true

	self:keepRegions(TaxiFrame, {6, 7}) -- N.B. region 6 is TaxiName, 7 is the Map background
	self:addSkinFrame(TaxiFrame, 10, -12, -32, 74, ftype)
	
end

function Skinner:QuestFrame()
	if not self.db.profile.QuestFrame or self.initialized.QuestFrame then return end
	self.initialized.QuestFrame = true

	-- hook OnShow methods to change text colour
	self:SecureHook("QuestFrameGreetingPanel_OnShow", function()
--		self:Debug("QFGP_OS")
		for i = 1, MAX_NUM_QUESTS do
			local text = self:getRegion(_G["QuestTitleButton"..i], 3)
			text:SetTextColor(self.BTr, self.BTg, self.BTb)
		end
	end)

	self:RawHook("QuestFrame_SetTitleTextColor", function(fontString)
		fontString:SetTextColor(self.HTr, self.HTg, self.HTb)
		end, true)
	self:RawHook("QuestFrame_SetTextColor", function(fontString)
		fontString:SetTextColor(self.BTr, self.BTg, self.BTb)
	end, true)

	self:keepFontStrings(QuestFrame)
	self:addSkinFrame(QuestFrame, 12, -18, -29, 66, ftype)
	
-->>--	Reward Panel
	self:keepFontStrings(QuestFrameRewardPanel)
	QuestRewardTalentFrameTalentReceiveText:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:skinScrollBar(QuestRewardScrollFrame)

-->>--	Progress Panel
	self:keepFontStrings(QuestFrameProgressPanel)
	QuestProgressRequiredItemsText:SetTextColor(self.HTr, self.HTg, self.HTb)
	self:skinScrollBar(QuestProgressScrollFrame)

-->>--	Detail Panel
	self:keepFontStrings(QuestFrameDetailPanel)
	QuestDetailTalentFrameTalentReceiveText:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:skinScrollBar(QuestDetailScrollFrame)

-->>--	Greeting Panel
	self:keepFontStrings(QuestFrameGreetingPanel)
	self:skinScrollBar(QuestGreetingScrollFrame)

end

function Skinner:Battlefields()
	if not self.db.profile.Battlefields or self.initialized.Battlefields then return end
	self.initialized.Battlefields = true

	self:keepFontStrings(BattlefieldFrame)
	self:removeRegions(BattlefieldListScrollFrame)
	self:skinScrollBar(BattlefieldListScrollFrame)
	BattlefieldFrameZoneDescription:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:addSkinFrame(BattlefieldFrame, 10, -12, -32, 71, ftype)

end

function Skinner:ArenaFrame()
	if not self.db.profile.ArenaFrame or self.initialized.ArenaFrame then return end
	self.initialized.ArenaFrame = true

	self:keepFontStrings(ArenaFrame)
	ArenaFrameZoneDescription:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:addSkinFrame(ArenaFrame, 10, -12, -32, 71, ftype)

end

function Skinner:ArenaRegistrar()
	if not self.db.profile.ArenaRegistrar or self.initialized.ArenaRegistrar then return end
	self.initialized.ArenaRegistrar = true

-->>--	Arena Registrar Frame
	self:keepFontStrings(ArenaRegistrarFrame)
	self:keepFontStrings(ArenaRegistrarGreetingFrame)
	AvailableServicesText:SetTextColor(self.HTr, self.HTg, self.HTb)
	RegistrationText:SetTextColor(self.HTr, self.HTg, self.HTb)
	ArenaRegistrarPurchaseText:SetTextColor(self.BTr, self.BTg, self.BTb)
	for i = 1, 5 do
		local text = self:getRegion(_G["ArenaRegistrarButton"..i], 3)
		text:SetTextColor(self.BTr, self.BTg, self.BTb)
	end
	self:skinEditBox(ArenaRegistrarFrameEditBox)
	self:addSkinFrame(ArenaRegistrarFrame, 10, -12, -32, 71, ftype)
	
-->>--	PVP Banner Frame
	self:keepRegions(PVPBannerFrame, {6, 17, 18, 19, 20, 21, 22}) -- N.B. region 6 is the background, 17 - 20 are the emblem, 21, 22 are the text

	self:removeRegions(PVPBannerFrameCustomizationFrame)
	self:keepFontStrings(PVPBannerFrameCustomization1)
	self:keepFontStrings(PVPBannerFrameCustomization2)
	self:addSkinFrame(PVPBannerFrame, 10, -12, -32, 74, ftype)

end

function Skinner:GuildRegistrar()
	if not self.db.profile.GuildRegistrar or self.initialized.GuildRegistrar then return end
	self.initialized.GuildRegistrar = true

	self:keepFontStrings(GuildRegistrarFrame)
	self:keepFontStrings(GuildRegistrarGreetingFrame)
	AvailableServicesText:SetTextColor(self.HTr, self.HTg, self.HTb)
	GuildRegistrarPurchaseText:SetTextColor(self.BTr, self.BTg, self.BTb)
	for i = 1, 2 do
		local text = self:getRegion(_G["GuildRegistrarButton"..i], 3)
		text:SetTextColor(self.BTr, self.BTg, self.BTb)
	end
	self:skinEditBox(GuildRegistrarFrameEditBox)
	self:addSkinFrame(GuildRegistrarFrame, 12, -17, -29, 65, ftype)
	
end

function Skinner:Petition()
	if not self.db.profile.Petition or self.initialized.Petition then return end
	self.initialized.Petition = true

	self:keepFontStrings(PetitionFrame)
	PetitionFrameCharterTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
	PetitionFrameCharterName:SetTextColor(self.BTr, self.BTg, self.BTb)
	PetitionFrameMasterTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
	PetitionFrameMasterName:SetTextColor(self.BTr, self.BTg, self.BTb)
	PetitionFrameMemberTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
	for i = 1, 9 do
		_G["PetitionFrameMemberName"..i]:SetTextColor(self.BTr, self.BTg, self.BTb)
	end
	PetitionFrameInstructions:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:addSkinFrame(PetitionFrame, 12, -17, -29, 65, ftype)
	
end

function Skinner:Tabard()
	if not self.db.profile.Tabard or self.initialized.Tabard then return end
	self.initialized.Tabard = true

	self:keepRegions(TabardFrame, {6, 17, 18, 19, 20, 21, 22}) -- N.B. region 6 is the background, 17 - 20 are the emblem, 21, 22 are the text

	TabardCharacterModelRotateLeftButton:Hide()
	TabardCharacterModelRotateRightButton:Hide()
	self:makeMFRotatable(TabardModel)
	TabardFrameCostFrame:SetBackdrop(nil)
	self:addSkinFrame(TabardFrameCostFrame, nil, nil, nil, nil, ftype)
	self:keepFontStrings(TabardFrameCustomizationFrame)
	for i = 1, 5 do
		self:keepFontStrings(_G["TabardFrameCustomization"..i])
	end
	self:addSkinFrame(TabardFrame, 10, -12, -32, 74, ftype)
	
end

function Skinner:BarbershopUI()
	if not self.db.profile.BarbershopUI or self.initialized.Barbershop then return end
	self.initialized.Barbershop = true

-->>-- Barbershop Banner Frame	
	self:keepFontStrings(BarberShopBannerFrame)
	BarberShopBannerFrameCaption:ClearAllPoints()
	BarberShopBannerFrameCaption:SetPoint("CENTER", BarberShopFrame, "TOP", 0, -46)
-->>-- Barbershop Frame	
	self:keepFontStrings(BarberShopFrame)
	self:keepFontStrings(BarberShopFrameMoneyFrame)
	self:addSkinFrame(BarberShopFrame, 35, -32, -32, 42, ftype)
	
end
