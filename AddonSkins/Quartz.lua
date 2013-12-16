local aName, aObj = ...
if not aObj:isAddonEnabled("Quartz") then return end
local _G = _G

function aObj:Quartz() -- Quartz3

	local Quartz3 = _G.LibStub("AceAddon-3.0"):GetAddon("Quartz3", true)
	if not Quartz3 then return end

	-- hook this to skin Unlock dialog frame
	self:SecureHook(Quartz3, "ShowUnlockDialog", function(this)
		self:skinButton{obj=self:getChild(this.unlock_dialog, 1)} -- it's a checkbutton
		self:addSkinFrame{obj=this.unlock_dialog, kfs=true, nb=true, y1=6}
		self:Unhook(Quartz3, "ShowUnlockDialog")
	end)

	-- set border colours
	local c = self.db.profile.Backdrop
	Quartz3.db.profile.backgroundcolor = {c.r, c.g, c.b}
	Quartz3.db.profile.backgroundalpha = c.a
	local c = self.db.profile.BackdropBorder
	Quartz3.db.profile.bordercolor = {c.r, c.g, c.b}
	Quartz3.db.profile.borderalpha = c.a

	local mod
	for _, modName in _G.pairs{"Player", "Target", "Focus", "Pet"} do
		mod = Quartz3:GetModule(modName, true)
		if mod and mod:IsEnabled() then
			self:applySkin{obj=mod.Bar}
			mod.Bar.Bar.__texture:SetTexture(self.sbTexture)
			mod.Bar.backdrop = _G.CopyTable(self.backdrop) -- make backdrop mirror Skinner's
			mod.db.profile.texture = self.db.profile.StatusBar.texture
			-- handle changes for interrupt toggle code in Quartz
			if not modName == "Player" then
				mod.config.noInterruptChangeColor = false
				mod.config.noInterruptChangeBorder = false
				mod.config.border = self.backdrop.edgeFile
			end
		end
	end
	mod = Quartz3:GetModule("Swing", true)
	if mod and mod:IsEnabled() then
		self:getChild(_G["Quartz3SwingBar"], 1).__texture:SetTexture(self.sbTexture)
	end
	mod = Quartz3:GetModule("Latency", true)
	if mod and mod:IsEnabled() then
		mod.lagbox:SetTexture(self.sbTexture)
	end
-->>-- Mirror Status Bars
	mod = Quartz3:GetModule("Mirror", true)
	if mod and mod:IsEnabled() then
		mod.db.profile.mirrortexture = self.db.profile.StatusBar.texture
		mod:ApplySettings()
	end
-->>-- Buff Status Bars
	mod = Quartz3:GetModule("Buff", true)
	if mod and mod:IsEnabled() then
		mod.db.profile.bufftexture = self.db.profile.StatusBar.texture
		mod:ApplySettings()
	end
-->>-- Enemy Cast Bars
	mod = Quartz3:GetModule("EnemyCasts", true)
	if mod and mod:IsEnabled() then
		mod.db.profile.texture = self.db.profile.StatusBar.texture
		mod:ApplySettings()
	end

end
