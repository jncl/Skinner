
function Skinner:Squeenix()

	-- Find & Skin the Squeenix border
	for i = 1, select("#", Minimap:GetChildren()) do
		local obj = select(i, Minimap:GetChildren())
		if obj:IsObjectType("Button") and obj:GetName() == nil then
			obj:Hide()
			self:addSkinButton(Minimap, Minimap)
			self.minimapskin = Minimap.sBut
			if not self.db.profile.MinimapGloss then LowerFrameLevel(self.minimapskin) end
		end
	end

	-- Move the Direction indicators
	self:moveObject(self:getRegion(Minimap, 1), "+", 2, nil, nil) -- East
	self:moveObject(self:getRegion(Minimap, 2), nil, nil, "-", 2) -- South
--	self:moveObject(self:getRegion(Minimap, 3), nil, nil, nil, nil) -- West
	self:moveObject(self:getRegion(Minimap, 4), nil, nil, "+", 1) -- North

end
