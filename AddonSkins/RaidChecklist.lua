if not Skinner:isAddonEnabled("RaidChecklist") then return end

function Skinner:RaidChecklist()

	self:addButtonBorder{obj=RaidChecklist.button}--, x1=-1, y1=1, x2=1, y2=-1}
	self:addSkinFrame{obj=RaidChecklistList}
	self:addSkinFrame{obj=RaidChecklistMissing}

end
