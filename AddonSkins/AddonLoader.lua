local _, aObj = ...
if not aObj:isAddonEnabled("AddonLoader") then return end
local _G = _G

aObj.addonsToSkin.AddonLoader = function(self) -- v 2.0

	-- register callback to adjust DropDown skinFrame position
	self.RegisterCallback("Addon Loader", "IOFPanel_After_Skinning", function(_, panel)
		if panel.name ~= "Addon Loader" then return end
		_G.C_Timer.After(0.15, function() -- wait for the objects to be skinned
			_G.AddonLoaderDropDown.sf:ClearAllPoints()
			_G.AddonLoaderDropDown.sf:SetPoint("TOPLEFT", _G.AddonLoaderDropDown, "TOPLEFT", 16, 5)
			_G.AddonLoaderDropDown.sf:SetPoint("BOTTOMRIGHT", _G.AddonLoaderDropDown, "BOTTOMRIGHT", -16, 13)
		end)
		self.UnregisterCallback("Addon Loader", "IOFPanel_After_Skinning")
	end)

end
