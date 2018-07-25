local aName, aObj = ...
if not aObj:isAddonEnabled("LUI") then return end
local _G = _G

-- The following code handles the Initial setup of Skinner when the LUI is loaded
aObj.otherAddons.LUIInit = function(self) -- v 3.18

	self:RawHook(self, "OnInitialize", function(this)
		-- Do these before we run the function

		-- setup the default DB values and register them
		self:checkAndRun("SetupDefaults", "opt", false, true)
		self.Defaults = nil -- only need to run this once

		-- create and use a new db profile called LUI
		local dbProfile = self.db:GetCurrentProfile()
		if dbProfile ~= "LUI" then
			self.db:SetProfile("LUI") -- create new profile
			self.db:CopyProfile(dbProfile) -- use settings from previous profile

			-- change settings
            self.db.profile.DropDownButtons = false
            self.db.profile.TexturedTab = false
            self.db.profile.TexturedDD = false
            self.db.profile.TooltipBorder  = {r = 0.3, g = 0.3, b = 0.3, a = 1}
            self.db.profile.BackdropBorder = {r = 0.2, g = 0.2, b = 0.2, a = 1}
            self.db.profile.Backdrop       = {r = 0.18, g = 0.18, b = 0.18, a = 1}
			self.db.profile.BdDefault = false
			self.db.profile.BdFile = "None"
			self.db.profile.BdEdgeFile = "None"
			self.db.profile.BdTexture = "Blizzard Tooltip"
			self.db.profile.BdBorderTexture = "Stripped_medium"
			self.db.profile.BdTileSize = 0
			self.db.profile.BdEdgeSize = 5
			self.db.profile.BdInset = 3
			self.db.profile.Gradient = {enable = false, invert = false, rotate = false, char = true, ui = true, npc = true, skinner = true, texture = "Blizzard Tooltip"}
			self.db.profile.Buffs = false
			self.db.profile.Nameplates = false
			self.db.profile.ChatEditBox = {skin = false, style = 1}
			self.db.profile.StatusBar = {texture = "LUI_Minimalist", r = 0, g = 0.5, b = 0.5, a = 0.5}
			self.db.profile.WorldMap = {skin = false, size = 1}
			self.db.profile.Minimap = {skin = false, gloss = false}
		end

		-- run the function
		self.hooks[this].OnInitialize(this)

		-- Now do this after we have run the function
		-- setup backdrop(s)
		for i, _ in _G.ipairs(self.Backdrop) do
			self.Backdrop[i] = self.backdrop
		end

		self:Unhook(self, "OnInitialize")

		if self.prdb.WorldMap.skin then
			-- skin the Quest Objectives dropdown
			if _G.LUI_WorldMap_QuestObjectivesDropDown then
				self:skinDropDown{obj=_G.LUI_WorldMap_QuestObjectivesDropDown}
			end
		end

	end)

	-- hook to change Tab size
	self:SecureHook(self, "addSkinFrame", function(this, opts)
		if self:hasAnyTextInName(opts.obj, {"Tab(%d+)$", "TabButton(%d+)$"}) then
			opts.x1 = opts.x1 or 4
			opts.y1 = opts.y1 or -3
			opts.x2 = opts.x2 or -4
			opts.y2 = opts.y2 or 3
			opts.obj.sf:ClearAllPoints()
			opts.obj.sf:SetPoint("TOPLEFT", opts.obj, "TOPLEFT", opts.x1, opts.y1)
			opts.obj.sf:SetPoint("BOTTOMRIGHT", opts.obj, "BOTTOMRIGHT", opts.x2, opts.y2)
		end
	end)
	-- hook to ignore Shapeshift button skinning
	self:RawHook(self, "addSkinButton", function(this, opts)
		if self:hasTextInName(opts.obj, "ShapeshiftButton(%d)$") then return end
		return self.hooks[this].addSkinButton(this, opts)
	end)

	if self:GetModule("UIButtons", true):IsEnabled() then
		-- hook this as UIButton code is now in a module
		self:SecureHook(self, "OnEnable", function(this)
			-- hook to ignore minus/plus button skinning
			self:RawHook(self, "skinButton", function(this, opts)
				if opts.mp
				or opts.mp2
				or opts.mp3
				then
					return
				end
				self.hooks[this].skinButton(this, opts)
			end)
			self.skinExpandButton = _G.nop
			self.checkTex = _G.nop
			self:Unhook(this, "OnEnable")
		end)
	end

	local chat = _G.LUI:GetModule("Chat", true)
	if chat then
		local btns = chat:GetModule("Buttons", true)
		if btns then
			local db, dbd = chat:Namespace(btns)
			if db.CopyChat then
				self:SecureHook(btns, "OnEnable", function(this)
					self:skinSlider{obj=_G.LUI_Chat_CopyScrollFrame.ScrollBar}
					self:addSkinFrame{obj=_G.LUI_Chat_CopyFrame, ft="a", kfs=true, nb=true, y1=-3, x2=-3}
					self:Unhook(this, "OnEnable")
				end)
			end
			db, dbd = nil, nil
		end
		btns = nil
	end
	chat = nil

end

-- Load support for LUI
local success, err = _G.xpcall(function() return aObj.otherAddons.LUIInit(aObj) end, _G.geterrorhandler())
if not success then
	aObj:CustomPrint(1, 0, 0, "Error running LUIInit")
end
