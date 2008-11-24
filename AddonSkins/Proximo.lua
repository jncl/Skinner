
function Skinner:Proximo()

	self:SecureHook(Proximo, "MakeFrame", function()
--		self:Debug("P_MF")
		self:applySkin(Proximo.frame)
		self:RawHook(Proximo.frame, "SetBackdropColor", function() end, true)
		self:RawHook(Proximo.frame, "SetBackdropBorderColor", function() end, true)
	end)

end
