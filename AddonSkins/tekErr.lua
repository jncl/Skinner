
function Skinner:tekErr()

	self:keepFontStrings(tekErrPanel)
	local titleText = self:getRegion(tekErrPanel, 2)
	self:moveObject(titleText, nil, nil, "+", 8)
	local cBut = self:getChild(tekErrPanel, 1)
	self:moveObject(cBut, "+", 0, "+", 8)
	self:applySkin(tekErrPanel)
	
	self:HookScript(tekErrPanel, "OnShow", function(this)
		self.hooks[this].OnShow(this)
		local eBox = self:getChild(this, 3)
		self:skinEditBox(eBox, {9})
		self:Unhook(tekErrPanel, "OnShow")
		end)

end
