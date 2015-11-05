local aName, aObj = ...
if not aObj:isAddonEnabled("EnhancedStackSplit") then return end
local _G = _G

function aObj:EnhancedStackSplit()
	if not self.db.profile.StackSplit then return end

	if not _G.StackSplitFrame.sf then
		self:ScheduleTimer("EnhancedStackSplit", 0.2) -- wait for 2/10th second for frame to be skinned
		return
	end

	-- hook these to show/hide stack split value
	_G.StackSplitOkayButton:HookScript("OnShow", function(this) _G.StackSplitText:Show() end)
	_G.StackSplitOkayButton:HookScript("OnHide", function(this) _G.StackSplitText:Hide() end)

	-- hook this to handle XL mode
	self:SecureHookScript(_G.EnhancedStackSplitXLModeButton, "OnClick", function(this)
		if self:getInt(_G.EnhancedStackSplitBottomTextureFrame:GetHeight()) == 30 then
			_G.StackSplitFrame.sf:SetPoint("BOTTOMRIGHT", _G.StackSplitFrame, "BOTTOMRIGHT", 0, -45)
		else
			_G.StackSplitFrame.sf:SetPoint("BOTTOMRIGHT", _G.StackSplitFrame, "BOTTOMRIGHT", 0, -24)
		end
	end)
	-- resize skin frame if in XL mode
	if self:getInt(_G.EnhancedStackSplitBottomTextureFrame:GetHeight()) == 30 then
		_G.StackSplitFrame.sf:SetPoint("BOTTOMRIGHT", _G.StackSplitFrame, "BOTTOMRIGHT", 0, -45)
	end

	self:keepFontStrings(_G.EnhancedStackSplitTopTextureFrame)
	self:keepRegions(_G.EnhancedStackSplitBottomTextureFrame, {})
	self:keepRegions(_G.EnhancedStackSplitBottom2TextureFrame, {})
	self:keepRegions(_G.EnhancedStackSplitAutoTextureFrame, {})

	-- skin buttons
	self:skinAllButtons{obj=_G.StackSplitFrame}

end
