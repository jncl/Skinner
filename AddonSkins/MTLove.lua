
function Skinner:MTLove()

	self:applySkin(MTLove_Frame)
	self:Hook(MTLove_Frame, "SetBackdropColor", function() end, true)
	self:Hook(MTLove_Frame, "SetBackdropBorderColor", function() end, true)
	self:applySkin(MTLove_Frame_Counter)
	self:Hook(MTLove_Frame_Counter, "SetBackdropColor", function() end, true)
	self:Hook(MTLove_Frame_Counter, "SetBackdropBorderColor", function() end, true)
	self:glazeStatusBar(MTLove_Frame_StatusBar0, 0)
	self:glazeStatusBar(MTLove_Frame_StatusBar1, 0)
	self:applySkin(MTLove_TT_Frame)
	self:Hook(MTLove_TT_Frame, "SetBackdropColor", function() end, true)
	self:Hook(MTLove_TT_Frame, "SetBackdropBorderColor", function() end, true)
	self:glazeStatusBar(MTLove_TT_Frame_StatusBar, 0)
	self:applySkin(MTLove_TT_Frame_Counter)
	self:Hook(MTLove_TT_Frame_Counter, "SetBackdropColor", function() end, true)
	self:Hook(MTLove_TT_Frame_Counter, "SetBackdropBorderColor", function() end, true)
	self:applySkin(MTLove_TargetCounter_Counter)
	self:Hook(MTLove_TargetCounter_Counter, "SetBackdropColor", function() end, true)
	self:Hook(MTLove_TargetCounter_Counter, "SetBackdropBorderColor", function() end, true)

-->>--	GUI Frame
	self:keepFontStrings(MTLove_GUI_Frame)
	self:applySkin(MTLove_GUI_Frame, true)
	MTLove_GUI_Frame_TabPage1:SetPoint("TOPLEFT", MTLove_GUI_Frame, "TOPLEFT", 10, -20)
	MTLove_GUI_Frame_TabPage2:SetPoint("TOPLEFT", MTLove_GUI_Frame, "TOPLEFT", 10, -20)
	MTLove_GUI_Frame_TabPage3:SetPoint("TOPLEFT", MTLove_GUI_Frame, "TOPLEFT", 10, -20)
	self:applySkin(MTLove_GUI_Frame_TabPage1)
	self:applySkin(MTLove_GUI_Frame_TabPage2)
	self:applySkin(MTLove_GUI_Frame_TabPage3)

-->>--	Tabs
	for i = 1, 3 do
		local tabName = _G["MTLove_GUI_FrameTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		if self.db.profile.TexturedTab then self:applySkin(tabName, nil, 0, 1)
		else self:applySkin(tabName) end
		if i == 1 then
			if self.db.profile.TexturedTab then self:setActiveTab(tabName) end
			self:moveObject(tabName, nil, nil, "+", 1)
		else
			if self.db.profile.TexturedTab then self:setInactiveTab(tabName) end
			self:moveObject(tabName, "+", 10, nil, nil)
		end
	end

	if self.db.profile.TexturedTab then
		self:SecureHook("MTLove_GUI_switch_Tab", function(tabToSwitchTo)
			self:setInactiveTab(MTLove_GUI_FrameTab1)
			self:setInactiveTab(MTLove_GUI_FrameTab2)
			self:setInactiveTab(MTLove_GUI_FrameTab3)
			self:setActiveTab(_G["MTLove_GUI_FrameTab"..tabToSwitchTo])
		end)
	end

end
