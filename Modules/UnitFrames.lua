local _, aObj = ...

local _G = _G

local ftype = "p"

local module = aObj:NewModule("UnitFrames", "AceEvent-3.0", "AceHook-3.0")

local db
local defaults = {
	profile = {
		alpha = 0.25,
		arena = false,
		focus = false,
		party = false,
		pet = (aObj.uCls == "HUNTER" or aObj.uCls == "WARLOCK") and true or nil,
		player = false,
		target = false,
	}
}
local lOfs = -9 -- level text offset
local unitFrames = {
	"FocusFrame",
	"PartyMemberBackground",
	"PartyMemberBuffTooltip",
	"PetFrame",
	"PlayerFrame",
	"TargetFrame",
}

module.isSkinned = _G.setmetatable({}, {__index = function(t, k) t[k] = true end})

-- N.B. handle bug in XML & lua which places mana bar 1 pixel too high
function module:adjustStatusBarPosn(sBar, yAdj)

	local oPnt
	yAdj = yAdj or 1
	if sBar.TextString then
		oPnt = {sBar.TextString:GetPoint()}
		sBar.TextString:SetPoint(oPnt[1], oPnt[2], oPnt[3], oPnt[4], oPnt[5] + yAdj)
	end
	if sBar == _G.PlayerFrame.healthbar then
		self:RawHook(sBar, "SetPoint", function(this, posn, xOfs, yOfs)
			self.hooks[this].SetPoint(this, posn, xOfs, yOfs + yAdj)
		end, true)
	else
		oPnt = {sBar:GetPoint()}
		sBar:SetPoint(oPnt[1], oPnt[2], oPnt[3], oPnt[4], oPnt[5] + yAdj)
	end

end
local function changeUFOpacity()

	-- handle in combat
	if _G.InCombatLockdown() then
	    aObj:add2Table(aObj.oocTab, {changeUFOpacity, {nil}})
	    return
	end

	for _, uf in _G.pairs(unitFrames) do
		if _G[uf].sf then
			_G[uf].sf:SetAlpha(db.alpha)
		end
		if _G[uf].totFrame
		and _G[uf].totFrame.sf
		then
			_G[uf].totFrame.sf:SetAlpha(db.alpha)
		end
	end
	for i = 1, _G.MAX_BOSS_FRAMES do
		if _G["Boss" .. i .. "TargetFrame"].sf then
			_G["Boss" .. i .. "TargetFrame"].sf:SetAlpha(db.alpha)
		end
	end
	for i = 1, _G.MAX_PARTY_MEMBERS do
		if _G["PartyMemberFrame" .. i].sf then
			_G["PartyMemberFrame" .. i].sf:SetAlpha(db.alpha)
			_G["PartyMemberFrame" .. i .. "PetFrame"].sf:SetAlpha(db.alpha)
		end
	end
	if _G.PartyMemberBackground.sf then
		_G.PartyMemberBackground:SetAlpha(db.alpha)
	end

	if _G.C_AddOns.IsAddOnLoaded("Blizzard_ArenaUI") then
		if _G.ArenaPrepBackground.sf then
			_G.ArenaPrepBackground.sf:SetAlpha(db.alpha)
		end
		if _G.ArenaEnemyBackground.sf then
			_G.ArenaEnemyBackground.sf:SetAlpha(db.alpha)
		end
		-- MAX_ARENA_ENEMIES is Deprecated
		-- for i = 1, _G.MAX_ARENA_ENEMIES do
		-- 	if _G["ArenaEnemyFrame" .. i].sf then
		-- 		_G["ArenaEnemyFrame" .. i].sf:SetAlpha(db.alpha)
		-- 		_G["ArenaEnemyFrame" .. i .. "PetFrame"].sf:SetAlpha(db.alpha)
		-- 	end
		-- end
	end

end
function module:adjustUnitFrames(opt)

	if opt == "init" then
		self:skinPlayerF()
		self:skinPetF()
		self:skinTargetF()
		self:skinFocusF()
		self:skinPartyF()
		self:skinPartyTooltip()
	elseif opt == "player" then
		self:skinPlayerF()
	elseif opt == "pet" then
		self:skinPetF()
	elseif opt == "target" then
		self:skinTargetF()
	elseif opt == "focus" then
		self:skinFocusF()
	elseif opt == "party" then
		self:skinPartyF()
		self:skinPartyTooltip()
	elseif opt == "alpha" then
		changeUFOpacity()
	end

