local _, aObj = ...
if not aObj:isAddonEnabled("WorldQuestTracker") then return end
local _G = _G

aObj.addonsToSkin.WorldQuestTracker = function(self) -- v 10.0.0.451-Retail

	_G.WorldQuestTrackerZoneSummaryFrame.Header.Background:SetTexture(nil)
	_G.WorldQuestTrackerSummaryHeader.BlackBackground:SetTexture(nil)
	_G.WorldQuestTrackerQuestsHeader.Background:SetTexture(nil)
	if self.modBtnBs then
		self:addButtonBorder{obj=_G.WorldQuestTrackerScreenPanel.MinimizeButton, es=12, ofs=0, x1=-1}
	end

	if self.modBtns then
		self:SecureHookScript(_G.LFGListFrame.SearchPanel.ScrollBox.StartGroupButton, "OnClick", function(this)
			_G.C_Timer.After(0.1, function()
				self:skinCloseButton{obj=_G.WorldQuestTrackerGroupFinderPopup.CloseButton, noSkin=true}
			end)

			self:Unhook(this, "OnClick")
		end)
	end

	if _G.WorldQuestTrackerAddon.db.profile.use_quest_summary then
		self:SecureHook(_G.WorldQuestTrackerAddon, "UpdateZoneSummaryFrame", function()
			if not _G.WorldQuestTrackerAddon.CanShowZoneSummaryFrame() then
				return
			end
			for i = 1, #_G.WorldQuestTrackerAddon.ZoneSumaryWidgets do
				self:getRegion(_G.WorldQuestTrackerAddon.ZoneSumaryWidgets[i], 1):SetTexture(nil) -- art texture
				_G.WorldQuestTrackerAddon.ZoneSumaryWidgets[i].BlackBackground:SetTexture(nil)
			end
		end)
	end

	if self.prdb.ObjectiveTracker.skin then
		self:skinObject("frame", {obj=_G.WorldQuestTrackerScreenPanel_QuestHolder, fType=ftype, kfs=true, x1=-25, y1=4, x2=3})
		self:SecureHook(_G.WorldQuestTrackerAddon, "UpdateTrackerScale", function()
			_G.WorldQuestTrackerScreenPanel_QuestHolder.sf:SetScale(_G.WorldQuestTrackerAddon.db.profile.tracker_scale)
		end)
		self:SecureHook(_G.WorldQuestTrackerAddon, "RefreshTrackerWidgets", function()
			if _G.WorldQuestTrackerScreenPanel_QuestHolder.sf then
				_G.WorldQuestTrackerScreenPanel_QuestHolder.sf:SetShown(_G.WorldQuestTrackerQuestsHeader:IsShown())
			end
		end)
	end

end
