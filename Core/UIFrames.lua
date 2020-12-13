local _, aObj = ...

local _G = _G

local ftype = "u"

-- The following functions are used by the GarrisonUI & OrderHallUI
local stageRegs, skinMissionFrame, skinPortrait, skinCovenantFollowerPortrait, skinFollower, skinFollowerListButtons, skinFollowerAbilitiesAndCounters, skinFollowerList, skinFollowerPage, skinFollowerTraitsAndEquipment, skinCompleteDialog, skinMissionPage, skinMissionComplete, skinMissionList

-- [WoD] LE_FOLLOWER_TYPE_GARRISON_6_0
-- [WoD] LE_FOLLOWER_TYPE_GARRISON_6_2 (Shipyards)
-- [Legion] LE_FOLLOWER_TYPE_GARRISON_7_0
-- [BfA] LE_FOLLOWER_TYPE_GARRISON_8_0
-- [Shadowlands] Enum.GarrisonType.Type_9_0
if _G.IsAddOnLoadOnDemand("Blizzard_GarrisonUI") then
	stageRegs = {1, 2, 3, 4, 5}
	local mfTabSkin = aObj.skinTPLs.new("tabs", {fType=ftype, ignoreSize=true, lod=true, ignoreHLTex=true, regions={7, 8, 9, 10}})
	function skinMissionFrame(frame)
		local x1Ofs, y1Ofs, y2Ofs = 2, 2, -5
		if frame == _G.CovenantMissionFrame then
			x1Ofs = -2
			y1Ofs = 1
			y2Ofs = -4
		elseif frame == _G.BFAMissionFrame then
			y1Ofs = 1
			y2Ofs = -6
		elseif frame == _G.OrderHallMissionFrame then
			y2Ofs = -4
		end
		frame.GarrCorners:DisableDrawLayer("BACKGROUND")
		aObj:skinObject("frame", {obj=frame, fType=ftype, kfs=true, cb=true, x1=x1Ofs, y1=y1Ofs, x2=1, y2=y2Ofs})
		x1Ofs, y1Ofs, y2Ofs = nil, nil, nil
		-- tabs
		mfTabSkin.obj = frame
		mfTabSkin.prefix =  frame:GetName()
		mfTabSkin.selectedTab = frame.selectedTab
		mfTabSkin.offsets = {x1=9, y1=2, x2=-9, y2=frame==_G.GarrisonMissionFrame and 0 or -4}
		aObj:skinObject(mfTabSkin)
	end
	function skinPortrait(frame)
		if frame.PuckBorder then
			-- FIXME: colour of PuckBorder changes for troops, is it important to show it?
			aObj:nilTexture(frame.PuckBorder, true)
			frame.PortraitRingQuality:SetTexture(nil)
			frame.PortraitRingCover:SetTexture(nil)
			aObj:changeTandC(frame.LevelCircle)
			frame.HealthBar.Health:SetTexture(aObj.sbTexture)
			frame.HealthBar.Border:SetTexture(nil)
		else
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
	end
	function skinFollower(frame)
		frame.BG:SetTexture(nil)
		if frame.AbilitiesBG then
			frame.AbilitiesBG:SetTexture(nil)
		end
		if frame.PortraitFrame then
			skinPortrait(frame.PortraitFrame)
		end
	end
	function skinFollowerListButtons(frame)
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
	-- Equipment buttons (OrderHallUI & BfA [Beta])
	local function skinEquipment(frame)
		for equipment in frame.equipmentPool:EnumerateActive() do
			equipment.BG:SetTexture(nil)
			equipment.Border:SetTexture(nil)
			aObj.modUIBtns:addButtonBorder{obj=equipment, ofs=1, relTo=equipment.Icon} -- use module function
		end
	end
	function skinFollowerAbilitiesAndCounters(frame)
		if aObj.modBtnBs then
			if frame.AbilitiesFrame.CombatAllySpell then
				-- CombatAllySpell buttons
				for i = 1, #frame.AbilitiesFrame.CombatAllySpell do
					aObj:addButtonBorder{obj=frame.AbilitiesFrame.CombatAllySpell[i], relTo=frame.AbilitiesFrame.CombatAllySpell[i].iconTexture}
				end
			end
			-- Ability buttons
			for ability in frame.abilitiesPool:EnumerateActive() do
				aObj:addButtonBorder{obj=ability.IconButton, reParent={ability.IconButton.Border}}
			end
			-- Counter buttons (Garrison Followers)
			for counters in frame.countersPool:EnumerateActive() do
				aObj:addButtonBorder{obj=counters, relTo=counters.Icon, reParent={counters.Border}}
			end
			-- hook to to handle new Abilities & Counters
			aObj:SecureHook(frame, "ShowAbilities", function(this, _)
				for ability in frame.abilitiesPool:EnumerateActive() do
					if not ability.IconButton.sbb then
						aObj:addButtonBorder{obj=ability.IconButton, reParent={ability.IconButton.Border}}
					end
				end
				for counters in frame.countersPool:EnumerateActive() do
					if not counters.sbb then
						aObj:addButtonBorder{obj=counters, relTo=counters.Icon, reParent={counters.Border}}
					end
				end
			end)

		end
		-- skin existing entries
		skinEquipment(frame)
		-- hook this to handle additional entries
		aObj:SecureHook(frame, "ShowEquipment", function(this, _)
			skinEquipment(this)
		end)
	end
	function skinFollowerList(frame)
		if frame.ElevatedFrame then
			frame.ElevatedFrame:DisableDrawLayer("OVERLAY")
			aObj:removeRegions(frame, {1})
			frame.listScroll.scrollBar:DisableDrawLayer("BACKGROUND")
		else
			frame:DisableDrawLayer("BORDER")
			aObj:removeRegions(frame, {1, 2, frame:GetParent() ~= _G.GarrisonLandingPage and 3 or nil})
			aObj:skinObject("slider", {obj=frame.listScroll.scrollBar, fType=ftype, y1=-2, y2=2})
		end
		if frame.FollowerScrollFrame then
			frame.FollowerScrollFrame:SetTexture(nil)
		end
		if frame.MaterialFrame then
			frame.MaterialFrame:DisableDrawLayer("BACKGROUND")
		end
		if frame.SearchBox then
			aObj:skinObject("editbox", {obj=frame.SearchBox, fType=ftype, si=true})
			-- need to do this as background isn't visible on Shipyard Mission page
			_G.RaiseFrameLevel(frame.SearchBox)
		end
		-- if FollowerList not yet populated, hook the function
		if not frame.listScroll.buttons then
			aObj:SecureHook(frame, "Initialize", function(this, _)
				skinFollowerListButtons(this)
				aObj:Unhook(this, "Initialize")
			end)
		else
			skinFollowerListButtons(frame)
		end
		if frame.followerTab
		and not frame:GetName():find("Ship") -- Shipyard & ShipFollowers
		then
			skinFollowerAbilitiesAndCounters(frame.followerTab)
		end
	end
	function skinFollowerPage(frame)
		if frame.PortraitFrame then
			skinPortrait(frame.PortraitFrame)
			aObj:addButtonBorder{obj=frame.ItemWeapon, relTo=frame.ItemWeapon.Icon}
			frame.ItemWeapon.Border:SetTexture(nil)
			aObj:addButtonBorder{obj=frame.ItemArmor, relTo=frame.ItemArmor.Icon}
			frame.ItemArmor.Border:SetTexture(nil)
		else
			skinPortrait(frame.CovenantFollowerPortraitFrame)
			if aObj.modBtnBs then
				for btn in frame.autoSpellPool:EnumerateActive() do
					btn.Border:SetTexture(nil)
					btn.SpellBorder:SetTexture(nil)
					aObj:addButtonBorder{obj=btn, relTo=btn.Icon}
				end
			end
		end
		aObj:skinStatusBar{obj=frame.XPBar, fi=0}
		frame.XPBar:DisableDrawLayer("OVERLAY")
	end
	function skinFollowerTraitsAndEquipment(frame)
		aObj:skinStatusBar{obj=frame.XPBar, fi=0}
		frame.XPBar:DisableDrawLayer("OVERLAY")
		for i = 1, #frame.Traits do
			frame.Traits[i].Border:SetTexture(nil)
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=frame.Traits[i], relTo=frame.Traits[i].Portrait, ofs=1}
			end
		end
		for i = 1, #frame.EquipmentFrame.Equipment do
			frame.EquipmentFrame.Equipment[i].BG:SetTexture(nil)
			frame.EquipmentFrame.Equipment[i].Border:SetTexture(nil)
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=frame.EquipmentFrame.Equipment[i], relTo=frame.EquipmentFrame.Equipment[i].Icon, ofs=1}
			end
		end
	end
	function skinCompleteDialog(frame, naval)
		if not naval then
			frame:ClearAllPoints()
			frame:SetPoint("TOPLEFT", -28, 42)
		else
			aObj:moveObject{obj=frame, x=4, y=20}
			_G.RaiseFrameLevelByTwo(frame) -- raise above markers on mission frame
		end
		frame:SetSize(naval and 935 or 948, _G.IsAddOnLoaded("GarrisonCommander") and 640 or naval and 648 or 630)
		-- frame.BorderFrame:DisableDrawLayer("BACKGROUND")
		-- frame.BorderFrame:DisableDrawLayer("BORDER")
		-- frame.BorderFrame:DisableDrawLayer("OVERLAY")
		aObj:removeRegions(frame.BorderFrame.Stage, {1, 2, 3, 4, 5, 6})
	    -- aObj:addSkinFrame{obj=frame.BorderFrame, ft=ftype, y2=-2}
		aObj:skinObject("frame", {obj=frame.BorderFrame, fType=ftype, kfs=true, y2=-2})
		if aObj.modBtns then
			aObj:skinStdButton{obj=frame.BorderFrame.ViewButton}
		end
	end
	function skinMissionPage(frame)
		frame.IconBG:SetTexture(nil)
		if frame.Board then -- shadowlands
			aObj:removeRegions(frame.Stage, {1})
		else
			aObj:removeRegions(frame.Stage, stageRegs)
		end
		frame.Stage.Header:SetAlpha(0)
		frame.Stage.MissionEnvIcon.Texture:SetTexture(nil)
		if frame.ButtonFrame then
			frame.ButtonFrame:SetTexture(nil)
		end
		if frame.StartMissionFrame then
			frame.StartMissionFrame.ButtonFrame:SetTexture(nil)
		end
		if frame.BuffsFrame then
			frame.BuffsFrame.BuffsBG:SetTexture(nil)
		end
		if frame.RewardsFrame then
			frame.RewardsFrame:DisableDrawLayer("BACKGROUND")
			frame.RewardsFrame:DisableDrawLayer("BORDER")
		end
		if frame.Enemies then
			for i = 1, #frame.Enemies do
				if frame.Enemies[i].PortraitFrame then
					frame.Enemies[i].PortraitFrame.PortraitRing:SetTexture(nil)
				else
					frame.Enemies[i].PortraitRing:SetTexture(nil)
				end
			end
			for i = 1, #frame.Followers do
				if frame.Followers[i].PortraitFrame then
					aObj:removeRegions(frame.Followers[i], {1})
					skinPortrait(frame.Followers[i].PortraitFrame)
				end
				if frame.Followers[i].DurabilityBackground then
					frame.Followers[i].DurabilityBackground:SetTexture(nil)
				end
			end
		end
		if frame.FollowerModel then
			aObj:moveObject{obj=frame.FollowerModel, x=-6, y=0}
		end
		if not _G.IsAddOnLoaded("MasterPlan") then
			frame.CloseButton:SetSize(28, 28) -- make button smaller
		end
		local y1Ofs, x2Ofs, y2Ofs = 5, 3, -20
		if frame.CloseButton.CloseButtonBorder then
			frame.CloseButton.CloseButtonBorder:SetTexture(nil)
			y1Ofs, x2Ofs, y2Ofs = 2, 1, -30
		end
		aObj:skinObject("frame", {obj=frame, fType=ftype, kfs=true, cb=true, x1=_G.IsAddOnLoaded("GarrisonCommander") and 0 or -320, y1=y1Ofs, x2=x2Ofs, y2=y2Ofs})
		if aObj.modBtns then
			aObj:skinStdButton{obj=frame.StartMissionButton}
			aObj:moveObject{obj=frame.StartMissionButton.Flash, x=-0.5, y=1.5}
			aObj:SecureHook(frame:GetParent():GetParent(), "UpdateStartButton", function(this, missionPage)
				aObj:clrBtnBdr(missionPage.StartMissionButton)
			end)
		end
	end
	function skinMissionComplete(frame, naval)
		local mcb = frame:GetParent().MissionCompleteBackground
		mcb:SetSize(naval and 953 or 949 , naval and 661 or 638)
		aObj:moveObject{obj=mcb, x=4, y=naval and 20 or -1}
		mcb = nil
	    frame:DisableDrawLayer("BACKGROUND")
		frame:DisableDrawLayer("BORDER")
		frame:DisableDrawLayer("ARTWORK")
		aObj:removeRegions(frame.Stage, naval and {1, 2, 3, 4} or stageRegs) -- top half only
		local flwr
		for i = 1, #frame.Stage.FollowersFrame.Followers do
			flwr = frame.Stage.FollowersFrame.Followers[i]
	        if naval then
	            flwr.NameBG:SetTexture(nil)
	        else
	            aObj:removeRegions(flwr, {1})
				flwr.DurabilityBackground:SetTexture(nil)
	        end
			if flwr.PortraitFrame then
				skinPortrait(flwr.PortraitFrame)
			end
			aObj:skinStatusBar{obj=flwr.XP, fi=0}
			flwr.XP:DisableDrawLayer("OVERLAY")
		end
		flwr = nil
	    frame.BonusRewards:DisableDrawLayer("BACKGROUND")
		frame.BonusRewards:DisableDrawLayer("BORDER")
		aObj:getRegion(frame.BonusRewards, 11):SetTextColor(aObj.HT:GetRGB()) -- Heading
	    frame.BonusRewards.Saturated:DisableDrawLayer("BACKGROUND")
		frame.BonusRewards.Saturated:DisableDrawLayer("BORDER")
		for i = 1, #frame.BonusRewards.Rewards do
			aObj:addButtonBorder{obj=frame.BonusRewards.Rewards[i], relTo=frame.BonusRewards.Rewards[i].Icon, reParent={frame.BonusRewards.Rewards[i].Quantity}}
		end
	    aObj:addSkinFrame{obj=frame, ft=ftype, x1=3, y1=6, y2=-16}
		if aObj.modBtns then
			aObj:skinStdButton{obj=frame.NextMissionButton}
			aObj:SecureHook(frame.NextMissionButton, "Disable", function(this, _)
				aObj:clrBtnBdr(this)
			end)
			aObj:SecureHook(frame.NextMissionButton, "Enable", function(this, _)
				aObj:clrBtnBdr(this)
			end)
		end
		for i = 1, #frame.Stage.EncountersFrame.Encounters do
			if not naval then
				frame.Stage.EncountersFrame.Encounters[i].Ring:SetTexture(nil)
			else
				frame.Stage.EncountersFrame.Encounters[i].PortraitRing:SetTexture(nil)
			end
		end
	    aObj:removeRegions(frame.Stage.MissionInfo, naval and {1, 2, 3, 4, 5, 8, 9, 10} or {1, 2, 3, 4, 5, 11, 12, 13})
	end
	local mlTabSkin = aObj.skinTPLs.new("tabs", {fType=ftype, numTabs=2, ignoreSize=true, lod=true, regions={7, 8, 9}, track=false})
	function skinMissionList(ml, tabOfs)
		ml.MaterialFrame:DisableDrawLayer("BACKGROUND")
		aObj:skinObject("frame", {obj=ml, fType=ftype, kfs=true, fb=true, ofs=1})
		if ml.RaisedFrameEdges then
			ml.MaterialFrame.LeftFiligree:SetTexture(nil)
			ml.MaterialFrame.RightFiligree:SetTexture(nil)
			ml.listScroll.scrollBar:DisableDrawLayer("BACKGROUND")
			ml.RaisedFrameEdges:DisableDrawLayer("BORDER")
		else
			aObj:skinObject("slider", {obj=ml.listScroll.scrollBar, fType=ftype, y1=-2, y2=2})
			-- tabs
			mlTabSkin.obj = ml
			mlTabSkin.prefix = ml:GetName()
			mlTabSkin.offsets =  {x1=tabOfs and tabOfs * -1 or 6, y1=tabOfs or 0, x2=tabOfs or -6, y2=2}
			aObj:skinObject(mlTabSkin)
			if aObj.isTT
			and not aObj:IsHooked("GarrisonMissonListTab_SetSelected")
			then
				aObj:SecureHook("GarrisonMissonListTab_SetSelected", function(tab, isSelected)
					-- aObj:Debug("GarrisonMissonListTab_SetSelected: [%s, %s]", tab, isSelected)
					if isSelected then
						aObj:setActiveTab(tab.sf)
					else
						aObj:setInactiveTab(tab.sf)
					end
				end)
			end
		end
		local btn
		for i = 1, #ml.listScroll.buttons do
			btn = ml.listScroll.buttons[i]
			btn:DisableDrawLayer("BACKGROUND")
			btn:DisableDrawLayer("BORDER")
			aObj:nilTexture(btn.LocBG, true)
			if btn.RareOverlay then
				btn.RareOverlay:SetTexture(nil)
				-- extend the top & bottom highlight texture
				btn.HighlightT:ClearAllPoints()
				btn.HighlightT:SetPoint("TOPLEFT", 0, 4)
				btn.HighlightT:SetPoint("TOPRIGHT", 0, 4)
		        btn.HighlightB:ClearAllPoints()
		        btn.HighlightB:SetPoint("BOTTOMLEFT", 0, -4)
		        btn.HighlightB:SetPoint("BOTTOMRIGHT", 0, -4)
				-- remove highlight corners
				btn.HighlightTL:SetTexture(nil)
				btn.HighlightTR:SetTexture(nil)
				btn.HighlightBL:SetTexture(nil)
				btn.HighlightBR:SetTexture(nil)
			end
		end
		btn = nil
		-- CompleteDialog
		skinCompleteDialog(ml.CompleteDialog)
	end
end

-- The following functions are used by several Chat* functions
aObj.cebRgns1 = {1, 2, 9, 10, 11} -- 1, 9, 10 & 11 are font strings, 2 is cursor texture
local function skinChatEB(obj)
	if aObj.prdb.ChatEditBox.style == 1 then -- Frame
		aObj:keepRegions(obj, aObj.cebRgns1)
		aObj:skinObject("frame", {obj=obj, fType=ftype, ofs=-2})
		obj.sf:SetAlpha(obj:GetAlpha())
	elseif aObj.prdb.ChatEditBox.style == 2 then -- Editbox
		aObj:skinObject("editbox", {obj=obj, fType=ftype, regions={3, 4, 5, 6, 7, 8}, ofs=-4})
	else -- Borderless
		aObj:keepRegions(obj, aObj.cebRgns1)
		aObj:skinObject("frame", {obj=obj, fType=ftype, noBdr=true, ofs=-5, y=2})
		obj.sf:SetAlpha(obj:GetAlpha())
	end
end
local function skinPointerFrame(frame)
	aObj:skinGlowBox(frame.Content)
	frame.Glow:SetBackdrop(nil)
end
local function hookPointerFrame()
	aObj:RawHook(_G.NPE_TutorialPointerFrame, "_GetFrame", function(this, ...)
		local frame = aObj.hooks[this]._GetFrame(this, ...)
		skinPointerFrame(frame)
		return frame
	end, true)
	if _G.NPE_PointerFrame_1
	and not _G.NPE_PointerFrame_1.sf
	then
		skinPointerFrame(_G.NPE_PointerFrame_1)
	end
	hookPointerFrame = nil
end
if not aObj.isClsc then
	-- hoook this (used by Blizzard_OrderHallTalents, PVPMatchResults, PVPMatchScoreboard & Blizzard_WarboardUI)
	aObj:RawHook("UIPanelCloseButton_SetBorderAtlas", function(...) end, true)
end

aObj.blizzFrames[ftype].AddonList = function(self)
	if not self.prdb.AddonList or self.initialized.AddonList then return end
	self.initialized.AddonList = true

	self:SecureHookScript(_G.AddonList, "OnShow", function(this)
		self:removeMagicBtnTex(this.CancelButton)
		self:removeMagicBtnTex(this.OkayButton)
		self:removeMagicBtnTex(this.EnableAllButton)
		self:removeMagicBtnTex(this.DisableAllButton)
		for i = 1, _G.MAX_ADDONS_DISPLAYED do
			if self.modBtns then
				self:skinStdButton{obj=_G["AddonListEntry" .. i .. "Load"]}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=_G["AddonListEntry" .. i .. "Enabled"]}
			end
		end
		self:skinSlider{obj=_G.AddonListScrollFrame.ScrollBar, rt="background"}
		self:skinDropDown{obj=_G.AddonCharacterDropDown, x2=109} -- created in OnLoad
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true}
		if self.modBtns then
			self:skinStdButton{obj=this.CancelButton}
			self:skinStdButton{obj=this.OkayButton}
			self:skinStdButton{obj=this.EnableAllButton}
			self:skinStdButton{obj=this.DisableAllButton}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.AddonListForceLoad}
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzLoDFrames[ftype].AdventureMap = function(self)
	if not self.prdb.AdventureMap or self.initialized.AdventureMap then return end

	-- N.B. fired when entering an OrderHall

	if not _G.AdventureMapQuestChoiceDialog then
		_G.C_Timer.After(0.1, function()
			self.blizzLoDFrames[ftype].AdventureMap(self)
		end)
		return
	end

	self.initialized.AdventureMap = true

	self:SecureHookScript(_G.AdventureMapQuestChoiceDialog, "OnShow", function(this)
		this:DisableDrawLayer("BACKGROUND") -- remove textures
		this.Details.ScrollBar:DisableDrawLayer("ARTWORK")
		self:skinSlider{obj=this.Details.ScrollBar}
		this.Details.Child.TitleHeader:SetTextColor(self.HT:GetRGB())
		this.Details.Child.DescriptionText:SetTextColor(self.BT:GetRGB())
		this.Details.Child.ObjectivesHeader:SetTextColor(self.HT:GetRGB())
		this.Details.Child.ObjectivesText:SetTextColor(self.BT:GetRGB())
		if this.CloseButton:GetNormalTexture() then
			this.CloseButton:GetNormalTexture():SetTexture(nil) -- frame is animated in
		end
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, y1=-12, x2=0, y2=-4}
		if self.modBtns then
			self:skinStdButton{obj=this.DeclineButton}
			self:skinStdButton{obj=this.AcceptButton}
		end

		self:Unhook(this, "OnShow")
	end)

	if self.modBtnBs then
		self:SecureHook(_G.AdventureMapQuestChoiceDialog, "RefreshRewards", function(this)
			for reward in this.rewardPool:EnumerateActive() do
				reward.ItemNameBG:SetTexture(nil)
				self:addButtonBorder{obj=reward, relTo=reward.Icon, reParent={reward.Count}}
			end
		end)
	end

end

aObj.blizzFrames[ftype].AlertFrames = function(self)
	if not self.prdb.AlertFrames or self.initialized.AlertFrames then return end
	self.initialized.AlertFrames = true

	local function skinACAlertFrames(frame)

		local fH = _G.Round(frame:GetHeight())

		aObj:nilTexture(frame.Background, true)
		frame.Unlocked:SetTextColor(aObj.BT:GetRGB())
		if frame.OldAchievement then frame.OldAchievement:SetTexture(nil) end -- AchievementAlertFrame(s)

		frame.Icon:DisableDrawLayer("BORDER")
		frame.Icon:DisableDrawLayer("OVERLAY")

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
			aObj:addSkinFrame{obj=frame, ft=ftype, x1=x1, y1=y1, x2=x2, y2=y2}
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=frame.Icon, relTo=frame.Icon.Texture}
			end
		else
			frame.sf:ClearAllPoints()
			frame.sf:SetPoint("TOPLEFT", frame, "TOPLEFT", x1, y1)
			frame.sf:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", x2, y2)
		end
		fH, x1, y1, x2, y2 = nil, nil, nil ,nil ,nil

	end
	-- called params: frame, achievementID, alreadyEarned (10585, true)
	self:SecureHook(_G.AchievementAlertSystem, "setUpFunction", function(frame, _)
		-- aObj:Debug("AchievementAlertSystem: [%s, %s, %s]", frame, ...)
		skinACAlertFrames(frame)
	end)
	--called params: frame, achievementID, criteriaString (10607, "Test")
	self:SecureHook(_G.CriteriaAlertSystem, "setUpFunction", function(frame, _)
		-- aObj:Debug("CriteriaAlertSystem: [%s, %s, %s]", frame, ...)
		skinACAlertFrames(frame)
	end)

	-- called params: self, itemLink, originalQuantity, rollType, roll, specID, isCurrency, showFactionBG, lootSource, lessAwesome, isUpgraded, wonRoll, showRatedBG, isSecondaryResult
	self:SecureHook(_G.LootAlertSystem, "setUpFunction", function(frame, ...)
		-- aObj:Debug("LootAlertSystem: [%s, %s]", frame, ...)
		frame:DisableDrawLayer("BACKGROUND")
		frame.lootItem.SpecRing:SetTexture(nil)
		self:addSkinFrame{obj=frame, ft=ftype, ofs=-10, y2=8}
		-- colour the Icon buttons' border
		if self.modBtnBs then
			local itemRarity
			local itemLink = ...
			if frame.isCurrency then
				-- BETA: API change
				itemRarity = _G.C_CurrencyInfo and _G.C_CurrencyInfo.GetCurrencyInfoFromLink and _G.C_CurrencyInfo.GetCurrencyInfoFromLink(itemLink).quality or _G.select(8, _G.GetCurrencyInfo(itemLink))
			else
				itemRarity = _G.select(3, _G.GetItemInfo(itemLink))
			end
			frame.lootItem.IconBorder:SetTexture(nil)
			self:addButtonBorder{obj=frame.lootItem, relTo=frame.lootItem.Icon}
			frame.lootItem.sbb:SetBackdropBorderColor(_G.ITEM_QUALITY_COLORS[itemRarity].r, _G.ITEM_QUALITY_COLORS[itemRarity].g, _G.ITEM_QUALITY_COLORS[itemRarity].b)
			itemLink, itemRarity = nil, nil
		end
	end)
	-- called parms: self, itemLink, quantity, specID, baseQuality (147239, 1, 1234, 5)
	self:SecureHook(_G.LootUpgradeAlertSystem, "setUpFunction", function(frame, _)
		-- aObj:Debug("LootUpgradeAlertSystem: [%s, %s, %s, %s, %s]", frame, ...)
		frame:DisableDrawLayer("BACKGROUND")
		self:addSkinFrame{obj=frame, ft=ftype, ofs=-10, y2=8}
	end)
	-- called params: self, amount (12345)
	self:SecureHook(_G.MoneyWonAlertSystem, "setUpFunction", function(frame, _)
		-- aObj:Debug("MoneyWonAlertSystem: [%s, %s]", frame, ...)
		frame:DisableDrawLayer("BACKGROUND")
		frame.IconBorder:SetTexture(nil)
		self:addSkinFrame{obj=frame, ft=ftype, ofs=-8, y2=8}
		if self.modBtnBs then
			self:addButtonBorder{obj=frame, relTo=frame.Icon}
		end
	end)
	-- called params: self, amount (350)
	self:SecureHook(_G.HonorAwardedAlertSystem, "setUpFunction", function(frame, _)
		-- aObj:Debug("HonorAwardedAlertSystem: [%s, %s]", frame, ...)
		frame:DisableDrawLayer("BACKGROUND")
		frame.IconBorder:SetTexture(nil)
		self:addSkinFrame{obj=frame, ft=ftype, ofs=-8, y2=8}
		if self.modBtnBs then
			self:addButtonBorder{obj=frame, relTo=frame.Icon}
		end
	end)
	-- called params: self, recipeID (209645)
	self:SecureHook(_G.NewRecipeLearnedAlertSystem, "setUpFunction", function(frame, _)
		-- aObj:Debug("NewRecipeLearnedAlertSystem: [%s, %s]", frame, ...)
		frame:DisableDrawLayer("BACKGROUND")
		frame.Icon:SetDrawLayer("BORDER")
		self:addSkinFrame{obj=frame, ft=ftype, ofs=-8}
	end)

	local function skinDCSAlertFrames(opts)

		opts.obj:DisableDrawLayer("BORDER")
		opts.obj:DisableDrawLayer("OVERLAY")
		opts.obj.dungeonTexture:SetDrawLayer("ARTWORK") -- move Dungeon texture above skinFrame
		aObj:addSkinFrame{obj=opts.obj, ft=ftype, ofs=opts.ofs or -8, y1=opts.y1 or nil}
		if self.modBtnBs then
			-- wait for animation to finish
			_G.C_Timer.After(0.2, function()
				aObj:addButtonBorder{obj=opts.obj, relTo=opts.obj.dungeonTexture}
			end)
		end

	end
	-- called params: frame, challengeType, count, max ("Raid", 2, 5)
	self:SecureHook(_G.GuildChallengeAlertSystem, "setUpFunction", function(frame, _)
		-- aObj:Debug("GuildChallengeAlertSystem: [%s, %s, %s, %s]", frame, ...)
		frame:DisableDrawLayer("BACKGROUND")
		frame:DisableDrawLayer("BORDER")
		frame:DisableDrawLayer("OVERLAY")
		aObj:addSkinFrame{obj=frame, ft=ftype, ofs=-10}
	end)
	-- called params: frame, rewardData={name="Deceiver's Fall", iconTextureFile=1616157, subtypeID=3, moneyAmount=1940000, moneyBase=1940000, monetVar=0, experienceBase=0, experienceGained=0, experienceVar=0, numRewards=1, numStrangers=0, rewards={} }
	self:SecureHook(_G.DungeonCompletionAlertSystem, "setUpFunction", function(frame, _)
		-- aObj:Debug("DungeonCompletionAlertSystem: [%s, %s]", frame, rewardData)
		skinDCSAlertFrames{obj=frame}
	end)
	-- called params: frame, rewardData={}
	self:SecureHook(_G.ScenarioAlertSystem, "setUpFunction", function(frame, _)
		-- aObj:Debug("ScenarioAlertSystem: [%s, %s]", frame, rewardData)
		self:getRegion(frame, 1):SetTexture(nil) -- Toast-IconBG
		skinDCSAlertFrames{obj=frame, ofs=-12}
	end)
	-- called params: frame, rewardQuestID, name, showBonusCompletion, xp, money (123456, "Test", true, 2500, 1234)
	self:SecureHook(_G.InvasionAlertSystem, "setUpFunction", function(frame, _)
		-- aObj:Debug("InvasionAlertSystem: [%s, %s, %s, %s, %s, %s]", frame, ...)
		self:getRegion(frame, 1):SetTexture(nil) -- Background toast texture
		self:getRegion(frame, 2):SetDrawLayer("ARTWORK") -- move icon to ARTWORK layer so it is displayed
		aObj:addSkinFrame{obj=frame, ft=ftype, ofs=-8}
		if self.modBtnBs then
			self:addButtonBorder{obj=frame, relTo=self:getRegion(frame, 2)}
		end
	end)
	-- called params: frame, raceName, raceTexture ("Demonic", "")
	self:SecureHook(_G.DigsiteCompleteAlertSystem, "setUpFunction", function(frame, _)
		-- aObj:Debug("DigsiteCompleteAlertSystem: [%s, %s, %s]", frame, ...)
		frame:DisableDrawLayer("BACKGROUND")
		self:addSkinFrame{obj=frame, ft=ftype, ofs=-10}
	end)
	-- called params: frame, type, icon, name, payloadID, showFancyToast
	self:SecureHook(_G.EntitlementDeliveredAlertSystem, "setUpFunction", function(frame, _)
		-- aObj:Debug("EntitlementDeliveredAlertSystem: [%s, %s, %s, %s, %s, %s]", frame, ...)
		frame:DisableDrawLayer("BACKGROUND")
		self:addSkinFrame{obj=frame, ft=ftype, ofs=-10}
		if self.modBtnBs then
			self:addButtonBorder{obj=frame, relTo=frame.Icon}
		end
	end)
	-- called params: frame, type, icon, name, payloadID, showFancyToast
	self:SecureHook(_G.RafRewardDeliveredAlertSystem, "setUpFunction", function(frame, _)
		-- aObj:Debug("RafRewardDeliveredAlertSystem: [%s, %s, %s, %s, %s, %s]", frame, ...)
		frame:DisableDrawLayer("BACKGROUND")
		self:addSkinFrame{obj=frame, ft=ftype, ofs=-10}
		if self.modBtnBs then
			self:addButtonBorder{obj=frame, relTo=frame.Icon}
		end
	end)
	-- called params: frame, name, garrisonType ("Menagerie", "")
	self:SecureHook(_G.GarrisonBuildingAlertSystem, "setUpFunction", function(frame, _)
		-- aObj:Debug("GarrisonBuildingAlertSystem: [%s, %s, %s]", frame, ...)
		frame:DisableDrawLayer("BACKGROUND")
		frame.Icon:SetDrawLayer("BORDER")
		self:addSkinFrame{obj=frame, ft=ftype, ofs=-10}
		if self.modBtnBs then
			self:addButtonBorder{obj=frame, relTo=frame.Icon}
		end
	end)
	-- called params: frame, missionInfo=({name="Test", typeAtlas="", followerTypeID=LE_FOLLOWER_TYPE_GARRISON_7_0})
	self:SecureHook(_G.GarrisonMissionAlertSystem, "setUpFunction", function(frame, _)
		-- aObj:Debug("GarrisonMissionAlertSystem: [%s, %s]", frame, ...)
		frame:DisableDrawLayer("BACKGROUND")
		frame:DisableDrawLayer("BORDER")
		self:addSkinFrame{obj=frame, ft=ftype, ofs=-10, y1=-8}
	end)
	-- called params: frame, missionInfo=({name="Test", typeAtlas="", followerTypeID=LE_FOLLOWER_TYPE_GARRISON_7_0})
	self:SecureHook(_G.GarrisonShipMissionAlertSystem, "setUpFunction", function(frame, _)
		-- aObj:Debug("GarrisonShipMissionAlertSystem: [%s, %s]", frame, ...)
		frame:DisableDrawLayer("BACKGROUND")
		self:addSkinFrame{obj=frame, ft=ftype, ofs=-10}
	end)
	-- called params: frame, missionInfo=({level=105, iLevel=875, isRare=true, followerTypeID=LE_FOLLOWER_TYPE_GARRISON_6_0})
	self:SecureHook(_G.GarrisonRandomMissionAlertSystem, "setUpFunction", function(frame, _)
		-- aObj:Debug("GarrisonRandomMissionAlertSystem: [%s, %s]", frame, ...)
		frame:DisableDrawLayer("BACKGROUND")
		frame.MissionType:SetDrawLayer("BORDER")
		self:addSkinFrame{obj=frame, ft=ftype, ofs=-10}
	end)
	-- called params: frame, followerID, name, level, quality, isUpgraded, followerInfo={isTroop=, followerTypeID=, portraitIconID=, quality=, level=, iLevel=}
	self:SecureHook(_G.GarrisonFollowerAlertSystem, "setUpFunction", function(frame, _)
		-- aObj:Debug("GarrisonFollowerAlertSystem: [%s, %s, %s, %s, %s, %s, %s]", frame, ...)
		frame:DisableDrawLayer("BACKGROUND")
		frame.PortraitFrame.PortraitRing:SetTexture(nil)
		self:nilTexture(frame.PortraitFrame.LevelBorder, true)
		self:nilTexture(frame.FollowerBG, true)
		self:addSkinFrame{obj=frame, ft=ftype, ofs=-8}
	end)
	-- called params: frame, followerID, name, class, texPrefix, level, quality, isUpgraded, followerInfo={}
	self:SecureHook(_G.GarrisonShipFollowerAlertSystem, "setUpFunction", function(frame, _)
		-- aObj:Debug("GarrisonShipFollowerAlertSystem: [%s, %s, %s, %s, %s, %s, %s, %s, %s]", frame, ...)
		frame:DisableDrawLayer("BACKGROUND")
		self:nilTexture(frame.FollowerBG, true)
		self:addSkinFrame{obj=frame, ft=ftype, ofs=-8}
	end)
	-- called params: frame, garrisonType, talent={icon=""}
	self:SecureHook(_G.GarrisonTalentAlertSystem, "setUpFunction", function(frame, _)
		-- aObj:Debug("GarrisonTalentAlertSystem: [%s, %s, %s]", frame, ...)
		frame:DisableDrawLayer("BACKGROUND")
		frame.Icon:SetDrawLayer("BORDER")
		self:addSkinFrame{obj=frame, ft=ftype, ofs=-10}
		if self.modBtnBs then
			self:addButtonBorder{obj=frame, relTo=frame.Icon}
		end
	end)
	-- called params: frame, questData (1234)
	self:SecureHook(_G.WorldQuestCompleteAlertSystem, "setUpFunction", function(frame, _)
		-- aObj:Debug("WorldQuestCompleteAlertSystem: [%s, %s]", frame, ...)
		frame.QuestTexture:SetDrawLayer("ARTWORK")
		frame:DisableDrawLayer("BORDER") -- toast texture
		self:addSkinFrame{obj=frame, ft=ftype, ofs=-6, y1=-10}
		if self.modBtnBs then
			self:addButtonBorder{obj=frame, relTo=frame.QuestTexture}
		end
	end)
	-- called params: frame, itemLink (137080)
	self:SecureHook(_G.LegendaryItemAlertSystem, "setUpFunction", function(frame, _)
		-- aObj:Debug("LegendaryItemAlertSystem: [%s, %s]", frame, ...)
		frame.Background:SetTexture(nil)
		frame.Background2:SetTexture(nil)
		frame.Background3:SetTexture(nil)
		self:addSkinFrame{obj=frame, ft=ftype, ofs=-20, x1=24, x2=-4}
		if self.modBtnBs then
			self:addButtonBorder{obj=frame, relTo=frame.Icon}
			-- set button border to Legendary colour
			frame.sbb:SetBackdropBorderColor(_G.ITEM_QUALITY_COLORS[5].r, _G.ITEM_QUALITY_COLORS[5].g, _G.ITEM_QUALITY_COLORS[5].b)
		end
	end)
	-- called params: frame, petID
	self:SecureHook(_G.NewPetAlertSystem, "setUpFunction", function(frame, _)
		-- aObj:Debug("NewPetAlertSystem: [%s, %s]", frame, ...)
		frame:DisableDrawLayer("BACKGROUND")
		self:addSkinFrame{obj=frame, ft=ftype, ofs=-8}
	end)
	-- called params: frame, mountID
	self:SecureHook(_G.NewMountAlertSystem, "setUpFunction", function(frame, _)
		-- aObj:Debug("NewMountAlertSystem: [%s, %s]", frame, ...)
		frame:DisableDrawLayer("BACKGROUND")
		self:addSkinFrame{obj=frame, ft=ftype, ofs=-8}
	end)
	if _G.NewToyAlertSystem then
		-- called params: frame, toyID
		self:SecureHook(_G.NewToyAlertSystem, "setUpFunction", function(frame, _)
			-- aObj:Debug("NewToyAlertSystem: [%s, %s]", frame, ...)
			frame:DisableDrawLayer("BACKGROUND")
			self:addSkinFrame{obj=frame, ft=ftype, ofs=-8}
		end)
	end

	-- hook this to stop gradient texture whiteout
	self:RawHook(_G.AlertFrame, "AddAlertFrame", function(this, frame)

		-- aObj:Debug("AlertFrame AddAlertFrame: [%s, %s]", this, frame)

		if _G.IsAddOnLoaded("Overachiever") then
			local ocScript = frame:GetScript("OnClick")
			if ocScript
			and ocScript == _G.OverachieverAlertFrame_OnClick
			then
				-- aObj:Debug("AF Overachiever Alert detected")
				-- stretch icon texture
				frame.Icon.Texture:SetTexCoord(-0.04, 0.75, 0.0, 0.555)
				skinACAlertFrames(frame)
			end
			ocScript = nil
		end

		-- run the hooked function
		self.hooks[this].AddAlertFrame(this, frame)

		-- adjust size if guild achievement
		if self:hasTextInName(frame, "AchievementAlertFrame") then
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

	-- hook these to reset Gradients
	self:SecureHook("AlertFrame_PauseOutAnimation", function(frame)
		if frame.sf then frame.sf.tfade:SetGradientAlpha(self:getGradientInfo()) end
		if frame.cb then frame.cb.tfade:SetGradientAlpha(self:getGradientInfo()) end
	end)
	self:SecureHook("AlertFrame_ResumeOutAnimation", function(frame)
		if frame.sf then frame.sf.tfade:SetAlpha(0) end
		if frame.cb then frame.cb.tfade:SetAlpha(0) end
	end)

end

aObj.blizzLoDFrames[ftype].AnimaDiversionUI = function(self)
	if not self.prdb.AnimaDiversionUI or self.initialized.AnimaDiversionUI then return end
	self.initialized.AnimaDiversionUI = true

	-- FIXME: ScrollContainer moves to the right when Anima flowing
	self:SecureHookScript(_G.AnimaDiversionFrame, "OnShow", function(this)
		self:removeNineSlice(this.NineSlice)
		self:keepFontStrings(this.BorderFrame)
		this.CloseButton.Border:SetTexture(nil)
		this.AnimaDiversionCurrencyFrame:DisableDrawLayer("BACKGROUND")
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, clr="sepia", x1=-4, y1=3, x2=2, y2=-5})
		if self.modBtns then
			self:skinCloseButton{obj=this.CloseButton , noSkin=true}
			self:skinStdButton{obj=this.ReinforceInfoFrame.AnimaNodeReinforceButton}
			self:SecureHook(this.ReinforceInfoFrame.AnimaNodeReinforceButton, "Disable", function(this, _)
				self:clrBtnBdr(this)
			end)
			self:SecureHook(this.ReinforceInfoFrame.AnimaNodeReinforceButton, "Enable", function(this, _)
				self:clrBtnBdr(this)
			end)
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].ArtifactToasts = function(self)
	if not self.prdb.ArtifactUI or self.initialized.ArtifactToasts then return end
	self.initialized.ArtifactToasts = true

	self:SecureHookScript(_G.ArtifactLevelUpToast, "OnShow", function(this)
		this:DisableDrawLayer("BACKGROUND")
		this:DisableDrawLayer("BORDER")
		this.IconFrame:SetTexture(nil)
		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].AutoComplete = function(self)
	if not self.prdb.AutoComplete or self.initialized.AutoComplete then return end
	self.initialized.AutoComplete = true

	-- tooltip
	_G.C_Timer.After(0.1, function()
		self:add2Table(self.ttList, _G.AutoCompleteBox)
	end)

