local aName, aObj = ...
local _G = _G
-- This is a Library

aObj.libsToSkin["LibToast-1.0"] = function(self) -- v LibToast 15
	if self.initialized.LibToast then return end
	self.initialized.LibToast = true

	local lT = _G.LibStub:GetLibrary("LibToast-1.0", true)
	if lT then
		local function skinToast(frame)
			aObj:skinObject("frame", {obj=frame})
			if aObj.modBtns then
				aObj:skinCloseButton{obj=frame.dismiss_button, font=aObj.fontSBX, noSkin=true}
			end
			frame.SetBackdrop = _G.nop
		end
		-- add metatable to skin new frames
		_G.setmetatable(lT.active_toasts, {__newindex = function(t, k, v)
			_G.rawset(t, k, v)
			skinToast(v)
		end})
		for _, frame in _G.pairs(lT.active_toasts) do
			skinToast(frame)
		end
	end

end
