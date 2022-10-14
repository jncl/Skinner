local _, aObj = ...
if not aObj:isAddonEnabled("BigWigs") then return end
local _G = _G

if not aObj.isRtl then return end

aObj.addonsToSkin.BigWigs = function(self) -- v 250.1

	-- skin BigWigs statusbar on the LFGDungeonReadyPopup
	if _G.BigWigsLoader then
		_G.BigWigsLoader.RegisterMessage(self, "BigWigs_FrameCreated", function(event, frame, name)
			if name == "QueueTimer" then
				aObj:skinObject("statusbar", {obj=frame, regions={4}, fi=0, bg=aObj:getRegion(frame, 2)})
				_G.BigWigsLoader.UnregisterMessage(self, "BigWigs_FrameCreated")
			end
		end)
	end

end
