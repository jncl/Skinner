local aName, aObj = ...
if not aObj:isAddonEnabled("Squire2_Config") then return end

function aObj:Squire2_Config()

	self:skinButton{obj=Squire2ConfigButton}

end
