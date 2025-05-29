local _, aObj = ...
local _G = _G

if not aObj:isAddonEnabled("ElvUI") then
	return
end

-- The following code handles the Initial setup of Skinner when the ElvUI is loaded
aObj.otherAddons.ElvUIInit = function(self) -- v 13.90

	local E
	local borderr, borderg, borderb, backdropr, backdropg, backdropb
	if _G.C_AddOns.IsAddOnLoaded("ElvUI") then
		E, _, _, _, _ = _G.unpack(_G.ElvUI)
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
		local profName = "ElvUI"

		local dbProfile = self.db:GetCurrentProfile()
		if dbProfile ~= profName then
			self.db:SetProfile(profName) -- create new profile
			self.db:CopyProfile(dbProfile) -- use settings from previous profile

			prdb = self.db.profile

			-- change settings
			prdb.DropDownButtons           = false
			prdb.TabDDTextures.texturedtab = false
			prdb.TabDDTextures.textureddd  = false
			prdb.TooltipBorder             = _G.CreateColor(borderr, borderg, borderb)
			prdb.Backdrop                  = _G.CreateColor(backdropr, backdropg, backdropb)
			prdb.BackdropBorder            = _G.CreateColor(borderr, borderg, borderb)
			prdb.BdDefault                 = false
			prdb.BdFile                    = "None"
			prdb.BdEdgeFile                = "None"
			prdb.BdTexture                 = "ElvUI Blank"
			prdb.BdBorderTexture           = "ElvUI GlowBorder"
			prdb.BdTileSize                = 0
			prdb.BdEdgeSize                = 1
			prdb.BdInset                   = -1
			prdb.Gradient.enable           = false
			prdb.Buffs                     = false
			prdb.Nameplates                = false
			prdb.ChatEditBox.skin          = false
			prdb.StatusBar.texture         = "ElvUI Norm"
			prdb.WorldMap.skin             = false
		end

		-- run the function
		self.hooks[this].OnInitialize(this)

		-- remove skinning code for CompactFrames
		self.blizzFrames.p.CompactFrames = nil

		-- remove skinning code for LFGFrame as it causes errors
		self.blizzFrames.u.LFGFrame = nil

		-- change Tab size
		self.skinTPLs.tabs.offsets = {x1=4, y1=-3, x2=-4, y2=3}

		self.isElvUI = true

		self:Unhook(self, "OnInitialize")
	end)

	local modUIBtns = self:GetModule("UIButtons", true)
	if modUIBtns
	and modUIBtns:IsEnabled()
	then
		-- disable minus/plus button skinning functions
		modUIBtns.skinExpandButton = _G.nop
		modUIBtns.checkTex = _G.nop
		-- hook this as UIButton code is now in a module
		self:SecureHook(modUIBtns, "OnEnable", function(this)
			-- hook to ignore Shapeshift button skinning
			self:RawHook(modUIBtns, "skinStdButton", function(fObj, opts)
				if aObj:hasTextInName(opts.obj, "ShapeshiftButton(%d)$") then
					return
				end
				return aObj.hooks[fObj].skinStdButton(fObj, opts)
			end, true)
			self:Unhook(this, "OnEnable")
		end)
	end

end

-- Load support for ElvUI
local success, _ = _G.xpcall(function() return aObj.otherAddons.ElvUIInit(aObj) end, _G.geterrorhandler())
if not success then
	aObj:CustomPrint(1, 0, 0, "Error running ElvUIInit")
end
