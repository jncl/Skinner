local aName, aObj = ...
local _G = _G

-- Add locals to see if it speeds things up
local IsAddOnLoaded, pairs = _G.IsAddOnLoaded, _G.pairs

local blizzLoDFrames = {
	-- player
	"AchievementUI", "ArchaeologyUI", "EncounterJournal", "GlyphUI", "GuildControlUI", "GuildUI", "InspectUI", "ItemSocketingUI", "LookingForGuildUI", "PVPUI", "RaidUI", "TalentUI",
	-- TradeSkillUI, loaded when TRADE_SKILL_SHOW event is fired
	-- npc
 	-- AuctionUI, loaded when AUCTION_HOUSE_SHOW event is fired
	"BarbershopUI", "BlackMarketUI", "ItemAlterationUI", "ItemUpgradeUI", "QuestChoice", "ReforgingUI", "TrainerUI", "VoidStorageUI",
	-- ui
	"BattlefieldMinimap", "BindingUI", "Calendar", "ChallengesUI", "DebugTools", "GMChatUI", "GMSurveyUI", "GuildBankUI", "MacroUI", "MovePad", "PetJournal", "StoreUI", "TimeManager",
	--	ArenaUI the unitframes are skinned in UnitFrames.lua
}
-- optional frames
local blizzLoD = {}
for _, v in pairs(blizzLoDFrames) do
	blizzLoD["Blizzard_"..v] = v
end
blizzLoDFrames = nil
function aObj:BlizzardFrames()
	-- self:Debug("BlizzardFrames")

	self.blizzFrames = {
		player = {
			["Buffs"] = true,
			["CastingBar"] = false, -- checked below
			["CompactFrames"] = false, -- checked below
			["CharacterFrames"] = true,
			["ContainerFrames"] = true,
			["DressUpFrame"] = true,
			["EquipmentFlyout"] = true,
			["FriendsFrame"] = true,
			["GhostFrame"] = true,
			["GuildInvite"] = true,
			["LootFrames"] = true,
			["LootHistory"] = true,
			["MirrorTimers"] = true,
			["OverrideActionBar"] = true,
			["QuestLog"] = false, -- checked below
			["ReadyCheck"] = true,
			["RolePollPopup"] = true,
			["ScrollOfResurrection"] = true,
			["SpellBookFrame"] = true,
			["SpellFlyout"] = true,
			["StackSplit"] = true,
			["TradeFrame"] = true,
			["WatchFrame"] = true,
			-- LoD frames
			["AchievementUI"] = false,
			["ArchaeologyUI"] = false,
			["EncounterJournal"] = false,
			["GlyphUI"] = false,
			["GuildControlUI"] = false,
			["GuildUI"] = false,
			["InspectUI"] = false,
			["ItemSocketingUI"] = false,
			["LookingForGuildUI"] = false,
			["PetJournal"] = false,
			["PVPUI"] = false,
			["RaidUI"] = false,
			["TalentUI"] = false,
			["TradeSkillUI"] = false,
		},
	    npc = {
			["BankFrame"] = true,
			["GossipFrame"] = true,
			["GuildRegistrar"] = true,
			["MerchantFrame"] = true,
			["Petition"] = true,
			["PetStableFrame"] = true,
			["QuestFrame"] = true,
			["SideDressUpFrame"] = true,
			["Tabard"] = true,
			["TaxiFrame"] = true,
			-- LoD frames
			["AuctionUI"] = false,
			["BarbershopUI"] = false,
			["BlackMarketUI"] = false,
			["ItemAlterationUI"] = false,
			["ItemUpgradeUI"] = false,
			["QuestChoice"] = false,
			["ReforgingUI"] = false,
			["TrainerUI"] = false,
			["VoidStorageUI"] = false,
		},
		ui = {
			["AlertFrames"] = true,
			["AuthChallengeUI"] = false, -- N.B. cannot be skinned
			["AutoComplete"] = true,
			["BNFrames"] = true,
			["ChatButtons"] = true,
			["ChatConfig"] = true,
			["ChatEditBox"] = true,
			["ChatFrames"] = true,
			["ChatMenus"] = true,
			["ChatMinimizedFrames"] = true,
			["ChatTabs"] = true,
			["ChatTemporaryWindow"] = true,
			["CinematicFrame"] = true,
			["CoinPickup"] = true,
			["ColorPicker"] = true,
			["DestinyFrame"] = true,
			["DropDownPanels"] = true,
			["HelpFrame"] = true,
			["ItemText"] = true,
			["LevelUpDisplay"] = true,
			["LFDFrame"] = true,
			["LFGFrame"] = true,
			["LFRFrame"] = true,
			["MailFrame"] = true,
			["MainMenuBar"] = false, -- checked below
			["MenuFrames"] = true,
			["Minimap"] = false, -- checked below
			["MinimapButtons"] = false, -- done with timer
			["MovieFrame"] = true,
			["ModelFrames"] = false, -- checked below
			["Nameplates"] = false, -- checked below
			["NavigationBar"] = true,
			["PetBattleUI"] = true,
			["PVEFrame"] = true,
			["QueueStatusFrame"] = true,
			["RaidFrame"] = true,
			["ScriptErrors"] = true,
			["StaticPopups"] = true,
			["Tooltips"] = false, -- checked below
			["Tutorial"] = true,
			["WorldMap"] = true,
			["WorldState"] = true,
			-- LoD frames
			["BattlefieldMinimap"] = false,
			["BindingUI"] = false,
			["Calendar"] = false,
			["ChallengesUI"] = false,
			["DebugTools"] = false,
			["GMChatUI"] = false,
			["GMSurveyUI"] = false,
			["GuildBankUI"] = false,
			["MacroUI"] = false,
			["MovePad"] = false,
			["StoreUI"] = false, -- N.B. cannot be skinned
			["TimeManager"] = false,
		},
	}

	-- optional frames
	if _G.IsMacClient() then self.blizzFrames.ui["MovieProgress"] = true end

	-- handle non standard ones here
	-- skin the MinimapButtons if SexyMap isn't loaded
	if not IsAddOnLoaded("SexyMap") then
		self:ScheduleTimer("checkAndRun", 1, "MinimapButtons") -- wait for a second before skinning the minimap buttons
	end

	-- skin required frames now
	for _, bfType in pairs(self.blizzFrames) do
		for skin, runNow in pairs(bfType) do
			if runNow then
				self:checkAndRun(skin)
			else
				bfType[skin] = true -- set so can be checked later in checkAndRun function
			end
		end
	end

