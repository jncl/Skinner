local aName, aObj = ...

local blizzLoDFrames = {
	-- player
	"AchievementUI", "ArchaeologyUI", "EncounterJournal", "GlyphUI", "GuildControlUI", "GuildUI", "InspectUI", "ItemSocketingUI", "LookingForGuildUI", "RaidUI", "TalentUI", 
	-- TradeSkillUI, loaded when TRADE_SKILL_SHOW event is fired
	-- npc
 	--AuctionUI, loaded when AUCTION_HOUSE_SHOW event is fired
	"BarbershopUI", "BlackMarketUI", "ItemAlterationUI", "ReforgingUI", "TrainerUI", "VoidStorageUI",
	-- ui
	"BattlefieldMinimap", "BindingUI", "Calendar", "ChallengesUI", "DebugTools", "GMChatUI", "GMSurveyUI", "GuildBankUI", "ItemUpgradeUI", "MacroUI", "MovePad", "PetJournal", "TimeManager", 
	--[=[
		ArenaUI -- unitframes skinned in UnitFrames.lua
	--]=]
}
-- optional frames
if aObj.isPTR then aObj:add2Table(blizzLoDFrames, "FeedbackUI") end -- ui
local blizzLoD = {}
for _, v in pairs(blizzLoDFrames) do
	blizzLoD["Blizzard_"..v] = v
end
blizzLoDFrames = nil
function aObj:BlizzardFrames()
--	  self:Debug("BlizzardFrames")

	local blizzFrames = {
		-- player
		"Buffs",
		-- CastingBar, checked with Quartz below
		"CharacterFrames", "CompactFrames", "ContainerFrames", "DressUpFrame", "EquipmentFlyout", "FriendsFrame", "GhostFrame", "GuildInvite", "LootFrames", "LootHistory", "MirrorTimers", "OverrideActionBar", "PVPFrame", 
		-- QuestLog, checked with EQL3 & QuestGuru below
		"ReadyCheck", "RolePollPopup", "ScrollOfResurrection", "SpellBookFrame", "SpellFlyout", "StackSplit", "TradeFrame", "WatchFrame", 
	    -- npc
		"ArenaRegistrar", "BankFrame", "GossipFrame", "GuildRegistrar", "MerchantFrame", "Petition", "PetStableFrame", "QuestFrame", "SideDressUpFrame", "Tabard", "TaxiFrame", 
		-- ui
		"AlertFrames", "AutoComplete", "BNFrames", "ChatButtons", "ChatConfig", "ChatEditBox", "ChatFrames", "ChatMenus", "ChatMinimizedFrames", "ChatTabs", "ChatTemporaryWindow", "CinematicFrame",  "CoinPickup", "ColorPicker", "DestinyFrame", "DropDownPanels", "HelpFrame", "ItemText", "LevelUpDisplay", "LFDFrame", "LFGFrame", "LFRFrame", "MailFrame",
		-- MainMenuBar, checked with Bongos below
		"MenuFrames", "Minimap", 
		-- MinimapButtons, done with timer
		-- ModelFrames, checked with CloseUp below
		-- Nameplates, checked with Aloft below
		"PetBattleUI", "PVEFrame", "RaidFrame", "ScriptErrors", "StaticPopups", 
		-- Tooltips, checked below
		"Tutorial", "WorldMap", "WorldState", 
	}

	-- optional frames
	if IsMacClient() then aObj:add2Table(blizzFrames, "MovieProgress") end -- ui

	for _, v in pairs(blizzFrames) do
		self:checkAndRun(v)
	end
	blizzFrames = nil

	-- handle non standard ones here
	self:ScheduleTimer("checkAndRun", 1, "MinimapButtons") -- wait for a second before skinning the minimap buttons

end

