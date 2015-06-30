local aName, aObj = ...
local _G = _G
local ftype = "u"

-- Add locals to see if it speeds things up
local ipairs, IsAddOnLoaded, pairs, unpack = _G.ipairs, _G.IsAddOnLoaded, _G.pairs, _G.unpack

do
	-- list of Tooltips to check to see whether we should colour the Tooltip Border or not
	-- use strings as the objects may not exist when we start
	aObj.ttCheck = {"GameTooltip", "ShoppingTooltip1", "ShoppingTooltip2", "ItemRefTooltip", "ItemRefShoppingTooltip1", "ItemRefShoppingTooltip2"}
	-- list of Tooltips used when the Tooltip style is 3
	-- using a metatable to manage tooltips when they are added in different functions
	aObj.ttList = _G.setmetatable({}, {__newindex = function(t, k, v)
		_G.rawset(t, k, v)
		-- get object reference for tooltip, handle either strings or objects being passed
		local tt = _G.type(v) == "string" and _G[v] or v
		-- set the backdrop if required
		if aObj.db.profile.Tooltips.style == 3 then
			tt:SetBackdrop(aObj.Backdrop[1])
		end
		-- hook the OnShow method
		aObj:HookScript(tt, "OnShow", function(this)
			aObj:skinTooltip(this)
			if this == _G.GameTooltip and aObj.db.profile.Tooltips.glazesb then
				-- handle in combat
				if _G.InCombatLockdown() then
					aObj:add2Table(aObj.oocTab, {aObj.glazeStatusBar, {aObj, _G.GameTooltipStatusBar, 0}})
				else
					aObj:glazeStatusBar(_G.GameTooltipStatusBar, 0)
				end
			end
		end)
		aObj:skinTooltip(tt) -- skin here so tooltip initially skinnned when logged on
	end})
	-- Set the Tooltip Border
	aObj.ttBorder = true

end

function aObj:AddonList()
	if not self.db.profile.AddonList or self.initialized.AddonList then return end
	self.initialized.AddonList = true

	self:skinDropDown{obj=_G.AddonCharacterDropDown, x2=110}
	self:skinScrollBar{obj=_G.AddonListScrollFrame}
	self:removeMagicBtnTex(_G.AddonList.CancelButton)
	self:removeMagicBtnTex(_G.AddonList.OkayButton)
	self:removeMagicBtnTex(_G.AddonList.EnableAllButton)
	self:removeMagicBtnTex(_G.AddonList.DisableAllButton)
	self:addSkinFrame{obj=_G.AddonList, ft=ftype, kfs=true, ri=true, ofs=2, x2=1}

end

function aObj:AlertFrames()
	if not self.db.profile.AlertFrames or self.initialized.AlertFrames then return end
	self.initialized.AlertFrames = true

	-- hook this to stop gradient texture whiteout
	self:RawHook("AlertFrame_AnimateIn", function(frame)
		-- aObj:Debug("AlertFrame_AnimateIn: [%s, %s]", frame, frame:GetName())
		frame.sf.tfade:SetParent(_G.MainMenuBar)
		-- reset Gradient alpha
		frame.sf.tfade:SetGradientAlpha(self:getGradientInfo())
		self.hooks.AlertFrame_AnimateIn(frame)
	end, true)

	local function skinAlertFrames(fName)

		local x1, x2, y1, y2, obj, icon = 5, -5, -10, 12
		if fName == "CriteriaAlertFrame" then
			x1, x2, y1, y2 = 38, 10, 4, 2
		end
		for i = 1, _G.MAX_ACHIEVEMENT_ALERTS do
			local obj = _G[fName .. i]
			if obj and not obj.sf then
				_G[fName .. i .. "Background"]:SetTexture(nil)
				_G[fName .. i .. "Background"].SetTexture = function() end
				_G[fName .. i .. "Unlocked"]:SetTextColor(aObj.BTr, aObj.BTg, aObj.BTb)
				if _G[fName .. i .. "OldAchievement"] then _G[fName .. i .. "OldAchievement"]:SetTexture(nil) end
				local icon = _G[fName .. i .. "Icon"]
				icon:DisableDrawLayer("BORDER")
				icon:DisableDrawLayer("OVERLAY")
				aObj:addButtonBorder{obj=icon, relTo=_G[fName .. i .. "IconTexture"]}
				aObj:addSkinFrame{obj=obj, ft=ftype, af=true, afas=true, x1=x1, y1=y1, x2=x2, y2=y2}
			end
		end

	end

	-- Achievement Alert Frames
	if not _G.AchievementAlertFrame1 or _G.AchievementAlertFrame2 then
		self:RawHook("AchievementAlertFrame_GetAlertFrame", function(...)
			local frame = self.hooks.AchievementAlertFrame_GetAlertFrame(...)
			skinAlertFrames("AchievementAlertFrame")
			if _G.AchievementAlertFrame2 then
				self:Unhook("AchievementAlertFrame_GetAlertFrame")
			end
			return frame
		end, true)
	end
	-- skin any existing Achievement Alert Frames
	skinAlertFrames("AchievementAlertFrame")
	-- adjust frame size for guild achievements
	self:SecureHook("AchievementAlertFrame_ShowAlert", function(...)
		for i = 1, _G.MAX_ACHIEVEMENT_ALERTS do
			local obj = _G["AchievementAlertFrame" .. i]
			if obj then
				local y1, y2 = -10, 12
	 				if obj.guildDisplay then
					y1, y2 = -8, 8
				end
				obj.sf:SetPoint("TOPLEFT", obj, "TOPLEFT", 5, y1)
				obj.sf:SetPoint("BOTTOMRIGHT", obj, "BOTTOMRIGHT", 5, y2)
			end
		end
	end)

	-- CriteriaAlert Frames
	if not _G.CriteriaAlertFrame1 or _G.CriteriaAlertFrame2 then
		self:RawHook("CriteriaAlertFrame_GetAlertFrame", function(...)
			local frame = self.hooks.CriteriaAlertFrame_GetAlertFrame(...)
			skinAlertFrames("CriteriaAlertFrame")
			if _G.CriteriaAlertFrame2 then
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
			aObj:addSkinFrame{obj=opts.obj, ft=ftype, af=true, afas=true, ofs=opts.ofs or -7, y1=opts.y1 or nil}
		end

	end

	-- DungeonCompletionAlert Frame
	skinDCSAlertFrame{obj=_G.DungeonCompletionAlertFrame1, regs={2, 3, 4, 5, 6, 10}, ofs=0, y1=-7}
	-- hook dungeon rewards function
	self:SecureHook("DungeonCompletionAlertFrameReward_SetReward", function(frame, ...)
		frame:DisableDrawLayer("OVERLAY")
	end)

	-- ChallengeModeAlert Frame
	skinDCSAlertFrame{obj=_G.ChallengeModeAlertFrame1, regs={1, 3, 7}, reParent={_G.ChallengeModeAlertFrame1.medalIcon}}
	-- hook challenge mode rewards function
	self:SecureHook("ChallengeModeAlertFrameReward_SetReward", function(frame, ...)
		frame:DisableDrawLayer("OVERLAY")
	end)

	-- ScenarioAlert Frame
	skinDCSAlertFrame{obj=_G.ScenarioAlertFrame1, regs={1, 3, 6}}

	-- GuildChallengeAlert Frame
	_G.GuildChallengeAlertFrame:DisableDrawLayer("BACKGROUND")
	_G.GuildChallengeAlertFrame:DisableDrawLayer("BORDER")
	_G.GuildChallengeAlertFrame:DisableDrawLayer("OVERLAY")
	self:ScheduleTimer("addButtonBorder", 0.2, {obj=_G.GuildChallengeAlertFrame, relTo=_G.GuildChallengeAlertFrameEmblemIcon}) -- wait for animation to finish
	self:addSkinFrame{obj=_G.GuildChallengeAlertFrame, ft=ftype, af=true, afas=true}

	local function skinWonAlertFrames(obj)

		-- move Icon draw layer (Garrison Cache icon)
		if obj.Icon
		and obj.Icon:GetDrawLayer() == "BACKGROUND"
		then
			obj.Icon:SetDrawLayer("ARTWORK")
		end
		if not obj.sf then
			obj:DisableDrawLayer("BACKGROUND")
			obj.IconBorder:SetTexture(nil)
			if obj.SpecRing then obj.SpecRing:SetTexture(nil) end -- Loot Won Alert Frame(s)
			aObj:ScheduleTimer("addButtonBorder", 0.2, {obj=obj, relTo=obj.Icon}) -- wait for animation to finish
			aObj:addSkinFrame{obj=obj, ft=ftype, af=true, afas=true, ofs=-10}
		end

	end

	-- LootWonAlert Frame
	self:SecureHook("LootWonAlertFrame_SetUp", function(frame, ...)
		skinWonAlertFrames(frame)
	end)
	for _, frame in pairs(_G.LOOT_WON_ALERT_FRAMES) do
		skinWonAlertFrames(frame)
	end
	-- MoneyWonAlert Frame
	self:SecureHook("MoneyWonAlertFrame_SetUp", function(frame, ...)
		skinWonAlertFrames(frame)
	end)
	for _, frame in pairs(_G.MONEY_WON_ALERT_FRAMES) do
		skinWonAlertFrames(frame)
	end

	local frames = {"DigsiteCompleteToastFrame", "StorePurchaseAlertFrame", "GarrisonBuildingAlertFrame", "GarrisonRandomMissionAlertFrame", "GarrisonMissionAlertFrame", "GarrisonFollowerAlertFrame"}
	self:add2Table(frames, "GarrisonShipFollowerAlertFrame")
	self:add2Table(frames, "GarrisonShipMissionAlertFrame")
	for _, frame in pairs(frames) do
		if _G[frame].Icon
		and _G[frame].Icon:GetDrawLayer() == "BACKGROUND"
		then
			_G[frame].Icon:SetDrawLayer("ARTWORK")
		end
		if _G[frame].Background then
			_G[frame].Background:SetTexture(nil)
		else
			_G[frame]:DisableDrawLayer("BACKGROUND") -- Background toast texture
		end
		if _G[frame].IconBG then
			_G[frame].IconBG:SetTexture(nil)
		elseif _G[frame].Portrait then -- GarrisonShipFollower AlertFrame
 		else
			_G[frame]:DisableDrawLayer("BORDER") -- icon background texture
		end
		self:addSkinFrame{obj=_G[frame], ft=ftype, af=true, afas=true, ofs=-10, y1=frame == "GarrisonFollowerAlertFrame" and -8 or nil, bg=true}
	end

	-- GarrisonFollowerAlert Frame
	_G.GarrisonFollowerAlertFrame:DisableDrawLayer("BORDER")
	_G.GarrisonFollowerAlertFrame.PortraitFrame.PortraitRing:SetTexture(nil)
	_G.GarrisonFollowerAlertFrame.PortraitFrame.LevelBorder:SetTexture(nil)

	-- LootUpgrade Frame
	local function skinLootUpgradeAlertFrame(frame)
		if not frame.sf then
			aObj:getRegion(frame, 1):SetTexture(nil) -- Background toast texture
			aObj:addSkinFrame{obj=frame, ft=ftype, af=true, afas=true, ofs=-10}
			aObj:ScheduleTimer(function(obj) obj.sf.tfade:SetParent(obj.sf) end, 0.15, frame)
		end
	end
	self:SecureHook("LootUpgradeFrame_SetUp", function(frame, ...)
		skinLootUpgradeAlertFrame(frame)
	end)
	for _, frame in pairs(_G.LOOT_UPGRADE_ALERT_FRAMES) do
		skinLootUpgradeAlertFrame(frame)
	end

end

function aObj:AuthChallengeUI()
	if not self.db.profile.AuthChallengeUI or self.initialized.AuthChallengeUI then return end
	self.initialized.AuthChallengeUI = true

	-->> N.B. Currently can't be skinned, as the XML has a ScopedModifier element saying fullLockdown="true"

	-- disable skinning of this frame
	self.db.profile.AuthChallengeUI = false

end

function aObj:AutoComplete()
	if not self.db.profile.AutoComplete or self.initialized.AutoComplete then return end
	self.initialized.AutoComplete = true

	self:addSkinFrame{obj=_G.AutoCompleteBox, kfs=true, ft=ftype}

end

function aObj:BattlefieldMinimap() -- LoD
	if not self.db.profile.BattlefieldMm.skin or self.initialized.BattlefieldMm then return end
	self.initialized.BattlefieldMm = true

-->>--	Minimap Tab
	self:keepRegions(_G.BattlefieldMinimapTab, {4, 5}) -- N.B. region 4 is the Text, 5 is the highlight
	local asopts = self.isTT and {ba=1} or nil
	self:addSkinFrame{obj=_G.BattlefieldMinimapTab, ft=ftype, noBdr=self.isTT, aso=asopts, y1=-7, y2=-7}
	self:moveObject{obj=_G.BattlefieldMinimapTabText, y=-1} -- move text down

	-- use a backdrop with no Texture otherwise the map tiles are obscured
	self:addSkinFrame{obj=_G.BattlefieldMinimap, ft=ftype, aso={bd=8}, x1=-4, y1=4, x2=-1, y2=-1}
	if self.db.profile.BattlefieldMm.gloss then
		_G.RaiseFrameLevel(_G.BattlefieldMinimap.sf)
	else
		_G.LowerFrameLevel(_G.BattlefieldMinimap.sf)
	end
	_G.BattlefieldMinimapCorner:SetTexture(nil)
	_G.BattlefieldMinimapBackground:SetTexture(nil)

	-- change the skinFrame's opacity as required
	self:SecureHook("BattlefieldMinimap_UpdateOpacity", function(opacity)
		local alpha = 1.0 - _G.BattlefieldMinimapOptions.opacity
		alpha = (alpha >= 0.15) and alpha - 0.15 or alpha
		_G.BattlefieldMinimap.sf:SetAlpha(alpha)
	end)

	if IsAddOnLoaded("Capping") then
		if _G.type(self["Capping_ModMap"]) == "function" then self:Capping_ModMap() end
	end

end

function aObj:BindingUI() -- LoD
	if not self.db.profile.MenuFrames or self.initialized.BindingUI then return end
	self.initialized.BindingUI = true

	-- just put a backdrop border around the frames
	self:keepRegions(_G.KeyBindingFrame.categoryList, {})
	_G.KeyBindingFrame.categoryList:SetBackdrop(self.Backdrop[10])
	_G.KeyBindingFrame.categoryList:SetBackdropBorderColor(unpack(self.bbColour))
	_G.KeyBindingFrame.bindingsContainer:SetBackdrop(self.Backdrop[10])
	_G.KeyBindingFrame.bindingsContainer:SetBackdropBorderColor(unpack(self.bbColour))
	self:skinScrollBar{obj=_G.KeyBindingFrame.scrollFrame}
	for i = 1, _G.KEY_BINDINGS_DISPLAYED do
		self:skinButton{obj=_G.KeyBindingFrame.keyBindingRows[i].key1Button}
		self:skinButton{obj=_G.KeyBindingFrame.keyBindingRows[i].key2Button}
	end
	self:addSkinFrame{obj=_G.KeyBindingFrame, ft=ftype, kfs=true, hdr=true}

end

function aObj:BNFrames()
	if not self.db.profile.BNFrames or self.initialized.BNFrames then return end
	self.initialized.BNFrames = true

-->>-- Toast frame
	-- hook these to stop gradient texture whiteout
	self:RawHook("BNToastFrame_Show", function()
		_G.BNToastFrame.sf.tfade:SetParent(_G.MainMenuBar)
		if _G.BNToastFrame.cb then _G.BNToastFrame.cb.tfade:SetParent(_G.MainMenuBar) end
		-- reset Gradient alpha
		_G.BNToastFrame.sf.tfade:SetGradientAlpha(self:getGradientInfo())
		if _G.BNToastFrame.cb then _G.BNToastFrame.cb.tfade:SetGradientAlpha(self:getGradientInfo()) end
		self.hooks.BNToastFrame_Show()
	end, true)
	self:SecureHook("AlertFrame_StopOutAnimation", function(frame)
		frame.sf.tfade:SetGradientAlpha(self:getGradientInfo())
		if frame.cb then frame.cb.tfade:SetGradientAlpha(self:getGradientInfo()) end
	end)
	self:RawHook("AlertFrame_ResumeOutAnimation", function(frame)
		frame.sf.tfade:SetAlpha(0)
		if frame.cb then frame.cb.tfade:SetAlpha(0) end
		self.hooks.AlertFrame_ResumeOutAnimation(frame)
	end, true)
	self:addSkinFrame{obj=_G.BNToastFrame, ft=ftype, af=true}

-->>-- Report frame
	_G.BNetReportFrameComment:DisableDrawLayer("BACKGROUND")
	self:skinScrollBar{obj=_G.BNetReportFrameCommentScrollFrame}
	self:skinEditBox{obj=_G.BNetReportFrameCommentBox, regs={6}}
	self:addSkinFrame{obj=_G.BNetReportFrame, ft=ftype}

-->>-- TimeAlert Frame
	self:RawHook("TimeAlert_Start", function(time)
		_G.TimeAlertFrame.sf.tfade:SetParent(_G.MainMenuBar)
		-- reset Gradient alpha
		_G.TimeAlertFrame.sf.tfade:SetGradientAlpha(self:getGradientInfo())
		self.hooks.TimeAlert_Start(time)
	end, true)
	_G._G.TimeAlertFrameBG:SetBackdrop(nil)
	self:addSkinFrame{obj=_G.TimeAlertFrame, ft=ftype, af=true, afas=true}

-->>-- ConversationInvite frame
	self:addSkinFrame{obj=_G.BNConversationInviteDialogList, ft=ftype}
	self:skinScrollBar{obj=_G.BNConversationInviteDialogListScrollFrame}
	self:addSkinFrame{obj=_G.BNConversationInviteDialog, kfs=true, ft=ftype, hdr=true}

end

function aObj:Calendar() -- LoD
	if not self.db.profile.Calendar or self.initialized.Calendar then return end
	self.initialized.Calendar = true

-->>--	Calendar Frame
	self:keepFontStrings(_G.CalendarFilterFrame)
	-- move close button
	self:moveObject{obj=_G.CalendarCloseButton, y=14}
	self:adjHeight{obj=_G.CalendarCloseButton, adj=-2}
	self:addButtonBorder{obj=_G.CalendarPrevMonthButton, ofs=-2}
	self:addButtonBorder{obj=_G.CalendarNextMonthButton, ofs=-2}
	self:addSkinFrame{obj=_G.CalendarFrame, ft=ftype, kfs=true, x1=1, y1=-2, x2=2, y2=-7}
	-- remove texture from day buttons
	for i = 1, 7 * 6 do
		_G["CalendarDayButton" .. i]:GetNormalTexture():SetTexture(nil)
	end

-->>-- View Holiday Frame
	self:keepFontStrings(_G.CalendarViewHolidayTitleFrame)
	self:moveObject{obj=_G.CalendarViewHolidayTitleFrame, y=-6}
	self:removeRegions(_G.CalendarViewHolidayCloseButton, {5})
	self:skinScrollBar{obj=_G.CalendarViewHolidayScrollFrame}
	self:addSkinFrame{obj=_G.CalendarViewHolidayFrame, ft=ftype, kfs=true, x1=2, y1=-3, x2=-3, y2=-2}

-->>-- View Raid Frame
	self:keepFontStrings(_G.CalendarViewRaidTitleFrame)
	self:moveObject{obj=_G.CalendarViewRaidTitleFrame, y=-6}
	self:removeRegions(_G.CalendarViewRaidCloseButton, {5})
	self:skinScrollBar{obj=_G.CalendarViewRaidScrollFrame}
	self:addSkinFrame{obj=_G.CalendarViewRaidFrame, ft=ftype, kfs=true, x1=2, y1=-3, x2=-3, y2=2}

-->>-- View Event Frame
	self:keepFontStrings(_G.CalendarViewEventTitleFrame)
	self:moveObject{obj=_G.CalendarViewEventTitleFrame, y=-6}
	self:removeRegions(_G.CalendarViewEventCloseButton, {5})
	self:addSkinFrame{obj=_G.CalendarViewEventDescriptionContainer, ft=ftype}
	self:skinScrollBar{obj=_G.CalendarViewEventDescriptionScrollFrame}
	self:keepFontStrings(_G.CalendarViewEventInviteListSection)
	self:skinSlider{obj=_G.CalendarViewEventInviteListScrollFrameScrollBar}
	self:addSkinFrame{obj=_G.CalendarViewEventInviteList, ft=ftype}
	self:addSkinFrame{obj=_G.CalendarViewEventFrame, ft=ftype, kfs=true, x1=2, y1=-3, x2=-3, y2=2}

-->>-- Create Event Frame
	_G.CalendarCreateEventIcon:SetAlpha(1) -- show event icon
	self:keepFontStrings(_G.CalendarCreateEventTitleFrame)
	self:moveObject{obj=_G.CalendarCreateEventTitleFrame, y=-6}
	self:removeRegions(_G.CalendarCreateEventCloseButton, {5})
	self:skinEditBox{obj=_G.CalendarCreateEventTitleEdit, regs={9}}
	self:skinDropDown{obj=_G.CalendarCreateEventTypeDropDown}
	self:skinDropDown{obj=_G.CalendarCreateEventHourDropDown, x2=-5}
	self:skinDropDown{obj=_G.CalendarCreateEventMinuteDropDown, x2=-5}
	self:skinDropDown{obj=_G.CalendarCreateEventAMPMDropDown, x2=-5}
	self:skinDropDown{obj=_G.CalendarCreateEventRepeatOptionDropDown}
	self:addSkinFrame{obj=_G.CalendarCreateEventDescriptionContainer, ft=ftype}
	self:skinScrollBar{obj=_G.CalendarCreateEventDescriptionScrollFrame}
	self:keepFontStrings(_G.CalendarCreateEventInviteListSection)
	self:skinSlider{obj=_G.CalendarCreateEventInviteListScrollFrameScrollBar}
	self:addSkinFrame{obj=_G.CalendarCreateEventInviteList, ft=ftype}
	self:skinEditBox{obj=_G.CalendarCreateEventInviteEdit, regs={9}}
	_G.CalendarCreateEventMassInviteButtonBorder:SetAlpha(0)
	_G.CalendarCreateEventRaidInviteButtonBorder:SetAlpha(0)
	_G.CalendarCreateEventCreateButtonBorder:SetAlpha(0)
	self:addSkinFrame{obj=_G.CalendarCreateEventFrame, ft=ftype, kfs=true, x1=2, y1=-3, x2=-3, y2=2}

-->>-- Mass Invite Frame
	self:keepFontStrings(_G.CalendarMassInviteTitleFrame)
	self:moveObject{obj=_G.CalendarMassInviteTitleFrame, y=-6}
	self:removeRegions(_G.CalendarMassInviteCloseButton, {5})
	self:skinEditBox{obj=_G.CalendarMassInviteGuildMinLevelEdit, regs={9}}
	self:skinEditBox{obj=_G.CalendarMassInviteGuildMaxLevelEdit, regs={9}}
	self:skinDropDown{obj=_G.CalendarMassInviteGuildRankMenu}
	self:addSkinFrame{obj=_G.CalendarMassInviteFrame, ft=ftype, kfs=true, x1=4, y1=-3, x2=-3, y2=26}

-->>-- Event Picker Frame
	self:keepFontStrings(_G.CalendarEventPickerTitleFrame)
	self:moveObject{obj=_G.CalendarEventPickerTitleFrame, y=-6}
	self:keepFontStrings(_G.CalendarEventPickerFrame)
	self:skinSlider(_G.CalendarEventPickerScrollBar)
	self:removeRegions(_G.CalendarEventPickerCloseButton, {7})
	self:addSkinFrame{obj=_G.CalendarEventPickerFrame, ft=ftype, x1=2, y1=-3, x2=-3, y2=2}

-->>-- Texture Picker Frame
	self:keepFontStrings(_G.CalendarTexturePickerTitleFrame)
	self:moveObject{obj=_G.CalendarTexturePickerTitleFrame, y=-6}
	self:skinSlider(_G.CalendarTexturePickerScrollBar)
	_G.CalendarTexturePickerCancelButtonBorder:SetAlpha(0)
	self:skinButton{obj=_G.CalendarTexturePickerCancelButton}
	_G.CalendarTexturePickerAcceptButtonBorder:SetAlpha(0)
	self:addSkinFrame{obj=_G.CalendarTexturePickerFrame, ft=ftype, kfs=true, x1=5, y1=-3, x2=-3, y2=2}

-->>-- Class Button Container
	for i = 1, _G.MAX_CLASSES do -- allow for the total button
		local btn = _G["CalendarClassButton" .. i]
		self:removeRegions(btn, {1})
		self:addButtonBorder{obj=btn}
	end
	-- Class Totals button, texture & size changes
	self:moveObject{obj=_G.CalendarClassTotalsButton, x=-2}
	_G.CalendarClassTotalsButton:SetWidth(25)
	_G.CalendarClassTotalsButton:SetHeight(25)
	self:applySkin{obj=_G.CalendarClassTotalsButton, ft=ftype, kfs=true, bba=self.modBtnBs and 1 or 0}

-->>-- ContextMenus
	self:addSkinFrame{obj=_G.CalendarContextMenu}
	self:addSkinFrame{obj=_G.CalendarInviteStatusContextMenu}

end

function aObj:ChallengesUI() -- LoD
	if not self.db.profile.ChallengesUI or self.initialized.ChallengesUI then return end
	self.initialized.ChallengesUI = true

	self:removeInset(_G.ChallengesFrameInset)
	self:keepFontStrings(_G.ChallengesFrame.details)
	for i = 1, 3 do
		local row = _G.ChallengesFrame["RewardRow" .. i]
		self:getRegion(row, 1):SetAlpha(0) -- N.B. texture changed in code
		self:addButtonBorder{obj=row.Reward2, relTo=row.Reward2.Icon}
		self:addButtonBorder{obj=row.Reward1, relTo=row.Reward1.Icon}
	end

	-- ChallengesLeaderboard Frame
	self:keepFontStrings(_G.ChallengesLeaderboardFrameHbar)
	self:addSkinFrame{obj=_G.ChallengesLeaderboardFrame, ft=ftype, kfs=true, ofs=-10}
	self:removeRegions(_G.ChallengesFrameLeaderboard, {1})
	self:skinButton{obj=_G.ChallengesFrameLeaderboard}

end

function aObj:ChatBubbles()
	if not self.db.profile.ChatBubbles or self.initialized.ChatBubbles then return end
	self.initialized.ChatBubbles = true

	local function skinChatBubbles()

		aObj.RegisterCallback("skinChatBubbles", "WorldFrame_GetChildren", function(this, child)
			if aObj:hasTextInTexture(aObj:getRegion(child, 1), "ChatBubble-Background", true) then
				aObj:applySkin{obj=child, ft=ftype, kfs=true} -- use apply skin otherwise text is behind
			end
		end)
		aObj:scanWorldFrameChildren()

	end
	-- skin any existing ones
	skinChatBubbles()

	local cbTmr
	-- hook these to skin ChatBubbles
	self:RegisterEvent("CINEMATIC_START", function()
		cbTmr = self:ScheduleRepeatingTimer(skinChatBubbles, 0.5)
	end)
	self:RegisterEvent("CINEMATIC_STOP", function()
		self:CancelTimer(cbTmr, true)
		cbTmr = nil
	end)

end

function aObj:ChatButtons()
	if not self.db.profile.ChatButtons or self.initialized.ChatButtons then return end
	self.initialized.ChatButtons = true

	if self.modBtnBs then
		for i = 1, _G.NUM_CHAT_WINDOWS do
			local obj = _G["ChatFrame" .. i].buttonFrame
			self:addButtonBorder{obj=obj.minimizeButton, ofs=-2}
			self:addButtonBorder{obj=obj.downButton, ofs=-2}
			self:addButtonBorder{obj=obj.upButton, ofs=-2}
			self:addButtonBorder{obj=obj.bottomButton, ofs=-2, reParent={self:getRegion(obj.bottomButton, 1)}}
		end
		self:addButtonBorder{obj=_G.ChatFrameMenuButton, ofs=-2}
	end

end

function aObj:ChatConfig()
	if not self.db.profile.ChatConfig or self.initialized.ChatConfig then return end
	self.initialized.ChatConfig = true

	self:addSkinFrame{obj=_G.ChatConfigFrame, ft=ftype, kfs=true, hdr=true}
	self:addSkinFrame{obj=_G.ChatConfigCategoryFrame, ft=ftype}
	self:addSkinFrame{obj=_G.ChatConfigBackgroundFrame, ft=ftype}

-->>--	Chat Settings
	for i = 1, #_G.CHAT_CONFIG_CHAT_LEFT do
		_G["ChatConfigChatSettingsLeftCheckBox" .. i]:SetBackdrop(nil)
	end
	self:addSkinFrame{obj=_G._G.ChatConfigChatSettingsLeft, ft=ftype}

	self:addSkinFrame{obj=_G.ChatConfigChatSettingsClassColorLegend, ft=ftype}

-->>--	Channel Settings
	self:SecureHook(_G.ChatConfigChannelSettings, "Show", function(this, ...)
		for i = 1, #_G.ChatConfigChannelSettingsLeft.checkBoxTable do
			_G["ChatConfigChannelSettingsLeftCheckBox" .. i]:SetBackdrop(nil)
		end
	end)
	self:addSkinFrame{obj=_G.ChatConfigChannelSettingsLeft, ft=ftype}
	self:addSkinFrame{obj=_G.ChatConfigChannelSettingsClassColorLegend, ft=ftype}

-->>--	Other Settings
	for i = 1, #_G.CHAT_CONFIG_OTHER_COMBAT do
		_G["ChatConfigOtherSettingsCombatCheckBox" .. i]:SetBackdrop(nil)
	end
	self:addSkinFrame{obj=_G.ChatConfigOtherSettingsCombat, ft=ftype}

	for i = 1, #_G.CHAT_CONFIG_OTHER_PVP do
		_G["ChatConfigOtherSettingsPVPCheckBox" .. i]:SetBackdrop(nil)
	end
	self:addSkinFrame{obj=_G.ChatConfigOtherSettingsPVP, ft=ftype}

	for i = 1, #_G.CHAT_CONFIG_OTHER_SYSTEM do
		_G["ChatConfigOtherSettingsSystemCheckBox" .. i]:SetBackdrop(nil)
	end
	self:addSkinFrame{obj=_G.ChatConfigOtherSettingsSystem, ft=ftype}

	for i = 1, #_G.CHAT_CONFIG_CHAT_CREATURE_LEFT do
		_G["ChatConfigOtherSettingsCreatureCheckBox" .. i]:SetBackdrop(nil)
	end
	self:addSkinFrame{obj=_G.ChatConfigOtherSettingsCreature, ft=ftype}

-->>--	Combat Settings
	-- Filters
	_G.ChatConfigCombatSettingsFiltersScrollFrameScrollBarBorder:Hide()
	self:skinScrollBar{obj=_G.ChatConfigCombatSettingsFiltersScrollFrame} --, noRR=true}
	self:addSkinFrame{obj=_G.ChatConfigCombatSettingsFilters, ft=ftype}

	-- Message Sources
	if _G.COMBAT_CONFIG_MESSAGESOURCES_BY then
		for i = 1, #_G.COMBAT_CONFIG_MESSAGESOURCES_BY do
			_G["CombatConfigMessageSourcesDoneByCheckBox" .. i]:SetBackdrop(nil)
		end
		self:addSkinFrame{obj=_G.CombatConfigMessageSourcesDoneBy, ft=ftype}
	end
	if _G.COMBAT_CONFIG_MESSAGESOURCES_TO then
		for i = 1, #_G.COMBAT_CONFIG_MESSAGESOURCES_TO do
			_G["CombatConfigMessageSourcesDoneToCheckBox" .. i]:SetBackdrop(nil)
		end
		self:addSkinFrame{obj=_G.CombatConfigMessageSourcesDoneTo, ft=ftype}
	end

	-- Colors
	for i = 1, #_G.COMBAT_CONFIG_UNIT_COLORS do
		_G["CombatConfigColorsUnitColorsSwatch" .. i]:SetBackdrop(nil)
	end
	self:addSkinFrame{obj=_G.CombatConfigColorsUnitColors, ft=ftype}

	for i, v in ipairs{"Highlighting", "UnitName", "SpellNames", "DamageNumber", "DamageSchool", "EntireLine"} do
		local clrize = i > 1 and "Colorize" or ""
	end

	-- Settings
	self:skinEditBox{obj=_G.CombatConfigSettingsNameEditBox , regs={9}}

	-- Tabs
	for i = 1, #_G.COMBAT_CONFIG_TABS do
		local obj = _G["CombatConfigTab" .. i]
		self:keepRegions(obj, {4, 5}) -- N.B. region 4 is the Text, 5 is the highlight
		self:addSkinFrame{obj=obj, ft=ftype, y1=-8, y2=-4}
	end

