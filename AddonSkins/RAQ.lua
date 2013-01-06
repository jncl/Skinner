local aName, aObj = ...
if not aObj:isAddonEnabled("RAQ") then return end

function aObj:RAQ()

	self:skinDropDown{obj=RAQDropDown}
	UIDropDownMenu_SetButtonWidth(RAQDropDown, 24)
	self:skinDropDown{obj=RAQOptionDropDown}
	UIDropDownMenu_SetButtonWidth(RAQOptionDropDown, 24)
	self:skinScrollBar{obj=RAQFrameScrollList}
	self:addSkinFrame{obj=RAQFrame, hdr=true}

end
