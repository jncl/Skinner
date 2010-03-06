local _G = _G
local ftype = "c"

local ba -- background alpha setting
local lOfs = -10 -- level text offset
local totOfs = -12 -- TargetofTarget frame offset

function Skinner:UnitFrames()

	local db = self.db.profile.UnitFrames

	ba = self.db.profile.UnitFrames.alpha

	if db.player then self:Player() end
	if db.pet then self:Pet() end
	if db.target then self:Target() end
	if db.focus then self:Focus() end
	if db.party then self:Party() end

end

function Skinner:Player()
	if self.initialized.Player then return end
	self.initialized.Player = true

	PlayerFrameFlash:SetTexture(nil) -- threat indicator texture
	PlayerFrameBackground:SetTexture(nil)
	PlayerFrameTexture:SetAlpha(0) -- texture file is changed dependant upon in vehicle or not
	PlayerFrameVehicleTexture:SetAlpha(0) -- texture file is changed dependant upon in vehicle or not
	PlayerStatusTexture:SetTexture(nil)
	PlayerAttackBackground:SetTexture(nil)
	PlayerRestGlow:SetTexture(nil)
	PlayerAttackGlow:SetTexture(nil)
	-- status bars
	self:glazeStatusBar(PlayerFrameHealthBar, 0)
	self:adjHeight{obj=PlayerFrameHealthBar , adj=-1} -- handle bug in PlayerFrame XML & lua which places mana bar 11 pixels below the healthbar, when their heights are 12
	self:glazeStatusBar(PlayerFrameManaBar, 0)
	-- casting bar handled in CastingBar function (UIE1)
	-- move PvP timer, level & rest icon down, so they are more visible
	self:moveObject{obj=PlayerPVPTimerText, y=lOfs}
	self:moveObject{obj=PlayerLevelText, y=lOfs}
	self:moveObject{obj=PlayerRestIcon, y=lOfs} -- covers level text when resting
	-- remove group indicator textures
	self:keepFontStrings(PlayerFrameGroupIndicator)
	self:moveObject{obj=PlayerFrameGroupIndicatorText, y=-1}
	self:addSkinFrame{obj=PlayerFrame, ft=ftype, noBdr=true, aso={ba=ba, ng=true}, x1=37, y1=-7, y2=6}

--	if the player class is a DeathKnight then skin the RuneFrame
	if self.uCls == "DEATHKNIGHT" then
		for i = 1, 6 do
			local rBdrTex = _G["RuneButtonIndividual"..i.."BorderTexture"]
			rBdrTex:SetTexture(nil)
		end
	end
--	if the player class is a Shaman/DeathKnight then skin the TotemFrame
	if self.uCls == "SHAMAN" or self.uCls == "DEATHKNIGHT" then
		for i = 1, 4 do
			_G["TotemFrameTotem"..i.."Background"]:SetAlpha(0)
			local tfTBdrTex = self:getRegion(self:getChild(_G["TotemFrameTotem"..i], 2), 1) -- Totem Border texture
			tfTBdrTex:SetAlpha(0)
		end
	end
--	if the player class is a Rogue/Druid then skin the ComboFrame
	if self.uCls == "ROGUE" or self.uCls == "DRUID" then
		for i = 1, 5 do
			local cPtTex = select(1, _G["ComboPoint"..i]:GetRegions())
			cPtTex:SetTexture(nil)
		end
	end
-- if the player class is a Druid then skin the AlternateManaBar
	if self.uCls == "DRUID" then
		PlayerFrameAlternateManaBarBorder:SetTexture(nil)
		self:glazeStatusBar(PlayerFrameAlternateManaBar, 0)
	end

end

function Skinner:Pet()
	if self.initialized.Pet then return end
	self.initialized.Pet = true

-->>-- Pet frame
	PetFrameFlash:SetTexture(nil)
	PetFrameTexture:SetAlpha(0) -- texture file is changed dependant upon in vehicle or not
	PetAttackModeTexture:SetTexture(nil)
	-- status bars
	self:glazeStatusBar(PetFrameHealthBar, 0)
	self:adjHeight{obj=PetFrameHealthBar, adj=-1} -- handle bug in PetFrame XML & lua which places mana bar 7 pixels below the healthbar, when their heights are 8
	self:adjWidth{obj=PetFrameHealthBar, adj=6}
	self:glazeStatusBar(PetFrameManaBar, 0)
	self:adjWidth{obj=PetFrameManaBar, adj=6}
	-- casting bar handled in CastingBar function (UIE1)
	self:moveObject{obj=PetFrame, x=20, y=1} -- align under Player Health/Mana bars
	self:addSkinFrame{obj=PetFrame, ft=ftype, noBdr=true, aso={ba=ba, ng=true}, x1=2, y1=-1, x2=1}
	-- Add Pet's Level to frame if a Hunter and required
	if self.uCls == "HUNTER" and self.db.profile.UnitFrames.petlevel then
		local plt = self.skinFrame[PetFrame]:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
		plt:SetPoint("BOTTOMLEFT", 4, 4)
		local lvlXP = 0
		local function checkLevel(event, ...)
