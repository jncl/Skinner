local aName, aObj = ...
local _G = _G
local ftype = "c"
local obj, objName, tex, texName, btn, btnName, tab, tabSF

function aObj:FriendsFrame()
	if not self.db.profile.FriendsFrame or self.initialized.FriendsFrame then return end
	self.initialized.FriendsFrame = true

	self:add2Table(self.charKeys1, "FriendsFrame")

	self:skinTabs{obj=FriendsFrame, lod=true}
	self:addSkinFrame{obj=FriendsFrame, ft=ftype, kfs=true, ri=true, y1=2, x2=1, y2=-6}

	-- FriendsTabHeader Frame
	self:adjWidth{obj=_G["FriendsFrameStatusDropDownMiddle"], adj=4}
	FriendsFrameStatusDropDownStatus:SetAlpha(1) -- display status icon
	self:skinDropDown{obj=FriendsFrameStatusDropDown, x2=-16}
	self:skinEditBox{obj=FriendsFrameBroadcastInput, regs={9, 10}, mi=true, noWidth=true, noHeight=true, noMove=true} -- region 10 is icon
	FriendsFrameBroadcastInputFill:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:skinTabs{obj=FriendsTabHeader, up=true, lod=true, x1=0, y1=-5, x2=0, y2=-5}
	if self.modBtnBs then
		self:addButtonBorder{obj=FriendsTabHeaderSoRButton}
	end

	--	FriendsList Frame
	-- adjust width of FFFSF so it looks right (too thin by default)
	FriendsFrameFriendsScrollFrameScrollBar:SetPoint("BOTTOMLEFT", FriendsFrameFriendsScrollFrame, "BOTTOMRIGHT", -4, 14)
	self:skinScrollBar{obj=FriendsFrameFriendsScrollFrame}

	for i = 1, FRIENDS_FRIENDS_TO_DISPLAY do
		btn = _G["FriendsFrameFriendsScrollFrameButton"..i]
		btn.background:SetAlpha(0)
		self:addButtonBorder{obj=btn, relTo=btn.gameIcon, hide=true, ofs=0}
	end

	-- Friends Tooltip
	self:addSkinFrame{obj=FriendsTooltip}

-->>-- Add Friend Frame
	self:addSkinFrame{obj=AddFriendFrame, kfs=true}
	self:skinEditBox{obj=AddFriendNameEditBox, regs={9}}
	self:addSkinFrame{obj=AddFriendNoteFrame, kfs=true}
	self:skinScrollBar{obj=AddFriendNoteFrameScrollFrame}

-->>-- FriendsFriends Frame
	self:skinDropDown{obj=FriendsFriendsFrameDropDown}
	self:addSkinFrame{obj=FriendsFriendsList, ft=ftype}
	self:skinScrollBar{obj=FriendsFriendsScrollFrame}
	self:addSkinFrame{obj=FriendsFriendsNoteFrame, kfs=true, ft=ftype}
	self:addSkinFrame{obj=FriendsFriendsFrame, ft=ftype}

-->>--	IgnoreList Frame
	self:keepFontStrings(IgnoreListFrame)
	self:skinScrollBar{obj=FriendsFrameIgnoreScrollFrame}

-->>--	PendingList Frame
	self:keepFontStrings(PendingListFrame)
	self:skinDropDown{obj=PendingListFrameDropDown}
	self:skinSlider{obj=FriendsFramePendingScrollFrame.scrollBar}
	for i = 1, PENDING_INVITES_TO_DISPLAY do
		btn = "FriendsFramePendingButton"..i
		self:applySkin{obj=_G[btn]}
		self:applySkin{obj=_G[btn.."AcceptButton"]}
		self:applySkin{obj=_G[btn.."DeclineButton"]}
	end

-->>--	Who Tab Frame
	self:removeInset(WhoFrameListInset)
	self:removeInset(WhoFrameEditBoxInset)
	self:skinFFColHeads("WhoFrameColumnHeader")
	self:skinDropDown{obj=WhoFrameDropDown, noSkin=true}
	self:moveObject{obj=WhoFrameDropDownButton, x=5, y=1}
	self:skinScrollBar{obj=WhoListScrollFrame}
	self:skinEditBox{obj=WhoFrameEditBox, move=true}
	WhoFrameEditBox:SetWidth(WhoFrameEditBox:GetWidth() +  24)
	self:moveObject{obj=WhoFrameEditBox, x=12}

-->>--	Channel Tab Frame
	self:keepFontStrings(ChannelFrame)
	self:removeInset(ChannelFrameLeftInset)
	self:removeInset(ChannelFrameRightInset)
	self:skinButton{obj=ChannelFrameNewButton}
	-- hook this to skin channel buttons
	self:SecureHook("ChannelList_Update", function()
		for i = 1, MAX_CHANNEL_BUTTONS do
			_G["ChannelButton"..i.."NormalTexture"]:SetAlpha(0)
		end
	end)
	self:skinScrollBar{obj=ChannelListScrollFrame}
	self:skinScrollBar{obj=ChannelRosterScrollFrame}
	-- Channel Pullout Tab & Frame
	self:keepRegions(ChannelPulloutTab, {4, 5}) -- N.B. region 4 is text, 5 is highlight
	self:addSkinFrame{obj=ChannelPulloutTab, ft=ftype}
	self:addSkinFrame{obj=ChannelPullout, ft=ftype}
-->>--	Daughter Frame
	self:skinEditBox{obj=ChannelFrameDaughterFrameChannelName, regs={9}, noWidth=true}
	self:skinEditBox{obj=ChannelFrameDaughterFrameChannelPassword, regs={9, 10}, noWidth=true}
	self:moveObject{obj=ChannelFrameDaughterFrameOkayButton, x=-2}
	self:addSkinFrame{obj=ChannelFrameDaughterFrame, ft=ftype, kfs=true, x1=2, y1=-6, x2=-5}
	self:skinDropDown{obj=ChannelListDropDown}
	self:skinDropDown{obj=ChannelRosterDropDown}

-->>--	Raid Tab Frame
	self:moveObject{obj=RaidFrameConvertToRaidButton, x=-50}
	self:moveObject{obj=RaidFrameRaidInfoButton, x=50}

	if IsAddOnLoaded("Blizzard_RaidUI") then self:RaidUI() end

