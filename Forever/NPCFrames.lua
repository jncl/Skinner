local _, aObj = ...

local _G = _G

aObj.SetupForever_NPCFrames = function()
	local ftype = "n"

	aObj.blizzFrames[ftype].StableUI = function(self)
		if not self.prdb.StableUI or self.initialized.StableUI then return end
		self.initialized.StableUI = true

		self:SecureHookScript(_G.PetStableFrame, "OnShow", function(this)
			if _G.InCombatLockdown() then
				self:add2Table(self.oocTab, {self.checkShown, {self, this}})
				return
			end

			this.modelScene.Background:SetTexture(nil)
			this.modelScene.PetShadow:SetTexture(nil)
			self:keepFontStrings(this.modelScene.PetModelSceneShadow)
			self:removeInset(this.modelScene.Inset)
			self:keepFontStrings(this.expBar.overlay)
			local expSB = this.expBar.StatusBar
			self:skinObject("statusbar", {obj=expSB, bg=expSB.Background, other={expSB.Underlay}})
			expSB:SetStatusBarColor(self:getColourByName("purple"))
			this.loyaltyLevel:DisableDrawLayer("BACKGROUND")
			self:keepFontStrings(_G.PetStableMoneyFrame.Border)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true})
			if self.modBtns then
				self:skinStdButton{obj=this.purchaseButton, fType=ftype, schk=true}
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=this.diet, fType=ftype, clr="gold"}
				local btn
				btn = _G.PetStableCurrentPet
				btn.background:Hide()
				self:addButtonBorder{obj=btn, fType=ftype, clr="gold"}
				for i = 1, _G.Constants.PetConsts.MAX_STABLE_SLOTS do
					btn = _G["PetStableStabledPet" .. i]
					if btn then
						btn.background:Hide()
						self:addButtonBorder{obj=btn, clr={btn.background:GetVertexColor()}}
						self:SecureHook(btn.background, "SetVertexColor", function(tObj, ...)
							tObj:GetParent().sbb:SetBackdropBorderColor(...)
						end)
					end
				end

			end

			self:Unhook(_G.PetStableFrame, "OnShow")
		end)
		self:checkShown(_G.PetStableFrame)

	end

end

aObj.SetupForever_NPCFramesOptions = function(_)

end

aObj.SetupForever_NPCFramesDefaults = function(_)

end
