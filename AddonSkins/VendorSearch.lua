
function Skinner:VendorSearch()

	self:skinEditBox(MerchantFrameSearchFrame, {9}, nil, true, true)
	self:moveObject(MerchantFrameSearchFrame, nil, nil, "+", 10)
	self:skinEditBox(MerchantFrameSearchTypeFrame, {9}, nil, true, true)
	self:moveObject(MerchantFrameSearchTypeFrame, nil, nil, "+",10)
	self:moveObject(MerchantFrameRefreshButton, "+", 5, "+", 10)
	
	self.VendorSearch = nil

end