end

local function skinChatEB(obj)

	if aObj.db.profile.ChatEditBox.style == 1 then -- Frame
		local kRegions = _G.CopyTable(aObj.ebRgns)
		aObj:add2Table(kRegions, 12)
		aObj:add2Table(kRegions, 13)
		aObj:keepRegions(obj, kRegions)
		aObj:addSkinFrame{obj=obj, ft=ftype, x1=2, y1=-2, x2=-2}
		obj.sf:SetAlpha(obj:GetAlpha())
	elseif aObj.db.profile.ChatEditBox.style == 2 then -- Editbox
		aObj:skinEditBox{obj=obj, regs={12, 13}, noHeight=true}
	else -- Borderless
		aObj:removeRegions(obj, {6, 7, 8})
		aObj:addSkinFrame{obj=obj, ft=ftype, noBdr=true, x1=5, y1=-4, x2=-5, y2=2}
		obj.sf:SetAlpha(obj:GetAlpha())
	end

end
function aObj:ChatEditBox()
	if not self.db.profile.ChatEditBox.skin or self.initialized.ChatEditBox then return end
	self.initialized.ChatEditBox = true

	-- these addons replace the Chat Edit Box
	if IsAddOnLoaded("NeonChat")
	or IsAddOnLoaded("Chatter")
	or IsAddOnLoaded("Prat-3.0")
	then
		return
	end

	for i = 1, _G.NUM_CHAT_WINDOWS do
		skinChatEB(_G["ChatFrame" .. i].editBox)
	end
	-- if editBox has a skin frame then hook these to manage its Alpha setting
	if self.db.profile.ChatEditBox.style ~= 2
	and not self:IsHooked("ChatEdit_ActivateChat")
	then
		local function setAlpha(eBox)
			if eBox and eBox.sf then eBox.sf:SetAlpha(eBox:GetAlpha()) end
		end
		self:SecureHook("ChatEdit_ActivateChat", function(editBox)
			setAlpha(editBox)
		end)
		self:SecureHook("ChatEdit_DeactivateChat", function(editBox)
			setAlpha(editBox)
		end)
	end

end

function aObj:ChatFrames()
	if not self.db.profile.ChatFrames or self.initialized.ChatFrames then return end
	self.initialized.ChatFrames = true

	local clqbf = "CombatLogQuickButtonFrame"
	local clqbf_c = clqbf .. "_Custom"
	local yOfs1 = 6
	for i = 1, _G.NUM_CHAT_WINDOWS do
		local obj = _G["ChatFrame" .. i]
		if obj == _G.COMBATLOG
		and _G[clqbf_c]:IsShown()
		then
			yOfs1 = 31
		else
			yOfs1 = 6
		end
		self:addSkinFrame{obj=obj, ft=ftype, ofs=6, y1=yOfs1, y2=-8}
	end

	-- CombatLog Quick Button Frame & Progress Bar
	if self.db.profile.CombatLogQBF then
		if _G[clqbf_c] then
			self:keepFontStrings(_G[clqbf_c])
			self:addSkinFrame{obj=_G[clqbf_c], ft=ftype, x1=-4, x2=4}
			self:adjHeight{obj=_G[clqbf_c], adj=4}
			self:glazeStatusBar(_G[clqbf_c .. "ProgressBar"], 0, _G[clqbf_c .. "Texture"])
		else
			self:glazeStatusBar(_G[clqbf .. "ProgressBar"], 0, _G[clqbf .. "Texture"])
		end
	end

end

function aObj:ChatMenus()
	if not self.db.profile.ChatMenus or self.initialized.ChatMenus then return end
	self.initialized.ChatMenus = true

	self:addSkinFrame{obj=_G.ChatMenu, ft=ftype}
	self:addSkinFrame{obj=_G.EmoteMenu, ft=ftype}
	self:addSkinFrame{obj=_G.LanguageMenu, ft=ftype}
	self:addSkinFrame{obj=_G.VoiceMacroMenu, ft=ftype}
	self:addSkinFrame{obj=_G.GeneralDockManagerOverflowButtonList, ft=ftype}

end

function aObj:ChatMinimizedFrames()
	if not self.db.profile.ChatFrames then return end

	-- minimized chat frames
	self:SecureHook("FCF_CreateMinimizedFrame", function(chatFrame)
		local obj = _G[chatFrame:GetName() .. "Minimized"]
		self:rmRegionsTex(obj, {1, 2, 3})
		self:addSkinFrame{obj=obj, ft=ftype, x1=1, y1=-2, x2=-1, y2=2}
		self:addButtonBorder{obj=_G[chatFrame:GetName() .. "MinimizedMaximizeButton"], ofs=-1}
	end)

end

local function skinChatTab(tab)

	aObj:rmRegionsTex(tab, {1, 2, 3, 4, 5, 6})
	aObj:addSkinFrame{obj=tab, ft=ftype, noBdr=aObj.isTT, x1=2, y1=-9, x2=-2, y2=-4}
	tab.sf:SetAlpha(tab:GetAlpha())
	-- hook this to fix tab gradient texture overlaying text & highlight
	if not aObj:IsHooked(tab, "SetParent") then
		aObj:SecureHook(tab, "SetParent", function(this, parent)
			if parent == _G.GeneralDockManager.scrollFrame.child then
				this.sf:SetParent(_G.GeneralDockManager)
			else
				this.sf:SetParent(this)
				this.sf:SetFrameLevel(1) -- reset frame level so that the texture is behind text etc
			end
		end)
	end
	-- hook this to manage alpha changes when chat frame fades in and out
	if not aObj:IsHooked(tab, "SetAlpha") then
		aObj:SecureHook(tab, "SetAlpha", function(this, alpha)
			this.sf:SetAlpha(alpha)
		end)
	end

end
function aObj:ChatTabs()
	if not self.db.profile.ChatTabs or self.initialized.ChatTabs then return end
	self.initialized.ChatTabs = true

	for i = 1, _G.NUM_CHAT_WINDOWS do
		local tab = _G["ChatFrame" .. i .. "Tab"]
		skinChatTab(tab)
	end

	if self.db.profile.ChatTabsFade then
		-- hook this to hide/show the skin frame
		aObj:SecureHook("FCFTab_UpdateColors", function(this, selected)
			if this.sf then this.sf:SetShown(selected) end
		end)
	end

end

function aObj:ChatTemporaryWindow()
	if not self.db.profile.ChatTabs
	and not self.db.profile.ChatFrames
	and not self.db.profile.ChatEditBox.skin
	then return end

	local function skinTempWindow(obj)

		if aObj.db.profile.ChatTabs
		and not obj.sf
		then
			skinChatTab(_G[obj:GetName() .. "Tab"])
		end
		if aObj.db.profile.ChatFrames
		and not obj.sf
		then
			aObj:addSkinFrame{obj=obj, ft=ftype, x1=-4, y1=4, x2=4, y2=-8}
		end
		if aObj.db.profile.ChatEditBox.skin
		and not obj.editBox.sknd
		then
			aObj:add2Table(aObj.skinned, obj.editBox) -- TODO: deprecate when all skins changed
			obj.editBox.sknd = true
			skinChatEB(obj.editBox)
		end
		if aObj.db.profile.ChatButtons
		and not obj.buttonFrame.sknd
		then
			aObj:addButtonBorder{obj=obj.buttonFrame.minimizeButton, ofs=-2}
			aObj:addButtonBorder{obj=obj.buttonFrame.downButton, ofs=-2}
			aObj:addButtonBorder{obj=obj.buttonFrame.upButton, ofs=-2}
			aObj:addButtonBorder{obj=obj.buttonFrame.bottomButton, ofs=-2, reParent={aObj:getRegion(obj.buttonFrame.bottomButton, 1)}}
			if obj.conversationButton then
				aObj:addButtonBorder{obj=obj.conversationButton, ofs=-2}
			end
			obj.buttonFrame.sknd = true
		end

	end
	-- hook this to handle Temporary windows (BN Conversations, Pet Battles etc)
	self:RawHook("FCF_OpenTemporaryWindow", function(...)
		local obj = self.hooks.FCF_OpenTemporaryWindow(...)
		skinTempWindow(obj)
		return obj
	end, true)
	-- skin any existing temporary windows
	for _, chatFrameName in pairs(_G.CHAT_FRAMES) do
		local frame = _G[chatFrameName]
		if frame.isTemporary then skinTempWindow(frame) end
	end

end

function aObj:CinematicFrame()
	if not self.db.profile.CinematicFrame or self.initialized.CinematicFrame then return end
	self.initialized.CinematicFrame = true

	self:addSkinFrame{obj=_G.CinematicFrame.closeDialog, ft=ftype}

end

function aObj:CoinPickup()
	if not self.db.profile.CoinPickup or self.initialized.CoinPickup then return end
	self.initialized.CoinPickup = true

	self:addSkinFrame{obj=_G.CoinPickupFrame, ft=ftype, kfs=true, x1=9, y1=-12, x2=-6, y2=12}

end

function aObj:ColorPicker()
	if not self.db.profile.Colours or self.initialized.Colours then return end
	self.initialized.Colours = true

	_G.ColorPickerFrame:SetBackdrop(nil)
	_G.ColorPickerFrameHeader:SetAlpha(0)
	self:skinSlider{obj=_G.OpacitySliderFrame, size=4}
	self:addSkinFrame{obj=_G.ColorPickerFrame, ft=ftype, y1=6}

