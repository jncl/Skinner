local aName, aObj = ...
if not aObj:isAddonEnabled("PetJournalEnhanced") then return end
local _G = _G

function aObj:PetJournalEnhanced()
	
	local PJE = _G.LibStub("AceAddon-3.0"):GetAddon("PetJournalEnhanced")
	if not PJE then return end
	
	-- hook this to remove unique count inset
	self:SecureHook(PJE, "InitPetJournal", function(this)
		self:removeInset(PJE:GetModule("UniquePets").frame)
		self:Unhook(PJE, "InitPetJournal")
	end)
	
	-- hook this to change textures behind pet highStat
	self:SecureHook(PJE:GetModule("Hooked"), "PetJournal_UpdatePetList", function()
		-- make sure extra textures have been created
		if not _G.PetJournal.listScroll.buttons[#_G.PetJournal.listScroll.buttons].highStatBg then return end
		for i = 1, #_G.PetJournal.listScroll.buttons do
			self:changeTandC(_G.PetJournal.listScroll.buttons[i].highStatBg, self.lvlBG)
		end
		self:Unhook(PJE:GetModule("Hooked"), "PetJournal_UpdatePetList")
	end)

end
