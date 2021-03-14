local _, aObj = ...
if not aObj:isAddonEnabled("KongConfig") then return end
local _G = _G

aObj.addonsToSkin.KongConfig = function(self) -- v 0.18

	self:RawHook("KongConfig_CreateComponents", function()
		self.isKC = true
		self.hooks.KongConfig_CreateComponents()
		self.isKC = nil
		self:removeBackdrop(_G.KongConfig.frame)

		self:Unhook(this, "KongConfig_CreateComponents")
	end, true)

end