end

local addonSkins = {
	"_NPCScan",
	"Accomplishment", "Accountant", "Acheron", "AchievementsReminder", "AckisRecipeList", "ACP", "AdiBags", "AdvancedTradeSkillWindow", "AISeller", "AlleyMap", "Altoholic", "Analyst", "AnnounceIt", "AphesLootBrowser", "Ara_Broker_Guild_Friends", "Archy", "ArkInventory", "ArkInventoryRules", "Armory", "ArmoryGuildBank", "Atlas", "AtlasLoot", "AtlasQuest", "Auctionator", "AuctionLite", "AuctionMaster", "AuctionProfitMaster", "Auctionsnatch", "AutoDecline", "AutoPartyButtons", "AutoProfit",
	"Badapples", "Baggins", "Bagnon", "Bagnon_Forever", "BankItems", "Bartender4", "BasicChatMods", "BattlePetCount", "BaudBag", "BaudManifest", "BeanCounter", "beql", "BetterInbox", "BindPad", "BlackList", "BossInfo", "BossNotes", "BossNotes_PersonalNotes", "BriefQuestComplete", "Broker_Transport", "Buffalo", "BugSack", "BulkMail2", "BulkMail2Inbox", "Butsu", "BuyEmAll",
	"CalendarNotify", "CallToArms", "Capping", "Carbonite", "CensusPlus", "CFM", "ChatBar", "Chatr", "Chatter", "Chinchilla", "Clique", "CloseUp", "Collectinator", "CollectMe", "Combuctor", "CombustionHelper", "ConcessionStand", "Converse", "CoolLine", "Cork", "Cosplay", "CowTip", "CT_MailMod", "CT_RaidTracker",
	"DaemonMailAssist", "DailiesQuestTracker", "DamageMeters", "DeathNote", "DockingStation", "Dominos", "DragonCore",
	"EasyUnlock", "EavesDrop", "EditingUI", "EggTimer", "ElvUI", "EnchantMe", "EnergyWatch", "EngBags", "EnhancedColourPicker", "EnhancedFlightMap", "EnhancedStackSplit", "EnhancedTradeSkills", "epgp", "epgp_lootmaster", "epgp_lootmaster_ml", "EquipCompare", "EventEquip", "Examiner", "ExtVendor",
	"Factionizer", "FarmIt2", "FBagOfHolding", "FB_OutfitDisplayFrame", "FB_TrackingFrame", "FeedMachine", "FishingBuddy", "Fizzle", "FlaresThatWork", "FlightMap", "FlightMapEnhanced", "FlyoutButtonCustom", "Fortress", "FPSideBar", "FramesResized", "FreierGeist_InstanceTime",
	"G15Buttons", "Gatherer", "GemMe", "Glamour", "GnomeWorks", "GnomishVendorShrinker", "Gobling", "Gossipmonger", "Grid", "GrimReaper", "GroupCalendar5", "GuildBankAccount", "GuildGreet", "GuildLaunchCT_RaidTracker", "GuildMaster",  "GupPet",
	"HabeebIt", "Hack", "Hadar_FocusFrame", "HandyNotes", "HaveWeMet", "HatTrick", "HeadCount", "HealBot", "Highlight", "HitsMode", "HoloFriends",
	"InboxMailBag", "InspectEquip", "IntricateChatMods", "IPopBar", "ItemDB", "ItemRack", "ItemSync",
	"LauncherMenu", "LazyAFK", "LightHeaded", "Links", "LinkWrangler", "Livestock", "LUI",
	"MacroBank", "MacroBrokerGUI", "MailTo", "MakeRocketGoNow", "Mapster", "MapsterEnhanced", "Megaphone", "MinimalArchaeology", "MinimapButtonFrame", "MobMap", "MogIt", "MonkeyQuest", "MonkeyQuestLog", "Mountiful", "MoveAnything", "MrTrader_SkillWindow", "MTLove", "MuffinMOTD", "MyBags", "myClock",
	"Necrosis", "NeonChat", "Notes", "nQuestLog",
	"Odyssey", "oGlow", "Omen", "OneBag3", "OneBank3", "oQueue", "oRA3", "Outfitter", "Overachiever",
	"PallyPower", "Panda", "PassLoot", "Pawn", "Perl_CombatDisplay", "Perl_Focus", "Perl_Party", "Perl_Party_Pet", "Perl_Party_Target", "Perl_Player", "Perl_Player_Pet", "Perl_Target", "Perl_Target_Target", "PetBattleHUD", "PetBattleMaster", "PetBattleTeams", "PetListPlus", "PetsPlus", "PetTracker", "PetTracker_Switcher", "PhoenixStyle", "Planner", "PlayerExpBar", "PlusOneTable", "POMAssist", "PoMTracker", "Possessions", "Postal", "PowerAuras", "PowerAurasButtons", "PreformAVEnabler", "Producer", "ProfessionsBook", "ProfessionsVault", "ProspectBar", "PvpMessages",
	"Quartz", "Quelevel", "QuestAgent", "QuestCompletist", "QuestGuru_Tracker", "QuestHelper", "QuestHelper2", "QuestHistory", "QuickMark",
	"RABuffs", "RaidAchievement", "RaidBuffStatus", "RaidChecklist", "RaidComp", "RaidRoll", "RaidRoll_LootTracker", "RaidTracker", "RaidyCheck", "RandomPet30", "RAQ", "ReagentRestocker", "Recap", "RecipeBook", "RecipeRadar", "Recount", "REFlex", "ReforgeLite", "Reforgenator", "Reforgerade", "RicoMiniMap",
	"SayGMOTD", "ScrollMaster", "ShadowDancer3", "sienasGemViewer", "SilverDragon", "Skada", "Skillet", "Smoker", "SmoothQuest", "SnapShot", "SorhaQuestLog", "Spew", "Squeenix", "sRaidFrames",
	"tabDB", "Talented", "TargetAnnounce", "tekBlocks", "tekDebug", "tekErr", "tekPad", "TheCollector", "TinyDPS", "TinyPad", "TipTac", "tomQuest2", "TomTom", "TooManyAddons", "TourGuide", "TradeSkillMaster", "TrinketBar", "Tukui", "TwinValkyr_shieldmonitor",
	"UberQuest", "UrbanAchiever",
	"vBagnon", "Vendorizer", "Vendomatic", "VendorSearch", "Violation", "Visor2_GUI", "Volumizer", "VuhDo", "VuhDoOptions",
	"Warden", "WeakAuras", "WebDKP", "Wholly", "WIM", "WoWEquip", "WowLua", "WoWPro", "WTFLatencyMeter",
	"xcalc", "XLoot", "xMerchant", "XPerl", "XPerl_RaidAdmin", "XPerl_RaidHelper",
	"zfpoison", "ZOMGBuffs", "ZygorGuidesViewer",
}
aObj.addonsToSkin = {}
for _, v in pairs(addonSkins) do
	aObj.addonsToSkin[v] = v
