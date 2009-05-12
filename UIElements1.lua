local _G = _G
local ftype = "u"

function Skinner:Tooltips()
	if not self.db.profile.Tooltips.skin or self.initialized.Tooltips then return end
	self.initialized.Tooltips = true

	-- 	change the default Tooltip Border colour here
	TOOLTIP_DEFAULT_COLOR = self.db.profile.TooltipBorder

	-- fix for TinyTip tooltip becoming 'fractured'
	if self.db.profile.Tooltips.style == 3 then
		TOOLTIP_DEFAULT_BACKGROUND_COLOR = self.db.profile.Backdrop
		self:setTTBackdrop(true)
	end

	local counts = 0
	local GTSBevt
	local function checkGTHeight(cHeight)

		counts = counts + 1

		if cHeight ~= math.ceil(GameTooltip:GetHeight()) then
			Skinner:skinTooltip(GameTooltip)
			Skinner:CancelTimer(GTSBevt, true)
			GTSBevt = nil
			counts = 0
		end

		if counts == 10 or GameTooltipStatusBar:IsShown() then
			Skinner:CancelTimer(GTSBevt, true)
			GTSBevt = nil
			counts = 0
		end

	end

	-- Hook this to deal with GameTooltip FadeHeight issues
	self:SecureHookScript(GameTooltipStatusBar, "OnHide", function(this)
		if GameTooltip:IsShown() then
			cHeight = math.ceil(GameTooltip:GetHeight())
			if not GTSBevt then
				GTSBevt = self:ScheduleRepeatingTimer(checkGTHeight, 0.2, cHeight)
			end
		end
		end)

	-- MUST hook to OnShow script rather than the Show method otherwise not every tooltip is skinned properly everytime
	for _, tooltip in pairs(self.ttList) do
		local ttip = _G[tooltip]
		self:SecureHookScript(ttip, "OnShow", function(this)
			self:skinTooltip(this)
			if this == GameTooltip and self.db.profile.Tooltips.glazesb then
				self:glazeStatusBar(GameTooltipStatusBar, 0)
			end
			end)
	end

end

function Skinner:MirrorTimers()
	if not self.db.profile.MirrorTimers.skin or self.initialized.MirrorTimers then return end
	self.initialized.MirrorTimers = true

	for i = 1, MIRRORTIMER_NUMTIMERS do
		local mTimer = _G["MirrorTimer"..i]
		local mTimerText = _G["MirrorTimer"..i.."Text"]
		local mTimerSB = _G["MirrorTimer"..i.."StatusBar"]
		self:keepFontStrings(mTimer)
		mTimer:SetHeight(mTimer:GetHeight() * 1.2)
		mTimerSB:SetWidth(mTimerSB:GetWidth() * 0.7)
		self:moveObject{obj=mTimerText, y=-2}
		if self.db.profile.MirrorTimers.glaze then self:glazeStatusBar(mTimerSB, 0) end
	end

end

function Skinner:CastingBar()
	if not self.db.profile.CastingBar.skin or self.initialized.CastingBar then return end
	self.initialized.CastingBar = true

	for _, prefix in pairs{"", "Pet"} do
		local cbfName = prefix.."CastingBarFrame"
		if cbfName == "CastingBarFrame" then
			self:SecureHook("CastingBarFrame_OnUpdate", function()
				self:moveObject{obj=CastingBarFrameSpark, y=-3}
			end)
		end

		local cbfObj = _G[cbfName]
		local cbfs = _G[cbfName.."Spark"]
		local cbff = _G[cbfName.."Flash"]
		local cbft = _G[cbfName.."Text"]

		self:keepFontStrings(cbfObj)
		-- adjust size/placement of the casting frame and associated textures
		cbfObj:SetWidth(cbfObj:GetWidth() * 0.7)
		cbfObj:SetHeight(cbfObj:GetHeight() * 1.2)
		cbfs:SetHeight(cbfs:GetHeight() * 1.5)
		cbff:SetWidth(cbfObj:GetWidth())
		cbff:SetHeight(cbfObj:GetHeight())
		cbff:SetTexture(self.sbTexture)
		self:moveObject{obj=cbff, y=-28}
		self:moveObject{obj=cbft, y=-3}

		if self.db.profile.CastingBar.glaze then self:glazeStatusBar(cbfObj, 0) end

	end

end

function Skinner:StaticPopups()
	if not self.db.profile.StaticPopups or self.initialized.StaticPopups then return end
	self.initialized.StaticPopups = true

	for i = 1, STATICPOPUP_NUMDIALOGS do
		self:skinEditBox{obj=_G["StaticPopup"..i.."EditBox"]}
		self:skinEditBox{obj=_G["StaticPopup"..i.."WideEditBox"]}
		self:skinMoneyFrame{obj=_G["StaticPopup"..i.."MoneyInputFrame"]}
		self:addSkinFrame{obj=_G["StaticPopup"..i], ft=ftype, x1=10, y1=3, x2=-10, y2=3}
	end

