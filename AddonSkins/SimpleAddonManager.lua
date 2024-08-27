local _, aObj = ...
if not aObj:isAddonEnabled("SimpleAddonManager") then return end
local _G = _G

aObj.addonsToSkin.SimpleAddonManager = function(self) -- v 1.34

	self:SecureHookScript(_G.SimpleAddonManager, "OnShow", function(this)
		self:skinObject("dropdown", {obj=this.CharacterDropDown, x2=109})
		self:skinObject("frame", {obj=this, kfs=true, cb=true})
		self:skinObject("slider", {obj=this.ScrollFrame.ScrollBar})
		self:skinObject("editbox", {obj=this.SearchBox, si=true})
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
		if self.modChkBtns then
			for _, cBtn in ipairs(this.ScrollFrame.buttons) do
				self:skinCheckButton{obj=cBtn.EnabledButton}
			end
		end

		self:SecureHookScript(this.CategoryFrame, "OnShow", function(fObj)
			self:skinObject("slider", {obj=fObj.ScrollFrame.ScrollBar})
			if self.modBtns then
				self:skinStdButton{obj=fObj.NewButton}
				self:skinStdButton{obj=fObj.SelectAllButton}
				self:skinStdButton{obj=fObj.ClearSelectionButton}
			end
			if self.modChkBtns then
				for _, cBtn in ipairs(fObj.ScrollFrame.buttons) do
					self:skinCheckButton{obj=cBtn.EnabledButton}
				end
			end

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.CategoryFrame)

		self:Unhook(this, "OnShow")
	end)

end
