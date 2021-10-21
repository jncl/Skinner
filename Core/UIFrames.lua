local _, aObj = ...

local _G = _G

local ftype = "u"

-- The following functions are used by the GarrisonUI & OrderHallUI
local skinPortrait, skinFollower, skinFollowerListButtons, skinEquipment, skinFollowerAbilitiesAndCounters, skinFollowerList, skinFollowerPage, skinFollowerTraitsAndEquipment, skinMissionFrame, skinCompleteDialog, skinMissionPage, skinMissionComplete, skinMissionList

-- [WoD] LE_FOLLOWER_TYPE_GARRISON_6_0
-- [WoD] LE_FOLLOWER_TYPE_GARRISON_6_2 (Shipyards)
-- [Legion] LE_FOLLOWER_TYPE_GARRISON_7_0
-- [BfA] LE_FOLLOWER_TYPE_GARRISON_8_0
-- [Shadowlands] Enum.GarrisonType.Type_9_0
if _G.IsAddOnLoadOnDemand("Blizzard_GarrisonUI") then
	function skinPortrait(frame)
		if frame.PuckBorder then
			frame.TroopStackBorder1:SetTexture(nil)
			frame.TroopStackBorder2:SetTexture(nil)
			aObj:nilTexture(frame.PuckBorder, true)
			frame.PortraitRingQuality:SetTexture(nil)
			frame.PortraitRingCover:SetTexture(nil)
			aObj:changeTandC(frame.LevelCircle)
			aObj:changeTex2SB(frame.HealthBar.Health)
			frame.HealthBar.Border:SetTexture(nil)
		else
			frame.PortraitRing:SetTexture(nil)
			frame.LevelBorder:SetAlpha(0) -- texture changed
			if frame.PortraitRingCover then
				frame.PortraitRingCover:SetTexture(nil)
			end
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
		for _, btn in _G.pairs(frame.listScroll.buttons) do
			if frame ~= _G.GarrisonShipyardFrameFollowers
			and frame ~= _G.GarrisonLandingPageShipFollowerList
			then
				skinFollower(btn.Follower)
			else
				skinFollower(btn)
			end
		end
	end
	function skinEquipment(frame)
		for equipment in frame.equipmentPool:EnumerateActive() do
			equipment.BG:SetTexture(nil)
			equipment.Border:SetTexture(nil)
			aObj.modUIBtns:addButtonBorder{obj=equipment, ofs=1, relTo=equipment.Icon} -- use module function
		end
	end
	function skinFollowerAbilitiesAndCounters(frame)
		if aObj.modBtnBs then
			if frame.AbilitiesFrame.CombatAllySpell then
				for _, btn in _G.pairs(frame.AbilitiesFrame.CombatAllySpell) do
					aObj:addButtonBorder{obj=btn, relTo=btn.iconTexture}
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
			aObj:SecureHook(frame, "ShowAbilities", function(_, _)
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
	function skinFollowerList(frame, colour)
		local gOfs, y1Ofs, y2Ofs
		if frame.ElevatedFrame then
			frame.ElevatedFrame:DisableDrawLayer("OVERLAY")
			aObj:removeRegions(frame, {1})
			aObj:removeRegions(frame.listScroll, {1})
			aObj:skinObject("slider", {obj=frame.listScroll.scrollBar, fType=ftype, y1=5, y2=-10})
			gOfs, y1Ofs, y2Ofs = 2, 5, -4
		else
			frame:DisableDrawLayer("BORDER")
			aObj:removeRegions(frame, {1, 2, not frame.isLandingPage and 3})
			-- aObj:removeRegions(frame, {1, 2, frame:GetParent() ~= _G.GarrisonLandingPage and 3 or nil})
			aObj:skinObject("slider", {obj=frame.listScroll.scrollBar, fType=ftype, y1=-2, y2=2})
			gOfs, y1Ofs, y2Ofs = 4, 8, -8
		end
		if frame.isLandingPage then
			gOfs, y1Ofs, y2Ofs = 6, 5, -8
		end
		aObj:skinObject("frame", {obj=frame.listScroll, fType=ftype, fb=true, ofs=gOfs, y1=y1Ofs, y2=y2Ofs, clr=colour})
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
			if frame.isLandingPage then
				aObj:moveObject{obj=frame.SearchBox, x=-10}
			end
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
		and not aObj:hasTextInName(frame, "Ship") -- Shipyard & ShipFollowers
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
		end
		if frame.CovenantFollowerPortraitFrame then
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
		for _, btn in _G.pairs(frame.Traits) do
			btn.Border:SetTexture(nil)
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=btn, relTo=btn.Portrait, ofs=1}
			end
		end
		for _, btn in _G.pairs(frame.EquipmentFrame.Equipment) do
			btn.BG:SetTexture(nil)
			btn.Border:SetTexture(nil)
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=btn, relTo=btn.Icon, ofs=1}
			end
		end
	end
	local mfTabSkin = aObj.skinTPLs.new("tabs", {fType=ftype, ignoreHLTex=false, regions={7, 8, 9, 10}})
	function skinMissionFrame(frame)
		local x1Ofs, y1Ofs, x2Ofs, y2Ofs = 2, 2, 1, -4
		if frame == _G.CovenantMissionFrame then
			x1Ofs = -2
			y1Ofs = 2
			y2Ofs = -6
		elseif frame == _G.BFAMissionFrame then
			y1Ofs = 1
			y2Ofs = -5
		elseif frame == _G.OrderHallMissionFrame then
			y2Ofs = -3
		end
		frame.GarrCorners:DisableDrawLayer("BACKGROUND")
		aObj:skinObject("frame", {obj=frame, fType=ftype, kfs=true, cbns=true, x1=x1Ofs, y1=y1Ofs, x2=x2Ofs, y2=y2Ofs})
		-- tabs
		mfTabSkin.obj = frame
		mfTabSkin.prefix =  frame:GetName()
		mfTabSkin.selectedTab = frame.selectedTab
		mfTabSkin.lod = aObj.isTT and true
		if frame == _G.GarrisonMissionFrame then
			x1Ofs, y1Ofs, x2Ofs, y2Ofs = 10, -2, -11, 2
		else
			x1Ofs, y1Ofs, x2Ofs, y2Ofs = 10, -2, -10, 7
		end
		mfTabSkin.offsets = {x1=x1Ofs, y1=aObj.isTT and 2 or y1Ofs, x2=x2Ofs, y2=aObj.isTT and 4 or y2Ofs}
		aObj:skinObject(mfTabSkin)
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
		aObj:removeRegions(frame.BorderFrame.Stage, {1, 2, 3, 4, 5, 6})
		aObj:skinObject("frame", {obj=frame.BorderFrame, fType=ftype, kfs=true, y2=-2})
		if aObj.modBtns then
			aObj:skinStdButton{obj=frame.BorderFrame.ViewButton}
		end
	end
	local stageRegs = {1, 2, 3, 4, 5}
	function skinMissionPage(frame, colour)
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
			y1Ofs, x2Ofs, y2Ofs = 2, 1, 0
		end
		aObj:skinObject("frame", {obj=frame, fType=ftype, kfs=true, rns=true, cbns=true, fb=true, clr=colour, x1=0, y1=y1Ofs, x2=x2Ofs, y2=y2Ofs})
		if aObj.modBtns then
			aObj:skinStdButton{obj=frame.StartMissionButton}
			aObj:moveObject{obj=frame.StartMissionButton.Flash, x=-0.5, y=1.5}
			aObj:SecureHook(frame:GetParent():GetParent(), "UpdateStartButton", function(_, missionPage)
				aObj:clrBtnBdr(missionPage.StartMissionButton)
			end)
		end
	end
	function skinMissionComplete(frame, naval)
		local mcb = frame:GetParent().MissionCompleteBackground
		mcb:SetSize(naval and 953 or 949 , naval and 661 or 638)
		aObj:moveObject{obj=mcb, x=4, y=naval and 20 or -1}
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
		aObj:nilTexture(frame.Stage.MissionInfo.IconBG, true)
	end
	local mlTabSkin = aObj.skinTPLs.new("tabs", {fType=ftype, numTabs=2, ignoreHLTex=false, upwards=true, regions={7, 8, 9}, track=false})
	function skinMissionList(ml, tabOfs)
		ml.MaterialFrame:DisableDrawLayer("BACKGROUND")
		aObj:skinObject("frame", {obj=ml, fType=ftype, kfs=true, fb=true, ofs=1})
		if ml.RaisedFrameEdges then
			ml.RaisedFrameEdges:DisableDrawLayer("BORDER")
			ml.MaterialFrame.LeftFiligree:SetTexture(nil)
			ml.MaterialFrame.RightFiligree:SetTexture(nil)
			aObj:skinObject("slider", {obj=ml.listScroll.scrollBar, fType=ftype, y1=5, y2=-10})
		else
			aObj:skinObject("slider", {obj=ml.listScroll.scrollBar, fType=ftype, y1=-2, y2=2})
			-- tabs
			mlTabSkin.obj = ml
			mlTabSkin.prefix = ml:GetName()
			mlTabSkin.lod = aObj.isTT and true
			mlTabSkin.offsets =  {x1=tabOfs and tabOfs * -1 or 6, y1=tabOfs or -6, x2=tabOfs or -6, y2=aObj.isTT and 3 or 8}
			aObj:skinObject(mlTabSkin)
			if aObj.isTT then
				aObj:secureHook("GarrisonMissonListTab_SetSelected", function(tab, isSelected)
					if isSelected then
						aObj:setActiveTab(tab.sf)
					else
						aObj:setInactiveTab(tab.sf)
					end
				end)
			else
				if ml.UpdateMissions then
					if not ml.Tab2:IsEnabled() then
						aObj:clrBBC(ml.Tab2.sf, "disabled")
					end
					aObj:SecureHook(ml, "UpdateMissions", function(this)
						if not this.Tab2:IsEnabled() then
							aObj:clrBBC(this.Tab2.sf, "disabled")
						else
							aObj:clrBBC(this.Tab2.sf)
						end
					end)
				end
			end
		end
		for _, btn in _G.pairs(ml.listScroll.buttons) do
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
		-- CompleteDialog
		skinCompleteDialog(ml.CompleteDialog)
	end
end

-- The following functions are used by several Chat* functions
if aObj.isClscBC then
	aObj.cebRgns = {1, 2, 6, 7} -- 1, 6 & 7 are font strings, 2 is cursor texture
else
	aObj.cebRgns = {1, 2, 9, 10, 11, 12} -- 1, 9, 10, 11 & 12 are font strings, 2 is cursor texture
