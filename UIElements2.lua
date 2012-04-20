local aName, aObj = ...
local _G = _G
local ftype = "u"
local obj, objName, tex, texName, btn, btnName, tab, tabSF, asopts

function aObj:ModelFrames()
	if not self.db.profile.CharacterFrames then return end
--[[
[12:55:21] <dreyruugr> http://ace.pastey.net/551
[12:55:42] <dreyruugr> That should do framerate independant rotation of the model, based on how much the mouse moves
[13:12:43] <dreyruugr> Gngsk: http://ace.pastey.net/552 - This doesn't work quite right, but if you work on it you'll be able to zoom in on the character's face using the y offset of the mouse

This does the trick, but it might be worth stealing chester's code from SuperInspect

]]
	self:add2Table(self.uiKeys1, "ModelFrames")

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

if IsMacClient() then
	function aObj:MovieProgress()
		if not self.db.profile.MovieProgress or self.initialized.MovieProgress then return end
		self.initialized.MovieProgress = true

		self:add2Table(self.uiKeys1, "MovieProgress")

		self:getChild(MovieProgressBar, 1):SetBackdrop(nil)
		self:removeRegions(MovieProgressFrame)
		self:glazeStatusBar(MovieProgressBar, 0, self:getRegion(MovieProgressBar, 1))
		self:addSkinFrame{obj=MovieProgressFrame, ft=ftype, x1=-6, y1=6, x2=6, y2=-6}

	end
end

function aObj:TimeManager() -- LoD
	if not self.db.profile.TimeManager or self.initialized.TimeManager then return end
	self.initialized.TimeManager = true

-->>--	Time Manager Frame
	TimeManagerFrameTicker:Hide()
	self:keepFontStrings(TimeManagerStopwatchFrame)
	self:addButtonBorder{obj=TimeManagerStopwatchCheck}
	self:skinDropDown{obj=TimeManagerAlarmHourDropDown, x2=-5}
	self:skinDropDown{obj=TimeManagerAlarmMinuteDropDown, x2=-5}
	self:skinDropDown{obj=TimeManagerAlarmAMPMDropDown, x2=-5}
	self:skinEditBox{obj=TimeManagerAlarmMessageEditBox, regs={9}}
	self:addSkinFrame{obj=TimeManagerFrame, ft=ftype, kfs=true, x1=14, y1=-11, x2=-49, y2=9}

-->>--	Time Manager Clock Button
	self:removeRegions(TimeManagerClockButton, {1})
	if not self.db.profile.Minimap.style then
		self:addSkinFrame{obj=TimeManagerClockButton, ft=ftype, x1=10, y1=-3, x2=-5, y2=5}
	end

-->>--	Stopwatch Frame
	self:keepFontStrings(StopwatchTabFrame)
	self:skinButton{obj=StopwatchCloseButton, cb=true, sap=true}
	self:addSkinFrame{obj=StopwatchFrame, ft=ftype, kfs=true, y1=-16, y2=2, nb=true}

end

function aObj:Calendar() -- LoD
	if not self.db.profile.Calendar or self.initialized.Calendar then return end
	self.initialized.Calendar = true

-->>--	Calendar Frame
	self:keepFontStrings(CalendarFilterFrame)
	-- move close button
	self:moveObject{obj=CalendarCloseButton, y=14}
	self:adjHeight{obj=CalendarCloseButton, adj=-2}
	self:addSkinFrame{obj=CalendarFrame, ft=ftype, kfs=true, x1=1, y1=-2, x2=2, y2=-7}

-->>-- View Holiday Frame
	self:keepFontStrings(CalendarViewHolidayTitleFrame)
	self:moveObject{obj=CalendarViewHolidayTitleFrame, y=-6}
	self:removeRegions(CalendarViewHolidayCloseButton, {5})
	self:skinScrollBar{obj=CalendarViewHolidayScrollFrame}
	self:addSkinFrame{obj=CalendarViewHolidayFrame, ft=ftype, kfs=true, x1=2, y1=-3, x2=-3, y2=-2}

-->>-- View Raid Frame
	self:keepFontStrings(CalendarViewRaidTitleFrame)
	self:moveObject{obj=CalendarViewRaidTitleFrame, y=-6}
	self:removeRegions(CalendarViewRaidCloseButton, {5})
	self:skinScrollBar{obj=CalendarViewRaidScrollFrame}
	self:addSkinFrame{obj=CalendarViewRaidFrame, ft=ftype, kfs=true, x1=2, y1=-3, x2=-3, y2=2}

-->>-- View Event Frame
	self:keepFontStrings(CalendarViewEventTitleFrame)
	self:moveObject{obj=CalendarViewEventTitleFrame, y=-6}
	self:removeRegions(CalendarViewEventCloseButton, {5})
	self:addSkinFrame{obj=CalendarViewEventDescriptionContainer, ft=ftype}
	self:skinScrollBar{obj=CalendarViewEventDescriptionScrollFrame}
	self:keepFontStrings(CalendarViewEventInviteListSection)
	self:addSkinFrame{obj=CalendarViewEventInviteList, ft=ftype}
	self:addSkinFrame{obj=CalendarViewEventFrame, ft=ftype, kfs=true, x1=2, y1=-3, x2=-3, y2=2}

-->>-- Create Event Frame
	CalendarCreateEventIcon:SetAlpha(1) -- show event icon
	self:keepFontStrings(CalendarCreateEventTitleFrame)
	self:moveObject{obj=CalendarCreateEventTitleFrame, y=-6}
	self:removeRegions(CalendarCreateEventCloseButton, {5})
	self:skinEditBox{obj=CalendarCreateEventTitleEdit, regs={9}}
	self:skinDropDown{obj=CalendarCreateEventTypeDropDown}
	self:skinDropDown{obj=CalendarCreateEventHourDropDown, x2=-5}
	self:skinDropDown{obj=CalendarCreateEventMinuteDropDown, x2=-5}
	self:skinDropDown{obj=CalendarCreateEventAMPMDropDown, x2=-5}
	self:skinDropDown{obj=CalendarCreateEventRepeatOptionDropDown}
	self:addSkinFrame{obj=CalendarCreateEventDescriptionContainer, ft=ftype}
	self:skinScrollBar{obj=CalendarCreateEventDescriptionScrollFrame}
	self:keepFontStrings(CalendarCreateEventInviteListSection)
	self:addSkinFrame{obj=CalendarCreateEventInviteList, ft=ftype}
	self:skinEditBox{obj=CalendarCreateEventInviteEdit, regs={9}}
	CalendarCreateEventMassInviteButtonBorder:SetAlpha(0)
	CalendarCreateEventRaidInviteButtonBorder:SetAlpha(0)
	CalendarCreateEventCreateButtonBorder:SetAlpha(0)
	self:addSkinFrame{obj=CalendarCreateEventFrame, ft=ftype, kfs=true, x1=2, y1=-3, x2=-3, y2=2}

