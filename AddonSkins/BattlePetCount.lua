local aName, aObj = ...
if not aObj:isAddonEnabled("BattlePetCount") then return end
local _G = _G

aObj.addonsToSkin.BattlePetCount = function(self) -- v 1.8.16

	self:removeInset(self:getChild(_G.PetBattleFrame.ActiveEnemy, 2)) -- inset frame around Battle Hint Box

end