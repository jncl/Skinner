
function Skinner:HoloFriends()

-->>--	HoloFriends Frame
	self:moveObject(HoloFriendsShowOfflineButton, nil, nil, "+", 5)
	self:keepRegions(HoloFriendsDropDown, {4,5}) -- N.B. regions 4 & 5 are text
	self:keepRegions(HoloFriendsFrameToggleTab1, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
	self:keepRegions(HoloFriendsFrameToggleTab2, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
	if self.db.profile.TexturedTab then
		self:applySkin(HoloFriendsFrameToggleTab1, nil, 0, 1)
		self:moveObject(HoloFriendsFrameToggleTab1Highlight, "-", 5, "+", 5)
	else self:applySkin(HoloFriendsFrameToggleTab1) end
	if self.db.profile.TexturedTab then
		self:applySkin(HoloFriendsFrameToggleTab2, nil, 0, 1)
		self:moveObject(HoloFriendsFrameToggleTab2Highlight, "-", 5, "+", 5)
	else self:applySkin(HoloFriendsFrameToggleTab2) end
	self:removeRegions(HoloFriendsScrollFrame)
	self:skinScrollBar(HoloFriendsScrollFrame)
	self:moveObject(HoloFriendsOnline, "-", 5, "-", 35)
	self:moveObject(HoloFriendsAddFriendButton, "-", 5, "-", 35)

-->>--	HoloIgnore Frame
	self:keepRegions(HoloIgnoreDropDown, {4,5}) -- N.B. regions 4 & 5 are text
	self:keepRegions(HoloIgnoreFrameToggleTab1, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
	self:keepRegions(HoloIgnoreFrameToggleTab2, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
	if self.db.profile.TexturedTab then self:applySkin(HoloIgnoreFrameToggleTab1, nil, 0, 1)
	else self:applySkin(HoloIgnoreFrameToggleTab1) end
	if self.db.profile.TexturedTab then self:applySkin(HoloIgnoreFrameToggleTab2, nil, 0, 1)
	else self:applySkin(HoloIgnoreFrameToggleTab2) end
	self:removeRegions(HoloIgnoreScrollFrame)
	self:skinScrollBar(HoloIgnoreScrollFrame)
	self:moveObject(HoloIgnoreAddIgnoreButton, "-", 5, "-", 35)

-->>--	Share Frame
	HoloFriendsShareFrame:SetWidth(HoloFriendsShareFrame:GetWidth() * self.FxMult)
	self:moveObject(HoloFriendsShareFrameButtonXClose, "+", 14, "+", 4)
	self:moveObject(HoloFriendsShareFrameButtonShare, "+", 16, "-", 4)
	self:moveObject(HoloFriendsShareFrameButtonClose, "+", 16, "-", 4)
	self:moveObject(HoloFriendsShareCharDropDown, nil, nil, "+", 20)
	self:keepRegions(HoloFriendsShareCharDropDown, {4,5})
	self:moveObject(HoloFriendsShareSourceScrollFrame, nil, nil, "+", 20)
	self:keepRegions(HoloFriendsShareSourceScrollFrame, {})
	self:skinScrollBar(HoloFriendsShareSourceScrollFrame)
	self:keepRegions(HoloFriendsShareSourceScrollBg, {2})
	r, g, b, a = HoloFriendsShareSourceScrollBg:GetBackdropColor()
	HoloFriendsShareSourceScrollBg:SetBackdropColor(r, g, b, 0)
	self:moveObject(HoloFriendsShareTargetScrollFrame, "+", 20, "+", 20)
	self:keepRegions(HoloFriendsShareTargetScrollFrame, {})
	self:skinScrollBar(HoloFriendsShareTargetScrollFrame)
	self:keepRegions(HoloFriendsShareTargetScrollBg, {2})
	r, g, b, a = HoloFriendsShareTargetScrollBg:GetBackdropColor()
	HoloFriendsShareTargetScrollBg:SetBackdropColor(r, g, b, 0)
	self:moveObject(HoloFriendsShareFrameNotice, "-", 5, "+", 20)
	self:keepRegions(HoloFriendsShareFrame, {6,7})
	self:applySkin(HoloFriendsShareFrame, nil)

end