-->>-- Mass Invite Frame
	self:keepFontStrings(CalendarMassInviteTitleFrame)
	self:moveObject{obj=CalendarMassInviteTitleFrame, y=-6}
	self:removeRegions(CalendarMassInviteCloseButton, {5})
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
	self:skinButton{obj=CalendarTexturePickerCancelButton}
	CalendarTexturePickerAcceptButtonBorder:SetAlpha(0)
	self:addSkinFrame{obj=CalendarTexturePickerFrame, ft=ftype, kfs=true, x1=5, y1=-3, x2=-3, y2=2}

-->>-- Class Button Container
	for i = 1, MAX_CLASSES do -- allow for the total button
		btn = _G["CalendarClassButton"..i]
		self:removeRegions(btn, {1})
		self:addButtonBorder{obj=btn}
	end
	-- Class Totals button, texture & size changes
	self:moveObject{obj=CalendarClassTotalsButton, x=-2}
	CalendarClassTotalsButton:SetWidth(25)
	CalendarClassTotalsButton:SetHeight(25)
	self:applySkin{obj=CalendarClassTotalsButton, ft=ftype, kfs=true, bba=self.modBtnBs and 1 or 0}

-->>-- ContextMenus
	self:addSkinFrame{obj=CalendarContextMenu}
	self:addSkinFrame{obj=CalendarArenaTeamContextMenu}
	self:addSkinFrame{obj=CalendarInviteStatusContextMenu}

end

function aObj:MenuFrames()
	if not self.db.profile.MenuFrames or self.initialized.MenuFrames then return end
	self.initialized.MenuFrames = true

	self:add2Table(self.uiKeys1, "MenuFrames")

-->>-- Game Menu Frame
	self:addSkinFrame{obj=GameMenuFrame, ft=ftype, kfs=true, hdr=true}

-->>-- Options
	self:addSkinFrame{obj=VideoOptionsFrame, ft=ftype, kfs=true, hdr=true}
	self:addSkinFrame{obj=VideoOptionsFrameCategoryFrame, ft=ftype, kfs=true}
	self:skinSlider(VideoOptionsFrameCategoryFrameListScrollBar)
	self:addSkinFrame{obj=VideoOptionsFramePanelContainer, ft=ftype}
	-- Graphics
	for _, child in ipairs{Graphics_:GetChildren()} do
		if child:GetName():find("DropDown") then
			self:skinDropDown{obj=child}
		end
	end
	-- Advanced
	for _, child in ipairs{Advanced_:GetChildren()} do
		if child:GetName():find("DropDown") then
			self:skinDropDown{obj=child}
		end
	end
	-- Languages
		self:skinDropDown{obj=InterfaceOptionsLanguagesPanelLocaleDropDown}
	-- Sound
	self:addSkinFrame{obj=AudioOptionsSoundPanel, ft=ftype}
	self:addSkinFrame{obj=AudioOptionsSoundPanelPlayback, ft=ftype}
	self:skinDropDown{obj=AudioOptionsSoundPanelHardwareDropDown}
	self:skinDropDown{obj=AudioOptionsSoundPanelSoundChannelsDropDown}
	self:addSkinFrame{obj=AudioOptionsSoundPanelHardware, ft=ftype}
	self:addSkinFrame{obj=AudioOptionsSoundPanelVolume, ft=ftype}
	-- Voice
	self:addSkinFrame{obj=AudioOptionsVoicePanel, ft=ftype}
	self:addSkinFrame{obj=AudioOptionsVoicePanelTalking, ft=ftype}
	self:skinDropDown{obj=AudioOptionsVoicePanelInputDeviceDropDown}
	self:skinButton{obj=RecordLoopbackSoundButton, x1=-2, x2=2}
	self:skinButton{obj=PlayLoopbackSoundButton, x1=-2, x2=2}
	self:addSkinFrame{obj=LoopbackVUMeter:GetParent(), ft=ftype, aso={ng=true}, nb=true}
	self:glazeStatusBar(LoopbackVUMeter) -- no background required
	self:addSkinFrame{obj=AudioOptionsVoicePanelBinding, ft=ftype}
	self:skinDropDown{obj=AudioOptionsVoicePanelChatModeDropDown}
	self:addSkinFrame{obj=AudioOptionsVoicePanelListening, ft=ftype}
	self:skinDropDown{obj=AudioOptionsVoicePanelOutputDeviceDropDown}
	self:addSkinFrame{obj=VoiceChatTalkers, ft=ftype}

-->>-- Mac Options
	if IsMacClient() then
		self:addSkinFrame{obj=MacOptionsFrame, ft=ftype, kfs=true, hdr=true}
		self:addSkinFrame{obj=MacOptionsFrameMovieRecording, ft=ftype, y1=-2}
		self:skinDropDown{obj=MacOptionsFrameResolutionDropDown}
		self:skinDropDown{obj=MacOptionsFrameFramerateDropDown}
		self:skinDropDown{obj=MacOptionsFrameCodecDropDown}
		-- popup frames
		self:addSkinFrame{obj=MacOptionsITunesRemote, ft=ftype, y1=-2}
		self:addSkinFrame{obj=MacOptionsCompressFrame, ft=ftype, kfs=true, hdr=true}
		self:addSkinFrame{obj=MacOptionsCancelFrame, ft=ftype, kfs=true, hdr=true}
		self:addSkinFrame{obj=FolderPicker, ft=ftype, kfs=true, hdr=true}
	end