end

function Skinner:ChatMenus()
	if not self.db.profile.ChatMenus or self.initialized.ChatMenus then return end
	self.initialized.ChatMenus = true

	self:addSkinFrame{obj=ChatMenu, ft=ftype}
	self:addSkinFrame{obj=EmoteMenu, ft=ftype}
	self:addSkinFrame{obj=LanguageMenu, ft=ftype}
	self:addSkinFrame{obj=VoiceMacroMenu, ft=ftype}

end

function Skinner:ChatTabs()
	if not self.db.profile.ChatTabs or self.initialized.ChatTabs then return end
	self.initialized.ChatTabs = true

	if self.isTT then
		-- hook this to change the texture for the Active and Inactive tabs
		self:SecureHook("FCF_Tab_OnClick",function(this, ...)
			for i = 1, 7 do
				local tabSF = self.skinFrame[_G["ChatFrame"..i.."Tab"]]
				if i == this:GetID() then
					self:setActiveTab(tabSF)
				else
					self:setInactiveTab(tabSF)
				end
			end
		end)
	end

	for i = 1, NUM_CHAT_WINDOWS do
		local tabName = _G["ChatFrame"..i.."Tab"]
		self:keepRegions(tabName, {4, 5}) --N.B. region 4 is text, 5 is highlight
		self:addSkinFrame{obj=tabName, ft=ftype, noBdr=self.isTT, y1=-8, y2=-5}
		local tabSF = self.skinFrame[tabName]
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end

end

function Skinner:ChatFrames()
	if not self.db.profile.ChatFrames or self.initialized.ChatFrames then return end
	self.initialized.ChatFrames = true

	self:SecureHook("FCF_StopResize", function()
		local frame = _G["Skinner"..this:GetParent():GetName()]
		if frame and frame.tfade then frame.tfade:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", -4, -math.ceil(frame:GetHeight())) end
	end)

	local clqbf_c = CombatLogQuickButtonFrame_Custom
	local xOfs1, yOfs1, xOfs2, yOfs2 = -4, nil, 4, -8
	for i = 1, NUM_CHAT_WINDOWS do
		local cf = _G["ChatFrame"..i]
		if SIMPLE_CHAT ~= "1" and CHAT_LOCKED ~= "1" and cf:GetName() == "ChatFrame2" and clqbf_c:IsShown() then
			yOfs1 = 31
		else
			yOfs1 = 4
		end
		self:addSkinFrame{obj=cf, ft=ftype, x1=xOfs1, y1=yOfs1, x2=xOfs2, y2=yOfs2}
	end

	-- CombatLog Quick Button Frame & Progress Bar
	if SIMPLE_CHAT ~= "1" and CHAT_LOCKED ~= "1" and self.db.profile.CombatLogQBF then
		if clqbf_c then
			self:keepFontStrings(clqbf_c)
			self:addSkinFrame{obj=clqbf_c, ft=ftype}
			clqbf_c:SetHeight(clqbf_c:GetHeight() + 4)
			self:glazeStatusBar(CombatLogQuickButtonFrame_CustomProgressBar, 0)
		else
			self:glazeStatusBar(CombatLogQuickButtonFrameProgressBar, 0)
		end
	end

end

function Skinner:ChatConfig()
	if not self.db.profile.ChatConfig or self.initialized.ChatConfig then return end
	self.initialized.ChatConfig = true

	self:addSkinFrame{obj=ChatConfigFrame, ft=ftype, kfs=true, hdr=true}
	self:addSkinFrame{obj=ChatConfigCategoryFrame, ft=ftype}
	self:addSkinFrame{obj=ChatConfigBackgroundFrame, ft=ftype}

-->>--	Chat Settings
	for i = 1, #CHAT_CONFIG_CHAT_LEFT do
		_G["ChatConfigChatSettingsLeftCheckBox"..i]:SetBackdrop(nil)
	end
	self:addSkinFrame{obj=ChatConfigChatSettingsLeft, ft=ftype}

	for i = 1, #CHAT_CONFIG_CHAT_RIGHT do
		_G["ChatConfigChatSettingsRightCheckBox"..i]:SetBackdrop(nil)
	end
	self:addSkinFrame{obj=ChatConfigChatSettingsRight, ft=ftype}

	for i = 1, #CHAT_CONFIG_CHAT_CREATURE_LEFT do
		_G["ChatConfigChatSettingsCreatureLeftCheckBox"..i]:SetBackdrop(nil)
	end
	self:addSkinFrame{obj=ChatConfigChatSettingsCreatureLeft, ft=ftype}

