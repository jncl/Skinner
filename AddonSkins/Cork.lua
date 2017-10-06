local aName, aObj = ...
if not aObj:isAddonEnabled("Cork") then return end
local _G = _G

aObj.addonsToSkin.Cork = function(self) -- v 7.1.0.62-Beta

	-- anchor
	self.RegisterCallback("Cork", "UIParent_GetChildren", function(this, child)
		if child:IsObjectType("Button")
		and self:getInt(child:GetHeight()) == 24
		then
			self:addSkinFrame{obj=child, kfs=true, x1=-2}
			self.UnregisterCallback("Cork", "UIParent_GetChildren")
		end
	end)

	-- tooltip (Corkboard)
	_G.C_Timer.After(0.1, function()
		self:add2Table(self.ttList, _G.Corkboard)
	end)

end
