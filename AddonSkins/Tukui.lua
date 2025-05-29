local _, aObj = ...
local _G = _G

if not aObj:isAddonEnabled("TukUI") then
	return
end

-- The following code handles the Initial setup of Skinner when the TukUI is loaded
aObj.otherAddons.TukUIInit = function(self) -- v 20.460

	local T, C
	local borderr, borderg, borderb, backdropr, backdropg, backdropb
	local mult
	if _G.C_AddOns.IsAddOnLoaded("TukUI") then
		T, C, _ = _G.unpack(_G.TukUI)
		borderr, borderg, borderb = _G.unpack(C.General.BorderColor)
		backdropr, backdropg, backdropb = _G.unpack(C.General.BackdropColor)
		mult = T.Mult
	else
		borderr, borderg, borderb = 0.6, 0.6, 0.6
		backdropr, backdropg, backdropb =  0.1, 0.1, 0.1
		mult = 1
	end

	self:RawHook(self, "OnInitialize", function(this)
		-- Do these before we run the function

		-- setup the default DB values and register them
		self:checkAndRun("SetupDefaults", "opt", false, true)
		self.Defaults = nil -- only need to run this once

		-- Register Textures
		self.LSM:Register("background", "TukUI Background", [[Interface\AddOns\TukUI\Medias\Textures\Others\\Blank"]])
		self.LSM:Register("border", "TukUI Border", [[Interface\AddOns\TukUI\Medias\Textures\Others\\Blank"]])
		self.LSM:Register("statusbar", "TukUI StatusBar", [[Interface\AddOns\TukUI\Medias\Textures\Status\\TukUI"]])

		local prdb = self.db.profile
		local profName = "TukUI"

		local dbProfile = self.db:GetCurrentProfile()
		if dbProfile ~= profName then
			self.db:SetProfile(profName) -- create new profile
			self.db:CopyProfile(dbProfile) -- use settings from previous profile

			prdb = self.db.profile

			-- change settings
			prdb.TabDDTextures.texturedtab = false
			prdb.TabDDTextures.textureddd  = false
            prdb.TooltipBorder  		   = _G.CreateColor(borderr, borderg, borderb)
            prdb.Backdrop       		   = _G.CreateColor(backdropr, backdropg, backdropb)
            prdb.BackdropBorder 		   = _G.CreateColor(borderr, borderg, borderb)
			prdb.BdDefault      		   = false
			prdb.BdFile         		   = "None"
			prdb.BdEdgeFile     		   = "None"
			prdb.BdTexture      		   = "TukUI Background"
			prdb.BdBorderTexture		   = "TukUI Border"
			prdb.BdTileSize     		   = 0
			prdb.BdEdgeSize     		   = mult
			prdb.BdInset        		   = -mult
			prdb.Gradient       		   = {enable = false, invert = false, rotate = false, char = true, ui = true, npc = true, skinner = true, texture = "TukUI Background"}
			prdb.Buffs = false
			prdb.Nameplates      		   = false
			prdb.ChatEditBox     		   = {skin = false, style = 1}
			prdb.StatusBar       		   = {texture = "TukUI StatusBar", r = 0, g = 0.5, b = 0.5, a = 0.5}
			prdb.WorldMap        		   = {skin = false, size = 1}
			prdb.Minimap         		   = {skin = false, gloss = false}
		end

		-- run the function
		self.hooks[this].OnInitialize(this)

		-- remove skinning code for CompactFrames
		self.blizzFrames.p.CompactFrames = nil

		-- setup backdrop(s)
		for i, _ in _G.ipairs(self.Backdrop) do
			self.Backdrop[i] = self.backdrop
		end

		self.isTukUI = true

		self:Unhook(this, "OnInitialize")
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

-- Load support for TukUI
local success, _ = _G.xpcall(function() return aObj.otherAddons.TukUIInit(aObj) end, _G.geterrorhandler())
if not success then
	aObj:CustomPrint(1, 0, 0, "Error running TukUIInit")
end
