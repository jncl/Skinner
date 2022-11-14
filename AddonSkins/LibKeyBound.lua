local aName, aObj = ...
local _G = _G
-- This is a Library

aObj.libsToSkin["LibKeyBound-1.0"] = function(self) -- v 110
	if self.initialized.LibKeyBound then return end
	self.initialized.LibKeyBound = true

	local lKB = _G.LibStub("LibKeyBound-1.0", true)

	if lKB then
		-- skin KeyboundDialog frame
		if self.db.profile.MenuFrames then
			self:skinObject("frame", {obj=_G.KeyboundDialog, kfs=true, ofs=4})
			if self.modBtns then
				self:skinStdButton{obj=_G.KeyboundDialogOkay}
				self:skinStdButton{obj=_G.KeyboundDialogCancel}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=_G.KeyboundDialogCheck}
			end
		end
	end

end
