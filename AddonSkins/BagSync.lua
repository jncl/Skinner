local _, aObj = ...
if not aObj:isAddonEnabled("BagSync") then return end
local _G = _G

aObj.addonsToSkin.BagSync = function(self) -- v 12.7

	-- minimap button
	local mmb = _G.BagSync:GetModule("Minimap", true)
	self.mmButs["BagSync"] = mmb.button
	mmb.buttonTexture:SetDrawLayer("ARTWORK") -- move Texture from "BACKGROUND"
	mmb.buttonTexture:SetTexture([[Interface\AddOns\BagSync\media\icon.tga]])
	mmb.buttonTexture:SetSize(26, 26)
	mmb = nil

end
