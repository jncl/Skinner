
function Skinner:AutoProfit()
	if not self.db.profile.MerchantFrames then return end

	self:moveObject(AutoProfit_SellButton, nil, nil, "+", 28)

	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then AutoProfit_Tooltip:SetBackdrop(self.backdrop) end
		self:skinTooltip(AutoProfit_Tooltip)
	end
end
