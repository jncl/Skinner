
function Skinner:WoWPro()

	-- hook this as buttons only created here
	self:SecureHook(WoWPro, "CreateObjectivePanel", function()
		self:skinSlider{obj=self:getChild(WoWPro.objectiveframe, 3), size=3} -- the scroll frame slider
		self:skinAllButtons{obj=WoWPro.objectiveframe}
		self:addSkinFrame{obj=WoWPro.objectiveframe}
		self:Unhook(WoWPro, "CreateObjectivePanel")
	end)
	
-->>-- Status Frame
	self:addSkinFrame{obj=WoWPro.statusframe}
-->>-- Item button
	self:addSkinButton{obj=WoWProItemFrame, bg=true}

end
