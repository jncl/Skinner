local pairs = pairs
local strgsub = string.gsub
local tinsert = table.insert
local IsAddOnLoaded = IsAddOnLoaded

function Skinner:BlizzardFrames()
--	self:Debug("BlizzardFrames")

	local blizzFrames = {
		"CharacterFrames", "PetStableFrame", "SpellBookFrame", "DressUpFrame", "AchievementAlerts", -- cf1
		"FriendsFrame", "TradeFrame", "ReadyCheck", "Buffs", "VehicleMenuBar", "WatchFrame", "GearManager", --cf2
		"MerchantFrames", "GossipFrame", "TaxiFrame", "QuestFrame", "Battlefields", "ArenaFrame", "ArenaRegistrar", "GuildRegistrar", "Petition", "Tabard", -- npc
		"MirrorTimers", "StaticPopups", "ChatMenus", "ChatTabs", "ChatFrames", "ChatEditBox", "LootFrame", "GroupLoot", "ContainerFrames", "StackSplit", "ItemText", "ColorPicker", "WorldMap", "HelpFrame", "Tutorial", "BattleScore", "ScriptErrors", "DropDowns", -- uie1
		"MenuFrames", "BankFrame", "MailFrame", "CoinPickup", "LFGFrame", "PVPFrame", -- uie2
	}

	if self.isPTR then tinsert(blizzFrames, "FeedbackUI") else self.FeedbackUI = nil end -- uie1
	if self.isPatch then tinsert(blizzFrames, "AutoComplete") end -- uie2

	for _, v in pairs(blizzFrames) do
		self:checkAndRun(v)
	end
	blizzFrames = nil
	
	-- handle non standard ones here
	self:ScheduleTimer("checkAndRun", 1, "MinimapButtons") -- wait for a second before skinning the minimap buttons
	self:checkAndRun("ChatConfig") -- done here even though it's LoD, as it is always loaded with Blizzard_CombatLog

	if IsMacClient() then self:checkAndRun("MovieProgress") end

--[[
	QuestLog -- checked with EQL3 below
	CastingBar -- checked with Quartz below
	Tooltips -- checked with TipTac below
	MainMenuBar -- checked with Bongos below
	Nameplates -- checked with Aloft below
	ModelFrames -- checked with CloseUp below
]]

end

function Skinner:SkinnerFrames()
--	self:Debug("SkinnerFrames")

	local skinnerFrames = {"ViewPort", "TopFrame", "MiddleFrames", "BottomFrame"}

	for _, v in pairs(skinnerFrames) do
		self:checkAndRun(v)
	end
	skinnerFrames = nil

end

local blizzLoDFrames = {
	 "AchievementUI", "AuctionUI", "BarbershopUI", "BattlefieldMinimap", "BindingUI", "Calendar", "GlyphUI", "GMChatUI", "GMSurveyUI", "GuildBankUI", "InspectUI", "ItemSocketingUI", "MacroUI", "RaidUI", "TalentUI", "TimeManager", "TradeSkillUI", "TrainerUI",
}
if Skinner.isPTR then tinsert(blizzLoDFrames, "DebugTools") else Skinner.DebugTools = nil end -- uie2
local blizzLoD = {}
for _, v in pairs(blizzLoDFrames) do
	blizzLoD["Blizzard_"..v] = v
end
blizzLoDFrames = nil

