local _, aObj = ...
if not aObj:isAddonEnabled("Bartender4") then return end
local _G = _G

aObj.addonsToSkin.Bartender4 = function(self) -- v 4.16.0

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
	if not _G.C_AddOns.IsAddOnLoaded("Masque")
		then
		if self.modBtns then
			mod = _G.Bartender4:GetModule("ActionBars", true)
			if mod then
				local function skinActionButtons(mObj)
					for _, bar in mObj:GetAll() do
						for _, btn in bar:GetAll() do
							btn.NormalTexture:SetAlpha(0)
							aObj:addButtonBorder{obj=btn, sabt=true, rpA=true}
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
				-- hook this to handle action bars being enabled/disabled
				self:SecureHook(mod, "EnableBar", function(this, _)
					skinActionButtons(this)
				end)
			end
			mod = _G.Bartender4:GetModule("PetBar", true)
			if mod then
				local function skinPetButtons(mObj)
					for _, btn in mObj.bar:GetAll() do
						aObj:addButtonBorder{obj=btn, sft=true, reParent={btn.autocastable, btn.SpellHighlightTexture, btn.autocast}, ofs=3, x2=2}
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
				local function skinStanceButtons(mObj)
					for _, btn in mObj.bar:GetAll() do
						aObj:addButtonBorder{obj=btn, sft=true}
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
	end

	mod = _G.Bartender4:GetModule("StatusTrackingBar", true)
	if mod then
		local function skinStatusBars(mObj)
			mObj.bar.manager.MainStatusTrackingBarContainer:DisableDrawLayer("OVERLAY") -- status bar textures
			mObj.bar.manager.SecondaryStatusTrackingBarContainer:DisableDrawLayer("OVERLAY") -- status bar textures
			self:skinStatusTrackingBars(mObj.bar.manager.MainStatusTrackingBarContainer)
			self:skinStatusTrackingBars(mObj.bar.manager.SecondaryStatusTrackingBarContainer)
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

	if not self.isMnln then
		if self.modBtnBs then
			mod = _G.Bartender4:GetModule("BagBar", true)
			if mod then
				local function abb2Bag(bag)
					aObj:addButtonBorder{obj=bag, ibt=true, ofs=aObj.isFrvr and 2 or 3, clr=bag.icon:GetVertexColor()}
				end
				abb2Bag(_G.MainMenuBarBackpackButton)
				for i = 0, 3 do
					abb2Bag(_G["CharacterBag" .. i .. "Slot"])
				end
				self:addButtonBorder{obj=_G.KeyRingButton, ofs=2, x2=aObj.isFrvr and 0}
				if _G.CharacterReagentBag0Slot then
					abb2Bag(_G.CharacterReagentBag0Slot)
				end
			end
			mod = _G.Bartender4:GetModule("MicroMenu", true)
			if mod then
				for _, bInfo in _G.pairs(_G.MicroMenu:GenerateButtonInfos()) do
					self:addButtonBorder{obj=bInfo.button, es=24, ofs=2, y2=self.isFrvr and 0 or nil}
				end
			end
		end
		mod = _G.Bartender4:GetModule("XPBar", true)
		if mod then
			mod.bar.content:DisableDrawLayer("OVERLAY")
			self:skinObject("statusbar", {obj=mod.bar.content, bg=self:getRegion(mod.bar.content, 6), other={_G.ExhaustionLevelFillBar}})
		end
		mod = _G.Bartender4:GetModule("RepBar", true)
		if mod then
			local rwbSB = mod.bar.content.StatusBar
			for i = 0, 3 do
				rwbSB["WatchBarTexture" .. i]:SetTexture(nil)
				rwbSB["XPBarTexture" .. i]:SetTexture(nil)
			end
			self:skinObject("statusbar", {obj=rwbSB, bg=rwbSB.Background, other={rwbSB.Underlay, rwbSB.Overlay}})
		end
	end

end