end

aObj.blizzLoDFrames[ftype].BattlefieldMap = function(self)
	if not self.prdb.BattlefieldMap or self.initialized.BattlefieldMap then return end
	self.initialized.BattlefieldMap = true

	self:SecureHookScript(_G.BattlefieldMapFrame, "OnShow", function(this)
		self:skinObject("frame", {obj=_G.BattlefieldMapTab, fType=ftype, kfs=true, noBdr=self.isTT, y1=-7, y2=-7})
		self:skinObject("frame", {obj=this.BorderFrame, fType=ftype, kfs=true, cb=true, fb=true, ofs=4, y1=6, x2=2, y2=2})

		-- change the skinFrame's opacity as required
		self:SecureHook(this, "RefreshAlpha", function(this)
			local alpha = 1.0 - _G.BattlefieldMapOptions.opacity
			alpha = (alpha >= 0.15) and alpha - 0.15 or alpha
			this.BorderFrame.sf:SetAlpha(alpha)
			alpha= nil
		end)

		if _G.IsAddOnLoaded("Capping") then
			if _G.type(self["Capping_ModMap"]) == "function" then self:Capping_ModMap() end
		end

		if _G.IsAddOnLoaded("Mapster") then
			local mBM = _G.LibStub:GetLibrary("AceAddon-3.0", true):GetAddon("Mapster", true):GetModule("BattleMap", true)
			if mBM then
				local function updBMVisibility(db)
					if db.hideTextures then
						this.BorderFrame.sf:Hide()
					else
						this.BorderFrame.sf:Show()
					end
				end
				-- change visibility as required
				updBMVisibility(mBM.db.profile)
				self:SecureHook(mBM, "UpdateTextureVisibility", function(this)
					updBMVisibility(this.db.profile)
				end)
			end
			mBM = nil
		end

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.BattlefieldMapFrame)

end

aObj.blizzLoDFrames[ftype].BindingUI = function(self)
	if not self.prdb.BindingUI or self.initialized.BindingUI then return end
	self.initialized.BindingUI = true

	self:SecureHookScript(_G.KeyBindingFrame, "OnShow", function(this)
		self:removeNineSlice(this.BG)
		self:keepRegions(this.categoryList, {})
		self:addFrameBorder{obj=this.categoryList, ft=ftype}
		self:addFrameBorder{obj=this.bindingsContainer, ft=ftype}
		self:skinSlider{obj=this.scrollFrame.ScrollBar, rt={"background", "border"}}
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true, hdr=true}
		if self.modBtns then
			for _, row in _G.pairs(this.keyBindingRows) do
				self:skinStdButton{obj=row.key1Button}
				self:skinStdButton{obj=row.key2Button}
				row.key1Button.sb:SetAlpha(row.key1Button:GetAlpha())
				row.key2Button.sb:SetAlpha(row.key2Button:GetAlpha())
				if not aObj.isClsc then
					self:SecureHook(row, "Update", function(this)
						self:clrBtnBdr(this.key2Button)
						this.key1Button.sb:SetAlpha(this.key1Button:GetAlpha())
						this.key2Button.sb:SetAlpha(this.key2Button:GetAlpha())
					end)
				end
			end
			if self.isClsc then
				self:SecureHook("KeyBindingFrame_Update", function()
					for _, row in _G.pairs(_G.KeyBindingFrame.keyBindingRows) do
						self:clrBtnBdr(row.key2Button)
						row.key1Button.sb:SetAlpha(row.key1Button:GetAlpha())
						row.key2Button.sb:SetAlpha(row.key2Button:GetAlpha())
					end
				end)
			end
			self:skinStdButton{obj=this.unbindButton}
			self:skinStdButton{obj=this.okayButton}
			self:skinStdButton{obj=this.cancelButton}
			self:skinStdButton{obj=this.defaultsButton}
			-- hook this to handle custom buttons (e.g. Voice Chat: Push to Talk)
			self:SecureHook("BindingButtonTemplate_SetupBindingButton", function(_, button)
				if button.GetCustomBindingType then
					self:skinStdButton{obj=button}
				end
			end)
			if not aObj.isClsc then
				self:skinStdButton{obj=this.quickKeybindButton}
				self:SecureHook(this, "UpdateUnbindKey", function(this)
					self:clrBtnBdr(this.unbindButton)
				end)
			else
				self:SecureHook("KeyBindingFrame_UpdateUnbindKey", function()
					self:clrBtnBdr(this.unbindButton)
				end)
			end
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=this.characterSpecificButton}
		end

		self:Unhook(this, "OnShow")
	end)

	if not aObj.isClsc then
		self:SecureHookScript(_G.QuickKeybindFrame, "OnShow", function(this)
			self:removeNineSlice(this.BG)
			this.BG.Bg:SetTexture(nil)
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true, hdr=true, ofs=0}
			if self.modBtns then
				self:skinStdButton{obj=this.defaultsButton}
				self:skinStdButton{obj=this.cancelButton}
				self:skinStdButton{obj=this.okayButton}
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=this.phantomExtraActionButton, x2=1, y2=-1}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=this.characterSpecificButton}
			end

			self:Unhook(this, "OnShow")
		end)
		-- tooltip
		_G.C_Timer.After(0.1, function()
			self:add2Table(self.ttList, _G.QuickKeybindTooltip)
		end)
	end

end

aObj.blizzFrames[ftype].BNFrames = function(self)
	if not self.prdb.BNFrames or self.initialized.BNFrames then return end
	self.initialized.BNFrames = true

	self:addSkinFrame{obj=_G.BNToastFrame, ft=ftype, nb=true} -- show textures
	self:hookSocialToastFuncs(_G.BNToastFrame)
	if self.modBtns then
		self:skinCloseButton{obj=_G.BNToastFrame.CloseButton, font=self.fontSBX, aso={bd=5, bba=0}, noSkin=true}
	end
	self:addSkinFrame{obj=_G.BNToastFrame.TooltipFrame, ft=ftype, kfs=true, nb=true}
	_G.BNToastFrame.TooltipFrame:SetScript("OnLoad", nil)
	self:addSkinFrame{obj=_G.TimeAlertFrame, ft=ftype, nb=true} -- show textures
	self:hookSocialToastFuncs(_G.TimeAlertFrame)
	if self.modBtns then
		self:skinCloseButton{obj=_G.TimeAlertFrame.CloseButton, font=self.fontSBX, aso={bd=5, bba=0}, noSkin=true}
	end

end

aObj.blizzLoDFrames[ftype].Calendar = function(self)
	if not self.prdb.Calendar or self.initialized.Calendar then return end
	self.initialized.Calendar = true

	self:SecureHookScript(_G.CalendarFrame, "OnShow", function(this)
		self:keepFontStrings(_G.CalendarFilterFrame)
		self:moveObject{obj=_G.CalendarCloseButton, y=14}
		self:adjHeight{obj=_G.CalendarCloseButton, adj=-2}
		self:addSkinFrame{obj=_G.CalendarContextMenu, ft=ftype}
		self:addSkinFrame{obj=_G.CalendarInviteStatusContextMenu, ft=ftype}
		-- remove texture from day buttons
		for i = 1, 7 * 6 do
			_G["CalendarDayButton" .. i]:GetNormalTexture():SetTexture(nil)
		end
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true, x1=1, y1=-2, x2=2, y2=-7}
		if self.modBtns then
			self:skinCloseButton{obj=_G.CalendarCloseButton}
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.CalendarPrevMonthButton, ofs=-1, y1=-2, x2=-2, clr="gold"}
			self:addButtonBorder{obj=_G.CalendarNextMonthButton, ofs=-1, y1=-2, x2=-2, clr="gold"}
			self:SecureHook("CalendarFrame_UpdateMonthOffsetButtons", function()
				self:clrBtnBdr(_G.CalendarPrevMonthButton, "gold")
				self:clrBtnBdr(_G.CalendarNextMonthButton, "gold")
			end)
			self:addButtonBorder{obj=_G.CalendarFilterButton, es=14, x1=3, y1=0, x2=3, y2=0}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.CalendarViewHolidayFrame, "OnShow", function(this)
		self:removeNineSlice(this.Border)
		self:skinSlider{obj=_G.CalendarViewHolidayScrollFrame.ScrollBar}
		self:removeRegions(_G.CalendarViewHolidayCloseButton, {5})
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true, hdr=true, x1=2, y1=-3, x2=-3, y2=-2}
		if self.modBtns then
			self:skinCloseButton{obj=_G.CalendarViewHolidayCloseButton}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.CalendarViewRaidFrame, "OnShow", function(this)
		self:removeNineSlice(this.Border)
		self:skinSlider{obj=_G.CalendarViewRaidScrollFrame.ScrollBar}
		self:removeRegions(_G.CalendarViewRaidCloseButton, {5})
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true, hdr=true, x1=2, y1=-3, x2=-3, y2=2}
		if self.modBtns then
			self:skinCloseButton{obj=_G.CalendarViewRaidCloseButton}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.CalendarViewEventFrame, "OnShow", function(this)
		self:removeNineSlice(this.Border)
		self:addSkinFrame{obj=_G.CalendarViewEventDescriptionContainer, ft=ftype}
		self:skinSlider{obj=_G.CalendarViewEventDescriptionScrollFrame.ScrollBar}
		self:keepFontStrings(_G.CalendarViewEventInviteListSection)
		self:skinSlider{obj=_G.CalendarViewEventInviteListScrollFrameScrollBar}
		self:addSkinFrame{obj=_G.CalendarViewEventInviteList, ft=ftype}
		self:removeRegions(_G.CalendarViewEventCloseButton, {5})
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true, hdr=true, x1=2, y1=-3, x2=-3, y2=2}
		if self.modBtns then
			self:skinCloseButton{obj=_G.CalendarViewEventCloseButton}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.CalendarCreateEventFrame, "OnShow", function(this)
		self:removeNineSlice(this.Border)
		_G.CalendarCreateEventIcon:SetAlpha(1) -- show event icon
		self:skinEditBox{obj=_G.CalendarCreateEventTitleEdit, regs={6}}
		self:skinDropDown{obj=_G.CalendarCreateEventTypeDropDown}
		self:skinDropDown{obj=_G.CalendarCreateEventHourDropDown, x2=-6}
		self:skinDropDown{obj=_G.CalendarCreateEventMinuteDropDown, x2=-6}
		self:skinDropDown{obj=_G.CalendarCreateEventAMPMDropDown, x2=-6}
		self:skinDropDown{obj=_G.CalendarCreateEventDifficultyOptionDropDown, x2=-16}
		self:addSkinFrame{obj=_G.CalendarCreateEventDescriptionContainer, ft=ftype}
		self:skinSlider{obj=_G.CalendarCreateEventDescriptionScrollFrame.ScrollBar}
		self:keepFontStrings(_G.CalendarCreateEventInviteListSection)
		self:skinSlider{obj=_G.CalendarCreateEventInviteListScrollFrameScrollBar}
		self:addSkinFrame{obj=_G.CalendarCreateEventInviteList, ft=ftype}
		self:skinEditBox{obj=_G.CalendarCreateEventInviteEdit, regs={6}}
		_G.CalendarCreateEventMassInviteButtonBorder:SetAlpha(0)
		_G.CalendarCreateEventRaidInviteButtonBorder:SetAlpha(0)
		_G.CalendarCreateEventCreateButtonBorder:SetAlpha(0)
		self:removeRegions(_G.CalendarCreateEventCloseButton, {5})
 		self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true, hdr=true, x1=2, y1=-3, x2=-3, y2=2}
		if self.modBtns then
			self:skinStdButton{obj=_G.CalendarCreateEventInviteButton}
			self:skinStdButton{obj=_G.CalendarCreateEventMassInviteButton}
			self:skinStdButton{obj=_G.CalendarCreateEventRaidInviteButton}
			self:skinStdButton{obj=_G.CalendarCreateEventCreateButton}
			self:skinCloseButton{obj=_G.CalendarCreateEventCloseButton}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.CalendarCreateEventAutoApproveCheck}
			self:skinCheckButton{obj=_G.CalendarCreateEventLockEventCheck}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.CalendarMassInviteFrame, "OnShow", function(this)
		self:removeNineSlice(this.Border)
		self:skinDropDown{obj=_G.CalendarMassInviteCommunityDropDown}
		self:skinEditBox{obj=_G.CalendarMassInviteMinLevelEdit, regs={6}}
		self:skinEditBox{obj=_G.CalendarMassInviteMaxLevelEdit, regs={6}}
		self:skinDropDown{obj=_G.CalendarMassInviteRankMenu}
		self:removeRegions(_G.CalendarMassInviteCloseButton, {5})
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true, hdr=true, x1=4, y1=-3, x2=-3, y2=20}
		if self.modBtns then
			self:skinStdButton{obj=_G.CalendarMassInviteAcceptButton}
			self:skinCloseButton{obj=_G.CalendarMassInviteCloseButton}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.CalendarEventPickerFrame, "OnShow", function(this)
		self:removeNineSlice(this.Border)
		self:keepFontStrings(_G.CalendarEventPickerFrame)
		self:skinSlider(_G.CalendarEventPickerScrollBar)
		self:removeRegions(_G.CalendarEventPickerCloseButton, {7})
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true, hdr=true, x1=2, y1=-3, x2=-3, y2=2}
		if self.modBtns then
			self:skinCloseButton{obj=_G.CalendarEventPickerCloseButton}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.CalendarTexturePickerFrame, "OnShow", function(this)
		self:removeNineSlice(this.Border)
		self:skinSlider(_G.CalendarTexturePickerScrollBar)
		_G.CalendarTexturePickerCancelButtonBorder:SetAlpha(0)
		_G.CalendarTexturePickerAcceptButtonBorder:SetAlpha(0)
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true, hdr=true, x1=5, y1=-3, x2=-3, y2=2}
		if self.modBtns then
			self:skinStdButton{obj=_G.CalendarTexturePickerCancelButton}
			self:skinStdButton{obj=_G.CalendarTexturePickerAcceptButton}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.CalendarClassButtonContainer, "OnShow", function(this)
		for i = 1, _G.MAX_CLASSES do -- allow for the total button
			self:removeRegions(_G["CalendarClassButton" .. i], {1})
			self:addButtonBorder{obj=_G["CalendarClassButton" .. i]}
		end
		-- Class Totals button, texture & size changes
		self:moveObject{obj=_G.CalendarClassTotalsButton, x=-2}
		_G.CalendarClassTotalsButton:SetSize(25, 25)
		self:applySkin{obj=_G.CalendarClassTotalsButton, ft=ftype, kfs=true, bba=self.modBtnBs and 1 or 0}

		self:Unhook(this, "OnShow")
	end)

-->>-- ContextMenus

end

