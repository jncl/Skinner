local _, aObj = ...

local _G = _G

local ftype = "p"

aObj.blizzFrames[ftype].Buffs = function(self)
	if not self.prdb.Buffs or self.initialized.Buffs then return end
	self.initialized.Buffs = true

	if self.modBtnBs then
		local function skinBuffBtn(btn)
			if btn
			and not btn.sbb
			then
				aObj:addButtonBorder{obj=btn, reParent={btn.count, btn.duration}, ofs=3, clr="grey"}
			end
		end
		-- skin current Buffs
		for i = 1, _G.BUFF_MAX_DISPLAY do
			skinBuffBtn(_G["BuffButton" .. i])
		end
		-- if not all buff buttons created yet
		if not _G.BuffButton32 then
			-- hook this to skin new Buffs
			self:SecureHook("AuraButton_Update", function(buttonName, index, _)
				if buttonName == "BuffButton" then
					skinBuffBtn(_G[buttonName .. index])
				end
			end)
		end
	end

	-- Debuffs already have a coloured border
	-- Temp Enchants already have a coloured border

end

aObj.blizzFrames[ftype].CastingBar = function(self)
	if not self.prdb.CastingBar.skin or self.initialized.CastingBar then return end
	self.initialized.CastingBar = true

	if _G.IsAddOnLoaded("Quartz")
	or _G.IsAddOnLoaded("Dominos_Cast")
	then
		self.blizzFrames[ftype].CastingBar = nil
		return
	end

	for _, type in _G.pairs{"", "Pet"} do
		_G[type .. "CastingBarFrame"].Border:SetAlpha(0)
		self:changeShield(_G[type .. "CastingBarFrame"].BorderShield, _G[type .. "CastingBarFrame"].Icon)
		_G[type .. "CastingBarFrame"].Flash:SetAllPoints()
		_G[type .. "CastingBarFrame"].Flash:SetTexture(self.tFDIDs.w8x8)
		if self.prdb.CastingBar.glaze then
			self:skinStatusBar{obj=_G[type .. "CastingBarFrame"], fi=0, bgTex=self:getRegion(_G[type .. "CastingBarFrame"], 1)}
		end
		-- adjust text and spark in Classic mode
		if not _G[type .. "CastingBarFrame"].ignoreFramePositionManager then
			_G[type .. "CastingBarFrame"].Text:SetPoint("TOP", 0, 2)
			_G[type .. "CastingBarFrame"].Spark.offsetY = -1
		end
	end

	-- hook this to handle the CastingBar being attached to the Unitframe and then reset
	self:SecureHook("CastingBarFrame_SetLook", function(castBar, look)
		castBar.Border:SetAlpha(0)
		castBar.Flash:SetAllPoints()
		castBar.Flash:SetTexture(self.tFDIDs.w8x8)
		if look == "CLASSIC" then
			castBar.Text:SetPoint("TOP", 0, 2)
			castBar.Spark.offsetY = -1
		end
	end)

end