-->>-- Opacity Frame, used by BattlefieldMinimap amongst others
	_G.OpacityFrame:SetBackdrop(nil)
	self:skinSlider{obj=_G.OpacityFrameSlider, size=3}
	self:addSkinFrame{obj=_G.OpacityFrame, ft=ftype}

end

function aObj:DeathRecap() -- LoD
	if not self.db.profile.DeathRecap or self.initialized.DeathRecap then return end
	self.initialized.DeathRecap = true

	_G.DeathRecapFrame:DisableDrawLayer("BORDER")
	_G.DeathRecapFrame.Background:SetTexture(nil)
	-- manage buttons here, as names have changed from normal
	self:skinButton{obj=_G.DeathRecapFrame.CloseButton}
	self:skinButton{obj=_G.DeathRecapFrame.CloseXButton, cb=true}
	self:addSkinFrame{obj=_G.DeathRecapFrame, ft=ftype, kfs=true, nb=true, ofs=-1}

end

function aObj:DebugTools() -- LoD
	if not self.db.profile.DebugTools or self.initialized.DebugTools then return end
	self.initialized.DebugTools = true

	self:skinSlider{obj=_G.EventTraceFrameScroll, size=3}
	self:addSkinFrame{obj=_G.EventTraceFrame, ft=ftype, kfs=true, x1=1, y1=-2, x2=-1, y2=4}
	self:skinScrollBar{obj=_G.ScriptErrorsFrameScrollFrame}
	self:addSkinFrame{obj=_G.ScriptErrorsFrame, ft=ftype, kfs=true, x1=1, y1=-2, x2=-1, y2=4}

	if self.db.profile.Tooltips.skin then
		self:add2Table(self.ttList, "FrameStackTooltip")
		self:add2Table(self.ttList, "EventTraceTooltip")
		self:HookScript(_G.FrameStackTooltip, "OnUpdate", function(this)
			self:skinTooltip(this)
		end)
		self:HookScript(_G.EventTraceTooltip, "OnUpdate", function(this)
			self:skinTooltip(this)
		end)
	end

end

function aObj:DestinyFrame()
	if not self.db.profile.DestinyFrame or self.initialized.DestinyFrame then return end
	self.initialized.DestinyFrame = true

	-- buttons
	for _, v in pairs{"alliance", "horde"} do
		local btn = _G.DestinyFrame[v .. "Button"]
		self:removeRegions(btn, {1})
		self:changeRecTex(btn:GetHighlightTexture())
		self:adjWidth{obj=btn, adj=-60}
		self:adjHeight{obj=btn, adj=-60}
		self:skinButton{obj=btn, x1=-2, y1=2, x2=-3, y2=-1}
	end

	_G.DestinyFrame.alphaLayer:SetTexture(0, 0, 0, 0.70)
	_G.DestinyFrame.background:SetTexture(nil)
	_G.DestinyFrame.frameHeader:SetTextColor(self.HTr, self.HTg, self.HTb)
	_G.DestinyFrameAllianceLabel:SetTextColor(self.BTr, self.BTg, self.BTb)
	_G.DestinyFrameHordeLabel:SetTextColor(self.BTr, self.BTg, self.BTb)
	_G.DestinyFrameLeftOrnament:SetTexture(nil)
	_G.DestinyFrameRightOrnament:SetTexture(nil)
	_G.DestinyFrame.allianceText:SetTextColor(self.BTr, self.BTg, self.BTb)
	_G.DestinyFrame.hordeText:SetTextColor(self.BTr, self.BTg, self.BTb)
	_G.DestinyFrameAllianceFinalText:SetTextColor(self.BTr, self.BTg, self.BTb)
	_G.DestinyFrameHordeFinalText:SetTextColor(self.BTr, self.BTg, self.BTb)

end

function aObj:DraenorZoneAbility()
	if not self.db.profile.DraenorZoneAbility or self.initialized.DraenorZoneAbility then return end
	self.initialized.DraenorZoneAbility = true

	self:removeRegions(_G.DraenorZoneAbilityFrame.SpellButton, {2, 4})
	self:addButtonBorder{obj=_G.DraenorZoneAbilityFrame.SpellButton, ofs=2}

end

function aObj:DropDownPanels() -- option under General settings
	if not self.db.profile.DropDownPanels or self.initialized.DropDownPanels then return end
	self.initialized.DropDownPanels = true

	self:SecureHook("UIDropDownMenu_CreateFrames", function(...)
		for i = 1,_G. UIDROPDOWNMENU_MAXLEVELS do
			local objName = "DropDownList" .. i
			local obj = _G[objName]
			if not self:IsHooked(obj, "Show") then
				self:SecureHook(obj, "Show", function(this)
					_G[this:GetName() .. "Backdrop"]:Hide()
					_G[this:GetName() .. "MenuBackdrop"]:Hide()
					if not this.sf then
						self:addSkinFrame{obj=this, ft=ftype, kfs=true}
					end
				end)
			end
		end
	end)

end

function aObj:GarrisonUI() -- LoD
	if not self.db.profile.GarrisonUI or self.initialized.GarrisonUI then return end
	self.initialized.GarrisonUI = true

	local stageRegs = {1, 2, 3, 4, 5}
	local cdStageRegs = {1, 2, 3, 4, 5, 6}

	local function skinPortrait(frame)

		frame.PortraitRing:SetTexture(nil)
		frame.LevelBorder:SetAlpha(0) -- texture changed
		if frame.PortraitRingCover then frame.PortraitRingCover:SetTexture(nil) end
		if frame.Empty then
			frame.Empty:SetTexture(nil)
			aObj:SecureHook(frame.Empty, "Show", function(this)
				local fp = this:GetParent()
				fp.Portrait:SetTexture(nil)
				fp.PortraitRingQuality:SetVertexColor(1, 1, 1, 1)
			end)
		end

	end
	local function skinFollower(frame)

		frame.BG:SetTexture(nil)
		if frame.AbilitiesBG then frame.AbilitiesBG:SetTexture(nil) end -- Mission Follower
		if frame.PortraitFrame then skinPortrait(frame.PortraitFrame) end

	end
	local function skinFollowerList(obj)

		local extraReg = obj:GetParent() ~= _G.GarrisonLandingPage and 3 or nil
		aObj:removeRegions(obj, {1, 2, extraReg})
		if obj.SearchBox then
			aObj:skinEditBox{obj=obj.SearchBox, regs={9, 10}, mi=true}
			-- need to do this as background isn't visible on Shipyard Mission page
			_G.RaiseFrameLevel(obj.SearchBox)
		end
		aObj:skinSlider{obj=obj.listScroll.scrollBar, adj=-4}
		for i = 1, #obj.listScroll.buttons do
			skinFollower(obj.listScroll.buttons[i])
		end

	end
	local function skinFollowerPage(frame)

		skinPortrait(frame.PortraitFrame)
		aObj:glazeStatusBar(frame.XPBar, 0,  nil)
		frame.XPBar:DisableDrawLayer("OVERLAY")
		aObj:addButtonBorder{obj=frame.ItemWeapon, relTo=frame.ItemWeapon.Icon}
		frame.ItemWeapon.Border:SetTexture(nil)
		aObj:addButtonBorder{obj=frame.ItemArmor, relTo=frame.ItemArmor.Icon}
		frame.ItemArmor.Border:SetTexture(nil)

	end
	local function skinFollowerAbilitiesAndCounters(frame, id)

		local this = frame:GetParent().FollowerTab
		for i = 1, #this.AbilitiesFrame.Abilities do
			-- Ability buttons
			aObj:addButtonBorder{obj=this.AbilitiesFrame.Abilities[i].IconButton}
		end
		for i = 1, #this.AbilitiesFrame.Counters do
			-- Counters buttons
			this.AbilitiesFrame.Counters[i].Border:SetTexture(nil)
			aObj:addButtonBorder{obj=this.AbilitiesFrame.Counters[i], relTo=this.AbilitiesFrame.Counters[i].Icon}
		end

	end
	local function skinFollowerTraitsAndEquipment(obj)

		aObj:glazeStatusBar(obj.XPBar, 0,  nil)
		obj.XPBar:DisableDrawLayer("OVERLAY")
		for i = 1, #obj.Traits do
			local btn = obj.Traits[i]
			btn.Border:SetTexture(nil)
			aObj:addButtonBorder{obj=btn, relTo=btn.Portrait}
		end
		for i = 1, #obj.EquipmentFrame.Equipment do
			local btn = obj.EquipmentFrame.Equipment[i]
			btn:DisableDrawLayer("BACKGROUND")
			btn.Border:SetTexture(nil)
			aObj:addButtonBorder{obj=btn, relTo=btn.Icon}
		end

	end
	local function skinCompleteDialog(obj)

		aObj:getRegion(obj.CompleteDialog, 1):SetTexture(0, 0, 0, 1) -- make background opaque
		obj.CompleteDialog.BorderFrame:DisableDrawLayer("BACKGROUND")
		obj.CompleteDialog.BorderFrame:DisableDrawLayer("BORDER")
		obj.CompleteDialog.BorderFrame:DisableDrawLayer("OVERLAY")
		aObj:removeRegions(obj.CompleteDialog.BorderFrame.Stage, cdStageRegs)
		aObj:skinButton{obj=obj.CompleteDialog.BorderFrame.ViewButton}

	end
	local function skinMissionPage(obj)

		obj:DisableDrawLayer("BACKGROUND")
		obj:DisableDrawLayer("BORDER")
		obj:DisableDrawLayer("OVERLAY")
		obj.ButtonFrame:SetTexture(nil)
		local btnSize = obj:GetParent():GetParent() ~= _G.GarrisonShipyardFrame and 32 or 28
		obj.CloseButton:SetSize(btnSize, btnSize)
		aObj:removeRegions(obj.Stage, stageRegs)
		-- don't skin ShipyardUI Mission Frame
		aObj:addSkinFrame{obj=obj, ft=ftype, x1=-320, y1=5, x2=3, y2=-20}
		-- handle animation of StartMissionButton
		if aObj.modBtns then
			 obj.StartMissionButton.sb.tfade:SetParent(obj.sf)
		end
		obj.Stage.MissionEnvIcon.Texture:SetTexture(nil)
		obj.BuffsFrame.BuffsBG:SetTexture(nil)
		obj.RewardsFrame:DisableDrawLayer("BACKGROUND")
		obj.RewardsFrame:DisableDrawLayer("BORDER")
		for i = 1, #obj.RewardsFrame.Rewards do
			local frame = obj.RewardsFrame.Rewards[i]
			frame.BG:SetTexture(nil)
			aObj:addButtonBorder{obj=frame, relTo=frame.Icon, reParent={frame.Quantity}}
		end

	end
	local function skinMissionComplete(obj)

		aObj:getRegion(obj:GetParent().MissionCompleteBackground, 1):SetTexture(0, 0, 0, 1) -- make background opaque
		obj:DisableDrawLayer("BACKGROUND")
		obj:DisableDrawLayer("BORDER")
		obj:DisableDrawLayer("ARTWORK")
		aObj:removeRegions(obj.Stage, stageRegs)
		for i = 1, #obj.Stage.FollowersFrame.Followers do
			local frame = obj.Stage.FollowersFrame.Followers[i]
			aObj:removeRegions(frame, {1})
			if frame.PortraitFrame then skinPortrait(frame.PortraitFrame) end
			aObj:glazeStatusBar(frame.XP, 0,  nil)
			frame.XP:DisableDrawLayer("OVERLAY")
		end
		obj.BonusRewards:DisableDrawLayer("BACKGROUND")
		obj.BonusRewards:DisableDrawLayer("BORDER")
		aObj:getRegion(obj.BonusRewards, 11):SetTextColor(aObj.HTr, aObj.HTg, aObj.HTb) -- Heading
		obj.BonusRewards.Saturated:DisableDrawLayer("BACKGROUND")
		obj.BonusRewards.Saturated:DisableDrawLayer("BORDER")

	end
	-->>-- GarrisonBuildingUI
	local function skinGarrisonBuildingUI()

		-- Building Frame
		_G.GarrisonBuildingFrame.MainHelpButton.Ring:SetTexture(nil)
		aObj:moveObject{obj=_G.GarrisonBuildingFrame.MainHelpButton, y=-4}
		aObj:addSkinFrame{obj=_G.GarrisonBuildingFrame, ft=ftype, kfs=true, ofs=2}

		-- BuildingList
		local bl = _G.GarrisonBuildingFrame.BuildingList
		bl:DisableDrawLayer("BORDER")

		-- tabs
		for i = 1, _G.GARRISON_NUM_BUILDING_SIZES do
			local tab = bl["Tab" .. i]
			tab:GetNormalTexture():SetAlpha(0) -- texture is changed in code
			aObj:addSkinFrame{obj=tab, ft=ftype, noBdr=aObj.isTT, x1=3, y1=0, x2=-3, y2=2}
			tab.sf.ignore = true -- don't change tab size
			if i == 1 then
				aObj:toggleTabDisplay(tab, true)
			else
				aObj:toggleTabDisplay(tab, false)
			end
		end

		for i = 1, #bl.Buttons do
			local btn = bl.Buttons[i]
			btn.BG:SetTexture(nil)
			aObj:addButtonBorder{obj=btn, relTo=btn.Icon}
		end
		aObj:SecureHook("GarrisonBuildingList_SelectTab", function(tab)
			-- handle tab textures
			for i = 1, _G.GARRISON_NUM_BUILDING_SIZES do
				if i == tab:GetID() then
					aObj:toggleTabDisplay(tab, true)
				else
					aObj:toggleTabDisplay(bl["Tab" .. i], false)
				end
			end
			-- handle buttons
			for i = 1, #bl.Buttons do
				local btn = bl.Buttons[i]
				btn.BG:SetTexture(nil)
				aObj:addButtonBorder{obj=btn, relTo=btn.Icon}
			end
		end)
		bl.MaterialFrame:DisableDrawLayer("BACKGROUND")

		-- BuildingLevelTooltip
		aObj:addSkinFrame{obj=_G.GarrisonBuildingFrame.BuildingLevelTooltip, ft=ftype}

		-- FollowerList
		local fl = _G.GarrisonBuildingFrame.FollowerList
		fl:DisableDrawLayer("BACKGROUND")
		fl:DisableDrawLayer("BORDER")
		skinFollowerList(fl)

		-- InfoBox
		local ib = _G.GarrisonBuildingFrame.InfoBox
		ib:DisableDrawLayer("BORDER")
		ib.AddFollowerButton.EmptyPortrait:SetTexture(nil)
		skinPortrait(ib.FollowerPortrait)
		ib.FollowerPortrait.PortraitRingQuality:SetVertexColor(ib.FollowerPortrait.PortraitRing:GetVertexColor())

		-- TownHallBox
		_G.GarrisonBuildingFrame.TownHallBox:DisableDrawLayer("BORDER")

		-- MapFrame

		-- Confirmation
		_G.GarrisonBuildingFrame.Confirmation:DisableDrawLayer("BACKGROUND")
		aObj:addSkinFrame{obj=_G.GarrisonBuildingFrame.Confirmation, ft=ftype, ofs=-12}

	end

	-->>-- GarrisonCapacitiveDisplay (i.e. Work Order Frame)
	local function skinGarrisonCapacitiveDisplay()

		local cdf = _G.GarrisonCapacitiveDisplayFrame
		aObj:addSkinFrame{obj=cdf, ft=ftype, kfs=true, ri=true, ofs=2}
		cdf.CapacitiveDisplay.IconBG:SetTexture(nil)
		aObj:addButtonBorder{obj=cdf.CapacitiveDisplay.ShipmentIconFrame, relTo=cdf.CapacitiveDisplay.ShipmentIconFrame.Icon}
		-- for i = 1, #cd.Reagents do
		-- 	local btn = cd.Reagents[i]
		-- 	aObj:addButtonBorder{obj=btn, relTo=btn.Icon, reParent={btn.Count}}
		-- 	btn.NameFrame:SetTexture(nil)
		-- end
		aObj:removeMagicBtnTex(cdf.StartWorkOrderButton)
		aObj:removeMagicBtnTex(cdf.CreateAllWorkOrdersButton)
		aObj:addButtonBorder{obj=cdf.DecrementButton, ofs=-2, es=10}
		aObj:skinEditBox{obj=cdf.Count, regs={9}}
		aObj:addButtonBorder{obj=cdf.IncrementButton, ofs=-2, es=10}
		-- hook this to skin regents
		aObj:SecureHook("GarrisonCapacitiveDisplayFrame_Update", function(this)
			for i = 1, #this.CapacitiveDisplay.Reagents do
				local btn = this.CapacitiveDisplay.Reagents[i]
				aObj:addButtonBorder{obj=btn, relTo=btn.Icon, reParent={btn.Count}}
				btn.NameFrame:SetTexture(nil)
			end
		end)

	end

	-->>-- GarrisonLandingPage
	local function skinGarrisonLandingPage()

		_G.GarrisonLandingPage:DisableDrawLayer("BACKGROUND")
		_G.GarrisonLandingPage.HeaderBar:SetTexture(nil)
		_G.GarrisonLandingPage.numTabs = 3
		aObj:skinTabs{obj=_G.GarrisonLandingPage, regs={9, 10}, ignore=true, lod=true, x1=5, y1=-8, x2=-4, y2=-3}
		aObj:addSkinFrame{obj=_G.GarrisonLandingPage, ft=ftype, ofs=-6, y1=-12, x2=-12}

		-- ReportTab
		local rp = _G.GarrisonLandingPage.Report
		rp.List:DisableDrawLayer("BACKGROUND")
		aObj:skinSlider{obj=rp.List.listScroll.scrollBar, adj=-4}
		for i = 1, #rp.List.listScroll.buttons do
			local btn = rp.List.listScroll.buttons[i]
			btn:DisableDrawLayer("BACKGROUND")
			btn:DisableDrawLayer("BORDER")
			for j = 1, #btn.Rewards do
				btn.Rewards[j]:DisableDrawLayer("BACKGROUND")
				aObj:addButtonBorder{obj=btn.Rewards[j], relTo=btn.Rewards[j].Icon, reParent={btn.Rewards[j].Quantity}}
			end
		end
		for i = 1, #rp.Shipments do
			local frame = rp.Shipments[i]
			aObj:removeRegions(frame, {1, 3, 4})
		end
		-- tabs at top
		rp.InProgress:GetNormalTexture():SetAlpha(0)
		rp.Available:GetNormalTexture():SetAlpha(0)

		-- FollowerList
		local fl = _G.GarrisonLandingPage.FollowerList
		skinFollowerList(fl)
		aObj:SecureHook(fl, "ShowFollower", function(this, id)
			skinFollowerAbilitiesAndCounters(this, id)
		end)

		-- FollowerTab
		skinFollowerPage(_G.GarrisonLandingPage.FollowerTab)

		-- FleetTab
		-- ShipFollowerList
		skinFollowerList(_G.GarrisonLandingPage.ShipFollowerList)
		-- ShipFollowerTab
		skinFollowerTraitsAndEquipment(_G.GarrisonLandingPage.ShipFollowerTab)

		-- minimap
		aObj:skinButton{obj=_G.GarrisonLandingPageTutorialBox.CloseButton, cb=true}

		local obj=_G.GarrisonLandingPageMinimapButton
		-- prevent AlertBG & SideToastGlow from being shown (this is a pita)
		obj.MinimapAlertAnim = nil
		obj.MinimapAlertAnim = obj:CreateAnimationGroup()
		obj.MinimapAlertAnim.AlertText1= obj.MinimapAlertAnim:CreateAnimation("Alpha")
		obj.MinimapAlertAnim.AlertText1:SetChildKey("AlertText")
		obj.MinimapAlertAnim.AlertText1:SetDuration(0.25)
		obj.MinimapAlertAnim.AlertText1:SetFromAlpha(0)
		obj.MinimapAlertAnim.AlertText1:SetToAlpha(1)
		obj.MinimapAlertAnim.AlertText1:SetOrder(1)
		obj.MinimapAlertAnim.AlertText2= obj.MinimapAlertAnim:CreateAnimation("Alpha")
		obj.MinimapAlertAnim.AlertText2:SetChildKey("AlertText")
		obj.MinimapAlertAnim.AlertText2:SetStartDelay(5)
		obj.MinimapAlertAnim.AlertText2:SetDuration(0.25)
		obj.MinimapAlertAnim.AlertText2:SetFromAlpha(1)
		obj.MinimapAlertAnim.AlertText2:SetToAlpha(0)
		obj.MinimapAlertAnim.AlertText2:SetOrder(2)
		-- based on the original scripts
		obj.MinimapAlertAnim:SetScript("OnPlay", function(this)
			this:GetParent().AlertText:Show()
			this:GetParent().MinimapPulseAnim:Play()
		end)
		obj.MinimapAlertAnim:SetScript("OnStop", function(this)
			this:GetParent().AlertText:Hide()
			this:GetParent().MinimapPulseAnim:Stop()
		end)
		obj.MinimapAlertAnim:SetScript("OnFinished", function(this)
			this:GetParent().AlertText:Hide()
			this:GetParent().MinimapPulseAnim:Stop()
		end)

	end

	-->>-- GarrisonMissionUI
	local function skinGarrisonMissionUI()

		-- hook this to skin extra reward buttons
		aObj:SecureHook("GarrisonMissionButton_SetRewards", function(this, rewards, numRewards)
			if numRewards > 0 then
				for i = 1, #this.Rewards do
					aObj:addButtonBorder{obj=this.Rewards[i], relTo=this.Rewards[i].Icon, reParent={this.Rewards[i].Quantity}}
				end
			end
		end)

		-- Mission Frame
		aObj:addSkinFrame{obj=_G.GarrisonMissionFrame, ft=ftype, kfs=true, ofs=2, x2=1, y2=-4}
		-- tabs
		aObj:skinTabs{obj=_G.GarrisonMissionFrame, regs={9, 10}, ignore=true, lod=true, x1=9, y1=2, x2=-9, y2=0}

		-- FollowerList
		local fl = _G.GarrisonMissionFrame.FollowerList
		fl:DisableDrawLayer("BORDER")
		fl.MaterialFrame:DisableDrawLayer("BACKGROUND")
		skinFollowerList(fl)
		aObj:SecureHook(fl, "ShowFollower", function(this, id)
			skinFollowerAbilitiesAndCounters(this, id)
		end)

	-->>-- MissionTab
		-- Mission List
		local ml = _G.GarrisonMissionFrame.MissionTab.MissionList
		ml:DisableDrawLayer("BORDER")
		ml.MaterialFrame:DisableDrawLayer("BACKGROUND")

		-- tabs at top
		for i = 1, 2 do
			local tab = ml["Tab" .. i]
			tab:DisableDrawLayer("BORDER")
			aObj:addSkinFrame{obj=tab, ft=ftype, noBdr=aObj.isTT}
			tab.sf.ignore = true -- don't change tab size
			if aObj.isTT then
				if i == 1 then
					aObj:setActiveTab(tab.sf)
				else
					aObj:setInactiveTab(tab.sf)
				end
			end
		end
		aObj:SecureHook("GarrisonMissionList_SetTab", function(tab)
			-- handle tab textures
			if aObj.isTT then
				for i = 1, 2 do
					if i == tab:GetID() then
						aObj:setActiveTab(tab.sf)
					else
						aObj:setInactiveTab(ml["Tab" .. i].sf)
					end
				end
			end

		end)
		aObj:skinSlider{obj=ml.listScroll.scrollBar, adj=-4}
		for i = 1, #ml.listScroll.buttons do
			local btn = ml.listScroll.buttons[i]
			btn:DisableDrawLayer("BACKGROUND")
			btn.Overlay.Overlay:SetTexture(nil)
			aObj:removeRegions(btn, {7, 8, 9, 10, 11, 12, 13, 14, 23, 24, 25, 26}) -- 23-26 are highlight corners
			for i = 1, #btn.Rewards do
				aObj:addButtonBorder{obj=btn.Rewards[i], relTo=btn.Rewards[i].Icon, reParent={btn.Rewards[i].Quantity}}
			end
		end

		-- CompleteDialog
		skinCompleteDialog(ml)

		-- MissionPage
		local mp = _G.GarrisonMissionFrame.MissionTab.MissionPage
		skinMissionPage(mp)
		for i = 1, #mp.Followers do
			aObj:removeRegions(mp.Followers[i], {1})
			skinPortrait(mp.Followers[i].PortraitFrame)
		end
		for i = 1, #mp.Enemies do
			local frame = mp.Enemies[i]
			frame.PortraitFrame.PortraitRing:SetTexture(nil)
		end
		aObj:moveObject{obj=mp.FollowerModel, x=-6, y=0}

	-->>-- FollowerTab
		_G.GarrisonMissionFrame.FollowerTab:DisableDrawLayer("BORDER")
		skinFollowerPage(_G.GarrisonMissionFrame.FollowerTab)

		-- MissionComplete
		local mc = _G.GarrisonMissionFrame.MissionComplete
		skinMissionComplete(mc)
		for i = 1, #mc.Stage.EncountersFrame.Encounters do
			local frame = mc.Stage.EncountersFrame.Encounters[i]
			frame.Ring:SetTexture(nil)
		end
		aObj:keepRegions(mc.Stage.MissionInfo, {6, 7, 8, 9, 10}) -- N.B. 6, 7, 9, 10 are text, 8 is MissionType
		-- N.B. IconBG texture seems to appear when the mission is Rare
		aObj:SecureHook("GarrisonMissionPage_SetReward", function(frame, reward)
			frame.BG:SetTexture(nil)
			aObj:addButtonBorder{obj=frame, relTo=frame.Icon, reParent={frame.Quantity}}
		end)

		-- GarrisonFollowerPlacer
		_G.GarrisonFollowerPlacer.PortraitRing:SetTexture(nil)
		_G.GarrisonFollowerPlacer.LevelBorder:SetAlpha(0)

		-- MissionFrame HelpBox
		aObj:skinButton{obj=_G.GarrisonMissionFrameHelpBox.Button}

	end

	-->>-- GarrisonMonumentUI
	local function skinGarrisonMonumentUI()

		_G.GarrisonMonumentFrame.Background:SetTexture(nil)
		aObj:addSkinFrame{obj=_G.GarrisonMonumentFrame, ft=ftype, ofs=-10, y2=6}
		aObj:addButtonBorder{obj=_G.GarrisonMonumentFrame.LeftBtn}
		aObj:addButtonBorder{obj=_G.GarrisonMonumentFrame.RightBtn}

	end

	-->>-- GarrisonRecruiterUI
	local function skinGarrisonRecruiterUI()

		_G.GarrisonRecruiterFrame.Pick.Line1:SetTexture(nil)
		_G.GarrisonRecruiterFrame.Pick.Line2:SetTexture(nil)
		aObj:skinDropDown{obj=_G.GarrisonRecruiterFrame.Pick.ThreatDropDown}
		aObj:addSkinFrame{obj=_G.GarrisonRecruiterFrame, ft=ftype, kfs=true, ri=true, ofs=1, y1=2}

		-- GarrisonRecruitSelect Frame
		-- FollowerList
		local fl = _G.GarrisonRecruitSelectFrame.FollowerList
		fl:DisableDrawLayer("BORDER")
		skinFollowerList(fl)
		-- Follower Selection
		local fs = _G.GarrisonRecruitSelectFrame.FollowerSelection
		fs:DisableDrawLayer("BORDER")
		fs.Line1:SetTexture(nil)
		fs.Line2:SetTexture(nil)
		for i = 1, 3 do
			local btn = fs["Recruit" .. i]
			btn.PortraitFrame.PortraitRing:SetTexture(nil)
			btn.PortraitFrame.LevelBorder:SetTexture(nil)
			btn.PortraitFrame.PortraitRingQuality:SetVertexColor(btn.PortraitFrame.LevelBorder:GetVertexColor())
		end
		aObj:addSkinFrame{obj=_G.GarrisonRecruitSelectFrame, ft=ftype, kfs=true, ofs=2}

	end

	-->>-- GarrisonShipyardUI
	local function skinGarrisonShipyardUI()

		-- wooden frame around dialog
		aObj:keepFontStrings(_G.GarrisonShipyardFrame.BorderFrame)
		aObj:moveObject{obj=_G.GarrisonShipyardFrame.BorderFrame.TitleText, y=3}

		-- Shipyard Frame
		aObj:addSkinFrame{obj=_G.GarrisonShipyardFrame, ft=ftype, kfs=true, ofs=2, x2=1, y2=-4}
		-- tabs
		aObj:skinTabs{obj=_G.GarrisonShipyardFrame, regs={9, 10}, ignore=true, lod=true, x1=9, y1=2, x2=-9, y2=0}

		-- List of ships (FollowerList)
		local fl = _G.GarrisonShipyardFrame.FollowerList
		fl:DisableDrawLayer("BORDER")
		fl.MaterialFrame:DisableDrawLayer("BACKGROUND")
		skinFollowerList(fl)

	-->>-- Naval Map Tab (MissionTab)
		-- Mission List
		local ml = _G.GarrisonShipyardFrame.MissionTab.MissionList
		ml.MapTexture:SetDrawLayer("BORDER", -2) -- make sure it appears above skinFrame but below other textures

		-- Fog overlays

		-- CompleteDialog
		skinCompleteDialog(ml)

		-- MissionPage
		local mp = _G.GarrisonShipyardFrame.MissionTab.MissionPage
		skinMissionPage(mp)
		for i = 1, #mp.Enemies do
			local frame = mp.Enemies[i]
			frame.PortraitRing:SetTexture(nil)
		end
		for i = 1, #mp.Followers do
			local frame = mp.Followers[i]
			for i = 1, #frame.Counters do
				-- Counters buttons
				frame.Counters[i].Border:SetTexture(nil)
				aObj:addButtonBorder{obj=frame.Counters[i], relTo=frame.Counters[i].Icon}
			end
		end

	-->>-- Fleet Tab (FollowerTab)
		-- FollowerTab
		local ft = _G.GarrisonShipyardFrame.FollowerTab
		ft:DisableDrawLayer("BORDER")
		skinFollowerTraitsAndEquipment(ft)

		-- MissionComplete
		local mc = _G.GarrisonShipyardFrame.MissionComplete
		skinMissionComplete(mc)
		for i = 1, #mc.Stage.EncountersFrame.Encounters do
			local frame = mc.Stage.EncountersFrame.Encounters[i]
			frame.PortraitRing:SetTexture(nil)
		end
		aObj:keepRegions(mc.Stage.MissionInfo, {6, 7}) -- N.B. 6 & 7 are MissionType & Title

	end

	-->>-- Tooltips
	local function skinGarrisonTooltips()

		aObj:addSkinFrame{obj=_G.GarrisonMissionMechanicTooltip, ft=ftype}
		aObj:addSkinFrame{obj=_G.GarrisonMissionMechanicFollowerCounterTooltip, ft=ftype}

		aObj:addSkinFrame{obj=_G.GarrisonBonusAreaTooltip, ft=ftype}
		aObj:addSkinFrame{obj=_G.GarrisonShipyardMapMissionTooltip, ft=ftype}

	end

	skinGarrisonBuildingUI()
	skinGarrisonCapacitiveDisplay()
	skinGarrisonLandingPage()
	skinGarrisonMissionUI()
	skinGarrisonMonumentUI()
	skinGarrisonRecruiterUI()
	skinGarrisonShipyardUI()
	skinGarrisonTooltips()

	-- N.B. Garrison Landing Page Minimap Button skinned with other minimap buttons