function Skinner:AddonFrames()
--	self:Debug("AddonFrames")

	-- this addon colour the Tooltip Border
	if IsAddOnLoaded("Chippu") then self.ttBorder = false end

	-- skin the QuestLog if EQL3 or QuestGuru aren't loaded
	-- N.B. Do it here as other Addons use the QuestLog size
	 if not IsAddOnLoaded("EQL3") and not IsAddOnLoaded("QuestGuru") then self:checkAndRun("QuestLog") end

	-- skin the CastingBar if Quartz isn't loaded
	if not IsAddOnLoaded("Quartz") then self:checkAndRun("CastingBar") end

	-- skin the Tooltips if TipTac isn't loaded
	if not IsAddOnLoaded("TipTac") then self:checkAndRun("Tooltips") end

	-- skin the MenuBar if Bongos isn't loaded
	if not IsAddOnLoaded("Bongos") and not IsAddOnLoaded("Bongos2") then self:checkAndRun("MainMenuBar") end

	-- skin the Nameplates if Aloft or nerNameplates aren't loaded
	if not IsAddOnLoaded("Aloft") and not IsAddOnLoaded("nerNameplates") then self:checkAndRun("Nameplates") end

	--	don't make Model Frames Rotatable if CloseUp is loaded
	if not IsAddOnLoaded("CloseUp") then self:checkAndRun("ModelFrames") end

	local addonFrames = {
		"Accountant", "AceProfit", "Acheron", "AckisRecipeList", "ACP", "AdvancedTradeSkillWindow", "aftt_extreme", "AlphaMap", "Altoholic", "Analyst", "AoTRDungeonQuester", "ArkInventory", "Armory", --[["Ash_Cooldowns", "Ash_Core", "Ash_DoTimer", "Assessment",--]] "Atlas", "AtlasLoot", "AtlasQuest", "AuldLangSyne", "AuldLangSyne_Note", "AutoDecline", "AutoProfit", "AutoProfitX", "AxuItemMenus",
		"Badapples", "Baggins", "Baggins_Search", "Bagnon", "Bagnon_Forever", "BankAccountant", "BankItems", "BattleChat", "BattleCry", "BaudBag", "BaudManifest", "BaudMenu", "BeanCounter", "BeastTraining", "beql", "BetterInbox", "BigBankStatement", "BigGuild", "BigTrouble", --[["Bongos_AB",--]] "Bonuses", "Broker_Transport", "Buffalo", --[["Buffalo2",--]]	"BuffQ", "BugSack", "Butsu", "BuyEmAll", "BuyPoisons",
		"CallToArms", "Capping", "Cartographer", "Cartographer_QuestInfo", "Cartographer3", "CBRipoff", "CEnemyCastBar", --[["CharactersViewer",--]] "Chatr", "Chatter", "Chinchilla", "Clique", "Cork", "Combuctor", "ConcessionStand", "Converse", "CowTip", "CT_MailMod", --[["CT_RaidAssist",--]] "CT_RaidTracker",
		"DamageMeters", "DebuffFilter", "Demon", "DemonTrainerFrame", "DepositBox", "DiamondThreatMeter", "Dominos", "DopieArenaInfo", "DuckieBank",
		"Earth", "EasyTrack", "EasyUnlock", "EavesDrop", "EditingUI", "EnchantMe", "EngBags", "EnhancedFlightMap", "EnhancedStackSplit", "EnhancedTradeSkills", "Epeen", "epgp", "EQL3", "EquipCompare", "EventEquip", --[["EveryQuest",--]] "Examiner",
		--[["FactionGrinder",--]] "Factionizer", "FBagOfHolding", "FeedMachine", "FishingBuddy", "FlightMap", "ForteWarlock", "FramesResized", "FreierGeist_InstanceTime", "FruityLoots", --[["FuBar_PoisonReminderFu",--]]
		"Gatherer", "GCInfo", "GemHelper", "GemMe", "GFW_FeedOMatic", "GlowFoSho", "Gossipmonger", "GotWood", "Grid", "GrimReaper", "GroupCalendar", "GroupCalendar5", "Guild_Alliance", "Guild_Log", "GuildAds", "GuildBankAccount", --[["GuildEventManager2",--]] "GuildLaunchCT_RaidTracker",
		"Hack", "Hadar_FocusFrame", "HandyNotes", "HatTrick", "HeadHunter", "HealBot", "HealersAssist", "HealingEstimator", "HealOrganizer", "Historian", "HitsMode", "HoloFriends",
		"IgorsMassAuction", "InspectEquip", "InstanceMaps", "InsultDevice", "InventoryOnPar", "IPopBar", "ItemDB", "ItemEnchantApplication", "ItemRack", "ItemSync",
		"JasonQuest", "Jobber", "Junk",
		"Karma", --[["KC_Items",--]] "KLHThreatMeter", "KombatStats",
		"LauncherMenu", "LightHeaded", "LinkHeaven", "Links", "LinksList", "LinkWrangler", "LoadIT", "LootHog", "LootLink", "LootScroll", "Ludwig", "Luggage",
		"MacroBank", "MageEatDrinkAid", "MailTo", "MakeRocketGoNow", --[["MCP", "MetaMap",--]]	 "MinimapButtonFrame", "Mirror", "MobileFrames", "MobileVault", "MobMap", "Moleskine", "MonkeyQuest", "MonkeyQuestLog", "MTLove", --[["MultiTips",--]] "MusicPlayer", "MyBags", "myClock", "myMusic",
		"NeonChat", "Notebook", "NotesUNeed", "nQuestLog",
		"Omen", "Omnibus", "OneBag3", "OneBank3", "oRA2", "oRA3", "Outfitter", "Overachiever",
		"Palatank", "PallyPower", "Panda", "PartyQuests", "Pawn", "PassLoot", "Perl_CombatDisplay", "Perl_Focus", "Perl_Party", "Perl_Party_Pet", "Perl_Party_Target", "Perl_Player", "Perl_Player_Pet", "Perl_Target", "Perl_Target_Target", "Planner", "PlayerExpBar", "PoliteWhisper", "Possessions", "Postal", "PowerAuras", "Prat", "ProcMeter", "ProfessionsBook", "Proximo", "PVPCooldown", "PVPCooldownReborn", "PvpMessages",
		"Quartz", "QuestAgent", "QuestGuru", "QuestHistory", "QuestIon",
		"RABuffs", "RaidTracker", "RandomPet30", "ReadySpells", "ReagentHeaven", "Recap", "RecipeBook", "RecipeRadar", "Recount", "RicoMiniMap",
		"Sanity2", --[["SanityBags",--]] "SellJunk", "ShadowDancer3", "ShieldLeft", "sienasGemViewer", "SimpleMouseoverTarget", "Skillet", "SmartBuff", "SmartDebuff", "SpamSentry", "Spew", "Spyglass", "Squeenix", "sRaidFrames", "StanceSets", "SuperMacro", "SW_Stats", "SW_UniLog", "SystemMessageControlTool",
		"Talented", "Tankadin", "TankPoints", "TargetAnnounce", "tekBlocks", "tekDebug", "tekErr", "tekKompare", "tekPad", "TheCollector", --[["TinyTip",--]] "TipBuddy", "TipTac", "TitanExitGame", "tomQuest2", "TomTom", "Toons", "TotemCaddy", "TourGuide", "TradeJunkie", "TuringTest",
		"UberQuest", "UrbanAchiever",
		"VanasKoS", "vBagnon", --[["Vendor",--]] "VendorSearch", "Violation", "Visor2GUI", "Volumizer",
		"WebDKP", "WIM", "WoWEquip",
		"xcalc", "XLoot", "XLootGroup", "XLootMonitor", "XPerl", "XPerl_RaidAdmin", "XPerl_RaidHelper", "XPerl_GrimReaper", "XRS",
		"ZOMGBuffs"
	}

	-- used for Addons that aren't LoadOnDemand
	for _, v in pairs(addonFrames) do
		self:checkAndRunAddOn(v)
	end
	addonFrames = nil

	self:checkAndRunAddOn("NicheCombatConfig", true) -- done here even though it's LoD, as it is always loaded with Blizzard_CombatLog -- use true so it isn't treated as a LoadManaged Addon
	self:checkAndRunAddOn("SuperInspect_UI", true) -- use true so it isn't treated as a LoadManaged Addon

	-- handle Addons with odd names here
	local oddlyNamedAddons = {
		"Auc-Advanced", "Auc-Util-BigPicture", "Auto-Bag", "DBM-Core", "Enchantrix-Barker", "!ImprovedErrorFrame", "Ogri'Lazy"
	}
	for _, v in pairs(oddlyNamedAddons) do
		v2, _ = strgsub(v, "[-_!']", "")
		self:checkAndRunAddOn(v, nil, v2)
	end
	oddlyNamedAddons = nil

	-- this addon has a relation
	self:checkAndRunAddOn("EnhancedTradeSkills", nil, "EnhancedTradeCrafts")

	-- skin the Blizzard LoD frames if they have already been loaded by other addons
	for k, v in pairs(blizzLoD) do
		if IsAddOnLoaded(k) then self:checkAndRun(v) end
	end

	-- load MSBTOptions here if FuBar_MSBTFu is loaded
	if IsAddOnLoaded("FuBar_MSBTFu") then
		self:checkAndRunAddOn("MSBTOptions", true) -- use true so it isn't treated as a LoadManaged Addon
	end

