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
			obj = nil
		end
	end
	-- skin anchor minions
	skinMinion("AchievementTracker", "SQLAchievementMinionAnchor")
	skinMinion("QuestTracker", "SQLQuestMinionAnchor")
	skinMinion("RemoteQuestsTracker", "SQLRemoteQuestsAnchor")
	skinMinion("ScenarioTracker", "SQLScenarioQuestsMinionAnchor")

	-- config options
	_G.SorhaQuestLog.db.profile.StatusBarTexture = self.db.profile.StatusBar.texture
	for _, mName in pairs{"AchievementTracker", "QuestTracker", "ScenarioTracker"} do
		local mod = _G.SorhaQuestLog:GetModule(mName)
		if mod then
			mod.db.profile.Colours.StatusBarFillColour.r = self.db.profile.StatusBar.r
			mod.db.profile.Colours.StatusBarFillColour.g = self.db.profile.StatusBar.g
			mod.db.profile.Colours.StatusBarFillColour.b = self.db.profile.StatusBar.b
			mod.db.profile.Colours.StatusBarFillColour.a = self.db.profile.StatusBar.a
		end
		mod = nil
	end

end
