local aName, aObj = ...
if not aObj:isAddonEnabled("EnhancedStackSplit") then return end
local _G = _G

aObj.addonsToSkin.EnhancedStackSplit = function(self) -- v 60100-1
	if not self.db.profile.StackSplit then return end

	-- hook this to handle XL mode by resizing skinFrame
	self:SecureHookScript(_G.EnhancedStackSplitXLModeButton, "OnClick", function(this)
		if _G.Round(_G.EnhancedStackSplitBottomTextureFrame:GetHeight()) == 30 then
			_G.StackSplitFrame.sf:SetPoint("BOTTOMRIGHT", _G.StackSplitFrame, "BOTTOMRIGHT", 0, -45)
		else
			_G.StackSplitFrame.sf:SetPoint("BOTTOMRIGHT", _G.StackSplitFrame, "BOTTOMRIGHT", 0, -24)
		end
	end)

	-- hook these to show/hide stack split value
	_G.StackSplitFrame.OkayButton:HookScript("OnShow", function(this) _G.StackSplitFrame.StackSplitText:Show() end)
	_G.StackSplitFrame.OkayButton:HookScript("OnHide", function(this) _G.StackSplitFrame.StackSplitText:Hide() end)

	-- OnShow already hooked by the frame skin, so using this way instead
	local os = _G.StackSplitFrame:GetScript("OnShow") -- store original function
	_G.StackSplitFrame:HookScript("OnShow", function(this)
		self:keepFontStrings(_G.EnhancedStackSplitTopTextureFrame)
		self:keepRegions(_G.EnhancedStackSplitBottomTextureFrame, {})
		self:keepRegions(_G.EnhancedStackSplitBottom2TextureFrame, {})
		self:keepRegions(_G.EnhancedStackSplitAutoTextureFrame, {})
		if self.modBtns then
			self:skinStdButton{obj=_G.EnhancedStackSplitAuto1Button}
			self:skinStdButton{obj=_G.EnhancedStackSplitButton1}
			self:skinStdButton{obj=_G.EnhancedStackSplitButton2}
			self:skinStdButton{obj=_G.EnhancedStackSplitButton3}
			self:skinStdButton{obj=_G.EnhancedStackSplitButton4}
			self:skinStdButton{obj=_G.EnhancedStackSplitButton5}
			self:skinStdButton{obj=_G.EnhancedStackSplitButton6}
			self:skinStdButton{obj=_G.EnhancedStackSplitButton7}
			self:skinStdButton{obj=_G.EnhancedStackSplitButton8}
			self:skinStdButton{obj=_G.EnhancedStackSplitButton9}
			self:skinStdButton{obj=_G.EnhancedStackSplitButton10}
			self:skinStdButton{obj=_G.EnhancedStackSplitButton11}
			self:skinStdButton{obj=_G.EnhancedStackSplitButton12}
			self:skinStdButton{obj=_G.EnhancedStackSplitButton13}
			self:skinStdButton{obj=_G.EnhancedStackSplitButton14}
			self:skinStdButton{obj=_G.EnhancedStackSplitButton15}
			self:skinStdButton{obj=_G.EnhancedStackSplitButton16}
			self:skinStdButton{obj=_G.EnhancedStackSplitAutoSplitButton}
			self:skinStdButton{obj=_G.EnhancedStackSplitModeTXTButton}
			-- DON'T skin _G.EnhancedStackSplitXLModeButton so it keeps its textures
		end
		this:SetScript("OnShow", os) -- reset to original function
		os = nil
	end)

end
