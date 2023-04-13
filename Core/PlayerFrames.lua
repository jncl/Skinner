local _, aObj = ...

local _G = _G

local ftype = "p"

aObj.blizzFrames[ftype].CompactFrames = function(self)
	if not self.prdb.CompactFrames or self.initialized.CompactFrames then return end
	self.initialized.CompactFrames = true

	if _G.IsAddOnLoaded("Tukui")
	or _G.IsAddOnLoaded("ElvUI")
	then
		self.blizzFrames[ftype].CompactFrames = nil
		return
	end

	-- handle AddOn being disabled
	if not self:checkLoadable("Blizzard_CompactRaidFrames") then
		return
	end

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
		self:keepFontStrings(this.displayFrame)
		this.displayFrame.filterOptions:DisableDrawLayer("BACKGROUND")
		if not self.isRtl then
			self:skinObject("dropdown", {obj=this.displayFrame.profileSelector, fType=ftype})
			self:skinObject("frame", {obj=this.containerResizeFrame, fType=ftype, kfs=true})
			if self.modBtns then
				self:skinStdButton{obj=this.displayFrame.lockedModeToggle, fType=ftype}
			end
		else
			if self.modBtns then
				self:skinStdButton{obj=this.displayFrame.editMode, fType=ftype, sechk=true}
			end
		end
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ofs=0})
		if self.modBtns then
			for i = 1, 8 do
				self:skinStdButton{obj=this.displayFrame.filterOptions["filterGroup" .. i]}
			end
			self:skinStdButton{obj=this.displayFrame.hiddenModeToggle, fType=ftype}
			self:skinStdButton{obj=this.displayFrame.convertToRaid, fType=ftype}
			self:skinStdButton{obj=this.displayFrame.leaderOptions.readyCheckButton, fType=ftype}
			if not self.isClscERA then
				self:skinStdButton{obj=this.displayFrame.leaderOptions.rolePollButton, fType=ftype}
			end
			if self.isRtl then
				for _, type in _G.pairs{"Tank", "Healer", "Damager"} do
					self:skinStdButton{obj=this.displayFrame.filterOptions["filterRole" .. type]}
				end
				this.displayFrame.leaderOptions.countdownButton:DisableDrawLayer("ARTWORK") -- alpha values are changed in code
				this.displayFrame.leaderOptions.countdownButton.Text:SetDrawLayer("OVERLAY") -- move draw layer so it is displayed
				self:skinStdButton{obj=this.displayFrame.leaderOptions.countdownButton, fType=ftype}
				self:skinStdButton{obj=_G.CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton, fType=ftype}
				_G.CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:GetNormalTexture():SetAlpha(1) -- icon
			end
			self:SecureHook("CompactRaidFrameManager_UpdateOptionsFlowContainer", function()
				local fObj = _G.CompactRaidFrameManager
				-- handle button skin frames not being created yet
				if fObj.displayFrame.leaderOptions.readyCheckButton.sb then
					self:clrBtnBdr(fObj.displayFrame.leaderOptions.readyCheckButton)
					if not self.isClscERA then
						self:clrBtnBdr(fObj.displayFrame.leaderOptions.rolePollButton)
					end
					if self.isRtl then
						self:clrBtnBdr(fObj.displayFrame.leaderOptions.countdownButton)
					end
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
	local grpName
	local function skinGrp(grp)
		aObj:skinObject("frame", {obj=grp.borderFrame, fType=ftype, kfs=true}) --, ofs=1, y1=-1, x2=-4, y2=4})
		grpName = grp:GetName()
		if grpName ~= "CompactPartyFrame" then
			for i = 1, _G.MEMBERS_PER_RAID_GROUP do
				skinUnit(_G[grpName .. "Member" .. i])
			end
		end
	end
	-- hook this to skin any new CompactRaidGroup(s)
	self:SecureHook("CompactRaidGroup_UpdateLayout", function(frame)
		skinGrp(frame)
	end)

	-- Compact RaidFrame Container
	local function skinCRFCframes()
		for type, fTab in _G.pairs(_G.CompactRaidFrameContainer.frameUpdateList) do
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

end

