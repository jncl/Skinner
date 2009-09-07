local _G = _G
local select = select
local IsAddOnLoaded = IsAddOnLoaded
local ftype = "u"

function Skinner:ModelFrames()
	if not self.db.profile.CharacterFrames then return end
--[[
[12:55:21] <dreyruugr> http://ace.pastey.net/551
[12:55:42] <dreyruugr> That should do framerate independant rotation of the model, based on how much the mouse moves
[13:12:43] <dreyruugr> Gngsk: http://ace.pastey.net/552 - This doesn't work quite right, but if you work on it you'll be able to zoom in on the character's face using the y offset of the mouse

This does the trick, but it might be worth stealing chester's code from SuperInspect

]]
	-- these are hooked to suppress the sound the normal functions use
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

function Skinner:MovieProgress()
	if not self.db.profile.MovieProgress or self.initialized.MovieProgress then return end
	self.initialized.MovieProgress = true

	if not MovieProgressFrame:IsShown() then
		self:SecureHook(MovieProgressFrame, "Show", function(this)
			self:getChild(MovieProgressBar, 1):SetBackdrop(nil)
			self:keepFontStrings(MovieProgressFrame)
			self:glazeStatusBar(MovieProgressBar, 0)
			self:Unhook(MovieProgressFrame, "Show")
		end)
	else
		self:getChild(MovieProgressBar, 1):SetBackdrop(nil)
		self:keepFontStrings(MovieProgressFrame)
		self:glazeStatusBar(MovieProgressBar, 0)
	end

end

function Skinner:TimeManager()
	if not self.db.profile.TimeManager or self.initialized.TimeManager then return end
	self.initialized.TimeManager = true

-->>--	Time Manager Frame
	TimeManagerFrameTicker:Hide()
	self:keepFontStrings(TimeManagerStopwatchFrame)
	self:skinDropDown{obj=TimeManagerAlarmHourDropDown}
	TimeManagerAlarmHourDropDownMiddle:SetWidth(TimeManagerAlarmHourDropDownMiddle:GetWidth() + 8)
	self:skinDropDown{obj=TimeManagerAlarmMinuteDropDown}
	TimeManagerAlarmMinuteDropDownMiddle:SetWidth(TimeManagerAlarmMinuteDropDownMiddle:GetWidth() + 8)
	self:skinDropDown{obj=TimeManagerAlarmAMPMDropDown}
	self:skinEditBox{obj=TimeManagerAlarmMessageEditBox, regs={9}}
	self:addSkinFrame{obj=TimeManagerFrame, ft=ftype, kfs=true, x1=14, y1=-11, x2=-49, y2=9}

-->>--	Time Manager Clock Button
	self:removeRegions(TimeManagerClockButton, {1})
	self:addSkinFrame{obj=TimeManagerClockButton, ft=ftype, x1=7, y1=-3, x2=-7, y2=3}

-->>--	Stopwatch Frame
	self:keepFontStrings(StopwatchTabFrame)
	self:addSkinFrame{obj=StopwatchFrame, ft=ftype, kfs=true, y1=-16, y2=2}

end

function Skinner:Calendar()
	if not self.db.profile.Calendar or self.initialized.Calendar then return end
	self.initialized.Calendar = true

-->>--	Calendar Frame

	self:skinDropDown{obj=CalendarFilterFrame, noMove=true}
	-- adjust non standard dropdown
	CalendarFilterFrameMiddle:SetHeight(16)
	self:moveObject{obj=CalendarFilterButton, x=-8}
	self:moveObject{obj=CalendarFilterFrameText, x=-8}
	-- move close button
	self:moveObject{obj=CalendarCloseButton, y=14}
	self:addSkinFrame{obj=CalendarFrame, ft=ftype, kfs=true, x1=1, y1=-2, x2=2, y2=-7}

-->>-- View Holiday Frame
	self:keepFontStrings(CalendarViewHolidayTitleFrame)
	self:moveObject{obj=CalendarViewHolidayTitleFrame, y=-6}
	self:removeRegions(CalendarViewHolidayCloseButton, {4})
	self:skinScrollBar{obj=CalendarViewHolidayScrollFrame}
	self:addSkinFrame{obj=CalendarViewHolidayFrame, ft=ftype, kfs=true, x1=2, y1=-3, x2=-3, y2=-2}