local stdFrames = {
	"_NPCScan",
	"Accomplishment", "Accountant", "Acheron", "AckisRecipeList", "ACP", "AdiBags", "AdvancedTradeSkillWindow", "AISeller", "AlleyMap", "Altoholic", "Analyst", "AnnounceIt", "AphesLootBrowser", "Ara_Broker_Guild_Friends", "Archy", "ArkInventory", "ArkInventoryRules", "Armory", "ArmoryGuildBank", "Atlas", "AtlasLoot", "AtlasQuest", "Auctionator", "AuctionLite", "AuctionProfitMaster", "Auctionsnatch", "AutoDecline", "AutoPartyButtons", "AutoProfit",
	"Badapples", "Baggins", "Bagnon", "Bagnon_Forever", "BankItems", "BasicChatMods", "BaudBag", "BaudManifest", "BeanCounter", "beql", "BetterInbox", "BindPad", "BlackList", "BossInfo", "BossNotes", "BossNotes_PersonalNotes", "BriefQuestComplete", "Broker_Transport", "Buffalo", "BugSack", "Butsu", "BuyEmAll",
	"CalendarNotify", "CallToArms", "Capping", "Carbonite", "CFM", "ChatBar", "Chatr", "Chatter", "Chinchilla", "Clique", "CloseUp", "Collectinator", "Combuctor", "CombustionHelper", "ConcessionStand", "Converse", "CoolLine", "Cork", "Cosplay", "CowTip", "CT_MailMod", "CT_RaidTracker",
	"DaemonMailAssist", "DailiesQuestTracker", "DamageMeters", "DeathNote", "DockingStation", "Dominos", "DragonCore",
	"EasyUnlock", "EavesDrop", "EditingUI", "EggTimer", "ElvUI", "EnchantMe", "EnergyWatch", "EngBags", "EnhancedColourPicker", "EnhancedFlightMap", "EnhancedStackSplit", "EnhancedTradeSkills", "epgp", "epgp_lootmaster", "epgp_lootmaster_ml", "EquipCompare", "EventEquip", "Examiner", "ExtVendor",
	"Factionizer", "FBagOfHolding", "FB_OutfitDisplayFrame", "FB_TrackingFrame", "FeedMachine", "FishingBuddy", "Fizzle", "FlightMap", "FlightMapEnhanced", "FlyoutButtonCustom", "Fortress", "FPSideBar", "FramesResized", "FreierGeist_InstanceTime",
	"G15Buttons", "Gatherer", "GemMe", "Glamour", "GnomeWorks", "GnomishVendorShrinker", "Gobling", "Gossipmonger", "Grid", "GrimReaper", "GroupCalendar5", "GuildBankAccount", "GuildGreet", "GuildLaunchCT_RaidTracker", "GuildMaster",  "GupPet",
	"Hack", "Hadar_FocusFrame", "HandyNotes", "HatTrick", "HeadCount", "HealBot", "Highlight", "HitsMode", "HoloFriends",
	"InspectEquip", "IntricateChatMods", "IPopBar", "ItemRack", "ItemSync",
	"LauncherMenu", "LazyAFK", "LightHeaded", "Links", "LinkWrangler", "Livestock",
	"MacroBank", "MacroBrokerGUI", "MailTo", "MakeRocketGoNow", "Mapster", "Megaphone", "MinimalArchaeology", "MinimapButtonFrame", "MobMap", "MogIt", "MonkeyQuest", "MonkeyQuestLog", "Mountiful", "MoveAnything", "MrTrader_SkillWindow", "MTLove", "MuffinMOTD", "MyBags", "myClock",
	"Necrosis", "NeonChat", "nQuestLog",
	"Odyssey", "oGlow", "Omen", "OneBag3", "OneBank3", "oRA3", "Outfitter", "Overachiever",
	"PallyPower", "Panda", "PassLoot", "Pawn", "Perl_CombatDisplay", "Perl_Focus", "Perl_Party", "Perl_Party_Pet", "Perl_Party_Target", "Perl_Player", "Perl_Player_Pet", "Perl_Target", "Perl_Target_Target", "PetListPlus", "PetsPlus", "PhoenixStyle", "Planner", "PlayerExpBar", "PlusOneTable", "POMAssist", "PoMTracker", "Possessions", "Postal", "PowerAuras", "PowerAurasButtons", "PreformAVEnabler", "Producer", "ProfessionsBook", "ProfessionTabs", "PvpMessages",
	"Quartz", "Quelevel", "QuestAgent", "QuestCompletist", "QuestGuru_Tracker", "QuestHelper", "QuestHelper2", "QuestHistory", "QuickMark",
	"RABuffs", "RaidAchievement", "RaidAchievement_AchieveReminder", "RaidBuffStatus", "RaidChecklist", "RaidComp", "RaidTracker", "RaidyCheck", "RandomPet30", "ReagentRestocker", "Recap", "RecipeBook", "RecipeRadar", "Recount", "REFlex", "ReforgeLite", "Reforgenator", "Reforgerade", "RicoMiniMap",
	"SayGMOTD", "ScrollMaster", "ShadowDancer3", "sienasGemViewer", "Skada", "Skillet", "Smoker", "SmoothQuest", "SnapShot", "Spew", "Squeenix", "sRaidFrames",
	"tabDB", "Talented", "TargetAnnounce", "tekBlocks", "tekDebug", "tekErr", "tekPad", "TheCollector", "TinyDPS", "TinyPad", "TipTac", "tomQuest2", "TomTom", "TooManyAddons", "TourGuide", "TradeSkillMaster", "TrinketBar", "Tukui", "TwinValkyr_shieldmonitor",
	"UberQuest", "UrbanAchiever",
	"vBagnon", "Vendorizer", "Vendomatic", "VendorSearch", "Violation", "Visor2_GUI", "Volumizer", "VuhDo", "VuhDoOptions",
	"Warden", "WeakAuras", "WebDKP", "WIM", "WoWEquip", "WowLua", "WoWPro", "WTFLatencyMeter",
	"xcalc", "XLoot", "XLootGroup", "XLootMonitor", "xMerchant", "XPerl", "XPerl_RaidAdmin", "XPerl_RaidHelper",
	"zfpoison", "ZOMGBuffs"
}
aObj.stdAddons = {}
for _, v in pairs(stdFrames) do
	aObj.stdAddons[v] = v
