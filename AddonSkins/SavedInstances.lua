local _, aObj = ...
if not aObj:isAddonEnabled("SavedInstances") then return end
local _G = _G

-- hook this here to stop frames being 'Skinned' if running ElvUI or TukUI
local SI = _G.LibStub:GetLibrary("AceAddon-3.0"):GetAddon("SavedInstances", true)
if SI then
	aObj:RawHook(SI, "SkinFrame", function(this, ...)
		return
	end, true)
end

aObj.addonsToSkin.SavedInstances = function(self) -- v 9.0.1

	self:SecureHook(SI, "ShowDetached", function(this)
		self:addSkinFrame{obj=this.detachframe, ft="a", kfs=true}

		self:Unhook(this, "ShowDetached")
	end)

end
