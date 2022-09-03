local _, aObj = ...
if not aObj:isAddonEnabled("ColorPickerPlus") then return end
local _G = _G

aObj.addonsToSkin.ColorPickerPlus = function(self) -- r 48

	if self.isRtl then
		self:keepFontStrings(_G.ColorPPHeaderTitle)
		self:moveObject{obj=_G.ColorPPHeaderTitle, y=-4}
	end

	if self.modBtns then
		self:skinStdButton{obj=_G.ColorPPCopy}
		self:skinStdButton{obj=_G.ColorPPPaste}
		self:skinOtherButton{obj=_G.ColorPPSwitcher, text="@", noSkin=true}
	end

end
