local _, aObj = ...
if not aObj:isAddonEnabled("Bartender4") then return end
local _G = _G

aObj.addonsToSkin.Bartender4 = function(self) -- v 4.11.1/

	self:SecureHook(_G.Bartender4, "ShowUnlockDialog", function(this)
		self:skinObject("frame", {obj=this.unlock_dialog, kfs=true, y1=6})
		if self.modBtns then
			self:skinStdButton{obj=_G.Bartender4DialogLock}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.Bartender4Snapping}
		end

		self:Unhook(_G.Bartender4, "ShowUnlockDialog")
	end)

	local mod
	if self.modBtns then
		mod = _G.Bartender4:GetModule("ActionBars", true)
		if mod then
			local function skinActionButtons(mod)
				for _, bar in mod:GetAll() do
					for _, btn in bar:GetAll() do
						self:addButtonBorder{obj=btn, sabt=true}
					end
				end
			end
			if mod.enabledState then
				skinActionButtons(mod)
			else
				self:SecureHook(mod, "OnEnable", function(this)
					skinActionButtons(this)

					self:Unhook(this, "OnEnable")
				end)
			end
		end
		mod = _G.Bartender4:GetModule("PetBar", true)
		if mod then
			local function skinPetButtons(mod)
				for _, btn in mod.bar:GetAll() do
					self:addButtonBorder{obj=btn, sft=true, reParent={btn.autocastable, btn.SpellHighlightTexture, btn.autocast}, ofs=3, x2=2}
				end
			end
			if mod.enabledState then
				skinPetButtons(mod)
			else
				self:SecureHook(mod, "OnEnable", function(this)
					skinPetButtons(this)

					self:Unhook(this, "OnEnable")
				end)
			end
		end
		mod = _G.Bartender4:GetModule("StanceBar", true)
		if mod then
			local function skinStanceButtons(mod)
				for _, btn in mod.bar:GetAll() do
					self:addButtonBorder{obj=btn, sft=true}
				end
			end
			if mod.enabledState then
				skinStanceButtons(mod)
			else
				self:SecureHook(mod, "OnEnable", function(this)
					skinStanceButtons(this)

					self:Unhook(this, "OnEnable")
				end)
			end
		end
		-- ExtraActionBar ?
	end

	mod = _G.Bartender4:GetModule("StatusTrackingBar", true)
	if mod then
		local function skinStatusBars(mod)
			-- skin Status bars
			mod.bar.manager:DisableDrawLayer("OVERLAY") -- status bar textures
			for _, bar in _G.ipairs(mod.bar.manager.bars) do
				self:skinStatusBar{obj=bar.StatusBar, fi=0, bgTex=bar.StatusBar.Background}
				if bar.ExhaustionTick then -- HonorStatusBar & ExpStatusBar
					bar.ExhaustionTick:GetNormalTexture():SetTexture(nil)
					bar.ExhaustionTick:GetHighlightTexture():SetTexture(nil)
				elseif bar.Tick then -- ArtifactStatusBar
					bar.Tick:GetNormalTexture():SetTexture(nil)
					bar.Tick:GetHighlightTexture():SetTexture(nil)
				end
			end
		end
		if mod.enabledState then
			skinStatusBars(mod)
		else
			self:SecureHook(mod, "OnEnable", function(this)
				skinStatusBars(this)

				self:Unhook(this, "OnEnable")
			end)
		end
	end

	mod = _G.Bartender4:GetModule("BlizzardArt", true)
	if mod then
		if mod.enabledState then
			-- disable Art
			mod:ToggleModule(nil, false)
		else
			self:SecureHook(mod, "OnEnable", function(this)
				-- disable Art
				mod:ToggleModule(nil, false)

				self:Unhook(this, "OnEnable")
			end)
		end
	end

end