end

-- N.B. The following function has been separated from the GarrisonUI skin code as it is used by several Quest Frames
function aObj:GarrisonTooltips()
	if not self.db.profile.GarrisonUI then return end

	_G.GarrisonFollowerTooltip.Portrait.PortraitRing:SetTexture(nil)
	_G.GarrisonFollowerTooltip.Portrait.LevelBorder:SetAlpha(0)
	aObj:addSkinFrame{obj=_G.GarrisonFollowerTooltip, ft=ftype}

	_G.GarrisonFollowerAbilityTooltip.CounterIconBorder:SetTexture(nil)
	aObj:addSkinFrame{obj=_G.GarrisonFollowerAbilityTooltip, ft=ftype}

	self:addSkinFrame{obj=_G.GarrisonShipyardFollowerTooltip, ft=ftype}

	_G.FloatingGarrisonFollowerTooltip.Portrait.PortraitRing:SetTexture(nil)
	_G.FloatingGarrisonFollowerTooltip.Portrait.LevelBorder:SetAlpha(0)
	aObj:addSkinFrame{obj=_G.FloatingGarrisonFollowerTooltip, ft=ftype}

	self:addSkinFrame{obj=_G.FloatingGarrisonShipyardFollowerTooltip, ft=ftype}

	_G.FloatingGarrisonFollowerAbilityTooltip.CounterIconBorder:SetTexture(nil)
	aObj:addSkinFrame{obj=_G.FloatingGarrisonFollowerAbilityTooltip, ft=ftype}

	aObj:addSkinFrame{obj=_G.FloatingGarrisonMissionTooltip, ft=ftype}

end

function aObj:GMChatUI() -- LoD
	if not self.db.profile.GMChatUI or self.initialized.GMChatUI then return end
	self.initialized.GMChatUI = true

-->>-- GM Chat Request frame
	_G.GMChatStatusFrame:DisableDrawLayer("BORDER")
	_G.GMChatStatusFrame:DisableDrawLayer("OVERLAY")
	self:addSkinFrame{obj=_G.GMChatStatusFrame, ft=ftype, anim=true, x1=30, y1=-12, x2=-30, y2=12}

-->>-- GMChat Frame
	if self.db.profile.ChatFrames then
		self:addSkinFrame{obj=_G.GMChatFrame, ft=ftype, x1=-4, y1=4, x2=4, y2=-8, nb=true}
	end
	self:skinButton{obj=_G.GMChatFrameCloseButton, cb=true}
	_G.GMChatFrame:DisableDrawLayer("BORDER")

-->>-- GMChatFrameEditBox
	if self.db.profile.ChatEditBox.skin then
		if self.db.profile.ChatEditBox.style == 1 then -- Frame
			local kRegions = _G.CopyTable(self.ebRgns)
			aObj:add2Table(kRegions, 12)
			self:keepRegions(_G.GMChatFrame.editBox, kRegions)
			self:addSkinFrame{obj=_G.GMChatFrame.editBox, ft=ftype, x1=2, y1=-2, x2=-2}
		elseif self.db.profile.ChatEditBox.style == 2 then -- Editbox
			self:skinEditBox{obj=_G.GMChatFrame.editBox, regs={12}, noHeight=true}
		else -- Borderless
			self:removeRegions(_G.GMChatFrame.editBox, {6, 7, 8})
			self:addSkinFrame{obj=_G.GMChatFrame.editBox, ft=ftype, noBdr=true, x1=5, y1=-4, x2=-5, y2=2}
		end
	end

-->>-- GMChat Frame Tab
	self:addSkinFrame{obj=_G.GMChatTab, kfs=true, ft=ftype, noBdr=self.isTT, y2=-4}

end

function aObj:GMSurveyUI() -- LoD
	if not self.db.profile.GMSurveyUI or self.initialized.GMSurveyUI then return end
	self.initialized.GMSurveyUI = true

	self:keepFontStrings(_G.GMSurveyHeader)
	self:moveObject{obj=_G.GMSurveyHeaderText, y=-8}
	self:addSkinFrame{obj=_G.GMSurveyFrame, ft=ftype, kfs=true, y1=-6, x2=-45}

	self:skinScrollBar{obj=_G.GMSurveyScrollFrame}

	for i = 1, _G.MAX_SURVEY_QUESTIONS do
		local obj = _G["GMSurveyQuestion" .. i]
		self:applySkin{obj=obj, ft=ftype} -- must use applySkin otherwise text is behind gradient
		obj.SetBackdropColor = function() end
		obj.SetBackdropBorderColor = function() end
	end

	self:skinScrollBar{obj=_G.GMSurveyCommentScrollFrame}
	self:applySkin{obj=_G.GMSurveyCommentFrame, ft=ftype} -- must use applySkin otherwise text is behind gradient

end

function aObj:GuildBankUI() -- LoD
	if not self.db.profile.GuildBankUI or self.initialized.GuildBankUI then return end
	self.initialized.GuildBankUI = true

-->>--	Main Frame
	_G.GuildBankEmblemFrame:Hide()
	for i = 1, _G.NUM_GUILDBANK_COLUMNS do
		local objName = "GuildBankColumn" .. i
		_G[objName .. "Background"]:SetAlpha(0)
	end
	self:skinEditBox{obj=_G.GuildItemSearchBox, regs={9, 10}, mi=true, noHeight=true, noMove=true}
	self:skinTabs{obj=_G.GuildBankFrame, lod=true}
	_G.GuildBankMoneyFrameBackground:DisableDrawLayer("BACKGROUND")
	self:addSkinFrame{obj=_G.GuildBankFrame, ft=ftype, kfs=true, hdr=true, x1=-3, y1=2, x2=1, y2=-5}
-->>--	Log Frame
	self:skinScrollBar{obj=_G.GuildBankTransactionsScrollFrame}

-->>--	Info Frame
	self:skinScrollBar{obj=_G.GuildBankInfoScrollFrame}

-->>--	GuildBank Popup Frame
	self:skinEditBox{obj=_G.GuildBankPopupEditBox, regs={9}}
	self:skinScrollBar{obj=_G.GuildBankPopupScrollFrame}
	self:addSkinFrame{obj=_G.GuildBankPopupFrame, ft=ftype, kfs=true, hdr=true, x1=2, y1=-12, x2=-24, y2=24}
	for i = 1, 16 do
		local btn = _G["GuildBankPopupButton" .. i]
		btn:DisableDrawLayer("BACKGROUND")
		self:addButtonBorder{obj=btn}
	end

-->>--	Tabs (side)
	for i = 1, _G.MAX_GUILDBANK_TABS do
		local objName = "GuildBankTab" .. i
		_G[objName]:DisableDrawLayer("BACKGROUND")
		self:addButtonBorder{obj=_G[objName .. "Button"], relTo=_G[objName .. "ButtonIconTexture"]}
	end

	-- send message when UI is skinned (used by oGlow skin)
	self:SendMessage("GuildBankUI_Skinned", self)

end

function aObj:HelpFrame()
	if not self.db.profile.HelpFrame or self.initialized.HelpFrame then return end
	self.initialized.HelpFrame = true

	self:keepFontStrings(_G.HelpFrame.header)
	self:moveObject{obj=_G.HelpFrame.header, y=-12}
	self:removeInset(_G.HelpFrame.leftInset)
	self:removeInset(_G.HelpFrame.mainInset)
	for i = 1, 6 do
		local btn = _G.HelpFrame["button" .. i]
		btn:GetNormalTexture():SetTexture(nil)
		btn:GetPushedTexture():SetTexture(nil)
	end
	_G.HelpFrame.button16:GetNormalTexture():SetTexture(nil)
	self:addSkinFrame{obj=_G.HelpFrame, ft=ftype, kfs=true, ofs=-10, y2=7}
	-- Account Security panel
	_G.HelpFrame.asec.ticketButton:GetNormalTexture():SetTexture(nil)
	_G.HelpFrame.asec.ticketButton:GetPushedTexture():SetTexture(nil)
	-- Character Stuck! panel
	self:addButtonBorder{obj=_G.HelpFrameCharacterStuckHearthstone, es=20}
	-- Report Bug panel
	self:skinSlider{obj=_G.HelpFrameReportBugScrollFrame.ScrollBar, size=3}
	self:addSkinFrame{obj=self:getChild(_G.HelpFrame.bug, 3), ft=ftype}
	-- Submit Suggestion panel
	self:skinSlider{obj=_G.HelpFrameSubmitSuggestionScrollFrame.ScrollBar, size=3}
	self:addSkinFrame{obj=self:getChild(_G.HelpFrame.suggestion, 3), ft=ftype}
	-- Help Browser
	self:removeInset(_G.HelpBrowser.BrowserInset)
	self:addButtonBorder{obj=_G.HelpBrowser.settings, ofs=-2}
	self:addButtonBorder{obj=_G.HelpBrowser.home, ofs=-2}
	self:addButtonBorder{obj=_G.HelpBrowser.back, ofs=-2}
	self:addButtonBorder{obj=_G.HelpBrowser.forward, ofs=-2}
	self:addButtonBorder{obj=_G.HelpBrowser.reload, ofs=-2}
	self:addButtonBorder{obj=_G.HelpBrowser.stop, ofs=-2}
	-- Knowledgebase (uses Browser frame)
	-- GM_Response
	self:skinScrollBar{obj=_G.HelpFrameGM_ResponseScrollFrame1}
	self:skinScrollBar{obj=_G.HelpFrameGM_ResponseScrollFrame2}
	self:addSkinFrame{obj=self:getChild(_G.HelpFrameGM_Response, 5), ft=ftype}
	self:addSkinFrame{obj=self:getChild(_G.HelpFrameGM_Response, 6), ft=ftype}

	-- BrowserSettings Tooltip
	_G.BrowserSettingsTooltip:DisableDrawLayer("BACKGROUND")
	self:addSkinFrame{obj=_G.BrowserSettingsTooltip, ft=ftype}

	-- TicketStatus Frame
	self:addSkinFrame{obj=_G.TicketStatusFrameButton}
	-- ReportPlayerName Dialog
	self:addSkinFrame{obj=_G.ReportPlayerNameDialog.CommentFrame, ft=ftype, kfs=true, y2=-2}
	_G.ReportPlayerNameDialog.CommentFrame.EditBox.InformationText:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:addSkinFrame{obj=_G.ReportPlayerNameDialog, ft=ftype}
	-- ReportCheating Dialog
	self:addSkinFrame{obj=_G.ReportCheatingDialog.CommentFrame, ft=ftype, kfs=true, y2=-2}
	_G.ReportCheatingDialog.CommentFrame.EditBox.InformationText:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:addSkinFrame{obj=_G.ReportCheatingDialog, ft=ftype}

end

