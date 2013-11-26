local aName, aObj = ...
local _G = _G

-- Add locals to see if it speeds things up
local AceGUIWidgetLSMlists, InterfaceOptionsFrame_OpenToCategory, IsAddOnLoaded, LibStub, pairs = _G.AceGUIWidgetLSMlists,  _G.InterfaceOptionsFrame_OpenToCategory, _G.IsAddOnLoaded, _G.LibStub, _G.pairs

function aObj:Defaults()

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
		Delay                = {Init = 0.5, Addons = 0.5, LoDs = 0.5},
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
	-->>-- Colours
		ClassColours         = false,
		ClassClrsBg          = false,
		TooltipBorder        = {r = 0.5, g = 0.5, b = 0.5, a = 1},
		BackdropBorder       = {r = 0.5, g = 0.5, b = 0.5, a = 1},
		Backdrop             = {r = 0, g = 0, b = 0, a = 0.9},
		HeadText             = {r = 0.8, g = 0.8, b = 0.0},
		BodyText             = {r = 0.7, g = 0.7, b = 0.0},
		GradientMin          = {r = 0.1, g = 0.1, b = 0.1, a = 0},
		GradientMax          = {r = 0.25, g = 0.25, b = 0.25, a = 1},
	-->>-- Gradient
		Gradient             = {enable = true, invert = false, rotate = false, char = true, ui = true, npc = true, skinner = true, texture = "Blizzard ChatFrame Background"},
	-->>-- Modules
		-- populated below
	-->>-- NPC Frames
		DisableAllNPC        = false,
		AuctionUI            = true,
		BankFrame            = true,
		BarbershopUI         = true,
		BlackMarketUI        = true,
		GossipFrame          = true,
		GuildRegistrar       = true,
		ItemAlterationUI     = true,
		MerchantFrame        = true,
		Petition             = true,
		PetStableFrame       = true,
		QuestFrame           = true,
		ReforgingUI          = true,
		SideDressUpFrame     = true,
		Tabard               = true,
		TaxiFrame            = true,
		TrainerUI            = true,
		VoidStorageUI        = true,
	-->>-- Player Frames
		DisableAllP          = false,
		AchievementUI        = {skin = true, style = 2},
		ArchaeologyUI        = true,
		Buffs                = true,
		CastingBar           = {skin = true, glaze = true},
		CharacterFrames      = true,
		CompactFrames        = true,
		ContainerFrames      = {skin = true, fheight = 100},
		DressUpFrame         = true,
		EncounterJournal     = true,
		EquipmentFlyout      = true,
		FriendsFrame         = true,
		GhostFrame           = true,
		GuildControlUI       = true,
		GuildUI              = true,
		GuildInvite          = true,
		InspectUI            = true,
		ItemSocketingUI      = true,
		LookingForGuildUI    = true,
		LootFrames           = {skin = true, size = 1},
		LootHistory          = true,
		MirrorTimers         = {skin = true, glaze = true},
		OverrideActionBar    = true,
		PetJournal           = true,
		PVPFrame             = true,
		QuestLog             = true,
		RaidUI               = true,
		ReadyCheck           = true,
		RolePollPopup        = true,
		ScrollOfResurrection = true,
		SpellBookFrame       = true,
		SpellFlyout          = true,
		StackSplit           = true,
		TalentUI             = true,
		TradeFrame           = true,
		TradeSkillUI         = true,
		VehicleMenuBar       = true,
		WatchFrame           = {skin = false, popups = true},
	-->>-- UI Frames
		DisableAllUI         = false,
		AlertFrames          = true,
		AuthChallengeUI		 = false, -- N.B. cannot be skinned
		AutoComplete         = true,
		BattlefieldMm        = {skin = true, gloss = false},
		BNFrames             = true,
		Calendar             = true,
		ChallengesUI         = true or nil,
		ChatButtons          = true,
		ChatConfig           = true,
		ChatEditBox          = {skin = true, style = 3},
		ChatFrames           = false,
		ChatMenus            = true,
		ChatTabs             = false,
		ChatTabsFade         = true,
		CinematicFrame       = true,
		CoinPickup           = true,
		Colours              = true,
		CombatLogQBF         = false,
		DebugTools           = true,
		DestinyFrame         = true,
		GMChatUI             = true,
		GMSurveyUI           = true,
		GuildBankUI          = true,
		HelpFrame            = true,
		ItemText             = true,
		ItemUpgradeUI        = true,
		LevelUpDisplay       = true,
		LFDFrame             = true,
		LFGFrame             = true,
		LFRFrame             = true,
		MailFrame            = true,
		MainMenuBar          = {skin = true, glazesb = true, extraab=true},
		MenuFrames           = true, -- inc. MacroUI & BindingUI
		Minimap              = {skin = false, gloss = false},
		MinimapButtons       = {skin = false, style = false},
		MovePad              = true,
		MovieFrame           = true,
		MovieProgress        = _G.IsMacClient() and true or nil,
		Nameplates           = true,
		PetBattleUI          = true,
		PVEFrame             = true,
		RaidFrame            = true,
		ScriptErrors         = true,
		StaticPopups         = true,
		StoreUI				 = false, -- N.B. cannot be skinned
		TimeManager          = true,
		Tooltips             = {skin = true, style = 1, glazesb = true, border = 1},
		Tutorial             = true,
		WorldMap             = {skin = true, size = 1},
		WorldState           = true,
	-->>-- Disabled Skins
		DisabledSkins        = {},
	-->-- Profiles
		-- populated below

	}}

	self.db = LibStub("AceDB-3.0"):New(aName .. "DB", defaults, "Default")

