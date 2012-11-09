local aName, aObj = ...
if not aObj:isAddonEnabled("GnomishVendorShrinker") then return end

function aObj:GnomishVendorShrinker()

	local function getFirstChildOfType(obj, oType)
		for _, child in ipairs{obj:GetChildren()} do
			if child:IsObjectType(oType) then return child end
		end
	end

	local frame = self:findFrame2(MerchantFrame, "Frame", 294, 315)
	if frame then
		self:skinEditBox{obj=getFirstChildOfType(frame, "EditBox"), regs={9}}
		local slider = getFirstChildOfType(frame, "Slider")
		self:skinSlider{obj=slider}
		self:getChild(slider, 3):SetBackdrop(nil) -- slider border
	end

end
