local _, aObj = ...
if not aObj:isAddonEnabled("SilverDragon") then return end
local _G = _G

aObj.addonsToSkin.SilverDragon = function(self) -- v 90005.0

	local ct = _G.LibStub("AceAddon-3.0"):GetAddon("SilverDragon"):GetModule("ClickTarget")
	if ct then
		self:skinObject("frame", {obj=ct.anchor, kfs=true, ofs=0})
		if self.modBtns then
			self:skinCloseButton{obj=self:getChild(ct.anchor, 1), noSkin=true}
		end
		local function skinPopup(frame)
			frame.title:SetTextColor(aObj.HT:GetRGB())
			frame.source:SetTextColor(aObj.BT:GetRGB())
			frame.status:SetTextColor(aObj.BT:GetRGB())
			frame:DisableDrawLayer("BORDER")
			aObj:skinObject("button", {obj=frame, sec=true, x1=26, y1=-18, x2=-8, y2=20})
			if aObj.modBtns then
				aObj:skinCloseButton{obj=frame.close, noSkin=true}
			end
		end
		if _G.SilverDragonPopupButton then
			skinPopup(_G.SilverDragonPopupButton)
		end
		local name, i = "SilverDragonPopupButton", 1
		self:SecureHook(ct, "CreatePopup", function(_)
			while _G[name] do
				skinPopup(_G[name])
				name = name .. i
				i = i + 1
			end
		end)
		ct = nil
	end

end
