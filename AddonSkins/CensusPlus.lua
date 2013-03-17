local aName, aObj = ...
if not aObj:isAddonEnabled("CensusPlus") then return end

function aObj:CensusPlus()

	if self.modBtnBs then
		-- Race Buttons
		for i = 1, 7 do
			self:addButtonBorder{obj=_G["CensusPlusRaceLegend" .. i]}
		end
		-- Class Buttons
		for i = 1, 11 do
			self:addButtonBorder{obj=_G["CensusPlusClassLegend" .. i]}
		end
	end
	self:skinScrollBar{obj=CensusPlusGuildScrollFrame}
	self:addSkinFrame{obj=CensusPlus, kfs=true, ofs=-3, y1=-2}

	-- Options frame
	self:moveObject{obj=CP_OptionCloseButton, x=2, y=2}
	CensusOptionsFrameHeader:SetTexture(nil)
	self:moveObject{obj=CensusOptionsFrameHeader, y=-8}
	self:addSkinFrame{obj=CP_OptionsWindow, ofs=-6}

	-- Player List
	self:moveObject{obj=CP_PlayerListCloseButton, x=2, y=2}
	CensusPlayerListFrameHeader:SetTexture(nil)
	self:moveObject{obj=CensusPlayerListFrameHeader, y=-8}
	self:skinScrollBar{obj=CensusPlusPlayerListScrollFrame}
	self:addSkinFrame{obj=CP_PlayerListWindow, ofs=-6}

	-- Minimap button
	if self.db.profile.MinimapButtons.skin then
		self:skinButton{obj=CensusButton, ob="C", sap=true}
	end

end
