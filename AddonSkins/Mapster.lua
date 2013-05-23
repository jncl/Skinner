local aName, aObj = ...
if not aObj:isAddonEnabled("Mapster") then return end
local _G = _G

function aObj:Mapster()

	local Mapster = _G.LibStub("AceAddon-3.0"):GetAddon("Mapster", true)
	if not Mapster then return end

	local function sizeDown()

		_G.WorldMapFrame.sf:ClearAllPoints()
		_G.WorldMapFrame.sf:SetPoint("TOPLEFT", _G.WorldMapFrame, "TOPLEFT", 12, -12)
		_G.WorldMapFrame.sf:SetPoint("BOTTOMRIGHT", _G.WorldMapFrame, "BOTTOMRIGHT", -20, -15)

	end
	local function sizeUp()

		_G.WorldMapFrame.sf:ClearAllPoints()
		_G.WorldMapFrame.sf:SetPoint("TOPLEFT", _G.WorldMapFrame, "TOPLEFT", 0, 1)
		_G.WorldMapFrame.sf:SetPoint("BOTTOMRIGHT", _G.WorldMapFrame, "BOTTOMRIGHT", 1, 0)

	end
	-- hook these to handle map size changes
	self:SecureHook(Mapster, "SizeDown", function()
		sizeDown()
	end)
	self:SecureHook(Mapster, "SizeUp", function()
		sizeUp()
	end)
	self:SecureHook(Mapster, "UpdateBorderVisibility", function()
		if Mapster.bordersVisible then
			_G.WorldMapFrame.sf:Show()
		else
			_G.WorldMapFrame.sf:Hide()
		end
	end)
	self:addSkinFrame{obj=_G.WorldMapFrame, ft="u", kfs=true}
	-- handle big/small map sizes
	if _G.WORLDMAP_SETTINGS.size == _G.WORLDMAP_WINDOWED_SIZE then
		sizeDown()
	else
		sizeUp()
	end
	-- on WorldMap frame
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
