local ftype = "u"

function Skinner:MenuFrames()
	if not self.db.profile.MenuFrames or self.initialized.MenuFrames then return end
	self.initialized.MenuFrames = true

	self:storeAndSkin(ftype, GameMenuFrame, true)

--	Video Options
	if not self.isWotLK then
		self:storeAndSkin(ftype, OptionsFrame, true)
		self:skinDropDown(OptionsFrameResolutionDropDown)
		self:skinDropDown(OptionsFrameRefreshDropDown)
		self:skinDropDown(OptionsFrameMultiSampleDropDown)
		self:storeAndSkin(ftype, OptionsFrameDisplay)
		self:storeAndSkin(ftype, OptionsFrameWorldAppearance)
		self:storeAndSkin(ftype, OptionsFrameBrightness)
		self:storeAndSkin(ftype, OptionsFramePixelShaders)
		self:storeAndSkin(ftype, OptionsFrameMiscellaneous)
	else
		self:storeAndSkin(ftype, VideoOptionsFrame, true)
		self:storeAndSkin(ftype, VideoOptionsFrameCategoryFrame)
		self:storeAndSkin(ftype, VideoOptionsResolutionPanelBrightness)
		self:storeAndSkin(ftype, VideoOptionsResolutionPanel)
		self:skinDropDown(VideoOptionsResolutionPanelResolutionDropDown)
		self:skinDropDown(VideoOptionsResolutionPanelMultiSampleDropDown)
		self:skinDropDown(VideoOptionsResolutionPanelRefreshDropDown)
		self:storeAndSkin(ftype, VideoOptionsEffectsPanelQuality)
		self:storeAndSkin(ftype, VideoOptionsEffectsPanelShaders)
		self:storeAndSkin(ftype, VideoOptionsEffectsPanel)
	end

