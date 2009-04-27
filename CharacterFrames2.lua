local ftype = "c"

function Skinner:FriendsFrame()
	if not self.db.profile.FriendsFrame or self.initialized.FriendsFrame then return end
	self.initialized.FriendsFrame = true

	self:SecureHook("FriendsFrame_ShowSubFrame", function(frameName)
--		self:Debug("FriendsFrame_ShowSubFrame: [%s, %s]", frameName, FriendsFrame.selectedTab)
		for i, v in pairs(FRIENDSFRAME_SUBFRAMES) do
--			self:Debug("FRIENDSFRAME_SUBFRAMES: [%s, %s]", i, v)
			-- change the texture for the Active and Inactive tabs
			if self.db.profile.TexturedTab then
				-- handle Friends and Ignore on the same Tab
				local j = ( i > 1 and i - 1 or i)
				-- handle Friends, Ignore and Muted on the same Tab
				j = ( j > 1 and j - 1 or j)
--				self:Debug("FF_SF: [%s]", j)
				-- handle additional Tabs with altered names or numbers
				local prefix = (v == "BadapplesFrame" and "Badapples" or "")
				local tabId  = (v == "BadapplesFrame" and 5 or j)
				-- ignore the IgnoreListFrame (also the MutedListFrame)
 				if v ~= "IgnoreListFrame" and v ~= "MutedListFrame" then
					self:setInactiveTab(_G[prefix.."FriendsFrameTab"..tabId])
				end
				if v == frameName then
					self:setActiveTab(_G[prefix.."FriendsFrameTab"..tabId])
				end
			end
		end
	end)

	self:SecureHook("GuildStatus_Update", function()
--		self:Debug("GuildStatus_Update")
		local _, _, _, xOfs, _ = GuildFrameGuildListToggleButton:GetPoint()
		if xOfs == 284 then
			self:moveObject(GuildFrameGuildListToggleButton, "+", 23, "-", 46)
		else
			self:moveObject(GuildFrameGuildListToggleButton, nil, nil, "-", 46)
		end
	end)

-->>--	Friends Frame
	self:keepFontStrings(FriendsFrame)

	FriendsFrame:SetWidth(FriendsFrame:GetWidth() * self.FxMult)
	FriendsFrame:SetHeight(FriendsFrame:GetHeight() * self.FyMult)

	self:moveObject(FriendsFrameTitleText, nil, nil, "+", 6)
	self:moveObject(FriendsFrameCloseButton, "+", 30, "+", 8)

	self:skinFFToggleTabs("FriendsFrameToggleTab") --N.B. Prefix string

	self:moveObject(FriendsFrameAddFriendButton, "-", 9, "-", 70)
	self:moveObject(FriendsFrameFriendButton1, nil, nil, "+", 15)

	self:moveObject(FriendsFrameFriendsScrollFrame, "+", 35, "+", 14)
	self:removeRegions(FriendsFrameFriendsScrollFrame)
	self:skinScrollBar(FriendsFrameFriendsScrollFrame)

-->>--	Ignore Frame
	self:keepFontStrings(IgnoreListFrame)

	IgnoreListFrame:SetWidth(IgnoreListFrame:GetWidth() * self.FxMult)
	IgnoreListFrame:SetHeight(IgnoreListFrame:GetHeight() * self.FyMult)

	self:skinFFToggleTabs("IgnoreFrameToggleTab") --N.B. Prefix string

	self:moveObject(FriendsFrameIgnorePlayerButton, "-", 9, "-", 70)
	self:moveObject(FriendsFrameStopIgnoreButton, "+", 4, nil, nil)
	self:moveObject(FriendsFrameIgnoreButton1, nil, nil, "+", 15)

	self:moveObject(FriendsFrameIgnoreScrollFrame, "+", 35, "+", 14)
	self:removeRegions(FriendsFrameIgnoreScrollFrame)
	self:skinScrollBar(FriendsFrameIgnoreScrollFrame)

