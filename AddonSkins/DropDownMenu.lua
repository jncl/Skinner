local aName, aObj = ...
local _G = _G
-- This is a Framework

aObj.otherAddons.DropDownMenu = function(self)
	if not self.prdb.DropDownPanels or self.initialized.DropDownMenu then return end
	self.initialized.DropDownMenu = true

	if not _G.LIB_UIDROPDOWNMENU_MAXLEVELS then
		self.otherAddons.DropDownMenu = nil
		return
	end

	local function skinDDMenu(frame)
		_G[frame:GetName() .. "Backdrop"]:SetBackdrop(nil)
		_G[frame:GetName() .. "MenuBackdrop"]:SetBackdrop(nil)
		aObj:addSkinFrame{obj=frame, ft="a", kfs=true, nb=true}
	end

	for i = 1, _G.LIB_UIDROPDOWNMENU_MAXLEVELS do
		self:SecureHookScript(_G["Lib_DropDownList" .. i], "OnShow", function(this)
			skinDDMenu(this)
			self:Unhook(this, "OnShow")
		end)
	end

	self:SecureHook("Lib_UIDropDownMenu_CreateFrames", function(level, index)
		if not _G["Lib_DropDownList" .. _G.LIB_UIDROPDOWNMENU_MAXLEVELS].sf then
			skinDDMenu(_G["Lib_DropDownList" .. _G.LIB_UIDROPDOWNMENU_MAXLEVELS])
		end
	end)

end
