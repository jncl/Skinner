local aName, aObj = ...
local _G = _G
local ftype = "u"
local obj, objName, tex, texName, btn, btnName, tab, tabSF, asopts

do
	-- list of Tooltips to check to see whether we should colour the Tooltip Border or not
	-- use strings as the objects may not exist when we start
	aObj.ttCheck = {"GameTooltip", "ShoppingTooltip1", "ShoppingTooltip2", "ShoppingTooltip3", "ItemRefTooltip", "ItemRefShoppingTooltip1", "ItemRefShoppingTooltip2", "ItemRefShoppingTooltip3"}
	-- list of Tooltips used when the Tooltip style is 3
	-- using a metatable to manage tooltips when they are added in different functions
	aObj.ttList = setmetatable({}, {__newindex = function(t, k, v)
	--	  aObj:Debug("ttList newindex: [%s, %s, %s]", t, k, v)
		rawset(t, k, v)
		-- set the backdrop if required
		if aObj.db.profile.Tooltips.style == 3 then
			_G[v]:SetBackdrop(aObj.Backdrop[1])
		end
		-- hook the OnShow method
		aObj:HookScript(_G[v], "OnShow", function(this)
			aObj:skinTooltip(this)
			if this == GameTooltip and aObj.db.profile.Tooltips.glazesb then
				-- handle in combat
				if InCombatLockdown() then
					aObj:add2Table(aObj.oocTab, {aObj.glazeStatusBar, {aObj, GameTooltipStatusBar, 0}})
					return
				end
				aObj:glazeStatusBar(GameTooltipStatusBar, 0)
			end
		end)
		aObj:skinTooltip(_G[v]) -- skin here so tooltip initially skinnned when logged on
	end})
	-- Set the Tooltip Border
	aObj.ttBorder = true
end

function aObj:AlertFrames()
	if not self.db.profile.AlertFrames or self.initialized.AlertFrames then return end
	self.initialized.AlertFrames = true

	self:add2Table(self.uiKeys1, "AlertFrames")

	local aafName = "AchievementAlertFrame"

	-- hook this to stop gradient texture whiteout
	self:RawHook("AlertFrame_AnimateIn", function(frame)
		frame.sf.tfade:SetParent(MainMenuBar)
		-- reset Gradient alpha
		frame.sf.tfade:SetGradientAlpha(self:getGradientInfo())
		self.hooks.AlertFrame_AnimateIn(frame)
	end, true)

	local function skinAlertFrames(fName)

		local x1, x2, y1, y2, obj, icon = 5, -5, -10, 12
		if fName == "CriteriaAlertFrame" then
			x1, x2, y1, y2 = 38, 10, 4, 2
		end
		for i = 1, MAX_ACHIEVEMENT_ALERTS do
			obj = _G[fName..i]
			if obj and not obj.sf then
				_G[fName..i.."Background"]:SetTexture(nil)
				_G[fName..i.."Background"].SetTexture = function() end
				_G[fName..i.."Unlocked"]:SetTextColor(aObj.BTr, aObj.BTg, aObj.BTb)
				if _G[fName..i.."OldAchievement"] then _G[fName..i.."OldAchievement"]:SetTexture(nil) end
				icon = _G[fName..i.."Icon"]
				icon:DisableDrawLayer("BORDER")
				icon:DisableDrawLayer("OVERLAY")
				aObj:addButtonBorder{obj=icon, relTo=_G[fName..i.."IconTexture"]}
				aObj:addSkinFrame{obj=obj, ft=ftype, af=true, x1=x1, y1=y1, x2=x2, y2=y2}
			end
		end

	end

	-- Achievement Alert Frames
	if not AchievementAlertFrame1 or AchievementAlertFrame2 then
		self:RawHook("AchievementAlertFrame_GetAlertFrame", function(...)
			local frame = self.hooks.AchievementAlertFrame_GetAlertFrame(...)
			skinAlertFrames("AchievementAlertFrame")
			if AchievementAlertFrame2 then
				self:Unhook("AchievementAlertFrame_GetAlertFrame")
			end
			return frame
		end, true)
	end
	-- skin any existing Achievement Alert Frames
	skinAlertFrames("AchievementAlertFrame")
	-- adjust frame size for guild achievements
	self:SecureHook("AchievementAlertFrame_ShowAlert", function(...)
		local obj, y1, y2
		for i = 1, MAX_ACHIEVEMENT_ALERTS do
			obj = _G["AchievementAlertFrame"..i]
			if obj then
				y1, y2 = -10, 12
	 				if obj.guildDisplay then
					y1, y2 = -8, 8
				end
				self.skinFrame[obj]:SetPoint("TOPLEFT", obj, "TOPLEFT", 5, y1)
				self.skinFrame[obj]:SetPoint("BOTTOMRIGHT", obj, "BOTTOMRIGHT", 5, y2)
			end
		end
	end)

	-- CriteriaAlert Frames
	if not CriteriaAlertFrame1 or CriteriaAlertFrame2 then
		self:RawHook("CriteriaAlertFrame_GetAlertFrame", function(...)
			local frame = self.hooks.CriteriaAlertFrame_GetAlertFrame(...)
			skinAlertFrames("CriteriaAlertFrame")
			if CriteriaAlertFrame2 then
				self:Unhook("CriteriaAlertFrame_GetAlertFrame")
			end
			return frame
		end, true)
	end
	-- skin any existing frames
	skinAlertFrames("CriteriaAlertFrame")

	local function skinDCSAlertFrame(opts)

		if opts.obj and not opts.obj.sf then
			aObj:removeRegions(opts.obj, opts.regs)
			aObj:ScheduleTimer("addButtonBorder", 0.2, {obj=opts.obj, relTo=opts.obj.dungeonTexture, reParent=opts.reParent}) -- wait for animation to finish
			aObj:addSkinFrame{obj=opts.obj, ft=ftype, af=true, ofs=opts.ofs or -7, y1=opts.y1 or nil}
		end

	end

	-- DungeonCompletionAlert Frame
	skinDCSAlertFrame{obj=DungeonCompletionAlertFrame1, regs={2, 3, 4, 5, 6, 10}, ofs=0, y1=-7}
	-- hook dungeon rewards function
	self:SecureHook("DungeonCompletionAlertFrameReward_SetReward", function(frame, ...)
		frame:DisableDrawLayer("OVERLAY")
	end)

	-- ChallengeModeAlert Frame
	skinDCSAlertFrame{obj=ChallengeModeAlertFrame1, regs={1, 3, 7}, reParent={ChallengeModeAlertFrame1.medalIcon}}
	-- hook challenge mode rewards function
	self:SecureHook("ChallengeModeAlertFrameReward_SetReward", function(frame, ...)
		frame:DisableDrawLayer("OVERLAY")
	end)

	-- ScenarioAlert Frame
	skinDCSAlertFrame{obj=ScenarioAlertFrame1, regs={1, 3, 6}}

	-- GuildChallengeAlert Frame
	GuildChallengeAlertFrame:DisableDrawLayer("BACKGROUND")
	GuildChallengeAlertFrame:DisableDrawLayer("BORDER")
	GuildChallengeAlertFrame:DisableDrawLayer("OVERLAY")
	aObj:ScheduleTimer("addButtonBorder", 0.2, {obj=GuildChallengeAlertFrame, relTo=GuildChallengeAlertFrameEmblemIcon}) -- wait for animation to finish
	self:addSkinFrame{obj=GuildChallengeAlertFrame, ft=ftype, af=true}

	local function skinWonAlertFrames(obj)

		if not obj.sf then
			obj.Background:SetTexture(nil)
			obj.IconBorder:SetTexture(nil)
			aObj:ScheduleTimer("addButtonBorder", 0.2, {obj=obj, relTo=obj.Icon}) -- wait for animation to finish
			aObj:addSkinFrame{obj=obj, ft=ftype, af=true, ofs=-10}
		end

	end

	-- LootWonAlert Frame
	self:SecureHook("LootWonAlertFrame_SetUp", function(frame, ...)
		skinWonAlertFrames(frame)
	end)
	for _, frame in pairs(LOOT_WON_ALERT_FRAMES) do
		skinWonAlertFrames(frame)
	end
	-- MoneyWonAlert Frame
	self:SecureHook("MoneyWonAlertFrame_SetUp", function(frame, ...)
		skinWonAlertFrames(frame)
	end)
	for _, frame in pairs(MONEY_WON_ALERT_FRAMES) do
		skinWonAlertFrames(frame)
	end

end

function aObj:AutoComplete()
	if not self.db.profile.AutoComplete or self.initialized.AutoComplete then return end
	self.initialized.AutoComplete = true


	self:add2Table(self.uiKeys1, "AutoComplete")

	self:addSkinFrame{obj=AutoCompleteBox, kfs=true, ft=ftype}

end

function aObj:BattlefieldMinimap() -- LoD
	if not self.db.profile.BattlefieldMm.skin or self.initialized.BattlefieldMm then return end
	self.initialized.BattlefieldMm = true

-->>--	Minimap Tab
	self:keepRegions(BattlefieldMinimapTab, {4, 5}) -- N.B. region 4 is the Text, 5 is the highlight
	asopts = self.isTT and {ba=1} or nil
	self:addSkinFrame{obj=BattlefieldMinimapTab, ft=ftype, noBdr=self.isTT, aso=asopts, y1=-7, y2=-7}
	self:moveObject{obj=BattlefieldMinimapTabText, y=-1} -- move text down

	-- use a backdrop with no Texture otherwise the map tiles are obscured
	self.bfminimapskin = self:addSkinFrame{obj=BattlefieldMinimap, ft=ftype, aso={bd=8}, x1=-4, y1=4, x2=-1, y2=-1}
	if self.db.profile.BattlefieldMm.gloss then
		RaiseFrameLevel(self.bfminimapskin)
	else
		LowerFrameLevel(self.bfminimapskin)
	end
	BattlefieldMinimapCorner:SetTexture(nil)
	BattlefieldMinimapBackground:SetTexture(nil)

	-- change the skinFrame's opacity as required
	self:SecureHook("BattlefieldMinimap_UpdateOpacity", function(opacity)
		local alpha = 1.0 - BattlefieldMinimapOptions.opacity
		alpha = (alpha >= 0.15) and alpha - 0.15 or alpha
		self.skinFrame[BattlefieldMinimap]:SetAlpha(alpha)
	end)

	if IsAddOnLoaded("Capping") then
		if type(self["Capping_ModMap"]) == "function" then self:Capping_ModMap() end
	end

end

function aObj:BindingUI() -- LoD
	if not self.db.profile.MenuFrames or self.initialized.BindingUI then return end
	self.initialized.BindingUI = true

	self:skinScrollBar{obj=KeyBindingFrameScrollFrame}
	self:addSkinFrame{obj=KeyBindingFrame, ft=ftype, kfs=true, hdr=true, x2=-42, y2=10}

end

function aObj:BNFrames()
	if not self.db.profile.BNFrames or self.initialized.BNFrames then return end
	self.initialized.BNFrames = true

	self:add2Table(self.uiKeys1, "BNFrames")

-->>-- Toast frame
	-- hook this to stop gradient texture whiteout
	self:RawHook("BNToastFrame_Show", function()
		BNToastFrame.sf.tfade:SetParent(MainMenuBar)
		BNToastFrame.cb.tfade:SetParent(MainMenuBar)
		-- reset Gradient alpha
		BNToastFrame.sf.tfade:SetGradientAlpha(self:getGradientInfo())
		BNToastFrame.cb.tfade:SetGradientAlpha(self:getGradientInfo())
		self.hooks.BNToastFrame_Show()
	end, true)
	self:addSkinFrame{obj=BNToastFrame, ft=ftype, af=true}

-->>-- Report frame
	BNetReportFrameComment:DisableDrawLayer("BACKGROUND")
	self:skinScrollBar{obj=BNetReportFrameCommentScrollFrame}
	self:skinEditBox{obj=BNetReportFrameCommentBox, regs={6}}
	self:addSkinFrame{obj=BNetReportFrame, ft=ftype}

-->>-- TimeAlert Frame
	self:RawHook("TimeAlert_Start", function(time)
		TimeAlertFrame.sf.tfade:SetParent(MainMenuBar)
		-- reset Gradient alpha
		TimeAlertFrame.sf.tfade:SetGradientAlpha(self:getGradientInfo())
		self.hooks.TimeAlert_Start(time)
	end, true)
	TimeAlertFrameBG:SetBackdrop(nil)
	self:addSkinFrame{obj=TimeAlertFrame, ft=ftype, af=true}

-->>-- ConversationInvite frame
	self:addSkinFrame{obj=BNConversationInviteDialogList, ft=ftype}
	self:skinScrollBar{obj=BNConversationInviteDialogListScrollFrame}
	self:addSkinFrame{obj=BNConversationInviteDialog, kfs=true, ft=ftype, hdr=true}

end

function aObj:Calendar() -- LoD
	if not self.db.profile.Calendar or self.initialized.Calendar then return end
	self.initialized.Calendar = true

-->>--	Calendar Frame
	self:keepFontStrings(CalendarFilterFrame)
	-- move close button
	self:moveObject{obj=CalendarCloseButton, y=14}
	self:adjHeight{obj=CalendarCloseButton, adj=-2}
	self:addButtonBorder{obj=CalendarPrevMonthButton, ofs=-2}
	self:addButtonBorder{obj=CalendarNextMonthButton, ofs=-2}
	self:addSkinFrame{obj=CalendarFrame, ft=ftype, kfs=true, x1=1, y1=-2, x2=2, y2=-7}

-->>-- View Holiday Frame
	self:keepFontStrings(CalendarViewHolidayTitleFrame)
	self:moveObject{obj=CalendarViewHolidayTitleFrame, y=-6}
	self:removeRegions(CalendarViewHolidayCloseButton, {5})
	self:skinScrollBar{obj=CalendarViewHolidayScrollFrame}
	self:addSkinFrame{obj=CalendarViewHolidayFrame, ft=ftype, kfs=true, x1=2, y1=-3, x2=-3, y2=-2}

-->>-- View Raid Frame
	self:keepFontStrings(CalendarViewRaidTitleFrame)
	self:moveObject{obj=CalendarViewRaidTitleFrame, y=-6}
	self:removeRegions(CalendarViewRaidCloseButton, {5})
	self:skinScrollBar{obj=CalendarViewRaidScrollFrame}
	self:addSkinFrame{obj=CalendarViewRaidFrame, ft=ftype, kfs=true, x1=2, y1=-3, x2=-3, y2=2}

-->>-- View Event Frame
	self:keepFontStrings(CalendarViewEventTitleFrame)
	self:moveObject{obj=CalendarViewEventTitleFrame, y=-6}
	self:removeRegions(CalendarViewEventCloseButton, {5})
	self:addSkinFrame{obj=CalendarViewEventDescriptionContainer, ft=ftype}
	self:skinScrollBar{obj=CalendarViewEventDescriptionScrollFrame}
	self:keepFontStrings(CalendarViewEventInviteListSection)
	self:addSkinFrame{obj=CalendarViewEventInviteList, ft=ftype}
	self:addSkinFrame{obj=CalendarViewEventFrame, ft=ftype, kfs=true, x1=2, y1=-3, x2=-3, y2=2}

