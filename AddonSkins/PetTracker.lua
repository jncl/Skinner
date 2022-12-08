local _, aObj = ...
if not aObj:isAddonEnabled("PetTracker") then return end
local _G = _G

aObj:SecureHook(_G.PetTracker, "NewModule", function(this, name, object)
	if name == "TrackToggle"
	and aObj.modChkBtns
	then
		aObj:skinCheckButton{obj=object}
		aObj:Unhook(this, "NewModule")
	end
end, true)
-- Journal/Switcher slots
local function skinSlot(slot, isBattle)
	if not slot.sf then
		slot.Bg:SetTexture(nil)
		slot.IconBorder:SetTexture(nil)
		slot.Quality:SetTexture(nil)
		aObj:changeTandC(slot.LevelBG)
		if aObj.modBtnBs then
			aObj:addButtonBorder{obj=slot, relTo=slot.Icon, reParent={slot.LevelBG, slot.Level}}
			aObj:SecureHook(slot.Quality, "SetVertexColor", function(this, r, g, b)
				slot.sbb:SetBackdropBorderColor(r, g, b, 1)
			end)
		end
		for _, btn in _G.pairs(slot.Abilities) do
			aObj:getRegion(btn, 1):SetTexture(nil)
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=btn, relTo=btn.icon, reParent={btn.Type}}
			end
		end
		if isBattle then
			aObj:skinObject("statusbar", {obj=slot.Health, regions={2, 3, 4, 5}, fi=0})
			aObj:skinObject("statusbar", {obj=slot.Xp, regions={2, 3, 4, 5}, fi=0})
		end
		aObj:skinObject("frame", {obj=slot, fb=true, ofs=4, x1=-7, x2=6})
	end
	-- IsEmpty frame, covers slot, don't skin it
	-- IsDead frame
end
aObj.addonsToSkin.PetTracker = function(self) -- v 9.1.0

	if _G.PetTracker.Objectives
	and _G.PetTracker.Objectives.Header
	then
		_G.PetTracker.Objectives.Header.Background:SetTexture(nil)
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.PetTracker.Objectives.Header.MinimizeButton, es=12, ofs=1, x1=-1}
		end
	end

	-- ProgressBars
	local function skinBarObj(obj)
		aObj:keepFontStrings(obj.Overlay)
		for _, bar in _G.pairs(obj.Bars) do
			bar:SetStatusBarTexture(aObj.sbTexture)
		end
	end
	self:RawHook(_G.PetTracker.ProgressBar, "New", function(...)
		local barObj = self.hooks[this].New(...)
		skinBarObj(barObj)
		return barObj
	end, true)
	for obj, _ in _G.pairs(_G.PetTracker.ProgressBar.__frames) do
		skinBarObj(obj)
	end

	-- Tooltips
	local function skinTT(obj)
		_G.C_Timer.After(0.1, function()
			aObj:add2Table(aObj.ttList, obj)
		end)
	end
	self:RawHook(_G.PetTracker.MultiTip, "Construct", function(...)
		local tTip = self.hooks[this].Construct(...)
		skinTT(tTip)
		return tTip
	end, true)
	for obj, _ in _G.pairs(_G.PetTracker.MultiTip.__frames) do
		skinTT(obj)
	end

	self:SecureHook(_G.PetTracker.PetSlot, "Construct", function(this)
		-- wait for all the slots to be created (Journal has 3, switcher has 6)
		if (this.__template == "PetTrackerJournalSlot" and this.__count == 3)
		or (this.__template == "PetTrackerBattleSlot" and this.__count == 6)
		then
			_G.C_Timer.After(0.25, function()
				for obj, _ in _G.pairs(this.__frames) do
					skinSlot(obj, this.__template == "PetTrackerBattleSlot" and true)
				end
			end)
		end
	end, true)

end

aObj.lodAddons.PetTracker_Battle = function(self) -- v 9.1.0
	if self.initialized.PetTracker_Battle then return end
	self.initialized.PetTracker_Battle = true

	self:SecureHookScript(_G.PetTrackerSwitcher, "OnShow", function(this)
		self:keepFontStrings(self:getChild(this, 4)) -- slot borders
		self:keepFontStrings(self:getChild(this, 5)) -- slot borders
		self:skinObject("frame", {obj=this, kfs=true, ri=true, rns=true, cb=true, x2=3})

		self:Unhook(this, "OnShow")
	end)

	self:SecureHook(_G.PetTrackerSwitcher, "Update", function(this)
		for i = 1, _G.NUM_BATTLE_PETS_IN_BATTLE do
			skinSlot(this[_G.LE_BATTLE_PET_ENEMY .. i], true)
			-- if this[_G.LE_BATTLE_PET_ENEMY .. i].pet:Exists() then
			-- 	this[_G.LE_BATTLE_PET_ENEMY .. i].sf:Show()
			-- else
			-- 	this[_G.LE_BATTLE_PET_ENEMY .. i].sf:Hide()
			-- end
			skinSlot(this[_G.LE_BATTLE_PET_ALLY .. i], true)
			-- if this[_G.LE_BATTLE_PET_ALLY .. i].pet:Exists() then
			-- 	this[_G.LE_BATTLE_PET_ALLY .. i].sf:Show()
			-- else
			-- 	this[_G.LE_BATTLE_PET_ALLY .. i].sf:Hide()
			-- end
		end
	end)

	if self.modBtnBs then
		_G.C_Timer.After(0.25, function()
			for _, btn in _G.pairs(self:getLastChild(_G.PetBattleFrame.BottomFrame).Buttons) do
				self:addButtonBorder{obj=btn}
			end
		end)
	end