end
local function skinChatEB(obj)
	if aObj.prdb.ChatEditBox.style == 1 then -- Frame
		aObj:keepRegions(obj, aObj.cebRgns)
		aObj:skinObject("frame", {obj=obj, fType=ftype, ofs=-2})
		obj.sf:SetAlpha(obj:GetAlpha())
	elseif aObj.prdb.ChatEditBox.style == 2 then -- Editbox
		aObj:skinObject("editbox", {obj=obj, fType=ftype, regions={3, 4, 5, 6, 7, 8}, ofs=-4})
	else -- Borderless
		aObj:keepRegions(obj, aObj.cebRgns)
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
		self:skinObject("slider", {obj=_G.AddonListScrollFrame.ScrollBar, fType=ftype, rpTex="background"})
		self:skinObject("dropdown", {obj=_G.AddonCharacterDropDown, fType=ftype, x2=109})
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true, x2=self.isClscBC and 1})
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
		-- aObj:Debug("skinACAlertFrames: [%s, %s, %s]", frame, _G.Round(frame:GetWidth()), _G.Round(frame:GetHeight())
		aObj:nilTexture(frame.Background, true)
		frame.Unlocked:SetTextColor(aObj.BT:GetRGB())
		if frame.OldAchievement then
			frame.OldAchievement:SetTexture(nil)
		end
		frame.Icon:DisableDrawLayer("BORDER")
		frame.Icon:DisableDrawLayer("OVERLAY")
		aObj:skinObject("frame", {obj=frame, fType=ftype, ofs=0, y1=frame.Shield and -15 or -8, y2=frame.Shield and 10 or 8}) -- adjust if Achievement Alert
		if aObj.modBtnBs then
			aObj:addButtonBorder{obj=frame.Icon, relTo=frame.Icon.Texture}
		end
	end
	-- called params: frame, achievementID, alreadyEarned (10585, true)
	self:SecureHook(_G.AchievementAlertSystem, "setUpFunction", function(frame, _)
		skinACAlertFrames(frame)
	end)
	for frame in _G.AchievementAlertSystem.alertFramePool:EnumerateActive() do
		skinACAlertFrames(frame)
	end
	--called params: frame, achievementID, criteriaString (10607, "Test")
	self:SecureHook(_G.CriteriaAlertSystem, "setUpFunction", function(frame, _)
		skinACAlertFrames(frame)
	end)
	for frame in _G.CriteriaAlertSystem.alertFramePool:EnumerateActive() do
		skinACAlertFrames(frame)
	end
	local function skinLootAlert(frame, ...)
		frame:DisableDrawLayer("BACKGROUND")
		frame.lootItem.SpecRing:SetTexture(nil)
		aObj:skinObject("frame", {obj=frame, fType=ftype, ofs=-10, y2=8})
		-- colour the Icon buttons' border
		if aObj.modBtnBs then
			local itemRarity
			local itemLink = ...
			if frame.isCurrency then
				itemRarity = _G.C_CurrencyInfo.GetCurrencyInfoFromLink(itemLink).quality
			else
				itemRarity = _G.select(3, _G.GetItemInfo(itemLink))
			end
			frame.lootItem.IconBorder:SetTexture(nil)
			aObj:addButtonBorder{obj=frame.lootItem, relTo=frame.lootItem.Icon}
			frame.lootItem.sbb:SetBackdropBorderColor(_G.ITEM_QUALITY_COLORS[itemRarity].r, _G.ITEM_QUALITY_COLORS[itemRarity].g, _G.ITEM_QUALITY_COLORS[itemRarity].b)
		end
	end
	-- called params: self, itemLink, originalQuantity, rollType, roll, specID, isCurrency, showFactionBG, lootSource, lessAwesome, isUpgraded, wonRoll, showRatedBG, isSecondaryResult
	self:SecureHook(_G.LootAlertSystem, "setUpFunction", function(frame, ...)
		skinLootAlert(frame, ...)
	end)
	for frame in _G.LootAlertSystem.alertFramePool:EnumerateActive() do
		skinLootAlert(frame)
	end
	local function skinLootUpgrade(frame)
		frame:DisableDrawLayer("BACKGROUND")
		aObj:addSkinFrame{obj=frame, ft=ftype, ofs=-10, y2=8}
	end
	-- called parms: self, itemLink, quantity, specID, baseQuality (147239, 1, 1234, 5)
	self:SecureHook(_G.LootUpgradeAlertSystem, "setUpFunction", function(frame, _)
		skinLootUpgrade(frame)
	end)
	for frame in _G.LootUpgradeAlertSystem.alertFramePool:EnumerateActive() do
		skinLootUpgrade(frame)
	end
	local function skinMoneyorHonor(frame)
		frame:DisableDrawLayer("BACKGROUND")
		frame.IconBorder:SetTexture(nil)
		aObj:addSkinFrame{obj=frame, ft=ftype, ofs=-8, y2=8}
		if aObj.modBtnBs then
			aObj:addButtonBorder{obj=frame, relTo=frame.Icon}
		end
	end
	-- called params: self, amount (12345)
	self:SecureHook(_G.MoneyWonAlertSystem, "setUpFunction", function(frame, _)
		skinMoneyorHonor(frame)
	end)
	for frame in _G.MoneyWonAlertSystem.alertFramePool:EnumerateActive() do
		skinMoneyorHonor(frame)
	end
	-- called params: self, amount (350)
	self:SecureHook(_G.HonorAwardedAlertSystem, "setUpFunction", function(frame, _)
		skinMoneyorHonor(frame)
	end)
	for frame in _G.HonorAwardedAlertSystem.alertFramePool:EnumerateActive() do
		skinMoneyorHonor(frame)
	end
	local function skinNewRecipe(frame)
		frame:DisableDrawLayer("BACKGROUND")
		frame.Icon:SetDrawLayer("BORDER")
		aObj:addSkinFrame{obj=frame, ft=ftype, ofs=-8}
	end
	-- called params: self, recipeID (209645)
	self:SecureHook(_G.NewRecipeLearnedAlertSystem, "setUpFunction", function(frame, _)
		skinNewRecipe(frame)
	end)
	for frame in _G.NewRecipeLearnedAlertSystem.alertFramePool:EnumerateActive() do
		skinNewRecipe(frame)
	end
	local function skinDCSAlertFrames(opts)
		opts.obj:DisableDrawLayer("BORDER")
		opts.obj:DisableDrawLayer("OVERLAY")
		opts.obj.dungeonTexture:SetDrawLayer("ARTWORK") -- move Dungeon texture above skinFrame
		aObj:addSkinFrame{obj=opts.obj, ft=ftype, ofs=opts.ofs or -8, y1=opts.y1 or nil}
		if aObj.modBtnBs then
			-- wait for animation to finish
			_G.C_Timer.After(0.2, function()
				aObj:addButtonBorder{obj=opts.obj, relTo=opts.obj.dungeonTexture}
			end)
		end
	end
	-- called params: frame, challengeType, count, max ("Raid", 2, 5)
	self:SecureHook(_G.GuildChallengeAlertSystem, "setUpFunction", function(frame, _)
		frame:DisableDrawLayer("BACKGROUND")
		frame:DisableDrawLayer("BORDER")
		frame:DisableDrawLayer("OVERLAY")
		aObj:addSkinFrame{obj=frame, ft=ftype, ofs=-10}
	end)
	-- called params: frame, rewardData={name="Deceiver's Fall", iconTextureFile=1616157, subtypeID=3, moneyAmount=1940000, moneyBase=1940000, monetVar=0, experienceBase=0, experienceGained=0, experienceVar=0, numRewards=1, numStrangers=0, rewards={} }
	self:SecureHook(_G.DungeonCompletionAlertSystem, "setUpFunction", function(frame, _)
		skinDCSAlertFrames{obj=frame}
	end)
	-- called params: frame, rewardData={}
	self:SecureHook(_G.ScenarioAlertSystem, "setUpFunction", function(frame, _)
		self:getRegion(frame, 1):SetTexture(nil) -- Toast-IconBG
		skinDCSAlertFrames{obj=frame, ofs=-12}
	end)
	-- called params: frame, rewardQuestID, name, showBonusCompletion, xp, money (123456, "Test", true, 2500, 1234)
	self:SecureHook(_G.InvasionAlertSystem, "setUpFunction", function(frame, _)
		self:getRegion(frame, 1):SetTexture(nil) -- Background toast texture
		self:getRegion(frame, 2):SetDrawLayer("ARTWORK") -- move icon to ARTWORK layer so it is displayed
		aObj:addSkinFrame{obj=frame, ft=ftype, ofs=-8}
		if self.modBtnBs then
			self:addButtonBorder{obj=frame, relTo=self:getRegion(frame, 2)}
		end
	end)
	-- called params: frame, raceName, raceTexture ("Demonic", "")
	self:SecureHook(_G.DigsiteCompleteAlertSystem, "setUpFunction", function(frame, _)
		frame:DisableDrawLayer("BACKGROUND")
		self:addSkinFrame{obj=frame, ft=ftype, ofs=-10}
	end)
	-- called params: frame, type, icon, name, payloadID, showFancyToast
	self:SecureHook(_G.EntitlementDeliveredAlertSystem, "setUpFunction", function(frame, _)
		frame:DisableDrawLayer("BACKGROUND")
		self:addSkinFrame{obj=frame, ft=ftype, ofs=-10}
		if self.modBtnBs then
			self:addButtonBorder{obj=frame, relTo=frame.Icon}
		end
	end)
	-- called params: frame, type, icon, name, payloadID, showFancyToast
	self:SecureHook(_G.RafRewardDeliveredAlertSystem, "setUpFunction", function(frame, _)
		frame:DisableDrawLayer("BACKGROUND")
		self:addSkinFrame{obj=frame, ft=ftype, ofs=-10}
		if self.modBtnBs then
			self:addButtonBorder{obj=frame, relTo=frame.Icon}
		end
	end)
	-- called params: frame, name, garrisonType ("Menagerie", "")
	self:SecureHook(_G.GarrisonBuildingAlertSystem, "setUpFunction", function(frame, _)
		frame:DisableDrawLayer("BACKGROUND")
		frame.Icon:SetDrawLayer("BORDER")
		self:addSkinFrame{obj=frame, ft=ftype, ofs=-10}
		if self.modBtnBs then
			self:addButtonBorder{obj=frame, relTo=frame.Icon}
		end
	end)
	-- called params: frame, missionInfo=({name="Test", typeAtlas="", followerTypeID=LE_FOLLOWER_TYPE_GARRISON_7_0})
	self:SecureHook(_G.GarrisonMissionAlertSystem, "setUpFunction", function(frame, _)
		frame:DisableDrawLayer("BACKGROUND")
		frame:DisableDrawLayer("BORDER")
		self:addSkinFrame{obj=frame, ft=ftype, ofs=-10, y1=-8}
	end)
	-- called params: frame, missionInfo=({name="Test", typeAtlas="", followerTypeID=LE_FOLLOWER_TYPE_GARRISON_7_0})
	self:SecureHook(_G.GarrisonShipMissionAlertSystem, "setUpFunction", function(frame, _)
		frame:DisableDrawLayer("BACKGROUND")
		self:addSkinFrame{obj=frame, ft=ftype, ofs=-10}
	end)
	-- called params: frame, missionInfo=({level=105, iLevel=875, isRare=true, followerTypeID=LE_FOLLOWER_TYPE_GARRISON_6_0})
	self:SecureHook(_G.GarrisonRandomMissionAlertSystem, "setUpFunction", function(frame, _)
		frame:DisableDrawLayer("BACKGROUND")
		frame.MissionType:SetDrawLayer("BORDER")
		self:addSkinFrame{obj=frame, ft=ftype, ofs=-10}
	end)
	-- called params: frame, followerID, name, level, quality, isUpgraded, followerInfo={isTroop=, followerTypeID=, portraitIconID=, quality=, level=, iLevel=}
	self:SecureHook(_G.GarrisonFollowerAlertSystem, "setUpFunction", function(frame, _)
		frame:DisableDrawLayer("BACKGROUND")
		frame.PortraitFrame.PortraitRing:SetTexture(nil)
		self:nilTexture(frame.PortraitFrame.LevelBorder, true)
		self:nilTexture(frame.FollowerBG, true)
		self:addSkinFrame{obj=frame, ft=ftype, ofs=-8}
	end)
	-- called params: frame, followerID, name, class, texPrefix, level, quality, isUpgraded, followerInfo={}
	self:SecureHook(_G.GarrisonShipFollowerAlertSystem, "setUpFunction", function(frame, _)
		frame:DisableDrawLayer("BACKGROUND")
		self:nilTexture(frame.FollowerBG, true)
		self:addSkinFrame{obj=frame, ft=ftype, ofs=-8}
	end)
	-- called params: frame, garrisonType, talent={icon=""}
	self:SecureHook(_G.GarrisonTalentAlertSystem, "setUpFunction", function(frame, _)
		frame:DisableDrawLayer("BACKGROUND")
		frame.Icon:SetDrawLayer("BORDER")
		self:addSkinFrame{obj=frame, ft=ftype, ofs=-10}
		if self.modBtnBs then
			self:addButtonBorder{obj=frame, relTo=frame.Icon}
		end
	end)
	-- called params: frame, questData (1234)
	self:SecureHook(_G.WorldQuestCompleteAlertSystem, "setUpFunction", function(frame, _)
		frame.QuestTexture:SetDrawLayer("ARTWORK")
		frame:DisableDrawLayer("BORDER") -- toast texture
		self:skinObject("frame", {obj=frame, ofs=-6})
		if self.modBtnBs then
			self:addButtonBorder{obj=frame, relTo=frame.QuestTexture}
		end
	end)
	-- called params: frame, itemLink (137080)
	self:SecureHook(_G.LegendaryItemAlertSystem, "setUpFunction", function(frame, _)
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
	local function skinQueuedAlert(frame)
		frame:DisableDrawLayer("BACKGROUND")
		aObj:addSkinFrame{obj=frame, ft=ftype, ofs=-8}
	end
	-- called params: frame, petID
	self:SecureHook(_G.NewPetAlertSystem, "setUpFunction", function(frame, _)
		skinQueuedAlert(frame)
	end)
	for frame in _G.NewPetAlertSystem.alertFramePool:EnumerateActive() do
		skinQueuedAlert(frame)
	end
	-- called params: frame, mountID
	self:SecureHook(_G.NewMountAlertSystem, "setUpFunction", function(frame, _)
		skinQueuedAlert(frame)
	end)
	for frame in _G.NewMountAlertSystem.alertFramePool:EnumerateActive() do
		skinQueuedAlert(frame)
	end
	-- called params: frame, toyID
	self:SecureHook(_G.NewToyAlertSystem, "setUpFunction", function(frame, _)
		skinQueuedAlert(frame)
	end)
	for frame in _G.NewToyAlertSystem.alertFramePool:EnumerateActive() do
		skinQueuedAlert(frame)
	end
	-- called params: frame, powerID
	self:SecureHook(_G.NewRuneforgePowerAlertSystem, "setUpFunction", function(frame, _)
		skinQueuedAlert(frame)
	end)
	for frame in _G.NewRuneforgePowerAlertSystem.alertFramePool:EnumerateActive() do
		skinQueuedAlert(frame)
	end
	if aObj.isRtlPTR then
		-- called params: frame, itemModifiedAppearanceID
		self:SecureHook(_G.NewCosmeticAlertFrameSystem, "setUpFunction", function(frame, _)
			skinQueuedAlert(frame)
		end)
		for frame in _G.NewCosmeticAlertFrameSystem.alertFramePool:EnumerateActive() do
			skinQueuedAlert(frame)
		end
	end

	-- hook this to stop gradient texture whiteout
	self:RawHook(_G.AlertFrame, "AddAlertFrame", function(this, frame)
		if _G.IsAddOnLoaded("Overachiever") then
			local ocScript = frame:GetScript("OnClick")
			if ocScript
			and ocScript == _G.OverachieverAlertFrame_OnClick
			then
				-- stretch icon texture
				frame.Icon.Texture:SetTexCoord(-0.04, 0.75, 0.0, 0.555)
				skinACAlertFrames(frame)
			end
		end
		-- run the hooked function
		self.hooks[this].AddAlertFrame(this, frame)
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
		if frame.sf
		and frame.sf.tfade
		then
			frame.sf.tfade:SetGradientAlpha(self:getGradientInfo())
		end
	end)
	self:SecureHook("AlertFrame_ResumeOutAnimation", function(frame)
		if frame.sf
		and frame.sf.tfade
		then
			frame.sf.tfade:SetAlpha(0)
		end
	end)

end

aObj.blizzLoDFrames[ftype].AnimaDiversionUI = function(self)
	if not self.prdb.AnimaDiversionUI or self.initialized.AnimaDiversionUI then return end
	self.initialized.AnimaDiversionUI = true

	-- FIXME: ScrollContainer moves to the right when Anima flowing
	self:SecureHookScript(_G.AnimaDiversionFrame, "OnShow", function(this)
		self:keepFontStrings(this.BorderFrame)
		this.CloseButton.Border:SetTexture(nil)
		this.AnimaDiversionCurrencyFrame:DisableDrawLayer("BACKGROUND")
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, rns=true, cbns=true, clr="sepia", x1=-4, y1=3, x2=2, y2=-5})
		if self.modBtns then
			self:skinStdButton{obj=this.ReinforceInfoFrame.AnimaNodeReinforceButton}
			self:SecureHook(this.ReinforceInfoFrame.AnimaNodeReinforceButton, "Disable", function(bObj, _)
				self:clrBtnBdr(bObj)
			end)
			self:SecureHook(this.ReinforceInfoFrame.AnimaNodeReinforceButton, "Enable", function(bObj, _)
				self:clrBtnBdr(bObj)
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

aObj.blizzFrames[ftype].AzeriteItemToasts = function(self)
	if not self.prdb.AzeriteItemToasts or self.initialized.AzeriteItemToasts then return end
	self.initialized.AzeriteItemToasts = true

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
		self:RawHook(this.ShowAnim, "Play", function(_)
		end, true)

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzLoDFrames[ftype].BattlefieldMap = function(self)
	if not self.prdb.BattlefieldMap or self.initialized.BattlefieldMap then return end
	self.initialized.BattlefieldMap = true

	self:SecureHookScript(_G.BattlefieldMapFrame, "OnShow", function(this)
		self:skinObject("frame", {obj=_G.BattlefieldMapTab, fType=ftype, kfs=true, noBdr=self.isTT, y1=-7, y2=-7})
		self:skinObject("frame", {obj=this.BorderFrame, fType=ftype, kfs=true, cb=true, fb=true, ofs=4, y1=6, x2=2, y2=2})

		-- change the skinFrame's opacity as required
		self:SecureHook(this, "RefreshAlpha", function(fObj)
			local alpha = 1.0 - _G.BattlefieldMapOptions.opacity
			alpha = (alpha >= 0.15) and alpha - 0.15 or alpha
			fObj.BorderFrame.sf:SetAlpha(alpha)
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
				self:SecureHook(mBM, "UpdateTextureVisibility", function(fObj)
					updBMVisibility(fObj.db.profile)
				end)
			end
		end

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.BattlefieldMapFrame)

end

if aObj.isRtlPTR then
	aObj.blizzLoDFrames[ftype].BehavioralMessaging = function(self)
		if not self.prdb.BehavioralMessaging or self.initialized.BehavioralMessaging then return end
		self.initialized.BehavioralMessaging = true

		self:SecureHookScript(_G.BehavioralMessagingTray, "OnShow", function(this)

			-- TODO: skin notification pool entries

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.BehavioralMessagingDetails, "OnShow", function(this)
			self:skinObject("frame", {obj=this, fType=ftype, rns=true})
			if self.modBtns then
				self:skinStdButton{obj=this.CloseButton, fType=ftype}
			end

			self:Unhook(this, "OnShow")
		end)

	end

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
					self:SecureHook(row, "Update", function(fObj)
						self:clrBtnBdr(fObj.key2Button)
						fObj.key1Button.sb:SetAlpha(fObj.key1Button:GetAlpha())
						fObj.key2Button.sb:SetAlpha(fObj.key2Button:GetAlpha())
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
				self:SecureHook(this, "UpdateUnbindKey", function(fObj)
					self:clrBtnBdr(fObj.unbindButton)
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

	if not self.isClsc then
		self:SecureHookScript(_G.QuickKeybindFrame, "OnShow", function(this)
			self:removeNineSlice(this.BG)
			this.BG.Bg:SetTexture(nil)
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, nb=true, hdr=true, ofs=0}
			if self.modBtns then
				self:skinStdButton{obj=this.defaultsButton}
				self:skinStdButton{obj=this.cancelButton}
				self:skinStdButton{obj=this.okayButton}
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

	self:SecureHookScript(_G.BNToastFrame, "OnShow", function(this)
		self:skinObject("frame", {obj=this, fType=ftype, ofs=0})
		if self.modBtns then
			self:skinCloseButton{obj=this.CloseButton, font=self.fontSBX, noSkin=true}
			this.CloseButton.cb = this.CloseButton.sb
		end
		self:hookSocialToastFuncs(this)
		self:skinObject("frame", {obj=this.TooltipFrame, fType=ftype, kfs=true})
		this.TooltipFrame:SetScript("OnLoad", nil)

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.TimeAlertFrame, "OnShow", function(this)
		self:skinObject("frame", {obj=this, fType=ftype, ofs=0})
		if self.modBtns then
			self:skinCloseButton{obj=this.CloseButton, font=self.fontSBX, noSkin=true}
			this.CloseButton.cb = this.CloseButton.sb
		end
		self:hookSocialToastFuncs(this)

	self:Unhook(this, "OnShow")
	end)

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
				self:SecureHook(dungeon, "SetUp", function(bObj, mapInfo, _)
					if mapInfo.level > 0 then
						bObj.sbb:SetBackdropBorderColor(bObj.HighestLevel:GetTextColor())
					else
						self:clrBtnBdr(bObj, "disabled")
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
		self:SecureHook(_G.BarberShopFrame, "UpdateSex", function(fObj)
			for btn in fObj.sexButtonPool:EnumerateActive() do
				btn.Ring:SetTexture(nil)
				btn.BlackBG:SetTexture(nil)
			end
		end)

		-- AlteredForms
		self:SecureHook(this, "UpdateAlteredFormButtons", function(fObj)
			for btn in fObj.alteredFormsPools:EnumerateActive() do
				btn.Ring:SetTexture(nil)
			end
		end)

		-- Categories

		-- Options
		self:SecureHook(this, "UpdateOptionButtons", function(fObj, _)
			for btn in fObj.pools:GetPool("CharCustomizeShapeshiftFormButtonTemplate"):EnumerateActive() do
				btn.Ring:SetTexture(nil)
			end
			for btn in fObj.pools:GetPool("CharCustomizeCategoryButtonTemplate"):EnumerateActive() do
				btn.Ring:SetTexture(nil)
			end
			for frame in fObj.selectionPopoutPool:EnumerateActive() do
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
					self:secureHook(frame, "UpdateButtons", function(_)
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
			self:SecureHook(this, "UpdateZoomButtonStates", function(fObj)
				self:clrBtnBdr(fObj.SmallButtons.ZoomOutButton, "gold")
				self:clrBtnBdr(fObj.SmallButtons.ZoomInButton, "gold")

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

	-- N.B. ChatBubbles in Raids, Dungeons and Garrisons are forbidden and can't be skinned
	local function skinChatBubbles()
		_G.C_Timer.After(0.1, function()
			-- get all ChatBubbles NOT including Forbidden ones
			for _, cBubble in _G.pairs(_G.C_ChatBubbles.GetAllChatBubbles()) do
				cBubble = aObj:getChild(cBubble, 1)
				aObj:skinObject("frame", {obj=cBubble, fType=ftype, kfs=true, ba=aObj.prdb.ChatBubbles.alpha, ng=true, ofs=-8, clr="grey"})
				-- make text visible
				if cBubble.String then
					cBubble.String:SetParent(cBubble.sf)
				elseif cBubble:GetNumRegions() == 2 then
					aObj:getRegion(cBubble, 2):SetParent(cBubble.sf)
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
	if _G.C_CVar.GetCVarBool("chatBubbles")
	or _G.C_CVar.GetCVarBool("chatBubblesParty")
	then
		-- skin any existing ones
		registerEvents()
		skinChatBubbles()
	end
	-- hook this to handle changes
	self:SecureHook("InterfaceOptionsDisplayPanelChatBubblesDropDown_SetValue", function(_, value)
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
		self:addButtonBorder{obj=_G.TextToSpeechButton, x1=1, y1=2, x2=-2, y2=-2, clr="grey"}
		-- QuickJoinToastButton(s)
		self:addButtonBorder{obj=_G.QuickJoinToastButton, x1=1, y1=2, x2=-2, y2=-2, clr="grey"}
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

aObj.blizzFrames[ftype].ChatChannelsUI = function(self)
	if not self.prdb.ChatChannelsUI or self.initialized.ChatChannelsUI then return end
	self.initialized.ChatChannelsUI = true

	self:SecureHookScript(_G.ChannelFrame, "OnShow", function(this)
		self:removeInset(this.LeftInset)
		self:removeInset(this.RightInset)
		if self.modBtns then
			self:skinStdButton{obj=this.NewButton}
			self:skinStdButton{obj=this.SettingsButton}
		end
		self:skinObject("slider", {obj=this.ChannelList.ScrollBar, fType=ftype})
		self:skinObject("slider", {obj=this.ChannelRoster.ScrollFrame.scrollBar, fType=ftype, y1=-2, y2=2})
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true, x1=-5, y2=-1})
		-- Create Channel Popup
		self:removeNineSlice(_G.CreateChannelPopup.BG)
		self:skinObject("editbox", {obj=_G.CreateChannelPopup.Name, fType=ftype, ofs=3})
		self:skinObject("editbox", {obj=_G.CreateChannelPopup.Password, fType=ftype, ofs=3})
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.CreateChannelPopup.UseVoiceChat}
		end
		if self.modBtns then
			self:skinStdButton{obj=_G.CreateChannelPopup.OKButton}
			self:skinStdButton{obj=_G.CreateChannelPopup.CancelButton}
		end
		self:skinObject("frame", {obj=_G.CreateChannelPopup, fType=ftype, kfs=true, cb=true, ofs=-6, y1=-7})

		self:Unhook(this, "OnShow")
	end)

	self:SecureHook(_G.ChannelFrame.ChannelList, "Update", function(this)
		for header in this.headerButtonPool:EnumerateActive() do
			header:GetNormalTexture():SetTexture(nil)
		end
		-- for textChannel in this.textChannelButtonPool:EnumerateActive() do
		-- end
		-- for voiceChannel in this.voiceChannelButtonPool:EnumerateActive() do
		-- end
		-- for communityChannel in this.communityChannelButtonPool:EnumerateActive() do
		-- end
	end)

	self:SecureHookScript(_G.VoiceChatPromptActivateChannel, "OnShow", function(this)
		self:skinObject("frame", {obj=this, fType=ftype})
		if self.modBtns then
			self:skinCloseButton{obj=this.CloseButton, font=self.fontSBX, noSkin=true}
			self:skinStdButton{obj=this.AcceptButton}
		end
		self:hookSocialToastFuncs(this)

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.VoiceChatChannelActivatedNotification, "OnShow", function(this)
		self:skinObject("frame", {obj=this, fType=ftype})
		if self.modBtns then
			self:skinCloseButton{obj=this.CloseButton, font=self.fontSBX, noSkin=true}
		end
		self:hookSocialToastFuncs(this)

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].ChatConfig = function(self)
	if not self.prdb.ChatConfig or self.initialized.ChatConfig then return end
	self.initialized.ChatConfig = true

	self:SecureHookScript(_G.ChatConfigFrame, "OnShow", function(this)
		if self.isRtl then
			self:removeNineSlice(this.Border)
		end
		self:skinObject("frame", {obj=_G.ChatConfigCategoryFrame, fType=ftype, kfs=true, rns=true, fb=true, ofs=0})
		self:skinObject("frame", {obj=_G.ChatConfigBackgroundFrame, fType=ftype, kfs=true, rns=true, fb=true, ofs=0})
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, hdr=true, ofs=-4, y1=0})
		if self.modBtns then
			self:skinStdButton{obj=this.DefaultButton}
			self:skinStdButton{obj=this.RedockButton}
			self:skinStdButton{obj=_G.CombatLogDefaultButton}
			if aObj.isRtlPTR
			or aObj.isClscERAPTR
			then
				self:skinStdButton{obj=this.ToggleChatButton}
				if aObj.isRtlPTR then
					self:skinStdButton{obj=_G.TextToSpeechDefaultButton, fType=ftype}
				end
			end
			self:skinStdButton{obj=_G.ChatConfigFrameCancelButton}
			self:skinStdButton{obj=_G.ChatConfigFrameOkayButton}
		end
		if self.modChkBtns then
			if aObj.isRtlPTR then
				self:skinCheckButton{obj=_G.TextToSpeechCharacterSpecificButton, fType=ftype}
			end
		end
		-- ChatTabManager
		local setTabState
		if self.isTT then
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
				tab:SetAlpha(1)
				tab:SetFrameLevel(21)
				tab.sf:SetFrameLevel(20)
				tab.sf:Show()
			end
		end
		local tabSkin = self.skinTPLs.new("tabs", {obj=this.ChatTabManager, tabs={}, fType=ftype, upwards=true, ignoreHLTex=false, offsets={x1=4, y1=self.isTT and -10 or -12, x2=-4, y2=self.isTT and -5 or 0}, regions={8, 9, 10, 11}, noCheck=true, func=setTabState})
		local function skinTabs(ctm)
			tabSkin.tabs = {}
			for tab in ctm.tabPool:EnumerateActive() do
				aObj:add2Table(tabSkin.tabs, tab)
				if tab:GetID() == _G.CURRENT_CHAT_FRAME_ID then
					tab:GetFontString():SetTextColor(1, 1, 1)
				else
					tab:GetFontString():SetTextColor(_G.NORMAL_FONT_COLOR.r, _G.NORMAL_FONT_COLOR.g, _G.NORMAL_FONT_COLOR.b)
				end
			end
			aObj:skinObject(tabSkin)
		end
		skinTabs(this.ChatTabManager)
		self:SecureHook(this.ChatTabManager, "OnShow", function(fObj)
			skinTabs(fObj)
		end)
		self:SecureHook(this.ChatTabManager, "UpdateSelection", function(fObj, _)
			skinTabs(fObj)
		end)
		local function skinCB(cBox)
			if aObj.isClscERAPTR
			and _G[cBox].NineSlice
			then
				aObj:removeNineSlice(_G[cBox].NineSlice)
			else
				aObj:removeBackdrop(_G[cBox])
			end
			if aObj.modChkBtns then
				local box
				for _, suffix in _G.pairs{"", "Check", "ColorSwatch"} do
					box = _G[cBox .. suffix]
					if box
					and box:IsObjectType("CheckButton")
					then
						aObj:skinCheckButton{obj=box}
					end
				end
			end
		end
		--	Chat Settings
		if self.modChkBtns then
			for i = 1, #_G.CHAT_CONFIG_CHAT_LEFT do
				skinCB("ChatConfigChatSettingsLeftCheckBox" .. i)
			end
		end
		self:skinObject("frame", {obj=_G.ChatConfigChatSettingsLeft, fType=ftype, kfs=true, rns=true, fb=true})
		--	Channel Settings
		self:skinObject("frame", {obj=_G.ChatConfigChannelSettingsLeft, fType=ftype, kfs=true, rns=true, fb=true})
		if not self.isClsc then
			if self.modChkBtns then
				self:SecureHookScript(_G.ChatConfigChannelSettings, "OnShow", function(fObj)
					for i = 1, #_G.CHAT_CONFIG_CHANNEL_LIST do
						skinCB("ChatConfigChannelSettingsLeftCheckBox" .. i)
					end

					self:Unhook(fObj, "OnShow")
				end)
			end
		else
			self:skinObject("frame", {obj=_G.ChatConfigChannelSettingsAvailable, fType=ftype, kfs=true})
			self:SecureHook("ChatConfig_CreateCheckboxes", function(frame, _)
				local box
				for i = 1, #frame.checkBoxTable do
					box = _G[frame:GetName() .. "CheckBox" .. i]
					if aObj.isClscERAPTR
					and box.NineSlice
					then
						aObj:removeNineSlice(box.NineSlice)
					else
						aObj:removeBackdrop(box)
					end
					if self.modChkBtns then
						 self:skinCheckButton{obj=box.CheckButton}
					end
				end
			end)
			self:SecureHook("ChatConfig_CreateBoxes", function(frame, _)
				local box
				for i = 1, #frame.boxTable do
					box = _G[frame:GetName() .. "Box" .. i]
					if aObj.isClscERAPTR
					and box.NineSlice
					then
						aObj:removeNineSlice(box.NineSlice)
					else
						aObj:removeBackdrop(box)
					end
					if self.modBtns then
						self:skinStdButton{obj=box.Button, ofs=0}
					end
				end
			end)
		end
		--	Other Settings
		for i = 1, #_G.CHAT_CONFIG_OTHER_COMBAT do
			skinCB("ChatConfigOtherSettingsCombatCheckBox" .. i)
		end
		self:skinObject("frame", {obj=_G.ChatConfigOtherSettingsCombat, fType=ftype, kfs=true, rns=true, fb=true})
		for i = 1, #_G.CHAT_CONFIG_OTHER_PVP do
			skinCB("ChatConfigOtherSettingsPVPCheckBox" .. i)
		end
		self:skinObject("frame", {obj=_G.ChatConfigOtherSettingsPVP, fType=ftype, kfs=true, rns=true, fb=true})
		for i = 1, #_G.CHAT_CONFIG_OTHER_SYSTEM do
			skinCB("ChatConfigOtherSettingsSystemCheckBox" .. i)
		end
		self:skinObject("frame", {obj=_G.ChatConfigOtherSettingsSystem, fType=ftype, kfs=true, rns=true, fb=true})
		for i = 1, #_G.CHAT_CONFIG_CHAT_CREATURE_LEFT do
			skinCB("ChatConfigOtherSettingsCreatureCheckBox" .. i)
		end
		self:skinObject("frame", {obj=_G.ChatConfigOtherSettingsCreature, fType=ftype, kfs=true, rns=true, fb=true})
		-- TextToSpeechSettings
		if aObj.isRtlPTR then
			-- N.B. TextToSpeechFrame is skinned separately
			if self.modChkBtns then
				self:SecureHook("TextToSpeechFrame_UpdateMessageCheckboxes", function(frame)
					for i = 1, #frame.checkBoxTable do
						self:skinCheckButton{obj=_G[frame:GetName() .. "CheckBox" .. i], fType=ftype}
					end

					self:Unhook("TextToSpeechFrame_UpdateMessageCheckboxes")
				end)
			end
			self:SecureHookScript(_G.ChatConfigTextToSpeechChannelSettings, "OnShow", function(fObj)
				self:skinObject("frame", {obj=_G.ChatConfigTextToSpeechChannelSettingsLeft, fType=ftype, kfs=true, rns=true, fb=true})
				for i = 1, #_G.CHAT_CONFIG_TEXT_TO_SPEECH_CHANNEL_LIST do
					skinCB("ChatConfigTextToSpeechChannelSettingsLeftCheckBox" .. i)
				end

				self:Unhook(fObj, "OnShow")
			end)
		end
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
		self:skinObject("frame", {obj=_G.ChatConfigCombatSettingsFilters, fType=ftype, kfs=true, rns=true, fb=true, ofs=0})
		_G.LowerFrameLevel(_G.ChatConfigCombatSettingsFilters) -- make frame appear below tab texture
		-- Message Sources
		for i = 1, #_G.COMBAT_CONFIG_MESSAGESOURCES_BY do
			skinCB("CombatConfigMessageSourcesDoneByCheckBox" .. i)
		end
		self:skinObject("frame", {obj=_G.CombatConfigMessageSourcesDoneBy, fType=ftype, kfs=true, rns=true, fb=true})
		for i = 1, #_G.COMBAT_CONFIG_MESSAGESOURCES_TO do
			skinCB("CombatConfigMessageSourcesDoneToCheckBox" .. i)
		end
		self:skinObject("frame", {obj=_G.CombatConfigMessageSourcesDoneTo, fType=ftype, kfs=true, rns=true, fb=true})
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
			if aObj.isClscERAPTR
			and _G["CombatConfigColorsUnitColorsSwatch" .. i].NineSlice
			then
				aObj:removeNineSlice(_G["CombatConfigColorsUnitColorsSwatch" .. i].NineSlice)
			else
				self:removeBackdrop(_G["CombatConfigColorsUnitColorsSwatch" .. i])
			end
		end
		self:skinObject("frame", {obj=_G.CombatConfigColorsUnitColors, fType=ftype, kfs=true, rns=true, fb=true})
		self:skinObject("frame", {obj=_G.CombatConfigColorsHighlighting, fType=ftype, kfs=true, rns=true, fb=true})
		self:skinObject("frame", {obj=_G.CombatConfigColorsColorizeUnitName, fType=ftype, kfs=true, rns=true, fb=true})
		self:skinObject("frame", {obj=_G.CombatConfigColorsColorizeSpellNames, fType=ftype, kfs=true, rns=true, fb=true})
		self:skinObject("frame", {obj=_G.CombatConfigColorsColorizeDamageNumber, fType=ftype, kfs=true, rns=true, fb=true})
		self:skinObject("frame", {obj=_G.CombatConfigColorsColorizeDamageSchool, fType=ftype, kfs=true, rns=true, fb=true})
		self:skinObject("frame", {obj=_G.CombatConfigColorsColorizeEntireLine, fType=ftype, kfs=true, rns=true, fb=true})
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
		end
		-- Formatting
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.CombatConfigFormattingShowTimeStamp}
			self:skinCheckButton{obj=_G.CombatConfigFormattingFullText}
			if not self.isClscERA then
				self:skinCheckButton{obj=_G.CombatConfigFormattingShowBraces}
				self:skinCheckButton{obj=_G.CombatConfigFormattingUnitNames}
				self:skinCheckButton{obj=_G.CombatConfigFormattingSpellNames}
				self:skinCheckButton{obj=_G.CombatConfigFormattingItemNames}
			end
		end
		-- Settings
		self:skinObject("editbox", {obj=_G.CombatConfigSettingsNameEditBox, fType=ftype})
		if self.modBtns then
			self:skinStdButton{obj=_G.CombatConfigSettingsSaveButton, fType=ftype}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.CombatConfigSettingsShowQuickButton, fType=ftype}
			self:skinCheckButton{obj=_G.CombatConfigSettingsSolo, fType=ftype}
			self:skinCheckButton{obj=_G.CombatConfigSettingsParty, fType=ftype}
			self:skinCheckButton{obj=_G.CombatConfigSettingsRaid, fType=ftype}
		end
		self:skinObject("tabs", {obj=_G.ChatConfigCombatSettings, prefix="CombatConfig", numTabs=#_G.COMBAT_CONFIG_TABS, fType=ftype, lod=self.isTT and true, upwards=true, offsets={x1=2, y1=-8, x2=-2, y2=self.isTT and -5 or 0}, regions={4, 5}, track=false})
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

	self:skinObject("frame", {obj=_G.ChatMenu, fType=ftype, rns=true, ofs=0})
	self:skinObject("frame", {obj=_G.EmoteMenu, fType=ftype, rns=true, ofs=0})
	self:skinObject("frame", {obj=_G.LanguageMenu, fType=ftype, rns=true, ofs=0})
	self:skinObject("frame", {obj=_G.VoiceMacroMenu, fType=ftype, rns=true, ofs=0})
	self:skinObject("frame", {obj=_G.GeneralDockManagerOverflowButtonList, fType=ftype, rns=true, ofs=0})

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
	local xOfs = 4
	if aObj.isClscBC then
		xOfs = 1
	end
	self:skinObject("tabs", {obj=_G.FloatingChatFrameManager, tabs=fcfTabs, fType=ftype, lod=self.isTT and true, upwards=true, ignoreHLTex=false, regions={7, 8, 9, 10, 11}, offsets={x1=xOfs, y1=self.isTT and -10 or -12, x2=xOfs * -1, y2=self.isTT and -3 or -1}, track=false, func=function(tab) tab.sf:SetAlpha(tab:GetAlpha()) tab.sf:Hide() end})
	if self.isTT then
		self:SecureHook("FCF_Tab_OnClick", function(this, _)
			for i = 1, _G.NUM_CHAT_WINDOWS do
				self:setInactiveTab(_G["ChatFrame" .. i .. "Tab"].sf)
			end
			self:setActiveTab(this.sf)
		end)
	end

	if self.prdb.ChatTabsFade then
		-- hook this to show/hide the skin frame
		self:SecureHook("FCFTab_UpdateColors", function(this, selected)
			if this.sf then
				this.sf:SetShown(selected)
			end
		end)
		_G.ChatFrame1Tab.sf:Show()
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
			aObj:skinObject("tabs", {obj=obj, fType=ftype, tabs={_G[obj:GetName() .. "Tab"]}, lod=self.isTT and true, upwards=true, ignoreHLTex=false, regions={7, 8, 9, 10, 11}, offsets={x1=4, y1=self.isTT and -10 or -12, x2=-4, y2=self.isTT and -3 or -1}, track=false})
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
		if aObj.isClscBC then
			self:skinObject("frame", {obj=this.closeDialog, fType=ftype, kfs=true, rb=true})
		else
			self:skinObject("frame", {obj=this.closeDialog, fType=ftype})
		end
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
		this.Hourglass:SetTexture(self.tFDIDs.mHG)
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
	if not self.prdb.ColorPicker or self.initialized.ColorPicker then return end
	self.initialized.ColorPicker = true

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
		this.GlowLineTopBottom:SetAlpha(0) -- texture changed in code
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

	local function skinTAD(frame)
		aObj:skinObject("editbox", {obj=frame.FilterBox, fType=ftype, si=true})
		aObj:skinObject("slider", {obj=frame.LinesScrollFrame.ScrollBar, fType=ftype})
		aObj:skinObject("frame", {obj=frame.ScrollFrameArt, fType=ftype, rns=true, fb=true})
		aObj:skinObject("frame", {obj=frame, fType=ftype, kfs=true, cb=true, ofs=-2, x1=5, x2=-1})
		if aObj.modBtns then
			aObj:skinOtherButton{obj=frame.OpenParentButton, font=aObj.fontS, disfont=aObj.fontDS, text=aObj.uparrow}
			aObj:skinOtherButton{obj=frame.NavigateBackwardButton, font=aObj.fontS, disfont=aObj.fontDS, text="x", size=32}
			aObj:skinOtherButton{obj=frame.NavigateForwardButton, font=aObj.fontS, disfont=aObj.fontDS, text="x", size=32}
			aObj:skinOtherButton{obj=frame.DuplicateButton, font=aObj.fontS, text=aObj.nearrow}
			aObj:clrBtnBdr(frame.NavigateBackwardButton)
			aObj:clrBtnBdr(frame.NavigateForwardButton)
			aObj:SecureHook(frame, "InspectTable", function(_, _)
				if frame.OpenParentButton:IsEnabled() then
					frame.OpenParentButton:SetText(aObj.uparrow)
				else
					frame.OpenParentButton:SetText("x")
				end
				aObj:clrBtnBdr(frame.OpenParentButton)
			end)
			aObj:SecureHook(frame, "UpdateTableNavigation", function(_, _)
				if frame.NavigateBackwardButton:IsEnabled() then
					frame.NavigateBackwardButton:SetText(aObj.larrow)
				else
					frame.NavigateBackwardButton:SetText("x")
				end
				if frame.NavigateForwardButton:IsEnabled() then
					frame.NavigateForwardButton:SetText(aObj.rarrow)
				else
					frame.NavigateForwardButton:SetText("x")
				end
				aObj:clrBtnBdr(frame.NavigateBackwardButton)
				aObj:clrBtnBdr(frame.NavigateForwardButton)
			end)
		end
		if aObj.modChkBtns then
			aObj:skinCheckButton{obj=frame.VisibilityButton}
			aObj:skinCheckButton{obj=frame.HighlightButton}
			aObj:skinCheckButton{obj=frame.DynamicUpdateButton}
		end
	end
	self:SecureHookScript(_G.TableAttributeDisplay, "OnShow", function(this)
		skinTAD(this)
		self:RawHook("DisplayTableInspectorWindow", function(...)
			local frame = self.hooks.DisplayTableInspectorWindow(...)
			skinTAD(frame)
			return frame
		end, true)

		self:Unhook(this, "OnShow")
	end)

	-- tooltips
	_G.C_Timer.After(0.1, function()
		self:add2Table(self.ttList, _G.FrameStackTooltip)
		_G.FrameStackTooltip:SetFrameLevel(20)
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
			self:changeTex(this[type .. "Button"]:GetHighlightTexture())
			self:adjWidth{obj=this[type .. "Button"], adj=-60}
			self:adjHeight{obj=this[type .. "Button"], adj=-60}
			if self.modBtns then
				self:skinStdButton{obj=this[type .. "Button"], x1=-2, y1=2, x2=-3, y2=-1}
			end
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].EventToastManager = function(self)
	if not self.prdb.EventToastManager or self.initialized.EventToastManager then return end
	self.initialized.EventToastManager = true

	local function skinToasts(frame)
		for toast in frame.eventToastPools:EnumerateActive() do
			toast:DisableDrawLayer("BORDER")
			if toast.BannerFrame then
				toast.BannerFrame:DisableDrawLayer("BACKGROUND")
				toast.BannerFrame:DisableDrawLayer("BORDER")
				toast.BannerFrame:DisableDrawLayer("OVERLAY")
				if toast.BannerFrame.MedalIcon then -- ChallengeMode
					toast.BannerFrame.MedalIcon:SetDrawLayer("ARTWORK", 2)
				end
			end
		end
	end
	self:SecureHook(_G.EventToastManagerFrame, "DisplayToast", function(this, _)
		skinToasts(this)
	end)
	skinToasts(_G.EventToastManagerFrame)

	self:SecureHookScript(_G.EventToastManagerFrame, "OnShow", function(this)
		this:DisableDrawLayer("BACKGROUND")

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.EventToastManagerFrame)

	self:SecureHookScript(_G.EventToastManagerSideDisplay, "OnShow", function(this)
		this:DisableDrawLayer("BACKGROUND")

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.EventToastManagerSideDisplay)

end

aObj.blizzLoDFrames[ftype].EventTrace = function(self)
	if not self.prdb.EventTrace or self.initialized.EventTrace then return end
	self.initialized.EventTrace = true

	local function skinMenuBtn(btn)
		aObj:skinStdButton{obj=btn, fType=ftype, y1=2, y2=-3}
		aObj.modUIBtns:chgHLTex(btn, btn.MouseoverOverlay)
	end
	aObj:SecureHookScript(_G.EventTrace, "OnShow", function(this)
		aObj:skinObject("editbox", {obj=this.Log.Bar.SearchBox, fType=ftype, si=true})
		aObj:skinObject("scrollbar", {obj=this.Log.Events.ScrollBar, fType=ftype, x1=0, x2=0})
		aObj:skinObject("scrollbar", {obj=this.Log.Search.ScrollBar, fType=ftype, x1=0, x2=0})
		aObj:skinObject("scrollbar", {obj=this.Filter.ScrollBar, fType=ftype, x1=0, x2=0})
		aObj:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true, x2=aObj.isRtl and 3 or 1})
		if aObj.modBtns then
			skinMenuBtn(this.SubtitleBar.ViewLog)
			skinMenuBtn(this.SubtitleBar.ViewFilter)
			aObj:skinStdButton{obj=this.SubtitleBar.OptionsDropDown, fType=ftype, clr="grey"}
			skinMenuBtn(this.Log.Bar.MarkButton)
			skinMenuBtn(this.Log.Bar.PlaybackButton)
			skinMenuBtn(this.Log.Bar.DiscardAllButton)
			skinMenuBtn(this.Filter.Bar.CheckAllButton)
			skinMenuBtn(this.Filter.Bar.UncheckAllButton)
			skinMenuBtn(this.Filter.Bar.DiscardAllButton)
		end

		aObj:Unhook(this, "OnShow")
	end)
	if aObj.modBtns
	or aObj.modChkBtns
	then
		aObj:SecureHook(_G.EventTraceLogEventButtonMixin, "Init", function(this, _)
			if aObj.modBtns then
				aObj:skinCloseButton{obj=this.HideButton, fType=ftype, noSkin=true}
			end
		end)
		aObj:SecureHook(_G.EventTraceFilterButtonMixin, "Init", function(this, _)
			if aObj.modBtns then
				aObj:skinCloseButton{obj=this.HideButton, fType=ftype, noSkin=true}
			end
			if aObj.modChkBtns then
				aObj:skinCheckButton{obj=this.CheckButton, fType=ftype, ofs=-1}
			end
		end)
	end
	self:checkShown(_G.EventTrace)

	-- tooltip
	_G.C_Timer.After(0.1, function()
		self:add2Table(self.ttList, _G.EventTraceTooltip)
	end)

end

-- this code handles the ExtraActionBarFrame and ZoneAbilityFrame buttons
aObj.blizzFrames[ftype].ExtraAbilityContainer = function(self)
	if self.initialized.ExtraAbilityContainer then return end
	self.initialized.ExtraAbilityContainer = true

	local function skinBtn(btn)
		if btn:IsForbidden() then return end
		-- handle in combat
		if _G.InCombatLockdown() then
		    aObj:add2Table(aObj.oocTab, {skinBtn, {btn}})
		    return
		end
		btn:GetNormalTexture():SetTexture(nil)
		if aObj.modBtnBs then
			aObj:addButtonBorder{obj=btn, sabt=true, ofs=2, reParent={btn.Count, btn.HotKey and btn.HotKey}}
		end
	end
	if self.prdb.MainMenuBar.extraab then
		self:SecureHookScript(_G.ExtraActionBarFrame.intro, "OnFinished", function(_)
			_G.ExtraActionBarFrame.button.style:SetAlpha(0)
		end)
		skinBtn(_G.ExtraActionBarFrame.button)
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

	_G.GarrisonFollowerTooltip.PortraitFrame.PortraitRing:SetTexture(nil)
	_G.GarrisonFollowerTooltip.PortraitFrame.LevelBorder:SetAlpha(0)
	_G.GarrisonFollowerAbilityTooltip.CounterIconBorder:SetTexture(nil)
	_G.FloatingGarrisonFollowerTooltip.PortraitFrame.PortraitRing:SetTexture(nil)
	_G.FloatingGarrisonFollowerTooltip.PortraitFrame.LevelBorder:SetAlpha(0)
	_G.FloatingGarrisonFollowerAbilityTooltip.CounterIconBorder:SetTexture(nil)

	-- tooltip
	_G.C_Timer.After(0.1, function()
		self:add2Table(self.ttList, _G.GarrisonFollowerTooltip)
		self:add2Table(self.ttList, _G.GarrisonFollowerAbilityTooltip)
		self:add2Table(self.ttList, _G.GarrisonFollowerAbilityWithoutCountersTooltip)
		self:add2Table(self.ttList, _G.GarrisonFollowerMissionAbilityWithoutCountersTooltip)
		self:add2Table(self.ttList, _G.GarrisonShipyardFollowerTooltip)
		self:add2Table(self.ttList, _G.FloatingGarrisonFollowerTooltip)
		self:add2Table(self.ttList, _G.FloatingGarrisonShipyardFollowerTooltip)
		self:add2Table(self.ttList, _G.FloatingGarrisonFollowerAbilityTooltip)
		self:add2Table(self.ttList, _G.FloatingGarrisonMissionTooltip)
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

	self:SecureHookScript(_G.GarrisonLandingPage, "OnShow", function(this)
		-- ReportTab (ALWAYS shown first)
		this.Report.List:DisableDrawLayer("BACKGROUND")
		self:skinObject("slider", {obj=this.Report.List.listScroll.scrollBar, fType=ftype, x2=-4})
		for _, btn in _G.pairs(this.Report.List.listScroll.buttons) do
			btn:DisableDrawLayer("BACKGROUND")
			btn:DisableDrawLayer("BORDER")
			if self.modBtnBs then
				for _, reward in _G.pairs(btn.Rewards) do
					self:addButtonBorder{obj=reward, relTo=reward.Icon, reParent={reward.Quantity}}
					self:clrButtonFromBorder(reward)
				end
			end
		end
		self:skinObject("frame", {obj=this.Report.List, fType=ftype, fb=true, y1=4})
		-- tabs (Top)
		self:skinObject("tabs", {obj=this.Report, tabs={this.Report.InProgress, this.Report.Available}, fType=ftype, lod=self.isTT and true, ignoreHLTex=false, upwards=true, offsets={x1=4, y1=self.isTT and -2 or -5, x2=-4, y2=self.isTT and -4 or 1}, regions={2, 3}, track=false, func=function(tab) tab:GetNormalTexture():SetAlpha(0) tab:SetFrameLevel(20) end})
		if self.isTT then
			self:SecureHook("GarrisonLandingPageReport_SetTab", function(tab)
				self:setInactiveTab(tab:GetParent().unselectedTab.sf)
				self:setActiveTab(tab.sf)
			end)
		end
		skinFollowerList(this.FollowerList)
		skinFollowerPage(this.FollowerTab)
		skinFollowerList(this.ShipFollowerList)
		skinFollowerTraitsAndEquipment(this.ShipFollowerTab)
		if _G.C_Garrison.GetLandingPageGarrisonType() == _G.Enum.GarrisonType.Type_9_0 then
			local function skinPanelBtns(panel)
				panel:DisableDrawLayer("BACKGROUND")
				aObj:skinObject("frame", {obj=panel.RenownButton, fType=ftype, regions={3, 5, 6}, ofs=-4, y1=-5, y2=3})
				panel.RenownButton.UpdateButtonTextures = _G.nop
				aObj:skinObject("frame", {obj=panel.SoulbindButton, fType=ftype, regions={1, 2}, ofs=-4, y1=-5, y2=3})
				panel.SoulbindButton.Portrait.SetAtlas = _G.nop
				skinPanelBtns = nil
			end
			if not this.SoulbindPanel then
				self:SecureHook(this, "SetupSoulbind", function(fObj)
					if fObj.SoulbindPanel then
						skinPanelBtns(fObj.SoulbindPanel)
						self:Unhook(fObj, "SetupSoulbind")
					end
				end)
			else
				skinPanelBtns(this.SoulbindPanel)
			end
			self:nilTexture(this.CovenantCallings.Background, true)
			self:nilTexture(this.CovenantCallings.Decor, true)
			if _G.C_ArdenwealdGardening.IsGardenAccessible() then
				self:nilTexture(self:getRegion(this.ArdenwealdGardeningPanel, 1), true)
				self:nilTexture(self:getChild(this.ArdenwealdGardeningPanel, 1).Border, true)
			end
		end
		this.HeaderBar:SetTexture(nil)
		self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true, ignoreHLTex=false, offsets={x1=5, y1=self.isTT and -9 or -14, x2=-5, y2=-2}, regions={7, 8, 9, 10}})
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, ofs=-13, y2=6})

		-- N.B. Garrison Landing Page Minimap Button skinned with other minimap buttons
		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.GarrisonLandingPage)

	if _G.GarrisonLandingPageTutorialBox then
		self:skinGlowBox(_G.GarrisonLandingPageTutorialBox, ftype)
	end

	self:SecureHookScript(_G.GarrisonBuildingFrame, "OnShow", function(this)
		this.MainHelpButton.Ring:SetTexture(nil)
		self:moveObject{obj=this.MainHelpButton, y=-4}
		this.GarrCorners:DisableDrawLayer("BACKGROUND")
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cbns=true, ofs=2})
		local function clrTabText()
			local btn
			for i = 1, _G.GARRISON_NUM_BUILDING_SIZES do
				btn = _G.GarrisonBuildingFrame.BuildingList["Tab" .. i]
				if btn == _G.GarrisonBuildingFrame.selectedTab then
					btn.Text:SetTextColor(1, 1, 1)
				else
					btn.Text:SetTextColor(_G.NORMAL_FONT_COLOR.r, _G.NORMAL_FONT_COLOR.g, _G.NORMAL_FONT_COLOR.b)
				end
			end
		end
		local function skinBLbuttons(bl)
			for i = 1, #bl.Buttons do
				bl.Buttons[i].BG:SetTexture(nil)
				if aObj.modBtnBs then
					aObj:addButtonBorder{obj=bl.Buttons[i], relTo=bl.Buttons[i].Icon}
				end
			end
		end
		self:SecureHookScript(_G.GarrisonBuildingFrame.BuildingList, "OnShow", function(fObj)
			skinBLbuttons(fObj)
			self:SecureHook("GarrisonBuildingList_SelectTab", function(tab)
				clrTabText()
				skinBLbuttons(tab:GetParent())
			end)
			fObj.MaterialFrame:DisableDrawLayer("BACKGROUND")
			fObj.Tabs = {fObj.Tab1, fObj.Tab2, fObj.Tab3}
			self:skinObject("tabs", {obj=fObj, tabs=fObj.Tabs, fType=ftype, lod=self.isTT and true, upwards=true, regions={1, 3}, offsets={x1=7, y1=-7, x2=-7, y2=self.isTT and 2 or 7}, track=false, func=aObj.isTT and function(tab)
				aObj:SecureHookScript(tab, "OnClick", function(blF)
					for _, bTab in _G.pairs(blF:GetParent().Tabs) do
						if bTab == this then
							aObj:setActiveTab(bTab.sf)
						else
							aObj:setInactiveTab(bTab.sf)
						end
					end
				end)
			end})
			clrTabText()
			self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, fb=true, y1=-5, clr="sepia"})

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(_G.GarrisonBuildingFrame.BuildingList)
		self:SecureHookScript(_G.GarrisonBuildingFrame.FollowerList, "OnShow", function(fObj)
			skinFollowerList(fObj, "sepia")

			self:Unhook(fObj, "OnShow")
		end)
		this.TownHallBox:DisableDrawLayer("BORDER")
		self:skinObject("frame", {obj=this.TownHallBox, fType=ftype, fb=true, clr="sepia"})
		if self.modBtns then
			self:skinStdButton{obj=this.TownHallBox.UpgradeButton, fType=ftype}
			self:SecureHook("GarrisonBuildingFrame_UpdateUpgradeButton", function()
				self:clrBtnBdr(_G.GarrisonBuildingFrame.TownHallBox.UpgradeButton)
			end)
		end
		self:SecureHookScript(_G.GarrisonBuildingFrame.InfoBox, "OnShow", function(fObj)
			fObj:DisableDrawLayer("BORDER")
			self:skinObject("frame", {obj=fObj, fType=ftype, fb=true, clr="sepia"})
			if self.modBtns then
				self:skinStdButton{obj=fObj.UpgradeButton}
			end
			-- N.B. The RankBadge changes with level and has level number within the texture, therefore MUST not be hidden
			-- ib.RankBadge:SetAlpha(0)
			fObj.InfoBar:SetTexture(nil)
			skinPortrait(fObj.FollowerPortrait)
			fObj.AddFollowerButton.EmptyPortrait:SetTexture(nil) -- InfoText background texture
			self:getRegion(fObj.PlansNeeded, 1):SetTexture(nil) -- shadow texture
			self:getRegion(fObj.PlansNeeded, 2):SetTexture(nil) -- cost bar texture
			-- Follower Portrait Ring Quality changes colour so track this change
			self:SecureHook("GarrisonBuildingInfoBox_ShowFollowerPortrait", function(_)
				-- make sure ring quality is updated to level border colour
				_G.GarrisonBuildingFrame.InfoBox.FollowerPortrait.PortraitRingQuality:SetVertexColor(_G.GarrisonBuildingFrame.InfoBox.FollowerPortrait.PortraitRing:GetVertexColor())
			end)

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(_G.GarrisonBuildingFrame.InfoBox)
		self:SecureHookScript(_G.GarrisonBuildingFrame.Confirmation, "OnShow", function(fObj)
			fObj:DisableDrawLayer("BACKGROUND")
			self:skinObject("frame", {obj=fObj, fType=ftype, cb=true, ofs=-12})
			if self.modBtns then
				self:skinStdButton{obj=fObj.UpgradeGarrisonButton}
				self:skinStdButton{obj=fObj.UpgradeButton}
				self:skinStdButton{obj=fObj.CancelButton}
			end

			self:Unhook(fObj, "OnShow")
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
			if self.modBtns
			and _G.GarrisonBuildingFrame.InfoBox.UpgradeButton.sb
			then
				 self:clrBtnBdr(_G.GarrisonBuildingFrame.InfoBox.UpgradeButton)
			end
		end)

		self:add2Table(self.ttList, _G.GarrisonBuildingFrame.BuildingLevelTooltip)

		self:Unhook(this, "OnShow")
	end)

	-- tooltips
	_G.C_Timer.After(0.1, function()
		self:add2Table(self.ttList, _G.GarrisonMissionMechanicTooltip)
		self:add2Table(self.ttList, _G.GarrisonMissionMechanicFollowerCounterTooltip)
	end)

	self:SecureHookScript(_G.GarrisonMissionTutorialFrame, "OnShow", function(this)
		if self.modBtns then
			self:skinStdButton{obj=this.GlowBox.Button}
		end
		-- N.B. NO CloseButton

		self:Unhook(this, "OnShow")
	end)

	-- hook these to skin mission rewards & OvermaxItem
    self:SecureHook("GarrisonMissionPage_SetReward", function(frame, _)
        frame.BG:SetTexture(nil)
		if self.modBtnBs then
			self:addButtonBorder{obj=frame, relTo=frame.Icon, reParent={frame.Quantity}, ofs=_G.Round(frame:GetWidth()) ~= 24 and 2 or nil}
			self:clrButtonFromBorder(frame)
		end
    end)
	self:SecureHook("GarrisonMissionButton_SetRewards", function(obj, _)
		for _, btn in _G.pairs(obj.Rewards) do
			self:removeRegions(btn, {1}) -- background shadow
			if self.modBtnBs then
				self:addButtonBorder{obj=btn, relTo=btn.Icon, reParent={btn.Quantity}, ofs=2}
				self:clrButtonFromBorder(btn)
			end
		end
	end)

	self:SecureHookScript(_G.GarrisonMissionFrame, "OnShow", function(this)
		skinMissionFrame(this)

		self:SecureHookScript(this.FollowerList, "OnShow", function(fObj)
			skinFollowerList(fObj)

			self:Unhook(fObj, "OnShow")
		end)

		self:SecureHookScript(this.MissionTab.MissionList, "OnShow", function(fObj)
			skinMissionList(fObj)

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.MissionTab.MissionList)

		self:SecureHookScript(this.MissionTab.MissionPage, "OnShow", function(fObj)
			skinMissionPage(fObj)

			self:Unhook(fObj, "OnShow")
		end)

		self:SecureHookScript(this.FollowerTab, "OnShow", function(fObj)
			skinFollowerPage(fObj)
			self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, fb=true})

			self:Unhook(fObj, "OnShow")
		end)

		self:SecureHookScript(this.MissionComplete, "OnShow", function(fObj)
			skinMissionComplete(fObj)

			self:Unhook(fObj, "OnShow")
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
		if self.modBtns then
			self:skinCloseButton{obj=this.BorderFrame.CloseButton2, noSkin=true}
		end
		self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true, ignoreHLTex=false, offsets={x1=10, y1=aObj.isTT and 2 or -1, x2=-11, y2=2}, regions={7, 8, 9, 10}})
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, x1=2, y1=2, x2=1, y2=-4})

		self:SecureHookScript(this.MissionTab.MissionList, "OnShow", function(fObj)
	        fObj:SetScale(1.019) -- make larger to fit frame
	        fObj.MapTexture:SetPoint("CENTER", fObj, "CENTER", 1, -10)
			fObj.MapTexture:SetDrawLayer("BACKGROUND", 1) -- make sure it appears above skinFrame but below other textures
			skinCompleteDialog(fObj.CompleteDialog, true)

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.MissionTab.MissionList)

		self:SecureHookScript(this.MissionTab.MissionPage, "OnShow", function(fObj)
			skinMissionPage(fObj, "sepia")

			self:Unhook(fObj, "OnShow")
		end)

		skinFollowerList(this.FollowerList, "sepia")
		self:SecureHookScript(this.FollowerTab, "OnShow", function(fObj)
			skinFollowerTraitsAndEquipment(fObj)
			self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, fb=true, clr="sepia"})

			self:Unhook(fObj, "OnShow")
		end)

		self:SecureHookScript(this.MissionComplete, "OnShow", function(fObj)
			skinMissionComplete(fObj, true)

			self:Unhook(fObj, "OnShow")
		end)

		self:add2Table(self.ttList, _G.GarrisonBonusAreaTooltip)
		self:add2Table(self.ttList, _G.GarrisonShipyardMapMissionTooltip)

		self:Unhook(this, "OnShow")
	end)

	-- a.k.a. Work Order Frame
	self:SecureHookScript(_G.GarrisonCapacitiveDisplayFrame, "OnShow", function(this)
		self:removeMagicBtnTex(this.StartWorkOrderButton)
		self:removeMagicBtnTex(this.CreateAllWorkOrdersButton)
		this.CapacitiveDisplay.IconBG:SetTexture(nil)
		skinPortrait(this.CapacitiveDisplay.ShipmentIconFrame.Follower)
		self:skinObject("editbox", {obj=this.Count, fType=ftype})
		-- hook this to skin reagents
		self:SecureHook("GarrisonCapacitiveDisplayFrame_Update", function(fObj, success, _)
			if success ~= 0 then
				for _, btn in _G.pairs(fObj.CapacitiveDisplay.Reagents) do
					btn.NameFrame:SetTexture(nil)
					if self.modBtnBs then
						self:addButtonBorder{obj=btn, relTo=btn.Icon, reParent={btn.Count}}
					end
				end
			end
			if self.modBtns then
				self:clrBtnBdr(fObj.StartWorkOrderButton)
				self:clrBtnBdr(fObj.CreateAllWorkOrdersButton)
			end
		end)
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true})
		if self.modBtns then
			self:skinStdButton{obj=this.StartWorkOrderButton}
			self:skinStdButton{obj=this.CreateAllWorkOrdersButton}
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=this.CapacitiveDisplay.ShipmentIconFrame, relTo=this.CapacitiveDisplay.ShipmentIconFrame.Icon}
			this.CapacitiveDisplay.ShipmentIconFrame.sbb:SetShown(this.CapacitiveDisplay.ShipmentIconFrame.Icon:IsShown())
			self:SecureHook(this.CapacitiveDisplay.ShipmentIconFrame.Icon, "Show", function(bObj)
				bObj:GetParent().sbb:Show()
			end)
			self:SecureHook(this.CapacitiveDisplay.ShipmentIconFrame.Icon, "Hide", function(bObj)
				bObj:GetParent().sbb:Hide()
			end)
			self:SecureHook(this.CapacitiveDisplay.ShipmentIconFrame.Icon, "SetShown", function(bObj, show)
				bObj:GetParent().sbb:SetShown(bObj, show)
			end)
			self:addButtonBorder{obj=this.DecrementButton, ofs=0, x2=-1, clr="gold"}
			self:addButtonBorder{obj=this.IncrementButton, ofs=0, x2=-1, clr="gold"}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.GarrisonMonumentFrame, "OnShow", function(this)
		this.Background:SetTexture(nil)
		self:skinObject("frame", {obj=this, fType=ftype, cb=true, ofs=-10, y2=8})
		if self.modBtnBs then
			self:addButtonBorder{obj=this.LeftBtn, clr="gold"}
			self:addButtonBorder{obj=this.RightBtn, clr="gold"}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.GarrisonRecruiterFrame, "OnShow", function(this)
		this.Pick.Line1:SetTexture(nil)
		this.Pick.Line2:SetTexture(nil)
		self:skinObject("dropdown", {obj=this.Pick.ThreatDropDown, fType=ftype})
		self:removeMagicBtnTex(this.Pick.ChooseRecruits)
		self:removeMagicBtnTex(this.Random.ChooseRecruits)
		self:removeMagicBtnTex(self:getChild(this.UnavailableFrame, 1))
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true, ofs=1, y1=2})
		if self.modBtns then
			self:skinStdButton{obj=this.Pick.ChooseRecruits}
			self:skinStdButton{obj=this.Random.ChooseRecruits}
			self:skinStdButton{obj=self:getChild(this.UnavailableFrame, 1)}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.GarrisonRecruitSelectFrame, "OnShow", function(this)
		skinFollowerList(this.FollowerList, "grey")
		for i = 1, 3 do
			self:nilTexture(this.FollowerSelection["Recruit" .. i].PortraitFrame.PortraitRing, true)
			self:nilTexture(this.FollowerSelection["Recruit" .. i].PortraitFrame.LevelBorder, true)
			this.FollowerSelection["Recruit" .. i].PortraitFrame.PortraitRingQuality:SetVertexColor(this.FollowerSelection["Recruit" .. i].PortraitFrame.LevelBorder:GetVertexColor())
			self:removeMagicBtnTex(this.FollowerSelection["Recruit" .. i].HireRecruits)
			if self.modBtns then
				self:skinStdButton{obj=this.FollowerSelection["Recruit" .. i].HireRecruits}
			end
		end
		self:skinObject("frame", {obj=this.FollowerSelection, fType=ftype, kfs=true, fb=true, y2=0})
		this.GarrCorners:DisableDrawLayer("BACKGROUND")
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cbns=true, ofs=2})

		self:Unhook(this, "OnShow")
	end)

	-- Legion
	self:SecureHookScript(_G.OrderHallMissionFrame, "OnShow", function(this)
		skinMissionFrame(this)
		this.ClassHallIcon:DisableDrawLayer("OVERLAY") -- this hides the frame
		this.sf:SetFrameStrata("LOW") -- allow map textures to be visible

		self:SecureHookScript(this.FollowerList, "OnShow", function(fObj)
			skinFollowerList(fObj)

			self:Unhook(fObj, "OnShow")
		end)

		self:SecureHookScript(this.MissionTab, "OnShow", function(fObj)
			skinMissionList(fObj.MissionList)
			-- this.MissionList.CombatAllyUI.Background:SetTexture(nil)
			fObj.MissionList.CombatAllyUI.Available.AddFollowerButton.EmptyPortrait:SetTexture(nil)
			skinPortrait(fObj.MissionList.CombatAllyUI.InProgress.PortraitFrame)
			self:skinObject("frame", {obj=fObj.MissionList.CombatAllyUI, fType=ftype, kfs=true, fb=true})
			if self.modBtns then
				self:skinStdButton{obj=fObj.MissionList.CombatAllyUI.InProgress.Unassign}
			end
			-- ZoneSupportMissionPage (a.k.a. Combat Ally selection page)
			fObj.ZoneSupportMissionPageBackground:DisableDrawLayer("BACKGROUND")
			fObj.ZoneSupportMissionPage:DisableDrawLayer("BACKGROUND")
			fObj.ZoneSupportMissionPage:DisableDrawLayer("BORDER")
			fObj.ZoneSupportMissionPage.CombatAllyLabel.TextBackground:SetTexture(nil)
			fObj.ZoneSupportMissionPage.ButtonFrame:SetTexture(nil)
			fObj.ZoneSupportMissionPage.Follower1:DisableDrawLayer("BACKGROUND")
			skinPortrait(fObj.ZoneSupportMissionPage.Follower1.PortraitFrame)
			self:skinObject("frame", {obj=fObj.ZoneSupportMissionPage, fType=ftype, cbns=true, fb=true})
			fObj.ZoneSupportMissionPage.CloseButton:SetSize(28, 28)
			if self.modBtns then
				self:moveObject{obj=fObj.ZoneSupportMissionPage.StartMissionButton.Flash, x=-0.5, y=1.5}
				self:skinStdButton{obj=fObj.ZoneSupportMissionPage.StartMissionButton}
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=fObj.ZoneSupportMissionPage.CombatAllySpell, clr="grey", ca=1}
			end
			skinMissionPage(fObj.MissionPage)

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.MissionTab)

		self:SecureHookScript(this.FollowerTab, "OnShow", function(fObj)
			skinFollowerPage(fObj)
			self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, fb=true})

			self:Unhook(fObj, "OnShow")
		end)

		self:SecureHookScript(this.MissionComplete, "OnShow", function(fObj)
			skinMissionComplete(fObj)

			self:Unhook(fObj, "OnShow")
		end)

		self:Unhook(this, "OnShow")
	end)

	if _G.OrderHallMissionTutorialFrame then
		self:SecureHookScript(_G.OrderHallMissionTutorialFrame, "OnShow", function(this)
			self:skinGlowBox(this.GlowBox, ftype)

			self:Unhook(this, "OnShow")
		end)
	end

	-- Battle for Azeroth
	self:SecureHookScript(_G.BFAMissionFrame, "OnShow", function(this)
		this.OverlayElements.Topper:SetTexture(nil)
		this.OverlayElements.CloseButtonBorder:SetTexture(nil)
		this.TitleScroll:DisableDrawLayer("ARTWORK")
		this.TitleText:SetTextColor(self.HT:GetRGB())
		skinMissionFrame(this)
		this.sf:SetFrameStrata("LOW") -- allow map textures to be visible
		self:SecureHookScript(this.FollowerList, "OnShow", function(fObj)
			skinFollowerList(fObj)

			self:Unhook(fObj, "OnShow")
		end)
		this.MapTab.ScrollContainer.Child.TiledBackground:SetTexture(nil)
		self:SecureHookScript(this.MissionTab.MissionList, "OnShow", function(fObj)
			skinMissionList(fObj, -2)

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.MissionTab.MissionList)
		self:SecureHookScript(this.MissionTab.MissionPage, "OnShow", function(fObj)
			skinMissionPage(fObj)

			self:Unhook(fObj, "OnShow")
		end)
		self:SecureHookScript(this.FollowerTab, "OnShow", function(fObj)
			skinFollowerPage(fObj)
			self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, fb=true})

			self:Unhook(fObj, "OnShow")
		end)
		-- MissionComplete
		self:SecureHookScript(this.MissionComplete, "OnShow", function(fObj)
			skinMissionComplete(fObj)

			self:Unhook(fObj, "OnShow")
		end)

		self:Unhook(this, "OnShow")
	end)

	-- Shadowlandds
	local function skinCovenantMissionFrame(frame)
		local function skinPuck(btn)
			aObj:nilTexture(btn.PuckShadow, true)
			aObj:nilTexture(btn.PuckBorder, true)
			for _, aBtn in _G.pairs(btn.AbilityButtons) do
				aBtn.Border:SetTexture(nil)
			end
			aObj:changeTex2SB(btn.HealthBar.Health)
			btn.HealthBar.Border:SetTexture(nil)
		end
		local function skinBoard(bFrame)
			for btn in bFrame.enemyFramePool:EnumerateActive() do
				skinPuck(btn)
			end
			for btn in bFrame.followerFramePool:EnumerateActive() do
				skinPuck(btn)
			end
			for btn in bFrame.enemySocketFramePool:EnumerateActive() do
				aObj:skinObject("frame", {obj=btn, fType=ftype, kfs=true, fb=true, ofs=2, clr="grey"})
			end
			for btn in bFrame.followerSocketFramePool:EnumerateActive() do
				aObj:skinObject("frame", {obj=btn, fType=ftype, kfs=true, fb=true, ofs=2, clr="grey"})
			end
		end
		frame.OverlayElements.CloseButtonBorder:SetTexture(nil)
		aObj:keepFontStrings(frame.RaisedBorder)
		skinMissionFrame(frame)
		aObj:clrBBC(frame.sf, "sepia")
		frame.sf:SetFrameStrata("LOW") -- allow map textures to be visible
		aObj:SecureHookScript(frame.FollowerList, "OnShow", function(this)
			skinFollowerList(this, "sepia")
			if aObj.modBtns then
				aObj:skinStdButton{obj=this.HealAllButton}
				aObj:SecureHook(this, "CalculateHealAllFollowersCost", function(fObj)
					aObj:clrBtnBdr(fObj.HealAllButton)
				end)
			end

			aObj:Unhook(this, "OnShow")
		end)
		aObj:SecureHookScript(frame.MissionTab, "OnShow", function(this)
			skinMissionList(this.MissionList)
			aObj:skinObject("slider", {obj=this.MissionList.listScroll.scrollBar, fType=ftype, y1=5, y2=-10})
			aObj:clrBBC(this.MissionList.sf, "grey")
			-- ZoneSupportMissionPage
			skinMissionPage(this.MissionPage)
			aObj:skinObject("frame", {obj=this.MissionPage.StartMissionFrame, fType=ftype, kfs=true, ng=true, clr="grey", x1=40, y1=-8, x2=-30, y2=10})
			aObj:clrBBC(this.MissionPage.sf, "grey")
			skinBoard(this.MissionPage.Board)

			aObj:Unhook(this, "OnShow")
		end)
		aObj:checkShown(frame.MissionTab)
		aObj:SecureHookScript(frame.FollowerTab, "OnShow", function(this)
			this.RaisedFrameEdges:DisableDrawLayer("BORDER")
			this.HealFollowerFrame.ButtonFrame:SetTexture(nil)
			aObj:skinObject("frame", {obj=this, fType=ftype, kfs=true, fb=true, clr="grey", y2=0})
			aObj:skinObject("frame", {obj=this.HealFollowerFrame, fType=ftype, kfs=true, ng=true, clr="grey", x1=140, y1=-517, x2=-130, y2=-12})
			if aObj.modBtns then
				aObj:skinStdButton{obj=this.HealFollowerFrame.HealFollowerButton}
				aObj:SecureHook(this, "UpdateHealCost", function(fObj)
					aObj:clrBtnBdr(fObj.HealFollowerFrame.HealFollowerButton)
				end)
			end
			if aObj.modBtnBs then
				local function skinAutospell()
					for btn in this.autoSpellPool:EnumerateActive() do
						btn.Border:SetTexture(nil)
						btn.SpellBorder:SetTexture(nil)
						aObj:addButtonBorder{obj=btn, relTo=btn.Icon}
					end
				end
				aObj:SecureHook(this, "UpdateAutoSpellAbilities", function(_, _)
					skinAutospell()
				end)
				skinAutospell()
			end

			aObj:Unhook(this, "OnShow")
		end)
		-- MissionComplete
		aObj:adjWidth(frame.MissionCompleteBackground, -3)
		local function skinFollowers(flwFrame)
			for btn in flwFrame.followerPool:EnumerateActive() do
				btn.RewardsFollower.PuckBorder:SetTexture(nil)
				aObj:changeTandC(btn.RewardsFollower.LevelDisplayFrame.LevelCircle)
			end
		end
		aObj:SecureHookScript(frame.MissionComplete, "OnShow", function(this)
			this:DisableDrawLayer("OVERLAY")
			aObj:removeNineSlice(this.NineSlice)
			this.RewardsScreen.CombatCompleteSuccessFrame.CombatCompleteLineTop:SetTexture(nil)
			this.RewardsScreen.CombatCompleteSuccessFrame.CombatCompleteLineBottom:SetTexture(nil)
			aObj:keepFontStrings(this.RewardsScreen.FinalRewardsPanel)
			-- hook this to skin followers
			aObj:SecureHook(this.RewardsScreen, "PopulateFollowerInfo", function(fObj, _)
				skinFollowers(fObj)
			end)
			-- skin any existing ones
			skinFollowers(this.RewardsScreen)
			if aObj.modBtns then
				aObj:skinStdButton{obj=this.RewardsScreen.FinalRewardsPanel.ContinueButton}
			end
			if aObj.modBtnBs then
				aObj:SecureHook(this.RewardsScreen, "SetRewards", function(fObj, _, victoryState)
					if victoryState then
						for btn in fObj.rewardsPool:EnumerateActive() do
							aObj:addButtonBorder{obj=btn, relTo=btn.Icon, reParent={btn.Quantity}}
						end
					end
				end)
			end
			-- CombatLog (LHS)
			this.AdventuresCombatLog.ElevatedFrame:DisableDrawLayer("OVERLAY")
			aObj:skinObject("slider", {obj=this.AdventuresCombatLog.CombatLogMessageFrame.ScrollBar, fType=ftype, y1=8, y2=-10})
			aObj:skinObject("frame", {obj=this.AdventuresCombatLog, fType=ftype, kfs=true, fb=true, clr="sepia", x2=10})
			-- MissionInfo (RHS)
			this.MissionInfo.Header:SetTexture(nil)
			aObj:nilTexture(this.MissionInfo.IconBG, true)
			aObj:skinObject("frame", {obj=this.MissionInfo, fType=ftype, kfs=true, fb=true, clr="grey", ofs=4, y2=-303})
			skinBoard(this.Board)
			aObj:skinObject("frame", {obj=this.CompleteFrame, fType=ftype, kfs=true, ng=true, clr="grey", x1=40, y1=-8, x2=-40, y2=10})
			if aObj.modBtns then
				aObj:skinStdButton{obj=this.CompleteFrame.ContinueButton}
				aObj:skinStdButton{obj=this.CompleteFrame.SpeedButton}
				aObj:SecureHook(this, "DisableCompleteFrameButtons", function(fObj)
					aObj:clrBtnBdr(fObj.CompleteFrame.ContinueButton)
					aObj:clrBtnBdr(fObj.CompleteFrame.SpeedButton)
				end)
				aObj:SecureHook(this, "EnableCompleteFrameButtons", function(fObj)
					aObj:clrBtnBdr(fObj.CompleteFrame.ContinueButton)
					aObj:clrBtnBdr(fObj.CompleteFrame.SpeedButton)
				end)
			end

			aObj:Unhook(this, "OnShow")
		end)
		-- Follower as mouse pointer when dragging
		aObj:SecureHook(frame, "GetPlacerFrame", function(this)
			aObj:nilTexture(_G.CovenantFollowerPlacer.PuckShadow, true)
			aObj:nilTexture(_G.CovenantFollowerPlacer.PuckBorder, true)
			for _, btn in _G.pairs(_G.CovenantFollowerPlacer.AbilityButtons) do
				btn.Border:SetTexture(nil)
			end
			self:changeTex2SB(_G.CovenantFollowerPlacer.HealthBar.Health)
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
			-- let other addons know when frame skinned (e.g. VenturePlan)
			self:SendMessage("CovenantMissionFrame_Skinned")
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
		self:skinObject("editbox", {obj=_G.GuildItemSearchBox, fType=ftype})
		_G.GuildBankMoneyFrameBackground:DisableDrawLayer("BACKGROUND")
		self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true, offsets={x1=9, y1=self.isTT and 2 or -3, x2=-9, y2=2}})
		-- Tabs (side)
		for i = 1, _G.MAX_GUILDBANK_TABS do
			_G["GuildBankTab" .. i]:DisableDrawLayer("BACKGROUND")
			if self.modBtnBs then
				 self:addButtonBorder{obj=_G["GuildBankTab" .. i .. "Button"], relTo=_G["GuildBankTab" .. i .. "ButtonIconTexture"], y2=-3}
			end
		end
		self:skinObject("slider", {obj=_G.GuildBankTransactionsScrollFrame.ScrollBar, fType=ftype, rpTex="artwork"})
		self:skinObject("slider", {obj=_G.GuildBankInfoScrollFrame.ScrollBar, fType=ftype, rpTex="artwork"})
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, hdr=true, cb=true})
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
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, hdr=true, ri=true, rns=true, cb=true, x1=self.isClsc and 0, x2=self.isClsc and 1 or 3})

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
			self:SecureHookScript(this.CommentFrame.EditBox, "OnTextChanged", function(ebObj)
				self:clrBtnBdr(ebObj:GetParent():GetParent().reportButton)
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
	self:SecureHook(_G.HelpTip, "Show", function(_, _)
		skinHelpTips()
	end)

end

-- These functions are used by the InterfaceOptions & SystemOptions functions
local checkChild, skinKids, cName
function checkChild(child, frameType)
	cName = child:GetName()
	if aObj:isDropDown(child) then
		aObj:skinObject("dropdown", {obj=child, fType=frameType, x2=aObj.iofDD[cName]})
	elseif child:IsObjectType("Slider") then
		aObj:skinObject("slider", {obj=child, fType=frameType})
	elseif child:IsObjectType("CheckButton")
	and aObj.modChkBtns
	then
		aObj:skinCheckButton{obj=child, fType=frameType, hf=true} -- handle hide/show
	elseif child:IsObjectType("EditBox") then
		aObj:skinObject("editbox", {obj=child, fType=frameType})
	elseif child:IsObjectType("Button")
	and aObj.modBtns
	and not aObj.iofBtn[child]
	then
		aObj:skinStdButton{obj=child, fType=ftype}
	end
end
function skinKids(obj, frameType)
	-- wait for all objects to be created
	_G.C_Timer.After(0.1, function()
		for _, child in _G.ipairs{obj:GetChildren()} do
			checkChild(child, frameType)
		end
	end)
end
aObj.blizzFrames[ftype].InterfaceOptions = function(self)
	if not self.prdb.InterfaceOptions or self.initialized.InterfaceOptions then return end
	self.initialized.InterfaceOptions = true

	-- Interface
	self:SecureHookScript(_G.InterfaceOptionsFrame, "OnShow", function(this)
		if self.isRtl then
			self:removeNineSlice(this.Border)
		end
		self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true, upwards=true, offsets={x1=9, y1=self.isTT and 0 or -4, x2=-9, y2=self.isTT and -5 or 0}})
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, hdr=true})
		if self.modBtns then
			self:skinStdButton{obj=_G.InterfaceOptionsFrameCancel, fType=ftype}
			self:skinStdButton{obj=_G.InterfaceOptionsFrameOkay, fType=ftype}
			self:skinStdButton{obj=_G.InterfaceOptionsFrameDefaults, fType=ftype}
		end
		-- LHS panel (Game Tab)
		self:SecureHookScript(_G.InterfaceOptionsFrameCategories, "OnShow", function(fObj)
			self:skinObject("slider", {obj=_G.InterfaceOptionsFrameCategoriesListScrollBar, fType=ftype, x1=4, x2=-5})
			self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, rns=true, fb=true, ofs=-1})

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(_G.InterfaceOptionsFrameCategories)
		-- LHS panel (AddOns tab)
		self:SecureHookScript(_G.InterfaceOptionsFrameAddOns, "OnShow", function(fObj)
			self:skinObject("slider", {obj=_G.InterfaceOptionsFrameAddOnsListScrollBar, fType=ftype, x1=4, x2=-5})
			self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, rns=true, fb=true, ofs=-1})
			if self.modBtns then
				-- skin toggle buttons
				for _, btn in _G.pairs(_G.InterfaceOptionsFrameAddOns.buttons) do
					self:skinExpandButton{obj=btn.toggle, fType=ftype, onSB=true, noHook=true}
					self:checkTex{obj=btn.toggle}
				end
				self:SecureHook("InterfaceAddOnsList_Update", function()
					for _, btn in _G.pairs(_G.InterfaceOptionsFrameAddOns.buttons) do
						self:checkTex{obj=btn.toggle}
					end
				end)
			end

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(_G.InterfaceOptionsFrameAddOns)
		-- RHS Panel
		self:skinObject("frame", {obj=_G.InterfaceOptionsFramePanelContainer, fType=ftype, kfs=true, rns=true, fb=true, ofs=-1, y2=0})
		-- Social Browser Frame (Twitter integration)
		self:SecureHookScript(_G.SocialBrowserFrame, "OnShow", function(fObj)
			self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, cb=true, x2=1})

			self:Unhook(fObj, "OnShow")
		end)
		if self.modBtns then
			self:SecureHook(_G.InterfaceOptionsSocialPanel.EnableTwitter, "setFunc", function(_)
				-- N.B. gets called when panel not skinned
				if _G.InterfaceOptionsSocialPanel.TwitterLoginButton.sb then
					self:clrBtnBdr(_G.InterfaceOptionsSocialPanel.TwitterLoginButton)
				end
			end)
		end

		self:Unhook(this, "OnShow")
	end)

	-- skin extra elements
	self.RegisterMessage("IONP", "IOFPanel_After_Skinning", function(_, panel)
		if panel ~= _G.InterfaceOptionsNamesPanel then return end
		skinKids(_G.InterfaceOptionsNamesPanelFriendly, ftype)
		skinKids(_G.InterfaceOptionsNamesPanelEnemy, ftype)
		skinKids(_G.InterfaceOptionsNamesPanelUnitNameplates, ftype)

		self.UnregisterMessage("IONP", "IOFPanel_After_Skinning")
	end)

	self.RegisterMessage("CUFP", "IOFPanel_After_Skinning", function(_, panel)
		if panel ~= _G.CompactUnitFrameProfiles then
			return
		end
		self:removeNineSlice(_G.CompactUnitFrameProfiles.newProfileDialog.Border)
		skinKids(_G.CompactUnitFrameProfiles.newProfileDialog, ftype)
		self:skinObject("frame", {obj=_G.CompactUnitFrameProfiles.newProfileDialog, fType=ftype, ofs=0})
		if self.modBtns then
			self:SecureHook("CompactUnitFrameProfiles_UpdateNewProfileCreateButton", function()
				self:clrBtnBdr(_G.CompactUnitFrameProfiles.newProfileDialog.createButton)
			end)
		end
		self:removeNineSlice(_G.CompactUnitFrameProfiles.deleteProfileDialog.Border)
		skinKids(_G.CompactUnitFrameProfiles.deleteProfileDialog, ftype)
		self:skinObject("frame", {obj=_G.CompactUnitFrameProfiles.deleteProfileDialog, fType=ftype, ofs=0})
		self:removeNineSlice(_G.CompactUnitFrameProfiles.unsavedProfileDialog.Border)
		skinKids(_G.CompactUnitFrameProfiles.unsavedProfileDialog, ftype)
		self:skinObject("frame", {obj=_G.CompactUnitFrameProfiles.unsavedProfileDialog, fType=ftype, ofs=0})
		skinKids(_G.CompactUnitFrameProfiles.optionsFrame, ftype)
		if self.modBtns then
			self:skinStdButton{obj=_G.CompactUnitFrameProfilesDeleteButton, fType=ftype}
			self:skinStdButton{obj=_G.CompactUnitFrameProfilesSaveButton, fType=ftype}
			self:SecureHook("CompactUnitFrameProfiles_UpdateManagementButtons", function()
				self:clrBtnBdr(_G.CompactUnitFrameProfilesDeleteButton)
				self:clrBtnBdr(_G.CompactUnitFrameProfilesSaveButton)
			end)
		end
		_G.CompactUnitFrameProfiles.optionsFrame.autoActivateBG:SetTexture(nil)

		self.UnregisterMessage("CUFP", "IOFPanel_After_Skinning")
	end)

	-- hook this to skin Interface Option panels
	self:SecureHook("InterfaceOptionsList_DisplayPanel", function(panel)

		-- let AddOn skins know when IOF panel is going to be skinned
		self:SendMessage("IOFPanel_Before_Skinning", panel)
		self.callbacks:Fire("IOFPanel_Before_Skinning", panel)

		-- don't skin a panel twice
		if not self.iofSkinnedPanels[panel] then
			skinKids(panel, panel.GetName and panel:GetName() and panel:GetName():find("InterfaceOptions") and ftype)
			self.iofSkinnedPanels[panel] = true
		end

		-- let AddOn skins know when IOF panel has been skinned
		self:SendMessage("IOFPanel_After_Skinning", panel)
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
	if self.modBtnBs then
		self:addButtonBorder{obj=WQ.QuestReward, relTo=WQ.QuestReward.Icon}
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

end

aObj.blizzFrames[ftype].ItemText = function(self)
	if not self.prdb.ItemText or self.initialized.ItemText then return end
	self.initialized.ItemText = true

	local function skinITFrame(frame)
		aObj:skinObject("slider", {obj=_G.ItemTextScrollFrame.ScrollBar, fType=ftype, rpTex=aObj.isClsc and {"background", "artwork"} or nil})
		aObj:skinStatusBar{obj=_G.ItemTextStatusBar, fi=0}
		aObj:moveObject{obj=_G.ItemTextPrevPageButton, x=-55}
		if not aObj.isClsc then
			aObj:skinObject("frame", {obj=frame, fType=ftype, kfs=true, ri=true, rns=true, cb=true, x2=3})
		else
			aObj:skinObject("frame", {obj=frame, fType=ftype, kfs=true, x1=10, y1=-12, x2=-31, y2=60})
			if aObj.modBtns then
				aObj:skinCloseButton{obj=_G.ItemTextCloseButton}
			end
		end
		if aObj.modBtnBs then
			-- N.B. page buttons are hidden or shown as required
			aObj:addButtonBorder{obj=_G.ItemTextPrevPageButton, ofs=-2, x1=1, clr="gold"}
			aObj:addButtonBorder{obj=_G.ItemTextNextPageButton, ofs=-2, x1=1, clr="gold"}
		end
	end
	self:SecureHookScript(_G.ItemTextFrame, "OnShow", function(this)
		_G.ItemTextPageText:SetTextColor(self.BT:GetRGB())
		_G.ItemTextPageText:SetTextColor("P", self.BT:GetRGB())
		_G.ItemTextPageText:SetTextColor("H1", self.HT:GetRGB())
		_G.ItemTextPageText:SetTextColor("H2", self.HT:GetRGB())
		_G.ItemTextPageText:SetTextColor("H3", self.HT:GetRGB())
		if skinITFrame then
			skinITFrame(this)
		end
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
			self:addButtonBorder{obj=_G.LFDQueueFrameRandomScrollFrameChildFrame.MoneyReward, libt=true}
		end
		if self.modBtns
		or self.modBtnBs
		then
			self:SecureHook("LFDQueueFrameRandom_UpdateFrame", function()
				if self.modBtns then
					self:clrBtnBdr(_G.LFDQueueFrameFindGroupButton)
				end
				if self.modBtnBs then
					for i = 1, 5 do
						if _G["LFDQueueFrameRandomScrollFrameChildFrameItem" .. i] then
							_G["LFDQueueFrameRandomScrollFrameChildFrameItem" .. i .. "NameFrame"]:SetTexture(nil)
							self:addButtonBorder{obj=_G["LFDQueueFrameRandomScrollFrameChildFrameItem" .. i], libt=true}
						end
					end
				end
			end)
		end

		-- Specific List subFrame
		for i = 1, _G.NUM_LFD_CHOICE_BUTTONS do
			if self.modBtns then
				self:skinExpandButton{obj=_G["LFDQueueFrameSpecificListButton" .. i].expandOrCollapseButton, sap=true}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=_G["LFDQueueFrameSpecificListButton" .. i].enableButton}
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
			self:skinOtherButton{obj=_G.LFGDungeonReadyStatusCloseButton, text=self.modUIBtns.minus}
			self:skinOtherButton{obj=_G.LFGDungeonReadyDialogCloseButton, text=self.modUIBtns.minus}
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
			self:SecureHook("LFGListCategorySelection_UpdateNavButtons", function(fObj)
				self:clrBtnBdr(fObj.StartGroupButton)
				self:clrBtnBdr(fObj.FindGroupButton)
			end)
		end
		self:SecureHook("LFGListCategorySelection_AddButton", function(fObj, _)
			for _, btn in _G.pairs(fObj.CategoryButtons) do
				btn.Cover:SetTexture(nil)
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
			for _, btn in _G.pairs(sp.ScrollFrame.buttons) do
				self:skinStdButton{obj=btn.CancelButton}
			end
			self:skinStdButton{obj=sp.ScrollFrame.ScrollChild.StartGroupButton}
			self:skinStdButton{obj=sp.BackButton}
			self:skinStdButton{obj=sp.SignUpButton}
			self:SecureHook("LFGListSearchPanel_UpdateButtonStatus", function(fObj)
				self:clrBtnBdr(fObj.ScrollFrame.ScrollChild.StartGroupButton)
				self:clrBtnBdr(fObj.SignUpButton)
			end)
		end
		if self.modBtnBs then
		    self:addButtonBorder{obj=sp.FilterButton, ofs=0}
			self:addButtonBorder{obj=sp.RefreshButton, ofs=-2}
		end

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
		if self.modBtns then
			for _, btn in _G.pairs(av.ScrollFrame.buttons) do
				self:skinStdButton{obj=btn.DeclineButton}
				self:skinStdButton{obj=btn.InviteButton}
			end
			self:skinStdButton{obj=av.RemoveEntryButton}
			self:skinStdButton{obj=av.EditButton}
		end
		if self.modBtnBs then
			 self:addButtonBorder{obj=av.RefreshButton, ofs=-2}
		end
		if self.modChkBtns then
			 self:skinCheckButton{obj=av.AutoAcceptButton}
		end

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
		self:skinEditBox{obj=ec.Name, regs={6}, mi=true} -- 6 is text
		self:skinDropDown{obj=ec.CategoryDropDown}
		self:skinDropDown{obj=ec.GroupDropDown}
		self:skinDropDown{obj=ec.ActivityDropDown}
		self:addFrameBorder{obj=ec.Description, ft=ftype, kfs=true, ofs=6}
		self:skinEditBox{obj=ec.ItemLevel.EditBox, regs={6}, mi=true} -- 6 is text
		self:skinEditBox{obj=ec.VoiceChat.EditBox, regs={6}, mi=true} -- 6 is text
		self:removeMagicBtnTex(ec.ListGroupButton)
		self:removeMagicBtnTex(ec.CancelButton)
		if self.modBtns then
			self:skinStdButton{obj=ec.ListGroupButton}
			self:skinStdButton{obj=ec.CancelButton}
			self:SecureHook("LFGListEntryCreation_UpdateValidState", function(fObj)
				self:clrBtnBdr(fObj.ListGroupButton)
			end)
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=ec.ItemLevel.CheckButton}
			self:skinCheckButton{obj=ec.HonorLevel.CheckButton}
			self:skinCheckButton{obj=ec.VoiceChat.CheckButton}
			self:skinCheckButton{obj=ec.PrivateGroup.CheckButton}
		end

		self:Unhook(this, "OnShow")
	end)

	-- LFGListApplication Dialog
	self:SecureHookScript(_G.LFGListApplicationDialog, "OnShow", function(this)
		self:removeNineSlice(this.Border)
		self:skinObject("slider", {obj=this.Description.ScrollBar, fType=ftype})
		self:skinObject("frame", {obj=this.Description, fType=ftype, kfs=true, fb=true, ofs=6})
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true})
		if self.modBtns then
			self:skinStdButton{obj=this.SignUpButton, fType=ftype}
			self:skinStdButton{obj=this.CancelButton, fType=ftype}
			self:SecureHook("LFGListApplicationDialog_UpdateValidState", function(fObj)
				self:clrBtnBdr(fObj.SignUpButton)
			end)
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=this.HealerButton.CheckButton, fType=ftype}
			self:skinCheckButton{obj=this.TankButton.CheckButton, fType=ftype}
			self:skinCheckButton{obj=this.DamagerButton.CheckButton, fType=ftype}
		end

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
		self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true, upwards=true, offsets={x1=1, y1=-6, x2=-1, y2=self.isTT and -2 or 3}, func=function(tab) tab:SetFrameLevel(20) end})
		self:skinObject("frame", {obj=_G.MacroButtonScrollFrame, fType=ftype, kfs=true, fb=true, ofs=12, y1=10, x2=31})
		self:skinObject("slider", {obj=_G.MacroButtonScrollFrame.ScrollBar, fType=ftype, rpTex="artwork"})
		self:skinObject("slider", {obj=_G.MacroFrameScrollFrame.ScrollBar, fType=ftype})
		self:skinObject("frame", {obj=_G.MacroFrameTextBackground, fType=ftype, kfs=true, rns=true, fb=true, ofs=0, x2=1})
		_G.MacroFrameSelectedMacroButton:DisableDrawLayer("BACKGROUND")
		for i = 1, _G.MAX_ACCOUNT_MACROS do
			_G["MacroButton" .. i]:DisableDrawLayer("BACKGROUND")
			if self.modBtnBs then
				self:addButtonBorder{obj=_G["MacroButton" .. i], relTo=_G["MacroButton" .. i .. "Icon"], reParent={_G["MacroButton" .. i .. "Name"]}, clr="grey", ca=0.85}
			end
		end
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, hdr=true, ri=true, rns=true, cb=true})
		if self.modBtns then
			self:skinStdButton{obj=_G.MacroEditButton}
			self:skinStdButton{obj=_G.MacroCancelButton}
			self:skinStdButton{obj=_G.MacroSaveButton}
			self:skinStdButton{obj=_G.MacroDeleteButton}
			self:skinStdButton{obj=_G.MacroNewButton, x2=-2}
			self:skinStdButton{obj=_G.MacroExitButton, x1=2}
			for _, btn in _G.pairs{_G.MacroEditButton, _G.MacroDeleteButton, _G.MacroNewButton} do
				self:SecureHook(btn, "Disable", function(bObj, _)
					self:clrBtnBdr(bObj)
				end)
				self:SecureHook(btn, "Enable", function(bObj, _)
					self:clrBtnBdr(bObj)
				end)
			end
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.MacroFrameSelectedMacroButton, relTo=_G.MacroFrameSelectedMacroButtonIcon, clr="grey", ca=0.85}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.MacroPopupFrame, "OnShow", function(this)
		self:adjHeight{obj=this, adj=20} -- so buttons don't overlay icons
		self:removeRegions(this.BorderBox, {1, 2, 3, 4, 5, 6, 7, 8})
		self:skinObject("editbox", {obj=_G.MacroPopupEditBox, fType=ftype})
		self:adjHeight{obj=_G.MacroPopupScrollFrame, adj=20} -- stretch to bottom of scroll area
		self:skinObject("slider", {obj=_G.MacroPopupScrollFrame.ScrollBar, fType=ftype, rpTex="background"})
		if self.isClscBC then
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, x2=-2, y2=4})
		else
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ofs=2, y2=4})
		end
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
		self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, offsets={x1=7, y1=self.isTT and 2 or -3, x2=-7, y2=2}})
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true, x2=self.isClsc and 1}
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
			self:SecureHook("InboxFrame_Update", function(_)
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
			self:SecureHook(_G.SendMailMailButton, "Disable", function(bObj, _)
				self:clrBtnBdr(bObj)
			end)
			self:SecureHook(_G.SendMailMailButton, "Enable", function(bObj, _)
				self:clrBtnBdr(bObj)
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
		self:keepFontStrings(_G.StanceBarFrame)
		self:keepFontStrings(_G.PetActionBarFrame)
		if not self.isClsc then
			_G.MainMenuBarArtFrame.LeftEndCap:SetTexture(nil)
			_G.MainMenuBarArtFrame.RightEndCap:SetTexture(nil)
			_G.MicroButtonAndBagsBar:DisableDrawLayer("BACKGROUND")
			_G.MainMenuBarArtFrameBackground:DisableDrawLayer("BACKGROUND")
			_G.StatusTrackingBarManager:DisableDrawLayer("OVERLAY") -- status bar textures
			for _, bar in _G.pairs(_G.StatusTrackingBarManager.bars) do
				self:skinObject("statusbar", {obj=bar.StatusBar, bg=bar.StatusBar.Background, other={bar.ExhaustionLevelFillBar}})
				if bar.ExhaustionTick then -- HonorStatusBar & ExpStatusBar
					bar.ExhaustionTick:GetNormalTexture():SetTexture(nil)
					bar.ExhaustionTick:GetHighlightTexture():SetTexture(nil)
				elseif bar.Tick then -- ArtifactStatusBar
					bar.Tick:GetNormalTexture():SetTexture(nil)
					bar.Tick:GetHighlightTexture():SetTexture(nil)
				end
			end
			self:keepFontStrings(_G.PossessBarFrame)
			self:keepFontStrings(_G.MultiCastFlyoutFrame) -- Shaman's Totem Frame
		else
			_G.MainMenuBarArtFrame:DisableDrawLayer("BACKGROUND")
			_G.MainMenuBarLeftEndCap:SetTexture(nil)
			_G.MainMenuBarRightEndCap:SetTexture(nil)
			_G.MainMenuExpBar:DisableDrawLayer("OVERLAY")
			_G.MainMenuExpBar:SetSize(1011, 13)
			self:moveObject{obj=_G.MainMenuExpBar, x=1, y=2}
			self:skinObject("statusbar", {obj=_G.MainMenuExpBar, bg=self:getRegion(_G.MainMenuExpBar, 6), other={_G.ExhaustionLevelFillBar}})
			_G.MainMenuBarMaxLevelBar:DisableDrawLayer("BACKGROUND")
			_G.ExhaustionTick:GetNormalTexture():SetTexture(nil)
			_G.ExhaustionTick:GetHighlightTexture():SetTexture(nil)
			_G.ReputationWatchBar.StatusBar:DisableDrawLayer("ARTWORK")
			self:skinObject("statusbar", {obj=_G.ReputationWatchBar.StatusBar, bg=_G.ReputationWatchBar.StatusBar.Background})
		end
		if self.modBtnBs then
			for _, btn in _G.pairs(_G.StanceBarFrame.StanceButtons) do
				self:addButtonBorder{obj=btn, abt=true, sec=true} -- N.B. uses SecureFrameTemplate
			end
			for i = 1, _G.NUM_PET_ACTION_SLOTS do
				self:addButtonBorder{obj=_G["PetActionButton" .. i], abt=true, sec=true, reParent={_G["PetActionButton" .. i .. "AutoCastable"], _G["PetActionButton" .. i .. "SpellHighlightTexture"]}, ofs=3}
				_G["PetActionButton" .. i .. "Shine"]:SetParent(_G["PetActionButton" .. i].sbb)
			end
			for i = 1, _G.NUM_ACTIONBAR_BUTTONS do
				_G["ActionButton" .. i].FlyoutBorder:SetTexture(nil)
				_G["ActionButton" .. i].FlyoutBorderShadow:SetTexture(nil)
				self:addButtonBorder{obj=_G["ActionButton" .. i], abt=true, sabt=true, ofs=3}
			end
			self:addButtonBorder{obj=_G.ActionBarUpButton, ofs=self.isClsc and -4, clr="gold"}
			self:addButtonBorder{obj=_G.ActionBarDownButton, ofs=self.isClsc and -4, clr="gold"}
			for _, bName in _G.ipairs(_G.MICRO_BUTTONS) do
				self:addButtonBorder{obj=_G[bName], es=24, ofs=2, y1=self.isClsc and -18, reParent=_G[bName] == "MainMenuMicroButton" and {_G[bName].Flash, _G.MainMenuBarDownload, not self.isClsc and _G.MainMenuBarPerformanceBar} or {_G[bName].Flash}, clr="grey"}
			end
			self:addButtonBorder{obj=_G.MainMenuBarBackpackButton, ibt=true, ofs=3}
			self:addButtonBorder{obj=_G.CharacterBag0Slot, ibt=true, ofs=3}
			self:addButtonBorder{obj=_G.CharacterBag1Slot, ibt=true, ofs=3}
			self:addButtonBorder{obj=_G.CharacterBag2Slot, ibt=true, ofs=3}
			self:addButtonBorder{obj=_G.CharacterBag3Slot, ibt=true, ofs=3}
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
					self:addButtonBorder{obj=btn, abt=true, sabt=true, ofs=3}
				end
			end
			if not self.isClsc then
				for i = 1, _G.NUM_POSSESS_SLOTS do
					self:addButtonBorder{obj=_G["PossessButton" .. i], abt=true, sec=true} -- N.B. uses SecureFrameTemplate
				end
				self:addButtonBorder{obj=_G.MultiCastSummonSpellButton, abt=true, sabt=true, ofs=5}
				self:addButtonBorder{obj=_G.MultiCastRecallSpellButton, abt=true, sabt=true, ofs=5}
				for i = 1, _G.NUM_MULTI_CAST_PAGES * _G.NUM_MULTI_CAST_BUTTONS_PER_PAGE do
					self:addButtonBorder{obj=_G["MultiCastActionButton" .. i], abt=true, sabt=true, ofs=5}
				end
			else
				self:addButtonBorder{obj=_G.KeyRingButton, ofs=2, clr="grey"}
			end
		end
	end

	-- these are done here as other AddOns may require them to be skinned
	if self.modBtnBs then
		self:addButtonBorder{obj=_G.MainMenuBarVehicleLeaveButton, clr="grey"}
	end

	if not self.isClsc then
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

end

aObj.blizzFrames[ftype].MenuFrames = function(self)
	if not self.prdb.MenuFrames or self.initialized.MenuFrames then return end
	self.initialized.MenuFrames = true

	self:SecureHookScript(_G.GameMenuFrame, "OnShow", function(this)
		if not self.isClsc then
			self:removeNineSlice(this.Border)
		end
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, hdr=true, ofs=0})
		if self.modBtns then
			for _, child in _G.ipairs{this:GetChildren()} do
				if child:IsObjectType("Button") then
					self:skinStdButton{obj=child, ofs=0}
				end
			end
		end

		self:Unhook(this, "OnShow")
	end)

	-- Rating Menu
	self:SecureHookScript(_G.RatingMenuFrame, "OnShow", function(this)
		if not self.isClsc then
			self:removeNineSlice(this.Border)
		end
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, hdr=true, ofs=0})
		if self.modBtns then
			self:skinStdButton{obj=_G.RatingMenuButtonOkay}
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].Minimap = function(self)
	if not self.prdb.Minimap.skin or self.initialized.Minimap then return end
	self.initialized.Minimap = true

	if _G.IsAddOnLoaded("SexyMap")
	or _G.IsAddOnLoaded("BasicMinimap")
	then
		self.blizzFrames[ftype].Minimap = nil
		return
	end

	-- fix for Titan Panel moving MinimapCluster
	if _G.IsAddOnLoaded("Titan") then
		_G.TitanMovable_AddonAdjust("MinimapCluster", true)
	end

	-- Cluster Frame
	_G.MinimapBorderTop:Hide()
	_G.MinimapZoneTextButton:ClearAllPoints()
	_G.MinimapZoneTextButton:SetPoint("BOTTOMLEFT", _G.Minimap, "TOPLEFT", 0, 5)
	_G.MinimapZoneTextButton:SetPoint("BOTTOMRIGHT", _G.Minimap, "TOPRIGHT", 0, 5)
	_G.MinimapZoneText:ClearAllPoints()
	_G.MinimapZoneText:SetPoint("CENTER")
	self:skinObject("button", {obj=_G.MinimapZoneTextButton, fType=ftype, x1=-5, x2=5})

	-- Minimap
	_G.Minimap:SetMaskTexture([[Interface\Buttons\WHITE8X8]]) -- N.B. use name NOT FileDataID, otherwise it appears as a green overlay
	-- use a backdrop with no Texture otherwise the map tiles are obscured
	self:skinObject("frame", {obj=_G.Minimap, fType=ftype, bd=8, ofs=5})
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
		end)
		self:moveObject{obj=_G.MiniMapInstanceDifficulty, x=6, y=-4}
		_G.GuildInstanceDifficultyHanger:SetAlpha(0)
		self:moveObject{obj=_G.GuildInstanceDifficulty, x=7}
		self:getRegion(_G.MiniMapChallengeMode, 1):SetTexCoord(0, 1, 0.27, 1.27) -- remove top hanger texture
		self:moveObject{obj=_G.MiniMapChallengeMode, x=6, y=-12}
	else
		if self.modBtns then
			_G.RaiseFrameLevelByTwo(_G.MinimapToggleButton)
			self:moveObject{obj=_G.MinimapToggleButton, x=-8, y=1}
			self:skinCloseButton{obj=_G.MinimapToggleButton, noSkin=true}
		end
	end

	self:keepFontStrings(_G.MinimapBackdrop)
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

	local ignBtn = {
		["GameTimeFrame"]                    = true,
		["GarrisonLandingPageMinimapButton"] = true,
		["MiniMapTracking"]                  = true,
		["MiniMapWorldMapButton"]            = true,
		["MinimapZoomIn"]                    = true,
		["MinimapZoomOut"]                   = true,
		["QueueStatusMinimapButton"]         = true,
		["OQ_MinimapButton"]                 = true,
	}
	local minBtn = self.prdb.MinimapButtons.style

	local function mmKids(mmObj)
		local objName, objType
		for _, obj in _G.ipairs{mmObj:GetChildren()} do
			objName, objType = obj:GetName(), obj:GetObjectType()
			if not ignBtn[obj]
			and obj ~= obj:GetParent().sf -- skinFrame
			and obj ~= obj:GetParent().sb -- skinButton
			and not obj.point -- TomTom waypoint
			and not obj.texture -- HandyNotes pin
			and objType == "Button"
			or (objType == "Frame" and objName == "MiniMapMailFrame")
			and not aObj:hasTextInName(objName, "SexyMap")
			then
				for _, reg in _G.ipairs{obj:GetRegions()} do
					if reg:GetObjectType() == "Texture" then
						-- change the DrawLayer to make the Icon show if required
						if aObj:hasTextInName(reg, "[Ii]con")
						or aObj:hasTextInTexture(reg, "[Ii]con")
						then
							if reg:GetDrawLayer() == "BACKGROUND" then
								reg:SetDrawLayer("ARTWORK")
							end
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
						aObj:skinObject("button", {obj=obj, fType=ftype})
					else
						aObj:skinObject("frame", {obj=obj, fType=ftype})
					end
				end
			end
		end
	end
	local function makeBtnSquare(obj, x1, y1, x2, y2)
		obj:SetSize(26, 26)
		obj:GetNormalTexture():SetTexCoord(x1, y1, x2, y2)
		obj:GetPushedTexture():SetTexCoord(x1, y1, x2, y2)
		obj:SetHighlightTexture(aObj.tFDIDs.bHLS)
		obj:SetHitRectInsets(-5, -5, -5, -5)
		if not minBtn then
			aObj:skinObject("button", {obj=obj, fType=ftype, ng=true, bd=obj==_G.GameTimeFrame and 10 or 1, ofs=4})
		end
	end

	if not self.isClsc then
		-- Calendar button
		makeBtnSquare(_G.GameTimeFrame, 0.1, 0.31, 0.16, 0.6)
		-- MinimapBackdrop
		_G.MiniMapTrackingBackground:SetTexture(nil)
		_G.MiniMapTrackingButtonBorder:SetTexture(nil)
		if not minBtn then
			_G.MiniMapTracking:SetScale(0.9)
			self:skinObject("frame", {obj=_G.MiniMapTracking, fType=ftype})
		end
		_G.QueueStatusMinimapButtonBorder:SetTexture(nil)
		self:moveObject{obj=_G.QueueStatusMinimapButton, x=-16}
		if not minBtn then
			self:skinObject("button", {obj=_G.QueueStatusMinimapButton, fType=ftype, ofs=-1})
			_G.RaiseFrameLevelByTwo(_G.QueueStatusMinimapButton)
			_G.LowerFrameLevel(_G.QueueStatusMinimapButton.sb)
		end
		-- skin any moved Minimap buttons if required
		if _G.IsAddOnLoaded("MinimapButtonFrame") then
			mmKids(_G.MinimapButtonFrame)
		end
		-- show the Bongos minimap icon if required
		if _G.IsAddOnLoaded("Bongos") then
			_G.Bongos3MinimapButton.icon:SetDrawLayer("ARTWORK")
		end
	else
		-- remove ring from GameTimeFrame texture
		self:RawHook(_G.GameTimeTexture, "SetTexCoord", function(this, minx, maxx, miny, maxy)
			self.hooks[this].SetTexCoord(this, minx + 0.075, maxx - 0.075, miny + 0.175, maxy - 0.2)
		end, true)
		_G.C_Timer.After(0.25, function()
			_G.GameTimeFrame:SetSize(28, 28)
			self:moveObject{obj=_G.GameTimeFrame, x=-6, y=-2}
			_G.GameTimeFrame.timeOfDay = 0
			if not minBtn then
				self:skinObject("frame", {obj=_G.GameTimeFrame, fType=ftype, ng=true, ofs=4})
			end
			_G.GameTimeFrame_Update(_G.GameTimeFrame)
		end)
		_G.MiniMapTrackingBorder:SetTexture(nil)
		if not self.isClscBC then
			self:moveObject{obj=_G.MiniMapTrackingFrame, x=-15}
			if not minBtn then
				self:skinObject("frame", {obj=_G.MiniMapTrackingFrame, fType=ftype, bd=10, x1=4, y1=-3})
			end
		else
			self:moveObject{obj=_G.MiniMapTracking, x=-10}
			if not minBtn then
				self:skinObject("frame", {obj=_G.MiniMapTracking, fType=ftype})
			end
			_G.MiniMapBattlefieldFrame:SetSize(28, 28)
		end
		self:moveObject{obj=_G.MiniMapMailFrame, y=-4}
	end

	_G.MiniMapWorldMapButton:ClearAllPoints()
	_G.MiniMapWorldMapButton:SetPoint("LEFT", _G.MinimapZoneTextButton, "RIGHT", -4, 0)
	self:skinOtherButton{obj=_G.MiniMapWorldMapButton, font=self.fontP, text="M", noSkin=minBtn}
	if _G.IsAddOnLoaded("SexyMap")
	or self.isClscBC
	then
		_G.MiniMapWorldMapButton:DisableDrawLayer("OVERLAY") -- border texture
	end
	_G.MiniMapMailIcon:SetTexture(self.tFDIDs.tMB)
	_G.MiniMapMailIcon:ClearAllPoints()
	_G.MiniMapMailIcon:SetPoint("CENTER", _G.MiniMapMailFrame)
	_G.MiniMapMailFrame:SetSize(26, 26)
	_G.TimeManagerClockButton:DisableDrawLayer("BORDER")
	_G.TimeManagerClockButton:SetSize(36, 14)
	if not _G.IsAddOnLoaded("SexyMap") then
		self:moveObject{obj=_G.TimeManagerClockTicker, x=-3, y=-1}
	end

	-- Zoom Buttons
	local btn, txt, xOfs, yOfs
	for _, btnName in _G.pairs{"In", "Out"} do
		if btnName == "In" then
			btn = _G.MinimapZoomIn
			txt = self.modUIBtns.plus
			if not self.isClsc then
				xOfs, yOfs = 14, -12
			else
				xOfs, yOfs = 9, -24
			end
		else
			btn = _G.MinimapZoomOut
			txt = self.modUIBtns.minus
			if not self.isClsc then
				xOfs, yOfs = 20, -10
			else
				xOfs, yOfs = 19, -12
			end
		end
		self:moveObject{obj=btn, x=xOfs, y=yOfs}
		self:skinOtherButton{obj=btn, text=txt, aso={bbclr=btn:IsEnabled() and "gold" or "disabled"}, noSkin=minBtn}
		if not minBtn then
			local function clrZoomBtns()
				for _, bName in _G.pairs{"In", "Out"} do
					btn = bName == "In" and _G.MinimapZoomIn or _G.MinimapZoomOut
					aObj:clrBBC(btn.sb, btn:IsEnabled() and "gold" or "disabled")
				end
			end
			self:SecureHookScript(btn, "OnClick", function(_)
				clrZoomBtns()
			end)
			self:RegisterEvent("MINIMAP_UPDATE_ZOOM", clrZoomBtns)
		end
	end

	-- skin Minimap children, allow for delayed addons to be loaded (e.g. Baggins)
	_G.C_Timer.After(0.5, function() mmKids(_G.Minimap) end)

	-- skin other minimap buttons
	local function skinMMBtn(_, mmBtn, _)
		for _, reg in _G.ipairs{mmBtn:GetRegions()} do
			if reg:GetObjectType() == "Texture" then
				if aObj:hasTextInName(reg, "Border")
				or aObj:hasTextInTexture(reg, "TrackingBorder")
				or aObj:hasTextInTexture(reg, "136430") -- file ID for Border texture
				or aObj:hasTextInTexture(reg, "136467") -- file ID for Background texture
				then
					reg:SetTexture(nil)
				end
			end
		end
		if not minBtn then
			aObj:skinObject("button", {obj=btn})
		end
	end
	-- wait until all AddOn skins have been loaded
	_G.C_Timer.After(1.0, function()
		for addon, obj in _G.pairs(self.mmButs) do
			if _G.IsAddOnLoaded(addon) then
				skinMMBtn("Loaded Addons btns", obj)
			end
		end
	end)

	local function skinDBI(_, dbiBtn, name)
		dbiBtn:SetSize(24, 24)
		aObj:moveObject{obj=dbiBtn.icon, x=-3, y=3}
		skinMMBtn("LibDBIcon btn", dbiBtn, name)
	end
	for name, button in _G.pairs(self.DBIcon.objects) do
		skinDBI(nil, button, name)
	end
	self.DBIcon:RegisterCallback("LibDBIcon_IconCreated", skinDBI)

	-- Garrison Landing Page Minimap button
	if not self.isClsc then
		local anchor = _G.AnchorUtil.CreateAnchor("TOPLEFT", "MinimapBackdrop", "TOPLEFT", 32, -140)
		local function skinGLPM(mBtn)
			if _G.C_Garrison.GetLandingPageGarrisonType() == _G.Enum.GarrisonType.Type_9_0
			and _G.C_Covenants.GetCovenantData(_G.C_Covenants.GetActiveCovenantID())
			then
				makeBtnSquare(mBtn, 0.2, 0.76, 0.2, 0.76)
			elseif _G.select(4, _G.GetBuildInfo()) > 79999 then -- BfA
				makeBtnSquare(mBtn, 0.30, 0.70, 0.26, 0.70)
			else
				makeBtnSquare(mBtn, 0.25, 0.76, 0.32, 0.685)
			end
			anchor:SetPoint(mBtn, true)
		end
		skinGLPM(_G.GarrisonLandingPageMinimapButton)
		self:SecureHook("GarrisonLandingPageMinimapButton_UpdateIcon", function(this)
			skinGLPM(this)
		end)
		_G.GarrisonLandingPageMinimapButton.AlertBG:SetTexture(nil)
	end