-->>-- Create Event Frame
	CalendarCreateEventIcon:SetAlpha(1) -- show event icon
	self:keepFontStrings(CalendarCreateEventTitleFrame)
	self:moveObject{obj=CalendarCreateEventTitleFrame, y=-6}
	self:removeRegions(CalendarCreateEventCloseButton, {5})
	self:skinEditBox{obj=CalendarCreateEventTitleEdit, regs={9}}
	self:skinDropDown{obj=CalendarCreateEventTypeDropDown}
	self:skinDropDown{obj=CalendarCreateEventHourDropDown, x2=-5}
	self:skinDropDown{obj=CalendarCreateEventMinuteDropDown, x2=-5}
	self:skinDropDown{obj=CalendarCreateEventAMPMDropDown, x2=-5}
	self:skinDropDown{obj=CalendarCreateEventRepeatOptionDropDown}
	self:addSkinFrame{obj=CalendarCreateEventDescriptionContainer, ft=ftype}
	self:skinScrollBar{obj=CalendarCreateEventDescriptionScrollFrame}
	self:keepFontStrings(CalendarCreateEventInviteListSection)
	self:addSkinFrame{obj=CalendarCreateEventInviteList, ft=ftype}
	self:skinEditBox{obj=CalendarCreateEventInviteEdit, regs={9}}
	CalendarCreateEventMassInviteButtonBorder:SetAlpha(0)
	CalendarCreateEventRaidInviteButtonBorder:SetAlpha(0)
	CalendarCreateEventCreateButtonBorder:SetAlpha(0)
	self:addSkinFrame{obj=CalendarCreateEventFrame, ft=ftype, kfs=true, x1=2, y1=-3, x2=-3, y2=2}

-->>-- Mass Invite Frame
	self:keepFontStrings(CalendarMassInviteTitleFrame)
	self:moveObject{obj=CalendarMassInviteTitleFrame, y=-6}
	self:removeRegions(CalendarMassInviteCloseButton, {5})
	self:skinEditBox{obj=CalendarMassInviteGuildMinLevelEdit, regs={9}}
	self:skinEditBox{obj=CalendarMassInviteGuildMaxLevelEdit, regs={9}}
	self:skinDropDown{obj=CalendarMassInviteGuildRankMenu}
	self:addSkinFrame{obj=CalendarMassInviteFrame, ft=ftype, kfs=true, x1=4, y1=-3, x2=-3, y2=26}

-->>-- Event Picker Frame
	self:keepFontStrings(CalendarEventPickerTitleFrame)
	self:moveObject{obj=CalendarEventPickerTitleFrame, y=-6}
	self:keepFontStrings(CalendarEventPickerFrame)
	self:skinSlider(CalendarEventPickerScrollBar)
	self:removeRegions(CalendarEventPickerCloseButton, {7})
	self:addSkinFrame{obj=CalendarEventPickerFrame, ft=ftype, x1=2, y1=-3, x2=-3, y2=2}

-->>-- Texture Picker Frame
	self:keepFontStrings(CalendarTexturePickerTitleFrame)
	self:moveObject{obj=CalendarTexturePickerTitleFrame, y=-6}
	self:skinSlider(CalendarTexturePickerScrollBar)
	CalendarTexturePickerCancelButtonBorder:SetAlpha(0)
	self:skinButton{obj=CalendarTexturePickerCancelButton}
	CalendarTexturePickerAcceptButtonBorder:SetAlpha(0)
	self:addSkinFrame{obj=CalendarTexturePickerFrame, ft=ftype, kfs=true, x1=5, y1=-3, x2=-3, y2=2}

-->>-- Class Button Container
	for i = 1, MAX_CLASSES do -- allow for the total button
		btn = _G["CalendarClassButton"..i]
		self:removeRegions(btn, {1})
		self:addButtonBorder{obj=btn}
	end
	-- Class Totals button, texture & size changes
	self:moveObject{obj=CalendarClassTotalsButton, x=-2}
	CalendarClassTotalsButton:SetWidth(25)
	CalendarClassTotalsButton:SetHeight(25)
	self:applySkin{obj=CalendarClassTotalsButton, ft=ftype, kfs=true, bba=self.modBtnBs and 1 or 0}

-->>-- ContextMenus
	self:addSkinFrame{obj=CalendarContextMenu}
	self:addSkinFrame{obj=CalendarArenaTeamContextMenu}
	self:addSkinFrame{obj=CalendarInviteStatusContextMenu}

end

function aObj:ChallengesUI() -- LoD
	if not self.db.profile.ChallengesUI or self.initialized.ChallengesUI then return end
	self.initialized.ChallengesUI = true

	self:add2Table(self.uiKeys1, "ChallengesUI")

	self:removeInset(ChallengesFrameInset)
	self:keepFontStrings(ChallengesFrame.details)
	for i = 1, 3 do
		row = ChallengesFrame["RewardRow"..i]
		self:getRegion(row, 1):SetAlpha(0) -- N.B. texture changed in code
		self:addButtonBorder{obj=row.Reward2, relTo=row.Reward2.Icon}
		self:addButtonBorder{obj=row.Reward1, relTo=row.Reward1.Icon}
	end

	-- ChallengesLeaderboard Frame
	self:keepFontStrings(ChallengesLeaderboardFrameHbar)
	self:addSkinFrame{obj=ChallengesLeaderboardFrame, ft=ftype, kfs=true, ofs=-10}
	self:removeRegions(ChallengesFrameLeaderboard, {1})
	self:skinButton{obj=ChallengesFrameLeaderboard}

end

function aObj:ChatButtons()
	if not self.db.profile.ChatButtons or self.initialized.ChatButtons then return end
	self.initialized.ChatButtons = true

	self:add2Table(self.uiKeys1, "ChatButtons")

	if self.modBtnBs then
		for i = 1, NUM_CHAT_WINDOWS do
			obj = _G["ChatFrame"..i].buttonFrame
			self:addButtonBorder{obj=obj.minimizeButton, ofs=-2}
			self:addButtonBorder{obj=obj.downButton, ofs=-2}
			self:addButtonBorder{obj=obj.upButton, ofs=-2}
			self:addButtonBorder{obj=obj.bottomButton, ofs=-2, reParent={self:getRegion(obj.bottomButton, 1)}}
		end
		self:addButtonBorder{obj=ChatFrameMenuButton, ofs=-2}
	end

end

function aObj:ChatConfig()
	if not self.db.profile.ChatConfig or self.initialized.ChatConfig then return end
	self.initialized.ChatConfig = true

	self:add2Table(self.uiKeys1, "ChatConfig")

	self:addSkinFrame{obj=ChatConfigFrame, ft=ftype, kfs=true, hdr=true}
	self:addSkinFrame{obj=ChatConfigCategoryFrame, ft=ftype}
	self:addSkinFrame{obj=ChatConfigBackgroundFrame, ft=ftype}

-->>--	Chat Settings
	for i = 1, #CHAT_CONFIG_CHAT_LEFT do
		_G["ChatConfigChatSettingsLeftCheckBox"..i]:SetBackdrop(nil)
	end
	self:addSkinFrame{obj=ChatConfigChatSettingsLeft, ft=ftype}

	self:addSkinFrame{obj=ChatConfigChatSettingsClassColorLegend, ft=ftype}

-->>--	Channel Settings
	self:SecureHook(ChatConfigChannelSettings, "Show", function(this, ...)
		for i = 1, #ChatConfigChannelSettingsLeft.checkBoxTable do
			_G["ChatConfigChannelSettingsLeftCheckBox"..i]:SetBackdrop(nil)
		end
	end)
	self:addSkinFrame{obj=ChatConfigChannelSettingsLeft, ft=ftype}
	self:addSkinFrame{obj=ChatConfigChannelSettingsClassColorLegend, ft=ftype}

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

	for i = 1, #CHAT_CONFIG_CHAT_CREATURE_LEFT do
		_G["ChatConfigOtherSettingsCreatureCheckBox"..i]:SetBackdrop(nil)
	end
	self:addSkinFrame{obj=ChatConfigOtherSettingsCreature, ft=ftype}

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

	local clrize
	for i, v in ipairs{"Highlighting", "UnitName", "SpellNames", "DamageNumber", "DamageSchool", "EntireLine"} do
		clrize = i > 1 and "Colorize" or ""
		obj = _G["CombatConfigColors"..clrize..v]
		self:addSkinFrame{obj=obj, ft=ftype}
	end

	-- Settings
	self:skinEditBox{obj=CombatConfigSettingsNameEditBox , regs={9}}

	-- Tabs
	for i = 1, #COMBAT_CONFIG_TABS do
		obj = _G["CombatConfigTab"..i]
		self:keepRegions(obj, {4, 5}) -- N.B. region 4 is the Text, 5 is the highlight
		self:addSkinFrame{obj=obj, ft=ftype, y1=-8, y2=-4}
	end

end

local function skinChatEB(obj)

	if aObj.db.profile.ChatEditBox.style == 1 then -- Frame
		local kRegions = CopyTable(aObj.ebRegions)
		table.insert(kRegions, 12)
		table.insert(kRegions, 13)
		aObj:keepRegions(obj, kRegions)
		aObj:addSkinFrame{obj=obj, ft=ftype, x1=2, y1=-2, x2=-2}
		aObj.skinFrame[obj]:SetAlpha(obj:GetAlpha())
	elseif aObj.db.profile.ChatEditBox.style == 2 then -- Editbox
		aObj:skinEditBox{obj=obj, regs={12, 13}, noHeight=true}
	else -- Borderless
		aObj:removeRegions(obj, {6, 7, 8})
		aObj:addSkinFrame{obj=obj, ft=ftype, noBdr=true, x1=5, y1=-4, x2=-5, y2=2}
		aObj.skinFrame[obj]:SetAlpha(obj:GetAlpha())
	end
	aObj.skinned[obj] = true


end
function aObj:ChatEditBox()
	-- don't use an initialized value to allow for dynamic changes
	if not self.db.profile.ChatEditBox.skin then return end

	self:add2Table(self.uiKeys2, "ChatEditBox")

	-- these addons replace the Chat Edit Box
	if IsAddOnLoaded("NeonChat")
	or IsAddOnLoaded("Chatter")
	or IsAddOnLoaded("Prat-3.0")
	then
		return
	end

	for i = 1, NUM_CHAT_WINDOWS do
		skinChatEB(_G["ChatFrame"..i].editBox)
	end
	-- if editBox has a skin frame then hook these to manage its Alpha setting
	if self.db.profile.ChatEditBox.style ~= 2
	and not self:IsHooked("ChatEdit_ActivateChat")
	then
		self:SecureHook("ChatEdit_ActivateChat", function(editBox)
			if editBox
			and self.skinFrame[editBox]
			then
				self.skinFrame[editBox]:SetAlpha(editBox:GetAlpha())
			end
		end)
		self:SecureHook("ChatEdit_DeactivateChat", function(editBox)
			if editBox
			and self.skinFrame[editBox]
			then
				self.skinFrame[editBox]:SetAlpha(editBox:GetAlpha())
			end
		end)
	end

end

function aObj:ChatFrames()
	if not self.db.profile.ChatFrames or self.initialized.ChatFrames then return end
	self.initialized.ChatFrames = true

	self:add2Table(self.uiKeys1, "ChatFrames")

	local clqbf = "CombatLogQuickButtonFrame"
	local clqbf_c = clqbf.."_Custom"
	local yOfs1 = 4
	for i = 1, NUM_CHAT_WINDOWS do
		obj = _G["ChatFrame"..i]
		if obj == COMBATLOG
		and _G[clqbf_c]:IsShown()
		then
			yOfs1 = 31
		else
			yOfs1 = 4
		end
		self:addSkinFrame{obj=obj, ft=ftype, x1=-4, y1=yOfs1, x2=4, y2=-8}
	end

	-- CombatLog Quick Button Frame & Progress Bar
	if self.db.profile.CombatLogQBF then
		if _G[clqbf_c] then
			self:keepFontStrings(_G[clqbf_c])
			self:addSkinFrame{obj=_G[clqbf_c], ft=ftype, x1=-4, x2=4}
			self:adjHeight{obj=_G[clqbf_c], adj=4}
			self:glazeStatusBar(_G[clqbf_c.."ProgressBar"], 0, _G[clqbf_c.."Texture"])
		else
			self:glazeStatusBar(_G[clqbf.."ProgressBar"], 0, _G[clqbf.."Texture"])
		end
	end

end

function aObj:ChatMenus()
	if not self.db.profile.ChatMenus or self.initialized.ChatMenus then return end
	self.initialized.ChatMenus = true

	self:add2Table(self.uiKeys1, "ChatMenus")

	self:addSkinFrame{obj=ChatMenu, ft=ftype}
	self:addSkinFrame{obj=EmoteMenu, ft=ftype}
	self:addSkinFrame{obj=LanguageMenu, ft=ftype}
	self:addSkinFrame{obj=VoiceMacroMenu, ft=ftype}
	self:addSkinFrame{obj=GeneralDockManagerOverflowButtonList, ft=ftype}

end

function aObj:ChatMinimizedFrames()

	-- self:add2Table(self.uiKeys1, "ChatMinimizedFrames") -- N.B. no option for this, internal function only

	-- minimized chat frames
	self:SecureHook("FCF_CreateMinimizedFrame", function(chatFrame)
		local obj = _G[chatFrame:GetName().."Minimized"]
		self:removeRegions(obj, {1, 2, 3})
		self:addSkinFrame{obj=obj, ft=ftype, x1=1, y1=-2, x2=-1, y2=2}
		self:addButtonBorder{obj=_G[chatFrame:GetName().."MinimizedMaximizeButton"], ofs=-1}
	end)

end

local function skinChatTab(objName)

	tab = _G[objName.."Tab"]
	aObj:keepRegions(tab, {7, 8, 9, 10, 11, 12}) --N.B. region 7 is glow, 8-10 are highlight, 11 is text, 12 is icon
	tabSF = aObj:addSkinFrame{obj=tab, ft=ftype, noBdr=aObj.isTT, y1=-8, y2=-5}
	tabSF:SetAlpha(0.2)
	-- hook this to fix tab gradient texture overlaying text & highlight
	if not aObj:IsHooked(tab, "SetParent") then
		aObj:SecureHook(tab, "SetParent", function(this, parent)
			local tabSF = aObj.skinFrame[this]
			if parent == GeneralDockManager.scrollFrame.child then
				tabSF:SetParent(GeneralDockManager)
			else
				tabSF:SetParent(this)
				tabSF:SetFrameLevel(1) -- reset frame level so that the texture is behind text etc
			end
		end)
	end
	-- hook this to manage alpha changes when chat frame fades in and out
	if not aObj:IsHooked(tab, "SetAlpha") then
		aObj:SecureHook(tab, "SetAlpha", function(this, alpha)
			aObj.skinFrame[this]:SetAlpha(alpha)
		end)
	end