function aObj:ItemText()
	if not self.db.profile.ItemText or self.initialized.ItemText then return end
	self.initialized.ItemText = true

	self:SecureHookScript(_G.ItemTextFrame, "OnShow", function(this)
		_G.ItemTextPageText:SetTextColor(self.BTr, self.BTg, self.BTb)
	end)

	self:skinScrollBar{obj=_G.ItemTextScrollFrame}
	self:glazeStatusBar(_G.ItemTextStatusBar, 0)
	self:moveObject{obj=_G.ItemTextPrevPageButton, x=-55} -- move prev button left
	self:addButtonBorder{obj=_G.ItemTextPrevPageButton, ofs=-2, y1=-3, x2=-3}
	self:addButtonBorder{obj=_G.ItemTextNextPageButton, ofs=-2, y1=-3, x2=-3}
	self:addSkinFrame{obj=_G.ItemTextFrame, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-2}

end

function aObj:LevelUpDisplay()
	if not self.db.profile.LevelUpDisplay or self.initialized.LevelUpDisplay then return end
	self.initialized.LevelUpDisplay = true

	_G.LevelUpDisplay:DisableDrawLayer("BACKGROUND")
	-- sub frames
	_G.LevelUpDisplay.scenarioBits:DisableDrawLayer("BACKGROUND")
	_G.LevelUpDisplay.scenarioBits:DisableDrawLayer("BORDER")
	_G.LevelUpDisplay.scenarioFiligree:DisableDrawLayer("OVERLAY")
	_G.LevelUpDisplay.challengeModeBits:DisableDrawLayer("BORDER")
	_G.LevelUpDisplay.challengeModeBits.BottomFiligree:SetTexture(nil)
	local dtf = _G.LevelUpDisplay.DraenorTalentFrame
	dtf:DisableDrawLayer("BORDER")
	-- dtf.descriptionshadow:SetTexture(nil)
	-- self:addButtonBorder{obj=dtf, relTo=dtf.Icon}
	self:addButtonBorder{obj=dtf, relTo=dtf.Icon2} -- starts on RHS as Icon, finishes on LHS

end

function aObj:LFDFrame()
	if not self.db.profile.LFDFrame or self.initialized.LFDFrame then return end
	self.initialized.LFDFrame = true

	-- LFD RoleCheck Popup
	self:addSkinFrame{obj=_G.LFDRoleCheckPopup, kfs=true, ft=ftype}

	-- LFD Parent Frame (now part of PVE Frame)
	self:keepFontStrings(_G.LFDParentFrame)
	self:removeInset(_G.LFDParentFrame.Inset)

	-- LFD Queue Frame
	_G.LFDQueueFrameBackground:SetAlpha(0)
	self:skinDropDown{obj=_G.LFDQueueFrameTypeDropDown}
	self:skinSlider{obj=_G.LFDQueueFrameRandomScrollFrame.ScrollBar}
	self:removeMagicBtnTex(_G.LFDQueueFrameFindGroupButton)
	if self.modBtnBs then
		self:SecureHook("LFDQueueFrameRandom_UpdateFrame", function()
			for i = 1, 5 do
				local btnName = "LFDQueueFrameRandomScrollFrameChildFrameItem" .. i
				if _G[btnName] then
					_G[btnName .. "NameFrame"]:SetTexture(nil)
					self:addButtonBorder{obj=_G[btnName], libt=true}
				end
			end
		end)
	end
	self:skinButton{obj=_G.LFDQueueFrameRandomScrollFrameChildFrame.bonusRepFrame.ChooseButton, as=true}
	self:addButtonBorder{obj=_G.LFDQueueFrameRandomScrollFrameChildFrame.MoneyReward, libt=true}
	_G.LFDQueueFrameRandomScrollFrameChildFrame.MoneyReward.NameFrame:SetTexture(nil)

	-- Specific List subFrame
	for i = 1, _G.NUM_LFD_CHOICE_BUTTONS do
		local btn = "LFDQueueFrameSpecificListButton" .. i .. "ExpandOrCollapseButton"
		self:skinButton{obj=_G[btn], mp2=true}
	end
	self:skinScrollBar{obj=_G.LFDQueueFrameSpecificListScrollFrame}

end

function aObj:LFGFrame()
	if not self.db.profile.LFGFrame or self.initialized.LFGFrame then return end
	self.initialized.LFGFrame = true

	-- LFG DungeonReady Popup a.k.a. ReadyCheck
	self:addSkinFrame{obj=_G.LFGDungeonReadyStatus, kfs=true, ft=ftype, ofs=-5}
	self:addSkinFrame{obj=_G.LFGDungeonReadyDialog, kfs=true, ft=ftype, ofs=-5}
	_G.LFGDungeonReadyDialog.SetBackdrop = function() end
	_G.LFGDungeonReadyDialogRewardsFrameReward1Border:SetAlpha(0)
	_G.LFGDungeonReadyDialogRewardsFrameReward2Border:SetAlpha(0)

	-- hook new button creation
	self:RawHook("LFGRewardsFrame_SetItemButton", function(...)
		local frame = self.hooks.LFGRewardsFrame_SetItemButton(...)
		_G[frame:GetName() .. "NameFrame"]:SetTexture(nil)
		self:addButtonBorder{obj=frame, libt=true}
		return frame
	end, true)

	-- LFGInvitePopup (Premade Groups?)
	self:addSkinFrame{obj=_G.LFGInvitePopup, ft=ftype}

end

function aObj:LFRFrame()
	if not self.db.profile.LFRFrame or self.initialized.LFRFrame then return end
	self.initialized.LFRFrame = true

	self:addSkinFrame{obj=_G.RaidBrowserFrame, ft=ftype, kfs=true, x1=-3, y1=2, x2=1, y2=-2}

	-- LFR Parent Frame
	-- LFR Queue Frame
	self:removeInset(_G.LFRQueueFrameRoleInset)
	self:removeInset(_G.LFRQueueFrameCommentInset)
	self:removeInset(_G.LFRQueueFrameListInset)
	_G.LFRQueueFrameCommentExplanation:SetTextColor(self.BTr, self.BTg, self.BTb)

	-- Specific List subFrame
	for i = 1, _G.NUM_LFR_CHOICE_BUTTONS do
		local btn = "LFRQueueFrameSpecificListButton" .. i .. "ExpandOrCollapseButton"
		self:skinButton{obj=_G[btn], mp2=true}
		self:moveObject{obj=_G[btn .. "Highlight"], x=-3} -- move highlight to the left
	end
	self:skinScrollBar{obj=_G.LFRQueueFrameSpecificListScrollFrame}

	-- LFR Browse Frame
	self:removeInset(_G.LFRBrowseFrameRoleInset)
	self:skinDropDown{obj=_G.LFRBrowseFrameRaidDropDown}
	self:skinScrollBar{obj=_G.LFRBrowseFrameListScrollFrame}
	self:keepFontStrings(_G.LFRBrowseFrame)

	-- Tabs (side)
	for i = 1, 2 do
		local obj = _G["LFRParentFrameSideTab" .. i]
		obj:DisableDrawLayer("BACKGROUND")
		self:addButtonBorder{obj=obj}
	end

end

function aObj:MacroUI() -- LoD
	if not self.db.profile.MenuFrames or self.initialized.MacroUI then return end
	self.initialized.MacroUI = true

-->>-- Macro Frame
	self:skinScrollBar{obj=_G.MacroButtonScrollFrame}
	self:skinScrollBar{obj=_G.MacroFrameScrollFrame}
	self:skinEditBox{obj=_G.MacroFrameText, noSkin=true}
	self:addSkinFrame{obj=_G.MacroFrameTextBackground, ft=ftype, x2=1}
	self:skinTabs{obj=_G.MacroFrame, up=true, lod=true, x1=-3, y1=-3, x2=3, y2=-3, hx=-2, hy=3}
	self:addSkinFrame{obj=_G.MacroFrame, ft=ftype, kfs=true, hdr=true, ri=true, x1=-3, y1=2, x2=1, y2=-2}
	-- add button borders
	local btn = _G["MacroFrameSelectedMacroButton"]
	btn:DisableDrawLayer("BACKGROUND")
	self:addButtonBorder{obj=btn, relTo=_G["MacroFrameSelectedMacroButtonIcon"]}
	for i = 1, _G.MAX_ACCOUNT_MACROS do
		local btn = _G["MacroButton" .. i]
		btn:DisableDrawLayer("BACKGROUND")
		self:addButtonBorder{obj=btn, relTo=_G["MacroButton" .. i .. "Icon"], spbt=true}
	end

-->>-- Macro Popup Frame
	self:skinEditBox{obj=_G.MacroPopupEditBox}
	self:skinScrollBar{obj=_G.MacroPopupScrollFrame}
	self:addSkinFrame{obj=_G.MacroPopupFrame, ft=ftype, kfs=true, x1=8, y1=-8, x2=-2, y2=4}
	-- add button borders
	for i = 1, _G.NUM_MACRO_ICONS_SHOWN do
		local btn = _G["MacroPopupButton" .. i]
		btn:DisableDrawLayer("BACKGROUND")
		self:addButtonBorder{obj=btn, relTo=_G["MacroPopupButton" .. i .. "Icon"], spbt=true}
	end

end

function aObj:MailFrame()
	if not self.db.profile.MailFrame or self.initialized.MailFrame then return end
	self.initialized.MailFrame = true

	self:skinTabs{obj=_G.MailFrame}
	self:addSkinFrame{obj=_G.MailFrame, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-5}

-->>--	Inbox Frame
	for i = 1, _G.INBOXITEMS_TO_DISPLAY do
		self:keepFontStrings(_G["MailItem" .. i])
		local btn = _G["MailItem" .. i .. "Button"]
		btn:DisableDrawLayer("BACKGROUND")
		self:addButtonBorder{obj=btn, ofs=3}
	end
	self:moveObject{obj=_G.InboxTooMuchMail, y=-24} -- move icon down
	self:removeRegions(_G.InboxFrame, {1}) -- background texture
	self:addButtonBorder{obj=_G.InboxPrevPageButton, ofs=-2, y1=-3, x2=-3}
	self:addButtonBorder{obj=_G.InboxNextPageButton, ofs=-2, y1=-3, x2=-3}

-->>--	Send Mail Frame
	self:keepFontStrings(_G.SendMailFrame)
	self:skinScrollBar{obj=_G.SendMailScrollFrame}
	for i = 1, _G.ATTACHMENTS_MAX_SEND do
		local btn = _G["SendMailAttachment" .. i]
		if not self.modBtnBs then
			self:resizeEmptyTexture(self:getRegion(btn, 1))
		else
			btn:DisableDrawLayer("BACKGROUND")
			self:addButtonBorder{obj=btn, ofs=3}
		end
	end
	self:skinEditBox{obj=_G.SendMailNameEditBox, regs={6}, noWidth=true} -- N.B. region 6 is text
	self:skinEditBox{obj=_G.SendMailSubjectEditBox, regs={6}, noWidth=true} -- N.B. region 6 is text
	self:skinEditBox{obj=_G.SendMailBodyEditBox, noSkin=true}
	local c = self.db.profile.BodyText
	_G.SendMailBodyEditBox:SetTextColor(c.r, c.g, c.b)
	self:skinMoneyFrame{obj=_G.SendMailMoney, moveSEB=true, moveGEB=true, noWidth=true}
	self:removeInset(_G.SendMailMoneyInset)
	_G.SendMailMoneyBg:DisableDrawLayer("BACKGROUND")

-->>--	Open Mail Frame
	self:skinScrollBar{obj=_G.OpenMailScrollFrame}
	_G.OpenMailBodyText:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:addSkinFrame{obj=_G.OpenMailFrame, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-2}
	self:addButtonBorder{obj=_G.OpenMailLetterButton, ibt=true, ofs=3}
	self:addButtonBorder{obj=_G.OpenMailMoneyButton, ibt=true, ofs=3}
	for i = 1, _G.ATTACHMENTS_MAX_RECEIVE do
		local btn = _G["OpenMailAttachmentButton" .. i]
		self:addButtonBorder{obj=btn, ibt=true, ofs=3}
	end
-->>-- Invoice Frame Text fields
	for _, v in pairs{"ItemLabel", "Purchaser", "BuyMode", "SalePrice", "Deposit", "HouseCut", "AmountReceived", "NotYetSent", "MoneyDelay"} do
		_G["OpenMailInvoice" .. v]:SetTextColor(self.BTr, self.BTg, self.BTb)
	end

end

function aObj:MainMenuBar()
	if not self.db.profile.MainMenuBar.skin or self.initialized.MainMenuBar then return end
	self.initialized.MainMenuBar = true

	_G.ExhaustionTick:SetAlpha(0)
	self:adjHeight{obj=_G.MainMenuExpBar, adj=-2} -- shrink it so it moves up
	self:keepRegions(_G.MainMenuExpBar, {1, 5, 6}) -- N.B. region 1 is rested XP, 5 is background, 6 is the normal XP
	self:adjHeight{obj=_G.ExhaustionLevelFillBar, adj=-1} -- mirror the XP bar
	local yOfs = IsAddOnLoaded("DragonCore") and -47 or -4
	self:addSkinFrame{obj=_G.MainMenuBar, ft=ftype, noBdr=true, x1=-4, y1=-5, x2=4, y2=yOfs}
	self:keepFontStrings(_G.MainMenuBarMaxLevelBar)
	self:keepFontStrings(_G.MainMenuBarArtFrame)
	self:moveObject{obj=_G.ReputationWatchBar, y=3} -- move it above MainMenuBar
	self:keepRegions(_G.ReputationWatchStatusBar, {9, 10}) -- 9 is background, 10 is the normal texture
	self:adjHeight{obj=_G.ReputationWatchStatusBar, adj=1}
	self:moveObject{obj=_G.ReputationWatchStatusBarText, y=-1} -- centre text on bar
	if self.db.profile.MainMenuBar.glazesb then
		self:glazeStatusBar(_G.MainMenuExpBar, 0, self:getRegion(_G.MainMenuExpBar, 5), {_G.ExhaustionLevelFillBar})
		_G.ExhaustionLevelFillBar:SetAlpha(0.75) -- increase alpha value to make it more visible
		self:glazeStatusBar(_G.ReputationWatchStatusBar, 0, _G.ReputationWatchStatusBarBackground)
	end

	-- StanceBar Frame
	self:keepFontStrings(_G.StanceBarFrame)
	for i = 1, _G.NUM_STANCE_SLOTS do
		self:addButtonBorder{obj=_G["StanceButton" .. i], abt=true, sec=true}
	end
	-- Possess Bar Frame
	self:keepFontStrings(_G.PossessBarFrame)
	for i = 1, _G.NUM_POSSESS_SLOTS do
		self:addButtonBorder{obj=_G["PossessButton" .. i], abt=true, sec=true}
	end
	-- Pet Action Bar Frame
	self:keepFontStrings(_G.PetActionBarFrame)
	for i = 1, _G.NUM_PET_ACTION_SLOTS do
		local btnName = "PetActionButton" .. i
		self:addButtonBorder{obj=_G[btnName], abt=true, sec=true, reParent={_G[btnName .. "AutoCastable"]}, ofs=3}
	end
	-- Shaman's Totem Frame
	self:keepFontStrings(_G.MultiCastFlyoutFrame)

-->>-- Action Buttons
	for i = 1, _G.NUM_ACTIONBAR_BUTTONS do
		local btn = _G["ActionButton" .. i]
		btn.FlyoutBorder:SetTexture(nil)
		btn.FlyoutBorderShadow:SetTexture(nil)
		btn.Border:SetAlpha(0) -- texture changed in blizzard code
		self:addButtonBorder{obj=btn, abt=true, sec=true}
	end

	-- Micro buttons, skinned before checks for a consistent look, 12.10.12
	local mbs = {"Character", "Spellbook", "Talent", "Achievement", "QuestLog", "Guild", "LFD", "Collections", "EJ", "Store"}
	for _, v in pairs(mbs) do
		self:addButtonBorder{obj=_G[v .. "MicroButton"], mb=true, ofs=0, y1=-21}
	end
	self:addButtonBorder{obj=_G.MainMenuMicroButton, mb=true, ofs=0, y1=-21, reParent={_G.MainMenuBarPerformanceBar, _G.MainMenuBarDownload}}
	self:addButtonBorder{obj=_G.FriendsMicroButton, x1=1, y1=1, x2=-2, y2=-1} -- on ChatFrame

-->>-- add button borders
	-- Bag buttons
	self:addButtonBorder{obj=_G.MainMenuBarBackpackButton}
	self:addButtonBorder{obj=_G.MultiCastSummonSpellButton, abt=true, sec=true, ofs=5}
	self:addButtonBorder{obj=_G.MultiCastRecallSpellButton, abt=true, sec=true, ofs=5}
	for i = 1, _G.NUM_MULTI_CAST_PAGES * _G.NUM_MULTI_CAST_BUTTONS_PER_PAGE do
		self:addButtonBorder{obj=_G["MultiCastActionButton" .. i], abt=true, sec=true, ofs=5}
	end
	-- ActionBar buttons
	self:addButtonBorder{obj=_G.ActionBarUpButton, es=12, ofs=-5, x2=-6, y2=7}
	self:addButtonBorder{obj=_G.ActionBarDownButton, es=12, ofs=-5, x2=-6, y2=7}

-->>-- Vehicle Leave Button
	self:addSkinButton{obj=_G.MainMenuBarVehicleLeaveButton, ft=ftype}
	self:SecureHook("MainMenuBarVehicleLeaveButton_Update", function()
		self:moveObject{obj=_G.MainMenuBarVehicleLeaveButton, y=3}
	end)

-->>-- MicroButtonAlert frames
	self:skinButton{obj=_G.TalentMicroButtonAlert.CloseButton, cb=true}
	self:skinButton{obj=_G.CollectionsMicroButtonAlert.CloseButton, cb=true}
	self:skinButton{obj=_G.LFDMicroButtonAlert.CloseButton, cb=true}

-->>-- Extra Action Button
	if self.db.profile.MainMenuBar.extraab then
		self:addButtonBorder{obj=_G.ExtraActionButton1, relTo=_G.ExtraActionButton1.icon, ofs=1}
		-- handle bug when Tukui is loaded
		if not aObj:isAddonEnabled("Tukui") then
			_G.ExtraActionButton1.style:SetTexture(nil)
			_G.ExtraActionButton1.style.SetTexture = function() end
		end
	end

-->>-- UnitPowerBarAlt (inc. PlayerPowerBarAlt)
	local function skinUnitPowerBarAlt(upba)
		-- Don't change the status bar texture as it changes dependant upon type of power type required
		upba.frame:SetAlpha(0)
		upba.counterBar:DisableDrawLayer("BACKGROUND")
		upba.counterBar:DisableDrawLayer("ARTWORK")
	end
	self:SecureHook("UnitPowerBarAlt_SetUp", function(this, barID)
		skinUnitPowerBarAlt(this)
	end)
	-- skin PlayerPowerBarAlt if already shown
	if _G.PlayerPowerBarAlt:IsVisible() then
		skinUnitPowerBarAlt(_G.PlayerPowerBarAlt)
	end

-->>-- MultiBar Buttons
	for _, v in pairs{"BottomLeft", "BottomRight", "Right", "Left"} do
		for i = 1, _G.NUM_MULTIBAR_BUTTONS do
			local btn = _G["MultiBar" .. v .. "Button" .. i]
			btn.FlyoutBorder:SetTexture(nil)
			btn.FlyoutBorderShadow:SetTexture(nil)
			btn.Border:SetAlpha(0) -- texture changed in blizzard code
			_G["MultiBar" .. v .. "Button" .. i .. "FloatingBG"]:SetAlpha(0)
			self:addButtonBorder{obj=btn, abt=true, sec=true}
		end
	end

	-- hook this to hide button grid after it has been shown
	self:SecureHook("ActionButton_HideGrid", function(btn)
		if ( _G[btn:GetName() .. "NormalTexture"] ) then
			_G[btn:GetName() .. "NormalTexture"]:SetVertexColor(1.0, 1.0, 1.0, 0)
		end
	end)

end

function aObj:MenuFrames()
	if not self.db.profile.MenuFrames or self.initialized.MenuFrames then return end
	self.initialized.MenuFrames = true

-->>-- Game Menu Frame
	self:addSkinFrame{obj=_G.GameMenuFrame, ft=ftype, kfs=true, hdr=true}

-->>-- System
	self:addSkinFrame{obj=_G.VideoOptionsFrame, ft=ftype, kfs=true, hdr=true}
	self:addSkinFrame{obj=_G.VideoOptionsFrameCategoryFrame, ft=ftype, kfs=true}
	self:skinSlider(_G.VideoOptionsFrameCategoryFrameListScrollBar)
	self:addSkinFrame{obj=_G.VideoOptionsFramePanelContainer, ft=ftype}
	-- Graphics
	for _, child in ipairs{_G.Display_:GetChildren()} do
		if aObj:hasTextInName(child, "DropDown") then
			self:skinDropDown{obj=child}
		end
	end
	self:addSkinFrame{obj=_G.Display_, ft=ftype}
	for _, child in ipairs{_G.RaidGraphics_:GetChildren()} do
		if aObj:hasTextInName(child, "DropDown") then
			self:skinDropDown{obj=child}
		end
	end
	self:addSkinFrame{obj=_G.Graphics_, ft=ftype}
	self:addSkinFrame{obj=_G.RaidGraphics_, ft=ftype}
	for _, child in ipairs{_G.Graphics_:GetChildren()} do
		if aObj:hasTextInName(child, "DropDown") then
			self:skinDropDown{obj=child}
		end
	end
	-- Advanced
	for _, child in ipairs{_G.Advanced_:GetChildren()} do
		if aObj:hasTextInName(child, "DropDown") then
			self:skinDropDown{obj=child}
		end
	end
	self:skinDropDown{obj=_G.Advanced_MultisampleAlphaTest}
	-- Network
	-- Languages
	for _, child in ipairs{_G.InterfaceOptionsLanguagesPanel:GetChildren()} do
		if aObj:hasTextInName(child, "DropDown") then
			self:skinDropDown{obj=child}
		end
	end
