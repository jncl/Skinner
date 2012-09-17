if not Skinner:isAddonEnabled("PetsPlus") then return end

function Skinner:PetsPlus()

	PetsPlusArtContainerBackground:SetAlpha(0)
	PetsPlusFrameRepText:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:addSkinFrame{obj=PetsPlusArtContainer, hdr=true}
	
	PetsPlusCompactRepBar:SetBackdrop(nil)
	self:glazeStatusBar(PetsPlusCompactRepBar, 0,  nil)
	PetsPlusRepBar:SetBackdrop(nil)
	self:glazeStatusBar(PetsPlusRepBar, 0,  nil)

end
