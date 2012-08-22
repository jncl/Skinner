local aName, aObj = ...
if not aObj:isAddonEnabled("Reforgenator") then return end

function aObj:Reforgenator()

	self:moveObject{obj=ReforgenatorPanel_CloseButton, x=9, y=3}
	self:skinDropDown{obj=ReforgenatorPanel_ModelSelection}
	self:skinDropDown{obj=ReforgenatorPanel_SandboxSelection}
	self:skinDropDown{obj=ReforgenatorPanel_TargetLevelSelection}
	self:skinScrollBar{obj=ReforgeListScrollFrame}
	for i = 1, 4 do
		_G["ReforgenatorPanel_Item"..i.."NameFrame"]:SetTexture(nil)
	end
	self:addSkinFrame{obj=ReforgenatorPanel}
	self:addSkinFrame{obj=ReforgenatorMessageTextFrame, kfs=true}

end
