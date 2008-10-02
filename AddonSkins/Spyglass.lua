
function Skinner:Spyglass()
	if not self.db.profile.Inspect then return end

	self:moveObject(InspectSummaryFrame, "+", 12, "+", 26)
	self:applySkin(InspectSummaryFrame)

end
