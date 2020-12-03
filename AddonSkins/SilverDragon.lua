local _, aObj = ...
if not aObj:isAddonEnabled("SilverDragon") then return end
local _G = _G

aObj.addonsToSkin.SilverDragon = function(self) -- v 90002.3

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
			aObj:skinObject("button", {obj=frame, sabt=true, x1=24, y1=-16, x2=0, y2=20})
			if aObj.modBtns then
				aObj:skinCloseButton{obj=frame.close, noSkin=true}
			end
			skinPopup = nil
		end
		if not ct.popup then
			self:SecureHook(ct, "CreatePopup", function(this)
				skinPopup(this.popup)

				self:Unhook(this, "CreatePopup")
			end)
		else
			skinPopup(ct.popup)
		end
		ct = nil
	end

end
