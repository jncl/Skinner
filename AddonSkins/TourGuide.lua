
function Skinner:TourGuide()

	--	hook this to skin the Objectives Panel & Scroll Bar
	self:SecureHook(TourGuide, "CreateObjectivePanel", function()
		self:skinButton{obj=self:getChild(TourGuideObjectives, 1)} -- Config button
		self:skinButton{obj=self:getChild(TourGuideObjectives, 2)} -- Guides button
		self:skinSlider{obj=self:getChild(TourGuideObjectives, 3), size=3} -- the scroll frame slider
		self:addSkinFrame{obj=TourGuideObjectives}
		self:Unhook(TourGuide, "CreateObjectivePanel")
	end, true)

-->>-- Status Frame
	self:addSkinFrame{obj=TourGuide.statusframe}

-->>-- Item Frame
	self:addSkinButton{obj=TourGuideItemFrame, bg=true}

end
