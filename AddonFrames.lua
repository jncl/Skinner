
function Skinner:BlizzardFrames()
--	self:Debug("BlizzardFrames")

	-- only need to do this once
	if self.initialized.BlizzardFrames then return end
	self.initialized.BlizzardFrames = true

	local blizzFrames = {
		"CharacterFrames", "PetStableFrame", "SpellBookFrame", "DressUpFrame",
		"FriendsFrame", "TradeFrame", "ResizeQW", "ReadyCheck", "Buffs", "AchievementWatch",
		"MerchantFrames", "GossipFrame", "TaxiFrame", "QuestFrame", "Battlefields", "ArenaFrame", "ArenaRegistrar", "GuildRegistrar", "Petition", "Tabard",
		"MirrorTimers", "QuestTimers", "StaticPopups", "ChatMenus", "ChatTabs", "ChatFrames", "ChatEditBox", "LootFrame", "GroupLoot", "ContainerFrames", "StackSplit", "ItemText", "ColorPicker", "WorldMap", "HelpFrame", "BattleScore", "ScriptErrors", "Tutorial", "DropDowns",
		"MenuFrames", "BankFrame", "MailFrame", "CoinPickup", "LFGFrame", "PVPFrame"
	}
	
	if Skinner.isPTR then table.insert(blizzFrames, "FeedbackUI") end

	for _, v in pairs(blizzFrames) do
		self:checkAndRun(v)
	end

	-- handle non standard ones here
	self:ScheduleEvent(self.checkAndRun, 1, self, "MinimapButtons") -- wait for a second before skinning the minimap buttons
	self:checkAndRun("ChatConfig") -- done here even though it's LoD, as it is always loaded with Blizzard_CombatLog

	if IsMacClient() then self:checkAndRun("MovieProgress") end

--[[
	QuestLog -- checked with EQL3 below
	CastingBar -- checked with Quartz below
	Tooltips -- checked with TipTac below
	InspectUI -- checked with Voyeur below
	ModelFrames -- checked with CloseUp below
	MainMenuBar -- checked with Bongos below
	Nameplates -- checked with Aloft below
]]

end

function Skinner:SkinnerFrames()
--	self:Debug("SkinnerFrames")

	-- only need to do this once
	if self.initialized.SkinnerFrames then return end
	self.initialized.SkinnerFrames = true

	local skinnerFrames = {
			"ViewPort", "TopFrame", "MiddleFrames", "BottomFrame"
	}

	for _, v in pairs(skinnerFrames) do
		self:checkAndRun(v)
	end

end

local blizzLoDFrames = {
	 "AuctionUI", "BattlefieldMinimap", "BindingUI", "GMSurveyUI", "GuildBankUI", "InspectUI", "ItemSocketingUI", "MacroUI", "RaidUI", "TalentUI", "TimeManager", "TradeSkillUI", "TrainerUI", "AchievementUI", "BarbershopUI", "Calendar", "GlyphUI"
}
local blizzLoD = {}
for _, v in pairs(blizzLoDFrames) do
	blizzLoD["Blizzard_"..v] = v
end