end

aObj.blizzLoDFrames[ftype].MovePad = function(self)
	if not self.prdb.MovePad or self.initialized.MovePad then return end
	self.initialized.MovePad = true

	self:SecureHookScript(_G.MovePadFrame, "OnShow", function(this)
		_G.MovePadRotateLeft.icon:SetTexture(self.tFDIDs.rB)
		_G.MovePadRotateRight.icon:SetTexture(self.tFDIDs.rB)
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
			local tex = _G.MovePadLock:GetNormalTexture()
			tex:SetTexture(self.tFDIDs.gAOI)
			tex:SetTexCoord(0, 0.25, 0, 1.0)
			tex:SetAlpha(1)
			tex = _G.MovePadLock:GetPushedTexture()
			tex:SetTexture(self.tFDIDs.gAOI)
			tex:SetTexCoord(0.25, 0.5, 0, 1.0)
			tex:SetAlpha(0.75)
			tex = _G.MovePadLock:GetCheckedTexture()
			tex:SetTexture(self.tFDIDs.gAOI)
			tex:SetTexCoord(0.25, 0.5, 0, 1.0)
			tex:SetAlpha(1)
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
		if not frame -- happens when called again after combat and frame doesn't exist any more
		or frame:IsForbidden()
		then
			return
		end
		-- handle in combat
		if frame:IsProtected()
		and _G.InCombatLockdown()
		then
		    aObj:add2Table(aObj.oocTab, {skinNamePlate, {frame}})
		    return
		end
		local nP = frame.UnitFrame or self:getChild(frame, 1)
		if nP then
			local nHb, nCb = nP.healthBar, nP.CastBar
			nHb.border:DisableDrawLayer("ARTWORK")
			if aObj.isClsc then
				aObj:skinObject("statusbar", {obj=nHb, fi=0, bg=nHb.background})
				if aObj.isClscBC then
					aObj:skinObject("statusbar", {obj=nCb, fi=0, bg=aObj:getRegion(nCb, 1)})
					aObj:nilTexture(nCb.Border, true)
					aObj:nilTexture(nCb.BorderShield, true)
				end
			else
				aObj:skinObject("statusbar", {obj=nHb, fi=0, bg=nHb.background, otherTex={nHb.myHealPrediction, nHb.otherHealPrediction}})
				if nCb then
					aObj:skinObject("statusbar", {obj=nCb, fi=0, bg=nCb.background})
				end
			end
			-- N.B. WidgetContainer objects managed in UIWidgets code
		end
	end
	-- hook this to skin created Nameplates
	self:SecureHook(_G.NamePlateDriverFrame, "OnNamePlateAdded", function(_, namePlateUnitToken)
		skinNamePlate(_G.C_NamePlate.GetNamePlateForUnit(namePlateUnitToken, _G.issecure()))
	end)
	-- skin any existing NamePlates
	for _, frame in _G.pairs(_G.C_NamePlate.GetNamePlates(_G.issecure())) do
		skinNamePlate(frame)
	end

	-- Class Nameplate Frames
	if not self.isClsc then
		local mF = _G.ClassNameplateManaBarFrame
		if mF then
			self:skinObject("statusbar", {obj=mF, fi=0, otherTex={mF.ManaCostPredictionBar, mF.FeedbackFrame.BarTexture}})
		end
		-- DeathKnight (nothing to skin)
		-- Mage (nothing to skin)
		-- Monk
		for i = 1, #_G.ClassNameplateBarWindwalkerMonkFrame.Chi do
			_G.ClassNameplateBarWindwalkerMonkFrame.Chi[i]:DisableDrawLayer("BACKGROUND")
		end
		self:skinObject("statusbar", {obj=_G.ClassNameplateBrewmasterBarFrame, fi=0})
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
				self:HookScript(this.navList[i].MenuArrowButton, "OnEnter", function(bObj)
					bObj.sbb:SetAlpha(1)
				end)
				self:HookScript(this.navList[i].MenuArrowButton, "OnLeave", function(bObj)
					bObj.sbb:SetAlpha(0)
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
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true})
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
		self:SecureHook(this, "RefreshAllData", function(fObj)
			for choiceTex in fObj.choiceTexturePool:EnumerateActive() do
				choiceTex:SetAlpha(0)
			end
			skinBtns(fObj)
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

	local updBBClr
	if self.modBtnBs then
		function updBBClr()
			if _G.PetBattleFrame.ActiveAlly.SpeedIcon:IsShown() then
				aObj:clrBtnBdr(_G.PetBattleFrame.ActiveAlly, "gold")
				_G.PetBattleFrame.ActiveEnemy.sbb:SetBackdropBorderColor(_G.PetBattleFrame.ActiveEnemy.Border:GetVertexColor())
			elseif _G.PetBattleFrame.ActiveEnemy.SpeedIcon:IsShown() then
				aObj:clrBtnBdr(_G.PetBattleFrame.ActiveEnemy, "gold")
				_G.PetBattleFrame.ActiveAlly.sbb:SetBackdropBorderColor(_G.PetBattleFrame.ActiveAlly.Border:GetVertexColor())
			else
				_G.PetBattleFrame.ActiveAlly.sbb:SetBackdropBorderColor(_G.PetBattleFrame.ActiveAlly.Border:GetVertexColor())
				_G.PetBattleFrame.ActiveEnemy.sbb:SetBackdropBorderColor(_G.PetBattleFrame.ActiveEnemy.Border:GetVertexColor())
			end
		end
	end
	self:SecureHookScript(_G.PetBattleFrame, "OnShow", function(this)
		this.TopArtLeft:SetTexture(nil)
		this.TopArtRight:SetTexture(nil)
		this.TopVersus:SetTexture(nil)
		local tvw = this.TopVersus:GetWidth()
		local tvh = this.TopVersus:GetHeight()
		-- Active Allies/Enemies
		local pbf
		for _, type in _G.pairs{"Ally", "Enemy"} do
			pbf = this["Active" .. type]
			pbf.Border:SetTexture(nil)
			if self.modBtnBs then
				pbf.Border2:SetTexture(nil) -- speed texture
				self:addButtonBorder{obj=pbf, relTo=pbf.Icon, ofs=1, reParent={pbf.LevelUnderlay, pbf.Level, pbf.SpeedUnderlay, pbf.SpeedIcon}}
				self:SecureHook(pbf.Border, "SetVertexColor", function(_, _)
					updBBClr()
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
				self:skinObject("frame", {obj=this.sfl, fType=ftype, ng=true, bd=11})
				this.sfl:SetPoint("TOPRIGHT", this, "TOP", -(tvw + 25), 4)
				this.sfl:SetSize(this.TopArtLeft:GetWidth() * 0.59, this.TopArtLeft:GetHeight() * 0.8)
			else
				this.sfr = _G.CreateFrame("Frame", nil, this)
				self:skinObject("frame", {obj=this.sfr, fType=ftype, ng=true, bd=11})
				this.sfr:SetPoint("TOPLEFT", this, "TOP", (tvw + 25), 4)
				this.sfr:SetSize(this.TopArtRight:GetWidth() * 0.59, this.TopArtRight:GetHeight() * 0.8)
			end
			-- Ally2/3, Enemy2/3
			for j = 2, 3 do
				_G.RaiseFrameLevelByTwo(this[type .. j])
				this[type .. j].BorderAlive:SetTexture(nil)
				self:changeTandC(this[type .. j].BorderDead, self.tFDIDs.dpI)
				this[type .. j].healthBarWidth = 34
				this[type .. j].ActualHealthBar:SetWidth(34)
				self:changeTex2SB(this[type .. j].ActualHealthBar)
				this[type .. j].HealthDivider:SetTexture(nil)
				if self.modBtnBs then
					self:addButtonBorder{obj=this[type .. j], relTo=this[type .. j].Icon, reParent={this[type .. j].ActualHealthBar}}
					this[type .. j].sbb:SetBackdropBorderColor(this[type .. j].BorderAlive:GetVertexColor())
					self:SecureHook(this[type .. j].BorderAlive, "SetVertexColor", function(tObj, ...)
						tObj:GetParent().sbb:SetBackdropBorderColor(...)
					end)
				end
			end
		end
		-- create a frame behind the VS text
		this.sfm = _G.CreateFrame("Frame", nil, this)
		self:skinObject("frame", {obj=this.sfm, fType=ftype, ng=true, bd=11})
		this.sfm:SetPoint("TOPLEFT", this.sfl, "TOPRIGHT", -8, 0)
		this.sfm:SetPoint("TOPRIGHT", this.sfr, "TOPLEFT", 8, 0)
		this.sfm:SetHeight(tvh * 0.8)
		this.TopVersusText:SetParent(this.sfm)
		for i = 1, _G.NUM_BATTLE_PETS_IN_BATTLE do
			this.BottomFrame.PetSelectionFrame["Pet" .. i].Framing:SetTexture(nil)
			self:changeTex2SB(this.BottomFrame.PetSelectionFrame["Pet" .. i].HealthBarBG)
			this.BottomFrame.PetSelectionFrame["Pet" .. i].HealthBarBG:SetVertexColor(0.2, 0.2, 0.2, 0.8) -- dark grey
			self:changeTex2SB(this.BottomFrame.PetSelectionFrame["Pet" .. i].ActualHealthBar)
			this.BottomFrame.PetSelectionFrame["Pet" .. i].HealthDivider:SetTexture(nil)
		end
		self:keepRegions(this.BottomFrame.xpBar, {1, 5, 6, 13}) -- text and statusbar textures
		self:skinStatusBar{obj=this.BottomFrame.xpBar, fi=0}
		this.BottomFrame.TurnTimer.TimerBG:SetTexture(nil)
		self:changeTex2SB(this.BottomFrame.TurnTimer.Bar)
		this.BottomFrame.TurnTimer.ArtFrame:SetTexture(nil)
		this.BottomFrame.TurnTimer.ArtFrame2:SetTexture(nil)
		self:removeRegions(this.BottomFrame.FlowFrame, {1, 2, 3})
		self:getRegion(this.BottomFrame.Delimiter, 1):SetTexture(nil)
		self:removeRegions(this.BottomFrame.MicroButtonFrame, {1, 2, 3})
		self:skinObject("frame", {obj=this.BottomFrame, fType=ftype, kfs=true, y1=8})
		if self.modBtns then
			self:skinStdButton{obj=this.BottomFrame.TurnTimer.SkipButton}
			self:SecureHook(this.BottomFrame.TurnTimer.SkipButton, "Disable", function(bObj, _)
				self:clrBtnBdr(bObj)
			end)
			self:SecureHook(this.BottomFrame.TurnTimer.SkipButton, "Enable", function(bObj, _)
				self:clrBtnBdr(bObj)
			end)
		end
		if self.modBtnBs then
			updBBClr()
			self:SecureHook("PetBattleFrame_InitSpeedIndicators", function(_)
				updBBClr()
			end)
			-- use hooksecurefunc as function hooked for tooltips lower down
			_G.hooksecurefunc("PetBattleFrame_UpdateSpeedIndicators", function(_)
				updBBClr()
			end)
			self:addButtonBorder{obj=this.BottomFrame.SwitchPetButton, reParent={this.BetterIcon}, ofs=3, x2=2, y2=-2}
			self:addButtonBorder{obj=this.BottomFrame.CatchButton, reParent={this.BetterIcon}, ofs=3, x2=2, y2=-2}
			self:addButtonBorder{obj=this.BottomFrame.ForfeitButton, ofs=3, x2=2, y2=-2}
			_G.C_Timer.After(0.1, function()
				self:addButtonBorder{obj=this.BottomFrame.abilityButtons[1], reParent={this.BetterIcon}, ofs=3, x2=2, y2=-2}
				self:addButtonBorder{obj=this.BottomFrame.abilityButtons[2], reParent={this.BetterIcon}, ofs=3, x2=2, y2=-2}
				self:addButtonBorder{obj=this.BottomFrame.abilityButtons[3], reParent={this.BetterIcon}, ofs=3, x2=2, y2=-2}
			end)
			-- hook this for pet ability buttons
			self:SecureHook("PetBattleActionButton_UpdateState", function(bObj)
				if bObj.sbb then
					if bObj.Icon
					and bObj.Icon:IsDesaturated()
					then
						self:clrBtnBdr(bObj, "disabled")
					else
						self:clrBtnBdr(bObj)
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
			self:HookScript(this.ActiveAlly.SpeedFlash, "OnPlay", function(_)
				reParent{parent=_G.MainMenuBar}
			end, true)
			self:SecureHookScript(this.ActiveAlly.SpeedFlash, "OnFinished", function(_)
				reParent{reset=true}
			end)
			self:HookScript(this.ActiveEnemy.SpeedFlash, "OnPlay", function(_)
				reParent{parent=_G.MainMenuBar}
			end, true)
			self:SecureHookScript(this.ActiveEnemy.SpeedFlash, "OnFinished", function(_)
				reParent{reset=true}
			end)
			-- hook this to reparent the gradient texture if pets have equal speed
			self:SecureHook("PetBattleFrame_UpdateSpeedIndicators", function(fObj)
				if not fObj.ActiveAlly.SpeedIcon:IsShown()
				and not fObj.ActiveEnemy.SpeedIcon:IsShown()
				then
					reParent{reset=true}
				end
			end)
		end

		self:Unhook(this, "OnShow")
		self:SendMessage("PetBattleUI_OnShow")
		self.callbacks:Fire("PetBattleUI_OnShow")
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
		self:changeTex2SB(_G.PetBattlePrimaryUnitTooltip.ActualHealthBar)
		self:changeTex2SB(_G.PetBattlePrimaryUnitTooltip.XPBar)
		self:add2Table(self.pbtt, _G.PetBattlePrimaryUnitTooltip.sf)
		-- hook this to reset tooltip gradients
		self:SecureHookScript(_G.PetBattleFrame, "OnHide", function(_)
			for i = 1, #aObj.pbtt do
				aObj.pbtt[i].tfade:SetParent(aObj.pbtt[i])
				aObj.pbtt[i].tfade:SetGradientAlpha(aObj:getGradientInfo())
			end
		end)
	end

end

aObj.blizzLoDFrames[ftype].PlayerChoice = function(self)
	if not self.prdb.PlayerChoice or self.initialized.PlayerChoice then return end
	self.initialized.PlayerChoice = true

	local optOfs = {
		[0]   = {-5, 0, 5, -30}, -- defaults
		-- [89]  = {}, -- WoD Strategic Assault Choice [Alliance] (Lunarfall) √
		-- [138] = {}, -- WoD Strategic Assault Choice [Horde] (Frostwall) √
		-- [203] = {}, -- Tanaan Battle Plan [Alliance] (Lion's Watch) √
		-- [240] = {}, -- Legion Artifact Weapon Choice (1st Artifact Weapon) √
		-- [281] = {}, -- Legion Artifact Weapon Choice (2nd Artifact Weapon) √
		-- [285] = {}, -- Legion Artifact Weapon Choice (Last Aritfact Weapon) √
		-- [342] = {}, -- Warchief's Command Board [Horde] √
		-- [505] = {}, -- Hero's Call Board [Alliance] √
		-- [611] = {}, -- Torghast Option (inside Toghast) √
		-- [640] = {}, -- Ember Court Entertainments List [Venthyr] (Hips) √
		-- [641] = {}, -- Ember Court Refreshments List [Venthyr] (Picky Stefan) √
		-- [653] = {}, -- Ember Court Invitation list [Venthyr] (Lord Garridan) √
		-- [667] = {}, -- Shadowlands Experience (Threads of Fate) √
		-- [671] = {}, -- Torghast Option (outside Toghast) √
		[998] = {-28, 48, 28, -48}, -- Covenant Selection (Oribos) [Enlarged] √
		[999] = {-4, 4, 4, -4}, -- Covenant Selection (Oribos) [Standard] √
	}

	local x1Ofs, y1Ofs, x2Ofs, y2Ofs
	local function resizeSF(frame, idx)
		-- aObj:Debug("resizeSF: [%s, %s]", frame, idx)
		x1Ofs, y1Ofs, x2Ofs, y2Ofs = _G.unpack(optOfs[idx])
		-- aObj:Debug("PCUI offsets: [%s, %s, %s, %s]", x1Ofs, y1Ofs, x2Ofs, y2Ofs)
		frame.sf:ClearAllPoints()
		frame.sf:SetPoint("TOPLEFT",frame, "TOPLEFT", x1Ofs, y1Ofs)
		frame.sf:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", x2Ofs, y2Ofs)
		x1Ofs, y1Ofs, x2Ofs, y2Ofs = nil, nil, nil, nil
	end
	local function skinOptions(frame, source) -- luacheck: ignore source
		-- aObj:Debug("skinOptions PCUI: [%s, %s, %s, %s]", source, frame.uiTextureKit, frame.optionFrameTemplate)
		if not frame.optionFrameTemplate then return end
		frame.sf:SetShown(not frame.optionFrameTemplate:find("Torghast"))
		for opt in frame.optionPools:EnumerateActiveByTemplate(frame.optionFrameTemplate) do
			opt.OptionText.String:SetTextColor(aObj.BT:GetRGB())
			opt.OptionText.HTML:SetTextColor(aObj.BT:GetRGB())
			if aObj.modBtns then
				for btn in opt.OptionButtonsContainer.buttonPool:EnumerateActive() do
					-- DON'T skin magnifying glass button
					if btn:GetText() ~= "Preview Covenant" then
						aObj:skinStdButton{obj=btn}
					end
				end
			end
			if frame.optionFrameTemplate == "PlayerChoiceNormalOptionTemplate" then
				opt.Background:SetTexture(nil)
				opt.ArtworkBorder:SetTexture(nil)
				opt.Header.Ribbon:SetTexture(nil)
				opt.Header.Contents.Text:SetTextColor(aObj.HT:GetRGB())
				opt.SubHeader.BG:SetTexture(nil)
				opt.SubHeader.Text:SetTextColor(aObj.HT:GetRGB())
				for reward in opt.Rewards.rewardsPool:EnumerateActive() do
					if reward.Name then
						reward.Name:SetTextColor(aObj.BT:GetRGB())
					elseif reward.Text then
						reward.Text:SetTextColor(aObj.BT:GetRGB())
					end
					if aObj.modBtnBs then
						if reward.Icon then
							aObj:addButtonBorder{obj=reward, fType=ftype, relTo=reward.Icon, reParent={reward.Count}}
						elseif reward.itemButton then
							aObj:addButtonBorder{obj=reward.itemButton, fType=ftype, ibt=true}
						end
					end
				end
				aObj:skinObject("frame", {obj=opt, fType=ftype, fb=true, clr="grey"})
				resizeSF(opt, 0)
			elseif frame.optionFrameTemplate == "PlayerChoiceCovenantChoiceOptionTemplate" then
				opt.BackgroundShadowSmall:SetTexture(nil)
				opt.BackgroundShadowLarge:SetTexture(nil)
				aObj:skinObject("frame", {obj=opt, fType=ftype, fb=true, clr="grey"})
				resizeSF(opt, 999)
				-- hook these to handle size changes on mouseover (used in Oribos for covenant choice)
				aObj:SecureHook(opt, "OnUpdate", function(this, _) -- used for first time enlargement
					if _G.RegionUtil.IsDescendantOfOrSame(_G.GetMouseFocus(), this) then
						resizeSF(opt, 998)
					end
					aObj:Unhook(opt, "OnUpdate")
				end)
				aObj:secureHook(opt, "OnEnter", function(_)
					resizeSF(opt, 998)
				end)
				aObj:secureHook(opt, "OnLeave", function(_)
					resizeSF(opt, 999)
				end)
			elseif frame.optionFrameTemplate == "PlayerChoiceTorghastOptionTemplate" then
				opt.Header.Text:SetTextColor(aObj.HT:GetRGB())
			end
		end
	end
	self:SecureHookScript(_G.PlayerChoiceFrame, "OnShow", function(this)
		this.BlackBackground:DisableDrawLayer("BACKGROUND")
		this.Header:DisableDrawLayer("BORDER")
		this.Background:DisableDrawLayer("BACKGROUND")
		this.Title:DisableDrawLayer("BACKGROUND")
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, rns=true, cbns=true, clr="sepia", ofs=0})
		skinOptions(this, "Initial")
		self:SecureHook(this, "SetupOptions", function(fObj)
			skinOptions(fObj, "SetupOptions")
		end)

		self:Unhook(this, "OnShow")
	end)

	if _G.C_PlayerChoice.IsWaitingForPlayerChoiceResponse() then
		-- if frame not yet skinned then force it to be skinned
		if self:IsHooked(_G.PlayerChoiceFrame, "OnShow") then
			_G.PlayerChoiceFrame:Show()
			_G.PlayerChoiceFrame:Hide()
		end
	end

end

aObj.blizzFrames[ftype].PVEFrame = function(self)
	if not self.prdb.PVEFrame or self.initialized.PVEFrame then return end
	self.initialized.PVEFrame = true

	-- "LFDParentFrame", "RaidFinderFrame", "LFGListPVEStub"

	self:SecureHookScript(_G.PVEFrame, "OnShow", function(this)
		self:keepFontStrings(this.shadows)
		self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, offsets={x1=9, y1=self.isTT and 2 or -3, x2=-9, y2=2}})
		-- GroupFinder Frame
		for i = 1, 3 do
			_G.GroupFinderFrame["groupButton" .. i].bg:SetTexture(nil)
			_G.GroupFinderFrame["groupButton" .. i].ring:SetTexture(nil)
			self:changeTex(_G.GroupFinderFrame["groupButton" .. i]:GetHighlightTexture())
			-- make icon square
			self:makeIconSquare(_G.GroupFinderFrame["groupButton" .. i], "icon")
		end
		-- hook this to change selected texture
		self:SecureHook("GroupFinderFrame_SelectGroupButton", function(index)
			for i = 1, 3 do
				if i == index then
					self:changeTex(_G.GroupFinderFrame["groupButton" .. i].bg, true)
				else
					_G.GroupFinderFrame["groupButton" .. i].bg:SetTexture(nil)
				end
			end
		end)
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true, x1=-4, x2=3})
		if self.modBtnBs then
			-- hook this to change button border colour
			self:SecureHook("GroupFinderFrame_EvaluateButtonVisibility", function(_, _)
				for i = 1, 3 do
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
		if not self.prdb.LFGTexture then
			self:nilTexture(this.background, true)
		end
		self:nilTexture(this.filigree, true)
		self:nilTexture(this.bottomArt, true)
		this.instanceInfo.underline:SetTexture(nil)
		self:skinObject("frame", {obj=this, fType=ftype, ofs=-1, y1=-5, x2=-4})
		if self.modBtns then
			self:skinOtherButton{obj=_G.PVPReadyDialogCloseButton, text=self.modUIBtns.minus}
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
		this.Content:DisableDrawLayer("BACKGROUND")
		this.Content:DisableDrawLayer("OVERLAY")
		self:skinObject("slider", {obj=this.ScrollFrame.ScrollBar, fType=ftype})
		self:keepFontStrings(this.TabContainer)
		self:skinObject("tabs", {obj=this.TabGroup, tabs=this.Tabs, fType=ftype, lod=self.isTT and true, offsets={x1=8, y1=self.isTT and 2 or -3, x2=-8, y2=2}, track=false})
		if self.isTT then
			self:SecureHook(this, "OnTabGroupClicked", function(fObj, selectedTab)
				for _, tab in _G.pairs(fObj.Tabs) do
					if tab == selectedTab then
						self:setActiveTab(tab.sf)
					else
						self:setInactiveTab(tab.sf)
					end
				end
			end)
		end
		self:skinObject("frame", {obj=this.ScrollFrame, fType=ftype, kfs=true, fb=true, ofs=0, y1=55, x2=23, y2=-4})
		this.CloseButton.Border:SetAtlas(nil)
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, ofs=0, x2=1})

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.PVPMatchResults, "OnShow", function(this)
		this.content:DisableDrawLayer("BACKGROUND")
		this.content:DisableDrawLayer("OVERLAY")
		this.scrollFrame.background:SetAlpha(0)
		self:skinObject("slider", {obj=this.scrollFrame.scrollBar, fType=ftype})
		self:keepFontStrings(this.content.tabContainer)
		self:skinObject("tabs", {obj=this.tabGroup, tabs=this.Tabs, fType=ftype, lod=self.isTT and true, offsets={x1=8, y1=self.isTT and 2 or -3, x2=-8, y2=2}, track=false})
		if self.isTT then
			self:SecureHook(this, "OnTabGroupClicked", function(fObj, selectedTab)
				for _, tab in _G.pairs(fObj.Tabs) do
					if tab == selectedTab then
						self:setActiveTab(tab.sf)
					else
						self:setInactiveTab(tab.sf)
					end
				end
			end)
		end
		self:skinObject("frame", {obj=this.scrollFrame, fType=ftype, kfs=true, fb=true, ofs=0, y1=55, x2=23, y2=-4})
		this.earningsArt:DisableDrawLayer("ARTWORK")
		this.CloseButton.Border:SetAtlas(nil)
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, ofs=0, x2=1})
		if self.modBtns then
			self:skinStdButton{obj=this.buttonContainer.leaveButton, fType=ftype}
			self:skinStdButton{obj=this.buttonContainer.requeueButton, fType=ftype}
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
		self:SecureHook("QuestLogQuests_Update", function(_)
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
				hdr.HighlightBackground:SetTexture(self.tFDIDs.qltHL)
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
			self:skinStdButton{obj=this.DetailsFrame.TrackButton, x2=-2}
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
		self:SecureHook(this.CampaignOverview, "UpdateCampaignLoreText", function(fObj, _, _)
			for tex in fObj.texturePool:EnumerateActive() do
				tex:SetTexture(nil)
			end
		end)

		self:Unhook(this, "OnShow")
	end)

	-- Quest Log Popup Detail Frame
	self:SecureHookScript(_G.QuestLogPopupDetailFrame, "OnShow", function(this)
		self:skinObject("slider", {obj=this.ScrollFrame.ScrollBar, fType=ftype, rpTex="artwork"})
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true})
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
					self:skinOtherButton{obj=this.MinimizeButton, text=self.modUIBtns.minus}
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
					aObj:SecureHookScript(_G.QueueStatusMinimapButton.smAnimGroup, "OnFinished", function(_)
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
		self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true, offsets={x1=7, y1=self.isTT and 2 or -1, x2=-7, y2=0}})
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true})

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
			self:skinCloseButton{obj=_G.RaidInfoCloseButton, fType=ftype}
			self:skinStdButton{obj=_G.RaidFrameConvertToRaidButton, fType=ftype}
			self:skinStdButton{obj=_G.RaidFrameRaidInfoButton, fType=ftype}
			self:skinStdButton{obj=_G.RaidInfoExtendButton, fType=ftype}
			self:skinStdButton{obj=_G.RaidInfoCancelButton, fType=ftype}
			self:SecureHook("RaidFrame_Update", function()
				self:clrBtnBdr(_G.RaidFrameConvertToRaidButton)
			end)
			self:SecureHook(_G.RaidFrameRaidInfoButton, "Disable", function(bObj, _)
				self:clrBtnBdr(bObj)
			end)
			self:SecureHook(_G.RaidFrameRaidInfoButton, "Enable", function(bObj, _)
				self:clrBtnBdr(bObj)
			end)
			self:SecureHook("RaidInfoFrame_UpdateSelectedIndex", function()
				self:clrBtnBdr(_G.RaidInfoExtendButton)
			end)
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.RaidFrameAllAssistCheckButton, fType=ftype}
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

	self:SecureHookScript(_G.ScrappingMachineFrame, "OnShow", function(this)
		this.Background:SetTexture(nil)
		this.ItemSlots:DisableDrawLayer("ARTWORK")
		for slot in this.ItemSlots.scrapButtons:EnumerateActive() do
			self:nilTexture(slot.IconBorder, true)
			self.modUIBtns:addButtonBorder{obj=slot, relTo=slot.Icon, clr="grey"} -- use module function to force button border
			-- hook this to reset sbb colour
			self:SecureHook(slot, "ClearSlot", function(bObj)
				self:clrBtnBdr(bObj, "grey")
			end)
		end
		self:removeMagicBtnTex(this.ScrapButton)
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true})
		if self.modBtns then
			 self:skinStdButton{obj=this.ScrapButton}
			 self:SecureHook(this, "UpdateScrapButtonState", function(fObj)
				 self:clrBtnBdr(fObj.ScrapButton)
			 end)
		end

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.ScrappingMachineFrame)

