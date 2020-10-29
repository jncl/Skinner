local _, aObj = ...
if not aObj:isAddonEnabled("SavedInstances") then return end
local _G = _G

aObj.addonsToSkin.SavedInstances = function(self) -- v 9.0.1

	local SI = _G.LibStub:GetLibrary("AceAddon-3.0"):GetAddon("SavedInstances", true)
	if not SI then return end

	self:SecureHook(SI, "ShowDetached", function(this)
		self:addSkinFrame{obj=this.detachframe, ft="a", kfs=true}

		self:Unhook(this, "ShowDetached")
	end)

end
