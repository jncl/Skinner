
function Skinner:TheCollector()

	self:keepFontStrings(TheCollectorFrame)
	self:keepFontStrings(TheCollectorFrameHeaderFrame)
	self:moveObject(TheCollectorFrameHeaderFrameText, nil, nil, "+", 7)
	self:getChild(TheCollectorFrame, 2):Hide() -- button in TLH corner
	self:skinFFToggleTabs("TheCollectorFrameTab", 2)
	self:moveObject(TheCollectorFrameTab1, nil, nil, "-", 10)
	self:keepFontStrings(TheCollectorFrameScrollFrame)
	self:skinScrollBar(TheCollectorFrameScrollFrame)
	self:moveObject(TheCollectorFrameScrollFrame, nil, nil, "+", 10)
	self:getChild(TheCollectorFrameStatusBar, 1):SetAlpha(0) -- border texture
	self:glazeStatusBar(TheCollectorFrameStatusBar, 0)
	self:moveObject(TheCollectorFrameStatusBar, nil, nil, "+", 10)
	self:moveObject(self:getChild(TheCollectorFrame, 4), nil, nil, "+", 10) -- close button in BRH corner
	self:applySkin(TheCollectorFrame)
	
--[[
	-- Model Frame
	self:applySkin(TheCollectorModelFrame)
	self:makeMFRotatable(TheCollectorModel)
	TheCollectorModelRotateLeftButton:Hide()
	TheCollectorModelRotateRightButton:Hide()
--]]
	
end
