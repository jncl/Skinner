local aName, aObj = ...
if not aObj:isAddonEnabled("Possessions") then return end

function aObj:Possessions()

	self:moveObject{obj=Possessions_FrameTitle, y=-6}
	self:moveObject{obj=Possessions_FrameCloseButton, x=8, y=9}
	self:skinDropDown{obj=Possessions_CharDropDown, x2=35}
	self:skinDropDown{obj=Possessions_LocDropDown, x2=35}
	self:skinDropDown{obj=Possessions_SlotDropDown, x2=35}
	self:skinDropDown{obj=Possessions_TypeDropDown, x2=35}
	self:skinDropDown{obj=Possessions_SubTypeDropDown, x2=35}
	self:skinEditBox{obj=Possessions_SearchBox, regs={9}}
	self:skinScrollBar{obj=Possessions_IC_ScrollFrame}
	for i = 1, 15 do
		self:keepFontStrings(_G["POSSESSIONS_BrowseButton"..i])
	end
	self:addSkinFrame{obj=Possessions_Frame, kfs=true}

end
