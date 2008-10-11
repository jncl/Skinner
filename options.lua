--check to see if running on PTR
local IsPTR = FeedbackUI and true or false
--check to see if running on WotLK
local IsWotLK = GetCVarBool and true or false

local FrameStrata = {"PARENT", "BACKGROUND", "LOW", "MEDIUM", "HIGH", "DIALOG", "FULLSCREEN", "FULLSCREEN_DIALOG", "TOOLTIP"}

function Skinner:Defaults()
	self:RegisterDefaults("profile", {
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
		MiddleFrame1	= {height = 64, width = 64, shown = false, xOfs = 0, yOfs = 0, flevel = 0, fstrata = "BACKGROUND"},
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
		PetStableFrame  = true,
		SpellBookFrame  = true,
		TalentFrame     = true,
		DressUpFrame    = true,
		FriendsFrame    = true,
		TradeSkill      = true,
		CraftFrame      = true,
		TradeFrame      = true,
		QuestLog        = {skin = true, size = 1},
		RaidUI          = true,
		ReadyCheck      = true,
		Buffs           = true,
		Achievements    = IsWotLK and true or nil,
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
		Inspect         = true,
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
		AuctionFrame    = true,
		MainMenuBar     = {skin = true, glazesb = true},
		CoinPickup      = true,
		GMSurveyUI      = true,
		LFGFrame        = true,
		ItemSocketingUI = true,
		GuildBankUI     = true,
		Nameplates      = true,
		TimeManager     = true,
		Calendar        = IsWotLK and true or nil,
		Feedback        = IsPTR and true or nil,
		-- NPC Frames
		MerchantFrames  = true,
		GossipFrame     = true,
		ClassTrainer    = true,
		TaxiFrame       = true,
		QuestFrame      = true,
		Battlefields    = true,
		ArenaFrame      = true,
		ArenaRegistrar  = true,
		GuildRegistrar  = true,
		Petition        = true,
		Tabard          = true,
		Barbershop      = IsWotLK and true or nil,
		-- Others
		TrackerFrame    = false,
	})

end