-->>--	RaidInfo Frame
	self:addSkinFrame{obj=RaidInfoInstanceLabel, kfs=true}
	self:addSkinFrame{obj=RaidInfoIDLabel, kfs=true}
	self:skinSlider{obj=RaidInfoScrollFrameScrollBar}
	self:addSkinFrame{obj=RaidInfoFrame, ft=ftype, kfs=true, hdr=true}

end

function aObj:TradeSkillUI() -- LoD
	if not self.db.profile.TradeSkillUI or self.initialized.TradeSkillUI then return end
	self.initialized.TradeSkillUI = true

	if self.modBtns then
		-- hook to manage changes to button textures
		self:SecureHook("TradeSkillFrame_Update", function()
			for i = 1, TRADE_SKILLS_DISPLAYED do
				self:checkTex(_G["TradeSkillSkill"..i])
			end
			self:checkTex(TradeSkillCollapseAllButton)
		end)
	end

	objName = "TradeSkillRankFrame"
	obj = _G[objName]
	_G[objName.."Border"]:SetAlpha(0)
	self:glazeStatusBar(obj, 0, _G[objName.."Background"])
	self:moveObject{obj=obj, x=-2}
	self:skinEditBox{obj=TradeSkillFrameSearchBox, regs={9}, mi=true, noHeight=true, noMove=true}
	self:skinButton{obj=TradeSkillFilterButton}
	self:addButtonBorder{obj=TradeSkillLinkButton, x1=1, y1=-5, x2=-3, y2=2}
	self:removeRegions(TradeSkillExpandButtonFrame)
	self:skinButton{obj=TradeSkillCollapseAllButton, mp=true}
	for i = 1, TRADE_SKILLS_DISPLAYED do
		self:skinButton{obj=_G["TradeSkillSkill"..i], mp=true}
	end
	self:skinScrollBar{obj=TradeSkillListScrollFrame}
	self:skinScrollBar{obj=TradeSkillDetailScrollFrame}
	self:keepFontStrings(TradeSkillDetailScrollChildFrame)
	self:addButtonBorder{obj=TradeSkillSkillIcon}
	self:skinEditBox{obj=TradeSkillInputBox, noHeight=true, x=-5}
	self:addSkinFrame{obj=TradeSkillFrame, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-5}
	self:removeMagicBtnTex(TradeSkillCreateAllButton)
	self:removeMagicBtnTex(TradeSkillCancelButton)
	self:removeMagicBtnTex(TradeSkillCreateButton)
	self:removeMagicBtnTex(TradeSkillViewGuildCraftersButton)
	-- Guild sub frame
	self:addSkinFrame{obj=TradeSkillGuildFrameContainer, ft=ftype}
	self:addSkinFrame{obj=TradeSkillGuildFrame, ft=ftype, kfs=true, ofs=-7}

	for i = 1, MAX_TRADE_SKILL_REAGENTS do
		_G["TradeSkillReagent"..i.."NameFrame"]:SetTexture(nil)
		self:addButtonBorder{obj=_G["TradeSkillReagent"..i], libt=true}
	end

	if self.modBtns then TradeSkillFrame_Update() end -- force update for button textures

end

function aObj:TradeFrame()
	if not self.db.profile.TradeFrame or self.initialized.TradeFrame then return end
	self.initialized.TradeFrame = true

	self:add2Table(self.charKeys1, "TradeFrame")

	for i = 1, MAX_TRADE_ITEMS do
		for _, v in pairs{"Player", "Recipient"} do
			btnName = "Trade"..v.."Item"..i
			_G[btnName.."SlotTexture"]:SetTexture(nil)
			_G[btnName.."NameFrame"]:SetTexture(nil)
			self:addButtonBorder{obj=_G[btnName.."ItemButton"], ibt=true}
		end
	end
	self:skinMoneyFrame{obj=TradePlayerInputMoneyFrame}
	self:addSkinFrame{obj=TradeFrame, ft=ftype, kfs=true, x1=10, y1=-11, x2=-28, y2=48}

end

function aObj:QuestLog()
	if not self.db.profile.QuestLog or self.initialized.QuestLog then return end
	self.initialized.QuestLog = true

	self:add2Table(self.charKeys1, "QuestLog")

	self:keepFontStrings(QuestLogCount)
	self:keepFontStrings(EmptyQuestLogFrame)

	if self.modBtns then
		local function qlUpd()

			for i = 1, #QuestLogScrollFrame.buttons do
				aObj:checkTex(QuestLogScrollFrame.buttons[i])
			end

		end
		-- hook to manage changes to button textures
		self:SecureHook("QuestLog_Update", function()
			qlUpd()
		end)
		-- hook this as well as it's a copy of QuestLog_Update
		self:SecureHook(QuestLogScrollFrame, "update", function()
			qlUpd()
		end)
		-- skin minus/plus buttons
		for i = 1, #QuestLogScrollFrame.buttons do
			self:skinButton{obj=QuestLogScrollFrame.buttons[i], mp=true}
		end
	end
	self:skinSlider{obj=QuestLogScrollFrame.scrollBar, adj=-4}
	self:skinAllButtons{obj=QuestLogControlPanel} -- Abandon/Push/Track
	self:addButtonBorder{obj=QuestLogFrameShowMapButton, relTo=QuestLogFrameShowMapButton.texture, x1=2, y1=-1, x2=-2, y2=1}
	self:addSkinFrame{obj=QuestLogFrame, ft=ftype, kfs=true, x1=10, y1=-11, x2=-1, y2=8}
	self:removeMagicBtnTex(QuestLogFrameCompleteButton)

-->>-- QuestLogDetail Frame
	QuestLogDetailTitleText:SetTextColor(self.HTr, self.HTg, self.HTb)
	self:skinScrollBar{obj=QuestLogDetailScrollFrame}
	self:addSkinFrame{obj=QuestLogDetailFrame, ft=ftype, kfs=true, x1=10, y1=-11, x2=1}

	self:QuestInfo()

end