-->>-- Interface
	self:skinTabs{obj=InterfaceOptionsFrame, up=true, lod=true, x1=6, y1=2, x2=-6, y2=-4}
	self:addSkinFrame{obj=InterfaceOptionsFrame, ft=ftype, kfs=true, hdr=true}
	InterfaceOptionsFrameCategoriesList:SetBackdrop(nil)
	self:skinScrollBar{obj=InterfaceOptionsFrameCategoriesList, size=2}
	self:addSkinFrame{obj=InterfaceOptionsFrameCategories, ft=ftype, kfs=true}
	InterfaceOptionsFrameAddOnsList:SetBackdrop(nil)
	self:skinScrollBar{obj=InterfaceOptionsFrameAddOnsList, size=2}
	self:addSkinFrame{obj=InterfaceOptionsFrameAddOns, ft=ftype, kfs=true}
	self:addSkinFrame{obj=InterfaceOptionsFramePanelContainer, ft=ftype}
	-- skin toggle buttons
	for i = 1, #InterfaceOptionsFrameAddOns.buttons do
		self:skinButton{obj=InterfaceOptionsFrameAddOns.buttons[i].toggle, mp2=true}
	end

-->>-- Rating Menu
	self:addSkinFrame{obj=RatingMenuFrame, ft=ftype, hdr=true}

	local oName
	local function checkKids(obj)

		oName = obj.GetName and obj:GetName() or nil
		  -- ignore named/AceConfig/XConfig/AceGUI objects
		if oName
		and (oName:find("AceConfig")
		or oName:find("XConfig")
		or oName:find("AceGUI"))
		then
			return
		end

		for _, child in ipairs{obj:GetChildren()} do
			-- aObj:Debug("checkKids: [%s, %s, %s]", child:GetName(), child:GetObjectType(), child:GetNumRegions())
			if not self.skinFrame[child] then
				if aObj:isDropDown(child) then
					aObj:skinDropDown{obj=child}
				elseif child:IsObjectType("EditBox") then
					aObj:skinEditBox{obj=child, regs={9}}
				elseif child:IsObjectType("ScrollFrame")
				and child:GetName()
				and child:GetName().."ScrollBar" -- handle unnamed ScrollBar's
				then
					aObj:skinScrollBar{obj=child}
				else
					checkKids(child)
				end
				-- remove Ampere's container background
				if child:GetParent().name
				and child:GetParent().name == "Ampere"
				and child:GetNumRegions() == 1
				then
					child:DisableDrawLayer("BACKGROUND")
				end
			end
		end

	end
	-- hook this to skin Interface Option panels and their elements
	self:SecureHook("InterfaceOptionsList_DisplayPanel", function(panel)
		-- skin tekKonfig library objects here as well as in AddonFrames to handle late loading of libraries
		if self.tekKonfig then self:checkAndRun("tekKonfig") end
		-- run Addon Loader skin code here
		if panel.name == "Addon Loader"
		and self.AddonLoader
		then
			self:checkAndRun("AddonLoader")
		end
		-- self:Debug("IOL_DP: [%s, %s, %s, %s]", panel, panel.name, panel:GetNumChildren(), self.skinFrame[panel])
		if panel
		and panel.GetNumChildren
		and not self.skinFrame[panel]
		then
			self:addSkinFrame{obj=panel, ft=ftype, kfs=true, nb=true}
			self:ScheduleTimer(checkKids, 0.1, panel) -- wait for 1/10th second for panel to be populated
			self:ScheduleTimer("skinAllButtons", 0.1, {obj=panel, as=true}) -- wait for 1/10th second for panel to be populated, always use applySkin to ensure text appears above button texture
		end
	end)

end

function aObj:BindingUI() -- LoD
	if not self.db.profile.MenuFrames or self.initialized.BindingUI then return end
	self.initialized.BindingUI = true

	self:skinScrollBar{obj=KeyBindingFrameScrollFrame}
	self:addSkinFrame{obj=KeyBindingFrame, ft=ftype, kfs=true, hdr=true, x2=-42, y2=10}

end

function aObj:MacroUI() -- LoD
	if not self.db.profile.MenuFrames or self.initialized.MacroUI then return end
	self.initialized.MacroUI = true

-->>-- Macro Frame
	self:skinScrollBar{obj=MacroButtonScrollFrame}
	self:skinScrollBar{obj=MacroFrameScrollFrame}
	self:skinEditBox{obj=MacroFrameText, noSkin=true}
	self:addSkinFrame{obj=MacroFrameTextBackground, ft=ftype, y2=2}
	self:skinTabs{obj=MacroFrame, up=true, lod=true, x1=-3, y1=-3, x2=3, y2=-3, hx=-2, hy=3}
	self:addSkinFrame{obj=MacroFrame, ft=ftype, kfs=true, hdr=true, x1=10, y1=-11, x2=-32, y2=71}
	if self.modBtnBs then
		-- add button borders
		btnName = "MacroFrameSelectedMacroButton"
		_G[btnName]:DisableDrawLayer("BACKGROUND")
		self:addButtonBorder{obj=_G[btnName], relTo=_G[btnName.."Icon"]}
		for i = 1, MAX_ACCOUNT_MACROS do
			btnName = "MacroButton"..i
			_G[btnName]:DisableDrawLayer("BACKGROUND")
			self:addButtonBorder{obj=_G[btnName], relTo=_G[btnName.."Icon"], spbt=true}
		end
	end

-->>-- Macro Popup Frame
	self:skinEditBox{obj=MacroPopupEditBox}
	self:skinScrollBar{obj=MacroPopupScrollFrame}
	self:addSkinFrame{obj=MacroPopupFrame, ft=ftype, kfs=true, x1=8, y1=-8, x2=-2, y2=4}
	-- add button borders
	for i = 1, NUM_MACRO_ICONS_SHOWN do
		btnName = "MacroPopupButton"..i
		_G[btnName]:DisableDrawLayer("BACKGROUND")
		self:addButtonBorder{obj=_G[btnName], relTo=_G[btnName.."Icon"], spbt=true}
	end

end

function aObj:MailFrame()
	if not self.db.profile.MailFrame or self.initialized.MailFrame then return end
	self.initialized.MailFrame = true

	self:add2Table(self.uiKeys1, "MailFrame")

	self:skinTabs{obj=MailFrame}
	self:addSkinFrame{obj=MailFrame, ft=ftype, kfs=true, x1=16, y1=-12, x2=-32, y2=69}

