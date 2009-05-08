
function Skinner:TourGuide()

	--	hook this to skin the Objectives Panel & Scroll Bar
	self:SecureHook(TourGuide, "CreateObjectivePanel", function()
		self:skinSlider(self:getChild(TourGuideObjectives, 3)) -- the scroll frame slider
		self:addSkinFrame{obj=TourGuideObjectives}
		self:Unhook(TourGuide, "CreateObjectivePanel")
	end, true)

-->>-- Status Frame
	self:addSkinFrame{obj=TourGuide.statusframe}

-->>-- Item Frame
	self:addSkinButton{obj=TourGuideItemFrame, bg=true}

end
