local _, aObj = ...
if not aObj:isAddonEnabled("Armory") then return end
local _G = _G
-- luacheck: ignore 631 (line is too long)

aObj.addonsToSkin.Armory = function(self) -- v 17.10.0

	self:SecureHookScript(_G.ArmoryDropDownList1, "OnShow", function(this)
		self:removeBackdrop(this.Border)
		self:removeNineSlice(this.Border)
		self:removeBackdrop(_G["ArmoryDropDownList1MenuBackdrop"])
		self:removeNineSlice(_G["ArmoryDropDownList1MenuBackdrop"].NineSlice)
		self:skinObject("frame", {obj=this, ofs=-2})

		self:Unhook(this, "OnShow")
	end)
	self:SecureHookScript(_G.ArmoryDropDownList2, "OnShow", function(this)
		self:removeBackdrop(this.Border)
		self:removeNineSlice(this.Border)
		self:removeBackdrop(_G["ArmoryDropDownList2MenuBackdrop"])
		self:removeNineSlice(_G["ArmoryDropDownList2MenuBackdrop"].NineSlice)
		self:skinObject("frame", {obj=this, ofs=-2})

		self:Unhook(this, "OnShow")
	end)

	self:SecureHook(_G.ArmoryStaticPopup, "Show", function(this)
		self:removeBackdrop(this.Border)
		self:removeNineSlice(this.Border)
		this.Border.Bg:SetTexture(nil)
		self:skinObject("frame", {obj=this, cb=true, ofs=0})
		if self.modBtns then
			self:skinStdButton{obj=this.button1}
			self:skinStdButton{obj=this.button2}
		end

		self:Unhook(this, "OnShow")
	end)

	if self.isTT then
		self:SecureHook("ArmoryPanelTemplates_UpdateTabs", function(frame)
			local tab
			for i = 1, frame.numTabs do
				tab = frame.Tabs[i] or _G[frame:GetName() .. "Tab" .. i]
				if tab.sf then
					self:setInactiveTab(tab.sf)
					if i == frame.selectedTab then
						self:setActiveTab(tab.sf)
					end
				end
			end
		end)
	end

	self:SecureHookScript(_G.ArmoryFrame, "OnShow", function(this)
		self:skinObject("tabs", {obj=this, prefix=this:GetName(), lod=self.isTT and true, regions={7}, offsets={x1=9, y1=2, x2=-9, y2=2}, track=false})
		self:skinObject("frame", {obj=this, kfs=true, ri=true, cb=true})
		_G.ArmoryFramePortrait:SetAlpha(1) -- used to delete characters
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.ArmorySelectCharacter, ofs=0, y1=-1, x2=-1}
		end
		-- Tabs (RHS)
		local tab
		for i = 1, 10 do
			tab = _G["ArmoryFrameLineTab" .. i]
			self:removeRegions(tab, {1}) -- N.B. region 2 is the icon, 3 is the text
			-- Move the first entry as all the others are positioned from it
			if i == 1 then
				self:moveObject{obj=tab, x=-2}
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=tab, clr="grey"}
			end
		end
		self:Unhook(this, "OnShow")
	end)

	local pdfSlots = {"Head", "Neck", "Shoulder", "Back", "Chest", "Shirt", "Tabard", "Wrist", "Hands", "Waist", "Legs", "Feet", "Finger0", "Finger1", "Trinket0", "Trinket1", "MainHand", "SecondaryHand"}
	self:SecureHookScript(_G.ArmoryPaperDollFrame, "OnShow", function(this)
		self:keepFontStrings(_G.ArmoryPaperDollTalent)
		_G.ArmoryPaperDollTalentButtonBorder:SetTexture(nil)
		self:keepFontStrings(_G.ArmoryPaperDollTradeSkill)
		self:skinObject("statusbar", {obj=_G.ArmoryPaperDollTradeSkillFrame1Bar, fi=0})
		self:skinObject("statusbar", {obj=_G.ArmoryPaperDollTradeSkillFrame1BackgroundBar, fi=0})
		self:skinObject("statusbar", {obj=_G.ArmoryPaperDollTradeSkillFrame2Bar, fi=0})
		self:skinObject("statusbar", {obj=_G.ArmoryPaperDollTradeSkillFrame2BackgroundBar, fi=0})
		-- ArmorySocketsFrame
		self:keepFontStrings(_G.ArmoryAttributesFrame)
		self:skinObject("dropdown", {obj=_G.ArmoryAttributesFramePlayerStatDropDown})
		if self.modBtnBs then
			for _, sName in _G.ipairs(pdfSlots) do
				_G["Armory" .. sName .. "Slot"]:DisableDrawLayer("BACKGROUND")
				self:addButtonBorder{obj=_G["Armory" .. sName .. "Slot"], ibt=true, clr="grey"}
				-- _G.PaperDollItemSlotButton_Update(btn)
			end
			self:addButtonBorder{obj=_G.ArmoryGearSetToggleButton, x1=1, x2=-1, clr="grey"}
		end
		-- ArmoryAlternateSlotFrame

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.ArmoryPaperDollFrame)

	self:SecureHookScript(_G.ArmoryGearSetFrame, "OnShow", function(this)
		self:skinObject("frame", {obj=this, kfs=true, ofs=0})
		if self.modBtns then
			self:skinCloseButton{obj=_G.ArmoryGearSetFrameClose}
			self:skinStdButton{obj=_G.ArmoryGearSetFrameEquipSet}
		end
		if self.modBtnBs then
			for i = 1, _G.MAX_EQUIPMENT_SETS_PER_PLAYER do
				_G["ArmoryGearSetButton" .. i]:DisableDrawLayer("BACKGROUND")
				self:addButtonBorder{obj=_G["ArmoryGearSetButton" .. i], y2=-4, clr="grey"}
			end
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.ArmoryPetFrame, "OnShow", function(this)
		_G.ArmoryPetSpecFrameRing:SetTexture(nil)
		for i = 1, 7 do
			self:removeRegions(_G["ArmoryPetStatsPaneCategory" .. i], {1, 2, 3, 4})
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.ArmoryPetFramePetInfo, relTo=_G.ArmoryPetFrameSelectedPetIcon, clr="grey"}
			self:addButtonBorder{obj=_G.ArmoryPetFrameDiet, ofs=1, x2=0, clr="gold"}
			for i = 1, 5 do
				self:addButtonBorder{obj=_G["ArmoryPetFramePet" .. i], ofs=4, clr="gold"}
			end
			self:addButtonBorder{obj=_G.ArmoryPetFrameNextPageButton, ofs=0, clr="grey"}
			self:addButtonBorder{obj=_G.ArmoryPetFramePrevPageButton, ofs=0, clr="grey"}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.ArmoryPVPFrame, "OnShow", function(this)
		_G.ArmoryPVPFrameBackground:SetTexture(nil)
		self:skinObject("tabs", {obj=this, prefix=this:GetName(), ignoreSize=true, lod=self.isTT and true, upwards=true, regions={7}, offsets={x1=6, y1=-2, x2=-6, y2=0}, track=false})
		self:skinObject("frame", {obj=_G.ArmoryConquestFrame.RatedSoloShuffle, kfs=true, fb=true, ofs=-1, clr="black"})
		self:skinObject("frame", {obj=_G.ArmoryConquestFrame.Arena2v2, kfs=true, fb=true, ofs=-1, clr="black"})
		self:skinObject("frame", {obj=_G.ArmoryConquestFrame.Arena3v3, kfs=true, fb=true, ofs=-1, clr="black"})
		self:skinObject("frame", {obj=_G.ArmoryConquestFrame.RatedBG, kfs=true, fb=true, ofs=-1, clr="black"})
		_G.ArmoryPVPHonorXPBar.Frame:SetTexture(nil)
		self:skinObject("statusbar", {obj=_G.ArmoryPVPHonorXPBar.Bar, fi=0})
		-- ArmoryPVPTalents
		for _, slot in _G.pairs(_G.ArmoryPVPTalents.Slots) do
			slot.Border:SetTexture(nil)
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.ArmoryOtherFrame, "OnShow", function(this)
		self:skinObject("tabs", {obj=this, prefix=this:GetName(), ignoreSize=true, lod=self.isTT and true, upwards=true, regions={7}, offsets={x1=6, y1=-0, x2=-6, y2=-2}, track=false})

		self:SecureHookScript(_G.ArmoryReputationFrame, "OnShow", function(fObj)
			for i = 1, 15 do
				_G["ArmoryReputationBar" .. i .. "Background"]:SetTexture(nil)
				_G["ArmoryReputationBar" .. i .. "ReputationBarLeftTexture"]:SetTexture(nil)
				_G["ArmoryReputationBar" .. i .. "ReputationBarRightTexture"]:SetTexture(nil)
				self:skinObject("statusbar", {obj=_G["ArmoryReputationBar" .. i .. "ReputationBar"], fi=0})
				if self.modBtns then
					self:skinExpandButton{obj=_G["ArmoryReputationBar" .. i .. "ExpandOrCollapseButton"], onSB=true}
				end
			end
			self:skinObject("slider", {obj=_G.ArmoryReputationListScrollFrame.ScrollBar, rpTex="background"})

			self:Unhook(fObj, "OnShow")
		end)

		self:SecureHookScript(_G.ArmoryTokenFrame, "OnShow", function(fObj)
			self:skinObject("slider", {obj=_G.ArmoryTokenFrameContainerScrollBar, rpTex={"background", "artwork"}})
			for _, btn in _G.pairs(_G["ArmoryTokenFrameContainer"].buttons) do
				btn:DisableDrawLayer("BACKGROUND")
				btn.categoryLeft:SetTexture(nil)
				btn.categoryRight:SetTexture(nil)
				btn.categoryMiddle:SetTexture(nil)
			end

			self:Unhook(fObj, "OnShow")
		end)

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.ArmoryInventoryFrame, "OnShow", function(this)
		_G.ArmoryInventoryMoneyBackgroundFrame:DisableDrawLayer("BACKGROUND")
		self:skinObject("editbox", {obj=_G.ArmoryInventoryFrameEditBox, si=true})
		_G.ArmoryInventoryExpandButtonFrame:DisableDrawLayer("BACKGROUND")
		self:skinObject("tabs", {obj=this, prefix=this:GetName(), ignoreSize=true, lod=self.isTT and true, regions={7}, offsets={x1=6, y1=2, x2=-6, y2=2}, track=false})
		self:skinObject("frame", {obj=this, kfs=true, cb=true})
		if self.modBtns then
			self:skinExpandButton{obj=_G.ArmoryInventoryCollapseAllButton, onSB=true}
		end

		self:SecureHookScript(_G.ArmoryInventoryIconViewFrame, "OnShow", function(fObj)
			self:skinObject("slider", {obj=fObj.ScrollBar, rpTex="artwork"})
			if self.modBtns then
				local function skinLines(cFrame)
					aObj:skinExpandButton{obj=_G[cFrame:GetName() .. "Label"], onSB=true}
					for _, child in _G.ipairs{cFrame:GetChildren()} do
						if child:IsObjectType("CheckButton") then
							aObj:addButtonBorder{obj=child, ibt=true}
							if not child.hasItem then
								child.icon:SetTexture(nil)
							end
							aObj:clrButtonFromBorder(child)
						end
					end
				end
				self:SecureHook("ArmoryInventoryIconViewFrame_ShowContainer", function(containerFrame)
					skinLines(containerFrame)
				end)
				for i = 1, #_G.ArmoryInventoryContainers do
					skinLines(_G["ArmoryInventoryContainer" .. i])
				end
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=_G.ArmoryInventoryIconViewFrameLayoutCheckButton}
			end

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(_G.ArmoryInventoryIconViewFrame)

		self:SecureHookScript(_G.ArmoryInventoryListViewFrame, "OnShow", function(fObj)
			self:skinObject("slider", {obj=_G.ArmoryInventoryListViewScrollFrame.ScrollBar, rpTex="background"})
			if self.isTT then
				_G.ArmoryPanelTemplates_UpdateTabs(_G.ArmoryInventoryFrame)
			end
			if self.modBtns then
				local lineButton, isHeader
				local function skinLines()
					for i = 1, _G.ARMORY_INVENTORY_LINES_DISPLAYED do
				        lineButton = _G["ArmoryInventoryLine" .. i]
				        _, _, _, _, isHeader = _G.Armory:GetInventoryLineInfo(lineButton:GetID())
						if isHeader then
							aObj:skinExpandButton{obj=lineButton, onSB=true}
						else
							lineButton:GetNormalTexture():SetAlpha(1)
						end
					end
				end
				self:SecureHook("ArmoryInventoryListViewFrame_Update", function()
					skinLines()
				end)
				skinLines()
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=_G.ArmoryInventoryListViewFrameSearchAllCheckButton}
			end

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(_G.ArmoryInventoryListViewFrame)

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.ArmoryQuestFrame, "OnShow", function(this)
		self:skinObject("editbox", {obj=_G.ArmoryQuestFrameEditBox, si=true})
		self:removeInset(this.bottomInset)
		self:skinObject("tabs", {obj=this, prefix=this:GetName(), ignoreSize=true, lod=self.isTT and true, regions={7}, track=false})
		self:skinObject("frame", {obj=this, kfs=true, cb=true})
		if self.modBtns then
			self:skinExpandButton{obj=_G.ArmoryQuestFrameCollapseAllButton, onSB=true}
		end

		self:SecureHook("ArmoryQuestInfo_Display", function(_, _)
			-- headers
			_G.ArmoryQuestInfoTitleHeader:SetTextColor(self.HT:GetRGB())
			_G.ArmoryQuestInfoDescriptionHeader:SetTextColor(self.HT:GetRGB())
			_G.ArmoryQuestInfoObjectivesHeader:SetTextColor(self.HT:GetRGB())
			_G.ArmoryQuestInfoTitleHeader:SetTextColor(self.HT:GetRGB())
			_G.ArmoryQuestInfoRewardsFrame.Header:SetTextColor(self.HT:GetRGB())
			-- other text
			_G.ArmoryQuestInfoQuestType:SetTextColor(self.BT:GetRGB())
			_G.ArmoryQuestInfoDescriptionText:SetTextColor(self.BT:GetRGB())
			_G.ArmoryQuestInfoObjectivesText:SetTextColor(self.BT:GetRGB())
			_G.ArmoryQuestInfoGroupSize:SetTextColor(self.BT:GetRGB())
			_G.ArmoryQuestInfoRewardText:SetTextColor(self.BT:GetRGB())
			_G.ArmoryQuestInfoRequiredMoneyText:SetTextColor(self.BT:GetRGB())
			_G.ArmoryQuestInfoAnchor:SetTextColor(self.BT:GetRGB())
			-- reward frame text
			_G.ArmoryQuestInfoRewardsFrame.ItemChooseText:SetTextColor(self.BT:GetRGB())
			_G.ArmoryQuestInfoRewardsFrame.ItemReceiveText:SetTextColor(self.BT:GetRGB())
			_G.ArmoryQuestInfoRewardsFrame.PlayerTitleText:SetTextColor(self.BT:GetRGB())
			_G.ArmoryQuestInfoRewardsFrame.QuestSessionBonusReward:SetTextColor(self.BT:GetRGB())
	        _G.ArmoryQuestInfoRewardsFrame.XPFrame.ReceiveText:SetTextColor(self.BT:GetRGB())
			-- objective(s)
			local br, bg, bb = self.BT:GetRGB()
			local r, g, b
			for i = 1, #_G.ArmoryQuestInfoObjectivesFrame.Objectives do
				r, g, b = _G.ArmoryQuestInfoObjectivesFrame.Objectives[i]:GetTextColor()
				_G.ArmoryQuestInfoObjectivesFrame.Objectives[i]:SetTextColor(br - r, bg - g, bb - b)
			end
			-- spell line(s)
			for spellLine in _G.ArmoryQuestInfoRewardsFrame.spellHeaderPool:EnumerateActive() do
				spellLine:SetVertexColor(self.BT:GetRGB())
			end

			_G.ArmoryQuestInfoSealFrame.Text:SetTextColor(self.HT:GetRGB())

		end)

		self:SecureHookScript(_G.ArmoryQuestLogFrame, "OnShow", function(fObj)
			fObj.Bg:SetTexture(nil)
			self:keepFontStrings(_G.ArmoryEmptyQuestLogFrame)
			self:skinObject("slider", {obj=_G.ArmoryQuestLogListScrollFrame.ScrollBar, rpTex="background"})
			self:skinObject("slider", {obj=_G.ArmoryQuestLogDetailScrollFrame.ScrollBar, rpTex="background"})
			if self.modBtns then
				local lineButton, isHeader
				self:SecureHook("ArmoryQuestLog_Update", function()
					for i = 1, 6 do
				        _, _, _, isHeader, _ = _G.Armory:GetQuestLogTitle(i)
						lineButton = _G["ArmoryQuestLogTitle" .. i]
						if isHeader then
							self:skinExpandButton{obj=lineButton, onSB=true}
						elseif lineButton.sb then
							lineButton.sb:Hide()
						end
					end
				end)
			end

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(_G.ArmoryQuestLogFrame)

		self:SecureHookScript(_G.ArmoryQuestHistoryFrame, "OnShow", function(fObj)
			self:skinObject("slider", {obj=_G.ArmoryQuestHistoryScrollFrame.ScrollBar, rpTex="background"})
			if self.modBtns then
				local lineButton, isHeader
				self:SecureHook("ArmoryQuestHistory_Update", function()
					for i = 1, 22 do
				        _, isHeader, _ = _G.Armory:GetQuestHistoryTitle(i)
						lineButton = _G["ArmoryQuestHistoryTitle" .. i]
						if isHeader then
							self:skinExpandButton{obj=lineButton, onSB=true}
						elseif lineButton.sb then
							lineButton.sb:Hide()
						end
					end

				end)
			end
			self:Unhook(fObj, "OnShow")
		end)

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.ArmoryQuestInfoObjectivesFrame, "OnShow", function(this)
		local line, cnt = _G.ArmoryQuestInfoObjective1, 1
		while line do
			line:SetTextColor(self.BT:GetRGB())
			cnt = cnt + 1
			line = _G["ArmoryQuestInfoObjective" .. cnt]
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.ArmoryQuestInfoTimerFrame, "OnShow", function(this)
		_G.ArmoryQuestInfoTimerText:SetTextColor(self.BT:GetRGB())

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.ArmoryQuestInfoRewardsFrame, "OnShow", function(this)
		self:removeRegions(this.TitleFrame, {2, 3, 4})

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.ArmorySpellBookFrame, "OnShow", function(this)
		this:DisableDrawLayer("BACKGROUND")
		self:skinObject("tabs", {obj=this, prefix=this:GetName(), suffix="Button", ignoreSize=true, lod=self.isTT and true, regions={7}, offsets={x1=9, y1=2, x2=-9, y2=2}, track=false})
		self:skinObject("frame", {obj=this, kfs=true, cb=true})

		_G.ArmorySpellBookPageText:SetTextColor(self.BT:GetRGB())
		local btn
		for i = 1, 8 do
			btn = _G["ArmorySpellBookSkillLineTab" .. i]
			btn:DisableDrawLayer("BACKGROUND")
			if self.modBtnBs then
				self:addButtonBorder{obj=btn, clr="grey"}
			end
		end
		for i = 1, 12 do
			btn = _G["ArmorySpellButton" .. i]
			btn:DisableDrawLayer("BACKGROUND")
			btn.SpellName:SetTextColor(self.HT:GetRGB())
			btn.SpellSubName:SetTextColor(self.BT:GetRGB())
			btn.RequiredLevelString:SetTextColor(self.BT:GetRGB())
			btn.SeeTrainerString:SetTextColor(self.BT:GetRGB())
			if self.modBtnBs then
				self:addButtonBorder{obj=btn, clr="grey"}
			end
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.ArmorySpellBookPrevPageButton, ofs=-2, y1=-3, x2=-3, clr="gold", schk=true}
			self:addButtonBorder{obj=_G.ArmorySpellBookNextPageButton, ofs=-2, y1=-3, x2=-3, clr="gold", schk=true}
			self:SecureHook("ArmorySpellButton_UpdateButton", function(bObj)
			    local slot, _, _, _, _ = _G.ArmorySpellBook_GetSpellBookSlot(bObj)
			    local texture = slot and _G.Armory:GetSpellBookItemTexture(slot, _G.ArmorySpellBookFrame.bookType, _G.ArmorySpellBookFrame.selectedPetSpec)
			    if not texture
				or _G.strlen(texture) == 0
				then
					bObj.sbb:Hide()
				else
					bObj.sbb:Show()
				end
			end)
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.ArmoryAchievementFrame, "OnShow", function(this)
		self:skinObject("editbox", {obj=_G.ArmoryAchievementFrameEditBox, si=true})
		self:skinObject("slider", {obj=_G.ArmoryAchievementListScrollFrame.ScrollBar, rpTex="background"})
		self:skinObject("tabs", {obj=this, prefix=this:GetName(), ignoreSize=true, lod=self.isTT and true, regions={7}, offsets={x1=6, y1=2, x2=-6, y2=2}, track=false})
		self:skinObject("frame", {obj=this, kfs=true, ri=true, cb=true})
		local function skinLines()
			for i = 1, 15 do
				_G["ArmoryAchievementBar" .. i .. "Background"]:SetTexture(nil)
				_G["ArmoryAchievementBar" .. i .. "AchievementBarLeftTexture"]:SetTexture(nil)
				_G["ArmoryAchievementBar" .. i .. "AchievementBarRightTexture"]:SetTexture(nil)
				self:skinObject("statusbar", {obj=_G["ArmoryAchievementBar" .. i .. "AchievementBar"], fi=0})
				if self.modBtns then
					self:skinExpandButton{obj=_G["ArmoryAchievementBar" .. i .. "ExpandOrCollapseButton"], onSB=true}
				end
			end
		end
		self:SecureHook("ArmoryAchievementFrame_Update", function()
			skinLines()
		end)
		skinLines()
		if self.modBtns then
			self:skinExpandButton{obj=_G.ArmoryAchievementCollapseAllButton, onSB=true}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.ArmorySocialFrame, "OnShow", function(this)
		self:skinObject("tabs", {obj=this, prefix=this:GetName(), ignoreSize=true, lod=self.isTT and true, regions={7}, offsets={x1=6, y1=2, x2=-6, y2=2}, track=false})
		self:skinObject("frame", {obj=this, kfs=true, ri=true, cb=true})

		self:SecureHookScript(_G.ArmoryFriendsListFrame, "OnShow", function(fObj)
			self:skinObject("slider", {obj=_G.ArmoryFriendsListScrollFrame.ScrollBar, rpTex="background"})

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(_G.ArmoryFriendsListFrame)

		self:SecureHookScript(_G.ArmoryIgnoreListFrame, "OnShow", function(fObj)
			self:skinObject("slider", {obj=_G.ArmoryIgnoreListScrollFrame.ScrollBar, rpTex="background"})

			self:Unhook(fObj, "OnShow")
		end)

		self:SecureHookScript(_G.ArmoryEventsListFrame, "OnShow", function(fObj)
			self:skinObject("slider", {obj=_G.ArmoryEventsListScrollFrame.ScrollBar, rpTex="background"})

			self:Unhook(fObj, "OnShow")
		end)

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.ArmoryTradeSkillFrame, "OnShow", function(this)
		self:keepFontStrings(this.RankFrame.Border)
		self:skinObject("statusbar", {obj=this.RankFrame, fi=0, bg=this.RankFrame.Background})
		self:skinObject("editbox", {obj=this.SearchBox, si=true})
		self:removeInset(this.bottomInset)
		self:skinObject("slider", {obj=this.RecipeList.ScrollBar--[[, rpTex="background"--]]})
		self:skinObject("slider", {obj=this.DetailsFrame.ScrollBar, rpTex="background"})
		self:removeRegions(_G.ArmoryTradeSkillFrame.DetailsFrame.Contents, {8, 9}) -- Header textures
		self:skinObject("frame", {obj=this, kfs=true, ri=true, cb=true})
		if self.modBtns then
			self:skinStdButton{obj=this.FilterButton, clr="grey"}
			self:skinExpandButton{obj=this.ExpandButtonFrame.CollapseAllButton, onSB=true}
			self:SecureHook(_G.ArmoryTradeSkillFrame.RecipeList, "UpdateSkillButtonIndent", function(fObj)
				for _, btn in _G.ipairs(fObj.buttons) do
					if not btn.sb then
						self:skinExpandButton{obj=btn, onSB=true}
						btn.SubSkillRankBar.BorderLeft:SetTexture(nil)
						btn.SubSkillRankBar.BorderRight:SetTexture(nil)
						btn.SubSkillRankBar.BorderMid:SetTexture(nil)
						self:skinObject("statusbar", {obj=btn.SubSkillRankBar, fi=0})
					end
					btn.sb:SetShown(btn.isHeader)
				end
			end)
		end
		if self.modBtnBs then
			local function skinDetails(contents)
				contents.ResultIcon.ResultBorder:SetTexture(nil)
				aObj:addButtonBorder{obj=contents.ResultIcon, ibt=true, ofs=3}
				aObj:clrButtonFromBorder(contents.ResultIcon)
				for _, btn in _G.pairs(contents.Reagents) do
					if aObj.modBtnBs then
						aObj:addButtonBorder{obj=btn, libt=true}
						aObj:clrButtonFromBorder(btn)
					end
					btn.NameFrame:SetTexture(nil)
				end
				for _, btn in _G.pairs(contents.OptionalReagents) do
					if aObj.modBtnBs then
						aObj:addButtonBorder{obj=btn, libt=true}
						aObj:clrButtonFromBorder(btn)
					end
					btn.NameFrame:SetTexture(nil)
				end
			end
			self:SecureHook(_G.ArmoryTradeSkillFrame.DetailsFrame, "RefreshDisplay", function(fObj)
				skinDetails(fObj.Contents)
			end)
			skinDetails(_G.ArmoryTradeSkillFrame.DetailsFrame.Contents)
		end

		self:Unhook(this, "OnShow")
	end)

	self.mmButs["Armory"] = _G.ArmoryMinimapButton

