
function Skinner:TheCollector()

	self:getChild(TheCollectorFrame, 2):Hide() -- button in TLH corner
	self:skinFFToggleTabs("TheCollectorFrameTab", 3)
	self:skinScrollBar{obj=TheCollectorFrameScrollFrame}
	self:getChild(TheCollectorFrameStatusBar, 1):SetAlpha(0) -- border texture
	self:glazeStatusBar(TheCollectorFrameStatusBar, 0)
	self:keepFontStrings(TheCollectorFrameHeaderFrame)
	self:addSkinFrame{obj=TheCollectorFrame, kfs=true, x1=4, y1=-5, x2=-5, y2=-10}
	
	-- skin buttons
	if self.db.profile.Buttons then
		-- hook to manage changes to button textures
		self:SecureHook("TheCollectorScrollFrameUpdate", function()
			for i = 1, COLLECTOR_NUM_ITEMS_TO_DISPLAY do
				self:checkTex(_G["TheCollectorFrameScrollFrameHeader"..i])
			end
		end)
	end
	self:skinButton{obj=self:getChild(TheCollectorFrame, 3), cb=true} -- close button TRHC
	self:skinButton{obj=self:getChild(TheCollectorFrame, 4)} -- close button BRHC
	for i = 1, COLLECTOR_NUM_ITEMS_TO_DISPLAY do
		self:skinButton{obj=_G["TheCollectorFrameScrollFrameHeader"..i], mp=true}
	end
	
end
