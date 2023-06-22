local _, aObj = ...

local _G = _G
-- luacheck: ignore 631 (line is too long)

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
		petspec = aObj.uCls == "HUNTER" and true or nil,
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

if not aObj.isRtl then
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
else
	local function colourManaBar(manaBar)
		local powerType, powerToken, altR, altG, altB = _G.UnitPowerType(manaBar.unit)
		local info = _G.PowerBarColor[powerToken]
		if info then
			local playerDeadOrGhost = (manaBar.unit == "player" and (_G.UnitIsDead("player") or _G.UnitIsGhost("player")))
			if playerDeadOrGhost then
				manaBar:SetStatusBarColor(0.6, 0.6, 0.6, 0.5)
			else
				manaBar:SetStatusBarColor(info.r, info.g, info.b)
			end
		elseif altR then
			manaBar:SetStatusBarColor(altR, altG, altB)
		else
			info = _G.PowerBarColor[powerType] or _G.PowerBarColor["MANA"]
			manaBar:SetStatusBarColor(info.r, info.g, info.b)
		end
		-- change colour if white
		aObj:rawHook(manaBar, "SetStatusBarColor", function(this, r, g, b, a)
			if r ~= 1
			or g ~= 1
			or b ~= 1
			then
				aObj.hooks[this].SetStatusBarColor(this, r, g, b, a)
			end
		end, true)
	end
	-- hook this to manage colour changes
	aObj:SecureHook("UnitFrameHealthBar_Update", function(statusbar, _)
		statusbar:SetStatusBarColor(0, 1, 0) -- green
	end)
	aObj:SecureHook("UnitFrameManaBar_UpdateType", function(statusbar, _)
		colourManaBar(statusbar)
	end)
