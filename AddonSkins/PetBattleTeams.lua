local _, aObj = ...
if not aObj:isAddonEnabled("PetBattleTeams") then return end
local _G = _G

aObj.addonsToSkin.PetBattleTeams = function(self) -- v 3.3.11

	local PBT = _G.LibStub("AceAddon-3.0"):GetAddon("PetBattleTeams", true)
	local pbtui = PBT:GetModule("GUI")
	if not pbtui then return end

	local function skinTeamFrame(frame)
		for _, btn in _G.pairs(frame.unitFrames) do
			btn.healthBarWidth = 34
			btn.ActualHealthBar:SetWidth(34)
			aObj:changeTex2SB(btn.ActualHealthBar)
			btn.BorderAlive:SetTexture(nil)
			aObj:changeTandC(btn.BorderDead, aObj.tFDIDs.dpI)
			btn.HealthDivider:SetTexture(nil)
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=btn, relTo=btn.Icon, reParent={btn.ActualHealthBar, frame.selectedTexture, frame.lockedTexture}}
			end
		end
	end
	local function skinTeams()
		for _, frame in _G.pairs(_G["PetBattleTeamsRosterFrame"].scrollChild.teamFrames) do
			skinTeamFrame(frame)
		end
	end
	self:SecureHook(pbtui, "InitializeGUI", function(this)
		self:skinObject("slider", {obj=this.mainFrame.rosterFrame.scrollFrame.ScrollBar})
		this.menuButton.overlay:SetTexture(nil)
		this.menuButton:SetHighlightTexture(self.tFDIDs.bHLS)
		self:skinObject("frame", {obj=this.mainFrame, kfs=true, x1=2, y1=2, y2=-1})
		if self.modBtnBs then
			self:addButtonBorder{obj=this.menuButton, ofs=-1, x1=3, y1=-2}
			self:addButtonBorder{obj=this.mainFrame.addTeamButton, ofs=3}
			self:addButtonBorder{obj=this.mainFrame.reviveButton, ofs=3}
			self:addButtonBorder{obj=this.mainFrame.bandageButton, ofs=3}
		end
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
			self:changeTex2SB(tt.ActualHealthBar)
			self:changeTex2SB(tt.XPBar)
			tt.Delimiter:SetTexture(nil)
			self:skinObject("frame", {obj=tt})
			if self.modBtnBs then
				self:addButtonBorder{obj=tt, relTo=tt.Icon, ofs=2, reParent={tt.Level}}
			end
		end
		tt = nil
	end

	PBT = nil

end