function aObj:RaidUI() -- LoD
	if not self.db.profile.RaidUI or self.initialized.RaidUI then return end
	self.initialized.RaidUI = true

	local function skinPulloutFrames()

		local obj, objName
		for i = 1, NUM_RAID_PULLOUT_FRAMES	do
			objName = "RaidPullout"..i
			obj = _G[objName]
			if not self.skinFrame[obj] then
				self:skinDropDown{obj=_G[objName.."DropDown"]}
				_G[objName.."MenuBackdrop"]:SetBackdrop(nil)
				self:addSkinFrame{obj=obj, ft=ftype, kfs=true, x1=3, y1=-1, x2=-1, y2=1}
			end
		end

	end
	-- hook this to skin the pullout group frames
	self:SecureHook("RaidPullout_GetFrame", function(...)
		skinPulloutFrames()
	end)
	-- hook this to skin the pullout character frames
	self:SecureHook("RaidPullout_Update", function(pullOutFrame)
		local pfName = pullOutFrame:GetName()
		local objName, barName
		for i = 1, pullOutFrame.numPulloutButtons do
			objName = pfName.."Button"..i
			if not self.skinFrame[obj] then
				for _, v in pairs{"HealthBar", "ManaBar", "Target", "TargetTarget"} do
					barName = objName..v
					self:removeRegions(_G[barName], {2})
					self:glazeStatusBar(_G[barName], 0, _G[barName.."Background"])
				end
				self:addSkinFrame{obj=_G[objName.."TargetTargetFrame"], ft=ftype, x1=4, x2=-4, y2=2}
				self:addSkinFrame{obj=_G[objName], ft=ftype, kfs=true, x1=-4, y1=-6, x2=4, y2=-6}
			end
		end
	end)

	self:skinButton{obj=RaidFrameReadyCheckButton}
	self:moveObject{obj=RaidGroup1,x= 2}

	-- Raid Groups
	for i = 1, MAX_RAID_GROUPS do
		self:addSkinFrame{obj=_G["RaidGroup"..i], ft=ftype, kfs=true, x1=-2, y1=2, x2=1, y2=-1}
	end
	-- Raid Group Buttons
	for i = 1, MAX_RAID_GROUPS * 5 do
		btn = _G["RaidGroupButton"..i]
		self:removeRegions(btn, {4})
		self:addSkinFrame{obj=btn, ft=ftype, aso={bd=5}, x1=-2, y1=2, x2=1, y2=-1}
	end
	-- Raid Class Tabs (side)
	for i = 1, MAX_RAID_CLASS_BUTTONS do
		self:removeRegions(_G["RaidClassButton"..i], {1}) -- N.B. region 2 is the icon, 3 is the text
	end

	-- skin existing frames
	skinPulloutFrames()

end

function aObj:ReadyCheck()
	if not self.db.profile.ReadyCheck or self.initialized.ReadyCheck then return end
	self.initialized.ReadyCheck = true

	self:add2Table(self.charKeys1, "ReadyCheck")

	self:addSkinFrame{obj=ReadyCheckListenerFrame, ft=ftype, kfs=true}

end

function aObj:Buffs()
	if not self.db.profile.Buffs or self.initialized.Buffs then return end
	self.initialized.Buffs = true

	self:add2Table(self.charKeys1, "Buffs")

	if self.modBtnBs then
		local function skinBuffs()

			local btn
			for i= 1, BUFF_MAX_DISPLAY do
				btn = _G["BuffButton"..i]
				if btn and not btn.sknrBdr then
					-- add button borders
					aObj:addButtonBorder{obj=btn}
					self:moveObject{obj=btn.duration, y=-1}
				end
			end

		end
		-- hook this to skin new Buffs
		self:SecureHook("BuffFrame_Update", function()
			skinBuffs()
		end)
		-- skin any current Buffs/Debuffs
		skinBuffs()

	end

	-- Debuffs already have a coloured border
	-- Temp Enchants already have a coloured border

-->>-- Consolidated Buffs
	if self.modBtnBs then
		-- remove surrounding border & resize
		ConsolidatedBuffsIcon:SetTexCoord(0.128, 0.37, 0.235, 0.7375)
		ConsolidatedBuffsIcon:SetWidth(30)
		ConsolidatedBuffsIcon:SetHeight(30)
		self:addButtonBorder{obj=ConsolidatedBuffs}
	end
	self:addSkinFrame{obj=ConsolidatedBuffsTooltip, x1=4, y1=-3, x2=-5, y2=4}

end

function aObj:VehicleMenuBar()
	if not self.db.profile.VehicleMenuBar or self.initialized.VehicleMenuBar then return end
	self.initialized.VehicleMenuBar = true

	self:add2Table(self.charKeys1, "VehicleMenuBar")

	local xOfs1, xOfs2, yOfs1, yOfs2, sf
	local function skinVehicleMenuBar(opts)

		-- aObj:Debug("sVMB: [%s, %s, %s]", opts.src, opts.sn or "nil", opts.pv or "nil")

		-- expand frame width if mechanical vehicle
		if opts.sn == "Mechanical"
		or VehicleMenuBar.currSkin == "Mechanical"
		then
			xOfs1 = 132
			yOfs1 = 42
			yOfs2 = -1
		else
			-- "Natural" settings
			xOfs1 = 159
			yOfs1 = 46
			yOfs2 = -2
		end
		xOfs2 = xOfs1 * -1

		-- remove all textures
		VehicleMenuBarArtFrame:DisableDrawLayer("BACKGROUND")
		VehicleMenuBarArtFrame:DisableDrawLayer("BORDER")
		VehicleMenuBarArtFrame:DisableDrawLayer("ARTWORK")
		VehicleMenuBarArtFrame:DisableDrawLayer("OVERLAY")
		-- Pitch Slider
		self:moveObject{obj=VehicleMenuBarPitchSlider, y=2}
		VehicleMenuBarPitchSlider:DisableDrawLayer("OVERLAY")
		 -- make it appear above the skin frame
		VehicleMenuBarPitchSlider:SetFrameStrata("MEDIUM")

		if sf then
			sf:ClearAllPoints()
			sf:SetPoint("TOPLEFT", VehicleMenuBar, "TOPLEFT", xOfs1, yOfs1)
			sf:SetPoint("BOTTOMRIGHT", VehicleMenuBar, "BOTTOMRIGHT", xOfs2, yOfs2)
		else
			sf = aObj:addSkinFrame{obj=VehicleMenuBar, ft=ftype, x1=xOfs1, y1=yOfs1, x2=xOfs2, y2=yOfs2}
		end

	end

	self:SecureHook(VehicleMenuBar, "Show", function(this, ...)
		skinVehicleMenuBar{src=1}
	end)

	self:SecureHook("VehicleMenuBar_SetSkin", function(skinName, pitchVisible)
		skinVehicleMenuBar{src=2, sn=skinName, pv=pitchVisible}
	end)

	if VehicleMenuBar:IsShown() then skinVehicleMenuBar{src=3} end

	if self.modBtnBs then
		self:addButtonBorder{obj=VehicleMenuBarLeaveButton}
		for i = 1, VEHICLE_MAX_ACTIONBUTTONS do
			btn = _G["VehicleMenuBarActionButton"..i]
			self:addButtonBorder{obj=btn, abt=true, sec=true, es=20}
		end
	end

