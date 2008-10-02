function Skinner:FramesResized_TalentUI()

	PlayerTalentFrame:SetHeight(PlayerTalentFrame:GetHeight() + 26)

	self:removeRegions(TalentFrame_MidTextures)
	self:removeRegions(TalentFrameScrollFrame_MidTextures)

	self:moveObject(PlayerTalentFrameTalentPointsText, "-", 10, "-", 7)
	self:moveObject(PlayerTalentFrameCancelButton, "-", 18, "+", 18)

end
