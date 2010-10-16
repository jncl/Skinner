if not Skinner:isAddonEnabled("!Swatter") then return end

function Skinner:Swatter()

	self:skinSlider{obj=SwatterErrorInputScroll.ScrollBar}
	self:addSkinFrame{obj=SwatterErrorFrame}

end
