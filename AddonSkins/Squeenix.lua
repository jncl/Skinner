
function Skinner:Squeenix()

--	self:Debug("Squeenix skin loaded")

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
		if child:IsObjectType("Frame") and child:GetName() == nil and child:GetFrameStrata() == "BACKGROUND" and math.ceil(child:GetWidth()) == 140 and math.ceil(child:GetHeight()) == 140 then
--			self:Debug("Squeenix, found Compass Frame")
			for j = 1, child:GetNumRegions() do
				local grandchild = select(j, child:GetRegions())
				if grandchild:IsObjectType("FontString") then
--					self:Debug("Squeenix found direction text")
					if grandchild:GetText() == "E" then self:moveObject(grandchild, "+", 1, nil, nil)
					elseif grandchild:GetText() == "W" then self:moveObject(grandchild, "-", 1, nil, nil)
					end
				end
			end
		end
	end

	self:moveObject(MinimapNorthTag, nil, nil, "+", 4) -- North

	self.Squeenix = nil
	
end