end

function module.skinUnitButton(_, opts)

	-- setup offset values
	opts.ofs = opts.ofs or 0
	opts.x1 = opts.x1 or opts.ofs * -1
	opts.y1 = opts.y1 or opts.ofs
	opts.x2 = opts.x2 or opts.ofs
	opts.y2 = opts.y2 or opts.ofs * -1
	aObj:skinObject("button", {obj=opts.obj, fType=ftype, subt=true, shat=true, bg=true, bd=11, ng=true, x1=opts.x1, y1=opts.y1, x2=opts.x2, y2=opts.y2})
	opts.obj.sb:SetBackdropColor(0.1, 0.1, 0.1, db.alpha) -- use dark background

	if opts.ti
	and opts.obj.threatIndicator
	then
		opts.obj.threatIndicator:ClearAllPoints()
		opts.obj.threatIndicator:SetAllPoints(opts.obj.sb)
		aObj:changeTex(opts.obj.threatIndicator, true, true)
		-- stop changes to texture
		for _, method in _G.pairs{"SetAtlas", "SetTexture", "SetTexCoord", "SetWidth", "SetHeight", "SetPoint"} do
			aObj:RawHook(opts.obj.threatIndicator, method, function(_, _)
				_G.nop()
			end, true)
		end
	end

end

function module:skinPlayerF()

	if db.player
	and not self.isSkinned["Player"]
	then
		local function skinPlayerFrame(frame)
			if _G.InCombatLockdown() then
			    aObj:add2Table(aObj.oocTab, {skinPlayerFrame, {frame}})
			    return
			end
			-- PowerBarAlt handled in MainMenuBar function (UIF)
			-- casting bar handled in CastingBar function (PF)
			_G.PlayerFrameBackground:SetTexture(nil)
			_G.PlayerFrameTexture:SetAlpha(0) -- texture file is changed dependant upon in vehicle or not
			_G.PlayerFrameVehicleTexture:SetAlpha(0) -- texture file is changed dependant upon in vehicle or not
			_G.PlayerStatusTexture:SetTexture(nil)
			_G.PlayerRestGlow:SetTexture(nil)
			_G.PlayerAttackGlow:SetTexture(nil)
			_G.PlayerAttackBackground:SetTexture(nil)
			frame.threatIndicator = _G.PlayerAttackBackground
			aObj:skinObject("statusbar", {obj=frame.healthbar, fi=0})
			aObj:skinObject("statusbar", {obj=frame.manabar, fi=0, nilFuncs=true})
			module:adjustStatusBarPosn(frame.healthbar)
			-- move level & rest icon down, so they are more visible
			module:SecureHook("PlayerFrame_UpdateLevelTextAnchor", function(level)
				_G.PlayerLevelText:SetPoint("CENTER", _G.PlayerFrameTexture, "CENTER", level == 100 and -62 or -61, -20 + lOfs)
			end)
			_G.PlayerRestIcon:SetPoint("TOPLEFT", 36, -63)
			aObj:keepFontStrings(_G.PlayerFrameGroupIndicator)
			if aObj.uCls == "DRUID"
			or aObj.uCls == "ROGUE"
			then
				for _, cp in _G.pairs(_G.ComboFrame.ComboPoints) do
					cp:DisableDrawLayer("BACKGROUND")
				end
			end
			if aObj.uCls == "SHAMAN"
			or aObj.uCls == "DEATHKNIGHT"
			then
				for i = 1, _G.MAX_TOTEMS do
					_G["TotemFrameTotem" .. i .. "Background"]:SetAlpha(0) -- texture is changed
					aObj:getRegion(aObj:getChild(_G["TotemFrameTotem" .. i], 2), 1):SetAlpha(0) -- Totem Border texture
				end
				aObj:moveObject{obj=_G.TotemFrameTotem1, y=lOfs} -- covers level text when active
			end
		end
		self:SecureHookScript(_G.PlayerFrame, "OnShow", function(this)
			skinPlayerFrame(this)

			self:Unhook(this, "OnShow")
		end)
		aObj:checkShown(_G.PlayerFrame)
	end

end