end
function module:skinUnitButton(opts) -- luacheck: ignore self

	-- setup offset values
	opts.ofs = opts.ofs or 0
	opts.x1 = opts.x1 or opts.ofs * -1
	opts.y1 = opts.y1 or opts.ofs
	opts.x2 = opts.x2 or opts.ofs
	opts.y2 = opts.y2 or opts.ofs * -1
	aObj:skinObject("button", {obj=opts.obj, fType=ftype, subt=true, bg=true, bd=11, ng=true, x1=opts.x1, y1=opts.y1, x2=opts.x2, y2=opts.y2})
	opts.obj.sb:SetBackdropColor(0.1, 0.1, 0.1, db.alpha) -- use dark background

	if opts.ti
	and opts.obj.threatIndicator
	then
		opts.obj.threatIndicator:ClearAllPoints()
		opts.obj.threatIndicator:SetAllPoints(opts.obj.sb)
		aObj:changeTex(opts.obj.threatIndicator, true, true)
		-- stop changes to texture
		opts.obj.threatIndicator.SetAtlas = _G.nop
		opts.obj.threatIndicator.SetTexture = _G.nop
		opts.obj.threatIndicator.SetTexCoord = _G.nop
		opts.obj.threatIndicator.SetWidth = _G.nop
		opts.obj.threatIndicator.SetHeight = _G.nop
		opts.obj.threatIndicator.SetPoint = _G.nop
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
			if not aObj.isRtl then
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
			else
				frame.PlayerFrameContainer.FrameTexture:SetAlpha(0) -- texture file is changed dependant upon in vehicle or not
				frame.PlayerFrameContainer.VehicleFrameTexture:SetAlpha(0) -- texture file is changed dependant upon in vehicle or not
				aObj:keepFontStrings(frame.PlayerFrameContent.PlayerFrameContentContextual.GroupIndicator)
				aObj:skinObject("statusbar", {obj=frame.PlayerFrameContent.PlayerFrameContentMain.HealthBarArea.PlayerFrameHealthBarAnimatedLoss, fi=0})
				aObj:skinObject("statusbar", {obj=frame.healthbar, fi=0, other={frame.myHealPredictionBar, frame.otherHealPredictionBar}})
				aObj:skinObject("statusbar", {obj=frame.manabar, fi=0, other={frame.myManaCostPredictionBar, frame.manabar.FeedbackFrame.BarTexture}, hookFunc=true})
				-- _G.PlayerFrameAlternateManaBar.DefaultBackground:SetAlpha(1)
				-- aObj:skinObject("statusbar", {obj=_G.PlayerFrameAlternateManaBar, regions={2, 3, 4, 5, 6}, fi=0, bg=_G.PlayerFrameAlternateManaBar.DefaultBackground})
			end
			local x1Ofs, y1Ofs, x2Ofs, y2Ofs = 35, -5, 2, 2
			-- skin the EclipseBarFrame/ComboPoints, if required
			if not aObj.isRtl then
				if aObj.uCls == "DRUID"
				or aObj.uCls == "ROGUE"
				then
					for i = 1, #_G.ComboFrame.ComboPoints do
						_G.ComboFrame.ComboPoints[i]:DisableDrawLayer("BACKGROUND")
					end
				end
				--	skin the TotemFrame, if required
				if aObj.uCls == "SHAMAN"
				or aObj.uCls == "DEATHKNIGHT"
				then
					for i = 1, _G.MAX_TOTEMS do
						_G["TotemFrameTotem" .. i .. "Background"]:SetAlpha(0) -- texture is changed
						aObj:getRegion(aObj:getChild(_G["TotemFrameTotem" .. i], 2), 1):SetAlpha(0) -- Totem Border texture
					end
					aObj:moveObject{obj=_G.TotemFrameTotem1, y=lOfs} -- covers level text when active
					y2Ofs = 9
				end
				-- skin the PaladinPowerBarFrame, if required
				if aObj.uCls == "PALADIN" then
					_G.PaladinPowerBarFrame:DisableDrawLayer("BACKGROUND")
					_G.PaladinPowerBarFrame.glow:DisableDrawLayer("BACKGROUND")
					y2Ofs = 6
				end
				-- skin the ArcaneChargesFrame, if required
				if aObj.uCls == "MAGE" then
					_G.MageArcaneChargesFrame:DisableDrawLayer("BACKGROUND")
				end
				-- skin the MonkHarmonyBar/MonkStaggerBar, if required
				if aObj.uCls == "MONK" then
					-- MonkHarmonyBarFrame (Windwalker)
					aObj:removeRegions(_G.MonkHarmonyBarFrame, {1, 2})
					for i = 1, #_G.MonkHarmonyBarFrame.LightEnergy do
						_G.MonkHarmonyBarFrame.LightEnergy[i]:DisableDrawLayer("BACKGROUND")
					end
					-- hook this to handle orb 5
					module:SecureHook(_G.MonkPowerBar, "UpdateMaxPower", function(this)
						if this.maxLight == 5 then
							_G.MonkHarmonyBarFrame.LightEnergy[5]:DisableDrawLayer("BACKGROUND")
							aObj:Unhook(_G.MonkPowerBar, "UpdateMaxPower")
						end
					end)
					-- MonkStaggerBar (Brewmaster)
					aObj:skinObject("statusbar", {obj=_G.MonkStaggerBar, regions= {2, 3, 4, 5, 6}, fi=0, bg=_G.MonkStaggerBar.DefaultBackground})
					-- extend frame if Brewmaster specialization
					if _G.MonkStaggerBar.class == aObj.uCls
					and _G.MonkStaggerBar.specRestriction == _G.GetSpecialization()
					then
						y2Ofs = 3
					end
				end
				-- skin the PriestBarFrame/InsanityBarFrame, if required
				if aObj.uCls == "PRIEST" then
					for i = 1, #_G.PriestBarFrame.LargeOrbs do
						_G.PriestBarFrame.LargeOrbs[i].Highlight:SetTexture(nil)
					end
					for i = 1, #_G.PriestBarFrame.SmallOrbs do
						_G.PriestBarFrame.SmallOrbs[i].Highlight:SetTexture(nil)
					end
					-- InsanityBarFrame
					_G.InsanityBarFrame.InsanityOn.PortraitOverlay:SetTexture(nil)
					_G.InsanityBarFrame.InsanityOn.TopShadowStay:SetTexture(nil)
				end
				-- skin the WarlockPowerFrame, if required
				if aObj.uCls == "WARLOCK" then
					_G.WarlockPowerFrame:DisableDrawLayer("BACKGROUND") -- Shard(s) background texture
				end
			else
				if aObj.uCls == "DEATHKNIGHT" then	-- luacheck: ignore 542 (empty if branch)
					-- RuneFrame
				elseif aObj.uCls == "DRACTHYR" then	-- luacheck: ignore 542 (empty if branch)
					-- EssencePlayerFrame
				elseif aObj.uCls == "DRUID" then
					for btn in _G.ComboPointDruidPlayerFrame.classResourceButtonPool:EnumerateActive() do
						btn.PointOff:SetAlpha(0)
					end
				elseif aObj.uCls == "MAGE" then
					_G.MageArcaneChargesFrame:DisableDrawLayer("BACKGROUND")
					for btn in _G.MageArcaneChargesFrame.classResourceButtonPool:EnumerateActive() do
						btn:DisableDrawLayer("BACKGROUND")
					end
				elseif aObj.uCls == "MONK" then
					aObj:removeRegions(_G.MonkHarmonyBarFrame, {1, 2})
					for btn in _G.MonkHarmonyBarFrame.classResourceButtonPool:EnumerateActive() do
						btn:DisableDrawLayer("BACKGROUND")
					end
					module:SecureHook(_G.MonkPowerBar, "UpdateMaxPower", function(fObj)
						if fObj.maxLight == 5 then
							_G.MonkHarmonyBarFrame.classResourceButtonTable[5]:DisableDrawLayer("BACKGROUND")
							aObj:Unhook(fObj, "UpdateMaxPower")
						end
					end)
				elseif aObj.uCls == "PRIEST" then
					_G.PriestBarFrame:DisableDrawLayer("BACKGROUND")
					for _, lOrb in _G.pairs(_G.PriestBarFrame.LargeOrbs) do
						lOrb.Bg:SetTexture(nil)
					end
					for _, sOrb in _G.pairs(_G.PriestBarFrame.SmallOrbs) do
						sOrb.Bg:SetTexture(nil)
					end
					_G.InsanityBarFrame.InsanityOn.PortraitOverlay:SetTexture(nil)
					_G.InsanityBarFrame.InsanityOn.TopShadowStay:SetTexture(nil)
				elseif aObj.uCls == "ROGUE" then
					for btn in _G.ComboPointPlayerFrame.classResourceButtonPool:EnumerateActive() do
						btn.PointOff:SetAlpha(0)
					end
				elseif aObj.uCls == "SHAMAN" then
					local function skinTotems(fObj)
						for btn  in fObj.totemPool:EnumerateActive() do
							aObj:getRegion(btn, 1):SetAlpha(0) -- Background texture
							aObj:getRegion(aObj:getChild(btn, 2), 1):SetAlpha(0) -- TotemBorder texture
						end
					end
					self:SecureHook(_G.TotemFrame, "Update", function(this)
						skinTotems(this)
					end)
					skinTotems(_G.TotemFrame)
				elseif aObj.uCls == "WARLOCK" then
					for btn in _G.WarlockPowerFrame.classResourceButtonPool:EnumerateActive() do
						btn:DisableDrawLayer("BACKGROUND")
					end
				end
			end
			-- skin the frame here as preceeding code changes y2Ofs value
			if aObj.isRtl then
				x1Ofs, y1Ofs, x2Ofs, y2Ofs = 14, -10, -12, 11
			end
			module:skinUnitButton{obj=frame, ti=true, x1=x1Ofs, y1=y1Ofs, x2=x2Ofs, y2=y2Ofs}
		end
		self:SecureHookScript(_G.PlayerFrame, "OnShow", function(this)
			skinPlayerFrame(this)

			self:Unhook(this, "OnShow")
		end)
		aObj:checkShown(_G.PlayerFrame)
	end

