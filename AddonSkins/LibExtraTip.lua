local _, aObj = ...
-- This is a Library
local _G = _G

aObj.libsToSkin["LibExtraTip-1"] = function(self) -- v 7.5.5724
	if not self.db.profile.Tooltips.skin or self.initialized.LibExtraTip then return end
	self.initialized.LibExtraTip = true

	-- hook this to skin extra tooltips
	self:RawHook(_G.LibStub("LibExtraTip-1"), "GetFreeExtraTipObject", function(this)
		local ttip = self.hooks[this].GetFreeExtraTipObject(this)
		if not _G.rawget(self.ttList, ttip) then
			self:add2Table(self.ttList, ttip)
		end
		return ttip
	end, true)

end
