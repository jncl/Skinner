local _, aObj = ...
if not aObj:isAddonEnabled("VuhDo") then return end
local _G = _G

aObj.addonsToSkin.VuhDo = function(self) -- v 3.119

	-- N.B. NOT a real Tooltip
	self:skinObject("frame", {obj=_G.VuhDoTooltip, ofs=0})
	self:skinObject("frame", {obj=_G.VuhDoBuffWatchMainFrame, kfs=true})

	-- change panel options
	local opt
	for i = 1, 10 do
		opt = _G.VUHDO_PANEL_SETUP[i].PANEL_COLOR.BACK
		opt.R, opt.G, opt.B, opt.O = self.bClr:GetRGBA()
		opt.useOpacity = true
		opt.useBackground = true
		opt = _G.VUHDO_PANEL_SETUP[i].PANEL_COLOR.BORDER
		opt.R, opt.G, opt.B, opt.O = self.bbClr:GetRGBA()
		opt.edgeSize = self.Backdrop[1].edgeSize
		opt.insets = self.Backdrop[1].insets.left
		opt.file = self.Backdrop[1].edgeFile
		opt.useOpacity = true
		opt.useBackground = true
		_G.VUHDO_PANEL_SETUP[i].PANEL_COLOR.barTexture = self.db.profile.StatusBar.texture
		-- redraw panel
		_G.VUHDO_redrawPanel(i)
		-- add Gradient
		self:applyGradient(_G.VUHDO_getOrCreateActionPanel(i))
	end
	opt = nil

end

