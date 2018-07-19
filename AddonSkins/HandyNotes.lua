local aName, aObj = ...
if not aObj:isAddonEnabled("HandyNotes") then return end
local _G = _G

aObj.addonsToSkin.HandyNotes = function(self) -- v 1.5.2

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
