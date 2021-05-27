local _, aObj = ...
if not aObj:isAddonEnabled("EveryGoldToBanker") then return end
local _G = _G

aObj.addonsToSkin.EveryGoldToBanker = function(self) -- v 1.0.10

	self:SecureHookScript(_G.EveryGoldToBankerCalculator, "OnShow", function(this)
		self:adjHeight{obj=_G.AmountEditBox, adj=-6}
		self:skinObject("editbox", {obj=_G.AmountEditBox})
		self:adjHeight{obj=_G.RecipientEditBox, adj=-6}
		self:skinObject("editbox", {obj=_G.RecipientEditBox})
		self:skinObject("frame", {obj=_G.TitleFrame, kfs=true, fb=true, ofs=-4, clr="gold"})
		self:skinObject("frame", {obj=_G.AmountFrame, kfs=true, fb=true, ofs=-4})
		self:skinObject("frame", {obj=_G.ResponseFrame, kfs=true, fb=true, ofs=-4})
		self:skinObject("frame", {obj=_G.RecipientFrame, kfs=true, fb=true, ofs=-4})
		self:skinObject("frame", {obj=_G.DefaultRecipientFrame, kfs=true, fb=true, ofs=-4})
		self:skinObject("frame", {obj=_G.DefaultAmountFrame, kfs=true, fb=true, ofs=-4})
		self:skinObject("frame", {obj=_G.SettingFrame, kfs=true, ofs=0})
		self:adjHeight{obj=_G.DefaultRecipientEditBox, adj=-6}
		self:skinObject("editbox", {obj=_G.DefaultRecipientEditBox})
		self:adjHeight{obj=_G.DefaultAmountEditBox, adj=-6}
		self:skinObject("editbox", {obj=_G.DefaultAmountEditBox})
		self:skinObject("frame", {obj=this, kfs=true, ofs=0})
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