aObj.blizzFrames[ftype].CompactFrames = function(self)
	if not self.prdb.CompactFrames or self.initialized.CompactFrames then return end
	self.initialized.CompactFrames = true

	if _G.IsAddOnLoaded("Tukui")
	or _G.IsAddOnLoaded("ElvUI")
	then
		self.blizzFrames[ftype].CompactFrames = nil
		return
	end

	local function skinUnit(unit)
		-- handle in combat
		if _G.InCombatLockdown() then
		    aObj:add2Table(aObj.oocTab, {skinUnit, {unit}})
		    return
		end
		if aObj:hasTextInTexture(unit.healthBar:GetStatusBarTexture(), "RaidFrame")
		or unit.healthBar:GetStatusBarTexture():GetTexture() == 423819 -- interface/raidframe/raid-bar-hp-fill.blp
		then
			unit:DisableDrawLayer("BACKGROUND")
			unit.horizDivider:SetTexture(nil)
			unit.horizTopBorder:SetTexture(nil)
			unit.horizBottomBorder:SetTexture(nil)
			unit.vertLeftBorder:SetTexture(nil)
			unit.vertRightBorder:SetTexture(nil)
			aObj:skinObject("statusbar", {obj=unit.healthBar, fi=0, bg=unit.healthBar.background})
			aObj:skinObject("statusbar", {obj=unit.powerBar, fi=0, bg=unit.powerBar.background})
		end
	end
	local function skinGrp(grp)
		aObj:skinObject("frame", {obj=grp.borderFrame, fType=ftype, kfs=true, ofs=1, y1=-1, x2=-4, y2=4})
		local grpName = grp:GetName()
		for i = 1, _G.MEMBERS_PER_RAID_GROUP do
			skinUnit(_G[grpName .. "Member" .. i])
		end
	end

	-- Compact Party Frame
	self:SecureHook("CompactPartyFrame_OnLoad", function()
		self:skinObject("frame", {obj=_G.CompactPartyFrame.borderFrame, fType=ftype, kfs=true})

		self:Unhook("CompactPartyFrame_OnLoad")
	end)
	-- hook this to skin any new CompactRaidGroup(s)
	self:SecureHook("CompactRaidGroup_UpdateLayout", function(frame)
		skinGrp(frame)
	end)

	-- Compact RaidFrame Container
	-- handle AddOn being disabled
	if not self:checkLoadable("Blizzard_CompactRaidFrames") then
		return
	end

	local function skinCRFCframes()
		for type, fTab in _G.pairs(_G.CompactRaidFrameContainer.frameUpdateList) do
			-- aObj:Debug("skinCRFCframes: [%s, %s]", type)
			for _, frame in _G.pairs(fTab) do
				if type == "normal" then
					if frame.borderFrame then -- group or party
						skinGrp(frame)
					else
						skinUnit(frame)
					end
				elseif type == "mini" then
					skinUnit(frame)
				end
			end
		end
	end
	-- hook this to skin any new CompactRaidFrameContainer entries
	self:SecureHook("FlowContainer_AddObject", function(container, _)
		if container == _G.CompactRaidFrameContainer then -- only for compact raid frame objects
			skinCRFCframes()
		end
	end)
	-- skin any existing unit(s) [mini, normal]
	skinCRFCframes()
	self:skinObject("frame", {obj=_G.CompactRaidFrameContainer.borderFrame, fType=ftype, kfs=true, ofs=1, y1=-1, x2=-4, y2=4})

	-- Compact RaidFrame Manager
	self:SecureHookScript(_G.CompactRaidFrameManager, "OnShow", function(this)
		self:moveObject{obj=this.toggleButton, x=5}
		this.toggleButton:SetSize(12, 32)
		this.toggleButton.nt = this.toggleButton:GetNormalTexture()
		this.toggleButton.nt:SetTexCoord(0.22, 0.5, 0.33, 0.67)
		-- hook this to trim the texture
		self:RawHook(this.toggleButton.nt, "SetTexCoord", function(tObj, x1, x2, _)
			self.hooks[tObj].SetTexCoord(tObj, x1 == 0 and x1 + 0.22 or x1 + 0.26, x2, 0.33, 0.67)
		end, true)
		-- Display Frame
		_G.CompactRaidFrameManagerDisplayFrameHeaderBackground:SetTexture(nil)
		_G.CompactRaidFrameManagerDisplayFrameHeaderDelineator:SetTexture(nil)
		this.displayFrame.filterOptions:DisableDrawLayer("BACKGROUND")
		self:skinObject("dropdown", {obj=this.displayFrame.profileSelector, fType=ftype})
		self:skinObject("frame", {obj=this.containerResizeFrame, fType=ftype, kfs=true})
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ofs=0})
		if self.modBtns then
			for i = 1, 8 do
				self:skinStdButton{obj=this.displayFrame.filterOptions["filterGroup" .. i]}
			end
			self:skinStdButton{obj=this.displayFrame.lockedModeToggle, fType=ftype}
			self:skinStdButton{obj=this.displayFrame.hiddenModeToggle, fType=ftype}
			self:skinStdButton{obj=this.displayFrame.convertToRaid, fType=ftype}
			self:skinStdButton{obj=this.displayFrame.leaderOptions.readyCheckButton, fType=ftype}
			if not self.isClsc then
				for _, type in _G.pairs{"Tank", "Healer", "Damager"} do
					self:skinStdButton{obj=this.displayFrame.filterOptions["filterRole" .. type]}
				end
				self:skinStdButton{obj=this.displayFrame.leaderOptions.rolePollButton, fType=ftype}
				this.displayFrame.leaderOptions.countdownButton:DisableDrawLayer("ARTWORK") -- alpha values are changed in code
				this.displayFrame.leaderOptions.countdownButton.Text:SetDrawLayer("OVERLAY") -- move draw layer so it is displayed
				self:skinStdButton{obj=this.displayFrame.leaderOptions.countdownButton, fType=ftype}
				self:skinStdButton{obj=_G.CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton, fType=ftype}
				_G.CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:GetNormalTexture():SetAlpha(1) -- icon
			end
			self:SecureHook("CompactRaidFrameManager_UpdateOptionsFlowContainer", function(fObj)
				self:clrBtnBdr(fObj.displayFrame.leaderOptions.readyCheckButton)
				if not self.isClsc then
					self:clrBtnBdr(fObj.displayFrame.leaderOptions.rolePollButton)
					self:clrBtnBdr(fObj.displayFrame.leaderOptions.countdownButton)
				end
			end)
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=this.displayFrame.everyoneIsAssistButton}
			_G.RaiseFrameLevel(this.displayFrame.everyoneIsAssistButton) -- so button border is visible
		end

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.CompactRaidFrameManager)

