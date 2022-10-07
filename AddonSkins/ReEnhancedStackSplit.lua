local _, aObj = ...
if not aObj:isAddonEnabled("ReEnhancedStackSplit")
and not aObj:isAddonEnabled("EnhancedStackSplit")
then
	return
end
local _G = _G

local function skinEnhancedStackSplit()

	aObj.RegisterCallback("ReEnhancedStackSplit", "StackSplit_skinned", function(_)
		-- hook these to show/hide stack split value
		if _G.StackSplitFrame.OkayButton then
			_G.StackSplitFrame.OkayButton:HookScript("OnShow", function(_) _G.StackSplitFrame.StackSplitText:Show() end)
			_G.StackSplitFrame.OkayButton:HookScript("OnHide", function(_) _G.StackSplitFrame.StackSplitText:Hide() end)
		else
			_G.StackSplitOkayButton:HookScript("OnShow", function(_) _G.StackSplitText:Show() end)
			_G.StackSplitOkayButton:HookScript("OnHide", function(_) _G.StackSplitText:Hide() end)
		end

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
		if _G.EnhancedStackSplit_Options.XLmode then
			_G.StackSplitFrame.sf:SetPoint("BOTTOMRIGHT", _G.StackSplitFrame, "BOTTOMRIGHT", 0, -45)
		else
			_G.StackSplitFrame.sf:SetPoint("BOTTOMRIGHT", _G.StackSplitFrame, "BOTTOMRIGHT", 0, -24)
		end
		if aObj:isAddonEnabled("ReEnhancedStackSplit") then
			_G.StackSplitFrame.sf:SetPoint("TOPLEFT", _G.StackSplitFrame, "TOPLEFT", 2, 2)
		end
		-- hook this to handle XL mode by resizing skinFrame
		aObj:SecureHookScript(_G.EnhancedStackSplitXLModeButton, "OnClick", function(_)
			if _G.Round(_G.EnhancedStackSplitBottomTextureFrame:GetHeight()) == 30 then
				_G.StackSplitFrame.sf:SetPoint("BOTTOMRIGHT", _G.StackSplitFrame, "BOTTOMRIGHT", 0, -45)
			else
				_G.StackSplitFrame.sf:SetPoint("BOTTOMRIGHT", _G.StackSplitFrame, "BOTTOMRIGHT", 0, -24)
			end
		end)
	end)

end

if aObj:isAddonEnabled("ReEnhancedStackSplit") then
	aObj.addonsToSkin.ReEnhancedStackSplit = function(self) -- v 9.0.2
		if not self.db.profile.StackSplit then return end

		skinEnhancedStackSplit()

	end
else
	aObj.addonsToSkin.EnhancedStackSplit = function(self) -- v 60100-1
		if not self.db.profile.StackSplit then return end

		skinEnhancedStackSplit()

	end
end
