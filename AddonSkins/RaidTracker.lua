
function Skinner:RaidTracker()

-->>-- Raid Tracker Frame
	RaidTrackerFrame:SetWidth(RaidTrackerFrame:GetWidth() - 30)
	RaidTrackerFrame:SetHeight(RaidTrackerFrame:GetHeight() - 40)
	self:keepFontStrings(RaidTrackerFrame)
	self:moveObject(RaidTrackerFrameHeaderTitle, nil, nil, "+", 10)
	self:moveObject(RaidTrackerFrameHeader, "-", 40, nil, nil) -- buttons frame
	self:moveObject(self:getChild(RaidTrackerFrame, 1), "+", 28, "+", 8) -- close button
	self:moveObject(RaidTrackerFrameView2Button, "-", 10, "-", 45)
	self:moveObject(RaidTrackerFrameBackButton, "+", 30, "-", 45)
	self:applySkin(RaidTrackerFrame)

	-- RT_LogFrame SubFrame
	self:keepFontStrings(RT_LogFrame)
	self:skinScrollBar(RT_LogFrame)

	-- RT_DetailFramePlayers SubFrame
	self:moveObject(RT_DetailFramePlayersText, nil, nil, "+", 10)
	RT_DetailFramePlayersText:SetTextColor(self.HTr, self.HTg, self.HTb)
	self:moveObject(RT_DetailFramePlayersTab1, nil, nil, "+", 10)
	self:skinFFColHeads("RT_DetailFramePlayersTab", 3)
	for i = 1, 11 do
		_G["RT_DetailFramePlayersLine"..i.."Number"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["RT_DetailFramePlayersLine"..i.."Name"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["RT_DetailFramePlayersLine"..i.."Join"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["RT_DetailFramePlayersLine"..i.."Leave"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		local text = self:getRegion(_G["RT_DetailFramePlayersLine"..i.."DeleteButton"], 1)
		text:SetTextColor(self.BTr, self.BTg, self.BTb)
	end
	self:keepFontStrings(RT_DetailFramePlayers)
	self:skinScrollBar(RT_DetailFramePlayers)

	-- RT_DetailFrameItems SubFrame
	self:keepFontStrings(RT_RarityDropdownFrame)
	self:moveObject(RT_DetailFrameItemsTab1, nil, nil, "+", 10)
	self:skinFFColHeads("RT_DetailFrameItemsTab", 4)
	for i = 1, 5 do
		_G["RT_DetailFrameItemsLine"..i.."Description"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["RT_DetailFrameItemsLine"..i.."Looted"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["RT_DetailFrameItemsLine"..i.."Count"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		local text = self:getRegion(_G["RT_DetailFrameItemsLine"..i.."DeleteButton"], 1)
		text:SetTextColor(self.BTr, self.BTg, self.BTb)
	end
	self:keepFontStrings(RT_DetailFrameItems)
	self:skinScrollBar(RT_DetailFrameItems)

	-- RT_DetailFrameRaids SubFrame
	self:moveObject(RT_DetailFrameRaidsText, nil, nil, "+", 10)
	RT_DetailFrameRaidsText:SetTextColor(self.HTr, self.HTg, self.HTb)
	self:moveObject(RT_DetailFrameRaidsTab1, nil, nil, "+", 10)
	self:keepFontStrings(RT_DetailFrameRaidsTab1)
	self:applySkin(RT_DetailFrameRaidsTab1)
	self:keepFontStrings(RT_DetailFrameRaidsTabLooter)
	self:applySkin(RT_DetailFrameRaidsTabLooter)
	for i = 1, 11 do
		_G["RT_DetailFrameRaidsLine"..i.."Number"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["RT_DetailFrameRaidsLine"..i.."Name"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["RT_DetailFrameRaidsLine"..i.."Note"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		local text = self:getRegion(_G["RT_DetailFrameRaidsLine"..i.."DeleteButton"], 1)
		text:SetTextColor(self.BTr, self.BTg, self.BTb)
	end
	self:keepFontStrings(RT_DetailFrameRaids)
	self:skinScrollBar(RT_DetailFrameRaids)

	-- RT_DetailFrameEvents SubFrame
	self:moveObject(RT_DetailFrameEventsText, nil, nil, "+", 10)
	RT_DetailFrameEventsText:SetTextColor(self.HTr, self.HTg, self.HTb)
	self:moveObject(RT_DetailFrameEventsTab1, nil, nil, "+", 10)
	self:keepFontStrings(RT_DetailFrameEventsTab1)
	self:applySkin(RT_DetailFrameEventsTab1)
	self:keepFontStrings(RT_DetailFrameEventsTabBoss)
	self:applySkin(RT_DetailFrameEventsTabBoss)
	for i = 1, 11 do
		_G["RT_DetailFrameEventsLine"..i.."Boss"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["RT_DetailFrameEventsLine"..i.."Time"]:SetTextColor(self.BTr, self.BTg, self.BTb)
	end
	self:keepFontStrings(RT_DetailFrameEvents)
	self:skinScrollBar(RT_DetailFrameEvents)

-->>--	RT_ConfirmDeleteFrame
	self:moveObject(RT_ConfirmDeleteFrame, "+", 20, nil, nil, RaidTrackerFrame)
	self:applySkin(RT_ConfirmDeleteFrame, true)

-->>--	RT_EditNoteFrame
	self:moveObject(RT_EditNoteFrame, "+", 20, nil, nil, RaidTrackerFrame)
	self:skinEditBox(RT_EditNoteFrameTextBox, {6})
	self:applySkin(RT_EditNoteFrame, true)

-->>-- RT_AcceptWipeFrame
	self:applySkin(RT_AcceptWipeFrame, true)
	
-->>-- RT_ExportFrame
	self:moveObject(RT_ExportFrame, "+", 20, nil, nil, RaidTrackerFrame)
	self:skinEditBox(RT_ExportFrameTextBox, {6})
	self:applySkin(RT_ExportFrame, true)

-->>-- RT_EditBossFrame
	self:keepFontStrings(RT_EditBossFrameMenu)
	self:applySkin(RT_EditBossFrame, true)

-->>-- RT_EditCostFrame
	self:skinEditBox(RT_EditCostFrameTextBox, {6})
	self:applySkin(RT_EditCostFrame, true)

-->>--	RT_JoinLeaveFrame
	self:moveObject(RT_JoinLeaveFrame, "+", 20, nil, nil, RaidTrackerFrame)
	self:skinEditBox(RT_JoinLeaveFrameNameEB, {6})
	self:skinEditBox(RT_JoinLeaveFrameNoteEB, {6})
	self:skinEditBox(RT_JoinLeaveFrameTimeEB, {6})
	self:applySkin(RT_JoinLeaveFrame, true)

-->>--	Options Frame
	self:moveObject(self:getChild(RT_OptionsFrame, 1), "+", 8, "+", 8) -- close button
	self:applySkin(RT_OptionsFrame, true)

-->>--	Item Options Frame
	self:moveObject(self:getChild(RT_ItemOptionsFrame, 1), "+", 8, "+", 8) -- close button
	self:keepFontStrings(RT_ItemOptionsFrameListScroll)
	self:skinScrollBar(RT_ItemOptionsFrameListScroll)
	self:applySkin(RT_ItemOptionsFrameList)
	self:applySkin(RT_ItemOptionsFrame, true)

end
