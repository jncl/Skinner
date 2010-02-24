
function Skinner:AlleyMap()

	local function sizeUp()
	
		self.skinFrame[WorldMapFrame]:SetParent(WorldMapFrame)
		self.skinFrame[WorldMapFrame]:SetFrameStrata("LOW")
		self.skinFrame[WorldMapFrame]:ClearAllPoints()
		self.skinFrame[WorldMapFrame]:SetPoint("TOPLEFT", WorldMapFrame, "TOPLEFT", 255, -95)
		self.skinFrame[WorldMapFrame]:SetPoint("BOTTOMRIGHT", WorldMapFrame, "BOTTOMRIGHT", -255, 95)
		
	end
	local function sizeDown()

		local kids = {WorldMapDetailFrame:GetChildren()}
		for _, child in pairs(kids) do
			child:SetAlpha(0)
		end
		kids = nil
	
		self.skinFrame[WorldMapFrame]:SetParent(WorldMapDetailFrame) -- handle frame movement
		self.skinFrame[WorldMapFrame]:SetFrameStrata("LOW")
		self.skinFrame[WorldMapFrame]:ClearAllPoints()
		self.skinFrame[WorldMapFrame]:SetPoint("TOPLEFT", WorldMapDetailFrame, "TOPLEFT", -5, 4)
		self.skinFrame[WorldMapFrame]:SetPoint("BOTTOMRIGHT", WorldMapDetailFrame, "BOTTOMRIGHT", 4, -4)
		
	end
	self:SecureHook("WorldMap_ToggleSizeUp", function()
		sizeUp()
		self:moveButtonText{obj=WorldMapFrameCloseButton:GetFontString(), y=-1}
	end)
	self:SecureHook("WorldMap_ToggleSizeDown", function()
		sizeDown()
		self:moveButtonText{obj=WorldMapFrameCloseButton:GetFontString(), y=1}
	end)
	
	self:addSkinFrame{obj=WorldMapFrame, ft="u", kfs=true}
	-- handle big/small map sizes
	if WorldMapFrame.sizedDown
	or WORLDMAP_SETTINGS and WORLDMAP_SETTINGS.size == WORLDMAP_WINDOWED_SIZE -- Patch
	then
		sizeDown()
		self:moveButtonText{obj=WorldMapFrameCloseButton:GetFontString(), x=-1}
	else
		sizeUp()
	end

end
