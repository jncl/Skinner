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

aObj.addonsToSkin.SavedInstances = function(self) -- v 10.1.2-10-gb6df957

	if SI then
		self:add2Table(self.ttList, SI.ScanTooltip)
		if SI.ShowDetached then
			self:SecureHook(SI, "ShowDetached", function(this)
				self:skinObject("frame", {obj=this.detachframe, kfs=true, cb=true})

				self:Unhook(this, "ShowDetached")
			end)
		else
			local tt = SI:GetModule("Tooltip", true)
			if tt then
				self:SecureHook(tt, "ShowDetached", function(this)
					self:skinObject("frame", {obj=_G.SavedInstancesDetachHeader, kfs=true, cb=true})

					self:Unhook(this, "ShowDetached")
				end)
			end
		end
		local mpm = SI:GetModule("MythicPlus", true)
		if mpm then
			self:SecureHook(mpm, "ExportKeys", function(this, _)
				self:skinObject("slider", {obj=self:getChild(this.KeyExportWindow, 2).ScrollBar})
				self:skinObject("frame", {obj=this.KeyExportWindow, kfs=true, rb=true, ofs=0})
				if self.modBtns then
					self:skinStdButton{obj=self:getChild(this.KeyExportWindow, 1)}
				end

				self:Unhook(this, "ExportKeys")
			end)
		end
	end

end
