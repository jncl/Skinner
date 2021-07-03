local _, aObj = ...
if not aObj:isAddonEnabled("DBM-Core") then return end
local _G = _G

aObj.addonsToSkin["DBM-Core"] = function(self) -- v 9.0.30/2.5.7

	-- hook this to skin the InfoFrame frame (actually a tooltip)
	self:SecureHook(_G.DBM.InfoFrame, "Show", function(this, _, event, ...)
		if _G.DBM.Options.DontShowInfoFrame and (event or 0) ~= "test" then return end
		self:skinObject("frame", {obj=this})

		self:Unhook(_G.DBM.InfoFrame, "Show")
	end)

	-- hook this to skin UpdateReminder frame
	self:SecureHook(_G.DBM, "ShowUpdateReminder", function(this, ...)
		self:skinObject("editbox", {obj=self:getChild(_G.DBMUpdateReminder, 1), y1=-4, y2=4})
		self:skinObject("frame", {obj=_G.DBMUpdateReminder, ofs=0})
		if self.modBtns then
			self:skinStdButton{obj=self:getChild(_G.DBMUpdateReminder, 2)}
		end
		
		self:Unhook(_G.DBM, "ShowUpdateReminder")
	end)

	-- hook this to skin DBMNotesEditor frame
	self:SecureHook(_G.DBM, "ShowNoteEditor", function(this, ...)
		self:skinObject("editbox", {obj=self:getChild(this.Noteframe, 1), y1=-4, y2=4})
		self:skinObject("frame", {obj=this.Noteframe, ofs=0})
		if self.modBtns then
			self:skinStdButton{obj=self:getChild(this.Noteframe, 2)}
			self:skinStdButton{obj=self:getChild(this.Noteframe, 3)}
			self:skinStdButton{obj=self:getChild(this.Noteframe, 4)}
		end

		self:Unhook(this, "ShowNoteEditor")
	end)

	-- set default Timer bar texture
	if _G.DBT_PersistentOptions then
		_G.DBT_PersistentOptions.Texture = self.sbTexture
	end
	_G.DBT.Options.Texture = self.sbTexture
	-- apply the new texture
	for bar in _G.DBT:GetBarIterator() do
		bar:SetStatusBarTexture(self.sbTexture)
	end

	-- minimap button
	if _G.DBMMinimapButton -- from 17687 alpha uses lib DBIcon for minimap button
	and self.db.profile.MinimapButtons.skin
	then
		_G.DBMMinimapButton:GetNormalTexture():SetTexCoord(.3, .7, .3, .7)
		_G.DBMMinimapButton:GetPushedTexture():SetTexCoord(.3, .7, .3, .7)
		_G.DBMMinimapButton:SetSize(22, 22)
		self:addSkinButton{obj=_G.DBMMinimapButton, parent=_G.DBMMinimapButton}
	end

end

