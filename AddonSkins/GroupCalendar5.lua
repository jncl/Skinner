local aName, aObj = ...
if not aObj:isAddonEnabled("GroupCalendar5") then return end

function aObj:GroupCalendar5()

	local function skinSEB(frame)
		
		-- Scrolling EditBox
		aObj:addSkinFrame{obj=frame, x1=-6, y1=4, y2=-6}
		frame.BackgroundTextures:Hide()
		frame.ScrollbarTrench:Hide()
		self:skinSlider{obj=frame.Scrollbar, size=3}
		
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
	if self.isTT then
		-- hook this to change the texture for the Active and Inactive tabs
		self:SecureHook(gcW.TabbedView.Tabs, "SelectTab",function(this, ...)
			for _, vTab in ipairs(this.Tabs) do
				local tabSF = self.skinFrame[vTab]
				if vTab == this.SelectedTab then
					self:setActiveTab(tabSF)
				else
					self:setInactiveTab(tabSF)
				end
			end
		end)
	end
	
	-- remove the clock
	gcW.Clock:Hide()
	-- skin the main frame
	self:addSkinFrame{obj=gcW, kfs=true, x1=10, y1=-11, x2=2, y2=-3}
-->>-- Tabbed Views
	-- Month View
	-- Settings View
	self:SecureHookScript(gcW.SettingsView, "OnShow", function(this)
		skinDD(this.ThemeMenu)
		skinDD(this.StartDayMenu)
		self:Unhook(gcW.SettingsView, "OnShow")
	end)
	-- Partners View
	self:skinEditBox{obj=gcW.PartnersView.CharacterName, regs={9, 10}}
	self:glazeStatusBar(gcW.PartnersView.ProgressBar, 0)
	-- Export View
	skinSEB(gcW.ExportView.ExportData)
	-- About View

-->>-- NewerVersion Frame
	self:addSkinFrame{obj=gcW.NewerVersionFrame, kfs=true, y1=1, y2=-1}
	
-->>-- ClassLimits Dialog
	self:SecureHookScript(gcUI.ClassLimitsDialog, "OnShow", function(this)
		skinDD(this.PriorityMenu)
		for _, class in pairs(self.classTable) do	
			self:skinEditBox{obj=this[strupper(class)].Min, regs={9}, noWidth=true}
			self:skinEditBox{obj=this[strupper(class)].Max, regs={9}, noWidth=true}
		end
		skinDD(this.MaxPartySizeMenu)
		self:Unhook(gcUI.ClassLimitsDialog, "OnShow")
	end)
	self:addSkinFrame{obj=gcUI.ClassLimitsDialog, kfs=true, y1=4, y2=4}
	
-->>-- RoleLimits Dialog
	self:SecureHookScript(gcUI.RoleLimitsDialog, "OnShow", function(this)
		skinDD(this.PriorityMenu)
		for _, role in pairs({"H", "T", "R", "M"}) do
			self:skinEditBox{obj=this[role].Min, regs={9}, noWidth=true}
			self:skinEditBox{obj=this[role].Max, regs={9}, noWidth=true}
			for _, class in pairs(self.classTable) do	
				self:skinEditBox{obj=this[role][strupper(class)], regs={9}, noWidth=true}
			end
		end
		skinDD(this.MaxPartySizeMenu)
		self:skinButton{obj=this.ToggleClassReservations}
		self:Unhook(gcUI.RoleLimitsDialog, "OnShow")
	end)
	self:addSkinFrame{obj=gcUI.RoleLimitsDialog, kfs=true, y1=4, y2=4}

-->>-- DaySidebar
	gcW.DaySidebar.Foreground:Hide()
	gcW.DaySidebar.ScrollingList.ScrollbarTrench:Hide()
	self:skinScrollBar{obj=gcW.DaySidebar.ScrollingList.ScrollFrame}
	self:addSkinFrame{obj=gcW.DaySidebar, kfs=true, bg=true, x1=-4, y1=2, x2=2, y2=-7}

