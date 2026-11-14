local _, aObj = ...
if not aObj:isAddonEnabled("AddonFactory") then return end
local _G = _G

aObj.addonsToSkin.AddonFactory = function(self) -- v 2026.10.14

	self:add2Table(self.ttList, "a", _G.AddonFactory_Tooltip)

end