end
addonSkins = nil
-- oddly named addons
aObj.addonsToSkin["!Swatter"] = "Swatter"
aObj.addonsToSkin["Auc-Advanced"] = "AucAdvanced"
aObj.addonsToSkin["Auto-Bag"] = "AutoBag"
aObj.addonsToSkin["DBM-Core"] = "DBMCore"
aObj.addonsToSkin["Enchantrix-Barker"] = "EnchantrixBarker"
aObj.addonsToSkin["Ogri'Lazy"] = "OgriLazy"
aObj.addonsToSkin["Prat-3.0"] = "Prat30"
aObj.addonsToSkin["XLoot1.0"] = "XLoot10"
-- libraries
aObj.libsToSkin = {
	["Dewdrop-2.0"] = "Dewdrop",
	["AceAddon-2.0"] = "Ace2",
	["Tablet-2.0"] = "Tablet",
	["Waterfall-1.0"] = "Waterfall",
	["AceGUI-3.0"] = "Ace3",
	["Configator"] = "Configator",
	["LibExtraTip-1"] = "LibExtraTip",
	["tektip-1.0"] = "tektip",
	["LibQTip-1.0"] = "LibQTip",
	["LibSimpleFrame-Mod-1.0"] = "LibSimpleFrame",
	["ArkDewdrop-3.0"] = "ArkDewdrop",
	["LibTradeSkillScan"] = "LibTradeSkillScan",
	["LibTradeLinks-1.0"] = "LibTradeSkillScan",
	["X-UI"] = "LibXUI",
	["LibDropdown-1.0"] = "LibDropdown",
	["LibToast-1.0"] = "LibToast",
	["LibDialog-1.0"] = "LibDialog",
}
function aObj:AddonFrames()
	-- self:Debug("AddonFrames")

	-- these addons colour the Tooltip Border
	if IsAddOnLoaded("Chippu")
	or IsAddOnLoaded("TipTac")
	then
		self.ttBorder = false
	end

	-- skin tooltips here after checking whether the ttBorder setting needed changing
	self:checkAndRun("Tooltips")

	-- skin the QuestLog if EQL3 isn't loaded
	-- N.B. Do it here as other Addons use the QuestLog size
	if not IsAddOnLoaded("EQL3") then self:checkAndRun("QuestLog") end

	-- skin the CastingBar if other castbar addons aren't loaded
	if not IsAddOnLoaded("Quartz")
	and not IsAddOnLoaded("Dominos_Cast")
	then
		self:checkAndRun("CastingBar")
	end

	-- skin the CompactFrames if Tukui/ElvUI aren't loaded
	if not IsAddOnLoaded("Tukui")
	and not IsAddOnLoaded("ElvUI")
	then
		self:checkAndRun("CompactFrames")
	end

	-- skin the MainMenuBar if Dominos isn't loaded
	if not IsAddOnLoaded("Dominos") then self:checkAndRun("MainMenuBar") end

	-- skin the Minimap if SexyMap isn't loaded
	if not IsAddOnLoaded("SexyMap") then self:checkAndRun("Minimap") end

	-- skin the Nameplates if other nameplate addons aren't loaded
	if not IsAddOnLoaded("Aloft")
	and not IsAddOnLoaded("nerNameplates")
	and not IsAddOnLoaded("TidyPlates")
	and not IsAddOnLoaded("DocsUI_Nameplates")
	then
		self:checkAndRun("Nameplates")
	end

	--	don't make Model Frames Rotatable if CloseUp is loaded
	if not IsAddOnLoaded("CloseUp") then self:checkAndRun("ModelFrames") end

	-- used for Addons that aren't LoadOnDemand
	for addon, skinFunc in pairs(self.addonsToSkin) do
		self:checkAndRunAddOn(addon, nil, skinFunc)
	end
	self.addonsToSkin = nil

	-- this addon has a relation
	self:checkAndRunAddOn("EnhancedTradeSkills", nil, "EnhancedTradeCrafts")

	-- load MSBTOptions here if FuBar_MSBTFu is loaded
	if IsAddOnLoaded("FuBar_MSBTFu") then
		self:checkAndRunAddOn("MSBTOptions", true) -- use true so it isn't treated as a LoadManaged Addon
	end

	-- skin library objects
	for lib, skin in pairs(self.libsToSkin) do
		if _G.LibStub(lib, true) then
			if self[skin] then self:checkAndRun(skin) -- not an addon in its own right
			else
				if self.db.profile.Warnings then
					self:CustomPrint(1, 0, 0, skin, "loaded but skin not found in SkinMe directory")
				end
			end
		end
	end

	-- skin KeyboundDialog frame
	if self.db.profile.MenuFrames then
		if _G.LibStub('LibKeyBound-1.0', true) then
			self:skinButton{obj=_G.KeyboundDialogOkay} -- this is a CheckButton object
			self:skinButton{obj=_G.KeyboundDialogCancel} -- this is a CheckButton object
			self:addSkinFrame{obj=_G.KeyboundDialog, kfs=true, y1=4, y2=6}
		end
	end

	-- skin tekKonfig library objects
	if self.tekKonfig then self:checkAndRun("tekKonfig") end -- not an addon in its own right

	-- skin the Blizzard LoD frames if they have already been loaded by other addons, wait for 0.2 secs to allow them to have been loaded
	self:ScheduleTimer(function()
		for addon, skin in pairs(blizzLoD) do
			if IsAddOnLoaded(addon) then self:checkAndRun(skin) end
		end
	end, 0.2)

	-- skin the any LoD Addons that have already been loaded by other addons, wait for 0.2 secs to allow them to have been loaded (Tukui does this for the PetJournal, other addons do it as well)
	self:ScheduleTimer(function()
		for addon, skin in pairs(self.lodAddons) do
			if IsAddOnLoaded(addon) then self:checkAndRun(skin) end
		end
	end, 0.2)

