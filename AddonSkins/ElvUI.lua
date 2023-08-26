local aName, aObj = ...
if not aObj:isAddonEnabled("ElvUI") then return end
local _G = _G

-- The following code handles the Initial setup of Skinner when the ElvUI is loaded
aObj.otherAddons.ElvUIInit = function(self) -- v 12.21

	local E, L, V, P, G
	local borderr, borderg, borderb, backdropr, backdropg, backdropb
    if self:isAddOnLoaded("ElvUI") then
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

		local prdb = self.db.profile

		-- create and use a new db profile called ElvUI
		local dbProfile = self.db:GetCurrentProfile()
		if dbProfile ~= "ElvUI" then
			self.db:SetProfile("ElvUI") -- create new profile or use existing ElvUI one
			self.db:CopyProfile(dbProfile) -- use settings from previous profile

			prdb = self.db.profile

			-- change settings
            prdb.DropDownButtons = false
            prdb.TexturedTab = false
            prdb.TexturedDD = false
            prdb.TooltipBorder  = {r = borderr, g = borderg, b = borderb}
            prdb.BackdropBorder = {r = borderr, g = borderg, b = borderb}
            prdb.Backdrop       = {r = backdropr, g = backdropg, b = backdropb}
			prdb.BdDefault = false
			prdb.BdFile = "None"
			prdb.BdEdgeFile = "None"
			prdb.BdTexture = "ElvUI Blank"
			prdb.BdBorderTexture = "ElvUI GlowBorder"
			prdb.BdTileSize = 0
			prdb.BdEdgeSize = 1
			prdb.BdInset = -1
			prdb.Gradient = {enable = false, invert = false, rotate = false, char = true, ui = true, npc = true, skinner = true, texture = "ElvUI Blank"}
			prdb.Buffs = false
			prdb.Nameplates = false
			prdb.ChatEditBox = {skin = false, style = 1}
			prdb.StatusBar = {texture = "ElvUI Norm", r = 0, g = 0.5, b = 0.5, a = 0.5}
			prdb.WorldMap = {skin = false, size = 1}
		end

		local c
		-- GradientMax colours
		c = prdb.ClassClrGr and E.myclass == 'PRIEST' and E.PriestColors or _G.RAID_CLASS_COLORS[E.myclass] or prdb.GradientMax
		self.gmaxClr = _G.CreateColor(c.r, c.g, c.b, c.a or prdb.GradientMax.a)
		-- Backdrop colours
		c = prdb.ClassClrBg and E.myclass == 'PRIEST' and E.PriestColors or _G.RAID_CLASS_COLORS[E.myclass] or prdb.Backdrop
		self.bClr = _G.CreateColor(c.r, c.g, c.b, c.a or prdb.Backdrop.a)
		-- BackdropBorder colours
		c = prdb.ClassClrBd and E.myclass == 'PRIEST' and E.PriestColors or _G.RAID_CLASS_COLORS[E.myclass] or prdb.BackdropBorder
		self.bbClr = _G.CreateColor(c.r, c.g, c.b, c.a or prdb.BackdropBorder.a)
		-- TooltipBorder colours
		c = prdb.ClassClrTT and E.myclass == 'PRIEST' and E.PriestColors or _G.RAID_CLASS_COLORS[E.myclass] or prdb.TooltipBorder
		self.tbClr = _G.CreateColor(c.r, c.g, c.b, c.a or prdb.TooltipBorder.a)

		prdb, c = nil, nil

		-- run the function
		self.hooks[this].OnInitialize(this)

		-- Now do this after we have run the function
		-- setup backdrop(s)
		for i, _ in _G.ipairs(self.Backdrop) do
			self.Backdrop[i] = self.backdrop
		end

		-- remove skinning code for LFGFrame as it causes errors
		self.blizzFrames.u.LFGFrame = nil

		self.isElvUI = true

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
			self.checkTex = _G.nop

			self:Unhook(this, "OnEnable")
		end)
	end

end

-- Load support for ElvUI
local success, err = _G.xpcall(function() return aObj.otherAddons.ElvUIInit(aObj) end, _G.geterrorhandler())
if not success then
	aObj:CustomPrint(1, 0, 0, "Error running ElvUIInit")
end
