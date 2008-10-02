
function Skinner:FreierGeist_InstanceTime()

	self:applySkin(InstanceTimeFrame)
	self:applySkin(InstanceTime_TimerFrameXP)
	self:applySkin(InstanceTime_TimerFrameRep)
	self:applySkin(InstanceTime_ListFrame)
	self:keepFontStrings(InstanceTimeScrollBar)
	self:skinScrollBar(InstanceTimeScrollBar)
	self:applySkin(InstanceTime_TellToFrame)
	self:applySkin(InstanceTime_ClassLootFrame)
-->>--	Options Frame
	self:skinEditBox(InstanceTimeOptionsFrameAnnouncement)
	self:skinEditBox(InstanceTimeOptionsFrameContinueWithin)
	self:applySkin(InstanceTimeOptionsFrame)
-->>--	Help Frame
	self:applySkin(InstanceTime_Help)
	self:keepFontStrings(InstanceTime_HelpScrollFrame)
	self:skinScrollBar(InstanceTime_HelpScrollFrame)

end