end
function aObj:ChatTabs()
	if not self.db.profile.ChatTabs or self.initialized.ChatTabs then return end
	self.initialized.ChatTabs = true

	self:add2Table(self.uiKeys1, "ChatTabs")

	for i = 1, NUM_CHAT_WINDOWS do
		skinChatTab("ChatFrame"..i)
	end

end

function aObj:ChatTemporaryWindow()
	if not self.db.profile.ChatTabs
	and not self.db.profile.ChatFrames
	and not self.db.profile.ChatEditBox.skin
	then return end

	-- self:add2Table(self.uiKeys1, "ChatTemporaryWindow") -- N.B. no option for this, internal function only

	local function skinTempWindow(obj)

		if self.db.profile.ChatTabs
		and not self.skinFrame[obj]
		then
			skinChatTab(obj:GetName())
		end
		if self.db.profile.ChatFrames
		and not self.skinFrame[obj]
		then
			self:addSkinFrame{obj=obj, ft=ftype, x1=-4, y1=4, x2=4, y2=-8}
		end
		if self.db.profile.ChatEditBox.skin
		and not self.skinned[obj.editBox]
			then skinChatEB(obj.editBox)
		end

	end
	-- hook this to handle Temporary windows (BN Conversations, Pet Battles etc)
	self:RawHook("FCF_OpenTemporaryWindow", function(...)
		local obj = self.hooks.FCF_OpenTemporaryWindow(...)
		skinTempWindow(obj)
		return obj
	end, true)
	-- skin any existing temporary windows
	for i = NUM_CHAT_WINDOWS + 1, NUM_CHAT_WINDOWS + 10 do
		if _G["ChatFrame"..i] then skinTempWindow(_G["ChatFrame"..i]) end
	end

end

function aObj:CinematicFrame()
	if not self.db.profile.CinematicFrame or self.initialized.CinematicFrame then return end
	self.initialized.CinematicFrame = true

	self:add2Table(self.uiKeys1, "CinematicFrame")

	self:addSkinFrame{obj=CinematicFrame.closeDialog, ft=ftype}

end

function aObj:CoinPickup()
	if not self.db.profile.CoinPickup or self.initialized.CoinPickup then return end
	self.initialized.CoinPickup = true

	self:add2Table(self.uiKeys1, "CoinPickup")

	self:addSkinFrame{obj=CoinPickupFrame, ft=ftype, kfs=true, x1=9, y1=-12, x2=-6, y2=12}

end

function aObj:ColorPicker()
	if not self.db.profile.Colours or self.initialized.Colours then return end
	self.initialized.Colours = true

	self:add2Table(self.uiKeys1, "Colours")

	ColorPickerFrame:SetBackdrop(nil)
	ColorPickerFrameHeader:SetAlpha(0)
	self:skinSlider(OpacitySliderFrame, 4)
	self:addSkinFrame{obj=ColorPickerFrame, ft=ftype, y1=6}

-->>-- Opacity Frame, used by BattlefieldMinimap amongst others
	OpacityFrame:SetBackdrop(nil)
	self:skinSlider{obj=OpacityFrameSlider, size=3}
	self:addSkinFrame{obj=OpacityFrame, ft=ftype}

end

function aObj:DebugTools() -- LoD
	if not self.db.profile.DebugTools or self.initialized.DebugTools then return end
	self.initialized.DebugTools = true

	self:skinSlider{obj=EventTraceFrameScroll, size=3}
	self:addSkinFrame{obj=EventTraceFrame, ft=ftype, kfs=true, x1=1, y1=-2, x2=-1, y2=4}
	self:skinScrollBar{obj=ScriptErrorsFrameScrollFrame}
	self:addSkinFrame{obj=ScriptErrorsFrame, ft=ftype, kfs=true, x1=1, y1=-2, x2=-1, y2=4}

	if self.db.profile.Tooltips.skin then
		self:add2Table(self.ttList, "FrameStackTooltip")
		self:add2Table(self.ttList, "EventTraceTooltip")
		self:HookScript(FrameStackTooltip, "OnUpdate", function(this)
			self:skinTooltip(this)
		end)
		self:HookScript(EventTraceTooltip, "OnUpdate", function(this)
			self:skinTooltip(this)
		end)
	end

end

function aObj:DestinyFrame()
	if not self.db.profile.DestinyFrame or self.initialized.DestinyFrame then return end
	self.initialized.DestinyFrame = true

	self:add2Table(self.uiKeys1, "DestinyFrame")

	-- buttons
	for _, v in pairs{"alliance", "horde"} do
		btn = DestinyFrame[v.."Button"]
		self:removeRegions(btn, {1})
		tex = btn:GetHighlightTexture()
		tex:SetTexture([[Interface\HelpFrame\HelpButtons]])
		tex:SetTexCoord(0.00390625, 0.78125000, 0.00390625, 0.21484375)
		self:adjWidth{obj=btn, adj=-60}
		self:adjHeight{obj=btn, adj=-60}
		self:skinButton{obj=btn, x1=0, y1=0, x2=-1, y2=3}
	end

	DestinyFrame.alphaLayer:SetTexture(0, 0, 0, 0.70)
	DestinyFrame.background:SetTexture(nil)
	DestinyFrame.frameHeader:SetTextColor(self.HTr, self.HTg, self.HTb)
	DestinyFrameAllianceLabel:SetTextColor(self.BTr, self.BTg, self.BTb)
	DestinyFrameHordeLabel:SetTextColor(self.BTr, self.BTg, self.BTb)
	DestinyFrameLeftOrnament:SetTexture(nil)
	DestinyFrameRightOrnament:SetTexture(nil)
	DestinyFrame.allianceText:SetTextColor(self.BTr, self.BTg, self.BTb)
	DestinyFrame.hordeText:SetTextColor(self.BTr, self.BTg, self.BTb)
	DestinyFrameAllianceFinalText:SetTextColor(self.BTr, self.BTg, self.BTb)
	DestinyFrameHordeFinalText:SetTextColor(self.BTr, self.BTg, self.BTb)

end

function aObj:DropDownPanels()
	if not self.db.profile.DropDownPanels or self.initialized.DropDownPanels then return end
	self.initialized.DropDownPanels = true

	self:add2Table(self.uiKeys1, "DropDowns")

	self:SecureHook("UIDropDownMenu_CreateFrames", function(...)
		local obj, objName
		for i = 1, UIDROPDOWNMENU_MAXLEVELS do
			objName = "DropDownList"..i
			obj = _G[objName]
			if not self:IsHooked(obj, "Show") then
				self:SecureHook(obj, "Show", function(this)
					_G[this:GetName().."Backdrop"]:Hide()
					_G[this:GetName().."MenuBackdrop"]:Hide()
					if not self.skinFrame[this] then
						self:addSkinFrame{obj=this, ft=ftype, kfs=true}
					end
				end)
			end
		end
	end)

end

if aObj.isPTR then
	function aObj:FeedbackUI() -- LoD
		if not self.db.profile.Feedback or self.initialized.Feedback then return end
		self.initialized.Feedback = true

		local bbR, bbG, bbB, bbA = unpack(self.bbColour)

		self:keepFontStrings(FeedbackUITitleFrm)
		FeedbackUIWelcomeFrame:SetBackdrop(nil)
		self:skinDropDown{obj=FeedbackUI_ModifierKeyDropDown}
		self:addSkinFrame{obj=FeedbackUI_ModifierKeyDropDownList, ft=ftype}
		self:skinDropDown{obj=FeedbackUI_MouseButtonDropDown}
		self:addSkinFrame{obj=FeedbackUI_MouseButtonDropDownList, ft=ftype}
		self:addSkinFrame{obj=FeedbackUI, ft=ftype, kfs=true}
		self:add2Table(UISpecialFrames, "FeedbackUI") -- make it closeable with Esc key

	-->>-- Welcome Frame panels
		FeedbackUIWelcomeFrameSurveys:DisableDrawLayer("BORDER")
		self:addButtonBorder{obj=FeedbackUIWelcomeFrameSurveys, relTo=FeedbackUIWelcomeFrameSurveysIcon}
		FeedbackUIWelcomeFrameSuggestions:DisableDrawLayer("BORDER")
		self:addButtonBorder{obj=FeedbackUIWelcomeFrameSuggestions, relTo=FeedbackUIWelcomeFrameSuggestionsIcon}
		FeedbackUIWelcomeFrameBugs:DisableDrawLayer("BORDER")
		self:addButtonBorder{obj=FeedbackUIWelcomeFrameBugs, relTo=FeedbackUIWelcomeFrameBugsIcon}

	-->-- Survey Frame
		FeedbackUISurveyFrame:SetBackdrop(nil)
		self:skinDropDown{obj=FeedbackUISurveyFrameSurveysPanelDdlCategory}
		self:addSkinFrame{obj=FeedbackUISurveyFrameSurveysPanelDdlCategoryList, ft=ftype}
		self:skinDropDown{obj=FeedbackUISurveyFrameSurveysPanelDdlStatus}
		self:addSkinFrame{obj=FeedbackUISurveyFrameSurveysPanelDdlStatusList, ft=ftype}
		FeedbackUISurveyFrameSurveysPanelHeadersColumnUnderline:SetAlpha(0)
		for i = 1, 8 do
			self:skinButton{obj=_G["FeedbackUISurveyFrameSurveysPanelScrollButtonsOption"..i.."Btn"], mp2=true}
		end
		self:skinUsingBD{obj=FeedbackUISurveyFrameSurveysPanelScrollScrollControls, size=3}
		FeedbackUISurveyFrameSurveysPanelBorder:SetBackdropBorderColor(bbR, bbG, bbB, bbA)
		FeedbackUISurveyFrameStatusPanelBorder:SetBackdropBorderColor(bbR, bbG, bbB, bbA)
		FeedbackUISurveyFrameStatusPanelLine:SetAlpha(0)
		FeedbackUISurveyFrameStepThroughPanelBorder:SetBackdropBorderColor(bbR, bbG, bbB, bbA)
		self:addSkinFrame{obj=FeedbackUISurveyFrameStepThroughPanelHeader, ft=ftype, x1=1, y1=-1, x2=-1, y2=1}
		self:addSkinFrame{obj=FeedbackUISurveyFrameStepThroughPanelEdit, ft=ftype}
		self:skinScrollBar{obj=FeedbackUISurveyFrameStepThroughPanelEditInput}
		self:skinUsingBD{obj=FeedbackUISurveyFrameStepThroughPanelScrollScrollControls, size=3}
		if self.modBtnBs then
			-- skin the alert buttons
			for i = 1, 10 do
				obj = _G["FeedbackUISurveyFrameSurveysPanelAlertFrameButton"..i]
				self:addButtonBorder{obj=obj, ofs=0, x2=-2, y2=3}
			end
		end

	-->>-- Suggestion Frame
		FeedbackUISuggestFrame:SetBackdrop(nil)
		FeedbackUISuggestFrameInfoPanelBorder:SetBackdropBorderColor(bbR, bbG, bbB, bbA)
		FeedbackUISuggestFrameStatusPanelBorder:SetBackdropBorderColor(bbR, bbG, bbB, bbA)
		FeedbackUISuggestFrameStatusPanelLine:SetAlpha(0)
		FeedbackUISuggestFrameStepThroughPanelBorder:SetBackdropBorderColor(bbR, bbG, bbB, bbA)
		self:addSkinFrame{obj=FeedbackUISuggestFrameStepThroughPanelHeader, ft=ftype, x1=1, y1=-1, x2=-1, y2=1}
		self:addSkinFrame{obj=FeedbackUISuggestFrameStepThroughPanelEdit, ft=ftype}
		self:skinScrollBar{obj=FeedbackUISuggestFrameStepThroughPanelEditInput}
		self:skinUsingBD{obj=FeedbackUISuggestFrameStepThroughPanelScrollScrollControls, size=3}

	-->>-- Bug Frame
		FeedbackUIBugFrame:SetBackdrop(nil)
		FeedbackUIBugFrameInfoPanelBorder:SetBackdropBorderColor(bbR, bbG, bbB, bbA)
		FeedbackUIBugFrameStatusPanelBorder:SetBackdropBorderColor(bbR, bbG, bbB, bbA)
		FeedbackUIBugFrameStatusPanelLine:SetAlpha(0)
		FeedbackUIBugFrameStepThroughPanelBorder:SetBackdropBorderColor(bbR, bbG, bbB, bbA)
		self:addSkinFrame{obj=FeedbackUIBugFrameStepThroughPanelHeader, ft=ftype, x1=1, y1=-1, x2=-1, y2=1}
		self:addSkinFrame{obj=FeedbackUIBugFrameStepThroughPanelEdit, ft=ftype}
		self:skinScrollBar{obj=FeedbackUIBugFrameStepThroughPanelEditInput}
		self:skinUsingBD{obj=FeedbackUIBugFrameStepThroughPanelScrollScrollControls, size=3}

		-- make the QuestLog Tip Label text visible
		FeedbackUIQuestLogTipLabel:SetTextColor(self.BTr, self.BTg, self.BTb)

		-- Minimap Button
		if self.db.profile.MinimapButtons.skin then
			for _, reg in ipairs{FeedbackUIButton:GetRegions()} do
				reg:SetWidth(26)
				reg:SetHeight(26)
			end
		end

	end
end

function aObj:GMChatUI() -- LoD
	if not self.db.profile.GMChatUI or self.initialized.GMChatUI then return end
	self.initialized.GMChatUI = true

-->>-- GM Chat Request frame
	GMChatStatusFrame:DisableDrawLayer("BORDER")
	GMChatStatusFrame:DisableDrawLayer("OVERLAY")
	self:addSkinFrame{obj=GMChatStatusFrame, ft=ftype, anim=true, x1=30, y1=-12, x2=-30, y2=12}

-->>-- GMChat Frame
	if self.db.profile.ChatFrames then
		self:addSkinFrame{obj=GMChatFrame, ft=ftype, x1=-4, y1=4, x2=4, y2=-8, nb=true}
	end
	self:skinButton{obj=GMChatFrameCloseButton, cb=true}
	GMChatFrame:DisableDrawLayer("BORDER")

-->>-- GMChatFrameEditBox
	if self.db.profile.ChatEditBox.skin then
		if self.db.profile.ChatEditBox.style == 1 then -- Frame
			local kRegions = CopyTable(self.ebRegions)
			table.insert(kRegions, 12)
			self:keepRegions(GMChatFrame.editBox, kRegions)
			self:addSkinFrame{obj=GMChatFrame.editBox, ft=ftype, x1=2, y1=-2, x2=-2}
		elseif self.db.profile.ChatEditBox.style == 2 then -- Editbox
			self:skinEditBox{obj=GMChatFrame.editBox, regs={12}, noHeight=true}
		else -- Borderless
			self:removeRegions(GMChatFrame.editBox, {6, 7, 8})
			self:addSkinFrame{obj=GMChatFrame.editBox, ft=ftype, noBdr=true, x1=5, y1=-4, x2=-5, y2=2}
		end
	end

