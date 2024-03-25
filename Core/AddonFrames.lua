local _, aObj = ...

local _G = _G
-- luacheck: ignore 631 (line is too long)

--@debug@
local index = {}
local mt = {
	__index = function (t, k)
		-- print("*access to element " .. tostring(k))
		return t[index][k] -- access the original table
	end,
	__newindex = function (t, k, v)
		-- print("*update of element " .. tostring(k) .. " to " .. tostring(v))
		if _G.rawget(t[index], k) then
			aObj:CustomPrint(1, 0, 0, k, "already exists in the table, please remove the static entry in AddonFrames code")
		end
		t[index][k] = v -- update original table
	end
}
local function track (t)
	local proxy = {}
	proxy[index] = t
	_G.setmetatable(proxy, mt)
	return proxy
end
local function untrack (t)
	return t[index]
end
--@end-debug@

local addonSkins = {
	"BindPad", "BossNotes", "BossNotes_PersonalNotes", "BuyEmAll",
	"CensusPlus", "Chatter",
	"Examiner",
	"FlaresThatWork", "FramesResized",
	"Livestock", "ls_Toasts",
	"MogIt",
	"Notes",
	"OneBag3", "OneBank3",
	"Quartz", "QuickMark",
	"SorhaQuestLog",
	"TooManyAddons",
	"Vendomatic",
	"XLoot", "xMerchant",
}
aObj.addonsToSkin = {}
for i = 1, #addonSkins do
	if aObj:isAddonEnabled(addonSkins[i]) then
		aObj.addonsToSkin[addonSkins[i]] = addonSkins[i]
	end
end
aObj.libsToSkin = {}
aObj.otherAddons = {}
local lodFrames = {
	"GarrisonMissionManager",
	"GuildBankSearch",
}
aObj.lodAddons = {}
for i = 1, #lodFrames do
	if aObj:isAddonEnabled(lodFrames[i]) then
		aObj.lodAddons[lodFrames[i]] = lodFrames[i]
	end
end

--@debug@
aObj.addonsToSkin = track(aObj.addonsToSkin)
aObj.libsToSkin   = track(aObj.libsToSkin)
aObj.otherAddons  = track(aObj.otherAddons)
aObj.lodAddons    = track(aObj.lodAddons)
aObj.RegisterCallback("AddonFrames", "AddOn_OnInitialize", function()
	aObj.addonsToSkin = untrack(aObj.addonsToSkin)
	aObj.libsToSkin   = untrack(aObj.libsToSkin)
	aObj.otherAddons  = untrack(aObj.otherAddons)
	aObj.lodAddons    = untrack(aObj.lodAddons)
	aObj.UnregisterCallback("AddonFrames", "AddOn_OnInitialize")
end)
--@end-debug@

local function skinLibs()
	for libName, skinFunc in _G.pairs(aObj.libsToSkin) do
		if _G.LibStub:GetLibrary(libName, true) then
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
	for fType, fTab in _G.pairs(aObj.blizzLoDFrames) do
		for fName, _ in _G.pairs(fTab) do
			if addon
			and addon == "Blizzard_" .. fName
			or aObj:isAddOnLoaded("Blizzard_" .. fName)
			then
				aObj:checkAndRun(fName, fType, true)
			end
		end
	end
end
function aObj:AddonFrames()

	-- used for Addons that aren't LoadOnDemand
	for addonName, skinFunc in _G.pairs(self.addonsToSkin) do
		self:checkAndRunAddOn(addonName, skinFunc)
	end

	-- skin any Blizzard LoD frames or LoD addons that have already been loaded by other addons, waiting to allow them to be loaded
	-- (Tukui does this for the PetJournal, other addons do it as well)
	_G.C_Timer.After(0.2, function()
		skinBLoD()
		for name, skinFunc in _G.pairs(self.lodAddons) do
			if self:isAddOnLoaded(name) then
				self:checkAndRunAddOn(name, skinFunc, true)
			end
		end
	end)

	-- skin library objects
	skinLibs()

