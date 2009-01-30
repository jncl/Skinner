
function Skinner:MakeRocketGoNow()

	for i = 1, UIParent:GetNumChildren() do
		local child = select(i, UIParent:GetChildren())
		if child:IsObjectType("Button") and child:GetName() == nil then
			if child.GetBackdropColor then
				local r, g, b ,a = child:GetBackdropColor()
				if r and r > 0 then
					r = string.format("%.2f", r)
					g = string.format("%.2f", g)
					b = string.format("%.2f", b)
					a = string.format("%.1f", a)
--					self:Debug("MakeRocketGoNow: [%s, %s, %s, %s]", r, g, b, a)
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
