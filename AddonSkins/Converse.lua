
function Skinner:Converse()

	self:removeRegions(ConverseFrame, {1,2,3,4,5,6,7})
	self:applySkin(ConverseFrame)
	self:moveObject(ConverseFrameCloseButton, nil, nil, "+", 10)
	self:removeRegions(ConverseFrameItemsScrollFrame)
	self:skinScrollBar(ConverseFrameItemsScrollFrame)
	self:removeRegions(ConverseFrameHistoryScrollFrame)
	self:skinScrollBar(ConverseFrameHistoryScrollFrame)
	self:removeRegions(ConverseFrameLinksPanel, {1,2})
	self:applySkin(ConverseFrameLinksPanel)
	self:skinEditBox(ConverseFrameAltEditFrameText)

end
