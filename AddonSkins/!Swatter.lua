if not Skinner:isAddonEnabled("!Swatter") then return end

function Skinner:Swatter()

	self:skinSlider{obj=SwatterErrorInputScrollScrollBar}
	self:addSkinFrame{obj=SwatterErrorFrame}

end
