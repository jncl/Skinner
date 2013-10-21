local aName, aObj = ...
local _G = _G
local ftype = "p"
local module = aObj:NewModule("UnitFrames", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")

local db, aso
local defaults = {
	profile = {
		alpha = 0.25,
		arena = false,
		focus = false,
		party = false,
		pet = false,
		petlevel = (aObj.uCls == "HUNTER" or aObj.uCls == "WARLOCK") and false or nil,
		player = false,
		target = false,
	}
}
local lOfs = -9 -- level text offset
local tDelay = 0.2 -- repeating timer delay
local isSkinned = _G.setmetatable({}, {__index = function(t, k) t[k] = true end})
local rpTmr = {}
local unitFrames = {
	"ArenaEnemyBackground", "FocusFrame", "FocusFrameToT", "PartyMemberBackground", "PartyMemberBuffTooltip",  "PlayerFrame", "PetFrame", "TargetFrame", "TargetFrameToT"
}

-- N.B. handle bug in XML & lua which places mana bar 1 pixel too high
local function adjustStatusBarPosn(sBar, yAdj)

	yAdj = yAdj or 1
	if sBar.TextString then
		local oPnt = {sBar.TextString:GetPoint()}
		sBar.TextString:SetPoint(oPnt[1], oPnt[2], oPnt[3], oPnt[4], oPnt[5] + yAdj + 1)
	end
	if sBar == _G.PlayerFrameHealthBar then
		aObj:RawHook(sBar, "SetPoint", function(this, posn, xOfs, yOfs)
			aObj.hooks[this].SetPoint(this, posn, xOfs, yOfs + yAdj)
		end, true)
	else
		local oPnt = {sBar:GetPoint()}
		sBar:SetPoint(oPnt[1], oPnt[2], oPnt[3], oPnt[4], oPnt[5] + yAdj)
	end

end
local function addBackground(opts)

	opts.obj.sb = _G.CreateFrame("Button", nil, opts.obj, "SecureFrameTemplate")
	opts.obj.sb:SetAllPoints(opts.obj)
	-- adjust frame levels so skin button is behind
	_G.RaiseFrameLevelByTwo(opts.obj)
	opts.obj.sb:SetFrameLevel(opts.obj:GetFrameLevel() - 1)
	-- create background texture
	opts.obj.sbg = opts.obj.sb:CreateTexture(nil, "BACKGROUND")
	local r, g, b = _G.unpack(aObj.bColour)
	opts.obj.sbg:SetTexture(r, g, b, db.alpha)

	-- setup offset values
	opts.ofs = opts.ofs or 0
	local xOfs1 = opts.x1 or opts.ofs * -1
	local yOfs1 = opts.y1 or opts.ofs
	local xOfs2 = opts.x2 or opts.ofs
	local yOfs2 = opts.y2 or opts.ofs * -1

	-- position texture
	opts.obj.sbg:ClearAllPoints()
	opts.obj.sbg:SetPoint("TOPLEFT", opts.obj.sb, "TOPLEFT", xOfs1, yOfs1)
	opts.obj.sbg:SetPoint("BOTTOMRIGHT", opts.obj.sb, "BOTTOMRIGHT", xOfs2, yOfs2)

end
local function fixThreat(tex, xOfs, yOfs)

	tex:ClearAllPoints()
	tex:SetAllPoints(tex:GetParent().sbg)
	tex:SetSize(xOfs, yOfs)
	aObj:changeRecTex(tex, true, true)
	-- stop changes to texture
	tex.SetTexture = function() end
	tex.SetTexCoord = function() end
	tex.SetWidth = function() end
	tex.SetHeight = function() end
	tex.SetPoint = function() end

end
local function skinPlayerF()

	if db.player
	and not isSkinned["Player"]
	then
		_G.PlayerFrameBackground:SetTexture(nil)
		_G.PlayerFrameTexture:SetAlpha(0) -- texture file is changed dependant upon in vehicle or not
		_G.PlayerFrameVehicleTexture:SetAlpha(0) -- texture file is changed dependant upon in vehicle or not
		_G.PlayerStatusTexture:SetTexture(nil)
		_G.PlayerAttackBackground:SetTexture(nil)
		_G.PlayerRestGlow:SetTexture(nil)
		_G.PlayerAttackGlow:SetTexture(nil)
		-- status bars
		adjustStatusBarPosn(_G.PlayerFrameHealthBar)
		aObj:glazeStatusBar(_G.PlayerFrameHealthBar, 0)
		aObj:glazeStatusBar(_G.PlayerFrameManaBar, 0)
		-- casting bar handled in CastingBar function (PF)
		-- move PvP Timer text down
		aObj:moveObject{obj=_G.PlayerPVPTimerText, y=-10}
		-- move level & rest icon down, so they are more visible
		aObj:moveObject{obj=_G.PlayerLevelText, y=lOfs - 1}
		aObj:moveObject{obj=_G.PlayerRestIcon, y=lOfs} -- covers level text when resting
		-- remove group indicator textures
		aObj:keepFontStrings(_G.PlayerFrameGroupIndicator)
		aObj:moveObject{obj=_G.PlayerFrameGroupIndicatorText, y=-1}
		--	skin the TotemFrame
		for i = 1, _G.MAX_TOTEMS do
			_G["TotemFrameTotem" .. i .. "Background"]:SetAlpha(0)
			aObj:getRegion(aObj:getChild(_G["TotemFrameTotem" .. i], 2), 1):SetAlpha(0) -- Totem Border texture
		end
		aObj:moveObject{obj=_G.TotemFrameTotem1, y=lOfs} -- covers level text when active
		local y2Ofs = 9
		--	skin the RuneFrame, if required
		if aObj.uCls == "DEATHKNIGHT" then
			for i = 1, 6 do
				_G["RuneButtonIndividual" .. i .. "BorderTexture"]:SetTexture(nil)
			end
		end
		-- skin the AlternateManaBar & EclipseBarFrame, if required
		if aObj.uCls == "DRUID" then
			_G.PlayerFrameAlternateManaBar.DefaultBorder:SetTexture(nil)
			_G.PlayerFrameAlternateManaBar.DefaultBorderLeft:SetTexture(nil)
			_G.PlayerFrameAlternateManaBar.DefaultBorderRight:SetTexture(nil)
			aObj:glazeStatusBar(_G.PlayerFrameAlternateManaBar, 0)
			_G.EclipseBarFrameBar:Hide()
			_G.EclipseBarFrame.sunBar:Hide()
			_G.EclipseBarFrame.moonBar:Hide()
		end
		-- skin the ShardBarFrame/DemonicFuryBarFrame/BurningEmbersBarFrame, if required
		if aObj.uCls == "WARLOCK" then
			-- ShardBarFrame (Affliction)
			_G.ShardBarFrame:DisableDrawLayer("BACKGROUND")
			for i = 1, _G.UnitPowerMax(_G.WarlockPowerFrame:GetParent().unit, _G.SPELL_POWER_SOUL_SHARDS) do
				_G.ShardBarFrame["shard" .. i]:DisableDrawLayer("BORDER")
				_G.ShardBarFrame["shard" .. i]:DisableDrawLayer("OVERLAY") -- Glow textures
			end
			-- DemonicFuryBarFrame (Demonology)
			aObj:moveObject{obj=_G.DemonicFuryBarFrame, x=-4, y=1}
			_G.DemonicFuryBarFrame.bar:SetTexture(nil) -- frame border texture
			-- BurningEmbersBarFrame (Destruction)
			_G.BurningEmbersBarFrame:DisableDrawLayer("BACKGROUND")
			for i = 1, _G.math.floor(_G.UnitPowerMax("player", _G.SPELL_POWER_BURNING_EMBERS, true) / _G.MAX_POWER_PER_EMBER) do
				_G.BurningEmbersBarFrame["ember" .. i]:DisableDrawLayer("BORDER")
				_G.BurningEmbersBarFrame["ember" .. i]:DisableDrawLayer("OVERLAY") -- Glow textures
			end
		end
		-- skin the PowerBar, if required
		if aObj.uCls == "PALADIN" then
			y2Ofs = 6
			_G.PaladinPowerBar:DisableDrawLayer("BACKGROUND")
			_G.PaladinPowerBar.glow:DisableDrawLayer("BACKGROUND")
		end
		-- skin the AlternateManaBar, MonkHarmonyBar & MonkStaggerBar, if required
		if aObj.uCls == "MONK" then
			_G.PlayerFrameAlternateManaBar.MonkBorder:SetTexture(nil)
			aObj:glazeStatusBar(_G.PlayerFrameAlternateManaBar, 0)
			aObj:removeRegions(_G.MonkHarmonyBar, {1, 2})
			aObj:removeRegions(_G.MonkStaggerBar, {2, 3, 4, 5, 6})
			aObj:glazeStatusBar(_G.MonkStaggerBar, 0)
			-- extend frame if Brewmaster specialization
			if _G.MonkStaggerBar.class == aObj.uCls and _G.MonkStaggerBar.specRestriction == _G.GetSpecialization() then
				y2Ofs = 3
			end
		end
		-- skin the BarFrame, if required
		if aObj.uCls == "PRIEST" then
			_G.PriestBarFrame:DisableDrawLayer("BACKGROUND")
			aObj:moveObject{obj=_G.PriestBarFrame.orb1, y=6}
			for i = 1, 3 do
				_G.PriestBarFrame["orb" .. i].highlight:SetTexture(nil) -- remove capping texture
			end
		end

		-- skin the PlayerFrame
		addBackground{obj=_G.PlayerFrame, x1=40, y1=-10, y2=y2Ofs}
		fixThreat(_G.PlayerFrameFlash, 232, 100)

	end

end
local function skinPetF()

	if db.pet
	and not isSkinned["Pet"]
	then
		_G.PetFrameTexture:SetAlpha(0) -- texture file is changed dependant upon in vehicle or not
		_G.PetAttackModeTexture:SetTexture(nil)
		-- status bars
		adjustStatusBarPosn(_G.PetFrameHealthBar, 0)
		aObj:glazeStatusBar(_G.PetFrameHealthBar, 0)
		adjustStatusBarPosn(_G.PetFrameManaBar, -1)
		aObj:glazeStatusBar(_G.PetFrameManaBar, 0)
		-- casting bar handled in CastingBar function (UIE1)
		aObj:moveObject{obj=_G.PetFrame, x=28, y=-3} -- align under Player Health/Mana bars

		-- skin the PetFrame
		addBackground{obj=_G.PetFrame, y1=-1, x2=-4}
		fixThreat(_G.PetFrameFlash, 128, 53)
		-- remove debuff border
		for i = 1, 4 do
			_G["PetFrameDebuff" .. i .. "Border"]:SetTexture(nil)
		end
	end
	-- Add Pet's Level to frame if required (only for Hunter/Warlock pets)
	if db.petlevel
	and aObj.uCls == "HUNTER"
	or aObj.uCls == "WARLOCK"
	then
		if not _G.PetFrame.lvl then
			_G.PetFrame.lvl = _G.PetFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
			_G.PetFrame.lvl:SetPoint("BOTTOMLEFT", 4, 4)
			local function checkLevel(event, ...) _G.PetFrame.lvl:SetText(_G.UnitLevel(_G.PetFrame.unit)) end
			module:SecureHook("PetFrame_Update", function(this, ...) checkLevel("pfu") end)
			module:RegisterEvent("PET_BAR_UPDATE", checkLevel) -- for pet changes
			module:RegisterEvent("UNIT_PET", checkLevel) -- for pet changes
			module:RegisterEvent("UNIT_PET_EXPERIENCE", checkLevel) -- for levelling
			checkLevel("init")
			_G.PetFrame.lvl:Show()
		else
			_G.PetFrame.lvl:Show()
		end
	elseif _G.PetFrame.lvl then
		_G.PetFrame.lvl:Hide()
	end

end
local function skinCommon(frame, adjSB)

	_G[frame .. "Background"]:SetTexture(nil)
	_G[frame .. "TextureFrameTexture"]:SetAlpha(0) -- texture file is changed dependant upon mob type
	-- status bars
	aObj:glazeStatusBar(_G[frame .. "HealthBar"], 0)
	aObj:glazeStatusBar(_G[frame .. "ManaBar"], 0)
	if adjSB then
		adjustStatusBarPosn(_G[frame .. "HealthBar"])
	end

end
local function skinUFrame(frame)

	addBackground{obj=_G[frame], y1=-10, x2=-41, y2=9}
	skinCommon(frame, true)
	aObj:removeRegions(_G[frame .. "NumericalThreat"], {3}) -- threat border
	-- move level & highlevel down, so they are more visible
	aObj:moveObject{obj=_G[frame .. "TextureFrameLevelText"], x=2, y=lOfs}
	-- casting bar
	local cBar = frame .. "SpellBar"
	aObj:adjHeight{obj=_G[cBar], adj=2}
	_G[cBar .. "Text"]:ClearAllPoints()
	_G[cBar .. "Text"]:SetPoint("TOP", 0, 3)
	_G[cBar .. "Flash"]:SetAllPoints()
	_G[cBar .. "Border"]:SetAlpha(0) -- texture file is changed dependant upon spell type
	aObj:changeShield(_G[cBar .. "BorderShield"], _G[cBar .. "Icon"])
	aObj:glazeStatusBar(_G[cBar], 0, aObj:getRegion(_G[cBar], 1), {_G[cBar .. "Flash"]})
-->>-- TargetofTarget Frame
	addBackground{obj=_G[frame].totFrame}
	skinCommon(frame .. "ToT", true)
	aObj:moveObject{obj=_G[frame .. "ToTHealthBar"], y=-2} -- move HealthBar down to match other frames

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
		fixThreat(_G.TargetFrameFlash, 232, 100)

		--	skin the ComboFrame, if required
		if aObj.uCls == "ROGUE"
		or aObj.uCls == "DRUID"
		then
			for i = 1, _G.MAX_COMBO_POINTS do
				aObj:getRegion(_G["ComboPoint" .. i], 1):SetTexture(nil)
			end
		end

		-- create a texture to show UnitClassification
		local ucTTex = _G.TargetFrame:CreateTexture(nil, "ARTWORK") -- make it appear above the portrait
		ucTTex:SetWidth(80)
		ucTTex:SetHeight(50)
		ucTTex:SetPoint("CENTER", 86, -22 + lOfs)
		local ucFTex = _G.FocusFrame:CreateTexture(nil, "ARTWORK") -- make it appear above the portrait
		ucFTex:SetWidth(80)
		ucFTex:SetHeight(50)
		ucFTex:SetPoint("CENTER", 86, -22 + lOfs)

		-- hook this to show/hide the elite texture
		module:SecureHook("TargetFrame_CheckClassification", function(frame, ...)
			if frame == _G.TargetFrame then
				showEliteTex(_G.UnitClassification("target"), ucTTex)
			elseif frame == _G.FocusFrame then
				showEliteTex(_G.UnitClassification("focus"), ucFTex)
			end
		end)

		--Boss Target Frames
		for i = 1, _G.MAX_BOSS_FRAMES do
			local frame = "Boss" .. i .. "TargetFrame"
			addBackground{obj=_G[frame], x1=-1, y1=-14, x2=-72, y2=5}
			skinCommon(frame)
			aObj:removeRegions(_G[frame .. "NumericalThreat"], {3}) -- threat border
			-- create a texture to show Elite dragon
			local bcTex = _G[frame .. "TextureFrame"]:CreateTexture(nil, "BACKGROUND")
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

		for i = 1, _G.MAX_PARTY_MEMBERS do
			local pF = "PartyMemberFrame" .. i
			addBackground{obj=_G[pF], x1=2, y1=5, x2=-1}
			fixThreat(_G[pF .. "Flash"], 128, 53)

			aObj:moveObject{obj=_G[pF .. "Portrait"], y=6}
			-- TODO stop portrait being moved
			_G[pF .. "Background"]:SetTexture(nil)
			_G[pF .. "Texture"]:SetAlpha(0) -- texture file is changed dependant upon in vehicle or not
			_G[pF .. "VehicleTexture"]:SetAlpha(0) -- texture file is changed dependant upon in vehicle or not
			_G[pF .. "Status"]:SetTexture(nil)

			-- status bars
			aObj:glazeStatusBar(_G[pF .. "HealthBar"], 0)
			aObj:glazeStatusBar(_G[pF .. "ManaBar"], 0)

			-- pet frame
			local pPF = pF .. "PetFrame"
			addBackground{obj=_G[pPF], x1=-2, y1=1, y2=1}
			fixThreat(_G[pPF .. "Flash"], 64, 26)
			_G[pPF .. "Texture"]:SetAlpha(0) -- texture file is changed dependant upon in vehicle or not
			-- status bar
			aObj:glazeStatusBar(_G[pPF .. "HealthBar"], 0)

		end

		-- PartyMember Buff Tooltip
		_G.PartyMemberBuffTooltip:SetBackdrop(nil)
		addBackground{obj=_G.PartyMemberBuffTooltip, ofs=-4}

		-- PartyMemberBackground
		aObj:addSkinFrame{obj=_G.PartyMemberBackground, ft=ftype, nb=true, x1=4, y1=2, x2=1, y2=2}
	end

end
local function skinArenaF()

	if db.arena
	and not isSkinned["Arena"]
	then
		aObj:SecureHook("Arena_LoadUI", function()
			local function skinFrame(fName)
				addBackground{obj=_G[fName], x1=-3, x2=3, y2=-6}
				_G[fName .. "Background"]:SetTexture(nil)
				_G[fName .. "Texture"]:SetTexture(nil)
				_G[fName .. "Status"]:SetTexture(nil)
				_G[fName .. "SpecBorder"]:SetTexture(nil)
				-- status bars
				aObj:glazeStatusBar(_G[fName .. "HealthBar"], 0)
				aObj:glazeStatusBar(_G[fName .. "ManaBar"], 0)
				-- casting bar
				local cBar = fName .. "CastingBar"
				aObj:adjHeight{obj=_G[cBar], adj=2}
				aObj:moveObject{obj=_G[cBar .. "Text"], y=-1}
				_G[cBar .. "Flash"]:SetAllPoints()
				aObj:glazeStatusBar(_G[cBar], 0, aObj:getRegion(_G[cBar], 1), {_G[cBar .. "Flash"]})
			end
			for i = 1, _G.MAX_ARENA_ENEMIES do
				skinFrame("ArenaPrepFrame" .. i)
				skinFrame("ArenaEnemyFrame" .. i)
				-- pet frame
				local aPF = "ArenaEnemyFrame" .. i .. "PetFrame"
				addBackground{obj=_G[aPF], y1=1, x2=1, y2=2}
				_G[aPF .. "Flash"]:SetTexture(nil)
				_G[aPF .. "Texture"]:SetTexture(nil)
				-- status bar
				aObj:glazeStatusBar(_G[aPF .. "HealthBar"], 0)
				aObj:glazeStatusBar(_G[aPF .. "ManaBar"], 0)
				-- move pet frame
				aObj:moveObject{obj=_G[aPF], x=-17} -- align under ArenaEnemy Health/Mana bars
			end
			-- ArenaPrepBackground
			aObj:addSkinFrame{obj=_G.ArenaPrepBackground, ft=ftype, nb=true}
			-- ArenaEnemyBackground
			aObj:addSkinFrame{obj=_G.ArenaEnemyBackground, ft=ftype, nb=true}
			aObj:Unhook("Arena_LoadUI")
		end)
	end

end
local function changeUFOpacity()

	local r, g, b = _G.unpack(aObj.bColour)

	for _, uFrame in _G.pairs(unitFrames) do
		if _G[uFrame].sbg then
			_G[uFrame].sbg:SetTexture(r, g, b, db.alpha)
		end
	end
	for i = 1, _G.MAX_PARTY_MEMBERS do
		if _G["PartyMemberFrame" .. i].sbg then
			_G["PartyMemberFrame" .. i].sbg:SetTexture(r, g, b, db.alpha)
			_G["PartyMemberFrame" .. i .. "PetFrame"].sbg:SetTexture(r, g, b, db.alpha)
		end
	end
	for i = 1, _G.MAX_BOSS_FRAMES do
		if _G["Boss" .. i .. "TargetFrame"].sbg then
			_G["Boss" .. i .. "TargetFrame"].sbg:SetTexture(r, g, b, db.alpha)
		end
	end
	for i = 1, _G.MAX_ARENA_ENEMIES do
		if _G["ArenaEnemyFrame" .. i].sbg then
			_G["ArenaEnemyFrame" .. i].sbg:SetTexture(r, g, b, db.alpha)
			_G["ArenaEnemyFrame" .. i .. "PetFrame"].sbg:SetTexture(r, g, b, db.alpha)
		end
	end

end

function module:OnInitialize()

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
		self:Disable()
	end

	-- disable ourself if another unitframe addon is loaded
	if _G.IsAddOnLoaded("Perl_Config")
	or _G.IsAddOnLoaded("XPerl")
	then
		self:Disable()
	end

	-- setup default applySkin options
	aso = {ba=db.alpha, bba=0, ng=true}

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