function Skinner:AddonFrames()
--	self:Debug("AddonFrames")

	-- only need to do this once
	if self.initialized.AddonFrames then return end
	self.initialized.AddonFrames = true

	-- this addon colour the Tooltip Border
	if IsAddOnLoaded("Chippu") then self.ttBorder = false end

	-- Skin the QuestLog if EQL3 or QuestGuru aren't loaded
	-- N.B. Do it here as other Addons use the QuestLog size
	 if not IsAddOnLoaded("EQL3") and not IsAddOnLoaded("QuestGuru") then self:checkAndRun("QuestLog") end

	-- Skin the CastingBar if Quartz isn't loaded
	if not IsAddOnLoaded("Quartz") then self:checkAndRun("CastingBar") end

	-- Skin the Tooltips if TipTac isn't loaded
	if not IsAddOnLoaded("TipTac") then self:checkAndRun("Tooltips") end

	-- Skin the MenuBar if Bongos isn't loaded
	if not IsAddOnLoaded("Bongos") and not IsAddOnLoaded("Bongos2") then self:checkAndRun("MainMenuBar") end

	-- Skin the Nameplates if Aloft or nerNameplates aren't loaded
	if not IsAddOnLoaded("Aloft") and not IsAddOnLoaded("nerNameplates") then self:checkAndRun("Nameplates") end

	local addonFrames = {
		"Accountant", "AceProfit", "AckisRecipeList", "ACP", "AdvancedTradeSkillWindow", "aftt_extreme", "AlphaMap", "Altoholic", "Analyst", "AoTRDungeonQuester", "ArkInventory", "Armory", "Ash_Cooldowns", "Ash_Core", "Ash_DoTimer", "Assessment", "Atlas", "AtlasLoot", "AtlasQuest", "AuldLangSyne", "AuldLangSyne_Note", "AutoDecline", "AutoProfit", "AutoProfitX", "AxuItemMenus",
		"Badapples", "Baggins", "Baggins_Search", "Bagnon", "Bagnon_Forever", "BankAccountant", "BankItems", "BattleChat", "BattleCry", "BaudBag", "BaudManifest", "BaudMenu", "BeanCounter", "BeastTraining", "beql", "BetterInbox", "BigBankStatement", "BigGuild", "BigTrouble", "Bongos_AB", "Bonuses", "Buffalo", "Buffalo2", "BuffQ", "BugSack", "Butsu", "BuyEmAll", "BuyPoisons",
		"Capping", "Cartographer", "Cartographer_QuestInfo", "Cartographer3", "CBRipoff", "CEnemyCastBar", "CharactersViewer", "Chatr", "Chatter", "Chinchilla", "Clique", "Cork", "Combuctor", "ConcessionStand", "Converse", "CowTip", "CT_MailMod", "CT_RaidAssist", "CT_RaidTracker",
		"DamageMeters", "DBM_RaidTools", "DebuffFilter", "Demon", "DemonTrainerFrame", "DepositBox", "DiamondThreatMeter", "DopieArenaInfo", "DoubleWide", "DoubleWideTradeSkills", "DuckieBank",
		"Earth", "EasyTrack", "EasyUnlock", "EavesDrop", "EditingUI", "EnchantMe", "EngBags", "EnhancedFlightMap", "EnhancedStackSplit", "EnhancedTradeSkills", "Epeen", "epgp", "EQL3", "EquipCompare", "EveryQuest", "Examiner",
		"FactionGrinder", "Factionizer", "FBagOfHolding", "FeedMachine", "FishingBuddy", "FlightMap", "ForteWarlock", "FramesResized", "FreierGeist_InstanceTime", "FruityLoots", "FuBar_PoisonReminderFu",
		"GCInfo", "GemHelper", "GemMe", "GFW_FeedOMatic", "GlowFoSho", "Gossipmonger", "GotWood", "Grid", "GrimReaper", "GroupCalendar", "Guild_Alliance", "Guild_Log", "GuildAds", "GuildBankAccount", "GuildEventManager2",
		"Hadar_FocusFrame", "HandyNotes", "HatTrick", "HealBot", "HealersAssist", "HealingEstimator", "HealOrganizer", "Historian", "HitsMode", "HoloFriends",
		"IgorsMassAuction", "ItemDB", "ItemEnchantApplication", "ItemRack", "ItemSync", "InstanceMaps", "InsultDevice", "InventoryOnPar",
		"JasonQuest", "Junk",
		"Karma", "KC_Items", "KLHThreatMeter", "KombatStats",
		"LightHeaded", "LinkHeaven", "Links", "LinksList", "LinkWrangler", "LoadIT", "LootHog", "LootLink", "LootScroll", "Ludwig", "Luggage",
		"MacroBank", "MageEatDrinkAid", "MailTo", "MakeRocketGoNow", "MCP", "MetaMap", "MinimapButtonFrame", "Mirror", "MobileFrames", "MobileVault", "MobMap", "Moleskine", "MonkeyQuest", "MonkeyQuestLog", "MTLove", "MultiTips", "MusicPlayer", "MyBags", "myClock", "myMusic",
		"NeonChat", "Notebook", "NotesUNeed", "nQuestLog",
		"Omen", "Omnibus", "OneBag3", "oRA2", "Outfitter",
		"Palatank", "PallyPower", "Panda", "PartyQuests", "PassLoot", "Perl_CombatDisplay", "Perl_Focus", "Perl_Party", "Perl_Party_Pet", "Perl_Party_Target", "Perl_Player", "Perl_Player_Pet", "Perl_Target", "Perl_Target_Target", "Planner", "PlayerExpBar", "PoliteWhisper", "Possessions", "Postal", "Prat", "ProcMeter", "ProfessionsBook", "Proximo", "PVPCooldown", "PVPCooldownReborn", "PvpMessages",
		"Quartz", "QuestAgent", "QuestGuru", "QuestHistory", "QuestIon",
		"RABuffs", "ReadySpells", "ReagentHeaven", "Recap", "RecipeBook", "RecipeRadar", "Recount",
		"Sanity2", "SanityBags", "SellJunk", "ShieldLeft", "sienasGemViewer", "SimpleMouseoverTarget", "Skillet", "SmartBuff", "SmartDebuff", "SpamSentry", "Spew", "Spyglass", "Squeenix", "sRaidFrames", "StanceSets", "SuperMacro", "SW_Stats", "SW_UniLog", "SystemMessageControlTool",
		"Talented", "Tankadin", "TankPoints", "TargetAnnounce", "tekBlocks", "tekDebug", "tekErr", "tekKompare", "tekPad", "TinyTip", "TipBuddy", "TipTac", "TitanExitGame", "TomTom", "Toons", "TourGuide", "TradeJunkie", "Trinity2", "TrinityBars2", "TuringTest",
		"UberQuest", "UrbanAchiever",
		"VanasKoS", "vBagnon", "Vendor", "Violation", "Visor2GUI",
		"WebDKP", "WIM", "WoWEquip",
		"xcalc", "XLoot", "XLootGroup", "XLootMonitor", "XPerl", "XPerl_RaidAdmin", "XPerl_RaidHelper", "XPerl_GrimReaper", "XRS",
		"ZOMGBuffs"
	}

	-- used for Addons that aren't LoadOnDemand
	for _, v in pairs(addonFrames) do
		self:checkAndRunAddOn(v)
	end

	self:checkAndRunAddOn("NicheCombatConfig", true) -- done here even though it's LoD, as it is always loaded with Blizzard_CombatLog -- use true so it isn't treated as a LoadManaged Addon
	self:checkAndRunAddOn("SuperInspect_UI", true) -- use true so it isn't treated as a LoadManaged Addon

	-- handle Addons with odd names here
	local oddlyNamedAddons = {
		"Auc-Advanced", "Auc-Util-BigPicture", "Auto-Bag", "Enchantrix-Barker", "FB_OutfitDisplayFrame", "FB_TrackingFrame", "!ImprovedErrorFrame", "Ogri'Lazy"
	}
	for _, v in pairs(oddlyNamedAddons) do
		v2, _ = string.gsub(v, "[-_!']", "")
		self:checkAndRunAddOn(v, nil, v2)
	end

	-- this addon has a relation
	self:checkAndRunAddOn("EnhancedTradeSkills", nil, "EnhancedTradeCrafts")

	--	don't make Model Frames Rotatable if CloseUp is loaded
	if not IsAddOnLoaded("CloseUp") then self:checkAndRun("ModelFrames") end

	-- skin the Blizzard LoD frames if they have already been loaded by other addons
	for k, v in pairs(blizzLoD) do
		if IsAddOnLoaded(k) then self:checkAndRun(v) end
	end

	-- load MSBTOptions here if FuBar_MSBTFu is loaded
	if IsAddOnLoaded("FuBar_MSBTFu") then
		self:checkAndRunAddOn("MSBTOptions", true) -- use true so it isn't treated as a LoadManaged Addon
	end

	--	load Bongos support here if it is loaded
	if IsAddOnLoaded("Bongos") then self:checkAndRunAddOn("Bongos") end

	-- skin Dewdrop, Ace2, Tablet, Waterfall, OptionHouse, Ace3GUI & LibSimpleOptions frames
	local libsToSkin = {
		["Dewdrop-2.0"] = "Dewdrop",
		["AceAddon-2.0"] = "Ace2",
		["Tablet-2.0"] = "Tablet",
		["Waterfall-1.0"] = "Waterfall",
		["OptionHouse-1.1"] = "OptionHouse",
		["AceGUI-3.0"] = "Ace3",
		["LibSimpleOptions-1.0"] = "LibSimpleOptions",
	}
	for k, v in pairs(libsToSkin) do
		if LibStub(k, true) then
			if self[v] then self:checkAndRun(v)
			else
				if self.db.profile.Warnings then
					self:CustomPrint(1, 0, 0, nil, nil, nil, v, "loaded but skin not found in SkinMe directory")
				end
			end
		end
	end
	-- skin Rock Config
	if Rock and Rock:HasLibrary("LibRockConfig-1.0") then
