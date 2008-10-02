
function Skinner:BugSack()

	self:applySkin(BugSackFrame, nil, nil, nil, 200)
	self:moveObject(BugSackFrameScroll, nil, nil, "-", 4)
	local yOfs = 8
	self:moveObject(BugSackFrameButton, nil, nil, "-", yOfs)
	self:moveObject(BugSackPrevButton, nil, nil, "-", yOfs)
	self:moveObject(BugSackNextButton, nil, nil, "-", yOfs)
	self:moveObject(BugSackFirstButton, nil, nil, "-", yOfs)
	self:moveObject(BugSackLastButton, nil, nil, "-", yOfs)
	self:skinScrollBar(BugSackFrameScroll)

end
