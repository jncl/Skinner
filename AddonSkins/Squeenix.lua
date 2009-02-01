
function Skinner:Squeenix()

	-- Find & Skin the Squeenix border & direction indicators
	for i = 1, Minimap:GetNumChildren() do
		local child = select(i, Minimap:GetChildren())
		if child:IsObjectType("Button") and child:GetName() == nil then
			child:Hide()
			self:addSkinButton(Minimap, Minimap)
			self.minimapskin = Minimap.sBut
			if not self.db.profile.MinimapGloss then LowerFrameLevel(self.minimapskin) end
		end
		-- Move the compass points text
		if child:IsObjectType("Frame") and child:GetName() == nil and child:GetFrameStrata() == "BACKGROUND" then
			for i = 1, child:GetNumChildren() do
				local grandchild = select(i, child:GetChildren())
				if grandchild:IsObjectType("FontString") then
					if grandchild:GetText() == "E" then self:moveObject(grandchild, "+", 4, nil, nil)
					elseif grandchild:GetText() == "W" then self:moveObject(grandchild, "-", 4, nil, nil)
					end
				end
			end
		end
	end

	self:moveObject(MinimapNorthTag, nil, nil, "+", 4) -- North

end
