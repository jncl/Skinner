-- many thanks to DavidTheMachine

local aName, aObj = ...
if not aObj:isAddonEnabled("EnergyWatch") then return end

function aObj:EnergyWatch()

	self:applySkin(EnergyWatchBar)
	self:keepFontStrings(EnergyWatchBar)
	self:glazeStatusBar(EnergyWatchStatusBar)

end
