
local _G = _G
local ftype = "c"
local select = select

local ba = 0.15 -- set background alpha
local lOfs = -9 -- level text offset

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

function Skinner:UnitFrames()

	local db = self.db.profile.UnitFrames
	
	if db.player then self:Player() end
	if db.target then self:Target() end
	if db.focus then self:Focus() end
	if db.party then self:Party() end

end

function Skinner:Player()
	if self.initialized.Player then return end
	self.initialized.Player = true

	PlayerFrameBackground:SetTexture(nil)
	PlayerFrameTexture:SetAlpha(0) -- texture file is changed dependant upon in vehicle or not
	PlayerFrameVehicleTexture:SetAlpha(0) -- texture file is changed dependant upon in vehicle or not
	PlayerStatusTexture:SetTexture(nil)
	PlayerRestGlow:SetTexture(nil)
	PlayerAttackGlow:SetTexture(nil)
	-- status bars
	self:glazeStatusBar(PlayerFrameHealthBar, 0)
	self:glazeStatusBar(PlayerFrameManaBar, 0)
	-- move level & highlevel down, so they are more visible
	self:moveObject{obj=PlayerLevelText, y=lOfs}
	self:moveObject{obj=PlayerRestIcon, y=lOfs} -- covers level text when resting
	
	self:addSkinFrame{obj=PlayerFrame, ft=ftype, noBdr=true, aso={ba=ba, ng=true}, x1=37, y1=-7, y2=9}

--	if the player class is a DeathKnight then skin the RuneFrame
	if self.uCls == "DEATHKNIGHT" then 
		for i = 1, 6 do
			local rBdrTex = _G["RuneButtonIndividual"..i.."BorderTexture"]
			rBdrTex:SetTexture(nil)
		end
	end
--	if the player class is a Shaman then skin the TotemFrame
	if self.uCls == "SHAMAN" or self.uCls == "DEATHKNIGHT" then 
		for i = 1, 4 do
			local tfTBdrTex = self:getRegion(self:getChild(_G["TotemFrameTotem"..i], 2), 1) -- Totem Border texture
			tfTBdrTex:SetAlpha(0)
		end
	end
--	if the player class is a Rogue then skin the ComboFrame
	if self.uCls == "ROGUE" then 
		for i = 1, 5 do
			local cPtTex = select(1, _G["ComboPoint"..i]:GetRegions())
			cPtTex:SetTexture(nil)
		end
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

local eTex = [[Interface\Tooltips\EliteNameplateIcon]]
function Skinner:Target()
	if self.initialized.Target then return end
	self.initialized.Target = true

	-- create a texture to show UnitClassification
	local uCat = TargetFrame:CreateTexture(nil, "ARTWORK") -- make it appear above the portrait
	uCat:SetWidth(80)
	uCat:SetHeight(50)
	uCat:SetPoint("CENTER", 84, -31)
	
	-- hook this to show/hide the elite texture
	self:SecureHook("TargetFrame_CheckClassification", function(this)
		local classification = UnitClassification("target")
		uCat:SetTexture(eTex)
		if classification == "worldboss" then
		elseif classification == "rareelite" then
		elseif classification == "elite" then
		elseif classification == "rare" then
		else uCat:SetTexture(nil)
		end
	end)

	TargetFrameFlash:SetTexture(nil)
	TargetFrameBackground:SetTexture(nil)
--	TargetFrameNameBackground:SetTexture(nil) -- used for faction colouring
	TargetFrameTexture:SetAlpha(0) -- texture file is changed dependant upon mob type
	-- status bars
	self:glazeStatusBar(TargetFrameHealthBar, 0)
	self:glazeStatusBar(TargetFrameManaBar, 0)
	-- casting bar
	TargetFrameSpellBarBorder:SetAlpha(0) -- texture file is changed dependant upon spell type
--	TargetFrameSpellBarBorderShield:SetAlpha(0) -- used for shield texture
	changeShield(TargetFrameSpellBar)
	self:glazeStatusBar(TargetFrameSpellBar, 0)
	self:removeRegions(TargetFrameNumericalThreat, {3}) -- threat border
	-- move level & highlevel down, so they are more visible
	self:moveObject{obj=TargetLevelText, y=lOfs}
	self:moveObject{obj=TargetHighLevelTexture, y=lOfs} -- elite texture
	
	self:addSkinFrame{obj=TargetFrame, ft=ftype, noBdr=true, aso={ba=ba, ng=true}, x1=1, y1=-7, x2=-37, y2=9}

-->>-- TargetofTarget Frame
	TargetofTargetBackground:SetTexture(nil)
	TargetofTargetTexture:SetTexture(nil)
	-- status bars
	self:glazeStatusBar(TargetofTargetHealthBar, 0)
	self:glazeStatusBar(TargetofTargetManaBar, 0)
	
	self:addSkinFrame{obj=TargetofTargetFrame, ft=ftype, noBdr=true, aso={ba=ba, ng=true}, x2=6}