aObj.blizzLoDFrames[ftype].ChallengesUI = function(self)
	if not self.prdb.ChallengesUI or self.initialized.ChallengesUI then return end
	self.initialized.ChallengesUI = true

	-- subframe of PVEFrame

	self:SecureHookScript(_G.ChallengesKeystoneFrame, "OnShow", function(this)
		this:DisableDrawLayer("BACKGROUND")
		this.RuneBG:SetTexture(nil)
		this.InstructionBackground:SetTexture(nil)
		this.Divider:SetTexture(nil)
		this.DungeonName:SetTextColor(self.BT:GetRGB())
		this.PowerLevel:SetTextColor(self.BT:GetRGB())
		this.RunesLarge:SetTexture(nil)
		this.RunesSmall:SetTexture(nil)
		this.SlotBG:SetTexture(nil)
		this.KeystoneFrame:SetTexture(nil)
		if self.modBtnBs then
			self:addButtonBorder{obj=this.KeystoneSlot}
		end
		if self.modBtns then
			self:skinStdButton{obj=this.StartButton}
		end
		self:addSkinFrame{obj=this, ft=ftype, ofs=-7}
		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.ChallengesFrame, "OnShow", function(this)
		this:DisableDrawLayer("BACKGROUND")
		self:removeInset(_G.ChallengesFrameInset)
		this.WeeklyInfo.Child:DisableDrawLayer("BACKGROUND")

		-- DungeonIcons
		if self.modBtnBs then
			for _, dungeon in _G.ipairs(this.DungeonIcons) do
				self:addButtonBorder{obj=dungeon, ofs=3, clr="disabled"}
				self:SecureHook(dungeon, "SetUp", function(this, mapInfo, _)
					-- BETA: Constant value changed
					if mapInfo.quality >= (_G.Enum.ItemQuality.Common)
					and _G.ITEM_QUALITY_COLORS[mapInfo.quality]
					then
						this.sbb:SetBackdropBorderColor(_G.ITEM_QUALITY_COLORS[mapInfo.quality].r, _G.ITEM_QUALITY_COLORS[mapInfo.quality].g, _G.ITEM_QUALITY_COLORS[mapInfo.quality].b, 1)
					else
						self:clrBtnBdr(this, "disabled")
					end
				end)
			end
		end

		-- SeasonChangeNoticeFrame
		this.SeasonChangeNoticeFrame.NewSeason:SetTextColor(self.HT:GetRGB())
		this.SeasonChangeNoticeFrame.SeasonDescription:SetTextColor(self.BT:GetRGB())
		this.SeasonChangeNoticeFrame.SeasonDescription2:SetTextColor(self.BT:GetRGB())
		this.SeasonChangeNoticeFrame.SeasonDescription3:SetTextColor(self.BT:GetRGB())
		this.SeasonChangeNoticeFrame.Affix.AffixBorder:SetTexture(nil)
		self:addSkinFrame{obj=this.SeasonChangeNoticeFrame, ft=ftype, kfs=true, nb=true, ofs=-15, y2=20}
		self:RaiseFrameLevelByFour(this.SeasonChangeNoticeFrame)
		if self.modBtns then
			self:skinStdButton{obj=this.SeasonChangeNoticeFrame.Leave}
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzLoDFrames[ftype].CharacterCustomize = function(self)
	if not self.prdb.CharacterCustomize or self.initialized.CharacterCustomize then return end
	self.initialized.CharacterCustomize = true

	self:SecureHookScript(_G.CharCustomizeFrame, "OnShow", function(this)

		-- Sexes
		self:SecureHook(_G.BarberShopFrame, "UpdateSex", function(this)
			for btn in this.sexButtonPool:EnumerateActive() do
				btn.Ring:SetTexture(nil)
				btn.BlackBG:SetTexture(nil)
			end
		end)

		-- AlteredForms
		self:SecureHook(this, "UpdateAlteredFormButtons", function(this)
			for btn in this.alteredFormsPools:EnumerateActive() do
				btn.Ring:SetTexture(nil)
			end
		end)

		-- Categories

		-- Options
		self:SecureHook(this, "UpdateOptionButtons", function(this, _)
			for btn in this.pools:GetPool("CharCustomizeShapeshiftFormButtonTemplate"):EnumerateActive() do
				btn.Ring:SetTexture(nil)
			end
			-- FIXME: Category buttons still have Ring texture, is it because it's in the original texture?
			for btn in this.pools:GetPool("CharCustomizeCategoryButtonTemplate"):EnumerateActive() do
				-- aObj:Debug("Category btn: [%s, %s]", btn, btn.categoryData)
				-- _G.Spew("", btn)
				-- _G.Spew("", btn.categoryData)
				btn.Ring:SetTexture(nil)
			end
			for frame in this.selectionPopoutPool:EnumerateActive() do
				self:removeNineSlice(frame.SelectionPopoutButton.Popout.Border)
				self:addSkinFrame{obj=frame.SelectionPopoutButton.Popout, ft=ftype, kfs=true, nb=true, ofs=-4}
				_G.RaiseFrameLevelByTwo(frame.SelectionPopoutButton.Popout) -- appear above other buttons
				-- resize frame
				frame.SelectionPopoutButton.Popout:Show()
				frame.SelectionPopoutButton.Popout:Hide()
				if self.modBtns then
					self:skinStdButton{obj=frame.SelectionPopoutButton, ofs=-5}
					-- ensure button skin is displayed first time
					frame.SelectionPopoutButton:Hide()
					frame.SelectionPopoutButton:Show()
				end
				if self.modBtnBs then
					self:addButtonBorder{obj=frame.IncrementButton, ofs=-2, x1=1, clr="gold"}
					self:addButtonBorder{obj=frame.DecrementButton, ofs=-2, x1=1, clr="gold"}
					self:secureHook(frame, "UpdateButtons", function(this)
						self:clrBtnBdr(frame.IncrementButton, "gold")
						self:clrBtnBdr(frame.DecrementButton, "gold")
					end)
				end
			end
		end)

		-- SmallButtons
		if self.modBtnBs then
			self:addButtonBorder{obj=this.RandomizeAppearanceButton, ofs=-4, x1=5, y2=5, clr="gold"}
			self:addButtonBorder{obj=this.SmallButtons.ResetCameraButton, ofs=-4, x1=5, y2=5, clr="gold"}
			self:addButtonBorder{obj=this.SmallButtons.ZoomOutButton, ofs=-4, x1=5, y2=5, clr="gold"}
			self:addButtonBorder{obj=this.SmallButtons.ZoomInButton, ofs=-4, x1=5, y2=5, clr="gold"}
			self:SecureHook(this, "UpdateZoomButtonStates", function(this)
				self:clrBtnBdr(this.SmallButtons.ZoomOutButton, "gold")
				self:clrBtnBdr(this.SmallButtons.ZoomInButton, "gold")

			end)
			self:addButtonBorder{obj=this.SmallButtons.RotateLeftButton, ofs=-4, x1=5, y2=5, clr="gold"}
			self:addButtonBorder{obj=this.SmallButtons.RotateRightButton, ofs=-4, x1=5, y2=5, clr="gold"}
		end

		if self.modBtns then
			self:skinStdButton{obj=_G.BarberShopFrame.CancelButton, ofs=0}
			self:skinStdButton{obj=_G.BarberShopFrame.ResetButton, ofs=0}
			self:skinStdButton{obj=_G.BarberShopFrame.AcceptButton, ofs=0}
		end

		-- tooltip
		_G.C_Timer.After(0.1, function()
			self:add2Table(self.ttList, _G.CharCustomizeTooltip)
			self:add2Table(self.ttList, _G.CharCustomizeNoHeaderTooltip)
		end)

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].ChatBubbles = function(self)
	if not self.prdb.ChatBubbles.skin or self.initialized.ChatBubbles then return end
	self.initialized.ChatBubbles = true

	-- N.B. ChatBubbles in Raids, Dungeons and Garrisons are fobidden and can't be skinned
	local function skinChatBubbles()
		_G.C_Timer.After(0.1, function()
			for _, cBubble in _G.pairs(_G.C_ChatBubbles.GetAllChatBubbles(false)) do
				if not aObj.isClsc then
					cBubble = aObj:getChild(cBubble, 1)
				end
				aObj:addSkinFrame{obj=cBubble, ft=ftype, kfs=true, nb=true, aso={ba=self.prdb.ChatBubbles.alpha, ng=true}, ofs=-8}
				-- Region 1 is ChatBubbleTail texture, region 2 is the font string
				if cBubble:GetNumRegions() == 2 then
					aObj:getRegion(cBubble, 2):SetParent(cBubble.sf) -- make text visible
				end
			end
		end)
	end
	 -- events which create chat bubbles
	local evtTab = {"CHAT_MSG_SAY", "CHAT_MSG_YELL", "CHAT_MSG_MONSTER_SAY", "CHAT_MSG_MONSTER_YELL", "CINEMATIC_START"}
	local function registerEvents()
		for _, event in _G.pairs(evtTab) do
			self:RegisterEvent(event, skinChatBubbles)
		end
	end
	local function unRegisterEvents()
		for _, event in _G.pairs(evtTab) do
			self:UnregisterEvent(event)
		end
	end
	-- if any chat bubbles options turned on
	if _G.GetCVarBool("chatBubbles")
	or _G.GetCVarBool("chatBubblesParty")
	then
		-- skin any existing ones
		registerEvents()
		skinChatBubbles()
	end
	-- hook this to handle changes
	self:SecureHook("InterfaceOptionsDisplayPanelChatBubblesDropDown_SetValue", function(this, value)
		-- unregister events
		unRegisterEvents()
		if value ~= 2 then -- either All or ExcludeParty
			registerEvents()
			skinChatBubbles()
		end
	end)

end

aObj.blizzFrames[ftype].ChatButtons = function(self)
	if not self.prdb.ChatButtons or self.initialized.ChatButtons then return end
	self.initialized.ChatButtons = true

	-- QuickJoinToastButton & frames (attached to ChatFrame)
	if self.modBtnBs then
		for i = 1, _G.NUM_CHAT_WINDOWS do
			self:addButtonBorder{obj=_G["ChatFrame" .. i].buttonFrame.minimizeButton, ofs=-2, clr="grey"}
			self:addButtonBorder{obj=_G["ChatFrame" .. i].ScrollToBottomButton, ofs=-1, x1=0, reParent={_G["ChatFrame" .. i].ScrollToBottomButton.Flash}, clr="grey"}
			_G["ChatFrame" .. i].buttonFrame.sknd = true
		end
		self:addButtonBorder{obj=_G.ChatFrameChannelButton, ofs=0, clr="grey"}
		self:addButtonBorder{obj=_G.ChatFrameToggleVoiceDeafenButton, ofs=0, clr="grey"}
		self:addButtonBorder{obj=_G.ChatFrameToggleVoiceMuteButton, ofs=0, clr="grey"}
		self:addButtonBorder{obj=_G.ChatFrameMenuButton, ofs=-2, x1=1, clr="grey"}
		-- QuickJoinToastButton(s)
		self:addButtonBorder{obj=_G.QuickJoinToastButton, x1=1, y1=2, x2=-3, y2=-3, clr="grey"}
		for _, type in _G.pairs{"Toast", "Toast2"} do
			_G.QuickJoinToastButton[type]:DisableDrawLayer("BACKGROUND")
			self:moveObject{obj=_G.QuickJoinToastButton[type], x=7}
			_G.QuickJoinToastButton[type]:Hide()
			self:addSkinFrame{obj=_G.QuickJoinToastButton[type], ft=ftype}
		end
		-- hook the animations to show or hide the QuickJoinToastButton frame(s)
		_G.QuickJoinToastButton.FriendToToastAnim:SetScript("OnPlay", function()
			_G.QuickJoinToastButton.Toast.sf:Show()
			_G.QuickJoinToastButton.Toast2.sf:Hide()

		end)
		_G.QuickJoinToastButton.ToastToToastAnim:SetScript("OnPlay", function()
			_G.QuickJoinToastButton.Toast.sf:Hide()
			_G.QuickJoinToastButton.Toast2.sf:Show()
		end)
		_G.QuickJoinToastButton.ToastToFriendAnim:SetScript("OnPlay", function()
			_G.QuickJoinToastButton.Toast.sf:Hide()
			_G.QuickJoinToastButton.Toast2.sf:Hide()
		end)
	end

end

aObj.blizzFrames[ftype].ChatConfig = function(self)
	if not self.prdb.ChatConfig or self.initialized.ChatConfig then return end
	self.initialized.ChatConfig = true

	self:SecureHookScript(_G.ChatConfigFrame, "OnShow", function(this)
		self:removeNineSlice(this.Border)
		self:skinObject("frame", {obj=_G.ChatConfigCategoryFrame, fType=ftype, kfs=true, fb=true})
		self:skinObject("frame", {obj=_G.ChatConfigBackgroundFrame, fType=ftype, kfs=true, fb=true})
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, hdr=true, ofs=-4, y1=0})
		if self.modBtns then
			self:skinStdButton{obj=this.DefaultButton}
			self:skinStdButton{obj=this.RedockButton}
			self:skinStdButton{obj=_G.CombatLogDefaultButton}
			self:skinStdButton{obj=_G.ChatConfigFrameCancelButton}
			self:skinStdButton{obj=_G.ChatConfigFrameOkayButton}
		end
		-- ChatTabManager
		self:skinObject("frame", {obj=_G.ChatConfigBackgroundFrame, fType=ftype, kfs=true, fb=true, x1=-5, y1=3, x2=725, y2=-512})
		local setTabState
		if aObj.isTT then
			function setTabState(tab)
				if tab:GetID() == _G.CURRENT_CHAT_FRAME_ID then
					aObj:setActiveTab(tab.sf)
				else
					aObj:setInactiveTab(tab.sf)
				end
				tab.sf:Show()
			end
		else
			function setTabState(tab)
				tab.sf:Show()
			end
		end
		local tabSkin = self.skinTPLs.new("tabs", {obj=this.ChatTabManager, tabs={}, fType=ftype, ignoreSize=true, offsets={x1=0, y1=-6, x2=0, y2=-4}, regions={11}, noCheck=true, func=setTabState})
		local function skinTabs(ctm)
			_G.wipe(tabSkin.tabs)
			for tab in ctm.tabPool:EnumerateActive() do
				aObj:add2Table(tabSkin.tabs, tab)
			end
			aObj:skinObject(tabSkin)
		end
		skinTabs(this.ChatTabManager)
		self:SecureHook(this.ChatTabManager, "OnShow", function(this)
			skinTabs(this)
		end)
		self:SecureHook(this.ChatTabManager, "UpdateSelection", function(this, _)
			skinTabs(this)
		end)
		local function skinCB(cBox)
			aObj:removeBackdrop(_G[cBox])
			if aObj.modChkBtns then
				local box
				for _, suffix in _G.pairs{"", "Check", "ColorSwatch"} do
					box = _G[cBox .. suffix]
					if box
					and box:IsObjectType("CHECKBUTTON")
					then
						aObj:skinCheckButton{obj=box}
					end
				end
				box = nil
			end
		end
		--	Chat Settings
		for i = 1, #_G.CHAT_CONFIG_CHAT_LEFT do
			skinCB("ChatConfigChatSettingsLeftCheckBox" .. i)
		end
		self:skinObject("frame", {obj=_G.ChatConfigChatSettingsLeft, fType=ftype, kfs=true, fb=true})
		--	Channel Settings
		self:skinObject("frame", {obj=_G.ChatConfigChannelSettingsLeft, fType=ftype, kfs=true, fb=true})
		if not self.isClsc then
			self:SecureHookScript(_G.ChatConfigChannelSettings, "OnShow", function(this)
				for i = 1, #_G.CHAT_CONFIG_CHANNEL_LIST do
					skinCB("ChatConfigChannelSettingsLeftCheckBox" .. i)
				end

				self:Unhook(this, "OnShow")
			end)
		else
			self:skinObject("frame", {obj==_G.ChatConfigChannelSettingsAvailable, fType=ftype, kfs=true})
			self:SecureHook("ChatConfig_CreateCheckboxes", function(frame, _)
				local box
				for i = 1, #frame.checkBoxTable do
					box = _G[frame:GetName() .. "CheckBox" .. i]
					self:removeBackdrop(box)
					if self.modChkBtns then
						 self:skinCheckButton{obj=box.CheckButton}
					end
				end
				box = nil
			end)
			self:SecureHook("ChatConfig_CreateBoxes", function(frame, _)
				local box
				for i = 1, #frame.boxTable do
					box = _G[frame:GetName() .. "Box" .. i]
					self:removeBackdrop(box)
					if self.modBtns then
						self:skinStdButton{obj=box.Button, ofs=0}
					end
				end
				box = nil
			end)
		end
		--	Other Settings
		for i = 1, #_G.CHAT_CONFIG_OTHER_COMBAT do
			skinCB("ChatConfigOtherSettingsCombatCheckBox" .. i)
		end
		self:skinObject("frame", {obj=_G.ChatConfigOtherSettingsCombat, fType=ftype, kfs=true, fb=true})
		for i = 1, #_G.CHAT_CONFIG_OTHER_PVP do
			skinCB("ChatConfigOtherSettingsPVPCheckBox" .. i)
		end
		self:skinObject("frame", {obj=_G.ChatConfigOtherSettingsPVP, fType=ftype, kfs=true, fb=true})
		for i = 1, #_G.CHAT_CONFIG_OTHER_SYSTEM do
			skinCB("ChatConfigOtherSettingsSystemCheckBox" .. i)
		end
		self:skinObject("frame", {obj=_G.ChatConfigOtherSettingsSystem, fType=ftype, kfs=true, fb=true})
		for i = 1, #_G.CHAT_CONFIG_CHAT_CREATURE_LEFT do
			skinCB("ChatConfigOtherSettingsCreatureCheckBox" .. i)
		end
		self:skinObject("frame", {obj=_G.ChatConfigOtherSettingsCreature, fType=ftype, kfs=true, fb=true})
		--	Combat Settings
		-- Filters
		_G.ChatConfigCombatSettingsFiltersScrollFrameScrollBarBorder:Hide()
		self:skinObject("slider", {obj=_G.ChatConfigCombatSettingsFiltersScrollFrameScrollBar, fType=ftype})
		if self.modBtns then
			self:skinStdButton{obj=_G.ChatConfigCombatSettingsFiltersDeleteButton}
			self:skinStdButton{obj=_G.ChatConfigCombatSettingsFiltersAddFilterButton}
			self:skinStdButton{obj=_G.ChatConfigCombatSettingsFiltersCopyFilterButton}
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.ChatConfigMoveFilterUpButton, es=12, ofs=-5, x2=-6, y2=7, clr="grey"}
			self:addButtonBorder{obj=_G.ChatConfigMoveFilterDownButton, es=12, ofs=-5, x2=-6, y2=7, clr="grey"}
		end
		self:skinObject("frame", {obj=_G.ChatConfigCombatSettingsFilters, fType=ftype, kfs=true, fb=true})
		_G.LowerFrameLevel(_G.ChatConfigCombatSettingsFilters) -- make frame appear below tab texture
		-- Message Sources
		for i = 1, #_G.COMBAT_CONFIG_MESSAGESOURCES_BY do
			skinCB("CombatConfigMessageSourcesDoneByCheckBox" .. i)
		end
		self:skinObject("frame", {obj=_G.CombatConfigMessageSourcesDoneBy, fType=ftype, kfs=true, fb=true})
		for i = 1, #_G.COMBAT_CONFIG_MESSAGESOURCES_TO do
			skinCB("CombatConfigMessageSourcesDoneToCheckBox" .. i)
		end
		self:skinObject("frame", {obj=_G.CombatConfigMessageSourcesDoneTo, fType=ftype, kfs=true, fb=true})
		-- Message Type
		for i, val in _G.ipairs(_G.COMBAT_CONFIG_MESSAGETYPES_LEFT) do
			skinCB("CombatConfigMessageTypesLeftCheckBox" .. i)
			if val.subTypes then
				for k, _ in _G.pairs(val.subTypes) do
					skinCB("CombatConfigMessageTypesLeftCheckBox" .. i .. "_" .. k)
				end
			end
		end
		for i, val in _G.ipairs(_G.COMBAT_CONFIG_MESSAGETYPES_RIGHT) do
			skinCB("CombatConfigMessageTypesRightCheckBox" .. i)
			if val.subTypes then
				for k, _ in _G.pairs(val.subTypes) do
					skinCB("CombatConfigMessageTypesRightCheckBox" .. i .. "_" .. k)
				end
			end
		end
		for i, val in _G.ipairs(_G.COMBAT_CONFIG_MESSAGETYPES_MISC) do
			skinCB("CombatConfigMessageTypesMiscCheckBox" .. i)
			if val.subTypes then
				for k, _ in _G.pairs(val.subTypes) do
					skinCB("CombatConfigMessageTypesMiscCheckBox" .. i .. "_" .. k)
				end
			end
		end
		-- Colors
		for i = 1, #_G.COMBAT_CONFIG_UNIT_COLORS do
			self:removeBackdrop(_G["CombatConfigColorsUnitColorsSwatch" .. i])
		end
		self:skinObject("frame", {obj=_G.CombatConfigColorsUnitColors, fType=ftype, kfs=true, fb=true})
		self:skinObject("frame", {obj=_G.CombatConfigColorsHighlighting, fType=ftype, kfs=true, fb=true})
		self:skinObject("frame", {obj=_G.CombatConfigColorsColorizeUnitName, fType=ftype, kfs=true, fb=true})
		self:skinObject("frame", {obj=_G.CombatConfigColorsColorizeSpellNames, fType=ftype, kfs=true, fb=true})
		self:skinObject("frame", {obj=_G.CombatConfigColorsColorizeDamageNumber, fType=ftype, kfs=true, fb=true})
		self:skinObject("frame", {obj=_G.CombatConfigColorsColorizeDamageSchool, fType=ftype, kfs=true, fb=true})
		self:skinObject("frame", {obj=_G.CombatConfigColorsColorizeEntireLine, fType=ftype, kfs=true, fb=true})
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.CombatConfigColorsHighlightingLine}
			self:skinCheckButton{obj=_G.CombatConfigColorsHighlightingAbility}
			self:skinCheckButton{obj=_G.CombatConfigColorsHighlightingDamage}
			self:skinCheckButton{obj=_G.CombatConfigColorsHighlightingSchool}
			self:skinCheckButton{obj=_G.CombatConfigColorsColorizeUnitNameCheck}
			self:skinCheckButton{obj=_G.CombatConfigColorsColorizeSpellNamesCheck}
			self:skinCheckButton{obj=_G.CombatConfigColorsColorizeSpellNamesSchoolColoring}
			self:skinCheckButton{obj=_G.CombatConfigColorsColorizeDamageNumberCheck}
			self:skinCheckButton{obj=_G.CombatConfigColorsColorizeDamageNumberSchoolColoring}
			self:skinCheckButton{obj=_G.CombatConfigColorsColorizeDamageSchoolCheck}
			self:skinCheckButton{obj=_G.CombatConfigColorsColorizeEntireLineCheck}
			-- Formatting
			self:skinCheckButton{obj=_G.CombatConfigFormattingShowTimeStamp}
			self:skinCheckButton{obj=_G.CombatConfigFormattingFullText}
			if not self.isClsc then
				self:skinCheckButton{obj=_G.CombatConfigFormattingShowBraces}
				self:skinCheckButton{obj=_G.CombatConfigFormattingUnitNames}
				self:skinCheckButton{obj=_G.CombatConfigFormattingSpellNames}
				self:skinCheckButton{obj=_G.CombatConfigFormattingItemNames}
			end
		end
		-- Settings
		self:skinObject("editbox", {obj=_G.CombatConfigSettingsNameEditBox, fType=ftype})
		if self.modBtns then
			self:skinStdButton{obj=_G.CombatConfigSettingsSaveButton}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.CombatConfigSettingsShowQuickButton}
			self:skinCheckButton{obj=_G.CombatConfigSettingsSolo}
			self:skinCheckButton{obj=_G.CombatConfigSettingsParty}
			self:skinCheckButton{obj=_G.CombatConfigSettingsRaid}
		end
		self:skinObject("tabs", {obj=_G.ChatConfigCombatSettings, prefix="CombatConfig", numTabs=#_G.COMBAT_CONFIG_TABS, fType=ftype, ignoreSize=true, lod=true, offsets={x1=0, y1=-8, x2=-2, y2=-4}, regions={4, 5}, track=false})
		if self.isTT then
			self:SecureHook("ChatConfig_UpdateCombatTabs", function(selectedTabID)
				local tab
				for i = 1, #_G.COMBAT_CONFIG_TABS do
					tab = _G[_G.CHAT_CONFIG_COMBAT_TAB_NAME .. i]
					if i == selectedTabID then
						self:setActiveTab(tab.sf)
					else
						self:setInactiveTab(tab.sf)
					end
				end
				tab = nil
			end)
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].ChatEditBox = function(self)
	if not self.prdb.ChatEditBox.skin or self.initialized.ChatEditBox then return end
	self.initialized.ChatEditBox = true

	if _G.IsAddOnLoaded("NeonChat")
	or _G.IsAddOnLoaded("Chatter")
	or _G.IsAddOnLoaded("Prat-3.0")
	then
		self.blizzFrames[ftype].ChatEditBox = nil
		return
	end

	for i = 1, _G.NUM_CHAT_WINDOWS do
		skinChatEB(_G["ChatFrame" .. i].editBox)
	end
	-- if editBox has a skin frame then hook these to manage its Alpha setting
	if self.prdb.ChatEditBox.style ~= 2 then
		local function setAlpha(eBox)
			if eBox
			and eBox.sf
			then
				eBox.sf:SetAlpha(eBox:GetAlpha())
			end
		end
		self:SecureHook("ChatEdit_ActivateChat", function(editBox)
			setAlpha(editBox)
		end)
		self:SecureHook("ChatEdit_DeactivateChat", function(editBox)
			setAlpha(editBox)
		end)
	end

end

aObj.blizzFrames[ftype].ChatFrames = function(self)
	if not self.prdb.ChatFrames or self.initialized.ChatFrames then return end
	self.initialized.ChatFrames = true

	for i = 1, _G.NUM_CHAT_WINDOWS do
		self:skinObject("frame", {obj=_G["ChatFrame" .. i], fType=ftype, ofs=6, y1=_G["ChatFrame" .. i] == _G.COMBATLOG and 30, x2=27, y2=-9})
	end

	-- CombatLog Quick Button Frame & Progress Bar
	if self.prdb.CombatLogQBF then
		if _G.CombatLogQuickButtonFrame_Custom then
			_G.CombatLogQuickButtonFrame_Custom:DisableDrawLayer("BACKGROUND")
			self:skinObject("frame", {obj=_G.CombatLogQuickButtonFrame_Custom, fType=ftype, ofs=0, x1=-3, x2=3})
			self:adjHeight{obj=_G.CombatLogQuickButtonFrame_Custom, adj=4}
			self:skinStatusBar{obj=_G.CombatLogQuickButtonFrame_CustomProgressBar, fi=0, bgTex=_G.CombatLogQuickButtonFrame_CustomTexture}
		else
			self:skinStatusBar{obj=_G.CombatLogQuickButtonFrameProgressBar, fi=0, bgTex=_G.CombatLogQuickButtonFrameTexture}
		end
	end

end

aObj.blizzFrames[ftype].ChatMenus = function(self)
	if not self.prdb.ChatMenus or self.initialized.ChatMenus then return end
	self.initialized.ChatMenus = true

	self:skinObject("frame", {obj=_G.ChatMenu, fType=ftype, ofs=0})
	self:skinObject("frame", {obj=_G.EmoteMenu, fType=ftype, ofs=0})
	self:skinObject("frame", {obj=_G.LanguageMenu, fType=ftype, ofs=0})
	self:skinObject("frame", {obj=_G.VoiceMacroMenu, fType=ftype, ofs=0})
	self:skinObject("frame", {obj=_G.GeneralDockManagerOverflowButtonList, fType=ftype, ofs=0})

end

aObj.blizzFrames[ftype].ChatMinimizedFrames = function(self)

	-- minimized chat frames
	self:SecureHook("FCF_CreateMinimizedFrame", function(chatFrame)
		_G[chatFrame:GetName() .. "Minimized"]:DisableDrawLayer("BACKGROUND")
		self:skinObject("frame", {obj=_G[chatFrame:GetName() .. "Minimized"], fType=ftype, kfs=true, ofs=-2, x2=-1})
		if self.modBtnBs then
			self:addButtonBorder{obj=_G[chatFrame:GetName() .. "MinimizedMaximizeButton"], ofs=-1}
		end
	end)

end

aObj.blizzFrames[ftype].ChatTabs = function(self)
	if not self.prdb.ChatTabs or self.initialized.ChatTabs then return end
	self.initialized.ChatTabs = true

	local fcfTabs = {}
	for i = 1, _G.NUM_CHAT_WINDOWS do
		self:add2Table(fcfTabs, _G["ChatFrame" .. i .. "Tab"])
		self:SecureHook(_G["ChatFrame" .. i .. "Tab"], "SetParent", function(this, parent)
			if parent == _G.GeneralDockManager.scrollFrame.child then
				this.sf:SetParent(_G.GeneralDockManager)
			else
				this.sf:SetParent(this)
				this.sf:SetFrameLevel(1) -- reset frame level so that the texture is behind text etc
			end
		end)
		-- hook this to manage alpha changes when chat frame fades in and out
		self:SecureHook(_G["ChatFrame" .. i .. "Tab"], "SetAlpha", function(this, alpha)
			this.sf:SetAlpha(alpha)
		end)
	end
	self:skinObject("tabs", {obj=_G.FloatingChatFrameManager, tabs=fcfTabs, fType=ftype, ignoreSize=true, lod=true, regions={7, 11}, offsets={x1=2, y1=-9, x2=-2, y2=-4}, track=false})
	fcfTabs = nil
	if self.isTT then
		self:SecureHook("FCF_Tab_OnClick", function(this, button)
			for i = 1, _G.NUM_CHAT_WINDOWS do
				self:setInactiveTab(_G["ChatFrame" .. i .. "Tab"].sf)
			end
			self:setActiveTab(this.sf)
		end)
	end

	if self.prdb.ChatTabsFade then
		-- hook this to hide/show the skin frame
		self:SecureHook("FCFTab_UpdateColors", function(this, selected)
			if this.sf then this.sf:SetShown(selected) end
		end)
	end

end

aObj.blizzFrames[ftype].ChatTemporaryWindow = function(self)
	if not self.prdb.ChatTabs
	and not self.prdb.ChatFrames
	and not self.prdb.ChatEditBox.skin
	then
		return
	end

	local function skinTempWindow(obj)
		if aObj.prdb.ChatTabs then
			aObj:skinObject("tabs", {obj=obj, fType=ftype, tabs={_G[obj:GetName() .. "Tab"]}, lod=true, regions={7, 11}, offsets={x1=2, y1=-9, x2=-2, y2=-4}, track=false})
		end
		if aObj.prdb.ChatFrames	then
			aObj:skinObject("frame", {obj=obj, fType=ftype, ofs=6, x2=27, y2=-9})
		end
		if aObj.prdb.ChatEditBox.skin then
			skinChatEB(obj.editBox)
		end
		if aObj.prdb.ChatButtons
		and aObj.modBtnBs
		then
			aObj:addButtonBorder{obj=obj.buttonFrame.minimizeButton, ofs=-2, clr="grey"}
			aObj:addButtonBorder{obj=obj.ScrollToBottomButton, ofs=-1, x1=0, reParent={obj.ScrollToBottomButton.Flash}, clr="grey"}
		end
	end
	-- hook this to handle Temporary windows (BN Conversations, Pet Battles etc)
	self:RawHook("FCF_OpenTemporaryWindow", function(...)
		local frame = self.hooks.FCF_OpenTemporaryWindow(...)
		skinTempWindow(frame)
		return frame
	end, true)
	-- skin any existing temporary windows
	for i = 1, #_G.CHAT_FRAMES do
		if _G[_G.CHAT_FRAMES[i]].isTemporary then
			skinTempWindow(_G[_G.CHAT_FRAMES[i]])
		end
	end

end

aObj.blizzFrames[ftype].CinematicFrame = function(self)
	if not self.prdb.CinematicFrame or self.initialized.CinematicFrame then return end
	self.initialized.CinematicFrame = true

	self:SecureHookScript(_G.CinematicFrame, "OnShow", function(this)
		self:removeNineSlice(this.closeDialog.Border)
		self:addSkinFrame{obj=this.closeDialog, ft=ftype, nb=true}
		if self.modBtns then
			self:skinStdButton{obj=_G.CinematicFrameCloseDialogConfirmButton}
			self:skinStdButton{obj=_G.CinematicFrameCloseDialogResumeButton}
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzLoDFrames[ftype].ClassTrial = function(self)
	if not self.prdb.ClassTrial or self.initialized.ClassTrial then return end
	self.initialized.ClassTrial = true

	-- N.B. ClassTrialSecureFrame can't be skinned, as the XML has a ScopedModifier element saying forbidden=""

	self:SecureHookScript(_G.ClassTrialThanksForPlayingDialog, "OnShow", function(this)
		this.ThanksText:SetTextColor(self.HT:GetRGB())
		this.ClassNameText:SetTextColor(self.HT:GetRGB())
		this.DialogFrame:SetTexture(nil)
		self:addSkinFrame{obj=this, ft=ftype, nb=true, x1=600, y1=-100, x2=-600, y2=500}
		if self.modBtns then
			self:skinStdButton{obj=this.BuyCharacterBoostButton}
			self:skinStdButton{obj=this.DecideLaterButton}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.ClassTrialTimerDisplay, "OnShow", function(this)
		-- create a Hourglass texture as per original Artwork
		this.Hourglass = this:CreateTexture(nil, "ARTWORK", nil)
		this.Hourglass:SetTexture([[Interface\Common\mini-hourglass]])
		this.Hourglass:SetPoint("LEFT", 20, 0)
		this.Hourglass:SetSize(30, 30)
		this:DisableDrawLayer("BACKGROUND")
		self:addSkinFrame{obj=this, ft=ftype}

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].CoinPickup = function(self)
	if not self.prdb.CoinPickup or self.initialized.CoinPickup then return end
	self.initialized.CoinPickup = true

	self:SecureHookScript(_G.CoinPickupFrame, "OnShow", function(this)
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, x1=9, y1=-12, x2=-6, y2=12}

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].ColorPicker = function(self)
	if not self.prdb.Colours or self.initialized.Colours then return end
	self.initialized.Colours = true

	self:SecureHookScript(_G.ColorPickerFrame, "OnShow", function(this)
		self:removeNineSlice(this.Border)
		self:skinObject("slider", {obj=_G.OpacitySliderFrame, fType=ftype})
		self:skinObject("frame", {obj=this, fType=ftype, hdr=true, ofs=0})
		if self.modBtns then
			self:skinStdButton{obj=_G.ColorPickerOkayButton}
			self:skinStdButton{obj=_G.ColorPickerCancelButton}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.OpacityFrame, "OnShow", function(this)
		-- used by BattlefieldMinimap amongst others
		self:removeNineSlice(this.Border)
		self:skinObject("slider", {obj=_G.OpacityFrameSlider, fType=ftype})
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ofs=0, y1=-1})

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].Console = function(self)
	if not self.prdb.Console or self.initialized.Console then return end
	self.initialized.Console = true

	self:SecureHookScript(_G.DeveloperConsole, "OnShow", function(this)
		local r, g, b, a = self.bbClr:GetRGBA()

		self:getChild(this.EditBox, 1).BorderTop:SetColorTexture(r, g, b, a)
		self:getChild(this.EditBox, 1).BorderBottom:SetColorTexture(r, g, b, a)

		this.Filters.BorderLeft:SetColorTexture(r, g, b, a)
		self:getChild(this.Filters, 1).BorderTop:SetColorTexture(r, g, b, a)
		self:getChild(this.Filters, 1).BorderBottom:SetColorTexture(r, g, b, a)

		this.AutoComplete.BorderTop:SetColorTexture(r, g, b, a)
		this.AutoComplete.BorderRight:SetColorTexture(r, g, b, a)
		this.AutoComplete.BorderLeft:SetColorTexture(r, g, b, a)
		this.AutoComplete.BorderBottom:SetColorTexture(r, g, b, a)
		this.AutoComplete.Tooltip.BorderTop:SetColorTexture(r, g, b, a)
		this.AutoComplete.Tooltip.BorderRight:SetColorTexture(r, g, b, a)
		this.AutoComplete.Tooltip.BorderLeft:SetColorTexture(r, g, b, a)
		this.AutoComplete.Tooltip.BorderBottom:SetColorTexture(r, g, b, a)

		r, g, b, a = nil, nil, nil, nil

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzLoDFrames[ftype].Contribution = function(self)
	if not self.prdb.Contribution or self.initialized.Contribution then return end
	self.initialized.Contribution = true

	self:SecureHookScript(_G.ContributionCollectionFrame, "OnShow", function(this)
		for contribution in this.contributionPool:EnumerateActive() do
			contribution.Header:DisableDrawLayer("BORDER")
			contribution.Header.Text:SetTextColor(self.HT:GetRGB())
			contribution.State.Border:SetAlpha(0) -- texture is changed
			contribution.State.TextBG:SetTexture(nil)
			self:skinStatusBar{obj=contribution.Status, fi=0}
			contribution.Status.Border:SetTexture(nil)
			contribution.Status.BG:SetTexture(nil)
			contribution.Description:SetTextColor(self.BT:GetRGB())
			self:skinStdButton{obj=contribution.ContributeButton}
		end
		for reward in this.rewardPool:EnumerateActive() do
			reward.RewardName:SetTextColor(self.BT:GetRGB())
		end
		this.CloseButton.CloseButtonBackground:SetTexture(nil)
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ofs=-21, x2=-18}

		self:Unhook(this, "OnShow")
	end)
	-- skin Contributions

	-- tooltips
	_G.C_Timer.After(0.1, function()
		self:add2Table(self.ttList, _G.ContributionBuffTooltip)
	end)

end

aObj.blizzFrames[ftype].CovenantToasts = function(self)
	if not self.prdb.CovenantToasts or self.initialized.CovenantToasts then return end
	self.initialized.CovenantToasts = true

	self:SecureHookScript(_G.CovenantChoiceToast, "OnShow", function(this)
		this.ToastBG:SetTexture(nil)

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.CovenantRenownToast, "OnShow", function(this)
		this.ToastBG:SetTexture(nil)
		this.GlowLineTopBottom:SetTexture(nil)
		this.RewardIconRing:SetTexture(nil)

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzLoDFrames[ftype].DeathRecap = function(self)
	if not self.prdb.DeathRecap or self.initialized.DeathRecap then return end
	self.initialized.DeathRecap = true

	self:SecureHookScript(_G.DeathRecapFrame, "OnShow", function(this)
		this:DisableDrawLayer("BORDER")
		this.Background:SetTexture(nil)
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true, ofs=-1, y1=-2}
		if self.modBtns then
			self:skinCloseButton{obj=this.CloseXButton}
			self:skinStdButton{obj=this.CloseButton}
		end
		_G.RaiseFrameLevelByTwo(this)

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzLoDFrames[ftype].DebugTools = function(self)
	if not self.prdb.DebugTools or self.initialized.DebugTools then return end
	self.initialized.DebugTools = true

	self:SecureHookScript(_G.EventTraceFrame, "OnShow", function(this)
		self:skinSlider{obj=_G.EventTraceFrameScroll}
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, x1=1, y1=-2, x2=-1, y2=4}
		if self.modBtns then
			self:SecureHook("EventTraceFrame_Update", function()
				for i = 1, #_G.EventTraceFrame.buttons do
					self:skinCloseButton{obj=_G.EventTraceFrame.buttons[i].HideButton, aso={bd=5, bba=0}}
				end

			end)
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.TableAttributeDisplay, "OnShow", function(this)
		local function skinTAD(frame)
			aObj:skinEditBox{obj=frame.FilterBox, regs={6, 7}, mi=true} -- 6 is text, 7 is icon
			aObj:skinSlider{obj=frame.LinesScrollFrame.ScrollBar}
			aObj:addFrameBorder{obj=frame.ScrollFrameArt, ft=ftype, ofs=0}
			aObj:addSkinFrame{obj=frame, ft=ftype, kfs=true, ofs=-2, x1=3, x2=-1}
			-- skin control buttons ?
			-- OpenParentButton
			-- NavigateBackwardsButton
			-- NavigateForwardsButton
			-- DuplicateButton
			if aObj.modChkBtns then
				aObj:skinCheckButton{obj=frame.VisibilityButton}
				aObj:skinCheckButton{obj=frame.HighlightButton}
				aObj:skinCheckButton{obj=frame.DynamicUpdateButton}
			end
		end
		skinTAD(this)
		-- hook this to skin subsequent frames
		self:RawHook("DisplayTableInspectorWindow", function(focusedTable, customTitle, tableFocusedCallback)
			local frame = self.hooks.DisplayTableInspectorWindow(focusedTable, customTitle, tableFocusedCallback)
			skinTAD(frame)
			return frame
		end, true)

		self:Unhook(this, "OnShow")
	end)

	-- tooltips
	_G.C_Timer.After(0.1, function()
		self:add2Table(self.ttList, _G.FrameStackTooltip)
		self:add2Table(self.ttList, _G.EventTraceTooltip)
	end)

end

aObj.blizzFrames[ftype].DestinyFrame = function(self)
	if not self.prdb.DestinyFrame or self.initialized.DestinyFrame then return end
	self.initialized.DestinyFrame = true

	self:SecureHookScript(_G.DestinyFrame, "OnShow", function(this)
		this.alphaLayer:SetColorTexture(0, 0, 0, 0.70)
		this.background:SetTexture(nil)
		this.frameHeader:SetTextColor(self.HT:GetRGB())
		_G.DestinyFrameAllianceLabel:SetTextColor(self.BT:GetRGB())
		_G.DestinyFrameHordeLabel:SetTextColor(self.BT:GetRGB())
		_G.DestinyFrameLeftOrnament:SetTexture(nil)
		_G.DestinyFrameRightOrnament:SetTexture(nil)
		this.allianceText:SetTextColor(self.BT:GetRGB())
		this.hordeText:SetTextColor(self.BT:GetRGB())
		_G.DestinyFrameAllianceFinalText:SetTextColor(self.BT:GetRGB())
		_G.DestinyFrameHordeFinalText:SetTextColor(self.BT:GetRGB())

		-- buttons
		for _, type in _G.pairs{"alliance", "horde"} do
			self:removeRegions(this[type .. "Button"], {1})
			self:changeRecTex(this[type .. "Button"]:GetHighlightTexture())
			self:adjWidth{obj=this[type .. "Button"], adj=-60}
			self:adjHeight{obj=this[type .. "Button"], adj=-60}
			self:skinStdButton{obj=this[type .. "Button"], x1=-2, y1=2, x2=-3, y2=-1}
		end

		self:Unhook(this, "OnShow")
	end)

end

-- this code handles the ExtraActionBarFrame and ZoneAbilityFrame buttons
aObj.blizzFrames[ftype].ExtraAbilityContainer = function(self)
	if self.initialized.ExtraAbilityContainer then return end
	self.initialized.ExtraAbilityContainer = true

	local function skinBtn(btn, secure)
		if btn:IsForbidden() then return end
		-- handle in combat
		if btn:IsProtected()
		and _G.InCombatLockdown()
		then
		    aObj:add2Table(aObj.oocTab, {skinBtn, {btn, secure}})
		    return
		end
		btn:GetNormalTexture():SetTexture(nil)
		if aObj.modBtnBs then
			aObj:addButtonBorder{obj=btn, seca=secure, ofs=2, reParent={btn.Count, btn.HotKey and btn.HotKey}}
		end
	end
	if self.prdb.MainMenuBar.extraab then
		self:SecureHookScript(_G.ExtraActionBarFrame.intro, "OnFinished", function(this)
			_G.ExtraActionBarFrame.button.style:SetAlpha(0)
		end)
		skinBtn(_G.ExtraActionBarFrame.button, true)
	end
	if self.prdb.ZoneAbility then
		local function getAbilities(frame)
			for btn in frame.SpellButtonContainer:EnumerateActive() do
				skinBtn(btn)
			end
		end
		self:SecureHook(_G.ZoneAbilityFrame, "UpdateDisplayedZoneAbilities", function(this)
			this.Style:SetAlpha(0)
			getAbilities(this)
		end)
		if _G.ZoneAbilityFrame:IsShown() then
			_G.ZoneAbilityFrame.Style:SetAlpha(0)
			getAbilities(_G.ZoneAbilityFrame)
		end
	end

end

