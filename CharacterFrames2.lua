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

	self:removeRegions(FriendsFrameFriendsScrollFrame)
	self:moveObject(FriendsFrameFriendsScrollFrame, "+", 35, "+", 14)
	self:skinScrollBar(FriendsFrameFriendsScrollFrame)

-->>--	Ignore Frame
	self:keepFontStrings(IgnoreListFrame)

	IgnoreListFrame:SetWidth(IgnoreListFrame:GetWidth() * self.FxMult)
	IgnoreListFrame:SetHeight(IgnoreListFrame:GetHeight() * self.FyMult)

	self:skinFFToggleTabs("IgnoreFrameToggleTab") --N.B. Prefix string

	self:moveObject(FriendsFrameIgnorePlayerButton, "-", 9, "-", 70)
	self:moveObject(FriendsFrameStopIgnoreButton, "+", 4, nil, nil)
	self:moveObject(FriendsFrameIgnoreButton1, nil, nil, "+", 15)

	self:removeRegions(FriendsFrameIgnoreScrollFrame)
	self:moveObject(FriendsFrameIgnoreScrollFrame, "+", 35, "+", 14)
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

-->>--	WhoFrame
	WhoFrame:SetWidth(WhoFrame:GetWidth() * self.FxMult)
	WhoFrame:SetHeight(WhoFrame:GetHeight() * self.FyMult)

	self:skinFFColHeads("WhoFrameColumnHeader") --N.B. Prefix string
	self:moveObject(WhoFrameColumnHeader1, "-", 6, "+", 25)

	self:skinDropDown(WhoFrameDropDown, nil, true)
	self:moveObject(WhoFrameDropDown, "+", 5, "+", 1)
	self:moveObject(WhoFrameButton1, nil, nil, "+", 15)

	self:removeRegions(WhoListScrollFrame)
	self:moveObject(WhoListScrollFrame, "+", 35, "+", 20)
	self:skinScrollBar(WhoListScrollFrame)

	self:moveObject(WhoFrameEditBox, "+", 20, "-", 65)
	WhoFrameEditBox:SetWidth(WhoFrameEditBox:GetWidth() + 30)
	self:skinEditBox(WhoFrameEditBox)

	self:moveObject(WhoFrameTotals, nil, nil, "-", 66)
	self:moveObject(WhoFrameGroupInviteButton, "+", 30, "-", 71)

-->>--	GuildFrame
	GuildFrame:SetWidth(GuildFrame:GetWidth() * self.FxMult)
	GuildFrame:SetHeight(GuildFrame:GetHeight() * self.FyMult)

	-- show offline members text and checkbox
	self:keepFontStrings(GuildFrameLFGFrame)
	self:moveObject(GuildFrameLFGButton, "+", 42, "+", 12)

	self:skinFFColHeads("GuildFrameColumnHeader") --N.B. Prefix string
	self:moveObject(GuildFrameColumnHeader1, "-", 6, "+", 25)
	self:skinFFColHeads("GuildFrameGuildStatusColumnHeader") --N.B. Prefix string
	self:moveObject(GuildFrameGuildStatusColumnHeader1, "-", 6, "+", 25)

	self:removeRegions(GuildListScrollFrame)
	self:moveObject(GuildListScrollFrame, "+", 35, "+", 20)
	self:skinScrollBar(GuildListScrollFrame)

	self:moveObject(GuildFrameTotals, nil, nil, "-", 46)
	self:moveObject(GuildFrameNotesLabel, "-", 8, "-", 8) -- MOTD
	self:moveObject(GuildFrameControlButton, "+", 30, "-", 71)

	-- Guild Control Popup Frame
	self:keepFontStrings(GuildControlPopupFrame)
	self:moveObject(GuildControlPopupFrame, "+", 36, nil, nil)
	self:moveObject(GuildControlPopupFrameCancelButton, "+", 20, "-", 26)
	self:skinDropDown(GuildControlPopupFrameDropDown)
	GuildControlPopupFrameEditBox:SetWidth(GuildControlPopupFrameEditBox:GetWidth() + 30)
	self:skinEditBox(GuildControlPopupFrameEditBox)
	self:skinEditBox(GuildControlWithdrawGoldEditBox, {9})
	self:skinEditBox(GuildControlWithdrawItemsEditBox, {9})
	self:moveObject(GuildControlPopupFrameTabPermissions, "+", 10, nil, nil)
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

