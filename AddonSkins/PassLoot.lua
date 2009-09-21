
function Skinner:PassLoot()

-->>--	Main Frame
	PassLoot.MainFrame.HeaderTexture:SetAlpha(0)
	self:addSkinFrame{obj=PassLoot.MainFrame, kfs=true, x1=4, y1=4, x2=-4, y2=4}
	-- Tabs
	local plmftm = PassLoot.MainFrame.TabMenu
	self:skinFFToggleTabs("PassLoot_TabbedMenuContainerTab", plmftm.numTabs)
	-- Rules SubFrame
	self:skinScrollBar{obj=plmftm.Rules.List.ScrollFrame}
	self:addSkinFrame{obj=plmftm.Rules.List, kfs=true}
	-- Rules Settings SubFrame
	self:skinEditBox{obj=plmftm.Rules.Settings.Desc, regs={15}}
	self:skinScrollBar{obj=plmftm.Rules.Settings.AvailableFilters.ScrollFrame}
	self:addSkinFrame{obj=plmftm.Rules.Settings.AvailableFilters, kfs=true}
	self:skinScrollBar{obj=plmftm.Rules.Settings.ActiveFilters.ScrollFrame}
	self:addSkinFrame{obj=plmftm.Rules.Settings.ActiveFilters, kfs=true}
	self:addSkinFrame{obj=plmftm.Rules.Settings, kfs=true}
	-- Widgets
	self:skinEditBox(PassLoot_Frames_Widgets_Zone, {15})
	self:skinDropDown(PassLoot_Frames_Widgets_ZoneType)
	self:skinDropDown(PassLoot_Frames_Widgets_Quality)
	self:skinDropDown(PassLoot_Frames_Widgets_Bind)
	self:skinDropDown(PassLoot_Frames_Widgets_Unique)
	self:skinDropDown(PassLoot_Frames_Widgets_EquipSlot)
	self:skinDropDown(PassLoot_Frames_Widgets_TypeSubType)
	self:skinDropDown(PassLoot_Frames_Widgets_ItemLevelComparison)
	self:skinDropDown(PassLoot_Frames_Widgets_RequiredLevelComparison)
	self:skinDropDown(PassLoot_Frames_Widgets_GroupRaid)
	self:skinDropDown(PassLoot_Frames_Widgets_LootWonComparison)
	self:skinEditBox(PassLoot_Frames_Widgets_LootWonCounter, {15})
	self:skinEditBox(PassLoot_Frames_Widgets_ItemNameTextBox, {15})
	self:skinDropDown(PassLoot_Frames_Widgets_ItemPriceComparison)
	-- ItemPrice comparison widget money frame
	local mf = (PassLoot_Frames_Widgets_ItemPriceComparison:GetParent()).MoneyInputFrame
	self:skinEditBox{obj=mf.Gold, regs={9, 10}, noHeight=true, noWidth=true} 
	self:skinEditBox{obj=mf.Silver, regs={9, 10}, noHeight=true, noWidth=true} 
	self:moveObject{obj=mf.Silver, x=-10}
	self:moveObject{obj=mf.Silver.IconTexture, x=10}
	self:skinEditBox{obj=mf.Copper, regs={9, 10}, noHeight=true, noWidth=true} 
	self:moveObject{obj=mf.Copper.IconTexture, x=10}
	
	-- Modules SubFrame
	self:skinScrollBar{obj=plmftm.Modules.ScrollFrame}
	self:applySkin{obj=plmftm.Modules.ScrollFrame.ScrollChild}
	self:addSkinFrame{obj=plmftm.Modules, kfs=true}
	-- ModuleHeaders
	for _, v in pairs(PassLoot.ModuleHeaders) do
		self:addSkinFrame{obj=PassLoot.PluginInfo[v].ProfileHeader.Box, kfs=true, y1=2}
	end

end
