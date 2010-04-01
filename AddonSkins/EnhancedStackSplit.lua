if not Skinner:isAddonEnabled("EnhancedStackSplit") then return end

function Skinner:EnhancedStackSplit()
	if not self.db.profile.StackSplit then return end

	self:keepFontStrings(EnhancedStackSplitTopTextureFrame)
	self:keepFontStrings(EnhancedStackSplitBottomTextureFrame)
	self:keepFontStrings(EnhancedStackSplitAutoTextureFrame)
	-- hide the StackSplit amount when in Auto Mode
	self:SecureHook("EnhancedStackSplit_ModeSettings", function(mode)
		if mode == 3 then StackSplitText:Hide()
		else StackSplitText:Show() end
	end)
	-- skin buttons
	self:skinButton{obj=EnhancedStackSplitAuto1Button}
	for i = 1, 10 do
		self:skinButton{obj=_G["EnhancedStackSplitButton"..i]}
	end
	self:skinButton{obj=EnhancedStackSplitModeTXTButton}
	self:skinButton{obj=EnhancedStackSplitAutoSplitButton}

end
