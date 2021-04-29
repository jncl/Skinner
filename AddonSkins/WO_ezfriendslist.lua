local _, aObj = ...
if not aObj:isAddonEnabled("WO_ezfriendslist") then return end
local _G = _G

aObj.addonsToSkin.WO_ezfriendslist = function(self) -- v 0.3

	self:SecureHookScript(_G.WFEZframe, "OnShow", function(this)
		self:skinObject("slider", {obj=_G.WFEZscrollb})
		_G.WFEZscrollf:DisableDrawLayer("BACKGROUND")
		self:skinObject("frame", {obj=this, kfs=true, ofs=-1})
		if self.modBtns then
			self:skinCloseButton{obj=_G.WFEZ_clsbtn, noSkin=true}
		end

		self:Unhook(this, "OnShow")
	end)

end
