if not Skinner:isAddonEnabled("RaidComp") then return end

function Skinner:RaidComp()

	-- stop tooltip backdrop being changed
	RaidComp.Tooltip_SetColor = function() end

	if self.modBtns then
		-- hook this to skin the buttons
		self:SecureHook(RaidComp, "BuildGUI", function(this)
			self:skinButton{obj=RC_GUI_TooltipCloseX, cb=true}
			self:skinButton{obj=RC_GUI_Help}
			self:Unhook(RaidComp, "BuildGUI")
		end)
	end

end
