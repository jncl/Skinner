local aName, aObj = ...
if not aObj:isAddonEnabled("EnhancedStackSplit") then return end

function aObj:EnhancedStackSplit()
	if not self.db.profile.StackSplit then return end

	if not StackSplitFrame.sf then
		self:ScheduleTimer("EnhancedStackSplit", 0.2) -- wait for 2/10th second for frame to be skinned
		return
	end

	-- hook these to show/hide stack split value
	self:SecureHookScript(StackSplitOkayButton, "OnShow", function(this)
		StackSplitText:Show()
	end)
	self:SecureHookScript(StackSplitOkayButton, "OnHide", function(this)
		StackSplitText:Hide()
	end)
	-- hook this to handle XL mode
	self:SecureHookScript(EnhancedStackSplitXLModeButton, "OnClick", function(this)
		if self:getInt(EnhancedStackSplitBottomTextureFrame:GetHeight()) == 30 then
			StackSplitFrame.sf:SetPoint("BOTTOMRIGHT", StackSplitFrame, "BOTTOMRIGHT", 0, -45)
		else
			StackSplitFrame.sf:SetPoint("BOTTOMRIGHT", StackSplitFrame, "BOTTOMRIGHT", 0, -24)
		end
	end)
	-- resize skin frame if in XL mode
	if self:getInt(EnhancedStackSplitBottomTextureFrame:GetHeight()) == 30 then
		StackSplitFrame.sf:SetPoint("BOTTOMRIGHT", StackSplitFrame, "BOTTOMRIGHT", 0, -45)
	end

	self:keepFontStrings(EnhancedStackSplitTopTextureFrame)
	self:keepRegions(EnhancedStackSplitBottomTextureFrame, {})
	self:keepRegions(EnhancedStackSplitBottom2TextureFrame, {})
	self:keepRegions(EnhancedStackSplitAutoTextureFrame, {})

	-- skin buttons
	self:skinAllButtons{obj=StackSplitFrame}

end
