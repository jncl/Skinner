
function Skinner:LibExtraTip()
	if not self.db.profile.Tooltips.skin then return end
	
	local lib = LibStub("LibExtraTip-1")
	
	-- hook this to skin extra tooltips
	self:RawHook(lib, "GetFreeExtraTipObject", function(this)
		local ttip = self.hooks[lib].GetFreeExtraTipObject(this)
		self:skinTooltip(ttip)
		if not self.skinned[ttip] then
			if self.db.profile.Tooltips.style == 3 then ttip:SetBackdrop(self.backdrop) end
		end
		return ttip
	end, true)
	
end
