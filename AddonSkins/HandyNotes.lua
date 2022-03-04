local aName, aObj = ...
if not aObj:isAddonEnabled("HandyNotes") then return end
local _G = _G

aObj.addonsToSkin.HandyNotes = function(self) -- v 1.6.5

	-- thanks to Xinhuan for the pointer in the code :-)
	local HNEditFrame = _G.LibStub("AceAddon-3.0"):GetAddon("HandyNotes"):GetModule("HandyNotes").HNEditFrame

	HNEditFrame.titleinputframe:SetBackdrop(nil)
	self:moveObject{obj=HNEditFrame.title, y=-6}
	self:skinEditBox(HNEditFrame.titleinputbox, {})
	self:addSkinFrame{obj=HNEditFrame.descframe, ft="a", nb=true}
	self:skinSlider{obj=HNEditFrame.descscrollframe.ScrollBar, size=3}
	self:skinDropDown{obj=HNEditFrame.icondropdown}
	self:skinCheckButton{obj=HNEditFrame.continentcheckbox}
	self:skinStdButton{obj=HNEditFrame.okbutton}
	self:skinStdButton{obj=HNEditFrame.cancelbutton}
	self:addSkinFrame{obj=HNEditFrame, kfs=true, ft="a", ofs=-5, y1=-4, y2=30}

end

aObj.addonsToSkin.HandyNotes_Shadowlands = function(self) -- v 44

	self:skinObject("slider", {obj=_G.HandyNotes_ShadowlandsAlphaMenuSliderOption.Slider})
	self:skinObject("slider", {obj=_G.HandyNotes_ShadowlandsScaleMenuSliderOption.Slider})

	local wmBtn = self:getLastChild(_G.WorldMapFrame)
	wmBtn.Border:SetTexture(nil)
	if self.modBtns then
		self:skinStdButton{obj=wmBtn, ofs=-1, clr="gold"}
	end

end
