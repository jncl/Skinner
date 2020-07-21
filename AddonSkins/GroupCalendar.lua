local _, aObj = ...
if not aObj:isAddonEnabled("GroupCalendar") then return end
local _G = _G

aObj.addonsToSkin.GroupCalendar = function(self) -- v 2.0.8

	self:SecureHookScript(_G.GroupCalendarFrame, "OnShow", function(this)

		self:skinDropDown{obj=_G.GroupCalendarTrustGroup}
		self:skinDropDown{obj=_G.GroupCalendarTrustMinRank}
		self:addFrameBorder{obj=_G.CalendarTrustedPlayersList}
		self:addFrameBorder{obj=_G.CalendarExcludedPlayersList}
		self:skinEditBox{obj=_G.CalendarTrustedPlayerName, regs={6}} -- 6 is text
		self:skinTabs{obj=this, ignore=true, lod=true}
		self:addSkinFrame{obj=this, ft="a", kfs=true, nb=true, ofs=2, y1=-11, y2=21}
		if self.modBtns then
			self:skinCloseButton{obj=_G.GroupCalendarCloseButton}
			self:skinStdButton{obj=_G.GroupCalendarSaveTrusted}
			self:skinStdButton{obj=_G.GroupCalendarRemoveTrusted}
			self:skinStdButton{obj=_G.GroupCalendarAddTrusted}
			self:skinStdButton{obj=_G.GroupCalendarAddExcluded}
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.GroupCalendarPreviousMonthButton, ofs=-2, x1=1, clr="gold"}
			self:addButtonBorder{obj=_G.GroupCalendarNextMonthButton, ofs=-2, x1=1, clr="gold"}
			self:addButtonBorder{obj=_G.GroupCalendarTodayButton, ofs=-2, x1=1, clr="gold"}
			self:addButtonBorder{obj=_G.GroupCalendarVersionsButton, ofs=-2, x1=8, x2=-10, clr="gold"}
			local btn
			for i = 0, 36 do
				btn = "GroupCalendarDay" .. i
				self:addButtonBorder{obj=_G[btn], ofs=5, reParent={_G[btn .. "Name"],_G[btn .. "OverlayIcon"], _G[btn .. "DogEarIcon"], _G[btn .. "CircledDate"]}, clr="grey"}
				_G[btn .. "SlotIcon"]:SetAlpha(0) -- texture changed in code
				-- colour current date button border
				if _G.gCalendarActualDateIndex == i then
					self:clrBtnBdr(_G[btn], "gold", 1)
				end
			end
			btn = nil
			self:RawHook("Calendar_HiliteActualDate", function()
				-- store original date index
				local ADI = _G.gCalendarActualDateIndex
				self.hooks.Calendar_HiliteActualDate()
				-- reset button border
				if ADI >= 0
				and _G["GroupCalendarDay" .. ADI].sbb
				then
					self:clrBtnBdr(_G["GroupCalendarDay" .. ADI], "grey", 1)
				end
				-- colour current date button border
				if _G.gCalendarActualDateIndex >= 0
				and _G["GroupCalendarDay" .. _G.gCalendarActualDateIndex].sbb
				then
					self:clrBtnBdr(_G["GroupCalendarDay" .. _G.gCalendarActualDateIndex], "gold", 1)
				end
				ADI = nil
			end, true)
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.GroupCalendarUseServerTime}
		end

		_G.GroupCalendarSideListScrollbarTrench:DisableDrawLayer("OVERLAY")
		self:skinSlider{obj=_G.GroupCalendarSideListScrollFrame.ScrollBar, rt="artwork", wdth=-4, size=3, hgt=-10}
		self:addSkinFrame{obj=_G.GroupCalendarSidePanel, ft="a", kfs=true, nb=true, ofs=2, y1=1}
		if self.modBtns then
			self:skinCloseButton{obj=_G.GroupCalendarSidePanelCloseButton}
			self:skinStdButton{obj=_G.GroupCalendarSidePanelButton}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.CalendarEditorFrame, "OnShow", function(this)

		_G.CalendarEditorScrollbarTrench:DisableDrawLayer("OVERLAY")
		self:skinSlider{obj=_G.CalendarEditorScrollFrame.ScrollBar}
		self:addSkinFrame{obj=this, ft="a", kfs=true, nb=true, ofs=2, y1=1}
		if self.modBtns then
			self:skinCloseButton{obj=_G.CalendarEditorCloseButton}
			self:skinStdButton{obj=_G.CalendarEditorNewEventButton}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.CalendarEventEditorFrame, "OnShow", function(this)

		_G.CalendarEditorFrame:Hide()

		if not this.sf then
			self:skinDropDown{obj=_G.CalendarEventTypeEventType}
			self:moveObject{obj=_G.CalendarEventTitle, y=6}
			self:skinEditBox{obj=_G.CalendarEventTitle, regs={6}} -- 6 is text
			self:skinDropDown{obj=_G.CalendarEventEditorTimeHour}
			self:skinDropDown{obj=_G.CalendarEventEditorTimeMinute}
			self:skinDropDown{obj=_G.CalendarEventEditorTimeAMPM}
			self:skinDropDown{obj=_G.CalendarEventEditorDurationDuration}
			self:skinDropDown{obj=_G.CalendarEventMinRank}
			self:skinEditBox{obj=_G.CalendarEventMinLevel, regs={6}} -- 6 is text
			self:skinEditBox{obj=_G.CalendarEventMaxLevel, regs={6}} -- 6 is text
			self:skinEditBox{obj=_G.CalendarEventTitle, regs={6}} -- 6 is text
			self:addFrameBorder{obj=_G.CalendarEventDescriptionFrame, ofs=5, x2=1, y2=1}
			self:skinDropDown{obj=_G.CalendarEventEditorCharacterMenu}
			self:skinDropDown{obj=_G.CalendarEventEditorRoleMenu}
			self:skinTabs{obj=this, ignore=true, lod=true}
			self:addSkinFrame{obj=this, ft="a", kfs=true, nb=true, ofs=2, y1=1, y2=-5}
			if self.modBtns then
				self:skinCloseButton{obj=_G.CalendarEventEditorCloseButton}
				self:skinStdButton{obj=_G.CalendarEventEditorDoneButton}
				self:skinStdButton{obj=_G.CalendarEventEditorDeleteButton}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=_G.CalendarEventEditorSelfAttend}
				self:skinCheckButton{obj=_G.CalendarEventEditorSelfNotAttend}
			end

			_G.CalendarEventEditorAttendanceExpandAll:DisableDrawLayer("BACKGROUND")
			_G.CalendarEventEditorAttendanceGroupTab:DisableDrawLayer("BACKGROUND")
			self:skinDropDown{obj=_G.CalendarEventEditorAttendanceViewMenu}
			_G.CalendarEventEditorAttendanceScrollbarTrench:DisableDrawLayer("OVERLAY")
			self:skinSlider{obj=_G.CalendarEventEditorAttendanceScrollFrame.ScrollBar}
			_G.CalendarEventEditorAttendanceMainViewTotals:DisableDrawLayer("BACKGROUND")
			_G.CalendarEventEditorAttendanceGroupView:DisableDrawLayer("BACKGROUND")
			-- N.B. DON'T try to skin expand buttons as they are also used as check buttons
			if self.modBtns then
				self:skinStdButton{obj=_G.CalendarEventEditorAttendanceMainViewAddButton}
				self:skinStdButton{obj=_G.CalendarEventEditorAttendanceGroupViewAutoSelect}
				self:skinStdButton{obj=_G.CalendarEventEditorAttendanceGroupViewInvite}
			end
			if self.modBtnBs then
				local btn
				for i = 0, 15 do
					btn = "CalendarEventEditorAttendanceItem" .. i .. "Menu"
					self:addButtonBorder{obj=_G[btn], ofs=0, clr="grey"}
				end
				btn = nil
			end

			self:skinEditBox{obj=_G.CalendarAddPlayerFrameName, regs={6}} -- 6 is text
			self:skinEditBox{obj=_G.CalendarAddPlayerFrameLevel, regs={6}} -- 6 is text
			self:skinDropDown{obj=_G.CalendarAddPlayerFrameGuildRankMenu}
			self:skinDropDown{obj=_G.CalendarAddPlayerFrameStatusMenu}
			self:skinDropDown{obj=_G.CalendarAddPlayerFrameRoleMenu}
			self:skinDropDown{obj=_G.CalendarAddPlayerFrameClassMenu}
			self:skinDropDown{obj=_G.CalendarAddPlayerFrameRaceMenu}
			self:skinEditBox{obj=_G.CalendarAddPlayerFrameComment, regs={6}} -- 6 is text
			self:skinEditBox{obj=_G.CalendarAddPlayerFrameWhisperReply, regs={6}} -- 6 is text
			self:addSkinFrame{obj=_G.CalendarAddPlayerFrame, ft="a", kfs=true, nb=true}
			if self.modBtns then
				self:skinStdButton{obj=_G.CalendarAddPlayerFrameSaveButton}
				self:skinStdButton{obj=_G.CalendarAddPlayerFrameDeleteButton}
				self:skinStdButton{obj=_G.CalendarAddPlayerFrameCancelButton}
				self:skinStdButton{obj=_G.CalendarAddPlayerFrameDoneButton}
			end
		end

	end)

	-- N.B. CalendarClassLimitsFrame NOT currently used
	-- self:SecureHookScript(_G.CalendarClassLimitsFrame, "OnShow", function(this)
	--
	-- 	self:skinDropDown{obj=_G.CalendarClassLimitsFramePriorityValue}
	-- 	local frame
	-- 	for _, class in pairs(_G.CLASS_SORT_ORDER) do
	-- 		frame = "CalendarClassLimitsFrame" .. self:capitStr(class)
	-- 		self:skinEditBox{obj=_G[frame .. "Min"], regs={6}} -- 6 is text
	-- 		self:skinEditBox{obj=_G[frame .. "Max"], regs={6}} -- 6 is text
	-- 	end
	-- 	frame = nil
	-- 	self:skinDropDown{obj=_G.CalendarClassLimitsFrameMaxPartySize}
	-- 	self:addSkinFrame{obj=this, ft="a", kfs=true, nb=true}
	-- 	if self.modBtns then
	-- 		self:skinStdButton{obj=_G.CalendarClassLimitsFrameCancelButton}
	-- 		self:skinStdButton{obj=_G.CalendarClassLimitsFrameDoneButton}
	-- 	end
	--
	-- 	self:Unhook(this, "OnShow")
	-- end)

end
