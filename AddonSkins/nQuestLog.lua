
function Skinner:nQuestLog()

	self:applySkin(nQuestLogFrame)
	self:RawHook(nQuestLogFrame, "SetBackdrop", function() end, true)
	self:RawHook(nQuestLogFrame, "SetBackdropColor", function() end, true)
	self:RawHook(nQuestLogFrame, "SetBackdropBorderColor", function() end, true)

end