end

aObj.addonsToSkin.ArmoryGuildBank = function(self)

	self:skinObject("editbox", {obj=_G.ArmoryGuildBankFrameEditBox, si=true})
	self:skinObject("dropdown", {obj=_G.ArmoryGuildBankNameDropDown})

	self:SecureHookScript(_G.ArmoryListGuildBankFrame, "OnShow", function(this)
		this.PortraitOverlay.TabardBorder:SetTexture(nil)
		_G.ArmoryListGuildBankFrameMoneyBackgroundFrame:DisableDrawLayer("BACKGROUND")
		self:skinObject("slider", {obj=_G.ArmoryListGuildBankScrollFrame.ScrollBar, rpTex="background"})
		self:skinObject("tabs", {obj=this, prefix=this:GetName(), ignoreSize=true, lod=self.isTT and true, regions={7}, offsets={x1=6, y1=0, x2=-6, y2=2}, track=false})
		self:skinObject("frame", {obj=this, kfs=true, cb=true})

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.ArmoryIconGuildBankFrame, "OnShow", function(this)
		self:removeRegions(_G.ArmoryIconGuildBankFrameEmblemFrame, {1, 2})
		self:skinObject("tabs", {obj=this, prefix=this:GetName(), ignoreSize=true, lod=self.isTT and true, regions={7}, offsets={x1=6, y1=0, x2=-6, y2=2}, track=false})
		self:skinObject("frame", {obj=this, kfs=true, ofs=-1, y1=-9, x2=2})
		for i = 1, 7 do
			_G["ArmoryIconGuildBankColumn" .. i .. "Background"]:SetTexture(nil)
		end
		if self.modBtnBs then
			self:SecureHook("ArmoryGuildBankFrame_Update", function()
				local btn
				if _G.AGB:GetIconViewMode() then
					for i = 1, 7 do
						for j = 1, 14 do
							btn = _G["ArmoryIconGuildBankColumn" .. i .. "Button" .. j]
							self:addButtonBorder{obj=btn, ibt=true}
							self:clrButtonFromBorder(btn)
						end
					end
				end
			end)
		end
		for i = 1, 8 do
			_G["ArmoryIconGuildBankTab" .. i]:DisableDrawLayer("BACKGROUND")
			if self.modBtnBs then
				self:addButtonBorder{obj=_G["ArmoryIconGuildBankTab" .. i .. "Button"], ofs=3, x2=2, y2=-4, clr="sepia"}
			end
		end
		if self.modBtns then
			self:skinCloseButton{obj=self:getChild(this, 11)}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.ArmoryIconGuildBankFramePersonalCheckButton}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.ArmoryInventoryGuildBankFrame, "OnShow", function(fObj)
		self:skinObject("slider", {obj=_G.ArmoryInventoryGuildBankScrollFrame.ScrollBar, rpTex="background"})
		if self.modBtns then
			local lineButton
			local function skinLines()
				for i = 1, _G.ARMORY_INVENTORY_LINES_DISPLAYED do
			        lineButton = _G["ArmoryInventoryGuildBankLine" .. i]
					if lineButton:GetID() ~= 0 then
						aObj:skinExpandButton{obj=lineButton, onSB=true}
					else
						lineButton:GetNormalTexture():SetAlpha(1)
					end
				end
			end
			self:SecureHook("ArmoryInventoryGuildBankFrame_Update", function()
				skinLines()
			end)
			skinLines()
		end

		self:Unhook(fObj, "OnShow")
	end)
	self:checkShown(_G.ArmoryInventoryGuildBankFrame)

end