end
function module:skinPetF()

	if not aObj.uCls == "HUNTER"
	or not aObj.uCls == "WARLOCK"
	then
		return
	end

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
			if not aObj.isRtl then
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
				if aObj.modBtnBs then
					aObj:addButtonBorder{obj=_G.PetFrameHappiness, ofs=1, clr="gold"}
				end
			else
				aObj:nilTexture(_G.PetFrameTexture, true)
				_G.PetAttackModeTexture:SetTexture(nil)
				aObj:skinObject("statusbar", {obj=frame.healthbar, fi=0, other={frame.MyHealPredictionBar, frame.OtherHealPredictionBar}})
				aObj:skinObject("statusbar", {obj=frame.manabar, fi=0, hookFunc=true})
				for btn in _G.PetFrame.DebuffFramePool:EnumerateActive() do
					btn.Border:SetTexture(nil)
				end
				if db.petspec
				and aObj.uCls == "HUNTER"
				then
					-- Add pet spec icon to pet frame, if required
					frame.roleIcon = _G.PetFrame:CreateTexture(nil, "artwork")
					frame.roleIcon:SetSize(24, 24)
					frame.roleIcon:SetPoint("left", -10, 0)
					frame.roleIcon:SetTexture(aObj.tFDIDs.lfgIR)
					local function setSpec()
						local petSpec = _G.GetSpecialization(nil, true)
						if petSpec then
							_G.PetFrame.roleIcon:SetTexCoord(_G.GetTexCoordsForRole(_G.GetSpecializationRole(petSpec, nil, true)))
						end
					end
					-- get Pet's Specialization Role to set roleIcon TexCoord
					module:RegisterEvent("UNIT_PET", function(_, arg1)
						if arg1 == "player"
						and _G.UnitIsVisible("pet")
						then
							setSpec()
						end
					end)
					setSpec()
				end
			end
		end
		self:SecureHookScript(_G.PetFrame, "OnShow", function(this)
			skinPetFrame(this)

			self:Unhook(this, "OnShow")
		end)
		aObj:checkShown(_G.PetFrame)
	end