end

function aObj:WatchFrame()
	if not self.db.profile.WatchFrame.skin
	and not self.db.profile.WatchFrame.popups
	or self.initialized.WatchFrame
	then
		return
	end
	self.initialized.WatchFrame = true

	self:add2Table(self.charKeys2, "WatchFrame")

	if self.modBtnBs then
		local btn
		local function skinWFBtns()

			for i = 1, WATCHFRAME_NUM_ITEMS do
				btn = _G["WatchFrameItem"..i]
				if not btn.sknrBdr then
					aObj:addButtonBorder{obj=btn, ibt=true}
				end
			end

		end
		-- use hooksecurefunc as it may be hooked again if skinned
		hooksecurefunc("WatchFrame_Update", function(this)
			skinWFBtns()
		end)
		skinWFBtns() -- skin any existing buttons
	end

	if self.db.profile.WatchFrame.skin then
		self:addSkinFrame{obj=WatchFrameLines, ft=ftype, x1=-30, y1=4, x2=10}
		-- hook this to handle displaying of the WatchFrameLines skin frame
		self:SecureHook("WatchFrame_Update", function(this)
			if not WatchFrameHeader:IsShown() then
				self.skinFrame[WatchFrameLines]:Hide()
			else
				self.skinFrame[WatchFrameLines]:Show()
			end
		end)
	end
	if self.db.profile.WatchFrame.popups then
		local function skinAutoPopUps()

			local obj
			for i = 1, GetNumAutoQuestPopUps() do
				obj = _G["WatchFrameAutoQuestPopUp"..i] and _G["WatchFrameAutoQuestPopUp"..i].ScrollChild
				if obj and not aObj.skinned[obj] then
					for key, reg in ipairs{obj:GetRegions()} do
						if key < 11 or key == 17 then reg:SetTexture(nil) end -- Animated textures
					end
					aObj:applySkin{obj=obj}
				end
			end

		end
		WatchFrameLines.AutoQuestShadow:SetTexture(nil) -- Animated texture
		-- hook this to skin the AutoPopUps
		self:SecureHook("WatchFrameAutoQuest_GetOrCreateFrame", function(parent, index)
			skinAutoPopUps()
		end)
		skinAutoPopUps()
	end

end

function aObj:GearManager() -- inc. in PaperDollFrame.xml
	if not self.db.profile.GearManager or self.initialized.GearManager then return end
	self.initialized.GearManager = true

	self:add2Table(self.charKeys1, "GearManager")

	self:addSkinFrame{obj=GearManagerDialog, ft=ftype, kfs=true, x1=4, y1=-2, x2=-1, y2=2}
	for i = 1, MAX_EQUIPMENT_SETS_PER_PLAYER do
		btn = _G["GearSetButton"..i]
		if not self.modBtnBs then
			self:getRegion(btn, 2):SetTexture(self.esTex)
		else
			btn:DisableDrawLayer("BACKGROUND")
			self:addButtonBorder{obj=btn, relTo=btn.icon}
		end
	end
-->>-- Popup frame
	self:skinScrollBar{obj=GearManagerDialogPopupScrollFrame}
	self:skinEditBox{obj=GearManagerDialogPopupEditBox, regs={9}}
	self:addSkinFrame{obj=GearManagerDialogPopup, ft=ftype, kfs=true, x1=4, y1=-2, x2=-1, y2=3}

end

function aObj:CompactFrames()
	if not self.db.profile.CompactFrames or self.initialized.CompactFrames then return end
	self.initialized.CompactFrames = true

	self:add2Table(self.charKeys1, "CompactFrames")

	local function skinUnit(unit)

		-- handle in combat
		if InCombatLockdown() then
			aObj:add2Table(aObj.oocTab, {skinUnit, unit})
			return
		end

		unit:DisableDrawLayer("BACKGROUND")
		unit:DisableDrawLayer("BORDER")

	end
	local function skinGrp(grp)

		grp.borderFrame:SetAlpha(0)
		local grpName = grp:GetName()
		for i = 1, MEMBERS_PER_RAID_GROUP do
			skinUnit(_G[grpName.."Member"..i])
		end

	end

-->>-- Compact Party Frame
	self:SecureHook("CompactPartyFrame_OnLoad", function()
		self:addSkinFrame{obj=CompactPartyFrame, ft=ftype, x1=2, y1=-10, x2=-3, y2=3}
		self:Unhook("CompactPartyFrame_OnLoad")
	end)
	-- hook this to skin any new CompactRaidGroup(s)
	self:SecureHook("CompactRaidGroup_UpdateBorder", function(frame)
		skinGrp(frame)
	end)

-->>-- Compact RaidFrame Container
	-- hook this to skin any new CompactRaidFrameContainer entries
	self:SecureHook("FlowContainer_AddObject", function(container, object)
		if container.frameUpdateList
		and container.frameUpdateList.group
		and container.frameUpdateList.group[object] then
			skinGrp(object)
		else
			skinUnit(object)
		end
	end)
	-- skin any existing unit(s) [group, mini, normal]
	for type, frame in ipairs(CompactRaidFrameContainer.frameUpdateList) do
		if type == "group" then
			skinGrp(frame)
		else
			skinUnit(frame)
		end
	end

	self:addSkinFrame{obj=CompactRaidFrameContainer.borderFrame, ft=ftype, kfs=true, bg=true, y1=-1, x2=-5, y2=4}

