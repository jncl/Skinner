local aName, aObj = ...

local _G = _G

aObj.SetupDefaults = function(self)

	local defaults = {
		profile = {
		-- General
			Warnings                   = true,
			Errors                     = true,
			MinimapIcon                = {hide = false, minimapPos = 210, radius = 80},
			FrameBorders               = true,
			-- Tab and DropDown Texture settings [changed 03.10.22 to allow defaults function to reset values correctly]
			TabDDTextures			   = {texturedtab = false, textureddd = false, tabddfile = "None", tabddtex = aName .. " Inactive Tab"},
			Delay                      = {Init = 0.5, Addons = 0.5},
			FadeHeight                 = {enable = false, value = 500, force = false},
			StatusBar                  = {texture = "Blizzard", r = 0, g = 0.5, b = 0.5, a = 0.5},
		-- Backdrop Settings
			BdDefault                  = true,
			BdFile                     = "None",
			BdTexture                  = "Blizzard ChatFrame Background",
			BdTileSize                 = 16,
			BdEdgeFile                 = "None",
			BdBorderTexture            = "Blizzard Tooltip",
			BdEdgeSize                 = 16,
			BdInset                    = 4,
		-- Background Texture settings
			BgUseTex                   = false,
			BgFile                     = "None",
			BgTexture                  = "None",
			BgTile                     = false,
			DUTexture                  = true,
			LFGTexture                 = false,
		-- Colours
			ClassClrBd                 = false,
			ClassClrBg                 = false,
			ClassClrGr                 = false,
			ClassClrTT                 = false,
			TooltipBorder              = _G.CreateColor(0.5, 0.5, 0.5, 1),
			Backdrop                   = _G.CreateColor(0, 0, 0, 0.9),
			BackdropBorder             = _G.CreateColor(0.5, 0.5, 0.5, 1),
			SliderBorder               = _G.CreateColor(0.2, 0.2, 0.2, 1),
			HeadText                   = _G.CreateColor(0.8, 0.8, 0, 1),
			BodyText                   = _G.CreateColor(0.6, 0.6, 0, 1),
			IgnoredText                = _G.CreateColor(0.5, 0.5, 0, 1),
			DisabledText               = _G.CreateColor(0.3, 0.3, 0, 1),
			GradientMin                = _G.CreateColor(0.1, 0.1, 0.1, 0),
			GradientMax                = _G.CreateColor(0.25, 0.25, 0.25, 1),
			BagginsBBC                 = _G.CreateColor(0.5, 0.5, 0.5, 1),
		-- Gradient
			Gradient                   = {enable = true, invert = false, rotate = false, char = true, ui = true, npc = true, skinner = true, addon = true, texture = "Blizzard ChatFrame Background"},
		-- Modules (populated below)
		-- NPC Frames
			DisableAllNPC              = false,
		-- Player Frames
			DisableAllP                = false,
			AchievementUI              = not aObj.isClscERA and {skin = true, style = 2} or nil,
			CastingBar                 = {skin = true, glaze = true},
			CompactFrames              = {skin = true, sbars = true},
			ContainerFrames            = {skin = false, itmbtns = false, fheight = 100},
			LootFrames                 = {skin = true, size = 1},
			MirrorTimers               = {skin = true, glaze = true},
		-- UI Frames
			DisableAllUI               = false,
			ChatBubbles                = {skin = true, alpha = 0.45},
			ChatButtons                = true,
			ChatConfig                 = true,
			ChatEditBox                = {skin = true, style = 3},
			ChatFrames                 = false, -- (inc ChatMinimizedFrames)
			ChatMenus                  = true,
			ChatTabs                   = false, -- (inc. ChatTemporaryWindow)
			ChatTabsFade               = true,
			CombatLogQBF               = not aObj.isClscERA and false or nil,
			MainMenuBar                = {skin = true, glazesb = true, actbtns = false, altpowerbar = not aObj.isClscERA and true or nil},
			Minimap                    = {skin = false, gloss = false},
			MinimapButtons             = {skin = false, style = false},
			Tooltips                   = {skin = true, style = 1, glazesb = true, border = 1},
			WorldMap                   = {skin = true, size = 1},
		-- Disabled Skins
			DisableAllAS               = false,
			DisabledSkins              = {},
		-- Profiles (populated below)

		},
	}

	if not self.db then
		self.db = _G.LibStub:GetLibrary("AceDB-3.0", true):New(aName .. "DB", defaults, true)
	end

