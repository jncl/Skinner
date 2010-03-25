
function Skinner:ItemRack()

	if not ItemRack_Version then self:ItemRack2() return end

	self.ItemRack2 = nil

	self:applySkin(ItemRack_InvFrame, true)
	self:applySkin(ItemRack_SetsFrame, true)

-->>--	Options Frame
	self:keepFontStrings(ItemRack_Sets_SubFrame1)
	self:keepFontStrings(ItemRack_OptList_ScrollFrame)
	self:skinScrollBar(ItemRack_OptList_ScrollFrame)
	self:applySkin(ItemRack_Sets_OptList, true)

-->>--	Sets Frame
	self:keepFontStrings(ItemRack_Sets_SubFrame2)
	self:keepFontStrings(ItemRack_Sets_ScrollFrame)
	self:skinScrollBar(ItemRack_Sets_ScrollFrame)
	self:skinEditBox(ItemRack_Sets_Name, {9})
	self:moveObject(ItemRack_Sets_Name, "-", 3, "+", 3)
	self:keepFontStrings(ItemRack_Sets_DropDown)
	self:applySkin(ItemRack_Sets_Saved, true)
	self:applySkin(ItemRack_Sets_SubFrame2, true)

-->>--	Events Frame
	self:keepFontStrings(ItemRack_Sets_SubFrame4)
	self:skinEditBox(ItemRack_EventName, {9})
	self:moveObject(ItemRack_EventName, nil, nil, "+", 5)
	self:skinEditBox(ItemRack_EventTrigger, {9})
	self:moveObject(ItemRack_EventTrigger, nil, nil, "+", 5)
	self:skinEditBox(ItemRack_EventDelay, {9})
	self:moveObject(ItemRack_EventDelay, nil, nil, "+", 5)
	self:keepFontStrings(ItemRackEventEditScrollFrame)
	self:skinScrollBar(ItemRackEventEditScrollFrame)
	self:keepFontStrings(ItemRack_Events_ScrollFrame)
	self:skinScrollBar(ItemRack_Events_ScrollFrame)
	self:applySkin(ItemRack_Sets_EventView, true)

-->>--	Help Frame
	self:keepFontStrings(ItemRack_Sets_SubFrame3)
	self:keepFontStrings(ItemRack_Help)
	self:skinScrollBar(ItemRack_Help)
	self:applySkin(ItemRack_Sets_SubFrame3, true)

-->>--	Tooltip
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then Rack_TooltipScan:SetBackdrop(self.backdrop) end
		self:skinTooltip(Rack_TooltipScan)
	end

-->>-- ClickBinder Frame
	self:SecureHook(ClickBinder, "Toggle", function(name, t)
--		self:Debug("CB.T: [%s, %s]", name, t)
		self:keepFontStrings(ClickBinderFrame)
		self:moveObject(ClickBinderTitle, nil, nil, "-", 6)
		self:applySkin(ClickBinderFrame, true)
	end)

end

function Skinner:ItemRack2()

	self.ItemRack = nil

	self:applySkin(ItemRackMenuFrame)

end

function Skinner:ItemRackOptions()

	self:applySkin(ItemRackOptFrame)

-->>--	Events Frame
	self:keepFontStrings(ItemRackOptSubFrame3)
	self:removeRegions(ItemRackOptEventListScrollFrame)
	self:skinScrollBar(ItemRackOptEventListScrollFrame)

-->>--	Queues Frame
	self:keepFontStrings(ItemRackOptSubFrame4)

-->>--	Options Frame
	self:keepFontStrings(ItemRackOptSubFrame1)
	self:skinEditBox(ItemRackOptButtonSpacing, {9})
	self:skinEditBox(ItemRackOptAlpha, {9})
	self:skinEditBox(ItemRackOptMainScale, {9})
	self:skinEditBox(ItemRackOptMenuScale, {9})
	self:removeRegions(ItemRackOptListScrollFrame)
	self:skinScrollBar(ItemRackOptListScrollFrame)

-->>--	Sets Frame
	self:keepFontStrings(ItemRackOptSubFrame2)
	self:skinEditBox(ItemRackOptSetsName, {9})
	self:moveObject(ItemRackOptSetsName, "-", 3, "+", 3)
	self:removeRegions(ItemRackOptSetsIconScrollFrame)
	self:skinScrollBar(ItemRackOptSetsIconScrollFrame)

-->>--	Pick Sets Frame
	self:keepFontStrings(ItemRackOptSubFrame5)
	self:removeRegions(ItemRackOptSetListScrollFrame)
	self:skinScrollBar(ItemRackOptSetListScrollFrame)

-->>--	Binder Frame
	self:applySkin(ItemRackOptBindFrame)

-->>--	? Frame
	self:keepFontStrings(ItemRackOptSubFrame6)
	self:keepFontStrings(ItemRackOptSubFrame7)
	self:removeRegions(ItemRackOptSortListScrollFrame)
	self:skinScrollBar(ItemRackOptSortListScrollFrame)

-->>--	Stats Frame
	self:applySkin(ItemRackOptItemStatsFrame)
	self:skinEditBox(ItemRackOptItemStatsDelay, {9})

end
