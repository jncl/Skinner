
function Skinner:AutoBag()
	if not self.db.profile.ContainerFrames.skin then return end

	AB_Options:SetHeight(AB_Options:GetHeight() - 30)
	self:keepFontStrings(AB_Options)
	AB_Divider_AutoBag:Hide()
	self:applySkin(AB_Arrange_ListBox)
	self:keepFontStrings(AB_Arrange_ListBoxScrollFrame)
	self:skinScrollBar(AB_Arrange_ListBoxScrollFrame)
	self:keepFontStrings(AB_Bag_Dropdown)
	self:keepFontStrings(AB_Bag_Dropdown2)
	self:skinEditBox(AB_Arrange_AddTextInput, {9})
	self:moveObject(AB_Arrange_AddTextInput, "-", 10, nil, nil)
	self:applySkin(AB_Options, true)

end
