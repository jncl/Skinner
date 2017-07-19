local aName, aObj = ...
local _G = _G

-- Add locals to see if it speeds things up
local IsAddOnLoaded, pairs = _G.IsAddOnLoaded, _G.pairs

function aObj:BlizzardFrames()
	-- self:Debug("BlizzardFrames")

	-- skin Blizzard frames
	for k1, v1 in pairs(self.blizzFrames) do
		if k1 ~= "o" then -- ignore options functions
			for k2, v2 in pairs(v1) do
				self:checkAndRun(k2, k1)
			end
		end
	end

end

local addonSkins = {
	"_NPCScan",
	"Accountant", "Acheron", "AckisRecipeList", "ACP", "AdiBags", "AdvancedInterfaceOptions", "Altoholic", "AngryKeystones", "AphesLootBrowser", "Archy", "ArkInventory", "ArkInventoryRules", "Armory", "ArmoryGuildBank", "Atlas", "AtlasLoot", "Auctionator", "AuctionMaster", "Auctionsnatch", "AutoDecline",
	"Baggins", "Bagnon_Forever", "Bagnon", "BankItems", "Bartender4", "BattlePetCount", "BaudBag", "BaudManifest", "BetterInbox", "BGDefender", "BindPad", "BlackList", "BonusRollPreview", "BossInfo", "BossNotes", "BossNotes_PersonalNotes", "Bugger", "BugSack", "BulkMail2", "BulkMail2Inbox", "BuyEmAll",
	"Carbonite", "CensusPlus", "CFM", "Chatter", "ClassOrderHallsComplete", "Clique", "Collectinator", "CollectMe", "Combuctor", "CombustionHelper", "CompactMissions", "CoolLine", "Cork", "Cosplay",
	"DeathNote", "DejaCharacterStats", "Details", "DockingStation", "Dominos", "DressUp",
	"ElvUI", "EnergyWatch", "EnhancedColourPicker", "EnhancedFlightMap", "EnhancedStackSplit", "epgp_lootmaster", "epgp_lootmaster_ml", "epgp", "Examiner", "ExtVendor",
	"FarmIt2", "FeedMachine", "FishingBuddy", "Fizzle", "FlaresThatWork", "FlightMapEnhanced", "FlyoutButtonCustom", "Fortress", "FramesResized", "FreierGeist_InstanceTime",
	"G15Buttons", "Glamour", "GnomeWorks", "GnomishVendorShrinker", "GroupCalendar5", "Growler", "GuildLaunchCT_RaidTracker", "GuildMaster",
	"HandyNotes", "HaveWeMet", "HealBot", "HoloFriends",
	"InboxMailBag", "ItemDB", "InspectorGadgetzan", "Inventorian",
	"KeystoneCommander",
	"LegacyQuest", "Livestock", "ls_Prospector", "ls_Toasts", "LUI",
	"MacroToolkit", "Mapster", "MapsterEnhanced", "MarkingBar", "Megaphone", "MinimalArchaeology", "MinimapButtonFrame", "MobileVault", "MogIt", "MoveAnything", "MrTrader_SkillWindow", "MyGarrisons",
	"Notes",
	"oGlow", "oQueue", "oRA3", "Omen", "OneBag3", "OneBank3", "Outfitter", "Overachiever",
	"Panda", "Pawn", "Perl_CombatDisplay", "Perl_Focus", "Perl_Party", "Perl_Party_Pet", "Perl_Party_Target", "Perl_Player", "Perl_Player_Pet", "Perl_Target", "Perl_Target_Target", "PetBattleHUD", "PetBattleMaster", "PetTracker", "PetTracker_Switcher", "PetTracker_Journal", "PhoenixStyle", "Possessions", "Postal", "PowerAuras", "PowerAurasButtons", "PreformAVEnabler", "PremadeGroupsFilter", "ProfessionsVault", "ProspectBar",
	"Quartz", "QuestCompletist", "QuestGuru", "QuestGuru_Tracker", "QuestHelper2", "QuestHistory", "QuestMapWithDetails", "QuickMark",
	"RaidAchievement", "RaidBuffStatus", "RaidRoll", "RaidRoll_LootTracker", "RAQ", "ReagentRestocker", "Recount", "REFlex", "Rematch", "RicoMiniMap",
	"ScrollMaster", "ServerHop", "SilverDragon", "Skada", "Skillet", "Smoker", "SnapShot", "SorhaQuestLog", "Spew", "Squeenix", "StaggerMeter",
	"TargetCharms", "TidyPlates", "TinyDPS", "TinyTooltip", "TipTac", "TomTom", "TooManyAddons", "TradeSkillMaster", "TrinketBar", "Tukui",
	"UrbanAchiever",
	"Vendomatic", "VuhDo", "VuhDoOptions",
	"Warden", "WeakAuras", "Wholly", "WIM", "WIM_Options", "WorldQuestGroupFinder", "WorldQuestTracker", "WoWPro", "WTFLatencyMeter",
	"XLoot", "xMerchant", "XPerl", "XPerl_RaidAdmin", "XPerl_RaidHelper",
	"ZPerl", "ZPerl_RaidAdmin", "ZPerl_RaidHelper", "ZygorGuidesViewer",
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
	["ArkDewdrop"] = "ArkDewdrop",
	["Configator"] = "Configator",
	["DetailsFramework-1.0"] = "DetailsFramework",
	["LibDialog-1.0"] = "LibDialog",
	["LibDropdown-1.0"] = "LibDropdown",
	["NoTaint_UIDropDownMenu-7.2.0"] = "Lib_UIDropdown",
	["LibExtraTip-1"] = "LibExtraTip",
	["LibKeyBound-1.0"] = "LibKeyBound",
	["LibQTip-1.0"] = "LibQTip",
	["LibToast-1.0"] = "LibToast",
	["LibTradeLinks-1.0"] = "LibTradeSkillScan",
	["LibTradeSkillScan"] = "LibTradeSkillScan",
	["tektip-1.0"] = "tektip",
	["X-UI"] = "LibXUI",
}
-- store other AddOns not previously referenced, here
aObj.otherAddons = {}
aObj.otherAddons["tekKonfig"] = true
-- aObj.otherAddons["LibKeyBound"] = true
aObj.otherAddons["WIM_Options"] = false
local function skinLibs()

	-- skin library objects
	for libName, skinFunc in pairs(aObj.libsToSkin) do
		if _G.LibStub(libName, true) then
			if skinFunc then
				aObj:checkAndRun(skinFunc, "s") -- not an addon in its own right
			else
				if aObj.db.profile.Warnings then
					aObj:CustomPrint(1, 0, 0, libName, "loaded but skin not found in SkinMe directory")
				end
			end
		end
	end

