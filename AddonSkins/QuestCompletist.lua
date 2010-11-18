local aName, aObj = ...
if not aObj:isAddonEnabled("QuestCompletist") then return end

function aObj:QuestCompletist()

	self:adjWidth{obj=qcMenuSlider, adj=-12}
	self:skinSlider{obj=qcMenuSlider}
	self:addSkinFrame{obj=frameQuestCompletist, kfs=true, x1=10, y1=-12, x2=-32, y2=71}

end
