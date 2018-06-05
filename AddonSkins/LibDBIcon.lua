local aName, aObj = ...
local _G = _G
-- This is a Library

aObj.libsToSkin["LibDBIcon-1.0"] = function(self) -- v r36
	if self.initialized.LibDBIcon then return end
	self.initialized.LibDBIcon = true

	local lDBI = _G.LibStub("LibDBIcon-1.0", true)
	if lDBI then
		-- tooltip
		_G.C_Timer.After(0.1, function()
			self:add2Table(self.ttList, lDBI.tooltip)
		end)
	end

end