-->>-- Compact RaidFrame Manager
	local function skinButton(btn)

		aObj:removeRegions(btn, {1, 2, 3})
		aObj:skinButton{obj=btn}

	end
	-- Buttons
	for _, v in pairs{"Tank", "Healer", "Damager"} do
		skinButton(CompactRaidFrameManager.displayFrame.filterOptions["filterRole"..v])
	end
	for i = 1, 8 do
		skinButton(CompactRaidFrameManager.displayFrame.filterOptions["filterGroup"..i])
	end
	CompactRaidFrameManager.displayFrame.filterOptions:DisableDrawLayer("BACKGROUND")
	self:skinDropDown{obj=CompactRaidFrameManager.displayFrame.profileSelector}
	skinButton(CompactRaidFrameManagerDisplayFrameLockedModeToggle)
	skinButton(CompactRaidFrameManagerDisplayFrameHiddenModeToggle)
	-- Leader Options
	skinButton(CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton)
	CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:GetNormalTexture():SetAlpha(1) -- icon
	skinButton(CompactRaidFrameManager.displayFrame.leaderOptions.readyCheckButton)
	skinButton(CompactRaidFrameManager.displayFrame.leaderOptions.rolePollButton)
	skinButton(CompactRaidFrameManager.displayFrame.convertToRaid)
	-- Display Frame
	self:keepFontStrings(CompactRaidFrameManager.displayFrame)
	-- Resize Frame
	self:addSkinFrame{obj=CompactRaidFrameManager.containerResizeFrame, ft=ftype, kfs=true, x1=-2, y1=-1, y2=4}
	-- Raid Frame Manager Frame
	self:addSkinFrame{obj=CompactRaidFrameManager, ft=ftype, kfs=true}

end

function aObj:ArchaeologyUI() -- LoD
	if not self.db.profile.ArchaeologyUI or self.initialized.ArchaeologyUI then return end
	self.initialized.ArchaeologyUI = true

	self:moveObject{obj=ArchaeologyFrame.infoButton, x=-25}
	self:skinDropDown{obj=ArchaeologyFrame.raceFilterDropDown}
	ArchaeologyFrameRankBarBackground:SetAllPoints(ArchaeologyFrame.rankBar)
	ArchaeologyFrameRankBarBorder:Hide()
	self:glazeStatusBar(ArchaeologyFrame.rankBar, 0,  ArchaeologyFrameRankBarBackground)
	self:addSkinFrame{obj=ArchaeologyFrame, ft=ftype, kfs=true, ri=true, x1=30, y1=2, x2=1}
-->>-- Summary Page
	self:keepFontStrings(ArchaeologyFrame.summaryPage) -- remove title textures
	ArchaeologyFrameSummaryPageTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
	for i = 1, ARCHAEOLOGY_MAX_RACES do
		ArchaeologyFrame.summaryPage["race"..i].raceName:SetTextColor(self.BTr, self.BTg, self.BTb)
	end
-->>-- Completed Page
	self:keepFontStrings(ArchaeologyFrame.completedPage) -- remove title textures
	ArchaeologyFrame.completedPage.infoText:SetTextColor(self.BTr, self.BTg, self.BTb)
	ArchaeologyFrame.completedPage.titleBig:SetTextColor(self.HTr, self.HTg, self.HTb)
	ArchaeologyFrame.completedPage.titleTop:SetTextColor(self.BTr, self.BTg, self.BTb)
	ArchaeologyFrame.completedPage.titleMid:SetTextColor(self.BTr, self.BTg, self.BTb)
	ArchaeologyFrame.completedPage.pageText:SetTextColor(self.BTr, self.BTg, self.BTb)
	for i = 1, ARCHAEOLOGY_MAX_COMPLETED_SHOWN do
		ArchaeologyFrame.completedPage["artifact"..i].artifactName:SetTextColor(self.HTr, self.HTg, self.HTb)
		ArchaeologyFrame.completedPage["artifact"..i].artifactSubText:SetTextColor(self.BTr, self.BTg, self.BTb)
		ArchaeologyFrame.completedPage["artifact"..i].border:Hide()
		_G["ArchaeologyFrameCompletedPageArtifact"..i.."Bg"]:Hide()
	end
-->>-- Artifact Page
	self:removeRegions(ArchaeologyFrame.artifactPage, {2, 3}) -- title textures
	ArchaeologyFrame.artifactPage:DisableDrawLayer("BACKGROUND")
	ArchaeologyFrame.artifactPage:DisableDrawLayer("BORDER")
	ArchaeologyFrame.artifactPage.historyTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
	ArchaeologyFrame.artifactPage.historyScroll.child.text:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:skinScrollBar{obj=ArchaeologyFrame.artifactPage.historyScroll}
	-- Solve Frame
	ArchaeologyFrameArtifactPageSolveFrameStatusBarBarBG:Hide()
	self:glazeStatusBar(ArchaeologyFrame.artifactPage.solveFrame.statusBar, 0, nil)
	ArchaeologyFrame.artifactPage.solveFrame.statusBar:SetStatusBarColor(0.75, 0.45, 0, 0.7)
-->>-- Help Page
	self:removeRegions(ArchaeologyFrame.helpPage, {2, 3}) -- title textures
	ArchaeologyFrame.helpPage.titleText:SetTextColor(self.HTr, self.HTg, self.HTb)
	ArchaeologyFrameHelpPageDigTex:SetTexCoord(0.05, 0.885, 0.055, 0.9) -- remove texture surrounds
	ArchaeologyFrameHelpPageDigTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
	ArchaeologyFrameHelpPageHelpScrollHelpText:SetTextColor(self.BTr, self.BTg, self.BTb)

end

function aObj:GuildUI() -- LoD
	if not self.db.profile.GuildUI or self.initialized.GuildUI then return end
	self.initialized.GuildUI = true