-->>--	Inbox Frame
	for i = 1, INBOXITEMS_TO_DISPLAY do
		self:keepFontStrings(_G["MailItem"..i])
		btn = _G["MailItem"..i.."Button"]
		if self.modBtnBs then
			btn:DisableDrawLayer("BACKGROUND")
			self:addButtonBorder{obj=btn}
		end
	end
	self:moveObject{obj=InboxTooMuchMail, y=-24} -- move icon down
	self:skinButton{obj=InboxCloseButton, cb=true}

-->>--	Send Mail Frame
	self:keepFontStrings(SendMailFrame)
	self:skinScrollBar{obj=SendMailScrollFrame}
	for i = 1, ATTACHMENTS_MAX_SEND do
		btn = _G["SendMailAttachment"..i]
		if not self.modBtnBs then
			self:resizeEmptyTexture(self:getRegion(btn, 1))
		else
			btn:DisableDrawLayer("BACKGROUND")
			self:addButtonBorder{obj=btn}
		end
	end
	self:skinEditBox{obj=SendMailNameEditBox, regs={6}, noWidth=true} -- N.B. region 6 is text
	self:skinEditBox{obj=SendMailSubjectEditBox, regs={6}, noWidth=true} -- N.B. region 6 is text
	self:skinEditBox{obj=SendMailBodyEditBox, noSkin=true}
	local c = self.db.profile.BodyText
	SendMailBodyEditBox:SetTextColor(c.r, c.g, c.b)
	self:skinMoneyFrame{obj=SendMailMoney, moveSEB=true, moveGEB=true, noWidth=true}

-->>--	Open Mail Frame
	self:skinScrollBar{obj=OpenMailScrollFrame}
	OpenMailBodyText:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:addSkinFrame{obj=OpenMailFrame, ft=ftype, kfs=true, x1=12, y1=-12, x2=-34, y2=70}
	self:addButtonBorder{obj=OpenMailLetterButton, ibt=true}
	self:addButtonBorder{obj=OpenMailMoneyButton, ibt=true}
	for i = 1, ATTACHMENTS_MAX_RECEIVE do
		btn = _G["OpenMailAttachmentButton"..i]
		self:addButtonBorder{obj=btn, ibt=true}
	end
-->>-- Invoice Frame Text fields
	for _, v in pairs{"ItemLabel", "Purchaser", "BuyMode", "SalePrice", "Deposit", "HouseCut", "AmountReceived", "NotYetSent", "MoneyDelay"} do
		_G["OpenMailInvoice"..v]:SetTextColor(self.BTr, self.BTg, self.BTb)
	end

end

function aObj:MainMenuBar()
	if not self.db.profile.MainMenuBar.skin or self.initialized.MainMenuBar then return end
	self.initialized.MainMenuBar = true

	self:add2Table(self.uiKeys2, "MainMenuBar")

	if self.db.profile.MainMenuBar.glazesb then
		self:glazeStatusBar(MainMenuExpBar, 0, self:getRegion(MainMenuExpBar, 5), {ExhaustionLevelFillBar})
		ExhaustionLevelFillBar:SetAlpha(0.75) -- increase alpha value to make it more visible
		self:glazeStatusBar(ReputationWatchStatusBar, 0, ReputationWatchStatusBarBackground)
	end

	if IsAddOnLoaded("Dominos") then return end

	ExhaustionTick:SetAlpha(0)
	self:adjHeight{obj=MainMenuExpBar, adj=-2} -- shrink it so it moves up
	self:adjHeight{obj=ExhaustionLevelFillBar, adj=-1} -- mirror the XP bar
	local yOfs = IsAddOnLoaded("DragonCore") and -47 or -4
	self:keepRegions(MainMenuExpBar, {1, 5, 6}) -- N.B. region 1 is rested XP, 5 is background, 6 is the normal XP
	self:addSkinFrame{obj=MainMenuBar, ft=ftype, noBdr=true, x1=-4, y1=-5, x2=4, y2=yOfs}
	self:keepFontStrings(MainMenuBarMaxLevelBar)
	self:keepFontStrings(MainMenuBarArtFrame)
	self:keepRegions(ReputationWatchStatusBar, {9, 10}) -- 9 is background, 10 is the normal texture

	-- Shapeshift Bar Frame
	self:keepFontStrings(ShapeshiftBarFrame)
	-- Possess Bar Frame
	self:keepFontStrings(PossessBarFrame)
	-- Pet Action Bar Frame
	self:keepFontStrings(PetActionBarFrame)
	-- Shaman's Totem Frame
	self:keepFontStrings(MultiCastFlyoutFrame)

-->>-- Action Buttons
	for i = 1, NUM_ACTIONBAR_BUTTONS do
		btnName = "ActionButton"..i
		btn = _G[btnName]
		_G[btnName.."Border"]:SetAlpha(0) -- texture changed in blizzard code
		-- _G[btnName.."Border"].Show = _G[btnName.."Border"].Hide
		btn.SetNormalTexture = function() end
		self:addButtonBorder{obj=btn, abt=true, sec=true}
	end

-->>-- Bonus Action Bar Buttons
	for i = 1, NUM_BONUS_ACTION_SLOTS do
		btnName = "BonusActionButton"..i
		btn = _G[btnName]
		btn.bg:SetAlpha(0) -- texture changed in the blizzard code
		_G[btnName.."Border"]:SetAlpha(0) -- texture changed in blizzard code
		-- _G[btnName.."Border"].Show = _G[btnName.."Border"].Hide
		btn.SetNormalTexture = function() end
		self:addButtonBorder{obj=btn, abt=true, sec=true}
	end
	local function toggleActionButtons(show)

		for i = 1, NUM_ACTIONBAR_BUTTONS do
			_G["ActionButton"..i]:SetAlpha(show and 0 or 1)
		end

	end
	if BonusActionBarFrame:IsShown() then toggleActionButtons(true) end
	-- hook these to hide/show ActionButtons when shapeshifting (Druid/Rogue)
	-- also handle Bar changes (Catalysm)
	self:SecureHook("ShowBonusActionBar", function()
		toggleActionButtons(true)
		if BonusActionBarFrame.currentType ~= "default" then
			self.skinFrame[BonusActionBarFrame]:Show()
		else
			self.skinFrame[BonusActionBarFrame]:Hide()
		end
	end)
	self:SecureHook("HideBonusActionBar", function()
		toggleActionButtons()
	end)
	local x1, y1, x2, y2 = 0, 0, 0, 0
	if BonusActionBarFrame.currentType ~= "default" then
		x1, y1, x2, y2 = 31, -7, -31, -2
	end
	local frame = self:addSkinFrame{obj=BonusActionBarFrame, ft=ftype, kfs=true, x1=x1, y1=y1, x2=x2, y2=y2}
	if BonusActionBarFrame.currentType == "default" then frame:Hide() end

