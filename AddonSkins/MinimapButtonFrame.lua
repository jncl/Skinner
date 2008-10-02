
function Skinner:MinimapButtonFrame()

	self:applySkin(MinimapButtonFrameDragButton)
	self:applySkin(MinimapButtonFrame)

-->>--	Options Frame
	self:keepFontStrings(MBFC)
	self:applySkin(MBFC)
	self:moveObject(self:getRegion(MBFC, 2), nil, nil, "-", 4)
	self:keepFontStrings(MBFCColorLockedDropDown)
	self:keepFontStrings(MBFCSortDropDown)
	self:applySkin(MBFCTabContainerFrame)

	self:keepRegions(MBFCTabContainerFrameTab1, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
	self:moveObject(MBFCTabContainerFrameTab1, nil, nil, "+", 2)
	self:keepRegions(MBFCTabContainerFrameTab2, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
	self:moveObject(MBFCTabContainerFrameTab2, "+", 10, nil, nil)
	if self.db.profile.TexturedTab then
		self:applySkin(MBFCTabContainerFrameTab1, nil, 0, 1)
		self:applySkin(MBFCTabContainerFrameTab2, nil, 0, 1)
		self:setActiveTab(MBFCTabContainerFrameTab1)
		self:setInactiveTab(MBFCTabContainerFrameTab2)
		self:SecureHook(MBFCTabPage1, "Show", function(this)
			self:setActiveTab(MBFCTabContainerFrameTab1)
			self:setInactiveTab(MBFCTabContainerFrameTab2)
		end)
		self:SecureHook(MBFCTabPage2, "Show", function(this)
			self:setActiveTab(MBFCTabContainerFrameTab2)
			self:setInactiveTab(MBFCTabContainerFrameTab1)
		end)
	else
		self:applySkin(MBFCTabContainerFrameTab1)
		self:applySkin(MBFCTabContainerFrameTab2)
	end

	-- hook these to stop the colour changing
	self:Hook("MBFC_ColorLocked", function() end, true)
	self:Hook("MBFC_ColorOpacityUpdate", function() end, true)
	self:Hook("MBFC_ColorUpdate", function() end, true)

end
