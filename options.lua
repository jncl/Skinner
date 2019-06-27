local aName, aObj = ...

local _G = _G
local ftype = "opt"

-- Add locals to see if it speeds things up
local AceGUIWidgetLSMlists, InterfaceOptionsFrame_OpenToCategory, LibStub, pairs = _G.AceGUIWidgetLSMlists,  _G.InterfaceOptionsFrame_OpenToCategory, _G.LibStub, _G.pairs

aObj.blizzFrames[ftype].SetupDefaults = function(self)

	local defaults = { profile = {
	-->>-- General
		Warnings             = true,
		Errors               = true,
		MinimapIcon          = {hide = false, minimapPos = 210, radius = 80},
		DropDownPanels       = true,
		DropDownButtons      = false,
		-- Tab and DropDown Texture settings
		TexturedTab          = false,
		TexturedDD           = false,
		TabDDFile            = "None",
		TabDDTexture         = aName .. " Inactive Tab",
		Delay                = {Init = 0.5, Addons = 0.5},
		FadeHeight           = {enable = false, value = 500, force = false},
		StatusBar            = {texture = "Blizzard", r = 0, g = 0.5, b = 0.5, a = 0.5},
	-->>-- Backdrop Settings
		BdDefault            = true,
		BdFile               = "None",
		BdTexture            = "Blizzard ChatFrame Background",
		BdTileSize           = 16,
		BdEdgeFile           = "None",
		BdBorderTexture      = "Blizzard Tooltip",
		BdEdgeSize           = 16,
		BdInset              = 4,
	-->>-- Background Texture settings
		BgUseTex             = false,
		BgFile               = "None",
		BgTexture            = "None",
		BgTile               = false,
		LFGTexture			 = false,
	-->>-- Colours
		ClassClrBd           = false,
		ClassClrBg           = false,
		ClassClrGr           = false,
		ClassClrTT           = false,
		TooltipBorder        = {r = 0.5, g = 0.5, b = 0.5, a = 1},
		BackdropBorder       = {r = 0.5, g = 0.5, b = 0.5, a = 1},
		Backdrop             = {r = 0, g = 0, b = 0, a = 0.9},
		HeadText             = {r = 0.8, g = 0.8, b = 0.0},
		BodyText             = {r = 0.6, g = 0.6, b = 0.0},
		IgnoredText          = {r = 0.5, g = 0.5, b = 0.0},
		GradientMin          = {r = 0.1, g = 0.1, b = 0.1, a = 0},
		GradientMax          = {r = 0.25, g = 0.25, b = 0.25, a = 1},
		BagginsBBC	         = {r = 0.5, g = 0.5, b = 0.5, a = 1},
	-->>-- Gradient
		Gradient             = {enable = true, invert = false, rotate = false, char = true, ui = true, npc = true, skinner = true, texture = "Blizzard ChatFrame Background"},
	-->>-- Modules
		-- populated below
	-->>-- NPC Frames
		DisableAllNPC        = false,
		AlliedRacesUI        = true,
		AuctionUI            = true,
		AzeriteRespecUI      = true,
		BankFrame            = true,
		BarbershopUI         = true,
		BlackMarketUI        = true,
		FlightMap            = true,
		GossipFrame          = true,
		GuildRegistrar       = true,
		ItemUpgradeUI        = true,
		MerchantFrame        = true,
		Petition             = true,
		PetStableFrame       = true,
		QuestChoice          = true,
		QuestFrame           = true,
		SideDressUpFrame     = true,
		Tabard               = true,
		TaxiFrame            = true,
		TrainerUI            = true,
		VoidStorageUI        = true,
	-->>-- Player Frames
		DisableAllP          = false,
		AchievementUI        = {skin = true, style = 2},
		ArchaeologyUI        = true,
		AzeriteEssenceUI     = true,
		AzeriteUI			 = true,
		Buffs                = true,
		CastingBar           = {skin = true, glaze = true},
		CharacterFrames      = true,
		Collections          = true, -- (Mounts, Pets, Toys, Heirlooms & Appearances)
		CommunitiesUI		 = true,
		CompactFrames        = true,
		ContainerFrames      = {skin = true, fheight = 100},
		DressUpFrame         = true,
		EncounterJournal     = true,
		EquipmentFlyout      = true,
		FriendsFrame         = true,
		GuildControlUI       = true,
		GuildUI              = true,
		GuildInvite          = true,
		InspectUI            = true,
		ItemSocketingUI      = true,
		LookingForGuildUI    = true,
		LootFrames           = {skin = true, size = 1},
		LootHistory          = true,
		MirrorTimers         = {skin = true, glaze = true},
		ObjectiveTracker     = {skin = false, popups = true},
		OverrideActionBar    = true, -- a.k.a. VehicleUI
		PVPFrame             = true,
		QuestMap             = true,
		RaidUI               = true,
		ReadyCheck           = true,
		RolePollPopup        = true,
		ScrollOfResurrection = true,
		SpellBookFrame       = true,
		StackSplit           = true,
		TalentUI             = true,
		TradeFrame           = true,
		TradeSkillUI         = true,
		VehicleMenuBar       = true,
	-->>-- UI Frames
		DisableAllUI         = false,
		AddonList            = true,
		AdventureMap         = true,
		AlertFrames          = true,
		ArtifactUI           = true,
		AutoComplete         = true,
		BattlefieldMap       = {skin = true, gloss = false},
		BNFrames             = true,
		Calendar             = true,
		ChallengesUI         = true,
		ChatBubbles          = true,
		ChatButtons          = true,
		ChatConfig           = true,
		ChatEditBox          = {skin = true, style = 3},
		ChatFrames           = false, -- (inc ChatMinimizedFrames)
		ChatMenus            = true,
		ChatTabs             = false, -- (inc. ChatTemporaryWindow)
		ChatTabsFade         = true,
		CinematicFrame       = true,
		ClassTrial           = true,
		CoinPickup           = true,
		Colours              = true,
		Console              = true,
		Contribution         = true,
		CombatLogQBF         = false,
		DeathRecap           = true,
		DebugTools           = true,
		DestinyFrame         = true,
		GarrisonUI           = true,
		GhostFrame           = true,
		GMChatUI             = true,
		GMSurveyUI           = true,
		GuildBankUI          = true,
		HelpFrame            = true,
		IslandsPartyPoseUI   = true,
		IslandsQueueUI   	 = true,
		ItemText             = true,
		LevelUpDisplay       = true,
		LossOfControl        = true,
		MailFrame            = true,
		MainMenuBar          = {skin = true, glazesb = true, extraab=true, altpowerbar=true},
		MenuFrames           = true, -- (inc. MacroUI & BindingUI)
		Minimap              = {skin = false, gloss = false},
		MinimapButtons       = {skin = false, style = false},
		MovePad              = true,
		MovieFrame           = true,
		Nameplates           = true,
		ObliterumUI          = true,
		OrderHallUI          = true,
		PetBattleUI          = true,
		ProductChoiceFrame   = true,
		PVEFrame             = true, -- (inc, LFD, LFG, RaidFinder, ScenarioFinder)
		PVPMatch			 = true,
		QuestMap             = true,
		QueueStatusFrame     = true,
		RaidFrame            = true, -- (inc. LFR)
		ScriptErrors         = true,
		ScrappingMachineUI   = true,
		SplashFrame          = true,
		StaticPopups         = true,
		TalkingHeadUI        = true,
		TimeManager          = true,
		Tooltips             = {skin = true, style = 1, glazesb = true, border = 1},
		Tutorial             = true,
		UIWidgets            = true,
		UnitPopup            = true,
		WarboardUI           = true,
		WarfrontsPartyPoseUI = true ,
		WorldMap             = {skin = true, size = 1},
		ZoneAbility          = true,
	-->>-- Disabled Skins
		DisableAllAS         = false,
		DisabledSkins        = {},
	-->-- Profiles
		-- populated below

	},}

	self.db = LibStub:GetLibrary("AceDB-3.0"):New(aName .. "DB", defaults, "Default")

end

