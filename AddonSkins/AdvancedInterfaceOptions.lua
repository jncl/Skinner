local aName, aObj = ...
if not aObj:isAddonEnabled("AdvancedInterfaceOptions") then return end
local _G = _G

function aObj:AdvancedInterfaceOptions()

	self:skinButton{obj=_G.InterfaceOptionsFrameOkay}

	-- Config dropdowns
	self.iofDD["AIOQuestSorting"] = 110
	self.iofDD["AIOActionCamMode"] = 110
	self.iofDD["AIOfctFloatMode"] = 110

end