-->>-- MultiBar Buttons
	for _, v in pairs{"BottomLeft", "BottomRight", "Right", "Left"} do
		for i = 1, NUM_MULTIBAR_BUTTONS do
			btnName = "MultiBar"..v.."Button"..i
			btn = _G[btnName]
			_G[btnName.."Border"]:SetAlpha(0) -- texture changed in blizzard code
			-- _G[btnName.."Border"].Show = _G[btnName.."Border"].Hide
			btn.SetNormalTexture = function() end
			self:addButtonBorder{obj=btn, abt=true, sec=true}
		end
	end

-->>-- add button borders if required
	if self.modBtnBs then
		-- Micro buttons
		for _, v in pairs{"Character", "Spellbook", "Talent", "Achievement", "QuestLog", "PVP", "LFD", "MainMenu", "Help", "Guild"} do
			self:addButtonBorder{obj=_G[v.."MicroButton"], mb=true, ofs=0, y1=-21}
		end
		self:addButtonBorder{obj=FriendsMicroButton, x1=1, y1=1, x2=-2, y2=-1}-- on ChatFrame
		self:addButtonBorder{obj=EJMicroButton, mb=true, ofs=0, y1=-21}
		self:addButtonBorder{obj=RaidMicroButton, mb=true, ofs=0, y1=-21}
		-- Bag buttons
		self:addButtonBorder{obj=MainMenuBarBackpackButton}
		self:addButtonBorder{obj=CharacterBag0Slot}
		self:addButtonBorder{obj=CharacterBag1Slot}
		self:addButtonBorder{obj=CharacterBag2Slot}
		self:addButtonBorder{obj=CharacterBag3Slot}
		for i = 1, NUM_SHAPESHIFT_SLOTS do
			btn = _G["ShapeshiftButton"..i]
			self:addButtonBorder{obj=btn, abt=true, sec=true}
		end
		for i = 1, NUM_POSSESS_SLOTS do
			btn = _G["PossessButton"..i]
			self:addButtonBorder{obj=btn, abt=true, sec=true}
		end
		for i = 1, NUM_PET_ACTION_SLOTS do
			btn = _G["PetActionButton"..i]
			self:addButtonBorder{obj=btn, pabt=true, sec=true}
		end
		self:addButtonBorder{obj=MultiCastSummonSpellButton, abt=true, sec=true, ofs=5}
		self:addButtonBorder{obj=MultiCastRecallSpellButton, abt=true, sec=true, ofs=5}
		for i = 1, NUM_MULTI_CAST_PAGES * NUM_MULTI_CAST_BUTTONS_PER_PAGE do
			self:addButtonBorder{obj=_G["MultiCastActionButton"..i], abt=true, sec=true, ofs=5}
		end
	end
-->>-- Vehicle Leave Button
	self:addSkinButton{obj=MainMenuBarVehicleLeaveButton, parent=MainMenuBarVehicleLeaveButton}
	self:SecureHook("MainMenuBarVehicleLeaveButton_Update", function()
		self:moveObject{obj=MainMenuBarVehicleLeaveButton, y=3}
	end)

-->>-- TalentMicroButtonAlert
	self:addSkinFrame{obj=TalentMicroButtonAlert, ft=ftype, kfs=true, y1=3, x2=3}

end

function aObj:CoinPickup()
	if not self.db.profile.CoinPickup or self.initialized.CoinPickup then return end
	self.initialized.CoinPickup = true

	self:add2Table(self.uiKeys1, "CoinPickup")

	self:addSkinFrame{obj=CoinPickupFrame, ft=ftype, kfs=true, x1=9, y1=-12, x2=-6, y2=12}

end

function aObj:ItemSocketingUI() -- LoD
	if not self.db.profile.ItemSocketingUI or self.initialized.ItemSocketingUI then return end
	self.initialized.ItemSocketingUI = true

	local colour
	local function colourSockets()

		for i = 1, GetNumSockets() do
			colour = GEM_TYPE_INFO[GetSocketTypes(i)]
			self.sBtn[_G["ItemSocketingSocket"..i]]:SetBackdropBorderColor(colour.r, colour.g, colour.b)
		end

	end
	-- hook this to colour the button border
	self:SecureHook("ItemSocketingFrame_Update", function()
		colourSockets()
	end)

	self:addSkinFrame{obj=ItemSocketingFrame, ft=ftype, kfs=true, x1=10, y1=-12, x2=-4, y2=26}

	self:skinScrollBar{obj=ItemSocketingScrollFrame}

	for i = 1, MAX_NUM_SOCKETS do
		objName = "ItemSocketingSocket"..i
		obj = _G[objName]
		_G[objName.."Left"]:SetAlpha(0)
		_G[objName.."Right"]:SetAlpha(0)
		self:getRegion(obj, 3):SetAlpha(0) -- button texture
		self:addSkinButton{obj=obj}
	end
	-- now colour the sockets
	colourSockets()

end

function aObj:GuildBankUI() -- LoD
	if not self.db.profile.GuildBankUI or self.initialized.GuildBankUI then return end
	self.initialized.GuildBankUI = true

-->>--	Main Frame
	GuildBankEmblemFrame:Hide()
	for i = 1, NUM_GUILDBANK_COLUMNS do
		objName = "GuildBankColumn"..i
		_G[objName.."Background"]:SetAlpha(0)
		for j = 1, NUM_SLOTS_PER_GUILDBANK_GROUP do
			self:addButtonBorder{obj=_G[objName.."Button"..j], ibt=true}
		end
	end
	self:skinEditBox{obj=GuildItemSearchBox, regs={9}, mi=true, noHeight=true, noMove=true}
	self:skinTabs{obj=GuildBankFrame, lod=true}
	self:addSkinFrame{obj=GuildBankFrame, ft=ftype, kfs=true, hdr=true, y1=-11, y2=1}

-->>--	Log Frame
	self:skinScrollBar{obj=GuildBankTransactionsScrollFrame}

-->>--	Info Frame
	self:skinScrollBar{obj=GuildBankInfoScrollFrame}