end

aObj.blizzLoDFrames[ftype].ItemSocketingUI = function(self)
	if not self.prdb.ItemSocketingUI or self.initialized.ItemSocketingUI then return end
	self.initialized.ItemSocketingUI = true

	-- copy of GEM_TYPE_INFO from Blizzard_ItemSocketingUI.xml
	local gemTypeInfo = {
		Yellow          = {textureKit="yellow", r=0.97, g=0.82, b=0.29},
		Red             = {textureKit="red", r=1, g=0.47, b=0.47},
		Blue            = {textureKit="blue", r=0.47, g=0.67, b=1},
		Hydraulic       = {textureKit="hydraulic", r=1, g=1, b=1},
		Cogwheel        = {textureKit="cogwheel", r=1, g=1, b=1},
		Meta            = {textureKit="meta", r=1, g=1, b=1},
		Prismatic       = {textureKit="prismatic", r=1, g=1, b=1},
		PunchcardRed    = {textureKit="punchcard-red", r=1, g=0.47, b=0.47},
		PunchcardYellow = {textureKit="punchcard-yellow", r=0.97, g=0.82, b=0.29},
		PunchcardBlue   = {textureKit="punchcard-blue", r=0.47, g=0.67, b=1},
		Domination      = {textureKit="domination", r=1, g=1, b=1},
		Cypher          = {textureKit="meta", r=1, g=1, b=1},
	}
	self:SecureHookScript(_G.ItemSocketingFrame, "OnShow", function(this)
		self:skinObject("slider", {obj=_G.ItemSocketingScrollFrame.ScrollBar, fType=ftype, rpTex="artwork"})
		if not self.isClscBC then
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true, x2=3})
		else
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, x1=10, y1=-12, x2=-4, y2=30})
			if self.modBtns then
				self:skinCloseButton{obj=_G.ItemSocketingCloseButton, fType=ftype}
			end
		end
		if self.modBtns then
			self:skinStdButton{obj=_G.ItemSocketingSocketButton, fType=ftype}
			self:SecureHook(_G.ItemSocketingSocketButton, "Disable", function(bObj, _)
				self:clrBtnBdr(bObj)
			end)
			self:SecureHook(_G.ItemSocketingSocketButton, "Enable", function(bObj, _)
				self:clrBtnBdr(bObj)
			end)
			this.Sockets = this.Sockets or {_G.ItemSocketingSocket1, _G.ItemSocketingSocket2, _G.ItemSocketingSocket3}
			for _, socket in _G.ipairs(this.Sockets) do
				socket:DisableDrawLayer("BACKGROUND")
				socket:DisableDrawLayer("BORDER")
				self:skinObject("button", {obj=socket, fType=ftype, bd=10, ng=true}) -- ≈ fb option for frame
			end
			local function colourSockets()
				local numSockets = _G.GetNumSockets()
				for i, socket in _G.ipairs(_G.ItemSocketingFrame.Sockets) do
					if i <= numSockets then
						local clr = gemTypeInfo[_G.GetSocketTypes(i)]
						socket.sb:SetBackdropBorderColor(clr.r, clr.g, clr.b)
					end
				end
			end
			-- hook this to colour the button border
			self:SecureHook("ItemSocketingFrame_Update", function()
				colourSockets()
			end)
			colourSockets()
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].LootFrames = function(self)
	if not self.prdb.LootFrames.skin or self.initialized.LootFrames then return end
	self.initialized.LootFrames = true

	self:SecureHookScript(_G.LootFrame, "OnShow", function(this)
		for i = 1, _G.LOOTFRAME_NUMBUTTONS do
			_G["LootButton" .. i .. "NameFrame"]:SetTexture(nil)
			if self.modBtnBs then
				self:addButtonBorder{obj=_G["LootButton" .. i]}
			end
		end
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true})
		if self.modBtnBs then
			self:SecureHook("LootFrame_Update", function()
				for i = 1, _G.LOOTFRAME_NUMBUTTONS do
					if _G["LootButton" .. i].quality then
						_G.SetItemButtonQuality(_G["LootButton" .. i], _G["LootButton" .. i].quality)
					end
				end
			end)
			self:addButtonBorder{obj=_G.LootFrameDownButton, ofs=-2, clr="gold"}
			self:addButtonBorder{obj=_G.LootFrameUpButton, ofs=-2, clr="gold"}
		end

		self:Unhook(this, "OnShow")
	end)

	local function skinGroupLoot(frame)

		frame:DisableDrawLayer("BACKGROUND")
		frame:DisableDrawLayer("BORDER")
		if aObj.isClsc then
			local fName = frame:GetName()
			_G[fName .. "SlotTexture"]:SetTexture(nil)
			_G[fName .. "NameFrame"]:SetTexture(nil)
			_G[fName .. "Corner"]:SetAlpha(0)
			frame.Timer:DisableDrawLayer("ARTWORK")
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=frame, relTo=frame.Icon, reParent={frame.Count}}
			end
		end
		aObj:skinStatusBar{obj=frame.Timer, fi=0, bgTex=frame.Timer.Background}
		-- hook this to show the Timer
		aObj:secureHook(frame, "Show", function(this)
			this.Timer:SetFrameLevel(this:GetFrameLevel() + 1)
		end)

		frame:SetScale(aObj.prdb.LootFrames.size ~= 1 and 0.75 or 1)
		if not aObj.isClsc then
			frame.IconFrame.Border:SetAlpha(0)
		end
		if aObj.modBtns then
			aObj:skinCloseButton{obj=frame.PassButton}
		end
		if aObj.prdb.LootFrames.size ~= 3 then -- Normal or small
			aObj:addSkinFrame{obj=frame, ft=ftype, x1=-3, y2=-3} -- adjust for Timer
		else -- Micro
			aObj:moveObject{obj=frame.IconFrame, x=95, y=5}
			frame.Name:SetAlpha(0)
			frame.NeedButton:ClearAllPoints()
			frame.NeedButton:SetPoint("TOPRIGHT", "$parent", "TOPRIGHT", -34, -4)
			frame.PassButton:ClearAllPoints()
			frame.PassButton:SetPoint("LEFT", frame.NeedButton, "RIGHT", 0, 2)
			frame.GreedButton:ClearAllPoints()
			frame.GreedButton:SetPoint("RIGHT", frame.NeedButton, "LEFT")
			if not self.isClsc then
				frame.DisenchantButton:ClearAllPoints()
				frame.DisenchantButton:SetPoint("RIGHT", frame.GreedButton, "LEFT", 2, 0)
			end
			aObj:adjWidth{obj=frame.Timer, adj=-30}
			frame.Timer:ClearAllPoints()
			frame.Timer:SetPoint("BOTTOMRIGHT", "$parent", "BOTTOMRIGHT", -10, 13)
			aObj:addSkinFrame{obj=frame, ft=ftype, x1=97, y2=8}
		end

	end
	for i = 1, _G.NUM_GROUP_LOOT_FRAMES do
		self:SecureHookScript(_G["GroupLootFrame" .. i], "OnShow", function(this)
			skinGroupLoot(this)

			self:Unhook(this, "OnShow")
		end)
	end

	self:SecureHookScript(_G.MasterLooterFrame, "OnShow", function(this)
		this:DisableDrawLayer("BACKGROUND")
		this.Item.NameBorderLeft:SetTexture(nil)
		this.Item.NameBorderRight:SetTexture(nil)
		this.Item.NameBorderMid:SetTexture(nil)
		this.Item.IconBorder:SetTexture(nil)
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true}
		if self.modBtns then
			 self:skinCloseButton{obj=self:getChild(this, 3)} -- unamed close button
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=this.Item, relTo=this.Item.Icon}
		end

		self:Unhook(this, "OnShow")
	end)

	if not self.isClsc then
		self:SecureHookScript(_G.BonusRollFrame, "OnShow", function(this)
			self:removeRegions(this, {1, 2, 3, 5})
			self:skinStatusBar{obj=this.PromptFrame.Timer, fi=0}
			self:addSkinFrame{obj=this, ft=ftype, bg=true}
			if self.modBtnBs then
				 self:addButtonBorder{obj=this.PromptFrame, relTo=this.PromptFrame.Icon, reParent={this.SpecIcon}}
			end

			self:Unhook(this, "OnShow")
		end)
		self:SecureHookScript(_G.BonusRollLootWonFrame, "OnShow", function(this)
			this:DisableDrawLayer("BACKGROUND")
			if this.SpecRing then this.SpecRing:SetTexture(nil) end
			self:addSkinFrame{obj=this, ft=ftype, ofs=-10, y2=8}

			self:Unhook(this, "OnShow")
		end)
		self:SecureHookScript(_G.BonusRollMoneyWonFrame, "OnShow", function(this)
			this:DisableDrawLayer("BACKGROUND")
			if this.SpecRing then this.SpecRing:SetTexture(nil) end
			self:addSkinFrame{obj=this, ft=ftype, ofs=-8, y2=8}

			self:Unhook(this, "OnShow")
		end)
	end

