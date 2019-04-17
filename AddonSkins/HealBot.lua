-- many thanks to acirac/diacono for their work on previous skins
local aName, aObj = ...
if not aObj:isAddonEnabled("HealBot") then return end
local _G = _G

aObj.addonsToSkin.HealBot = function(self) -- v 8.1.5.2

	-- Options frame
	self:addSkinFrame{obj=_G.HealBot_Options_Contents, ft="a", kfs=true, nb=true}
	self:addSkinFrame{obj=_G.HealBot_Options_MainFrame, ft="a", kfs=true, nb=true}
	self:addSkinFrame{obj=_G.HealBot_Options, ft="a", kfs=true, nb=true, hdr=true, y1=4}
	if self.modBtns then
		self:skinStdButton{obj=_G.HealBot_Options_Defaults}
		self:skinStdButton{obj=_G.HealBot_Options_Reset}
		self:skinStdButton{obj=_G.HealBot_Options_Reload}
		self:skinStdButton{obj=_G.HealBot_Options_CloseButton}
	end

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
	self:skinSlider{obj=_G.HealBot_Options_RangeCheckFreq}
	self:skinDropDown{obj=_G.HealBot_Options_hbLangs}
	self:skinDropDown{obj=_G.HealBot_Options_hbCommands}
	self:skinDropDown{obj=_G.HealBot_Options_hbProfile}
	self:skinDropDown{obj=_G.HealBot_Options_EmergencyFClass}
	self:addSkinFrame{obj=_G.HealBot_Options_EmergLFrame, ft="a", kfs=true, nb=true}
	if self.modBtns then
		self:skinStdButton{obj=_G.HealBot_Options_LangsButton}
		self:skinStdButton{obj=_G.HealBot_Options_CommandsButton}
		self:skinStdButton{obj=self:getChild(_G.HealBot_Options_Panel1, 7)}
	end

	-- Spells [Panel2]
	self:skinDropDown{obj=_G.HealBot_Options_ActionBarsCombo}
	if self.modChkBtns then
		 self:skinCheckButton{obj=_G.HealBot_Options_EnableHealthy}
	end
	self:adjHeight{obj=_G.HealBot_Options_ActionBarsCombo, adj=12}
	self:skinDropDown{obj=_G.HealBot_Options_CastButton}
	self:skinDropDown{obj=_G.HealBot_Options_ButtonCastMethod}
	for _, v in _G.pairs{"Click", "Shift", "Ctrl", "Alt", "CtrlShift", "AltShift", "CtrlAlt"} do
		self:skinEditBox{obj=_G["HealBot_Options_" .. v], regs={6}, noHeight=true}
		if self.modBtns then
			self:skinStdButton{obj=_G["HealBot_Options_" .. v .. "HelpSelectButton"]}
		end
	end
	self:addSkinFrame{obj=_G.HealBot_Options_KeysFrame, ft="a", kfs=true, nb=true}
	self:addSkinFrame{obj=_G.HealBot_Options_DisabledBarPanel, ft="a", kfs=true, nb=true}
	if self.modChkBtns then
		self:skinCheckButton{obj=_G.HealBot_Options_EnableSmartCast}
		self:skinCheckButton{obj=_G.HealBot_Options_ProtectPvP}
	end
	for _, v in _G.pairs{"HealSpells", "OtherSpells", "Macros", "Items", "Cmds"} do
		self:skinDropDown{obj=_G["HealBot_Options_Select" .. v .. "Combo"]}
		self:adjHeight{obj=_G["HealBot_Options_Select" .. v .. "Combo"], adj=12}
		if self.modBtns then
			self:skinStdButton{obj=_G["HealBot_Options_" .. v .. "Select"]}
		end
	end
	self:addSkinFrame{obj=_G.HealBot_Options_SelectSpellsFrame, ft="a", kfs=true, nb=true}

	-- Skins [Panel3]
	self:skinDropDown{obj=_G.HealBot_Options_Skins}
	self:skinEditBox{obj=_G.HealBot_Options_NewSkin, regs={6, 7}}
	self:skinDropDown{obj=_G.HealBot_Options_FramesSelFrame}
	if self.modBtns then
		self:skinStdButton{obj=_G.HealBot_Options_DeleteSkin}
		self:skinStdButton{obj=_G.HealBot_Options_NewSkinb}
		self:skinStdButton{obj=_G.HealBot_Options_ApplyTab2Frames}
	end

		-- General
		self:skinDropDown{obj=_G.HealBot_Options_ManaIndicator}
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.HealBot_Options_PartyFrames}
			self:skinCheckButton{obj=_G.HealBot_Options_MiniBossFrames}
			self:skinCheckButton{obj=_G.HealBot_Options_RaidFrames}
			self:skinCheckButton{obj=_G.HealBot_Options_UseFluidBars}
		end
		self:skinSlider{obj=_G.HealBot_Options_BarUpdateFreq}
		self:addSkinFrame{obj=_G.HealBot_Options_GeneralSkinsFrame, ft="a", kfs=true, nb=true}
		-- Protection
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.HealBot_Options_CrashProt}
			self:skinCheckButton{obj=_G.HealBot_Options_CombatProt}
		end
		self:skinEditBox{obj=_G.HealBot_Options_CrashProtEditBox, regs={6, 7}}
		self:skinSlider{obj=_G.HealBot_Options_CrashProtStartTime}
		self:addSkinFrame{obj=_G.HealBot_Options_CrashProtPanel, ft="a", kfs=true, nb=true}
		self:addSkinFrame{obj=_G.HealBot_Options_CombatProtPanel, ft="a", kfs=true, nb=true}
		self:addSkinFrame{obj=_G.HealBot_Options_ProtSkinsFrame, ft="a", kfs=true, nb=true}
		-- Chat
		self:skinEditBox{obj=_G.HealBot_Options_NotifyChan, regs={6}}
		self:skinEditBox{obj=_G.HealBot_Options_NotifyOtherMsg, regs={6, 7}}
		self:addSkinFrame{obj=_G.HealBot_Options_ChatSkinsFrame, ft="a", kfs=true, nb=true}
		-- Frames (General)
		if self.modBtns then
			 self:skinStdButton{obj=_G.HealBot_Options_FramesHealGroupSettings}
		end
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
		self:skinSlider{obj=_G.HealBot_FrameScale}
		self:skinDropDown{obj=_G.HealBot_Options_TooltipPos}
		self:skinEditBox{obj=_G.HealBot_Options_FrameTitle, regs={6}}
		self:skinDropDown{obj=_G.HealBot_Options_AliasFontOutline}
		if self.modChkBtns then
			 self:skinCheckButton{obj=_G.HealBot_Options_FrameAliasShow}
		end
		self:skinSlider{obj=_G.HealBot_Options_AliasFontName}
		self:skinSlider{obj=_G.HealBot_Options_AliasFontHeight}
		self:skinSlider{obj=_G.HealBot_Options_AliasFontOffset}
		if self.modBtns then
			self:skinStdButton{obj=_G.HealBot_BackgroundColorpickb}
			self:skinStdButton{obj=_G.HealBot_BorderColorpickb}
		end
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
			if self.modChkBtns then
				self:skinCheckButton{obj=_G.HealBot_Options_ShowHeaders}
			end
			self:skinSlider{obj=_G.HealBot_Options_HeadTextureS}
			self:skinSlider{obj=_G.HealBot_Options_HeadHightS}
			self:skinSlider{obj=_G.HealBot_Options_HeadWidthS}
			self:skinSlider{obj=_G.HealBot_Options_HeadFontNameS}
			self:skinSlider{obj=_G.HealBot_Options_HeadFontHeightS}
			self:skinDropDown{obj=_G.HealBot_Options_HeadFontOutline}
			self:addSkinFrame{obj=_G.HealBot_Options_HeadersSkinsFrame, ft="a", kfs=true, nb=true}
			-- Bars
			if self.modBtns then
				 self:skinStdButton{obj=_G.HealBot_Options_SkinsFramesBarsGeneralb}
				 self:skinStdButton{obj=_G.HealBot_Options_SkinsFramesBarsColoursb}
				 self:skinStdButton{obj=_G.HealBot_Options_SkinsFramesBarsTextb}
				 self:skinStdButton{obj=_G.HealBot_Options_SkinsFramesBarsSortb}
				 self:skinStdButton{obj=_G.HealBot_Options_SkinsFramesBarsVisibilityb}
				 self:skinStdButton{obj=_G.HealBot_Options_SkinsFramesBarsAggrob}
			end
			self:addSkinFrame{obj = _G.HealBot_Options_BarsSkinsFrame, ft="a", kfs=true, nb=true}
				-- General
				self:skinSlider{obj=_G.HealBot_Options_BarTextureS}
				self:skinSlider{obj=_G.HealBot_Options_BarNumColsS}
				self:skinSlider{obj=_G.HealBot_Options_BarHeightS}
				self:skinSlider{obj=_G.HealBot_Options_BarWidthS}
				self:skinSlider{obj=_G.HealBot_Options_BarBRSpaceS}
				self:skinSlider{obj=_G.HealBot_Options_BarBCSpaceS}
				self:skinSlider{obj=_G.HealBot_Options_AggroBarSize}
				self:skinSlider{obj=_G.HealBot_Options_Bar2Size}
				self:addSkinFrame{obj = _G.HealBot_Options_SkinsFramesBarsGeneral, ft="a", kfs=true, nb=true, ofs=0}
				-- Colours
				self:skinDropDown{obj = _G.HealBot_Options_BarHealthColour}
				self:skinSlider{obj=_G.HealBot_Options_BarAlpha}
				self:skinDropDown{obj = _G.HealBot_Options_BarHealthBackColour}
				self:skinSlider{obj=_G.HealBot_Options_BarOutlineBackGround}
				self:skinSlider{obj=_G.HealBot_Options_BarAlphaBackGround}
				self:skinDropDown{obj = _G.HealBot_Options_BarIncHealColour}
				self:skinSlider{obj=_G.HealBot_Options_BarAlphaInHeal}
				self:skinDropDown{obj = _G.HealBot_Options_AbsorbColour}
				self:skinSlider{obj=_G.HealBot_Options_BarAlphaAbsorb}
				self:skinSlider{obj=_G.HealBot_Options_BarAlphaEor}
				self:skinSlider{obj=_G.HealBot_Options_BarAlphaDis}
				self:addSkinFrame{obj = _G.HealBot_Options_SkinsFramesBarsColours, ft="a", kfs=true, nb=true, ofs=0}
				-- Text
				if self.modChkBtns then
					self:skinCheckButton{obj=_G.HealBot_Options_BarTextInClassColour}
					self:skinCheckButton{obj=_G.HealBot_Options_ShowClassOnBar}
					self:skinCheckButton{obj=_G.HealBot_Options_ShowNameOnBar}
					self:skinCheckButton{obj=_G.HealBot_Options_NumberTextLines}
					self:skinCheckButton{obj=_G.HealBot_Options_ShowHealthOnBar}
				end
				self:skinSlider{obj=_G.HealBot_Options_MaxChars}
				self:skinDropDown{obj=_G.HealBot_Options_BarHealthIncHeal}
				self:skinDropDown{obj=_G.HealBot_Options_BarHealthType}
				self:skinDropDown{obj=_G.HealBot_Options_BarHealthNumFormat1}
				self:skinDropDown{obj=_G.HealBot_Options_BarHealthNumFormat2}
				self:skinEditBox{obj=_G.HealBot_Options_DisconnectedTag, regs={6, 7}}
				self:skinEditBox{obj=_G.HealBot_Options_UnitDeadTag, regs={6}}
				self:skinEditBox{obj=_G.HealBot_Options_OutOfRangeTag, regs={6}}
				self:skinEditBox{obj=_G.HealBot_Options_ReserverTag, regs={6}}
				self:skinSlider{obj=_G.HealBot_Options_FontName}
				self:skinSlider{obj=_G.HealBot_Options_TextAlign}
				self:skinSlider{obj=_G.HealBot_Options_FontHeight}
				self:skinDropDown{obj=_G.HealBot_Options_FontOutline}
				self:addSkinFrame{obj=_G.HealBot_Options_SkinsFramesBarsText, ft="a", kfs=true, nb=true, ofs=0}
				-- Sort
				if self.modChkBtns then
					self:skinCheckButton{obj=_G.HealBot_Options_SubSortPlayerFirst}
					self:skinCheckButton{obj=_G.HealBot_Options_SortOutOfRangeLast}
				end
				self:skinDropDown{obj=_G.HealBot_Options_ExtraSort}
				self:skinDropDown{obj=_G.HealBot_Options_ExtraSubSort}
				self:addSkinFrame{obj=_G.HealBot_Options_SkinsFramesBarsSort, ft="a", kfs=true, nb=true, ofs=0}
				-- Visibility
				self:skinSlider{obj=_G.HealBot_Options_AlertLevelIC}
				self:skinSlider{obj=_G.HealBot_Options_AlertLevelOC}
				if self.modChkBtns then
					self:skinCheckButton{obj=_G.HealBot_Options_HideBars}
				end
				self:skinDropDown{obj=_G.HealBot_Options_EmergencyFilter}
				self:addSkinFrame{obj=_G.HealBot_Options_SkinsFramesBarsVisibility, ft="a", kfs=true, nb=true, ofs=0}
				-- Visibility Enemy
				if self.modChkBtns then
					self:skinCheckButton{obj=_G.HealBot_Options_ShowEnemyIncSelf}
					self:skinCheckButton{obj=_G.HealBot_Options_ShowEnemyIncTanks}
					self:skinCheckButton{obj=_G.HealBot_Options_ShowEnemyIncArena}
					self:skinCheckButton{obj=_G.HealBot_Options_ShowEnemyIncArenaPets}
					self:skinCheckButton{obj=_G.HealBot_Options_ShowEnemyIncMyTargets}
					self:skinCheckButton{obj=_G.HealBot_Options_HideEnemyOutOfCombat}
					self:skinCheckButton{obj=_G.HealBot_Options_EnemyExistsPlayerTargets}
					self:skinCheckButton{obj=_G.HealBot_Options_EnemyExistsArena}
					self:skinCheckButton{obj=_G.HealBot_Options_EnemyExistsBosses}
				end
				self:skinSlider{obj=_G.HealBot_Options_ShowEnemyNumBoss}
				self:addSkinFrame{obj=_G.HealBot_Options_SkinsFramesBarsVisibilityEnemy, ft="a", kfs=true, nb=true, ofs=0}
				-- Aggro
				if self.modChkBtns then
					self:skinCheckButton{obj=_G.HealBot_Options_AggroTrack}
					self:skinCheckButton{obj=_G.HealBot_Options_HighlightActiveBar}
					self:skinCheckButton{obj=_G.HealBot_Options_HighlightTargetBar}
				end
				self:skinDropDown{obj=_G.HealBot_Options_BarHealthNumFormatAggro}
				self:skinDropDown{obj=_G.HealBot_Options_AggroIndAlertLevel}
				self:skinDropDown{obj=_G.HealBot_Options_AggroAlertLevel}
				self:skinSlider{obj=_G.HealBot_Options_AggroFlashFreq}
				self:skinSlider{obj=_G.HealBot_Options_AggroFlashAlphaMin}
				self:skinSlider{obj=_G.HealBot_Options_AggroFlashAlphaMax}
				self:addSkinFrame{obj=_G.HealBot_Options_SkinsFramesBarsAggro, ft="a", kfs=true, nb=true, ofs=0}
			-- Icons
			if self.modBtns then
				self:skinStdButton{obj=_G.HealBot_Options_SkinsFrameIconsGeneralb}
				self:skinStdButton{obj=_G.HealBot_Options_SkinsFrameIconsTextb}
			end
			self:addSkinFrame{obj=_G.HealBot_Options_IconsSkinsFrame, ft="a", kfs=true, nb=true}
				-- General
				if self.modChkBtns then
					self:skinCheckButton{obj=_G.HealBot_Options_BarButtonShowHoT}
					self:skinCheckButton{obj=_G.HealBot_Options_ShowDebuffIcon}
					self:skinCheckButton{obj=_G.HealBot_Options_ShowDirection}
					self:skinCheckButton{obj=_G.HealBot_Options_ShowReadyCheck}
					self:skinCheckButton{obj=_G.HealBot_Options_BarButtonShowRaidIcon}
					self:skinCheckButton{obj=_G.HealBot_BarButtonIconAlwaysEnabled}
					self:skinCheckButton{obj=_G.HealBot_BarButtonIconFadeOnExpire}
				end
				self:skinSlider{obj=_G.HealBot_BarButtonMaxBuffIcons}
				self:skinSlider{obj=_G.HealBot_BarButtonMaxDeuffIcons} -- N.B. note spelling !!
				self:skinSlider{obj=_G.HealBot_BarButtonIconScale}
				self:addSkinFrame{obj=_G.HealBot_Options_SkinsFrameIconsGeneral, ft="a", kfs=true, nb=true, ofs=0}
				-- Text
				self:skinSlider{obj=_G.HealBot_BarButtonIconTextDurationTime}
				self:skinSlider{obj=_G.HealBot_BarButtonIconTextDurationWarn}
				self:skinSlider{obj=_G.HealBot_BarButtonIconTextScale}
				self:addSkinFrame{obj=_G.HealBot_Options_SkinsFrameIconsText, ft="a", kfs=true, nb=true, ofs=0}

	-- Debuffs [Panel4]
	self:skinCheckButton{obj=_G.HealBot_Options_MonitorDebuffs}
		-- CureDispelCleanse
		self:skinDropDown{obj=_G.HealBot_Options_CDCTxt1}
		self:skinDropDown{obj=_G.HealBot_Options_CDCGroups1}
		self:skinDropDown{obj=_G.HealBot_Options_CDCTxt2}
		self:skinDropDown{obj=_G.HealBot_Options_CDCGroups2}
		self:skinDropDown{obj=_G.HealBot_Options_CDCTxt3}
		self:skinDropDown{obj=_G.HealBot_Options_CDCGroups3}
		self:skinSlider{obj=_G.HealBot_Options_IgnoreDebuffsDurationSecs}
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
		if self.modBtns then
			 self:skinStdButton{obj=_G.HealBot_Options_DeleteCDebuffBtn}
			self:skinStdButton{obj=_G.HealBot_Options_NewCDebuffBtn}
			self:skinStdButton{obj=_G.HealBot_Options_EnableDisableCDBtn}
			self:skinStdButton{obj=_G.HealBot_Options_CDCPriorityCustom}
			self:skinStdButton{obj=_G.HealBot_Options_ResetCDebuffBtn}
		end
		self:skinEditBox{obj=_G.HealBot_Options_NewCDebuff, regs={6, 7}}
		self:skinDropDown{obj=_G.HealBot_Options_CDCPriorityC}
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.HealBot_Options_CDCReverseDurC}
			self:skinCheckButton{obj=_G.HealBot_Options_CDCCol_OnOff}
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
		self:skinSlider{obj=_G.HealBot_Options_WarningSound}
		self:addSkinFrame{obj=_G.HealBot_Options_WarningCureFrame, ft="a", kfs=true, nb=true}

	-- Buffs [Panel5]
		--General
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.HealBot_Options_MonitorBuffs}
		end
		for i = 1, 8 do
			self:skinDropDown{obj=_G["HealBot_Options_BuffTxt".. i]}
			self:skinDropDown{obj=_G["HealBot_Options_BuffGroups" .. i]}
		end
		self:skinSlider{obj=_G.HealBot_Options_ShortBuffTimer}
		self:skinSlider{obj=_G.HealBot_Options_LongBuffTimer}
		self:addSkinFrame{obj=_G.HealBot_Options_BuffsPanel, ft="a", kfs=true, nb=true}
		-- Icons
		self:skinDropDown{obj=_G.HealBot_Options_FilterHoTctl}
		self:skinDropDown{obj=_G.HealBot_Options_Class_HoTctlName}
		self:skinDropDown{obj=_G.HealBot_Options_Class_HoTctlAction}

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
	if self.modBtns then
		 self:skinStdButton{obj=_G.HealBot_Options_TooltipPosSettings}
	end
	self:skinSlider{obj=_G.HealBot_Options_TTAlpha}

	-- Mouse Wheel [Panel7]
	if self.modChkBtns then
		 self:skinCheckButton{obj=_G.HealBot_Options_EnableMouseWheel}
	end
	for _, key in _G.pairs{"", "Shift", "Ctrl", "Alt"} do
		for _, action in _G.pairs{"Up", "Down"} do
			self:skinDropDown{obj=_G["HealBot_Options_MouseWheel" .. key .. action]}
		end
	end

	-- Test [Panel8]
	if self.modBtns then
		 self:skinStdButton{obj=_G.HealBot_Options_TestBarsButton}
	end
	self:skinDropDown{obj=_G.HealBot_Options_TestBarsProfile}
	self:skinSlider{obj=_G.HealBot_Options_NumberTestBars}
	self:skinSlider{obj=_G.HealBot_Options_NumberTestTanks}
	self:skinSlider{obj=_G.HealBot_Options_NumberTestHealers}
	self:skinSlider{obj=_G.HealBot_Options_NumberTestMyTargets}
	self:skinSlider{obj=_G.HealBot_Options_NumberTestPets}
	self:skinSlider{obj=_G.HealBot_Options_NumberTestEnemy}

	-- Import / Export [Panel9]
	self:skinDropDown{obj=_G.HealBot_Options_InOutSkin}
	if self.modBtns then
		self:skinStdButton{obj=_G.HealBot_Options_ShareSkinb}
		self:skinStdButton{obj=_G.HealBot_Options_LoadSkinb}
	end
	self:skinSlider{obj=_G.HealBot_Options_ShareExternalScrollScrollBar}
	self:addSkinFrame{obj=_G.HealBot_Options_ShareExternalEditBoxFrame, ft="a", kfs=true, nb=true}

	-- tooltips
	if self.db.profile.Tooltips.skin then
		self:add2Table(self.ttList, _G.HealBot_Tooltip)
		self:add2Table(self.ttList, _G.HealBot_ScanTooltip)
	end

	-- minimap button
	self.mmButs["HealBot"] = _G.HealBot_MMButton

end
