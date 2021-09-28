local _, aObj = ...
local _G = _G
-- This is a Library

aObj.libsToSkin["LibUIDropDownMenu-4.0"] = function(self) -- v 90000
	if self.initialized.LibUIDropDownMenu then return end
	self.initialized.LibUIDropDownMenu = true

	local lDD = _G.LibStub:GetLibrary("LibUIDropDownMenu-4.0", true)

	if lDD then
		for i = 1, _G.L_UIDROPDOWNMENU_MAXLEVELS do
			if _G["L_DropDownList" .. i].Border then
				self:removeBackdrop(_G["L_DropDownList" .. i].Border)
			end
			if _G["L_DropDownList" .. i].Backdrop then
				self:removeBackdrop(_G["L_DropDownList" .. i].Backdrop)
			end
			self:removeBackdrop(_G["L_DropDownList" .. i].MenuBackdrop)
			self:skinObject("frame", {obj=_G["L_DropDownList" .. i], ofs=0})
		end
	end

end
