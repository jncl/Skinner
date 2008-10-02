
function Skinner:AutoProfit()
	if not self.db.profile.MerchantFrames then return end

	self:moveObject(TreasureModel, nil, nil, "+", 28)
	self:moveObject(AutosellButton, nil, nil, "+", 28)

end