-->>-- EventSidebar
	local eSB = gcW.EventSidebar
	-- hook this to manage Tabs
	if self.isTT then
		-- hook this to change the texture for the Active and Inactive tabs
		self:SecureHook(eSB.TabbedView.Tabs, "SelectTab",function(this, ...)
			for _, vTab in ipairs(this.Tabs) do
				local tabSF = self.skinFrame[vTab]
				if vTab == this.SelectedTab then
					self:setActiveTab(tabSF)
				else
					self:setInactiveTab(tabSF)
				end
			end
		end)
	end
	eSB.Foreground:Hide()
	self:addSkinFrame{obj=eSB, kfs=true, bg=true, x1=-4, y1=2, x2=2, y2=-7}
-->>-- Tabbed Views
 	-- Event View
 	-- Edit View
	self:SecureHookScript(eSB.EventEditor, "OnShow", function(this)
		this.Background:SetAlpha(0)
		skinDD(this.EventTypeMenu)
		self:skinEditBox{obj=this.EventTitle, regs={9}}
		skinDD(this.EventModeMenu)
		self:skinEditBox{obj=this.LevelRangePicker.MinLevel, regs={9}, noWidth=true}
		self:skinEditBox{obj=this.LevelRangePicker.MaxLevel, regs={9}, noWidth=true}
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
		self:Unhook(eSB.EventEditor, "OnShow")
	end)
 	-- Invite View
	self:skinEditBox{obj=eSB.EventInvite.CharacterName, regs={9, 10}, x=-2}
	self:keepFontStrings(eSB.EventInvite.StatusSection)
	eSB.EventInvite.ScrollingList.ScrollbarTrench:Hide()
	self:skinScrollBar{obj=eSB.EventInvite.ScrollingList.ScrollFrame}
	eSB.EventInvite.ExpandAll.TabLeft:SetAlpha(0)
	eSB.EventInvite.ExpandAll.TabMiddle:SetAlpha(0)
	eSB.EventInvite.ExpandAll.TabRight:SetAlpha(0)
	self:skinButton{obj=eSB.EventInvite.ExpandAll, mp2=true}
	self:SecureHook(eSB.EventInvite, "Refresh", function(this)
		for i = 1, #this.ScrollingList.ItemFrames do
			if this.ScrollingList.ItemFrames[i].ExpandButton then
				self:skinButton{obj=this.ScrollingList.ItemFrames[i].ExpandButton, mp2=true}
			end
		end
		self:Unhook(eSB.EventInvite, "Refresh")
	end)
 	-- Group View
	self:SecureHookScript(eSB.EventGroup, "OnShow", function(this)
		skinDD(this.ViewMenu)
		self:keepFontStrings(this.TotalsSection)
		self:keepFontStrings(this.StatusSection)
		self:skinButton{obj=this.StartEventButton}
		self:skinButton{obj=this.StopEventButton}
		self:skinButton{obj=this.AutoSelectButton}
		self:skinButton{obj=this.InviteSelectedButton}
		this.ScrollingList.ScrollbarTrench:Hide()
		self:skinScrollBar{obj=this.ScrollingList.ScrollFrame}
		this.ExpandAll.TabLeft:SetAlpha(0)
		this.ExpandAll.TabMiddle:SetAlpha(0)
		this.ExpandAll.TabRight:SetAlpha(0)
		self:skinButton{obj=this.ExpandAll, mp2=true}
		self:Unhook(eSB.EventGroup, "OnShow")
	end)
	self:SecureHook(eSB.EventGroup, "Refresh", function(this)
		for i = 1, #this.ScrollingList.ItemFrames do
			if this.ScrollingList.ItemFrames[i].CheckButton then
				self:skinButton{obj=this.ScrollingList.ItemFrames[i].CheckButton, mp2=true}
			end
			self:skinButton{obj=this.ScrollingList.ItemFrames[i].InviteButton}
			self:skinButton{obj=this.ScrollingList.ItemFrames[i].ConfirmButton}
			self:skinButton{obj=this.ScrollingList.ItemFrames[i].StandbyButton}
		end
		self:Unhook(eSB.EventGroup, "Refresh")
	end)
	
-->>-- All Tabs
	for i = 1, MC2UIElementsLib.TabNameIndex - 1 do
		local tabName = _G["MC2UIElementsLibTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		local tabSF = self:addSkinFrame{obj=tabName, noBdr=self.isTT, x1=6, y1=0, x2=-6, y2=2}
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end

end
