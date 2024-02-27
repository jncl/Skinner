local _, aObj = ...
if not aObj:isAddonEnabled("Rematch") then return end
local _G = _G
-- luacheck: ignore 631 (line is too long)

aObj.addonsToSkin.Rematch = function(self) -- v 5.1.3

	-- TODO: See if buttons and checkbox textures can be replaced

	local function rmInset(frame)
		frame.TopLeft:SetTexture(nil)
		frame.TopRight:SetTexture(nil)
		frame.Top:SetTexture(nil)
		frame.BottomLeft:SetTexture(nil)
		frame.BottomRight:SetTexture(nil)
		frame.Bottom:SetTexture(nil)
		frame.Left:SetTexture(nil)
		frame.Right:SetTexture(nil)
	end
	local function skinPanel(frame)
		aObj:removeInset(frame.Top)
		frame.Top.Back:SetTexture(nil)
		if frame.Top.SearchBox then
			aObj:skinObject("editbox", {obj=frame.Top.SearchBox, chginset=false, mi=true, mix=20})
		end
	    aObj:removeInset(frame.List)
		aObj:skinObject("scrollbar", {obj=frame.List.ScrollBar})
	end

	self:SecureHookScript(_G.RematchFrame, "OnShow", function(this)
	    this:DisableDrawLayer("BACKGROUND")
	    this:DisableDrawLayer("BORDER")
		self:skinObject("tabs", {obj=this, tabs={this.PanelTabs:GetChildren()}, ignoreSize=true, lod=true, regions={3}, track=false})
		if self.isTT then
			self:SecureHook(_G.Rematch.panelTabs, "Update", function(fObj)
				for _, tab in _G.ipairs{fObj:GetChildren()} do
					if tab.isSelected then
						self:setActiveTab(tab.sf)
					else
						self:setInactiveTab(tab.sf)
					end
				end
			end)
		end
		self:skinObject("frame", {obj=this, kfs=true, x1=-4, y1=2, x2=1, y2=-2})

	    self:keepFontStrings(this.TitleBar)
		if self.modBtns then
			-- FIXME: skin buttons
			-- self:skinStdButton{obj=this.TitleBar.LockButton}
			-- self:skinStdButton{obj=this.TitleBar.PrevModeButton}
			-- self:skinStdButton{obj=this.TitleBar.NextModeButton}
		    -- self:skinStdButton{obj=this.TitleBar.MinimizeButton}
			self:skinCloseButton{obj=this.TitleBar.CloseButton}
		end

		self:removeInset(this.ToolBar)
		self:keepFontStrings(this.ToolBar.TotalsButton)
		self:removeRegions(this.ToolBar.AchievementTotal, {4, 5})
		for _, btn in ipairs(this.ToolBar.Buttons) do
			btn.Border:SetTexture(nil)
			if self.modBtnBs then
				self:addButtonBorder{obj=btn, reParent={btn.Cancel, btn.Count}}
			end
		end

		-- side tabs
		for _, tab in pairs(this.TeamTabs.Tabs) do
			if self.modBtns then
				self:skinStdButton{obj=tab, ofs=-1, x1=-1, y2=5}
			end
		end

		if self.modBtns then
			self:skinStdButton{obj=this.BottomBar.SummonButton, schk=true}
			self:skinStdButton{obj=this.BottomBar.FindBattleButton}
			self:skinStdButton{obj=this.BottomBar.SaveAsButton}
			self:skinStdButton{obj=this.BottomBar.SaveButton, sechk=true}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=this.BottomBar.UseRematchCheckButton}
		end

		self:SecureHookScript(this.LoadedTeamPanel, "OnShow", function(fObj)
			self:removeInset(fObj.TeamButton)
			if self.modBtns then
				self:skinStdButton{obj=fObj.PreferencesFrame.PreferencesButton, clr="grey"}
				self:skinStdButton{obj=fObj.NotesFrame.NotesButton, clr="grey"}
				self:skinStdButton{obj=fObj.TeamButton, clr="gold"}
			end

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.LoadedTeamPanel)

		self:SecureHookScript(this.PetsPanel, "OnShow", function(fObj)
			self:removeInset(fObj.Top)
			fObj.Top.Back:SetTexture(nil)
			self:skinObject("editbox", {obj=fObj.Top.SearchBox, chginset=false, mi=true, mix=20})
			if self.modBtns then
				self:skinStdButton{obj=fObj.Top.FilterButton, clr="grey"}
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=fObj.Top.ToggleButton, clr="grey", ofs=1}
			end
			-- .TypeBar appears when ToggleButton clicked
			self:skinObject("tabs", {obj=fObj.Top.TypeBar, tabs=fObj.Top.TypeBar.Tabs, ignoreSize=true, lod=true, regions={3}, offsets={x1=4, y1=0, x2=-2, y2=-2}, track=false, func=aObj.isTT and function(tab)
				self:SecureHookScript(tab, "OnClick", function(tObj)
					for _, btn in _G.pairs(tObj:GetParent().Tabs) do
						self:setInactiveTab(btn.sf)
					end
					if tObj.isSelected then
						self:setActiveTab(tObj.sf)
					end
				end)
			end})
			fObj.Top.TypeBar.TabbedBorder:SetTexture(nil)
			self:skinObject("frame", {obj=fObj.Top.TypeBar, y1=-19, fb=true})
		    self:removeInset(fObj.ResultsBar)
		    self:removeInset(fObj.List)
			self:skinObject("scrollbar", {obj=fObj.List.ScrollBar})
			local function skinElement(...)
				local _, element
				if _G.select("#", ...) == 2 then
					element, _ = ...
				else
					_, element, _ = ...
				end
				element.Back:SetTexture(nil)
			end
			_G.ScrollUtil.AddInitializedFrameCallback(fObj.List.ScrollBox, skinElement, aObj, true)

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.PetsPanel)

		self:SecureHookScript(this.LoadedTargetPanel, "OnShow", function(fObj)
			self:removeInset(fObj)
			fObj.InsetBack:SetTexture(nil)
			if self.modBtns then
				self:skinStdButton{obj=fObj.AllyTeam.PrevTeamButton, clr="grey"}
				self:skinStdButton{obj=fObj.AllyTeam.NextTeamButton, clr="grey"}
				self:skinStdButton{obj=fObj.BigLoadSaveButton, clr="grey"}
				self:skinStdButton{obj=fObj.MediumLoadButton, clr="grey"}
				self:skinStdButton{obj=fObj.SmallRandomButton, clr="grey"}
				self:skinStdButton{obj=fObj.SmallTeamsButton, clr="grey"}
				self:skinStdButton{obj=fObj.SmallSaveButton, clr="grey"}
			end

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.LoadedTargetPanel)

		self:SecureHookScript(this.LoadoutPanel, "OnShow", function(fObj)
			for _,loadout in pairs(fObj.Loadouts) do
				rmInset(loadout)
				loadout.Back:SetTexture(nil)
				loadout.Pet.LevelBubble:SetTexture(nil)
				loadout.XpBarBack:SetTexture(nil)
				loadout.XpBar:SetTexture(self.sbTexture)
				loadout.XpBarBorder:SetTexture(nil)
				loadout.HpBarBack:SetTexture(nil)
				loadout.HpBar:SetTexture(self.sbTexture)
				loadout.HpBarBorder:SetTexture(nil)
				-- loadout.
				self:skinObject("frame", {obj=loadout, fb=true})
				fObj.AbilityFlyout.Border:SetTexture(nil)
				self:skinObject("frame", {obj=fObj.AbilityFlyout, fb=true})
			end

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.LoadoutPanel)

		self:SecureHookScript(this.MiniLoadoutPanel, "OnShow", function(fObj)
			for _,loadout in pairs(fObj.Loadouts) do
				rmInset(loadout)
				loadout.Back:SetTexture(nil)
				loadout.LevelBubble:SetTexture(nil)
				loadout.TopStatusBarBack:SetTexture(nil)
				loadout.BottomStatusBarBack:SetTexture(nil)
				loadout.TopStatusBar:SetTexture(self.sbTexture)
				loadout.BottomStatusBar:SetTexture(self.sbTexture)
				loadout.TopStatusBarBorder:SetTexture(nil)
				loadout.BottomStatusBarBorder:SetTexture(nil)
				-- loadout.
				self:skinObject("frame", {obj=loadout, fb=true})
			end

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.MiniLoadoutPanel)

		self:SecureHookScript(this.TeamsPanel, "OnShow", function(fObj)
			skinPanel(fObj)
			if self.modBtns then
				self:skinStdButton{obj=fObj.Top.TeamsButton, clr="grey"}
			end

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.TeamsPanel)

		self:SecureHookScript(this.TargetsPanel, "OnShow", function(fObj)
			skinPanel(fObj)

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.TargetsPanel)

		self:SecureHookScript(this.QueuePanel, "OnShow", function(fObj)
			skinPanel(fObj)
			self:removeInset(fObj.PreferencesFrame)
			self:removeInset(fObj.StatusBar)
			local function skinElement(...)
				local _, element
				if _G.select("#", ...) == 2 then
					element, _ = ...
				else
					_, element, _ = ...
				end
				element.Back:SetTexture(nil)
			end
			_G.ScrollUtil.AddInitializedFrameCallback(fObj.List.ScrollBox, skinElement, aObj, true)
			if self.modBtns then
				self:skinStdButton{obj=fObj.Top.QueueButton, clr="grey"}
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=fObj.PreferencesFrame.PreferencesButton, clr="grey", ofs=1}
			end

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.QueuePanel)

		self:SecureHookScript(this.OptionsPanel, "OnShow", function(fObj)
			skinPanel(fObj)

			-- TODO: skin option check buttons

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.OptionsPanel)

		self:Unhook(this, "OnShow")
	end)

	-- skin tooltip menus
	local function scanChildren(frame, menuName, parent)
		for _, child in _G.ipairs_reverse{frame:GetChildren()} do
			-- check for forbidden objects (StoreUI components etc.)
			if not child:IsForbidden() then
				if child.menuName == menuName
				and child.relativeTo == parent
				then
					return child
				end
			end
		end
	end
	self:SecureHook(_G.Rematch.menus, "Show", function(_, menuName, parent, _)
	    local parentFrame, menuFrame = parent:GetParent()
		if not parentFrame.isRematchMenu then
			menuFrame = scanChildren(_G.UIParent, menuName, parent)
		else
			menuFrame = scanChildren(parent, menuName, parent)
		end
		if menuFrame then
			self:keepFontStrings(menuFrame.Title)
			self:skinObject("frame", {obj=menuFrame, kfs=true})
		end
	end)

	self:SecureHookScript(_G.RematchPetCard, "OnShow", function(this)
		this.Content.Top.Back:SetTexture(nil)
		this.Content.Front.Abilities.Back:SetTexture(nil)
		this.Content.Front.Stats:DisableDrawLayer("BACKGROUND")
		this.Content.Front.Stats.HpBar.Border:SetTexture(nil)
		this.Content.Front.Stats.HpBar.Bar:SetTexture(self.sbTexture)
		this.Content.Front.Stats.XpBar.Border:SetTexture(nil)
		this.Content.Front.Stats.XpBar.Bar:SetTexture(self.sbTexture)
		this.Content.Back.Racial.Back:SetTexture(nil)
		this.Content.Back.Racial.TypeNameDoodadLeft:SetTexture(nil)
		this.Content.Back.Racial.TypeNameDoodadRight:SetTexture(nil)
		this.Content.Back.Source:DisableDrawLayer("BACKGROUND")
		this.Content.Back.Lore:DisableDrawLayer("BACKGROUND")
		this.Content.Back.Lore.Text:SetTextColor(self.BT:GetRGB())
		self:skinObject("frame", {obj=this.Content, kfs=true})
		self:skinObject("frame", {obj=this, kfs=true, cb=true})

		self:Unhook(this, "OnShow")
	end)

	-- TODO: Finish skinning all dialog subframes
	self:SecureHookScript(_G.RematchDialog, "OnShow", function(this)
		this.Prompt:DisableDrawLayer("BACKGROUND")
		this.Prompt:DisableDrawLayer("BORDER")
		self:skinObject("frame", {obj=this, kfs=true, cb=true})
		if self.modBtns then
			-- .MinimizeButton
			self:skinStdButton{obj=this.CancelButton}
			self:skinStdButton{obj=this.OtherButton}
			self:skinStdButton{obj=this.AcceptButton}
		end

		self:SecureHookScript(this.Canvas.EditBox, "OnShow", function(fObj)
			self:skinObject("editbox", {obj=fObj.EditBox})

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.Canvas.EditBox)

		self:SecureHookScript(this.Canvas.MultiLineEditBox, "OnShow", function(fObj)
			self:removeInset(fObj)
			self:skinObject("slider", {obj=fObj.ScrollFrame.ScrollBar})

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.Canvas.MultiLineEditBox)

		self:SecureHookScript(this.Canvas.CheckButton, "OnShow", function(fObj)
			if self.modChkBtns then
				self:skinCheckButton{obj=fObj.Check}
			end

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.Canvas.CheckButton)

		self:SecureHookScript(this.Canvas.IncludeCheckButtons, "OnShow", function(fObj)
			if self.modChkBtns then
				self:skinCheckButton{obj=fObj.IncludePreferences}
				self:skinCheckButton{obj=fObj.IncludeNotes}
			end

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.Canvas.IncludeCheckButtons)

		-- Icon
		-- ColorPicker
		self:SecureHookScript(this.Canvas.DropDown, "OnShow", function(fObj)
			self:skinObject("dropdown", {obj=fObj.DropDown, noBB=true, x1=0, y1=0, x2=0, y2=0})

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.Canvas.DropDown)

		self:SecureHookScript(this.Canvas.Pet, "OnShow", function(fObj)
			fObj.ListButtonPet.Back:SetTexture(nil)

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.Canvas.Pet)
		-- Team
		-- LayoutTabs
		-- PreferencesReadOnly
		self:SecureHookScript(this.Canvas.Preferences, "OnShow", function(fObj)
			self:skinObject("editbox", {obj=fObj.MaxLevel})
			self:skinObject("editbox", {obj=fObj.MinLevel})
			self:skinObject("editbox", {obj=fObj.MaxHealth})
			self:skinObject("editbox", {obj=fObj.MinHealth})
			if self.modChkBtns then
				self:skinCheckButton{obj=fObj.AllowMM}
			end

			self:Unhook(fObj, "OnShow")
		end)

		self:SecureHookScript(this.Canvas.IconPicker, "OnShow", function(fObj)
			self:skinObject("editbox", {obj=fObj.SearchBox, chginset=false, mi=true, mix=20})
		    self:removeInset(fObj.List)
			self:skinObject("scrollbar", {obj=fObj.List.ScrollBar})

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.Canvas.IconPicker)

		self:SecureHookScript(this.Canvas.TeamPicker, "OnShow", function(fObj)
			self:removeInset(fObj.Lister.Top)
			fObj.Lister.Top.Back:SetTexture(nil)
		    self:removeInset(fObj.Lister.List)
			self:skinObject("scrollbar", {obj=fObj.Lister.List.ScrollBar})
			self:removeInset(fObj.Picker.Top)
			fObj.Picker.Top.Back:SetTexture(nil)
		    self:removeInset(fObj.Picker.List)
			self:skinObject("scrollbar", {obj=fObj.Picker.List.ScrollBar})
			self:skinObject("editbox", {obj=fObj.Picker.SearchBox, chginset=false, mi=true, mix=20})
			if self.modBtns then
				self:skinStdButton{obj=fObj.Lister.Top.AddButton, clr="grey"}
				self:skinStdButton{obj=fObj.Lister.Top.DeleteButton, clr="grey"}
				self:skinStdButton{obj=fObj.Lister.Top.DownButton, clr="grey"}
				self:skinStdButton{obj=fObj.Lister.Top.UpButton, clr="grey"}
				self:skinStdButton{obj=fObj.Picker.Top.AllButton, clr="grey"}
				self:skinStdButton{obj=fObj.Picker.Top.CancelButton, clr="grey"}
			end

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.Canvas.TeamPicker)

		self:SecureHookScript(this.Canvas.GroupPicker, "OnShow", function(fObj)
			self:removeInset(fObj.Top)
			fObj.List:DisableDrawLayer("BACKGROUND")
			fObj.List:DisableDrawLayer("BORDER")
			if self.modBtns then
				self:skinStdButton{obj=fObj.Top.CancelButton, clr="grey"}
			end

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.Canvas.GroupPicker)

		-- ComboBox
		-- TeamWithAbilities
		-- OtherTeamWithAbilities
		-- GroupSelect
		-- WinRecord
		-- ListData
		-- ConflictRadios
		-- MultiTeam
		-- Slider
		-- TeamWarning
		-- PetSummary
		-- BarChartDropDown
		-- BarChart
		-- BattleSummary
		-- PetHerderPicker

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.RematchTooltip, "OnShow", function(this)
		self:skinObject("frame", {obj=this, kfs=true})

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.RematchGameTooltip, "OnShow", function(this)
		self:skinObject("frame", {obj=this, kfs=true})

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.RematchAbilityTooltip, "OnShow", function(this)
		self:skinObject("frame", {obj=this, kfs=true})

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.RematchAbilityTooltip)

	if self.modChkBtns then
		self.RegisterCallback("rematch.journal", "AddOn_Loaded", function(_, addon)
			if addon == "Blizzard_Collections" then
				-- wait for button to be created
				_G.C_Timer.After(0.25, function()
					self:skinCheckButton{obj=_G.Rematch.journal.UseRematchCheckButton}
				end)
				self.UnregisterCallback("rematch.journal", "AddOn_Loaded")
			end
		end)
	end

end
