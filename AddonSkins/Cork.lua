local aName, aObj = ...
if not aObj:isAddonEnabled("Cork") then return end

function aObj:Cork()

	-- skin the anchor button
	for _, child in pairs{UIParent:GetChildren()} do
		if child:IsObjectType("Button")
		and child:GetName() == nil
		and ceil(child:GetHeight()) == 24
		and child.GetBackdropBorderColor
		and not self.skinFrame[child]
		then
			local r, g, b ,a = child:GetBackdropBorderColor()
			if r and r > 0 then
				r = format("%.1f", r)
				g = format("%.1f", g)
				b = format("%.1f", b)
				a = format("%.1f", a)
				print(child, r, g, b, a)
				if r == "0.5" and g == "0.5" and b == "0.5" and a == "1.0" then
					self:addSkinFrame{obj=child}
					break
				end
			end
		end
	end
	-- skin the Corkboard (tooltip)
	self:SecureHook(Corkboard, "Show", function(this, ...)
		self:applySkin(Corkboard)
	end)
	self:applySkin(Corkboard)

end
