local aName, aObj = ...
local _G = _G
local ftype = "u"

local ipairs, pairs, unpack = _G.ipairs, _G.pairs, _G.unpack
local IsAddOnLoaded = _G.IsAddOnLoaded

-- Tooltips skinning code
do
	-- list of Tooltips to check to see whether we should colour the Tooltip Border or not
	-- use strings as the objects may not exist when we start
	aObj.ttCheck = {"GameTooltip", "ShoppingTooltip1", "ShoppingTooltip2", "ItemRefTooltip", "ItemRefShoppingTooltip1", "ItemRefShoppingTooltip2", "SmallTextTooltip"}
	-- list of Tooltips used when the Tooltip style is 3
	-- using a metatable to manage tooltips when they are added in different functions
	aObj.ttList = _G.setmetatable({}, {__newindex = function(t, k, v)
		-- aObj:Debug("ttList __Newindex: [%s, %s, %s]", t, k, v)
		_G.rawset(t, k, v)
		-- get object reference for tooltip, handle either strings or objects being passed
		local tt = _G.type(v) == "string" and _G[v] or v
		-- set the backdrop if required
		if aObj.db.profile.Tooltips.style == 3 then
			tt:SetBackdrop(aObj.Backdrop[1])
		end
		-- hook the OnShow method, NOT the Show method
		aObj:HookScript(tt, "OnShow", function(this)
			if this == _G.GameTooltip
			and aObj.db.profile.Tooltips.glazesb
			then
				aObj:glazeStatusBar(_G.GameTooltipStatusBar, 0)
			end
		end)
		-- hook this to prevent Gradient overlay when tooltip reshown
		aObj:HookScript(tt, "OnUpdate", function(this)
			aObj:skinTooltip(this)
		end)
		-- skin here so tooltip initially skinnned when logged on
		aObj:skinTooltip(tt)
	end})
	-- Set the Tooltip Border
	aObj.ttBorder = true

end
-- The following functions are used by the GarrisonUI & OrderHallUI
local stageRegs = {1, 2, 3, 4, 5}
local navalStageRegs = {1, 2, 3, 4}
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
			fp.PortraitRingQuality:SetVertexColor(1, 1, 1)
			fp.PortraitRing:SetAtlas("GarrMission_PortraitRing_Quality") -- reset after legion titled follower
		end)
	end

end
local function skinFollower(frame)

	frame.BG:SetTexture(nil)
	if frame.AbilitiesBG then frame.AbilitiesBG:SetTexture(nil) end -- Mission Follower
	if frame.PortraitFrame then skinPortrait(frame.PortraitFrame) end

end
local function skinFollowerList(frame)

	aObj:removeRegions(frame, {1, 2, frame:GetParent() ~= _G.GarrisonLandingPage and 3 or nil})

	if frame.SearchBox then
		aObj:skinEditBox{obj=frame.SearchBox, regs={6, 7, 8}, mi=true} -- 6 is text, 7 is icon, 8 is text
		-- need to do this as background isn't visible on Shipyard Mission page
		_G.RaiseFrameLevel(frame.SearchBox)
	end
	aObj:skinSlider{obj=frame.listScroll.scrollBar, wdth=-4}

	for i = 1, #frame.listScroll.buttons do
		if frame ~= _G.GarrisonShipyardFrameFollowers
		and frame ~= _G.GarrisonLandingPageShipFollowerList
		then
			skinFollower(frame.listScroll.buttons[i].Follower)
		else
			skinFollower(frame.listScroll.buttons[i])
		end
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

	local ft = frame:GetParent().FollowerTab
	-- Ability buttons
	local btn
	for i = 1, #ft.AbilitiesFrame.Abilities do
		btn = ft.AbilitiesFrame.Abilities[i]
		aObj:addButtonBorder{obj=btn.IconButton}
		btn.IconButton.Border:SetTexture(nil)
	end
	-- CombatAllySpell buttons
	for i = 1, #ft.AbilitiesFrame.CombatAllySpell do
		btn = ft.AbilitiesFrame.CombatAllySpell[i]
		aObj:addButtonBorder{obj=btn, relTo=btn.iconTexture}
	end

	-- OrderHallUI
	if ft.AbilitiesFrame.Equipment then
		for i = 1, #ft.AbilitiesFrame.Equipment do
			btn = ft.AbilitiesFrame.Equipment[i]
			btn:DisableDrawLayer("BACKGROUND")
			btn.Border:SetTexture(nil)
			aObj:addButtonBorder{obj=btn, ofs=1, relTo=btn.Icon}
		end
	end
	ft, btn = nil

end
local function skinFollowerTraitsAndEquipment(obj)

	aObj:glazeStatusBar(obj.XPBar, 0,  nil)
	obj.XPBar:DisableDrawLayer("OVERLAY")
	local btn
	for i = 1, #obj.Traits do
		btn = obj.Traits[i]
		btn.Border:SetTexture(nil)
		aObj:addButtonBorder{obj=btn, relTo=btn.Portrait, ofs=1}
	end
	for i = 1, #obj.EquipmentFrame.Equipment do
		btn = obj.EquipmentFrame.Equipment[i]
		btn:DisableDrawLayer("BACKGROUND")
		btn.Border:SetTexture(nil)
		aObj:addButtonBorder{obj=btn, relTo=btn.Icon, ofs=1}
	end
	btn = nil

end
local function skinCompleteDialog(frame, naval)

	frame:SetSize(naval and 934 or 954, 630)
	aObj:moveObject{obj=frame, x=4, y=2}

	frame.BorderFrame:DisableDrawLayer("BACKGROUND")
	frame.BorderFrame:DisableDrawLayer("BORDER")
	frame.BorderFrame:DisableDrawLayer("OVERLAY")
	aObj:removeRegions(frame.BorderFrame.Stage, cdStageRegs)
	aObj:skinButton{obj=frame.BorderFrame.ViewButton}
    aObj:addSkinFrame{obj=frame.BorderFrame, ft=ftype, y2=-2}


end
local function skinMissionPage(obj)

	obj:DisableDrawLayer("BACKGROUND")
	obj:DisableDrawLayer("BORDER")
	obj:DisableDrawLayer("OVERLAY")
	obj.ButtonFrame:SetTexture(nil)

	aObj:removeRegions(obj.Stage, stageRegs)
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
		obj.RewardsFrame.Rewards[i].BG:SetTexture(nil)
		-- N.B. reward buttons have an IconBorder
	end

end
local function skinMissionComplete(obj, naval)

	local mcb = obj:GetParent().MissionCompleteBackground
    mcb:SetSize(naval and 952 or 953, 642)
	aObj:moveObject{obj=mcb, x=4, y=2}
	mcb = nil

    obj:DisableDrawLayer("BACKGROUND")
	obj:DisableDrawLayer("BORDER")
	obj:DisableDrawLayer("ARTWORK")
	aObj:removeRegions(obj.Stage, naval and navalStageRegs or stageRegs) -- top half only
	local frame
	for i = 1, #obj.Stage.FollowersFrame.Followers do
		frame = obj.Stage.FollowersFrame.Followers[i]
        if naval then
            frame.NameBG:SetTexture(nil)
        else
            aObj:removeRegions(frame, {1})
        end
		if frame.PortraitFrame then skinPortrait(frame.PortraitFrame) end
		aObj:glazeStatusBar(frame.XP, 0,  nil)
		frame.XP:DisableDrawLayer("OVERLAY")
	end
	frame = nil
    obj.BonusRewards:DisableDrawLayer("BACKGROUND")
	obj.BonusRewards:DisableDrawLayer("BORDER")
	aObj:getRegion(obj.BonusRewards, 11):SetTextColor(aObj.HTr, aObj.HTg, aObj.HTb) -- Heading
    obj.BonusRewards.Saturated:DisableDrawLayer("BACKGROUND")
	obj.BonusRewards.Saturated:DisableDrawLayer("BORDER")
    aObj:addSkinFrame{obj=obj, ft=ftype, y1=6, y2=-16}

end
local function skinMissionList(ml)

	ml:DisableDrawLayer("BORDER")
	ml.MaterialFrame:DisableDrawLayer("BACKGROUND")

	-- tabs at top
	local tab
	for i = 1, 2 do
		tab = ml["Tab" .. i]
		tab:DisableDrawLayer("BORDER")
		aObj:addSkinFrame{obj=tab, ft=ftype, noBdr=aObj.isTT}
		tab.sf.ignore = true -- don't change tab size
		if aObj.isTT then
			if i == 1 then
				aObj:setActiveTab(tab.sf)
			else
				aObj:setInactiveTab(tab.sf)
			end
			aObj:SecureHookScript(tab, "OnClick", function(this)
				local list = this:GetParent()
				aObj:setActiveTab(this.sf)
				if this:GetID() == 1 then
					aObj:setInactiveTab(list.Tab2.sf)
				else
					aObj:setInactiveTab(list.Tab1.sf)
				end
				list = nil
			end)
		end
	end
	tab = nil

	aObj:skinSlider{obj=ml.listScroll.scrollBar, wdth=-4}
	local btn
	for i = 1, #ml.listScroll.buttons do
		btn = ml.listScroll.buttons[i]
		btn:DisableDrawLayer("BACKGROUND")
		btn:DisableDrawLayer("BORDER")
		-- extend the top & bottom highlight texture
		btn.HighlightT:ClearAllPoints()
		btn.HighlightT:SetPoint("TOPLEFT", 0, 4)
		btn.HighlightT:SetPoint("TOPRIGHT", 0, 4)
        btn.HighlightB:ClearAllPoints()
        btn.HighlightB:SetPoint("BOTTOMLEFT", 0, -4)
        btn.HighlightB:SetPoint("BOTTOMRIGHT", 0, -4)
		aObj:removeRegions(btn, {13, 14, 23, 24, 25, 26}) -- LocBG, RareOverlay, Highlight corners
		-- N.B. reward buttons have an IconBorder
	end
	btn = nil

	-- CompleteDialog
	skinCompleteDialog(ml.CompleteDialog)

end
-- The following functions are used by several Chat* functions
local function skinChatEB(obj)

	local kRegions
	if aObj.db.profile.ChatEditBox.style == 1 then -- Frame
		kRegions = _G.CopyTable(aObj.ebRgns)
		aObj:add2Table(kRegions, 9) -- 9 is text
		aObj:add2Table(kRegions, 10) -- 10 is text
		aObj:keepRegions(obj, kRegions)
		aObj:addSkinFrame{obj=obj, ft=ftype, nb=true, x1=2, y1=-2, x2=-2}
		obj.sf:SetAlpha(obj:GetAlpha())
	elseif aObj.db.profile.ChatEditBox.style == 2 then -- Editbox
		aObj:skinEditBox{obj=obj, regs={9, 10}, noHeight=true}
	else -- Borderless
		aObj:removeRegions(obj, {3, 4, 5})
		aObj:addSkinFrame{obj=obj, ft=ftype, nb=true, noBdr=true, x1=5, y1=-4, x2=-5, y2=2}
		obj.sf:SetAlpha(obj:GetAlpha())
	end
	kRegions = nil

end
local function skinChatTab(tab)

	aObj:rmRegionsTex(tab, {1, 2, 3, 4, 5, 6})
	aObj:addSkinFrame{obj=tab, ft=ftype, noBdr=aObj.isTT, x1=2, y1=-9, x2=-2, y2=-4}
	tab.sf:SetAlpha(tab:GetAlpha())
	-- hook this to fix tab gradient texture overlaying text & highlight
	aObj:secureHook(tab, "SetParent", function(this, parent)
		if parent == _G.GeneralDockManager.scrollFrame.child then
			this.sf:SetParent(_G.GeneralDockManager)
		else
			this.sf:SetParent(this)
			this.sf:SetFrameLevel(1) -- reset frame level so that the texture is behind text etc
		end
	end)
	-- hook this to manage alpha changes when chat frame fades in and out
	aObj:secureHook(tab, "SetAlpha", function(this, alpha)
		this.sf:SetAlpha(alpha)
	end)

end

aObj.blizzFrames[ftype].AddonList = function(self)
	if not self.db.profile.AddonList or self.initialized.AddonList then return end
	self.initialized.AddonList = true

	self:skinDropDown{obj=_G.AddonCharacterDropDown, x2=110}
	self:skinSlider{obj=_G.AddonListScrollFrame.ScrollBar, rt="background"}
	self:removeMagicBtnTex(_G.AddonList.CancelButton)
	self:removeMagicBtnTex(_G.AddonList.OkayButton)
	self:removeMagicBtnTex(_G.AddonList.EnableAllButton)
	self:removeMagicBtnTex(_G.AddonList.DisableAllButton)
	self:addSkinFrame{obj=_G.AddonList, ft=ftype, kfs=true, ri=true, ofs=2, x2=1}

end

aObj.blizzLoDFrames[ftype].AdventureMap = function(self)
	if not self.db.profile.AdventureMap or self.initialized.AdventureMap then return end
	self.initialized.AdventureMap = true

	-- AdventureMapQuestChoiceDialog
	_G.AdventureMapQuestChoiceDialog:DisableDrawLayer("BACKGROUND") -- remove textures
	self:skinSlider{obj=_G.AdventureMapQuestChoiceDialog.Details.ScrollBar}
	_G.AdventureMapQuestChoiceDialog.Details.Child.TitleHeader:SetTextColor(self.HTr, self.HTg, self.HTb)
	_G.AdventureMapQuestChoiceDialog.Details.Child.DescriptionText:SetTextColor(self.BTr, self.BTg, self.BTb)
	_G.AdventureMapQuestChoiceDialog.Details.Child.ObjectivesHeader:SetTextColor(self.HTr, self.HTg, self.HTb)
	_G.AdventureMapQuestChoiceDialog.Details.Child.ObjectivesText:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:addSkinFrame{obj=_G.AdventureMapQuestChoiceDialog, ft=ftype, y1=-11, x2=1, y2=-4}

	self:SecureHook(_G.AdventureMapQuestChoiceDialog, "RefreshRewards", function(this)
		for reward in this.rewardPool:EnumerateActive() do
			reward.ItemNameBG:SetTexture(nil)
			self:addButtonBorder{obj=reward, relTo=reward.Icon, reParent={reward.Count}}
		end
	end)

end

