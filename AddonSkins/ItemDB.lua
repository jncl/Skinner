local aName, aObj = ...
if not aObj:isAddonEnabled("ItemDB") then return end

function aObj:ItemDB()

	self:moveObject{obj=ItemDB_Browser_Filter_NameText, y=5}
	self:moveObject{obj=ItemDB_Browser_Filter_LevelText, y=5}
	self:moveObject{obj=ItemDB_Browser_Filter_RarityText, y=5}
	self:skinEditBox{obj=ItemDB_Browser_Filter_Name, regs={9}}
	self:skinEditBox{obj=ItemDB_Browser_Filter_MinLevel, regs={9}}
	self:skinEditBox{obj=ItemDB_Browser_Filter_MaxLevel, regs={9}}
	self:skinDropDown{obj=ItemDB_Browser_Filter_RarityDropDown}
	self:skinDropDown{obj=ItemDB_Browser_FilterDropDown}
	for _, v in pairs{"Rarity", "Name", "MinLevel", "ItemLevel", "Value"} do
		local btn = _G["ItemDB_Browser_Sort_" .. v] 
		self:removeRegions(btn, {1, 2, 3}) -- left, right & middle textures
		self:addSkinFrame{obj=btn, nb=true}
		self:adjHeight{obj=btn, adj=3}
	end
	for i = 1, 15 do
		local btn = _G["ItemDB_Browser_FilterButton" .. i]
		self:rmRegionsTex(btn, {1}) -- normal texture
		self:addSkinFrame{obj=btn, nb=true}
	end
	for i = 1, 8 do
		self:removeRegions(_G["ItemDB_Browser_ItemButton" .. i], {1, 2, 3}) -- left, right & name frame textures
		self:removeRegions(_G["ItemDB_Browser_ItemButton" .. i .. "Item"], {4}) -- normal texture
		self:addButtonBorder{obj=_G["ItemDB_Browser_ItemButton" .. i .. "Item"]}
	end
	self:skinScrollBar{obj=ItemDB_Browser_FilterScrollFrame}
	self:skinScrollBar{obj=ItemDB_Browser_ItemScrollFrame}
	self:addSkinFrame{obj=ItemDB_Browser, kfs=true, x1=10, y1=-12, x2=0, y2=5}
	-- AdvancedFilters
	self:addSkinFrame{obj=ItemDB_Browser_AdvancedFilters, kfs=true, nb=true, bg=true, ofs=-2, x1=-5}
	self:skinButton{obj=ItemDB_Browser_AdvancedFiltersCloseButton, cb=true}
	self:removeRegions(ItemDB_Browser_AdvancedFiltersCloseButton, {5}) -- corner texture

	-- Tabs
	self:skinTabs{obj=ItemDB_Browser}

end