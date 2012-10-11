local aName, aObj = ...
if not aObj:isAddonEnabled("GroupCalendar5") then return end

local function skinGroupCalendar5()

	local function skinSEB(frame)
		
		-- Scrolling EditBox
		aObj:addSkinFrame{obj=frame, x1=-6, y1=4, y2=-6}
		frame.BackgroundTextures:Hide()
		frame.ScrollbarTrench:Hide()
		aObj:skinSlider{obj=frame.Scrollbar, size=3}
		
	end
	local function skinDD(frame)
		
		-- DropDown Menu
		if not aObj.db.profile.TexturedDD then aObj:keepFontStrings(frame)
		else
			aObj:skinDropDown{obj=frame, x1=0, y1=1, x2=2, y2=-1}
		end
		
	end
	
	local gcUI = GroupCalendar.UI
	local gcW = gcUI.Window
	
	-- hook this to manage Tabs
	if aObj.isTT then
		-- hook this to change the texture for the Active and Inactive tabs
		aObj:SecureHook(gcW.TabbedView.Tabs, "SelectTab",function(this, ...)
			for _, vTab in ipairs(this.Tabs) do
				local tabSF = aObj.skinFrame[vTab]
				if vTab == this.SelectedTab then
					aObj:setActiveTab(tabSF)
				else
					aObj:setInactiveTab(tabSF)
				end
			end
		end)
	end
	
	-- remove the clock
	gcW.Clock:Hide()
	-- skin the main frame
	aObj:addSkinFrame{obj=gcW, kfs=true, x1=10, y1=-11, x2=2, y2=-3}
	aObj:Unhook(gcUI.Window, "Show")
-->>-- Tabbed Views
	-- Month View
	-- Settings View
	aObj:SecureHookScript(gcW.SettingsView, "OnShow", function(this)
		skinDD(this.ThemeMenu)
		skinDD(this.StartDayMenu)
		aObj:Unhook(gcW.SettingsView, "OnShow")
	end)
	-- Partners View
	aObj:skinEditBox{obj=gcW.PartnersView.CharacterName, regs={9, 10}}
	aObj:glazeStatusBar(gcW.PartnersView.ProgressBar, 0)
	-- Export View
	skinSEB(gcW.ExportView.ExportData)
	-- About View

-->>-- NewerVersion Frame
	aObj:addSkinFrame{obj=gcW.NewerVersionFrame, kfs=true, y1=1, y2=-1}
	
-->>-- ClassLimits Dialog
	aObj:SecureHookScript(gcUI.ClassLimitsDialog, "OnShow", function(this)
		skinDD(this.PriorityMenu)
		for _, class in pairs(aObj.classTable) do	
			aObj:skinEditBox{obj=this[strupper(class)].Min, regs={9}, noWidth=true}
			aObj:skinEditBox{obj=this[strupper(class)].Max, regs={9}, noWidth=true}
		end
		skinDD(this.MaxPartySizeMenu)
		aObj:Unhook(gcUI.ClassLimitsDialog, "OnShow")
	end)
	aObj:addSkinFrame{obj=gcUI.ClassLimitsDialog, kfs=true, y1=4, y2=4}
	
-->>-- RoleLimits Dialog
	aObj:SecureHookScript(gcUI.RoleLimitsDialog, "OnShow", function(this)
		skinDD(this.PriorityMenu)
		for _, role in pairs({"H", "T", "R", "M"}) do
			aObj:skinEditBox{obj=this[role].Min, regs={9}, noWidth=true}
			aObj:skinEditBox{obj=this[role].Max, regs={9}, noWidth=true}
			for _, class in pairs(aObj.classTable) do	
				aObj:skinEditBox{obj=this[role][strupper(class)], regs={9}, noWidth=true}
			end
		end
		skinDD(this.MaxPartySizeMenu)
		aObj:skinButton{obj=this.ToggleClassReservations}
		aObj:Unhook(gcUI.RoleLimitsDialog, "OnShow")
	end)
	aObj:addSkinFrame{obj=gcUI.RoleLimitsDialog, kfs=true, y1=4, y2=4}

-->>-- DaySidebar
	gcW.DaySidebar.Foreground:Hide()
	gcW.DaySidebar.ScrollingList.ScrollbarTrench:Hide()
	aObj:skinScrollBar{obj=gcW.DaySidebar.ScrollingList.ScrollFrame}
	aObj:addSkinFrame{obj=gcW.DaySidebar, kfs=true, bg=true, x1=-4, y1=2, x2=2, y2=-7}

-->>-- EventSidebar
	local eSB = gcW.EventSidebar
	-- hook this to manage Tabs
	if aObj.isTT then
		-- hook this to change the texture for the Active and Inactive tabs
		aObj:SecureHook(eSB.TabbedView.Tabs, "SelectTab",function(this, ...)
			for _, vTab in ipairs(this.Tabs) do
				local tabSF = aObj.skinFrame[vTab]
				if vTab == this.SelectedTab then
					aObj:setActiveTab(tabSF)
				else
					aObj:setInactiveTab(tabSF)
				end
			end
		end)
	end
	eSB.Foreground:Hide()
	aObj:addSkinFrame{obj=eSB, kfs=true, bg=true, x1=-4, y1=2, x2=2, y2=-7}