-->>--	Channel Settings
	self:SecureHook(ChatConfigChannelSettings, "Show", function(this)
		for i = 1, #ChatConfigChannelSettingsLeft.checkBoxTable do
			local cccslcb = _G["ChatConfigChannelSettingsLeftCheckBox"..i]
			if not self.skinFrame[cccslcb] then
				self:addSkinFrame{obj=cccslcb, ft=ftype}
			end
		end
	end)
	self:addSkinFrame{obj=ChatConfigChannelSettingsLeft, ft=ftype}

-->>--	Other Settings
	for i = 1, #CHAT_CONFIG_OTHER_COMBAT do
		_G["ChatConfigOtherSettingsCombatCheckBox"..i]:SetBackdrop(nil)
	end
	self:addSkinFrame{obj=ChatConfigOtherSettingsCombat, ft=ftype}

	for i = 1, #CHAT_CONFIG_OTHER_PVP do
		_G["ChatConfigOtherSettingsPVPCheckBox"..i]:SetBackdrop(nil)
	end
	self:addSkinFrame{obj=ChatConfigOtherSettingsPVP, ft=ftype}

	for i = 1, #CHAT_CONFIG_OTHER_SYSTEM do
		_G["ChatConfigOtherSettingsSystemCheckBox"..i]:SetBackdrop(nil)
	end
	self:addSkinFrame{obj=ChatConfigOtherSettingsSystem, ft=ftype}

-->>--	Combat Settings
	-- Filters
	ChatConfigCombatSettingsFiltersScrollFrameScrollBarBorder:Hide()
	self:skinScrollBar{obj=ChatConfigCombatSettingsFiltersScrollFrame} --, noRR=true}
	self:addSkinFrame{obj=ChatConfigCombatSettingsFilters, ft=ftype}

	-- Message Sources
	if COMBAT_CONFIG_MESSAGESOURCES_BY then
		for i = 1, #COMBAT_CONFIG_MESSAGESOURCES_BY do
			_G["CombatConfigMessageSourcesDoneByCheckBox"..i]:SetBackdrop(nil)
		end
		self:addSkinFrame{obj=CombatConfigMessageSourcesDoneBy, ft=ftype}
	end
	if COMBAT_CONFIG_MESSAGESOURCES_TO then
		for i = 1, #COMBAT_CONFIG_MESSAGESOURCES_TO do
			_G["CombatConfigMessageSourcesDoneToCheckBox"..i]:SetBackdrop(nil)
		end
		self:addSkinFrame{obj=CombatConfigMessageSourcesDoneTo, ft=ftype}
	end

	-- Colors
	for i = 1, #COMBAT_CONFIG_UNIT_COLORS do
		_G["CombatConfigColorsUnitColorsSwatch"..i]:SetBackdrop(nil)
	end
	self:addSkinFrame{obj=CombatConfigColorsUnitColors, ft=ftype}

	local clrize, ccccObj
	for i, v in ipairs{"Highlighting", "UnitName", "SpellNames", "DamageNumber", "DamageSchool", "EntireLine"} do
		clrize = i > 1 and "Colorize" or ""
		ccccObj = _G["CombatConfigColors"..clrize..v]
		self:addSkinFrame{obj=ccccObj, ft=ftype}
	end

	-- Settings
	self:skinEditBox{obj=CombatConfigSettingsNameEditBox , regs={9}}

	-- Tabs
	for i = 1, #COMBAT_CONFIG_TABS do
		local tabName = _G["CombatConfigTab"..i]
		self:keepRegions(tabName, {4, 5}) -- N.B. region 4 is the Text, 5 is the highlight
		self:addSkinFrame{obj=tabName, ft=ftype, y1=-8, y2=-4}
	end

end

function Skinner:ChatEditBox()
	-- don't use an initialized value to allow for dynamic changes
	if not self.db.profile.ChatEditBox.skin then return end

	-- these addons replace the Chat Edit Box
	if IsAddOnLoaded("NeonChat") or IsAddOnLoaded("Chatter") then return end

	if self.db.profile.ChatEditBox.style == 1 then
		local kRegions = CopyTable(self.ebRegions)
		table.insert(kRegions, 9)
		self:keepRegions(ChatFrameEditBox, kRegions)
		self:addSkinFrame{obj=ChatFrameEditBox, ft=ftype, x1=2, y1=-2, x2=-2}
	else
		self:skinEditBox{obj=ChatFrameEditBox, regs={9}, noHeight=true}
	end

end

function Skinner:LootFrame()
	if not self.db.profile.LootFrame or self.initialized.LootFrame then return end
	self.initialized.LootFrame = true

	self:moveObject{obj=self:getRegion(LootFrame, 3), x=-12} -- title
	self:addSkinFrame{obj=LootFrame, ft=ftype, kfs=true, x1=8, y1=-13, x2=-68}

end

