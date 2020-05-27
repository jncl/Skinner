local _, aObj = ...
if not aObj:isAddonEnabled("Restocker") then return end
local _G = _G

aObj.addonsToSkin.Restocker = function(self) -- v 6.1

	self:SecureHookScript(_G.RestockerMainFrame, "OnShow", function(this)

		self:removeInset(this.listInset)
		self:skinSlider{obj=this.scrollFrame.ScrollBar}
		self:skinEditBox{obj=this.editBox, regs={6}} -- 6 is text
		self:skinDropDown{obj=this.profileDropDownMenu}
		_G.UIDropDownMenu_SetWidth(this.profileDropDownMenu, 120)
		_G.UIDropDownMenu_SetButtonWidth(this.profileDropDownMenu, 24)
		self:addSkinFrame{obj=this, ft="a", kfs=true, x2=1}
		if self.modBtns then
			self:skinStdButton{obj=this.addBtn}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=this.checkbox}
			self:skinCheckButton{obj=self:getChild(this, 6)} -- N.B. .checkboxBank used by check button and check button text
		end

		self:Unhook(this, "OnShow")
	end)

	-- Hook this to skin scrollChild entries
	self:SecureHook(_G.RestockerMainFrame.scrollChild, "SetHeight", function(this, ...)
		local btn
		for _, child in pairs{this:GetChildren()} do
			self:skinEditBox{obj=child.editBox, regs={6}} -- 6 is text
			if self.modBtns then
				btn = self:getChild(child, 1)
				if not btn.sb then -- only move once
					self:moveObject{obj=btn, x=-2}
				end
				self:skinCloseButton{obj=btn}
			end
		end
		btn = nil

	end)

	self.RegisterCallback("Restocker", "IOFPanel_Before_Skinning", function(this, panel)
		if panel.name ~= "Restocker" then return end
		self.iofSkinnedPanels[panel] = true

		self:skinEditBox{obj=panel.addProfileEditBox, regs={6}} -- 6 is text
		self:skinDropDown{obj=panel.deleteProfileMenu, x2=109}
		if self.modBtns then
			self:skinStdButton{obj=panel.addProfileButton}
			self:skinStdButton{obj=panel.deleteProfileButton}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=panel.loginMessage}
			self:skinCheckButton{obj=panel.autoOpenAtMerchant}
			self:skinCheckButton{obj=panel.autoOpenAtBank}
			self:skinCheckButton{obj=panel.sortListAlphabetically}
			self:skinCheckButton{obj=panel.sortListNumerically}
		end

		self.UnregisterCallback("Restocker", "IOFPanel_Before_Skinning")
	end)

end
