local aName, aObj = ...
if not aObj:isAddonEnabled("PetTracker") then return end
local _G = _G
local pairs = _G.pairs

local ptRJ
aObj.addonsToSkin.PetTracker = function(self) -- v 9.0.1

	-- Custom Tutorials
	local cTut = _G.LibStub:GetLibrary('CustomTutorials-2.1', true)
	if cTut then
		for _, frame in _G.pairs(cTut.frames) do
			self:addSkinFrame{obj=frame, ft="a", kfs=true, ri=true, ofs=2, x2=1}
			if self.modBtns then
				self:addButtonBorder{obj=frame.prev, ofs=-1, clr="gold"}
				self:addButtonBorder{obj=frame.next, ofs=-1, clr="gold"}
				self:SecureHook(frame.prev, "Disable", function(this, _)
					self:clrBtnBdr(this, "gold")
				end)
				self:SecureHook(frame.prev, "Enable", function(this, _)
					self:clrBtnBdr(this, "gold")
				end)
				self:SecureHook(frame.next, "Disable", function(this, _)
					self:clrBtnBdr(this, "gold")
				end)
				self:SecureHook(frame.next, "Enable", function(this, _)
					self:clrBtnBdr(this, "gold")
				end)
			end
		end
	end
	cTut = nil


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
		for j = 1, _G.PetTracker.MaxQuality do
			aObj:skinStatusBar{obj=obj.Bars[j], fi=0}
		end
	end
	-- hook this to skin new Bars
	self:RawHook(_G.PetTracker.ProgressBar, "New", function(this, ...)
		local barObj = self.hooks[this].New(this, ...)
		skinBarObj(barObj)
		return barObj
	end, true)
	-- skin existing bars
	for obj, _ in pairs(_G.PetTracker.ProgressBar.__frames) do
		skinBarObj(obj)
	end

	-- Tooltips
	local function skinTT(obj)
		_G.C_Timer.After(0.1, function()
			aObj:add2Table(aObj.ttList, obj)
		end)
	end
	-- hook this to skin new tooltips
	self:RawHook(_G.PetTracker.MultiTip, "Construct", function(this, ...)
		local tTip = self.hooks[this].Construct(this, ...)
		skinTT(tTip)
		return tTip
	end, true)
	-- skin existing tooltips
	for obj, _ in pairs(_G.PetTracker.MultiTip.__frames) do
		skinTT(obj)
	end

	-- Journal/Switcher slots
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
			local btn = slot.Abilities[i]
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
	-- hook this to skin slots
	self:SecureHook(_G.PetTracker.PetSlot, "Construct", function(this)
		-- wait for all the slots to be created (Journal has 3, switcher has 6P)
		if (this.__template == "PetTrackerJournalSlot" and this.__count == 3)
		or (this.__template == "PetTrackerBattleSlot" and this.__count == 6)
		then
			_G.C_Timer.After(0.1, function()
				for obj, _ in pairs(this.__frames) do
					skinSlot(obj, this.__template == "PetTrackerBattleSlot" and true)
				end
			end)
		end
	end, true)

	local cnt = 0
	self:SecureHook(_G.PetTracker, "NewModule", function(this, name, object)
		if name == "TrackToggle"
		and self.modChkBtns
		then
			cnt = cnt + 1
			self:skinCheckButton{obj=object}
		elseif name == "RivalsJournal" then
			cnt = cnt + 1
			ptRJ = object
		elseif name == "Switcher" then
			cnt = cnt + 1
			-- wait for module to be setup
			_G.C_Timer.After(0.1, function()
				self.callbacks:Fire("Switcher_Created", object)
			end)
		end
		if cnt == 3 then
			self:Unhook(this, "NewModule")
		end
	end, true)

	-- skin Pet Switcher frame
	self.RegisterCallback("PetTracker", "Switcher_Created", function(_, object)
		self:keepFontStrings(self:getChild(object, 4))
		self:keepFontStrings(self:getChild(object, 5))
		self:addSkinFrame{obj=object, ft="a", kfs=true, ri=true}

		self.UnregisterCallback("PetTracker", "Switcher_Created")
	end)

