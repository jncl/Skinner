local _, aObj = ...
if not aObj:isAddonEnabled("DBM-Core") then return end
local _G = _G

aObj.addonsToSkin["DBM-Core"] = function(self) -- v 10.0.5/2.5.15

	-- hook this to skin the InfoFrame frame
	self:SecureHook(_G.DBM.InfoFrame, "Show", function(_, _, event, _)
		if _G.DBM.Options.DontShowInfoFrame and (event or 0) ~= "test" then return end
		self:skinObject("frame", {obj=_G.DBMInfoFrame})

		self:Unhook(_G.DBM.InfoFrame, "Show")
	end)

	-- hook this to skin UpdateReminder frame
	self:SecureHook(_G.DBM, "ShowUpdateReminder", function(_, _)
		self:skinObject("editbox", {obj=self:getChild(_G.DBMUpdateReminder, 1), y1=-4, y2=4})
		self:skinObject("frame", {obj=_G.DBMUpdateReminder, ofs=0})
		if self.modBtns then
			self:skinStdButton{obj=self:getChild(_G.DBMUpdateReminder, 2)}
		end

		self:Unhook(_G.DBM, "ShowUpdateReminder")
	end)

	-- hook this to skin DBMNotesEditor frame
	self:SecureHook(_G.DBM, "ShowNoteEditor", function(this, _)
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

aObj.lodAddons["DBM-GUI"] = function(self) -- v 10.0.5/2.5.15

	self:SecureHook(_G.DBM_GUI_OptionsFrame, "UpdateMenuFrame", function(_)
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
		self:skinObject("tabs", {obj=this, prefix=this:GetName(), ignoreSize=true, ignoreHLTex=true, lod=self.isTT and true, upwards=true, regions={7}, offsets={x1=6, y1=-2, x2=14, y2=-4}, track=false})
		if self.isTT then
			self:SecureHook(_G.DBM_GUI_OptionsFrame, "ShowTab", function(_, tab)
				for i = 1, #_G.DBM_GUI.tabs do
					if i == tab then
						self:setActiveTab(_G["DBM_GUI_OptionsFrameTab" .. i].sf)
					else
						self:setInactiveTab(_G["DBM_GUI_OptionsFrameTab" .. i].sf)
					end
				end
			end)
		end
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
	local function skinSubPanels(frame)
		for _, child in _G.ipairs{frame:GetChildren()} do
			if child.mytype == "area"
			and not child.sknd
			then
				child.sknd = true
				aObj:skinObject("skin", {obj=child, bd=10, ng=true}) -- frame border
				for _, gChild in _G.ipairs{child:GetChildren()} do
					if aObj:isDropDown(gChild) then
						aObj:skinObject("dropdown", {obj=gChild, x2=gChild.width and 34 or nil})
					elseif gChild:IsObjectType("CheckButton")
					and aObj.modChkBtns
					then -- NewSpecialWarning object
						aObj:skinCheckButton{obj=gChild}
						for _, ggChild in _G.ipairs{gChild:GetChildren()} do
							if aObj:isDropDown(ggChild) then
								aObj:skinObject("dropdown", {obj=ggChild, x1=16, y2=-1})
							end
						end
					elseif gChild:IsObjectType("Button")
					and aObj.modBtns
					then
						cW, cH = _G.Round(gChild:GetWidth()), _G.Round(gChild:GetHeight())
						-- aObj:Debug("skinSubPanels Button: [%s, %s]", cW, cH)
						-- handle expand button (Spell/Skill Cooldowns)
						if cW == 15
						and cH == 15
						then
							gChild:SetSize(8, 8)
							aObj:skinExpandButton{obj=gChild}
							aObj:checkTex(gChild)
						else
							-- increase high of short, narrow buttons
							if cH <= 16 then
								gChild:SetHeight(20)
							end
							if cW == 25 then -- handle Note buttons
								gChild:SetWidth(28)
							end
							aObj:skinStdButton{obj=gChild, ofs=0, x1=4, x2=-4}
						end
					elseif gChild:IsObjectType("EditBox") then
						aObj:skinObject("editbox", {obj=gChild})
					elseif gChild:IsObjectType("Slider") then
						aObj:removeBackdrop(gChild)
						aObj:skinObject("slider", {obj=gChild})
					end
				end
			end
		end
	end

	-- hook this to skin AddOn sub panels
	self:SecureHook(_G.DBM_GUI_OptionsFrame, "DisplayFrame", function(_, frame)
		skinSubPanels(frame)
	end)

	-- hook this to skin BossMod sub panels button in TRHC
	self:SecureHook(_G.DBM_GUI, "CreateBossModPanel", function(_, mod)
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
	end
	self:SecureHook(_G.DBM_GUI, "CreateExportProfile", function(_, _)
		if skinPopupFrame then
			skinPopupFrame()
		end

		self:Unhook(_G.DBM_GUI, "CreateExportProfile")
	end)
	self:SecureHook(_G.DBM_GUI, "CreateImportProfile", function(_, _)
		if skinPopupFrame then
			skinPopupFrame()
		end

		self:Unhook(_G.DBM_GUI, "CreateImportProfile")
	end)

end
