local _, aObj = ...
if not aObj:isAddonEnabled("Simulationcraft") then return end
local _G = _G

aObj.addonsToSkin.Simulationcraft = function(self) -- v 11.1.7-01

	local sc = _G.LibStub:GetLibrary("AceAddon-3.0"):GetAddon("Simulationcraft", true)

	if sc then
		self:RawHook(sc, "GetMainFrame", function(this, text)
			local frame = self.hooks[this].GetMainFrame(this, text)
			self:skinObject("slider", {obj=_G.SimcScrollFrame.ScrollBar})
			self:skinObject("frame", {obj=frame, kfs=true})
			if self.modBtns then
				self:skinStdButton{obj=_G.SimcFrameButton}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=_G.AutomaticClose}
			end
			self:Unhook(this, "GetMainFrame")
			return frame
		end, true)
	end

end
