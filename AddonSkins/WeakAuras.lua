local _, aObj = ...
if not aObj:isAddonEnabled("WeakAuras") then return end
local _G = _G

aObj.addonsToSkin.WeakAuras = function(self) -- v 3.7.13

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

	-- setup defaults for Progress Bars
	local c = self.prdb.StatusBar
	_G.WeakAuras.regionTypes["aurabar"].default.texture = c.texture
	_G.WeakAuras.regionTypes["aurabar"].default.barColor = {c.r, c.g, c.b, c.a}

	-- hook this as frame is shown before it is fully setup
	self:SecureHook(_G.WeakAuras.RealTimeProfilingWindow, "UpdateButtons", function(this)
		-- barsFrame
		-- statsFrame
		self:skinObject("frame", {obj=this})
		if self.modBtns then
			self:skinCloseButton{obj=self:getChild(this.titleFrame, 1)}
			self:moveObject{obj=self:getChild(this.titleFrame, 1), x=4}
			local minBtn = self:getChild(this.titleFrame, 2)
			self:skinOtherButton{obj=minBtn, font=self.fontS, text=aObj.swarrow, size=28}
			self:moveObject{obj=minBtn, y=-2}
			self:SecureHookScript(minBtn, "OnClick", function(bObj)
				if bObj:GetParent():GetParent().minimized then
					bObj:SetText(aObj.nearrow)
					self:adjHeight{obj=bObj:GetParent():GetParent(), adj=2}
				else
					bObj:SetText(aObj.swarrow)
				end
			end)
			self:skinStdButton{obj=this.toggleButton}
			self:skinStdButton{obj=this.reportButton}
			self:skinStdButton{obj=this.combatButton}
			self:skinStdButton{obj=this.encounterButton}
		end

		self:Unhook(this, "UpdateButtons")
	end)

	self:SecureHook(_G.WeakAuras, "PrintProfile", function(this)
		self:skinObject("slider", {obj=_G.WADebugEditBox.ScrollFrame.ScrollBar})
		_G.WADebugEditBox.Background:DisableDrawLayer("OVERLAY") -- titlebg
		self:getChild(_G.WADebugEditBox.Background, 2):DisableDrawLayer("BACKGROUND")
		self:skinObject("frame", {obj=_G.WADebugEditBox.Background, y1=4})
		if self.modBtns then
			self:skinCloseButton{obj=self:getChild(_G.WADebugEditBox.Background, 1)}
		end

		self:Unhook(this, "PrintProfile")
	end)

end

aObj.lodAddons.WeakAurasOptions = function(self) -- v 3.7.13

	-- wait until frame is created
	if not _G.WeakAurasOptions then
		_G.C_Timer.After(0.1, function()
			self.lodAddons.WeakAurasOptions(self)
		end)
		return
	end

	self:SecureHookScript(_G.WeakAurasOptions, "OnShow", function(this)
		self:skinObject("editbox", {obj=this.filterInput, si=true, ca=true})
		self:moveObject{obj=self:getRegion(self:getChild(this, 2), 1), y=-10} -- title text
		this.moversizer:SetBackdropBorderColor(self.bbClr:GetRGB())
		self:skinObject("frame", {obj=this, kfs=true, ofs=-1, y1=5})
		if self.modBtns then
			local function skinBtn(id)
				local frame = aObj:getChild(this, id)
				aObj:keepFontStrings(frame)
				aObj:moveObject{obj=frame, x=23, y=id ~= 2 and 1 or 0}
				if id == 1 then
					aObj:skinCloseButton{obj=aObj:getChild(frame, 1)}
				end
				if id == 5 then -- up-down arrow
					aObj:skinOtherButton{obj=aObj:getChild(frame, 1), font=aObj.fontS, text=aObj.swarrow, size=28}
					aObj:SecureHookScript(aObj:getChild(frame, 1), "OnClick", function(bObj)
						if _G.WeakAurasOptions.minimized then
							bObj:SetText(aObj.nearrow)
						else
							bObj:SetText(aObj.swarrow)
						end
					end)
				end
			end
			skinBtn(1) -- close button frame
			skinBtn(5) -- minimize button frame
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
			self:skinStdButton{obj=self:getChild(_G.WeakAurasSnippets, 1)}
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
