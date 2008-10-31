
function Skinner:Analyst()

	self:keepFontStrings(EconomyFrame)
	EconomyFrame:SetWidth(EconomyFrame:GetWidth() * self.FxMult)
	EconomyFrame:SetHeight(EconomyFrame:GetHeight() * self.FyMult)
	self:moveObject(EconomyFrameTitleFrame, nil, nil, "-", 22)
	self:moveObject(EconomyFrameCloseButton, "+", 28, "+", 8)
	self:skinDropDown(EconomyFramePeriodDropDown)
	self:moveObject(EconomyFrameTopStats, "-", 12, nil, nil)
	self:applySkin(EconomyFrameTopStats)
	self:skinDropDown(EconomyFrameLeftStatsReportDropDown)
	self:moveObject(EconomyFrameLeftStats, "-", 12, nil, nil)
	self:applySkin(EconomyFrameLeftStats)
	self:skinDropDown(EconomyFrameRightStatsReportDropDown)
	self:moveObject(EconomyFrameRightStats, "-", 12, nil, nil)
	self:applySkin(EconomyFrameRightStats)
	self:applySkin(EconomyFrame)

end
