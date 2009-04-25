
function Skinner:QuestGuru()
	if not self.db.profile.QuestLog.skin then return end

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
	QuestGuru_QuestLogFrame:SetWidth(QuestGuru_QuestLogFrame:GetWidth() - 46)
	self:keepFontStrings(QuestGuru_QuestLogFrame)
	self:applySkin(QuestGuru_QuestLogFrame)
	self:keepFontStrings(QuestGuru_QuestLogCount)
	self:skinFFToggleTabs("QuestGuru_QuestLogFrameTab", 5)
	self:moveObject(QuestGuru_QuestLogTrack, "-", 4, "+", 5)
	self:moveObject(QuestGuru_QuestFrameExpandCollapseButton, "-", 6, nil, nil)
	self:moveObject(QuestGuru_QuestLogFrameTab1, nil, nil, "-", 12)
	-- hook this to stop tabs from moving
	self:RawHook(QuestGuru_QuestLogFrameTab1, "SetPoint", function() end, true)
	self:moveObject(QuestGuru_QuestLogFrameCloseButton, "+", 44, "+", 5)
	self:moveObject(QuestGuru_QuestFrameExitButton, "+", 44, "-", 12)
	self:moveObject(QuestGuru_QuestLogFrameAbandonButton, "-", 4, "-", 12)
	QuestGuru_QuestLogTalentFrameTalentReceiveText:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:removeRegions(QuestGuru_QuestLogListScrollFrame)
	self:skinScrollBar(QuestGuru_QuestLogListScrollFrame)
	self:removeRegions(QuestGuru_QuestLogDetailScrollFrame)
	self:skinScrollBar(QuestGuru_QuestLogDetailScrollFrame)
	colourText("Log")
-->>-- History Frame
	if QuestGuru_TabPage2 then
		QuestGuru_QuestHistoryTalentFrameTalentReceiveText:SetTextColor(self.BTr, self.BTg, self.BTb)
		self:skinEditBox(QuestGuru_QuestHistorySearch, {9})
		self:removeRegions(QuestGuru_QuestHistoryListScrollFrame)
		self:skinScrollBar(QuestGuru_QuestHistoryListScrollFrame)
		self:removeRegions(QuestGuru_QuestHistoryDetailScrollFrame)
		self:skinScrollBar(QuestGuru_QuestHistoryDetailScrollFrame)
		QuestGuru_QuestHistoryXPText:SetTextColor(self.BTr, self.BTg, self.BTb)
		QuestGuru_QuestHistoryRepText:SetTextColor(self.BTr, self.BTg, self.BTb)
		self:moveObject(QuestGuru_QuestHistorySearchText, nil, nil, "-", 10)
		colourText("History")
	end
-->>-- Abandoned Frame (TabPage3)
	QuestGuru_QuestAbandonTalentFrameTalentReceiveText:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:skinEditBox(QuestGuru_QuestAbandonSearch, {9})
	self:removeRegions(QuestGuru_QuestAbandonListScrollFrame)
	self:skinScrollBar(QuestGuru_QuestAbandonListScrollFrame)
	self:removeRegions(QuestGuru_QuestAbandonDetailScrollFrame)
	self:skinScrollBar(QuestGuru_QuestAbandonDetailScrollFrame)
	self:moveObject(QuestGuru_QuestAbandonSearchText, nil, nil, "-", 10)
	colourText("Abandon")

-->>--	Options Frame
	self:skinEditBox(QuestGuru_AnnounceFrameChannelWhisperTo, {9}, nil, true)
	self:skinEditBox(QuestGuru_AnnounceFrameMessageItem, {9}, nil, true)
	self:skinEditBox(QuestGuru_AnnounceFrameMessageMonster, {9}, nil, true)
	self:skinEditBox(QuestGuru_AnnounceFrameMessageEvent, {9}, nil, true)
	self:skinEditBox(QuestGuru_AnnounceFrameMessageQuest, {9}, nil, true)

-->>--	Tracker Frame
	if self.db.profile.TrackerFrame then
		self:keepFontStrings(QGT_QuestWatchFrame)
		self:applySkin(QGT_QuestWatchFrame)
		self:RawHook("QGT_SetWatchBorder", function() end, true)
		self:RawHook(QGT_QuestWatchFrame, "SetBackdropColor", function() end, true)
	end

-->>--	QuestStartInfo Frame
	self:keepFontStrings(QuestGuru_QuestStartInfoFrame)
	self:applySkin(QuestGuru_QuestStartInfoFrame)
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

	-- hook this to change the Quest text colours
	self:SecureHook("QuestGuru_ColorizeText", function(inText)
		for _, v1 in pairs({ "Log", "History", "Abandon" }) do
			for i = 1, 10 do
				local text = _G["QuestGuru_Quest"..v1.."Objective"..i]
				if text then
					local r, g, b, a = text:GetTextColor()
					text:SetTextColor(self.BTr - r, self.BTg - g, self.BTb)
				end
		   	end
			for _, v2 in pairs({ "Start", "Finish" }) do
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

-->>--	Tooltip
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then QGT_QuestWatchTooltip:SetBackdrop(self.backdrop) end
		self:SecureHook(QGT_QuestWatchTooltip, "Show", function(this)
			self:skinTooltip(QGT_QuestWatchTooltip)
		end)
	end

	-- hook this for LightHeaded support
	if IsAddOnLoaded("LightHeaded") then
		self:SecureHookScript(QuestGuru_QuestLogFrame, "OnUpdate", function(this, elapsed)
			if not LightHeaded.db.profile.open and LightHeaded.db.profile.lhopen and (not LightHeadedFrameSub.justclosed or LightHeadedFrameSub.justclosed == nil) then
				self:moveObject(LightHeadedFrame, "+", 6, "-", 19)
			end
		end)
	end

end
