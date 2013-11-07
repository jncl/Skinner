local aName, aObj = ...
if not aObj:isAddonEnabled("Cork") then return end
local _G = _G

function aObj:Cork()

	-- skin the anchor button
	self.RegisterCallback("Cork", "UIParent_GetChildren", function(this, child)
		if child:IsObjectType("Button")
		and child:GetName() == nil
		and self:getInt(child:GetHeight()) == 24
		and not child.sf
		then
			local r, g, b ,a = child:GetBackdropBorderColor()
			if r
			and r > 0
			then
				r = _G.format("%.1f", r)
				g = _G.format("%.1f", g)
				b = _G.format("%.1f", b)
				a = _G.format("%.1f", a)
				if r == "0.5"
				and g == "0.5"
				and b == "0.5"
				and a == "1.0"
				then
					self:addSkinFrame{obj=child}
					self.UnregisterCallback("Cork", "UIParent_GetChildren")
				end
			end
		end
	end)

	-- skin the Corkboard (tooltip)
	self:SecureHook(_G.Corkboard, "Show", function(this, ...)
		self:applySkin(_G.Corkboard)
	end)
	self:applySkin(_G.Corkboard)

end
