
function Skinner:Spew()

	self:keepFontStrings(SpewPanel)
	local titleText = self:getRegion(SpewPanel, 2)
	self:moveObject(titleText, nil, nil, "+", 10)
	local cBtn = self:getChild(SpewPanel, 1) -- close button
	self:moveObject{obj=cBtn, y=11}
	self:skinButton{obj=cBtn, cb=true}
	local clrBtn = self:getChild(self:getChild(SpewPanel, 2), 1) -- clear button
	self:skinButton{obj=clrBtn}
	self:applySkin(SpewPanel)
	
end
