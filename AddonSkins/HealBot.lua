-- many thanks to acirac/diacono for their work on previous skins
local aName, aObj = ...
if not aObj:isAddonEnabled("HealBot") then return end
local _G = _G

aObj.addonsToSkin.HealBot = function(self) -- v 7.3.0.0
	if not self.db.profile.Tooltips.skin then return end

	-- Options frame
	self:addSkinFrame{obj=_G.HealBot_Options_Contents}
	self:addSkinFrame{obj=_G.HealBot_Options_MainFrame}
	self:addSkinFrame{obj=_G.HealBot_Options, kfs=true, hdr=true, y1=4}

	-- About
	self:addSkinFrame{obj=_G.HealBot_Options_Panel0_1}
	self:skinDropDown{obj=_G.HealBot_Options_FAQ}
	self:addSkinFrame{obj=_G.HealBot_Options_Panel0_2}
	self:addSkinFrame{obj=_G.HealBot_Options_Panel0_3}
	-- General
	self:addSkinFrame{obj=_G.HealBot_Options_GenFrame}
	self:skinSlider{obj=_G.HealBot_Options_RangeCheckFreq}
	self:skinDropDown{obj=_G.HealBot_Options_hbLangs}
	self:skinDropDown{obj=_G.HealBot_Options_hbCommands}
	self:skinDropDown{obj=_G.HealBot_Options_hbProfile}
	self:skinDropDown{obj=_G.HealBot_Options_EmergencyFClass}
	self:addSkinFrame{obj=_G.HealBot_Options_EmergLFrame}
	-- Spells
	self:skinDropDown{obj=_G.HealBot_Options_ActionBarsCombo}
	self:adjHeight{obj=_G.HealBot_Options_ActionBarsCombo, adj=12}
	self:skinDropDown{obj=_G.HealBot_Options_CastButton}
	self:skinDropDown{obj=_G.HealBot_Options_ButtonCastMethod}
	for _, v in _G.pairs{"Click", "Shift", "Ctrl", "Alt", "CtrlShift", "AltShift", "CtrlAlt"} do
		self:skinEditBox{obj=_G["HealBot_Options_" .. v], regs={6}, noHeight=true}
		self:skinButton{obj=_G["HealBot_Options_" .. v .. "HelpSelectButton"]}
	end
	self:addSkinFrame{obj=_G.HealBot_Options_KeysFrame}
	self:addSkinFrame{obj=_G.HealBot_Options_DisabledBarPanel}
	for _, v in _G.pairs{"HealSpells", "OtherSpells", "Macros", "Items", "Cmds"} do
		self:skinDropDown{obj=_G["HealBot_Options_Select" .. v .. "Combo"]}
		self:adjHeight{obj=_G["HealBot_Options_Select" .. v .. "Combo"], adj=12}
		self:skinButton{obj=_G["HealBot_Options_" .. v .. "Select"]}
	end
	self:addSkinFrame{obj=_G.HealBot_Options_SelectSpellsFrame}
	-- Skins
	self:skinDropDown{obj=_G.HealBot_Options_Skins}
	self:skinEditBox{obj=_G.HealBot_Options_NewSkin, regs={6, 7}}

		-- General
		self:skinDropDown{obj=_G.HealBot_Options_SkinPartyRaidDefault}
		self:skinDropDown{obj=_G.HealBot_Options_ActionAnchor}
		self:skinDropDown{obj=_G.HealBot_Options_ActionBarsAnchor}
		self:skinDropDown{obj=_G.HealBot_Options_ManaIndicator}
		self:addSkinFrame{obj=_G.HealBot_Options_GeneralSkinsFrame}
		self:skinSlider{obj=_G.HealBot_Options_BarUpdateFreq}
		-- Healing
		self:addSkinFrame{obj=_G.HealBot_Options_HealingSkinsFrame}
		self:skinSlider{obj=_G.HealBot_Options_AlertLevelIC}
		self:skinSlider{obj=_G.HealBot_Options_AlertLevelOC}
		self:skinDropDown{obj=_G.HealBot_Options_EmergencyFilter}
		self:addSkinFrame{obj=_G.HealBot_Options_HealRaidFrame}
		self:skinDropDown{obj=_G.HealBot_Options_ExtraSort}
		self:skinDropDown{obj=_G.HealBot_Options_ExtraSubSort}
		self:addSkinFrame{obj=_G.HealBot_Options_HealSortFrame}
		self:addSkinFrame{obj=_G.HealBot_Options_HealHideFrame}
		-- Aggro
		self:skinDropDown{obj=_G.HealBot_Options_BarHealthNumFormatAggro}
		self:skinDropDown{obj=_G.HealBot_Options_AggroIndAlertLevel}
		self:skinDropDown{obj=_G.HealBot_Options_AggroAlertLevel}
		self:skinSlider{obj=_G.HealBot_Options_AggroFlashFreq}
		self:skinSlider{obj=_G.HealBot_Options_AggroFlashAlphaMin}
		self:skinSlider{obj=_G.HealBot_Options_AggroFlashAlphaMax}
		self:addSkinFrame{obj=_G.HealBot_Options_AggroSkinsFrame}
		-- Enemy
		self:skinSlider{obj=_G.HealBot_Options_ShowEnemyNumBoss}
		self:addSkinFrame{obj=_G.HealBot_Options_EnemySkinsFrame}
		-- Protection
		self:skinEditBox{obj=_G.HealBot_Options_CrashProtEditBox, regs={6, 7}}
		self:skinSlider{obj=_G.HealBot_Options_CrashProtStartTime}
		self:addSkinFrame{obj=_G.HealBot_Options_CrashProtPanel}
		self:skinSlider{obj=_G.HealBot_Options_CombatPartyNo}
		self:skinSlider{obj=_G.HealBot_Options_CombatRaidNo}
		self:addSkinFrame{obj=_G.HealBot_Options_CombatProtPanel}
		self:addSkinFrame{obj=_G.HealBot_Options_ProtSkinsFrame}
		-- Share
		self:skinDropDown{obj=_G.HealBot_Options_ShareSkin}
		self:skinSlider{obj=_G.HealBot_Options_ShareExternalScrollScrollBar}
		self:addSkinFrame{obj=_G.HealBot_Options_ShareExternalEditBoxFrame}
		self:addSkinFrame{obj=_G.HealBot_Options_ShareSkinsFrame}
		-- Chat
		self:skinEditBox{obj=_G.HealBot_Options_NotifyChan, regs={6}}
		self:skinEditBox{obj=_G.HealBot_Options_NotifyOtherMsg, regs={6, 7}}
		self:addSkinFrame{obj=_G.HealBot_Options_ChatSkinsFrame}

		-- Frames
		self:skinDropDown{obj=_G.HealBot_Options_FramesSelFrame}
		self:skinEditBox{obj=_G.HealBot_Options_FrameAlias, regs={6}}
		self:skinDropDown{obj=_G.HealBot_Options_BarsGrowDirection}
		self:skinDropDown{obj=_G.HealBot_Options_BarsOrientation}
		self:skinSlider{obj=_G.HealBot_FrameScale}
		self:skinEditBox{obj=_G.HealBot_Options_FrameTitle, regs={6}}
		self:skinDropDown{obj=_G.HealBot_Options_AliasFontOutline}
		self:skinSlider{obj=_G.HealBot_Options_AliasFontName}
		self:skinSlider{obj=_G.HealBot_Options_AliasFontHeight}
		self:skinSlider{obj=_G.HealBot_Options_AliasFontOffset}
		self:skinButton{obj=_G.HealBot_BackgroundColorpickb}
		self:skinButton{obj=_G.HealBot_BorderColorpickb}
		self:addSkinFrame{obj=_G.HealBot_Options_FramesSkinsFrame}
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
			self:addSkinFrame{obj=_G.HealBot_Options_HealGroupsSkinsFrame}
			-- Headers
			self:skinSlider{obj=_G.HealBot_Options_HeadTextureS}
			self:skinSlider{obj=_G.HealBot_Options_HeadHightS}
			self:skinSlider{obj=_G.HealBot_Options_HeadWidthS}
			self:skinSlider{obj=_G.HealBot_Options_HeadFontNameS}
			self:skinSlider{obj=_G.HealBot_Options_HeadFontHeightS}
			self:skinDropDown{obj = _G.HealBot_Options_HeadFontOutline}
			self:addSkinFrame{obj = _G.HealBot_Options_HeadersSkinsFrame}
			-- Bars
			self:skinSlider{obj=_G.HealBot_Options_BarTextureS}
			self:skinSlider{obj=_G.HealBot_Options_BarNumColsS}
			self:skinSlider{obj=_G.HealBot_Options_BarHeightS}
			self:skinSlider{obj=_G.HealBot_Options_BarWidthS}
			self:skinSlider{obj=_G.HealBot_Options_BarBRSpaceS}
			self:skinSlider{obj=_G.HealBot_Options_BarBCSpaceS}
			self:skinSlider{obj=_G.HealBot_Options_AggroBarSize}
			self:skinSlider{obj=_G.HealBot_Options_Bar2Size}
			self:addSkinFrame{obj = _G.HealBot_Options_BarsSkinsFrame}
			-- Bar Colours
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
			self:addSkinFrame{obj = _G.HealBot_Options_BarColoursSkinsFrame}
			-- Bar text
			self:skinDropDown{obj = _G.HealBot_Options_BarHealthIncHeal}
			self:skinDropDown{obj = _G.HealBot_Options_BarHealthType}
			self:skinDropDown{obj = _G.HealBot_Options_BarHealthNumFormat1}
			self:skinDropDown{obj = _G.HealBot_Options_BarHealthNumFormat2}
			self:skinSlider{obj=_G.HealBot_Options_FontName}
			self:skinSlider{obj=_G.HealBot_Options_TextAlign}
			self:skinSlider{obj=_G.HealBot_Options_FontHeight}
			self:skinDropDown{obj = _G.HealBot_Options_FontOutline}
			self:addSkinFrame{obj = _G.HealBot_Options_TextSkinsFrame}
			-- Icons
			self:skinSlider{obj=_G.HealBot_BarButtonIconScale}
			self:skinDropDown{obj = _G.HealBot_Options_FilterHoTctl}
			self:skinDropDown{obj = _G.HealBot_Options_Class_HoTctlName}
			self:skinDropDown{obj = _G.HealBot_Options_Class_HoTctlAction}
			self:addSkinFrame{obj = _G.HealBot_Options_IconsSkinsFrame}
			-- Icon text
			self:skinSlider{obj=_G.HealBot_BarButtonIconTextDurationTime}
			self:skinSlider{obj=_G.HealBot_BarButtonIconTextDurationWarn}
			self:skinSlider{obj=_G.HealBot_BarButtonIconTextScale}
			self:addSkinFrame{obj = _G.HealBot_Options_IconTextSkinsFrame}

	-- Cure
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
	self:addSkinFrame{obj=_G.HealBot_Options_CureDispelCleanse}
	self:skinDropDown{obj=_G.HealBot_Options_CDebuffCat}
	self:skinDropDown{obj=_G.HealBot_Options_CDebuffTxt1}
	self:skinDropDown{obj=_G.HealBot_Options_CDCCastBy}
	self:skinEditBox{obj=_G.HealBot_Options_NewCDebuff, regs={6, 7}}
	self:skinDropDown{obj=_G.HealBot_Options_CDCPriorityC}
	self:addSkinFrame{obj=_G.HealBot_Options_CustomCureFrame}
	self:skinDropDown{obj=_G.HealBot_Options_CDCWarnRange1}
	self:skinDropDown{obj=_G.HealBot_Options_CDCWarnRange2}
	self:skinDropDown{obj=_G.HealBot_Options_CDCWarnRange3}
	self:skinDropDown{obj=_G.HealBot_Options_CDCWarnRange4}
	self:skinSlider{obj=_G.HealBot_Options_WarningSound}
	self:addSkinFrame{obj=_G.HealBot_Options_WarningCureFrame}
	-- Buffs
	for i = 1, 8 do
		self:skinDropDown{obj=_G["HealBot_Options_BuffTxt".. i]}
		self:skinDropDown{obj=_G["HealBot_Options_BuffGroups" .. i]}
	end
	self:skinSlider{obj=_G.HealBot_Options_ShortBuffTimer}
	self:skinSlider{obj=_G.HealBot_Options_LongBuffTimer}
	self:addSkinFrame{obj=_G.HealBot_Options_BuffsPanel}
	-- Tips
	self:skinSlider{obj=_G.HealBot_Options_TTAlpha}
	self:skinDropDown{obj=_G.HealBot_Options_TooltipPos}
	-- Mouse Wheel
	for _, key in _G.pairs{"", "Shift", "Ctrl", "Alt"} do
		for _, action in _G.pairs{"Up", "Down"} do
			self:skinDropDown{obj=_G["HealBot_Options_MouseWheel" .. key .. action]}
		end
	end
	-- Test
	self:skinDropDown{obj=_G.HealBot_Options_TestBarsProfile}
	self:skinSlider{obj=_G.HealBot_Options_NumberTestBars}
	self:skinSlider{obj=_G.HealBot_Options_NumberTestTanks}
	self:skinSlider{obj=_G.HealBot_Options_NumberTestHealers}
	self:skinSlider{obj=_G.HealBot_Options_NumberTestMyTargets}
	self:skinSlider{obj=_G.HealBot_Options_NumberTestPets}
	self:skinSlider{obj=_G.HealBot_Options_NumberTestEnemy}
	self:skinButton{obj=_G.HealBot_Options_TestBarsButton}
	-- Usage

	-- tooltips
	if self.db.profile.Tooltips.skin then
		self:add2Table(self.ttList, "HealBot_Tooltip")
		self:add2Table(self.ttList, "HealBot_ScanTooltip")
	end

	-- minimap button
	self.mmButs["HealBot"] = _G.HealBot_MMButton

end
