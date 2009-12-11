
function Skinner:QuestGuru()
	if not self.db.profile.QuestLog then return end

	-- History Frame bits
	if self.db.profile.Buttons then
		-- hook to manage changes to button textures
		self:SecureHook("QuestGuru_History_Update", function()
			for i = 1, 27 do
				self:checkTex(_G["QuestGuru_HistoryTitle"..i])
			end
		end)
	end
	-- button on QL frame
	self:skinButton{obj=QuestGuru_HistoryFrameShowButton}
	-- History Frame
	self:skinEditBox{obj=QuestGuru_HistorySearch, regs={9}}
	self:moveObject{obj=QuestGuru_HistoryFrameExpandCollapseButton:GetFontString(), x=2}
	for i = 1, 27 do
		self:skinButton{obj=_G["QuestGuru_HistoryTitle"..i], mp=true}
	end
	self:skinScrollBar{obj=QuestGuru_HistoryListScrollFrame}
	self:skinAllButtons{obj=QuestGuru_HistoryFrame}
	self:addSkinFrame{obj=QuestGuru_HistoryFrame, kfs=true, x1=10, y1=-6, x2=-45, y2=16}

-->>--	Tracker Frame(s)
	if IsAddOnLoaded("QuestGuru_Tracker") then
		self:addSkinFrame{obj=QGT_QuestWatchFrame, kfs=true}
		self:RawHook("QGT_SetQuestWatchBorder", function(...) end, true)
		self:addSkinFrame{obj=QGT_AchievementWatchFrame, kfs=true}
		self:RawHook("QGT_SetAchievementWatchBorder", function(...) end, true)
		self:skinSlider(QGT_QuestWatchFrameSlider)
		self:skinSlider(QGT_AchievementWatchFrameSlider)
		-- glaze Achievement StatusBars
		for i = 1, 40 do
			local sBar = _G["QGT_AchievementWatchLine"..i].statusBar
			if not self.sbGlazed[sBar] then
				self:removeRegions(sBar, {3, 4, 5}) -- remove textures
				self:glazeStatusBar(sBar, 0)
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

end