function module:skinPetF()

	if not (aObj.uCls == "HUNTER" or aObj.uCls == "WARLOCK") then
		return
	end

	-- aObj:Debug("skinPetFrame[ %s, %s, %s]", aObj.uCls, db.pet, not _G.rawget(module.isSkinned, "Pet"))

	if db.pet
	and not self.isSkinned["Pet"]
	then
		local function skinPetFrame(frame)
			if _G.InCombatLockdown() then
			    aObj:add2Table(aObj.oocTab, {skinPetFrame, {frame}})
			    return
			end
			module:skinUnitButton{obj=frame, ti=true, x1=1}
			-- casting bar handled in CastingBar function
			_G.PetPortrait:SetDrawLayer("BORDER") -- move portrait to BORDER layer, so it is displayed
			-- N.B. DON'T move the frame as it causes taint
			_G.PetFrameTexture:SetAlpha(0) -- texture file is changed dependant upon in vehicle or not
			_G.PetAttackModeTexture:SetTexture(nil)
			-- status bars
			aObj:skinObject("statusbar", {obj=_G.PetFrameHealthBar, fi=0})
			aObj:skinObject("statusbar", {obj=_G.PetFrameManaBar, fi=0, nilFuncs=true})
			module:adjustStatusBarPosn(_G.PetFrameHealthBar, 0)
			module:adjustStatusBarPosn(_G.PetFrameManaBar, -1)
			if db.petlvl
			and aObj.uCls == "HUNTER"
			then
				-- Add pet level to pet frame, if required
				frame.level = frame:CreateFontString(nil, "artwork", "GameNormalNumberFont")
				frame.level:SetPoint("bottomleft", 5, 5)
				frame.level:SetText(_G.UnitLevel("pet"))
				-- get Pet's Level when changed
				local function setLvl()
					if _G.UnitIsVisible("pet") then
						_G.PetFrame.level:SetText(_G.UnitLevel("pet"))
					end
				end
				-- get level when pet changes
				module:RegisterEvent("UNIT_PET", function(_)
					setLvl()
				end)
				module:RegisterEvent("UNIT_LEVEL", function(_)
					setLvl()
				end)
			end
			if _G.PetFrameHappiness
			and aObj.modBtnBs
			then
				aObj:addButtonBorder{obj=_G.PetFrameHappiness, ofs=1, clr="gold"}
			end
		end
		self:SecureHookScript(_G.PetFrame, "OnShow", function(this)
			skinPetFrame(this)

			self:Unhook(this, "OnShow")
		end)
		aObj:checkShown(_G.PetFrame)
	end

end

local hBar, mBar
function module:skinCommon(fName, adjSB)

	local fo = _G[fName]
	_G[fName .. "Background"]:SetTexture(nil)
	_G[fName .. "TextureFrameTexture"]:SetAlpha(0)

	hBar = _G[fName .. "HealthBar"]
	mBar = _G[fName .. "ManaBar"]
	-- Retail also has a .TempMaxHealthLoss statusbar
	aObj:skinObject("statusbar", {obj=hBar, fi=0, other=aObj.isClsc and {fo.MyHealPredictionBar, fo.OtherHealPredictionBar} or nil})
	aObj:skinObject("statusbar", {obj=mBar, fi=0, hookFunc=true})
	if adjSB then
		self:adjustStatusBarPosn(hBar)
	end

end

function module:skinButton(fName, ti)

	local fObj = _G[fName]
	local x1Ofs, y1Ofs, x2Ofs, y2Ofs
	if fObj.isBossFrame then
		x1Ofs, y1Ofs, x2Ofs, y2Ofs = -1, -14, -72, -10
	else
		x1Ofs, y1Ofs, x2Ofs, y2Ofs = -2, -5, -35, 0
		-- move level & highlevel down, so they are more visible
		aObj:moveObject{obj=_G[fName .. "TextureFrameLevelText"], x=2, y=lOfs}
	end

	self:skinUnitButton{obj=fObj, ti=ti or true, x1=x1Ofs, y1=y1Ofs, x2=x2Ofs, y2=y2Ofs}
	self:skinCommon(fName, true)
	if not aObj.isClscERA then
		if fObj.threatNumericIndicator then
			fObj.threatNumericIndicator:DisableDrawLayer("ARTWORK")
		end
	end

	-- create a texture to show UnitClassification
	fObj.ucTex = fObj:CreateTexture(nil, "ARTWORK")
	fObj.ucTex:SetSize(80, 50)
	fObj.ucTex:SetPoint("CENTER", fObj.isBossFrame and 36 or 86, (fObj.isBossFrame and -15 or -25) + lOfs)

	if fObj.spellbar then
		aObj:changeShield(fObj.spellbar.BorderShield, fObj.spellbar.Icon)
		fObj.spellbar.Border:SetAlpha(0) -- texture file is changed dependant upon spell type
		aObj:adjHeight{obj=fObj.spellbar, adj=2}
		fObj.spellbar.Flash:SetAllPoints()
		fObj.spellbar.Text:ClearAllPoints()
		fObj.spellbar.Text:SetPoint("TOP", 0, 3)
		aObj:skinObject("statusbar", {obj=fObj.spellbar, fi=0, bg=aObj:getRegion(fObj.spellbar, 1), other={fObj.spellbar.Flash}})
	end

	-- PowerBarAlt handled in MainMenuBar function (UIF)

