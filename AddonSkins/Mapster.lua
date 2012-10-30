local aName, aObj = ...
if not aObj:isAddonEnabled("Mapster") then return end

function aObj:Mapster()

	local Mapster = LibStub("AceAddon-3.0"):GetAddon("Mapster", true)
	if not Mapster then return end

	local function sizeDown()

		aObj.skinFrame[WorldMapFrame]:ClearAllPoints()
		aObj.skinFrame[WorldMapFrame]:SetPoint("TOPLEFT", WorldMapFrame, "TOPLEFT", 12, -12)
		aObj.skinFrame[WorldMapFrame]:SetPoint("BOTTOMRIGHT", WorldMapFrame, "BOTTOMRIGHT", -20, -15)

	end
	local function sizeUp()

		aObj.skinFrame[WorldMapFrame]:ClearAllPoints()
		aObj.skinFrame[WorldMapFrame]:SetPoint("TOPLEFT", WorldMapFrame, "TOPLEFT", 0, 1)
		aObj.skinFrame[WorldMapFrame]:SetPoint("BOTTOMRIGHT", WorldMapFrame, "BOTTOMRIGHT", 1, 0)

	end
	-- hook these to handle map size changes
	self:SecureHook(Mapster, "SizeDown", function()
		sizeDown()
	end)
	self:SecureHook(Mapster, "SizeUp", function()
		sizeUp()
	end)
	self:SecureHook(Mapster, "UpdateBorderVisibility", function()
		if Mapster.bordersVisible then WorldMapFrame.sf:Show()
		else WorldMapFrame.sf:Hide() end
	end)
	self:addSkinFrame{obj=WorldMapFrame, ft="u", kfs=true}
	-- handle big/small map sizes
	if WorldMapFrame.sizedDown
	or WORLDMAP_SETTINGS and WORLDMAP_SETTINGS.size == WORLDMAP_WINDOWED_SIZE -- Patch
	then
		sizeDown()
	else
		sizeUp()
	end
	-- on WorldMap frame
	self:skinButton{obj=MapsterOptionsButton}
	self:skinDropDown{obj=MapsterQuestObjectivesDropDown}

end

function aObj:MapsterEnhanced()

	local MapsterEnhanced = LibStub("AceAddon-3.0"):GetAddon("MapsterEnhanced", true)
	if not MapsterEnhanced then return end

	-- remove textures
	self:SecureHook(WorldMapFrame, "Show", function(this)
		self:rmRegionsTex(MapsterNonOverlayHolder, {4, 5, 6, 7, 8, 9, 10, 11, 12, 13 ,14 ,15})
		self:Unhook(WorldMapFrame, "Show")
	end)
	
end
