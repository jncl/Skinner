
function Skinner:Mapster()

	local Mapster = LibStub("AceAddon-3.0"):GetAddon("Mapster", true)
	if not Mapster then return end

	-- hook these to handle map size changes
	self:SecureHook(Mapster, "SizeDown", function()
		self:moveObject{obj=WorldMapFrameCloseButton:GetFontString(), x=1, y=1}
		self.skinFrame[WorldMapFrame]:ClearAllPoints()
		self.skinFrame[WorldMapFrame]:SetPoint("TOPLEFT", WorldMapFrame, "TOPLEFT", 12, -12)
		self.skinFrame[WorldMapFrame]:SetPoint("BOTTOMRIGHT", WorldMapFrame, "BOTTOMRIGHT", -20, -15)
	end)
	self:SecureHook(Mapster, "SizeUp", function()
		self:moveObject{obj=WorldMapFrameCloseButton:GetFontString(), x=-1, y=-1}
		self.skinFrame[WorldMapFrame]:ClearAllPoints()
		self.skinFrame[WorldMapFrame]:SetPoint("TOPLEFT", WorldMapFrame, "TOPLEFT", 0, 1)
		self.skinFrame[WorldMapFrame]:SetPoint("BOTTOMRIGHT", WorldMapFrame, "BOTTOMRIGHT", 1, 0)
	end)
	self:SecureHook(Mapster, "UpdateBorderVisibility", function()
		if Mapster.bordersVisible then self.skinFrame[WorldMapFrame]:Show()
		else self.skinFrame[WorldMapFrame]:Hide() end
	end)
	-- handle big/small map sizes
	if WorldMapFrame.sizedDown then
		self:addSkinFrame{obj=WorldMapFrame, ft="u", kfs=true, x1=12, y1=-12, x2=-20, y2=-15}
	else
		self:addSkinFrame{obj=WorldMapFrame, ft="u", kfs=true, y1=1, x2=1}
	end
	self:skinButton{obj=MapsterOptionsButton}

end
