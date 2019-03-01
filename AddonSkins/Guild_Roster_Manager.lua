local aName, aObj = ...
if not aObj:isAddonEnabled("Guild_Roster_Manager") then return end
local _G = _G

aObj.addonsToSkin.Guild_Roster_Manager = function(self) -- v 1.44

	-- buttons on GuildRoster subframe)
	if self.modBtns then
		self:skinStdButton{obj=_G.GRM_LoadLogButton}
	end

	-- GRM_MemberDetailMetaData (appears on mouseover of guild members on GuildRoster frame when showing Guild Status)
	self:removeInset(_G.GRM_DayDropDownMenuSelected)
	self:addSkinFrame{obj=_G.GRM_DayDropDownMenu, ft="a", kfs=true, nb=true}
	self:removeInset(_G.GRM_YearDropDownMenuSelected)
	self:addSkinFrame{obj=_G.GRM_YearDropDownMenu, ft="a", kfs=true, nb=true}
	self:removeInset(_G.GRM_MonthDropDownMenuSelected)
	self:addSkinFrame{obj=_G.GRM_MonthDropDownMenu, ft="a", kfs=true, nb=true}
	self:skinEditBox{obj=_G.GRM_PlayerNoteEditBox, regs={6}} -- 6 is text
	self:addSkinFrame{obj=_G.GRM_PlayerNoteWindow, ft="a", kfs=true, nb=true, x1=-2, x2=2}
	self:skinEditBox{obj=_G.GRM_PlayerOfficerNoteEditBox, regs={6}} -- 6 is text
	self:addSkinFrame{obj=_G.GRM_PlayerOfficerNoteWindow, ft="a", kfs=true, nb=true, x1=-2, x2=2}
	self:addSkinFrame{obj=_G.GRM_CustomNoteEditBoxFrame, ft="a", kfs=true, nb=true, x1=-2, x2=2}
	if self.modChkBtns then
		self:skinCheckButton{obj=_G.GRM_CustomNoteSyncMetaCheckBox}
	end
	self:removeInset(_G.GRM_CustomNoteRankDropDownSelected)
	self:addSkinFrame{obj=_G.GRM_CustomNoteRankDropDownMenu, ft="a", kfs=true, nb=true}
	if self.modBtns then
		self:skinStdButton{obj=_G.GRM_MemberDetailJoinDateButton}
		self:skinStdButton{obj=_G.GRM_MemberDetailBirthdayButton}
		self:skinStdButton{obj=_G.GRM_SetPromoDateButton}
		self:skinStdButton{obj=_G.GRM_DateSubmitButton}
		self:skinStdButton{obj=_G.GRM_SetUnknownButton}
		self:skinStdButton{obj=_G.GRM_DateSubmitCancelButton}
		self:skinStdButton{obj=_G.GRM_ConfirmCustomNoteButton}
		self:skinStdButton{obj=_G.GRM_CancelCustomNoteButton}
	end

	-- appears when right clicking on date(s)
	self:addSkinFrame{obj=_G.GRM_altDropDownOptions, ft="a"}

	self:addSkinFrame{obj=_G.GRM_MemberDetailMetaData, ft="a", kfs=true, bas=true, x1=2, y2=6}
	_G.GRM_MemberDetailMetaDataCloseButton:SetSize(30, 30)

	-- GRM_MemberDetailEditBoxFrame
	self:skinEditBox{obj=_G.GRM_MemberDetailPopupEditBox, regs={6}} -- 6 is text
	self:addSkinFrame{obj=_G.GRM_MemberDetailEditBoxFrame, ft="a", kfs=true, nb=true}

	-- GRM_AddAltEditFrame
	self:skinEditBox{obj=_G.GRM_AddAltEditBox, regs={6}, noInsert=true} -- 6 is text
	if self.modBtns then
		self:skinStdButton{obj=_G.GRM_AddAltButton}
	end
	self:addSkinFrame{obj=_G.GRM_AddAltEditFrame, ft="a", kfs=true, nb=true, ofs=-6}

	-- GRM_RosterConfirmFrame
	if self.modBtns then
		self:skinStdButton{obj=_G.GRM_RosterConfirmYesButton}
		self:skinStdButton{obj=_G.GRM_RosterConfirmCancelButton}
	end
	self:addSkinFrame{obj=_G.GRM_RosterConfirmFrame, ft="a", kfs=true, ofs=2, x2=1}

	-- Tab Buttons
	if self.modBtns then
		self:skinStdButton{obj=_G.GRM_LogTab}
		self:skinStdButton{obj=_G.GRM_AddEventTab}
		self:skinStdButton{obj=_G.GRM_BanListTab}
		self:skinStdButton{obj=_G.GRM_AddonUsersTab}
		self:skinStdButton{obj=_G.GRM_OptionsTab}
		self:skinStdButton{obj=_G.GRM_GuildAuditTab}
	end

	-- GRM_RosterChangeLogFrame
	self:skinSlider{obj=_G.GRM_RosterChangeLogScrollFrameSlider} -- size changed in code
	self:addSkinFrame{obj=_G.GRM_RosterChangeLogScrollBorderFrame, ft="a", kfs=true, nb=true, ofs=-2, y1=-5, x2=-4}
	self:addSkinFrame{obj=_G.GRM_RosterChangeLogFrame, ft="a", kfs=true, ofs=2, x2=1}

	-- GRM_RosterCheckBoxSideFrame
	if self.modChkBtns then
		for _, type in pairs{"Joined", "LeveledChange", "InactiveReturn", "PromotionChange", "DemotionChange", "NoteChange", "OfficerNoteChange", "CustomNoteChange", "NameChange", "RankRename", "Event", "LeftGuild"} do
			self:skinCheckButton{obj=_G["GRM_Roster" .. type .. "CheckButton"]}
			if type == "LeveledChange"
			or type == "PromotionChange"
			or type == "DemotionChange"
			or type == "NoteChange"
			or type == "OfficerNoteChange"
			or type == "CustomNoteChange"
			then
				type = type:gsub("Change", "") -- remove "Change"
			end
			self:skinCheckButton{obj=_G["GRM_Roster" .. type .. "ChatCheckButton"]}
		end
		self:skinCheckButton{obj=_G.GRM_RosterRecommendationsButton}
		self:skinCheckButton{obj=_G.GRM_RosterRecommendationsChatButton}
		self:skinCheckButton{obj=_G.GRM_RosterBannedPlayersButton}
		self:skinCheckButton{obj=_G.GRM_RosterBannedPlayersButtonChatButton}
		self:skinCheckButton{obj=_G.GRM_RosterCheckAllLogButton}
		self:skinCheckButton{obj=_G.GRM_RosterCheckAllChatButton}
	end
	self:addSkinFrame{obj=_G.GRM_RosterCheckBoxSideFrame, ft="a", kfs=true, nb=true, ofs=-3}

	-- GRM_LogFrame
	self:skinEditBox{obj=_G.GRM_LogEditBox, regs={6}, noHeight=true, noWidth=true} -- 6 is text
	if self.modBtns then
		self:skinStdButton{obj=_G.GRM_LogExtraOptionsButton}
	end
	-- GRM_LogExtraOptionsFrame
	if self.modBtns then
		self:skinStdButton{obj=_G.GRM_LogExportButton}
		self:skinStdButton{obj=_G.GRM_RosterClearLogButton}
		self:skinStdButton{obj=_G.GRM_ConfirmClearButton}
	end
	if self.modChkBtns then
		self:skinCheckButton{obj=_G.GRM_LogShowLinesCheckButton}
		self:skinCheckButton{obj=_G.GRM_SearchAutoFocusCheckButton}
		self:skinCheckButton{obj=_G.GRM_LogEnableRmvClickCheckButton}
	end
	self:skinEditBox{obj=_G.GRM_LogExtraEditBox1, regs={6}} -- 6 is text
	self:skinEditBox{obj=_G.GRM_LogExtraEditBox2, regs={6}} -- 6 is text
	self:addSkinFrame{obj=_G.GRM_LogExtraOptionsFrame, ft="a", kfs=true, nb=true, ofs=-3}

	if self.modBtns then
		self:skinCloseButton{obj=_G.GRM_BorderFrameCloseButton}
		_G.GRM_BorderFrameCloseButton:SetSize(26, 26)
	end
	self:skinSlider{obj=_G.GRM_ExportLogScrollFrameSlider, wdth=-4}
	self:addSkinFrame{obj=_G.GRM_ExportLogBorderFrame, ft="a", kfs=true, nb=true}

	-- GRM_EventsFrame
	self:addSkinFrame{obj=_G.GRM_AddEventScrollBorderFrame, ft="a", kfs=true, nb=true, aso={bd=10, ng=true}, ofs=-2, y1=-4, x2=-4} -- no backdrop background & no gradient texture (allows text to be seen)
	self:skinSlider{obj=_G.GRM_AddEventScrollFrameSlider, wdth=-4}
	if self.modBtns then
		self:skinStdButton{obj=_G.GRM_EventsFrameSetAnnounceButton}
		self:skinStdButton{obj=_G.GRM_EventsFrameIgnoreButton}
	end

	-- GRM_CoreBanListFrame
	self:skinSlider{obj=_G.GRM_CoreBanListScrollFrameSlider}
	self:addSkinFrame{obj=_G.GRM_CoreBanListScrollBorderFrame, ft="a", kfs=true, nb=true, aso={bd=10, ng=true}, ofs=-2} -- no backdrop background & no gradient texture (allows text to be seen)
	if self.modBtns then
		self:skinStdButton{obj=_G.GRM_BanListRemoveButton}
		self:skinStdButton{obj=_G.GRM_BanListAddButton}
		self:skinStdButton{obj=_G.GRM_BanListEditButton}
	end

	-- GRM_AddBanFrame
	self:skinEditBox{obj=_G.GRM_AddBanNameSelectionEditBox, regs={6, 7, 8}, noWidth=true} -- 6 is text
	self:removeInset(_G.GRM_BanServerSelected)
	self:removeInset(_G.GRM_AddBanDropDownClassSelected)
	self:addSkinFrame{obj=_G.GRM_BanServerDropDownMenu, ft="a", kfs=true, nb=true}
	self:addSkinFrame{obj=_G.GRM_AddBanDropDownMenu, ft="a", kfs=true, nb=true}
	self:addSkinFrame{obj=_G.GRM_AddBanReasonEditBoxFrame, ft="a", kfs=true, nb=true}
	if self.modBtns then
		self:skinStdButton{obj=_G.GRM_AddBanConfirmButton}
	end
	self:addSkinFrame{obj=_G.GRM_AddBanFrame, ft="a", kfs=true, y1=2, x2=1}

	-- GRM_PopupWindowConfirmFrame
	if self.modBtns then
		self:skinStdButton{obj=_G.GRM_PopupWindowConfirmFrameYesButton}
		self:skinStdButton{obj=_G.GRM_PopupWindowConfirmFrameCancelButton}
	end
	self:addSkinFrame{obj=_G.GRM_PopupWindowConfirmFrame, ft="a", kfs=true, nb=true, ofs=-2}

	-- GRM_AddonUsersFrame
	self:skinSlider{obj=_G.GRM_AddonUsersScrollFrameSlider}
	self:addSkinFrame{obj=_G.GRM_AddonUsersScrollBorderFrame, ft="a", kfs=true, nb=true, ofs=-2}

	-- GRM_OptionsFrame
	-- TODO: skin tabs
	local function skinObjNG(obj, adj)
		aObj:addSkinFrame{obj=obj, ft="a", kfs=true, nb=true, aso={ng=true}, x1=adj, x2=adj * -1}
	end
	local function skinEB(obj)
		aObj:skinEditBox{obj=obj, regs={6}, noWidth=true, noInsert=true}
		obj:SetWidth(obj:GetWidth() - 4)
	end
	--- General:
	if self.modChkBtns then
		self:skinCheckButton{obj=_G.GRM_RosterLoadOnLogonCheckButton}
		self:skinCheckButton{obj=_G.GRM_RosterLoadOnLogonChangesCheckButton}
		self:skinCheckButton{obj=_G.GRM_RosterShowMainTagCheckButton}
		self:skinCheckButton{obj=_G.GRM_ShowMainTagOnMains}
		self:skinCheckButton{obj=_G.GRM_ShowMinimapButton}
		self:skinCheckButton{obj=_G.GRM_SyncAllSettingsCheckButton}
	end
	self:skinSlider{obj=_G.GRM_FontSizeSlider, hgt=-2}
	self:skinSlider{obj=_G.GRM_TooltipScaleSlider, hgt=-2}
	skinObjNG(_G.GRM_MainTagFormatSelected, 4)
	self:addSkinFrame{obj=_G.GRM_MainTagFormatMenu, ft="a", kfs=true, nb=true}
	skinObjNG(_G.GRM_LanguageSelected, 4)
	self:addSkinFrame{obj=_G.GRM_LanguageDropDownMenu, ft="a", kfs=true, nb=true}
	skinObjNG(_G.GRM_FontSelected, 4)
	self:addSkinFrame{obj=_G.GRM_FontDropDownMenu, ft="a", kfs=true, nb=true}
	skinObjNG(_G.GRM_TimestampSelected, 4)
	self:addSkinFrame{obj=_G.GRM_TimestampSelectedDropDownMenu, ft="a", kfs=true, nb=true}
	skinObjNG(_G.GRM_24HrSelected, 4)
	self:addSkinFrame{obj=_G.GRM_24HrSelectedDropDownMenu, ft="a", kfs=true, nb=true}
	--- Scanning Roster:
	skinEB(_G.GRM_RosterTimeIntervalEditBox)
	skinObjNG(_G.GRM_RosterTimeIntervalOverlayNote, 2)
	skinEB(_G.GRM_ReportInactiveReturnEditBox)
	skinObjNG(_G.GRM_ReportInactiveReturnOverlayNote, 2)
	skinEB(_G.GRM_RosterReportUpcomingEventsEditBox)
	skinObjNG(_G.GRM_RosterReportUpcomingEventsOverlayNote, 2)
	skinEB(_G.GRM_RosterMinLvlEditBox)
	skinObjNG(_G.GRM_RosterMinLvlOverlayNote, 2)
	if self.modChkBtns then
		self:skinCheckButton{obj=_G.GRM_RosterTimeIntervalCheckButton}
		self:skinCheckButton{obj=_G.GRM_RosterReportInactiveReturnButton}
		self:skinCheckButton{obj=_G.GRM_RosterReportUpcomingEventsCheckButton}
		self:skinCheckButton{obj=_G.GRM_RosterMainOnlyCheckButton}
		self:skinCheckButton{obj=_G.GRM_ShowNotesOnLeavingPlayerButton}
		self:skinCheckButton{obj=_G.GRM_LevelRecordButton}
		self:skinCheckButton{obj=_G.GRM_LevelFilter1Button}
		self:skinCheckButton{obj=_G.GRM_LevelFilter2Button}
		self:skinCheckButton{obj=_G.GRM_LevelFilter3Button}
		self:skinCheckButton{obj=_G.GRM_LevelFilter4Button}
		self:skinCheckButton{obj=_G.GRM_LevelFilter5Button}
		self:skinCheckButton{obj=_G.GRM_LevelFilter6Button}
		self:skinCheckButton{obj=_G.GRM_LevelFilter7Button}
		self:skinCheckButton{obj=_G.GRM_LevelFilter8Button}
	end
	--- Sync:
	self:skinSlider{obj=_G.GRM_SyncSpeedSlider, hgt=-2}
	if self.modChkBtns then
		self:skinCheckButton{obj=_G.GRM_SyncOnlyCurrentVersionCheckButton}
		self:skinCheckButton{obj=_G.GRM_RosterSyncCheckButton}
		self:skinCheckButton{obj=_G.GRM_SyncAllRestrictReceiveButton}
		self:skinCheckButton{obj=_G.GRM_RosterSyncBanList}
		self:skinCheckButton{obj=_G.GRM_CustomNoteSyncCheckBox}
		self:skinCheckButton{obj=_G.GRM_BDaySyncCheckBox}
		self:skinCheckButton{obj=_G.GRM_RosterNotifyOnChangesCheckButton}
	end
	if self.modBtns then
		self:skinStdButton{obj=_G.GRM_CustomRankResetButton}
	end
	skinObjNG(_G.GRM_RosterSyncRankDropDownSelected, 4)
	self:addSkinFrame{obj=_G.GRM_RosterSyncRankDropDownMenu, ft="a", kfs=true, nb=true}
	skinObjNG(_G.GRM_RosterBanListDropDownSelected, 4)
	self:addSkinFrame{obj=_G.GRM_RosterBanListDropDownMenu, ft="a", kfs=true, nb=true}
	skinObjNG(_G.GRM_DefaultCustomSelected, 4)
	self:addSkinFrame{obj=_G.GRM_DefaultCustomRankDropDownMenu, ft="a", kfs=true, nb=true}
	--- Guild Rank Restricted:
	if self.modChkBtns then
		self:skinCheckButton{obj=_G.GRM_RosterAddTimestampCheckButton}
		self:skinCheckButton{obj=_G.GRM_AddJoinedTagButton}
		self:skinCheckButton{obj=_G.GRM_RecruitNotificationCheckButton}
		self:skinCheckButton{obj=_G.GRM_RecruitNotificationAutoPopButton}
		self:skinCheckButton{obj=_G.GRM_RosterRecommendKickCheckButton}
		self:skinCheckButton{obj=_G.GRM_AllAltsOfflineTimed}
		self:skinCheckButton{obj=_G.GRM_RosterReportAddEventsToCalendarButton}
	end
	-- Officer
	skinEB(_G.GRM_RosterKickRecommendEditBox)
	skinObjNG(_G.GRM_RosterKickOverlayNote, 2)
	-- Backup
	if self.modChkBtns then
		self:skinCheckButton{obj=_G.GRM_AutoBackupCheckBox}
	end
	skinEB(_G.GRM_AutoBackupTimeEditBox)
	skinObjNG(_G.GRM_AutoBackupTimeOverlayNote, 2)
	-- TODO: Tabs
	if self.modBtns then
		self:SecureHook(_G.GRM, "BuildBackupScrollFrame", function(factionID)
			self:skinStdButton{obj=_G.GuildBackup1_1}
			self:skinStdButton{obj=_G.GuildBackup2_1}
			self:skinStdButton{obj=_G.GuildBackup3_1}
			self:skinStdButton{obj=_G.GuildBackup4_1}
			self:skinStdButton{obj=_G.GuildBackup5_1}
			self:skinStdButton{obj=_G.GuildBackup6_1}
			self:skinStdButton{obj=_G.GuildBackup7_1}
			self:skinStdButton{obj=_G.GuildBackup8_1}
			self:skinStdButton{obj=_G.GuildBackup1_2}
			self:skinStdButton{obj=_G.GuildBackup2_2}
			self:skinStdButton{obj=_G.GuildBackup3_2}
			self:skinStdButton{obj=_G.GuildBackup4_2}
			self:skinStdButton{obj=_G.GuildBackup5_2}
			self:skinStdButton{obj=_G.GuildBackup6_2}
			self:skinStdButton{obj=_G.GuildBackup7_2}
			self:skinStdButton{obj=_G.GuildBackup8_2}
			self:Unhook(_G.GRM, "BuildBackupScrollFrame")
		end)
	end
	self:skinSlider{obj=_G.GRM_CoreBackupScrollFrameSlider}
	self:addSkinFrame{obj=_G.GRM_CoreBackupScrollBorderFrame, ft="a", kfs=true, nb=true, ofs=-2}
	--- Slash Commands:
	self:skinStdButton{obj=_G.GRM_ScanOptionsButton}
	self:skinStdButton{obj=_G.GRM_SyncOptionsButton}
	self:skinStdButton{obj=_G.GRM_CenterOptionsButton}
	self:skinStdButton{obj=_G.GRM_HelpOptionsButton}
	self:skinStdButton{obj=_G.GRM_VersionOptionsButton}
	self:skinStdButton{obj=_G.GRM_ClearAllOptionsButton}
	self:skinStdButton{obj=_G.GRM_ClearGuildOptionsButton}
	self:skinStdButton{obj=_G.GRM_ResetDefaultOptionsButton}
	self:skinStdButton{obj=_G.GRM_HardResetButton}
	--- UI Configuration:
	if self.modChkBtns then
		self:skinCheckButton{obj=_G.GRM_FadeCheckButton}
		self:skinCheckButton{obj=_G.GRM_NoteBordersButton}
		self:skinCheckButton{obj=_G.GRM_ReputationToggleButton}
		self:skinCheckButton{obj=_G.GRM_BirthdayToggleButton}
	end

	-- GRM_AuditFrame
	if self.modChkBtns then
		self:skinCheckButton{obj=_G.GRM_AuditFrameShowAllCheckbox}
		self:skinCheckButton{obj=_G.GRM_AuditFrameIncludeUnknownCheckBox}
	end
	if self.modBtns then
		self:skinStdButton{obj=_G.GRM_SetJoinUnkownButton}
		self:skinStdButton{obj=_G.GRM_SetPromoUnkownButton}
	end
	self:skinSlider{obj=_G.GRM_AuditScrollFrameSlider}
	self:addSkinFrame{obj=_G.GRM_AuditScrollBorderFrame, ft="a", kfs=true, nb=true, ofs=-2}


	-- tooltips
	_G.C_Timer.After(0.1, function()
		self:add2Table(self.ttList, _G.GRM_MemberDetailRankToolTip)
		self:add2Table(self.ttList, _G.GRM_MemberDetailJoinDateToolTip)
		self:add2Table(self.ttList, _G.GRM_MemberDetailServerNameToolTip)
		self:add2Table(self.ttList, _G.GRM_MemberDetailNotifyStatusChangeTooltip)
	end)

	-- GRM_PopupWindow
	_G.RaiseFrameLevelByTwo(_G.GRM_PopupWindow)
	self:addSkinFrame{obj=_G.GRM_PopupWindow, ft="a", kfs=true}

	-- hook these to handle frame changes
	self:SecureHook(_G.GRM_UI, "GR_MetaDataInitializeUIFirst", function(this)
		if self.modBtns then
			self:adjHeight{obj=_G.GRM_DateSubmitButton, adj=-4}
			self:adjHeight{obj=_G.GRM_SetUnknownButton, adj=-3}
			self:adjHeight{obj=_G.GRM_DateSubmitCancelButton, adj=-4}
		end
		_G.GRM_PlayerNoteWindow:SetBackdrop(nil)
		_G.GRM_PlayerOfficerNoteWindow:SetBackdrop(nil)
		_G.GRM_CustomNoteEditBoxFrame:SetBackdrop(nil)
		_G.GRM_CustomNoteSyncMetaCheckBox:SetSize(24, 24)
		self:Unhook(this, "GR_MetaDataInitializeUIFirst")
	end)
	self:SecureHook(_G.GRM_UI, "GR_MetaDataInitializeUISecond", function(this)
		_G.GRM_MemberDetailPopupEditBox:SetTextInsets(6 ,3 ,3 ,6)
		_G.GRM_altDropDownOptions:SetBackdrop(nil)
		self:Unhook(this, "GR_MetaDataInitializeUISecond")
	end)
	self:SecureHook(_G.GRM_UI, "GR_MetaDataInitializeUIThird", function(this)
		_G.GRM_AddAltEditBox:SetTextInsets(6 ,3 ,3 ,6)
		_G.GRM_LoadLogButton:SetSize(60, 16)
		_G.GRM_MemberDetailMetaData:SetPoint("TOPLEFT", _G.GuildRosterFrame, "TOPRIGHT", -2, 2)
		self:Unhook(this, "GR_MetaDataInitializeUIThird")
	end)

	self.mmButs["Guild_Roster_Manager"] = _G.GRM_MinimapButton

end
