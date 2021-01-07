local aName, aObj = ...

if not aObj.isClsc then return end

local _G = _G

local ftype
local funcs = {
	NPC = {
		BankFrame = {keep = false, keepOpts = true},
		GossipFrame = {keep = true, keepOpts = true},
		GuildRegistrar = {keep = true, keepOpts = true},
		MerchantFrame = {keep = true, keepOpts = true},
		Petition = {keep = true, keepOpts = true},
		PetStableFrame = {keep = false, keepOpts = true},
		QuestFrame = {keep = true, keepOpts = true},
		QuestInfo = {keep = true, keepOpts = true},
		Tabard = {keep = true, keepOpts = true},
		TaxiFrame = {keep = false, keepOpts = true},
		TrainerUI = {keep = false, keepOpts = true},
	},
	Player = {
		Buffs = {keep = true, keepOpts = true},
		CastingBar = {keep = true, keepOpts = true},
		CharacterFrames = {keep = false, keepOpts = true},
		CompactFrames = {keep = true, keepOpts = true},
		ContainerFrames = {keep = false, keepOpts = true},
		DressUpFrame = {keep = false, keepOpts = true},
		FriendsFrame = {keep = false, keepOpts = true},
		InspectUI = {keep = false, keepOpts = true},
		LootFrames = {keep = true, keepOpts = true},
		LootHistory = {keep = true, keepOpts = true},
		MirrorTimers = {keep = true, keepOpts = true},
		RaidUI = {keep = true, keepOpts = true},
		ReadyCheck = {keep = true, keepOpts = true},
		SpellBookFrame = {keep = false, keepOpts = true},
		StackSplit = {keep = false, keepOpts = true},
		TalentUI = {keep = false, keepOpts = true},
		TradeFrame = {keep = true, keepOpts = true},
		TradeSkillUI = {keep = false, keepOpts = true},
	},
	UI = {
		AddonList = {keep = true, keepOpts = true},
		AutoComplete = {keep = true, keepOpts = true},
		BindingUI = {keep = true, keepOpts = true},
		BattlefieldMap = {keep = true, keepOpts = true},
		BNFrames = {keep = true, keepOpts = true},
		ChatBubbles = {keep = true, keepOpts = true},
		ChatButtons = {keep = false, keepOpts = true},
		ChatConfig = {keep = true, keepOpts = true},
		ChatEditBox = {keep = true, keepOpts = true},
		ChatFrames = {keep = true, keepOpts = true},
		ChatMenus = {keep = true, keepOpts = true},
		ChatTabs = {keep = true, keepOpts = true},
		CinematicFrame = {keep = true, keepOpts = true},
		CoinPickup = {keep = true, keepOpts = true},
		ColorPicker = {keep = true, keepOpts = true},
		DebugTools = {keep = true, keepOpts = true},
		GMChatUI = {keep = true, keepOpts = true},
		GMSurveyUI = {keep = true, keepOpts = true},
		HelpFrame = {keep = false, keepOpts = true},
		InterfaceOptions = {keep = true, keepOpts = true},
		ItemText = {keep = true, keepOpts = true},
		MacroUI = {keep = true, keepOpts = true},
		MailFrame = {keep = true, keepOpts = true},
		MainMenuBar = {keep = false, keepOpts = true},
		MenuFrames = {keep = true, keepOpts = true},
		Minimap = {keep = true, keepOpts = true},
		MinimapButtons = {keep = true, keepOpts = true},
		MovePad = {keep = true, keepOpts = true},
		MovieFrame = {keep = true, keepOpts = true},
		Nameplates = {keep = true, keepOpts = true},
		ProductChoiceFrame = {keep = true, keepOpts = true},
		PTRFeedback = (aObj.isPTR or aObj.isClscPTR or aObj.isBeta) and {keep = true, keepOpts = true} or nil,
		RaidFrame = {keep = false, keepOpts = true},
		StaticPopups = {keep = true, keepOpts = true},
		SystemOptions = {keep = true, keepOpts = true},
		TimeManager = {keep = true, keepOpts = true},
		Tooltips = {keep = true, keepOpts = true},
		Tutorial = {keep = false, keepOpts = true},
		UIDropDownMenu = {keep = true, keepOpts = true},
		UIWidgets = {keep = true, keepOpts = true},
		UnitPopup = {keep = true, keepOpts = true},
		WorldMap = {keep = false, keepOpts = true},
	},
}

