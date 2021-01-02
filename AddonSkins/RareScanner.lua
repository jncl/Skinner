local _, aObj = ...
if not aObj:isAddonEnabled("RareScanner") then return end
local _G = _G

aObj.addonsToSkin.RareScanner = function(self) -- v 9.0.2.7

	self:skinObject("frame", {obj=_G.scanner_button, kfs=true, cbns=true})
	if self.modBtns then
		self:skinOtherButton{obj=_G.scanner_button.FilterDisabledButton, text=self.modUIBtns.minus, noSkin=true}
		self:skinOtherButton{obj=_G.scanner_button.FilterEnabledButton, text=self.modUIBtns.plus, noSkin=true}
	end

	-- WorldMapOverlayFrame
	for _, frame in _G.pairs(_G.WorldMapFrame.overlayFrames) do
		if frame.EditBox then
			self:skinObject("editbox", {obj=frame.EditBox, ofs=0})
			self:adjHeight{obj=frame.EditBox, adj=-10}
		end
	end

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
