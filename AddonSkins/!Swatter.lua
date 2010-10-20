if not Skinner:isAddonEnabled("!Swatter") then return end

function Skinner:Swatter()

	-- handle the fact that the AddOn was loaded but, due to it checking for another debugging aid, didn't initialise
	if Swatter and Swatter.Version then
		self:skinSlider{obj=SwatterErrorInputScroll.ScrollBar}
		self:addSkinFrame{obj=SwatterErrorFrame}
	end

end