--[[
	--	load Bongos support here if it is loaded
	if IsAddOnLoaded("Bongos") then self:checkAndRunAddOn("Bongos") end
--]]

	-- skin Dewdrop, Ace2, Tablet, Waterfall, Ace3GUI, LibSimpleOptions, Configator, LibExtraTip, tektip & LibQTip/LibTooltip library objects
	local libsToSkin = {
		["Dewdrop-2.0"] = "Dewdrop",
		["AceAddon-2.0"] = "Ace2",
		["Tablet-2.0"] = "Tablet",
		["Waterfall-1.0"] = "Waterfall",
		["AceGUI-3.0"] = "Ace3",
		["LibSimpleOptions-1.0"] = "LibSimpleOptions",
		["Configator"] = "Configator",
		["LibExtraTip-1"] = "LibExtraTip",
		["tektip-1.0"] = "tektip",
		["LibQTip-1.0"] = "LibQTip",
		["LibTooltip-1.0"] = "LibQTip",
		["LibQTipClick-1.1"] = "LibQTip",
	}
	for k, v in pairs(libsToSkin) do
--		self:Debug("skin Libs:[%s, %s]", k, v)
		if LibStub(k, true) then
			if self[v] then self:checkAndRun(v)
			else
				if self.db.profile.Warnings then
					self:CustomPrint(1, 0, 0, v, "loaded but skin not found in SkinMe directory")
				end
			end
		end
	end
	libsToSkin = nil

	-- skin Rock Config
	if Rock and Rock:HasLibrary("LibRockConfig-1.0") then
		if self.RockConfig then self:checkAndRun("RockConfig")
		else
			if self.db.profile.Warnings then
				self:CustomPrint(1, 0, 0, "RockConfig", "loaded but skin not found in SkinMe directory")
			end
		end
	end

	-- skin KeyBound Dialog frame
	if self.db.profile.MenuFrames then
		if LibStub('LibKeyBound-1.0', true) then
			self:addSkinFrame{obj=KeyboundDialog, kfs=true}
		end
	end

	-- skin tekKonfig library objects
	if self.tekKonfig then self:tekKonfig() end

