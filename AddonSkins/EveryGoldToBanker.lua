local _, aObj = ...
if not aObj:isAddonEnabled("EveryGoldToBanker") then return end
local _G = _G

aObj.addonsToSkin.EveryGoldToBanker = function(self) -- v 1.0.10

	self:SecureHookScript(_G.EveryGoldToBankerCalculator, "OnShow", function(this)
		self:skinObject("editbox", {obj=_G.AmountEditBox, y1=-4, y2=4})
		self:skinObject("editbox", {obj=_G.RecipientEditBox, y1=-4, y2=4})
		self:skinObject("frame", {obj=_G.TitleFrame, kfs=true, fb=true, ofs=-6, clr="gold"})
		self:keepFontStrings(_G.AmountFrame)
		self:keepFontStrings(_G.DefaultAmountFrame)
		self:keepFontStrings(_G.ResponseFrame)
		self:keepFontStrings(_G.RecipientFrame)
		self:keepFontStrings(_G.DefaultRecipientFrame)
		self:skinObject("frame", {obj=_G.SettingFrame, kfs=true, ofs=-4, y1=-6})
		self:skinObject("editbox", {obj=_G.DefaultRecipientEditBox, y1=-4, y2=4})
		self:skinObject("editbox", {obj=_G.DefaultAmountEditBox, y1=-4, y2=4})
		self:skinObject("frame", {obj=this, kfs=true, ofs=-4})
		if self.modBtns then
			self:skinCloseButton{obj=_G.MinimizeButton, noSkin=true}
			self:skinStdButton{obj=_G.CheckButton}
			self:skinStdButton{obj=_G.SendButton}
			self:skinStdButton{obj=_G.SettingButton}
			self:skinStdButton{obj=_G.DoneSettingButton}
		end

		self:Unhook(this, "OnShow")
	end)

end