-->>--	MutedList Frame (New 2.2)
	self:keepFontStrings(MutedListFrame)
	self:skinFFToggleTabs("MutedFrameToggleTab", 3) --N.B. Prefix string
	self:moveObject(FriendsFrameMutedPlayerButton, "-", 9, "-", 70)
	self:moveObject(FriendsFrameUnmuteButton, "+", 4, nil, nil)
	self:moveObject(FriendsFrameMutedButton1, nil, nil, "+", 15)
	self:moveObject(FriendsFrameMutedScrollFrame, "+", 35, "+", 14)
	self:removeRegions(FriendsFrameMutedScrollFrame)
	self:skinScrollBar(FriendsFrameMutedScrollFrame)

-->>--	Who Frame
	WhoFrame:SetWidth(WhoFrame:GetWidth() * self.FxMult)
	WhoFrame:SetHeight(WhoFrame:GetHeight() * self.FyMult)

	self:skinFFColHeads("WhoFrameColumnHeader") --N.B. Prefix string
	self:moveObject(WhoFrameColumnHeader1, "-", 6, "+", 25)

	self:skinDropDown(WhoFrameDropDown, nil, true)
	self:moveObject(WhoFrameDropDown, "+", 5, "+", 1)
	self:moveObject(WhoFrameButton1, "-", 5, "+", 15)

	self:moveObject(WhoListScrollFrame, "+", 35, "+", 20)
	self:removeRegions(WhoListScrollFrame)
	self:skinScrollBar(WhoListScrollFrame)

	self:moveObject(WhoFrameEditBox, "+", 20, "-", 65)
	WhoFrameEditBox:SetWidth(WhoFrameEditBox:GetWidth() + 30)
	self:skinEditBox(WhoFrameEditBox)

	self:moveObject(WhoFrameTotals, nil, nil, "-", 66)
	self:moveObject(WhoFrameGroupInviteButton, "+", 30, "-", 71)

-->>--	Guild Frame
	GuildFrame:SetWidth(GuildFrame:GetWidth() * self.FxMult)
	GuildFrame:SetHeight(GuildFrame:GetHeight() * self.FyMult)

	-- show offline members text and checkbox
	self:keepFontStrings(GuildFrameLFGFrame)
	self:moveObject(GuildFrameLFGButton, "+", 42, "+", 12)

	self:skinFFColHeads("GuildFrameColumnHeader") --N.B. Prefix string
	self:moveObject(GuildFrameColumnHeader1, "-", 6, "+", 15)
	self:moveObject(GuildFrameButton1, "-", 5, "+", 15)
	self:skinFFColHeads("GuildFrameGuildStatusColumnHeader") --N.B. Prefix string
	self:moveObject(GuildFrameGuildStatusColumnHeader1, "-", 6, "+", 15)
	self:moveObject(GuildFrameGuildStatusButton1, "-", 5, "+", 15)

	self:moveObject(GuildListScrollFrame, "+", 35, "+", 20)
	self:removeRegions(GuildListScrollFrame)
	self:skinScrollBar(GuildListScrollFrame)

	self:moveObject(GuildFrameTotals, nil, nil, "-", 46)
	self:moveObject(GuildFrameNotesLabel, "-", 8, "-", 8) -- MOTD
	self:moveObject(GuildFrameControlButton, "+", 30, "-", 71)

	-- Guild Control Popup Frame
	GuildControlPopupFrame:SetHeight(FriendsFrame:GetHeight())
	self:keepFontStrings(GuildControlPopupFrame)
	self:moveObject(GuildControlPopupFrame, "+", 36, "+", 6)
	self:moveObject(GuildControlPopupFrameCancelButton, "+", 20, "-", 26)
	self:skinDropDown(GuildControlPopupFrameDropDown)
	GuildControlPopupFrameEditBox:SetWidth(GuildControlPopupFrameEditBox:GetWidth() + 30)
	self:skinEditBox(GuildControlPopupFrameEditBox, {9})
	self:skinEditBox(GuildControlWithdrawGoldEditBox, {9})
	self:skinEditBox(GuildControlWithdrawItemsEditBox, {9})
	self:moveObject(GuildControlPopupFrameTabPermissions, "+", 10, "-", 20)
	self:storeAndSkin(ftype, GuildControlPopupFrameTabPermissions)
	for i = 1, MAX_GUILDBANK_TABS do
		local gbtpt = _G["GuildBankTabPermissionsTab"..i]
		local gbtptText = _G["GuildBankTabPermissionsTab"..i.."Text"]
		self:keepFontStrings(gbtpt)
		self:storeAndSkin(ftype, gbtpt)
		gbtpt:SetHeight(gbtpt:GetHeight() - 5)
		if i == 6 then self:moveObject(gbtpt, nil, nil, "-", 5) end
		self:moveObject(gbtptText, nil, nil, "+", 5)
	end
	self:storeAndSkin(ftype, GuildControlPopupFrame)