end

function module:skinTargetF()

	if db.target
	and not self.isSkinned["Target"]
	then
		local function skinTargetFrame(frame)
			if _G.InCombatLockdown() then
			    aObj:add2Table(aObj.oocTab, {skinTargetFrame, {frame}})
			    return
			end
			module:skinButton(frame:GetName())
			module:skinUnitButton{obj=frame.totFrame}
			module:skinCommon(frame.totFrame:GetName(), true)
			-- move level text down, so it is more visible
			module:SecureHook("TargetFrame_UpdateLevelTextAnchor", function(fObj, targetLevel)
				fObj.levelText:SetPoint("CENTER", targetLevel == 100 and 61 or 62, -20 + lOfs)
			end)
			aObj:moveObject{obj=_G["TargetFrameToTHealthBar"], y=-2} -- move HealthBar down to match other frames
		end
		self:SecureHookScript(_G.TargetFrame, "OnShow", function(this)
			skinTargetFrame(this)

			self:Unhook(this, "OnShow")
		end)
		aObj:checkShown(_G.TargetFrame)

		local function skinBossTargetFrame(frame)
			if _G.InCombatLockdown() then
			    aObj:add2Table(aObj.oocTab, {skinBossTargetFrame, {frame}})
			    return
			end
			module:skinButton(frame:GetName(), false)
			frame.ucTex:SetTexture(aObj.tFDIDs.enI)
		end
		for i = 1, _G.MAX_BOSS_FRAMES do
			self:SecureHookScript(_G["Boss" .. i .. "TargetFrame"], "OnShow", function(this)
				skinBossTargetFrame(this)

				self:Unhook(this, "OnShow")
			end)
			aObj:checkShown(_G["Boss" .. i .. "TargetFrame"])
		end

	end

end

function module:skinFocusF()

	if db.focus
	and not self.isSkinned["Focus"]
	then
		local function skinFocusFrame(frame)
			if _G.InCombatLockdown() then
			    aObj:add2Table(aObj.oocTab, {skinFocusFrame, {frame}})
			    return
			end
			module:skinButton(frame:GetName(), false)
			module:skinUnitButton{obj=frame.totFrame, x2=4, y2=4}
			module:skinCommon(frame.totFrame:GetName(), true)
			aObj:moveObject{obj=_G["FocusFrameToTHealthBar"], y=-2} -- move HealthBar down to match other frames
		end
		self:SecureHookScript(_G.FocusFrame, "OnShow", function(this)
			skinFocusFrame(this)

			self:Unhook(this, "OnShow")
		end)
		aObj:checkShown(_G.FocusFrame)
	end

end

function module:skinPartyF()

	if db.party
	and not self.isSkinned["Party"]
	then
		local function skinPartyMemberFrame(frame)
			if _G.InCombatLockdown() then
			    aObj:add2Table(aObj.oocTab, {skinPartyMemberFrame, {frame}})
			    return
			end
			module:skinUnitButton{obj=frame, ti=true, x1=2, y1=5, x2=-1}
			local pMF = frame:GetName()
			_G[pMF .. "Background"]:SetTexture(nil)
			_G[pMF .. "Texture"]:SetAlpha(0) -- texture file is changed dependant upon in vehicle or not
			_G[pMF .. "VehicleTexture"]:SetAlpha(0) -- texture file is changed dependant upon in vehicle or not
			_G[pMF .. "Status"]:SetTexture(nil)
			aObj:skinObject("statusbar", {obj=_G[pMF .. "HealthBar"], fi=0})
			aObj:skinObject("statusbar", {obj=_G[pMF .. "ManaBar"], fi=0, nilFuncs=true})
			-- PowerBarAlt handled in MainMenuBar function (UIFrames.lua)
			-- pet frame
			local pPF = pMF .. "PetFrame"
			module:skinUnitButton{obj=_G[pPF], ti=true, x1=-2, y1=1, y2=1}
			_G[pPF .. "Texture"]:SetAlpha(0) -- texture file is changed dependant upon in vehicle or not
			aObj:skinObject("statusbar", {obj=_G[pPF .. "HealthBar"], fi=0})
		end
		for i = 1, _G.MAX_PARTY_MEMBERS do
			self:SecureHookScript(_G["PartyMemberFrame" .. i], "OnShow", function(this)
				skinPartyMemberFrame(this)

				self:Unhook(this, "OnShow")
			end)
			aObj:checkShown(_G["PartyMemberFrame" .. i])
		end
		aObj:skinObject("frame", {obj=_G.PartyMemberBackground, fType=ftype, x1=4, y2=2})
	end

