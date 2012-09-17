local aName, aObj = ...
local _G = _G
local ftype = "p"
local module = aObj:NewModule("UnitFrames", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")

local db, aso, plt
local defaults = {
	profile = {
		player = false,
		target = false,
		focus = false,
		party = false,
		pet = false,
		petlevel = (aObj.uCls == "HUNTER" or aObj.uCls == "WARLOCK") and false or nil,
		alpha = 0.25,
		arena = false,
	}
}
local lOfs = -10 -- level text offset
local totOfs = -12 -- TargetofTarget frame offset
local tDelay = 0.2 -- repeating timer delay
local isSkinned = setmetatable({}, {__index = function(table, key) table[key] = true end})
local rpTmr = {}
local unitFrames = {
	"PlayerFrame", "PetFrame", "TargetFrame", "TargetFrameToT", "FocusFrame", "FocusFrameToT", "PartyMemberBuffTooltip", "PartyMemberBackground", "ArenaEnemyBackground"
}

local function skinPlayerF()

	if db.player
	and not isSkinned["Player"]
	then
		PlayerFrameBackground:SetTexture(nil)
		PlayerFrameTexture:SetAlpha(0) -- texture file is changed dependant upon in vehicle or not
		PlayerFrameVehicleTexture:SetAlpha(0) -- texture file is changed dependant upon in vehicle or not
		PlayerStatusTexture:SetTexture(nil)
		PlayerAttackBackground:SetTexture(nil)
		PlayerRestGlow:SetTexture(nil)
		PlayerAttackGlow:SetTexture(nil)
		-- status bars
		aObj:glazeStatusBar(PlayerFrameHealthBar, 0)
		aObj:adjHeight{obj=PlayerFrameHealthBar , adj=-1} -- handle bug in PlayerFrame XML & lua which places mana bar 11 pixels below the healthbar, when their heights are 12
		aObj:glazeStatusBar(PlayerFrameManaBar, 0)
		-- casting bar handled in CastingBar function (UIE1)
		-- move PVP Icon/Timer text up & right
		aObj:moveObject{obj=PlayerPVPIcon, x=2, y=25}
		aObj:moveObject{obj=PlayerPVPTimerText, x=34, y=2}
		-- move level & rest icon down, so they are more visible
		aObj:moveObject{obj=PlayerLevelText, y=lOfs}
		aObj:moveObject{obj=PlayerRestIcon, y=lOfs} -- covers level text when resting
		-- remove group indicator textures
		aObj:keepFontStrings(PlayerFrameGroupIndicator)
		aObj:moveObject{obj=PlayerFrameGroupIndicatorText, y=-1}
		aObj:addSkinFrame{obj=PlayerFrame, ft=ftype, noBdr=true, aso=aso, x1=37, y1=-7, y2=aObj.uCls == "PALADIN" and 3 or 6}
		--	skin the TotemFrame
		for i = 1, MAX_TOTEMS do
			_G["TotemFrameTotem"..i.."Background"]:SetAlpha(0)
			aObj:getRegion(aObj:getChild(_G["TotemFrameTotem"..i], 2), 1):SetAlpha(0) -- Totem Border texture
		end
		aObj:moveObject{obj=TotemFrameTotem1, y=lOfs} -- covers level text when active

		--	skin the RuneFrame, if required
		if aObj.uCls == "DEATHKNIGHT" then
			for i = 1, 6 do
				_G["RuneButtonIndividual"..i.."BorderTexture"]:SetTexture(nil)
			end
		end
		-- skin the AlternateManaBar & EclipseBarFrame, if required
		if aObj.uCls == "DRUID" then
			PlayerFrameAlternateManaBarBorder:SetTexture(nil)
			aObj:glazeStatusBar(PlayerFrameAlternateManaBar, 0)
			EclipseBarFrameBar:Hide()
			EclipseBarFrame.sunBar:Hide()
			EclipseBarFrame.moonBar:Hide()
		end
		-- skin the ShardBarFrame/DemonicFuryBarFrame/BurningEmbersBarFrame, if required
		if aObj.uCls == "WARLOCK" then
			-- ShardBarFrame
			ShardBarFrame:DisableDrawLayer("BACKGROUND")
			for i = 1, ShardBarFrame.shardCount do
				_G["ShardBarFrameShard"..i]:DisableDrawLayer("BORDER")
				_G["ShardBarFrameShard"..i]:DisableDrawLayer("OVERLAY") -- Glow textures
			end
			-- DemonicFuryBarFrame
			DemonicFuryBarFrame:DisableDrawLayer("ARTWORK") -- frame border texture
			-- BurningEmbersBarFrame
			BurningEmbersBarFrame:DisableDrawLayer("BACKGROUND")
			for i = 1, BurningEmbersBarFrame.emberCount do
				_G["BurningEmbersBarFrameEmber"..i]:DisableDrawLayer("BORDER")
				_G["BurningEmbersBarFrameEmber"..i]:DisableDrawLayer("OVERLAY") -- Glow textures
			end
		end
		-- skin the PowerBar, if required
		if aObj.uCls == "PALADIN" then
			PaladinPowerBar:DisableDrawLayer("BACKGROUND")
			PaladinPowerBar.glow:DisableDrawLayer("BACKGROUND")
		end
		-- skin the ManaBar, if required
		if aObj.uCls == "MONK" then
			PlayerFrameAlternateManaBar:Hide()
			aObj:removeRegions(MonkHarmonyBar, {1, 2})
		end
		-- skin the bar, if required
		if aObj.uCls == "PRIEST" then
			PriestBarFrame:DisableDrawLayer("BACKGROUND")
			aObj:moveObject{obj=PriestBarFrame.orb1, y=6}
		end
	end

end
local function skinPetF()

	if db.pet
	and not isSkinned["Pet"]
	then
		PetFrameTexture:SetAlpha(0) -- texture file is changed dependant upon in vehicle or not
		PetAttackModeTexture:SetTexture(nil)
		-- status bars
		aObj:glazeStatusBar(PetFrameHealthBar, 0)
		aObj:adjHeight{obj=PetFrameHealthBar, adj=-1} -- handle bug in PetFrame XML & lua which places mana bar 7 pixels below the healthbar, when their heights are 8
		aObj:glazeStatusBar(PetFrameManaBar, 0)
		-- casting bar handled in CastingBar function (UIE1)
		aObj:moveObject{obj=PetFrame, x=20, y=1} -- align under Player Health/Mana bars
		aObj:addSkinFrame{obj=PetFrame, ft=ftype, noBdr=true, aso=aso, x1=2, y1=-1, x2=1}
		-- Add Pet's Level to frame if required (only for Hunter/Warlock pets)
		if db.petlevel
		and aObj.uCls == "HUNTER"
		or aObj.uCls == "WARLOCK"
		then
			if not PetFrame.lvl then
				PetFrame.lvl = aObj.skinFrame[PetFrame]:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
				PetFrame.lvl:SetPoint("BOTTOMLEFT", 4, 4)
				local function checkLevel(event, ...)

					PetFrame.lvl:SetText(UnitLevel(PetFrame.unit))

				end
				module:SecureHook("PetFrame_Update", function(this, ...)
					checkLevel("pfu")
				end)
				module:RegisterEvent("PET_BAR_UPDATE", checkLevel) -- for pet changes
				module:RegisterEvent("UNIT_PET", checkLevel) -- for pet changes
				module:RegisterEvent("UNIT_PET_EXPERIENCE", checkLevel) -- for levelling
				checkLevel("init")
				PetFrame.lvl:Show()
			else
				PetFrame.lvl:Show()
			end
		elseif PetFrame.lvl then
			PetFrame.lvl:Hide()
		end
	end


end
local function skinToT(frame)

	_G[frame.."Background"]:SetTexture(nil)
	_G[frame.."TextureFrameTexture"]:SetTexture(nil)
	-- status bars
	aObj:glazeStatusBar(_G[frame.."HealthBar"], 0)
	aObj:glazeStatusBar(_G[frame.."ManaBar"], 0)
	aObj:moveObject{obj=_G[frame.."ManaBar"], y=1} -- handle bug in <frame> XML & lua which places mana bar 8 pixels below the healthbar, when their heights are 7
	aObj:moveObject{obj=_G[frame], y=totOfs}

end
local function skinUFrame(frame)

	aObj:addSkinFrame{obj=_G[frame], ft=ftype, noBdr=true, aso=aso, y1=-7, x2=-37, y2=6}
	_G[frame.."Background"]:SetTexture(nil)
	_G[frame.."TextureFrameTexture"]:SetAlpha(0) -- texture file is changed dependant upon mob type
	-- status bars
	aObj:glazeStatusBar(_G[frame.."HealthBar"], 0)
	aObj:adjHeight{obj=_G[frame.."HealthBar"] , adj=-1} -- handle bug in <frame> XML & lua which places mana bar 11 pixels below the healthbar, when their heights are 12
	aObj:glazeStatusBar(_G[frame.."ManaBar"], 0)
	aObj:removeRegions(_G[frame.."NumericalThreat"], {3}) -- threat border
	-- move level & highlevel down, so they are more visible
	aObj:moveObject{obj=_G[frame.."TextureFrameLevelText"], x=2, y=lOfs}
	-- casting bar
	local cBar = frame.."SpellBar"
	aObj:adjHeight{obj=_G[cBar], adj=2}
	_G[cBar.."Text"]:ClearAllPoints()
	_G[cBar.."Text"]:SetPoint("TOP", 0, 3)
	_G[cBar.."Flash"]:SetAllPoints()
	_G[cBar.."Border"]:SetAlpha(0) -- texture file is changed dependant upon spell type
	aObj:changeShield(_G[cBar.."BorderShield"], _G[cBar.."Icon"])
	aObj:glazeStatusBar(_G[cBar], 0, aObj:getRegion(_G[cBar], 1), {_G[cBar.."Flash"]})
-->>-- TargetofTarget Frame
	skinToT(frame.."ToT")
	aObj:addSkinFrame{obj=_G[frame.."ToT"], ft=ftype, noBdr=true, aso=aso, x2=6, y2=-1}

end
local function skinTargetF()

	local function showEliteTex(uCls, tex)

		if uCls == "worldboss"
		or uCls == "elite"
		then
			tex:SetTexture([[Interface\Tooltips\EliteNameplateIcon]])
		elseif uCls == "rareelite" then
			tex:SetTexture([[Interface\AddOns\]]..aName..[[\textures\RareEliteNameplateIcon]])
		elseif uCls == "rare" then
			tex:SetTexture([[Interface\AddOns\]]..aName..[[\textures\RareNameplateIcon]])
		else tex:SetTexture(nil)
		end

	end

	if db.target
	and not isSkinned["Target"]
	then
		skinUFrame("TargetFrame")

		--	skin the ComboFrame, if required
		if aObj.uCls == "ROGUE"
		or aObj.uCls == "DRUID"
		then
			for i = 1, MAX_COMBO_POINTS do
				aObj:getRegion(_G["ComboPoint"..i], 1):SetTexture(nil)
			end
		end

		-- create a texture to show UnitClassification
		local ucTTex = TargetFrame:CreateTexture(nil, "ARTWORK") -- make it appear above the portrait
		ucTTex:SetWidth(80)
		ucTTex:SetHeight(50)
		ucTTex:SetPoint("CENTER", 86, -22 + lOfs)
		local ucFTex = FocusFrame:CreateTexture(nil, "ARTWORK") -- make it appear above the portrait
		ucFTex:SetWidth(80)
		ucFTex:SetHeight(50)
		ucFTex:SetPoint("CENTER", 86, -22 + lOfs)

		-- hook this to show/hide the elite texture
		module:SecureHook("TargetFrame_CheckClassification", function(frame, ...)
			if frame == TargetFrame then
				showEliteTex(UnitClassification("target"), ucTTex)
			elseif frame == FocusFrame then
				showEliteTex(UnitClassification("focus"), ucFTex)
			end
			-- adjust ComboFrame position dependant upon Target classification, if required
			-- as the threat indicator obscures them when boss/elite etc
			if aObj.uCls == "ROGUE"
			or aObj.uCls == "DRUID"
			then
				ComboFrame:ClearAllPoints()
				if ucTTex:GetTexture() then
					ComboFrame:SetPoint("TOPRIGHT", TargetFrame, "TOPRIGHT", -32, -7)
				else
					ComboFrame:SetPoint("TOPRIGHT", TargetFrame, "TOPRIGHT", -42, -7)
				end
			end
		end)

	-->>--Boss Target Frames
		for i = 1, MAX_BOSS_FRAMES do
			local frame = "Boss"..i.."TargetFrame"
			_G[frame.."Background"]:SetTexture(nil)
			_G[frame.."TextureFrameTexture"]:SetAlpha(0) -- texture file is changed dependant upon mob type
			aObj:glazeStatusBar(_G[frame.."HealthBar"], 0)
			aObj:glazeStatusBar(_G[frame.."ManaBar"], 0)
			aObj:removeRegions(_G[frame.."NumericalThreat"], {3}) -- threat border
			aObj:addSkinFrame{obj=_G[frame], ft=ftype, noBdr=true, aso=aso, x1=-1,  y1=-14, x2=-72, y2=5}
			-- create a texture to show Elite dragon
			local bcTex = _G[frame.."TextureFrame"]:CreateTexture(nil, "BACKGROUND")
			bcTex:SetWidth(80)
			bcTex:SetHeight(50)
			bcTex:SetPoint("CENTER", 30, -21)
			bcTex:SetTexture([[Interface\Tooltips\EliteNameplateIcon]])
		end
	end

end
local function skinFocusF()

	if db.focus
	and not isSkinned["Focus"]
	then
		skinUFrame("FocusFrame")
	end

end
local function resetPosn(pF)

	-- handle in combat
	if InCombatLockdown() then return end

	_G[pF.."Portrait"]:SetPoint("TOPLEFT", 7, -6)
	_G[pF.."LeaderIcon"]:SetPoint("TOPLEFT")
	_G[pF.."MasterIcon"]:SetPoint("TOPLEFT", 32, 0)
	_G[pF.."PVPIcon"]:SetPoint("TOPLEFT", -9, -15)
	_G[pF.."Disconnect"]:SetPoint("LEFT", -7, -1)

	-- cancel repeating timer
	module:CancelTimer(rpTmr[_G[pF]], true)
	rpTmr[_G[pF]] = nil

end
local function skinPartyF()

	local pF
	if db.party
	and not isSkinned["Party"]
	then
		-- hook this to change positions
		module:SecureHook("PartyMemberFrame_ToVehicleArt", function(this, ...)
			if not rpTmr[this] then
				rpTmr[this] = module:ScheduleRepeatingTimer(resetPosn, tDelay, this:GetName())
			end
		end)

		for i = 1, MAX_PARTY_MEMBERS do
			pF = "PartyMemberFrame"..i
			aObj:moveObject{obj=_G[pF.."Portrait"], y=6}
			--[=[
				TODO stop portrait being moved
			--]=]
			_G[pF.."Background"]:SetTexture(nil)
			_G[pF.."Texture"]:SetAlpha(0) -- texture file is changed dependant upon in vehicle or not
			_G[pF.."VehicleTexture"]:SetAlpha(0) -- texture file is changed dependant upon in vehicle or not
			_G[pF.."Status"]:SetTexture(nil)

			-- reset positions if required
			if _G[pF].state == "vehicle" then
				rpTmr[_G[pF]] = module:ScheduleRepeatingTimer(resetPosn, tDelay, pF)
			end
			-- status bars
			aObj:glazeStatusBar(_G[pF.."HealthBar"], 0)
			aObj:glazeStatusBar(_G[pF.."ManaBar"], 0)
			aObj:addSkinFrame{obj=_G[pF], ft=ftype, noBdr=true, aso=aso, x1=2, y1=5, x2=-1}

			-- pet frame
			local pPF = pF.."PetFrame"
			_G[pPF.."Flash"]:SetTexture(nil)
			_G[pPF.."Texture"]:SetAlpha(0) -- texture file is changed dependant upon in vehicle or not
			-- status bar
			aObj:glazeStatusBar(_G[pPF.."HealthBar"], 0)
			aObj:addSkinFrame{obj=_G[pPF], ft=ftype, noBdr=true, aso=aso, x1=-2, y1=1, y2=1}

		end
		-- PartyMember Buff Tooltip
		aObj:addSkinFrame{obj=PartyMemberBuffTooltip, ft=ftype, noBdr=true, aso=aso, x1=2, y1=-2, x2=-2, y2=2}
		-- PartyMemberBackground
		aObj:addSkinFrame{obj=PartyMemberBackground, ft=ftype, x1=4, y1=2, x2=1, y2=2}
	end

end
local function skinArenaF()

	if db.arena
	and not isSkinned["Arena"]
	then
		local aF, aPF, cBar
		aObj:SecureHook("Arena_LoadUI", function()
			for i = 1, MAX_ARENA_ENEMIES do
				aF = "ArenaEnemyFrame"..i
				_G[aF.."Background"]:SetTexture(nil)
				_G[aF.."Texture"]:SetTexture(nil)
				_G[aF.."Status"]:SetTexture(nil)

				-- status bars
				aObj:glazeStatusBar(_G[aF.."HealthBar"], 0)
				aObj:glazeStatusBar(_G[aF.."ManaBar"], 0)
				aObj:addSkinFrame{obj=_G[aF], ft=ftype, noBdr=true, aso=aso, x1=-3, x2=3, y2=-6}

				-- pet frame
				aPF = aF.."PetFrame"
				_G[aPF.."Flash"]:SetTexture(nil)
				_G[aPF.."Texture"]:SetTexture(nil)
				-- status bar
				aObj:glazeStatusBar(_G[aPF.."HealthBar"], 0)
				aObj:addSkinFrame{obj=_G[aPF], ft=ftype, noBdr=true, aso=aso, y1=1, x2=1, y2=2}
				-- move pet frame
				aObj:moveObject{obj=_G[aPF], x=-17} -- align under ArenaEnemy Health/Mana bars

				-- casting bar
				cBar = aF.."CastingBar"
				aObj:adjHeight{obj=_G[cBar], adj=2}
				aObj:moveObject{obj=_G[cBar.."Text"], y=-1}
				_G[cBar.."Flash"]:SetAllPoints()
				aObj:glazeStatusBar(_G[cBar], 0, aObj:getRegion(_G[cBar], 1), {_G[cBar.."Flash"]})
			end
			-- ArenaEnemyBackground
			aObj:addSkinFrame{obj=ArenaEnemyBackground, ft=ftype}
			aObj:Unhook("Arena_LoadUI")
		end)
	end

end
local function changeUFOpacity()

	local r, g, b = unpack(aObj.bColour)

	for _, uFrame in pairs(unitFrames) do
		if aObj.skinFrame[_G[uFrame]] then
			aObj.skinFrame[_G[uFrame]]:SetBackdropColor(r, g, b, db.alpha)
		end
	end
	for i = 1, MAX_PARTY_MEMBERS do
		if aObj.skinFrame[_G["PartyMemberFrame"..i]] then
			aObj.skinFrame[_G["PartyMemberFrame"..i]]:SetBackdropColor(r, g, b, db.alpha)
			aObj.skinFrame[_G["PartyMemberFrame"..i.."PetFrame"]]:SetBackdropColor(r, g, b, db.alpha)
		end
	end
	for i = 1, MAX_BOSS_FRAMES do
		if aObj.skinFrame[_G["Boss"..i.."TargetFrame"]] then
			aObj.skinFrame[_G["Boss"..i.."TargetFrame"]]:SetBackdropColor(r, g, b, db.alpha)
		end
	end
	for i = 1, MAX_ARENA_ENEMIES do
		if aObj.skinFrame[_G["ArenaEnemyFrame"..i]] then
			aObj.skinFrame[_G["ArenaEnemyFrame"..i]]:SetBackdropColor(r, g, b, db.alpha)
			aObj.skinFrame[_G["ArenaEnemyFrame"..i.."PetFrame"]]:SetBackdropColor(r, g, b, db.alpha)
		end
	end

end

function module:OnInitialize()

	self.db = aObj.db:RegisterNamespace("UnitFrames", defaults)
	db = self.db.profile

	-- convert any old settings
	if aObj.db.profile.UnitFrames then
		for k, v in pairs(aObj.db.profile.UnitFrames) do
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
		self:Disable()
	end

	-- setup default applySkin options
	aso = {ba=db.alpha, ng=true}

end

function module:OnEnable()

	self:adjustUnitFrames("init")

end

function module:adjustUnitFrames(opt)

	if opt == "init" then
		skinPlayerF()
		skinPetF()
		skinTargetF()
		skinFocusF()
		skinPartyF()
		skinArenaF()
	elseif opt == "player" then
		skinPlayerF()
	elseif opt == "pet"
	or opt == "petlevel"
	then
		skinPetF()
	elseif opt == "target" then
		skinTargetF()
	elseif opt == "focus" then
		skinFocusF()
	elseif opt == "party" then
		skinPartyF()
	elseif opt == "arena" then
		skinArenaF()
	elseif opt == "alpha" then
		changeUFOpacity()
	end

end

function module:GetOptions()

	local options = {
		type = "group",
		name = aObj.L["Unit Frames"],
		desc = aObj.L["Change the Unit Frames settings"],
		get = function(info) return module.db.profile[info[#info]] end,
		set = function(info, value)
			if not module:IsEnabled() then module:Enable() end
			module.db.profile[info[#info]] = value
			module:adjustUnitFrames(info[#info])
		end,
		args = {
			player = {
				type = "toggle",
				order = 1,
				name = aObj.L["Player"],
				desc = aObj.L["Toggle the skin of the Player UnitFrame"],
			},
			pet = {
				type = "toggle",
				order = 2,
				name = aObj.L["Pet"],
				desc = aObj.L["Toggle the skin of the Pet UnitFrame"],
				set = (aObj.uCls == "HUNTER" or aObj.uCls == "WARLOCK") and function(info, value)
					module.db.profile[info[#info]] = value
					if not value then module.db.profile.petlevel = false end -- disable petlevel when disabled
					module:adjustUnitFrames(info[#info])
				end or nil,
			},
			petlevel = (aObj.uCls == "HUNTER" or aObj.uCls == "WARLOCK") and {
				type = "toggle",
				order = 3,
				name = aObj.L["Pet Level"],
				desc = aObj.L["Toggle the Pet Level on the Pet Frame"],
				set = function(info, value)
					module.db.profile[info[#info]] = value
					if value then module.db.profile.pet = true end -- enable pet frame when enabled
					module:adjustUnitFrames(info[#info])
				end,
			} or nil,
			target = {
				type = "toggle",
				order = 4,
				name = aObj.L["Target"],
				desc = aObj.L["Toggle the skin of the Target UnitFrame"],
			},
			focus = {
				type = "toggle",
				order = 5,
				name = aObj.L["Focus"],
				desc = aObj.L["Toggle the skin of the Focus UnitFrame"],
			},
			party = {
				type = "toggle",
				order = 6,
				name = aObj.L["Party"],
				desc = aObj.L["Toggle the skin of the Party UnitFrames"],
			},
			arena = {
				type = "toggle",
				order = 8,
				name = aObj.L["Arena"],
				desc = aObj.L["Toggle the skin of the Arena UnitFrames"],
			},
			alpha = {
				type = "range",
				order = 10,
				width = "double",
				name = aObj.L["UnitFrame Background Opacity"],
				desc = aObj.L["Change Opacity value of the UnitFrames Background"],
				min = 0, max = 1, step = 0.05,
			},
		},
	}
	return options

end
