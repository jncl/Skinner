
function Skinner:Atlas()

-->>--	AtlasFrame
	self:moveObject(self:getRegion(AtlasFrame, 6), nil, nil, "+", 8)
	self:moveObject(self:getRegion(AtlasFrame, 7), nil, nil, "+", 8)
	self:moveObject(AtlasFrameCloseButton, "-", 4, "+", 8)
	self:skinDropDown(AtlasFrameDropDownType)
	self:skinDropDown(AtlasFrameDropDown)
	self:removeRegions(AtlasFrame, {1,2,3,4,5}) -- N.B. other regions are text or Map Textures
	self:skinEditBox(AtlasSearchEditBox, {9})
	self:keepFontStrings(AtlasScrollBar)
	self:skinScrollBar(AtlasScrollBar)
	self:applySkin(AtlasFrame, nil)
	-- change the draw layer so the map is visible
	AtlasMap:SetDrawLayer("OVERLAY")

-->>--	AtlasOptionsFrame
	self:keepRegions(AtlasOptionsFrame, {11})
	self:skinDropDown(AtlasOptionsFrameDropDownCats)
	self:applySkin(AtlasOptionsFrame, true)

end
