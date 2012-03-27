local aName, aObj = ...
if not aObj:isAddonEnabled("FreierGeist_InstanceTime") then return end

function aObj:FreierGeist_InstanceTime()

	self:addSkinFrame{obj=InstanceTimeFrame}
	self:addSkinFrame{obj=InstanceTime_TimerFrameXP}
	self:addSkinFrame{obj=InstanceTime_TimerFrameRep}
	self:skinScrollBar{obj=InstanceTimeScrollBar}
	self:addSkinFrame{obj=InstanceTime_ListFrame}
	self:addSkinFrame{obj=InstanceTime_TellToFrame}
	self:skinScrollBar{obj=InstanceTimeClassScrollBar}
	self:addSkinFrame{obj=InstanceTime_ClassFrame}
	self:skinScrollBar{obj=InstanceTimeLootScrollBar}
	self:addSkinFrame{obj=InstanceTime_LootFrame}
	self:skinScrollBar{obj=InstanceTimeBossScrollBar}
	self:addSkinFrame{obj=InstanceTime_BosskillFrame}
	self:addSkinFrame{obj=InstanceTime_MenuFrame}

	-- RaidClip Frame
	self:addSkinFrame{obj=InstanceTime_RaidClipFrame}
	self:skinScrollBar{obj=InstanceTime_RaidScrollFrame}

-->>--	Options Frame
	self:skinTabs{obj=InstanceTimeOptionsFrame}
	self:addSkinFrame{obj=InstanceTimeOptionsFrame, hdr=true, y2=-2}
	-- Page 1
	self:skinEditBox(optionsTabPage1LeaveChannels)
	self:skinEditBox(optionsTabPage1ContinueWithin)
	self:skinEditBox(optionsTabPage1RepairUntil)
	-- Page 2
	self:skinEditBox(optionsTabPage2Announcement)
	self:skinDropDown{obj=optionsTabPage2DropDownPostTo}
	-- Page 3
	self:skinEditBox(optionsTabPage3ExcludeItem1)
	self:skinEditBox(optionsTabPage3ExcludeItem2)
	self:skinEditBox(optionsTabPage3ExcludeItem3)
	self:skinEditBox(optionsTabPage3ExcludeItem4)
	self:skinEditBox(optionsTabPage3ExcludeItem5)
	self:skinEditBox(optionsTabPage3ExcludeItem6)
	self:skinEditBox(optionsTabPage3ExcludeItem7)
	self:skinEditBox(optionsTabPage3ExcludeItem8)
	self:skinEditBox(optionsTabPage3ExcludeItem9)
	self:skinEditBox(optionsTabPage3ExcludeItem10)
	-- Page 5
	self:skinEditBox(optionsTabPage5DateFormat)

-->>--	Help Frame
	self:skinFFToggleTabs("InstanceTime_HelpTab_", 6)
	self:skinScrollBar{obj=InstanceTime_HelpScrollFrame}
	self:addSkinFrame{obj=InstanceTime_Help, ofs=-7}

end
