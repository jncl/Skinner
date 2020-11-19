local aName, aObj = ...
if not aObj:isAddonEnabled("AutoDecline") then return end
local _G = _G

function aObj:AutoDecline()

	self:addSkinFrame{obj=_G.AD_TogglesBorder, kfs=true, hdr=true, y2=6}
	self:addSkinFrame{obj=_G.ADOptionsFrame, kfs=true, hdr=true, y2=4}

end
