local aName, aObj = ...
if not aObj:isAddonEnabled("PetTracker") then return end
local _G = _G

aObj.addonsToSkin.PetTracker = function(self) -- v 8.0.2

	-- Custom Tutorials
	local cTut = _G.LibStub:GetLibrary('CustomTutorials-2.1', true)
	if cTut then
		for k, frame in _G.pairs(cTut.frames) do
			self:addSkinFrame{obj=frame, ft="a", kfs=true, ri=true, ofs=2, x2=1}
			self:addButtonBorder{obj=frame.prev, ofs=-1}
			self:addButtonBorder{obj=frame.next, ofs=-1}
		end
	end
	cTut = nil

	-- Objectives
	_G.PetTracker.Objectives.Header.Background:SetTexture(nil)

	for i = 1, #_G.PetTracker.ProgressBar.usedFrames do
		self:keepFontStrings(_G.PetTracker.ProgressBar.usedFrames[i].Overlay)
		for j = 1, _G.PetTracker.MaxQuality do
			self:skinStatusBar{obj=_G.PetTracker.ProgressBar.usedFrames[i].Bars[j], fi=0}
		end
	end

	-- Tooltips
	for i = 1, _G.PetTracker.MapTip.numFrames do
		_G.C_Timer.After(0.1, function()
			self:add2Table(self.ttList, _G.PetTracker.MapTip.usedFrames[i])
		end)
	end

	self:SecureHook(_G.PetTracker, "NewModule", function(this, name, object)
		if name == "TrackToggle" then
			self:skinCheckButton{obj=object}
		end
	end)

end

local function skinSlot(slot, isBattle)

	slot.Bg:SetTexture(nil)
	slot.IconBorder:SetTexture(nil)
	slot.Quality:SetTexture(nil)
	aObj:changeTandC(slot.LevelBG, aObj.lvlBG)
	if aObj.modBtnBs then
		aObj:addButtonBorder{obj=slot, relTo=slot.Icon, reParent={slot.LevelBG, slot.Level}}
		aObj:SecureHook(slot.Quality, "SetVertexColor", function(this, r, g, b)
			slot.sbb:SetBackdropBorderColor(r, g, b, 1)
		end)
	end

	-- ability buttons
	for i = 1, _G.NUM_BATTLE_PET_ABILITIES do
		local btn = slot.Ability[i]
		aObj:getRegion(btn, 1):SetTexture(nil)
		aObj:addButtonBorder{obj=btn, relTo=btn.icon, reParent={btn.Type}}
	end

	if isBattle then
		aObj:removeRegions(slot.Health, {2, 3, 4, 5})
		aObj:skinStatusBar{obj=slot.Health, fi=0}
		aObj:removeRegions(slot.Xp, {2, 3, 4, 5})
		aObj:skinStatusBar{obj=slot.Xp, fi=0}
	end

	aObj:addSkinFrame{obj=slot, ft="a", aso={bd=8, ng=true}, x1=-4, x2=1, y2=-2} -- use asf here as button already has a border

	-- IsEmpty frame, covers slot, don't skin it
	-- IsDead frame

end

aObj.addonsToSkin.PetTracker_Switcher = function(self) -- v 8.0.2

	self:SecureHook(_G.PetTracker.Switcher, "Initialize", function(this)
		for i = 1, _G.NUM_BATTLE_PETS_IN_BATTLE do
			for _, slot in _G.pairs{this[_G.LE_BATTLE_PET_ALLY .. i], this[_G.LE_BATTLE_PET_ENEMY .. i]} do
				skinSlot(slot, true)
			end
		end
		-- remove borders
		self:keepFontStrings(self:getChild(this, 4))
		self:keepFontStrings(self:getChild(this, 5))
		self:Unhook(this, "Initialize")
	end)
	self:addSkinFrame{obj=_G.PetTracker.Switcher, ft="a", kfs=true, ri=true, y1=2, x2=1}

	if self.modBtnBs then
		local btn
		for i = 1, #_G.PetTracker.EnemyActions.buttons do
			btn = _G.PetTracker.EnemyActions.buttons[i]
			self:addButtonBorder{obj=btn, reParent={btn.Lock, btn.BetterIcon}}
			btn.sbb:SetBackdropBorderColor(btn.Icon:GetVertexColor())
			self:SecureHook(btn.Icon, "SetVertexColor", function(this, r, g, b)
				this:GetParent().sbb:SetBackdropBorderColor(r, g, b, 1)
			end)
		end
		btn = nil
	end

end

aObj.addonsToSkin.PetTracker_Journal = function(self) -- v 8.0.2

	self:SecureHookScript(_G.PetTrackerRivalJournal, "OnShow", function(this)
		self:removeInset(_G.PetTrackerRivalJournal.Count)
		self:removeInset(_G.PetTrackerRivalJournal.ListInset)
		self:skinEditBox{obj=_G.PetTrackerRivalJournal.SearchBox, regs={6}}
		self:skinSlider{obj=_G.PetTrackerRivalJournal.List.scrollBar, wdth=-4}
		local btn
		for i = 1, #_G.PetTrackerRivalJournal.List.buttons do
			btn = _G.PetTrackerRivalJournal.List.buttons[i]
			self:removeRegions(btn, {1}) -- background
			btn.model.quality:SetTexture(nil)
			self:changeTandC(btn.model.levelRing, aObj.lvlBG)
			self:addButtonBorder{obj=btn, relTo=btn.icon, reParent={btn.model.levelRing, btn.model.level}}
			-- TODO: make model appear below frame
		end
		btn = nil
		if self.modBtnBs then
			-- hook this to update button border quality
			self:SecureHook(this.List, "update", function(this)
				for i = 1, #this.buttons do
					this.buttons[i].sbb:SetBackdropBorderColor(this.buttons[i].model.quality:GetVertexColor())
				end
			end)
		end

		self:removeInset(_G.PetTrackerRivalJournal.Card)
		self:addSkinFrame{obj=_G.PetTrackerRivalJournal.Card, ft="a", kfs=true, nb=true, aso={bd=8, ng=true}}
		if self.modBtnBs then
			-- skin rewards
			for i = 1, 4 do
				self:addButtonBorder{obj=_G.PetTrackerRivalJournal.Card[i], ibt=true}
			end
		end
		-- Rival Pet cards (RHS)
		for _, slot in _G.ipairs(_G.PetTrackerRivalJournal.Slots) do
			skinSlot(slot)
		end

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

		-- Team panel
		self:removeInset(_G.PetTrackerRivalJournal.Team)
	    self:keepRegions(_G.PetTrackerRivalJournal.Team.Border, {11})
	    self:moveObject{obj=self:getRegion(_G.PetTrackerRivalJournal.Team.Border, 11), y=8}

		-- Location panel
	    self:removeInset(_G.PetTrackerRivalJournal.Map.Background)
	    self:removeInset(_G.PetTrackerRivalJournal.Map.BorderFrame)

		-- History panel
		self:removeInset(_G.PetTrackerRivalJournal.History)
		self:removeRegions(_G.PetTrackerRivalJournal.History, {1})
		self:getChild(_G.PetTrackerRivalJournal.History, 1):DisableDrawLayer("OVERLAY") -- ShadowOverlay frame
		self:removeMagicBtnTex(_G.PetTrackerRivalJournal.History.LoadButton)
		self:skinStdButton{obj=_G.PetTrackerRivalJournal.History.LoadButton}

		self:addSkinFrame{obj=this, ft="a", kfs=true, noBdr=true}

		self:Unhook(this, "OnShow")
	end)

end