function Skinner:GroupLoot()
	if not self.db.profile.GroupLoot.skin or self.initialized.GroupLoot then return end
	self.initialized.GroupLoot = true

	local f = GameFontNormalSmall:GetFont()
	local xMult, yMult = 0.75, 0.75

	self:skinDropDown{obj=GroupLootDropDown}

	for i = 1, NUM_GROUP_LOOT_FRAMES do

		local glf = "GroupLootFrame"..i
		local glfo = _G[glf]
		self:keepFontStrings(glfo)
		self:removeRegions(_G[glf.."Timer"], {1})
		self:glazeStatusBar(_G[glf.."Timer"], 0)
		-- hook this to skin the group loot frame
		self:SecureHook(glfo, "Show", function(this)
			this:SetBackdrop(nil)
		end)

		if self.db.profile.GroupLoot.size == 1 then

			self:addSkinFrame{obj=glfo, ft=ftype, x1=4, y1=-5, x2=-4, y2=5}

		elseif self.db.profile.GroupLoot.size == 2 then

			glfo:SetScale(0.75)
			self:addSkinFrame{obj=glfo, ft=ftype, x1=4, y1=-5, x2=-4, y2=5}

		elseif self.db.profile.GroupLoot.size == 3 then

			glfo:SetScale(0.75)
			self:moveObject{obj=_G[glf.."SlotTexture"], x=95, y=4} -- Loot item icon
			_G[glf.."NameFrame"]:Hide()
			_G[glf.."Name"]:Hide()
			_G[glf.."RollButton"]:ClearAllPoints()
			_G[glf.."RollButton"]:SetPoint("RIGHT", _G[glf.."PassButton"], "LEFT", 5, -5)
			_G[glf.."GreedButton"]:ClearAllPoints()
			_G[glf.."GreedButton"]:SetPoint("RIGHT", _G[glf.."RollButton"], "LEFT", 0, 0)
			_G[glf.."Timer"]:SetWidth(_G[glf.."Timer"]:GetWidth() - 28)
			self:moveObject{obj=_G[glf.."Timer"], x=-3}
			self:addSkinFrame{obj=glfo, ft=ftype, x1=102, y1=-5, x2=-4, y2=16}

		end

	end

end

function Skinner:ContainerFrames()
	if not self.db.profile.ContainerFrames.skin or self.initialized.ContainerFrames then return end
	self.initialized.ContainerFrames = true

	for i = 1, NUM_CONTAINER_FRAMES do
		local frameObj = _G["ContainerFrame"..i]
		self:addSkinFrame{obj=frameObj, ft=ftype, kfs=true, x1=8, y1=-4, x2=-3}
		-- resize and move the bag name to make it more readable
		local frameName = _G["ContainerFrame"..i.."Name"]
		frameName:SetWidth(145)
		self:moveObject{obj=frameName, x=-30}
	end

end

function Skinner:StackSplit()
	if not self.db.profile.StackSplit or self.initialized.StackSplit then return end
	self.initialized.StackSplit = true

	self:addSkinFrame{obj=StackSplitFrame, ft=ftype, kfs=true, x1=9, y1=-12, x2=-6, y2=12}

end

function Skinner:ItemText()
	if not self.db.profile.ItemText or self.initialized.ItemText then return end
	self.initialized.ItemText = true

	self:SecureHookScript(ItemTextFrame, "OnShow", function(this)
		ItemTextPageText:SetTextColor(self.BTr, self.BTg, self.BTb)
	end)

	self:skinScrollBar{obj=ItemTextScrollFrame}
	self:glazeStatusBar(ItemTextStatusBar, 0)
	self:moveObject{obj=ItemTextPrevPageButton, x=-55} -- move prev button left
	self:addSkinFrame{obj=ItemTextFrame, ft=ftype, kfs=true, x1=10, y1=-12, x2=-32, y2=71}

end

function Skinner:ColorPicker()
	if not self.db.profile.Colours or self.initialized.Colours then return end
	self.initialized.Colours = true

	ColorPickerFrame:SetBackdrop(nil)
	ColorPickerFrameHeader:SetAlpha(0)
	self:skinSlider(OpacitySliderFrame, 4)
	self:addSkinFrame{obj=ColorPickerFrame, ft=ftype, x1=6, y1=6, x2=-6, y2=4}

-->>-- Opacity Frame, used by BattlefieldMinimap amongst others
	OpacityFrame:SetBackdrop(nil)
	self:skinSlider(OpacityFrameSlider)
	self:addSkinFrame{obj=OpacityFrame, ft=ftype}

end

