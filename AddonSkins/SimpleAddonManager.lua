local _, aObj = ...
if not aObj:isAddonEnabled("SimpleAddonManager") then return end
local _G = _G

aObj.addonsToSkin.SimpleAddonManager = function(self) -- v 1.54

	self:SecureHookScript(_G.SimpleAddonManager, "OnShow", function(this)
		self:skinObject("dropdown", {obj=this.CharacterDropDown, x2=109})
		self:skinObject("editbox", {obj=this.SearchBox, si=true})
		self:skinObject("frame", {obj=this, kfs=true, cb=true, ofs=0})
		if self.modBtns then
			self:skinStdButton{obj=this.CancelButton}
			self:skinStdButton{obj=this.OkButton}
			self:skinStdButton{obj=this.EnableAllButton}
			self:skinStdButton{obj=this.DisableAllButton}
			self:skinStdButton{obj=this.SetsButton}
			self:skinStdButton{obj=this.ResultOptionsButton}
			self:skinStdButton{obj=this.ConfigButton}
			self:skinStdButton{obj=this.CategoryButton}
		end

		self:SecureHookScript(this.AddonListFrame, "OnShow", function(fObj)
			self:skinObject("slider", {obj=fObj.ScrollFrame.ScrollBar})

			for _, btn in _G.ipairs(fObj.ScrollFrame.buttons) do
				if self.modBtns then
					self:skinExpandButton{obj=btn.ExpandOrCollapseButton, onSB=true}
				end
				if self.modChkBtns then
					self:skinCheckButton{obj=btn.EnabledButton}
				end
			end

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.AddonListFrame)

		self:SecureHookScript(this.CategoryFrame, "OnShow", function(fObj)
			self:skinObject("slider", {obj=fObj.ScrollFrame.ScrollBar})
			if self.modBtns then
				self:skinStdButton{obj=fObj.NewButton}
				self:skinStdButton{obj=fObj.SelectAllButton}
				self:skinStdButton{obj=fObj.ClearSelectionButton}
			end
			if self.modChkBtns then
				for _, cBtn in _G.ipairs(fObj.ScrollFrame.buttons) do
					self:skinCheckButton{obj=cBtn.EnabledButton}
				end
			end

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.CategoryFrame)

		self:SecureHookScript(_G.SAM_ADDON_LIST_TOOLTIP, "OnShow", function(fObj)
			self:skinObject("frame", {obj=fObj, kfs=true, ofs=0})

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(_G.SAM_ADDON_LIST_TOOLTIP)


		self:Unhook(this, "OnShow")
	end)

end