-->>--	GuildInfo Frame
	self:keepFontStrings(GuildInfoFrame)
	self:moveObject(GuildInfoTitle, nil, nil, "+", 3)

	self:removeRegions(GuildInfoFrameScrollFrame)
	self:skinScrollBar(GuildInfoFrameScrollFrame)

	self:storeAndSkin(ftype, GuildInfoTextBackground)
	self:storeAndSkin(ftype, GuildInfoFrame)

-->>--	GuildMemberDetail Frame
	self:keepFontStrings(GuildMemberDetailFrame)
	self:moveObject(GuildMemberDetailFrame, "+", 30, "-", 40)
	self:moveObject(GuildFramePromoteButton, nil, nil, "-", 30)
	self:storeAndSkin(ftype, GuildMemberNoteBackground)
	self:storeAndSkin(ftype, GuildMemberOfficerNoteBackground)
	self:storeAndSkin(ftype, GuildMemberDetailFrame)

-->>--	GuildEventLog Frame
	self:keepRegions(GuildEventLogFrame, {2}) -- N.B. region 2 is text
	self:storeAndSkin(ftype, GuildEventFrame)
	self:removeRegions(GuildEventLogScrollFrame)
	self:skinScrollBar(GuildEventLogScrollFrame)
	self:storeAndSkin(ftype, GuildEventLogFrame)

-->>--	Channel Frame (New 2.2)
	self:SecureHook("ChannelList_Update", function()
		for i = 1, MAX_CHANNEL_BUTTONS do
			local cbnt = _G["ChannelButton"..i.."NormalTexture"]
			cbnt:SetAlpha(0)
		end
	end)
	self:keepFontStrings(ChannelFrame)
	ChannelFrameVerticalBar:Hide()
	self:removeRegions(ChannelListScrollFrame)
	self:skinScrollBar(ChannelListScrollFrame)
	self:removeRegions(ChannelRosterScrollFrame)
	self:skinScrollBar(ChannelRosterScrollFrame)
	self:moveObject(ChannelFrameNewButton, "-", 8, "-", 5)
	-- Channel Pullout Tab & Frame
	ChannelPulloutTab:SetWidth(ChannelPulloutTab:GetWidth() + 14)
	ChannelPulloutTab:SetHeight(ChannelPulloutTab:GetHeight() * self.FTyMult)
	self:keepRegions(ChannelPulloutTab, {4, 5}) -- N.B. region 4 is text, 5 is highlight
	self:moveObject(ChannelPulloutTabText, nil, nil, "+", 10)
	self:moveObject(self:getRegion(ChannelPulloutTab, 5), "-", 5, "+", 10) -- highlight texture
	self:applySkin(ChannelPulloutTab)
-- 	self:moveObject(ChannelPullout, "+", 10, nil, nil)
	self:moveObject(ChannelPulloutCloseButton, "+", 2, "+", 2)
	self:applySkin(ChannelPullout)
	self:RawHook(ChannelPullout, "SetBackdropColor", function() end, true)
	self:RawHook(ChannelPullout, "SetBackdropBorderColor", function() end, true)

