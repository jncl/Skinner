
function Skinner:BugSack()

	self:skinScrollBar{obj=BugSackFrameScroll}
	self:skinAllButtons(BugSackFrame)
	self:addSkinFrame{obj=BugSackFrame, kfs=true, y2=8}

end
