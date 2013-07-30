local aName, aObj = ...
if not aObj:isAddonEnabled("SilverDragon") then return end
local _G = _G

function aObj:SilverDragon()

	local ct = _G.LibStub("AceAddon-3.0"):GetAddon("SilverDragon"):GetModule("ClickTarget")
	if ct then
		ct.popup.details:SetTextColor(self.BTr, self.BTg, self.BTb)
		ct.popup.subtitle:SetTextColor(self.BTr, self.BTg, self.BTb)
		self:skinButton{obj=ct.popup.close, cb=true}
		self:addSkinFrame{obj=ct.popup, kfs=true, nb=true}
	end

end
