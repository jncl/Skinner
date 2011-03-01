local aName, aObj = ...
if not aObj:isAddonEnabled("FlightMapEnhanced") then return end

function aObj:FlightMapEnhanced()

	self:skinSlider{obj=FlightMapEnhancedTaxiChoiceContainerScrollBar}
	FlightMapEnhancedTaxiChoice:DisableDrawLayer("BACKGROUND")
	FlightMapEnhancedTaxiChoice:DisableDrawLayer("BORDER")
	self:addSkinFrame{obj=FlightMapEnhancedTaxiChoice, kfs=true, ofs=2}

	-- Flight Timer frame
	if FlightMapEnhanced_Config.vconf.modules["ft"] == 1 then
		local bd
		-- find the frame and skin it
		for _, child in pairs{UIParent:GetChildren()} do
			if child:GetName() == nil then
				if child.GetBackdrop then
					bd = child:GetBackdrop()
					if bd and bd.bgFile and bd.bgFile:find("ftimes_frame") then
						print("FlightMapEnhanced flight timer frame found")
						self:addSkinFrame{obj=child, kfs=true, y1=3, y2=12}
						break
					end
				end
			end
		end
	end

end
