
function Skinner:HealBot()
	if not self.db.profile.Tooltips.skin then return end

-->>--	Tooltips
	if self.db.profile.Tooltips.style == 3 then
		HealBot_ScanTooltip:SetBackdrop(self.backdrop)
		HealBot_Tooltip:SetBackdrop(self.backdrop)
	end
	self:skinTooltip(HealBot_ScanTooltip)
	self:skinTooltip(HealBot_Tooltip)

end
