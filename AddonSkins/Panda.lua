if not Skinner:isAddonEnabled("Panda") then return end

function Skinner:Panda(LoD)

--	self:Debug("Panda skin loaded:[%s]", LoD)
	
	local frame = Panda.panel
	
	local function skinPanda()
	
		local btn
		for i = 4, 8 do -- Skill tabs
			btn = Skinner:getChild(frame, i)
			Skinner:removeRegions(btn, {3}) -- N.B. other regions are icon and highlight
			btn:SetWidth(btn:GetWidth() * 1.25)
			btn:SetHeight(btn:GetHeight() * 1.25)
			if i == 4 then Skinner:moveObject(btn, "-", 3, nil, nil) end
			self:addButtonBorder{obj=btn, sec=true}
		end
		self:addSkinFrame{obj=frame, kfs=true, y1=-11, y2=6}
		
		local function skinPanel(frame)
		
			local subPanel = self:getChild(frame, 1)
			 -- move the subpanel up
			subPanel:ClearAllPoints()
			subPanel:SetPoint("TOPLEFT", 190, -80)
			subPanel:SetPoint("BOTTOMRIGHT", -12, 39)
			local firstBtn
			for _, child in ipairs{frame:GetChildren()} do
				if child:IsObjectType("Button") and floor(child:GetWidth()) == 158 then
					Skinner:removeRegions(child, {1}) -- remove the filter texture from the button
					self:addSkinFrame{obj=child}
					if not firstBtn then
						child:SetPoint("TOPLEFT", frame, 23, -76) -- move the buttons up
						firstBtn = child
					end
				end
			end
			
		end
		
		skinPanel(Panda.panel.panels[1]) -- first panel already shown
		for i = 2, #Panda.panel.panels do
			Skinner:SecureHookScript(Panda.panel.panels[i], "OnShow", function(this)
				skinPanel(this)
				Skinner:Unhook(Panda.panel.panels[i], "OnShow")
			end)
		end
		
	end

	if not LoD then
		self:SecureHook(frame, "Show", function(this, ...)
			skinPanda()
			self:Unhook(frame, "Show")
		end)
	else
		skinPanda()
	end
	self:RawHook(Panda, "RefreshButtonFactory", function(...)
		self:Debug("Panda_RBF: [%s, %s, %s]", ...)
		local btn = self.hooks[Panda].RefreshButtonFactory(...)
		if not self.sBut[btn] then self:skinButton{obj=btn} end
	end, true)
	
end
