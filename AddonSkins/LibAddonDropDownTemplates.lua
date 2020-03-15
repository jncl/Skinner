local _, aObj = ...
local _G = _G
-- This is a Library

aObj.libsToSkin["AddonDropDownTemplates-1.0"] = function(self) -- v AddonDropDownTemplates-1.0, 8
	if self.initialized.AddonDropDownTemplates then return end
	self.initialized.AddonDropDownTemplates = true

	local ADDT = _G.LibStub:GetLibrary("AddonDropDownTemplates-1.0", true)

	if ADDT then
		self:RawHook(ADDT, "CreateListTemplate", function(this, lib, name, id)
			local button = self.hooks[this].CreateListTemplate(this, lib, name, id)
			self:addSkinFrame{obj=_G[name .. "Backdrop"], ft="a", kfs=true, nb=true}
			self:addSkinFrame{obj=_G[name .. "MenuBackdrop"], ft="a", kfs=true, nb=true}
			return button
		end, true)
		self:RawHook(ADDT, "CreateMenuTemplate", function(this, ...)
			local button = self.hooks[this].CreateMenuTemplate(this, ...)
			self:skinDropDown{obj=button, x1=0, x2=-1}
			return button
		end, true)
	end

end