-->>-- View Raid Frame
	self:keepFontStrings(CalendarViewRaidTitleFrame)
	self:moveObject{obj=CalendarViewRaidTitleFrame, y=-6}
	self:removeRegions(CalendarViewRaidCloseButton, {4})
	self:skinScrollBar{obj=CalendarViewRaidScrollFrame}
	self:addSkinFrame{obj=CalendarViewRaidFrame, ft=ftype, kfs=true, x1=2, y1=-3, x2=-3, y2=2}

-->>-- View Event Frame
	self:keepFontStrings(CalendarViewEventTitleFrame)
	self:moveObject{obj=CalendarViewEventTitleFrame, y=-6}
	self:removeRegions(CalendarViewEventCloseButton, {4})
	self:addSkinFrame{obj=CalendarViewEventDescriptionContainer, ft=ftype}
	self:skinScrollBar{obj=CalendarViewEventDescriptionScrollFrame}
	self:keepFontStrings(CalendarViewEventInviteListSection)
	self:addSkinFrame{obj=CalendarViewEventInviteList, ft=ftype}
	self:addSkinFrame{obj=CalendarViewEventFrame, ft=ftype, kfs=true, x1=2, y1=-3, x2=-3, y2=2}

-->>-- Create Event Frame
	CalendarCreateEventIcon:SetAlpha(1) -- show event icon
	self:keepFontStrings(CalendarCreateEventTitleFrame)
	self:moveObject{obj=CalendarCreateEventTitleFrame, y=-6}
	self:removeRegions(CalendarCreateEventCloseButton, {4})
	self:skinEditBox{obj=CalendarCreateEventTitleEdit, regs={9}}
	self:skinDropDown{obj=CalendarCreateEventTypeDropDown}
	self:skinDropDown{obj=CalendarCreateEventHourDropDown}
	CalendarCreateEventHourDropDownMiddle:SetWidth(CalendarCreateEventHourDropDownMiddle:GetWidth() + 8)
	self:skinDropDown{obj=CalendarCreateEventMinuteDropDown}
	CalendarCreateEventMinuteDropDownMiddle:SetWidth(CalendarCreateEventMinuteDropDownMiddle:GetWidth() + 8)
	self:skinDropDown{obj=CalendarCreateEventAMPMDropDown}
	self:skinDropDown{obj=CalendarCreateEventRepeatOptionDropDown}
	self:addSkinFrame{obj=CalendarCreateEventDescriptionContainer, ft=ftype}
	self:skinScrollBar{obj=CalendarCreateEventDescriptionScrollFrame}
	self:keepFontStrings(CalendarCreateEventInviteListSection)
	self:addSkinFrame{obj=CalendarCreateEventInviteList, ft=ftype}
	self:skinEditBox{obj=CalendarCreateEventInviteEdit, regs={9}}
	CalendarCreateEventMassInviteButtonBorder:SetAlpha(0)
	-- TODO Fix this to be skinned properly when in a raid
	if CalendarCreateEventRaidInviteButtonBorder then CalendarCreateEventRaidInviteButtonBorder:SetAlpha(0) end
	CalendarCreateEventCreateButtonBorder:SetAlpha(0)
	self:addSkinFrame{obj=CalendarCreateEventFrame, ft=ftype, kfs=true, x1=2, y1=-3, x2=-3, y2=2}

-->>-- Mass Invite Frame
	self:keepFontStrings(CalendarMassInviteTitleFrame)
	self:moveObject{obj=CalendarMassInviteTitleFrame, y=-6}
	self:removeRegions(CalendarMassInviteCloseButton, {4})
	self:skinEditBox{obj=CalendarMassInviteGuildMinLevelEdit, regs={9}}
	self:skinEditBox{obj=CalendarMassInviteGuildMaxLevelEdit, regs={9}}
	self:skinDropDown{obj=CalendarMassInviteGuildRankMenu}
	self:addSkinFrame{obj=CalendarMassInviteFrame, ft=ftype, kfs=true, x1=4, y1=-3, x2=-3, y2=26}

