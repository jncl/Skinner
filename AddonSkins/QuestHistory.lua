local aName, aObj = ...
if not aObj:isAddonEnabled("QuestHistory") then return end

function aObj:QuestHistory()

	self:skinDropDown{obj=QuestHistoryFrameSortDropDown1, x2=35}
	self:skinDropDown{obj=QuestHistoryFrameCharacterDropDown1, x2=35}
	self:skinEditBox{obj=QuestHistoryFrameSearchEditBox, regs={9}}
	self:skinScrollBar{obj=QuestHistoryListScrollFrame}
	-- self:moveObject{obj=QuestHistoryFrameCloseButton, y=8}
	self:addSkinFrame{obj=QuestHistoryFrame, kfs=true, x1=6, y1=-6, x2=-45, y2=12}

-->>-- Detail Frame
	self:skinScrollBar{obj=QuestHistoryDetailListScrollFrame}
	self:skinScrollBar{obj=QuestHistoryDetailNotesScrollFrame}
	self:skinScrollBar{obj=QuestHistoryDetailScrollFrame}
	self:addSkinFrame{obj=QuestHistoryDetailFrame, kfs=true, x1=10, y1=-11, x2=-32, y2=45}
	-- colour text fields
	QuestHistoryDetailQuestTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
	QuestHistoryDetailObjectivesText:SetTextColor(self.BTr, self.BTg, self.BTb)
	for i = 1, 10 do
		_G["QuestHistoryDetailObjective"..i]:SetTextColor(self.BTr, self.BTg, self.BTb)
	end
	QuestHistoryDetailRequiredMoneyText:SetTextColor(self.BTr, self.BTg, self.BTb)
	QuestHistoryDetailDescriptionTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
	QuestHistoryDetailQuestDescription:SetTextColor(self.BTr, self.BTg, self.BTb)
	QuestHistoryDetailRewardTitleText:SetTextColor(self.HTr, self.HTg, self.HTb)
	QuestHistoryDetailItemChooseText:SetTextColor(self.BTr, self.BTg, self.BTb)
	QuestHistoryDetailItemReceiveText:SetTextColor(self.BTr, self.BTg, self.BTb)

-->>-- Message Frame
	self:skinScrollBar{obj=QuestHistoryMessageScrollFrameOne}
	self:addSkinFrame{obj=QuestHistoryMessageFrame, kfs=true, y1=4, y2=4}

-->>-- Options Frame
	self:addSkinFrame{obj=QuestHistoryOptionsFrameShow, y2=-2}
	self:addSkinFrame{obj=QuestHistoryOptionsFrameLog}
	self:skinDropDown{obj=QuestHistoryOptionsFrameAddonDropDown1, x2=35}
	self:skinDropDown{obj=QuestHistoryOptionsFrameAddonDropDown2, x2=35}
	self:skinDropDown{obj=QuestHistoryOptionsFrameServerDropDown1, x2=35}
	self:addSkinFrame{obj=QuestHistoryOptionsFrameRepair}
	self:addSkinFrame{obj=QuestHistoryOptionsFrameOther}
	self:addSkinFrame{obj=QuestHistoryOptionsFrame, kfs=true, y2=4}
	self:addSkinFrame{obj=QuestHistoryConfirmFrame, kfs=true, y2=4}

-->>-- Edit Frame
	for _, v in pairs{"LevelAccepted", "LevelCompleted", "MoneyRewarded", "XPRewarded", "AcceptedOrder", "Level", "CompletedOrder", "Category", "Tag", "QuestGiver", "QuestCompleter", "AcceptedZone", "AcceptedX", "AcceptedY", "CompletedZone", "CompletedX", "CompletedY", "TimeAccepted", "TimeCompleted", "TimesAbandoned", "QuestID", "QuestIDLevel"} do
		local eBox = _G["QuestHistoryEdit"..v.."EditBox"]
		self:skinEditBox{obj=eBox, regs={9}, noHeight=true, noWidth=true}
		self:adjWidth{obj=eBox, adj= eBox:GetWidth() < 45 and 8 or 0}
		self:adjHeight{obj=eBox, adj=4}
	end
	self:skinScrollBar{obj=QuestHistoryEditListScrollFrame}
	self:skinButton{obj=QuestHistoryEditTitleButton, as=true}
	self:skinButton{obj=QuestHistoryEditObjectivesButton, as=true}
	self:skinButton{obj=QuestHistoryEditDescriptionButton, as=true}
	self:skinScrollBar{obj=QuestHistoryEditScrollFrame}
	self:addSkinFrame{obj=QuestHistoryEditFrame, kfs=true, bgen=1, x1=6, y1=-11, x2=-32, y2=46}

end