-- N.B. The following function has been separated from the GarrisonUI skin code as it is used by several Quest Frames
aObj.blizzFrames[ftype].GarrisonTooltips = function(self)
	if not self.prdb.GarrisonUI then return end

	self:SecureHookScript(_G.GarrisonFollowerTooltip, "OnShow", function(this)
		this.PortraitFrame.PortraitRing:SetTexture(nil)
		this.PortraitFrame.LevelBorder:SetAlpha(0)
		_G.C_Timer.After(0.1, function() self:add2Table(self.ttList, this) end)

		self:Unhook(this, "OnShow")
	end)
	self:SecureHookScript(_G.GarrisonFollowerAbilityTooltip, "OnShow", function(this)
		this.CounterIconBorder:SetTexture(nil)
		_G.C_Timer.After(0.1, function() self:add2Table(self.ttList, this) end)

		self:Unhook(this, "OnShow")
	end)
	self:SecureHookScript(_G.GarrisonFollowerAbilityWithoutCountersTooltip, "OnShow", function(this)
		_G.C_Timer.After(0.1, function() self:add2Table(self.ttList, this) end)

		self:Unhook(this, "OnShow")
	end)
	self:SecureHookScript(_G.GarrisonFollowerMissionAbilityWithoutCountersTooltip, "OnShow", function(this)
		_G.C_Timer.After(0.1, function() self:add2Table(self.ttList, this) end)

		self:Unhook(this, "OnShow")
	end)
	self:SecureHookScript(_G.GarrisonShipyardFollowerTooltip, "OnShow", function(this)
		_G.C_Timer.After(0.1, function() self:add2Table(self.ttList, this) end)

		self:Unhook(this, "OnShow")
	end)
	self:SecureHookScript(_G.FloatingGarrisonFollowerTooltip, "OnShow", function(this)
		this.PortraitFrame.PortraitRing:SetTexture(nil)
		this.PortraitFrame.LevelBorder:SetAlpha(0)
		_G.C_Timer.After(0.1, function() self:add2Table(self.ttList, this) end)

		self:Unhook(this, "OnShow")
	end)
	self:SecureHookScript(_G.FloatingGarrisonShipyardFollowerTooltip, "OnShow", function(this)
		_G.C_Timer.After(0.1, function() self:add2Table(self.ttList, this) end)

		self:Unhook(this, "OnShow")
	end)
	self:SecureHookScript(_G.FloatingGarrisonFollowerAbilityTooltip, "OnShow", function(this)
		this.CounterIconBorder:SetTexture(nil)
		_G.C_Timer.After(0.1, function() self:add2Table(self.ttList, this) end)

		self:Unhook(this, "OnShow")
	end)
	self:SecureHookScript(_G.FloatingGarrisonMissionTooltip, "OnShow", function(this)
		_G.C_Timer.After(0.1, function() self:add2Table(self.ttList, this) end)

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzLoDFrames[ftype].GarrisonUI = function(self)
	-- RequiredDep: Blizzard_GarrisonTemplates
	if not self.prdb.GarrisonUI or self.initialized.GarrisonUI then return end

	-- wait until all frames are created
	if not _G._G.GarrisonRecruiterFrame then
		_G.C_Timer.After(0.1, function()
			self.blizzLoDFrames[ftype].GarrisonUI(self)
		end)
		return
	end

	self.initialized.GarrisonUI = true

	self.garrisonType = _G.C_Garrison.GetLandingPageGarrisonType()
	-- aObj:Debug("garrisonType: [%s, %s]", _G.C_Garrison.GetLandingPageGarrisonType())

	-- hook these to skin mission rewards & OvermaxItem
    self:SecureHook("GarrisonMissionPage_SetReward", function(frame, _)
		-- aObj:Debug("GMP_SR: [%s, %s, %s]", frame, reward, missionComplete)
        frame.BG:SetTexture(nil)
		if self.modBtnBs then
			self:addButtonBorder{obj=frame, relTo=frame.Icon, reParent={frame.Quantity}, ofs=_G.Round(frame:GetWidth()) ~= 24 and 2 or nil}
			self:clrButtonFromBorder(frame)
		end
    end)
	self:SecureHook("GarrisonMissionButton_SetRewards", function(btn, _t)
		-- aObj:Debug("GMB_SRs: [%s, %s, %s]", btn, rewards, cnt)
		for i = 1, #btn.Rewards do
			self:removeRegions(btn.Rewards[i], {1}) -- background shadow
			if self.modBtnBs then
				self:addButtonBorder{obj=btn.Rewards[i], relTo=btn.Rewards[i].Icon, reParent={btn.Rewards[i].Quantity}, ofs=2}
				self:clrButtonFromBorder(btn.Rewards[i])
			end
		end
	end)

	self:SecureHookScript(_G.GarrisonMissionMechanicTooltip, "OnShow", function(this)
		_G.C_Timer.After(0.1, function() self:add2Table(self.ttList, this) end)

		self:Unhook(this, "OnShow")
	end)
	self:SecureHookScript(_G.GarrisonMissionMechanicFollowerCounterTooltip, "OnShow", function(this)
		_G.C_Timer.After(0.1, function() self:add2Table(self.ttList, this) end)

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.GarrisonBuildingFrame, "OnShow", function(this)

		this.MainHelpButton.Ring:SetTexture(nil)
		self:moveObject{obj=this.MainHelpButton, y=-4}
		this.GarrCorners:DisableDrawLayer("BACKGROUND")
		this.TownHallBox:DisableDrawLayer("BORDER")
		self:skinStdButton{obj=this.TownHallBox.UpgradeButton}
		self:addSkinFrame{obj=_G.GarrisonBuildingFrame, ft=ftype, kfs=true, ofs=2}

		-- BuildingLevelTooltip
		self:SecureHookScript(_G.GarrisonBuildingFrame.BuildingLevelTooltip, "OnShow", function(this)
			_G.C_Timer.After(0.1, function() self:add2Table(self.ttList, this) end)
			self:Unhook(this, "OnShow")
		end)

		local function skinBLbuttons(bl)
			for i = 1, #bl.Buttons do
				bl.Buttons[i].BG:SetTexture(nil)
				aObj:addButtonBorder{obj=bl.Buttons[i], relTo=bl.Buttons[i].Icon}
			end
		end
		self:SecureHookScript(_G.GarrisonBuildingFrame.BuildingList, "OnShow", function(this)
			this:DisableDrawLayer("BORDER")

			-- tabs
			for i = 1, _G.GARRISON_NUM_BUILDING_SIZES do
				this["Tab" .. i]:GetNormalTexture():SetAlpha(0) -- texture is changed in code
				self:addSkinFrame{obj=this["Tab" .. i], ft=ftype, noBdr=aObj.isTT, x1=3, y1=0, x2=-3, y2=2}
				this["Tab" .. i].sf.ignore = true -- don't change tab size
				if i == 1 then
					self:toggleTabDisplay(this["Tab" .. i], true)
				else
					self:toggleTabDisplay(this["Tab" .. i], false)
				end
			end
			self:SecureHook("GarrisonBuildingList_SelectTab", function(tab)
				local gbl = tab:GetParent()
				-- handle tab textures
				for i = 1, _G.GARRISON_NUM_BUILDING_SIZES do
					if i == tab:GetID() then
						self:toggleTabDisplay(tab, true)
					else
						self:toggleTabDisplay(gbl["Tab" .. i], false)
					end
				end
				-- handle buttons
				skinBLbuttons(gbl)
				gbl = nil
			end)

			skinBLbuttons(this)
			this.MaterialFrame:DisableDrawLayer("BACKGROUND")

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.GarrisonBuildingFrame.BuildingList)

		self:SecureHookScript(_G.GarrisonBuildingFrame.FollowerList, "OnShow", function(this)
			this:DisableDrawLayer("BACKGROUND")
			skinFollowerList(this)
			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.GarrisonBuildingFrame.InfoBox, "OnShow", function(this)
			this:DisableDrawLayer("BORDER")
			self:skinStdButton{obj=this.UpgradeButton}
			-- N.B. The RankBadge changes with level and has level number within the texture, therefore MUST not be hidden
			-- ib.RankBadge:SetAlpha(0)
			this.InfoBar:SetTexture(nil)
			skinPortrait(this.FollowerPortrait)
			this.AddFollowerButton.EmptyPortrait:SetTexture(nil) -- InfoText background texture
			self:getRegion(this.PlansNeeded, 1):SetTexture(nil) -- shadow texture
			self:getRegion(this.PlansNeeded, 2):SetTexture(nil) -- cost bar texture
			-- this.PlansNeeded:Hide()
			-- Follower Portrait Ring Quality changes colour so track this change
			self:SecureHook("GarrisonBuildingInfoBox_ShowFollowerPortrait", function(_)
				-- make sure ring quality is updated to level border colour
				_G.GarrisonBuildingFrame.InfoBox.FollowerPortrait.PortraitRingQuality:SetVertexColor(_G.GarrisonBuildingFrame.InfoBox.FollowerPortrait.PortraitRing:GetVertexColor())
			end)
			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.GarrisonBuildingFrame.InfoBox)

		-- MapFrame

		self:SecureHookScript(_G.GarrisonBuildingFrame.Confirmation, "OnShow", function(this)
			this:DisableDrawLayer("BACKGROUND")
			self:skinStdButton{obj=this.UpgradeGarrisonButton}
			self:skinStdButton{obj=this.UpgradeButton}
			self:skinStdButton{obj=this.CancelButton}
			self:addSkinFrame{obj=this, ft=ftype, ofs=-12}
			self:Unhook(this, "OnShow")
		end)

		self:Unhook(this, "OnShow")
	end)

	-- hook this to show/hide 'Plans Required' text (Bug in Blizzard's code, reported 03.03.18)
	self:SecureHook("GarrisonBuildingInfoBox_ShowBuilding", function(ID, owned, showLock)
		local buildingInfo
		if owned then
			buildingInfo = {_G.C_Garrison.GetOwnedBuildingInfo(ID)}
		else
			buildingInfo = {_G.C_Garrison.GetBuildingInfo(ID)}
		end

		if not showLock then
			if buildingInfo[16] -- isMaxLevel
			and buildingInfo[15] -- canUpgrade
			then
				_G.GarrisonBuildingFrame.InfoBox.PlansNeeded:Hide()
				_G.GarrisonBuildingFrame.InfoBox.Building:SetDesaturated(false)
			else
				_G.GarrisonBuildingFrame.InfoBox.PlansNeeded:Show()
				_G.GarrisonBuildingFrame.InfoBox.Building:SetDesaturated(true)
			end
		else
			_G.GarrisonBuildingFrame.InfoBox.Building:SetDesaturated(true)
		end
	end)

	self:SecureHookScript(_G.GarrisonMissionTutorialFrame, "OnShow", function(this)
		if self.modBtns then
			self:skinStdButton{obj=this.GlowBox.Button}
		end
		-- N.B. NO CloseButton

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.GarrisonMissionFrame, "OnShow", function(this)
		skinMissionFrame(this)

		self:SecureHookScript(this.FollowerList, "OnShow", function(this)
			skinFollowerList(this)

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(this.MissionTab.MissionList, "OnShow", function(this)
			skinMissionList(this)

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(this.MissionTab.MissionList)

		self:SecureHookScript(this.MissionTab.MissionPage, "OnShow", function(this)
			skinMissionPage(this)

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(this.FollowerTab, "OnShow", function(this)
			this:DisableDrawLayer("BORDER")
			skinFollowerPage(this)

			self:Unhook(this, "OnShow")
		end)

		-- MissionComplete
		self:SecureHookScript(this.MissionComplete, "OnShow", function(this)
			skinMissionComplete(this)

			self:Unhook(this, "OnShow")
		end)

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.GarrisonFollowerPlacer, "OnShow", function(this)
		this.PortraitRing:SetTexture(nil)
		this.LevelBorder:SetAlpha(0)

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.GarrisonShipyardFrame, "OnShow", function(this)
		self:keepFontStrings(this.BorderFrame)
		this.BorderFrame.GarrCorners:DisableDrawLayer("BACKGROUND")
		self:skinCloseButton{obj=this.BorderFrame.CloseButton2}
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, x1=2, y1=2, x2=1, y2=-5}
		self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, ignoreSize=true, lod=true, offsets={x1=9, y1=2, x2=-9, y2=0}, regions={7, 8, 9, 10}})

		self:SecureHookScript(this.FollowerList, "OnShow", function(this)
			skinFollowerList(this)

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(this.MissionTab.MissionList, "OnShow", function(this)
	        this:SetScale(1.019) -- make larger to fit frame
	        this.MapTexture:SetPoint("CENTER", this, "CENTER", 1, -10)
			this.MapTexture:SetDrawLayer("BACKGROUND", 1) -- make sure it appears above skinFrame but below other textures
			skinCompleteDialog(this.CompleteDialog, true)

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(this.MissionTab.MissionList)

		self:SecureHookScript(this.MissionTab.MissionPage, "OnShow", function(this)
			skinMissionPage(this)

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(this.FollowerTab, "OnShow", function(this)
			this:DisableDrawLayer("BORDER")
			skinFollowerTraitsAndEquipment(this)

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(this.MissionComplete, "OnShow", function(this)
			skinMissionComplete(this, true)

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.GarrisonBonusAreaTooltip, "OnShow", function(this)
			_G.C_Timer.After(0.1, function() self:add2Table(self.ttList, this) end)

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.GarrisonShipyardMapMissionTooltip, "OnShow", function(this)
			_G.C_Timer.After(0.1, function() self:add2Table(self.ttList, this) end)

			self:Unhook(this, "OnShow")
		end)

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.GarrisonLandingPage, "OnShow", function(this)
		this.HeaderBar:SetTexture(nil)
		self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, ignoreSize=true, lod=true, offsets={x1=4, y1=-10, x2=-4, y2=-3}, regions={7, 8, 9, 10}})
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, ofs=-13, y2=4})
		-- ReportTab
		self:SecureHookScript(this.Report, "OnShow", function(this)
			this.List:DisableDrawLayer("BACKGROUND")
			self:skinObject("slider", {obj=this.List.listScroll.scrollBar, fType=ftype, y1=-1, y2=1})
			for _, btn in _G.pairs(this.List.listScroll.buttons) do
				btn:DisableDrawLayer("BACKGROUND")
				btn:DisableDrawLayer("BORDER")
				for _, reward in _G.pairs(btn.Rewards) do
					self:addButtonBorder{obj=reward, relTo=reward.Icon, reParent={reward.Quantity}}
					self:clrButtonFromBorder(reward)
				end
			end
			self:skinObject("frame", {obj=this.List, fType=ftype, fb=true, y1=4})
			self:skinObject("tabs", {obj=this, tabs={this.InProgress, this.Available}, fType=ftype, ignoreSize=true, lod=true, offsets={x1=4, y1=-2, x2=-4, y2=-4}, regions={3}, track=false, func=function(tab) tab:GetNormalTexture():SetAlpha(0) _G.RaiseFrameLevelByTwo(tab) end})
			if self.isTT then
				self:SecureHook("GarrisonLandingPageReport_SetTab", function(this)
					self:setActiveTab(_G.GarrisonLandingPage.Report.selectedTab.sf)
					self:setInactiveTab(_G.GarrisonLandingPage.Report.unselectedTab.sf)
				end)
			end

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(this.Report)

		self:SecureHookScript(this.FollowerList, "OnShow", function(this)
			skinFollowerList(this)

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(this.FollowerTab, "OnShow", function(this)
			skinFollowerPage(this)

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(this.ShipFollowerList, "OnShow", function(this)
			skinFollowerList(this)

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(this.ShipFollowerTab, "OnShow", function(this)
			skinFollowerTraitsAndEquipment(this)

			self:Unhook(this, "OnShow")
		end)

		if self.garrisonType == _G.Enum.GarrisonType.Type_9_0 then
			this.CovenantCallings:DisableDrawLayer("BACKGROUND")
			local function skinPanelBtns(panel)
				panel:DisableDrawLayer("BACKGROUND")
				aObj:skinObject("frame", {obj=panel.RenownButton, fType=ftype, regions={3, 5, 6}, ofs=-4, y1=-5, y2=3})
				panel.RenownButton.UpdateButtonTextures = _G.nop
				aObj:skinObject("frame", {obj=panel.SoulbindButton, fType=ftype, regions={1, 2}, ofs=-4, y1=-5, y2=3})
				panel.SoulbindButton.Portrait.SetAtlas = _G.nop
				skinPanelBtns = nil
			end
			if not this.SoulbindPanel then
				self:SecureHook(this, "SetupSoulbind", function(this)
					if this.SoulbindPanel then
						skinPanelBtns(this.SoulbindPanel)
						self:Unhook(this, "SetupSoulbind")
					end
				end)
			else
				skinPanelBtns(this.SoulbindPanel)
			end
		end

		-- N.B. Garrison Landing Page Minimap Button skinned with other minimap buttons
		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.GarrisonLandingPage)

	if _G.GarrisonLandingPageTutorialBox then
		self:skinGlowBox(_G.GarrisonLandingPageTutorialBox, ftype)
	end

	-- a.k.a. Work Order Frame
	self:SecureHookScript(_G.GarrisonCapacitiveDisplayFrame, "OnShow", function(this)
		self:removeMagicBtnTex(this.StartWorkOrderButton)
		self:removeMagicBtnTex(this.CreateAllWorkOrdersButton)
		this.CapacitiveDisplay.IconBG:SetTexture(nil)
		skinPortrait(this.CapacitiveDisplay.ShipmentIconFrame.Follower)
		self:skinEditBox{obj=this.Count, regs={6}, noHeight=true}
		self:moveObject{obj=this.Count, x=-6}
		-- hook this to skin reagents
		self:SecureHook("GarrisonCapacitiveDisplayFrame_Update", function(this, success, _)
			if success ~= 0 then
				local btn
				for i = 1, #this.CapacitiveDisplay.Reagents do
					btn = this.CapacitiveDisplay.Reagents[i]
					btn.NameFrame:SetTexture(nil)
					if self.modBtnBs then
						aObj:addButtonBorder{obj=btn, relTo=btn.Icon, reParent={btn.Count}}
					end
				end
				btn = nil
			end
			if self.modBtns then
				self:clrBtnBdr(this.StartWorkOrderButton)
				self:clrBtnBdr(this.CreateAllWorkOrdersButton)
			end
		end)
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true}
		if self.modBtns then
			self:skinStdButton{obj=this.StartWorkOrderButton}
			self:skinStdButton{obj=this.CreateAllWorkOrdersButton}
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=this.CapacitiveDisplay.ShipmentIconFrame, relTo=this.CapacitiveDisplay.ShipmentIconFrame.Icon}
			this.CapacitiveDisplay.ShipmentIconFrame.sbb:SetShown(this.CapacitiveDisplay.ShipmentIconFrame.Icon:IsShown())
			self:SecureHook(this.CapacitiveDisplay.ShipmentIconFrame.Icon, "Show", function(this)
				this:GetParent().sbb:Show()
			end)
			self:SecureHook(this.CapacitiveDisplay.ShipmentIconFrame.Icon, "Hide", function(this)
				this:GetParent().sbb:Hide()
			end)
			self:SecureHook(this.CapacitiveDisplay.ShipmentIconFrame.Icon, "SetShown", function(this, show)
				this:GetParent().sbb:SetShown(this, show)
			end)
			self:addButtonBorder{obj=this.DecrementButton, ofs=0, x2=-1, clr="gold"}
			self:addButtonBorder{obj=this.IncrementButton, ofs=0, x2=-1, clr="gold"}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.GarrisonMonumentFrame, "OnShow", function(this)
		this.Background:SetTexture(nil)
		self:addButtonBorder{obj=this.LeftBtn}
		self:addButtonBorder{obj=this.RightBtn}
		self:addSkinFrame{obj=this, ft=ftype, ofs=-10, y2=6}

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.GarrisonRecruiterFrame, "OnShow", function(this)
		this.Pick.Line1:SetTexture(nil)
		this.Pick.Line2:SetTexture(nil)
		self:skinDropDown{obj=this.Pick.ThreatDropDown}
		self:removeMagicBtnTex(this.Pick.ChooseRecruits)
		self:skinStdButton{obj=this.Pick.ChooseRecruits}
		self:removeMagicBtnTex(this.Random.ChooseRecruits)
		self:skinStdButton{obj=this.Random.ChooseRecruits}
		self:removeMagicBtnTex(self:getChild(this.UnavailableFrame, 1))
		self:skinStdButton{obj=self:getChild(this.UnavailableFrame, 1)}
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true, ofs=1, y1=2}

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.GarrisonRecruitSelectFrame, "OnShow", function(this)
		skinFollowerList(this.FollowerList)

		this.FollowerSelection:DisableDrawLayer("BORDER")
		this.FollowerSelection.Line1:SetTexture(nil)
		this.FollowerSelection.Line2:SetTexture(nil)
		for i = 1, 3 do
			self:nilTexture(this.FollowerSelection["Recruit" .. i].PortraitFrame.PortraitRing, true)
			self:nilTexture(this.FollowerSelection["Recruit" .. i].PortraitFrame.LevelBorder, true)
			this.FollowerSelection["Recruit" .. i].PortraitFrame.PortraitRingQuality:SetVertexColor(this.FollowerSelection["Recruit" .. i].PortraitFrame.LevelBorder:GetVertexColor())
			self:removeMagicBtnTex(this.FollowerSelection["Recruit" .. i].HireRecruits)
			self:skinStdButton{obj=this.FollowerSelection["Recruit" .. i].HireRecruits}
		end

		this.GarrCorners:DisableDrawLayer("BACKGROUND")
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ofs=2}

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.OrderHallMissionFrame, "OnShow", function(this)
		skinMissionFrame(this)
		this.ClassHallIcon:DisableDrawLayer("OVERLAY") -- this hides the frame
		this.sf:SetFrameStrata("LOW") -- allow map textures to be visible

		self:SecureHookScript(this.FollowerList, "OnShow", function(this)
			skinFollowerList(this)

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(this.MissionTab, "OnShow", function(this)
			skinMissionList(this.MissionList)

			this.MissionList.CombatAllyUI.Background:SetTexture(nil)
			this.MissionList.CombatAllyUI.Available.AddFollowerButton.EmptyPortrait:SetTexture(nil)
			skinPortrait(this.MissionList.CombatAllyUI.InProgress.PortraitFrame)
			if self.modBtns then
				self:skinStdButton{obj=this.MissionList.CombatAllyUI.InProgress.Unassign}
			end

			-- ZoneSupportMissionPage (a.k.a. Combat Ally selection page)
			this.ZoneSupportMissionPageBackground:DisableDrawLayer("BACKGROUND")
			this.ZoneSupportMissionPage:DisableDrawLayer("BACKGROUND")
			this.ZoneSupportMissionPage:DisableDrawLayer("BORDER")
			this.ZoneSupportMissionPage.CombatAllyLabel.TextBackground:SetTexture(nil)
			if self.modBtnBs then
				self:addButtonBorder{obj=this.ZoneSupportMissionPage.CombatAllySpell, clr="grey", ca=1}
			end
			this.ZoneSupportMissionPage.ButtonFrame:SetTexture(nil)
			this.ZoneSupportMissionPage.Follower1:DisableDrawLayer("BACKGROUND")
			skinPortrait(this.ZoneSupportMissionPage.Follower1.PortraitFrame)
			self:skinObject("frame", {obj=this.ZoneSupportMissionPage, fType=ftype, kfs=true, cb=true, x1=-360, y1=434, x2=3, y2=-65})
			this.ZoneSupportMissionPage.CloseButton:SetSize(28, 28)
			if self.modBtns then
				self:moveObject{obj=this.ZoneSupportMissionPage.StartMissionButton.Flash, x=-0.5, y=1.5}
				self:skinStdButton{obj=this.ZoneSupportMissionPage.StartMissionButton}
			end

			skinMissionPage(this.MissionPage)

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(this.MissionTab)

		self:SecureHookScript(this.FollowerTab, "OnShow", function(this)
			this:DisableDrawLayer("BORDER")
			skinFollowerPage(this)

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(this.MissionComplete, "OnShow", function(this)
			skinMissionComplete(this)

			self:Unhook(this, "OnShow")
		end)

		self:Unhook(this, "OnShow")
	end)

	if _G.OrderHallMissionTutorialFrame then
		self:SecureHookScript(_G.OrderHallMissionTutorialFrame, "OnShow", function(this)
			self:skinGlowBox(this.GlowBox, ftype)

			self:Unhook(this, "OnShow")
		end)
	end

	self:SecureHookScript(_G.BFAMissionFrame, "OnShow", function(this)
		this.OverlayElements.Topper:SetTexture(nil)
		this.OverlayElements.CloseButtonBorder:SetTexture(nil)
		this.TitleScroll:DisableDrawLayer("ARTWORK")
		this.TitleText:SetTextColor(self.HT:GetRGB())

		skinMissionFrame(this)
		this.sf:SetFrameStrata("LOW") -- allow map textures to be visible

		self:SecureHookScript(this.FollowerList, "OnShow", function(this)
			skinFollowerList(this)

			self:Unhook(this, "OnShow")
		end)

		this.MapTab.ScrollContainer.Child.TiledBackground:SetTexture(nil)

		self:SecureHookScript(this.MissionTab.MissionList, "OnShow", function(this)
			skinMissionList(this, -2)

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(this.MissionTab.MissionList)

		self:SecureHookScript(this.MissionTab.MissionPage, "OnShow", function(this)
			skinMissionPage(this)

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(this.FollowerTab, "OnShow", function(this)
			this:DisableDrawLayer("BORDER")
			skinFollowerPage(this)

			self:Unhook(this, "OnShow")
		end)

		-- MissionComplete
		self:SecureHookScript(this.MissionComplete, "OnShow", function(this)
			skinMissionComplete(this)

			self:Unhook(this, "OnShow")
		end)

		self:Unhook(this, "OnShow")
	end)

	local function skinCovenantMissionFrame(frame)
		local function skinPuck(btn)
			aObj:nilTexture(btn.PuckShadow, true)
			aObj:nilTexture(btn.PuckBorder, true)
			for i = 1, #btn.AbilityButtons do
				btn.AbilityButtons[i].Border:SetTexture(nil)
			end
			btn.HealthBar.Health:SetTexture(aObj.sbTexture)
			btn.HealthBar.Border:SetTexture(nil)
		end
		local function skinBoard(frame)
			for btn in frame.enemyFramePool:EnumerateActive() do
				skinPuck(btn)
			end
			for btn in frame.enemySocketFramePool:EnumerateActive() do
				aObj:skinObject("frame", {obj=btn, fType=ftype, kfs=true, fb=true, ofs=2, clr="grey"})
			end
			for btn in frame.followerFramePool:EnumerateActive() do
				skinPuck(btn)
			end
			for btn in frame.followerSocketFramePool:EnumerateActive() do
				aObj:skinObject("frame", {obj=btn, fType=ftype, kfs=true, fb=true, ofs=2, clr="grey"})
			end
		end
		frame.OverlayElements.CloseButtonBorder:SetTexture(nil)
		aObj:keepFontStrings(frame.RaisedBorder)
		aObj:addSkinFrame{obj=frame, ft=ftype, kfs=true, x2=1, y2=-6}
		frame.sf:SetFrameStrata("LOW") -- allow map textures to be visible
		skinMissionFrame(frame)
		aObj:SecureHookScript(frame.FollowerList, "OnShow", function(this)
			this:DisableDrawLayer("BORDER")
			skinFollowerList(this)
			if aObj.modBtns then
				aObj:skinStdButton{obj=this.HealAllButton}
				aObj:SecureHook(this, "CalculateHealAllFollowersCost", function(this)
					aObj:clrBtnBdr(this.HealAllButton)
				end)
			end

			aObj:Unhook(this, "OnShow")
		end)
		aObj:SecureHookScript(frame.MissionTab, "OnShow", function(this)
			skinMissionList(this.MissionList)
			-- ZoneSupportMissionPage
			skinMissionPage(this.MissionPage)
			skinBoard(this.MissionPage.Board)

			aObj:Unhook(this, "OnShow")
		end)
		aObj:checkShown(frame.MissionTab)
		aObj:SecureHookScript(frame.FollowerTab, "OnShow", function(this)
			this:DisableDrawLayer("BORDER")
			this.RaisedFrameEdges:DisableDrawLayer("BORDER")
			this.HealFollowerFrame.ButtonFrame:SetTexture(nil)
			if aObj.modBtns then
				aObj:skinStdButton{obj=this.HealFollowerFrame.HealFollowerButton}
				aObj:SecureHook(this, "UpdateHealCost", function(this)
					aObj:clrBtnBdr(this.HealFollowerFrame.HealFollowerButton)
				end)
			end
			if aObj.modBtnBs then
				aObj:SecureHook(this, "UpdateAutoSpellAbilities", function(this, _)
					for btn in this.autoSpellPool:EnumerateActive() do
						btn.Border:SetTexture(nil)
						btn.SpellBorder:SetTexture(nil)
						aObj:addButtonBorder{obj=btn, relTo=btn.Icon}
					end
				end)
			end

			aObj:Unhook(this, "OnShow")
		end)
		-- MissionComplete
		aObj:adjWidth(frame.MissionCompleteBackground, -3)
		local function skinFollowers(frame)
			for btn in frame.followerPool:EnumerateActive() do
				btn.RewardsFollower.PuckBorder:SetTexture(nil)
				aObj:changeTandC(btn.RewardsFollower.LevelDisplayFrame.LevelCircle)
			end
		end
		aObj:SecureHookScript(frame.MissionComplete, "OnShow", function(this)
			this:DisableDrawLayer("OVERLAY")
			aObj:removeNineSlice(this.NineSlice)
			-- .RewardsScreen
				-- .CombatCompleteSuccessFrame
			this.RewardsScreen.CombatCompleteSuccessFrame.CombatCompleteLineTop:SetTexture(nil)
			this.RewardsScreen.CombatCompleteSuccessFrame.CombatCompleteLineBottom:SetTexture(nil)
			aObj:keepFontStrings(this.RewardsScreen.FinalRewardsPanel)
			-- hook this to skin followers
			aObj:SecureHook(this.RewardsScreen, "PopulateFollowerInfo", function(this, ...)
				skinFollowers(this)
			end)
			-- skin any existing ones
			skinFollowers(this.RewardsScreen)
			if aObj.modBtns then
				aObj:skinStdButton{obj=this.RewardsScreen.FinalRewardsPanel.ContinueButton}
			end
			if aObj.modBtnBs then
				aObj:SecureHook(this.RewardsScreen, "SetRewards", function(this, _, victoryState)
					if victoryState then
						for btn in this.rewardsPool:EnumerateActive() do
							aObj:addButtonBorder{obj=btn, relTo=btn.Icon, reParent={btn.Quantity}}
						end
					end
				end)
			end

			aObj:removeRegions(this.AdventuresCombatLog, {1})
			this.AdventuresCombatLog.ElevatedFrame:DisableDrawLayer("OVERLAY")
			this.AdventuresCombatLog.CombatLogMessageFrame.ScrollBar:DisableDrawLayer("BACKGROUND")

			-- .MissionInfo
			this.MissionInfo.Header:SetTexture(nil)
			aObj:nilTexture(this.MissionInfo.IconBG, true)

			skinBoard(this.Board)
			this.CompleteFrame:DisableDrawLayer("BACKGROUND")
			if aObj.modBtns then
				aObj:skinStdButton{obj=this.CompleteFrame.ContinueButton}
				aObj:skinStdButton{obj=this.CompleteFrame.SpeedButton}
				aObj:SecureHook(this, "DisableCompleteFrameButtons", function(this)
					aObj:clrBtnBdr(this.CompleteFrame.ContinueButton)
					aObj:clrBtnBdr(this.CompleteFrame.SpeedButton)
				end)
				aObj:SecureHook(this, "EnableCompleteFrameButtons", function(this)
					aObj:clrBtnBdr(this.CompleteFrame.ContinueButton)
					aObj:clrBtnBdr(this.CompleteFrame.SpeedButton)
				end)
			end

			aObj:Unhook(this, "OnShow")
		end)
		-- Follower as mouse pointer when dragging
		aObj:SecureHook(frame, "GetPlacerFrame", function(this)
			aObj:nilTexture(_G.CovenantFollowerPlacer.PuckShadow, true)
			aObj:nilTexture(_G.CovenantFollowerPlacer.PuckBorder, true)
			for i = 1, #_G.CovenantFollowerPlacer.AbilityButtons do
				_G.CovenantFollowerPlacer.AbilityButtons[i].Border:SetTexture(nil)
			end
			_G.CovenantFollowerPlacer.HealthBar.Health:SetTexture(aObj.sbTexture)
			_G.CovenantFollowerPlacer.HealthBar.Border:SetTexture(nil)

			aObj:Unhook(this, "GetPlacerFrame")
		end)
	end
	self:SecureHookScript(_G.CovenantMissionFrame, "OnShow", function(this)

		-- show or hide the MapTab as required
		-- required as Map textures are visible when the Mission tab is displayed
		-- TODO: handle condition when there is a MapTab visible
		if _G.C_Garrison.IsAtGarrisonMissionNPC() then
			this.MapTab:Hide()
		else
			this.MapTab:Show()
		end

		if skinCovenantMissionFrame then
			skinCovenantMissionFrame(this)
			skinCovenantMissionFrame = nil
		end

	end)

end

aObj.blizzFrames[ftype].GhostFrame = function(self)
	if not self.prdb.GhostFrame or self.initialized.GhostFrame then return end
	self.initialized.GhostFrame = true

	self:SecureHookScript(_G.GhostFrame, "OnShow", function(this)
		self:addSkinFrame{obj=this, ft=ftype, kfs=true}
		_G.RaiseFrameLevelByTwo(this) -- make it appear above other frames
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.GhostFrameContentsFrame, relTo=_G.GhostFrameContentsFrameIcon}
		end

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.GhostFrame)

end

aObj.blizzLoDFrames[ftype].GMChatUI = function(self)
	if not self.prdb.GMChatUI or self.initialized.GMChatUI then return end
	self.initialized.GMChatUI = true

	self:SecureHookScript(_G.GMChatFrame, "OnShow", function(this)
		self:addSkinFrame{obj=_G.GMChatTab, ft=ftype, kfs=true, noBdr=self.isTT, y2=-4}
		if self.prdb.ChatFrames then
			self:addSkinFrame{obj=this, ft=ftype, x1=-4, y1=4, x2=4, y2=-8}
		end
		if self.modBtns then
			self:skinCloseButton{obj=_G.GMChatFrameCloseButton}
		end
		this:DisableDrawLayer("BORDER")
		if self.prdb.ChatEditBox.skin then
			if self.prdb.ChatEditBox.style == 1 then -- Frame
				local kRegions = _G.CopyTable(self.ebRgns)
				aObj:add2Table(kRegions, 12)
				self:keepRegions(this.editBox, kRegions)
				self:addSkinFrame{obj=this.editBox, ft=ftype, x1=2, y1=-2, x2=-2}
				kRegions = nil
			elseif self.prdb.ChatEditBox.style == 2 then -- Editbox
				self:skinEditBox{obj=this.editBox, regs={12}, noHeight=true}
			else -- Borderless
				self:removeRegions(this.editBox, {6, 7, 8})
				self:addSkinFrame{obj=this.editBox, ft=ftype, noBdr=true, x1=5, y1=-4, x2=-5, y2=2}
			end
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.GMChatStatusFrame, "OnShow", function(this)
		this:DisableDrawLayer("BORDER")
		this:DisableDrawLayer("OVERLAY")
		self:addSkinFrame{obj=this, ft=ftype, anim=true, x1=30, y1=-12, x2=-30, y2=12}

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzLoDFrames[ftype].GMSurveyUI = function(self)
	if not self.prdb.GMSurveyUI or self.initialized.GMSurveyUI then return end
	self.initialized.GMSurveyUI = true

	self:SecureHookScript(_G.GMSurveyFrame, "OnShow", function(this)
		self:skinSlider{obj=_G.GMSurveyScrollFrame.ScrollBar, rt="artwork"}
		for i = 1, _G.MAX_SURVEY_QUESTIONS do
			self:applySkin{obj=_G["GMSurveyQuestion" .. i], ft=ftype} -- must use applySkin otherwise text is behind gradient
			_G["GMSurveyQuestion" .. i].SetBackdropColor = _G.nop
			_G["GMSurveyQuestion" .. i].SetBackdropBorderColor = _G.nop
		end
		self:skinSlider{obj=_G.GMSurveyCommentScrollFrame.ScrollBar}
		self:applySkin{obj=_G.GMSurveyCommentFrame, ft=ftype} -- must use applySkin otherwise text is behind gradient
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, hdr=true, y1=-6, x2=-45}

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzLoDFrames[ftype].GuildBankUI = function(self)
	if not self.prdb.GuildBankUI or self.initialized.GuildBankUI then return end
	self.initialized.GuildBankUI = true

	self:SecureHookScript(_G.GuildBankFrame, "OnShow", function(this)
		_G.GuildBankEmblemFrame:Hide()
		for i = 1, _G.NUM_GUILDBANK_COLUMNS do
			_G["GuildBankColumn" .. i]:DisableDrawLayer("BACKGROUND")
			if self.modBtnBs then
				for j = 1, _G.NUM_SLOTS_PER_GUILDBANK_GROUP do
					self:addButtonBorder{obj=_G["GuildBankColumn" .. i .. "Button" .. j], ibt=true, clr="grey", ca=0.85}
				end
			end
		end
		self:skinEditBox{obj=_G.GuildItemSearchBox, regs={6, 7}, mi=true, noHeight=true, noMove=true} -- 6 is text, 7 is icon
		_G.GuildBankMoneyFrameBackground:DisableDrawLayer("BACKGROUND")
		self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=true})
		-- Tabs (side)
		for i = 1, _G.MAX_GUILDBANK_TABS do
			_G["GuildBankTab" .. i]:DisableDrawLayer("BACKGROUND")
			if self.modBtnBs then
				 self:addButtonBorder{obj=_G["GuildBankTab" .. i .. "Button"], relTo=_G["GuildBankTab" .. i .. "ButtonIconTexture"], y2=-3}
			end
		end
		self:skinSlider{obj=_G.GuildBankTransactionsScrollFrame.ScrollBar, rt="artwork"}
		self:skinSlider{obj=_G.GuildBankInfoScrollFrame.ScrollBar, rt="artwork"}
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, hdr=true, x2=1, y2=-5}
		if self.modBtns then
			self:skinStdButton{obj=_G.GuildBankFrameDepositButton, x1=0} -- don't overlap withdraw button
			self:skinStdButton{obj=_G.GuildBankFrameWithdrawButton, x2=0} -- don't overlap deposit button
			self:skinStdButton{obj=_G.GuildBankFramePurchaseButton}
			self:SecureHook("GuildBankFrame_UpdateTabBuyingInfo", function()
				self:clrBtnBdr(_G.GuildBankFramePurchaseButton)
			end)
			self:skinStdButton{obj=_G.GuildBankInfoSaveButton}
		end
		-- send message when UI is skinned (used by oGlow skin)
		self:SendMessage("GuildBankUI_Skinned", self)

		self:Unhook(this, "OnShow")
	end)

	--	GuildBank Popup Frame
	self:SecureHookScript(_G.GuildBankPopupFrame, "OnShow", function(this)
		self:adjHeight{obj=this, adj=20}
		self:removeRegions(this.BorderBox, {1, 2, 3, 4, 5, 6, 7, 8})
		self:skinEditBox{obj=_G.GuildBankPopupEditBox, regs={6}}
		self:adjHeight{obj=_G.GuildBankPopupScrollFrame, adj=20} -- stretch to bottom of scroll area
		self:skinSlider{obj=_G.GuildBankPopupScrollFrame.ScrollBar, rt="background"}
		for i = 1, _G.NUM_GUILDBANK_ICONS_SHOWN do
			_G["GuildBankPopupButton" .. i]:DisableDrawLayer("BACKGROUND")
			if self.modBtnBs then
				self:addButtonBorder{obj=_G["GuildBankPopupButton" .. i], relTo=_G["GuildBankPopupButton" .. i .. "Icon"], reParent={_G["GuildBankPopupButton" .. i .. "Name"]}}
			end
		end
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, hdr=true, ofs=-6}
		if self.modBtns then
			self:skinStdButton{obj=_G.GuildBankPopupCancelButton}
			self:skinStdButton{obj=_G.GuildBankPopupOkayButton}
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].HelpFrame = function(self)
	if not self.prdb.HelpFrame or self.initialized.HelpFrame then return end
	self.initialized.HelpFrame = true

	self:SecureHookScript(_G.HelpFrame, "OnShow", function(this)
		self:removeInset(this.Browser.BrowserInset)
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, hdr=true, cb=true, x2=3})

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.BrowserSettingsTooltip, "OnShow", function(this)
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true})
		if self.modBtns then
			self:skinStdButton{obj=_G.this.CookiesButton}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.TicketStatusFrame, "OnShow", function(this)
		self:skinObject("frame", {obj=_G.TicketStatusFrameButton, fType=ftype})

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.TicketStatusFrame)

	self:SecureHookScript(_G.ReportCheatingDialog, "OnShow", function(this)
		this.Border.Bg:SetTexture(nil)
		self:removeNineSlice(this.Border)
		self:skinObject("frame", {obj=this.CommentFrame, fType=ftype, kfs=true, fb=true})
		self:skinObject("frame", {obj=this, fType=ftype, ofs=0})
		if self.modBtns then
			self:skinStdButton{obj=this.reportButton}
			self:skinStdButton{obj=_G.ReportCheatingDialogCancelButton}
			self:SecureHookScript(this.CommentFrame.EditBox, "OnTextChanged", function(this)
				self:clrBtnBdr(this:GetParent():GetParent().reportButton)
			end)
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].HelpTip = function(self)
	if not self.prdb.HelpTip or self.initialized.HelpTip then return end
	self.initialized.HelpTip = true

	local function skinHelpTips()
		for hTip in _G.HelpTip.framePool:EnumerateActive() do
			self:skinGlowBox(hTip, ftype)
			if self.modBtns then
				-- N.B. .CloseButton already skinned in skinGlowBox function
				self:skinStdButton{obj=hTip.OkayButton}
			end
		end
	end
	skinHelpTips()
	self:SecureHook(_G.HelpTip, "Show", function(this, _)
		skinHelpTips()
	end)

end

-- These functions are used by the InterfaceOptions & SystemOptions functions
local checkChild, skinKids, cName
function checkChild(child)
	cName = child:GetName()
	if aObj:isDropDown(child) then
		-- apply specific adjustment if required
		aObj:skinObject("dropdown", {obj=child, fType=ftype, x2=aObj.iofDD[cName]})
		child.Text:SetAlpha(1)
		child.Icon:SetAlpha(1)
	elseif child:IsObjectType("Slider") then
		aObj:skinObject("slider", {obj=child, fType=ftype})
	elseif child:IsObjectType("CheckButton") then
		aObj:skinCheckButton{obj=child, hf=true} -- handle hide/show
	elseif child:IsObjectType("EditBox") then
		aObj:skinObject("editbox", {obj=child, fType=ftype})
	elseif child:IsObjectType("Button")
	and not aObj.iofBtn[child]
	then
		aObj:skinStdButton{obj=child}
	end
end
function skinKids(obj)
	-- wait for all objects to be created
	_G.C_Timer.After(0.1, function()
		for _, child in _G.ipairs{obj:GetChildren()} do
			checkChild(child)
		end
	end)
end
aObj.blizzFrames[ftype].InterfaceOptions = function(self)
	if not self.prdb.InterfaceOptions or self.initialized.InterfaceOptions then return end
	self.initialized.InterfaceOptions = true

	-- Interface
	self:SecureHookScript(_G.InterfaceOptionsFrame, "OnShow", function(this)
		self:removeNineSlice(this.Border)
		self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, ignoreSize=true, lod=true, upwards=true, offsets={x1=6, y1=2, x2=-6, y2=-3}})
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, hdr=true})
		if self.modBtns then
			self:skinStdButton{obj=_G.InterfaceOptionsFrameCancel}
			self:skinStdButton{obj=_G.InterfaceOptionsFrameOkay}
			self:skinStdButton{obj=_G.InterfaceOptionsFrameDefaults}
		end
		-- LHS panel (Game Tab)
		self:SecureHookScript(_G.InterfaceOptionsFrameCategories, "OnShow", function(this)
			self:skinObject("slider", {obj=_G.InterfaceOptionsFrameCategoriesListScrollBar, fType=ftype, x1=4, x2=-5})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, fb=true})

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.InterfaceOptionsFrameCategories)
		-- LHS panel (AddOns tab)
		self:SecureHookScript(_G.InterfaceOptionsFrameAddOns, "OnShow", function(this)
			self:skinObject("slider", {obj=_G.InterfaceOptionsFrameAddOnsListScrollBar, fType=ftype, x1=4, x2=-5})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, fb=true})
			if self.modBtns then
				-- skin toggle buttons
				for _, btn in _G.pairs(_G.InterfaceOptionsFrameAddOns.buttons) do
					self:skinExpandButton{obj=btn.toggle, onSB=true, noHook=true}
					self:checkTex{obj=btn.toggle}
				end
				self:SecureHook("InterfaceAddOnsList_Update", function()
					for _, btn in _G.pairs(_G.InterfaceOptionsFrameAddOns.buttons) do
						self:checkTex{obj=btn.toggle}
					end
				end)
			end

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.InterfaceOptionsFrameAddOns)
		-- RHS Panel
		self:skinObject("frame", {obj=_G.InterfaceOptionsFramePanelContainer, fType=ftype, kfs=true, fb=true})
		-- Social Browser Frame (Twitter integration)
		self:SecureHookScript(_G.SocialBrowserFrame, "OnShow", function(this)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, x2=1})

			self:Unhook(this, "OnShow")
		end)
		if self.modBtns then
			self:SecureHook(_G.InterfaceOptionsSocialPanel.EnableTwitter, "setFunc", function(value)
				-- N.B. gets called when panel not skinned
				if _G.InterfaceOptionsSocialPanel.TwitterLoginButton.sb then
					self:clrBtnBdr(_G.InterfaceOptionsSocialPanel.TwitterLoginButton)
				end
			end)
		end

		self:Unhook(this, "OnShow")
	end)

	-- skin extra elements
	self.RegisterCallback("IONP", "IOFPanel_After_Skinning", function(this, panel)
		if panel ~= _G.InterfaceOptionsNamesPanel then return end
		skinKids(_G.InterfaceOptionsNamesPanelFriendly)
		skinKids(_G.InterfaceOptionsNamesPanelEnemy)
		skinKids(_G.InterfaceOptionsNamesPanelUnitNameplates)

		self.UnregisterCallback("IONP", "IOFPanel_After_Skinning")
	end)

	self.RegisterCallback("CUFP", "IOFPanel_After_Skinning", function(this, panel)
		if panel ~= _G.CompactUnitFrameProfiles then return end
		self:removeNineSlice(_G.CompactUnitFrameProfiles.newProfileDialog.Border)
		self:removeNineSlice(_G.CompactUnitFrameProfiles.deleteProfileDialog.Border)
		self:removeNineSlice(_G.CompactUnitFrameProfiles.unsavedProfileDialog.Border)
		skinKids(_G.CompactUnitFrameProfiles.newProfileDialog)
		self:addSkinFrame{obj=_G.CompactUnitFrameProfiles.newProfileDialog, ft=ftype}
		skinKids(_G.CompactUnitFrameProfiles.deleteProfileDialog)
		self:addSkinFrame{obj=_G.CompactUnitFrameProfiles.deleteProfileDialog, ft=ftype}
		skinKids(_G.CompactUnitFrameProfiles.unsavedProfileDialog)
		self:addSkinFrame{obj=_G.CompactUnitFrameProfiles.unsavedProfileDialog, ft=ftype}
		skinKids(_G.CompactUnitFrameProfiles.optionsFrame)
		_G.CompactUnitFrameProfiles.optionsFrame.autoActivateBG:SetTexture(nil)

		self.UnregisterCallback("CUFP", "IOFPanel_After_Skinning")
	end)

	-- hook this to skin Interface Option panels
	self:SecureHook("InterfaceOptionsList_DisplayPanel", function(panel)
		-- aObj:Debug("IOL_DP: [%s, %s, %s, %s, %s, %s]", panel, panel.name, panel.parent, panel.GetNumChildren and panel:GetNumChildren(), self.iofSkinnedPanels[panel], panel.GetName and panel:GetName() or "n/a")

		-- let AddOn skins know when IOF panel is going to be skinned
		self.callbacks:Fire("IOFPanel_Before_Skinning", panel)

		-- don't skin a panel twice
		if not self.iofSkinnedPanels[panel] then
			skinKids(panel)
			self.iofSkinnedPanels[panel] = true
		end

		-- let AddOn skins know when IOF panel has been skinned
		self.callbacks:Fire("IOFPanel_After_Skinning", panel)

	end)

