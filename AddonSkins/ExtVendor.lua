local aName, aObj = ...
if not aObj:isAddonEnabled("ExtVendor") then return end

function aObj:ExtVendor()

	self:skinEditBox{obj=MerchantFrameSearchBox, regs={9}}
	self:moveObject{obj=MerchantFrameSearchBoxSearchIcon, x=20}
	
	if self.modBtnBs then
		self:addButtonBorder{obj=MerchantFrameSellJunkButton}
	end
	self:skinButton{obj=MerchantFrameFilterButton}
	self:skinDropDown{obj=MerchantFrameFilterDropDown}

end
