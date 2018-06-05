local aName, aObj = ...
local _G = _G
-- This is a Library

aObj.libsToSkin["LibUIDropDownMenu"] = function(self) -- v 90000
	if self.initialized.LibUIDropDownMenu then return end
	self.initialized.LibUIDropDownMenu = true

	local lDD = _G.LibStub("LibUIDropDownMenu", true)

	if lDD then
		for i = 1, _G.L_UIDROPDOWNMENU_MAXLEVELS do
			_G["L_DropDownList" .. i .. "Backdrop"]:SetBackdrop(nil)
			_G["L_DropDownList" .. i .. "MenuBackdrop"]:SetBackdrop(nil)
			self:applySkin{obj=_G["L_DropDownList" .. i]}
		end
	end

end
