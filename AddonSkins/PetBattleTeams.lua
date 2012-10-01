local aName, aObj = ...
if not aObj:isAddonEnabled("PetBattleTeams") then return end

function aObj:PetBattleTeams()

	-- mainFrame
	self:skinScrollBar{obj=PetBattleTeamsUI.scrollBar}
	self:addSkinFrame{obj=PetBattleTeamsUI.mainFrame, x1=3, y1=-2, y2=-1}
	PetBattleTeamsUI.mainFrame.menu.overlay:SetTexture(nil)
	PetBattleTeamsUI.mainFrame.menu:SetHighlightTexture([[Interface\Buttons\ButtonHilight-Square]])
	self:addButtonBorder{obj=PetBattleTeamsUI.mainFrame.menu, relTo=PetBattleTeamsUI.mainFrame.menu.icon}
	self:addButtonBorder{obj=PetBattleTeamsUI.mainFrame.addTeamButton}
	self:addButtonBorder{obj=PetBattleTeamsUI.mainFrame.revivePetsButton, sec=true}
	-- Pet buttons
	for i = 1, 24 do
		for j = 1, 3 do
			local btn = PetBattleTeamsUI.mainFrame.petUnitFrames[i][j]
			self:addButtonBorder{obj=btn, relTo=btn.Icon, reParent={btn.ActualHealthBar, btn.selected}}
			btn.ActualHealthBar:SetTexture(self.sbTexture)
			btn.BorderAlive:SetTexture(nil)
			self:changeTandC(btn.BorderDead, [[Interface\PetBattles\DeadPetIcon]])
			btn.HealthDivider:SetTexture(nil)
		end
	end
	
	-- tooltip
	if self.db.profile.Tooltips.skin then
		local obj = PetBattleTeamsUI.tooltip
		obj:DisableDrawLayer("BACKGROUND")
		obj.ActualHealthBar:SetTexture(self.sbTexture)
		obj.XPBar:SetTexture(self.sbTexture)
		obj.Delimiter:SetTexture(nil)
		self:addButtonBorder{obj=obj, relTo=obj.Icon, ofs=2, reParent={obj.Level}}
		self:addSkinFrame{obj=obj}
	end
	
end