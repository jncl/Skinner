local aName, aObj = ...
if not aObj:isAddonEnabled("Simulationcraft") then return end
local _G = _G

aObj.addonsToSkin.Simulationcraft = function(self) -- v1.8.2/9.0.1-alpha-10

	if _G.SimcCopyFrame then
		self:skinSlider{obj=_G.SimcCopyFrameScroll.ScrollBar}
		self:addSkinFrame{obj=_G.SimcCopyFrame, x2=2}
	else
		self:SecureHook(_G.LibStub:GetLibrary("AceAddon-3.0"):GetAddon("Simulationcraft", true), "PrintSimcProfile", function(this, ...)
			self:skinSlider{obj=_G.SimcScrollFrame.ScrollBar}
			self:addSkinFrame{obj=_G.SimcFrame, ft="a", kfs=true, nb=true}
			if self.modBtns then
				self:skinStdButton{obj=_G.SimcFrameButton}
			end

			self:Unhook(this, "PrintSimcProfile")
		end)
	end

end