aObj.blizzFrames[ftype].AlertFrames = function(self)
	if not self.db.profile.AlertFrames or self.initialized.AlertFrames then return end
	self.initialized.AlertFrames = true

	-- hook this to stop gradient texture whiteout
	self:RawHook(_G.AlertFrame, "AddAlertFrame", function(this, frame)

		-- aObj:Debug("AlertFrame AddAlertFrame: [%s, %s]", this, frame)

		-- run the hooked function
		self.hooks[this].AddAlertFrame(this, frame)

		-- adjust size if guild achievement
		if aObj:hasTextInName(frame, "AchievementAlertFrame") then
			local y1, y2 = -10, 12
	 		if frame.guildDisplay then y1, y2 = -8, 8 end
			frame.sf:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, y1)
			frame.sf:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 5, y2)
			y1, y2 = nil, nil
		end

	end, true)

	-- hook this to remove rewardFrame rings
	self:SecureHook("StandardRewardAlertFrame_AdjustRewardAnchors", function(frame)
		if frame.RewardFrames then
			for i = 1, #frame.RewardFrames do
				frame.RewardFrames[i]:DisableDrawLayer("OVERLAY") -- reward ring
			end
		end
	end)

	-- hook these to manage Gradient texture when animating
	self:SecureHook("AlertFrame_StopOutAnimation", function(frame)
		if frame.sf then frame.sf.tfade:SetGradientAlpha(self:getGradientInfo()) end
		if frame.cb then frame.cb.tfade:SetGradientAlpha(self:getGradientInfo()) end
	end)
	self:Hook("AlertFrame_ResumeOutAnimation", function(frame)
		if frame.sf then frame.sf.tfade:SetAlpha(0) end
		if frame.cb then frame.cb.tfade:SetAlpha(0) end
		-- self.hooks.AlertFrame_ResumeOutAnimation(frame)
	end, true)

	-- called params: frame, challengeType, count, max ("Raid", 2, 5)
	self:SecureHook(_G.GuildChallengeAlertSystem, "setUpFunction", function(frame, ...)
		-- aObj:Debug("GuildChallengeAlertSystem: [%s, %s, %s, %s]", frame, ...)
		frame:DisableDrawLayer("BACKGROUND")
		frame:DisableDrawLayer("BORDER")
		frame:DisableDrawLayer("OVERLAY")
		aObj:addSkinFrame{obj=frame, ft=ftype, ofs=-10}
	end)
	-- called params: frame, rewardQuestID, name, showBonusCompletion, xp, money (123456, "Test", true, 2500, 1234)
	self:SecureHook(_G.InvasionAlertSystem, "setUpFunction", function(frame, ...)
		-- aObj:Debug("InvasionAlertSystem: [%s, %s, %s, %s, %s, %s]", frame, ...)
		aObj:getRegion(frame, 1):SetTexture(nil) -- Background toast texture
		aObj:getRegion(frame, 2):SetDrawLayer("ARTWORK") -- move icon to ARTWORK layer so it is displayed
		-- TODO add border to icon ?
		aObj:addSkinFrame{obj=frame, ft=ftype, ofs=-8}
	end)
	-- called params: frame, raceName, raceTexture ("Demonic", "")
	self:SecureHook(_G.DigsiteCompleteAlertSystem, "setUpFunction", function(frame, ...)
		-- aObj:Debug("DigsiteCompleteAlertSystem: [%s, %s, %s]", frame, ...)
		frame:DisableDrawLayer("BACKGROUND")
		self:addSkinFrame{obj=frame, ft=ftype, ofs=-10}
	end)
	-- called params: frame, type, icon, name, payloadID
	self:SecureHook(_G.StorePurchaseAlertSystem, "setUpFunction", function(frame, ...)
		-- aObj:Debug("StorePurchaseAlertSystem: [%s, %s, %s, %s, %s]", frame, ...)
		frame:DisableDrawLayer("BACKGROUND")
		self:addSkinFrame{obj=frame, ft=ftype, ofs=-8}
	end)
	-- called params: frame, name, garrisonType ("Menagerie", "")
	self:SecureHook(_G.GarrisonBuildingAlertSystem, "setUpFunction", function(frame, ...)
		-- aObj:Debug("GarrisonBuildingAlertSystem: [%s, %s, %s]", frame, ...)
		frame:DisableDrawLayer("BACKGROUND")
		frame.Icon:SetDrawLayer("BORDER")
		self:addButtonBorder{obj=frame, relTo=frame.Icon}
		self:addSkinFrame{obj=frame, ft=ftype, ofs=-10}
	end)
	-- called params: frame, missionInfo=({name="Test", typeAtlas="", followerTypeID=LE_FOLLOWER_TYPE_GARRISON_7_0})
	self:SecureHook(_G.GarrisonMissionAlertSystem, "setUpFunction", function(frame, ...)
		-- aObj:Debug("GarrisonMissionAlertSystem: [%s, %s]", frame, ...)
		frame:DisableDrawLayer("BACKGROUND")
		frame:DisableDrawLayer("BORDER")
		self:addSkinFrame{obj=frame, ft=ftype, ofs=-10, y1=-8}
	end)
	-- called params: frame, missionInfo=({name="Test", typeAtlas="", followerTypeID=LE_FOLLOWER_TYPE_GARRISON_7_0})
	self:SecureHook(_G.GarrisonShipMissionAlertSystem, "setUpFunction", function(frame, ...)
		-- aObj:Debug("GarrisonShipMissionAlertSystem: [%s, %s]", frame, ...)
		frame:DisableDrawLayer("BACKGROUND")
		self:addSkinFrame{obj=frame, ft=ftype, ofs=-10}
	end)
	-- called params: frame, missionInfo=({level=105, iLevel=875, isRare=true, followerTypeID=LE_FOLLOWER_TYPE_GARRISON_6_0})
	self:SecureHook(_G.GarrisonRandomMissionAlertSystem, "setUpFunction", function(frame, ...)
		-- aObj:Debug("GarrisonRandomMissionAlertSystem: [%s, %s]", frame, ...)
		frame:DisableDrawLayer("BACKGROUND")
		frame.MissionType:SetDrawLayer("BORDER")
		self:addSkinFrame{obj=frame, ft=ftype, ofs=-10}
	end)
	-- called params: frame, followerID, name, level, quality, isUpgraded, followerInfo={isTroop=, followerTypeID=, portraitIconID=, quality=, level=, iLevel=}
	self:SecureHook(_G.GarrisonFollowerAlertSystem, "setUpFunction", function(frame, ...)
		-- aObj:Debug("GarrisonFollowerAlertSystem: [%s, %s, %s, %s, %s, %s, %s]", frame, ...)
		frame:DisableDrawLayer("BACKGROUND")
		frame.PortraitFrame.PortraitRing:SetTexture(nil)
		frame.PortraitFrame.LevelBorder:SetTexture(nil)
		frame.PortraitFrame.LevelBorder.SetTexture = _G.nop
		frame.FollowerBG:SetTexture(nil)
		frame.FollowerBG.SetTexture = _G.nop
		self:addSkinFrame{obj=frame, ft=ftype, ofs=-8}
	end)
	-- called params: frame, followerID, name, class, texPrefix, level, quality, isUpgraded, followerInfo={}
	self:SecureHook(_G.GarrisonShipFollowerAlertSystem, "setUpFunction", function(frame, ...)
		-- aObj:Debug("GarrisonShipFollowerAlertSystem: [%s, %s, %s, %s, %s, %s, %s, %s, %s]", frame, ...)
		-- Spew("GarrisonShipFollowerAlertSystem", _G.select(8, ...))
		frame:DisableDrawLayer("BACKGROUND")
		frame.FollowerBG:SetTexture(nil)
		frame.FollowerBG.SetTexture = _G.nop
		self:addSkinFrame{obj=frame, ft=ftype, ofs=-8}
	end)
	-- called params: frame, garrisonType, talent={icon=""}
	self:SecureHook(_G.GarrisonTalentAlertSystem, "setUpFunction", function(frame, ...)
		-- aObj:Debug("GarrisonTalentAlertSystem: [%s, %s, %s]", frame, ...)
		frame:DisableDrawLayer("BACKGROUND")
		frame.Icon:SetDrawLayer("BORDER")
		self:addButtonBorder{obj=frame, relTo=frame.Icon}
		self:addSkinFrame{obj=frame, ft=ftype, ofs=-10}
	end)
	-- called params: frame, questData (1234)
	self:SecureHook(_G.WorldQuestCompleteAlertSystem, "setUpFunction", function(frame, ...)
		-- aObj:Debug("WorldQuestCompleteAlertSystem: [%s, %s]", frame, ...)
		frame.QuestTexture:SetDrawLayer("ARTWORK")
		frame:DisableDrawLayer("BORDER") -- toast texture
		self:addButtonBorder{obj=frame, relTo=frame.QuestTexture}
		self:addSkinFrame{obj=frame, ft=ftype, ofs=-6, y1=-10}
	end)
	-- called params: frame, itemLink (137080)
	self:SecureHook(_G.LegendaryItemAlertSystem, "setUpFunction", function(frame, ...)
		-- aObj:Debug("LegendaryItemAlertSystem: [%s, %s]", frame, ...)
		frame.Background:SetTexture(nil)
		frame.Background2:SetTexture(nil)
		frame.Background3:SetTexture(nil)
		self:addSkinFrame{obj=frame, ft=ftype, ofs=-12}
	end)
	-- called params: self, itemLink, quantity, rollType, roll, specID, isCurrency, showFactionBG, lootSource, lessAwesome, isUpgraded, isPersonal, showRatedBG
	self:SecureHook(_G.LootAlertSystem, "setUpFunction", function(frame, ...)
		-- aObj:Debug("LootAlertSystem: [%s, %s]", frame, #...)
		-- Spew("LootAlertSystem", ...)
		frame:DisableDrawLayer("BACKGROUND")
		frame.SpecRing:SetTexture(nil)
		self:addSkinFrame{obj=frame, ft=ftype, ofs=-10, y2=8}
	end)
	-- called parms: self, itemLink, quantity, specID, baseQuality (147239, 1, 1234, 5)
	self:SecureHook(_G.LootUpgradeAlertSystem, "setUpFunction", function(frame, ...)
		aObj:Debug("LootUpgradeAlertSystem: [%s, %s, %s, %s, %s]", frame, ...)
		Spew("LootUpgradeAlertSystem", ...)
		frame:DisableDrawLayer("BACKGROUND")
		self:addSkinFrame{obj=frame, ft=ftype, ofs=-10, y2=8}
	end)
	-- called params: self, amount (12345)
	self:SecureHook(_G.MoneyWonAlertSystem, "setUpFunction", function(frame, ...)
		-- aObj:Debug("MoneyWonAlertSystem: [%s, %s]", frame, ...)
		frame:DisableDrawLayer("BACKGROUND")
		self:addSkinFrame{obj=frame, ft=ftype, ofs=-8, y2=8}
	end)
	-- called params: self, recipeID (209645)
	self:SecureHook(_G.NewRecipeLearnedAlertSystem, "setUpFunction", function(frame, ...)
		-- aObj:Debug("NewRecipeLearnedAlertSystem: [%s, %s]", frame, ...)
		frame:DisableDrawLayer("BACKGROUND")
		frame.Icon:SetDrawLayer("BORDER")
		self:addSkinFrame{obj=frame, ft=ftype, ofs=-8}
	end)
	-- called params: self, amount (350)
	self:SecureHook(_G.HonorAwardedAlertSystem, "setUpFunction", function(frame, ...)
		-- aObj:Debug("HonorAwardedAlertSystem: [%s, %s]", frame, ...)
		frame:DisableDrawLayer("BACKGROUND")
		self:addSkinFrame{obj=frame, ft=ftype, ofs=-8, y2=8}
	end)
	if self.isPTR then
		-- called params: frame, petID
		self:SecureHook(_G.NewPetAlertSystem, "setUpFunction", function(frame, ...)
			aObj:Debug("NewPetAlertSystem: [%s, %s]", frame, ...)
			frame:DisableDrawLayer("BACKGROUND")
			self:addSkinFrame{obj=frame, ft=ftype, ofs=-8}
		end)
		-- called params: frame, mountID
		self:SecureHook(_G.NewMountAlertSystem, "setUpFunction", function(frame, ...)
			aObj:Debug("NewMountAlertSystem: [%s, %s]", frame, ...)
			frame:DisableDrawLayer("BACKGROUND")
			self:addSkinFrame{obj=frame, ft=ftype, ofs=-8}
		end)
	end

	local function skinDCSAlertFrames(opts)

		opts.obj:DisableDrawLayer("BORDER")
		opts.obj:DisableDrawLayer("OVERLAY")
		opts.obj.dungeonTexture:SetDrawLayer("ARTWORK") -- move Dungeon texture above skinButton
		aObj:addSkinFrame{obj=opts.obj, ft=ftype, ofs=opts.ofs or -8, y1=opts.y1 or nil}
		-- wait for animation to finish
		_G.C_Timer.After(0.2, function()
			aObj:addButtonBorder{obj=opts.obj, relTo=opts.obj.dungeonTexture}
		end)

	end
	-- called params: frame, rewardData={}
	self:SecureHook(_G.DungeonCompletionAlertSystem, "setUpFunction", function(frame, rewardData)
		aObj:Debug("DungeonCompletionAlertSystem: [%s, %s]", frame, rewardData)
		Spew("DungeonCompletionAlertSystem", rewardData)
		skinDCSAlertFrames{obj=frame, y1=-17}
	end)
	-- called params: frame, rewardData=({name="Test", iconTextureFile="", hasBonusStep=True, isBonusStepComplete=True, moneyAmount=1234, experienceGained=1500, numRewards={}, })
	self:SecureHook(_G.ScenarioAlertSystem, "setUpFunction", function(frame, rewardData)
		aObj:Debug("ScenarioAlertSystem: [%s, %s]", frame, rewardData)
		Spew("ScenarioAlertSystem", rewardData)
		self:getRegion(frame, 1):SetTexture(nil) -- Toast-IconBG
		skinDCSAlertFrames{obj=frame, ofs=-12}
	end)

	local function skinACAlertFrames(frame)

		local fH = aObj:getInt(frame:GetHeight())

		frame.Background:SetTexture(nil)
		frame.Background.SetTexture = _G.nop
		frame.Unlocked:SetTextColor(aObj.BTr, aObj.BTg, aObj.BTb)
		frame.Icon:DisableDrawLayer("BORDER")
		frame.Icon:DisableDrawLayer("OVERLAY")

		if frame.OldAchievement then frame.OldAchievement:SetTexture(nil) end -- AchievementAlertFrame(s)

		local x1, y1, x2, y2 = 6, -13, -4, 15
		-- CriteriaAlertFrame is smaller than most (Achievement Progress etc)
		if fH == 52 then
			x1, y1, x2, y2 = 30, 0, 0, 5
		end
		-- GuildAchievementFrame is taller than most (Achievement Progress etc)
		if fH == 104 then
			y1, y2 = -8, 10
		end
		if not frame.sf then
			aObj:addButtonBorder{obj=frame.Icon, relTo=frame.Icon.Texture}
			aObj:addSkinFrame{obj=frame, ft=ftype, x1=x1, y1=y1, x2=x2, y2=y2}
		end
		fH, x1, y1, x2, y2 = nil, nil, nil ,nil ,nil

	end
	-- called params: frame, achievementID, alreadyEarned (10585, true)
	self:SecureHook(_G.AchievementAlertSystem, "setUpFunction", function(frame, ...)
		-- aObj:Debug("AchievementAlertSystem: [%s, %s, %s]", frame, ...)
		skinACAlertFrames(frame)
	end)
	--called params: frame, achievementID, criteriaString (10607, "Test")
	self:SecureHook(_G.CriteriaAlertSystem, "setUpFunction", function(frame, ...)
		-- aObj:Debug("CriteriaAlertSystem: [%s, %s, %s]", frame, ...)
		skinACAlertFrames(frame)
	end)

end

aObj.blizzFrames[ftype].ArtifactToasts = function(self)
	if not self.db.profile.ArtifactUI or self.initialized.ArtifactToasts then return end
	self.initialized.ArtifactToasts = true

	_G.ArtifactLevelUpToast:DisableDrawLayer("BACKGROUND")
	_G.ArtifactLevelUpToast:DisableDrawLayer("BORDER")
	_G.ArtifactLevelUpToast.IconFrame:SetTexture(nil)

end

aObj.blizzLoDFrames[ftype].ArtifactUI = function(self)
	if not self.db.profile.ArtifactUI or self.initialized.ArtifactUI then return end
	self.initialized.ArtifactUI = true

	_G.ArtifactFrame.ForgeBadgeFrame:DisableDrawLayer("OVERLAY") -- this hides the frame
	_G.ArtifactFrame.ForgeBadgeFrame.ForgeLevelLabel:SetDrawLayer("ARTWORK") -- this shows the artifact level

	self:keepFontStrings(_G.ArtifactFrame.BorderFrame)
	self:addSkinFrame{obj=_G.ArtifactFrame, ft=ftype, ofs=5, y1=4}
	-- tabs
	self:skinTabs{obj=_G.ArtifactFrame, regs={}, ignore=true, lod=true, x1=6, y1=9, x2=-6, y2=-4}

	-- PerksTab
	_G.ArtifactFrame.PerksTab:DisableDrawLayer("BORDER")
	_G.ArtifactFrame.PerksTab:DisableDrawLayer("OVERLAY")
	_G.ArtifactFrame.PerksTab.TitleContainer.Background:SetAlpha(0) -- title underline texture
	_G.ArtifactFrame.PerksTab.Model:DisableDrawLayer("OVERLAY")
	-- CrestFrame
	for i = 1, 14 do
		_G.ArtifactFrame.PerksTab.CrestFrame["CrestRune" .. i]:SetAtlas(nil)
	end
	-- hook this to stop Background being Refreshed
	_G.ArtifactPerksMixin.RefreshBackground = _G.nop
	-- PerksTab powerButtons
	local function skinPowerBtns()

		if _G.ArtifactFrame.PerksTab.PowerButtons then
			for i = 1, #_G.ArtifactFrame.PerksTab.PowerButtons do
				aObj:changeTandC(_G.ArtifactFrame.PerksTab.PowerButtons[i].RankBorder, aObj.lvlBG)
				aObj:changeTandC(_G.ArtifactFrame.PerksTab.PowerButtons[i].RankBorderFinal, aObj.lvlBG)
			end
		end

	end
	skinPowerBtns()
	-- hook this to skin new buttons
	self:SecureHook(_G.ArtifactFrame.PerksTab, "RefreshPowers", function(this, newItem)
		skinPowerBtns()
	end)

	-- AppearancesTab
	self:SecureHook(_G.ArtifactFrame.AppearancesTab, "Refresh", function(this)
		for appearanceSet in this.appearanceSetPool:EnumerateActive() do
			appearanceSet:DisableDrawLayer("BACKGROUND")
		end
		for appearanceSlot in this.appearanceSlotPool:EnumerateActive() do
			appearanceSlot:DisableDrawLayer("BACKGROUND")
			appearanceSlot.Border:SetTexture(nil)
		end
	end)

	if self.isPTR then
		-- ArtifactRelicForgeUI
		_G.ArtifactRelicForgeFrame.TitleContainer.Background:SetAlpha(0)
		for i = 1, 3 do
			self:skinButton{obj=_G.ArtifactRelicForgeFrame.TitleContainer["RelicSlot" .. i].AttuneButton}
		end
		self:skinButton{obj=_G.ArtifactRelicForgeFrame.PreviewRelicFrame.AttuneButton}
		self:addSkinFrame{obj=_G.ArtifactRelicForgeFrame, ft=ftype, kfs=true, ri=true, ofs=2, x2=1}
	end



end

aObj.blizzFrames[ftype].AuthChallengeUI = function(self)
	if not self.db.profile.AuthChallengeUI or self.initialized.AuthChallengeUI then return end
	self.initialized.AuthChallengeUI = true

	-->> N.B. Currently can't be skinned, as the XML has a ScopedModifier element saying fullLockdown="true"

	-- disable skinning of this frame
	self.db.profile.AuthChallengeUI = false

end

aObj.blizzFrames[ftype].AutoComplete = function(self)
	if not self.db.profile.AutoComplete or self.initialized.AutoComplete then return end
	self.initialized.AutoComplete = true

	self:addSkinFrame{obj=_G.AutoCompleteBox, kfs=true, ft=ftype}

end

aObj.blizzLoDFrames[ftype].BattlefieldMinimap = function(self)
	if not self.db.profile.BattlefieldMm.skin or self.initialized.BattlefieldMm then return end
	self.initialized.BattlefieldMm = true

-->>--	Minimap Tab
	self:keepRegions(_G.BattlefieldMinimapTab, {4, 5}) -- N.B. region 4 is the Text, 5 is the highlight
	-- local asopts = self.isTT and {ba=1} or nil
	self:addSkinFrame{obj=_G.BattlefieldMinimapTab, ft=ftype, noBdr=self.isTT, aso=self.isTT and {ba=1} or nil, y1=-7, y2=-7}
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
		alpha= nil
	end)

	if IsAddOnLoaded("Capping") then
		if _G.type(self["Capping_ModMap"]) == "function" then self:Capping_ModMap() end
	end

	if IsAddOnLoaded("Mapster") then
		local Mapster = _G.LibStub("AceAddon-3.0"):GetAddon("Mapster", true)
		local mBM = Mapster:GetModule("BattleMap", true)
		if mBM then
			local bmDB = Mapster.db:GetNamespace("BattleMap", true).profile
			local function updBMVisibility()
				if bmDB.hideTextures then
					_G.BattlefieldMinimap.sf:Hide()
				else
					_G.BattlefieldMinimap.sf:Show()
				end
			end
			bmDB = nil
			self:SecureHook(mBM, "UpdateTextureVisibility", function()
				updBMVisibility()
			end)
			-- change visibility as required
			updBMVisibility()
		end
		Mapster, mBM = nil, nil
	end

end

aObj.blizzLoDFrames[ftype].BindingUI = function(self)
	if not self.db.profile.MenuFrames or self.initialized.BindingUI then return end
	self.initialized.BindingUI = true

	-- just put a backdrop border around the frames
	self:keepRegions(_G.KeyBindingFrame.categoryList, {})
	_G.KeyBindingFrame.categoryList:SetBackdrop(self.Backdrop[10])
	_G.KeyBindingFrame.categoryList:SetBackdropBorderColor(self.bbColour[1], self.bbColour[2], self.bbColour[3], self.bbColour[4])
	_G.KeyBindingFrame.bindingsContainer:SetBackdrop(self.Backdrop[10])
	_G.KeyBindingFrame.bindingsContainer:SetBackdropBorderColor(self.bbColour[1], self.bbColour[2], self.bbColour[3], self.bbColour[4])
	self:skinSlider{obj=_G.KeyBindingFrame.scrollFrame.ScrollBar, rt={"background", "border"}}
	for i = 1, #_G.KeyBindingFrame.keyBindingRows do
		self:skinButton{obj=_G.KeyBindingFrame.keyBindingRows[i].key1Button}
		self:skinButton{obj=_G.KeyBindingFrame.keyBindingRows[i].key2Button}
	end
	self:addSkinFrame{obj=_G.KeyBindingFrame, ft=ftype, kfs=true, hdr=true}

end

aObj.blizzFrames[ftype].BNFrames = function(self)
	if not self.db.profile.BNFrames or self.initialized.BNFrames then return end
	self.initialized.BNFrames = true

-->>-- Toast frame
	-- hook these to stop gradient texture whiteout
	self:Hook("BNToastFrame_Show", function()
		_G.BNToastFrame.sf.tfade:SetParent(_G.MainMenuBar)
		if _G.BNToastFrame.cb then _G.BNToastFrame.cb.tfade:SetParent(_G.MainMenuBar) end
		-- reset Gradient alpha
		_G.BNToastFrame.sf.tfade:SetGradientAlpha(self:getGradientInfo())
		if _G.BNToastFrame.cb then _G.BNToastFrame.cb.tfade:SetGradientAlpha(self:getGradientInfo()) end
	end, true)
	self:Hook("BNToastFrame_Close", function()
		_G.BNToastFrame.sf.tfade:SetParent(_G.BNToastFrame.sf)
		if _G.BNToastFrame.cb then _G.BNToastFrame.cb.tfade:SetParent(_G.BNToastFrame.cb) end
	end, true)
	self:addSkinFrame{obj=_G.BNToastFrame, ft=ftype}

-->>-- Report frame
	_G.BNetReportFrameComment:DisableDrawLayer("BACKGROUND")
	self:skinSlider{obj=_G.BNetReportFrameCommentScrollFrame.ScrollBar}
	self:skinEditBox{obj=_G.BNetReportFrameCommentBox, regs={3}}
	self:addSkinFrame{obj=_G.BNetReportFrame, ft=ftype}

-->>-- TimeAlert Frame
	self:Hook("TimeAlert_Start", function(time)
		_G.TimeAlertFrame.sf.tfade:SetParent(_G.MainMenuBar)
		-- reset Gradient alpha
		_G.TimeAlertFrame.sf.tfade:SetGradientAlpha(self:getGradientInfo())
	end, true)
	self:Hook("TimeAlert_Close", function()
		_G.TimeAlertFrame.sf.tfade:SetParent(_G.TimeAlertFrame.sf)

	end, true)
	_G._G.TimeAlertFrameBG:SetBackdrop(nil)
	self:addSkinFrame{obj=_G.TimeAlertFrame, ft=ftype}



end

aObj.blizzLoDFrames[ftype].Calendar = function(self)
	if not self.db.profile.Calendar or self.initialized.Calendar then return end
	self.initialized.Calendar = true

-->>--	Calendar Frame
	self:keepFontStrings(_G.CalendarFilterFrame)
	-- move close button
	self:moveObject{obj=_G.CalendarCloseButton, y=14}
	self:adjHeight{obj=_G.CalendarCloseButton, adj=-2}
	self:addButtonBorder{obj=_G.CalendarPrevMonthButton, ofs=-2, y1=-3, x2=-3}
	self:addButtonBorder{obj=_G.CalendarNextMonthButton, ofs=-2, y1=-3, x2=-3}
	self:addButtonBorder{obj=_G.CalendarFilterButton, es=14, x1=3, y1=0, x2=3, y2=0}
	self:addSkinFrame{obj=_G.CalendarFrame, ft=ftype, kfs=true, x1=1, y1=-2, x2=2, y2=-7}
	-- remove texture from day buttons
	for i = 1, 7 * 6 do
		_G["CalendarDayButton" .. i]:GetNormalTexture():SetTexture(nil)
	end

-->>-- View Holiday Frame
	self:keepFontStrings(_G.CalendarViewHolidayTitleFrame)
	self:moveObject{obj=_G.CalendarViewHolidayTitleFrame, y=-6}
	self:removeRegions(_G.CalendarViewHolidayCloseButton, {5})
	self:skinSlider{obj=_G.CalendarViewHolidayScrollFrame.ScrollBar}
	self:addSkinFrame{obj=_G.CalendarViewHolidayFrame, ft=ftype, kfs=true, x1=2, y1=-3, x2=-3, y2=-2}

-->>-- View Raid Frame
	self:keepFontStrings(_G.CalendarViewRaidTitleFrame)
	self:moveObject{obj=_G.CalendarViewRaidTitleFrame, y=-6}
	self:removeRegions(_G.CalendarViewRaidCloseButton, {5})
	self:skinSlider{obj=_G.CalendarViewRaidScrollFrame.ScrollBar}
	self:addSkinFrame{obj=_G.CalendarViewRaidFrame, ft=ftype, kfs=true, x1=2, y1=-3, x2=-3, y2=2}

-->>-- View Event Frame
	self:keepFontStrings(_G.CalendarViewEventTitleFrame)
	self:moveObject{obj=_G.CalendarViewEventTitleFrame, y=-6}
	self:removeRegions(_G.CalendarViewEventCloseButton, {5})
	self:addSkinFrame{obj=_G.CalendarViewEventDescriptionContainer, ft=ftype}
	self:skinSlider{obj=_G.CalendarViewEventDescriptionScrollFrame.ScrollBar}
	self:keepFontStrings(_G.CalendarViewEventInviteListSection)
	self:skinSlider{obj=_G.CalendarViewEventInviteListScrollFrameScrollBar}
	self:addSkinFrame{obj=_G.CalendarViewEventInviteList, ft=ftype}
	self:addSkinFrame{obj=_G.CalendarViewEventFrame, ft=ftype, kfs=true, x1=2, y1=-3, x2=-3, y2=2}

-->>-- Create Event Frame
	_G.CalendarCreateEventIcon:SetAlpha(1) -- show event icon
	self:keepFontStrings(_G.CalendarCreateEventTitleFrame)
	self:moveObject{obj=_G.CalendarCreateEventTitleFrame, y=-6}
	self:removeRegions(_G.CalendarCreateEventCloseButton, {5})
	self:skinEditBox{obj=_G.CalendarCreateEventTitleEdit, regs={6}}
	self:skinDropDown{obj=_G.CalendarCreateEventTypeDropDown}
	self:skinDropDown{obj=_G.CalendarCreateEventHourDropDown, x2=-5}
	self:skinDropDown{obj=_G.CalendarCreateEventMinuteDropDown, x2=-5}
	self:skinDropDown{obj=_G.CalendarCreateEventAMPMDropDown, x2=-5}
	self:skinDropDown{obj=_G.CalendarCreateEventDifficultyOptionDropDown, x2=-5}
	self:addSkinFrame{obj=_G.CalendarCreateEventDescriptionContainer, ft=ftype}
	self:skinSlider{obj=_G.CalendarCreateEventDescriptionScrollFrame.ScrollBar}
	self:keepFontStrings(_G.CalendarCreateEventInviteListSection)
	self:skinSlider{obj=_G.CalendarCreateEventInviteListScrollFrameScrollBar}
	self:addSkinFrame{obj=_G.CalendarCreateEventInviteList, ft=ftype}
	self:skinEditBox{obj=_G.CalendarCreateEventInviteEdit, regs={6}}
	_G.CalendarCreateEventMassInviteButtonBorder:SetAlpha(0)
	_G.CalendarCreateEventRaidInviteButtonBorder:SetAlpha(0)
	_G.CalendarCreateEventCreateButtonBorder:SetAlpha(0)
	self:addSkinFrame{obj=_G.CalendarCreateEventFrame, ft=ftype, kfs=true, x1=2, y1=-3, x2=-3, y2=2}

