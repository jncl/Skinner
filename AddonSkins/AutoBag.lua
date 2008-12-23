
function Skinner:AutoBag()
	if not self.db.profile.ContainerFrames.skin then return end

	self:keepFontStrings(AB_Options)
	self:moveObject(AB_Options_Close, nil, nil, "-", 10)
	self:moveObject(AB_Options_Enable, nil, nil, "+", 8)
	AB_Divider_AutoBag:Hide()
	self:applySkin(AB_Arrange_ListBox)
	AB_Arrange_ListBox:SetWidth(AB_Arrange_ListBox:GetWidth() + 20)
	AB_Arrange_ListBox:SetHeight(AB_Arrange_ListBox:GetHeight() + 50)
	self:keepFontStrings(AB_Arrange_ListBoxScrollFrame)
	self:skinScrollBar(AB_Arrange_ListBoxScrollFrame)
	self:skinDropDown(AB_Bag_Dropdown)
	self:moveObject(AB_Bag_Dropdown, "-", 20, "-", 30)
	self:skinDropDown(AB_Bag_Dropdown2)
	self:moveObject(AB_Bag_Dropdown2, "-", 20, "-", 30)
	self:skinEditBox(AB_Arrange_AddTextInput, {9})
	self:moveObject(AB_Arrange_AddTextInput, "-", 10, nil, nil)
	self:applySkin(AB_Options, true)

end
