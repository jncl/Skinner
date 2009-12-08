
function Skinner:xcalc()

	self:SecureHook(xcalc, "windowframe", function(this)
		self:skinAllButtons{obj=xcalc_window, x1=-2, y1=-2, x2=2, y2=2, ty=0}
		self:addSkinFrame{obj=xcalc_window, kfs=true}
		self:Unhook(xcalc, "windowframe")
	end)

	self:SecureHook(xcalc, "optionframe", function(this)
		self:skinAllButtons{obj=xcalc_optionwindow}
		self:addSkinFrame{obj=xcalc_optionwindow, kfs=true}
		self:Unhook(xcalc, "optionframe")
	end)

end