end

aObj.blizzFrames[ftype].LootHistory = function(self)
	if not self.prdb.LootHistory or self.initialized.LootHistory then return end
	self.initialized.LootHistory = true

	self:SecureHookScript(_G.LootHistoryFrame, "OnShow", function(this)
		this:DisableDrawLayer("BACKGROUND")
		this.Divider:SetTexture(nil)
		self:skinObject("slider", {obj=this.ScrollFrame.ScrollBar, fType=ftype, rpTex="background"})
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, ofs=-1})
		local function skinItemFrames(obj)
			for _, frame in _G.pairs(obj.itemFrames) do
				frame.Divider:SetTexture(nil)
				frame.NameBorderLeft:SetTexture(nil)
				frame.NameBorderRight:SetTexture(nil)
				frame.NameBorderMid:SetTexture(nil)
				frame.ActiveHighlight:SetTexture(nil)
				if aObj.modBtns then
					if not frame.ToggleButton.sb then
						aObj:skinExpandButton{obj=frame.ToggleButton, plus=true}
					end
				end
			end
		end
		-- hook this to skin loot history items
		self:SecureHook("LootHistoryFrame_FullUpdate", function(fObj)
			skinItemFrames(fObj)
		end)
		-- skin existing itemFrames
		skinItemFrames(this)

		self:skinObject("dropdown", {obj=_G.LootHistoryDropDown, fType=ftype})

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].MirrorTimers = function(self)
	if not self.prdb.MirrorTimers.skin or self.initialized.MirrorTimers then return end
	self.initialized.MirrorTimers = true

	local objName, obj, objBG, objSB
	for i = 1, _G.MIRRORTIMER_NUMTIMERS do
		objName = "MirrorTimer" .. i
		obj = _G[objName]
		objBG = self:getRegion(obj, 1)
		objSB = _G[objName .. "StatusBar"]
		self:removeRegions(obj, {3})
		obj:SetHeight(obj:GetHeight() * 1.25)
		self:moveObject{obj=_G[objName .. "Text"], y=-2}
		objBG:SetWidth(objBG:GetWidth() * 0.75)
		objSB:SetWidth(objSB:GetWidth() * 0.75)
		if self.prdb.MirrorTimers.glaze then
			self:skinStatusBar{obj=objSB, fi=0, bgTex=objBG}
		end
	end

	if not self.isClsc then
		-- Battleground/Arena/Island Expeditions Start Timer
		local function skinTT(timer)

			if not aObj.sbGlazed[timer.bar] then
				_G[timer.bar:GetName() .. "Border"]:SetTexture(nil) -- animations
				aObj:skinStatusBar{obj=timer.bar, fi=0}
			end

		end
		self:SecureHook("StartTimer_SetGoTexture", function(timer)
			skinTT(timer)
		end)
		-- skin existing timers
		for _, timer in _G.pairs(_G.TimerTracker.timerList) do
			skinTT(timer)
		end
	end

