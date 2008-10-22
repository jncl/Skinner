
function Skinner:tekDebug()

	self:keepFontStrings(tekDebugPanel)
	local titleText = self:getRegion(tekDebugPanel, 2)
	self:moveObject(titleText, nil, nil, "+", 8)
	local cBut = self:getChild(tekDebugPanel, 1)
	self:moveObject(cBut, "+", 0, "+", 8)
	self:applySkin(tekDebugPanel)
	
	self:HookScript(tekDebugPanel, "OnShow", function(this)
		self.hooks[this].OnShow(this)
		-- local eBox = self:getChild(this, 3)
		-- self:skinEditBox(eBox, {9})
		self:Unhook(tekDebugPanel, "OnShow")
		end)

end