end

aObj.lodAddons.PetTracker_Journal = function(self) -- v 9.1.0
	if self.initialized.PetTracker_Journal then return end
	self.initialized.PetTracker_Journal = true

	self:SecureHookScript(_G.PetTrackerRivalsJournal, "OnShow", function(this)
		-- wait for frame objects to be created
		_G.C_Timer.After(0.5, function()
			self:removeInset(this.Count)
			self:removeInset(this.ListInset)
			self:skinObject("editbox", {obj=this.SearchBox, si=true})
			self:skinObject("slider", {obj=this.List.scrollBar})
			for _, btn in _G.pairs(this.List.buttons) do
				self:removeRegions(btn, {1}) -- background
				btn.model.quality:SetTexture(nil)
				self:changeTandC(btn.model.levelRing)
				if self.modBtnBs then
					self:addButtonBorder{obj=btn, relTo=btn.icon, reParent={btn.model.levelRing, btn.model.level}}
				end
				-- TODO: make model appear below frame
			end
			if self.modBtnBs then
				-- hook this to update button border quality
				self:SecureHook(this.List, "update", function(this)
					for _, btn in _G.pairs(this.buttons) do
						btn.sbb:SetBackdropBorderColor(btn.model.quality:GetVertexColor())
					end
				end)
			end
			self:skinObject("frame", {obj=this.Card, kfs=true, ri=true, rns=true, fb=true, ofs=1})
			if self.modBtnBs then
				-- skin rewards
				for i = 1, 4 do
					self:addButtonBorder{obj=this.Card[i], ibt=true}
				end
			end
			-- N.B. Slots skinned above

			-- Tabs in TRHC
			for i = 1, 3 do
				this["Tab" .. i].TabBg:SetAlpha(0)
				this["Tab" .. i].Hider:SetAlpha(0)
				-- use a button border to indicate the active tab
				self.modUIBtns:addButtonBorder{obj=this["Tab" .. i], relTo=this["Tab" .. i].Icon, ofs=i == 1 and 3 or 6} -- use module function here to force creation
				this["Tab" .. i].sbb:SetBackdropBorderColor(1, 0.6, 0, 1)
				this["Tab" .. i].sbb:SetShown(not this["Tab" .. i].Hider:IsShown())
			end
			self:SecureHook(this, "SetTab", function(this, tab)
				for i = 1, 3 do
					this["Tab" .. i].sbb:SetShown(not this["Tab" .. i].Hider:IsShown())
				end
			end)
			self:removeInset(this.Team)
		    self:keepRegions(this.Team.Border, {11})
		    self:moveObject{obj=self:getRegion(this.Team.Border, 11), y=8}
		    self:removeInset(this.Map.BorderFrame)
			self:removeNineSlice(this.History.NineSlice)
			this.History:DisableDrawLayer("BACKGROUND")
			self:getChild(this.History, 2):DisableDrawLayer("OVERLAY") -- ShadowOverlay frame
			self:removeMagicBtnTex(this.History.LoadButton)
			if self.modBtns then
				self:skinStdButton{obj=this.History.LoadButton}
			end
			self:skinObject("frame", {obj=this, kfs=true, ri=true, rns=true, cb=true, x2=3})
		end)

		self:Unhook(this, "OnShow")
	end)

	self:SecureHook(_G.PetTrackerRivalsJournal, "SetShown", function(this, show)
		if show then
			_G.MountJournal:SetShown(false)
			_G.PetJournal:SetShown(false)
			_G.ToyBox:SetShown(false)
			_G.HeirloomsJournal:SetShown(false)
			_G.WardrobeCollectionFrame:SetShown(false)
		end
		for i = 1, _G.CollectionsJournal.numTabs do
			_G.PanelTemplates_DeselectTab(_G["CollectionsJournalTab" .. i])
		end

	end)

	self:SecureHookScript(_G.PetTrackerRivalsJournal, "OnHide", function(this)
		_G.CollectionsJournal_UpdateSelectedTab(_G.CollectionsJournal)

	end)

end
