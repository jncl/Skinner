local aName, aObj = ...
if not aObj:isAddonEnabled("PetJournalEnhanced") then return end

function aObj:PetJournalEnhanced()

	if PetJournalEnhancedOptions.showUniquePetCount then
		self:removeInset(PetJournalEnhanced:GetModule("UniquePets").frame)
	end
	
	-- hook this to change textures behind pet highStat
	self:SecureHook("PetJournal_UpdatePetList", function()
		-- make sure extra textures have been created
		if not PetJournal.listScroll.buttons[#PetJournal.listScroll.buttons].highStatBg then return end
		for i = 1, #PetJournal.listScroll.buttons do
			self:changeTandC(PetJournal.listScroll.buttons[i].highStatBg, self.lvlBG)
		end
		self:Unhook("PetJournal_UpdatePetList")
	end)

end