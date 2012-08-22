local aName, aObj = ...
if not aObj:isAddonEnabled("Auto-Bag") then return end

function aObj:AutoBag()

	-- close with Esc
	self:add2Table(UISpecialFrames,"AB_Options")

	self:addSkinFrame{obj=AB_Arrange_ListBox, kfs=true, x1=-1, y1=-1}
	self:skinScrollBar{obj=AB_Arrange_ListBoxScrollFrame}
	self:skinDropDown{obj=AB_Bag_Dropdown, x2=60}
	self:skinDropDown{obj=AB_Bag_Dropdown2, x2=60}
	self:skinEditBox{obj=AB_Arrange_AddTextInput, regs={9}, noHeight=true, noWidth=true, x=-8, y=-2}
	self:skinButton{obj=AB_Arrange_Delete}
	self:skinButton{obj=AB_Arrange_Add}
	self:skinDropDown{obj=AB_PoorBaseSelector, x1=0, x2=110}
	self:adjWidth{obj=AB_Options, adj=220}
	self:adjHeight{obj=AB_Options, adj=150}
	self:addSkinFrame{obj=AB_Options, kfs=true, hdr=true}
	
	-- options panel
	self:skinDropDown{obj=AB_Groups_Dropdown, x2=60}

end