-->>--	Daughter Frame
	self:keepFontStrings(ChannelFrameDaughterFrame)
	self:storeAndSkin(ftype, ChannelFrameDaughterFrame)
	self:skinEditBox(ChannelFrameDaughterFrameChannelName, {9})
	self:skinEditBox(ChannelFrameDaughterFrameChannelPassword, {9, 10}) -- N.B. regions 9 & 10 are text
	self:skinDropDown(ChannelListDropDown)
	self:skinDropDown(ChannelRosterDropDown)

-->>--	Raid Frame
	self:moveObject(RaidFrameConvertToRaidButton, "-", 30, "+", 10)

	if IsAddOnLoaded("Blizzard_RaidUI") then self:RaidUI() end

-->>--	RaidInfo Frame
	self:keepFontStrings(RaidInfoFrame)
	self:moveObject(RaidInfoScrollFrame, "+", 5, nil, nil)
	self:removeRegions(RaidInfoScrollFrame)
	self:skinScrollBar(RaidInfoScrollFrame)
	self:storeAndSkin(ftype, RaidInfoFrame)
	self:SecureHook(RaidInfoFrame, "Show", function()
		self:moveObject(RaidInfoFrame, "+", 35, nil, nil)
	end)

	self:storeAndSkin(ftype, FriendsFrame)

