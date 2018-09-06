local aName, aObj = ...
if not aObj:isAddonEnabled("DejaCharacterStats") then return end
local _G = _G

aObj.addonsToSkin.DejaCharacterStats = function(self) -- v 800r106

	-- TODO: remove header textures
	-- TODO: remove detail line background
	-- TODO: skin checkboxes

	self:skinSlider{obj=_G.CharacterFrameInsetRightScrollBar, size=3}

	if self.modBtnBs then
		 self:addButtonBorder{obj=_G.PaperDollFrame.ExpandButton, ofs=-2}
	end
	if self.modBtns then
		self:skinStdButton{obj=_G.DCS_TableRelevantStats}
		self:skinStdButton{obj=_G.DCS_TableResetButton}
	end

	-- DCS_configButton (lock icon TRHS of papedoll frame)
	-- DCS_InterfaceOptConfigButton  (lock icon TRHS of IoF panel)

	-- stop DCS_InterfaceOptConfigButton being skinned when IoF opened
	self.iofBtn[_G.DCS_InterfaceOptConfigButton] = true

end