-->>-- Mass Invite Frame
	self:keepFontStrings(_G.CalendarMassInviteTitleFrame)
	self:moveObject{obj=_G.CalendarMassInviteTitleFrame, y=-6}
	self:removeRegions(_G.CalendarMassInviteCloseButton, {5})
	self:skinEditBox{obj=_G.CalendarMassInviteGuildMinLevelEdit, regs={6}}
	self:skinEditBox{obj=_G.CalendarMassInviteGuildMaxLevelEdit, regs={6}}
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
	local btn
	for i = 1, _G.MAX_CLASSES do -- allow for the total button
		btn = _G["CalendarClassButton" .. i]
		self:removeRegions(btn, {1})
		self:addButtonBorder{obj=btn}
	end
	btn = nil
	-- Class Totals button, texture & size changes
	self:moveObject{obj=_G.CalendarClassTotalsButton, x=-2}
	-- _G.CalendarClassTotalsButton:SetWidth(25)
	-- _G.CalendarClassTotalsButton:SetHeight(25)
	_G.CalendarClassTotalsButton:SetSize(25, 25)
	self:applySkin{obj=_G.CalendarClassTotalsButton, ft=ftype, kfs=true, bba=self.modBtnBs and 1 or 0}

-->>-- ContextMenus
	self:addSkinFrame{obj=_G.CalendarContextMenu}
	self:addSkinFrame{obj=_G.CalendarInviteStatusContextMenu}

end

aObj.blizzLoDFrames[ftype].ChallengesUI = function(self)
	if not self.db.profile.ChallengesUI or self.initialized.ChallengesUI then return end
	self.initialized.ChallengesUI = true

	self:removeInset(_G.ChallengesFrameInset)

	_G.ChallengesFrame.WeeklyBest.Child.Star:SetTexture(nil)
	_G.ChallengesFrame.WeeklyBest.Child.Glow:SetTexture(nil)
	_G.ChallengesFrame.WeeklyBest.Child:DisableDrawLayer("BACKGROUND") -- Rune textures
	_G.ChallengesFrame.WeeklyBest.Child:DisableDrawLayer("OVERLAY") -- glow texture

	_G.ChallengesFrame.GuildBest:DisableDrawLayer("BACKGROUND")

	_G.ChallengesFrame:DisableDrawLayer("BACKGROUND")

	-- ChallengesKeystoneFrame
	_G.ChallengesKeystoneFrame:DisableDrawLayer("BACKGROUND")
	_G.ChallengesKeystoneFrame.RuneBG:SetTexture(nil)
	_G.ChallengesKeystoneFrame.InstructionBackground:SetTexture(nil)
	_G.ChallengesKeystoneFrame.Divider:SetTexture(nil)
	_G.ChallengesKeystoneFrame.DungeonName:SetTextColor(self.BTr, self.BTg, self.BTb)
	_G.ChallengesKeystoneFrame.PowerLevel:SetTextColor(self.BTr, self.BTr, self.BTg)
	_G.ChallengesKeystoneFrame.RunesLarge:SetTexture(nil)
	_G.ChallengesKeystoneFrame.RunesSmall:SetTexture(nil)
	_G.ChallengesKeystoneFrame.SlotBG:SetTexture(nil)
	_G.ChallengesKeystoneFrame.KeystoneFrame:SetTexture(nil)
	self:addButtonBorder{obj=_G.ChallengesKeystoneFrame.KeystoneSlot}
	self:addSkinFrame{obj=_G.ChallengesKeystoneFrame, ft=ftype, ofs=-7}

end

aObj.blizzFrames[ftype].ChatBubbles = function(self)
	if not self.db.profile.ChatBubbles or self.initialized.ChatBubbles then return end
	self.initialized.ChatBubbles = true

	local cbeTmr
	local function skinChatBubbles()

		aObj.RegisterCallback("skinChatBubbles", "WorldFrame_GetChildren", function(this, child)
			if aObj:hasTextInTexture(aObj:getRegion(child, 1), "ChatBubble-Background", true) then
				aObj:applySkin{obj=child, ft=ftype, kfs=true} -- use apply skin otherwise text is behind
			end
		end)
		aObj:scanWorldFrameChildren()

		if cbeTmr then
			cbeTmr:Cancel()
		end
		cbeTmr = nil

	end
	-- skin any existing ones
	skinChatBubbles()

	local function srt4Event(event, ...)

		if not cbeTmr then
			cbcTmr = _G.C_Timer.NewTicker(0.25, function() skinChatBubbles() end)
		end

	end
	-- capture events which may create new ones
	-- CHAT_MSG(_MONSTER)_EMOTE
	-- CHAT_MSG_RAID_BOSS_EMOTE
	self:RegisterEvent("CHAT_MSG_SAY", srt4Event)
	self:RegisterEvent("CHAT_MSG_MONSTER_SAY",srt4Event)
	-- CHAT_MSG(_MONSTER)_WHISPER
	self:RegisterEvent("CHAT_MSG_YELL", srt4Event)
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL", srt4Event)

	-- CHAT_MSG_PARTY
	-- CHAT_MSG_PARTY_LEADER
	-- CHAT_MSG_RAID
	-- CHAT_MSG_RAID_LEADER
	-- CHAT_MSG_RAID_WARNING

	-- capture these as well
	self:RegisterEvent("CINEMATIC_START", function()
		srt4Event()
	end)
	self:RegisterEvent("CINEMATIC_STOP", function()
		if cbeTmr then
			cbeTmr:Cancel()
		end
		cbcTmr = nil
	end)

end

aObj.blizzFrames[ftype].ChatButtons = function(self)
	if not self.db.profile.ChatButtons or self.initialized.ChatButtons then return end
	self.initialized.ChatButtons = true

	-- QuickJoinToastButton & frames (attached to ChatFrame)
	local qjtb = _G.QuickJoinToastButton
	if self.modBtnBs then
		local obj
		for i = 1, _G.NUM_CHAT_WINDOWS do
			obj = _G["ChatFrame" .. i].buttonFrame
			self:addButtonBorder{obj=obj.minimizeButton, ofs=-2}
			self:addButtonBorder{obj=obj.downButton, ofs=-2}
			self:addButtonBorder{obj=obj.upButton, ofs=-2}
			self:addButtonBorder{obj=obj.bottomButton, ofs=-2, reParent={self:getRegion(obj.bottomButton, 1)}}
		end
		obj = nil
		self:addButtonBorder{obj=_G.ChatFrameMenuButton, ofs=-2}
		self:addButtonBorder{obj=qjtb, x1=1, y1=1, x2=-2, y2=-1}
	end
	local nTab, frame = {"Toast", "Toast2"}
	for i = 1, #nTab do
		frame = nTab[i]
		qjtb[frame]:DisableDrawLayer("BACKGROUND")
		self:addSkinFrame{obj=qjtb[frame], ft=ftype}
		self:moveObject{obj=qjtb[frame], x=7}
		qjtb[frame]:Hide()
	end
	nTab, frame = nil, nil

	-- hook the animations to show or hide the QuickJoinToastButton frame(s)
	qjtb.FriendToToastAnim:SetScript("OnPlay", function()
		_G.QuickJoinToastButton.Toast.sf:Show()
		_G.QuickJoinToastButton.Toast2.sf:Hide()

	end)
	qjtb.ToastToToastAnim:SetScript("OnPlay", function()
		_G.QuickJoinToastButton.Toast.sf:Hide()
		_G.QuickJoinToastButton.Toast2.sf:Show()
	end)
	qjtb.ToastToFriendAnim:SetScript("OnPlay", function()
		_G.QuickJoinToastButton.Toast.sf:Hide()
		_G.QuickJoinToastButton.Toast2.sf:Hide()
	end)
	qjtb = nil

end

aObj.blizzFrames[ftype].ChatConfig = function(self)
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
			_G.ChatConfigChannelSettingsLeft.checkBoxTable[i]:SetBackdrop(nil)
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
	self:skinSlider{obj=_G.ChatConfigCombatSettingsFiltersScrollFrameScrollBar}
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

	-- Settings
	self:skinEditBox{obj=_G.CombatConfigSettingsNameEditBox , regs={6}} -- 6 is text

	-- Tabs
	local tab
	for i = 1, #_G.COMBAT_CONFIG_TABS do
		tab = _G["CombatConfigTab" .. i]
		self:keepRegions(tab, {4, 5}) -- N.B. region 4 is the Text, 5 is the highlight
		self:addSkinFrame{obj=tab, ft=ftype, y1=-8, y2=-4}
	end
	tab = nil

end

aObj.blizzFrames[ftype].ChatEditBox = function(self)
	if IsAddOnLoaded("NeonChat")
	or IsAddOnLoaded("Chatter")
	or IsAddOnLoaded("Prat-3.0")
	then
		aObj.blizzFrames[ftype].ChatEditBox = nil
		return
	end

	if not self.db.profile.ChatEditBox.skin or self.initialized.ChatEditBox then return end
	self.initialized.ChatEditBox = true

	for i = 1, _G.NUM_CHAT_WINDOWS do
		skinChatEB(_G["ChatFrame" .. i].editBox)
	end
	-- if editBox has a skin frame then hook these to manage its Alpha setting
	if self.db.profile.ChatEditBox.style ~= 2 then
		local function setAlpha(eBox)
			if eBox and eBox.sf then eBox.sf:SetAlpha(eBox:GetAlpha()) end
		end
		self:secureHook("ChatEdit_ActivateChat", function(editBox)
			setAlpha(editBox)
		end)
		self:secureHook("ChatEdit_DeactivateChat", function(editBox)
			setAlpha(editBox)
		end)
	end

end

aObj.blizzFrames[ftype].ChatFrames = function(self)
	if not self.db.profile.ChatFrames or self.initialized.ChatFrames then return end
	self.initialized.ChatFrames = true

	local clqbf = "CombatLogQuickButtonFrame"
	local clqbf_c = clqbf .. "_Custom"
	local yOfs1 = 6
	local obj
	for i = 1, _G.NUM_CHAT_WINDOWS do
		obj = _G["ChatFrame" .. i]
		if obj == _G.COMBATLOG
		and _G[clqbf_c]:IsShown()
		then
			yOfs1 = 31
		else
			yOfs1 = 6
		end
		self:addSkinFrame{obj=obj, ft=ftype, ofs=6, y1=yOfs1, y2=-8}
	end
	yOfs1, obj = nil, nil
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
	clqbf, clqbf_c = nil, nil

end

aObj.blizzFrames[ftype].ChatMenus = function(self)
	if not self.db.profile.ChatMenus or self.initialized.ChatMenus then return end
	self.initialized.ChatMenus = true

	self:addSkinFrame{obj=_G.ChatMenu, ft=ftype}
	self:addSkinFrame{obj=_G.EmoteMenu, ft=ftype}
	self:addSkinFrame{obj=_G.LanguageMenu, ft=ftype}
	self:addSkinFrame{obj=_G.VoiceMacroMenu, ft=ftype}
	self:addSkinFrame{obj=_G.GeneralDockManagerOverflowButtonList, ft=ftype}

end

aObj.blizzFrames[ftype].ChatMinimizedFrames = function(self)
	if not self.db.profile.ChatFrames then return end

	-- minimized chat frames
	self:SecureHook("FCF_CreateMinimizedFrame", function(chatFrame)
		local obj = _G[chatFrame:GetName() .. "Minimized"]
		self:rmRegionsTex(obj, {1, 2, 3})
		self:addSkinFrame{obj=obj, ft=ftype, x1=1, y1=-2, x2=-1, y2=2}
		self:addButtonBorder{obj=_G[chatFrame:GetName() .. "MinimizedMaximizeButton"], ofs=-1}
		obj = nil
	end)

end

aObj.blizzFrames[ftype].ChatTabs = function(self)
	if not self.db.profile.ChatTabs or self.initialized.ChatTabs then return end
	self.initialized.ChatTabs = true

	local tab
	for i = 1, _G.NUM_CHAT_WINDOWS do
		tab = _G["ChatFrame" .. i .. "Tab"]
		skinChatTab(tab)
	end
	tab = nil
	if self.db.profile.ChatTabsFade then
		-- hook this to hide/show the skin frame
		aObj:SecureHook("FCFTab_UpdateColors", function(this, selected)
			if this.sf then this.sf:SetShown(selected) end
		end)
	end

end

aObj.blizzFrames[ftype].ChatTemporaryWindow = function(self)
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
	for i = 1, #_G.CHAT_FRAMES do
		if _G[_G.CHAT_FRAMES[i]].isTemporary then skinTempWindow(_G[_G.CHAT_FRAMES[i]]) end
	end

end

aObj.blizzFrames[ftype].CinematicFrame = function(self)
	if not self.db.profile.CinematicFrame or self.initialized.CinematicFrame then return end
	self.initialized.CinematicFrame = true

	self:addSkinFrame{obj=_G.CinematicFrame.closeDialog, ft=ftype}

end

aObj.blizzLoDFrames[ftype].ClassTrial = function(self)
	if not self.db.profile.ClassTrial or self.initialized.ClassTrial then return end
	self.initialized.ClassTrial = true

	-- N.B. ClassTrialSecureFrame can't be skinned, as the XML has a ScopedModifier element saying forbidden="true"

	_G.ClassTrialThanksForPlayingDialog.ThanksText:SetTextColor(self.HTr, self.HTg, self.HTb)
	_G.ClassTrialThanksForPlayingDialog.ClassNameText:SetTextColor(self.HTr, self.HTg, self.HTb)
	_G.ClassTrialThanksForPlayingDialog.DialogFrame:SetTexture(nil)
	self:addSkinFrame{obj=_G.ClassTrialThanksForPlayingDialog, ft=ftype, x1=668, y1=-403, x2=-668, y2=402}

	-- create a Hourglass texture as per original Artwork
	_G.ClassTrialTimerDisplay.Hourglass = _G.ClassTrialTimerDisplay:CreateTexture(nil, "ARTWORK", nil)
	_G.ClassTrialTimerDisplay.Hourglass:SetTexture([[Interface\Common\mini-hourglass]])
	_G.ClassTrialTimerDisplay.Hourglass:SetPoint("LEFT", 20, 0)
	_G.ClassTrialTimerDisplay.Hourglass:SetSize(30, 30)
	_G.ClassTrialTimerDisplay:DisableDrawLayer("BACKGROUND")
	self:addSkinFrame{obj=_G.ClassTrialTimerDisplay, ft=ftype}

end

aObj.blizzFrames[ftype].CoinPickup = function(self)
	if not self.db.profile.CoinPickup or self.initialized.CoinPickup then return end
	self.initialized.CoinPickup = true

	self:addSkinFrame{obj=_G.CoinPickupFrame, ft=ftype, kfs=true, x1=9, y1=-12, x2=-6, y2=12}

end

aObj.blizzFrames[ftype].ColorPicker = function(self)
	if not self.db.profile.Colours or self.initialized.Colours then return end
	self.initialized.Colours = true

	_G.ColorPickerFrame:SetBackdrop(nil)
	_G.ColorPickerFrameHeader:SetAlpha(0)
	self:skinSlider{obj=_G.OpacitySliderFrame, size=4}
	self:addSkinFrame{obj=_G.ColorPickerFrame, ft=ftype, y1=6}

-->>-- Opacity Frame, used by BattlefieldMinimap amongst others
	_G.OpacityFrame:SetBackdrop(nil)
	self:skinSlider{obj=_G.OpacityFrameSlider}
	self:addSkinFrame{obj=_G.OpacityFrame, ft=ftype}

end

if aObj.isPTR then
	aObj.blizzLoDFrames[ftype].Console = function(self)
	if not self.db.profile.Console or self.initialized.Console then return end
	self.initialized.Console = true

	-- disable skinning of this frame
	self.db.profile.Console = false

	-->> N.B. Currently can't be skinned, as the TOC has an element saying Secure: 1

	end
end

aObj.blizzLoDFrames[ftype].Contribution = function(self)
	if not self.db.profile.Contribution or self.initialized.Contribution then return end
	self.initialized.Contribution = true

	-- skin Contributions
	for contribution in _G.ContributionCollectionFrame.contributionPool:EnumerateActive() do
		contribution.Header:DisableDrawLayer("BORDER")
		contribution.Header.Text:SetTextColor(self.HTr, self.HTg, self.HTb)
		contribution.State.Border:SetAlpha(0) -- texture is changed
		contribution.State.TextBG:SetTexture(nil)
		self:glazeStatusBar(contribution.Status, 0, nil)
		contribution.Status.Border:SetTexture(nil)
		contribution.Status.BG:SetTexture(nil)
		contribution.Description:SetTextColor(self.BTr, self.BTg, self.BTb)
	end
	for reward in _G.ContributionCollectionFrame.rewardPool:EnumerateActive() do
		reward.RewardName:SetTextColor(self.BTr, self.BTg, self.BTb)
	end

	_G.ContributionCollectionFrame.CloseButton.CloseButtonBackground:SetTexture(nil)
	self:addSkinFrame{obj=_G.ContributionCollectionFrame, ft=ftype, kfs=true, ofs=-21, x2=-18}

	-- Tooltips
	if self.db.profile.Tooltips.skin then
		self:add2Table(self.ttList, "ContributionTooltip")
		self:add2Table(self.ttList, "ContributionBuffTooltip")
	end

end

aObj.blizzLoDFrames[ftype].DeathRecap = function(self)
	if not self.db.profile.DeathRecap or self.initialized.DeathRecap then return end
	self.initialized.DeathRecap = true

	_G.DeathRecapFrame:DisableDrawLayer("BORDER")
	_G.DeathRecapFrame.Background:SetTexture(nil)
	-- manage buttons here, as names have changed from normal
	self:skinButton{obj=_G.DeathRecapFrame.CloseButton}
	self:skinButton{obj=_G.DeathRecapFrame.CloseXButton, cb=true}
	self:addSkinFrame{obj=_G.DeathRecapFrame, ft=ftype, kfs=true, nb=true, ofs=-1, y1=-2}
	_G.RaiseFrameLevelByTwo(_G.DeathRecapFrame)

end

aObj.blizzLoDFrames[ftype].DebugTools = function(self)
	if not self.db.profile.DebugTools or self.initialized.DebugTools then return end
	self.initialized.DebugTools = true

	self:skinSlider{obj=_G.EventTraceFrameScroll}
	self:addSkinFrame{obj=_G.EventTraceFrame, ft=ftype, kfs=true, x1=1, y1=-2, x2=-1, y2=4}

	if self.isPTR then
		-- skin TableAttributeDisplay frame
		local function skinTAD(frame)
			-- skin control buttons ?
			self:skinEditBox{obj=frame.FilterBox, regs={6, 7}, mi=true} -- 6 is text, 7 is icon
			self:skinSlider{obj=frame.LinesScrollFrame.ScrollBar}
			self:addSkinFrame{obj=frame.ScrollFrameArt, ft=ftype}
			self:addSkinFrame{obj=frame, ft=ftype, kfs=true, ofs=-2, x1=3, x2=-1}
		end
		skinTAD(_G.TableAttributeDisplay)
		-- hook this to skin subsequent frames
		self:RawHook("DisplayTableInspectorWindow", function(focusedTable, customTitle, tableFocusedCallback)
			local frame = self.hooks.DisplayTableInspectorWindow(focusedTable, customTitle, tableFocusedCallback)
			-- aObj:Debug("DisplayTableInspectorWindow: [%s, %s, %s, %s]", focusedTable, customTitle, tableFocusedCallback, frame)
			skinTAD(frame)
			return frame
		end, true)
	end

	if self.db.profile.Tooltips.skin then
		self:add2Table(self.ttList, "FrameStackTooltip")
		self:add2Table(self.ttList, "EventTraceTooltip")
	end

end

aObj.blizzFrames[ftype].DestinyFrame = function(self)
	if not self.db.profile.DestinyFrame or self.initialized.DestinyFrame then return end
	self.initialized.DestinyFrame = true

	-- buttons
	local nTab, btn = {"alliance", "horde"}
	for i = 1, #nTab do
		btn = _G.DestinyFrame[nTab[i] .. "Button"]
		self:removeRegions(btn, {1})
		self:changeRecTex(btn:GetHighlightTexture())
		self:adjWidth{obj=btn, adj=-60}
		self:adjHeight{obj=btn, adj=-60}
		self:skinButton{obj=btn, x1=-2, y1=2, x2=-3, y2=-1}
	end
	nTab, btn = nil, nil

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

