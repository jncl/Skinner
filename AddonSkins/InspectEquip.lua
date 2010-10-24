if not Skinner:isAddonEnabled("InspectEquip") then return end

function Skinner:InspectEquip()

	self:addSkinFrame{obj=InspectEquip_InfoWindow}

end