end

-- The following function is used by the IslandsPartyPoseUI & WarfrontsPartyPoseUI functions
local skinPartyPoseFrame
if _G.IsAddOnLoadOnDemand("Blizzard_IslandsPartyPoseUI") then
	function skinPartyPoseFrame(frame)

		frame.Border:DisableDrawLayer("BORDER") -- PartyPose NineSliceLayout
		aObj:addSkinFrame{obj=frame, ft=ftype, kfs=true, nb=true}

		-- RewardFrame
		frame.RewardAnimations.RewardFrame.NameFrame:SetTexture(nil)
		aObj:nilTexture(frame.RewardAnimations.RewardFrame.IconBorder, true)
		aObj:addButtonBorder{obj=frame.RewardAnimations.RewardFrame, relTo=frame.RewardAnimations.RewardFrame.Icon, reParent={frame.RewardAnimations.RewardFrame.Count}}

		aObj:nilTexture(frame.OverlayElements.Topper, true)

		-- ModelScene
		frame.ModelScene.Bg:SetTexture(nil)
		frame.ModelScene:DisableDrawLayer("BORDER")
		frame.ModelScene:DisableDrawLayer("OVERLAY")

		if aObj.modBtns then
			if frame.LeaveButton then
				aObj:skinStdButton{obj=frame.LeaveButton}
			end
		end

	end
end
aObj.blizzLoDFrames[ftype].IslandsPartyPoseUI = function(self)
	if not self.prdb.IslandsPartyPoseUI or self.initialized.IslandsPartyPoseUI then return end

	if not _G.IslandsPartyPoseFrame then
		_G.C_Timer.After(0.1, function()
			self.blizzLoDFrames[ftype].IslandsPartyPoseUI(self)
		end)
		return
	end

	self.initialized.IslandsPartyPoseUI = true

	skinPartyPoseFrame(_G.IslandsPartyPoseFrame)
	-- Score

end

aObj.blizzLoDFrames[ftype].IslandsQueueUI = function(self)
	if not self.prdb.IslandsQueueUI or self.initialized.IslandsQueueUI then return end

	if not _G.IslandsQueueFrame then
		_G.C_Timer.After(0.1, function()
			self.blizzLoDFrames[ftype].IslandsQueueUI(self)
		end)
		return
	end

	self.initialized.IslandsQueueUI = true

	local IQF = _G.IslandsQueueFrame

	IQF.TitleBanner.Banner:SetTexture(nil)
	for i = 1, #IQF.IslandCardsFrame.IslandCards do
		-- IQF.IslandCardsFrame.IslandCards[i].Background:SetTexture(nil)
		IQF.IslandCardsFrame.IslandCards[i].TitleScroll.Parchment:SetTexture(nil)
	end

	IQF.DifficultySelectorFrame.Background:SetTexture(nil)
	if self.modBtns then
		self:skinStdButton{obj=IQF.DifficultySelectorFrame.QueueButton}
	end

	local WQ = IQF.WeeklyQuest
	WQ.OverlayFrame.Bar:SetTexture(nil)
	WQ.OverlayFrame.FillBackground:SetTexture(nil)
	self:skinStatusBar{obj=WQ.StatusBar, fi=0}
	-- N.B. NOT a real tooltip
	self:addSkinFrame{obj=WQ.QuestReward.Tooltip, ft=ftype, kfs=true, nb=true}
	if self.modBtnBs then
		self:addButtonBorder{obj=WQ.QuestReward, relTo=WQ.QuestReward.Icon}
		self:addButtonBorder{obj=WQ.QuestReward.Tooltip.ItemTooltip, relTo=WQ.QuestReward.Tooltip.ItemTooltip.Icon, reParent={WQ.QuestReward.Tooltip.ItemTooltip.Count}}
	end

	IQF.TutorialFrame.TutorialText:SetTextColor(self.BT:GetRGB())
	IQF.TutorialFrame:SetSize(317, 336)
	self:addSkinFrame{obj=IQF.TutorialFrame, ft=ftype, kfs=true, y1=-1, x2=-1, y2=20}
	if self.modBtns then
		self:skinStdButton{obj=IQF.TutorialFrame.Leave}
	end

	self:keepFontStrings(IQF.ArtOverlayFrame)

	IQF.HelpButton.Ring:SetTexture(nil)

	self:addSkinFrame{obj=IQF, ft=ftype, kfs=true}
	IQF, WQ = nil, nil

end

aObj.blizzFrames[ftype].ItemText = function(self)
	if not self.prdb.ItemText or self.initialized.ItemText then return end
	self.initialized.ItemText = true

	self:SecureHookScript(_G.ItemTextFrame, "OnShow", function(this)
		_G.ItemTextPageText:SetTextColor(self.BT:GetRGB())
		_G.ItemTextPageText:SetTextColor("P", self.BT:GetRGB())
		_G.ItemTextPageText:SetTextColor("H1", self.HT:GetRGB())
		_G.ItemTextPageText:SetTextColor("H2", self.HT:GetRGB())
		_G.ItemTextPageText:SetTextColor("H3", self.HT:GetRGB())

		if not this.sf then
			self:skinSlider{obj=_G.ItemTextScrollFrame.ScrollBar, wdth=-4}
			self:skinStatusBar{obj=_G.ItemTextStatusBar, fi=0}
			self:moveObject{obj=_G.ItemTextPrevPageButton, x=-55} -- move prev button left
			if not self.isClsc then
				self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true}
			else
				_G.ItemTextScrollFrame:DisableDrawLayer("BACKGROUND")
				_G.ItemTextScrollFrame:DisableDrawLayer("ARTWORK")
				self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true, x1=10, y1=-12, x2=-31, y2=60}
				if self.modBtns then
					self:skinCloseButton{obj=_G.ItemTextCloseButton}
				end
			end
			if self.modBtnBs then
				-- N.B. page buttons are hidden or shown as required
				self:addButtonBorder{obj=_G.ItemTextPrevPageButton, ofs=-2, x1=1, clr="gold"}
				self:addButtonBorder{obj=_G.ItemTextNextPageButton, ofs=-2, x1=1, clr="gold"}
			end

		end
	end)

end

aObj.blizzFrames[ftype].LevelUpDisplay = function(self)
	if not self.prdb.LevelUpDisplay or self.initialized.LevelUpDisplay then return end
	self.initialized.LevelUpDisplay = true

	self:SecureHookScript(_G.LevelUpDisplay, "OnShow", function(this)
		this:DisableDrawLayer("BACKGROUND")
		-- sub frames
		this.scenarioFrame:DisableDrawLayer("BORDER")
		this.scenarioBits:DisableDrawLayer("BACKGROUND")
		this.scenarioBits:DisableDrawLayer("BORDER")
		this.scenarioFiligree:DisableDrawLayer("OVERLAY")
		this.challengeModeBits:DisableDrawLayer("BORDER")
		this.challengeModeBits.BottomFiligree:SetTexture(nil)
		-- SpellBucketFrame ?

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.LevelUpDisplay)

	self:SecureHookScript(_G.BossBanner, "OnShow", function(this)
		this:DisableDrawLayer("BACKGROUND")
		this:DisableDrawLayer("BORDER")
		this.BottomFillagree:SetTexture(nil)
		this.SkullSpikes:SetTexture(nil)
		this.RightFillagree:SetTexture(nil)
		this.LeftFillagree:SetTexture(nil)
		for i = 1, #this.LootFrames do
			this.LootFrames[1]:DisableDrawLayer("BACKGROUND")
			self:addButtonBorder{obj=this.LootFrames[i], relTo=this.LootFrames[i].Icon, reParent={this.LootFrames[i].Count}}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.AzeriteLevelUpToast, "OnShow", function(this)
		this:DisableDrawLayer("BACKGROUND")
		this.GlowLineBottomBurst:SetTexture(nil)
		this.CloudyLineRight:SetTexture(nil)
		this.CloudyLineRMover:SetTexture(nil)
		this.CloudyLineLeft:SetTexture(nil)
		this.CloudyLineLMover:SetTexture(nil)
		this.BottomLineLeft:SetTexture(nil)
		this.BottomLineRight:SetTexture(nil)
		this.Stars1:SetTexture(nil)
		this.Stars2:SetTexture(nil)
		this.IconGlowBurst:SetTexture(nil)
		this.IconStarBurst:SetTexture(nil)
		this.WhiteIconGlow:SetTexture(nil)
		this.WhiteStarBurst:SetTexture(nil)

		-- hook this to disable Animations
		self:RawHook(this.ShowAnim, "Play", function(this)
		end, true)

		self:Unhook(this, "OnShow")
	end)

end

local skinCheckBtns
if _G.PVEFrame then
	-- The following function is used by the LFDFrame & RaidFinder functions
	function skinCheckBtns(frame)

		for _, type in _G.pairs{"Tank", "Healer", "DPS", "Leader"} do
			if aObj.modChkBtns then
				aObj:skinCheckButton{obj=_G[frame .. "QueueFrameRoleButton" .. type].checkButton}
			end
			if _G[frame .. "QueueFrameRoleButton" .. type].background then
				_G[frame .. "QueueFrameRoleButton" .. type].background:SetTexture(nil)
			end
			if _G[frame .. "QueueFrameRoleButton" .. type].incentiveIcon then
				_G[frame .. "QueueFrameRoleButton" .. type].incentiveIcon.border:SetTexture(nil)
			end
		end

	end
end
aObj.blizzFrames[ftype].LFDFrame = function(self)
	if not self.prdb.PVEFrame or self.initialized.LFDFrame then return end
	self.initialized.LFDFrame = true

	self:SecureHookScript(_G.LFDRoleCheckPopup, "OnShow", function(this)
		self:removeNineSlice(this.Border)
		if self.modBtns then
			self:skinStdButton{obj=_G.LFDRoleCheckPopupAcceptButton}
			self:skinStdButton{obj=_G.LFDRoleCheckPopupDeclineButton}
		end
		self:addSkinFrame{obj=this, ft=ftype, kfs=true}

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.LFDReadyCheckPopup, "OnShow", function(this)
		self:removeNineSlice(this.Border)
		if self.modBtns then
			self:skinStdButton{obj=this.YesButton}
			self:skinStdButton{obj=this.NoButton}
		end
		self:addSkinFrame{obj=this, ft=ftype, kfs=true}

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.LFDReadyCheckPopup)

	-- LFD Parent Frame (now part of PVE Frame)
	self:SecureHookScript(_G.LFDParentFrame, "OnShow", function(this)
		self:keepFontStrings(this)
		self:removeInset(this.Inset)

		-- LFD Queue Frame
		skinCheckBtns("LFD")
		_G.LFDQueueFrameBackground:SetAlpha(0)
		self:skinDropDown{obj=_G.LFDQueueFrameTypeDropDown}
		self:skinSlider{obj=_G.LFDQueueFrameRandomScrollFrame.ScrollBar}
		_G.LFDQueueFrameRandomScrollFrameChildFrame.MoneyReward.NameFrame:SetTexture(nil)
		self:removeMagicBtnTex(_G.LFDQueueFrameFindGroupButton)
		if self.modBtns then
			self:skinStdButton{obj=_G.LFDQueueFrameFindGroupButton}
		end
		if self.modBtnBs then
			self:SecureHook("LFDQueueFrameRandom_UpdateFrame", function()
				for i = 1, 5 do
					if _G["LFDQueueFrameRandomScrollFrameChildFrameItem" .. i] then
						_G["LFDQueueFrameRandomScrollFrameChildFrameItem" .. i .. "NameFrame"]:SetTexture(nil)
						self:addButtonBorder{obj=_G["LFDQueueFrameRandomScrollFrameChildFrameItem" .. i], libt=true}
					end
				end
				self:clrBtnBdr(_G.LFDQueueFrameFindGroupButton)
			end)
			self:addButtonBorder{obj=_G.LFDQueueFrameRandomScrollFrameChildFrame.MoneyReward, libt=true}
		end

		-- Specific List subFrame
		for i = 1, _G.NUM_LFD_CHOICE_BUTTONS do
			if self.modChkBtns then
				self:skinCheckButton{obj=_G["LFDQueueFrameSpecificListButton" .. i].enableButton}
			end
			if self.modBtns then
				self:skinExpandButton{obj=_G["LFDQueueFrameSpecificListButton" .. i].expandOrCollapseButton, sap=true}
			end
		end
		self:skinSlider{obj=_G.LFDQueueFrameSpecificListScrollFrame.ScrollBar, rt="background"}

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].LFGFrame = function(self)
	if not self.prdb.PVEFrame or self.initialized.LFGFrame then return end
	self.initialized.LFGFrame = true

	self:SecureHookScript(_G.LFGDungeonReadyPopup, "OnShow", function(this) -- a.k.a. ReadyCheck, also used for Island Expeditions
		self:removeNineSlice(_G.LFGDungeonReadyStatus.Border)
		self:removeNineSlice(_G.LFGDungeonReadyDialog.Border)

		self:addSkinFrame{obj=_G.LFGDungeonReadyStatus, ft=ftype, kfs=true, ofs=-5}
		self:addSkinFrame{obj=_G.LFGDungeonReadyDialog, ft=ftype, kfs=true, rp=true, ofs=-5, y2=10} -- use rp=true to make background visible
		if self.modBtns then
			self:skinStdButton{obj=_G.LFGDungeonReadyDialog.enterButton}
			self:skinStdButton{obj=_G.LFGDungeonReadyDialog.leaveButton}
		end
		_G.LFGDungeonReadyDialog.SetBackdrop = _G.nop

		_G.LFGDungeonReadyDialog.instanceInfo:DisableDrawLayer("BACKGROUND")

		-- show background texture if required
		if self.prdb.LFGTexture then
			self:SecureHook("LFGDungeonReadyPopup_Update", function()
				local lfgTex = _G.LFGDungeonReadyDialog.background
				lfgTex:SetAlpha(1) -- show texture
				-- adjust texture to fit within skinFrame
				lfgTex:SetWidth(288)
				if _G.LFGDungeonReadyPopup:GetHeight() < 200 then
					lfgTex:SetHeight(170)
				else
					lfgTex:SetHeight(200)
				end
				lfgTex:SetTexCoord(0, 1, 0, 1)
				lfgTex:ClearAllPoints()
				lfgTex:SetPoint("TOPLEFT", _G.LFGDungeonReadyDialog, "TOPLEFT", 9, -9)
				lfgTex = nil
			end)
		end

		-- RewardsFrame
		_G.LFGDungeonReadyDialogRewardsFrameReward1Border:SetAlpha(0)
		_G.LFGDungeonReadyDialogRewardsFrameReward2Border:SetAlpha(0)
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.LFGDungeonReadyDialogRewardsFrameReward1, relTo=_G.LFGDungeonReadyDialogRewardsFrameReward1.texture}
			self:addButtonBorder{obj=_G.LFGDungeonReadyDialogRewardsFrameReward2, relTo=_G.LFGDungeonReadyDialogRewardsFrameReward2.texture}
		end

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.LFGDungeonReadyPopup)

	-- hook new button creation
	self:RawHook("LFGRewardsFrame_SetItemButton", function(...)
		local frame = self.hooks.LFGRewardsFrame_SetItemButton(...)
		_G[frame:GetName() .. "NameFrame"]:SetTexture(nil)
		if self.modBtnBs then
			self:addButtonBorder{obj=frame, libt=true}
		end
		return frame
	end, true)

	self:SecureHookScript(_G.LFGInvitePopup, "OnShow", function(this)
		self:removeNineSlice(this.Border)
		self:addSkinFrame{obj=this, ft=ftype}
		if self.modBtns then
			self:skinStdButton{obj=_G.LFGInvitePopupAcceptButton}
			self:skinStdButton{obj=_G.LFGInvitePopupDeclineButton}
		end
		if self.modChkBtns then
			for i = 1, #this.RoleButtons do
				self:skinCheckButton{obj=this.RoleButtons[i].checkButton}
			end
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].LFGList = function(self)
	if not self.prdb.PVEFrame or self.initialized.LFGList then return end
	self.initialized.LFGList = true

	self:SecureHookScript(_G.LFGListFrame, "OnShow", function(this)
		-- Premade Groups LFGListPVEStub/LFGListPVPStub
		-- CategorySelection
		self:removeInset(this.CategorySelection.Inset)
		self:removeMagicBtnTex(this.CategorySelection.FindGroupButton)
		self:removeMagicBtnTex(this.CategorySelection.StartGroupButton)
		if self.modBtns then
			self:skinStdButton{obj=this.CategorySelection.StartGroupButton}
			self:skinStdButton{obj=this.CategorySelection.FindGroupButton}
			self:SecureHook("LFGListCategorySelection_UpdateNavButtons", function(this)
				self:clrBtnBdr(this.StartGroupButton)
				self:clrBtnBdr(this.FindGroupButton)
			end)
		end
		self:SecureHook("LFGListCategorySelection_AddButton", function(this, _)
			for i = 1, #this.CategoryButtons do
				this.CategoryButtons[i].Cover:SetTexture(nil)
			end
		end)

		-- NothingAvailable
		self:removeInset(this.NothingAvailable.Inset)

		-- SearchPanel
		local sp = this.SearchPanel
		self:skinEditBox{obj=sp.SearchBox, regs={6, 7, 8}, mi=true} -- 6 is text, 7 is icon, 8 maybe added fontstring
		self:addSkinFrame{obj=sp.AutoCompleteFrame, ft=ftype, kfs=true, x1=4, y1=4, y2=4}
		self:removeInset(sp.ResultsInset)
		self:skinSlider{obj=sp.ScrollFrame.scrollBar, wdth=-4}
		self:removeMagicBtnTex(sp.BackButton)
		self:removeMagicBtnTex(sp.SignUpButton)
		if self.modBtns then
			for i = 1, #sp.ScrollFrame.buttons do
				self:skinStdButton{obj=sp.ScrollFrame.buttons[i].CancelButton}
			end
			self:skinStdButton{obj=sp.ScrollFrame.StartGroupButton}
			self:skinStdButton{obj=sp.BackButton}
			self:skinStdButton{obj=sp.SignUpButton}
			self:SecureHook("LFGListSearchPanel_UpdateButtonStatus", function(this)
				self:clrBtnBdr(this.ScrollFrame.StartGroupButton)
				self:clrBtnBdr(this.SignUpButton)
			end)
		end
		if self.modBtnBs then
		    self:addButtonBorder{obj=sp.FilterButton, ofs=0}
			self:addButtonBorder{obj=sp.RefreshButton, ofs=-2}
		end
		sp = nil

		-- ApplicationViewer
		local av = this.ApplicationViewer
		av:DisableDrawLayer("BACKGROUND")
		self:removeInset(av.Inset)
		for _ ,type in _G.pairs{"Name", "Role", "ItemLevel"} do
			self:removeRegions(av[type .. "ColumnHeader"], {1, 2, 3})
			if self.modBtns then
				 self:skinStdButton{obj=av[type .. "ColumnHeader"]}
			end
		end
		self:skinSlider{obj=av.ScrollFrame.scrollBar, wdth=-4}
		self:removeMagicBtnTex(av.RemoveEntryButton)
		self:removeMagicBtnTex(av.EditButton)
		if self.modBtnBs then
			 self:addButtonBorder{obj=av.RefreshButton, ofs=-2}
		end
		if self.modChkBtns then
			 self:skinCheckButton{obj=av.AutoAcceptButton}
		end
		if self.modBtns then
			for i = 1, #av.ScrollFrame.buttons do
				self:skinStdButton{obj=av.ScrollFrame.buttons[i].DeclineButton}
				self:skinStdButton{obj=av.ScrollFrame.buttons[i].InviteButton}
			end
			self:skinStdButton{obj=av.RemoveEntryButton}
			self:skinStdButton{obj=av.EditButton}
		end
		av = nil

		-- EntryCreation
		local ec = this.EntryCreation
		self:removeInset(ec.Inset)
		local ecafd = ec.ActivityFinder.Dialog
		self:removeNineSlice(ecafd.Border)
		self:skinEditBox{obj=ecafd.EntryBox, regs={6}, mi=true} -- 6 is text
		self:skinSlider{obj=ecafd.ScrollFrame.scrollBar, size=4}
		ecafd.BorderFrame:DisableDrawLayer("BACKGROUND")
		self:addSkinFrame{obj=ecafd, ft=ftype, kfs=true}
		if self.modBtns then
			self:skinStdButton{obj=ecafd.SelectButton}
			self:skinStdButton{obj=ecafd.CancelButton}
		end
		ecafd = nil
		self:skinEditBox{obj=ec.Name, regs={6}, mi=true} -- 6 is text
		self:skinDropDown{obj=ec.CategoryDropDown}
		self:skinDropDown{obj=ec.GroupDropDown}
		self:skinDropDown{obj=ec.ActivityDropDown}
		self:addFrameBorder{obj=ec.Description, ft=ftype, kfs=true, ofs=6}
		self:skinEditBox{obj=ec.ItemLevel.EditBox, regs={6}, mi=true} -- 6 is text
		self:skinEditBox{obj=ec.VoiceChat.EditBox, regs={6}, mi=true} -- 6 is text
		self:removeMagicBtnTex(ec.ListGroupButton)
		self:removeMagicBtnTex(ec.CancelButton)
		if self.modChkBtns then
			self:skinCheckButton{obj=ec.ItemLevel.CheckButton}
			self:skinCheckButton{obj=ec.HonorLevel.CheckButton}
			self:skinCheckButton{obj=ec.VoiceChat.CheckButton}
			self:skinCheckButton{obj=ec.PrivateGroup.CheckButton}
		end
		if self.modBtns then
			self:skinStdButton{obj=ec.ListGroupButton}
			self:skinStdButton{obj=ec.CancelButton}
			self:SecureHook("LFGListEntryCreation_UpdateValidState", function(this)
				self:clrBtnBdr(this.ListGroupButton)
			end)
		end
		ec = nil

		self:Unhook(this, "OnShow")
	end)

	-- LFGListApplication Dialog
	self:SecureHookScript(_G.LFGListApplicationDialog, "OnShow", function(this)
		self:removeNineSlice(this.Border)
		if self.modChkBtns then
			self:skinCheckButton{obj=this.HealerButton.CheckButton}
			self:skinCheckButton{obj=this.TankButton.CheckButton}
			self:skinCheckButton{obj=this.DamagerButton.CheckButton}
		end
		self:skinSlider{obj=this.Description.ScrollBar, wdth=-4}
		self:addFrameBorder{obj=this.Description, ft=ftype, ofs=6}
		this.Description.EditBox.Instructions:SetTextColor(self.BT:GetRGB())
		if self.modBtns then
			self:skinStdButton{obj=this.SignUpButton}
			self:skinStdButton{obj=this.CancelButton}
		end
		self:addSkinFrame{obj=this, ft=ftype, kfs=true}

		self:Unhook(this, "OnShow")
	end)

	-- LFGListInvite Dialog
	self:SecureHookScript(_G.LFGListInviteDialog, "OnShow", function(this)
		self:removeNineSlice(this.Border)
		self:addSkinFrame{obj=this, ft=ftype}
		if self.modBtns then
			self:skinStdButton{obj=this.AcceptButton}
			self:skinStdButton{obj=this.DeclineButton}
			self:skinStdButton{obj=this.AcknowledgeButton}
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].LFRFrame = function(self)
	if not self.prdb.RaidFrame or self.initialized.LFRFrame then return end
	self.initialized.LFRFrame = true

	self:SecureHookScript(_G.RaidBrowserFrame, "OnShow", function(this)
		self:addSkinFrame{obj=this, ft=ftype, kfs=true}
		-- LFR Parent Frame
		-- LFR Queue Frame
		self:removeInset(_G.LFRQueueFrameRoleInset)
		self:removeInset(_G.LFRQueueFrameCommentInset)
		self:removeInset(_G.LFRQueueFrameListInset)
		_G.LFRQueueFrameCommentExplanation:SetTextColor(self.BT:GetRGB())

		-- Specific List subFrame
		for i = 1, _G.NUM_LFR_CHOICE_BUTTONS do
			self:skinCheckButton{obj=_G["LFRQueueFrameSpecificListButton" .. i].enableButton}
			self:skinExpandButton{obj=_G["LFRQueueFrameSpecificListButton" .. i].expandOrCollapseButton, sap=true}
		end
		self:skinSlider{obj=_G.LFRQueueFrameSpecificListScrollFrame.ScrollBar}

		-- LFR Browse Frame
		self:removeInset(_G.LFRBrowseFrameRoleInset)
		self:skinDropDown{obj=_G.LFRBrowseFrameRaidDropDown}
		self:skinSlider{obj=_G.LFRBrowseFrameListScrollFrame.ScrollBar, rt="background"}
		self:keepFontStrings(_G.LFRBrowseFrame)

		-- Tabs (side)
		for i = 1, 2 do
			_G["LFRParentFrameSideTab" .. i]:DisableDrawLayer("BACKGROUND")
			self:addButtonBorder{obj=_G["LFRParentFrameSideTab" .. i]}
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].LossOfControl = function(self)
	if not self.prdb.LossOfControl or self.initialized.LossOfControl then return end
	self.initialized.LossOfControl = true

	if self.modBtnBs then
		self:SecureHookScript(_G.LossOfControlFrame, "OnShow", function(this)
			self:addButtonBorder{obj=this, relTo=this.Icon}

			self:Unhook(this, "OnShow")
		end)
	end

end