-->>-- Guild Frame
	self:removeInset(GuildFrameBottomInset)
	self:skinDropDown{obj=GuildDropDown}
	GuildLevelFrame:DisableDrawLayer("BACKGROUND")
	-- XP Bar
	GuildXPBar:DisableDrawLayer("BORDER")
	GuildXPBarProgress:SetTexture(self.sbTexture)
	GuildXPBarShadow:SetAlpha(0)
	GuildXPBarCap:SetTexture(self.sbTexture)
	GuildXPBarCapMarker:SetAlpha(0)
	-- Faction Bar
	GuildFactionBar:DisableDrawLayer("BORDER")
	GuildFactionBarProgress:SetTexture(self.sbTexture)
	GuildFactionBarShadow:SetAlpha(0)
	GuildFactionBarCap:SetTexture(self.sbTexture)
	GuildFactionBarCapMarker:SetAlpha(0)
	self:keepRegions(GuildFrame, {8, 19, 20, 18, 21, 22}) -- regions 8, 19, 20 are text, 18, 21 & 22 are tabard
	self:moveObject{obj=GuildFrameTabardBackground, x=6, y=-10}
	self:moveObject{obj=GuildFrameTabardEmblem, x=6, y=-10}
	self:moveObject{obj=GuildFrameTabardBorder, x=6, y=-10}
	self:skinTabs{obj=GuildFrame, lod=true}
	self:addSkinFrame{obj=GuildFrame, ft=ftype, ri=true, x1=-5, y1=2, x2=1, y2=-6}
	self:removeMagicBtnTex(GuildAddMemberButton)
	self:removeMagicBtnTex(GuildControlButton)
	self:removeMagicBtnTex(GuildViewLogButton)
	-- GuildMain Frame
	GuildPerksToggleButton:DisableDrawLayer("BACKGROUND")
	GuildNewPerksFrame:DisableDrawLayer("BACKGROUND")
	GuildUpdatesNoNews:SetTextColor(self.BTr, self.BTg, self.BTb)
	GuildUpdatesDivider:SetAlpha(0)
	GuildUpdatesNoEvents:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:removeRegions(GuildLatestPerkButton, {2, 5, 6}) -- region2 is NameFrame, 5-6 are borders
	self:addButtonBorder{obj=GuildLatestPerkButton, libt=true}
	GuildNextPerkButtonNameFrame:SetTexture(nil)
	self:addButtonBorder{obj=GuildNextPerkButton, libt=true, reParent={GuildNextPerkButtonLockTexture}}
	GuildAllPerksFrame:DisableDrawLayer("BACKGROUND")
	self:skinSlider{obj=GuildPerksContainer.ScrollBar, adj=-6}
	for i = 1, #GuildPerksContainer.buttons do
		-- can't use DisableDrawLayer as the update code uses it
		btn = GuildPerksContainer.buttons[i]
		self:removeRegions(btn, {1, 2, 3, 4, 5, 6})
		self:addButtonBorder{obj=btn, relTo=btn.icon, reParent={btn.lock}}
	end
	self:skinEditBox{obj=GuildNameChangeFrame.editBox, regs={9}}

-->>-- GuildRoster Frame
	self:skinDropDown{obj=GuildRosterViewDropdown}
	self:skinFFColHeads("GuildRosterColumnButton", 5)
	self:skinSlider{obj=GuildRosterContainerScrollBar, adj=-4}
	for i = 1, #GuildRosterContainer.buttons do
		btn = GuildRosterContainer.buttons[i]
		btn:DisableDrawLayer("BACKGROUND")
		btn.barTexture:SetTexture(self.sbTexture)
		btn.header.leftEdge:SetAlpha(0)
		btn.header.rightEdge:SetAlpha(0)
		btn.header.middle:SetAlpha(0)
		self:applySkin{obj=btn.header}
		self:addButtonBorder{obj=btn, relTo=btn.icon, hide=true, es=12}
	end
	self:skinDropDown{obj=GuildMemberRankDropdown}
	-- adjust text position & font so it overlays correctly
	self:moveObject{obj=GuildMemberRankDropdown, x=-6, y=2}
	GuildMemberRankDropdownText:SetFontObject(GameFontHighlight)
	self:addSkinFrame{obj=GuildMemberNoteBackground, ft=ftype}
	self:addSkinFrame{obj=GuildMemberOfficerNoteBackground, ft=ftype}
	self:addSkinFrame{obj=GuildMemberDetailFrame, ft=ftype, kfs=true, nb=true, ofs=-6}

-->>-- GuildNews Frame
	GuildNewsFrame:DisableDrawLayer("BACKGROUND")
	self:skinSlider{obj=GuildNewsContainerScrollBar, size=2}
	for i = 1, #GuildNewsContainer.buttons do
		GuildNewsContainer.buttons[i].header:SetAlpha(0)
	end
	self:skinDropDown{obj=GuildNewsDropDown}
	self:addSkinFrame{obj=GuildNewsFiltersFrame, ft=ftype, kfs=true, ofs=-7}
	self:keepFontStrings(GuildNewsBossModelTextFrame)
	self:addSkinFrame{obj=GuildNewsBossModel, ft=ftype, kfs=true, ofs=4, y2=-81} -- similar to QuestNPCModel
	-- Rewards Panel
	GuildRewardsFrame:DisableDrawLayer("BACKGROUND")
	self:skinSlider{obj=GuildRewardsContainerScrollBar, adj=-4}
	for i = 1, #GuildRewardsContainer.buttons do
		btn = GuildRewardsContainer.buttons[i]
		btn:GetNormalTexture():SetAlpha(0)
		btn.disabledBG:SetAlpha(0)
		self:addButtonBorder{obj=btn, relTo=btn.icon, reParent={btn.lock}}
	end
	self:skinDropDown{obj=GuildRewardsDropDown}

