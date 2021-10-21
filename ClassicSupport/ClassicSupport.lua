local aName, aObj = ...

local _G = _G

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
		ItemSocketingUI = aObj.isClscBC and {keep = true, keepOpts = true},
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
		EventTrace = {keep = true, keepOpts = true},
		GMChatUI = {keep = true, keepOpts = true},
		GMSurveyUI = not aObj.isClscBC and {keep = false, keepOpts = true},
		GuildBankUI = aObj.isClscBC and {keep = false, keepOpts = true},
		HelpFrame = {keep = true, keepOpts = true},
		InterfaceOptions = {keep = true, keepOpts = true},
		ItemText = {keep = true, keepOpts = true},
		MacroUI = {keep = true, keepOpts = true},
		MailFrame = {keep = true, keepOpts = true},
		MainMenuBar = {keep = true, keepOpts = true},
		MenuFrames = {keep = true, keepOpts = true},
		Minimap = {keep = true, keepOpts = true},
		MinimapButtons = {keep = true, keepOpts = true},
		MovePad = {keep = true, keepOpts = true},
		MovieFrame = {keep = true, keepOpts = true},
		Nameplates = {keep = true, keepOpts = true},
		ProductChoiceFrame = {keep = true, keepOpts = true},
		PTRFeedback = (not aObj.isRtl or aObj.isClsc) and {keep = true, keepOpts = true},
		RaidFrame = {keep = false, keepOpts = true},
		SharedBasicControls = {keep = true, keepOpts = true},
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

aObj.SetupClassic = function(self)

	local function nilFunc(tabName, ltr, fName)
		aObj[tabName][ltr][fName] = nil
	end
	local function nilOpts(fType, fName)
		aObj.db.profile[fName] = nil
		aObj.db.defaults.profile[fName] = nil
		aObj.optTables[fType .. " Frames"].args[fName] = nil
	end
	for _, fType in _G.pairs{"NPC", "Player", "UI"} do
		local ltr = fType:sub(1, 1):lower()
		for _, tabName in _G.pairs{"blizzFrames", "blizzLoDFrames"} do
			for fName, _ in _G.pairs(self[tabName][ltr]) do
				if funcs[fType][fName] then
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

	-- remove UnitFrames module options
	local ufDB = self.db:GetNamespace("UnitFrames", true)
	if ufDB then
		ufDB.profile.focus = nil
		ufDB.profile.arena = nil
		ufDB.defaults.profile.focus = nil
		ufDB.defaults.profile.arena = nil
	end
	self.optTables["Modules"].args[aName .. "_UnitFrames"].args.focus = nil
	self.optTables["Modules"].args[aName .. "_UnitFrames"].args.arena = nil
	self:GetModule("UnitFrames", true).skinFocusF = _G.nop

	-- NOP functions that are not required and cause errors
	self.skinGlowBox = _G.nop

	-- Add options for new frames
	if self.isClscBC then
		if self.db.profile.ArenaFrame == nil then
			self.db.profile.ArenaFrame = true
			self.db.defaults.profile.ArenaFrame = true
		end
		self.optTables["NPC Frames"].args.ArenaFrame = {
			type = "toggle",
			name = self.L["Arena Frame"],
			desc = self.L["Toggle the skin of the "] .. self.L["Arena Frame"],
		}
		if self.db.profile.ArenaRegistrarFrame == nil then
			self.db.profile.ArenaRegistrarFrame = true
			self.db.defaults.profile.ArenaRegistrarFrame = true
		end
		self.optTables["NPC Frames"].args.ArenaRegistrarFrame = {
			type = "toggle",
			name = self.L["Arena Registrar Frame"],
			desc = self.L["Toggle the skin of the "] .. self.L["Arena Registrar Frame"],
		}
	end
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
	if not self.isClscBC then
		if self.db.profile.GMSurveyUI == nil then
			self.db.profile.GMSurveyUI = true
			self.db.defaults.profile.GMSurveyUI = true
		end
		self.optTables["UI Frames"].args.HelpFrame.args.GMSurveyUI = {
			type = "toggle",
			name = self.L["GM Survey UI"],
			desc = self.L["Toggle the skin of the "] .. self.L["GM Survey UI"],
		}
	else
		if self.db.profile.LFGLFM == nil then
			self.db.profile.LFGLFM = true
			self.db.defaults.profile.LFGLFM = true
		end
		self.optTables["UI Frames"].args.LFGLFM = {
			type = "toggle",
			width = "double",
			name = self.L["Looking for Group/More Frame"],
			desc = self.L["Toggle the skin of the "] .. self.L["Looking for Group/More Frame"],
		}
	end
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

	-- ChatEditBox
	self.cebRgns = {1, 2, 6, 7} -- 1, 6, 7 are font strings, 2 is cursor texture

end