-->>-- GMChat Frame Tab
	self:addSkinFrame{obj=GMChatTab, kfs=true, ft=ftype, noBdr=self.isTT, y2=-4}

end

function aObj:GMSurveyUI() -- LoD
	if not self.db.profile.GMSurveyUI or self.initialized.GMSurveyUI then return end
	self.initialized.GMSurveyUI = true

	self:keepFontStrings(GMSurveyHeader)
	self:moveObject{obj=GMSurveyHeaderText, y=-8}
	self:addSkinFrame{obj=GMSurveyFrame, ft=ftype, kfs=true, y1=-6, x2=-45}

	self:skinScrollBar{obj=GMSurveyScrollFrame}

	for i = 1, MAX_SURVEY_QUESTIONS do
		obj = _G["GMSurveyQuestion"..i]
		self:applySkin{obj=obj, ft=ftype} -- must use applySkin otherwise text is behind gradient
		obj.SetBackdropColor = function() end
		obj.SetBackdropBorderColor = function() end
	end

	self:skinScrollBar{obj=GMSurveyCommentScrollFrame}
	self:applySkin{obj=GMSurveyCommentFrame, ft=ftype} -- must use applySkin otherwise text is behind gradient

end

function aObj:GuildBankUI() -- LoD
	if not self.db.profile.GuildBankUI or self.initialized.GuildBankUI then return end
	self.initialized.GuildBankUI = true

-->>--	Main Frame
	GuildBankEmblemFrame:Hide()
	for i = 1, NUM_GUILDBANK_COLUMNS do
		objName = "GuildBankColumn"..i
		_G[objName.."Background"]:SetAlpha(0)
		for j = 1, NUM_SLOTS_PER_GUILDBANK_GROUP do
			self:addButtonBorder{obj=_G[objName.."Button"..j], ibt=true}
		end
	end
	self:skinEditBox{obj=GuildItemSearchBox, regs={9}, mi=true, noHeight=true, noMove=true}
	self:skinTabs{obj=GuildBankFrame, lod=true}
	GuildBankMoneyFrameBackground:DisableDrawLayer("BACKGROUND")
	self:addSkinFrame{obj=GuildBankFrame, ft=ftype, kfs=true, hdr=true, x1=-3, y1=2, x2=1, y2=-5}
-->>--	Log Frame
	self:skinScrollBar{obj=GuildBankTransactionsScrollFrame}

-->>--	Info Frame
	self:skinScrollBar{obj=GuildBankInfoScrollFrame}

-->>--	GuildBank Popup Frame
	self:skinEditBox{obj=GuildBankPopupEditBox, regs={9}}
	self:skinScrollBar{obj=GuildBankPopupScrollFrame}
	self:addSkinFrame{obj=GuildBankPopupFrame, ft=ftype, kfs=true, hdr=true, x1=2, y1=-12, x2=-24, y2=24}

-->>--	Tabs (side)
	for i = 1, MAX_GUILDBANK_TABS do
		objName = "GuildBankTab"..i
		_G[objName]:DisableDrawLayer("BACKGROUND")
		self:addButtonBorder{obj=_G[objName.."Button"], relTo=_G[objName.."ButtonIconTexture"]}
	end

	-- send message when UI is skinned (used by oGlow skin)
	self:SendMessage("GuildBankUI_Skinned", self)

end

function aObj:HelpFrame()
	if not self.db.profile.HelpFrame or self.initialized.HelpFrame then return end
	self.initialized.HelpFrame = true

	self:add2Table(self.uiKeys1, "HelpFrame")

	self:keepFontStrings(HelpFrame.header)
	self:moveObject{obj=HelpFrame.header, y=-12}
	self:removeInset(HelpFrame.leftInset)
	self:removeInset(HelpFrame.mainInset)
	self:addSkinFrame{obj=HelpFrame, ft=ftype, kfs=true, ofs=-10}
	-- Knowledge Base panel
	self:keepFontStrings(HelpFrame.kbase)
	self:skinEditBox{obj=HelpFrame.kbase.searchBox, regs={9}, mi=true, noHeight=true, noMove=true}
	self:skinSlider{obj=HelpFrame.kbase.scrollFrame.ScrollBar, adj=-4}
	self:skinSlider{obj=HelpFrame.kbase.scrollFrame2.ScrollBar, adj=-6}
	for i = 1, #HelpFrame.kbase.scrollFrame.buttons do
		btn = HelpFrame.kbase.scrollFrame.buttons[i]
		btn:DisableDrawLayer("ARTWORK")
		self:skinButton{obj=btn, as=true}
	end
	-- Nav Bar
	HelpFrame.kbase.navBar:DisableDrawLayer("BACKGROUND")
	HelpFrame.kbase.navBar.overlay:DisableDrawLayer("OVERLAY")
	HelpFrame.kbase.navBar.home:DisableDrawLayer("OVERLAY")
	HelpFrame.kbase.navBar.home:GetNormalTexture():SetAlpha(0)
	HelpFrame.kbase.navBar.home:GetPushedTexture():SetAlpha(0)
	HelpFrame.kbase.navBar.home.text:SetPoint("RIGHT", -20, 0) -- allow text to be fully displayed
	-- hook this to handle navbar buttons
	self:SecureHook("NavBar_AddButton", function(this, buttonData)
		-- self:Debug("NavBar_AddButton: [%s, %s]", this, buttonData)
		for i = 1, #this.navList do
			local btn = this.navList[i]
			btn:DisableDrawLayer("OVERLAY")
			btn:GetNormalTexture():SetAlpha(0)
			btn:GetPushedTexture():SetAlpha(0)
		end
	end)

	-- Report Player panel
	self:addSkinFrame{obj=ReportPlayerNameDialog.CommentFrame, ft=ftype, kfs=true, y2=-2}
	ReportPlayerNameDialog.CommentFrame.EditBox.InformationText:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:addSkinFrame{obj=ReportPlayerNameDialog, ft=ftype}
	self:addSkinFrame{obj=ReportCheatingDialog.CommentFrame, ft=ftype, kfs=true, y2=-2}
	ReportCheatingDialog.CommentFrame.EditBox.InformationText:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:addSkinFrame{obj=ReportCheatingDialog, ft=ftype}
	-- Account Security panel
	-- Character Stuck! panel
	self:addButtonBorder{obj=HelpFrameCharacterStuckHearthstone, es=20}
	-- Submit Bug panel
	self:skinSlider{obj=HelpFrameReportBugScrollFrame.ScrollBar, size=3}
	self:addSkinFrame{obj=self:getChild(HelpFrame.bug, 3), ft=ftype}
	-- Submit Suggestion panel
	self:skinSlider{obj=HelpFrameSubmitSuggestionScrollFrame.ScrollBar, size=3}
	self:addSkinFrame{obj=self:getChild(HelpFrame.suggestion, 3), ft=ftype}
	-- Open a Ticket panel
	--	Ticket panel
	self:skinSlider{obj=HelpFrameTicketScrollFrame.ScrollBar}
	self:addSkinFrame{obj=self:getChild(HelpFrame.ticket, 4), ft=ftype}
	--	Ticket Status Frame
	self:addSkinFrame{obj=TicketStatusFrameButton, ft=ftype}
	-- HelpOpenTicketButton
	HelpOpenTicketButton.tutorial:DisableDrawLayer("BACKGROUND")
	self:addSkinFrame{obj=HelpOpenTicketButton.tutorial, ft=ftype, y1=3, x2=3}

end

function aObj:ItemText()
	if not self.db.profile.ItemText or self.initialized.ItemText then return end
	self.initialized.ItemText = true

	self:add2Table(self.uiKeys1, "ItemText")

	self:SecureHookScript(ItemTextFrame, "OnShow", function(this)
		ItemTextPageText:SetTextColor(self.BTr, self.BTg, self.BTb)
	end)

	self:skinScrollBar{obj=ItemTextScrollFrame}
	self:glazeStatusBar(ItemTextStatusBar, 0)
	self:moveObject{obj=ItemTextPrevPageButton, x=-55} -- move prev button left
	self:addButtonBorder{obj=ItemTextPrevPageButton, ofs=-2}
	self:addButtonBorder{obj=ItemTextNextPageButton, ofs=-2}
	self:addSkinFrame{obj=ItemTextFrame, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-2}

end

function aObj:ItemUpgradeUI() -- LoD
	if not self.db.profile.ItemUpgradeUI or self.initialized.ItemUpgradeUI then return end
	self.initialized.ItemUpgradeUI = true

	ItemUpgradeFrame.MissingDescription:SetTextColor(self.BTr, self.BTg, self.BTb)
	ItemUpgradeFrame.NoMoreUpgrades:SetTextColor(self.BTr, self.BTg, self.BTb)
	ItemUpgradeFrame.TitleTextLeft:SetTextColor(self.BTr, self.BTg, self.BTb)
	ItemUpgradeFrame.TitleTextRight:SetTextColor(self.BTr, self.BTg, self.BTb)
	ItemUpgradeFrameShadows:DisableDrawLayer("OVERLAY")
	self:addButtonBorder{obj=ItemUpgradeFrame.ItemButton, relTo=ItemUpgradeFrame.ItemButton.IconTexture}
	ItemUpgradeFrame.ItemButton.ItemFrame:SetTexture(nil)
	ItemUpgradeFrame.ItemButton.ItemName:SetTextColor(self.BTr, self.BTg, self.BTb)
	ItemUpgradeFrame.ItemButton.MissingText:SetTextColor(self.BTr, self.BTg, self.BTb)
	ItemUpgradeFrameMoneyFrame:DisableDrawLayer("BACKGROUND")
	self:removeMagicBtnTex(ItemUpgradeFrameUpgradeButton)
	self:addSkinFrame{obj=ItemUpgradeFrame, ft=ftype, kfs=true}

end

function aObj:LevelUpDisplay()
	if not self.db.profile.LevelUpDisplay or self.initialized.LevelUpDisplay then return end
	self.initialized.LevelUpDisplay = true

	self:add2Table(self.uiKeys1, "LevelUpDisplay")

	LevelUpDisplay:DisableDrawLayer("BACKGROUND")

end

function aObj:LFDFrame()
	if not self.db.profile.LFDFrame or self.initialized.LFDFrame then return end
	self.initialized.LFDFrame = true

	self:add2Table(self.uiKeys1, "LFDFrame")

	-- LFD RoleCheck Popup
	self:addSkinFrame{obj=LFDRoleCheckPopup, kfs=true, ft=ftype}

	-- LFD Parent Frame (now part of PVE Frame)
	self:keepFontStrings(LFDParentFrame)
	self:removeInset(LFDParentFrame.Inset)

	-- LFD Queue Frame
	LFDQueueFrameBackground:SetAlpha(0)
	self:skinDropDown{obj=LFDQueueFrameTypeDropDown}
	self:skinScrollBar{obj=LFDQueueFrameRandomScrollFrame}
	self:removeMagicBtnTex(LFDQueueFrameFindGroupButton)
	if self.modBtnBs then
		self:SecureHook("LFDQueueFrameRandom_UpdateFrame", function()
			local btnName
			for i = 1, 5 do
				btnName = "LFDQueueFrameRandomScrollFrameChildFrameItem"..i
				if _G[btnName] then
					_G[btnName.."NameFrame"]:SetTexture(nil)
					self:addButtonBorder{obj=_G[btnName], libt=true}
				end
			end
		end)
	end

	-- Specific List subFrame
	for i = 1, NUM_LFD_CHOICE_BUTTONS do
		btn = "LFDQueueFrameSpecificListButton"..i.."ExpandOrCollapseButton"
		self:skinButton{obj=_G[btn], mp2=true}
	end
	self:skinScrollBar{obj=LFDQueueFrameSpecificListScrollFrame}

end

function aObj:LFGFrame()
	if not self.db.profile.LFGFrame or self.initialized.LFGFrame then return end
	self.initialized.LFGFrame = true

	self:add2Table(self.uiKeys1, "LFGFrame")

	-- LFG DungeonReady Popup a.k.a. ReadyCheck
	self:addSkinFrame{obj=LFGDungeonReadyStatus, kfs=true, ft=ftype}
	self:addSkinFrame{obj=LFGDungeonReadyDialog, kfs=true, ft=ftype}
	LFGDungeonReadyDialog.SetBackdrop = function() end
	LFGDungeonReadyDialogRewardsFrameReward1Border:SetAlpha(0)
	LFGDungeonReadyDialogRewardsFrameReward2Border:SetAlpha(0)

end

function aObj:LFRFrame()
	if not self.db.profile.LFRFrame or self.initialized.LFRFrame then return end
	self.initialized.LFRFrame = true

	self:add2Table(self.uiKeys1, "LFRFrame")

	self:addSkinFrame{obj=RaidBrowserFrame, ft=ftype, kfs=true, x1=-3, y1=2, x2=1, y2=-2}

	-- LFR Parent Frame
	-- LFR Queue Frame
	self:removeInset(LFRQueueFrameRoleInset)
	self:removeInset(LFRQueueFrameCommentInset)
	self:removeInset(LFRQueueFrameListInset)
	LFRQueueFrameCommentExplanation:SetTextColor(self.BTr, self.BTg, self.BTb)

	-- Specific List subFrame
	for i = 1, NUM_LFR_CHOICE_BUTTONS do
		btn = "LFRQueueFrameSpecificListButton"..i.."ExpandOrCollapseButton"
		self:skinButton{obj=_G[btn], mp2=true}
		self:moveObject{obj=_G[btn.."Highlight"], x=-3} -- move highlight to the left
	end
	self:skinScrollBar{obj=LFRQueueFrameSpecificListScrollFrame}

	-- LFR Browse Frame
	self:removeInset(LFRBrowseFrameRoleInset)
	self:skinDropDown{obj=LFRBrowseFrameRaidDropDown}
	self:skinScrollBar{obj=LFRBrowseFrameListScrollFrame}
	self:keepFontStrings(LFRBrowseFrame)

	-- Tabs (side)
	for i = 1, 2 do
		obj = _G["LFRParentFrameSideTab"..i]
		obj:DisableDrawLayer("BACKGROUND")
		self:addButtonBorder{obj=obj}
	end

end

function aObj:MacroUI() -- LoD
	if not self.db.profile.MenuFrames or self.initialized.MacroUI then return end
	self.initialized.MacroUI = true

-->>-- Macro Frame
	self:skinScrollBar{obj=MacroButtonScrollFrame}
	self:skinScrollBar{obj=MacroFrameScrollFrame}
	self:skinEditBox{obj=MacroFrameText, noSkin=true}
	self:addSkinFrame{obj=MacroFrameTextBackground, ft=ftype, y2=2}
	self:skinTabs{obj=MacroFrame, up=true, lod=true, x1=-3, y1=-3, x2=3, y2=-3, hx=-2, hy=3}
	self:addSkinFrame{obj=MacroFrame, ft=ftype, kfs=true, hdr=true, ri=true, x1=-3, y1=2, x2=1, y2=-2}
	if self.modBtnBs then
		-- add button borders
		btnName = "MacroFrameSelectedMacroButton"
		_G[btnName]:DisableDrawLayer("BACKGROUND")
		self:addButtonBorder{obj=_G[btnName], relTo=_G[btnName.."Icon"]}
		for i = 1, MAX_ACCOUNT_MACROS do
			btnName = "MacroButton"..i
			_G[btnName]:DisableDrawLayer("BACKGROUND")
			self:addButtonBorder{obj=_G[btnName], relTo=_G[btnName.."Icon"], spbt=true}
		end
	end