-->>-- GuildInfo Frame
	self:removeRegions(GuildInfoFrame, {1, 2, 3, 4, 5, 6 ,7, 8}) -- Background textures and bars
	self:skinTabs{obj=GuildInfoFrame, up=true, lod=true, x1=2, y1=-5, x2=2, y2=-5}
	-- GuildInfoFrameInfo Frame
	self:keepFontStrings(GuildInfoFrameInfo)
	self:skinSlider{obj=GuildInfoEventsContainerScrollBar, adj=-4}
	GuildInfoNoEvents:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:skinSlider{obj=GuildInfoDetailsFrameScrollBar, adj=-4}
	-- GuildInfoFrameRecruitment Frame
	GuildRecruitmentInterestFrameBg:SetAlpha(0)
	GuildRecruitmentAvailabilityFrameBg:SetAlpha(0)
	GuildRecruitmentRolesFrameBg:SetAlpha(0)
	GuildRecruitmentLevelFrameBg:SetAlpha(0)
	GuildRecruitmentCommentFrameBg:SetAlpha(0)
	self:skinSlider{obj=GuildRecruitmentCommentInputFrameScrollFrame.ScrollBar}
	GuildRecruitmentCommentEditBoxFill:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:addSkinFrame{obj=GuildRecruitmentCommentInputFrame, ft=ftype, kfs=true}
	self:removeMagicBtnTex(GuildRecruitmentListGuildButton)
	-- GuildInfoFrameApplicants Frame
	for i = 1, #GuildInfoFrameApplicantsContainer.buttons do
		btn = GuildInfoFrameApplicantsContainer.buttons[i]
		self:applySkin{obj=btn}
		btn.ring:SetAlpha(0)
		btn.PointsSpentBgGold:SetAlpha(0)
		self:moveObject{obj=btn.PointsSpentBgGold, x=6, y=-6}
	end
	self:skinSlider{obj=GuildInfoFrameApplicantsContainerScrollBar, adj=-4}
	self:removeMagicBtnTex(GuildRecruitmentInviteButton)
	self:removeMagicBtnTex(GuildRecruitmentDeclineButton)
	self:removeMagicBtnTex(GuildRecruitmentMessageButton)
	-- Guild Text Edit frame
	self:skinSlider{obj=GuildTextEditScrollFrameScrollBar, adj=-6}
	self:addSkinFrame{obj=GuildTextEditContainer, ft=ftype, nb=true}
	self:addSkinFrame{obj=GuildTextEditFrame, ft=ftype, kfs=true, nb=true, ofs=-7}
	-- Guild Log Frame
	self:skinSlider{obj=GuildLogScrollFrame.ScrollBar, adj=-6}
	self:addSkinFrame{obj=GuildLogContainer, ft=ftype, nb=true}
	self:addSkinFrame{obj=GuildLogFrame, ft=ftype, kfs=true, nb=true, ofs=-7}

end

function aObj:GuildControlUI() -- LoD
	if not self.db.profile.GuildControlUI or self.initialized.GuildControlUI then return end
	self.initialized.GuildControlUI = true

	GuildControlUI:DisableDrawLayer("BACKGROUND")
	GuildControlUIHbar:SetAlpha(0)
	self:skinDropDown{obj=GuildControlUI.dropdown}
	self:addSkinFrame{obj=GuildControlUI, ft=ftype, kfs=true, x1=10, y1=-10, x2=-10, y2=10}
	-- Guild Ranks Panel
	local function skinROFrames()

		local obj
		for i = 1, MAX_GUILDRANKS do
			obj = _G["GuildControlUIRankOrderFrameRank"..i]
			if obj and not aObj.skinned[obj] then
				aObj:skinEditBox{obj=obj.nameBox, regs={9}, x=-5}
			end
		end

	end
	self:SecureHook("GuildControlUI_RankOrder_Update", function(...)
		skinROFrames()
	end)
	skinROFrames()
	-- Rank Permissions Panel
	GuildControlUI.rankPermFrame:DisableDrawLayer("BACKGROUND")
	self:skinDropDown{obj=GuildControlUI.rankPermFrame.dropdown}
	self:skinEditBox{obj=GuildControlUI.rankPermFrame.goldBox, regs={9}}
	-- Bank Tab Permissions panel
	self:keepFontStrings(GuildControlUI.bankTabFrame.scrollFrame)
	self:skinSlider{obj=GuildControlUIRankBankFrameInsetScrollFrameScrollBar}
	self:skinDropDown{obj=GuildControlUI.bankTabFrame.dropdown}
	GuildControlUI.bankTabFrame.inset:DisableDrawLayer("BACKGROUND")
	GuildControlUI.bankTabFrame.inset:DisableDrawLayer("BORDER")
	-- hook this as buttons are created as required
	self:SecureHook("GuildControlUI_BankTabPermissions_Update", function(this)
		-- self:Debug("GuildControlUI_BankTabPermissions_Update: [%s]", this)
		for i = 1, MAX_BUY_GUILDBANK_TABS do
			btn = _G["GuildControlBankTab"..i]
			if btn
			and not self.skinned[btn]
			then
				btn:DisableDrawLayer("BACKGROUND")
				self:skinEditBox{obj=btn.owned.editBox, regs={9}}
				self:skinButton{obj=btn.buy.button, as=true}
			end
		end
	end)

end

function aObj:EncounterJournal() -- LoD
	if not self.db.profile.EncounterJournal or self.initialized.EncounterJournal then return end
	self.initialized.EncounterJournal = true

	self:addSkinFrame{obj=EncounterJournal, ft=ftype, kfs=true, y1=2, x2=1}
-->>-- Search EditBox, dropdown and results frame
	self:skinEditBox{obj=EncounterJournal.searchBox, regs={9}, mi=true, noHeight=true, noMove=true}
	EncounterJournal.searchBox.sbutton1:DisableDrawLayer("OVERLAY")
	self:addSkinFrame{obj=EncounterJournal.searchResults, ft=ftype, kfs=true, ofs=6, y1=-1, x2=4}
	self:skinSlider{obj=EncounterJournal.searchResults.scrollFrame.scrollBar, adj=-4}
	for i = 1, #EncounterJournal.searchResults.scrollFrame.buttons do
		btn = EncounterJournal.searchResults.scrollFrame.buttons[i]
		self:removeRegions(btn, {1})
		btn:GetNormalTexture():SetAlpha(0)
		btn:GetPushedTexture():SetAlpha(0)
		self:addButtonBorder{obj=btn, relTo=btn.icon}
	end
-->>-- Nav Bar
	EncounterJournal.navBar:DisableDrawLayer("BACKGROUND")
	EncounterJournal.navBar:DisableDrawLayer("BORDER")
	EncounterJournal.navBar.overlay:DisableDrawLayer("OVERLAY")
	EncounterJournal.navBar.home:DisableDrawLayer("OVERLAY")
	EncounterJournal.navBar.home:GetNormalTexture():SetAlpha(0)
	EncounterJournal.navBar.home:GetPushedTexture():SetAlpha(0)
	EncounterJournal.navBar.home.text:SetPoint("RIGHT", -20, 0)
-->>-- inset frame
	EncounterJournal.inset:DisableDrawLayer("BACKGROUND")
	EncounterJournal.inset:DisableDrawLayer("BORDER")
