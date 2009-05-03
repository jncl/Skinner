local ftype = "u"

function Skinner:MenuFrames()
	if not self.db.profile.MenuFrames or self.initialized.MenuFrames then return end
	self.initialized.MenuFrames = true

-->>-- Game Menu Frame
	self:addSkinFrame{obj=GameMenuFrame, ftype=ftype, kfs=true, hdr=true}

-->>-- Video Options
	self:addSkinFrame{obj=VideoOptionsFrame, ftype=ftype, kfs=true, hdr=true}
	self:addSkinFrame{obj=VideoOptionsFrameCategoryFrame, ftype=ftype, kfs=true}
	self:skinSlider(VideoOptionsFrameCategoryFrameListScrollBar)
	self:addSkinFrame{obj=VideoOptionsFramePanelContainer, ftype=ftype}
	-- Resolution Panel
	self:skinDropDown(VideoOptionsResolutionPanelResolutionDropDown)
	self:skinDropDown(VideoOptionsResolutionPanelRefreshDropDown)
	self:skinDropDown(VideoOptionsResolutionPanelMultiSampleDropDown)
	self:addSkinFrame{obj=VideoOptionsResolutionPanel, ftype=ftype}
	-- Brightness subPanel
	self:addSkinFrame{obj=VideoOptionsResolutionPanelBrightness, ftype=ftype}
	-- Effects Panel
	self:addSkinFrame{obj=VideoOptionsEffectsPanel, ftype=ftype}
	self:addSkinFrame{obj=VideoOptionsEffectsPanelQuality, ftype=ftype}
	self:addSkinFrame{obj=VideoOptionsEffectsPanelShaders, ftype=ftype}
	
-->>-- Sound & Voice Options
	self:addSkinFrame{obj=AudioOptionsFrame, ftype=ftype, kfs=true, hdr=true}
	self:skinSlider(AudioOptionsFrameCategoryFrameListScrollBar)
	self:addSkinFrame{obj=AudioOptionsFrameCategoryFrame, ftype=ftype, kfs=true}
	self:addSkinFrame{obj=AudioOptionsFramePanelContainer, ftype=ftype}
	-- Sound Panel
	self:addSkinFrame{obj=AudioOptionsSoundPanel, ftype=ftype}
	self:addSkinFrame{obj=AudioOptionsSoundPanelPlayback, ftype=ftype}
	self:skinDropDown(AudioOptionsSoundPanelHardwareDropDown)
	self:addSkinFrame{obj=AudioOptionsSoundPanelHardware, ftype=ftype}
	self:addSkinFrame{obj=AudioOptionsSoundPanelVolume, ftype=ftype}
	-- Voice Panel
	self:addSkinFrame{obj=AudioOptionsVoicePanel, ftype=ftype}
	self:addSkinFrame{obj=AudioOptionsVoicePanelTalking, ftype=ftype}
	self:skinDropDown(AudioOptionsVoicePanelInputDeviceDropDown)
	self:addSkinFrame{obj=AudioOptionsVoicePanelBinding, ftype=ftype}
	self:skinDropDown(AudioOptionsVoicePanelChatModeDropDown)
	self:addSkinFrame{obj=AudioOptionsVoicePanelListening, ftype=ftype}
	self:skinDropDown(AudioOptionsVoicePanelOutputDeviceDropDown)
	self:addSkinFrame{obj=VoiceChatTalkers, ftype=ftype}
	

-->>-- Mac Options
	if IsMacClient() then
		self:addSkinFrame{obj=MacOptionsFrame, ftype=ftype, kfs=true, hdr=true}
		self:addSkinFrame{obj=MacOptionsFrameMovieRecording, ftype=ftype}
		self:skinDropDown(MacOptionsFrameResolutionDropDown)
		self:skinDropDown(MacOptionsFrameFramerateDropDown)
		self:skinDropDown(MacOptionsFrameCodecDropDown)
		self:addSkinFrame{obj=MacOptionsITunesRemote, ftype=ftype}
		self:addSkinFrame{obj=MacOptionsCompressFrame, ftype=ftype, kfs=true, hdr=true}
		self:addSkinFrame{obj=MacOptionsCancelFrame, ftype=ftype, kfs=true, hdr=true}
		self:addSkinFrame{obj=FolderPicker, ftype=ftype, kfs=true, hdr=true}
		-- Movie Progres Frame
		self:glazeStatusBar(MovieProgressBar, 0)
		self:addSkinFrame{obj=MovieProgressFrame, ftype=ftype}
	end
	
