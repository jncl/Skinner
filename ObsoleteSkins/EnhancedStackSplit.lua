local aName, aObj = ...
if not aObj:isAddonEnabled("EnhancedStackSplit")
and not aObj:isAddonEnabled("ReEnhancedStackSplit")
then return end
local _G = _G

local function skinFrame()
	if not aObj.db.profile.StackSplit then return end

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
		aObj:keepFontStrings(_G.EnhancedStackSplitTopTextureFrame)
		aObj:keepRegions(_G.EnhancedStackSplitBottomTextureFrame, {})
		aObj:keepRegions(_G.EnhancedStackSplitBottom2TextureFrame, {})
		aObj:keepRegions(_G.EnhancedStackSplitAutoTextureFrame, {})
		if aObj.modBtns then
			aObj:skinStdButton{obj=_G.EnhancedStackSplitAuto1Button}
			aObj:SecureHook(_G.EnhancedStackSplitAuto1Button, "Disable", function(this, _)
				aObj:clrBtnBdr(this)
			end)
			aObj:SecureHook(_G.EnhancedStackSplitAuto1Button, "Enable", function(this, _)
				aObj:clrBtnBdr(this)
			end)
			for i = 1, 16 do
				aObj:skinStdButton{obj=_G["EnhancedStackSplitButton" .. i]}
				aObj:SecureHook(_G["EnhancedStackSplitButton" .. i], "Disable", function(this, _)
					aObj:clrBtnBdr(this)
				end)
				aObj:SecureHook(_G["EnhancedStackSplitButton" .. i], "Enable", function(this, _)
					aObj:clrBtnBdr(this)
				end)
			end
			aObj:skinStdButton{obj=_G.EnhancedStackSplitAutoSplitButton}
			aObj:SecureHook(_G.EnhancedStackSplitAutoSplitButton, "Disable", function(this, _)
				aObj:clrBtnBdr(this)
			end)
			aObj:SecureHook(_G.EnhancedStackSplitAutoSplitButton, "Enable", function(this, _)
				aObj:clrBtnBdr(this)
			end)
			aObj:skinStdButton{obj=_G.EnhancedStackSplitModeTXTButton}
			aObj:SecureHook(_G.EnhancedStackSplitModeTXTButton, "Disable", function(this, _)
				aObj:clrBtnBdr(this)
			end)
			aObj:SecureHook(_G.EnhancedStackSplitModeTXTButton, "Enable", function(this, _)
				aObj:clrBtnBdr(this)
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
		if aObj:isAddonEnabled("ReEnhancedStackSplit") then
			_G.StackSplitFrame.sf:SetPoint("TOPLEFT", _G.StackSplitFrame, "TOPLEFT", 2, 2)
		end
		-- hook this to handle XL mode by resizing skinFrame
		aObj:SecureHookScript(_G.EnhancedStackSplitXLModeButton, "OnClick", function(this)
			if _G.Round(_G.EnhancedStackSplitBottomTextureFrame:GetHeight()) == 30 then
				_G.StackSplitFrame.sf:SetPoint("BOTTOMRIGHT", _G.StackSplitFrame, "BOTTOMRIGHT", 0, -45)
			else
				_G.StackSplitFrame.sf:SetPoint("BOTTOMRIGHT", _G.StackSplitFrame, "BOTTOMRIGHT", 0, -24)
			end
		end)
	end)
	
end
aObj.addonsToSkin.EnhancedStackSplit = function(self) -- v 60100-1
	skinFrame()
end
aObj.addonsToSkin.ReEnhancedStackSplit = function(self) -- v 9.0.2
	skinFrame()
end
