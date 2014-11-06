local aName, aObj = ...
if not aObj:isAddonEnabled("FlightMapEnhanced") then return end
local _G = _G

function aObj:FlightMapEnhanced()

	-- N.B. skin frame after buttons are created otherwise they aren't displayed
	self:SecureHookScript(_G.FlightMapEnhancedTaxiChoice, "OnShow", function(this)
		for i = 1, #_G.FlightMapEnhancedTaxiChoiceContainer.buttons do
			local btn = _G.FlightMapEnhancedTaxiChoiceContainer.buttons[i]
			self:keepRegions(btn, {2, 6, 7, 8}) -- N.B. regions 2 & 7 are the text, 6 is the icon, 8 is the highlight
		end
		self:skinSlider{obj=_G.FlightMapEnhancedTaxiChoiceContainerScrollBar, adj=-4}
		_G.FlightMapEnhancedTaxiChoice:DisableDrawLayer("BACKGROUND")
		_G.FlightMapEnhancedTaxiChoice:DisableDrawLayer("BORDER")
		self:addSkinFrame{obj=_G.FlightMapEnhancedTaxiChoice, kfs=true, ofs=2}
		self:Unhook(_G.FlightMapEnhancedTaxiChoice, "OnShow")
	end)

	-- Flight Timer frame
	if _G.FlightMapEnhanced_Config
	and _G.FlightMapEnhanced_Config.vconf
	and _G.FlightMapEnhanced_Config.vconf.modules
	and _G.FlightMapEnhanced_Config.vconf.modules["ft"] == 1 then
		self.RegisterCallback("FlightMapEnhanced", "UIParent_GetChildren", function(this, child)
			if child.texture
			and child.flightpath
			and child.timeleft
			and child.modus
			then
				child.texture:SetTexture(nil)
				self:addSkinFrame{obj=child, kfs=true, y1=5, y2=12}
				-- hook this to adjust timer frame width, as required
				self:SecureHookScript(child, "OnShow", function(this)
					local tw = self:getRegion(this, 2):GetWidth()
					if this:GetWidth() - 25 < tw then
						this:SetWidth(tw + 25)
					end
				end)
				self.UnregisterCallback("FlightMapEnhanced", "UIParent_GetChildren")
			end
		end)
		-- hook this to increase height of Tooltip for Flight times info
		self:SecureHook("TaxiNodeOnButtonEnter", function()
			_G.GameTooltip:SetHeight(_G.GameTooltip:GetHeight() + 12)
		end)
	end

	-- Minimap button
	self:getRegion(_G.FlightMapEnhancedMinimapButton, 1):SetDrawLayer("ARTWORK") -- move Icon's drawlayer
	self:removeRegions(_G.FlightMapEnhancedMinimapButton, {2}) -- remove Border texture
	self:addSkinFrame{obj=_G.FlightMapEnhancedMinimapButton}

end
