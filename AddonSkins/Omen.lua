local _, aObj = ...
if not aObj:isAddonEnabled("Omen") then return end
local _G = _G

aObj.addonsToSkin.Omen = function(self) -- v 3.2.4

	_G.Omen.db.profile.Bar.Texture = self.db.profile.StatusBar.texture
	_G.Omen.UpdateBackdrop = _G.nop

	self:skinObject("frame", {obj=_G.Omen.Title, kfs=true})
	self:skinObject("frame", {obj=_G.Omen.BarList, kfs=true})

end