--		self:Debug("LibRockConfig found")
		if self.RockConfig then self:checkAndRun("RockConfig")
		else
			if self.db.profile.Warnings then
				self:CustomPrint(1, 0, 0, nil, nil, nil, "RockConfig", "loaded but skin not found in SkinMe directory")
			end
		end
	end
	-- skin KeyBound Dialog frame
	if LibStub('LibKeyBound-1.0', true) then self:applySkin(KeyboundDialog) end
	-- skin LibTooltip a.k.a. LibQTip tooltips
	local lt = {"LibTooltip-1.0", "LibQTip-1.0"}
	for _, lib in pairs(lt) do
		if LibStub(lib, true) then
			local function skinLTTooltips()
				for key, tooltip in LibStub(lib):IterateTooltips() do
--					self:Debug("%s:[%s, %s]", lib, key, tooltip)
					if not tooltip.skinned then
						self:applySkin(tooltip)
						tooltip.skinned = true
					end
				end
			end
			-- hook this to handle new tooltips
			self:SecureHook(LibStub(lib), "Acquire", function(this, key, ...)
				skinLTTooltips()
			end)
			-- skin any existing ones
			skinLTTooltips()
		end
	end
	
end

local lodFrames = {
	"AutoBarConfig", "Bagnon", "Bagnon_Options", "Banknon", "BaudAuction", "Bongos", "Bongos_Options", "Cartographer_Notes", "CECB_Options", "cgCrafty", "CharacterInfo", "DBM_GUI", "Dominos_Config", "Enchantrix", "EnhTooltip", "FilterTradeSkill", "FramesResized_TalentUI", "GFW_HuntersHelperUI", "ItemRackOptions", "MSBTOptions", "Perl_Config_Options", "SpamSentry_report", "SpecialTalentUI", "SuperInspect_UI", "TradeTabs", "TipTacOptions", "WIM_Options", "XPerl_Options", "ZOMGBuffs_BlessingsManager"
}
local lodAddons = {}
for _, v in pairs(lodFrames) do
	lodAddons[v] = v