end
function module:skinCommon(fName, adjSB)

	local fo = _G[fName]
	if not aObj.isRtl then
		_G[fName .. "Background"]:SetTexture(nil)
		_G[fName .. "TextureFrameTexture"]:SetAlpha(0)
	else
		if fo.TargetFrameContainer then
			aObj:nilTexture(fo.TargetFrameContainer.FrameTexture, true)
			fo.TargetFrameContent.TargetFrameContentMain.ReputationColor:SetTexture(nil)
		else
			fo.FrameTexture:SetAlpha(0)
		end
	end

	aObj:skinObject("statusbar", {obj=fo.healthbar, fi=0, other={fo.myHealPredictionBar, fo.otherHealPredictionBar}})
	aObj:skinObject("statusbar", {obj=fo.manabar, fi=0, hookFunc=true})
	if not aObj.isRtl then
		if adjSB then
			self:adjustStatusBarPosn(fo.healthbar)
		end
	else
		if fo.TargetFrameContent then
			fo.TargetFrameContent.TargetFrameContentMain.HealthBar.HealthBarTexture.SetAtlas = _G.nop
		end
	end

end
function module:skinButton(fName, ti)

	local fo = _G[fName]
	local x1Ofs, y1Ofs, x2Ofs, y2Ofs
	if fo.isBossFrame then
		if not aObj.isRtl then
			x1Ofs, y1Ofs, x2Ofs, y2Ofs = -1, -14, -72, -10
		else
			x1Ofs, y1Ofs, x2Ofs, y2Ofs = 44, -20, -44, 10
		end
	else
		if not aObj.isRtl then
			x1Ofs, y1Ofs, x2Ofs, y2Ofs = -2, -5, -35, 0
		else
			x1Ofs, y1Ofs, x2Ofs, y2Ofs = 14, -12, -14, 12
		end
	end

	self:skinUnitButton{obj=fo, ti=ti or true, x1=x1Ofs, y1=y1Ofs, x2=x2Ofs, y2=y2Ofs}
	self:skinCommon(fName, true)
	if not aObj.isClscERA then
		if fo.threatNumericIndicator then
			fo.threatNumericIndicator:DisableDrawLayer("ARTWORK")
		end
	end

	if not fo.isBossFrame then
		-- move level & highlevel down, so they are more visible
		if not aObj.isRtl then
			aObj:moveObject{obj=_G[fName .. "TextureFrameLevelText"], x=2, y=lOfs}
		end
	end

	-- create a texture to show UnitClassification
	fo.ucTex = fo:CreateTexture(nil, "ARTWORK")
	if not aObj.isRtl then
		fo.ucTex:SetSize(80, 50)
		fo.ucTex:SetPoint("CENTER", fo.isBossFrame and 36 or 86, (fo.isBossFrame and -15 or -25) + lOfs)
	else
		if fo.isBossFrame then
			fo.ucTex:SetSize(90, 70)
			fo.ucTex:SetPoint("CENTER", 50, 0 + lOfs)
		-- else
		-- 	fo.ucTex:SetSize(80, 50)
		-- 	fo.ucTex:SetPoint("CENTER", 86, -25 + lOfs)
		end
	end

	if fo.spellbar then
		aObj:changeShield(fo.spellbar.BorderShield, fo.spellbar.Icon)
		fo.spellbar.Border:SetAlpha(0) -- texture file is changed dependant upon spell type
		if not aObj.isRtl then
			aObj:adjHeight{obj=fo.spellbar, adj=2}
			fo.spellbar.Flash:SetAllPoints()
			fo.spellbar.Text:ClearAllPoints()
			fo.spellbar.Text:SetPoint("TOP", 0, 3)
			aObj:skinObject("statusbar", {obj=fo.spellbar, fi=0, bg=aObj:getRegion(fo.spellbar, 1), other={fo.spellbar.Flash}})
		else
			aObj:nilTexture(fo.spellbar.TextBorder, true)
			aObj:skinObject("statusbar", {obj=fo.spellbar--[[, fi=0]], bg=fo.spellbar.Background, hookFunc=true})
		end
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
			if not aObj.isRtl then
				module:SecureHook("TargetFrame_UpdateLevelTextAnchor", function(fObj, targetLevel)
					fObj.levelText:SetPoint("CENTER", targetLevel == 100 and 61 or 62, -20 + lOfs)
				end)
				aObj:moveObject{obj=_G["TargetFrameToTHealthBar"], y=-2} -- move HealthBar down to match other frames
			end
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
			if not aObj.isRtl then
				frame.ucTex:SetTexture(aObj.tFDIDs.enI)
			end
		end
		if not aObj.isRtl then
			for i = 1, _G.MAX_BOSS_FRAMES do
				self:SecureHookScript(_G["Boss" .. i .. "TargetFrame"], "OnShow", function(this)
					skinBossTargetFrame(this)

					self:Unhook(this, "OnShow")
				end)
				aObj:checkShown(_G["Boss" .. i .. "TargetFrame"])
			end
		else
			for _, frame in _G.pairs(_G.BossTargetFrameContainer.BossTargetFrames) do
				self:SecureHookScript(frame, "OnShow", function(this)
					skinBossTargetFrame(this)

					self:Unhook(this, "OnShow")
				end)
				aObj:checkShown(frame)
			end
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
			if not aObj.isRtl then
				aObj:moveObject{obj=_G["FocusFrameToTHealthBar"], y=-2} -- move HealthBar down to match other frames
			end
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
			if not aObj.isRtl then
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
			else
				frame.Texture:SetAlpha(0) -- changed in code
				frame.VehicleTexture:SetAlpha(0) -- changed in code
				frame.PartyMemberOverlay.Status:SetTexture(nil)
				aObj:skinObject("statusbar", {obj=frame.HealthBar, fi=0, other={frame.HealthBar.MyHealPredictionBar, frame.HealthBar.OtherHealPredictionBar}})
				aObj:skinObject("statusbar", {obj=frame.ManaBar, fi=0})
				frame.HealthBar:SetStatusBarColor(0, 1, 0)
				module:skinUnitButton{obj=frame.PetFrame, ti=true, x1=-2, y1=1, y2=1}
				frame.PetFrame.Texture:SetAlpha(0) -- changed in code
				aObj:skinObject("statusbar", {obj=frame.PetFrame.HealthBar, fi=0})
			end
		end
		if not aObj.isRtl then
			for i = 1, _G.MAX_PARTY_MEMBERS do
				self:SecureHookScript(_G["PartyMemberFrame" .. i], "OnShow", function(this)
					skinPartyMemberFrame(this)

					self:Unhook(this, "OnShow")
				end)
				aObj:checkShown(_G["PartyMemberFrame" .. i])
			end
			aObj:skinObject("frame", {obj=_G.PartyMemberBackground, fType=ftype, x1=4, y2=2})
		else
			for frame in _G.PartyFrame.PartyMemberFramePool:EnumerateActive() do
				self:SecureHookScript(frame, "OnShow", function(this)
					skinPartyMemberFrame(this)

					self:Unhook(this, "OnShow")
				end)
				aObj:checkShown(frame)
			end
			aObj:skinObject("frame", {obj=_G.PartyFrame.Background, fType=ftype, kfs=true, rb=true})
		end
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
					aObj:addButtonBorder{obj=_G["PartyMemberBuffTooltipDebuff" .. i], relTo=_G["PartyMemberBuffTooltipDebuff" .. i .. "Icon"], ofs=3, clr="grey", ca=0.85}
				end
			end
			if aObj.modBtnBs then
				for i = 1, _G.MAX_PARTY_TOOLTIP_BUFFS do
					aObj:addButtonBorder{obj=_G["PartyMemberBuffTooltipBuff" .. i], relTo=_G["PartyMemberBuffTooltipBuff" .. i .. "Icon"], ofs=3, clr="grey", ca=0.85}
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
local function changeUFOpacity()

	-- handle in combat
	if _G.InCombatLockdown() then
	    aObj:add2Table(aObj.oocTab, {changeUFOpacity, {nil}})
	    return
	end

	for i = 1 ,#unitFrames do
		if _G[unitFrames[i]].sf then
			_G[unitFrames[i]].sf:SetAlpha(db.alpha)
		end
		if _G[unitFrames[i]].totFrame
		and _G[unitFrames[i]].totFrame.sf
		then
			_G[unitFrames[i]].totFrame.sf:SetAlpha(db.alpha)
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

	if _G.IsAddOnLoaded("Blizzard_ArenaUI") then
		if _G.ArenaPrepBackground.sf then
			_G.ArenaPrepBackground.sf:SetAlpha(db.alpha)
		end
		if _G.ArenaEnemyBackground.sf then
			_G.ArenaEnemyBackground.sf:SetAlpha(db.alpha)
		end
		for i = 1, _G.MAX_ARENA_ENEMIES do
			if _G["ArenaEnemyFrame" .. i].sf then
				_G["ArenaEnemyFrame" .. i].sf:SetAlpha(db.alpha)
				_G["ArenaEnemyFrame" .. i .. "PetFrame"].sf:SetAlpha(db.alpha)
			end
		end
	end