-->>-- Event Picker Frame
	self:keepFontStrings(CalendarEventPickerTitleFrame)
	self:moveObject{obj=CalendarEventPickerTitleFrame, y=-6}
	self:keepFontStrings(CalendarEventPickerFrame)
	self:skinSlider(CalendarEventPickerScrollBar)
	self:removeRegions(CalendarEventPickerCloseButton, {7})
	self:addSkinFrame{obj=CalendarEventPickerFrame, ft=ftype, x1=2, y1=-3, x2=-3, y2=2}

-->>-- Texture Picker Frame
	self:keepFontStrings(CalendarTexturePickerTitleFrame)
	self:moveObject{obj=CalendarTexturePickerTitleFrame, y=-6}
	self:skinSlider(CalendarTexturePickerScrollBar)
	CalendarTexturePickerCancelButtonBorder:SetAlpha(0)
	CalendarTexturePickerAcceptButtonBorder:SetAlpha(0)
	self:addSkinFrame{obj=CalendarTexturePickerFrame, ft=ftype, kfs=true, x1=5, y1=-3, x2=-3, y2=2}

-->>-- Class Button Container
	for i = 1, MAX_CLASSES do -- allow for the total button
		self:removeRegions(_G["CalendarClassButton"..i], {1})
	end
	self:keepFontStrings(CalendarClassTotalsButton)
	-- Class Totals button, texture & size changes
	CalendarClassTotalsButtonBackgroundMiddle:SetTexture(self.itTex)
	self:moveObject{obj=CalendarClassTotalsButtonBackgroundMiddle, x=2}
	CalendarClassTotalsButtonBackgroundMiddle:SetWidth(18)
	CalendarClassTotalsButtonBackgroundMiddle:SetHeight(18)
	CalendarClassTotalsButtonBackgroundMiddle:SetAlpha(1)

end

function Skinner:MenuFrames()
	if not self.db.profile.MenuFrames or self.initialized.MenuFrames then return end
	self.initialized.MenuFrames = true

-->>-- Game Menu Frame
	self:addSkinFrame{obj=GameMenuFrame, ft=ftype, kfs=true, hdr=true}

-->>-- Video Options
	self:addSkinFrame{obj=VideoOptionsFrame, ft=ftype, kfs=true, hdr=true}
	self:addSkinFrame{obj=VideoOptionsFrameCategoryFrame, ft=ftype, kfs=true}
	self:skinSlider(VideoOptionsFrameCategoryFrameListScrollBar)
	self:addSkinFrame{obj=VideoOptionsFramePanelContainer, ft=ftype}
	-- Resolution Panel
	self:skinDropDown{obj=VideoOptionsResolutionPanelResolutionDropDown}
	self:skinDropDown{obj=VideoOptionsResolutionPanelRefreshDropDown}
	self:skinDropDown{obj=VideoOptionsResolutionPanelMultiSampleDropDown}
	self:addSkinFrame{obj=VideoOptionsResolutionPanel, ft=ftype}
	-- Brightness subPanel
	self:addSkinFrame{obj=VideoOptionsResolutionPanelBrightness, ft=ftype}
	-- Effects Panel
	self:addSkinFrame{obj=VideoOptionsEffectsPanel, ft=ftype}
	self:addSkinFrame{obj=VideoOptionsEffectsPanelQuality, ft=ftype}
	self:addSkinFrame{obj=VideoOptionsEffectsPanelShaders, ft=ftype}

