-- many thanks to acirac/diacono for their work on previous skins
local aName, aObj = ...
if not aObj:isAddonEnabled("HealBot") then return end

function aObj:HealBot() -- v 5.1.0.2
	if not self.db.profile.Tooltips.skin then return end

	-- Options frame
	self:addSkinFrame{obj=HealBot_Options_Contents}
	self:addSkinFrame{obj=HealBot_Options_MainFrame}
	self:addSkinFrame{obj=HealBot_Options, kfs=true, hdr=true, y1=4}

	-- About
	self:addSkinFrame{obj=HealBot_Options_Panel0_1}
	self:skinDropDown{obj=HealBot_Options_FAQ}
	self:addSkinFrame{obj=HealBot_Options_Panel0_2}
	self:addSkinFrame{obj=HealBot_Options_Panel0_3}
	-- General
	self:addSkinFrame{obj=HealBot_Options_GenFrame}
	self:skinDropDown{obj=HealBot_Options_hbLangs}
	self:skinDropDown{obj=HealBot_Options_hbCommands}
	self:skinDropDown{obj=HealBot_Options_EmergencyFClass}
	self:addSkinFrame{obj=HealBot_Options_EmergLFrame}
	-- Spells
	self:skinDropDown{obj=HealBot_Options_ActionBarsCombo}
	self:adjHeight{obj=HealBot_Options_ActionBarsCombo, adj=12}
	self:skinDropDown{obj=HealBot_Options_CastButton}
	self:skinDropDown{obj=HealBot_Options_ButtonCastMethod}
	for _, v in pairs{"Click", "Shift", "Ctrl", "Alt", "CtrlShift", "AltShift", "CtrlAlt"} do
		self:skinEditBox{obj=_G["HealBot_Options_" .. v], regs={9}, noHeight=true}
		self:skinButton{obj=_G["HealBot_Options_" .. v .. "HelpSelectButton"]}
	end
	self:addSkinFrame{obj=HealBot_Options_KeysFrame}
	self:addSkinFrame{obj=HealBot_Options_DisabledBarPanel}
	for _, v in pairs{"HealSpells", "OtherSpells", "Macros", "Items", "Cmds"} do
		self:skinDropDown{obj=_G["HealBot_Options_Select" .. v .. "Combo"]}
		self:adjHeight{obj=_G["HealBot_Options_Select" .. v .. "Combo"], adj=12}
		self:skinButton{obj=_G["HealBot_Options_" .. v .. "Select"]}
	end
	self:addSkinFrame{obj=HealBot_Options_SelectSpellsFrame}
	-- Skins
	self:skinDropDown{obj=HealBot_Options_Skins}
	self:skinEditBox{obj=HealBot_Options_NewSkin, regs={9, 10}}
	self:skinDropDown{obj=HealBot_Options_ShareSkin}
		-- General
		self:skinDropDown{obj=HealBot_Options_SkinPartyRaidDefault}
		self:skinDropDown{obj=HealBot_Options_ActionAnchor}
		self:skinDropDown{obj=HealBot_Options_ActionBarsAnchor}
		self:skinDropDown{obj=HealBot_Options_ManaIndicator}
		self:addSkinFrame{obj=HealBot_Options_GeneralSkinsFrame}
		-- Healing
		self:addSkinFrame{obj=HealBot_Options_HealAlertFrame}
		self:skinDropDown{obj=HealBot_Options_EmergencyFilter}
		self:addSkinFrame{obj=HealBot_Options_HealRaidFrame}
		self:skinDropDown{obj=HealBot_Options_ExtraSort}
		self:skinDropDown{obj=HealBot_Options_ExtraSubSort}
		self:addSkinFrame{obj=HealBot_Options_HealSortFrame}
		self:addSkinFrame{obj=HealBot_Options_HealHideFrame}
		self:addSkinFrame{obj=HealBot_Options_HealingSkinsFrame}
		-- Headers
		self:skinDropDown{obj=HealBot_Options_HeadFontOutline}
		self:addSkinFrame{obj=HealBot_Options_HeadersSkinsFrame}
		-- Bars
		self:skinDropDown{obj=HealBot_Options_BarHealthColour}
		self:skinDropDown{obj=HealBot_Options_BarHealthBackColour}
		self:skinDropDown{obj=HealBot_Options_BarIncHealColour}
		self:addSkinFrame{obj=HealBot_Options_BarsSkinsFrame}
		-- Icons
		self:skinDropDown{obj=HealBot_Options_FilterHoTctl}
		self:skinDropDown{obj=HealBot_Options_Class_HoTctlName}
		self:skinDropDown{obj=HealBot_Options_Class_HoTctlAction}
		self:addSkinFrame{obj=HealBot_Options_IconsSkinsFrame}
		-- Aggro
		self:skinDropDown{obj=HealBot_Options_BarHealthNumFormatAggro}
		self:skinDropDown{obj=HealBot_Options_AggroIndAlertLevel}
		self:skinDropDown{obj=HealBot_Options_AggroAlertLevel}
		self:addSkinFrame{obj=HealBot_Options_AggroSkinsFrame}
		-- Protection
		self:skinEditBox{obj=HealBot_Options_CrashProtEditBox, regs={9, 10}}
		self:addSkinFrame{obj=HealBot_Options_CrashProtPanel}
		self:addSkinFrame{obj=HealBot_Options_CombatProtPanel}
		self:addSkinFrame{obj=HealBot_Options_ProtSkinsFrame}
		-- Chat
		self:skinEditBox{obj=HealBot_Options_NotifyChan, regs={9}}
		self:skinEditBox{obj=HealBot_Options_NotifyOtherMsg, regs={9, 10}}
		self:addSkinFrame{obj=HealBot_Options_ChatSkinsFrame}
		-- Bar text
		self:skinDropDown{obj=HealBot_Options_BarHealthIncHeal}
		self:skinDropDown{obj=HealBot_Options_BarHealthType}
		self:skinDropDown{obj=HealBot_Options_BarHealthNumFormat1}
		self:skinDropDown{obj=HealBot_Options_BarHealthNumFormat2}
		self:skinDropDown{obj=HealBot_Options_FontOutline}
		self:addSkinFrame{obj=HealBot_Options_TextSkinsFrame}
		-- Icon text
		self:addSkinFrame{obj=HealBot_Options_IconTextSkinsFrame}

	-- Cure
	self:skinDropDown{obj=HealBot_Options_CDCTxt1}
	self:skinDropDown{obj=HealBot_Options_CDCGroups1}
	self:skinDropDown{obj=HealBot_Options_CDCTxt2}
	self:skinDropDown{obj=HealBot_Options_CDCGroups2}
	self:skinDropDown{obj=HealBot_Options_CDCTxt3}
	self:skinDropDown{obj=HealBot_Options_CDCGroups3}
	self:skinDropDown{obj=HealBot_Options_CDCPriority1}
	self:skinDropDown{obj=HealBot_Options_CDCPriority2}
	self:skinDropDown{obj=HealBot_Options_CDCPriority3}
	self:skinDropDown{obj=HealBot_Options_CDCPriority4}
	self:addSkinFrame{obj=HealBot_Options_CureDispelCleanse}
	self:skinDropDown{obj=HealBot_Options_CDebuffCat}
	self:skinDropDown{obj=HealBot_Options_CDebuffTxt1}
	self:skinDropDown{obj=HealBot_Options_CDCCastBy}
	self:skinEditBox{obj=HealBot_Options_NewCDebuff, regs={9, 10}}
	self:skinDropDown{obj=HealBot_Options_CDCPriorityC}
	self:addSkinFrame{obj=HealBot_Options_CustomCureFrame}
	self:skinDropDown{obj=HealBot_Options_CDCWarnRange1}
	self:skinDropDown{obj=HealBot_Options_CDCWarnRange2}
	self:skinDropDown{obj=HealBot_Options_CDCWarnRange3}
	self:skinDropDown{obj=HealBot_Options_CDCWarnRange4}
	self:addSkinFrame{obj=HealBot_Options_WarningCureFrame}
	-- Buffs
	for i = 1, 8 do
		self:skinDropDown{obj=_G["HealBot_Options_BuffTxt".. i]}
		self:skinDropDown{obj=_G["HealBot_Options_BuffGroups" .. i]}
	end
	self:addSkinFrame{obj=HealBot_Options_BuffsPanel}
	-- Tips
	self:skinDropDown{obj=HealBot_Options_TooltipPos}
	-- Mouse Wheel
	for _, key in pairs{"", "Shift", "Ctrl", "Alt"} do
		for _, action in pairs{"Up", "Down"} do
			self:skinDropDown{obj=_G["HealBot_Options_MouseWheel" .. key .. action]}
		end
	end
	-- Test
	self:skinButton{obj=HealBot_Options_TestBarsButton}
	-- Usage

	-- tooltips
	if self.db.profile.Tooltips.skin then
		self:add2Table(self.ttList, "HealBot_Tooltip")
		self:add2Table(self.ttList, "HealBot_ScanTooltip")
	end

end
