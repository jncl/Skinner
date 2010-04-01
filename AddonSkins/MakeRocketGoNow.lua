if not Skinner:isAddonEnabled("MakeRocketGoNow") then return end

function Skinner:MakeRocketGoNow()

	for _, child in pairs{UIParent:GetChildren()} do
		if child:IsObjectType("Button")
		and child:GetName() == nil
		then
			if child.GetBackdropColor then
				local r, g, b ,a = child:GetBackdropColor()
				if r and r > 0 then
					r = format("%.2f", r)
					g = format("%.2f", g)
					b = format("%.2f", b)
					a = format("%.1f", a)
					if r == "0.09" and g == "0.09" and b == "0.19" and a == "0.5" then
						self:applySkin(child)
						child:SetFrameLevel(child:GetFrameLevel() + 5)
						break
					end
				end
			end
		end
	end

end
