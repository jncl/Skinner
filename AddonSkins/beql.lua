
function Skinner:beql()
	if not self.db.profile.QuestLog then return end

	-- do nothing if only using simple QuestLog
	if beql.db.profile.QuestLog.style == "simple" then return end

	self:removeRegions(beqlQuestLogCollapseAllButton, {7, 8, 9})
	self:skinButton{obj=beqlQuestLogCollapseAllButton, mp=true}

	-- skin buttons on QL frame
--	self:skinButton{obj=beqlQuestLogFrameMinimizeButton, x1=6, y1=-6, x2=-6, y2=6} -- need the correct icon
	self:skinButton{obj=beqlQuestLogFrameConfigButton, tx=1, ty=0, y1=-2, y2=2}
	self:skinButton{obj=beqlQuestHistoryButton}

	-- History Frame
	if self.db.profile.Buttons then
		local function qlUpd()

			for i = 1, #beqlHistoryFrameCharlistScrollFrame.buttons do
				Skinner:checkTex(beqlHistoryFrameCharlistScrollFrame.buttons[i])
			end
			for i = 1, #beqlHistoryFrameQuestScrollFrame.buttons do
				Skinner:checkTex(beqlHistoryFrameQuestScrollFrame.buttons[i])
			end

		end
		-- hook these to manage changes to button textures
		self:SecureHook(beql, "UpdateBrwoserCharList", function()
			qlUpd()
		end)
		self:SecureHook(beql, "UpdateBrowserQuestList", function()
			qlUpd()
		end)
	end

	self:moveObject{obj=beqlHistoryFrameTitleText, y=-6}
	self:skinAllButtons{obj=beqlHistoryFrame}
	self:skinScrollBar{obj=beqlHistoryFrameCharlistScrollFrame}
	-- skin minus/plus buttons
	for i = 1, #beqlHistoryFrameCharlistScrollFrame.buttons do
		self:skinButton{obj=beqlHistoryFrameCharlistScrollFrame.buttons[i], mp=true, plus=true}
	end
	self:skinScrollBar{obj=beqlHistoryFrameQuestScrollFrame}
	-- skin minus/plus buttons
	for i = 1, #beqlHistoryFrameQuestScrollFrame.buttons do
		self:skinButton{obj=beqlHistoryFrameQuestScrollFrame.buttons[i], mp=true, plus=true}
	end
	self:addSkinFrame{obj=beqlHistoryFrame, kfs=true}

-->>-- Tooltips
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then beqlQuestWatchFrame.Tooltip:SetBackdrop(self.Backdrop[1]) end
		self:SecureHookScript(beqlQuestWatchFrame.Tooltip, "OnShow", function(this)
			self:skinTooltip(this)
		end)
	end
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then beqlAchievementWatchFrame.Tooltip:SetBackdrop(self.Backdrop[1]) end
		self:SecureHookScript(beqlAchievementWatchFrame.Tooltip, "OnShow", function(this)
			self:skinTooltip(this)
		end)
	end
-->>-- Watch frames
	if self.db.profile.WatchFrame then
		-- QuestWatch frame
		self:addSkinFrame{obj=beqlQuestWatchFrame.TitleFrame}
		self:addSkinFrame{obj=beqlQuestWatchFrame.Backdrop, y1=-2, y2=2}
		-- AchievementWatch frame
		self:addSkinFrame{obj=beqlAchievementWatchFrame.TitleFrame}
		self:addSkinFrame{obj=beqlAchievementWatchFrame.Backdrop, y1=-2}
		beql:AchievementTrackermaximize(beqlAchievementWatchFrame.TitleFrame.Minimize) -- force redraw
	end

end
