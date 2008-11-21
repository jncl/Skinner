
function Skinner:Panda(LoD)

--	self:Debug("Panda skin loaded:[%s]", LoD)
	
	self:keepFontStrings(PandaPanel)
	local titleText = self:getRegion(PandaPanel, 2)
	self:moveObject(titleText, nil, nil, "+", 10)
	local cBut = self:getChild(PandaPanel, 1) -- close button
	self:moveObject(cBut, nil, ni, "+", 11)
	self:applySkin(PandaPanel)
	
	local firstBtn
	for i = 1, select("#", PandaPanel:GetChildren()) do
		local child = select(i, PandaPanel:GetChildren())
		if child:IsObjectType("Frame") and child:GetWidth() == 630 and child:GetHeight() == 305 then
			self:Debug("PandaPanel, found subpanel")
			child:ClearAllPoints()
			child:SetPoint("TOPLEFT", 190, -66) -- move the subpanel up
			child:SetPoint("BOTTOMRIGHT", -12, 39)
		end
		if child:IsObjectType("Button") and child:GetWidth() == 158 and child:GetHeight() == 20 then
			self:removeRegions(child, {1}) -- remove the filter texture from the button
			if not firstBtn then
				child:SetPoint("TOPLEFT", this, 23, -68) -- move the buttons up
				firstBtn = child
			end
		end
	end
	
end