-->>-- Interface
	if self.isTT then
		-- hook this to change the texture for the Active and Inactive tabs
		self:SecureHook("InterfaceOptionsFrame_TabOnClick",function()
			for i = 1, InterfaceOptionsFrame.numTabs do
				local tabSF = self.skinFrame[_G["InterfaceOptionsFrameTab"..i]]
				if i == InterfaceOptionsFrame.selectedTab then
					self:setActiveTab(tabSF)
				else
					self:setInactiveTab(tabSF)
				end
			end
		end)
	end
	
	self:addSkinFrame{obj=InterfaceOptionsFrame, ftype=ftype, kfs=true, hdr=true}
	InterfaceOptionsFrameCategoriesList:SetBackdrop(nil)
	self:skinScrollBar(InterfaceOptionsFrameCategoriesList)
	self:addSkinFrame{obj=InterfaceOptionsFrameCategories, ftype=ftype, kfs=true}
	InterfaceOptionsFrameAddOnsList:SetBackdrop(nil)
	self:skinSlider(InterfaceOptionsFrameAddOnsListScrollBar)
	self:addSkinFrame{obj=InterfaceOptionsFrameAddOns, ftype=ftype, kfs=true}
	self:addSkinFrame{obj=InterfaceOptionsFramePanelContainer, ftype=ftype}

	-- Tabs
	for i = 1, 2 do
		local tabName = _G["InterfaceOptionsFrameTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		self:addSkinFrame{obj=tabName, ftype=ftype, ttab=self.isTT, x1=6, y1=0, x2=-6, y2=-5}
		local tabSF = self.skinFrame[tabName]
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end

	-- Hook this to skin any Interface Option panels
	self:SecureHook("InterfaceOptionsList_DisplayPanel", function(panel)
		self:Debug("IOL_DP: [%s, %s]", panel, panel:GetName())
		-- skin tekKonfig library objects
		if self.tekKonfig then self:tekKonfig() end
		if not self.skinFrame[panel] then
			for i = 1, panel:GetNumChildren() do
				local child = select(i, panel:GetChildren())
				if child then
				 	if self:isDropDown(child) then self:skinDropDown(child)
					elseif child:IsObjectType("EditBox") then self:skinEditBox(child, {9})
					end
				end
			end
			self:addSkinFrame{obj=panel, ftype=ftype, kfs=true}
		end
	end)

end

function Skinner:MacroUI()
	if not self.db.profile.MenuFrames or self.initialized.MacroUI then return end
	self.initialized.MacroUI = true

-->>-- Macro Frame
	self:skinFFToggleTabs("MacroFrameTab", 2)
	self:removeRegions(MacroButtonScrollFrame)
	self:skinScrollBar(MacroButtonScrollFrame)
	self:moveObject(MacroFrameCharLimitText, nil, nil, "-", 2)
	self:removeRegions(MacroFrameScrollFrame)
	self:skinScrollBar(MacroFrameScrollFrame)
	self:skinEditBox(MacroFrameText, nil, true)
	self:addSkinFrame{obj=MacroFrameTextBackground, ftype=ftype}
	self:addSkinFrame{obj=MacroFrame, ftype=ftype, kfs=true, hdr=true, x1=10, y1=-11, x2=-32, y2=71}

-->>-- Macro Popup Frame
	self:skinEditBox(MacroPopupEditBox)
	self:removeRegions(MacroPopupScrollFrame)
	self:skinScrollBar(MacroPopupScrollFrame)
	self:addSkinFrame{obj=MacroPopupFrame, ftype=ftype, kfs=true, x1=8, y1=-8, x2=-2, y2=4}

end

function Skinner:BindingUI()
	if not self.db.profile.MenuFrames or self.initialized.BindingUI then return end
	self.initialized.BindingUI = true

	self:removeRegions(KeyBindingFrameScrollFrame)
	self:skinScrollBar(KeyBindingFrameScrollFrame)
	self:addSkinFrame{obj=KeyBindingFrame, ftype=ftype, kfs=true, hdr=true, x1=0, y1=0, x2=-42, y2=10}

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

	self:addSkinFrame{obj=BankFrame, ftype=ftype, kfs=true, x1=10, y1=-11, x2=-25, y2=91}

end

function Skinner:MailFrame()
	if not self.db.profile.MailFrame or self.initialized.MailFrame then return end
	self.initialized.MailFrame = true

	if self.isTT then
		-- hook this to change the texture for the Active and Inactive tabs
		self:SecureHook("MailFrameTab_OnClick",function(...)
			for i = 1, MailFrame.numTabs do
				local tabSF = self.skinFrame[_G["MailFrameTab"..i]]
				if i == MailFrame.selectedTab then
					self:setActiveTab(tabSF)
				else
					self:setInactiveTab(tabSF)
				end
			end
		end)
	end
	
	self:addSkinFrame{obj=MailFrame, ftype=ftype, kfs=true, x1=10, y1=-12, x2=-32, y2=68}

-->>--	Inbox Frame
	for i = 1, 7 do
		self:keepFontStrings(_G["MailItem"..i])
	end

-->>--	Send Mail Frame
	self:keepFontStrings(SendMailFrame)
	self:removeRegions(SendMailScrollFrame)
	self:skinScrollBar(SendMailScrollFrame)
	self:SecureHook("SendMailFrame_Update", function()
		for i = 1, ATTACHMENTS_MAX_SEND do
			local sma = _G["SendMailAttachment"..i]
			if not self.skinned[sma] then
				self:keepFontStrings(sma)
				self:addSkinButton{obj=sma, hide=true}
			end
		end
	end)

	self:skinEditBox(SendMailNameEditBox, {6}) -- N.B. region 6 is text
	self:skinEditBox(SendMailSubjectEditBox, {6}) -- N.B. region 6 is text
	self:skinEditBox(SendMailBodyEditBox, nil, true)
	local c = self.db.profile.BodyText
	SendMailBodyEditBox:SetTextColor(c.r, c.g, c.b)
	self:skinMoneyFrame(SendMailMoney, nil, nil, true, true)

-->>--	Open Mail Frame
	self:removeRegions(OpenMailScrollFrame)
	self:skinScrollBar(OpenMailScrollFrame)
	OpenMailBodyText:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:addSkinFrame{obj=OpenMailFrame, ftype=ftype, kfs=true, x1=10, y1=-12, x2=-34, y2=68}
	
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
		self:addSkinFrame{obj=tabName, ftype=ftype, ttab=self.isTT, x1=6, y1=0, x2=-6, y2=2}
		local tabSF = self.skinFrame[tabName]
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end

end

function Skinner:AuctionUI()
	if not self.db.profile.AuctionUI or self.initialized.AuctionUI then return end
	self.initialized.AuctionUI = true

	if self.isTT then
		-- hook this to change the texture for the Active and Inactive tabs
		self:SecureHook("AuctionFrameTab_OnClick",function(...)
			for i = 1, AuctionFrame.numTabs do
				local tabSF = self.skinFrame[_G["AuctionFrameTab"..i]]
				if i == AuctionFrame.selectedTab then
					self:setActiveTab(tabSF)
				else
					self:setInactiveTab(tabSF)
				end
			end
		end)
	end

	-- hide filter texture when filter is clicked
	self:SecureHook("FilterButton_SetType", function(button, type, text, isLast)
		_G[button:GetName().."NormalTexture"]:SetAlpha(0)
	end)

	self:addSkinFrame{obj=AuctionFrame, ftype=ftype, kfs=true, hdr=true, x1=10, y1=-12, x2=0, y2=3}

-->>--	Browse Frame
	for k, v in pairs({"Name", "MinLevel", "MaxLevel"}) do
		local obj = _G["Browse"..v]
		self:skinEditBox(obj, {9})
	end
	self:skinDropDown(BrowseDropDown)
	for _, v in pairs({"Quality", "Level", "Duration", "HighBidder", "CurrentBid"}) do
		local obj = _G["Browse"..v.."Sort"]
		self:keepRegions(obj, {4, 5, 6}) -- N.B. region 4 is the text, 5 is the arrow, 6 is the highlight
		self:addSkinFrame{obj=obj, ftype=ftype}
	end
	self:removeRegions(BrowseFilterScrollFrame)
	self:skinScrollBar(BrowseFilterScrollFrame)
	for i = 1, NUM_FILTERS_TO_DISPLAY do
		self:keepRegions(_G["AuctionFilterButton"..i], {3, 4}) -- N.B. region 3 is the highlight, 4 is the text
		self:addSkinFrame{obj=_G["AuctionFilterButton"..i], ftype=ftype}
	end
	self:removeRegions(BrowseScrollFrame)
	self:skinScrollBar(BrowseScrollFrame)
	self:skinMoneyFrame(BrowseBidPrice, nil, nil, true)

-->>--	Bid Frame
	self:removeRegions(BidScrollFrame)
	self:skinScrollBar(BidScrollFrame)
	for _, v in pairs({"Quality", "Level", "Duration", "Buyout", "Status", "Bid"}) do
		local obj = _G["Bid"..v.."Sort"]
		self:keepRegions(obj, {4, 5, 6}) -- N.B. region 4 is the text, 5 is the arrow, 6 is the highlight
		self:addSkinFrame{obj=obj, ftype=ftype}
	end
	self:skinMoneyFrame(BidBidPrice, nil, nil, true)

-->>--	Auctions Frame
	self:addSkinFrame{obj=AuctionsItemButton, ftype=ftype}
	self:removeRegions(AuctionsScrollFrame)
	self:skinScrollBar(AuctionsScrollFrame)
	for _, v in pairs({"Quality", "Duration", "HighBidder", "Bid"}) do
		local obj = _G["Auctions"..v.."Sort"]
		self:keepRegions(obj, {4, 5, 6}) -- N.B. region 4 is the text, 5 is the arrow, 6 is the highlight
		self:addSkinFrame{obj=obj, ftype=ftype}
	end
	self:skinMoneyFrame(StartPrice, nil, nil, true)
	self:skinMoneyFrame(BuyoutPrice, nil, nil, true)

-->>--	Auction DressUp Frame
	self:keepRegions(AuctionDressUpFrame, {3, 4}) --N.B. regions 3 & 4 are the background
	self:keepRegions(AuctionDressUpFrameCloseButton, {1}) -- N.B. region 1 is the button artwork
	AuctionDressUpModelRotateLeftButton:Hide()
	AuctionDressUpModelRotateRightButton:Hide()
	self:makeMFRotatable(AuctionDressUpModel)
	self:moveObject(AuctionDressUpFrame, "+", 6)
	self:addSkinFrame{obj=AuctionDressUpFrame, ftype=ftype, x1=-6, y1=-3, x2=-2, y2=0}
-->>--	Tabs
	for i = 1, AuctionFrame.numTabs do
		local tabName = _G["AuctionFrameTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		self:addSkinFrame{obj=tabName, ftype=ftype, ttab=self.isTT, x1=6, y1=0, x2=-6, y2=2}
		local tabSF = self.skinFrame[tabName]
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end
	
end

function Skinner:MainMenuBar()
	if not self.db.profile.MainMenuBar.skin or self.initialized.MainMenuBar then return end
	self.initialized.MainMenuBar = true

	if self.db.profile.MainMenuBar.glazesb then
		self:glazeStatusBar(MainMenuExpBar, 0)
 		self:glazeStatusBar(ReputationWatchStatusBar, 0)
	end
	
	if IsAddOnLoaded("Dominos") then return end

-->>-- Main Menu Bar
	self:keepFontStrings(MainMenuBarMaxLevelBar)
	self:keepFontStrings(MainMenuBarArtFrame)
	ExhaustionTick:SetAlpha(0)
	MainMenuExpBar:SetHeight(MainMenuExpBar:GetHeight() - 2) -- shrink it so it moves up
	self:addSkinFrame{obj=MainMenuBar, ftype=ftype, kfs=true, mmb=true, x1=-4, y1=-7, x2=4, y2=-4}
	
--[[
	-- bugfix ??
	if MainMenuBar:GetFrameLevel() > 0 then
	    LowerFrameLevel(MainMenuBar)
	end
--]]

	-- Experience Bar
	self:keepRegions(MainMenuExpBar, {1, 7}) -- N.B. region 1 is rested XP, 7 is the normal XP
	-- Reputation Bar
	self:keepRegions(ReputationWatchStatusBar, {10}) -- 10 is the normal texture

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

-->>--	Bonus Action Bar Frame
	self:keepFontStrings(BonusActionBarFrame)
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
-->>--	Shapeshift Bar Frame
	self:keepFontStrings(ShapeshiftBarFrame)
	-- skin shapeshift buttons
	for i = 1, NUM_SHAPESHIFT_SLOTS do
		local ssBtn = _G["ShapeshiftButton"..i]
		self:addSkinButton{obj=ssBtn}
	end

-->>--	Possess Bar Frame
	self:keepFontStrings(PossessBarFrame)

-->>--	Pet Action Bar Frame
	self:keepFontStrings(PetActionBarFrame)

end

function Skinner:CoinPickup()
	if not self.db.profile.CoinPickup or self.initialized.CoinPickup then return end
	self.initialized.CoinPickup = true

	self:addSkinFrame{obj=CoinPickupFrame, ftype=ftype, kfs=true, x1=9, y1=-12, x2=-6, y2=12}
	
end

function Skinner:GMSurveyUI()
	if not self.db.profile.GMSurveyUI or self.initialized.GMSurveyUI then return end
	self.initialized.GMSurveyUI = true

	self:keepFontStrings(GMSurveyHeader)
	self:moveObject(GMSurveyHeaderText, nil, nil, "-", 8)
	self:addSkinFrame{obj=GMSurveyFrame, ftype=ftype, kfs=true, y1=-6, x2=-45}

	self:removeRegions(GMSurveyScrollFrame)
	self:skinScrollBar(GMSurveyScrollFrame)

	-- this isn't working, questions are hidden behind the skin
	for i = 1, MAX_SURVEY_QUESTIONS do
		self:addSkinFrame{obj=_G["GMSurveyQuestion"..i], ftype=ftype, y1=-2}
	end

	self:removeRegions(GMSurveyCommentScrollFrame)
	self:skinScrollBar(GMSurveyCommentScrollFrame)
	self:addSkinFrame{obj=GMSurveyCommentFrame, ftype=ftype}

end

function Skinner:LFGFrame()
	if not self.db.profile.LFGFrame or self.initialized.LFGFrame then return end
	self.initialized.LFGFrame = true

	if self.isTT then
		self:SecureHookScript(LFGFrame, "OnShow", function(this)
			self:setActiveTab(self.skinFrame[LFGParentFrameTab1])
			self:setInactiveTab(self.skinFrame[LFGParentFrameTab2])
		end)
		self:SecureHookScript(LFMFrame, "OnShow", function(this)
			self:setActiveTab(self.skinFrame[LFGParentFrameTab2])
			self:setInactiveTab(self.skinFrame[LFGParentFrameTab1])
		end)
	end
	LFGFrameRolesBorder:SetBackdrop(nil)
	LFGFrameQueue1Border:SetBackdrop(nil)
	LFGFrameQueue2Border:SetBackdrop(nil)
	LFGFrameQueue3Border:SetBackdrop(nil)

	self:addSkinFrame{obj=LFGParentFrame, ftype=ftype, kfs=true, x1=17, y1=-11, x2=-30, y2=70}
	
-->>--	LFG Frame
	self:keepFontStrings(AutoJoinBackground)
	self:skinDropDown(LFGFrameNameDropDown1)
	self:skinDropDown(LFGFrameNameDropDown2)
	self:skinDropDown(LFGFrameNameDropDown3)
	self:skinDropDown(LFGFrameTypeDropDown1)
	self:skinDropDown(LFGFrameTypeDropDown2)
	self:skinDropDown(LFGFrameTypeDropDown3)
	self:addSkinFrame{obj=LFGEye, ftype=ftype, kfs=true}
	
-->>--	LFM Frame
	self:keepRegions(LFMFrame, {2}) -- totals text
	self:keepFontStrings(AddMemberBackground)
	self:skinDropDown(LFMFrameTypeDropDown)
	self:skinDropDown(LFMFrameNameDropDown)
	self:keepFontStrings(LFMFrameDropDown1)
	self:skinFFColHeads("LFMFrameColumnHeader", 3) -- first 3
	self:keepRegions(LFMFrameColumnHeader4Group, {4, 5}) -- N.B 4 is text, 5 is highlight
	self:addSkinFrame{obj=LFMFrameColumnHeader4Group, ftype=ftype}
	
	for i = 4, 7 do
		self:keepRegions(_G["LFMFrameColumnHeader"..i], {4, 5, 6}) -- N.B 4 is text, 5 is highlight, 6 is icon
		self:addSkinFrame{obj=_G["LFMFrameColumnHeader"..i], ftype=ftype}
	end

	LFMFrameRoleBackground:Hide()
	self:removeRegions(LFMListScrollFrame)
	self:skinScrollBar(LFMListScrollFrame)
	self:addSkinFrame{obj=LFMEye, ftype=ftype, kfs=true}

-->>--	Tabs
	for i = 1, 2 do
		local tabName = _G["LFGParentFrameTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		self:addSkinFrame{obj=tabName, ftype=ftype, ttab=self.isTT, x1=6, y1=0, x2=-6, y2=2}
		local tabSF = self.skinFrame[tabName]
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end

end

function Skinner:ItemSocketingUI()
	if not self.db.profile.ItemSocketingUI or self.initialized.ItemSocketingUI then return end
	self.initialized.ItemSocketingUI = true

	local function colourSockets()
	
		for i = 1, GetNumSockets() do
			local colour = GEM_TYPE_INFO[GetSocketTypes(i)]
			self.sBut[_G["ItemSocketingSocket"..i]]:SetBackdropBorderColor(colour.r, colour.g, colour.b)
		end

	end
	-- hook this to colour the button border
	self:SecureHook("ItemSocketingFrame_Update", function()
		colourSockets()
	end)

	self:addSkinFrame{obj=ItemSocketingFrame, ftype=ftype, kfs=true, x1=10, y1=-12, x2=-4, y2=26}

	self:removeRegions(ItemSocketingScrollFrame)
	self:skinScrollBar(ItemSocketingScrollFrame)

	for i = 1, MAX_NUM_SOCKETS do
		local isB = _G["ItemSocketingSocket"..i]
		_G["ItemSocketingSocket"..i.."Left"]:SetAlpha(0)
		_G["ItemSocketingSocket"..i.."Right"]:SetAlpha(0)
		self:getRegion(isB, 3):SetAlpha(0) -- button texture
		self:addSkinButton{obj=isB}
	end
	-- now colour the sockets
	colourSockets()
	
	-- Tooltip
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then ItemSocketingDescription:SetBackdrop(self.backdrop) end
		self:skinTooltip(ItemSocketingDescription)
	end

end

function Skinner:GuildBankUI()
	if not self.db.profile.GuildBankUI or self.initialized.GuildBankUI then return end
	self.initialized.GuildBankUI = true

	if self.isTT then
		-- hook this to change the texture for the Active and Inactive tabs
		self:SecureHook("GuildBankFrameTab_OnClick",function(...)
			for i = 1, 4 do
				local tabSF = self.skinFrame[_G["GuildBankFrameTab"..i]]
				if i == GuildBankFrame.selectedTab then
					self:setActiveTab(tabSF)
				else
					self:setInactiveTab(tabSF)
				end
			end
		end)
	end

-->>--	Main Frame
	GuildBankEmblemFrame:Hide()
	for i = 1, 7 do
		_G["GuildBankColumn"..i.."Background"]:SetAlpha(0)
	end
	self:addSkinFrame{obj=GuildBankFrame, ftype=ftype, kfs=true, hdr=true, y1=-11, y2=1}
	
-->>--	Log Frame
	self:removeRegions(GuildBankTransactionsScrollFrame)
	self:skinScrollBar(GuildBankTransactionsScrollFrame)

-->>--	Info Frame
	self:removeRegions(GuildBankInfoScrollFrame)
	self:skinScrollBar(GuildBankInfoScrollFrame)

-->>--	GuildBank Popup Frame
	self:skinEditBox(GuildBankPopupEditBox, {9})
	self:removeRegions(GuildBankPopupScrollFrame)
	self:skinScrollBar(GuildBankPopupScrollFrame)
	self:addSkinFrame{obj=GuildBankPopupFrame, ftype=ftype, kfs=true, hdr=true, x1=2, y1=-12, x2=-24, y2=24}
	
-->>--	GuildBank Tabs (side)
	for i = 1, MAX_GUILDBANK_TABS do
		local tabName = _G["GuildBankTab"..i]
		self:keepRegions(tabName, {7, 8})
	end

-->>--	GuildBank Frame Tabs (bottom)
	for i = 1, 4 do
		local tabName = _G["GuildBankFrameTab"..i]
		self:keepFontStrings(tabName)
		self:addSkinFrame{obj=tabName, ftype=ftype, ttab=self.isTT, x1=6, x2=-6, y2=2}
		local tabSF = self.skinFrame[tabName]
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end
	
end

function Skinner:Nameplates()
	if not self.db.profile.Nameplates or self.initialized.Nameplates then return end
	self.initialized.Nameplates = true

	local npTex = "Interface\\Tooltips\\Nameplate-Border"
	local npEvt
	local function isNameplate(obj)

		if obj:GetName() then return false end

		local region
		region = select(2, obj:GetRegions()) -- get the second region used by the nameplate
		if region and region:IsObjectType("Texture") and region:GetTexture() == npTex then return true
		else return false end

	end

	local function skinNameplates()

		for i = 1, WorldFrame:GetNumChildren() do
			local child = select(i, WorldFrame:GetChildren())
			if isNameplate(child) then
-- 				Skinner:ShowInfo(child, true)
				-- child 1 is the flash texture
				select(2, child:GetRegions()):SetAlpha(0) -- hide border texture
				select(3, child:GetRegions()):SetAlpha(0) -- hide border texture
				-- child 4 is the spell icon
				select(5, child:GetRegions()):SetAlpha(0) -- hide glow effect
				-- children 6 & 7 are text, 8 & 9 are raid icons, 10 is the elite icon
				if not Skinner.skinned[child] then
					for i = 1, 2 do -- skin both status bars
						local sb = select(i, child:GetChildren())
						Skinner:glazeStatusBar(sb, 0, true)
					end
				end
			end
		end

		-- if the nameplates are off then disable the skinning code
		local SHOW_ENEMIES = GetCVarBool("nameplateShowEnemies")
		local SHOW_FRIENDS = GetCVarBool("nameplateShowFriends")
		if not SHOW_ENEMIES and not SHOW_FRIENDS then
			Skinner:CancelTimer(npEvt, true)
			npEvt = nil
		end

	end

	local function showFunc()

		if not npEvt then
			npEvt = Skinner:ScheduleRepeatingTimer(skinNameplates, 0.2)
		end

	end

	self:SecureHook("SetCVar", function(varName, varValue, ...)
--		self:Debug("SetCVar:[%s, %s]", varName, varValue)
		if string.find(varName, "nameplateShow") and varValue == 1 then showFunc() end
	end)

	local SHOW_ENEMIES = GetCVarBool("nameplateShowEnemies")
	local SHOW_FRIENDS = GetCVarBool("nameplateShowFriends")
	if SHOW_ENEMIES or SHOW_FRIENDS then showFunc() end

end

function Skinner:GMChatUI()
	if not self.db.profile.HelpFrame then return end

	self:applySkin(self:getChild(GMChatStatusFrame, 1)) -- GM Chat Request frame

-->>-- GMChat Frame
	self:keepFontStrings(GMChatTab)
	GMChatTab:ClearAllPoints()
	GMChatTab:SetPoint("BOTTOMLEFT", GMChatFrame, "TOPLEFT")
	GMChatTab:SetPoint("TOPRIGHT", GMChatFrame, "TOPRIGHT", 0, 30)
	GMChatFrameCloseButton:ClearAllPoints()
	GMChatFrameCloseButton:SetPoint("RIGHT", GMChatTab, "RIGHT")
	self:applySkin(GMChatTab)

end

-- PTR only
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
