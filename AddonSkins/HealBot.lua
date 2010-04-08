if not Skinner:isAddonEnabled("HealBot") then return end
-- many thanks to acirac for the original skin

function Skinner:HealBot() -- version 3.3.3.1
	if not self.db.profile.Tooltips.skin then return end

-->>--	Tooltips
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then
			HealBot_ScanTooltip:SetBackdrop(self.Backdrop[1])
			HealBot_Tooltip:SetBackdrop(self.Backdrop[1])
		end
		self:SecureHookScript(HealBot_ScanTooltip, "OnShow", function(this)
			self:skinTooltip(this)
		end)
		self:SecureHookScript(HealBot_Tooltip, "OnShow", function(this)
			self:skinTooltip(this)
		end)
	end

-- Tabs
	for i = 1, HealBot_Options.numTabs do
		local tabObj = _G["HealBot_OptionsTab"..i]
		self:keepRegions(tabObj, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		self:addSkinFrame{obj=tabObj, ft=ftype, noBdr=self.isTT, x1=6, y1=0, x2=-6, y2=2}
		local tabSF = self.skinFrame[tabObj]
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end

	if self.isTT then
		-- hook this to change the texture for the Active and Inactive tabs
		self:SecureHook("HealBot_Options_ShowPanel",function(...)
			for i = 1, HealBot_Options.numTabs do
				local tabSF = self.skinFrame[_G["HealBot_OptionsTab"..i]]
				if i == HealBot_Options.selectedTab then
					self:setActiveTab(tabSF)
				else
					self:setInactiveTab(tabSF)
				end
			end
		end)
	end

-->>-- Options Frame
	self:addSkinFrame{obj=HealBot_Options, kfs=true, hdr=true}

-->>-- Options Panel1 (General)
	self:addSkinFrame{obj=HealBot_Options_GenFrame}
	self:skinDropDown{obj=HealBot_Options_HealCommMethod}
	self:skinDropDown{obj=HealBot_Options_EmergencyFClass}
	self:addSkinFrame{obj=HealBot_Options_EmergLFrame}

-->>-- Options Panel2 (Spells)
	self:skinDropDown{obj=HealBot_Options_ActionBarsCombo}
	self:moveObject{obj=HealBot_Options_ActionBarsCombo, y=5}
	self:skinDropDown{obj=HealBot_Options_CastButton}
	self:skinEditBox{obj=HealBot_Options_Click, regs={9}}
	self:moveObject{obj=HealBot_Options_Click, y=10}
	self:moveObject{obj=HealBot_AutoTarget_ButtonText, y=10}
	self:moveObject{obj=HealBot_AutoTrinket_ButtonText, y=10}
	self:skinEditBox{obj=HealBot_Options_Shift, regs={9}}
	self:skinEditBox{obj=HealBot_Options_Ctrl, regs={9}}
	self:skinEditBox{obj=HealBot_Options_Alt, regs={9}}
	self:skinEditBox{obj=HealBot_Options_CtrlShift, regs={9}}
	self:skinEditBox{obj=HealBot_Options_AltShift, regs={9}}
	self:skinDropDown{obj=HealBot_Options_ButtonCastMethod}
	self:moveObject{obj=HealBot_Options_ButtonCastMethod, y=6}
	self:addSkinFrame{obj=HealBot_Options_KeysFrame}
	self:addSkinFrame{obj=HealBot_Options_DisabledBarPanel}
	-- Select Spells subpanel
	self:skinDropDown{obj=HealBot_Options_SelectHealSpellsCombo}
	self:skinDropDown{obj=HealBot_Options_SelectOtherSpellsCombo}
	self:skinDropDown{obj=HealBot_Options_SelectMacrosCombo}
	self:skinDropDown{obj=HealBot_Options_SelectItemsCombo}
	self:skinDropDown{obj=HealBot_Options_SelectCmdsCombo}
	self:addSkinFrame{obj=HealBot_Options_SelectSpellsFrame}

-->>-- Options Panel 3 (Skins)
	self:skinDropDown{obj=HealBot_Options_Skins}
	self:skinEditBox{obj=HealBot_Options_NewSkin, regs={9, 10}}
	self:moveObject{obj=HealBot_Options_NewSkin, y=4}
	self:moveObject{obj=HealBot_Options_NewSkinb, x=-5}
	self:skinDropDown{obj=HealBot_Options_ShareSkin}
	-- General subpanel
	self:skinDropDown{obj=HealBot_Options_ActionAnchor}
	self:skinDropDown{obj=HealBot_Options_BarHealthNumFormatAggro}
	self:skinDropDown{obj=HealBot_Options_SkinPartyRaidDefault}
	self:addSkinFrame{obj=HealBot_Options_GeneralSkinsFrame}
	-- Healing subpanel
	self:skinDropDown{obj=HealBot_Options_AggroAlertLevel}
	self:skinDropDown{obj=HealBot_Options_EmergencyFilter}
	self:skinDropDown{obj=HealBot_Options_ExtraSort}
	self:skinDropDown{obj=HealBot_Options_ExtraSubSort}
	self:addSkinFrame{obj=HealBot_Options_HealingSkinsFrame}
	-- Inc. Heals subpanel
	self:addSkinFrame{obj=HealBot_Options_IncHealsSkinsFrame}
	-- Chat subpanel
	self:skinEditBox{obj=HealBot_Options_NotifyChan, regs={9}}
	self:skinEditBox{obj=HealBot_Options_NotifyHealMsg, regs={9, 10}}
	self:moveObject{obj=HealBot_Options_NotifyHealMsg, y=2}
	self:skinEditBox{obj=HealBot_Options_NotifyOtherMsg, regs={9, 10}}
	self:moveObject{obj=HealBot_Options_NotifyOtherMsg, y=3}
	self:addSkinFrame{obj=HealBot_Options_ChatSkinsFrame}
	-- Headers subpanel
	self:addSkinFrame{obj=HealBot_Options_HeadersSkinsFrame}
	-- Bars subpanel
	self:addSkinFrame{obj=HealBot_Options_BarsSkinsFrame}
	-- Text subpanel
	self:skinDropDown{obj=HealBot_Options_BarHealthIncHeal}
	self:skinDropDown{obj=HealBot_Options_BarHealthType}
	self:skinDropDown{obj=HealBot_Options_BarHealthNumFormat1}
	self:skinDropDown{obj=HealBot_Options_BarHealthNumFormat2}
	self:addSkinFrame{obj=HealBot_Options_TextSkinsFrame}
	-- Icons subpanel
	self:skinDropDown{obj=HealBot_Options_FilterHoTctl}
	self:skinDropDown{obj=HealBot_Options_Class_HoTctlName}
	self:skinDropDown{obj=HealBot_Options_Class_HoTctlAction}
	self:addSkinFrame{obj=HealBot_Options_IconsSkinsFrame}

-->>-- Options Panel4 (Cure)
	-- Debuff subpanel
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
	-- Custom subpanel
	self:skinDropDown{obj=HealBot_Options_CDebuffTxt1}
	self:skinEditBox{obj=HealBot_Options_NewCDebuff, regs={9, 10}}
	self:moveObject{obj=HealBot_Options_NewCDebuff, y=4}
	self:moveObject{obj=HealBot_Options_NewCDebuffBtn, x=-5}
	self:skinDropDown{obj=HealBot_Options_CDCPriorityC}
	self:addSkinFrame{obj=HealBot_Options_CustomCureFrame}
	-- Warning subpanel
	self:skinDropDown{obj=HealBot_Options_CDCWarnRange1}
	self:skinDropDown{obj=HealBot_Options_CDCWarnRange2}
	self:skinDropDown{obj=HealBot_Options_CDCWarnRange3}
	self:skinDropDown{obj=HealBot_Options_CDCWarnRange4}
	self:addSkinFrame{obj=HealBot_Options_WarningCureFrame}

-->>-- Options Panel5
	for i = 1, 10 do
		self:skinDropDown{obj=_G["HealBot_Options_BuffTxt"..i]}
		self:skinDropDown{obj=_G["HealBot_Options_BuffGroups"..i]}
	end
	self:addSkinFrame{obj=HealBot_Options_BuffsPanel}
	self:addSkinFrame{obj=HealBot_Options_BuffTimers}

-->>-- Options Panel 6 (Tips)
	self:skinDropDown{obj=HealBot_Options_TooltipPos}
	self:addSkinFrame{obj=HealBot_Options_TooltipsPanel}

-->>-- Error frame
	self:addSkinFrame{obj=HealBot_Error}

end
