local aName, aObj = ...
if not aObj:isAddonEnabled("Panda") then return end

function aObj:Panda(LoD)

--	self:Debug("Panda skin loaded:[%s]", LoD)
	
	local frame = Panda.panel
	
	local function skinPanda()
	
		local btn
		for i = 4, 8 do -- Skill tabs
			btn = aObj:getChild(frame, i)
			aObj:removeRegions(btn, {3}) -- N.B. other regions are icon and highlight
			btn:SetWidth(btn:GetWidth() * 1.25)
			btn:SetHeight(btn:GetHeight() * 1.25)
			if i == 4 then aObj:moveObject{obj=btn, x=-3} end
			aObj:addButtonBorder{obj=btn, sec=true}
		end
		aObj:addSkinFrame{obj=frame, kfs=true, y1=-11, y2=6}
		
		local function skinPanel(frame)
		
			local subPanel = aObj:getChild(frame, 1)
			 -- move the subpanel up
			subPanel:ClearAllPoints()
			subPanel:SetPoint("TOPLEFT", 190, -80)
			subPanel:SetPoint("BOTTOMRIGHT", -12, 39)
			local firstBtn
			for _, child in ipairs{frame:GetChildren()} do
				if child:IsObjectType("Button") and floor(child:GetWidth()) == 158 then
					aObj:removeRegions(child, {1}) -- remove the filter texture from the button
					aObj:addSkinFrame{obj=child}
					if not firstBtn then
						child:SetPoint("TOPLEFT", frame, 23, -76) -- move the buttons up
						firstBtn = child
					end
				end
			end
			
		end
		
		skinPanel(Panda.panel.panels[1]) -- first panel already shown
		for i = 2, #Panda.panel.panels do
			aObj:SecureHookScript(Panda.panel.panels[i], "OnShow", function(this)
				skinPanel(this)
				aObj:Unhook(Panda.panel.panels[i], "OnShow")
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
		local btn = self.hooks[Panda].RefreshButtonFactory(...)
		if not self.sBtn[btn] then self:skinButton{obj=btn} end
	end, true)
	
end
