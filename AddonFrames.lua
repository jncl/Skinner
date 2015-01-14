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
	"BarbershopUI", "BlackMarketUI", "ItemAlterationUI", "ItemUpgradeUI", "GarrisonUI", "QuestChoice", "TrainerUI", "VoidStorageUI",
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
			["ObjectiveTracker"] = true,
			["OverrideActionBar"] = true,
			["ReadyCheck"] = true,
			["RolePollPopup"] = true,
			["ScrollOfResurrection"] = true,
			["SpellBookFrame"] = true,
			["StackSplit"] = true,
			["TradeFrame"] = true,
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
			["AddonList"] = true,
			["AlertFrames"] = true,
			["AuthChallengeUI"] = false, -- N.B. cannot be skinned
			["AutoComplete"] = true,
			["BNFrames"] = true,
			["ChatBubbles"] = true,
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
			["DraenorZoneAbility"] = true,
			["DropDownPanels"] = true,
			["GarrisonFollowerTooltips"] = true,
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
			["QuestMap"] = false, -- checked below
			["QueueStatusFrame"] = true,
			["RaidFrame"] = true,
			["ScriptErrors"] = true,
			["SplashFrame"] = true,
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
	"Accountant", "Acheron", "AckisRecipeList", "ACP", "AdiBags", "Altoholic", "AphesLootBrowser", "Archy", "ArkInventory", "ArkInventoryRules", "Armory", "ArmoryGuildBank", "Atlas", "AtlasLoot", "Auctionator", "AuctionMaster", "Auctionsnatch", "AutoDecline",
	"Baggins", "Bagnon_Forever", "Bagnon", "BankItems", "Bartender4", "BattlePetCount", "BaudBag", "BaudManifest", "BetterInbox", "BindPad", "BlackList", "BonusRollPreview", "BossInfo", "BossNotes", "BossNotes_PersonalNotes", "Bugger", "BugSack", "BulkMail2", "BulkMail2Inbox", "BuyEmAll",
	"Carbonite", "CensusPlus", "CFM", "Chatter", "Clique", "Collectinator", "CollectMe", "Combuctor", "CombustionHelper", "CompactMissions", "CoolLine", "Cork", "Cosplay",
	"DeathNote", "DockingStation", "Dominos",
	"ElvUI", "EnergyWatch", "EnhancedColourPicker", "EnhancedFlightMap", "EnhancedStackSplit", "epgp_lootmaster", "epgp_lootmaster_ml", "epgp", "Examiner", "ExtVendor",
	"FarmIt2", "FeedMachine", "FishingBuddy", "Fizzle", "FlaresThatWork", "FlightMapEnhanced", "FlyoutButtonCustom", "Fortress", "FramesResized", "FreierGeist_InstanceTime",
	"G15Buttons", "Glamour", "GnomeWorks", "GnomishVendorShrinker", "GroupCalendar5", "GuildLaunchCT_RaidTracker", "GuildMaster",
	"HandyNotes", "HaveWeMet", "HealBot", "HoloFriends",
	"InboxMailBag", "ItemDB",
	"LegacyQuest", "Livestock", "LUI",
	"Mapster", "MapsterEnhanced", "MarkingBar", "Megaphone", "MinimalArchaeology", "MinimapButtonFrame", "MogIt", "MrTrader_SkillWindow", "MyGarrisons",
	"Notes",
	"oGlow", "oQueue", "oRA3", "Omen", "OneBag3", "OneBank3", "Outfitter", "Overachiever",
	"Panda", "Pawn", "Perl_CombatDisplay", "Perl_Focus", "Perl_Party", "Perl_Party_Pet", "Perl_Party_Target", "Perl_Player", "Perl_Player_Pet", "Perl_Target", "Perl_Target_Target", "PetBattleHUD", "PetBattleMaster", "PetTracker", "PetTracker_Switcher", "PetTracker_Journal", "PhoenixStyle", "Possessions", "PowerAuras", "PowerAurasButtons", "PreformAVEnabler", "ProfessionsVault", "ProspectBar",
	"Quartz", "QuestCompletist", "QuestGuru", "QuestGuru_Tracker", "QuestHelper2", "QuestHistory", "QuestMapWithDetails", "QuickMark",
	"RaidAchievement", "RaidBuffStatus", "RaidRoll", "RaidRoll_LootTracker", "RAQ", "ReagentRestocker", "Recount", "REFlex", "RicoMiniMap",
	"ScrollMaster", "SilverDragon", "Skada", "Skillet", "Smoker", "SnapShot", "SorhaQuestLog", "Spew", "Squeenix", "StaggerMeter",
	"TargetCharms", "TooManyAddons", "TradeSkillMaster", "TrinketBar", "Tukui",
	"UrbanAchiever",
	"Vendomatic", "VuhDo", "VuhDoOptions",
	"Warden", "WeakAuras", "Wholly", "WIM", "WIM_Options", "WoWPro", "WTFLatencyMeter",
	"XLoot", "xMerchant", "XPerl", "XPerl_RaidAdmin", "XPerl_RaidHelper",
	"ZygorGuidesViewer",
}
aObj.addonsToSkin = {}
for _, v in pairs(addonSkins) do
	aObj.addonsToSkin[v] = v
