local _, aObj = ...
if not aObj:isAddonEnabled("SilverDragon") then return end
local _G = _G

aObj.addonsToSkin.SilverDragon = function(self) -- v2024.1.1

	local SD = _G.LibStub("AceAddon-3.0"):GetAddon("SilverDragon", true)

	if SD then
		self:RawHook(SD, "GetDebugWindow", function(this)
			local frame = self.hooks[this].GetDebugWindow()
			self:skinTextDump(frame)
			self:Unhook(this, "GetDebugWindow")
			return frame
		end, true)
		self:RawHook(SD.NAMESPACE.Tooltip, "Get", function(this, name)
			local tooltip = self.hooks[this].Get(this, name)
			if not _G.tContains(self.ttList, tooltip) then
				_G.C_Timer.After(0.1, function()
					self:add2Table(self.ttList, tooltip)
				end)
			end
			return tooltip
		end, true)
		local ct = SD:GetModule("ClickTarget", true)
		if ct then
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
			if self.isRtl then
				self:skinObject("frame", {obj=ct.anchor, kfs=true, ofs=0})
				if self.modBtns then
					self:skinCloseButton{obj=self:getChild(ct.anchor, 1), noSkin=true}
				end
				local name, i = "SilverDragonPopupButton", 1
				self:SecureHook(ct, "CreatePopup", function(_)
					while _G[name] do
						skinPopup(_G[name])
						name = name .. i
						i = i + 1
					end
				end)
			end
		end
		local ol = SD:GetModule("Overlay", true)
		if ol then
			_G.C_Timer.After(0.1, function()
				self:add2Table(self.ttList, ol.tooltip)
			end)
		end
	end

end
