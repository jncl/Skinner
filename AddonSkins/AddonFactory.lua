local _, aObj = ...
if not aObj:isAddonEnabled("AddonFactory") then return end
local _G = _G

aObj.addonsToSkin.AddonFactory = function(self) -- v 1

	self:add2Table(self.ttList, _G.AddonFactory_Tooltip)

end
