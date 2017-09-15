local aName, aObj = ...
if not aObj:isAddonEnabled("Guild_Roster_Manager") then return end
local _G = _G

aObj.addonsToSkin.Guild_Roster_Manager = function(self) -- 7.2.5R1.02

	-- TODO DropDown Frame(s) & Button(s)

	-- FIXME - remove spaces from the realm name when constructing the PlayerName string so it matches subsequent checks
	_G.GRM_AddonGlobals.addonPlayerName = (_G.GetUnitName ( "PLAYER" , false ) .. "-" .. _G.GRM_AddonGlobals.realmName:gsub(" ", ""))

	-- GRM_LoadLogButton (on GuildRoster frame)
	self:skinButton{obj=_G.GRM_LoadLogButton}

	-- GRM_MemberDetailMetaData )appears on mouseover of guild members on GuildRoster frame)
	self:removeInset(_G.GRM_DayDropDownMenuSelected)
	self:addSkinFrame{obj=_G.GRM_DayDropDownMenu, kfs=true}
	self:removeInset(_G.GRM_YearDropDownMenuSelected)
	self:addSkinFrame{obj=_G.GRM_YearDropDownMenu, kfs=true}
	self:removeInset(_G.GRM_MonthDropDownMenuSelected)
	self:addSkinFrame{obj=_G.GRM_MonthDropDownMenu, kfs=true}
	self:skinEditBox{obj=_G.GRM_PlayerNoteEditBox, regs={6}} -- 6 is text
	self:addSkinFrame{obj=_G.GRM_PlayerNoteWindow, x1=-2, x2=2}
	self:skinEditBox{obj=_G.GRM_PlayerOfficerNoteEditBox, regs={6}} -- 6 is text
	self:addSkinFrame{obj=_G.GRM_PlayerOfficerNoteWindow, x1=-2, x2=2}
	-- self:removeInset(_G.GRM_guildRankDropDownMenuSelected)
	-- self:addSkinFrame{obj=_G.GRM_RankDropDownMenu, kfs=true}

	-- appears when right clicking on date(s)
	self:addSkinFrame{obj=_G.GRM_altDropDownOptions}

	-- N.B. use ApplySkin for buttons otherwise Button skin frame disappears!
	self:addSkinFrame{obj=_G.GRM_MemberDetailMetaData, kfs=true, bas=true, x1=2, y2=6}
	_G.GRM_MemberDetailMetaDataCloseButton:SetSize(30, 30)

	-- tooltips
	if self.db.profile.Tooltips.skin then
		self:add2Table(self.ttList, "GRM_MemberDetailRankToolTip")
		self:add2Table(self.ttList, "GRM_MemberDetailJoinDateToolTip")
		self:add2Table(self.ttList, "GRM_altFrameToolTip")
	end

	-- GRM_PopupWindow
	_G.RaiseFrameLevelByTwo(_G.GRM_PopupWindow)
	self:addSkinFrame{obj=_G.GRM_PopupWindow, kfs=true}

	-- GRM_MemberDetailEditBoxFrame
	self:skinEditBox{obj=_G.GRM_MemberDetailPopupEditBox, regs={6}} -- 6 is text
	self:addSkinFrame{obj=_G.GRM_MemberDetailEditBoxFrame, kfs=true}

	-- GRM_CoreAltFrame

	-- GRM_AddAltEditFrame
	self:skinEditBox{obj=_G.GRM_AddAltEditBox, regs={6}, noInsert=true} -- 6 is text
	self:addSkinFrame{obj=_G.GRM_AddAltEditFrame, kfs=true, ofs=-6}

	-- GRM_AddEventFrame
	self:addSkinFrame{obj=_G.GRM_AddEventScrollBorderFrame, kfs=true, ofs=-4}
	self:skinSlider{obj=_G.GRM_AddEventScrollFrameSlider, wdth=-4}
	self:addSkinFrame{obj=_G.GRM_AddEventFrame, kfs=true, ofs=2, x2=1}

	-- GRM_RosterChangeLogFrame
	self:skinCheckButton{obj=_G.GRM_RosterTimeIntervalCheckButton}
	self:skinCheckButton{obj=_G.GRM_RosterRecommendKickCheckButton}
	self:skinEditBox{obj=_G.GRM_RosterKickRecommendEditBox, regs={6}, noWidth=true} -- 6 is text
	self:skinCheckButton{obj=_G.GRM_RosterReportInactiveReturnButton}
	self:skinEditBox{obj=_G.GRM_ReportInactiveReturnEditBox, regs={6}, noWidth=true} -- 6 is text
	self:skinCheckButton{obj=_G.GRM_RosterReportUpcomingEventsCheckButton}
	self:skinEditBox{obj=_G.GRM_RosterReportUpcomingEventsEditBox, regs={6}, noWidth=true} -- 6 is text
	-- GRM_RosterSyncRankDropDownSelected
	self:skinCheckButton{obj=_G.GRM_RosterSyncCheckButton}
	self:removeInset(_G.GRM_RosterSyncRankDropDownSelected)
	self:addSkinFrame{obj=_G.GRM_RosterSyncRankDropDownMenu, kfs=true}
	self:addSkinFrame{obj=_G.GRM_RosterChangeLogScrollBorderFrame, kfs=true, ofs=-2, y1=-4, x2=-4}
	self:skinSlider{obj=_G.GRM_RosterChangeLogScrollFrameSlider} -- size changed in code
	self:addSkinFrame{obj=_G.GRM_RosterChangeLogFrame, kfs=true, ofs=2, x2=1}

	-- GRM_RosterCheckBoxSideFrame
	self:addSkinFrame{obj=_G.GRM_RosterCheckBoxSideFrame, kfs=true, ofs=-3}

	-- GRM_RosterConfirmFrame
	self:addSkinFrame{obj=_G.GRM_RosterConfirmFrame, kfs=true, ofs=2, x2=1}

	-- hook these to handle frame changes
	self:SecureHook(_G.GRM_UI, "GR_MetaDataInitializeUIFirst", function(this)
		self:adjHeight{obj=_G.GRM_DateSubmitButton, adj=-4}
		self:adjHeight{obj=_G.GRM_DateSubmitCancelButton, adj=-4}
		_G.GRM_PlayerNoteWindow:SetBackdrop(nil)
		_G.GRM_PlayerOfficerNoteWindow:SetBackdrop(nil)
		self:Unhook(this, "GR_MetaDataInitializeUIFirst")
	end)
	self:SecureHook(_G.GRM_UI, "GR_MetaDataInitializeUISecond", function(this)
		_G.GRM_MemberDetailPopupEditBox:SetTextInsets(6 ,3 ,3 ,6)
		_G.GRM_altDropDownOptions:SetBackdrop(nil)
		self:Unhook(this, "GR_MetaDataInitializeUISecond")
	end)
	self:SecureHook(_G.GRM_UI, "GR_MetaDataInitializeUIThird", function(this)
		_G.GRM_AddAltEditBox:SetTextInsets(6 ,3 ,3 ,6)
		_G.GRM_LoadLogButton:SetSize (60 ,16)
		self:moveObject{obj=_G.GRM_LoadLogButton, x=-13, y=7}
		self:Unhook(this, "GR_MetaDataInitializeUIThird")
	end)
	self:SecureHook(_G.GRM_UI, "MetaDataInitializeUIrosterLog1", function(this)
		_G.GRM_RosterOptionsButton:SetSize (90 ,20)
		_G.GRM_RosterClearLogButton:SetSize (90 ,20)
		_G.GRM_RosterTimeIntervalOverlayNote:SetBackdrop(nil)
		_G.GRM_RosterKickOverlayNote:SetBackdrop(nil)
		_G.GRM_ReportInactiveReturnEditBox:SetWidth(38)
		_G.GRM_ReportInactiveReturnEditBox:ClearAllPoints()
		_G.GRM_ReportInactiveReturnEditBox:SetPoint("RIGHT", _G.GRM_RosterReportInactiveReturnButtonText2, "LEFT", 2, 0)
		_G.GRM_ReportInactiveReturnEditBox:SetTextInsets(6 ,9 ,9 ,6)
		_G.GRM_ReportInactiveReturnOverlayNote:SetBackdrop(nil)
		_G.GRM_RosterReportUpcomingEventsOverlayNote:SetBackdrop(nil)
		self:Unhook(this, "MetaDataInitializeUIrosterLog1")
	end)

end
