local aName, aObj = ...
local _G = _G

-- Add locals to see if it speeds things up
local IsAddOnLoaded, pairs, C_Timer = _G.IsAddOnLoaded, _G.pairs, _G.C_Timer

function aObj:BlizzardFrames()
	-- self:Debug("BlizzardFrames")

	-- skin Blizzard frames
	for type, fTab in pairs(self.blizzFrames) do
		if type ~= "opt" then -- ignore options functions
			for func, _ in pairs(fTab) do
				self:checkAndRun(func, type)
			end
		end
	end

end

local addonSkins = {
	"_NPCScan",
	"Accountant", "Acheron", "ACP", "AdiBags", "AdvancedInterfaceOptions", "AngryKeystones", "AphesLootBrowser", "Archy", "Atlas", "AtlasLoot", "Auctionator", "AuctionMaster", "Auctionsnatch", "AutoDecline",
	"Baggins", "BankItems", "Bartender4", "BattlePetCount", "BaudManifest", "BetterInbox", "BGDefender", "BindPad", "BlackList", "BossInfo", "BossNotes", "BossNotes_PersonalNotes", "Bugger", "BulkMail2", "BulkMail2Inbox", "BuyEmAll",
	"CensusPlus", "CFM", "Chatter", "Clique", "CollectMe", "Combuctor", "CombustionHelper", "CompactMissions", "CoolLine", "Cosplay",
	"DeathNote", "DejaCharacterStats", "Details", "DockingStation", "Dominos", "DressUp",
	"EnergyWatch", "EnhancedColourPicker", "EnhancedFlightMap", "epgp_lootmaster", "epgp_lootmaster_ml", "epgp", "Examiner", "ExtVendor",
	"FarmIt2", "FeedMachine", "FishingBuddy", "Fizzle", "FlaresThatWork", "FlightMapEnhanced", "FlyoutButtonCustom", "Fortress", "FramesResized", "FreierGeist_InstanceTime",
	"G15Buttons", "Glamour", "GnomeWorks", "GnomishVendorShrinker", "GroupCalendar5", "Growler", "GuildLaunchCT_RaidTracker", "GuildMaster",
	"HandyNotes", "HaveWeMet", "HoloFriends",
	"InboxMailBag", "ItemDB", "InspectorGadgetzan", "Inventorian",
	"KeystoneCommander",
	"LegacyQuest", "Livestock", "ls_Prospector", "ls_Toasts", "LUI",
	"MacroToolkit", "Mapster", "MapsterEnhanced", "MarkingBar", "Megaphone", "MinimalArchaeology", "MinimapButtonFrame", "MobileVault", "MogIt", "MoveAnything", "MrTrader_SkillWindow", "MyGarrisons",
	"Notes",
	"oGlow", "oQueue", "oRA3", "Omen", "OneBag3", "OneBank3", "Overachiever",
	"PetBattleHUD", "PetBattleMaster", "PetTracker", "PetTracker_Switcher", "PetTracker_Journal", "PhoenixStyle", "Possessions", "Postal", "PowerAuras", "PowerAurasButtons", "PreformAVEnabler", "PremadeGroupsFilter", "ProfessionsVault", "ProspectBar",
	"Quartz", "QuestCompletist", "QuestGuru", "QuestGuru_Tracker", "QuestHelper2", "QuestHistory", "QuestMapWithDetails", "QuickMark",
	"RaidAchievement", "RaidRoll", "RaidRoll_LootTracker", "RAQ", "ReagentRestocker", "REFlex", "Rematch",
	"ScrollMaster", "SilverDragon", "Skada", "Smoker", "SnapShot", "SorhaQuestLog", "Squeenix", "StaggerMeter",
	"TargetCharms", "TidyPlates", "TipTac", "TooManyAddons", "TradeSkillMaster", "TrinketBar", "Tukui",
	"UrbanAchiever",
	"Vendomatic", "VuhDo", "VuhDoOptions",
	"Warden", "WeakAuras", "WoWPro", "WTFLatencyMeter",
	"XLoot", "xMerchant", "XPerl", "XPerl_RaidAdmin", "XPerl_RaidHelper",
}
aObj.addonsToSkin = {}
for i = 1, #addonSkins do
--@alpha@
	if aObj.addonsToSkin[addonSkins[i]] then
		aObj:CustomPrint(1, 0, 0, "Duplicate entry in addonSkins table (AddonFrames)", addonSkins[i])
	else
--@end-alpha@
		aObj.addonsToSkin[addonSkins[i]] = addonSkins[i]
--@alpha@
	end
--@end-alpha@
end
addonSkins = nil
-- oddly named addons
aObj.addonsToSkin["Classic Quest Log"] = "ClassicQuestLog"
aObj.addonsToSkin["DBM-Core"] = "DBMCore"
aObj.addonsToSkin["Enchantrix-Barker"] = "EnchantrixBarker"
aObj.addonsToSkin["Prat-3.0"] = "Prat30"
-- libraries
aObj.libsToSkin = {
	["NoTaint_UIDropDownMenu-7.2.0"] = "Lib_UIDropdown",
	["LibKeyBound-1.0"] = "LibKeyBound",
	["LibTradeLinks-1.0"] = "LibTradeSkillScan",
	["LibTradeSkillScan"] = "LibTradeSkillScan",
	["tektip-1.0"] = "tektip",
	["X-UI"] = "LibXUI",
}
-- store other AddOns not previously referenced, here so they can be enabled/disabled on the options panel
otherAddons = {
	"PetBattleTeams",
	"ProfessionTabs_TF",
	"ProfessionTabs_TSF",
	"ReagentMaker",
	"TradeSkillDW",
	"TradeSkillMaster_AuctionDB",
	"TradeSkillMaster_Auctioning",
	"TradeSkillMaster_Crafting",
	"TradeSkillMaster_Shopping",
	"TSM_AuctionFrameHook",
	"TSM_AuctionHouse",
}
aObj.otherAddons = {}
for i = 1, #otherAddons do
	aObj.otherAddons[otherAddons[i]] = otherAddons[i]
