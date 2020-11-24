local _, aObj = ...
if not aObj:isAddonEnabled("ActionBarProfiles") then return end
local _G = _G

aObj.addonsToSkin.ActionBarProfiles = function(self) -- v 9.0.1-1

	self:SecureHookScript(_G.PaperDollActionBarProfilesPane, "OnShow", function(this)
		this.scrollBar:DisableDrawLayer("BACKGROUND")
		this.scrollBar:DisableDrawLayer("ARTWORK")
		self:skinObject("slider", {obj=this.scrollBar, y1=-2, y2=2})
		for _, btn in _G.pairs(this.buttons) do
			btn:DisableDrawLayer("BACKGROUND")
			if self.modBtnBs then
				self:addButtonBorder{obj=btn, relTo=btn.icon}
			end
		end
		if self.modBtns then
			self:skinStdButton{obj=this.UseProfile}
			self:skinStdButton{obj=this.SaveProfile}
			self:SecureHook(this, "Update", function(this)
				self:clrBtnBdr(this.UseProfile)
				self:clrBtnBdr(this.SaveProfile)
			end)
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.PaperDollActionBarProfilesSaveDialog, "OnShow", function(this)
		self:skinObject("editbox", {obj=this.EditBox})
		this:DisableDrawLayer("BACKGROUND")
		self:skinObject("frame", {obj=this, ofs=-4})
		if self.modBtns then
			self:skinStdButton{obj=_G.PaperDollActionBarProfilesSaveDialogCancel}
			self:skinStdButton{obj=this.Okay}
			self:SecureHook(this, "Update", function(this)
				self:clrBtnBdr(this.Okay)
			end)
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=this.OptionActions, ofs=-2}
			self:skinCheckButton{obj=this.OptionEmptySlots, ofs=-2}
			self:skinCheckButton{obj=this.OptionTalents, ofs=-2,}
			self:skinCheckButton{obj=this.OptionMacros, ofs=-2}
			self:skinCheckButton{obj=this.OptionPetActions, ofs=-2}
			self:skinCheckButton{obj=this.OptionBindings, ofs=-2}
		end

		self:Unhook(this, "OnShow")
	end)

end