-->>--	GuildInfoFrame
	self:keepFontStrings(GuildInfoFrame)
	self:moveObject(GuildInfoTitle, nil, nil, "+", 3)

	self:removeRegions(GuildInfoFrameScrollFrame)
	self:skinScrollBar(GuildInfoFrameScrollFrame)

	self:storeAndSkin(ftype, GuildInfoTextBackground)
	self:storeAndSkin(ftype, GuildInfoFrame)

-->>--	GuildMemberDetailFrame
	self:keepFontStrings(GuildMemberDetailFrame)
	self:moveObject(GuildMemberDetailFrame, "+", 28, nil, nil)
	self:moveObject(GuildFramePromoteButton, nil, nil, "-", 30)
	self:storeAndSkin(ftype, GuildMemberNoteBackground)
	self:storeAndSkin(ftype, GuildMemberOfficerNoteBackground)
	self:storeAndSkin(ftype, GuildMemberDetailFrame)

-->>--	GuildEventLogFrame
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

-->>--	Daughter Frame
	self:keepFontStrings(ChannelFrameDaughterFrame)
	self:storeAndSkin(ftype, ChannelFrameDaughterFrame)
	self:skinEditBox(ChannelFrameDaughterFrameChannelName, {9})
	self:skinEditBox(ChannelFrameDaughterFrameChannelPassword, {9, 10}) -- N.B. regions 9 & 10 are text
	self:moveObject(ChannelFrameDaughterFrameVoiceChat, nil, nil, "+", 10)
	self:skinDropDown(ChannelListDropDown)
	self:skinDropDown(ChannelRosterDropDown)

-->>--	Raid Frame
	self:moveObject(RaidFrameConvertToRaidButton, "-", 30, "+", 10)

	if IsAddOnLoaded("Blizzard_RaidUI") then self:RaidUI() end

-->>--	RaidInfoFrame
	self:keepFontStrings(RaidInfoFrame)
	self:removeRegions(RaidInfoScrollFrame)
	self:moveObject(RaidInfoScrollFrame, "+", 5, nil, nil)
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
	if not self.db.profile.TradeSkill or self.initialized.TradeSkillUI then return end
	self.initialized.TradeSkillUI = true

	self:keepFontStrings(TradeSkillFrame)
	TradeSkillFrame:SetWidth(TradeSkillFrame:GetWidth() * self.FxMult)
	TradeSkillFrame:SetHeight(TradeSkillFrame:GetHeight() * self.FyMult)
	self:moveObject(TradeSkillFrameTitleText, nil, nil, "+", 12)
	self:moveObject(TradeSkillFrameCloseButton, "+", 28, "+", 8)
	self:moveObject(TradeSkillRankFrame, "-", 40, "+", 14)
	if not self.isWotLK then self:removeRegions(TradeSkillRankFrameBorder, {1})
	else TradeSkillRankFrameBorder:SetAlpha(0) end
	self:glazeStatusBar(TradeSkillRankFrame, 0)
	self:moveObject(TradeSkillFrameAvailableFilterCheckButton, "-", 38, "+", 12)
	self:skinEditBox(TradeSkillFrameEditBox, {9})
	self:removeRegions(TradeSkillExpandButtonFrame)
	self:moveObject(TradeSkillExpandButtonFrame, "-", 6, "+", 12)
	self:skinDropDown(TradeSkillSubClassDropDown)
	self:skinDropDown(TradeSkillInvSlotDropDown)
	self:moveObject(TradeSkillInvSlotDropDown, "+", 20, "+", 12)
	self:moveObject(TradeSkillSkill1, "-", 6, "+", 12)
	self:removeRegions(TradeSkillListScrollFrame)
	self:moveObject(TradeSkillListScrollFrame, "+", 35, "+", 12)
	self:skinScrollBar(TradeSkillListScrollFrame)
	self:removeRegions(TradeSkillDetailScrollFrame)
	self:moveObject(TradeSkillDetailScrollFrame, "+", 2, "+", 12)
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

