local aName, aObj = ...
local _G = _G
-- This is a Library

function aObj:LibDialog()
	if self.initialized.LibDropdown then return end
	self.initialized.LibDropdown = true

	local lD = _G.LibStub("LibDialog-1.0", true)
	if lD then
		-- add metatable to skin new frames
		local mt = {__newindex = function(t, k, v)
			_G.rawset(t, k, v)
			aObj:addSkinFrame{obj=v, ofs=-6}
		end}
		_G.setmetatable(lD.active_dialogs, mt)
		-- skin any existing frames
		for i = 1, #lD.active_dialogs do
			self:addSkinFrame{obj=lD.active_dialogs[i], ofs=-6}
		end

	end

end
