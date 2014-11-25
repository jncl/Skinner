local aName, aObj = ...
if not aObj:isAddonEnabled("GarrisonMissionManager") then return end
local _G = _G

function aObj:GarrisonMissionManager()

	 -- move buttons
	 local mp = _G.GarrisonMissionFrame.MissionTab.MissionPage
	 local btn = self:getChild(mp, 16)
	 btn:ClearAllPoints()
	 btn:SetPoint("TOPLEFT", mp, "TOPRIGHT", -5, -10)

end
