local _, aObj = ...
if not aObj:isAddonEnabled("ModernCharacterFrame") then return end
local _G = _G

aObj.addonsToSkin.ModernCharacterFrame = function(self) -- v 0.8.2

	local y2Ofs = 72
	self:SecureHook("MCF_CharacterFrame_OnShow", function(this)
		self:removeInset(_G.CharacterFrame.InsetRight)
		_G.CharacterModelFrame:DisableDrawLayer("BACKGROUND")
		_G.CharacterModelFrame:DisableDrawLayer("BORDER")
		_G.CharacterModelFrame:DisableDrawLayer("OVERLAY")
		_G.PaperDollFrame.Sidebar.DecorLeft:SetAlpha(0)
		_G.PaperDollFrame.Sidebar.DecorRight:SetAlpha(0)
		for i = 1, #_G.MCF_PAPERDOLL_SIDEBARS do
			local tab = _G["PaperDollSidebarTab" .. i]
			tab.TabBg:SetAlpha(0)
			tab.Hider:SetAlpha(0)
			-- use a button border to indicate the active tab
			self.modUIBtns:addButtonBorder{obj=tab, relTo=tab.Icon, ofs=i==1 and 3 or 1, clr="selected"} -- use module function here to force creation
			tab.sbb:SetShown(_G[MCF_PAPERDOLL_SIDEBARS[i].frame]:IsShown())
		end
		-- hook this to manage the active tab
		self:SecureHook("MCF_PaperDollFrame_UpdateSidebarTabs", function()
			for i = 1, #_G.MCF_PAPERDOLL_SIDEBARS do
				local tab = _G["PaperDollSidebarTab" .. i]
				if tab
				and tab.sbb
				then
					tab.sbb:SetShown(_G[MCF_PAPERDOLL_SIDEBARS[i].frame]:IsShown())
				end
			end
		end)
		self:skinObject("scrollbar", {obj=_G.CharacterFrame.StatsPane.ScrollBar, x1=1, x2=4})
		local function skinStats()
			local cIdx = 1
			while _G["CharacterStatsPaneCategory" .. cIdx] do
				local cat = _G["CharacterStatsPaneCategory" .. cIdx]
				cat.BgTop:SetTexture(nil)
				cat.BgMiddle:SetTexture(nil)
				cat.BgBottom:SetTexture(nil)
				cat.BgMinimized:SetTexture(nil)
				local sIdx = 1
				while _G["CharacterStatsPaneCategory" .. cIdx .. "Stat" .. sIdx] do
					local stat = _G["CharacterStatsPaneCategory" .. cIdx .. "Stat" .. sIdx]
					if stat.Bg then
						stat.Bg:SetTexture(nil)
					end
					sIdx = sIdx + 1
				end
				cIdx = cIdx + 1
			end
		end
		self:SecureHook("MCF_PaperDollFrame_UpdateStats", function()
			skinStats()
		end)
		skinStats()
		self:skinObject("slider", {obj=_G.PaperDollTitlesPane.scrollBar})
		for _, btn in _G.pairs(_G.PaperDollTitlesPane.buttons) do
			btn:DisableDrawLayer("BACKGROUND")
		end
		self:skinObject("slider", {obj=_G.PaperDollEquipmentManagerPane.scrollBar})
		for _, btn in _G.pairs(_G.PaperDollEquipmentManagerPane.buttons) do
			btn:DisableDrawLayer("BACKGROUND")
			btn.SpecRing:SetTexture(nil)
			if self.modBtnBs then
				self:addButtonBorder{obj=btn, relTo=btn.icon, clr="grey"}
			end
		end

		if self.modBtns then
			self:skinStdButton{obj=_G.PaperDollEquipmentManagerPane.EquipSet, schk=true}
			self:skinStdButton{obj=_G.PaperDollEquipmentManagerPane.SaveSet, schk=true}
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.CharacterFrame.ExpandButton, clr="gold", ofs=-1, y1=-2, x2=-2}
		end

		-- adjust width of CharacterFrame skin frame if required
		_G.C_Timer.After(0.05, function()
			local _, _, _, xOfs, _ = _G.CharacterFrame.sf:GetPoint(2)
			if _G.CharacterFrame.Expanded
			and xOfs == -31
			then
				_G.CharacterFrame.sf:SetPoint("BOTTOMRIGHT", _G.CharacterFrame, "BOTTOMRIGHT", 171, y2Ofs)
			else
				_G.CharacterFrame.sf:SetPoint("BOTTOMRIGHT", _G.CharacterFrame, "BOTTOMRIGHT", -31, y2Ofs)
			end
		end)

		self:Unhook(this, "MCF_CharacterFrame_OnShow")
	end)

	self:SecureHookScript(_G.MCF_GearManagerDialogPopup, "OnShow", function(this)
		self:skinObject("editbox", {obj=_G.MCF_GearManagerDialogPopupEditBox})
		self:skinObject("slider", {obj=_G.MCF_GearManagerDialogPopupScrollFrame.ScrollBar, rpTex="background"})
		self:skinObject("frame", {obj=this, kfs=true, ofs=-4, x1=3})
		if self.modBtns then
			self:skinStdButton{obj=_G.MCF_GearManagerDialogPopupCancel}
			self:skinStdButton{obj=_G.MCF_GearManagerDialogPopupOkay, schk=true}
		end
		for _, btn in _G.pairs(this.buttons) do
			btn:DisableDrawLayer("BACKGROUND")
			if self.modBtnBs then
				self:addButtonBorder{obj=btn, relTo=btn.icon, clr="grey", ca=0.85}
			end
		end

		self:Unhook(this, "OnShow")
	end)

	-- hook these to adjust width of CharacterFrame skin frame
	self:SecureHook("MCF_CharacterFrame_Collapse", function()
		if _G.CharacterFrame.sf then
			_G.CharacterFrame.sf:SetPoint("BOTTOMRIGHT", _G.CharacterFrame, "BOTTOMRIGHT", -31, y2Ofs)
		end

	end)
	self:SecureHook("MCF_CharacterFrame_Expand", function()
		if _G.CharacterFrame.sf then
			_G.CharacterFrame.sf:SetPoint("BOTTOMRIGHT", _G.CharacterFrame, "BOTTOMRIGHT", 171, y2Ofs)
		end

	end)

	self.RegisterCallback("ModernCharacterFrame", "IOFPanel_Before_Skinning", function(_, panel)
		aObj:Debug("IOFPanel_Before_Skinning: [%s, %s]", panel.name)
		if panel.name ~= "Modern Character Frame" then return end
		self.iofSkinnedPanels[panel] = true
		self:skinObject("dropdown", {obj=_G.MCF_OptionsFrameTacoTipIntegrationGSStatTypeDropDown})
		if self.modBtns then
			self:skinStdButton{obj=_G.MCF_OptionsFrameResetButton}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.MCF_OptionsFrameItemColorButton}
			self:skinCheckButton{obj=_G.MCF_OptionsFrameRepairCost}
			self:skinCheckButton{obj=_G.MCF_OptionsFrameTacoTipIntegrationEnableButton}
			self:skinCheckButton{obj=_G.MCF_OptionsFrameTacoTipIntegrationGSColorEnableButton}
		end

		self.UnregisterCallback("ModernCharacterFrame", "IOFPanel_Before_Skinning")
	end)

end
