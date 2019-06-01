local aName, aObj = ...

local _G = _G

-- Add locals to see if it speeds things up
local IsAddOnLoaded, pairs = _G.IsAddOnLoaded, _G.pairs

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
	"Accountant", "Acheron", "ACP", "AdvancedInterfaceOptions", "AngryKeystones", "Archy", "Atlas", "AtlasLoot", "Auctionsnatch", "AutoDecline",
	"BankItems", "BaudManifest", "BetterInbox", "BGDefender", "BindPad", "BlackList", "BossInfo", "BossNotes", "BossNotes_PersonalNotes", "Bugger", "BulkMail2", "BulkMail2Inbox", "BuyEmAll",
	"CensusPlus", "CFM", "Chatter", "Clique", "CollectMe", "Combuctor", "CombustionHelper", "CompactMissions", "Cosplay",
	"DeathNote", "DejaCharacterStats", "Dominos", "DressUp",
	"EnergyWatch", "EnhancedFlightMap", "epgp_lootmaster", "epgp_lootmaster_ml", "epgp", "Examiner", "ExtVendor",
	"FarmIt2", "FeedMachine", "FlaresThatWork", "FlightMapEnhanced", "FramesResized", "FreierGeist_InstanceTime",
	"G15Buttons", "Glamour", "GnomishVendorShrinker", "GroupCalendar5", "Growler", "GuildLaunchCT_RaidTracker",
	"HaveWeMet", "HoloFriends",
	"InboxMailBag", "ItemDB", "InspectorGadgetzan", "Inventorian",
	"KeystoneCommander",
	"LegacyQuest", "Livestock", "ls_Prospector", "ls_Toasts",
	"MacroToolkit", "Mapster", "MapsterEnhanced", "MarkingBar", "Megaphone", "MobileVault", "MogIt", "MoveAnything", "MyGarrisons",
	"Notes",
	"oRA3", "Omen", "OneBag3", "OneBank3",
	"PetBattleMaster", "Possessions", "PowerAuras", "PowerAurasButtons", "PreformAVEnabler", "ProfessionsVault", "ProspectBar",
	"Quartz", "QuestCompletist", "QuestGuru_Tracker", "QuestHelper2", "QuestHistory", "QuestMapWithDetails", "QuickMark",
	"RaidRoll", "RaidRoll_LootTracker", "RAQ", "ReagentRestocker", "REFlex", "Rematch",
	"ScrollMaster", "SilverDragon", "Skada", "Smoker", "SnapShot", "SorhaQuestLog", "Squeenix", "StaggerMeter",
	"TargetCharms", "TooManyAddons",
	"UrbanAchiever",
	"Vendomatic", "VuhDo", "VuhDoOptions",
	"Warden", "WoWPro", "WTFLatencyMeter",
	"XLoot", "xMerchant",
}
aObj.addonsToSkin = {}
for i = 1, #addonSkins do
	aObj.addonsToSkin[addonSkins[i]] = addonSkins[i]
end
addonSkins = nil
-- oddly named addons
aObj.addonsToSkin["Classic Quest Log"] = "ClassicQuestLog"
aObj.addonsToSkin["Enchantrix-Barker"] = "EnchantrixBarker"
aObj.addonsToSkin["Prat-3.0"] = "Prat30"
-- libraries
aObj.libsToSkin = {
	["LibTradeLinks-1.0"] = "LibTradeSkillScan",
	["LibTradeSkillScan"] = "LibTradeSkillScan",
	["tektip-1.0"] = "tektip",
	["X-UI"] = "LibXUI",
}
-- store other AddOns not previously referenced, here so they can be enabled/disabled on the options panel
local otherAddons = {
	"ProfessionTabs_TF",
	"ProfessionTabs_TSF",
	"ReagentMaker",
	"TradeSkillDW",
}
aObj.otherAddons = {}
for i = 1, #otherAddons do
	aObj.otherAddons[otherAddons[i]] = otherAddons[i]
