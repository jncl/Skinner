local floor = math.floor

function Skinner:QuestGuru()
	if not self.db.profile.QuestLog then return end

	-- LightHeaded support
	if IsAddOnLoaded("LightHeaded") then
		self:moveObject{obj=LightHeadedFrame, x=-55}
		self:RawHook(LightHeadedFrame, "SetPoint", function(this, point, relTo, relPoint, xOfs, yOfs)
			self:Debug("LHF_SP: [%s, %s, %s, %s, %s, %s, %s]", point, relTo, relPoint, xOfs, yOfs, relTo == QuestGuru_QuestLogFrame, floor(xOfs) > -16)
			if relTo == QuestGuru_QuestLogFrame and floor(xOfs) > -56 then xOfs = -55 end
			self.hooks[this].SetPoint(this, point, relTo, relPoint, xOfs, yOfs)
		end, true)
	end

	local function colourText(type)

		_G["QuestGuru_Quest"..type.."StartLabel"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["QuestGuru_Quest"..type.."StartPos"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["QuestGuru_Quest"..type.."StartNPCName"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["QuestGuru_Quest"..type.."FinishLabel"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["QuestGuru_Quest"..type.."FinishPos"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["QuestGuru_Quest"..type.."FinishNPCName"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["QuestGuru_Quest"..type.."FinishPos"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["QuestGuru_Quest"..type.."QuestTitle"]:SetTextColor(self.HTr, self.HTg, self.HTb)
		_G["QuestGuru_Quest"..type.."DescriptionTitle"]:SetTextColor(self.HTr, self.HTg, self.HTb)
		_G["QuestGuru_Quest"..type.."RewardTitleText"]:SetTextColor(self.HTr, self.HTg, self.HTb)
		_G["QuestGuru_Quest"..type.."PlayerTitleText"]:SetTextColor(self.HTr, self.HTg, self.HTb)
		_G["QuestGuru_Quest"..type.."ObjectivesText"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["QuestGuru_Quest"..type.."TimerText"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["QuestGuru_Quest"..type.."RequiredMoneyText"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["QuestGuru_Quest"..type.."SuggestedGroupNum"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["QuestGuru_Quest"..type.."QuestDescription"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["QuestGuru_Quest"..type.."ItemChooseText"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["QuestGuru_Quest"..type.."ItemReceiveText"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["QuestGuru_Quest"..type.."SpellLearnText"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["QuestGuru_Quest"..type.."HonorFrameReceiveText"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G["QuestGuru_Quest"..type.."TalentFrameReceiveText"]:SetTextColor(self.BTr, self.BTg, self.BTb)
		-- XP text
		if type == "Log" then
			QuestGuru_QuestLogXPFrameReceiveText:SetTextColor(self.BTr, self.BTg, self.BTb)
		end
		if type == "History" then
			QuestGuru_QuestHistoryXPText:SetTextColor(self.BTr, self.BTg, self.BTb)
		end
	end
	-- m/p buttons
	if self.db.profile.Buttons then
		-- hook to manage changes to button textures (Current Tab)
		self:SecureHook("QuestLog_Update", function()
			for i = 1, QUESTGURU_QUESTS_DISPLAYED do
				self:checkTex(_G["QuestGuru_QuestLogTitle"..i])
			end
		end)
		if IsAddOnLoaded("QuestGuru_History") then
			-- hook to manage changes to button textures (History Tab)
			self:SecureHook("QuestGuru_UpdateHistory", function()
				for i = 1, QUESTGURU_QUESTS_DISPLAYED do
					self:checkTex(_G["QuestGuru_QuestHistoryTitle"..i])
				end
			end)
		end
		-- hook to manage changes to button textures (Abandoned Tab)
		self:SecureHook("QuestGuru_UpdateAbandon", function()
			for i = 1, QUESTGURU_QUESTS_DISPLAYED do
				self:checkTex(_G["QuestGuru_QuestAbandonTitle"..i])
			end
		end)
	end
-->>-- Quest Log frame
	self:keepFontStrings(QuestGuru_QuestLogCount)
	self:keepFontStrings(QuestGuru_EmptyQuestLogFrame)
	self:skinButton{obj=QuestGuru_QuestFrameExpandCollapseButton, x1=-2}
	self:skinButton{obj=QuestGuru_QuestLogFrameCloseButton, cb=true}
	self:skinButton{obj=QuestGuru_QuestFrameExitButton}
	self:skinButton{obj=QuestGuru_QuestFrameOptionsButton}
	self:skinFFToggleTabs("QuestGuru_QuestLogFrameTab", QUESTGURU_NUMTABS)
	self:moveObject{obj=QuestGuru_QuestLogFrameTab1, y=-10}
	QuestGuru_QuestLogFrameTab1.SetPoint = function() end -- stop it being moved again
	QuestGuru_QuestLogDummyText:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:addSkinFrame{obj=QuestGuru_QuestLogFrame, kfs=true, x1=6, y1=-6, x2=-45, y2=14}
-->>-- Empty QuestLog frame
	QuestGuru_QuestLogNoQuestsText:SetTextColor(self.BTr, self.BTg, self.BTb)
-->>-- Tab1 (Current)
	self:SecureHook("QuestLog_UpdateQuestDetails", function(...)
		colourText("Log")
		-- Quest objectives
		for i = 1, MAX_OBJECTIVES do
			local r, g, b = _G["QuestGuru_QuestLogObjective"..i]:GetTextColor()
			_G["QuestGuru_QuestLogObjective"..i]:SetTextColor(self.BTr - r, self.BTg - g, self.BTb - b)
		end
	end)
	for i = 1, QUESTGURU_QUESTS_DISPLAYED do
		self:skinButton{obj=_G["QuestGuru_QuestLogTitle"..i], mp=true}
	end
	self:skinScrollBar{obj=QuestGuru_QuestLogListScrollFrame}
	self:skinButton{obj=QuestGuru_QuestLogFrameAbandonButton}
	self:skinButton{obj=QuestGuru_QuestFramePushQuestButton}
	self:skinScrollBar{obj=QuestGuru_QuestLogDetailScrollFrame}
-->>-- Tab2 (History)
	if IsAddOnLoaded("QuestGuru_History") then
		self:SecureHook("QuestLog_UpdateQuestHistoryDetails", function(...)
			colourText("History")
			-- Quest objectives
			for i = 1, MAX_OBJECTIVES do
				local r, g, b = _G["QuestGuru_QuestHistoryObjective"..i]:GetTextColor()
				_G["QuestGuru_QuestHistoryObjective"..i]:SetTextColor(self.BTr - r, self.BTg - g, self.BTb - b)
			end
		end)
		self:skinEditBox{obj=QuestGuru_QuestHistorySearch, regs={9}}
		for i = 1, QUESTGURU_QUESTS_DISPLAYED do
			self:skinButton{obj=_G["QuestGuru_QuestHistoryTitle"..i], mp=true}
		end
		self:skinScrollBar{obj=QuestGuru_QuestHistoryListScrollFrame}
		self:skinScrollBar{obj=QuestGuru_QuestHistoryDetailScrollFrame}
		self:skinAllButtons{obj=QuestGuru_TabPage2}
		self:addSkinFrame{obj=QuestGuru_TabPage2, kfs=true, x1=10, y1=-6, x2=-45, y2=16}
	end
-->>-- Tab3 (Abandoned)
	self:SecureHook("QuestLog_UpdateQuestAbandonDetails", function(...)
		colourText("Abandon")
	end)
	self:skinEditBox{obj=QuestGuru_QuestAbandonSearch, regs={9}}
	self:skinButton{obj=QuestGuru_QuestAbandonClearList}
	for i = 1, QUESTGURU_QUESTS_DISPLAYED do
		self:skinButton{obj=_G["QuestGuru_QuestAbandonTitle"..i], mp=true}
	end
	self:skinScrollBar{obj=QuestGuru_QuestAbandonListScrollFrame}
	self:skinScrollBar{obj=QuestGuru_QuestAbandonDetailScrollFrame}
-->>-- Tab4
-->>-- Tab5
-->>--	Tracker Frame(s)
	if IsAddOnLoaded("QuestGuru_Tracker") then
		if self.db.profile.WatchFrame then
			self:addSkinFrame{obj=QGT_QuestWatchFrame, kfs=true}
			QGT_SetQuestWatchBorder = function() end
			self:addSkinFrame{obj=QGT_AchievementWatchFrame, kfs=true}
			QGT_SetAchievementWatchBorder = function() end
		end
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
