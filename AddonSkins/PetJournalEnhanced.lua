local _, aObj = ...
if not aObj:isAddonEnabled("PetJournalEnhanced") then return end
local _G = _G

aObj.lodAddons.PetJournalEnhanced = function(self) -- v 2.9.30

	local PJE = _G.LibStub("AceAddon-3.0"):GetAddon("PetJournalEnhanced")
	if not PJE then return end
	
	self:removeInset(PJE:GetModule("UniquePets").frame) -- inset around unique pets count
	
	local petList = PJE:GetModule("PetList")
	self:skinObject("slider", {obj=petList.listScroll.scrollBar})
	for i = 1, #petList.listScroll.buttons do
		local btn = petList.listScroll.buttons[i]
		self:removeRegions(btn, {1}) -- background
		self:changeTandC(btn.dragButton.levelBG)
	end
	local dropdown = PJE:GetModule("DropDown")
	self:skinObject("dropdown", {obj=dropdown.menuFrame})
	self:skinObject("dropdown", {obj=dropdown.petOptionsMenu})
	if self.modBtns then
		self:skinStdButton{obj=dropdown.filterButton}
	end

end