end

aObj.blizzLoDFrames[ftype].RaidUI = function(self)
	if not self.prdb.RaidUI or self.initialized.RaidUI then return end
	self.initialized.RaidUI = true

	-- N.B. accessed via Raid tab on Friends Frame

	-- N.B. Pullout functionality commented out, therefore code removed from this function

	self:moveObject{obj=_G.RaidGroup1, x=3}

	-- Raid Groups
	for i = 1, _G.MAX_RAID_GROUPS do
		_G["RaidGroup" .. i]:DisableDrawLayer("BACKGROUND")
		self:skinObject("frame", {obj=_G["RaidGroup" .. i], fType=ftype, fb=true})
	end
	-- Raid Group Buttons
	for i = 1, _G.MAX_RAID_GROUPS * 5 do
		_G["RaidGroupButton" .. i]:SetNormalTexture(nil)
		self:skinObject("button", {obj=_G["RaidGroupButton" .. i], fType=ftype, subt=true--[[, bd=7]], ofs=1})
	end
	-- Raid Class Tabs (side)
	for i = 1, _G.MAX_RAID_CLASS_BUTTONS do
		self:removeRegions(_G["RaidClassButton" .. i], {1}) -- 2 is icon, 3 is text
	end

	if self.isClsc then
		if self.modBtns then
			self:skinStdButton{obj=_G.RaidFrameReadyCheckButton, fType=ftype}
		end
	end