end

aObj.lodAddons.PetTracker_Journal = function(self) -- v 9.0.1

	-- wait for RivalsJournal and its List entries to be created
	if not ptRJ
	or not ptRJ.List.buttons
	then
		_G.C_Timer.After(0.1, function()
		    self.lodAddons.PetTracker_Journal(self)
		end)
		return
	end

	self:removeNineSlice(ptRJ.NineSlice)
	self:removeInset(ptRJ.Count)
	self:removeInset(ptRJ.ListInset)
	self:skinEditBox{obj=ptRJ.SearchBox, regs={6}}
	self:skinSlider{obj=ptRJ.List.scrollBar, wdth=-4}
	for _, btn in _G.pairs(ptRJ.List.buttons) do
		self:removeRegions(btn, {1}) -- background
		btn.model.quality:SetTexture(nil)
		self:changeTandC(btn.model.levelRing, aObj.lvlBG)
		if self.modBtnBs then
			self:addButtonBorder{obj=btn, relTo=btn.icon, reParent={btn.model.levelRing, btn.model.level}}
		end
		-- TODO: make model appear below frame
	end
	if self.modBtnBs then
		-- hook this to update button border quality
		self:SecureHook(ptRJ.List, "update", function(this)
			for i = 1, #this.buttons do
				this.buttons[i].sbb:SetBackdropBorderColor(this.buttons[i].model.quality:GetVertexColor())
			end
		end)
	end

	self:removeInset(ptRJ.Card)
	self:addSkinFrame{obj=ptRJ.Card, ft="a", kfs=true, nb=true, aso={bd=8, ng=true}}
	if self.modBtnBs then
		-- skin rewards
		for i = 1, 4 do
			self:addButtonBorder{obj=ptRJ.Card[i], ibt=true}
		end
	end
	-- N.B. Slots skinned above

	-- Tabs in TRHC
	for i = 1, 3 do
		ptRJ["Tab" .. i].TabBg:SetAlpha(0)
		ptRJ["Tab" .. i].Hider:SetAlpha(0)
		-- use a button border to indicate the active tab
		self.modUIBtns:addButtonBorder{obj=ptRJ["Tab" .. i], relTo=ptRJ["Tab" .. i].Icon, ofs=i == 1 and 3 or 6} -- use module function here to force creation
		ptRJ["Tab" .. i].sbb:SetBackdropBorderColor(1, 0.6, 0, 1)
		ptRJ["Tab" .. i].sbb:SetShown(not ptRJ["Tab" .. i].Hider:IsShown())
	end
	self:SecureHook(ptRJ, "SetTab", function(this, tab)
		for i = 1, 3 do
			this["Tab" .. i].sbb:SetShown(not this["Tab" .. i].Hider:IsShown())
		end
	end)

	-- Team panel
	self:removeInset(ptRJ.Team)
    self:keepRegions(ptRJ.Team.Border, {11})
    self:moveObject{obj=self:getRegion(ptRJ.Team.Border, 11), y=8}

	-- Location panel
    self:removeInset(ptRJ.Map.BorderFrame)

	-- History panel
	self:removeNineSlice(ptRJ.History.NineSlice)
	ptRJ.History:DisableDrawLayer("BACKGROUND")
	self:getChild(ptRJ.History, 2):DisableDrawLayer("OVERLAY") -- ShadowOverlay frame
	self:removeMagicBtnTex(ptRJ.History.LoadButton)
	if self.modBtns then
		self:skinStdButton{obj=ptRJ.History.LoadButton}
	end

	self:addSkinFrame{obj=ptRJ, ft="a", kfs=true, noBdr=true}

end