end
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

	-- handle addons linked to the InspectUI
	if arg1 == "Blizzard_InspectUI" then
		--	This addon creates a button on the Inspect Frame
		self:checkAndRunAddOn("WoWEquip", nil, "WoWEquip_CITB")
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
	-- handle TradeTabs changes for both Craft and TradeSkills
	if IsAddOnLoaded("TradeTabs") then
		if arg1 == "Blizzard_TradeSkillUI" then
			self:checkAndRunAddOn("TradeTabs")
		end
	end

end

function Skinner:ADDON_LOADED(arg1)
--	self:Debug("ADDON_LOADED: [%s]", arg1)

	self:ScheduleEvent(self.LoDFrames, self.db.profile.Delay.LoDs, self, arg1)

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

function Skinner:ViewPort()
	if not self.db.profile.ViewPort.shown or self.initialized.ViewPort then return end
	self.initialized.ViewPort = true

	local xOfs = self.db.profile.ViewPort.left * self.db.profile.ViewPort.XScaling
	local yOfs = self.db.profile.ViewPort.top * self.db.profile.ViewPort.YScaling
	local xOfs2 = self.db.profile.ViewPort.right * self.db.profile.ViewPort.XScaling
	local yOfs2 = self.db.profile.ViewPort.bottom * self.db.profile.ViewPort.YScaling