end
otherAddons = nil
local function skinLibs()

	-- skin library objects
	for libName, skinFunc in pairs(aObj.libsToSkin) do
		if _G.LibStub(libName, true) then
			if _G.type(skinFunc) == "function" then
				aObj:checkAndRun(libName, "l")
			elseif aObj[skinFunc] then
				aObj:checkAndRun(skinFunc, "s")
			else
				if aObj.prdb.Warnings then
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

	-- skin DropDownMenu framework objects (used by RCLootCouncil)
	if self.otherAddons["DropDownMenu"] then self:checkAndRun("DropDownMenu", "o") end

	-- skin any Blizzard LoD frames or LoD addons that have already been loaded by other addons, waiting to allow them to be loaded
	-- (Tukui does this for the PetJournal, other addons do it as well)
	_G.C_Timer.After(0.2, function()
		skinBLoD()
		for name, skinFunc in pairs(self.lodAddons) do
			if IsAddOnLoaded(name) then self:checkAndRunAddOn(name, true, skinFunc) end
		end
	end)

	-- skin library objects
	skinLibs()

end

local lodFrames = {
	"DoTimer_Options",
	"Enchantrix",
	"GarrisonMissionManager", "GuildBankSearch",
	"LilSparkysWorkshop", "Ludwig_Window",
	"PetJournalEnhanced",
	"Scrap_Merchant", "Scrap_Options", "Scrap_Visualizer",
}
aObj.lodAddons = {}
for i = 1, #lodFrames do
	aObj.lodAddons[lodFrames[i]] = lodFrames[i]
end
lodFrames = nil

function aObj:LoDFrames(addon)
	-- self:Debug("LoDFrames: [%s, %s]", addon, self.lodAddons[addon])

	-- check to see if it's a Blizzard LoD Frame
	skinBLoD(addon)

	-- used for User LoadOnDemand Addons
	if self.lodAddons[addon] then self:checkAndRunAddOn(addon, true, self.lodAddons[addon]) end

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
	-- e.g. ArkDewdrop by ArkInventory when an AddonLoader is used
	skinLibs()

end

-- Event processing here
function aObj:ADDON_LOADED(event, addon)
	-- self:Debug("ADDON_LOADED: [%s]", addon)

	aObj:LoDFrames(addon)

end

function aObj:AUCTION_HOUSE_SHOW()
	-- self:Debug("AUCTION_HOUSE_SHOW")

	self.callbacks:Fire("Auction_House_Show")

	self:UnregisterEvent("AUCTION_HOUSE_SHOW")

end

function aObj:PLAYER_ENTERING_WORLD()
	-- self:Debug("PLAYER_ENTERING_WORLD")

	-- delay issuing callback to allow for code to be loaded
	_G.C_Timer.After(0.5, function()
		self.callbacks:Fire("Player_Entering_World")
	end)

end

function aObj:TRADE_SKILL_SHOW()
	-- self:Debug("TRADE_SKILL_SHOW")

	self:checkAndRunAddOn("ReagentMaker")
	self:checkAndRunAddOn("ProfessionTabs_TSF")
	self:checkAndRunAddOn("TradeSkillDW")

	if _G.Auctionator_Search then
		self:skinStdButton{obj=_G.Auctionator_Search}
	end

	self:UnregisterEvent("TRADE_SKILL_SHOW")

end

function aObj:TRADE_SHOW()
	-- self:Debug("TRADE_SHOW")

	self:checkAndRun("ProfessionTabs_TF", "o")

	self:UnregisterEvent("TRADE_SHOW")

end

function aObj:PLAYER_LEVEL_UP(...)
--[[
	arg1 - event name
	arg2 - new player level
	arg3 - hit points gained from levelling
	arg4 - mana points gained from levelling
	arg5 - Talent points gained from levelling
	arg6-arg10 - attribute score increases from levelling:
		Strength (6)
		Agility (7)
		Stamina (8)
		Intellect (9)
		Spirit (10)

	Expansion Level number: (Level cap)
		0 : Classic (60)
		1 : Burning Crusade (70)
		2 : Wrath of the Lich King (80)
		3 : Cataclysm (85)
		4 : Mists of Pandaria (90)
		5 : Warlords of Draenor (100)
		6 : Legion (110)
		7 : Battle for Azeroth (120)
--]]

	local newPlayerLevel = _G.select(2, ...)

	if newPlayerLevel < _G.MAX_PLAYER_LEVEL then return end

	-- max XP level reached, adjust watchbar positions
	for _, bar in pairs{_G.ReputationWatchBar, _G.ArtifactWatchBar, _G.HonorWatchBar} do
		bar.SetPoint = bar.OrigSetPoint
		aObj:moveObject{obj=bar, y=2}
		bar.SetPoint = _G.nop
	end

end
