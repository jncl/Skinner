local _, aObj = ...
local _G = _G
-- This is a Library

aObj.libsToSkin["LibCandyBar-3.0"] = function(self) -- v LibCandyBar-3.0, 100
	if self.initialized.LibCandyBar then return end
	self.initialized.LibCandyBar = true

	local lCB = _G.LibStub:GetLibrary("LibCandyBar-3.0", true)

	if lCB then
		self:RawHook(lCB, "New", function(this, _, ...)
			local bar = self.hooks[this].New(this, self.sbTexture, ...)
			return bar
		end, true)
		self:RawHook(lCB.barPrototype, "SetTexture", function(_, _)
			_G.nop()
		end, true)
	end

end
