
function Skinner:TourGuide()

	-- move the UnlistedQuest frame up
	self:moveObject(self:getChild(QuestFrame, 7), "-", 10, "+", 26)

	--	hook this to skin the Objectives Panel Scroll Bar
	self:SecureHook(TourGuide, "CreateObjectivePanel", function()
		local TGOPS = self:getChild(TourGuideObjectives, 3)
		self:skinSlider(TGOPS)
		self:applySkin(TourGuideObjectives)
		self:Unhook(TourGuide, "CreateObjectivePanel")
	end, true)

	-- Status Frame
	self:applySkin(TourGuide.statusframe)
	self:RawHook(TourGuide.statusframe, "SetBackdropColor", function() end, true)
	-- Item Frame
	self:addSkinButton(TourGuideItemFrame, TourGuideItemFrame)

end
