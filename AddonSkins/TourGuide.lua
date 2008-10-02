
function Skinner:TourGuide()

	-- move the UnlistedQuest frame up
	self:moveObject(self:getChild(QuestFrame, 7), "-", 10, "+", 26)

	--	hook this to skin the Objectives Panel Scroll Bar
	self:SecureHook(TourGuide, "CreateObjectivePanel", function()
		local TGOFSB = self:getChild(TourGuideObjectives, 3)
		self:keepFontStrings(TGOFSB)
		TGOFSB:GetThumbTexture():SetAlpha(1)
		self:skinUsingBD2(TGOFSB)
		self:applySkin(TourGuideObjectives)
		self:Unhook(TourGuide, "CreateObjectivePanel")
	end, true)

	-- Status Frame
	self:applySkin(TourGuide.statusframe)
	self:Hook(TourGuide.statusframe, "SetBackdropColor", function() end, true)
	-- Item Frame
	self:addSkinButton(TourGuideItemFrame, TourGuideItemFrame)

end