--	self:Debug("VP [%s, %s, %s, %s]", xOfs, yOfs, xOfs2, yOfs2)
	WorldFrame:SetPoint("TOPLEFT", xOfs, -yOfs)
	WorldFrame:SetPoint("BOTTOMRIGHT", -xOfs2, yOfs2)

	if self.db.profile.ViewPort.overlay then
		ViewportOverlay = WorldFrame:CreateTexture(nil, "BACKGROUND")
		ViewportOverlay:SetTexture(self.db.profile.ViewPort.r or 0, self.db.profile.ViewPort.g or 0, self.db.profile.ViewPort.b or 0, ba or self.db.profile.ViewPort.a or 1)
		ViewportOverlay:SetPoint("TOPLEFT", UIParent, "TOPLEFT", -1, 1)
		ViewportOverlay:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 1, -1)
	end

end

function Skinner:ViewPort_top()
	if not self.db.profile.ViewPort.shown then return end

	WorldFrame:SetPoint("TOPLEFT", (self.db.profile.ViewPort.left * self.db.profile.ViewPort.XScaling), -(self.db.profile.ViewPort.top * self.db.profile.ViewPort.YScaling))
	WorldFrame:SetPoint("TOPRIGHT", -(self.db.profile.ViewPort.right * self.db.profile.ViewPort.XScaling), -(self.db.profile.ViewPort.top * self.db.profile.ViewPort.YScaling))

end

function Skinner:ViewPort_bottom()
	if not self.db.profile.ViewPort.shown then return end

	WorldFrame:SetPoint("BOTTOMLEFT", (self.db.profile.ViewPort.left * self.db.profile.ViewPort.XScaling), (self.db.profile.ViewPort.bottom * self.db.profile.ViewPort.YScaling))
	WorldFrame:SetPoint("BOTTOMRIGHT", -(self.db.profile.ViewPort.right * self.db.profile.ViewPort.XScaling), (self.db.profile.ViewPort.bottom * self.db.profile.ViewPort.YScaling))

end

function Skinner:ViewPort_left()
	if not self.db.profile.ViewPort.shown then return end

	local xOfs = self.db.profile.ViewPort.left * self.db.profile.ViewPort.XScaling
	local yOfs = self.db.profile.ViewPort.top * self.db.profile.ViewPort.YScaling
	WorldFrame:SetPoint("TOPLEFT", xOfs, -yOfs)

end

function Skinner:ViewPort_right()
	if not self.db.profile.ViewPort.shown then return end

	local xOfs2 = self.db.profile.ViewPort.right * self.db.profile.ViewPort.XScaling
	local yOfs2 = self.db.profile.ViewPort.bottom * self.db.profile.ViewPort.YScaling
	WorldFrame:SetPoint("BOTTOMRIGHT", -xOfs2, yOfs2)

end

function Skinner:ViewPort_reset()

	self.initialized.ViewPort = nil
	WorldFrame:ClearAllPoints()
	WorldFrame:SetPoint("TOPLEFT", 0, -0)
	WorldFrame:SetPoint("BOTTOMRIGHT", -0, 0)

end

local ftype = "s"

