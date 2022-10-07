local _, aObj = ...
if not aObj:isAddonEnabled("BigWigs") then return end
local _G = _G

aObj.addonsToSkin.BigWigs = function(self) -- v 191.2

	-- skin BigWigs statusbar
	if _G.BigWigsLoader then
		_G.BigWigsLoader.RegisterCallback(self, "BigWigs_FrameCreated", function(event, frame, name)
			if name == "QueueTimer" then
				aObj:removeRegions(frame, {2, 4}) -- background & border textures
				aObj:skinStatusBar{obj=frame, fi=0}
				_G.BigWigsLoader.UnregisterCallback(self, "BigWigs_FrameCreated")
			end
		end)
	end

end
