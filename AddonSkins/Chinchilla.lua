local _, aObj = ...
if not aObj:isAddonEnabled("Chinchilla") then return end
local _G = _G

aObj.addonsToSkin.Chinchilla = function(self) -- v 2.10.2

	local Chinchilla = _G.LibStub:GetLibrary("AceAddon-3.0"):GetAddon("Chinchilla", true)

	local locn = Chinchilla:GetModule("Location", true)
	if locn then
		self:skinObject("frame", {obj=_G.Chinchilla_Location_Frame, ofs=0})
		if self.modBtns then
			self:skinOtherButton{obj=_G.Chinchilla_Location_Frame.closeButton, font=self.fontS, text=self.uparrow, y1=-2, y2=6}
			self:SecureHookScript(_G.Chinchilla_Location_Frame.closeButton, "OnClick", function(this)
				aObj:Debug("OnClick: [%s, %s]", this, _G.Minimap:IsShown())
				if _G.Minimap:IsShown() then
					this:SetText(self.uparrow)
				else
					this:SetText(self.downarrow)
				end
			end)
		end
		locn = nil
	end

	local expd = Chinchilla:GetModule("Expander", true)
	if expd then
		self:removeRegions(_G.TimeManagerClockButton, {1})
		self:skinObject("button", {obj=_G.TimeManagerClockButton})
		expd = nil
	end

end
