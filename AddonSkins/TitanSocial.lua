local _, aObj = ...
if not aObj:isAddonEnabled("TitanSocial") then return end
local _G = _G

aObj.addonsToSkin.TitanSocial = function(self) -- v 7.3.0

	-- find the tooltip frame and skin it
	self.RegisterCallback("TitanSocial", "UIParent_GetChildren", function(_, child)
		if child.lines
		and child.columns
		and child.scrollframe
		and child.scrollchild
		then
			self:add2Table(self.ttList, child)
			self.UnregisterCallback("TitanSocial", "UIParent_GetChildren")
		end
	end)
	self:scanUIParentsChildren()

end