end

local lodFrames = {
	"Altoholic_Summary", "Altoholic_Characters", "Altoholic_Search", "Altoholic_Achievements", "Altoholic_Guild", "Altoholic_Agenda", "Altoholic_Grids", "AzCastBarOptions",
	"Bagnon", "Bagnon_Options", "Bagnon_GuildBank", "Banknon", "BetterBindingFrame",
	"DockingStation_Config", "Dominos_Config", "DoTimer_Options",
	"Enchantrix", "EnhTooltip",
	"FramesResized_TalentUI",
	"GnomishAuctionShrinker", "GuildBankSearch",
	"ItemRackOptions",
	"LilSparkysWorkshop",
	"MSBTOptions",
	"oRA2_Leader", "oRA2_Participant", "Overachiever_Tabs",
	"PetJournalEnhanced", "Perl_Config_Options",
	"Scrap_Merchant", "Scrap_Options", "Scrap_Visualizer", "Squire2_Config",
	"Talented_GlyphFrame", "TradeTabs", "TipTacOptions",
	"WeakAurasOptions", "WIM_Options",
	"XPerl_Options",
	"ZOMGBuffs_BlessingsManager",
}
aObj.lodAddons = {}
for _, v in pairs(lodFrames) do
	aObj.lodAddons[v] = v
