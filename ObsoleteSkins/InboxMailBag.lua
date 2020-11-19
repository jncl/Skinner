local aName, aObj = ...
if not aObj:isAddonEnabled("InboxMailBag") then return end

function aObj:InboxMailBag()

	self:skinEditBox{obj=InboxMailbagFrameItemSearchBox, regs={9}, mi=true}
	self:skinScrollBar{obj=InboxMailbagFrameScrollFrame}
	self:keepFontStrings(InboxMailbagFrame)
	if self.modBtnBs then
		for i = 1, BAGITEMS_ICON_DISPLAYED do
			self:addButtonBorder{obj=_G["InboxMailbagFrameItem" .. i], ibt=true}
		end
	end

end
