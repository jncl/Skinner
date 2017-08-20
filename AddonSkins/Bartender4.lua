local aName, aObj = ...
if not aObj:isAddonEnabled("Bartender4") then return end
local _G = _G

function aObj:Bartender4() -- v 4.7.9

	local BT4ABs = _G.Bartender4:GetModule("ActionBars", true)
	if not BT4ABs then return end

	self:SecureHook(_G.Bartender4, "ShowUnlockDialog", function(this)
		self:skinCheckButton{obj=_G.Bartender4Snapping}
		self:skinButton{obj=_G.Bartender4DialogLock}
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
		_G.MainMenuExpBar:DisableDrawLayer("OVERLAY", -1)
		_G.ExhaustionTick:SetAlpha(0)
		_G.ReputationWatchBar.StatusBar:DisableDrawLayer("ARTWORK", 0)
		_G.ArtifactWatchBar.StatusBar:DisableDrawLayer("ARTWORK", 0)
		_G.ArtifactWatchBar.Tick:SetAlpha(0)
		_G.HonorWatchBar.StatusBar:DisableDrawLayer("ARTWORK", 0)
		_G.HonorWatchBar.ExhaustionTick:SetAlpha(0)
	end
	if self.db.profile.MainMenuBar.glazesb then
		self:glazeStatusBar(_G.MainMenuExpBar, 0, self:getRegion(_G.MainMenuExpBar, 9), {_G.ExhaustionLevelFillBar})
		self:glazeStatusBar(_G.ReputationWatchBar.StatusBar, 0, _G.ReputationWatchBar.StatusBar.Background)
		self:glazeStatusBar(_G.ArtifactWatchBar.StatusBar, 0, _G.ArtifactWatchBar.StatusBar.Background, {_G.ArtifactWatchBar.StatusBar.Underlay})
		self:glazeStatusBar(_G.HonorWatchBar.StatusBar, 0, _G.HonorWatchBar.StatusBar.Background, {_G.HonorWatchBar.StatusBar.Underlay, _G.HonorWatchBar.ExhaustionLevelFillBar})
	end

end
