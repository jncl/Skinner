
function Skinner:MacroBank()
	if not self.db.profile.MenuFrames then return end
	
	self:SecureHook(MacroBank.MainFrame, "Show", function(this, ...)
		local frame = MacroBank.MainFrame
		frame:ClearAllPoints();
	    frame:SetPoint("TOPLEFT", MacroFrame, "TOPRIGHT")
		self:keepFontStrings(frame)
		frame.HeaderTexture:Hide()
		frame.HeaderTexture:SetPoint("TOP", frame, "TOP", 0, 7)
		self:keepFontStrings(frame.MacroList.ScrollFrame)
		self:skinScrollBar(frame.MacroList.ScrollFrame)
		self:applySkin(frame.MacroList)
		self:skinEditBox(frame.MacroCategory, {9})
		self:skinEditBox(frame.MacroDescription, {9})
		self:skinEditBox(frame.MacroName, {9})
		self:keepFontStrings(frame.MacroBody.ScrollFrame)
		self:skinScrollBar(frame.MacroBody.ScrollFrame)
		self:applySkin(frame.MacroBody)
		self:applySkin(frame)
		-- wait for a half a second to resize the frame 
		self:ScheduleTimer(function() frame:SetWidth(MacroFrame:GetWidth()) 	frame:SetHeight(MacroFrame:GetHeight())end, 0.5)
		self:Unhook(MacroBank.MainFrame, "Show")
	end)

end
