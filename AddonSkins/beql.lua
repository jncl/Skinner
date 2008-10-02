
function Skinner:beql()
	if not self.db.profile.QuestLog.skin then return end

	-- if only using default QuestLog
	if beql.db.profile.simplequestlog then return end

	self:SecureHook(beql, "Maximize", function()
		QuestLogFrame:SetWidth(QuestLogFrame:GetWidth() - 34)
	end)

	self:SecureHook(beql, "Minimize", function()
		QuestLogFrame:SetWidth(QuestLogFrame:GetWidth() - 34)
	end)

	self:SecureHook("QuestLog_Update", function()
		if beql.db.char.saved.minimized then
			beql:Maximize()
		end
	end)

	-- resize the quest log frame
	QuestLogFrame:SetWidth(QuestLogFrame:GetWidth() + 32)
	QuestLogFrame:SetHeight(QuestLogFrame:GetHeight() + 10)

	self:keepFontStrings(beqlHistoryFrame)
	self:moveObject(self:getRegion(beqlHistoryFrame, 13), nil, nil, "-", 8)
	self:keepFontStrings(beqlHistoryListScrollFrame)
	self:skinScrollBar(beqlHistoryListScrollFrame)
	self:applySkin(beqlHistoryFrame)

end
