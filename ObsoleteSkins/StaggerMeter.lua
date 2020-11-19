local aName, aObj = ...
if not aObj:isAddonEnabled("StaggerMeter") then return end
local _G = _G

function aObj:StaggerMeter()

	if self.uCls ~= "MONK" then return end

	local smmf = self:getChild(_G.StaggerFrameIcon, 1)
	self:addSkinFrame{obj=smmf}
	local smcpf = self:getChild(smmf, 1)
	local smmpf = self:getChild(smmf, 2)

end