function Skinner:CraftUI()
	if not self.db.profile.CraftFrame or self.initialized.CraftUI then return end
	self.initialized.CraftUI = true

	self:keepFontStrings(CraftFrame)
	CraftFrame:SetWidth(CraftFrame:GetWidth() * self.FxMult)
	CraftFrame:SetHeight(CraftFrame:GetHeight() * self.FyMult)
	self:moveObject(CraftFrameTitleText, nil, nil, "+", 12)
	self:moveObject(CraftFrameCloseButton, "+", 28, "+", 8)
	self:moveObject(CraftFrameIsMakeableText, nil, nil, "+", 15)
	self:skinDropDown(CraftFrameFilterDropDown)
	self:moveObject(CraftFrameFilterDropDown, nil, nil, "+", 15)
	self:moveObject(CraftRankFrame, "-", 40, "+", 14)
	self:removeRegions(CraftRankFrameBorder, {1})
	self:glazeStatusBar(CraftRankFrame, 0)
	self:moveObject(CraftFrameAvailableFilterCheckButton, "-", 38, "+", 12)
	self:skinEditBox(CraftFrameEditBox, {9})
	self:removeRegions(CraftExpandButtonFrame)
	self:moveObject(Craft1, nil, nil, "+", 20)
	self:removeRegions(CraftListScrollFrame)
	self:moveObject(CraftListScrollFrame, "+", 35, "+", 20)
	self:skinScrollBar(CraftListScrollFrame)
	self:removeRegions(CraftDetailScrollFrame)
	self:moveObject(CraftDetailScrollFrame, "-", 4, "+", 10)
	self:skinScrollBar(CraftDetailScrollFrame)
	self:moveObject(CraftCreateButton, "-", 10, "-", 5)
	self:moveObject(CraftCancelButton, "-", 10, "-", 5)
	for i = 1, 8 do
		self:moveObject(_G["CraftReagent"..i.."Count"], "+", 4, nil, nil)
	end
	self:storeAndSkin(ftype, CraftFrame)

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
	self:keepRegions(QuestLogCollapseAllButton, {4, 6}) -- N.B. region 4 is button, 6 is text
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

function Skinner:RaidUI()
	if not self.db.profile.RaidUI or self.initialized.RaidUI then return end
	self.initialized.RaidUI = true

	self:moveObject(RaidFrameAddMemberButton, "-", 40, "+", 10)
	self:moveObject(RaidGroup1, "-", 7, "+", 8)
	for i = 1, 12 do
		local tabName = _G["RaidClassButton"..i]
		self:removeRegions(tabName, {1}) -- N.B. region 2 is the icon, 3 is the text
		-- Move the last entry as all the others are positioned from it
		if i == 12 then self:moveObject(tabName, "+", 31, "-", 70) end
	end

	self:SecureHook("RaidPullout_GetFrame", function(filterID)
		for i = 1, NUM_RAID_PULLOUT_FRAMES 	do
			local pulloutButton = _G["RaidPullout"..i]
			if not pulloutButton.skinned then
				self:storeAndSkin(ftype, pulloutButton)
				pulloutButton.skinned = true
			end
		end
	end)

end

function Skinner:ReadyCheck()
	if not self.db.profile.ReadyCheck or self.initialized.ReadyCheck then return end
	self.initialized.ReadyCheck = true

-->>--	Ready Check Frame
	self:keepFontStrings(ReadyCheckFrame)
	ReadyCheckFrame:SetWidth(ReadyCheckFrame:GetWidth() * self.FxMult)
	ReadyCheckFrame:SetHeight(ReadyCheckFrame:GetHeight() * self.FyMult)
	self:moveObject(ReadyCheckFrameText, "-", 12, "+", 10)
	self:moveObject(ReadyCheckFrameYesButton, "-", 15, "-", 5)
	self:storeAndSkin(ftype, ReadyCheckFrame)

end

function Skinner:Buffs()
	if not self.db.profile.Buffs or self.initialized.Buffs then return end
	self.initialized.Buffs = true

	local function skinBuffs()

		for i= 1, BUFF_MAX_DISPLAY do
			local bb = _G["BuffButton"..i]
			if bb and not bb.skinned then
				Skinner:addSkinButton(bb)
				Skinner:moveObject(_G["BuffButton"..i.."Duration"], nil, nil, "-", 2)
				bb.skinned = true
			end
		end
		for i= 1, DEBUFF_MAX_DISPLAY do
			local db = _G["DebuffButton"..i]
			if db and not db.skinned then
				Skinner:addSkinButton(db)
				Skinner:moveObject(_G["DebuffButton"..i.."Duration"], nil, nil, "-", 2)
				db.sBut:ClearAllPoints()
				db.sBut:SetPoint("TOPLEFT", db, "TOPLEFT", -6, 6)
				db.sBut:SetPoint("BOTTOMRIGHT", db, "BOTTOMRIGHT", 6, -5)
				db.skinned = true
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
