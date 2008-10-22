
function Skinner:UrbanAchiever()
	if not self.db.profile.Achievements then return end
	
	local this = UrbanAchiever
	self:keepFontStrings(this.frame)
	this.frame.close:SetPoint("TOPRIGHT", this.frame, "TOPRIGHT")
	local uaPS = UrbanAchieverFramePointShield
	uaPS:SetAlpha(1)
	uaPS:SetPoint("TOP", this.frame, "TOP", 60, -5)
	this.pointsText:SetPoint("LEFT", uaPS, "RIGHT", 5, 2)
	this.compPointsText:SetPoint("TOPRIGHT", this.frame, "TOP", -67, -5)
	self:skinEditBox(self:getChild(this.frame.editbox, 1), {9})
	self:keepRegions(this.frame.summaryBar, {3, 4, 5})
	self:glazeStatusBar(this.frame.summaryBar, 0)
	self:keepRegions(this.frame.comparisonSummaryBar, {3, 4, 5})
	self:glazeStatusBar(this.frame.comparisonSummaryBar, 0)
	self:skinSlider(this.frame.catScroll)
	self:skinSlider(this.frame.achScroll)
	-- Category frame
	self:moveObject(this.frame.category, "-", 10, nil, nil)
	self:applySkin(this.frame.category)
	self:applySkin(this.frame, true)
	
-->>-- Tabs
	for i = 1, #this.frame.tabButtons do
		local tabName = this.frame.tabButtons[i]
		self:keepRegions(tabName, {1, 3}) -- N.B. region 3 is the Text, 1 is the highlight
		if i == 1 then self:moveObject(tabName, nil, nil, "+", 1)
		else self:moveObject(tabName, "-", 2, nil, nil) end
		if self.db.profile.TexturedTab then self:applySkin(tabName, nil, 0, 1)
		else self:applySkin(tabName) end
	end
-->>-- Category Buttons
	local bDrop = CopyTable(self.backdrop)
	bDrop.edgeSize = 8
	for i = 1, #this.frame.catButtons do
		local catBtn = this.frame.catButtons[i]
		self:keepFontStrings(catBtn)
		self:getRegion(catBtn, 3):SetAlpha(1) -- highlight texture
		self:applySkin(catBtn, nil, nil, nil, nil, bDrop)
	end
-->>-- Achievement Buttons
	-- for i = 1, #this.frame.achButtons do
	-- 	local achBtn = this.frame.achButtons[i]
	-- 	self:keepRegions(achBtn, {3, 4}) -- N.B. region 3 is the 
	-- 	self:applySkin(achBtn)
	-- end
-->>-- Achievement Sort Buttons
	-- this.frame.achSort.name
	-- this.frame.achSort.points
	-- this.frame.achSort.completed
	-- this.frame.achSort.comparison
-->>-- Achievement Display Frame
	self:keepRegions(this.frame.display.bar, {3, 4, 5})
	self:glazeStatusBar(this.frame.display.bar, 0)
	self:keepRegions(this.frame.display.compareBar, {3, 4, 5})
	self:glazeStatusBar(this.frame.display.compareBar, 0)
	self:skinSlider(this.frame.criteriaScroll)
	
end

