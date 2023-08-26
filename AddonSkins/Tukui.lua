local aName, aObj = ...
if not aObj:isAddonEnabled("Tukui") then return end
local _G = _G

-- The following code handles the Initial setup of Skinner when the TukUI is loaded
aObj.otherAddons.TukuiInit = function(self) -- v 20.02

	-- handle version 12 and above
	local ver = _G.tonumber(_G.GetAddOnMetadata("Tukui", "Version"):sub(1, 2))
	local mediapath = [[Interface\AddOns\Tukui\Medias\Textures\]]
    local borderr, borderg, borderb = 0.6, 0.6, 0.6
    local backdropr, backdropg, backdropb =  0.1, 0.1, 0.1
	local mult = 1
	if ver > 12 then
		mediapath = [[Interface\AddOns\Tukui\Medias\Textures\]]
	    if self:isAddOnLoaded("Tukui") then
	        local T, C, L = _G.unpack(_G.Tukui)
	        borderr, borderg, borderb = _G.unpack(C.General.BorderColor)
	        backdropr, backdropg, backdropb = _G.unpack(C.General.BackdropColor)
			mult = T.Mult
		end
    end

	self:RawHook(self, "OnInitialize", function(this)
		-- Do these before we run the function

		-- setup the default DB values and register them
		self:checkAndRun("SetupDefaults", "opt", false, true)
		self.Defaults = nil -- only need to run this once

		-- Register Textures
		self.LSM:Register("background", "Tukui Background", mediapath .. "Others\\Blank")
		self.LSM:Register("border", "Tukui Border", mediapath .. "Others\\Blank")
		self.LSM:Register("statusbar", "Tukui StatusBar", mediapath .. "Status\\Tukui")

		-- create and use a new db profile called Tukui
		local dbProfile = self.db:GetCurrentProfile()
		if dbProfile ~= "Tukui" then
			self.db:SetProfile("Tukui") -- create new profile
			self.db:CopyProfile(dbProfile) -- use settings from previous profile

			-- change settings
            self.db.profile.TooltipBorder  = {r = borderr, g = borderg, b = borderb, a = 1}
            self.db.profile.BackdropBorder = {r = borderr, g = borderg, b = borderb, a = 1}
            self.db.profile.Backdrop       = {r = backdropr, g = backdropg, b = backdropb, a = 1}
			self.db.profile.BdDefault = false
			self.db.profile.BdFile = "None"
			self.db.profile.BdEdgeFile = "None"
			self.db.profile.BdTexture = "Tukui Background"
			self.db.profile.BdBorderTexture = "Tukui Border"
			self.db.profile.BdTileSize = 0
			self.db.profile.BdEdgeSize = mult
			self.db.profile.BdInset = -mult
			self.db.profile.Gradient = {enable = false, invert = false, rotate = false, char = true, ui = true, npc = true, skinner = true, texture = "Tukui Background"}
			self.db.profile.Buffs = false
			self.db.profile.Nameplates = false
			self.db.profile.ChatEditBox = {skin = false, style = 1}
			self.db.profile.StatusBar = {texture = "Tukui StatusBar", r = 0, g = 0.5, b = 0.5, a = 0.5}
			self.db.profile.WorldMap = {skin = false, size = 1}
			self.db.profile.Minimap = {skin = false, gloss = false}
			self.db.profile.TexturedTab = false
		end

		-- run the function
		self.hooks[this].OnInitialize(this)

		-- Now do this after we have run the function
		-- setup backdrop(s)
		for i, _ in _G.ipairs(self.Backdrop) do
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

-- Load support for TukUI
local success, err = _G.xpcall(function() return aObj.otherAddons.TukuiInit(aObj) end, _G.geterrorhandler())
if not success then
	aObj:CustomPrint(1, 0, 0, "Error running TukuiInit")
end
