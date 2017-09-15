local aName, aObj = ...
if not aObj:isAddonEnabled("Simulationcraft") then return end
local _G = _G

aObj.addonsToSkin.Simulationcraft = function(self) -- v1.8.2

	self:skinSlider{obj=_G.SimcCopyFrameScroll.ScrollBar}
	self:addSkinFrame{obj=_G.SimcCopyFrame, x2=2}

end
