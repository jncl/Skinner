
function Skinner:EnhancedStackSplit()
	if not self.db.profile.StackSplit then return end

	-- resize the StackSplitFrame skin Frame
	self.skinFrame[StackSplitFrame]:SetPoint("BOTTOMRIGHT", StackSplitFrame, "BOTTOMRIGHT", 0, -24)

	self:keepFontStrings(EnhancedStackSplitTopTextureFrame)
	self:keepFontStrings(EnhancedStackSplitBottomTextureFrame)
	self:keepFontStrings(EnhancedStackSplitAutoTextureFrame)
	-- hide the StackSplit amount when in Auto Mode
	self:SecureHook("EnhancedStackSplit_ModeSettings", function(mode)
		if mode == 3 then StackSplitText:Hide()
		else StackSplitText:Show() end
	end)

end
