local _, aObj = ...
local _G = _G
-- This is a Library

aObj.libsToSkin["NickTag-1.0"] = function(self) -- v 12
	if self.initialized["NickTag-1.0"] then return end
	self.initialized["NickTag-1.0"] = true

	self:SecureHookScript(_G.AvatarPickFrame, "OnShow", function(this)
		self:skinObject("slider", {obj=_G.AvatarPickFrameAvatarScroll.ScrollBar, rpTex="background"})
		self:skinObject("slider", {obj=_G.AvatarPickFrameBackgroundScroll.ScrollBar, rpTex="background"})
		self:skinObject("frame", {obj=this, kfs=true})
		if self.modBtns then
			self:skinStdButton{obj=_G.AvatarPickFrameAccept}
			self:skinStdButton{obj=_G.AvatarPickFrameColor}
		end

		self:Unhook(this, "OnShow")
	end)

end
