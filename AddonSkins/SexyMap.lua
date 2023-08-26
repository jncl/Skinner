local _, aObj = ...
if not aObj:isAddonEnabled("SexyMap") then return end
local _G = _G

aObj.addonsToSkin.SexyMap = function(self) -- v10.0.10

	-- tooltip
	if self:isAddOnLoaded("SexyMap") then
		self:add2Table(self.ttList, "SexyMapZoneTextTooltip")
	end

end