--			Skinner:Debug("checkLevel: [%s]", event)
			if event == "UNIT_PET" then lvlXP = 0 end -- pet changed
			local currXP, nextXP = GetPetExperience()
			if nextXP > lvlXP then
				plt:SetText(UnitLevel(PetFrame.unit))
				lvlXP = nextXP
			end
		end
		self:SecureHook("PetFrame_Update", function(this, ...)
			checkLevel("pfu")
		end)
		self:RegisterEvent("UNIT_PET", checkLevel) -- for pet changes
		self:RegisterEvent("UNIT_PET_EXPERIENCE", checkLevel) -- for levelling
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

	Skinner:addSkinFrame{obj=_G[frame], ft=ftype, noBdr=true, aso={ba=ba, ng=true}, y1=-7, x2=-37, y2=6}
	_G[frame.."Flash"]:SetAlpha(0) -- texture file is changed dependant upon size
	_G[frame.."Background"]:SetTexture(nil)
--	<frame>NameBackground:SetTexture(nil) -- used for faction colouring
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
	Skinner:adjHeight{obj=_G[cBar], adj=4}
	_G[cBar.."Border"]:SetAlpha(0) -- texture file is changed dependant upon spell type
	Skinner:changeShield(_G[cBar.."BorderShield"], _G[cBar.."Icon"])
	_G[cBar.."Flash"]:SetAllPoints()
	Skinner:moveObject{obj=_G[cBar.."Text"], y=-2}
	Skinner:glazeStatusBar(_G[cBar], 0, Skinner:getRegion(_G[cBar], 1), {_G[cBar.."Flash"]})

-->>-- TargetofTarget Frame
	skinToT(frame.."ToT")
	Skinner:addSkinFrame{obj=_G[frame.."ToT"], ft=ftype, noBdr=true, aso={ba=ba, ng=true}, x2=6, y2=-1}

end

function Skinner:Target()
	if self.initialized.Target then return end
	self.initialized.Target = true

	skinUFrame("TargetFrame")

	-- create a texture to show UnitClassification
	local uCat = TargetFrame:CreateTexture(nil, "ARTWORK") -- make it appear above the portrait
	uCat:SetWidth(80)
	uCat:SetHeight(50)
	uCat:SetPoint("CENTER", 86, -22 + lOfs)

	-- hook this to show/hide the elite texture
	self:SecureHook("TargetFrame_CheckClassification", function(this)
		local classification = UnitClassification("target")
--		self:Debug("TF_CC: [%s]", classification)
		if classification == "worldboss" then
			uCat:SetTexture([[Interface\Tooltips\EliteNameplateIcon]])
		elseif classification == "rareelite" then
			uCat:SetTexture([[Interface\AddOns\Skinner\textures\RareEliteNameplateIcon]])
		elseif classification == "elite" then
			uCat:SetTexture([[Interface\Tooltips\EliteNameplateIcon]])
		elseif classification == "rare" then
			uCat:SetTexture([[Interface\AddOns\Skinner\textures\RareNameplateIcon]])
		else uCat:SetTexture(nil)
		end
	end)

-->>--Boss Target Frames
	for i = 1, 4 do
		local frame = "Boss"..i.."TargetFrame"
		_G[frame.."Flash"]:SetTexture(nil)
		_G[frame.."Background"]:SetTexture(nil)
		_G[frame.."TextureFrameTexture"]:SetAlpha(0) -- texture file is changed dependant upon mob type
		self:glazeStatusBar(_G[frame.."HealthBar"], 0)
		self:glazeStatusBar(_G[frame.."ManaBar"], 0)
		self:removeRegions(_G[frame.."NumericalThreat"], {3}) -- threat border
		self:addSkinFrame{obj=_G[frame], ft=ftype, noBdr=true, aso={ba=ba, ng=true}, x1=-1,  y1=-14, x2=-72, y2=5}
		-- create a texture to show Elite dragon
		local bCat = _G[frame.."TextureFrame"]:CreateTexture(nil, "BACKGROUND")
		bCat:SetWidth(80)
		bCat:SetHeight(50)
		bCat:SetPoint("CENTER", 30, -21)
		bCat:SetTexture([[Interface\Tooltips\EliteNameplateIcon]])
	end

