
function Skinner:Factionizer()
	if not self.db.profile.CharacterFrames then return end

-->>--	Options Button
	self:moveObject(FIZ_OrderByStandingCheckBox, "-", 60, "+", 16)
	self:moveObject(FIZ_OptionsButton, nil, nil, "+", 16)
-->>--	Reputation Detail Frame
	FIZ_ReputationDetailFrame:SetHeight(FIZ_ReputationDetailFrame:GetHeight() - 8)
	self:keepFontStrings(FIZ_ReputationDetailFrame)
	self:moveObject(FIZ_ReputationDetailFrame, "+", 30, "+", 28)
	self:keepFontStrings(FIZ_UpdateListScrollFrame)
	self:skinScrollBar(FIZ_UpdateListScrollFrame)
	self:applySkin(FIZ_ReputationDetailFrame)
-->>--	Options Frame
	FIZ_OptionsFrame:SetWidth(FIZ_OptionsFrame:GetWidth() * self.FxMult)
	FIZ_OptionsFrame:SetHeight(FIZ_OptionsFrame:GetHeight() * self.FyMult)
	self:keepFontStrings(FIZ_OptionsFrame)
	self:moveObject(FIZ_OptionsFrame, "+", 28, nil, nil)
	self:moveObject(FIZ_OptionsFrameTitle, nil, nil, "-", 6)
	self:applySkin(FIZ_OptionsFrame)

end
