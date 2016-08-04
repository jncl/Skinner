local aName, aObj = ...
if not aObj:isAddonEnabled("Mapster") then return end
local _G = _G

function aObj:Mapster()

	local Mapster = _G.LibStub("AceAddon-3.0"):GetAddon("Mapster", true)
	if not Mapster then return end

	self:addSkinFrame{obj=_G.WorldMapFrame, ft="u", kfs=true, ofs=2}
	self:skinButton{obj=Mapster.optionsButton}

end

function aObj:MapsterEnhanced()

	local Mapster = _G.LibStub("AceAddon-3.0"):GetAddon("Mapster", true)
	if not Mapster then return end

	-- remove textures
	self:SecureHook(_G.WorldMapFrame, "Show", function(this)
		self:rmRegionsTex(Mapster.nonOverlayHolder, {4, 5, 6, 7, 8, 9, 10, 11, 12, 13 ,14 ,15})
		self:Unhook(_G.WorldMapFrame, "Show")
	end)

end
