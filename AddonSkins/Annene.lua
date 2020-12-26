local _, aObj = ...
if not aObj:isAddonEnabled("Annene") then return end
local _G = _G

aObj.addonsToSkin.Annene = function(self) -- v 9.0.2-1

	local xOfs
	self:SecureHook(_G.PetBattleFrame, "Show", function(this)
		this.TopArtLeft.SetTexture = _G.nop
		this.TopArtRight.SetTexture = _G.nop
		this.BottomFrame.LeftEndCap.SetTexture = _G.nop
		this.BottomFrame.RightEndCap.SetTexture = _G.nop
		this.BottomFrame.TurnTimer.TimerBG.SetTexture = _G.nop
		if this.sfl then
			this.sfl:Hide()
			this.sfr:Hide()
			this.sfm:Hide()
			this.sfl, this.sfr, this.sfm = nil, nil, nil
			this.BottomFrame.sf:Hide()
			this.BottomFrame.sf = nil
			self:skinObject("frame", {obj=this.BottomFrame, fType=ftype, bd=11})
			if self.modBtnBs then
				local function adjBB(btn)
					btn.sbb:ClearAllPoints()
					btn.sbb:SetPoint("TOPLEFT", btn, "TOPLEFT", -4, 4)
					btn.sbb:SetPoint("BOTTOMRIGHT", btn, "BOTTOMRIGHT", 3, -3)
				end
				_G.C_Timer.After(0.2, function()
					for i = 1, 3 do
						adjBB(this.BottomFrame.abilityButtons[i])
					end
				end)
				for _, btn in _G.pairs{"SwitchPetButton", "CatchButton", "ForfeitButton"} do
					adjBB(this.BottomFrame[btn])
				end
			end
		end
		-- make sure width of skin frame adjusts after 1st showing
		if not xOfs then
			xOfs = 190
		else
			xOfs = 210
		end
		this.BottomFrame.sf:ClearAllPoints()
		this.BottomFrame.sf:SetPoint("TOPLEFT", this.BottomFrame, "TOPLEFT", xOfs * -1, 36)
		this.BottomFrame.sf:SetPoint("BOTTOMRIGHT", this.BottomFrame, "BOTTOMRIGHT", xOfs, 10)
	end)
	self:checkShown(_G.PetBattleFrame)

end
