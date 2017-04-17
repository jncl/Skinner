local aName, aObj = ...
if not aObj:isAddonEnabled("AngryKeystones") then return end
local _G = _G

function aObj:AngryKeystones()

	-- Config dropdowns
	self.iofDD["AngryKeystonesConfigDropDown"] = 195

	-- ScenarioBlocksFrame is changed

	-- Schedule module (skin .Frame .Frame.Entries[*].Affixes[*])
	-- part of ChallengesUI

end
