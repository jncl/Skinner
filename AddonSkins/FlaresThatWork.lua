local aName, aObj = ...
if not aObj:isAddonEnabled("FlaresThatWork") then return end

function aObj:FlaresThatWork()

	self:addSkinFrame{obj=FlaresThatWork.border}

end
