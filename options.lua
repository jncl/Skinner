--check to see if running on PTR
local IsPTR = FeedbackUI and true or false

function Skinner:Defaults()

	local defaults = { profile = {
		-- Colours
		TooltipBorder	= {r = 0.5, g = 0.5, b = 0.5, a = 1},
		BackdropBorder	= {r = 0.5, g = 0.5, b = 0.5, a = 1},
		Backdrop		= {r = 0, g = 0, b = 0, a = 0.9},
		HeadText		= {r = 0.8, g = 0.8, b = 0.0},
		BodyText		= {r = 0.7, g = 0.7, b = 0.0},
		GradientMin		= {r = 0.1, g = 0.1, b = 0.1, a = 0},
		GradientMax		= {r = 0.25, g = 0.25, b = 0.25, a = 1},
		-- Backdrop Settings
		BdDefault		= true,
		BdFile			= "None",
		BdTexture		= "Blizzard ChatFrame Background",
		BdTileSize		= 16,
		BdEdgeFile		= "None",
		BdBorderTexture = "Blizzard Tooltip",
		BdEdgeSize		= 16,
		BdInset			= 4,
		-- Other
		TexturedTab		= false,
		TexturedDD		= false,
		Warnings		= true,
		Errors			= true,
		Gradient		= {enable = true, invert = false, rotate = false, char = true, ui = true, npc = true, skinner = true, texture = "Blizzard ChatFrame Background"},
		FadeHeight		= {enable = false, value = 500, force = false},
		Delay			= {Init = 0.5, Addons = 0.5, LoDs = 0.5},
		ViewPort		= {top = 64, bottom = 64, YResolution = 1050, YScaling = 768/1050, left = 128, right = 128, XResolution = 768, XScaling = 768/1050, shown = false, overlay = false, r = 0, g = 0, b = 0, a = 1},
		TopFrame		= {height = 64, width = 1920, shown = false, fheight = 50, xyOff = true, borderOff = false, alpha = 0.9, invert = false, rotate = false},
		MiddleFrame		= {fheight = 50, borderOff = false, lock = false, r = 0, g = 0, b = 0, a = 0.9},
		MiddleFrame1	= {height = 64, width = 64, shown = false, xOfs = 0, yOfs = 300, flevel = 0, fstrata = "BACKGROUND"},
		MiddleFrame2	= {height = 64, width = 64, shown = false, xOfs = 0, yOfs = 0, flevel = 0, fstrata = "BACKGROUND"},
		MiddleFrame3	= {height = 64, width = 64, shown = false, xOfs = 0, yOfs = 0, flevel = 0, fstrata = "BACKGROUND"},
		MiddleFrame4	= {height = 64, width = 64, shown = false, xOfs = 0, yOfs = 0, flevel = 0, fstrata = "BACKGROUND"},
		MiddleFrame5	= {height = 64, width = 64, shown = false, xOfs = 0, yOfs = 0, flevel = 0, fstrata = "BACKGROUND"},
		MiddleFrame6	= {height = 64, width = 64, shown = false, xOfs = 0, yOfs = 0, flevel = 0, fstrata = "BACKGROUND"},
		MiddleFrame7	= {height = 64, width = 64, shown = false, xOfs = 0, yOfs = 0, flevel = 0, fstrata = "BACKGROUND"},
		MiddleFrame8	= {height = 64, width = 64, shown = false, xOfs = 0, yOfs = 0, flevel = 0, fstrata = "BACKGROUND"},
		MiddleFrame9	= {height = 64, width = 64, shown = false, xOfs = 0, yOfs = 0, flevel = 0, fstrata = "BACKGROUND"},
		BottomFrame		= {height = 200, width = 1920, shown = false, fheight = 50, xyOff = true, borderOff = false, alpha = 0.9, invert = false, rotate = false},
		StatusBar		= {texture = "Blizzard", r = 0, g = 0.5, b = 0.5, a = 0.5},
		-- Character Frames
		CharacterFrames = true,
		PVPFrame  		= true,
		PetStableFrame  = true,
		SpellBookFrame  = true,
		TalentUI		= true,
		DressUpFrame    = true,
		FriendsFrame    = true,
		TradeSkillUI	= true,
		TradeFrame      = true,
		QuestLog        = {skin = true, size = 1},
		RaidUI          = true,
		ReadyCheck      = true,
		Buffs           = true,
		AchieveFrame    = true,
		AchieveAlert    = true,
		AchieveWatch    = true,
		-- UI Frames
		Tooltips        = {skin = true, style = 1, glazesb = true, border = 1},
		MirrorTimers    = {skin = true, glaze = true},
		CastingBar      = {skin = true, glaze = true},
		StaticPopups    = true,
		ChatMenus       = true,
		ChatConfig      = true,
		ChatTabs        = false,
		ChatFrames      = false,
		CombatLogQBF    = false,
		ChatEditBox     = {skin = true, style = 1},
		LootFrame       = true,
		GroupLoot       = {skin = true, size = 1},
		ContainerFrames = {skin = true, fheight = 100},
		StackSplit      = true,
		ItemText        = true,
		Colours         = true,
		WorldMap        = true,
		HelpFrame       = true,
		KnowledgeBase   = true,
		InspectUI		= true,
		BattleScore     = true,
		BattlefieldMm   = true,
		ScriptErrors    = true,
		Tutorial        = true,
		DropDowns       = true,
		MinimapButtons  = false,
		MinimapGloss    = false,
		MovieProgress   = IsMacClient() and true or nil,
		MenuFrames      = true,
		BankFrame       = true,
		MailFrame       = true,
		AuctionUI	    = true,
		MainMenuBar     = {skin = true, glazesb = true},
		CoinPickup      = true,
		GMSurveyUI      = true,
		LFGFrame        = true,
		ItemSocketingUI = true,
		GuildBankUI     = true,
		Nameplates      = true,
		TimeManager     = true,
		Calendar        = true,
		Feedback        = IsPTR and true or nil,
		-- NPC Frames
		MerchantFrames  = true,
		GossipFrame     = true,
		TrainerUI	    = true,
		TaxiFrame       = true,
		QuestFrame      = true,
		Battlefields    = true,
		ArenaFrame      = true,
		ArenaRegistrar  = true,
		GuildRegistrar  = true,
		Petition        = true,
		Tabard          = true,
		BarbershopUI	= true,
		-- Others
		TrackerFrame    = false,
		-- LDB icon
		MinimapIcon		= {hide = false, minimapPos = 210, radius = 90},
		
	}}

	self.db = LibStub("AceDB-3.0"):New("SkinnerDB", defaults, "Default")