aObj.blizzLoDFrames[ftype].MacroUI = function(self)
	if not self.prdb.MacroUI or self.initialized.MacroUI then return end
	self.initialized.MacroUI = true

	self:SecureHookScript(_G.MacroFrame, "OnShow", function(this)
		self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=true, upwards=true, offsets={x1=-3, y1=-3, x2=3, y2=-3}, ignoreHLTex=true})
		_G.RaiseFrameLevel(_G.MacroFrameTab1)
		_G.RaiseFrameLevel(_G.MacroFrameTab2)
		self:addFrameBorder{obj=_G.MacroButtonScrollFrame, ft=ftype, ofs=12, y1=10, x2=31}
		self:skinSlider{obj=_G.MacroButtonScrollFrame.ScrollBar, rt="artwork"}
		self:skinSlider{obj=_G.MacroFrameScrollFrame.ScrollBar}
		self:skinEditBox{obj=_G.MacroFrameText, noSkin=true}
		self:addFrameBorder{obj=_G.MacroFrameTextBackground, ft=ftype}
		if self.modBtns then
			self:skinStdButton{obj=_G.MacroEditButton}
			self:skinStdButton{obj=_G.MacroCancelButton}
			self:skinStdButton{obj=_G.MacroSaveButton}
			self:skinStdButton{obj=_G.MacroDeleteButton}
			self:skinStdButton{obj=_G.MacroNewButton, x2=-2}
			self:skinStdButton{obj=_G.MacroExitButton, x1=2}
			for _, btn in _G.pairs{_G.MacroEditButton, _G.MacroDeleteButton, _G.MacroNewButton} do
				self:SecureHook(btn, "Disable", function(this, _)
					self:clrBtnBdr(this)
				end)
				self:SecureHook(btn, "Enable", function(this, _)
					self:clrBtnBdr(this)
				end)
			end
		end
		_G.MacroFrameSelectedMacroButton:DisableDrawLayer("BACKGROUND")
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.MacroFrameSelectedMacroButton, relTo=_G.MacroFrameSelectedMacroButtonIcon, clr="grey", ca=0.85}
		end
		for i = 1, _G.MAX_ACCOUNT_MACROS do
			_G["MacroButton" .. i]:DisableDrawLayer("BACKGROUND")
			if self.modBtnBs then
				self:addButtonBorder{obj=_G["MacroButton" .. i], relTo=_G["MacroButton" .. i .. "Icon"], reParent={_G["MacroButton" .. i .. "Name"]}, clr="grey", ca=0.85}
			end
		end
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, hdr=true, ri=true, x2=self.isClsc and 1 or nil}

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.MacroPopupFrame, "OnShow", function(this)
		self:adjHeight{obj=this, adj=20}
		self:removeRegions(this.BorderBox, {1, 2, 3, 4, 5, 6, 7, 8})
		self:skinEditBox{obj=_G.MacroPopupEditBox}
		self:adjHeight{obj=_G.MacroPopupScrollFrame, adj=20} -- stretch to bottom of scroll area
		self:skinSlider{obj=_G.MacroPopupScrollFrame.ScrollBar, rt="background"}
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ofs=1, x2=-2, y2=4}
		if self.modBtns then
			self:skinStdButton{obj=this.BorderBox.CancelButton}
			self:skinStdButton{obj=this.BorderBox.OkayButton}
			self:SecureHook("MacroPopupOkayButton_Update", function()
				self:clrBtnBdr(this.BorderBox.OkayButton)
			end)
		end
		for i = 1, _G.NUM_MACRO_ICONS_SHOWN do
			_G["MacroPopupButton" .. i]:DisableDrawLayer("BACKGROUND")
			if self.modBtnBs then
				self:addButtonBorder{obj=_G["MacroPopupButton" .. i], relTo=_G["MacroPopupButton" .. i .. "Icon"], reParent={_G["MacroPopupButton" .. i .. "Name"]}, clr="grey", ca=0.85}
			end
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].MailFrame = function(self)
	if not self.prdb.MailFrame or self.initialized.MailFrame then return end
	self.initialized.MailFrame = true

	self:SecureHookScript(_G.MailFrame, "OnShow", function(this)
		self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, ignoreSize=self.isClsc and true})
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true, x2=self.isClsc and 1 or nil, y2=-5}
		--	Inbox Frame
		for i = 1, _G.INBOXITEMS_TO_DISPLAY do
			self:keepFontStrings(_G["MailItem" .. i])
			_G["MailItem" .. i].Button:DisableDrawLayer("BACKGROUND")
			if self.modBtnBs then
				self:addButtonBorder{obj=_G["MailItem" .. i].Button, relTo=_G["MailItem" .. i].Button.Icon, reParent={_G["MailItem" .. i .. "ButtonCount"]}}
			end
		end
		self:moveObject{obj=_G.InboxTooMuchMail, y=-24} -- move icon down
		self:removeRegions(_G.InboxFrame, {1}) -- background texture
		if self.modBtns then
			self:skinStdButton{obj=_G.OpenAllMail}
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.InboxPrevPageButton, ofs=-2, y1=-3, x2=-3}
			self:addButtonBorder{obj=_G.InboxNextPageButton, ofs=-2, y1=-3, x2=-3}
			self:SecureHook("InboxFrame_Update", function(this)
				for i = 1, _G.INBOXITEMS_TO_DISPLAY do
					self:clrButtonFromBorder(_G["MailItem" .. i].Button)
				end
				self:clrPNBtns("Inbox")
			end)
		end
		--	Send Mail Frame
		self:keepFontStrings(_G.SendMailFrame)
		self:skinSlider{obj=_G.SendMailScrollFrame.ScrollBar, rt={"background", "artwork"}}
		for i = 1, _G.ATTACHMENTS_MAX_SEND do
			if not self.modBtnBs then
				self:resizeEmptyTexture(self:getRegion(_G["SendMailAttachment" .. i], 1))
			else
				_G["SendMailAttachment" .. i]:DisableDrawLayer("BACKGROUND")
				self:addButtonBorder{obj=_G["SendMailAttachment" .. i], reParent={_G["SendMailAttachment" .. i].Count}}
			end
		end
		self:skinEditBox{obj=_G.SendMailNameEditBox, regs={3}, noWidth=true} -- N.B. region 3 is text
		self:skinEditBox{obj=_G.SendMailSubjectEditBox, regs={3}, noWidth=true} -- N.B. region 3 is text
		self:skinEditBox{obj=_G.SendMailBodyEditBox, noSkin=true}
		_G.SendMailBodyEditBox:SetTextColor(self.prdb.BodyText.r, self.prdb.BodyText.g, self.prdb.BodyText.b)
		self:skinMoneyFrame{obj=_G.SendMailMoney, moveSEB=true, moveGEB=true, noWidth=true}
		self:removeInset(_G.SendMailMoneyInset)
		_G.SendMailMoneyBg:DisableDrawLayer("BACKGROUND")
		if self.modBtns then
			self:skinStdButton{obj=_G.SendMailMailButton}
			self:skinStdButton{obj=_G.SendMailCancelButton}
			self:SecureHook(_G.SendMailMailButton, "Disable", function(this, _)
				self:clrBtnBdr(this)
			end)
			self:SecureHook(_G.SendMailMailButton, "Enable", function(this, _)
				self:clrBtnBdr(this)
			end)
		end
		--	Open Mail Frame
		_G.OpenMailScrollFrame:DisableDrawLayer("BACKGROUND")
		self:skinSlider{obj=_G.OpenMailScrollFrame.ScrollBar, rt="overlay"}
		_G.OpenMailBodyText:SetTextColor(self.BT:GetRGB())
		self:addSkinFrame{obj=_G.OpenMailFrame, ft=ftype, kfs=true, ri=true}
		if self.modBtns then
			self:skinStdButton{obj=_G.OpenMailReportSpamButton}
			self:skinStdButton{obj=_G.OpenMailCancelButton}
			self:skinStdButton{obj=_G.OpenMailDeleteButton}
			self:skinStdButton{obj=_G.OpenMailReplyButton}
			self:SecureHook("OpenMail_Update", function()
				self:clrBtnBdr(_G.OpenMailReportSpamButton)
				self:clrBtnBdr(_G.OpenMailReplyButton)
			end)

		end
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.OpenMailLetterButton, ibt=true}
			self:addButtonBorder{obj=_G.OpenMailMoneyButton, ibt=true}
			for i = 1, _G.ATTACHMENTS_MAX_RECEIVE do
				self:addButtonBorder{obj=_G["OpenMailAttachmentButton" .. i], ibt=true}
			end
		end
		-- Invoice Frame Text fields
		local fields = {"ItemLabel", "Purchaser", "SalePrice", "Deposit", "HouseCut", "AmountReceived", "NotYetSent", "MoneyDelay"}
		if self.isClsc then
			self:add2Table(fields, "BuyMode")
		end
		for _, type in _G.pairs(fields) do
			_G["OpenMailInvoice" .. type]:SetTextColor(self.BT:GetRGB())
		end
		fields = nil

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].MainMenuBar = function(self)
	if self.initialized.MainMenuBar then return end
	self.initialized.MainMenuBar = true

	if _G.IsAddOnLoaded("Dominos") then
		self.blizzFrames[ftype].MainMenuBar = nil
		return
	end

	if self.prdb.MainMenuBar.skin then

		_G.MicroButtonAndBagsBar:DisableDrawLayer("BACKGROUND")
		_G.MainMenuBarArtFrameBackground:DisableDrawLayer("BACKGROUND")
		_G.MainMenuBarArtFrame.LeftEndCap:SetTexture(nil)
		_G.MainMenuBarArtFrame.RightEndCap:SetTexture(nil)
		_G.StatusTrackingBarManager:DisableDrawLayer("OVERLAY") -- status bar textures
		local bar
		for i = 1, #_G.StatusTrackingBarManager.bars do
			bar = _G.StatusTrackingBarManager.bars[i]
			self:skinStatusBar{obj=bar.StatusBar, bgTex=bar.StatusBar.Background, otherTex={bar.ExhaustionLevelFillBar or nil}}
			if bar.ExhaustionTick then -- HonorStatusBar & ExpStatusBar
				bar.ExhaustionTick:GetNormalTexture():SetTexture(nil)
				bar.ExhaustionTick:GetHighlightTexture():SetTexture(nil)
			elseif bar.Tick then -- ArtifactStatusBar
				bar.Tick:GetNormalTexture():SetTexture(nil)
				bar.Tick:GetHighlightTexture():SetTexture(nil)
			end
		end
		bar = nil

		-- StanceBar Frame
		self:keepFontStrings(_G.StanceBarFrame)
		-- Possess Bar Frame
		self:keepFontStrings(_G.PossessBarFrame)
		-- Pet Action Bar Frame
		self:keepFontStrings(_G.PetActionBarFrame)
		-- Shaman's Totem Frame
		self:keepFontStrings(_G.MultiCastFlyoutFrame)

		if self.modBtnBs then
			for i = 1, _G.NUM_STANCE_SLOTS do
				self:addButtonBorder{obj=_G["StanceButton" .. i], abt=true, sec=true}
			end
			for i = 1, _G.NUM_POSSESS_SLOTS do
				self:addButtonBorder{obj=_G["PossessButton" .. i], abt=true, sec=true}
			end
			local bName
			for i = 1, _G.NUM_PET_ACTION_SLOTS do
				bName = "PetActionButton" .. i
				self:addButtonBorder{obj=_G[bName], abt=true, sec=true, ofs=3, reParent={_G[bName .. "AutoCastable"], _G[bName .. "SpellHighlightTexture"]}}
				_G[bName .. "Shine"]:SetParent(_G[bName].sbb)
			end
			bName = nil
			-- Action Buttons
			for i = 1, _G.NUM_ACTIONBAR_BUTTONS do
				_G["ActionButton" .. i].FlyoutBorder:SetTexture(nil)
				_G["ActionButton" .. i].FlyoutBorderShadow:SetTexture(nil)
				self:addButtonBorder{obj=_G["ActionButton" .. i], abt=true, seca=true, ofs=2.5}
			end
			-- ActionBar buttons
			self:addButtonBorder{obj=_G.ActionBarUpButton, clr="gold"}
			self:addButtonBorder{obj=_G.ActionBarDownButton, clr="gold"}
			-- Micro buttons
			local mBut
			for i = 1, #_G.MICRO_BUTTONS do
				mBut = _G[_G.MICRO_BUTTONS[i]]
				self:addButtonBorder{obj=mBut, es=24, ofs=2.5, reParent=mBut == "MainMenuMicroButton" and {mBut.Flash, _G.MainMenuBarPerformanceBar, _G.MainMenuBarDownload} or {mBut.Flash}, clr="grey"}
			end
			mBut = nil
			-- skin bag buttons
			self:addButtonBorder{obj=_G.MainMenuBarBackpackButton, ibt=true, ofs=2.5}
			self:addButtonBorder{obj=_G.CharacterBag0Slot, ibt=true, ofs=2.5}
			self:addButtonBorder{obj=_G.CharacterBag1Slot, ibt=true, ofs=2.5}
			self:addButtonBorder{obj=_G.CharacterBag2Slot, ibt=true, ofs=2.5}
			self:addButtonBorder{obj=_G.CharacterBag3Slot, ibt=true, ofs=2.5}
			-- MultiCastActionBarFrame
			self:addButtonBorder{obj=_G.MultiCastSummonSpellButton, abt=true, sec=true, ofs=5}
			self:addButtonBorder{obj=_G.MultiCastRecallSpellButton, abt=true, sec=true, ofs=5}
			for i = 1, _G.NUM_MULTI_CAST_PAGES * _G.NUM_MULTI_CAST_BUTTONS_PER_PAGE do
				self:addButtonBorder{obj=_G["MultiCastActionButton" .. i], abt=true, seca=true, ofs=5}
			end
			-- MultiBar Buttons
			for _, type in _G.pairs{"BottomLeft", "BottomRight", "Right", "Left"} do
				local btn
				for i = 1, _G.NUM_MULTIBAR_BUTTONS do
					btn = _G["MultiBar" .. type .. "Button" .. i]
					btn.FlyoutBorder:SetTexture(nil)
					btn.FlyoutBorderShadow:SetTexture(nil)
					btn.Border:SetAlpha(0) -- texture changed in blizzard code
					if not btn.noGrid then
						_G[btn:GetName() .. "FloatingBG"]:SetAlpha(0)
					end
					self:addButtonBorder{obj=btn, abt=true, seca=true, ofs=2.5}
				end
				btn = nil
			end
		end

	end

	-- these are done here as other AddOns may require them to be skinned
	if self.modBtnBs then
		self:addButtonBorder{obj=_G.MainMenuBarVehicleLeaveButton, clr="grey"}
	end

	-- UnitPowerBarAlt (inc. PlayerPowerBarAlt)
	if self.prdb.MainMenuBar.altpowerbar then
		local function skinUnitPowerBarAlt(upba)
			-- Don't change the status bar texture as it changes dependant upon type of power type required
			upba.frame:SetAlpha(0)
			-- adjust height and TextCoord so background appears, this enables the numbers to become easier to see
			upba.counterBar:SetHeight(26)
			upba.counterBar.BG:SetTexCoord(0.0, 1.0, 0.35, 0.40)
			upba.counterBar.BGL:SetAlpha(0)
			upba.counterBar.BGR:SetAlpha(0)
			upba.counterBar:DisableDrawLayer("ARTWORK")
		end
		self:SecureHook("UnitPowerBarAlt_SetUp", function(this, _)
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

end

aObj.blizzFrames[ftype].MenuFrames = function(self)
	if not self.prdb.MenuFrames or self.initialized.MenuFrames then return end
	self.initialized.MenuFrames = true

	self:SecureHookScript(_G.GameMenuFrame, "OnShow", function(this)
		self:removeNineSlice(this.Border)
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true, hdr=true}
		if self.modBtns then
			for _, child in _G.ipairs{this:GetChildren()} do
				if child:IsObjectType("Button") then
					self:skinStdButton{obj=child}
				end
			end
		end

		self:Unhook(this, "OnShow")
	end)

	-- Rating Menu
	self:SecureHookScript(_G.RatingMenuFrame, "OnShow", function(this)
		self:removeNineSlice(this.Border)
		self:addSkinFrame{obj=_G.RatingMenuFrame, ft=ftype, hdr=true}
		if self.modBtns then
			self:skinStdButton{obj=_G.RatingMenuButtonOkay}
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].Minimap = function(self)
	if not self.prdb.Minimap.skin or self.initialized.Minimap then return end
	self.initialized.Minimap = true

	if _G.IsAddOnLoaded("SexyMap") then
		self.blizzFrames[ftype].Minimap = nil
		return
	end

	-- fix for Titan Panel moving MinimapCluster
	if _G.IsAddOnLoaded("Titan") then _G.TitanMovable_AddonAdjust("MinimapCluster", true) end

	-- Cluster Frame
	_G.MinimapBorderTop:Hide()
	_G.MinimapZoneTextButton:ClearAllPoints()
	_G.MinimapZoneTextButton:SetPoint("BOTTOMLEFT", _G.Minimap, "TOPLEFT", 0, 5)
	_G.MinimapZoneTextButton:SetPoint("BOTTOMRIGHT", _G.Minimap, "TOPRIGHT", 0, 5)
	_G.MinimapZoneText:ClearAllPoints()
	_G.MinimapZoneText:SetPoint("CENTER")
	-- World Map Button
	_G.MiniMapWorldMapButton:ClearAllPoints()
	_G.MiniMapWorldMapButton:SetPoint("LEFT", _G.MinimapZoneTextButton, "RIGHT", -4, 0)
	if self.modBtns then
		self:addSkinButton{obj=_G.MinimapZoneTextButton, parent=_G.MinimapZoneTextButton, ft=ftype, x1=-5, x2=5}
		self:skinOtherButton{obj=_G.MiniMapWorldMapButton, font=self.fontP, text="M"}
	end

	-- Minimap
	_G.Minimap:SetMaskTexture([[Interface\Buttons\WHITE8X8]]) -- needs to be a square texture
	-- use a backdrop with no Texture otherwise the map tiles are obscured
	self:addSkinFrame{obj=_G.Minimap, ft=ftype, aso={bd=8}, ofs=5}
	if self.prdb.Minimap.gloss then
		_G.RaiseFrameLevel(_G.Minimap.sf)
	else
		_G.LowerFrameLevel(_G.Minimap.sf)
	end

	if not self.isClsc then
		-- N.B. copied from SexyMap
		-- Removes the circular "waffle-like" texture that shows when using a non-circular minimap in the blue quest objective area.
		_G.Minimap:SetArchBlobRingScalar(0)
		_G.Minimap:SetArchBlobRingAlpha(0)
		_G.Minimap:SetQuestBlobRingScalar(0)
		_G.Minimap:SetQuestBlobRingAlpha(0)
	else
		if self.modBtns then
			_G.RaiseFrameLevelByTwo(_G.MinimapToggleButton)
			self:moveObject{obj=_G.MinimapToggleButton, x=-8, y=1}
			self:skinCloseButton{obj=_G.MinimapToggleButton, noSkin=true}
		end
	end

	-- Minimap Backdrop Frame
	self:keepFontStrings(_G.MinimapBackdrop)

	-- Buttons
	-- on LHS
	local yOfs = -18 -- allow for GM Ticket button
	local function skinMmBut(name)
		if _G["MiniMap" .. name] then
			_G["MiniMap" .. name]:ClearAllPoints()
			_G["MiniMap" .. name]:SetPoint("TOPRIGHT", _G.Minimap, "TOPLEFT", 0, yOfs)
			yOfs = yOfs - _G["MiniMap" .. name]:GetHeight() + 3
		end
	end
	skinMmBut("Tracking")
	skinMmBut("VoiceChatFrame")
	yOfs = nil
	-- on RHS
	_G.MiniMapMailFrame:ClearAllPoints()
	_G.MiniMapMailFrame:SetPoint("LEFT", _G.Minimap, "RIGHT", -10, 28)

	if not self.isClsc then
		-- Difficulty indicators
		-- hook this to mamage MiniMapInstanceDifficulty texture
		self:SecureHook("MiniMapInstanceDifficulty_Update", function()
			local _, _, difficulty, _, maxPlayers, _, _ = _G.GetInstanceInfo()
			local _, _, isHeroic, _ = _G.GetDifficultyInfo(difficulty)
			local xOffset = 0
			if maxPlayers >= 10
			and maxPlayers <= 19
			then
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
	end

	self:moveObject{obj=_G.BuffFrame, x=-40}

	-- hook this to handle Jostle Library
	if _G.LibStub:GetLibrary("LibJostle-3.0", true) then
		self:RawHook(_G.MinimapCluster, "SetPoint", function(this, point, relTo, relPoint, _)
			self.hooks[this].SetPoint(this, point, relTo, relPoint, -6, -18)
		end, true)
	end

end

aObj.blizzFrames[ftype].MinimapButtons = function(self)
	if not self.prdb.MinimapButtons.skin or self.initialized.MinimapButtons then return end
	self.initialized.MinimapButtons = true

	if not self.modBtns then return end

	local minBtn = self.prdb.MinimapButtons.style

	local function mmKids(mmObj)

		local objName, objType
		for _, obj in _G.ipairs{mmObj:GetChildren()} do
			objName, objType = obj:GetName(), obj:GetObjectType()
			-- aObj:Debug("mmKids: [%s, %s, %s]", objName, objType, obj:GetNumRegions())
			if not obj.sb
			and not obj.sf
			and not obj.point -- TomTom waypoint
			and not obj.texture -- HandyNotes pin
			and objType == "Button"
			or (objType == "Frame" and objName == "MiniMapMailFrame")
			and objName ~= "QueueStatusMinimapButton"
			and objName ~= "OQ_MinimapButton"
			then
				for _, reg in _G.ipairs{obj:GetRegions()} do
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
						elseif aObj:hasTextInTexture(reg, "Background") then
							reg:SetTexture(nil)
						end
					end
				end
				if not minBtn then
					if objType == "Button" then
						aObj:addSkinButton{obj=obj, ft=ftype, parent=obj, sap=true}
					else
						aObj:addSkinFrame{obj=obj, ft=ftype}
					end
				end
			end
		end
		objName, objType = nil, nil

	end
	local function makeBtnSquare(obj, x1, y1, x2, y2)

		obj:SetSize(26, 26)
		obj:GetNormalTexture():SetTexCoord(x1, y1, x2, y2)
		obj:GetPushedTexture():SetTexCoord(x1, y1, x2, y2)
		obj:SetHighlightTexture([[Interface\Buttons\ButtonHilight-Square]])
		aObj:addSkinFrame{obj=obj, ft=ftype, nb=true, aso={ba=minBtn and 0 or 1, bba=minBtn and 0 or 1, ng=minBtn and true or nil}, ofs=4}
		-- make sure textures appear above skinFrame
		_G.RaiseFrameLevelByTwo(obj)
		_G.LowerFrameLevel(obj.sf)
		-- alter the HitRectInsets to make it easier to activate
		obj:SetHitRectInsets(-5, -5, -5, -5)

	end

	-- skin Minimap children, allow for delayed addons to be loaded (e.g. Baggins)
	_G.C_Timer.After(0.5, function() mmKids(_G.Minimap) end)

	if not self.isClsc then
		-- Calendar button
		makeBtnSquare(_G.GameTimeFrame, 0.1, 0.31, 0.16, 0.6)
		-- MinimapBackdrop
		_G.MiniMapTrackingBackground:SetTexture(nil)
		_G.MiniMapTrackingButtonBorder:SetTexture(nil)
		if not minBtn then
			_G.MiniMapTracking:SetScale(0.9)
			self:addSkinFrame{obj=_G.MiniMapTracking, ft=ftype, nb=true}
		end
		_G.QueueStatusMinimapButtonBorder:SetTexture(nil)
		self:addSkinButton{obj=_G.QueueStatusMinimapButton, ft=ftype, sap=true}
		-- make sure textures appear above skinFrame
		_G.RaiseFrameLevelByTwo(_G.QueueStatusMinimapButton)
		_G.LowerFrameLevel(_G.QueueStatusMinimapButton.sb)
		-- skin any moved Minimap buttons if required
		if _G.IsAddOnLoaded("MinimapButtonFrame") then mmKids(_G.MinimapButtonFrame) end
		-- show the Bongos minimap icon if required
		if _G.IsAddOnLoaded("Bongos") then _G.Bongos3MinimapButton.icon:SetDrawLayer("ARTWORK") end
	else
		-- remove ring from GameTimeFrame texture
		self:RawHook(_G.GameTimeTexture, "SetTexCoord", function(this, minx, maxx, miny, maxy)
			minx, maxx, miny, maxy = minx + 0.075, maxx - 0.075, miny + 0.175, maxy - 0.2
			self.hooks[this].SetTexCoord(this, minx, maxx, miny, maxy)
		end, true)
		_G.C_Timer.After(0.25, function()
			_G.GameTimeFrame:SetSize(28, 28)
			self:addSkinFrame{obj=_G.GameTimeFrame, ft=ftype, nb=true, ofs=4}
			self:moveObject{obj=_G.GameTimeFrame, x=-6, y=-2}
			_G.GameTimeFrame.timeOfDay = 0
			_G.GameTimeFrame_Update(_G.GameTimeFrame)
		end)
		_G.MiniMapTrackingBorder:SetTexture(nil)
		self:addSkinFrame{obj=_G.MiniMapTrackingFrame, ft=ftype, nb=true, aso={bd=10}, x1=4, y1=-3}
		self:moveObject{obj=_G.MiniMapTrackingFrame, x=-15}
		self:moveObject{obj=_G.MiniMapMailFrame, y=-4}
	end

	_G.MiniMapMailIcon:SetTexture([[Interface\Minimap\Tracking\Mailbox.blp]])
	_G.MiniMapMailFrame:SetSize(26, 26)

	-- Zoom Buttons
	local btn, txt, xOfs, yOfs
	for _, btnName in _G.pairs{"In", "Out"} do
		if btnName == "In" then
			btn = _G.MinimapZoomIn
			txt = self.modUIBtns.plus
			if not self.isClsc then
				xOfs, yOfs = 14, -12 -- 72, -25
			else
				xOfs, yOfs = 9, -24 -- 77, -13
			end
		else
			btn = _G.MinimapZoomOut
			txt = self.modUIBtns.minus
			if not self.isClsc then
				xOfs, yOfs = 20, -10 -- 50, -43
			else
				xOfs, yOfs = 19, -12 -- 51, -41
			end
		end
		self:skinOtherButton{obj=btn, text=txt, aso={bbclr=btn:IsEnabled() and "gold" or "disabled"}, noHooks=true}
		self:moveObject{obj=btn, x=xOfs, y=yOfs}
		-- make button text appear in correct colour
		btn:SetNormalFontObject(btn:IsEnabled() and self.modUIBtns.fontP or self.modUIBtns.fontDP) -- N.B. use module name instead of shortcut
		if not btn:IsEnabled() then
			btn:Enable()
			btn:Disable()
		end
		local function clrZoomBtns()
			for _, btnName in _G.pairs{"In", "Out"} do
				btn = btnName == "In" and _G.MinimapZoomIn or _G.MinimapZoomOut
				aObj:clrBBC(btn.sb, btn:IsEnabled() and "gold" or "disabled")
				-- make button text appear in correct colour
				btn:SetNormalFontObject(btn:IsEnabled() and aObj.modUIBtns.fontP or aObj.modUIBtns.fontDP) -- N.B. use module name instead of shortcut
			end
		end
		self:SecureHookScript(btn, "OnClick", function(this)
			clrZoomBtns()
		end)
		self:RegisterEvent("MINIMAP_UPDATE_ZOOM", clrZoomBtns)
	end
	btn, txt, xOfs, yOfs = nil, nil, nil, nil

	-- skin other minimap buttons as required
	if not minBtn then
		local function skinMMBtn(_, btn, _)
			-- aObj:Debug("skinMMBtn#1: [%s, %s, %s]", cb, btn, name)
			for _, reg in _G.ipairs{btn:GetRegions()} do
				if reg:GetObjectType() == "Texture" then
					-- aObj:Debug("skinMMBtn#2: [%s, %s, %s]", reg, reg:GetName(), reg:GetTexture())
					if aObj:hasTextInName(reg, "Border")
					or aObj:hasTextInTexture(reg, "TrackingBorder")
					or aObj:hasTextInTexture(reg, "136430") -- file ID for Border texture
					then
						reg:SetTexture(nil)
					end
				end
			end

			aObj:addSkinButton{obj=btn, parent=btn, sap=true}

		end
		-- wait until all AddOn skins have been loaded
		_G.C_Timer.After(0.5, function()
			for addon, obj in _G.pairs(self.mmButs) do
				if _G.IsAddOnLoaded(addon) then
					skinMMBtn("Loaded Addons btns", obj)
				end
			end
			self.mmButs = nil
		end)

		-- skin existing LibDBIcon buttons
		for name, button in _G.pairs(self.DBIcon.objects) do
			skinMMBtn("Existing LibDBIcon btns", button, name)
		end
		-- skin LibDBIcon Minimap Buttons when created
		self.DBIcon.RegisterCallback(self, "LibDBIcon_IconCreated", skinMMBtn)
	end

	if not self.isClsc then
		-- Garrison Landing Page Minimap button
		local anchor
		anchor = _G.AnchorUtil.CreateAnchor("TOPLEFT", "MinimapBackdrop", "TOPLEFT", 32, -140)
		local function skinGLPM(btn)
			if aObj.garrisonType == _G.Enum.GarrisonType.Type_9_0
			and _G.C_Covenants.GetCovenantData(_G.C_Covenants.GetActiveCovenantID())
			then
				makeBtnSquare(btn, 0.2, 0.76, 0.2, 0.76)
			elseif _G.select(4, _G.GetBuildInfo()) > 79999 then -- BfA
				makeBtnSquare(btn, 0.30, 0.70, 0.26, 0.70)
			else
				makeBtnSquare(btn, 0.25, 0.76, 0.32, 0.685)
			end
			anchor:SetPoint(btn, true)
		end
		skinGLPM(_G.GarrisonLandingPageMinimapButton)
		self:SecureHook("GarrisonLandingPageMinimapButton_UpdateIcon", function(this)
			skinGLPM(this)
		end)
		_G.GarrisonLandingPageMinimapButton.AlertBG:SetTexture(nil)
	end

	minBtn = nil

end

aObj.blizzLoDFrames[ftype].MovePad = function(self)
	if not self.prdb.MovePad or self.initialized.MovePad then return end
	self.initialized.MovePad = true

	self:SecureHookScript(_G.MovePadFrame, "OnShow", function(this)
		_G.MovePadRotateLeft.icon:SetTexture([[Interface/Glues/CharacterSelect/RestoreButton]])
		_G.MovePadRotateRight.icon:SetTexture([[Interface/Glues/CharacterSelect/RestoreButton]])
		_G.MovePadRotateRight.icon:SetTexCoord(1, 0, 0, 1) -- flip texture horizontally
		self:addSkinFrame{obj=this, ft=ftype}
		if self.modBtns then
			self:skinStdButton{obj=_G.MovePadForward}
			self:skinStdButton{obj=_G.MovePadJump}
			self:skinStdButton{obj=_G.MovePadRotateLeft}
			self:skinStdButton{obj=_G.MovePadRotateRight}
			self:skinStdButton{obj=_G.MovePadBackward}
			self:skinStdButton{obj=_G.MovePadStrafeLeft}
			self:skinStdButton{obj=_G.MovePadStrafeRight}
			-- Lock button, change texture
			_G.MovePadLock:SetBackdrop(nil)
			local tex = _G.MovePadLock:GetNormalTexture()
			tex:SetTexture([[Interface/Glues/CharacterSelect/Glues-AddOn-Icons]])
			tex:SetTexCoord(0, 0.25, 0, 1.0)
			tex:SetAlpha(1)
			tex = _G.MovePadLock:GetPushedTexture()
			tex:SetTexture([[Interface/Glues/CharacterSelect/Glues-AddOn-Icons]])
			tex:SetTexCoord(0.25, 0.5, 0, 1.0)
			tex:SetAlpha(1)
			tex = _G.MovePadLock:GetCheckedTexture()
			tex:SetTexture([[Interface/Glues/CharacterSelect/Glues-AddOn-Icons]])
			tex:SetTexCoord(0.25, 0.5, 0, 1.0)
			tex:SetAlpha(1)
			tex = nil
			self:moveObject{obj=_G.MovePadLock, x=-6, y=7} -- move it up and left
		end

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.MovePadFrame)

end

aObj.blizzFrames[ftype].MovieFrame = function(self)
	if not self.prdb.MovieFrame or self.initialized.MovieFrame then return end
	self.initialized.MovieFrame = true

	self:SecureHookScript(_G.MovieFrame, "OnShow", function(this)
		self:removeNineSlice(this.CloseDialog.Border)
		self:addSkinFrame{obj=this.CloseDialog, ft=ftype, nb=true}
		if self.modBtns then
			self:skinStdButton{obj=this.CloseDialog.ConfirmButton}
			self:skinStdButton{obj=this.CloseDialog.ResumeButton}
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].Nameplates = function(self)
	if not self.prdb.Nameplates or self.initialized.Nameplates then return end
	self.initialized.Nameplates = true

	if _G.IsAddOnLoaded("Plater") then
		self.blizzFrames[ftype].Nameplates = nil
		return
	end

	local function skinNamePlate(frame)
		if not frame then return end -- happens when called again after combat and frame doesn't exist any more
		if frame:IsForbidden() then return end
		-- handle in combat
		if frame:IsProtected()
		and _G.InCombatLockdown()
		then
		    aObj:add2Table(aObj.oocTab, {skinNamePlate, {frame}})
		    return
		end
		-- aObj:Debug("skinNamePlate: [%s, %s, %s]", frame, frame.template)
		local nP = frame.UnitFrame
		if nP then
			if not aObj.isClsc then
				aObj:skinStatusBar{obj=nP.healthBar, fi=0, bgTex=nP.healthBar.background, otherTex={nP.healthBar.myHealPrediction, nP.healthBar.otherHealPrediction}}
				aObj:skinStatusBar{obj=nP.castBar, fi=0, bgTex=nP.castBar.background}
				-- N.B. WidgetContainer objects managed in UIWidgets code
			else
				aObj:skinStatusBar{obj=nP.healthBar, fi=0, bgTex=nP.healthBar.background}
				nP.healthBar.border:DisableDrawLayer("ARTWORK")
			end
		end
		nP = nil
	end
	-- hook this to skin created Nameplates
	self:SecureHook(_G.NamePlateDriverFrame, "OnNamePlateAdded", function(this, namePlateUnitToken)
		skinNamePlate(_G.C_NamePlate.GetNamePlateForUnit(namePlateUnitToken, _G.issecure()))
	end)
	-- skin any existing NamePlates
	for _, frame in _G.pairs(_G.C_NamePlate.GetNamePlates(_G.issecure())) do
		skinNamePlate(frame)
	end

	-- Class Nameplate Frames
	-- ManaFrame
	local mF = _G.ClassNameplateManaBarFrame
	if mF then
		self:skinStatusBar{obj=mF, fi=0,  otherTex={mF.ManaCostPredictionBar, mF.FeedbackFrame.BarTexture}}
		mF = nil
	end

	if not self.isClsc then
		-- DeathKnight (nothing to skin)
		-- Mage (nothing to skin)
		-- Monk
		for i = 1, #_G.ClassNameplateBarWindwalkerMonkFrame.Chi do
			_G.ClassNameplateBarWindwalkerMonkFrame.Chi[i]:DisableDrawLayer("BACKGROUND")
		end
		self:skinStatusBar{obj=_G.ClassNameplateBrewmasterBarFrame, fi=0}
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

	-- tooltip
	_G.C_Timer.After(0.1, function()
		self:add2Table(self.ttList, _G.NamePlateTooltip)
	end)

end

aObj.blizzFrames[ftype].NavigationBar = function(self)
	if not self.prdb.NavigationBar or self.initialized.NavigationBar then return end
	self.initialized.NavigationBar = true
	-- Helper function, used by several frames

	-- hook this to handle navbar buttons
	self:SecureHook("NavBar_AddButton", function(this, _)
		for i = 1, #this.navList do
			self:skinNavBarButton(this.navList[i])
			if self.modBtnBs
			and this.navList[i].MenuArrowButton -- Home button doesn't have one
			and not this.navList[i].MenuArrowButton.sbb
			then
				self:addButtonBorder{obj=this.navList[i].MenuArrowButton, ofs=-2, x1=-1, x2=0, clr="gold", ca=0.75}
				this.navList[i].MenuArrowButton.sbb:SetAlpha(0) -- hide button border
				self:HookScript(this.navList[i].MenuArrowButton, "OnEnter", function(this)
					this.sbb:SetAlpha(1)
				end)
				self:HookScript(this.navList[i].MenuArrowButton, "OnLeave", function(this)
					this.sbb:SetAlpha(0)
				end)
			end
		end
		-- overflow Button
		this.overflowButton:GetNormalTexture():SetAlpha(0)
		this.overflowButton:GetPushedTexture():SetAlpha(0)
		this.overflowButton:GetHighlightTexture():SetAlpha(0)
		this.overflowButton:SetText("<<")
		this.overflowButton:SetNormalFontObject(self.modUIBtns.fontP) -- use module name instead of shortcut

	end)

end

aObj.blizzLoDFrames[ftype].NewPlayerExperience = function(self)
	if not self.prdb.NewPlayerExperience or self.initialized.NewPlayerExperience then return end
	self.initialized.NewPlayerExperience = true

	if hookPointerFrame then
		hookPointerFrame()
	end

	local function skinFrame(frame)
		frame:DisableDrawLayer("BORDER") -- hide NineSlice UniqueCornersLayout
		aObj:addSkinFrame{obj=frame, ft=ftype, nb=true, ofs=-30}
	end

	skinFrame(_G.NPE_TutorialMainFrame_Frame)
	skinFrame(_G.NPE_TutorialSingleKey_Frame)
	skinFrame(_G.NPE_TutorialWalk_Frame)

	skinFrame(_G.NPE_TutorialKeyboardMouseFrame_Frame)
	if self.modBtns then
		self:skinStdButton{obj=_G.KeyboardMouseConfirmButton}
	end

end

aObj.blizzLoDFrames[ftype].ObliterumUI = function(self)
	if not self.prdb.ObliterumUI or self.initialized.ObliterumUI then return end
	self.initialized.ObliterumUI = true

	self:SecureHookScript(_G.ObliterumForgeFrame, "OnShow", function(this)
		this.Background:SetTexture(nil)
		this.ItemSlot:DisableDrawLayer("ARTWORK")
		this.ItemSlot:DisableDrawLayer("OVERLAY")
		self.modUIBtns:addButtonBorder{obj=this.ItemSlot} -- use module function to force button border
		self:removeMagicBtnTex(this.ObliterateButton)
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true}
		if self.modBtns then
			self:skinStdButton{obj=this.ObliterateButton}
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzLoDFrames[ftype].OrderHallUI = function(self)
	-- RequiredDep: Blizzard_GarrisonUI, Blizzard_AdventureMap
	if not self.prdb.OrderHallUI or self.initialized.OrderHallUI then return end
	self.initialized.OrderHallUI = true

	local function skinBtns(frame)
		for btn in frame.buttonPool:EnumerateActive() do
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=btn, relTo=btn.Icon, ofs=2}
				if btn.Border:GetAtlas() == "orderhalltalents-spellborder-yellow"
				and btn.Border:IsShown()
				or btn.talent.researched then
					aObj:clrBtnBdr(btn, "yellow")
				elseif btn.Border:GetAtlas() == "orderhalltalents-spellborder-green"
				and btn.Border:IsShown()
				then
					aObj:clrBtnBdr(btn, "green")
				else
					aObj:clrBtnBdr(btn, "grey")
				end
			end
			btn.Border:SetTexture(nil)
		end
		for talentRank in frame.talentRankPool:EnumerateActive() do
			aObj:changeTandC(talentRank.Background)
		end
	end
	self:SecureHookScript(_G.OrderHallTalentFrame, "OnShow", function(this)
		for i = 1, #this.FrameTick do
			this.FrameTick[i]:SetTextColor(self.BT:GetRGB())
		end
		self:nilTexture(this.OverlayElements.CornerLogo, true)
		this.Currency.Icon:SetAlpha(1) -- show currency icon
		if self.modBtnBs then
			self:addButtonBorder{obj=this.Currency, relTo=this.Currency.Icon, clr="grey"}
		end
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true, ofs=2, x2=3}
		skinBtns(this)
		self:SecureHook(this, "RefreshAllData", function(this)
			for choiceTex in this.choiceTexturePool:EnumerateActive() do
				choiceTex:SetAlpha(0)
			end
			skinBtns(this)
		end)

		self:Unhook(this, "OnShow")
	end)

	-- CommandBar at top of screen
	self:SecureHookScript(_G.OrderHallCommandBar, "OnShow", function(this)
		this:DisableDrawLayer("BACKGROUND")
		self:addSkinFrame{obj=this, ft=ftype, nb=true, ofs=4, y2=-2} -- N.B. Icons on command bar need to be visible

		self:Unhook(this, "OnShow")

	end)
	self:checkShown(_G.OrderHallCommandBar)

end

