-- many thanks to acirac for the updated skin
if not Skinner:isAddonEnabled("HealBot") then return end

function Skinner:HealBot() -- version 4.2.0.1
	if not self.db.profile.Tooltips.skin then return end

-->>--	Tooltips
	if self.db.profile.Tooltips.style == 3 then
		HealBot_ScanTooltip:SetBackdrop(self.backdrop)
		HealBot_Tooltip:SetBackdrop(self.backdrop)
	end
	self:skinTooltip(HealBot_ScanTooltip)
	self:skinTooltip(HealBot_Tooltip)

-- Tabs
	self:resizeTabs(HealBot_Options)
	for i = 1, HealBot_Options.numTabs do
		local tabObj = _G["HealBot_OptionsTab"..i]
		self:keepRegions(tabObj, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		self:addSkinFrame{obj=tabObj, ft=ftype, noBdr=self.isTT, x1=6, x2=-6, y2=2}
		local tabSF = self.skinFrame[tabObj]
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end
	
	if self.db.profile.TexturedTab then
		self:setActiveTab(HealBot_OptionsTab1)
		self:SecureHook("HealBot_Options_ShowPanel", function(this)
			for i = 1, HealBot_Options.numTabs do
				local tabObj = _G["HealBot_OptionsTab"..i]
				local tabSF = self.skinFrame[tabObj]
				if i == HealBot_Options.selectedTab then
				  self:setActiveTab(tabSF)
				else
				  self:setInactiveTab(tabSF)
				end
			end
		end)
	end

	self:keepFontStrings(HealBot_Options_SelectHealSpellsCombo)
	self:keepFontStrings(HealBot_Options_SelectOtherSpellsCombo)
	self:keepFontStrings(HealBot_Options_SelectMacrosCombo)
	self:keepFontStrings(HealBot_Options_SelectItemsCombo)
	self:keepFontStrings(HealBot_Options_SelectCmdsCombo)
	
	self:keepFontStrings(HealBot_Options_hbCommands)
	self:keepFontStrings(HealBot_Options_EmergencyFilter)
	self:keepFontStrings(HealBot_Options_ManaIndicator)
	self:keepFontStrings(HealBot_Options_BarHealthNumFormatAggro)
	self:keepFontStrings(HealBot_Options_AggroIndAlertLevel)	
	self:keepFontStrings(HealBot_Options_AggroAlertLevel)	
	self:keepFontStrings(HealBot_Options_CastButton)
	self:keepFontStrings(HealBot_Options_ButtonCastMethod)
	self:keepFontStrings(HealBot_Options_ExtraSort)
	self:keepFontStrings(HealBot_Options_ExtraSubSort)
	self:keepFontStrings(HealBot_Options_FilterHoTctl)
	self:keepFontStrings(HealBot_Options_Class_HoTctlName)
	self:keepFontStrings(HealBot_Options_Class_HoTctlAction)
	
	self:keepFontStrings(HealBot_Options_BarHealthIncHeal)
	self:keepFontStrings(HealBot_Options_BarHealthType)
	self:keepFontStrings(HealBot_Options_BarHealthNumFormat1)
	self:keepFontStrings(HealBot_Options_BarHealthNumFormat2)
	self:keepFontStrings(HealBot_Options_HeadFontOutline)
	self:keepFontStrings(HealBot_Options_FontOutline)
	
	self:keepFontStrings(HealBot_Options_EmergencyFClass)
	self:keepFontStrings(HealBot_Options_EmergLFrame)
	self:applySkin(HealBot_Options_EmergLFrame, nil)	
	
	self:keepFontStrings(HealBot_Options_BuffTxt1)
	self:keepFontStrings(HealBot_Options_BuffTxt2)
	self:keepFontStrings(HealBot_Options_BuffTxt3)
	self:keepFontStrings(HealBot_Options_BuffTxt4)
	self:keepFontStrings(HealBot_Options_BuffTxt5)
	self:keepFontStrings(HealBot_Options_BuffTxt6)
	self:keepFontStrings(HealBot_Options_BuffTxt7)
	self:keepFontStrings(HealBot_Options_BuffTxt8)
	self:keepFontStrings(HealBot_Options_BuffTxt9)
	self:keepFontStrings(HealBot_Options_BuffTxt10)
	
	self:keepFontStrings(HealBot_Options_BuffGroups1)
	self:keepFontStrings(HealBot_Options_BuffGroups2)
	self:keepFontStrings(HealBot_Options_BuffGroups3)
	self:keepFontStrings(HealBot_Options_BuffGroups4)
	self:keepFontStrings(HealBot_Options_BuffGroups5)
	self:keepFontStrings(HealBot_Options_BuffGroups6)
	self:keepFontStrings(HealBot_Options_BuffGroups7)
	self:keepFontStrings(HealBot_Options_BuffGroups8)
	self:keepFontStrings(HealBot_Options_BuffGroups9)
	self:keepFontStrings(HealBot_Options_BuffGroups10)
	
	self:keepFontStrings(HealBot_Options_CDCTxt1)
	self:keepFontStrings(HealBot_Options_CDCTxt2)
	self:keepFontStrings(HealBot_Options_CDCTxt3)
	
	self:keepFontStrings(HealBot_Options_CDCGroups1)
	self:keepFontStrings(HealBot_Options_CDCGroups2)
	self:keepFontStrings(HealBot_Options_CDCGroups3)
	
	self:keepFontStrings(HealBot_Options_CDCPriority1)
	self:keepFontStrings(HealBot_Options_CDCPriority2)
	self:keepFontStrings(HealBot_Options_CDCPriority3)
	self:keepFontStrings(HealBot_Options_CDCPriority4)
	
	self:keepFontStrings(HealBot_Options_CDebuffCat)
	self:keepFontStrings(HealBot_Options_CDCPriorityC)
	
	self:keepFontStrings(HealBot_Options_CDCWarnRange1)
	self:keepFontStrings(HealBot_Options_CDCWarnRange2)
	self:keepFontStrings(HealBot_Options_CDCWarnRange3)
	self:keepFontStrings(HealBot_Options_CDCWarnRange4)
	
	self:keepFontStrings(HealBot_Options_BarHealthColour)
	self:keepFontStrings(HealBot_Options_BarIncHealColour)
	
	self:keepFontStrings(HealBot_Options_BuffsPanel)
	self:applySkin(HealBot_Options_BuffsPanel, nil)	
	self:keepFontStrings(HealBot_Options_ComboClassButton)
	self:keepFontStrings(HealBot_Options_ActionBarsCombo)
	self:keepFontStrings(HealBot_Options_MouseWheelUp)
	self:keepFontStrings(HealBot_Options_MouseWheelDown)	
	self:keepFontStrings(HealBot_Options_MouseWheelShiftUp)
	self:keepFontStrings(HealBot_Options_MouseWheelShiftDown)
	self:keepFontStrings(HealBot_Options_MouseWheelCtrlUp)
	self:keepFontStrings(HealBot_Options_MouseWheelCtrlDown)
	self:keepFontStrings(HealBot_Options_MouseWheelAltUp)
	self:keepFontStrings(HealBot_Options_MouseWheelAltDown)	
	self:keepFontStrings(HealBot_Options_SkinPartyRaidDefault)
	self:keepFontStrings(HealBot_Options_KeysFrame)
	self:applySkin(HealBot_Options_KeysFrame, nil)
	self:keepFontStrings(HealBot_Options_DisabledBarPanel)
	self:applySkin(HealBot_Options_DisabledBarPanel, nil)	
	self:keepFontStrings(HealBot_Options_SelectSpellsFrame)
	self:applySkin(HealBot_Options_SelectSpellsFrame, nil)
	self:keepFontStrings(HealBot_Options_HealAlertFrame)
	self:applySkin(HealBot_Options_HealAlertFrame, nil)
	self:keepFontStrings(HealBot_Options_HealRaidFrame)
	self:applySkin(HealBot_Options_HealRaidFrame, nil)	
	self:keepFontStrings(HealBot_Options_HealSortFrame)
	self:applySkin(HealBot_Options_HealSortFrame, nil)
	self:keepFontStrings(HealBot_Options_HealHideFrame)
	self:applySkin(HealBot_Options_HealHideFrame, nil)	
	self:keepFontStrings(HealBot_Options_AggroSkinsFrame)
	self:applySkin(HealBot_Options_AggroSkinsFrame, nil)
	self:keepFontStrings(HealBot_Options_IconTextSkinsFrame)
	self:applySkin(HealBot_Options_IconTextSkinsFrame, nil)	
	
	self:keepFontStrings(HealBot_Options_TooltipPos)
	self:keepFontStrings(HealBot_Options_TooltipsPanel)
	self:applySkin(HealBot_Options_TooltipsPanel, nil)
	self:keepFontStrings(HealBot_Options_GeneralSkinsFrame)
	self:applySkin(HealBot_Options_GeneralSkinsFrame, nil)
	self:keepFontStrings(HealBot_Options_HealingSkinsFrame)
	self:applySkin(HealBot_Options_HealingSkinsFrame, nil)			
	self:keepFontStrings(HealBot_Options_ChatSkinsFrame)
	self:applySkin(HealBot_Options_ChatSkinsFrame, nil)	
	self:keepFontStrings(HealBot_Options_HeadersSkinsFrame)
	self:applySkin(HealBot_Options_HeadersSkinsFrame, nil)	
	self:keepFontStrings(HealBot_Options_BarsSkinsFrame)
	self:applySkin(HealBot_Options_BarsSkinsFrame, nil)	
	self:keepFontStrings(HealBot_Options_TextSkinsFrame)
	self:applySkin(HealBot_Options_TextSkinsFrame, nil)	
	self:keepFontStrings(HealBot_Options_IconsSkinsFrame)
	self:applySkin(HealBot_Options_IconsSkinsFrame, nil)
	
	self:keepFontStrings(HealBot_Options_CustomCureFrame)
	self:applySkin(HealBot_Options_CustomCureFrame, nil)
	self:keepFontStrings(HealBot_Options_WarningCureFrame)
	self:applySkin(HealBot_Options_WarningCureFrame, nil)
	
	self:keepFontStrings(HealBot_Options_CDebuffTxt1)
	self:keepFontStrings(HealBot_Options_CureDispelCleanse)
	self:applySkin(HealBot_Options_CureDispelCleanse, nil)	
	self:keepFontStrings(HealBot_Options_Skins)
	self:keepFontStrings(HealBot_Options_ShareSkin)
	self:keepFontStrings(HealBot_Options_ActionAnchor)
	self:keepFontStrings(HealBot_Options_ActionBarsAnchor)
	self:keepFontStrings(HealBot_Options_GenFrame)
	self:applySkin(HealBot_Options_GenFrame, nil)
	self:keepFontStrings(HealBot_Options_ProtSkinsFrame)
	self:applySkin(HealBot_Options_ProtSkinsFrame, nil)
	self:keepFontStrings(HealBot_Options_CrashProtPanel)
	self:applySkin(HealBot_Options_CrashProtPanel, nil)
	self:keepFontStrings(HealBot_Options_CombatProtPanel)
	self:applySkin(HealBot_Options_CombatProtPanel, nil)	
	self:keepFontStrings(HealBot_Options_MouseWheelPanel)
	self:applySkin(HealBot_Options_MouseWheelPanel, nil)	
	self:keepFontStrings(HealBot_Options_TestButtonsPanel)
	self:applySkin(HealBot_Options_TestButtonsPanel, nil)	
	
	
	self:moveObject(HealBot_Options_ActionBarsCombo, nil, nil, "+", 5)
	self:moveObject(HealBot_Options_CastButton, nil, nil, "+", 5)
	self:moveObject(HealBot_ComboButtons_ButtonText, nil, nil, "+", 12)
	self:moveObject(HealBot_ComboButtons_Button1, nil, nil, "+", 12)
	self:moveObject(HealBot_AutoTarget_ButtonText, nil, nil, "+", 15)
	self:moveObject(HealBot_AutoTrinket_ButtonText, nil, nil, "+", 15)
	self:moveObject(HealBot_Options_Click, nil, nil, "+", 15)
	self:moveObject(HealBot_Options_MouseWheelModKey, nil, nil, "-", 1)
	self:moveObject(HealBot_Options_NewCDebuff, nil, nil, "+", 4)
	self:moveObject(HealBot_Options_NewSkin, nil, nil, "+", 4)
	self:moveObject(HealBot_Options_NewCDebuffBtn, "-", 5, nil, nil)
	self:moveObject(HealBot_Options_NewSkinb, "-", 5, nil, nil)
	self:moveObject(HealBot_Options_NotifyHealMsg, nil, nil, "+", 2)
	self:moveObject(HealBot_Options_NotifyOtherMsg, nil, nil, "+", 3)
			
	self:skinEditBox(HealBot_Options_NotifyChan, {9})
	self:skinEditBox(HealBot_Options_NotifyOtherMsg, {9,10})
	self:skinEditBox(HealBot_Options_NotifyHealMsg, {9,10})
	self:skinEditBox(HealBot_Options_Click, {9})
	self:skinEditBox(HealBot_Options_Shift, {9})
	self:skinEditBox(HealBot_Options_Ctrl, {9})
	self:skinEditBox(HealBot_Options_Alt, {9})
	self:skinEditBox(HealBot_Options_CtrlShift, {9})
	self:skinEditBox(HealBot_Options_AltShift, {9})
	self:skinEditBox(HealBot_Options_CtrlAlt, {9})
	self:skinEditBox(HealBot_Options_NewCDebuff, {9,10})
	self:skinEditBox(HealBot_Options_NewSkin, {9,10})
	self:skinEditBox(HealBot_Options_CrashProtEditBox, {9})
	
	self:keepFontStrings(HealBot_Options)
	self:applySkin(HealBot_Options, true)
end
