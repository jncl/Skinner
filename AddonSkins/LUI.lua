local aName, aObj = ...
if not aObj:isAddonEnabled("LUI") then return end

function aObj:LUI()
	
	-- World Map changes
	if self:IsHooked("WorldMap_ToggleSizeUp") then self:Unhook("WorldMap_ToggleSizeUp") end
	if self:IsHooked("WorldMap_ToggleSizeDown") then self:Unhook("WorldMap_ToggleSizeDown") end
	self:SecureHook("WorldMap_ToggleSizeUp", function()
		_G.WorldMapFrame.sf:SetAllPoints(_G.WorldMapFrame)
	end)
	self:SecureHook("WorldMap_ToggleSizeDown", function()
		_G.WorldMapFrame.sf:ClearAllPoints()
		_G.WorldMapFrame.sf:SetPoint("TOPLEFT", _G.WorldMapFrame, "TOPLEFT", 0, 2)
		_G.WorldMapFrame.sf:SetPoint("BOTTOMRIGHT", _G.WorldMapFrame, "BOTTOMRIGHT", -30, 0)
	end)
	-- resize if minimap
	if _G.WORLDMAP_SETTINGS.size == _G.WORLDMAP_WINDOWED_SIZE then WorldMap_ToggleSizeDown() end
	-- skin the Quest Objectives dropdown
	self:skinDropDown{obj=LUI_WorldMap_QuestObjectivesDropDown}
	
	-- skin the Chat CopyFrame
	self:skinScrollBar{obj=LUI_Chat_CopyScrollFrame}
	self:addSkinFrame{obj=LUI_Chat_CopyFrame, y1=-3, x2=-3}

end

-- The following code handles the Initial setup of Skinner when the LUI is loaded
function aObj:LUIInit()

	self:RawHook(self, "OnInitialize", function(this)
		-- Do these before we run the function

		-- setup the default DB values and register them
		self:checkAndRun("Defaults", true)
		self.Defaults = nil -- only need to run this once

		-- create and use a new db profile called LUI
		local dbProfile = self.db:GetCurrentProfile()
		if dbProfile ~= "LUI" then
			self.db:SetProfile("LUI") -- create new profile
			self.db:CopyProfile(dbProfile) -- use settings from previous profile

			-- change settings
			self.db.profile.ClassColours = false
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
			self.db.profile.Minimap = {skin = false, gloss = false}
			self.db.profile.TexturedTab = false
			-- self.db.profile.WorldMap.skin = false
		end

		-- run the function
		self.hooks[this].OnInitialize(this)

		-- Now do this after we have run the function
		-- setup backdrop(s)
		for i, _ in ipairs(self.Backdrop) do
			self.Backdrop[i] = self.backdrop
		end

		self:Unhook(self, "OnInitialize")
	end)

	-- hook to change Tab size
	self:SecureHook(self, "addSkinFrame", function(this, opts)
		if self:hasAnyTextInName(opts.obj, {"Tab(%d+)$", "TabButton(%d+)$"}) then
			local xOfs1 = (opts.x1 or 0) + 4
			local yOfs1 = (opts.y1 or 0) - 3
			local xOfs2 = (opts.x2 or 0) - 4
			local yOfs2 = (opts.y2 or 0) + 3
			opts.obj.sf:ClearAllPoints()
			opts.obj.sf:SetPoint("TOPLEFT", opts.obj, "TOPLEFT", xOfs1, yOfs1)
			opts.obj.sf:SetPoint("BOTTOMRIGHT", opts.obj, "BOTTOMRIGHT", xOfs2, yOfs2)
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
				return self.hooks[this].skinButton(this, opts)
			end)
			self.checkTex = function() end
			self:Unhook(self, "OnEnable")
		end)
	end

end

-- Load support for LUI
local success, err = aObj:checkAndRun("LUIInit", true)
if not success then
	print("Error running", "LUIInit", err)
end
