
function Skinner:PowerAuras()

	self:getRegion(PowaOptionsFrame, 1):SetAlpha(0) -- Header box
	self:moveObject(PowaOptionsHeader, nil, nil, "-", 5)
	self:moveObject(PowaOptionsFrameCloseButton, "+", 6, "+", 6)
	self:applySkin(PowaOptionsFrame)
-->>-- Config Frame
	self:getRegion(PowaBarConfigFrame, 1):SetAlpha(0) -- Header box
	self:moveObject(PowaHeader, nil, nil, "-", 4)
	self:moveObject(PowaCloseButton, "+", 6, "+", 6)
	self:applySkin(PowaBarConfigFrame)
	-- top Panel
	self:applySkin(PowaBarConfigFrameEditor)
	-- Activation Panel
	self:skinDropDown(PowaDropDownBuffType)
	self:skinEditBox(PowaBarBuffStacks, {9}, nil, true)
	self:moveObject(PowaBarBuffStacks, "-", 5, "-", 2)
	self:skinEditBox(PowaBarBuffName, {9}, nil, true)
	self:moveObject(PowaExactButton, nil, nil, "+", 8)
	self:skinEditBox(PowaBarMultiID, {9}, nil, true)
	self:moveObject(PowaBarMultiID, nil, nil, "+", 8)
	self:applySkin(PowaBarConfigFrameEditor2)
	-- Animation Panel
	self:applySkin(PowaBarConfigFrameEditor3)
	-- Timer Panel
	self:applySkin(PowaBarConfigFrameEditor4)
	-- Sound Panel
	self:applySkin(PowaBarConfigFrameEditor5)
	
end
