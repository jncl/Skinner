local aName, aObj = ...
if not aObj:isAddonEnabled("WhatsTraining") then return end
local _G = _G

aObj.addonsToSkin.WhatsTraining = function(self) -- v 1.6.1

	-- WhatsTrainingFrame
	_G.WhatsTrainingFrame:DisableDrawLayer("ARTWORK")
	self:skinSlider{obj=_G.WhatsTrainingFrame.scrollBar.ScrollBar, rt="artwork"}

	-- hook these to hide/show Page buttons
	self:SecureHookScript(_G.WhatsTrainingFrame, "OnShow", function(this)
		_G.SpellBookPageText:Hide()
		_G.SpellBookPrevPageButton:Hide()
		_G.SpellBookNextPageButton:Hide()
	end)
	self:SecureHookScript(_G.WhatsTrainingFrame, "OnHide", function(this)
		_G.SpellBookPageText:Show()
		_G.SpellBookPrevPageButton:Show()
		_G.SpellBookNextPageButton:Show()
	end)

	-- tooltip
	_G.C_Timer.After(0.1, function()
		self:add2Table(self.ttList, _G.WhatsTrainingTooltip)
	end)

end
