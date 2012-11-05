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

	-- skin frame if it exists
	local GUI = PetBattleTeams:GetModule("GUI")
	self:skinScrollBar{obj=GUI.mainFrame.rosterFrame.scrollFrame}
	self:addSkinFrame{obj=GUI.mainFrame, y1=2, y2=-5}
	skinTeamFrame(GUI.mainFrame.selectedTeam)
	self:addButtonBorder{obj=GUI.mainFrame.addTeamButton}
	-- Team Roster buttons
	for i = 1, #GUI.mainFrame.rosterFrame.scrollChild.teamFrames do
		skinTeamFrame(GUI.mainFrame.rosterFrame.scrollChild.teamFrames[i])
	end
	-- hook this to skin new teams
	self:RawHook(PetBattleTeamsFrame, "New", function(this)
		local frame = self.hooks[this].New(this)
		skinTeamFrame(frame)
		return frame
	end, true)

	-- tooltip
	if self.db.profile.Tooltips.skin then
		local tt = PetBattleTeams:GetModule("Tooltip")
		tt.tooltip:DisableDrawLayer("BACKGROUND")
		tt.tooltip.ActualHealthBar:SetTexture(self.sbTexture)
		tt.tooltip.XPBar:SetTexture(self.sbTexture)
		tt.tooltip.Delimiter:SetTexture(nil)
		self:addButtonBorder{obj=tt.tooltip, relTo=tt.tooltip.Icon, ofs=2, reParent={tt.tooltip.Level}}
		self:addSkinFrame{obj=tt.tooltip}
	end

end