end

local db
local aName = "Skinner"
local ldb = LibStub("LibDataBroker-1.1")
local icon = LibStub("LibDBIcon-1.0")

function Skinner:Options()

	db = self.db.profile

	local optTables = {

		General = {	
	    	name = aName,
			type = "group",
			get = function(info) return db[info[#info]] end,
			set = function(info, value) db[info[#info]] = value end,
			args = {
				desc = {
					order = 1,
					type = "description",
					name = self.L["UI Enhancement"] .." - "..GetAddOnMetadata("Skinner", "Version").. "\n",
				},
				longdesc = {
					order = 2,
					type = "description",
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
						if value then icon:Show("Skinner") else icon:Hide("Skinner") end
					end,
					hidden = function() return not icon end,
				},
				DropDowns = {
					type = "toggle",
					order = 6,
					name = self.L["DropDowns"],
					desc = self.L["Toggle the skin of the DropDowns"],
				},
				TexturedDD = {
					type = "toggle",
					order = 7,
					name = self.L["Textured DropDown"],
					desc = self.L["Toggle the Texture of the DropDowns"],
				},
				TexturedTab = {
					type = "toggle",
					order = 8,
					name = self.L["Textured Tab"],
					desc = self.L["Toggle the Texture of the Tabs"],
				},
				TrackerFrame = {
					type = "toggle",
					order = 9,
					name = self.L["Skin Tracker Frame"],
					desc = self.L["Toggle the skin of the Tracker Frame"],
				},
				Delay = {
					type = "group",
					order = 10,
					inline = true,
					name = self.L["Skinning Delays"],
					desc = self.L["Change the Skinning Delays settings"],
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
					order = 11,
					inline = true,
					name = self.L["Fade Height"],
					desc = self.L["Change the Fade Height settings"],
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
					order = 12,
					inline = true,
					name = self.L["StatusBar"],
					desc = self.L["Change the StatusBar settings"],
					args = {
						texture = {
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
						},
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
			desc = self.L["Change the default backdrop settings"],
			get = function(info) return db[info[#info]] end,
			set = function(info, value)
				db[info[#info]] = value == "" and "None" or value
				if not info[#info] == "BdDefault" then db.BdDefault = false end
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
				BdTexture = {
					type = "select",
					order = 3,
					width = "double",
					name = self.L["Backdrop Texture"],
					desc = self.L["Choose the Texture for the Backdrop"],
					dialogControl = "LSM30_Background",
					values = AceGUIWidgetLSMlists.background,
				},
				BdTileSize = {
					type = "range",
					order = 4,
					name = self.L["Backdrop TileSize"],
					desc = self.L["Set Backdrop TileSize"],
					min = 0, max = 512, step = 8,
				},
				BdEdgeFile = {
					type = "input",
					order = 5,
					width = "full",
					name = self.L["Border Texture File"],
					desc = self.L["Set Border Texture Filename"],
				},
				BdBorderTexture = {
					type = "select",
					order = 6,
					width = "double",
					name = self.L["Border Texture"],
					desc = self.L["Choose the Texture for the Border"],
					dialogControl = 'LSM30_Border',
					values = AceGUIWidgetLSMlists.border,
				},
				BdEdgeSize = {
					type = "range",
					order = 7,
					name = self.L["Border Width"],
					desc = self.L["Set Border Width"],
					min = 0, max = 32, step = 8,
				},
				BdInset = {
					type = "range",
					order = 8,
					name = self.L["Border Inset"],
					desc = self.L["Set Border Inset"],
					min = 2, max = 8, step = 2,
				},
			},
		},

		Colours = {
			type = "group",
			name = self.L["Default Colours"],
			desc = self.L["Change the default colour settings"],
			get = function(info)
				local c = db[info[#info]]
				return c.r, c.g, c.b, c.a
			end,
			set = function(info, r, g, b, a)
				local c = db[info[#info]]
				c.r, c.g, c.b, c.a = r, g, b, a
			end,
			args = {
				TooltipBorder = {
					type = "color",
					order = 1,
					width = "double",
					name = self.L["Tooltip Border Colors"],
					desc = self.L["Set Tooltip Border Colors"],
					hasAlpha = true,
				},
				Backdrop = {
					type = "color",
					order = 2,
					width = "double",
					name = self.L["Backdrop Colors"],
					desc = self.L["Set Backdrop Colors"],
					hasAlpha = true,
				},
				BackdropBorder = {
					type = "color",
					order = 3,
					width = "double",
					name = self.L["Border Colors"],
					desc = self.L["Set Backdrop Border Colors"],
					hasAlpha = true,
				},
				HeadText = {
					type = "color",
					order = 4,
					width = "double",
					name = self.L["Text Heading Colors"],
					desc = self.L["Set Text Heading Colors"],
				},
				BodyText = {
					type = "color",
					order = 5,
					width = "double",
					name = self.L["Text Body Colors"],
					desc = self.L["Set Text Body Colors"],
				},
				GradientMin = {
					type = "color",
					order = 6,
					width = "double",
					name = self.L["Gradient Minimum Colors"],
					desc = self.L["Set Gradient Minimum Colors"],
					hasAlpha = true,
				},
				GradientMax = {
					type = "color",
					order = 7,
					width = "double",
					name = self.L["Gradient Maximum Colors"],
					desc = self.L["Set Gradient Maximum Colors"],
					hasAlpha = true,
				},
			},
		},

		Gradient = {
			type = "group",
			name = self.L["Gradient"],
			desc = self.L["Change the Gradient Effect settings"],
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
				texture = {
					type = "select",
					order = 2,
					width = "double",
					name = self.L["Gradient Texture"],
					desc = self.L["Choose the Texture for the Gradient"],
					dialogControl = "LSM30_Background",
					values = AceGUIWidgetLSMlists.background,
				},
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

		["VP/TMBFrames"] = {
			type = "group",
			childGroups = "tab",
			args = {
				desc = {
					order = 1,
					type = "description",
					name = self.L["ViewPort & TMB Frames"] .. "\n",
				},
				longdesc = {
					order = 2,
					type = "description",
					name = self.L["Change the ViewPort & TMB Frames settings"] .. "\n",
				},
				ViewPort = {
					type = "group",
					order = 1,
					name = self.L["View Port"],
					desc = self.L["Change the ViewPort settings"],
					get = function(info) return db.ViewPort[info[#info]] end,
					set = function(info, value)
						db.ViewPort[info[#info]] = value
						if info[#info] == "shown" then
							if self.initialized.ViewPort then
								self:checkAndRun("ViewPort_reset")
							else
								self:checkAndRun("ViewPort")
							end
						else
							self:checkAndRun("ViewPort_"..info[#info])
						end
					end,
					args = {
						shown = {
							type = "toggle",
							order = 1,
							width = "full",
							name = self.L["ViewPort Show"],
							desc = self.L["Toggle the ViewPort"],
						},
						top = {
							type = "range",
							order = 4,
							name = self.L["VP Top"],
							desc = self.L["Change Height of the Top Band"],
							min = 0, max = 256, step = 1,
						},
						bottom = {
							type = "range",
							order = 5,
							name = self.L["VP Bottom"],
							desc = self.L["Change Height of the Bottom Band"],
							min = 0, max = 256, step = 1,
						},
						left = {
							type = "range",
							order = 6,
							name = self.L["VP Left"],
							desc = self.L["Change Width of the Left Band"],
							min = 0, max = 1800, step = 1,
						},
						right = {
							type = "range",
							order = 7,
							name = self.L["VP Right"],
							desc = self.L["Change Width of the Right Band"],
							min = 0, max = 1800, step = 1,
						},
						XResolution = {
							type = "range",
							order = 8,
							name = self.L["VP XResolution"],
							desc = self.L["Change X Resolution"],
							min = 0, max = 1600, step = 2,
							set = function(info, value)
								db.ViewPort.XResolution = value
								db.ViewPort.XScaling = value / 1050
								self.initialized.ViewPort = nil
								self:checkAndRun("ViewPort")
							end,
						},
						YResolution = {
							type = "range",
							order = 9,
							name = self.L["VP YResolution"],
							desc = self.L["Change Y Resolution"],
							min = 0, max = 2600, step = 2,
							set = function(info, value)
								db.ViewPort.YResolution = value
								db.ViewPort.YScaling = 768 / value
								self.initialized.ViewPort = nil
								self:checkAndRun("ViewPort")
							end,
						},
						overlay = {
							type = "toggle",
							order = 2,
							name = self.L["ViewPort Overlay"],
							desc = self.L["Toggle the ViewPort Overlay"],
							set = function(info, value)
								db.ViewPort.overlay = value
								self.initialized.ViewPort = nil
								self:checkAndRun("ViewPort")
							end,
						},
						colour = {
							type = "color",
							order = 3,
							width = "double",
							name = self.L["ViewPort Colors"],
							desc = self.L["Set ViewPort Colors"],
							hasAlpha = true,
							get = function(info)
								local c = db.ViewPort
								return c.r, c.g, c.b, c.a
							end,
							set = function(info, r, g, b, a)
								local c = db.ViewPort
								c.r, c.g, c.b, c.a = r, g, b, a
							end,
						},
					},
				},
				TopFrame =  {
					type = "group",
					order = 2,
					name = self.L["Top Frame"],
					desc = self.L["Change the TopFrame settings"],
					get = function(info) return db.TopFrame[info[#info]] end,
					set = function(info, value) db.TopFrame[info[#info]] = value end,
					args = {
						shown = {
							type = "toggle",
							order = 1,
							width = "full",
							name = self.L["TopFrame Show"],
							desc = self.L["Toggle the TopFrame"],
							set = function(info, value)
								db.TopFrame.shown = value
								if SkinnerTF then
									if self.topframe:IsVisible() then
										self.topframe:Hide()
										self:adjustTFOffset("reset")
									else
										self.topframe:Show()
										self:adjustTFOffset(nil)
									end
								else
									self:checkAndRun("TopFrame")
								end
							end,
						},
						height = {
							type = "range",
							order = 6,
							name = self.L["TF Height"],
							desc = self.L["Change Height of the TopFrame"],
							min = 0, max = 500, step = 1,
							set = function(info, value)
								db.TopFrame.height = value
								if SkinnerTF then
									self.topframe:SetHeight(value)
									self:adjustTFOffset(nil)
								end
							end,
						},
						width = {
							type = "range",
							order = 7,
							name = self.L["TF Width"],
							desc = self.L["Change Width of the TopFrame"],
							min = 0, max = 2000, step = 1,
							set = function(info, value)
								db.TopFrame.width = value
								if SkinnerTF then
									self.topframe:SetWidth(value)
								end
							end,
						},
						fheight = {
							type = "range",
							order = 8,
							name = self.L["TF Fade Height"],
							desc = self.L["Change the Height of the Fade Effect"],
							min = 0, max = 500, step = 1,
							set = function(info, value)
								db.TopFrame.fheight = value
								if SkinnerTF then
									if db.FadeHeight.enable and db.FadeHeight.force then
									-- set the Fade Height to the global value if 'forced'
									-- making sure that it isn't greater than the frame height
										fh = db.FadeHeight.value <= math.ceil(self.topframe:GetHeight()) and db.FadeHeight.value or math.ceil(self.topframe:GetHeight())
									elseif value then
										fh = value <= math.ceil(self.topframe:GetHeight()) and value or math.ceil(self.topframe:GetHeight())
									end
									if db.TopFrame.invert then self.topframe.tfade:SetPoint("TOPRIGHT", self.topframe, "BOTTOMRIGHT", 4, (fh - 4))
									else self.topframe.tfade:SetPoint("BOTTOMRIGHT", self.topframe, "TOPRIGHT", -4, -(fh - 4)) end
								end
							end,
						},
						xyOff = {
							type = "toggle",
							order = 2,
							name = self.L["TF Move Origin offscreen"],
							desc = self.L["Hide Border on Left and Top"],
							set = function(info, value)
								db.TopFrame.xyOff = value
								if SkinnerTF then
									if value then
										self.topframe:SetPoint("TOPLEFT", UIParent, "TOPLEFT", -6, 6)
									else
										self.topframe:SetPoint("TOPLEFT", UIParent, "TOPLEFT", -3, 3)
									end
								end
							end,
						},
						borderOff = {
							type = "toggle",
							order = 3,
							name = self.L["TF Toggle Border"],
							desc = self.L["Toggle the Border"],
						},
						alpha = {
							type = "range",
							order = 9,
							name = self.L["TF Alpha"],
							desc = self.L["Change Alpha value of the TopFrame"],
							min = 0, max = 1, step = 0.1,
						},
						invert = {
							type = "toggle",
							order = 4,
							name = self.L["TF Invert Gradient"],
							desc = self.L["Toggle the Inversion of the Gradient"],
						},
						rotate = {
							type = "toggle",
							order = 5,
							name = self.L["TF Rotate Gradient"],
							desc = self.L["Toggle the Rotation of the Gradient"],
						},
					},
				},
				MiddleFrame = {
					type = "group",
					order = 3,
					name = self.L["Middle Frame(s)"],
					desc = self.L["Change the MiddleFrame(s) settings"],
					get = function(info) return db.MiddleFrame[info[#info]]	end,
					set = function(info, value) db.MiddleFrame[info[#info]] = value	end,
					args = {
						fheight = {
							type = "range",
							order = 4,
							name = self.L["MF Fade Height"],
							desc = self.L["Change the Height of the Fade Effect"],
							min = 0, max = 500, step = 1,
						},
						borderOff = {
							type = "toggle",
							order = 2,
							name = self.L["MF Toggle Border"],
							desc = self.L["Toggle the Border"],
						},
						colour = {
							type = "color",
							order = 3,
							name = self.L["MF Colour"],
							desc = self.L["Change the Colour of the MiddleFrame(s)"],
							hasAlpha = true,
							get = function(info)
								local c = db.MiddleFrame
								return c.r, c.g, c.b, c.a
							end,
							set = function(info, r, g, b, a)
								local c = db.MiddleFrame
								c.r, c.g, c.b, c.a = r, g, b, a
							end,
						},
						lock = {
							type = "toggle",
							order = 1,
							name = self.L["MF Lock Frames"],
							desc = self.L["Toggle the Frame Lock"],
							set = function(info, value)
								db.MiddleFrame.lock = value
								for i = 1, 9 do
									if db["MiddleFrame"..i].shown then
										if value then
											_G["SkinnerMF"..i]:SetScript("OnMouseDown", function() end)
											_G["SkinnerMF"..i]:EnableMouse(false)
										else
											_G["SkinnerMF"..i]:SetScript("OnMouseDown", OnMouseDown)
											_G["SkinnerMF"..i]:EnableMouse(true)
										end
									 end
								end
							end,
						},
					},
				},
				BottomFrame = {
					type = "group",
					order = 4,
					name = self.L["Bottom Frame"],
					desc = self.L["Change the BottomFrame settings"],
					get = function(info) return db.BottomFrame[info[#info]] end,
					set = function(info, value) db.BottomFrame[info[#info]] = value end,
					args = {
						shown = {
							type = "toggle",
							order = 1,
							width = "full",
							name = self.L["BottomFrame Show"],
							desc = self.L["Toggle the BottomFrame"],
							set = function(info, value)
								db.BottomFrame.shown = value
								if SkinnerBF then
									if self.bottomframe:IsVisible() then
										self.bottomframe:Hide()
									else
										self.bottomframe:Show()
									end
								else
									self:checkAndRun("BottomFrame")
								end
							end,
						},
						height = {
							type = "range",
							order = 6,
							name = self.L["BF Height"],
							desc = self.L["Change Height of the BottomFrame"],
							min = 0, max = 500, step = 1,
							set = function(info, value)
								db.BottomFrame.height = value
								if SkinnerBF then
									self.bottomframe:SetHeight(value)
								end
							end,
						},
						width = {
							type = "range",
							order = 7,
							name = self.L["BF Width"],
							desc = self.L["Change Width of the BottomFrame"],
							min = 0, max = 2000, step = 1,
							set = function(info, value)
								db.BottomFrame.width = value
								if SkinnerBF then
									self.bottomframe:SetWidth(value)
								end
							end,
						},
						fheight = {
							type = "range",
							order = 8,
							name = self.L["BF Fade Height"],
							desc = self.L["Change the Height of the Fade Effect"],
							min = 0, max = 500, step = 1,
							set = function(info, value)
								db.BottomFrame.fheight = value
								if SkinnerBF then
									if db.FadeHeight.enable and db.FadeHeight.force then
									-- set the Fade Height to the global value if 'forced'
									-- making sure that it isn't greater than the frame height
										fh = db.FadeHeight.value <= math.ceil(self.bottomframe:GetHeight()) and db.FadeHeight.value or math.ceil(self.bottomframe:GetHeight())
									elseif value then
										fh = value <= math.ceil(self.bottomframe:GetHeight()) and value or math.ceil(self.bottomframe:GetHeight())
									end
									if db.BottomFrame.invert then self.bottomframe.tfade:SetPoint("TOPRIGHT", self.bottomframe, "BOTTOMRIGHT", 4, (fh - 4))
									else self.bottomframe.tfade:SetPoint("BOTTOMRIGHT", self.bottomframe, "TOPRIGHT", -4, -(fh - 4)) end
								end
							end,
						},
						xyOff = {
							type = "toggle",
							order = 2,
							name = self.L["BF Move Origin offscreen"],
							desc = self.L["Hide Border on Left and Bottom"],
							set = function(info, value)
								db.BottomFrame.xyOff = value
								if SkinnerBF then
									if value then
										self.bottomframe:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", -6, -6)
									else
										self.bottomframe:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", -3, -3)
									end
								end
							end,
						},
						borderOff = {
							type = "toggle",
							order = 3,
							name = self.L["BF Toggle Border"],
							desc = self.L["Toggle the Border"],
						},
						alpha = {
							type = "range",
							order = 9,
							name = self.L["BF Alpha"],
							desc = self.L["Change Alpha value of the BottomFrame"],
							min = 0, max = 1, step = 0.1,
						},
						invert = {
							type = "toggle",
							order = 4,
							name = self.L["BF Invert Gradient"],
							desc = self.L["Toggle the Inversion of the Gradient"],
						},
						rotate = {
							type = "toggle",
							order = 5,
							name = self.L["BF Rotate Gradient"],
							desc = self.L["Toggle the Rotation of the Gradient"],
						},
					},
				},
			},
		},

		NPCFrames = {
			type = "group",
			name = self.L["NPC Frames"],
			desc = self.L["Change the NPC Frames settings"],
			get = function(info) return db[info[#info]] end,
			set = function(info, value)
				db[info[#info]] = value
				local uiOpt = string.match(info[#info], "UI" , -2)
				-- handle Blizzard UI LoD Addons
				if uiOpt then
					if IsAddOnLoaded("Blizzard_"..info[#info]) then
						self:checkAndRun(info[#info])
					end
				else self:checkAndRun(info[#info]) end
			end,
			args = {
				none = {
					type = "execute",
					order = 1,
					width = "full",
					name = self.L["Disable all NPC Frames"],
					desc = self.L["Disable all the NPC Frames from being skinned"],
					func = function()
						for _, keyName in pairs(self.npcKeys) do
							db[keyName] = false
						end
					end,
				},
				MerchantFrames = {
					type = "toggle",
					name = self.L["Merchant Frames"],
					desc = self.L["Toggle the skin of the Merchant Frame"],
				},
				GossipFrame = {
					type = "toggle",
					name = self.L["Gossip Frame"],
					desc = self.L["Toggle the skin of the Gossip Frame"],
				},
				TrainerUI = {
					name = self.L["Class Trainer Frame"],
					desc = self.L["Toggle the skin of the Class Trainer Frame"],
					type = "toggle",
				},
				TaxiFrame = {
					type = "toggle",
					name = self.L["Taxi Frame"],
					desc = self.L["Toggle the skin of the Taxi Frame"],
				},
				QuestFrame = {
					type = "toggle",
					name = self.L["Quest Frame"],
					desc = self.L["Toggle the skin of the Quest Frame"],
				},
				Battlefields = {
					type = "toggle",
					name = self.L["Battlefields Frame"],
					desc = self.L["Toggle the skin of the Battlefields Frame"],
				},
				ArenaFrame = {
					type = "toggle",
					name = self.L["Arena Frame"],
					desc = self.L["Toggle the skin of the Arena Frame"],
				},
				ArenaRegistrar = {
					type = "toggle",
					name = self.L["Arena Registrar Frame"],
					desc = self.L["Toggle the skin of the Arena Registrar Frame"],
				},
				GuildRegistrar = {
					type = "toggle",
					name = self.L["Guild Registrar Frame"],
					desc = self.L["Toggle the skin of the Guild Registrar Frame"],
				},
				Petition = {
					type = "toggle",
					name = self.L["Petition Frame"],
					desc = self.L["Toggle the skin of the Petition Frame"],
				},
				Tabard = {
					type = "toggle",
					name = self.L["Tabard Frame"],
					desc = self.L["Toggle the skin of the Tabard Frame"],
				},
				BarbershopUI = {
					type = "toggle",
					name = self.L["Barbershop Frame"],
					desc = self.L["Toggle the skin of the Barbershop Frame"],
				},
			},
		},

		PlayerFrames = {
			type = "group",
			name = self.L["Character Frames"],
			desc = self.L["Change the Character Frames settings"],
			get = function(info) return db[info[#info]] end,
			set = function(info, value)
				db[info[#info]] = value
				-- handle Blizzard UI LoD Addons
				local uiOpt = string.match(info[#info], "UI" , -2)
				if uiOpt then
					if IsAddOnLoaded("Blizzard_"..info[#info]) then
						self:checkAndRun(info[#info])
					end
				else self:checkAndRun(info[#info]) end
			end,
			args = {
				none = {
					type = "execute",
					order = 1,
					width = "full",
					name = self.L["Disable all Character Frames"],
					desc = self.L["Disable all the Character Frames from being skinned"],
					func = function()
						for _, keyName in pairs(self.charKeys1) do
							db[keyName] = false
						end
						for _, keyName in pairs(self.charKeys2) do
							db[keyName].skin = false
						end
					end,
				},
				CharacterFrames = {
					type = "toggle",
					name = self.L["Character Frames"],
					desc = self.L["Toggle the skin of the Character Frames"],
				},
				PVPFrame = {
					type = "toggle",
					name = self.L["PVP Frame"],
					desc = self.L["Toggle the skin of the PVP Frame"],
				},
				PetStableFrame = {
					type = "toggle",
					name = self.L["Stable Frame"],
					desc = self.L["Toggle the skin of the Stable Frame"],
				},
				SpellBookFrame = {
					type = "toggle",
					name = self.L["SpellBook Frame"],
					desc = self.L["Toggle the skin of the SpellBook Frame"],
				},
				TalentUI = {
					type = "toggle",
					name = self.L["Talent Frame"],
					desc = self.L["Toggle the skin of the Talent Frame"],
				},
				DressUpFrame = {
					type = "toggle",
					name = self.L["DressUp Frame"],
					desc = self.L["Toggle the skin of the DressUp Frame"],
				},
				FriendsFrame = {
					type = "toggle",
					name = self.L["Social Frame"],
					desc = self.L["Toggle the skin of the Social Frame"],
				},
				TradeSkillUI = {
					type = "toggle",
					name = self.L["Trade Skill Frame"],
					desc = self.L["Toggle the skin of the Trade Skill Frame"],
				},
				TradeFrame = {
					type = "toggle",
					name = self.L["Trade Frame"],
					desc = self.L["Toggle the skin of the Trade Frame"],
				},
				QuestLog = {
					type = "group",
					inline = true,
					order = -1,
					name = self.L["Quest Log"],
					desc = self.L["Change the Quest Log settings"],
					get = function(info) return db.QuestLog[info[#info]] end,
					set = function(info, value)
						db.QuestLog[info[#info]] = value
						if info[#info] == "skin" then self:checkAndRun("QuestLog")
						else self:checkAndRun("ResizeQW") end
					end,
					args = {
						skin = {
							type = "toggle",
							order = 1,
							name = self.L["Quest Log Skin"],
							desc = self.L["Toggle the skin of the Quest Log Frame"],
						},
						size = {
							type = "range",
							order = 2,
							name = self.L["Quest Watch Size"],
							desc = self.L["Set the Quest Watch Font Size (Normal, Small)"],
							min = 1, max = 2, step = 1,
						},
					},
				},
				RaidUI = {
					type = "toggle",
					name = self.L["RaidUI Frame"],
					desc = self.L["Toggle the skin of the RaidUI Frame"],
				},
				ReadyCheck = {
					type = "toggle",
					name = self.L["ReadyCheck Frame"],
					desc = self.L["Toggle the skin of the ReadyCheck Frame"],
				},
				Buffs = {
					type = "toggle",
					name = self.L["Buffs Buttons"],
					desc = self.L["Toggle the skin of the Buffs Buttons"],
				},
				achievements = {
					type = "group",
					inline = true,
					order = -2,
					name = self.L["AchievementUI"],
					desc = self.L["Change the AchievementUI settings"],
					get = function(info) return db[info[#info]] end,
					set = function(info, value)
						db[info[#info]] = value
						local aOpt = string.sub(info[#info], -5)
						local aFunc
						if IsAddOnLoaded("Blizzard_AchievementUI") then
							if aOpt == "Frame" then aFunc = "UI"
							elseif aOpt == "Alert" then aFunc = "Alerts"
							elseif aOpt == "Watch" then aFunc = "Watch"
							end
							self:checkAndRun("Achievement"..aFunc)
						end
					end,
					args = {
						AchieveFrame = {
							type = "toggle",
							order = 1,
							name = self.L["Achievements Frame"],
							desc = self.L["Toggle the skin of the Achievements Frame"],
						},
						AchieveAlert = {
							type = "toggle",
							order = 2,
							name = self.L["Achievement Alerts"],
							desc = self.L["Toggle the skin of the Achievement Alerts"],
						},
						AchieveWatch = {
							type = "toggle",
							order = 3,
							name = self.L["Achievement Watch"],
							desc = self.L["Toggle the skin of the Achievement Watch"],
						},
					},
				},
			},
		},

		UIFrames = {
			type = "group",
			name = self.L["UI Frames"],
			desc = self.L["Change the UI Elements settings"],
			get = function(info) return db[info[#info]] end,
			set = function(info, value)
				db[info[#info]] = value
				local uiOpt = string.match(info[#info], "UI" , -2)
				if info[#info] == "Colours" then self:checkAndRun("ColorPicker")
				elseif info[#info] == "Feedback" then self:checkAndRun("FeedbackUI")
				elseif info[#info] == "CombatLogQBF" then return
				elseif info[#info] == "BattlefieldMm" then
					if IsAddOnLoaded("Blizzard_BattlefieldMinimap") then
						self:checkAndRun("BattlefieldMinimap")
					end
				elseif info[#info] == "TimeManager" or info[#info] == "Calendar" then
					if IsAddOnLoaded(info[#info]) then
						self:checkAndRun(info[#info])
					end
				-- handle Blizzard UI LoD Addons
				elseif uiOpt then
					if IsAddOnLoaded("Blizzard_"..info[#info]) then
						self:checkAndRun(info[#info])
					end
				else self:checkAndRun(info[#info]) end
			end,
			args = {
				none = {
					type = "execute",
					order = 1,
					width = "full",
					name = self.L["Disable all UI Frames"],
					desc = self.L["Disable all the UI Frames from being skinned"],
					func = function()
						for _, keyName in pairs(self.uiKeys1) do
							db[keyName] = false
						end
						for _, keyName in pairs(self.uiKeys2) do
							db[keyName].skin = false
						end
					end,
				},
				Tooltips = {
					type = "group",
					inline = true,
					order = -1,
					name = self.L["Tooltips"],
					desc = self.L["Change the Tooltip settings"],
					get = function(info) return db.Tooltips[info[#info]] end,
					set = function(info, value)
						db.Tooltips[info[#info]] = value
						self:checkAndRun("Tooltips")
					end,
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
							set = function(info, value)
								db.Tooltips.style = value
								if value == 3 then self:setTTBackdrop(true)
								else self:setTTBackdrop() end
							end,
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
				MirrorTimers = {
					type = "group",
					inline = true,
					order = -2,
					name = self.L["Timer Frames"],
					desc = self.L["Change the Timer Settings"],
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
				CastingBar = {
					type = "group",
					inline = true,
					order = -10,
					name = self.L["Casting Bar Frame"],
					desc = self.L["Change the Casting Bar Settings"],
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
				chatopts = {
					type = "group",
					inline = true,
					order = -8,
					name = self.L["Chat Sub Frames"],
					desc = self.L["Change the Chat Sub Frames"],
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
						ChatFrames = {
							type = "toggle",
							order = 4,
							name = self.L["Chat Frames"],
							desc = self.L["Toggle the skin of the Chat Frames"],
						},
						CombatLogQBF = {
							type = "toggle",
							width = "double",
							name = self.L["CombatLog Quick Button Frame"],
							desc = self.L["Toggle the skin of the CombatLog Quick Button Frame"],
						},
					},
				},
				ChatEditBox = {
					type = "group",
					inline = true,
					order = -9,
					name = self.L["Chat Edit Box"],
					desc = self.L["Change the Chat Edit Box settings"],
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
							desc = self.L["Set the Chat Edit Box style (Frame, EditBox)"],
							min = 1, max = 2, step = 1,
						},
					},
				},
				LootFrame = {
					type = "toggle",
					name = self.L["Loot Frame"],
					desc = self.L["Toggle the skin of the Loot Frame"],
				},
				GroupLoot = {
					type = "group",
					inline = true,
					order = -6,
					name = self.L["Group Loot Frame"],
					desc = self.L["Change the GroupLoot settings"],
					get = function(info) return db.GroupLoot[info[#info]] end,
					set = function(info, value)
						db.GroupLoot[info[#info]] = value
						self:checkAndRun("GroupLoot")
					end,
					args = {
						skin = {
							type = "toggle",
							order = 1,
							name = self.L["GroupLoot Skin"],
							desc = self.L["Toggle the skin of the GroupLoot Frame"],
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
				ContainerFrames = {
					type = "group",
					inline = true,
					order = -7,
					name = self.L["Container Frames"],
					desc = self.L["Change the Container Frames settings"],
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
				StackSplit = {
					type = "toggle",
					name = self.L["Stack Split Frame"],
					desc = self.L["Toggle the skin of the Stack Split Frame"],
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
				StaticPopups = {
					type = "toggle",
					name = self.L["Static Popups"],
					desc = self.L["Toggle the skin of Static Popups"],
				},
				ScriptErrors = {
					type = "toggle",
					name = self.L["Script Errors Frame"],
					desc = self.L["Toggle the skin of the Script Errors Frame"],
				},
				Nameplates = {
					type = "toggle",
					name = self.L["Nameplates"],
					desc = self.L["Toggle the skin of the Nameplates"],
				},
				ItemText = {
					type = "toggle",
					name = self.L["Item Text Frame"],
					desc = self.L["Toggle the skin of the Item Text Frame"],
				},
				WorldMap = {
					type = "toggle",
					name = self.L["World Map Frame"],
					desc = self.L["Toggle the skin of the World Map Frame"],
				},
				helpframes = {
					type = "group",
					inline = true,
					order = -5,
					name = self.L["Help Request Frames"],
					desc = self.L["Change the Help Request Frames"],
					args = {
						HelpFrame = {
							type = "toggle",
							name = self.L["Help Frame"],
							desc = self.L["Toggle the skin of the Help Frame"],
						},
						Tutorial = {
							type = "toggle",
							name = self.L["Tutorial Frame"],
							desc = self.L["Toggle the skin of the Tutorial Frame"],
						},
						GMSurveyUI = {
							type = "toggle",
							name = self.L["GM Survey UI Frame"],
							desc = self.L["Toggle the skin of the GM Survey UI Frame"],
						},
						Feedback = IsPTR and {
							type = "toggle",
							name = self.L["Feedback"],
							desc = self.L["Toggle the skin of the Feedback Frame"],
						} or nil,
					},
				},
				LFGFrame = {
					type = "toggle",
					name = self.L["LFG Frame"],
					desc = self.L["Toggle the skin of the LFG Frame"],
				},
				InspectUI = {
					type = "toggle",
					name = self.L["Inspect Frame"],
					desc = self.L["Toggle the skin of the Inspect Frame"],
				},
				BattleScore = {
					type = "toggle",
					name = self.L["Battle Score Frame"],
					desc = self.L["Toggle the skin of the Battle Score Frame"],
				},
				BattlefieldMm = {
					type = "toggle",
					name = self.L["Battlefield Minimap Frame"],
					desc = self.L["Toggle the skin of the Battlefield Minimap Frame"],
				},
				minimapopts = {
					type = "group",
					inline = true,
					order = -3,
					name = self.L["Minimap Options"],
					desc = self.L["Change the Minimap Options"],
					args = {
						MinimapButtons = {
							type = "toggle",
							name = self.L["Minimap Buttons"],
							desc = self.L["Toggle the skin of the Minimap Buttons"],
						},
						MinimapGloss = {
							type = "toggle",
							name = self.L["Minimap Gloss Effect"],
							desc = self.L["Toggle the Gloss Effect for the Minimap"],
							set = function(info, value)
								db.MinimapGloss = value
								if self.minimapskin then
									if not value then LowerFrameLevel(self.minimapskin)
									else RaiseFrameLevel(self.minimapskin) end
								end
							end,
						},
					},
				},
				MenuFrames = {
					type = "toggle",
					name = self.L["Menu Frames"],
					desc = self.L["Toggle the skin of the Menu Frames"],
				},
				MovieProgress = IsMacClient and {
					type = "toggle",
					name = self.L["Movie Progress"],
					desc = self.L["Toggle the skinning of Movie Progress"],
				} or nil,
				BankFrame = {
					type = "toggle",
					name = self.L["Bank Frame"],
					desc = self.L["Toggle the skin of the Bank Frame"],
				},
				GuildBankUI = {
					type = "toggle",
					name = self.L["GuildBankUI Frame"],
					desc = self.L["Toggle the skin of the GuildBankUI Frame"],
				},
				MailFrame = {
					type = "toggle",
					name = self.L["Mail Frame"],
					desc = self.L["Toggle the skin of the Mail Frame"],
				},
				AuctionUI = {
					type = "toggle",
					name = self.L["Auction Frame"],
					desc = self.L["Toggle the skin of the Auction Frame"],
				},
				MainMenuBar = {
					type = "group",
					inline = true,
					order = -4,
					name = self.L["Main Menu Bar"],
					desc = self.L["Change the Main Menu Bar Frame Settings"],
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
					},
				},
				ItemSocketingUI = {
					type = "toggle",
					name = self.L["ItemSocketingUI Frame"],
					desc = self.L["Toggle the skin of the ItemSocketingUI Frame"],
				},
				TimeManager = {
					type = "toggle",
					name = self.L["Time Manager"],
					desc = self.L["Toggle the skin of the Time Manager Frame"],
				},
				Calendar = {
					type = "toggle",
					name = self.L["Calendar"],
					desc = self.L["Toggle the skin of the Calendar Frame"],
				},
			},
		},

	}

	local FrameStrata = {
		BACKGROUND = "Background",
		LOW = "Low",
		MEDIUM = "Medium",
		HIGH = "High",
		DIALOG = "Dialog",
		FULLSCREEN = "Fullscreen",
		FULLSCREEN_DIALOG = "Fullscreen_Dialog",
		TOOLTIP = "Tooltip",
	}

	-- setup middleframe(s) options
	local mfkey
	for i = 1, 9 do

		mfkey = {}
		mfkey.type = "group"
		mfkey.inline = true
		mfkey.name = self.L["Middle Frame"..i]
		mfkey.desc = self.L["Change MiddleFrame"..i.." settings"]
		mfkey.get = function(info) return db["MiddleFrame"..i][info[#info]] end
		mfkey.args = {}
		mfkey.args.shown = {}
		mfkey.args.shown.type = "toggle"
		mfkey.args.shown.order = 1
		mfkey.args.shown.name = self.L["MiddleFrame"..i.." Show"]
		mfkey.args.shown.desc = self.L["Toggle the MiddleFrame"..i]
		mfkey.args.shown.set = function(info, value)
			db["MiddleFrame"..i][info[#info]] = value
			if self.initialized["MiddleFrame"..i] then
				if self["middleframe"..i]:IsVisible() then
					self["middleframe"..i]:Hide()
				else
					self["middleframe"..i]:Show()
				end
			else
				self:checkAndRun("MiddleFrames")
			end
		end
		mfkey.args.flevel = {}
		mfkey.args.flevel.type = "range"
		mfkey.args.flevel.name = self.L["MF"..i.." Frame Level"]
		mfkey.args.flevel.desc = self.L["Change the MF"..i.." Frame Level"]
		mfkey.args.flevel.min = 0
		mfkey.args.flevel.max = 20
		mfkey.args.flevel.step = 1
		mfkey.args.flevel.set = function(info, value)
			db["MiddleFrame"..i][info[#info]] = value
			if self["middleframe"..i] then self["middleframe"..i]:SetFrameLevel(value) end
		end
		mfkey.args.fstrata = {}
		mfkey.args.fstrata.type = "select"
		mfkey.args.fstrata.name = self.L["MF"..i.." Frame Strata"]
		mfkey.args.fstrata.desc = self.L["Change the MF"..i.." Frame Strata"]
		mfkey.args.fstrata.values = FrameStrata
		mfkey.args.fstrata.set = function(info, value)
--			self:Debug("MF frame strata:[%s]", value)
			db["MiddleFrame"..i][info[#info]] = value
			if self["middleframe"..i] then self["middleframe"..i]:SetFrameStrata(value) end
		end

		optTables["VP/TMBFrames"].args.MiddleFrame.args["mf"..i] = mfkey

	end
	mfkey = nil

	-- add these if Baggins & its skin are loaded
	if IsAddOnLoaded("Baggins") and self.Baggins then
		-- setup option to change the Bank Bags colour
		local bbckey = {}
		bbckey.type = "color"
		bbckey.order = -1
		bbckey.width = "double"
		bbckey.name = self.L["Baggins Bank Bags Colour"]
		bbckey.desc = self.L["Set Baggins Bank Bags Colour"]
		bbckey.hasAlpha = true
		-- add to the colour submenu
		optTables.Colours.args["BagginsBBC"] = bbckey
		bbckey = nil
	end

	-- add DB profile options
	optTables.Profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)

	-- option tables list
	local optNames = {
		"Backdrop", "Colours", "Gradient", "VP/TMBFrames", "NPCFrames", "PlayerFrames", "UIFrames", "Profiles"
	}
	-- register the options tables and add them to the blizzard frame
	local ACR = LibStub("AceConfigRegistry-3.0")
	local ACD = LibStub("AceConfigDialog-3.0")

	LibStub("AceConfig-3.0"):RegisterOptionsTable(aName, optTables.General, {aName, "skin"})
	self.optionsFrame = ACD:AddToBlizOptions(aName, aName)

	-- register the options, add them to the Blizzard Options
	-- build the table used by the chatCommand function
	local optCheck = {}
	for _, v in ipairs(optNames) do
--		self:Debug("options: [%s]", v)
		local optTitle = string.join(" ", aName, v)
		ACR:RegisterOptionsTable(optTitle, optTables[v])
		self.optionsFrame[self.L[v]] = ACD:AddToBlizOptions(optTitle, self.L[v], aName)
		optCheck[string.lower(v)] = v
	end

	-- Slash command handler
	local function chatCommand(input)

		if not input or input:trim() == "" then
			-- Open general panel if there are no parameters
			InterfaceOptionsFrame_OpenToCategory(Skinner.optionsFrame)
		elseif optCheck[string.lower(input)] then
			InterfaceOptionsFrame_OpenToCategory(Skinner.optionsFrame[optCheck[string.lower(input)]])
		else
			LibStub("AceConfigCmd-3.0"):HandleCommand(aName, aName, input)
		end
	end

	-- Register slash command handlers
	self:RegisterChatCommand(aName, chatCommand)
	self:RegisterChatCommand("skin", chatCommand)

	-- setup the LDB object
	SkinnerLDB = ldb:NewDataObject("Skinner", {
			type = "launcher",
			icon = "Interface\\Icons\\INV_Misc_Pelt_Wolf_01",
			OnClick = function(clickedframe, button)
				if button == "RightButton" then
					if InterfaceOptionsFrame:IsShown() then HideUIPanel(InterfaceOptionsFrame)
					else Skinner:ShowConfig() end
				end
			end,
			OnTooltipShow = function(tt)
				tt:AddLine("Skinner")
				tt:AddLine("|cffffff00" .. Skinner.L["Right Click to display options menu"])
			end,
	})

	-- register the data object to the Icon library
	icon:Register(aName, SkinnerLDB, db.MinimapIcon)

end

function Skinner:ShowConfig()

	InterfaceOptionsFrame_OpenToCategory(Skinner.optionsFrame)

end
