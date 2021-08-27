local _, aObj = ...
if not aObj:isAddonEnabled("ReEnhancedStackSplit") then return end
local _G = _G

aObj.addonsToSkin.ReEnhancedStackSplit = function(self) -- v 9.0.2
	if not self.db.profile.StackSplit then return end

	-- hook these to show/hide stack split value
	if _G.StackSplitFrame.OkayButton then
		_G.StackSplitFrame.OkayButton:HookScript("OnShow", function(this) _G.StackSplitFrame.StackSplitText:Show() end)
		_G.StackSplitFrame.OkayButton:HookScript("OnHide", function(this) _G.StackSplitFrame.StackSplitText:Hide() end)
	else
		_G.StackSplitOkayButton:HookScript("OnShow", function(this) _G.StackSplitText:Show() end)
		_G.StackSplitOkayButton:HookScript("OnHide", function(this) _G.StackSplitText:Hide() end)
	end

	-- OnShow already hooked by the frame skin, so using this way instead
	local os = _G.StackSplitFrame:GetScript("OnShow") -- store original function
	_G.StackSplitFrame:HookScript("OnShow", function(this)
		self:keepFontStrings(_G.EnhancedStackSplitTopTextureFrame)
		self:keepRegions(_G.EnhancedStackSplitBottomTextureFrame, {})
		self:keepRegions(_G.EnhancedStackSplitBottom2TextureFrame, {})
		self:keepRegions(_G.EnhancedStackSplitAutoTextureFrame, {})
		if self.modBtns then
			self:skinStdButton{obj=_G.EnhancedStackSplitAuto1Button}
			self:SecureHook(_G.EnhancedStackSplitAuto1Button, "Disable", function(this, _)
				self:clrBtnBdr(this)
			end)
			self:SecureHook(_G.EnhancedStackSplitAuto1Button, "Enable", function(this, _)
				self:clrBtnBdr(this)
			end)
			for i = 1, 16 do
				self:skinStdButton{obj=_G["EnhancedStackSplitButton" .. i]}
				self:SecureHook(_G["EnhancedStackSplitButton" .. i], "Disable", function(this, _)
					self:clrBtnBdr(this)
				end)
				self:SecureHook(_G["EnhancedStackSplitButton" .. i], "Enable", function(this, _)
					self:clrBtnBdr(this)
				end)
			end
			self:skinStdButton{obj=_G.EnhancedStackSplitAutoSplitButton}
			self:SecureHook(_G.EnhancedStackSplitAutoSplitButton, "Disable", function(this, _)
				self:clrBtnBdr(this)
			end)
			self:SecureHook(_G.EnhancedStackSplitAutoSplitButton, "Enable", function(this, _)
				self:clrBtnBdr(this)
			end)
			self:skinStdButton{obj=_G.EnhancedStackSplitModeTXTButton}
			self:SecureHook(_G.EnhancedStackSplitModeTXTButton, "Disable", function(this, _)
				self:clrBtnBdr(this)
			end)
			self:SecureHook(_G.EnhancedStackSplitModeTXTButton, "Enable", function(this, _)
				self:clrBtnBdr(this)
			end)
			-- DON'T skin _G.EnhancedStackSplitXLModeButton so it keeps its textures
		end
		this:SetScript("OnShow", os) -- reset to original function
		os = nil
		if _G.EnhancedStackSplit_Options.XLmode then
			_G.StackSplitFrame.sf:SetPoint("BOTTOMRIGHT", _G.StackSplitFrame, "BOTTOMRIGHT", 0, -45)
		else
			_G.StackSplitFrame.sf:SetPoint("BOTTOMRIGHT", _G.StackSplitFrame, "BOTTOMRIGHT", 0, -24)
		end
		if self:isAddonEnabled("ReEnhancedStackSplit") then
			_G.StackSplitFrame.sf:SetPoint("TOPLEFT", _G.StackSplitFrame, "TOPLEFT", 2, 2)
		end
		-- hook this to handle XL mode by resizing skinFrame
		self:SecureHookScript(_G.EnhancedStackSplitXLModeButton, "OnClick", function(this)
			if _G.Round(_G.EnhancedStackSplitBottomTextureFrame:GetHeight()) == 30 then
				_G.StackSplitFrame.sf:SetPoint("BOTTOMRIGHT", _G.StackSplitFrame, "BOTTOMRIGHT", 0, -45)
			else
				_G.StackSplitFrame.sf:SetPoint("BOTTOMRIGHT", _G.StackSplitFrame, "BOTTOMRIGHT", 0, -24)
			end
		end)
	end)
	
end
