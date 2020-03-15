local aName, aObj = ...
if not aObj:isAddonEnabled("Guild_Roster_Manager") then return end
local _G = _G

aObj.addonsToSkin.Guild_Roster_Manager = function(self) -- v 1.87

	-- buttons on GuildRoster subframe
	if self.modBtns then
		self:skinStdButton{obj=_G.GRM_LoadLogButton}
		self:skinStdButton{obj=_G.GRM_LoadLogOldRosterButton}
		self:skinStdButton{obj=_G.GRM_LoadToolButton}
		self:skinStdButton{obj=_G.GRM_LoadToolOldRosterButton}
	end
	if self.modChkBtns then
		self:SecureHook(_G.GRM_UI, "MainRoster_OnShow", function(this)
			self:skinCheckButton{obj=_G.GRM_EnableMouseOver}

			self:Unhook(this, "MainRoster_OnShow")
		end)
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
	if self.modChkBtns then
		self:skinCheckButton{obj=_G.GRM_CustomNoteSyncMetaCheckBox}
		self:skinCheckButton{obj=_G.GRM_SafeFromRulesCheckButton}
	end

	-- appears when right clicking on date(s)
	self:addSkinFrame{obj=_G.GRM_altDropDownOptions, ft="a"}

	self:addSkinFrame{obj=_G.GRM_MemberDetailMetaData, ft="a", kfs=true, bas=true, ofs=0}
	_G.GRM_MemberDetailMetaDataCloseButton:SetSize(30, 30)

	-- GRM_MemberDetailEditBoxFrame
	self:skinEditBox{obj=_G.GRM_MemberDetailPopupEditBox, regs={6}} -- 6 is text
	self:addSkinFrame{obj=_G.GRM_MemberDetailEditBoxFrame, ft="a", kfs=true, nb=true}

	-- GRM_AddAltEditFrame
	self:skinEditBox{obj=_G.GRM_AddAltEditBox, regs={6}, noInsert=true} -- 6 is text
	self:addSkinFrame{obj=_G.GRM_AddAltEditFrame, ft="a", kfs=true, nb=true, ofs=-3}
	if self.modBtns then
		self:skinCloseButton{obj=_G.GRM_AddAltEditBoxCloseButton}
		self:skinStdButton{obj=_G.GRM_AddAltButton2, x1=2, x2=-2}
	end

	-- GRM_RosterConfirmFrame
	self:addSkinFrame{obj=_G.GRM_RosterConfirmFrame, ft="a", kfs=true, ofs=2, x2=1}
	if self.modBtns then
		self:skinStdButton{obj=_G.GRM_RosterConfirmYesButton}
		self:skinStdButton{obj=_G.GRM_RosterConfirmCancelButton}
	end

	-- Tab Buttons
	if self.modBtns then
		self:skinStdButton{obj=_G.GRM_LogTab, y2=4}
		self:skinStdButton{obj=_G.GRM_AddEventTab, y2=4}
		self:skinStdButton{obj=_G.GRM_BanListTab, y2=4}
		self:skinStdButton{obj=_G.GRM_AddonUsersTab, y2=4}
		self:skinStdButton{obj=_G.GRM_OptionsTab, y2=4}
		self:skinStdButton{obj=_G.GRM_GuildAuditTab, x2=-1, y2=4}
	end

	-- GRM_RosterChangeLogFrame
	self:skinSlider{obj=_G.GRM_RosterChangeLogScrollFrameSlider} -- size changed in code
	self:addSkinFrame{obj=_G.GRM_RosterChangeLogScrollBorderFrame, ft="a", kfs=true, nb=true, ofs=-2, y1=-5, x2=-4}
	_G.GRM_RosterChangeLogFrame.GRM_LogFrame.GRM_LogEditBox:SetBackdrop(nil)
	self:addSkinFrame{obj=_G.GRM_RosterChangeLogFrame, ft="a", kfs=true, ofs=2, x2=1}

	-- GRM_ExportLogFrameEditBox
	-- TODO: tabs
	self:addSkinFrame{obj=_G.GRM_ExportLogScrollBorderFrame, ft="a", kfs=true, nb=true, ofs=-3, x2=-4}
	self:skinSlider{obj=_G.GRM_ExportLogScrollFrameSlider, wdth=-4}
	self:skinEditBox{obj=_G.GRM_ExportRangeEditBox1, regs={6, 7}} -- 6 & 7 are text
	self:skinEditBox{obj=_G.GRM_ExportRangeEditBox2, regs={6, 7}} -- 6 & 7 are text
	self:removeInset(_G.GRM_DelimiterDropdownMenuSelected)
	self:addSkinFrame{obj=_G.GRM_DelimiterDropdownMenuSelected, ft="a", kfs=true, nb=true}
	self:removeInset(_G.GRM_DelimiterDropdownMenu)
	self:addSkinFrame{obj=_G.GRM_DelimiterDropdownMenu, ft="a", kfs=true, nb=true}
	self:addSkinFrame{obj=_G.GRM_ExportLogBorderFrame, ft="a", kfs=true, nb=true, ofs=0, x2=1}
	if self.modBtns then
		self:skinCloseButton{obj=_G.GRM_BorderFrameCloseButton}
		_G.GRM_BorderFrameCloseButton:SetSize(26, 26)
		self:skinStdButton{obj=_G.GRM_ExportSelectedRangeButton}
		self:skinStdButton{obj=_G.GRM_ExportNextRangeButton}
		self:skinStdButton{obj=_G.GRM_ExportPreviousRangeButton}
		self:skinStdButton{obj=_G.GRM_ExportMemberDetailsHeadersButton}
		self:skinStdButton{obj=_G.GRM_ExportResetOptionsButton}
	end
	if self.modChkBtns then
		self:skinCheckButton{obj=_G.GRM_ExportAutoIncludeHeadersCheckButton}
		self:skinCheckButton{obj=_G.GRM_ExportFilter1}
		self:skinCheckButton{obj=_G.GRM_ExportFilter2}
		self:skinCheckButton{obj=_G.GRM_ExportFilter3}
		self:skinCheckButton{obj=_G.GRM_ExportFilter4}
		self:skinCheckButton{obj=_G.GRM_ExportFilter5}
		self:skinCheckButton{obj=_G.GRM_ExportFilter6}
		self:skinCheckButton{obj=_G.GRM_ExportFilter7}
		self:skinCheckButton{obj=_G.GRM_ExportFilter8}
		self:skinCheckButton{obj=_G.GRM_ExportFilter9}
		self:skinCheckButton{obj=_G.GRM_ExportFilter10}
		self:skinCheckButton{obj=_G.GRM_ExportFilter11}
		self:skinCheckButton{obj=_G.GRM_ExportFilter12}
		self:skinCheckButton{obj=_G.GRM_ExportFilter13}
		self:skinCheckButton{obj=_G.GRM_ExportFilter14}
		self:skinCheckButton{obj=_G.GRM_ExportFilter15}
		self:skinCheckButton{obj=_G.GRM_ExportFilter16}
	end

	-- GRM_RosterCheckBoxSideFrame
	self:addSkinFrame{obj=_G.GRM_RosterCheckBoxSideFrame, ft="a", kfs=true, nb=true, ofs=-3}
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

	-- GRM_LogFrame
	self:skinEditBox{obj=_G.GRM_LogEditBox, regs={6}, noHeight=true, noWidth=true} -- 6 is text
	if self.modBtns then
		self:skinStdButton{obj=_G.GRM_LogExtraOptionsButton}
	end
	-- GRM_LogExtraOptionsFrame
	self:skinEditBox{obj=_G.GRM_LogExtraEditBox1, regs={6}} -- 6 is text
	self:skinEditBox{obj=_G.GRM_LogExtraEditBox2, regs={6}} -- 6 is text
	self:skinSlider{obj=_G.GRM_UI.GRM_RosterChangeLogFrame.GRM_LogFrame.GRM_LogExtraOptionsFrame.GRM_LogFontSizeSlider, hgt=-2} -- N.B. also called 'GRM_FontSizeSlider' which is a duplicate name
	self:addSkinFrame{obj=_G.GRM_LogExtraOptionsFrame, ft="a", kfs=true, nb=true, ofs=-3}
	if self.modBtns then
		self:skinStdButton{obj=_G.GRM_LogExportButton}
		self:skinStdButton{obj=_G.GRM_RosterClearLogButton}
		self:skinStdButton{obj=_G.GRM_ConfirmClearButton}
		self:skinStdButton{obj=_G.GRM_RosterResetOptionsButton}
	end
	if self.modChkBtns then
		self:skinCheckButton{obj=_G.GRM_LogShowLinesCheckButton}
		self:skinCheckButton{obj=_G.GRM_SearchAutoFocusCheckButton}
		self:skinCheckButton{obj=_G.GRM_LogEnableRmvClickCheckButton}
		self:skinCheckButton{obj=_G.GRM_LogShowTooltipCheckButton}
	end

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
	self:addSkinFrame{obj=_G.GRM_AddBanFrame, ft="a", kfs=true, y1=2, x2=1}
	if self.modBtns then
		self:skinStdButton{obj=_G.GRM_AddBanConfirmButton}
	end

	-- GRM_PopupWindowConfirmFrame
	self:addSkinFrame{obj=_G.GRM_PopupWindowConfirmFrame, ft="a", kfs=true, nb=true, ofs=-2}
	if self.modBtns then
		self:skinStdButton{obj=_G.GRM_PopupWindowConfirmFrameYesButton}
		self:skinStdButton{obj=_G.GRM_PopupWindowConfirmFrameCancelButton}
	end

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
		self:skinCheckButton{obj=_G.GRM_ColorizeSystemMessagesCheckButton}
		self:skinCheckButton{obj=_G.GRM_RosterShowMainTagCheckButton}
		self:skinCheckButton{obj=_G.GRM_ShowMainTagOnMains}
		self:skinCheckButton{obj=_G.GRM_ShowMinimapButton}
		self:skinCheckButton{obj=_G.GRM_SyncAllSettingsCheckButton}
	end
	self:addSkinFrame{obj=_G.GRM_ColorSelectOptionsFrame, ft="a", nb=true, aso={ng=true}}
	skinEB(_G.GRM_ReportDestinationEditBox)
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
		self:skinCheckButton{obj=_G.GRM_ReportInactivesOnlyIfAllButton}
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
	skinObjNG(_G.GRM_RosterSyncRankDropDownSelected, 4)
	self:addSkinFrame{obj=_G.GRM_RosterSyncRankDropDownMenu, ft="a", kfs=true, nb=true}
	skinObjNG(_G.GRM_RosterBanListDropDownSelected, 4)
	self:addSkinFrame{obj=_G.GRM_RosterBanListDropDownMenu, ft="a", kfs=true, nb=true}
	skinObjNG(_G.GRM_DefaultCustomSelected, 4)
	self:addSkinFrame{obj=_G.GRM_DefaultCustomRankDropDownMenu, ft="a", kfs=true, nb=true}
	if self.modBtns then
		self:skinStdButton{obj=_G.GRM_CustomRankResetButton}
	end
	if self.modChkBtns then
		self:skinCheckButton{obj=_G.GRM_SyncOnlyCurrentVersionCheckButton}
		self:skinCheckButton{obj=_G.GRM_RosterSyncCheckButton}
		self:skinCheckButton{obj=_G.GRM_SyncAllRestrictReceiveButton}
		self:skinCheckButton{obj=_G.GRM_RosterSyncBanList}
		self:skinCheckButton{obj=_G.GRM_CustomNoteSyncCheckBox}
		self:skinCheckButton{obj=_G.GRM_BDaySyncCheckBox}
		self:skinCheckButton{obj=_G.GRM_RosterNotifyOnChangesCheckButton}
	end
	--- Guild Rank Restricted:
	if self.modChkBtns then
		self:skinCheckButton{obj=_G.GRM_RosterAddTimestampCheckButton}
		self:skinCheckButton{obj=_G.GRM_AddJoinedTagButton}
		self:skinCheckButton{obj=_G.GRM_NoteTagFeatureCheckButton}
		self:skinCheckButton{obj=_G.GRM_RosterReportAddEventsToCalendarButton}
	end
	-- Officer
	skinEB(_G.GRM_CustomTagJoinEditBox)
	skinEB(_G.GRM_CustomTagREJoinEditBox)
	if self.modBtns then
		self:skinStdButton{obj=_G.GRM_ExportGlobalControlButton}
	end
	-- Backup
	if self.modChkBtns then
		self:skinCheckButton{obj=_G.GRM_AutoBackupCheckBox}
	end
	skinEB(_G.GRM_AutoBackupTimeEditBox)
	skinObjNG(_G.GRM_AutoBackupTimeOverlayNote, 2)
	-- TODO: Tabs
	if self.modBtns then
		self:SecureHook(_G.GRM, "BuildBackupScrollFrame", function(showAll, fullRefresh)
			for i = 1, #GRM_G.BackupEntries do
				self:skinStdButton{obj=_G["GuildBackup1_" .. i]}
				self:skinStdButton{obj=_G["GuildBackup2_" .. i]}
			end

			self:Unhook(_G.GRM, "BuildBackupScrollFrame")
		end)
	end
	self:skinSlider{obj=_G.GRM_CoreBackupScrollFrameSlider}
	self:addSkinFrame{obj=_G.GRM_CoreBackupScrollBorderFrame, ft="a", kfs=true, nb=true, ofs=-2}
	--- Slash Commands:
	if self.modBtns then
		self:skinStdButton{obj=_G.GRM_ScanOptionsButton}
		self:skinStdButton{obj=_G.GRM_SyncOptionsButton}
		self:skinStdButton{obj=_G.GRM_CenterOptionsButton}
		self:skinStdButton{obj=_G.GRM_HelpOptionsButton}
		self:skinStdButton{obj=_G.GRM_VersionOptionsButton}
		self:skinStdButton{obj=_G.GRM_ClearAllOptionsButton}
		self:skinStdButton{obj=_G.GRM_ClearGuildOptionsButton}
		self:skinStdButton{obj=_G.GRM_ResetDefaultOptionsButton}
		self:skinStdButton{obj=_G.GRM_HardResetButton}
	end
	--- UI Configuration:
	self:skinSlider{obj=_G.GRM_CoreWindowScaleSlider, hgt=-2}
	self:skinSlider{obj=_G.GRM_MouseOverScaleSlider, hgt=-2}
	self:skinSlider{obj=_G.GRM_MacroToolScaleSlider, hgt=-2}
	self:skinSlider{obj=_G.GRM_ExportToolScaleSlider, hgt=-2}
	self:skinSlider{obj=_G.GRM_AdvancedAuditToolScaleSlider, hgt=-2}
	if self.modBtns then
		self:skinStdButton{obj=_G.GRM_OpenMouseoverButton}
		self:skinStdButton{obj=_G.GRM_OpenMacroToolButton}
		self:skinStdButton{obj=_G.GRM_OpenExportToolButton}
		self:skinStdButton{obj=_G.GRM_OpenAuditJoinDateToolButton}
	end
	if self.modChkBtns then
		self:skinCheckButton{obj=_G.GRM_FadeCheckButton}
		self:skinCheckButton{obj=_G.GRM_NoteBordersButton}
		self:skinCheckButton{obj=_G.GRM_ReputationToggleButton}
		self:skinCheckButton{obj=_G.GRM_BirthdayToggleButton}
		self:skinCheckButton{obj=_G.GRM_ColorizePlayerNamesButton}
	end

	-- GRM_AuditFrame
	self:skinSlider{obj=_G.GRM_AuditScrollFrameSlider}
	self:addSkinFrame{obj=_G.GRM_AuditScrollBorderFrame, ft="a", kfs=true, nb=true, ofs=-2}
	if self.modBtns then
		self:skinStdButton{obj=_G.GRM_JDAuditToolButton}
		self:skinStdButton{obj=_G.GRM_ShowExportWindowButton}
		self:skinStdButton{obj=_G.GRM_SetJoinUnkownButton}
		self:skinStdButton{obj=_G.GRM_SetPromoUnkownButton}
		self:skinStdButton{obj=_G.GRM_SetBdayUnkownButton}
	end
	if self.modChkBtns then
		self:skinCheckButton{obj=_G.GRM_AuditFrameShowAllCheckbox}
		self:skinCheckButton{obj=_G.GRM_AuditFrameIncludeUnknownCheckBox}
		self:skinCheckButton{obj=_G.GRM_AuditBirthdayToggleButton}
	end

	-- GRM_AuditJDTool
	self:skinSlider{obj=_G.GRM_JDToolScrollFrameSlider}
	self:addSkinFrame{obj=_G.GRM_JDToolScrollBorderFrame, ft="a", kfs=true, nb=true, ofs=-3}
	self:addSkinFrame{obj=_G.GRM_AuditJDTool, ft="a", kfs=true, x2=1}
	if self.modBtns then
		self:skinStdButton{obj=_G.GRM_AuditJDToolButton1}
		self:skinStdButton{obj=_G.GRM_AuditJDToolButton2}
		self:skinStdButton{obj=_G.GRM_AuditJDToolButton3}
		self:skinStdButton{obj=_G.GRM_AuditJDToolButton4}
		self:skinStdButton{obj=_G.GRM_AuditJDToolButton5}
		self:skinStdButton{obj=_G.GRM_AuditJDToolButton6}
		self:skinStdButton{obj=_G.GRM_AuditJDToolButton7}
	end
	if self.modChkBtns then
		self:skinCheckButton{obj=_G.GRM_AuditJDToolCheckButton1}
		self:skinCheckButton{obj=_G.GRM_AuditJDToolCheckBox}
	end

	-- tooltips
	_G.C_Timer.After(0.1, function()
		self:add2Table(self.ttList, _G.GRM_MemberDetailRankToolTip)
		self:add2Table(self.ttList, _G.GRM_MemberDetailJoinDateToolTip)
		self:add2Table(self.ttList, _G.GRM_MemberDetailServerNameToolTip)
		self:add2Table(self.ttList, _G.GRM_MemberDetailNotifyStatusChangeTooltip)
		self:add2Table(self.ttList, _G.GRM_OfficerNoteTooltip)
		self:add2Table(self.ttList, _G.GRM_LogTooltip)
		self:add2Table(self.ttList, _G.GRM_MemberDetailNJDSyncTooltip)
		self:add2Table(self.ttList, _G.GRM_GuildNameTooltip)
		self:add2Table(self.ttList, _G.GRM_AltGroupHeaderTooltip)
		self:add2Table(self.ttList, _G.GRM_BanHeaderTooltip)
		self:add2Table(self.ttList, _G.GRM_BirthdayTooltip)
		self:add2Table(self.ttList, _G.GRM_AddonUsersTooltip)
	end)

	-- GRM_PopupWindow
	_G.RaiseFrameLevelByTwo(_G.GRM_PopupWindow)
	self:addSkinFrame{obj=_G.GRM_PopupWindow, ft="a", kfs=true}

	-- GRM_GeneralPopupWindow
	self:addSkinFrame{obj=_G.GRM_GeneralPopupWindow, ft="a", kfs=true, nb=true}
	if self.modBtns then
		self:skinStdButton{obj=_G.GRM_GeneralPopupWindowYesButton}
		self:skinStdButton{obj=_G.GRM_GeneralPopupWindowNoButton}
	end

	-- hook these to handle frame changes
	self:SecureHook(_G.GRM_UI, "GR_MetaDataInitializeUIFirst", function(isManualUpdate)
		_G.GRM_PlayerNoteWindow:SetBackdrop(nil)
		_G.GRM_PlayerOfficerNoteWindow:SetBackdrop(nil)
		_G.GRM_CustomNoteEditBoxFrame:SetBackdrop(nil)
		_G.GRM_CustomNoteSyncMetaCheckBox:SetSize(24, 24)
		if self.modBtns then
			self:adjHeight{obj=_G.GRM_DateSubmitButton, adj=-4}
			self:adjHeight{obj=_G.GRM_SetUnknownButton, adj=-3}
			self:adjHeight{obj=_G.GRM_DateSubmitCancelButton, adj=-4}
		end
		if self.modChkBtns then
			_G.GRM_SafeFromRulesCheckButton:SetSize(24, 24)
		end

		self:Unhook(_G.GRM_UI, "GR_MetaDataInitializeUIFirst")
	end)
	self:SecureHook(_G.GRM_UI, "GR_MetaDataInitializeUISecond", function(isManualUpdate)
		_G.GRM_MemberDetailPopupEditBox:SetTextInsets(6 ,3 ,3 ,6)
		_G.GRM_altDropDownOptions:SetBackdrop(nil)

		self:Unhook(_G.GRM_UI, "GR_MetaDataInitializeUISecond")
	end)
	self:SecureHook(_G.GRM_UI, "GR_MetaDataInitializeUIThird", function(isManualUpdate)
		_G.GRM_AddAltEditBox:SetTextInsets(6 ,3 ,3 ,6)
		_G.GRM_LoadLogButton:SetSize(60, 16)
		_G.GRM_LoadLogOldRosterButton:SetSize(60, 16)
		_G.GRM_LoadToolButton:SetSize(60, 16)
		_G.GRM_LoadToolOldRosterButton:SetSize(60, 16)

		self:Unhook(_G.GRM_UI, "GR_MetaDataInitializeUIThird")
	end)

	self.mmButs["Guild_Roster_Manager"] = _G.GRM_MinimapButton

	-- Macro Tool frame
	-- TODO: tabs
	skinEB(_G.GRM_RosterKickRecommendEditBox)
	self:removeInset(_G.GRM_TimeScaleSelected)
	self:addSkinFrame{obj=_G.GRM_TimeScaleSelected, ft="a", kfs=true, nb=true}
	self:removeInset(_G.GRM_TimeScaleDropDownMenu)
	self:addSkinFrame{obj=_G.GRM_TimeScaleDropDownMenu, ft="a", kfs=true, nb=true}
	self:addSkinFrame{obj=_G.GRM_ToolMacrodScrollBorderFrame, ft="a", kfs=true, nb=true, ofs=-3}
	self:skinSlider{obj=_G.GRM_ToolMacrodScrollFrameSilder, wdth=-4}
	self:addSkinFrame{obj=_G.GRM_ToolQueuedScrollBorderFrame, ft="a", kfs=true, nb=true, ofs=-3}
	self:skinSlider{obj=_G.GRM_ToolRulesScrollFrameSilder, wdth=-4}
	self:addSkinFrame{obj=_G.GRM_ToolRulesScrollBorderFrame, ft="a", kfs=true, nb=true, ofs=-3}
	self:skinSlider{obj=_G.GRM_ToolQueuedScrollFrameSilder, wdth=-4}
	self:addSkinFrame{obj=_G.GRM_ToolCoreFrame, ft="a", kfs=true, ofs=0}
	if self.modBtns then
		self:skinStdButton{obj=_G.GRM_ToolBuildMacroButton}
		self:skinStdButton{obj=_G.GRM_ToolViewSafeListButton}
		self:skinStdButton{obj=_G.GRM_ToolClearSelectedMacrodNamesButton}
		self:skinStdButton{obj=_G.GRM_ToolResetSelectedMacroNamesButton}
		self:skinStdButton{obj=_G.GRM_CustomRuleAddButton}
		self:skinStdButton{obj=_G.GRM_ToolResetSettingsButton}
	end
	if self.modChkBtns then
		-- TODO: skin Kick Rule check boxes
	end

	self:SecureHookScript(_G.GRM_ToolCustomRulesFrame, "OnShow", function(this)
		skinEB(_G.GRM_CustomRuleNameEditBox)
		skinEB(_G.GRM_CustomRuleLevelStartEditBox)
		skinEB(_G.GRM_CustomRuleLevelStopEditBox)
		skinEB(_G.GRM_NoteSearchEditBox)
		self:addSkinFrame{obj=this, ft="a", kfs=true}
		if self.modBtns then
			self:skinStdButton{obj=_G.GRM_ToolCustomRulesConfirmButton}
			self:skinStdButton{obj=_G.GRM_ToolCustomRulesCancelButton}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.GRM_ToolRecommendKickCheckButton}
			self:skinCheckButton{obj=_G.GRM_ToolAltsOfflineTimed}
			-- TODO: action this when required
			-- for i = 1, _G.GuildControlGetNumRanks() - 1 do
			-- 	if _G["GRM_ToolCustomRulesRank" .. i] then
			-- 		self:skinCheckButton{obj=_G["GRM_ToolCustomRulesRank" .. i]}
			-- 	end
			-- end
			self:skinCheckButton{obj=_G.GRM_ToolCompareStringCheckButton}
			self:skinCheckButton{obj=_G.GRM_ToolPublicNoteCheckButton}
			self:skinCheckButton{obj=_G.GRM_ToolOfficerCheckButton}
			self:skinCheckButton{obj=_G.GRM_ToolCustomCheckButton}
		end

		self:Unhook(this, "OnShow")
	end)

	self:addSkinFrame{obj=_G.GRM_ToolIgnoredScrollBorderFrame, ft="a", kfs=true, nb=true, ofs=-3}
	self:skinSlider{obj=_G.GRM_ToolIgnoredScrollFrameSilder, wdth=-4}
	self:addSkinFrame{obj=_G.GRM_ToolIgnoreListFrame, ft="a", kfs=true, ofs=0}
	if self.modBtns then
		self:skinStdButton{obj=_G.GRM_ToolIgnoreClearSelectionButton}
		self:skinStdButton{obj=_G.GRM_ToolIgnoreResetSelectedNamesButton}
		self:skinStdButton{obj=_G.GRM_ToiolIgnoreRemoveAllButton}
	end
	if self.modChkBtns then
		self:skinCheckButton{obj=_G.GRM_ToolCoreIgnoreCheckButton}
	end

end