end

function module:skinPartyTooltip()

	if db.pet
	or db.party
	then
		local function skinPartyMemberBuffTooltip(frame)
			if _G.InCombatLockdown() then
			    aObj:add2Table(aObj.oocTab, {skinPartyMemberBuffTooltip, {frame}})
			    return
			end
			aObj:skinObject("frame", {obj=frame, fType=ftype, kfs=true, ofs=-1, x1=2, y1=-2})
			for i = 1, _G.MAX_PARTY_TOOLTIP_DEBUFFS do
				_G["PartyMemberBuffTooltipDebuff" .. i]:DisableDrawLayer("OVERLAY")
				if aObj.modBtnBs then
					aObj:addButtonBorder{obj=_G["PartyMemberBuffTooltipDebuff" .. i], fType=ftype, relTo=_G["PartyMemberBuffTooltipDebuff" .. i .. "Icon"], ofs=3}
				end
			end
			if aObj.modBtnBs then
				for i = 1, _G.MAX_PARTY_TOOLTIP_BUFFS do
					aObj:addButtonBorder{obj=_G["PartyMemberBuffTooltipBuff" .. i], fType=ftype, relTo=_G["PartyMemberBuffTooltipBuff" .. i .. "Icon"], ofs=3}
				end
			end
		end
		if not self:IsHooked(_G.PartyMemberBuffTooltip, "OnShow") then
			self:SecureHookScript(_G.PartyMemberBuffTooltip, "OnShow", function(this)
				skinPartyMemberBuffTooltip(this)

				self:Unhook(this, "OnShow")
			end)
		end
	end

end

function module:OnInitialize()

	-- disable ourself if another unitframe addon is loaded
	if _G.C_AddOns.IsAddOnLoaded("Perl_Config")
	or _G.C_AddOns.IsAddOnLoaded("XPerl")
	then
		self:SetEnabledState(false)
	end

	self.db = aObj.db:RegisterNamespace("UnitFrames", defaults)
	db = self.db.profile

	-- convert any old settings
	if aObj.db.profile.UnitFrames then
		for k, v in _G.pairs(aObj.db.profile.UnitFrames) do
			db[k] = v
		end
		aObj.db.profile.UnitFrames = nil
	end

	 -- disable ourself if required
	if not db.player
	and not db.target
	and not db.focus
	and not db.party
	and not db.pet
	and not db.arena
	then
		self:SetEnabledState(false)
	end

end

function module:OnDisable()

	self:UnhookAll()

	aObj.blizzLoDFrames[ftype].ArenaUI = _G.nop

end

function module:OnEnable()

	if db.target
	or db.focus
	then
		local function chgTex(frame)
			if (frame == _G.TargetFrame
			or frame == _G.FocusFrame)
			and frame.ucTex
			then
				local classification = _G.UnitClassification(frame.unit)
				if classification == "worldboss"
				or classification == "elite"
				then
					frame.ucTex:SetTexture(aObj.tFDIDs.enI)
				elseif classification == "rareelite" then
					frame.ucTex:SetTexture(aObj.tFDIDs.renI)
				elseif classification == "rare" then
					frame.ucTex:SetTexture(aObj.tFDIDs.rareNP)
				else
					frame.ucTex:SetTexture(nil)
				end
			end
		end
		-- hook this to show/hide the elite texture
		self:SecureHook("TargetFrame_CheckClassification", function(frame, _)
			chgTex(frame)
		end)
	end

	self:adjustUnitFrames("init")

end

