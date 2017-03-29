local aName, aObj = ...
if not aObj:isAddonEnabled("SilverDragon") then return end
local _G = _G

function aObj:SilverDragon()

	local ct = _G.LibStub("AceAddon-3.0"):GetAddon("SilverDragon"):GetModule("ClickTarget")
	if ct then
		ct.popup.title:SetTextColor(self.HTr, self.HTg, self.HTb)
		ct.popup.source:SetTextColor(self.BTr, self.BTg, self.BTb)
		ct.popup.status:SetTextColor(self.BTr, self.BTg, self.BTb)
		ct.popup:DisableDrawLayer("BORDER")
		self:skinButton{obj=ct.popup.close, cb=true}
		self:addSkinFrame{obj=ct.popup, kfs=true, nb=true, x1=20, y1=-12, x2=2, y2=15}
	end

end