aObj.addonsToSkin.VuhDoOptions = function(self) -- v 3.119

	local function skinObject(obj, type, x2Ofs)
		local objName = obj:GetName()
		if type == "dropdown"
		or type == "dropdown2"
		or type == "dropdown3" -- dropdown with editbox
		then
			obj:SetHeight(32)
			local btnName = objName .. "Button"
			_G[btnName]:SetNormalTexture([[Interface\ChatFrame\UI-ChatIcon-ScrollDown-Up]])
			_G[btnName]:SetPushedTexture([[Interface\ChatFrame\UI-ChatIcon-ScrollDown-Down]])
			aObj:moveObject{obj=_G[btnName], y=3}
			_G[btnName]:SetSize(24, 24)
			btnName = nil
			if type == "dropdown" then
				aObj:skinObject("dropdown", {obj=obj, x1=0, x2=0})
			else
				_G[objName .. "Left"]:ClearAllPoints()
				_G[objName .. "Left"]:SetPoint("LEFT", obj, "LEFT")
				aObj:skinObject("dropdown", {obj=obj, x1=0, x2=x2Ofs})
				aObj:moveObject{obj=obj, y=18}
				if type == "dropdown3" then
					local eB = _G[objName .. "EditBox"]
					skinObject(eB, "editbox")
					eB:SetHeight(18)
					aObj:moveObject{obj=eB, y=-26}
					eB = nil
				end
			end
		elseif type == "slider" then
			if obj:GetObjectType() == "Frame" then
				objName = objName .. "Slider"
			end
			aObj:removeBackdrop(_G[objName])
			_G[objName .. "Thumb"]:SetTexture([[Interface\Buttons\UI-ScrollBar-Knob]])
			_G[objName .. "Thumb"]:SetSize(24, 24)
			aObj:skinObject("slider", {obj=_G[objName], x1=1})
		elseif type == "slider2" then
			objName = objName .. "ScrollBar"
			aObj:removeBackdrop(_G[objName])
			_G[objName .. "ThumbTexture"]:SetTexture([[Interface\Buttons\UI-ScrollBar-Knob]])
			_G[objName .. "ThumbTexture"]:SetSize(24, 24)
			aObj:skinObject("slider", {obj=_G[objName], x1=1, x2=-2})
		elseif type == "editbox" then
			if _G.Round(obj:GetHeight()) == 32 then
				aObj:moveObject{obj=obj, y=-6}
			end
			obj:SetHeight(20)
			if obj:GetNumRegions() == 6 then
				aObj:skinObject("editbox", {obj=obj, ofs=2})
			else
				aObj:skinObject("editbox", {obj=obj, regions={}, ofs=2})
			end
		elseif type == "button"
		or type == "button2"
		then
			if obj:GetNormalTexture() then -- handle CheckBox/RadioBox CheckButtons
				obj:GetNormalTexture():SetTexture(nil)
				obj:GetPushedTexture():SetTexture(nil)
				-- use module to skin buttons so they are visible
				aObj.modUIBtns:skinStdButton{obj=obj, name=type == "button2" and true, ofs=1}
			end
		end
		objName = nil
	end
	local function skinSubFrames(frame)
		local cName, cW, noFB, ofs, x1Ofs, x2Ofs
		for _, child in _G.ipairs{frame:GetChildren()} do
			cName = child:GetName()
			if cName:find("~sf~$")
			or cName:find("~sb~$")
			then
				-- ignore it
			elseif cName:find("RadioPanel") then
				if cName:find("RadioButton$") then
					skinObject(child, "button")
				else
					if child:GetNumChildren() > 0 then
						skinSubFrames(child)
					end
				end
			else
				cW = _G.Round(child:GetWidth())
				if cName:find("Button$")
				or cName:find("Button%d+$")
				then
					if cName:find("DetailsPanelUp") then
						child:GetNormalTexture():SetTexture([[Interface\Buttons\UI-MicroStream-Yellow]])
						child:GetNormalTexture():SetRotation(3.14)
					elseif cName:find("DetailsPanelDown") then
						child:GetNormalTexture():SetTexture([[Interface\Buttons\UI-MicroStream-Yellow]])
					else
						skinObject(child, "button2")
					end
				elseif cName:find("IgnoreComboBox$") then -- EditComboBox
					skinObject(child, "dropdown3", 20)
				elseif cName:find("SelectComboBox$")
				and child:GetAttribute("derive_custom") -- HotSlotContainer ComboBox
				then
					skinObject(child, "dropdown3", -17)
				elseif cName:find("ComboBox$") then
					if child.isScrollable == false
					or cW == 150
					then
						skinObject(child, "dropdown")
					else
						skinObject(child, "dropdown2", 150 - cW)
					end
				elseif cName:find("SoundCombo$") -- Debuff Tab StandardPanel
				or cName:find("SortCombo$") -- Panels Tab GeneralPanel
				or cName:find("BackgroundPanelTextureCombo$") -- Panels Tab GeneralPanel
				or cName:find("FontCombo$") -- Panels Tab HeadersPanel/TextPanel
				or cName:find("IconCombo$") -- Panels Tab MiscPanel
				or cName:find("TextIndicatorCombo$") -- Panels Tab MiscPanel
				or cName:find("LayoutCombo$") -- Tools Tab KeyLayoutsPanel
				then
					skinObject(child, "dropdown")
				elseif cName:find("Combo$") then -- MorePanel
					skinObject(child, "dropdown2", -50)
				elseif cName:find("Slider$") then
					skinObject(child, "slider")
				elseif cName:find("ScrollFrame$") then
					ofs, x1Ofs, x2Ofs = 0, -3, nil
					if cName:find("ExportFrame")
					or aObj:hasTextInName(child, "ImportFrame")
					then
						ofs, x1Ofs, x2Ofs = 6, nil, 2
					end
					aObj:skinObject("frame", {obj=child, kfs=true, ofs=ofs, x1=x1Ofs, x2=x2Ofs})
					skinObject(child, "slider2")
				elseif cName:find("ScrollPanel$") then
					aObj:removeBackdrop(child)
					skinObject(child, "slider2")
					if child:GetScrollChild():GetNumChildren() > 0 then
						skinSubFrames(child:GetScrollChild())
					end
				elseif cName:find("EditBox$")
				or cName:find("EditBox%d+$")
				then
					skinObject(child, "editbox")
				elseif child:IsObjectType("Frame") then
					-- N.B. give the skinFrame a name otherwise an error occurs when using dropdowns
					if child.backdropInfo then
						if cName:find("MorePanel$")
						or cName:find("ExportFrame$")
						or cName:find("ImportFrame$")
						then
							noFB = true
						end
						aObj:skinObject("frame", {obj=child, kfs=true, name=true, fb=not noFB, ofs=0})
					end
					if child:GetNumChildren() > 0 then
						skinSubFrames(child)
					end
				end
			end
		end
		cName, cW, noFB, ofs, x1Ofs, x2Ofs = nil, nil, nil, nil, nil, nil
	end
	-- hook this to skin ComboBox panels & items
	self:SecureHook("VUHDO_lnfComboBoxInitFromModel", function(aComboBox)
		local ddBox, panel
		if aComboBox.isScrollable then
			ddBox = aComboBox:GetName() .. "ScrollPanel"
			skinObject(_G[ddBox], "slider2")
			panel = aComboBox:GetName() .. "ScrollPanelSelectPanel"
		else
			ddBox = aComboBox:GetName() .. "SelectPanel"
			panel = aComboBox:GetName() .. "SelectPanel"
		end
		self:skinObject("frame", {obj=_G[ddBox], kfs=true, y1=5, y2=-5})
		if aComboBox:GetAttribute("combo_table") then
			for idx, _ in _G.ipairs(aComboBox:GetAttribute("combo_table")) do
				if _G[panel .. "Item" .. idx] then
					self:removeBackdrop(_G[panel .. "Item" .. idx])
				end
			end
		end
		ddBox, panel = nil, nil
	end)
	-- hook this to skin Indicators panel contents
	self:SecureHook("VUHDO_newOptionsIndicatorsBuildScrollChild", function(aScrollChild)
		skinSubFrames(aScrollChild)

		self:Unhook("VUHDO_newOptionsIndicatorsBuildScrollChild")
	end)
	-- hook this to skin AoE Advice Items
	self:SecureHook("VUHDO_newOptionsAoeAdvicePopulate", function(aParent)
		local iName
		for idx, item in _G.ipairs{aParent:GetChildren()} do
			if idx ~= 1 then -- ignore GeneralPanel
				self:skinObject("frame", {obj=item, kfs=true, fb=true, ofs=0})
				iName = item:GetName()
				skinObject(_G[iName .. "HealedSlider"], "slider")
				skinObject(_G[iName .. "EnableCheckButton"], "button")
			end
		end
		iName = nil

		self:Unhook("VUHDO_newOptionsAoeAdvicePopulate")
	end)
	-- hook this to skin Bouquet items
	local tParent
	self:SecureHook("VUHDO_rebuildAllBouquetItems", function(aParent, _)
		if aParent ~= nil then
			tParent = aParent
		elseif tParent == nil then
			return
		end
		for _, child in _G.ipairs{tParent:GetChildren()} do
			self:skinObject("frame", {obj=child, kfs=true, fb=true, ofs=0, y1=1, y2=-1})
		end
	end)
	-- hook this to skin keyboardMacros
	self:SecureHook("VUHDO_keyboardlocalSpellsScrollPanelOnShow", function(aScrollPanel)
		local cName
		for _, child in _G.ipairs{aScrollPanel:GetChildren()} do
			self:skinObject("frame", {obj=child, kfs=true, fb=true, ofs=0})
			cName = child:GetName()
			skinObject(_G[cName .. "EditBox"], "editbox")
			skinObject(_G[cName .. "EditButton"], "button")
			skinObject(_G[cName .. "Assignment1Button"], "button")
		end
		cName = nil
	end)
	-- hook this to skin Buffs General Panel
	self:SecureHook("VUHDO_buildAllBuffSetupGenerericPanel", function()
		local cName
		for _, child in _G.ipairs{_G.VuhDoNewOptionsBuffsGeneric:GetChildren()} do
			self:skinObject("frame", {obj=child, kfs=true, fb=true, ofs=1})
			cName = child:GetName()
			if _G[cName .. "GenericPanel"] then
				for _, kid in _G.ipairs{_G[cName .. "GenericPanel"]:GetChildren()} do
					if self:hasTextInNameRE(kid, "ComboBox$") then
						skinObject(kid, "dropdown")
					elseif self:hasTextInNameRE(kid, "EditBox$") then
						skinObject(kid, "editbox")
					end
				end
			end
			skinObject(_G[cName .. "UpButton"], "button2")
			skinObject(_G[cName .. "DownButton"], "button2")
		end
		cName = nil

		self:Unhook("VUHDO_buildAllBuffSetupGenerericPanel")
	end)

	-- This is the Main Options Frame
	self:SecureHookScript(_G.VuhDoNewOptionsTabbedFrame, "OnShow", function(this)
		self:removeBackdrop(_G.VuhDoNewOptionsTabbedFrameOkayCancelPanel)
		skinSubFrames(_G.VuhDoNewOptionsTabbedFrameContentPanel)
		local tpName = this:GetName() .. "TabsPanel"
		_G[tpName].Tabs = {}
		for _, name in _G.pairs{"General", "Colors", "Tools", "Move", "Spells", "Panels", "Buffs", "Debuffs"} do
			self:add2Table(_G[tpName].Tabs, _G[tpName .. name .. "RadioButton"])
			_G[tpName .. name .. "RadioButtonTextureCheckMarkTexture"]:SetTexture(nil)
			_G[tpName .. name .. "RadioButton"]:SetSize(46, 46)
			_G.VUHDO_lnfTabCheckButtonOnEnter(_G[tpName .. name .. "RadioButton"])
		end
		self:skinObject("tabs", {obj=_G[tpName], tabs=_G[tpName].Tabs, ignoreSize=true, lod=true, regions={1, 3}, offsets={x1=-3, y1=-19, x2=3, y2=5}, track=false, func=aObj.isTT and function(tab)
			aObj:SecureHookScript(tab, "OnClick", function(this)
				for _, tab in _G.pairs(this:GetParent().Tabs) do
					if tab == this then
						aObj:setActiveTab(tab.sf)
					else
						aObj:setInactiveTab(tab.sf)
					end
				end
			end)
		end})
		tpname = nil
		self:skinObject("frame", {obj=this, kfs=true, y1=20, y2=-25})
		skinObject(_G.VuhDoNewOptionsTabbedFrameOkayCancelPanelOkayButton, "button")
		skinObject(_G.VuhDoNewOptionsTabbedFrameOkayCancelPanelCancelButton, "button")
		skinObject(_G.VuhDoNewOptionsGeneralBouquetBackButton, "button")

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.VuhDoNewOptionsScaleSlider, "OnShow", function(this)
		skinObject(this, "slider")

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.VuhDoLnfShareDialog, "OnShow", function(this)
		self:removeBackdrop(_G.VuhDoLnfShareDialogRootPane)
		skinObject(_G.VuhDoLnfShareDialogRootPaneBuddyCombo, "dropdown3", -30)
		self:removeBackdrop(_G.VuhDoLnfShareDialogTransmitPane)
		_G.VuhDoLnfShareDialogTransmitPaneProgressBar:SetStatusBarTexture(self.sbTexture)
		self:skinObject("frame", {obj=this, kfs=true})
		skinObject(_G.VuhDoLnfShareDialogRootPaneOkayButton, "button")
		skinObject(_G.VuhDoLnfShareDialogRootPaneCancelButton, "button")
		skinObject(_G.VuhDoLnfShareDialogTransmitPaneCancelButton, "button")

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.VuhDoNewColorPicker, "OnShow", function(this)
		skinObject(_G.VuhDoColorPickerColorCodeEditBox, "editbox")
		skinObject(_G.VuhDoNewColorPickerOpacitySliderFrameSlider, "slider")
		self:skinObject("frame", {obj=this})
		skinObject(_G.VuhDoNewColorPickerTextRadioButton, "button")
		skinObject(_G.VuhDoNewColorPickerBackgroundRadioButton, "button")
		skinObject(_G.VuhDoNewColorPickerOkayButton, "button")
		skinObject(_G.VuhDoNewColorPickerCancelButton, "button")
		skinObject(_G.VuhDoNewColorPickerCopyButton, "button")
		skinObject(_G.VuhDoNewColorPickerPasteButton, "button")

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.VuhDoLnfIconTextDialog, "OnShow", function(this)
		local panel = this:GetName() .. "RootPane"
		self:removeBackdrop(_G[panel])
		skinObject(_G[panel .. "XAdjustSlider"], "slider")
		skinObject(_G[panel .. "YAdjustSlider"], "slider")
		skinObject(_G[panel .. "ScaleSlider"], "slider")
		skinObject(_G[panel .. "FontCombo"], "dropdown")
		skinObject(_G[panel .. "ShadowCheckButton"], "button")
		skinObject(_G[panel .. "OutlineCheckButton"], "button")
		skinObject(_G[panel .. "MonoCheckButton"], "button")
		skinObject(_G[panel .. "OkayButton"], "button")
		self:skinObject("frame", {obj=this, kfs=true})
		panel = nil

		self:Unhook(this, "OnShow")
	end)

	-- N.B. NOT a real Tooltip
	self:skinObject("frame", {obj=_G.VuhDoOptionsTooltip})

	self:SecureHookScript(_G.VuhDoYesNoFrame, "OnShow", function(this)
		self:skinObject("frame", {obj=this, kfs=true, x1=10, y1=-12, x2=-5, y2=26})
		if self.modBtns then
			self:skinStdButton{obj=_G.VuhDoYesNoFrameYesButton}
			self:skinStdButton{obj=_G.VuhDoYesNoFrameNoButton}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.VuhDoThreeSelectFrame, "OnShow", function(this)
		self:skinObject("frame", {obj=this, kfs=true, ofs=-11, x2=-5, y2=3})
		if self.modBtns then
			self:skinStdButton{obj=_G.VuhDoThreeSelectFrameButton1}
			self:skinStdButton{obj=_G.VuhDoThreeSelectFrameButton2}
			self:skinStdButton{obj=_G.VuhDoThreeSelectFrameButton3}
		end

		self:Unhook(this, "OnShow")
	end)

end
