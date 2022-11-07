local aName, aObj = ...
if not aObj:isAddonEnabled("Rematch") then return end
local _G = _G

aObj.addonsToSkin.Rematch = function(self) -- v 4.14.4

	local function skinScrollFrame(frame)
	    aObj:removeInset(frame.List.Background)
		aObj:skinObject("slider", {obj=frame.List.ScrollFrame.ScrollBar, x2=-2})
		local function skinBtns(frame)
			if frame.hasButtons then
			    for _, btn in _G.pairs(frame.ScrollFrame.Buttons) do
			        btn:DisableDrawLayer("BACKGROUND")
			    end
			end
		end
		aObj:SecureHook(frame.List, "Update", function(this)
			skinBtns(this)
		end)
		skinBtns(frame.List)
	end
	local function skinComboBox(frame)
		aObj:skinObject("frame", {obj=frame, fb=true, ofs=0})
		if aObj.modBtnBs then
			aObj:addButtonBorder{obj=aObj:getChild(frame, 1), ofs=-1}--, ofs=1, x1=-1, y1=1, x2=1, y2=-1, relTo=, reParent={}, clr=, ca=}
		end
	end
    -- Menu (replaces dropdown menus)
    self:RawHook(_G.Rematch, "GetMenuFrame", function(this, ...)
        local frame = self.hooks[this].GetMenuFrame(this, ...)
        if not frame.sf then
            self:removeRegions(frame, {1, 2})
            self:removeRegions(frame.Title, {1, 2})
			self:skinObject("frame", {obj=frame, ofs=0})
        end
		-- TODO: skin Buttons' Check texture ??
        return frame
    end, true)

	local function skinTabs(frame)
		aObj:skinObject("tabs", {obj=frame, tabs=frame.PanelTabs.Tabs, ignoreSize=true, lod=true, selectedTab=frame == _G.RematchFrame and _G.RematchSettings.ActivePanel or _G.RematchSettings.JournalPanel, regions={3}, track=false, func=aObj.isTT and function(tab)
			aObj:SecureHookScript(tab, "OnClick", function(this)
				for _, tab in _G.pairs(this:GetParent().Tabs) do
					aObj:setInactiveTab(tab.sf)
				end
				if this:GetID() == frame == _G.RematchFrame and _G.RematchSettings.ActivePanel or _G.RematchSettings.JournalPanel then
					aObj:setActiveTab(this.sf)
				end
			end)
		end})
	end
    -- Journal (used when integrated with PetJournal)
	self:SecureHookScript(_G.RematchJournal, "OnShow", function(this)
		if this.CollectMeButton then
			self:removeMagicBtnTex(this.CollectMeButton)
			if self.modBtns then
				self:skinStdButton{obj=this.CollectMeButton}
			end
		end
		skinTabs(this)
		self:skinObject("frame", {obj=this, kfs=true, rns=true, cb=true, x1=-4, y1=2, x2=1, y2=-2})

		self:Unhook(this, "OnShow")
	end)
	if self.modChkBtns then
		self:SecureHook(_G.RematchJournal, "SetupUseRematchButton", function(this)
			self:skinCheckButton{obj=_G.UseRematchButton}
			self:Unhook(this, "SetupUseRematchButton")
		end)
	end

    -- Frame (used when standalone)
	self:SecureHookScript(_G.RematchFrame, "OnShow", function(this)
	    this:DisableDrawLayer("BACKGROUND")
	    this:DisableDrawLayer("BORDER")
	    self:keepFontStrings(this.TitleBar)
		skinTabs(this)
		self:skinObject("frame", {obj=this, kfs=true, cb=true, x1=-4, y1=2, x2=1, y2=-2})
		if self.modBtns then
			-- FIXME: skin buttons
			-- self:skinStdButton{obj=this.TitleBar.LockButton}
			-- self:skinStdButton{obj=this.TitleBar.SinglePanelButton}
		    -- self:skinOtherButton{obj=this.TitleBar.MinimizeButton, text=""} -- uses existing texture
		end
		-- remove these textures after buttons skinned, otherwise texture remains for some reason
	    self:removeRegions(this.TitleBar.LockButton, {5})
	    self:removeRegions(this.TitleBar.SinglePanelButton, {5})
	    self:removeRegions(this.TitleBar.MinimizeButton, {5})

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.RematchToolbar, "OnShow", function(this)
	    self:removeInset(this.PetCount)
	    self:removeRegions(this.Achievement, {4, 5})
		if self.modBtnBs then
		    self:addButtonBorder{obj=_G.RematchHealButton}
		    self:addButtonBorder{obj=_G.RematchBandageButton}
		    self:addButtonBorder{obj=_G.RematchToolbar.PetTreat}
		    self:addButtonBorder{obj=_G.RematchToolbar.LesserPetTreat}
		    self:addButtonBorder{obj=_G.RematchToolbar.SafariHat}
		    self:addButtonBorder{obj=_G.RematchToolbar.SummonRandom}
			-- N.B. these buttons are only shown when the toolbar is at the bottom
		    self:addButtonBorder{obj=_G.RematchToolbar.FindBattle}
		    self:addButtonBorder{obj=_G.RematchToolbar.Save}
		    self:addButtonBorder{obj=_G.RematchToolbar.SaveAs}
		end
	    -- N.B. have to hook this as it changes the GameTooltip border colour
	    self:SecureHook(this, "ButtonOnEnter", function(this, _)
	        if not this.tooltipTitle then
	            self:skinTooltip(_G.GameTooltip)
	        end
	    end)

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.RematchMiniPanel, "OnShow", function(this)
	    for _, pet in _G.pairs(this.Pets) do
	        pet.HP:DisableDrawLayer("OVERLAY")
			self:skinObject("statusbar", {obj=pet.HP, fi=0, bg=self:getRegion(pet.HP, 6)})
	        pet.XP:DisableDrawLayer("OVERLAY")
			self:skinObject("statusbar", {obj=pet.XP, fi=0, bg=self:getRegion(pet.XP, 4)})
	    end
	    self:removeInset(this.Background)
	    self:removeInset(this.Target)
		self:skinObject("frame", {obj=this.Flyout, kfs=true})
		if self.modBtnBs then
			self:addButtonBorder{obj=this.Target.ModelBorder}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.RematchPetPanel, "OnShow", function(this)
	    self:removeInset(this.Top)
		self:skinObject("editbox", {obj=this.Top.SearchBox, chginset=false, regions={3}, ofs=0})
		self:skinObject("tabs", {obj=this.Top.TypeBar, tabs=this.Top.TypeBar.Tabs, ignoreSize=true, lod=true, regions={8}, offsets={x1=4, y1=0, x2=-2, y2=-2}, track=false, func=aObj.isTT and function(tab)
			aObj:SecureHookScript(tab, "OnClick", function(this)
				for _, tab in _G.pairs(this:GetParent().Tabs) do
					aObj:setInactiveTab(tab.sf)
				end
				if tab.Selected:IsShown() then
					aObj:setActiveTab(this.sf)
				end
			end)
		 	aObj:keepFontStrings(tab.Selected)
		end})
	    for _, btn in _G.pairs(this.Top.TypeBar.Buttons) do
	        btn.IconBorder:SetTexture(nil)
	    end
		self:skinObject("frame", {obj=this.Top.TypeBar, kfs=true, y1=1})
	    self:removeInset(this.Results)
		skinScrollFrame(this)
		if self.modBtns then
			self:skinStdButton{obj=this.Top.Filter}
		end
		if self.modBtnBs then
		    self:addButtonBorder{obj=this.Top.Toggle, ofs=0}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.RematchBottomPanel, "OnShow", function(this)
		self:removeMagicBtnTex(this.FindBattleButton)
		self:removeMagicBtnTex(this.SaveAsButton)
		self:removeMagicBtnTex(this.SaveButton)
		self:removeMagicBtnTex(this.SummonButton)
		if self.modBtns then
			self:skinStdButton{obj=this.SummonButton}
			self:skinStdButton{obj=this.SaveButton}
			self:skinStdButton{obj=this.SaveAsButton}
			self:skinStdButton{obj=this.FindBattleButton}
			self:SecureHook(this, "Update", function(this)
				self:clrBtnBdr(this.SummonButton)
				self:clrBtnBdr(this.SaveButton)
				self:clrBtnBdr(this.FindBattleButton)
			end)
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=this.UseDefault}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.RematchLoadoutPanel, "OnShow", function(this)
	    for _, frame in _G.pairs(this.Loadouts) do
	        self:removeInset(frame)
	        frame.XP:DisableDrawLayer("OVERLAY")
			self:skinObject("statusbar", {obj=frame.XP, fi=0, bg=self:getRegion(frame.XP, 11)})
	        frame.HP:DisableDrawLayer("OVERLAY")
			self:skinObject("statusbar", {obj=frame.HP, fi=0, bg=self:getRegion(frame.HP, 6)})
			self:skinObject("frame", {obj=frame, kfs=true, fb=true, ofs=0})
	    end
	    self:removeInset(this.Target)
	    self:removeRegions(this.Target, {11}) -- line
		self:skinObject("frame", {obj=this.Flyout, kfs=true})
	    self:removeInset(this.TargetPanel.Top)
		self:skinObject("editbox", {obj=this.TargetPanel.Top.SearchBox, chginset=false, regions={3}, ofs=0})
		skinScrollFrame(this.TargetPanel)
		if self.modBtns then
			self:skinStdButton{obj=this.Target.LoadSaveButton}
			self:skinStdButton{obj=this.Target.TargetButton}
			self:skinStdButton{obj=this.TargetPanel.Top.BackButton}
		end
		if self.modBtnBs then
		    self:addButtonBorder{obj=this.Target.ModelBorder}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.RematchTeamPanel, "OnShow", function(this)
	    self:removeInset(this.Top)
		if self.modBtnBs then
			self:addButtonBorder{obj=this.Top.Teams, ofs=0}
		end
		self:skinObject("editbox", {obj=this.Top.SearchBox, chginset=false, regions={3}, ofs=0})
		skinScrollFrame(this)

		self:Unhook(this, "OnShow")
	end)

	self:SecureHook(_G.RematchTeamTabs, "GetTabButton", function(this, index)
        this.Tabs[index]:DisableDrawLayer("BACKGROUND")
		if self.modBtnBs then
			self:addButtonBorder{obj=this.Tabs[index], ofs=4, relTo=this.Tabs[index].Icon}
		end
	end)

	self:SecureHookScript(_G.RematchQueuePanel, "OnShow", function(this)
	    self:removeInset(this.Top)
		if self.modBtnBs then
			self:addButtonBorder{obj=this.Top.QueueButton, ofs=0}
		end
	    self:removeInset(this.Status)
		skinScrollFrame(this)

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.RematchOptionPanel, "OnShow", function(this)
	    self:removeInset(this)
	    self:removeInset(this.Top)
		self:skinObject("editbox", {obj=this.Top.SearchBox, chginset=false, regions={3}, ofs=0})
		skinScrollFrame(this)
		-- TODO: skin CheckButtons

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.RematchLoadedTeamPanel, "OnShow", function(this)
	    this:DisableDrawLayer("BACKGROUND")
	    self:removeInset(this)
	    self:removeInset(this.Footnotes)

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.RematchAbilityCard, "OnShow", function(this)
	    this:DisableDrawLayer("BACKGROUND")
	    -- self:removeRegions(this, {14}) -- line
	    this.Hints:DisableDrawLayer("BACKGROUND")
	    self:removeRegions(this.Hints, {2, 9}) -- line & doodad
		self:skinObject("frame", {obj=this, kfs=true})

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.RematchPetCard, "OnShow", function(this)
	    this.Title:DisableDrawLayer("BACKGROUND")
		this.Title:SetFrameStrata("FULLSCREEN_DIALOG")
	    this.Front.Bottom:DisableDrawLayer("BACKGROUND")
	    self:removeRegions(this.Front.Bottom, {2}) -- line
	    this.Front.Middle:DisableDrawLayer("BACKGROUND")
	    this.Front.Middle:DisableDrawLayer("ARTWORK") -- line
	    this.Front.Middle.XP:DisableDrawLayer("OVERLAY")
		self:skinObject("statusbar", {obj=this.Front.Middle.XP, fi=0, bg=self:getRegion(this.Front.Middle.XP, 11)})
		self:skinObject("frame", {obj=this.Front, kfs=true})
	    this.Back.Source:DisableDrawLayer("BACKGROUND")
	    self:removeRegions(this.Back.Source, {3}) -- line
	    this.Back.Bottom:DisableDrawLayer("BACKGROUND")
	    self:removeRegions(this.Back.Bottom, {2, 15, 16}) -- line & doodads
	    this.Back.Middle:DisableDrawLayer("BACKGROUND")
	    this.Back.Middle:DisableDrawLayer("BORDER") -- doodads
		self:removeRegions(this.Back.Middle, {7}) -- line above middle area
	    this.Back.Middle.Lore:SetTextColor(self.BT:GetRGB())
		self:skinObject("frame", {obj=this.Back, kfs=true})
		self:skinObject("frame", {obj=this, kfs=true, cb=true, x2=0.5})
		if self.modBtns then
			self:skinStdButton{obj=this.PinButton, ofs=-6}
			-- self:removeRegions(this.CloseButton, {5})
		end
	    self:removeRegions(this.PinButton, {5})

		self:Unhook(this, "OnShow")
	end)

    self:SecureHookScript(_G.RematchDialog, "OnShow", function(this)
		-- .Preferences
		for _, eb in _G.pairs(this.Preferences.editBoxes) do
			self:adjHeight{obj=this.Preferences[eb], adj=-4}
			self:removeBackdrop(this.Preferences[eb])
			self:skinObject("editbox", {obj=this.Preferences[eb], regions={3}})
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=this.Preferences.AllowMM}
		end
		self:removeMagicBtnTex(this.Cancel)
		self:removeMagicBtnTex(this.Accept)
		self:removeMagicBtnTex(this.Other)
	    this.Prompt:DisableDrawLayer("BACKGROUND")
	    this.Prompt:DisableDrawLayer("BORDER")
		-- .Pet
		-- .Warning
		self:skinObject("editbox", {obj=this.EditBox, ofs=0})
		-- .Slot
		--. CheckButton
		-- .Team
		-- .OldTeam
		skinComboBox(this.TabPicker)
		self:skinObject("slider", {obj=this.MultiLine.ScrollBar, x1=4, y1=-3, x2=-4, y2=3})
		self:skinObject("frame", {obj=self:getChild(this.MultiLine, 2), kfs=true, fb=true, ofs=0})
	    self:removeInset(this.TeamTabIconPicker)
		self:skinObject("slider", {obj=this.TeamTabIconPicker.ScrollFrame.ScrollBar, x1=3})
		-- .SaveAs.Team
		self:skinObject("editbox", {obj=this.SaveAs.Name, regions={}})
		skinComboBox(this.SaveAs.Target)
		self:skinObject("frame", {obj=this, kfs=true, cb=true, y1=2, x2=1, y2=-2})
		if self.modBtns then
			self:skinStdButton{obj=this.Cancel}
			self:skinStdButton{obj=this.Accept}
			self:skinStdButton{obj=this.Other}
			self:SecureHook(this.Accept, "SetEnabled", function(this, _)
				self:clrBtnBdr(this)
			end)
			self:SecureHook(this.Other, "SetEnabled", function(this, _)
				self:clrBtnBdr(this)
			end)
			self:removeRegions(this.CloseButton, {5})
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=self:getChild(this.TabPicker, 1), ofs=-1}
			self:addButtonBorder{obj=self:getChild(this.SaveAs.Target, 1), ofs=-1}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=this.CheckButton}
			self:skinCheckButton{obj=this.SaveAs.Themselves}
			self:skinCheckButton{obj=this.ShareIncludes.IncludePreferences}
			self:skinCheckButton{obj=this.ShareIncludes.IncludeNotes}
		end

    	self:Unhook(this, "OnShow")
    end)

    self:SecureHookScript(_G.RematchNotes, "OnShow", function(this)
	    self:removeRegions(this.Content, {1, 2, 3})
		self:skinObject("slider", {obj=this.Content.ScrollFrame.ScrollBar, x1=3, x2=-4})
		self:skinObject("frame", {obj=this.Content, ng=true, ofs=0})
		self:skinObject("frame", {obj=this, kfs=true, cb=true, x1=-3, y1=2, x2=1, y2=-2})
		if self.modBtns then
			self:skinStdButton{obj=this.LockButton, ofs=-6}
			self:skinStdButton{obj=this.Controls.DeleteButton}
			self:skinStdButton{obj=this.Controls.UndoButton}
			self:skinStdButton{obj=this.Controls.SaveButton}
			self:removeRegions(this.CloseButton, {5})
		end
	    self:removeRegions(this.LockButton, {5})

    	self:Unhook(this, "OnShow")
    end)

    -- Tooltip(s) N.B. skin these rather than treat them as tooltips as their background changes
	self:skinObject("frame", {obj=_G.RematchTooltip, kfs=true})
	self:skinObject("frame", {obj=_G.RematchTableTooltip, kfs=true})

end