end
addonSkins = nil
-- oddly named addons
aObj.addonsToSkin["Auc-Advanced"] = "AucAdvanced"
aObj.addonsToSkin["Auto-Bag"] = "AutoBag"
aObj.addonsToSkin["Classic Quest Log"] = "ClassicQuestLog"
aObj.addonsToSkin["DBM-Core"] = "DBMCore"
aObj.addonsToSkin["Enchantrix-Barker"] = "EnchantrixBarker"
aObj.addonsToSkin["Prat-3.0"] = "Prat30"
aObj.addonsToSkin["XLoot1.0"] = "XLoot10"
-- libraries
aObj.libsToSkin = {
	["AceGUI-3.0"] = "Ace3",
	["Configator"] = "Configator",
	["tektip-1.0"] = "tektip",
	["LibQTip-1.0"] = "LibQTip",
	["ArkDewdrop-3.0"] = "ArkDewdrop",
	["LibTradeSkillScan"] = "LibTradeSkillScan",
	["LibTradeLinks-1.0"] = "LibTradeSkillScan",
	["X-UI"] = "LibXUI",
	["LibDropdown-1.0"] = "LibDropdown",
	["LibToast-1.0"] = "LibToast",
	["LibDialog-1.0"] = "LibDialog",
	["LibExtraTip-1"] = "LibExtraTip",
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

	-- skin the QuestMap if EQL3 isn't loaded
	-- N.B. Do it here as other Addons use the QuestLog size
	if not IsAddOnLoaded("EQL3") then self:checkAndRun("QuestMap") end

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

	-- special case for dummy addon entry WIM_Options
	if self.WIM_Options then self:checkAndRun("WIM_Options") end -- not an addon in its own right

	-- used for Addons that aren't LoadOnDemand
	for addon, skinFunc in pairs(self.addonsToSkin) do
		self:checkAndRunAddOn(addon, nil, skinFunc)
	end
	self.addonsToSkin = nil

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

	-- skin tekKonfig library objects (N.B. not a LibStub library)
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
	"Bagnon", "Bagnon_Options", "Bagnon_GuildBank", "Banknon",
	"DockingStation_Config", "Dominos_Config", "DoTimer_Options",
	"Enchantrix",
	"GarrisonMissionManager", "GuildBankSearch",
	"LilSparkysWorkshop", "Ludwig_Window",
	"MasterPlan",
	"Overachiever_Tabs",
	"PetJournalEnhanced", "Perl_Config_Options",
	"Scrap_Merchant", "Scrap_Options", "Scrap_Visualizer",
	"WeakAurasOptions",
	"XPerl_Options",
}
aObj.lodAddons = {}
for _, v in pairs(lodFrames) do
	aObj.lodAddons[v] = v
end
lodFrames = nil
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

	-- handle addons linked to the PetJournal
	if addon == "Blizzard_PetJournal" then
		--	This addon is dependent upon the PetJournal
		self:checkAndRunAddOn("PetBattleTeams")
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

	self:checkAndRunAddOn("TradeSkillDW")

	self:UnregisterEvent("TRADE_SKILL_SHOW")

end

function aObj:TRADE_SHOW()
	-- self:Debug("TRADE_SHOW")

	-- trigger this to skin ProfessionTabs
	self:checkAndRunAddOn("ProfessionTabs_TF")

	self:UnregisterEvent("TRADE_SHOW")

end
