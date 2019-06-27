local aName, aObj = ...
if not aObj.isClassic then return end
local _G = _G

local pairs, ipairs = _G.pairs, _G.ipairs

local ftype
local funcs= {
	NPC = {
		{ name = "GossipFrame", type = "", keepOpts=true },
		{ name = "BankFrame", type = "", keepOpts=true },
		{ name = "MerchantFrame", type = "", keepOpts=true },
		{ name = "PetStableFrame", type = "", keepOpts=true },
		{ name = "QuestFrame", type = "", keepOpts=true },
		{ name = "AlliedRacesUI", type = "LoD", keepOpts=false },
		{ name = "AuctionUI", type = "LoD", keepOpts=true },
		{ name ="AzeriteRespecUI", type = "LoD", keepOpts = false },
		{ name ="BarbershopUI", type = "LoD", keepOpts = false },
		{ name ="BlackMarketUI", type = "LoD", keepOpts = false },
		{ name ="ItemUpgradeUI", type = "LoD", keepOpts = false },
		{ name ="QuestChoice", type = "LoD", keepOpts = false },
		{ name ="TrainerUI", type = "LoD", keepOpts = true },
		{ name ="VoidStorageUI", type = "LoD", keepOpts = false },
	},
	Player = {
		{ name = "CharacterFrames", type = "", keepOpts = true },
		{ name = "CompactFrames", type = "", keepOpts = true },
		{ name = "ContainerFrames", type = "", keepOpts = true },
		{ name = "EquipmentFlyout", type = "", keepOpts = false },
		{ name = "FriendsFrame", type = "", keepOpts = true },
		{ name = "GuildInvite", type = "", keepOpts = false },
		{ name = "LootFrames", type = "", keepOpts = true },
		{ name = "MirrorTimers", type = "", keepOpts = true },
		{ name = "ObjectiveTracker", type = "", keepOpts = false },
		{ name = "OverrideActionBar", type = "", keepOpts = false },
		{ name = "PVPHonorSystem", type = "", keepOpts = false },
		{ name = "RolePollPopup", type = "", keepOpts = false },
		{ name = "SpellBookFrame", type = "", keepOpts = true },
		{ name = "StackSplit", type = "", keepOpts = true },
		{ name = "WardrobeOutfits", type = "", keepOpts = false },
		{ name = "AchievementUI", type = "LoD", keepOpts = false },
		{ name = "ArchaeologyUI", type = "LoD", keepOpts = false },
		{ name = "ArenaUI", type = "LoD", keepOpts = false },
		{ name = "ArtifactUI", type = "LoD", keepOpts = false },
		{ name = "AzeriteUI", type = "LoD", keepOpts = false },
		{ name = "Collections", type = "LoD", keepOpts = false },
		{ name = "Communities", type = "LoD", keepOpts = true },
		{ name = "EncounterJournal", type = "LoD", keepOpts = false },
		{ name = "GuildUI", type = "LoD", keepOpts = false },
		{ name = "GuildControlUI", type = "LoD", keepOpts = false },
		{ name = "LookingForGuildUI", type = "LoD", keepOpts = false },
		{ name = "InspectUI", type = "LoD", keepOpts = true },
		{ name = "ItemSocketingUI", type = "LoD", keepOpts = false },
		{ name = "PVPUI", type = "LoD", keepOpts = false },
		{ name = "RaidUI", type = "LoD", keepOpts = true },
		{ name = "TalentUI", type = "LoD", keepOpts = false },
		{ name = "TradeSkillUI", type = "LoD", keepOpts = true },
		-- aObj.blizzLoDFrames[ftype].InspectUI = nil ??
	},
	UI = {
		-- aObj.blizzFrames[ftype].UIWidgets = nil ???
		{ name = "ArtifactToasts", type = "", keepOpts = false },
		{ name = "ChatButtons", type = "", keepOpts = true },
		{ name = "DestinyFrame", type = "", keepOpts = false },
		{ name = "GarrisonTooltips", type = "", keepOpts = false },
		{ name = "GhostFrame", type = "", keepOpts = false },
		{ name = "ItemText", type = "", keepOpts = true },
		{ name = "LevelUpDisplay", type = "", keepOpts = false },
		{ name = "LFDFrame", type = "", keepOpts = false },
		{ name = "LFGFrame", type = "", keepOpts = false },
		{ name = "LFGList", type = "", keepOpts = false },
		{ name = "LFRFrame", type = "", keepOpts = false },
		{ name = "LossOfControl", type = "", keepOpts = false },
		{ name = "MainMenuBar", type = "", keepOpts = true },
		{ name = "Minimap", type = "", keepOpts = true },
		{ name = "MinimapButtons", type = "", keepOpts = true },
		{ name = "NamePlates", type = "", keepOpts = true },
		{ name = "PetBattleUI", type = "", keepOpts = false },
		{ name = "PVEFrame", type = "", keepOpts = false },
		{ name = "PVPHelper", type = "", keepOpts = false },
		{ name = "QuestMap", type = "", keepOpts = false },
		{ name = "QueueStatusFrame", type = "", keepOpts = false },
		{ name = "RaidFrame", type = "", keepOpts = true },
		{ name = "RaidFinder", type = "", keepOpts = false },
		{ name = "ScenarioFinder", type = "", keepOpts = false },
		{ name = "SplashFrame", type = "", keepOpts = false },
		{ name = "TimeManager", type = "", keepOpts = false },
		{ name = "Tutorial", type = "", keepOpts = true },
		{ name = "UIWidgets", type = "", keepOpts = true },
		{ name = "WorldMap", type = "", keepOpts = true },
		{ name = "ZoneAbility", type = "", keepOpts = false },
		{ name = "AdventureMap", type = "LoD", keepOpts = false },
		{ name = "Calendar", type = "LoD", keepOpts = false },
		{ name = "ChallengesUI", type = "LoD", keepOpts = false },
		{ name = "ClassTrial", type = "LoD", keepOpts = false },
		{ name = "Contribution", type = "LoD", keepOpts = false },
		{ name = "DeathRecap", type = "LoD", keepOpts = false },
		{ name = "GarrisonUI", type = "LoD", keepOpts = false },
		{ name = "GuildBankUI", type = "LoD", keepOpts = false },
		{ name = "IslandsPartyPoseUI", type = "LoD", keepOpts = false },
		{ name = "IslandsQueueUI", type = "LoD", keepOpts = false },
		{ name = "ObliterumUI", type = "LoD", keepOpts = false },
		{ name = "OrderHallUI", type = "LoD", keepOpts = false },
		{ name = "ScrappingMachineUI", type = "LoD", keepOpts = false },
		{ name = "TalkingHeadUI", type = "LoD", keepOpts = false },
		{ name = "WarboardUI", type = "LoD", keepOpts = false },
		{ name = "WarfrontsPartyPoseUI", type = "LoD", keepOpts = false },
	},
}
aObj.otherAddons.ClassicInit = function(self)

	-- remove code for frames that don't exist
	local function removeFunc(name, ftype, type)
		-- aObj:Debug("removeFunc: [%s, %s, %s]", name, ftype, type)
		if type == "LoD" then
			aObj.blizzLoDFrames[ftype][name] = nil
		else
			aObj.blizzFrames[ftype][name] = nil
		end
	end

	for fType, tTab in pairs(funcs) do
		-- aObj:Debug("ClassicInit: [%s, %s]", fType, tTab)
		for _, fTab in ipairs(tTab) do
			removeFunc(fTab.name, fType:sub(1, 1):lower(), fTab.type)
		end
	end

	-- remove otions for frames that don't exist
	local function removeOpts(name, ftype, keepOpts)
		-- aObj:Debug("removeOpts: [%s, %s, %s]", name, ftype, keepOpts)
		if not keepOpts then
			aObj.db.profile[name] = nil
			aObj.db.defaults.profile[name] = nil
			aObj.optTables[ftype].args[name] = nil
		end
	end

	self:SecureHook(self.blizzFrames.opt, "SetupOptions", function(this)
		for fType, tTab in pairs(funcs) do
			for _, fTab in ipairs(tTab) do
				removeOpts(fTab.name, fType .. " Frames", fTab.keepOpts)
			end
		end
		-- Add options for new frames
		self.db.profile.QuestLog = true
		self.db.defaults.profile.QuestLog = true
		self.optTables["UI Frames"].args.QuestLog = {
			type = "toggle",
			name = self.L["Quest Log"],
			desc = self.L["Toggle the skin of the Quest Log"],
		}
		self.db.profile.QuestTimer = true
		self.db.defaults.profile.QuestTimer = true
		self.optTables["UI Frames"].args.QuestTimer = {
			type = "toggle",
			name = self.L["Quest Timer"],
			desc = self.L["Toggle the skin of the Quest Timer"],
		}
		self:Unhook(this, "SetupOptions")
	end)

	_G.collectgarbage("collect")

	-- add/replace code for frames that do exist

	ftype = "n"
	aObj.blizzLoDFrames[ftype].AuctionUI = function(self)
		if not self.prdb.AuctionUI or self.initialized.AuctionUI then return end
		self.initialized.AuctionUI = true

		local function skinBtn(btnName, idx)
			aObj:keepFontStrings(_G[btnName .. idx])
			_G[btnName .. idx .. "Highlight"]:SetAlpha(1)
			_G[btnName .. idx .. "ItemNormalTexture"]:SetAlpha(0) -- texture changed in code
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=_G[btnName .. idx .. "Item"], reParent={_G[btnName .. idx .. "Count"], _G[btnName .. idx .. "Stock"]}}
				aObj:clrButtonBorder(_G[btnName .. idx .. "Item"])
			end
		end

		self:SecureHookScript(_G.AuctionFrame, "OnShow", function(this)
			-- hide filter texture when filter is clicked
			self:SecureHook("FilterButton_SetUp", function(button, ...)
				_G[button:GetName() .. "NormalTexture"]:SetAlpha(0)
			end)

			self:skinTabs{obj=this, lod=true}
			self:addSkinFrame{obj=_G.AuctionFrame, ft=ftype, kfs=true, hdr=true, x1=10, y1=-11, y2=5}
			self:moveObject{obj=_G.AuctionFrameCloseButton, x=3}

			-- AuctionFrame Browse
			for i = 1, _G.NUM_FILTERS_TO_DISPLAY do
				self:keepRegions(_G["AuctionFilterButton" .. i], {3, 4}) -- N.B. region 3 is the highlight, 4 is the text
				self:addSkinFrame{obj=_G["AuctionFilterButton" .. i], ft=ftype, nb=true, aso={bd=5}, y2=-1}
			end
			self:skinSlider{obj=_G.BrowseFilterScrollFrame.ScrollBar, rt="artwork"}
			self:skinSlider{obj=_G.BrowseScrollFrame.ScrollBar, rt="artwork"}
			for _, type in pairs{"Quality", "Level", "Duration", "HighBidder", "CurrentBid"} do
				self:keepRegions(_G["Browse" .. type .. "Sort"], {4, 5, 6}) -- N.B. region 4 is the text, 5 is the arrow, 6 is the highlight
				self:addSkinFrame{obj=_G["Browse" .. type .. "Sort"], ft=ftype, nb=true, aso={bd=5}, x2=-2}
			end
			for i = 1, _G.NUM_BROWSE_TO_DISPLAY do
				if _G["BrowseButton" .. i].Orig then break end -- Auctioneer CompactUI loaded
				skinBtn("BrowseButton", i)
			end
			for _, type in pairs{"Name", "MinLevel", "MaxLevel"} do
				self:skinEditBox{obj=_G["Browse" .. type], regs={6, type == "Name" and 7 or nil}, mi=true} -- 6 is text, 7 is icon
				self:moveObject{obj=_G["Browse" .. type], x=type == "MaxLevel" and -6 or -4, y=type ~= "MaxLevel" and 3 or 0}
			end
			self:skinDropDown{obj=_G.BrowseDropDown, x2=109}
			self:skinMoneyFrame{obj=_G.BrowseBidPrice, moveSEB=true}
			_G.BrowseBidButton:DisableDrawLayer("BORDER")
			_G.BrowseBuyoutButton:DisableDrawLayer("BORDER")
			_G.BrowseCloseButton:DisableDrawLayer("BORDER")

			if self.modChkBtns then
				self:skinCheckButton{obj=_G.IsUsableCheckButton}
				self:skinCheckButton{obj=_G.ShowOnPlayerCheckButton}
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=_G.BrowsePrevPageButton, ofs=-2, y1=-3, x2=-3}
				self:addButtonBorder{obj=_G.BrowseNextPageButton, ofs=-2, y1=-3, x2=-3}
			end
			if self.modBtns then
				self:skinStdButton{obj=_G.BrowseSearchButton}
				self:skinStdButton{obj=_G.BrowseCloseButton}
				self:skinStdButton{obj=_G.BrowseBuyoutButton}
				self:skinStdButton{obj=_G.BrowseBidButton}
			end

			self:SecureHookScript(_G.BrowseWowTokenResults, "OnShow", function(this)
				this.Token:DisableDrawLayer("BACKGROUND")
				if self.modBtns then
					self:skinStdButton{obj=this.Buyout}
					self:skinStdButton{obj=_G.StoreButton, x1=14, y1=2, x2=-14, y2=2}
				end
				self:Unhook(this, "OnShow")
			end)
			self:SecureHookScript(_G.WowTokenGameTimeTutorial, "OnShow", function(this)
				this.LeftDisplay.Label:SetTextColor(self.HT:GetRGB())
				this.LeftDisplay.Tutorial1:SetTextColor(self.BT:GetRGB())
				this.RightDisplay.Label:SetTextColor(self.HT:GetRGB())
				this.RightDisplay.Tutorial1:SetTextColor(self.BT:GetRGB())
				self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true, ofs=1, y1=2, y2=220}
				self:Unhook(this, "OnShow")
			end)
			self:Unhook(this, "OnShow")

			-- AuctionFrame Bid
			for _, type in pairs{"Quality", "Level", "Duration", "Buyout", "Status", "Bid"} do
				self:keepRegions(_G["Bid" .. type .. "Sort"], {4, 5, 6}) -- N.B. region 4 is the text, 5 is the arrow, 6 is the highlight
				self:addSkinFrame{obj=_G["Bid" .. type .. "Sort"], ft=ftype, aso={bd=5}, x2=-2}
			end
			for i = 1, _G.NUM_BIDS_TO_DISPLAY do
				skinBtn("BidButton", i)
			end
			self:skinSlider{obj=_G.BidScrollFrame.ScrollBar, rt="artwork"}
			self:skinMoneyFrame{obj=_G.BidBidPrice, moveSEB=true}
			_G.BidCloseButton:DisableDrawLayer("BORDER")
			_G.BidBuyoutButton:DisableDrawLayer("BORDER")
			_G.BidBidButton:DisableDrawLayer("BORDER")
			if self.modBtns then
				self:skinStdButton{obj=_G.BidBidButton}
				self:skinStdButton{obj=_G.BidBuyoutButton}
				self:skinStdButton{obj=_G.BidCloseButton}
			end
			self:Unhook(this, "OnShow")

			-- AuctionFrame Auctions
			for _, type in pairs{"Quality", "Duration", "HighBidder", "Bid"} do
				self:keepRegions(_G["Auctions" .. type .. "Sort"], {4, 5, 6}) -- N.B. region 4 is the text, 5 is the arrow, 6 is the highlight
				self:addSkinFrame{obj=_G["Auctions" .. type .. "Sort"], ft=ftype, aso={bd=5}, x2=-2}
			end
			self:skinSlider{obj=_G.AuctionsScrollFrame.ScrollBar, rt="artwork"}
			for i = 1, _G.NUM_AUCTIONS_TO_DISPLAY do
				skinBtn("AuctionsButton", i)
			end
			if not self.modBtnBs then
				self:resizeEmptyTexture(self:getRegion(_G.AuctionsItemButton, 2))
			else
				self:getRegion(_G.AuctionsItemButton, 2):SetAlpha(0) -- texture is changed in blizzard code
				self:addButtonBorder{obj=_G.AuctionsItemButton}
			end
			self:skinEditBox{obj=_G.AuctionsStackSizeEntry, regs={6}, noWidth=true} -- 6 is text
			self:skinEditBox{obj=_G.AuctionsNumStacksEntry, regs={6}, noWidth=true} -- 6 is text
			self:skinDropDown{obj=_G.PriceDropDown}
			self:skinMoneyFrame{obj=_G.StartPrice, moveSEB=true}
			self:skinMoneyFrame{obj=_G.BuyoutPrice, moveSEB=true}
			if self.modBtns then
				self:skinStdButton{obj=_G.AuctionsStackSizeMaxButton}
				self:skinStdButton{obj=_G.AuctionsNumStacksMaxButton}
				self:skinStdButton{obj=_G.AuctionsCreateAuctionButton}
				self:skinStdButton{obj=_G.AuctionsCancelAuctionButton, x2=-1}
				self:skinStdButton{obj=_G.AuctionsCloseButton}
			end
			self:Unhook(this, "OnShow")

			self:SecureHookScript(_G.AuctionProgressFrame, "OnShow", function(this)
				this:DisableDrawLayer("BACKGROUND")
				this:DisableDrawLayer("ARTWORK")
				self:keepFontStrings(_G.AuctionProgressBar)
				self:moveObject{obj=_G.AuctionProgressBar.Text, y=-2}
				self:skinStatusBar{obj=_G.AuctionProgressBar, fi=0}
				self:Unhook(this, "OnShow")
			end)

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].BankFrame = function(self)
		if not self.prdb.BankFrame or self.initialized.BankFrame then return end
		self.initialized.BankFrame = true

		self:SecureHookScript(_G.BankFrame, "OnShow", function(this)

			self:keepFontStrings(_G.BankSlotsFrame)
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true, x1=10, y1=-11, x2=-33, y2=90}
			if self.modBtns then
				self:skinCloseButton{obj=_G.BankCloseButton}
   			 	self:skinStdButton{obj=_G.BankFramePurchaseButton}
			end
			if self.modBtnBs then
				self:SecureHook("BankFrameItemButton_Update", function(btn)
					if not btn.hasItem then
						btn.sbb:SetBackdropBorderColor(0.498, 0.498, 0.498, 0.5) -- grey border, 50% alpha
					end
				end)
				-- add button borders to bank items
				for i = 1, _G.NUM_BANKGENERIC_SLOTS do
					self:addButtonBorder{obj=_G.BankSlotsFrame["Item" .. i], ibt=true, reParent={_G["BankFrameItem" .. i].IconQuestTexture}, grey=true}
					-- force quality border update
					_G.BankFrameItemButton_Update(_G.BankSlotsFrame["Item" .. i])
				end
				-- add button borders to bags
				for i = 1, _G.NUM_BANKBAGSLOTS do
					self:addButtonBorder{obj=_G.BankSlotsFrame["Bag" .. i], ibt=true}
				end
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].GossipFrame = function(self)
		if not self.prdb.GossipFrame or self.initialized.GossipFrame then return end
		self.initialized.GossipFrame = true

		self:SecureHookScript(_G.GossipFrame, "OnShow", function(this)
			self:keepFontStrings(_G.GossipFrameGreetingPanel)
			_G.GossipGreetingText:SetTextColor(self.HT:GetRGB())
			self:skinStdButton{obj=_G.GossipFrameGreetingGoodbyeButton}
			self:skinSlider{obj=_G.GossipGreetingScrollFrame.ScrollBar, rt="artwork"}
			for i = 1, _G.NUMGOSSIPBUTTONS do
				self:getRegion(_G["GossipTitleButton" .. i], 3):SetTextColor(self.BT:GetRGB())
				hookQuestText(_G["GossipTitleButton" .. i])
			end
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, x1=10, y1=-18, x2=-29, y2=60}

			-- NPCFriendshipStatusBar
			self:removeRegions(_G.NPCFriendshipStatusBar, {1, 3, 4, 5 ,6})
			self:skinStatusBar{obj=_G.NPCFriendshipStatusBar, fi=0, bgTex=self:getRegion(_G.NPCFriendshipStatusBar, 7)}

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].MerchantFrame = function(self)
		if not self.prdb.MerchantFrame or self.initialized.MerchantFrame then return end
		self.initialized.MerchantFrame = true

		self:SecureHookScript(_G.MerchantFrame, "OnShow", function(this)
			self:skinTabs{obj=this, lod=true} -- do first otherwise error when TradeSkillMaster Addon is loaded
			self:removeInset(_G.MerchantMoneyInset)
			_G.MerchantMoneyBg:DisableDrawLayer("BACKGROUND")
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true, x2=1, y2=-5.5}
			if self.modBtnBs then
				self:removeRegions(_G.MerchantPrevPageButton, {2})
				self:addButtonBorder{obj=_G.MerchantPrevPageButton, ofs=-2, y1=-3, x2=-3}
				self:removeRegions(_G.MerchantNextPageButton, {2})
				self:addButtonBorder{obj=_G.MerchantNextPageButton, ofs=-2, y1=-3, x2=-3}
			end

			-- Items/Buyback Items
			for i = 1, _G.math.max(_G.MERCHANT_ITEMS_PER_PAGE, _G.BUYBACK_ITEMS_PER_PAGE) do
				_G["MerchantItem" .. i .. "NameFrame"]:SetTexture(nil)
				if not self.modBtnBs then
					_G["MerchantItem" .. i .. "SlotTexture"]:SetTexture(self.esTex)
				else
					_G["MerchantItem" .. i .. "SlotTexture"]:SetTexture(nil)
					self:addButtonBorder{obj=_G["MerchantItem" .. i .. "ItemButton"], ibt=true}
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
				self:addButtonBorder{obj=_G.MerchantRepairAllButton, grey=true, ga=0.85}
				self:addButtonBorder{obj=_G.MerchantRepairItemButton, grey=true, ga=0.85}
				self:addButtonBorder{obj=_G.MerchantGuildBankRepairButton, grey=true, ga=0.85}
			else
				_G.MerchantBuyBackItemSlotTexture:SetTexture(self.esTex)
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].PetStableFrame = function(self)
		if not self.prdb.PetStableFrame or self.initialized.PetStableFrame then return end
		self.initialized.PetStableFrame = true

		self:SecureHookScript(_G.PetStableFrame, "OnShow", function(this)

			self:makeMFRotatable(_G.PetStableModel)
			self:keepFontStrings(_G.PetStableCurrentPet)
			self:keepFontStrings(_G.PetStableStabledPet1)
			_G.PetStableStabledPet2:DisableDrawLayer("BACKGROUND")
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true, x1=10, y1=-11, x2=-32, y2=71}
			if self.modBtns then
				self:skinCloseButton{obj=_G.PetStableFrameCloseButton}
				self:skinStdButton{obj=_G.PetStablePurchaseButton}
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=_G.PetStableCurrentPet}
				local btn
				for i = 1, _G.NUM_PET_STABLE_SLOTS do
					btn = _G["PetStableStabledPet" .. i]
					self:addButtonBorder{obj=btn}
					self:SecureHook(_G["PetStableStabledPet" .. i .. "Background"], "SetVertexColor", function(this, ...)
						this:GetParent().sbb:SetBackdropBorderColor(...)
					end)
				end
				btn = nil
			end

		end)

	end

	aObj.blizzFrames[ftype].QuestFrame = function(self)
		if not self.prdb.QuestFrame or self.initialized.QuestFrame then return end
		self.initialized.QuestFrame = true

		for i = 1, _G.MAX_NUM_QUESTS do
			hookQuestText(_G["QuestTitleButton" .. i])
		end
		self:SecureHookScript(_G.QuestFrame, "OnShow", function(this)
			self:RawHook("QuestFrame_SetTitleTextColor", function(fontString, ...)
				fontString:SetTextColor(self.HT:GetRGB())
			end, true)
			self:RawHook("QuestFrame_SetTextColor", function(fontString, ...)
				fontString:SetTextColor(self.BT:GetRGB())
			end, true)

			self:addSkinFrame{obj=this, ft=ftype, kfs=true, x1=10, y1=-18, x2=-29, y2=65}

			--	Reward Panel
			self:keepFontStrings(_G.QuestFrameRewardPanel)
			self:skinSlider{obj=_G.QuestRewardScrollFrame.ScrollBar, rt="artwork"}

			--	Progress Panel
			self:keepFontStrings(_G.QuestFrameProgressPanel)
			_G.QuestProgressTitleText:SetTextColor(self.HT:GetRGB())
			_G.QuestProgressText:SetTextColor(self.BT:GetRGB())
			_G.QuestProgressRequiredMoneyText:SetTextColor(self.BT:GetRGB())
			_G.QuestProgressRequiredItemsText:SetTextColor(self.HT:GetRGB())
			self:skinSlider{obj=_G.QuestProgressScrollFrame.ScrollBar, rt="artwork"}
			local btnName
			for i = 1, _G.MAX_REQUIRED_ITEMS do
				btnName = "QuestProgressItem" .. i
				_G[btnName .. "NameFrame"]:SetTexture(nil)
				if self.modBtns then
					 self:addButtonBorder{obj=_G[btnName], libt=true}
				end
			end
			btnName = nil
			self:SecureHook("QuestFrameProgressItems_Update", function()
				local br, bg, bb = self.BT:GetRGB()
				local r, g ,b = _G.QuestProgressRequiredMoneyText:GetTextColor()
				-- if red colour is less than 0.2 then it needs to be coloured
				if r < 0.2 then
					_G.QuestProgressRequiredMoneyText:SetTextColor(br - r, bg - g, bb - b)
				end
				br, bg, bb, r, g, b = nil, nil, nil, nil, nil, nil
			end)

			--	Detail Panel
			self:keepFontStrings(_G.QuestFrameDetailPanel)
			self:skinSlider{obj=_G.QuestDetailScrollFrame.ScrollBar, rt="artwork"}

			--	Greeting Panel
			self:keepFontStrings(_G.QuestFrameGreetingPanel)
			self:keepFontStrings(_G.QuestGreetingScrollChildFrame) -- hide Horizontal Break texture
			self:skinSlider{obj=_G.QuestGreetingScrollFrame.ScrollBar, rt="artwork"}
			if _G.QuestFrameGreetingPanel:IsShown() then
				_G.GreetingText:SetTextColor(self.BT:GetRGB())
				_G.CurrentQuestsText:SetTextColor(self.HT:GetRGB())
				_G.AvailableQuestsText:SetTextColor(self.HT:GetRGB())
			end

			if self.modBtns then
				self:skinStdButton{obj=_G.QuestFrameCompleteQuestButton}
				self:skinStdButton{obj=_G.QuestFrameGoodbyeButton}
				self:skinStdButton{obj=_G.QuestFrameCompleteButton}
				self:skinStdButton{obj=_G.QuestFrameDeclineButton}
				self:skinStdButton{obj=_G.QuestFrameAcceptButton}
				self:skinStdButton{obj=_G.QuestFrameGreetingGoodbyeButton}
				self:skinStdButton{obj=_G.QuestFrameCancelButton}
			end

			self:Unhook(this, "OnShow")
		end)

		-- QuestNPCModel
		self:SecureHookScript(_G.QuestNPCModel, "OnShow", function(this)
			self:keepFontStrings(_G.QuestNPCModelTextFrame)
			self:skinSlider{obj=_G.QuestNPCModelTextScrollFrame.ScrollBar}
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, ofs=4, y2=-81} -- similar to GuildNewsBossModel
			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzLoDFrames[ftype].TrainerUI = function(self)
		if not self.prdb.TrainerUI or self.initialized.TrainerUI then return end
		self.initialized.TrainerUI = true

		self:SecureHookScript(_G.ClassTrainerFrame, "OnShow", function(this)
			self:skinDropDown{obj=_G.ClassTrainerFrameFilterDropDown}
			self:removeMagicBtnTex(_G.ClassTrainerTrainButton)
			if self.modBtns then
				 self:skinStdButton{obj=_G.ClassTrainerTrainButton}
				 self:skinStdButton{obj=_G.ClassTrainerCancelButton}
			end
			self:keepFontStrings(_G.ClassTrainerExpandButtonFrame)
			if self.modBtns then
				self:skinExpandButton{obj=_G.ClassTrainerCollapseAllButton, onSB=true}
				for i = 1, _G.CLASS_TRAINER_SKILLS_DISPLAYED do
					self:skinExpandButton{obj=_G["ClassTrainerSkill" .. i], onSB=true}
				end
				self:SecureHook("ClassTrainerFrame_Update", function()
					for i = 1, _G.CLASS_TRAINER_SKILLS_DISPLAYED do
						self:checkTex{obj=_G["ClassTrainerSkill" .. i]}
					end
				end)
			end
			_G.ClassTrainerSkillIcon:DisableDrawLayer("BACKGROUND")
			if self.modBtnBs then
				self:addButtonBorder{obj=_G.ClassTrainerSkillIcon}
			end
			self:skinSlider{obj=_G.ClassTrainerListScrollFrame.ScrollBar, rt="background"}
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, x1=10, y1=-11, x2=-31.5, y2=70}
			self:Unhook(this, "OnShow")
		end)

	end

	ftype = "p"
	aObj.blizzFrames[ftype].CharacterFrames = function(self)
		if not self.prdb.CharacterFrames or self.initialized.CharacterFrames then return end
		self.initialized.CharacterFrames = true

		self:skinTabs{obj=_G.CharacterFrame, lod=true}
		self:addSkinFrame{obj=_G.CharacterFrame, ft=ftype, kfs=true, x1=10, y1=-12, x2=-31, y2=71}

		self:keepFontStrings(_G.PaperDollFrame)
		self:makeMFRotatable(_G.CharacterModelFrame)
		_G.CharacterAttributesFrame:DisableDrawLayer("BACKGROUND")
		if self.modBtnBs then
			for i = 1, 5 do
				self:addButtonBorder{obj=_G["MagicResFrame" .. i], ofs=0, x1=1, y2=-2}
			end
			self:SecureHook("PaperDollItemSlotButton_Update", function(btn)
				local icon = btn.Icon or btn.icon or _G[btn:GetName() .. "IconTexture"]
				if not btn.hasItem then
					btn.sbb:SetBackdropBorderColor(0.498, 0.498, 0.498, 0.85) -- grey border, 85% alpha
					icon:SetTexture(nil)
				else
					btn.sbb:SetBackdropBorderColor(icon:GetVertexColor())
				end
			end)
		end
		for _, btn in pairs{_G.PaperDollItemsFrame:GetChildren()} do
			btn:DisableDrawLayer("BACKGROUND")
			if btn ~= _G.CharacterAmmoSlot then
				if self.modBtnBs then
					self:addButtonBorder{obj=btn, ibt=true, reParent={btn.ignoreTexture}, grey=true}
					-- force quality border update
					_G.PaperDollItemSlotButton_Update(btn)
				end
			else
				btn:DisableDrawLayer("OVERLAY")
				btn:GetNormalTexture():SetTexture(nil)
				btn:GetPushedTexture():SetTexture(nil)
				if self.modBtnBs then
					self:addButtonBorder{obj=btn, reParent={btn.Count, self:getRegion(btn, 4)}, grey=true}
				end
			end
		end

		self:SecureHookScript(_G.ReputationFrame, "OnShow", function(this)
			self:keepFontStrings(this)
			for i = 1, _G.NUM_FACTIONS_DISPLAYED do
				if self.modBtns then
					self:skinExpandButton{obj=_G["ReputationHeader" .. i], onSB=true}
				end
				self:removeRegions(_G["ReputationBar" .. i], {1, 2})
				self:skinStatusBar{obj=_G["ReputationBar" .. i], fi=0}
			end
			if self.modBtns then
				self:skinCloseButton{obj=_G.ReputationDetailCloseButton}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=_G.ReputationDetailAtWarCheckBox}
				self:skinCheckButton{obj=_G.ReputationDetailInactiveCheckBox}
				self:skinCheckButton{obj=_G.ReputationDetailMainScreenCheckBox}
			end
			self:addSkinFrame{obj=_G.ReputationDetailFrame, ft=ftype, kfs=true, x1=6, y1=-6, x2=-6, y2=6}

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.PetPaperDollFrame, "OnShow", function(this)
			self:keepFontStrings(this)
			self:keepFontStrings(_G.PetPaperDollFrameExpBar)
			self:skinStatusBar{obj=_G.PetPaperDollFrameExpBar, fi=0}
			self:makeMFRotatable(_G.PetModelFrame)
			-- TODO: PetPaperDollPetInfo
			_G.PetAttributesFrame:DisableDrawLayer("BACKGROUND")
			-- TODO: skin Resistance buttons (PetMagicResFrame1/2/3/4/5)
			if self.modBtns then
				self:skinStdButton{obj=_G.PetPaperDollCloseButton}
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.SkillFrame, "OnShow", function(this)
			self:keepFontStrings(this)
			_G.SkillFrameExpandButtonFrame:DisableDrawLayer("BACKGROUND")
			if self.modBtns then
				self:skinExpandButton{obj=_G.SkillFrameCollapseAllButton, onSB=true}
			end
			for i = 1, _G.SKILLS_TO_DISPLAY do
				if self.modBtns then
					 self:skinExpandButton{obj=_G["SkillTypeLabel"  .. i], onSB=true}
				end
				_G["SkillRankFrame"  .. i .. "Border"]:GetNormalTexture():SetTexture(nil)
				self:skinStatusBar{obj=_G["SkillRankFrame"  .. i], fi=0, bgTex=_G["SkillRankFrame"  .. i .. "Background"], otherTex={_G["SkillRankFrame"  .. i .. "FillBar"]}}
			end
			self:skinSlider{obj=_G.SkillListScrollFrame.ScrollBar, rt="artwork"}
			self:skinSlider{obj=_G.SkillDetailScrollFrame.ScrollBar, rt="artwork"}
			if self.modBtns then
				self:skinStdButton{obj=_G.SkillFrameCancelButton}
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.HonorFrame, "OnShow", function(this)
			self:keepFontStrings(this)
			self:skinStatusBar{obj=_G.HonorFrameProgressBar, fi=0}

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzLoDFrames[ftype].Communities = function(self)
		if not self.prdb.CommunitiesUI or self.initialized.CommunitiesUI then return end

		if not _G.CommunitiesFrame then
			_G.C_Timer.After(0.1, function()
				self.blizzLoDFrames[ftype].Communities(self)
			end)
			return
		end

		self.initialized.CommunitiesUI = true

		local function skinColumnDisplay(frame)
			frame:DisableDrawLayer("BACKGROUND")
			frame:DisableDrawLayer("BORDER")
			frame:DisableDrawLayer("ARTWORK")
			for header in frame.columnHeaders:EnumerateActive() do
				header:DisableDrawLayer("BACKGROUND")
				aObj:addSkinFrame{obj=header, ft=ftype}
			end
		end

		local cFrame = _G.CommunitiesFrame

		-->> N.B. Currently can't be skinned, as the XML has a ScopedModifier element saying forbidden="true"
			-- CommunitiesAddDialog
			-- CommunitiesCreateDialog

		self:keepFontStrings(cFrame.PortraitOverlay)

		cFrame.MaximizeMinimizeFrame:DisableDrawLayer("BACKGROUND")
		if self.modBtns then
			self:skinOtherButton{obj=cFrame.MaximizeMinimizeFrame.MaximizeButton, font=self.fontS, text="↕"}
			self:skinOtherButton{obj=cFrame.MaximizeMinimizeFrame.MinimizeButton, font=self.fontS, text="↕"}
		end

		self:SecureHookScript(cFrame.CommunitiesList, "OnShow", function(this)
			this:DisableDrawLayer("BORDER")
			this:DisableDrawLayer("ARTWORK")
			self:skinSlider{obj=this.ListScrollFrame.ScrollBar, wdth=-4}
			self:skinDropDown{obj=this.EntryDropDown}
			this.FilligreeOverlay:DisableDrawLayer("ARTWORK")
			this.FilligreeOverlay:DisableDrawLayer("OVERLAY")
			this.FilligreeOverlay:DisableDrawLayer("BORDER")
			self:removeInset(this.InsetFrame)
			for i = 1, #this.ListScrollFrame.buttons do
				self:removeRegions(this.ListScrollFrame.buttons[i], {1})
				self:changeRecTex(this.ListScrollFrame.buttons[i].Selection, true)
				this.ListScrollFrame.buttons[i].Selection:SetHeight(60)
				self:changeRecTex(this.ListScrollFrame.buttons[i]:GetHighlightTexture())
				this.ListScrollFrame.buttons[i]:GetHighlightTexture():SetHeight(60)
			end
			self:SecureHook(this, "Update", function(cList)
				for i = 1, #cList.ListScrollFrame.buttons do
					self:removeRegions(cList.ListScrollFrame.buttons[i], {1})
					self:changeRecTex(cList.ListScrollFrame.buttons[i].Selection, true)
					cList.ListScrollFrame.buttons[i].Selection:SetHeight(60)
				end
			end)
			self:Unhook(this, "OnShow")
		end)

		-- tabs on RHS
		for _, tabName in pairs{"ChatTab", "RosterTab"} do
			cFrame[tabName]:DisableDrawLayer("BORDER")
			if self.modBtnBs then
				self:addButtonBorder{obj=cFrame[tabName]}
			end
		end

		self:skinDropDown{obj=cFrame.StreamDropDownMenu}

		-- VoiceChatHeadset
		-- CommunitiesCalendarButton

		self:SecureHookScript(cFrame.MemberList.ColumnDisplay, "OnShow", function(this)
			skinColumnDisplay(this)
		end)
		if self.modChkBtns then
			 self:skinCheckButton{obj=cFrame.MemberList.ShowOfflineButton, hf=true}
		end
		self:skinSlider{obj=cFrame.MemberList.ListScrollFrame.scrollBar, wdth=-4}
		self:skinDropDown{obj=cFrame.MemberList.DropDown}
		self:removeInset(cFrame.MemberList.InsetFrame)

		self:skinSlider{obj=cFrame.Chat.MessageFrame.ScrollBar, wdth=-4}
		if self.modBtns then
			 self:skinStdButton{obj=_G.JumpToUnreadButton}
		end
		self:removeInset(cFrame.Chat.InsetFrame)

		self:skinEditBox{obj=cFrame.ChatEditBox, regs={6}} -- 6 is text

		self:SecureHookScript(cFrame.InvitationFrame, "OnShow", function(this)
			this:DisableDrawLayer("BACKGROUND")
			this:DisableDrawLayer("ARTWORK")
			self:removeInset(this.InsetFrame)
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true}
			if self.modBtns then
				self:skinStdButton{obj=this.AcceptButton}
				self:skinStdButton{obj=this.DeclineButton}
			end
			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(cFrame.EditStreamDialog, "OnShow", function(this)
			self:skinEditBox{obj=this.NameEdit, regs={6}} -- 6 is text
			this.NameEdit:SetPoint("TOPLEFT", this.NameLabel, "BOTTOMLEFT", -4, 0)
			self:addSkinFrame{obj=this.Description, ft=ftype, kfs=true, nb=true, ofs=7}
			self:skinCheckButton{obj=this.TypeCheckBox}
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true}
			self:skinStdButton{obj=this.Accept}
			self:skinStdButton{obj=this.Delete}
			self:skinStdButton{obj=this.Cancel}
			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(cFrame.NotificationSettingsDialog, "OnShow", function(this)
			self:skinDropDown{obj=this.CommunitiesListDropDownMenu}
			self:skinSlider{obj=this.ScrollFrame.ScrollBar, wdth=-4}
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true}
			if self.modBtns then
				self:skinStdButton{obj=this.ScrollFrame.Child.NoneButton}
				self:skinStdButton{obj=this.ScrollFrame.Child.AllButton}
				self:skinStdButton{obj=this.CancelButton}
				self:skinStdButton{obj=this.OkayButton}
			end
			if self.modChkBtns then
				 self:skinCheckButton{obj=this.ScrollFrame.Child.QuickJoinButton}
			end
			self:Unhook(this, "OnShow")
		end)

		self:moveObject{obj=cFrame.AddToChatButton, x=-6, y=-6}

		if self.modBtns then
			self:skinStdButton{obj=cFrame.AddToChatButton}
			self:skinStdButton{obj=cFrame.InviteButton}
			self:skinStdButton{obj=cFrame.CommunitiesControlFrame.CommunitiesSettingsButton}
		end

		self:addSkinFrame{obj=cFrame, ft=ftype, kfs=true, ri=true, x1=-5, x2=1, y2=-5}
		-- tabs
		cFrame.numTabs = 5
		self:skinTabs{obj=cFrame, lod=true}

		cFrame = nil

		self:SecureHookScript(_G.CommunitiesAvatarPickerDialog, "OnShow", function(this)
			self:skinSlider{obj=this.ScrollFrame.ScrollBar, rt="background"}
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true}
			if self.modBtns then
				self:skinStdButton{obj=this.CancelButton}
				self:skinStdButton{obj=this.OkayButton}
			end
			if self.modBtnBs then
				for i = 1, 5 do
					for j = 1, 6 do
						self:addButtonBorder{obj=this.ScrollFrame.avatarButtons[i][j]}
					end
				end
			end
			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.CommunitiesTicketManagerDialog, "OnShow", function(this)
			self:skinDropDown{obj=this.UsesDropDownMenu}
			this.InviteManager.ArtOverlay:DisableDrawLayer("OVERLAY")
			this.InviteManager.ListScrollFrame:DisableDrawLayer("BACKGROUND")
			self:skinSlider{obj=this.InviteManager.ListScrollFrame.scrollBar, wdth=-4}
			skinColumnDisplay(this.InviteManager.ColumnDisplay)
			if self.modBtns then
				for i = 1, #this.InviteManager.ListScrollFrame.buttons do
					self:skinStdButton{obj=this.InviteManager.ListScrollFrame.buttons[i].CopyLinkButton}
					if self.modBtnBs then
						 self:addButtonBorder{obj=this.InviteManager.ListScrollFrame.buttons[i].RevokeButton, ofs=0}
					end
				end
			end
			self:addSkinFrame{obj=this.InviteManager, ft=ftype, kfs=true, nb=true, x1=8, y1=-8, x2=-12, y2=-4}
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true, y1=-8, y2=6}
			if self.modBtns then
				self:skinStdButton{obj=this.LinkToChat}
				self:skinStdButton{obj=this.Copy}
				self:skinStdButton{obj=this.GenerateLinkButton}
				self:skinDropDown{obj=this.ExpiresDropDownMenu}
				self:skinStdButton{obj=this.Close}
			end
			if self.modBtnBs then
				 self:addButtonBorder{obj=this.MaximizeButton, ofs=0}
			end
			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.CommunitiesSettingsDialog, "OnShow", function(this)
			self:skinEditBox{obj=this.NameEdit, regs={6}} -- 6 is text
			self:skinEditBox{obj=this.ShortNameEdit, regs={6}} -- 6 is text
			self:addSkinFrame{obj=this.MessageOfTheDay, ft=ftype, kfs=true, nb=true, ofs=8}
			self:addSkinFrame{obj=this.Description, ft=ftype, kfs=true, nb=true, ofs=8}
			if self.modBtns then
				self:skinStdButton{obj=this.ChangeAvatarButton}
				self:skinStdButton{obj=this.Delete}
				self:skinStdButton{obj=this.Accept}
				self:skinStdButton{obj=this.Cancel}
			end
			self:addSkinFrame{obj=this, ft=ftype, nb=true, ofs=-10}
			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].CompactFrames = function(self)
		if IsAddOnLoaded("Tukui")
		or IsAddOnLoaded("ElvUI")
		then
			aObj.blizzFrames[ftype].CompactFrames = nil
			return
		end

		if not self.prdb.CompactFrames or self.initialized.CompactFrames then return end
		self.initialized.CompactFrames = true

		local function skinUnit(unit)

			-- handle Raid Profile changes and new unit(s)
			if aObj:hasTextInTexture(unit.healthBar:GetStatusBarTexture(), "RaidFrame") then
				unit:DisableDrawLayer("BACKGROUND")
				unit.horizDivider:SetTexture(nil)
				unit.horizTopBorder:SetTexture(nil)
				unit.horizBottomBorder:SetTexture(nil)
				unit.vertLeftBorder:SetTexture(nil)
				unit.vertRightBorder:SetTexture(nil)
				aObj:skinStatusBar{obj=unit.healthBar, fi=0, bgTex=unit.healthBar.background}
				aObj:skinStatusBar{obj=unit.powerBar, fi=0, bgTex=unit.powerBar.background}
			end

		end
		local function skinGrp(grp)

			local grpName = grp:GetName()
			for i = 1, _G.MEMBERS_PER_RAID_GROUP do
				skinUnit(_G[grpName .. "Member" .. i])
			end
			grpName = nil
			if not grp.borderFrame.sf then
				aObj:addSkinFrame{obj=grp.borderFrame, ft=ftype, kfs=true, y1=-1, x2=-3, y2=3}
			end

		end

		-- Compact Party Frame
		self:SecureHook("CompactPartyFrame_OnLoad", function()
			self:addSkinFrame{obj=_G.CompactPartyFrame.borderFrame, ft=ftype, kfs=true, y1=-1, x2=-3, y2=3}
			self:Unhook("CompactPartyFrame_OnLoad")
		end)
		-- hook this to skin any new CompactRaidGroup(s)
		self:SecureHook("CompactRaidGroup_UpdateLayout", function(frame)
			skinGrp(frame)
		end)

		-- Compact RaidFrame Container
		-- handle AddOn being disabled
		if not self:checkLoadable("Blizzard_CompactRaidFrames") then return end

		local function skinCRFCframes()

			-- handle in combat as UnitFrame uses SecureUnitButtonTemplate
			if _G.InCombatLockdown() then
				aObj:add2Table(aObj.oocTab, {skinCRFCframes, {nil}})
				return
			end

			for type, fTab in pairs(_G.CompactRaidFrameContainer.frameUpdateList) do
				local frame
				for i = 1, #fTab do
					frame = fTab[i]
					if type == "normal" then
						if frame.borderFrame then -- group or party
							skinGrp(frame)
						else
							skinUnit(frame)
						end
					elseif type == "mini" then
						skinUnit(frame)
					end
				end
				frame = nil
			end

		end
		-- hook this to skin any new CompactRaidFrameContainer entries
		self:SecureHook("FlowContainer_AddObject", function(container, object)
			if container == _G.CompactRaidFrameContainer then -- only for compact raid frame objects
				skinCRFCframes()
			end
		end)
		-- skin any existing unit(s) [mini, normal]
		skinCRFCframes()
		self:addSkinFrame{obj=_G.CompactRaidFrameContainer.borderFrame, ft=ftype, kfs=true, y1=-1, x2=-5, y2=5}

		-- Compact RaidFrame Manager
		self:SecureHookScript(_G.CompactRaidFrameManager, "OnShow", function(this)
			-- Toggle button
			self:moveObject{obj=this.toggleButton, x=5}
			this.toggleButton:SetSize(12, 32)
			this.toggleButton.nt = this.toggleButton:GetNormalTexture()
			this.toggleButton.nt:SetTexCoord(0.22, 0.5, 0.33, 0.67)
			-- hook this to trim the texture
			self:RawHook(this.toggleButton.nt, "SetTexCoord", function(this, x1, x2, y1, y2)
				self.hooks[this].SetTexCoord(this, x1 == 0 and x1 + 0.22 or x1 + 0.26, x2, 0.33, 0.67)
			end, true)

			-- Display Frame
			_G.CompactRaidFrameManagerDisplayFrameHeaderBackground:SetTexture(nil)
			_G.CompactRaidFrameManagerDisplayFrameHeaderDelineator:SetTexture(nil)
			-- Buttons
			for i = 1, 8 do
				self:skinStdButton{obj=this.displayFrame.filterOptions["filterGroup" .. i]}
			end
			this.displayFrame.filterOptions:DisableDrawLayer("BACKGROUND")
			self:skinDropDown{obj=this.displayFrame.profileSelector}
			self:skinStdButton{obj=this.displayFrame.lockedModeToggle}
			self:skinStdButton{obj=this.displayFrame.hiddenModeToggle}
			self:skinStdButton{obj=this.displayFrame.convertToRaid}
			-- Leader Options
			self:skinStdButton{obj=this.displayFrame.leaderOptions.readyCheckButton}
			if self.modChkBtns then
				self:skinCheckButton{obj=this.displayFrame.everyoneIsAssistButton}
				_G.RaiseFrameLevel(this.displayFrame.everyoneIsAssistButton) -- so button border is visible
			end
			-- Resize Frame
			self:addSkinFrame{obj=this.containerResizeFrame, ft=ftype, kfs=true, x1=-2, y1=-1, y2=4}
			-- Raid Frame Manager Frame
			self:addSkinFrame{obj=this, ft=ftype, kfs=true}

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.CompactRaidFrameManager)

	end

	aObj.blizzFrames[ftype].ContainerFrames = function(self)
		if not self.prdb.ContainerFrames.skin or self.initialized.ContainerFrames then return end
		self.initialized.ContainerFrames = true

		local objName
		local function skinBag(frame, id)

			frame.PortraitButton.Highlight:SetTexture(nil)
			aObj:addSkinFrame{obj=frame, ft=ftype, kfs=true, x1=8, y1=-4, x2=-3}
			-- resize and move the bag name to make it more readable
			objName = frame:GetName()
			_G[objName .. "Name"]:SetWidth(137)
			aObj:moveObject{obj=_G[objName .. "Name"], x=-17}

			if aObj.modBtnBs then
				-- skin the item buttons
				local bo
				for i = 1, _G.MAX_CONTAINER_ITEMS do
					bo = _G[objName .. "Item" .. i]
					aObj:addButtonBorder{obj=bo, ibt=true, reParent={_G[objName .. "Item" .. i .. "IconQuestTexture"], bo.JunkIcon, bo.UpgradeIcon, bo.flash, bo.NewItemTexture, bo.BattlepayItemTexture}}
				end
				bo = nil
				-- update Button quality borders
				_G.ContainerFrame_Update(frame)
			end

			objName = nil

		end

		self:SecureHook("ContainerFrame_GenerateFrame", function(frame, size, id)
			-- skin the frame if required
			if not frame.sf then
				skinBag(frame, id)
			end
		end)

		self:SecureHookScript(_G.BagHelpBox, "OnShow", function(this)
			self:skinCloseButton{obj=this.CloseButton, noSkin=true}
			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].FriendsFrame = function(self)
		if not self.prdb.FriendsFrame or self.initialized.FriendsFrame then return end
		self.initialized.FriendsFrame = true

		local function addTabFrame(frame)
			aObj:addSkinFrame{obj=frame, ft=ftype, kfs=true, nb=true, ofs=0, y1=-81, y2=-2, aso={bd=10, ng=true}}
		end

		self:SecureHookScript(_G.FriendsFrame, "OnShow", function(this)
			self:skinTabs{obj=this, lod=true}
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true, y2=-5}
			self:moveObject{obj=this.CloseButton, x=2}

			self:skinDropDown{obj=_G.FriendsDropDown}
			self:skinDropDown{obj=_G.TravelPassDropDown}

			self:SecureHookScript(_G.FriendsTabHeader, "OnShow", function(this)
				_G.FriendsFrameBattlenetFrame:DisableDrawLayer("BACKGROUND")
				if self.modBtnBs then
					self:addButtonBorder{obj=_G.FriendsFrameBattlenetFrame.BroadcastButton, ofs=-2}
				end
				self:addSkinFrame{obj=_G.FriendsFrameBattlenetFrame.BroadcastFrame.ScrollFrame, ft=ftype, kfs=true, nb=true, ofs=4}
				if self.modBtns then
					self:skinStdButton{obj=_G.FriendsFrameBattlenetFrame.BroadcastFrame.ScrollFrame.UpdateButton}
					self:skinStdButton{obj=_G.FriendsFrameBattlenetFrame.BroadcastFrame.ScrollFrame.CancelButton}
				end
				_G.FriendsFrameBattlenetFrame.BroadcastFrame.ScrollFrame.EditBox.PromptText:SetTextColor(self.BT:GetRGB())
				self:addSkinFrame{obj=_G.FriendsFrameBattlenetFrame.BroadcastFrame, ft=ftype, ofs=-10}
				self:addSkinFrame{obj=_G.FriendsFrameBattlenetFrame.UnavailableInfoFrame, ft=ftype}
				self:skinDropDown{obj=_G.FriendsFrameStatusDropDown}
				_G.FriendsFrameStatusDropDownStatus:SetAlpha(1) -- display status icon
				self:skinEditBox{obj=_G.FriendsFrameBroadcastInput, regs={6, 7}, mi=true, noWidth=true, noHeight=true, noMove=true} -- 6 is text, 7 is icon
				_G.FriendsFrameBroadcastInputFill:SetTextColor(self.BT:GetRGB())
				_G.PanelTemplates_SetNumTabs(this, 2) -- adjust for Friends & Ignore
				self:skinTabs{obj=this, up=true, lod=true, x1=0, y1=-5, x2=0, y2=-5}
				if self.modBtnBs then
					self:addButtonBorder{obj=_G.FriendsTabHeaderRecruitAFriendButton}
					self:addButtonBorder{obj=_G.FriendsTabHeaderSoRButton}
				end
				_G.RaiseFrameLevel(this)
				self:Unhook(this, "OnShow")
			end)
			self:checkShown(_G.FriendsTabHeader)

			self:SecureHookScript(_G.FriendsListFrame, "OnShow", function(this)
				if self.modBtns then
					self:skinStdButton{obj=_G.FriendsFrameAddFriendButton, x1=1}
					self:skinStdButton{obj=_G.FriendsFrameSendMessageButton}
					self:skinStdButton{obj=self:getChild(this.RIDWarning, 1)} -- unnamed parent frame
				end
				if self.modBtnBs then
					self:addButtonBorder{obj=_G.FriendsFrameFriendsScrollFrame.PendingInvitesHeaderButton}
				end
				_G.FriendsFrameFriendsScrollFrame.PendingInvitesHeaderButton.BG:SetTexture(nil)
				if self.modBtns then
					for invite in _G.FriendsFrameFriendsScrollFrame.invitePool:EnumerateActive() do
						self:skinStdButton{obj=invite.DeclineButton}
						self:skinStdButton{obj=invite.AcceptButton}
					end
				end
				self:skinSlider{obj=_G.FriendsFrameFriendsScrollFrame.scrollBar, rt="background"}
				-- adjust width of FFFSF so it looks right (too thin by default)
				_G.FriendsFrameFriendsScrollFrame.scrollBar:ClearAllPoints()
				_G.FriendsFrameFriendsScrollFrame.scrollBar:SetPoint("TOPRIGHT", "FriendsFrame", "TOPRIGHT", -8, -101)
				_G.FriendsFrameFriendsScrollFrame.scrollBar:SetPoint("BOTTOMLEFT", "FriendsFrame", "BOTTOMRIGHT", -24, 40)
				local btn
				for i = 1, _G.FRIENDS_FRIENDS_TO_DISPLAY do
					btn = _G["FriendsFrameFriendsScrollFrameButton" .. i]
					btn.background:SetAlpha(0)
					if self.modBtnBs then
						self:addButtonBorder{obj=btn, relTo=btn.gameIcon, ofs=0}
						self:SecureHook(btn.gameIcon, "Show", function(this)
							this:GetParent().sbb:Show()
						end)
						self:SecureHook(btn.gameIcon, "Hide", function(this)
							this:GetParent().sbb:Hide()
						end)
						self:SecureHook(btn.gameIcon, "SetShown", function(this, show)
							this:GetParent().sbb:SetShown(this, show)
						end)
						btn.sbb:SetShown(btn.gameIcon:IsShown())
						self:addButtonBorder{obj=btn.travelPassButton, ofs=0, y1=3, y2=-2}
						self:SecureHook(btn.travelPassButton, "Enable", function(this)
							this.sbb:SetBackdropBorderColor(self.bbClr:GetRGBA())
						end)
						self:SecureHook(btn.travelPassButton, "Disable", function(this)
							this.sbb:SetBackdropBorderColor(0.5, 0.5, 0.5)
						end)
						if not btn.travelPassButton:IsEnabled() then btn.travelPassButton.sbb:SetBackdropBorderColor(0.5, 0.5, 0.5, 1) end
						self:addButtonBorder{obj=btn.summonButton}
						self:SecureHook(btn.summonButton, "Enable", function(this)
							this.sbb:SetBackdropBorderColor(self.bbClr:GetRGBA())
						end)
						self:SecureHook(btn.summonButton, "Disable", function(this)
							this.sbb:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
						end)
						if not btn.summonButton:IsEnabled() then btn.summonButton.sbb:SetBackdropBorderColor(0.5, 0.5, 0.5) end
					end
				end
				btn = nil
				addTabFrame(this)
				self:Unhook(this, "OnShow")
			end)
			self:checkShown(_G.FriendsListFrame)

			self:SecureHookScript(_G.IgnoreListFrame, "OnShow", function(this)
				this:DisableDrawLayer("BACKGROUND")
				if self.modBtns then
					self:skinStdButton{obj=_G.FriendsFrameIgnorePlayerButton, x1=1}
					self:skinStdButton{obj=_G.FriendsFrameUnsquelchButton}
				end
				self:skinSlider{obj=_G.FriendsFrameIgnoreScrollFrame.ScrollBar}
				addTabFrame(this)
				self:Unhook(this, "OnShow")
			end)

			self:SecureHookScript(_G.WhoFrame, "OnShow", function(this)
				self:removeInset(_G.WhoFrameListInset)
				self:skinColHeads("WhoFrameColumnHeader")
				self:skinDropDown{obj=_G.WhoFrameDropDown}
				-- remove col head 2 as it is really a dropdown
				_G.WhoFrameColumnHeader2.sf.tfade:SetTexture(nil)
				_G.WhoFrameColumnHeader2.sf:SetBackdrop(nil)
				_G.WhoFrameColumnHeader2.sf:Hide()
				self:moveObject{obj=_G.WhoFrameColumnHeader4, x=4}
				if self.modBtns then
					self:skinStdButton{obj=_G.WhoFrameGroupInviteButton}
					self:skinStdButton{obj=_G.WhoFrameAddFriendButton}
					self:skinStdButton{obj=_G.WhoFrameWhoButton}
				end
				self:removeInset(_G.WhoFrameEditBoxInset)
				self:skinEditBox{obj=_G.WhoFrameEditBox}--, move=true}
				_G.WhoFrameEditBox:SetWidth(_G.WhoFrameEditBox:GetWidth() + 24)
				self:moveObject{obj=_G.WhoFrameEditBox, x=11, y=6}
				self:skinSlider{obj=_G.WhoListScrollFrame.ScrollBar, rt="background"}
				self:Unhook(this, "OnShow")
			end)

			-- tooltip
			_G.C_Timer.After(0.1, function()
				self:add2Table(self.ttList, _G.FriendsTooltip)
			end)

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.AddFriendFrame, "OnShow", function(this)
			if self.modBtns then
				self:skinStdButton{obj=_G.AddFriendInfoFrameContinueButton}
				self:skinStdButton{obj=_G.AddFriendEntryFrameAcceptButton}
				self:skinStdButton{obj=_G.AddFriendEntryFrameCancelButton}
			end
			self:skinEditBox{obj=_G.AddFriendNameEditBox, regs={6}} -- 6 is text
			self:skinSlider{obj=_G.AddFriendNoteFrameScrollFrame.ScrollBar}
			self:addSkinFrame{obj=_G.AddFriendNoteFrame, ft=ftype, kfs=true}
			self:addSkinFrame{obj=this, ft=ftype, kfs=true}
			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.FriendsFriendsFrame, "OnShow", function(this)
			self:skinDropDown{obj=_G.FriendsFriendsFrameDropDown}
			self:addSkinFrame{obj=_G.FriendsFriendsList, ft=ftype}
			self:skinSlider{obj=_G.FriendsFriendsScrollFrame.ScrollBar}
			if self.modBtns then
				self:skinStdButton{obj=_G.FriendsFriendsSendRequestButton}
				self:skinStdButton{obj=_G.FriendsFriendsCloseButton}
			end
			self:addSkinFrame{obj=this, ft=ftype}
			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.BattleTagInviteFrame, "OnShow", function(this)
			if self.modBtns then
				self:skinStdButton{obj=self:getChild(this, 1)} -- Send Request
				self:skinStdButton{obj=self:getChild(this, 2)} -- Cancel
			end
			self:addSkinFrame{obj=this, ft=ftype}
			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.RecruitAFriendFrame, "OnShow", function(this)
			self:skinEditBox{obj=_G.RecruitAFriendNameEditBox, regs={6}} -- 6 is text
			_G.RecruitAFriendNameEditBox.Fill:SetTextColor(self.BT:GetRGB())
			self:addSkinFrame{obj=_G.RecruitAFriendNoteFrame, ft=ftype, kfs=true}
			_G.RecruitAFriendNoteEditBox.Fill:SetTextColor(self.BT:GetRGB())
			self:skinStdButton{obj=_G.RecruitAFriendFrame.SendButton}
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, ofs=-6, y1=-7}
			-- RecruitAFriendSentFrame
			self:skinStdButton{obj=_G.RecruitAFriendSentFrame.OKButton}
			self:addSkinFrame{obj=_G.RecruitAFriendSentFrame, ft=ftype, ofs=-7, y2=4}
			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.ChannelFrame, "OnShow", function(this)
			self:removeInset(this.LeftInset)
			self:removeInset(this.RightInset)
			if self.modBtns then
				self:skinStdButton{obj=this.NewButton}
				self:skinStdButton{obj=this.SettingsButton}
				self:skinCloseButton{obj=this.Tutorial.CloseButton, noSkin=true}
			end
			self:skinSlider{obj=this.ChannelList.ScrollBar, wdth=-4}
			self:skinSlider{obj=this.ChannelRoster.ScrollFrame.scrollBar, wdth=-4}
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true, x1=-5, y2=-1}
			-- Create Channel Popup
			self:skinEditBox{obj=_G.CreateChannelPopup.Name, regs={6}} -- 6 is text
			self:skinEditBox{obj=_G.CreateChannelPopup.Password, regs={6}} -- 6 is text
			if self.modChkBtns then
				self:skinCheckButton{obj=_G.CreateChannelPopup.UseVoiceChat}
			end
			if self.modBtns then
				self:skinStdButton{obj=_G.CreateChannelPopup.OKButton}
				self:skinStdButton{obj=_G.CreateChannelPopup.CancelButton}
			end
			self:addSkinFrame{obj=_G.CreateChannelPopup, ft=ftype, kfs=true}
			self:Unhook(this, "OnShow")
		end)

		self:SecureHook(_G.ChannelFrame.ChannelList, "Update", function(this)
			for header in this.headerButtonPool:EnumerateActive() do
				header:GetNormalTexture():SetTexture(nil)
			end
			for textChannel in this.textChannelButtonPool:EnumerateActive() do
			end
			for voiceChannel in this.voiceChannelButtonPool:EnumerateActive() do
			end
			for communityChannel in this.communityChannelButtonPool:EnumerateActive() do
			end
		end)

		self:SecureHookScript(_G.VoiceChatPromptActivateChannel, "OnShow", function(this)
			self:skinCloseButton{obj=this.CloseButton, font=self.fontSBX, aso={bd=5, bba=0}, onSB=true, storeOnParent=true}
			self:skinStdButton{obj=this.AcceptButton}
			self:addSkinFrame{obj=this, ft=ftype, nb=true}
			self:hookSocialToastFuncs(this)
			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.VoiceChatChannelActivatedNotification, "OnShow", function(this)
			self:skinCloseButton{obj=this.CloseButton, font=self.fontSBX, aso={bd=5, bba=0}, onSB=true, storeOnParent=true}
			self:addSkinFrame{obj=this, ft=ftype, nb=true}
			self:hookSocialToastFuncs(this)
			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzLoDFrames[ftype].InspectUI = function(self)
		if not self.prdb.InspectUI or self.initialized.InspectUI then return end
		self.initialized.InspectUI = true

		self:SecureHookScript(_G.InspectFrame, "OnShow", function(this)
			self:skinTabs{obj=this, lod=true}
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, x1=10, y1=-12, x2=-31, y2=71}
			self:Unhook(this, "OnShow")

			-- send message when UI is skinned (used by oGlow skin)
			self:SendMessage("InspectUI_Skinned", self)
		end)

		self:SecureHookScript(_G.InspectPaperDollFrame, "OnShow", function(this)
			_G.InspectModelFrame:DisableDrawLayer("BACKGROUND")
			_G.InspectModelFrame:DisableDrawLayer("BORDER")
			_G.InspectModelFrame:DisableDrawLayer("OVERLAY")
			self:makeMFRotatable(_G.InspectModelFrame)
			this:DisableDrawLayer("BORDER")
			if self.modBtnBs then
				self:SecureHook("InspectPaperDollItemSlotButton_Update", function(btn)
					if not btn.hasItem then
						btn.sbb:SetBackdropBorderColor(0.498, 0.498, 0.498, 0.5) -- grey border, 50% alpha
						btn.icon:SetTexture(nil)
					end
				end)
			end
			for _, btn in ipairs{_G.InspectPaperDollItemsFrame:GetChildren()} do
				btn:DisableDrawLayer("BACKGROUND")
				if self.modBtnBs then
					self:addButtonBorder{obj=btn, ibt=true, grey=true}
				end
			end
			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.InspectHonorFrame, "OnShow", function(this)
			self:removeRegions(this, {1, 2, 3, 4, 5, 6, 7, 8})
			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].LootFrames = function(self)
		if not self.prdb.LootFrames.skin or self.initialized.LootFrames then return end
		self.initialized.LootFrames = true

		self:SecureHookScript(_G.LootFrame, "OnShow", function(this)
			for i = 1, _G.LOOTFRAME_NUMBUTTONS do
				_G["LootButton" .. i .. "NameFrame"]:SetTexture(nil)
				if self.modBtnBs then
					self:addButtonBorder{obj=_G["LootButton" .. i]}
				end
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=_G.LootFrameDownButton, ofs=-2}
				self:addButtonBorder{obj=_G.LootFrameUpButton, ofs=-2}
			end
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true, x2=1}

			if self.modBtnBs then
				self:SecureHook("LootFrame_Update", function()
					for i = 1, _G.LOOTFRAME_NUMBUTTONS do
						if _G["LootButton" .. i].quality then
							_G.SetItemButtonQuality(_G["LootButton" .. i], _G["LootButton" .. i].quality)
						end
					end
				end)
			end

			self:Unhook(this, "OnShow")
		end)

		local function skinGroupLoot(frame)

			aObj:keepFontStrings(frame)
			frame.Timer.Background:SetAlpha(0)
			aObj:skinStatusBar{obj=frame.Timer, fi=0}
			-- hook this to show the Timer
			aObj:SecureHook(frame, "Show", function(this)
				this.Timer:SetFrameLevel(this:GetFrameLevel() + 1)
			end)

			if aObj.prdb.LootFrames.size == 1 then
				frame.IconFrame.Border:SetAlpha(0)
				aObj:addSkinFrame{obj=frame, ft=ftype, x1=-3, y2=-3} -- adjust for Timer
			elseif aObj.prdb.LootFrames.size == 2 then
				frame.IconFrame.Border:SetAlpha(0)
				frame:SetScale(0.75)
				aObj:addSkinFrame{obj=frame, ft=ftype, x1=-3, y2=-3} -- adjust for Timer
			elseif aObj.prdb.LootFrames.size == 3 then
				frame:SetScale(0.75)
				aObj:moveObject{obj=frame.IconFrame, x=95, y=5}
				frame.Name:SetAlpha(0)
				frame.NeedButton:ClearAllPoints()
				frame.NeedButton:SetPoint("TOPRIGHT", "$parent", "TOPRIGHT", -34, -4)
				frame.PassButton:ClearAllPoints()
				frame.PassButton:SetPoint("LEFT", frame.NeedButton, "RIGHT", 0, 2)
				frame.GreedButton:ClearAllPoints()
				frame.GreedButton:SetPoint("RIGHT", frame.NeedButton, "LEFT")
				frame.DisenchantButton:ClearAllPoints()
				frame.DisenchantButton:SetPoint("RIGHT", frame.GreedButton, "LEFT", 2, 0)
				aObj:adjWidth{obj=frame.Timer, adj=-30}
				frame.Timer:ClearAllPoints()
				frame.Timer:SetPoint("BOTTOMRIGHT", "$parent", "BOTTOMRIGHT", -10, 13)
				aObj:addSkinFrame{obj=frame, ft=ftype, x1=97, y2=8}
			end

		end
		for i = 1, _G.NUM_GROUP_LOOT_FRAMES do
			self:SecureHookScript(_G["GroupLootFrame" .. i], "OnShow", function(this)
				skinGroupLoot(this)
				self:Unhook(this, "OnShow")
			end)
		end

		self:SecureHookScript(_G.MasterLooterFrame, "OnShow", function(this)
			this.Item.NameBorderLeft:SetTexture(nil)
			this.Item.NameBorderRight:SetTexture(nil)
			this.Item.NameBorderMid:SetTexture(nil)
			this.Item.IconBorder:SetTexture(nil)
			self:addButtonBorder{obj=this, relTo=this.Icon}
			this:DisableDrawLayer("BACKGROUND")
			self:skinCloseButton{obj=self:getChild(this, 3)} -- unamed close button
			self:addSkinFrame{obj=this, ft=ftype, kfs=true}
			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].MirrorTimers = function(self)
		if not self.prdb.MirrorTimers.skin or self.initialized.MirrorTimers then return end
		self.initialized.MirrorTimers = true

		local objName, obj, objBG, objSB
		for i = 1, _G.MIRRORTIMER_NUMTIMERS do
			objName = "MirrorTimer" .. i
			obj = _G[objName]
			objBG = self:getRegion(obj, 1)
			objSB = _G[objName .. "StatusBar"]
			self:removeRegions(obj, {3})
			obj:SetHeight(obj:GetHeight() * 1.25)
			self:moveObject{obj=_G[objName .. "Text"], y=-2}
			objBG:SetWidth(objBG:GetWidth() * 0.75)
			objSB:SetWidth(objSB:GetWidth() * 0.75)
			if self.prdb.MirrorTimers.glaze then
				self:skinStatusBar{obj=objSB, fi=0, bgTex=objBG}
			end
		end
		objName, obj, objBG, objSB = nil, nil, nil, nil

	end

	aObj.blizzLoDFrames[ftype].RaidUI = function(self)
		if not self.prdb.RaidUI or self.initialized.RaidUI then return end
		self.initialized.RaidUI = true

		local function skinPulloutFrames()

			for i = 1, _G.NUM_RAID_PULLOUT_FRAMES do
				if not _G["RaidPullout" .. i].sf then
					aObj:skinDropDown{obj=_G["RaidPullout" .. i .. "DropDown"]}
					_G["RaidPullout" .. i .. "MenuBackdrop"]:SetBackdrop(nil)
					aObj:addSkinFrame{obj=_G["RaidPullout" .. i], ft=ftype, kfs=true, x1=3, y1=-1, x2=-1, y2=1}
				end
			end

		end
		-- hook this to skin the pullout group frames
		self:SecureHook("RaidPullout_GetFrame", function(...)
			skinPulloutFrames()
		end)
		-- hook this to skin the pullout character frames
		self:SecureHook("RaidPullout_Update", function(pullOutFrame)
			local pfName = pullOutFrame:GetName()
			for i = 1, pullOutFrame.numPulloutButtons do
				if not _G[pfName .. "Button" .. i].sf then
					for _, bName in pairs{"HealthBar", "ManaBar", "Target", "TargetTarget"} do
						self:removeRegions(_G[pfName .. "Button" .. i .. bName], {2})
						self:skinStatusBar{obj=_G[pfName .. "Button" .. i .. bName], fi=0, bgTex=_G[pfName .. "Button" .. i .. bName .. "Background"]}
					end
					self:addSkinFrame{obj=_G[pfName .. "Button" .. i .. "TargetTargetFrame"], ft=ftype, x1=4, x2=-4, y2=2}
					self:addSkinFrame{obj=_G[pfName .. "Button" .. i], ft=ftype, kfs=true, x1=-4, y1=-6, x2=4, y2=-6}
				end
			end
			pfName = nil
		end)

		self:moveObject{obj=_G.RaidGroup1, x=2}

		-- Raid Groups
		for i = 1, _G.MAX_RAID_GROUPS do
			_G["RaidGroup" .. i]:DisableDrawLayer("BACKGROUND")
			self:addSkinFrame{obj=_G["RaidGroup" .. i], ft=ftype}
		end
		-- Raid Group Buttons
		for i = 1, _G.MAX_RAID_GROUPS * 5 do
			_G["RaidGroupButton" .. i]:SetNormalTexture(nil)
			self:addSkinFrame{obj=_G["RaidGroupButton" .. i], ft=ftype, aso={bd=5}}
		end
		-- Raid Class Tabs (side)
		for i = 1, _G.MAX_RAID_CLASS_BUTTONS do
			self:removeRegions(_G["RaidClassButton" .. i], {1}) -- 2 is icon, 3 is text
		end

		-- skin existing frames
		skinPulloutFrames()

		if self.modBtns then
			self:skinStdButton{obj=_G.RaidFrameReadyCheckButton}
		end

	end

	aObj.blizzFrames[ftype].SpellBookFrame = function(self)
		if not self.prdb.SpellBookFrame or self.initialized.SpellBookFrame then return end
		self.initialized.SpellBookFrame = true

		self:SecureHookScript(_G.SpellBookFrame, "OnShow", function(this)

			this.numTabs = 3
			self:skinTabs{obj=this, suffix="Button", regs={1}, lod=true, x1=10, y1=-12, x2=-31, y2=50}
			if self.isTT then
				local function setTab(bookType)
					local tab
					for i = 1, this.numTabs do
						tab = _G["SpellBookFrameTabButton" .. i]
						if tab.bookType == bookType then
							self:setActiveTab(tab.sf)
						else
							self:setInactiveTab(tab.sf)
						end
					end
					tab = nil

				end
				-- hook to handle tabs
				self:SecureHook("ToggleSpellBook", function(bookType)
					setTab(bookType)
				end)
				-- set correct tab
				setTab(this.bookType)
			end
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, x1=10, y1=-12, x2=-31, y2=50}
			if self.modBtns then
				self:skinCloseButton{obj=_G.SpellBookCloseButton}
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=_G.SpellBookPrevPageButton, ofs=-2, y1=-3, x2=-3}
				self:addButtonBorder{obj=_G.SpellBookNextPageButton, ofs=-2, y1=-3, x2=-3}
			end

			-- Spellbook Panel
			local function updBtn(btn)

	            -- handle in combat
	            if _G.InCombatLockdown() then
	                aObj:add2Table(aObj.oocTab, {updBtn, {btn}})
	                return
	            end

				if aObj.modBtnBs
				and btn.sbb -- allow for not skinned during combat
				then
					if not btn:IsEnabled() then
						btn.sbb:Hide()
					else
						btn.sbb:Show()
					end
				end
				local spellString, subSpellString = _G[btn:GetName() .. "SpellName"], _G[btn:GetName() .. "SubSpellName"]
				if _G[btn:GetName() .. "IconTexture"]:IsDesaturated() then -- player level too low, see Trainer, or offSpec
					if btn.sbb then btn.sbb:SetBackdropBorderColor(0.5, 0.5, 0.5, 0.75) end
					spellString:SetTextColor(_G.DISABLED_FONT_COLOR:GetRGB())
					subSpellString:SetTextColor(_G.DISABLED_FONT_COLOR:GetRGB())
				else
					if btn.sbb then btn.sbb:SetBackdropBorderColor(aObj.bbClr:GetRGBA()) end
					spellString:SetTextColor(aObj.HT:GetRGB())
					subSpellString:SetTextColor(aObj.BT:GetRGB())
				end
				spellString, subSpellString = nil, nil
			end

			_G.SpellBookPageText:SetTextColor(self.BT:GetRGB())
			local btn
			for i = 1, _G.SPELLS_PER_PAGE do
				btn = _G["SpellButton" .. i]
				btn:DisableDrawLayer("BACKGROUND")
				btn:GetNormalTexture():SetAlpha(0)
				btn:GetPushedTexture():SetAlpha(0)
				if self.modBtnBs then
					self:addButtonBorder{obj=btn, sec=true, reParent={_G["SpellButton" .. i .. "AutoCastable"]}}
				end
				updBtn(btn)
			end
			btn = nil

			-- hook this to change text colour as required
			self:SecureHook("SpellButton_UpdateButton", function(this)
				updBtn(this)
			end)

			-- Tabs (side)
			for i = 1, _G.MAX_SKILLLINE_TABS do
				self:removeRegions(_G["SpellBookSkillLineTab" .. i], {1}) -- N.B. other regions are icon and highlight
				self:addButtonBorder{obj=_G["SpellBookSkillLineTab" .. i]}
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].StackSplit = function(self)
		if not self.prdb.StackSplit or self.initialized.StackSplit then return end
		self.initialized.StackSplit = true

		self:SecureHookScript(_G.StackSplitFrame, "OnShow", function(this)
			-- handle different addons being loaded
			if IsAddOnLoaded("EnhancedStackSplit") then
				if _G.Round(_G.EnhancedStackSplitBottomTextureFrame:GetHeight()) == 30 then
					self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true, y2=-45}
				else
					self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true, y2=-24}
				end
			else
				self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true, x1=9, y1=-12, x2=-6, y2=12}
			end
			if self.modBtns then
				self:skinStdButton{obj=_G.StackSplitOkayButton}
				self:skinStdButton{obj=_G.StackSplitCancelButton}
			end
			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzLoDFrames[ftype].TradeSkillUI = function(self)
		if not self.prdb.TradeSkillUI or self.initialized.TradeSkillUI then return end
		self.initialized.TradeSkillUI = true

		self:SecureHookScript(_G.TradeSkillFrame, "OnShow", function(this)

			self:skinStatusBar{obj=_G.TradeSkillRankFrame, fi=0, bgTex=_G.TradeSkillRankFrameBackground}
			_G.TradeSkillRankFrameBorder:GetNormalTexture():SetTexture(nil)
			self:keepFontStrings(_G.TradeSkillExpandButtonFrame)
			self:skinDropDown{obj=_G.TradeSkillInvSlotDropDown}
			self:skinDropDown{obj=_G.TradeSkillSubClassDropDown}
			self:skinSlider{obj=_G.TradeSkillListScrollFrame.ScrollBar}
			self:skinSlider{obj=_G.TradeSkillDetailScrollFrame.ScrollBar}
			self:keepFontStrings(_G.TradeSkillDetailScrollChildFrame)
			local btnName
			for i = 1, _G.MAX_TRADE_SKILL_REAGENTS do
				btnName = "TradeSkillReagent" .. i
				_G[btnName .. "NameFrame"]:SetTexture(nil)
				if self.modBtns then
					 self:addButtonBorder{obj=_G[btnName], libt=true}
				end
			end
			btnName = nil
			self:skinEditBox{obj=_G.TradeSkillInputBox, regs={6}, x=-6} -- 6 is text
			self:addSkinFrame{obj=_G.TradeSkillFrame, ft=ftype, kfs=true, nb=true, x1=10, y1=-11, x2=-32, y2=70}
			if self.modBtns then
				self:skinExpandButton{obj=_G.TradeSkillCollapseAllButton, onSB=true}
				for i = 1, _G.TRADE_SKILLS_DISPLAYED do
					self:skinExpandButton{obj=_G["TradeSkillSkill" .. i], onSB=true}
				end
				self:skinCloseButton{obj=_G.TradeSkillFrameCloseButton}
				self:skinStdButton{obj=_G.TradeSkillCreateButton}
				self:skinStdButton{obj=_G.TradeSkillCancelButton}
				self:skinStdButton{obj=_G.TradeSkillCreateAllButton}
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=_G.TradeSkillSkillIcon}
				self:addButtonBorder{obj=_G.TradeSkillDecrementButton, ofs=0}
				self:addButtonBorder{obj=_G.TradeSkillIncrementButton, ofs=0}
			end

			self:Unhook(this, "OnShow")

		end)

	end

	ftype = "u"
	aObj.blizzFrames[ftype].ChatButtons = function(self)
		if not self.prdb.ChatButtons or self.initialized.ChatButtons then return end
		self.initialized.ChatButtons = true

		-- QuickJoinToastButton & frames (attached to ChatFrame)
		if self.modBtnBs then
			for i = 1, _G.NUM_CHAT_WINDOWS do
				self:addButtonBorder{obj=_G["ChatFrame" .. i].buttonFrame.minimizeButton, ofs=-2}
				self:addButtonBorder{obj=_G["ChatFrame" .. i].ScrollToBottomButton, ofs=-1, reParent={_G["ChatFrame" .. i].ScrollToBottomButton.Flash}}
				self:addButtonBorder{obj=_G["ChatFrame" .. i].buttonFrame.bottomButton, ofs=-2}
				self:addButtonBorder{obj=_G["ChatFrame" .. i].buttonFrame.downButton, ofs=-2}
				self:addButtonBorder{obj=_G["ChatFrame" .. i].buttonFrame.upButton, ofs=-2}
			end
			self:addButtonBorder{obj=_G.ChatFrameChannelButton, ofs=0}
			self:addButtonBorder{obj=_G.ChatFrameMenuButton, ofs=-2}
		end

	end

	aObj.blizzFrames[ftype].ItemText = function(self)
		if not self.prdb.ItemText or self.initialized.ItemText then return end
		self.initialized.ItemText = true

		self:SecureHookScript(_G.ItemTextFrame, "OnShow", function(this)
			_G.ItemTextPageText:SetTextColor(self.BT:GetRGB())
			_G.ItemTextPageText:SetTextColor("P", self.BT:GetRGB())
			_G.ItemTextPageText:SetTextColor("H1", self.HT:GetRGB())
			_G.ItemTextPageText:SetTextColor("H2", self.HT:GetRGB())
			_G.ItemTextPageText:SetTextColor("H3", self.HT:GetRGB())

			if not this.sf then
				self:skinSlider{obj=_G.ItemTextScrollFrame.ScrollBar, wdth=-4}
				self:skinStatusBar{obj=_G.ItemTextStatusBar, fi=0}
				self:moveObject{obj=_G.ItemTextPrevPageButton, x=-55} -- move prev button left
				self:addButtonBorder{obj=_G.ItemTextPrevPageButton, ofs=-2, y1=-3, x2=-3}
				self:addButtonBorder{obj=_G.ItemTextNextPageButton, ofs=-2, y1=-3, x2=-3}
				_G.ItemTextScrollFrame:DisableDrawLayer("BACKGROUND")
				_G.ItemTextScrollFrame:DisableDrawLayer("ARTWORK")
				self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true, x1=10, y1=-12, x2=-31, y2=60}
				if self.modBtns then
					self:skinCloseButton{obj=_G.ItemTextCloseButton}
				end
			end
		end)

	end

	aObj.blizzFrames[ftype].MainMenuBar = function(self)
		if IsAddOnLoaded("Dominos") then
			aObj.blizzFrames[ftype].MainMenuBar = nil
			return
		end

		if self.initialized.MainMenuBar then return end
		self.initialized.MainMenuBar = true

		if self.prdb.MainMenuBar.skin then

			_G.MainMenuBarArtFrame:DisableDrawLayer("BACKGROUND")
			_G.MainMenuBarLeftEndCap:SetTexture(nil)
			_G.MainMenuBarRightEndCap:SetTexture(nil)
			_G.MainMenuExpBar:DisableDrawLayer("OVERLAY")
			_G.ExhaustionTick:GetNormalTexture():SetTexture(nil)
			_G.ExhaustionTick:GetHighlightTexture():SetTexture(nil)
			self:skinStatusBar{obj=_G.MainMenuExpBar, fi=0, bgTex=self:getRegion(_G.MainMenuExpBar, 6), otherTex={_G.ExhaustionLevelFillBar}}
			self:moveObject{obj=_G.MainMenuExpBar, y=2}
			-- MainMenuBarMaxLevelBar
			-- MainMenuBarPerformanceBarFrameButton

			-- StanceBar Frame
			self:keepFontStrings(_G.StanceBarFrame)
			-- Pet Action Bar Frame
			self:keepFontStrings(_G.PetActionBarFrame)

			if self.modBtnBs then
				for i = 1, _G.NUM_STANCE_SLOTS do
					self:addButtonBorder{obj=_G["StanceButton" .. i], abt=true, sec=true}
				end
				for i = 1, _G.NUM_PET_ACTION_SLOTS do
					self:addButtonBorder{obj=_G["PetActionButton" .. i], abt=true, sec=true, reParent={_G["PetActionButton" .. i .. "AutoCastable"], _G["PetActionButton" .. i .. "SpellHighlightTexture"]}, ofs=3}
					_G["PetActionButton" .. i .. "Shine"]:SetParent(_G["PetActionButton" .. i].sbb)
				end
				-- Action Buttons
				for i = 1, _G.NUM_ACTIONBAR_BUTTONS do
					_G["ActionButton" .. i].FlyoutBorder:SetTexture(nil)
					_G["ActionButton" .. i].FlyoutBorderShadow:SetTexture(nil)
					self:addButtonBorder{obj=_G["ActionButton" .. i], abt=true, seca=true}
				end
				-- ActionBar buttons
				self:addButtonBorder{obj=_G.ActionBarUpButton, ofs=-4}
				self:addButtonBorder{obj=_G.ActionBarDownButton, ofs=-4}

				-- Micro buttons
				local mBut
				for i = 1, #_G.MICRO_BUTTONS do
					mBut = _G[_G.MICRO_BUTTONS[i]]
					self:addButtonBorder{obj=mBut, ofs=0, y1=-20, reParent=mBut == "MainMenuMicroButton" and {mBut.Flash, _G.MainMenuBarDownload} or {mBut.Flash}}
				end
				mBut = nil

				-- skin bag buttons
				self:addButtonBorder{obj=_G.MainMenuBarBackpackButton, ibt=true}
				self:addButtonBorder{obj=_G.CharacterBag0Slot, ibt=true}
				self:addButtonBorder{obj=_G.CharacterBag1Slot, ibt=true}
				self:addButtonBorder{obj=_G.CharacterBag2Slot, ibt=true}
				self:addButtonBorder{obj=_G.CharacterBag3Slot, ibt=true}

				-- MultiBar Buttons
				for _, type in pairs{"BottomLeft", "BottomRight", "Right", "Left"} do
					local btn
					for i = 1, _G.NUM_MULTIBAR_BUTTONS do
						btn = _G["MultiBar" .. type .. "Button" .. i]
						btn.FlyoutBorder:SetTexture(nil)
						btn.FlyoutBorderShadow:SetTexture(nil)
						btn.Border:SetAlpha(0) -- texture changed in blizzard code
						if not btn.noGrid then
							_G[btn:GetName() .. "FloatingBG"]:SetAlpha(0)
						end
						self:addButtonBorder{obj=btn, abt=true, seca=true}
					end
					btn = nil
				end

			end

		end

		-- these are done here as other AddOns may require them to be skinned
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.MainMenuBarVehicleLeaveButton}
		end

	end

	aObj.blizzFrames[ftype].Minimap = function(self)
		if IsAddOnLoaded("SexyMap") then
			aObj.blizzFrames[ftype].Minimap = nil
			return
		end

		if not self.prdb.Minimap.skin or self.initialized.Minimap then return end
		self.initialized.Minimap = true

		-- fix for Titan Panel moving MinimapCluster
		if IsAddOnLoaded("Titan") then _G.TitanMovable_AddonAdjust("MinimapCluster", true) end

		-- Cluster Frame
		_G.MinimapBorderTop:Hide()
		_G.MinimapZoneTextButton:ClearAllPoints()
		_G.MinimapZoneTextButton:SetPoint("BOTTOMLEFT", _G.Minimap, "TOPLEFT", 0, 5)
		_G.MinimapZoneTextButton:SetPoint("BOTTOMRIGHT", _G.Minimap, "TOPRIGHT", 0, 5)
		_G.MinimapZoneText:ClearAllPoints()
		_G.MinimapZoneText:SetPoint("CENTER")
		self:addSkinButton{obj=_G.MinimapZoneTextButton, parent=_G.MinimapZoneTextButton, ft=ftype, x1=-5, x2=5}
		if self.modBtns then
			_G.RaiseFrameLevelByTwo(_G.MinimapToggleButton)
			self:moveObject{obj=_G.MinimapToggleButton, x=-8, y=1}
			self:skinCloseButton{obj=_G.MinimapToggleButton, noSkin=true}
		end
		-- World Map Button
		_G.MiniMapWorldMapButton:ClearAllPoints()
		_G.MiniMapWorldMapButton:SetPoint("LEFT", _G.MinimapZoneTextButton, "RIGHT", -4, 0)
		self:skinOtherButton{obj=_G.MiniMapWorldMapButton, font=self.fontP, text="M"}

		-- Minimap
		_G.Minimap:SetMaskTexture([[Interface\Buttons\WHITE8X8]]) -- needs to be a square texture
		-- use a backdrop with no Texture otherwise the map tiles are obscured
		self:addSkinFrame{obj=_G.Minimap, ft=ftype, aso={bd=8}, ofs=5}
		if self.prdb.Minimap.gloss then
			_G.RaiseFrameLevel(_G.Minimap.sf)
		else
			_G.LowerFrameLevel(_G.Minimap.sf)
		end

		-- Minimap Backdrop Frame
		self:keepFontStrings(_G.MinimapBackdrop)

		-- Buttons
		-- on LHS
		local yOfs = -18 -- allow for GM Ticket button
		local function skinmmBut(name)
			if _G["MiniMap" .. name] then
				_G["MiniMap" .. name]:ClearAllPoints()
				_G["MiniMap" .. name]:SetPoint("TOPRIGHT", _G.Minimap, "TOPLEFT", 0, yOfs)
				yOfs = yOfs - _G["MiniMap" .. name]:GetHeight() + 3
			end
		end
		skinmmBut("Tracking")
		skinmmBut("VoiceChatFrame")
		yOfs = nil
		-- on RHS
		_G.MiniMapMailFrame:ClearAllPoints()
		_G.MiniMapMailFrame:SetPoint("LEFT", _G.Minimap, "RIGHT", -10, 28)
		_G.MinimapZoomIn:ClearAllPoints()
		_G.MinimapZoomIn:SetPoint("BOTTOMLEFT", _G.Minimap, "BOTTOMRIGHT", -4, -3)
		_G.MinimapZoomOut:ClearAllPoints()
		_G.MinimapZoomOut:SetPoint("TOPRIGHT", _G.Minimap, "BOTTOMRIGHT", 3, 4)

		-- move BuffFrame
		self:moveObject{obj=_G.BuffFrame, x=-40}

		-- hook this to handle Jostle Library
		if _G.LibStub:GetLibrary("LibJostle-3.0", true) then
			self:RawHook(_G.MinimapCluster, "SetPoint", function(this, point, relTo, relPoint, xOfs, yOfs)
				self.hooks[this].SetPoint(this, point, relTo, relPoint, -6, -18)
			end, true)
		end

	end

	aObj.blizzFrames[ftype].MinimapButtons = function(self)
		if not self.prdb.MinimapButtons.skin or self.initialized.MinimapButtons then return end
		self.initialized.MinimapButtons = true

		local minBtn = self.prdb.MinimapButtons.style
		local asopts = {ba=minBtn and 0 or 1, bba=minBtn and 0 or 1, ng=minBtn and true or nil}

		local function mmKids(mmObj)

			local objName, objType
			for _, obj in ipairs{mmObj:GetChildren()} do
				objName, objType = obj:GetName(), obj:GetObjectType()
				if not obj.sb
				and not obj.sf
				and not objName == "QueueStatusMinimapButton" -- ignore QueueStatusMinimapButton
				and not objName == "OQ_MinimapButton" -- ignore oQueue's minimap button
				and objType == "Button"
				or (objType == "Frame" and objName == "MiniMapMailFrame")
				then
					for _, reg in ipairs{obj:GetRegions()} do
						if reg:GetObjectType() == "Texture" then
							-- change the DrawLayer to make the Icon show if required
							if aObj:hasTextInName(reg, "[Ii]con")
							or aObj:hasTextInTexture(reg, "[Ii]con")
							then
								if reg:GetDrawLayer() == "BACKGROUND" then reg:SetDrawLayer("ARTWORK") end
								-- centre the icon
								reg:ClearAllPoints()
								reg:SetPoint("CENTER")
							elseif aObj:hasTextInName(reg, "Border")
							or aObj:hasTextInTexture(reg, "TrackingBorder")
							then
								reg:SetTexture(nil)
							elseif aObj:hasTextInTexture(reg, "Background") then
								reg:SetTexture(nil)
							end
						end
					end
					if not minBtn then
						if objType == "Button" then
							aObj:addSkinButton{obj=obj, parent=obj, sap=true, ft=ftype}
						else
							aObj:addSkinFrame{obj=obj, ft=ftype}
						end
					end
				elseif objType == "Frame"
				and (objName
				and not objName == "MiniMapTrackingButton") -- handled below
				then
					mmKids(obj)
				end
			end
			objName, objType = nil, nil

		end
		local function makeBtnSquare(obj, x1, y1, x2, y2)

			obj:SetSize(26, 26)
			obj:GetNormalTexture():SetTexCoord(x1, y1, x2, y2)
			obj:GetPushedTexture():SetTexCoord(x1, y1, x2, y2)
			obj:SetHighlightTexture([[Interface\Buttons\ButtonHilight-Square]])
			aObj:addSkinFrame{obj=obj, ft=ftype, aso=asopts, ofs=4}
			-- make sure textures appear above skinFrame
			_G.RaiseFrameLevelByTwo(obj)
			_G.LowerFrameLevel(obj.sf)
			-- alter the HitRectInsets to make it easier to activate
			obj:SetHitRectInsets(-5, -5, -5, -5)

		end

		-- skin Minimap children, allow for delayed addons to be loaded (e.g. Baggins)
		_G.C_Timer.After(0.5, function() mmKids(_G.Minimap) end)

		-- GameTimeFrame button
		-- TODO: make texture square and add button border

		_G.MiniMapMailIcon:SetTexture([[Interface\Minimap\Tracking\Mailbox.blp]])
		_G.MiniMapMailFrame:SetSize(26, 26)

		-- MinimapBackdrop
		local function skinZoom(obj)
			obj:GetNormalTexture():SetTexture(nil)
			obj:GetPushedTexture():SetTexture(nil)
			if minBtn then
				obj:GetDisabledTexture():SetTexture([[Interface\Minimap\UI-Minimap-Background]])
			else
				obj:GetDisabledTexture():SetTexture(nil)
			end
			aObj:adjWidth{obj=obj, adj=-8}
			aObj:adjHeight{obj=obj, adj=-8}
			aObj:addSkinButton{obj=obj, parent=obj, aso=asopts, ft=ftype}
			obj.sb:SetAllPoints(obj:GetNormalTexture())
			obj.sb:SetNormalFontObject(aObj.modUIBtns.fontX)
			obj.sb:SetDisabledFontObject(aObj.modUIBtns.fontDX)
			obj.sb:SetPushedTextOffset(1, 1)
			if not obj:IsEnabled() then obj.sb:Disable() end
		end
		skinZoom(_G.MinimapZoomIn)
		_G.MinimapZoomIn.sb:SetText(self.modUIBtns.plus)
		skinZoom(_G.MinimapZoomOut)
		_G.MinimapZoomOut.sb:SetText(self.modUIBtns.minus)

		-- skin any moved Minimap buttons if required
		if IsAddOnLoaded("MinimapButtonFrame") then mmKids(_G.MinimapButtonFrame) end

		-- show the Bongos minimap icon if required
		if IsAddOnLoaded("Bongos") then _G.Bongos3MinimapButton.icon:SetDrawLayer("ARTWORK") end

		-- skin other minimap buttons as required
		if not minBtn then
			local function skinMMBtn(cb, btn, name)
				-- aObj:Debug("skinMMBtn#1: [%s, %s, %s]", cb, btn, name)
				for _, reg in ipairs{btn:GetRegions()} do
					if reg:GetObjectType() == "Texture" then
						-- aObj:Debug("skinMMBtn#2: [%s, %s, %s]", reg, reg:GetName(), reg:GetTexture())
						if aObj:hasTextInName(reg, "Border")
						or aObj:hasTextInTexture(reg, "TrackingBorder")
						or aObj:hasTextInTexture(reg, "136430") -- file ID for Border texture
						then
							reg:SetTexture(nil)
						end
					end
				end

				aObj:addSkinButton{obj=btn, parent=btn, sap=true}

			end
			-- wait until all AddOn skins have been loaded
			_G.C_Timer.After(0.5, function()
				for addon, obj in pairs(self.mmButs) do
					if IsAddOnLoaded(addon) then
						skinMMBtn("Loaded Addons btns", obj)
					end
				end
				self.mmButs = nil
			end)

			-- skin existing LibDBIcon buttons
			for name, button in pairs(_G.LibStub:GetLibrary("LibDBIcon-1.0").objects) do
				skinMMBtn("Existing LibDBIcon btns", button, name)
			end
			-- skin LibDBIcon Minimap Buttons when created
			self.DBIcon.RegisterCallback(self, "LibDBIcon_IconCreated", skinMMBtn)
		end

	end

	aObj.blizzFrames[ftype].NamePlates = function(self)
		if not self.prdb.Nameplates or self.initialized.Nameplates then return end
		self.initialized.Nameplates = true

		local function skinNamePlate(frame)
			local nP = frame.UnitFrame
			if nP then
				-- healthBar
				aObj:skinStatusBar{obj=nP.healthBar, fi=0, bgTex=nP.healthBar.background}
				nP.healthBar.border:DisableDrawLayer("ARTWORK")
			end
			nP = nil
		end

		-- skin any existing NamePlates
		for _, frame in ipairs(_G.C_NamePlate.GetNamePlates(_G.issecure())) do
			skinNamePlate(frame)
		end

		-- hook this to skin created Nameplates
		self:SecureHook(_G.NamePlateDriverFrame, "OnNamePlateAdded", function(this, namePlateUnitToken)
			local namePlateFrameBase = _G.C_NamePlate.GetNamePlateForUnit(namePlateUnitToken, _G.issecure())
			-- aObj:Debug("NPDF OnNamePlateAdded: [%s, %s, %s]", namePlateUnitToken, namePlateFrameBase, issecure())
			skinNamePlate(namePlateFrameBase)
		end)

		-- Class Nameplate Frames
		-- ManaFrame
		local mF = _G.ClassNameplateManaBarFrame
		if mF then
			self:skinStatusBar{obj=mF, fi=0,  otherTex={mF.ManaCostPredictionBar, mF.FeedbackFrame.BarTexture}}--, nilFuncs=true}
			mF = nil
		end

		-- tooltip
		_G.C_Timer.After(0.1, function()
			self:add2Table(self.ttList, _G.NamePlateTooltip)
		end)

	end

	aObj.blizzFrames[ftype].QuestLog = function(self)
		if not self.prdb.QuestLog or self.initialized.QuestLog then return end
		self.initialized.QuestLog = true

		self:SecureHookScript(_G.QuestLogFrame, "OnShow", function(this)

			_G.QuestLogCollapseAllButton:DisableDrawLayer("BACKGROUND")
			self:keepFontStrings(_G.EmptyQuestLogFrame)
			if self.modBtns then
				self:skinExpandButton{obj=_G.QuestLogCollapseAllButton, onSB=true}
				for i = 1, _G.QUESTS_DISPLAYED do
					self:skinExpandButton{obj=_G["QuestLogTitle" .. i], onSB=true}
					self:checkTex{obj=_G["QuestLogTitle" .. i]}
				end
				self:SecureHook("QuestLog_Update", function(this)
					for i = 1, _G.QUESTS_DISPLAYED do
						self:checkTex{obj=_G["QuestLogTitle" .. i]}
					end
				end)
			end
			-- TODO: _G["QuestLogTitle" .. i .. "Check"] texture

			self:skinSlider{obj=_G.QuestLogListScrollFrame.ScrollBar}
			self:skinSlider{obj=_G.QuestLogDetailScrollFrame.ScrollBar}

			_G.QuestLogQuestTitle:SetTextColor(self.HT:GetRGB())
			_G.QuestLogObjectivesText:SetTextColor(self.BT:GetRGB())
			_G.QuestLogTimerText:SetTextColor(self.BT:GetRGB())
			for i = 1, _G.MAX_OBJECTIVES do
				_G["QuestLogObjective" .. i]:SetTextColor(self.BT:GetRGB())
			end
			_G.QuestLogRequiredMoneyText:SetTextColor(self.BT:GetRGB())
			_G.QuestLogDescriptionTitle:SetTextColor(self.HT:GetRGB())
			_G.QuestLogQuestDescription:SetTextColor(self.BT:GetRGB())
			_G.QuestLogRewardTitleText:SetTextColor(self.HT:GetRGB())
			_G.QuestLogItemChooseText:SetTextColor(self.BT:GetRGB())
			_G.QuestLogItemReceiveText:SetTextColor(self.BT:GetRGB())
			_G.QuestLogSpellLearnText:SetTextColor(self.BT:GetRGB())

			self:SecureHook("QuestLog_UpdateQuestDetails", function(...)
				for i = 1, _G.MAX_OBJECTIVES do
					_G["QuestLogObjective" .. i]:SetTextColor(self.BT:GetRGB())
				end
				_G.QuestLogRequiredMoneyText:SetTextColor(self.BT:GetRGB())
				_G.QuestLogRewardTitleText:SetTextColor(self.HT:GetRGB())
				_G.QuestLogItemChooseText:SetTextColor(self.BT:GetRGB())
				_G.QuestLogItemReceiveText:SetTextColor(self.BT:GetRGB())
			end)

			local btnName
			for i = 1, _G.MAX_NUM_ITEMS do
				btnName = "QuestLogItem" .. i
				_G[btnName .. "NameFrame"]:SetTexture(nil)
				if self.modBtns then
					 self:addButtonBorder{obj=_G[btnName], libt=true}
				end
			end
			btnName = nil

			self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true, x1=10, y1=-11, x2=-33, y2=50}
			if self.modBtns then
				self:skinCloseButton{obj=_G.QuestLogFrameCloseButton}
				self:skinStdButton{obj=_G.QuestLogFrameAbandonButton}
				self:skinStdButton{obj=_G.QuestFrameExitButton}
				self:skinStdButton{obj=_G.QuestFramePushQuestButton}
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].QuestTimer = function(self)
		if not self.prdb.QuestTimer or self.initialized.QuestTimer then return end
		self.initialized.QuestTimer = true

		self:addSkinFrame{obj=_G.QuestTimerFrame, ft=ftype, kfs=true, nb=true, ofs=4}

	end

	aObj.blizzFrames[ftype].RaidFrame = function(self)
		if not self.prdb.RaidFrame or self.initialized.RaidFrame then return end
		self.initialized.RaidFrame = true

		self:SecureHookScript(_G.RaidParentFrame, "OnShow", function(this)
			self:skinTabs{obj=this, lod=true}
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true, y2=-5}
			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.RaidFrame, "OnShow", function(this)
			if self.modChkBtns then
				self:skinCheckButton{obj=_G.RaidFrameAllAssistCheckButton}
			end
			if self.modBtns then
				self:skinStdButton{obj=_G.RaidFrameConvertToRaidButton}
				self:skinStdButton{obj=_G.RaidFrameRaidInfoButton}
			end

			-- RaidInfo Frame
			self:skinSlider{obj=_G.RaidInfoScrollFrame.ScrollBar}
			if self.modBtns then
				self:skinCloseButton{obj=_G.RaidInfoCloseButton}
			end
			self:addSkinFrame{obj=_G.RaidInfoFrame, ft=ftype, kfs=true, hdr=true}
			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].Tutorial = function(self)
		if not self.prdb.Tutorial or self.initialized.Tutorial then return end
		self.initialized.Tutorial = true

		self:SecureHookScript(_G.TutorialFrame, "OnShow", function(this)
			this:DisableDrawLayer("BACKGROUND")
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true}
			if self.modChkBtns then
				self:skinCheckButton{obj=_G.TutorialFrameCheckButton}
			end
			if self.modBtns then
				self:skinStdButton{obj=_G.TutorialFrameOkayButton}
			end
			self:Unhook(this, "OnShow")
		end)

		-- wait for function to be declared
		_G.C_Timer.After(0.5, function()
			local btn
			for i = 1, 10 do
				btn = _G["TutorialFrameAlertButton" .. i]
				self:skinOtherButton{obj=btn, ft=ftype, sap=true, font="ZoneTextFont", text="!"}
				self:moveObject{obj=btn:GetFontString(), x=-2}
			end
			btn = nil
		end)

	end

	aObj.blizzFrames[ftype].UIWidgets = function(self)
		if not self.prdb.UIWidgets or self.initialized.UIWidgets then return end
		self.initialized.UIWidgets = true

		local function setTextColor(textObject)
			local tClr = {textObject:GetTextColor()}
			-- aObj:Debug("setTextColor: [%s, %s, %s, %s, %s]", textObject:GetText(), aObj:round2(tClr[1], 2), aObj:round2(tClr[2], 2), aObj:round2(tClr[3], 2), aObj:round2(tClr[4], 2))
			if (aObj:round2(tClr[1], 2) == 0.41 or aObj:round2(tClr[1], 2) == 0.28
			and aObj:round2(tClr[2], 2) == 0.02
			and aObj:round2(tClr[3], 2) == 0.02) -- Red
			or (aObj:round2(tClr[1], 2) == 0.08
			and aObj:round2(tClr[2], 2) == 0.16
			and aObj:round2(tClr[3], 2) == 0.37) -- Blue
			then
				textObject:SetTextColor(aObj.BT:GetRGB())
				textObject.SetTextColor = _G.nop
			end
			_G.wipe(tClr)
		end

		-- Documentation in UIWidgetManagerDocumentation.lua (UIWidgetVisualizationType)
		local function skinWidget(wFrame, wInfo)
			-- aObj:Debug("skinWidget: [%s, %s, %s, %s]", wFrame, wFrame.widgetType, wFrame.widgetTag, wInfo)
			if wFrame.widgetType == 0 then -- IconAndText (World State: ICONS at TOP)
				-- N.B. DON'T add buttonborder to Icon(s)
			elseif wFrame.widgetType == 1 then -- CaptureBar (World State: Capture bar on RHS)
				-- DON'T change textures
			elseif wFrame.widgetType == 2 then -- StatusBar
				aObj:skinStatusBar{obj=wFrame.Bar, fi=0, nilFuncs=true}
				wFrame.Bar:DisableDrawLayer("BACKGROUND")
				wFrame.Bar:DisableDrawLayer("OVERLAY")
			elseif wFrame.widgetType == 3 then -- DoubleStatusBar (Island Expeditions)
				aObj:skinStatusBar{obj=wFrame.LeftBar, fi=0, bgTex=wFrame.LeftBar.BG, nilFuncs=true}
				aObj:removeRegions(wFrame.LeftBar, {2, 3, 4}) -- border textures
				aObj:skinStatusBar{obj=wFrame.RightBar, fi=0, bgTex=wFrame.RightBar.BG, nilFuncs=true}
				aObj:removeRegions(wFrame.RightBar, {2, 3, 4}) -- border textures
			elseif wFrame.widgetType == 4 then -- IconTextAndBackground (Island Expedition Totals)
			elseif wFrame.widgetType == 5 then -- DoubleIconAndText
				if aObj.modBtnBs then
					aObj:addButtonBorder{obj=wFrame.Left, relTo=wFrame.Left.Icon}
					aObj:addButtonBorder{obj=wFrame.Right, relTo=wFrame.Right.Icon}
				end
			elseif wFrame.widgetType == 6 then -- StackedResourceTracker
				for resourceFrame in wFrame.resourcePool:EnumerateActive() do
					resourceFrame:SetFontColor(self.BT)
				end
			elseif wFrame.widgetType == 7 then -- IconTextAndCurrencies
				if aObj.modBtnBs then
					aObj:addButtonBorder{obj=wFrame, relTo=wFrame.Icon}
					if wInfo.visInfoDataFunction(wFrame.widgetID) then
						wFrame.sbb:SetBackdropBorderColor(0.498, 0.498, 0.498, 1) -- grey border
					else
						wFrame.sbb:SetBackdropBorderColor(aObj.bbClr:GetRGBA())
					end
				end
			elseif wFrame.widgetType == 8 then -- TextWithState
				setTextColor(wFrame.Text)
			elseif wFrame.widgetType == 9 then -- HorizontalCurrencies
				for currencyFrame in wFrame.currencyPool:EnumerateActive() do
					setTextColor(currencyFrame.Text)
					setTextColor(currencyFrame.LeadingText)
				end
			elseif wFrame.widgetType == 10 then -- BulletTextList
				for lineFrame in wFrame.linePool:EnumerateActive() do
					setTextColor(lineFrame.Text)
				end
			elseif wFrame.widgetType == 11 then -- ScenarioHeaderCurrenciesAndBackground
				aObj:nilTexture(wFrame.Frame, true)
			elseif wFrame.widgetType == 12 then -- TextureWithState (PTR - TextureAndText)
				-- .Background
				-- .Foreground
				setTextColor(wFrame.Text)
			elseif wFrame.widgetType == 13 then -- SpellDisplay
				wFrame.Spell.Border:SetTexture(nil)
				setTextColor(wFrame.Spell.Text)
				if aObj.modBtnBs then
					aObj:addButtonBorder{obj=wFrame.Spell, relTo=wFrame.Spell.Icon}
				end
			elseif wFrame.widgetType == 14 then -- DoubleStateIconRow
				-- TODO: add button borders if required
			end
		end

		self:SecureHook(_G.UIWidgetManager, "CreateWidget", function(this, widgetID, widgetSetID, widgetType)
			skinWidget(this.widgetIdToFrame[widgetID], this.widgetVisTypeInfo[widgetType].visInfoDataFunction(widgetID))
		end)

	end

	aObj.blizzFrames[ftype].WorldMap = function(self)
		if not self.prdb.WorldMap.skin or self.initialized.WorldMap then return end
		self.initialized.WorldMap = true

		self:SecureHookScript(_G.WorldMapFrame, "OnShow", function(this)
			self:keepFontStrings(_G.WorldMapFrame)
			self:addSkinFrame{obj=_G.WorldMapFrame.BorderFrame, ft="u", kfs=true, nb=true, ofs=1}
			-- make sure map textures are displayed
			_G.WorldMapFrame.BorderFrame.sf:SetFrameStrata("LOW")
			self:skinDropDown{obj=_G.WorldMapContinentDropDown}
			self:skinDropDown{obj=_G.WorldMapZoneDropDown}
			if self.modBtns then
				self:skinStdButton{obj=_G.WorldMapZoomOutButton}
				self:skinCloseButton{obj=_G.WorldMapFrameCloseButton}
			end

			self:Unhook(this, "OnShow")
		end)

	end

	-- TODO: fix errors/updates
		-- RaidUI
		-- GameTooltip
		-- GuildRegistrarFrame
		-- InterfaceOptionsPanels
		-- OptionsFrameTemplates
		-- PetFrame (Happiness)
		-- PetitionFrame
		-- RaidFrame
		-- StanceBar
		-- StaticPopup
		-- TabardFrame
		-- TaxiFrame
		-- TradeFrame
		-- UnitFrame
		-- UnitPopup
		-- WorldStateFrame

	-- TODO: not skinned
		-- BattlefieldFrame
		-- CraftUI

	-- VideoOptionsFrame
	if self.modBtns then
		self:skinStdButton{obj=_G.VideoOptionsFrameClassicDefaults}
	end

	-- UnitFrames
	uFrames = self:GetModule("UnitFrames", true)
	function uFrames:skinPlayerF()

		if db.player
		and not isSkinned["Player"]
		then

			local pF = _G.PlayerFrame
			_G.PlayerFrameBackground:SetTexture(nil)
			_G.PlayerFrameTexture:SetAlpha(0) -- texture file is changed dependant upon in vehicle or not
			_G.PlayerFrameVehicleTexture:SetAlpha(0) -- texture file is changed dependant upon in vehicle or not
			_G.PlayerStatusTexture:SetTexture(nil)
			pF.threatIndicator = _G.PlayerAttackBackground
			_G.PlayerRestGlow:SetTexture(nil)
			_G.PlayerAttackGlow:SetTexture(nil)

			-- status bars
			aObj:skinStatusBar{obj=pF.healthbar, fi=0}
			aObj:skinStatusBar{obj=pF.manabar, fi=0, nilFuncs=true}
			uFrames:adjustStatusBarPosn(pF.healthbar)

			-- PowerBarAlt handled in MainMenuBar function (UIF)

			-- casting bar handled in CastingBar function (PF)

			-- move level & rest icon down, so they are more visible
			uFrames:SecureHook("PlayerFrame_UpdateLevelTextAnchor", function(level)
				_G.PlayerLevelText:SetPoint("CENTER", _G.PlayerFrameTexture, "CENTER", level == 100 and -62 or -61, -20 + lOfs)
			end)
			_G.PlayerRestIcon:SetPoint("TOPLEFT", 36, -63)

			-- remove group indicator textures
			aObj:keepFontStrings(_G.PlayerFrameGroupIndicator)
			aObj:moveObject{obj=_G.PlayerFrameGroupIndicatorText, y=-1}

			uFrames:skinUnitButton{obj=pF, ti=true, x1=35, y1=-5, x2=2, y2=2}

			pF = nil

		end

	end
	function uFrames:skinPetF()

		if db.pet
		and not isSkinned["Pet"]
		then
			_G.PetFrameTexture:SetAlpha(0) -- texture file is changed dependant upon in vehicle or not
			_G.PetFrame.threatIndicator = _G.PetAttackModeTexture
			-- status bars
			uFrames:adjustStatusBarPosn(_G.PetFrameHealthBar, 0)
			aObj:skinStatusBar{obj=_G.PetFrameHealthBar, fi=0}
			uFrames:adjustStatusBarPosn(_G.PetFrameManaBar, -1)
			aObj:skinStatusBar{obj=_G.PetFrameManaBar, fi=0, nilFuncs=true}
			-- casting bar handled in CastingBar function
			aObj:moveObject{obj=_G.PetFrame, x=21, y=-2} -- align under Player Health/Mana bars

			-- skin the PetFrame
			_G.PetPortrait:SetDrawLayer("BORDER") -- move portrait to BORDER layer, so it is displayed
			uFrames:skinUnitButton{obj=_G.PetFrame, ti=true, x1=1}
		end
		if db.petspec
		and aObj.uCls == "HUNTER"
		then
			-- Add pet spec icon to pet frame, if required
			_G.PetFrame.roleIcon = _G.PetFrame:CreateTexture(nil, "artwork")
			_G.PetFrame.roleIcon:SetSize(24, 24)
			_G.PetFrame.roleIcon:SetPoint("left", -10, 0)
			_G.PetFrame.roleIcon:SetTexture([[Interface\LFGFrame\UI-LFG-ICON-ROLES]])
		end

		-- get Pet's Specialization Role to set roleIcon TexCoord
		aObj:RegisterEvent("UNIT_PET", function(event, arg1)
			if arg1 == "player"
			and _G.UnitIsVisible("pet")
			then
				local petSpec = _G.GetSpecialization(nil, true)
				if petSpec then
					_G.PetFrame.roleIcon:SetTexCoord(_G.GetTexCoordsForRole(_G.GetSpecializationRole(petSpec, nil, true)))
				end
				petSpec = nil
			end
		end)

	end
	uFrames.skinFocusF = nil



end

-- Load support for WoW Classic
local success, err = _G.xpcall(function() return aObj.otherAddons.ClassicInit(aObj) end, _G.geterrorhandler())
if not success then
	aObj:CustomPrint(1, 0, 0, "Error running ClassicInit")
end
