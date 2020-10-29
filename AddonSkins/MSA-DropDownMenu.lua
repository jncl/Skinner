local aName, aObj = ...
local _G = _G
-- This is a Library

aObj.libsToSkin["MSA-DropDownMenu-1.0"] = function(self) -- v 7
	if self.initialized["MSA-DropDownMenu"] then return end
	self.initialized["MSA-DropDownMenu"] = true

	local function skinDDL(ddlName)
		aObj:removeBackdrop(_G[ddlName .. "Backdrop"])
		aObj:removeBackdrop(_G[ddlName .. "MenuBackdrop"])
		aObj:addSkinFrame{obj=_G[ddlName], ft="a", kfs=true, nb=true}
	end
	skinDDL("MSA_DropDownList1")
	skinDDL("MSA_DropDownList2")
	self:SecureHook("MSA_DropDownMenu_CreateFrames", function(level, index)
		for i = 1, _G.MSA_DROPDOWNMENU_MAXLEVELS do
			skinDDL("MSA_DropDownList" .. i)
		end
	end)

end
