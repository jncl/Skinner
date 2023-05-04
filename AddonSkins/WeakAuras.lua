local _, aObj = ...
if not aObj:isAddonEnabled("WeakAuras") then return end
local _G = _G

aObj.addonsToSkin.WeakAuras = function(self) -- v 5.5.2

	if _G.WeakAuras.ShowDisplayTooltip then
		-- hook this to skin the WeakAuras added elements
		local s1, s2, s3, s4, s5
		self:SecureHook(_G.WeakAuras, "ShowDisplayTooltip", function(this, _)
			if _G.ItemRefTooltip.WeakAuras_Tooltip_Thumbnail
			and not s1
			then
				if self.modBtnBs then
					self:addButtonBorder{obj=_G.ItemRefTooltip.WeakAuras_Tooltip_Thumbnail}
				end
				s1 = true
			end
			if _G.ItemRefTooltip.WeakAuras_Tooltip_Button
			and not s2
			then
				if self.modBtns then
					self:skinStdButton{obj=_G.ItemRefTooltip.WeakAuras_Tooltip_Button}
				end
				s2 = true
			end
			if _G.ItemRefTooltip.WeakAuras_Tooltip_Button2
			and not s3
			then
				if self.modBtns then
					self:skinStdButton{obj=_G.ItemRefTooltip.WeakAuras_Tooltip_Button2}
				end
				s3 = true
			end
			if _G.ItemRefTooltip.WeakAuras_Desc_Box
			and not s4
			then
				self:skinObject("frame", {obj=_G.ItemRefTooltip.WeakAuras_Desc_Box, fb=true})
				_G.ItemRefTooltip.WeakAuras_Desc_Box.SetBackdrop = _G.nop
				s4 = true
			end
			if _G.WeakAurasTooltipAnchor
			and not s5
			then
				local frame = _G.WeakAurasTooltipAnchor
				-- .WeakAurasTooltipThumbnailFrame
				if self.modBtns then
					self:skinStdButton{obj=self:getChild(frame, 2)} -- these buttons have the same name (importButton)
					self:skinStdButton{obj=self:getChild(frame, 3)} -- these buttons have the same name (showCodeButton)
				end
				if self.modChkBtns then
					local cBtn
					for i = 1, 15 do
						cBtn = frame["WeakAurasTooltipCheckButton" .. i]
						if cBtn then
							self:skinCheckButton{obj=cBtn}
						end
					end
				end
				s5 = true
			end
			if s1
			and s2
			and s3
			and s4
			and s5
			then
				self:Unhook(this, "ShowDisplayTooltip")
			end
		end)
	end

	-- hook this as frame is shown before it is fully setup
	self:SecureHook(_G.WeakAuras.RealTimeProfilingWindow, "UpdateButtons", function(this)
		-- barsFrame
		-- statsFrame
		self:skinObject("frame", {obj=this})
		if self.modBtns then
			self:skinCloseButton{obj=this.CloseButton}
			self:skinOtherButton{obj=this.MaxMinButtonFrame.MaximizeButton, font=self.fontS, text=self.nearrow}
			self:skinOtherButton{obj=this.MaxMinButtonFrame.MinimizeButton, font=self.fontS, text=self.swarrow}
			self:skinStdButton{obj=this.toggleButton}
			self:skinStdButton{obj=this.reportButton}
			self:skinStdButton{obj=this.combatButton}
			self:skinStdButton{obj=this.encounterButton}
		end

		self:Unhook(this, "UpdateButtons")
	end)

end

aObj.lodAddons.WeakAurasOptions = function(self) -- v 5.5.2

	-- wait until frame is created
	if not _G.WeakAurasOptions then
		_G.C_Timer.After(0.1, function()
			self.lodAddons.WeakAurasOptions(self)
		end)
		return
	end

	self:SecureHookScript(_G.WeakAurasOptions, "OnShow", function(this)
		self:skinObject("editbox", {obj=this.filterInput, si=true, ca=true})
		this.moversizer:SetBackdropBorderColor(self.bbClr:GetRGB())
		self:skinObject("frame", {obj=this, kfs=true, x2=0, y1=-1})
		if self.modBtns then
			self:skinCloseButton{obj=this.CloseButton, fType=ftype}
			self:skinOtherButton{obj=this.MaxMinButtonFrame.MaximizeButton, font=self.fontS, text=self.nearrow}
			self:skinOtherButton{obj=this.MaxMinButtonFrame.MinimizeButton, font=self.fontS, text=self.swarrow}
		end
		-- hide the frame skin around the RHS InlineGroup
		if this.container.content:GetParent().sf then
			this.container.content:GetParent().sf:Hide()
		end
		local _, _, _, enabled, loadable = _G.GetAddOnInfo("WeakAurasTutorials")
		if enabled
		and loadable
		then
			self:keepFontStrings(self:getChild(this, 5)) -- tutorial button frame
		end
		-- additional frames
		self:skinObject("editbox", {obj=self:getChild(this.iconPicker.frame, 2), ofs=4})
		self:skinObject("frame", {obj=_G.WeakAurasSnippets, kfs=true})
		if self.modBtns then
			self:skinStdButton{obj=self:getPenultimateChild(this.texturePicker.frame)}
			self:skinStdButton{obj=self:getLastChild(this.texturePicker.frame)}
			self:skinStdButton{obj=self:getPenultimateChild(this.iconPicker.frame)}
			self:skinStdButton{obj=self:getLastChild(this.iconPicker.frame)}
			self:skinStdButton{obj=self:getPenultimateChild(this.modelPicker.frame)}
			self:skinStdButton{obj=self:getLastChild(this.modelPicker.frame)}
			self:skinStdButton{obj=self:getLastChild(this.importexport.frame)}
			self:skinStdButton{obj=self:getLastChild(this.codereview.frame)}
			self:skinStdButton{obj=self:getChild(this.texteditor.frame, 2)}
			self:skinStdButton{obj=self:getChild(this.texteditor.frame, 3)}
			self:skinStdButton{obj=_G.WASettingsButton}
			self:skinStdButton{obj=self:getChild(this.texteditor.frame, 4)}
			self:skinStdButton{obj=_G.WASnippetsButton}
			self:skinStdButton{obj=self:getChild(_G.WeakAurasSnippets, 5)} -- AddSnippetButton
		end

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.WeakAurasOptions)

	-- Templates
	if self.modBtns then
		-- event, addon
		self.RegisterCallback("WeakAurasOptions", "AddOn_Loaded", function(_, addon)
			if addon == "WeakAurasTemplates" then
				_G.C_Timer.After(0.1, function()
					self:skinStdButton{obj=_G.WeakAurasOptions.newView.backButton}
					self:skinStdButton{obj=_G.WeakAurasOptions.newView.makeBatchButton}
					self:skinStdButton{obj=_G.WeakAurasOptions.newView.batchButton}
					self:skinStdButton{obj=self:getLastChild(_G.WeakAurasOptions.newView.frame)} -- cancel button
				end)
				self.UnregisterCallback("WeakAurasOptions", "AddOn_Loaded")
			end
		end)
	end

	local tipPopup = self:getChild(_G.WeakAurasOptions, 7)
	local eb = self:getChild(tipPopup, 1)
	if eb
	and eb:GetObjectType() == "EditBox"
	then
		self:skinObject("editbox", {obj=eb})
		self:skinObject("frame", {obj=tipPopup, kfs=true, ofs=0})
	end

end
