local aName, aObj = ...
if not aObj:isAddonEnabled("Rematch") then return end
local _G = _G

aObj.addonsToSkin.Rematch = function(self) -- v 4.9.0

    local tab, btn, pet

    -- Journal (used when integrated with PetJournal)
    -- tabs
    for i = 1, #_G.RematchJournal.PanelTabs.Tabs do
        tab = _G.RematchJournal.PanelTabs.Tabs[i]
        for j = 1, 3 do
            tab.Inactive[j]:SetTexture(nil)
            tab.Active[j]:SetTexture(nil)
        end
		self:addSkinFrame{obj=tab, ft="a", noBdr=self.isTT, x1=8, y1=0, x2=-8, y2=3}
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
		tab = nil
    end)
	if _G.RematchJournal.CollectMeButton then
		self:removeMagicBtnTex(_G.RematchJournal.CollectMeButton)
		if self.modBtns then
			self:skinStdButton{obj=_G.RematchJournal.CollectMeButton}
		end
	end
    self:addSkinFrame{obj=_G.RematchJournal, ft="a", kfs=true, aso={ba=1}, x1=-4, y1=2, x2=1, y2=-5}

    -- Frame (used when standalone)
    _G.RematchFrame:DisableDrawLayer("BACKGROUND")
    _G.RematchFrame:DisableDrawLayer("BORDER")
    self:keepFontStrings(_G.RematchFrame.TitleBar)
	if self.modBtns then
		self:skinStdButton{obj=_G.RematchFrame.TitleBar.LockButton, ofs=-6}
		self:skinStdButton{obj=_G.RematchFrame.TitleBar.SinglePanelButton, ofs=-6}
	    self:skinOtherButton{obj=_G.RematchFrame.TitleBar.MinimizeButton, text=""} -- uses existing texture
		self:skinCloseButton{obj=_G.RematchFrame.TitleBar.CloseButton}
	end
	-- remove these textures after buttons skinned, otherwise texture remains for some reason
    self:removeRegions(_G.RematchFrame.TitleBar.LockButton, {5})
    self:removeRegions(_G.RematchFrame.TitleBar.SinglePanelButton, {5})
    self:removeRegions(_G.RematchFrame.TitleBar.MinimizeButton, {5})
    self:removeRegions(_G.RematchFrame.TitleBar.CloseButton, {5})
    -- tabs
    for i = 1, #_G.RematchFrame.PanelTabs.Tabs do
        tab = _G.RematchFrame.PanelTabs.Tabs[i]
        for j = 1, 3 do
            tab.Inactive[j]:SetTexture(nil)
            tab.Active[j]:SetTexture(nil)
        end
		self:addSkinFrame{obj=tab, ft="a", noBdr=self.isTT, x1=8, y1=0, x2=-8, y2=3}
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
	if _G.RematchFrame.TitleBar:IsShown() then
		self:addSkinFrame{obj=_G.RematchFrame, ft="a", kfs=true, nb=true, x1=-4, y1=2, x2=1, y2=-5}
	else
        self:addSkinFrame{obj=_G.RematchFrame, ft="a", kfs=true, nb=true, x1=-4, y1=-24, x2=1, y2=-5}
	end
    -- hook these to handle resize of skinframe when TitleBar is hidden/shown
    local function resizeFrame(showTitleBar)
        if showTitleBar then
			_G.RematchFrame.sf:ClearAllPoints()
			_G.RematchFrame.sf:SetPoint("TOPLEFT", _G.RematchFrame, "TOPLEFT", -4, 2)
			_G.RematchFrame.sf:SetPoint("BOTTOMRIGHT", _G.RematchFrame, "BOTTOMRIGHT", 1, -5)
        else
			_G.RematchFrame.sf:ClearAllPoints()
			_G.RematchFrame.sf:SetPoint("TOPLEFT", _G.RematchFrame, "TOPLEFT", -4, -24)
			_G.RematchFrame.sf:SetPoint("BOTTOMRIGHT", _G.RematchFrame, "BOTTOMRIGHT", 1, -5)
        end
    end
    self:SecureHook(_G.RematchFrame.TitleBar, "SetShown", function(this, value)
        resizeFrame(value)
    end)
    self:SecureHook(_G.RematchFrame.TitleBar, "Show", function(this)
        resizeFrame(true)
    end)

    -- Toolbar
    self:removeInset(_G.RematchToolbar.PetCount)
    self:removeRegions(_G.RematchToolbar.Achievement, {4, 5})
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
    self:SecureHook(_G.RematchToolbar, "ButtonOnEnter", function(this, once)
        if not this.tooltipTitle then
            self:skinTooltip(_G.GameTooltip)
        end
    end)

    -- MiniPanel
    for i = 1, 3 do
        pet = _G.RematchMiniPanel.Pets[i]
        pet.HP:DisableDrawLayer("OVERLAY")
		self:skinStatusBar{obj=pet.HP, fi=0, bgTex=self:getRegion(pet.HP, 6)}
        pet.XP:DisableDrawLayer("OVERLAY")
		self:skinStatusBar{obj=pet.XP, fi=0, bgTex=self:getRegion(pet.XP, 4)}
    end
    self:removeInset(_G.RematchMiniPanel.Background)
    self:removeInset(_G.RematchMiniPanel.Target)
    self:addSkinFrame{obj=_G.RematchMiniPanel.Flyout, ft="a", kfs=true, nb=true}
	if self.modBtnBs then
		self:addButtonBorder{obj=_G.RematchMiniPanel.Target.ModelBorder}
	end

    -- Menu (replaces dropdowns)
    self:RawHook(_G.Rematch, "GetMenuFrame", function(this, level, parent)
        local frame = self.hooks[this].GetMenuFrame(this, level, parent)
        if not frame.sf then
            self:removeRegions(frame, {1, 2})
            self:removeRegions(frame.Title, {1, 2})
            self:addSkinFrame{obj=frame, ft="a", nb=true, ofs=0}
        end
        return frame
    end, true)

	local function skinScrollFrame(frame)
	    aObj:removeInset(frame.List.Background)
	    aObj:skinSlider{obj=frame.List.ScrollFrame.ScrollBar, adj=-4, rt="artwork"}
		aObj:SecureHook(frame.List, "Update", function(this)
			if not this.ScrollFrame.Buttons then return end
			local btn
		    for i = 1, #this.ScrollFrame.Buttons do
		        btn = this.ScrollFrame.Buttons[i]
		        btn:SetBackdrop(nil)
		        btn:DisableDrawLayer("BACKGROUND")
		    end
			btn = nil
		end)
	end
    -- PetPanel (Tab1)
    self:removeInset(_G.RematchPetPanel.Top)
	if self.modBtnBs then
	    self:addButtonBorder{obj=_G.RematchPetPanel.Top.Toggle, ofs=0}
	    self:addButtonBorder{obj=_G.RematchPetPanel.Top.Filter, ofs=0}
	end
    self:skinUsingBD{obj=_G.RematchPetPanel.Top.SearchBox}
    _G.RematchPetPanel.Top.SearchBox:SetWidth(_G.RematchPetPanel.Top.SearchBox:GetWidth() - 5)
    -- tabs (3)
    for i = 1, 3 do
        tab = _G.RematchPetPanel.Top.TypeBar.Tabs[i]
		self:addSkinFrame{obj=tab, ft="a", noBdr=self.isTT, ofs=0, x1=4, y2=-2, x2=-4}
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
		tab = nil
    end)
    for i = 1, #_G.RematchPetPanel.Top.TypeBar.Buttons do
        _G.RematchPetPanel.Top.TypeBar.Buttons[i].IconBorder:SetTexture(nil)
    end
    self:addSkinFrame{obj=_G.RematchPetPanel.Top.TypeBar, ft="a", kfs=true, nb=true, y1=1}

    self:removeInset(_G.RematchPetPanel.Results)
	skinScrollFrame(_G.RematchPetPanel)

    -- BottomPanel
	self:removeMagicBtnTex(_G.RematchBottomPanel.FindBattleButton)
	self:removeMagicBtnTex(_G.RematchBottomPanel.SaveAsButton)
	self:removeMagicBtnTex(_G.RematchBottomPanel.SaveButton)
	self:removeMagicBtnTex(_G.RematchBottomPanel.SummonButton)
	if self.modBtns then
		self:skinStdButton{obj=_G.RematchBottomPanel.SummonButton}
		self:skinStdButton{obj=_G.RematchBottomPanel.SaveButton}
		self:skinStdButton{obj=_G.RematchBottomPanel.SaveAsButton}
		self:skinStdButton{obj=_G.RematchBottomPanel.FindBattleButton}
	end
	if self.modChkBtns then
		self:skinCheckButton{obj=_G.RematchBottomPanel.UseDefault}
	end

    -- LoadoutPanel
    for i = 1, 3 do
        pet = _G.RematchLoadoutPanel.Loadouts[i]
        self:removeInset(pet)
        pet.XP:DisableDrawLayer("OVERLAY")
		self:skinStatusBar{obj=pet.XP, fi=0, bgTex=self:getRegion(pet.XP, 11)}
        pet.HP:DisableDrawLayer("OVERLAY")
		self:skinStatusBar{obj=pet.HP, fi=0, bgTex=self:getRegion(pet.HP, 6)}
    end
    self:removeInset(_G.RematchLoadoutPanel.Target)
    self:removeRegions(_G.RematchLoadoutPanel.Target, {11}) -- line
    self:addSkinFrame{obj=_G.RematchLoadoutPanel.Flyout, ft="a", kfs=true, nb=true}
	if self.modBtns then
		self:skinStdButton{obj=_G.RematchLoadoutPanel.Target.LoadSaveButton}
	end
	if self.modBtnBs then
	    self:addButtonBorder{obj=_G.RematchLoadoutPanel.Target.TargetButton, ofs=0}
	    self:addButtonBorder{obj=_G.RematchLoadoutPanel.Target.ModelBorder}
	end

    -- TeamPanel (Tab2)
    self:removeInset(_G.RematchTeamPanel.Top)
	if self.modBtnBs then
		self:addButtonBorder{obj=_G.RematchTeamPanel.Top.Teams, ofs=0}
	end
    self:skinUsingBD{obj=_G.RematchTeamPanel.Top.SearchBox}
    _G.RematchTeamPanel.Top.SearchBox:SetWidth(_G.RematchTeamPanel.Top.SearchBox:GetWidth() - 5)
	skinScrollFrame(_G.RematchTeamPanel)

    -- TeamTabs
	self:SecureHook(_G.RematchTeamTabs, "GetTabButton", function(this, index)
        local tab = _G.RematchTeamTabs.Tabs[index]
        tab:DisableDrawLayer("BACKGROUND")
		if self.modBtnBs then
			self:addButtonBorder{obj=tab, ofs=4, relTo=tab.Icon}
		end
		tab = nil
	end)

    -- QueuePanel (Tab3)
    self:removeInset(_G.RematchQueuePanel.Top)
	if self.modBtnBs then
		self:addButtonBorder{obj=_G.RematchQueuePanel.Top.QueueButton, ofs=0}
	end
    self:removeInset(_G.RematchQueuePanel.Status)
	skinScrollFrame(_G.RematchQueuePanel)

    -- OptionPanel (Tab4)
    self:removeInset(_G.RematchOptionPanel)
	skinScrollFrame(_G.RematchOptionPanel)

    -- LoadedTeamPanel
    _G.RematchLoadedTeamPanel:DisableDrawLayer("BACKGROUND")
    self:removeInset(_G.RematchLoadedTeamPanel)
    self:removeInset(_G.RematchLoadedTeamPanel.Footnotes)

    -- AbilityCard (Tooltip)
    _G.RematchAbilityCard:DisableDrawLayer("BACKGROUND")
    self:removeRegions(_G.RematchAbilityCard, {14}) -- line
    _G.RematchAbilityCard.Hints:DisableDrawLayer("BACKGROUND")
    self:removeRegions(_G.RematchAbilityCard.Hints, {2, 9}) -- line & doodad
    self:addSkinFrame{obj=_G.RematchAbilityCard, ft="a", kfs=true, nb=true}

    -- PetCard (Tooltip)
    -- hook this to manage the displaying of the PetCard and child panels (Front, Back) so that title is displayed
    self:RawHook(_G.RematchPetCard, "SetAlpha", function(this, alpha)
        if alpha == 0 then
            self:addSkinFrame{obj=this, ft="a", kfs=true, nb=true, ofs=-2, y1=-20}
        else
            self:addSkinFrame{obj=this, ft="a", kfs=true, nb=true, x1=-3, y1=2, x2=1}
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
    self:removeRegions(_G.RematchPetCard.Front.Middle, {12}) -- line
    _G.RematchPetCard.Front.Middle.XP:DisableDrawLayer("OVERLAY")
	self:skinStatusBar{obj=_G.RematchPetCard.Front.Middle.XP, fi=0, bgTex=self:getRegion(_G.RematchPetCard.Front.Middle.XP, 11)}
    _G.RematchPetCard.Front.Middle.BreedTable:SetBackdrop(nil)
    _G.RematchPetCard.Back:SetBackdrop(nil)
    _G.RematchPetCard.Back.Source:DisableDrawLayer("BACKGROUND")
    self:removeRegions(_G.RematchPetCard.Back.Source, {3}) -- line
    _G.RematchPetCard.Back.Bottom:DisableDrawLayer("BACKGROUND")
    self:removeRegions(_G.RematchPetCard.Back.Bottom, {2, 15, 16}) -- line & doodads
    _G.RematchPetCard.Back.Middle:DisableDrawLayer("BACKGROUND")
    _G.RematchPetCard.Back.Middle:DisableDrawLayer("BORDER") -- doodads
	self:removeRegions(_G.RematchPetCard.Back.Middle, {7}) -- line above middle area
    _G.RematchPetCard.Back.Middle.Lore:SetTextColor(self.BTr, self.BTg, self.BTb)

    -- Tooltip(s) N.B. skin these rather than treat them as tooltips as their background changes
	self:addSkinFrame{obj=_G.RematchTooltip, ft="a", kfs=true, nb=true}
	self:addSkinFrame{obj=_G.RematchTableTooltip, ft="a", kfs=true, nb=true}

    -- Dialog
    _G.RematchDialog.Prompt:DisableDrawLayer("BACKGROUND")
    _G.RematchDialog.Prompt:DisableDrawLayer("BORDER")
    self:skinUsingBD{obj=_G.RematchDialog.EditBox}
    _G.RematchDialog.TabPicker:DisableDrawLayer("BORDER")
	if self.modBtnBs then
		self:addButtonBorder{obj=self:getChild(_G.RematchDialog.TabPicker, 1), ofs=-1}
	end
	self:removeMagicBtnTex(_G.RematchDialog.Cancel)
	self:removeMagicBtnTex(_G.RematchDialog.Accept)
	self:removeMagicBtnTex(_G.RematchDialog.Other)
    self:addSkinFrame{obj=_G.RematchDialog, ft="a", kfs=true, y1=2, x2=1, y2=-2}
	if self.modBtns then
		self:skinStdButton{obj=_G.RematchDialog.Cancel}
		self:skinStdButton{obj=_G.RematchDialog.Accept}
		self:skinStdButton{obj=_G.RematchDialog.Other}
	end
    self:removeRegions(_G.RematchDialog.CloseButton, {5})

    -- TeamTabIconPicker
    self:removeInset(_G.RematchDialog.TeamTabIconPicker)
    self:skinSlider{obj=_G.RematchTeamTabIconPickerScrollBar, adj=-4}

    -- SaveAs
    self:skinUsingBD{obj=_G.RematchDialog.SaveAs.Name}
    self:addSkinFrame{obj=_G.RematchDialog.SaveAs.Target, ft="a", kfs=true, nb=true, ofs=0}
	if self.modBtnBs then
		self:addButtonBorder{obj=self:getChild(_G.RematchDialog.SaveAs.Target, 1), ofs=-1}
	end

    -- Notes
    _G.RematchNotes.Content:SetBackdrop(nil)
    self:removeRegions(_G.RematchNotes.Content, {1, 2, 3, 4})
    self:skinSlider{obj=_G.RematchNotes.Content.ScrollFrame.ScrollBar, adj=-4}
    self:addSkinFrame{obj=_G.RematchNotes, ft="a", kfs=true, x1=-3, y1=2, x2=1, y2=-2}
	if self.modBtns then
		self:skinStdButton{obj=_G.RematchNotes.LockButton, ofs=-6}
		self:skinStdButton{obj=_G.RematchNotes.Controls.DeleteButton}
		self:skinStdButton{obj=_G.RematchNotes.Controls.UndoButton}
		self:skinStdButton{obj=_G.RematchNotes.Controls.SaveButton}
	end
    self:removeRegions(_G.RematchNotes.LockButton, {5})
    self:removeRegions(_G.RematchNotes.CloseButton, {5})

end
