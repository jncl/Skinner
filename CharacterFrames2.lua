local ftype = "c"

function Skinner:FriendsFrame()
	if not self.db.profile.FriendsFrame or self.initialized.FriendsFrame then return end
	self.initialized.FriendsFrame = true

	-- hook this to manage textured tabs
	if self.isTT then
		self:SecureHook("FriendsFrame_ShowSubFrame", function(frameName)
--			self:Debug("FriendsFrame_ShowSubFrame: [%s, %s]", frameName, FriendsFrame.selectedTab)
			for i, v in pairs(FRIENDSFRAME_SUBFRAMES) do
--				self:Debug("FRIENDSFRAME_SUBFRAMES: [%s, %s]", i, v)
				-- handle Friends and Ignore on the same Tab
				local j = ( i > 1 and i - 1 or i)
				-- handle Friends, Ignore and Muted on the same Tab
				j = ( j > 1 and j - 1 or j)
--				self:Debug("FF_SF: [%s]", j)
				-- handle additional Tabs with altered names or numbers
				local prefix = (v == "BadapplesFrame" and "Badapples" or "")
				local tabId = (v == "BadapplesFrame" and 5 or j)
				local tabSF = self.skinFrame[_G[prefix.."FriendsFrameTab"..tabId]]
				-- ignore the IgnoreListFrame (also the MutedListFrame)
 				if v ~= "IgnoreListFrame" and v ~= "MutedListFrame" then
					self:setInactiveTab(tabSF)
				end
				if v == frameName then
					self:setActiveTab(tabSF)
				end
			end
		end)
	end
-->>--	Friends Frame
	self:keepFontStrings(FriendsFrame)
	self:skinFFToggleTabs("FriendsFrameToggleTab")
	self:removeRegions(FriendsFrameFriendsScrollFrame)
	self:skinScrollBar(FriendsFrameFriendsScrollFrame)
	self:moveObject(FriendsFrameAddFriendButton, nil, nil, "+", 1)
	self:addSkinFrame(FriendsFrame, 12, -12, -33, 71, ftype)
	
-->>--	Ignore Frame
	self:keepFontStrings(IgnoreListFrame)
	self:skinFFToggleTabs("IgnoreFrameToggleTab")
	self:removeRegions(FriendsFrameIgnoreScrollFrame)
	self:skinScrollBar(FriendsFrameIgnoreScrollFrame)
	self:moveObject(FriendsFrameIgnorePlayerButton, nil, nil, "+", 1)

-->>--	MutedList Frame
	self:keepFontStrings(MutedListFrame)
	self:skinFFToggleTabs("MutedFrameToggleTab")
	self:removeRegions(FriendsFrameMutedScrollFrame)
	self:skinScrollBar(FriendsFrameMutedScrollFrame)
	self:moveObject(FriendsFrameMutedPlayerButton, nil, nil, "+", 1)
	self:moveObject(FriendsFrameUnmuteButton, "+", 4)

-->>--	Who Frame
	self:skinFFColHeads("WhoFrameColumnHeader")
	self:skinDropDown(WhoFrameDropDown, nil, true)
	self:removeRegions(WhoListScrollFrame)
	self:skinScrollBar(WhoListScrollFrame)
	self:skinEditBox(WhoFrameEditBox, nil, nil, nil, nil, true)
	WhoFrameEditBox:SetWidth(WhoFrameEditBox:GetWidth() +  24)
	self:moveObject(WhoFrameEditBox, "+", 12)

-->>--	Guild Frame
	self:keepFontStrings(GuildFrameLFGFrame)
	self:skinFFColHeads("GuildFrameColumnHeader")
	self:skinFFColHeads("GuildFrameGuildStatusColumnHeader")
	self:removeRegions(GuildListScrollFrame)
	self:skinScrollBar(GuildListScrollFrame)
	-- Guild Control Popup Frame
	self:keepFontStrings(GuildControlPopupFrame)
	self:skinDropDown(GuildControlPopupFrameDropDown)
	self:skinEditBox(GuildControlPopupFrameEditBox, {9})
	self:skinEditBox(GuildControlWithdrawGoldEditBox, {9})
	self:skinEditBox(GuildControlWithdrawItemsEditBox, {9})
	self:storeAndSkin(ftype, GuildControlPopupFrameTabPermissions)
	self:addSkinFrame(GuildControlPopupFrame, 3, -6, -28, 25, ftype)
	for i = 1, MAX_GUILDBANK_TABS do
		local gbtpt = _G["GuildBankTabPermissionsTab"..i]
		self:keepFontStrings(gbtpt)
		self:addSkinFrame(gbtpt, 0, -6, 0, 0, ftype)
	end