-- table to hold PetBattle tooltips
aObj.pbtt = {}
aObj.blizzFrames[ftype].PetBattleUI = function(self)
	if not self.prdb.PetBattleUI or self.initialized.PetBattleUI then return end
	self.initialized.PetBattleUI = true

	self:SecureHookScript(_G.PetBattleFrame, "OnShow", function(this)
		-- Top Frame
		this.TopArtLeft:SetTexture(nil)
		this.TopArtRight:SetTexture(nil)
		this.TopVersus:SetTexture(nil)
		local tvw = this.TopVersus:GetWidth()
		local tvh = this.TopVersus:GetHeight()
		-- Active Allies/Enemies
		local pbf
		for _, type in _G.pairs{"Ally", "Enemy"} do
			pbf = this["Active" .. type]
			self:addButtonBorder{obj=pbf, relTo=pbf.Icon, ofs=1, reParent={pbf.LevelUnderlay, pbf.Level, pbf.SpeedUnderlay, pbf.SpeedIcon}}
			pbf.Border:SetTexture(nil)
			pbf.Border2:SetTexture(nil)
			if self.modBtnBs then
				pbf.sbb:SetBackdropBorderColor(pbf.Border:GetVertexColor())
				self:SecureHook(pbf.Border, "SetVertexColor", function(this, ...)
					this:GetParent().sbb:SetBackdropBorderColor(...)
				end)
			end
			self:changeTandC(pbf.LevelUnderlay)
			self:changeTandC(pbf.SpeedUnderlay)
			self:changeTandC(pbf.HealthBarBG, self.sbTexture)
			pbf.HealthBarBG:SetVertexColor(0.2, 0.2, 0.2, 0.8) -- black
			self:adjWidth{obj=pbf.HealthBarBG, adj=-10}
			self:adjHeight{obj=pbf.HealthBarBG, adj=-10}
			self:changeTandC(pbf.ActualHealthBar, self.sbTexture)
			pbf.ActualHealthBar:SetVertexColor(0, 1, 0) -- green
			self:moveObject{obj=pbf.ActualHealthBar, x=type == "Ally" and -5 or 5}
			pbf.HealthBarFrame:SetTexture(nil)
			-- add a background frame
			if type == "Ally" then
				this.sfl = _G.CreateFrame("Frame", nil, this)
				this.sfl:SetFrameStrata("BACKGROUND")
				self:applySkin{obj=this.sfl, bba=0, fh=tvh * 0.8}
				this.sfl:SetPoint("TOPRIGHT", this, "TOP", -(tvw + 25), 4)
				this.sfl:SetSize(this.TopArtLeft:GetWidth() * 0.59, this.TopArtLeft:GetHeight() * 0.8)
			else
				this.sfr = _G.CreateFrame("Frame", nil, this)
				this.sfr:SetFrameStrata("BACKGROUND")
				self:applySkin{obj=this.sfr, bba=0, fh=tvh * 0.8}
				this.sfr:SetPoint("TOPLEFT", this, "TOP", (tvw + 25), 4)
				this.sfr:SetSize(this.TopArtRight:GetWidth() * 0.59, this.TopArtRight:GetHeight() * 0.8)
			end
			-- Ally2/3, Enemy2/3
			for j = 2, 3 do
				self:addButtonBorder{obj=this[type .. j], relTo=this[type .. j].Icon, reParent={this[type .. j].ActualHealthBar}}
				this[type .. j].BorderAlive:SetTexture(nil)
				self:changeTandC(this[type .. j].BorderDead, [[Interface\PetBattles\DeadPetIcon]])
				if self.modBtnBs then
					this[type .. j].sbb:SetBackdropBorderColor(this[type .. j].BorderAlive:GetVertexColor())
					self:SecureHook(this[type .. j].BorderAlive, "SetVertexColor", function(this, ...)
						this:GetParent().sbb:SetBackdropBorderColor(...)
					end)
				end
				this[type .. j].healthBarWidth = 34
				this[type .. j].ActualHealthBar:SetWidth(34)
				this[type .. j].ActualHealthBar:SetTexture(self.sbTexture)
				this[type .. j].HealthDivider:SetTexture(nil)
			end
		end
		pbf= nil
		-- create a frame behind the VS text
		this.sfm = _G.CreateFrame("Frame", nil, this)
		this.sfm:SetFrameStrata("BACKGROUND")
		self:applySkin{obj=this.sfm, bba=0}
		this.sfm:SetPoint("TOPLEFT", this.sfl, "TOPRIGHT", -8, 0)
		this.sfm:SetPoint("TOPRIGHT", this.sfr, "TOPLEFT", 8, 0)
		this.sfm:SetHeight(tvh * 0.8)
		tvw, tvh = nil, nil
		-- Bottom Frame
		this.BottomFrame.RightEndCap:SetTexture(nil)
		this.BottomFrame.LeftEndCap:SetTexture(nil)
		this.BottomFrame.Background:SetTexture(nil)
		self:skinStdButton{obj=this.BottomFrame.TurnTimer.SkipButton}
		-- Pet Selection
		for i = 1, _G.NUM_BATTLE_PETS_IN_BATTLE do
			this.BottomFrame.PetSelectionFrame["Pet" .. i].Framing:SetTexture(nil)
			this.BottomFrame.PetSelectionFrame["Pet" .. i].HealthBarBG:SetTexture(self.sbTexture)
			this.BottomFrame.PetSelectionFrame["Pet" .. i].HealthBarBG:SetVertexColor(0.2, 0.2, 0.2, 0.8) -- dark grey
			this.BottomFrame.PetSelectionFrame["Pet" .. i].ActualHealthBar:SetTexture(self.sbTexture)
			this.BottomFrame.PetSelectionFrame["Pet" .. i].HealthDivider:SetTexture(nil)
		end
		self:keepRegions(this.BottomFrame.xpBar, {1, 5, 6, 13}) -- text and statusbar textures
		self:skinStatusBar{obj=this.BottomFrame.xpBar, fi=0}
		this.BottomFrame.TurnTimer.TimerBG:SetTexture(nil)
		this.BottomFrame.TurnTimer.Bar:SetTexture(self.sbTexture)
		this.BottomFrame.TurnTimer.ArtFrame:SetTexture(nil)
		this.BottomFrame.TurnTimer.ArtFrame2:SetTexture(nil)
		self:removeRegions(this.BottomFrame.FlowFrame, {1, 2, 3})
		self:getRegion(this.BottomFrame.Delimiter, 1):SetTexture(nil)
		self:removeRegions(this.BottomFrame.MicroButtonFrame, {1, 2, 3})
		self:addSkinFrame{obj=this.BottomFrame, ft=ftype, y1=10}
		if self.modBtnBs then
			-- skin forfeit button
			self:addButtonBorder{obj=this.BottomFrame.ForfeitButton, es=20, ofs=3, x1=-5, y1=5, clr="grey"}
			-- hook this for pet ability buttons
			self:SecureHook("PetBattleActionButton_UpdateState", function(this)
				if not this.sbb then
					self:addButtonBorder{obj=this, reParent={this.BetterIcon}, es=20, ofs=3, x1=-5, y1=5}
				end
				if this.sbb then
					if this.Icon
					and this.Icon:IsDesaturated()
					then
						self:clrBtnBdr(this, "disabled")
					else
						self:clrBtnBdr(this)
					end
				end
			end)
		end
		-- Tooltip frames
		if self.prdb.Tooltips.skin then
			-- hook these to stop tooltip gradient being whiteouted !!
			local function reParent(opts)
				for i = 1, #aObj.pbtt do
					aObj.pbtt[i].tfade:SetParent(opts.parent or aObj.pbtt[i])
		 			if opts.reset then
						-- reset Gradient alpha
						aObj.pbtt[i].tfade:SetGradientAlpha(aObj:getGradientInfo())
					end
				end
	 		end
			self:HookScript(this.ActiveAlly.SpeedFlash, "OnPlay", function(this)
				reParent{parent=_G.MainMenuBar}
			end, true)
			self:SecureHookScript(this.ActiveAlly.SpeedFlash, "OnFinished", function(this)
				reParent{reset=true}
			end)
			self:HookScript(this.ActiveEnemy.SpeedFlash, "OnPlay", function(this)
				reParent{parent=_G.MainMenuBar}
			end, true)
			self:SecureHookScript(this.ActiveEnemy.SpeedFlash, "OnFinished", function(this)
				reParent{reset=true}
			end)
			-- -- hook these to ensure gradient texture is reparented correctly
			-- self:SecureHookScript(this, "OnShow", function(this)
			-- 	reParent{parent=_G.MainMenuBar, reset=true}
			-- end)
			-- self:HookScript(this, "OnHide", function(this)
			-- 	reParent{}
			-- end)
			-- hook this to reparent the gradient texture if pets have equal speed
			self:SecureHook("PetBattleFrame_UpdateSpeedIndicators", function(this)
				if not this.ActiveAlly.SpeedIcon:IsShown()
				and not this.ActiveEnemy.SpeedIcon:IsShown()
				then
					reParent{reset=true}
				end
			end)
		end

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.PetBattleFrame)

	if self.prdb.Tooltips.skin then
		-- skin the tooltips
		for _, prefix in _G.pairs{"PetBattlePrimaryUnit", "PetBattlePrimaryAbility", "FloatingBattlePet", "FloatingPetBattleAbility", "BattlePet"} do
			_G[prefix .. "Tooltip"]:DisableDrawLayer("BACKGROUND")
			if _G[prefix .. "Tooltip"].Delimiter then _G[prefix .. "Tooltip"].Delimiter:SetTexture(nil) end
			if _G[prefix .. "Tooltip"].Delimiter1 then _G[prefix .. "Tooltip"].Delimiter1:SetTexture(nil) end
			if _G[prefix .. "Tooltip"].Delimiter2 then _G[prefix .. "Tooltip"].Delimiter2:SetTexture(nil) end
			self:addSkinFrame{obj=_G[prefix .. "Tooltip"], ft=ftype}
		end
		_G.PetBattlePrimaryUnitTooltip.ActualHealthBar:SetTexture(self.sbTexture)
		_G.PetBattlePrimaryUnitTooltip.XPBar:SetTexture(self.sbTexture)
		self:add2Table(self.pbtt, _G.PetBattlePrimaryUnitTooltip.sf)
		-- hook this to reset tooltip gradients
		self:SecureHookScript(_G.PetBattleFrame, "OnHide", function(this)
			for i = 1, #aObj.pbtt do
				aObj.pbtt[i].tfade:SetParent(aObj.pbtt[i])
				aObj.pbtt[i].tfade:SetGradientAlpha(aObj:getGradientInfo())
			end
		end)
	end

end

aObj.blizzLoDFrames[ftype].PlayerChoiceUI = function(self)
	if not self.prdb.PlayerChoiceUI or self.initialized.PlayerChoiceUI then return end
	self.initialized.PlayerChoiceUI = true

	local optionOffsets = {
		[0]   = {x1 = -10, y1 = 70, x2 = 10, y2 = 0}, -- defaults
		[89]  =	{y1 = 40}, -- WoD Strategic Assault Choice [Alliance]
		[144] =	{y1 = 40}, -- WoD Strategic Assault Choice [Horde]
		[240] =	{y1 = 60}, -- Legion Artifact Weapon Choice [Alliance?]
		[281] =	{y1 = 60}, -- Legion Artifact Weapon Choice [Horde]
		[342] =	{y2 = 10}, -- Warchief's Command Board [Horde]
		[505] =	{y2 = 10}, -- Hero's Call Board [Alliance]
		[667] = {y2 = 20}, -- Shadowlands Experience (Threads of Fate)
		[998] = {x1 = -35, y1 = 40, x2 = 34, y2 = -32}, -- Covenant Selection (Oribos) [Enlarged]
		[999] = {x1 = -13, y1 = 40, x2 = 13, y2 = -34}, -- Covenant Selection (Oribos) [Standard]
	}
	local defTab, ooTab, x1Ofs, y1Ofs, x2Ofs, y2Ofs = optionOffsets[0]
	local function resizeSF(frame, idx)
		-- aObj:Debug("resizeSF: [%s, %s]", frame, idx)
		ooTab = optionOffsets[idx]
		x1Ofs, y1Ofs, x2Ofs, y2Ofs = ooTab.x1 or defTab.x1, ooTab.y1 or defTab.y1, ooTab.x2 or defTab.x2, ooTab.y2 or defTab.y2
		aObj:Debug("PCUI offsets: [%s, %s, %s, %s]", x1Ofs, y1Ofs, x2Ofs, y2Ofs)
		frame.sf:ClearAllPoints()
		frame.sf:SetPoint("TOPLEFT",frame, "TOPLEFT", x1Ofs, y1Ofs)
		frame.sf:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", x2Ofs, y2Ofs)
	end
	self:SecureHookScript(_G.PlayerChoiceFrame, "OnShow", function(this)
		self:removeNineSlice(this.NineSlice)
		this.BlackBackground.BlackBackground:SetTexture(nil)
		self:nilTexture(this.BorderFrame.Header, true)
		this.Background.BackgroundTile:SetTexture(nil)
		this.Title:DisableDrawLayer("BACKGROUND")
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cbns=true, clr="sepia"})

		-- Option 1-4
			-- RewardsFrame
				-- .CurrencyRewardsPool
				-- .ReputationRewardsPool
				-- .ItemRewardsPool
			-- WidgetContainer
		local skinBtns
		if self.modBtns then
			function skinBtns(array)
				for btn in array.buttonPool:EnumerateActive() do
					-- DON'T skin magnifying glass button
					if btn:GetText() ~= "Preview Covenant" then
						aObj:skinStdButton{obj=btn}
					end
				end
			end
		end
		for _, opt in _G.pairs(this.Options) do
			self:nilTexture(opt.Header.Ribbon, true)
			self:skinObject("frame", {obj=opt, fType=ftype, fb=true, clr="grey"})
			if self.modBtns then
				skinBtns(opt.OptionButtonsContainer)
				self:SecureHook(opt.OptionButtonsContainer, "ConfigureButtons", function(this, ...)
					skinBtns(this)
				end)
				self:SecureHook(opt.OptionButtonsContainer, "DisableButtons", function(this)
					for btn in this.buttonPool:EnumerateActive() do
						if btn:GetText() ~= "Preview Covenant" then
							self:clrBtnBdr(btn)
						end
					end
				end)
			end
			-- hook these to handle size changes on mouseover (used in Oribos for covenant choice)
			self:SecureHook(opt, "OnEnterOverride", function(this)
				if this:GetOptionLayoutInfo().enlargeBackgroundOnMouseOver then
					resizeSF(opt, 998)
				end
			end)
			self:SecureHook(opt, "OnLeaveOverride", function(this)
				if this:GetOptionLayoutInfo().enlargeBackgroundOnMouseOver then
					resizeSF(opt, 999)
				end
			end)
		end

		self:SecureHook(this, "Update", function(this)
			this.sf:SetShown(not _G.IsInJailersTower())
			local pci = _G.C_PlayerChoice.GetPlayerChoiceInfo()
			aObj:Debug("PCUI - Update: [%s, %s]", this.uiTextureKit, pci.choiceID)
			for _, opt in _G.pairs(this.Options) do
				opt.Header.Text:SetTextColor(self.HT:GetRGB())
				opt.SubHeader.Text:SetTextColor(self.HT:GetRGB())
				opt.OptionText.String:SetTextColor(self.BT:GetRGB())
				opt.OptionText.HTML:SetTextColor(self.BT:GetRGB())
				if this.uiTextureKit ~= "jailerstower" then
					resizeSF(opt, this.uiTextureKit == "Oribos" and 999 or pci.choiceID)
					opt.sf:Show()
				else
					opt.sf:Hide()
				end
				if this.uiTextureKit ~= "Oribos"
				and this.uiTextureKit ~= "jailerstower"
				then
					opt.Background:SetTexture(nil)
					opt.ArtworkBorder:SetTexture(nil)
					for item in opt.RewardsFrame.Rewards.ItemRewardsPool:EnumerateActive() do
						item.Name:SetTextColor(self.BT:GetRGB())
						if self.modBtnBs then
							self:addButtonBorder{obj=item, relTo=item.Icon, reParent={item.Count}}
						end
					end
				end
			end
			pci = nil
		end)

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].PVEFrame = function(self)
	if not self.prdb.PVEFrame or self.initialized.PVEFrame then return end
	self.initialized.PVEFrame = true

	-- "LFDParentFrame", "ScenarioFinderFrame", "RaidFinderFrame", "LFGListPVEStub"
	local gbCnt = 3

	self:SecureHookScript(_G.PVEFrame, "OnShow", function(this)
		self:removeInset(this.Inset)
		self:keepFontStrings(this.shadows)
		self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, ignoreHLTex=true})
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true, y2=-5}
		-- GroupFinder Frame
		for i = 1,gbCnt do
			_G.GroupFinderFrame["groupButton" .. i].bg:SetTexture(nil)
			_G.GroupFinderFrame["groupButton" .. i].ring:SetTexture(nil)
			self:changeRecTex(_G.GroupFinderFrame["groupButton" .. i]:GetHighlightTexture())
			-- make icon square
			self:makeIconSquare(_G.GroupFinderFrame["groupButton" .. i], "icon", true)
		end
		-- hook this to change selected texture
		self:SecureHook("GroupFinderFrame_SelectGroupButton", function(index)
			for i = 1, gbCnt do
				if i == index then
					self:changeRecTex(_G.GroupFinderFrame["groupButton" .. i].bg, true)
				else
					_G.GroupFinderFrame["groupButton" .. i].bg:SetTexture(nil)
				end
			end
		end)
		if self.modBtnBs then
			-- hook this to change button border colour
			self:SecureHook("GroupFinderFrame_EvaluateButtonVisibility", function(this, _)
				for i = 1, gbCnt do
					self:clrBtnBdr(_G.GroupFinderFrame["groupButton" .. i])
				end
			end)
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].PVPHelper = function(self)

	self:SecureHookScript(_G.PVPFramePopup, "OnShow", function(this)
		self:removeNineSlice(this.Border)
		this:DisableDrawLayer("BORDER")
		_G.PVPFramePopupRing:SetTexture(nil)
 		self:addSkinFrame{obj=this, ft=ftype, nb=true}
		if self.modBtns then
			self:skinCloseButton{obj=this.minimizeButton}
			self:skinStdButton{obj=_G.PVPFramePopupAcceptButton}
			self:skinStdButton{obj=_G.PVPFramePopupDeclineButton}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.PVPRoleCheckPopup, "OnShow", function(this)
		self:removeNineSlice(this.Border)
		self:addSkinFrame{obj=this, ft=ftype}
		if self.modBtns then
			self:skinStdButton{obj=_G.PVPRoleCheckPopupAcceptButton}
			self:skinStdButton{obj=_G.PVPRoleCheckPopupDeclineButton}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.PVPReadyDialog, "OnShow", function(this)
		self:removeNineSlice(this.Border)
		self:nilTexture(this.background, true)
		self:nilTexture(this.filigree, true)
		self:nilTexture(this.bottomArt, true)
		this.instanceInfo.underline:SetTexture(nil)
		self:addSkinFrame{obj=this, ft=ftype, kfs=true}
		if self.modBtns then
			self:skinStdButton{obj=this.enterButton}
			self:skinStdButton{obj=this.leaveButton}
		end

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.PVPReadyDialog)

end

aObj.blizzFrames[ftype].PVPMatch = function(self)
	if not self.prdb.PVPMatch or self.initialized.PVPMatch then return end
	self.initialized.PVPMatch = true

	self:SecureHookScript(_G.PVPMatchScoreboard, "OnShow", function(this)

		this.Content:DisableDrawLayer("OVERLAY") -- inset textures
		-- ScrollCategories
		self:skinSlider{obj=this.ScrollFrame.ScrollBar}
		-- TabContainer
			-- TabGroup
				-- PVPScoreboardTab1/2/3

		self:addSkinFrame{obj=this, ft=ftype, kfs=true}

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.PVPMatchResults, "OnShow", function(this)

		-- overlay.decorator
		-- Score (UIWidgetContainer)
		-- content
			-- scrollCategories
		self:skinSlider{obj=this.content.scrollFrame.scrollBar}
			-- tabContainer
				-- tabGroup
					-- PVPScoreFrameTab1/2/3
				-- matchTimeContainer
			-- earningsContainer
				-- rewardsContainer
					-- items
				-- progressContainer
					-- honor
						-- button
					-- conquest
						-- button
					-- rating
						-- button
			-- earningsArt
		self:addSkinFrame{obj=this, ft=ftype, kfs=true}
		if self.modBtns then
			self:skinStdButton{obj=this.buttonContainer.leaveButton}
			self:skinStdButton{obj=this.buttonContainer.requeueButton}
		end

		self:Unhook(this, "OnShow")
	end)
	self:skinDropDown{obj=_G.PVPMatchResultsNameDropDown}

end

aObj.blizzFrames[ftype].QuestMap = function(self)
	if not self.prdb.QuestMap or self.initialized.QuestMap then return end
	self.initialized.QuestMap = true

	if _G.IsAddOnLoaded("EQL3") then
		self.blizzFrames[ftype].QuestMap = nil
		return
	end

	self:SecureHookScript(_G.QuestMapFrame, "OnShow", function(this)
		this.Background:SetAlpha(0) -- N.B. Texture changed in code
		this.VerticalSeparator:SetTexture(nil)
		self:skinDropDown{obj=_G.QuestMapQuestOptionsDropDown}
		-- QuestsFrame
		this.QuestsFrame:DisableDrawLayer("BACKGROUND")
		this.QuestsFrame.Contents.Separator:DisableDrawLayer("OVERLAY")
		this.QuestsFrame.Contents.StoryHeader:DisableDrawLayer("BACKGROUND")
		self:SecureHook("QuestLogQuests_Update", function(poiTable)
			for hdr in this.QuestsFrame.campaignHeaderFramePool:EnumerateActive() do
				hdr.Background:SetTexture(nil)
				hdr.TopFiligree:SetTexture(nil)
				hdr.HighlightTexture:SetAtlas("CampaignHeader_SelectedGlow")
				hdr.SelectedHighlight:SetTexture(nil)
				if self.modBtns then
	 				self:skinExpandButton{obj=hdr.CollapseButton, onSB=true}
				end
			end
			local tex
			local function skinEB(hdr)
				tex = hdr:GetNormalTexture() and hdr:GetNormalTexture():GetTexture()
				if tex
				and _G.tonumber(tex)
				and tex == 904010 -- Campaign_HeaderIcon_* [Atlas]
				and not hdr.sb
				then
					aObj:skinExpandButton{obj=hdr, onSB=true}
					aObj:checkTex{obj=hdr}
				end
			end
			for hdr in this.QuestsFrame.covenantCallingsHeaderFramePool:EnumerateActive() do
				self:removeRegions(hdr, {2, 3, 4})
				hdr.HighlightBackground:SetTexture([[Interface\QuestFrame\UI-QuestLogTitleHighlight]])
				if self.modBtns then
					skinEB(hdr)
				end
			end
			if self.modBtns then
				for hdr in _G.QuestScrollFrame.headerFramePool:EnumerateActive() do
					skinEB(hdr)
				end
			end
		end)
		this.QuestsFrame.DetailFrame:DisableDrawLayer("ARTWORK")
		self:skinSlider{obj=this.QuestsFrame.ScrollBar}
		self:addSkinFrame{obj=this.QuestsFrame.StoryTooltip, ft=ftype}
		-- QuestSessionManagement
		this.QuestSessionManagement.BG:SetTexture(nil)
		if self.modBtnBs then
			self:addButtonBorder{obj=this.QuestSessionManagement.ExecuteSessionCommand, ofs=1, clr="gold"}
		end
		-- Details Frame
		self:keepFontStrings(this.DetailsFrame)
		self:keepFontStrings(this.DetailsFrame.RewardsFrame)
		self:getRegion(this.DetailsFrame.RewardsFrame, 3):SetTextColor(self.HT:GetRGB())
		self:skinSlider{obj=this.DetailsFrame.ScrollFrame.ScrollBar, wdth=-4}
		this.DetailsFrame.CompleteQuestFrame:DisableDrawLayer("BACKGROUND")
		this.DetailsFrame.CompleteQuestFrame:DisableDrawLayer("ARTWORK")
		this.DetailsFrame.CompleteQuestFrame.CompleteButton:DisableDrawLayer("BORDER")
		self:adjWidth{obj=this.DetailsFrame.AbandonButton, adj=-2} -- moves buttons to the right slightly
		self:moveObject{obj=this.DetailsFrame.AbandonButton, y=2}
		self:removeRegions(this.DetailsFrame.ShareButton, {6, 7}) -- divider textures
		if self.modBtns then
			self:skinStdButton{obj=this.DetailsFrame.BackButton}
			self:skinStdButton{obj=this.DetailsFrame.CompleteQuestFrame.CompleteButton}
			self:skinStdButton{obj=this.DetailsFrame.AbandonButton}
			self:skinStdButton{obj=this.DetailsFrame.ShareButton}
			self:skinStdButton{obj=this.DetailsFrame.TrackButton}
			self:SecureHook("QuestMapFrame_UpdateQuestDetailsButtons", function()
				self:clrBtnBdr(_G.QuestMapFrame.DetailsFrame.AbandonButton)
				self:clrBtnBdr(_G.QuestMapFrame.DetailsFrame.TrackButton)
				self:clrBtnBdr(_G.QuestMapFrame.DetailsFrame.ShareButton)
				if _G.QuestLogPopupDetailFrame.AbandonButton.sb then
					self:clrBtnBdr(_G.QuestLogPopupDetailFrame.AbandonButton)
					self:clrBtnBdr(_G.QuestLogPopupDetailFrame.TrackButton)
					self:clrBtnBdr(_G.QuestLogPopupDetailFrame.ShareButton)
				end
			end)
		end
		-- CampaignOverview
		this.CampaignOverview.BG:SetTexture(nil)
		self:keepFontStrings(this.CampaignOverview.Header)
		self:skinSlider{obj=this.CampaignOverview.ScrollFrame.ScrollBar, rt={"artwork", "overlay"}}
		self:SecureHook(this.CampaignOverview, "UpdateCampaignLoreText", function(this, campaignID, textEntries)
			for tex in this.texturePool:EnumerateActive() do
				tex:SetTexture(nil)
			end
		end)

		self:Unhook(this, "OnShow")
	end)

	-- Quest Log Popup Detail Frame
	self:SecureHookScript(_G.QuestLogPopupDetailFrame, "OnShow", function(this)
		self:skinSlider{obj=this.ScrollFrame.ScrollBar, rt="artwork"}
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true, ofs=2}
		if self.modBtns then
			self:skinStdButton{obj=this.AbandonButton}
			self:skinStdButton{obj=this.TrackButton}
			self:skinStdButton{obj=this.ShareButton}
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=this.ShowMapButton, relTo=this.ShowMapButton.Texture, x1=2, y1=-1, x2=-2, y2=1}
		end

		self:Unhook(this, "OnShow")
	end)

	-- tooltip
	-- BETA: Tooltip name change
	local wct = _G.QuestMapFrame.QuestsFrame.CampaignTooltip
	wct.ItemTooltip.FollowerTooltip.PortraitFrame.PortraitRing:SetTexture(nil)
	wct.ItemTooltip.FollowerTooltip.PortraitFrame.LevelBorder:SetAlpha(0)
	_G.C_Timer.After(0.1, function()
		wct.ofs = -2
		self:add2Table(self.ttList, wct)
		wct = nil
	end)

end

aObj.blizzFrames[ftype].QuestSession = function(self)
	if not self.prdb.QuestSession or self.initialized.QuestSession then return end
	self.initialized.QuestSession = true

	for _, frame in _G.ipairs(_G.QuestSessionManager.SessionManagementDialogs) do
		self:SecureHookScript(frame, "OnShow", function(this)
			this.BG:SetTexture(nil)
			this.Border:DisableDrawLayer("BORDER")
			this.Border.Bg:SetTexture(nil)
			this.Divider:SetTexture(nil)
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true, ofs=-4}
			if self.modBtns then
				self:skinStdButton{obj=this.ButtonContainer.Confirm}
				self:skinStdButton{obj=this.ButtonContainer.Decline}
				if this.MinimizeButton then
					self:skinStdButton{obj=this.MinimizeButton}
				end
			end

			self:Unhook(this, "OnShow")
		end)
	end

end

aObj.blizzFrames[ftype].QueueStatusFrame = function(self)
	if not self.prdb.QueueStatusFrame or self.initialized.QueueStatusFrame then return end
	self.initialized.QueueStatusFrame = true

	self:SecureHookScript(_G.QueueStatusFrame, "OnShow", function(this)
		this:DisableDrawLayer("BACKGROUND")
		self:addSkinFrame{obj=this, ft=ftype, anim=_G.IsAddOnLoaded("SexyMap") and true or nil}

		-- change the colour of the Entry Separator texture
		for sEntry in this.statusEntriesPool:EnumerateActive() do
			sEntry.EntrySeparator:SetColorTexture(self.bbClr:GetRGBA())
		end

		-- handle SexyMap's use of AnimationGroups to show and hide frames
		if _G.IsAddOnLoaded("SexyMap") then
			local rtEvt
			local function checkForAnimGrp()
				if _G.QueueStatusMinimapButton.smAlphaAnim then
					rtEvt:Cancel()
					rtEvt = nil
					aObj:SecureHookScript(_G.QueueStatusMinimapButton.smAnimGroup, "OnFinished", function(this)
						_G.QueueStatusFrame.sf:Hide()
					end)
				end
			end
			rtEvt = _G.C_Timer.NewTicker(0.2, function() checkForAnimGrp() end)
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].RaidFrame = function(self)
	if not self.prdb.RaidFrame or self.initialized.RaidFrame then return end
	self.initialized.RaidFrame = true

	self:SecureHookScript(_G.RaidParentFrame, "OnShow", function(this)
		self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=true})
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true, y2=-5}

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.RaidFrame, "OnShow", function(this)
		-- RaidInfo Frame
		self:skinObject("frame", {obj=_G.RaidInfoInstanceLabel, fType=ftype, kfs=true, ofs=0})
		self:skinObject("frame", {obj=_G.RaidInfoIDLabel, fType=ftype, kfs=true, ofs=0})
		self:skinObject("slider", {obj=_G.RaidInfoScrollFrame.scrollBar, fType=ftype})
		self:removeNineSlice(_G.RaidInfoFrame.Border)
		self:moveObject{obj=_G.RaidInfoFrame.Header, y=-2}
		self:skinObject("frame", {obj=_G.RaidInfoFrame, fType=ftype, kfs=true, hdr=true, ofs=-5, y1=-6})
		if self.modBtns then
			self:skinCloseButton{obj=_G.RaidInfoCloseButton}
			self:skinStdButton{obj=_G.RaidFrameConvertToRaidButton}
			self:SecureHook("RaidFrame_Update", function()
				self:clrBtnBdr(_G.RaidFrameConvertToRaidButton)
			end)
			self:skinStdButton{obj=_G.RaidFrameRaidInfoButton}
			self:SecureHook(_G.RaidFrameRaidInfoButton, "Disable", function(this, _)
				self:clrBtnBdr(this)
			end)
			self:SecureHook(_G.RaidFrameRaidInfoButton, "Enable", function(this, _)
				self:clrBtnBdr(this)
			end)
			self:skinStdButton{obj=_G.RaidInfoExtendButton}
			self:SecureHook("RaidInfoFrame_UpdateSelectedIndex", function()
				self:clrBtnBdr(_G.RaidInfoExtendButton)
			end)
			self:skinStdButton{obj=_G.RaidInfoCancelButton}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.RaidFrameAllAssistCheckButton}
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].RaidFinder = function(self)
	if not self.prdb.PVEFrame or self.initialized.RaidFinder then return end
	self.initialized.RaidFinder = true

	self:SecureHookScript(_G.RaidFinderFrame, "OnShow", function(this)
		this:DisableDrawLayer("BACKGROUND")
		this:DisableDrawLayer("BORDER")
		self:removeInset(_G.RaidFinderFrameRoleInset)
		self:removeInset(_G.RaidFinderFrameBottomInset)
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.RaidFinderQueueFrameScrollFrameChildFrameItem1, libt=true}
			self:addButtonBorder{obj=_G.RaidFinderQueueFrameScrollFrameChildFrame.MoneyReward, libt=true}
		end
		_G.RaidFinderQueueFrameScrollFrameChildFrameItem1NameFrame:SetTexture(nil)
		if _G.RaidFinderQueueFrameScrollFrameChildFrameItem2 then
			if self.modBtnBs then
				self:addButtonBorder{obj=_G.RaidFinderQueueFrameScrollFrameChildFrameItem2, libt=true}
			end
			_G.RaidFinderQueueFrameScrollFrameChildFrameItem2NameFrame:SetTexture(nil)
		end
		if _G.RaidFinderQueueFrameScrollFrameChildFrameItem3 then
			if self.modBtnBs then
				self:addButtonBorder{obj=_G.RaidFinderQueueFrameScrollFrameChildFrameItem3, libt=true}
			end
			_G.RaidFinderQueueFrameScrollFrameChildFrameItem3NameFrame:SetTexture(nil)
		end
		_G.RaidFinderQueueFrameScrollFrameChildFrame.MoneyReward.NameFrame:SetTexture(nil)
		self:removeMagicBtnTex(_G.RaidFinderFrameFindRaidButton)
		if self.modBtns then
			self:skinStdButton{obj=_G.RaidFinderFrameFindRaidButton}
		end

		-- TODO texture is present behind frame
		-- RaidFinderQueueFrame
		self:nilTexture(_G.RaidFinderQueueFrameBackground, true)
		skinCheckBtns("RaidFinder")
		self:skinDropDown{obj=_G.RaidFinderQueueFrameSelectionDropDown}
		self:skinSlider{obj=_G.RaidFinderQueueFrameScrollFrame.ScrollBar, rt={"background", "artwork"}}

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzLoDFrames[ftype].ScrappingMachineUI = function(self)
	if not self.prdb.ScrappingMachineUI or self.initialized.ScrappingMachineUI then return end

	if not _G.ScrappingMachineFrame then
		_G.C_Timer.After(0.1, function()
			self.blizzLoDFrames[ftype].ScrappingMachineUI(self)
		end)
		return
	end

	self.initialized.ScrappingMachineUI = true

	_G.ScrappingMachineFrame.Background:SetTexture(nil)
	_G.ScrappingMachineFrame.ItemSlots:DisableDrawLayer("ARTWORK")
	for slot in _G.ScrappingMachineFrame.ItemSlots.scrapButtons:EnumerateActive() do
		self:nilTexture(slot.IconBorder, true)
		self.modUIBtns:addButtonBorder{obj=slot, relTo=slot.Icon, clr="grey"} -- use module function to force button border
		-- hook this to reset sbb colour
		self:SecureHook(slot, "ClearSlot", function(this)
			self:clrBtnBdr(this, "grey")
		end)
	end
	self:removeMagicBtnTex(_G.ScrappingMachineFrame.ScrapButton)
	self:addSkinFrame{obj=_G.ScrappingMachineFrame, ft=ftype, kfs=true, ri=true}
	if self.modBtns then
		 self:skinStdButton{obj=_G.ScrappingMachineFrame.ScrapButton}
		 self:SecureHook(_G.ScrappingMachineFrame, "UpdateScrapButtonState", function(this)
			 self:clrBtnBdr(this.ScrapButton)
		 end)
	end

end

aObj.blizzFrames[ftype].SharedBasicControls = function(self)
	if not self.prdb.SharedBasicControls or self.initialized.SharedBasicControls then return end
	self.initialized.SharedBasicControls = true

	self:SecureHookScript(_G.BasicMessageDialog, "OnShow", function(this)
		self:removeNineSlice(this.Border)
		self:addSkinFrame{obj=this, ft=ftype, kfs=true}

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.ScriptErrorsFrame, "OnShow", function(this)
		self:skinSlider{obj=this.ScrollFrame.ScrollBar}
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true, x1=1, y1=-2, x2=-1, y2=4}
		if self.modBtns then
			self:skinCloseButton{obj=_G.ScriptErrorsFrameClose}
			self:skinStdButton{obj=this.Reload}
			self:skinStdButton{obj=this.Close}
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=this.PreviousError, ofs=-3, x1=2, clr="gold"}
			self:addButtonBorder{obj=this.NextError, ofs=-3, x1=2, clr="gold"}
			self:SecureHook(this, "UpdateButtons", function(this)
				self:clrBtnBdr(this.PreviousError,"gold")
				self:clrBtnBdr(this.NextError, "gold")
			end)
		end

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.ScriptErrorsFrame)

end

aObj.blizzFrames[ftype].SplashFrame = function(self)
	if not self.prdb.SplashFrame or self.initialized.SplashFrame then return end
	self.initialized.SplashFrame = true

	self:SecureHookScript(_G.SplashFrame, "OnShow", function(this)
		this.RightFeature.StartQuestButton:DisableDrawLayer("BACKGROUND")
		if self.modBtns then
			self:skinCloseButton{obj=this.TopCloseButton, noSkin=true}
			self:skinStdButton{obj=this.BottomCloseButton}
			self:skinStdButton{obj=this.RightFeature.StartQuestButton, ofs=0, x1=40}
			self:SecureHook(this.RightFeature.StartQuestButton, "SetButtonState", function(this, _)
				self:clrBtnBdr(this)
			end)
		end

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.SplashFrame)

end

aObj.blizzFrames[ftype].StaticPopups = function(self)
	if not self.prdb.StaticPopups or self.initialized.StaticPopups then return end
	self.initialized.StaticPopups = true

	if self.modBtns then
		-- hook this to handle close button texture changes
		self:SecureHook("StaticPopup_Show", function(_)
			local nTex
			for i = 1, _G.STATICPOPUP_NUMDIALOGS do
				nTex = _G["StaticPopup" .. i .. "CloseButton"]:GetNormalTexture()
				if self:hasTextInTexture(nTex, "HideButton") then
					_G["StaticPopup" .. i .. "CloseButton"]:SetText(self.modUIBtns.minus)
				elseif self:hasTextInTexture(nTex, "MinimizeButton") then
					_G["StaticPopup" .. i .. "CloseButton"]:SetText(self.modUIBtns.mult)
				end
			end
			nTex = nil
		end)
		self:SecureHook("StaticPopup_OnUpdate", function(dialog, _)
			self:clrBtnBdr(dialog.button1 or _G[dialog:GetName() .. "Button1"])
		end)
	end

	for i = 1, _G.STATICPOPUP_NUMDIALOGS do
		self:SecureHookScript(_G["StaticPopup" .. i], "OnShow", function(this)
			self:removeNineSlice(this.Border)
			this.Separator:SetTexture(nil)
			local objName = this:GetName()
			self:skinObject("editbox", {obj=_G[objName .. "EditBox"], fType=ftype})
			self:skinMoneyFrame{obj=_G[objName .. "MoneyInputFrame"]}
			_G[objName .. "ItemFrameNameFrame"]:SetTexture(nil)
			self:skinObject("frame", {obj=this, fType=ftype, ofs=-6})
			if self.modBtns then
				self:skinStdButton{obj=this.button1}
				self:skinStdButton{obj=this.button2}
				self:skinStdButton{obj=this.button3}
				self:skinStdButton{obj=this.button4}
				self:skinStdButton{obj=this.extraButton}
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=_G[objName .. "ItemFrame"], ibt=true}
			end
			-- prevent FrameLevel from being changed (LibRock does this)
			this.sf.SetFrameLevel = _G.nop
			objName = nil

			self:Unhook(this, "OnShow")
		end)
		-- check to see if already being shown
		self:checkShown(_G["StaticPopup" .. i])
	end

	if not self.isClsc then
		self:SecureHookScript(_G.PetBattleQueueReadyFrame, "OnShow", function(this)
			self:removeNineSlice(this.Border)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true})
			if self.modBtns then
				self:skinStdButton{obj=this.AcceptButton}
				self:skinStdButton{obj=this.DeclineButton}
			end

			self:Unhook(this, "OnShow")
		end)
	end

	local function skinReportFrame(frame)
		if not aObj.isClsc then
			aObj:removeNineSlice(frame.Border)
		end
		aObj:skinObject("frame", {obj=frame.Comment, fType=ftype, kfs=true, fb=true})
		aObj:skinObject("frame", {obj=frame, fType=ftype, kfs=true})
		if aObj.modBtns then
			aObj:skinStdButton{obj=frame.ReportButton}
			aObj:skinStdButton{obj=frame.CancelButton}
		end
	end

	if not self.isClsc then
		self:SecureHook(_G.PlayerReportFrame, "ShowReportDialog", function(this, ...)
			skinReportFrame(this)

			self:Unhook(this, "ShowReportDialog")
		end)
		self:SecureHook(_G.ClubFinderReportFrame, "ShowReportDialog", function(this, ...)
			skinReportFrame(this)

			self:Unhook(this, "ShowReportDialog")
		end)
	else
		self:SecureHook(_G.PlayerReportFrame, "InitiateReport", function(this, ...)
			skinReportFrame(this)

			self:Unhook(this, "InitiateReport")
		end)
	end

end

