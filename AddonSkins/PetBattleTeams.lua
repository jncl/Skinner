local aName, aObj = ...
if not aObj:isAddonEnabled("PetBattleTeams") then return end
local _G = _G

aObj.addonsToSkin.PetBattleTeams = function(self) -- v 3.3.11

	local PBT = _G.LibStub("AceAddon-3.0"):GetAddon("PetBattleTeams", true)
	local pbtui = PBT:GetModule("GUI")
	if not pbtui then return end

	local function skinTeamFrame(frame)
		for i = 1, 3 do
			local btn = frame.unitFrames[i]
			if self.modBtnBs then
				aObj:addButtonBorder{obj=btn, relTo=btn.Icon, reParent={btn.ActualHealthBar, frame.selectedTexture, frame.lockedTexture}}
			end
			btn.healthBarWidth = 34
			btn.ActualHealthBar:SetWidth(34)
			btn.ActualHealthBar:SetTexture(aObj.sbTexture)
			btn.BorderAlive:SetTexture(nil)
			aObj:changeTandC(btn.BorderDead, [[Interface\PetBattles\DeadPetIcon]])
			btn.HealthDivider:SetTexture(nil)
		end
	end
	local function skinTeams()
		aObj:Debug("skinTeams: [%s]", #_G["PetBattleTeamsRosterFrame"].scrollChild.teamFrames)
		for i = 1, #_G["PetBattleTeamsRosterFrame"].scrollChild.teamFrames do
			skinTeamFrame(_G["PetBattleTeamsRosterFrame"].scrollChild.teamFrames[i])
		end

	end
	self:SecureHook(pbtui, "InitializeGUI", function(this)
		-- skin frame
		self:skinSlider{obj=this.mainFrame.rosterFrame.scrollFrame.ScrollBar}
		this.menuButton.overlay:SetTexture(nil)
		self:addSkinFrame{obj=this.mainFrame, ft="a", kfs=true, nb=true, y1=2, y2=-5}
		if self.modBtns then
			self:addSkinButton{obj=this.menuButton, parent=this.menuButton, sap=true}
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=this.mainFrame.addTeamButton}
			self:addButtonBorder{obj=this.mainFrame.reviveButton}
			self:addButtonBorder{obj=this.mainFrame.bandageButton}
		end
		-- Selected Team
		skinTeamFrame(this.mainFrame.selectedTeam)
		-- Team Roster, wait for them to be created
		_G.C_Timer.After(0.2, function()
			skinTeams()
		end)
		self:Unhook(this, "InitializeGUI")
	end)
	-- hook this to handle roster changes
	self:SecureHook(pbtui, "CreateScrollBar", function(this)
		local tm = _G.LibStub("AceAddon-3.0"):GetAddon("PetBattleTeams"):GetModule("TeamManager")
	    tm.RegisterCallback(self, "TEAM_CREATED", skinTeams)
	    tm.RegisterCallback(self, "TEAM_UPDATED", skinTeams)
		tm = nil
		self:Unhook(this, "CreateScrollBar")
	end)
	pbtui = nil

	-- tooltip
	if self.db.profile.Tooltips.skin then
		local tt = PBT:GetModule("Tooltip").tooltip
		if tt then
			tt:DisableDrawLayer("BACKGROUND")
			tt.ActualHealthBar:SetTexture(self.sbTexture)
			tt.XPBar:SetTexture(self.sbTexture)
			tt.Delimiter:SetTexture(nil)
			if self.modBtnBs then
				self:addButtonBorder{obj=tt, relTo=tt.Icon, ofs=2, reParent={tt.Level}}
			end
			self:addSkinFrame{obj=tt, ft="a", kfs=true, nb=true}
		end
		tt = nil
	end

	PBT = nil

end