end
lodFrames = nil
-- MobMap Databases
for i = 1, 8 do
	aObj.lodAddons["MobMapDatabaseStub" .. i] = "MobMapDatabaseStub" .. i
end
aObj.lodAddons["MobMapDatabaseStub6"] = nil -- ignore stub6
-- RaidAchievement modules
for _, v in pairs{"Icecrown", "Naxxramas", "Ulduar", "WotlkHeroics", "CataHeroics", "CataRaids", "PandaHeroics", "PandaRaids", "PandaScenarios"} do
	aObj.lodAddons["RaidAchievement_" .. v] = "RaidAchievement_" .. v
end
-- oddly named LoD addons
aObj.lodAddons["_DevPad.GUI"] = "_DevPadGUI"
aObj.lodAddons["DBM-GUI"] = "DBMGUI"

local prev_addon
function aObj:LoDFrames(addon)
	-- self:Debug("LoDFrames: [%s, %s, %s]", addon, self.lodAddons[addon], blizzLoD[addon])

	-- ignore multiple occurrences of the same addon
	if addon == prev_addon then return end
	prev_addon = addon

	-- used for Blizzard LoadOnDemand Addons
	if blizzLoD[addon] then self:checkAndRun(blizzLoD[addon]) end

	-- used for User LoadOnDemand Addons
	if self.lodAddons[addon] then self:checkAndRunAddOn(addon, true, self.lodAddons[addon]) end

	-- handle addons linked to the InspectUI
	if addon == "Blizzard_InspectUI" then
		--	This addon is dependent upon the Inspect Frame
		self:checkAndRunAddOn("Spyglass")
	end

	-- deal with Addons under the control of an LoadManager
	-- use lowercase addonname (lazyafk issue)
	if self.lmAddons[addon:lower()] then
		self:checkAndRunAddOn(addon, true, self.lmAddons[addon:lower()])
		self.lmAddons[addon:lower()] = nil
	end

	-- handle FramesResized changes
	if IsAddOnLoaded("FramesResized") then
		if addon == "Blizzard_TradeSkillUI" and self.FR_TradeSkillUI then self:checkAndRun("FR_TradeSkillUI") -- not an addon in its own right
		elseif addon == "Blizzard_TrainerUI" and self.FR_TrainerUI then self:checkAndRun("FR_TrainerUI") -- not an addon in its own right
		end
	end

	-- load library skins here as well, they may only get loaded by a LoD AddOn
	-- e.g. Dewdrop by ArkInventory when an AddonLoader is used
	for k, v in pairs(self.libsToSkin) do
		if _G.LibStub(k, true) then
			if self[v] then self:checkAndRun(v) end
		end
	end

