local aName, aObj = ...
if not aObj:isAddonEnabled("FlightMapEnhanced") then return end

function aObj:FlightMapEnhanced()

	-- N.B. skin frame after buttons are created otherwise they aren't displayed
	self:SecureHookScript(FlightMapEnhancedTaxiChoice, "OnShow", function(this)
		for i = 1, #FlightMapEnhancedTaxiChoiceContainer.buttons do
			local btn = FlightMapEnhancedTaxiChoiceContainer.buttons[i]
			self:keepRegions(btn, {2, 6, 7, 8}) -- N.B. regions 2 & 7 are the text, 6 is the icon, 8 is the highlight
		end
		self:skinSlider{obj=FlightMapEnhancedTaxiChoiceContainerScrollBar, adj=-4}
		FlightMapEnhancedTaxiChoice:DisableDrawLayer("BACKGROUND")
		FlightMapEnhancedTaxiChoice:DisableDrawLayer("BORDER")
		self:addSkinFrame{obj=FlightMapEnhancedTaxiChoice, kfs=true, ofs=2}
		self:Unhook(FlightMapEnhancedTaxiChoice, "OnShow")
	end)

	-- Flight Timer frame
	if FlightMapEnhanced_Config
	and FlightMapEnhanced_Config.vconf
	and FlightMapEnhanced_Config.vconf.modules
	and FlightMapEnhanced_Config.vconf.modules["ft"] == 1 then
		local bd
		-- find the frame and skin it
		for _, child in pairs{UIParent:GetChildren()} do
			if child:GetName() == nil then
				if child.GetBackdrop then
					bd = child:GetBackdrop()
					if bd and bd.bgFile and bd.bgFile:find("ftimes_frame") then
						self:addSkinFrame{obj=child, kfs=true, y1=3, y2=12}
						break
					end
				end
			end
		end
	end

	-- Minimap button
	self:getRegion(FlightMapEnhancedMinimapButton, 1):SetDrawLayer("ARTWORK") -- move Icon's drawlayer
	self:removeRegions(FlightMapEnhancedMinimapButton, {2}) -- remove Border texture
	self:addSkinFrame{obj=FlightMapEnhancedMinimapButton}

end
