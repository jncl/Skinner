local _G = _G
local ftype = "c"
local select = select

local ba -- background alpha setting
local lOfs = -10 -- level text offset

local shldTex = [[Interface\AchievementFrame\UI-Achievement-Progressive-Shield]]
local function changeShield(parent)

	local shldReg = _G[parent:GetName().."BorderShield"]
	shldReg:SetWidth(55)
	shldReg:SetHeight(55)
	shldReg:SetTexture(shldTex)
	shldReg:SetDrawLayer("BORDER") -- make it display behind the spell icon
	shldReg:SetTexCoord(0, 0.75, 0, 0.75)
	-- move so it is behind the icon
	shldReg:ClearAllPoints()
	shldReg:SetPoint("RIGHT", parent, "LEFT", 18, 0)

end

local function changeFlash(parent)

	local flshReg = _G[parent:GetName().."Flash"]
	flshReg:SetWidth(parent:GetWidth())
	flshReg:SetHeight(parent:GetHeight())
	flshReg:SetTexture(Skinner.sbTexture)
	Skinner:moveObject{obj=flshReg, x=(parent==FocusFrameSpellBar and 2 or 0), y=-20} -- otherwise it's above the casting bar

end

function Skinner:UnitFrames()

	local db = self.db.profile.UnitFrames

	ba = self.db.profile.UnitFrames.alpha

	if db.player then self:Player() end
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
	-- move level & rest icon down, so they are more visible
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

-->>-- Pet frame
	PetFrameFlash:SetTexture(nil)
	PetFrameTexture:SetAlpha(0) -- texture file is changed dependant upon in vehicle or not
	PetAttackModeTexture:SetTexture(nil)
	-- status bars
	self:glazeStatusBar(PetFrameHealthBar, 0)
	self:glazeStatusBar(PetFrameManaBar, 0)
	-- casting bar
	self:keepFontStrings(PetCastingBarFrame)
	self:glazeStatusBar(PetCastingBarFrame, 0)

	self:addSkinFrame{obj=PetFrame, ft=ftype, noBdr=true, aso={ba=ba, ng=true}, x1=2, y1=-1, x2=-6, y2=5}

end

local function skinToT(parent)

	_G[parent.."Background"]:SetTexture(nil)
	_G[parent.."TextureFrameTexture"]:SetTexture(nil)
	-- status bars
	Skinner:glazeStatusBar(_G[parent.."HealthBar"], 0)
	Skinner:glazeStatusBar(_G[parent.."ManaBar"], 0)
	Skinner:moveObject{obj=_G[parent], y=-12}

end

local function skinUFrame(frame)

	_G[frame.."Flash"]:SetAlpha(0) -- texture file is changed dependant upon size
	_G[frame.."Background"]:SetTexture(nil)
--	<frame>NameBackground:SetTexture(nil) -- used for faction colouring
	_G[frame.."TextureFrameTexture"]:SetAlpha(0) -- texture file is changed dependant upon mob type
	-- status bars
	Skinner:glazeStatusBar(_G[frame.."HealthBar"], 0)
	Skinner:adjHeight{obj=_G[frame.."HealthBar"] , adj=-1} -- handle bug in <frame> XML & lua which places mana bar 11 pixels below the healthbar, when their heights are 12
	Skinner:glazeStatusBar(_G[frame.."ManaBar"], 0)
	Skinner:glazeStatusBar(_G[frame.."SpellBar"], 0)
	Skinner:removeRegions(_G[frame.."NumericalThreat"], {3}) -- threat border
	-- move level & highlevel down, so they are more visible
	Skinner:moveObject{obj=_G[frame.."TextureFrameLevelText"], x=2, y=lOfs}
	-- casting bar
	_G[frame.."SpellBarBorder"]:SetAlpha(0) -- texture file is changed dependant upon spell type
--	<frame>SpellBarBorderShield:SetAlpha(0) -- used for shield texture
	changeShield(_G[frame.."SpellBar"])
	changeFlash(_G[frame.."SpellBar"])

	Skinner:addSkinFrame{obj=_G[frame], ft=ftype, noBdr=true, aso={ba=ba, ng=true}, y1=-7, x2=-37, y2=6}

-->>-- TargetofTarget Frame
	skinToT(frame.."ToT")
	Skinner:addSkinFrame{obj=_G[frame.."ToT"], ft=ftype, noBdr=true, aso={ba=ba, ng=true}, x2=6}

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
		_G["Boss"..i.."TargetFrameFlash"]:SetTexture(nil)
		_G["Boss"..i.."TargetFrameBackground"]:SetTexture(nil)
		_G["Boss"..i.."TargetFrameTextureFrameTexture"]:SetAlpha(0) -- texture file is changed dependant upon mob type
		self:glazeStatusBar(_G["Boss"..i.."TargetFrameHealthBar"], 0)
		self:glazeStatusBar(_G["Boss"..i.."TargetFrameManaBar"], 0)
		self:removeRegions(_G["Boss"..i.."TargetFrameNumericalThreat"], {3}) -- threat border
		self:addSkinFrame{obj=_G["Boss"..i.."TargetFrame"], ft=ftype, noBdr=true, aso={ba=ba, ng=true}, x1=-1,  y1=-14, x2=-72, y2=5}
		-- create a texture to show Elite dragon
		local bCat = _G["Boss"..i.."TargetFrameTextureFrame"]:CreateTexture(nil, "BACKGROUND")
		bCat:SetWidth(80)
		bCat:SetHeight(50)
		bCat:SetPoint("CENTER", 30, -21)
		bCat:SetTexture(eTex)
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
		self:Debug("changeUFOpacity: [%s, %s]", uFrame, self.skinFrame[_G[uFrame]])
		self.skinFrame[_G[uFrame]]:SetBackdropColor(r, g, b, a)
	end
	for i = 1, MAX_PARTY_MEMBERS do
		self.skinFrame[_G["PartyMemberFrame"..i]]:SetBackdropColor(r, g, b, a)
		self.skinFrame[_G["PartyMemberFrame"..i.."PetFrame"]]:SetBackdropColor(r, g, b, a)
	end
	for i = 1, 4 do
		self.skinFrame[_G["Boss"..i.."TargetFrame"]]:SetBackdropColor(r, g, b, a)
	end

end