-->>-- Mac Options
	if _G.IsMacClient() then
		-- Movie Recording
		for _, child in ipairs{_G.MovieRecordingOptionsPanel:GetChildren()} do
			if aObj:hasTextInName(child, "DropDown") then
				self:skinDropDown{obj=child}
			end
		end
		-- iTunes Remote
		-- Keyboard Options
	end

	-- Sound
	self:addSkinFrame{obj=_G.AudioOptionsSoundPanel, ft=ftype}
	self:addSkinFrame{obj=_G.AudioOptionsSoundPanelPlayback, ft=ftype}
	self:skinDropDown{obj=_G.AudioOptionsSoundPanelHardwareDropDown}
	self:skinDropDown{obj=_G.AudioOptionsSoundPanelSoundChannelsDropDown}
	self:addSkinFrame{obj=_G.AudioOptionsSoundPanelHardware, ft=ftype}
	self:addSkinFrame{obj=_G.AudioOptionsSoundPanelVolume, ft=ftype}
	-- Voice
	self:addSkinFrame{obj=_G.AudioOptionsVoicePanel, ft=ftype}
	self:addSkinFrame{obj=_G.AudioOptionsVoicePanelTalking, ft=ftype}
	self:skinDropDown{obj=_G.AudioOptionsVoicePanelInputDeviceDropDown}
	self:skinButton{obj=_G.RecordLoopbackSoundButton, x1=-2, x2=2}
	self:skinButton{obj=_G.PlayLoopbackSoundButton, x1=-2, x2=2}
	self:addSkinFrame{obj=_G.LoopbackVUMeter:GetParent(), ft=ftype, aso={ng=true}, nb=true}
	self:glazeStatusBar(_G.LoopbackVUMeter) -- no background required
	self:addSkinFrame{obj=_G.AudioOptionsVoicePanelBinding, ft=ftype}
	self:skinDropDown{obj=_G.AudioOptionsVoicePanelChatModeDropDown}
	self:addSkinFrame{obj=_G.AudioOptionsVoicePanelListening, ft=ftype}
	self:skinDropDown{obj=_G.AudioOptionsVoicePanelOutputDeviceDropDown}
	self:addSkinFrame{obj=_G.VoiceChatTalkers, ft=ftype}

-->>-- Interface
	self:skinTabs{obj=_G.InterfaceOptionsFrame, up=true, lod=true, ignht=true, x1=6, y1=2, x2=-6, y2=-4}
	self:addSkinFrame{obj=_G.InterfaceOptionsFrame, ft=ftype, kfs=true, hdr=true}
	_G.InterfaceOptionsFrameCategoriesList:SetBackdrop(nil)
	self:skinScrollBar{obj=_G.InterfaceOptionsFrameCategoriesList, size=2}
	self:addSkinFrame{obj=_G.InterfaceOptionsFrameCategories, ft=ftype, kfs=true}
	_G.InterfaceOptionsFrameAddOnsList:SetBackdrop(nil)
	self:skinScrollBar{obj=_G.InterfaceOptionsFrameAddOnsList, size=2}
	self:addSkinFrame{obj=_G.InterfaceOptionsFrameAddOns, ft=ftype, kfs=true, bgen=1}
	self:addSkinFrame{obj=_G.InterfaceOptionsFramePanelContainer, ft=ftype, bgen=1}
	-- skin toggle buttons
	for i = 1, #_G.InterfaceOptionsFrameAddOns.buttons do
		self:skinButton{obj=_G.InterfaceOptionsFrameAddOns.buttons[i].toggle, mp2=true}
	end
	-- Social Browser Frame (Twitter integration)
	self:addSkinFrame{obj=_G.SocialBrowserFrame, ft=ftype, kfs=true, ofs=2, x2=0}

-->>-- Rating Menu
	self:addSkinFrame{obj=_G.RatingMenuFrame, ft=ftype, hdr=true}

-->>-- CompactUnitFrameProfiles
	_G.CompactUnitFrameProfiles.optionsFrame.autoActivateBG:SetTexture(nil)

	local function checkKids(obj)

		-- ignore named/AceConfig/XConfig/AceGUI objects
		if aObj:hasAnyTextInName(obj, {"AceConfig", "XConfig", "AceGUI"})
		or aObj.ignoreIOF[obj] -- ignore object if required
		then
			return
		end

		local kids = {obj:GetChildren()}
		for _, child in _G.ipairs(kids) do
			if not child.sf
			and not aObj:hasAnyTextInName(child, {"AceConfig", "XConfig", "AceGUI"})
			then
				-- aObj:Debug("checkKids: [%s]", child)
				if aObj:isDropDown(child)
				and not aObj.ignoreIOF[child]
				then
					local xOfs
					if aObj:hasTextInName(child, "PowaDropDownDefaultTimer") then
						xOfs = -90
					elseif aObj:hasTextInName(child, "PowaDropDownDefaultStacks") then
						xOfs = -110
					elseif aObj:hasTextInName(child, "oGlowOptFQualityThreshold")
					or aObj:hasTextInName(child, "BugSackFontSize")
					or aObj:hasTextInName(child, "BugSackSoundDropdown")
					then
						xOfs = 110
					end
					-- handle SushiDropdown (used by Bagnon)
					if aObj:hasTextInName(child, "SushiDropdown") then
						if not aObj:IsHooked(_G.SushiDropFrame, "OnCreate") then
							aObj:SecureHook(_G.SushiDropFrame, "OnCreate", function()
								-- Spew("SushiDropdown", SushiDropFrame)
								for _, frame in pairs(_G.SushiDropFrame.usedFrames) do
									if not frame.bg.sf then
										aObj:addSkinFrame{obj=frame.bg, kfs=true}
										frame.bg.SetBackdrop = function() end
									end
								end
							end)
							aObj:SecureHook(_G.SushiDropFrame, "OnAcquire", function(this)
								-- need to raise frame level so it's above other text
								_G.RaiseFrameLevelByTwo(this)
							end)
						end
					end
					aObj:skinDropDown{obj=child, x2=xOfs}
				elseif child:IsObjectType("EditBox")
				and not aObj.ignoreIOF[child]
				then
					-- handle SushiSlider Editboxes (used by Bagnon)
					if child:GetParent():GetName()
					and child:GetParent():GetName():find("SushiSlider")
					then
						aObj:skinEditBox{obj=child, regs={6, 7}}
						local slider = child:GetParent()
						-- stop width & backdrop being changed
						slider.UpdateEditWidth = function() end
						slider.EditBG:SetBackdrop(nil)
						-- move % character to the right
						slider.Suffix:SetPoint('RIGHT', slider.EditBG, 7, -3)
					else
						aObj:skinEditBox{obj=child, regs={9}}
					end
				elseif child:IsObjectType("ScrollFrame")
				and child:GetName()
				and child:GetName() .. "ScrollBar" -- handle named ScrollBar's
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
		kids = nil

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
		if panel
		and panel.GetNumChildren
		and not panel.sf
		and not self.ignoreIOF[panel]
		then
			self:addSkinFrame{obj=panel, ft=ftype, kfs=true, nb=true}
			self:ScheduleTimer(checkKids, 0.1, panel) -- wait for 1/10th second for panel to be populated
			self:ScheduleTimer("skinAllButtons", 0.1, {obj=panel, as=true, ft=ftype}) -- wait for 1/10th second for panel to be populated, always use applySkin to ensure text appears above button texture
		end
	end)

end

function aObj:Minimap()
	if not self.db.profile.Minimap.skin or self.initialized.Minimap then return end
	self.initialized.Minimap = true

	-- fix for Titan Panel moving MinimapCluster
	if IsAddOnLoaded("Titan") then _G.TitanMovable_AddonAdjust("MinimapCluster", true) end

-->>-- Cluster Frame
	_G.MinimapBorderTop:Hide()
	_G.MinimapZoneTextButton:ClearAllPoints()
	_G.MinimapZoneTextButton:SetPoint("BOTTOMLEFT", _G.Minimap, "TOPLEFT", 0, 5)
	_G.MinimapZoneTextButton:SetPoint("BOTTOMRIGHT", _G.Minimap, "TOPRIGHT", 0, 5)
	_G.MinimapZoneText:ClearAllPoints()
	_G.MinimapZoneText:SetPoint("CENTER")
	self:addSkinButton{obj=_G.MinimapZoneTextButton, parent=_G.MinimapZoneTextButton, ft=ftype}
	-- World Map Button
	_G.MiniMapWorldMapButton:ClearAllPoints()
	_G.MiniMapWorldMapButton:SetPoint("LEFT", _G.MinimapZoneTextButton, "RIGHT", -4, 0)
	self:skinButton{obj=_G.MiniMapWorldMapButton, ob="M"}

-->>-- Minimap
	_G.Minimap:SetMaskTexture([[Interface\Buttons\WHITE8X8]]) -- needs to be a square texture
	-- use a backdrop with no Texture otherwise the map tiles are obscured
	self:addSkinFrame{obj=_G.Minimap, ft=ftype, nb=true, aso={bd=8}, ofs=5}
	if self.db.profile.Minimap.gloss then
		_G.RaiseFrameLevel(_G.Minimap.sf)
	else
		_G.LowerFrameLevel(_G.Minimap.sf)
	end

-->>-- Minimap Backdrop Frame
	_G.MinimapBorder:SetAlpha(0)
	_G.MinimapNorthTag:SetAlpha(0)
	_G.MinimapCompassTexture:SetAlpha(0)

-->>-- Buttons
	-- on LHS
	local yOfs = -18 -- allow for GM Ticket button
	for _, v in pairs{_G.MiniMapTracking, _G.MiniMapLFGFrame, _G.MiniMapRecordingButton, _G.MiniMapVoiceChatFrame} do
		v:ClearAllPoints()
		v:SetPoint("TOPRIGHT", _G.Minimap, "TOPLEFT", 0, yOfs)
		yOfs = yOfs - v:GetHeight() + 3
	end
	-- on RHS
	_G.MiniMapMailFrame:ClearAllPoints()
	_G.MiniMapMailFrame:SetPoint("LEFT", _G.Minimap, "RIGHT", -10, 28)
	_G.MinimapZoomIn:ClearAllPoints()
	_G.MinimapZoomIn:SetPoint("BOTTOMLEFT", _G.Minimap, "BOTTOMRIGHT", -4, -3)
	_G.MinimapZoomOut:ClearAllPoints()
	_G.MinimapZoomOut:SetPoint("TOPRIGHT", _G.Minimap, "BOTTOMRIGHT", 3, 4)

	-- Difficulty indicators
	-- hook this to mamage MiniMapInstanceDifficulty texture
	self:SecureHook("MiniMapInstanceDifficulty_Update", function()
		local _, _, difficulty, _, maxPlayers, _, _ = _G.GetInstanceInfo()
		local _, _, isHeroic, _ = _G.GetDifficultyInfo(difficulty)
		local xOffset = 0
		if ( maxPlayers >= 10 and maxPlayers <= 19 ) then
			xOffset = -1
		end
		if isHeroic then
			_G.MiniMapInstanceDifficultyTexture:SetTexCoord(0.0, 0.25, 0.125, 0.5) -- remove top hanger texture
			_G.MiniMapInstanceDifficultyText:SetPoint("CENTER", xOffset, -1)
		else
			_G.MiniMapInstanceDifficultyTexture:SetTexCoord(0.0, 0.25, 0.625, 1) -- remove top hanger texture
			_G.MiniMapInstanceDifficultyText:SetPoint("CENTER", xOffset, 5)
		end
	end)
	self:moveObject{obj=_G.MiniMapInstanceDifficulty, x=6, y=-4}
	_G.GuildInstanceDifficultyHanger:SetAlpha(0)
	self:moveObject{obj=_G.GuildInstanceDifficulty, x=7}
	self:getRegion(_G.MiniMapChallengeMode, 1):SetTexCoord(0, 1, 0.27, 1.27) -- remove top hanger texture
	self:moveObject{obj=_G.MiniMapChallengeMode, x=6, y=-12}

	-- move BuffFrame
	self:moveObject{obj=_G.BuffFrame, x=-40}

	-- hook this to handle Jostle Library
	if _G.LibStub:GetLibrary("LibJostle-3.0", true) then
		self:RawHook(_G.MinimapCluster, "SetPoint", function(this, point, relTo, relPoint, xOfs, yOfs)
			self.hooks[this].SetPoint(this, point, relTo, relPoint, -6, -18)
		end, true)
	end

	self:moveObject{obj=_G.GarrisonLandingPageMinimapButton, x=0, y=-20}
	_G.GarrisonLandingPageMinimapButton.AlertBG:SetTexture(nil)

end

function aObj:MinimapButtons()
	if not self.db.profile.MinimapButtons.skin or self.initialized.MinimapButtons then return end
	self.initialized.MinimapButtons = true

	local minBtn = self.db.profile.MinimapButtons.style

	local function mmKids(mmObj)

		for _, obj in ipairs{mmObj:GetChildren()} do
			local objName, objType = obj:GetName(), obj:GetObjectType()
			if not obj.sb
			and not obj.sf
			and not objName == "QueueStatusMinimapButton" -- ignore QueueStatusMinimapButton
			and not objName == "OQ_MinimapButton" -- ignore oQueue's minimap button
			and objType == "Button"
			or (objType == "Frame" and objName == "MiniMapMailFrame")
			then
				for _, reg in ipairs{obj:GetRegions()} do
					if reg:GetObjectType() == "Texture" then
						-- change the DrawLayer to make the Icon show if required
						if aObj:hasTextInName(reg, "[Ii]con")
						or aObj:hasTextInTexture(reg, "[Ii]con")
						then
							if reg:GetDrawLayer() == "BACKGROUND" then reg:SetDrawLayer("ARTWORK") end
							-- centre the icon
							reg:ClearAllPoints()
							reg:SetPoint("CENTER")
						elseif aObj:hasTextInName(reg, "Border")
						or aObj:hasTextInTexture(reg, "TrackingBorder")
						then
							reg:SetTexture(nil)
							obj:SetSize(32, 32)
							if not minBtn then
								if objType == "Button" then
									aObj:addSkinButton{obj=obj, parent=obj, sap=true, ft=ftype}
								else
									aObj:addSkinFrame{obj=obj, ft=ftype}
								end
							end
						elseif aObj:hasTextInTexture(reg, "Background") then
							reg:SetTexture(nil)
						end
					end
				end
			elseif objType == "Frame"
			and (objName
			and not objName == "MiniMapTrackingButton") -- handled below
			then
				mmKids(obj)
			end
		end

	end

	-- skin Minimap children, allow for delayed addons to be loaded (e.g. Baggins)
	self:ScheduleTimer(mmKids, 0.5, _G.Minimap)

	-- skin other Blizzard buttons
	local asopts = {ba=minBtn and 0 or 1, bba=minBtn and 0 or 1, ng=minBtn and true or nil}
	-- Calendar button
	local obj = _G.GameTimeFrame
	obj:SetSize(26, 26)
	obj:GetNormalTexture():SetTexCoord(0.1, 0.31, 0.16, 0.6)
	obj:GetPushedTexture():SetTexCoord(0.6, 0.81, 0.16, 0.6)
	obj:GetHighlightTexture():SetTexture([[Interface\Buttons\ButtonHilight-Square]])
	self:addSkinFrame{obj=obj, aso=asopts, x1=-4, y1=4, x2=4, y2=-4}
	-- make sure textures appear above skinFrame
	_G.LowerFrameLevel(obj.sf)

	-- MinimapZoomIn/Out buttons
	for k, obj in pairs{_G.MinimapZoomIn, _G.MinimapZoomOut} do
		obj:GetNormalTexture():SetTexture(nil)
		obj:GetPushedTexture():SetTexture(nil)
		if minBtn then
			obj:GetDisabledTexture():SetTexture([[Interface\Minimap\UI-Minimap-Background]])
		else
			obj:GetDisabledTexture():SetTexture(nil)
		end
		self:adjWidth{obj=obj, adj=-8}
		self:adjHeight{obj=obj, adj=-8}
		self:addSkinButton{obj=obj, parent=obj, aso=asopts, ft=ftype}
		obj.sb:SetAllPoints(obj:GetNormalTexture())
		obj.sb:SetNormalFontObject(self.modUIBtns.fontX)
		obj.sb:SetDisabledFontObject(self.modUIBtns.fontDX)
		obj.sb:SetPushedTextOffset(1, 1)
		obj.sb:SetText(k == 1 and self.modUIBtns.plus or self.modUIBtns.minus)
		if not obj:IsEnabled() then obj.sb:Disable() end
	end
	-- change Mail icon
	_G.MiniMapMailIcon:SetTexture([[Interface\Minimap\Tracking\Mailbox.blp]])
	-- resize other buttons
	_G.MiniMapMailFrame:SetSize(28, 28)
	_G.MiniMapVoiceChatFrame:SetSize(32, 32)
	_G.MiniMapVoiceChatFrameIcon:ClearAllPoints()
	_G.MiniMapVoiceChatFrameIcon:SetPoint("CENTER")
	-- MiniMap Tracking
	_G.MiniMapTrackingBackground:SetTexture(nil)
	_G.MiniMapTrackingButtonBorder:SetTexture(nil)
	_G.MiniMapTrackingIcon:SetParent(_G.MiniMapTrackingButton)
	_G.MiniMapTrackingIcon:ClearAllPoints()
	_G.MiniMapTrackingIcon:SetPoint("CENTER", _G.MiniMapTrackingButton)
	-- change this to stop the icon being moved
	_G.MiniMapTrackingIcon.SetPoint = function() end
	if not minBtn then
		self:addSkinFrame{obj=_G.MiniMapTracking, ft=ftype}
	end
	-- QueueStatusMinimapButton (reparent to ensure Eye is visible)
	_G.QueueStatusMinimapButtonBorder:SetTexture(nil)
	aObj:addSkinButton{obj=_G.QueueStatusMinimapButton, parent=_G.QueueStatusMinimapButton, sap=true, rp=true, ft=ftype}

	-- skin any moved Minimap buttons if required
	if IsAddOnLoaded("MinimapButtonFrame") then mmKids(_G.MinimapButtonFrame) end

	-- show the Bongos minimap icon if required
	if IsAddOnLoaded("Bongos") then _G.Bongos3MinimapButton.icon:SetDrawLayer("ARTWORK") end

	-- skin other minimap buttons as required
	if not minBtn then
		local mmButs = {
			["SmartBuff"] = _G.SmartBuff_MiniMapButton,
			["WebDKP"] = _G.WebDKP_MinimapButton,
			["GuildAds"] = _G.GuildAdsMinimapButton,
			["Outfitter"] = _G.OutfitterMinimapButton,
			["Perl_Config"] = _G.PerlButton,
			["WIM"] = _G.WIM3MinimapButton,
			["HealBot"] = _G.HealBot_MMButton,
			["Altoholic"] = _G.AltoholicMinimapButton,
			["Armory"] = _G.ArmoryMinimapButton,
			["ZygorGuidesViewer"] = _G.ZygorGuidesViewerMapIcon,
			["RaidBuffStatus"] = _G.RBSMinimapButton,
		}
		local function skinMMBtn(btn, name)

			-- _G.print("skinMMBtn", btn, name or nil)

			for _, reg in ipairs{btn:GetRegions()} do
				if reg:GetObjectType() == "Texture" then
					if self:hasTextInName(reg, "Border")
					or self:hasTextInTexture(reg, "TrackingBorder")
					then
						reg:SetTexture(nil)
					end
				end
			end

			self:addSkinButton{obj=btn, parent=btn, sap=true, ft=ftype}

		end
		for addon, obj in pairs(mmButs) do
			if IsAddOnLoaded(addon) then
				skinMMBtn(obj)
			end
		end
		mmButs = nil
		-- skin LibDBIcon Minimap Buttons
		_G.LibStub("LibDataBroker-1.1").RegisterCallback(aObj, "LibDBIcon_IconCreated", skinMMBtn)
		-- skin existing buttons
		for name, button in pairs(_G.LibStub("LibDBIcon-1.0").objects) do
			skinMMBtn(button, name)
		end
	end

	-- Garrison Landing Page Minimap button
	local obj = _G.GarrisonLandingPageMinimapButton
	obj:SetSize(26, 26)
	local x1, y1, x2, y2 = 0.25, 0.76, 0.32, 0.685
	obj:GetNormalTexture():SetTexCoord(x1, y1, x2, y2)
	obj:GetPushedTexture():SetTexCoord(x1, y1, x2, y2)
	obj:GetHighlightTexture():SetTexture([[Interface\Buttons\ButtonHilight-Square]])
	self:addSkinFrame{obj=obj, aso=asopts, x1=-4, y1=4, x2=4, y2=-4}
	-- make sure textures appear above skinFrame
	_G.LowerFrameLevel(obj.sf)

