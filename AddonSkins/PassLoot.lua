
function Skinner:PassLoot()

-->>--	Options Frame
	self:applySkin(PassLoot_MainFrame, true)
	-- Rules
	self:removeRegions(PassLoot_Rules_RuleList_Scroll)
	self:skinScrollBar(PassLoot_Rules_RuleList_Scroll)
	self:applySkin(PassLoot_Rules_RuleList)
	self:keepFontStrings(PassLoot_Rules_Settings_ScrollFrame)
	self:skinScrollBar(PassLoot_Rules_Settings_ScrollFrame)
	self:applySkin(PassLoot_Rules_Settings_ScrollFrame_Content)
	self:removeRegions(PassLoot_Rules_Settings_ItemList_Scroll)
	self:skinScrollBar(PassLoot_Rules_Settings_ItemList_Scroll)
	self:applySkin(PassLoot_Rules_Settings_ItemList)
	self:applySkin(PassLoot_Rules_Settings)
	-- Profiles
	self:skinDropDown(PassLoot_Profiles_CurrentProfile)
	self:skinDropDown(PassLoot_Profiles_CopyProfile)
	self:skinDropDown(PassLoot_Profiles_DeleteProfile)
	self:skinEditBox(PassLoot_Profiles_NewProfileName, {15})
	self:applySkin(PassLoot_Profiles)
	-- Modules
	self:skinDropDown(PassLoot_Frames_Widgets_Bind)
	self:skinEditBox(PassLoot_Frames_Widgets_Desc, {15})
	self:skinDropDown(PassLoot_Frames_Widgets_EquipSlot)
	self:skinDropDown(PassLoot_Frames_Widgets_GroupRaid)
	self:skinEditBox(PassLoot_Frames_Widgets_LootWonCounter, {15})
	self:keepFontStrings(PassLoot_Frames_Widgets_LootWonComparison)
	self:skinEditBox(PassLoot_Frames_Widgets_LootWonDropDownEditBox, {15})
	self:skinDropDown(PassLoot_Frames_Widgets_Quality)
	self:skinDropDown(PassLoot_Frames_Widgets_TypeSubType)
	self:skinDropDown(PassLoot_Frames_Widgets_Unique)
	self:skinEditBox(PassLoot_Frames_Widgets_Zone, {15})
	self:moveObject(PassLoot_Rules_Settings_Zone, "+", 4, nil, nil)
	self:skinDropDown(PassLoot_Frames_Widgets_ZoneType)
	self:keepFontStrings(PassLoot_Modules_ScrollFrame)
	self:skinScrollBar(PassLoot_Modules_ScrollFrame)
	self:applySkin(PassLoot_Modules_ScrollFrame_Content)
	self:applySkin(PassLoot_Modules)
	for _, v in pairs(PassLoot.ModuleHeaders) do
		self:applySkin(PassLoot.PluginInfo[v].ProfileHeader.Box)
	end
	-- Tabs
	self:skinFFToggleTabs("PassLoot_TabbedMenuContainerTab", 3)
	self:moveObject(PassLoot_TabbedMenuContainerTab1, nil, nil, "-", 8)

end
