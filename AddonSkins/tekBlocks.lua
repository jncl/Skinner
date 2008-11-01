
function Skinner:tekBlocks(...)

--	self:Debug("tekBlocks:[%s, %s, %s]", select(1, ...) or "nil", select(2, ...) or "nil", select(3, ...) or "nil")
	
	-- skin any existing data objects
	for i = 1, select("#", UIParent:GetChildren()) do
		local child = select(i, UIParent:GetChildren())
		if child:IsObjectType("Button") and not child.skinned and child.GetBackdrop and child.IconUpdate then
			child:SetWidth(child:GetWidth() + 6)
			Skinner:applySkin(child)
			child.skinned = true
		end
	end
	
end

--	register for LDB callback when a new dataobject is created and tekBlocks is loaded
LibStub("LibDataBroker-1.1").RegisterCallback(Skinner, "LibDataBroker_DataObjectCreated", "tekBlocks")
--Skinner:Debug("Registered LDB callback for tekBlocks")
