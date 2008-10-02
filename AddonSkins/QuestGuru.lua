
function Skinner:QuestGuru()
	if not self.db.profile.QuestLog.skin then return end

	local headingText = {"QuestTitle", "DescriptionTitle", "RewardTitleText"}
	local bodyText = {"ObjectivesText", "TimerText", "RequiredMoneyText", "SuggestedGroupNum", "QuestDescription", "ItemChooseText", "ItemReceiveText", "SpellLearnText", "PlayerTitleText", "StartLabel", "FinishLabel"}

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

	QuestGuru_QuestLogFrame:SetWidth(QuestGuru_QuestLogFrame:GetWidth() - 46)
	self:keepFontStrings(QuestGuru_QuestLogFrame)
	self:applySkin(QuestGuru_QuestLogFrame)
	self:keepFontStrings(QuestGuru_QuestLogCount)
	self:skinFFToggleTabs("QuestGuru_QuestLogFrameTab", 5)
	self:moveObject(QuestGuru_QuestLogFrameTab1, nil, nil, "-", 10)
	self:moveObject(QuestGuru_QuestLogFrameCloseButton, "+", 42, "+", 3)
	self:moveObject(QuestGuru_QuestFrameExitButton, "+", 34, "-", 12)
	self:moveObject(QuestGuru_QuestLogFrameAbandonButton, nil, nil, "-", 12)
	-- Quest Log Frame
	self:removeRegions(QuestGuru_QuestLogListScrollFrame)
	self:skinScrollBar(QuestGuru_QuestLogListScrollFrame)
	self:removeRegions(QuestGuru_QuestLogDetailScrollFrame)
	self:skinScrollBar(QuestGuru_QuestLogDetailScrollFrame)
	colourText("Log")
	-- History Frame
	self:skinEditBox(QuestGuru_QuestHistorySearch, {9})
	self:removeRegions(QuestGuru_QuestHistoryListScrollFrame)
	self:skinScrollBar(QuestGuru_QuestHistoryListScrollFrame)
	self:removeRegions(QuestGuru_QuestHistoryDetailScrollFrame)
	self:skinScrollBar(QuestGuru_QuestHistoryDetailScrollFrame)
	colourText("History")
	QuestGuru_QuestHistoryXPText:SetTextColor(self.BTr, self.BTg, self.BTb)
	QuestGuru_QuestHistoryRepText:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:moveObject(QuestGuru_QuestHistorySearchText, nil, nil, "-", 10)
	-- Abandoned Frame
	self:skinEditBox(QuestGuru_QuestAbandonSearch, {9})
	self:removeRegions(QuestGuru_QuestAbandonListScrollFrame)
	self:skinScrollBar(QuestGuru_QuestAbandonListScrollFrame)
	self:removeRegions(QuestGuru_QuestAbandonDetailScrollFrame)
	self:skinScrollBar(QuestGuru_QuestAbandonDetailScrollFrame)
	colourText("Abandon")
	self:moveObject(QuestGuru_QuestAbandonSearchText, nil, nil, "-", 10)
	-- Guild Frame (not used)
	-- Party Frame (not used)

-->>--	Options Frame
	self:skinEditBox(QuestGuru_AnnounceFrameChannelWhisperTo, {9}, nil, true)
	self:skinEditBox(QuestGuru_AnnounceFrameMessageItem, {9}, nil, true)
	self:skinEditBox(QuestGuru_AnnounceFrameMessageMonster, {9}, nil, true)
	self:skinEditBox(QuestGuru_AnnounceFrameMessageEvent, {9}, nil, true)
	self:skinEditBox(QuestGuru_AnnounceFrameMessageQuest, {9}, nil, true)

-->>--	Tracker Frame
	if self.db.profile.TrackerFrame then
		self:keepFontStrings(QuestGuru_QuestWatchFrame)
		self:applySkin(QuestGuru_QuestWatchFrame)
		self:Hook("QuestGuru_SetWatchBorder", function() end, true)
		self:Hook(QuestGuru_QuestWatchFrame, "SetBackdropColor", function() end, true)
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
				local r, g, b, a = _G["QuestGuru_Quest"..v1.."Objective"..i]:GetTextColor()
				_G["QuestGuru_Quest"..v1.."Objective"..i]:SetTextColor(self.BTr - r, self.BTg - g, self.BTb)
		   	end
			for _, v2 in pairs({ "Start", "Finish" }) do
				local text = _G["QuestGuru_Quest"..v1..v2.."Pos"]
				text:SetTextColor(self.BTr, self.BTg, self.BTb)
				if not QuestGuru_Settings.Colorize.NPCNames.Enabled or (v1 == "Abandon" and v2 == "Finish") then
					local text = _G["QuestGuru_Quest"..v1..v2.."NPCName"]
					text:SetTextColor(self.BTr, self.BTg, self.BTb)
				end
			end
		end
	end)

-->>--	Tooltip
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then QuestGuru_QuestWatchTooltip:SetBackdrop(self.backdrop) end
		self:SecureHook(QuestGuru_QuestWatchTooltip, "Show", function(this)
			self:skinTooltip(QuestGuru_QuestWatchTooltip)
			end)
	end

	-- hook this for LightHeaded support
	if IsAddOnLoaded("LightHeaded") then
		self:SecureHook("QuestLog_OnUpdate", function(elapsed)
		if not LightHeaded.db.profile.open and LightHeaded.db.profile.lhopen and (not LightHeadedFrameSub.justclosed or LightHeadedFrameSub.justclosed == nil) then
				self:moveObject(LightHeadedFrame, "+", 6, "-", 19)
			end
		end)
	end

end
