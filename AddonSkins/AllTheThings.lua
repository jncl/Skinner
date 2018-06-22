local aName, aObj = ...
if not aObj:isAddonEnabled("AllTheThings") then return end
local _G = _G

aObj.addonsToSkin.AllTheThings = function(self) -- v 1.6.1

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

		panel.Separator:SetTexture(nil)
		panel:DisableDrawLayer("BACKGROUND") -- remove lines around settings panel

		for _, tabPanel in pairs(panel.tabs) do
			self:removeRegions(tabPanel, {1, 2, 3, 4, 5, 6}) -- remove tab button textures
		end

		-- adjust width of ScrollBar
		local UIConfig = _G.AllTheThingsSettingsConfig
		UIConfig.ScrollFrame.ScrollBar:ClearAllPoints();
		UIConfig.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", UIConfig.ScrollFrame, "TOPRIGHT", -16, -18)
		UIConfig.ScrollFrame.ScrollBar:SetPoint("BOTTOMLEFT", UIConfig.ScrollFrame, "BOTTOMRIGHT", -16, 18)
		self:skinSlider{obj=UIConfig.ScrollFrame.ScrollBar}

		-- skin checkboxes, if required
		if self.modChkBtns then
			for k, child in _G.ipairs{UIConfig.ScrollFrame:GetScrollChild():GetChildren()} do
				if child:IsObjectType("CheckButton") then
					self:skinCheckButton{obj=child, hf=true}
				end
			end
		end
		UIConfig = nil

		-- skin sub panels
		local function skinSubPanel(subPanel, topOfs)
			subPanel:DisableDrawLayer("BORDER")
			aObj:addSkinFrame{obj=subPanel, ft="a", kfs=true, nb=true, aso={bd=10, ng=true}, ofs=2, y1=topOfs or nil}
		end
		for _, name in pairs{"mode", "alerts", "spec", "other"} do
			skinSubPanel(_G["AllTheThings-General-" .. name .. "Frame"])
		end
		for _, name in pairs{"basic", "seasonal", "seasonalSub", "unobtainable", "noChance", "possChance", "highChance", "legacy"} do
			skinSubPanel(_G["AllTheThings-Account Filters-" .. name .. "Frame"])
		end
		for _, name in pairs{"profile", "show", "item", "equip", "armor", "weapon"} do
			skinSubPanel(_G["AllTheThings-Mini List-" .. name .. "Frame"])
		end
		for _, name in pairs{"tooltip", "prog", "shared", "database"} do
			skinSubPanel(_G["AllTheThings-Tooltip-" .. name .. "Frame"])
		end
		skinSubPanel(_G["AllTheThings-About-faqFrame"], 5)

		-- Mini List panel
		self:skinDropDown{obj=_G["AllTheThings-dropdown"], x2=34}
		self:skinStdButton{obj=_G["AllTheThings-SaveProfileButton"]}
		self:skinStdButton{obj=_G["AllTheThings-LoadProfileButton"]}
		self:skinStdButton{obj=_G["AllTheThings-DeleteProfileButton"]}
		self:skinSlider{obj=_G["AllTheThings-Window-settings"].ScrollBar}
		self:addSkinFrame{obj=_G["AllTheThings-Window-settings"], ft="a", kfs=true}

		self.UnregisterCallback("AllTheThings", "IOFPanel_After_Skinning")
	end)

end