end

aObj.blizzFrames[ftype].ReadyCheck = function(self)
	if not self.prdb.ReadyCheck or self.initialized.ReadyCheck then return end
	self.initialized.ReadyCheck = true

	self:SecureHookScript(_G.ReadyCheckFrame, "OnShow", function(this)
		self:skinStdButton{obj=_G.ReadyCheckFrameYesButton}
		self:skinStdButton{obj=_G.ReadyCheckFrameNoButton}
		self:addSkinFrame{obj=_G.ReadyCheckListenerFrame, ft=ftype, kfs=true, nb=true, x1=32}
		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].TradeFrame = function(self)
	if not self.prdb.TradeFrame or self.initialized.TradeFrame then return end
	self.initialized.TradeFrame = true

	self:SecureHookScript(_G.TradeFrame, "OnShow", function(this)
		if not self.isClsc then
			this.RecipientOverlay.portrait:SetAlpha(0)
			this.RecipientOverlay.portraitFrame:SetTexture(nil)
		end
		self:removeInset(_G.TradeRecipientItemsInset)
		self:removeInset(_G.TradeRecipientEnchantInset)
		self:removeInset(_G.TradePlayerItemsInset)
		self:removeInset(_G.TradePlayerEnchantInset)
		self:removeInset(_G.TradePlayerInputMoneyInset)
		self:removeInset(_G.TradeRecipientMoneyInset)
		self:skinObject("moneyframe", {obj=_G.TradePlayerInputMoneyFrame, moveGEB=true})
		_G.TradeRecipientMoneyBg:DisableDrawLayer("BACKGROUND")
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true, x2=1})
		if self.modBtns then
			self:skinStdButton{obj=_G.TradeFrameTradeButton}
			self:skinStdButton{obj=_G.TradeFrameCancelButton}
		end
		if self.modBtnBs then
			for i = 1, _G.MAX_TRADE_ITEMS do
				for _, type in _G.pairs{"Player", "Recipient"} do
					_G["Trade" .. type .. "Item" .. i .. "SlotTexture"]:SetTexture(nil)
					_G["Trade" .. type .. "Item" .. i .. "NameFrame"]:SetTexture(nil)
					self:addButtonBorder{obj=_G["Trade" .. type .. "Item" .. i .. "ItemButton"], ibt=true}
				end
			end
		end

		self:Unhook(this, "OnShow")
	end)

end
