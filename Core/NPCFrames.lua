local _, aObj = ...

local _G = _G

local ftype = "n"

aObj.blizzFrames[ftype].GuildRegistrar = function(self)
	if not self.prdb.GuildRegistrar or self.initialized.GuildRegistrar then return end
	self.initialized.GuildRegistrar = true

	self:SecureHookScript(_G.GuildRegistrarFrame, "OnShow", function(this)
		self:keepFontStrings(_G.GuildRegistrarGreetingFrame)
		if self.isRtl then
			_G.AvailableServicesText:SetTextColor(self.HT:GetRGB())
		else
			_G.GuildAvailableServicesText:SetTextColor(self.HT:GetRGB())
		end
		self:getRegion(_G.GuildRegistrarButton1, 3):SetTextColor(self.BT:GetRGB())
		self:getRegion(_G.GuildRegistrarButton2, 3):SetTextColor(self.BT:GetRGB())
		_G.GuildRegistrarPurchaseText:SetTextColor(self.BT:GetRGB())
		self:skinObject("editbox", {obj=_G.GuildRegistrarFrameEditBox, fType=ftype})
		if self.isRtl then
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true})
		else
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, x1=10, y1=-17, x2=-29, y2=62})
		end
		if self.modBtns then
			self:skinStdButton{obj=_G.GuildRegistrarFrameGoodbyeButton}
			self:skinStdButton{obj=_G.GuildRegistrarFrameCancelButton}
			self:skinStdButton{obj=_G.GuildRegistrarFramePurchaseButton}
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].MerchantFrame = function(self)
	if not self.prdb.MerchantFrame or self.initialized.MerchantFrame then return end
	self.initialized.MerchantFrame = true

	self:SecureHookScript(_G.MerchantFrame, "OnShow", function(this)
		self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true})
		self:removeInset(_G.MerchantMoneyInset)
		_G.MerchantMoneyBg:DisableDrawLayer("BACKGROUND")
		if self.isRtl then
			self:skinObject("dropdown", {obj=_G.MerchantFrameLootFilter, fType=ftype})
			self:removeInset(_G.MerchantExtraCurrencyInset)
			_G.MerchantExtraCurrencyBg:DisableDrawLayer("BACKGROUND")
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true, y2=-3})
		else
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, cb=true, x2=1, y2=-3})
		end
		if self.modBtnBs then
			self:removeRegions(_G.MerchantPrevPageButton, {2})
			self:removeRegions(_G.MerchantNextPageButton, {2})
			self:addButtonBorder{obj=_G.MerchantPrevPageButton, ofs=-2, y1=-3, x2=-3}
			self:addButtonBorder{obj=_G.MerchantNextPageButton, ofs=-2, y1=-3, x2=-3}
			self:SecureHook("MerchantFrame_UpdateMerchantInfo", function()
				self:clrPNBtns("Merchant")
			end)
		end
		-- Items/Buyback Items
		for i = 1, _G.math.max(_G.MERCHANT_ITEMS_PER_PAGE, _G.BUYBACK_ITEMS_PER_PAGE) do
			_G["MerchantItem" .. i .. "NameFrame"]:SetTexture(nil)
			if not self.modBtnBs then
				_G["MerchantItem" .. i .. "SlotTexture"]:SetTexture(self.tFDIDs.esTex)
			else
				_G["MerchantItem" .. i .. "SlotTexture"]:SetTexture(nil)
				self:addButtonBorder{obj=_G["MerchantItem" .. i].ItemButton, ibt=true}
			end
		end
		_G.MerchantBuyBackItemNameFrame:SetTexture(nil)
		if self.modBtnBs then
			_G.MerchantBuyBackItemSlotTexture:SetTexture(nil)
			self:addButtonBorder{obj=_G.MerchantBuyBackItem.ItemButton, ibt=true}
			-- remove surrounding border (diff=0.01375)
			self:getRegion(_G.MerchantRepairItemButton, 1):SetTexCoord(0.01375, 0.2675, 0.01375, 0.54875)
			_G.MerchantRepairAllIcon:SetTexCoord(0.295, 0.54875, 0.01375, 0.54875)
			_G.MerchantGuildBankRepairButtonIcon:SetTexCoord(0.57375, 0.83, 0.01375, 0.54875)
			self:addButtonBorder{obj=_G.MerchantRepairAllButton, fType=ftype, clr="gold", ca=0.5}
			self:addButtonBorder{obj=_G.MerchantRepairItemButton, fType=ftype, clr="gold", ca=0.5}
			self:addButtonBorder{obj=_G.MerchantGuildBankRepairButton, fType=ftype, schk=true, clr="gold", ca=0.5}
			self:SecureHook("MerchantFrame_UpdateCanRepairAll", function()
				self:clrBtnBdr(_G.MerchantRepairAllButton, "gold", 0.5)
			end)
			if self.isRtl then
				self:SecureHook("MerchantFrame_UpdateGuildBankRepair", function()
					self:clrBtnBdr(_G.MerchantGuildBankRepairButton, "gold", 0.5)
				end)
			end
		else
			_G.MerchantBuyBackItemSlotTexture:SetTexture(self.tFDIDs.esTex)
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].Petition = function(self)
	if not self.prdb.Petition or self.initialized.Petition then return end
	self.initialized.Petition = true

	self:SecureHookScript(_G.PetitionFrame, "OnShow", function(this)
		_G.PetitionFrameCharterTitle:SetTextColor(self.HT:GetRGB())
		_G.PetitionFrameCharterName:SetTextColor(self.BT:GetRGB())
		_G.PetitionFrameMasterTitle:SetTextColor(self.HT:GetRGB())
		_G.PetitionFrameMasterName:SetTextColor(self.BT:GetRGB())
		_G.PetitionFrameMemberTitle:SetTextColor(self.HT:GetRGB())
		for i = 1, 9 do
			_G["PetitionFrameMemberName" .. i]:SetTextColor(self.BT:GetRGB())
		end
		_G.PetitionFrameInstructions:SetTextColor(self.BT:GetRGB())
		if self.isRtl then
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true})
		else
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, x1=10, y1=-17, x2=-29, y2=62})
		end
		if self.modBtns then
			self:skinStdButton{obj=_G.PetitionFrameCancelButton}
			self:skinStdButton{obj=_G.PetitionFrameSignButton}
			self:skinStdButton{obj=_G.PetitionFrameRequestButton, x2=-1}
			self:skinStdButton{obj=_G.PetitionFrameRenameButton, x1=1, x2=-1}
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].QuestFrame = function(self)
	if not self.prdb.QuestFrame or self.initialized.QuestFrame then return end
	self.initialized.QuestFrame = true

	self:SecureHookScript(_G.QuestFrame, "OnShow", function(this)
		self:RawHook("QuestFrame_SetTitleTextColor", function(fontString, _)
			fontString:SetTextColor(self.HT:GetRGB())
		end, true)
		self:RawHook("QuestFrame_SetTextColor", function(fontString, _)
			fontString:SetTextColor(self.BT:GetRGB())
		end, true)

		if self.isRtl then
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true})
		else
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, x1=10, y1=-18, x2=-29, y2=65})
		end

		--	Reward Panel
		self:keepFontStrings(_G.QuestFrameRewardPanel)
		self:skinObject("slider", {obj=_G.QuestRewardScrollFrame.ScrollBar, fType=ftype, rpTex="artwork"})

		--	Progress Panel
		self:keepFontStrings(_G.QuestFrameProgressPanel)
		_G.QuestProgressTitleText:SetTextColor(self.HT:GetRGB())
		_G.QuestProgressText:SetTextColor(self.BT:GetRGB())
		_G.QuestProgressRequiredMoneyText:SetTextColor(self.BT:GetRGB())
		_G.QuestProgressRequiredItemsText:SetTextColor(self.HT:GetRGB())
		self:skinObject("slider", {obj=_G.QuestProgressScrollFrame.ScrollBar, fType=ftype, rpTex="artwork"})
		local btnName
		for i = 1, _G.MAX_REQUIRED_ITEMS do
			btnName = "QuestProgressItem" .. i
			_G[btnName .. "NameFrame"]:SetTexture(nil)
			if self.modBtns then
				 self:addButtonBorder{obj=_G[btnName], libt=true, clr="grey"}
			end
		end
		self:SecureHook("QuestFrameProgressItems_Update", function()
			local br, bg, bb = self.BT:GetRGB()
			local r, g ,b = _G.QuestProgressRequiredMoneyText:GetTextColor()
			-- if red colour is less than 0.2 then it needs to be coloured
			if r < 0.2 then
				_G.QuestProgressRequiredMoneyText:SetTextColor(br - r, bg - g, bb - b)
			end
		end)

		--	Detail Panel
		self:keepFontStrings(_G.QuestFrameDetailPanel)
		self:skinObject("slider", {obj=_G.QuestDetailScrollFrame.ScrollBar, fType=ftype, rpTex="artwork"})

		--	Greeting Panel
		self:keepFontStrings(_G.QuestFrameGreetingPanel)
		self:keepFontStrings(_G.QuestGreetingScrollChildFrame) -- hide Horizontal Break texture
		self:skinObject("slider", {obj=_G.QuestGreetingScrollFrame.ScrollBar, fType=ftype, rpTex="artwork"})
		if _G.QuestFrameGreetingPanel:IsShown() then
			_G.GreetingText:SetTextColor(self.BT:GetRGB())
			_G.CurrentQuestsText:SetTextColor(self.HT:GetRGB())
			_G.AvailableQuestsText:SetTextColor(self.HT:GetRGB())
		end
		if not self.isRtl then
			for i = 1, _G.MAX_NUM_QUESTS do
				self:hookQuestText(_G["QuestTitleButton" .. i])
			end
			-- force recolouring of quest text
			self:checkShown(_G.QuestFrameGreetingPanel)
		end

		if self.modBtns then
			self:SecureHook(_G.QuestFrameCloseButton, "Disable", function(bObj, _)
				self:clrBtnBdr(bObj)
			end)
			self:SecureHook(_G.QuestFrameCloseButton, "Enable", function(bObj, _)
				self:clrBtnBdr(bObj)
			end)
			self:skinStdButton{obj=_G.QuestFrameCompleteQuestButton, fType=ftype, schk=true}
			self:skinStdButton{obj=_G.QuestFrameGoodbyeButton, fType=ftype}
			self:skinStdButton{obj=_G.QuestFrameCompleteButton, fType=ftype}
			self:SecureHookScript(_G.QuestFrameProgressPanel, "OnShow", function(_)
				self:clrBtnBdr(_G.QuestFrameCompleteButton)
			end)
			self:skinStdButton{obj=_G.QuestFrameDeclineButton, fType=ftype}
			self:skinStdButton{obj=_G.QuestFrameAcceptButton, fType=ftype, schk=true}
			self:skinStdButton{obj=_G.QuestFrameGreetingGoodbyeButton, fType=ftype}
			if not self.isRtl then
				self:skinStdButton{obj=_G.QuestFrameCancelButton, fType=ftype}
			end
		end

		self:Unhook(this, "OnShow")
	end)

	if self.isRtl then
		if not (self:isAddonEnabled("Quester")
		and _G.QuesterDB.gossipColor)
		then
			-- hook this to colour quest button text
			self:RawHook(_G.QuestFrameGreetingPanel.titleButtonPool, "Acquire", function(this)
				local btn = self.hooks[this].Acquire(this)
				self:hookQuestText(btn)
				return btn
			end, true)
		end
		self:skinObject("frame", {obj=_G.QuestModelScene, fType=ftype, kfs=true, x1=-5, x2=5, y2=-81})
	else
		self:skinObject("frame", {obj=_G.QuestNPCModel, fType=ftype, kfs=true, x1=-5, x2=5, y2=-81})
	end
	self:keepFontStrings(_G.QuestNPCModelTextFrame)
	self:skinObject("slider", {obj=_G.QuestNPCModelTextScrollFrame.ScrollBar, fType=ftype})