function Skinner:TopFrame()
	if not self.db.profile.TopFrame.shown or self.initialized.TopFrame then return end
	self.initialized.TopFrame = true

	local fh = nil

	local frame = CreateFrame("Frame", "SkinnerTF", UIParent)
	frame:SetFrameStrata("BACKGROUND")
	frame:SetFrameLevel(0)
	frame:EnableMouse(false)
	frame:SetMovable(false)
	frame:SetWidth(self.db.profile.TopFrame.width or 1920)
	frame:SetHeight(self.db.profile.TopFrame.height or 100)
	frame:ClearAllPoints()
	if self.db.profile.TopFrame.xyOff or self.db.profile.TopFrame.borderOff then
		frame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", -6, 6)
	else
		frame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", -3, 3)
	end
	local fb = self.db.profile.TopFrame.borderOff and 0 or 1
	-- set the fade height
	if self.db.profile.FadeHeight.enable and self.db.profile.FadeHeight.force then
		-- set the Fade Height to the global value if 'forced'
		-- making sure that it isn't greater than the frame height
		fh = self.db.profile.FadeHeight.value <= math.ceil(frame:GetHeight()) and self.db.profile.FadeHeight.value or math.ceil(frame:GetHeight())
	elseif self.db.profile.TopFrame.fheight then
		fh = self.db.profile.TopFrame.fheight <= math.ceil(frame:GetHeight()) and self.db.profile.TopFrame.fheight or math.ceil(frame:GetHeight())
	end
	self:storeAndSkin(ftype, frame, nil, fb, self.db.profile.TopFrame.alpha, fh)

	-- keep a reference to the frame
	self.topframe = frame

	self:adjustTFOffset(nil)

	if not self.db.profile.Gradient.skinner then return end

	-- TopFrame Gradient settings
	local orientation = self.db.profile.TopFrame.rotate and "HORIZONTAL" or "VERTICAL"
	self.gradientOnTF = self.db.profile.TopFrame.invert and {orientation, self.MaxR, self.MaxG, self.MaxB, self.MaxA, self.MinR, self.MinG, self.MinB, self.MinA} or {orientation, self.MinR, self.MinG, self.MinB, self.MinA, self.MaxR, self.MaxG, self.MaxB, self.MaxA}
	gradientOffTF = {orientation, 0, 0, 0, 1, 0, 0, 0, 1}

	if self.db.profile.TopFrame.invert then
		frame.tfade:ClearAllPoints()
		frame.tfade:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", -4, 4)
		frame.tfade:SetPoint("TOPRIGHT", frame, "BOTTOMRIGHT", 4, (fh - 4))
	end
	--	apply the Gradient
	frame.tfade:SetGradientAlpha(unpack(self.db.profile.Gradient.enable and self.gradientOnTF or gradientOffTF))

end

function Skinner:MiddleFrames()

	local function createMiddleFrame(frameId)

		local dbkey = "MiddleFrame"..frameId
		if Skinner.initialized[dbkey] then return end -- already created
		Skinner.initialized[dbkey] = true

		local mfkey = Skinner.db.profile[dbkey]
		local mfp = Skinner.db.profile.MiddleFrame

		local frame = CreateFrame("Frame", "SkinnerMF"..frameId, UIParent)
		frame:SetID(frameId)
		frame:SetFrameStrata(mfkey.fstrata)
		frame:SetFrameLevel(mfkey.flevel)
		frame:SetMovable(true)
		frame:SetResizable(true)
		frame:SetWidth(mfkey.width)
		frame:SetHeight(mfkey.height)
		frame:SetPoint("CENTER", UIParent, "CENTER", mfkey.xOfs, mfkey.yOfs)
		frame:RegisterForDrag("LeftButtonUp")

		if not OnMouseDown then
			function OnMouseDown()
				if arg1 == "LeftButton" and IsAltKeyDown() then
					this.isMoving = true
					this:StartMoving()
					this:Raise()
				end
				if arg1 == "LeftButton" and IsControlKeyDown() then
					this.isMoving = true
					this:StartSizing("BOTTOMRIGHT")
					this:Raise()
				end
			end
		end
		if mfp.lock then
			frame:SetScript("OnMouseDown", function() end)
			frame:EnableMouse(false)
		else
			frame:SetScript("OnMouseDown", OnMouseDown)
			frame:EnableMouse(true)
		end
		if not OnMouseUp then
			function OnMouseUp()
				if arg1 == "LeftButton" then
					if this.isMoving then
						this:StopMovingOrSizing()
						this.isMoving = nil
						this:SetFrameStrata("BACKGROUND")
						this:SetFrameLevel(0)
						local x, y = this:GetCenter()
						local px, py = this:GetParent():GetCenter()
						local dbkey	= "MiddleFrame"..this:GetID()
						Skinner.db.profile[dbkey].xOfs = x - px
						Skinner.db.profile[dbkey].yOfs = y - py
						Skinner.db.profile[dbkey].width = math.floor(this:GetWidth())
						Skinner.db.profile[dbkey].height = math.floor(this:GetHeight())
					end
				end
			end
		end
		frame:SetScript("OnMouseUp", OnMouseUp)
		if not OnHide then
			function OnHide()
				if this.isMoving then
					this:StopMovingOrSizing()
					this.isMoving = nil
				end
			end
		end
		frame:SetScript("OnHide", OnHide)

		local fhp = Skinner.db.profile.FadeHeight
		-- set the fade height
		if fhp.enable and fhp.force then
		-- set the Fade Height to the global value if 'forced'
		-- making sure that it isn't greater than the frame height
			fh = fhp.value <= math.ceil(frame:GetHeight()) and fhp.value or math.ceil(frame:GetHeight())
		elseif mfp.fheight then
			fh = mfp.fheight <= math.ceil(frame:GetHeight()) and mfp.fheight or math.ceil(frame:GetHeight())
		end
		local fb = mfp.borderOff and 0 or 1
		Skinner:storeAndSkin(ftype, frame, nil, fb, nil, fh)
		frame:SetBackdropColor(mfp.r, mfp.g, mfp.b, mfp.a)

		Skinner["middleframe"..frameId] = frame

		frame:Show()

	end

	for i = 1, 9 do
		if self.db.profile["MiddleFrame"..i].shown then createMiddleFrame(i) end
	end

