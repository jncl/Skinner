local _, aObj = ...

local _G = _G

aObj.SetupForever_NPCFrames = function()
	local ftype = "n"

	aObj.blizzFrames[ftype].StableUI = function(self)
		if not self.prdb.StableUI or self.initialized.StableUI then return end
		self.initialized.StableUI = true

		local skinPetButton
		if self.modBtnBs then
			local id, isCurrentPetSlot, unlocked, clr
			function skinPetButton(btn)
				aObj:keepFontStrings(btn)
				aObj:addButtonBorder{obj=btn, fType=ftype}
				aObj:getRegion(btn, 1):SetAlpha(1) -- IconTexture
				btn.lockIcon:SetAlpha(1)
				aObj:SecureHook(btn, "Update", function(bObj)
					id = bObj:GetID()
					isCurrentPetSlot = id == 1
					unlocked = isCurrentPetSlot or id - 2 < _G.C_StableInfo.GetNumStableSlots()
					if not unlocked then
						clr = "red"
					elseif (not isCurrentPetSlot and unlocked) then
						clr = "default"
					elseif (isCurrentPetSlot and unlocked) then
						clr = "gold"
					else
						clr = "default"
					end
					aObj:clrBtnBdr(btn.sbb, clr)
				end)
				btn:Update()
			end
		end
		self:SecureHookScript(_G.PetStableFrame, "OnShow", function(this)
			if _G.InCombatLockdown() then
				self:add2Table(self.oocTab, {self.checkShown, {self, this}})
				return
			end

			this.modelScene.Background:SetTexture(nil)
			this.modelScene.PetShadow:SetTexture(nil)
			self:removeInset(this.modelScene.Inset)
			self:keepFontStrings(this.modelScene.PetModelSceneShadow)
			self:skinObject("progressbar", {obj=this.expBar, fType=ftype, ofs=-2})
			self:keepFontStrings(_G.PetStableMoneyFrame.Border)
			this.BottomDividerFrame.horzDivider:SetTexture(nil)
			this.TopDividerFrame.horzDivider:SetTexture(nil)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true})
			if self.modBtns then
				self:skinStdButton{obj=this.purchaseButton, fType=ftype, schk=true}
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=this.diet, fType=ftype, clr="gold"}
				skinPetButton(_G.PetStableCurrentPet)
				for i = 1, _G.Constants.PetConsts.MAX_STABLE_SLOTS do
					skinPetButton(_G["PetStableStabledPet" .. i])
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
