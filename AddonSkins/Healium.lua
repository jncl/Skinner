local _, aObj = ...
if not aObj:isAddonEnabled("Healium") then return end
local _G = _G

if aObj.isRtl then return end

aObj.addonsToSkin.Healium = function(self) -- v 2.8.14Classic/2.8.15BC

	-- UnitFrames
	for _, fName in _G.pairs{"Party", "Pet", "Me", "Friends", "Damagers", "Healers", "Tanks", "Target"} do
		self:skinObject("frame", {obj=_G["Healium" .. fName .. "Frame"].CaptionBar, kfs=true, cbns=true, ofs=0})
	end
	for i = 1, 8 do
		self:skinObject("frame", {obj=_G["HealiumGroup" .. i .. "Frame"].CaptionBar, kfs=true, cbns=true, ofs=0})
	end

	self.mmButs["Healium"] = _G.HealiumMiniMap

end
