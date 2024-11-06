local _, aObj = ...
if not aObj:isAddonEnabled("SavedInstances") then return end
local _G = _G

local SI = _G.LibStub:GetLibrary("AceAddon-3.0"):GetAddon("SavedInstances", true)

-- hook this here to stop frames being 'Skinned' if running ElvUI or TukUI
if SI
and _G.C_AddOns.IsAddOnLoaded("ElvUI")
or _G.C_AddOns.IsAddOnLoaded("Tukui")
then
	SI.SkinFrame = _G.nop
-- 	aObj:RawHook(SI, "SkinFrame", function(this, ...)
-- 		return
-- 	end, true)
end

aObj.addonsToSkin.SavedInstances = function(self) -- v 11.0.6

	if not SI then
		return
	end

	self:add2Table(self.ttList, SI.ScanTooltip)

	local ttm = SI:GetModule("Tooltip", true)
	if ttm then
		self:SecureHook(ttm, "ShowDetached", function(this)
			self:skinObject("frame", {obj=_G.SavedInstancesDetachHeader, kfs=true, cb=true})

			self:Unhook(this, "ShowDetached")
		end)
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
