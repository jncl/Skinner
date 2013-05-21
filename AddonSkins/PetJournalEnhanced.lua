local aName, aObj = ...
if not aObj:isAddonEnabled("PetJournalEnhanced") then return end
local _G = _G

function aObj:PetJournalEnhanced() -- LoD
	
	local PJE = _G.LibStub("AceAddon-3.0"):GetAddon("PetJournalEnhanced")
	if not PJE then return end
	
	self:removeInset(PJE:GetModule("UniquePets").frame) -- inset around unique pets count
	
	-- PetList scroll frame & buttons
	local petList = PJE:GetModule("PetList")
	self:skinSlider{obj=petList.listScroll.scrollBar, adj=-4}
	for i = 1, #petList.listScroll.buttons do
		local btn = petList.listScroll.buttons[i]
		self:removeRegions(btn, {1}) -- background
		self:changeTandC(btn.dragButton.levelBG, self.lvlBG)
	end

end
