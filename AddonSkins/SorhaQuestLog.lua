local aName, aObj = ...
if not aObj:isAddonEnabled("SorhaQuestLog") then return end
local _G = _G

function aObj:SorhaQuestLog()

	local function skinMinion(module, anchor)
		if _G[anchor] and _G[anchor].BorderFrame then
			aObj:addSkinFrame{obj=_G[anchor].BorderFrame}
		else
			local obj = _G.SorhaQuestLog:GetModule(module)
			if obj then
				aObj:SecureHook(obj, "CreateMinionLayout", function(this)
					aObj:addSkinFrame{obj=_G[anchor].BorderFrame}
					aObj:Unhook(obj, "CreateMinionLayout")
				end)
			end
		end
	end
	-- skin anchor minions
	skinMinion("AchievementTracker", "SQLAchievementMinionAnchor")
	skinMinion("QuestTracker", "SQLQuestMinionAnchor")
	skinMinion("QuestTimersTracker", "SQLQuestTimerAnchor")
	skinMinion("RemoteQuestsTracker", "SQLRemoteQuestsAnchor")
	skinMinion("ScenarioTracker", "SQLScenarioQuestsMinionAnchor")

	-- config options
	local sqlat = _G.SorhaQuestLog:GetModule("AchievementTracker")
	if sqlat then
		sqlat.db.profile.StatusBarTexture = self.db.profile.StatusBar.texture
		sqlat.db.profile.Colours.AchievementStatusBarFillColour.r = self.db.profile.StatusBar.r
		sqlat.db.profile.Colours.AchievementStatusBarFillColour.g = self.db.profile.StatusBar.g
		sqlat.db.profile.Colours.AchievementStatusBarFillColour.b = self.db.profile.StatusBar.b
		sqlat.db.profile.Colours.AchievementStatusBarFillColour.a = self.db.profile.StatusBar.a
		sqlat = nil
	end
	local sqlst = _G.SorhaQuestLog:GetModule("ScenarioTracker")
	if sqlst then
		sqlst.db.profile.Colours.StatusBarFillColour.r = self.db.profile.StatusBar.r
		sqlst.db.profile.Colours.StatusBarFillColour.g = self.db.profile.StatusBar.g
		sqlst.db.profile.Colours.StatusBarFillColour.b = self.db.profile.StatusBar.b
		sqlst.db.profile.Colours.StatusBarFillColour.a = self.db.profile.StatusBar.a
		sqlst = nil
	end

end
