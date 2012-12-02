local aName, aObj = ...
if not aObj:isAddonEnabled("PetBattleTeams") then return end

function aObj:PetBattleTeams()

	local function skinTeamFrame(frame)

		for i = 1, 3 do
			local btn = frame[i]
			aObj:addButtonBorder{obj=btn, relTo=btn.Icon, reParent={btn.ActualHealthBar, frame.selectedTexture, frame.lockedTexture}}
			btn.healthBarWidth = 34
			btn.ActualHealthBar:SetWidth(34)
			btn.ActualHealthBar:SetTexture(aObj.sbTexture)
			btn.BorderAlive:SetTexture(nil)
			aObj:changeTandC(btn.BorderDead, [[Interface\PetBattles\DeadPetIcon]])
			btn.HealthDivider:SetTexture(nil)
		end

	end

	-- skin frame
	self:skinScrollBar{obj=PetBattleTeamsUI.scrollBar}
	PetBattleTeamsUI.mainFrame.menu.overlay:SetTexture(nil)
	self:addButtonBorder{obj=PetBattleTeamsUI.mainFrame.menu, ofs=-2, x1=3}
	self:addButtonBorder{obj=PetBattleTeamsUI.mainFrame.addTeamButton}
	self:addSkinFrame{obj=PetBattleTeamsUI.mainFrame, ofs=-3, y1=-2, y2=-1}
	-- Team Roster buttons
	for i = 1, #PetBattleTeamsUI.mainFrame.petUnitFrames do
		skinTeamFrame(PetBattleTeamsUI.mainFrame.petUnitFrames[i])
	end

	-- tooltip
	if self.db.profile.Tooltips.skin then
		local tt = PetBattleTeamsUI.tooltip
		tt:DisableDrawLayer("BACKGROUND")
		tt.ActualHealthBar:SetTexture(self.sbTexture)
		tt.XPBar:SetTexture(self.sbTexture)
		tt.Delimiter:SetTexture(nil)
		self:addButtonBorder{obj=tt, relTo=tt.Icon, ofs=2, reParent={tt.Level}}
		self:addSkinFrame{obj=tt}
	end

end