end

-- Event processing here
function aObj:ADDON_LOADED(event, addon)
	-- self:Debug("ADDON_LOADED: [%s]", addon)

	self:ScheduleTimer("LoDFrames", self.db.profile.Delay.LoDs, addon)

end

function aObj:AUCTION_HOUSE_SHOW()
	-- self:Debug("AUCTION_HOUSE_SHOW")

	self:checkAndRun("AuctionUI") -- npc
	-- trigger these when AH loads otherwise errors occur
	self:checkAndRunAddOn("BtmScan")
	self:checkAndRunAddOn("AuctionFilterPlus")
	self:checkAndRunAddOn("Auctionator")

	-- handle TradeSkillMaster_Auctioning frame size changes
	if IsAddOnLoaded("TradeSkillMaster_Auctioning")
	or IsAddOnLoaded("TradeSkillMaster_AuctionDB")
	or IsAddOnLoaded("TradeSkillMaster_Shopping")
	then
		self:checkAndRun("TSM_AuctionFrameHook")
	end

	self:UnregisterEvent("AUCTION_HOUSE_SHOW")

end

function aObj:PLAYER_ENTERING_WORLD()
	-- self:Debug("PLAYER_ENTERING_WORLD")

	-- use this to handle textures supplied by other addons (e.g. XPerl)
	self:updateSBTexture()

	self:UnregisterEvent("PLAYER_ENTERING_WORLD")

end

function aObj:TRADE_SKILL_SHOW()
	-- self:Debug("TRADE_SKILL_SHOW")

	self:checkAndRun("TradeSkillUI") -- player
	-- trigger this when TradeSkill loads otherwise it doesn't get loaded
	self:checkAndRunAddOn("ReagentMaker")

	-- trigger this to skin ProfessionTabs
	self:checkAndRunAddOn("ProfessionTabs_TSF")

	self:UnregisterEvent("TRADE_SKILL_SHOW")

end

function aObj:TRADE_SHOW()
	-- self:Debug("TRADE_SHOW")

	-- trigger this to skin ProfessionTabs
	self:checkAndRunAddOn("ProfessionTabs_TF")

	self:UnregisterEvent("TRADE_SHOW")

end
