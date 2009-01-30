
function Skinner:Panda(LoD)

--	self:Debug("Panda skin loaded:[%s]", LoD)
	
	self:keepFontStrings(PandaPanel)
	local titleText = self:getRegion(PandaPanel, 2)
	self:moveObject(titleText, nil, nil, "+", 10)
	local cBut = self:getChild(PandaPanel, 1) -- close button
	self:moveObject(cBut, nil, ni, "+", 11)
	self:applySkin(PandaPanel)
	
	self:SecureHook(PandaPanel, "Show", function(this, ...)
		local firstBtn
		for i = 1, PandaPanel:GetNumChildren() do
			local child = select(i, PandaPanel:GetChildren())
			if child:IsObjectType("Frame") and math.floor(child:GetWidth()) == 630 then
				self:Debug("PandaPanel, found subpanel")
				child:ClearAllPoints()
				child:SetPoint("TOPLEFT", 190, -66) -- move the subpanel up
				child:SetPoint("BOTTOMRIGHT", -12, 39)
			end
			if child:IsObjectType("Button") and math.floor(child:GetWidth()) == 158 then
				self:removeRegions(child, {1}) -- remove the filter texture from the button
				if not firstBtn then
					child:SetPoint("TOPLEFT", this, 23, -68) -- move the buttons up
					firstBtn = child
				end
			end
		end
		self:Unhook(PandaPanel, "Show")
	end)
	
end
