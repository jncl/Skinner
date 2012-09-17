local aName, aObj = ...
if not aObj:isAddonEnabled("xMerchant") then return end

function aObj:xMerchant()

	local frame = NuuhMerchantFrame or xMerchantFrame
	self:skinEditBox{obj=frame.search, regs={9}}
	self:skinScrollBar{obj=frame.scrollframe}
	frame.top:Hide()
	frame.bottom:Hide()

end