end

local DBIcon = LibStub("LibDBIcon-1.0")
function aObj:Options()

	local db = self.db.profile
	local dflts = self.db.defaults.profile

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
						if value then DBIcon:Show(aName) else DBIcon:Hide(aName) end
					end,
					hidden = function() return not DBIcon end,
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
						LoDs = {
							type = "range",
							order = 3,
							name = self.L["LoD Addons Delay"],
							desc = self.L["Set the Delay before Skinning Load on Demand Frames"],
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
								self:checkAndRun("updateSBTexture")
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
								self:checkAndRun("updateSBTexture")
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
				if info[#info] ~= "BgUseTex" then db.BgUseTex = true end
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
			},
		},

		Colours = {
			type = "group",
			name = self.L["Default Colours"],
			get = function(info)
				if info[#info] == "ClassColours"
				or info[#info] == "ClassClrsBg"
				then
					return db[info[#info]]
				else
					local c = db[info[#info]]
					return c.r, c.g, c.b, c.a
				end
			end,
			set = function(info, r, g, b, a)
				if info[#info] == "ClassColours" then
					db[info[#info]] = r
					if r then
						db.TooltipBorder.r = _G.RAID_CLASS_COLORS[self.uCls].r
						db.TooltipBorder.g = _G.RAID_CLASS_COLORS[self.uCls].g
						db.TooltipBorder.b = _G.RAID_CLASS_COLORS[self.uCls].b
						db.BackdropBorder.r = _G.RAID_CLASS_COLORS[self.uCls].r
						db.BackdropBorder.g = _G.RAID_CLASS_COLORS[self.uCls].g
						db.BackdropBorder.b = _G.RAID_CLASS_COLORS[self.uCls].b
					else
						db.TooltipBorder.r = dflts.TooltipBorder.r
						db.TooltipBorder.g = dflts.TooltipBorder.g
						db.TooltipBorder.b = dflts.TooltipBorder.b
						db.BackdropBorder.r = dflts.BackdropBorder.r
						db.BackdropBorder.g = dflts.BackdropBorder.g
						db.BackdropBorder.b = dflts.BackdropBorder.b
					end
				elseif info[#info] == "ClassClrsBg" then
					db[info[#info]] = r
					if r then
						db.Backdrop.r = _G.RAID_CLASS_COLORS[self.uCls].r
						db.Backdrop.g = _G.RAID_CLASS_COLORS[self.uCls].g
						db.Backdrop.b = _G.RAID_CLASS_COLORS[self.uCls].b
					else
						db.Backdrop.r = dflts.Backdrop.r
						db.Backdrop.g = dflts.Backdrop.g
						db.Backdrop.b = dflts.Backdrop.b
					end
				else
					local c = db[info[#info]]
					c.r, c.g, c.b, c.a = r, g, b, a
				end
			end,
			args = {
				ClassColours = {
					type = "toggle",
					order = 1,
					width = "double",
					name = self.L["Class Coloured Borders"],
					desc = self.L["Use Class Colours for Borders"],
				},
				ClassClrsBg = {
					type = "toggle",
					order = 2,
					width = "double",
					name = self.L["Class Coloured Background"],
					desc = self.L["Use Class Colours for Background"],
				},
				TooltipBorder = {
					type = "color",
					order = 3,
					width = "double",
					name = self.L["Tooltip Border Colors"],
					desc = self.L["Set Tooltip Border Colors"],
					hasAlpha = true,
				},
				Backdrop = {
					type = "color",
					order = 5,
					width = "double",
					name = self.L["Backdrop Colors"],
					desc = self.L["Set Backdrop Colors"],
					hasAlpha = true,
				},
				BackdropBorder = {
					type = "color",
					order = 4,
					width = "double",
					name = self.L["Border Colors"],
					desc = self.L["Set Backdrop Border Colors"],
					hasAlpha = true,
				},
				HeadText = {
					type = "color",
					order = 5,
					width = "double",
					name = self.L["Text Heading Colors"],
					desc = self.L["Set Text Heading Colors"],
				},
				BodyText = {
					type = "color",
					order = 6,
					width = "double",
					name = self.L["Text Body Colors"],
					desc = self.L["Set Text Body Colors"],
				},
				GradientMin = {
					type = "color",
					order = 7,
					width = "double",
					name = self.L["Gradient Minimum Colors"],
					desc = self.L["Set Gradient Minimum Colors"],
					hasAlpha = true,
				},
				GradientMax = {
					type = "color",
					order = 8,
					width = "double",
					name = self.L["Gradient Maximum Colors"],
					desc = self.L["Set Gradient Maximum Colors"],
					hasAlpha = true,
				},
				BagginsBBC = IsAddOnLoaded("Baggins") and self.Baggins and {
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
				local uiOpt = info[#info]:match("UI" , -2)
				-- handle Blizzard UI LoD Addons
				if uiOpt then
					if IsAddOnLoaded("Blizzard_" .. info[#info]) then
						self:checkAndRun(info[#info])
					end
				else self:checkAndRun(info[#info]) end
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
					set = function(info, value)
						db[info[#info]] = value
					end,
				},
				head2 = {
					order = 3,
					type = "header",
					name = self.L["or choose which frames to skin"],
				},
				AuctionUI = {
					type = "toggle",
					name = self.L["Auction Frame"],
					desc = self.L["Toggle the skin of the Auction Frame"],
				},
				BankFrame = {
					type = "toggle",
					name = self.L["Bank Frame"],
					desc = self.L["Toggle the skin of the Bank Frame"],
				},
				BarbershopUI = {
					type = "toggle",
					name = self.L["Barbershop Frame"],
					desc = self.L["Toggle the skin of the Barbershop Frame"],
				},
				BlackMarketUI = {
					type = "toggle",
					width = "double",
					name = self.L["Black Market Auction Frame"],
					desc = self.L["Toggle the skin of the Black Market Auction Frame"],
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
				ItemAlterationUI = {
					type = "toggle",
					name = self.L["Item Alteration Frame"],
					desc = self.L["Toggle the skin of the Item Alteration Frame"],
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
				QuestFrame = {
					type = "toggle",
					name = self.L["Quest Frame"],
					desc = self.L["Toggle the skin of the Quest Frame"],
				},
				ReforgingUI = {
					type = "toggle",
					name = self.L["Reforging Frame"],
					desc = self.L["Toggle the skin of the Reforging Frame"],
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
					name = self.L["Trainer Frame"],
					desc = self.L["Toggle the skin of the Trainer Frame"],
					type = "toggle",
				},
				VoidStorageUI = {
					type = "toggle",
					name = self.L["Void Storage Frame"],
					desc = self.L["Toggle the skin of the Void Storage Frame"],
				},
			},
		},

		["Player Frames"] = {
			type = "group",
			name = self.L["Player Frames"],
			get = function(info) return db[info[#info]] end,
			set = function(info, value)
				db[info[#info]] = value
				-- handle Blizzard UI LoD Addons
				local uiOpt = info[#info]:match("UI" , -2)
				if uiOpt then
					if IsAddOnLoaded("Blizzard_" .. info[#info]) then
						self:checkAndRun(info[#info])
					end
				else self:checkAndRun(info[#info]) end
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
					set = function(info, value)
						db[info[#info]] = value
					end,
				},
				head2 = {
					order = 3,
					type = "header",
					name = self.L["or choose which frames to skin"],
				},
				AchievementUI = {
					type = "group",
					order = -2,
					inline = true,
					name = self.L["Achievement UI"],
					get = function(info) return db.AchievementUI[info[#info]] end,
					set = function(info, value)
						db.AchievementUI[info[#info]] = value
						if IsAddOnLoaded("Blizzard_AchievementUI") then	self:checkAndRun("AchievementUI") end
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
					name = self.L["Archaeology Frame"],
					desc = self.L["Toggle the skin of the Archaeology Frame"],
				},
				Buffs = {
					type = "toggle",
					name = self.L["Buffs Buttons"],
					desc = self.L["Toggle the skin of the Buffs Buttons"],
				},
				CastingBar = {
					type = "group",
					inline = true,
					order = -10,
					name = self.L["Casting Bar Frame"],
					get = function(info) return db.CastingBar[info[#info]] end,
					set = function(info, value)
						db.CastingBar[info[#info]] = value
						self:checkAndRun("CastingBar")
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
						self:checkAndRun("ContainerFrames")
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
					name = self.L["Dungeon Journal"],
					desc = self.L["Toggle the skin of the Dungeon Journal"],
				},
				EquipmentFlyout = {
					type = "toggle",
					name = self.L["Equipment Flyout"],
					desc = self.L["Toggle the skin of the Equipment Flyout Frame"],
				},
				FriendsFrame = {
					type = "toggle",
					name = self.L["Social Frame"],
					desc = self.L["Toggle the skin of the Social Frame"],
				},
				GhostFrame = {
					type = "toggle",
					name = self.L["Ghost Frame"],
					desc = self.L["Toggle the skin of the Ghost Frame"],
				},
				GuildControlUI = {
					type = "toggle",
					name = self.L["Guild Control Frame"],
					desc = self.L["Toggle the skin of the Guild Control Frame"],
				},
				GuildUI = {
					type = "toggle",
					name = self.L["Guild Frame"],
					desc = self.L["Toggle the skin of the Guild Frame"],
				},
				GuildInvite = {
					type = "toggle",
					name = self.L["Guild Invite Frame"],
					desc = self.L["Toggle the skin of the Guild Invite Frame"],
				},
				InspectUI = {
					type = "toggle",
					name = self.L["Inspect Frame"],
					desc = self.L["Toggle the skin of the Inspect Frame"],
				},
				ItemSocketingUI = {
					type = "toggle",
					name = self.L["Item Socketing Frame"],
					desc = self.L["Toggle the skin of the Item Socketing Frame"],
				},
				LookingForGuildUI = {
					type = "toggle",
					width = "double",
					name = self.L["Looking for Guild Frame"],
					desc = self.L["Toggle the skin of the Looking for Guild Frame"],
				},
				LootFrames = {
					type = "group",
					inline = true,
					order = -1,
					name = self.L["Loot Frames"],
					get = function(info) return db.LootFrames[info[#info]] end,
					set = function(info, value)
						db.LootFrames[info[#info]] = value
						self:checkAndRun("LootFrames")
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
					order = -2,
					name = self.L["Timer Frames"],
					get = function(info) return db.MirrorTimers[info[#info]] end,
					set = function(info, value)
						db.MirrorTimers[info[#info]] = value
						self:checkAndRun("MirrorTimers")
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
				OverrideActionBar = {
					type = "toggle",
					name = self.L["Override Action Bar"],
					desc = self.L["Toggle the skin of the Override Action Bar"],
				},
				PetJournal = {
					type = "toggle",
					width = "double",
					name = self.L["Mounts and Pets Frame"],
					desc = self.L["Toggle the skin of the Mounts and Pets Frame"],
					set = function(info, value)
						db[info[#info]] = value
						if IsAddOnLoaded("Blizzard_PetJournal") then self:checkAndRun("PetJournal") end
					end,
				},
				PVPFrame = {
					type = "toggle",
					name = self.L["PVP Frame"],
					desc = self.L["Toggle the skin of the PVP Frame"],
				},
				QuestLog = {
					type = "toggle",
					name = self.L["Quest Log Frame"],
					desc = self.L["Toggle the skin of the Quest Log Frame"],
				},
				RaidUI = {
					type = "toggle",
					name = self.L["Raid UI Frames"],
					desc = self.L["Toggle the skin of the Raid UI Frames"],
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
				SpellFlyout = {
					type = "toggle",
					name = self.L["SpellFlyouts"],
					desc = self.L["Toggle the skin of the SpellFlyouts"],
				},
				StackSplit = {
					type = "toggle",
					name = self.L["Stack Split Frame"],
					desc = self.L["Toggle the skin of the Stack Split Frame"],
				},
				TalentUI = {
					type = "toggle",
					name = self.L["Talent Frame"],
					desc = self.L["Toggle the skin of the Talent Frame"],
				},
				TradeFrame = {
					type = "toggle",
					name = self.L["Trade Frame"],
					desc = self.L["Toggle the skin of the Trade Frame"],
				},
				TradeSkillUI = {
					type = "toggle",
					name = self.L["Trade Skill Frame"],
					desc = self.L["Toggle the skin of the Trade Skill Frame"],
				},
				WatchFrame = {
					type = "group",
					order = -1,
					inline = true,
					name = self.L["Tracker Frame"],
					get = function(info) return db.WatchFrame[info[#info]] end,
					set = function(info, value) db.WatchFrame[info[#info]] = value end,
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
			},
		},

		["UI Frames"] = {
			type = "group",
			name = self.L["UI Frames"],
			get = function(info) return db[info[#info]] end,
			set = function(info, value)
				db[info[#info]] = value
				local uiOpt = info[#info]:match("UI" , -2)
				if info[#info] == "Colours" then self:checkAndRun("ColorPicker")
				elseif info[#info] == "CombatLogQBF" then return
				-- handle Blizzard UI LoD Addons
				elseif uiOpt then
					if IsAddOnLoaded("Blizzard_" .. info[#info]) then
						self:checkAndRun(info[#info])
					end
				else self:checkAndRun(info[#info]) end
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
					set = function(info, value)
						db[info[#info]] = value
					end,
				},
				head2 = {
					order = 3,
					type = "header",
					name = self.L["or choose which frames to skin"],
				},
				AlertFrames = {
					type = "toggle",
					name = self.L["Alert Frames"],
					desc = self.L["Toggle the skin of the Alert Frames"],
				},
				AuthChallengeUI = {
					type = "toggle",
					name = self.L["AuthChallenge Frame"],
					desc = self.L["Toggle the skin of the AuthChallenge Frame"],
				},
				AutoComplete = {
					type = "toggle",
					name = self.L["Auto Complete"],
					desc = self.L["Toggle the skin of the Auto Complete Frame"],
				},
				BattlefieldMm = {
					type = "group",
					inline = true,
					order = -1,
					name = self.L["Battlefield Minimap Options"],
					get = function(info) return db.BattlefieldMm[info[#info]] end,
					set = function(info, value)
						db.BattlefieldMm[info[#info]] = value
						if info[#info] == "skin" then
							if _G.IsAddOnLoaded("Blizzard_BattlefieldMinimap") then
								self:checkAndRun("BattlefieldMinimap")
							end
						elseif info[#info] == "gloss" and _G.BattlefieldMinimap.sf then
							if value then
								_G.RaiseFrameLevel(_G.BattlefieldMinimap.sf)
							else
								_G.LowerFrameLevel(_G.BattlefieldMinimap.sf)
							end
						end
					end,
					args = {
						skin = {
							type = "toggle",
							name = self.L["Skin Frame"],
							desc = self.L["Toggle the skin of the Battlefield Minimap Frame"],
							order = 1,
						},
						gloss = {
							type = "toggle",
							name = self.L["Gloss Effect"],
							desc = self.L["Toggle the Gloss Effect for the Battlefield Minimap"],
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
					name = self.L["Challenges Frame"],
					desc = self.L["Toggle the skin of the Challenges Frame"],
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
						self:checkAndRun("ChatEditBox")
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
				CoinPickup = {
					type = "toggle",
					name = self.L["Coin Pickup Frame"],
					desc = self.L["Toggle the skin of the Coin Pickup Frame"],
				},
				Colours = {
					type = "toggle",
					name = self.L["Color Picker Frame"],
					desc = self.L["Toggle the skin of the Color Picker Frame"],
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
				GMChatUI = {
					type = "toggle",
					name = self.L["GM Chat Frame"],
					desc = self.L["Toggle the skin of the GM Chat Frame"],
				},
				GuildBankUI = {
					type = "toggle",
					name = self.L["Guild Bank Frame"],
					desc = self.L["Toggle the skin of the Guild Bank Frame"],
				},
				helpframes = {
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
							name = self.L["GM Survey Frame"],
							desc = self.L["Toggle the skin of the GM Survey Frame"],
						},
					},
				},
				ItemText = {
					type = "toggle",
					name = self.L["Item Text Frame"],
					desc = self.L["Toggle the skin of the Item Text Frame"],
				},
				ItemUpgradeUI = {
					type = "toggle",
					name = self.L["Item Upgrade Frame"],
					desc = self.L["Toggle the skin of the Item Upgrade Frame"],
				},
				LevelUpDisplay = {
					type = "toggle",
					name = self.L["Level Up Display"],
					desc = self.L["Toggle the skin of the Level Up Display"],
				},
				LFDFrame = {
					type = "toggle",
					name = self.L["LFD Frame"],
					desc = self.L["Toggle the skin of the LFD Frame"],
				},
				LFRFrame = {
					type = "toggle",
					name = self.L["LFR Frame"],
					desc = self.L["Toggle the skin of the LFR Frame"],
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
						self:checkAndRun("MainMenuBar")
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
						if info[#info] == "skin" then self:checkAndRun("Minimap")
						elseif info[#info] == "gloss" and _G.Minimap.sf then
							if value then
								_G.RaiseFrameLevel(_G.Minimap.sf)
							else
								_G.LowerFrameLevel(_G.Minimap.sf)
							end
						elseif info[#info] == "btns" then self:checkAndRun("MinimapButtons")
						elseif info[#info] == "style" then
							db.Minimap.btns = true
							self:checkAndRun("MinimapButtons")
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
						if info[#info] == "skin" then self:checkAndRun("MinimapButtons")
						elseif info[#info] == "style" then
							db.MinimapButtons.skin = true
							self:checkAndRun("MinimapButtons")
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
				MovieProgress = _G.IsMacClient() and {
					type = "toggle",
					name = self.L["Movie Progress"],
					desc = self.L["Toggle the skinning of Movie Progress"],
				} or nil,
				Nameplates = {
					type = "toggle",
					name = self.L["Nameplates"],
					desc = self.L["Toggle the skin of the Nameplates"],
				},
				PetBattleUI = {
					type = "toggle",
					name = self.L["Pet Battle Frame"],
					desc = self.L["Toggle the skin of the Pet Battle Frame"],
				},
				PVEFrame = {
					type = "toggle",
					name = self.L["PVE Frame"],
					desc = self.L["Toggle the skin of the PVE Frame"],
				},
				RaidFrame = {
					type = "toggle",
					name = self.L["Raid Frame"],
					desc = self.L["Toggle the skin of the Raid Frame"],
				},
				ScriptErrors = {
					type = "toggle",
					name = self.L["Script Errors Frame"],
					desc = self.L["Toggle the skin of the Script Errors Frame"],
				},
				StaticPopups = {
					type = "toggle",
					name = self.L["Static Popups"],
					desc = self.L["Toggle the skin of Static Popups"],
				},
				StoreUI = {
					type = "toggle",
					name = self.L["Store Frame"],
					desc = self.L["Toggle the skin of the Store Frame"],
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
				WorldMap = {
					type = "group",
					inline = true,
					order = -1,
					name = self.L["World Map Frame"],
					get = function(info) return db.WorldMap[info[#info]] end,
					set = function(info, value)
						db.WorldMap[info[#info]] = value
						self:checkAndRun("WorldMap")
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
				WorldState = {
					type = "toggle",
					name = self.L["Battle Score Frame"],
					desc = self.L["Toggle the skin of the Battle Score Frame"],
				},
			},
		},

		["Disabled Skins"] = {
			type = "group",
			name = self.L["Disable Addon Skins"],
			get = function(info) return db.DisabledSkins[info[#info]] end,
			set = function(info, value) db.DisabledSkins[info[#info]] = value end,
			args = {
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
	local function addDSOpt(name, lib)

		aObj.optTables["Disabled Skins"].args[name] = {
			type = "toggle",
			name = name..(lib and " (Lib)" or ""),
			desc = self.L["Toggle the skinning of "]..name,
			width = name:len() > 20 and "double" or nil,
		}

	end
	for addonName in pairs(self.addonsToSkin) do
		addDSOpt(addonName)
	end
	for _, addonName in pairs(self.libsToSkin) do
		addDSOpt(addonName, true)
	end
	for addonName in pairs(self.lodAddons) do
		addDSOpt(addonName)
	end

	-- add DB profile options
	self.optTables.Profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)

	-- option tables list
	local optNames = {
		"Backdrop", "Background", "Colours", "Gradient", "Modules", "NPC Frames", "Player Frames", "UI Frames", "Disabled Skins", "Profiles"
	}
	-- register the options tables and add them to the blizzard frame
	self.ACR = LibStub("AceConfigRegistry-3.0")
	self.ACD = LibStub("AceConfigDialog-3.0")

	self.ACR:RegisterOptionsTable(aName, self.optTables.General, {aName, "skin"})
	self.optionsFrame = self.ACD:AddToBlizOptions(aName, aName)

	-- register the options, add them to the Blizzard Options
	-- build the table used by the chatCommand function
	local optCheck = {}
	for _, v in _G.ipairs(optNames) do
		local optTitle = (" "):join(aName, v)
		self.ACR:RegisterOptionsTable(optTitle, self.optTables[v])
		self.optionsFrame[self.L[v]] = self.ACD:AddToBlizOptions(optTitle, self.L[v], aName)
		optCheck[v:lower()] = v
	end

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
		db.ClassColours = dflts.ClassColours
		db.TooltipBorder = dflts.TooltipBorder
		db.BackdropBorder = dflts.BackdropBorder
		db.Backdrop = dflts.Backdrop
		db.HeadText = dflts.HeadText
		db.BodyText = dflts.BodyText
		db.GradientMin = dflts.GradientMin
		db.GradientMax = dflts.GradientMax
		-- refresh panel
		InterfaceOptionsFrame_OpenToCategory(self.optionsFrame[self.L["Colours"]])
	end
	self.optionsFrame[self.L["Gradient"]].default = function()
		db.Gradient.enable = dflts.Gradient.enable
		db.Gradient.invert = dflts.Gradient.invert
		db.Gradient.rotate = dflts.Gradient.rotate
		db.Gradient.char = dflts.Gradient.char
		db.Gradient.ui = dflts.Gradient.ui
		db.Gradient.npc = dflts.Gradient.npc
		db.Gradient.skinner = dflts.Gradient.skinner
		db.Gradient.texture = dflts.Gradient.texture
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
			LibStub("AceConfigCmd-3.0"):HandleCommand(aName, aName, input)
		end
	end

	-- Register slash command handlers
	self:RegisterChatCommand(aName, chatCommand)
	self:RegisterChatCommand("skin", chatCommand)

	-- setup the DB object
	self.DBObj = LibStub("LibDataBroker-1.1"):NewDataObject(aName, {
		type = "launcher",
		icon = [[Interface\Icons\INV_Misc_Pelt_Wolf_01]],
		OnClick = function()
			-- do twice to overcome Blizzard bug
			InterfaceOptionsFrame_OpenToCategory(aObj.optionsFrame)
			InterfaceOptionsFrame_OpenToCategory(aObj.optionsFrame)
		end,
	})

	-- register the data object to the Icon library
	DBIcon:Register(aName, self.DBObj, db.MinimapIcon)

end