end

function Skinner:Focus()
	if self.initialized.Focus then return end
	self.initialized.Focus = true
	
	FocusFrameFlash:SetAlpha(0) -- texture file is changed dependant upon size
	FocusFrameBackground:SetTexture(nil)
--	FocusFrameNameBackground:SetTexture(nil) -- used for faction colouring
	FocusFrameTexture:SetTexture(nil)
	if self.isPatch then FocusFrameTextureFrameFullSizeTexture:SetTexture(nil) end
	-- status bars
	self:glazeStatusBar(FocusFrameHealthBar, 0)
	self:glazeStatusBar(FocusFrameManaBar, 0)
	-- casting bar
	FocusFrameSpellBarBorder:SetAlpha(0) -- texture file is changed dependant upon spell type
--	FocusFrameSpellBarBorderShield:SetAlpha(0) -- used for shield texture
	changeShield(FocusFrameSpellBar)
	self:glazeStatusBar(FocusFrameSpellBar, 0)
	self:removeRegions(FocusFrameNumericalThreat, {3}) -- threat border

	-- handle different sized frames
	if FocusFrame.fullSize then
	 	x1 ,y1, x2, y2 = 1, -7, -37, 9
 	else
 		x1 ,y1, x2, y2 = 6, 2, -5, 24
	end
	self:addSkinFrame{obj=FocusFrame, ft=ftype, noBdr=true, aso={ba=ba, ng=true}, x1=x1, y1=y1, x2=x2, y2=y2}

	if self.isPatch then
		self:SecureHook("FocusFrame_SetFullSize", function(fullSize)
			if fullSize then
				Skinner.skinFrame[FocusFrame]:SetPoint("TOPLEFT", FocusFrame, "TOPLEFT", 1, -7)
				Skinner.skinFrame[FocusFrame]:SetPoint("BOTTOMRIGHT", FocusFrame, "BOTTOMRIGHT", -37, 9)
			else
				Skinner.skinFrame[FocusFrame]:SetPoint("TOPLEFT", FocusFrame, "TOPLEFT", 6, 2)
				Skinner.skinFrame[FocusFrame]:SetPoint("BOTTOMRIGHT", FocusFrame, "BOTTOMRIGHT", -5, 24)
			end
		end)
	end
	
-->>-- TargetofFocus Frame	
	TargetofFocusBackground:SetTexture(nil)
	TargetofFocusTexture:SetTexture(nil)
	-- status bars
	self:glazeStatusBar(TargetofFocusHealthBar, 0)
	self:glazeStatusBar(TargetofFocusManaBar, 0)
	
	self:addSkinFrame{obj=TargetofFocusFrame, ft=ftype, noBdr=true, aso={ba=ba, ng=true}, x2=6}

end

function Skinner:Party()
	if self.initialized.Party then return end
	self.initialized.Party = true
	
	for i = 1, MAX_PARTY_MEMBERS do
		local pF = "PartyMemberFrame"..i
		_G[pF.."Background"]:SetTexture(nil)
		_G[pF.."Texture"]:SetAlpha(0) -- texture file is changed dependant upon in vehicle or not
		_G[pF.."VehicleTexture"]:SetAlpha(0) -- texture file is changed dependant upon in vehicle or not
		_G[pF.."Status"]:SetTexture(nil)
		
		-- move if already in a vehicle
		if _G[pF].state == "vehicle" then
			_G[pF.."Portrait"]:SetPoint("TOPLEFT", 7, -6)
			_G[pF.."LeaderIcon"]:SetPoint("TOPLEFT", 0, 0)
			_G[pF.."MasterIcon"]:SetPoint("TOPLEFT", 32, 0)
			_G[pF.."PVPIcon"]:SetPoint("TOPLEFT", -9, -15)
			_G[pF.."Disconnect"]:SetPoint("LEFT", -7, -1)
		end
		-- stop things being moved when moving to a vehicle and back again
		_G[pF.."Portrait"].SetPoint = function() end
		_G[pF.."LeaderIcon"].SetPoint = function() end
		_G[pF.."MasterIcon"].SetPoint = function() end
		_G[pF.."PVPIcon"].SetPoint = function() end
		_G[pF.."Disconnect"].SetPoint = function() end
		
		-- status bars
		self:glazeStatusBar(_G[pF.."HealthBar"], 0)
		self:glazeStatusBar(_G[pF.."ManaBar"], 0)
		self:addSkinFrame{obj=_G[pF], ft=ftype, noBdr=true, aso={ba=ba, ng=true}, x1=2, y1=5, x2=-1}
		-- pet frame
		local pPF ="PartyMemberFrame"..i.."PetFrame"
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