-->>--	GuildBank Popup Frame
	self:skinEditBox{obj=GuildBankPopupEditBox, regs={9}}
	self:skinScrollBar{obj=GuildBankPopupScrollFrame}
	self:addSkinFrame{obj=GuildBankPopupFrame, ft=ftype, kfs=true, hdr=true, x1=2, y1=-12, x2=-24, y2=24}

-->>--	Tabs (side)
	for i = 1, MAX_GUILDBANK_TABS do
		objName = "GuildBankTab"..i
		_G[objName]:DisableDrawLayer("BACKGROUND")
		self:addButtonBorder{obj=_G[objName.."Button"], relTo=_G[objName.."ButtonIconTexture"]}
	end

end

function aObj:Nameplates()
	if not self.db.profile.Nameplates or self.initialized.Nameplates then return end
	self.initialized.Nameplates = true

	self:add2Table(self.uiKeys1, "Nameplates")

	local npEvt
	local function skinNameplates()

		local tex, sb
		for _, child in pairs{WorldFrame:GetChildren()} do
			if child.GetName
			and child:GetName()
			and child:GetName():find("^NamePlate%d+$")
			then
				-- aObj:ShowInfo(child, true)
				for k, reg in ipairs{child:GetRegions()} do -- process in key order
					-- region 1 is the flash texture, toggled using aggro warning option
					if k == 2 -- border texture
					or k == 3-- glow effect
					then reg:SetAlpha(0)
					end
					-- regions 4 & 5 are text, 6 & 7 are raid icons, 8 is the elite icon
				end
				-- skin both status bars
				sb = aObj:getChild(child, 1)
				if not aObj.sbGlazed[sb] then aObj:glazeStatusBar(sb, 0) end
				sb = aObj:getChild(child, 2)
				if not aObj.sbGlazed[sb] then aObj:glazeStatusBar(sb, 0) end
				-- skin the Shield texture
				aObj:getRegion(sb, 2):SetAlpha(0) -- border texture
				aObj:changeShield(self:getRegion(sb, 3), self:getRegion(sb, 4)) -- non-interruptible shield texture and icon
			end
		end

		-- if the nameplates are off then disable the skinning code
		if not GetCVarBool("nameplateShowEnemies")
		and not GetCVarBool("nameplateShowFriends")
		then
			aObj:CancelTimer(npEvt, true)
			npEvt = nil
		end

	end

	local function showFunc()

		if not npEvt then
			npEvt = aObj:ScheduleRepeatingTimer(skinNameplates, 0.2)
		end

	end

	self:SecureHook("SetCVar", function(varName, varValue, ...)
		if varName:find("nameplateShow") and varValue == 1 then showFunc() end
	end)

	if GetCVarBool("nameplateShowEnemies")
	or GetCVarBool("nameplateShowFriends")
	then
		showFunc()
	end

end

function aObj:GMChatUI() -- LoD
	if not self.db.profile.GMChatUI or self.initialized.GMChatUI then return end
	self.initialized.GMChatUI = true

-->>-- GM Chat Request frame
	GMChatStatusFrame:DisableDrawLayer("BORDER")
	GMChatStatusFrame:DisableDrawLayer("OVERLAY")
	self:addSkinFrame{obj=GMChatStatusFrame, ft=ftype, anim=true, x1=30, y1=-12, x2=-30, y2=12}

-->>-- GMChat Frame
	if self.db.profile.ChatFrames then
		self:addSkinFrame{obj=GMChatFrame, ft=ftype, x1=-4, y1=4, x2=4, y2=-8, nb=true}
	end
	self:skinButton{obj=GMChatFrameCloseButton, cb=true}
	GMChatFrame:DisableDrawLayer("BORDER")

-->>-- GMChatFrameEditBox
	if self.db.profile.ChatEditBox.skin then
		if self.db.profile.ChatEditBox.style == 1 then -- Frame
			local kRegions = CopyTable(self.ebRegions)
			table.insert(kRegions, 12)
			self:keepRegions(GMChatFrame.editBox, kRegions)
			self:addSkinFrame{obj=GMChatFrame.editBox, ft=ftype, x1=2, y1=-2, x2=-2}
		elseif self.db.profile.ChatEditBox.style == 2 then -- Editbox
			self:skinEditBox{obj=GMChatFrame.editBox, regs={12}, noHeight=true}
		else -- Borderless
			self:removeRegions(GMChatFrame.editBox, {6, 7, 8})
			self:addSkinFrame{obj=GMChatFrame.editBox, ft=ftype, noBdr=true, x1=5, y1=-4, x2=-5, y2=2}
		end
	end

-->>-- GMChat Frame Tab
	self:addSkinFrame{obj=GMChatTab, kfs=true, ft=ftype, noBdr=self.isTT, y2=-4}

end

function aObj:AutoComplete()
	if not self.db.profile.AutoComplete or self.initialized.AutoComplete then return end
	self.initialized.AutoComplete = true


	self:add2Table(self.uiKeys1, "AutoComplete")

	self:addSkinFrame{obj=AutoCompleteBox, kfs=true, ft=ftype}

end

function aObj:DebugTools() -- LoD
	if not self.db.profile.DebugTools or self.initialized.DebugTools then return end
	self.initialized.DebugTools = true

	self:addSkinFrame{obj=EventTraceFrame, kfs=true, ft=ftype, x1=1, y1=-2, x2=-1, y2=4}
	self:skinSlider{obj=EventTraceFrameScroll, size=3}
	self:skinScrollBar{obj=ScriptErrorsFrameScrollFrame}
	self:addSkinFrame{obj=ScriptErrorsFrame, kfs=true, ft=ftype, x1=1, y1=-2, x2=-1, y2=4}

	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then
			self:add2Table(self.ttList, "FrameStackTooltip")
			self:add2Table(self.ttList, "EventTraceTooltip")
		end
		self:HookScript(FrameStackTooltip, "OnUpdate", function(this)
			self:skinTooltip(this)
		end)
		self:HookScript(EventTraceTooltip, "OnUpdate", function(this)
			self:skinTooltip(this)
		end)
	end

end

function aObj:RolePollPopup()
	if not self.db.profile.RolePollPopup or self.initialized.RolePollPopup then return end
	self.initialized.RolePollPopup = true

	self:add2Table(self.uiKeys1, "RolePollPopup")

	self:addSkinFrame{obj=RolePollPopup, ft=ftype, x1=5, y1=-5, x2=-5, y2=5}

