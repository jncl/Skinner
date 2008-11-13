
function Skinner:QuestAgent()

	self:SecureHook(QuestAgent, "ShowQuest", function(this, q, name)
		self:Debug("QuestAgent_ShowQuest")
		for i = 1, 10 do
			local r, g, b, a = _G["QuestAgent_QuestLogObjective"..i]:GetTextColor()
			_G["QuestAgent_QuestLogObjective"..i]:SetTextColor(self.BTr - r, self.BTg - g, self.BTb)
		end
		local r, g, b, a = QuestAgent_QuestLogRequiredMoneyText:GetTextColor()
		QuestAgent_QuestLogRequiredMoneyText:SetTextColor(self.BTr - r, self.BTg - g, self.BTb)
		QuestAgent_QuestLogRewardTitleText:SetTextColor(self.HTr, self.HTg, self.HTb)
		QuestAgent_QuestLogItemChooseText:SetTextColor(self.BTr, self.BTg, self.BTb)
		QuestAgent_QuestLogItemReceiveText:SetTextColor(self.BTr, self.BTg, self.BTb)
		QuestAgent_QuestLogSpellLearnText:SetTextColor(self.BTr, self.BTg, self.BTb)
	end)
	
	self:keepFontStrings(QuestAgent_QuestLogFrame)
	QuestAgent_QuestLogFrame:SetWidth(QuestAgent_QuestLogFrame:GetWidth() * self.FxMult)
	QuestAgent_QuestLogFrame:SetHeight(QuestAgent_QuestLogFrame:GetHeight() * self.FyMult)
	self:moveObject(QuestAgent_QuestLogTitleText, nil, nil, "+", 10)
	self:removeRegions(QuestAgent_QuestLogDetailScrollFrame)
	self:skinScrollBar(QuestAgent_QuestLogDetailScrollFrame)
	self:moveObject(QuestAgent_QuestLogDetailScrollFrame, "-", 10, "+", 40)
	self:moveObject(QuestAgent_QuestLogFrameCloseButton, "+", 30, "+", 8)
	self:moveObject(QuestAgent_QuestFrameExitButton, "+", 33, "-", 44)
	
	QuestAgent_QuestLogQuestTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
	QuestAgent_QuestLogObjectivesText:SetTextColor(self.BTr, self.BTg, self.BTb)
	QuestAgent_QuestLogTimerText:SetTextColor(self.BTr, self.BTg, self.BTb)
	for i = 1, 10 do
   		local r, g, b, a = _G["QuestAgent_QuestLogObjective"..i]:GetTextColor()
   		_G["QuestAgent_QuestLogObjective"..i]:SetTextColor(self.BTr - r, self.BTg - g, self.BTb)
   	end
	QuestAgent_QuestLogRequiredMoneyText:SetTextColor(self.BTr, self.BTg, self.BTb)
	QuestAgent_QuestLogSuggestedGroupNum:SetTextColor(self.HTr, self.HTg, self.HTb)
	QuestAgent_QuestLogDescriptionTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
	QuestAgent_QuestLogQuestDescription:SetTextColor(self.BTr, self.BTg, self.BTb)
	QuestAgent_QuestLogPlayerTitleText:SetTextColor(self.BTr, self.BTg, self.BTb)
	QuestAgent_QuestLogRewardTitleText:SetTextColor(self.HTr, self.HTg, self.HTb)
	
	self:applySkin(QuestAgent_QuestLogFrame)

	self:applySkin(QuestAgentUpdateDialog)

end
