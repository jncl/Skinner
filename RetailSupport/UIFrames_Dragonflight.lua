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
				self:skinCheckButton{obj=this.EnableSnapCheckButton.Button, fType=ftype}
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
			self:removeNineSlice(fObj.Border)
			self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, cb=true, y2=14})
			if self.modBtns then
				self:skinStdButton{obj=fObj.Buttons.RevertChangesButton, fType=ftype, sechk=true}
			end
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
			skinSettingsAndButtons(fObj)
			self:SecureHook(fObj, "UpdateDialog", function(frame, _)
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
			aObj:skinObject("frame", {obj=oFrame.DragonridingPanel, fType=ftype, fb=true, y1=-1, x2=-1, y2=11, clr="grey"})
			aObj:skinObject("frame", {obj=oFrame, fType=ftype, kfs=true, rns=true, cbns=true, ofs=-4, y1=-11, clr="gold_df"})
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
			self:skinObject("frame", {obj=this, fType=ftype, rns=true, cbns=true, ofs=-2, y1=-7, clr="gold_df"})
			if self.modBtns then
				self:skinStdButton{obj=this.LevelSkipButton, fType=ftype, clr="gold"}
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
				local function setTabState(_, _, idx)
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
			local function skinCategory(element, _, new)
				if new ~= false then
					if element.Background then
						element.Background:SetTexture(nil)
					end
					-- Button
					if element.Toggle then
						if aObj.modBtnBs then
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
			_G.ScrollUtil.AddAcquiredFrameCallback(this.CategoryList.ScrollBox, skinCategory, aObj, true)
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
						aObj:skinStdButton{obj=element.Button, fType=ftype, sechk=true}
					elseif element.Buttons then
						skinButtonsTable(element.Buttons)
					elseif element.DropDown
					and element.DropDown.Button
					then
						aObj:skinStdButton{obj=element.DropDown.Button, fType=ftype, clr="grey", ignoreHLTex=true, sechk=true, x1=10, y1=-4, x2=-10, y2=4}
					elseif element.OpenAccessButton then
						aObj:skinStdButton{obj=element.OpenAccessButton, fType=ftype}
					elseif element.PushToTalkKeybindButton then
						aObj:skinStdButton{obj=element.PushToTalkKeybindButton, fType=ftype}
					elseif element.ToggleTest then
						aObj:addButtonBorder{obj=element.ToggleTest, fType=ftype, clr="grey", ofs=1}
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
			local function skinSetting(element, _, new)
				if new ~= false then
					local name = element:GetElementData().data.name
					-- aObj:Debug("skinSetting: [%s, %s]", name)
					if name == "Push to Talk Key" then
						_G.C_Timer.After(0.1, function()
							skinCommonElements(element)
						end)
					elseif element.EvaluateVisibility then -- handle ExpandableSection(s)
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
					-- TODO: skin TTS Voice DropDown button
				end
			end
			_G.ScrollUtil.AddAcquiredFrameCallback(this.Container.SettingsList.ScrollBox, skinSetting, aObj, true)
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

	aObj.blizzFrames[ftype].SpellFlyout = function(self)
		if not self.prdb.SpellFlyout or self.initialized.SpellFlyout then return end
		self.initialized.SpellFlyout = true

		self:SecureHookScript(_G.SpellFlyout, "OnShow", function(this)
			self:skinObject("frame", {obj=this.Background, fType=ftype, kfs=true, ofs=8, y2=-1, clr="grey"})
			if self.modBtnBs then
				local function skinBtns()
					local i = 1
					local button = _G["SpellFlyoutButton" .. i]
					while (button and button:IsShown()) do
						aObj:addButtonBorder{obj=button, fType=ftype, abt=true, sft=true, clr="grey"}
						i = i+1
						button = _G["SpellFlyoutButton" .. i]
					end
				end
				skinBtns()
				self:SecureHook(this, "Toggle", function(_)
					skinBtns()
				end)
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].TalkingHead = function(self)
		if not self.prdb.TalkingHead or self.initialized.TalkingHead then return end
		self.initialized.TalkingHead = true

		self:SecureHookScript(_G.TalkingHeadFrame, "OnShow", function(this)
			-- remove CloseButton animation
			this.MainFrame.TalkingHeadsInAnim.CloseButton = nil
			this.MainFrame.Close.CloseButton = nil
			self:nilTexture(this.BackgroundFrame.TextBackground, true)
			self:nilTexture(this.PortraitFrame.Portrait, true)
			self:nilTexture(this.MainFrame.Model.PortraitBg, true)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, bd=11, ng=true, ofs=-15, y2=14})
			if self.modBtns then
				self:skinCloseButton{obj=this.MainFrame.CloseButton, noSkin=true}
			end

			local function clrFrame(...)
				local r, _,_,_ = ...
				if r == 0 then -- use light background (Island Expeditions, Voldun Quest, Dark Iron intro)
					_G.TalkingHeadFrame.sf:SetBackdropColor(.75, .75, .75, .75)
					_G.TalkingHeadFrame.MainFrame.CloseButton:SetNormalFontObject(self.modUIBtns.fontBX)
				else
					_G.TalkingHeadFrame.sf:SetBackdropColor(.1, .1, .1, .75)
					_G.TalkingHeadFrame.MainFrame.CloseButton:SetNormalFontObject(self.modUIBtns.fontX)
				end
			end
			clrFrame(this.TextFrame.Text:GetTextColor())
			self:SecureHook(this.TextFrame.Text, "SetTextColor", function(_, ...)
				clrFrame(...)
			end)

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
		["Spell Flyout"]           = true,
		["Talking Head"]           = true,
	}
	self:setupFramesOptions(optTab, "UI")
	_G.wipe(optTab)

end