-->>-- Sound & Voice Options
	self:addSkinFrame{obj=AudioOptionsFrame, ft=ftype, kfs=true, hdr=true}
	self:skinSlider(AudioOptionsFrameCategoryFrameListScrollBar)
	self:addSkinFrame{obj=AudioOptionsFrameCategoryFrame, ft=ftype, kfs=true}
	self:addSkinFrame{obj=AudioOptionsFramePanelContainer, ft=ftype}
	-- Sound Panel
	self:addSkinFrame{obj=AudioOptionsSoundPanel, ft=ftype}
	self:addSkinFrame{obj=AudioOptionsSoundPanelPlayback, ft=ftype}
	self:skinDropDown{obj=AudioOptionsSoundPanelHardwareDropDown}
	self:addSkinFrame{obj=AudioOptionsSoundPanelHardware, ft=ftype}
	self:addSkinFrame{obj=AudioOptionsSoundPanelVolume, ft=ftype}
	-- Voice Panel
	self:addSkinFrame{obj=AudioOptionsVoicePanel, ft=ftype}
	self:addSkinFrame{obj=AudioOptionsVoicePanelTalking, ft=ftype}
	self:skinDropDown{obj=AudioOptionsVoicePanelInputDeviceDropDown}
	self:addSkinFrame{obj=AudioOptionsVoicePanelBinding, ft=ftype}
	self:skinDropDown{obj=AudioOptionsVoicePanelChatModeDropDown}
	self:addSkinFrame{obj=AudioOptionsVoicePanelListening, ft=ftype}
	self:skinDropDown{obj=AudioOptionsVoicePanelOutputDeviceDropDown}
	self:addSkinFrame{obj=VoiceChatTalkers, ft=ftype}


