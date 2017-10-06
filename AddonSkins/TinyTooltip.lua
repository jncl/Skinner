local aName, aObj = ...
if not aObj:isAddonEnabled("TinyTooltip") then return end
local _G = _G
local LibStub, unpack = _G.LibStub, unpack

aObj.addonsToSkin.TinyTooltip = function(self) -- v 2.1.8.3

	local LibEvent = LibStub:GetLibrary("LibEvent.7000")

	-- setup textures and colours
	_G.BigTipDB.general.bgfile = self.bdTexName
	_G.BigTipDB.general.background = {self.bColour[1], self.bColour[2], self.bColour[3], self.bColour[4]}
	_G.BigTipDB.general.borderCorner = self.bdbTexName
	_G.BigTipDB.general.borderColor = {self.tbColour[1], self.tbColour[2], self.tbColour[3], self.tbColour[4]}
	_G.BigTipDB.general.statusbarTexture = self.db.profile.StatusBar.texture

	-- update existing tooltips
	for _, tip in pairs(_G.TinyTooltip.tooltips) do

		LibEvent:trigger("tooltip.style.bgfile", tip, _G.BigTipDB.general.bgfile)
		LibEvent:trigger("tooltip.style.background", tip, unpack(_G.BigTipDB.general.background))
		LibEvent:trigger("tooltip.style.border.corner", tip, _G.BigTipDB.general.borderCorner)
		LibEvent:trigger("tooltip.style.border.color", tip, unpack(_G.BigTipDB.general.borderColor))
		LibEvent:trigger("tooltip.statusbar.texture", _G.BigTipDB.general.statusbarTexture)

	end

	LibEvent = nil

end
