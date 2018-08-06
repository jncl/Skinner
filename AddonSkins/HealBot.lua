-- many thanks to acirac/diacono for their work on previous skins
local aName, aObj = ...
if not aObj:isAddonEnabled("HealBot") then return end
local _G = _G

aObj.addonsToSkin.HealBot = function(self) -- v 8.0.1.0

	-- Options frame
	self:addSkinFrame{obj=_G.HealBot_Options_Contents, ft="a", kfs=true, nb=true}
	self:addSkinFrame{obj=_G.HealBot_Options_MainFrame, ft="a", kfs=true, nb=true}
	self:skinStdButton{obj=_G.HealBot_Options_Defaults}
	self:skinStdButton{obj=_G.HealBot_Options_Reset}
	self:skinStdButton{obj=_G.HealBot_Options_Reload}
	self:skinStdButton{obj=_G.HealBot_Options_CloseButton}
	self:addSkinFrame{obj=_G.HealBot_Options, ft="a", kfs=true, nb=true, hdr=true, y1=4}

	-- About [Panel0]
	self:addSkinFrame{obj=_G.HealBot_Options_Panel0_1, ft="a", kfs=true, nb=true}
	self:skinDropDown{obj=_G.HealBot_Options_FAQ}
	self:addSkinFrame{obj=_G.HealBot_Options_Panel0_2, ft="a", kfs=true, nb=true}
	self:addSkinFrame{obj=_G.HealBot_Options_Panel0_3, ft="a", kfs=true, nb=true}

	-- General [Panel1]
	self:addSkinFrame{obj=_G.HealBot_Options_GenFrame, ft="a", kfs=true, nb=true}
	if self.modChkBtns then
		self:skinCheckButton{obj=_G.HealBot_Options_HideOptions}
		self:skinCheckButton{obj=_G.HealBot_Options_RightButtonOptions}
		self:skinCheckButton{obj=_G.HealBot_Options_ShowMinimapButton}
		self:skinCheckButton{obj=_G.HealBot_Options_QueryTalents}
		self:skinCheckButton{obj=_G.HealBot_Options_EnableLibQuickHealth}
		self:skinCheckButton{obj=_G.HealBot_Options_EnableAutoCombat}
		self:skinCheckButton{obj=_G.HealBot_Options_NoAuraWhenRested}
		self:skinCheckButton{obj=_G.HealBot_Options_DisableHealBotOpt}
		self:skinCheckButton{obj=_G.HealBot_Options_DisableHealBotSolo}
		self:skinCheckButton{obj=_G.HealBot_Options_AdjustMaxHealth}
	end
	self:skinSlider{obj=_G.HealBot_Options_RangeCheckFreq, hgt=-4}
	self:skinDropDown{obj=_G.HealBot_Options_hbLangs}
	self:skinStdButton{obj=_G.HealBot_Options_LangsButton}
	self:skinDropDown{obj=_G.HealBot_Options_hbCommands}
	self:skinStdButton{obj=_G.HealBot_Options_CommandsButton}
	self:skinDropDown{obj=_G.HealBot_Options_hbProfile}
	-- self:skinStdButton{obj=_G.HealBot_Options_hbProfileButton} -- N.B. name already used by above DD
	self:skinStdButton{obj=self:getChild(_G.HealBot_Options_Panel1, 7)}
	self:skinDropDown{obj=_G.HealBot_Options_EmergencyFClass}
	self:addSkinFrame{obj=_G.HealBot_Options_EmergLFrame, ft="a", kfs=true, nb=true}

	-- Spells [Panel2]
	self:skinDropDown{obj=_G.HealBot_Options_ActionBarsCombo}
	self:skinCheckButton{obj=_G.HealBot_Options_EnableHealthy}
	self:adjHeight{obj=_G.HealBot_Options_ActionBarsCombo, adj=12}
	self:skinDropDown{obj=_G.HealBot_Options_CastButton}
	self:skinDropDown{obj=_G.HealBot_Options_ButtonCastMethod}
	for _, v in _G.pairs{"Click", "Shift", "Ctrl", "Alt", "CtrlShift", "AltShift", "CtrlAlt"} do
		self:skinEditBox{obj=_G["HealBot_Options_" .. v], regs={6}, noHeight=true}
		self:skinStdButton{obj=_G["HealBot_Options_" .. v .. "HelpSelectButton"]}
	end
	self:addSkinFrame{obj=_G.HealBot_Options_KeysFrame, ft="a", kfs=true, nb=true}
	self:addSkinFrame{obj=_G.HealBot_Options_DisabledBarPanel, ft="a", kfs=true, nb=true}
	self:skinCheckButton{obj=_G.HealBot_Options_EnableSmartCast}
	self:skinCheckButton{obj=_G.HealBot_Options_ProtectPvP}
	for _, v in _G.pairs{"HealSpells", "OtherSpells", "Macros", "Items", "Cmds"} do
		self:skinDropDown{obj=_G["HealBot_Options_Select" .. v .. "Combo"]}
		self:adjHeight{obj=_G["HealBot_Options_Select" .. v .. "Combo"], adj=12}
		self:skinStdButton{obj=_G["HealBot_Options_" .. v .. "Select"]}
	end
	self:addSkinFrame{obj=_G.HealBot_Options_SelectSpellsFrame, ft="a", kfs=true, nb=true}

	-- Skins [Panel3]
	self:skinDropDown{obj=_G.HealBot_Options_Skins}
	self:skinStdButton{obj=_G.HealBot_Options_DeleteSkin}
	self:skinEditBox{obj=_G.HealBot_Options_NewSkin, regs={6, 7}}
	self:skinStdButton{obj=_G.HealBot_Options_NewSkinb}
	self:skinDropDown{obj=_G.HealBot_Options_FramesSelFrame}
	self:skinStdButton{obj=_G.HealBot_Options_ApplyTab2Frames}

		-- General
		self:skinDropDown{obj=_G.HealBot_Options_ManaIndicator}
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.HealBot_Options_PartyFrames}
			self:skinCheckButton{obj=_G.HealBot_Options_MiniBossFrames}
			self:skinCheckButton{obj=_G.HealBot_Options_RaidFrames}
			self:skinCheckButton{obj=_G.HealBot_Options_UseFluidBars}
		end
		self:skinSlider{obj=_G.HealBot_Options_BarUpdateFreq, hgt=-4}
		self:addSkinFrame{obj=_G.HealBot_Options_GeneralSkinsFrame, ft="a", kfs=true, nb=true}
		-- Healing
		self:skinStdButton{obj=_G.HealBot_Options_HealingHealGroupSettings}
		self:addSkinFrame{obj=_G.HealBot_Options_HealingSkinsFrame, ft="a", kfs=true, nb=true}
		self:skinSlider{obj=_G.HealBot_Options_AlertLevelIC, hgt=-4}
		self:skinSlider{obj=_G.HealBot_Options_AlertLevelOC, hgt=-4}
		self:skinDropDown{obj=_G.HealBot_Options_EmergencyFilter}
		self:addSkinFrame{obj=_G.HealBot_Options_HealRaidFrame, ft="a", kfs=true, nb=true}
		self:skinDropDown{obj=_G.HealBot_Options_ExtraSort}
		self:skinDropDown{obj=_G.HealBot_Options_ExtraSubSort}
		self:skinStdButton{obj=_G.HealBot_SkinsSubFrameSelectHealRaidFrameb}
		self:skinStdButton{obj=_G.HealBot_SkinsSubFrameSelectHealSortFrameb}
		self:skinStdButton{obj=_G.HealBot_SkinsSubFrameSelectHealHideFrameb}
		self:addSkinFrame{obj=_G.HealBot_Options_HealSortFrame, ft="a", kfs=true, nb=true}
		self:addSkinFrame{obj=_G.HealBot_Options_HealHideFrame, ft="a", kfs=true, nb=true}
		-- Aggro
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.HealBot_Options_AggroTrack}
			self:skinCheckButton{obj=_G.HealBot_Options_HighlightActiveBar}
			self:skinCheckButton{obj=_G.HealBot_Options_HighlightTargetBar}
		end
		self:skinDropDown{obj=_G.HealBot_Options_BarHealthNumFormatAggro}
		self:skinDropDown{obj=_G.HealBot_Options_AggroIndAlertLevel}
		self:skinDropDown{obj=_G.HealBot_Options_AggroAlertLevel}
		self:skinSlider{obj=_G.HealBot_Options_AggroFlashFreq, hgt=-4}
		self:skinSlider{obj=_G.HealBot_Options_AggroFlashAlphaMin, hgt=-4}
		self:skinSlider{obj=_G.HealBot_Options_AggroFlashAlphaMax, hgt=-4}
		self:addSkinFrame{obj=_G.HealBot_Options_AggroSkinsFrame, ft="a", kfs=true, nb=true}
		-- Enemy
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.HealBot_Options_ShowEnemyIncSelf}
			self:skinCheckButton{obj=_G.HealBot_Options_ShowEnemyIncTanks}
			self:skinCheckButton{obj=_G.HealBot_Options_ShowEnemyIncArena}
			self:skinCheckButton{obj=_G.HealBot_Options_ShowEnemyIncMyTargets}
			self:skinCheckButton{obj=_G.HealBot_Options_HideEnemyOutOfCombat}
		end
		self:skinSlider{obj=_G.HealBot_Options_ShowEnemyNumBoss, hgt=-4}
		self:addSkinFrame{obj=_G.HealBot_Options_EnemySkinsFrame, ft="a", kfs=true, nb=true}
		-- Protection
		self:skinCheckButton{obj=_G.HealBot_Options_CrashProt}
		self:skinEditBox{obj=_G.HealBot_Options_CrashProtEditBox, regs={6, 7}}
		self:skinSlider{obj=_G.HealBot_Options_CrashProtStartTime, hgt=-4}
		self:addSkinFrame{obj=_G.HealBot_Options_CrashProtPanel, ft="a", kfs=true, nb=true}
		self:skinCheckButton{obj=_G.HealBot_Options_CombatProt}
		self:skinSlider{obj=_G.HealBot_Options_CombatPartyNo, hgt=-4}
		self:skinSlider{obj=_G.HealBot_Options_CombatRaidNo, hgt=-4}
		self:addSkinFrame{obj=_G.HealBot_Options_CombatProtPanel, ft="a", kfs=true, nb=true}
		self:addSkinFrame{obj=_G.HealBot_Options_ProtSkinsFrame, ft="a", kfs=true, nb=true}
		-- Share
		self:skinDropDown{obj=_G.HealBot_Options_ShareSkin}
		self:skinStdButton{obj=_G.HealBot_Options_ShareSkinb}
		self:skinStdButton{obj=_G.HealBot_Options_LoadSkinb}
		self:skinSlider{obj=_G.HealBot_Options_ShareExternalScrollScrollBar}
		self:addSkinFrame{obj=_G.HealBot_Options_ShareExternalEditBoxFrame, ft="a", kfs=true, nb=true}
		self:addSkinFrame{obj=_G.HealBot_Options_ShareSkinsFrame, ft="a", kfs=true, nb=true}
		-- Chat
		self:skinEditBox{obj=_G.HealBot_Options_NotifyChan, regs={6}}
		self:skinEditBox{obj=_G.HealBot_Options_NotifyOtherMsg, regs={6, 7}}
		self:addSkinFrame{obj=_G.HealBot_Options_ChatSkinsFrame, ft="a", kfs=true, nb=true}

		-- Frames
		self:skinStdButton{obj=_G.HealBot_Options_FramesHealGroupSettings}
		self:skinEditBox{obj=_G.HealBot_Options_FrameAlias, regs={6}}
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.HealBot_Options_ActionLocked}
			self:skinCheckButton{obj=_G.HealBot_Options_AutoShow}
			self:skinCheckButton{obj=_G.HealBot_Options_PanelSounds}
		end
		self:skinDropDown{obj=_G.HealBot_Options_ActionAnchor}
		self:skinDropDown{obj=_G.HealBot_Options_ActionBarsAnchor}
		self:skinDropDown{obj=_G.HealBot_Options_BarsGrowDirection}
		self:skinDropDown{obj=_G.HealBot_Options_BarsOrientation}
		self:skinSlider{obj=_G.HealBot_FrameScale, hgt=-4}
		self:skinDropDown{obj=_G.HealBot_Options_TooltipPos}
		self:skinEditBox{obj=_G.HealBot_Options_FrameTitle, regs={6}}
		self:skinDropDown{obj=_G.HealBot_Options_AliasFontOutline}
		self:skinCheckButton{obj=_G.HealBot_Options_FrameAliasShow}
		self:skinSlider{obj=_G.HealBot_Options_AliasFontName, hgt=-4}
		self:skinSlider{obj=_G.HealBot_Options_AliasFontHeight, hgt=-4}
		self:skinSlider{obj=_G.HealBot_Options_AliasFontOffset, hgt=-4}
		self:skinStdButton{obj=_G.HealBot_BackgroundColorpickb}
		self:skinStdButton{obj=_G.HealBot_BorderColorpickb}
		self:addSkinFrame{obj=_G.HealBot_Options_FramesSkinsFrame, ft="a", kfs=true, nb=true}

			-- Heal Groups
			self:skinDropDown{obj=_G.HealBot_Options_HealGroups1Frame}
			self:skinDropDown{obj=_G.HealBot_Options_HealGroups2Frame}
			self:skinDropDown{obj=_G.HealBot_Options_HealGroups3Frame}
			self:skinDropDown{obj=_G.HealBot_Options_HealGroups4Frame}
			self:skinDropDown{obj=_G.HealBot_Options_HealGroups5Frame}
			self:skinDropDown{obj=_G.HealBot_Options_HealGroups6Frame}
			self:skinDropDown{obj=_G.HealBot_Options_HealGroups7Frame}
			self:skinDropDown{obj=_G.HealBot_Options_HealGroups8Frame}
			self:skinDropDown{obj=_G.HealBot_Options_HealGroups9Frame}
			self:skinDropDown{obj=_G.HealBot_Options_HealGroups10Frame}
			self:skinDropDown{obj=_G.HealBot_Options_HealGroups11Frame}
			self:addSkinFrame{obj=_G.HealBot_Options_HealGroupsSkinsFrame, ft="a", kfs=true, nb=true}
			if self.modChkBtns then
				for i = 1, 11 do
					self:skinCheckButton{obj=_G["HealBot_Options_HealGroups" .. i]}
				end
			end
			-- Headers
			self:skinSlider{obj=_G.HealBot_Options_HeadTextureS, hgt=-4}
			self:skinSlider{obj=_G.HealBot_Options_HeadHightS, hgt=-4}
			self:skinSlider{obj=_G.HealBot_Options_HeadWidthS, hgt=-4}
			self:skinSlider{obj=_G.HealBot_Options_HeadFontNameS, hgt=-4}
			self:skinSlider{obj=_G.HealBot_Options_HeadFontHeightS, hgt=-4}
			self:skinDropDown{obj=_G.HealBot_Options_HeadFontOutline}
			self:addSkinFrame{obj=_G.HealBot_Options_HeadersSkinsFrame, ft="a", kfs=true, nb=true}
			-- Bars
			self:skinSlider{obj=_G.HealBot_Options_BarTextureS, hgt=-4, hgt=-4, hgt=-4}
			self:skinSlider{obj=_G.HealBot_Options_BarNumColsS, hgt=-4, hgt=-4, hgt=-4}
			self:skinSlider{obj=_G.HealBot_Options_BarHeightS, hgt=-4, hgt=-4, hgt=-4}
			self:skinSlider{obj=_G.HealBot_Options_BarWidthS, hgt=-4, hgt=-4, hgt=-4}
			self:skinSlider{obj=_G.HealBot_Options_BarBRSpaceS, hgt=-4, hgt=-4, hgt=-4}
			self:skinSlider{obj=_G.HealBot_Options_BarBCSpaceS, hgt=-4, hgt=-4, hgt=-4}
			self:skinSlider{obj=_G.HealBot_Options_AggroBarSize, hgt=-4, hgt=-4, hgt=-4}
			self:skinSlider{obj=_G.HealBot_Options_Bar2Size, hgt=-4, hgt=-4, hgt=-4}
			self:addSkinFrame{obj = _G.HealBot_Options_BarsSkinsFrame, ft="a", kfs=true, nb=true}
			-- Bar Colours
			self:skinDropDown{obj = _G.HealBot_Options_BarHealthColour}
			self:skinSlider{obj=_G.HealBot_Options_BarAlpha, hgt=-4, hgt=-4}
			self:skinDropDown{obj = _G.HealBot_Options_BarHealthBackColour}
			self:skinSlider{obj=_G.HealBot_Options_BarOutlineBackGround, hgt=-4, hgt=-4}
			self:skinSlider{obj=_G.HealBot_Options_BarAlphaBackGround, hgt=-4, hgt=-4}
			self:skinDropDown{obj = _G.HealBot_Options_BarIncHealColour}
			self:skinSlider{obj=_G.HealBot_Options_BarAlphaInHeal, hgt=-4, hgt=-4}
			self:skinDropDown{obj = _G.HealBot_Options_AbsorbColour}
			self:skinSlider{obj=_G.HealBot_Options_BarAlphaAbsorb, hgt=-4, hgt=-4}
			self:skinSlider{obj=_G.HealBot_Options_BarAlphaEor, hgt=-4, hgt=-4}
			self:skinSlider{obj=_G.HealBot_Options_BarAlphaDis, hgt=-4, hgt=-4}
			self:addSkinFrame{obj = _G.HealBot_Options_BarColoursSkinsFrame, ft="a", kfs=true, nb=true}
			-- Bar text
			if self.modChkBtns then
				self:skinCheckButton{obj=_G.HealBot_Options_BarTextInClassColour}
				self:skinCheckButton{obj=_G.HealBot_Options_ShowClassOnBar}
				self:skinCheckButton{obj=_G.HealBot_Options_ShowNameOnBar}
				self:skinCheckButton{obj=_G.HealBot_Options_NumberTextLines}
				self:skinCheckButton{obj=_G.HealBot_Options_ShowHealthOnBar}
			end
			self:skinDropDown{obj=_G.HealBot_Options_BarHealthIncHeal}
			self:skinDropDown{obj=_G.HealBot_Options_BarHealthType}
			self:skinDropDown{obj=_G.HealBot_Options_BarHealthNumFormat1}
			self:skinDropDown{obj=_G.HealBot_Options_BarHealthNumFormat2}
			self:skinSlider{obj=_G.HealBot_Options_FontName, hgt=-4}
			self:skinSlider{obj=_G.HealBot_Options_TextAlign, hgt=-4}
			self:skinSlider{obj=_G.HealBot_Options_FontHeight, hgt=-4}
			self:skinDropDown{obj=_G.HealBot_Options_FontOutline}
			self:addSkinFrame{obj=_G.HealBot_Options_TextSkinsFrame, ft="a", kfs=true, nb=true}
			-- Icons
			if self.modChkBtns then
				self:skinCheckButton{obj=_G.HealBot_Options_BarButtonShowHoT}
				self:skinCheckButton{obj=_G.HealBot_Options_ShowDebuffIcon}
				self:skinCheckButton{obj=_G.HealBot_Options_ShowDirection}
				self:skinCheckButton{obj=_G.HealBot_Options_ShowReadyCheck}
				self:skinCheckButton{obj=_G.HealBot_Options_BarButtonShowRaidIcon}
				self:skinCheckButton{obj=_G.HealBot_BarButtonIconAlwaysEnabled}
			end
			self:skinSlider{obj=_G.HealBot_BarButtonIconScale, hgt=-4}
			self:skinDropDown{obj=_G.HealBot_Options_FilterHoTctl}
			self:skinDropDown{obj=_G.HealBot_Options_Class_HoTctlName}
			self:skinDropDown{obj=_G.HealBot_Options_Class_HoTctlAction}
			self:addSkinFrame{obj=_G.HealBot_Options_IconsSkinsFrame, ft="a", kfs=true, nb=true}
			-- Icon text
			self:skinSlider{obj=_G.HealBot_BarButtonIconTextDurationTime, hgt=-4}
			self:skinSlider{obj=_G.HealBot_BarButtonIconTextDurationWarn, hgt=-4}
			self:skinSlider{obj=_G.HealBot_BarButtonIconTextScale, hgt=-4}
			self:addSkinFrame{obj = _G.HealBot_Options_IconTextSkinsFrame, ft="a", kfs=true, nb=true}

	-- Cure [Panel4]
	self:skinCheckButton{obj=_G.HealBot_Options_MonitorDebuffs}
		-- CureDispelCleanse
		self:skinDropDown{obj=_G.HealBot_Options_CDCTxt1}
		self:skinDropDown{obj=_G.HealBot_Options_CDCGroups1}
		self:skinDropDown{obj=_G.HealBot_Options_CDCTxt2}
		self:skinDropDown{obj=_G.HealBot_Options_CDCGroups2}
		self:skinDropDown{obj=_G.HealBot_Options_CDCTxt3}
		self:skinDropDown{obj=_G.HealBot_Options_CDCGroups3}
		self:skinSlider{obj=_G.HealBot_Options_IgnoreDebuffsDurationSecs, hgt=-4}
		self:skinDropDown{obj=_G.HealBot_Options_CDCPriority1}
		self:skinDropDown{obj=_G.HealBot_Options_CDCPriority2}
		self:skinDropDown{obj=_G.HealBot_Options_CDCPriority3}
		self:skinDropDown{obj=_G.HealBot_Options_CDCPriority4}
		self:addSkinFrame{obj=_G.HealBot_Options_CureDispelCleanse, ft="a", kfs=true, nb=true}
		-- CustomCureFrame
		self:skinDropDown{obj=_G.HealBot_Options_CDebuffCat}
		self:skinDropDown{obj=_G.HealBot_Options_CDebuffTxt1}
		self:skinDropDown{obj=_G.HealBot_Options_CDCCastBy}
		self:skinStdButton{obj=_G.HealBot_Options_CDCCastByCustom}
		self:skinCheckButton{obj=_G.HealBot_Options_CDCReverseDurC}
		self:skinStdButton{obj=_G.HealBot_Options_DeleteCDebuffBtn}
		self:skinEditBox{obj=_G.HealBot_Options_NewCDebuff, regs={6, 7}}
		self:skinStdButton{obj=_G.HealBot_Options_NewCDebuffBtn}
		self:skinStdButton{obj=_G.HealBot_Options_EnableDisableCDBtn}
		self:skinDropDown{obj=_G.HealBot_Options_CDCPriorityC}
		self:skinStdButton{obj=_G.HealBot_Options_CDCPriorityCustom}
		self:skinCheckButton{obj=_G.HealBot_Options_CDCCol_OnOff}
		self:skinStdButton{obj=_G.HealBot_Options_ResetCDebuffBtn}
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.HealBot_Options_CDCAllDisease}
			self:skinCheckButton{obj=_G.HealBot_Options_CDCAllMagic}
			self:skinCheckButton{obj=_G.HealBot_Options_CDCAllPoison}
			self:skinCheckButton{obj=_G.HealBot_Options_CDCAllCurse}
		end
		self:addSkinFrame{obj=_G.HealBot_Options_CustomCureFrame, ft="a", kfs=true, nb=true}
		-- WarningCureFrame
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.HealBot_Options_CDCCol_ShowOnHealthBar}
			self:skinCheckButton{obj=_G.HealBot_Options_CDCCol_ShowOnAggroBar}
			self:skinCheckButton{obj=_G.HealBot_Options_ShowDebuffWarning}
			self:skinCheckButton{obj=_G.HealBot_Options_SoundDebuffWarning}
		end
		self:skinDropDown{obj=_G.HealBot_Options_CDCWarnRange1}
		self:skinDropDown{obj=_G.HealBot_Options_CDCWarnRange2}
		self:skinDropDown{obj=_G.HealBot_Options_CDCWarnRange3}
		self:skinDropDown{obj=_G.HealBot_Options_CDCWarnRange4}
		self:skinSlider{obj=_G.HealBot_Options_WarningSound, hgt=-4}
		self:addSkinFrame{obj=_G.HealBot_Options_WarningCureFrame, ft="a", kfs=true, nb=true}

	-- Buffs [ Panel 5]
	for i = 1, 8 do
		self:skinDropDown{obj=_G["HealBot_Options_BuffTxt".. i]}
		self:skinDropDown{obj=_G["HealBot_Options_BuffGroups" .. i]}
	end
	self:skinSlider{obj=_G.HealBot_Options_ShortBuffTimer, hgt=-4}
	self:skinSlider{obj=_G.HealBot_Options_LongBuffTimer, hgt=-4}
	self:addSkinFrame{obj=_G.HealBot_Options_BuffsPanel, ft="a", kfs=true, nb=true}

	-- Tips [Panel6]
	if self.modChkBtns then
		self:skinCheckButton{obj=_G.HealBot_Options_ShowTooltip}
		self:skinCheckButton{obj=_G.HealBot_Options_ShowTooltipTarget}
		self:skinCheckButton{obj=_G.HealBot_Options_ShowTooltipSpellDetail}
		self:skinCheckButton{obj=_G.HealBot_Options_ShowTooltipSpellCoolDown}
		self:skinCheckButton{obj=_G.HealBot_Options_ShowTooltipInstant}
		self:skinCheckButton{obj=_G.HealBot_Options_ShowTooltipUseGameTip}
		self:skinCheckButton{obj=_G.HealBot_Options_ShowTooltipShowHoT}
	end
	self:skinStdButton{obj=_G.HealBot_Options_TooltipPosSettings}
	self:skinSlider{obj=_G.HealBot_Options_TTAlpha, hgt=-4}

	-- Mouse Wheel [Panel7]
	self:skinCheckButton{obj=_G.HealBot_Options_EnableMouseWheel}
	for _, key in _G.pairs{"", "Shift", "Ctrl", "Alt"} do
		for _, action in _G.pairs{"Up", "Down"} do
			self:skinDropDown{obj=_G["HealBot_Options_MouseWheel" .. key .. action]}
		end
	end

	-- Test [Panel8]
	self:skinStdButton{obj=_G.HealBot_Options_TestBarsButton}
	self:skinDropDown{obj=_G.HealBot_Options_TestBarsProfile}
	self:skinSlider{obj=_G.HealBot_Options_NumberTestBars, hgt=-4}
	self:skinSlider{obj=_G.HealBot_Options_NumberTestTanks, hgt=-4}
	self:skinSlider{obj=_G.HealBot_Options_NumberTestHealers, hgt=-4}
	self:skinSlider{obj=_G.HealBot_Options_NumberTestMyTargets, hgt=-4}
	self:skinSlider{obj=_G.HealBot_Options_NumberTestPets, hgt=-4}
	self:skinSlider{obj=_G.HealBot_Options_NumberTestEnemy, hgt=-4}

	-- tooltips
	if self.db.profile.Tooltips.skin then
		self:add2Table(self.ttList, _G.HealBot_Tooltip)
		self:add2Table(self.ttList, _G.HealBot_ScanTooltip)
	end

	-- minimap button
	self.mmButs["HealBot"] = _G.HealBot_MMButton

end
