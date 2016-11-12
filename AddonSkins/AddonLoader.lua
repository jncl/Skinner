local aName, aObj = ...
if not aObj:isAddonEnabled("AddonLoader") then return end
local _G = _G

function aObj:AddonLoader()

	_G.AddonLoaderDropDownLeft:SetHeight(64)
	_G.AddonLoaderDropDownMiddle:SetHeight(64)
	_G.AddonLoaderDropDownRight:SetHeight(64)
	_G.AddonLoaderDropDownButton:SetPoint("TOPRIGHT", _G.AddonLoaderDropDownRight, "TOPRIGHT", -16, -18)
	self:moveObject{obj=_G.AddonLoaderDropDown, y=5}

end