-->>-- Macro Popup Frame
	self:skinEditBox{obj=MacroPopupEditBox}
	self:skinScrollBar{obj=MacroPopupScrollFrame}
	self:addSkinFrame{obj=MacroPopupFrame, ft=ftype, kfs=true, x1=8, y1=-8, x2=-2, y2=4}
	-- add button borders
	for i = 1, NUM_MACRO_ICONS_SHOWN do
		btnName = "MacroPopupButton"..i
		_G[btnName]:DisableDrawLayer("BACKGROUND")
		self:addButtonBorder{obj=_G[btnName], relTo=_G[btnName.."Icon"], spbt=true}
	end

end

function aObj:MailFrame()
	if not self.db.profile.MailFrame or self.initialized.MailFrame then return end
	self.initialized.MailFrame = true

	self:add2Table(self.uiKeys1, "MailFrame")

	self:skinTabs{obj=MailFrame}
	self:addSkinFrame{obj=MailFrame, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-5}

-->>--	Inbox Frame
	for i = 1, INBOXITEMS_TO_DISPLAY do
		self:keepFontStrings(_G["MailItem"..i])
		btn = _G["MailItem"..i.."Button"]
		if self.modBtnBs then
			btn:DisableDrawLayer("BACKGROUND")
			self:addButtonBorder{obj=btn}
		end
	end
	self:moveObject{obj=InboxTooMuchMail, y=-24} -- move icon down
	self:removeRegions(InboxFrame, {1}) -- background texture
	self:addButtonBorder{obj=InboxPrevPageButton, ofs=-2}
	self:addButtonBorder{obj=InboxNextPageButton, ofs=-2}

-->>--	Send Mail Frame
	self:keepFontStrings(SendMailFrame)
	self:skinScrollBar{obj=SendMailScrollFrame}
	for i = 1, ATTACHMENTS_MAX_SEND do
		btn = _G["SendMailAttachment"..i]
		if not self.modBtnBs then
			self:resizeEmptyTexture(self:getRegion(btn, 1))
		else
			btn:DisableDrawLayer("BACKGROUND")
			self:addButtonBorder{obj=btn}
		end
	end
	self:skinEditBox{obj=SendMailNameEditBox, regs={6}, noWidth=true} -- N.B. region 6 is text
	self:skinEditBox{obj=SendMailSubjectEditBox, regs={6}, noWidth=true} -- N.B. region 6 is text
	self:skinEditBox{obj=SendMailBodyEditBox, noSkin=true}
	local c = self.db.profile.BodyText
	SendMailBodyEditBox:SetTextColor(c.r, c.g, c.b)
	self:skinMoneyFrame{obj=SendMailMoney, moveSEB=true, moveGEB=true, noWidth=true}
	self:removeInset(SendMailMoneyInset)
	SendMailMoneyBg:DisableDrawLayer("BACKGROUND")

-->>--	Open Mail Frame
	self:skinScrollBar{obj=OpenMailScrollFrame}
	OpenMailBodyText:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:addSkinFrame{obj=OpenMailFrame, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-2}
	self:addButtonBorder{obj=OpenMailLetterButton, ibt=true}
	self:addButtonBorder{obj=OpenMailMoneyButton, ibt=true}
	for i = 1, ATTACHMENTS_MAX_RECEIVE do
		btn = _G["OpenMailAttachmentButton"..i]
		self:addButtonBorder{obj=btn, ibt=true}
	end
-->>-- Invoice Frame Text fields
	for _, v in pairs{"ItemLabel", "Purchaser", "BuyMode", "SalePrice", "Deposit", "HouseCut", "AmountReceived", "NotYetSent", "MoneyDelay"} do
		_G["OpenMailInvoice"..v]:SetTextColor(self.BTr, self.BTg, self.BTb)
	end

end

function aObj:MainMenuBar()
	if not self.db.profile.MainMenuBar.skin or self.initialized.MainMenuBar then return end
	self.initialized.MainMenuBar = true

	self:add2Table(self.uiKeys2, "MainMenuBar")

	if self.db.profile.MainMenuBar.glazesb then
		self:glazeStatusBar(MainMenuExpBar, 0, self:getRegion(MainMenuExpBar, 5), {ExhaustionLevelFillBar})
		ExhaustionLevelFillBar:SetAlpha(0.75) -- increase alpha value to make it more visible
		self:glazeStatusBar(ReputationWatchStatusBar, 0, ReputationWatchStatusBarBackground)
	end

	if IsAddOnLoaded("Dominos") then return end

	ExhaustionTick:SetAlpha(0)
	self:adjHeight{obj=MainMenuExpBar, adj=-2} -- shrink it so it moves up
	self:adjHeight{obj=ExhaustionLevelFillBar, adj=-1} -- mirror the XP bar
	local yOfs = IsAddOnLoaded("DragonCore") and -47 or -4
	self:keepRegions(MainMenuExpBar, {1, 5, 6}) -- N.B. region 1 is rested XP, 5 is background, 6 is the normal XP
	self:addSkinFrame{obj=MainMenuBar, ft=ftype, noBdr=true, x1=-4, y1=-5, x2=4, y2=yOfs}
	self:keepFontStrings(MainMenuBarMaxLevelBar)
	self:keepFontStrings(MainMenuBarArtFrame)
	self:keepRegions(ReputationWatchStatusBar, {9, 10}) -- 9 is background, 10 is the normal texture

	-- StanceBar Frame
	self:keepFontStrings(StanceBarFrame)
	for i = 1, NUM_STANCE_SLOTS do
		self:addButtonBorder{obj=_G["StanceButton"..i], abt=true, sec=true}
	end
	-- Possess Bar Frame
	self:keepFontStrings(PossessBarFrame)
	for i = 1, NUM_POSSESS_SLOTS do
		self:addButtonBorder{obj=_G["PossessButton"..i], abt=true, sec=true}
	end
	-- Pet Action Bar Frame
	self:keepFontStrings(PetActionBarFrame)
	for i = 1, NUM_PET_ACTION_SLOTS do
		btn = "PetActionButton"..i
		self:addButtonBorder{obj=_G[btn], abt=true, sec=true, reParent={_G[btn.."AutoCastable"]}, ofs=3}
	end
	-- Shaman's Totem Frame
	self:keepFontStrings(MultiCastFlyoutFrame)

-->>-- Action Buttons
	for i = 1, NUM_ACTIONBAR_BUTTONS do
		btnName = "ActionButton"..i
		btn = _G[btnName]
		_G[btnName.."Border"]:SetAlpha(0) -- texture changed in blizzard code
		-- _G[btnName.."Border"].Show = _G[btnName.."Border"].Hide
		btn.SetNormalTexture = function() end
		self:addButtonBorder{obj=btn, abt=true, sec=true}
	end

-->>-- MultiBar Buttons
	for _, v in pairs{"BottomLeft", "BottomRight", "Right", "Left"} do
		for i = 1, NUM_MULTIBAR_BUTTONS do
			btnName = "MultiBar"..v.."Button"..i
			btn = _G[btnName]
			_G[btnName.."Border"]:SetAlpha(0) -- texture changed in blizzard code
			-- _G[btnName.."Border"].Show = _G[btnName.."Border"].Hide
			btn.SetNormalTexture = function() end
			self:addButtonBorder{obj=btn, abt=true, sec=true}
		end
	end

-->>-- add button borders if required
	if self.modBtnBs then
		-- Micro buttons
		mBtns = {"Character", "Spellbook", "Talent", "Achievement", "QuestLog", "Guild", "PVP", "LFD", "EJ", "MainMenu", "Help"}
		self:add2Table(mBtns, "Companions")
		for _, v in pairs(mBtns) do
			self:addButtonBorder{obj=_G[v.."MicroButton"], mb=true, ofs=0, y1=-21}
		end
		self:addButtonBorder{obj=FriendsMicroButton, x1=1, y1=1, x2=-2, y2=-1}-- on ChatFrame
		-- Bag buttons
		self:addButtonBorder{obj=MainMenuBarBackpackButton}
		self:addButtonBorder{obj=CharacterBag0Slot}
		self:addButtonBorder{obj=CharacterBag1Slot}
		self:addButtonBorder{obj=CharacterBag2Slot}
		self:addButtonBorder{obj=CharacterBag3Slot}
		for i = 1, NUM_POSSESS_SLOTS do
			btn = _G["PossessButton"..i]
			self:addButtonBorder{obj=btn, abt=true, sec=true}
		end
		for i = 1, NUM_STANCE_SLOTS do
			btn = _G["StanceButton"..i]
			self:addButtonBorder{obj=btn, abt=true, sec=true}
		end
		self:addButtonBorder{obj=MultiCastSummonSpellButton, abt=true, sec=true, ofs=5}
		self:addButtonBorder{obj=MultiCastRecallSpellButton, abt=true, sec=true, ofs=5}
		for i = 1, NUM_MULTI_CAST_PAGES * NUM_MULTI_CAST_BUTTONS_PER_PAGE do
			self:addButtonBorder{obj=_G["MultiCastActionButton"..i], abt=true, sec=true, ofs=5}
		end
		-- ActionBar buttons
		self:addButtonBorder{obj=ActionBarUpButton, ofs=-5, x1=4}
		self:addButtonBorder{obj=ActionBarDownButton, ofs=-5, x1=4}
	end
-->>-- Vehicle Leave Button
	self:addSkinButton{obj=MainMenuBarVehicleLeaveButton}
	self:SecureHook("MainMenuBarVehicleLeaveButton_Update", function()
		self:moveObject{obj=MainMenuBarVehicleLeaveButton, y=3}
	end)

-->>-- TalentMicroButtonAlert frame
	self:skinButton{obj=TalentMicroButtonAlert.CloseButton, cb=true}
-->>-- CompanionsMicroButtonAlert frame
	self:skinButton{obj=CompanionsMicroButtonAlert.CloseButton, cb=true}

-->>-- Extra Action Button
	self:addButtonBorder{obj=ExtraActionButton1, relTo=ExtraActionButton1.icon}
	ExtraActionButton1.style:SetTexture(nil)
	ExtraActionButton1.style.SetTexture = function() end
-->>-- UnitPowerBarAlt (inc. PlayerPowerBarAlt)
	local function skinUnitPowerBarAlt(bar)
		bar.frame:SetTexture(nil)
		bar.frame:Hide()
		-- Don't change the status bar texture as it changes dependant upon type of power type required
	end
	self:SecureHook("UnitPowerBarAlt_SetUp", function(this, barID)
		skinUnitPowerBarAlt(this)
	end)
	-- skin PlayerPowerBarAlt if already shown
	if PlayerPowerBarAlt:IsVisible() then
		skinUnitPowerBarAlt(PlayerPowerBarAlt)
	end

end

function aObj:MenuFrames()
	if not self.db.profile.MenuFrames or self.initialized.MenuFrames then return end
	self.initialized.MenuFrames = true

	self:add2Table(self.uiKeys1, "MenuFrames")

-->>-- Game Menu Frame
	self:addSkinFrame{obj=GameMenuFrame, ft=ftype, kfs=true, hdr=true}

-->>-- Options
	self:addSkinFrame{obj=VideoOptionsFrame, ft=ftype, kfs=true, hdr=true}
	self:addSkinFrame{obj=VideoOptionsFrameCategoryFrame, ft=ftype, kfs=true}
	self:skinSlider(VideoOptionsFrameCategoryFrameListScrollBar)
	self:addSkinFrame{obj=VideoOptionsFramePanelContainer, ft=ftype}
	-- Graphics
	for _, child in ipairs{Graphics_:GetChildren()} do
		if child:GetName():find("DropDown") then
			self:skinDropDown{obj=child}
		end
	end
	-- Advanced
	for _, child in ipairs{Advanced_:GetChildren()} do
		if child:GetName():find("DropDown") then
			self:skinDropDown{obj=child}
		end
	end
	-- Languages
		self:skinDropDown{obj=InterfaceOptionsLanguagesPanelLocaleDropDown}
	-- Sound
	self:addSkinFrame{obj=AudioOptionsSoundPanel, ft=ftype}
	self:addSkinFrame{obj=AudioOptionsSoundPanelPlayback, ft=ftype}
	self:skinDropDown{obj=AudioOptionsSoundPanelHardwareDropDown}
	self:skinDropDown{obj=AudioOptionsSoundPanelSoundChannelsDropDown}
	self:addSkinFrame{obj=AudioOptionsSoundPanelHardware, ft=ftype}
	self:addSkinFrame{obj=AudioOptionsSoundPanelVolume, ft=ftype}
	-- Voice
	self:addSkinFrame{obj=AudioOptionsVoicePanel, ft=ftype}
	self:addSkinFrame{obj=AudioOptionsVoicePanelTalking, ft=ftype}
	self:skinDropDown{obj=AudioOptionsVoicePanelInputDeviceDropDown}
	self:skinButton{obj=RecordLoopbackSoundButton, x1=-2, x2=2}
	self:skinButton{obj=PlayLoopbackSoundButton, x1=-2, x2=2}
	self:addSkinFrame{obj=LoopbackVUMeter:GetParent(), ft=ftype, aso={ng=true}, nb=true}
	self:glazeStatusBar(LoopbackVUMeter) -- no background required
	self:addSkinFrame{obj=AudioOptionsVoicePanelBinding, ft=ftype}
	self:skinDropDown{obj=AudioOptionsVoicePanelChatModeDropDown}
	self:addSkinFrame{obj=AudioOptionsVoicePanelListening, ft=ftype}
	self:skinDropDown{obj=AudioOptionsVoicePanelOutputDeviceDropDown}
	self:addSkinFrame{obj=VoiceChatTalkers, ft=ftype}

-->>-- Mac Options
	if IsMacClient() then
		self:addSkinFrame{obj=MacOptionsFrame, ft=ftype, kfs=true, hdr=true}
		self:addSkinFrame{obj=MacOptionsFrameMovieRecording, ft=ftype, y1=-2}
		self:skinDropDown{obj=MacOptionsFrameResolutionDropDown}
		self:skinDropDown{obj=MacOptionsFrameFramerateDropDown}
		self:skinDropDown{obj=MacOptionsFrameCodecDropDown}
		-- popup frames
		self:addSkinFrame{obj=MacOptionsITunesRemote, ft=ftype, y1=-2}
		self:addSkinFrame{obj=MacOptionsCompressFrame, ft=ftype, kfs=true, hdr=true}
		self:addSkinFrame{obj=MacOptionsCancelFrame, ft=ftype, kfs=true, hdr=true}
		self:addSkinFrame{obj=FolderPicker, ft=ftype, kfs=true, hdr=true}
	end