end

aObj.blizzFrames[ftype].SharedBasicControls = function(self)
	if not self.prdb.SharedBasicControls or self.initialized.SharedBasicControls then return end
	self.initialized.SharedBasicControls = true

	self:SecureHookScript(_G.BasicMessageDialog, "OnShow", function(this)
		self:removeNineSlice(this.Border)
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ofs=0})
		if self.modBtns then
			self:skinStdButton{obj=_G.BasicMessageDialogButton, fType=ftype}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.ScriptErrorsFrame, "OnShow", function(this)
		self:skinObject("slider", {obj=this.ScrollFrame.ScrollBar, fType=ftype})
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ofs=0})
		if self.modBtns then
			self:skinCloseButton{obj=_G.ScriptErrorsFrameClose}
			self:skinStdButton{obj=this.Reload}
			self:skinStdButton{obj=this.Close}
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=this.PreviousError, ofs=-3, x1=2, clr="gold"}
			self:addButtonBorder{obj=this.NextError, ofs=-3, x1=2, clr="gold"}
			self:SecureHook(this, "UpdateButtons", function(fObj)
				self:clrBtnBdr(fObj.PreviousError,"gold")
				self:clrBtnBdr(fObj.NextError, "gold")
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
			self:SecureHook(this.RightFeature.StartQuestButton, "SetButtonState", function(bObj, _)
				self:clrBtnBdr(bObj)
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
		end)
	end

	for i = 1, _G.STATICPOPUP_NUMDIALOGS do
		self:SecureHookScript(_G["StaticPopup" .. i], "OnShow", function(this)
			if self.isRtl then
				self:removeNineSlice(this.Border)
			end
			this.Separator:SetTexture(nil)
			local objName = this:GetName()
			self:skinObject("editbox", {obj=_G[objName .. "EditBox"], fType=ftype, ofs=0, y1=-4, y2=4})
			self:skinMoneyFrame{obj=_G[objName .. "MoneyInputFrame"]}
			_G[objName .. "ItemFrameNameFrame"]:SetTexture(nil)
			self:skinObject("frame", {obj=this, fType=ftype, ofs=-6})
			if self.modBtns then
				self:skinStdButton{obj=this.button1, y1=2}
				self:SecureHook(this.button1, "Disable", function(bObj, _)
					self:clrBtnBdr(bObj)
				end)
				self:SecureHook(this.button1, "Enable", function(bObj, _)
					self:clrBtnBdr(bObj)
				end)
				self:SecureHook(this.button1, "SetEnabled", function(bObj)
					self:clrBtnBdr(bObj)
				end)
				self:skinStdButton{obj=this.button2, y1=2}
				self:SecureHook(this.button2, "Disable", function(bObj, _)
					self:clrBtnBdr(bObj)
				end)
				self:SecureHook(this.button2, "Enable", function(bObj, _)
					self:clrBtnBdr(bObj)
				end)
				self:SecureHook(this.button2, "SetEnabled", function(bObj)
					self:clrBtnBdr(bObj)
				end)
				self:skinStdButton{obj=this.button3, y1=2}
				self:SecureHook(this.button3, "Disable", function(bObj, _)
					self:clrBtnBdr(bObj)
				end)
				self:SecureHook(this.button3, "SetEnabled", function(bObj)
					self:clrBtnBdr(bObj)
				end)
				self:skinStdButton{obj=this.button4, y1=2}
				self:SecureHook(this.button4, "Disable", function(bObj, _)
					self:clrBtnBdr(bObj)
				end)
				self:SecureHook(this.button4, "Enable", function(bObj, _)
					self:clrBtnBdr(bObj)
				end)
				self:skinStdButton{obj=this.extraButton, y1=2}
				self:SecureHook(this.extraButton, "Disable", function(bObj, _)
					self:clrBtnBdr(bObj)
				end)
				self:SecureHook(this.extraButton, "Enable", function(bObj, _)
					self:clrBtnBdr(bObj)
				end)
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=_G[objName .. "ItemFrame"], ibt=true}
			end
			-- prevent FrameLevel from being changed (LibRock does this)
			this.sf.SetFrameLevel = _G.nop

			self:Unhook(this, "OnShow")
		end)
		-- check to see if already being shown
		self:checkShown(_G["StaticPopup" .. i])
	end

	local function skinReportFrame(frame)
		aObj:skinObject("frame", {obj=frame.Comment, fType=ftype, kfs=true, fb=true})
		aObj:skinObject("frame", {obj=frame, fType=ftype, kfs=true})
		if aObj.modBtns then
			aObj:skinStdButton{obj=frame.ReportButton}
			aObj:skinStdButton{obj=frame.CancelButton}
		end
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
		self:SecureHook(_G.PlayerReportFrame, "ShowReportDialog", function(this, _)
			self:removeNineSlice(this.Border)
			skinReportFrame(this)

			self:Unhook(this, "ShowReportDialog")
		end)
		self:SecureHook(_G.ClubFinderReportFrame, "ShowReportDialog", function(this, _)
			self:removeNineSlice(this.Border)
			skinReportFrame(this)

			self:Unhook(this, "ShowReportDialog")
		end)
	else
		self:SecureHook(_G.PlayerReportFrame, "InitiateReport", function(this, _)
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
			self:removeRegions(btn.ModelScene, {1, 2, 6, 7})
		end
		-- .Tree
			-- .LinkContainer
			-- .NodeContainer
		-- .ConduitList
			-- ScrollBox.ScrollTarget
				-- .Lists / .Sections
					-- CategoryButton
						-- Container
		if self.modBtns then
			for _, frame in _G.ipairs(this.ConduitList.ScrollBox:GetFrames()) do
				self:getRegion(frame.CategoryButton.Container, 1):SetTexture(nil)
				self:skinStdButton{obj=frame.CategoryButton, fType=ftype, ofs=1, clr="sepia"}
			end
		end
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ofs=-5, clr="sepia"})
		if self.modBtns then
			self:skinCloseButton{obj=this.CloseButton, fType=ftype, noSkin=true}
			self:skinStdButton{obj=this.ActivateSoulbindButton, fType=ftype}
			self:skinStdButton{obj=this.CommitConduitsButton, fType=ftype}
			self:SecureHook(this, "UpdateActivateSoulbindButton", function(fObj)
				self:clrBtnBdr(fObj.ActivateSoulbindButton)
			end)
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzLoDFrames[ftype].SubscriptionInterstitialUI = function(self)
	if not self.prdb.SubscriptionInterstitialUI or self.initialized.SubscriptionInterstitialUI then return end
	self.initialized.SubscriptionInterstitialUI = true

	self:SecureHookScript(_G.SubscriptionInterstitialFrame, "OnShow", function(this)
		self:skinObject("frame", {obj=this, fType=ftype, ri=true, rns=true, cb=true, ofs=1, x2=2})
		if self.modBtns then
			self:skinStdButton{obj=this.ClosePanelButton, fType=ftype}
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].SystemOptions = function(self)
	if not self.prdb.SystemOptions or self.initialized.SystemOptions then return end
	self.initialized.SystemOptions = true

	self:SecureHookScript(_G.VideoOptionsFrame, "OnShow", function(this)
		self:removeNineSlice(this.Border)
		-- Main panel
		self:skinObject("frame", {obj=_G.VideoOptionsFrameCategoryFrame, fType=ftype, kfs=true, rns=true, fb=true})
		self:skinObject("slider", {obj=_G.VideoOptionsFrameCategoryFrameListScrollBar, fType=ftype, x1=4, x2=-5})
		self:skinObject("frame", {obj=_G.VideoOptionsFramePanelContainer, fType=ftype, kfs=true, rns=true, fb=true})
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, hdr=true})
		_G.VideoOptionsFrameApply:SetFrameLevel(2) -- make it appear above the PanelContainer
		if self.modBtns then
			self:skinStdButton{obj=_G.VideoOptionsFrameApply, fType=ftype}
			self:skinStdButton{obj=_G.VideoOptionsFrameCancel, fType=ftype}
			self:skinStdButton{obj=_G.VideoOptionsFrameOkay, fType=ftype}
			self:skinStdButton{obj=_G.VideoOptionsFrameDefaults, fType=ftype}
			if self.isClsc then
				self:skinStdButton{obj=_G.VideoOptionsFrameClassic, fType=ftype}
			end
			self:SecureHook(_G.VideoOptionsFrameApply, "Disable", function(bObj)
				self:clrBtnBdr(bObj)
			end)
			self:SecureHook(_G.VideoOptionsFrameApply, "Enable", function(bObj)
				self:clrBtnBdr(bObj)
			end)
		end
		-- Graphics
		self:skinObject("tabs", {obj=_G.Display_, tabs={_G.GraphicsButton, _G.RaidButton}, fType=ftype, upwards=true, offsets={x1=4, y1=0, x2=0, y2=self.isTT and -3 or 2}, track=false, func=function(tab) tab:SetFrameLevel(20) tab.SetFrameLevel = _G.nop end})
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
		skinKids(_G.Display_, ftype)
		self:skinObject("frame", {obj=_G.Display_, fType=ftype, kfs=true, rns=true, fb=true})
		skinKids(_G.Graphics_, ftype)
		self:skinObject("frame", {obj=_G.Graphics_, fType=ftype, kfs=true, rns=true, fb=true})
		skinKids(_G.RaidGraphics_, ftype)
		self:skinObject("frame", {obj=_G.RaidGraphics_, fType=ftype, kfs=true, rns=true, fb=true})

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
		skinKids(this, ftype)

		self:Unhook(this, "OnShow")
	end)
	-- Network
	self:SecureHookScript(_G.NetworkOptionsPanel, "OnShow", function(this)
		skinKids(_G.NetworkOptionsPanel, ftype)

		self:Unhook(this, "OnShow")
	end)
	-- Languages
	self:SecureHookScript(_G.InterfaceOptionsLanguagesPanel, "OnShow", function(this)
		skinKids(this, ftype)

		self:Unhook(this, "OnShow")
	end)
	-- Keyboard
	self:SecureHookScript(_G.MacKeyboardOptionsPanel, "OnShow", function(this)
		-- Languages
		skinKids(this, ftype)

		self:Unhook(this, "OnShow")
	end)
	-- Sound
	self:SecureHookScript(_G.AudioOptionsSoundPanel, "OnShow", function(this)
		skinKids(this, ftype)
		self:skinObject("frame", {obj=_G.AudioOptionsSoundPanelPlayback, fType=ftype, kfs=true, rns=true, fb=true})
		self:skinObject("frame", {obj=_G.AudioOptionsSoundPanelHardware, fType=ftype, kfs=true, rns=true, fb=true})
		self:skinObject("frame", {obj=_G.AudioOptionsSoundPanelVolume, fType=ftype, kfs=true, rns=true, fb=true})

		self:Unhook(this, "OnShow")
	end)
	-- Voice
	self:SecureHookScript(_G.AudioOptionsVoicePanel, "OnShow", function(this)
		self.iofBtn[this.PushToTalkKeybindButton] = true
		skinKids(this, ftype)
		this.TestInputDevice.ToggleTest:DisableDrawLayer("BACKGROUND")
		self:skinObject("frame", {obj=this.TestInputDevice.VUMeter, fType=ftype, kfs=true, rns=true, fb=true})
		if self.modBtnBs then
			self:addButtonBorder{obj=this.TestInputDevice.ToggleTest, fType=ftype, ofs=0, y2=-2}
			self:skinStdButton{obj=this.PushToTalkKeybindButton, fType=ftype}
			this.PushToTalkKeybindButton.KeyLabel:SetDrawLayer("ARTWORK")
			if not self.isClsc then
				self:skinStdButton{obj=this.MacMicrophoneAccessWarning.OpenAccessButton, fType=ftype}
			end
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
	self:SecureHook(_G.TalkingHeadFrame.TextFrame.Text, "SetTextColor", function(_, r, _)
		if r == 0 then -- use light background (Island Expeditions, Voldun Quest, Dark Iron intro)
			_G.TalkingHeadFrame.sf:SetBackdropColor(.75, .75, .75, .75)
			_G.TalkingHeadFrame.MainFrame.CloseButton:SetNormalFontObject(self.modUIBtns.fontBX)
		else
			_G.TalkingHeadFrame.sf:SetBackdropColor(.1, .1, .1, .75) -- use dark background
			_G.TalkingHeadFrame.MainFrame.CloseButton:SetNormalFontObject(self.modUIBtns.fontX)
		end
	end)

end

aObj.blizzFrames[ftype].TextToSpeechFrame = function(self)
	if not self.prdb.TextToSpeechFrame or self.initialized.TextToSpeechFrame then return end
	self.initialized.TextToSpeechFrame = true

	self:SecureHookScript(_G.TextToSpeechFrame, "OnShow", function(this)
		self:skinObject("dropdown", {obj=_G.TextToSpeechFrameTtsVoiceDropdown, fType=ftype})
		self:getChild(_G.TextToSpeechFrameTtsVoicePicker, 1):DisableDrawLayer("BACKGROUND")
		self:skinObject("scrollbar", {obj=_G.TextToSpeechFrameTtsVoicePicker.ScrollBar, fType=ftype, rpTex="background"})
		self:skinObject("dropdown", {obj=_G.TextToSpeechFrameTtsVoiceAlternateDropdown, fType=ftype})
		self:getChild(_G.TextToSpeechFrameTtsVoiceAlternatePicker, 1):DisableDrawLayer("BACKGROUND")
		self:skinObject("scrollbar", {obj=_G.TextToSpeechFrameTtsVoiceAlternatePicker.ScrollBar, fType=ftype, rpTex="background"})
		self:skinObject("slider", {obj=_G.TextToSpeechFrameAdjustRateSlider, fType=ftype})
		self:skinObject("slider", {obj=_G.TextToSpeechFrameAdjustVolumeSlider, fType=ftype})
		if self.modBtns then
			self:skinStdButton{obj=_G.TextToSpeechFramePlaySampleButton, fType=ftype}
			self:skinStdButton{obj=_G.TextToSpeechFramePlaySampleAlternateButton, fType=ftype}
			if not aObj.isRtlPTR then
				self:skinStdButton{obj=_G.TextToSpeechDefaultButton, fType=ftype}
			end
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.TextToSpeechFramePanelContainer.PlaySoundSeparatingChatLinesCheckButton, fType=ftype}
			self:skinCheckButton{obj=_G.TextToSpeechFramePanelContainer.AddCharacterNameToSpeechCheckButton, fType=ftype}
			self:skinCheckButton{obj=_G.TextToSpeechFramePanelContainer.NarrateMyMessagesCheckButton, fType=ftype}
			self:skinCheckButton{obj=_G.TextToSpeechFramePanelContainer.PlayActivitySoundWhenNotFocusedCheckButton, fType=ftype}
			self:skinCheckButton{obj=_G.TextToSpeechFramePanelContainer.UseAlternateVoiceForSystemMessagesCheckButton, fType=ftype}
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].TimeManager = function(self)
	if not self.prdb.TimeManager or self.initialized.TimeManager then return end
	self.initialized.TimeManager = true

	-- Time Manager Frame
	self:SecureHookScript(_G.TimeManagerFrame, "OnShow", function(this)
		_G.TimeManagerFrameTicker:Hide()
		self:keepFontStrings(_G.TimeManagerStopwatchFrame)
		self:skinObject("dropdown", {obj=_G.TimeManagerAlarmHourDropDown, fType=ftype, x2=-6})
		self:skinObject("dropdown", {obj=_G.TimeManagerAlarmMinuteDropDown, fType=ftype, x2=-6})
		self:skinObject("dropdown", {obj=_G.TimeManagerAlarmAMPMDropDown, fType=ftype, x2=-6})
		self:skinObject("editbox", {obj=_G.TimeManagerAlarmMessageEditBox, fType=ftype})
		self:removeRegions(_G.TimeManagerAlarmEnabledButton, {6, 7})
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true, x2=self.isClsc and 1 or 3})
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.TimeManagerStopwatchCheck, y1=2, y2=-4}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.TimeManagerAlarmEnabledButton, fType=ftype}
			self:skinCheckButton{obj=_G.TimeManagerMilitaryTimeCheck, fType=ftype}
			self:skinCheckButton{obj=_G.TimeManagerLocalTimeCheck, fType=ftype}
		end
		-- Stopwatch Frame
		self:keepFontStrings(_G.StopwatchTabFrame)
		self:skinObject("frame", {obj=_G.StopwatchFrame, fType=ftype, kfs=true, y1=-16, x2=-1, y2=2})
		if self.modBtns then
			self:skinCloseButton{obj=_G.StopwatchCloseButton, fType=ftype, noSkin=true}
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.StopwatchPlayPauseButton, ofs=-1, x1=0, clr="gold"}
			self:addButtonBorder{obj=_G.StopwatchResetButton, ofs=-1, x1=0, clr="gold"}
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].Tooltips = function(self)
	if not self.prdb.Tooltips.skin or self.initialized.Tooltips then return end
	self.initialized.Tooltips = true

	if _G.IsAddOnLoaded("TinyTooltip") then
		_G.setmetatable(self.ttList, {__newindex = function(_, _, tTip)
			tTip = _G.type(tTip) == "string" and _G[tTip] or tTip
			_G.LibStub:GetLibrary("LibEvent.7000", true):trigger("tooltip.style.init", tTip)
			self:SendMessage("Tooltip_Setup", tTip)
		end})
		return
	end

	local tt_Tips
	if _G.IsAddOnLoaded("TipTac") then
		tt_Tips = self:getKeys(_G.TipTac.tipsToModify)
	else
		tt_Tips = {}
	end

	-- using a metatable to manage tooltips when they are added in different functions
	_G.setmetatable(self.ttList, {__newindex = function(tab, _, tTip)
		-- get object reference for tooltip, handle either strings or objects being passed
		tTip = _G.type(tTip) == "string" and _G[tTip] or tTip
		-- ignore if TipTac is managing it
		if tt_Tips[tTip] then return end

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

		-- hook this to prevent Gradient overlay when tooltip reshown
		self:HookScript(tTip, "OnUpdate", function(this)
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
		-- ensure it gets updated
		self.ttHook[_G.ItemRefTooltip] = true
		if self.modBtns then
			self:skinCloseButton{obj=self.isClsc and _G.ItemRefCloseButton or this.CloseButton, noSkin=true}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHook("GameTooltip_AddProgressBar", function(this, _)
		for progressBar in this.progressBarPool:EnumerateActive() do
			self:removeRegions(progressBar.Bar, {1, 2, 3, 4, 5}) -- 6 is text
		    self:skinStatusBar{obj=progressBar.Bar, fi=0, bgTex=self:getRegion(progressBar.Bar, 7)}
		end
	end)

	if aObj.isClscBC then
		-- Hook these to handle AddOns that use GameTooltip Backdrop functions (e.g. SavedInstances)
		self:RawHook(_G.GameTooltip, "GetBackdrop", function(_)
			return aObj.Backdrop[1]
		end, true)
		self:RawHook(_G.GameTooltip, "GetBackdropColor", function(_)
			return aObj.bClr:GetRGBA()
		end, true)
		self:RawHook(_G.GameTooltip, "GetBackdropBorderColor", function(_)
			return aObj.bbClr:GetRGBA()
		end, true)
	end

	-- AceConfigDialog tooltip
	addTooltip(self.ACD.tooltip)

	-- SexyMapZoneTextTooltip
	if not self.isClsc then
		if _G.IsAddOnLoaded("SexyMap") then
			self:add2Table(self.ttList, "SexyMapZoneTextTooltip")
		end
	end

end

aObj.blizzLoDFrames[ftype].TorghastLevelPicker = function(self)
	if not self.prdb.TorghastLevelPicker or self.initialized.TorghastLevelPicker then return end
	self.initialized.TorghastLevelPicker = true

	self:SecureHookScript(_G.TorghastLevelPickerFrame, "OnShow", function(this)
		if self.modBtnBs then
			self:addButtonBorder{obj=this.Pager.PreviousPage, clr="gold", ofs=-2, y1=-3, x2=-3}
			self:addButtonBorder{obj=this.Pager.NextPage, clr="gold", ofs=-2, y1=-3, x2=-3}
			self:SecureHook(this.Pager, "SetupPagingButtonStates", function(fObj)
				self:clrBtnBdr(fObj.PreviousPage, "gold")
				self:clrBtnBdr(fObj.NextPage, "gold")
			end)
		end
		-- .ModelScene
		this.CloseButton.CloseButtonBorder:SetTexture(nil)
		if self.modBtns then
			self:skinCloseButton{obj=this.CloseButton , noSkin=true}
			self:skinStdButton{obj=this.OpenPortalButton}
			self:SecureHook(this, "UpdatePortalButtonState", function(fObj, _)
				self:clrBtnBdr(fObj.OpenPortalButton)
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
		self:SecureHookScript(this.sf, "OnShow", function(_)
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
		if aObj.isRtlPTR
		or aObj.isClscERAPTR
		then
			aObj:removeNineSlice(_G[frame:GetName() .. "MenuBackdrop"].NineSlice)
		end
		aObj:skinObject("frame", {obj=frame, fType=ftype, kfs=true, ofs=-4})
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

	local function setTextColor(textObject)
		self:rawHook(textObject, "SetTextColor", function(this, r, g, b, a)
			local tcr, tcg, tcb = aObj:round2(r, 2), aObj:round2(g, 2), aObj:round2(b, 2)
			if (tcr == 0.41 or tcr == 0.28 and tcg == 0.02 and tcb == 0.02) -- Red
			or (tcr == 0.08 and tcg == 0.17 or tcg == 0.16 and tcb == 0.37) -- Blue
			-- or (tcr == 0.19 and tcg == 0.05 and tcb == 0.01) -- WarboardUI
			then
				self.hooks[this].SetTextColor(this, aObj.BT:GetRGBA())
			else
				self.hooks[this].SetTextColor(this, r, g, b, a)
			end
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
		-- aObj:Debug("skinWidget: [%s, %s, %s, %s, %s, %s, %s]", wFrame, wFrame:GetDebugName(), wFrame.widgetType, wFrame.widgetTag, wFrame.widgetSetID, wFrame.widgetID, wInfo)

		-- luacheck: ignore 542 ((W542) empty if branch)
		if wFrame.widgetType == 0 then -- IconAndText (World State: ICONS at TOP)
			-- N.B. DON'T add buttonborder to Icon(s)
		elseif wFrame.widgetType == 1 then -- CaptureBar (World State: Capture bar on RHS)
			-- DON'T change textures as it doesn't really improve it
		elseif wFrame.widgetType == 2 then -- StatusBar
			if aObj.isClsc then
				aObj:removeRegions(wFrame.Bar, {5, 6, 7}) -- border textures
			else
				aObj:skinObject("statusbar", {obj=wFrame.Bar, regions={2, 3, 4, 9, 10, 11}, fi=0, nilFuncs=true})
			end
		elseif wFrame.widgetType == 3 then -- DoubleStatusBar (Island Expeditions)
			aObj:skinObject("statusbar", {obj=wFrame.LeftBar, regions={2, 3, 4}, fi=0, bg=wFrame.LeftBar.BG, nilFuncs=true})
			aObj:skinObject("statusbar", {obj=wFrame.RightBar, regions={2, 3, 4}, fi=0, bg=wFrame.RightBar.BG, nilFuncs=true})
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
		elseif wFrame.widgetType == 12 then -- TextureAndText
			-- .Background
			-- .Foreground
			setTextColor(wFrame.Text)
		-- N.B. Classic ONLY has 12 UIWidgets
		elseif wFrame.widgetType == 13 then -- SpellDisplay
			wFrame.Spell.Border:SetTexture(nil)
			local tcr = setTextColor(wFrame.Spell.Text)
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=wFrame.Spell, relTo=wFrame.Spell.Icon, reParent={wFrame.Spell.StackCount}}
				if tcr == 0.5 then
					aObj:clrBtnBdr(wFrame.Spell, "grey")
				end
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
			aObj:nilTexture(wFrame.Frame, true)
			aObj:skinObject("statusbar", {obj=wFrame.TimerBar, fi=0, bg=wFrame.TimerBar.BG})
			-- FIXME: uses partitionPool ??
		elseif wFrame.widgetType == 21 then -- TextColumnRow
		elseif wFrame.widgetType == 22 then -- Spacer
		end
	end

	if not self.isClsc then
		local function hookAndSkinWidgets(widgetContainer)
			-- DON'T skin NamePlate[n].UnitFrame.WidgetContainer widgets as they cause Clamping Errors
			if widgetContainer:GetDebugName():find("^NamePlate%d+%.UnitFrame%.WidgetContainer") then return end
			aObj:SecureHook(widgetContainer, "UpdateWidgetLayout", function(this)
				for widget in this.widgetPools:EnumerateActive() do
					skinWidget(widget, _G.UIWidgetManager:GetWidgetTypeInfo(widget.widgetType))
				end
			end)
			-- skin existing widgets
			for widget in widgetContainer.widgetPools:EnumerateActive() do
				skinWidget(widget, _G.UIWidgetManager:GetWidgetTypeInfo(widget.widgetType))
			end
		end
		-- hook this to skin new widgets
		self:SecureHook(_G.UIWidgetManager, "OnWidgetContainerRegistered", function(_, widgetContainer)
			hookAndSkinWidgets(widgetContainer)
		end)
		self:SecureHook(_G.UIWidgetManager, "OnWidgetContainerUnregistered", function(_, widgetContainer)
			self:Unhook(widgetContainer, "UpdateWidgetLayout")
		end)
		-- handle existing WidgetContainers
		for widgetContainer, _ in _G.pairs(_G.UIWidgetManager.registeredWidgetContainers) do
			hookAndSkinWidgets(widgetContainer)
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

-- accessed via the Great Vault in Oribos or the Great Vault button on the PVPUI
aObj.blizzLoDFrames[ftype].WeeklyRewards = function(self)
	if not self.prdb.WeeklyRewards or self.initialized.WeeklyRewards then return end
	self.initialized.WeeklyRewards = true

	self:SecureHookScript(_G.WeeklyRewardsFrame, "OnShow", function(this)
		self:skinObject("frame", {obj=this.HeaderFrame, fType=ftype, kfs=true, fb=true, clr="topaz"})
		for _, frame in _G.pairs{"RaidFrame", "MythicFrame", "PVPFrame"} do
			self:skinObject("frame", {obj=this[frame], fType=ftype, kfs=true, fb=true, ofs=3, clr="topaz"})
			this[frame].Background:SetAlpha(1)
		end
		for _, frame in _G.pairs(this.Activities) do
			self:skinObject("frame", {obj=frame, fType=ftype, kfs=true, fb=true, ofs=-3, x2=1, y2=-1, clr="grey"})
			-- show required textures
			if frame.Background then
				frame.Background:SetAlpha(1)
				frame.Orb:SetAlpha(1)
				frame.LockIcon:SetAlpha(1)
			end
			-- .ItemFrame
			-- .UnselectedFrame
			-- FIXME: Why hook this?
			-- self:SecureHook(frame, "Refresh", function(this)
			-- 	if this.unlocked or this.hasRewards then
			-- 	end
			-- end)
		end
		-- .ConcessionFrame
			-- .RewardsFrame
			-- .UnselectedFrame

		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, rns=true, cbns=true, ofs=-5, clr="sepia"})
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
			self:keepFontStrings(this)
			self:moveObject{obj=this.BorderFrame.CloseButton, x=-2.5}
			self:skinObject("frame", {obj=this.BorderFrame, fType=ftype, kfs=true, rns=true, cb=true, ofs=2, x1=-3, x2=0})
			-- make sure map textures are displayed
			this.BorderFrame.sf:SetFrameStrata("LOW")
		end
		this.BorderFrame.Tutorial.Ring:SetTexture(nil)
		for _, oFrame in _G.pairs(this.overlayFrames) do
			-- Tracking Options Button
			if oFrame.IconOverlay then
				oFrame:DisableDrawLayer("BACKGROUND")
				oFrame.Border:SetTexture(nil)
				if self.modBtns then
					self:skinStdButton{obj=oFrame, ofs=-1, clr="gold"}
					if oFrame.ActiveTexture then -- WorldMapTrackingPin
						self:SecureHook(oFrame, "Refresh", function(bObj)
							self:clrBtnBdr(bObj, "gold")
						end)
					end
				end
			-- Floor Navigation Dropdown
			elseif oFrame.Button then
				self:skinObject("dropdown", {obj=oFrame, fType=ftype})
			-- BountyBoard overlay
			elseif oFrame.bountyObjectivePool then
				oFrame:DisableDrawLayer("BACKGROUND")
				self:SecureHook(oFrame, "RefreshBountyTabs", function(fObj)
					for tab in fObj.bountyTabPool:EnumerateActive() do
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
		-- Nav Bar
		self:skinNavBarButton(this.NavBar.home)
		this.NavBar:DisableDrawLayer("BACKGROUND")
		this.NavBar:DisableDrawLayer("BORDER")
		this.NavBar.overlay:DisableDrawLayer("OVERLAY")
		if self.modBtns then
			self:skinOtherButton{obj=this.BorderFrame.MaxMinButtonFrame.MaximizeButton, font=self.fontS, text=self.nearrow}
			self:skinOtherButton{obj=this.BorderFrame.MaxMinButtonFrame.MinimizeButton, font=self.fontS, text=self.swarrow}
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
			if frame.Border then
				aObj:removeBackdrop(frame.Border)
			end
			aObj:skinObject("frame", {obj=frame, fType=ftype, kfs=not border and true, ofs=ofs or 4, clr="blue"})
		end
		skinFrame(_G.PTR_IssueReporter)
		for _, name in _G.pairs{"Confused", "ReportBug"} do
			_G.PTR_IssueReporter[name]:SetPushedTexture(nil)
			self:removeBackdrop(_G.PTR_IssueReporter[name].Border)
			self:skinObject("button", {obj=_G.PTR_IssueReporter[name], fType=ftype, clr="blue"})
		end

		self:SecureHook(_G.PTR_IssueReporter, "GetStandaloneSurveyFrame", function(this)
			skinFrame(_G.PTR_IssueReporter.StandaloneSurvey, 2) -- header frame
			skinFrame(_G.PTR_IssueReporter.StandaloneSurvey.SurveyFrame)
			if self.modBtns then
				self:skinCloseButton{obj=self:getChild(_G.PTR_IssueReporter.StandaloneSurvey.SurveyFrame, 2), noSkin=true}
				self:skinStdButton{obj=self:getChild(_G.PTR_IssueReporter.StandaloneSurvey.SurveyFrame, 3), ofs=-1, clr="blue"}
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
