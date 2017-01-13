local aName, aObj = ...
if not aObj:isAddonEnabled("Bartender4") then return end
local _G = _G

function aObj:Bartender4()

	local BT4ABs = _G.Bartender4:GetModule("ActionBars", true)
	if not BT4ABs then return end

	self:SecureHook(_G.Bartender4, "ShowUnlockDialog", function(this)
		self:skinButton{obj=self:getChild(this.unlock_dialog, 2)} -- it's a checkbutton
		self:addSkinFrame{obj=this.unlock_dialog, kfs=true, nb=true, y1=6}
		self:Unhook(_G.Bartender4, "ShowUnlockDialog")
	end)

	-- skin ActionBar buttons
	for _, ab in _G.pairs(BT4ABs.actionbars) do
		for _, btn in _G.pairs(ab.buttons) do
			self:addButtonBorder{obj=btn, abt=true, sec=true}
		end
	end

	-- skin XPBar, ReputationWatchBar, ArtifactWatchBar, HonorWatchBar if required
	if not self.db.profile.MainMenuBar.skin then
		-- XPBar
		_G.ExhaustionTick:SetAlpha(0)
		self:keepRegions(_G.MainMenuExpBar, {1, 2, 3, 4, 5, 9, 10}) -- N.B. region 5 is rested XP, 9 is background, 10 is the normal XP
		-- ReputationWatchBar
		self:keepRegions(_G.ReputationWatchBar.StatusBar, {1, 2, 3, 4, 13, 14, 16}) -- 13 is background, 14 is the normal texture
		-- ArtifactWatchBar
		local awbsb = _G.ArtifactWatchBar.StatusBar
		awbsb:DisableDrawLayer("ARTWORK")
		_G.ArtifactWatchBar.Tick:SetAlpha(0)
		-- HonorWatchBar
		local hwbsb = _G.HonorWatchBar.StatusBar
		hwbsb:DisableDrawLayer("ARTWORK")
		_G.HonorWatchBar.ExhaustionTick:SetAlpha(0)
		if self.db.profile.MainMenuBar.glazesb then
			self:glazeStatusBar(_G.MainMenuExpBar, 0, self:getRegion(_G.MainMenuExpBar, 9), {_G.ExhaustionLevelFillBar})
			self:glazeStatusBar(_G.ReputationWatchBar.StatusBar, 0, _G.ReputationWatchBar.StatusBar.Background)
			self:glazeStatusBar(awbsb, 0, awbsb.Background, {awbsb.Underlay})
			self:glazeStatusBar(hwbsb, 0, hwbsb.Background, {hwbsb.Underlay, _G.HonorWatchBar.ExhaustionLevelFillBar})
		end
		awbsb, hwbsb = nil, nil
	end

end
