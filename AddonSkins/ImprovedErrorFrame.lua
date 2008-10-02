
function Skinner:ImprovedErrorFrame()

	self:applySkin(ImprovedErrorFrameCloseButton)
	self:applySkin(ImprovedErrorFrameFrame)

	self:removeRegions(ScriptErrorsScrollFrameOne)
	self:skinScrollBar(ScriptErrorsScrollFrameOne)

end
