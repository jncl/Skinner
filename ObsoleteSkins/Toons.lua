
function Skinner:Toons()

	if not self.db.profile.FriendsFrame then return end

	-- skin the Tab
	self:keepRegions(FriendsFrameTab5, {7,8}) -- N.B. these regions are text
	self:moveObject(FriendsFrameTab5, "+", 9, nil, nil)

	self:applySkin(FriendsFrameTab5)

	self:moveObject(ToonsFrameHorizontalBarLeft, "-", 5, nil, nil)

	self:moveObject(ToonsFrameDeleteButton, "-", 10, "-", 75)
	self:moveObject(ToonsFrameTotalPlayedText, "+", 25, "-", 75)
	self:moveObject(ToonsFrameMoneyFrame, "+", 25, "-", 75)

	self:applySkin(ToonsFrame)

end