aObj.blizzFrames[ftype].SetupOptions = function(self)

	local db = self.db.profile
	local dflts = self.db.defaults.profile
	local bggns = _G.IsAddOnLoaded("Baggins") and self.Baggins and true or false

	local function reskinIOFBackdrop()
		-- show changes by reskinning the Interface Options Frame with the new settings
		self:setupBackdrop()
		_G.InterfaceOptionsFrame.sf:SetBackdrop(self.backdrop)
		_G.InterfaceOptionsFrame.sf:SetBackdropColor(aObj.bClr:GetRGBA())
		_G.InterfaceOptionsFrame.sf:SetBackdropBorderColor(aObj.bbClr:GetRGBA())
	end

	self.optTables = {

		General = {
			type = "group",
			name = aName,
			get = function(info) return db[info[#info]] end,
			set = function(info, value) db[info[#info]] = value end,
			args = {
				desc = {
					type = "description",
					order = 1,
					name = self.L["UI Enhancement"]  .. " - "..(_G.GetAddOnMetadata(aName, "X-Curse-Packaged-Version") or _G.GetAddOnMetadata(aName, "Version") or "") .. "\n",
				},
				longdesc = {
					type = "description",
					order = 2,
					name = self.L["Provides a Minimalist UI by removing the Blizzard textures"] .. "\n",
				},
				Errors = {
					type = "toggle",
					order = 3,
					name = self.L["Show Errors"],
					desc = self.L["Toggle the Showing of Errors"],
				},
				Warnings = {
					type = "toggle",
					order = 4,
					name = self.L["Show Warnings"],
					desc = self.L["Toggle the Showing of Warnings"],
				},
				MinimapIcon = {
					type = "toggle",
					order = 5,
					name = self.L["Minimap icon"],
					desc = self.L["Toggle the minimap icon"],
					get = function(info) return not db.MinimapIcon.hide end,
					set = function(info, value)
						db.MinimapIcon.hide = not value
						if value then self.DBIcon:Show(aName) else self.DBIcon:Hide(aName) end
					end,
					hidden = function() return not self.DBIcon end,
				},
				DropDownButtons = {
					type = "toggle",
					order = 6,
					name = self.L["DropDown Buttons"],
					desc = self.L["Toggle the skin of the DropDown Buttons"],
				},
				DropDownPanels = {
					type = "toggle",
					order = 7,
					name = self.L["DropDown Panels"],
					desc = self.L["Toggle the skin of the DropDown Panels"],
				},
				TabDDTextures = {
					type = "group",
					order = 10,
					inline = true,
					name = self.L["Inactive Tab & DropDown Texture Settings"],
					args = {
						TexturedDD = {
							type = "toggle",
							order = 1,
							name = self.L["Textured DropDown"],
							desc = self.L["Toggle the Texture of the DropDowns"],
						},
						TexturedTab = {
							type = "toggle",
							order = 2,
							name = self.L["Textured Tab"],
							desc = self.L["Toggle the Texture of the Tabs"],
							set = function(info, value)
								db[info[#info]] = value
								self.isTT = db[info[#info]] and true or false
							end,
						},
						TabDDFile = {
							type = "input",
							order = 3,
							width = "full",
							name = self.L["Inactive Tab & DropDown Texture File"],
							desc = self.L["Set Inactive Tab & DropDown Texture Filename"],
						},
						TabDDTexture = AceGUIWidgetLSMlists and {
							type = "select",
							order = 4,
							width = "double",
							name = self.L["Inactive Tab & DropDown Texture"],
							desc = self.L["Choose the Texture for the Inactive Tab & DropDowns"],
							dialogControl = "LSM30_Background",
							values = AceGUIWidgetLSMlists.background,
						} or nil,
					},
				},
				Delay = {
					type = "group",
					order = 21,
					inline = true,
					name = self.L["Skinning Delays"],
					get = function(info) return db.Delay[info[#info]] end,
					set = function(info, value) db.Delay[info[#info]] = value end,
					args = {
						Init = {
							type = "range",
							order = 1,
							name = self.L["Initial Delay"],
							desc = self.L["Set the Delay before Skinning Blizzard Frames"],
							min = 0, max = 10, step = 0.5,
						},
						Addons = {
							type = "range",
							order = 2,
							name = self.L["Addons Delay"],
							desc = self.L["Set the Delay before Skinning Addons Frames"],
							min = 0, max = 10, step = 0.5,
						},
					},
				},
				FadeHeight = {
					type = "group",
					order = 22,
					inline = true,
					name = self.L["Fade Height"],
					get = function(info) return db.FadeHeight[info[#info]] end,
					set = function(info, value) db.FadeHeight[info[#info]] = value end,
					args = {
						enable = {
							type = "toggle",
							order = 1,
							name = self.L["Global Fade Height"],
							desc = self.L["Toggle the Global Fade Height"],
						},
						value = {
							type = "range",
							order = 2,
							name = self.L["Fade Height value"],
							desc = self.L["Change the Height of the Fade Effect"],
							min = 0, max = 1000, step = 10,
						},
						force = {
							type = "toggle",
							order = 3,
							name = self.L["Force the Global Fade Height"],
							desc = self.L["Force ALL Frame Fade Height's to be Global"],
						},
					},
				},
				StatusBar = {
					type = "group",
					order = 23,
					inline = true,
					name = self.L["StatusBar"],
					args = {
						texture = AceGUIWidgetLSMlists and {
							type = "select",
							order = 1,
							name = self.L["Texture"],
							desc = self.L["Choose the Texture for the Status Bars"],
							dialogControl = "LSM30_Statusbar",
							values = AceGUIWidgetLSMlists.statusbar,
							get = function(info) return db.StatusBar.texture end,
							set = function(info, value)
								db.StatusBar.texture = value
								self:checkAndRun("updateSBTexture", "s") -- not an addon in its own right
							end,
						} or nil,
						bgcolour = {
							type = "color",
							order = 2,
							name = self.L["Background Colour"],
							desc = self.L["Change the Colour of the Status Bar Background"],
							hasAlpha = true,
							get = function(info)
								local c = db.StatusBar
								return c.r, c.g, c.b, c.a
							end,
							set = function(info, r, g, b, a)
								local c = db.StatusBar
								c.r, c.g, c.b, c.a = r, g, b, a
								self:checkAndRun("updateSBTexture", "s") -- not an addon in its own right
							end,
						},
					},
				},
			},
		},

		Backdrop = {
			type = "group",
			name = self.L["Default Backdrop"],
			get = function(info) return db[info[#info]] end,
			set = function(info, value)
				db[info[#info]] = value == "" and "None" or value
				if info[#info] ~= "BdDefault" then db.BdDefault = false end
				reskinIOFBackdrop()
			end,
			args = {
				BdDefault = {
					type = "toggle",
					order = 1,
					width = "double",
					name = self.L["Use Default Backdrop"],
					desc = self.L["Toggle the Default Backdrop"],
				},
				BdFile = {
					type = "input",
					order = 2,
					width = "full",
					name = self.L["Backdrop Texture File"],
					desc = self.L["Set Backdrop Texture Filename"],
				},
				BdTexture = AceGUIWidgetLSMlists and {
					type = "select",
					order = 3,
					width = "double",
					name = self.L["Backdrop Texture"],
					desc = self.L["Choose the Texture for the Backdrop"],
					dialogControl = "LSM30_Background",
					values = AceGUIWidgetLSMlists.background,
				} or nil,
				BdTileSize = {
					type = "range",
					order = 4,
					name = self.L["Backdrop TileSize"],
					desc = self.L["Set Backdrop TileSize"],
					min = 0, max = 128, step = 4,
				},
				BdEdgeFile = {
					type = "input",
					order = 5,
					width = "full",
					name = self.L["Border Texture File"],
					desc = self.L["Set Border Texture Filename"],
				},
				BdBorderTexture = AceGUIWidgetLSMlists and {
					type = "select",
					order = 6,
					width = "double",
					name = self.L["Border Texture"],
					desc = self.L["Choose the Texture for the Border"],
					dialogControl = 'LSM30_Border',
					values = AceGUIWidgetLSMlists.border,
				} or nil,
				BdEdgeSize = {
					type = "range",
					order = 7,
					name = self.L["Border Width"],
					desc = self.L["Set Border Width"],
					min = 0, max = 32, step = 1,
				},
				BdInset = {
					type = "range",
					order = 8,
					name = self.L["Border Inset"],
					desc = self.L["Set Border Inset"],
					min = 0, max = 8, step = 1,
				},
			},
		},

		Background = {
			type = "group",
			name = self.L["Background Settings"],
			get = function(info) return db[info[#info]] end,
			set = function(info, value)
				db[info[#info]] = value == "" and "None" or value
				if info[#info] ~= "BgUseTex"
				and info[#info] ~= "LFGTexture"
				then
					db.BgUseTex = true
				end
				if db.BgUseTex then db.Tooltips.style = 3 end -- set Tooltip style to Custom
			end,
			args = {
				BgUseTex = {
					type = "toggle",
					order = 1,
					width = "double",
					name = self.L["Use Background Texture"],
					desc = self.L["Toggle the Background Texture"],
				},
				BgFile = {
					type = "input",
					order = 2,
					width = "full",
					name = self.L["Background Texture File"],
					desc = self.L["Set Background Texture Filename"],
				},
				BgTexture = AceGUIWidgetLSMlists and {
					type = "select",
					order = 3,
					width = "double",
					name = self.L["Background Texture"],
					desc = self.L["Choose the Texture for the Background"],
					dialogControl = "LSM30_Background",
					values = AceGUIWidgetLSMlists.background,
				} or nil,
				BgTile = {
					type = "toggle",
					order = 4,
					name = self.L["Tile Background"],
					desc = self.L["Tile or Stretch Background"],
				},
				LFGTexture = {
					type = "toggle",
					width = "double",
					name = self.L["Show LFG Background Texture"],
					desc = self.L["Toggle the background texture of the LFG Popup"],
				},
			},
		},

		Colours = {
			type = "group",
			name = self.L["Default Colours"],
			get = function(info)
				if info[#info] == "ClassClrBd"
				or info[#info] == "ClassClrBg"
				or info[#info] == "ClassClrGr"
				or info[#info] == "ClassClrTT"
				then
					return db[info[#info]]
				else
					local c = db[info[#info]]
					return c.r, c.g, c.b, c.a or nil
				end
			end,
			set = function(info, r, g, b, a)
				if info[#info] == "ClassClrBd" then
					db[info[#info]] = r
					if r then
						db.BackdropBorder.r = _G.RAID_CLASS_COLORS[self.uCls].r
						db.BackdropBorder.g = _G.RAID_CLASS_COLORS[self.uCls].g
						db.BackdropBorder.b = _G.RAID_CLASS_COLORS[self.uCls].b
						if bggns then
							db.BagginsBBC.r = _G.RAID_CLASS_COLORS[self.uCls].r
							db.BagginsBBC.g = _G.RAID_CLASS_COLORS[self.uCls].g
							db.BagginsBBC.b = _G.RAID_CLASS_COLORS[self.uCls].b
						end
					else
						db.BackdropBorder = dflts.BackdropBorder
						if bggns then
							db.BagginsBBC = dflts.BagginsBBC
						end
					end
				elseif info[#info] == "ClassClrBg" then
					db[info[#info]] = r
					if r then
						db.Backdrop.r = _G.RAID_CLASS_COLORS[self.uCls].r
						db.Backdrop.g = _G.RAID_CLASS_COLORS[self.uCls].g
						db.Backdrop.b = _G.RAID_CLASS_COLORS[self.uCls].b
					else
						db.Backdrop = dflts.Backdrop
					end
				elseif info[#info] == "ClassClrGr" then
					db[info[#info]] = r
					if r then
						db.GradientMax.r = _G.RAID_CLASS_COLORS[self.uCls].r
						db.GradientMax.g = _G.RAID_CLASS_COLORS[self.uCls].g
						db.GradientMax.b = _G.RAID_CLASS_COLORS[self.uCls].b
					else
						db.GradientMax = dflts.GradientMax
					end
				elseif info[#info] == "ClassClrTT" then
					db[info[#info]] = r
					if r then
						db.TooltipBorder.r = _G.RAID_CLASS_COLORS[self.uCls].r
						db.TooltipBorder.g = _G.RAID_CLASS_COLORS[self.uCls].g
						db.TooltipBorder.b = _G.RAID_CLASS_COLORS[self.uCls].b
					else
						db.TooltipBorder = dflts.TooltipBorder
					end
				else
					local c = db[info[#info]]
					c.r, c.g, c.b, c.a = r, g, b, a
				end
			end,
			args = {
				ClassClrBd = {
					type = "toggle",
					order = 1,
					width = "double",
					name = self.L["Class Coloured Border"],
					desc = self.L["Use Class Colour for Border"],
				},
				ClassClrBg = {
					type = "toggle",
					order = 2,
					width = "double",
					name = self.L["Class Coloured Background"],
					desc = self.L["Use Class Colour for Background"],
				},
				ClassClrGr = {
					type = "toggle",
					order = 3,
					width = "double",
					name = self.L["Class Coloured Gradient"],
					desc = self.L["Use Class Colour for Gradient"],
				},
				ClassClrTT = {
					type = "toggle",
					order = 4,
					width = "double",
					name = self.L["Class Coloured Tooltip"],
					desc = self.L["Use Class Colour for Tooltip"],
				},
				TooltipBorder = {
					type = "color",
					order = 6,
					width = "double",
					name = self.L["Tooltip Border Colour"],
					desc = self.L["Set Tooltip Border Colour"],
					hasAlpha = true,
				},
				Backdrop = {
					type = "color",
					order = 7,
					width = "double",
					name = self.L["Backdrop Colour"],
					desc = self.L["Set Backdrop Colour"],
					hasAlpha = true,
				},
				BackdropBorder = {
					type = "color",
					order = 8,
					width = "double",
					name = self.L["Border Colour"],
					desc = self.L["Set Backdrop Border Colour"],
					hasAlpha = true,
				},
				HeadText = {
					type = "color",
					order = 9,
					width = "double",
					name = self.L["Text Heading Colour"],
					desc = self.L["Set Text Heading Colour"],
				},
				BodyText = {
					type = "color",
					order = 10,
					width = "double",
					name = self.L["Text Body Colour"],
					desc = self.L["Set Text Body Colour"],
				},
				IgnoredText = {
					type = "color",
					order = 11,
					width = "double",
					name = self.L["Ignored Text Colour"],
					desc = self.L["Set Ignored Text Colour"],
				},
				GradientMin = {
					type = "color",
					order = 12,
					width = "double",
					name = self.L["Gradient Minimum Colour"],
					desc = self.L["Set Gradient Minimum Colour"],
					hasAlpha = true,
				},
				GradientMax = {
					type = "color",
					order = 13,
					width = "double",
					name = self.L["Gradient Maximum Colour"],
					desc = self.L["Set Gradient Maximum Colour"],
					hasAlpha = true,
				},
				BagginsBBC = _G.IsAddOnLoaded("Baggins") and self.Baggins and {
					type = "color",
					order = -1,
					width = "double",
					name = self.L["Baggins Bank Bags Colour"],
					desc = self.L["Set Baggins Bank Bags Colour"],
					hasAlpha = true,
				} or nil,
			},
		},

		Gradient = {
			type = "group",
			name = self.L["Gradient"],
			get = function(info) return db.Gradient[info[#info]] end,
			set = function(info, value) db.Gradient[info[#info]] = value end,
			args = {
				enable = {
					type = "toggle",
					order = 1,
					width = "double",
					name = self.L["Gradient Effect"],
					desc = self.L["Toggle the Gradient Effect"],
				},
				texture = AceGUIWidgetLSMlists and {
					type = "select",
					order = 2,
					width = "double",
					name = self.L["Gradient Texture"],
					desc = self.L["Choose the Texture for the Gradient"],
					dialogControl = "LSM30_Background",
					values = AceGUIWidgetLSMlists.background,
				} or nil,
				invert = {
					type = "toggle",
					order = 3,
					width = "double",
					name = self.L["Invert Gradient"],
					desc = self.L["Invert the Gradient Effect"],
				},
				rotate = {
					type = "toggle",
					order = 4,
					width = "double",
					name = self.L["Rotate Gradient"],
					desc = self.L["Rotate the Gradient Effect"],
				},
				char = {
					type = "toggle",
					order = 5,
					width = "double",
					name = self.L["Enable Character Frames Gradient"],
					desc = self.L["Enable the Gradient Effect for the Character Frames"],
				},
				ui = {
					type = "toggle",
					order = 6,
					width = "double",
					name = self.L["Enable UserInterface Frames Gradient"],
					desc = self.L["Enable the Gradient Effect for the UserInterface Frames"],
				},
				npc = {
					type = "toggle",
					order = 7,
					width = "double",
					name = self.L["Enable NPC Frames Gradient"],
					desc = self.L["Enable the Gradient Effect for the NPC Frames"],
				},
				skinner = {
					type = "toggle",
					order = 8,
					width = "double",
					name = self.L["Enable Skinner Frames Gradient"],
					desc = self.L["Enable the Gradient Effect for the Skinner Frames"],
				},
			},
		},

		Modules = {
			type = "group",
			name = self.L["Module settings"],
			childGroups = "tab",
			args = {
				desc = {
					type = "description",
					name = self.L["Change the Module's settings"],
				},
			},
		},

		["NPC Frames"] = {
			type = "group",
			name = self.L["NPC Frames"],
			get = function(info) return db[info[#info]] end,
			set = function(info, value)
				db[info[#info]] = value
				-- handle Blizzard LoD Addons
				if self.blizzLoDFrames.n[info[#info]] then
					if _G.IsAddOnLoaded("Blizzard_" .. info[#info]) then
						self:checkAndRun(info[#info], "n", true)
					end
				else self:checkAndRun(info[#info], "n") end
				-- treat GossipFrame & QuestFrame as one
				-- as they both change the quest text colours
				if info[#info] == "GossipFrame" then
					db.QuestFrame = value
					_G.InterfaceOptionsFrame_OpenToCategory(self.optionsFrame[self.L["NPC Frames"]])
				end
				if info[#info] == "QuestFrame" then
					db.GossipFrame = value
					_G.InterfaceOptionsFrame_OpenToCategory(self.optionsFrame[self.L["NPC Frames"]])
				end
			end,
			args = {
				head1 = {
					order = 1,
					type = "header",
					name = self.L["Either"],
				},
				DisableAllNPC = {
					order = 2,
					width = "full",
					type = "toggle",
					name = self.L["Disable all NPC Frames"],
					desc = self.L["Disable all the NPC Frames from being skinned"],
					set = function(info, value) db[info[#info]] = value end,
				},
				head2 = {
					order = 3,
					type = "header",
					name = self.L["or choose which frames to skin"],
				},
				AlliedRacesUI = {
					type = "toggle",
					name = self.L["Allied Races UI"],
					desc = self.L["Toggle the skin of the Allied Races UI"],
				},
				AuctionUI = {
					type = "toggle",
					name = self.L["Auction UI"],
					desc = self.L["Toggle the skin of the Auction UI"],
				},
				AzeriteRespecUI ={
					type = "toggle",
					name = self.L["Azerite Respec UI"],
					desc = self.L["Toggle the skin of the Azerite Respec UI"],
				},
				BankFrame = {
					type = "toggle",
					name = self.L["Bank Frame"],
					desc = self.L["Toggle the skin of the Bank Frame"],
				},
				BarbershopUI = {
					type = "toggle",
					name = self.L["Barbershop UI"],
					desc = self.L["Toggle the skin of the Barbershop UI"],
				},
				BlackMarketUI = {
					type = "toggle",
					width = "double",
					name = self.L["Black Market UI"],
					desc = self.L["Toggle the skin of the Black Market UI"],
				},
				FlightMap = {
					type = "toggle",
					name = self.L["Flight Map"],
					desc = self.L["Toggle the skin of the Flight Map"],
				},
				GossipFrame = {
					type = "toggle",
					name = self.L["Gossip Frame"],
					desc = self.L["Toggle the skin of the Gossip Frame"],
				},
				GuildRegistrar = {
					type = "toggle",
					name = self.L["Guild Registrar Frame"],
					desc = self.L["Toggle the skin of the Guild Registrar Frame"],
				},
				MerchantFrame = {
					type = "toggle",
					name = self.L["Merchant Frame"],
					desc = self.L["Toggle the skin of the Merchant Frame"],
				},
				Petition = {
					type = "toggle",
					name = self.L["Petition Frame"],
					desc = self.L["Toggle the skin of the Petition Frame"],
				},
				PetStableFrame = {
					type = "toggle",
					name = self.L["Stable Frame"],
					desc = self.L["Toggle the skin of the Stable Frame"],
				},
				QuestChoice = {
					type = "toggle",
					name = self.L["Quest Choice Frame"],
					desc = self.L["Toggle the skin of the Quest Choice Frame"],
				},
				QuestFrame = {
					type = "toggle",
					name = self.L["Quest Frame"],
					desc = self.L["Toggle the skin of the Quest Frame"],
				},
				SideDressUpFrame = {
					type = "toggle",
					name = self.L["Side DressUp Frame"],
					desc = self.L["Toggle the skin of the Side DressUp Frame"],
				},
				Tabard = {
					type = "toggle",
					name = self.L["Tabard Frame"],
					desc = self.L["Toggle the skin of the Tabard Frame"],
				},
				TaxiFrame = {
					type = "toggle",
					name = self.L["Taxi Frame"],
					desc = self.L["Toggle the skin of the Taxi Frame"],
				},
				TrainerUI = {
					name = self.L["Trainer UI"],
					desc = self.L["Toggle the skin of the Trainer UI"],
					type = "toggle",
				},
				VoidStorageUI = {
					type = "toggle",
					name = self.L["Void Storage UI"],
					desc = self.L["Toggle the skin of the Void Storage UI"],
				},
			},
		},

		["Player Frames"] = {
			type = "group",
			name = self.L["Player Frames"],
			get = function(info) return db[info[#info]] end,
			set = function(info, value)
				db[info[#info]] = value
				-- handle Blizzard LoD Addons
				if self.blizzLoDFrames.p[info[#info]] then
					if _G.IsAddOnLoaded("Blizzard_" .. info[#info]) then
						self:checkAndRun(info[#info], "p", true)
					end
				else self:checkAndRun(info[#info], "p") end
			end,
			args = {
				head1 = {
					order = 1,
					type = "header",
					name = self.L["Either"],
				},
				DisableAllP = {
					order = 2,
					width = "full",
					type = "toggle",
					name = self.L["Disable all Player Frames"],
					desc = self.L["Disable all the Player Frames from being skinned"],
					set = function(info, value) db[info[#info]] = value end,
				},
				head2 = {
					order = 3,
					type = "header",
					name = self.L["or choose which frames to skin"],
				},
				AchievementUI = {
					type = "group",
					order = -1,
					inline = true,
					name = self.L["Achievement UI"],
					get = function(info) return db.AchievementUI[info[#info]] end,
					set = function(info, value)
						db.AchievementUI[info[#info]] = value
						if _G.IsAddOnLoaded("Blizzard_AchievementUI") then	self:checkAndRun("AchievementUI", "p", true) end
					end,
					args = {
						skin = {
							type = "toggle",
							name = self.L["Achievement Skin"],
							desc = self.L["Toggle the skin of the Achievement Frame"],
						},
						style = {
							type = "range",
							name = self.L["Achievement Style"],
							desc = self.L["Set the Achievement style (Textured, Untextured)"],
							min = 1, max = 2, step = 1,
						},
					},
				},
				ArchaeologyUI = {
					type = "toggle",
					name = self.L["Archaeology UI"],
					desc = self.L["Toggle the skin of the Archaeology UI"],
				},
				AzeriteEssenceUI = {
					type = "toggle",
					name = self.L["Azerite Essence UI"],
					desc = self.L["Toggle the skin of the Azerite Essence UI"],
				},
				AzeriteUI = {
					type = "toggle",
					name = self.L["Azerite UI"],
					desc = self.L["Toggle the skin of the Azerite UI"],
				},
				Buffs = {
					type = "toggle",
					name = self.L["Buffs Buttons"],
					desc = self.L["Toggle the skin of the Buffs Buttons"],
				},
				CastingBar = {
					type = "group",
					inline = true,
					order = -1,
					name = self.L["Casting Bar Frame"],
					get = function(info) return db.CastingBar[info[#info]] end,
					set = function(info, value)
						db.CastingBar[info[#info]] = value
						self:checkAndRun("CastingBar", "p")
					end,
					args = {
						skin = {
							type = "toggle",
							order = 1,
							name = self.L["Casting Bar Skin"],
							desc = self.L["Toggle the skin of the Casting Bar"],
						},
						glaze = {
							type = "toggle",
							order = 2,
							name = self.L["Glaze Casting Bar"],
							desc = self.L["Toggle the glazing Casting Bar"],
						},
					},
				},
				CharacterFrames = {
					type = "toggle",
					name = self.L["Character Frames"],
					desc = self.L["Toggle the skin of the Character Frames"],
				},
				Collections = {
					-- (Mounts, Pets, Toys, Heirlooms & Appearances)
					type = "toggle",
					name = self.L["Collections Journal"],
					desc = self.L["Toggle the skin of the Collections Journal"],
				},
				CommunitiesUI ={
					type = "toggle",
					name = self.L["Communities UI"],
					desc = self.L["Toggle the skin of the Communities UI"],
				},
				CompactFrames = {
					type = "toggle",
					name = self.L["Compact Frames"],
					desc = self.L["Toggle the skin of the Compact Frames"],
				},
				ContainerFrames = {
					type = "group",
					inline = true,
					order = -1,
					name = self.L["Container Frames"],
					get = function(info) return db.ContainerFrames[info[#info]] end,
					set = function(info, value)
						db.ContainerFrames[info[#info]] = value
						self:checkAndRun("ContainerFrames", "p")
					end,
					args = {
						skin = {
							type = "toggle",
							order = 1,
							name = self.L["Containers Skin"],
							desc = self.L["Toggle the skin of the Container Frames"],
						},
						fheight = {
							type = "range",
							order = 2,
							name = self.L["CF Fade Height"],
							desc = self.L["Change the Height of the Fade Effect"],
							min = 0, max = 300, step = 1,
						},
					},
				},
				DressUpFrame = {
					type = "toggle",
					name = self.L["DressUp Frame"],
					desc = self.L["Toggle the skin of the DressUp Frame"],
				},
				EncounterJournal = {
					type = "toggle",
					name = self.L["Adventure Guide"],
					desc = self.L["Toggle the skin of the Adventure Guide"],
				},
				EquipmentFlyout = {
					type = "toggle",
					name = self.L["Equipment Flyout"],
					desc = self.L["Toggle the skin of the Equipment Flyout Frame"],
				},
				FriendsFrame = {
					type = "toggle",
					name = self.L["Friends List Frame"],
					desc = self.L["Toggle the skin of the Friends List Frame"],
				},
				GuildControlUI = {
					type = "toggle",
					name = self.L["Guild Control UI"],
					desc = self.L["Toggle the skin of the Guild Control UI"],
				},
				GuildUI = {
					type = "toggle",
					name = self.L["Guild UI"],
					desc = self.L["Toggle the skin of the Guild UI"],
				},
				GuildInvite = {
					type = "toggle",
					name = self.L["Guild Invite Frame"],
					desc = self.L["Toggle the skin of the Guild Invite Frame"],
				},
				InspectUI = {
					type = "toggle",
					name = self.L["Inspect UI"],
					desc = self.L["Toggle the skin of the Inspect UI"],
				},
				ItemSocketingUI = {
					type = "toggle",
					name = self.L["Item Socketing UI"],
					desc = self.L["Toggle the skin of the Item Socketing UI"],
				},
				LookingForGuildUI = {
					type = "toggle",
					width = "double",
					name = self.L["Looking for Guild UI"],
					desc = self.L["Toggle the skin of the Looking for Guild UI"],
				},
				LootFrames = {
					type = "group",
					inline = true,
					order = -1,
					name = self.L["Loot Frames"],
					get = function(info) return db.LootFrames[info[#info]] end,
					set = function(info, value)
						db.LootFrames[info[#info]] = value
						self:checkAndRun("LootFrames", "p")
					end,
					args = {
						skin = {
							type = "toggle",
							order = 1,
							name = self.L["Loot Frames"],
							desc = self.L["Toggle the skin of the Loot Frames"],
						},
						size = {
							type = "range",
							order = 2,
							name = self.L["GroupLoot Size"],
							desc = self.L["Set the GroupLoot size (Normal, Small, Micro)"],
							min = 1, max = 3, step = 1,
						},
					},
				},
				LootHistory = {
					type = "toggle",
					name = self.L["Loot History Frame"],
					desc = self.L["Toggle the skin of the Loot History Frame"],
				},
				MirrorTimers = {
					type = "group",
					inline = true,
					order = -1,
					name = self.L["Timer Frames"],
					get = function(info) return db.MirrorTimers[info[#info]] end,
					set = function(info, value)
						db.MirrorTimers[info[#info]] = value
						self:checkAndRun("MirrorTimers", "p")
					end,
					args = {
						skin = {
							type = "toggle",
							order = 1,
							name = self.L["Timer Skin"],
							desc = self.L["Toggle the skin of the Timer"],
						},
						glaze = {
							type = "toggle",
							order = 2,
							name = self.L["Glaze Timer"],
							desc = self.L["Toggle the glazing Timer"],
						},
					},
				},
				ObjectiveTracker = {
					type = "group",
					order = -1,
					inline = true,
					name = self.L["Tracker Frame"],
					get = function(info) return db.ObjectiveTracker[info[#info]] end,
					set = function(info, value) db.ObjectiveTracker[info[#info]] = value end,
					args = {
						skin = {
							type = "toggle",
							name = self.L["Tracker Frame Skin"],
							desc = self.L["Toggle the skin of the Tracker Frame"],
						},
						popups = {
							type = "toggle",
							name = self.L["AutoPopUps Skin"],
							desc = self.L["Toggle the skin of the AutoPopUps"],
						},
					},
				},
				OverrideActionBar = {
					type = "toggle",
					name = self.L["Vehicle UI"],
					desc = self.L["Toggle the skin of the Vehicle UI"],
				},
				PVPFrame = {
					type = "toggle",
					name = self.L["PVP Frame"],
					desc = self.L["Toggle the skin of the PVP Frame"],
				},
				QuestMap = {
					type = "toggle",
					name = self.L["Quest Map Frame"],
					desc = self.L["Toggle the skin of the Quest Map Frame"],
				},
				RaidUI = {
					type = "toggle",
					name = self.L["Raid UI"],
					desc = self.L["Toggle the skin of the Raid UI"],
				},
				ReadyCheck = {
					type = "toggle",
					name = self.L["ReadyCheck Frame"],
					desc = self.L["Toggle the skin of the ReadyCheck Frame"],
				},
				RolePollPopup = {
					type = "toggle",
					name = self.L["Role Poll Popup"],
					desc = self.L["Toggle the skin of the Role Poll Popup"],
				},
				ScrollOfResurrection = {
					type = "toggle",
					name = self.L["Scroll Of Resurrection"],
					desc = self.L["Toggle the skin of the Scroll Of Resurrection Frame"],
				},
				SpellBookFrame = {
					type = "toggle",
					name = self.L["SpellBook Frame"],
					desc = self.L["Toggle the skin of the SpellBook Frame"],
				},
				StackSplit = {
					type = "toggle",
					name = self.L["Stack Split Frame"],
					desc = self.L["Toggle the skin of the Stack Split Frame"],
				},
				TalentUI = {
					type = "toggle",
					name = self.L["Talent UI"],
					desc = self.L["Toggle the skin of the Talent UI"],
				},
				TradeFrame = {
					type = "toggle",
					name = self.L["Trade Frame"],
					desc = self.L["Toggle the skin of the Trade Frame"],
				},
				TradeSkillUI = {
					type = "toggle",
					name = self.L["Trade Skill UI"],
					desc = self.L["Toggle the skin of the Trade Skill UI"],
				},
			},
		},

		["UI Frames"] = {
			type = "group",
			name = self.L["UI Frames"],
			get = function(info) return db[info[#info]] end,
			set = function(info, value)
				db[info[#info]] = value
				if info[#info] == "Colours" then self:checkAndRun("ColorPicker", "p")
				elseif info[#info] == "CombatLogQBF" then return
				elseif info[#info] == "ChatTabsFade" then return
				-- handle Blizzard LoD Addons
				elseif self.blizzLoDFrames.u[info[#info]] then
					if _G.IsAddOnLoaded("Blizzard_" .. info[#info]) then
						self:checkAndRun(info[#info], "u", true)
					end
				else self:checkAndRun(info[#info], "u") end
			end,
			args = {
				head1 = {
					order = 1,
					type = "header",
					name = self.L["Either"],
				},
				DisableAllUI = {
					order = 2,
					width = "full",
					type = "toggle",
					name = self.L["Disable all UI Frames"],
					desc = self.L["Disable all the UI Frames from being skinned"],
					set = function(info, value) db[info[#info]] = value end,
				},
				head2 = {
					order = 3,
					type = "header",
					name = self.L["or choose which frames to skin"],
				},
				AddonList = {
					type = "toggle",
					name = self.L["AddonList Frame"],
					desc = self.L["Toggle the skin of the AddonList Frame"],
				},
				AdventureMap = {
					type = "toggle",
					name = self.L["Adventure Map"],
					desc = self.L["Toggle the skin of the Adventure Map"],
				},
				AlertFrames = {
					type = "toggle",
					name = self.L["Alert Frames"],
					desc = self.L["Toggle the skin of the Alert Frames"],
				},
				ArtifactUI = {
					type = "toggle",
					name = self.L["Artifact UI"],
					desc = self.L["Toggle the skin of the Artifact UI"],
				},
				AutoComplete = {
					type = "toggle",
					name = self.L["Auto Complete"],
					desc = self.L["Toggle the skin of the Auto Complete Frame"],
				},
				BattlefieldMap ={
					type = "group",
					inline = true,
					order = -1,
					name = self.L["Battlefield Map Options"],
					get = function(info) return db.BattlefieldMap[info[#info]] end,
					set = function(info, value)
						db.BattlefieldMap[info[#info]] = value
						if info[#info] == "skin" then
							if _G.IsAddOnLoaded("Blizzard_BattlefieldMap") then
								self:checkAndRun("BattlefieldMap", "u", true)
							end
						elseif info[#info] == "gloss" and _G.BattlefieldMap.sf then
							if value then
								_G.RaiseFrameLevel(_G.BattlefieldMap.sf)
							else
								_G.LowerFrameLevel(_G.BattlefieldMap.sf)
							end
						end
					end,
					args = {
						skin = {
							type = "toggle",
							name = self.L["Skin Frame"],
							desc = self.L["Toggle the skin of the Battlefield Map Frame"],
							order = 1,
						},
						gloss = {
							type = "toggle",
							name = self.L["Gloss Effect"],
							desc = self.L["Toggle the Gloss Effect for the Battlefield Map"],
							order = 2,
						},
					},
				},
				BNFrames = {
					type = "toggle",
					name = self.L["BattleNet Frames"],
					desc = self.L["Toggle the skin of the BattleNet Frames"],
				},
				Calendar = {
					type = "toggle",
					name = self.L["Calendar"],
					desc = self.L["Toggle the skin of the Calendar Frame"],
				},
				ChallengesUI = {
					type = "toggle",
					name = self.L["Challenges UI"],
					desc = self.L["Toggle the skin of the Challenges UI"],
				},
				chatopts = {
					type = "group",
					inline = true,
					order = -1,
					name = self.L["Chat Sub Frames"],
					args = {
						ChatMenus = {
							type = "toggle",
							order = 1,
							name = self.L["Chat Menus"],
							desc = self.L["Toggle the skin of the Chat Menus"],
						},
						ChatConfig = {
							type = "toggle",
							order = 2,
							name = self.L["Chat Config"],
							desc = self.L["Toggle the skinning of the Chat Config Frame"],
						},
						ChatTabs = {
							type = "toggle",
							order = 3,
							name = self.L["Chat Tabs"],
							desc = self.L["Toggle the skin of the Chat Tabs"],
						},
						ChatTabsFade = {
							type = "toggle",
							order = 4,
							name = self.L["Chat Tabs Fade"],
							desc = self.L["Toggle the fading of the Chat Tabs"],
						},
						ChatFrames = {
							type = "toggle",
							order = 5,
							name = self.L["Chat Frames"],
							desc = self.L["Toggle the skin of the Chat Frames"],
						},
						ChatButtons = {
							type = "toggle",
							order = 6,
							name = self.L["Chat Buttons"],
							desc = self.L["Toggle the skin of the Chat Buttons"],
						},
						CombatLogQBF = {
							type = "toggle",
							width = "double",
							order = 7,
							name = self.L["CombatLog Quick Button Frame"],
							desc = self.L["Toggle the skin of the CombatLog Quick Button Frame"],
						},
						ChatBubbles = {
							type = "toggle",
							order = 8,
							name = self.L["Chat Bubbles"],
							desc = self.L["Toggle the skin of the Chat Bubbles"],
						},
					},
				},
				ChatEditBox = {
					type = "group",
					inline = true,
					order = -1,
					name = self.L["Chat Edit Box"],
					get = function(info) return db.ChatEditBox[info[#info]] end,
					set = function(info, value)
						db.ChatEditBox[info[#info]] = value
						self:checkAndRun("ChatEditBox", "u")
					end,
					args = {
						skin = {
							type = "toggle",
							order = 1,
							name = self.L["Chat Edit Box Skin"],
							desc = self.L["Toggle the skin of the Chat Edit Box Frame"],
						},
						style = {
							type = "range",
							order = 2,
							name = self.L["Chat Edit Box Style"],
							desc = self.L["Set the Chat Edit Box style (Frame, EditBox, Borderless)"],
							min = 1, max = 3, step = 1,
						},
					},
				},
				CinematicFrame = {
					type = "toggle",
					name = self.L["Cinematic Frame"],
					desc = self.L["Toggle the skin of the Cinematic Frame"],
				},
				ClassTrial = {
					type = "toggle",
					name = self.L["ClassTrial Frames"],
					desc = self.L["Toggle the skin of the ClassTrial Frames"],
				},
				CoinPickup = {
					type = "toggle",
					name = self.L["Coin Pickup Frame"],
					desc = self.L["Toggle the skin of the Coin Pickup Frame"],
				},
				Colours = {
					type = "toggle",
					name = self.L["Colour Picker Frame"],
					desc = self.L["Toggle the skin of the Colour Picker Frame"],
				},
				Console = {
					type = "toggle",
					name = self.L["Developer Console Frame"],
					desc = self.L["Toggle the skin of the Developer Console Frame"],
					width = "double",
				},
				Contribution = {
					type = "toggle",
					name = self.L["Contribution Frame"],
					desc = self.L["Toggle the skin of the Contribution Frame"],
				},
				DeathRecap = {
					type = "toggle",
					name = self.L["Death Recap Frame"],
					desc = self.L["Toggle the skin of the Death Recap Frame"],
				},
				DebugTools = {
					type = "toggle",
					name = self.L["Debug Tools Frames"],
					desc = self.L["Toggle the skin of the Debug Tools Frames"],
				},
				DestinyFrame = {
					type = "toggle",
					name = self.L["Destiny Frame"],
					desc = self.L["Toggle the skin of the Destiny Frame"],
				},
				GarrisonUI = {
					type = "toggle",
					name = self.L["Garrison UI"],
					desc = self.L["Toggle the skin of the Garrison UI"],
				},
				GhostFrame = {
					type = "toggle",
					name = self.L["Ghost Frame"],
					desc = self.L["Toggle the skin of the Ghost Frame"],
				},
				GMChatUI = {
					type = "toggle",
					name = self.L["GM Chat UI"],
					desc = self.L["Toggle the skin of the GM Chat UI"],
				},
				GuildBankUI = {
					type = "toggle",
					name = self.L["Guild Bank UI"],
					desc = self.L["Toggle the skin of the Guild Bank UI"],
				},
				HelpFrame = {
					type = "group",
					inline = true,
					order = -1,
					name = self.L["Help Frames"],
					args = {
						HelpFrame = {
							type = "toggle",
							name = self.L["Customer Support"],
							desc = self.L["Toggle the skin of the Customer Support Frame"],
						},
						GMSurveyUI = {
							type = "toggle",
							name = self.L["GM Survey UI"],
							desc = self.L["Toggle the skin of the GM Survey UI"],
						},
					},
				},
				IslandsPartyPoseUI ={
					type = "toggle",
					name = self.L["Islands Party Pose UI"],
					desc = self.L["Toggle the skin of the Islands Party Pose UI"],
				},
				IslandsQueueUI ={
					type = "toggle",
					name = self.L["Islands Queue UI"],
					desc = self.L["Toggle the skin of the Islands Queue UI"],
				},
				ItemText = {
					type = "toggle",
					name = self.L["Item Text Frame"],
					desc = self.L["Toggle the skin of the Item Text Frame"],
				},
				ItemUpgradeUI = {
					type = "toggle",
					name = self.L["Item Upgrade UI"],
					desc = self.L["Toggle the skin of the Item Upgrade UI"],
				},
				LevelUpDisplay = {
					type = "toggle",
					name = self.L["Level Up Display"],
					desc = self.L["Toggle the skin of the Level Up Display"],
				},
				LossOfControl = {
					type = "toggle",
					name = self.L["Loss Of Control Frame"],
					desc = self.L["Toggle the skin of the Loss Of Control Frame"],
				},
				MailFrame = {
					type = "toggle",
					name = self.L["Mail Frame"],
					desc = self.L["Toggle the skin of the Mail Frame"],
				},
				MainMenuBar = {
					type = "group",
					inline = true,
					order = -1,
					name = self.L["Main Menu Bar"],
					get = function(info) return db.MainMenuBar[info[#info]] end,
					set = function(info, value)
						db.MainMenuBar[info[#info]] = value
						self:checkAndRun("MainMenuBar", "u")
					end,
					args = {
						skin = {
							type = "toggle",
							order = 1,
							name = self.L["Main Menu Bar Skin"],
							desc = self.L["Toggle the skin of the Main Menu Bar"],
						},
						glazesb = {
							type = "toggle",
							order = 2,
							width = "double",
							name = self.L["Glaze Main Menu Bar Status Bar"],
							desc = self.L["Toggle the glazing Main Menu Bar Status Bar"],
						},
						extraab = {
							type = "toggle",
							order = 3,
							width = "double",
							name = self.L["Skin Extra Action Button"],
							desc = self.L["Toggle the skin of the Extra Action Button"],
						},
						altpowerbar = {
							type = "toggle",
							order = 3,
							width = "double",
							name = self.L["Skin Alternate Power Bars"],
							desc = self.L["Toggle the skin of the Alternate Power Bars"],
						},
					},
				},
				MenuFrames = {
					-- inc. BindingUI & MacroUI
					type = "toggle",
					name = self.L["Menu Frames"],
					desc = self.L["Toggle the skin of the Menu Frames"],
				},
				Minimap = {
					type = "group",
					inline = true,
					order = -1,
					name = self.L["Minimap Options"],
					get = function(info) return db.Minimap[info[#info]] end,
					set = function(info, value)
						db.Minimap[info[#info]] = value
						if info[#info] == "skin" then self:checkAndRun("Minimap", "u")
						elseif info[#info] == "gloss" and _G.Minimap.sf then
							if value then
								_G.RaiseFrameLevel(_G.Minimap.sf)
							else
								_G.LowerFrameLevel(_G.Minimap.sf)
							end
						elseif info[#info] == "btns" then self:checkAndRun("MinimapButtons", "u")
						elseif info[#info] == "style" then
							db.Minimap.btns = true
							self:checkAndRun("MinimapButtons", "u")
						end
					end,
					args = {
						skin = {
							type = "toggle",
							name = self.L["Skin Frame"],
							desc = self.L["Toggle the skin of the Minimap"],
							order = 1,
						},
						gloss = {
							type = "toggle",
							name = self.L["Gloss Effect"],
							desc = self.L["Toggle the Gloss Effect for the Minimap"],
							order = 2,
						},
					},
				},
				MinimapButtons = {
					type = "group",
					inline = true,
					order = -1,
					name = self.L["Minimap Button Options"],
					get = function(info) return db.MinimapButtons[info[#info]] end,
					set = function(info, value)
						db.MinimapButtons[info[#info]] = value
						if info[#info] == "skin" then self:checkAndRun("MinimapButtons", "u")
						elseif info[#info] == "style" then
							db.MinimapButtons.skin = true
							self:checkAndRun("MinimapButtons", "u")
						end
					end,
					args = {
						skin = {
							type = "toggle",
							order = 1,
							name = self.L["Minimap Buttons"],
							desc = self.L["Toggle the skin of the Minimap Buttons"],
						},
						style = {
							type = "toggle",
							name = self.L["Minimal Minimap Buttons"],
							desc = self.L["Toggle the style of the Minimap Buttons"],
							width = "double",
						},
					},
				},
				MovePad = {
					type = "toggle",
					name = self.L["Move Pad"],
					desc = self.L["Toggle the skin of the Move Pad"],
				},
				MovieFrame = {
					type = "toggle",
					name = self.L["Movie Frame"],
					desc = self.L["Toggle the skin of the Movie Frame"],
				},
				Nameplates = {
					type = "toggle",
					name = self.L["Nameplates"],
					desc = self.L["Toggle the skin of the Nameplates"],
				},
				ObliterumUI = {
					type = "toggle",
					name = self.L["Obliterum UI"],
					desc = self.L["Toggle the skin of the Obliterum UI"],
				},
				OrderHallUI = {
					type = "toggle",
					name = self.L["OrderHall UI"],
					desc = self.L["Toggle the skin of the OrderHall UI"],
				},
				PetBattleUI = {
					type = "toggle",
					name = self.L["Pet Battle UI"],
					desc = self.L["Toggle the skin of the Pet Battle UI"],
				},
				ProductChoiceFrame = {
					type = "toggle",
					name = self.L["Product Choice Frame"],
					desc = self.L["Toggle the skin of the Product Choice Frame"],
				},
				PVEFrame = {
					-- inc. LFD, LFG, Scenario
					type = "toggle",
					name = self.L["Group Finder Frame"],
					desc = self.L["Toggle the skin of the Group Finder Frame"],
				},
				PVPMatch = {
					type = "toggle",
					name = self.L["PVP Match Frame"],
					desc = self.L["Toggle the skin of the PVP Match Frame"],
				},
				QuestMap = {
					type = "toggle",
					name = self.L["Quest Map"],
					desc = self.L["Toggle the skin of the Quest Map"],
				},
				QueueStatusFrame = {
					type = "toggle",
					name = self.L["Queue Status Frame"],
					desc = self.L["Toggle the skin of the Queue Status Frame"],
				},
				RaidFrame = {
					-- inc. LFR
					type = "toggle",
					name = self.L["Raid Frame"],
					desc = self.L["Toggle the skin of the Raid Frame"],
				},
				ScrappingMachineUI ={
					type = "toggle",
					name = self.L["Scrapping Machine UI"],
					desc = self.L["Toggle the skin of the Scrapping Machine UI"],
				},
				ScriptErrors = {
					type = "toggle",
					name = self.L["Script Errors Frame"],
					desc = self.L["Toggle the skin of the Script Errors Frame"],
				},
				SplashFrame = {
					type = "toggle",
					name = self.L["What's New Frame"],
					desc = self.L["Toggle the skin of the What's New Frame"],
				},
				StaticPopups = {
					type = "toggle",
					name = self.L["Static Popups"],
					desc = self.L["Toggle the skin of Static Popups"],
				},
				TalkingHeadUI = {
					type = "toggle",
					name = self.L["TalkingHead UI"],
					desc = self.L["Toggle the skin of the TalkingHead UI"],
				},
				TimeManager = {
					type = "toggle",
					name = self.L["Time Manager"],
					desc = self.L["Toggle the skin of the Time Manager Frame"],
				},
				Tooltips = {
					type = "group",
					inline = true,
					order = -1,
					name = self.L["Tooltips"],
					get = function(info) return db.Tooltips[info[#info]] end,
					set = function(info, value) db.Tooltips[info[#info]] = value end,
					args = {
						skin = {
							type = "toggle",
							order = 1,
							name = self.L["Tooltip Skin"],
							desc = self.L["Toggle the skin of the Tooltips"],
						},
						glazesb = {
							type = "toggle",
							order = 2,
							width = "double",
							name = self.L["Glaze Status Bar"],
							desc = self.L["Toggle the glazing Status Bar"],
						},
						style = {
							type = "range",
							order = 3,
							name = self.L["Tooltips Style"],
							desc = self.L["Set the Tooltips style (Rounded, Flat, Custom)"],
							min = 1, max = 3, step = 1,
						},
						border = {
							type = "range",
							order = 4,
							name = self.L["Tooltips Border Colour"],
							desc = self.L["Set the Tooltips Border colour (Default, Custom)"],
							min = 1, max = 2, step = 1,
						},
					},
				},
				Tutorial = {
					type = "toggle",
					name = self.L["Tutorial Frame"],
					desc = self.L["Toggle the skin of the Tutorial Frame"],
				},
				UIWidgets = {
					type = "toggle",
					name = self.L["UI Widgets"],
					desc = self.L["Toggle the skin of the UI Widgets"],
				},
				UnitPopup ={
					type = "toggle",
					name = self.L["Unit Popups"],
					desc = self.L["Toggle the skin of the Unit Popups"],
				},
				WarboardUI = {
					type = "toggle",
					name = self.L["Warboard UI"],
					desc = self.L["Toggle the skin of the Warboard UI"],
				},
				WarfrontsPartyPoseUI = {
					type = "toggle",
					name = self.L["Warfronts Party Pose UI"],
					desc = self.L["Toggle the skin of the Warfronts Party Pose UI"],
				},
				WorldMap = {
					type = "group",
					inline = true,
					order = -1,
					name = self.L["World Map Frame"],
					get = function(info) return db.WorldMap[info[#info]] end,
					set = function(info, value)
						db.WorldMap[info[#info]] = value
						self:checkAndRun("WorldMap", "u")
					end,
					args = {
						skin = {
							type = "toggle",
							order = 1,
							name = self.L["World Map Skin"],
							desc = self.L["Toggle the skin of the World Map Frame"],
						},
						size = {
							type = "range",
							order = 2,
							name = self.L["World Map Size"],
							desc = self.L["Set the World Map size (Normal, Fullscreen)"],
							min = 1, max = 2, step = 1,
						},
					},
				},
				ZoneAbility = {
					type = "toggle",
					name = self.L["Zone Ability"],
					desc = self.L["Toggle the skin of the Zone Ability"],
				},
			},
		},

		["Disabled Skins"] = {
			type = "group",
			name = self.L["Disable Addon Skins"],
			get = function(info) return db.DisabledSkins[info[#info]] end,
			set = function(info, value) db.DisabledSkins[info[#info]] = value and value or nil end,
			args = {
				head1 = {
					order = 1,
					type = "header",
					name = self.L["Either"],
				},
				DisableAllAS = {
					order = 2,
					width = "full",
					type = "toggle",
					name = self.L["Disable all Addon Skins"],
					desc = self.L["Disable all the Addon skins"],
					get = function(info) return db[info[#info]] end,
					set = function(info, value) db[info[#info]] = value end,
				},
				head2 = {
					order = 3,
					type = "header",
					name = self.L["or choose which Addon skins to disable"],
				},
			},
		},

	}

	-- module options
	for _, mod in self:IterateModules() do
		if mod.GetOptions then
			self.optTables["Modules"].args[mod.name] = mod:GetOptions()
		end
	end

	-- add DisabledSkins options
	local function addDSOpt(name, lib, lod)

		local name2 = name .. (lib and " (Lib)" or lod and " (LoD)" or "")
		local width2 = name2:len() > 19 and "double" or nil
		aObj.optTables["Disabled Skins"].args[name] = {
			type = "toggle",
			name = name2,
			desc = aObj.L["Toggle the skinning of "]..name,
			width = width2,
		}
		name2, width2 = nil, nil

	end
	for addonName in pairs(self.addonsToSkin) do
		addDSOpt(addonName)
	end
	for addonName in pairs(self.libsToSkin) do
		addDSOpt(addonName, true)
	end
	for addonName in pairs(self.lodAddons) do
		addDSOpt(addonName, nil, true)
	end
	for addonName in pairs(self.otherAddons) do
		if addonName == "tekKonfig" then
			addDSOpt(addonName, true)
		else
			addDSOpt(addonName)
		end
	end

	-- add DB profile options
	self.optTables.Profiles = LibStub:GetLibrary("AceDBOptions-3.0"):GetOptionsTable(self.db)

	-- register the options tables and add them to the blizzard frame
	self.ACR = LibStub:GetLibrary("AceConfigRegistry-3.0", true)
	local ACD = LibStub:GetLibrary("AceConfigDialog-3.0", true)

	self.ACR:RegisterOptionsTable(aName, self.optTables.General, {aName, "skin"})
	self.optionsFrame = ACD:AddToBlizOptions(aName, aName)

	-- register the options, add them to the Blizzard Options
	-- build the table used by the chatCommand function
	-- option tables list
	local optNames = {
		"Backdrop", "Background", "Colours", "Gradient", "Modules", "NPC Frames", "Player Frames", "UI Frames", "Disabled Skins", "Profiles"
	}
	local optCheck, optTitle = {}
	for _, v in _G.ipairs(optNames) do
		optTitle = (" "):join(aName, v)
		self.ACR:RegisterOptionsTable(optTitle, self.optTables[v])
		self.optionsFrame[self.L[v]] = ACD:AddToBlizOptions(optTitle, self.L[v], aName)
		optCheck[v:lower()] = v
	end
	optNames, optTitle = nil, nil

	-- runs when the player clicks "Defaults"
	self.optionsFrame[self.L["Backdrop"]].default = function()
		db.BdDefault = dflts.BdDefault
		db.BdFile = dflts.BdFile
		db.BdTexture = dflts.BdTexture
		db.BdTileSize = dflts.BdTileSize
		db.BdEdgeFile = dflts.BdEdgeFile
		db.BdBorderTexture = dflts.BdBorderTexture
		db.BdEdgeSize = dflts.BdEdgeSize
		db.BdInset = dflts.BdInset
		-- refresh panel
		InterfaceOptionsFrame_OpenToCategory(self.optionsFrame[self.L["Backdrop"]])
		reskinIOFBackdrop()
	end
	self.optionsFrame[self.L["Background"]].default = function()
		db.BgUseTex = dflts.BgUseTex
		db.BgFile = dflts.BgFile
		db.BgTexture = dflts.BgTexture
		db.BgTile = dflts.BgTile
		-- refresh panel
		InterfaceOptionsFrame_OpenToCategory(self.optionsFrame[self.L["Background"]])
	end
	self.optionsFrame[self.L["Colours"]].default = function()
		db.ClassClrBd = dflts.ClassClrBd
		db.ClassClrBg = dflts.ClassClrBg
		db.ClassClrGr = dflts.ClassClrGr
		db.ClassClrTT = dflts.ClassClrTT
		db.TooltipBorder = dflts.TooltipBorder
		db.Backdrop = dflts.Backdrop
		db.BackdropBorder = dflts.BackdropBorder
		db.HeadText = dflts.HeadText
		db.BodyText = dflts.BodyText
		db.IgnoredText = dflts.IgnoredText
		db.GradientMin = dflts.GradientMin
		db.GradientMax = dflts.GradientMax
		if bggns then
			db.BagginsBBC = dflts.BagginsBBC
		end
		-- refresh panel
		InterfaceOptionsFrame_OpenToCategory(self.optionsFrame[self.L["Colours"]])
	end
	self.optionsFrame[self.L["Gradient"]].default = function()
		db.Gradient.enable = dflts.Gradient.enable
		db.Gradient.texture = dflts.Gradient.texture
		db.Gradient.invert = dflts.Gradient.invert
		db.Gradient.rotate = dflts.Gradient.rotate
		db.Gradient.char = dflts.Gradient.char
		db.Gradient.ui = dflts.Gradient.ui
		db.Gradient.npc = dflts.Gradient.npc
		db.Gradient.skinner = dflts.Gradient.skinner
		-- refresh panel
		InterfaceOptionsFrame_OpenToCategory(self.optionsFrame[self.L["Gradient"]])
	end

	-- Slash command handler
	local function chatCommand(input)

		if not input or input:trim() == "" then
			-- Open general panel if there are no parameters, do twice to overcome Blizzard bug
			InterfaceOptionsFrame_OpenToCategory(aObj.optionsFrame)
			InterfaceOptionsFrame_OpenToCategory(aObj.optionsFrame)
		elseif optCheck[input:lower()] then
			InterfaceOptionsFrame_OpenToCategory(aObj.optionsFrame[optCheck[input:lower()]])
			InterfaceOptionsFrame_OpenToCategory(aObj.optionsFrame[optCheck[input:lower()]])
		else
			LibStub:GetLibrary("AceConfigCmd-3.0"):HandleCommand(aName, aName, input)
		end

	end

	-- Register slash command handlers
	self:RegisterChatCommand(aName, chatCommand)
	self:RegisterChatCommand("skin", chatCommand)

	-- setup the DB object
	self.DBObj = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject(aName, {
		type = "launcher",
		icon = [[Interface\Icons\INV_Misc_Pelt_Wolf_01]],
		OnClick = function()
			-- do twice to overcome Blizzard bug
			InterfaceOptionsFrame_OpenToCategory(aObj.optionsFrame)
			InterfaceOptionsFrame_OpenToCategory(aObj.optionsFrame)
		end,
	})

	-- register the data object to the Icon library
	self.DBIcon:Register(aName, self.DBObj, db.MinimapIcon)

end