end
otherAddons = nil
local function skinLibs()

	-- skin library objects
	for libName, skinFunc in pairs(aObj.libsToSkin) do
		-- aObj:Debug("skinLibs: [%s, %s, %s]", libName, skinFunc, _G.LibStub(libName, true))
		if _G.LibStub(libName, true) then
			if aObj[skinFunc] then
				aObj:checkAndRun(skinFunc, "s")
			elseif _G.type(skinFunc) == "function" then
				aObj:checkAndRun(libName, "l")
			else
				if aObj.db.profile.Warnings then
					aObj:CustomPrint(1, 0, 0, libName, "loaded but skin not found in AddonSkins directory (sL)")
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

	-- used for Addons that aren't LoadOnDemand
	for addonName, skinFunc in pairs(self.addonsToSkin) do
		self:checkAndRunAddOn(addonName, nil, skinFunc)
	end
	self.addonsToSkin = nil

	-- skin tekKonfig framework objects
	if self.otherAddons["tekKonfig"] then self:checkAndRun("tekKonfig", "o") end

	-- skin any Blizzard LoD frames or LoD addons that have already been loaded by other addons, waiting to allow them to be loaded
	-- (Tukui does this for the PetJournal, other addons do it as well)
	C_Timer.After(0.2, function()
		skinBLoD()
		for name, skinFunc in pairs(self.lodAddons) do
			if IsAddOnLoaded(name) then self:checkAndRunAddOn(name, true, skinFunc) end
		end
	end)

	-- skin library objects after a short delay to allow them to be loaded
	C_Timer.After(0.2, function() skinLibs() end)

end

local lodFrames = {
	"AzCastBarOptions",
	"DockingStation_Config", "DoTimer_Options",
	"Enchantrix",
	"GarrisonMissionManager", "GuildBankSearch",
	"LilSparkysWorkshop", "Ludwig_Window",
	"MasterPlan",
	"Overachiever_Tabs",
	"PetJournalEnhanced",
	"Scrap_Merchant", "Scrap_Options", "Scrap_Visualizer",
	"TipTacOptions",
	"WeakAurasOptions",
	"XPerl_Options",
}
aObj.lodAddons = {}
for i = 1, #lodFrames do
	aObj.lodAddons[lodFrames[i]] = lodFrames[i]
end
lodFrames = nil
-- RaidAchievement modules
local raMods = {"Icecrown", "Naxxramas", "Ulduar", "WotlkHeroics", "CataHeroics", "CataRaids", "PandaHeroics", "PandaRaids", "PandaScenarios"}
for i = 1, #raMods do
	aObj.lodAddons["RaidAchievement_" .. raMods[i]] = "RaidAchievement_" .. raMods[i]
end
raMods = nil
-- oddly named LoD addons
aObj.lodAddons["DBM-GUI"] = "DBMGUI"

-- local prev_addon
function aObj:LoDFrames(addon)
	-- self:Debug("LoDFrames: [%s, %s]", addon, self.lodAddons[addon])

	-- -- ignore multiple occurrences of the same addon
	-- if addon == prev_addon then return end
	-- prev_addon = addon

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
	C_Timer.After(0.2, function() skinLibs() end)

end

-- Event processing here
function aObj:ADDON_LOADED(event, addon)
	-- self:Debug("ADDON_LOADED: [%s]", addon)

	aObj:LoDFrames(addon)

end

function aObj:AUCTION_HOUSE_SHOW()
	-- self:Debug("AUCTION_HOUSE_SHOW")

	-- trigger these when AH loads otherwise errors occur
	self:checkAndRunAddOn("Auctionator")

	-- handle TradeSkillMaster_Auctioning frame size changes
	if IsAddOnLoaded("TradeSkillMaster_Auctioning")
	or IsAddOnLoaded("TradeSkillMaster_AuctionDB")
	or IsAddOnLoaded("TradeSkillMaster_Shopping")
	then
		self:checkAndRun("TSM_AuctionFrameHook", "s")
		self:checkAndRun("TSM_AuctionHouse", "s")
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

	self:checkAndRunAddOn("TradeSkillMaster_Crafting")
	self:checkAndRunAddOn("ReagentMaker")
	self:checkAndRunAddOn("ProfessionTabs_TSF")
	self:checkAndRunAddOn("TradeSkillDW")

	self:UnregisterEvent("TRADE_SKILL_SHOW")

end

function aObj:TRADE_SHOW()
	-- self:Debug("TRADE_SHOW")

	self:checkAndRunAddOn("ProfessionTabs_TF")

	self:UnregisterEvent("TRADE_SHOW")

end
