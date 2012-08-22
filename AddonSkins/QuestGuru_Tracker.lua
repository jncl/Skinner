local aName, aObj = ...
if not aObj:isAddonEnabled("QuestGuru_Tracker") then return end

function aObj:QuestGuru_Tracker()
	if not self.db.profile.WatchFrame.skin then return end

	self:addSkinFrame{obj=QGT_QuestWatchFrame, kfs=true}
	QGT_SetQuestWatchBorder = function() end
	self:addSkinFrame{obj=QGT_AchievementWatchFrame, kfs=true}
	QGT_SetAchievementWatchBorder = function() end
	self:skinSlider(QGT_QuestWatchFrameSlider)
	self:skinSlider(QGT_AchievementWatchFrameSlider)
	-- glaze Achievement StatusBars
	for i = 1, 40 do
		local sBar = "QGT_AchievementWatchLine"..i.."StatusBar"
		if not self.sbGlazed[_G[sBar]] then
			self:removeRegions(_G[sBar], {3, 4, 5}) -- remove textures
			self:glazeStatusBar(_G[sBar], 0, _G[sBar.."BG"])
		end
	end
	-- Tooltips
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then
			QGT_AchievementWatchFrameTooltip:SetBackdrop(self.Backdrop[1])
			QGT_QuestWatchFrameTooltip:SetBackdrop(self.Backdrop[1])
		end
		self:SecureHook(QGT_AchievementWatchFrameTooltip, "Show", function()
			self:skinTooltip(QGT_AchievementWatchFrameTooltip)
		end)
		self:SecureHook(QGT_QuestWatchFrameTooltip, "Show", function()
			self:skinTooltip(QGT_QuestWatchFrameTooltip)
		end)
	end

end
