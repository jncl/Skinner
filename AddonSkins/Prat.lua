
function Skinner:Prat()
	self:removeRegions(PratWhoScrollFrame)
	self:skinScrollBar(PratWhoScrollFrame)
	self:applySkin(PratWhoFrame)
	self:removeRegions(PratWhoFrame, {1, 2})

	self:removeRegions(PratCCFrameScroll)
	self:skinScrollBar(PratCCFrameScroll)
	self:applySkin(PratCCFrame)
end
