local _, aObj = ...
if not aObj:isAddonEnabled("DBM-Core") then return end
local _G = _G
-- luacheck: ignore 631 (line is too long)

aObj.addonsToSkin["DBM-Core"] = function(self) -- v 10.2.19/3.4.56

	-- hook this to skin the InfoFrame frame
	self:SecureHook(_G.DBM.InfoFrame, "Show", function(_, _, event, _)
		if _G.DBM.Options.DontShowInfoFrame and not (event or ""):find("test") then
			return
		end
		self:skinObject("frame", {obj=_G.DBMInfoFrame})

		self:Unhook(_G.DBM.InfoFrame, "Show")
	end)

	-- hook this to skin UpdateReminder frame
	self:SecureHook(_G.DBM, "ShowUpdateReminder", function(_, _)
		self:skinObject("editbox", {obj=self:getChild(_G.DBMUpdateReminder, 1), y1=-4, y2=4})
		self:skinObject("frame", {obj=_G.DBMUpdateReminder, ofs=-2})
		if self.modBtns then
			self:skinStdButton{obj=self:getChild(_G.DBMUpdateReminder, 2)}
		end

		self:Unhook(_G.DBM, "ShowUpdateReminder")
	end)

	-- hook this to skin DBMNotesEditor frame
	self:SecureHook(_G.DBM, "ShowNoteEditor", function(this, _)
		self:skinObject("editbox", {obj=self:getChild(_G.DBMNotesEditor, 1), y1=-4, y2=4})
		self:skinObject("frame", {obj=_G.DBMNotesEditor, ofs=-2})
		if self.modBtns then
			self:skinStdButton{obj=self:getChild(_G.DBMNotesEditor, 2)}
			self:skinStdButton{obj=self:getChild(_G.DBMNotesEditor, 3)}
			self:skinStdButton{obj=self:getChild(_G.DBMNotesEditor, 4)}
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

end

aObj.lodAddons["DBM-GUI"] = function(self) -- v 10.2.19/3.4.56

	--	Options Frame
	self:SecureHookScript(_G.DBM_GUI_OptionsFrame, "OnShow", function(this)
		local frameWrapper = self:getLastChild(this)
		self:skinObject("frame", {obj=frameWrapper, kfs=true, fb=true, x2=4})
		self:skinObject("slider", {obj=_G.DBM_GUI_OptionsFrameList.ScrollBar})
		self:skinObject("frame", {obj=_G.DBM_GUI_OptionsFrameList, kfs=true, fb=true})
		self:removeBackdrop(self:getChild(_G.DBM_GUI_OptionsFramePanelContainerFOV.ScrollBar, 3))
		self:skinObject("slider", {obj=_G.DBM_GUI_OptionsFramePanelContainerFOV.ScrollBar})
		self:skinObject("frame", {obj=_G.DBM_GUI_OptionsFramePanelContainer, kfs=true, fb=true})
		if self.isRtl then
			_G.Spew("", _G.DBM_GUI.tabs)
			self:skinObject("tabs", {obj=this, prefix=this:GetName(), ignoreSize=true, ignoreHLTex=true, lod=self.isTT and true, upwards=true, offsets = {x1=8, y1=-3, x2=-8, y2=-3}})
		else
			self:skinObject("tabs", {obj=this, tabs=this.tabsGroup.buttons, ignoreSize=true, ignoreHLTex=true, lod=self.isTT and true, upwards=true, offsets = {x1=0, y1=-8, x2=0, y2=-3}, regions={4}, track=false})
			if self.isTT then
				self:SecureHook(this, "ShowTab", function(_, tabNo)
					for idx, btn in _G.ipairs(this.tabsGroup.buttons) do
						if tabNo == idx then
							self:setActiveTab(btn.sf)
						else
							self:setInactiveTab(btn.sf)
						end
					end
				end)
			end
		end
		self:skinObject("frame", {obj=this, kfs=true, hdr=true, y2=0})
		if self.modBtns then
			if self.isClsc then
				self:skinCloseButton{obj=_G.DBM_GUI_OptionsFrameClosePanelButton}
			end
			self:skinStdButton{obj=_G.DBM_GUI_OptionsFrameOkay}
			self:skinStdButton{obj=_G.DBM_GUI_OptionsFrameWebsiteButton}
			-- skin the Bosses LoadAddOn buttons
			for _, addon in _G.ipairs(_G.DBM.AddOns) do
				if addon.panel.frame:GetNumChildren() == 2 then
					self:skinStdButton{obj=self:getChild(addon.panel.frame, 1)}
				end
			end
		end

		self:Unhook(this, "OnShow")
	end)

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

	self:SecureHookScript(_G.DBM_GUI_DropDown, "OnShow", function(this)
		self:skinObject("slider", {obj=_G.DBM_GUI_DropDownListScrollBar, x1=6, x2=-6})
		self:skinObject("frame", {obj=_G.DBM_GUI_DropDown, kfs=true})

		self:Unhook(this, "OnShow")
	end)

	-- skin dropdown menu
	local oW, oH, btn
	local function skinSubPanels(frame)
		for _, child in _G.ipairs{frame:GetChildren()} do
			if not child.sknd then
				child.sknd = true
				-- "line" ?
				if child.mytype == "area"
				or child.mytype == "ability"
				then
					aObj:skinObject("skin", {obj=child, bd=10, ng=true}) -- frame border
					for _, gChild in _G.ipairs{child:GetChildren()} do
						oW, oH = _G.Round(gChild:GetWidth()), _G.Round(gChild:GetHeight())
						if gChild.mytype == "checkbutton" then
							if aObj.modChkBtns then
								aObj:skinCheckButton{obj=gChild}
							end
							for _, ggChild in _G.ipairs{gChild:GetChildren()} do
								if ggChild.mytype == "dropdown" then
									aObj:skinObject("dropdown", {obj=ggChild, x2=oW==26 and 34, y2=oH==26 and 0})
								end
							end
						elseif gChild.mytype == "button"
						and aObj.modBtns
						then
							-- handle expand button (Spell/Skill Cooldowns)
							if oW == 15
							and oH == 15
							then
								gChild:SetSize(8, 8)
								aObj:skinExpandButton{obj=gChild}
								aObj:checkTex(gChild)
							else
								-- increase high of short, narrow buttons
								if oH <= 16 then
									gChild:SetHeight(20)
								end
								if oW == 25 then -- handle Note buttons
									gChild:SetWidth(28)
								end
								aObj:skinStdButton{obj=gChild, ofs=0, x1=4, x2=-4}
							end
						elseif gChild:IsObjectType("EditBox") then
							aObj:skinObject("editbox", {obj=gChild})
						elseif gChild:IsObjectType("Slider") then
							aObj:removeBackdrop(gChild)
							aObj:skinObject("slider", {obj=gChild})
						elseif gChild.mytype == "dropdown" then
							aObj:skinObject("dropdown", {obj=gChild, x2=gChild.width and 34 or nil})
						elseif child.mytype == "ability" then
							btn = aObj:getChild(child, 2)
							btn.toggle:SetSize(8, 8)
							aObj:skinExpandButton{obj=btn.toggle}
							aObj:checkTex(btn.toggle)
						end
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

	local pfSkinned = false
	for _, method in pairs{"CreateImportProfile", "CreateExportProfile"} do
		self:SecureHook(_G.DBM_GUI, method, function(_, _)
			if not pfSkinned then
				local pFrame = aObj:getLastChild(_G.UIParent)
				aObj:removeBackdrop(aObj:getChild(pFrame, 1))
				aObj:skinObject("slider", {obj=aObj:getChild(pFrame, 2).ScrollBar})
				aObj:skinObject("frame", {obj=pFrame, ofs=0})
				if aObj.modBtns then
					aObj:skinStdButton{obj=aObj:getChild(pFrame, 3)} -- Import
					aObj:skinStdButton{obj=aObj:getChild(pFrame, 4)} -- Close
				end
				pfSkinned = true
			end

			self:Unhook(_G.DBM_GUI, method)
		end)
	end

end