end
local function skinBLoD(addon)

	local bLoD
	for fType, fTab in pairs(aObj.blizzLoDFrames) do
		for fName, _ in pairs(fTab) do
			bLoD = "Blizzard_" .. fName
			if (addon and addon == bLoD)
			or IsAddOnLoaded(bLoD)
			then
				aObj:checkAndRun(fName, fType, true)
			end
		end
	end
	bLoD = nil

end
function aObj:AddonFrames()
	-- self:Debug("AddonFrames")

	-- special case for dummy addon entry WIM_Options
	if self.WIM_Options then self:checkAndRun("WIM_Options", "s") end -- not an addon in its own right

	-- used for Addons that aren't LoadOnDemand
	for addOnName, skinFunc in pairs(self.addonsToSkin) do
		self:checkAndRunAddOn(addOnName, nil, skinFunc)
	end
	self.addonsToSkin = nil

	-- skin tekKonfig library objects (N.B. not a LibStub library)
	if self.tekKonfig then self:checkAndRun("tekKonfig", "s") end -- not an addon in its own right

	-- skin any Blizzard LoD frames or LoD addons that have already been loaded by other addons, waiting to allow them to be loaded
	-- (Tukui does this for the PetJournal, other addons do it as well)
	_G.C_Timer.After(0.2, function()
		skinBLoD()
		for name, skinFunc in pairs(self.lodAddons) do
			if IsAddOnLoaded(name) then self:checkAndRunAddOn(name, true, skinFunc) end
		end
	end)

	-- skin library objects after a short delay to allow them to be loaded
	_G.C_Timer.After(0.2, function() skinLibs() end)

end