function module:GetOptions()

	local options = {
		type = "group",
		name = aObj.L["Unit Frames"],
		desc = aObj.L["Change the Unit Frames settings"],
		get = function(info) return db[info[#info]] end,
		set = function(info, value)
			if not self:IsEnabled() then self:Enable() end
			db[info[#info]] = value
			 -- enable pet frame when enabled (Classic Support)
			if info[#info] == "petlvl"
			and value == true
			then
				db.pet = true
			end
			-- disable if required
			if info[#info] == "pet"
			and value == false
			then
				if db.petlvl then db.petlvl = value end
			end
			self:adjustUnitFrames(info[#info])
		end,
		args = {
			player = {
				type = "toggle",
				order = 1,
				name = aObj.L["Player"],
			},
			pet = (aObj.uCls == "HUNTER" or aObj.uCls == "WARLOCK") and {
				type = "toggle",
				order = 2,
				name = aObj.L["Pet"],
			} or nil,
			petlvl = aObj.uCls == "HUNTER" and {
				type = "toggle",
				order = 4,
				name = aObj.L["Pet Level"],
			} or nil,
			target = {
				type = "toggle",
				order = 4,
				name = aObj.L["Target"],
			},
			focus = {
				type = "toggle",
				order = 5,
				name = aObj.L["Focus"],
			},
			party = {
				type = "toggle",
				order = 6,
				name = aObj.L["Party"],
			},
			arena = {
				type = "toggle",
				order = 8,
				name = aObj.L["Arena"],
			},
			alpha = {
				type = "range",
				order = 10,
				width = "double",
				name = aObj.L["Unit Frame Background Opacity"],
				min = 0, max = 1, step = 0.05,
			},
		},
	}
	return options

end

aObj.blizzLoDFrames[ftype].ArenaUI = function(_)

	if db.arena then
		local function skinArenaFrame(fName)
			if _G.InCombatLockdown() then
			    aObj:add2Table(aObj.oocTab, {skinArenaFrame, {fName}})
			    return
			end
			module:skinUnitButton{obj=_G[fName], x1=-3, x2=3, y2=-6}
			_G[fName .. "Background"]:SetTexture(nil)
			_G[fName .. "Texture"]:SetTexture(nil)
			_G[fName .. "Status"]:SetTexture(nil)
			_G[fName .. "SpecBorder"]:SetTexture(nil)
			aObj:skinObject("statusbar", {obj=_G[fName .. "HealthBar"], fi=0})
			aObj:skinObject("statusbar", {obj=_G[fName .. "ManaBar"], fi=0, nilFuncs=true})
			local cBar = fName .. "CastingBar"
			aObj:adjHeight{obj=_G[cBar], adj=2}
			aObj:moveObject{obj=_G[cBar].Text, y=-1}
			_G[cBar].Flash:SetAllPoints()
			aObj:skinObject("statusbar", {obj=_G[cBar], fi=0, bg=aObj:getRegion(_G[cBar], 1), other={_G[cBar].Flash}})
			-- _G[cBar]:SetStatusBarColor(0, 1, 0)
			if _G[fName].petFrame then
				fName = fName .. "PetFrame"
				module:skinUnitButton{obj=_G[fName], y1=1, x2=1, y2=2}
				_G[fName .. "Flash"]:SetTexture(nil)
				_G[fName .. "Texture"]:SetTexture(nil)
				aObj:skinObject("statusbar", {obj=_G[fName .. "HealthBar"], fi=0})
				aObj:skinObject("statusbar", {obj=_G[fName .. "ManaBar"], fi=0, nilFuncs=true})
				aObj:moveObject{obj=_G[fName], x=-17} -- align under ArenaEnemy Health/Mana bars
			end
		end
		if not aObj.isMnln then
			for i = 1, _G.MAX_ARENA_ENEMIES do
				skinArenaFrame("ArenaPrepFrame" .. i)
				skinArenaFrame("ArenaEnemyFrame" .. i)
			end
		else
			for _, frame in _G.pairs(_G.ArenaEnemyPrepFramesContainer.UnitFrames) do
				skinArenaFrame(frame:GetName())
			end
			for _, frame in _G.pairs(_G.ArenaEnemyMatchFramesContainer.UnitFrames) do
				skinArenaFrame(frame:GetName())
			end
		end
		aObj:skinObject("frame", {obj=_G.ArenaPrepBackground, fType=ftype})
		aObj:skinObject("frame", {obj=_G.ArenaEnemyBackground, fType=ftype})
	end

end