aObj.blizzLoDFrames[ftype].GarrisonUI = function(self)
	if not self.db.profile.GarrisonUI or self.initialized.GarrisonUI then return end
	self.initialized.GarrisonUI = true

	-->>-- GarrisonBuildingUI
	local function skinGarrisonBuildingUI()

		-- Building Frame
		_G.GarrisonBuildingFrame.MainHelpButton.Ring:SetTexture(nil)
		aObj:moveObject{obj=_G.GarrisonBuildingFrame.MainHelpButton, y=-4}
		_G.GarrisonBuildingFrame.GarrCorners:DisableDrawLayer("BACKGROUND")
		aObj:addSkinFrame{obj=_G.GarrisonBuildingFrame, ft=ftype, kfs=true, ofs=2}

		-- BuildingList
		local bl = _G.GarrisonBuildingFrame.BuildingList
		bl:DisableDrawLayer("BORDER")

		-- tabs
		local tab
		for i = 1, _G.GARRISON_NUM_BUILDING_SIZES do
			tab = bl["Tab" .. i]
			tab:GetNormalTexture():SetAlpha(0) -- texture is changed in code
			aObj:addSkinFrame{obj=tab, ft=ftype, noBdr=aObj.isTT, x1=3, y1=0, x2=-3, y2=2}
			tab.sf.ignore = true -- don't change tab size
			if i == 1 then
				aObj:toggleTabDisplay(tab, true)
			else
				aObj:toggleTabDisplay(tab, false)
			end
		end
		tab = nil

		local btn
		for i = 1, #bl.Buttons do
			btn = bl.Buttons[i]
			btn.BG:SetTexture(nil)
			aObj:addButtonBorder{obj=btn, relTo=btn.Icon}
		end
		btn = nil

		aObj:SecureHook("GarrisonBuildingList_SelectTab", function(tab)
			local gbl = tab:GetParent()
			-- handle tab textures
			for i = 1, _G.GARRISON_NUM_BUILDING_SIZES do
				if i == tab:GetID() then
					aObj:toggleTabDisplay(tab, true)
				else
					aObj:toggleTabDisplay(gbl["Tab" .. i], false)
				end
			end
			-- handle buttons
			local btn
			for i = 1, #gbl.Buttons do
				btn = gbl.Buttons[i]
				btn.BG:SetTexture(nil)
				aObj:addButtonBorder{obj=btn, relTo=btn.Icon}
			end
			gbl, btn = nil, nil
		end)
		bl.MaterialFrame:DisableDrawLayer("BACKGROUND")
		bl = nil
		-- BuildingLevelTooltip
		aObj:addSkinFrame{obj=_G.GarrisonBuildingFrame.BuildingLevelTooltip, ft=ftype}

		-- FollowerList
		local fl = _G.GarrisonBuildingFrame.FollowerList
		fl:DisableDrawLayer("BACKGROUND")
		fl:DisableDrawLayer("BORDER")
		skinFollowerList(fl)
		fl = nil

		-- InfoBox
		local ib = _G.GarrisonBuildingFrame.InfoBox
		ib:DisableDrawLayer("BORDER")
		-- N.B. The RankBadge changes with level and has level number within the texture, therefore MUST not be hidden
		-- ib.RankBadge:SetAlpha(0)
		ib.AddFollowerButton.EmptyPortrait:SetTexture(nil)
		skinPortrait(ib.FollowerPortrait)
		ib = nil
		-- FollowerPortrait RingQuality changes colour so track this change
		aObj:SecureHook("GarrisonBuildingInfoBox_ShowFollowerPortrait", function(...)
			local obj = _G.GarrisonBuildingFrame.InfoBox.FollowerPortrait
			-- make sure ring quality is updated to level border colour
			obj.PortraitRingQuality:SetVertexColor(obj.PortraitRing:GetVertexColor())
			obj = nil
		end)

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
		self:removeMagicBtnTex(cdf.StartWorkOrderButton)
		self:removeMagicBtnTex(cdf.CreateAllWorkOrdersButton)
		aObj:addSkinFrame{obj=cdf, ft=ftype, kfs=true, ri=true, ofs=2}
		cdf.CapacitiveDisplay.IconBG:SetTexture(nil)
		aObj:addButtonBorder{obj=cdf.CapacitiveDisplay.ShipmentIconFrame, relTo=cdf.CapacitiveDisplay.ShipmentIconFrame.Icon, hide=true}
		skinPortrait(cdf.CapacitiveDisplay.ShipmentIconFrame.Follower)
		aObj:skinEditBox{obj=cdf.Count, regs={6}, noHeight=true}
		aObj:moveObject{obj=cdf.Count, x=-6}
		aObj:addButtonBorder{obj=cdf.DecrementButton, ofs=-2, es=10}
		aObj:addButtonBorder{obj=cdf.IncrementButton, ofs=-2, es=10}
		cdf = nil
		-- hook this to skin reagents
		aObj:SecureHook("GarrisonCapacitiveDisplayFrame_Update", function(this, success, ...)
			if success ~= 0 then
				local btn
				for i = 1, #this.CapacitiveDisplay.Reagents do
					btn = this.CapacitiveDisplay.Reagents[i]
					aObj:addButtonBorder{obj=btn, relTo=btn.Icon, reParent={btn.Count}}
					btn.NameFrame:SetTexture(nil)
				end
				btn = nil
			end
		end)

	end

	-->>-- GarrisonLandingPage
	local function skinGarrisonLandingPage()

		_G.GarrisonLandingPage:DisableDrawLayer("BACKGROUND")
		_G.GarrisonLandingPage.HeaderBar:SetTexture(nil)
		_G.GarrisonLandingPage.numTabs = 3
		aObj:skinTabs{obj=_G.GarrisonLandingPage, regs={9, 10}, ignore=true, lod=true, bg=true, x1=4, y1=0, x2=-4, y2=-3}
		aObj:addSkinFrame{obj=_G.GarrisonLandingPage, ft=ftype, ofs=-6, y1=-13, x2=-13}

		-- ReportTab
		local rp = _G.GarrisonLandingPage.Report
		rp.List:DisableDrawLayer("BACKGROUND")
		aObj:skinSlider{obj=rp.List.listScroll.scrollBar, wdth=-4}
		local btn, rwd
		for i = 1, #rp.List.listScroll.buttons do
			btn = rp.List.listScroll.buttons[i]
			btn:DisableDrawLayer("BACKGROUND")
			btn:DisableDrawLayer("BORDER")
			for i = 1, #btn.Rewards do
				rwd = btn.Rewards[i]
				rwd:DisableDrawLayer("BACKGROUND")
				aObj:addButtonBorder{obj=rwd, relTo=rwd.Icon, reParent={rwd.Quantity}}
			end
		end
		btn, rwd = nil, nil
		-- tabs at top
		local nTab, btn = {"InProgress", "Available"}
		for i = 1, #nTab do
			btn = nTab[i]
			rp[btn]:GetNormalTexture():SetAlpha(0)
			aObj:addSkinFrame{obj=rp[btn], ft=ftype, noBdr=aObj.isTT, x1=4, y1=-2, x2=-4, y2=-4}
			rp[btn].sf.ignore = true
			if rp[btn] == rp.selectedTab then
				if aObj.isTT then aObj:setActiveTab(rp[btn].sf) end
			else
				if aObj.isTT then aObj:setInactiveTab(rp[btn].sf) end
			end
		end
		nTab, btn = nil, nil
		if aObj.isTT then
			self:SecureHook("GarrisonLandingPageReport_SetTab", function(this)
				aObj:setActiveTab(_G.GarrisonLandingPage.Report.selectedTab.sf)
				aObj:setInactiveTab(_G.GarrisonLandingPage.Report.unselectedTab.sf)
			end)
		end
		rp = nil

		-- FollowerList
		local fl = _G.GarrisonLandingPage.FollowerList
		-- if FollowerList not yet populated, hook the function
		if not fl.listScroll.buttons then
			aObj:SecureHook(fl, "Initialize", function(this, ...)
				skinFollowerList(this)
				aObj:Unhook(fl, "Initialize")
			end)
		else
			skinFollowerList(fl)
		end
		aObj:SecureHook(fl, "ShowFollower", function(this, id)
			skinFollowerAbilitiesAndCounters(this, id)
		end)

		-- FollowerTab
		skinFollowerPage(_G.GarrisonLandingPage.FollowerTab)

		-- FleetTab
		-- ShipFollowerList
		fl = _G.GarrisonLandingPage.ShipFollowerList
		-- if FollowerList not yet populated, hook the function
		if not fl.listScroll.buttons then
			aObj:SecureHook(fl, "Initialize", function(this, ...)
				skinFollowerList(this)
				aObj:Unhook(fl, "Initialize")
			end)
		else
			skinFollowerList(fl)
		end
		fl = nil

		-- ShipFollowerTab
		skinFollowerTraitsAndEquipment(_G.GarrisonLandingPage.ShipFollowerTab)

		-- minimap
		aObj:skinButton{obj=_G.GarrisonLandingPageTutorialBox.CloseButton, cb=true}

		local obj = _G.GarrisonLandingPageMinimapButton
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
		obj = nil

	end

	-->>-- GarrisonMissionUI
	local function skinGarrisonMissionUI()

		-- Mission Frame
		self:skinButton{obj=_G.GarrisonMissionFrame.CloseButton, cb=true}
		_G.GarrisonMissionFrame.GarrCorners:DisableDrawLayer("BACKGROUND")
		-- don't skin buttons, otherwise Tab buttons get skinned  as well
		aObj:addSkinFrame{obj=_G.GarrisonMissionFrame, ft=ftype, kfs=true, nb=true, x1=2, y1=3, x2=1, y2=-4}
		-- tabs
		aObj:skinTabs{obj=_G.GarrisonMissionFrame, regs={9, 10}, ignore=true, lod=true, x1=9, y1=2, x2=-9, y2=0}

		-- FollowerList
		local fl = _G.GarrisonMissionFrame.FollowerList
		fl:DisableDrawLayer("BORDER")
		fl.MaterialFrame:DisableDrawLayer("BACKGROUND")
		-- if FollowerList not yet populated, hook the function
		if not fl.listScroll.buttons then
			aObj:SecureHook(fl, "Initialize", function(this, ...)
				skinFollowerList(this)
				aObj:Unhook(fl, "Initialize")
			end)
		else
			skinFollowerList(fl)
		end
		aObj:SecureHook(fl, "ShowFollower", function(this, id)
			skinFollowerAbilitiesAndCounters(this, id)
		end)
		fl = nil

	-->>-- MissionTab
		-- Mission List
		skinMissionList(_G.GarrisonMissionFrame.MissionTab.MissionList)

		-- MissionPage
		local mp = _G.GarrisonMissionFrame.MissionTab.MissionPage
		skinMissionPage(mp)
		mp.CloseButton:SetSize(28, 28) -- make button smaller
		for i = 1, #mp.Followers do
			aObj:removeRegions(mp.Followers[i], {1})
			skinPortrait(mp.Followers[i].PortraitFrame)
		end
		for i = 1, #mp.Enemies do
			mp.Enemies[i].PortraitFrame.PortraitRing:SetTexture(nil)
		end
		aObj:moveObject{obj=mp.FollowerModel, x=-6, y=0}
		mp = nil

	-->>-- FollowerTab
		_G.GarrisonMissionFrame.FollowerTab:DisableDrawLayer("BORDER")
		skinFollowerPage(_G.GarrisonMissionFrame.FollowerTab)

		-- MissionComplete
		local mc = _G.GarrisonMissionFrame.MissionComplete
		skinMissionComplete(mc)
		for i = 1, #mc.Stage.EncountersFrame.Encounters do
			mc.Stage.EncountersFrame.Encounters[i].Ring:SetTexture(nil)
		end
        aObj:rmRegionsTex(mc.Stage.MissionInfo, {1, 2, 3, 4, 5, 11, 12, 13})
		mc = nil

        aObj:SecureHook("GarrisonMissionPage_SetReward", function(frame, reward)
            frame.BG:SetTexture(nil)
			-- N.B. reward buttons have an IconBorder
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
		_G.GarrisonRecruitSelectFrame.GarrCorners:DisableDrawLayer("BACKGROUND")
		aObj:addSkinFrame{obj=_G.GarrisonRecruiterFrame, ft=ftype, kfs=true, ri=true, ofs=1, y1=2}

		-- GarrisonRecruitSelect Frame
		-- FollowerList
		local fl = _G.GarrisonRecruitSelectFrame.FollowerList
		fl:DisableDrawLayer("BORDER")
		skinFollowerList(fl)
		fl = nil

		-- Follower Selection
		local fs = _G.GarrisonRecruitSelectFrame.FollowerSelection
		fs:DisableDrawLayer("BORDER")
		fs.Line1:SetTexture(nil)
		fs.Line2:SetTexture(nil)
		local btn
		for i = 1, 3 do
			btn = fs["Recruit" .. i].PortraitFrame
			btn.PortraitRing:SetTexture(nil)
			btn.LevelBorder:SetTexture(nil)
			btn.PortraitRingQuality:SetVertexColor(btn.LevelBorder:GetVertexColor())
		end
		fs, btn = nil, nil
		aObj:addSkinFrame{obj=_G.GarrisonRecruitSelectFrame, ft=ftype, kfs=true, ofs=2}

	end

	-->>-- GarrisonShipyardUI
	local function skinGarrisonShipyardUI()

		-- wooden frame around dialog
		aObj:keepFontStrings(_G.GarrisonShipyardFrame.BorderFrame)
		aObj:moveObject{obj=_G.GarrisonShipyardFrame.BorderFrame.TitleText, y=3}
		_G.GarrisonShipyardFrame.BorderFrame.GarrCorners:DisableDrawLayer("BACKGROUND")

		-- Shipyard Frame
		aObj:addSkinFrame{obj=_G.GarrisonShipyardFrame, ft=ftype, kfs=true, x1=2, y1=3, x2=1, y2=-4}
		-- tabs
		aObj:skinTabs{obj=_G.GarrisonShipyardFrame, regs={9, 10}, ignore=true, lod=true, x1=9, y1=2, x2=-9, y2=0}

		-- List of ships (FollowerList)
		local fl = _G.GarrisonShipyardFrame.FollowerList
		fl:DisableDrawLayer("BORDER")
		fl.MaterialFrame:DisableDrawLayer("BACKGROUND")
		-- if FollowerList not yet populated, hook the function
		if not fl.listScroll.buttons then
			aObj:SecureHook(fl, "Initialize", function(this, ...)
				skinFollowerList(this)
				aObj:Unhook(fl, "Initialize")
			end)
		else
			skinFollowerList(fl)
		end
		fl = nil

	-->>-- Naval Map Tab (MissionTab)
		-- Mission List
		local ml = _G.GarrisonShipyardFrame.MissionTab.MissionList
        ml:SetScale(1.019) -- make larger to fit frame
		ml.MapTexture:SetDrawLayer("BORDER", -2) -- make sure it appears above skinFrame but below other textures
        ml.MapTexture:SetPoint("CENTER", ml, "CENTER", 1, -10)

		-- Fog overlays
		local function showCurrentMissions()
			local ml = _G.GarrisonShipyardFrame.MissionTab.MissionList
			local fffl = ml.FogFrames[1]:GetFrameLevel()
			for i = 1, #ml.missions do
				if ml.missions[i].inProgress then
					ml.missionFrames[i]:SetFrameLevel(fffl + 1)
				end
			end
			ml, fffl = nil, nil
		end
		-- make sure current missions are above the fog (Bugfix for Blizzard code)
		showCurrentMissions()
		-- hook this to ensure they are when map reshown/updated
		self:SecureHook("GarrisonShipyardMap_UpdateMissions", function()
			showCurrentMissions()
		end)

		-- CompleteDialog
		skinCompleteDialog(ml.CompleteDialog, true)
		ml = nil

		-- MissionPage
		local mp = _G.GarrisonShipyardFrame.MissionTab.MissionPage
		skinMissionPage(mp)
		for i = 1, #mp.Enemies do
			mp.Enemies[i].PortraitRing:SetTexture(nil)
		end
		local ctr
		for i = 1, #mp.Followers do
			-- Counters buttons
			for i = 1, #mp.Followers[i].Counters do
				ctr = mp.Followers[i].Counters[i]
				ctr.Border:SetTexture(nil)
				aObj:addButtonBorder{obj=ctr, relTo=ctr.Icon}
			end
		end
		mp, ctr = nil, nil

	-->>-- Fleet Tab (FollowerTab)
		-- FollowerTab
		local ft = _G.GarrisonShipyardFrame.FollowerTab
		ft:DisableDrawLayer("BORDER")
		skinFollowerTraitsAndEquipment(ft)
		ft = nil

		-- MissionComplete
		local mc = _G.GarrisonShipyardFrame.MissionComplete
		skinMissionComplete(mc, true)
		for i = 1, #mc.Stage.EncountersFrame.Encounters do
			mc.Stage.EncountersFrame.Encounters[i].PortraitRing:SetTexture(nil)
		end
        self:rmRegionsTex(mc.Stage.MissionInfo, {1, 2, 3, 4, 5, 8, 9, 10}) -- N.B. 6 & 7 are MissionType & Title
		mc = nil

	end

	-->>-- Tooltips
	local function skinGarrisonTooltips()

		aObj:addSkinFrame{obj=_G.GarrisonMissionMechanicTooltip, ft=ftype}
		aObj:addSkinFrame{obj=_G.GarrisonMissionMechanicFollowerCounterTooltip, ft=ftype}

		aObj:addSkinFrame{obj=_G.GarrisonBonusAreaTooltip, ft=ftype}
		aObj:addSkinFrame{obj=_G.GarrisonShipyardMapMissionTooltip, ft=ftype}

	end

	skinGarrisonBuildingUI()
	skinGarrisonMissionUI()
	skinGarrisonShipyardUI()
	skinGarrisonLandingPage()
	skinGarrisonCapacitiveDisplay()
	skinGarrisonMonumentUI()
	skinGarrisonRecruiterUI()
	skinGarrisonTooltips()

	-- N.B. Garrison Landing Page Minimap Button skinned with other minimap buttons

end

-- N.B. The following function has been separated from the GarrisonUI skin code as it is used by several Quest Frames
aObj.blizzFrames[ftype].GarrisonTooltips = function(self)
	if not self.db.profile.GarrisonUI then return end

	_G.GarrisonFollowerTooltip.PortraitFrame.PortraitRing:SetTexture(nil)
	_G.GarrisonFollowerTooltip.PortraitFrame.LevelBorder:SetAlpha(0)
	aObj:addSkinFrame{obj=_G.GarrisonFollowerTooltip, ft=ftype}

	_G.GarrisonFollowerAbilityTooltip.CounterIconBorder:SetTexture(nil)
	aObj:addSkinFrame{obj=_G.GarrisonFollowerAbilityTooltip, ft=ftype}

	self:addSkinFrame{obj=_G.GarrisonFollowerAbilityWithoutCountersTooltip, ft=ftype}
	self:addSkinFrame{obj=_G.GarrisonFollowerMissionAbilityWithoutCountersTooltip, ft=ftype}

	self:addSkinFrame{obj=_G.GarrisonShipyardFollowerTooltip, ft=ftype}

	_G.FloatingGarrisonFollowerTooltip.PortraitFrame.PortraitRing:SetTexture(nil)
	_G.FloatingGarrisonFollowerTooltip.PortraitFrame.LevelBorder:SetAlpha(0)
	aObj:addSkinFrame{obj=_G.FloatingGarrisonFollowerTooltip, ft=ftype}

	self:addSkinFrame{obj=_G.FloatingGarrisonShipyardFollowerTooltip, ft=ftype}

	_G.FloatingGarrisonFollowerAbilityTooltip.CounterIconBorder:SetTexture(nil)
	aObj:addSkinFrame{obj=_G.FloatingGarrisonFollowerAbilityTooltip, ft=ftype}

	aObj:addSkinFrame{obj=_G.FloatingGarrisonMissionTooltip, ft=ftype}

end

aObj.blizzLoDFrames[ftype].GMChatUI = function(self)
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
			kRegions = nil
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

aObj.blizzLoDFrames[ftype].GMSurveyUI = function(self)
	if not self.db.profile.GMSurveyUI or self.initialized.GMSurveyUI then return end
	self.initialized.GMSurveyUI = true

	self:keepFontStrings(_G.GMSurveyHeader)
	self:moveObject{obj=_G.GMSurveyHeaderText, y=-8}
	self:addSkinFrame{obj=_G.GMSurveyFrame, ft=ftype, kfs=true, y1=-6, x2=-45}
	self:skinSlider{obj=_G.GMSurveyScrollFrame.ScrollBar, rt="artwork"}

	local obj
	for i = 1, _G.MAX_SURVEY_QUESTIONS do
		obj = _G["GMSurveyQuestion" .. i]
		self:applySkin{obj=obj, ft=ftype} -- must use applySkin otherwise text is behind gradient
		obj.SetBackdropColor = _G.nop
		obj.SetBackdropBorderColor = _G.nop
	end
	obj = nil

	self:skinSlider{obj=_G.GMSurveyCommentScrollFrame.ScrollBar}
	self:applySkin{obj=_G.GMSurveyCommentFrame, ft=ftype} -- must use applySkin otherwise text is behind gradient

end

aObj.blizzLoDFrames[ftype].GuildBankUI = function(self)
	if not self.db.profile.GuildBankUI or self.initialized.GuildBankUI then return end
	self.initialized.GuildBankUI = true

	--	Main Frame
	_G.GuildBankEmblemFrame:Hide()
	for i = 1, _G.NUM_GUILDBANK_COLUMNS do
		_G["GuildBankColumn" .. i .. "Background"]:SetAlpha(0)
		for j = 1, 14 do
			self:addButtonBorder{obj=_G["GuildBankColumn" .. i .. "Button" .. j], ibt=true}
		end
	end
	self:skinEditBox{obj=_G.GuildItemSearchBox, regs={6, 7}, mi=true, noHeight=true, noMove=true} -- 6 is text, 7 is icon
	_G.GuildBankMoneyFrameBackground:DisableDrawLayer("BACKGROUND")
	self:addSkinFrame{obj=_G.GuildBankFrame, ft=ftype, kfs=true, hdr=true, x1=-3, y1=2, x2=1, y2=-5}
	self:skinTabs{obj=_G.GuildBankFrame, lod=true}

	--	Log Frame
	self:skinSlider{obj=_G.GuildBankTransactionsScrollFrame.ScrollBar, rt="artwork"}

	--	Info Frame
	self:skinSlider{obj=_G.GuildBankInfoScrollFrame.ScrollBar, rt="artwork"}

	--	GuildBank Popup Frame
	self:adjHeight{obj=_G.GuildBankPopupScrollFrame, adj=20} -- stretch to bottom of scroll area
	self:skinSlider{obj=_G.GuildBankPopupScrollFrame.ScrollBar, rt="background"}
	self:removeRegions(self:getChild(_G.GuildBankPopupFrame, 1), {1, 2, 3, 4, 5, 6, 7, 8})
	self:adjHeight{obj=_G.GuildBankPopupFrame, adj=20}
	self:skinEditBox{obj=_G.GuildBankPopupEditBox, regs={6}}
	self:addSkinFrame{obj=_G.GuildBankPopupFrame, ft=ftype, kfs=true, hdr=true, ofs=-6}
	self:SecureHookScript(_G.GuildBankPopupFrame, "OnShow", function(this)
		local btn
		for i = 1, _G.NUM_GUILDBANK_ICONS_SHOWN do
			btn = _G["GuildBankPopupButton" .. i]
			btn:DisableDrawLayer("BACKGROUND")
			self:addButtonBorder{obj=btn, relTo=_G["GuildBankPopupButton" .. i .. "Icon"], spbt=true}
		end
		btn = nil
		self:Unhook(_G.GuildBankPopupFrame, "OnShow")
	end)

	--	Tabs (side)
	local objName
	for i = 1, _G.MAX_GUILDBANK_TABS do
		objName = "GuildBankTab" .. i
		_G[objName]:DisableDrawLayer("BACKGROUND")
		self:addButtonBorder{obj=_G[objName .. "Button"], relTo=_G[objName .. "ButtonIconTexture"]}
	end
	objName = nil

	-- send message when UI is skinned (used by oGlow skin)
	self:SendMessage("GuildBankUI_Skinned", self)

end

aObj.blizzFrames[ftype].HelpFrame = function(self)
	if not self.db.profile.HelpFrame or self.initialized.HelpFrame then return end
	self.initialized.HelpFrame = true

	self:keepFontStrings(_G.HelpFrame.header)
	self:moveObject{obj=_G.HelpFrame.header, y=-12}
	self:removeInset(_G.HelpFrame.leftInset)
	self:removeInset(_G.HelpFrame.mainInset)
	self:addSkinFrame{obj=_G.HelpFrame, ft=ftype, kfs=true, ofs=-10, y2=7}
	-- widen buttons so text fits better
	for i = 1, 6 do
		_G.HelpFrame["button" .. i]:SetWidth(180)
	end
	_G.HelpFrame.button16:SetWidth(180) -- Submit Suggestion button

	-- Account Security panel
	_G.HelpFrame.asec.ticketButton:GetNormalTexture():SetTexture(nil)
	_G.HelpFrame.asec.ticketButton:GetPushedTexture():SetTexture(nil)

	-- Character Stuck! panel
	self:addButtonBorder{obj=_G.HelpFrameCharacterStuckHearthstone, es=20}

	-- Report Bug panel
	self:skinSlider{obj=_G.HelpFrameReportBugScrollFrame.ScrollBar}
	self:addSkinFrame{obj=self:getChild(_G.HelpFrame.bug, 3), ft=ftype}

	-- Submit Suggestion panel
	self:skinSlider{obj=_G.HelpFrameSubmitSuggestionScrollFrame.ScrollBar}
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
	self:skinSlider{obj=_G.HelpFrameGM_ResponseScrollFrame1.ScrollBar}
	self:skinSlider{obj=_G.HelpFrameGM_ResponseScrollFrame2.ScrollBar}
	self:addSkinFrame{obj=self:getChild(_G.HelpFrameGM_Response, 5), ft=ftype}
	self:addSkinFrame{obj=self:getChild(_G.HelpFrameGM_Response, 6), ft=ftype}

	-- BrowserSettings Tooltip
	_G.BrowserSettingsTooltip:DisableDrawLayer("BACKGROUND")
	self:addSkinFrame{obj=_G.BrowserSettingsTooltip, ft=ftype}

	-- TicketStatus Frame
	self:addSkinFrame{obj=_G.TicketStatusFrameButton}
	if not self.isPTR then
		-- ReportPlayerName Dialog
		self:addSkinFrame{obj=_G.ReportPlayerNameDialog.CommentFrame, ft=ftype, kfs=true, y2=-2}
		_G.ReportPlayerNameDialog.CommentFrame.EditBox.InformationText:SetTextColor(self.BTr, self.BTg, self.BTb)
		self:addSkinFrame{obj=_G.ReportPlayerNameDialog, ft=ftype}
	end

	-- ReportCheating Dialog
	self:addSkinFrame{obj=_G.ReportCheatingDialog.CommentFrame, ft=ftype, kfs=true, y2=-2}
	_G.ReportCheatingDialog.CommentFrame.EditBox.InformationText:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:addSkinFrame{obj=_G.ReportCheatingDialog, ft=ftype}

end

aObj.blizzFrames[ftype].ItemText = function(self)
	if not self.db.profile.ItemText or self.initialized.ItemText then return end
	self.initialized.ItemText = true

	self:SecureHookScript(_G.ItemTextFrame, "OnShow", function(this)
		_G.ItemTextPageText:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G.ItemTextPageText:SetTextColor("P", self.BTr, self.BTg, self.BTb)
		_G.ItemTextPageText:SetTextColor("H1", self.HTr, self.HTg, self.HTb)
		_G.ItemTextPageText:SetTextColor("H2", self.HTr, self.HTg, self.HTb)
		_G.ItemTextPageText:SetTextColor("H3", self.HTr, self.HTg, self.HTb)
	end)

	self:skinSlider{obj=_G.ItemTextScrollFrame.ScrollBar, wdth=-4}
	self:glazeStatusBar(_G.ItemTextStatusBar, 0)
	self:moveObject{obj=_G.ItemTextPrevPageButton, x=-55} -- move prev button left
	self:addButtonBorder{obj=_G.ItemTextPrevPageButton, ofs=-2, y1=-3, x2=-3}
	self:addButtonBorder{obj=_G.ItemTextNextPageButton, ofs=-2, y1=-3, x2=-3}
	self:addSkinFrame{obj=_G.ItemTextFrame, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-2}

end

aObj.blizzFrames[ftype].LevelUpDisplay = function(self)
	if not self.db.profile.LevelUpDisplay or self.initialized.LevelUpDisplay then return end
	self.initialized.LevelUpDisplay = true

	_G.LevelUpDisplay:DisableDrawLayer("BACKGROUND")
	-- sub frames
	_G.LevelUpDisplay.scenarioFrame:DisableDrawLayer("BORDER")
	_G.LevelUpDisplay.scenarioBits:DisableDrawLayer("BACKGROUND")
	_G.LevelUpDisplay.scenarioBits:DisableDrawLayer("BORDER")
	_G.LevelUpDisplay.scenarioFiligree:DisableDrawLayer("OVERLAY")
	_G.LevelUpDisplay.challengeModeBits:DisableDrawLayer("BORDER")
	_G.LevelUpDisplay.challengeModeBits.BottomFiligree:SetTexture(nil)
	-- SpellBucketFrame ?

	-- BossBanner, remove textures as Alpha values are changed
	self:rmRegionsTex(_G.BossBanner, {1, 2, 3, 4, 5, 6, 10, 11, 12, 13,}) -- 7 is skull, 8 is loot, 9 is flash
	-- skin Boss Loot Frame(s)
	local frame
	for i = 1, #_G.BossBanner.LootFrames do
		frame = _G.BossBanner.LootFrames[i]
		frame:DisableDrawLayer("BACKGROUND")
		self:addButtonBorder{obj=frame, relTo=frame.Icon, reParent={frame.Count}}
	end
	frame = nil

end

local rTab = {"Tank", "Healer", "DPS", "Leader"}
local function skinCheckBtns(frame)

	for i = 1, #rTab do
		aObj:skinCheckButton{obj=_G[frame .. "QueueFrameRoleButton" .. rTab[i]].checkButton}
	end

end
aObj.blizzFrames[ftype].LFDFrame = function(self)
	if not self.db.profile.LFDFrame or self.initialized.LFDFrame then return end
	self.initialized.LFDFrame = true

	-- LFD RoleCheck Popup
	self:addSkinFrame{obj=_G.LFDRoleCheckPopup, kfs=true, ft=ftype}

	-- LFD Parent Frame (now part of PVE Frame)
	self:keepFontStrings(_G.LFDParentFrame)
	self:removeInset(_G.LFDParentFrame.Inset)

	-- LFD Queue Frame
	skinCheckBtns("LFD")
	_G.LFDQueueFrameBackground:SetAlpha(0)
	self:skinDropDown{obj=_G.LFDQueueFrameTypeDropDown}
	self:skinSlider{obj=_G.LFDQueueFrameRandomScrollFrame.ScrollBar}
	if self.modBtnBs then
		self:SecureHook("LFDQueueFrameRandom_UpdateFrame", function()
			local btnName
			for i = 1, 5 do
				btnName = "LFDQueueFrameRandomScrollFrameChildFrameItem" .. i
				if _G[btnName] then
					_G[btnName .. "NameFrame"]:SetTexture(nil)
					self:addButtonBorder{obj=_G[btnName], libt=true}
				end
			end
			btnName = nil
		end)
	end
	self:skinButton{obj=_G.LFDQueueFrameRandomScrollFrameChildFrame.bonusRepFrame.ChooseButton, as=true}
	self:addButtonBorder{obj=_G.LFDQueueFrameRandomScrollFrameChildFrame.MoneyReward, libt=true}
	_G.LFDQueueFrameRandomScrollFrameChildFrame.MoneyReward.NameFrame:SetTexture(nil)
	self:removeMagicBtnTex(_G.LFDQueueFrameFindGroupButton)
	self:skinButton{obj=_G.LFDQueueFrameFindGroupButton}

	-- Specific List subFrame
	local btn
	for i = 1, _G.NUM_LFD_CHOICE_BUTTONS do
		btn = "LFDQueueFrameSpecificListButton" .. i .. "ExpandOrCollapseButton"
		self:skinButton{obj=_G[btn], mp2=true}
	end
	self:skinSlider{obj=_G.LFDQueueFrameSpecificListScrollFrame.ScrollBar, rt="background"}

end

aObj.blizzFrames[ftype].LFGFrame = function(self)
	if not self.db.profile.LFGFrame or self.initialized.LFGFrame then return end
	self.initialized.LFGFrame = true

	-- LFG DungeonReady Popup a.k.a. ReadyCheck
	self:addSkinFrame{obj=_G.LFGDungeonReadyStatus, kfs=true, ft=ftype, ofs=-5}
	self:addSkinFrame{obj=_G.LFGDungeonReadyDialog, kfs=true, ft=ftype, ofs=-5}
	_G.LFGDungeonReadyDialog.SetBackdrop = _G.nop
	_G.LFGDungeonReadyDialog.instanceInfo:DisableDrawLayer("BACKGROUND")
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

aObj.blizzFrames[ftype].LFRFrame = function(self)
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
	local btn
	for i = 1, _G.NUM_LFR_CHOICE_BUTTONS do
		btn = "LFRQueueFrameSpecificListButton" .. i .. "ExpandOrCollapseButton"
		self:skinButton{obj=_G[btn], mp2=true}
		self:moveObject{obj=_G[btn .. "Highlight"], x=-3} -- move highlight to the left
	end
	self:skinSlider{obj=_G.LFRQueueFrameSpecificListScrollFrame.ScrollBar}

	-- LFR Browse Frame
	self:removeInset(_G.LFRBrowseFrameRoleInset)
	self:skinDropDown{obj=_G.LFRBrowseFrameRaidDropDown}
	self:skinSlider{obj=_G.LFRBrowseFrameListScrollFrame.ScrollBar, rt="background"}
	self:keepFontStrings(_G.LFRBrowseFrame)

	-- Tabs (side)
	local tab
	for i = 1, 2 do
		tab = _G["LFRParentFrameSideTab" .. i]
		tab:DisableDrawLayer("BACKGROUND")
		self:addButtonBorder{obj=tab}
	end
	tab = nil

end

aObj.blizzLoDFrames[ftype].MacroUI = function(self)
	if not self.db.profile.MenuFrames or self.initialized.MacroUI then return end
	self.initialized.MacroUI = true

-->>-- Macro Frame
	self:skinSlider{obj=_G.MacroButtonScrollFrame.ScrollBar, rt="artwork"}
	self:skinSlider{obj=_G.MacroFrameScrollFrame.ScrollBar}
	self:skinEditBox{obj=_G.MacroFrameText, noSkin=true}
	self:addSkinFrame{obj=_G.MacroFrameTextBackground, ft=ftype, x2=1}
	self:skinTabs{obj=_G.MacroFrame, up=true, lod=true, x1=-3, y1=-3, x2=3, y2=-3, hx=-2, hy=3}
	self:addSkinFrame{obj=_G.MacroFrame, ft=ftype, kfs=true, hdr=true, ri=true, x1=-3, y1=2, x2=1, y2=-2}
	-- add button borders
	_G.MacroFrameSelectedMacroButton:DisableDrawLayer("BACKGROUND")
	self:addButtonBorder{obj=_G.MacroFrameSelectedMacroButton, relTo=_G.MacroFrameSelectedMacroButtonIcon}
	local btn
	for i = 1, _G.MAX_ACCOUNT_MACROS do
		btn = _G["MacroButton" .. i]
		btn:DisableDrawLayer("BACKGROUND")
		self:addButtonBorder{obj=btn, relTo=_G["MacroButton" .. i .. "Icon"], spbt=true}
	end
	btn = nil

-->>-- Macro Popup Frame
	self:adjHeight{obj=_G.MacroPopupScrollFrame, adj=20} -- stretch to bottom of scroll area
	self:skinSlider{obj=_G.MacroPopupScrollFrame.ScrollBar, rt="background"}
	self:removeRegions(self:getChild(_G.MacroPopupFrame, 1), {1, 2, 3, 4, 5, 6, 7, 8})
	self:adjHeight{obj=_G.MacroPopupFrame, adj=20}
	self:skinEditBox{obj=_G.MacroPopupEditBox}
	self:addSkinFrame{obj=_G.MacroPopupFrame, ft=ftype, kfs=true, x1=8, y1=-8, x2=-2, y2=4}
	self:SecureHookScript(_G.MacroPopupFrame, "OnShow", function(this)
		local btn
		for i = 1, _G.NUM_MACRO_ICONS_SHOWN do
			btn = _G["MacroPopupButton" .. i]
			btn:DisableDrawLayer("BACKGROUND")
			self:addButtonBorder{obj=btn, relTo=_G["MacroPopupButton" .. i .. "Icon"], spbt=true}
		end
		btn = nil
		self:Unhook(_G.MacroPopupFrame, "OnShow")
	end)

end

aObj.blizzFrames[ftype].MailFrame = function(self)
	if not self.db.profile.MailFrame or self.initialized.MailFrame then return end
	self.initialized.MailFrame = true

	self:skinTabs{obj=_G.MailFrame}
	self:addSkinFrame{obj=_G.MailFrame, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-5}

-->>--	Inbox Frame
	local btn
	for i = 1, _G.INBOXITEMS_TO_DISPLAY do
		self:keepFontStrings(_G["MailItem" .. i])
		btn = _G["MailItem" .. i .. "Button"]
		btn:DisableDrawLayer("BACKGROUND")
		self:addButtonBorder{obj=btn, ofs=3}
	end
	btn = nil
	self:moveObject{obj=_G.InboxTooMuchMail, y=-24} -- move icon down
	self:removeRegions(_G.InboxFrame, {1}) -- background texture
	self:addButtonBorder{obj=_G.InboxPrevPageButton, ofs=-2, y1=-3, x2=-3}
	self:addButtonBorder{obj=_G.InboxNextPageButton, ofs=-2, y1=-3, x2=-3}

-->>--	Send Mail Frame
	self:keepFontStrings(_G.SendMailFrame)
	self:skinSlider{obj=_G.SendMailScrollFrame.ScrollBar, rt={"background", "artwork"}}
	local btn
	for i = 1, _G.ATTACHMENTS_MAX_SEND do
		btn = _G["SendMailAttachment" .. i]
		if not self.modBtnBs then
			self:resizeEmptyTexture(self:getRegion(btn, 1))
		else
			btn:DisableDrawLayer("BACKGROUND")
			self:addButtonBorder{obj=btn, ofs=3}
		end
	end
	btn = nil
	self:skinEditBox{obj=_G.SendMailNameEditBox, regs={3}, noWidth=true} -- N.B. region 3 is text
	self:skinEditBox{obj=_G.SendMailSubjectEditBox, regs={3}, noWidth=true} -- N.B. region 3 is text
	self:skinEditBox{obj=_G.SendMailBodyEditBox, noSkin=true}
	local clr = self.db.profile.BodyText
	_G.SendMailBodyEditBox:SetTextColor(clr.r, clr.g, clr.b)
	clr = nil
	self:skinMoneyFrame{obj=_G.SendMailMoney, moveSEB=true, moveGEB=true, noWidth=true}
	self:removeInset(_G.SendMailMoneyInset)
	_G.SendMailMoneyBg:DisableDrawLayer("BACKGROUND")

-->>--	Open Mail Frame
	_G.OpenMailScrollFrame:DisableDrawLayer("BACKGROUND")
	self:skinSlider{obj=_G.OpenMailScrollFrame.ScrollBar, rt="overlay"}
	_G.OpenMailBodyText:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:addSkinFrame{obj=_G.OpenMailFrame, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-2}
	self:addButtonBorder{obj=_G.OpenMailLetterButton, ibt=true, ofs=3}
	self:addButtonBorder{obj=_G.OpenMailMoneyButton, ibt=true, ofs=3}
	local btn
	for i = 1, _G.ATTACHMENTS_MAX_RECEIVE do
		btn = _G["OpenMailAttachmentButton" .. i]
		self:addButtonBorder{obj=btn, ibt=true, ofs=3}
	end
	btn = nil
-->>-- Invoice Frame Text fields
	local nTab = {"ItemLabel", "Purchaser", "BuyMode", "SalePrice", "Deposit", "HouseCut", "AmountReceived", "NotYetSent", "MoneyDelay"}
	for i = 1, #nTab do
		_G["OpenMailInvoice" .. nTab[i]]:SetTextColor(self.BTr, self.BTg, self.BTb)
	end
	nTab = nil

end

aObj.blizzFrames[ftype].MainMenuBar = function(self)
	if IsAddOnLoaded("Dominos") then
		aObj.blizzFrames[ftype].MainMenuBar = nil
		return
	end

	if not self.db.profile.MainMenuBar.skin or self.initialized.MainMenuBar then return end
	self.initialized.MainMenuBar = true

	_G.ExhaustionTick:SetAlpha(0)
	self:moveObject{obj=_G.MainMenuExpBar, y=2}
	self:keepRegions(_G.MainMenuExpBar, {1, 2, 3, 4, 5, 9, 10}) -- N.B. region 5 is rested XP, 9 is background, 10 is the normal XP
	self:addSkinFrame{obj=_G.MainMenuBar, ft=ftype, noBdr=true, x1=-4, y1=-5, x2=4, y2=IsAddOnLoaded("DragonCore") and -47 or -4}
	self:keepFontStrings(_G.MainMenuBarMaxLevelBar)
	self:keepFontStrings(_G.MainMenuBarArtFrame)

	local function moveWatchBar(bar)
		-- adjust offset dependant upon player level
		aObj:moveObject{obj=bar, y=aObj.uLvl < _G.MAX_PLAYER_LEVEL_TABLE[_G.GetExpansionLevel()] and 2 or 4}
		-- stop it being moved
		bar.SetPoint = _G.nop
		-- move text down
		bar.OverlayFrame.Text:SetPoint("CENTER", 0, -1)
		-- increase frame level so it responds to mouseovers'
		aObj:RaiseFrameLevelByFour(bar)
	end

	-- ReputationWatchBar
	moveWatchBar(_G.ReputationWatchBar)
	self:keepRegions(_G.ReputationWatchBar.StatusBar, {1, 2, 3, 4, 13, 14, 16}) -- 13 is background, 14 is the normal texture
	-- ArtifactWatchBar
	local awbsb = _G.ArtifactWatchBar.StatusBar
	moveWatchBar(_G.ArtifactWatchBar)
	awbsb:DisableDrawLayer("ARTWORK")
	_G.ArtifactWatchBar.Tick:SetAlpha(0)
	-- HonorWatchBar
	local hwbsb = _G.HonorWatchBar.StatusBar
	moveWatchBar(_G.HonorWatchBar)
	hwbsb:DisableDrawLayer("ARTWORK")
	_G.HonorWatchBar.ExhaustionTick:SetAlpha(0)
	if self.db.profile.MainMenuBar.glazesb then
		self:glazeStatusBar(_G.MainMenuExpBar, 0, self:getRegion(_G.MainMenuExpBar, 9), {_G.ExhaustionLevelFillBar})
		self:glazeStatusBar(_G.ReputationWatchBar.StatusBar, 0, _G.ReputationWatchBar.StatusBar.Background)
		self:glazeStatusBar(awbsb, 0, awbsb.Background, {awbsb.Underlay})
		self:glazeStatusBar(hwbsb, 0, hwbsb.Background, {hwbsb.Underlay, _G.HonorWatchBar.ExhaustionLevelFillBar})
	end
	awbsb, hwbsb = nil, nil

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
	local btnName
	for i = 1, _G.NUM_PET_ACTION_SLOTS do
		btnName = "PetActionButton" .. i
		self:addButtonBorder{obj=_G[btnName], abt=true, sec=true, reParent={_G[btnName .. "AutoCastable"]}, ofs=3}
	end
	btnName = nil
	-- Shaman's Totem Frame
	self:keepFontStrings(_G.MultiCastFlyoutFrame)

-->>-- Action Buttons
	local btn
	for i = 1, _G.NUM_ACTIONBAR_BUTTONS do
		btn = _G["ActionButton" .. i]
		btn.FlyoutBorder:SetTexture(nil)
		btn.FlyoutBorderShadow:SetTexture(nil)
		self:addButtonBorder{obj=btn, abt=true, sec=true}
	end
	btn = nil
	-- Micro buttons, skinned before checks for a consistent look, 12.10.12
	local nTab = {"Character", "Spellbook", "Talent", "Achievement", "QuestLog", "Guild", "LFD", "Collections", "EJ", "Store"}
	for i = 1, #nTab do
		self:addButtonBorder{obj=_G[nTab[i] .. "MicroButton"], mb=true, ofs=0, y1=-21}
	end
	nTab = nil
	self:addButtonBorder{obj=_G.MainMenuMicroButton, mb=true, ofs=0, y1=-21, reParent={_G.MainMenuBarPerformanceBar, _G.MainMenuBarDownload}}

-->>-- skin bag buttons
	self:addButtonBorder{obj=_G.MainMenuBarBackpackButton, ibt=true}
	self:addButtonBorder{obj=_G.CharacterBag0Slot, ibt=true}
	self:addButtonBorder{obj=_G.CharacterBag1Slot, ibt=true}
	self:addButtonBorder{obj=_G.CharacterBag2Slot, ibt=true}
	self:addButtonBorder{obj=_G.CharacterBag3Slot, ibt=true}

	-- MultiCastActionBarFrame
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
	local nTab = {"Talent", "Collections", "LFD", "EJ"}
	 for i =1, #nTab do
		self:skinButton{obj=_G[nTab[i] .. "MicroButtonAlert"].CloseButton, cb=true}
	end
	nTab = nil

-->>-- Extra Action Button
	if self.db.profile.MainMenuBar.extraab then
		local btn = _G.ExtraActionButton1
		btn:GetNormalTexture():SetTexture(nil)
		self:addButtonBorder{obj=btn, ofs=2, relTo=btn.icon}
		-- handle bug when Tukui is loaded
		if not aObj:isAddonEnabled("Tukui") then
			btn.style:SetTexture(nil)
			btn.style.SetTexture = _G.nop
		end
		btn = nil
	end

-->>-- UnitPowerBarAlt (inc. PlayerPowerBarAlt)
	if self.db.profile.MainMenuBar.altpowerbar then
		local function skinUnitPowerBarAlt(upba)
			upba:DisableDrawLayer("BACKGROUND")
			-- Don't change the status bar texture as it changes dependant upon type of power type required
			upba.frame:SetAlpha(0)
			-- adjust height and TextCoord so background appears, this enables the numbers to become easier to see
			upba.counterBar:SetHeight(26)
			upba.counterBar.BG:SetTexCoord(0.0, 1.0, 0.35, 0.40)
			upba.counterBar.BGL:SetAlpha(0)
			upba.counterBar.BGR:SetAlpha(0)
			upba.counterBar:DisableDrawLayer("ARTWORK")
		end
		self:SecureHook("UnitPowerBarAlt_SetUp", function(this, barID)
			skinUnitPowerBarAlt(this)
		end)
		-- skin PlayerPowerBarAlt if already shown
		if _G.PlayerPowerBarAlt:IsVisible() then
			skinUnitPowerBarAlt(_G.PlayerPowerBarAlt)
		end
		-- skin BuffTimers
		for i = 1, 10 do
			if _G["BuffTimer" .. i] then
				skinUnitPowerBarAlt(_G["BuffTimer" .. i])
			end
		end
	end

-->>-- MultiBar Buttons
	local nTab, btn = {"BottomLeft", "BottomRight", "Right", "Left"}
	for i = 1, #nTab do
		for j = 1, _G.NUM_MULTIBAR_BUTTONS do
			btn = _G["MultiBar" .. nTab[i] .. "Button" .. j]
			btn.FlyoutBorder:SetTexture(nil)
			btn.FlyoutBorderShadow:SetTexture(nil)
			btn.Border:SetAlpha(0) -- texture changed in blizzard code
			_G["MultiBar" .. nTab[i] .. "Button" .. j .. "FloatingBG"]:SetAlpha(0)
			self:addButtonBorder{obj=btn, abt=true, sec=true}
		end
	end
	nTab, btn = nil, nil

	-- hook this to hide button grid after it has been shown
	self:SecureHook("ActionButton_HideGrid", function(btn)
		if _G[btn:GetName() .. "NormalTexture"] then
			_G[btn:GetName() .. "NormalTexture"]:SetVertexColor(1.0, 1.0, 1.0, 0)
		end
	end)

end

-- table to hold addon dropdown names that need to have their length adjusted
aObj.iofDD = {}
aObj.blizzFrames[ftype].MenuFrames = function(self)
	if not self.db.profile.MenuFrames or self.initialized.MenuFrames then return end
	self.initialized.MenuFrames = true

-->>-- Game Menu Frame
	self:addSkinFrame{obj=_G.GameMenuFrame, ft=ftype, kfs=true, hdr=true}

	local function checkChild(child)
		if aObj:hasTextInName(child, "DropDown") then
			aObj:skinDropDown{obj=child}
		end
		if child:IsObjectType("Slider") then
			aObj:skinSlider{obj=child, hgt=aObj:getInt(child:GetHeight()) == 22 and -7 or -2}
		end
	end
	local function skinKids(obj)
		local kids = {obj:GetChildren()}
		for i = 1, #kids do
			checkChild(kids[i])
		end
		kids = nil
	end

-->>-- System
	self:addSkinFrame{obj=_G.VideoOptionsFrame, ft=ftype, kfs=true, hdr=true}
	self:addSkinFrame{obj=_G.VideoOptionsFrameCategoryFrame, ft=ftype, kfs=true}
	self:skinSlider(_G.VideoOptionsFrameCategoryFrameListScrollBar)
	self:addSkinFrame{obj=_G.VideoOptionsFramePanelContainer, ft=ftype}

	-- Graphics
	skinKids(_G.Display_)
	self:addSkinFrame{obj=_G.Display_, ft=ftype}
	skinKids(_G.Graphics_)
	self:addSkinFrame{obj=_G.Graphics_, ft=ftype}
	skinKids(_G.RaidGraphics_)
	self:addSkinFrame{obj=_G.RaidGraphics_, ft=ftype}
	-- Advanced
	skinKids(_G.Advanced_)
	self:skinDropDown{obj=_G.Advanced_MultisampleAlphaTest}
	-- Network
	-- Languages
	skinKids(_G.InterfaceOptionsLanguagesPanel)

	-- Sound
	skinKids(_G.AudioOptionsSoundPanel)
	self:addSkinFrame{obj=_G.AudioOptionsSoundPanel, ft=ftype}
	self:addSkinFrame{obj=_G.AudioOptionsSoundPanelPlayback, ft=ftype}
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
	self:skinTabs{obj=_G.InterfaceOptionsFrame, up=true, lod=true, ignore=true, ignht=true, x1=6, y1=2, x2=-6, y2=-4}
	self:addSkinFrame{obj=_G.InterfaceOptionsFrame, ft=ftype, kfs=true, hdr=true}
	_G.InterfaceOptionsFrameCategoriesList:SetBackdrop(nil)
	self:skinSlider{obj=_G.InterfaceOptionsFrameCategoriesListScrollBar}
	self:addSkinFrame{obj=_G.InterfaceOptionsFrameCategories, ft=ftype, kfs=true}
	_G.InterfaceOptionsFrameAddOnsList:SetBackdrop(nil)
	self:skinSlider{obj=_G.InterfaceOptionsFrameAddOnsListScrollBar}
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
	if _G.CompactUnitFrameProfiles then
		_G.CompactUnitFrameProfiles.optionsFrame.autoActivateBG:SetTexture(nil)
	end

	local function checkKids(obj)

		-- aObj:Debug("checkKids#1: [%s, %s, %s]", obj, obj:GetObjectType(), obj.name)

		-- ignore object if required
		-- ignore named/AceConfig/XConfig/AceGUI objects
		if aObj.ignoreIOF[obj]
		or aObj:hasAnyTextInName(obj, {"AceConfig", "XConfig", "AceGUI"})
		then
			return
		end

		local kids, child = {obj:GetChildren()}
		-- aObj:Debug("checkKids#2: [%s]", #kids)
		for i = 1, #kids do
			child = kids[i]
			if not aObj.ignoreIOF[child]
			and not aObj:hasAnyTextInName(child, {"AceConfig", "XConfig", "AceGUI"})
			then
				-- aObj:Debug("checkKids#3: [%s, %s, %s]", child, child:GetObjectType(), "DropDown?: " .. (aObj:isDropDown(child) and "true" or "false"))
				if aObj:isDropDown(child) then
					 -- ignore TinyTooltip colourpicker(s)
					if child ~= obj.colordropdown then
						local xOfs
						-- apply addon specific adjustments
						for ddtext, ddofs in pairs(aObj.iofDD) do
							if aObj:hasTextInName(child, ddtext) then
								xOfs = ddofs
							end
						end
						-- handle SushiDropdown (used by Bagnon)
						if aObj:hasTextInName(child, "SushiDropdown") then
							aObj:secureHook(_G.SushiDropFrame, "OnCreate", function(this)
								local frame
								for j = 1, #this.usedFrames do
									frame = this.usedFrames[j]
									if not frame.bg.sf then
										aObj:addSkinFrame{obj=frame.bg, kfs=true}
										frame.bg.SetBackdrop = _G.nop
									end
								end
								frame = nil
							end)
							aObj:secureHook(_G.SushiDropFrame, "OnAcquire", function(this)
								-- need to raise frame level so it's above other text
								_G.RaiseFrameLevelByTwo(this)
							end)
						end
						-- handle TinyTooltip dropdowns
						if child.keystring then xOfs = 110 end
						aObj:skinDropDown{obj=child, x2=xOfs}
						xOfs = nil
					end
				elseif child:IsObjectType("EditBox") then
						aObj:skinEditBox{obj=child, regs={6}}
				elseif child:IsObjectType("ScrollFrame") then
					if child:GetName()
					and child:GetName() .. "ScrollBar" -- handle named ScrollBar's
					then
						aObj:skinScrollBar{obj=child}
					end
				elseif child:IsObjectType("Slider") then
					if aObj:hasTextInName(child, "SushiSlider")
					then
						aObj:skinSlider{obj=child, hgt=-2}
					else
						aObj:skinSlider{obj=child}
					end
				-- Cork Config panel tabs
				elseif child:IsObjectType("Button")
				and obj.name == "Cork"
				and child.OrigSetText
				then
					-- hide textures (changed in code)
					child.left:SetAlpha(0)
					child.right:SetAlpha(0)
					child.middle:SetAlpha(0)
					aObj:addSkinFrame{obj=child, noBdr=aObj.isTT, x1=6, y1=0, x2=-6, y2=-3}
					if aObj.isTT then
						child.sf.ignore = true
						if child:IsEnabled() then
							aObj:setInactiveTab(child.sf)
						else
							aObj:setActiveTab(child.sf)
						end
						aObj:secureHook(child.left, "SetTexture", function(this, tex)
							if aObj:hasTextInTexture(this, "InActiveTab", true) then
								aObj:setInactiveTab(this:GetParent().sf)
							else
								aObj:setActiveTab(this:GetParent().sf)
							end
						end)
					end
				-- TinyInspect SubtypeFrame
				elseif child:IsObjectType("CheckButton")
				and child.SubtypeFrame
				then
					aObj:addSkinFrame{obj=child.SubtypeFrame}
				elseif child:IsObjectType("CheckButton") then
					aObj:skinCheckButton{obj=child}
				else
					checkKids(child)
				end
				-- remove Ampere's container background
				if obj.name == "Ampere"
				and child:GetNumRegions() == 1
				then
					child:DisableDrawLayer("BACKGROUND")
				end
				-- remove TinyTooltip element(s) backdrop
				if child.checkbox
				and aObj:getInt(child:GetWidth()) == 560
				then
					child:SetBackdrop(nil)
				end
				-- AdvancedInterfaceOptions
				if obj.name == "CVar Browser" then
					if i == 2 then -- ListFrame
						aObj:removeInset(child)
						child:DisableDrawLayer("ARTWORK") -- scrollbar textures
						_G.RaiseFrameLevelByTwo(child) -- make it visible
					end
				end
			end
		end
		kids, child = nil, nil

	end
	-- hook this to skin Interface Option panels and their elements
	self:SecureHook("InterfaceOptionsList_DisplayPanel", function(panel)
		-- aObj:Debug("IOL_DP: [%s, %s]", panel, panel.GetNumChildren)
		-- skin tekKonfig library objects here as well as in AddonFrames to handle late loading of libraries
		if self.tekKonfig then
			self:checkAndRun("tekKonfig", "s") -- not an addon in its own right
		end
		-- run Addon Loader skin code here
		if panel.name == "Addon Loader"
		and self.AddonLoader
		then
			self:checkAndRunAddOn("AddonLoader")
		end
		if panel
		and panel.GetNumChildren
		then
			_G.C_Timer.After(0.1, function() checkKids(panel) end) -- wait for the panel to be populated
			_G.C_Timer.After(0.1, function() self:skinAllButtons{obj=panel, as=true, ft=ftype} end) -- wait for the panel to be populated, always use applySkin to ensure text appears above button texture
			self:addSkinFrame{obj=panel, ft=ftype, kfs=true, nb=true}
		end
	end)

end

aObj.blizzFrames[ftype].Minimap = function(self)
	if IsAddOnLoaded("SexyMap") then
		aObj.blizzFrames[ftype].Minimap = nil
		return
	end

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
	self:addSkinButton{obj=_G.MinimapZoneTextButton, parent=_G.MinimapZoneTextButton, ft=ftype, x1=-5, x2=5}
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
	local function skinmmBut(name)
		local obj = _G["MiniMap" .. name]
		if obj then
			obj:ClearAllPoints()
			obj:SetPoint("TOPRIGHT", _G.Minimap, "TOPLEFT", 0, yOfs)
			yOfs = yOfs - obj:GetHeight() + 3
		end
		obj = nil
	end
	skinmmBut("Tracking")
	skinmmBut("VoiceChatFrame")
	yOfs = nil
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
		difficulty, maxPlayers, isHeroic, xOffset = nil, nil, nil, nil
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

aObj.mmButs = {}
aObj.blizzFrames[ftype].MinimapButtons = function(self)
	if not self.db.profile.MinimapButtons.skin or self.initialized.MinimapButtons then return end
	self.initialized.MinimapButtons = true

	local minBtn = self.db.profile.MinimapButtons.style
	local asopts = {ba=minBtn and 0 or 1, bba=minBtn and 0 or 1, ng=minBtn and true or nil}

	local function mmKids(mmObj)

		local objName, objType
		local kids, obj = {mmObj:GetChildren()}
		for i = 1, #kids do
			obj = kids[i]
			objName, objType = obj:GetName(), obj:GetObjectType()
			if not obj.sb
			and not obj.sf
			and not objName == "QueueStatusMinimapButton" -- ignore QueueStatusMinimapButton
			and not objName == "OQ_MinimapButton" -- ignore oQueue's minimap button
			and objType == "Button"
			or (objType == "Frame" and objName == "MiniMapMailFrame")
			then
				local regs, reg = {obj:GetRegions()}
				for i = 1, #regs do
					reg = regs[i]
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
				regs, reg = nil, nil
			elseif objType == "Frame"
			and (objName
			and not objName == "MiniMapTrackingButton") -- handled below
			then
				mmKids(obj)
			end
		end
		kids, obj = nil, nil
		objName, objType = nil, nil

	end
	local function makeSquare(obj, x1, y1, x2, y2)

		obj:SetSize(26, 26)
		obj:GetNormalTexture():SetTexCoord(x1, y1, x2, y2)
		obj:GetPushedTexture():SetTexCoord(x1, y1, x2, y2)
		obj:GetHighlightTexture():SetTexture([[Interface\Buttons\ButtonHilight-Square]])
		aObj:addSkinFrame{obj=obj, aso=asopts, ofs=4}
		-- make sure textures appear above skinFrame
		_G.LowerFrameLevel(obj.sf)
		-- alter the HitRectInsets to make it easier to activate
		obj:SetHitRectInsets(-5, -5, -5, -5)

	end

	-- skin Minimap children, allow for delayed addons to be loaded (e.g. Baggins)
	_G.C_Timer.After(0.5, function() mmKids(_G.Minimap) end)

	-- Calendar button
	makeSquare(_G.GameTimeFrame, 0.1, 0.31, 0.16, 0.6)

	-- MinimapZoomIn/Out buttons
	local function skinZoom(obj)
		obj:GetNormalTexture():SetTexture(nil)
		obj:GetPushedTexture():SetTexture(nil)
		if minBtn then
			obj:GetDisabledTexture():SetTexture([[Interface\Minimap\UI-Minimap-Background]])
		else
			obj:GetDisabledTexture():SetTexture(nil)
		end
		aObj:adjWidth{obj=obj, adj=-8}
		aObj:adjHeight{obj=obj, adj=-8}
		aObj:addSkinButton{obj=obj, parent=obj, aso=asopts, ft=ftype}
		obj.sb:SetAllPoints(obj:GetNormalTexture())
		obj.sb:SetNormalFontObject(aObj.modUIBtns.fontX)
		obj.sb:SetDisabledFontObject(aObj.modUIBtns.fontDX)
		obj.sb:SetPushedTextOffset(1, 1)
		if not obj:IsEnabled() then obj.sb:Disable() end
	end
	skinZoom(_G.MinimapZoomIn)
	_G.MinimapZoomIn.sb:SetText(self.modUIBtns.plus)
	skinZoom(_G.MinimapZoomOut)
	_G.MinimapZoomOut.sb:SetText(self.modUIBtns.minus)

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
	_G.MiniMapTrackingIcon.SetPoint = _G.nop
	if not minBtn then
		self:addSkinFrame{obj=_G.MiniMapTracking, ft=ftype}
	end
	_G.QueueStatusMinimapButtonBorder:SetTexture(nil)
	self:addSkinButton{obj=_G.QueueStatusMinimapButton, ft=ftype, sap=true}

	-- skin any moved Minimap buttons if required
	if IsAddOnLoaded("MinimapButtonFrame") then mmKids(_G.MinimapButtonFrame) end

	-- show the Bongos minimap icon if required
	if IsAddOnLoaded("Bongos") then _G.Bongos3MinimapButton.icon:SetDrawLayer("ARTWORK") end

	-- skin other minimap buttons as required
	if not minBtn then
		local function skinMMBtn(cb, btn, name)

			local regs, reg = {btn:GetRegions()}
			for i = 1, #regs do
				reg = regs[i]
				if reg:GetObjectType() == "Texture" then
					if aObj:hasTextInName(reg, "Border")
					or aObj:hasTextInTexture(reg, "TrackingBorder")
					then
						reg:SetTexture(nil)
					end
				end
			end
			regs, reg = nil, nil

			aObj:addSkinButton{obj=btn, ft=ftype, parent=btn, sap=true}

		end
		for addon, obj in pairs(self.mmButs) do
			if IsAddOnLoaded(addon) then
				skinMMBtn("Loaded Addons btns", obj)
			end
		end
		self.mmButs = nil

		-- skin existing LibDBIcon buttons
		for name, button in pairs(_G.LibStub("LibDBIcon-1.0").objects) do
			skinMMBtn("Existing LibDBIcon btns", button, name)
		end
		-- skin LibDBIcon Minimap Buttons when created
--		_G.LibStub("LibDBIcon-1.0").RegisterCallback(aObj, "LibDBIcon_IconCreated", skinMMBtn)
		aObj.RegisterCallback(aObj, "LibDBIcon_IconCreated", skinMMBtn)
	end

	-- Garrison Landing Page Minimap button
	makeSquare(_G.GarrisonLandingPageMinimapButton, 0.25, 0.76, 0.32, 0.685)

end

aObj.blizzLoDFrames[ftype].MovePad = function(self)
	if not self.db.profile.MovePad or self.initialized.MovePad then return end
	self.initialized.MovePad = true

	self:skinButton{obj=_G.MovePadLock, lb=true}
	self:moveObject{obj=_G.MovePadLock, x=-6, y=7} -- move it up and left
	self:skinButton{obj=_G.MovePadForward}
	self:skinButton{obj=_G.MovePadJump}
	self:skinButton{obj=_G.MovePadBackward}
	self:skinButton{obj=_G.MovePadStrafeLeft}
	self:skinButton{obj=_G.MovePadStrafeRight}
	self:addSkinFrame{obj=_G.MovePadFrame, ft=ftype, nb=true}

end

aObj.blizzFrames[ftype].MovieFrame = function(self)
	if not self.db.profile.MovieFrame or self.initialized.MovieFrame then return end
	self.initialized.MovieFrame = true

	self:addSkinFrame{obj=_G.MovieFrame.CloseDialog, ft=ftype}

end

aObj.blizzFrames[ftype].NamePlates = function(self)
	if not self.db.profile.Nameplates or self.initialized.Nameplates then return end
	self.initialized.Nameplates = true

	local function skinNamePlate(frame)

		local nP = frame.UnitFrame

		if nP then
			-- healthBar
			aObj:glazeStatusBar(nP.healthBar, 0, nP.healthBar.background, {nP.healthBar.myHealPrediction, nP.healthBar.otherHealPrediction})
			-- castBar
			aObj:glazeStatusBar(nP.castBar, 0, nP.castBar.background)
			-- TODO handle large size NamePlates
			aObj:changeShield(nP.castBar.BorderShield, nP.castBar.Icon)
		end
		nP = nil

	end

	-- skin any existing NamePlates
	for _, frame in pairs(_G.C_NamePlate.GetNamePlates()) do
		skinNamePlate(frame)
	end

	-- hook this to skin created Nameplates
	self:SecureHook(_G.NamePlateDriverFrame, "OnNamePlateCreated", function(this, namePlateFrameBase)
		skinNamePlate(namePlateFrameBase)
	end)

	-- Class Nameplate Frames
	-- ManaFrame
	local mF = _G.ClassNameplateManaBarFrame
	if mF then
		self:glazeStatusBar(mF, 0,  nil, {mF.ManaCostPredictionBar, mF.FeedbackFrame.BarTexture})
		mF.SetTexture = _G.nop
		mF = nil
	end

	-- DeathKnight (nothing to skin)
	-- Mage (nothing to skin)
	-- Monk
	for i = 1, #_G.ClassNameplateBarWindwalkerMonkFrame.Chi do
		_G.ClassNameplateBarWindwalkerMonkFrame.Chi[i]:DisableDrawLayer("BACKGROUND")
	end
	self:glazeStatusBar(_G.ClassNameplateBrewmasterBarFrame, 0,  nil)
	-- Paladin
	for i = 1, #_G.ClassNameplateBarPaladinFrame.Runes do
		_G.ClassNameplateBarPaladinFrame.Runes[i].OffTexture:SetTexture(nil)
	end
	-- Rogue/Druid
	for i = 1, #_G.ClassNameplateBarRogueDruidFrame.ComboPoints do
		_G.ClassNameplateBarRogueDruidFrame.ComboPoints[i]:DisableDrawLayer("BACKGROUND")
	end
	-- Warlock
	for i = 1, #_G.ClassNameplateBarWarlockFrame.Shards do
		_G.ClassNameplateBarWarlockFrame.Shards[i].ShardOff:SetTexture(nil)
	end

end

aObj.blizzFrames[ftype].NavigationBar = function(self)
	-- Helper function, used by several frames

	-- hook this to handle navbar buttons
	self:SecureHook("NavBar_AddButton", function(this, buttonData)
		local btn
		for i = 1, #this.navList do
			btn = this.navList[i]
			btn:DisableDrawLayer("OVERLAY")
			btn:GetNormalTexture():SetAlpha(0)
			btn:GetPushedTexture():SetAlpha(0)
			if self.modBtnBs
			and btn.MenuArrowButton -- Home button doesn't have one
			and not btn.MenuArrowButton.sbb
			then
				self:addButtonBorder{obj=btn.MenuArrowButton, ofs=-2, x1=-1, x2=0}
				btn.MenuArrowButton.sbb:SetAlpha(0) -- hide button border
				self:HookScript(btn.MenuArrowButton, "OnEnter", function(this)
					this.sbb:SetAlpha(1)
				end)
				self:HookScript(btn.MenuArrowButton, "OnLeave", function(this)
					this.sbb:SetAlpha(0)
				end)
			end
		end
		btn = nil
	end)

end

aObj.blizzLoDFrames[ftype].ObliterumUI = function(self)
	if not self.db.profile.ObliterumUI or self.initialized.ObliterumUI then return end
	self.initialized.ObliterumUI = true

	_G.ObliterumForgeFrame.Background:SetTexture(nil)
	self:removeMagicBtnTex(_G.ObliterumForgeFrame.ObliterateButton)
	_G.ObliterumForgeFrame.ItemSlot:DisableDrawLayer("ARTWORK")
	_G.ObliterumForgeFrame.ItemSlot:DisableDrawLayer("OVERLAY")
	self:addSkinFrame{obj=_G.ObliterumForgeFrame, ft=ftype, kfs=true, ri=true, ofs=2, x2=1}
	self.modUIBtns:addButtonBorder{obj=_G.ObliterumForgeFrame.ItemSlot} -- use module function to force button border

end

aObj.blizzLoDFrames[ftype].OrderHallUI = function(self)
	if not self.db.profile.OrderHallUI or self.initialized.OrderHallUI then return end
	self.initialized.OrderHallUI = true

	-->>-- OrderHallMissionFrame
	-- Mission Frame
	_G.OrderHallMissionFrame.ClassHallIcon:DisableDrawLayer("OVERLAY") -- this hides the frame
	self:skinButton{obj=_G.OrderHallMissionFrame.CloseButton, cb=true}
	_G.OrderHallMissionFrame.GarrCorners:DisableDrawLayer("BACKGROUND")
	-- don't skin buttons, otherwise Tab buttons get skinned  as well
	self:addSkinFrame{obj=_G.OrderHallMissionFrame, ft=ftype, kfs=true, nb=true, x1=2, y1=2, x2=1, y2=-4}
	_G.OrderHallMissionFrame.sf:SetFrameStrata("LOW") -- allow map textures to be visible
	-- tabs
	self:skinTabs{obj=_G.OrderHallMissionFrame, regs={9, 10}, ignore=true, lod=true, x1=9, y1=2, x2=-9, y2=-4}

	-- FollowerList
	local fl = _G.OrderHallMissionFrame.FollowerList
	fl:DisableDrawLayer("BORDER")
	fl.MaterialFrame:DisableDrawLayer("BACKGROUND")
	-- if FollowerList not yet populated, hook the function
	if not fl.listScroll.buttons then
		self:SecureHook(fl, "Initialize", function(this, ...)
			skinFollowerList(this)
			aObj:Unhook(fl, "Initialize")
		end)
	else
		skinFollowerList(fl)
	end
	self:SecureHook(fl, "ShowFollower", function(this, id)
		skinFollowerAbilitiesAndCounters(this, id)
	end)
	fl = nil

	-->>-- MissionTab
	-- Mission List
	local ml = _G.OrderHallMissionFrame.MissionTab.MissionList
	skinMissionList(ml)

	-- CombatAllyUI
	ml.CombatAllyUI.Background:SetTexture(nil)
	ml.CombatAllyUI.Available.AddFollowerButton.EmptyPortrait:SetTexture(nil)
	skinPortrait(ml.CombatAllyUI.InProgress.PortraitFrame)
	-- self:skinButton{obj=ml.CombatAllyUI.Available.AddFollowerButton}
	self:skinButton{obj=ml.CombatAllyUI.InProgress.Unassign}
	ml = nil

	_G.OrderHallMissionFrame.MissionTab.ZoneSupportMissionPageBackground:DisableDrawLayer("BACKGROUND")
	-- ZoneSupportMissionPage (i.e. Combat Ally selection page)
	local zs = _G.OrderHallMissionFrame.MissionTab.ZoneSupportMissionPage
	-- remove frame textures
	zs:DisableDrawLayer("BACKGROUND")
	zs:DisableDrawLayer("BORDER")
	zs.CombatAllyLabel.TextBackground:SetTexture(nil)
	zs.ButtonFrame:SetTexture(nil)
	zs.Follower1:DisableDrawLayer("BACKGROUND")
	skinPortrait(zs.Follower1.PortraitFrame)
	self:addSkinFrame{obj=zs, ft=ftype, kfs=true, x1=-360, y1=434, x2=3, y2=-65}
	zs.CloseButton:SetSize(28, 28)
	self:skinButton{obj=zs.StartMissionButton}
	zs = nil

	-- MissionPage
	local mp = _G.OrderHallMissionFrame.MissionTab.MissionPage
	skinMissionPage(mp)
	mp.CloseButton:SetSize(28, 28)
	for i = 1, #mp.Followers do
		self:removeRegions(mp.Followers[i], {1})
		skinPortrait(mp.Followers[i].PortraitFrame)
	end
	for i = 1, #mp.Enemies do
		mp.Enemies[i].PortraitFrame.PortraitRing:SetTexture(nil)
	end
	self:moveObject{obj=mp.FollowerModel, x=-6, y=0}
	mp = nil

	-->>-- FollowerTab
	_G.OrderHallMissionFrame.FollowerTab:DisableDrawLayer("BORDER")
	skinFollowerPage(_G.OrderHallMissionFrame.FollowerTab)

	-- MissionComplete
	local mc = _G.OrderHallMissionFrame.MissionComplete
	skinMissionComplete(mc)
	for i = 1, #mc.Stage.EncountersFrame.Encounters do
		mc.Stage.EncountersFrame.Encounters[i].Ring:SetTexture(nil)
	end
    self:rmRegionsTex(mc.Stage.MissionInfo, {1, 2, 3, 4, 5, 11, 12, 13})
	mc = nil

	-->>-- MapTab

	-- Talents
	-- OrderHallTalentFrame
	self:removeInset(_G.OrderHallTalentFrame.LeftInset)
	self:addSkinFrame{obj=_G.OrderHallTalentFrame, ft=ftype, kfs=true, nb=true, ofs=3, x2=1}
	self:skinButton{obj=_G.OrderHallTalentFrameCloseButton, cb=true}
	_G.OrderHallTalentFrame.CurrencyIcon:SetAlpha(1) -- show currency icon
	for i = 1, #_G.OrderHallTalentFrame.FrameTick do
		_G.OrderHallTalentFrame.FrameTick[i]:SetTextColor(self.BTr, self.BTg, self.BTb)
	end
	self:SecureHook(_G.OrderHallTalentFrame, "RefreshAllData", function(this)
		for choiceTex in this.choiceTexturePool:EnumerateActive() do
			choiceTex:SetAlpha(0)
		end
	end)

	-- CommandBar at top of screen
	_G.OrderHallCommandBar:DisableDrawLayer("BACKGROUND")
	self:addSkinFrame{obj=_G.OrderHallCommandBar, ft=ftype, ofs=4, y2=-2}

	-- OrderHallMissionTutorialFrame
	self:skinButton{obj=_G.OrderHallMissionTutorialFrame.GlowBox.CloseButton, cb=true}

end

aObj.pbtt = {}
aObj.blizzFrames[ftype].PetBattleUI = function(self)
	if not self.db.profile.PetBattleUI or self.initialized.PetBattleUI then return end
	self.initialized.PetBattleUI = true

	-- Top Frame
	_G.PetBattleFrame.TopArtLeft:SetTexture(nil)
	_G.PetBattleFrame.TopArtRight:SetTexture(nil)
	_G.PetBattleFrame.TopVersus:SetTexture(nil)
	-- Active Allies/Enemies
	local nTab, pbf, sfn, xOfs = {"Ally", "Enemy"}
	for i = 1, #nTab do
		pbf = _G.PetBattleFrame["Active" .. nTab[i]]
		self:addButtonBorder{obj=pbf, relTo=pbf.Icon, ofs=1, reParent={pbf.LevelUnderlay, pbf.Level, pbf.SpeedUnderlay, pbf.SpeedIcon}}
		pbf.Border:SetTexture(nil)
		pbf.Border2:SetTexture(nil)
		if self.modBtnBs then
			pbf.sbb:SetBackdropBorderColor(pbf.Border:GetVertexColor())
			self:SecureHook(pbf.Border, "SetVertexColor", function(this, ...)
				this:GetParent().sbb:SetBackdropBorderColor(...)
			end)
		end
		self:changeTandC(pbf.LevelUnderlay, self.lvlBG)
		self:changeTandC(pbf.SpeedUnderlay, self.lvlBG)
		self:changeTandC(pbf.HealthBarBG, self.sbTexture)
		pbf.HealthBarBG:SetVertexColor(0.2, 0.2, 0.2, 0.8) -- black
		self:adjWidth{obj=pbf.HealthBarBG, adj=-10}
		self:adjHeight{obj=pbf.HealthBarBG, adj=-10}
		self:changeTandC(pbf.ActualHealthBar, self.sbTexture)
		pbf.ActualHealthBar:SetVertexColor(0, 1, 0) -- green
		self:moveObject{obj=pbf.ActualHealthBar, x=nTab[i] == "Ally" and -5 or 5}
		pbf.HealthBarFrame:SetTexture(nil)
		-- add a background frame
		sfn = nTab[i] == "Ally" and "sfl" or "sfr"
		_G.PetBattleFrame[sfn] = _G.CreateFrame("Frame", nil, _G.PetBattleFrame)
		_G.PetBattleFrame[sfn]:SetFrameStrata("BACKGROUND")
		self:applySkin{obj=_G.PetBattleFrame[sfn], bba=0, fh=45}
		_G.PetBattleFrame[sfn]:SetSize(335, 92)
		xOfs = 405
		if nTab[i] == "Ally" then
			_G.PetBattleFrame.sfl:SetPoint("TOPLEFT", _G.PetBattleFrame, "TOPLEFT", xOfs, 4)
		else
			_G.PetBattleFrame.sfr:SetPoint("TOPRIGHT", _G.PetBattleFrame, "TOPRIGHT", xOfs * -1, 4)
		end
		-- Ally2/3, Enemy2/3
		local btn
		for j = 2, 3 do
			btn = _G.PetBattleFrame[nTab[i] .. j]
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
		btn = nil
	end
	nTab, pbf, sfn, xOfs= nil, nil, nil, nil

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
	local btn
	for i = 1, _G.NUM_BATTLE_PETS_IN_BATTLE do
		btn = _G.PetBattleFrame.BottomFrame.PetSelectionFrame["Pet" .. i]
		btn.Framing:SetTexture(nil)
		btn.HealthBarBG:SetTexture(self.sbTexture)
		btn.HealthBarBG:SetVertexColor(0.2, 0.2, 0.2, 0.8) -- dark grey
		btn.ActualHealthBar:SetTexture(self.sbTexture)
		btn.HealthDivider:SetTexture(nil)
	end
	btn = nil
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
			local btn
			for i = 1, _G.NUM_BATTLE_PET_ABILITIES do
				btn = this.BottomFrame.abilityButtons[i]
				self:addButtonBorder{obj=btn, reParent={btn.BetterIcon}}
			end
			btn = nil
			self:Unhook("PetBattleFrame_UpdateActionBarLayout")
		end)
		self:SecureHook("PetBattleActionButton_UpdateState", function(this)
			if this.sbb then
				if this.Icon
				and this.Icon:IsDesaturated()
				then
					this.sbb:SetBackdropBorderColor(.5, .5, .5)
				else
					this.sbb:SetBackdropBorderColor(self.bbColour[1], self.bbColour[2], self.bbColour[3], self.bbColour[4])
				end
			end
		end)
	end

	-- Tooltip frames
	if self.db.profile.Tooltips.skin then
		-- hook these to stop tooltip gradient being whiteouted !!
		local function reParent(opts)
			local ttsf
			for i = 1, #aObj.pbtt do
				ttsf = aObj.pbtt[i]
				ttsf.tfade:SetParent(opts.parent or ttsf)
	 			if opts.reset then
					-- reset Gradient alpha
					ttsf.tfade:SetGradientAlpha(aObj:getGradientInfo())
				end
			end
			ttsf = nil
 		end
		local pbfaasf = _G.PetBattleFrame.ActiveAlly.SpeedFlash
		self:HookScript(pbfaasf, "OnPlay", function(this)
			reParent{parent=_G.MainMenuBar}
		end, true)
		self:SecureHookScript(pbfaasf, "OnFinished", function(this)
			reParent{reset=true}
		end)
		local pbfaesf = _G.PetBattleFrame.ActiveEnemy.SpeedFlash
		self:HookScript(pbfaesf, "OnPlay", function(this)
			reParent{parent=_G.MainMenuBar}
		end, true)
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
		-- skin the tooltips
		local nTab, tt = {"PetBattlePrimaryUnit", "PetBattlePrimaryAbility", "FloatingBattlePet", "FloatingPetBattleAbility", "BattlePet"}
		for i = 1, #nTab do
			tt = _G[nTab[i] .. "Tooltip"]
			if tt.Delimiter then tt.Delimiter:SetTexture(nil) end
			if tt.Delimiter1 then tt.Delimiter1:SetTexture(nil) end
			if tt.Delimiter2 then tt.Delimiter2:SetTexture(nil) end
			if not nTab[i] == "BattlePet" then tt:DisableDrawLayer("BACKGROUND") end
			self:addSkinFrame{obj=tt, ft=ftype}
		end
		nTab, tt = nil, nil
		_G.PetBattlePrimaryUnitTooltip.ActualHealthBar:SetTexture(self.sbTexture)
		_G.PetBattlePrimaryUnitTooltip.XPBar:SetTexture(self.sbTexture)
		self:add2Table(self.pbtt, _G.PetBattlePrimaryUnitTooltip.sf)
	end

end

aObj.blizzFrames[ftype].PVEFrame = function(self)
	if not self.db.profile.PVEFrame or self.initialized.PVEFrame then return end
	self.initialized.PVEFrame = true

	self:removeInset(_G.PVEFrame.Inset)
	self:keepFontStrings(_G.PVEFrame.shadows)
	self:skinButton{obj=_G.PVEFrameCloseButton, cb=true}
	-- N.B. don't skin any buttons here
	self:addSkinFrame{obj=_G.PVEFrame, ft=ftype, kfs=true, ri=true, nb=true, x1=-3, y1=2, x2=1, y2=-5}
	self:skinTabs{obj=_G.PVEFrame}

	-- GroupFinder Frame
	local btn
	for i = 1, 4 do
		btn = _G.GroupFinderFrame["groupButton" .. i]
		btn.bg:SetTexture(nil)
		btn.ring:SetTexture(nil)
		self:changeRecTex(btn:GetHighlightTexture())
	end
	btn = nil
	-- hook this to change selected texture
	self:SecureHook("GroupFinderFrame_SelectGroupButton", function(index)
		local btn
		for i = 1, 4 do
			btn = _G.GroupFinderFrame["groupButton" .. i]
			if i == index then
				self:changeRecTex(btn.bg, true)
			else
				btn.bg:SetTexture(nil)
			end
		end
		btn = nil
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
	self:removeMagicBtnTex(cs.FindGroupButton)
	self:skinButton{obj=cs.FindGroupButton}
	self:removeMagicBtnTex(cs.StartGroupButton)
	self:skinButton{obj=cs.StartGroupButton}
	-- NothingAvailable
	self:removeInset(_G.LFGListFrame.NothingAvailable.Inset)
	-- SearchPanel
	local sp = _G.LFGListFrame.SearchPanel
	self:skinEditBox{obj=sp.SearchBox, regs={6, 7}, mi=true} -- 6 is text, 7 is icon
    self:addButtonBorder{obj=sp.FilterButton, ofs=0}
	self:addSkinFrame{obj=sp.AutoCompleteFrame, ft=ftype, kfs=true, nb=true, x1=4, y1=4, y2=4}
	self:addButtonBorder{obj=sp.RefreshButton, ofs=-2}
	self:removeInset(sp.ResultsInset)
	self:skinButton{obj=sp.ScrollFrame.StartGroupButton, as=true} -- use as otherwise button skin not visible
	self:skinSlider{obj=sp.ScrollFrame.scrollBar, wdth=-4}
	for i = 1, #sp.ScrollFrame.buttons do
		self:skinButton{obj=sp.ScrollFrame.buttons[i].CancelButton}
	end
	self:removeMagicBtnTex(sp.BackButton)
	self:skinButton{obj=sp.BackButton}
	self:removeMagicBtnTex(sp.SignUpButton)
	self:skinButton{obj=sp.SignUpButton}
	-- ApplicationViewer
	local av = _G.LFGListFrame.ApplicationViewer
	av:DisableDrawLayer("BACKGROUND")
	self:removeInset(av.Inset)
	for _, v in pairs{"Name", "Role", "ItemLevel"} do
		btn = av[v .. "ColumnHeader"]
		self:removeRegions(btn, {1, 2, 3})
		self:skinButton{obj=btn}
	end
	self:addButtonBorder{obj=av.RefreshButton, ofs=-2}
	self:skinSlider{obj=av.ScrollFrame.scrollBar, wdth=-4}
	for i = 1, #av.ScrollFrame.buttons do
		btn = av.ScrollFrame.buttons[i]
		self:skinButton{obj=btn.DeclineButton}
		self:skinButton{obj=btn.InviteButton}
	end
	self:removeMagicBtnTex(av.RemoveEntryButton)
	self:skinButton{obj=av.RemoveEntryButton}
	self:removeMagicBtnTex(av.EditButton)
	self:skinButton{obj=av.EditButton}
	-- EntryCreation
	local ec = _G.LFGListFrame.EntryCreation
	self:removeInset(ec.Inset)
	local ecafd = ec.ActivityFinder.Dialog
	self:skinEditBox{obj=ecafd.EntryBox, regs={6}, mi=true} -- 6 is text
	self:skinSlider{obj=ecafd.ScrollFrame.scrollBar, size=4}
	ecafd.BorderFrame:DisableDrawLayer("BACKGROUND")
	self:addSkinFrame{obj=ecafd, ft=ftype, kfs=true}
	self:skinEditBox{obj=ec.Name, regs={6}, mi=true} -- 6 is text
	self:skinDropDown{obj=ec.CategoryDropDown}
	self:skinDropDown{obj=ec.GroupDropDown}
	self:skinDropDown{obj=ec.ActivityDropDown}
	self:skinEditBox{obj=ec.ItemLevel.EditBox, regs={6}, mi=true} -- 6 is text
	self:skinEditBox{obj=ec.VoiceChat.EditBox, regs={6}, mi=true} -- 6 is text
	self:addSkinFrame{obj=ec.Description, ft=ftype, kfs=true, ofs=6}
	self:removeMagicBtnTex(ec.ListGroupButton)
	self:skinButton{obj=ec.ListGroupButton}
	self:removeMagicBtnTex(ec.CancelButton)
	self:skinButton{obj=ec.CancelButton}

	-- LFGListApplication Dialog
	self:skinSlider{obj=_G.LFGListApplicationDialog.Description.ScrollBar, wdth=-4}
	self:addSkinFrame{obj=_G.LFGListApplicationDialog.Description, ft=ftype, kfs=true, ofs=6}
	_G.LFGListApplicationDialog.Description.EditBox.Instructions:SetTextColor(self.BTr, self.BTg, self.BTb)
	self:addSkinFrame{obj=_G.LFGListApplicationDialog, ft=ftype, kfs=true}
	-- LFGListInvite Dialog
	self:addSkinFrame{obj=_G.LFGListInviteDialog, ft=ftype}

	-- ScenarioFinder Frame
	self:keepFontStrings(_G.ScenarioFinderFrame)
	self:RaiseFrameLevelByFour(_G.ScenarioFinderFrame.NoScenariosCover) -- cover buttons and dropdown
	self:removeInset(_G.ScenarioFinderFrame.Inset)

	-- ScenarioQueueFrame
	_G.ScenarioQueueFrame.Bg:SetAlpha(0) -- N.B. texture changed in code
	self:skinDropDown{obj=_G.ScenarioQueueFrame.Dropdown}
	self:skinSlider{obj=_G.ScenarioQueueFrame.Random.ScrollFrame.ScrollBar, rt={"background", "artwork"}}
	local btnName
	for i = 1, _G.ScenarioQueueFrame.Random.ScrollFrame.Child.numRewardFrames do
		btnName = "ScenarioQueueFrameRandomScrollFrameChildFrameItem" .. i
		if _G[btnName] then
			_G[btnName .. "NameFrame"]:SetTexture(nil)
			self:addButtonBorder{obj=_G[btnName], libt=true}
		end
	end
	btnName = nil
	self:skinButton{obj=_G.ScenarioQueueFrame.Random.ScrollFrame.Child.bonusRepFrame.ChooseButton, as=true}
	self:addButtonBorder{obj=_G.ScenarioQueueFrame.Random.ScrollFrame.Child.MoneyReward, libt=true}
	_G.ScenarioQueueFrame.Random.ScrollFrame.Child.MoneyReward.NameFrame:SetTexture(nil)

	self:skinButton{obj=_G.ScenarioQueueFrameSpecificButton1ExpandOrCollapseButton, mp2=true}
	self:moveObject{obj=_G.ScenarioQueueFrameSpecificButton1ExpandOrCollapseButtonHighlight, x=-3} -- move highlight to the left
	self:skinSlider{obj=_G.ScenarioQueueFrame.Specific.ScrollFrame.ScrollBar, rt="background"}
	self:keepFontStrings(_G.ScenarioQueueFramePartyBackfill)

end

aObj.blizzFrames[ftype].PVPHelper = function(self)

	-- PVPFramePopup
	_G.PVPFramePopup:DisableDrawLayer("BORDER")
	_G.PVPFramePopupRing:SetTexture(nil)
	self:addSkinFrame{obj=_G.PVPFramePopup, ft=ftype}
	-- PVPRoleCheckPopup
	self:addSkinFrame{obj=_G.PVPRoleCheckPopup, ft=ftype}
	-- PVPReadyDialog
	_G.PVPReadyDialog.instanceInfo.underline:SetAlpha(0)
	self:addSkinFrame{obj=_G.PVPReadyDialog, ft=ftype, kfs=true}

end

aObj.blizzFrames[ftype].QuestMap = function(self)
	if IsAddOnLoaded("EQL3") then
		aObj.blizzFrames[ftype].QuestMap = nil
		return
	end

	if not self.db.profile.QuestMap or self.initialized.QuestMap then return end
	self.initialized.QuestMap = true

	-- Quest Log Popup Detail Frame
	local qlpdf = _G.QuestLogPopupDetailFrame
	self:skinSlider{obj=qlpdf.ScrollFrame.ScrollBar, rt="artwork"}
	self:addButtonBorder{obj=qlpdf.ShowMapButton, relTo=qlpdf.ShowMapButton.Texture, x1=2, y1=-1, x2=-2, y2=1}
	self:addSkinFrame{obj=qlpdf, ft=ftype, kfs=true, ri=true, ofs=2}
	qlpdf = nil

	-- Quest Map Frame
	_G.QuestMapFrame.VerticalSeparator:SetTexture(nil)
	self:skinDropDown{obj=_G.QuestMapQuestOptionsDropDown}
	_G.QuestMapFrame.QuestsFrame:DisableDrawLayer("BACKGROUND")
	_G.QuestMapFrame.QuestsFrame.Contents.StoryHeader:DisableDrawLayer("BACKGROUND")
	_G.QuestMapFrame.QuestsFrame.Contents.StoryHeader.Shadow:SetTexture(nil)
	self:skinSlider{obj=_G.QuestMapFrame.QuestsFrame.ScrollBar}
	self:addSkinFrame{obj=_G.QuestMapFrame.QuestsFrame.StoryTooltip, ft=ftype}

	-- Details Frame
	self:keepFontStrings(_G.QuestMapFrame.DetailsFrame)
	self:skinButton{obj=_G.QuestMapFrame.DetailsFrame.BackButton}
	self:keepFontStrings(_G.QuestMapFrame.DetailsFrame.RewardsFrame)
	self:getRegion(_G.QuestMapFrame.DetailsFrame.RewardsFrame, 3):SetTextColor(self.HTr, self.HTg, self.HTb)
	self:skinSlider{obj=_G.QuestMapFrame.DetailsFrame.ScrollFrame.ScrollBar, wdth=-4}
	_G.QuestMapFrame.DetailsFrame.CompleteQuestFrame:DisableDrawLayer("BACKGROUND")
	_G.QuestMapFrame.DetailsFrame.CompleteQuestFrame:DisableDrawLayer("ARTWORK")
	_G.QuestMapFrame.DetailsFrame.CompleteQuestFrame.CompleteButton:DisableDrawLayer("BORDER")
	self:skinButton{obj=_G.QuestMapFrame.DetailsFrame.AbandonButton}
	self:moveObject{obj=_G.QuestMapFrame.DetailsFrame.AbandonButton, y=2}
	self:skinButton{obj=_G.QuestMapFrame.DetailsFrame.ShareButton}
	self:removeRegions(_G.QuestMapFrame.DetailsFrame.ShareButton, {6, 7}) -- divider textures
	self:skinButton{obj=_G.QuestMapFrame.DetailsFrame.TrackButton}

	-- skin header buttons, if required
	if self.modBtns then
		-- hook this to skin Quest Header button
		self:SecureHook("QuestLogQuests_Update", function(...)
			local btn, tex
			for i = 1, #_G.QuestMapFrame.QuestsFrame.Contents.Headers do
				btn = _G.QuestMapFrame.QuestsFrame.Contents.Headers[i]
				tex = btn:GetNormalTexture() and btn:GetNormalTexture():GetTexture()
				if tex
				and (tex:find("MinusButton")
				or tex:find("PlusButton"))
				and not btn.sb
				then
					self:skinButton{obj=btn, mp=true}
				end
				self:checkTex(btn)
			end
			btn, tex = nil, nil
		end)
	end

	-- QuestInfo
	self:checkAndRun("QuestInfo", "n")

end

aObj.blizzFrames[ftype].QueueStatusFrame = function(self)
	if not self.db.profile.QueueStatusFrame or self.initialized.QueueStatusFrame then return end
	self.initialized.QueueStatusFrame = true

	_G.QueueStatusFrame:DisableDrawLayer("BACKGROUND")
	self:addSkinFrame{obj=_G.QueueStatusFrame, anim=IsAddOnLoaded("SexyMap") and true or nil}
	-- handle SexyMap's use of AnimationGroups to show and hide frames
	if IsAddOnLoaded("SexyMap") then
		local rtEvt
		local function checkForAnimGrp()
			if _G.QueueStatusMinimapButton.smAlphaAnim then
				rtEvt:Cancel()
				-- aObj:CancelTimer(rtEvt, true)
				rtEvt = nil
				aObj:SecureHookScript(_G.QueueStatusMinimapButton.smAnimGroup, "OnFinished", function(this)
					_G.QueueStatusFrame.sf:Hide()
				end)
			end
		end
		rtEvt = _G.C_Timer.NewTicker(0.2, function() checkForAnimGrp() end)
	end

end

aObj.blizzFrames[ftype].RaidFrame = function(self)
	if not self.db.profile.RaidFrame or self.initialized.RaidFrame then return end
	self.initialized.RaidFrame = true

	self:skinTabs{obj=_G.RaidParentFrame, lod=true}
	self:addSkinFrame{obj=_G.RaidParentFrame, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-5}

-->>-- RaidFinder Frame
	_G.RaidFinderFrame:DisableDrawLayer("BACKGROUND")
	_G.RaidFinderFrame:DisableDrawLayer("BORDER")
	self:RaiseFrameLevelByFour(_G.RaidFinderFrame.NoRaidsCover) -- cover buttons and dropdown
	self:removeInset(_G.RaidFinderFrameRoleInset)
	self:removeInset(_G.RaidFinderFrameBottomInset)
	self:addButtonBorder{obj=_G.RaidFinderQueueFrameScrollFrameChildFrameItem1, libt=true}
	_G.RaidFinderQueueFrameScrollFrameChildFrameItem1NameFrame:SetTexture(nil)
	self:addButtonBorder{obj=_G.RaidFinderQueueFrameScrollFrameChildFrame.MoneyReward, libt=true}
	_G.RaidFinderQueueFrameScrollFrameChildFrame.MoneyReward.NameFrame:SetTexture(nil)
	self:removeMagicBtnTex(_G.RaidFinderFrameFindRaidButton)
	self:skinButton{obj=_G.RaidFinderFrameFindRaidButton}

	-- TODO texture is present behind frame
	_G.RaidFinderQueueFrameBackground:SetTexture(nil)
	_G.RaidFinderQueueFrameBackground.SetTexture = _G.nop
	skinCheckBtns("RaidFinder")
	self:skinDropDown{obj=_G.RaidFinderQueueFrameSelectionDropDown}
	self:skinSlider{obj=_G.RaidFinderQueueFrameScrollFrame.ScrollBar, rt={"background", "artwork"}}

end

aObj.blizzFrames[ftype].SecureTransferUI = function(self)
	if not self.db.profile.SecureTransferUI or self.initialized.SecureTransferUI then return end
	self.initialized.SecureTransferUI = true

	-- disable skinning of this frame
	self.db.profile.SecureTransferUI = false

	-->> N.B. Currently can't be skinned, as the XML has a ScopedModifier element saying forbidden="true"

end

aObj.blizzFrames[ftype].SharedBasicControls = function(self)
	if not self.db.profile.ScriptErrors or self.initialized.ScriptErrors then return end
	self.initialized.ScriptErrors = true

	self:addSkinFrame{obj=_G.BasicMessageDialog, ft=ftype, kfs=true}

	-- ScriptErrorsFrame
	self:skinSlider{obj=_G.ScriptErrorsFrame.ScrollFrame.ScrollBar}
	self:addButtonBorder{obj=_G.ScriptErrorsFrame.PreviousError, ofs=-3, x1=2}
	self:addButtonBorder{obj=_G.ScriptErrorsFrame.NextError, ofs=-3, x1=2}
	self:addSkinFrame{obj=_G.ScriptErrorsFrame, ft=ftype, kfs=true, x1=1, y1=-2, x2=-1, y2=4}

end

aObj.blizzFrames[ftype].SplashFrame = function(self)
	if not self.db.profile.SplashFrame or self.initialized.SplashFrame then return end
	self.initialized.SplashFrame = true

	_G.SplashFrame.Label:SetTextColor(self.HTr, self.HTg, self.HTb)
	_G.SplashFrame.StartButton:DisableDrawLayer("BACKGROUND")
	self:skinButton{obj=_G.SplashFrame.StartButton}
	self:addSkinFrame{obj=_G.SplashFrame, ft=ftype, kfs=true}

end

aObj.blizzFrames[ftype].StaticPopups = function(self)
	if not self.db.profile.StaticPopups or self.initialized.StaticPopups then return end
	self.initialized.StaticPopups = true

	if self.modBtns then
		-- hook this to handle close button texture changes
		self:SecureHook("StaticPopup_Show", function(...)
			local obj
			for i = 1, _G.STATICPOPUP_NUMDIALOGS do
				obj = _G["StaticPopup" .. i .. "CloseButton"]
				if aObj:hasTextInTexture(obj:GetNormalTexture(), "HideButton") then
					obj:SetText(self.modUIBtns.minus)
				elseif aObj:hasTextInTexture(obj:GetNormalTexture(), "MinimizeButton") then
					obj:SetText(self.modUIBtns.mult)
				end
			end
		end)
	end

	local objName, obj
	for i = 1, _G.STATICPOPUP_NUMDIALOGS do
		objName = "StaticPopup" .. i
		obj = _G[objName]
		self:skinEditBox{obj=_G[objName .. "EditBox"]}
		self:skinMoneyFrame{obj=_G[objName .. "MoneyInputFrame"]}
		_G[objName .. "ItemFrameNameFrame"]:SetTexture(nil)
		self:addButtonBorder{obj=_G[objName .. "ItemFrame"], ibt=true}
		self:addSkinFrame{obj=obj, ft=ftype, x1=6, y1=-6, x2=-6, y2=6}
		-- prevent FrameLevel from being changed (LibRock does this)
		obj.sf.SetFrameLevel = _G.nop
	end
	objName, obj = nil, nil

end

aObj.blizzLoDFrames[ftype].SocialUI = function(self)
	if not self.db.profile.SocialUI or self.initialized.SocialUI then return end
	self.initialized.SocialUI = true

	-- disable skinning of this frame
	self.db.profile.SocialUI = false

	-->> N.B. Currently can't be skinned, as the XML has a ScopedModifier element saying forbidden="true"

end

aObj.blizzLoDFrames[ftype].StoreUI = function(self)
	if not self.db.profile.StoreUI or self.initialized.StoreUI then return end
	self.initialized.StoreUI = true

	-- disable skinning of this frame
	self.db.profile.StoreUI = false

	-->> N.B. Currently can't be skinned, as the XML has a ScopedModifier element saying forbidden="true"

end

aObj.blizzLoDFrames[ftype].TalkingHeadUI = function(self)
	if not self.db.profile.TalkingHeadUI or self.initialized.TalkingHeadUI then return end
	self.initialized.TalkingHeadUI = true

	-- skin frame
	_G.TalkingHeadFrame.BackgroundFrame.TextBackground:SetTexture(nil)
	_G.TalkingHeadFrame.PortraitFrame.Portrait:SetTexture(nil)
	_G.TalkingHeadFrame.MainFrame.Model.PortraitBg:SetTexture(nil)
	self:addSkinFrame{obj=_G.TalkingHeadFrame, ft=ftype, nb=true, aso={bd=11, ng=true}, ofs=-15, y2=14}
	_G.TalkingHeadFrame.sf:SetBackdropColor(.1, .1, .1, .75) -- use dark background

	-- TODO skin the close button properly, currently the textures have been removed so it is not displayed
	_G.TalkingHeadFrame.MainFrame.CloseButton:GetNormalTexture():SetTexture(nil)
	_G.TalkingHeadFrame.MainFrame.CloseButton:GetPushedTexture():SetTexture(nil)
	_G.TalkingHeadFrame.MainFrame.CloseButton:GetDisabledTexture():SetTexture(nil)
	_G.TalkingHeadFrame.MainFrame.CloseButton:GetHighlightTexture():SetTexture(nil)

end

aObj.blizzFrames[ftype].TimeManager = function(self)
	if not self.db.profile.TimeManager or self.initialized.TimeManager then return end
	self.initialized.TimeManager = true

	-- Time Manager Frame
	_G.TimeManagerFrameTicker:Hide()
	self:keepFontStrings(_G.TimeManagerStopwatchFrame)
	self:addButtonBorder{obj=_G.TimeManagerStopwatchCheck}
	self:skinDropDown{obj=_G.TimeManagerAlarmHourDropDown, x2=-5}
	self:skinDropDown{obj=_G.TimeManagerAlarmMinuteDropDown, x2=-5}
	self:skinDropDown{obj=_G.TimeManagerAlarmAMPMDropDown, x2=-5}
	self:skinEditBox{obj=_G.TimeManagerAlarmMessageEditBox, regs={6}}
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

aObj.blizzFrames[ftype].Tooltips = function(self)
	if not self.db.profile.Tooltips.skin or self.initialized.Tooltips then return end
	self.initialized.Tooltips = true

	-- skin Item Ref Tooltip's close button and move it
	self:skinButton{obj=_G.ItemRefCloseButton, cb=true}
	self:moveObject{obj=_G.ItemRefCloseButton, x=2, y=2}

	if IsAddOnLoaded("TipTac")
	or IsAddOnLoaded("TinyTooltip")
	then
		return
	end

	-- this addon colours the Tooltip Border
	if IsAddOnLoaded("Chippu") then
		self.ttBorder = false
	end

	-- add tooltips to table to set backdrop and hook OnShow method
	for i = 1, #self.ttCheck do
		self:add2Table(self.ttList, self.ttCheck[i])
	end

	-- Hook this to skin the GameTooltip StatusBars
	self:SecureHook("GameTooltip_ShowStatusBar", function(this, ...)
		local sb
		for i = 1, this.numStatusBars do
			sb = _G[this:GetName() .. "StatusBar" .. i]
			self:removeRegions(sb, {2})
			if self.db.profile.Tooltips.glazesb then
				self:glazeStatusBar(sb, 0)
			end
		end
		sb = nil
	end)

end

aObj.blizzFrames[ftype].Tutorial = function(self)
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
	self:skinSlider{obj=_G.TutorialFrameTextScrollFrame.ScrollBar}
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

aObj.blizzFrames[ftype].UIDropDownMenu = function(self)
	if not self.db.profile.DropDownPanels or self.initialized.DropDownPanels then return end
	self.initialized.DropDownPanels = true

	local frame
	for i = 1, _G.UIDROPDOWNMENU_MAXLEVELS do
		frame = _G["DropDownList" .. i]
		self:addSkinFrame{obj=frame, ft=ftype, kfs=true}
		_G[frame:GetName() .. "Backdrop"]:SetBackdrop(nil)
		_G[frame:GetName() .. "MenuBackdrop"]:SetBackdrop(nil)
	end
	frame = nil

--@debug@
	self:SecureHook("UIDropDownMenu_CreateFrames", function(level, index)
		if _G.UIDROPDOWNMENU_MAXLEVELS > 2 then
			_G.DEFAULT_CHAT_FRAME:AddMessage("UIDropDownMenus > 2" .. "[" .. level .. "][" .. index .. "]", 1, 0, 0, nil, true)
		end
	end)
--@end-debug@



end

aObj.blizzFrames[ftype].WorldMap = function(self)
	if not self.db.profile.WorldMap.skin or self.initialized.WorldMap then return end
	self.initialized.WorldMap = true

	if not IsAddOnLoaded("Mapster")
	and not IsAddOnLoaded("AlleyMap")
	then
		local function sizeUp()

			_G.WorldMapFrame.sf:ClearAllPoints()
			_G.WorldMapFrame.sf:SetPoint("TOPLEFT", _G.WorldMapFrame, "TOPLEFT", 101, 1)
			_G.WorldMapFrame.sf:SetPoint("BOTTOMRIGHT", _G.WorldMapFrame, "BOTTOMRIGHT", -101, 1)

		end
		local function sizeDown()

			_G.WorldMapFrame.sf:ClearAllPoints()
			_G.WorldMapFrame.sf:SetPoint("TOPLEFT", _G.WorldMapFrame, "TOPLEFT", 0, 1)
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
			self:addSkinFrame{obj=_G.WorldMapFrame, ft=ftype, kfs=true, bgen=1, y1=1, x2=1}
		elseif not IsAddOnLoaded("MetaMap")
		and not IsAddOnLoaded("Cartographer_LookNFeel")
		then
			self:addSkinFrame{obj=_G.WorldMapFrame, ft=ftype, kfs=true, bgen=1}
			if _G.WORLDMAP_SETTINGS.size == _G.WORLDMAP_WINDOWED_SIZE then
				sizeDown()
			else
				sizeUp()
			end
		end
	end

	self:keepFontStrings(_G.WorldMapFrame.BorderFrame)
	self:removeInset(_G.WorldMapFrame.BorderFrame.Inset)
	if not self.isPTR then
		self:skinButton{obj=_G.WorldMapFrameSizeDownButton, ob3="↕"} -- up-down arrow
		self:skinButton{obj=_G.WorldMapFrameSizeUpButton, ob3="↕"} -- up-down arrow
	else
		self:skinMaxMinFrame(_G.WorldMapFrame.BorderFrame, 3)
	end
	_G.WorldMapFrame.MainHelpButton.Ring:SetTexture(nil)
	self:skinDropDown{obj=_G.WorldMapTitleDropDown}
	self:skinDropDown{obj=_G.WorldMapLevelDropDown}
	-- UIElementsFrame
	local uie = _G.WorldMapFrame.UIElementsFrame
	self:skinDropDown{obj=uie.TrackingOptionsButton.DropDown}
	uie.TrackingOptionsButton.Button.Border:SetTexture(nil)
	self:skinButton{obj=uie.TrackingOptionsButton.Button, y2=3}
	if uie.TrackingOptionsButton.Button.sb then
		_G.LowerFrameLevel(_G.WorldMapFrame.UIElementsFrame.TrackingOptionsButton.Button.sb)
	end
	self:addButtonBorder{obj=uie.OpenQuestPanelButton}
	self:addButtonBorder{obj=uie.CloseQuestPanelButton}
	-- BountyBoard
	uie.BountyBoard:DisableDrawLayer("BACKGROUND")
	self:skinButton{obj=uie.BountyBoard.TutorialBox.CloseButton, cb=true}
	self:SecureHook(uie.BountyBoard, "RefreshBountyTabs", function(this)
		for tab in this.bountyTabPool:EnumerateActive() do
			if tab.objectiveCompletedBackground then
				tab.objectiveCompletedBackground:SetTexture(nil)
			end
		end
	end)
	uie = nil

	-- Nav Bar
	_G.WorldMapFrame.NavBar:DisableDrawLayer("BACKGROUND")
	_G.WorldMapFrame.NavBar:DisableDrawLayer("BORDER")
	_G.WorldMapFrame.NavBar.overlay:DisableDrawLayer("OVERLAY")
	_G.WorldMapFrame.NavBar.home:DisableDrawLayer("OVERLAY")
	_G.WorldMapFrame.NavBar.home:GetNormalTexture():SetAlpha(0)
	_G.WorldMapFrame.NavBar.home:GetPushedTexture():SetAlpha(0)
	_G.WorldMapFrame.NavBar.home.text:SetPoint("RIGHT", -20, 0)

	-- Tooltip(s)
	if self.db.profile.Tooltips.skin then
		self:add2Table(self.ttList, _G.WorldMapTooltip)
		self:add2Table(self.ttList, "WorldMapCompareTooltip1")
		self:add2Table(self.ttList, "WorldMapCompareTooltip2")
	end
	self:addButtonBorder{obj=_G.WorldMapTooltip.ItemTooltip, relTo=_G.WorldMapTooltip.ItemTooltip.Icon, reParent={_G.WorldMapTooltip.ItemTooltip.Count}}
	self:removeRegions(_G.WorldMapTaskTooltipStatusBar.Bar, {1, 2, 3, 4, 5}) -- 6 is text
	self:glazeStatusBar(_G.WorldMapTaskTooltipStatusBar.Bar, 0, self:getRegion(_G.WorldMapTaskTooltipStatusBar.Bar, 7))

	-- BarFrame
	self:removeRegions(_G.MapBarFrame, {1, 2, 3})
	self:glazeStatusBar(_G.MapBarFrame, 0, _G.MapBarFrame.FillBG)

end

aObj.blizzFrames[ftype].WorldState = function(self)
	if not self.db.profile.WorldState or self.initialized.WorldState then return end
	self.initialized.WorldState = true

-->>-- CaptureBar(s)
	local nTab = {"texA", "texH"}
    local function skinCaptureBar(id)
        local bar = _G["WorldStateCaptureBar" .. id]
        aObj:removeRegions(bar, {4})
        -- create textures for Alliance/Horde icons
		for i = 1, #nTab do
            bar[nTab[i]] = bar:CreateTexture(nil, "artwork")
            bar[nTab[i]]:SetTexture[[Interface\WorldStateFrame\WorldState-CaptureBar]]
            bar[nTab[i]]:SetSize(27, 27)
        end
        bar.texA:SetTexCoord(0, 0.091, 0, 0.4)
        bar.texH:SetTexCoord(0.584, 0.675, 0, 0.4)
        bar.texA:SetPoint("RIGHT", bar, "LEFT", 26, 0)
        bar.texH:SetPoint("LEFT", bar, "RIGHT", -26, 0)
		bar = nil
    end
    self:SecureHook(_G.ExtendedUI["CAPTUREPOINT"], "create", function(id)
        skinCaptureBar(id)
    end)
    -- skin any existing frames
    for i = 1, _G.NUM_EXTENDED_UI_FRAMES do
        skinCaptureBar(i)
    end

-->>-- WorldStateScore frame
	local wssfxpb = _G.WorldStateScoreFrame.XPBar
	wssfxpb.Frame:SetTexture(nil)
	self:glazeStatusBar(wssfxpb.Bar, 0, wssfxpb.Bar.Background, nil, true)
	wssfxpb.Bar.OverlayFrame.Text:SetPoint("CENTER", 0, 0)
	wssfxpb.NextAvailable.Frame:SetTexture(nil)
	wssfxpb = nil
	self:skinSlider{obj=_G.WorldStateScoreScrollFrame.ScrollBar, rt="artwork"}
	self:skinTabs{obj=_G.WorldStateScoreFrame}
	self:addSkinFrame{obj=_G.WorldStateScoreFrame, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-5}

end

aObj.blizzFrames[ftype].WowTokenUI = function(self)
	if not self.db.profile.WowTokenUI or self.initialized.WowTokenUI then return end
	self.initialized.WowTokenUI = true

	-- disable skinning of this frame
	self.db.profile.WowTokenUI = false

	-->> N.B. Currently can't be skinned, as the XML has a ScopedModifier element saying forbidden="true"

end

aObj.blizzFrames[ftype].ZoneAbility = function(self)
	if not self.db.profile.ZoneAbility or self.initialized.ZoneAbility then return end
	self.initialized.ZoneAbility = true

	_G.ZoneAbilityFrame.SpellButton.Style:SetAlpha(0) -- texture is changed
	_G.ZoneAbilityFrame.SpellButton:SetNormalTexture(nil)
	self:addButtonBorder{obj=_G.ZoneAbilityFrame.SpellButton, ofs=2}

end
