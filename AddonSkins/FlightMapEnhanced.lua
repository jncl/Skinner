local aName, aObj = ...
if not aObj:isAddonEnabled("FlightMapEnhanced") then return end

function aObj:FlightMapEnhanced()

	self:skinSlider{obj=FlightMapEnhancedTaxiChoiceContainerScrollBar}
	FlightMapEnhancedTaxiChoice:DisableDrawLayer("BACKGROUND")
	FlightMapEnhancedTaxiChoice:DisableDrawLayer("BORDER")
	self:addSkinFrame{obj=FlightMapEnhancedTaxiChoice, kfs=true, ofs=2}

end
