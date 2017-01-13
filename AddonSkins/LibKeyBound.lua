local aName, aObj = ...
local _G = _G
-- This is a Library

function aObj:LibKeyBound()
	if self.initialized.LibKeyBound then return end
	self.initialized.LibKeyBound = true

	local lKB = _G.LibStub("LibKeyBound-1.0", true)
	if lKB then
		-- skin KeyboundDialog frame
		if self.db.profile.MenuFrames then
			self:skinButton{obj=_G.KeyboundDialogOkay} -- this is a CheckButton object
			self:skinButton{obj=_G.KeyboundDialogCancel} -- this is a CheckButton object
			self:addSkinFrame{obj=_G.KeyboundDialog, kfs=true, y1=4, y2=6}
		end
	end

end