end

aObj.blizzFrames[ftype].QuestInfo = function(self)
	if not self.prdb.QuestInfo or self.initialized.QuestInfo then return end
	self.initialized.QuestInfo = true

	local function skinRewards(frame)
		if frame.Header:IsObjectType("FontString") then -- QuestInfoRewardsFrame
			frame.Header:SetTextColor(aObj.HT:GetRGB())
		end
		frame.ItemChooseText:SetTextColor(aObj.BT:GetRGB())
		frame.ItemReceiveText:SetTextColor(aObj.BT:GetRGB())
		if not self.isClsc then
			frame.PlayerTitleText:SetTextColor(aObj.BT:GetRGB())
		end
		if frame.XPFrame.ReceiveText then -- QuestInfoRewardsFrame
			frame.XPFrame.ReceiveText:SetTextColor(aObj.BT:GetRGB())
		end
		-- RewardButtons
		for _, btn in _G.pairs(frame.RewardButtons) do
			btn.NameFrame:SetTexture(nil)
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=btn, libt=true}
				aObj:clrButtonFromBorder(btn)
			end
		end
		-- SpellReward
		for spellBtn in frame.spellRewardPool:EnumerateActive() do
			spellBtn.NameFrame:SetTexture(nil)
			spellBtn:DisableDrawLayer("OVERLAY")
			if aObj.modBtnBs then
				 aObj:addButtonBorder{obj=spellBtn, relTo=spellBtn.Icon, clr="grey"}
			end
		end
		-- FollowerReward
		for flwrBtn in frame.followerRewardPool:EnumerateActive() do
			flwrBtn.BG:SetTexture(nil)
			flwrBtn.PortraitFrame.PortraitRing:SetTexture(nil)
			flwrBtn.PortraitFrame.LevelBorder:SetAlpha(0) -- texture changed
			if flwrBtn.PortraitFrame.PortraitRingCover then
				flwrBtn.PortraitFrame.PortraitRingCover:SetTexture(nil)
			end
		end
		for spellLine in frame.spellHeaderPool:EnumerateActive() do
			spellLine:SetVertexColor(aObj.BT:GetRGB())
		end
		if self.isRtl then
			for rep in frame.reputationRewardPool:EnumerateActive() do
				rep.NameFrame:SetTexture(nil)
				if aObj.modBtnBs then
					aObj:addButtonBorder{obj=rep, fType=ftype, relTo=rep.Icon, reParent={rep.RewardAmount}, clr="grey"}
				end
			end
		end
	end
	local function updateQIDisplay(_)
		local br, bg, bb = aObj.BT:GetRGB()
		-- headers
		_G.QuestInfoTitleHeader:SetTextColor(aObj.HT:GetRGB())
		_G.QuestInfoDescriptionHeader:SetTextColor(aObj.HT:GetRGB())
		_G.QuestInfoObjectivesHeader:SetTextColor(aObj.HT:GetRGB())
		-- other text
		_G.QuestInfoQuestType:SetTextColor(aObj.BT:GetRGB())
		_G.QuestInfoObjectivesText:SetTextColor(aObj.BT:GetRGB())
		_G.QuestInfoRewardText:SetTextColor(aObj.BT:GetRGB())
		local r, g, b = _G.QuestInfoRequiredMoneyText:GetTextColor()
		_G.QuestInfoRequiredMoneyText:SetTextColor(br - r, bg - g, bb - b)
		_G.QuestInfoGroupSize:SetTextColor(aObj.BT:GetRGB())
		_G.QuestInfoAnchor:SetTextColor(aObj.BT:GetRGB())
		-- remove any embedded colour codes
		local newText, upd = aObj:removeColourCodes(_G.QuestInfoDescriptionText:GetText())
		if upd then
			_G.QuestInfoDescriptionText:SetText(newText)
		end
		_G.QuestInfoDescriptionText:SetTextColor(aObj.BT:GetRGB())
		-- skin rewards
		skinRewards(_G.QuestInfoFrame.rewardsFrame)
		-- Objectives
		for _, obj in _G.pairs(_G.QuestInfoObjectivesFrame.Objectives) do
			r, g ,b = obj:GetTextColor()
			-- if red colour is less than 0.25 then it needs to be coloured
			if r < 0.25 then
				obj:SetTextColor(br - r, bg - g, bb - b)
			end
		end
		-- QuestInfoSpecialObjectives Frame
		_G.QuestInfoSpellObjectiveLearnLabel:SetTextColor(aObj.BT:GetRGB())
		_G.QuestInfoSpellObjectiveFrameNameFrame:SetTexture(nil)
		if not aObj.isClsc then
			_G.QuestInfoSpellObjectiveFrameSpellBorder:SetTexture(nil)
		end
		if aObj.modBtnBs then
			 aObj:addButtonBorder{obj=_G.QuestInfoSpellObjectiveFrame, relTo=_G.QuestInfoSpellObjectiveFrame.Icon, clr="grey"}
		end
		-- QuestInfoSeal Frame text colour
		-- TODO: can this be replaced with removeColourCodes function ?
		if _G.QuestInfoSealFrame:IsShown()
		and _G.QuestInfoSealFrame.theme
		then
			local sealText = aObj:unwrapTextFromColourCode(_G.QuestInfoSealFrame.theme.signature)
			_G.QuestInfoSealFrame.Text:SetText(aObj.HT:WrapTextInColorCode(sealText)) -- re-colour text
		end
	end

	self:SecureHook("QuestInfo_Display", function(...)
		updateQIDisplay(...)
	end)

	self:SecureHookScript(_G.QuestInfoFrame, "OnShow", function(this)
		updateQIDisplay()

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.QuestInfoTimerFrame, "OnShow", function(this)
		_G.QuestInfoTimerText:SetTextColor(self.BT:GetRGB())
		_G.QuestInfoAnchor:SetTextColor(self.BT:GetRGB())

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.QuestInfoRequiredMoneyFrame, "OnShow", function(this)
		self:SecureHook("QuestInfo_ShowRequiredMoney", function()
			local br, bg, bb = self.BT:GetRGB()
			local r, g ,b = _G.QuestInfoRequiredMoneyText:GetTextColor()
			-- if red value is less than 0.2 then it needs to be coloured
			if r < 0.2 then
				_G.QuestInfoRequiredMoneyText:SetTextColor(br - r, bg - g, bb - b)
			end
		end)

		self:Unhook(this, "OnShow")
	end)

	local function skinRewardBtns(frame)
		for _, type in _G.pairs{"HonorFrame", "ArtifactXPFrame", "WarModeBonusFrame", "SkillPointFrame", "TitleFrame"} do
			-- Classic DOESN'T have a WarModeBonusFrame
			if frame[type] then
				-- QIRF's TitleFrame DOESN'T have a NameFrame
				if frame[type].NameFrame then
					frame[type].NameFrame:SetTexture(nil)
				end
				if aObj.modBtnBs then
					aObj:addButtonBorder{obj=frame[type], sibt=true, relTo=frame[type].Icon, reParent=type == "SkillPointFrame" and {frame[type].CircleBackground, frame[type].CircleBackgroundGlow, frame[type].ValueText} or nil, clr="grey"}
				end
			end
		end
		if self.isRtl then
			for rep in frame.reputationRewardPool:EnumerateActive() do
				rep.NameFrame:SetTexture(nil)
				if aObj.modBtnBs then
					aObj:addButtonBorder{obj=rep, fType=ftype, relTo=rep.Icon, reParent={rep.RewardAmount}, clr="grey"}
				end
			end
		end
	end
	self:SecureHookScript(_G.QuestInfoRewardsFrame, "OnShow", function(this)
		skinRewardBtns(this, "libt")
		this.XPFrame.ReceiveText:SetTextColor(self.BT:GetRGB())
		self:removeRegions(_G.QuestInfoPlayerTitleFrame, {2, 3, 4}) -- NameFrame textures
		if self.isClsc then
			this.TalentFrame.ReceiveText:SetTextColor(self.BT:GetRGB())
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.MapQuestInfoRewardsFrame, "OnShow", function(this)
		skinRewardBtns(this)
		for _, type in _G.pairs{"XPFrame", "MoneyFrame"} do
			this[type].NameFrame:SetTexture(nil)
			if self.modBtnBs then
				self:addButtonBorder{obj=this[type], sibt=true, relTo=this[type].Icon, clr="grey"}
			end
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].Tabard = function(self)
	if not self.prdb.Tabard or self.initialized.Tabard then return end
	self.initialized.Tabard = true

	self:SecureHookScript(_G.TabardFrame, "OnShow", function(this)
		if self.isClsc then
			self:removeBackdrop(_G.TabardFrameCostFrame)
		else
			self:removeNineSlice(_G.TabardFrameCostFrame.NineSlice)
		end
		self:keepFontStrings(_G.TabardFrameCustomizationFrame)
		for i = 1, 5 do
			self:keepFontStrings(_G["TabardFrameCustomization" .. i])
			if self.modBtnBs then
				self:addButtonBorder{obj=_G["TabardFrameCustomization" .. i .. "LeftButton"], ofs=-3, x1=1, clr="gold"}
				self:addButtonBorder{obj=_G["TabardFrameCustomization" .. i .. "RightButton"], ofs=-3, x1=1, clr="gold"}
			end
		end
		if self.isRtl then
			self:removeInset(_G.TabardFrameMoneyInset)
			_G.TabardFrameMoneyBg:DisableDrawLayer("BACKGROUND")
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true})
		else
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, x1=10, y1=-11, x2=-32, y2=71})
		end
		if self.modBtns then
			self:skinStdButton{obj=_G.TabardFrameAcceptButton}
			self:skinStdButton{obj=_G.TabardFrameCancelButton}
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.TabardCharacterModelRotateLeftButton, ofs=-4, y2=5, clr="gold"}
			self:addButtonBorder{obj=_G.TabardCharacterModelRotateRightButton, ofs=-4, y2=5, clr="gold"}
		end

		self:Unhook(this, "OnShow")
	end)

end
