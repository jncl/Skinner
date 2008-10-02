
function Skinner:EnhancedStackSplit()
	if not self.db.profile.StackSplit then return end

	StackSplitFrame:SetHeight(StackSplitFrame:GetHeight() + 40)
	self:keepFontStrings(EnhancedStackSplitTopTextureFrame)
	self:keepFontStrings(EnhancedStackSplitBottomTextureFrame)
	self:moveObject(EnhancedStackSplitBottomTextureFrame, "-", 7, "+", 23)
	self:moveObject(StackSplitText, nil, nil, "+", 16)
	self:moveObject(StackSplitLeftButton, "+", 5, "+", 16)
	self:moveObject(StackSplitRightButton, "-", 5, "+", 16)

	self:SecureHook("OpenStackSplitFrame", function(maxStack, parent, anchor, anchorTo)
--		self:Debug("OSSF")
		self:moveObject(StackSplitOkayButton, nil, nil, "+", 24)
		self:moveObject(StackSplitCancelButton, nil, nil, "+", 24)
	end)

end
