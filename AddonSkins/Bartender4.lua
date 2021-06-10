local _, aObj = ...
if not aObj:isAddonEnabled("Bartender4") then return end
local _G = _G

aObj.addonsToSkin.Bartender4 = function(self) -- v 4.10.9

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

	if self.modBtns then
		local mod = _G.Bartender4:GetModule("ActionBars", true)
		if mod then
			local function skinActionButtons(mod)
				-- skin ActionBar buttons
				for _, bar in mod:GetAll() do
					for _, btn in _G.ipairs(bar.buttons) do
						self:addButtonBorder{obj=btn, abt=true, sabt=true}
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
	end

	local mod = _G.Bartender4:GetModule("StatusTrackingBar", true)
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

	local mod = _G.Bartender4:GetModule("BlizzardArt", true)
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

	mod = nil

end
