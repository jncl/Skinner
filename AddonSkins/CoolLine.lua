local aName, aObj = ...
if not aObj:isAddonEnabled("CoolLine") then return end
local _G = _G

aObj.addonsToSkin.CoolLine = function(self) -- v 8.0.002

	_G.CoolLineDB.statusbar = self.db.profile.StatusBar.texture
	local r, g, b, a = self.bClr:GetRGBA()
	_G.CoolLineDB.bgcolor = {r = r, g = g, b = b, a = a}
	_G.CoolLineDB.border = self.bdbTexName
	r, g, b, a = self.bbClr:GetRGBA()
	_G.CoolLineDB.bordercolor = {r = r, g = g, b = b, a = a}
	if _G.CoolLineDB.perchar then
		_G.CoolLineCharDB.statusbar = self.db.profile.StatusBar.texture
		r, g, b, a = self.bClr:GetRGBA()
		_G.CoolLineCharDB.bgcolor = {r = r, g = g, b = b, a = a}
		_G.CoolLineCharDB.border = self.bdbTexName
		r, g, b, a = self.bbClr:GetRGBA()
		_G.CoolLineCharDB.bordercolor = {r = r, g = g, b = b, a = a}
	end
	r, g, b, a = nil, nil, nil, nil

	-- apply changes
	_G.CoolLine.updatelook()

end
