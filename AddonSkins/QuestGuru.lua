
function Skinner:QuestGuru()
	if not self.db.profile.QuestLog then return end

	-- hook this for LightHeaded support
	if IsAddOnLoaded("LightHeaded") then
		self:SecureHookScript(QuestGuru_QuestLogFrame, "OnUpdate", function(this, elapsed)
			if not LightHeaded.db.profile.open and LightHeaded.db.profile.lhopen and (not LightHeadedFrameSub.justclosed or LightHeadedFrameSub.justclosed == nil) then
				self:moveObject{obj=LightHeadedFrame, x=-2}
			end
		end)
	end

	-- hook this to change the Quest text colours
	self:SecureHook("QuestGuru_ColorizeText", function(inText)
		for _, v1 in pairs{"Log", "History", "Abandon"} do
			for i = 1, 10 do
				local text = _G["QuestGuru_Quest"..v1.."Objective"..i]
				if text then
					local r, g, b, a = text:GetTextColor()
					text:SetTextColor(self.BTr - r, self.BTg - g, self.BTb)
				end
		   	end
			for _, v2 in pairs{ "Start", "Finish" } do
				local text = _G["QuestGuru_Quest"..v1..v2.."Pos"]
				if text then
					text:SetTextColor(self.BTr, self.BTg, self.BTb)
					if not QuestGuru_Settings.Colorize.NPCNames.Enabled or (v1 == "Abandon" and v2 == "Finish") then
						local text = _G["QuestGuru_Quest"..v1..v2.."NPCName"]
						text:SetTextColor(self.BTr, self.BTg, self.BTb)
					end
				end
			end
		end
	end)

	local headingText = {"QuestTitle", "DescriptionTitle", "RewardTitleText"}
	local bodyText = {"ObjectivesText", "TimerText", "RequiredMoneyText", "SuggestedGroupNum", "QuestDescription", "ItemChooseText", "ItemReceiveText", "SpellLearnText", "PlayerTitleText", "StartLabel", "FinishLabel", }--"TalentReceiveText"

	local function colourText(textType)

		for _, v in pairs(headingText) do
			local text = _G["QuestGuru_Quest"..textType..v]
			text:SetTextColor(self.HTr, self.HTg, self.HTb)
		end
		for _, v in pairs(bodyText) do
			local text = _G["QuestGuru_Quest"..textType..v]
			text:SetTextColor(self.BTr, self.BTg, self.BTb)
		end

	end

-->>-- Quest Log Frame (TabPage1)
	self:addSkinFrame{obj=QuestGuru_QuestLogFrame, kfs=true, x1=5, y1=-6, x2=-45, y2=12}
	self:keepFontStrings(QuestGuru_QuestLogCount)
	self:skinFFToggleTabs("QuestGuru_QuestLogFrameTab", QUESTGURU_NUMTABS)
	self:moveObject{obj=QuestGuru_QuestLogFrameTab1, x=4, y=-12}
	self:RawHook(QuestGuru_QuestLogFrameTab1, "SetPoint", function() end, true)
	
	QuestGuru_QuestLogTalentFrameTalentReceiveText:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:skinScrollBar{obj=QuestGuru_QuestLogListScrollFrame}
	self:skinScrollBar{obj=QuestGuru_QuestLogDetailScrollFrame}
	colourText("Log")
-->>-- History Frame (TabPage2)
	if QuestGuru_TabPage2 then
		QuestGuru_QuestHistoryTalentFrameTalentReceiveText:SetTextColor(self.BTr, self.BTg, self.BTb)
		self:skinEditBox{obj=QuestGuru_QuestHistorySearch, regs={9}}
		self:skinScrollBar{obj=QuestGuru_QuestHistoryListScrollFrame}
		self:skinScrollBar{obj=QuestGuru_QuestHistoryDetailScrollFrame}
		QuestGuru_QuestHistoryXPText:SetTextColor(self.BTr, self.BTg, self.BTb)
		QuestGuru_QuestHistoryRepText:SetTextColor(self.BTr, self.BTg, self.BTb)
		colourText("History")
	end
-->>-- Abandoned Frame (TabPage3)
	QuestGuru_QuestAbandonTalentFrameTalentReceiveText:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:skinEditBox{obj=QuestGuru_QuestAbandonSearch, regs={9}}
	self:skinScrollBar{obj=QuestGuru_QuestAbandonListScrollFrame}
	self:skinScrollBar{obj=QuestGuru_QuestAbandonDetailScrollFrame}
	colourText("Abandon")

-->>--	Options Frame
	self:skinEditBox{obj=QuestGuru_AnnounceFrameChannelWhisperTo, regs={9}, noHeight=true}
	self:skinEditBox{obj=QuestGuru_AnnounceFrameMessageItem, regs={9}, noHeight=true}
	self:skinEditBox{obj=QuestGuru_AnnounceFrameMessageMonster, regs={9}, noHeight=true}
	self:skinEditBox{obj=QuestGuru_AnnounceFrameMessageEvent, regs={9}, noHeight=true}
	self:skinEditBox{obj=QuestGuru_AnnounceFrameMessageQuest, regs={9}, noHeight=true}

-->>--	Tracker Frame(s)
	if IsAddOnLoaded("QuestGuru_Tracker") then
		if self.db.profile.TrackerFrame.skin then
			self:addSkinFrame{obj=QGT_QuestWatchFrame, kfs=true}
			self:RawHook("QGT_SetQuestWatchBorder", function(...) end, true)
			self:addSkinFrame{obj=QGT_AchievementWatchFrame, kfs=true}
			self:RawHook("QGT_SetAchievementWatchBorder", function(...) end, true)
		end
		if self.db.profile.TrackerFrame.clean then
			self:skinSlider(QGT_QuestWatchFrameSlider)
			self:skinSlider(QGT_AchievementWatchFrameSlider)
		end
		if self.db.profile.TrackerFrame.glazesb then
			-- glaze Achievement StatusBars
			for i = 1, 40 do
				local sBar = _G["QGT_AchievementWatchLine"..i].statusBar
				if not self.sbGlazed[sBar] then
					self:removeRegions(sBar, {3, 4, 5}) -- remove textures
					self:glazeStatusBar(sBar, 0)
				end
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

-->>--	QuestStartInfo Frame
	self:addSkinFrame{obj=QuestGuru_QuestStartInfoFrame, kfs=true}
	QuestGuru_QuestStartInfoTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
	QuestGuru_QuestStartInfoTimeLabel:SetTextColor(self.BTr, self.BTg, self.BTb)
	QuestGuru_QuestStartInfoTime:SetTextColor(self.BTr, self.BTg, self.BTb)
	QuestGuru_QuestStartInfoLevelLabel:SetTextColor(self.BTr, self.BTg, self.BTb)
	QuestGuru_QuestStartInfoLevel:SetTextColor(self.BTr, self.BTg, self.BTb)

	self:SecureHook("QuestGuru_QuestAbandonStart_OnEnter", function()
		if not QuestGuru_Settings.Colorize.NPCNames.Enabled then
			QuestGuru_QuestStartInfoNPC:SetTextColor(self.BTr, self.BTg, self.BTb)
		end
		if not QuestGuru_Settings.Colorize.AreaNames.Enabled then
			QuestGuru_QuestStartInfoPOS:SetTextColor(self.BTr, self.BTg, self.BTb)
			QuestGuru_QuestStartInfoArea:SetTextColor(self.BTr, self.BTg, self.BTb)
		end
	end)

end
