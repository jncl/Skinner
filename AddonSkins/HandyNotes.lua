local aName, aObj = ...
if not aObj:isAddonEnabled("HandyNotes") then return end

function aObj:HandyNotes()

	-- thanks to Xinhuan for the pointer in the code :-)
	local HNEditFrame = LibStub("AceAddon-3.0"):GetAddon("HandyNotes"):GetModule("HandyNotes").HNEditFrame
	
	HNEditFrame.titleinputframe:SetBackdrop(nil)
	self:skinEditBox(HNEditFrame.titleinputbox, {})
	self:addSkinFrame{obj=HNEditFrame.descframe}
	self:skinScrollBar{obj=HNEditFrame.descscrollframe}
	self:skinDropDown{obj=HNEditFrame.icondropdown}
	self:skinDropDown{obj=HNEditFrame.leveldropdown}
	self:addSkinFrame{obj=HNEditFrame, kfs=true}

end
