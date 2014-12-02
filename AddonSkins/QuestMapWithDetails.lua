local aName, aObj = ...
if not aObj:isAddonEnabled("QuestMapWithDetails") then return end
local _G = _G

function aObj:QuestMapWithDetails()

	self:moveObject{obj=_G.QuestMapFrame.DetailsFrame.AbandonButton, x=10, y=0}
	self:addSkinFrame{obj=_G.QuestMapFrame.DetailsFrame, x1=0, y1=71, x2=48, y2=-5}

end
