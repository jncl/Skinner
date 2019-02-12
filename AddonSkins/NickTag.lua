local aName, aObj = ...
local _G = _G
-- This is a Library

aObj.libsToSkin["NickTag-1.0"] = function(self) -- v 11

	-- AvatarPickFrame
	self:skinSlider{obj=_G.AvatarPickFrameAvatarScroll.ScrollBar, rt="background"}
	self:skinSlider{obj=_G.AvatarPickFrameBackgroundScroll.ScrollBar, rt="background"}
	self:addSkinFrame{obj=_G.AvatarPickFrame, ft="a", kfs=true, nb=true}
	if self.modBtns then
		self:skinStdButton{obj=_G.AvatarPickFrameAccept}
		self:skinStdButton{obj=_G.AvatarPickFrameColor}
	end

end
