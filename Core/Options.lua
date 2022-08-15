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
			-- Tab and DropDown Texture settings
			TexturedTab                = false,
			TexturedDD                 = false,
			TabDDFile                  = "None",
			TabDDTexture               = aName .. " Inactive Tab",
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
			CastingBar                 = {skin = true, glaze = true},
			ContainerFrames            = {skin = true, fheight = 100},
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
			CombatLogQBF               = not aObj.isClscERA and false or nil,
			MainMenuBar                = {skin = true, glazesb = true},
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
					get = function(_) return not db.MinimapIcon.hide end,
					set = function(_, value)
						db.MinimapIcon.hide = not value
						if value then self.DBIcon:Show(aName) else self.DBIcon:Hide(aName) end
					end,
					hidden = function() return not self.DBIcon end,
				},
				FrameBorders = {
					type = "toggle",
					order = 7,
					name = self.L["Frame Borders"],
					desc = self.L["Frame Borders"] .. " " .. self.L["have no Background or Gradient textures"],
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
						TabDDTexture = _G.AceGUIWidgetLSMlists and {
							type = "select",
							order = 4,
							width = "double",
							name = self.L["Inactive Tab & DropDown Texture"],
							desc = self.L["Choose the Texture for the Inactive Tab & DropDowns"],
							dialogControl = "LSM30_Background",
							values = _G.AceGUIWidgetLSMlists.background,
						} or nil,
					},
				},
				Delay = {
					type = "group",
					order = 12,
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
					order = 14,
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
					order = 16,
					inline = true,
					name = self.L["Status Bar"],
					args = {
						texture = _G.AceGUIWidgetLSMlists and {
							type = "select",
							order = 1,
							name = self.L["Texture"],
							desc = self.L["Choose the Texture for the Status Bars"],
							dialogControl = "LSM30_Statusbar",
							values = _G.AceGUIWidgetLSMlists.statusbar,
							get = function(_) return db.StatusBar.texture end,
							set = function(_, value)
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
							get = function(_)
								local c = db.StatusBar
								return c.r, c.g, c.b, c.a
							end,
							set = function(_, r, g, b, a)
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
				BdTexture = _G.AceGUIWidgetLSMlists and {
					type = "select",
					order = 3,
					width = "double",
					name = self.L["Backdrop Texture"],
					desc = self.L["Choose the Texture for the Backdrop"],
					dialogControl = "LSM30_Background",
					values = _G.AceGUIWidgetLSMlists.background,
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
				BdBorderTexture = _G.AceGUIWidgetLSMlists and {
					type = "select",
					order = 6,
					width = "double",
					name = self.L["Border Texture"],
					desc = self.L["Choose the Texture for the Border"],
					dialogControl = 'LSM30_Border',
					values = _G.AceGUIWidgetLSMlists.border,
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
				BgTexture = _G.AceGUIWidgetLSMlists and {
					type = "select",
					order = 3,
					width = "double",
					name = self.L["Background Texture"],
					desc = self.L["Choose the Texture for the Background"],
					dialogControl = "LSM30_Background",
					values = _G.AceGUIWidgetLSMlists.background,
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
					return db[info[#info]]:GetRGBA()
				end
			end,
			set = function(info, r, g, b, a)
				local c
				if info[#info]:find("ClassClr") then
					if self.isClsc then
						c = {_G.GetClassColorObj(self.uCls):GetRGBA()}
					else
						c = {_G.C_ClassColor.GetClassColor(self.uCls):GetRGBA()}
					end
				end
				if info[#info] == "ClassClrBd" then
					db[info[#info]] = r
					if r then
						db.BackdropBorder:SetRGBA(c[1], c[2], c[3], 1)
						if _G.IsAddOnLoaded("Baggins") then
							db.BagginsBBC:SetRGBA(c[1], c[2], c[3], 1)
						end
					else
						db.BackdropBorder:SetRGBA(dflts.BackdropBorder:GetRGBA())
						if _G.IsAddOnLoaded("Baggins") then
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
					name = self.L["Class Coloured "] .. self.L["Border"],
					desc = self.L["Use Class Colour for "] .. self.L["Border"],
				},
				ClassClrBg = {
					type = "toggle",
					order = 2,
					width = "double",
					name = self.L["Class Coloured "] .. self.L["Background"],
					desc = self.L["Use Class Colour for "] .. self.L["Background"],
				},
				ClassClrGr = {
					type = "toggle",
					order = 3,
					width = "double",
					name = self.L["Class Coloured "] .. self.L["Gradient"],
					desc = self.L["Use Class Colour for "] .. self.L["Gradient"],
				},
				ClassClrTT = {
					type = "toggle",
					order = 4,
					width = "double",
					name = self.L["Class Coloured "] .. self.L["Tooltip"],
					desc = self.L["Use Class Colour for "] .. self.L["Tooltip"],
				},
				TooltipBorder = {
					type = "color",
					order = 6,
					width = "double",
					name = self.L["Tooltip"] .. " " .. self.L["Border"] .. " " .. self.L["Colour"],
					desc = self.L["Set "] .. self.L["Tooltip"] .. " " .. self.L["Border"] .. " " .. self.L["Colour"],
					hasAlpha = true,
				},
				Backdrop = {
					type = "color",
					order = 7,
					width = "double",
					name = self.L["Backdrop"] .. " " .. self.L["Colour"],
					desc = self.L["Set "] .. self.L["Backdrop"] .. " " .. self.L["Colour"],
					hasAlpha = true,
				},
				BackdropBorder = {
					type = "color",
					order = 8,
					width = "double",
					name = self.L["Backdrop"] .. " " .. self.L["Border"] .. " " .. self.L["Colour"],
					desc = self.L["Set "] .. self.L["Backdrop"] .. " " .. self.L["Border"] .. " " .. self.L["Colour"],
					hasAlpha = true,
				},
				SliderBorder = {
					type = "color",
					order = 9,
					width = "double",
					name = self.L["Slider & EditBox"] .. " " .. self.L["Border"] .. " " .. self.L["Colour"],
					desc = self.L["Set "] .. self.L["Slider & EditBox"] .. " " .. self.L["Border"] .. " " .. self.L["Colour"],
					hasAlpha = true,
				},
				HeadText = {
					type = "color",
					order = 10,
					width = "double",
					name = self.L["Text Heading Colour"],
					desc = self.L["Set "] .. self.L["Text Heading Colour"],
				},
				BodyText = {
					type = "color",
					order = 11,
					width = "double",
					name = self.L["Text Body Colour"],
					desc = self.L["Set "] .. self.L["Text Body Colour"],
				},
				IgnoredText = {
					type = "color",
					order = 12,
					width = "double",
					name = self.L["Ignored Text Colour"],
					desc = self.L["Set "] .. self.L["Ignored Text Colour"],
				},
				GradientMin = {
					type = "color",
					order = 20,
					width = "double",
					name = self.L["Gradient Minimum Colour"],
					desc = self.L["Set "] .. self.L["Gradient Minimum Colour"],
					hasAlpha = true,
				},
				GradientMax = {
					type = "color",
					order = 21,
					width = "double",
					name = self.L["Gradient Maximum Colour"],
					desc = self.L["Set "] .. self.L["Gradient Maximum Colour"],
					hasAlpha = true,
				},
				BagginsBBC = {
					type = "color",
					order = -1,
					width = "double",
					name = self.L["Baggins Bank Bags Colour"],
					desc = self.L["Set "] .. self.L["Baggins Bank Bags Colour"],
					hasAlpha = true,
					hidden = function() return _G.IsAddOnLoaded("Baggins") and false or true end,
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
					desc = self.L["Toggle the Gradient Effect"],
				},
				texture = _G.AceGUIWidgetLSMlists and {
					type = "select",
					order = 2,
					width = "double",
					name = self.L["Gradient Texture"],
					desc = self.L["Choose the Texture for the Gradient"],
					dialogControl = "LSM30_Background",
					values = _G.AceGUIWidgetLSMlists.background,
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
				addon = {
					type = "toggle",
					order = 9,
					width = "double",
					name = self.L["Enable AddOn Frames Gradient"],
					desc = self.L["Enable the Gradient Effect for AddOn Frames"],
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
				-- treat GossipFrame, QuestFrame, QuestInfo & QuestLog/QuestMap as one
				-- as they all change the quest text colours
				if info[#info] == "GossipFrame" then
					db.QuestFrame = value
					db.QuestInfo = value
					if self.isClsc then
						db.QuestLog = value
					else
						db.QuestMap = value
					end
					_G.InterfaceOptionsFrame_OpenToCategory(self.optionsFrame[self.L["UI Frames"]])
					_G.InterfaceOptionsFrame_OpenToCategory(self.optionsFrame[self.L["NPC Frames"]])
				elseif info[#info] == "QuestFrame" then
					db.GossipFrame = value
					db.QuestInfo = value
					if self.isClsc then
						db.QuestLog = value
					else
						db.QuestMap = value
					end
					_G.InterfaceOptionsFrame_OpenToCategory(self.optionsFrame[self.L["UI Frames"]])
					_G.InterfaceOptionsFrame_OpenToCategory(self.optionsFrame[self.L["NPC Frames"]])
				elseif info[#info] == "QuestInfo" then
					db.GossipFrame = value
					db.QuestFrame = value
					if self.isClsc then
						db.QuestLog = value
					else
						db.QuestMap = value
					end
					_G.InterfaceOptionsFrame_OpenToCategory(self.optionsFrame[self.L["UI Frames"]])
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
							desc = self.L["Toggle the skin of the "] .. self.L["Casting Bar Frames"],
						},
						glaze = {
							type = "toggle",
							order = 2,
							name = self.L["Glaze Frames"],
							desc = self.L["Toggle the glazing of the "] .. self.L["Casting Bar Frames"],
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
							desc = self.L["Toggle the skin of the "] .. self.L["Container Frames"],
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
							desc = self.L["Toggle the skin of the "] .. self.L["Loot Frames"],
						},
						size = {
							type = "range",
							order = 3,
							name = self.L["GroupLoot Size"],
							desc = self.L["Set the GroupLoot size (Normal, Small, Micro)"],
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
							desc = self.L["Toggle the skin of the "] .. self.L["Timer Frames"],
						},
						glaze = {
							type = "toggle",
							order = 2,
							name = self.L["Glaze Frames"],
							desc = self.L["Toggle the glazing of the "] .. self.L["Timer Frames"],
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
					if _G.IsAddOnLoaded("Blizzard_" .. info[#info]) then
						self:checkAndRun(info[#info], "u", true)
					end
				-- treat GossipFrame, QuestFrame, QuestInfo & QuestLog/QuestMap as one
				-- as they all change the quest text colours
				elseif info[#info] == self.isCls and "QuestLog" or "QuestMap" then
					db.GossipFrame = value
					db.QuestFrame = value
					db.QuestInfo = value
					_G.InterfaceOptionsFrame_OpenToCategory(self.optionsFrame[self.L["NPC Frames"]])
					_G.InterfaceOptionsFrame_OpenToCategory(self.optionsFrame[self.L["UI Frames"]])
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
							desc = self.L["Toggle the skin of the "] .. self.L["Chat Menus"],
						},
						ChatConfig = {
							type = "toggle",
							order = 2,
							name = self.L["Chat Config Frame"],
							desc = self.L["Toggle the skin of the "] .. self.L["Chat Config Frame"],
						},
						ChatTabs = {
							type = "toggle",
							order = 3,
							name = self.L["Chat Tabs"],
							desc = self.L["Toggle the skin of the "] .. self.L["Chat Tabs"],
						},
						ChatFrames = {
							type = "toggle",
							order = 5,
							name = self.L["Chat Frames"],
							desc = self.L["Toggle the skin of the "] .. self.L["Chat Frames"],
						},
						ChatButtons = {
							type = "toggle",
							order = 6,
							name = self.L["Chat Buttons"],
							desc = self.L["Toggle the skin of the "] .. self.L["Chat Buttons"],
						},
						CombatLogQBF = not self.isClscERA and {
							type = "toggle",
							width = "double",
							order = 7,
							name = self.L["CombatLog Quick Button Frame"],
							desc = self.L["Toggle the skin of the "] .. self.L["CombatLog Quick Button Frame"],
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
							name = self.L["Chat Bubbles Skin"],
							desc = self.L["Toggle the skin of the "] .. self.L["Chat Bubbles"],
						},
						alpha = {
							type = "range",
							order = 2,
							name = self.L["Background Alpha"],
							desc = self.L["Set the Background Alpha value"],
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
							desc = self.L["Toggle the skin of the "] .. self.L["Chat Edit Box Frames"],
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
							desc = self.L["Toggle the skin of the "] .. self.L["Main Menu Bar"],
						},
						glazesb = {
							type = "toggle",
							order = 2,
							width = "double",
							name = self.L["Glaze Status Bar"],
							desc = self.L["Toggle the glazing of the "] .. self.L["Status Bar"],
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
							desc = self.L["Toggle the skin of the "] .. self.L["Minimap"],
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
							desc = self.L["Toggle the skin of the "] .. self.L["Minimap Buttons"],
						},
						style = {
							type = "toggle",
							name = self.L["Minimal Style"],
							desc = self.L["Toggle the style of the Minimap Buttons"],
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
							desc = self.L["Toggle the skin of the "] .. self.L["Tooltips"],
						},
						glazesb = {
							type = "toggle",
							order = 2,
							width = "double",
							name = self.L["Glaze Status Bar"],
							desc = self.L["Toggle the glazing of the "] .. self.L["Status Bar"],
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
							name = self.L["Tooltips"] .. " " .. self.L["Border"] .. " " .. self.L["Colour"],
							desc = self.L["Set the Tooltips Border colour (Default, Custom)"],
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
							desc = self.L["Toggle the skin of the "] .. self.L["World Map Frame"],
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
					desc = self.L["Disable all the Addon/Library skins"],
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
		["Bank Frame"]       = true,
		["Gossip Frame"]     = true,
		["Guild Registrar"]  = {suff = "Frame"},
		["Merchant Frame"]   = true,
		["Petition"]         = {suff = "Frame"},
		["Pet Stable Frame"] = {desc = "Stable Frame"},
		["Quest Frame"]      = true,
		["Quest Info"]       = {suff = "Frame"},
		["Tabard"]           = {suff = "Frame"},
		["Taxi Frame"]       = true,
		["Trainer UI"]       = true,
	}
	self:setupFramesOptions(npcOptTab, "NPC")
	_G.wipe(npcOptTab)

	local pfOptTab = {
		["Buffs"]             = {desc = "Buffs Buttons"},
		["Character Frames"]  = true,
		["Compact Frames"]    = true,
		["Dress Up Frame"]    = true,
		["Friends Frame"]     = {desc = "Social Frame"},
		["Inspect UI"]        = true,
		["Item Socketing UI"] = true,
		["Loot History"]      = {suff = "Frame"},
		["Raid UI"]           = true,
		["Ready Check"]       = {suff = "Frame"},
		["SpellBook Frame"]   = true,
		["Talent UI"]         = true,
		["Trade Frame"]       = true,
		["Trade Skill UI"]    = true,
	}
	self:setupFramesOptions(pfOptTab, "Player")
	_G.wipe(pfOptTab)

	local uiOptTab = {
		["Addon List"]            = {suff = "Frame"},
		["Auto Complete"]         = {suff = "Frame"},
		["Battlefield Map"]       = {suff = "Frame"},
		["Binding UI"]            = {desc = "Key Bindings UI"},
		["BN Frames"]             = {desc = "BattleNet Frames"},
		["Calendar"]              = true,
		["Cinematic Frame"]       = true,
		["Coin Pickup"]           = {suff = "Frame"},
		["Color Picker"]          = {suff = "Frame"},
		["Debug Tools"]           = {suff = "Frames"},
		["Event Trace"]           = true,
		["GM Chat UI"]            = true,
		["Guild Bank UI"]         = true,
		["Help Frame"]            = {desc = "Customer Support Frame"},
		["Interface Options"]     = true,
		["Item Text"]             = {suff = "Frame"},
		["Macro UI"]              = {desc = "Macros UI"},
		["Mail Frame"]            = true,
		["Menu Frames"]           = true,
		["Move Pad"]              = true,
		["Movie Frame"]           = true,
		["Nameplates"]            = true,
		["PTR Feedback"]          = _G.PTR_IssueReporter and {suff = "Frames"} or nil,
		["Raid Frame"]            = true,
		["Shared Basic Controls"] = {desc = "Script Errors Frame"},
		["Stack Split"]           = {suff = "Frame"},
		["Static Popups"]         = true,
		["System Options"]        = true,
		["Text To Speech Frame"]  = self.isRtl or self.isClscBC and true,
		["Time Manager"]          = {suff = "Frame"},
		["Tutorial"]              = {suff = "Frame"},
		["UI DropDown Menu"]      = {desc = "DropDown Panels"},
		["UI Widgets"]            = true,
		["UnitPopup"]            = {desc = "Unit Popups"},
	}
	self:setupFramesOptions(uiOptTab, "UI")
	_G.wipe(uiOptTab)

	-- module options
	for _, mod in self:IterateModules() do
		if mod.GetOptions then
			self.optTables["Modules"].args[mod.name] = mod:GetOptions()
		end
	end

	-- add DB profile options
	self.optTables.Profiles = _G.LibStub:GetLibrary("AceDBOptions-3.0", true):GetOptionsTable(self.db)
	self.ACR = _G.LibStub:GetLibrary("AceConfigRegistry-3.0", true)

	-- register the options tables and add them to the blizzard frame
	self.ACR:RegisterOptionsTable(aName, self.optTables.General)
	self.optionsFrame = self.ACD:AddToBlizOptions(aName, self.L[aName]) -- N.B. display localised name

	-- register the options, add them to the Blizzard Options in the order specified
	local optCheck, optTitle = {}
	for _, oName in _G.pairs{"Backdrop", "Background", "Colours", "Gradient", "Modules", "NPC Frames", "Player Frames", "UI Frames", "Disabled Skins", "Profiles"} do
		optTitle = _G.strjoin(" ", aName, oName)
		self.ACR:RegisterOptionsTable(optTitle, self.optTables[oName])
		self.optionsFrame[self.L[oName]] = self.ACD:AddToBlizOptions(optTitle, self.L[oName], self.L[aName]) -- N.B. use localised name
		optCheck[oName:lower()] = oName -- store option name in table
	end

	-- runs when the player clicks "Defaults"
	self.optionsFrame.default = function()
		for name, _ in _G.pairs(self.optTables.General.args) do
			db[name] = dflts[name]
		end
		-- refresh panel
		_G.InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
	end
	self.optionsFrame[self.L["Backdrop"]].default = function()
		for name, _ in _G.pairs(self.optTables.Backdrop.args) do
			db[name] = dflts[name]
		end
		-- refresh panel
		_G.InterfaceOptionsFrame_OpenToCategory(self.optionsFrame[self.L["Backdrop"]])
		reskinIOFBackdrop()
	end
	self.optionsFrame[self.L["Background"]].default = function()
		for name, _ in _G.pairs(self.optTables.Background.args) do
			db[name] = dflts[name]
		end
		-- refresh panel
		_G.InterfaceOptionsFrame_OpenToCategory(self.optionsFrame[self.L["Background"]])
	end
	self.optionsFrame[self.L["Colours"]].default = function()
		for name, _ in _G.pairs(self.optTables.Colours.args) do
			db[name] = dflts[name]
		end
		-- refresh panel
		_G.InterfaceOptionsFrame_OpenToCategory(self.optionsFrame[self.L["Colours"]])
	end
	self.optionsFrame[self.L["Gradient"]].default = function()
		for name, _ in _G.pairs(self.optTables.Gradient.args) do
			db.Gradient[name] = dflts.Gradient[name]
		end
		-- refresh panel
		_G.InterfaceOptionsFrame_OpenToCategory(self.optionsFrame[self.L["Gradient"]])
	end
	self.optionsFrame[self.L["NPC Frames"]].default = function()
		for name, _ in _G.pairs(self.optTables["NPC Frames"].args) do
			db[name] = dflts[name]
		end
		-- refresh panel
		_G.InterfaceOptionsFrame_OpenToCategory(self.optionsFrame[self.L["NPC Frames"]])
	end
	self.optionsFrame[self.L["Player Frames"]].default = function()
		for name, _ in _G.pairs(self.optTables["Player Frames"].args) do
			db[name] = dflts[name]
		end
		-- refresh panel
		_G.InterfaceOptionsFrame_OpenToCategory(self.optionsFrame[self.L["Player Frames"]])
	end
	self.optionsFrame[self.L["UI Frames"]].default = function()
		for name, _ in _G.pairs(self.optTables["UI Frames"].args) do
			db[name] = dflts[name]
		end
		-- refresh panel
		_G.InterfaceOptionsFrame_OpenToCategory(self.optionsFrame[self.L["UI Frames"]])
	end
	self.optionsFrame[self.L["Disabled Skins"]].default = function()
		db.DisableAllAS = false
		db.DisabledSkins = {}
		-- refresh panel
		_G.InterfaceOptionsFrame_OpenToCategory(self.optionsFrame[self.L["Disabled Skins"]])
	end

	-- Slash command handler
	local function chatCommand(input)
		if not input or input:trim() == "" then
			-- Open general panel if there are no parameters, do twice to overcome Blizzard bug
			_G.InterfaceOptionsFrame_OpenToCategory(aObj.optionsFrame)
			_G.InterfaceOptionsFrame_OpenToCategory(aObj.optionsFrame)
		elseif optCheck[input:lower()] then
			_G.InterfaceOptionsFrame_OpenToCategory(aObj.optionsFrame[optCheck[input:lower()]])
			_G.InterfaceOptionsFrame_OpenToCategory(aObj.optionsFrame[optCheck[input:lower()]])
		else
			_G.LibStub:GetLibrary("AceConfigCmd-3.0", true):HandleCommand(aName, self.L[aName], input)
		end
	end

	-- Register slash command handlers
	self:RegisterChatCommand(self.L[aName], chatCommand) -- N.B. use localised name
	self:RegisterChatCommand("skin", chatCommand)

	-- setup the DB object
	self.DBObj = _G.LibStub:GetLibrary("LibDataBroker-1.1", true):NewDataObject(aName, {
		type = "launcher",
		icon = self.tFDIDs.mpw01,
		OnClick = function()
			-- do twice to overcome Blizzard bug
			_G.InterfaceOptionsFrame_OpenToCategory(aObj.optionsFrame)
			_G.InterfaceOptionsFrame_OpenToCategory(aObj.optionsFrame)
		end,
		OnTooltipShow = function(tooltip)
			tooltip:AddLine(self.L["Skinner"])
			tooltip:AddLine(self.L["Click to open config panel"], 1, 1, 1)
		end,
	})

	-- register the data object to the Icon library
	self.DBIcon:Register(aName, self.DBObj, db.MinimapIcon)

	-- defer populating Disabled Skins panel until required
	self.RegisterMessage("Skinner_SO", "IOFPanel_Before_Skinning", function(_, panel)
		if panel.parent ~= self.L[aName] -- N.B. use localised name
		or panel.name ~= self.L["Disabled Skins"] -- N.B. use localised name
		then
			return
		end

		-- add Disabled Skins entries
		local function addDSOpt(name)
			aObj.optTables["Disabled Skins"].args[name] = {
				type = "toggle",
				name = name,
				desc = aObj.L["Toggle the skinning of "] .. name,
				width = name:len() > 21 and "double" or nil,
			}
		end
		for name, _ in _G.pairs(self.addonsToSkin) do
			if self:isAddonEnabled(name) then
				addDSOpt(name)
			end
		end
		for name, _ in _G.pairs(self.libsToSkin) do
			if _G.LibStub:GetLibrary(name, true) then
				addDSOpt(name .. " (Lib)")
			end
		end
		for name, _ in _G.pairs(self.lodAddons) do
			if self:isAddonEnabled(name) then
				addDSOpt(name .. " (LoD)")
			end
		end
		for name, _ in _G.pairs(self.otherAddons) do
			if self:isAddonEnabled(name) then
				addDSOpt(name)
			end
		end

		self.UnregisterMessage("Skinner_SO", "IOFPanel_Before_Skinning")

		-- ensure new entries are displayed
		-- N.B. AFTER message is unregistered otherwise a stack overflow occurs
		_G.InterfaceOptionsList_DisplayPanel(panel)

	end)

end
