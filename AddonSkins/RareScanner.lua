local aName, aObj = ...
if not aObj:isAddonEnabled("RareScanner") then return end
local _G = _G

aObj.addonsToSkin.RareScanner = function(self) -- v 5.6.2

	-- scanner_button
	_G.scanner_button:DisableDrawLayer("BACKGROUND")
	_G.scanner_button:DisableDrawLayer("BORDER")
	self:addSkinFrame{obj=_G.scanner_button, ft="a", kfs=true, nb=true}
	if self.modBtns then
		self:skinCloseButton{obj=_G.scanner_button.CloseButton}
		self:skinStdButton{obj=_G.scanner_button.FilterDisabledButton, as=true}
		_G.scanner_button.FilterDisabledButton:GetNormalTexture():SetAlpha(1)
		self:skinStdButton{obj=_G.scanner_button.FilterEnabledButton, as=true}
		_G.scanner_button.FilterEnabledButton:GetNormalTexture():SetAlpha(1)
	end

	-- Registry Window
		-- buttons

	-- tooltips
	_G.C_Timer.After(0.1, function()
		self:add2Table(self.ttList, _G.scanner_button.LootBar.LootBarToolTip)
		self:add2Table(self.ttList, _G.scanner_button.LootBar.LootBarToolTipComp1)
		self:add2Table(self.ttList, _G.scanner_button.LootBar.LootBarToolTipComp2)
		self:add2Table(self.ttList, _G.RSMapItemToolTip)
		self:add2Table(self.ttList, _G.RSMapItemToolTipComp1)
		self:add2Table(self.ttList, _G.RSMapItemToolTipComp2)
	end)

	-- Config
	self.aboutPanels["RareScanner"] = true

end
