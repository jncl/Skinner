
function Skinner:beql()
	if not self.db.profile.QuestLog then return end

	-- if only using default QuestLog
	if beql.db.profile.simplequestlog then return end

	self:skinScrollBar{obj=beqlHistoryListScrollFrame}
	self:addSkinFrame{obj=beqlHistoryFrame, kfs=true}

end
