function Skinner:FramesResized_TalentUI()

	PlayerTalentFrame:SetHeight(PlayerTalentFrame:GetHeight() + 26)

	PlayerTalentFrameBackgroundBottomLeft:SetHeight(384)
	PlayerTalentFrameBackgroundBottomRight:SetHeight(384)
	
	self:removeRegions(PlayerTalentFrame_MidTextures)
	self:removeRegions(PlayerTalentFrameScrollFrame_MidTextures)

	self:moveObject(PlayerTalentFrameTalentPointsText, "-", 10, "+", 107)
	self:moveObject(PlayerTalentFrameCancelButton, "-", 18, "+", 65)

end
