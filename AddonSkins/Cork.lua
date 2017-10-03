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

	-- tooltip
	local function skinTooltip(tt)
		aObj:addSkinFrame{obj=tt}
	end
	self:SecureHook(_G.Corkboard, "Show", function(this)
		skinTooltip(this)
	end)

end
