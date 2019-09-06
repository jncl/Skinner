local aName, aObj = ...
if not aObj:isAddonEnabled("Healium") then return end
local _G = _G

if not aObj.isClassic then return end

aObj.addonsToSkin.Healium = function(self) -- v 2.6.2

	-- UnitFrames
	for _, fName in pairs{"Party", "Pet", "Me", "Friends", "Damagers", "Healers", "Tanks", "Target", "Focus"} do
		self:addSkinFrame{obj=_G["Healium" .. fName .. "Frame"].CaptionBar, ft="a", kfs=true}
	end
	for i = 1, 8 do
		self:addSkinFrame{obj=_G["HealiumGroup" .. i .. "Frame"].CaptionBar, ft="a", kfs=true}
	end

	-- minimap button
	_G.HealiumMiniMap:DisableDrawLayer("OVERLAY")
	self:addSkinButton{obj=_G.HealiumMiniMap, parent=_G.HealiumMiniMap, ofs=3}

end