-->>-- Tabbed Views
 	-- Event View
 	-- Edit View
	aObj:SecureHookScript(eSB.EventEditor, "OnShow", function(this)
		this.Background:SetAlpha(0)
		skinDD(this.EventTypeMenu)
		aObj:skinEditBox{obj=this.EventTitle, regs={9}}
		skinDD(this.EventModeMenu)
		aObj:skinEditBox{obj=this.LevelRangePicker.MinLevel, regs={9}, noWidth=true}
		aObj:skinEditBox{obj=this.LevelRangePicker.MaxLevel, regs={9}, noWidth=true}
		skinSEB(this.Description)
		skinDD(this.DatePicker.MonthMenu)
		skinDD(this.DatePicker.DayMenu)
		skinDD(this.DatePicker.YearMenu)
		skinDD(this.TimePicker.HourMenu)
		skinDD(this.TimePicker.MinuteMenu)
		skinDD(this.TimePicker.AMPMMenu)
		skinDD(this.DurationMenu)
		skinDD(this.RepeatMenu)
		skinDD(this.LockoutMenu)
		aObj:Unhook(eSB.EventEditor, "OnShow")
	end)
 	-- Invite View
	aObj:skinEditBox{obj=eSB.EventInvite.CharacterName, regs={9, 10}, x=-2}
	aObj:keepFontStrings(eSB.EventInvite.StatusSection)
	eSB.EventInvite.ScrollingList.ScrollbarTrench:Hide()
	aObj:skinScrollBar{obj=eSB.EventInvite.ScrollingList.ScrollFrame}
	eSB.EventInvite.ExpandAll.TabLeft:SetAlpha(0)
	eSB.EventInvite.ExpandAll.TabMiddle:SetAlpha(0)
	eSB.EventInvite.ExpandAll.TabRight:SetAlpha(0)
	aObj:skinButton{obj=eSB.EventInvite.ExpandAll, mp2=true}
	aObj:SecureHook(eSB.EventInvite, "Refresh", function(this)
		for i = 1, #this.ScrollingList.ItemFrames do
			if this.ScrollingList.ItemFrames[i].ExpandButton then
				aObj:skinButton{obj=this.ScrollingList.ItemFrames[i].ExpandButton, mp2=true}
			end
		end
		aObj:Unhook(eSB.EventInvite, "Refresh")
	end)
 	-- Group View
	aObj:SecureHookScript(eSB.EventGroup, "OnShow", function(this)
		skinDD(this.ViewMenu)
		aObj:keepFontStrings(this.TotalsSection)
		aObj:keepFontStrings(this.StatusSection)
		aObj:skinButton{obj=this.StartEventButton}
		aObj:skinButton{obj=this.StopEventButton}
		aObj:skinButton{obj=this.AutoSelectButton}
		aObj:skinButton{obj=this.InviteSelectedButton}
		this.ScrollingList.ScrollbarTrench:Hide()
		aObj:skinScrollBar{obj=this.ScrollingList.ScrollFrame}
		this.ExpandAll.TabLeft:SetAlpha(0)
		this.ExpandAll.TabMiddle:SetAlpha(0)
		this.ExpandAll.TabRight:SetAlpha(0)
		aObj:skinButton{obj=this.ExpandAll, mp2=true}
		aObj:Unhook(eSB.EventGroup, "OnShow")
	end)
	aObj:SecureHook(eSB.EventGroup, "Refresh", function(this)
		for i = 1, #this.ScrollingList.ItemFrames do
			if this.ScrollingList.ItemFrames[i].CheckButton then
				aObj:skinButton{obj=this.ScrollingList.ItemFrames[i].CheckButton, mp2=true}
			end
			aObj:skinButton{obj=this.ScrollingList.ItemFrames[i].InviteButton}
			aObj:skinButton{obj=this.ScrollingList.ItemFrames[i].ConfirmButton}
			aObj:skinButton{obj=this.ScrollingList.ItemFrames[i].StandbyButton}
		end
		aObj:Unhook(eSB.EventGroup, "Refresh")
	end)
	
-->>-- All Tabs
	for i = 1, MC2UIElementsLib.TabNameIndex - 1 do
		local tabName = _G["MC2UIElementsLibTab"..i]
		aObj:keepRegions(tabName, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		local tabSF = aObj:addSkinFrame{obj=tabName, noBdr=aObj.isTT, x1=6, y1=0, x2=-6, y2=2}
		if i == 1 then
			if aObj.isTT then aObj:setActiveTab(tabSF) end
		else
			if aObj.isTT then aObj:setInactiveTab(tabSF) end
		end
	end

end

function aObj:GroupCalendar5()

	self:SecureHook(GroupCalendar.UI.Window, "Show", function(this)
		skinGroupCalendar5()
	end)

end
