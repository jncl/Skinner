local aName, aObj = ...
if not aObj:isAddonEnabled("AppearanceTooltip") then return end
local _G = _G

aObj.addonsToSkin.AppearanceTooltip = function(self) -- v 23

	-- tooltip
	_G.AppearanceTooltipTooltip:DisableDrawLayer("BACKGROUND")
	_G.C_Timer.After(0.1, function()
		self:add2Table(self.ttList, _G.AppearanceTooltipTooltip)
	end)

end
