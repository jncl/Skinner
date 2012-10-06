local aName, aObj = ...
if not aObj:isAddonEnabled("ElvUI") then return end
local E, C, L

function aObj:ElvUI()

    E, C, L = unpack(ElvUI)
-->>-- Bags
	if C["others"].enablebag == true then
		self:SecureHook(Stuffing, "CreateBagFrame", function(this, bType)
			self:skinButton{obj=_G["Stuffing_CloseButton"..bType], cb=true}
		end)
		self:skinEditBox{obj=StuffingFrameBags.editbox}
		StuffingFrameBags.editbox:ClearAllPoints()
		StuffingFrameBags.editbox:SetPoint("topleft", StuffingFrameBags, "topleft", 12, -9)
		StuffingFrameBags.editbox:SetPoint("bottomright", StuffingFrameBags, "topright", -40, -28)
		self:skinButton{obj=StuffingFrameBags.b_close, cb=true}
	end

-->>-- Chat Copy frame
	if C["chat"].enable then
		for i = 1, NUM_CHAT_WINDOWS do
			self:SecureHookScript(_G["ButtonCF"..i], "OnClick", function(this)
				 -- stop animations otherwise the text doesn't show
				CopyFrame.anim:Stop()
				CopyFrame.anim_o:Stop()
				self:skinButton{obj=CopyCloseButton, cb=true}
				self:skinScrollBar{obj=CopyScroll}
				for i = 1, NUM_CHAT_WINDOWS do
					self:Unhook(_G["ButtonCF"..i], "OnClick")
				end
			end)
		end
	end

end

-- The following code handles the Initial setup of Skinner when the ElvUI is loaded
function aObj:ElvUIInit()

	local borderr, borderg, borderb, backdropr, backdropg, backdropb
    if IsAddOnLoaded("ElvUI") then
        E, C, L = unpack(ElvUI)
       	borderr, borderg, borderb = unpack(C.media.bordercolor)
        backdropr, backdropg, backdropb = unpack(C.media.backdropcolor)
    else
        borderr, borderg, borderb = 0.6, 0.6, 0.6
        backdropr, backdropg, backdropb =  0.1, 0.1, 0.1
    end

	self:RawHook(self, "OnInitialize", function(this)
		-- Do these before we run the function

		-- setup the default DB values and register them
		self:checkAndRun("Defaults", true)
		self.Defaults = nil -- only need to run this once

		-- Register Textures if required
		if not C.media.blank then
			self.LSM:Register("background","ElvUI Blank", [[Interface\BUTTONS\WHITE8X8]])
		end
		if not C.media.glowTex then
			self.LSM:Register("border", "ElvUI GlowBorder", [[Interface\AddOns\ElvUI\media\textures\glowTex.tga]])
		end
		if not C.media.normTex then
			self.LSM:Register("statusbar","ElvUI Norm", [[Interface\AddOns\ElvUI\media\textures\normTex.tga]])
		end

		-- create and use a new db profile called ElvUI
		local dbProfile = self.db:GetCurrentProfile()
		if dbProfile ~= "ElvUI" then
			self.db:SetProfile("ElvUI") -- create new profile
			self.db:CopyProfile(dbProfile) -- use settings from previous profile

			-- change settings
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
		self.db.profile.ClassColours = C.general.classcolortheme

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
			self.skinFrame[opts.obj]:ClearAllPoints()
			self.skinFrame[opts.obj]:SetPoint("TOPLEFT", opts.obj, "TOPLEFT", xOfs1, yOfs1)
			self.skinFrame[opts.obj]:SetPoint("BOTTOMRIGHT", opts.obj, "BOTTOMRIGHT", xOfs2, yOfs2)
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
			self:Unhook(self, "OnEnable")
		end)
	end

end

-- Load support for ElvUI
local success, err = aObj:checkAndRun("ElvUIInit", true)
if not success then
	print("Error running", "ElvUIInit", err)
end