end

function Skinner:Focus()
	if self.initialized.Focus then return end
	self.initialized.Focus = true

	skinUFrame("FocusFrame")

end

function Skinner:Party()
	if self.initialized.Party then return end
	self.initialized.Party = true

	local rpTmr
	local function resetPosn(pF)

		-- handle in combat
		if InCombatLockdown() then return end

		_G[pF.."Portrait"]:SetPoint("TOPLEFT", 7, -6)
		_G[pF.."LeaderIcon"]:SetPoint("TOPLEFT", 0, 0)
		_G[pF.."MasterIcon"]:SetPoint("TOPLEFT", 32, 0)
		_G[pF.."PVPIcon"]:SetPoint("TOPLEFT", -9, -15)
		_G[pF.."Disconnect"]:SetPoint("LEFT", -7, -1)

		-- cancel repeating timer
		Skinner:CancelTimer(rpTmr, true)
		rpTmr = nil

	end

	-- hook this to change positions
	self:SecureHook("PartyMemberFrame_ToVehicleArt", function(this, ...)
		if not rpTmr then
			rpTmr = self:ScheduleRepeatingTimer(resetPosn, 0.1, this:GetName())
		end
	end)

	for i = 1, MAX_PARTY_MEMBERS do
		local pF = "PartyMemberFrame"..i
		_G[pF.."Flash"]:SetTexture(nil)
		_G[pF.."Background"]:SetTexture(nil)
		_G[pF.."Texture"]:SetAlpha(0) -- texture file is changed dependant upon in vehicle or not
		_G[pF.."VehicleTexture"]:SetAlpha(0) -- texture file is changed dependant upon in vehicle or not
		_G[pF.."Status"]:SetTexture(nil)

		-- reset positions if required
		if _G[pF].state == "vehicle" then
			rpTmr = self:ScheduleRepeatingTimer(resetPosn, 0.1, pF)
		end

		-- status bars
		self:glazeStatusBar(_G[pF.."HealthBar"], 0)
		self:glazeStatusBar(_G[pF.."ManaBar"], 0)
		self:addSkinFrame{obj=_G[pF], ft=ftype, noBdr=true, aso={ba=ba, ng=true}, x1=2, y1=5, x2=-1}

		-- pet frame
		local pPF = pF.."PetFrame"
		_G[pPF.."Flash"]:SetTexture(nil)
		_G[pPF.."Texture"]:SetAlpha(0) -- texture file is changed dependant upon in vehicle or not
		-- status bar
		self:glazeStatusBar(_G[pPF.."HealthBar"], 0)
		self:addSkinFrame{obj=_G[pPF], ft=ftype, noBdr=true, aso={ba=ba, ng=true}, x1=-2, y1=1, y2=1}
	end
	-- PartyMember Buff Tooltip
	self:addSkinFrame{obj=PartyMemberBuffTooltip, ft=ftype, noBdr=true, aso={ba=ba, ng=true}, x1=2, y1=-2, x2=-2, y2=2}
	-- PartyMemberBackground
	self:addSkinFrame{obj=PartyMemberBackground, ft=ftype, x1=4, y1=2, x2=1, y2=2}

end

function Skinner:changeUFOpacity()

	local r, g, b, _ = unpack(self.bColour)
	local a = self.db.profile.UnitFrames.alpha

	for _, uFrame in pairs{"PlayerFrame", "PetFrame", "TargetFrame", "TargetFrameToT", "FocusFrame", "FocusFrameToT", "PartyMemberBuffTooltip"} do
		if self.skinFrame[_G[uFrame]] then
			self.skinFrame[_G[uFrame]]:SetBackdropColor(r, g, b, a)
		end
	end
	for i = 1, MAX_PARTY_MEMBERS do
		if self.skinFrame[_G["PartyMemberFrame"..i]] then
			self.skinFrame[_G["PartyMemberFrame"..i]]:SetBackdropColor(r, g, b, a)
			self.skinFrame[_G["PartyMemberFrame"..i.."PetFrame"]]:SetBackdropColor(r, g, b, a)
		end
	end
	for i = 1, 4 do
		if self.skinFrame[_G["Boss"..i.."TargetFrame"]] then
			self.skinFrame[_G["Boss"..i.."TargetFrame"]]:SetBackdropColor(r, g, b, a)
		end
	end

end