end

function aObj:MovePad() -- LoD
	if not self.db.profile.MovePad or self.initialized.MovePad then return end
	self.initialized.MovePad = true

	self:skinButton{obj=_G.MovePadForward}
	self:skinButton{obj=_G.MovePadJump}
	self:skinButton{obj=_G.MovePadBackward}
	self:skinButton{obj=_G.MovePadStrafeLeft}
	self:skinButton{obj=_G.MovePadStrafeRight}
	self:addSkinButton{obj=_G.MovePadLock, as=true, ft=ftype, ofs=-4}
	self:addSkinFrame{obj=_G.MovePadFrame, ft=ftype}
	self:addButtonBorder{obj=_G.MovePadJump, ofs=0}

end

function aObj:MovieFrame()
	if not self.db.profile.MovieFrame or self.initialized.MovieFrame then return end
	self.initialized.MovieFrame = true

	self:addSkinFrame{obj=_G.MovieFrame.CloseDialog, ft=ftype}

end

if _G.IsMacClient() then
	function aObj:MovieProgress()
		if not self.db.profile.MovieProgress or self.initialized.MovieProgress then return end
		self.initialized.MovieProgress = true

		self:getChild(_G.MovieProgressBar, 1):SetBackdrop(nil)
		self:removeRegions(_G.MovieProgressFrame)
		self:glazeStatusBar(_G.MovieProgressBar, 0, self:getRegion(_G.MovieProgressBar, 1))
		self:addSkinFrame{obj=_G.MovieProgressFrame, ft=ftype, x1=-6, y1=6, x2=6, y2=-6}

	end
end

function aObj:Nameplates()
	if not self.db.profile.Nameplates or self.initialized.Nameplates then return end
	self.initialized.Nameplates = true

	local r, g, b, a = unpack(self.sbColour)
	local sbTex, shTex = self.sbTexture, self.shieldTex
	local _, rg2, rg3, rg6
	local function skinPlate(obj)

		_, rg2, rg3 = obj:GetRegions() -- border & highlight
		rg2:SetTexture(nil)
		rg3:SetTexture(nil)

		-- skin both status bars (health & cast)
		obj.sb1, obj.sb2 = obj:GetChildren()
		for i = 1, 2 do
			if obj["sb" .. i] then
				aObj:glazeStatusBar(obj["sb" .. i], 0,  nil)
			end
		end

		-- Cast bar uninterruptible shield texture
		_, rg2 ,obj.sb2.rg3, obj.sb2.rg4, _, rg6 = obj.sb2:GetRegions() -- ?, border, shield, icon, spellname, shadow
		rg2:SetTexture(nil)
		rg6:SetTexture(nil)
		aObj:changeShield(obj.sb2.rg3, obj.sb2.rg4)
		obj.sb2.rg3.sw = obj.sb2.rg3.SetWidth -- store original function
		obj.sb2.rg3.SetWidth = function() end

	end
	local npEvt
	local function skinNameplates()

		-- if the nameplates are off then disable the skinning code
		if not _G.GetCVarBool("nameplateShowEnemies")
		and not _G.GetCVarBool("nameplateShowFriends")
		then
			aObj:CancelTimer(npEvt, true)
			npEvt = nil
		else
			aObj.RegisterCallback("skinNameplates", "WorldFrame_GetChildren", function(this, child)
				if aObj:hasTextInName(child, "NamePlate") then
					local npObj = aObj:getChild(child, 1) -- use first child frame (5.1)
					if not npObj.sknd then
						skinPlate(npObj)
						npObj.sknd = true
					else
						 -- reset shield texture's width & position
						npObj.sb2.rg3:sw(46)
						npObj.sb2.rg3:SetPoint("CENTER", npObj.sb2.rg4, "CENTER", 9, -1)
					end
				end
			end)
			aObj:scanWorldFrameChildren()
		end

	end

	local function showFunc()

		if not npEvt then
			npEvt = aObj:ScheduleRepeatingTimer(skinNameplates, 0.2)
		end

	end

	-- track changes to Saved Variables to enable Nameplate skinning
	self:SecureHook("SetCVar", function(varName, varValue, ...)
		if varName:find("nameplateShow") and varValue == 1 then showFunc() end
	end)

	-- track combat starting to enable Nameplate skinning
	self:RegisterEvent("PLAYER_REGEN_DISABLED", function()
		showFunc()
	end)

	if _G.GetCVarBool("nameplateShowEnemies")
	or _G.GetCVarBool("nameplateShowFriends")
	then
		showFunc()
	end

end

function aObj:NavigationBar()
	-- Helper function, used by several frames

	-- hook this to handle navbar buttons
	self:SecureHook("NavBar_AddButton", function(this, buttonData)
		for i = 1, #this.navList do
			local btn = this.navList[i]
			btn:DisableDrawLayer("OVERLAY")
			btn:GetNormalTexture():SetAlpha(0)
			btn:GetPushedTexture():SetAlpha(0)
		end
	end)

end

aObj.pbtt = {}
function aObj:PetBattleUI()
	if not self.db.profile.PetBattleUI or self.initialized.PetBattleUI then return end
	self.initialized.PetBattleUI = true

	-- Top Frame
	_G.PetBattleFrame.TopArtLeft:SetTexture(nil)
	_G.PetBattleFrame.TopArtRight:SetTexture(nil)
	_G.PetBattleFrame.TopVersus:SetTexture(nil)
	-- Active Allies/Enemies
	for _, v in pairs{"Ally", "Enemy"} do
		local obj = _G.PetBattleFrame["Active" .. v]
		self:addButtonBorder{obj=obj, relTo=obj.Icon, ofs=1, reParent={obj.LevelUnderlay, obj.Level, obj.SpeedUnderlay, obj.SpeedIcon}}
		obj.Border:SetTexture(nil)
		obj.Border2:SetTexture(nil)
		if self.modBtnBs then
			obj.sbb:SetBackdropBorderColor(obj.Border:GetVertexColor())
			self:SecureHook(obj.Border, "SetVertexColor", function(this, ...)
				this:GetParent().sbb:SetBackdropBorderColor(...)
			end)
		end
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
		local sfn = v == "Ally" and "sfl" or "sfr"
		_G.PetBattleFrame[sfn] = _G.CreateFrame("Frame", nil, _G.PetBattleFrame)
		self:applySkin{obj=_G.PetBattleFrame[sfn], bba=0, fh=45}
		local xOfs, yOfs = 405, 4
		if v == "Ally" then
			_G.PetBattleFrame.sfl:SetPoint("TOPLEFT", _G.PetBattleFrame, "TOPLEFT", xOfs, yOfs)
		else
			_G.PetBattleFrame.sfr:SetPoint("TOPRIGHT", _G.PetBattleFrame, "TOPRIGHT", xOfs * -1, yOfs)
		end
		_G.PetBattleFrame[sfn]:SetSize(340, 94)
		_G.PetBattleFrame[sfn]:SetFrameStrata("BACKGROUND")
		-- Ally2/3, Enemy2/3
		for i = 2, 3 do
			local btn = _G.PetBattleFrame[v .. i]
			self:addButtonBorder{obj=btn, relTo=btn.Icon, reParent={btn.ActualHealthBar}}
			btn.BorderAlive:SetTexture(nil)
			self:changeTandC(btn.BorderDead, [[Interface\PetBattles\DeadPetIcon]])
			if self.modBtnBs then
				btn.sbb:SetBackdropBorderColor(btn.BorderAlive:GetVertexColor())
				self:SecureHook(btn.BorderAlive, "SetVertexColor", function(this, ...)
					this:GetParent().sbb:SetBackdropBorderColor(...)
				end)
			end
			btn.healthBarWidth = 34
			btn.ActualHealthBar:SetWidth(34)
			btn.ActualHealthBar:SetTexture(self.sbTexture)
			btn.HealthDivider:SetTexture(nil)
		end
	end
	-- create a frame behind the VS text
	_G.PetBattleFrame.sfm = _G.CreateFrame("Frame", nil, _G.PetBattleFrame)
	self:applySkin{obj=_G.PetBattleFrame.sfm, bba=0}
	_G.PetBattleFrame.sfm:SetPoint("TOPLEFT", _G.PetBattleFrame.sfl, "TOPRIGHT", -8, 0)
	_G.PetBattleFrame.sfm:SetPoint("TOPRIGHT", _G.PetBattleFrame.sfr, "TOPLEFT", 8, 0)
	_G.PetBattleFrame.sfm:SetHeight(45)
	_G.PetBattleFrame.sfm:SetFrameStrata("BACKGROUND")

	-- Bottom Frame
	_G.PetBattleFrame.BottomFrame.RightEndCap:SetTexture(nil)
	_G.PetBattleFrame.BottomFrame.LeftEndCap:SetTexture(nil)
	_G.PetBattleFrame.BottomFrame.Background:SetTexture(nil)
	-- Pet Selection
	for i = 1, _G.NUM_BATTLE_PETS_IN_BATTLE do
		local btn = _G.PetBattleFrame.BottomFrame.PetSelectionFrame["Pet" .. i]
		btn.Framing:SetTexture(nil)
		btn.HealthBarBG:SetTexture(self.sbTexture)
		btn.HealthBarBG:SetVertexColor(0.2, 0.2, 0.2, 0.8) -- dark grey
		btn.ActualHealthBar:SetTexture(self.sbTexture)
		btn.HealthDivider:SetTexture(nil)
	end
	self:keepRegions(_G.PetBattleFrame.BottomFrame.xpBar, {1, 5, 6, 13}) -- text and statusbar textures
	self:glazeStatusBar(_G.PetBattleFrame.BottomFrame.xpBar, 0,  nil)
	_G.PetBattleFrame.BottomFrame.TurnTimer.TimerBG:SetTexture(nil)
	_G.PetBattleFrame.BottomFrame.TurnTimer.Bar:SetTexture(self.sbTexture)
	_G.PetBattleFrame.BottomFrame.TurnTimer.ArtFrame:SetTexture(nil)
	_G.PetBattleFrame.BottomFrame.TurnTimer.ArtFrame2:SetTexture(nil)
	self:removeRegions(_G.PetBattleFrame.BottomFrame.FlowFrame, {1, 2, 3})
	self:getRegion(_G.PetBattleFrame.BottomFrame.Delimiter, 1):SetTexture(nil)
	self:addButtonBorder{obj=_G.PetBattleFrame.BottomFrame.SwitchPetButton}
	self:addButtonBorder{obj=_G.PetBattleFrame.BottomFrame.CatchButton}
	self:addButtonBorder{obj=_G.PetBattleFrame.BottomFrame.ForfeitButton}
	self:removeRegions(_G.PetBattleFrame.BottomFrame.MicroButtonFrame, {1, 2, 3})
	self:addSkinFrame{obj=_G.PetBattleFrame.BottomFrame, ft=ftype, y1=8}
	if self.modBtnBs then
		-- hook these for pet ability buttons
		self:SecureHook("PetBattleFrame_UpdateActionBarLayout", function(this)
			for i = 1, _G.NUM_BATTLE_PET_ABILITIES do
				local btn = this.BottomFrame.abilityButtons[i]
				self:addButtonBorder{obj=btn, reParent={btn.BetterIcon}}
			end
			self:Unhook("PetBattleFrame_UpdateActionBarLayout")
		end)
		self:SecureHook("PetBattleActionButton_UpdateState", function(this)
			if this.sbb then
				if this.Icon
				and this.Icon:IsDesaturated()
				then
					this.sbb:SetBackdropBorderColor(.5, .5, .5)
				else
					this.sbb:SetBackdropBorderColor(unpack(self.bbColour))
				end
			end
		end)
	end

	-- Tooltip frames
	if self.db.profile.Tooltips.skin then
		-- hook these to stop tooltip gradient being whiteouted !!
		local function reParent(opts)
			for _, ttsf in pairs(aObj.pbtt) do
				ttsf.tfade:SetParent(opts.parent or ttsf)
	 			if opts.reset then
					-- reset Gradient alpha
					ttsf.tfade:SetGradientAlpha(aObj:getGradientInfo())
				end
			end
 		end
		-- N.B. Can't use RawHookScript as it has a bug preventing its use on AnimationGroup Scripts
		-- (Needs to check for IsProtected as a function before calling it)
		local pbfaasf = _G.PetBattleFrame.ActiveAlly.SpeedFlash
		-- self:RawHookScript(pbfaasf, "OnPlay", function(this)
		local pbfaasfop = pbfaasf:HasScript("OnPlay") and pbfaasf:GetScript("OnPlay") or nil
		pbfaasf:SetScript("OnPlay", function(this)
			reParent{parent=_G.MainMenuBar}
			if pbfaasfop then pbfaasfop(this) end
			-- self.hooks[this].OnPlay(this)
		-- end, true)
		end)
		self:SecureHookScript(pbfaasf, "OnFinished", function(this)
			reParent{reset=true}
		end)
		local pbfaesf = _G.PetBattleFrame.ActiveEnemy.SpeedFlash
		-- self:RawHookScript(pbfaesf, "OnPlay", function(this)
		local pbfaesfop = pbfaesf:HasScript("OnPlay") and pbfaesf:GetScript("OnPlay") or nil
		pbfaesf:SetScript("OnPlay", function(this)
			reParent{parent=_G.MainMenuBar}
			if pbfaesfop then pbfaesfop(this) end
			-- self.hooks[this].OnPlay(this)
		-- end, true)
		end)
		self:SecureHookScript(pbfaesf, "OnFinished", function(this)
			reParent{reset=true}
		end)
		-- hook these to ensure gradient texture is reparented correctly
		self:SecureHookScript(_G.PetBattleFrame, "OnShow", function(this)
			reParent{parent=_G.MainMenuBar, reset=true}
		end)
		self:SecureHookScript(_G.PetBattleFrame, "OnHide", function(this)
			reParent{}
		end)
		-- hook this to reparent the gradient texture if pets have equal speed
		self:SecureHook("PetBattleFrame_UpdateSpeedIndicators", function(this)
			if not this.ActiveAlly.SpeedIcon:IsShown()
			and not this.ActiveEnemy.SpeedIcon:IsShown()
			then
				reParent{reset=true}
			end
		end)
		-- PetBattlePrimaryUnit Tooltip
		local obj = _G.PetBattlePrimaryUnitTooltip
		obj:DisableDrawLayer("BACKGROUND")
		obj.ActualHealthBar:SetTexture(self.sbTexture)
		obj.XPBar:SetTexture(self.sbTexture)
		obj.Delimiter:SetTexture(nil)
		obj.sf = self:addSkinFrame{obj=obj, ft=ftype}
		self:add2Table(self.pbtt, obj.sf)
		-- PetBattlePrimaryAbility Tooltip
		_G.PetBattlePrimaryAbilityTooltip.Delimiter1:SetTexture(nil)
		_G.PetBattlePrimaryAbilityTooltip.Delimiter2:SetTexture(nil)
		_G.PetBattlePrimaryAbilityTooltip:DisableDrawLayer("BACKGROUND")
		self:addSkinFrame{obj=_G.PetBattlePrimaryAbilityTooltip, ft=ftype}
		-- FloatingBattlePet Tooltip
		_G.FloatingBattlePetTooltip.Delimiter:SetTexture(nil)
		_G.FloatingBattlePetTooltip:DisableDrawLayer("BACKGROUND")
		self:addSkinFrame{obj=_G.FloatingBattlePetTooltip, ft=ftype}
		-- FloatingPetBattleAbility Tooltip
		_G.FloatingPetBattleAbilityTooltip.Delimiter1:SetTexture(nil)
		_G.FloatingPetBattleAbilityTooltip.Delimiter2:SetTexture(nil)
		_G.FloatingPetBattleAbilityTooltip:DisableDrawLayer("BACKGROUND")
		self:addSkinFrame{obj=_G.FloatingPetBattleAbilityTooltip, ft=ftype}
		-- BattlePetTooltip (used for caged battle pets in inventory)
		self:addSkinFrame{obj=_G.BattlePetTooltip, ft=ftype}
	end

end

function aObj:PVEFrame() -- a.k.a. GroupFinderFrame
	if not self.db.profile.PVEFrame or self.initialized.PVEFrame then return end
	self.initialized.PVEFrame = true

	self:removeInset(_G.PVEFrame.Inset)
	self:keepFontStrings(_G.PVEFrame.shadows)
	self:addSkinFrame{obj=_G.PVEFrame, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-5}
	self:skinTabs{obj=_G.PVEFrame}

	-- GroupFinder Frame
	for i = 1, 4 do
		local btn = _G.GroupFinderFrame["groupButton" .. i]
		btn.bg:SetTexture(nil)
		btn.ring:SetTexture(nil)
		self:changeRecTex(btn:GetHighlightTexture())
	end
	-- hook this to change selected texture
	self:SecureHook("GroupFinderFrame_SelectGroupButton", function(index)
		for i = 1, 4 do
			local btn = _G.GroupFinderFrame["groupButton" .. i]
			if i == index then
				self:changeRecTex(btn.bg, true)
			else
				btn.bg:SetTexture(nil)
			end
		end
	end)
	-- Premade Groups LFGListPVEStub (LFGList)
	-- CategorySelection
	local cs = _G.LFGListFrame.CategorySelection
	self:removeInset(cs.Inset)
	self:SecureHook("LFGListCategorySelection_AddButton", function(...)
		for i = 1, #cs.CategoryButtons do
			cs.CategoryButtons[i].Cover:SetTexture(nil)
		end
	end)
	self:skinButton{obj=cs.FindGroupButton}
	self:removeMagicBtnTex(cs.FindGroupButton)
	self:skinButton{obj=cs.StartGroupButton}
	self:removeMagicBtnTex(cs.StartGroupButton)
	-- NothingAvailable
	self:removeInset(_G.LFGListFrame.NothingAvailable.Inset)
	-- SearchPanel
	local sp = _G.LFGListFrame.SearchPanel
	self:skinEditBox{obj=sp.SearchBox, regs={9, 10}, mi=true}
	self:addSkinFrame{obj=sp.AutoCompleteFrame, ft=ftype, kfs=true, nb=true, x1=4, y1=4, y2=4}
	self:addButtonBorder{obj=sp.RefreshButton, ofs=-2}
	self:removeInset(sp.ResultsInset)
	self:skinButton{obj=sp.ScrollFrame.StartGroupButton, as=true} -- use as otherwise button skin not visible
	self:skinSlider{obj=sp.ScrollFrame.scrollBar, adj=-4}
	self:skinButton{obj=sp.BackButton}
	self:removeMagicBtnTex(sp.BackButton)
	self:skinButton{obj=sp.SignUpButton}
	self:removeMagicBtnTex(sp.SignUpButton)
	-- ApplicationViewer
	local av = _G.LFGListFrame.ApplicationViewer
	av:DisableDrawLayer("BACKGROUND")
	self:removeInset(av.Inset)
	for _, v in pairs{"Name", "Role", "ItemLevel"} do
		local btn = av[v .. "ColumnHeader"]
		self:removeRegions(btn, {1, 2, 3})
		self:skinButton{obj=btn}
	end
	self:addButtonBorder{obj=av.RefreshButton, ofs=-2}
	self:skinSlider{obj=av.ScrollFrame.scrollBar, adj=-4}
	for i = 1, #av.ScrollFrame.buttons do
		local btn = av.ScrollFrame.buttons[i]
		self:skinButton{obj=btn.DeclineButton}
		self:skinButton{obj=btn.InviteButton}
	end
	self:skinButton{obj=av.RemoveEntryButton}
	self:removeMagicBtnTex(av.RemoveEntryButton)
	self:skinButton{obj=av.EditButton}
	self:removeMagicBtnTex(av.EditButton)
	-- EntryCreation
	local ec = _G.LFGListFrame.EntryCreation
	self:removeInset(ec.Inset)
	local ecafd = ec.ActivityFinder.Dialog
	self:skinEditBox{obj=ecafd.EntryBox, regs={9}, mi=true}
	self:skinSlider{obj=ecafd.ScrollFrame.scrollBar, size=4}
	ecafd.BorderFrame:DisableDrawLayer("BACKGROUND")
	self:addSkinFrame{obj=ecafd, ft=ftype, kfs=true}
	self:skinEditBox{obj=ec.Name, regs={9}, mi=true}
	self:skinDropDown{obj=ec.CategoryDropDown}
	self:skinDropDown{obj=ec.GroupDropDown}
	self:skinDropDown{obj=ec.ActivityDropDown}
	self:skinEditBox{obj=ec.ItemLevel.EditBox, regs={9}, mi=true}
	self:skinEditBox{obj=ec.VoiceChat.EditBox, regs={9}, mi=true}
	self:addSkinFrame{obj=ec.Description, ft=ftype, kfs=true, ofs=6}
	self:skinButton{obj=ec.ListGroupButton}
	self:removeMagicBtnTex(ec.ListGroupButton)
	self:skinButton{obj=ec.CancelButton}
	self:removeMagicBtnTex(ec.CancelButton)

	-- LFGListApplication Dialog
	self:skinSlider{obj=_G.LFGListApplicationDialog.Description.ScrollBar, adj=-4}
	self:addSkinFrame{obj=_G.LFGListApplicationDialog.Description, ft=ftype, kfs=true, ofs=6}
	_G.LFGListApplicationDialog.Description.EditBox.Instructions:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:addSkinFrame{obj=_G.LFGListApplicationDialog, ft=ftype, kfs=true}
	-- LFGListInvite Dialog
	self:addSkinFrame{obj=_G.LFGListInviteDialog, ft=ftype}

	-- ScenarioFinder Frame
	self:keepFontStrings(_G.ScenarioFinderFrame)
	self:removeInset(_G.ScenarioFinderFrame.Inset)

	-- ScenarioQueueFrame
	_G.ScenarioQueueFrame.Bg:SetAlpha(0) -- N.B. texture changed in code
	self:skinDropDown{obj=_G.ScenarioQueueFrame.Dropdown}
	self:skinScrollBar{obj=_G.ScenarioQueueFrame.Random.ScrollFrame}
	for i = 1, _G.ScenarioQueueFrame.Random.ScrollFrame.Child.numRewardFrames do
		local btnName = "ScenarioQueueFrameRandomScrollFrameChildFrameItem" .. i
		if _G[btnName] then
			_G[btnName .. "NameFrame"]:SetTexture(nil)
			self:addButtonBorder{obj=_G[btnName], libt=true}
		end
	end
	self:skinButton{obj=_G.ScenarioQueueFrame.Random.ScrollFrame.Child.bonusRepFrame.ChooseButton, as=true}
	self:addButtonBorder{obj=_G.ScenarioQueueFrame.Random.ScrollFrame.Child.MoneyReward, libt=true}
	_G.ScenarioQueueFrame.Random.ScrollFrame.Child.MoneyReward.NameFrame:SetTexture(nil)

	self:skinButton{obj=_G.ScenarioQueueFrameSpecificButton1ExpandOrCollapseButton, mp2=true}
	self:moveObject{obj=_G.ScenarioQueueFrameSpecificButton1ExpandOrCollapseButtonHighlight, x=-3} -- move highlight to the left
	self:skinScrollBar{obj=_G.ScenarioQueueFrame.Specific.ScrollFrame}
	self:keepFontStrings(_G.ScenarioQueueFramePartyBackfill)
	self:removeMagicBtnTex(_G.ScenarioQueueFrameFindGroupButton)

