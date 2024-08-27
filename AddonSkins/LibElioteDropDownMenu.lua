local _, aObj = ...
local _G = _G
-- This is a Library

aObj.libsToSkin["ElioteDropDownMenu-1.0"] = function(self) -- v ElioteDropDownMenu-1.0, 12
	if self.initialized.ElioteDropDownMenu then return end
	self.initialized.ElioteDropDownMenu = true

	local eDDM = _G.LibStub:GetLibrary("ElioteDropDownMenu-1.0", true)

	if eDDM then
		local ddPrefix = "ElioteDDM_DropDownList"
		for i = 1, eDDM.UIDROPDOWNMENU_MAXLEVELS do
			if _G[ddPrefix .. i] then
				aObj:skinObject("ddlist", {obj=_G[ddPrefix .. i]})
			end
		end
		aObj:SecureHook(eDDM, "UIDropDownMenu_CreateFrames", function(_, level, _)
			for i = 1, eDDM.UIDROPDOWNMENU_MAXLEVELS do
				aObj:skinObject("ddlist", {obj=_G[ddPrefix .. i]})
			end
		end)
	end

end