end

aObj.SetupOptions = function(self)

	local db = self.db.profile
	local dflts = self.db.defaults.profile

	local aVersion = _G.C_AddOns.GetAddOnMetadata(aName, "Version") or ""

	local function reskinIOFBackdrop()
		-- show changes by reskinning the Interface Options Frame with the new settings
		aObj:setupBackdrop()
		_G.SettingsPanel.sf:SetBackdrop(aObj.backdrop)
		_G.SettingsPanel.sf:SetBackdropColor(aObj.bClr:GetRGBA())
		_G.SettingsPanel.sf:SetBackdropBorderColor(aObj.bbClr:GetRGBA())
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
					name = _G.strjoin(" ", self.L["UI Enhancement"], "-", aVersion, "\n"),
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
				},
				Warnings = {
					type = "toggle",
					order = 4,
					name = self.L["Show Warnings"],
				},
				MinimapIcon = {
					type = "toggle",
					order = 5,
					name = self.L["Minimap icon"],
					get = function(info) return not db[info[1]].hide end,
					set = function(info, value)
						db[info[1]].hide = not value
						if value then self.DBIcon:Show(aName) else self.DBIcon:Hide(aName) end
					end,
					hidden = function() return not self.DBIcon end,
				},
				FrameBorders = {
					type = "toggle",
					order = 7,
					name = self.L["Frame Borders"],
					desc = self.L["No Background or Gradient texture"],
				},
				TabDDTextures = {
					type = "group",
					order = 10,
					inline = true,
					name = self.L["Inactive Tab & DropDown Texture Settings"],
					get = function(info) return db[info[1]][info[#info]] end,
					-- use this function when all AddOn have been changed
					-- set = function(info, value) db[info[1]][info[#info]] = value end,
					args = {
						textureddd = {
							type = "toggle",
							order = 1,
							name = self.L["Textured DropDown"],
							set = function(info, value)
								db[info[1]][info[#info]] = value
								-- store without parent name until all AddOn changed
								db.TexturedDD = value
							end,
						},
						texturedtab = {
							type = "toggle",
							order = 2,
							name = self.L["Textured Tab"],
							set = function(info, value)
								db[info[1]][info[#info]] = value
								self.isTT = db[info[1]][info[#info]] and true or false
								-- store without parent name until all AddOn changed
								db.TexturedTab = value
							end,
						},
						tabddfile = {
							type = "input",
							order = 3,
							width = "full",
							name = self.L["Inactive Tab & DropDown Texture File"],
							set = function(info, value)
								db[info[1]][info[#info]] = value
								-- store without parent name until all AddOn changed
								db.TabDDFile = value
							end,
						},
						tabddtex = _G.AceGUIWidgetLSMlists and {
							type = "select",
							order = 4,
							width = "double",
							name = self.L["Inactive Tab & DropDown Texture"],
							dialogControl = "LSM30_Background",
							values = _G.AceGUIWidgetLSMlists.background,
							set = function(info, value)
								db[info[1]][info[#info]] = value
								-- store without parent name until all AddOn changed
								db.TabDDTexture = value
							end,
						} or nil,
					},
				},
				Delay = {
					type = "group",
					order = 12,
					inline = true,
					name = self.L["Skinning Delays"],
					get = function(info) return db[info[1]][info[#info]] end,
					set = function(info, value) db[info[1]][info[#info]] = value end,
					args = {
						Init = {
							type = "range",
							order = 1,
							name = self.L["Initial Delay"],
							min = 0, max = 10, step = 0.5,
						},
						Addons = {
							type = "range",
							order = 2,
							name = self.L["Addons Delay"],
							min = 0, max = 10, step = 0.5,
						},
					},
				},
				FadeHeight = {
					type = "group",
					order = 14,
					inline = true,
					name = self.L["Fade Height"],
					get = function(info) return db[info[1]][info[#info]] end,
					set = function(info, value) db[info[1]][info[#info]] = value end,
					args = {
						enable = {
							type = "toggle",
							order = 1,
							name = self.L["Global Fade Height"],
						},
						value = {
							type = "range",
							order = 2,
							name = self.L["Fade Height value"],
							min = 0, max = 1000, step = 10,
						},
						force = {
							type = "toggle",
							order = 3,
							width = "double",
							name = self.L["Force the Global Fade Height"],
						},
					},
				},
				StatusBar = {
					type = "group",
					order = 16,
					inline = true,
					name = self.L["Status Bar"],
					args = {
						texture = _G.AceGUIWidgetLSMlists and {
							type = "select",
							order = 1,
							name = self.L["Texture"],
							dialogControl = "LSM30_Statusbar",
							values = _G.AceGUIWidgetLSMlists.statusbar,
							get = function(info) return db[info[1]][info[#info]] end,
							set = function(info, value)
								db[info[1]][info[#info]] = value
								self:checkAndRun("updateSBTexture", "s") -- not an addon in its own right
							end,
						} or nil,
						bgcolour = {
							type = "color",
							order = 2,
							name = self.L["Background Colour"],
							hasAlpha = true,
							get = function(info)
								local c = db[info[1]]
								return c.r, c.g, c.b, c.a
							end,
							set = function(info, r, g, b, a)
								local c = db[info[1]]
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
				},
				BdFile = {
					type = "input",
					order = 2,
					width = "full",
					name = self.L["Backdrop Texture File"],
				},
				BdFile2 = {
					type = "input",
					order = 3,
					width = "full",
					name = self.L["Button/Tab/EditBox/Slider Backdrop Texture File"],
				},
				BdTexture = _G.AceGUIWidgetLSMlists and {
					type = "select",
					order = 5,
					width = "double",
					name = self.L["Backdrop Texture"],
					dialogControl = "LSM30_Background",
					values = _G.AceGUIWidgetLSMlists.background,
				} or nil,
				BdTileSize = {
					type = "range",
					order = 6,
					name = self.L["Backdrop TileSize"],
					min = 0, max = 128, step = 4,
				},
				BdEdgeFile = {
					type = "input",
					order = 8,
					width = "full",
					name = self.L["Border Texture File"],
				},
				BdBorderTexture = _G.AceGUIWidgetLSMlists and {
					type = "select",
					order = 9,
					width = "double",
					name = self.L["Border Texture"],
					dialogControl = 'LSM30_Border',
					values = _G.AceGUIWidgetLSMlists.border,
				} or nil,
				BdEdgeSize = {
					type = "range",
					order = 10,
					name = self.L["Border Width"],
					min = 0, max = 32, step = 1,
				},
				BdInset = {
					type = "range",
					order = 11,
					name = self.L["Border Inset"],
					min = 0, max = 16, step = 1,
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
				and info[#info] ~= "DUTexture"
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
				},
				BgFile = {
					type = "input",
					order = 2,
					width = "full",
					name = self.L["Background Texture File"],
				},
				BgTexture = _G.AceGUIWidgetLSMlists and {
					type = "select",
					order = 5,
					width = "double",
					name = self.L["Background Texture"],
					dialogControl = "LSM30_Background",
					values = _G.AceGUIWidgetLSMlists.background,
				} or nil,
				BgTile = {
					type = "toggle",
					order = 6,
					name = self.L["Tile Background"],
				},
				DUTexture = {
					type = "toggle",
					width = "double",
					name = self.L["Show Dressing Room Background Texture"],
				},
				LFGTexture = {
					type = "toggle",
					width = "double",
					name = self.L["Show LFG Background Texture"],
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
					return db[info[#info]]:GetRGBA()
				end
			end,
			set = function(info, r, g, b, a)
				local c
				if info[#info]:find("ClassClr") then
					if self.isMnln then
						c = {_G.C_ClassColor.GetClassColor(self.uCls):GetRGBA()}
					else
						c = {_G.GetClassColorObj(self.uCls):GetRGBA()}
					end
				end
				if info[#info] == "ClassClrBd" then
					db[info[#info]] = r
					if r then
						db.BackdropBorder:SetRGBA(c[1], c[2], c[3], 1)
						if _G.C_AddOns.IsAddOnLoaded("Baggins") then
							db.BagginsBBC:SetRGBA(c[1], c[2], c[3], 1)
						end
					else
						db.BackdropBorder:SetRGBA(dflts.BackdropBorder:GetRGBA())
						if _G.C_AddOns.IsAddOnLoaded("Baggins") then
							db.BagginsBBC:SetRGBA(dflts.BagginsBBC:GetRGBA())
						end
					end
				elseif info[#info] == "ClassClrBg" then
					db[info[#info]] = r
					if r then
						db.Backdrop:SetRGBA(c[1], c[2], c[3], 1)
					else
						db.Backdrop:SetRGBA(dflts.Backdrop:GetRGBA())
					end
				elseif info[#info] == "ClassClrGr" then
					db[info[#info]] = r
					if r then
						db.GradientMax:SetRGBA(c[1], c[2], c[3], 1)
					else
						db.GradientMax:SetRGBA(dflts.GradientMax:GetRGBA())
					end
				elseif info[#info] == "ClassClrTT" then
					db[info[#info]] = r
					if r then
						db.TooltipBorder:SetRGBA(c[1], c[2], c[3], 1)
					else
						db.TooltipBorder:SetRGBA(dflts.TooltipBorder:GetRGBA())
					end
				else
					db[info[#info]]:SetRGBA(r, g, b, a)
				end
			end,
			args = {
				ClassClrBd = {
					type = "toggle",
					order = 1,
					width = "double",
					name = self.L["Class Coloured Border"],
				},
				ClassClrBg = {
					type = "toggle",
					order = 2,
					width = "double",
					name = self.L["Class Coloured Background"],
				},
				ClassClrGr = {
					type = "toggle",
					order = 3,
					width = "double",
					name = self.L["Class Coloured Gradient"],
				},
				ClassClrTT = {
					type = "toggle",
					order = 4,
					width = "double",
					name = self.L["Class Coloured Tooltip"],
				},
				TooltipBorder = {
					type = "color",
					order = 6,
					width = "double",
					name = self.L["Tooltip Border Colour"],
					hasAlpha = true,
				},
				Backdrop = {
					type = "color",
					order = 7,
					width = "double",
					name = self.L["Backdrop Colour"],
					hasAlpha = true,
				},
				BackdropBorder = {
					type = "color",
					order = 8,
					width = "double",
					name = self.L["Backdrop Border Colour"],
					hasAlpha = true,
				},
				SliderBorder = {
					type = "color",
					order = 9,
					width = "double",
					name = self.L["Slider & EditBox Border Colour"],
					hasAlpha = true,
				},
				HeadText = {
					type = "color",
					order = 10,
					width = "double",
					name = self.L["Text Heading Colour"],
				},
				BodyText = {
					type = "color",
					order = 11,
					width = "double",
					name = self.L["Text Body Colour"],
				},
				IgnoredText = {
					type = "color",
					order = 12,
					width = "double",
					name = self.L["Ignored Text Colour"],
				},
				DisabledText = {
					type = "color",
					order = 12,
					width = "double",
					name = self.L["Disabled Text Colour"],
				},
				GradientMin = {
					type = "color",
					order = 20,
					width = "double",
					name = self.L["Gradient Minimum Colour"],
					hasAlpha = true,
				},
				GradientMax = {
					type = "color",
					order = 21,
					width = "double",
					name = self.L["Gradient Maximum Colour"],
					hasAlpha = true,
				},
				BagginsBBC = {
					type = "color",
					order = -1,
					width = "double",
					name = self.L["Baggins Bank Bags Colour"],
					hasAlpha = true,
					hidden = function() return _G.C_AddOns.IsAddOnLoaded("Baggins") and false or true end,
				},
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
				},
				texture = _G.AceGUIWidgetLSMlists and {
					type = "select",
					order = 2,
					width = "double",
					name = self.L["Gradient Texture"],
					dialogControl = "LSM30_Background",
					values = _G.AceGUIWidgetLSMlists.background,
				} or nil,
				invert = {
					type = "toggle",
					order = 3,
					width = "double",
					name = self.L["Invert Gradient"],
				},
				rotate = {
					type = "toggle",
					order = 4,
					width = "double",
					name = self.L["Rotate Gradient"],
				},
				char = {
					type = "toggle",
					order = 5,
					width = "double",
					name = self.L["Enable Character Frames Gradient"],
				},
				ui = {
					type = "toggle",
					order = 6,
					width = "double",
					name = self.L["Enable UserInterface Frames Gradient"],
				},
				npc = {
					type = "toggle",
					order = 7,
					width = "double",
					name = self.L["Enable NPC Frames Gradient"],
				},
				skinner = {
					type = "toggle",
					order = 8,
					width = "double",
					name = self.L["Enable Skinner Frames Gradient"],
				},
				addon = {
					type = "toggle",
					order = 9,
					width = "double",
					name = self.L["Enable AddOn Frames Gradient"],
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
					if _G.C_AddOns.IsAddOnLoaded("Blizzard_" .. info[#info]) then
						self:checkAndRun(info[#info], "n", true)
					end
				else self:checkAndRun(info[#info], "n") end
				-- treat GossipFrame, QuestFrame, QuestInfo & QuestLog/QuestMap as one
				-- as they all change the quest text colours
				if info[#info] == "GossipFrame" then
					db.QuestFrame = value
					db.QuestInfo = value
					if not self.isMnln then
						db.QuestLog = value
					else
						db.QuestMap = value
					end
				elseif info[#info] == "QuestFrame" then
					db.GossipFrame = value
					db.QuestInfo = value
					if not self.isMnln then
						db.QuestLog = value
					else
						db.QuestMap = value
					end
				elseif info[#info] == "QuestInfo" then
					db.GossipFrame = value
					db.QuestFrame = value
					if not self.isMnln then
						db.QuestLog = value
					else
						db.QuestMap = value
					end
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
					set = function(info, value) db[info[#info]] = value end,
				},
				head2 = {
					order = 3,
					type = "header",
					name = self.L["or choose which frames to skin"],
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
					if _G.C_AddOns.IsAddOnLoaded("Blizzard_" .. info[#info]) then
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
					set = function(info, value) db[info[#info]] = value end,
				},
				head2 = {
					order = 3,
					type = "header",
					name = self.L["or choose which frames to skin"],
				},
				AchievementUI = not self.isClscERA and {
					type = "group",
					inline = true,
					order = -1,
					name = self.L["Achievement UI"],
					get = function(info) return db.AchievementUI[info[#info]] end,
					set = function(info, value)
						db.AchievementUI[info[#info]] = value
						if _G.C_AddOns.IsAddOnLoaded("Blizzard_AchievementUI") then self:checkAndRun("AchievementUI", "p", true) end
					end,
					args = {
						skin = {
							type = "toggle",
							name = self.L["Skin Frame"],
						},
						style = {
							type = "range",
							name = self.L["Achievement Style"],
							desc = self.L["1 - Textured, 2 - Untextured"],
							min = 1, max = 2, step = 1,
						},
					},
				} or nil,
				CastingBar = {
					type = "group",
					inline = true,
					order = -1,
					name = self.L["Casting Bar Frames"],
					get = function(info) return db.CastingBar[info[#info]] end,
					set = function(info, value)
						db.CastingBar[info[#info]] = value
						self:checkAndRun("CastingBar", "p")
					end,
					args = {
						skin = {
							type = "toggle",
							order = 1,
							name = self.L["Skin Frames"],
						},
						glaze = {
							type = "toggle",
							order = 2,
							name = self.L["Glaze Frames"],
						},
					},
				},
				CompactFrames = {
					type = "group",
					inline = true,
					order = -1,
					name = self.L["Compact Frames"],
					get = function(info) return db.CompactFrames[info[#info]] end,
					set = function(info, value)
						db.CompactFrames[info[#info]] = value
						self:checkAndRun("CompactFrames", "p")
					end,
					args = {
						skin = {
							type = "toggle",
							order = 1,
							name = self.L["Skin Frames"],
						},
						sbars = {
							type = "toggle",
							order = 1,
							name = self.L["Skin Status Bars"],
						},
					},
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
							name = self.L["Skin Frames"],
						},
						itmbtns = self.isMnln and {
							type = "toggle",
							order = 2,
							name = self.L["Skin Item Buttons"],
						} or nil,
						fheight = {
							type = "range",
							order = 3,
							name = self.L["Fade Height"],
							min = 0, max = 300, step = 1,
						},
					},
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
							name = self.L["Skin Frames"],
						},
						size = {
							type = "range",
							order = 3,
							name = self.L["GroupLoot Size"],
							desc = self.L["1 - Normal, 2 - Small, 3 - Micro"],
							min = 1, max = 3, step = 1,
						},
					},
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
							name = self.L["Skin Frames"],
						},
						glaze = {
							type = "toggle",
							order = 2,
							name = self.L["Glaze Frames"],
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
				if info[#info] == "CombatLogQBF" then return
				elseif info[#info] == "ChatTabsFade" then return
				-- handle Blizzard LoD Addons
				elseif self.blizzLoDFrames.u[info[#info]] then
					if _G.C_AddOns.IsAddOnLoaded("Blizzard_" .. info[#info]) then
						self:checkAndRun(info[#info], "u", true)
					end
				-- treat GossipFrame, QuestFrame, QuestInfo & QuestLog/QuestMap as one
				-- as they all change the quest text colours
				elseif info[#info] == not self.isMnln and "QuestLog" or "QuestMap" then
					db.GossipFrame = value
					db.QuestFrame = value
					db.QuestInfo = value
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
					set = function(info, value) db[info[#info]] = value end,
				},
				head2 = {
					order = 3,
					type = "header",
					name = self.L["or choose which frames to skin"],
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
						},
						ChatConfig = {
							type = "toggle",
							order = 2,
							name = self.L["Chat Config Frame"],
						},
						ChatTabs = {
							type = "toggle",
							order = 3,
							name = self.L["Chat Tabs"],
						},
						ChatTabsFade = {
							type = "toggle",
							order = 4,
							name = self.L["Chat Tabs Fade"],
						},
						ChatFrames = {
							type = "toggle",
							order = 5,
							name = self.L["Chat Frames"],
						},
						ChatButtons = {
							type = "toggle",
							order = 6,
							name = self.L["Skin Buttons"],
						},
						CombatLogQBF = not self.isClscERA and {
							type = "toggle",
							width = "double",
							order = 7,
							name = self.L["CombatLog Quick Button Frame"],
						} or nil,
					},
				},
				ChatBubbles = {
					type = "group",
					inline = true,
					order = -1,
					name = self.L["Chat Bubbles"],
					get = function(info) return db.ChatBubbles[info[#info]] end,
					set = function(info, value)
						db.ChatBubbles[info[#info]] = value
						self:checkAndRun("ChatBubbles", "u")
					end,
					args = {
						skin = {
							type = "toggle",
							order = 1,
							name = self.L["Skin Frames"],
						},
						alpha = {
							type = "range",
							order = 2,
							name = self.L["Background Alpha"],
							min = 0, max = 1, step = 0.05,
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
							name = self.L["Skin Frames"],
						},
						style = {
							type = "range",
							order = 2,
							name = self.L["Chat Edit Box Style"],
							desc = self.L["1 - Frame, 2 - EditBox, 3 - Borderless"],
							min = 1, max = 3, step = 1,
						},
					},
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
							name = self.L["Skin Frame"],
						},
						glazesb = {
							type = "toggle",
							order = 2,
							name = self.L["Glaze Status Bar"],
						},
						altpowerbar = {
							type = "toggle",
							order = 3,
							name = self.L["Alternate Power Bars"],
						},
						actbtns = {
							hidden = not self:canSkinActionBtns(),
							type = "toggle",
							order = 4,
							name = self.L["Skin Action Buttons"],
						},
					},
				},
				Minimap = {
					type = "group",
					inline = true,
					order = -1,
					name = self.L["Minimap Options"],
					get = function(info) return db.Minimap[info[#info]] end,
					set = function(info, value)
						db.Minimap[info[#info]] = value
						if info[#info] == "skin" and value then self:checkAndRun("Minimap", "u")
						elseif info[#info] == "gloss" and _G.Minimap.sf then
							if value then
								_G.RaiseFrameLevel(_G.Minimap.sf)
							else
								_G.LowerFrameLevel(_G.Minimap.sf)
							end
						end
					end,
					args = {
						skin = {
							type = "toggle",
							name = self.L["Skin Frame"],
							order = 1,
						},
						gloss = {
							type = "toggle",
							name = self.L["Gloss Effect"],
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
						if info[#info] == "skin" and value then self:checkAndRun("MinimapButtons", "u")
						elseif info[#info] == "style" then
							db.MinimapButtons.skin = true
							self:checkAndRun("MinimapButtons", "u")
						end
					end,
					args = {
						skin = {
							type = "toggle",
							order = 1,
							name = self.L["Skin Buttons"],
						},
						style = {
							type = "toggle",
							name = self.L["Minimal Style"],
						},
					},
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
							name = self.L["Skin Frames"],
						},
						glazesb = {
							type = "toggle",
							order = 2,
							width = "double",
							name = self.L["Glaze Status Bar"],
						},
						style = {
							type = "range",
							order = 3,
							name = self.L["Tooltips Style"],
							desc = self.L["1 - Rounded, 2 - Flat, 3 - Custom"],
							min = 1, max = 3, step = 1,
						},
						border = {
							type = "range",
							order = 4,
							name = self.L["Tooltips Border Colour"],
							desc = self.L["1 - Default, 2 - Custom"],
							min = 1, max = 2, step = 1,
						},
					},
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
							name = self.L["Skin Frame"],
						},
						size = {
							type = "range",
							order = 2,
							name = self.L["World Map Size"],
							desc = self.L["1 - Normal, 2 - Fullscreen"],
							min = 1, max = 2, step = 1,
						},
					},
				},
			},
		},

		["Disabled Skins"] = {
			type = "group",
			name = self.L["Disable Addon/Library Skins"],
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
					name = self.L["Disable all Addon/Library Skins"],
					get = function(info) return db[info[#info]] end,
					set = function(info, value) db[info[#info]] = value end,
				},
				head2 = {
					order = 3,
					type = "header",
					name = self.L["or choose which Addon/Library skins to disable"],
				},
			},
		},

	}

	local npcOptTab = {
		["Auction House UI"] = not self.isClscERA and true or nil,
		["Bank Frame"]       = true,
		["Black Market UI"]  = not self.isClscERA and true or nil,
		["Gossip Frame"]     = true,
		["Guild Registrar"]  = {suff = "Frame"},
		["Merchant Frame"]   = true,
		["Petition"]         = {suff = "Frame"},
		["Quest Frame"]      = true,
		["Quest Info"]       = {suff = "Frame"},
		["Tabard"]           = {suff = "Frame"},
		["Taxi Frame"]       = true,
		["Trainer UI"]       = true,
	}
	self:setupFramesOptions(npcOptTab, "NPC")
	_G.wipe(npcOptTab)

	local pfOptTab = {
		["Archaeology UI"]    = not self.isClscERA and true or nil,
		["Buffs"]             = {suff = "Buttons"},
		["Character Frames"]  = true,
		["Collections"]       = self.isMnln and {pref = "Warband"} or self.isClsc and {suff = "Journal"} or nil,
		["Communities"]       = {pref = "Guild &"},
		["Dress Up Frame"]    = true,
		["Encounter Journal"] = self.isMnln and {desc = "Adventure Guide"} or self.isClsc and {desc = "Dungeon Journal"} or nil,
		["Equipment Flyout"]  = not self.isClscERA and true or nil,
		["Friends Frame"]     = {desc = "Social Frame"},
		["Inspect UI"]        = true,
		["Item Socketing UI"] = true,
		["Raid UI"]           = true,
		["Ready Check"]       = {suff = "Frame"},
		["Role Poll Popup"]   = not self.isClscERA and true or nil,
		["Trade Frame"]       = true,
	}
	self:setupFramesOptions(pfOptTab, "Player")
	_G.wipe(pfOptTab)

	local uiOptTab = {
		["Addon List"]            = {suff = "Frame"},
		["Alert Frames"]          = true,
		["Auto Complete"]         = {suff = "Frame"},
		["Battlefield Map"]       = {suff = "Frame"},
		["BN Frames"]             = {desc = "BattleNet Frames"},
		["Calendar"]              = true,
		["Cinematic Frame"]       = true,
		["Coin Pickup"]           = {suff = "Frame"},
		["Color Picker"]          = {suff = "Frame"},
		["Debug Tools"]           = {suff = "Frames"},
		["Destiny Frame"]         = not self.isClscERA and true or nil,
		["Event Trace"]           = true,
		["Ghost Frame"]           = not self.isClscERA and true or nil,
		["GM Chat UI"]            = true,
		["Guild Bank UI"]         = true,
		["Help Frame"]            = {desc = "Customer Support Frame"},
		["Item Text"]             = {suff = "Frame"},
		["Macro UI"]              = {desc = "Macros UI"},
		["Mail Frame"]            = true,
		["Menu"]                  = {desc = "Dropdown Frames"},
		["Menu Frames"]           = true,
		["Move Pad"]              = true,
		["Movie Frame"]           = true,
		["Navigation Bar"]        = not self.isClscERA and true or nil,
		["Override Action Bar"]   = not self.isClscERA and {desc = "Vehicle UI"} or nil,
		["Pet Battle UI"]         = not self.isClscERA and true or nil,
		["PTR Feedback"]          = _G.PTR_IssueReporter and {suff = "Frames"} or nil,
		["PVE Frame"]             = self.isClscERA and {desc = "Looking for Group"} or {desc = "Group Finder Frame"},
		["Queue Status Frame"]    = true,
		["Raid Frame"]            = true,
		["Report Frame"]          = true,
		["Settings"]              = {desc = "Options Frame"} or nil,
		["Shared Basic Controls"] = {desc = "Script Errors Frame"},
		["Stack Split"]           = {suff = "Frame"},
		["Static Popups"]         = true,
		["Text To Speech Frame"]  = true,
		["Time Manager"]          = {suff = "Frame"},
		["Tutorial"]              = {suff = "Frame"},
		["UI DropDown Menu"]      = {desc = "DropDown Panels"},
		["UI Widgets"]            = true,
	}
	self:setupFramesOptions(uiOptTab, "UI")
	_G.wipe(uiOptTab)

	for _, mod in self:IterateModules() do
		if mod:IsEnabled()
		and mod.GetOptions
		then
			self.optTables["Modules"].args[mod.name] = mod:GetOptions()
		end
	end

	self.ACR = _G.LibStub:GetLibrary("AceConfigRegistry-3.0", true)

	local function preLoadFunc()
		-- add Disabled Skins entries
		local function addDSOpt(name)
			aObj.optTables["Disabled Skins"].args[name] = {
				type = "toggle",
				name = name,
				width = name:len() > 21 and "double" or nil,
			}
		end
		for name, _ in _G.pairs(aObj.addonsToSkin) do
			if aObj:isAddonEnabled(name) then
				addDSOpt(name)
			end
		end
		for name, _ in _G.pairs(aObj.libsToSkin) do
			if _G.LibStub:GetLibrary(name, true) then
				addDSOpt(name .. " (Lib)")
			end
		end
		for name, _ in _G.pairs(aObj.lodAddons) do
			if aObj:isAddonEnabled(name) then
				addDSOpt(name .. " (LoD)")
			end
		end
		for name, _ in _G.pairs(aObj.otherAddons) do
			if aObj:isAddonEnabled(name) then
				addDSOpt(name)
			end
		end
	end
	local function postLoadFunc()
		local method
		if not aObj.isMnln then
			method = "default"
		else
			method = "OnDefault"
		end
		aObj.optionsFrames["Backdrop"][method] = function()
			for name, _ in _G.pairs(aObj.optTables["Backdrop"].args) do
				db[name] = dflts[name]
			end
			reskinIOFBackdrop()
			aObj.ACR:NotifyChange("Backdrop")
		end
		aObj.optionsFrames["Disabled Skins"][method] = function()
			db.DisableAllAS = false
			db.DisabledSkins = {}
			aObj.ACR:NotifyChange("Disabled Skins")
		end
	end
	-- create array of option keys
	local optKeys = _G.GetKeysArray(self.optTables)
	-- remove General entry
	_G.tDeleteItem(optKeys, "General")
	-- sort into alpha order
	_G.table.sort(optKeys)
	self:setupOptions(optKeys, {"Backdrop", "Modules", "Disabled Skins"}, preLoadFunc, postLoadFunc)

	local function chatCommand(input)
		aObj.callbacks:Fire("Options_Selected")
		if not input or input:trim() == "" then
			_G.Settings.OpenToCategory(aObj.L[aName])
		elseif aObj.optCheck[input:lower()] then
			_G.Settings.OpenToCategory(aObj.L[aName], aObj.optCheck[input:lower()])
		else
			_G.LibStub:GetLibrary("AceConfigCmd-3.0", true):HandleCommand(aName, aObj.L[aName], input)
		end
	end

	self:RegisterChatCommand(self.L[aName], chatCommand)
	self:RegisterChatCommand(self.L["Skin"], chatCommand)

	if not self.isMnln then
		local DBObj = _G.LibStub:GetLibrary("LibDataBroker-1.1", true):NewDataObject(aName, {
			type = "launcher",
			icon = aObj.tFDIDs.mpw01,
			OnClick = function()
				aObj.callbacks:Fire("Options_Selected")
				_G.Settings.OpenToCategory(aName, aObj.L[aName])
			end,
			OnTooltipShow = function(tooltip)
				tooltip:AddLine(aObj.L[aName])
				tooltip:AddLine(aObj.L["Click to open config panel"], 1, 1, 1)
			end,
		})
		self.DBIcon:Register(aName, DBObj, db.MinimapIcon)
	end

end