end

function aObj:QuestMap()
	if not self.db.profile.QuestMap or self.initialized.QuestMap then return end
	self.initialized.QuestMap = true

-->>-- Quest Log Popup Detail Frame
	local qlpdf = _G.QuestLogPopupDetailFrame
	qlpdf.ScrollFrame:DisableDrawLayer("ARTWORK")
	self:skinScrollBar{obj=qlpdf.ScrollFrame}
	self:addButtonBorder{obj=qlpdf.ShowMapButton, relTo=qlpdf.ShowMapButton.Texture, x1=2, y1=-1, x2=-2, y2=1}
	self:addSkinFrame{obj=qlpdf, ft=ftype, kfs=true, ri=true, ofs=2}

-->>-- Quest Map Frame
	_G.QuestMapFrame.VerticalSeparator:SetTexture(nil)
	self:skinDropDown{obj=_G.QuestMapQuestOptionsDropDown}
	_G.QuestMapFrame.QuestsFrame:DisableDrawLayer("BACKGROUND")
	_G.QuestMapFrame.QuestsFrame.Contents.StoryHeader:DisableDrawLayer("BACKGROUND")
	_G.QuestMapFrame.QuestsFrame.Contents.StoryHeader.Shadow:SetTexture(nil)
	self:skinSlider{obj=_G.QuestMapFrame.QuestsFrame.ScrollBar, size=3}
	self:addSkinFrame{obj=_G.QuestMapFrame.QuestsFrame.StoryTooltip, ft=ftype}

	-- Details Frame
	self:keepFontStrings(_G.QuestMapFrame.DetailsFrame)
	self:keepFontStrings(_G.QuestMapFrame.DetailsFrame.RewardsFrame)
	self:getRegion(_G.QuestMapFrame.DetailsFrame.RewardsFrame, 3):SetTextColor(self.HTr, self.HTg, self.HTb)
	self:skinSlider{obj=_G.QuestMapFrame.DetailsFrame.ScrollFrame.ScrollBar, adj=-4}
	_G.QuestMapFrame.DetailsFrame.CompleteQuestFrame.CompleteButton:DisableDrawLayer("BORDER")
	self:moveObject{obj=_G.QuestMapFrame.DetailsFrame.AbandonButton, y=2}
	self:removeRegions(_G.QuestMapFrame.DetailsFrame.ShareButton, {6, 7}) -- divider textures

-->>-- QuestInfo
	self:QuestInfo() -- NPC Frames

end

function aObj:QueueStatusFrame() -- shown on mouseover of QueueStatusMinimapButton
	if not self.db.profile.QueueStatusFrame or self.initialized.QueueStatusFrame then return end
	self.initialized.QueueStatusFrame = true

	_G.QueueStatusFrame:DisableDrawLayer("BACKGROUND")
	self:addSkinFrame{obj=_G.QueueStatusFrame, anim=IsAddOnLoaded("SexyMap") and true or nil}
	-- handle SexyMap's use of AnimationGroups to show and hide frames
	if IsAddOnLoaded("SexyMap") then
		local rtEvt
		local function checkForAnimGrp()
			if _G.QueueStatusMinimapButton.smAlphaAnim then
				aObj:CancelTimer(rtEvt, true)
				rtEvt = nil
				aObj:SecureHookScript(_G.QueueStatusMinimapButton.smAnimGroup, "OnFinished", function(this)
					_G.QueueStatusFrame.sf:Hide()
				end)
			end
		end
		rtEvt = self:ScheduleRepeatingTimer(checkForAnimGrp, 0.2)
	end

end

function aObj:RaidFrame()
	if not self.db.profile.RaidFrame or self.initialized.RaidFrame then return end
	self.initialized.RaidFrame = true

	self:skinTabs{obj=_G.RaidParentFrame, lod=true}
	self:addSkinFrame{obj=_G.RaidParentFrame, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-5}

-->>-- RaidFinder Frame
	self:keepRegions(_G.RaidFinderFrame, {})
	self:removeInset(_G.RaidFinderFrameRoleInset)
	self:removeInset(_G.RaidFinderFrameBottomInset)
	self:addButtonBorder{obj=_G.RaidFinderQueueFrameScrollFrameChildFrameItem1, libt=true}
	_G.RaidFinderQueueFrameScrollFrameChildFrameItem1NameFrame:SetTexture(nil)
	self:addButtonBorder{obj=_G.RaidFinderQueueFrameScrollFrameChildFrame.MoneyReward, libt=true}
	_G.RaidFinderQueueFrameScrollFrameChildFrame.MoneyReward.NameFrame:SetTexture(nil)

	self:removeMagicBtnTex(_G.RaidFinderFrameFindRaidButton)
	self:keepRegions(_G.RaidFinderQueueFrame, {})
	self:skinDropDown{obj=_G.RaidFinderQueueFrameSelectionDropDown}
	self:skinScrollBar{obj=_G.RaidFinderQueueFrameScrollFrame}

end

function aObj:ScriptErrors()
	if not self.db.profile.ScriptErrors or self.initialized.ScriptErrors then return end
	self.initialized.ScriptErrors = true

	-- skin Basic Script Errors Frame (BasicControls.xml)
	self:addSkinFrame{obj=_G.BasicScriptErrors, kfs=true, ft=ftype}

end

function aObj:SplashFrame()
	if not self.db.profile.SplashFrame or self.initialized.SplashFrame then return end
	self.initialized.SplashFrame = true

	_G.SplashFrame.Label:SetTextColor(self.HTr, self.HTg, self.HTb)
	self:addSkinFrame{obj=_G.SplashFrame, ft=ftype, kfs=true}

end

function aObj:StaticPopups()
	if not self.db.profile.StaticPopups or self.initialized.StaticPopups then return end
	self.initialized.StaticPopups = true

	if self.modBtns then
		-- hook this to handle close button texture changes
		self:SecureHook("StaticPopup_Show", function(...)
			for i = 1, _G.STATICPOPUP_NUMDIALOGS do
				local obj = _G["StaticPopup" .. i .. "CloseButton"]
				if aObj:hasTextInTexture(obj:GetNormalTexture(), "HideButton") then
					obj:SetText(self.modUIBtns.minus)
				elseif aObj:hasTextInTexture(obj:GetNormalTexture(), "MinimizeButton") then
					obj:SetText(self.modUIBtns.mult)
				end
			end
		end)
	end

	for i = 1, _G.STATICPOPUP_NUMDIALOGS do
		local objName = "StaticPopup" .. i
		local obj = _G[objName]
		self:skinEditBox{obj=_G[objName .. "EditBox"]}
		self:skinMoneyFrame{obj=_G[objName .. "MoneyInputFrame"]}
		_G[objName .. "ItemFrameNameFrame"]:SetTexture(nil)
		self:addButtonBorder{obj=_G[objName .. "ItemFrame"], ibt=true}
		self:addSkinFrame{obj=obj, ft=ftype, x1=6, y1=-6, x2=-6, y2=6}
		-- prevent FrameLevel from being changed (LibRock does this)
		obj.sf.SetFrameLevel = function() end
	end

end

function aObj:SocialUI() -- LoD
	if not self.db.profile.SocialUI or self.initialized.SocialUI then return end
	self.initialized.SocialUI = true

	-- disable skinning of this frame
	self.db.profile.SocialUI = false

	-->> N.B. Currently can't be skinned, as the XML has a ScopedModifier element saying forbidden="true"

end

function aObj:StoreUI() -- LoD
	if not self.db.profile.StoreUI or self.initialized.StoreUI then return end
	self.initialized.StoreUI = true

	-- disable skinning of this frame
	self.db.profile.StoreUI = false

	-->> N.B. Currently can't be skinned, as the XML has a ScopedModifier element saying forbidden="true"

end

function aObj:TimeManager() -- LoD
	if not self.db.profile.TimeManager or self.initialized.TimeManager then return end
	self.initialized.TimeManager = true

	-- Time Manager Frame
	_G.TimeManagerFrameTicker:Hide()
	self:keepFontStrings(_G.TimeManagerStopwatchFrame)
	self:addButtonBorder{obj=_G.TimeManagerStopwatchCheck}
	self:skinDropDown{obj=_G.TimeManagerAlarmHourDropDown, x2=-5}
	self:skinDropDown{obj=_G.TimeManagerAlarmMinuteDropDown, x2=-5}
	self:skinDropDown{obj=_G.TimeManagerAlarmAMPMDropDown, x2=-5}
	self:skinEditBox{obj=_G.TimeManagerAlarmMessageEditBox, regs={9}}
	self:removeRegions(_G.TimeManagerAlarmEnabledButton, {6, 7})
	self:addSkinFrame{obj=_G.TimeManagerFrame, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-2}

	if not IsAddOnLoaded("SexyMap") then
		-- Time Manager Clock Button
		self:removeRegions(_G.TimeManagerClockButton, {1})
		if not self.db.profile.Minimap.style then
			self:addSkinFrame{obj=_G.TimeManagerClockButton, ft=ftype, x1=10, y1=-3, x2=-5, y2=5}
		end
	end

	-- Stopwatch Frame
	self:keepFontStrings(_G.StopwatchTabFrame)
	self:skinButton{obj=_G.StopwatchCloseButton, cb=true, sap=true}
	self:addSkinFrame{obj=_G.StopwatchFrame, ft=ftype, kfs=true, y1=-16, y2=2, nb=true}

end

function aObj:Tooltips()
	if not self.db.profile.Tooltips.skin or self.initialized.Tooltips then return end
	self.initialized.Tooltips = true

	-- skin Item Ref Tooltip's close button
	self:skinButton{obj=_G.ItemRefCloseButton, cb=true}

	if self.db.profile.Tooltips.style == 3 then
		-- Hook this to deal with GameTooltip FadeHeight issues
		self:SecureHookScript(_G.GameTooltipStatusBar, "OnHide", function(this)
			self:ScheduleTimer("skinTooltip", 0.1, _G.GameTooltip)
		end)
	end

	-- add tooltips to table to set backdrop and hook OnShow method
	for _, tooltip in pairs(self.ttCheck) do
		self:add2Table(self.ttList, tooltip)
	end
	self:add2Table(self.ttList, "SmallTextTooltip")

	-- Hook this to skin the GameTooltip StatusBars
	self:SecureHook("GameTooltip_ShowStatusBar", function(this, ...)
		if _G.GameTooltipStatusBar1 then
			self:removeRegions(_G.GameTooltipStatusBar1, {2})
			if aObj.db.profile.Tooltips.glazesb then
				self:glazeStatusBar(_G.GameTooltipStatusBar1, 0)
			end
		end
		if _G.GameTooltipStatusBar2 then
			self:removeRegions(_G.GameTooltipStatusBar2, {2})
			if aObj.db.profile.Tooltips.glazesb then
				self:glazeStatusBar(_G.GameTooltipStatusBar2, 0)
			end
			self:Unhook("GameTooltip_ShowStatusBar")
		end
	end)

end

function aObj:Tutorial()
	if not self.db.profile.Tutorial or self.initialized.Tutorial then return end
	self.initialized.Tutorial = true

	local function resetSF()

		-- use the same frame level & strata as TutorialFrame so it appears above other frames
		_G.TutorialFrame.sf:SetFrameLevel(_G.TutorialFrame:GetFrameLevel())
		_G.TutorialFrame.sf:SetFrameStrata(_G.TutorialFrame:GetFrameStrata())

	end
	_G.TutorialFrame:DisableDrawLayer("BACKGROUND")
	_G.TutorialFrameTop:SetTexture(nil)
	_G.TutorialFrameBottom:SetTexture(nil)
	for i = 1, 30 do
		_G["TutorialFrameLeft" .. i]:SetTexture(nil)
		_G["TutorialFrameRight" .. i]:SetTexture(nil)
	end
	_G.TutorialTextBorder:SetAlpha(0)
	self:skinScrollBar{obj=_G.TutorialFrameTextScrollFrame}
	-- stop animation before skinning, otherwise textures reappear
	_G.AnimateMouse:Stop()
	_G.AnimateCallout:Stop()
	self:addSkinFrame{obj=_G.TutorialFrame, ft=ftype, anim=true, x1=10, y1=-11, x2=1}
	resetSF()
	-- hook this as the TutorialFrame frame level keeps changing
	self:SecureHookScript(_G.TutorialFrame.sf, "OnShow", function(this)
		resetSF()
	end)
	-- hook this to hide the skin frame if required (e.g. arrow keys tutorial)
	self:SecureHook("TutorialFrame_Update", function(...)
		resetSF()
		_G.TutorialFrame.sf:SetShown(_G.TutorialFrameTop:IsShown())
	end)
	self:addButtonBorder{obj=_G.TutorialFramePrevButton, ofs=-2}
	self:addButtonBorder{obj=_G.TutorialFrameNextButton, ofs=-2}

-->>-- Alert button
	local btn =_G. TutorialFrameAlertButton
	btn:GetNormalTexture():SetAlpha(0)
	btn:SetNormalFontObject("ZoneTextFont")
	btn:SetText("?")
	self:moveObject{obj=btn:GetFontString(), x=4}
	self:addSkinButton{obj=btn, parent=btn, ft=ftype, x1=30, y1=-1, x2=-25, y2=10}

end

function aObj:WorldMap()
	if not self.db.profile.WorldMap.skin or self.initialized.WorldMap then return end
	self.initialized.WorldMap = true

	if not IsAddOnLoaded("Mapster")
	and not IsAddOnLoaded("AlleyMap")
	then
		local function sizeUp()

			_G.WorldMapFrame.sf:ClearAllPoints()
			_G.WorldMapFrame.sf:SetPoint("TOPLEFT", _G.WorldMapFrame, "TOPLEFT", 102, 1)
			_G.WorldMapFrame.sf:SetPoint("BOTTOMRIGHT", _G.WorldMapFrame, "BOTTOMRIGHT", -102, 1)

		end
		local function sizeDown()

			_G.WorldMapFrame.sf:ClearAllPoints()
			_G.WorldMapFrame.sf:SetPoint("TOPLEFT", _G.WorldMapFrame, "TOPLEFT", 0, 2)
			_G.WorldMapFrame.sf:SetPoint("BOTTOMRIGHT", _G.WorldMapFrame, "BOTTOMRIGHT", 2, -2)

		end
		-- handle size change
		self:SecureHook("WorldMap_ToggleSizeUp", function()
			sizeUp()
		end)
		self:SecureHook("WorldMap_ToggleSizeDown", function()
			sizeDown()
		end)
		self:SecureHook("WorldMapFrame_ToggleWindowSize", function()
			if _G.WORLDMAP_SETTINGS.size == _G.WORLDMAP_WINDOWED_SIZE then
				sizeDown()
			end
		end)
		-- handle different map addons being loaded or fullscreen required
		if self.db.profile.WorldMap.size == 2 then
			self:addSkinFrame{obj=_G.WorldMapFrame, ft=ftype, kfs=true, y1=1, x2=1}
		elseif not IsAddOnLoaded("MetaMap")
		and not IsAddOnLoaded("Cartographer_LookNFeel")
		then
			self:addSkinFrame{obj=_G.WorldMapFrame, ft=ftype, kfs=true}
			if _G.WORLDMAP_SETTINGS.size == _G.WORLDMAP_WINDOWED_SIZE then
				sizeDown()
			else
				sizeUp()
			end
		end
	end

	self:keepFontStrings(_G.WorldMapFrame.BorderFrame)
	self:removeInset(_G.WorldMapFrame.BorderFrame.Inset)
	self:skinButton{obj=_G.WorldMapFrameSizeDownButton, ob3="↕"} -- up-down arrow
	self:skinButton{obj=_G.WorldMapFrameSizeUpButton, ob3="↕"} -- up-down arrow
	_G.WorldMapFrame.MainHelpButton.Ring:SetTexture(nil)
	self:skinDropDown{obj=_G.WorldMapTitleDropDown}
	self:skinDropDown{obj=_G.WorldMapFrame.UIElementsFrame.TrackingOptionsButton.DropDown}
	_G.WorldMapFrame.UIElementsFrame.TrackingOptionsButton.Button.Border:SetTexture(nil)
	self:skinButton{obj=_G.WorldMapFrame.UIElementsFrame.TrackingOptionsButton.Button}
	if _G.WorldMapFrame.UIElementsFrame.TrackingOptionsButton.Button.sb then
		_G.LowerFrameLevel(_G.WorldMapFrame.UIElementsFrame.TrackingOptionsButton.Button.sb)
	end
	self:addButtonBorder{obj=_G.WorldMapFrame.UIElementsFrame.OpenQuestPanelButton}
	self:addButtonBorder{obj=_G.WorldMapFrame.UIElementsFrame.CloseQuestPanelButton}
	-->>-- Nav Bar
	_G.WorldMapFrame.NavBar:DisableDrawLayer("BACKGROUND")
	_G.WorldMapFrame.NavBar:DisableDrawLayer("BORDER")
	_G.WorldMapFrame.NavBar.overlay:DisableDrawLayer("OVERLAY")
	_G.WorldMapFrame.NavBar.home:DisableDrawLayer("OVERLAY")
	_G.WorldMapFrame.NavBar.home:GetNormalTexture():SetAlpha(0)
	_G.WorldMapFrame.NavBar.home:GetPushedTexture():SetAlpha(0)
	_G.WorldMapFrame.NavBar.home.text:SetPoint("RIGHT", -20, 0)

	self:skinDropDown{obj=_G.WorldMapLevelDropDown}

-->>-- Tooltip(s)
	if self.db.profile.Tooltips.skin then
		self:add2Table(self.ttList, "WorldMapTooltip")
		self:add2Table(self.ttList, "WorldMapCompareTooltip1")
		self:add2Table(self.ttList, "WorldMapCompareTooltip2")
	end

	self:removeRegions(_G.MapBarFrame, {1, 2, 3})
	self:glazeStatusBar(_G.MapBarFrame, 0, _G.MapBarFrame.FillBG)

	self:glazeStatusBar(_G.WorldMapTaskTooltipStatusBar.Bar, 0, self:getRegion(_G.WorldMapTaskTooltipStatusBar.Bar, 7))

end

function aObj:WorldState()
	if not self.db.profile.WorldState or self.initialized.WorldState then return end
	self.initialized.WorldState = true

	self:skinDropDown{obj=_G.ScorePlayerDropDown}
	self:skinScrollBar{obj=_G.WorldStateScoreScrollFrame}
	self:skinTabs{obj=_G.WorldStateScoreFrame}
	self:addSkinFrame{obj=_G.WorldStateScoreFrame, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-5}

end

function aObj:WowTokenUI()
	if not self.db.profile.WowTokenUI or self.initialized.WowTokenUI then return end
	self.initialized.WowTokenUI = true

	-- disable skinning of this frame
	self.db.profile.WowTokenUI = false

	-->> N.B. Currently can't be skinned, as the XML has a ScopedModifier element saying forbidden="true"

end
