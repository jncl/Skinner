
function Skinner:QuestGuru()
	if not self.db.profile.QuestLog.skin then return end

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

-->>--	Tracker Frame
	if self.db.profile.TrackerFrame then
		self:addSkinFrame{obj=QGT_QuestWatchFrame, kfs=true}
		self:RawHook("QGT_SetWatchBorder", function() end, true)
		self:RawHook(QGT_QuestWatchFrame, "SetBackdropColor", function() end, true)
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