local lodFrames = {
	"Altoholic_Summary", "Altoholic_Characters", "Altoholic_Search", "Altoholic_Achievements", "Altoholic_Guild", "Altoholic_Agenda", "Altoholic_Grids", "ArkInventorySearch", "AzCastBarOptions",
	"DockingStation_Config", "DoTimer_Options",
	"Enchantrix",
	"GarrisonMissionManager", "GuildBankSearch",
	"LilSparkysWorkshop", "Ludwig_Window",
	"MasterPlan",
	"Overachiever_Tabs",
	"PetJournalEnhanced", "Perl_Config_Options",
	"Scrap_Merchant", "Scrap_Options", "Scrap_Visualizer",
	"TipTacOptions",
	"WeakAurasOptions",
	"XPerl_Options",
	"ZPerl_Options",
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

aObj.otherAddons["PetBattleTeams"] = false

local prev_addon
function aObj:LoDFrames(addon)
	-- self:Debug("LoDFrames: [%s, %s]", addon, self.lodAddons[addon])

	-- ignore multiple occurrences of the same addon
	if addon == prev_addon then return end
	prev_addon = addon

	-- check to see if it's a Blizzard LoD Frame
	skinBLoD()

	-- used for User LoadOnDemand Addons
	if self.lodAddons[addon] then self:checkAndRunAddOn(addon, true, self.lodAddons[addon]) end

	-- handle addons linked to the PetJournal
	if addon == "Blizzard_Collections" then
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
		if addon == "Blizzard_TradeSkillUI" and self.FR_TradeSkillUI then self:checkAndRun("FR_TradeSkillUI", "s") -- not an addon in its own right
		elseif addon == "Blizzard_TrainerUI" and self.FR_TrainerUI then self:checkAndRun("FR_TrainerUI", "s") -- not an addon in its own right
		end
	end

	-- load library skins here as well, they may only get loaded by a LoD AddOn
	-- include a short delay to allow them to be loaded
	-- e.g. ArkDewdrop by ArkInventory when an AddonLoader is used
	_G.C_Timer.After(0.2, function() skinLibs() end)

end

-- Event processing here
function aObj:ADDON_LOADED(event, addon)
	-- self:Debug("ADDON_LOADED: [%s]", addon)

	_G.C_Timer.After(self.db.profile.Delay.LoDs, function() aObj:LoDFrames(addon) end)

end

aObj.otherAddons["TradeSkillMaster_Auctioning"] = false
aObj.otherAddons["TradeSkillMaster_AuctionDB"] = false
aObj.otherAddons["TradeSkillMaster_Shopping"] = false
function aObj:AUCTION_HOUSE_SHOW()
	self:Debug("AUCTION_HOUSE_SHOW")

	-- trigger these when AH loads otherwise errors occur
	self:checkAndRunAddOn("Auctionator")

	-- handle TradeSkillMaster_Auctioning frame size changes
	if IsAddOnLoaded("TradeSkillMaster_Auctioning")
	or IsAddOnLoaded("TradeSkillMaster_AuctionDB")
	or IsAddOnLoaded("TradeSkillMaster_Shopping")
	then
		self:checkAndRun("TSM_AuctionFrameHook", "s") -- not an addon in its own right
		self:checkAndRun("TSM_AuctionHouse", "s") -- not an addon in its own right
	end

	self:UnregisterEvent("AUCTION_HOUSE_SHOW")

end

function aObj:PLAYER_ENTERING_WORLD()
	-- self:Debug("PLAYER_ENTERING_WORLD")

	-- use this to handle textures supplied by other addons (e.g. XPerl)
	self:updateSBTexture()

	self:UnregisterEvent("PLAYER_ENTERING_WORLD")

end

aObj.otherAddons["TradeSkillMaster_Crafting"] = false
aObj.otherAddons["ReagentMaker"] = false
aObj.otherAddons["ProfessionTabs_TSF"] = false
aObj.otherAddons["TradeSkillDW"] = false
function aObj:TRADE_SKILL_SHOW()
	-- self:Debug("TRADE_SKILL_SHOW")

	self:checkAndRunAddOn("TradeSkillMaster_Crafting")
	self:checkAndRunAddOn("ReagentMaker")
	self:checkAndRunAddOn("ProfessionTabs_TSF")
	self:checkAndRunAddOn("TradeSkillDW")

	self:UnregisterEvent("TRADE_SKILL_SHOW")

end

aObj.otherAddons["ProfessionTabs_TF"] = false
function aObj:TRADE_SHOW()
	-- self:Debug("TRADE_SHOW")

	self:checkAndRunAddOn("ProfessionTabs_TF")

	self:UnregisterEvent("TRADE_SHOW")

end