-->>--	GuildInfo Frame
	self:keepFontStrings(GuildInfoFrame)
	self:removeRegions(GuildInfoFrameScrollFrame)
	self:skinScrollBar(GuildInfoFrameScrollFrame)
	self:storeAndSkin(ftype, GuildInfoTextBackground)
	self:storeAndSkin(ftype, GuildInfoFrame)
-->>--	GuildMemberDetail Frame
	self:keepFontStrings(GuildMemberDetailFrame)
	self:storeAndSkin(ftype, GuildMemberNoteBackground)
	self:storeAndSkin(ftype, GuildMemberOfficerNoteBackground)
	self:storeAndSkin(ftype, GuildMemberDetailFrame)
-->>--	GuildEventLog Frame
	self:keepFontStrings(GuildEventLogFrame)
	self:storeAndSkin(ftype, GuildEventFrame)
	self:removeRegions(GuildEventLogScrollFrame)
	self:skinScrollBar(GuildEventLogScrollFrame)
	self:storeAndSkin(ftype, GuildEventLogFrame)
-->>--	Channel Frame
	self:keepFontStrings(ChannelFrame)
	-- hook this to skin channel buttons
	self:SecureHook("ChannelList_Update", function()
		for i = 1, MAX_CHANNEL_BUTTONS do
			local cbnt = _G["ChannelButton"..i.."NormalTexture"]
			cbnt:SetAlpha(0)
		end
	end)
	ChannelFrameVerticalBar:Hide()
	self:removeRegions(ChannelListScrollFrame)
	self:skinScrollBar(ChannelListScrollFrame)
	self:removeRegions(ChannelRosterScrollFrame)
	self:skinScrollBar(ChannelRosterScrollFrame)
	-- Channel Pullout Tab & Frame
	self:keepRegions(ChannelPulloutTab, {4, 5}) -- N.B. region 4 is text, 5 is highlight
	self:storeAndSkin(ftype, ChannelPulloutTab)
	self:storeAndSkin(ftype, ChannelPullout)
-->>--	Daughter Frame
	self:keepFontStrings(ChannelFrameDaughterFrame)
	self:storeAndSkin(ftype, ChannelFrameDaughterFrame)
	self:skinEditBox(ChannelFrameDaughterFrameChannelName, {9}, nil, nil, nil, true)
	self:skinEditBox(ChannelFrameDaughterFrameChannelPassword, {9, 10}, nil, nil, nil, true) -- N.B. regions 9 & 10 are text
	self:skinDropDown(ChannelListDropDown)
	self:skinDropDown(ChannelRosterDropDown)

-->>--	Raid Frame
	self:moveObject(RaidFrameConvertToRaidButton, "-", 50)
	self:moveObject(RaidFrameRaidInfoButton, "+", 50)

	if IsAddOnLoaded("Blizzard_RaidUI") then self:RaidUI() end

-->>--	RaidInfo Frame
	self:keepFontStrings(RaidInfoFrame)
	self:removeRegions(RaidInfoScrollFrame)
	self:skinScrollBar(RaidInfoScrollFrame)
	RaidInfoFrame:SetBackdrop(nil)
	self:addSkinFrame(RaidInfoFrame, 10, -6, -5, 0, ftype)

