
function Skinner:ItemDB()

	self:keepRegions(ItemDB_DBFrame, {})
	self:moveObject(ItemDB_DBFrame_CloseButton, "-", 4, "+", 6)
	self:removeRegions(ItemDB_DBFrame_ItemList_BrowseQualitySort, {1, 2, 3})
	self:applySkin(ItemDB_DBFrame_ItemList_BrowseQualitySort)
	self:removeRegions(ItemDB_DBFrame_ItemList_BrowseNameSort, {1, 2, 3})
	self:applySkin(ItemDB_DBFrame_ItemList_BrowseNameSort)
	self:removeRegions(ItemDB_DBFrame_ItemList_BrowseLevelSort, {1, 2, 3})
	self:applySkin(ItemDB_DBFrame_ItemList_BrowseLevelSort)
	self:removeRegions(ItemDB_DBFrame_ItemList_BrowseValueSort, {1, 2, 3})
	-- Hook this to manage the filters
	self:SecureHook("ItemDB_DBFrame_FilterButton_SetType", function(button, type, text, isLast)
		-- self:Debug("ItemDB_DBFrame_FilterButton_SetType: [%s, %s, %s, %s]", button, type, text, isLast)
		self:keepRegions(button, {3, 4})
		self:applySkin(button)
	end)
	self:applySkin(ItemDB_DBFrame_ItemList_BrowseValueSort)
	self:removeRegions(ItemDB_DBFrame_FilterScrollFrame)
	self:skinScrollBar(ItemDB_DBFrame_FilterScrollFrame)
	self:removeRegions(ItemDB_DBFrame_ItemList_BrowseScrollFrame)
	self:skinScrollBar(ItemDB_DBFrame_ItemList_BrowseScrollFrame)
	self:skinEditBox(ItemDB_DBFrame_ItemList_Name)
	self:skinEditBox(ItemDB_DBFrame_ItemList_MinLevel)
	self:skinEditBox(ItemDB_DBFrame_ItemList_MaxLevel)
	self:keepRegions(ItemDB_DBFrame_ItemList_RarityFilterDropDown, {4,5}) -- N.B. regions 4 & 5 are text
	self:moveObject(ItemDB_DBFrame_ItemList_CloseButton, nil, nil, "-", 6)
	self:applySkin(ItemDB_DBFrame)

-->>--	Tabs
	self:keepRegions(ItemDB_DBFrameTab1, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
	if self.db.profile.TexturedTab then self:applySkin(ItemDB_DBFrameTab1, nil, 0, 1)
	else self:applySkin(ItemDB_DBFrameTab1) end
	self:moveObject(ItemDB_DBFrameTab1, nil, nil, "-", 4)
	self:setActiveTab(ItemDB_DBFrameTab1)
	self:keepRegions(ItemDB_DBFrameTab2, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
	if self.db.profile.TexturedTab then self:applySkin(ItemDB_DBFrameTab2, nil, 0, 1)
	else self:applySkin(ItemDB_DBFrameTab2) end
	self:moveObject(ItemDB_DBFrameTab2, "+", 6, nil, nil)
	self:setInactiveTab(ItemDB_DBFrameTab2)

	self:SecureHook("ItemDB_DBFrame_Tab_OnClick", function(index)
		-- self:Debug("ItemDB_DBFrame_Tab_OnClick: [%s, %s]", index, ItemDB_DBFrame.selectedTab)
		self:setInactiveTab(ItemDB_DBFrameTab1)
		self:setInactiveTab(ItemDB_DBFrameTab2)
		if ItemDB_DBFrame.selectedTab == 1 then
			self:setActiveTab(ItemDB_DBFrameTab1)
		else
			self:setActiveTab(ItemDB_DBFrameTab2)
		end
	end)

-->>--	DressUp Frame
	self:keepRegions(ItemDB_DBFrame_DressUpFrame, {})
	self:makeMFRotatable(ItemDB_DBFrame_DressUpModel)
	ItemDB_DBFrame_DressUpModelRotateLeftButton:Hide()
	ItemDB_DBFrame_DressUpModelRotateRightButton:Hide()
	self:keepRegions(ItemDB_DBFrame_DressUpFrameCloseButton, {1})
	self:applySkin(ItemDB_DBFrame_DressUpFrame)

end