end

function aObj:BlizzardFrames()

	-- skin Blizzard frames
	for type, fTab in _G.pairs(self.blizzFrames) do
		for func, _ in _G.pairs(fTab) do
			self:checkAndRun(func, type)
		end
	end

end

function aObj:LoDFrames(addon)
	-- self:Debug("LoDFrames: [%s, %s]", addon, self.lodAddons[addon])

	-- check to see if it's a Blizzard LoD Frame
	skinBLoD(addon)

	-- used for User LoadOnDemand Addons
	if self.lodAddons[addon] then
		self:checkAndRunAddOn(addon, self.lodAddons[addon], true)
	end

	-- deal with Addons under the control of an LoadManager
	-- use lowercase addonname (lazyafk issue)
	if self.lmAddons[addon:lower()] then
		self:checkAndRunAddOn(addon, self.lmAddons[addon:lower()], true)
		self.lmAddons[addon:lower()] = nil
	end

	-- handle FramesResized changes
	if self:isAddOnLoaded("FramesResized") then
		if addon == "Blizzard_TradeSkillUI"
		and self.FR_TradeSkillUI then
			self:checkAndRun("FR_TradeSkillUI", "s") -- not an addon in its own right
		elseif addon == "Blizzard_TrainerUI"
		and self.FR_TrainerUI then
			self:checkAndRun("FR_TrainerUI", "s") -- not an addon in its own right
		end
	end

	-- load library skins here as well, they may only get loaded by a LoD AddOn
	-- e.g. ArkDewdrop by ArkInventory when an AddonLoader is used
	skinLibs()

end

-- Event processing here
function aObj:ADDON_LOADED(_, addon)
	-- self:Debug("ADDON_LOADED: [%s]", addon)

	self:LoDFrames(addon)

	self.callbacks:Fire("AddOn_Loaded", addon)
	-- remove all callbacks for this event
	self.callbacks.events["AddOn_Loaded"] = nil

end

function aObj:AUCTION_HOUSE_SHOW()
	-- self:Debug("AUCTION_HOUSE_SHOW")

	self.callbacks:Fire("Auction_House_Show")
	-- remove all callbacks for this event
	self.callbacks.events["Auction_House_Show"] = nil

	self:UnregisterEvent("AUCTION_HOUSE_SHOW")

end

function aObj:PLAYER_ENTERING_WORLD()
	-- self:Debug("PLAYER_ENTERING_WORLD")

	-- delay issuing callback to allow for code to be loaded
	_G.C_Timer.After(0.5, function()
		self.callbacks:Fire("Player_Entering_World")
		-- remove all callbacks for this event
		self.callbacks.events["Player_Entering_World"] = nil
	end)

	self:UnregisterEvent("PLAYER_ENTERING_WORLD")

end

function aObj:PLAYER_LEVEL_CHANGED(...) -- luacheck: ignore 212 (unused argument)
--[[
	arg1 - event name
	arg2 - old player level
	arg3 - new player level
	...

	Expansion Level number: (Level cap)
		0 : Classic (60)
		1 : Burning Crusade (70)
		2 : Wrath of the Lich King (80)
		3 : Cataclysm (85)
		4 : Mists of Pandaria (90)
		5 : Warlords of Draenor (100)
		6 : Legion (110)
		7 : Battle for Azeroth (120)
		8 : Shadowlands (60), start @ 50
		9 : Dragonflight (70)
--]]

	local newPLevel = _G.select(3, ...)

	-- if new level < old level then just started shadowlands expansion

	if newPLevel < _G.MAX_PLAYER_LEVEL then return end

	-- max XP level reached, adjust watchbar positions
	for _, bar in _G.pairs{_G.ReputationWatchBar, _G.ArtifactWatchBar, _G.HonorWatchBar} do
		bar.SetPoint = bar.OrigSetPoint
		aObj:moveObject{obj=bar, y=2}
		bar.SetPoint = _G.nop
	end

end
