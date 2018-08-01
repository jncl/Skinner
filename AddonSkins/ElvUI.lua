local aName, aObj = ...
if not aObj:isAddonEnabled("ElvUI") then return end
local _G = _G

-- The following code handles the Initial setup of Skinner when the ElvUI is loaded
aObj.otherAddons.ElvUIInit = function(self) -- v 10.73

	local E, L, V, P, G
	local borderr, borderg, borderb, backdropr, backdropg, backdropb
    if _G.IsAddOnLoaded("ElvUI") then
		E, L, V, P, G = _G.unpack(_G.ElvUI)
       	borderr, borderg, borderb = _G.unpack(E.media.bordercolor)
        backdropr, backdropg, backdropb = _G.unpack(E.media.backdropcolor)
    else
        borderr, borderg, borderb = 0.6, 0.6, 0.6
        backdropr, backdropg, backdropb =  0.1, 0.1, 0.1
    end

	self:RawHook(self, "OnInitialize", function(this)
		-- Do these before we run the function

		-- setup the default DB values and register them
		self:checkAndRun("SetupDefaults", "opt", false, true)
		self.Defaults = nil -- only need to run this once

		-- Register Textures if required
		if not E.media.blank then
			self.LSM:Register("background","ElvUI Blank", [[Interface\BUTTONS\WHITE8X8]])
		end
		if not E.media.glowTex then
			self.LSM:Register("border", "ElvUI GlowBorder", [[Interface\AddOns\ElvUI\media\textures\glowTex.tga]])
		end
		if not E.media.normTex then
			self.LSM:Register("statusbar","ElvUI Norm", [[Interface\AddOns\ElvUI\media\textures\normTex.tga]])
		end

		-- create and use a new db profile called ElvUI
		local dbProfile = self.db:GetCurrentProfile()
		if dbProfile ~= "ElvUI" then
			self.db:SetProfile("ElvUI") -- create new profile or use existing ElvUI one
			self.db:CopyProfile(dbProfile) -- use settings from previous profile

			-- change settings
            self.db.profile.DropDownButtons = false
            self.db.profile.TexturedTab = false
            self.db.profile.TexturedDD = false
            self.db.profile.TooltipBorder  = {r = borderr, g = borderg, b = borderb}
            self.db.profile.BackdropBorder = {r = borderr, g = borderg, b = borderb}
            self.db.profile.Backdrop       = {r = backdropr, g = backdropg, b = backdropb}
			self.db.profile.BdDefault = false
			self.db.profile.BdFile = "None"
			self.db.profile.BdEdgeFile = "None"
			self.db.profile.BdTexture = "ElvUI Blank"
			self.db.profile.BdBorderTexture = "ElvUI GlowBorder"
			self.db.profile.BdTileSize = 0
			self.db.profile.BdEdgeSize = 1
			self.db.profile.BdInset = -1
			self.db.profile.Gradient = {enable = false, invert = false, rotate = false, char = true, ui = true, npc = true, skinner = true, texture = "ElvUI Blank"}
			self.db.profile.Buffs = false
			self.db.profile.Nameplates = false
			self.db.profile.ChatEditBox = {skin = false, style = 1}
			self.db.profile.StatusBar = {texture = "ElvUI Norm", r = 0, g = 0.5, b = 0.5, a = 0.5}
			self.db.profile.WorldMap = {skin = false, size = 1}
		end
		-- class colours
		self.db.profile.ClassClrBd = E.myclass == 'PRIEST' and E.PriestColors or _G.RAID_CLASS_COLORS[E.myclass]
		self.db.profile.ClassClrBg = E.myclass == 'PRIEST' and E.PriestColors or _G.RAID_CLASS_COLORS[E.myclass]
		self.db.profile.ClassClrGr = E.myclass == 'PRIEST' and E.PriestColors or _G.RAID_CLASS_COLORS[E.myclass]
		self.db.profile.ClassClrTT = E.myclass == 'PRIEST' and E.PriestColors or _G.RAID_CLASS_COLORS[E.myclass]

		-- replace removeRegions function by rmRegionsTex function as several frames have had Textures removed/Fontstrings added
		self.removeRegions = self.rmRegionsTex

		-- run the function
		self.hooks[this].OnInitialize(this)

		-- Now do this after we have run the function
		-- setup backdrop(s)
		for i, _ in _G.ipairs(self.Backdrop) do
			self.Backdrop[i] = self.backdrop
		end

		-- remove skinning code for LFGFrame as it causes errors
		aObj.blizzFrames.u.LFGFrame = nil

		self:Unhook(self, "OnInitialize")
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
			self.checkTex = function() end
			self:Unhook(this, "OnEnable")
		end)
	end

end

-- Load support for ElvUI
local success, err = _G.xpcall(function() return aObj.otherAddons.ElvUIInit(aObj) end, _G.geterrorhandler())
if not success then
	aObj:CustomPrint(1, 0, 0, "Error running ElvUIInit")
end
