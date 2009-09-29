
function Skinner:AutoBag()
	if not self.db.profile.ContainerFrames.skin then return end

	AB_Divider_AutoBag:Hide()
	self:addSkinFrame{obj=AB_Arrange_ListBox, kfs=true, x1=-1}
	self:skinScrollBar{obj=AB_Arrange_ListBoxScrollFrame}
	self:skinDropDown{obj=AB_Bag_Dropdown}
	self:skinDropDown{obj=AB_Bag_Dropdown2}
	self:skinEditBox{obj=AB_Arrange_AddTextInput, regs={9}, noHeight=true, noWidth=true, x=-8, y=-2}
	self:addSkinFrame{obj=AB_Options, kfs=true, hdr=true, y2=10}

end