aObj.ClassicSupport = function(self)

	local function nilFunc(tabName, ltr, fName)
		-- aObj:Debug("nilFunc: [%s, %s, %s]", tabName, ltr, fName)
		aObj[tabName][ltr][fName] = nil
	end
	local function nilOpts(fType, fName)
		-- aObj:Debug("nilOpts: [%s, %s]", fType, fName)
		aObj.db.profile[fName] = nil
		aObj.db.defaults.profile[fName] = nil
		aObj.optTables[fType .. " Frames"].args[fName] = nil
	end
	for _, fType in _G.pairs{"NPC", "Player", "UI"} do
		local ltr = fType:sub(1, 1):lower()
		for _, tabName in _G.pairs{"blizzFrames", "blizzLoDFrames"} do
			for fName, _ in _G.pairs(self[tabName][ltr]) do
				-- aObj:Debug("type: [%s, %s]", fName, _G.type(funcs[fType][fName]))
				if funcs[fType][fName] then
					-- aObj:Debug("keep: [%s]", funcs[fType][fName].keep)
					if not funcs[fType][fName].keep then
						nilFunc(tabName, ltr, fName)
					end
					if not funcs[fType][fName].keepOpts then
						nilOpts(fType, fName)
					end
				else
					nilFunc(tabName, ltr, fName)
					nilOpts(fType, fName)
				end
			end
		end
		ltr = nil
	end

	-- remove CombatLog Quick Button Frame option
	self.db.profile.CombatLogQBF = nil
	self.db.defaults.profile.CombatLogQBF = nil
	self.optTables["UI Frames"].args.chatopts.args.CombatLogQBF = nil
	-- remove MainMenuBar sub-options
	self.db.profile.MainMenuBar.extraab = nil
	self.db.profile.MainMenuBar.altpowerbar = nil
	self.db.defaults.profile.MainMenuBar.extraab = nil
	self.db.defaults.profile.MainMenuBar.altpowerbar = nil
	self.optTables["UI Frames"].args.MainMenuBar.args.extraab = nil
	self.optTables["UI Frames"].args.MainMenuBar.args.altpowerbar = nil

	_G.collectgarbage("collect")

	-- NOP functions that are not required and cause errors
	self.removeNineSlice = _G.nop
	self.skinGlowBox = _G.nop

	-- Add options for new frames
	if self.db.profile.AuctionUI == nil then
		self.db.profile.AuctionUI = true
		self.db.defaults.profile.AuctionUI = true
	end
	self.optTables["NPC Frames"].args.AuctionUI = {
		type = "toggle",
		name = self.L["Auction UI"],
		desc = self.L["Toggle the skin of the "] .. self.L["Auction UI"],
	}
	if self.db.profile.CraftUI == nil then
		self.db.profile.CraftUI = true
		self.db.defaults.profile.CraftUI = true
	end
	self.optTables["Player Frames"].args.CraftUI = {
		type = "toggle",
		name = self.L["Craft UI"],
		desc = self.L["Toggle the skin of the "] .. self.L["Craft UI"],
	}
	if self.db.profile.BattlefieldFrame == nil then
		self.db.profile.BattlefieldFrame = true
		self.db.defaults.profile.BattlefieldFrame = true
	end
	self.optTables["UI Frames"].args.BattlefieldFrame = {
		type = "toggle",
		name = self.L["Battlefield Frame"],
		desc = self.L["Toggle the skin of the "] .. self.L["Battlefield Frame"],
	}
	if self.db.profile.QuestLog == nil then
		self.db.profile.QuestLog = true
		self.db.defaults.profile.QuestLog = true
	end
	self.optTables["UI Frames"].args.QuestLog = {
		type = "toggle",
		name = self.L["Quest Log"],
		desc = self.L["Toggle the skin of the "] .. self.L["Quest Log"],
	}
	if self.db.profile.QuestTimer == nil then
		self.db.profile.QuestTimer = true
		self.db.defaults.profile.QuestTimer = true
	end
	self.optTables["UI Frames"].args.QuestTimer = {
		type = "toggle",
		name = self.L["Quest Timer"],
		desc = self.L["Toggle the skin of the "] .. self.L["Quest Timer"],
	}
	if self.db.profile.WorldStateScoreFrame == nil then
		self.db.profile.WorldStateScoreFrame = true
		self.db.defaults.profile.WorldStateScoreFrame = true
	end
	self.optTables["UI Frames"].args.WorldStateScoreFrame = {
		type = "toggle",
		name = self.L["Battle Score Frame"],
		desc = self.L["Toggle the skin of the "] .. self.L["Battle Score Frame"],
	}

	-- add/replace code for frames that do exist
	ftype = "n"
	self.blizzLoDFrames[ftype].AuctionUI = function(self)
		if not self.prdb.AuctionUI or self.initialized.AuctionUI then return end
		self.initialized.AuctionUI = true

		local function skinBtn(btnName, idx)
			aObj:keepFontStrings(_G[btnName .. idx])
			_G[btnName .. idx .. "Highlight"]:SetAlpha(1)
			_G[btnName .. idx .. "ItemNormalTexture"]:SetAlpha(0) -- texture changed in code
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=_G[btnName .. idx .. "Item"], reParent={_G[btnName .. idx .. "Count"], _G[btnName .. idx .. "Stock"]}}
				aObj:clrButtonFromBorder(_G[btnName .. idx .. "Item"])
			end
		end

		self:SecureHookScript(_G.AuctionFrame, "OnShow", function(this)
			-- hide filter texture when filter is clicked
			self:SecureHook("FilterButton_SetUp", function(button, ...)
				_G[button:GetName() .. "NormalTexture"]:SetAlpha(0)
			end)
			self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, ignoreSize=true, lod=true})
			self:addSkinFrame{obj=_G.AuctionFrame, ft=ftype, kfs=true, hdr=true, x1=10, y1=-11, y2=5}
			self:moveObject{obj=_G.AuctionFrameCloseButton, x=3}
			-- AuctionFrame Browse
			for i = 1, _G.NUM_FILTERS_TO_DISPLAY do
				self:keepRegions(_G["AuctionFilterButton" .. i], {3, 4}) -- N.B. region 3 is the highlight, 4 is the text
				self:addSkinFrame{obj=_G["AuctionFilterButton" .. i], ft=ftype, nb=true, aso={bd=5}, y2=-1}
			end
			self:skinSlider{obj=_G.BrowseFilterScrollFrame.ScrollBar, rt="artwork"}
			self:skinSlider{obj=_G.BrowseScrollFrame.ScrollBar, rt="artwork"}
			for _, type in _G.pairs{"Quality", "Level", "Duration", "HighBidder", "CurrentBid"} do
				self:keepRegions(_G["Browse" .. type .. "Sort"], {4, 5, 6}) -- N.B. region 4 is the text, 5 is the arrow, 6 is the highlight
				self:addSkinFrame{obj=_G["Browse" .. type .. "Sort"], ft=ftype, nb=true, aso={bd=5}, x2=-2}
			end
			for i = 1, _G.NUM_BROWSE_TO_DISPLAY do
				if _G["BrowseButton" .. i].Orig then break end -- Auctioneer CompactUI loaded
				skinBtn("BrowseButton", i)
			end
			for _, type in _G.pairs{"Name", "MinLevel", "MaxLevel"} do
				self:skinEditBox{obj=_G["Browse" .. type], regs={6, type == "Name" and 7 or nil}, mi=true} -- 6 is text, 7 is icon
				self:moveObject{obj=_G["Browse" .. type], x=type == "MaxLevel" and -6 or -4, y=type ~= "MaxLevel" and 3 or 0}
			end
			self:skinDropDown{obj=_G.BrowseDropDown, x2=109}
			self:skinMoneyFrame{obj=_G.BrowseBidPrice, moveSEB=true}
			_G.BrowseBidButton:DisableDrawLayer("BORDER")
			_G.BrowseBuyoutButton:DisableDrawLayer("BORDER")
			_G.BrowseCloseButton:DisableDrawLayer("BORDER")
			if self.modBtns then
				self:skinStdButton{obj=_G.BrowseSearchButton}
				self:skinStdButton{obj=_G.BrowseCloseButton}
				self:skinStdButton{obj=_G.BrowseBuyoutButton}
				self:skinStdButton{obj=_G.BrowseBidButton}
				for _, btn in _G.pairs{_G.BrowseBuyoutButton, _G.BrowseBidButton} do
					self:SecureHook(btn, "Disable", function(this, _)
						self:clrBtnBdr(this)
					end)
					self:SecureHook(btn, "Enable", function(this, _)
						self:clrBtnBdr(this)
					end)
				end
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=_G.BrowsePrevPageButton, ofs=-2, y1=-3, x2=-3}
				self:addButtonBorder{obj=_G.BrowseNextPageButton, ofs=-2, y1=-3, x2=-3}
				self:SecureHookScript(_G.BrowseSearchButton, "OnUpdate", function(this, _)
					if _G.CanSendAuctionQuery("list") then
						self:clrPNBtns("Browse")
					end
				end)
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=_G.IsUsableCheckButton}
				self:skinCheckButton{obj=_G.ShowOnPlayerCheckButton}
			end
			-- WoW Token
			self:SecureHookScript(_G.BrowseWowTokenResults, "OnShow", function(this)
				this.Token:DisableDrawLayer("BACKGROUND")
				if self.modBtns then
					self:skinStdButton{obj=this.Buyout}
					self:skinStdButton{obj=_G.StoreButton, x1=14, y1=2, x2=-14, y2=2}
				end

				self:Unhook(this, "OnShow")
			end)
			self:SecureHookScript(_G.WowTokenGameTimeTutorial, "OnShow", function(this)
				self.LeftDisplay.Label:SetTextColor(self.HT:GetRGB())
				self.LeftDisplay.Tutorial1:SetTextColor(self.BT:GetRGB())
				self.RightDisplay.Label:SetTextColor(self.HT:GetRGB())
				self.RightDisplay.Tutorial1:SetTextColor(self.BT:GetRGB())
				self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true, ofs=1, y1=2, y2=220}

				self:Unhook(this, "OnShow")
			end)
			-- AuctionFrame Bid
			for _, type in _G.pairs{"Quality", "Level", "Duration", "Buyout", "Status", "Bid"} do
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
				self:SecureHook("AuctionFrameBid_Update", function()
					self:clrBtnBdr(_G.BidBidButton)
					self:clrBtnBdr(_G.BidBuyoutButton)
				end)
			end
			-- AuctionFrame Auctions
			for _, type in _G.pairs{"Quality", "Duration", "HighBidder", "Bid"} do
				self:keepRegions(_G["Auctions" .. type .. "Sort"], {4, 5, 6}) -- N.B. region 4 is the text, 5 is the arrow, 6 is the highlight
				self:addSkinFrame{obj=_G["Auctions" .. type .. "Sort"], ft=ftype, aso={bd=5}, x2=-2}
			end
			self:skinSlider{obj=_G.AuctionsScrollFrame.ScrollBar, rt="artwork"}
			for i = 1, _G.NUM_AUCTIONS_TO_DISPLAY do
				skinBtn("AuctionsButton", i)
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
				self:SecureHook(_G.AuctionsCreateAuctionButton, "Disable", function(this, _)
					self:clrBtnBdr(this)
				end)
				self:SecureHook(_G.AuctionsCreateAuctionButton, "Enable", function(this, _)
					self:clrBtnBdr(this)
				end)
				self:SecureHook("AuctionFrameAuctions_Update", function()
					self:clrBtnBdr(_G.AuctionsCancelAuctionButton)
				end)
				if _G.IsAddOnLoaded("Leatrix_Plus")
				and _G.LeaPlusDB["AhExtras"] == "On"
				then
					self:skinStdButton{obj=self:getLastChild(_G.AuctionFrameAuctions)}
				end
			end
			if not self.modBtnBs then
				self:resizeEmptyTexture(self:getRegion(_G.AuctionsItemButton, 2))
			else
				self:getRegion(_G.AuctionsItemButton, 2):SetAlpha(0) -- texture is changed in blizzard code
				self:addButtonBorder{obj=_G.AuctionsItemButton, clr="grey"}
			end
			if _G.IsAddOnLoaded("Leatrix_Plus")
			and _G.LeaPlusDB["AhExtras"] == "On"
			and self.modChkBtns
			then
				self:skinCheckButton{obj=self:getPenultimateChild(_G.AuctionFrameAuctions)}
				self:skinCheckButton{obj=self:getChild(_G.AuctionFrameAuctions, _G.AuctionFrameAuctions:GetNumChildren() - 2)}
			end
			self:SecureHookScript(_G.AuctionProgressFrame, "OnShow", function(this)
				this:DisableDrawLayer("ARTWORK")
				self:keepFontStrings(_G.AuctionProgressBar)
				self:moveObject{obj=_G.AuctionProgressBar.Text, y=-2}
				self:skinStatusBar{obj=_G.AuctionProgressBar, fi=0, bgTex=_G.AuctionProgressBarFill}

				self:Unhook(this, "OnShow")
			end)

			self:Unhook(this, "OnShow")
		end)

	end

	self.blizzFrames[ftype].BankFrame = function(self)
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
						self:clrBtnBdr(btn, "grey")
					end
				end)
				-- add button borders to bank items
				for i = 1, _G.NUM_BANKGENERIC_SLOTS do
					self:addButtonBorder{obj=_G.BankSlotsFrame["Item" .. i], ibt=true, reParent={_G["BankFrameItem" .. i].IconQuestTexture}}
					-- force quality border update
					_G.BankFrameItemButton_Update(_G.BankSlotsFrame["Item" .. i])
				end
				-- add button borders to bag slots
				for i = 1, _G.NUM_BANKBAGSLOTS do
					self:addButtonBorder{obj=_G.BankSlotsFrame["Bag" .. i], ibt=true}
					_G.BankSlotsFrame["Bag" .. i].sbb:SetBackdropBorderColor(_G.BankSlotsFrame["Bag" .. i].icon:GetVertexColor())
				end
			end

			self:Unhook(this, "OnShow")
		end)

	end

	self.blizzFrames[ftype].PetStableFrame = function(self)
		if not self.prdb.PetStableFrame or self.initialized.PetStableFrame then return end
		self.initialized.PetStableFrame = true

		self:SecureHookScript(_G.PetStableFrame, "OnShow", function(this)
			self:makeMFRotatable(_G.PetStableModel)
			_G.PetStableCurrentPetBackground:SetTexture(nil)
			_G.PetStableStabledPet1Background:SetTexture(nil)
			_G.PetStableStabledPet2Background:SetTexture(nil)
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true, x1=10, y1=-11, x2=-31, y2=71}
			if self.modBtns then
				self:skinCloseButton{obj=_G.PetStableFrameCloseButton}
				self:skinStdButton{obj=_G.PetStablePurchaseButton}
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=_G.PetStablePetInfo, ofs=1, x2=0, clr="gold"}
				-- TODO: use white border
				self:addButtonBorder{obj=_G.PetStableCurrentPet, clr="white"}
				local btn
				for i = 1, _G.NUM_PET_STABLE_SLOTS do
					btn = _G["PetStableStabledPet" .. i]
					self:addButtonBorder{obj=btn, clr="grey", ca=0.85}
					self:SecureHook(_G["PetStableStabledPet" .. i .. "Background"], "SetVertexColor", function(self, ...)
						self:GetParent().sbb:SetBackdropBorderColor(...)
					end)
				end
				btn = nil
			end

			self:Unhook(this, "OnShow")
		end)

	end

	self.blizzFrames[ftype].TaxiFrame = function(self)
		if not self.prdb.TaxiFrame or self.initialized.TaxiFrame then return end
		self.initialized.TaxiFrame = true

		self:SecureHookScript(_G.TaxiFrame, "OnShow", function(this)
			self:removeRegions(this, {1, 2 ,3 ,4 ,5})
			self:addSkinFrame{obj=this, ft=ftype, nb=true, x1=10, y1=-11, x2=-32, y2=62}
			if self.modBtns then
				self:skinCloseButton{obj=_G.TaxiCloseButton}
			end

			self:Unhook(this, "OnShow")
		end)

	end

	self.blizzLoDFrames[ftype].TrainerUI = function(self)
		if not self.prdb.TrainerUI or self.initialized.TrainerUI then return end
		self.initialized.TrainerUI = true

		self:SecureHookScript(_G.ClassTrainerFrame, "OnShow", function(this)
			self:skinDropDown{obj=_G.ClassTrainerFrameFilterDropDown}
			self:removeMagicBtnTex(_G.ClassTrainerTrainButton)
			self:keepFontStrings(_G.ClassTrainerExpandButtonFrame)
			_G.ClassTrainerSkillIcon:DisableDrawLayer("BACKGROUND")
			self:skinSlider{obj=_G.ClassTrainerListScrollFrame.ScrollBar, rt="background"}
			self:skinSlider{obj=_G.ClassTrainerDetailScrollFrame.ScrollBar, rt="background"}
			local x1, y1, x2, y2
			if _G.IsAddOnLoaded("Leatrix_Plus")
			and _G.LeaPlusDB["EnhanceTrainers"] == "On"
			then
				x1, y1, x2, y2 = 10, -11, -33, 49
			else
				x1, y1, x2, y2 = 10, -11, -31, 71
			end
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, x1=x1, y1=y1, x2=x2, y2=y2}
			x1, y1, x2, y2 = nil, nil, nil, nil
			if self.modBtns then
				self:skinStdButton{obj=_G.ClassTrainerTrainButton}
				self:skinStdButton{obj=_G.ClassTrainerCancelButton}
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
			if self.modBtnBs then
				self:addButtonBorder{obj=_G.ClassTrainerSkillIcon}
			end

			self:Unhook(this, "OnShow")
		end)

	end

	ftype = "p"
	self.blizzFrames[ftype].CharacterFrames = function(self)
		if not self.prdb.CharacterFrames or self.initialized.CharacterFrames then return end
		self.initialized.CharacterFrames = true

		self:SecureHookScript(_G.CharacterFrame, "OnShow", function(this)
			self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, ignoreSize=true, lod=true})
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, x1=10, y1=-12, x2=-31, y2=71}
			-- PaperDoll Frame
			self:keepFontStrings(_G.PaperDollFrame)
			self:makeMFRotatable(_G.CharacterModelFrame)
			_G.CharacterAttributesFrame:DisableDrawLayer("BACKGROUND")
			if self.modBtnBs then
				for i = 1, 5 do
					self:addButtonBorder{obj=_G["MagicResFrame" .. i], es=24, ofs=2, x1=-1, y2=-4, clr="grey"}
				end
				self:SecureHook("PaperDollItemSlotButton_Update", function(btn)
					-- ignore buttons with no border
					if btn.sbb then
						if not btn.hasItem then
							self:clrBtnBdr(btn, "grey")
							btn.icon:SetTexture(nil)
						else
							btn.sbb:SetBackdropBorderColor(btn.icon:GetVertexColor())
						end
					end
				end)
			end
			for _, btn in _G.pairs{_G.PaperDollItemsFrame:GetChildren()} do
				-- handle non button children [ECS_StatsFrame]
				if btn:IsObjectType("Button") then
					btn:DisableDrawLayer("BACKGROUND")
					if btn ~= _G.CharacterAmmoSlot then
						if self.modBtnBs then
							self:addButtonBorder{obj=btn, ibt=true, reParent={btn.ignoreTexture}, clr="grey"}
						end
					else
						btn:DisableDrawLayer("OVERLAY")
						btn:GetNormalTexture():SetTexture(nil)
						btn:GetPushedTexture():SetTexture(nil)
						if self.modBtnBs then
							self:addButtonBorder{obj=btn, reParent={btn.Count, self:getRegion(btn, 4)}, clr="grey"}
							btn.icon = _G.CharacterAmmoSlotIconTexture
						end
					end
					if self.modBtnBs then
						-- force quality border update
						_G.PaperDollItemSlotButton_Update(btn)
					end
				end
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.ReputationFrame, "OnShow", function(this)
			self:keepFontStrings(this)
			local awc
			for i = 1, _G.NUM_FACTIONS_DISPLAYED do
				if self.modBtns then
					self:skinExpandButton{obj=_G["ReputationHeader" .. i], onSB=true}
					self.modUIBtns:checkTex{obj=_G["ReputationHeader" .. i]}
				end
				self:removeRegions(_G["ReputationBar" .. i], {1, 2})
				self:skinStatusBar{obj=_G["ReputationBar" .. i], fi=0}
				awc = self:getRegion(_G["ReputationBar" .. i .. "AtWarCheck"], 1)
				awc:SetTexture([[Interface\Buttons\UI-Checkbox-SwordCheck]])
				awc:SetTexCoord(0, 1, 0, 1)
				awc:SetSize(32, 32)
			end
			awc = nil
			self:skinSlider{obj=_G.ReputationListScrollFrame.ScrollBar, rt="background"}
			self:addSkinFrame{obj=_G.ReputationDetailFrame, ft=ftype, kfs=true, x1=6, y1=-6, x2=-6, y2=6}
			if self.modBtns then
				self:skinCloseButton{obj=_G.ReputationDetailCloseButton}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=_G.ReputationDetailAtWarCheckBox}
				self:skinCheckButton{obj=_G.ReputationDetailInactiveCheckBox}
				self:skinCheckButton{obj=_G.ReputationDetailMainScreenCheckBox}
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.PetPaperDollFrame, "OnShow", function(this)
			self:keepFontStrings(this)
			self:removeRegions(_G.PetPaperDollFrameExpBar, {1, 2})
			self:skinStatusBar{obj=_G.PetPaperDollFrameExpBar, fi=0}
			self:makeMFRotatable(_G.PetModelFrame)
			_G.PetAttributesFrame:DisableDrawLayer("BACKGROUND")
			if self.modBtnBs then
				self:addButtonBorder{obj=_G.PetPaperDollPetInfo, ofs=1, x2=0, clr="gold"}
				for i = 1, 5 do
					self:addButtonBorder{obj=_G["PetMagicResFrame" .. i], es=24, ofs=2, x1=-1, y2=-49, clr="grey"}
				end
				self:skinStdButton{obj=_G.PetPaperDollCloseButton}
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.SkillFrame, "OnShow", function(this)
			self:keepFontStrings(this)
			_G.SkillFrameExpandButtonFrame:DisableDrawLayer("BACKGROUND")
			for i = 1, _G.SKILLS_TO_DISPLAY do
				if self.modBtns then
					 self:skinExpandButton{obj=_G["SkillTypeLabel"  .. i], onSB=true, minus=true}
				end
				_G["SkillRankFrame"  .. i .. "BorderNormal"]:SetTexture(nil)
				self:skinStatusBar{obj=_G["SkillRankFrame"  .. i], fi=0, otherTex={_G["SkillRankFrame"  .. i .. "FillBar"]}}
			end
			self:skinSlider{obj=_G.SkillListScrollFrame.ScrollBar, rt="artwork"}
			self:skinSlider{obj=_G.SkillDetailScrollFrame.ScrollBar, rt="artwork"}
			self:removeRegions(_G.SkillDetailStatusBar, {1})
			self:skinStatusBar{obj=_G.SkillDetailStatusBar, fi=0, otherTex={_G.SkillDetailStatusBarFillBar}}
			if self.modBtns then
				self:skinExpandButton{obj=_G.SkillFrameCollapseAllButton, onSB=true, minus=true}
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

	self.blizzFrames[ftype].ContainerFrames = function(self)
		if not self.prdb.ContainerFrames.skin or self.initialized.ContainerFrames then return end
		self.initialized.ContainerFrames = true

		local function skinBag(frame, _)

			aObj:addSkinFrame{obj=frame, ft=ftype, kfs=true, x1=8, y1=-4, x2=-3}
			-- resize and move the bag name to make it more readable
			local objName = frame:GetName()
			_G[objName .. "Name"]:SetWidth(137)
			aObj:moveObject{obj=_G[objName .. "Name"], x=-17}

			if aObj.modBtns then
				_G[objName .. "AddSlotsButton"]:DisableDrawLayer("OVERLAY")
				aObj:skinStdButton{obj=_G[objName .. "AddSlotsButton"]}
			end
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

		self:SecureHook("ContainerFrame_GenerateFrame", function(frame, id)
			-- skin the frame if required
			if not frame.sf then
				skinBag(frame, id)
			end
		end)

		if self.modBtns then
			self:SecureHookScript(_G.BagHelpBox, "OnShow", function(this)
				self:skinCloseButton{obj=this.CloseButton, noSkin=true}

				self:Unhook(this, "OnShow")
			end)
		end

	end

	self.blizzLoDFrames[ftype].CraftUI = function(self)
		if not self.prdb.CraftUI or self.initialized.CraftUI then return end
		self.initialized.CraftUI = true

		self:SecureHookScript(_G.CraftFrame, "OnShow", function(this)
			self:skinStatusBar{obj=_G.CraftRankFrame, fi=0, bgTex=_G.CraftRankFrameBackground}
			_G.CraftRankFrameBorder:GetNormalTexture():SetTexture(nil)
			self:keepFontStrings(_G.CraftExpandButtonFrame)
			self:skinSlider{obj=_G.CraftListScrollFrameScrollBar, rt="background"}
			self:skinSlider{obj=_G.CraftDetailScrollFrameScrollBar, rt="background"}
			self:keepFontStrings(_G.CraftDetailScrollChildFrame)
			local x1, y1, x2, y2
			if _G.IsAddOnLoaded("Leatrix_Plus")
			and _G.LeaPlusDB["EnhanceProfessions"] == "On"
			then
				x1, y1, x2, y2 = 10, -11, -33, 49
			else
				x1, y1, x2, y2 = 10, -11, -31, 71
			end
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true, x1=x1, y1=y1, x2=x2, y2=y2}
			x1, y1, x2, y2 = nil, nil, nil, nil
			if self.modBtns then
				self:skinExpandButton{obj=_G.CraftCollapseAllButton, onSB=true}
				self:skinCloseButton{obj=_G.CraftFrameCloseButton}
				self:skinStdButton{obj=_G.CraftCreateButton}
				self:skinStdButton{obj=_G.CraftCancelButton}
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=_G.CraftIcon}
			end

			self:Unhook(this, "OnShow")
		end)

	end

	self.blizzFrames[ftype].DressUpFrame = function(self)
		if not self.prdb.DressUpFrame or self.initialized.DressUpFrame then return end
		self.initialized.DressUpFrame = true

		if _G.IsAddOnLoaded("DressUp") then
			self.blizzFrames[ftype].DressUpFrame = nil
			return
		end

		self:SecureHookScript(_G.SideDressUpFrame, "OnShow", function(this)
			self:removeRegions(this, {1, 2, 3, 4})
			_G.SideDressUpModel.controlFrame:DisableDrawLayer("BACKGROUND") -- model controls background
			self:removeRegions(_G.SideDressUpModelCloseButton, {5}) -- corner texture
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true, x1=1, y1=-3, x2=-2}
			if self.modBtns then
				self:skinStdButton{obj=_G.SideDressUpModelResetButton}
				self:skinCloseButton{obj=_G.SideDressUpModelCloseButton}
				if _G.IsAddOnLoaded("Leatrix_Plus")
				and _G.LeaPlusDB["EnhanceDressup"] == "On"
				then
					self:skinStdButton{obj=self:getPenultimateChild(this)}
					self:skinStdButton{obj=self:getChild(this, this:GetNumChildren() - 2)}
				end
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.DressUpFrame, "OnShow", function(this)
			self:makeMFRotatable(_G.DressUpModelFrame)
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, x1=10, y1=-11, x2=-33, y2=71}
			if self.modBtns then
				self:skinStdButton{obj=_G.DressUpFrameCloseButton}
				self:skinStdButton{obj=_G.DressUpFrameCancelButton}
				self:skinStdButton{obj=this.ResetButton}
				if _G.IsAddOnLoaded("Leatrix_Plus")
				and _G.LeaPlusDB["EnhanceDressup"] == "On"
				then
					self:skinStdButton{obj=self:getPenultimateChild(this)}
					self:skinStdButton{obj=self:getChild(this, this:GetNumChildren() - 2)}
				end
			end

			self:Unhook(this, "OnShow")
		end)

	end

	self.blizzFrames[ftype].FriendsFrame = function(self)
		if not self.prdb.FriendsFrame or self.initialized.FriendsFrame then return end
		self.initialized.FriendsFrame = true

		self:SecureHookScript(_G.FriendsFrame, "OnShow", function(this)
			self:skinDropDown{obj=_G.FriendsDropDown}
			self:skinDropDown{obj=_G.TravelPassDropDown}
			self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, ignoreSize=true, lod=true})
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true, y2=-5}
			self:moveObject{obj=this.CloseButton, x=1}

			self:SecureHookScript(_G.FriendsTabHeader, "OnShow", function(this)
				_G.FriendsFrameBattlenetFrame:DisableDrawLayer("BACKGROUND")
				if self.modBtnBs then
					self:addButtonBorder{obj=_G.FriendsFrameBattlenetFrame.BroadcastButton, ofs=-2, x1=1, y1=-1}
				end
				self:addFrameBorder{obj=_G.FriendsFrameBattlenetFrame.BroadcastFrame.ScrollFrame, ft=ftype, ofs=4}
				if self.modBtns then
					self:skinStdButton{obj=_G.FriendsFrameBattlenetFrame.BroadcastFrame.ScrollFrame.UpdateButton}
					self:skinStdButton{obj=_G.FriendsFrameBattlenetFrame.BroadcastFrame.ScrollFrame.CancelButton}
				end
				_G.FriendsFrameBattlenetFrame.BroadcastFrame.ScrollFrame.EditBox.PromptText:SetTextColor(self.BT:GetRGB())
				_G.FriendsFrameBattlenetFrame.BroadcastFrame:DisableDrawLayer("BACKGROUND")
				self:addSkinFrame{obj=_G.FriendsFrameBattlenetFrame.BroadcastFrame, ft=ftype, ofs=-10}
				self:addSkinFrame{obj=_G.FriendsFrameBattlenetFrame.UnavailableInfoFrame, ft=ftype}
				self:skinDropDown{obj=_G.FriendsFrameStatusDropDown}
				_G.FriendsFrameStatusDropDownStatus:SetAlpha(1) -- display status icon
				self:skinEditBox{obj=_G.FriendsFrameBroadcastInput, regs={6, 7}, mi=true, noWidth=true, noHeight=true, noMove=true} -- 6 is text, 7 is icon
				_G.FriendsFrameBroadcastInputFill:SetTextColor(self.BT:GetRGB())
				self:skinObject("tabs", {obj=this, prefix=this:GetName(), numTabs=2, fType=ftype, lod=true, upwards=true, offsets={x1=0, y1=-5, x2=0, y2=-5}})
				if self.modBtnBs then
					self:addButtonBorder{obj=_G.FriendsTabHeaderRecruitAFriendButton}
					self:addButtonBorder{obj=_G.FriendsTabHeaderSoRButton}
				end
				_G.RaiseFrameLevel(this)

				self:Unhook(this, "OnShow")
			end)
			self:checkShown(_G.FriendsTabHeader)

			self:SecureHookScript(_G.FriendsListFrame, "OnShow", function(this)
				_G.FriendsFrameFriendsScrollFrame.PendingInvitesHeaderButton.BG:SetTexture(nil)
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
						self:addButtonBorder{obj=btn, relTo=btn.gameIcon, ofs=0, clr="grey"}
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
						self:addButtonBorder{obj=btn.summonButton}
						for _, name in _G.pairs{"travelPassButton", "summonButton"} do
							self:SecureHook(btn[name], "Disable", function(this, _)
								self:clrBtnBdr(this)
							end)
							self:SecureHook(btn[name], "Enable", function(this, _)
								self:clrBtnBdr(this)
							end)
						end
					end
				end
				btn = nil
				self:addFrameBorder{obj=this, ft=ftype, y1=-81, y2=-2}
				if self.modBtns then
					self:skinStdButton{obj=_G.FriendsFrameAddFriendButton, x1=1}
					self:skinStdButton{obj=_G.FriendsFrameSendMessageButton}
					self:skinStdButton{obj=self:getChild(this.RIDWarning, 1)} -- unnamed parent frame
					for invite in _G.FriendsFrameFriendsScrollFrame.invitePool:EnumerateActive() do
						self:skinStdButton{obj=invite.DeclineButton}
						self:skinStdButton{obj=invite.AcceptButton}
					end
				end
				if self.modBtnBs then
					self:addButtonBorder{obj=_G.FriendsFrameFriendsScrollFrame.PendingInvitesHeaderButton}
				end

				self:Unhook(this, "OnShow")
			end)
			self:checkShown(_G.FriendsListFrame)

			self:SecureHookScript(_G.IgnoreListFrame, "OnShow", function(this)
				this:DisableDrawLayer("BACKGROUND")
				self:skinSlider{obj=_G.FriendsFrameIgnoreScrollFrame.ScrollBar}
				self:addFrameBorder{obj=this, ft=ftype, y1=-81, y2=-2}
				if self.modBtns then
					self:skinStdButton{obj=_G.FriendsFrameIgnorePlayerButton, x1=1}
					self:skinStdButton{obj=_G.FriendsFrameUnsquelchButton}
					self:SecureHook("IgnoreList_Update", function()
						self:clrBtnBdr(_G.FriendsFrameUnsquelchButton)
					end)
				end

				self:Unhook(this, "OnShow")
			end)

			self:SecureHookScript(_G.WhoFrame, "OnShow", function(this)
				self:removeInset(_G.WhoFrameListInset)
				self:skinColHeads("WhoFrameColumnHeader", nil, ftype)
				self:skinDropDown{obj=_G.WhoFrameDropDown}
				self:moveObject{obj=_G.WhoFrameDropDown, y=1}
				-- remove col head 2 as it is really a dropdown
				_G.WhoFrameColumnHeader2.sf.tfade:SetTexture(nil)
				_G.WhoFrameColumnHeader2.sf:SetBackdrop(nil)
				_G.WhoFrameColumnHeader2.sf:Hide()
				self:moveObject{obj=_G.WhoFrameColumnHeader4, x=4}
				self:removeInset(_G.WhoFrameEditBoxInset)
				self:skinEditBox{obj=_G.WhoFrameEditBox}--, move=true}
				if not self.isElvUI then
					_G.WhoFrameEditBox:SetWidth(_G.WhoFrameEditBox:GetWidth() + 24)
					self:moveObject{obj=_G.WhoFrameEditBox, x=11, y=6}
				end
				self:skinSlider{obj=_G.WhoListScrollFrame.ScrollBar, rt="background"}
				if self.modBtns then
					self:skinStdButton{obj=_G.WhoFrameGroupInviteButton}
					self:skinStdButton{obj=_G.WhoFrameAddFriendButton}
					self:SecureHook("WhoList_Update", function()
						self:clrBtnBdr(_G.WhoFrameGroupInviteButton)
						self:clrBtnBdr(_G.WhoFrameAddFriendButton)
					end)
					self:skinStdButton{obj=_G.WhoFrameWhoButton}
				end

				self:Unhook(this, "OnShow")
			end)

			self:SecureHookScript(_G.GuildFrame, "OnShow", function(this)
				self:keepFontStrings(this)
				_G.GuildFrameLFGFrame:DisableDrawLayer("BACKGROUND")
				self:skinColHeads("GuildFrameColumnHeader", nil, ftype)
				self:skinColHeads("GuildFrameGuildStatusColumnHeader", nil, ftype)
				self:skinSlider{obj=_G.GuildListScrollFrame.ScrollBar, rt="background"}
				if self.modBtns then
					self:skinStdButton{obj=_G.GuildFrameControlButton}
					self:skinStdButton{obj=_G.GuildFrameAddMemberButton}
					self:skinStdButton{obj=_G.GuildFrameGuildInformationButton}
					-- self:skinStdButton{obj=_G.GuildMOTDEditButton}
				end
				if self.modBtnBs then
					self:addButtonBorder{obj=_G.GuildFrameGuildListToggleButton, ofs=-2, clr="gold"}
				end
				if self.modChkBtns then
					self:skinCheckButton{obj=_G.GuildFrameLFGButton}
				end

				self:Unhook(this, "OnShow")
			end)

			self:SecureHookScript(_G.GuildControlPopupFrame, "OnShow", function(this)
				-- N.B. dropdown button border needs adjusting
				self:skinDropDown{obj=_G.GuildControlPopupFrameDropDown, noBB=true}
				self:skinEditBox{obj=_G.GuildControlPopupFrameEditBox, regs={1, 5}}
				self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true, ofs=0}
				if self.modBtnBs then
					self:addButtonBorder{obj=_G.GuildControlPopupFrameDropDown.Button, es=12, ofs=-2, x1=31}
					self:skinStdButton{obj=_G.GuildControlPopupFrameCancelButton}
					self:skinStdButton{obj=_G.GuildControlPopupAcceptButton}
				end
				if self.modBtns then
					self:skinExpandButton{obj=_G.GuildControlPopupFrameAddRankButton, as=true, plus=true}
					self:skinExpandButton{obj=_G.GuildControlPopupFrameRemoveRankButton, as=true}
				end
				if self.modChkBtns then
					for i = 1, 13 do
						self:skinCheckButton{obj=_G["GuildControlPopupFrameCheckbox" .. i]}
					end
				end

				self:Unhook(this, "OnShow")
			end)

			self:SecureHookScript(_G.GuildInfoFrame, "OnShow", function(this)
				self:skinSlider{obj=_G.GuildInfoFrameScrollFrame.ScrollBar, rt="artwork"}
				self:addFrameBorder{obj=_G.GuildInfoTextBackground, ft=ftype}
				self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true, ofs=0}
				if self.modBtns then
					self:skinCloseButton{obj=_G.GuildInfoCloseButton}
					self:skinStdButton{obj=_G.GuildInfoSaveButton}
					self:skinStdButton{obj=_G.GuildInfoCancelButton}
				end

				self:Unhook(this, "OnShow")
			end)

			self:SecureHookScript(_G.GuildMemberDetailFrame, "OnShow", function(this)
				this:DisableDrawLayer("OVERLAY")
				self:addFrameBorder{obj=_G.GuildMemberNoteBackground, ft=ftype}
				self:addFrameBorder{obj=_G.GuildMemberOfficerNoteBackground, ft=ftype}
				self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true, ofs=0}
				if self.modBtns then
					self:skinCloseButton{obj=_G.GuildMemberDetailCloseButton}
					self:skinStdButton{obj=_G.GuildMemberRemoveButton}
					self:skinStdButton{obj=_G.GuildMemberGroupInviteButton}
					self:skinStdButton{obj=_G.GuildFramePromoteButton}
					self:skinStdButton{obj=_G.GuildFrameDemoteButton}
				end

				self:Unhook(this, "OnShow")
			end)

			-- tooltip
			_G.C_Timer.After(0.1, function()
				self:add2Table(self.ttList, _G.FriendsTooltip)
			end)

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.AddFriendFrame, "OnShow", function(this)
			self:skinEditBox{obj=_G.AddFriendNameEditBox, regs={6}} -- 6 is text
			self:skinSlider{obj=_G.AddFriendNoteFrameScrollFrame.ScrollBar}
			self:addFrameBorder{obj=_G.AddFriendNoteFrame, ft=ftype}
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true}
			if self.modBtns then
				self:skinStdButton{obj=_G.AddFriendInfoFrameContinueButton}
				self:skinStdButton{obj=_G.AddFriendEntryFrameAcceptButton}
				self:skinStdButton{obj=_G.AddFriendEntryFrameCancelButton}
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.FriendsFriendsFrame, "OnShow", function(this)
			self:skinDropDown{obj=_G.FriendsFriendsFrameDropDown}
			self:addFrameBorder{obj=_G.FriendsFriendsList, ft=ftype}
			self:skinSlider{obj=_G.FriendsFriendsScrollFrame.ScrollBar}
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true}
			if self.modBtns then
				self:skinStdButton{obj=_G.FriendsFriendsSendRequestButton}
				self:skinStdButton{obj=_G.FriendsFriendsCloseButton}
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.BattleTagInviteFrame, "OnShow", function(this)
			self:addSkinFrame{obj=this, ft=ftype}
			if self.modBtns then
				self:skinStdButton{obj=self:getChild(this, 1)} -- Send Request
				self:skinStdButton{obj=self:getChild(this, 2)} -- Cancel
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.RecruitAFriendFrame, "OnShow", function(this)
			self:skinEditBox{obj=_G.RecruitAFriendNameEditBox, regs={6}} -- 6 is text
			_G.RecruitAFriendNameEditBox.Fill:SetTextColor(self.BT:GetRGB())
			self:addFrameBorder{obj=this.NoteFrame, ft=ftype}
			_G.RecruitAFriendNoteEditBox.Fill:SetTextColor(self.BT:GetRGB())
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, ofs=-6, y1=-7}
			if self.modBtns then
				self:skinStdButton{obj=_G.RecruitAFriendFrame.SendButton}
			end
			-- RecruitAFriendSentFrame
			self:addSkinFrame{obj=_G.RecruitAFriendSentFrame, ft=ftype, kfs=true, ofs=-7, y2=4}
			if self.modBtns then
				self:skinStdButton{obj=_G.RecruitAFriendSentFrame.OKButton}
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.ChannelFrame, "OnShow", function(this)
			self:removeInset(this.LeftInset)
			self:removeInset(this.RightInset)
			self:skinSlider{obj=this.ChannelList.ScrollBar, wdth=-4}
			self:skinSlider{obj=this.ChannelRoster.ScrollFrame.scrollBar, wdth=-4}
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true, x1=-5, x2=1, y2=-1}
			-- Create Channel Popup
			self:skinEditBox{obj=_G.CreateChannelPopup.Name, regs={6}} -- 6 is text
			self:skinEditBox{obj=_G.CreateChannelPopup.Password, regs={6}} -- 6 is text
			self:addSkinFrame{obj=_G.CreateChannelPopup, ft=ftype, kfs=true}
			if self.modBtns then
				self:skinStdButton{obj=_G.CreateChannelPopup.OKButton}
				self:skinStdButton{obj=_G.CreateChannelPopup.CancelButton}
				self:skinStdButton{obj=this.NewButton}
				self:skinStdButton{obj=this.SettingsButton}
				self:skinCloseButton{obj=this.Tutorial.CloseButton, noSkin=true}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=_G.CreateChannelPopup.UseVoiceChat}
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHook(_G.ChannelFrame.ChannelList, "Update", function(this)
			for header in this.headerButtonPool:EnumerateActive() do
				header:GetNormalTexture():SetTexture(nil)
			end
			-- for textChannel in this.textChannelButtonPool:EnumerateActive() do
			-- end
			-- for voiceChannel in this.voiceChannelButtonPool:EnumerateActive() do
			-- end
			-- for communityChannel in this.communityChannelButtonPool:EnumerateActive() do
			-- end
		end)

		self:SecureHookScript(_G.VoiceChatPromptActivateChannel, "OnShow", function(this)
			self:addSkinFrame{obj=this, ft=ftype, nb=true}
			if self.modBtns then
				self:skinCloseButton{obj=this.CloseButton, font=self.fontSBX, noSkin=true}
				self:skinStdButton{obj=this.AcceptButton}
			end
			self:hookSocialToastFuncs(this)

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.VoiceChatChannelActivatedNotification, "OnShow", function(this)
			self:addSkinFrame{obj=this, ft=ftype, nb=true}
			if self.modBtns then
				self:skinCloseButton{obj=this.CloseButton, font=self.fontSBX, noSkin=true}
			end
			self:hookSocialToastFuncs(this)

			self:Unhook(this, "OnShow")
		end)

	end

	self.blizzLoDFrames[ftype].InspectUI = function(self)
		if not self.prdb.InspectUI or self.initialized.InspectUI then return end
		self.initialized.InspectUI = true

		self:SecureHookScript(_G.InspectFrame, "OnShow", function(this)
			self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, ignoreSize=true, lod=true})
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, x1=10, y1=-12, x2=-31, y2=71}

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.InspectPaperDollFrame, "OnShow", function(this)
			_G.InspectModelFrame:DisableDrawLayer("BACKGROUND")
			_G.InspectModelFrame:DisableDrawLayer("BORDER")
			_G.InspectModelFrame:DisableDrawLayer("OVERLAY")
			self:makeMFRotatable(_G.InspectModelFrame)
			this:DisableDrawLayer("BORDER")
			for _, btn in _G.ipairs{_G.InspectPaperDollItemsFrame:GetChildren()} do
				btn:DisableDrawLayer("BACKGROUND")
				if self.modBtnBs then
					self:addButtonBorder{obj=btn, ibt=true, clr="grey"}
				end
			end
			if self.modBtnBs then
				self:SecureHook("InspectPaperDollItemSlotButton_Update", function(btn)
					if not btn.hasItem then
						self:clrBtnBdr(btn, "grey")
						btn.icon:SetTexture(nil)
					end
				end)
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.InspectHonorFrame, "OnShow", function(this)
			self:removeRegions(this, {1, 2, 3, 4, 5, 6, 7, 8})

			self:Unhook(this, "OnShow")
		end)

	end

	self.blizzFrames[ftype].SpellBookFrame = function(self)
		if not self.prdb.SpellBookFrame or self.initialized.SpellBookFrame then return end
		self.initialized.SpellBookFrame = true

		self:SecureHookScript(_G.SpellBookFrame, "OnShow", function(this)
			this.numTabs = 3
			self:skinObject("tabs", {obj=this, prefix=this:GetName(), suffix="Button", fType=ftype, ignoreSize=true, lod=true, offsets={x1=13, y1=-14, x2=-13, y2=16}, regions={1, 3}, track=false})
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
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true, x1=10, y1=-12, x2=-31, y2=72}
			if self.modBtns then
				self:skinCloseButton{obj=_G.SpellBookCloseButton}
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=_G.SpellBookPrevPageButton, ofs=-2, y1=-3, x2=-3}
				self:addButtonBorder{obj=_G.SpellBookNextPageButton, ofs=-2, y1=-3, x2=-3}
				self:clrPNBtns("SpellBook")
				self:SecureHook("SpellBookFrame_UpdatePages", function()
					self:clrPNBtns("SpellBook")
				end)
			end
			-- Spellbook Panel
			local function updBtn(btn)
				-- handle in combat
				if btn:IsProtected()
				and _G.InCombatLockdown()
				then
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
					aObj:clrBtnBdr(btn)
				end
				local spellString, subSpellString = _G[btn:GetName() .. "SpellName"], _G[btn:GetName() .. "SubSpellName"]
				if _G[btn:GetName() .. "IconTexture"]:IsDesaturated() then -- player level too low, see Trainer, or offSpec
					spellString:SetTextColor(_G.DISABLED_FONT_COLOR:GetRGB())
					subSpellString:SetTextColor(_G.DISABLED_FONT_COLOR:GetRGB())
					btn.RequiredLevelString:SetTextColor(_G.DISABLED_FONT_COLOR:GetRGB())
					btn.SeeTrainerString:SetTextColor(_G.DISABLED_FONT_COLOR:GetRGB())
				else
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
				btn:GetNormalTexture():SetTexture(nil)
				if self.modBtnBs then
					self:addButtonBorder{obj=btn, sft=true, reParent={_G["SpellButton" .. i .. "AutoCastable"]}}
				end
				updBtn(btn)
			end
			btn = nil
			-- hook self to change text colour as required
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

	self.blizzFrames[ftype].StackSplit = function(self)
		if not self.prdb.StackSplit or self.initialized.StackSplit then return end
		self.initialized.StackSplit = true

		self:SecureHookScript(_G.StackSplitFrame, "OnShow", function(this)
			-- handle different addons being loaded
			if _G.IsAddOnLoaded("EnhancedStackSplit") then
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

	self.blizzLoDFrames[ftype].TalentUI = function(self)
		if not self.prdb.TalentUI or self.initialized.TalentUI then return end
		self.initialized.TalentUI = true

		self:SecureHookScript(_G.TalentFrame, "OnShow", function(this)
			self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, ignoreSize=true, lod=true})
			self:skinSlider{obj=_G.TalentFrameScrollFrameScrollBar, rt="artwork"}
			-- keep background Texture
			self:removeRegions(this, {1, 2, 3, 4, 5, 11, 12, 13}) -- remove portrait, border & points border
			self:addSkinFrame{obj=this, ft=ftype, x1=10, y1=-12, x2=-31, y2=71}
			if self.modBtns then
				self:skinStdButton{obj=_G.TalentFrameCancelButton}
			end
			if self.modBtnBs then
				local function colourBtn(btn)
					btn.sbb:SetBackdropBorderColor(_G[btn:GetName() .. "Slot"]:GetVertexColor())
				end
				local btn
				for i = 1, _G.MAX_NUM_TALENTS do
					btn = _G["TalentFrameTalent" .. i]
					btn:DisableDrawLayer("BACKGROUND")
					_G["TalentFrameTalent" .. i .. "RankBorder"]:SetTexture(nil)
					self:addButtonBorder{obj=btn, x1=-3, y2=-3, reParent={_G["TalentFrameTalent" .. i .. "Rank"]}}
					colourBtn(btn)
				end
				btn = nil
				self:SecureHook("TalentFrame_Update", function()
					for i = 1, _G.MAX_NUM_TALENTS do
						colourBtn(_G["TalentFrameTalent" .. i])
					end
				end)
			end

			self:Unhook(this, "OnShow")
		end)

	end

	self.blizzLoDFrames[ftype].TradeSkillUI = function(self)
		if not self.prdb.TradeSkillUI or self.initialized.TradeSkillUI then return end
		self.initialized.TradeSkillUI = true

		self:SecureHookScript(_G.TradeSkillFrame, "OnShow", function(this)
			self:skinStatusBar{obj=_G.TradeSkillRankFrame, fi=0, bgTex=_G.TradeSkillRankFrameBackground}
			_G.TradeSkillRankFrameBorder:GetNormalTexture():SetTexture(nil)
			self:keepFontStrings(_G.TradeSkillExpandButtonFrame)
			self:skinDropDown{obj=_G.TradeSkillInvSlotDropDown}
			self:skinDropDown{obj=_G.TradeSkillSubClassDropDown}
			self:skinSlider{obj=_G.TradeSkillListScrollFrame.ScrollBar, rt="background"}
			self:skinSlider{obj=_G.TradeSkillDetailScrollFrame.ScrollBar, rt="background"}
			self:keepFontStrings(_G.TradeSkillDetailScrollChildFrame)
			local btnName
			for i = 1, _G.MAX_TRADE_SKILL_REAGENTS do
				btnName = "TradeSkillReagent" .. i
				_G[btnName .. "NameFrame"]:SetTexture(nil)
				if self.modBtnBs then
					 self:addButtonBorder{obj=_G[btnName], libt=true, clr="grey"}
				end
			end
			btnName = nil
			self:skinEditBox{obj=_G.TradeSkillInputBox, regs={6}, noHeight=true, x=-6} -- 6 is text
			local x1, y1, x2, y2
			if _G.IsAddOnLoaded("Leatrix_Plus")
			and _G.LeaPlusDB["EnhanceProfessions"] == "On"
			then
				x1, y1, x2, y2 = 10, -11, -33, 49
			else
				x1, y1, x2, y2 = 10, -11, -32, 70
			end
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true, x1=x1, y1=y1, x2=x2, y2=y2}
			x1, y1, x2, y2 = nil, nil, nil, nil
			if self.modBtns then
				self:skinCloseButton{obj=_G.TradeSkillFrameCloseButton}
				self:skinExpandButton{obj=_G.TradeSkillCollapseAllButton, onSB=true}
				for i = 1, _G.TRADE_SKILLS_DISPLAYED do
					self:skinExpandButton{obj=_G["TradeSkillSkill" .. i], onSB=true}
					self:checkTex{obj=_G["TradeSkillSkill" .. i]}
				end
				self:SecureHook("TradeSkillFrame_Update", function()
					for i = 1, _G.TRADE_SKILLS_DISPLAYED do
						self:checkTex{obj=_G["TradeSkillSkill" .. i]}
					end
				end)
				self:skinStdButton{obj=_G.TradeSkillCreateAllButton, ofs=0}
				self:skinStdButton{obj=_G.TradeSkillCreateButton, ofs=0}
				self:skinStdButton{obj=_G.TradeSkillCancelButton, ofs=0}
				self:SecureHook("TradeSkillFrame_SetSelection", function(id)
					self:clrBtnBdr(_G.TradeSkillCreateButton)
					self:clrBtnBdr(_G.TradeSkillCreateAllButton)
				end)
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=_G.TradeSkillSkillIcon, clr="gold"}
				self:addButtonBorder{obj=_G.TradeSkillDecrementButton, ofs=0, clr="gold"}
				self:addButtonBorder{obj=_G.TradeSkillIncrementButton, ofs=0, clr="gold"}
			end

			self:Unhook(this, "OnShow")
		end)

	end

	ftype = "u"
	self.blizzFrames[ftype].BattlefieldFrame = function(self)
		if not self.prdb.BattlefieldFrame or self.initialized.BattlefieldFrame then return end
		self.initialized.BattlefieldFrame = true

		self:SecureHookScript(_G.BattlefieldFrame, "OnShow", function(this)
			self:skinSlider{obj=_G.BattlefieldListScrollFrame.ScrollBar, rt="artwork"}
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true, x1=10, y1=-11, x2=-32, y2=71}
			if self.modBtns then
				self:skinCloseButton{obj=_G.BattlefieldFrameCloseButton}
				self:skinStdButton{obj=_G.BattlefieldFrameCancelButton}
				self:skinStdButton{obj=_G.BattlefieldFrameJoinButton}
				self:skinStdButton{obj=_G.BattlefieldFrameGroupJoinButton}
			end

			self:Unhook(this, "OnShow")
		end)

	end

	self.blizzFrames[ftype].ChatButtons = function(self)
		if not self.prdb.ChatButtons or self.initialized.ChatButtons then return end
		self.initialized.ChatButtons = true

		if self.modBtnBs then
			for i = 1, _G.NUM_CHAT_WINDOWS do
				self:addButtonBorder{obj=_G["ChatFrame" .. i].buttonFrame.bottomButton, ofs=-2, x1=1, clr="grey"}
				self:addButtonBorder{obj=_G["ChatFrame" .. i].buttonFrame.downButton, ofs=-2, x1=1, clr="grey"}
				self:addButtonBorder{obj=_G["ChatFrame" .. i].buttonFrame.upButton, ofs=-2, x1=1, clr="grey"}
				self:addButtonBorder{obj=_G["ChatFrame" .. i].buttonFrame.minimizeButton, ofs=-2, x=1, clr="grey"}
				self:addButtonBorder{obj=_G["ChatFrame" .. i].ScrollToBottomButton, ofs=-1, reParent={_G["ChatFrame" .. i].ScrollToBottomButton.Flash}}
			end
			self:addButtonBorder{obj=_G.ChatFrameChannelButton, ofs=1, clr="grey"}
			self:addButtonBorder{obj=_G.ChatFrameMenuButton, ofs=-2, x1=1, clr="grey"}
		end

	end

	-- ChatEditBox
	self.cebRgns1 = {1, 2, 6, 7} -- 1, 6, 7 are font strings, 2 is cursor texture
	self.cebRgns2 = {6, 7}

	self.blizzFrames[ftype].HelpFrame = function(self)
		if not self.prdb.HelpFrame or self.initialized.HelpFrame then return end
		self.initialized.HelpFrame = true

		self:SecureHookScript(_G.HelpFrame, "OnShow", function(this)
			self:removeInset(this.leftInset)
			self:removeInset(this.mainInset)
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, hdr=true, ofs=0}
			-- widen buttons so text fits better
			for i = 1, 6 do
				this["button" .. i]:SetWidth(180)
				if self.modBtns then
					self:skinStdButton{obj=this["button" .. i], x1=0, y1=2, x2=-3, y2=1}
				end
			end
			this.button16:SetWidth(180) -- Submit Suggestion button
			if self.modBtns then
				self:skinStdButton{obj=this.button16, x1=0, y1=2, x2=-3, y2=1}
			end

			-- Account Security panel
			this.asec.ticketButton:GetNormalTexture():SetTexture(nil)
			this.asec.ticketButton:GetPushedTexture():SetTexture(nil)
			if self.modBtns then
				self:skinStdButton{obj=this.asec.ticketButton, x1=0, y1=2, x2=-3, y2=1}
			end

			-- Character Stuck! panel
			if self.modBtnBs then
				self:addButtonBorder{obj=_G.HelpFrameCharacterStuckHearthstone, es=20}
			end
			if self.modBtns then
				self:skinStdButton{obj=_G.HelpFrameCharacterStuckStuck}
			end

			local skinSubmit
			if self.modBtns then
				function skinSubmit(frame)
					aObj:skinStdButton{obj=frame.submitButton}
					aObj:SecureHookScript(frame, "OnShow", function(this)
						aObj:clrBtnBdr(this.submitButton)
					end)
					aObj:SecureHookScript(frame.editbox, "OnTextChanged", function(this)
						aObj:clrBtnBdr(this.submitButton)
					end)
				end
			end
			-- Report Bug panel
			self:skinSlider{obj=_G.HelpFrameReportBugScrollFrame.ScrollBar}
			self:addFrameBorder{obj=self:getChild(this.bug, 3), ft=ftype}
			if self.modBtns then
				skinSubmit(this.bug)
			end

			-- Submit Suggestion panel
			self:skinSlider{obj=_G.HelpFrameSubmitSuggestionScrollFrame.ScrollBar}
			self:addFrameBorder{obj=self:getChild(this.suggestion, 3), ft=ftype}
			if self.modBtns then
				skinSubmit(this.suggestion)
			end

			-- Help Browser
			self:removeInset(_G.HelpBrowser.BrowserInset)
			if self.modBtns then
				self:skinStdButton{obj=_G.BrowserSettingsTooltip.CookiesButton}
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=_G.HelpBrowser.settings, ofs=-2, x1=1, clr="gold"}
				self:addButtonBorder{obj=_G.HelpBrowser.home, ofs=-2, x1=1, clr="gold"}
				self:addButtonBorder{obj=_G.HelpBrowser.back, ofs=-2, x1=1, clr="gold"}
				self:addButtonBorder{obj=_G.HelpBrowser.forward, ofs=-2, x1=1, clr="gold"}
				self:SecureHookScript(_G.HelpBrowser, "OnButtonUpdate", function(this)
					self:clrBtnBdr(this.back, "gold")
					self:clrBtnBdr(this.forward, "gold")
				end)
				self:addButtonBorder{obj=_G.HelpBrowser.reload, ofs=-2, x1=1, clr="gold"}
				self:addButtonBorder{obj=_G.HelpBrowser.stop, ofs=-2, x1=1, clr="gold"}
			end

			-- Knowledgebase (uses Browser frame)

			-- GM_Response
			self:skinSlider{obj=_G.HelpFrameGM_ResponseScrollFrame1.ScrollBar}
			self:skinSlider{obj=_G.HelpFrameGM_ResponseScrollFrame2.ScrollBar}
			self:addSkinFrame{obj=self:getChild(_G.HelpFrameGM_Response, 5), ft=ftype}
			self:addSkinFrame{obj=self:getChild(_G.HelpFrameGM_Response, 6), ft=ftype}

			-- BrowserSettings Tooltip
			_G.BrowserSettingsTooltip:DisableDrawLayer("BACKGROUND")
			self:addSkinFrame{obj=_G.BrowserSettingsTooltip, ft=ftype}

			-- HelpOpenTicketButton
			-- HelpOpenWebTicketButton

			-- ReportCheating Dialog
			self:removeNineSlice(_G.ReportCheatingDialog.Border)
			self:addSkinFrame{obj=_G.ReportCheatingDialog.CommentFrame, ft=ftype, kfs=true, y2=-2}
			_G.ReportCheatingDialog.CommentFrame.EditBox.InformationText:SetTextColor(self.BT:GetRGB())
			self:addSkinFrame{obj=_G.ReportCheatingDialog, ft=ftype}

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.TicketStatusFrame, "OnShow", function(this)
			self:skinObject("frame", {obj=_G.TicketStatusFrameButton, fType=ftype})

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.TicketStatusFrame)

	end

	self.blizzFrames[ftype].MainMenuBar = function(self)
		if self.initialized.MainMenuBar then return end
		self.initialized.MainMenuBar = true

		if _G.IsAddOnLoaded("Dominos") then
			self.blizzFrames[ftype].MainMenuBar = nil
			return
		end

		if self.prdb.MainMenuBar.skin then
			_G.MainMenuExpBar:SetSize(1011, 13)
			_G.MainMenuExpBar:DisableDrawLayer("OVERLAY")
			self:moveObject{obj=_G.MainMenuExpBar, x=1, y=2}
			self:skinStatusBar{obj=_G.MainMenuExpBar, fi=0, bgTex=self:getRegion(_G.MainMenuExpBar, 6), otherTex={_G.ExhaustionLevelFillBar}}
			_G.MainMenuBarMaxLevelBar:DisableDrawLayer("BACKGROUND")
			_G.MainMenuBarArtFrame:DisableDrawLayer("BACKGROUND")
			_G.MainMenuBarLeftEndCap:SetTexture(nil)
			_G.MainMenuBarRightEndCap:SetTexture(nil)

			_G.ExhaustionTick:GetNormalTexture():SetTexture(nil)
			_G.ExhaustionTick:GetHighlightTexture():SetTexture(nil)
			_G.ReputationWatchBar.StatusBar:DisableDrawLayer("ARTWORK")
			self:skinStatusBar{obj=_G.ReputationWatchBar.StatusBar, fi=0, bgTex=_G.ReputationWatchBar.StatusBar.Background}

			self:keepFontStrings(_G.StanceBarFrame)
			self:keepFontStrings(_G.PetActionBarFrame)

			if self.modBtnBs then
				for i = 1, _G.NUM_STANCE_SLOTS do
					self:addButtonBorder{obj=_G["StanceButton" .. i], abt=true, sft=true}
				end
				for i = 1, _G.NUM_PET_ACTION_SLOTS do
					self:addButtonBorder{obj=_G["PetActionButton" .. i], abt=true, sft=true, reParent={_G["PetActionButton" .. i .. "AutoCastable"], _G["PetActionButton" .. i .. "SpellHighlightTexture"]}, ofs=3}
					_G["PetActionButton" .. i .. "Shine"]:SetParent(_G["PetActionButton" .. i].sbb)
				end
				-- Action Buttons
				for i = 1, _G.NUM_ACTIONBAR_BUTTONS do
					_G["ActionButton" .. i].FlyoutBorder:SetTexture(nil)
					_G["ActionButton" .. i].FlyoutBorderShadow:SetTexture(nil)
					self:addButtonBorder{obj=_G["ActionButton" .. i], abt=true, sft=true, ofs=2.5}
				end
				-- ActionBar buttons
				self:addButtonBorder{obj=_G.ActionBarUpButton, ofs=-4, clr="gold"}
				self:addButtonBorder{obj=_G.ActionBarDownButton, ofs=-4, clr="gold"}

				-- Micro buttons
				local mBut
				for i = 1, #_G.MICRO_BUTTONS do
					mBut = _G[_G.MICRO_BUTTONS[i]]
					self:addButtonBorder{obj=mBut, es=24, ofs=2, y1=-18, reParent=mBut == "MainMenuMicroButton" and {mBut.Flash, _G.MainMenuBarDownload} or {mBut.Flash}, clr="grey"}
				end
				mBut = nil

				-- skin bag buttons
				self:addButtonBorder{obj=_G.MainMenuBarBackpackButton, ibt=true, ofs=2.5}
				self:addButtonBorder{obj=_G.CharacterBag0Slot, ibt=true, ofs=2.5}
				self:addButtonBorder{obj=_G.CharacterBag1Slot, ibt=true, ofs=2.5}
				self:addButtonBorder{obj=_G.CharacterBag2Slot, ibt=true, ofs=2.5}
				self:addButtonBorder{obj=_G.CharacterBag3Slot, ibt=true, ofs=2.5}
				self:addButtonBorder{obj=_G.KeyRingButton, ofs=2.5, clr="grey"} -- size is 18, 39

				-- MultiBar Buttons
				for _, type in _G.pairs{"BottomLeft", "BottomRight", "Right", "Left"} do
					local btn
					for i = 1, _G.NUM_MULTIBAR_BUTTONS do
						btn = _G["MultiBar" .. type .. "Button" .. i]
						btn.FlyoutBorder:SetTexture(nil)
						btn.FlyoutBorderShadow:SetTexture(nil)
						btn.Border:SetAlpha(0) -- texture changed in blizzard code
						if not btn.noGrid then
							_G[btn:GetName() .. "FloatingBG"]:SetAlpha(0)
						end
						self:addButtonBorder{obj=btn, abt=true, sft=true, ofs=2.5}
					end
					btn = nil
				end

			end

		end

		-- these are done here as other AddOns may require them to be skinned
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.MainMenuBarVehicleLeaveButton, ofs=2.5, clr="grey"}
		end

	end

	self.blizzFrames[ftype].QuestLog = function(self)
		if not self.prdb.QuestLog or self.initialized.QuestLog then return end
		self.initialized.QuestLog = true

		if _G.IsAddOnLoaded("QuestLogEx") then
			self.blizzFrames[ftype].QuestLog = nil
			return
		end

		self:SecureHookScript(_G.QuestLogFrame, "OnShow", function(this)
			_G.QuestLogCollapseAllButton:DisableDrawLayer("BACKGROUND")
			self:keepFontStrings(_G.EmptyQuestLogFrame)
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
			for i = 1, _G.MAX_NUM_ITEMS do
				_G["QuestLogItem" .. i .. "NameFrame"]:SetTexture(nil)
				if self.modBtns then
					 self:addButtonBorder{obj=_G["QuestLogItem" .. i], libt=true, clr="grey"}
				end
			end
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true, x1=10, y1=-11, x2=-33, y2=48}
			if self.modBtns then
				self:skinExpandButton{obj=_G.QuestLogCollapseAllButton, onSB=true}
				for i = 1, _G.QUESTS_DISPLAYED do
					self:skinExpandButton{obj=_G["QuestLogTitle" .. i], onSB=true}
					self:checkTex{obj=_G["QuestLogTitle" .. i]}
				end
				self:SecureHook("QuestLog_Update", function()
					for i = 1, _G.QUESTS_DISPLAYED do
						self:checkTex{obj=_G["QuestLogTitle" .. i]}
					end
				end)
				self:skinCloseButton{obj=_G.QuestLogFrameCloseButton}
				self:skinStdButton{obj=_G.QuestLogFrameAbandonButton, x1=2, x2=-2}
				self:skinStdButton{obj=_G.QuestFrameExitButton}
				self:skinStdButton{obj=_G.QuestFramePushQuestButton, x1=2, x2=-2}
			end

			self:SecureHook("QuestLog_UpdateQuestDetails", function(...)
				for i = 1, _G.MAX_OBJECTIVES do
					_G["QuestLogObjective" .. i]:SetTextColor(self.BT:GetRGB())
				end
				_G.QuestLogRequiredMoneyText:SetTextColor(self.BT:GetRGB())
				_G.QuestLogRewardTitleText:SetTextColor(self.HT:GetRGB())
				_G.QuestLogItemChooseText:SetTextColor(self.BT:GetRGB())
				_G.QuestLogItemReceiveText:SetTextColor(self.BT:GetRGB())
			end)

			self:Unhook(this, "OnShow")
		end)

	end

	self.blizzFrames[ftype].QuestTimer = function(self)
		if not self.prdb.QuestTimer or self.initialized.QuestTimer then return end
		self.initialized.QuestTimer = true

		self:addSkinFrame{obj=_G.QuestTimerFrame, ft=ftype, kfs=true, nb=true, x1=20, y1=4, x2=-20, y2=10}

	end

	self.blizzFrames[ftype].RaidFrame = function(self)
		if not self.prdb.RaidFrame or self.initialized.RaidFrame then return end
		self.initialized.RaidFrame = true

		self:SecureHookScript(_G.RaidParentFrame, "OnShow", function(this)
			self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=true})
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true, y2=-5}

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.RaidFrame, "OnShow", function(this)
			self:skinSlider{obj=_G.RaidInfoScrollFrame.ScrollBar}
			self:addSkinFrame{obj=_G.RaidInfoFrame, ft=ftype, kfs=true, nb=true, hdr=true}
			if self.modBtns then
				self:skinCloseButton{obj=_G.RaidInfoCloseButton}
				self:skinStdButton{obj=_G.RaidFrameConvertToRaidButton}
				self:SecureHook("RaidFrame_Update", function()
					self:clrBtnBdr(_G.RaidFrameConvertToRaidButton)
				end)
				self:skinStdButton{obj=_G.RaidFrameRaidInfoButton}
				self:SecureHook(_G.RaidFrameRaidInfoButton, "Disable", function(this, _)
					self:clrBtnBdr(this)
				end)
				self:SecureHook(_G.RaidFrameRaidInfoButton, "Enable", function(this, _)
					self:clrBtnBdr(this)
				end)
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=_G.RaidFrameAllAssistCheckButton}
			end

			self:Unhook(this, "OnShow")
		end)

	end

	self.blizzFrames[ftype].Tutorial = function(self)
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

		if self.modBtns then
			_G.C_Timer.After(0.5, function()
				local btn
				for i = 1, 10 do
					btn = _G["TutorialFrameAlertButton" .. i]
					self:moveObject{obj=btn:GetHighlightTexture(), x=3}
					self:skinOtherButton{obj=btn, ft=ftype, sap=true, font="ZoneTextFont", text="!"}
				end
				btn = nil
			end)
		end

	end

	self.blizzFrames[ftype].WorldMap = function(self)
		if not self.prdb.WorldMap.skin or self.initialized.WorldMap then return end
		self.initialized.WorldMap = true

		self:SecureHookScript(_G.WorldMapFrame, "OnShow", function(this)
			if not _G.IsAddOnLoaded("Mapster")
			and not _G.IsAddOnLoaded("AlleyMap")
			then
				self:keepFontStrings(_G.WorldMapFrame)
				self:addSkinFrame{obj=_G.WorldMapFrame.BorderFrame, ft="u", kfs=true, nb=true, ofs=1}
				-- make sure map textures are displayed
				_G.WorldMapFrame.BorderFrame.sf:SetFrameStrata("LOW")
			end

			self:skinDropDown{obj=_G.WorldMapContinentDropDown}
			self:skinDropDown{obj=_G.WorldMapZoneDropDown}
			if self.modBtns then
				self:skinStdButton{obj=_G.WorldMapZoomOutButton}
				self:skinCloseButton{obj=_G.WorldMapFrameCloseButton}
			end

			self:Unhook(this, "OnShow")
		end)

	end

	self.blizzFrames[ftype].WorldStateScoreFrame = function(self)
		if not self.prdb.WorldStateScoreFrame or self.initialized.WorldStateScoreFrame then return end
		self.initialized.WorldStateScoreFrame = true

		self:SecureHookScript(_G.WorldStateScoreFrame, "OnShow", function(this)
			self:skinObject("slider", {obj=_G.WorldStateScoreScrollFrame.ScrollBar, fType=ftype, rpTex="artwork"})
			self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, ignoreSize=true, lod=true})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, x1=12, y1=-15, x2=-114, y2=66})
			if self.modBtns then
				self:skinStdButton{obj=_G.WorldStateScoreFrameLeaveButton}
			end

			self:Unhook(this, "OnShow")
		end)

	end

	-- TODO:
		-- UnitPopup

	-- VideoOptionsFrame, wait for variable to be populated
	if self.modBtns then
		_G.C_Timer.After(1, function()
			self:skinStdButton{obj=_G.VideoOptionsFrameClassic}
		end)
	end

	-- remove UnitFrames module options
	local ufDB = self.db:GetNamespace("UnitFrames", true)
	if ufDB then
		ufDB.profile.petspec = nil
		ufDB.profile.focus = nil
		ufDB.profile.arena = nil
		ufDB.defaults.profile.petspec = nil
		ufDB.defaults.profile.focus = nil
		ufDB.defaults.profile.arena = nil
		ufDB = nil
	end
	self.optTables["Modules"].args[aName .. "_UnitFrames"].args.petspec = nil
	self.optTables["Modules"].args[aName .. "_UnitFrames"].args.focus = nil
	self.optTables["Modules"].args[aName .. "_UnitFrames"].args.arena = nil
	self:GetModule("UnitFrames", true).skinFocusF = _G.nop
	self:UnregisterEvent("UNIT_PET")

end