end
stdFrames = nil
-- oddly named addons
aObj.stdAddons["!Swatter"] = "Swatter"
aObj.stdAddons["Auc-Advanced"] = "AucAdvanced"
aObj.stdAddons["Auto-Bag"] = "AutoBag"
aObj.stdAddons["DBM-Core"] = "DBMCore"
aObj.stdAddons["Enchantrix-Barker"] = "EnchantrixBarker"
aObj.stdAddons["Ogri'Lazy"] = "OgriLazy"
aObj.stdAddons["Prat-3.0"] = "Prat30"
aObj.stdAddons["XLoot1.0"] = "XLoot10"
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

}
function aObj:AddonFrames()
--	   self:Debug("AddonFrames")

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

	-- skin the CastingBar if Quartz isn't loaded
	if not IsAddOnLoaded("Quartz") then self:checkAndRun("CastingBar") end

	-- skin the MenuBar if Bongos isn't loaded
	if not IsAddOnLoaded("Bongos")
	and not IsAddOnLoaded("Bongos2")
	then
		self:checkAndRun("MainMenuBar")
	end

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
	for _, v in pairs(self.stdAddons) do
		self:checkAndRunAddOn(v)
	end
	self.stdAddons = nil

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

	-- skin library objects
	for k, v in pairs(self.libsToSkin) do
		if LibStub(k, true) then
			if self[v] then self:checkAndRun(v) -- not an addon in its own right
			else
				if self.db.profile.Warnings then
					self:CustomPrint(1, 0, 0, v, "loaded but skin not found in SkinMe directory")
				end
			end
		end
	end

	-- skin Rock Config
	if Rock and Rock:HasLibrary("LibRockConfig-1.0") then
		if self.RockConfig then self:checkAndRun("RockConfig") -- not an addon in its own right
		else
			if self.db.profile.Warnings then
				self:CustomPrint(1, 0, 0, "RockConfig", "loaded but skin not found in SkinMe directory")
			end
		end
	end

	-- skin KeyboundDialog frame
	if self.db.profile.MenuFrames then
		if LibStub('LibKeyBound-1.0', true) then
			self:skinButton{obj=KeyboundDialogOkay} -- this is a CheckButton object
			self:skinButton{obj=KeyboundDialogCancel} -- this is a CheckButton object
			self:addSkinFrame{obj=KeyboundDialog, kfs=true, y1=4, y2=6}
		end
	end

	-- skin tekKonfig library objects
	if self.tekKonfig then self:checkAndRun("tekKonfig") end -- not an addon in its own right

