local aName, aObj = ...
if not aObj:isAddonEnabled("CombustionHelper") then return end

function aObj:CombustionHelper()

	-- disable rebuild of frame backdrops
	CombuBackdropBuild = function() end
	CombuMBTrackerBackdropBuild = function() end

	self:addSkinFrame{obj=CombustionFrame}
	self:glazeStatusBar(Pyrobar, 0,  nil)
	self:glazeStatusBar(Ignbar, 0,  nil)
	self:glazeStatusBar(LBbar, 0,  nil)
	self:glazeStatusBar(Combubar, 0,  nil)

	-- Living Bomb Tracker
	self:addSkinFrame{obj=CombuMBTrackerBorderFrame}

	-- Options tooltip frame
	self:addSkinFrame{obj=CombuOptionsTooltipFrame}

	-- Options frame (part of IOP)
	if self.modBtns then
		for _, v in pairs{"Scale", "Bar", "beforefade", "fadeoutspeed", "fadeinspeed", "afterfade"} do
			self:skinButton{obj=_G["Combu"..v.."SliderMinus"], mp=true}
			self:skinButton{obj=_G["Combu"..v.."SliderPlus"], mp=true, plus=true}
		end
		-- graphical options
		for _, v in pairs{"EdgeSize", "TileSize", "Insets"} do
			self:skinButton{obj=_G["Combu"..v.."SliderMinus"], mp=true}
			self:skinButton{obj=_G["Combu"..v.."SliderPlus"], mp=true, plus=true}
		end
		-- magebomb tracker
		for _, v in pairs{"Scale", "EdgeSize", "TileSize", "Insets"} do
			self:skinButton{obj=_G["CombuMBTracker"..v.."SliderMinus"], mp=true}
			self:skinButton{obj=_G["CombuMBTracker"..v.."SliderPlus"], mp=true, plus=true}
		end

	end
	-- graphical options
	for k, v in pairs{"Font", "Sound", "Texture", "Edge", "Bg"} do
		self:skinSlider{obj=_G["Combu"..v.."ScrollFrame"].ScrollBar, adj=-4}
		self:addSkinFrame{obj=_G["Combu"..v.."BorderFrame"]}
	end
	-- magebomb options
	for k, v in pairs{"Font", "Sound", "Texture", "Edge", "Bg"} do
		self:skinSlider{obj=_G["CombuMBTracker"..v.."ScrollFrame"].ScrollBar, adj=-4}
		self:addSkinFrame{obj=_G["CombuMBTracker"..v.."BorderFrame"]}
	end

end
