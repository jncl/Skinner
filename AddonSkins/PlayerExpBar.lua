
function Skinner:PlayerExpBar()

	PlayerExpBarMain:SetWidth(PlayerExpBarMain:GetWidth() * 0.75)
	PlayerExpBarMain:SetHeight(PlayerExpBarMain:GetHeight() * 1.1)
	self:keepFontStrings(PlayerExpBarMain)
	self:glazeStatusBar(PlayerExpBarStatusBar, 0)


	PlayerExpBarPet:SetWidth(PlayerExpBarPet:GetWidth() * 0.75)
	PlayerExpBarPet:SetHeight(PlayerExpBarPet:GetHeight() * 1.1)
	self:keepFontStrings(PlayerExpBarPet)
	self:glazeStatusBar(PlayerExpBarPetStatusBar, 0)

	PlayerExpBar_RepWatch:SetWidth(PlayerExpBar_RepWatch:GetWidth() * 0.75)
	PlayerExpBar_RepWatch:SetHeight(PlayerExpBar_RepWatch:GetHeight() * 1.1)
	self:keepFontStrings(PlayerExpBar_RepWatch)
	self:glazeStatusBar(PlayerExpBar_RepWatchStatusBar, 0)

-->>--	Config Frame
	self:keepFontStrings(PlayerExpBarOptionsFrame)
	self:applySkin(PlayerExpBarOptionsFrame)
	self:SecureHook(PlayerExpBarOptionsFrame, "Show", function()
		self:moveObject(self:getRegion(PlayerExpBarOptionsFrame, 2), nil, nil, "-", 6)
		self:Unhook(PlayerExpBarOptionsFrame, "Show")
	end)

end
