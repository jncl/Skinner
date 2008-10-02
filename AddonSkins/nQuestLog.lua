
function Skinner:nQuestLog()

	self:applySkin(nQuestLogFrame)
	self:Hook(nQuestLogFrame, "SetBackdrop", function() end, true)
	self:Hook(nQuestLogFrame, "SetBackdropColor", function() end, true)
	self:Hook(nQuestLogFrame, "SetBackdropBorderColor", function() end, true)

end
