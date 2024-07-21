local _, aObj = ...
if not aObj:isAddonEnabled("WeakAuras") then return end
local _G = _G

aObj.addonsToSkin.WeakAuras = function(self) -- v 5.15.0

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

	self:SecureHookScript(_G.WeakAurasProfilingFrame, "OnShow", function(this)
		self:keepFontStrings(this.ColumnDisplay)
		self:skinColumnDisplay(this.ColumnDisplay)
		self:skinObject("dropdown", {obj=this.buttons.modeDropDown})
		this.ScrollBox:DisableDrawLayer("BACKGROUND")
		self:skinObject("scrollbar", {obj=this.ScrollBar})
		self:skinObject("frame", {obj=this, kfs=true, cb=true, ofs=self.isRtl and -1 or 2, x2=self.isRtl and 0 or 1})
		if self.modBtns then
			self:skinOtherButton{obj=this.MaxMinButtonFrame.MaximizeButton, font=self.fontS, text=self.nearrow}
			self:skinOtherButton{obj=this.MaxMinButtonFrame.MinimizeButton, font=self.fontS, text=self.swarrow}
			self:skinStdButton{obj=this.buttons.report}
			self:skinStdButton{obj=this.buttons.stop}
			self:skinStdButton{obj=this.buttons.start, clr="grey"}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.WeakAurasProfilingReport, "OnShow", function(this)
		self:skinObject("scrollbar", {obj=this.ScrollBox.ScrollBar})
		this.ScrollBox.messageFrame:DisableDrawLayer("BACKGROUND")
		self:skinObject("frame", {obj=this, kfs=true, cb=true, ofs=self.isRtl and -1 or 2, x2=self.isRtl and 0 or 1})

		self:Unhook(this, "OnShow")
	end)

end

aObj.lodAddons.WeakAurasOptions = function(self) -- v 5.15.0

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
		self:skinObject("frame", {obj=this, kfs=true, ofs=self.isRtl and -1 or 2, x2=self.isRtl and 0 or 1})
		if self.modBtns then
			self:skinCloseButton{obj=this.CloseButton}
			self:skinOtherButton{obj=this.MaxMinButtonFrame.MaximizeButton, font=self.fontS, text=self.nearrow}
			self:skinOtherButton{obj=this.MaxMinButtonFrame.MinimizeButton, font=self.fontS, text=self.swarrow}
		end
		-- hide the frame skin around the RHS InlineGroup
		if this.container.content:GetParent().sf then
			this.container.content:GetParent().sf:Hide()
		end

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.WeakAurasOptions)

	local function skinKids(frame)
		for _, child in _G.ipairs_reverse{frame:GetChildren()} do
			if child:IsObjectType("EditBox") then
				aObj:skinObject("editbox", {obj=child, ofs=4})
			elseif child:IsObjectType("Button")
			and not child.obj
			and aObj.modBtns
			then
				aObj:skinStdButton{obj=child}
			end
		end
	end
	-- IconPicker
	self.RegisterCallback("WeakAurasOptions", "Ace3_InlineGroup", function(_, iGrp)
		_G.C_Timer.After(0.1, function() -- wait for object to be populated
			if iGrp.frame:GetParent() == _G.WeakAurasOptions then
				skinKids(iGrp.frame)
				self.UnregisterCallback("WeakAurasOptions", "Ace3_InlineGroup")
			end
		end)
	end)
	-- ImportExport, TextEditor, CodeReview, DebugLog
	self.RegisterCallback("WeakAurasOptions", "Ace3_WeakAurasInlineGroup", function(_, waiGrp)
		_G.C_Timer.After(0.1, function()
			skinKids(waiGrp.frame)
			-- Code Editor frame
			if _G.WeakAurasSnippets then
				self:secureHookScript(_G.WeakAurasSnippets, "OnShow", function(this)
					self:skinObject("frame", {obj=this, kfs=true, cb=true})
					if self.modBtns then
						self:skinStdButton{obj=self:getChild(this, 5)} -- AddSnippetButton
					end

					self:Unhook(this, "OnShow")
				end)
				self:secureHookScript(_G.WeakAurasAPISearchFrame, "OnShow", function(this)
					self:skinObject("editbox", {obj=_G.WeakAurasAPISearchFilterInput, si=true})
					self:skinObject("frame", {obj=this, kfs=true, cb=true})

					self:Unhook(this, "OnShow")
				end)
				if self.modBtns then
					self:skinStdButton{obj=_G.WASettingsButton}
				end
			end
		end)
	end)
	-- Template
	self.RegisterCallback("WeakAurasOptions", "Ace3_WeakAurasTemplateGroup", function(_, watGrp)
		_G.C_Timer.After(0.1, function()
			skinKids(watGrp.frame)
			self.UnregisterCallback("WeakAurasOptions", "Ace3_WeakAurasTemplateGroup")
		end)
	end)
	-- UpdateFrame
	self.RegisterCallback("WeakAurasOptions", "Ace3_ScrollFrame", function(_, sFrm)
		_G.C_Timer.After(0.1, function()
			if sFrm.frame:GetParent() == _G.WeakAurasOptions then
				skinKids(sFrm.frame)
				self.UnregisterCallback("WeakAurasOptions", "Ace3_ScrollFrame")
			end
		end)
	end)
	-- TexturePicker, ModelPicker
	self.RegisterCallback("WeakAurasOptions", "Ace3_SimpleGroup", function(_, sGrp)
		_G.C_Timer.After(0.1, function() -- wait for object to be populated
			if sGrp.frame:GetParent() == _G.WeakAurasOptions then
				skinKids(sGrp.frame)
			end
			-- TODO: Add button border to .textureWidgets
		end)
	end)

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

	self:SecureHookScript(_G.WeakAurasOptions.tipPopup, "OnShow", function(this)
		self:skinObject("editbox", {obj=self:getChild(this, 1), y1=-4, y2=4})
		self:skinObject("frame", {obj=this, kfs=true, ofs=0})

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.WeakAurasOptions.dynamicTextCodesFrame, "OnShow", function(this)
		self:skinObject("frame", {obj=this, kfs=true, cb=true})

		self:Unhook(this, "OnShow")
	end)

end