end

function module:OnInitialize()

	-- disable ourself if another unitframe addon is loaded
	if _G.IsAddOnLoaded("Perl_Config")
	or _G.IsAddOnLoaded("XPerl")
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

function module:OnDisable() -- luacheck: ignore self

	aObj.blizzLoDFrames[ftype].ArenaUI = _G.nop

end

function module:OnEnable()

	self:adjustUnitFrames("init")

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
		if not aObj.isRtl then
			-- hook this to show/hide the elite texture
			self:SecureHook("TargetFrame_CheckClassification", function(frame, _)
				chgTex(frame)
			end)
		else
			self:SecureHook(_G.TargetFrame, "CheckClassification", function(this, _)
				chgTex(this)
			end)
			self:SecureHook(_G.FocusFrame, "CheckClassification", function(this, _)
				chgTex(this)
			end)
		end
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

function module:GetOptions()

	local options = {
		type = "group",
		name = aObj.L["Unit Frames"],
		desc = aObj.L["Change the Unit Frames settings"],
		get = function(info) return db[info[#info]] end,
		set = function(info, value)
			if not self:IsEnabled() then self:Enable() end
			db[info[#info]] = value
			 -- enable pet frame when enabled
			if info[#info] == "petspec"
			and value == true
			then
				db.pet = true
			end
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
				if db.petspec then db.petspec = value end
				if db.petlvl then db.petlvl = value end
			end
			self:adjustUnitFrames(info[#info])
		end,
		args = {
			player = {
				type = "toggle",
				order = 1,
				name = aObj.L["Player"],
				desc = _G.strjoin(" ", aObj.L["Toggle the skin of the"], aObj.L["Player"], aObj.L["Unit Frame"]),
			},
			pet = (aObj.uCls == "HUNTER" or aObj.uCls == "WARLOCK") and {
				type = "toggle",
				order = 2,
				name = aObj.L["Pet"],
				desc = _G.strjoin(" ", aObj.L["Toggle the skin of the"], aObj.L["Pet"], aObj.L["Unit Frame"]),
			} or nil,
			petspec = aObj.isRtl and aObj.uCls == "HUNTER" and {
				type = "toggle",
				order = 3,
				name = aObj.L["Pet Spec"],
				desc = aObj.L["Toggle the Pet Spec on the Pet Frame"],
			} or nil,
			petlvl = not aObj.isRtl and aObj.uCls == "HUNTER" and {
				type = "toggle",
				order = 4,
				name = aObj.L["Pet Level"],
				desc = aObj.L["Toggle the Pet Level on the Pet Frame"],
			} or nil,
			target = {
				type = "toggle",
				order = 4,
				name = aObj.L["Target"],
				desc = _G.strjoin(" ", aObj.L["Toggle the skin of the"], aObj.L["Target"], aObj.L["Unit Frame"]),
			},
			focus = {
				type = "toggle",
				order = 5,
				name = aObj.L["Focus"],
				desc = _G.strjoin(" ", aObj.L["Toggle the skin of the"], aObj.L["Focus"], aObj.L["Unit Frame"]),
			},
			party = {
				type = "toggle",
				order = 6,
				name = aObj.L["Party"],
				desc = _G.strjoin(" ", aObj.L["Toggle the skin of the"], aObj.L["Party"], aObj.L["Unit Frames"]),
			},
			arena = {
				type = "toggle",
				order = 8,
				name = aObj.L["Arena"],
				desc = _G.strjoin(" ", aObj.L["Toggle the skin of the"], aObj.L["Arena"], aObj.L["Unit Frames"]),
			},
			alpha = {
				type = "range",
				order = 10,
				width = "double",
				name = aObj.L["Unit Frame Background Opacity"],
				desc = aObj.L["Change Opacity value of the Unit Frames' Background"],
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
		if not aObj.isRtl then
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
