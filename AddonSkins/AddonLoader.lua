local aName, aObj = ...
if not aObj:isAddonEnabled("AddonLoader") then return end

function aObj:AddonLoader(...)
	
	AddonLoaderDropDownLeft:SetHeight(64)
	AddonLoaderDropDownMiddle:SetHeight(64)
	AddonLoaderDropDownRight:SetHeight(64)
	AddonLoaderDropDownButton:SetPoint("TOPRIGHT", AddonLoaderDropDownRight, "TOPRIGHT", -16, -18)
	self:moveObject{obj=AddonLoaderDropDown, y=5}
	
end