function Skinner:WorldMap()
	if not self.db.profile.WorldMap.skin or self.initialized.WorldMap then return end
	self.initialized.WorldMap = true

	self:skinDropDown{obj=WorldMapContinentDropDown}
	self:skinDropDown{obj=WorldMapZoneDropDown}
	self:skinDropDown{obj=WorldMapZoneMinimapDropDown}
	self:skinDropDown{obj=WorldMapLevelDropDown}

	-- handle different map addons being loaded or fullscreen required
	if self.db.profile.WorldMap.size == 2 or IsAddOnLoaded("Mapster") or IsAddOnLoaded("Cartographer") then
		self:addSkinFrame{obj=WorldMapFrame, ftype=ftype, kfs=true, y1=1}
	elseif not IsAddOnLoaded("MetaMap")then
		self:addSkinFrame{obj=WorldMapFrame, ft=ftype, kfs=true, x1=99, x2=-101, y2=18}
	end

-->>-- Tooltip
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then WorldMapTooltip:SetBackdrop(self.Backdrop[1]) end
		self:SecureHook(WorldMapTooltip, "Show", function()
			self:skinTooltip(WorldMapTooltip)
		end)
	end

end

function Skinner:HelpFrame()
	if not self.db.profile.HelpFrame or self.initialized.HelpFrame then return end
	self.initialized.HelpFrame = true

	local hfTitle = self:getRegion(HelpFrame, 8)
	local kbTitle = self:getRegion(KnowledgeBaseFrame, 2)
	-- hook these to manage frame titles
	self:SecureHook("HelpFrame_ShowFrame", function(key)
		hfTitle:SetAlpha(0)
		kbTitle:SetAlpha(0)
		if key == "KBase" then
			kbTitle:SetAlpha(1)
		else
			hfTitle:SetAlpha(1)
		end
	end)
	self:SecureHook("HelpFrame_PopFrame", function()
		if HelpFrame.openFrame and HelpFrame.openFrame:GetName() == "KnowledgeBaseFrame" then
			hfTitle:SetAlpha(0)
			kbTitle:SetAlpha(1)
		end
	end)

-->>--	Help Frame
	self:moveObject{obj=hfTitle, y=-8}
	self:addSkinFrame{obj=HelpFrame, ft=ftype, kfs=true, x1=6, y1=-6, x2=-45, y2=14}

-->>--	Open Ticket Frame
	HelpFrameOpenTicketDivider:Hide()
	self:skinScrollBar{obj=HelpFrameOpenTicketScrollFrame}

-->>--	Ticket Status Frame
	local tsfC = self:getChild(TicketStatusFrame, 2) -- skin this unnamed child
	self:addSkinFrame{obj=tsfC, ft=ftype}

-->>--	KnowledgeBase Frame
	self:keepFontStrings(KnowledgeBaseFrame)
	self:moveObject{obj=kbTitle, y=-8}
	self:skinEditBox{obj=KnowledgeBaseFrameEditBox}
	self:skinDropDown{obj=KnowledgeBaseFrameCategoryDropDown}
	self:skinDropDown{obj=KnowledgeBaseFrameSubCategoryDropDown}
	KnowledgeBaseFrameDivider:Hide()
	KnowledgeBaseFrameDivider2:Hide()
	self:skinScrollBar{obj=KnowledgeBaseArticleScrollFrame}

end

function Skinner:Tutorial()
	if not self.db.profile.Tutorial then return end

	self:addSkinFrame{obj=TutorialFrame, ft=ftype}

	-- skin the alert buttons
	for i = 1, 10 do
		local tfabObj = _G["TutorialFrameAlertButton"..i]
		self:addSkinButton{obj=tfabObj, parent=tfabObj, x1=-2, y1=2, x2=1, y2=1}
	end

end

function Skinner:GMSurveyUI()
	if not self.db.profile.GMSurveyUI or self.initialized.GMSurveyUI then return end
	self.initialized.GMSurveyUI = true

	self:keepFontStrings(GMSurveyHeader)
	self:moveObject{obj=GMSurveyHeaderText, y=-8}
	self:addSkinFrame{obj=GMSurveyFrame, ft=ftype, kfs=true, y1=-6, x2=-45}

	self:skinScrollBar{obj=GMSurveyScrollFrame}

	-- FIXME: this isn't working, questions are hidden behind the skin
	for i = 1, MAX_SURVEY_QUESTIONS do
		self:addSkinFrame{obj=_G["GMSurveyQuestion"..i], ft=ftype, y1=-2}
	end

	self:skinScrollBar{obj=GMSurveyCommentScrollFrame}
	self:addSkinFrame{obj=GMSurveyCommentFrame, ft=ftype}

end

-- PTR only
function Skinner:FeedbackUI()
	if not self.db.profile.Feedback or self.initialized.Feedback then return end
	self.initialized.Feedback = true

	local bbR, bbG, bbB, bbA = unpack(self.bbColour)

	self:keepFontStrings(FeedbackUITitleFrm)
	self:moveObject{obj=FeedbackUIBtnClose, x=4, y=4}
	FeedbackUIWelcomeFrame:SetBackdrop(nil)
	self:keepFontStrings(FeedbackUI_ModifierKeyDropDown)
	self:addSkinFrame{obj=FeedbackUI_ModifierKeyDropDownList, ft=ftype}
	self:keepFontStrings(FeedbackUI_MouseButtonDropDown)
	self:addSkinFrame{obj=FeedbackUI_MouseButtonDropDownList, ft=ftype}
	self:addSkinFrame{obj=FeedbackUI, ft=ftype, kfs=true}

