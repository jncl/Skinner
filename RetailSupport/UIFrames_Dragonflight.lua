local _, aObj = ...

local _G = _G

aObj.SetupDragonflight_UIFrames = function()
	local ftype = "u"

	aObj.blizzFrames[ftype].EditMode = function(self)
		if not self.prdb.EditMode or self.initialized.EditMode then return end
		self.initialized.EditMode = true

		self:SecureHookScript(_G.EditModeManagerFrame, "OnShow", function(this)
			self:removeNineSlice(this.Border)
			this.Tutorial.Ring:SetTexture(nil)
			self:skinObject("dropdown", {obj=this.LayoutDropdown.DropDownMenu, fType=ftype})
			self:skinObject("slider", {obj=this.GridSpacingSlider.Slider.Slider, fType=ftype, y1=-8, y2=8})
			this.AccountSettings.Expander.Divider:SetTexture(nil)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true})
			if self.modBtns then
				self:skinStdButton{obj=this.SaveChangesButton, fType=ftype, sechk=true}
				self:skinStdButton{obj=this.RevertAllChangesButton, fType=ftype, sechk=true}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=this.ShowGridCheckButton.Button, fType=ftype}
				local checkButtons = {"TargetAndFocus", "PartyFrames", "RaidFrames", "StanceBar", "PetActionBar", "CastBar", "EncounterBar", "ExtraAbilities", "PossessActionBar", "BuffFrame", "DebuffFrame", "TalkingHeadFrame", "VehicleLeaveButton", "BossFrames", "ArenaFrames", "LootFrame", "HudTooltip"}
				for _, cBtn in _G.pairs(checkButtons) do
					self:skinCheckButton{obj=this.AccountSettings.Settings[cBtn].Button, fType=ftype}
				end
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.EditModeNewLayoutDialog, "OnShow", function(fObj)
			self:removeNineSlice(fObj.Border)
			self:skinObject("editbox", {obj=fObj.LayoutNameEditBox, fType=ftype, y1=-4, y2=4})
			self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, ofs=-6})
			if self.modBtns then
				self:skinStdButton{obj=fObj.AcceptButton, fType=ftype, schk=true}
				self:skinStdButton{obj=fObj.CancelButton, fType=ftype}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=fObj.CharacterSpecificLayoutCheckButton.Button, fType=ftype}
			end

			self:Unhook(fObj, "OnShow")
		end)

		self:SecureHookScript(_G.EditModeImportLayoutDialog, "OnShow", function(fObj)
			self:removeNineSlice(fObj.Border)
			self:skinObject("frame", {obj=fObj.ImportBox, fType=ftype, kfs=true, fb=true, ofs=6})
			self:skinObject("editbox", {obj=fObj.LayoutNameEditBox, fType=ftype, y1=-4, y2=4})
			self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, ofs=-6})
			if self.modBtns then
				self:skinStdButton{obj=fObj.AcceptButton, fType=ftype, sechk=true}
				self:skinStdButton{obj=fObj.CancelButton, fType=ftype}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=fObj.CharacterSpecificLayoutCheckButton.Button, fType=ftype}
			end

			self:Unhook(fObj, "OnShow")
		end)

		self:SecureHookScript(_G.EditModeImportLayoutLinkDialog, "OnShow", function(fObj)
			self:removeNineSlice(fObj.Border)
			self:skinObject("editbox", {obj=fObj.LayoutNameEditBox, fType=ftype, y1=-4, y2=4})
			self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, ofs=-6})
			if self.modBtns then
				self:skinStdButton{obj=fObj.AcceptButton, fType=ftype, sechk=true}
				self:skinStdButton{obj=fObj.CancelButton, fType=ftype}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=fObj.CharacterSpecificLayoutCheckButton.Button, fType=ftype}
			end

			self:Unhook(fObj, "OnShow")
		end)

		self:SecureHookScript(_G.EditModeUnsavedChangesDialog, "OnShow", function(fObj)
			self:removeNineSlice(fObj.Border)
			self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, ofs=-6})
			if self.modBtns then
				self:skinStdButton{obj=fObj.SaveAndProceedButton, fType=ftype}
				self:skinStdButton{obj=fObj.ProceedButton, fType=ftype}
				self:skinStdButton{obj=fObj.CancelButton, fType=ftype}
			end

			self:Unhook(fObj, "OnShow")
		end)

		self:SecureHookScript(_G.EditModeSystemSettingsDialog, "OnShow", function(fObj)
			local function skinSettingsAndButtons(frame)
				for dropdown in frame.pools:EnumerateActiveByTemplate("EditModeSettingDropdownTemplate") do
					aObj:skinObject("dropdown", {obj=dropdown.Dropdown.DropDownMenu, fType=ftype})
				end
				for slider in frame.pools:EnumerateActiveByTemplate("EditModeSettingSliderTemplate") do
					aObj:skinObject("slider", {obj=slider.Slider.Slider, fType=ftype, y1=-8, y2=8})
				end
				if aObj.modChkBtns then
					for checkbox in frame.pools:EnumerateActiveByTemplate("EditModeSettingCheckboxTemplate") do
						aObj:skinCheckButton{obj=checkbox.Button, fType=ftype}
					end
				end
				if aObj.modBtns then
					for button in frame.pools:EnumerateActiveByTemplate("EditModeSystemSettingsDialogExtraButtonTemplate") do
						aObj:skinStdButton{obj=button, fType=ftype, schk=true}
					end
				end
			end
			self:removeNineSlice(fObj.Border)
			self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, cb=true, y2=14})
			if self.modBtns then
				self:skinStdButton{obj=fObj.Buttons.RevertChangesButton, fType=ftype, sechk=true}
			end
			skinSettingsAndButtons(fObj)
			self:SecureHook(fObj, "UpdateDialog", function(frame, systemFrame)
				skinSettingsAndButtons(frame)
			end)

			self:Unhook(fObj, "OnShow")
		end)

	end

	aObj.blizzLoDFrames[ftype].ExpansionLandingPage = function(self)
		if not self.prdb.ExpansionLandingPage or self.initialized.ExpansionLandingPage then return end
		self.initialized.ExpansionLandingPage = true

		local function skinFactionBtns(list)
			list.ScrollBox.view:ForEachFrame(function(fObj, _)
				fObj.LockedState:DisableDrawLayer("BACKGROUND")
				fObj.UnlockedState:DisableDrawLayer("BACKGROUND")
				-- FIXME: colour should be more of a powder blue
				aObj:skinObject("frame", {obj=fObj, fType=ftype, fb=true, x1=28, x2=-29, y2=0, clr="blue"})
				if aObj.modChkBtns then
					aObj:skinCheckButton{obj=fObj.UnlockedState.WatchFactionButton, fType=ftype}
					fObj.UnlockedState.WatchFactionButton:SetSize(20, 20)
				end
			end)
		end
		local function skinOverlay(overlay)
			local oFrame = aObj:getChild(overlay, 1)
			oFrame.Header.TitleDivider:SetTexture(nil)
			aObj:skinObject("scrollbar", {obj=oFrame.MajorFactionList.ScrollBar, fType=ftype})
			skinFactionBtns(oFrame.MajorFactionList)
			aObj:SecureHook(oFrame.MajorFactionList, "Refresh", function(lObj)
				skinFactionBtns(lObj)
			end)
			-- N.B. keep background visible
			aObj:skinObject("frame", {obj=oFrame.DragonridingPanel, fType=ftype, fb=true, y1=-2, x2=-2, y2=11, clr="grey"})
			aObj:skinObject("frame", {obj=oFrame, fType=ftype, kfs=true, rns=true, cb=true, clr="gold_df"})
			if aObj.modBtns then
				aObj:skinStdButton{obj=oFrame.DragonridingPanel.SkillsButton, fType=ftype}
			end
		end
		_G.EventRegistry:RegisterCallback("ExpansionLandingPage.OverlayChanged", skinOverlay, aObj)

		self:SecureHookScript(_G.ExpansionLandingPage, "OnShow", function(this)
			-- FIXME: Blizzard bug uses self.Overlay instead of self.overlay 01.10.22
			skinOverlay(this.Overlay or this.overlay)

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].MainMenuBarCommon = function(self)
		if self.initialized.MainMenuBarCommon then return end
		self.initialized.MainMenuBarCommon = true

		if _G.IsAddOnLoaded("Bartender4") then
			return
		end

		if self.prdb.MainMenuBar.skin then
			local function skinActionBtns(frame)
				if self.modBtnBs then
					for _, btn in _G.pairs(frame.actionButtons) do
						btn.SlotBackground:SetTexture(nil)
						btn.SlotArt:SetTexture(nil)
						btn.Border:SetTexture(nil)
						aObj:addButtonBorder{obj=btn, abt=true, sft=true, reParent={btn.Name, btn.AutoCastable, btn.SpellHighlightTexture, btn.AutoCastShine}, ofs=3, clr="grey"}
					end
				end
			end
			for _, frame in _G.pairs{_G.StanceBar, _G.PetActionBar, _G.PossessActionBar} do
				self:SecureHookScript(frame, "OnShow", function(this)
					skinActionBtns(this)

					self:Unhook(this, "OnShow")
				end)
				self:checkShown(frame)
			end
		end

	end

	aObj.blizzLoDFrames[ftype].MajorFactions = function(self)
		if not self.prdb.MajorFactions or self.initialized.MajorFactions then return end
		self.initialized.MajorFactions = true

		-- MajorFactionToasts
		-- MajorFactionUnlockToast
		-- MajorFactionsRenownToast

		local function skinRewards(frame)
			for reward in frame.rewardsPool:EnumerateActive() do
				aObj:skinObject("frame", {obj=reward, fType=ftype, kfs=true, fb=true, ofs=-14, clr="sepia"})
				reward.Check:SetAlpha(1) -- make Checkmark visible
				reward.Icon:SetAlpha(1) -- make Icon visible
			end
		end
		self:SecureHookScript(_G.MajorFactionRenownFrame, "OnShow", function(this)
			this:DisableDrawLayer("BACKGROUND")
			this:DisableDrawLayer("BORDER")
			this:DisableDrawLayer("ARTWORK")
			this.NineSlice:DisableDrawLayer("ARTWORK")
			this.HeaderFrame.Background:SetAlpha(0) -- texture changed in code
			self:SecureHook(this, "SetRewards", function(fObj, _)
				skinRewards(fObj)
			end)
			skinRewards(this)
			this.TrackFrame.Glow:SetAlpha(0) -- texture changed in code
			self:skinObject("frame", {obj=this, fType=ftype, rns=true, cb=true, ofs=0, clr="gold_df"})
			if self.modBtns then
				-- .LevelSkipButton
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].QuickKeybind = function(self)
		if not self.prdb.BindingUI and not self.prdb.EditMode or self.initialized.QuickKeybind then return end
		self.initialized.QuickKeybind = true

		self:SecureHookScript(_G.QuickKeybindFrame, "OnShow", function(this)
			self:removeNineSlice(this.BG)
			this.BG.Bg:SetTexture(nil)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, hdr=true, ofs=0})
			if self.modBtns then
				self:skinStdButton{obj=this.DefaultsButton}
				self:skinStdButton{obj=this.CancelButton}
				self:skinStdButton{obj=this.OkayButton}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=this.UseCharacterBindingsButton}
			end

			self:Unhook(this, "OnShow")
		end)
		-- tooltip
		_G.C_Timer.After(0.1, function()
			self:add2Table(self.ttList, _G.QuickKeybindTooltip)
		end)

	end

	aObj.blizzFrames[ftype].Settings = function(self)
		if not self.prdb.Settings or self.initialized.Settings then return end
		self.initialized.Settings = true

		-- Create keybinding Categories table
		local bindingsCategories = {
			[_G.BINDING_HEADER_OTHER] = {},
		}
		for bindingIndex = 1, _G.GetNumBindings() do
			local _, cat, _, _ = _G.GetBinding(bindingIndex)
			if cat then
				cat = _G[cat] or cat
				if not bindingsCategories[cat] then
					bindingsCategories[cat] = {}
				end
			end
		end
		self:SecureHookScript(_G.SettingsPanel, "OnShow", function(this)
			this.Bg:DisableDrawLayer("BACKGROUND")
			this.NineSlice.Text:SetDrawLayer("ARTWORK")
			self:skinObject("tabs", {obj=this, tabs=this.tabsGroup.buttons, fType=ftype, ignoreSize=true, lod=self.isTT and true, upwards=true, regions={4}, offsets={x1=6, y1=-10, x2=-6, y2=-6}, track=false})
			if self.isTT then
				local function setTabState(_, btn, idx)
					for key, tab in _G.pairs(this.tabsGroup.buttons) do
						aObj:setInactiveTab(tab.sf)
						if key == idx then
							aObj:setActiveTab(tab.sf)
						end
					end
				end
				this.tabsGroup:RegisterCallback(_G.ButtonGroupBaseMixin.Event.Selected, setTabState, aObj)
			end
			self:skinObject("editbox", {obj=this.SearchBox, fType=ftype, si=true})
			-- this.CategoryList.ScrollBar [DON'T skin (MinimalScrollBar)]
			local function skinCategories(element)
				if element.Background then
					element.Background:SetTexture(nil)
				end
				-- Button
				if element.Toggle then
					if aObj.modBtnBs then
						if not element.Toggle.sb then
							aObj:skinExpandButton{obj=element.Toggle, fType=ftype, noddl=true, noHook=true, plus=true, ofs=0}
							aObj:SecureHook(element, "SetExpanded", function(bObj, expanded)
								if expanded then
									bObj.Toggle:SetText(aObj.modUIBtns.minus)
								else
									bObj.Toggle:SetText(aObj.modUIBtns.plus)
								end
							end)
						end
					end
				end
			end
			_G.ScrollUtil.AddInitializedFrameCallback(this.CategoryList.ScrollBox, skinCategories, aObj, true)
			self:skinObject("frame", {obj=this.CategoryList, fType=ftype, fb=true, y1=12})

			self:getRegion(this.Container.SettingsList.Header, 2):SetTexture(nil)
			-- this.Container.SettingsList.ScrollBar [DON'T skin (MinimalScrollBar)]
			local function skinButtonsTable(tbl)
				for _, btn in _G.pairs(tbl) do
					aObj:skinStdButton{obj=btn, fType=ftype}
				end
			end
			local function skinCommonElements(element)
				if aObj.modBtns then
					if element.Button then
						aObj:skinStdButton{obj=element.Button, fType=ftype}
					elseif element.Buttons then
						skinButtonsTable(element.Buttons)
					elseif element.OpenAccessButton then
						aObj:skinStdButton{obj=element.OpenAccessButton, fType=ftype}
					elseif element.PushToTalkKeybindButton then
						aObj:skinStdButton{obj=element.PushToTalkKeybindButton, fType=ftype}
					elseif element.ToggleTest then
						aObj:addButtonBorder{obj=element.ToggleTest, fType=ftype, clr="grey", ofs=1}
					elseif element.DropDown
					and element.DropDown.Button
					then
						aObj:skinStdButton{obj=element.DropDown.Button, fType=ftype, clr="grey", ignoreHLTex=true, x1=10, y1=-4, x2=-10, y2=4}
					end
				end
				if aObj.modChkBtns
				and element.CheckBox
				then
					aObj:skinCheckButton{obj=element.CheckBox, fType=ftype}
				end
				if aObj.modBtnBs
				and element.DropDown
				and element.DropDown.IncrementButton
				then
					aObj:addButtonBorder{obj=element.DropDown.IncrementButton, fType=ftype, clr="grey", ofs=-2, y1=-3}
					aObj:addButtonBorder{obj=element.DropDown.DecrementButton, fType=ftype, clr="grey", ofs=-2, y1=-3}
				end
				if element.DropDown
				and element.DropDown.Button
				and element.DropDown.Button.Popout
				then
					aObj:skinObject("frame", {obj=element.DropDown.Button.Popout.Border, fType=ftype, kfs=true, x1=7, y1=0, x2=-12, y2=20, clr="grey"})
				end
				if element.SliderWithSteppers then
					aObj:skinObject("slider", {obj=element.SliderWithSteppers.Slider, fType=ftype, y1=-12, y2=12})
				end
			end
			local function skinSettings(element)
				if element then
					local name = element:GetElementData().data.name
					if element.EvaluateVisibility then -- handle ExpandableSection(s)
						-- TODO: skin the .Button, needs to have a +/- character on RHS ??
						if name == "Advanced"
						or name == "Raid"
						then
							for _, control in _G.pairs(element.Controls) do
								skinCommonElements(control)
							end
						elseif bindingsCategories[name] then
							for btnTable in element.bindingsPool:EnumerateActive() do
								skinButtonsTable(btnTable.Buttons)
							end
						end
					else
						skinCommonElements(element)
					end
					if element.VUMeter then
						aObj:skinObject("frame", {obj=element.VUMeter, fType=ftype, kfs=true, rns=true, fb=true, clr="grey"})
					end
				end
			end
			_G.ScrollUtil.AddInitializedFrameCallback(this.Container.SettingsList.ScrollBox, skinSettings, aObj, true)
			self:skinObject("frame", {obj=this.Container, fType=ftype, fb=true, y1=12})
			-- .InputBlocker
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, rns=true})
			if self.modBtns then
				self:skinCloseButton{obj=this.ClosePanelButton, fType=ftype}
				self:skinStdButton{obj=this.Container.SettingsList.Header.DefaultsButton, fType=ftype}
				self:skinStdButton{obj=this.CloseButton, fType=ftype}
				self:skinStdButton{obj=this.ApplyButton, fType=ftype, sechk=true}
			end

			self:Unhook(this, "OnShow")
		end)

		-- tooltip
		_G.C_Timer.After(0.1, function()
			self:add2Table(self.ttList, _G.SettingsTooltip)
		end)

	end

	aObj.blizzFrames[ftype].Social = function(self)
		if not self.prdb.Social or self.initialized.Social then return end
		self.initialized.Social = true

		self:SecureHookScript(_G.SocialBrowserFrame, "OnShow", function(this)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, x2=-3})

			self:Unhook(this, "OnShow")
		end)

	end

end

aObj.SetupDragonflight_UIFramesOptions = function(self)

	local optTab = {
		["Edit Mode"]              = true,
		["Expansion Landing Page"] = true,
		["Major Factions"]         = {suff = "UI"},
		["Settings"]               = {desc = "Options"},
		["Social"]                 = {desc = "Twitter Login"},
	}
	self:setupFramesOptions(optTab, "UI")
	_G.wipe(optTab)

end