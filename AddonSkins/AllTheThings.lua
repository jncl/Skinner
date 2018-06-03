local aName, aObj = ...
if not aObj:isAddonEnabled("AllTheThings") then return end
local _G = _G

aObj.addonsToSkin.AllTheThings = function(self) -- v 1.6.0

	-- Tooltip icon frame, leave as is for now

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
	self.mmButs["AllTheThings"] = _G["AllTheThings-Minimap"]
	self:getRegion(_G["AllTheThings-Minimap"], 2):SetDrawLayer("OVERLAY") -- make logo appear

	self.RegisterCallback("AllTheThings", "IOFPanel_After_Skinning", function(this, panel)
		if panel.name ~= "AllTheThings" then return end

		panel:DisableDrawLayer("BACKGROUND") -- remove lines around settings panel

		for _, tabPanel in pairs(panel.tabs) do
			self:removeRegions(tabPanel, {1, 2, 3, 4, 5, 6}) -- remove tab button textures
		end

		-- TODO: ScrollBar width needs widening

		-- TODO: only Checkbuttons on panel 1 appear with skinned frame
		-- for k, child in _G.ipairs{_G.AllTheThingsSettingsConfig.ScrollFrame:GetScrollChild():GetChildren()} do
		-- 	if child:IsObjectType("CheckButton") then
		-- 		_G.print("CB", k, child)
		-- 		if self.modChkBtns then
		-- 			self:skinCheckButton{obj=child}
		-- 		end
		-- 	end
		-- end

		-- Mini List panel
		self:skinDropDown{obj=_G["AllTheThings-dropdown"], x2=34}
		self:skinStdButton{obj=_G["AllTheThings-SaveProfileButton"]}
		self:skinStdButton{obj=_G["AllTheThings-LoadProfileButton"]}
		self:skinStdButton{obj=_G["AllTheThings-DeleteProfileButton"]}
		self:addSkinFrame{obj=_G["AllTheThings-Window-settings"], ft="a", kfs=true}

		self.UnregisterCallback("AllTheThings", "IOFPanel_After_Skinning")
	end)

end
