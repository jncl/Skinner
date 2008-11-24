
function Skinner:LibSimpleOptions()

	local function skinLSOPanel(panel)
	
		for i = 1, select("#", panel:GetChildren()) do
			local child = select(i, panel:GetChildren())
			if Skinner:isDropDown(child) then Skinner:skinDropDown(child, nil, nil, true)
			elseif child:IsObjectType("ScrollFrame") then Skinner:skinScrollBar(child)
			elseif not child:IsObjectType("Slider") and child:GetBackdrop() then
				Skinner:applySkin(child)
			end
		end
		
	end
	
	for panel in pairs(LibStub("LibSimpleOptions-1.0").panels) do
		self:RawHookScript(panel, "OnShow", function(this)
			self:Debug("LSO.panel_OS:[%s, %s]", this, this:GetName())
			self.hooks[this].OnShow(this)
			skinLSOPanel(this)
			self:Unhook(panel, "OnShow")
		end)
	end

end
