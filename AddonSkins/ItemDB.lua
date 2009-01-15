
function Skinner:ItemDB()

	local IDB
	if LibStub("AceAddon-3.0") then IDB = LibStub("AceAddon-3.0"):GetAddon("ItemDB", true) end
	if not IDB then return end

	-- Browser
	self:keepFontStrings(ItemDB_Browser)
	self:moveObject(ItemDB_Browser_CloseButtonTR, "+", 1, "+", 11)
	self:moveObject(ItemDB_Browser_Title, nil, nil, "+", 10)
	self:moveObject(ItemDB_Browser_Filter_NameText, nil, nil, "+", 10)
	self:skinEditBox(ItemDB_Browser_Filter_Name)
	self:moveObject(ItemDB_Browser_Filter_LevelText, nil, nil, "+", 15)
	self:skinEditBox(ItemDB_Browser_Filter_MinLevel)
	self:skinEditBox(ItemDB_Browser_Filter_MaxLevel)
	self:skinDropDown(ItemDB_Browser_Filter_RarityDropDown)
	self:skinDropDown(ItemDB_Browser_FilterDropDown)
	self:removeRegions(ItemDB_Browser_FilterScrollFrame)
	self:skinScrollBar(ItemDB_Browser_FilterScrollFrame)
	self:removeRegions(ItemDB_Browser_ItemScrollFrame)
	self:skinScrollBar(ItemDB_Browser_ItemScrollFrame)
	
	self:applySkin(ItemDB_Browser)
	
	-- sort buttons
	local sortNames= {"Rarity", "Name", "MinLevel", "ItemLevel", "Value"}
	for _, v in pairs(sortNames) do
		local sortObj = _G["ItemDB_Browser_Sort_"..v]
		self:keepRegions(sortObj, {4, 5, 6}) -- N.B. Region 4 is text, 5 is the arrow, 6 is the highlight
		self:applySkin(sortObj)
	end
	-- filter buttons
	-- Hook this to manage the filters
	self:SecureHook(IDB, "FilterList_Update", function()
		for i = 1, 15 do
			local filterObj = _G["ItemDB_Browser_FilterButton"..i]
			self:keepRegions(filterObj, {3, 4})
			self:applySkin(filterObj)
		end
	end)

	-- Tabs
	for i = 1, ItemDB_Browser.numTabs do
		local tabObj = _G["ItemDB_BrowserTab"..i]
		if i == 1 then
			self:moveObject(tabObj, nil, nil, "-", 4)
		else
			self:moveObject(tabObj, "+", 3, nil, nil)
		end 
		self:keepRegions(tabObj, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		if self.db.profile.TexturedTab then
			self:applySkin(tabObj, nil, 0, 1)
			if i == 1 then self:setActiveTab(tabObj)
			else self:setInactiveTab(tabObj) end
		else self:applySkin(tabObj) end
	end
	if self.db.profile.TexturedTab then 
		self:SecureHook(IDB, "SelectItemProvider", function(id)
			for i = 1, ItemDB_Browser.numTabs do
				local tabObj = _G["ItemDB_BrowserTab"..i]
				if i == ItemDB_Browser.selectedTab then self:setActiveTab(tabObj)
				else self:setInactiveTab(tabObj) end
			end
		end)
	end
	
end
