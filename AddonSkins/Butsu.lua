
function Skinner:Butsu()
	if not self.db.profile.LootFrame then return end

	self:applySkin(Butsu)
	self:RawHook(Butsu, "SetBackdropBorderColor", function() end, true)

end