end

function Skinner:BottomFrame()
	if not self.db.profile.BottomFrame.shown or self.initialized.BottomFrame then return end
	self.initialized.BottomFrame = true

	local fh = nil

	local frame = CreateFrame("Frame", "SkinnerBF", UIParent)
	frame:SetFrameStrata("BACKGROUND")
	frame:SetFrameLevel(0)
	frame:EnableMouse(false)
	frame:SetMovable(false)
	frame:SetWidth(self.db.profile.BottomFrame.width or 1920)
	frame:SetHeight(self.db.profile.BottomFrame.height or 200)
	frame:ClearAllPoints()
	if self.db.profile.BottomFrame.xyOff  or self.db.profile.BottomFrame.borderOff then
		frame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", -6, -6)
	else
		frame:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", -3, -3)
	end
	local fb = self.db.profile.BottomFrame.borderOff and 0 or 1
	-- set the fade height
	if self.db.profile.FadeHeight.enable and self.db.profile.FadeHeight.force then
	-- set the Fade Height to the global value if 'forced'
	-- making sure that it isn't greater than the frame height
		fh = self.db.profile.FadeHeight.value <= math.ceil(frame:GetHeight()) and self.db.profile.FadeHeight.value or math.ceil(frame:GetHeight())
	elseif self.db.profile.BottomFrame.fheight then
		fh = self.db.profile.BottomFrame.fheight <= math.ceil(frame:GetHeight()) and self.db.profile.BottomFrame.fheight or math.ceil(frame:GetHeight())
	end
	self:storeAndSkin(ftype, frame, nil, fb, self.db.profile.BottomFrame.alpha, fh)

	-- keep a reference to the frame
	self.bottomframe = frame

	if not self.db.profile.Gradient.skinner then return end

	-- BottomFrame Gradient settings
	local orientation = self.db.profile.BottomFrame.rotate and "HORIZONTAL" or "VERTICAL"
	self.gradientOnBF = self.db.profile.BottomFrame.invert and {orientation, self.MaxR, self.MaxG, self.MaxB, self.MaxA, self.MinR, self.MinG, self.MinB, self.MinA} or {orientation, self.MinR, self.MinG, self.MinB, self.MinA, self.MaxR, self.MaxG, self.MaxB, self.MaxA}
	gradientOffBF = {orientation, 0, 0, 0, 1, 0, 0, 0, 1}

	if self.db.profile.BottomFrame.invert then
		frame.tfade:ClearAllPoints()
		frame.tfade:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", -4, 4)
		frame.tfade:SetPoint("TOPRIGHT", frame, "BOTTOMRIGHT", 4, (fh - 4))
	end
	--	apply the Gradient
	frame.tfade:SetGradientAlpha(unpack(self.db.profile.Gradient.enable and self.gradientOnBF or gradientOffBF))

end
