
function Skinner:GnomishVendorShrinker()

	local frame = self:getChild(MerchantFrame, MerchantFrame:GetNumChildren() - 1)
	self:skinEditBox{obj=self:getChild(frame, 15), regs={9}}
	local slider = self:getChild(frame, 16)
	self:skinSlider{obj=slider}
	self:getChild(slider, 3):SetBackdrop(nil) -- slider border

end
