
function Skinner:EnhancedStackSplit()
	if not self.db.profile.StackSplit then return end

	StackSplitFrame:SetHeight(StackSplitFrame:GetHeight() + 50)
	self:keepFontStrings(EnhancedStackSplitTopTextureFrame)
	self:keepFontStrings(EnhancedStackSplitBottomTextureFrame)
	self:moveObject(EnhancedStackSplitBottomTextureFrame, "-", 7, "+", 23)
	self:keepFontStrings(EnhancedStackSplitAutoTextureFrame)
	self:moveObject(StackSplitText, nil, nil, "+", 16)
	self:moveObject(StackSplitLeftButton, "+", 5, "+", 16)
	self:moveObject(StackSplitRightButton, "-", 5, "+", 16)
	self:moveObject(EnhancedStackSplitAuto1Button, nil, nil, "+", 24)

	self:SecureHook("OpenStackSplitFrame", function(...)
--		self:Debug("OSSF")
		self:moveObject(StackSplitOkayButton, nil, nil, "+", 24)
		self:moveObject(StackSplitCancelButton, nil, nil, "+", 24)
	end)
	self:SecureHook("EnhancedStackSplit_ModeSettings", function(mode)
		if mode == 3 then StackSplitText:Hide()
		else StackSplitText:Show() end
	end)

end
