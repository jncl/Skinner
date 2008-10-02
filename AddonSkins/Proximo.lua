
function Skinner:Proximo()

	self:SecureHook(Proximo, "MakeFrame", function()
--		self:Debug("P_MF")
		self:applySkin(Proximo.frame)
		self:Hook(Proximo.frame, "SetBackdropColor", function() end, true)
		self:Hook(Proximo.frame, "SetBackdropBorderColor", function() end, true)
	end)

end