-->>--	Frame Tabs
	for i = 1, FriendsFrame.numTabs do
		local tabName = _G["FriendsFrameTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		if i == 1 then
			self:moveObject(tabName, nil, nil, "-", 72)
		else
			self:moveObject(tabName, "+", 9, nil, nil)
		end
		if self.db.profile.TexturedTab then self:applySkin(tabName, nil ,0)
		else self:storeAndSkin(ftype, tabName) end
	end

	-- Hook this to resize the Tabs
	self:SecureHook(FriendsFrame, "Show", function()
		self:resizeTabs(FriendsFrame)
	end)

end

function Skinner:TradeSkillUI()
	if not self.db.profile.TradeSkillUI or self.initialized.TradeSkillUI then return end
	self.initialized.TradeSkillUI = true

	-- if DoubleWideTradeSkills is loaded then use it's skin for the TradeSkillFrame
	if IsAddOnLoaded("DoubleWideTradeSkills") then return end

	self:keepFontStrings(TradeSkillFrame)
	TradeSkillFrame:SetWidth(TradeSkillFrame:GetWidth() * self.FxMult)
	TradeSkillFrame:SetHeight(TradeSkillFrame:GetHeight() * self.FyMult)
	self:moveObject(TradeSkillFrameTitleText, nil, nil, "+", 12)
	self:moveObject(TradeSkillFrameCloseButton, "+", 28, "+", 8)
	self:moveObject(TradeSkillRankFrame, "-", 40, "+", 14)
	TradeSkillRankFrameBorder:SetAlpha(0)
	self:glazeStatusBar(TradeSkillRankFrame, 0)
	self:moveObject(TradeSkillFrameAvailableFilterCheckButton, "-", 38, "+", 12)
	self:skinEditBox(TradeSkillFrameEditBox, {9})
	self:removeRegions(TradeSkillExpandButtonFrame)
	self:moveObject(TradeSkillExpandButtonFrame, "-", 6, "+", 12)
	self:skinDropDown(TradeSkillSubClassDropDown)
	self:skinDropDown(TradeSkillInvSlotDropDown)
	self:moveObject(TradeSkillInvSlotDropDown, "+", 20, "+", 12)
	self:moveObject(TradeSkillSkill1, "-", 6, "+", 12)
	self:moveObject(TradeSkillListScrollFrame, "+", 35, "+", 12)
	self:removeRegions(TradeSkillListScrollFrame)
	self:skinScrollBar(TradeSkillListScrollFrame)
	self:moveObject(TradeSkillDetailScrollFrame, "+", 2, "+", 12)
	self:removeRegions(TradeSkillDetailScrollFrame)
	self:skinScrollBar(TradeSkillDetailScrollFrame)
	self:moveObject(TradeSkillInputBox, "-", 5, nil, nil)
	self:skinEditBox(TradeSkillInputBox)
	self:moveObject(TradeSkillCreateButton, "-", 10, "-", 5)
	self:moveObject(TradeSkillCancelButton, "-", 7, "-", 5)
	for i = 1, 8 do
		self:moveObject(_G["TradeSkillReagent"..i.."Count"], "+", 4, nil, nil)
	end
	self:storeAndSkin(ftype, TradeSkillFrame)

end

function Skinner:TradeFrame()
	if not self.db.profile.TradeFrame or self.initialized.TradeFrame then return end
	self.initialized.TradeFrame = true

	self:keepFontStrings(TradeFrame)

	TradeFrame:SetWidth(TradeFrame:GetWidth() * self.FxMult)
	TradeFrame:SetHeight(TradeFrame:GetHeight() * self.FyMult)

	-- move everything up and across
	local xOfs = 12
	local yOfs = 40
	self:moveObject(TradeFrameRecipientNameText, "-", xOfs, "+", 6)
	self:moveObject(TradeFramePlayerNameText, "-", xOfs, "+", 6)
	self:moveObject(TradeFramePlayerEnchantText, "-", xOfs, "+", yOfs)
	self:moveObject(TradeHighlightPlayer, "-", xOfs, "+", yOfs)
	self:moveObject(TradeHighlightRecipient, "-", xOfs, "+", yOfs)
	self:moveObject(TradeRecipientItem1, "-", xOfs, "+", yOfs)
	self:moveObject(TradePlayerItem1, "-", xOfs, "+", yOfs)
	self:moveObject(TradeRecipientMoneyFrame, "+", xOfs, "+", yOfs)
	self:moveObject(TradePlayerInputMoneyFrame, "-", xOfs, "+", yOfs)
	self:skinMoneyFrame(TradePlayerInputMoneyFrame)

	self:moveObject(TradeFrameTradeButton, "+", 20, "-", 44)
	self:moveObject(TradeFrameCloseButton, "+", 26, "+", 8)

	self:storeAndSkin(ftype, TradeFrame)

end

function Skinner:QuestLog()
	if not self.db.profile.QuestLog.skin or self.initialized.QuestLog then return end
	self.initialized.QuestLog = true

	self:SecureHook("QuestLog_UpdateQuestDetails", function(doNotScroll)
--		self:Debug("QuestLog_UpdateQuestDetails")
		for i = 1, 10 do
			local r, g, b, a = _G["QuestLogObjective"..i]:GetTextColor()
			_G["QuestLogObjective"..i]:SetTextColor(self.BTr - r, self.BTg - g, self.BTb)
		end
		local r, g, b, a = QuestLogRequiredMoneyText:GetTextColor()
		QuestLogRequiredMoneyText:SetTextColor(self.BTr - r, self.BTg - g, self.BTb)
		QuestLogRewardTitleText:SetTextColor(self.HTr, self.HTg, self.HTb)
		QuestLogItemChooseText:SetTextColor(self.BTr, self.BTg, self.BTb)
		QuestLogItemReceiveText:SetTextColor(self.BTr, self.BTg, self.BTb)
	end)

	self:keepFontStrings(QuestLogFrame)
	QuestLogFrame:SetWidth(QuestLogFrame:GetWidth() * self.FxMult)
	QuestLogFrame:SetHeight(QuestLogFrame:GetHeight() * self.FyMult)
	self:moveObject(QuestLogTitleText, nil, nil, "+", 10)
	self:keepFontStrings(QuestLogCount)
	self:moveObject(QuestLogFrameCloseButton, "+", 29, "+", 8)

	-- movement values
	local xOfs, yOfs = 8, 24
	self:moveObject(QuestLogExpandButtonFrame, "-", xOfs, "+", yOfs)
	self:removeRegions(QuestLogCollapseAllButton, {7, 8, 9})
	self:moveObject(QuestLogQuestCount, nil, nil, "+", 20)
	self:moveObject(QuestLogTitle1, "-", xOfs, "+", yOfs)
	self:moveObject(QuestLogListScrollFrame, "-", xOfs, "+", yOfs)
	self:keepFontStrings(EmptyQuestLogFrame)

	QuestLogQuestTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
	QuestLogObjectivesText:SetTextColor(self.BTr, self.BTg, self.BTb)
	for i = 1, 10 do
   		local r, g, b, a = _G["QuestLogObjective"..i]:GetTextColor()
   		_G["QuestLogObjective"..i]:SetTextColor(self.BTr - r, self.BTg - g, self.BTb)
   	end
	QuestLogSuggestedGroupNum:SetTextColor(self.HTr, self.HTg, self.HTb)
	QuestLogDescriptionTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
	QuestLogQuestDescription:SetTextColor(self.BTr, self.BTg, self.BTb)

	self:skinScrollBar(QuestLogListScrollFrame)
	self:skinScrollBar(QuestLogDetailScrollFrame)
	self:moveObject(QuestLogFrameAbandonButton, "-", 12, "-", 47)
	self:moveObject(QuestFrameExitButton, "+", 32, "-", 47)
	self:storeAndSkin(ftype, QuestLogFrame)

end

--[[
function Skinner:ResizeQW()

	if self.db.profile.QuestLog.size == 1 then
		self.QWfont = GameFontHighlight
	else
		self.QWfont = GameFontHighlightSmall
	end
	for i = 1, 30 do
		_G["QuestWatchLine"..i]:SetFontObject(self.QWfont)
	end

end
--]]

function Skinner:RaidUI()
	if not self.db.profile.RaidUI or self.initialized.RaidUI then return end
	self.initialized.RaidUI = true

	self:moveObject(RaidFrameAddMemberButton, "-", 40, "+", 10)
	self:moveObject(RaidGroup1, "-", 7, "+", 8)
	for i = 1, MAX_RAID_CLASS_BUTTONS do
		local tabName = _G["RaidClassButton"..i]
		self:removeRegions(tabName, {1}) -- N.B. region 2 is the icon, 3 is the text
		-- Move the last entry as all the others are positioned from it
		if i == MAX_RAID_CLASS_BUTTONS then self:moveObject(tabName, "+", 31, "-", 70) end
	end

	self:SecureHook("RaidPullout_GetFrame", function(filterID)
		for i = 1, NUM_RAID_PULLOUT_FRAMES 	do
			local pulloutButton = _G["RaidPullout"..i]
			if not self.skinned[pulloutButton] then
				self:storeAndSkin(ftype, pulloutButton)
			end
		end
	end)

end

function Skinner:ReadyCheck()
	if not self.db.profile.ReadyCheck or self.initialized.ReadyCheck then return end
	self.initialized.ReadyCheck = true

-->>--	Ready Check Frame
	self:keepFontStrings(ReadyCheckListenerFrame)
	ReadyCheckListenerFrame:SetWidth(ReadyCheckListenerFrame:GetWidth() * self.FxMult)
	ReadyCheckListenerFrame:SetHeight(ReadyCheckListenerFrame:GetHeight() * self.FyMult)
	self:moveObject(ReadyCheckFrameText, "-", 12, "+", 10)
	self:moveObject(ReadyCheckFrameYesButton, "-", 15, "-", 5)
	self:storeAndSkin(ftype, ReadyCheckListenerFrame)

end

function Skinner:Buffs()
	if not self.db.profile.Buffs or self.initialized.Buffs then return end
	self.initialized.Buffs = true

	local function skinBuffs()

		for i= 1, BUFF_MAX_DISPLAY do
			local bb = _G["BuffButton"..i]
			if bb and not Skinner.skinned[bb] then
				Skinner:addSkinButton(bb)
				Skinner:moveObject(_G["BuffButton"..i.."Duration"], nil, nil, "-", 2)
			end
		end
		for i= 1, DEBUFF_MAX_DISPLAY do
			local db = _G["DebuffButton"..i]
			if db and not Skinner.skinned[db] then
				Skinner:addSkinButton(db)
				Skinner:moveObject(_G["DebuffButton"..i.."Duration"], nil, nil, "-", 2)
				Skinner.sBut[db]:ClearAllPoints()
				Skinner.sBut[db]:SetPoint("TOPLEFT", db, "TOPLEFT", -6, 6)
				Skinner.sBut[db]:SetPoint("BOTTOMRIGHT", db, "BOTTOMRIGHT", 6, -5)
			end
		end

	end

	skinBuffs()

	self:SecureHook("BuffFrame_Update", function()
		skinBuffs()
	end)

	-- skin Main and Off Hand Enchant buttons
	self:addSkinButton(TempEnchant1)
	self:addSkinButton(TempEnchant2)

end

function Skinner:VehicleMenuBar()
	if not self.db.profile.VehicleMenuBar or self.initialized.VehicleMenuBar then return end
	self.initialized.VehicleMenuBar = true

	local xOfs1, xOfs2, xOfs3
	local yOfs1 = 42
	local yOfs2 = -1
	local yOfs3, yOfs4
	
	local function skinVehicleMenuBar(pitchVisible, src)
	
--		Skinner:Debug("sVMB: [%s, %s]", pitchVisible, src)
		
		-- expand frame width if mechanical vehicle
		if pitchVisible then
			xOfs1 = 132
			xOfs2 = xOfs1 * -1
			xOfs3 = -338
			yOfs3 = 41
			yOfs4 = 23
		else
			xOfs1 = 160
			xOfs2 = xOfs1 * -1
			xOfs3 = -355
			yOfs3 = 44
			yOfs4 = 24
		end
	
		VehicleMenuBarArtFrame:DisableDrawLayer("BACKGROUND")
		VehicleMenuBarArtFrame:DisableDrawLayer("BORDER")
		VehicleMenuBarArtFrame:DisableDrawLayer("ARTWORK")
		VehicleMenuBarArtFrame:DisableDrawLayer("OVERLAY")
		VehicleMenuBarPitchSlider:SetFrameStrata("MEDIUM") -- make it appear above the skin frame
		CharacterMicroButton:ClearAllPoints()
		CharacterMicroButton:SetPoint("BOTTOMLEFT", VehicleMenuBar, "BOTTOMRIGHT", xOfs3, yOfs3)
		SocialsMicroButton:ClearAllPoints()
		SocialsMicroButton:SetPoint("TOPLEFT", CharacterMicroButton, "BOTTOMLEFT", 0, yOfs4)
		
		local yAdj = 7
		Skinner:moveObject(VehicleMenuBarPitchUpButton, nil, nil, "+", yAdj)
		Skinner:moveObject(VehicleMenuBarPitchDownButton, nil, nil, "+", yAdj)
		Skinner:moveObject(VehicleMenuBarLeaveButton, nil, nil, "+", yAdj)
		Skinner:moveObject(VehicleMenuBarPitchSlider, nil, nil, "+", yAdj - 2)
		
		local sf = Skinner.skinFrame[VehicleMenuBar]
		if not sf then
--			Skinner:Debug("Unskinned")
			Skinner:addSkinFrame(VehicleMenuBar, xOfs1, yOfs1, xOfs2, yOfs2)
		else
--			Skinner:Debug("Already Skinned")
			sf:ClearAllPoints()
			sf:SetPoint("TOPLEFT", VehicleMenuBar, "TOPLEFT", xOfs1, yOfs1)
			sf:SetPoint("BOTTOMRIGHT", VehicleMenuBar, "BOTTOMRIGHT", xOfs2, yOfs2)
		end
		
	end

    self:SecureHook(VehicleMenuBar, "Show", function(this, ...)
--        self:Debug("VehicleMenuBar_Show")
        skinVehicleMenuBar(nil, 1)
    end)

    self:SecureHook("VehicleMenuBar_SetSkin", function(skinName, pitchVisible)
--        self:Debug("VehicleMenuBar_SetSkin: [%s, %s]", skinName, pitchVisible)
        skinVehicleMenuBar(pitchVisible, 2)
    end)

	if VehicleMenuBar:IsShown() then skinVehicleMenuBar(nil, 3) end
	
end

function Skinner:WatchFrame()

	local function glazeWatchLines()
--		Skinner:Debug("gWL: [%s]", #WATCHFRAME_ACHIEVEMENTLINES)
		-- glaze Achievement StatusBars
		for i = 1, #WATCHFRAME_ACHIEVEMENTLINES do
			local sBar = WATCHFRAME_ACHIEVEMENTLINES[i].statusBar
			if not self.skinned[WATCHFRAME_ACHIEVEMENTLINES[i].statusBar] then
				Skinner:removeRegions(sBar, {3, 4, 5}) -- remove textures
				Skinner:glazeStatusBar(sBar, 0)
			end
		end
	end
	-- hook this to manage Tracked Achievements
	self:SecureHook("WatchFrame_Update", function(this)
--		self:Debug("WF_U: [%s]", this or "None")
		glazeWatchLines()
	end)
	-- glaze any existing lines
	glazeWatchLines()

	self:keepFontStrings(WatchFrame)
	if self.db.profile.TrackerFrame then
	    self:addSkinFrame(WatchFrame, 0, 0, 0, 0)
        -- set the alpha value to ensure it's always seen
    	WatchFrame:SetAlpha(1)
	    WatchFrame.baseAlpha = 1
    	SetCVar("watchFrameBaseAlpha", 1)
        -- make sure it's hidden/shown as required
		self:SecureHook("WatchFrame_Expand", function(this) Skinner.skinFrame[this]:Show() end)
		self:SecureHook("WatchFrame_Collapse", function(this) Skinner.skinFrame[this]:Hide() end)
        -- force the watch frame to resize
	    if WatchFrame.collapsed then
    		WatchFrame_Expand(WatchFrame)
    		WatchFrame_Collapse(WatchFrame)
    	else
    		WatchFrame_Collapse(WatchFrame)
    		WatchFrame_Expand(WatchFrame)
    	end
		-- 	add a texture to the resize buttons

--[[
		local line1 = sizer:CreateTexture(nil, "BACKGROUND")
		line1:SetWidth(14)
		line1:SetHeight(14)
		line1:SetPoint("BOTTOMRIGHT", -8, 8)
		line1:SetTexture("Interface\\Tooltips\\UI-Tooltip-Border")
		local x = 0.1 * 14/17
		line1:SetTexCoord(0.05 - x, 0.5, 0.05, 0.5 + x, 0.05, 0.5 - x, 0.5 + x, 0.5)

		local line2 = sizer:CreateTexture(nil, "BACKGROUND")
		line2:SetWidth(8)
		line2:SetHeight(8)
		line2:SetPoint("BOTTOMRIGHT", -8, 8)
		line2:SetTexture("Interface\\Tooltips\\UI-Tooltip-Border")
		local x = 0.1 * 8/17
		line2:SetTexCoord(0.05 - x, 0.5, 0.05, 0.5 + x, 0.05, 0.5 - x, 0.5 + x, 0.5)
--]]

	end

end

--[[
function Skinner:GearManager()

	self:moveObject(GearManagerToggleButton, nil, nil, "+", 20)

	self:keepFontStrings(GearManagerDialog)
	self:moveObject(GearManagerDialog, "+", 37, "-", 1)
	self:applySkin(GearManagerDialog)
-->>-- Popup frame
	self:keepFontStrings(GearManagerDialogPopup)
	self:keepFontStrings(GearManagerDialogPopupScrollFrame)
	self:skinScrollBar(GearManagerDialogPopupScrollFrame)
	self:skinEditBox(GearManagerDialogPopupEditBox, {9})
	self:applySkin(GearManagerDialogPopup)

end
--]]
