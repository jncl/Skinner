local _, aObj = ...
local _G = _G
-- This is a Library

local LibDialog
local function skinLibDialog(lD)
	-- add metatable to skin new frames
	_G.setmetatable(lD.active_dialogs, {__newindex = function(t, k, v)
		_G.rawset(t, k, v)
		v:SetBackdrop(nil)
		aObj:skinObject("frame", {obj=v, kfs=true, ofs=-6})
		if aObj.modBtns then
			aObj:skinCloseButton{obj=v.close_button, noSkin=true}
		end
	end})
	_G.setmetatable(lD.active_editboxes, {__newindex = function(t, k, v)
		_G.rawset(t, k, v)
		aObj:skinEditBox{obj=v, regs={6}} -- 6 is text
	end})
	if aObj.modBtns then
		_G.setmetatable(lD.active_buttons, {__newindex = function(t, k, v)
			_G.rawset(t, k, v)
			aObj:skinStdButton{obj=v}
		end})
	end
	if aObj.modChkBtns then
		_G.setmetatable(lD.active_checkboxes, {__newindex = function(t, k, v)
			_G.rawset(t, k, v)
			aObj:skinCheckButton{obj=v}
		end})
	end
	-- skin any existing frames
	for i = 1, #lD.active_dialogs do
		lD.active_dialogs[i]:SetBackdrop(nil)
		aObj:skinObject("frame", {obj=lD.active_dialogs[i], kfs=true, ofs=-6})
		if aObj.modBtns then
			aObj:skinCloseButton{obj=lD.active_dialogs[i].close_button, noSkin=true}
		end
	end
	for i = 1, #lD.active_editboxes do
		aObj:skinEditBox{obj=lD.active_editboxes[i], regs={6}} -- 6 is text
	end
	if aObj.modBtns then
		for i = 1, #lD.active_buttons do
			aObj:skinStdButton{obj=lD.active_buttons[i]}
		end
	end
	if aObj.modChkBtns then
		for i = 1, #lD.active_checkboxes do
			aObj:skinCheckButton{obj=lD.active_checkboxes[i]}
		end
	end

end
aObj.libsToSkin["LibDialog-1.0"] = function(self) -- v 8
	if self.initialized.LibDialog then return end
	self.initialized.LibDialog = true

	LibDialog = _G.LibStub:GetLibrary("LibDialog-1.0", true)
	if LibDialog then
		skinLibDialog(LibDialog)
	end

end

-- N.B. handle version used by RCLootCouncil
aObj.libsToSkin["LibDialog-1.1"] = function(self) -- v 9
	if self.initialized.LibDialog then return end
	self.initialized.LibDialog = true

	LibDialog = _G.LibStub:GetLibrary("LibDialog-1.1", true)
	if LibDialog then
		skinLibDialog(LibDialog)
	end

end

aObj.libsToSkin["LibDialog-1.0RS"] = function(self) -- v 8
	if self.initialized.LibDialogRS then return end
	self.initialized.LibDialogRS = true

	LibDialog = _G.LibStub:GetLibrary("LibDialog-1.0RS", true)
	if LibDialog then
		skinLibDialog(LibDialog)
	end

end
