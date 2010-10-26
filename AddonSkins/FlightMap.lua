if not Skinner:isAddonEnabled("FlightMap") then return end

function Skinner:FlightMap()

	-- Taxi Frame
	self:skinDropDown{obj=FlightMapTaxiContinents}
	
	-- Only shown in flight
	self:SecureHook("FlightMapTimes_OnUpdate", function()
		self:moveObject{obj=FlightMapTimesSpark, y=-3}
	end)
	self:removeRegions(FlightMapTimesFrame, {1, 3})
	self:moveObject{obj=FlightMapTimesText, y=-3}
	self:glazeStatusBar(FlightMapTimesFrame, 0)

	-- Tooltip
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then FlightMapTooltip:SetBackdrop(self.backdrop) end
		self:skinTooltip(FlightMapTooltip)
	end

end
