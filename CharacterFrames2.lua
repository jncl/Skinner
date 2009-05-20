local _G = _G
local ftype = "c"

function Skinner:FriendsFrame()
	if not self.db.profile.FriendsFrame or self.initialized.FriendsFrame then return end
	self.initialized.FriendsFrame = true

	-- hook this to manage textured tabs
	if self.isTT then
		self:SecureHook("FriendsFrame_ShowSubFrame", function(frameName)
			for i, v in pairs(FRIENDSFRAME_SUBFRAMES) do
				-- handle Friends and Ignore on the same Tab
				local j = ( i > 1 and i - 1 or i)
				-- handle Friends, Ignore and Muted on the same Tab
				j = ( j > 1 and j - 1 or j)
				-- handle additional Tabs with altered names or numbers
				local prefix = (v == "BadapplesFrame" and "Badapples" or "")
				local tabId = (v == "BadapplesFrame" and 6 or j)
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
	self:skinFFToggleTabs("FriendsFrameToggleTab")
self:skinScrollBar{obj=FriendsFrameFriendsScrollFrame}
	self:moveObject{obj=FriendsFrameAddFriendButton, y=1}
	self:addSkinFrame{obj=FriendsFrame, ft=ftype, kfs=true, x1=12, y1=-11, x2=-33, y2=71}

-->>--	Ignore Frame
	self:keepFontStrings(IgnoreListFrame)
	self:skinFFToggleTabs("IgnoreFrameToggleTab")
	self:skinScrollBar{obj=FriendsFrameIgnoreScrollFrame}
	self:moveObject{obj=FriendsFrameIgnorePlayerButton, y=1}

-->>--	MutedList Frame
	self:keepFontStrings(MutedListFrame)
	self:skinFFToggleTabs("MutedFrameToggleTab")
	self:skinScrollBar{obj=FriendsFrameMutedScrollFrame}
	self:moveObject{obj=FriendsFrameMutedPlayerButton, y=1}
	self:moveObject{obj=FriendsFrameUnmuteButton, x=4}

-->>--	Who Frame
	self:skinFFColHeads("WhoFrameColumnHeader")
	self:skinDropDown{obj=WhoFrameDropDown, noSkin=true}
	self:moveObject{obj=WhoFrameDropDownButton, x=5, y=1}
	self:skinScrollBar{obj=WhoListScrollFrame}
	self:skinEditBox{obj=WhoFrameEditBox, move=true}
	WhoFrameEditBox:SetWidth(WhoFrameEditBox:GetWidth() +  24)
	self:moveObject{obj=WhoFrameEditBox, x=12}

-->>--	Guild Frame
	self:keepFontStrings(GuildFrameLFGFrame)
	self:skinFFColHeads("GuildFrameColumnHeader")
	self:skinFFColHeads("GuildFrameGuildStatusColumnHeader")
	self:skinScrollBar{obj=GuildListScrollFrame}
	-- Guild Control Popup Frame
	self:skinDropDown{obj=GuildControlPopupFrameDropDown}
	self:skinEditBox{obj=GuildControlPopupFrameEditBox, regs={9}}
	self:skinEditBox{obj=GuildControlWithdrawGoldEditBox, regs={9}}
	self:skinEditBox{obj=GuildControlWithdrawItemsEditBox, regs={9}}
	self:addSkinFrame{obj=GuildControlPopupFrameTabPermissions, ft=ftype}
	self:addSkinFrame{obj=GuildControlPopupFrame, ft=ftype, kfs=true, x1=3, y1=-6, x2=-28, y2=25}

	for i = 1, MAX_GUILDBANK_TABS do
		local gbtpt = _G["GuildBankTabPermissionsTab"..i]
		self:addSkinFrame{obj=gbtpt, ft=ftype, kfs=true, y1=-8}
	end
-->>--	GuildInfo Frame
	self:skinScrollBar{obj=GuildInfoFrameScrollFrame}
	self:addSkinFrame{obj=GuildInfoTextBackground, ft=ftype}
	self:addSkinFrame{obj=GuildInfoFrame, ft=ftype, kfs=true}
-->>--	GuildMemberDetail Frame
	self:keepFontStrings(GuildMemberDetailFrame)
	self:addSkinFrame{obj=GuildMemberNoteBackground, ft=ftype}
	self:addSkinFrame{obj=GuildMemberOfficerNoteBackground, ft=ftype}
	self:addSkinFrame{obj=GuildMemberDetailFrame, ft=ftype}
-->>--	GuildEventLog Frame
	self:addSkinFrame{obj=GuildEventFrame, ft=ftype}
	self:skinScrollBar{obj=GuildEventLogScrollFrame}
	self:addSkinFrame{obj=GuildEventLogFrame, ft=ftype, kfs=true}
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
	self:skinScrollBar{obj=ChannelListScrollFrame}
	self:skinScrollBar{obj=ChannelRosterScrollFrame}
	-- Channel Pullout Tab & Frame
	self:keepRegions(ChannelPulloutTab, {4, 5}) -- N.B. region 4 is text, 5 is highlight
	self:addSkinFrame{obj=ChannelPulloutTab, ft=ftype}
	self:addSkinFrame{obj=ChannelPullout, ft=ftype}
-->>--	Daughter Frame
	self:addSkinFrame{obj=ChannelFrameDaughterFrame, ft=ftype, kfs=true}
	self:skinEditBox{obj=ChannelFrameDaughterFrameChannelName, regs={9}, move=true}
	self:skinEditBox{obj=ChannelFrameDaughterFrameChannelPassword, regs={9, 10}, move=true} -- N.B. regions 9 & 10 are text
	self:skinDropDown{obj=ChannelListDropDown}
	self:skinDropDown{obj=ChannelRosterDropDown}

-->>--	Raid Frame
	self:moveObject{obj=RaidFrameConvertToRaidButton, x=-50}
	self:moveObject{obj=RaidFrameRaidInfoButton, x=50}

	if IsAddOnLoaded("Blizzard_RaidUI") then self:RaidUI() end

-->>--	RaidInfo Frame
	self:skinScrollBar{obj=RaidInfoScrollFrame}
	self:addSkinFrame{obj=RaidInfoFrame, ft=ftype, kfs=true, x1=10, y1=-6, x2=-5}

-->>--	Frame Tabs
	for i = 1, FriendsFrame.numTabs do
		local tabName = _G["FriendsFrameTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		self:addSkinFrame{obj=tabName, ft=ftype, noBdr=self.isTT, x1=6, x2=-6, y2=2}
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

	TradeSkillRankFrameBorder:SetAlpha(0)
	self:glazeStatusBar(TradeSkillRankFrame, 0)
	self:skinEditBox{obj=TradeSkillFrameEditBox, regs={9}}
	self:removeRegions(TradeSkillExpandButtonFrame)
	self:skinDropDown{obj=TradeSkillSubClassDropDown}
	self:skinDropDown{obj=TradeSkillInvSlotDropDown}
	self:skinScrollBar{obj=TradeSkillListScrollFrame}
	self:skinScrollBar{obj=TradeSkillDetailScrollFrame}
	self:skinEditBox{obj=TradeSkillInputBox}
	self:moveObject{obj=TradeSkillInputBox, x=-5}
	self:addSkinFrame{obj=TradeSkillFrame, ft=ftype, kfs=true, x1=10, y1=-11, x2=-32, y2=71}

end

function Skinner:TradeFrame()
	if not self.db.profile.TradeFrame or self.initialized.TradeFrame then return end
	self.initialized.TradeFrame = true

	self:skinMoneyFrame{obj=TradePlayerInputMoneyFrame}
	self:addSkinFrame{obj=TradeFrame, ft=ftype, kfs=true, x1=10, y1=-11, x2=-28, y2=48}

end

function Skinner:QuestLog()
	if not self.db.profile.QuestLog.skin or self.initialized.QuestLog then return end
	self.initialized.QuestLog = true

	self:SecureHook("QuestLog_UpdateQuestDetails", function(doNotScroll)
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

	self:skinScrollBar{obj=QuestLogListScrollFrame}
	self:skinScrollBar{obj=QuestLogDetailScrollFrame}
	self:addSkinFrame{obj=QuestLogFrame, ft=ftype, kfs=true, x1=10, y1=-11, x2=-33, y2=48}

end

function Skinner:RaidUI()
	if not self.db.profile.RaidUI or self.initialized.RaidUI then return end
	self.initialized.RaidUI = true

	self:moveObject{obj=RaidFrameAddMemberButton, x=-30}
	self:moveObject{obj=RaidGroup1,x= 2}

	-- Raid Groups
	for i = 1, MAX_RAID_GROUPS do
		local rGrp = _G["RaidGroup"..i]
		self:addSkinFrame{obj=rGrp, ft=ftype, kfs=true}
	end
	-- Raid Group Buttons
	-- FIXME need to use a smaller edged backdrop
	for i = 1, MAX_RAID_GROUPS * 5 do
		local rgBtn = _G["RaidGroupButton"..i]
		self:removeRegions(rgBtn, {4})
		self:addSkinFrame{obj=rgBtn, ft=ftype, y1=1, y2=-3}
	end
	-- Raid Class Tabs (side)
	for i = 1, MAX_RAID_CLASS_BUTTONS do
		local tabName = _G["RaidClassButton"..i]
		self:removeRegions(tabName, {1}) -- N.B. region 2 is the icon, 3 is the text
	end
	-- hook this to skin the pullout group frames
	self:SecureHook("RaidPullout_GetFrame", function(filterID)
		for i = 1, NUM_RAID_PULLOUT_FRAMES 	do
			local rp = _G["RaidPullout"..i]
			if not self.skinFrame[rp] then
				self:skinDropDown{obj=_G["RaidPullout"..i.."DropDown"]}
				_G["RaidPullout"..i.."MenuBackdrop"]:SetBackdrop(nil)
				self:addSkinFrame{obj=rp, ft=ftype, kfs=true, x1=3, y1=-1, x2=-1, y2=1}
			end
		end
	end)
	-- hook this to skin the pullout character frames
	self:SecureHook("RaidPullout_Update", function(pullOutFrame)
		local pfName = pullOutFrame:GetName()
--		self:Debug("RP_U: [%s, %s]", pullOutFrame, pfName)
		for i = 1, pullOutFrame.numPulloutButtons do
			local pfBName = pfName.."Button"..i
			local pfBObj = _G[pfBName]
			if not self.skinFrame[pfBObj] then
				for _, v in pairs{"HealthBar", "ManaBar", "Target", "TargetTarget"} do
					local sBar = _G[pfBName..v]
					self:keepRegions(sBar, {3})
					self:glazeStatusBar(sBar, 0)
				end
				self:addSkinFrame{obj=_G[pfBName.."TargetTargetFrame"], ft=ftype, x1=4, x2=-4, y2=2}
				self:addSkinFrame{obj=pfBObj, ft=ftype, kfs=true, x1=-4, y1=-6, x2=4, y2=-6}
			end
		end
	end)


end

function Skinner:ReadyCheck()
	if not self.db.profile.ReadyCheck or self.initialized.ReadyCheck then return end
	self.initialized.ReadyCheck = true

-->>--	Ready Check Frame
	self:addSkinFrame{obj=ReadyCheckListenerFrame, ft=ftype, kfs=true}

end

function Skinner:Buffs()
	if not self.db.profile.Buffs or self.initialized.Buffs then return end
	self.initialized.Buffs = true

	local function skinBuffs()

		for i= 1, BUFF_MAX_DISPLAY do
			local bb = _G["BuffButton"..i]
			if bb and not Skinner.sBut[bb] then
				Skinner:addSkinButton{obj=bb}
				Skinner:moveObject{obj=_G["BuffButton"..i.."Duration"], y=-2}
			end
		end
		for i= 1, DEBUFF_MAX_DISPLAY do
			local db = _G["DebuffButton"..i]
			if db and not Skinner.sBut[db] then
				Skinner:addSkinButton{obj=db, x1=-5, y1=5, x2=5 ,y2=-5}
				Skinner:moveObject{obj=_G["DebuffButton"..i.."Duration"], y=-3}
			end
		end

	end

	self:SecureHook("BuffFrame_Update", function()
		skinBuffs()
	end)

	-- skin any urrent Buffs/Debuffs
	skinBuffs()

	-- skin Main and Off Hand Enchant buttons (Poisons/Oils etc)
	self:addSkinButton{obj=TempEnchant1}
	self:moveObject{obj=_G["TempEnchant1".."Duration"], y=-2}
	self:addSkinButton{obj=TempEnchant2}
	self:moveObject{obj=_G["TempEnchant2".."Duration"], y=-2}

end

function Skinner:VehicleMenuBar()
	if not self.db.profile.VehicleMenuBar or self.initialized.VehicleMenuBar then return end
	self.initialized.VehicleMenuBar = true

	local xOfs1, xOfs2
	local yOfs1 = 30
	local yOfs2 = -1

	local function skinVehicleMenuBar(opts)

--		Skinner:Debug("sVMB: [%s, %s, %s]", opts.pv, opts.src, opts.sn)

		-- expand frame width if mechanical vehicle
		if opts.pv then
			xOfs1 = 132
		else
			xOfs1 = 159
		end
		xOfs2 = xOfs1 * -1

		-- remove all textures
		VehicleMenuBarArtFrame:DisableDrawLayer("BACKGROUND")
		VehicleMenuBarArtFrame:DisableDrawLayer("BORDER")
		VehicleMenuBarArtFrame:DisableDrawLayer("ARTWORK")
		VehicleMenuBarArtFrame:DisableDrawLayer("OVERLAY")
		 -- make it appear above the skin frame
		VehicleMenuBarPitchSlider:SetFrameStrata("MEDIUM")
		-- move the Action Button Frame
		Skinner:moveObject{obj=VehicleMenuBarActionButtonFrame, y=-7}

		local sf = Skinner.skinFrame[VehicleMenuBar]
		if not sf then
			self:addSkinFrame{obj=VehicleMenuBar, ft=ftype, x1=xOfs1, y1=yOfs1, x2=xOfs2, y2=yOfs2}
		else
			sf:ClearAllPoints()
			sf:SetPoint("TOPLEFT", VehicleMenuBar, "TOPLEFT", xOfs1, yOfs1)
			sf:SetPoint("BOTTOMRIGHT", VehicleMenuBar, "BOTTOMRIGHT", xOfs2, yOfs2)
		end

	end

    self:SecureHook(VehicleMenuBar, "Show", function(this, ...)
        skinVehicleMenuBar{src=1}
    end)

    self:SecureHook("VehicleMenuBar_SetSkin", function(skinName, pitchVisible)
        skinVehicleMenuBar{pv=pitchVisible, src=2, sn=skinName}
    end)

	if VehicleMenuBar:IsShown() then skinVehicleMenuBar{src=3} end

end

function Skinner:WatchFrame()
	if not self.db.profile.TrackerFrame.skin
	and not self.db.profile.TrackerFrame.clean
	and not self.db.profile.TrackerFrame.glazesb then return end

	if self.db.profile.TrackerFrame.skin then
		self:addSkinFrame{obj=WatchFrameLines, ft=ftype, x1=-10, y1=4, x2=10}
		self:SecureHook(WatchFrameLines, "Show", function(this) Skinner.skinFrame[this]:Show() end)
		self:SecureHook(WatchFrameLines, "Hide", function(this) Skinner.skinFrame[this]:Hide() end)
	end

	if self.db.profile.TrackerFrame.clean then self:keepFontStrings(WatchFrame) end

	if self.db.profile.TrackerFrame.glazesb then
		local function glazeWatchLines()

			-- glaze Achievement StatusBars
			for i = 1, #WATCHFRAME_ACHIEVEMENTLINES do
				local sBar = WATCHFRAME_ACHIEVEMENTLINES[i].statusBar
				if not self.sbGlazed[sBar] then
					Skinner:removeRegions(sBar, {3, 4, 5}) -- remove textures
					Skinner:glazeStatusBar(sBar, 0)
				end
			end

		end

		-- hook this to manage the tracked Achievements
		self:SecureHook("WatchFrame_Update", function(this)
			glazeWatchLines()
		end)

		-- glaze any existing lines
		glazeWatchLines()
	end

end

function Skinner:GearManager()
	if not self.db.profile.GearManager then return end

	self:addSkinFrame{obj=GearManagerDialog, ft=ftype, kfs=true, x1=4, y1=-2, x2=-1, y2=2}
-->>-- Popup frame
	self:skinScrollBar{obj=GearManagerDialogPopupScrollFrame}
	self:skinEditBox{obj=GearManagerDialogPopupEditBox, regs={9}}
	self:addSkinFrame{obj=GearManagerDialogPopup, ft=ftype, kfs=true, x1=4, y1=-2, x2=-1, y2=3}

end
