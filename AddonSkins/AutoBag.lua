local aName, aObj = ...
if not aObj:isAddonEnabled("Auto-Bag") then return end
local _G = _G

aObj.addonsToSkin["Auto-Bag"] = function(self) -- v 50200.00

	-- close with Esc key
	self:add2Table(_G.UISpecialFrames, "AB_Options")

	self:SecureHookScript(_G.AB_Options, "OnShow", function(this)
		self:skinCheckButton{obj=_G.AB_Options_Enable}
		self:addSkinFrame{obj=_G.AB_Arrange_ListBox, ft="a", kfs=true, nb=true, x1=-1, y1=-1}
		self:skinSlider{obj=_G.AB_Arrange_ListBoxScrollFrameScrollBar, size=3}
		self:skinDropDown{obj=_G.AB_Bag_Dropdown, x2=59}
		self:skinDropDown{obj=_G.AB_Bag_Dropdown2, x2=59}
		self:skinEditBox{obj=_G.AB_Arrange_AddTextInput, regs={9}, noHeight=true, noWidth=true, x=-8, y=-2}
		self:skinStdButton{obj=_G.AB_Arrange_Delete}
		self:skinStdButton{obj=_G.AB_Arrange_Add}
		self:skinSlider{obj=_G.AB_GoldSlider, hgt=-10}
		self:skinDropDown{obj=_G.AB_PoorBaseSelector, x1=0, x2=109}
		self:skinStdButton{obj=_G.AB_PreviewJunk}
		self:skinSlider{obj=_G.AB_FreeSlotsSlider, hgt=-10}
		self:skinCheckButton{obj=_G.AB_ForceDeleteButton}
		self:skinStdButton{obj=_G.AB_BagButton}
		self:addSkinFrame{obj=this, kfs=true, ft="a", hdr=true}
		this:SetSize(575, 400)
		self:Unhook(this, "OnShow")
	end)

	-- stop config being skinned twice
	self.iofSkinnedPanels[_G.AB_Options] = true

end
