if not Skinner:isAddonEnabled("SayGMOTD") then return end

function Skinner:SayGMOTD()

	local frame
	for _, child in pairs{UIParent:GetChildren()} do
		if child.button
		and child.header
		and child.text
		then
			self:addSkinFrame{obj=child, x1=0, y1=-10, x2=-10, y2=0}
			break
		end
	end

end