aObj.lodAddons["DBM-GUI"] = function(self) -- v 9.0.30/2.5.7

	self:SecureHook(_G.DBM_GUI_OptionsFrame, "UpdateMenuFrame", function(this)
		for _, btn in _G.pairs(_G.DBM_GUI_OptionsFrameList.buttons) do
			if btn.element
			and btn.element.haschilds
			then
				if btn.toggle.sb then
					self:checkTex(btn.toggle)
					btn.toggle.sb:SetShown(btn.toggle:IsShown())
				else
					self:skinExpandButton{obj=btn.toggle, sap=true}
					self:checkTex(btn.toggle)
				end
			elseif btn.toggle.sb then
				btn.toggle.sb:Hide()
			end
		end
	end)
	--	Options Frame
	self:SecureHookScript(_G.DBM_GUI_OptionsFrame, "OnShow", function(this)
		self:removeBackdrop(_G.DBM_GUI_OptionsFrameListList)
		self:skinObject("slider", {obj=_G.DBM_GUI_OptionsFrameListListScrollBar})
		self:skinObject("frame", {obj=_G.DBM_GUI_OptionsFrameList, kfs=true, fb=true})
		self:removeBackdrop(self:getChild(_G.DBM_GUI_OptionsFramePanelContainerFOV.ScrollBar, 3))
		self:skinObject("slider", {obj=_G.DBM_GUI_OptionsFramePanelContainerFOV.ScrollBar})
		self:skinObject("frame", {obj=_G.DBM_GUI_OptionsFramePanelContainer, kfs=true, fb=true})
		_G.DBM_GUI_OptionsFrame.numTabs = 2
		self:skinObject("tabs", {obj=this, prefix=this:GetName(), ignoreSize=true, ignoreHLTex=true, lod=self.isTT and true, upwards=true, offsets={x1=4, y1=0, x2=-4, y2=-2}})
		self:SecureHook(_G.DBM_GUI_OptionsFrame, "ShowTab", function(this, tab)
			_G.PanelTemplates_SetTab(this, tab)
		end)
		self:skinObject("frame", {obj=this, kfs=true, hdr=true})
		if self.modBtns then
			self:skinStdButton{obj=_G.DBM_GUI_OptionsFrameOkay}
			self:skinStdButton{obj=_G.DBM_GUI_OptionsFrameWebsiteButton}
			-- skin the Bosses LoadAddOn buttons
			for _, addon in _G.ipairs(_G.DBM.AddOns) do
				if addon.panel.frame:GetNumChildren() == 1 then
					self:skinStdButton{obj=self:getChild(addon.panel.frame, 1)}
				end
			end
		end

		self:Unhook(this, "OnShow")
	end)
	
	self:SecureHookScript(_G.DBM_GUI_DropDown, "OnShow", function(this)
		self:skinObject("slider", {obj=_G.DBM_GUI_DropDownListScrollBar, x1=6, x2=-6})
		self:skinObject("frame", {obj=_G.DBM_GUI_DropDown, kfs=true})
		
		self:Unhook(this, "OnShow")
	end)

	-- skin dropdown menu
	local cW, cH
	local function skinSubPanels(panel)
		for _, subPanel in _G.pairs(panel.areas) do
			if not subPanel.sknd then
				aObj:skinObject("skin", {obj=subPanel.frame, bd=10, ng=true})
				subPanel.sknd = true
				-- skin suitable children
				for _, child in _G.ipairs{subPanel.frame:GetChildren()} do
					if aObj:isDropDown(child) then
						aObj:skinObject("dropdown", {obj=child, x2=34})
	                elseif child:IsObjectType("CheckButton")
					and aObj.modChkBtns
					then -- NewSpecialWarning object
						aObj:skinCheckButton{obj=child}
	                    for _, child2 in _G.ipairs{child:GetChildren()} do
	                        if aObj:isDropDown(child2) then
								aObj:skinObject("dropdown", {obj=child2, x1=16, x2=34, y2=-1})
	                        end
	                    end
					elseif child:IsObjectType("Button")
					and aObj.modBtns
					then
						cW, cH = _G.Round(child:GetWidth()), _G.Round(child:GetHeight())
						-- aObj:Debug("skinSubPanels Button: [%s, %s]", cW, cH)
						-- handle expand button (Spell/Skill Cooldowns)
						if cW == 15
						and cH == 15
						then
							child:SetSize(8, 8)
							aObj:skinExpandButton{obj=child}
							aObj:checkTex(child)
						else
							-- increase high of short, narrow buttons
							if cH <= 16 then
								child:SetHeight(20)
							end
							if cW == 25 then -- handle Note buttons
								child:SetWidth(28)
							end
							aObj:skinStdButton{obj=child, ofs=0, x1=4, x2=-4}
						end
	                elseif child:IsObjectType("EditBox") then
						aObj:skinObject("editbox", {obj=child})
					elseif child:IsObjectType("Slider") then
						aObj:removeBackdrop(child)
						aObj:skinObject("slider", {obj=child})
					end
				end
			end
		end
	end
	
	-- register here to skin option panels
	_G.DBM:RegisterOnGuiLoadCallback(function()
		for _, panel in _G.ipairs(_G.DBM_GUI.panels) do
			if panel.areas then
				skinSubPanels(panel)
			end
		end
	end)
	
	-- hook this to skin BossMod sub panels button in TRHC
	self:SecureHook(_G.DBM_GUI, "CreateBossModPanel", function(this, mod)
		if self.modBtns then
			self:skinStdButton{obj=self:getChild(mod.panel.frame, 1), ofs=0}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=self:getChild(mod.panel.frame, 2)}
		end
	end)
	
	local function skinPopupFrame()
		local pFrame = aObj:getLastChild(_G.UIParent)
		aObj:removeBackdrop(aObj:getChild(pFrame, 1))
		aObj:skinObject("frame", {obj=_G.TestEditBox, kfs=true, fb=true, y2=-4})
		aObj:skinObject("slider", {obj=_G.TestScrollFrame.ScrollBar})
		aObj:skinObject("frame", {obj=pFrame, ofs=0})
		if aObj.modBtns then
			aObj:skinStdButton{obj=aObj:getPenultimateChild(pFrame)}
			aObj:skinStdButton{obj=pFrame.import}
		end
		pFrame = nil
		skinPopupFrame = nil
	end	
	self:SecureHook(_G.DBM_GUI, "CreateExportProfile", function(this, export)
		if skinPopupFrame then
			skinPopupFrame()
		end
		
		self:Unhook(_G.DBM_GUI, "CreateExportProfile")
	end)
	self:SecureHook(_G.DBM_GUI, "CreateImportProfile", function(this, importFunc)
		if skinPopupFrame then
			skinPopupFrame()
		end
		
		self:Unhook(_G.DBM_GUI, "CreateImportProfile")
	end)

end
