local aName, aObj = ...
if not aObj:isAddonEnabled("RecipeRadarClassic") then return end
local _G = _G

aObj.addonsToSkin.RecipeRadarClassic = function(self) -- v 1.0.0.20

	self:SecureHookScript(_G.RecipeRadarFrame, "OnShow", function(this)
		_G.RecipeRadarRadarTabFrame:DisableDrawLayer("BACKGROUND")
		_G.RecipeRadarRecipesTabFrame:DisableDrawLayer("BACKGROUND")
		self:skinDropDown{obj=_G.RecipeRadar_PersonAvailDropDown}
		self:skinDropDown{obj=_G.RecipeRadar_Prof1DropDown}
		self:skinDropDown{obj=_G.RecipeRadar_TeamDropDown}
		self:skinDropDown{obj=_G.RecipeRadar_RealmAvailDropDown}
		self:skinDropDown{obj=_G.RecipeRadar_Prof2DropDown}
		self:skinSlider{obj=_G.RecipeRadarListScrollFrame.ScrollBar, rt="background"}
		if self.modBtns then
			for i = 1, _G.RECIPERADAR_VENDORS_DISPLAYED do
				self:skinExpandButton{obj = _G["RecipeRadarVendor" .. i], onSB=true}
				-- hook this to show profession icon
				self:SecureHook(_G["RecipeRadarVendor" .. i], "SetNormalTexture", function(this, nTex)
					if self:hasTextInTexture(this:GetNormalTexture(), "RecipeRadarClassic") then
						this:GetNormalTexture():SetAlpha(1)
					end
				end)
			end
		end
		-- RecipeRadarDetailFrame
		_G.RecipeDetailIcon:DisableDrawLayer("BACKGROUND")
		_G.RecipeCostIcon:DisableDrawLayer("BACKGROUND")
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.RecipeDetailIcon}
		end
		_G.RecipeRadarMapFrame:DisableDrawLayer("OVERLAY") -- separator bar texture
		self:skinDropDown{obj=_G.RadarTabDropDown}
		self:skinDropDown{obj=_G.RecipesTabDropDown}
		self:addSkinFrame{obj=this, ft="a", kfs=true, nb=true, x1=10, y1=-11, x2=-33, y2=71}
		if self.modBtns then
			self:skinCloseButton{obj=_G.RecipeRadarExitButton}
			self:skinStdButton{obj=_G.RecipeRadarOptionsButton}
			self:skinStdButton{obj=_G.RecipeRadarCloseButton}
			-- RecipeRadarLockButton
			_G.RecipeRadarLockNormal:SetTexture([[Interface/Glues/CharacterSelect/Glues-AddOn-Icons]])
			_G.RecipeRadarLockNormal.SetTexture = _G.nop
			_G.RecipeRadarLockNormal:SetAlpha(1)
			_G.RecipeRadarLockPushed:SetTexture([[Interface/Glues/CharacterSelect/Glues-AddOn-Icons]])
			_G.RecipeRadarLockPushed.SetTexture = _G.nop
			_G.RecipeRadarLockPushed:SetAlpha(1)
			_G.RecipeRadarLockButton:SetSize(14, 14) -- halve size to make icon fit
			self:addSkinButton{obj=_G.RecipeRadarLockButton, aso={ng=true}}
			-- hook this to Hide/Show locked texture
			local function chkLock()
				if _G.RecipeRadar.db.profile.Locked then
					_G.RecipeRadarLockNormal:SetTexCoord(0, 0.25, 0, 1.0) -- locked
					_G.RecipeRadarLockPushed:SetTexCoord(0, 0.25, 0, 1.0) -- locked
				else
					_G.RecipeRadarLockNormal:SetTexCoord(0.25, 0.5, 0, 1.0) -- unlocked
					_G.RecipeRadarLockPushed:SetTexCoord(0.25, 0.5, 0, 1.0) -- unlocked
				end
			end
			self:RawHook("RecipeRadar_UpdateLock", function(this)
				chkLock()
			end, true)
			chkLock()
			self:moveObject{obj=_G.RecipeRadarLockButton, x=-6} -- move it left
		end

		self:Unhook(this, "OnShow")
	end)

	-- tooltip
	_G.C_Timer.After(0.1, function()
		self:add2Table(self.ttList, _G.RecipeRadarAvailabilityTooltip)
	end)

	self.mmButs["RecipeRadarClassic"] = _G.RecipeRadarMinimapButtonFrame
	_G.RecipeRadar_MinimapButton:SetNormalTexture([[Interface\AddOns\RecipeRadarClassic\Images\Misc\Scroll.blp]])
	_G.RecipeRadar_MinimapButton:SetPushedTexture([[Interface\AddOns\RecipeRadarClassic\Images\Misc\Scroll.blp]])
	_G.RecipeRadar_MinimapButton:SetSize(20, 20)
	self:moveObject{obj=_G.RecipeRadar_MinimapButton, x=5, y=-6}

end
