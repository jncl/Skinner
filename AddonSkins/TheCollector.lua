
function Skinner:TheCollector()

	self:getChild(TheCollectorFrame, 2):Hide() -- button in TLH corner
	self:skinFFToggleTabs("TheCollectorFrameTab", 3)
	self:skinScrollBar{obj=TheCollectorFrameScrollFrame}
	self:getChild(TheCollectorFrameStatusBar, 1):SetAlpha(0) -- border texture
	self:glazeStatusBar(TheCollectorFrameStatusBar, 0)
	self:keepFontStrings(TheCollectorFrameHeaderFrame)
	self:addSkinFrame{obj=TheCollectorFrame, kfs=true, x1=4, y1=-5, x2=-5, y2=-10}
	
	self:moveObject{obj=TheCollectorPetToggleButton, y=-2}
	
end
