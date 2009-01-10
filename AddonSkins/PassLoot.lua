
function Skinner:PassLoot()

-->>--	Options Frame
	self:applySkin(PassLoot_MainFrame, true)
	-- Tabbed SubFrame
	self:skinFFToggleTabs("PassLoot_TabbedMenuContainerTab", PassLoot_TabbedMenuContainer.numTabs)
	self:moveObject(PassLoot_TabbedMenuContainerTab1, nil, nil, "-", 8)
	-- Rules SubFrame
	self:keepFontStrings(PassLoot_Rules_RuleList_Scroll)
	self:skinScrollBar(PassLoot_Rules_RuleList_Scroll)
	self:applySkin(PassLoot_Rules_RuleList)
	-- Rules Settings SubFrame
	self:skinEditBox(PassLoot_Rules_Settings_Desc, {9})
	self:applySkin(PassLoot_Rules_Settings)
	self:keepFontStrings(PassLoot_Rules_Settings_Options_Scroll)
	self:skinScrollBar(PassLoot_Rules_Settings_Options_Scroll)
	self:applySkin(PassLoot_Rules_Settings_Options)
	self:keepFontStrings(PassLoot_Rules_Settings_Filters_Scroll)
	self:skinScrollBar(PassLoot_Rules_Settings_Filters_Scroll)
	self:applySkin(PassLoot_Rules_Settings_Filters)
	-- Widgets
	self:skinEditBox(PassLoot_Frames_Widgets_Zone, {15})
	self:moveObject(PassLoot_Rules_Settings_Zone, "+", 4, nil, nil)
	self:skinDropDown(PassLoot_Frames_Widgets_ZoneType)
	self:skinDropDown(PassLoot_Frames_Widgets_Quality)
	self:skinDropDown(PassLoot_Frames_Widgets_Bind)
	self:skinDropDown(PassLoot_Frames_Widgets_Unique)
	self:skinDropDown(PassLoot_Frames_Widgets_EquipSlot)
	self:skinDropDown(PassLoot_Frames_Widgets_TypeSubType)
	self:skinDropDown(PassLoot_Frames_Widgets_ItemLevelComparison)
	self:skinDropDown(PassLoot_Frames_Widgets_RequiredLevelComparison)
	self:skinDropDown(PassLoot_Frames_Widgets_GroupRaid)
	self:keepFontStrings(PassLoot_Frames_Widgets_LootWonComparison)
	self:skinEditBox(PassLoot_Frames_Widgets_LootWonCounter, {15})
	self:skinEditBox(PassLoot_Frames_Widgets_ItemNameTextBox, {15})
	self:skinDropDown(PassLoot_Frames_Widgets_ItemPriceComparison)
	-- Modules SubFrame
	self:keepFontStrings(PassLoot_Modules_ScrollFrame)
	self:skinScrollBar(PassLoot_Modules_ScrollFrame)
	self:applySkin(PassLoot_Modules_ScrollFrame_Content)
	self:applySkin(PassLoot_Modules)
	for _, v in pairs(PassLoot.ModuleHeaders) do
		self:applySkin(PassLoot.PluginInfo[v].ProfileHeader.Box)
	end
	-- Settings SubFrame
	self:keepFontStrings(PassLoot_Settings_OutputFrameMain)
	self:applySkin(PassLoot_Settings)
	-- Profiles SubFrame
	self:skinDropDown(PassLoot_Profiles_CurrentProfile)
	self:skinDropDown(PassLoot_Profiles_CopyProfile)
	self:skinDropDown(PassLoot_Profiles_DeleteProfile)
	self:skinEditBox(PassLoot_Profiles_NewProfileName, {15})
	self:applySkin(PassLoot_Profiles)

end
