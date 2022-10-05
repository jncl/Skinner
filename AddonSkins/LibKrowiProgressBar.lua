local _, aObj = ...
local _G = _G
-- This is a Library

aObj.libsToSkin["Krowi_ProgressBar-1.1"] = function(self) -- v 1.1
	if self.initialized.LibKrowiProgressBar then return end
	self.initialized.LibKrowiProgressBar = true

	local lKPB = _G.LibStub:GetLibrary("Krowi_ProgressBar-1.1", true)
	
	if lKPB then
		self:RawHook(lKPB, "New", function(this, parent)
			local sBar = self.hooks[this].New(this, parent)
			sBar:DisableDrawLayer("BACKGROUND")
			sBar:DisableDrawLayer("OVERLAY")
			sBar.TextRight:SetDrawLayer("ARTWORK")
			sBar.TextLeft:SetDrawLayer("ARTWORK")
			for _, tex in _G.pairs(sBar.Fill) do
				tex:SetTexture(self.sbTexture)
			end
			return sBar
		end, true)
	end

end