aObj.blizzLoDFrames[ftype].ItemSocketingUI = function(self)
	if not self.prdb.ItemSocketingUI or self.initialized.ItemSocketingUI then return end
	self.initialized.ItemSocketingUI = true

	-- copy of GEM_TYPE_INFO from Blizzard_ItemSocketingUI.xml
	local gemTypeInfo = {
		["Yellow"]          = {textureKit = "yellow", r = 0.97, g = 0.82, b = 0.29},
		["Red"]             = {textureKit = "red", r = 1, g = 0.47, b = 0.47},
		["Blue"]            = {textureKit = "blue", r = 0.47, g = 0.67, b = 1},
		["Hydraulic"]       = {textureKit = "hydraulic", r = 1, g = 1, b = 1},
		["Cogwheel"]        = {textureKit = "cogwheel", r = 1, g = 1, b = 1},
		["Meta"]            = {textureKit = "meta", r = 1, g = 1, b = 1},
		["Prismatic"]       = {textureKit = "prismatic", r = 1, g = 1, b = 1},
		["PunchcardRed"]    = {textureKit = "punchcard-red", r = 1, g = 0.47, b = 0.47},
		["PunchcardYellow"] = {textureKit = "punchcard-yellow", r = 0.97, g = 0.82, b = 0.29},
		["PunchcardBlue"]   = {textureKit = "punchcard-blue", r = 0.47, g = 0.67, b = 1},
		["Domination"]      = {textureKit = "domination", r = 1, g = 1, b = 1},
		["Cypher"]          = {textureKit = "meta", r = 1, g = 1, b = 1},
	}
	if self.isRtl then
		gemTypeInfo["Tinker"] = {textureKit = "punchcard-red", r = 1, g = 0.47, b = 0.47}
	end
	if self.isRtlPTR2 then
		gemTypeInfo["Primordial"] = {textureKit="meta", r=1, g=1, b=1}
	end
	self:SecureHookScript(_G.ItemSocketingFrame, "OnShow", function(this)
		self:skinObject("slider", {obj=_G.ItemSocketingScrollFrame.ScrollBar, fType=ftype, rpTex="artwork"})
		if self.isRtl then
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true, x2=3})
		else
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, x1=10, y1=-12, x2=-4, y2=30})
			if self.modBtns then
				self:skinCloseButton{obj=_G.ItemSocketingCloseButton, fType=ftype}
			end
		end
		if self.modBtns then
			self:skinStdButton{obj=_G.ItemSocketingSocketButton, fType=ftype, schk=true}
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
		if not self.isRtl then
			self:removeRegions(obj, {3})
			obj:SetHeight(obj:GetHeight() * 1.25)
			self:moveObject{obj=_G[objName .. "Text"], y=-2}
			objBG = self:getRegion(obj, 1)
			objBG:SetWidth(objBG:GetWidth() * 0.75)
			objSB = _G[objName .. "StatusBar"]
			objSB:SetWidth(objSB:GetWidth() * 0.75)
		else
			self:nilTexture(obj.TextBorder, true)
			objBG = self:getRegion(obj, 2)
			self:nilTexture(obj.Border, true)
		end
		if self.prdb.MirrorTimers.glaze then
			if not self.isRtl then
				self:skinObject("statusbar", {obj=objSB, fi=0, bg=objBG})
			else
				self:skinObject("statusbar", {obj=obj.StatusBar, fi=0, bg=objBG, hookFunc=true})
			end
		end
	end
	if self.prdb.MirrorTimers.glaze
	and self.isRtl then
		self:RawHook("MirrorTimer_Show", function(timer, value, maxvalue, scale, paused, label)
			local dialog = self.hooks.MirrorTimer_Show(timer, value, maxvalue, scale, paused, label)
			local statusbar = dialog.StatusBar
			if timer == "BREATH" then
				statusbar:SetStatusBarColor(self:getColourByName("light_blue"))
			elseif timer == "DEATH" then
				statusbar:SetStatusBarColor(self:getColourByName("blue"))
			elseif timer == "EXHAUSTION" then
				statusbar:SetStatusBarColor(self:getColourByName("yellow"))
			elseif timer == "FEIGNDEATH" then
				statusbar:SetStatusBarColor(self:getColourByName("yellow"))
			end
			return dialog
		end, true)
	end

	if self.isRtl then
		-- Battleground/Arena/Island Expeditions Start Timer
		local function skinTT(timer)
			_G[timer.bar:GetName() .. "Border"]:SetTexture(nil) -- animations
			if aObj.prdb.MirrorTimers.glaze then
				if not aObj.sbGlazed[timer.bar]	then
					aObj:skinObject("statusbar", {obj=timer.bar, fi=0, bg=self:getRegion(timer.bar, 1)})
				end
				if aObj.isRtl then
					timer.bar:SetStatusBarColor(aObj:getColourByName("red"))
				end
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
		if not self.isRtl then
			_G["RaidGroupButton" .. i]:SetNormalTexture("")
		else
			_G["RaidGroupButton" .. i]:GetNormalTexture():SetTexture(nil)
		end
		self:skinObject("button", {obj=_G["RaidGroupButton" .. i], fType=ftype, subt=true--[[, bd=7]], ofs=1})
	end
	-- Raid Class Tabs (side)
	for i = 1, _G.MAX_RAID_CLASS_BUTTONS do
		self:removeRegions(_G["RaidClassButton" .. i], {1}) -- 2 is icon, 3 is text
	end

	if not self.isRtl then
		if self.modBtns then
			self:skinStdButton{obj=_G.RaidFrameReadyCheckButton, fType=ftype}
		end
	end

end

aObj.blizzFrames[ftype].ReadyCheck = function(self)
	if not self.prdb.ReadyCheck or self.initialized.ReadyCheck then return end
	self.initialized.ReadyCheck = true

	self:SecureHookScript(_G.ReadyCheckFrame, "OnShow", function(this)
		self:skinObject("frame", {obj=_G.ReadyCheckListenerFrame, fType=ftype, kfs=true, x1=32})
		if self.modBtns then
			self:skinStdButton{obj=_G.ReadyCheckFrameYesButton}
			self:skinStdButton{obj=_G.ReadyCheckFrameNoButton}
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].TradeFrame = function(self)
	if not self.prdb.TradeFrame or self.initialized.TradeFrame then return end
	self.initialized.TradeFrame = true

	self:SecureHookScript(_G.TradeFrame, "OnShow", function(this)
		if self.isRtl then
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
