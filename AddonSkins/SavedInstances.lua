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

aObj.addonsToSkin.SavedInstances = function(self) -- v 9.0.3

	if SI then
		self:SecureHook(SI, "ShowDetached", function(this)
			self:skinObject("frame", {obj=this.detachframe, kfs=true, cb=true})

			self:Unhook(this, "ShowDetached")
		end)
	end

end
