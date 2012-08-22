local aName, aObj = ...
if not aObj:isAddonEnabled("CoolLine") then return end

function aObj:CoolLine()

	CoolLineDB.statusbar = self.db.profile.StatusBar.texture
	CoolLineDB.bgcolor = self.bColour
	CoolLineDB.border = self.bdbTex
	CoolLineDB.bordercolor = self.bbColour
	if CoolLineDB.perchar then
		CoolLineCharDB.statusbar = self.db.profile.StatusBar.texture
		CoolLineCharDB.bgcolor = self.bColour
		CoolLineCharDB.border = self.bdbTex
		CoolLineCharDB.bordercolor = self.bbColour
	end

	-- apply changes
	CoolLine.updatelook()

end