-->>-- Mac Options
	if IsMacClient() then
		self:addSkinFrame{obj=MacOptionsFrame, ft=ftype, kfs=true, hdr=true}
		self:addSkinFrame{obj=MacOptionsFrameMovieRecording, ft=ftype}
		self:skinDropDown{obj=MacOptionsFrameResolutionDropDown}
		self:skinDropDown{obj=MacOptionsFrameFramerateDropDown}
		self:skinDropDown{obj=MacOptionsFrameCodecDropDown}
		self:addSkinFrame{obj=MacOptionsITunesRemote, ft=ftype}
		self:addSkinFrame{obj=MacOptionsCompressFrame, ft=ftype, kfs=true, hdr=true}
		self:addSkinFrame{obj=MacOptionsCancelFrame, ft=ftype, kfs=true, hdr=true}
		self:addSkinFrame{obj=FolderPicker, ft=ftype, kfs=true, hdr=true}
		-- Movie Progres Frame
		self:glazeStatusBar(MovieProgressBar, 0)
		self:addSkinFrame{obj=MovieProgressFrame, ft=ftype}
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

	self:addSkinFrame{obj=InterfaceOptionsFrame, ft=ftype, kfs=true, hdr=true}
	InterfaceOptionsFrameCategoriesList:SetBackdrop(nil)
	self:skinScrollBar{obj=InterfaceOptionsFrameCategoriesList}
	self:addSkinFrame{obj=InterfaceOptionsFrameCategories, ft=ftype, kfs=true}
	InterfaceOptionsFrameAddOnsList:SetBackdrop(nil)
	self:skinSlider(InterfaceOptionsFrameAddOnsListScrollBar)
	self:addSkinFrame{obj=InterfaceOptionsFrameAddOns, ft=ftype, kfs=true}
	self:addSkinFrame{obj=InterfaceOptionsFramePanelContainer, ft=ftype}

	-- Tabs
	for i = 1, 2 do
		local tabName = _G["InterfaceOptionsFrameTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		self:addSkinFrame{obj=tabName, ft=ftype, noBdr=self.isTT, x1=6, x2=-6, y2=-4}
		local tabSF = self.skinFrame[tabName]
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end

	-- Hook this to skin any Interface Option panels
	self:SecureHook("InterfaceOptionsList_DisplayPanel", function(panel)
		-- skin tekKonfig library objects
		if self.tekKonfig then self:tekKonfig() end
		if panel and panel.GetNumChildren and not self.skinFrame[panel] then
			for i = 1, panel:GetNumChildren() do
				local child = select(i, panel:GetChildren())
				if child then
				 	if self:isDropDown(child) then self:skinDropDown{obj=child}
					elseif child:IsObjectType("EditBox") then self:skinEditBox{obj=child, regs={9}}
					end
				end
			end
			self:addSkinFrame{obj=panel, ft=ftype, kfs=true}
		end
	end)

end

function Skinner:MacroUI()
	if not self.db.profile.MenuFrames or self.initialized.MacroUI then return end
	self.initialized.MacroUI = true

-->>-- Macro Frame
	self:skinFFToggleTabs("MacroFrameTab", 2)
	self:skinScrollBar{obj=MacroButtonScrollFrame}
	self:moveObject{obj=MacroFrameCharLimitText, y=-2}
	self:skinScrollBar{obj=MacroFrameScrollFrame}
	self:skinEditBox{obj=MacroFrameText, noSkin=true}
	self:addSkinFrame{obj=MacroFrameTextBackground, ft=ftype}
	self:addSkinFrame{obj=MacroFrame, ft=ftype, kfs=true, hdr=true, x1=10, y1=-11, x2=-32, y2=71}

-->>-- Macro Popup Frame
	self:skinEditBox{obj=MacroPopupEditBox}
	self:skinScrollBar{obj=MacroPopupScrollFrame}
	self:addSkinFrame{obj=MacroPopupFrame, ft=ftype, kfs=true, x1=8, y1=-8, x2=-2, y2=4}

end

function Skinner:BindingUI()
	if not self.db.profile.MenuFrames or self.initialized.BindingUI then return end
	self.initialized.BindingUI = true

	self:skinScrollBar{obj=KeyBindingFrameScrollFrame}
	self:addSkinFrame{obj=KeyBindingFrame, ft=ftype, kfs=true, hdr=true, x2=-42, y2=10}

end

function Skinner:BankFrame()
	if not self.db.profile.BankFrame or self.initialized.BankFrame then return end
	self.initialized.BankFrame = true

	self:addSkinFrame{obj=BankFrame, ft=ftype, kfs=true, x1=10, y1=-11, x2=-25, y2=91}

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

	self:addSkinFrame{obj=MailFrame, ft=ftype, kfs=true, x1=16, y1=-12, x2=-32, y2=69}

-->>--	Inbox Frame
	for i = 1, 7 do
		self:keepFontStrings(_G["MailItem"..i])
	end

-->>--	Send Mail Frame
	self:keepFontStrings(SendMailFrame)
	self:skinScrollBar{obj=SendMailScrollFrame}
	self:SecureHook("SendMailFrame_Update", function()
		for i = 1, ATTACHMENTS_MAX_SEND do
			local sma = _G["SendMailAttachment"..i]
			if not self.sBut[sma] then
				self:addSkinButton{obj=sma, hide=true, kfs=true}
			end
		end
	end)

	self:skinEditBox{obj=SendMailNameEditBox, regs={6}, noWidth=true} -- N.B. region 6 is text
	self:skinEditBox{obj=SendMailSubjectEditBox, regs={6}, noWidth=true} -- N.B. region 6 is text
	self:skinEditBox{obj=SendMailBodyEditBox, noSkin=true}
	local c = self.db.profile.BodyText
	SendMailBodyEditBox:SetTextColor(c.r, c.g, c.b)
	self:skinMoneyFrame{obj=SendMailMoney, moveSEB=true, moveGEB=true, noWidth=true}

-->>--	Open Mail Frame
	self:skinScrollBar{obj=OpenMailScrollFrame}
	OpenMailBodyText:SetTextColor(self.BTr, self.BTg, self.BTb)
	for i = 1, ATTACHMENTS_MAX_RECEIVE do
		local rma = _G["OpenMailAttachmentButton"..i]
		self:addSkinButton{obj=rma, hide=true}
	end
	self:addSkinFrame{obj=OpenMailFrame, ft=ftype, kfs=true, x1=12, y1=-12, x2=-34, y2=70}

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
		self:addSkinFrame{obj=tabName, ft=ftype, noBdr=self.isTT, x1=6, x2=-6, y2=2}
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

	self:addSkinFrame{obj=AuctionFrame, ft=ftype, kfs=true, hdr=true, x1=10, y1=-11, y2=4}

-->>--	Browse Frame
	for k, v in pairs{"Name", "MinLevel", "MaxLevel"} do
		local obj = _G["Browse"..v]
		self:skinEditBox{obj=obj, regs={9}}
	end
	self:skinDropDown{obj=BrowseDropDown}
	for _, v in pairs{"Quality", "Level", "Duration", "HighBidder", "CurrentBid"} do
		local obj = _G["Browse"..v.."Sort"]
		self:keepRegions(obj, {4, 5, 6}) -- N.B. region 4 is the text, 5 is the arrow, 6 is the highlight
		self:addSkinFrame{obj=obj, ft=ftype}
	end
	self:skinScrollBar{obj=BrowseFilterScrollFrame}
	for i = 1, NUM_FILTERS_TO_DISPLAY do
		self:keepRegions(_G["AuctionFilterButton"..i], {3, 4}) -- N.B. region 3 is the highlight, 4 is the text
		self:addSkinFrame{obj=_G["AuctionFilterButton"..i], ft=ftype}
	end
	self:skinScrollBar{obj=BrowseScrollFrame}
	self:skinMoneyFrame{obj=BrowseBidPrice, moveSEB=true}

-->>--	Bid Frame
	self:skinScrollBar{obj=BidScrollFrame}
	for _, v in pairs{"Quality", "Level", "Duration", "Buyout", "Status", "Bid"} do
		local obj = _G["Bid"..v.."Sort"]
		self:keepRegions(obj, {4, 5, 6}) -- N.B. region 4 is the text, 5 is the arrow, 6 is the highlight
		self:addSkinFrame{obj=obj, ft=ftype}
	end
	self:skinMoneyFrame{obj=BidBidPrice, moveSEB=true}

-->>--	Auctions Frame
	self:addSkinFrame{obj=AuctionsItemButton, ft=ftype}
	self:skinScrollBar{obj=AuctionsScrollFrame}
	for _, v in pairs{"Quality", "Duration", "HighBidder", "Bid"} do
		local obj = _G["Auctions"..v.."Sort"]
		self:keepRegions(obj, {4, 5, 6}) -- N.B. region 4 is the text, 5 is the arrow, 6 is the highlight
		self:addSkinFrame{obj=obj, ft=ftype}
	end
	self:skinMoneyFrame{obj=StartPrice, moveSEB=true}
	self:skinMoneyFrame{obj=BuyoutPrice, moveSEB=true}

-->>--	Auction DressUp Frame
	self:keepRegions(AuctionDressUpFrame, {3, 4}) --N.B. regions 3 & 4 are the background
	self:keepRegions(AuctionDressUpFrameCloseButton, {1}) -- N.B. region 1 is the button artwork
	AuctionDressUpModelRotateLeftButton:Hide()
	AuctionDressUpModelRotateRightButton:Hide()
	self:makeMFRotatable(AuctionDressUpModel)
	self:moveObject{obj=AuctionDressUpFrame, x=6}
	self:addSkinFrame{obj=AuctionDressUpFrame, ft=ftype, x1=-6, y1=-3, x2=-2}
-->>--	Tabs
	for i = 1, AuctionFrame.numTabs do
		local tabName = _G["AuctionFrameTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		self:addSkinFrame{obj=tabName, ft=ftype, noBdr=self.isTT, x1=6, x2=-6, y2=2}
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
 		ExhaustionLevelFillBar:SetTexture(self.sbTexture)
	end

	if IsAddOnLoaded("Dominos") then return end

-->>-- Main Menu Bar
	self:keepFontStrings(MainMenuBarMaxLevelBar)
	self:keepFontStrings(MainMenuBarArtFrame)
	ExhaustionTick:SetAlpha(0)
	MainMenuExpBar:SetHeight(MainMenuExpBar:GetHeight() - 2) -- shrink it so it moves up
	ExhaustionLevelFillBar:SetHeight(MainMenuExpBar:GetHeight()) -- mirror the XP bar
	self:addSkinFrame{obj=MainMenuBar, ft=ftype, kfs=true, noBdr=true, x1=-4, y1=-7, x2=4, y2=-4}

	-- Experience Bar
	self:keepRegions(MainMenuExpBar, {1, 7}) -- N.B. region 1 is rested XP, 7 is the normal XP
	-- Reputation Bar
	self:keepRegions(ReputationWatchStatusBar, {10}) -- 10 is the normal texture

	local function toggleActionButtons()

		local babf = BonusActionBarFrame
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

-->>-- Bonus Action Bar Frame
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
-->>-- Shapeshift Bar Frame
	self:keepFontStrings(ShapeshiftBarFrame)
	-- skin shapeshift buttons
	for i = 1, NUM_SHAPESHIFT_SLOTS do
		local ssBtn = _G["ShapeshiftButton"..i]
		self:removeRegions(ssBtn, {6, 7, 8})
		self:addSkinButton{obj=ssBtn, parent=ssBtn}
	end

-->>-- Possess Bar Frame
	self:keepFontStrings(PossessBarFrame)

-->>-- Pet Action Bar Frame
	self:keepFontStrings(PetActionBarFrame)

-->>-- Shaman's Totem Frame
	self:addSkinFrame{obj=MultiCastFlyoutFrame, kfs=true, ft=ftype, y1=-4, y2=-4}

end

function Skinner:CoinPickup()
	if not self.db.profile.CoinPickup or self.initialized.CoinPickup then return end
	self.initialized.CoinPickup = true

	self:addSkinFrame{obj=CoinPickupFrame, ft=ftype, kfs=true, x1=9, y1=-12, x2=-6, y2=12}

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

	self:addSkinFrame{obj=LFGParentFrame, ft=ftype, kfs=true, x1=17, y1=-11, x2=-29, y2=70}

-->>--	LFG Frame
	self:keepFontStrings(AutoJoinBackground)
	self:skinDropDown{obj=LFGFrameNameDropDown1}
	self:skinDropDown{obj=LFGFrameNameDropDown2}
	self:skinDropDown{obj=LFGFrameNameDropDown3}
	self:skinDropDown{obj=LFGFrameTypeDropDown1}
	self:skinDropDown{obj=LFGFrameTypeDropDown2}
	self:skinDropDown{obj=LFGFrameTypeDropDown3}
	self:addSkinFrame{obj=LFGEye, ft=ftype, kfs=true}

-->>--	LFM Frame
	self:keepRegions(LFMFrame, {2}) -- totals text
	self:keepFontStrings(AddMemberBackground)
	self:skinDropDown{obj=LFMFrameTypeDropDown}
	self:skinDropDown{obj=LFMFrameNameDropDown}
	self:keepFontStrings(LFMFrameDropDown1)
	self:skinFFColHeads("LFMFrameColumnHeader", 3) -- first 3
	self:keepRegions(LFMFrameColumnHeader4Group, {4, 5}) -- N.B 4 is text, 5 is highlight
	self:addSkinFrame{obj=LFMFrameColumnHeader4Group, ft=ftype}

	for i = 4, 7 do
		self:keepRegions(_G["LFMFrameColumnHeader"..i], {4, 5, 6}) -- N.B 4 is text, 5 is highlight, 6 is icon
		self:addSkinFrame{obj=_G["LFMFrameColumnHeader"..i], ft=ftype}
	end

	LFMFrameRoleBackground:Hide()
	self:skinScrollBar{obj=LFMListScrollFrame}
	self:addSkinFrame{obj=LFMEye, ft=ftype, kfs=true}

-->>--	Tabs
	for i = 1, 2 do
		local tabName = _G["LFGParentFrameTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		self:addSkinFrame{obj=tabName, ft=ftype, noBdr=self.isTT, x1=6, x2=-6, y2=2}
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

	self:addSkinFrame{obj=ItemSocketingFrame, ft=ftype, kfs=true, x1=10, y1=-12, x2=-4, y2=26}

	self:skinScrollBar{obj=ItemSocketingScrollFrame}

	for i = 1, MAX_NUM_SOCKETS do
		local isB = _G["ItemSocketingSocket"..i]
		_G["ItemSocketingSocket"..i.."Left"]:SetAlpha(0)
		_G["ItemSocketingSocket"..i.."Right"]:SetAlpha(0)
		self:getRegion(isB, 3):SetAlpha(0) -- button texture
		self:addSkinButton{obj=isB}
	end
	-- now colour the sockets
	colourSockets()

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
	self:addSkinFrame{obj=GuildBankFrame, ft=ftype, kfs=true, hdr=true, y1=-11, y2=1}

-->>--	Log Frame
	self:skinScrollBar{obj=GuildBankTransactionsScrollFrame}

-->>--	Info Frame
	self:skinScrollBar{obj=GuildBankInfoScrollFrame}

-->>--	GuildBank Popup Frame
	self:skinEditBox{obj=GuildBankPopupEditBox, regs={9}}
	self:skinScrollBar{obj=GuildBankPopupScrollFrame}
	self:addSkinFrame{obj=GuildBankPopupFrame, ft=ftype, kfs=true, hdr=true, x1=2, y1=-12, x2=-24, y2=24}

-->>--	GuildBank Tabs (side)
	for i = 1, MAX_GUILDBANK_TABS do
		local tabName = _G["GuildBankTab"..i]
		self:keepRegions(tabName, {7, 8})
	end

-->>--	GuildBank Frame Tabs (bottom)
	for i = 1, 4 do
		local tabName = _G["GuildBankFrameTab"..i]
		self:keepFontStrings(tabName)
		self:addSkinFrame{obj=tabName, ft=ftype, noBdr=self.isTT, x1=6, x2=-6, y2=2}
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

	local npTex = [[Interface\Tooltips\Nameplate-Border]]
	local shldTex = [[Interface\AchievementFrame\UI-Achievement-Progressive-Shield]]
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
--				 child 1 is the flash texture
				select(2, child:GetRegions()):SetAlpha(0) -- hide border texture
				select(3, child:GetRegions()):SetAlpha(0) -- hide border texture
				-- child 4 is the shield icon, replace texture with Achievement's Shield texture
				local shldReg = select(4, child:GetRegions())
				shldReg:SetHeight(30)
				shldReg:SetWidth(30)
				shldReg:SetTexture(shldTex)
				shldReg:SetTexCoord(0, 0.75, 0, 0.75)
				-- child 5 is the spell icon
				select(6, child:GetRegions()):SetAlpha(0) -- hide glow effect
				-- children 7 & 8 are text, 9 & 10 are raid icons, 11 is the elite icon
				for i = 1, 2 do -- skin both status bars
					local sb = select(i, child:GetChildren())
					if not Skinner.sbGlazed[sb] then
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
			npEvt = Skinner:ScheduleRepeatingTimer(skinNameplates, 0.1)
		end

	end

	self:SecureHook("SetCVar", function(varName, varValue, ...)
		if varName:find("nameplateShow") and varValue == 1 then showFunc() end
	end)

	local SHOW_ENEMIES = GetCVarBool("nameplateShowEnemies")
	local SHOW_FRIENDS = GetCVarBool("nameplateShowFriends")
	if SHOW_ENEMIES or SHOW_FRIENDS then showFunc() end

end

function Skinner:GMChatUI()
	if not self.db.profile.GMChatUI or self.initialized.GMChatUI then return end
	self.initialized.GMChatUI = true

-->>-- GM Chat Request frame
	self:addSkinFrame{obj=self:getChild(GMChatStatusFrame, 2), ft=ftype}

-->>-- GMChat Frame
	if self.db.profile.ChatFrames then
		self:addSkinFrame{obj=GMChatFrame, ft=ftype, x1=-4, y1=4, x2=4, y2=-8}
	end

-->>-- GMChat Frame Tab
	self:addSkinFrame{obj=GMChatTab, ft=ftype, kfs=true, noBdr=self.isTT, y2=-4}

end

function Skinner:AutoComplete()

	self:addSkinFrame{obj=AutoCompleteBox, kfs=true, ft=ftype}--, x1=10, y1=-12, x2=-32, y2=71}

end

function Skinner:DebugTools()
	if not self.db.profile.DebugTools or self.initialized.DebugTools then return end
	self.initialized.DebugTools = true

	self:addSkinFrame{obj=EventTraceFrame, kfs=true, ft=ftype, x1=1, y1=-2, x2=-1, y2=4}
	self:skinSlider{obj=EventTraceFrameScroll, size=3}
	self:addSkinFrame{obj=ScriptErrorsFrame, kfs=true, ft=ftype, x1=1, y1=-2, x2=-1, y2=4}
	self:skinScrollBar{obj=ScriptErrorsFrameScrollFrame}

	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then
			FrameStackTooltip:SetBackdrop(self.Backdrop[1])
			EventTraceTooltip:SetBackdrop(self.Backdrop[1])
		end
		self:SecureHook(FrameStackTooltip, "Show", function()
			self:skinTooltip(FrameStackTooltip)
		end)
		self:SecureHook(EventTraceTooltip, "Show", function()
			self:skinTooltip(EventTraceTooltip)
		end)
	end

end