-->-- Survey Frame
	FeedbackUISurveyFrame:SetBackdrop(nil)
	self:keepFontStrings(FeedbackUISurveyFrameSurveysPanelDdlCategory)
	self:addSkinFrame{obj=FeedbackUISurveyFrameSurveysPanelDdlCategoryList, ft=ftype}
	self:keepFontStrings(FeedbackUISurveyFrameSurveysPanelDdlStatus)
	self:addSkinFrame{obj=FeedbackUISurveyFrameSurveysPanelDdlStatusList, ft=ftype}
	self:skinScrollBar{obj=FeedbackUISurveyFrameSurveysPanelScrollScrollControls, size=3}
	FeedbackUISurveyFrameSurveysPanelBorder:SetBackdropBorderColor(bbR, bbG, bbB, bbA)
	FeedbackUISurveyFrameStatusPanelBorder:SetBackdropBorderColor(bbR, bbG, bbB, bbA)
	FeedbackUISurveyFrameStatusPanelLine:SetAlpha(0)
	FeedbackUISurveyFrameStepThroughPanelBorder:SetBackdropBorderColor(bbR, bbG, bbB, bbA)
	self:addSkinFrame{obj=FeedbackUISurveyFrameStepThroughPanelHeader, ft=ftype}
	self:addSkinFrame{obj=FeedbackUISurveyFrameStepThroughPanelEdit, ft=ftype}
	self:skinScrollBar{obj=FeedbackUISurveyFrameStepThroughPanelEditInput}
	self:skinScrollBar{obj=FeedbackUISurveyFrameStepThroughPanelScrollScrollControls, size=3}

-->>-- Suggestion Frame
	FeedbackUISuggestFrame:SetBackdrop(nil)
	FeedbackUISuggestFrameInfoPanelBorder:SetBackdropBorderColor(bbR, bbG, bbB, bbA)
	FeedbackUISuggestFrameStatusPanelBorder:SetBackdropBorderColor(bbR, bbG, bbB, bbA)
	FeedbackUISuggestFrameStatusPanelLine:SetAlpha(0)
	FeedbackUISuggestFrameStepThroughPanelBorder:SetBackdropBorderColor(bbR, bbG, bbB, bbA)
	self:addSkinFrame{obj=FeedbackUISuggestFrameStepThroughPanelHeader, ft=ftype}
	self:addSkinFrame{obj=FeedbackUISuggestFrameStepThroughPanelEdit, ft=ftype}
	self:skinScrollBar{obj=FeedbackUISuggestFrameStepThroughPanelEditInput}
	self:skinScrollBar{obj=FeedbackUISuggestFrameStepThroughPanelScrollScrollControls, size=3}

-->>-- Bug Frame
	FeedbackUIBugFrame:SetBackdrop(nil)
	FeedbackUIBugFrameInfoPanelBorder:SetBackdropBorderColor(bbR, bbG, bbB, bbA)
	FeedbackUIBugFrameStatusPanelBorder:SetBackdropBorderColor(bbR, bbG, bbB, bbA)
	FeedbackUIBugFrameStatusPanelLine:SetAlpha(0)
	FeedbackUIBugFrameStepThroughPanelBorder:SetBackdropBorderColor(bbR, bbG, bbB, bbA)
	self:addSkinFrame{obj=FeedbackUIBugFrameStepThroughPanelHeader, ft=ftype}
	self:addSkinFrame{obj=FeedbackUIBugFrameStepThroughPanelEdit, ft=ftype}
	self:skinScrollBar{obj=FeedbackUIBugFrameStepThroughPanelEditInput}
	self:skinScrollBar{obj=FeedbackUIBugFrameStepThroughPanelScrollScrollControls, size=3}

	-- make the QuestLog Tip Label text visible
	FeedbackUIQuestLogTipLabel:SetTextColor(self.BTr, self.BTg, self.BTb)

end

function Skinner:InspectUI()
	if not self.db.profile.InspectUI or self.initialized.InspectUI then return end
	self.initialized.InspectUI = true

	if self.isTT then
		-- hook this to change the texture for the Active and Inactive tabs
		self:SecureHook("InspectSwitchTabs",function(newID)
			for i = 1, InspectFrame.numTabs do
				local tabSF = self.skinFrame[_G["InspectFrameTab"..i]]
				if i == newID then
					self:setActiveTab(tabSF)
				else
					self:setInactiveTab(tabSF)
				end
			end
		end)
	end

	self:addSkinFrame{obj=InspectFrame, ft=ftype, kfs=true, x1=10, y1=-12, x2=-32, y2=69}

	-- Inspect Model Frame
	self:keepRegions(InspectPaperDollFrame, {5, 6, 7}) -- N.B. regions 5-7 are text
	InspectModelRotateLeftButton:Hide()
	InspectModelRotateRightButton:Hide()
	self:makeMFRotatable(InspectModelFrame)

