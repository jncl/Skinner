
function Skinner:Spew()

	self:keepFontStrings(SpewPanel)
	local titleText = self:getRegion(SpewPanel, 2)
	self:moveObject(titleText, nil, nil, "+", 10)
	local cBut = self:getChild(SpewPanel, 1) -- close button
	self:moveObject(cBut, nil, ni, "+", 11)
	self:applySkin(SpewPanel)
	
end
