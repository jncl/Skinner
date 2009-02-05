
function Skinner:Panda(LoD)

--	self:Debug("Panda skin loaded:[%s]", LoD)
	
	local function skinPandaPanel()
	
		Skinner:keepFontStrings(PandaPanel)
		Skinner:moveObject(Skinner:getRegion(PandaPanel, 2), nil, nil, "+", 10) -- titletext
		Skinner:moveObject(Skinner:getChild(PandaPanel, 1), nil, ni, "+", 11) -- close button
		Skinner:applySkin(PandaPanel)
	
		local firstBtn
		for i = 1, PandaPanel:GetNumChildren() do
			local child = select(i, PandaPanel:GetChildren())
			if child:IsObjectType("Frame") and math.floor(child:GetWidth()) == 630 then
--				Skinner:Debug("PandaPanel, found subpanel")
				child:ClearAllPoints()
				child:SetPoint("TOPLEFT", 190, -66) -- move the subpanel up
				child:SetPoint("BOTTOMRIGHT", -12, 39)
			end
			if child:IsObjectType("Button") and math.floor(child:GetWidth()) == 158 then
				Skinner:removeRegions(child, {1}) -- remove the filter texture from the button
				if not firstBtn then
					child:SetPoint("TOPLEFT", PandaPanel, 23, -68) -- move the buttons up
					firstBtn = child
				end
			end
		end
		
	end

	if not LoD then
		self:SecureHook(PandaPanel, "Show", function(this, ...)
			skinPandaPanel()
			self:Unhook(PandaPanel, "Show")
		end)
		self.Panda = nil
	else
		skinPandaPanel()
		self.Panda = nil
	end
	
end
