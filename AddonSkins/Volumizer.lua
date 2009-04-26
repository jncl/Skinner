
function Skinner:Volumizer()

	self:applySkin(VolumizerPanel)
	local tb = self:getChild(VolumizerPanel, 1)
	tb:SetBackdrop(nil)
	self:moveObject(self:getRegion(tb, 1), nil, nil, "-", 6)

end
