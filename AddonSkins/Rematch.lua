local aName, aObj = ...
if not aObj:isAddonEnabled("Rematch") then return end
local _G = _G

function aObj:Rematch()

    local tab, btn, pet

    -- Journal (used when integrated with PetJournal)
    -- tabs
    for i = 1, #_G.RematchJournal.PanelTabs.Tabs do
        tab = _G.RematchJournal.PanelTabs.Tabs[i]
        for j = 1, 3 do
            tab.Inactive[j]:SetTexture(nil)
            tab.Active[j]:SetTexture(nil)
        end
		self:addSkinFrame{obj=tab, noBdr=self.isTT, x1=8, y1=0, x2=-8, y2=3}
        if i == _G.RematchSettings.JournalPanel then
            if self.isTT then self:setActiveTab(tab.sf) end
        else
            if self.isTT then self:setInactiveTab(tab.sf) end
        end
    end
    self:SecureHook(_G.Rematch, "SelectPanelTab", function(this, parent, index)
        local tab
        for i = 1, #parent.Tabs do
            tab = parent.Tabs[i]
            if i == index then
                if self.isTT then self:setActiveTab(tab.sf) end
            else
                if self.isTT then self:setInactiveTab(tab.sf) end
            end
        end
    end)
    self:addSkinFrame{obj=_G.RematchJournal, kfs=true, aso={ba=1}, y1=2, x2=1, y2=-5}

    -- Frame (used when standalone)
    _G.RematchFrame:DisableDrawLayer("BACKGROUND")
    _G.RematchFrame:DisableDrawLayer("BORDER")
    self:keepFontStrings(_G.RematchFrame.TitleBar)
    _G.RematchFrame.TitleBar.LockButton:SetBackdrop(nil)
    _G.RematchFrame.TitleBar.LockButton:DisableDrawLayer("OVERLAY")
    self:skinButton{obj=_G.RematchFrame.TitleBar.MinimizeButton, ob="–"} -- Alt+hyphen
    _G.RematchFrame.TitleBar.MinimizeButton:DisableDrawLayer("OVERLAY")
    _G.RematchFrame.TitleBar.NarrowModeButton:SetBackdrop(nil)
    _G.RematchFrame.TitleBar.NarrowModeButton:DisableDrawLayer("OVERLAY")
    -- tabs
    for i = 1, #_G.RematchFrame.PanelTabs.Tabs do
        tab = _G.RematchFrame.PanelTabs.Tabs[i]
        for j = 1, 3 do
            tab.Inactive[j]:SetTexture(nil)
            tab.Active[j]:SetTexture(nil)
        end
		self:addSkinFrame{obj=tab, noBdr=self.isTT, x1=8, y1=0, x2=-8, y2=3}
        if i == _G.RematchSettings.ActivePanel then
            if self.isTT then self:setActiveTab(tab.sf) end
        else
            if self.isTT then self:setInactiveTab(tab.sf) end
        end
    end
    self:SecureHook(_G.RematchFrame, "SelectPanel", function(this, index, unselect)
        local tab
        for i = 1, #this.PanelTabs.Tabs do
            tab = this.PanelTabs.Tabs[i]
            if i == index then
                if self.isTT then self:setActiveTab(tab.sf) end
            else
                if self.isTT then self:setInactiveTab(tab.sf) end
            end
        end
    end)
    -- hook these to handle resize of skinframe when TitleBar is hidden/shown
    local function resizeFrame(showTitleBar)
        if showTitleBar then
            aObj:addSkinFrame{obj=_G.RematchFrame, bgen=1, x1=-4, y1=2, x2=1, y2=-5} -- don't skin TypeBar Tab buttons
        else
            aObj:addSkinFrame{obj=_G.RematchFrame, bgen=1, x1=-4, y1=-24, x2=1, y2=-5} -- don't skin TypeBar Tab buttons
        end
    end
    self:SecureHook(_G.RematchFrame.TitleBar, "SetShown", function(this, value)
        resizeFrame(value)
    end)
    self:SecureHook(_G.RematchFrame.TitleBar, "Show", function(this)
        resizeFrame(true)
    end)

    -- TopPanel
    self:removeInset(_G.RematchTopPanel.PetCount)
    self:removeRegions(_G.RematchTopPanel.AchievementStatus, {4, 5})

    -- Toolbar
    self:addButtonBorder{obj=_G.RematchToolbar.HealButton}
    self:addButtonBorder{obj=_G.RematchToolbar.BandageButton}
    self:addButtonBorder{obj=_G.RematchToolbar.PetTreatButton}
    self:addButtonBorder{obj=_G.RematchToolbar.LesserTreatButton}
    self:addButtonBorder{obj=_G.RematchToolbar.SafariButton}
    self:addButtonBorder{obj=_G.RematchToolbar.SummonButton}
    self:addButtonBorder{obj=_G.RematchToolbar.FindBattleButton}
    -- N.B. have to hook this as it changes the GameTooltip border colour
    self:SecureHook(_G.RematchToolbar, "ButtonOnEnter", function(this, once)
        if not this.tooltipTitle then
            self:skinTooltip(_G.GameTooltip)
        end
    end)

    -- MiniPanel
    for i = 1, 3 do
        pet = _G.RematchMiniPanel.Pets[i]
        pet.HP:DisableDrawLayer("OVERLAY")
        self:glazeStatusBar(pet.HP, 0,self:getRegion(pet.HP, 6))
        pet.XP:DisableDrawLayer("OVERLAY")
        self:glazeStatusBar(pet.XP, 0, self:getRegion(pet.XP, 4))
    end
    self:removeInset(_G.RematchMiniPanel)
    self:addSkinFrame{obj=_G.RematchMiniPanel.Flyout}
    self:removeInset(_G.RematchMiniPanel.Target)
    self:addButtonBorder{obj=_G.RematchMiniPanel.Target.ModelBorder}

    -- NarrowPanel
    self:addButtonBorder{obj=_G.RematchNarrowPanel.SaveAsButton}
    self:addButtonBorder{obj=_G.RematchNarrowPanel.SaveButton}

    -- Menu (replaces dropdowns)
    self:RawHook(_G.Rematch, "GetMenuFrame", function(this, level, parent)
        local frame = self.hooks[this].GetMenuFrame(this, level, parent)
        if not frame.sknd then
            self:removeRegions(frame, {1, 2})
            self:removeRegions(frame.Title, {1, 2})
            self:addSkinFrame{obj=frame, nb=true, ofs=0} -- ignore buttons
        end
        return frame
    end, true)

    -- PetPanel (Tab1)
    self:removeInset(_G.RematchPetPanel.Top)
    self:addButtonBorder{obj=_G.RematchPetPanel.Top.Toggle, ofs=0}
    self:addButtonBorder{obj=_G.RematchPetPanel.Top.Filter, ofs=0}
    self:skinUsingBD{obj=_G.RematchPetPanel.Top.SearchBox}
    _G.RematchPetPanel.Top.SearchBox:SetWidth(_G.RematchPetPanel.Top.SearchBox:GetWidth() - 5)
    -- tabs (3)
    for i = 1, 3 do
        tab = _G.RematchPetPanel.Top.TypeBar.Tabs[i]
		self:addSkinFrame{obj=tab, noBdr=self.isTT, ofs=0, x1=2}
        tab.sf.ignore = true
        tab:DisableDrawLayer("BACKGROUND")
        tab.Selected:DisableDrawLayer("ARTWORK")
        if i == 1 then
            if self.isTT then self:setActiveTab(tab.sf) end
        else
            if self.isTT then self:setInactiveTab(tab.sf) end
        end
    end
    self:SecureHook(_G.RematchPetPanel, "TypeBarTabOnClick", function(this)
        local tab
        for i = 1, 3 do
            tab = _G.RematchPetPanel.Top.TypeBar.Tabs[i]
            if i == this:GetID() then
                if self.isTT then self:setActiveTab(tab.sf) end
            else
                if self.isTT then self:setInactiveTab(tab.sf) end
            end
        end

    end)
    self:addSkinFrame{obj=_G.RematchPetPanel.Top.TypeBar, nb=true, y1=1} -- don't skin buttons
    for i = 1, #_G.RematchPetPanel.Top.TypeBar.Buttons do
        _G.RematchPetPanel.Top.TypeBar.Buttons[i].IconBorder:SetTexture(nil)
    end
    self:removeInset(_G.RematchPetPanel.Results)
    self:removeInset(_G.RematchPetPanel.List)
    self:skinSlider{obj=_G.RematchPetListScrollBar, adj=-4}
    for i = 1, #_G.RematchPetPanel.List.ScrollFrame.buttons do
        btn = _G.RematchPetPanel.List.ScrollFrame.buttons[i]
        btn:SetBackdrop(nil)
        btn:DisableDrawLayer("BACKGROUND")
    end

    -- BottomPanel
    self:skinAllButtons{obj=_G.RematchBottomPanel, rmbt=true}

    -- LoadoutPanel
    for i = 1, 3 do
        pet = _G.RematchLoadoutPanel.Loadouts[i]
        self:removeInset(pet)
        pet.XP:DisableDrawLayer("OVERLAY")
        self:glazeStatusBar(pet.XP, 0,  self:getRegion(pet.XP, 11))
        pet.HP:DisableDrawLayer("OVERLAY")
        self:glazeStatusBar(pet.HP, 0, self:getRegion(pet.HP, 6))
    end
    self:removeInset(_G.RematchLoadoutPanel.Target)
    self:removeRegions(_G.RematchLoadoutPanel.Target, {11}) -- line
    self:addButtonBorder{obj=_G.RematchLoadoutPanel.Target.TargetButton, ofs=0}
    self:skinButton{obj=_G.RematchLoadoutPanel.Target.LoadSaveButton}
    self:addButtonBorder{obj=_G.RematchLoadoutPanel.Target.ModelBorder}
    self:addSkinFrame{obj=_G.RematchLoadoutPanel.Flyout}

    -- TeamPanel (Tab2)
    self:removeInset(_G.RematchTeamPanel.Top)
    self:addButtonBorder{obj=_G.RematchTeamPanel.Top.Toggle, ofs=0}
    self:addButtonBorder{obj=_G.RematchTeamPanel.Top.Teams, ofs=0}
    self:skinUsingBD{obj=_G.RematchTeamPanel.Top.SearchBox}
    _G.RematchTeamPanel.Top.SearchBox:SetWidth(_G.RematchTeamPanel.Top.SearchBox:GetWidth() - 5)
    self:addButtonBorder{obj=_G.RematchTeamPanel.Top.Team, ofs=0}
    self:removeInset(_G.RematchTeamPanel.List)
    self:skinSlider{obj=_G.RematchTeamListScrollBar, adj=-4}
    for i = 1, #_G.RematchTeamPanel.List.ScrollFrame.buttons do
        btn = _G.RematchTeamPanel.List.ScrollFrame.buttons[i]
        btn:SetBackdrop(nil)
        btn:DisableDrawLayer("BACKGROUND")
    end
    -- TeamTabs
    for i = 1, #_G.RematchTeamTabs.Tabs do
        tab = _G.RematchTeamTabs.Tabs[i]
        tab:DisableDrawLayer("BACKGROUND")
        self:addButtonBorder{obj=tab, ofs=4}
    end

    -- QueuePanel (Tab3)
    self:removeInset(_G.RematchQueuePanel.Top)
    self:addButtonBorder{obj=_G.RematchQueuePanel.Top.QueueButton, ofs=0}
    self:addButtonBorder{obj=_G.RematchQueuePanel.Top.Toggle, ofs=0}
    self:removeRegions(_G.RematchQueuePanel.Top.LevelingSlot, {18}) -- line
    _G.RematchQueuePanel.Top.LevelingSlot:SetBackdrop(nil)
    _G.RematchQueuePanel.Top.LevelingSlot:DisableDrawLayer("BACKGROUND")
    self:removeInset(_G.RematchQueuePanel.Status)
    self:removeInset(_G.RematchQueuePanel.List)
    self:skinSlider{obj=_G.RematchQueueListScrollBar, adj=-4}
    for i = 1, #_G.RematchQueuePanel.List.ScrollFrame.buttons do
        btn = _G.RematchQueuePanel.List.ScrollFrame.buttons[i]
        btn:SetBackdrop(nil)
        btn:DisableDrawLayer("BACKGROUND")
    end

    -- OptionPanel (Tab4)
    self:removeInset(_G.RematchOptionPanel)
    self:removeInset(_G.RematchOptionPanel.List)
    self:skinSlider{obj=_G.RematchOptionListScrollBar, adj=-4}
    for i = 1, #_G.RematchOptionPanel.List.ScrollFrame.buttons do
        btn = _G.RematchOptionPanel.List.ScrollFrame.buttons[i]
        btn.Header:DisableDrawLayer("BACKGROUND")
    end

    -- LoadedTeamPanel
    _G.RematchLoadedTeamPanel:DisableDrawLayer("BACKGROUND")
    self:removeInset(_G.RematchLoadedTeamPanel)
    self:removeInset(_G.RematchLoadedTeamPanel.Footnotes)
    self:skinAllButtons{obj=_G.RematchLoadedTeamPanel.Footnotes}

    -- AbilityCard (Tooltip)
    _G.RematchAbilityCard:DisableDrawLayer("BACKGROUND")
    self:removeRegions(_G.RematchAbilityCard, {14}) -- line
    _G.RematchAbilityCard.Hints:DisableDrawLayer("BACKGROUND")
    self:removeRegions(_G.RematchAbilityCard.Hints, {2, 9}) -- line & doodad
    self:addSkinFrame{obj=_G.RematchAbilityCard}

    -- PetCard (Tooltip)
    -- hook this to manage the displaying of the PetCard and child panels (Front, Back) so that title is displayed
    self:RawHook(_G.RematchPetCard, "SetAlpha", function(this, alpha)
        if alpha == 0 then
            self:addSkinFrame{obj=this, kfs=true, ofs=-2, y1=-20}
        else
            self:addSkinFrame{obj=this, kfs=true, x1=-3, y1=2, x2=1}
        end
        this.PinButton:SetAlpha(alpha)
        this.PetCardTitle:SetAlpha(alpha)
        this.CloseButton:SetAlpha(alpha)
    end, true)
    _G.RematchPetCard.PinButton:SetBackdrop(nil)
    self:removeRegions(_G.RematchPetCard.PinButton, {1})
    _G.RematchPetCard.Title:DisableDrawLayer("BACKGROUND")
    _G.RematchPetCard.Front:SetBackdrop(nil)
    _G.RematchPetCard.Front.Bottom:DisableDrawLayer("BACKGROUND")
    self:removeRegions(_G.RematchPetCard.Front.Bottom, {2}) -- line
    _G.RematchPetCard.Front.Middle:DisableDrawLayer("BACKGROUND")
    self:removeRegions(_G.RematchPetCard.Front.Middle, {11}) -- line
    _G.RematchPetCard.Front.Middle.XP:DisableDrawLayer("OVERLAY")
    self:glazeStatusBar(_G.RematchPetCard.Front.Middle.XP, 0, self:getRegion(_G.RematchPetCard.Front.Middle.XP, 11))
    _G.RematchPetCard.Front.Middle.BreedTable:SetBackdrop(nil)
    _G.RematchPetCard.Back:SetBackdrop(nil)
    _G.RematchPetCard.Back.Source:DisableDrawLayer("BACKGROUND")
    self:removeRegions(_G.RematchPetCard.Back.Source, {3}) -- line
    _G.RematchPetCard.Back.Bottom:DisableDrawLayer("BACKGROUND")
    self:removeRegions(_G.RematchPetCard.Back.Bottom, {2, 15, 16}) -- line & doodads
    _G.RematchPetCard.Back.Middle:DisableDrawLayer("BACKGROUND")
    self:removeRegions(_G.RematchPetCard.Back.Middle, {2}) -- line
    _G.RematchPetCard.Back.Middle.Lore:SetTextColor(self.BTr, self.BTg, self.BTb)

    -- Tooltip(s)
    self:addSkinFrame{obj=_G.RematchTooltip}
    self:addSkinFrame{obj=_G.RematchTableTooltip}

    -- Dialog
    _G.RematchDialog.Prompt:DisableDrawLayer("BACKGROUND")
    _G.RematchDialog.Prompt:DisableDrawLayer("BORDER")
    self:skinUsingBD{obj=_G.RematchDialog.EditBox}
    _G.RematchDialog.TabPicker:DisableDrawLayer("BORDER")
    self:addSkinFrame{obj=_G.RematchDialog.TabPicker}
    self:addSkinFrame{obj=_G.RematchDialog, kfs=true, rmbt=true, y1=2, x2=1, y2=-2}

    -- TeamTabIconPicker
    self:removeInset(_G.RematchDialog.TeamTabIconPicker)
    self:skinSlider{obj=_G.RematchTeamTabIconPickerScrollBar, adj=-4}
    self:skinUsingBD{obj=_G.RematchDialog.TeamTabIconPicker.Search}

    -- SaveAs
    self:skinUsingBD{obj=_G.RematchDialog.SaveAs.Name}
    self:addSkinFrame{obj=_G.RematchDialog.SaveAs.Target}

    -- Notes
    self:addSkinFrame{obj=_G.RematchNotes, kfs=true, x1=-3, y1=2, x2=1, y2=-2}
    _G.RematchNotes.LockButton:SetBackdrop(nil)
    self:removeRegions(_G.RematchNotes.LockButton, {1})
    _G.RematchNotes.Content:SetBackdrop(nil)
    self:removeRegions(_G.RematchNotes.Content, {1, 2, 3, 4})
    self:skinSlider{obj=_G.RematchNotes.Content.ScrollFrame.ScrollBar, adj=-4}

end