-->>--	PVP Frame
	self:keepFontStrings(InspectPVPFrame)

-->>--	Talent Frame
	self:keepRegions(InspectTalentFrame, {6, 7, 8, 9, 10}) -- N.B. 6, 7, 8 & 9 are the background picture, 10 is text
	InspectTalentFrameCloseButton:Hide()
	self:skinScrollBar{obj=InspectTalentFrameScrollFrame}
	self:keepFontStrings(InspectTalentFramePointsBar)
	self:skinFFToggleTabs("InspectTalentFrameTab")

-->>--	Frame Tabs
	for i = 1, InspectFrame.numTabs do
		local tabName = _G["InspectFrameTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		self:addSkinFrame{obj=tabName, ft=ftype, noBdr=self.isTT, x1=6, x2=-6, y2=2}
		local tabSF = self.skinFrame[tabName]
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end

end

function Skinner:BattleScore()
	if not self.db.profile.BattleScore or self.initialized.BattleScore then return end
	self.initialized.BattleScore = true

	if self.isTT then
		-- hook this to change the texture for the Active and Inactive tabs
		self:SecureHook("WorldStateScoreFrameTab_OnClick",function(tab)
			for i = 1, 3 do
				local tabObj = _G["WorldStateScoreFrameTab"..i]
				local tabSF = self.skinFrame[tabObj]
				if tabObj == tab then
					self:setActiveTab(tabSF)
				else
					self:setInactiveTab(tabSF)
				end
			end
		end)
	end

	self:skinScrollBar{obj=WorldStateScoreScrollFrame}
	self:addSkinFrame{obj=WorldStateScoreFrame, ft=ftype, kfs=true, x1=10, y1=-15, x2=-113, y2=70}

-->>-- Tabs
	for i = 1, 3 do
		local tabName = _G["WorldStateScoreFrameTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		self:addSkinFrame{obj=tabName, ft=ftype, noBdr=self.isTT, x1=7, y1=8, x2=-7, y2=10}
		local tabSF = self.skinFrame[tabName]
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end

end

function Skinner:BattlefieldMinimap()
	if not self.db.profile.BattlefieldMm then return end

	-- change the skinFrame's opacity as required
	self:SecureHook("BattlefieldMinimap_UpdateOpacity", function(opacity)
		local alpha = 1.0 - BattlefieldMinimapOptions.opacity
		if ( alpha >= 0.15 ) then alpha = alpha - 0.15 end
		self.skinFrame[BattlefieldMinimap]:SetAlpha(alpha)
		self.skinFrame[BattlefieldMinimap].tfade:SetAlpha(alpha)
	end)

-->>--	Minimap Tab
	self:keepRegions(BattlefieldMinimapTab, {4, 5}) -- N.B. region 4 is the Text, 5 is the highlight
	asopts = self.isTT and {ba=1} or nil
	self:addSkinFrame{obj=BattlefieldMinimapTab, ft=ftype, noBdr=self.isTT, aso=asopts, y1=-7, y2=-7}
	self:moveObject{obj=BattlefieldMinimapTabText, y=-1} -- move text down
-->>--	Minimap
	-- change the draw layer so that the map is visible
	for i = 1, NUM_WORLDMAP_DETAIL_TILES do
		_G["BattlefieldMinimap"..i]:SetDrawLayer("ARTWORK")
	end

	-- Create a frame to skin as using the BattlefieldMinimap one causes issues with Capping
	self:addSkinFrame{obj=BattlefieldMinimap, ft=ftype, bg=true, x1=-4, y1=4, x2=-2, y2=-1}
	-- hide the textures as the alpha values are changed in game
	BattlefieldMinimapCorner:Hide()
	BattlefieldMinimapBackground:Hide()

	if IsAddOnLoaded("Capping") then
		if type(self["Capping_ModMap"]) == "function" then self:Capping_ModMap() end
	end

end

function Skinner:ScriptErrors()
	if not self.db.profile.ScriptErrors then return end

	self:addSkinFrame{obj=ScriptErrors, ft=ftype}

end

function Skinner:DropDowns()
	if not self.db.profile.DropDowns or self.initialized.DropDowns then return end
	self.initialized.DropDowns = true

	self:SecureHook("UIDropDownMenu_CreateFrames", function(level, index)
		for i = 1, UIDROPDOWNMENU_MAXLEVELS do
			local ddl = "DropDownList"..i
			local ddlObj = _G[ddl]
			if not self:IsHooked(ddlObj, "Show") then
				self:SecureHook(ddlObj, "Show", function()
					_G[ddl.."Backdrop"]:Hide()
					_G[ddl.."MenuBackdrop"]:Hide()
					if not self.skinFrame[ddlObj] then
						self:addSkinFrame{obj=ddlObj, ft=ftype, kfs=true}
					end
				end)
			end
		end
	end)

end

function Skinner:MinimapButtons()
	if not self.db.profile.MinimapButtons or self.initialized.MinimapButtons then return end
	self.initialized.MinimapButtons = true

	local function mmKids(mmObj)

		local mmObjName = mmObj.GetName and mmObj:GetName() or "<Anon>"

		for i = 1, mmObj:GetNumChildren() do
			local obj = select(i, mmObj:GetChildren())
			local objName = obj:GetName()
			local objType = obj:GetObjectType()
			if not (Skinner.sBut[obj] or Skinner.skinFrame[obj]) and objName
			and (objType == "Button" or objType == "Frame" and objName == "MiniMapMailFrame") then
				for i = 1, obj:GetNumRegions() do
					local reg = select(i, obj:GetRegions())
					if reg:GetObjectType() == "Texture" then
						local regName = reg:GetName()
						local regTex = reg:GetTexture()
						local regDL = reg:GetDrawLayer()
						-- change the DrawLayer to make the Icon show if required
						if (regName and string.find(regName, "[Ii]con"))
						or (regTex and string.find(regTex, "[Ii]con")) then
							if regDL == "BACKGROUND" then reg:SetDrawLayer("ARTWORK") end
							-- centre the icon
							reg:ClearAllPoints()
							reg:SetPoint("CENTER")
						elseif (regName and string.find(regName, "Border"))
						or (regTex and string.find(regTex, "TrackingBorder")) then
							reg:SetTexture(nil)
							obj:SetWidth(32)
							obj:SetHeight(32)
							if objType == "Button" then
								Skinner:addSkinButton{obj=obj, parent=obj, sap=true}
							else
								Skinner:addSkinFrame{obj=obj, ft=ftype}
							end
						end
					end
				end
			elseif objName and objType == "Frame" then
				mmKids(obj)
			end
		end

	end

	-- skin Minimap children
	mmKids(Minimap)

	-- skin other Blizzard buttons
	for _, obj in pairs{GameTimeFrame, MinimapZoomIn, MinimapZoomOut} do
		self:addSkinButton{obj=obj, parent=obj}
		self.sBut[obj]:ClearAllPoints()
		self.sBut[obj]:SetAllPoints(obj)
	end
	-- resize other buttons
	MiniMapMailFrame:SetWidth(28)
	MiniMapMailFrame:SetHeight(28)
	GameTimeFrame:SetWidth(36)
	GameTimeFrame:SetHeight(36)
	MiniMapVoiceChatFrame:SetWidth(32)
	MiniMapVoiceChatFrame:SetHeight(32)
	MiniMapVoiceChatFrameIcon:ClearAllPoints()
	MiniMapVoiceChatFrameIcon:SetPoint("CENTER")

	-- MiniMap Tracking button
	MiniMapTrackingIcon:ClearAllPoints()
	MiniMapTrackingIcon:SetPoint("CENTER", MiniMapTrackingButton)
	MiniMapTrackingIcon:SetParent(MiniMapTrackingButton)
	-- hook this to stop the icon being moved
	self:RawHook(MiniMapTrackingIcon, "SetPoint", function(this, ...) end, true)

	-- move GameTime a.k.a. Calendar texture up a layer
	GameTimeFrame:GetNormalTexture():SetDrawLayer("BORDER")
	GameTimeFrame:GetPushedTexture():SetDrawLayer("BORDER")
	GameTimeFrame:GetFontString():SetDrawLayer("BORDER")

	-- skin any moved Minimap buttons if required
	if IsAddOnLoaded("MinimapButtonFrame") then mmKids(MinimapButtonFrame) end

	-- show the Bongos minimap icon if required
	if IsAddOnLoaded("Bongos") then Bongos3MinimapButton.icon:SetDrawLayer("ARTWORK") end

	-- skin other minimap buttons as required
	local mmButs = {
		["SmartBuff"] = SmartBuff_MiniMapButton,
		["WebDKP"] = WebDKP_MinimapButton,
		["GuildAds"] = GuildAdsMinimapButton,
		["Outfitter"] = OutfitterMinimapButton,
		["Perl_Config"] = PerlButton,
		["WIM"] = WIM3MinimapButton
	}
	for addon, obj in pairs(mmButs) do
		if IsAddOnLoaded(addon) then
			self:addSkinButton{obj=obj, parent=obj, sap=true}
		end
	end
	mmButs = nil

end
