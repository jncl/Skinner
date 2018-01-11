local aName, aObj = ...
if not aObj:isAddonEnabled("Postal") then return end
local _G = _G

aObj.addonsToSkin.Postal = function(self) -- v 3.5.8

	-- Hide MailFrame OpenAllMail button
	_G.OpenAllMail:Hide()

	if self.modBtnBs then
		self:moveObject{obj=_G.Postal_ModuleMenuButton, y=-1}
		self:addButtonBorder{obj=_G.Postal_ModuleMenuButton, ofs=-2, x1=1}
		self:skinStdButton{obj=_G.PostalSelectOpenButton}
		self:skinStdButton{obj=_G.PostalSelectReturnButton}
		self:skinStdButton{obj=_G.PostalOpenAllButton}
		self:addButtonBorder{obj=_G.Postal_OpenAllMenuButton, ofs=-3, x1=2}
		-- Send Mail Frame
		self:addButtonBorder{obj=_G.Postal_BlackBookButton, ofs=-2, x1=1}
	end

	-- About frame
	self:SecureHook(_G.Postal, "CreateAboutFrame", function(this)
		self:skinSlider{obj=_G.PostalAboutScroll.ScrollBar}
		self:skinCloseButton{obj=self:getChild(_G.Postal.aboutFrame, 2)}
		self:addSkinFrame{obj=_G.Postal.aboutFrame, ft="a", nb=true, y1=-2, x2=-2}
		self:Unhook(_G.Postal, "CreateAboutFrame")
	end)

end