end

local lodFrames = {
	"Bagnon", "Bagnon_Options", "Banknon", "BaudAuction", "BetterBindingFrame", --[["Bongos", "Bongos_Options",--]]
	"Cartographer_Notes", "CECB_Options", "cgCrafty", "CharacterInfo", "DockingStation_Config", "Dominos_Config", "DoTimer_Options", "Enchantrix", "EnhTooltip", "FilterTradeSkill", "FramesResized_TalentUI", "GuildBankSearch", "ItemRackOptions",  "LilSparkysWorkshop", "MSBTOptions", "Overachiever_Tabs", "Perl_Config_Options", "SpamSentry_report", --[[SpecialTalentUI",--]] "SuperInspect_UI", "TradeTabs", "TipTacOptions", "WIM_Options", "XPerl_Options", "ZOMGBuffs_BlessingsManager",
}
local lodAddons = {}
for _, v in pairs(lodFrames) do
	lodAddons[v] = v
end
lodFrames = nil
for i = 1, 8 do
	lodAddons["MobMapDatabaseStub"..i] = "MobMapDatabaseStub"..i
end

function Skinner:LoDFrames(arg1)
--	self:Debug("LoDFrames: [%s]", arg1)

	if arg1 == prev_arg1 then return end
	local prev_arg1 = arg1

	-- used for Blizzard LoadOnDemand Addons
	if blizzLoD[arg1] then self:checkAndRun(blizzLoD[arg1]) end

	-- used for User LoadOnDemand Addons
	if lodAddons[arg1] then self:checkAndRunAddOn(lodAddons[arg1], true) end

	-- handle renamed DBM-GUI addon
	if arg1 == "DBM-GUI" then
		self:checkAndRunAddOn(arg1, true, "DBM_GUI")
	end

	-- handle addons linked to the InspectUI
	if arg1 == "Blizzard_InspectUI" then
		--	This addon is dependent upon the Inspect Frame
		self:checkAndRunAddOn("Spyglass")
	end

	--	deal with Addons under the control of an LoadManager
	if self.lmAddons[arg1] then
		self:checkAndRunAddOn(arg1, true, self.lmAddons[arg1])
		self.lmAddons[arg1] = nil
	end

	-- handle FramesResized changes
	if IsAddOnLoaded("FramesResized") then
		if arg1 == "Blizzard_TradeSkillUI" and self.FR_TradeSkillUI then self:FR_TradeSkillUI()
		elseif arg1 == "Blizzard_TrainerUI" and self.FR_TrainerUI then self:FR_TrainerUI()
		end
	end

end

function Skinner:ADDON_LOADED(event, arg1)
--	self:Debug("ADDON_LOADED: [%s]", arg1)

	self:ScheduleTimer("LoDFrames", self.db.profile.Delay.LoDs, arg1)

end

function Skinner:AUCTION_HOUSE_SHOW()
--	self:Debug("AUCTION_HOUSE_SHOW")

	self:checkAndRun("AuctionUI")
	-- trigger these when AH loads otherwise errors occur
	self:checkAndRunAddOn("BtmScan")
	self:checkAndRunAddOn("Fence")
	self:checkAndRunAddOn("AuctionFilterPlus")

	self:UnregisterEvent("AUCTION_HOUSE_SHOW")

end
