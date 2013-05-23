local aName, aObj = ...
if not aObj:isAddonEnabled("SorhaQuestLog") then return end
local _G = _G

function aObj:SorhaQuestLog()

	-- skin anchor minions
	self:addSkinFrame{obj=_G.SQLQuestMinionBorder}
	self:addSkinFrame{obj=_G.SQLQuestTimerMinionBorder}
	self:addSkinFrame{obj=_G.SQLScenarioQuestsMinionBorder}
	-- the following Minion anchor BorderFrame(s) are the same
	self:addSkinFrame{obj=_G["SQLAchievementMinionAnchor"].BorderFrame}
	self:addSkinFrame{obj=_G["SQLRemoteQuestsAnchor"].BorderFrame}

	-- config options
	local sqlat = _G.SorhaQuestLog:GetModule("AchievementTracker")
	sqlat.db.profile.StatusBarTexture = self.db.profile.StatusBar.texture
	sqlat.db.profile.Colours.AchievementStatusBarFillColour.r = self.db.profile.StatusBar.r
	sqlat.db.profile.Colours.AchievementStatusBarFillColour.g = self.db.profile.StatusBar.g
	sqlat.db.profile.Colours.AchievementStatusBarFillColour.b = self.db.profile.StatusBar.b
	sqlat.db.profile.Colours.AchievementStatusBarFillColour.a = self.db.profile.StatusBar.a
	local sqlst = _G.SorhaQuestLog:GetModule("ScenarioTracker")
	sqlst.db.profile.Colours.StatusBarFillColour.r = self.db.profile.StatusBar.r
	sqlst.db.profile.Colours.StatusBarFillColour.g = self.db.profile.StatusBar.g
	sqlst.db.profile.Colours.StatusBarFillColour.b = self.db.profile.StatusBar.b
	sqlst.db.profile.Colours.StatusBarFillColour.a = self.db.profile.StatusBar.a
	
end
