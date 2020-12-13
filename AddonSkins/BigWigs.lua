local _, aObj = ...
if not aObj:isAddonEnabled("BigWigs") then return end
local _G = _G

aObj.addonsToSkin.BigWigs = function(self) -- v 191.2

	-- skin BigWigs statusbar
	if _G.BigWigsLoader then
		_G.BigWigsLoader.RegisterMessage(aObj, "BigWigs_FrameCreated", function(event, frame, name)
			aObj:removeRegions(frame, {2, 4}) -- background & border textures
			aObj:skinStatusBar{obj=frame, fi=0}
		end)
	end

end
