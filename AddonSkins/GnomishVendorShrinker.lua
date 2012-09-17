local aName, aObj = ...
if not aObj:isAddonEnabled("GnomishVendorShrinker") then return end

function aObj:GnomishVendorShrinker()

	local frame = self:findFrame2(MerchantFrame, "Frame", 294, 315)
	if frame then
		self:skinEditBox{obj=self:getFirstChildOfType(frame, "EditBox"), regs={9}}
		local slider = self:getFirstChildOfType(frame, "Slider")
		self:skinSlider{obj=slider}
		self:getChild(slider, 3):SetBackdrop(nil) -- slider border
	end

end