-->>-- Interface
	self:skinTabs{obj=InterfaceOptionsFrame, up=true, lod=true, x1=6, y1=2, x2=-6, y2=-4}
	self:addSkinFrame{obj=InterfaceOptionsFrame, ft=ftype, kfs=true, hdr=true}
	InterfaceOptionsFrameCategoriesList:SetBackdrop(nil)
	self:skinScrollBar{obj=InterfaceOptionsFrameCategoriesList, size=2}
	self:addSkinFrame{obj=InterfaceOptionsFrameCategories, ft=ftype, kfs=true}
	InterfaceOptionsFrameAddOnsList:SetBackdrop(nil)
	self:skinScrollBar{obj=InterfaceOptionsFrameAddOnsList, size=2}
	self:addSkinFrame{obj=InterfaceOptionsFrameAddOns, ft=ftype, kfs=true, bgen=1}
	self:addSkinFrame{obj=InterfaceOptionsFramePanelContainer, ft=ftype, bgen=1}
	-- skin toggle buttons
	for i = 1, #InterfaceOptionsFrameAddOns.buttons do
		self:skinButton{obj=InterfaceOptionsFrameAddOns.buttons[i].toggle, mp2=true}
	end

-->>-- Rating Menu
	self:addSkinFrame{obj=RatingMenuFrame, ft=ftype, hdr=true}

	local oName
	local function checkKids(obj)

		oName = obj.GetName and obj:GetName() or nil
		  -- ignore named/AceConfig/XConfig/AceGUI objects
		if oName
		and (oName:find("AceConfig")
		or oName:find("XConfig")
		or oName:find("AceGUI"))
		or aObj.ignoreIOF[obj] -- ignore object if required
		then
			return
		end

		for _, child in ipairs{obj:GetChildren()} do
			-- aObj:Debug("checkKids: [%s, %s, %s]", child:GetName(), child:GetObjectType(), child:GetNumRegions())
			if not aObj.skinFrame[child] then
				if aObj:isDropDown(child)
				and not aObj.ignoreIOF[child]
				then
					local xOfs
					if child:GetName():find("PowaDropDownDefaultTimer") then
						xOfs = -90
					elseif child:GetName():find("PowaDropDownDefaultStacks") then
						xOfs = -110
					elseif child:GetName():find("oGlowOptFQualityThreshold") then
						xOfs = 110
					end
					aObj:skinDropDown{obj=child, x2=xOfs}
				elseif child:IsObjectType("EditBox")
				and not aObj.ignoreIOF[child]
				then
					aObj:skinEditBox{obj=child, regs={9}}
				elseif child:IsObjectType("ScrollFrame")
				and child:GetName()
				and child:GetName().."ScrollBar" -- handle named ScrollBar's
				then
					aObj:skinScrollBar{obj=child}
				else
					checkKids(child)
				end
				-- remove Ampere's container background
				if child:GetParent().name
				and child:GetParent().name == "Ampere"
				and child:GetNumRegions() == 1
				then
					child:DisableDrawLayer("BACKGROUND")
				end
			end
		end

	end
	-- hook this to skin Interface Option panels and their elements
	self:SecureHook("InterfaceOptionsList_DisplayPanel", function(panel)
		-- skin tekKonfig library objects here as well as in AddonFrames to handle late loading of libraries
		if self.tekKonfig then self:checkAndRun("tekKonfig") end
		-- run Addon Loader skin code here
		if panel.name == "Addon Loader"
		and self.AddonLoader
		then
			self:checkAndRun("AddonLoader")
		end
		-- self:Debug("IOL_DP: [%s, %s, %s, %s]", panel, panel.name, panel:GetNumChildren(), self.skinFrame[panel])
		if panel
		and panel.GetNumChildren
		and not self.skinFrame[panel]
		then
			self:addSkinFrame{obj=panel, ft=ftype, kfs=true, nb=true}
			self:ScheduleTimer(checkKids, 0.1, panel) -- wait for 1/10th second for panel to be populated
			self:ScheduleTimer("skinAllButtons", 0.1, {obj=panel, as=true}) -- wait for 1/10th second for panel to be populated, always use applySkin to ensure text appears above button texture
		end
	end)

end

function aObj:Minimap()
	if not self.db.profile.Minimap.skin or self.initialized.Minimap then return end
	self.initialized.Minimap = true

	self:add2Table(self.uiKeys2, "Minimap")

-->>-- Cluster Frame
	MinimapBorderTop:Hide()
	MinimapZoneTextButton:ClearAllPoints()
	MinimapZoneTextButton:SetPoint("BOTTOMLEFT", Minimap, "TOPLEFT", 0, 5)
	MinimapZoneTextButton:SetPoint("BOTTOMRIGHT", Minimap, "TOPRIGHT", 0, 5)
	MinimapZoneText:ClearAllPoints()
	MinimapZoneText:SetPoint("CENTER")
	self:addSkinButton{obj=MinimapZoneTextButton, parent=MinimapZoneTextButton}
	-- World Map Button
	MiniMapWorldMapButton:ClearAllPoints()
	MiniMapWorldMapButton:SetPoint("LEFT", MinimapZoneTextButton, "RIGHT", -4, 0)
	self:skinButton{obj=MiniMapWorldMapButton, ob="M"}

-->>-- Minimap
	Minimap:SetMaskTexture([[Interface\Buttons\WHITE8X8]]) -- needs to be a square texture
	-- use a backdrop with no Texture otherwise the map tiles are obscured
	self.minimapskin = self:addSkinFrame{obj=Minimap, ft=ftype, aso={bd=8}, ofs=5}
	if self.db.profile.Minimap.gloss then
		RaiseFrameLevel(self.minimapskin)
	else
		LowerFrameLevel(self.minimapskin)
	end

-->>-- Minimap Backdrop Frame
	MinimapBorder:SetAlpha(0)
	MinimapNorthTag:SetAlpha(0)
	MinimapCompassTexture:SetAlpha(0)

-->>-- Buttons
	-- on LHS
	local xOfs, yOfs = 6, 4
	for _, v in pairs{MiniMapTracking, MiniMapLFGFrame, MiniMapRecordingButton, MiniMapVoiceChatFrame} do
		v:ClearAllPoints()
		v:SetPoint("TOPRIGHT", Minimap, "TOPLEFT", xOfs, yOfs)
		yOfs = yOfs - v:GetHeight() + 3
	end
	self:moveObject{obj=MiniMapInstanceDifficulty, x=-10}
	self:moveObject{obj=GuildInstanceDifficulty, x=-10}
	self:moveObject{obj=MiniMapChallengeMode, x=-16, y=0}
	-- on RHS
	MiniMapMailFrame:ClearAllPoints()
	MiniMapMailFrame:SetPoint("LEFT", Minimap, "RIGHT", -10, 28)
	MinimapZoomIn:ClearAllPoints()
	MinimapZoomIn:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMRIGHT", -4, -3)
	MinimapZoomOut:ClearAllPoints()
	MinimapZoomOut:SetPoint("TOPRIGHT", Minimap, "BOTTOMRIGHT", 3, 4)

	-- move BuffFrame
	self:moveObject{obj=BuffFrame, x=-40}

end

function aObj:MinimapButtons()
	if not self.db.profile.MinimapButtons.skin or self.initialized.MinimapButtons then return end
	self.initialized.MinimapButtons = true

	self:add2Table(self.uiKeys2, "MinimapButtons")

	local minBtn = self.db.profile.MinimapButtons.style
	local objName, objType, tex, texName

	local function mmKids(mmObj)

		local objName, objType, tex, texName
		for _, obj in ipairs{mmObj:GetChildren()} do
			objName = obj:GetName()
			objType = obj:GetObjectType()
			if not aObj.sBtn[obj]
			and not aObj.skinFrame[obj]
			and objType == "Button"
			or (objType == "Frame" and objName == "MiniMapMailFrame")
			then
				for _, reg in ipairs{obj:GetRegions()} do
					if reg:GetObjectType() == "Texture" then
						texName = reg:GetName()
						tex = reg:GetTexture()
						-- change the DrawLayer to make the Icon show if required
						if (texName and texName:find("[Ii]con"))
						or (tex and tex:find("[Ii]con"))
						then
							if reg:GetDrawLayer() == "BACKGROUND" then reg:SetDrawLayer("ARTWORK") end
							-- centre the icon
							reg:ClearAllPoints()
							reg:SetPoint("CENTER")
						elseif (texName and texName:find("Border"))
						or (tex and tex:find("TrackingBorder"))
						then
							reg:SetTexture(nil)
							obj:SetWidth(32)
							obj:SetHeight(32)
							if not minBtn then
								if objType == "Button" then
									aObj:addSkinButton{obj=obj, parent=obj, sap=true, rp=obj==QueueStatusMinimapButton and true or nil} -- reparent to ensure Eye is visible
								else
									aObj:addSkinFrame{obj=obj, ft=ftype}
								end
							end
						elseif (tex and tex:find("Background")) then
							reg:SetTexture(nil)
						end
					end
				end
			elseif objName and objType == "Frame" then
				mmKids(obj)
			end
		end

	end

	-- skin Minimap children, allow for delayed addons to be loaded (e.g. Baggins)
	self:ScheduleTimer(mmKids, 0.5, Minimap)

	-- skin other Blizzard buttons
	asopts = {ba=minBtn and 0 or 1, bba=minBtn and 0 or 1, ng=minBtn and true or nil}
	-- Calendar button
	obj = GameTimeFrame
	obj:SetWidth(26)
	obj:SetHeight(26)
	obj:GetNormalTexture():SetTexCoord(0.1, 0.31, 0.16, 0.6)
	obj:GetPushedTexture():SetTexCoord(0.6, 0.81, 0.16, 0.6)
	self:addSkinFrame{obj=obj, aso=asopts, x1=-4, y1=4, x2=4, y2=-4}
	-- make sure textures appear above skinFrame
	LowerFrameLevel(self.skinFrame[obj])

	-- MinimapZoomIn/Out buttons
	for k, obj in pairs{MinimapZoomIn, MinimapZoomOut} do
		obj:GetNormalTexture():SetTexture(nil)
		obj:GetPushedTexture():SetTexture(nil)
		if minBtn then
			obj:GetDisabledTexture():SetTexture([[Interface\Minimap\UI-Minimap-Background]])
		else
			obj:GetDisabledTexture():SetTexture(nil)
		end
		self:adjWidth{obj=obj, adj=-8}
		self:adjHeight{obj=obj, adj=-8}
		self:addSkinButton{obj=obj, parent=obj, aso=asopts}
		btn = self.sBtn[obj]
		btn:SetAllPoints(obj:GetNormalTexture())
		btn:SetNormalFontObject(self.modUIBtns.fontX)
		btn:SetDisabledFontObject(self.modUIBtns.fontDX)
		btn:SetPushedTextOffset(1, 1)
		btn:SetText(k == 1 and self.modUIBtns.plus or self.modUIBtns.minus)
		if not obj:IsEnabled() then btn:Disable() end
	end
	-- change Mail icon
	MiniMapMailIcon:SetTexture([[Interface\Minimap\Tracking\Mailbox.blp]])
	-- resize other buttons
	MiniMapMailFrame:SetWidth(28)
	MiniMapMailFrame:SetHeight(28)
	MiniMapVoiceChatFrame:SetWidth(32)
	MiniMapVoiceChatFrame:SetHeight(32)
	MiniMapVoiceChatFrameIcon:ClearAllPoints()
	MiniMapVoiceChatFrameIcon:SetPoint("CENTER")
	-- MiniMap Tracking
	MiniMapTrackingBackground:SetTexture(nil)
	MiniMapTrackingIcon:SetParent(MiniMapTrackingButton)
	MiniMapTrackingIcon:ClearAllPoints()
	MiniMapTrackingIcon:SetPoint("CENTER", MiniMapTrackingButton)
	-- change this to stop the icon being moved
	MiniMapTrackingIcon.SetPoint = function() end
	if not minBtn then
		self:addSkinFrame{obj=MiniMapTracking, ft=ftype}
	end
	-- Instance Difficulty
	MiniMapInstanceDifficultyTexture:SetTexCoord(0.0, 0.25, 0.135, 0.5) -- remove top hanger texture
	self:moveObject{obj=MiniMapInstanceDifficulty, y=-5}
	-- Guild Instance Difficulty
	GuildInstanceDifficultyHanger:SetAlpha(0)

	-- skin any moved Minimap buttons if required
	if IsAddOnLoaded("MinimapButtonFrame") then mmKids(MinimapButtonFrame) end

	-- show the Bongos minimap icon if required
	if IsAddOnLoaded("Bongos") then Bongos3MinimapButton.icon:SetDrawLayer("ARTWORK") end

	-- skin other minimap buttons as required
	if not minBtn then
		local mmButs = {
			["SmartBuff"] = SmartBuff_MiniMapButton,
			["WebDKP"] = WebDKP_MinimapButton,
			["GuildAds"] = GuildAdsMinimapButton,
			["Outfitter"] = OutfitterMinimapButton,
			["Perl_Config"] = PerlButton,
			["WIM"] = WIM3MinimapButton,
			["FlightMapEnhanced"] = FlightMapEnhancedMinimapButton,
		}
		for addon, obj in pairs(mmButs) do
			if IsAddOnLoaded(addon) then
				self:addSkinButton{obj=obj, parent=obj, sap=true}
			end
		end
		mmButs = nil
	end

end

function aObj:ModelFrames()
	if not self.db.profile.CharacterFrames then return end
--[[
[12:55:21] <dreyruugr> http://ace.pastey.net/551
[12:55:42] <dreyruugr> That should do framerate independant rotation of the model, based on how much the mouse moves
[13:12:43] <dreyruugr> Gngsk: http://ace.pastey.net/552 - This doesn't work quite right, but if you work on it you'll be able to zoom in on the character's face using the y offset of the mouse

This does the trick, but it might be worth stealing chester's code from SuperInspect

]]
	self:add2Table(self.uiKeys1, "ModelFrames")

	-- these are hooked to suppress the sound the normal functions use
	self:SecureHook("Model_RotateLeft", function(model, rotationIncrement)
		if not rotationIncrement then
			rotationIncrement = 0.03
		end
		model.rotation = model.rotation - rotationIncrement
		model:SetRotation(model.rotation)
	end)
	self:SecureHook("Model_RotateRight", function(model, rotationIncrement)
		if not rotationIncrement then
			rotationIncrement = 0.03
		end
		model.rotation = model.rotation + rotationIncrement
		model:SetRotation(model.rotation)
	end)

end

function aObj:MovePad() -- LoD
	if not self.db.profile.MovePad or self.initialized.MovePad then return end
	self.initialized.MovePad = true

	self:skinButton{obj=MovePadForward}
	self:skinButton{obj=MovePadJump}
	self:skinButton{obj=MovePadBackward}
	self:skinButton{obj=MovePadStrafeLeft}
	self:skinButton{obj=MovePadStrafeRight}
	self:addSkinButton{obj=MovePadLock, as=true, ofs=-4}
	self:addSkinFrame{obj=MovePadFrame, ft=ftype}
	self:addButtonBorder{obj=MovePadJump, ofs=0}

