local aName, aObj = ...
if not aObj:isAddonEnabled("HandyNotes") then return end
local _G = _G

aObj.addonsToSkin.HandyNotes = function(self) -- v

	-- thanks to Xinhuan for the pointer in the code :-)
	local HNEditFrame = LibStub("AceAddon-3.0"):GetAddon("HandyNotes"):GetModule("HandyNotes").HNEditFrame

	HNEditFrame.titleinputframe:SetBackdrop(nil)
	self:skinEditBox(HNEditFrame.titleinputbox, {})
	self:addSkinFrame{obj=HNEditFrame.descframe, ft="a", nb=true}
	self:skinSlider{obj=HNEditFrame.descscrollframe.ScrollBar, size=3}
	self:skinDropDown{obj=HNEditFrame.icondropdown}
	self:skinDropDown{obj=HNEditFrame.leveldropdown}
	self:addSkinFrame{obj=HNEditFrame, kfs=true, ft="a", nb=true}

end
