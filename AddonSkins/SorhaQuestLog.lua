-- luacheck: ignore 631 (line is too long)
local _, aObj = ...
if not aObj:isAddonEnabled("SorhaQuestLog") then return end
local _G = _G

aObj.addonsToSkin.SorhaQuestLog = function(self) -- v1.5.5.1

	local SorhaQuestLog = _G.LibStub:GetLibrary("AceAddon-3.0"):GetAddon("SorhaQuestLog", true)

	local modInfo = {
		["AchievementTracker"]  = "SQLAchievementMinionBorder",
		["ActivitiesTracker"]   = "SQLActivitiesMinionBorder",
		["AdventureTracker"]    = "SQLAdventureMinionBorder",
		["QuestTracker"]        = "SQLQuestMinionBorder",
		["RemoteQuestsTracker"] = "SQLRemoteQuestsMinionBorder",
		["ScenarioTracker"]     = "SQLScenarioQuestsMinionBorder",
	}

	local function checkAutoHide(obj)
		local mName = obj:GetName()
		local minion = _G[modInfo[mName]]
		local mParent = minion:GetParent()
		if obj.db.profile.AutoHideTitle == true then
			if mParent.objFontString:GetText() then
				minion.sf:Show()
			else
				minion.sf:Hide()
			end
		else
			minion.sf:Show()
		end
	end
	local function skinMinion(obj, frame)
		if _G[frame] then
			aObj:skinObject("frame", {obj=_G[frame]})
			checkAutoHide(obj)
		else
			aObj:SecureHook(obj, "CreateMinionLayout", function(this)
				aObj:skinObject("frame", {obj=_G[modInfo[this:GetName()]]})
				checkAutoHide(this)
				aObj:Unhook(this, "CreateMinionLayout")
			end)
		end
		aObj:SecureHook(obj, "UpdateMinion", function(this)
			checkAutoHide(this)
		end)
	end

	-- change options & skin minions
	SorhaQuestLog.db.profile.StatusBarTexture  = self.db.profile.StatusBar.texture
	SorhaQuestLog.db.profile.BorderTexture     = "None"
	SorhaQuestLog.db.profile.BackgroundTexture = "None"
	for mName, frame in pairs(modInfo) do
		local mod = SorhaQuestLog:GetModule(mName)
		if mod then
			skinMinion(mod, frame)
			if mod.db.profile.Colours
			and mod.db.profile.Colours.StatusBarFillColour
			then
				mod.db.profile.Colours.StatusBarFillColour.r = self.db.profile.StatusBar.r
				mod.db.profile.Colours.StatusBarFillColour.g = self.db.profile.StatusBar.g
				mod.db.profile.Colours.StatusBarFillColour.b = self.db.profile.StatusBar.b
				mod.db.profile.Colours.StatusBarFillColour.a = self.db.profile.StatusBar.a
			end
			-- N.B. RemoteQuestsTracker is currently broken 12.08.24 the .ScrollChild doesn't exist as the template has changed in 11.0.0
			-- local function skinBtn(obj)
			-- 	for k, reg in _G.ipairs{obj:GetRegions()} do
			-- 		if k < 11 or k > 17 then -- Animated textures
			-- 			reg:SetTexture(nil)
			-- 		end
			-- 		obj.QuestIconBadgeBorder:SetTexture(nil)
			-- 	end
			-- 	obj.FlashFrame:DisableDrawLayer("OVERLAY") -- hide IconBg flash texture
			-- end
			-- if mName == "RemoteQuestsTracker" then
			-- 	self:RawHook(mod, "GetMinionButton", function(this)
			-- 		local btn = self.hooks[this].GetMinionButton(this)
			-- 		skinBtn(btn.ScrollChild)
			-- 		return btn
			-- 	end, true)
			-- 	-- skin any existing buttons
			-- 	for i = 1, 5 do
			-- 		if _G[mName .. "Button" .. i] then
			-- 			skinBtn(_G[mName .. "Button" .. i].ScrollChild)
			-- 		end
			-- 	end
			-- end
		end
	end

end
