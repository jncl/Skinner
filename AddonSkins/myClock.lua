
function Skinner:myClock()

	self:keepFontStrings(myClockFrameDropDownMenu)
	self:applySkin(myClockFrame)

	-- Options Frame
	self:keepFontStrings(myClockOptionsFrameOffsetDropDown)
	self:keepFontStrings(myClockOptionsFrameTimeFormatDropDown)
	self:applySkin(myClockOptionsFrame, true)

end
