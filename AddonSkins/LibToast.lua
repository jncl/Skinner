local aName, aObj = ...
local _G = _G
-- This is a Library

function aObj:LibToast()
	if self.initialized.LibToast then return end
	self.initialized.LibToast = true

	local lT = _G.LibStub("LibToast-1.0", true)
	if lT then
		-- add metatable to skin new frames
		local mt = {__newindex = function(t, k, v)
			_G.rawset(t, k, v)
			aObj:addSkinFrame{obj=v}
		end}
		_G.setmetatable(lT.active_toasts, mt)
		-- skin any existing frames
		for i = 1, #lT.active_toasts do
			self:addSkinFrame{obj=lT.active_toasts[i]}
		end
	end

end