function Skinner:Options()
	self.options = {
		type = "group",
		args = {
			cp = {
				name = self.L["Default Colours"],
				desc = self.L["Change the default colour settings"],
				type = "group",
				args = {
					ttborder = {
						name = self.L["Tooltip Border Colors"],
						desc = self.L["Set Tooltip Border Colors"],
						type = "color",
						get = function()
							return self.db.profile.TooltipBorder.r, self.db.profile.TooltipBorder.g, self.db.profile.TooltipBorder.b, self.db.profile.TooltipBorder.a
						end,
						set = function(r, g, b, a)
							self.db.profile.TooltipBorder.r, self.db.profile.TooltipBorder.g, self.db.profile.TooltipBorder.b, self.db.profile.TooltipBorder.a = r, g, b, a
						end,
						hasAlpha = true,
					},
					border = {
						name = self.L["Border Colors"],
						desc = self.L["Set Backdrop Border Colors"],
						type = "color",
						get = function()
							return self.db.profile.BackdropBorder.r, self.db.profile.BackdropBorder.g, self.db.profile.BackdropBorder.b, self.db.profile.BackdropBorder.a
						end,
						set = function(r, g, b, a)
							self.db.profile.BackdropBorder.r, self.db.profile.BackdropBorder.g, self.db.profile.BackdropBorder.b, self.db.profile.BackdropBorder.a = r, g, b, a
						end,
						hasAlpha = true,
					},
					backdrop = {
						name = self.L["Backdrop Colors"],
						desc = self.L["Set Backdrop Colors"],
						type = "color",
						get = function()
							return self.db.profile.Backdrop.r, self.db.profile.Backdrop.g, self.db.profile.Backdrop.b, self.db.profile.Backdrop.a
						end,
						set = function(r, g, b, a)
							self.db.profile.Backdrop.r, self.db.profile.Backdrop.g, self.db.profile.Backdrop.b, self.db.profile.Backdrop.a = r, g, b, a
						end,
						hasAlpha = true,
					},
					headtext = {
						name = self.L["Text Heading Colors"],
						desc = self.L["Set Text Heading Colors"],
						type = "color",
						get = function()
							return self.db.profile.HeadText.r, self.db.profile.HeadText.g, self.db.profile.HeadText.b
						end,
						set = function(r, g, b)
							self.db.profile.HeadText.r, self.db.profile.HeadText.g, self.db.profile.HeadText.b = r, g, b
						end,
					},
					bodytext = {
						name = self.L["Text Body Colors"],
						desc = self.L["Set Text Body Colors"],
						type = "color",
						get = function()
							return self.db.profile.BodyText.r, self.db.profile.BodyText.g, self.db.profile.BodyText.b
						end,
						set = function(r, g, b)
							self.db.profile.BodyText.r, self.db.profile.BodyText.g, self.db.profile.BodyText.b = r, g, b
						end,
					},
					gradientMin = {
						name = self.L["Gradient Minimum Colors"],
						desc = self.L["Set Gradient Minimum Colors"],
						type = "color",
						get = function()
							return self.db.profile.GradientMin.r, self.db.profile.GradientMin.g, self.db.profile.GradientMin.b, self.db.profile.GradientMin.a
						end,
						set = function(r, g, b, a)
							self.db.profile.GradientMin.r, self.db.profile.GradientMin.g, self.db.profile.GradientMin.b, self.db.profile.GradientMin.a = r, g, b, a
						end,
						hasAlpha = true,
					},
					gradientMax = {
						name = self.L["Gradient Maximum Colors"],
						desc = self.L["Set Gradient Maximum Colors"],
						type = "color",
						get = function()
							return self.db.profile.GradientMax.r, self.db.profile.GradientMax.g, self.db.profile.GradientMax.b, self.db.profile.GradientMax.a
						end,
						set = function(r, g, b, a)
							self.db.profile.GradientMax.r, self.db.profile.GradientMax.g, self.db.profile.GradientMax.b, self.db.profile.GradientMax.a = r, g, b, a
						end,
						hasAlpha = true,
					},
				},
			},
			bd = {
				name = self.L["Default Backdrop"],
				desc = self.L["Change the default backdrop settings"],
				type = "group",
				args = {
					default = {
						name = self.L["Use Default Backdrop"],
						desc = self.L["Toggle the Default Backdrop"],
						type = "toggle",
						get = function()
							return self.db.profile.BdDefault
						end,
						set = function (v)
							self.db.profile.BdDefault = v
						end,
						order = 50,
					},
					bdfile = {
						name = self.L["Backdrop Texture File"],
						desc = self.L["Set Backdrop Texture Filename"],
						usage = "<Enter a Texture Filename>",
						type = "text",
						get = function()
							return self.db.profile.BdFile
						end,
						set = function(v)
							self.db.profile.BdFile = v == "" and "None" or v
							self.db.profile.BdDefault = false
						end,
					},
					bdtex = {
						name = self.L["Backdrop Texture"],
						desc = self.L["Choose the Texture for the Backdrop"],
						type = "text",
						get = function()
							return self.db.profile.BdTexture
						end,
						set = function(v)
							self.db.profile.BdTexture = v
							self.db.profile.BdDefault = false
						end,
						validate = self.LSM:List("background", v),
					},
					tilesize = {
						name = self.L["Backdrop TileSize"],
						desc = self.L["Set Backdrop TileSize"],
						type = "range",
						step = 8,
						min = 0,
						max = 512,
						get = function()
							return self.db.profile.BdTileSize
						end,
						set = function(v)
							self.db.profile.BdTileSize = v
							self.db.profile.BdDefault = false
						end,
					},
					bbFile = {
						name = self.L["Border Texture File"],
						desc = self.L["Set Border Texture Filename"],
						usage = "<Enter a Texture Filename>",
						type = "text",
						get = function()
							return self.db.profile.BdEdgeFile
						end,
						set = function(v)
							self.db.profile.BdEdgeFile = v == "" and "None" or v
							self.db.profile.BdDefault = false
						end,
					},
					border = {
						name = self.L["Border Texture"],
						desc = self.L["Choose the Texture for the Border"],
						type = "text",
						get = function()
							return self.db.profile.BdBorderTexture
						end,
						set = function(v)
							self.db.profile.BdBorderTexture = v
							self.db.profile.BdDefault = false
						end,
						validate = self.LSM:List("border", v),
					},
					edgesize = {
						name = self.L["Border Width"],
						desc = self.L["Set Border Width"],
						type = "range",
						step = 8,
						min = 0,
						max = 32,
						get = function()
							return self.db.profile.BdEdgeSize
						end,
						set = function(v)
							self.db.profile.BdEdgeSize = v
							self.db.profile.BdDefault = false
						end,
					},
					inset = {
						name = self.L["Border Inset"],
						desc = self.L["Set Border Inset"],
						type = "range",
						step = 2,
						min = 2,
						max = 8,
						get = function()
							return self.db.profile.BdInset
						end,
						set = function(v)
							self.db.profile.BdInset = v
							self.db.profile.BdDefault = false
						end,
					},
				},
			},
			texturedtab = {
				name = self.L["Textured Tab"],
				desc = self.L["Toggle the Texture of the Tabs"],
				type = "toggle",
				get = function()
					return self.db.profile.TexturedTab
				end,
				set = function(v)
					self.db.profile.TexturedTab = v
				end,
			},
			textureddd = {
				name = self.L["Textured DropDown"],
				desc = self.L["Toggle the Texture of the DropDowns"],
				type = "toggle",
				get = function()
					return self.db.profile.TexturedDD
				end,
				set = function(v)
					self.db.profile.TexturedDD = v
				end,
			},
			warnings = {
				name = self.L["Show Warnings"],
				desc = self.L["Toggle the Showing of Warnings"],
				type = "toggle",
				get = function()
					return self.db.profile.Warnings
				end,
				set = function(v)
					self.db.profile.Warnings = v
				end,
				order = 200,
			},
			errors = {
				name = self.L["Show Errors"],
				desc = self.L["Toggle the Showing of Errors"],
				type = "toggle",
				get = function()
					return self.db.profile.Errors
				end,
				set = function(v)
					self.db.profile.Errors = v
				end,
				order = 200,
			},
			gradient = {
				name = self.L["Gradient"],
				desc = self.L["Change the Gradient Effect settings"],
				type = "group",
				args = {
					enable = {
						name = self.L["Gradient Effect"],
						desc = self.L["Toggle the Gradient Effect"],
						type = "toggle",
						get = function()
							return self.db.profile.Gradient.enable
						end,
						set = function (v)
							self.db.profile.Gradient.enable = v
						end,
					},
					invert = {
						name = self.L["Invert Gradient"],
						desc = self.L["Invert the Gradient Effect"],
						type = "toggle",
						get = function()
							return self.db.profile.Gradient.invert
						end,
						set = function (v)
							self.db.profile.Gradient.invert = v
						end,
					},
					rotate = {
						name = self.L["Rotate Gradient"],
						desc = self.L["Rotate the Gradient Effect"],
						type = "toggle",
						get = function()
							return self.db.profile.Gradient.rotate
						end,
						set = function (v)
							self.db.profile.Gradient.rotate = v
						end,
					},
					char = {
						name = self.L["Enable Character Frames Gradient"],
						desc = self.L["Enable the Gradient Effect for the Character Frames"],
						type = "toggle",
						get = function()
							return self.db.profile.Gradient.char
						end,
						set = function (v)
							self.db.profile.Gradient.char = v
						end,
					},
					ui = {
						name = self.L["Enable UserInterface Frames Gradient"],
						desc = self.L["Enable the Gradient Effect for the UserInterface Frames"],
						type = "toggle",
						get = function()
							return self.db.profile.Gradient.ui
						end,
						set = function (v)
							self.db.profile.Gradient.ui = v
						end,
					},
					npc = {
						name = self.L["Enable NPC Frames Gradient"],
						desc = self.L["Enable the Gradient Effect for the NPC Frames"],
						type = "toggle",
						get = function()
							return self.db.profile.Gradient.npc
						end,
						set = function (v)
							self.db.profile.Gradient.npc = v
						end,
					},
					skinner = {
						name = self.L["Enable Skinner Frames Gradient"],
						desc = self.L["Enable the Gradient Effect for the Skinner Frames"],
						type = "toggle",
						get = function()
							return self.db.profile.Gradient.skinner
						end,
						set = function (v)
							self.db.profile.Gradient.skinner = v
						end,
					},
					texture = {
						name = self.L["Gradient Texture"],
						desc = self.L["Choose the Texture for the Gradient"],
--						usage = "<Enter a Texture Filename or Default to reset>",
						type = "text",
						get = function()
							return self.db.profile.Gradient.texture
						end,
						set = function(v)
							self.db.profile.Gradient.texture = v
						end,
						validate = self.LSM:List("background", v),
					},
				},
			},
			fadeheight = {
				name = self.L["Fade Height"],
				desc = self.L["Change the Fade Height settings"],
				type = "group",
				args = {
					enable = {
						name = self.L["Global Fade Height"],
						desc = self.L["Toggle the Global Fade Height"],
						type = "toggle",
						get = function()
							return self.db.profile.FadeHeight.enable
						end,
						set = function (v)
							self.db.profile.FadeHeight.enable = v
						end,
					},
					value = {
						name = self.L["Fade Height value"],
						desc = self.L["Change the Height of the Fade Effect"],
						type = "range",
						step = 1,
						min = 0,
						max = 1000,
						get = function()
							return self.db.profile.FadeHeight.value
						end,
						set = function (v)
							self.db.profile.FadeHeight.value = v
						end,
					},
					force = {
						name = self.L["Force the Global Fade Height"],
						desc = self.L["Force ALL Frame Fade Height's to be Global"],
						type = "toggle",
						get = function()
							return self.db.profile.FadeHeight.force
						end,
						set = function (v)
							self.db.profile.FadeHeight.force = v
						end,
					},
				},
			},
			delay = {
				name = self.L["Skinning Delays"],
				desc = self.L["Change the Skinning Delays settings"],
				type = "group",
				args = {
					init = {
						name = self.L["Initial Delay"],
						desc = self.L["Set the Delay before Skinning Blizzard Frames"],
						type = "range",
						step = 0.5,
						min = 0,
						max = 10,
						get = function()
							return self.db.profile.Delay.Init
						end,
						set = function (v)
							self.db.profile.Delay.Init = v
						end,
					},
					addons = {
						name = self.L["Addons Delay"],
						desc = self.L["Set the Delay before Skinning Addons Frames"],
						type = "range",
						step = 0.5,
						min = 0,
						max = 10,
						get = function()
							return self.db.profile.Delay.Addons
						end,
						set = function (v)
							self.db.profile.Delay.Addons = v
						end,
					},
					lods = {
						name = self.L["LoD Addons Delay"],
						desc = self.L["Set the Delay before Skinning Load on Demand Frames"],
						type = "range",
						step = 0.5,
						min = 0,
						max = 10,
						get = function()
							return self.db.profile.Delay.LoDs
						end,
						set = function (v)
							self.db.profile.Delay.LoDs = v
						end,
					},
				},
			},
			viewport = {
				name = self.L["View Port"],
				desc = self.L["Change the ViewPort settings"],
				type = "group",
				args = {
					show = {
						name = self.L["ViewPort Show"],
						desc = self.L["Toggle the ViewPort"],
						type = "toggle",
						get = function()
							return self.db.profile.ViewPort.shown
						end,
						set = function (v)
							self.db.profile.ViewPort.shown = v
							if self.initialized.ViewPort then
								self:checkAndRun("ViewPort_reset")
							else
								self:checkAndRun("ViewPort")
							end
						end,
						order = 50,
					},
					top = {
						name = self.L["VP Top"],
						desc = self.L["Change Height of the Top Band"],
						type = "range",
						step = 1,
						min = 0,
						max = 256,
						get = function ()
							return self.db.profile.ViewPort.top
						end,
						set = function (v)
							self.db.profile.ViewPort.top = v
							self:checkAndRun("ViewPort_top")
						end,
					},
					bottom = {
						name = self.L["VP Bottom"],
						desc = self.L["Change Height of the Bottom Band"],
						type = "range",
						step = 1,
						min = 0,
						max = 256,
						get = function ()
							return self.db.profile.ViewPort.bottom
						end,
						set = function (v)
							self.db.profile.ViewPort.bottom = v
							self:checkAndRun("ViewPort_bottom")
						end,
					},
					yres = {
						name = self.L["VP YResolution"],
						desc = self.L["Change Y Resolution"],
						type = "range",
						step = 2,
						min = 0,
						max = 2600,
						get = function ()
							return self.db.profile.ViewPort.YResolution
						end,
						set = function (v)
							self.db.profile.ViewPort.YResolution = v
							self.db.profile.ViewPort.YScaling = 768 / self.db.profile.ViewPort.YResolution
							self.initialized.ViewPort = nil
							self:checkAndRun("ViewPort")
						end,
					},
					left = {
						name = self.L["VP Left"],
						desc = self.L["Change Width of the Left Band"],
						type = "range",
						step = 1,
						min = 0,
						max = 1800,
						get = function ()
							return self.db.profile.ViewPort.left
						end,
						set = function (v)
							self.db.profile.ViewPort.left = v
							self:checkAndRun("ViewPort_left")
						end,
					},
					right = {
						name = self.L["VP Right"],
						desc = self.L["Change Width of the Right Band"],
						type = "range",
						step = 1,
						min = 0,
						max = 1800,
						get = function ()
							return self.db.profile.ViewPort.right
						end,
						set = function (v)
							self.db.profile.ViewPort.right = v
							self:checkAndRun("ViewPort_right")
						end,
					},
					xres = {
						name = self.L["VP XResolution"],
						desc = self.L["Change X Resolution"],
						type = "range",
						step = 2,
						min = 0,
						max = 1600,
						get = function ()
							return self.db.profile.ViewPort.XResolution
						end,
						set = function (v)
							self.db.profile.ViewPort.XResolution = v
							self.db.profile.ViewPort.XScaling =	 self.db.profile.ViewPort.XResolution / 1050
							self.initialized.ViewPort = nil
							self:checkAndRun("ViewPort")
						end,
					},
					overlay = {
						name = self.L["ViewPort Overlay"],
						desc = self.L["Toggle the ViewPort Overlay"],
						type = "toggle",
						get = function()
							return self.db.profile.ViewPort.overlay
						end,
						set = function (v)
							self.db.profile.ViewPort.overlay = v
							self.initialized.ViewPort = nil
							self:checkAndRun("ViewPort")
						end,
					},
					colour = {
						name = self.L["ViewPort Colors"],
						desc = self.L["Set ViewPort Colors"],
						type = "color",
						get = function()
							return self.db.profile.ViewPort.r, self.db.profile.ViewPort.g, self.db.profile.ViewPort.b, self.db.profile.ViewPort.a
						end,
						set = function(r, g, b, a)
							self.db.profile.ViewPort.r, self.db.profile.ViewPort.g, self.db.profile.ViewPort.b, self.db.profile.ViewPort.a = r, g, b, a
						end,
						hasAlpha = true,
					},
				},
			},
			topframe = {
				name = self.L["Top Frame"],
				desc = self.L["Change the TopFrame settings"],
				type = "group",
				args = {
					show = {
						name = self.L["TopFrame Show"],
						desc = self.L["Toggle the TopFrame"],
						type = "toggle",
						get = function()
							return self.db.profile.TopFrame.shown
						end,
						set = function (v)
							self.db.profile.TopFrame.shown = v
							if self.initialized.TopFrame then
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
						order = 50,
					},
					height = {
						name = self.L["TF Height"],
						desc = self.L["Change Height of the TopFrame"],
						type = "range",
						step = 1,
						min = 0,
						max = 500,
						get = function ()
							return self.db.profile.TopFrame.height
						end,
						set = function (v)
							self.db.profile.TopFrame.height = v
							if self.initialized.TopFrame then
								self.topframe:SetHeight(v)
								self:adjustTFOffset(nil)
							end
						end,
					},
					width = {
						name = self.L["TF Width"],
						desc = self.L["Change Width of the TopFrame"],
						type = "range",
						step = 1,
						min = 0,
						max = 2000,
						get = function ()
							return self.db.profile.TopFrame.width
						end,
						set = function (v)
							self.db.profile.TopFrame.width = v
							if self.initialized.TopFrame then
								self.topframe:SetWidth(v)
							end
						end,
					},
					fadeheight = {
						name = self.L["TF Fade Height"],
						desc = self.L["Change the Height of the Fade Effect"],
						type = "range",
						step = 1,
						min = 0,
						max = 500,
						get = function ()
							return self.db.profile.TopFrame.fheight
						end,
						set = function (v)
							self.db.profile.TopFrame.fheight = v
							if self.initialized.TopFrame then
								if self.db.profile.FadeHeight.enable and self.db.profile.FadeHeight.force then
								-- set the Fade Height to the global value if 'forced'
								-- making sure that it isn't greater than the frame height
									fh = self.db.profile.FadeHeight.value <= math.ceil(self.topframe:GetHeight()) and self.db.profile.FadeHeight.value or math.ceil(self.topframe:GetHeight())
								elseif self.db.profile.TopFrame.fheight then
									fh = self.db.profile.TopFrame.fheight <= math.ceil(self.topframe:GetHeight()) and self.db.profile.TopFrame.fheight or math.ceil(self.topframe:GetHeight())
								end
								if self.db.profile.TopFrame.invert then self.topframe.tfade:SetPoint("TOPRIGHT", self.topframe, "BOTTOMRIGHT", 4, (fh - 4))
								else self.topframe.tfade:SetPoint("BOTTOMRIGHT", self.topframe, "TOPRIGHT", -4, -(fh - 4)) end
							end
						end,
					},
					xyOff = {
						name = self.L["TF Move Origin offscreen"],
						desc = self.L["Hide Border on Left and Top"],
						type = "toggle",
						get = function ()
							return self.db.profile.TopFrame.xyOff
						end,
						set = function (v)
							self.db.profile.TopFrame.xyOff = v
							if self.initialized.TopFrame then
								if self.db.profile.TopFrame.xyOff then
									self.topframe:SetPoint("TOPLEFT", UIParent, "TOPLEFT", -6, 6)
								else
									self.topframe:SetPoint("TOPLEFT", UIParent, "TOPLEFT", -3, 3)
								end
							end
						end,
					},
					borderOff = {
						name = self.L["TF Toggle Border"],
						desc = self.L["Toggle the Border"],
						type = "toggle",
						get = function ()
							return self.db.profile.TopFrame.borderOff
						end,
						set = function (v)
							self.db.profile.TopFrame.borderOff = v
						end,
					},
					alpha = {
						name = self.L["TF Alpha"],
						desc = self.L["Change Alpha value of the TopFrame"],
						type = "range",
						step = 0.1,
						min = 0,
						max = 1,
						get = function ()
							return self.db.profile.TopFrame.alpha
						end,
						set = function (v)
							self.db.profile.TopFrame.alpha = v
						end,
					},
					invert = {
						name = self.L["TF Invert Gradient"],
						desc = self.L["Toggle the Inversion of the Gradient"],
						type = "toggle",
						get = function ()
							return self.db.profile.TopFrame.invert
						end,
						set = function (v)
							self.db.profile.TopFrame.invert = v
						end,
					},
					rotate = {
						name = self.L["TF Rotate Gradient"],
						desc = self.L["Toggle the Rotation of the Gradient"],
						type = "toggle",
						get = function()
							return self.db.profile.TopFrame.rotate
						end,
						set = function (v)
							self.db.profile.TopFrame.rotate = v
						end,
					},
				},
			},
			middleframe = {
				name = self.L["Middle Frame(s)"],
				desc = self.L["Change the MiddleFrame(s) settings"],
				type = "group",
				args = {
					fadeheight = {
						name = self.L["MF Fade Height"],
						desc = self.L["Change the Height of the Fade Effect"],
						type = "range",
						step = 1,
						min = 0,
						max = 500,
						get = function ()
							return self.db.profile.MiddleFrame.fheight
						end,
						set = function (v)
							self.db.profile.MiddleFrame.fheight = v
						end,
					},
					borderOff = {
						name = self.L["MF Toggle Border"],
						desc = self.L["Toggle the Border"],
						type = "toggle",
						get = function ()
							return self.db.profile.MiddleFrame.borderOff
						end,
						set = function (v)
							self.db.profile.MiddleFrame.borderOff = v
						end,
					},
					colour = {
						name = self.L["MF Colour"],
						desc = self.L["Change the Colour of the MiddleFrame(s)"],
						type = "color",
						get = function()
							return self.db.profile.MiddleFrame.r, self.db.profile.MiddleFrame.g, self.db.profile.MiddleFrame.b, self.db.profile.MiddleFrame.a
						end,
						set = function(r, g, b, a)
							self.db.profile.MiddleFrame.r, self.db.profile.MiddleFrame.g, self.db.profile.MiddleFrame.b, self.db.profile.MiddleFrame.a = r, g, b, a
						end,
						hasAlpha = true,
					},
					lock = {
						name = self.L["MF Lock Frames"],
						desc = self.L["Toggle the Frame Lock"],
						type = "toggle",
						get = function ()
							return self.db.profile.MiddleFrame.lock
						end,
						set = function (v)
							self.db.profile.MiddleFrame.lock = v
							for i = 1, 9 do
								if self.db.profile["MiddleFrame"..i].shown then
									if self.db.profile.MiddleFrame.lock then
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
			bottomframe = {
				name = self.L["Bottom Frame"],
				desc = self.L["Change the BottomFrame settings"],
				type = "group",
				args = {
					show = {
						name = self.L["BottomFrame Show"],
						desc = self.L["Toggle the BottomFrame"],
						type = "toggle",
						get = function()
							return self.db.profile.BottomFrame.shown
						end,
						set = function (v)
							self.db.profile.BottomFrame.shown = v
							if self.initialized.BottomFrame then
								if self.bottomframe:IsVisible() then
									self.bottomframe:Hide()
								else
									self.bottomframe:Show()
								end
							else
								self:checkAndRun("BottomFrame")
							end
						end,
						order = 50,
					},
					height = {
						name = self.L["BF Height"],
						desc = self.L["Change Height of the BottomFrame"],
						type = "range",
						step = 1,
						min = 0,
						max = 500,
						get = function ()
							return self.db.profile.BottomFrame.height
						end,
						set = function (v)
							self.db.profile.BottomFrame.height = v
							if self.initialized.BottomFrame then
								self.bottomframe:SetHeight(v)
							end
						end,
					},
					width = {
						name = self.L["BF Width"],
						desc = self.L["Change Width of the BottomFrame"],
						type = "range",
						step = 1,
						min = 0,
						max = 2000,
						get = function ()
							return self.db.profile.BottomFrame.width
						end,
						set = function (v)
							self.db.profile.BottomFrame.width = v
							if self.initialized.BottomFrame then
								self.bottomframe:SetWidth(v)
							end
						end,
					},
					fadeheight = {
						name = self.L["BF Fade Height"],
						desc = self.L["Change the Height of the Fade Effect"],
						type = "range",
						step = 1,
						min = 0,
						max = 500,
						get = function ()
							return self.db.profile.BottomFrame.fheight
						end,
						set = function (v)
							self.db.profile.BottomFrame.fheight = v
							if self.initialized.BottomFrame then
								if self.db.profile.FadeHeight.enable and self.db.profile.FadeHeight.force then
								-- set the Fade Height to the global value if 'forced'
								-- making sure that it isn't greater than the frame height
									fh = self.db.profile.FadeHeight.value <= math.ceil(self.bottomframe:GetHeight()) and self.db.profile.FadeHeight.value or math.ceil(self.bottomframe:GetHeight())
								elseif self.db.profile.BottomFrame.fheight then
									fh = self.db.profile.BottomFrame.fheight <= math.ceil(self.bottomframe:GetHeight()) and self.db.profile.BottomFrame.fheight or math.ceil(self.bottomframe:GetHeight())
								end
								if self.db.profile.BottomFrame.invert then self.bottomframe.tfade:SetPoint("TOPRIGHT", self.bottomframe, "BOTTOMRIGHT", 4, (fh - 4))
								else self.bottomframe.tfade:SetPoint("BOTTOMRIGHT", self.bottomframe, "TOPRIGHT", -4, -(fh - 4)) end
							end
						end,
					},
					xyOff = {
						name = self.L["BF Move Origin offscreen"],
						desc = self.L["Hide Border on Left and Bottom"],
						type = "toggle",
						get = function ()
							return self.db.profile.BottomFrame.xyOff
						end,
						set = function (v)
							self.db.profile.BottomFrame.xyOff = v
							if self.initialized.BottomFrame then
								if self.db.profile.BottomFrame.xyOff then
									self.bottomframe:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", -6, -6)
								else
									self.bottomframe:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", -3, -3)
								end
							end
						end,
					},
					borderOff = {
						name = self.L["BF Toggle Border"],
						desc = self.L["Toggle the Border"],
						type = "toggle",
						get = function ()
							return self.db.profile.BottomFrame.borderOff
						end,
						set = function (v)
							self.db.profile.BottomFrame.borderOff = v
						end,
					},
					alpha = {
						name = self.L["BF Alpha"],
						desc = self.L["Change Alpha value of the BottomFrame"],
						type = "range",
						step = 0.1,
						min = 0,
						max = 1,
						get = function ()
							return self.db.profile.BottomFrame.alpha
						end,
						set = function (v)
							self.db.profile.BottomFrame.alpha = v
						end,
					},
					invert = {
						name = self.L["BF Invert Gradient"],
						desc = self.L["Toggle the Inversion of the Gradient"],
						type = "toggle",
						get = function ()
							return self.db.profile.BottomFrame.invert
						end,
						set = function (v)
							self.db.profile.BottomFrame.invert = v
						end,
					},
					rotate = {
						name = self.L["BF Rotate Gradient"],
						desc = self.L["Toggle the Rotation of the Gradient"],
						type = "toggle",
						get = function()
							return self.db.profile.BottomFrame.rotate
						end,
						set = function (v)
							self.db.profile.BottomFrame.rotate = v
						end,
					},
				},
			},
			statusbar = {
				name = self.L["StatusBar"],
				desc = self.L["Change the StatusBar settings"],
				type = "group",
				args = {
					texture = {
						name = self.L["Texture"],
						desc = self.L["Choose the Texture for the Status Bars"],
						type = 'text',
						get = function()
							return self.db.profile.StatusBar.texture
						end,
						set = function(v)
							self.db.profile.StatusBar.texture = v
							self:checkAndRun("updateSBTexture")
						end,
						validate = self.LSM:List("statusbar", v),
					},
					bgcolour = {
						name = self.L["Background Colour"],
						desc = self.L["Change the Colour of the Status Bar Background"],
						type = "color",
						get = function()
							return self.db.profile.StatusBar.r, self.db.profile.StatusBar.g, self.db.profile.StatusBar.b, self.db.profile.StatusBar.a
						end,
						set = function(r, g, b, a)
							self.db.profile.StatusBar.r, self.db.profile.StatusBar.g, self.db.profile.StatusBar.b, self.db.profile.StatusBar.a = r, g, b, a
							self:checkAndRun("updateSBTexture")
						end,
						hasAlpha = true,
					},
				},
			},
			char = {
				name = self.L["Character Frames"],
				desc = self.L["Change the Character Frames settings"],
				type = "group",
				args = {
					none = {
						name = self.L["Disable all Character Frames"],
						desc = self.L["Disable all the Character Frames from being skinned"],
						type = "execute",
						func = function()
							for _, keyName in pairs(self.charKeys1) do
								self.db.profile[keyName] = false
							end
							for _, keyName in pairs(self.charKeys2) do
								self.db.profile[keyName].skin = false
							end
						end,
						order = 50,
					},
					character = {
						name = self.L["Character Frames"],
						desc = self.L["Toggle the skin of the Character Frames"],
						type = "toggle",
						get = function()
							return self.db.profile.CharacterFrames
						end,
						set = function(v)
							self.db.profile.CharacterFrames = v
							self:checkAndRun("CharacterFrames")
						end,
					},
					stable = {
						name = self.L["Stable Frame"],
						desc = self.L["Toggle the skin of the Stable Frame"],
						type = "toggle",
						get = function()
							return self.db.profile.PetStableFrame
						end,
						set = function(v)
							self.db.profile.PetStableFrame = v
							self:checkAndRun("PetStableFrame")
						end,
					},
					spellbook = {
						name = self.L["SpellBook Frame"],
						desc = self.L["Toggle the skin of the SpellBook Frame"],
						type = "toggle",
						get = function()
							return self.db.profile.SpellBookFrame
						end,
						set = function(v)
							self.db.profile.SpellBookFrame = v
							self:checkAndRun("SpellBookFrame")
						end,
					},
					talent = {
						name = self.L["Talent Frame"],
						desc = self.L["Toggle the skin of the Talent Frame"],
						type = "toggle",
						get = function()
							return self.db.profile.TalentFrame
						end,
						set = function(v)
							self.db.profile.TalentFrame = v
							if IsAddOnLoaded("Blizzard_TalentUI") then
								self:checkAndRun("TalentUI")
							end
						end,
					},
					dressup = {
						name = self.L["DressUP Frame"],
						desc = self.L["Toggle the skin of the DressUp Frame"],
						type = "toggle",
						get = function()
							return self.db.profile.DressUpFrame
						end,
						set = function(v)
							self.db.profile.DressUpFrame = v
							self:checkAndRun("DressUpFrame")
						end,
					},
					friends = {
						name = self.L["Social Frame"],
						desc = self.L["Toggle the skin of the Social Frame"],
						type = "toggle",
						get = function()
							return self.db.profile.FriendsFrame
						end,
						set = function(v)
							self.db.profile.FriendsFrame = v
							self:checkAndRun("FriendsFrame")
							end,
					},
					tradeskill = {
						name = self.L["Trade Skill Frame"],
						desc = self.L["Toggle the skin of the Trade Skill Frame"],
						type = "toggle",
						get = function()
							return self.db.profile.TradeSkill
						end,
						set = function(v)
							self.db.profile.TradeSkill = v
							if IsAddOnLoaded("Blizzard_TradeSkillUI") then
								self:checkAndRun("TradeSkillUI")
							end
						end,
					},
					craft = {
						name = self.L["Craft Frame"],
						desc = self.L["Toggle the skin of the Craft Frame"],
						type = "toggle",
						get = function()
							return self.db.profile.CraftFrame
						end,
						set = function(v)
							self.db.profile.CraftFrame = v
							if IsAddOnLoaded("Blizzard_CraftUI") then
								self:checkAndRun("CraftUI")
							end
						end,
					},
					trade = {
						name = self.L["Trade Frame"],
						desc = self.L["Toggle the skin of the Trade Frame"],
						type = "toggle",
						get = function()
							return self.db.profile.TradeFrame
						end,
						set = function(v)
							self.db.profile.TradeFrame = v
							self:checkAndRun("TradeFrame")
						end,
					},
					questlog = {
						name = self.L["Quest Log"],
						desc = self.L["Change the Quest Log settings"],
						type = "group",
						args = {
							skin = {
								name = self.L["Quest Log Skin"],
								desc = self.L["Toggle the skin of the Quest Log Frame"],
								type = "toggle",
								get = function()
									return self.db.profile.QuestLog.skin
								end,
								set = function (v)
									self.db.profile.QuestLog.skin = v
									self:checkAndRun("QuestLog")
								end,
								order = 50,
							},
							size = {
								name = self.L["Quest Watch Size"],
								desc = self.L["Set the Quest Watch Font Size (Normal, Small)"],
								type = "range",
								step = 1,
								min = 1,
								max = 2,
								get = function()
									return self.db.profile.QuestLog.size
								end,
								set = function (v)
									self.db.profile.QuestLog.size = v
									self:checkAndRun("ResizeQW")
								end,
							},
						},
					},
					raidui = {
						name = self.L["RaidUI Frame"],
						desc = self.L["Toggle the skin of the RaidUI Frame"],
						type = "toggle",
						get = function()
							return self.db.profile.RaidUI
						end,
						set = function(v)
							self.db.profile.RaidUI = v
							if IsAddOnLoaded("Blizzard_RaidUI") then
								self:checkAndRun("RaidUI")
							end
						end,
					},
					readycheck = {
						name = self.L["ReadyCheck Frame"],
						desc = self.L["Toggle the skin of the ReadyCheck Frame"],
						type = "toggle",
						get = function()
							return self.db.profile.ReadyCheck
						end,
						set = function(v)
							self.db.profile.ReadyCheck = v
							self:checkAndRun("ReadyCheck")
						end,
					},
					buffs = {
						name = self.L["Buffs Buttons"],
						desc = self.L["Toggle the skin of the Buffs Buttons"],
						type = "toggle",
						get = function()
							return self.db.profile.Buffs
						end,
						set = function(v)
							self.db.profile.Buffs = v
							self:checkAndRun("Buffs")
						end,
					},
					achievements = IsWotLK and {
						name = self.L["Achievements Frame"],
						desc = self.L["Toggle the skin of the Achievements Frame"],
						type = "toggle",
						get = function()
							return self.db.profile.Achievements
						end,
						set = function(v)
							self.db.profile.Achievements = v
							if IsAddOnLoaded("Blizzard_AchievementUI") then
								self:checkAndRun("AchievementUI")
							end
						end,
					} or nil,
				},
			},
			ui = {
				name = self.L["UI Frames"],
				desc = self.L["Change the UI Elements settings"],
				type = "group",
				args = {
					none = {
						name = self.L["Disable all UI Frames"],
						desc = self.L["Disable all the UI Frames from being skinned"],
						type = "execute",
						func = function()
							for _, keyName in pairs(self.uiKeys1) do
								self.db.profile[keyName] = false
							end
							for _, keyName in pairs(self.uiKeys2) do
								self.db.profile[keyName].skin = false
							end
						end,
						order = 50,
					},
					tooltip = {
						name = self.L["Tooltips"],
						desc = self.L["Change the Tooltip settings"],
						type = "group",
						args = {
							skin = {
								name = self.L["Tooltip Skin"],
								desc = self.L["Toggle the skin of the Tooltips"],
								type = "toggle",
								get = function()
									return self.db.profile.Tooltips.skin
								end,
								set = function (v)
									self.db.profile.Tooltips.skin = v
									self:checkAndRun("Tooltips")
								end,
								order = 50,
							},
							style = {
								name = self.L["Tooltips Style"],
								desc = self.L["Set the Tooltips style (Rounded, Flat, Custom)"],
								type = "range",
								step = 1,
								min = 1,
								max = 3,
								get = function()
									return self.db.profile.Tooltips.style
								end,
								set = function (v)
									self.db.profile.Tooltips.style = v
									if v == 3 then self:setTTBackdrop(true)
									else self:setTTBackdrop() end
								end,
							},
							glazesb = {
								name = self.L["Glaze Status Bar"],
								desc = self.L["Toggle the glazing Status Bar"],
								type = "toggle",
								get = function()
									return self.db.profile.Tooltips.glazesb
								end,
								set = function (v)
									self.db.profile.Tooltips.glazesb = v
									self:checkAndRun("Tooltips")
								end,
							},
							border = {
								name = self.L["Tooltips Border Colour"],
								desc = self.L["Set the Tooltips Border colour (Default, Custom)"],
								type = "range",
								step = 1,
								min = 1,
								max = 2,
								get = function()
									return self.db.profile.Tooltips.border
								end,
								set = function (v)
									self.db.profile.Tooltips.border = v
									self:checkAndRun("Tooltips")
								end,
							},
						},
					},
					timers = {
						name = self.L["Timer Frames"],
						desc = self.L["Change the Timer Settings"],
						type = "group",
						args = {
							skin = {
								name = self.L["Timer Skin"],
								desc = self.L["Toggle the skin of the Timer"],
								type = "toggle",
								get = function()
									return self.db.profile.MirrorTimers.skin
								end,
								set = function (v)
									self.db.profile.MirrorTimers.skin = v
									self:checkAndRun("MirrorTimers")
								end,
								order = 50,
							},
							glaze = {
								name = self.L["Glaze Timer"],
								desc = self.L["Toggle the glazing Timer"],
								type = "toggle",
								get = function()
									return self.db.profile.MirrorTimers.glaze
								end,
								set = function (v)
									self.db.profile.MirrorTimers.glaze = v
									self:checkAndRun("MirrorTimers")
								end,
							},
						},
					},
					castbar = {
						name = self.L["Casting Bar Frame"],
						desc = self.L["Change the Casting Bar Settings"],
						type = "group",
						args = {
							skin = {
								name = self.L["Casting Bar Skin"],
								desc = self.L["Toggle the skin of the Casting Bar"],
								type = "toggle",
								get = function()
									return self.db.profile.CastingBar.skin
								end,
								set = function (v)
									self.db.profile.CastingBar.skin = v
									self:checkAndRun("CastingBar")
								end,
								order = 50,
							},
							glaze = {
								name = self.L["Glaze Casting Bar"],
								desc = self.L["Toggle the glazing Casting Bar"],
								type = "toggle",
								get = function()
									return self.db.profile.CastingBar.glaze
								end,
								set = function (v)
									self.db.profile.CastingBar.glaze = v
									self:checkAndRun("CastingBar")
								end,
							},
						},
					},
					popups = {
						name = self.L["Static Popups"],
						desc = self.L["Toggle the skin of Static Popups"],
						type = "toggle",
						get = function()
							return self.db.profile.StaticPopups
						end,
						set = function(v)
							self.db.profile.StaticPopups = v
							self:checkAndRun("StaticPopups")
						end,
					},
					chatmenus = {
						name = self.L["Chat Menus"],
						desc = self.L["Toggle the skin of the Chat Menus"],
						type = "toggle",
						get = function()
							return self.db.profile.ChatMenus
						end,
						set = function(v)
							self.db.profile.ChatMenus = v
							self:checkAndRun("ChatMenus")
						end,
					},
					chatconfig = {
						name = self.L["Chat Config"],
						desc = self.L["Toggle the skinning of the Chat Config Frame"],
						type = "toggle",
						get = function()
							return self.db.profile.ChatConfig
						end,
						set = function(v)
							self.db.profile.ChatConfig = v
							self:checkAndRun("ChatConfig")
						end,
					},
					chattabs = {
						name = self.L["Chat Tabs"],
						desc = self.L["Toggle the skin of the Chat Tabs"],
						type = "toggle",
						get = function()
							return self.db.profile.ChatTabs
						end,
						set = function(v)
							self.db.profile.ChatTabs = v
							self:checkAndRun("ChatTabs")
						end,
					},
					chatframes = {
						name = self.L["Chat Frames"],
						desc = self.L["Toggle the skin of the Chat Frames"],
						type = "toggle",
						get = function()
							return self.db.profile.ChatFrames
						end,
						set = function(v)
							self.db.profile.ChatFrames = v
							self:checkAndRun("ChatFrames")
						end,
					},
					combatlogqbf = {
						name = self.L["CombatLog Quick Button Frame"],
						desc = self.L["Toggle the skin of the CombatLog Quick Button Frame"],
						type = "toggle",
						get = function()
							return self.db.profile.CombatLogQBF
						end,
						set = function(v)
							self.db.profile.CombatLogQBF = v
						end,
					},
					chateb = {
						name = self.L["Chat Edit Box"],
						desc = self.L["Change the Chat Edit Box settings"],
						type = "group",
						args = {
							skin = {
								name = self.L["Chat Edit Box Skin"],
								desc = self.L["Toggle the skin of the Chat Edit Box Frame"],
								type = "toggle",
								get = function()
									return self.db.profile.ChatEditBox.skin
								end,
								set = function (v)
									self.db.profile.ChatEditBox.skin = v
									self:checkAndRun("ChatEditBox")
								end,
								order = 50,
							},
							style = {
								name = self.L["Chat Edit Box Style"],
								desc = self.L["Set the Chat Edit Box style (Frame, EditBox)"],
								type = "range",
								step = 1,
								min = 1,
								max = 2,
								get = function()
									return self.db.profile.ChatEditBox.style
								end,
								set = function (v)
									self.db.profile.ChatEditBox.style = v
									self:checkAndRun("ChatEditBox")
								end,
							},
						},
					},
					loot = {
						name = self.L["Loot Frame"],
						desc = self.L["Toggle the skin of the Loot Frame"],
						type = "toggle",
						get = function()
							return self.db.profile.LootFrame
						end,
						set = function(v)
							self.db.profile.LootFrame = v
							self:checkAndRun("LootFrame")
						end,
					},
					grouploot = {
						name = self.L["Group Loot Frame"],
						desc = self.L["Change the GroupLoot settings"],
						type = "group",
						args = {
							skin = {
								name = self.L["GroupLoot Skin"],
								desc = self.L["Toggle the skin of the GroupLoot Frame"],
								type = "toggle",
								get = function()
									return self.db.profile.GroupLoot.skin
								end,
								set = function (v)
									self.db.profile.GroupLoot.skin = v
									self:checkAndRun("GroupLoot")
								end,
								order = 50,
							},
							size = {
								name = self.L["GroupLoot Size"],
								desc = self.L["Set the GroupLoot size (Normal, Small, Micro)"],
								type = "range",
								step = 1,
								min = 1,
								max = 3,
								get = function()
									return self.db.profile.GroupLoot.size
								end,
								set = function (v)
									self.db.profile.GroupLoot.size = v
									self:checkAndRun("GroupLoot")
								end,
							},
						},
					},
					container = {
						name = self.L["Container Frames"],
						desc = self.L["Change the Container Frames settings"],
						type = "group",
						args = {
							skin = {
								name = self.L["Containers Skin"],
								desc = self.L["Toggle the skin of the Container Frames"],
								type = "toggle",
								get = function()
									return self.db.profile.ContainerFrames.skin
								end,
								set = function (v)
									self.db.profile.ContainerFrames.skin = v
									self:checkAndRun("ContainerFrames")
								end,
								order = 50,
							},
							fadeheight = {
								name = self.L["CF Fade Height"],
								desc = self.L["Change the Height of the Fade Effect"],
								type = "range",
								step = 1,
								min = 0,
								max = 300,
								get = function ()
									return self.db.profile.ContainerFrames.fheight
								end,
								set = function (v)
									self.db.profile.ContainerFrames.fheight = v
									self:checkAndRun("ContainerFrames")
								end,
							},
						},
					},
					stack = {
						name = self.L["Stack Split Frame"],
						desc = self.L["Toggle the skin of the Stack Split Frame"],
						type = "toggle",
						get = function()
							return self.db.profile.StackSplit
						end,
						set = function(v)
							self.db.profile.StackSplit = v
							self:checkAndRun("StackSplit")
						end,
					},
					itemtext = {
						name = self.L["Item Text Frame"],
						desc = self.L["Toggle the skin of the Item Text Frame"],
						type = "toggle",
						get = function()
							return self.db.profile.ItemText
						end,
						set = function(v)
							self.db.profile.ItemText = v
							self:checkAndRun("ItemText")
						end,
					},
					colours = {
						name = self.L["Color Picker Frame"],
						desc = self.L["Toggle the skin of the Color Picker Frame"],
						type = "toggle",
						get = function()
							return self.db.profile.Colours
						end,
						set = function(v)
							self.db.profile.Colours = v
							self:checkAndRun("ColorPicker")
						end,
					},
					map = {
						name = self.L["World Map Frame"],
						desc = self.L["Toggle the skin of the World Map Frame"],
						type = "toggle",
						get = function()
							return self.db.profile.WorldMap
						end,
						set = function(v)
							self.db.profile.WorldMap = v
							self:checkAndRun("WorldMap")
						end,
					},
					help = {
						name = self.L["Help Frame"],
						desc = self.L["Toggle the skin of the Help Frame"],
						type = "toggle",
						get = function()
							return self.db.profile.HelpFrame
						end,
						set = function(v)
							self.db.profile.HelpFrame = v
							self:checkAndRun("HelpFrame")
						end,
					},
					inspect = {
						name = self.L["Inspect Frame"],
						desc = self.L["Toggle the skin of the Inspect Frame"],
						type = "toggle",
						get = function()
							return self.db.profile.Inspect
						end,
						set = function(v)
							self.db.profile.Inspect = v
							if IsAddOnLoaded("Blizzard_InspectUI") then
								self:checkAndRun("InspectUI")
							end
							end,
					},
					battlescore = {
						name = self.L["Battle Score Frame"],
						desc = self.L["Toggle the skin of the Battle Score Frame"],
						type = "toggle",
						get = function()
							return self.db.profile.BattleScore
						end,
						set = function(v)
							self.db.profile.BattleScore = v
							self:checkAndRun("BattleScore")
						end,
					},
					battlemm = {
						name = self.L["Battlefield Minimap Frame"],
						desc = self.L["Toggle the skin of the Battlefield Minimap Frame"],
						type = "toggle",
						get = function()
							return self.db.profile.BattlefieldMm
						end,
						set = function(v)
							self.db.profile.BattlefieldMm = v
							if IsAddOnLoaded("Blizzard_BattlefieldMinimap") then
								self:checkAndRun("BattlefieldMinimap")
							end
						end,
					},
					scripterrors = {
						name = self.L["Script Errors Frame"],
						desc = self.L["Toggle the skin of the Script Errors Frame"],
						type = "toggle",
						get = function()
							return self.db.profile.ScriptErrors
						end,
						set = function(v)
							self.db.profile.ScriptErrors = v
							self:checkAndRun("ScriptErrors")
						end,
					},
					tutorial = {
						name = self.L["Tutorial Frame"],
						desc = self.L["Toggle the skin of the Tutorial Frame"],
						type = "toggle",
						get = function()
							return self.db.profile.Tutorial
						end,
						set = function(v)
							self.db.profile.Tutorial = v
							self:checkAndRun("Tutorial")
						end,
					},
					dropdowns = {
						name = self.L["DropDowns"],
						desc = self.L["Toggle the skin of the DropDowns"],
						type = "toggle",
						get = function()
							return self.db.profile.DropDowns
						end,
						set = function(v)
							self.db.profile.DropDowns = v
							self:checkAndRun("DropDowns")
						end,
					},
					minimapbuttons = {
						name = self.L["Minimap Buttons"],
						desc = self.L["Toggle the skin of the Minimap Buttons"],
						type = "toggle",
						get = function()
							return self.db.profile.MinimapButtons
						end,
						set = function(v)
							self.db.profile.MinimapButtons = v
							self:checkAndRun("MinimapButtons")
						end,
					},
					minimapgloss = {
						name = self.L["Minimap Gloss Effect"],
						desc = self.L["Toggle the Gloss Effect for the Minimap"],
						type = "toggle",
						get = function()
							return self.db.profile.MinimapGloss
						end,
						set = function(v)
							self.db.profile.MinimapGloss = v
							if self.minimapskin then
								if not v then LowerFrameLevel(self.minimapskin)
								else RaiseFrameLevel(self.minimapskin) end
							end
						end,
					},
					movieprogress = IsMacClient and {
						name = self.L["Movie Progress"],
						desc = self.L["Toggle the skinning of Movie Progress"],
						type = "toggle",
						get = function()
							return self.db.profile.MovieProgress
						end,
						set = function(v)
							self.db.profile.MovieProgress = v
							self:checkAndRun("MovieProgress")
						end,
					} or nil,
					menu = {
						name = self.L["Menu Frames"],
						desc = self.L["Toggle the skin of the Menu Frames"],
						type = "toggle",
						get = function()
							return self.db.profile.MenuFrames
						end,
						set = function(v)
							self.db.profile.MenuFrames = v
							self:checkAndRun("MenuFrames")
						end,
					},
					bank = {
						name = self.L["Bank Frame"],
						desc = self.L["Toggle the skin of the Bank Frame"],
						type = "toggle",
						get = function()
							return self.db.profile.BankFrame
						end,
						set = function(v)
							self.db.profile.BankFrame = v
							self:checkAndRun("BankFrame")
						end,
					},
					mail = {
						name = self.L["Mail Frame"],
						desc = self.L["Toggle the skin of the Mail Frame"],
						type = "toggle",
						get = function()
							return self.db.profile.MailFrame
						end,
						set = function(v)
							self.db.profile.MailFrame = v
							self:checkAndRun("MailFrame")
						end,
					},
					auction = {
						name = self.L["Auction Frame"],
						desc = self.L["Toggle the skin of the Auction Frame"],
						type = "toggle",
						get = function()
							return self.db.profile.AuctionFrame
						end,
						set = function(v)
							self.db.profile.AuctionFrame = v
							if IsAddOnLoaded("Blizzard_AuctionUI") then
								self:checkAndRun("AuctionUI")
							end
						end,
					},
					mainbar = {
						name = self.L["Main Menu Bar"],
						desc = self.L["Change the Main Menu Bar Frame Settings"],
						type = "group",
						args = {
							skin = {
								name = self.L["Main Menu Bar Skin"],
								desc = self.L["Toggle the skin of the Main Menu Bar"],
								type = "toggle",
								get = function()
									return self.db.profile.MainMenuBar.skin
								end,
								set = function (v)
									self.db.profile.MainMenuBar.skin = v
									self:checkAndRun("MainMenuBar")
								end,
								order = 50,
							},
							glazesb = {
								name = self.L["Glaze Main Menu Bar Status Bar"],
								desc = self.L["Toggle the glazing Main Menu Bar Status Bar"],
								type = "toggle",
								get = function()
									return self.db.profile.MainMenuBar.glazesb
								end,
								set = function (v)
									self.db.profile.MainMenuBar.glazesb = v
									self:checkAndRun("MainMenuBar")
								end,
							},
						},
					},
					coins = {
						name = self.L["Coin Pickup Frame"],
						desc = self.L["Toggle the skin of the Coin Pickup Frame"],
						type = "toggle",
						get = function()
							return self.db.profile.CoinPickup
						end,
						set = function(v)
							self.db.profile.CoinPickup = v
							self:checkAndRun("CoinPickup")
						end,
					},
					gmsurveyui = {
						name = self.L["GM Survey UI Frame"],
						desc = self.L["Toggle the skin of the GM Survey UI Frame"],
						type = "toggle",
						get = function()
							return self.db.profile.GMSurveyUI
						end,
						set = function(v)
							self.db.profile.GMSurveyUI = v
							if IsAddOnLoaded("Blizzard_GMSurveyUI") then
								self:checkAndRun("GMSurveyUI")
							end
						end,
					},
					lfg = {
						name = self.L["LFG Frame"],
						desc = self.L["Toggle the skin of the LFG Frame"],
						type = "toggle",
						get = function()
							return self.db.profile.LFGFrame
						end,
						set = function(v)
							self.db.profile.LFGFrame = v
							self:checkAndRun("LFGFrame")
						end,
					},
					itemsocketingui = {
						name = self.L["ItemSocketingUI Frame"],
						desc = self.L["Toggle the skin of the ItemSocketingUI Frame"],
						type = "toggle",
						get = function()
							return self.db.profile.ItemSocketingUI
						end,
						set = function(v)
							self.db.profile.ItemSocketingUI = v
							if IsAddOnLoaded("Blizzard_ItemSocketingUI") then
								self:checkAndRun("ItemSocketingUI")
							end
						end,
					},
					guildbankui = {
						name = self.L["GuildBankUI Frame"],
						desc = self.L["Toggle the skin of the GuildBankUI Frame"],
						type = "toggle",
						get = function()
							return self.db.profile.GuildBankUI
						end,
						set = function(v)
							self.db.profile.GuildBankUI = v
							if IsAddOnLoaded("Blizzard_GuildBankUI") then
								self:checkAndRun("GuildBankUI")
							end
						end,
					},
					nameplates = {
						name = self.L["Nameplates"],
						desc = self.L["Toggle the skin of the Nameplates"],
						type = "toggle",
						get = function()
							return self.db.profile.Nameplates
						end,
						set = function(v)
							self.db.profile.Nameplates = v
							self:checkAndRun("Nameplates")
						end,
					},
					timemanager = {
						name = self.L["Time Manager"],
						desc = self.L["Toggle the skin of the Time Manager Frame"],
						type = "toggle",
						get = function()
							return self.db.profile.TimeManager
						end,
						set = function(v)
							self.db.profile.TimeManager = v
							self:checkAndRun("TimeManager")
						end,
					},
					calendar = IsWotLK and {
						name = self.L["Calendar"],
						desc = self.L["Toggle the skin of the Calendar Frame"],
						type = "toggle",
						get = function()
							return self.db.profile.Calendar
						end,
						set = function(v)
							self.db.profile.Calendar = v
							self:checkAndRun("Calendar")
						end,
					} or nil,
					feedback = IsPTR and {
						name = self.L["Feedback"],
						desc = self.L["Toggle the skin of the Feedback Frame"],
						type = "toggle",
						get = function()
							return self.db.profile.Feedback
						end,
						set = function(v)
							self.db.profile.Feedback = v
							self:checkAndRun("FeedbackUI")
						end,
					} or nil,
				},
			},
			npc = {
				name = self.L["NPC Frames"],
				desc = self.L["Change the NPC Frames settings"],
				type = "group",
				args = {
					none = {
						name = self.L["Disable all NPC Frames"],
						desc = self.L["Disable all the NPC Frames from being skinned"],
						type = "execute",
						func = function()
							for _, keyName in pairs(self.npcKeys) do
								self.db.profile[keyName] = false
							end
						end,
						order = 50,
					},
					merchant = {
						name = self.L["Merchant Frames"],
						desc = self.L["Toggle the skin of the Merchant Frame"],
						type = "toggle",
						get = function()
							return self.db.profile.MerchantFrames
						end,
						set = function(v)
							self.db.profile.MerchantFrames = v
							self:checkAndRun("MerchantFrames")
						end,
					},
					gossip = {
						name = self.L["Gossip Frame"],
						desc = self.L["Toggle the skin of the Gossip Frame"],
						type = "toggle",
						get = function()
							return self.db.profile.GossipFrame
						end,
						set = function(v)
							self.db.profile.GossipFrame = v
							self:checkAndRun("GossipFrame")
						end,
					},
					trainer = {
						name = self.L["Class Trainer Frame"],
						desc = self.L["Toggle the skin of the Class Trainer Frame"],
						type = "toggle",
						get = function()
							return self.db.profile.ClassTrainer
						end,
						set = function(v)
							self.db.profile.ClassTrainer = v
							if IsAddOnLoaded("Blizzard_TrainerUI") then
								self:checkAndRun("TrainerUI")
							end
						end,
					},
					taxi = {
						name = self.L["Taxi Frame"],
						desc = self.L["Toggle the skin of the Taxi Frame"],
						type = "toggle",
						get = function()
							return self.db.profile.TaxiFrame
						end,
						set = function(v)
							self.db.profile.TaxiFrame = v
							self:checkAndRun("TaxiFrame")
						end,
					},
					quest = {
						name = self.L["Quest Frame"],
						desc = self.L["Toggle the skin of the Quest Frame"],
						type = "toggle",
						get = function()
							return self.db.profile.QuestFrame
						end,
						set = function(v)
							self.db.profile.QuestFrame = v
							self:checkAndRun("QuestFrame")
						end,
					},
					battles = {
						name = self.L["Battlefields Frame"],
						desc = self.L["Toggle the skin of the Battlefields Frame"],
						type = "toggle",
						get = function()
							return self.db.profile.Battlefields
						end,
						set = function(v)
							self.db.profile.Battlefields = v
							self:checkAndRun("Battlefields")
						end,
					},
					arena = {
						name = self.L["Arena Frame"],
						desc = self.L["Toggle the skin of the Arena Frame"],
						type = "toggle",
						get = function()
							return self.db.profile.ArenaFrame
						end,
						set = function(v)
							self.db.profile.ArenaFrame = v
							self:checkAndRun("ArenaFrame")
						end,
					},
					arenaregistrar = {
						name = self.L["Arena Registrar Frame"],
						desc = self.L["Toggle the skin of the Arena Registrar Frame"],
						type = "toggle",
						get = function()
							return self.db.profile.ArenaRegistrar
						end,
						set = function(v)
							self.db.profile.ArenaRegistrar = v
							self:checkAndRun("ArenaRegistrar")
						end,
					},
					guildregistrar = {
						name = self.L["Guild Registrar Frame"],
						desc = self.L["Toggle the skin of the Guild Registrar Frame"],
						type = "toggle",
						get = function()
							return self.db.profile.GuildRegistrar
						end,
						set = function(v)
							self.db.profile.GuildRegistrar = v
							self:checkAndRun("GuildRegistrar")
						end,
					},
					petition = {
						name = self.L["Petition Frame"],
						desc = self.L["Toggle the skin of the Petition Frame"],
						type = "toggle",
						get = function()
							return self.db.profile.Petition
						end,
						set = function(v)
							self.db.profile.Petition = v
							self:checkAndRun("Petition")
						end,
					},
					tabard = {
						name = self.L["Tabard Frame"],
						desc = self.L["Toggle the skin of the Tabard Frame"],
						type = "toggle",
						get = function()
							return self.db.profile.Tabard
						end,
						set = function(v)
							self.db.profile.Tabard = v
							self:checkAndRun("Tabard")
						end,
					},
					barbershop = IsWotLK and {
						name = self.L["Barbershop Frame"],
						desc = self.L["Toggle the skin of the Barbershop Frame"],
						type = "toggle",
						get = function()
							return self.db.profile.Barbershop
						end,
						set = function(v)
							self.db.profile.Barbershop = v
							if IsAddOnLoaded("Blizzard_BarbershopUI") then
								self:checkAndRun("BarbershopUI")
							end
						end,
					} or nil,
				},
			},
			tracker = {
				name = self.L["Skin Tracker Frame"],
				desc = self.L["Toggle the skin of the Tracker Frame"],
				type = "toggle",
				get = function()
					return self.db.profile.TrackerFrame
				end,
				set = function(v)
					self.db.profile.TrackerFrame = v
				end,
				order = 200,
			},
		},
	}

	-- setup middleframe(s) options
	for i = 1, 9 do

		mfkey = {}
		mfkey.name = self.L["Middle Frame"..i]
		mfkey.desc = self.L["Change MiddleFrame"..i.." settings"]
		mfkey.type = "group"
		mfkey.order = i * 10
		mfkey.args = {}
		mfkey.args.show = {}
		mfkey.args.show.name = self.L["MiddleFrame"..i.." Show"]
		mfkey.args.show.desc = self.L["Toggle the MiddleFrame"..i]
		mfkey.args.show.type = "toggle"
		mfkey.args.show.order = 10
		mfkey.args.show.get = function() return self.db.profile["MiddleFrame"..i].shown end
		mfkey.args.show.set = function(v)
			self.db.profile["MiddleFrame"..i].shown = v
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
		mfkey.args.level = {}
		mfkey.args.level.name = self.L["MF"..i.." Frame Level"]
		mfkey.args.level.desc = self.L["Change the MF"..i.." Frame Level"]
		mfkey.args.level.type = "range"
		mfkey.args.level.step = 1
		mfkey.args.level.min = 0
		mfkey.args.level.max = 20
		mfkey.args.level.get = function() return self.db.profile["MiddleFrame"..i].flevel end
		mfkey.args.level.set = function(v)
			self.db.profile["MiddleFrame"..i].flevel = v
			self["middleframe"..i]:SetFrameLevel(self.db.profile["MiddleFrame"..i].flevel)
		end
		mfkey.args.strata = {}
		mfkey.args.strata.name = self.L["MF"..i.." Frame Strata"]
		mfkey.args.strata.desc = self.L["Change the MF"..i.." Frame Strata"]
		mfkey.args.strata.type = "text"
		mfkey.args.strata.usage = "<Choose a Frame Strata>"
		mfkey.args.strata.get = function() return self.db.profile["MiddleFrame"..i].fstrata end
		mfkey.args.strata.set = function(v)
			self.db.profile["MiddleFrame"..i].fstrata = v
			self["middleframe"..i]:SetFrameStrata(self.db.profile["MiddleFrame"..i].fstrata)
		end
		mfkey.args.strata.validate = FrameStrata

		self.options.args.middleframe.args["mf"..i] = mfkey

	end

end
