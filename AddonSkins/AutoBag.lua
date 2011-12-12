local aName, aObj = ...
if not aObj:isAddonEnabled("Auto-Bag") then return end

function aObj:AutoBag()

	-- close with Esc
	self:add2Table(UISpecialFrames,"AB_Options")

	self:addSkinFrame{obj=AB_Arrange_ListBox, kfs=true, x1=-1, y1=-1}
	self:skinScrollBar{obj=AB_Arrange_ListBoxScrollFrame}
	self:skinDropDown{obj=AB_Bag_Dropdown}
	self:skinDropDown{obj=AB_Bag_Dropdown2}
	self:skinEditBox{obj=AB_Arrange_AddTextInput, regs={9}, noHeight=true, noWidth=true, x=-8, y=-2}
	self:skinButton{obj=AB_Arrange_Delete}
	self:skinButton{obj=AB_Arrange_Add}
	self:skinSlider{obj=AB_GoldSlider}
	self:skinDropDown{obj=AB_PoorBaseSelector}
	self:skinSlider{obj=AB_FreeSlotsSlider}
	self:adjWidth{obj=AB_Options, adj=220}
	self:adjHeight{obj=AB_Options, adj=150}
	self:addSkinFrame{obj=AB_Options, kfs=true, hdr=true}

end
