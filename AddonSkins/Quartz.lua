local _, aObj = ...
if not aObj:isAddonEnabled("Quartz") then return end
local _G = _G

aObj.addonsToSkin.Quartz = function(self) -- v 3.8.0

	local Quartz3 = _G.LibStub("AceAddon-3.0"):GetAddon("Quartz3", true)
	if not Quartz3 then return end

	-- set border colours
	local c = self.db.profile.Backdrop
	Quartz3.db.profile.backgroundcolor = {c.r, c.g, c.b}
	Quartz3.db.profile.backgroundalpha = c.a
	c = self.db.profile.BackdropBorder
	Quartz3.db.profile.bordercolor = {c.r, c.g, c.b}
	Quartz3.db.profile.borderalpha = c.a

	local mod
	for _, modName in _G.pairs{"Player", "Target", "Focus", "Pet"} do
		mod = Quartz3:GetModule(modName, true)
		if mod
		and mod:IsEnabled()
		then
			self:skinObject("frame", {obj=mod.Bar, kfs=true, ofs=0})
			self:skinObject("statusbar", {obj=mod.Bar.Bar, fi=0})
			mod.db.profile.texture = self.db.profile.StatusBar.texture
			mod.db.profile.border = self.db.profile.BdBorderTexture
		end
	end

	mod = Quartz3:GetModule("Swing", true)
	if mod
	and mod:IsEnabled()
	then
		self:skinObject("frame", {obj=_G.Quartz3SwingBar, ofs=0})
		_G.Quartz3SwingBar.SetBackdrop = _G.nop
		self:skinObject("statusbar", {obj=self:getChild(_G["Quartz3SwingBar"], 1), fi=0})
	end

	mod = Quartz3:GetModule("Latency", true)
	if mod
	and mod:IsEnabled()
	then
		mod.lagbox:SetTexture(self.sbTexture)
	end

	mod = Quartz3:GetModule("GCD", true)
	if mod
	and mod:IsEnabled()
	then
		mod.db.profile.bartexture = self.db.profile.StatusBar.texture
		mod:ApplySettings()
	end

	mod = Quartz3:GetModule("Mirror", true)
	if mod
	and mod:IsEnabled()
	then
		mod.db.profile.mirrortexture = self.db.profile.StatusBar.texture
		mod:ApplySettings()
	end

	mod = Quartz3:GetModule("Buff", true)
	if mod
	and mod:IsEnabled()
	then
		mod.db.profile.bufftexture = self.db.profile.StatusBar.texture
		mod:ApplySettings()
	end

	mod = Quartz3:GetModule("EnemyCasts", true)
	if mod
	and mod:IsEnabled()
	then
		mod.db.profile.texture = self.db.profile.StatusBar.texture
		mod:ApplySettings()
	end

	self:SecureHook(Quartz3, "ShowUnlockDialog", function(this)
		self:SecureHookScript(_G.Quartz3UnlockDialog, "OnShow", function(fObj)
			self:skinObject("frame", {obj=fObj, kfs=true, ofs=0, y1=4, y2=4})
			if self.modBtns then
				_G.Quartz3UnlockDialogLock:DisableDrawLayer("BACKGROUND")
				self:skinObject("button", {obj=_G.Quartz3UnlockDialogLock, ofs=0}) -- it's a CheckButton
			end

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.Quartz3UnlockDialog)

		self:Unhook(this, "ShowUnlockDialog")
	end)

end