end

local lodFrames = {
	"Altoholic_Characters", "Altoholic_Search", "Altoholic_Achievements", "Altoholic_Guild", "Altoholic_Agenda", "Altoholic_Grids", "AzCastBarOptions",
	"Bagnon", "Bagnon_Options", "Banknon", "BetterBindingFrame",
	"DockingStation_Config", "Dominos_Config", "DoTimer_Options",
	"Enchantrix", "EnhTooltip",
	"FramesResized_TalentUI",
	"GnomishAuctionShrinker", "GuildBankSearch",
	"ItemRackOptions",
	"LilSparkysWorkshop",
	"MSBTOptions",
	"oRA2_Leader", "oRA2_Participant", "Overachiever_Tabs",
	"Perl_Config_Options",
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
	aObj.lodAddons["MobMapDatabaseStub"..i] = "MobMapDatabaseStub"..i
end
aObj.lodAddons["MobMapDatabaseStub6"] = nil -- ignore stub6
-- RaidAchievement modules
for _, v in pairs{"Icecrown", "Naxxramas", "Ulduar", "WotlkHeroics", "CataHeroics", "CataRaids"} do
	aObj.lodAddons["RaidAchievement_"..v] = "RaidAchievement_"..v
end
-- oddly named LoD addons
aObj.lodAddons["_DevPad.GUI"] = "_DevPadGUI"
aObj.lodAddons["DBM-GUI"] = "DBMGUI"

local prev_addon
function aObj:LoDFrames(addon)
	-- self:Debug("LoDFrames: [%s]", addon)

	-- ignore multiple occurrences of the same addon
	if addon == prev_addon then return end
	prev_addon = addon

	-- used for Blizzard LoadOnDemand Addons
	if blizzLoD[addon] then self:checkAndRun(blizzLoD[addon]) end

	-- used for User LoadOnDemand Addons
	if self.lodAddons[addon] then self:checkAndRunAddOn(self.lodAddons[addon], true) end

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
		if LibStub(k, true) then
			if self[v] then self:checkAndRun(v) end
		end
	end

end

function aObj:ADDON_LOADED(event, addon)
	-- self:Debug("ADDON_LOADED: [%s]", addon)

	self:ScheduleTimer("LoDFrames", self.db.profile.Delay.LoDs, addon)

end

function aObj:AUCTION_HOUSE_SHOW()
--	self:Debug("AUCTION_HOUSE_SHOW")

	self:checkAndRun("AuctionUI") -- npc
	-- trigger these when AH loads otherwise errors occur
	self:checkAndRunAddOn("BtmScan")
	self:checkAndRunAddOn("AuctionFilterPlus")

	self:UnregisterEvent("AUCTION_HOUSE_SHOW")

end

function aObj:TRADE_SKILL_SHOW()
--	self:Debug("TRADE_SKILL_SHOW")

	self:checkAndRun("TradeSkillUI") -- player
	-- trigger this when TradeSkill loads otherwise it doesn't get loaded
	self:checkAndRunAddOn("ReagentMaker")

	self:UnregisterEvent("TRADE_SKILL_SHOW")

end
