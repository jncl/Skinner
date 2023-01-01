local _, aObj = ...
local _G = _G
-- This is a Library

aObj.libsToSkin["LibDialog-1.0"] = function(self) -- v 8
	if self.initialized.LibDialog then return end
	self.initialized.LibDialog = true

	local lD = _G.LibStub("LibDialog-1.0", true)
	if lD then
		-- add metatable to skin new frames
		_G.setmetatable(lD.active_dialogs, {__newindex = function(t, k, v)
			_G.rawset(t, k, v)
			v:SetBackdrop(nil)
			self:skinObject("frame", {obj=v, kfs=true, ofs=-6})
			if self.modBtns then
				self:skinCloseButton{obj=v.close_button, noSkin=true}
			end
		end})
		_G.setmetatable(lD.active_editboxes, {__newindex = function(t, k, v)
			_G.rawset(t, k, v)
			self:skinEditBox{obj=v, regs={6}} -- 6 is text
		end})
		if self.modBtns then
			_G.setmetatable(lD.active_buttons, {__newindex = function(t, k, v)
				_G.rawset(t, k, v)
				self:skinStdButton{obj=v}
			end})
		end
		if self.modChkBtns then
			_G.setmetatable(lD.active_checkboxes, {__newindex = function(t, k, v)
				_G.rawset(t, k, v)
				self:skinCheckButton{obj=v}
			end})
		end
		-- skin any existing frames
		for i = 1, #lD.active_dialogs do
			lD.active_dialogs[i]:SetBackdrop(nil)
			self:skinObject("frame", {obj=lD.active_dialogs[i], kfs=true, ofs=-6})
			if self.modBtns then
				self:skinCloseButton{obj=lD.active_dialogs[i].close_button, noSkin=true}
			end
		end
		for i = 1, #lD.active_editboxes do
			self:skinEditBox{obj=lD.active_editboxes[i], regs={6}} -- 6 is text
		end
		if self.modBtns then
			for i = 1, #lD.active_buttons do
				self:skinStdButton{obj=lD.active_buttons[i]}
			end
		end
		if self.modChkBtns then
			for i = 1, #lD.active_checkboxes do
				self:skinCheckButton{obj=lD.active_checkboxes[i]}
			end
		end
	end

end