aObj.blizzLoDFrames[ftype].Soulbinds = function(self)
	if not self.prdb.Soulbinds or self.initialized.Soulbinds then return end
	self.initialized.Soulbinds = true

	self:SecureHookScript(_G.SoulbindViewer, "OnShow", function(this)

		-- .Fx
		self:keepFontStrings(this.Border)
		-- .SelectGroup
		for btn in this.SelectGroup.pool:EnumerateActive() do
			self:removeRegions(btn.ModelScene, {1, 2, 3, 6, 7})
		end
		-- .Tree
			-- .LinkContainer
			-- .NodeContainer
		-- .ConduitList
			-- ScrollBox.ScrollTarget
				-- .Lists / .Sections
					-- CategoryButton
						-- Container
		for _, list in _G.pairs(this.ConduitList.ScrollBox.ScrollTarget.Lists) do
			self:removeRegions(list.CategoryButton.Container, {1})
			if self.modBtns then
				self:skinStdButton{obj=list.CategoryButton, clr="sepia"}
			end
		end

		self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true, ofs=-5, aso={bbclr="sepia"}}
		if self.modBtns then
			self:skinCloseButton{obj=this.CloseButton, noSkin=true}
			self:skinStdButton{obj=this.ActivateSoulbindButton}
			self:SecureHook(this, "UpdateActivateSoulbindButton", function(this)
				self:clrBtnBdr(this.ActivateSoulbindButton)
			end)
			self:skinStdButton{obj=this.CommitConduitsButton}
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzLoDFrames[ftype].SubscriptionInterstitialUI = function(self)
	if not self.prdb.SubscriptionInterstitialUI or self.initialized.SubscriptionInterstitialUI then return end
	self.initialized.SubscriptionInterstitialUI = true

	self:SecureHookScript(_G.SubscriptionInterstitialFrame, "OnShow", function(this)

		this:DisableDrawLayer("BACKGROUND")
		self:removeNineSlice(this.NineSlice)
		this.ShadowOverlay:DisableDrawLayer("OVERLAY")
		-- .SubscribeButton
		-- .UpgradeButton
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true, ofs=1, x2=2}
		if self.modBtns then
			self:skinStdButton{obj=this.ClosePanelButton}
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].SystemOptions = function(self)
	if not self.prdb.SystemOptions or self.initialized.SystemOptions then return end
	self.initialized.SystemOptions = true

	-- Graphics
	self:SecureHookScript(_G.VideoOptionsFrame, "OnShow", function(this)
		self:removeNineSlice(this.Border)
		-- Main panel
		self:skinObject("frame", {obj=_G.VideoOptionsFrameCategoryFrame, fType=ftype, fb=true})
		self:skinObject("slider", {obj=_G.VideoOptionsFrameCategoryFrameListScrollBar, fType=ftype, x1=4, x2=-5})
		self:skinObject("frame", {obj=_G.VideoOptionsFramePanelContainer, fType=ftype, fb=true})
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, hdr=true})
		if self.modBtns then
			self:skinStdButton{obj=_G.VideoOptionsFrameApply}
			self:skinStdButton{obj=_G.VideoOptionsFrameCancel}
			self:skinStdButton{obj=_G.VideoOptionsFrameOkay}
			self:skinStdButton{obj=_G.VideoOptionsFrameDefaults}
			if self.isClsc then
				self:skinStdButton{obj=_G.VideoOptionsFrameClassic}
			end
			self:SecureHook(_G.VideoOptionsFrameApply, "Disable", function(this)
				self:clrBtnBdr(this)
			end)
			self:SecureHook(_G.VideoOptionsFrameApply, "Enable", function(this)
				self:clrBtnBdr(this)
			end)
		end
		-- Graphics
		skinKids(_G.Display_)
		self:skinObject("frame", {obj=_G.Display_, fType=ftype, fb=true})
		self:skinObject("tabs", {obj=_G.Display_, tabs={_G.GraphicsButton, _G.RaidButton}, fType=ftype, ignoreSize=true, upwards=true, offsets={x1=4, y1=0, x2=0, y2=-4}, track=false})
		if self.isTT then
			self:SecureHook("GraphicsOptions_SelectBase", function()
				self:setActiveTab(_G.GraphicsButton.sf)
				self:setInactiveTab(_G.RaidButton.sf)
			end)
			self:SecureHook("GraphicsOptions_SelectRaid", function()
				if _G.Display_RaidSettingsEnabledCheckBox:GetChecked() then
					self:setActiveTab(_G.RaidButton.sf)
					self:setInactiveTab(_G.GraphicsButton.sf)
				end
			end)
		end
		skinKids(_G.Graphics_)
		self:skinObject("frame", {obj=_G.Graphics_, fType=ftype, fb=true})
		skinKids(_G.RaidGraphics_)
		self:skinObject("frame", {obj=_G.RaidGraphics_, fType=ftype, fb=true})

		self:Unhook(this, "OnShow")
	end)
	if self.isClsc then
		self:SecureHook("VideoOptionsDropDownMenu_DisableDropDown", function(dropDown)
			self:checkDisabledDD(dropDown)
		end)
		self:SecureHook("VideoOptionsDropDownMenu_EnableDropDown", function(dropDown)
			self:checkDisabledDD(dropDown)
		end)
	end

	-- Advanced
	self:SecureHookScript(_G.Advanced_, "OnShow", function(this)
		skinKids(this)

		self:Unhook(this, "OnShow")
	end)
	-- Network
	self:SecureHookScript(_G.NetworkOptionsPanel, "OnShow", function(this)
		skinKids(_G.NetworkOptionsPanel)

		self:Unhook(this, "OnShow")
	end)
	-- Languages
	self:SecureHookScript(_G.InterfaceOptionsLanguagesPanel, "OnShow", function(this)
		skinKids(this)

		self:Unhook(this, "OnShow")
	end)
	-- Keyboard
	self:SecureHookScript(_G.MacKeyboardOptionsPanel, "OnShow", function(this)
		-- Languages
		skinKids(this)

		self:Unhook(this, "OnShow")
	end)
	-- Sound
	self:SecureHookScript(_G.AudioOptionsSoundPanel, "OnShow", function(this)
		skinKids(this)
		self:skinObject("frame", {obj=_G.AudioOptionsSoundPanelPlayback, fType=ftype, fb=true, ofs=0})
		self:skinObject("frame", {obj=_G.AudioOptionsSoundPanelHardware, fType=ftype, fb=true, ofs=0})
		self:skinObject("frame", {obj=_G.AudioOptionsSoundPanelVolume, fType=ftype, fb=true, ofs=0})

		self:Unhook(this, "OnShow")
	end)
	-- Voice
	self:SecureHookScript(_G.AudioOptionsVoicePanel, "OnShow", function(this)
		self.iofBtn[this.PushToTalkKeybindButton] = true
		skinKids(this)
		this.TestInputDevice.ToggleTest:DisableDrawLayer("BACKGROUND")
		self:skinObject("frame", {obj=this.TestInputDevice.VUMeter, fType=ftype, fb=true})
		if self.modBtnBs then
			self:addButtonBorder{obj=this.TestInputDevice.ToggleTest, ofs=0, y2=-2}
			self:skinStdButton{obj=this.PushToTalkKeybindButton, ofs=0}
			self:skinStdButton{obj=this.MacMicrophoneAccessWarning.OpenAccessButton}
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzLoDFrames[ftype].TalkingHeadUI = function(self)
	if not self.prdb.TalkingHeadUI or self.initialized.TalkingHeadUI then return end
	self.initialized.TalkingHeadUI = true

	-- remove CloseButton animation
	_G.TalkingHeadFrame.MainFrame.TalkingHeadsInAnim.CloseButton = nil
	_G.TalkingHeadFrame.MainFrame.Close.CloseButton = nil

	self:nilTexture(_G.TalkingHeadFrame.BackgroundFrame.TextBackground, true)
	self:nilTexture(_G.TalkingHeadFrame.PortraitFrame.Portrait, true)
	self:nilTexture(_G.TalkingHeadFrame.MainFrame.Model.PortraitBg, true)
	self:addSkinFrame{obj=_G.TalkingHeadFrame, ft=ftype, kfs=true, nb=true, aso={bd=11, ng=true}, ofs=-15, y2=14}
	_G.TalkingHeadFrame.sf:SetBackdropColor(.1, .1, .1, .75) -- use dark background
	if self.modBtns then
		self:skinCloseButton{obj=_G.TalkingHeadFrame.MainFrame.CloseButton, noSkin=true}
	end

	-- hook this to manage skin frame background when text colour changes
	self:SecureHook(_G.TalkingHeadFrame.TextFrame.Text, "SetTextColor", function(this, r, _)
		if r == 0 then -- use light background (Island Expeditions, Voldun Quest, Dark Iron intro)
			_G.TalkingHeadFrame.sf:SetBackdropColor(.75, .75, .75, .75)
			_G.TalkingHeadFrame.MainFrame.CloseButton:SetNormalFontObject(self.modUIBtns.fontBX)
		else
			_G.TalkingHeadFrame.sf:SetBackdropColor(.1, .1, .1, .75) -- use dark background
			_G.TalkingHeadFrame.MainFrame.CloseButton:SetNormalFontObject(self.modUIBtns.fontX)
		end
	end)

end

aObj.blizzFrames[ftype].TimeManager = function(self)
	if not self.prdb.TimeManager or self.initialized.TimeManager then return end
	self.initialized.TimeManager = true

	-- Time Manager Frame
	self:SecureHookScript(_G.TimeManagerFrame, "OnShow", function(this)
		_G.TimeManagerFrameTicker:Hide()
		self:keepFontStrings(_G.TimeManagerStopwatchFrame)
		self:skinDropDown{obj=_G.TimeManagerAlarmHourDropDown, x2=-6}
		self:skinDropDown{obj=_G.TimeManagerAlarmMinuteDropDown, x2=-6}
		self:skinDropDown{obj=_G.TimeManagerAlarmAMPMDropDown, x2=-6}
		self:skinEditBox{obj=_G.TimeManagerAlarmMessageEditBox, regs={6}}
		self:removeRegions(_G.TimeManagerAlarmEnabledButton, {6, 7})
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true, x2=self.isClsc and 1 or 3}
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.TimeManagerStopwatchCheck, y1=2, y2=-4}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.TimeManagerAlarmEnabledButton}
			self:skinCheckButton{obj=_G.TimeManagerMilitaryTimeCheck}
			self:skinCheckButton{obj=_G.TimeManagerLocalTimeCheck}
		end
		-- Stopwatch Frame
		self:keepFontStrings(_G.StopwatchTabFrame)
		self:addSkinFrame{obj=_G.StopwatchFrame, ft=ftype, kfs=true, y1=-16, x2=-1, y2=2}
		if self.modBtns then
			self:skinCloseButton{obj=_G.StopwatchCloseButton, sap=true}
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.StopwatchPlayPauseButton, ofs=-1, x1=0, clr="gold"}
			self:addButtonBorder{obj=_G.StopwatchResetButton, ofs=-1, x1=0, clr="gold"}
		end

		self:Unhook(this, "OnShow")
	end)

	-- TimeManagerClockButton on the Minimap
	if not _G.IsAddOnLoaded("SexyMap") then
		if not self.prdb.Minimap.style then
			self:addSkinFrame{obj=_G.TimeManagerClockButton, ft=ftype, kfs=true, nb=true, x1=14, y1=-3, x2=-8, y2=5}
		end
	end

end

aObj.blizzFrames[ftype].Tooltips = function(self)
	if not self.prdb.Tooltips.skin or self.initialized.Tooltips then return end
	self.initialized.Tooltips = true

	if _G.IsAddOnLoaded("TipTac") then
		self.blizzFrames[ftype].Tooltips = nil
		return
	end

	if _G.IsAddOnLoaded("TinyTooltip") then
		local LibEvent = _G.LibStub:GetLibrary("LibEvent.7000")
		_G.setmetatable(self.ttList, {__newindex = function(tab, _, tTip)
			tTip = _G.type(tTip) == "string" and _G[tTip] or tTip
			LibEvent:trigger("tooltip.style.init", tTip)
			self.callbacks:Fire("Tooltip_Setup", tTip)
		end})
		return
	end

	-- using a metatable to manage tooltips when they are added in different functions
	_G.setmetatable(self.ttList, {__newindex = function(tab, _, tTip)
		-- get object reference for tooltip, handle either strings or objects being passed
		tTip = _G.type(tTip) == "string" and _G[tTip] or tTip
		-- store using tooltip object as the key
		_G.rawset(tab, tTip, true)

		-- glaze the Status bar(s) if required
		if self.prdb.Tooltips.glazesb then
			if tTip.GetName -- named tooltips only
			and tTip:GetName()
			and _G[tTip:GetName() .. "StatusBar"]
			and not _G[tTip:GetName() .. "StatusBar"].Bar -- ignore ReputationParagonTooltip
			then
				self:skinStatusBar{obj=_G[tTip:GetName() .. "StatusBar"], fi=0}
			end
			if tTip.statusBar2 then
				self:skinStatusBar{obj=_G[tTip:GetName() .. "StatusBar2"], fi=0}
			end
		end

		-- skin here so tooltip initially skinned
		self:skinTooltip(tTip)

		-- stop backdrop being changed
		self:removeBackdrop(tTip, true)

		-- hook this to prevent Gradient overlay when tooltip reshown
		self:HookScript(tTip, "OnUpdate", function(this)
			-- aObj:Debug("tTip OnUpdate: [%s, %s]", this, this.ItemTooltip)
			self:skinTooltip(this)
		end)

		-- hook Show function for tooltips which don't get Updated
		if self.ttHook[tTip] then
			self:SecureHookScript(tTip, "OnShow", function(this)
				self:skinTooltip(this)
			end)
		end

		if self.modBtnBs then
			-- if it has an ItemTooltip then add a button border
			if tTip.ItemTooltip	then
				self:addButtonBorder{obj=tTip.ItemTooltip, relTo=tTip.ItemTooltip.Icon, reParent={tTip.ItemTooltip.Count}}
			end
		end

	end})

	-- add tooltips to table
	local function addTooltip(tTip)
		tTip:DisableDrawLayer("OVERLAY")
		tTip.ftype = ftype
		aObj:add2Table(aObj.ttList, tTip)
	end
	for _, tTip in _G.pairs{_G.GameTooltip, _G.SmallTextTooltip, _G.EmbeddedItemTooltip, _G.ItemRefTooltip} do
		addTooltip(tTip)
		if tTip.shoppingTooltips then
			for _, tip in _G.pairs(tTip.shoppingTooltips) do
				if not _G.rawget(self.ttList, tip) then
					addTooltip(tip)
				end
			end
		end
	end

	self:SecureHookScript(_G.ItemRefTooltip, "OnShow", function(this)
		if self.modBtns then
			self:skinCloseButton{obj=this.CloseButton, noSkin=true}
		end
		-- ensure it gets updated
		self.ttHook[_G.ItemRefTooltip] = true

		self:Unhook(this, "OnShow")
	end)

	self:SecureHook("GameTooltip_AddProgressBar", function(this, _)
		for progressBar in this.progressBarPool:EnumerateActive() do
			self:removeRegions(progressBar.Bar, {1, 2, 3, 4, 5}) -- 6 is text
		    self:skinStatusBar{obj=progressBar.Bar, fi=0, bgTex=self:getRegion(progressBar.Bar, 7)}
		end
	end)

	-- Hook these to handle AddOns that use GameTooltip Backdrop functions (e.g. SavedInstances)
	self:RawHook(_G.GameTooltip, "GetBackdrop", function(this)
		return aObj.Backdrop[1]
	end, true)
	self:RawHook(_G.GameTooltip, "GetBackdropColor", function(this)
		return aObj.bClr:GetRGBA()
	end, true)
	self:RawHook(_G.GameTooltip, "GetBackdropBorderColor", function(this)
		return aObj.bbClr:GetRGBA()
	end, true)

	-- AceConfigDialog tooltip
	addTooltip(self.ACD.tooltip)

end

aObj.blizzLoDFrames[ftype].TorghastLevelPicker = function(self)
	if not self.prdb.TorghastLevelPicker or self.initialized.TorghastLevelPicker then return end
	self.initialized.TorghastLevelPicker = true

	self:SecureHookScript(_G.TorghastLevelPickerFrame, "OnShow", function(this)
		if self.modBtnBs then
			self:addButtonBorder{obj=this.Pager.PreviousPage, clr="gold", ofs=-2, y1=-3, x2=-3}
			self:addButtonBorder{obj=this.Pager.NextPage, clr="gold", ofs=-2, y1=-3, x2=-3}
			self:SecureHook(this.Pager, "SetupPagingButtonStates", function(this)
				self:clrBtnBdr(this.PreviousPage, "gold")
				self:clrBtnBdr(this.NextPage, "gold")
			end)
		end
		-- .ModelScene
		this.CloseButton.CloseButtonBorder:SetTexture(nil)
		if self.modBtns then
			self:skinCloseButton{obj=this.CloseButton , noSkin=true}
			self:skinStdButton{obj=this.OpenPortalButton}
			self:SecureHook(this, "UpdatePortalButtonState", function(this, _)
				self:clrBtnBdr(this.OpenPortalButton)
			end)
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].Tutorial = function(self)
	if not self.prdb.Tutorial or self.initialized.Tutorial then return end
	self.initialized.Tutorial = true

	self:SecureHookScript(_G.TutorialFrame, "OnShow", function(this)
		local function resetSF()

			-- use the same frame level & strata as TutorialFrame so it appears above other frames
			_G.TutorialFrame.sf:SetFrameLevel(_G.TutorialFrame:GetFrameLevel())
			_G.TutorialFrame.sf:SetFrameStrata(_G.TutorialFrame:GetFrameStrata())

		end
		this:DisableDrawLayer("BACKGROUND")
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
		self:addSkinFrame{obj=this, ft=ftype, anim=true, y1=-11, x2=1}
		resetSF()
		-- hook this as the TutorialFrame frame level keeps changing
		self:SecureHookScript(this.sf, "OnShow", function(this)
			resetSF()
		end)
		-- hook this to hide the skin frame if required (e.g. arrow keys tutorial)
		self:SecureHook("TutorialFrame_Update", function(_)
			resetSF()
			_G.TutorialFrame.sf:SetShown(_G.TutorialFrameTop:IsShown())
		end)

		if self.modBtns then
			self:skinStdButton{obj=_G.TutorialFrameOkayButton}
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.TutorialFramePrevButton, ofs=-2}
			self:addButtonBorder{obj=_G.TutorialFrameNextButton, ofs=-2}
			self:SecureHook("TutorialFrame_CheckNextPrevButtons", function()
				self:clrBtnBdr(_G.TutorialFramePrevButton, "gold")
				self:clrBtnBdr(_G.TutorialFrameNextButton, "gold")
			end)
		end

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.TutorialFrame)

	-- Alert button
	self:SecureHookScript(_G.TutorialFrameAlertButton, "OnShow", function(this)
		self:skinOtherButton{obj=this, ft=ftype, font="ZoneTextFont", text="?", x1=30, y1=-1, x2=-25, y2=10}

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.HelpPlateTooltip, "OnShow", function(this)
		this:DisableDrawLayer("BORDER") -- hide Arrow glow textures
		self:skinGlowBox(this, ftype)
		-- move Arrow textures to align with frame border
		self:moveObject{obj=this.ArrowUP, y=-2}
		self:moveObject{obj=this.ArrowDOWN, y=2}
		self:moveObject{obj=this.ArrowRIGHT, x=-2}
		self:moveObject{obj=this.ArrowLEFT, x=2}

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.HelpPlateTooltip)

end

aObj.blizzLoDFrames[ftype].TutorialTemplates = function(self)
	if not self.prdb.Tutorial or self.initialized.TutorialTemplates then return end
	self.initialized.TutorialTemplates = true

	if hookPointerFrame then
		hookPointerFrame()
	end

end

aObj.blizzFrames[ftype].UIDropDownMenu = function(self)
	if not self.prdb.UIDropDownMenu or self.initialized.UIDropDownMenu then return end
	self.initialized.UIDropDownMenu = true

	local function skinDDMenu(frame)
		if not aObj.isClsc then
			aObj:removeNineSlice(frame.Border)
		else
			aObj:removeBackdrop(_G[frame:GetName() .. "Backdrop"])
		end
		aObj:removeBackdrop(_G[frame:GetName() .. "MenuBackdrop"])
		aObj:addSkinFrame{obj=frame, ft=ftype, kfs=true, nb=true, ofs=-2}
	end

	for i = 1, _G.UIDROPDOWNMENU_MAXLEVELS do
		self:SecureHookScript(_G["DropDownList" .. i], "OnShow", function(this)
			skinDDMenu(this)

			self:Unhook(this, "OnShow")
		end)
	end

	self:SecureHook("UIDropDownMenu_CreateFrames", function(_)
		if not _G["DropDownList" .. _G.UIDROPDOWNMENU_MAXLEVELS].sf then
			skinDDMenu(_G["DropDownList" .. _G.UIDROPDOWNMENU_MAXLEVELS])
		end
	end)

end

aObj.blizzFrames[ftype].UIWidgets = function(self)
	if not self.prdb.UIWidgets or self.initialized.UIWidgets then return end
	self.initialized.UIWidgets = true

	-- N.B. In Shadowlands, get Clamping Errors when in certain areas and displaying StatusBar/SpellDisplay widgets
	local disableTypeBySZ = {
		[2] = {
			["Bleak Redoubt"] = true,
			["House of Plagues"] = true,
			["The Desiccation"] = true,
		},
		[13] = {
			["House of Plagues"] = true,
		},
	}

	local function setTextColor(textObject)
		self:rawHook(textObject, "SetTextColor", function(this, r, g, b, a)
			-- aObj:Debug("textObject SetTextColor: [%s, %s, %s, %s, %s]", this, r, g, b, a)
			local tcr, tcg, tcb = aObj:round2(r, 2), aObj:round2(g, 2), aObj:round2(b, 2)
			-- aObj:Debug("SetTextColor: [%s, %s, %s, %s, %s]", this:GetText(), tcr, tcg, tcb)
			if (tcr == 0.41 or tcr == 0.28 and tcg == 0.02 and tcb == 0.02) -- Red
			or (tcr == 0.08 and tcg == 0.17 or tcg == 0.16 and tcb == 0.37) -- Blue
			-- or (tcr == 0.19 and tcg == 0.05 and tcb == 0.01) -- WarboardUI
			then
				self.hooks[this].SetTextColor(this, aObj.BT:GetRGBA())
			else
				self.hooks[this].SetTextColor(this, r, g, b, a)
			end
			tcg, tcb = nil, nil
			return tcr
		end, true)
		return textObject:SetTextColor(textObject:GetTextColor())
	end

	-- Documentation in UIWidgetManagerSharedDocumentation.lua (UIWidgetVisualizationType)
	local function skinWidget(wFrame, wInfo)
		-- handle in combat
		if wFrame:IsProtected()
		and _G.InCombatLockdown()
		then
		    aObj:add2Table(aObj.oocTab, {skinWidget, {wFrame, wInfo}})
		    return
		end
		-- Get SubZone
		local SZ = _G.GetSubZoneText()

		aObj:Debug("skinWidget#0: [%s, %s, %s]", _G.C_Map.GetBestMapForUnit("player"), _G.GetRealZoneText(), SZ)
		aObj:Debug("skinWidget: [%s, %s, %s, %s, %s, %s]", wFrame, wFrame.widgetType, wFrame.widgetTag, wFrame.widgetSetID, wFrame.widgetID, wInfo)

		if wFrame.widgetType == 0 then -- IconAndText (World State: ICONS at TOP)
			-- N.B. DON'T add buttonborder to Icon(s)
		elseif wFrame.widgetType == 1 then -- CaptureBar (World State: Capture bar on RHS)
			-- DON'T change textures
		elseif wFrame.widgetType == 2 then -- StatusBar
			if not disableTypeBySZ[wFrame.widgetType][SZ] then
				aObj:skinStatusBar{obj=wFrame.Bar, fi=0, nilFuncs=true}
				aObj:removeRegions(wFrame.Bar, {1, 2, 3, 5, 6, 7}) -- background & border textures
			else
				aObj:removeRegions(wFrame.Bar, {5, 6, 7}) -- border textures
			end
		elseif wFrame.widgetType == 3 then -- DoubleStatusBar (Island Expeditions)
			aObj:skinStatusBar{obj=wFrame.LeftBar, fi=0, bgTex=wFrame.LeftBar.BG, nilFuncs=true}
			aObj:removeRegions(wFrame.LeftBar, {2, 3, 4}) -- border textures
			aObj:skinStatusBar{obj=wFrame.RightBar, fi=0, bgTex=wFrame.RightBar.BG, nilFuncs=true}
			aObj:removeRegions(wFrame.RightBar, {2, 3, 4}) -- border textures
		elseif wFrame.widgetType == 4 then -- IconTextAndBackground (Island Expedition Totals)
		elseif wFrame.widgetType == 5 then -- DoubleIconAndText
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=wFrame.Left, relTo=wFrame.Left.Icon}
				aObj:addButtonBorder{obj=wFrame.Right, relTo=wFrame.Right.Icon}
			end
		elseif wFrame.widgetType == 6 then -- StackedResourceTracker
			for resourceFrame in wFrame.resourcePool:EnumerateActive() do
				resourceFrame:SetFontColor(self.BT)
			end
		elseif wFrame.widgetType == 7 then -- IconTextAndCurrencies
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=wFrame, relTo=wFrame.Icon}
				if wInfo.visInfoDataFunction(wFrame.widgetID) then
					self:clrBtnBdr(wFrame, "grey")
				else
					self:clrBtnBdr(wFrame)
				end
			end
		elseif wFrame.widgetType == 8 then -- TextWithState
			setTextColor(wFrame.Text)
		elseif wFrame.widgetType == 9 then -- HorizontalCurrencies
			for currencyFrame in wFrame.currencyPool:EnumerateActive() do
				setTextColor(currencyFrame.Text)
				setTextColor(currencyFrame.LeadingText)
			end
		elseif wFrame.widgetType == 10 then -- BulletTextList
			for lineFrame in wFrame.linePool:EnumerateActive() do
				setTextColor(lineFrame.Text)
			end
		elseif wFrame.widgetType == 11 then -- ScenarioHeaderCurrenciesAndBackground
			aObj:nilTexture(wFrame.Frame, true)
		elseif wFrame.widgetType == 12 then -- TextureWithState (PTR - TextureAndText)
			-- .Background
			-- .Foreground
			setTextColor(wFrame.Text)
		elseif wFrame.widgetType == 13 then -- SpellDisplay
			if not disableTypeBySZ[wFrame.widgetType][SZ] then
				wFrame.Spell.Border:SetTexture(nil)
				local tcr = setTextColor(wFrame.Spell.Text)
				if aObj.modBtnBs then
					aObj:addButtonBorder{obj=wFrame.Spell, relTo=wFrame.Spell.Icon, reParent={wFrame.Spell.StackCount}}
					if tcr == 0.5 then
						aObj:clrBtnBdr(wFrame.Spell, "grey")
					end
				end
				tcr = nil
			end
		elseif wFrame.widgetType == 14 then -- DoubleStateIconRow
			-- TODO: add button borders if required
		elseif wFrame.widgetType == 15 then -- TextureAndTextRow
			for entryFrame in wFrame.entryPool:EnumerateActive() do
				-- .Background
				-- .Foreground
				setTextColor(entryFrame.Text)
			end
		elseif wFrame.widgetType == 16 then -- ZoneControl
		elseif wFrame.widgetType == 17 then -- CaptureZone
		elseif wFrame.widgetType == 18 then -- TextureWithAnimation
		elseif wFrame.widgetType == 19 then -- DiscreteProgressSteps
		elseif wFrame.widgetType == 20 then -- ScenarioHeaderTimer
			aObj:skinStatusBar{obj=wFrame.TimerBar, fi=0, bgTex=wFrame.TimerBar.BG, nilFuncs=true}
		end
	end

	if not self.isClsc then
		local function getWidgets(widgetContainer)
			local count = 0
			for widget in widgetContainer.widgetPools:EnumerateActive() do
				count = count + 1
				skinWidget(widget, _G.UIWidgetManager:GetWidgetTypeInfo(widget.widgetType))
			end
			return count
		end
		-- hook this to skin new widgets
		self:SecureHook(_G.UIWidgetManager, "OnWidgetContainerRegistered", function(this, widgetContainer)
			-- aObj:Debug("UIWM OnWidgetContainerRegistered: [%s, %s]", this, widgetContainer)
			getWidgets(widgetContainer)
		end)
		-- handle existing WidgetContainers
		for widgetContainer, _ in _G.pairs(_G.UIWidgetManager.registeredWidgetContainers) do
			getWidgets(widgetContainer)
		end
		--handle widgets in Instances/Scenarios
		self.RegisterCallback("UIWidgetsUI", "Player_Entering_World", function(this)
			-- name, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceMapID, instanceGroupSize[, lfgDungeonsID] = GetInstanceInfo
			-- aObj:Debug("PEW - InstanceInfo: [%s, %s, %s, %s, %s, %s, %s, %s, %s, %s]", _G.GetInstanceInfo())

			-- handle the DoubleStatusBar widget on Island Expeditions
			local ieCnt = getWidgets(_G.UIWidgetTopCenterContainerFrame)
			-- handle ScenarioHeaderCurrenciesAndBackground
			local shCnt = getWidgets(_G.ScenarioStageBlock.WidgetContainer)
			if ieCnt > 0
			and shCnt > 0 then
				self.UnregisterCallback("UIWidgetsUI", "Player_Entering_World")
			end
			ieCnt, shCnt = nil, nil
		end)
		if _G.UIWidgetPowerBarContainerFrame:IsShown() then
			getWidgets(_G.UIWidgetPowerBarContainerFrame)
		else
			self:SecureHookScript(_G.UIWidgetPowerBarContainerFrame, "OnShow", function(this)
				getWidgets(this)

				self:Unhook(this, "OnShow")
			end)
		end
	else
		self:SecureHook(_G.UIWidgetManager, "CreateWidget", function(this, widgetID, _, widgetType)
			skinWidget(this.widgetIdToFrame[widgetID], this.widgetVisTypeInfo[widgetType].visInfoDataFunction(widgetID))
		end)
	end

end

aObj.blizzFrames[ftype].UnitPopup = function(self)
	if not self.prdb.UnitPopup or self.initialized.UnitPopup then return end
	self.initialized.UnitPopup = true

	self:skinSlider{obj=_G.UnitPopupVoiceSpeakerVolume.Slider}
	self:skinSlider{obj=_G.UnitPopupVoiceMicrophoneVolume.Slider}
	self:skinSlider{obj=_G.UnitPopupVoiceUserVolume.Slider}

end

aObj.blizzLoDFrames[ftype].WarfrontsPartyPoseUI = function(self)
	if not self.prdb.WarfrontsPartyPoseUI or self.initialized.WarfrontsPartyPoseUI then return end

	if not _G.WarfrontsPartyPoseFrame then
		_G.C_Timer.After(0.1, function()
			self.blizzLoDFrames[ftype].WarfrontsPartyPoseUI(self)
		end)
		return
	end

	self.initialized.WarfrontsPartyPoseUI = true

	skinPartyPoseFrame(_G.WarfrontsPartyPoseFrame)

end

aObj.blizzLoDFrames[ftype].WeeklyRewards = function(self)
	if not self.prdb.WeeklyRewards or self.initialized.WeeklyRewards then return end
	self.initialized.WeeklyRewards = true

	self:SecureHookScript(_G.WeeklyRewardsFrame, "OnShow", function(this)

		self:removeNineSlice(this.NineSlice)
		this.HeaderFrame:DisableDrawLayer("BACKGROUND")
		this.HeaderFrame:DisableDrawLayer("BORDER")
		for _, frame in _G.pairs{"RaidFrame", "MythicFrame", "PVPFrame"} do
			self:addFrameBorder{obj=this[frame], ft=ftype, ofs=3, aso={bbclr="sepia"}}
			this[frame].Background:SetAlpha(1)
		end
		for i, frame in _G.ipairs(this.Activities) do
			-- _G.Spew("", frame)
			self:addFrameBorder{obj=frame, ft=ftype, ofs=3, x1=3, y1=-3, aso={bbclr="grey"}}
			-- show required textures
			if frame.Background then
				frame.Background:SetAlpha(1)
				frame.Orb:SetAlpha(1)
				frame.LockIcon:SetAlpha(1)
			end
			-- .ItemFrame
			-- .UnselectedFrame
			self:SecureHook(frame, "Refresh", function(this)
				if this.unlocked or this.hasRewards then
				end
			end)
		end
		-- .ConcessionFrame
			-- .RewardsFrame
			-- .UnselectedFrame

		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ofs=-5}
		if self.modBtns then
			self:skinStdButton{obj=this.SelectRewardButton}
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].WorldMap = function(self)
	if not self.prdb.WorldMap.skin or self.initialized.WorldMap then return end
	self.initialized.WorldMap = true

	self:SecureHookScript(_G.WorldMapFrame, "OnShow", function(this)

		if not _G.IsAddOnLoaded("Mapster")
		and not _G.IsAddOnLoaded("AlleyMap")
		then
			self:keepFontStrings(_G.WorldMapFrame)
			self:addSkinFrame{obj=_G.WorldMapFrame.BorderFrame, ft=ftype, kfs=true, nb=true}
			self:removeNineSlice(_G.WorldMapFrame.BorderFrame.NineSlice)
			-- make sure map textures are displayed
			_G.WorldMapFrame.BorderFrame.sf:SetFrameStrata("LOW")
		end

		this.BorderFrame.Tutorial.Ring:SetTexture(nil)
		local oFrame
		for i = 1, #this.overlayFrames do
			oFrame = this.overlayFrames[i]
			-- Tracking Options Button
			if oFrame.IconOverlay then
				if self.modBtns then
					self:skinStdButton{obj=oFrame, y2=3, clr="gold"}
				end
				oFrame:DisableDrawLayer("BACKGROUND")
				oFrame.Border:SetTexture(nil)
			-- Floor Navigation Dropdown
			elseif oFrame.Button then
				self:skinDropDown{obj=oFrame}
			-- BountyBoard overlay
			elseif oFrame.bountyObjectivePool then
				oFrame:DisableDrawLayer("BACKGROUND")
				self:SecureHook(oFrame, "RefreshBountyTabs", function(this)
					for tab in this.bountyTabPool:EnumerateActive() do
						if tab.objectiveCompletedBackground then
							tab.objectiveCompletedBackground:SetTexture(nil)
						end
					end
				end)
			-- ActionButton overlay
			elseif oFrame.ActionFrameTexture then
				oFrame.ActionFrameTexture:SetTexture(nil)
				if self.modBtnBs then
					self:addButtonBorder{obj=oFrame.SpellButton}
				end
			end
		end
		oFrame = nil
		-- Nav Bar
		self:skinNavBarButton(this.NavBar.home)
		this.NavBar:DisableDrawLayer("BACKGROUND")
		this.NavBar:DisableDrawLayer("BORDER")
		this.NavBar.overlay:DisableDrawLayer("OVERLAY")

		if self.modBtns then
			self:skinOtherButton{obj=this.BorderFrame.MaxMinButtonFrame.MaximizeButton, font=self.fontS, text=self.updown}
			self:skinOtherButton{obj=this.BorderFrame.MaxMinButtonFrame.MinimizeButton, font=self.fontS, text=self.updown}
			self:skinCloseButton{obj=this.BorderFrame.CloseButton} -- child of MaxMinButtonFrame
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=this.SidePanelToggle.CloseButton, clr="gold"}
			self:addButtonBorder{obj=this.SidePanelToggle.OpenButton, clr="gold"}
		end

		self:Unhook(this, "OnShow")
	end)

end

-- PTR Feedback Tool
if _G.PTR_IssueReporter then
	aObj.blizzFrames[ftype].PTRFeedback = function(self)
		if not self.prdb.PTRFeedback or self.initialized.PTRFeedback then return end
		self.initialized.PTRFeedback = true

		local function skinFrame(frame, ofs, border)
			if border then
				aObj:skinObject("frame", {obj=frame, fType=ftype, ofs=ofs or 4, clr="blue"})
			else
				aObj:skinObject("frame", {obj=frame, fType=ftype, kfs=true, ofs=ofs or 4, clr="blue"})
			end
			if frame.Border then
				aObj:removeBackdrop(frame.Border)
			end
		end

		skinFrame(_G.PTR_IssueReporter)
		for _, name in _G.pairs{"Confused", "ReportBug"} do
			self:addSkinButton{obj=_G.PTR_IssueReporter[name], aso={bbclr="blue"}}
			_G.PTR_IssueReporter[name]:SetPushedTexture(nil)
			self:removeBackdrop(_G.PTR_IssueReporter[name].Border)
		end

		self:SecureHook(_G.PTR_IssueReporter, "GetStandaloneSurveyFrame", function(this)
			skinFrame(_G.PTR_IssueReporter.StandaloneSurvey, 3) -- header frame
			skinFrame(_G.PTR_IssueReporter.StandaloneSurvey.SurveyFrame)
			if self.modBtns then
				self:skinCloseButton{obj=self:getChild(_G.PTR_IssueReporter.StandaloneSurvey.SurveyFrame, 2), noSkin=true}
				self:skinStdButton{obj=self:getChild(_G.PTR_IssueReporter.StandaloneSurvey.SurveyFrame, 3), ofs=0, clr="blue"}
			end

			self:Unhook(this, "GetStandaloneSurveyFrame")
		end)

		self:SecureHook(_G.PTR_IssueReporter, "BuildSurveyFrameFromSurveyData", function(surveyFrame, _)
			skinFrame(surveyFrame)
			for _, frame in _G.pairs(surveyFrame.FrameComponents) do
				skinFrame(frame, 2, true)
				if frame.FrameType == "MultipleChoice"
				and self.modChkBtns then
					for _, checkBox in _G.pairs(frame.Checkboxes) do
						self:skinCheckButton{obj=checkBox}
					end
				-- elseif frame.FrameType == "StandaloneQuestion" then
				-- elseif frame.FrameType == "ModelViewer" then
				-- elseif frame.FrameType == "IconViewer" then
				end
			end
		end)

	end
end
