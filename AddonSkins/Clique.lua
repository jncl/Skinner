local _, aObj = ...
if not aObj:isAddonEnabled("Clique") then return end
local _G = _G

aObj.addonsToSkin.Clique = function(self) -- v 90002-1.0.0
	if not self.db.profile.SpellBookFrame then return end

	-- Tab on SpellBook (side)
	self:removeRegions(_G.CliqueSpellTab, {1})
	if self.modBtnBs then
		self:addButtonBorder{obj=_G.CliqueSpellTab}
	end

	self:skinObject("frame", {obj=_G.CliqueDialog, kfs=true, cb=true, ofs=2, x2=1	})
	if self.modBtns then
		self:skinStdButton{obj=_G.CliqueDialog.button_binding}
		self:skinStdButton{obj=_G.CliqueDialog.button_accept}
	end

	self:skinObject("dropdown", {obj=_G.CliqueConfig.dropdown})
	self:skinColHeads("CliqueConfigPage1Column", 2)
	self:skinObject("slider", {obj=_G.CliqueConfig.page1.slider})
	self:removeMagicBtnTex(_G.CliqueConfig.page1.button_spell)
	self:removeMagicBtnTex(_G.CliqueConfig.page1.button_other)
	self:removeMagicBtnTex(_G.CliqueConfig.page1.button_options)
	if self.modBtns then
		self:skinStdButton{obj=_G.CliqueConfig.page1.button_spell}
		self:skinStdButton{obj=_G.CliqueConfig.page1.button_other}
		self:skinStdButton{obj=_G.CliqueConfig.page1.button_options}
	end
	self:skinObject("slider", {obj=_G.CliqueConfig.page2.clickGrabber.scrollFrame.ScrollBar})
	self:removeMagicBtnTex(_G.CliqueConfig.page2.button_save)
	self:removeMagicBtnTex(_G.CliqueConfig.page2.button_cancel)
	self:skinObject("frame", {obj=_G.CliqueConfig.page2.clickGrabber, fb=true})
	if self.modBtns then
		self:skinStdButton{obj=_G.CliqueConfig.page2.button_binding}
		self:skinStdButton{obj=_G.CliqueConfig.page2.button_save}
		self:skinStdButton{obj=_G.CliqueConfig.page2.button_cancel}
		self:SecureHook(_G.CliqueConfig.page2.button_save, "Disable", function(this, _)
			self:clrBtnBdr(this)
		end)
		self:SecureHook(_G.CliqueConfig.page2.button_save, "Enable", function(this, _)
			self:clrBtnBdr(this)
		end)
	end
	self:skinObject("glowbox", {obj=_G.CliqueConfig.bindAlert})
	self:skinObject("frame", {obj=_G.CliqueConfig, kfs=true, cb=true, ofs=2, x1=-5, x2=2.5})

	self:skinObject("glowbox", {obj=_G.CliqueTabAlert})

end
