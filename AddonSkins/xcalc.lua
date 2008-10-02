
function Skinner:xcalc()

	self:SecureHook("xcalc_windowframe", function()
		self:keepFontStrings(xcalc_window)
		self:applySkin(xcalc_window)
		self:Unhook("xcalc_windowframe")
	end)

	self:SecureHook("xcalc_optionframe", function()
		self:keepFontStrings(xcalc_optionwindow)
		self:applySkin(xcalc_optionwindow)
		self:Unhook("xcalc_optionframe")
	end)

end
