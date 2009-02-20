
function Skinner:EveryQuest()
	if not self.db.profile.QuestLog.skin then return end

	if not IsAddOnLoaded("beql") then
		self:moveObject(EveryQuest.EveryQuestToggleButton, nil, nil, "+", 6)
	else
		self:moveObject(EveryQuest.EveryQuestToggleButton, "-", 20, "+", 6)
	end

	EveryQuestFrame:SetWidth(353)
	EveryQuestFrame:SetHeight(498)
	self:keepFontStrings(EveryQuestFrame)
	self:moveObject(EveryQuestTitleText, nil, nil, "+", 10)
	self:moveObject(EveryQuestFrameCloseButton, "+", 28, "+", 8)
	self:keepFontStrings(EveryQuestdewdropZoneListMenu)
	self:moveObject(EveryQuestdewdropZoneListMenu, nil, nil, "+", 15)

--	EveryQuestListScrollFrame:SetHeight(EveryQuestListScrollFrame:GetHeight() * self.FyMult)
	self:moveObject(EveryQuestCollapseAllButton, "+", 0, "+", 15)
	self:keepRegions(EveryQuestCollapseAllButton, {4, 6}) -- N.B. region 4 is button, 6 is text
	self:keepFontStrings(EveryQuestHighlightFrame)
	self:keepFontStrings(EveryQuestListScrollFrame)
	self:skinScrollBar(EveryQuestListScrollFrame)
	self:moveObject(EveryQuestListScrollFrame, nil, nil, "+", 15)
	self:moveObject(EveryQuestTitle1, "-", 10, "+", 15)
	self:moveObject(EveryQuestExitButton, "+", 30, nil, nil)
	self:applySkin(EveryQuestFrame)

end