-->>--	Frame Tabs
	for i = 1, FriendsFrame.numTabs do
		local tabName = _G["FriendsFrameTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		self:addSkinFrame(tabName, 6, 0, -6, 2, ftype, self.isTT)
		local tabSF = self.skinFrame[tabName]
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end

end

function Skinner:TradeSkillUI()
	if not self.db.profile.TradeSkillUI or self.initialized.TradeSkillUI then return end
	self.initialized.TradeSkillUI = true

	-- if DoubleWideTradeSkills is loaded then use it's skin for the TradeSkillFrame
	if IsAddOnLoaded("DoubleWideTradeSkills") then return end

	self:keepFontStrings(TradeSkillFrame)
	TradeSkillRankFrameBorder:SetAlpha(0)
	self:glazeStatusBar(TradeSkillRankFrame, 0)
	self:moveObject(TradeSkillRankFrame, "-", 30)
	self:moveObject(TradeSkillFrameAvailableFilterCheckButton, "-", 28)
	self:skinEditBox(TradeSkillFrameEditBox, {9})
	self:removeRegions(TradeSkillExpandButtonFrame)
	self:skinDropDown(TradeSkillSubClassDropDown)
	self:skinDropDown(TradeSkillInvSlotDropDown)
	self:removeRegions(TradeSkillListScrollFrame)
	self:skinScrollBar(TradeSkillListScrollFrame)
	self:removeRegions(TradeSkillDetailScrollFrame)
	self:skinScrollBar(TradeSkillDetailScrollFrame)
	self:skinEditBox(TradeSkillInputBox)
	self:moveObject(TradeSkillInputBox, "-", 5)
	self:addSkinFrame(TradeSkillFrame, 10, -12, -32, 71, ftype)

end

function Skinner:TradeFrame()
	if not self.db.profile.TradeFrame or self.initialized.TradeFrame then return end
	self.initialized.TradeFrame = true

	self:keepFontStrings(TradeFrame)
	self:skinMoneyFrame(TradePlayerInputMoneyFrame)
	self:addSkinFrame(TradeFrame, 10, -11, -28, 48, ftype)

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
	self:keepFontStrings(QuestLogCount)

	self:removeRegions(QuestLogCollapseAllButton, {7, 8, 9})
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
	self:addSkinFrame(QuestLogFrame, 10, -12, -33, 48, ftype)

end

function Skinner:RaidUI()
	if not self.db.profile.RaidUI or self.initialized.RaidUI then return end
	self.initialized.RaidUI = true

	self:moveObject(RaidFrameAddMemberButton, "-", 30)
	self:moveObject(RaidGroup1, "+", 3)

	for i = 1, MAX_RAID_CLASS_BUTTONS do
		local tabName = _G["RaidClassButton"..i]
		self:removeRegions(tabName, {1}) -- N.B. region 2 is the icon, 3 is the text
	end
	-- hook this to skin the pullout class frames
	self:SecureHook("RaidPullout_GetFrame", function(filterID)
		for i = 1, NUM_RAID_PULLOUT_FRAMES 	do
			local rp = _G["RaidPullout"..i]
			if not self.skinFrame[rp] then
				self:skinDropDown(_G["RaidPullout"..i.."DropDown"])
				_G["RaidPullout"..i.."MenuBackdrop"]:SetBackdrop(nil)
				self:addSkinFrame(rp, nil, nil, nil, nil, ftype)
			end
		end
	end)
	-- hook this to skin the pullout group frames
	self:SecureHook("RaidPullout_Update", function(pullOutFrame)
		local pfName = pullOutFrame:GetName()
		self:Debug("RP_U: [%s, %s]", pullOutFrame, pfName)
		for i = 1, pullOutFrame.numPulloutButtons do
			local pfB = _G[pfName.."Button"..i]
			if not self.skinFrame[pfB] then
				self:glazeStatusBar(_G[pfName.."Button"..i.."HealthBar"], 0)
				self:glazeStatusBar(_G[pfName.."Button"..i.."ManaBar"], 0)
				self:glazeStatusBar(_G[pfName.."Button"..i.."Target"], 0)
				self:glazeStatusBar(_G[pfName.."Button"..i.."TargetTarget"], 0)
				_G[pfName.."Button"..i.."TargetTargetFrame"]:SetBackdrop(nil)
				self:addSkinFrame(pfB, nil, nil, nil, nil, ftype)
			end
		end
	end)
	

end

function Skinner:ReadyCheck()
	if not self.db.profile.ReadyCheck or self.initialized.ReadyCheck then return end
	self.initialized.ReadyCheck = true

-->>--	Ready Check Frame
	self:keepFontStrings(ReadyCheckListenerFrame)
	self:addSkinFrame(ReadyCheckListenerFrame, nil, nil, nil, nil, ftype)
	
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
--	    self:addSkinFrame(WatchFrame, 10, -2, -1, WatchFrame:GetHeight() + 30, ftype) -- link to WatchFrame to skin the Header only
	    self:addSkinFrame(WatchFrameLines, -10, 4, 10, 0, ftype)
		self:SecureHook(WatchFrameLines, "Show", function(this) Skinner.skinFrame[this]:Show() end)
		self:SecureHook(WatchFrameLines, "Hide", function(this) Skinner.skinFrame[this]:Hide() end)
		
		-- track watchframe alpha change (CVAR) as per nameplates code
		
		-- fade skinframe in/out with watchframe - use generic function in UIParent.lua
		-- or hook the fadein/fadeout functions and replicate them for the skinFrame
		
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
