local _, aObj = ...
if not aObj:isAddonEnabled("Grid2") then return end
-- local _G = _G

aObj.addonsToSkin.Grid2 = function(self) -- v 3.3.2

	if self.modBtns then
		self.RegisterCallback("Grid2", "SettingsPanel_DisplayCategory", function(_, panel)
			if panel.name ~= "Grid2" then return end
			self.spSkinnedPanels[panel] = true

			self:skinStdButton{obj=self:getChild(panel, 1)}

			self.UnregisterCallback("Grid2", "SettingsPanel_DisplayCategory")
		end)
	end

end
