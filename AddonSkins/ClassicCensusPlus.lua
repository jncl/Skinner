local aName, aObj = ...
if not aObj:isAddonEnabled("ClassicCensusPlus") then return end
local _G = _G

if aObj.isRtl then return end

aObj.addonsToSkin.ClassicCensusPlus = function(self) -- v 1.0.0

	-- Minimap button [do here before table is removed]
	self.mmButs["ClassicCensusPlus"] = _G.CensusButton
	_G.CensusButton:GetNormalTexture():SetTexture(nil) -- remove background texture

	self:addSkinFrame{obj=_G.MiniCensusPlus, ft="a", kfs=true, nb=true}
	if self.modBtns then
		self:skinStdButton{obj=_G.CensusPlusMaximizeButton}
		self:skinCloseButton{obj=_G.MiniCensusPlusCloseButton}
	end

	self:skinSlider{obj=_G.CensusPlusGuildScrollFrame.ScrollBar}
	self:addSkinFrame{obj=_G.ClassicCensusPlus, ft="a", kfs=true, nb=true, x2=30}
	if self.modBtns then
		self:skinStdButton{obj=_G.CP_DisplayOptionsButton}
		self:skinCloseButton{obj=_G.CensusPlusCloseButton}
		self:skinStdButton{obj=_G.CensusPlusMinimizeButton}
		self:skinStdButton{obj=_G.CensusPlusTakeButton}
		self:skinStdButton{obj=_G.CensusPlusStopButton}
		self:skinStdButton{obj=_G.CensusPlusPruneButton}
		self:skinStdButton{obj=_G.CensusPlusPurgeButton}
		self:skinStdButton{obj=_G.CP_DisplayCharactersButton}
		self:skinStdButton{obj=_G.CP_DisplayOptionsButton}
	end
	if self.modBtnBs then
		for i = 1, 4 do
			self:addButtonBorder{obj=_G["CensusPlusRaceLegend" .. i]}
		end
		for i = 1, 8 do
			self:addButtonBorder{obj=_G["CensusPlusClassLegend" .. i]}
		end
	end

	self:addSkinFrame{obj=_G.CP_EU_US_Version, ft="a", kfs=true, nb=true}
	if self.modBtns then
		self:skinStdButton{obj=_G.CP_US}
		self:skinStdButton{obj=_G.CP_EU}
	end

	self:skinSlider{obj=_G.CensusPlusPlayerListScrollFrame.ScrollBar}
	self:addSkinFrame{obj=_G.CP_PlayerListWindow, ft="a", kfs=true, nb=true, hdr=true}
	if self.modBtns then
		self:skinCloseButton{obj=_G.CP_PlayerListCloseButton}
	end

end