-->>-- InstanceSelect frame
	EncounterJournal.instanceSelect.bg:SetAlpha(0)
	self:skinDropDown{obj=EncounterJournal.instanceSelect.tierDropDown}
	self:skinSlider{obj=EncounterJournal.instanceSelect.scroll.ScrollBar, adj=-6}
	self:addSkinFrame{obj=EncounterJournal.instanceSelect.scroll, ft=ftype, ofs=6, x2=4}
	-- Instance buttons
	if self.modBtnBs then
		for i = 1, 30 do
			btn = EncounterJournal.instanceSelect.scroll.child["instance"..i]
			if btn then
				self:addButtonBorder{obj=btn, relTo=btn.bgImage, ofs=0}
			end
		end
	end
	-- Tabs
	EncounterJournal.instanceSelect.raidsTab:DisableDrawLayer("BACKGROUND")
	EncounterJournal.instanceSelect.dungeonsTab:DisableDrawLayer("BACKGROUND")
-->>-- Encounter frame
	-- Instance frame
	EncounterJournal.encounter.instance.loreBG:SetTexCoord(0.06, 0.70, 0.08, 0.58)
	EncounterJournal.encounter.instance.loreBG:SetWidth(370)
	EncounterJournal.encounter.instance.loreBG:SetHeight(315)
	self:moveObject{obj=EncounterJournal.encounter.instance.title, y=40}
	EncounterJournalEncounterFrameInstanceFrameTitleBG:SetAlpha(0)
	self:moveObject{obj=EncounterJournal.encounter.instance.mapButton, x=-20, y=-20}
	self:skinSlider{obj=EncounterJournal.encounter.instance.loreScroll.ScrollBar, adj=-4}
	EncounterJournal.encounter.instance.loreScroll.child.lore:SetTextColor(self.BTr, self.BTg, self.BTb)
	-- Model frame
	self:makeMFRotatable(EncounterJournal.encounter.model)
	self:getRegion(EncounterJournal.encounter.model, 1):SetAlpha(0) -- TitleBG
	-- Boss/Creature buttons
	self:SecureHook("EncounterJournal_DisplayInstance", function(instanceID, noButton)
		for i = 1, 10 do
			btn = _G["EncounterJournalBossButton"..i]
			if btn then
				btn:SetNormalTexture(nil)
				btn:SetPushedTexture(nil)
			end
		end
	end)
	self:SecureHook("EncounterJournal_DisplayEncounter", function(encounterID, noButton)
		for i = 1, 6 do
			EncounterJournal.encounter["creatureButton"..i]:SetNormalTexture(nil)
			local hTex = EncounterJournal.encounter["creatureButton"..i]:GetHighlightTexture()
			hTex:SetTexture([[Interface\EncounterJournal\UI-EncounterJournalTextures]])
			hTex:SetTexCoord(0.68945313, 0.81054688, 0.33300781, 0.39257813)
		end
	end)
	-- Info frame
	self:getRegion(EncounterJournal.encounter.info, 1):SetAlpha(0) -- BG
	EncounterJournal.encounter.info.dungeonBG:SetAlpha(0)
	EncounterJournal.encounter.info.encounterTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
	self:skinSlider{obj=EncounterJournal.encounter.info.detailsScroll.ScrollBar, adj=-4}
	EncounterJournal.encounter.info.detailsScroll.child.description:SetTextColor(self.BTr, self.BTg, self.BTb)
	EncounterJournalEncounterFrameInfoResetButton:SetNormalTexture(nil)
	EncounterJournalEncounterFrameInfoResetButton:SetPushedTexture(nil)
	EncounterJournal.encounter.info.difficulty:SetNormalTexture(nil)
	EncounterJournal.encounter.info.difficulty:SetPushedTexture(nil)
	EncounterJournal.encounter.info.difficulty:DisableDrawLayer("BACKGROUND")
	-- Hook this to skin headers
	self:SecureHook("EncounterJournal_ToggleHeaders", function(this, doNotShift)
		for i = 1, 25 do
			obj = _G["EncounterJournalInfoHeader"..i]
			if obj then
				obj.button:DisableDrawLayer("BACKGROUND")
				obj.description:SetTextColor(self.BTr, self.BTg, self.BTb)
				obj.descriptionBG:SetAlpha(0)
				obj.descriptionBGBottom:SetAlpha(0)
			end
		end
	end)
	-- Loot
	self:skinSlider{obj=EncounterJournal.encounter.info.lootScroll.scrollBar, adj=-4}
	EncounterJournal.encounter.info.lootScroll.filter:DisableDrawLayer("BACKGROUND")
	EncounterJournal.encounter.info.lootScroll.filter:SetNormalTexture(nil)
	EncounterJournal.encounter.info.lootScroll.filter:SetPushedTexture(nil)
	self:addSkinFrame{obj=EncounterJournal.encounter.info.lootScroll.classFilter, ft=ftype, kfs=true}
	EncounterJournal.encounter.info.lootScroll.classClearFilter:DisableDrawLayer("BACKGROUND")
	-- hook this to skin loot entries
	self:SecureHook("EncounterJournal_LootUpdate", function()
		for i = 1, #EncounterJournal.encounter.info.lootScroll.buttons do
			btn = EncounterJournal.encounter.info.lootScroll.buttons[i]
			btn:DisableDrawLayer("BORDER")
			btn.slot:SetTextColor(self.BTr, self.BTg, self.BTb)
			btn.armorType:SetTextColor(self.BTr, self.BTg, self.BTb)
			self:addButtonBorder{obj=btn, relTo=btn.icon}
		end

	end)
	-- Tabs (side)
	for _, v in pairs{"bossTab", "lootTab"} do
		EncounterJournal.encounter.info[v]:SetNormalTexture(nil)
		EncounterJournal.encounter.info[v]:SetPushedTexture(nil)
		EncounterJournal.encounter.info[v]:SetDisabledTexture(nil)
		self:addSkinFrame{obj=EncounterJournal.encounter.info[v], ft=ftype, noBdr=true, ofs=-3, aso={rotate=true}} -- gradient is right to left
	end
	self:moveObject{obj=EncounterJournal.encounter.info.bossTab, x=10}
	-- hide/show the texture to realign it on the tab
	EncounterJournal.encounter.info.bossTab.unselected:Hide()
	EncounterJournal.encounter.info.bossTab.unselected:Show()

end
