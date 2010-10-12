local _, Skinner = ...
local module = Skinner:NewModule("UnitFrames", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")
local _G = _G
local ftype = "c"

local db, aso, plt
local defaults = {
	profile = {
		player = false,
		target = false,
		focus = false,
		party = false,
		pet = false,
		petlevel = (Skinner.uCls == "HUNTER" or Skinner.uCls == "WARLOCK") and false or nil,
		alpha = 0.25,
		arena = false,
		compact = Skinner.isBeta and false or nil,
	}
}
local lOfs = -10 -- level text offset
local totOfs = -12 -- TargetofTarget frame offset
local tDelay = 0.2 -- repeating timer delay
local isSkinned = setmetatable({}, {__index = function(table, key) table[key] = true end})
local rpTmr = {}
local unitFrames = {
	"PlayerFrame", "PetFrame", "TargetFrame", "TargetFrameToT", "FocusFrame", "FocusFrameToT", "PartyMemberBuffTooltip", "PartyMemberBackground", "ArenaEnemyBackground",
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
		Skinner:glazeStatusBar(PlayerFrameHealthBar, 0)
		Skinner:adjHeight{obj=PlayerFrameHealthBar , adj=-1} -- handle bug in PlayerFrame XML & lua which places mana bar 11 pixels below the healthbar, when their heights are 12
		Skinner:glazeStatusBar(PlayerFrameManaBar, 0)
		-- casting bar handled in CastingBar function (UIE1)
		-- move PvP timer, level & rest icon down, so they are more visible
		Skinner:moveObject{obj=PlayerPVPTimerText, y=lOfs}
		Skinner:moveObject{obj=PlayerLevelText, y=lOfs}
		Skinner:moveObject{obj=PlayerRestIcon, y=lOfs} -- covers level text when resting
		-- remove group indicator textures
		Skinner:keepFontStrings(PlayerFrameGroupIndicator)
		Skinner:moveObject{obj=PlayerFrameGroupIndicatorText, y=-1}
		Skinner:addSkinFrame{obj=PlayerFrame, ft=ftype, noBdr=true, aso=aso, x1=37, y1=-7, y2=Skinner.uCls == "PALADIN" and 3 or 6}

		--	if the player class is a DeathKnight then skin the RuneFrame
		if Skinner.uCls == "DEATHKNIGHT" then
			for i = 1, 6 do
				_G["RuneButtonIndividual"..i.."BorderTexture"]:SetTexture(nil)
			end
		end
		--	if the player class is a Shaman/DeathKnight then skin the TotemFrame
		if Skinner.uCls == "SHAMAN"
		or Skinner.uCls == "DEATHKNIGHT"
		then
			for i = 1, MAX_TOTEMS do
				_G["TotemFrameTotem"..i.."Background"]:SetAlpha(0)
				Skinner:getRegion(Skinner:getChild(_G["TotemFrameTotem"..i], 2), 1):SetAlpha(0) -- Totem Border texture
			end
		end
		--	if the player class is a Rogue/Druid then skin the ComboFrame
		if Skinner.uCls == "ROGUE"
		or Skinner.uCls == "DRUID"
		then
			for i = 1, MAX_COMBO_POINTS do
				Skinner:getRegion(_G["ComboPoint"..i], 1):SetTexture(nil)
			end
			Skinner:moveObject{obj=ComboFrame, x=3, y=3}
		end

		-- if the player class is a Druid then skin the AlternateManaBar
		if Skinner.uCls == "DRUID" then
			PlayerFrameAlternateManaBarBorder:SetTexture(nil)
			Skinner:glazeStatusBar(PlayerFrameAlternateManaBar, 0)
		end
		if Skinner.isBeta then
			-- if the player class is a Warlock then skin the ShardBar
			if Skinner.uCls == "WARLOCK" then
				for i = 1, SHARD_BAR_NUM_SHARDS do
					_G["ShardBarFrameShard"..i]:DisableDrawLayer("BORDER")
					_G["ShardBarFrameShard"..i]:DisableDrawLayer("OVERLAY") -- Glow texture
				end
			end
			-- if the player class is a Paladin then skin the PowerBar
			if Skinner.uCls == "PALADIN" then
				PaladinPowerBar:DisableDrawLayer("BACKGROUND")
				PaladinPowerBar.glow:DisableDrawLayer("BACKGROUND")
			end
			-- if the player class is a Druid then skin the EclipseBarFrame
			if Skinner.uCls == "DRUID" then
				EclipseBarFrameBar:Hide()
				EclipseBarFrame.sunBar:Hide()
				EclipseBarFrame.moonBar:Hide()
			end
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
		Skinner:glazeStatusBar(PetFrameHealthBar, 0)
		Skinner:adjHeight{obj=PetFrameHealthBar, adj=-1} -- handle bug in PetFrame XML & lua which places mana bar 7 pixels below the healthbar, when their heights are 8
		Skinner:glazeStatusBar(PetFrameManaBar, 0)
		-- casting bar handled in CastingBar function (UIE1)
		Skinner:moveObject{obj=PetFrame, x=20, y=1} -- align under Player Health/Mana bars (Hunter's only)
		Skinner:addSkinFrame{obj=PetFrame, ft=ftype, noBdr=true, aso=aso, x1=2, y1=-1, x2=1}
	end

	-- Add Pet's Level to frame if required (only for Hunter/Warlock pets)
	if db.petlevel
	and Skinner.uCls == "HUNTER"
	or Skinner.uCls == "WARLOCK"
	then
		if not plt then
			plt = Skinner.skinFrame[PetFrame]:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
			plt:SetPoint("BOTTOMLEFT", 4, 4)
			local lvlXP = 0
			local function checkLevel(event, ...)

				plt:SetText(UnitLevel(PetFrame.unit))

			end
			module:SecureHook("PetFrame_Update", function(this, ...)
				checkLevel("pfu")
			end)
			module:RegisterEvent("PET_BAR_UPDATE", checkLevel) -- for pet changes
			module:RegisterEvent("UNIT_PET", checkLevel) -- for pet changes
			module:RegisterEvent("UNIT_PET_EXPERIENCE", checkLevel) -- for levelling
			checkLevel("init")
			plt:Show()
		else
			plt:Show()
		end
	elseif plt then
		plt:Hide()
	end

end
local function skinToT(parent)

	_G[parent.."Background"]:SetTexture(nil)
	_G[parent.."TextureFrameTexture"]:SetTexture(nil)
	-- status bars
	Skinner:glazeStatusBar(_G[parent.."HealthBar"], 0)
	Skinner:glazeStatusBar(_G[parent.."ManaBar"], 0)
	Skinner:moveObject{obj=_G[parent.."ManaBar"], y=1} -- handle bug in <frame> XML & lua which places mana bar 8 pixels below the healthbar, when their heights are 7
	Skinner:moveObject{obj=_G[parent], y=totOfs}

end
local function skinUFrame(frame)

	Skinner:addSkinFrame{obj=_G[frame], ft=ftype, noBdr=true, aso=aso, y1=-7, x2=-37, y2=6}
	_G[frame.."Background"]:SetTexture(nil)
	_G[frame.."TextureFrameTexture"]:SetAlpha(0) -- texture file is changed dependant upon mob type
	-- status bars
	Skinner:glazeStatusBar(_G[frame.."HealthBar"], 0)
	Skinner:adjHeight{obj=_G[frame.."HealthBar"] , adj=-1} -- handle bug in <frame> XML & lua which places mana bar 11 pixels below the healthbar, when their heights are 12
	Skinner:glazeStatusBar(_G[frame.."ManaBar"], 0)
	Skinner:removeRegions(_G[frame.."NumericalThreat"], {3}) -- threat border
	-- move level & highlevel down, so they are more visible
	Skinner:moveObject{obj=_G[frame.."TextureFrameLevelText"], x=2, y=lOfs}
	-- casting bar
	local cBar = frame.."SpellBar"
	Skinner:adjHeight{obj=_G[cBar], adj=2}
	Skinner:moveObject{obj=_G[cBar.."Text"], y=-1}
	_G[cBar.."Flash"]:SetAllPoints()
	_G[cBar.."Border"]:SetAlpha(0) -- texture file is changed dependant upon spell type
	Skinner:changeShield(_G[cBar.."BorderShield"], _G[cBar.."Icon"])
	Skinner:glazeStatusBar(_G[cBar], 0, Skinner:getRegion(_G[cBar], 1), {_G[cBar.."Flash"]})

-->>-- TargetofTarget Frame
	skinToT(frame.."ToT")
	Skinner:addSkinFrame{obj=_G[frame.."ToT"], ft=ftype, noBdr=true, aso=aso, x2=6, y2=-1}

end
local function skinTargetF()

	if db.target
	and not isSkinned["Target"]
	then
		skinUFrame("TargetFrame")

		-- create a texture to show UnitClassification
		local ucTex = TargetFrame:CreateTexture(nil, "ARTWORK") -- make it appear above the portrait
		ucTex:SetWidth(80)
		ucTex:SetHeight(50)
		ucTex:SetPoint("CENTER", 86, -22 + lOfs)

		-- hook this to show/hide the elite texture
		module:SecureHook("TargetFrame_CheckClassification", function(this)
			local uCls = UnitClassification("target")
			if uCls == "worldboss"
			or uCls == "elite"
			then
				ucTex:SetTexture([[Interface\Tooltips\EliteNameplateIcon]])
			elseif uCls == "rareelite" then
				ucTex:SetTexture([[Interface\AddOns\Skinner\textures\RareEliteNameplateIcon]])
			elseif uCls == "rare" then
				ucTex:SetTexture([[Interface\AddOns\Skinner\textures\RareNameplateIcon]])
			else ucTex:SetTexture(nil)
			end
		end)

	-->>--Boss Target Frames
		for i = 1, MAX_BOSS_FRAMES do
			local frame = "Boss"..i.."TargetFrame"
			_G[frame.."Background"]:SetTexture(nil)
			_G[frame.."TextureFrameTexture"]:SetAlpha(0) -- texture file is changed dependant upon mob type
			Skinner:glazeStatusBar(_G[frame.."HealthBar"], 0)
			Skinner:glazeStatusBar(_G[frame.."ManaBar"], 0)
			Skinner:removeRegions(_G[frame.."NumericalThreat"], {3}) -- threat border
			Skinner:addSkinFrame{obj=_G[frame], ft=ftype, noBdr=true, aso=aso, x1=-1,  y1=-14, x2=-72, y2=5}
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
local function skinPartyF()

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
			local pF = "PartyMemberFrame"..i
			_G[pF.."Background"]:SetTexture(nil)
			_G[pF.."Texture"]:SetAlpha(0) -- texture file is changed dependant upon in vehicle or not
			_G[pF.."VehicleTexture"]:SetAlpha(0) -- texture file is changed dependant upon in vehicle or not
			_G[pF.."Status"]:SetTexture(nil)

			-- reset positions if required
			if _G[pF].state == "vehicle" then
				rpTmr[_G[pF]] = module:ScheduleRepeatingTimer(resetPosn, tDelay, pF)
			end

			-- status bars
			Skinner:glazeStatusBar(_G[pF.."HealthBar"], 0)
			Skinner:glazeStatusBar(_G[pF.."ManaBar"], 0)
			Skinner:addSkinFrame{obj=_G[pF], ft=ftype, noBdr=true, aso=aso, x1=2, y1=5, x2=-1}

			-- pet frame
			local pPF = pF.."PetFrame"
			_G[pPF.."Flash"]:SetTexture(nil)
			_G[pPF.."Texture"]:SetAlpha(0) -- texture file is changed dependant upon in vehicle or not
			-- status bar
			Skinner:glazeStatusBar(_G[pPF.."HealthBar"], 0)
			Skinner:addSkinFrame{obj=_G[pPF], ft=ftype, noBdr=true, aso=aso, x1=-2, y1=1, y2=1}
		end
		-- PartyMember Buff Tooltip
		Skinner:addSkinFrame{obj=PartyMemberBuffTooltip, ft=ftype, noBdr=true, aso=aso, x1=2, y1=-2, x2=-2, y2=2}
		-- PartyMemberBackground
		Skinner:addSkinFrame{obj=PartyMemberBackground, ft=ftype, x1=4, y1=2, x2=1, y2=2}
	end

end
local function skinArenaF()

	if db.arena
	and not isSkinned["Arena"]
	then
		Skinner:SecureHook("Arena_LoadUI", function()
			for i = 1, MAX_ARENA_ENEMIES do
				local aF = "ArenaEnemyFrame"..i
				_G[aF.."Background"]:SetTexture(nil)
				_G[aF.."Texture"]:SetTexture(nil)
				_G[aF.."Status"]:SetTexture(nil)

				-- status bars
				Skinner:glazeStatusBar(_G[aF.."HealthBar"], 0)
				Skinner:glazeStatusBar(_G[aF.."ManaBar"], 0)
				Skinner:addSkinFrame{obj=_G[aF], ft=ftype, noBdr=true, aso=aso, x1=-3, x2=3, y2=-6}

				-- pet frame
				local aPF = aF.."PetFrame"
				_G[aPF.."Flash"]:SetTexture(nil)
				_G[aPF.."Texture"]:SetTexture(nil)
				-- status bar
				Skinner:glazeStatusBar(_G[aPF.."HealthBar"], 0)
				Skinner:addSkinFrame{obj=_G[aPF], ft=ftype, noBdr=true, aso=aso, y1=1, x2=1, y2=2}
				-- move pet frame
				Skinner:moveObject{obj=_G[aPF], x=-17} -- align under ArenaEnemy Health/Mana bars

				-- casting bar
				local cBar = aF.."CastingBar"
				Skinner:adjHeight{obj=_G[cBar], adj=2}
				Skinner:moveObject{obj=_G[cBar.."Text"], y=-1}
				_G[cBar.."Flash"]:SetAllPoints()
				Skinner:glazeStatusBar(_G[cBar], 0, Skinner:getRegion(_G[cBar], 1), {_G[cBar.."Flash"]})
			end
			-- ArenaEnemyBackground
			Skinner:addSkinFrame{obj=ArenaEnemyBackground, ft=ftype}
			Skinner:Unhook("Arena_LoadUI")
		end)
	end

end
local skinCompactF
if Skinner.isBeta then
	Skinner:add2Table(unitFrames, "CompactPartyFrame")
	function skinCompactF()

		if db.compact
		and not isSkinned["Compact"]
		then
			-- skin Compact Party Frame
			CompactPartyFrame.borderFrame:DisableDrawLayer("ARTWORK")
			for i = 1, MEMBERS_PER_RAID_GROUP do
				_G["CompactPartyFrameMember"..i]:DisableDrawLayer("BACKGROUND")
				_G["CompactPartyFrameMember"..i]:DisableDrawLayer("BORDER")
			end
			Skinner:addSkinFrame{obj=CompactPartyFrame, ft=ftype, x1=3, y1=-11, x2=-3, y2=3}
			-- hook this to skin Compact Raid Unit Frame(s)
			Skinner:RawHook("CompactRaidFrameContainer_GetUnitFrame", function(...)
				local frame = Skinner.hooks[this].CompactRaidFrameContainer_GetUnitFrame(...)
				frame:DisableDrawLayer("BACKGROUND")
				frame:DisableDrawLayer("BORDER")
				return frame
			end, true)
			-- hook this to skin Compact Raid Group Frame(s)
			Skinner:RawHook("CompactRaidGroup_GenerateForGroup", function(...)
				local frame = Skinner.hooks[this].CompactRaidGroup_GenerateForGroup(...)
				frame.borderFrame:DisableDrawLayer("ARTWORK")
				Skinner:addSkinFrame{obj=frame, ft=ftype, x1=3, y1=-11, x2=-3, y2=3}
				return frame
			end, true)
		end

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
local function changeUFOpacity()

	local r, g, b = unpack(Skinner.bColour)

	for _, uFrame in pairs(unitFrames) do
		if Skinner.skinFrame[_G[uFrame]] then
			Skinner.skinFrame[_G[uFrame]]:SetBackdropColor(r, g, b, db.alpha)
		end
	end
	for i = 1, MAX_PARTY_MEMBERS do
		if Skinner.skinFrame[_G["PartyMemberFrame"..i]] then
			Skinner.skinFrame[_G["PartyMemberFrame"..i]]:SetBackdropColor(r, g, b, db.alpha)
			Skinner.skinFrame[_G["PartyMemberFrame"..i.."PetFrame"]]:SetBackdropColor(r, g, b, db.alpha)
		end
	end
	for i = 1, MAX_BOSS_FRAMES do
		if Skinner.skinFrame[_G["Boss"..i.."TargetFrame"]] then
			Skinner.skinFrame[_G["Boss"..i.."TargetFrame"]]:SetBackdropColor(r, g, b, db.alpha)
		end
	end
	for i = 1, MAX_ARENA_ENEMIES do
		if Skinner.skinFrame[_G["ArenaEnemyFrame"..i]] then
			Skinner.skinFrame[_G["ArenaEnemyFrame"..i]]:SetBackdropColor(r, g, b, db.alpha)
			Skinner.skinFrame[_G["ArenaEnemyFrame"..i.."PetFrame"]]:SetBackdropColor(r, g, b, db.alpha)
		end
	end

end

function module:OnInitialize()

	self.db = Skinner.db:RegisterNamespace("UnitFrames", defaults)
	db = self.db.profile

	-- convert any old settings
	if Skinner.db.profile.UnitFrames then
		for k, v in pairs(Skinner.db.profile.UnitFrames) do
			db[k] = v
		end
		Skinner.db.profile.UnitFrames = nil
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
		if Skinner.isBeta then skinCompactF() end
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
	elseif opt == "compact" and Skinner.isBeta then
		skinCompactF()
	end

end

function module:GetOptions()

	local options = {
		type = "group",
		name = Skinner.L["Unit Frames"],
		desc = Skinner.L["Change the Unit Frames settings"],
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
				name = Skinner.L["Player"],
				desc = Skinner.L["Toggle the skin of the Player UnitFrame"],
			},
			target = {
				type = "toggle",
				order = 4,
				name = Skinner.L["Target"],
				desc = Skinner.L["Toggle the skin of the Target UnitFrame"],
			},
			focus = {
				type = "toggle",
				order = 5,
				name = Skinner.L["Focus"],
				desc = Skinner.L["Toggle the skin of the Focus UnitFrame"],
			},
			party = {
				type = "toggle",
				order = 6,
				name = Skinner.L["Party"],
				desc = Skinner.L["Toggle the skin of the Party UnitFrames"],
			},
			arena = {
				type = "toggle",
				order = 7,
				name = Skinner.L["Arena"],
				desc = Skinner.L["Toggle the skin of the Arena UnitFrames"],
			},
			alpha = {
				type = "range",
				order = 10,
				width = "double",
				name = Skinner.L["UnitFrame Background Opacity"],
				desc = Skinner.L["Change Opacity value of the UnitFrames Background"],
				min = 0, max = 1, step = 0.05,
			},
			pet = {
				type = "toggle",
				order = 2,
				name = Skinner.L["Pet"],
				desc = Skinner.L["Toggle the skin of the Pet UnitFrame"],
				set = Skinner.uCls == "HUNTER" and function(info, value)
					module.db.profile[info[#info]] = value
					if not value then module.db.profile.petlevel = false end -- disable petlevel when disabled
					module:adjustUnitFrames(info[#info])
				end or nil,
			},
			petlevel = (Skinner.uCls == "HUNTER" or Skinner.uCls == "WARLOCK") and {
				type = "toggle",
				order = 3,
				name = Skinner.L["Pet Level"],
				desc = Skinner.L["Toggle the Pet Level on the Pet Frame"],
				set = function(info, value)
					module.db.profile[info[#info]] = value
					if value then module.db.profile.pet = true end -- enable pet frame when enabled
					module:adjustUnitFrames(info[#info])
				end,
			} or nil,
			compact = Skinner.isBeta and {
				type = "toggle",
				order = 8,
				name = Skinner.L["Compact"],
				desc = Skinner.L["Toggle the skin of the Compact UnitFrames"],
			} or nil,
		},
	}
	return options

end
