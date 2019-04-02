local aName, aObj = ...
local _G = _G
-- This is a Library

function aObj:Lib_UIDropdown()
	if self.initialized.Lib_UIDropdown then return end
	self.initialized.Lib_UIDropdown = true

	local lDD = _G.LibStub("NoTaint_UIDropDownMenu-7.2.0", true)

	if lDD then
		for i = 1, _G.LIB_UIDROPDOWNMENU_MAXLEVELS do
			_G["Lib_DropDownList" .. i .. "Backdrop"]:SetBackdrop(nil)
			_G["Lib_DropDownList" .. i .. "MenuBackdrop"]:SetBackdrop(nil)
			self:applySkin{obj=_G["Lib_DropDownList" .. i]}
		end
	end

end
