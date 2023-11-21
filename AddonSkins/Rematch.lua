local _, aObj = ...
if not aObj:isAddonEnabled("Rematch") then return end
local _G = _G
-- luacheck: ignore 631 (line is too long)

aObj.addonsToSkin.Rematch = function(self) -- v 5.0.1

	local function removeInset(frame)
		frame.TopLeft:SetTexture(nil)
		frame.TopRight:SetTexture(nil)
		frame.Top:SetTexture(nil)
		frame.BottomLeft:SetTexture(nil)
		frame.BottomRight:SetTexture(nil)
		frame.Bottom:SetTexture(nil)
		frame.Left:SetTexture(nil)
		frame.Right:SetTexture(nil)
	end

	self:SecureHookScript(_G.RematchFrame, "OnShow", function(this)
	    this:DisableDrawLayer("BACKGROUND")
	    this:DisableDrawLayer("BORDER")

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

		self:removeInset(this.PetsPanel.Top)
		this.PetsPanel.Top.Back:SetTexture(nil)
		self:skinObject("editbox", {obj=this.PetsPanel.Top.SearchBox, chginset=false, mi=true, mix=20})
		if self.modBtns then
			self:skinStdButton{obj=this.PetsPanel.Top.FilterButton, clr="grey"}
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=this.PetsPanel.Top.ToggleButton, clr="grey", ofs=1}
		end
		-- .TypeBar appears when ToggleButton clicked
		self:skinObject("tabs", {obj=this.PetsPanel.Top.TypeBar, tabs=this.PetsPanel.Top.TypeBar.Tabs, ignoreSize=true, lod=true, regions={3}, offsets={x1=4, y1=0, x2=-2, y2=-2}, track=false, func=aObj.isTT and function(tab)
			self:SecureHookScript(tab, "OnClick", function(tObj)
				for _, btn in _G.pairs(tObj:GetParent().Tabs) do
					self:setInactiveTab(btn.sf)
				end
				if tObj.isSelected then
					self:setActiveTab(tObj.sf)
				end
			end)
		end})
		this.PetsPanel.Top.TypeBar.TabbedBorder:SetTexture(nil)
		self:skinObject("frame", {obj=this.PetsPanel.Top.TypeBar, y1=-19, fb=true})
	    self:removeInset(this.PetsPanel.ResultsBar)
	    self:removeInset(this.PetsPanel.List)
		self:skinObject("scrollbar", {obj=this.PetsPanel.List.ScrollBar})
		local function skinElement(...)
			local _, element
			if _G.select("#", ...) == 2 then
				element, _ = ...
			else
				_, element, _ = ...
			end
			element.Back:SetTexture(nil)
		end
		_G.ScrollUtil.AddInitializedFrameCallback(this.PetsPanel.List.ScrollBox, skinElement, aObj, true)

		self:removeInset(this.LoadedTargetPanel)
		this.LoadedTargetPanel.InsetBack:SetTexture(nil)
		if self.modBtns then
			self:removeInset(this.LoadedTeamPanel.TeamButton)
			self:skinStdButton{obj=this.LoadedTeamPanel.TeamButton}
		end

		for _,loadout in pairs(this.LoadoutPanel.Loadouts) do
			removeInset(loadout)
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
		end

		for _,loadout in pairs(this.MiniLoadoutPanel.Loadouts) do
			removeInset(loadout)
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

		self:removeInset(this.TeamsPanel.Top)
		this.TeamsPanel.Top.Back:SetTexture(nil)
		self:skinObject("editbox", {obj=this.TeamsPanel.Top.SearchBox, chginset=false, mi=true, mix=20})
		if self.modBtns then
			self:skinStdButton{obj=this.TeamsPanel.Top.TeamsButton, clr="grey"}
		end
	    self:removeInset(this.TeamsPanel.List)
		self:skinObject("scrollbar", {obj=this.TeamsPanel.List.ScrollBar})
		-- local function skinTeam(...)
		-- 	local _, element, elementData
		-- 	if _G.select("#", ...) == 2 then
		-- 		element, elementData = ...
		-- 	else
		-- 		_, element, elementData = ...
		-- 	end
		-- 	-- element.Back:SetTexture(nil)
		-- end
		-- _G.ScrollUtil.AddInitializedFrameCallback(this.TeamsPanel.List.ScrollBox, skinTeam, aObj, true)

		self:removeInset(this.TargetsPanel.Top)
		this.TargetsPanel.Top.Back:SetTexture(nil)
		self:skinObject("editbox", {obj=this.TargetsPanel.Top.SearchBox, chginset=false, mi=true, mix=20})
	    self:removeInset(this.TargetsPanel.List)
		self:skinObject("scrollbar", {obj=this.TargetsPanel.List.ScrollBar})
		-- local function skinTarget(...)
		-- 	local _, element, elementData
		-- 	if _G.select("#", ...) == 2 then
		-- 		element, elementData = ...
		-- 	else
		-- 		_, element, elementData = ...
		-- 	end
		-- 	-- element.Back:SetTexture(nil)
		-- end
		-- _G.ScrollUtil.AddInitializedFrameCallback(this.TargetsPanel.List.ScrollBox, skinTarget, aObj, true)

		self:removeInset(this.QueuePanel.PreferencesFrame)
		if self.modBtnBs then
			self:addButtonBorder{obj=this.QueuePanel.PreferencesFrame.PreferencesButton, clr="grey", ofs=1}
		end
		self:removeInset(this.QueuePanel.Top)
		this.QueuePanel.Top.Back:SetTexture(nil)
		if self.modBtns then
			self:skinStdButton{obj=this.QueuePanel.Top.QueueButton, clr="grey"}
		end
		self:removeInset(this.QueuePanel.StatusBar)
	    self:removeInset(this.QueuePanel.List)
		self:skinObject("scrollbar", {obj=this.QueuePanel.List.ScrollBar})
		-- local function skinQueue(...)
		-- 	local _, element, elementData
		-- 	if _G.select("#", ...) == 2 then
		-- 		element, elementData = ...
		-- 	else
		-- 		_, element, elementData = ...
		-- 	end
		-- 	-- element.Back:SetTexture(nil)
		-- end
		-- _G.ScrollUtil.AddInitializedFrameCallback(this.QueuePanel.List.ScrollBox, skinQueue, aObj, true)

		self:removeInset(this.OptionsPanel.Top)
		this.OptionsPanel.Top.Back:SetTexture(nil)
		self:skinObject("editbox", {obj=this.OptionsPanel.Top.SearchBox, chginset=false, mi=true, mix=20})
	    self:removeInset(this.OptionsPanel.List)
		self:skinObject("scrollbar", {obj=this.OptionsPanel.List.ScrollBar})
		-- local function skinOption(...)
		-- 	local _, element, elementData
		-- 	if _G.select("#", ...) == 2 then
		-- 		element, elementData = ...
		-- 	else
		-- 		_, element, elementData = ...
		-- 	end
		-- 	-- element.Back:SetTexture(nil)
		-- end
		-- _G.ScrollUtil.AddInitializedFrameCallback(this.OptionsPanel.List.ScrollBox, skinOption, aObj, true)

		-- TODO: skin option check buttons


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

		-- bottom tabs
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
					aObj:skinObject("frame", {obj=child, kfs=true})
				end
			end
		end

	end
	self:SecureHook(_G.Rematch.menus, "Show", function(_, menuName, parent, _)
	    local parentFrame = parent:GetParent()
		if not parentFrame.isRematchMenu then
			scanChildren(_G.UIParent, menuName, parent)
		else
			scanChildren(parent, menuName, parent)
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
		self:skinObject("editbox", {obj=this.Canvas.EditBox.EditBox})
		self:removeInset(this.Canvas.MultiLineEditBox)
		self:skinObject("slider", {obj=this.Canvas.MultiLineEditBox.ScrollFrame.ScrollBar})
		self:skinObject("frame", {obj=this, kfs=true, cb=true})
		if self.modBtns then
			self:skinStdButton{obj=this.CancelButton}
			self:skinStdButton{obj=this.OtherButton}
			self:skinStdButton{obj=this.AcceptButton}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=this.Canvas.CheckButton.Check}
			self:skinCheckButton{obj=this.Canvas.IncludeCheckButtons.IncludePreferences}
			self:skinCheckButton{obj=this.Canvas.IncludeCheckButtons.IncludeNotes}
		end

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
