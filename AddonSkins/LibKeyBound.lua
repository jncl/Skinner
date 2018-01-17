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
			self:skinCheckButton{obj=_G.KeyboundDialogCheck}
			self:skinStdButton{obj=_G.KeyboundDialogOkay}
			self:skinStdButton{obj=_G.KeyboundDialogCancel}
			self:addSkinFrame{obj=_G.KeyboundDialog, ft="a", kfs=true, nb=true, y1=4, y2=6}
		end
	end

end
