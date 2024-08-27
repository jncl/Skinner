local _, aObj = ...
local _G = _G
-- This is a Library

aObj.libsToSkin["MSA-DropDownMenu-1.0"] = function(self) -- v 1.0.18
	if self.initialized["MSA-DropDownMenu"] then return end
	self.initialized["MSA-DropDownMenu"] = true

	local msaDD = _G.LibStub:GetLibrary("MSA-DropDownMenu-1.0", true)

	if msaDD then
		aObj:skinObject("ddlist", {obj=_G.MSA_DropDownList1})
		aObj:skinObject("ddlist", {obj=_G.MSA_DropDownList2})
		self:SecureHook("MSA_DropDownMenu_CreateFrames", function(_, _)
			for i = 1, _G.MSA_DROPDOWNMENU_MAXLEVELS do
				aObj:skinObject("ddlist", {obj=_G["MSA_DropDownList" .. i]})
			end
		end)
	end

end