--	Sound & Voice Options (Voice New 2.2)
	if not self.isWotLK then
		self:storeAndSkin(ftype, AudioOptionsFrame, true)
	-->>--	Sound Options
		self:storeAndSkin(ftype, SoundOptionsFramePlayback)
		self:storeAndSkin(ftype, SoundOptionsFrameHardware)
		self:skinDropDown(SoundOptionsOutputDropDown)
		self:storeAndSkin(ftype, SoundOptionsFrameVolume)
	-->>--	Voice Options
		self:skinDropDown(VoiceOptionsFrameInputDeviceDropDown)
		self:storeAndSkin(ftype, VoiceOptionsFrameTalking)
		self:skinDropDown(VoiceOptionsFrameTypeDropDown)
		self:storeAndSkin(ftype, VoiceOptionsFrameMode)
		self:skinDropDown(VoiceOptionsFrameOutputDeviceDropDown)
		self:storeAndSkin(ftype, VoiceOptionsFrameSpeaking)
	-->>--	Voice Chat Button
		self:skinDropDown(MiniMapVoiceChatDropDown)
		self:storeAndSkin(ftype, VoiceChatTalkers)
	-->>--	Tabs
		self:keepRegions(AudioOptionsFrameTab1, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		self:keepRegions(AudioOptionsFrameTab2, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		self:moveObject(AudioOptionsFrameTab1, nil, nil, "-", 1)
		self:moveObject(AudioOptionsFrameTab2, "+", 12, nil, nil)
		if self.db.profile.TexturedTab then
			self:applySkin(AudioOptionsFrameTab1, nil, 0, 1)
			self:applySkin(AudioOptionsFrameTab2, nil, 0, 1)
			self:setActiveTab(AudioOptionsFrameTab1)
			self:setInactiveTab(AudioOptionsFrameTab2)
			self:SecureHook("ToggleAudioOption", function(tab)
				-- frame names are back to front in the table
				if tab == AUDIOOPTIONSFRAME_SUBFRAMES[2] then
					self:setActiveTab(AudioOptionsFrameTab1)
					self:setInactiveTab(AudioOptionsFrameTab2)
				else
					self:setActiveTab(AudioOptionsFrameTab2)
					self:setInactiveTab(AudioOptionsFrameTab1)
				end
			end)
		else
			self:storeAndSkin(ftype, AudioOptionsFrameTab1)
			self:storeAndSkin(ftype, AudioOptionsFrameTab2)
		end
	else
		self:storeAndSkin(ftype, AudioOptionsFrame, true)
		self:storeAndSkin(ftype, AudioOptionsFrameCategoryFrame)
		self:storeAndSkin(ftype, AudioOptionsSoundPanelPlayback)
		self:storeAndSkin(ftype, AudioOptionsSoundPanelHardware)
		self:storeAndSkin(ftype, AudioOptionsSoundPanelVolume)
		self:storeAndSkin(ftype, AudioOptionsSoundPanel)
		self:skinDropDown(AudioOptionsSoundPanelHardwareDropDown)
		self:storeAndSkin(ftype, AudioOptionsVoicePanelTalking)
		self:storeAndSkin(ftype, AudioOptionsVoicePanelBinding)
		self:storeAndSkin(ftype, AudioOptionsVoicePanelListening)
		self:storeAndSkin(ftype, AudioOptionsVoicePanel)
		self:skinDropDown(AudioOptionsVoicePanelInputDeviceDropDown)
		self:skinDropDown(AudioOptionsVoicePanelOutputDeviceDropDown)
		self:skinDropDown(AudioOptionsVoicePanelChatModeDropDown)
	end
	
-->>--	Mac Options (New 2.2)
	if IsMacClient() then
		self:storeAndSkin(ftype, MacOptionsFrame, true)
		self:storeAndSkin(ftype, MacOptionsFrameMovieRecording)
		self:skinDropDown(MacOptionsFrameResolutionDropDown)
		self:skinDropDown(MacOptionsFrameFramerateDropDown)
		self:skinDropDown(MacOptionsFrameCodecDropDown)
		self:storeAndSkin(ftype, MacOptionsITunesRemote)
-->>--		Movie Progress Frame
		self:glazeStatusBar(MovieProgressBar, 0)
		self:storeAndSkin(ftype, MovieProgressFrame)
		self:storeAndSkin(ftype, MacOptionsCancelFrame, true)
	end

-->>--	InterfaceOptionsFrame (changed in 2.4)
	self:removeRegions(InterfaceOptionsFrameCategoriesList)
	self:skinScrollBar(InterfaceOptionsFrameCategoriesList)
	self:removeRegions(InterfaceOptionsFrameAddOnsList)
	self:skinScrollBar(InterfaceOptionsFrameAddOnsList)
	self:storeAndSkin(ftype, InterfaceOptionsFrameCategories)
	self:storeAndSkin(ftype, InterfaceOptionsFrameAddOns)
	self:storeAndSkin(ftype, InterfaceOptionsFrame, true)
	-- Tabs
	for i = 1, 2 do
		local tabName = _G["InterfaceOptionsFrameTab"..i]
		local tabNameT = _G["InterfaceOptionsFrameTab"..i.."Text"]
		local tabNameHT = _G["InterfaceOptionsFrameTab"..i.."HighlightTexture"]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		if self.db.profile.TexturedTab then self:applySkin(tabName, nil, 0, 1)
		else self:storeAndSkin(ftype, tabName) end
		self:moveObject(tabNameT, nil, nil, "+", 3)
		self:moveObject(tabNameHT, "-", 5, "+", 3)
		if i == 2 then self:moveObject(tabName, "+", 14, nil, nil) end
	end

	-- Hook this to skin any Interface Option panels
	local hookFunc
	if not self.isWotLK then
		hookFunc = "InterfaceOptionsList_DisplayFrame"
	else
		hookFunc = "InterfaceOptionsList_DisplayPanel"
	end
	self:SecureHook(hookFunc, function(frame)
--		self:Debug("%s: [%s, %s]", hookFunc, frame, frame:GetName())
		if not frame.skinned then
			for i = 1, select("#", frame:GetChildren()) do
				local child = select(i, frame:GetChildren())
				if child and self:isDropDown(child) then self:skinDropDown(child) end
			end
			self:storeAndSkin(ftype, frame)
			frame.skinned = true
		end
	end)

end

function Skinner:MacroUI()
	if not self.db.profile.MenuFrames or self.initialized.MacroUI then return end
	self.initialized.MacroUI = true

	self:keepFontStrings(MacroFrame)
	MacroFrame:SetWidth(MacroFrame:GetWidth() * self.FxMult)
	MacroFrame:SetHeight(MacroFrame:GetHeight() * self.FyMult)

	for i = 1, 2 do
		local tabName = _G["MacroFrameTab"..i]
		if self.isWotLK and i == 1 then self:moveObject(tabName, "-", 30, "+", 0) end
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		self:moveObject(_G[tabName:GetName().."Text"], nil, nil, "+", 5)
		self:moveObject(_G[tabName:GetName().."HighlightTexture"], nil, nil, "+", 8)
		self:storeAndSkin(ftype, tabName)
	end

	if self.isWotLK then
		self:removeRegions(MacroButtonScrollFrame)
		self:skinScrollBar(MacroButtonScrollFrame)
	end
	self:moveObject(MacroFrameCloseButton, "+", 28, "+", 8)
	if not self.isWotLK then self:moveObject(MacroButton1, "-", 10, nil, nil) end
	self:moveObject(MacroFrameSelectedMacroBackground, nil, nil, "+", 10)
	self:moveObject(MacroFrameTextBackground, "-", 10, "+", 10)
	self:moveObject(MacroFrameScrollFrame, "-", 10, nil, nil)
	self:moveObject(MacroDeleteButton, "-", 10, "-", 72)
	self:moveObject(MacroNewButton, "-", 4, "-", 6)
	self:moveObject(MacroExitButton, "-", 4, "-", 6)
	self:moveObject(MacroFrameCharLimitText, nil, nil, "-", 75)

	self:removeRegions(MacroFrameScrollFrame)
	self:skinScrollBar(MacroFrameScrollFrame)
	self:skinEditBox(MacroFrameText, nil, true)
	self:storeAndSkin(ftype, MacroFrameTextBackground)
	self:storeAndSkin(ftype, MacroFrame)

	-- Macro Popup Frame
	self:keepFontStrings(MacroPopupFrame)
	MacroPopupFrame:SetWidth(MacroPopupFrame:GetWidth() * self.FxMult)
	MacroPopupFrame:SetHeight(MacroPopupFrame:GetHeight() - 20) -- N.B. must be absolute not multiple
	self:moveObject(MacroPopupFrame, "+", 40, nil, nil)

	local xOfs, yOfs = 5, 15
	self:moveObject(MacroPopupEditBox, "-", xOfs, "+", yOfs)
	self:moveObject(MacroPopupScrollFrame, "+", 10, "+", yOfs)
	self:moveObject(MacroPopupButton1, "-", xOfs, "+", yOfs)
	self:moveObject(MacroPopupCancelButton, nil, nil, "-", 4)
	self:skinEditBox(MacroPopupEditBox)
	-- regions 5 & 6 are text
	self:moveObject(self:getRegion(MacroPopupFrame, 5), "-", xOfs, "+", yOfs)
	self:moveObject(self:getRegion(MacroPopupFrame, 6), "-", xOfs, "+", yOfs)
	self:removeRegions(MacroPopupScrollFrame)
	self:skinScrollBar(MacroPopupScrollFrame)
	self:storeAndSkin(ftype, MacroPopupFrame)

end

function Skinner:BindingUI()
	if not self.db.profile.MenuFrames or self.initialized.BindingUI then return end
	self.initialized.BindingUI = true

	self:keepFontStrings(KeyBindingFrame)
	KeyBindingFrame:SetWidth(KeyBindingFrame:GetWidth() * 0.95)
	-- N.B. Don't change Height

	self:moveObject(KeyBindingFrameHeaderText, nil, nil, "-", 8)
	self:moveObject(KeyBindingFrameCharacterButton, "+", 30, "+", 5)
	self:moveObject(KeyBindingFrameOutputText, nil, nil, "-", 10)
	self:moveObject(KeyBindingFrameDefaultButton, nil, nil, "-", 14)
	self:moveObject(KeyBindingFrameCancelButton, "+", 40, "-", 14)

	self:removeRegions(KeyBindingFrameScrollFrame)
	self:skinScrollBar(KeyBindingFrameScrollFrame)

	self:storeAndSkin(ftype, KeyBindingFrame)

end

function Skinner:ModelFrames()
--[[
[12:55:21] <dreyruugr> http://ace.pastey.net/551
[12:55:42] <dreyruugr> That should do framerate independant rotation of the model, based on how much the mouse moves
[13:12:43] <dreyruugr> Gngsk: http://ace.pastey.net/552 - This doesn't work quite right, but if you work on it you'll be able to zoom in on the character's face using the y offset of the mouse

This does the trick, but it might be worth stealing chester's code from SuperInspect

]]

	self:SecureHook("Model_RotateLeft", function(model, rotationIncrement)
		if not rotationIncrement then
			rotationIncrement = 0.03
		end
		model.rotation = model.rotation - rotationIncrement
		model:SetRotation(model.rotation)
	end)
	self:SecureHook("Model_RotateRight", function(model, rotationIncrement)
		if not rotationIncrement then
			rotationIncrement = 0.03
		end
		model.rotation = model.rotation + rotationIncrement
		model:SetRotation(model.rotation)
	end)

end

function Skinner:BankFrame()
	if not self.db.profile.BankFrame or self.initialized.BankFrame then return end
	self.initialized.BankFrame = true

	self:keepFontStrings(BankFrame)

	BankFrame:SetWidth(BankFrame:GetWidth() * self.FxMult)
	BankFrame:SetHeight(BankFrame:GetHeight() * self.FyMult)

	self:moveObject(BankFrameTitleText, nil, nil, "-", 35)
	self:moveObject(BankCloseButton, "+", 20, "+", 6)
	self:moveObject(BankFrameItem1, "-", 10, nil, nil)
	-- regions 4 and 5 hold the slot text
	self:moveObject(self:getRegion(BankFrame, 4), "+", 10, "-", 40)
	self:moveObject(self:getRegion(BankFrame, 5), "+", 10, "-", 40)
	self:moveObject(BankFramePurchaseInfo, nil, nil, "-", 40)
	self:moveObject(BankFrameMoneyFrame, nil, nil, "_", 90)

	self:storeAndSkin(ftype, BankFrame)

end

function Skinner:MailFrame()
	if not self.db.profile.MailFrame or self.initialized.MailFrame then return end
	self.initialized.MailFrame = true

	if self.db.profile.TexturedTab then
		self:SecureHook("MailFrameTab_OnClick", function(tab)
--			self:Debug("MailFrameTab_OnClick: [%s]", tab)
--			self:Debug("MailFrameTab_OnClick#2: [%s]", PanelTemplates_GetSelectedTab(MailFrame))
			for i = 1, MailFrame.numTabs do
				local tabName = _G["MailFrameTab"..i]
				if i == MailFrame.selectedTab then
					self:setActiveTab(tabName)
				else
					self:setInactiveTab(tabName)
				end
			end
		end)
	end

	self:SecureHook("OpenMail_Update", function()
--		self:Debug("OpenMail_Update")
		self:moveObject(OpenMailAttachmentText, nil, nil, "-", 70)
		self:moveObject(OpenMailLetterButton, nil, nil, "-", 70)
		self:moveObject(OpenMailMoneyButton, nil, nil, "-", 70)
		for i = 1, ATTACHMENTS_MAX_RECEIVE do
			self:moveObject(_G["OpenMailAttachmentButton"..i], "+", 15, "-", 70)
		end
	end)

	self:keepFontStrings(MailFrame)
	MailFrame:SetWidth(MailFrame:GetWidth() * self.FxMult)
	MailFrame:SetHeight(MailFrame:GetHeight() * self.FyMult)

	self:moveObject(InboxCloseButton, "+", 28, "+", 8)

-->>--	Inbox Frame
	self:moveObject(InboxTitleText, "-", 15, "+", 12)
	self:moveObject(InboxCurrentPage, nil, nil, "+", 12)

	for i = 1, 7 do
		self:keepFontStrings(_G["MailItem"..i])
	end

	local xOfs, yOfs = 5, 20
	self:moveObject(MailItem1, "-", xOfs, "+", yOfs)
	self:moveObject(InboxPrevPageButton, "-", xOfs, "+", yOfs / 2)
	self:moveObject(InboxNextPageButton, "-", xOfs, "+", yOfs / 2)

-->>--	Send Mail Frame
	self:keepFontStrings(SendMailFrame)
	self:moveObject(SendMailTitleText, "-", 15, "+", 12)
	self:removeRegions(SendMailScrollFrame)
	self:skinScrollBar(SendMailScrollFrame)
	self:moveObject(SendMailScrollFrame, "-", 5, nil, nil)

	for _, v in pairs({SendMailCostMoneyFrame, SendMailPackageButton, SendMailCancelButton}) do
		self:moveObject(v, "-", 5, "+", 10)
	end
	self:SecureHook("SendMailFrame_Update", function()
		for i = 1, ATTACHMENTS_MAX_SEND do
			local sma = _G["SendMailAttachment"..i]
			self:moveObject(sma, "-", 10, "-", 10)
			if not sma.skinned then
				self:removeRegions(sma, {1})
				self:addSkinButton(sma, nil, nil, true)
				sma.skinned = true
			end
		end
	end)

	self:moveObject(SendMailNameEditBox, "-", 20, "+", 10)
	self:skinEditBox(SendMailNameEditBox, {6}) -- N.B. region 6 is text
	self:skinEditBox(SendMailSubjectEditBox, {6}) -- N.B. region 6 is text
	self:skinEditBox(SendMailBodyEditBox, nil, true)
	local c = self.db.profile.BodyText
	SendMailBodyEditBox:SetTextColor(c.r, c.g, c.b)

	self:skinMoneyFrame(SendMailMoney)
	self:moveObject(SendMailMoneyGold, "-", 10, nil, nil)
	self:moveObject(SendMailMoneySilver, "-", 10, nil, nil)
	self:moveObject(SendMailCancelButton, "-", 2, "-", 15)

-->>--	Open Mail Frame
	self:keepFontStrings(OpenMailFrame)
	OpenMailFrame:SetWidth(OpenMailFrame:GetWidth() * self.FxMult)
	OpenMailFrame:SetHeight(OpenMailFrame:GetHeight() * self.FyMult)
	self:moveObject(OpenMailTitleText, nil, nil, "-", 24)
	self:moveObject(OpenMailCloseButton, "+", 28, "+", 8)
	self:moveObject(OpenMailSenderLabel, "-", 5, "+", 10)
	self:moveObject(OpenMailReportSpamButton, "+", 36, "+", 12)
	self:moveObject(OpenMailSubjectLabel, "-", 5, "+", 10)
	self:moveObject(OpenMailScrollFrame, "-", 5, "+", 10)
	self:keepFontStrings(OpenMailScrollFrame)
	self:skinScrollBar(OpenMailScrollFrame)
	self:moveObject(OpenMailCancelButton, "+", 30, "-", 72)
	OpenMailBodyText:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:storeAndSkin(ftype, OpenMailFrame)

-->>-- Invoice Frame Text fields
	OpenMailInvoiceItemLabel:SetTextColor(self.BTr, self.BTg, self.BTb)
	OpenMailInvoicePurchaser:SetTextColor(self.BTr, self.BTg, self.BTb)
	OpenMailInvoiceBuyMode:SetTextColor(self.BTr, self.BTg, self.BTb)
	OpenMailInvoiceSalePrice:SetTextColor(self.BTr, self.BTg, self.BTb)
	OpenMailInvoiceDeposit:SetTextColor(self.BTr, self.BTg, self.BTb)
	OpenMailInvoiceHouseCut:SetTextColor(self.BTr, self.BTg, self.BTb)
	OpenMailInvoiceAmountReceived:SetTextColor(self.BTr, self.BTg, self.BTb)
	OpenMailInvoiceNotYetSent:SetTextColor(self.BTr, self.BTg, self.BTb)
	OpenMailInvoiceMoneyDelay:SetTextColor(self.BTr, self.BTg, self.BTb)

-->>--	FrameTabs
	for i = 1, MailFrame.numTabs do
		local tabName = _G["MailFrameTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		if self.db.profile.TexturedTab then self:applySkin(tabName, nil, 0)
		else self:storeAndSkin(ftype, tabName) end
		if i == 1 then
			self:moveObject(tabName, nil, nil, "-", 69)
			if self.db.profile.TexturedTab then self:setActiveTab(tabName) end
		else
			self:moveObject(tabName, "+", 4, nil, nil)
			if self.db.profile.TexturedTab then self:setInactiveTab(tabName) end
		end
	end

	self:storeAndSkin(ftype, MailFrame)

end

function Skinner:AuctionUI()
	if not self.db.profile.AuctionFrame or self.initialized.AuctionUI then return end
	self.initialized.AuctionUI = true

-->>-- Tabs
	if self.db.profile.TexturedTab then
		self:SecureHook("AuctionFrameTab_OnClick", function(index)
--			self:Debug("AuctionFrameTab_OnClick: [%s]", index)
			for i = 1, AuctionFrame.numTabs do
				local tabName = _G["AuctionFrameTab"..i]
				if i == AuctionFrame.selectedTab then
					self:setActiveTab(tabName)
				else
					self:setInactiveTab(tabName)
				end
			end
		end)
	end
	-- hide filter texture when filter is clicked
	self:SecureHook("FilterButton_SetType", function(button, type, text, isLast)
		_G[button:GetName().."NormalTexture"]:SetAlpha(0)
	end)

	self:keepFontStrings(AuctionFrame)
	AuctionFrame:SetHeight(AuctionFrame:GetHeight() - 6)

	self:moveObject(AuctionFrameCloseButton, "-", 4, "+", 8)

-->>--	All Tabs
	for i = 1, AuctionFrame.numTabs do
		local tabName = _G["AuctionFrameTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		if self.db.profile.TexturedTab then self:applySkin(tabName, nil, 0)
		else self:storeAndSkin(ftype, tabName) end
		if i == 1 then
			self:moveObject(tabName, nil, nil, "-", 4)
			if self.db.profile.TexturedTab then self:setActiveTab(tabName) end
		else
			self:moveObject(tabName, "+", 3, nil, nil)
			if self.db.profile.TexturedTab then self:setInactiveTab(tabName) end
		end
	end

	self:moveObject(AuctionFrameMoneyFrame, nil, nil, "-", 6)

-->>--	Browse Frame
	self:moveObject(BrowseTitle, nil, nil, "+", 6)

	self:removeRegions(BrowseFilterScrollFrame)
	self:skinScrollBar(BrowseFilterScrollFrame)
	self:removeRegions(BrowseScrollFrame)
	self:skinScrollBar(BrowseScrollFrame)

	for i = 1, NUM_FILTERS_TO_DISPLAY do
		self:keepRegions(_G["AuctionFilterButton"..i], {3, 4}) -- N.B. region 3 is the highlight, 4 is the text
		self:storeAndSkin(ftype, _G["AuctionFilterButton"..i])
	end

	self:skinDropDown(BrowseDropDown)
	self:moveObject(BrowseDropDownName, "+", 40, nil, nil)

	for _, v in pairs({"Quality", "Level", "Duration", "HighBidder", "CurrentBid"}) do
		local obj = _G["Browse"..v.."Sort"]
		self:keepFontStrings(obj)
		self:storeAndSkin(ftype, obj)
	end

	for k, v in pairs({"Name", "MinLevel", "MaxLevel"}) do
		local obj = _G["Browse"..v]
		self:skinEditBox(obj, {9})
		self:moveObject(obj, "-", 10, "+", (k ~= 3 and 3 or 0))
		obj:SetWidth(obj:GetWidth() + 4)
	end

	self:skinMoneyFrame(BrowseBidPrice)

-->>--	Bid Frame
	self:moveObject(BidTitle, nil, nil, "+", 6)

	self:removeRegions(BidScrollFrame)
	self:skinScrollBar(BidScrollFrame)

	for _, v in pairs({"Quality", "Level", "Duration", "Buyout", "Status", "Bid"}) do
		local obj = _G["Bid"..v.."Sort"]
		self:keepFontStrings(obj)
		self:storeAndSkin(ftype, obj)
	end

	self:skinMoneyFrame(BidBidPrice)

-->>--	Auctions Frame
	self:moveObject(AuctionsTitle, nil, nil, "+", 6)
	self:storeAndSkin(ftype, AuctionsItemButton)
	self:removeRegions(AuctionsScrollFrame)
	self:skinScrollBar(AuctionsScrollFrame)

	for _, v in pairs({"Quality", "Duration", "HighBidder", "Bid"}) do
		local obj = _G["Auctions"..v.."Sort"]
		self:keepFontStrings(obj)
		self:storeAndSkin(ftype, obj)
	end

	self:skinMoneyFrame(StartPrice)
	self:skinMoneyFrame(BuyoutPrice)

	self:storeAndSkin(ftype, AuctionFrame)

-->>--	AuctionDressUp Frame
	self:keepRegions(AuctionDressUpFrame, {3, 4}) --N.B. regions 3 & 4 are the background
	AuctionDressUpFrame:SetWidth(AuctionDressUpFrame:GetWidth() - 6)
	AuctionDressUpFrame:SetHeight(AuctionDressUpFrame:GetHeight() - 13)
	self:moveObject(AuctionDressUpBackgroundTop, nil, nil, "+", 8)

	AuctionDressUpModelRotateLeftButton:Hide()
	AuctionDressUpModelRotateRightButton:Hide()
	self:makeMFRotatable(AuctionDressUpModel)

	self:keepRegions(AuctionDressUpFrameCloseButton, {1}) -- N.B. region 1 is the button artwork
	self:storeAndSkin(ftype, AuctionDressUpFrame)

end

function Skinner:MainMenuBar()
	if not self.db.profile.MainMenuBar.skin or self.initialized.MainMenuBar then return end
	self.initialized.MainMenuBar = true

	-- Don't move the Performance Bar if IPopBar is loaded as it keeps moving up the screen
	if not IsAddOnLoaded("IPopBar") then
		-- hook this to move the PerformanceBar
		self:SecureHook("MainMenuBar_UpdateKeyRing", function()
			if SHOW_KEYRING == 1 then self:moveObject(MainMenuBarPerformanceBarFrame, nil, nil, "+", 4) end
		end)
	end

	-- Hook this to move the Reputation Watch Bar
	self:SecureHook("ReputationWatchBar_Update", function(newLevel)
		self:moveObject(ReputationWatchBar, nil, nil, "-", 4)
	end)

	self:keepFontStrings(MainMenuBar)
	if not MainMenuBarMaxLevelBar:IsShown() then
		MainMenuBar:SetHeight(MainMenuBar:GetHeight() * 1.15)
		self:moveObject(ActionBarUpButton, nil, nil, "-", 4)
		self:moveObject(ActionBarDownButton, nil, nil, "-", 4)
	else
		self:moveObject(ActionBarUpButton, nil, nil, "+", 4)
		self:moveObject(ActionBarDownButton, nil, nil, "+", 4)
		self:moveObject(MainMenuBarPageNumber, nil, nil, "+", 4)
	end
	self:moveObject(MainMenuBar, nil, nil, "-", 4)
	self:storeAndSkin(ftype, MainMenuBar, nil, 0)
	LowerFrameLevel(MainMenuBar)

	-- Experience Bar
	self:keepRegions(MainMenuExpBar, {1, 7}) -- N.B. region 1 is rested XP, 7 is the normal XP
	MainMenuExpBar:SetWidth(MainMenuExpBar:GetWidth() - 8)
	MainMenuExpBar:SetHeight(MainMenuExpBar:GetHeight() * self.FyMult)
	self:moveObject(MainMenuExpBar, nil, nil, "-", 4)
	self:moveObject(MainMenuBarExpText, nil, nil, "-", 1)
	if self.db.profile.MainMenuBar.glazesb then self:glazeStatusBar(MainMenuExpBar, 0) end
	-- Reputation Bar
	self:keepRegions(ReputationWatchStatusBar, {10}) -- 10 is the normal texture
	ReputationWatchStatusBar:SetWidth(MainMenuExpBar:GetWidth())
	self:moveObject(ReputationWatchBar, nil, nil, "-", 4)
--	self:moveObject(ReputationWatchStatusBarText, nil, nil, "-", 3)
	if self.db.profile.MainMenuBar.glazesb then self:glazeStatusBar(ReputationWatchStatusBar, 0) end

-->>--	MainMenuBarOverlayFrame
	self:keepFontStrings(MainMenuBarMaxLevelBar)
	self:keepFontStrings(MainMenuBarArtFrame)
	if not self.isWotLK then
		self:moveObject(MainMenuBarPerformanceBarFrame, nil, nil, "+", 4)
		MainMenuBarPerformanceBarFrame:SetFrameStrata("MEDIUM")
	end
	-- Exhaustion Bar (i.e. Rested)
	ExhaustionLevelFillBar:SetHeight(ExhaustionLevelFillBar:GetHeight() * self.FyMult)
	ExhaustionTick:SetAlpha(0)

	-- don't move these buttons if Dominos is loaded otherwise they appear in the TLHC
	if not IsAddOnLoaded("Dominos") then
		-- move Action Buttons, Micro buttons etc
		self:moveObject(ActionButton1, nil, nil, "+", 3)
		self:moveObject(CharacterMicroButton, nil, nil, "+", 4)
		self:moveObject(MainMenuBarBackpackButton, nil, nil, "+", 4)
	end

	-- move the Bag count
	for i = 0, 3 do
		self:moveObject(_G["CharacterBag"..i.."SlotCount"], "+", 5, "-", 1)
	end
	
	local function toggleActionButtons()

		local babf = BonusActionBarFrame

--		Skinner:Debug("tAB: [%s, %s, %s, %s]", _G["ActionButton1"]:IsShown(),_G["BonusActionButton1"]:IsShown(), babf.mode,  babf.state)

		if babf.mode == "show" or (babf.mode == "none" and babf.state == "top") then
			for i = 1, 12 do
				_G["ActionButton"..i]:SetAlpha(0)
			end
		else
			for i = 1, 12 do
				_G["ActionButton"..i]:SetAlpha(1)
			end
		end

	end

-->>--	BonusActionBar Frame
	self:keepFontStrings(BonusActionBarFrame)
	-- don't move this button if Dominos is loaded otherwise it appears in the TLHC
	if not IsAddOnLoaded("Dominos") then
		self:moveObject(BonusActionButton1, nil, nil, "+", 3)
	end
	if BonusActionBarFrame.mode == "show" then
		toggleActionButtons()
	end
	-- hook these to hide/show ActionButtons when shapeshifting (Druid/Rogue)
	self:SecureHook("ShowBonusActionBar", function(this)
		toggleActionButtons()
	end)
	self:SecureHook("HideBonusActionBar", function(this)
		toggleActionButtons()
	end)
-->>--	ShapeshiftBar Frame
	self:keepFontStrings(ShapeshiftBarFrame)

-->>--	PossessBar Frame
	self:keepFontStrings(PossessBarFrame)

-->>--	PetActionBar Frame
	self:keepFontStrings(PetActionBarFrame)
	-- don't move this button if Dominos is loaded otherwise it appears in the TLHC
	if not IsAddOnLoaded("Dominos") then
		self:moveObject(PetActionButton1, nil, nil, "+", 4)
	end

end

function Skinner:CoinPickup()
	if not self.db.profile.CoinPickup or self.initialized.CoinPickup then return end
	self.initialized.CoinPickup = true

	self:keepFontStrings(CoinPickupFrame)
	CoinPickupFrame:SetWidth(CoinPickupFrame:GetWidth() * 0.8)
	CoinPickupFrame:SetHeight(CoinPickupFrame:GetHeight() * 0.65)
	self:moveObject(CoinPickupGoldIcon, "+", 5, "-", 5)
	self:moveObject(CoinPickupSilverIcon, "+", 5, "-", 5)
	self:moveObject(CoinPickupCopperIcon, "+", 5, "-", 5)
	self:moveObject(CoinPickupText, "+", 5, "-", 5)
	self:moveObject(CoinPickupLeftButton, "+", 10, "-", 5)
	self:moveObject(CoinPickupRightButton, "-", 10, "-", 5)
	self:moveObject(CoinPickupOkayButton, "+", 3, "-", 13)
	self:moveObject(CoinPickupCancelButton, "-", 5, "-", 13)
	self:storeAndSkin(ftype, CoinPickupFrame)

end

function Skinner:GMSurveyUI()
	if not self.db.profile.GMSurveyUI or self.initialized.GMSurveyUI then return end
	self.initialized.GMSurveyUI = true

	self:keepFontStrings(GMSurveyFrame)
	self:keepFontStrings(GMSurveyHeader)

	for i = 1, MAX_SURVEY_QUESTIONS do
		self:storeAndSkin(ftype, _G["GMSurveyQuestion"..i])
	end
	self:storeAndSkin(ftype, GMSurveyCommentFrame)
	self:moveObject(GMSurveyHeaderText, nil, nil, "-", 6)
	self:moveObject(GMSurveyCloseButton, "+", 40, nil, nil)
	self:moveObject(GMSurveyCancelButton, nil, nil, "-", 10)
	self:moveObject(GMSurveySubmitButton, "+", 40, "-", 10)

	self:removeRegions(GMSurveyScrollFrame)
	self:skinScrollBar(GMSurveyScrollFrame)
	self:removeRegions(GMSurveyCommentScrollFrame)
	self:skinScrollBar(GMSurveyCommentScrollFrame)

	self:storeAndSkin(ftype, GMSurveyFrame, true)

end

function Skinner:LFGFrame()
	if not self.db.profile.LFGFrame or self.initialized.LFGFrame then return end
	self.initialized.LFGFrame = true

	if self.db.profile.TexturedTab then
		self:SecureHook("LFGParentFrameTab1_OnClick", function()
--			self:Debug("LFGParentFrameTab1_OnClick")
			self:setActiveTab(LFGParentFrameTab1)
			self:setInactiveTab(LFGParentFrameTab2)
		end)
		self:SecureHook("LFGParentFrameTab2_OnClick", function()
--			self:Debug("LFGParentFrameTab2_OnClick")
			self:setActiveTab(LFGParentFrameTab2)
			self:setInactiveTab(LFGParentFrameTab1)
		end)
	end

	-- hook these to move the comment
	self:SecureHook("LFMFrame_OnShow", function()
		self:moveObject(LFGComment, nil, nil, "-", 80)
	end)
	self:SecureHook("LFGFrame_OnShow", function()
		self:moveObject(LFGComment, nil, nil, "-", 80)
	end)

	LFGParentFrame:SetWidth(LFGParentFrame:GetWidth() * self.FxMult)
	LFGParentFrame:SetHeight(LFGParentFrame:GetHeight() * self.FyMult)
	-- move the close button
	self:moveObject(self:getChild(LFGParentFrame, 4), "+", 28, "+", 8)
	self:skinEditBox(LFGComment, {6})

-->>--	LFG Frame
	self:keepFontStrings(AutoJoinBackground)
	self:skinDropDown(LFGFrameNameDropDown1)
	self:skinDropDown(LFGFrameNameDropDown2)
	self:skinDropDown(LFGFrameNameDropDown3)
	self:skinDropDown(LFGFrameTypeDropDown1)
	self:skinDropDown(LFGFrameTypeDropDown2)
	self:skinDropDown(LFGFrameTypeDropDown3)
	self:moveObject(LFGSearchBg1, "+", 30, nil, nil)
	self:keepRegions(LFGEye, {})
	self:storeAndSkin(ftype, LFGEye)
	self:moveObject(LFGFrameDoneButton, "+", 25, "-", 76)

-->>--	LFM Frame
	self:keepFontStrings(AddMemberBackground)
	self:moveObject(LFMFrameTotals, nil, nil, "-", 76)
	self:skinDropDown(LFMFrameTypeDropDown)
	self:skinDropDown(LFMFrameNameDropDown)
	self:moveObject(LFMFrameTypeDropDown, "-", 10, nil, nil)
	self:skinFFColHeads("LFMFrameColumnHeader") --N.B. Prefix string
	self:moveObject(LFMFrameColumnHeader1, "-", 10, nil, nil)
	self:removeRegions(LFMListScrollFrame)
	self:skinScrollBar(LFMListScrollFrame)
	self:keepFontStrings(LFMEye)
	self:storeAndSkin(ftype, LFMEye)
	self:keepRegions(LFMFrame, {1})
	self:moveObject(LFMFrameGroupInviteButton, "+", 25, "-", 76)

-->>--	Tabs
	self:keepRegions(LFGParentFrameTab1, {7, 8})
	self:keepRegions(LFGParentFrameTab2, {7, 8})
	self:moveObject(LFGParentFrameTab1, nil, nil, "-", 70)
	self:moveObject(LFGParentFrameTab2, "+", 10, nil, nil)
	if self.db.profile.TexturedTab then self:applySkin(LFGParentFrameTab1, nil, 0)
	else self:storeAndSkin(ftype, LFGParentFrameTab1) end

	if self.db.profile.TexturedTab then self:applySkin(LFGParentFrameTab2, nil, 0)
	else self:storeAndSkin(ftype, LFGParentFrameTab2) end

	self:keepFontStrings(LFGParentFrame)
	self:storeAndSkin(ftype, LFGParentFrame)

end

function Skinner:ItemSocketingUI()
	if not self.db.profile.ItemSocketingUI or self.initialized.ItemSocketingUI then return end
	self.initialized.ItemSocketingUI = true

	self:SecureHook("ItemSocketingFrame_Update", function()
		for i = 1, GetNumSockets() do
			-- colour the button border
			local colour = GEM_TYPE_INFO[GetSocketTypes(i)]
			_G["ItemSocketingSocket"..i].sBut:SetBackdropBorderColor(colour.r, colour.g, colour.b)
		end
	end)

	ItemSocketingFrame:SetWidth(CharacterFrame:GetWidth())
	ItemSocketingFrame:SetHeight(CharacterFrame:GetHeight())
	self:moveObject(ItemSocketingCloseButton, nil, nil, "+", 8)
	self:removeRegions(ItemSocketingScrollFrame)
	self:skinScrollBar(ItemSocketingScrollFrame)
	for i = 1, MAX_NUM_SOCKETS do
		local isB = _G["ItemSocketingSocket"..i]
		_G["ItemSocketingSocket"..i.."Left"]:SetAlpha(0)
		_G["ItemSocketingSocket"..i.."Right"]:SetAlpha(0)
		self:getRegion(isB, 3):SetAlpha(0) -- button texture
		self:addSkinButton(isB, nil, nil, true)
	end
	self:moveObject(ItemSocketingSocketButton, nil, nil, "-", 20)
	self:keepFontStrings(ItemSocketingFrame)
	self:storeAndSkin(ftype, ItemSocketingFrame)

	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then ItemSocketingDescription:SetBackdrop(self.backdrop) end
		self:skinTooltip(ItemSocketingDescription)
	end

end

function Skinner:GuildBankUI()
	if not self.db.profile.GuildBankUI or self.initialized.GuildBankUI then return end
	self.initialized.GuildBankUI = true

-->>--	Main Frame
	GuildBankEmblemFrame:Hide()
	self:keepFontStrings(GuildBankFrame)
	self:moveObject(GuildBankTabTitle, nil, nil, "+", 20)
	self:moveObject(self:getChild(GuildBankFrame, 13), "-", 2, "+", 9) -- Close Button
	self:moveObject(GuildBankColumn1, "-", 5, "+", 10)
	for i = 1, 7 do
		_G["GuildBankColumn"..i.."Background"]:SetAlpha(0)
	end
	self:storeAndSkin(ftype, GuildBankFrame, true)

-->>--	Log Frame
	self:removeRegions(GuildBankTransactionsScrollFrame)
	self:skinScrollBar(GuildBankTransactionsScrollFrame)

-->>--	Info Frame
	self:removeRegions(GuildBankInfoScrollFrame)
	self:skinScrollBar(GuildBankInfoScrollFrame)

-->>--	GuildBank Tabs (on the RHS)
	for i = 1, 6 do
		local tabName = _G["GuildBankTab"..i]
		self:keepRegions(tabName, {7, 8})
		if i == 1 then self:moveObject(tabName, "-", 2, nil, nil) end
	end

-->>--	GuildBank Frame Tabs (at the bottom)
	for i = 1, MAX_GUILDBANK_TABS do
		local tabName = _G["GuildBankFrameTab"..i]
		self:keepFontStrings(tabName)
		if self.db.profile.TexturedTab then
			self:applySkin(tabName, nil, 0, 1)
			if i == 1 then self:setActiveTab(tabName)
			else self:setInactiveTab(tabName) end
		else self:storeAndSkin(ftype, tabName) end
		if i == 1 then self:moveObject(tabName, nil, nil, "-", 2)
		else self:moveObject(tabName, "+", 13, nil, nil) end
	end

	if self.db.profile.TexturedTab then
		self:SecureHook("GuildBankFrameTab_OnClick", function(id, doNotUpdate)
			for i = 1, 4 do
				local tabName = _G["GuildBankFrameTab"..i]
				if i == GuildBankFrame.selectedTab then self:setActiveTab(tabName)
				else self:setInactiveTab(tabName) end
			end
		end)
	end


-->>--	GuildBank Popup Frame
	self:keepFontStrings(GuildBankPopupFrame)
	self:skinEditBox(GuildBankPopupEditBox, {9})
	self:removeRegions(GuildBankPopupScrollFrame)
	self:skinScrollBar(GuildBankPopupScrollFrame)
	self:moveObject(GuildBankPopupScrollFrame, "+", 18, nil, nil)
	self:moveObject(GuildBankPopupButton1, "+", 18, nil, nil)
	self:moveObject(GuildBankPopupCancelButton, "-", 12, "-", 14)
	self:storeAndSkin(ftype, GuildBankPopupFrame, true)

end

function Skinner:Nameplates()
	if not self.db.profile.Nameplates or self.initialized.Nameplates then return end
	self.initialized.Nameplates = true

	local npTex = "Interface\\Tooltips\\Nameplate-Border"
	local function isNameplate(obj)

		if obj:GetName() then return false end

		local region
		if not Skinner.isPTR then 
			region = select(1, obj:GetRegions()) -- get the first region used by the nameplate
		else
			region = select(2, obj:GetRegions()) -- get the second region used by the nameplate
		end
		if region and region:IsObjectType("Texture") and region:GetTexture() == npTex then return true
		else return false end

	end

	local function skinNameplates()

		for i = 1, select("#", WorldFrame:GetChildren()) do
			local child = select(i, WorldFrame:GetChildren())
			if isNameplate(child) then
				if not Skinner.isPTR then 
					select(1, child:GetRegions()):SetAlpha(0) -- hide border texture
					select(2, child:GetRegions()):SetAlpha(0) -- hide border texture
					select(4, child:GetRegions()):SetAlpha(0) -- hide glow effect
				else
					select(2, child:GetRegions()):SetAlpha(0) -- hide border texture
					select(3, child:GetRegions()):SetAlpha(0) -- hide border texture
					select(5, child:GetRegions()):SetAlpha(0) -- hide glow effect
				end
				if not child.skinned then
					for i = 1, 2 do -- skin both status bars
						local sb = select(i, child:GetChildren())
						sb:SetStatusBarTexture(Skinner.sbTexture)
						if not sb.bg then
							local bg = sb:CreateTexture(nil, "BORDER")
							bg:SetPoint("TOPLEFT", sb, "TOPLEFT")
							bg:SetPoint("BOTTOMRIGHT", sb, "BOTTOMRIGHT")
							bg:SetTexture(Skinner.sbTexture)
							bg:SetVertexColor(unpack(Skinner.sbColour))
							sb.bg = bg
						end
					end
					child.skinned = true
				end
			end
		end

		-- if the nameplates are off then disable the skinning code
		if not self.isWotLK then
			if NAMEPLATES_ON == nil and FRIENDNAMEPLATES_ON == nil then
				Skinner:CancelScheduledEvent("NameplateUpdateCheck")
			end
		else
			local SHOW_ENEMIES = GetCVarBool("nameplateShowEnemies")
			local SHOW_FRIENDS = GetCVarBool("nameplateShowFriends")
			if not SHOW_ENEMIES and not SHOW_FRIENDS then
				Skinner:CancelScheduledEvent("NameplateUpdateCheck")
			end
		end
		
	end

	local function showFunc()

		if not Skinner:IsEventScheduled("NameplateUpdateCheck") then
			Skinner:ScheduleRepeatingEvent("NameplateUpdateCheck", skinNameplates, 0.2)
		end

	end

	if not self.isWotLK then
		self:SecureHook("ShowNameplates", showFunc)
		self:SecureHook("ShowFriendNameplates", showFunc)
	else
		self:SecureHook("SetCVar", function(varName, varValue, ...)
--			self:Debug("SetCVar:[%s, %s]", varName, varValue)
			if string.find(varName, "nameplateShow") and varValue == 1 then showFunc() end
			end)
	end

	if not self.isWotLK then
		if NAMEPLATES_ON or FRIENDNAMEPLATES_ON then showFunc() end
	else
		local SHOW_ENEMIES = GetCVarBool("nameplateShowEnemies")
		local SHOW_FRIENDS = GetCVarBool("nameplateShowFriends")
		if SHOW_ENEMIES or SHOW_FRIENDS then showFunc() end
	end

end

function Skinner:FeedbackUI()
	if not self.db.profile.Feedback or self.initialized.Feedback then return end
	self.initialized.Feedback = true

	local bbR, bbG, bbB, bbA = unpack(self.bbColour)
	
	local function skinFUIScrollBar(obj)
		
		obj:SetBackdrop(self.backdrop3)
		obj:SetBackdropBorderColor(.2, .2, .2, 1)
		obj:SetBackdropColor(.1, .1, .1, 1)
	
	end

	self:keepFontStrings(FeedbackUI)
	self:keepFontStrings(FeedbackUITitleFrm)
	self:moveObject(FeedbackUIBtnClose, "+", 4, "+", 4)
	FeedbackUIWelcomeFrame:SetBackdrop(nil)
	self:keepFontStrings(FeedbackUI_ModifierKeyDropDown)
	self:keepFontStrings(FeedbackUI_MouseButtonDropDown)
	self:storeAndSkin(ftype, FeedbackUI_ModifierKeyDropDownList)
	self:storeAndSkin(ftype, FeedbackUI_MouseButtonDropDownList)
	self:storeAndSkin(ftype, FeedbackUI)
	
-->-- Survey Frame
	FeedbackUISurveyFrame:SetBackdrop(nil)
	self:keepFontStrings(FeedbackUISurveyFrameSurveysPanelDdlCategory)
	self:keepFontStrings(FeedbackUISurveyFrameSurveysPanelDdlStatus)
	self:storeAndSkin(ftype, FeedbackUISurveyFrameSurveysPanelDdlCategoryList)
	self:storeAndSkin(ftype, FeedbackUISurveyFrameSurveysPanelDdlStatusList)
	skinFUIScrollBar(FeedbackUISurveyFrameSurveysPanelScrollScrollControls)
	FeedbackUISurveyFrameSurveysPanelBorder:SetBackdropBorderColor(bbR, bbG, bbB, bbA)
	FeedbackUISurveyFrameStatusPanelBorder:SetBackdropBorderColor(bbR, bbG, bbB, bbA)
	FeedbackUISurveyFrameStatusPanelLine:SetAlpha(0)
	FeedbackUISurveyFrameStepThroughPanelBorder:SetBackdropBorderColor(bbR, bbG, bbB, bbA)
	self:storeAndSkin(ftype, FeedbackUISurveyFrameStepThroughPanelHeader)
	self:storeAndSkin(ftype, FeedbackUISurveyFrameStepThroughPanelEdit)
	self:removeRegions(FeedbackUISurveyFrameStepThroughPanelEditInput)
	self:skinScrollBar(FeedbackUISurveyFrameStepThroughPanelEditInput)
	skinFUIScrollBar(FeedbackUISurveyFrameStepThroughPanelScrollScrollControls)
	
-->>-- Suggestion Frame	
	FeedbackUISuggestFrame:SetBackdrop(nil)
	FeedbackUISuggestFrameInfoPanelBorder:SetBackdropBorderColor(bbR, bbG, bbB, bbA)
	FeedbackUISuggestFrameStatusPanelBorder:SetBackdropBorderColor(bbR, bbG, bbB, bbA)
	FeedbackUISuggestFrameStatusPanelLine:SetAlpha(0)
	FeedbackUISuggestFrameStepThroughPanelBorder:SetBackdropBorderColor(bbR, bbG, bbB, bbA)
	self:storeAndSkin(ftype, FeedbackUISuggestFrameStepThroughPanelHeader)
	self:storeAndSkin(ftype, FeedbackUISuggestFrameStepThroughPanelEdit)
	self:removeRegions(FeedbackUISuggestFrameStepThroughPanelEditInput)
	self:skinScrollBar(FeedbackUISuggestFrameStepThroughPanelEditInput)
	skinFUIScrollBar(FeedbackUISuggestFrameStepThroughPanelScrollScrollControls)
	
-->>-- Bug Frame
	FeedbackUIBugFrame:SetBackdrop(nil)
	FeedbackUIBugFrameInfoPanelBorder:SetBackdropBorderColor(bbR, bbG, bbB, bbA)
	FeedbackUIBugFrameStatusPanelBorder:SetBackdropBorderColor(bbR, bbG, bbB, bbA)
	FeedbackUIBugFrameStatusPanelLine:SetAlpha(0)
	FeedbackUIBugFrameStepThroughPanelBorder:SetBackdropBorderColor(bbR, bbG, bbB, bbA)
	self:storeAndSkin(ftype, FeedbackUIBugFrameStepThroughPanelHeader)
	self:storeAndSkin(ftype, FeedbackUIBugFrameStepThroughPanelEdit)
	self:removeRegions(FeedbackUIBugFrameStepThroughPanelEditInput)
	self:skinScrollBar(FeedbackUIBugFrameStepThroughPanelEditInput)
	skinFUIScrollBar(FeedbackUIBugFrameStepThroughPanelScrollScrollControls)
	
	-- make the QuestLog Tip Label text visible
	FeedbackUIQuestLogTipLabel:SetTextColor(self.BTr, self.BTg, self.BTb)
	
end
