local _, aObj = ...
if not aObj:isAddonEnabled("RepHelper")
and not aObj:isAddonEnabled("RepHelper_Classic")
then
	return
end
local _G = _G

local addonName = aObj:isAddonEnabled("RepHelper") and "RepHelper" or "RepHelper_Classic"

aObj.addonsToSkin[addonName] = function(self) -- v 8.3.0.1-release/1.13.4.1-release

	if self.modBtnBs then
		self:addButtonBorder{obj=_G.RPH_OptionsButton, ofs=-2, x1=1, clr="gold"}
	end
	if self.modChkBtns then
		self:skinCheckButton{obj=_G.RPH_OrderByStandingCheckBox}
	end

	self:SecureHookScript(_G.RPH_OptionsFrame, "OnShow", function(this)

		self:addSkinFrame{obj=this, ft="a", kfs=true, nb=true, hdr=true, x1=-1}
		if self.modBtns then
			self:skinCloseButton{obj=_G.RPH_OptionsFrameClose}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.RPH_EnableMissingBox}
			self:skinCheckButton{obj=_G.RPH_ExtendDetailsBox}
			self:skinCheckButton{obj=_G.RPH_GainToChatBox}
			self:skinCheckButton{obj=_G.RPH_ShowPreviewRepBox}
			self:skinCheckButton{obj=_G.RPH_SwitchFactionBarBox}
			self:skinCheckButton{obj=_G.RPH_SilentSwitchBox}
			if _G.RPH_NoGuildGainBox then
				self:skinCheckButton{obj=_G.RPH_NoGuildGainBox}
				self:skinCheckButton{obj=_G.RPH_NoGuildSwitchBox}
				self:skinCheckButton{obj=_G.RPH_EnableParagonBarBox}
			end
		end

		if addonName == "RepHelper_Classic" then
			self:moveObject{obj=this, x=1, y=-3}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.RPH_ReputationDetailFrame, "OnShow", function(this)

		self:skinSlider{obj=_G.RPH_UpdateListScrollFrame.ScrollBar}
		self:addSkinFrame{obj=this, ft="a", kfs=true, nb=true, hdr=true, x1=-1}
		if self.modBtns then
			 self:skinCloseButton{obj=_G.RPH_ReputationDetailCloseButton}
			 self:skinStdButton{obj=_G.RPH_ShowAllButton}
			 self:skinStdButton{obj=_G.RPH_ShowNoneButton}
			 self:skinStdButton{obj=_G.RPH_ExpandButton}
			 self:skinStdButton{obj=_G.RPH_CollapseButton}
			 self:skinStdButton{obj=_G.RPH_SupressNoneFactionButton}
			 self:skinStdButton{obj=_G.RPH_SupressNoneGlobalButton}
			 self:skinStdButton{obj=_G.RPH_ClearSessionGainButton}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.RPH_ReputationDetailAtWarCheckBox}
			self:skinCheckButton{obj=_G.RPH_ReputationDetailInactiveCheckBox}
			self:skinCheckButton{obj=_G.RPH_ReputationDetailMainScreenCheckBox}
			self:skinCheckButton{obj=_G.RPH_ShowQuestButton}
			self:skinCheckButton{obj=_G.RPH_ShowInstancesButton}
			self:skinCheckButton{obj=_G.RPH_ShowMobsButton}
			self:skinCheckButton{obj=_G.RPH_ShowItemsButton}
			self:skinCheckButton{obj=_G.RPH_ShowGeneralButton}
			if _G.RPH_ShowDarkmoonFaireButto then
				self:skinCheckButton{obj=_G.RPH_ShowDarkmoonFaireButton}
			end
		end

		if addonName == "RepHelper_Classic" then
			self:moveObject{obj=this, x=1, y=-3}
		end

		self:Unhook(this, "OnShow")
	end)

	if self.modChkBtns then
		self.RegisterCallback(addonName, "IOFPanel_Before_Skinning", function(this, panel)
			aObj:Debug(addonName .. " IOFPanel_Before_Skinning: [%s, %s]", panel, panel.name)
			if panel.name ~= addonName then return end
			self:skinCheckButton{obj=_G.RPH_OptionEnableMissingCB}
			self:skinCheckButton{obj=_G.RPH_OptionExtendDetailsCB}
			self:skinCheckButton{obj=_G.RPH_OptionGainToChatCB}
			self:skinCheckButton{obj=_G.RPH_OptionShowPreviewRepCB}
			self:skinCheckButton{obj=_G.RPH_OptionSwitchFactionBarCB}
			self:skinCheckButton{obj=_G.RPH_OptionSilentSwitchCB}
			self.iofSkinnedPanels[panel] = true
			self.UnregisterCallback(addonName, "IOFPanel_Before_Skinning")
		end)
	end

end
