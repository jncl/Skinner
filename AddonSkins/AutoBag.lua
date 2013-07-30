local aName, aObj = ...
if not aObj:isAddonEnabled("Auto-Bag") then return end
local _G = _G

function aObj:AutoBag()

	-- close with Esc
	self:add2Table(UISpecialFrames, "AB_Options")

	self:addSkinFrame{obj=_G.AB_Arrange_ListBox, kfs=true, x1=-1, y1=-1}
	self:skinScrollBar{obj=_G.AB_Arrange_ListBoxScrollFrame}
	self:skinDropDown{obj=_G.AB_Bag_Dropdown, x2=60}
	self:skinDropDown{obj=_G.AB_Bag_Dropdown2, x2=60}
	self:skinEditBox{obj=_G.AB_Arrange_AddTextInput, regs={9}, noHeight=true, noWidth=true, x=-8, y=-2}
	self:skinButton{obj=_G.AB_Arrange_Delete}
	self:skinButton{obj=_G.AB_Arrange_Add}
	self:skinDropDown{obj=_G.AB_PoorBaseSelector, x1=0, x2=110}
	self:adjWidth{obj=_G.AB_Options, adj=220}
	self:adjHeight{obj=_G.AB_Options, adj=150}
	self:addSkinFrame{obj=_G.AB_Options, kfs=true, hdr=true}
	
	-- -- options panel
	-- self:skinDropDown{obj=AB_Groups_Dropdown, x2=60}
	-- self:skinScrollBar{obj=AB_Groups_ListBoxScrollFrame}
	-- self:addSkinFrame{obj=AB_Groups_ListBox}

end
