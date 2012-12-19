local aName, aObj = ...
if not aObj:isAddonEnabled("PetBattleTeams") then return end

function aObj:PetBattleTeams()

	local function skinTeamFrame(frame)

		for i = 1, 3 do
			local btn = frame.unitFrames[i]
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
	local pbtuimf = PetBattleTeams:GetModule("GUI").mainFrame
	self:skinScrollBar{obj=pbtuimf.rosterFrame.scrollFrame}
	self:addButtonBorder{obj=pbtuimf.addTeamButton}
	self:addButtonBorder{obj=pbtuimf.reviveButton}
	self:addButtonBorder{obj=pbtuimf.bandageButton}
	self:addSkinFrame{obj=pbtuimf, y1=2, y2=-5}
	-- Selected Team
	skinTeamFrame(pbtuimf.selectedTeam)
	-- Team Roster, wait for them to be created
	self:ScheduleTimer(function()
		for i = 1, #pbtuimf.rosterFrame.scrollChild.teamFrames do
			skinTeamFrame(pbtuimf.rosterFrame.scrollChild.teamFrames[i])
		end
	end, 0.2)

	-- tooltip
	if self.db.profile.Tooltips.skin then
		local tt = PetBattleTeams:GetModule("Tooltip").tooltip
		tt:DisableDrawLayer("BACKGROUND")
		tt.ActualHealthBar:SetTexture(self.sbTexture)
		tt.XPBar:SetTexture(self.sbTexture)
		tt.Delimiter:SetTexture(nil)
		self:addButtonBorder{obj=tt, relTo=tt.Icon, ofs=2, reParent={tt.Level}}
		self:addSkinFrame{obj=tt}
	end

end
