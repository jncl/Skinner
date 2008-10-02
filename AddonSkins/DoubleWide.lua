
function Skinner:DoubleWide()

	QuestLogFrame:SetWidth(QuestLogFrame:GetWidth() + 10)
	self:moveObject(QuestLogDetailScrollFrame, "-", 20, nil, nil)

end
