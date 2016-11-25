local aName, aObj = ...
if not aObj:isAddonEnabled("Postal") then return end
local _G = _G

function aObj:Postal()

	if self.modBtnBs then
		self:addButtonBorder{obj=_G.Postal_ModuleMenuButton, ofs=-2, x1=1}
		self:addButtonBorder{obj=_G.Postal_OpenAllMenuButton, ofs=-3, x1=2}
		self:addButtonBorder{obj=_G.Postal_BlackBookButton, ofs=-2, x1=1}
	end

	-- About frame
	self:SecureHook(_G.Postal, "CreateAboutFrame", function(this)
		self:skinSlider{obj=_G.PostalAboutScroll.ScrollBar}
		self:addSkinFrame{obj=_G.Postal.aboutFrame}
		self:Unhook(_G.Postal, "CreateAboutFrame")
	end)

end
