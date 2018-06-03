local aName, aObj = ...
local _G = _G
-- This is a Library

aObj.libsToSkin["LibDialog-1.0"] = function(self) -- v r89
	if self.initialized.LibDialog then return end
	self.initialized.LibDialog = true

	local lD = _G.LibStub("LibDialog-1.0", true)
	if lD then
		-- add metatable to skin new frames
		_G.setmetatable(lD.active_dialogs, {__newindex = function(t, k, v)
			_G.rawset(t, k, v)
			for i = 1, #v.buttons do
				self:skinStdButton{obj=v.buttons[i]}
			end
			self:skinCloseButton{obj=v.close_button}
			self:addSkinFrame{obj=v, ft="a", nb=true, ofs=-6}
			v:SetBackdrop(nil)
		end})
		-- skin any existing frames
		for i = 1, #lD.active_dialogs do
			for j = 1, #lD.active_dialogs[i].buttons do
				self:skinStdButton{obj=lD.active_dialogs[i].buttons[j]}
			end
			self:skinCloseButton{obj=lD.active_dialogs[i].close_button}
			self:addSkinFrame{obj=lD.active_dialogs[i], ft="a", nb=true, ofs=-6}
			lD.active_dialogs[i]:SetBackdrop(nil)
		end
	end

end
