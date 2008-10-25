
function Skinner:tekDebug()

	self:keepFontStrings(tekDebugPanel)
	local titleText = self:getRegion(tekDebugPanel, 2)
	self:moveObject(titleText, nil, nil, "+", 10)
	local cBut = self:getChild(tekDebugPanel, 1) -- close button
	self:moveObject(cBut, nil, nil, "+", 11)
	self:applySkin(tekDebugPanel)
	
	self:HookScript(tekDebugPanel, "OnShow", function(this)
		self.hooks[this].OnShow(this)
		for i = 2, 16 do
			self:getChild(tekDebugPanel, i):SetNormalTexture(nil) -- remove background texture
		end
		self:Unhook(tekDebugPanel, "OnShow")
		end)

end
