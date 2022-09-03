local aName, aObj = ...
if not aObj:isAddonEnabled("Mapster") then return end
local _G = _G

aObj.addonsToSkin.Mapster = function(self) -- v 1.8.4

	local Mapster = _G.LibStub("AceAddon-3.0"):GetAddon("Mapster", true)
	if not Mapster then return end

	if self.isRtl then
		self:keepFontStrings(_G.WorldMapFrame.BorderFrame)
		self:addSkinFrame{obj=_G.WorldMapFrame, ft="a", kfs=true, nb=true, ofs=2}
		self:removeNineSlice(_G.WorldMapFrame.BorderFrame.NineSlice)
	else
		self:keepFontStrings(_G.WorldMapFrame)
		self:addSkinFrame{obj=_G.WorldMapFrame.BorderFrame, ft="a", kfs=true, nb=true, ofs=1}
	end

	if self.modBtns
	and Mapster.optionsButton
	then
		self:skinStdButton{obj=Mapster.optionsButton}
	end

	-- Move TomTom's Cursor coordinates if required
	if self:isAddonEnabled("TomTom")
	and _G.TomTomWorldFrame
	and _G.TomTomWorldFrame.Cursor
	then
		self:moveObject{obj=_G.TomTomWorldFrame.Cursor, x=-100}
		_G.TomTomWorldFrame.Cursor.SetPoint = _G.nop
	end

end