end

function aObj:LFDFrame()
	if not self.db.profile.LFDFrame or self.initialized.LFDFrame then return end
	self.initialized.LFDFrame = true

	self:add2Table(self.uiKeys1, "LFDFrame")

	-- LFD RoleCheck Popup
	self:addSkinFrame{obj=LFDRoleCheckPopup, kfs=true, ft=ftype}
	-- LFD Parent Frame
	self:addSkinFrame{obj=LFDParentFrame, ft=ftype, kfs=true, ri=true, y1=2, x2=1, y2=-2}
	self:moveObject{obj=LFDParentFrameEyeFrame, x=10, y=-11}
	LowerFrameLevel(self.skinFrame[LFDParentFrame]) -- hopefully allow Random cooldown frame to appear in front now
	-- Queue Frame
	LFDQueueFrameBackground:SetAlpha(0)
	self:skinDropDown{obj=LFDQueueFrameTypeDropDown}
	self:skinScrollBar{obj=LFDQueueFrameRandomScrollFrame}
	self:removeMagicBtnTex(LFDQueueFrameFindGroupButton)
	self:removeMagicBtnTex(LFDQueueFrameCancelButton)
	if self.modBtnBs then
		self:SecureHook("LFDQueueFrameRandom_UpdateFrame", function()
			local btnName
			for i = 1, 5 do
				btnName = "LFDQueueFrameRandomScrollFrameChildFrameItem"..i
				if _G[btnName] then
					_G[btnName.."NameFrame"]:SetTexture(nil)
					self:addButtonBorder{obj=_G[btnName], libt=true}
				end
			end
		end)
	end
	-- Specific List subFrame
	for i = 1, NUM_LFD_CHOICE_BUTTONS do
		btn = "LFDQueueFrameSpecificListButton"..i.."ExpandOrCollapseButton"
		self:skinButton{obj=_G[btn], mp2=true}
	end
	self:skinScrollBar{obj=LFDQueueFrameSpecificListScrollFrame}

end

function aObj:LFRFrame()
	if not self.db.profile.LFRFrame or self.initialized.LFRFrame then return end
	self.initialized.LFRFrame = true

	self:add2Table(self.uiKeys1, "LFRFrame")

-->>-- LFR Parent Frame
-->>-- LFR Queue Frame
	self:removeInset(LFRQueueFrameRoleInset)
	self:removeInset(LFRQueueFrameCommentInset)
	self:removeInset(LFRQueueFrameListInset)
	LFRQueueFrameCommentExplanation:SetTextColor(self.BTr, self.BTg, self.BTb)
	-- Specific List subFrame
	for i = 1, NUM_LFR_CHOICE_BUTTONS do
		btn = "LFRQueueFrameSpecificListButton"..i.."ExpandOrCollapseButton"
		self:skinButton{obj=_G[btn], mp2=true}
		self:moveObject{obj=_G[btn.."Highlight"], x=-3} -- move highlight to the left
	end
	self:skinScrollBar{obj=LFRQueueFrameSpecificListScrollFrame}

-->>-- LFR Browse Frame
	self:skinDropDown{obj=LFRBrowseFrameRaidDropDown}
	self:skinFFColHeads("LFRBrowseFrameColumnHeader", 7)
	self:skinScrollBar{obj=LFRBrowseFrameListScrollFrame}
	self:keepFontStrings(LFRBrowseFrame)

	-->>-- Tabs (side)
	for i = 1, 2 do
		obj = _G["LFRParentFrameSideTab"..i]
		obj:DisableDrawLayer("BACKGROUND")
		self:addButtonBorder{obj=obj}
	end

end

function aObj:BNFrames()
	if not self.db.profile.BNFrames or self.initialized.BNFrames then return end
	self.initialized.BNFrames = true

	self:add2Table(self.uiKeys1, "BNFrames")

-->>-- Toast frame
	-- remove textures from close button
	-- this involves using text instead of a texture
	if not self.modBtns then
		local btn = BNToastFrameCloseButton
		-- create font to use
		btn:GetNormalTexture():SetTexture(nil)
		btn:GetPushedTexture():SetTexture(nil)
		btn:SetText(self.modUIBtns.mult)
		btn:SetNormalFontObject(self.modUIBtns.fontSBX)
		self:adjWidth{obj=btn, adj=-2}
		self:adjHeight{obj=btn, adj=-2}
		btn:GetFontString():ClearAllPoints()
		btn:GetFontString():SetPoint("TOPRIGHT", -1, 0)
	end
	self:addSkinFrame{obj=BNToastFrame, ft=ftype, anim=true}

-->>-- Report frame
	BNetReportFrameComment:DisableDrawLayer("BACKGROUND")
	self:skinScrollBar{obj=BNetReportFrameCommentScrollFrame}
	self:skinEditBox{obj=BNetReportFrameCommentBox, regs={6}}
	self:addSkinFrame{obj=BNetReportFrame, ft=ftype}

-->>-- ConversationInvite frame
	self:addSkinFrame{obj=BNConversationInviteDialogList, ft=ftype}
	self:skinScrollBar{obj=BNConversationInviteDialogListScrollFrame}
	self:addSkinFrame{obj=BNConversationInviteDialog, kfs=true, ft=ftype, hdr=true}

end

function aObj:CinematicFrame()
	if not self.db.profile.CinematicFrame or self.initialized.CinematicFrame then return end
	self.initialized.CinematicFrame = true

	self:add2Table(self.uiKeys1, "CinematicFrame")

	self:addSkinFrame{obj=CinematicFrame.closeDialog, ft=ftype}

end

function aObj:LevelUpDisplay()
	if not self.db.profile.LevelUpDisplay or self.initialized.LevelUpDisplay then return end
	self.initialized.LevelUpDisplay = true

	self:add2Table(self.uiKeys1, "LevelUpDisplay")

	LevelUpDisplay:DisableDrawLayer("BACKGROUND")

end

function aObj:SpellFlyout()
	if not self.db.profile.SpellFlyout or self.initialized.SpellFlyout then return end
	self.initialized.SpellFlyout = true

	self:add2Table(self.uiKeys1, "SpellFlyout")

	self:SecureHook("ActionButton_UpdateFlyout", function(this)
		if this.FlyoutBorder
		and not self.skinned[this]
		then
			this.FlyoutBorder:SetAlpha(0)
			this.FlyoutBorderShadow:SetAlpha(0)
		end
	end)

