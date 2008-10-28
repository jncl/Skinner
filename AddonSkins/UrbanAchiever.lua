
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
	this.frame.category.backdrop:SetAlpha(0)
	self:moveObject(this.frame.category, "-", 10, nil, nil)
	self:applySkin(this.frame.category)
	self:applySkin(this.frame, true)
	
-->>-- Category Buttons
	local bDrop = CopyTable(self.backdrop)
	bDrop.edgeSize = 8
	for i = 1, #this.frame.catButtons do
		local catBtn = this.frame.catButtons[i]
		self:keepFontStrings(catBtn)
		self:getRegion(catBtn, 3):SetAlpha(1) -- highlight texture
		self:applySkin(catBtn, nil, nil, nil, nil, bDrop)
	end
-->>-- Achievement Display Frame
	self:keepRegions(this.frame.display.bar, {3, 4, 5})
	self:glazeStatusBar(this.frame.display.bar, 0)
	self:keepRegions(this.frame.display.compareBar, {3, 4, 5})
	self:glazeStatusBar(this.frame.display.compareBar, 0)
	self:skinSlider(this.frame.criteriaScroll)
	
-->>-- Tracker Frame
	self:applySkin(UrbanAchieverTrackerFrame.header)

-->>-- Tabs
	for i = 1, #this.frame.tabButtons do
		local tabObj = this.frame.tabButtons[i]
		tabObj.backdrop:SetAlpha(0)
		if self.db.profile.TexturedTab then
			self:applySkin(tabObj, nil, 0, 1)
			if i == 1 then self:setActiveTab(tabObj)
			else self:setInactiveTab(tabObj) end
		else self:applySkin(tabObj) end
	end
	if self.db.profile.TexturedTab then 
		self:SecureHook(this, "RefreshCategoryButtons", function(this)
			for i = 1, #this.frame.tabButtons do
				if this.currentTab == "achievements" then
					self:setActiveTab(this.frame.tabButtons[1])
					self:setInactiveTab(this.frame.tabButtons[2])
				else 
					self:setActiveTab(this.frame.tabButtons[2])
					self:setInactiveTab(this.frame.tabButtons[1])
				end
			end
		end)
	end
	
	
end