end

if IsMacClient() then
	function aObj:MovieProgress()
		if not self.db.profile.MovieProgress or self.initialized.MovieProgress then return end
		self.initialized.MovieProgress = true

		self:add2Table(self.uiKeys1, "MovieProgress")

		self:getChild(MovieProgressBar, 1):SetBackdrop(nil)
		self:removeRegions(MovieProgressFrame)
		self:glazeStatusBar(MovieProgressBar, 0, self:getRegion(MovieProgressBar, 1))
		self:addSkinFrame{obj=MovieProgressFrame, ft=ftype, x1=-6, y1=6, x2=6, y2=-6}

	end
end

-- disabled, changed in MoP and I can't get it to work properly yet (03.09.12)
function aObj:Nameplates()
	if not self.db.profile.Nameplates or self.initialized.Nameplates then return end
	self.initialized.Nameplates = true

	self:add2Table(self.uiKeys1, "Nameplates")

	local pairs, select = pairs, select
	local GetCVarBool, UnitName, InCombatLockdown = GetCVarBool, UnitName, InCombatLockdown
	local cs = aObj.changeShield

	local sb1, sb2, rg2 ,rg3, rg4
	local r, g, b, a = unpack(self.sbColour)
	local function skinPlate(obj)

		rg2, rg3 = select(2, obj:GetRegions()) -- border & highlight
		rg2:SetTexture(nil)
		rg3:SetTexture(nil)
		-- skin both status bars
		sb1, sb2 = select(1, obj:GetChildren())

		sb1:SetStatusBarTexture(aObj.sbTexture)
		sb1.bg = sb1.bg or sb1:CreateTexture(nil, "BACKGROUND")
		sb1.bg:SetTexture(aObj.sbTexture)
		sb1.bg:SetVertexColor(r, g, b, a)
		sb2.bg = sb2.bg or sb2:CreateTexture(nil, "BACKGROUND")
		sb2.bg:SetTexture(aObj.sbTexture)
		sb2.bg:SetVertexColor(r, g, b, a)

		-- Casting bar
		rg2 ,rg3, rg4 = select(2, sb2:GetRegions()) -- border, shield, icon
		rg2:SetTexture(nil)
		rg3:SetTexture(aObj.shieldTex)
		rg3:SetTexCoord(0, 1, 0, 1)
		rg3:SetWidth(46)
		rg3:SetHeight(46)
		-- move it behind the icon
		rg3:ClearAllPoints()
		rg3:SetPoint("CENTER", rg4, "CENTER", 9, -1)

	end
	local npEvt
	local function skinNameplates()

		-- rg2, rg3, rg4, sb1, sb2 = nil, nil, nil, nil, nil
		for _, child in pairs{WorldFrame:GetChildren()} do
			if child.GetName
			and child:GetName()
			and child:GetName():find("^NamePlate%d+$")
			then
				-- handle in combat
				-- if InCombatLockdown()
				-- and select(4, child:GetRegions()) == UnitName("target")
				-- then
				-- 	aObj.oocTab[#aObj.oocTab + 1] = {skinPlate, {child}}
				-- else
					skinPlate(child)
				-- end
--[=[
				rg2, rg3 = select(2, child:GetRegions()) -- border & highlight
				rg2:SetTexture(nil)
				rg3:SetTexture(nil)
				-- skin both status bars
				sb1, sb2 = select(1, child:GetChildren())
				if not aObj.sbGlazed[sb1] then gsb(aObj, sb1, 0) end
				if not aObj.sbGlazed[sb2] then gsb(aObj, sb2, 0) end
				-- Casting bar
				rg2 ,rg3, rg4 = select(2, sb2:GetRegions()) -- border, shield, icon
				rg2:SetTexture(nil)
				rg3:SetTexture(nil)
				-- cs(aObj, rg3, rg4)
--]=]
			end
		end

		-- if the nameplates are off then disable the skinning code
		if not GetCVarBool("nameplateShowEnemies")
		and not GetCVarBool("nameplateShowFriends")
		then
			aObj:CancelTimer(npEvt, true)
			npEvt = nil
		end

	end

	local function showFunc()

		if not npEvt then
			npEvt = aObj:ScheduleRepeatingTimer(skinNameplates, 0.2)
		end

	end

	self:SecureHook("SetCVar", function(varName, varValue, ...)
		if varName:find("nameplateShow") and varValue == 1 then showFunc() end
	end)

	if GetCVarBool("nameplateShowEnemies")
	or GetCVarBool("nameplateShowFriends")
	then
		showFunc()
	end

end

aObj.pbtt = {}
function aObj:PetBattleUI()
	if not self.db.profile.PetBattleUI or self.initialized.PetBattleUI then return end
	self.initialized.PetBattleUI = true

	self:add2Table(self.uiKeys1, "PetBattleUI")

	local dpt = [[Interface\PetBattles\DeadPetIcon]]

	-- Top Frame
	PetBattleFrame.TopArtLeft:SetTexture(nil)
	PetBattleFrame.TopArtRight:SetTexture(nil)
	PetBattleFrame.TopVersus:SetTexture(nil)
	-- Active Allies/Enemies
	for _, v in pairs{"Ally", "Enemy"} do
		obj = PetBattleFrame["Active"..v]
		self:addButtonBorder{obj=obj, relTo=obj.Icon, ofs=1, reParent={obj.LevelUnderlay, obj.Level, obj.SpeedUnderlay, obj.SpeedIcon}}
		obj.Border:SetTexture(nil)
		obj.Border2:SetTexture(nil)
		self:changeTandC(obj.LevelUnderlay, self.lvlBG)
		self:changeTandC(obj.SpeedUnderlay, self.lvlBG)
		self:changeTandC(obj.HealthBarBG, self.sbTexture)
		obj.HealthBarBG:SetVertexColor(0.2, 0.2, 0.2, 0.8) -- black
		self:adjWidth{obj=obj.HealthBarBG, adj=-10}
		self:adjHeight{obj=obj.HealthBarBG, adj=-10}
		self:changeTandC(obj.ActualHealthBar, self.sbTexture)
		obj.ActualHealthBar:SetVertexColor(0, 1, 0) -- green
		self:moveObject{obj=obj.ActualHealthBar, x= v == "Ally" and -5 or 5}
		obj.HealthBarFrame:SetTexture(nil)
		-- add a background frame
		local sfn = v == "Ally" and "lsf" or "rsf"
		PetBattleFrame[sfn] = CreateFrame("Frame", nil, PetBattleFrame)
		self:applySkin{obj=PetBattleFrame[sfn], bba=0, fh=45}
		if v == "Ally" then
			PetBattleFrame.lsf:SetPoint("TOPLEFT", PetBattleFrame, "TOPLEFT", 380, 4)
		else
			PetBattleFrame.rsf:SetPoint("TOPRIGHT", PetBattleFrame, "TOPRIGHT", -380, 4)
		end
		PetBattleFrame[sfn]:SetWidth(360)
		PetBattleFrame[sfn]:SetHeight(94)
		PetBattleFrame[sfn]:SetFrameStrata("BACKGROUND")
		-- Ally2/3, Enemy2/3
		for i = 2, 3 do
			btn = PetBattleFrame[v..i]
			self:addButtonBorder{obj=btn, relTo=btn.Icon, reParent={btn.ActualHealthBar}}
			btn.ActualHealthBar:SetTexture(self.sbTexture)
			btn.BorderAlive:SetTexture(nil)
			self:changeTandC(btn.BorderDead, dpt)
			btn.HealthDivider:SetTexture(nil)
			if v == "Enemy" then
				btn.healthBarWidth = 35
				btn.ActualHealthBar:SetWidth(35)
				self:moveObject{obj=btn.ActualHealthBar, x=1}
			end
		end
	end
	-- create a frame behind the VS text
	PetBattleFrame.msf = CreateFrame("Frame", nil, PetBattleFrame)
	self:applySkin{obj=PetBattleFrame.msf, bba=0}
	PetBattleFrame.msf:SetPoint("TOPLEFT", PetBattleFrame.lsf, "TOPRIGHT", -8, 0)
	PetBattleFrame.msf:SetPoint("TOPRIGHT", PetBattleFrame.rsf, "TOPLEFT", 8, 0)
	PetBattleFrame.msf:SetHeight(45)
	PetBattleFrame.msf:SetFrameStrata("BACKGROUND")

	-- Bottom Frame
	PetBattleFrame.BottomFrame.RightEndCap:SetTexture(nil)
	PetBattleFrame.BottomFrame.LeftEndCap:SetTexture(nil)
	PetBattleFrame.BottomFrame.Background:SetTexture(nil)
	-- Pet Selection
	for i = 1, NUM_BATTLE_PETS_IN_BATTLE do
		local btn = PetBattleFrame.BottomFrame.PetSelectionFrame["Pet"..i]
		btn.Framing:SetTexture(nil)
		self:addButtonBorder{obj=btn, relTo=btn.Icon, reParent={btn.Level}}
		btn.HealthBarBG:SetTexture(self.sbTexture)
		btn.HealthBarBG:SetVertexColor(0.2, 0.2, 0.2, 0.8) -- dark grey
		btn.ActualHealthBar:SetTexture(self.sbTexture)
		btn.HealthDivider:SetTexture(nil)
	end
	self:keepRegions(PetBattleFrame.BottomFrame.xpBar, {1, 5, 6, 13}) -- text and statusbar textures
	self:glazeStatusBar(PetBattleFrame.BottomFrame.xpBar, 0,  nil)
	PetBattleFrame.BottomFrame.TurnTimer.TimerBG:SetTexture(nil)
	PetBattleFrame.BottomFrame.TurnTimer.Bar:SetTexture(self.sbTexture)
	PetBattleFrame.BottomFrame.TurnTimer.ArtFrame:SetTexture(nil)
	PetBattleFrame.BottomFrame.TurnTimer.ArtFrame2:SetTexture(nil)
	self:removeRegions(PetBattleFrame.BottomFrame.FlowFrame, {1, 2, 3})
	self:getRegion(PetBattleFrame.BottomFrame.Delimiter, 1):SetTexture(nil)
	self:addButtonBorder{obj=PetBattleFrame.BottomFrame.SwitchPetButton}
	self:addButtonBorder{obj=PetBattleFrame.BottomFrame.CatchButton}
	self:addButtonBorder{obj=PetBattleFrame.BottomFrame.ForfeitButton}
	self:removeRegions(PetBattleFrame.BottomFrame.MicroButtonFrame, {1, 2, 3})
	self:addSkinFrame{obj=PetBattleFrame.BottomFrame, ft=ftype, y1=8}
	-- hook these for pet ability buttons
	self:SecureHook("PetBattleFrame_UpdateActionBarLayout", function(this)
		for i = 1, NUM_BATTLE_PET_ABILITIES do
			btn = this.BottomFrame.abilityButtons[i]
			self:addButtonBorder{obj=btn, reParent={btn.BetterIcon}}
		end
		self:Unhook("PetBattleFrame_UpdateActionBarLayout")
	end)
	self:SecureHook("PetBattleActionButton_UpdateState", function(this)
		if this.sknrBdr then
			if this.Icon
			and this.Icon:IsDesaturated()
			then
				this.sknrBdr:SetBackdropBorderColor(.5, .5, .5)
			else
				this.sknrBdr:SetBackdropBorderColor(unpack(self.bbColour))
			end
		end
	end)

	-- Tooltip frames
	if self.db.profile.Tooltips.skin then
		-- PetBattlePrimaryUnit Tooltip
		obj = PetBattlePrimaryUnitTooltip
		obj:DisableDrawLayer("BACKGROUND")
		obj.ActualHealthBar:SetTexture(self.sbTexture)
		obj.XPBar:SetTexture(self.sbTexture)
		obj.Delimiter:SetTexture(nil)
		self:addButtonBorder{obj=obj, relTo=obj.Icon, ofs=2, reParent={obj.Level}}
		obj.sf = self:addSkinFrame{obj=obj, ft=ftype}
		self:add2Table(self.pbtt, PetBattlePrimaryUnitTooltip.sf)
		-- hook these to stop tooltip gradient being whiteouted !!
		-- N.B. Can't use RawHookScript as it has a bug preventing its use on AnimationGroup Scripts
		-- (Needs to check for IsProtected as a function before calling it)
		local pbfaasf = PetBattleFrame.ActiveAlly.SpeedFlash
		-- self:RawHookScript(pbfaasf, "OnPlay", function(this)
		local pbfaasfop = pbfaasf:HasScript("OnPlay") and pbfaasf:GetScript("OnPlay") or nil
		pbfaasf:SetScript("OnPlay", function(this)
			for _, tooltip in pairs(aObj.pbtt) do
				tooltip.tfade:SetParent(MainMenuBar)
			end
			if pbfaasfop then pbfaasfop(this) end
			-- self.hooks[this].OnPlay(this)
		-- end, true)
		end)
		self:SecureHookScript(pbfaasf, "OnFinished", function(this)
			for _, tooltip in pairs(aObj.pbtt) do
				tooltip.tfade:SetParent(tooltip)
			end
		end)
		local pbfaesf = PetBattleFrame.ActiveEnemy.SpeedFlash
		-- self:RawHookScript(pbfaesf, "OnPlay", function(this)
		local pbfaesfop = pbfaesf:HasScript("OnPlay") and pbfaesf:GetScript("OnPlay") or nil
		pbfaesf:SetScript("OnPlay", function(this)
			for _, tooltip in pairs(aObj.pbtt) do
				tooltip.tfade:SetParent(MainMenuBar)
			end
			if pbfaesfop then pbfaesfop(this) end
			-- self.hooks[this].OnPlay(this)
		-- end, true)
		end)
		self:SecureHookScript(pbfaesf, "OnFinished", function(this)
			for _, tooltip in pairs(aObj.pbtt) do
				tooltip.tfade:SetParent(tooltip)
			end
		end)
		-- hook these to ensure gradient texture is reparented correctly
		self:SecureHookScript(PetBattleFrame, "OnShow", function(this)
			for _, tooltip in pairs(aObj.pbtt) do
				tooltip.tfade:SetParent(MainMenuBar)
				-- reset Gradient alpha
				tooltip.tfade:SetGradientAlpha(self:getGradientInfo())
			end
		end)
		self:SecureHookScript(PetBattleFrame, "OnHide", function(this)
			for _, tooltip in pairs(aObj.pbtt) do
				tooltip.tfade:SetParent(tooltip)
			end
		end)
		-- PetBattlePrimaryAbility Tooltip
		PetBattlePrimaryAbilityTooltip.Delimiter1:SetTexture(nil)
		PetBattlePrimaryAbilityTooltip.Delimiter2:SetTexture(nil)
		self:addSkinFrame{obj=PetBattlePrimaryAbilityTooltip, ft=ftype}
		-- FloatingBattlePet Tooltip
		FloatingBattlePetTooltip.Delimiter:SetTexture(nil)
	end

end

function aObj:PVEFrame()
	if not self.db.profile.PVEFrame or self.initialized.PVEFrame then return end
	self.initialized.PVEFrame = true

	self:add2Table(self.uiKeys1, "PVEFrame")

	self:keepFontStrings(PVEFrame.shadows)
	self:addSkinFrame{obj=PVEFrame, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-5}
	self:skinTabs{obj=PVEFrame}

	-- GroupFinder Frame
	for i = 1, 3 do
		btn = GroupFinderFrame["groupButton"..i]
		btn.bg:SetTexture(nil)
		btn.ring:SetTexture(nil)
		tex = btn:GetHighlightTexture()
		tex:SetTexture([[Interface\HelpFrame\HelpButtons]])
		tex:SetTexCoord(0.00390625, 0.78125000, 0.00390625, 0.21484375)
	end
	-- hook this to change selected texture
	self:SecureHook("GroupFinderFrame_SelectGroupButton", function(index)
		for i = 1, 3 do
			btn = GroupFinderFrame["groupButton"..i]
			if i == index then
				btn.bg:SetTexture([[Interface\HelpFrame\HelpButtons]])
				btn.bg:SetTexCoord(0.00390625, 0.78125000, 0.66015625, 0.87109375)
			else
				btn.bg:SetTexture(nil)
			end
		end
	end)
	-- ScenarioFinder Frame
	self:keepFontStrings(ScenarioFinderFrame)
	self:removeInset(ScenarioFinderFrame.Inset)

	-- ScenarioQueueFrame
	ScenarioQueueFrame.Bg:SetAlpha(0) -- N.B. texture changed in code
	self:skinDropDown{obj=ScenarioQueueFrame.Dropdown}
	self:skinScrollBar{obj=ScenarioQueueFrame.Random.ScrollFrame}
	self:skinButton{obj=ScenarioQueueFrameSpecificButton1ExpandOrCollapseButton, mp2=true}
	self:moveObject{obj=ScenarioQueueFrameSpecificButton1ExpandOrCollapseButtonHighlight, x=-3} -- move highlight to the left
	self:skinScrollBar{obj=ScenarioQueueFrame.Specific.ScrollFrame}
	self:keepFontStrings(ScenarioQueueFramePartyBackfill)
	self:removeMagicBtnTex(ScenarioQueueFrameFindGroupButton)

end

function aObj:QueueStatusFrame()

	self:addSkinFrame{obj=QueueStatusFrame}

end

function aObj:RaidFrame()
	if not self.db.profile.RaidFrame or self.initialized.RaidFrame then return end
	self.initialized.RaidFrame = true

	self:add2Table(self.uiKeys1, "RaidFrame")

	self:skinTabs{obj=RaidParentFrame, lod=true}
	self:addSkinFrame{obj=RaidParentFrame, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-5}

-->>-- RaidFinder Frame
	self:keepRegions(RaidFinderFrame, {})
	self:removeInset(RaidFinderFrameRoleInset)
	self:removeInset(RaidFinderFrameBottomInset)
	self:addButtonBorder{obj=RaidFinderQueueFrameScrollFrameChildFrameItem1, libt=true}
	RaidFinderQueueFrameScrollFrameChildFrameItem1NameFrame:SetTexture(nil)
	self:removeMagicBtnTex(RaidFinderFrameFindRaidButton)
	self:keepRegions(RaidFinderQueueFrame, {})
	self:skinDropDown{obj=RaidFinderQueueFrameSelectionDropDown}
	self:skinScrollBar{obj=RaidFinderQueueFrameScrollFrame}

end

function aObj:ScriptErrors()
	if not self.db.profile.ScriptErrors or self.initialized.ScriptErrors then return end
	self.initialized.ScriptErrors = true

	self:add2Table(self.uiKeys1, "ScriptErrors")

	-- skin Basic Script Errors Frame (BasicControls.xml)
	self:addSkinFrame{obj=BasicScriptErrors, kfs=true, ft=ftype}

end

function aObj:StaticPopups()
	if not self.db.profile.StaticPopups or self.initialized.StaticPopups then return end
	self.initialized.StaticPopups = true

	self:add2Table(self.uiKeys1, "StaticPopups")

	if self.modBtns then
		-- hook this to handle close button texture changes
		self:SecureHook("StaticPopup_Show", function(...)
			local obj, tex
			for i = 1, STATICPOPUP_NUMDIALOGS do
				obj = _G["StaticPopup"..i.."CloseButton"]
				tex = obj:GetNormalTexture() and obj:GetNormalTexture():GetTexture() or nil
				if tex then
					if tex:find("HideButton") then
						obj:SetText(self.modUIBtns.minus)
					elseif tex:find("MinimizeButton") then
						obj:SetText(self.modUIBtns.mult)
					end
				end
			end
		end)
	end

	for i = 1, STATICPOPUP_NUMDIALOGS do
		objName = "StaticPopup"..i
		obj = _G[objName]
		self:skinEditBox{obj=_G[objName.."EditBox"]}
		self:skinMoneyFrame{obj=_G[objName.."MoneyInputFrame"]}
		_G[objName.."ItemFrameNameFrame"]:SetTexture(nil)
		self:addButtonBorder{obj=_G[objName.."ItemFrame"], ibt=true}
		self:addSkinFrame{obj=obj, ft=ftype, x1=6, y1=-6, x2=-6, y2=6}
		-- prevent FrameLevel from being changed (LibRock does this)
		self.skinFrame[obj].SetFrameLevel = function() end
	end

end

function aObj:TimeManager() -- LoD
	if not self.db.profile.TimeManager or self.initialized.TimeManager then return end
	self.initialized.TimeManager = true

-->>--	Time Manager Frame
	TimeManagerFrameTicker:Hide()
	self:keepFontStrings(TimeManagerStopwatchFrame)
	self:addButtonBorder{obj=TimeManagerStopwatchCheck}
	self:skinDropDown{obj=TimeManagerAlarmHourDropDown, x2=-5}
	self:skinDropDown{obj=TimeManagerAlarmMinuteDropDown, x2=-5}
	self:skinDropDown{obj=TimeManagerAlarmAMPMDropDown, x2=-5}
	self:skinEditBox{obj=TimeManagerAlarmMessageEditBox, regs={9}}
	self:removeRegions(TimeManagerAlarmEnabledButton, {6, 7})
	self:addSkinFrame{obj=TimeManagerFrame, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-2}

-->>--	Time Manager Clock Button
	self:removeRegions(TimeManagerClockButton, {1})
	if not self.db.profile.Minimap.style then
		self:addSkinFrame{obj=TimeManagerClockButton, ft=ftype, x1=10, y1=-3, x2=-5, y2=5}
	end

-->>--	Stopwatch Frame
	self:keepFontStrings(StopwatchTabFrame)
	self:skinButton{obj=StopwatchCloseButton, cb=true, sap=true}
	self:addSkinFrame{obj=StopwatchFrame, ft=ftype, kfs=true, y1=-16, y2=2, nb=true}

end

function aObj:Tooltips()
	if not self.db.profile.Tooltips.skin or self.initialized.Tooltips then return end
	self.initialized.Tooltips = true

	self:add2Table(self.uiKeys2, "Tooltips")

	-- skin Item Ref Tooltip's close button
	self:skinButton{obj=ItemRefCloseButton, cb=true}

	if self.db.profile.Tooltips.style == 3 then
		-- Hook this to deal with GameTooltip FadeHeight issues
		self:SecureHookScript(GameTooltipStatusBar, "OnHide", function(this)
			self:ScheduleTimer("skinTooltip", 0.1, GameTooltip)
		end)
	end

	-- add tooltips to table to set backdrop and hook OnShow method
	for _, tooltip in pairs(self.ttCheck) do
		self:add2Table(self.ttList, tooltip)
	end
	self:add2Table(self.ttList, "SmallTextTooltip")

	-- Hook this to skin the GameTooltip StatusBars
	self:SecureHook("GameTooltip_ShowStatusBar", function(this, ...)
		if GameTooltipStatusBar1 then
			self:removeRegions(GameTooltipStatusBar1, {2})
			if aObj.db.profile.Tooltips.glazesb then
				self:glazeStatusBar(GameTooltipStatusBar1, 0)
			end
		end
		if GameTooltipStatusBar2 then
			self:removeRegions(GameTooltipStatusBar2, {2})
			if aObj.db.profile.Tooltips.glazesb then
				self:glazeStatusBar(GameTooltipStatusBar2, 0)
			end
			self:Unhook("GameTooltip_ShowStatusBar")
		end
	end)

	FloatingBattlePetTooltip.Delimiter:SetTexture(nil)
	self:addSkinFrame{obj=FloatingBattlePetTooltip, ft=ftype}

end

function aObj:Tutorial()
	if not self.db.profile.Tutorial or self.initialized.Tutorial then return end
	self.initialized.Tutorial = true

	self:add2Table(self.uiKeys1, "Tutorial")

	local function resetSF()

		-- use the same frame level & strata as TutorialFrame so it appears above other frames
		self.skinFrame[TutorialFrame]:SetFrameLevel(TutorialFrame:GetFrameLevel())
		self.skinFrame[TutorialFrame]:SetFrameStrata(TutorialFrame:GetFrameStrata())

	end
	TutorialFrame:DisableDrawLayer("BACKGROUND")
	TutorialFrameTop:SetTexture(nil)
	TutorialFrameBottom:SetTexture(nil)
	for i = 1, 30 do
		_G["TutorialFrameLeft"..i]:SetTexture(nil)
		_G["TutorialFrameRight"..i]:SetTexture(nil)
	end
	TutorialTextBorder:SetAlpha(0)
	self:skinScrollBar{obj=TutorialFrameTextScrollFrame}
	-- stop animation before skinning, otherwise textures reappear
	AnimateMouse:Stop()
	AnimateCallout:Stop()
	self:addSkinFrame{obj=TutorialFrame, ft=ftype, anim=true, x1=10, y1=-11, x2=1}
	resetSF()
	-- hook this as the TutorialFrame frame level keeps changing
	self:SecureHookScript(self.skinFrame[TutorialFrame], "OnShow", function(this)
		resetSF()
	end)
	-- hook this to hide the skin frame if required (e.g. arrow keys tutorial)
	self:SecureHook("TutorialFrame_Update", function(...)
		resetSF()
		if TutorialFrameTop:IsShown() then
			self.skinFrame[TutorialFrame]:Show()
		else
			self.skinFrame[TutorialFrame]:Hide()
		end
	end)
	self:addButtonBorder{obj=TutorialFramePrevButton, ofs=-2}
	self:addButtonBorder{obj=TutorialFrameNextButton, ofs=-2}

-->>-- Alert button
	btn = TutorialFrameAlertButton
	btn:GetNormalTexture():SetAlpha(0)
	btn:SetNormalFontObject("ZoneTextFont")
	btn:SetText("?")
	self:moveObject{obj=btn:GetFontString(), x=4}
	self:addSkinButton{obj=btn, parent=btn, x1=30, y1=-1, x2=-25, y2=10}

end

function aObj:WorldMap()
	if not self.db.profile.WorldMap.skin or self.initialized.WorldMap then return end
	self.initialized.WorldMap = true

	self:add2Table(self.uiKeys2, "WorldMap")

	if not IsAddOnLoaded("Mapster")
	and not IsAddOnLoaded("AlleyMap")
	then
		local function sizeUp()

			self.skinFrame[WorldMapFrame]:ClearAllPoints()
			self.skinFrame[WorldMapFrame]:SetPoint("TOPLEFT", WorldMapFrame, "TOPLEFT", 102, 1)
			self.skinFrame[WorldMapFrame]:SetPoint("BOTTOMRIGHT", WorldMapFrame, "BOTTOMRIGHT", -102, 1)

		end
		local function sizeDown()

			x1, y1, x2, y2 = 0, 2, 0, 0
			self.skinFrame[WorldMapFrame]:ClearAllPoints()
			self.skinFrame[WorldMapFrame]:SetPoint("TOPLEFT", WorldMapFrame, "TOPLEFT", x1, y1)
			self.skinFrame[WorldMapFrame]:SetPoint("BOTTOMRIGHT", WorldMapFrame, "BOTTOMRIGHT", x2, y2)

		end
		-- handle size change
		self:SecureHook("WorldMap_ToggleSizeUp", function()
			sizeUp()
		end)
		self:SecureHook("WorldMap_ToggleSizeDown", function()
			sizeDown()
		end)
		self:SecureHook("WorldMapFrame_ToggleWindowSize", function()
			if WORLDMAP_SETTINGS.size == WORLDMAP_WINDOWED_SIZE -- Patch
			then
				sizeDown()
			end
		end)
		-- handle different map addons being loaded or fullscreen required
		if self.db.profile.WorldMap.size == 2 then
			self:addSkinFrame{obj=WorldMapFrame, ft=ftype, kfs=true, y1=1, x2=1}
		elseif not IsAddOnLoaded("MetaMap") and not IsAddOnLoaded("Cartographer_LookNFeel") then
			self:addSkinFrame{obj=WorldMapFrame, ft=ftype, kfs=true}
			if WORLDMAP_SETTINGS.size == WORLDMAP_WINDOWED_SIZE -- Patch
			then
				sizeDown()
			else
				sizeUp()
			end
		end
	end

	-- textures removed as they are shown and alphas are changed
	WorldMapFrameMiniBorderLeft:SetTexture(nil)
	WorldMapFrameMiniBorderRight:SetTexture(nil)

	self:skinDropDown{obj=WorldMapContinentDropDown}
	self:skinDropDown{obj=WorldMapZoneDropDown}
	self:skinDropDown{obj=WorldMapZoneMinimapDropDown}
	self:skinDropDown{obj=WorldMapLevelDropDown}
	self:skinSlider{obj=WorldMapQuestScrollFrame.ScrollBar}
	self:skinSlider{obj=WorldMapQuestDetailScrollFrame.ScrollBar, adj=-6}
	self:skinSlider{obj=WorldMapQuestRewardScrollFrame.ScrollBar, adj=-6}
	self:skinDropDown{obj=WorldMapShowDropDown}

-->>-- Tooltip(s)
	if self.db.profile.Tooltips.skin then
		self:add2Table(self.ttList, "WorldMapTooltip")
		self:add2Table(self.ttList, "WorldMapCompareTooltip1")
		self:add2Table(self.ttList, "WorldMapCompareTooltip2")
		self:add2Table(self.ttList, "WorldMapCompareTooltip3")
	end

end

function aObj:WorldState()
	if not self.db.profile.WorldState or self.initialized.WorldState then return end
	self.initialized.WorldState = true

	self:add2Table(self.uiKeys1, "WorldState")

	self:skinDropDown{obj=ScorePlayerDropDown}
	self:skinScrollBar{obj=WorldStateScoreScrollFrame}
	self:skinTabs{obj=WorldStateScoreFrame}
	self:addSkinFrame{obj=WorldStateScoreFrame, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-5}

end