end

function aObj:GuildInvite()
	if not self.db.profile.GuildInvite or self.initialized.GuildInvite then return end
	self.initialized.GuildInvite = true

	self:add2Table(self.uiKeys1, "GuildInvite")

	self:keepFontStrings(GuildInviteFrameLevel)
	GuildInviteFrame:DisableDrawLayer("BACKGROUND")
	GuildInviteFrame:DisableDrawLayer("BORDER")
	GuildInviteFrame:DisableDrawLayer("ARTWORK")
	GuildInviteFrame:DisableDrawLayer("OVERLAY")
	self:addSkinFrame{obj=GuildInviteFrame, ft=ftype}

end

function aObj:GhostFrame()
	if not self.db.profile.GhostFrame or self.initialized.GhostFrame then return end
	self.initialized.GhostFrame = true

	self:add2Table(self.uiKeys1, "GhostFrame")

	self:addButtonBorder{obj=GhostFrameContentsFrame, relTo=GhostFrameContentsFrameIcon}
	self:addSkinButton{obj=GhostFrame, parent=GhostFrame, kfs=true, sap=true, hide=true}
	GhostFrame:SetFrameStrata("HIGH") -- make it appear above other frames (i.e. Corkboard)

end

function aObj:LookingForGuildUI() -- LoD
	if not self.db.profile.LookingForGuildUI or self.initialized.LookingForGuildUI then return end
	self.initialized.LookingForGuildUI = true

	self:skinTabs{obj=LookingForGuildFrame, up=true, lod=true, x1=0, y1=-5, x2=0, y2=-5}
	self:addSkinFrame{obj=LookingForGuildFrame, ft=ftype, kfs=true, ri=true, y1=2, x2=1}
	-- Start Frame (Settings)
	LookingForGuildInterestFrameBg:SetAlpha(0)
	LookingForGuildAvailabilityFrameBg:SetAlpha(0)
	LookingForGuildRolesFrameBg:SetAlpha(0)
	LookingForGuildCommentFrameBg:SetAlpha(0)
	self:skinScrollBar{obj=LookingForGuildCommentInputFrameScrollFrame}
	self:addSkinFrame{obj=LookingForGuildCommentInputFrame, ft=ftype, kfs=true, ofs=-1}
	LookingForGuildCommentEditBoxFill:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:removeMagicBtnTex(LookingForGuildBrowseButton)
	-- Browse Frame
	self:skinSlider{obj=LookingForGuildBrowseFrameContainerScrollBar, adj=-4}
	for i = 1, #LookingForGuildBrowseFrameContainer.buttons do
		btn = LookingForGuildBrowseFrameContainer.buttons[i]
		self:applySkin{obj=btn}
		_G[btn:GetName().."Ring"]:SetAlpha(0)
		btn.PointsSpentBgGold:SetAlpha(0)
		self:moveObject{obj=btn.PointsSpentBgGold, x=6, y=-6}
	end
	self:removeMagicBtnTex(LookingForGuildRequestButton)
	-- Apps Frame (Requests)
	self:skinSlider{obj=LookingForGuildAppsFrameContainerScrollBar}
	for i = 1, #LookingForGuildAppsFrameContainer.buttons do
		btn = LookingForGuildAppsFrameContainer.buttons[i]
		self:applySkin{obj=btn}
	end
	-- Request Membership Frame
	GuildFinderRequestMembershipEditBoxFill:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:addSkinFrame{obj=GuildFinderRequestMembershipFrameInputFrame, ft=ftype}
	self:addSkinFrame{obj=GuildFinderRequestMembershipFrame, ft=ftype}

end

function aObj:LFGFrame()
	if not self.db.profile.LFGFrame or self.initialized.LFGFrame then return end
	self.initialized.LFGFrame = true

	self:add2Table(self.uiKeys1, "LFGFrame")

	-- LFG DungeonReady Popup a.k.a. ReadyCheck
	self:addSkinFrame{obj=LFGDungeonReadyStatus, kfs=true, ft=ftype}
	self:addSkinFrame{obj=LFGDungeonReadyDialog, kfs=true, ft=ftype}
	LFGDungeonReadyDialog.SetBackdrop = function() end
	LFGDungeonReadyDialogRewardsFrameReward1Border:SetAlpha(0)
	LFGDungeonReadyDialogRewardsFrameReward2Border:SetAlpha(0)
	-- Search Status Frame
	self:addSkinFrame{obj=LFGSearchStatus, ft=ftype}

end

function aObj:MovePad() -- LoD
	if not self.db.profile.MovePad or self.initialized.MovePad then return end
	self.initialized.MovePad = true

	self:skinButton{obj=MovePadForward}
	self:skinButton{obj=MovePadJump}
	self:skinButton{obj=MovePadBackward}
	self:skinButton{obj=MovePadStrafeLeft}
	self:skinButton{obj=MovePadStrafeRight}
	-- MovePadLock:SetBackdrop(nil)
	self:addSkinButton{obj=MovePadLock, as=true, ofs=-4}
	self:addSkinFrame{obj=MovePadFrame, ft=ftype}

end

function aObj:RaidFrame()
	if not self.db.profile.RaidFrame or self.initialized.RaidFrame then return end
	self.initialized.RaidFrame = true

	self:add2Table(self.uiKeys1, "RaidFrame")

	self:skinTabs{obj=RaidParentFrame, lod=true}
	self:addSkinFrame{obj=RaidParentFrame, ft=ftype, kfs=true, ri=true, y1=2, x2=1, y2=-6}

-->>-- RaidFinder Frame
	self:keepRegions(RaidFinderFrame, {})
	self:removeInset(RaidFinderFrameRoleInset)
	self:keepRegions(RaidFinderQueueFrame, {})
	self:skinDropDown{obj=RaidFinderQueueFrameSelectionDropDown}
	self:skinScrollBar{obj=RaidFinderQueueFrameScrollFrame}

-->>-- Raid Frame
	self:skinButton{obj=RaidFrameConvertToRaidButton}
	self:skinButton{obj=RaidFrameRaidInfoButton}
	self:keepFontStrings(RaidInfoFrame)
	self:skinSlider{obj=RaidInfoScrollFrame.scrollBar}

end
