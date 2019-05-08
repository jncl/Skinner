local aName, aObj = ...
if not aObj:isAddonEnabled("AllTheThings") then return end
local _G = _G

aObj.addonsToSkin.AllTheThings = function(self) -- v 1.8.9a

	-- Tooltip Model frame
	self:addSkinFrame{obj=_G.ATTGameTooltipModel, ft="a", kfs=true, nb=true}

	-- hook this to skin frames
	self:RawHook(_G.AllTheThings, "GetWindow", function(this, suffix, parent, todo)
		local frame = self.hooks[this].GetWindow(this, suffix, parent, todo)
		if not frame.sf then
			self:skinSlider{obj=frame.ScrollBar, size=3}
			self:addSkinFrame{obj=frame, ft="a", kfs=true}
		end
		return frame
	end, true)

	-- minimap button
	if _G["AllTheThings-Minimap"] then
		self.mmButs["AllTheThings"] = _G["AllTheThings-Minimap"]
		self:getRegion(_G["AllTheThings-Minimap"], 2):SetDrawLayer("OVERLAY") -- make logo appear
	end

	-- Settings Panels
	self.RegisterCallback("AllTheThings", "IOFPanel_After_Skinning", function(this, panel)
		if panel.name ~= "AllTheThings" then return end

		panel:SetBackdrop(nil)
		self:getRegion(panel, 4):SetTexture(nil) -- Separator line

		for i, tabPanel in _G.pairs(panel.Tabs) do
			self:removeRegions(tabPanel, {1, 2, 3, 4, 5, 6}) -- remove tab button textures
			if i == 3 then -- Unobtainables Tab
				for _, obj in _G.ipairs(tabPanel.objects) do
					if obj:IsObjectType("Frame")
					and obj:GetWidth() == 600
					and _G.Round(obj:GetHeight()) == 2500
					then -- child frame
						for _, child in _G.ipairs{obj:GetChildren()} do
							if child:GetObjectType() == "Frame" then
								self:addSkinFrame{obj=child, ft="a", kfs=true, nb=true, aso={bd=10, ng=true}}
							end
						end
					elseif obj:IsObjectType("CheckButton")
					and self.modChkBtns
					then
						self:skinCheckButton{obj=obj, hf=true}
					end
				end
			end
		end

		self.UnregisterCallback("AllTheThings", "IOFPanel_After_Skinning")
	end)

end
