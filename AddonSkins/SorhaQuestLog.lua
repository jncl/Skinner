local aName, aObj = ...
if not aObj:isAddonEnabled("SorhaQuestLog") then return end
local _G = _G

function aObj:SorhaQuestLog()

	local modInfo = {
		["AchievementTracker"] = "SQLAchievementMinionBorder",
		["QuestTracker"] = "SQLQuestMinionBorder",
		["RemoteQuestsTracker"] = "SQLRemoteQuestsMinionBorder",
		["ScenarioTracker"] = "SQLScenarioQuestsMinionBorder",
	}

	local function checkAutoHide(obj)
		local mName = obj:GetName()
		if obj.db.profile.AutoHideTitle == true then
			if (mName:find("Achievement")
			and _G.GetNumTrackedAchievements() > 0)
			or (mName:find("QuestT") -- differentiate between QuestTracker & RemoteQuestsTracker
			and _G.SQLQuestMinionAnchor.buttonShowHidden:IsShown())
			or (mName:find("Remote")
			and _G.GetNumAutoQuestPopUps() > 0)
			or (mName:find("Scenario")
			and _G.C_Scenario.IsInScenario() == true)
			then
				_G[modInfo[mName]]:Show()
			else
				_G[modInfo[mName]]:Hide()
			end
		else
			_G[modInfo[mName]]:Show()
		end
		mName = nil
	end
	local function skinMinion(obj, border)
		if _G[border] then
			aObj:addSkinFrame{obj=_G[border]}
			checkAutoHide(obj)
		else
			aObj:SecureHook(obj, "CreateMinionLayout", function(this)
				aObj:addSkinFrame{obj=_G[modInfo[this:GetName()]]}
				checkAutoHide(this)
				aObj:Unhook(obj, "CreateMinionLayout")
			end)
		end
		aObj:SecureHook(obj, "UpdateMinion", function(this)
			checkAutoHide(this)
		end)
	end

	-- change options & skin minions
	_G.SorhaQuestLog.db.profile.StatusBarTexture = self.db.profile.StatusBar.texture
	_G.SorhaQuestLog.db.profile.BorderTexture = "None"
	_G.SorhaQuestLog.db.profile.BackgroundTexture = "None"
	for mName, border in pairs(modInfo) do
		local mod = _G.SorhaQuestLog:GetModule(mName)
		if mod then
			-- skin anchor minions
			skinMinion(mod, border)
			-- config options
			if not mod == "RemoteQuestsTracker" then
				mod.db.profile.Colours.StatusBarFillColour.r = self.db.profile.StatusBar.r
				mod.db.profile.Colours.StatusBarFillColour.g = self.db.profile.StatusBar.g
				mod.db.profile.Colours.StatusBarFillColour.b = self.db.profile.StatusBar.b
				mod.db.profile.Colours.StatusBarFillColour.a = self.db.profile.StatusBar.a
			end
		end
		mod = nil
	end

	-- RemoteQuestsTracker Button(s)
	local function skinBtn(obj)
		for k, reg in ipairs{obj:GetRegions()} do
			if k < 11 or k > 17 then reg:SetTexture(nil) end -- Animated textures
			if k == 13 then reg:SetTexture(nil) end -- IconBadgeBorder
		end
		obj.FlashFrame:DisableDrawLayer("OVERLAY") -- hide IconBg flash texture
	end
	-- hook this to skin new buttons
	self:RawHook(_G.SorhaQuestLog:GetModule("RemoteQuestsTracker"), "GetMinionButton", function(this)
		local btn = self.hooks[this].GetMinionButton(this)
		skinBtn(btn.ScrollChild)
		return btn
	end, true)
	-- skin any existing buttons
	for i = 1, 5 do
		if _G["RemoteQuestsTrackerButton" .. i] then
			skinBtn(_G["RemoteQuestsTrackerButton" .. i].ScrollChild)
		end
	end

end
