if _G.WOW_PROJECT_ID ~= _G.WOW_PROJECT_MAINLINE then return end

local _, aObj = ...

local _G = _G

aObj.SetupRetail_UIFrames = function()
	local ftype = "u"

	-- The following functions are used by the GarrisonUI & OrderHallUI
	local skinPortrait, skinFollower, skinFollowerListButton, skinEquipment, skinFollowerAbilitiesAndCounters, skinFollowerList, skinFollowerPage, skinFollowerTraitsAndEquipment, skinMissionFrame, skinCompleteDialog, skinMissionPage, skinMissionComplete, skinMissionList

	-- [WoD] Enum.Type_6_0_Garrison
	-- [WoD] Enum.Type_6_0_Garrison and C_Garrison.HasShipyard()
	-- [Legion] Enum.Type_7_0_Garrison
	-- [BfA] Enum.Type_8_0_Garrison
	-- [Shadowlands] Enum.Type_9_0_Garrison
	if _G.C_AddOns.IsAddOnLoadOnDemand("Blizzard_GarrisonUI") then
		function skinPortrait(frame)
			if frame.PuckBorder then -- CovenantMissions
				frame.TroopStackBorder1:SetTexture(nil)
				frame.TroopStackBorder2:SetTexture(nil)
				frame.PuckBorder:SetTexture(nil)
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
			-- DON'T add a border to Counters/Abilities buttons
		end
		function skinFollowerListButton(btn, list)
			if list ~= _G.GarrisonShipyardFrameFollowers
			and list ~= _G.GarrisonLandingPageShipFollowerList
			then
				skinFollower(btn.Follower)
			else
				skinFollower(btn)
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
				-- hook to skin Abilities, Counters & Spells
				aObj:SecureHook(frame, "ShowFollower", function(_, _)
					-- Ability buttons
					for ability in frame.abilitiesPool:EnumerateActive() do
						aObj:addButtonBorder{obj=ability.IconButton, reParent={ability.IconButton.Border}}
					end
					-- Counter buttons (Garrison Followers)
					for counters in frame.countersPool:EnumerateActive() do
						aObj:addButtonBorder{obj=counters, relTo=counters.Icon, reParent={counters.Border}}
					end
					-- Spell buttons (Covenant Adventurers)
					for spell in frame.autoSpellPool:EnumerateActive() do
						aObj:addButtonBorder{obj=spell, ftype=ftype, relTo=spell.Icon, ofs=1, clr="white"}
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
			local gOfs, y1Ofs, y2Ofs = 0, -1, 2
			if frame.ElevatedFrame then -- Covenant Missions
				frame.ElevatedFrame:DisableDrawLayer("OVERLAY")
				aObj:removeRegions(frame, {1})
			else
				aObj:removeRegions(frame, {1, 2, not frame.isLandingPage and 3})
			end
			if frame.isLandingPage then
				gOfs, y1Ofs, y2Ofs = 4, 1, 4
			end
			aObj:skinObject("frame", {obj=frame, fType=ftype, kfs=true, fb=true, ofs=gOfs, y1=y1Ofs, x2=4, y2=y2Ofs, clr=colour})
			aObj:skinObject("scrollbar", {obj=frame.ScrollBar, fType=ftype})
			local function skinElement(...)
				local _, element, elementData, new
				if _G.select("#", ...) == 2 then
					element, elementData = ...
				elseif _G.select("#", ...) == 3 then
					element, elementData, new = ...
				else
					_, element, elementData, new = ...
				end
				if new ~= false then
					skinFollowerListButton(element, elementData.followerList)
				end
			end
			_G.ScrollUtil.AddAcquiredFrameCallback(frame.ScrollBox, skinElement, aObj, true)
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
			aObj:skinObject("statusbar", {obj=frame.XPBar, fi=0})
			frame.XPBar:DisableDrawLayer("OVERLAY")
		end
		function skinFollowerTraitsAndEquipment(frame)
			aObj:skinObject("statusbar", {obj=frame.XPBar, fi=0})
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
		function skinMissionFrame(frame, colour)
			--@debug@
			-- _G.Spew("skinMissionFrame", frame)
			--@end-debug@
			local x1Ofs, y1Ofs, x2Ofs, y2Ofs = 2, 2, 1, -4
			if frame == _G.CovenantMissionFrame then
				if frame.textureKit == "thewarwithin" then
					x1Ofs = 5
					y1Ofs = -5
					x2Ofs = -5
					y2Ofs = 4
				else
					x1Ofs = -2
					y1Ofs = 6
					y2Ofs = -5
				end
			elseif frame == _G.BFAMissionFrame then
				y1Ofs = 1
				y2Ofs = -5
			elseif frame == _G.OrderHallMissionFrame then
				y2Ofs = -3
			end
			frame.GarrCorners:DisableDrawLayer("BACKGROUND")
			aObj:skinObject("tabs", {obj=frame, prefix=frame:GetName(), fType=ftype, selectedTab=frame.selectedTab, lod=aObj.isTT and true, regions={7, 8, 9, 10}})
			-- set FrameStrata to "LOW" to allow map textures to be visible
			aObj:skinObject("frame", {obj=frame, fType=ftype, kfs=true, bg=true, sfs="LOW", cbns=true, x1=x1Ofs, y1=y1Ofs, x2=x2Ofs, y2=y2Ofs, clr=colour})
		end
		function skinCompleteDialog(frame, naval)
			if not naval then
				frame:ClearAllPoints()
				frame:SetPoint("TOPLEFT", -28, 42)
			else
				aObj:moveObject{obj=frame, x=4, y=20}
				_G.RaiseFrameLevelByTwo(frame) -- raise above markers on mission frame
			end
			frame:SetSize(naval and 935 or 948, _G.C_AddOns.IsAddOnLoaded("GarrisonCommander") and 640 or naval and 648 or 630)
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
				for _, e in _G.pairs(frame.Enemies) do
					if e.PortraitFrame then
						e.PortraitFrame.PortraitRing:SetTexture(nil)
					else
						e.PortraitRing:SetTexture(nil)
					end
				end
				for _, f in _G.pairs(frame.Followers ) do
					if f.PortraitFrame then
						aObj:removeRegions(f, {1})
						skinPortrait(f.PortraitFrame)
					end
					if f.DurabilityBackground then
						f.DurabilityBackground:SetTexture(nil)
					end
				end
			end
			if frame.FollowerModel then
				aObj:moveObject{obj=frame.FollowerModel, x=-6, y=0}
			end
			if not _G.C_AddOns.IsAddOnLoaded("MasterPlan") then
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
			for _, flwr in _G.pairs(frame.Stage.FollowersFrame.Followers) do
		        if naval then
		            flwr.NameBG:SetTexture(nil)
		        else
		            aObj:removeRegions(flwr, {1})
					flwr.DurabilityBackground:SetTexture(nil)
		        end
				if flwr.PortraitFrame then
					skinPortrait(flwr.PortraitFrame)
				end
				aObj:skinObject("statusbar", {obj=flwr.XP, fi=0})
				flwr.XP:DisableDrawLayer("OVERLAY")
			end
		    frame.BonusRewards:DisableDrawLayer("BACKGROUND")
			frame.BonusRewards:DisableDrawLayer("BORDER")
			aObj:getRegion(frame.BonusRewards, 11):SetTextColor(aObj.HT:GetRGB()) -- Heading
		    frame.BonusRewards.Saturated:DisableDrawLayer("BACKGROUND")
			frame.BonusRewards.Saturated:DisableDrawLayer("BORDER")
			for _, r in _G.pairs(frame.BonusRewards.Rewards) do
				aObj:addButtonBorder{obj=r, relTo=r.Icon, reParent={r.Quantity}}
			end
			aObj:skinObject("frame", {obj=frame, fType=ftype, x1=3, y1=6, y2=-16})
			if aObj.modBtns then
				aObj:skinStdButton{obj=frame.NextMissionButton, fType=ftype, schk=true}
			end
			for _, e in _G.pairs(frame.Stage.EncountersFrame.Encounters) do
				if not naval then
					e.Ring:SetTexture(nil)
				else
					e.PortraitRing:SetTexture(nil)
				end
			end
		    aObj:removeRegions(frame.Stage.MissionInfo, naval and {1, 2, 3, 4, 5, 8, 9, 10} or {1, 2, 3, 4, 5, 11, 12, 13})
			frame.Stage.MissionInfo.IconBG:SetTexture(nil)
		end
		function skinMissionList(ml, tabOfs, colour)
			ml.MaterialFrame:DisableDrawLayer("BACKGROUND")
			aObj:skinObject("frame", {obj=ml, fType=ftype, kfs=true, fb=true, ofs=1, x2=4, clr=colour})
			if ml.RaisedFrameEdges then -- CovenantMissions
				ml.RaisedFrameEdges:DisableDrawLayer("BORDER")
				ml.MaterialFrame.LeftFiligree:SetTexture(nil)
				ml.MaterialFrame.RightFiligree:SetTexture(nil)
			else
				-- Top Tabs
				aObj:skinObject("tabs", {obj=ml, prefix=ml:GetName(), fType=ftype, numTabs=2, ignoreHLTex=false, upwards=true, lod=aObj.isTT and true, regions={7, 8, 9}, offsets={x1=tabOfs and tabOfs * -1 or nil, y1=tabOfs or -6, x2=tabOfs or nil, y2=aObj.isTT and 3 or 8}, track=false})
				if not aObj.isTT then
					if ml.UpdateMissions then
						aObj:clrBBC(ml.Tab2.sf, not ml.Tab2:IsEnabled() and "disabled")
						aObj:SecureHook(ml.Tab2, "SetEnabled", function(bObj, state)
							aObj:clrBBC(bObj.sf, not state and "disabled")
						end)
					end
				end
			end
			aObj:skinObject("scrollbar", {obj=ml.ScrollBar, fType=ftype})
			local function skinElement(...)
				local _, element, new
				if _G.select("#", ...) == 2 then
					element, _ = ...
				elseif _G.select("#", ...) == 3 then
					element, _, new = ...
				else
					_, element, _, new = ...
				end
				if new ~= false then
					element:DisableDrawLayer("BACKGROUND")
					element:DisableDrawLayer("BORDER")
					element.LocBG:SetTexture(nil)
					if element.RareOverlay then
						element.RareOverlay:SetTexture(nil)
						-- extend the top & bottom highlight texture
						element.HighlightT:ClearAllPoints()
						element.HighlightT:SetPoint("TOPLEFT", 0, 4)
						element.HighlightT:SetPoint("TOPRIGHT", 0, 4)
				        element.HighlightB:ClearAllPoints()
				        element.HighlightB:SetPoint("BOTTOMLEFT", 0, -4)
				        element.HighlightB:SetPoint("BOTTOMRIGHT", 0, -4)
						-- remove highlight corners
						element.HighlightTL:SetTexture(nil)
						element.HighlightTR:SetTexture(nil)
						element.HighlightBL:SetTexture(nil)
						element.HighlightBR:SetTexture(nil)
					end
				end
			end
			_G.ScrollUtil.AddAcquiredFrameCallback(ml.ScrollBox, skinElement, aObj, true)
			-- CompleteDialog
			skinCompleteDialog(ml.CompleteDialog)
		end
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
			self:skinObject("scrollbar", {obj=this.Details.ScrollBar, fType=ftype})
			this.Details.Child.TitleHeader:SetTextColor(self.HT:GetRGB())
			this.Details.Child.DescriptionText:SetTextColor(self.BT:GetRGB())
			this.Details.Child.ObjectivesHeader:SetTextColor(self.HT:GetRGB())
			this.Details.Child.ObjectivesText:SetTextColor(self.BT:GetRGB())
			if this.CloseButton:GetNormalTexture() then
				this.CloseButton:GetNormalTexture():SetTexture(nil) -- frame is animated in
			end
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, y1=-12, x2=0, y2=-4})
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
					self:addButtonBorder{obj=reward, relTo=reward.Icon}
				end
			end)
		end

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
				self:skinStdButton{obj=this.ReinforceInfoFrame.AnimaNodeReinforceButton, fType=ftype, schk=true}
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

	aObj.blizzLoDFrames[ftype].BehavioralMessaging = function(self)
		if not self.prdb.GMChatUI or self.initialized.BehavioralMessaging then return end

		if not _G.BehavioralMessagingDetails then
			_G.C_Timer.After(0.1, function()
				self.blizzLoDFrames[ftype].BehavioralMessaging(self)
			end)
			return
		end

		self.initialized.BehavioralMessaging = true

		-- TODO: skin notification pool entries for BehavioralMessagingTray ?

		self:SecureHookScript(_G.BehavioralMessagingDetails, "OnShow", function(this)
			self:removeNineSlice(this.Border)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true})
			if self.modBtns then
				self:skinStdButton{obj=this.CloseButton, fType=ftype}
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].BossBannerToast = function(self)
		if not self.prdb.BossBannerToast or self.initialized.BossBannerToast then return end
		self.initialized.BossBannerToast = true

		self:SecureHookScript(_G.BossBanner, "OnShow", function(this)
			this:DisableDrawLayer("BORDER")
			this:DisableDrawLayer("BACKGROUND")
			this.BottomFillagree:SetTexture(nil)
			this.SkullSpikes:SetTexture(nil)
			this.RightFillagree:SetTexture(nil)
			this.LeftFillagree:SetTexture(nil)

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzLoDFrames[ftype].ChallengesUI = function(self)
		if not self.prdb.PVEFrame or self.initialized.ChallengesUI then return end
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
			self:skinObject("frame", {obj=this, fType=ftype, cb=true, ofs=-7})
			if self.modBtns then
				self:skinStdButton{obj=this.StartButton}
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=this.KeystoneSlot}
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.ChallengesFrame, "OnShow", function(this)
			this:DisableDrawLayer("BACKGROUND")
			_G.ChallengesFrameInset.Bg:SetTexture(nil)
			self:removeNineSlice(_G.ChallengesFrameInset.NineSlice)
			this.WeeklyInfo.Child:DisableDrawLayer("BACKGROUND")
			if this.WeeklyInfo.Child.AffixesContainer.Affixes then
				for _, affix in _G.pairs(this.WeeklyInfo.Child.AffixesContainer.Affixes) do
					affix.Border:SetTexture(nil)
				end
			end
			local scnf = this.SeasonChangeNoticeFrame
			scnf.NewSeason:SetTextColor(self.HT:GetRGB())
			scnf.SeasonDescription:SetTextColor(self.BT:GetRGB())
			scnf.SeasonDescription2:SetTextColor(self.BT:GetRGB())
			scnf.SeasonDescription3:SetTextColor(self.BT:GetRGB())
			scnf.Affix.AffixBorder:SetTexture(nil)
			self:skinObject("frame", {obj=scnf, fType=ftype, kfs=true, ofs=-15, y2=20})
			self:RaiseFrameLevelByFour(scnf)
			if self.modBtns then
				self:skinStdButton{obj=scnf.Leave}
			end
			if self.modBtnBs then
				for _, dungeon in _G.ipairs(this.DungeonIcons) do
					self:addButtonBorder{obj=dungeon, fType=ftype, ofs=3, clr="disabled"}
					self:SecureHook(dungeon, "SetUp", function(bObj, mapInfo, _)
						if mapInfo.level > 0 then
							bObj.sbb:SetBackdropBorderColor(bObj.HighestLevel:GetTextColor())
						else
							self:clrBtnBdr(bObj, "disabled")
						end
					end)
				end
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].ChatButtons = function(self)
		if not self.prdb.ChatButtons or self.initialized.ChatButtons then return end
		self.initialized.ChatButtons = true

		-- QuickJoinToastButton & frames (attached to ChatFrame)
		if self.modBtnBs then
			for i = 1, _G.NUM_CHAT_WINDOWS do
				self:addButtonBorder{obj=_G["ChatFrame" .. i].buttonFrame.minimizeButton, ofs=-2}
				_G["ChatFrame" .. i].buttonFrame.sknd = true
			end
			self:addButtonBorder{obj=_G.ChatFrameChannelButton, ofs=0}
			self:addButtonBorder{obj=_G.ChatFrameToggleVoiceDeafenButton, ofs=0}
			self:addButtonBorder{obj=_G.ChatFrameToggleVoiceMuteButton, ofs=0}
			self:addButtonBorder{obj=_G.ChatFrameMenuButton, ofs=-2, x1=1}
			self:addButtonBorder{obj=_G.TextToSpeechButton, ofs=1}
			-- QuickJoinToastButton(s)
			self:addButtonBorder{obj=_G.QuickJoinToastButton, x1=1, y1=2, x2=-2, y2=-2}
			for _, type in _G.pairs{"Toast", "Toast2"} do
				_G.QuickJoinToastButton[type]:DisableDrawLayer("BACKGROUND")
				self:moveObject{obj=_G.QuickJoinToastButton[type], x=7}
				_G.QuickJoinToastButton[type]:Hide()
				self:skinObject("frame", {obj=_G.QuickJoinToastButton[type], fType=ftype})
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
			self:skinObject("scrollbar", {obj=this.ChannelList.ScrollBar, fType=ftype})
			self:skinObject("scrollbar", {obj=this.ChannelRoster.ScrollBar, fType=ftype})
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
			self:skinObject("frame", {obj=_G.CreateChannelPopup, fType=ftype, kfs=true, hdr=true, cb=true})

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

	aObj.blizzFrames[ftype].ChatTemporaryWindow = function(self)
		if not self.prdb.ChatTabs
		and not self.prdb.ChatFrames
		and not self.prdb.ChatEditBox.skin
		then
			return
		end

		local function skinChatEB(obj)
			aObj:keepFontStrings(obj)
			aObj:getRegion(obj, 2):SetAlpha(1) -- cursor texture
			if aObj.prdb.ChatEditBox.style == 1 then -- Frame
				aObj:skinObject("frame", {obj=obj, fType=ftype, ofs=-2})
			elseif aObj.prdb.ChatEditBox.style == 2 then -- Editbox
				aObj:skinObject("editbox", {obj=obj, fType=ftype, regions={}, ofs=-4})
			else -- Borderless
				aObj:skinObject("frame", {obj=obj, fType=ftype, noBdr=true, ofs=-5, y=2})
			end
			obj.sf:SetAlpha(obj:GetAlpha())
		end
		local function skinTempWindow(obj)
			if aObj.prdb.ChatTabs then
				-- Top Tabs
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
				aObj:addButtonBorder{obj=obj.buttonFrame.minimizeButton, ofs=-2}
				aObj:addButtonBorder{obj=obj.ScrollToBottomButton, ofs=-1, x1=0}
			end
		end
		-- hook this to handle Temporary windows (BN Conversations, Pet Battles etc)
		self:RawHook("FCF_OpenTemporaryWindow", function(...)
			local frame = self.hooks.FCF_OpenTemporaryWindow(...)
			skinTempWindow(frame)
			return frame
		end, true)
		-- skin any existing temporary windows
		for _, cf in _G.pairs(_G.CHAT_FRAMES) do
			if _G[cf].isTemporary then
				skinTempWindow(_G[cf])
			end
		end

	end

	aObj.blizzLoDFrames[ftype].ClassTrial = function(self)
		if not self.prdb.ClassTrial or self.initialized.ClassTrial then return end
		self.initialized.ClassTrial = true

		-- N.B. ClassTrialSecureFrame can't be skinned, as the XML has a ScopedModifier element saying forbidden=""

		self:SecureHookScript(_G.ClassTrialThanksForPlayingDialog, "OnShow", function(this)
			this.ThanksText:SetTextColor(self.HT:GetRGB())
			this.ClassNameText:SetTextColor(self.HT:GetRGB())
			this.DialogText:SetTextColor(self.HT:GetRGB())
			this.DialogFrame:SetTexture(nil)
			self:skinObject("frame", {obj=this, fType=ftype, x1=600, y1=-100, x2=-600, y2=500})
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
			self:skinObject("frame", {obj=this, fType=ftype})

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzLoDFrames[ftype].ClickBindingUI = function(self)
		if not self.prdb.BindingUI or self.initialized.ClickBindingUI then return end
		self.initialized.ClickBindingUI = true

		self:SecureHookScript(_G.ClickBindingFrame, "OnShow", function(this)
			self:removeBackdrop(this.ScrollBoxBackground)
			self:skinObject("scrollbar", {obj=this.ScrollBar, fType=ftype})
			local function skinElement(...)
				local _, element, new
				if _G.select("#", ...) == 2 then
					element, _ = ...
				elseif _G.select("#", ...) == 3 then
					element, _, new = ...
				else
					_, element, _, new = ...
				end
				if new ~= false then
					if element.DeleteButton then
						aObj:removeRegions(element, {1}) -- background
						if aObj.modBtns	then
							aObj:skinStdButton{obj=element.DeleteButton, fType=ftype}
						end
						if aObj.modBtnBs then
							aObj:addButtonBorder{obj=element, fType=ftype, relTo=element.Icon}
						end
					end
				end
			end
			_G.ScrollUtil.AddAcquiredFrameCallback(this.ScrollBox, skinElement, aObj, true)
			this.MacrosPortrait:DisableDrawLayer("OVERLAY")
			this.SpellbookPortrait:DisableDrawLayer("OVERLAY")
			this.TutorialFrame.Tutorial:SetDrawLayer("ARTWORK") -- make background visible
			this.TutorialButton.Ring:SetTexture(nil)
			self:moveObject{obj=this.TutorialButton, y=-4}
			self:skinObject("frame", {obj=this.TutorialFrame, fType=ftype, rns=true, cb=true, ofs=3, y1=2}) -- DON'T remove artwork
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, rns=true, cb=true})
			if self.modBtns then
				self:skinStdButton{obj=this.SaveButton, fType=ftype}
				self:skinStdButton{obj=this.AddBindingButton, fType=ftype, sechk=true}
				self:skinStdButton{obj=this.ResetButton, fType=ftype}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=this.EnableMouseoverCastCheckbox, fType=ftype}
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].ColorPicker = function(self)
		if not self.prdb.ColorPicker or self.initialized.ColorPicker then return end
		self.initialized.ColorPicker = true

		self:SecureHookScript(_G.ColorPickerFrame, "OnShow", function(this)
			self:removeNineSlice(this.Border)
			self:skinObject("editbox", {obj=this.Content.HexBox, fType=ftype})
			self:skinObject("frame", {obj=this, fType=ftype, hdr=true, ofs=0})
			if self.modBtns then
				self:skinStdButton{obj=this.Footer.CancelButton}
				self:skinStdButton{obj=this.Footer.OkayButton}
			end

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

			-- PTR
				-- .CheatBrowserToggle
				-- .MessageFrame
				-- .ResizeButton

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
				self:skinObject("statusbar", {obj=contribution.State, fi=0})
				contribution.Status.Border:SetTexture(nil)
				contribution.Status.BG:SetTexture(nil)
				contribution.Description:SetTextColor(self.BT:GetRGB())
				self:skinStdButton{obj=contribution.ContributeButton}
			end
			for reward in this.rewardPool:EnumerateActive() do
				reward.RewardName:SetTextColor(self.BT:GetRGB())
			end
			this.CloseButton.CloseButtonBackground:SetTexture(nil)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, ofs=-21, x2=-18})

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
			_G.RaiseFrameLevelByTwo(this)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ofs=-1, y1=-2})
			if self.modBtns then
				self:skinCloseButton{obj=this.CloseXButton}
				self:skinStdButton{obj=this.CloseButton}
			end
			if self.modBtnBs then
				for i = 1, _G.NUM_DEATH_RECAP_EVENTS do
					self:addButtonBorder{obj=this["Recap" .. i].SpellInfo, fType=ftype, relTo=this["Recap" .. i].SpellInfo.Icon, clr="gold"}
				end
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].DelvesCompanionConfiguration = function(self)
		if not self.prdb.DelvesUI or self.initialized.DelvesCompanionConfiguration then return end
		self.initialized.DelvesCompanionConfiguration = true

		self:SecureHookScript(_G.DelvesCompanionConfigurationFrame, "OnShow", function(this)
			self:keepFontStrings(this.Border)
			this.CompanionPortraitFrame.Border:SetTexture(nil)
			-- .CompanionExperienceRingFrame
			self:keepFontStrings(this.CompanionLevelFrame)
			this.CompanionInfoFrame.InfoFrameShadow:SetTexture(nil)
			-- this.CompanionInfoFrame.CompanionInfoGLine:SetTexture(nil)
			_G.CompanionInfoGLine:SetTexture(nil) -- FIXME: Blizzard bug? using name instead of parentKey
			self:skinObject("frame", {obj=this.CompanionCombatRoleSlot.OptionsList, kfs=true, ofs=4, y2=-5})
			self:skinObject("frame", {obj=this.CompanionCombatTrinketSlot.OptionsList, kfs=true, ofs=4, y2=-5})
			self:skinObject("frame", {obj=this.CompanionUtilityTrinketSlot.OptionsList, kfs=true, ofs=4, y2=-5})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, ofs=4})
			self:moveObject{obj=this.CloseButton, x=-3, y=-4}
			if self.modBtns then
				self:skinStdButton{obj=this.CompanionConfigShowAbilitiesButton, fType=ftype, schk=true, sechk=true}
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.DelvesCompanionAbilityListFrame, "OnShow", function(this)
			self:skinObject("ddbutton", {obj=this.DelvesCompanionRoleDropdown, fType=ftype})
			self:skinPagingControls(this.DelvesCompanionAbilityListPagingControls)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true})
			if self.modBtnBs then
				local function skinAbilityButtons()
					for _, btn in _G.ipairs(this.buttons) do
						aObj:addButtonBorder{obj=btn, fType=ftype, libt=true, clr=btn.nodeInfo.activeRank > 0 and "white"}
					end
				end
				self:SecureHook(this, "Refresh", function(_, _, _)
					skinAbilityButtons()
				end)
				skinAbilityButtons()
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzLoDFrames[ftype].DelvesDifficultyPicker = function(self)
		if not self.prdb.DelvesUI or self.initialized.DelvesDifficultyPicker then return end
		self.initialized.DelvesDifficultyPicker = true

		self:SecureHookScript(_G.DelvesDifficultyPickerFrame, "OnShow", function(this)
			self:keepFontStrings(this.Border)
			self:skinObject("ddbutton", {obj=this.Dropdown, fType=ftype})
			-- .DelveModifiersWidgetContainer
			-- .DelveBackgroundWidgetContainer
			local function skinRewardBtns()
				for btn in this.DelveRewardsContainerFrame.rewardPool:EnumerateActive() do
					btn.NameFrame:SetTexture(nil)
					if self.modBtnBs then
						self:addButtonBorder{obj=btn, libt=true, relTo=btn.Icon}
					end
				end
			end
			self:SecureHook(this.DelveRewardsContainerFrame, "SetRewards", function(_)
				skinRewardBtns()
			end)
			_G.C_Timer.After(0.5, function() -- wait for buttons to be setup
				skinRewardBtns()
			end)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, cb=true, ofs=4})
			self:moveObject{obj=this.CloseButton, x=-3, y=-1}
			if self.modBtns then
				self:skinStdButton{obj=this.EnterDelveButton, fType=ftype, sechk=true}
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzLoDFrames[ftype].DelvesDashboardUI = function(self)
		if not self.prdb.DelvesUI
		or not self.prdb.PVEFrame
		or self.initialized.DelvesDashboardUI
		then
			return
		end
		self.initialized.DelvesDashboardUI = true

		self:SecureHookScript(_G.DelvesDashboardFrame, "OnShow", function(this)
			this.DashboardBackground:SetPoint("TOPLEFT", this, 0, -20)
			this.ThresholdBar.BarBorder:SetTexture(nil)
			self:skinObject("statusbar", {obj=this.ThresholdBar, fi=0, bg=this.ThresholdBar.BarBackground})
			this.ThresholdBar.Threshold10.Reward.IconBorder:SetTexture(nil)
			local bplf = this.ButtonPanelLayoutFrame
			self:skinObject("frame", {obj=bplf.CompanionConfigButtonPanel, fType=ftype, kfs=true, fb=true, ofs=0})
			self:skinObject("frame", {obj=bplf.GreatVaultButtonPanel, fType=ftype, kfs=true, fb=true, ofs=0})
			if self.modBtns then
				self:skinStdButton{obj=bplf.CompanionConfigButtonPanel.CompanionConfigButton, fType=ftype, sechk=true}
			end

			self:Unhook(this, "OnShow")
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

	aObj.blizzFrames[ftype].EditMode = function(self)
		if not self.prdb.EditMode or self.initialized.EditMode then return end
		self.initialized.EditMode = true

		self:SecureHookScript(_G.EditModeManagerFrame, "OnShow", function(this)
			self:removeNineSlice(this.Border)
			this.Tutorial.Ring:SetTexture(nil)
			self:skinObject("ddbutton", {obj=this.LayoutDropdown, fType=ftype})
			self:skinObject("slider", {obj=this.GridSpacingSlider.Slider.Slider, fType=ftype, y1=-8, y2=8})
			this.AccountSettings.Expander.Divider:SetTexture(nil)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true})
			if self.modBtns then
				self:skinStdButton{obj=this.SaveChangesButton, fType=ftype, sechk=true}
				self:skinStdButton{obj=this.RevertAllChangesButton, fType=ftype, sechk=true}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=this.ShowGridCheckButton.Button, fType=ftype}
				self:skinCheckButton{obj=this.EnableSnapCheckButton.Button, fType=ftype}
				self:skinCheckButton{obj=this.EnableAdvancedOptionsCheckButton.Button, fType=ftype}
				self:removeNineSlice(this.AccountSettings.SettingsContainer.BorderArt)
				self:skinObject("frame", {obj=this.AccountSettings.SettingsContainer, fType=ftype, kfs=true, fb=true, ofs=3})
				for _, frame in _G.pairs(this.AccountSettings.settingsCheckButtons) do
					self:skinCheckButton{obj=frame.Button, fType=ftype}
				end
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.EditModeNewLayoutDialog, "OnShow", function(fObj)
			self:removeNineSlice(fObj.Border)
			self:skinObject("editbox", {obj=fObj.LayoutNameEditBox, fType=ftype, y1=-4, y2=4})
			self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, ofs=-6})
			if self.modBtns then
				self:skinStdButton{obj=fObj.AcceptButton, fType=ftype, sechk=true}
				self:skinStdButton{obj=fObj.CancelButton, fType=ftype}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=fObj.CharacterSpecificLayoutCheckButton.Button, fType=ftype}
			end

			self:Unhook(fObj, "OnShow")
		end)

		self:SecureHookScript(_G.EditModeImportLayoutDialog, "OnShow", function(fObj)
			self:removeNineSlice(fObj.Border)
			self:skinObject("frame", {obj=fObj.ImportBox, fType=ftype, kfs=true, fb=true, ofs=6})
			self:skinObject("editbox", {obj=fObj.LayoutNameEditBox, fType=ftype, y1=-4, y2=4})
			self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, ofs=-6})
			if self.modBtns then
				self:skinStdButton{obj=fObj.AcceptButton, fType=ftype, sechk=true}
				self:skinStdButton{obj=fObj.CancelButton, fType=ftype}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=fObj.CharacterSpecificLayoutCheckButton.Button, fType=ftype}
			end

			self:Unhook(fObj, "OnShow")
		end)

		self:SecureHookScript(_G.EditModeImportLayoutLinkDialog, "OnShow", function(fObj)
			self:removeNineSlice(fObj.Border)
			self:skinObject("editbox", {obj=fObj.LayoutNameEditBox, fType=ftype, y1=-4, y2=4})
			self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, ofs=-6})
			if self.modBtns then
				self:skinStdButton{obj=fObj.AcceptButton, fType=ftype, sechk=true}
				self:skinStdButton{obj=fObj.CancelButton, fType=ftype}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=fObj.CharacterSpecificLayoutCheckButton.Button, fType=ftype}
			end

			self:Unhook(fObj, "OnShow")
		end)

		self:SecureHookScript(_G.EditModeUnsavedChangesDialog, "OnShow", function(fObj)
			self:removeNineSlice(fObj.Border)
			self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, ofs=-6})
			if self.modBtns then
				self:skinStdButton{obj=fObj.SaveAndProceedButton, fType=ftype}
				self:skinStdButton{obj=fObj.ProceedButton, fType=ftype}
				self:skinStdButton{obj=fObj.CancelButton, fType=ftype}
			end

			self:Unhook(fObj, "OnShow")
		end)

		self:SecureHookScript(_G.EditModeSystemSettingsDialog, "OnShow", function(fObj)
			self:removeNineSlice(fObj.Border)
			self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, cb=true, y2=14})
			if self.modBtns then
				self:skinStdButton{obj=fObj.Buttons.RevertChangesButton, fType=ftype, sechk=true}
			end
			local function skinSettingsAndButtons(frame)
				for dropdown in frame.pools:EnumerateActiveByTemplate("EditModeSettingDropdownTemplate") do
					aObj:skinObject("ddbutton", {obj=dropdown.Dropdown, fType=ftype})
				end
				for slider in frame.pools:EnumerateActiveByTemplate("EditModeSettingSliderTemplate") do
					aObj:skinObject("slider", {obj=slider.Slider.Slider, fType=ftype, y1=-8, y2=8})
				end
				if aObj.modChkBtns then
					for checkbox in frame.pools:EnumerateActiveByTemplate("EditModeSettingCheckboxTemplate") do
						aObj:skinCheckButton{obj=checkbox.Button, fType=ftype}
					end
				end
				if aObj.modBtns then
					for button in frame.pools:EnumerateActiveByTemplate("EditModeSystemSettingsDialogExtraButtonTemplate") do
						aObj:skinStdButton{obj=button, fType=ftype, schk=true}
					end
				end
			end
			skinSettingsAndButtons(fObj)
			self:SecureHook(fObj, "UpdateDialog", function(frame, _)
				skinSettingsAndButtons(frame)
			end)

			self:Unhook(fObj, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].EventToastManager = function(self)
		if not self.prdb.EventToastManager or self.initialized.EventToastManager then return end
		self.initialized.EventToastManager = true

		local function skinToast(frame)
			if not frame:IsShown() then
				return
			end
			local toast = frame.currentDisplayingToast
			toast:DisableDrawLayer("BACKGROUND")
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
		skinToast(_G.EventToastManagerFrame)

		self:SecureHook(_G.EventToastManagerFrame, "DisplayToast", function(this, _)
			skinToast(this)
		end)

		self:SecureHookScript(_G.EventToastManagerFrame, "OnShow", function(this)
			this:DisableDrawLayer("BACKGROUND")

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.EventToastManagerFrame)

		self:SecureHookScript(_G.EventToastManagerSideDisplay, "OnShow", function(this)
			this.BlackBG:SetAtlas(nil)

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.EventToastManagerSideDisplay)

	end

	aObj.blizzLoDFrames[ftype].ExpansionLandingPage = function(self)
		if not self.prdb.ExpansionLandingPage or self.initialized.ExpansionLandingPage then return end
		self.initialized.ExpansionLandingPage = true

		local function skinOverlay(_, oFrame)
			oFrame = oFrame or _G.ExpansionLandingPage.overlayFrame
			if oFrame.Border then
				oFrame.Border:DisableDrawLayer("OVERLAY")
			end
			oFrame.Header.TitleDivider:SetTexture(nil)
			if oFrame.MajorFactionList then
				oFrame.ScrollFadeOverlay:DisableDrawLayer("ARTWORK")
				aObj:skinObject("scrollbar", {obj=oFrame.MajorFactionList.ScrollBar, fType=ftype})
				local function skinElement(...)
					local _, element, new
					if _G.select("#", ...) == 2 then
						element, _ = ...
					elseif _G.select("#", ...) == 3 then
						element, _, new = ...
					else
						_, element, _, new = ...
					end
					if new ~= false then
						element.LockedState:DisableDrawLayer("BACKGROUND")
						element.UnlockedState:DisableDrawLayer("BACKGROUND")
						aObj:skinObject("frame", {obj=element, fType=ftype, fb=true, x1=29, x2=-29, y2=0, ca=0.35})
						if aObj.modChkBtns then
							aObj:skinCheckButton{obj=element.UnlockedState.WatchFactionButton, fType=ftype}
							element.UnlockedState.WatchFactionButton:SetSize(20, 20)
						end
					end
				end
				_G.ScrollUtil.AddAcquiredFrameCallback(oFrame.MajorFactionList.ScrollBox, skinElement, aObj, true)
			end
			if oFrame.DragonridingPanel then
				aObj:skinObject("frame", {obj=oFrame.DragonridingPanel, fType=ftype, fb=true, y1=-1, x2=-1, y2=11})
				if aObj.modBtns then
					aObj:skinStdButton{obj=oFrame.DragonridingPanel.SkillsButton, fType=ftype}
				end
			end
			aObj:skinObject("frame", {obj=oFrame, fType=ftype, kfs=true, cbns=true})
		end
		_G.EventRegistry:RegisterCallback("ExpansionLandingPage.OverlayChanged", skinOverlay, aObj)

		self:SecureHookScript(_G.ExpansionLandingPage, "OnShow", function(this)
			skinOverlay(self, this.overlayFrame)

			self:Unhook(this, "OnShow")
		end)

	end

	-- this code handles the ExtraActionBarFrame and ZoneAbilityFrame buttons
	aObj.blizzFrames[ftype].ExtraAbilityContainer = function(self)
		if self.initialized.ExtraAbilityContainer then return end
		self.initialized.ExtraAbilityContainer = true

		local function skinBtn(opts)
			if opts.obj.NormalTexture then
				opts.obj:GetNormalTexture():SetTexture(nil)
			end
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=opts.obj, sabt=true, reParent={opts.obj.HotKey, opts.obj.Count, opts.obj.Flash, opts.obj.style, opts.obj.cooldown}, ofs=2}
			end
		end
		if self.prdb.MainMenuBar.extraab then
			self:SecureHookScript(_G.ExtraActionBarFrame.intro, "OnFinished", function(_)
				_G.ExtraActionBarFrame.button.style:SetAlpha(0)
			end)
			if self:canSkin(skinBtn, {obj=_G.ExtraActionBarFrame.button}) then
				skinBtn({obj=_G.ExtraActionBarFrame.button})
			end
		end
		if self.prdb.ZoneAbility then
			local function getAbilities(frame)
				frame.Style:SetAlpha(0)
				for btn in frame.SpellButtonContainer:EnumerateActive() do
					if aObj:canSkin(skinBtn, {obj=btn}) then
						skinBtn({obj=btn})
					end
				end
			end
			self:SecureHook(_G.ZoneAbilityFrame, "UpdateDisplayedZoneAbilities", function(this)
				getAbilities(this)
			end)
			if _G.ZoneAbilityFrame:IsShown() then
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

		if aObj.isTT then
			aObj:SecureHook("GarrisonMissonListTab_SetSelected", function(tab, isSelected)
				if tab.sf then
					if isSelected then
						aObj:setActiveTab(tab.sf)
					else
						aObj:setInactiveTab(tab.sf)
					end
				end
			end)
		end

		self:SecureHookScript(_G.GarrisonLandingPage, "OnShow", function(this)
			this.HeaderBar:SetTexture(nil)
			self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true, regions={7, 8, 9, 10}})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, ofs=-10, y2=18})

			self:SecureHookScript(this.Report, "OnShow", function(fObj)
				fObj.List:DisableDrawLayer("BACKGROUND")
				self:skinObject("scrollbar", {obj=fObj.List.ScrollBar, fType=ftype})
				self:skinObject("frame", {obj=fObj.List, fType=ftype, fb=true, y1=4})
				local function skinElement(...)
					local _, element, new
					if _G.select("#", ...) == 2 then
						element, _ = ...
					elseif _G.select("#", ...) == 3 then
						element, _, new = ...
					else
						_, element, _, new = ...
					end
					if new ~= false then
						element:DisableDrawLayer("BACKGROUND")
						element:DisableDrawLayer("BORDER")
						if aObj.modBtnBs then
							for _, reward in _G.pairs(element.Rewards) do
								aObj:addButtonBorder{obj=reward, relTo=reward.Icon, reParent={reward.Quantity}}
								aObj:clrButtonFromBorder(reward)
							end
						end
					end
				end
				_G.ScrollUtil.AddAcquiredFrameCallback(fObj.List.ScrollBox, skinElement, aObj, true)
				-- Top Tabs
				self:skinObject("tabs", {obj=fObj, tabs={fObj.InProgress, fObj.Available}, fType=ftype, lod=self.isTT and true, upwards=true, offsets={x1=4, y1=self.isTT and -4 or -5, x2=-4, y2=self.isTT and -4 or 1}, regions={2, 3}, track=false, func=function(tab) tab:GetNormalTexture():SetAlpha(0) tab:SetFrameLevel(20) end})
				if self.isTT then
					self:SecureHook("GarrisonLandingPageReport_SetTab", function(tab)
						self:setInactiveTab(tab:GetParent().unselectedTab.sf)
						self:setActiveTab(tab.sf)
					end)
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.Report)

			skinFollowerList(this.FollowerList)
			skinFollowerPage(this.FollowerTab)

			if this.garrTypeID == _G.Enum.GarrisonType.Type_6_0_Garrison and _G.C_Garrison.HasShipyard() then
				skinFollowerList(this.ShipFollowerList)
				skinFollowerTraitsAndEquipment(this.ShipFollowerTab)
			elseif _G.C_Garrison.GetLandingPageGarrisonType() == _G.Enum.GarrisonType.Type_9_0_Garrison then -- Covenant
				local function skinPanelBtns(panel)
					panel:DisableDrawLayer("BACKGROUND")
					aObj:skinObject("frame", {obj=panel.RenownButton, fType=ftype, regions={3, 5, 6}, ofs=-4, y1=-5, y2=3, clr="turq", ca=0.25})
					panel.RenownButton.UpdateButtonTextures = _G.nop
					aObj:skinObject("frame", {obj=panel.SoulbindButton, fType=ftype, regions={1, 2}, ofs=-4, y1=-5, y2=3, clr="turq", ca=0.25})
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
				self:removeRegions(this.CovenantCallings, {1, 2})
				if _G.C_ArdenwealdGardening.IsGardenAccessible() then
					self:getRegion(this.ArdenwealdGardeningPanel, 1):SetTexture(nil)
					self:getChild(this.ArdenwealdGardeningPanel, 1).Border:SetTexture(nil)
				end
			end

			-- N.B. Garrison Landing Page Minimap Button skinned with other minimap buttons
			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.GarrisonLandingPage)

		if _G.GarrisonLandingPageTutorialBox then
			self:skinObject("glowbox", {obj=_G.GarrisonLandingPageTutorialBox, fType=ftype})
		end

		self:SecureHookScript(_G.GarrisonBuildingFrame, "OnShow", function(this)
			self:skinMainHelpBtn(this)
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
			local function skinBLbuttons()
				for _, btn in _G.pairs(_G.GarrisonBuildingFrame.BuildingList.Buttons) do
					btn.BG:SetTexture(nil)
					if aObj.modBtnBs then
						aObj:addButtonBorder{obj=btn, relTo=btn.Icon}
						if btn.info.needsPlan then
							aObj:clrBtnBdr(btn, "grey")
						else
							aObj:clrBtnBdr(btn)
						end
					end
				end
			end
			self:SecureHookScript(_G.GarrisonBuildingFrame.BuildingList, "OnShow", function(fObj)
				skinBLbuttons()
				self:SecureHook("GarrisonBuildingList_SelectTab", function(_)
					clrTabText()
					skinBLbuttons()
				end)
				fObj.MaterialFrame:DisableDrawLayer("BACKGROUND")
				fObj.Tabs = {fObj.Tab1, fObj.Tab2, fObj.Tab3}
				-- Top Tabs
				self:skinObject("tabs", {obj=fObj, tabs=fObj.Tabs, fType=ftype, lod=self.isTT and true, upwards=true, regions={1, 3}, offsets={y1=-7, y2=self.isTT and 2 or 7}, track=false, func=aObj.isTT and function(tab)
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
			self:SecureHook("GarrisonBuildingInfoBox_ShowBuilding", function(ID, _, showLock)
				local buildingInfo = {_G.C_Garrison.GetOwnedBuildingInfoAbbrev(ID)}
				if not showLock then
					if buildingInfo[5] then -- buildingRank [1-3] if known
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
			self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true, ignoreHLTex=false, regions={7, 8, 9, 10}})
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

			skinFollowerList(this.FollowerList)
			self:SecureHookScript(this.FollowerTab, "OnShow", function(fObj)
				skinFollowerTraitsAndEquipment(fObj)
				self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, fb=true, ofs=-1, clr="sepia"})

				self:Unhook(fObj, "OnShow")
			end)

			self:SecureHookScript(this.MissionComplete, "OnShow", function(fObj)
				skinMissionComplete(fObj, true)

				self:Unhook(fObj, "OnShow")
			end)

			self:add2Table(self.ttList, _G.GarrisonBonusAreaTooltip)
			self:add2Table(self.ttList, _G.GarrisonShipyardMapMissionTooltip)
			-- TODO: .ItemTooltip ?

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
					if not _G.C_Garrison.GetNumPendingShipments() then
						return
					end
					for _, btn in _G.pairs(fObj.CapacitiveDisplay.Reagents) do
						if _G.type(btn) == "table"
						and btn:IsObjectType("Button")
						then
							btn.NameFrame:SetTexture(nil)
							if self.modBtnBs then
								self:addButtonBorder{obj=btn, fType=ftype, relTo=btn.Icon}
							end
						end
					end
				end
			end)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true})
			if self.modBtns then
				self:skinStdButton{obj=this.StartWorkOrderButton, fType=ftype, sechk=true}
				self:skinStdButton{obj=this.CreateAllWorkOrdersButton, fType=ftype, sechk=true}
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=this.CapacitiveDisplay.ShipmentIconFrame, fType=ftype, relTo=this.CapacitiveDisplay.ShipmentIconFrame.Icon}
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
				self:addButtonBorder{obj=this.DecrementButton, fType=ftype, ofs=0, x2=-1, clr="gold"}
				self:addButtonBorder{obj=this.IncrementButton, fType=ftype, ofs=0, x2=-1, clr="gold"}
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
			self:skinObject("ddbutton", {obj=this.Pick.ThreatDropdown, fType=ftype})
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
			skinFollowerList(this.FollowerList)
			for i = 1, 3 do
				self:removeRegions(this.FollowerSelection["Recruit" .. i].PortraitFrame, {1, 4})
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
					self:addButtonBorder{obj=fObj.ZoneSupportMissionPage.CombatAllySpell, ca=1}
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

		-- Battle for Azeroth
		self:SecureHookScript(_G.BFAMissionFrame, "OnShow", function(this)
			this.OverlayElements.Topper:SetTexture(nil)
			this.OverlayElements.CloseButtonBorder:SetTexture(nil)
			this.TitleScroll:DisableDrawLayer("ARTWORK")
			this.TitleText:SetTextColor(self.HT:GetRGB())
			skinMissionFrame(this)
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
				aObj:removeRegions(btn, {1, 4})
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
					aObj:skinObject("frame", {obj=btn, fType=ftype, kfs=true, fb=true, ofs=2})
				end
				for btn in bFrame.followerSocketFramePool:EnumerateActive() do
					aObj:skinObject("frame", {obj=btn, fType=ftype, kfs=true, fb=true, ofs=2})
				end
			end
			frame.OverlayElements.CloseButtonBorder:SetTexture(nil)
			aObj:keepFontStrings(frame.RaisedBorder)
			skinMissionFrame(frame, "sepia")
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
				skinMissionList(this.MissionList, nil, "grey")
				-- ZoneSupportMissionPage
				skinMissionPage(this.MissionPage, "grey")
				aObj:skinObject("frame", {obj=this.MissionPage.StartMissionFrame, fType=ftype, kfs=true, ng=true, x1=40, y1=-8, x2=-30, y2=10})
				skinBoard(this.MissionPage.Board)

				aObj:Unhook(this, "OnShow")
			end)
			aObj:checkShown(frame.MissionTab)
			aObj:SecureHookScript(frame.FollowerTab, "OnShow", function(this)
				this.RaisedFrameEdges:DisableDrawLayer("BORDER")
				this.HealFollowerFrame.ButtonFrame:SetTexture(nil)
				aObj:skinObject("frame", {obj=this, fType=ftype, kfs=true, fb=true, y2=0})
				aObj:skinObject("frame", {obj=this.HealFollowerFrame, fType=ftype, kfs=true, ng=true, x1=140, y1=-517, x2=-130, y2=-12})
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
				aObj:skinObject("scrollbar", {obj=this.AdventuresCombatLog.CombatLogMessageFrame.ScrollBar, fType=ftype, y1=8, y2=-10})
				aObj:skinObject("frame", {obj=this.AdventuresCombatLog, fType=ftype, kfs=true, fb=true, clr="sepia", x2=10})
				-- MissionInfo (RHS)
				this.MissionInfo.Header:SetTexture(nil)
				this.MissionInfo.IconBG:SetTexture(nil)
				aObj:skinObject("frame", {obj=this.MissionInfo, fType=ftype, kfs=true, fb=true, ofs=4, y2=-303})
				skinBoard(this.Board)
				aObj:skinObject("frame", {obj=this.CompleteFrame, fType=ftype, kfs=true, ng=true, x1=40, y1=-8, x2=-40, y2=10})
				if aObj.modBtns then
					aObj:skinStdButton{obj=this.CompleteFrame.ContinueButton, schk=true}
					aObj:skinStdButton{obj=this.CompleteFrame.SpeedButton, schk=true}
				end

				aObj:Unhook(this, "OnShow")
			end)
			-- Follower as mouse pointer when dragging
			aObj:SecureHook(frame, "GetPlacerFrame", function(this)
				self:removeRegions(_G.CovenantFollowerPlacer, {1, 4})
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
				-- let AddOn skins know when frame skinned (e.g. VenturePlan)
				self.callbacks:Fire("CovenantMissionFrame_Skinned")
				-- remove all callbacks for this event
				self.callbacks.events["CovenantMissionFrame_Skinned"] = nil
			end

		end)

	end

	aObj.blizzLoDFrames[ftype].GenericTraitUI = function(self) -- used by DragonridingPanelSkills & MountJournalOpenDynamicFlightSkillTree
		if self.initialized.GenericTraitUI then return end
		self.initialized.GenericTraitUI = true

		self:SecureHookScript(_G.GenericTraitFrame, "OnShow", function(this)
			this.Header.TitleDivider:SetAlpha(0)
			this.Currency:DisableDrawLayer("BACKGROUND")
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cbns=true, ofs=-10})

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.GenericTraitFrame)

	end

	aObj.blizzFrames[ftype].HelpTip = function(self)
		if not self.prdb.HelpTip or self.initialized.HelpTip then return end
		self.initialized.HelpTip = true

		local function skinHelpTips()
			for hTip in _G.HelpTip.framePool:EnumerateActive() do
				_G.RaiseFrameLevelByTwo(hTip)
				self:skinObject("glowbox", {obj=hTip, fType=ftype})
				if self.modBtns then
					-- N.B. .CloseButton already skinned in skinGlowBox function
					self:skinStdButton{obj=hTip.OkayButton, clr="gold"}
				end
			end
		end
		skinHelpTips()
		self:SecureHook(_G.HelpTip, "Show", function(_, _)
			skinHelpTips()
		end)

	end

	-- The following function is used by the IslandsPartyPoseUI & WarfrontsPartyPoseUI functions
	local skinPartyPoseFrame
	if _G.C_AddOns.IsAddOnLoadOnDemand("Blizzard_IslandsPartyPoseUI") then
		function skinPartyPoseFrame(frame)
			frame.Border:DisableDrawLayer("BORDER") -- PartyPose NineSliceLayout
			frame.RewardAnimations.RewardFrame.NameFrame:SetTexture(nil)
			frame.RewardAnimations.RewardFrame.IconBorder:SetTexture(nil)
			frame.OverlayElements.Topper:SetTexture(nil)
			frame.ModelScene.Bg:SetTexture(nil)
			frame.ModelScene:DisableDrawLayer("BORDER")
			frame.ModelScene:DisableDrawLayer("OVERLAY")
			aObj:skinObject("frame", {obj=frame, fType=ftype, kfs=true})
			if aObj.modBtns then
				if frame.LeaveButton then
					aObj:skinStdButton{obj=frame.LeaveButton}
				end
			end
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=frame.RewardAnimations.RewardFrame, relTo=frame.RewardAnimations.RewardFrame.Icon}
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

		self:SecureHookScript(_G.IslandsQueueFrame, "OnShow", function(this)
			this.TitleBanner.Banner:SetTexture(nil)
			for _, ic in _G.pairs(this.IslandCardsFrame.IslandCards) do
				ic.TitleScroll.Parchment:SetTexture(nil)
			end
			this.DifficultySelectorFrame.Background:SetTexture(nil)
			if self.modBtns then
				self:skinStdButton{obj=this.DifficultySelectorFrame.QueueButton}
			end
			local WQ = this.WeeklyQuest
			WQ.OverlayFrame.Bar:SetTexture(nil)
			WQ.OverlayFrame.FillBackground:SetTexture(nil)
			self:skinObject("statusbar", {obj=WQ.StatusBar, fi=0})
			-- N.B. NOT a real tooltip
			if self.modBtnBs then
				self:addButtonBorder{obj=WQ.QuestReward, relTo=WQ.QuestReward.Icon}
			end
			this.TutorialFrame.TutorialText:SetTextColor(self.BT:GetRGB())
			this.TutorialFrame:SetSize(317, 336)
			self:skinObject("frame", {obj=this.TutorialFrame, fType=ftype, kfs=true, y1=-1, x2=-1, y2=20})
			if self.modBtns then
				self:skinStdButton{obj=this.TutorialFrame.Leave}
			end
			self:keepFontStrings(this.ArtOverlayFrame)
			this.HelpButton.Ring:SetTexture(nil)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true})

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.IslandsQueueFrame)

	end

	aObj.blizzFrames[ftype].LossOfControl = function(self)
		if not self.prdb.LossOfControl or self.initialized.LossOfControl then return end
		self.initialized.LossOfControl = true

		self:SecureHookScript(_G.LossOfControlFrame, "OnShow", function(this)
			this.blackBg:SetTexture(nil)
			if self.modBtnBs then
				self:addButtonBorder{obj=this, relTo=this.Icon}
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].MainMenuBar = function(self)
		if self.initialized.MainMenuBar then return end
		self.initialized.MainMenuBar = true

		-- this is done here as other AddOns may require it to be skinned
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.MainMenuBar.VehicleLeaveButton, schk=true}
		end

		if _G.C_AddOns.IsAddOnLoaded("Dominos")
		or _G.C_AddOns.IsAddOnLoaded("Bartender4")
		then
			self.blizzFrames[ftype].MainMenuBar = nil
			return
		end

		if self.prdb.MainMenuBar.skin then
			local skinMultiBarBtns = _G.nop
			if self.modBtnBs then
				function skinMultiBarBtns(type)
					local bName
					for i = 1, _G.NUM_MULTIBAR_BUTTONS do
						bName = "MultiBar" .. type .. "Button" .. i
						if _G[bName] then
							aObj:skinActionBtn(_G[bName], ftype)
						end
					end
				end
			end
			self:SecureHookScript(_G.MainMenuBar, "OnShow", function(this)
				this.BorderArt:SetTexture(nil)
				this.EndCaps:DisableDrawLayer("OVERLAY")
				if self.modBtnBs then
					for i = 1, _G.NUM_ACTIONBAR_BUTTONS do
						self:skinActionBtn(_G["ActionButton" .. i], ftype)
					end
					skinMultiBarBtns("BottomLeft")
					skinMultiBarBtns("BottomRight")
				end

				self:Unhook(this, "OnShow")
			end)
			self:checkShown(_G.MainMenuBar)

			local function skinSTBars(container)
				for _, bar in _G.pairs(container.bars) do
					aObj:skinObject("statusbar", {obj=bar.StatusBar, bg=bar.StatusBar.Background, other={bar.StatusBar.Underlay, bar.StatusBar.Overlay}, hookFunc=true})
					if bar.priority == 0 then -- Azerite bar
						bar.StatusBar:SetStatusBarColor(aObj:getColourByName("yellow"))
					elseif bar.priority == 1 then -- Rep bar
						bar.StatusBar:SetStatusBarColor(aObj:getColourByName("light_blue"))
					elseif bar.priority == 2 then -- Honor bar
						bar.StatusBar:SetStatusBarColor(aObj:getColourByName("blue"))
					elseif bar.priority == 3 then -- XP bar
						bar.ExhaustionTick:GetNormalTexture():SetTexture(nil)
						bar.ExhaustionTick:GetHighlightTexture():SetTexture(nil)
						bar.ExhaustionLevelFillBar:SetTexture(aObj.sbTexture)
						bar.ExhaustionLevelFillBar:SetVertexColor(aObj:getColourByName("bright_blue"))
						bar.StatusBar:SetStatusBarColor(aObj:getColourByName("blue"))
					elseif bar.priority == 4 then -- Artifact bar
						bar.Tick:GetNormalTexture():SetTexture(nil)
						bar.Tick:GetHighlightTexture():SetTexture(nil)
						bar.StatusBar:SetStatusBarColor(aObj:getColourByName("yellow"))
					end
				end
			end
			self:SecureHookScript(_G.StatusTrackingBarManager, "OnShow", function(this)
				this.MainStatusTrackingBarContainer:DisableDrawLayer("OVERLAY") -- status bar textures
				this.SecondaryStatusTrackingBarContainer:DisableDrawLayer("OVERLAY") -- status bar textures
				skinSTBars(this.MainStatusTrackingBarContainer)
				skinSTBars(this.SecondaryStatusTrackingBarContainer)

				self:Unhook(this, "OnShow")
			end)
			self:checkShown(_G.StatusTrackingBarManager)

			self:SecureHookScript(_G.MultiCastActionBarFrame, "OnShow", function(this)
				self:keepFontStrings(_G.MultiCastFlyoutFrame) -- Shaman's Totem Frame
				if self.modBtnBs then
					self:addButtonBorder{obj=_G.MultiCastSummonSpellButton, sabt=true, ofs=5}
					self:addButtonBorder{obj=_G.MultiCastRecallSpellButton, sabt=true, ofs=5}
					for i = 1, _G.NUM_MULTI_CAST_PAGES * _G.NUM_MULTI_CAST_BUTTONS_PER_PAGE do
						self:skinActionBtn(_G["MultiCastActionButton" .. i], ftype)
					end
				end

				self:Unhook(this, "OnShow")
			end)
			self:checkShown(_G.MultiCastActionBarFrame)

			if self.modBtnBs then
				skinMultiBarBtns("Right")
				skinMultiBarBtns("Left")
				skinMultiBarBtns("5")
				skinMultiBarBtns("6")
				skinMultiBarBtns("7")
				skinMultiBarBtns("8")
			end
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
			local i = 1
			local bt = _G["BuffTimer" .. i]
			while bt do
				skinUnitPowerBarAlt(bt)
				i = i + 1
				bt = _G["BuffTimer" .. i]
			end
			-- UIWidgetPowerBarContainerFrame
		end

	end

	aObj.blizzFrames[ftype].MainMenuBarCommon = function(self)
		if self.initialized.MainMenuBarCommon then return end
		self.initialized.MainMenuBarCommon = true

		if _G.C_AddOns.IsAddOnLoaded("Dominos")
		or _G.C_AddOns.IsAddOnLoaded("Bartender4")
		then
			self.blizzFrames[ftype].MainMenuBarCommon = nil
			return
		end

		if self.prdb.MainMenuBar.skin then
			for _, frame in _G.pairs{_G.StanceBar, _G.PetActionBar, _G.PossessActionBar} do
				self:SecureHookScript(frame, "OnShow", function(this)
					for _, btn in _G.pairs(this.actionButtons) do
						self:skinActionBtn(btn, ftype)
					end

					self:Unhook(this, "OnShow")
				end)
				self:checkShown(frame)
			end
		end

	end

	aObj.blizzLoDFrames[ftype].MajorFactions = function(self)
		if not self.prdb.MajorFactions or self.initialized.MajorFactions then return end
		self.initialized.MajorFactions = true

		self:SecureHookScript(_G.MajorFactionUnlockToast, "OnShow", function(this)
			this.ToastBG:SetTexture(nil)
			this:DisableDrawLayer("ARTWORK") -- .GlowLineBottom

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.MajorFactionsRenownToast, "OnShow", function(this)
			this.ToastBG:SetTexture(nil)
			this.GlowLineBottom:SetAlpha(0) -- texture changed in code
			this.RewardIconRing:SetTexture(nil)

			self:Unhook(this, "OnShow")
		end)

		local function skinRewards(frame)
			for reward in frame.rewardsPool:EnumerateActive() do
				aObj:skinObject("frame", {obj=reward, fType=ftype, kfs=true, fb=true, ofs=-14, clr="sepia"})
				reward.Check:SetAlpha(1) -- make Checkmark visible
				reward.Icon:SetAlpha(1) -- make Icon visible
			end
		end
		self:SecureHookScript(_G.MajorFactionRenownFrame, "OnShow", function(this)
			this.NineSlice:DisableDrawLayer("ARTWORK")
			this.HeaderFrame.Background:SetAlpha(0) -- texture changed in code
			self:SecureHook(this, "SetRewards", function(fObj, _)
				skinRewards(fObj)
			end)
			skinRewards(this)
			this.TrackFrame.Glow:SetAlpha(0) -- texture changed in code
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, rns=true, cbns=true, ofs=-2, y1=-7, clr="gold_df"})
			if self.modBtns then
				self:skinStdButton{obj=this.LevelSkipButton, fType=ftype, clr="gold"}
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzLoDFrames[ftype].NewPlayerExperience = function(self)
		if not self.prdb.NewPlayerExperience or self.initialized.NewPlayerExperience then return end
		self.initialized.NewPlayerExperience = true

		local function skinFrame(frame)
			frame:DisableDrawLayer("BORDER") -- hide NineSlice UniqueCornersLayout
			aObj:skinObject("frame", {obj=frame, fType=ftype, ofs=-30})
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

		self:SecureHookScript(_G.OrderHallTalentFrame, "OnShow", function(this)
			for _, ft in _G.pairs(this.FrameTick) do
				ft:SetTextColor(self.BT:GetRGB())
			end
			this.OverlayElements.CornerLogo:SetTexture(nil)
			this.Currency.Icon:SetAlpha(1) -- show currency icon
			if self.modBtnBs then
				self:addButtonBorder{obj=this.Currency, relTo=this.Currency.Icon}
			end
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, cb=true, ofs=2, x2=3})

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
			self:skinObject("frame", {obj=this, fType=ftype, ofs=4, y2=-2}) -- N.B. Icons on command bar need to be visible

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
			self:skinObject("statusbar", {obj=this.BottomFrame.xpBar, fi=0})
			this.BottomFrame.TurnTimer.TimerBG:SetTexture(nil)
			self:changeTex2SB(this.BottomFrame.TurnTimer.Bar)
			this.BottomFrame.TurnTimer.ArtFrame:SetTexture(nil)
			this.BottomFrame.TurnTimer.ArtFrame2:SetTexture(nil)
			self:removeRegions(this.BottomFrame.FlowFrame, {1, 2, 3})
			self:getRegion(this.BottomFrame.Delimiter, 1):SetTexture(nil)
			self:removeRegions(this.BottomFrame.MicroButtonFrame, {1, 2, 3})
			self:skinObject("frame", {obj=this.BottomFrame, fType=ftype, kfs=true, y1=8})
			if self.modBtns then
				self:skinStdButton{obj=this.BottomFrame.TurnTimer.SkipButton, fType=ftype, schk=true}
			end
			if self.modBtnBs then
				updBBClr()
				self:SecureHook("PetBattleFrame_InitSpeedIndicators", function(_)
					updBBClr()
				end)
				-- N.B. using hooksecurefunc as function hooked for tooltips lower down
				_G.hooksecurefunc("PetBattleFrame_UpdateSpeedIndicators", function(_)
					updBBClr()
				end)
				for _, bName in _G.pairs{"SwitchPetButton", "CatchButton", "ForfeitButton"} do
					self:addButtonBorder{obj=this.BottomFrame[bName], fType=ftype, reParent={this.BottomFrame[bName].BetterIcon}, ofs=3, x2=2, y2=-2}
				end
				_G.C_Timer.After(0.1, function()
					for _, btn in _G.pairs(this.BottomFrame.abilityButtons) do
						self:addButtonBorder{obj=btn, fType=ftype, reParent={btn.BetterIcon}, ofs=3, x2=2, y2=-2}
					end
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
					for _, f in _G.pairs(aObj.pbtt) do
						if f.tfade then
							f.tfade:SetParent(opts.parent or f)
							if opts.reset then
								-- reset Gradient alpha
								f.tfade:SetGradient(aObj:getGradientInfo())
							end
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

			-- let AddOn skins know when frame skinned
			self.callbacks:Fire("PetBattleUI_OnShow")
			-- remove all callbacks for this event
			self.callbacks.events["PetBattleUI_OnShow"] = nil

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.PetBattleFrame)

		if self.prdb.Tooltips.skin then
			-- skin the tooltips
			local tTip
			for _, prefix in _G.pairs{"PetBattlePrimaryUnit", "PetBattlePrimaryAbility", "FloatingBattlePet", "FloatingPetBattleAbility", "BattlePet"} do
				tTip = _G[prefix .. "Tooltip"]
				tTip:DisableDrawLayer("BACKGROUND")
				if tTip.Delimiter then
				   tTip.Delimiter:SetTexture(nil)
				end
				if tTip.Delimiter1 then
				   tTip.Delimiter1:SetTexture(nil)
				end
				if tTip.Delimiter2 then
					tTip.Delimiter2:SetTexture(nil)
				end
				self:skinObject("frame", {obj=tTip, fType=ftype, cbns=true})
			end
			self:changeTex2SB(_G.PetBattlePrimaryUnitTooltip.ActualHealthBar)
			self:changeTex2SB(_G.PetBattlePrimaryUnitTooltip.XPBar)
			self:add2Table(self.pbtt, _G.PetBattlePrimaryUnitTooltip.sf)
			-- hook this to reset tooltip gradients
			self:SecureHookScript(_G.PetBattleFrame, "OnHide", function(_)
				for _, f in _G.pairs(aObj.pbtt) do
					if f.tfade then
						f.tfade:SetParent(f)
						f.tfade:SetGradient(aObj:getGradientInfo())
					end
				end
			end)
		end

	end

	aObj.blizzLoDFrames[ftype].PlayerChoice = function(self)
		if not self.prdb.PlayerChoice or self.initialized.PlayerChoice then return end
		self.initialized.PlayerChoice = true

		-- info from Blizzard_PlayerChoice.lua
		-- local customTextureKits = {
			-- neutral, -- default
			-- alliance,
			-- horde,
			-- marine,
			-- mechagon,
			-- jailerstower,
			-- cypherchoice,
			-- Oribos,
			-- NightFae,
			-- Venthyr,
			-- Kyrian,
			-- Dragonflight,
			-- genericplayerchoice,
			-- thewarwithin,
		-- }

		-- choiceID
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
			-- [575] = {}, -- Ally Choice in Newhome, Nazjatar from Calling Conch (Horde only) √
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
			-- handle in combat
			if _G.InCombatLockdown() then
			    aObj:add2Table(aObj.oocTab, {resizeSF, {frame, idx}})
			    return
			end
			-- aObj:Debug("resizeSF: [%s, %s]", frame, idx)
			x1Ofs, y1Ofs, x2Ofs, y2Ofs = _G.unpack(optOfs[idx])
			-- aObj:Debug("PCUI offsets: [%s, %s, %s, %s]", x1Ofs, y1Ofs, x2Ofs, y2Ofs)
			frame.sf:ClearAllPoints()
			frame.sf:SetPoint("TOPLEFT",frame, "TOPLEFT", x1Ofs, y1Ofs)
			frame.sf:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", x2Ofs, y2Ofs)
		end
		local function skinOptions(frame, _)
			if not frame.optionFrameTemplate then return end
			if frame.sf
			and frame.uiTextureKit == "jailerstower"
			or frame.uiTextureKit == "cypherchoice"
			then
				frame.sf:Hide()
			else
				frame.sf:Show()
			end
			for opt in frame.optionPools:EnumerateActiveByTemplate(frame.optionFrameTemplate) do
				-- aObj:Debug("PCF skinOptions: [%s, %s]", frame.optionFrameTemplate)
				opt.OptionText.String:SetTextColor(aObj.BT:GetRGB())
				opt.OptionText.HTML:SetTextColor("P", aObj.BT:GetRGB())
				if aObj.modBtns then
					for btn in opt.OptionButtonsContainer.buttonPool:EnumerateActive() do
						-- DON'T skin magnifying glass button
						if btn:GetText() ~= "Preview Covenant" then
							aObj:skinStdButton{obj=btn, fType=ftype, schk=true, sechk=true}
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
								aObj:addButtonBorder{obj=reward, fType=ftype, relTo=reward.Icon}
							elseif reward.itemButton then
								aObj:addButtonBorder{obj=reward.itemButton, fType=ftype, ibt=true}
							end
						end
					end
					aObj:skinObject("frame", {obj=opt, fType=ftype, fb=true})
					resizeSF(opt, 0)
				elseif frame.optionFrameTemplate == "PlayerChoiceCovenantChoiceOptionTemplate" then
					opt.BackgroundShadowSmall:SetTexture(nil)
					opt.BackgroundShadowLarge:SetTexture(nil)
					aObj:skinObject("frame", {obj=opt, fType=ftype, fb=true})
					resizeSF(opt, 999)
					-- hook these to handle size changes on mouseover (used in Oribos for covenant choice)
					aObj:SecureHook(opt, "OnUpdate", function(this, _) -- used for first time enlargement
						if _G.RegionUtil.IsDescendantOfOrSame(_G.GetMouseFocus(), this) then
							resizeSF(opt, 998)
						end

						aObj:Unhook(opt, "OnUpdate")
					end)
					aObj:SecureHook(opt, "OnEnter", function(_)
						resizeSF(opt, 998)
					end)
					aObj:SecureHook(opt, "OnLeave", function(_)
						resizeSF(opt, 999)
					end)
				elseif frame.optionFrameTemplate == "PlayerChoiceTorghastOptionTemplate" then
					opt.Header.Text:SetTextColor(aObj.HT:GetRGB())
				elseif frame.optionFrameTemplate == "PlayerChoiceCypherOptionTemplate" then
					for key, reg in _G.ipairs{opt:GetRegions()} do
						if key > 3 then -- non icon textures
							reg:SetTexture(nil)
						end
					end
					aObj:skinObject("frame", {obj=opt, fType=ftype, clr=opt.optionInfo.rarityColor and {opt.optionInfo.rarityColor:GetRGBA()} or "gold_df"})
					resizeSF(opt, 0)
					if aObj.modBtns then
						_G.CypherPlayerChoiceToggleButton:DisableDrawLayer("ARTWORK")
						_G.CypherPlayerChoiceToggleButton:GetHighlightTexture():SetAlpha(0) -- texture changed in code
						_G.CypherPlayerChoiceToggleButton.Text:SetDrawLayer("OVERLAY")
						aObj:skinStdButton{obj=_G.CypherPlayerChoiceToggleButton, fType=ftype, ofs=-8, x1=30, x2=-30, clr="gold"}
					end
				elseif frame.optionFrameTemplate == "PlayerChoiceGenericPowerChoiceOptionTemplate" then -- Delves Power Choice
					opt.BackgroundContainer:DisableDrawLayer("BACKGROUND")
					aObj:skinObject("frame", {obj=opt, fType=ftype, clr=opt.optionInfo.rarityColor and {opt.optionInfo.rarityColor:GetRGBA()} or "silver"})
					resizeSF(opt, 0)
					if aObj.modBtns then
						_G.GenericPlayerChoiceToggleButton:DisableDrawLayer("ARTWORK")
						_G.GenericPlayerChoiceToggleButton.Text:SetDrawLayer("OVERLAY")
						aObj:skinStdButton{obj=_G.GenericPlayerChoiceToggleButton, fType=ftype, ofs=-8, x1=30, x2=-30, clr="silver"}
					end
				end
			end
		end
		self:SecureHookScript(_G.PlayerChoiceFrame, "OnShow", function(this)
			this.BlackBackground:DisableDrawLayer("BACKGROUND")
			this.Header:DisableDrawLayer("BORDER")
			this.Background:DisableDrawLayer("BACKGROUND")
			this.Title:DisableDrawLayer("BACKGROUND")
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, rns=true, cbns=true, ofs=0})
			skinOptions(this, "Initial")
			self:SecureHook(this, "SetupOptions", function(fObj)
				skinOptions(fObj, "SetupOptions")
			end)

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.PlayerChoiceFrame)

	end

	aObj.blizzFrames[ftype].PVPHelper = function(self)

		self:SecureHookScript(_G.PVPFramePopup, "OnShow", function(this)
			self:removeNineSlice(this.Border)
			this:DisableDrawLayer("BORDER")
			_G.PVPFramePopupRing:SetTexture(nil)
			self:skinObject("frame", {obj=this, fType=ftype})
			if self.modBtns then
				self:skinCloseButton{obj=this.minimizeButton}
				self:skinStdButton{obj=_G.PVPFramePopupAcceptButton}
				self:skinStdButton{obj=_G.PVPFramePopupDeclineButton}
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.PVPRoleCheckPopup, "OnShow", function(this)
			self:removeNineSlice(this.Border)
			self:skinObject("frame", {obj=this, fType=ftype})
			if self.modBtns then
				self:skinStdButton{obj=_G.PVPRoleCheckPopupAcceptButton}
				self:skinStdButton{obj=_G.PVPRoleCheckPopupDeclineButton}
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.PVPReadyDialog, "OnShow", function(this)
			self:removeNineSlice(this.Border)
			if not self.prdb.LFGTexture then
				this.background:SetTexture(nil)
			end
			this.bottomArt:SetTexture(nil)
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

		self:SecureHookScript(_G.PVPReadyPopup, "OnShow", function(this)
			self:removeNineSlice(_G.ReadyStatus.Border)
			self:skinObject("frame", {obj=_G.ReadyStatus, fType=ftype, kfs=true, ofs=-6, x2=-5})
			if self.modBtns then
				self:skinOtherButton{obj=_G.ReadyStatus.CloseButton, fType=ftype, text=self.modUIBtns.minus}
			end

			self:Unhook(this, "OnShow")
		end)
	end

	aObj.blizzFrames[ftype].PVPMatch = function(self)
		if not self.prdb.PVPMatch or self.initialized.PVPMatch then return end
		self.initialized.PVPMatch = true

		self:SecureHookScript(_G.PVPMatchScoreboard, "OnShow", function(this)
			this.Content:DisableDrawLayer("BACKGROUND")
			this.Content:DisableDrawLayer("OVERLAY")
			this.Content.ScrollBox.Background:SetAlpha(0)
			self:skinObject("scrollbar", {obj=this.Content.ScrollBar, fType=ftype})
			self:skinObject("scrollbar", {obj=this.Content.ScrollBar, fType=ftype})
			-- TODO: skin elements
			local function skinElement(_)
			-- 	local _, element, elementData, new
			-- 	if _G.select("#", ...) == 2 then
			-- 		element, elementData = ...
			-- 	elseif _G.select("#", ...) == 3 then
			-- 		element, elementData, new = ...
			-- 	else
			-- 		_, element, elementData, new = ...
			-- 	end
			-- 	if new ~= false then
			-- 	end
			end
			_G.ScrollUtil.AddAcquiredFrameCallback(this.Content.ScrollBox, skinElement, aObj, true)
			self:keepFontStrings(this.TabContainer)
			self:skinObject("tabs", {obj=this.TabGroup, tabs=this.Tabs, fType=ftype, lod=self.isTT and true, track=false})
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
			this.CloseButton.Border:SetAtlas(nil)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true})

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.PVPMatchResults, "OnShow", function(this)
			this.content:DisableDrawLayer("BACKGROUND")
			this.content:DisableDrawLayer("OVERLAY")
			this.content.scrollBox.Background:SetAlpha(0)
			self:skinObject("scrollbar", {obj=this.content.scrollBar, fType=ftype})
			-- TODO: skin elements
			local function skinElement(_)
				-- local _, element, elementData, new
				-- if _G.select("#", ...) == 2 then
				-- 	element, elementData = ...
				-- elseif _G.select("#", ...) == 3 then
				-- 	element, elementData, new = ...
				-- else
				-- 	_, element, elementData, new = ...
				-- end
				-- if new ~= false then
				-- end
			end
			_G.ScrollUtil.AddAcquiredFrameCallback(this.content.scrollBox, skinElement, aObj, true)
			self:keepFontStrings(this.content.tabContainer)
			self:skinObject("tabs", {obj=this.tabGroup, tabs=this.Tabs, fType=ftype, lod=self.isTT and true, track=false})
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
			this.earningsArt:DisableDrawLayer("ARTWORK")
			this.CloseButton.Border:SetAtlas(nil)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true})
			if self.modBtns then
				self:skinStdButton{obj=this.buttonContainer.leaveButton, fType=ftype}
				self:skinStdButton{obj=this.buttonContainer.requeueButton, fType=ftype, schk=true, fsechk=true}
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].QuestMap = function(self)
		if not self.prdb.QuestMap or self.initialized.QuestMap then return end
		self.initialized.QuestMap = true

		if _G.C_AddOns.IsAddOnLoaded("EQL3") then
			self.blizzFrames[ftype].QuestMap = nil
			return
		end

		self:SecureHookScript(_G.QuestMapFrame, "OnShow", function(this)
			-- this.Background:SetAlpha(0) -- N.B. Texture changed in code
			this.VerticalSeparator:SetTexture(nil)
			-- .SettingsDropdown

			self:SecureHookScript(this.QuestsFrame, "OnShow", function(fObj) -- a.k.a. QuestScrollFrame
				self:skinObject("scrollbar", {obj=fObj.ScrollBar, fType=ftype})
				fObj.Background:SetTexture(nil)
				fObj.Edge:SetTexture(nil)
				fObj.Contents.Separator.Divider:SetTexture(nil)
				fObj.Contents.StoryHeader.Background:SetTexture(nil)
				fObj.Contents.StoryHeader.Divider:SetTexture(nil)
				self:skinObject("editbox", {obj=fObj.SearchBox, fType=ftype, si=true})
				self:keepFontStrings(fObj.BorderFrame)

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.QuestsFrame)

			self:SecureHookScript(this.QuestSessionManagement, "OnShow", function(fObj)
				fObj.BG:SetTexture(nil)
				if self.modBtnBs then
					self:addButtonBorder{obj=fObj.ExecuteSessionCommand, ofs=1, clr="gold"}
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.QuestSessionManagement)

			self:SecureHookScript(this.DetailsFrame, "OnShow", function(fObj)
				self:keepFontStrings(fObj)
				self:keepFontStrings(fObj.BorderFrame)
				self:keepFontStrings(fObj.BackFrame)
				self:skinObject("scrollbar", {obj=fObj.ScrollFrame.ScrollBar, fType=ftype})
				self:keepFontStrings(fObj.RewardsFrameContainer.RewardsFrame)
				fObj.RewardsFrameContainer.RewardsFrame.Label:SetTextColor(self.HT:GetRGB())
				self:adjWidth{obj=fObj.AbandonButton, adj=-2} -- moves buttons to the right slightly
				self:moveObject{obj=fObj.AbandonButton, y=2}
				fObj.ShareButton:DisableDrawLayer("OVERLAY") -- divider textures
				if self.modBtns then
					self:skinStdButton{obj=fObj.BackFrame.BackButton}
					-- .DestinationMapButton
					-- .WaypointMapButton
					self:skinStdButton{obj=fObj.AbandonButton}
					self:skinStdButton{obj=fObj.ShareButton}
					self:skinStdButton{obj=fObj.TrackButton, x2=-2}
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.DetailsFrame)

			self:SecureHookScript(this.CampaignOverview, "OnShow", function(fObj)
				self:keepFontStrings(fObj.BorderFrame)
				self:keepFontStrings(fObj.Header)
				self:skinObject("scrollbar", {obj=fObj.ScrollFrame.ScrollBar, fType=ftype})
				fObj.BG:SetTexture(nil)
				fObj.ScrollFrame:DisableDrawLayer("OVERLAY")

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.CampaignOverview)

			self:SecureHookScript(this.MapLegend, "OnShow", function(fObj)
				self:keepFontStrings(fObj.BorderFrame)
				self:skinObject("scrollbar", {obj=fObj.ScrollFrame.ScrollBar, fType=ftype})
				fObj.ScrollFrame.Background:SetTexture(nil)
				if self.modBtns then
					self:skinStdButton{obj=fObj.BackButton, fType=ftype}
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.MapLegend)

			_G.C_Timer.After(0.1, function()
				local wct = this.QuestsFrame.CampaignTooltip
				wct.ItemTooltip.FollowerTooltip.PortraitFrame.PortraitRing:SetTexture(nil)
				wct.ItemTooltip.FollowerTooltip.PortraitFrame.LevelBorder:SetAlpha(0)
				wct.ofs = -2
				self.ttHook[wct] = "Show"
				self:add2Table(self.ttList, wct)
				self:add2Table(self.ttList, this.QuestsFrame.StoryTooltip)
			end)

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.QuestLogPopupDetailFrame, "OnShow", function(this)
			self:skinObject("scrollbar", {obj=this.ScrollFrame.ScrollBar, fType=ftype, rpTex="artwork"})
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

		self:SecureHook("QuestLogQuests_Update", function(_)
			for hdr in _G.QuestScrollFrame.titleFramePool:EnumerateActive() do
				self:keepFontStrings(hdr)
				if self.modChkBtns then
					self:removeRegions(hdr.Checkbox, {1, 3})
					self:skinObject("button", {obj=hdr.Checkbox, fType=ftype, bd=12, ng=true, ofs=0})
				end
			end
			-- .objectiveFramePool
			for hdr in _G.QuestScrollFrame.headerFramePool:EnumerateActive() do
				self:keepFontStrings(hdr)
			end
			for hdr in _G.QuestScrollFrame.campaignHeaderFramePool:EnumerateActive() do
				self:keepFontStrings(hdr)
				hdr.HighlightTexture:SetAtlas("CampaignHeader_SelectedGlow")
			end
			for hdr in _G.QuestScrollFrame.campaignHeaderMinimalFramePool:EnumerateActive() do
				self:keepFontStrings(hdr)
			end
			for hdr in _G.QuestScrollFrame.covenantCallingsHeaderFramePool:EnumerateActive() do
				self:keepFontStrings(hdr)
				hdr.HighlightTexture:SetTexture(self.tFDIDs.qltHL)
			end
		end)
		self:SecureHook(_G.QuestMapFrame.CampaignOverview, "UpdateCampaignLoreText", function(fObj, _, _)
			for tex in fObj.texturePool:EnumerateActive() do
				tex:SetTexture(nil) -- divider lines
			end
		end)
		if self.modBtns then
			self:SecureHook("QuestMapFrame_UpdateQuestDetailsButtons", function()
				if _G.QuestMapFrame.DetailsFrame.AbandonButton.sb then
					self:clrBtnBdr(_G.QuestMapFrame.DetailsFrame.AbandonButton)
					self:clrBtnBdr(_G.QuestMapFrame.DetailsFrame.TrackButton)
					self:clrBtnBdr(_G.QuestMapFrame.DetailsFrame.ShareButton)
					if _G.QuestLogPopupDetailFrame.AbandonButton.sb then
						self:clrBtnBdr(_G.QuestLogPopupDetailFrame.AbandonButton)
						self:clrBtnBdr(_G.QuestLogPopupDetailFrame.TrackButton)
						self:clrBtnBdr(_G.QuestLogPopupDetailFrame.ShareButton)
					end
				end
			end)
		end

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
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ofs=-4})
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

	aObj.blizzFrames[ftype].QuickKeybind = function(self)
		if not self.prdb.BindingUI and not self.prdb.EditMode or self.initialized.QuickKeybind then return end
		self.initialized.QuickKeybind = true

		self:SecureHookScript(_G.QuickKeybindFrame, "OnShow", function(this)
			self:removeNineSlice(this.BG)
			this.BG.Bg:SetTexture(nil)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, hdr=true, ofs=0})
			if self.modBtns then
				self:skinStdButton{obj=this.DefaultsButton}
				self:skinStdButton{obj=this.CancelButton}
				self:skinStdButton{obj=this.OkayButton}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=this.UseCharacterBindingsButton}
			end

			self:Unhook(this, "OnShow")
		end)
		-- tooltip
		_G.C_Timer.After(0.1, function()
			self:add2Table(self.ttList, _G.QuickKeybindTooltip)
		end)

	end

	aObj.blizzFrames[ftype].RaidFinder = function(self)
		if not self.prdb.PVEFrame or self.initialized.RaidFinder then return end
		self.initialized.RaidFinder = true

		self:SecureHookScript(_G.RaidFinderFrame, "OnShow", function(this)
			this:DisableDrawLayer("BACKGROUND")
			this:DisableDrawLayer("BORDER")
			self:removeInset(_G.RaidFinderFrameRoleInset)
			_G.RaidFinderQueueFrameBackground:SetTexture(nil)
			self:skinRoleBtns("RaidFinder")
			self:skinObject("ddbutton", {obj=_G.RaidFinderQueueFrameSelectionDropdown, fType=ftype})
			self:skinObject("scrollbar", {obj=_G.RaidFinderQueueFrameScrollFrame.ScrollBar, fType=ftype, rpTex={"background", "artwork"}})
			self:removeInset(_G.RaidFinderFrameBottomInset)
			local btn
			for i = 1, 3 do
				btn = _G["RaidFinderQueueFrameScrollFrameChildFrameItem" .. i]
				if btn then
					btn.NameFrame:SetTexture(nil)
					if self.modBtnBs then
						self:addButtonBorder{obj=btn, fType=ftype, libt=true}
					end
				end
			end
			_G.RaidFinderQueueFrameScrollFrameChildFrame.MoneyReward.NameFrame:SetTexture(nil)
			self:removeMagicBtnTex(_G.RaidFinderFrameFindRaidButton)
			if self.modBtns then
				self:skinStdButton{obj=_G.RaidFinderFrameFindRaidButton}
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=_G.RaidFinderQueueFrameScrollFrameChildFrame.MoneyReward, fType=ftype, libt=true}
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].ScenarioFinderFrame = function(self)
		if not self.prdb.PVEFrame or self.initialized.ScenarioFinderFrame then return end
		self.initialized.ScenarioFinderFrame = true

		self:SecureHookScript(_G.ScenarioFinderFrame, "OnShow", function(this)
			self:removeInset(this.Inset)
			this.Queue.Bg:SetAlpha(0)
			self:skinObject("ddbutton", {obj=this.Queue.Dropdown, fType=ftype})
			self:skinObject("scrollbar", {obj=this.Queue.Random.ScrollFrame.ScrollBar, fType=ftype})
			self:skinObject("slider", {obj=this.Queue.Specific.ScrollFrame.ScrollBar, fType=ftype, rpTex={"background"}})
			-- .Queue.PartyBackfill
			-- .Queue.CooldownFrame
			if self.modBtns then
				self:skinStdButton{obj=_G.ScenarioQueueFrameFindGroupButton, fType=ftype}
			end
			local btn
			self:SecureHook("ScenarioQueueFrameSpecific_Update", function()
				for i = 1, _G.NUM_SCENARIO_CHOICE_BUTTONS do
					btn = this.Queue.Specific["Button" .. i]
					if btn then
						if self.modBtns then
							self:skinExpandButton{obj=btn.expandOrCollapseButton, sap=true}
						end
						if self.modChkBtns then
							self:skinCheckButton{obj=btn.enableButton}
						end
					end
				end
			end)

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].RaidFrame = function(self)
		if not self.prdb.RaidFrame or self.initialized.RaidFrame then return end
		self.initialized.RaidFrame = true

		self:SecureHookScript(_G.RaidParentFrame, "OnShow", function(this)
			self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true})

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.RaidFrame, "OnShow", function(this)
			-- RaidInfo Frame
			self:skinObject("frame", {obj=_G.RaidInfoInstanceLabel, fType=ftype, kfs=true, ofs=0})
			self:skinObject("frame", {obj=_G.RaidInfoIDLabel, fType=ftype, kfs=true, ofs=0})
			self:skinObject("scrollbar", {obj=_G.RaidInfoFrame.ScrollBar, fType=ftype})
			self:removeNineSlice(_G.RaidInfoFrame.Border)
			self:moveObject{obj=_G.RaidInfoFrame.Header, y=-2}
			self:skinObject("frame", {obj=_G.RaidInfoFrame, fType=ftype, kfs=true, hdr=true, ofs=-5, y1=-6})
			if self.modBtns then
				self:skinCloseButton{obj=_G.RaidInfoCloseButton, fType=ftype}
				self:skinStdButton{obj=_G.RaidFrameConvertToRaidButton, fType=ftype, sechk=true}
				self:skinStdButton{obj=_G.RaidFrameRaidInfoButton, fType=ftype, schk=true}
				self:skinStdButton{obj=_G.RaidInfoExtendButton, fType=ftype, schk=true, sechk=true}
				self:skinStdButton{obj=_G.RaidInfoCancelButton, fType=ftype}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=_G.RaidFrameAllAssistCheckButton, fType=ftype}
			end

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
				slot.IconBorder:SetTexture(nil)
				self.modUIBtns:addButtonBorder{obj=slot, relTo=slot.Icon} -- use module function to force button border
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

	aObj.blizzFrames[ftype].SplashFrame = function(self)
		if not self.prdb.SplashFrame or self.initialized.SplashFrame then return end
		self.initialized.SplashFrame = true

		self:SecureHookScript(_G.SplashFrame, "OnShow", function(this)
			this.Label:SetTextColor(_G.HIGHLIGHT_FONT_COLOR:GetRGB()) -- allow for font OUTLINE to be seen
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

	aObj.blizzFrames[ftype].SpellFlyout = function(self)
		if not self.prdb.SpellFlyout or self.initialized.SpellFlyout then return end
		self.initialized.SpellFlyout = true

		local offsets = {
			["RIGHT"] = {x1 = -6},
			["LEFT"] = {x2 = -1},
			["UP"] = {y2 = -1},
			["DOWN"] = {y1 = -1},
		}
		local defOfs, ofs = 6
		local function posnSkin(frame)
			frame:SetFrameStrata(frame:GetParent():GetFrameStrata())
			ofs = offsets[frame.direction]
			frame.sf:ClearAllPoints()
			frame.sf:SetPoint("TOPLEFT", frame, "TOPLEFT", ofs.x1 or defOfs * -1, ofs.y1 or defOfs)
			frame.sf:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", ofs.x2 or defOfs, ofs.y2 or defOfs * -1)
		end
		local skinBtns = _G.nop
		if self.modBtnBs then
			local i, button
			function skinBtns()
				i = 1
				button = _G["SpellFlyoutButton" .. i]
				while (button and button:IsShown()) do
					aObj:addButtonBorder{obj=button, fType=ftype, abt=true, sft=true}
					i = i + 1
					button = _G["SpellFlyoutButton" .. i]
				end
			end
		end
		self:SecureHookScript(_G.SpellFlyout, "OnShow", function(this)
			self:keepFontStrings(this.Background)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, sft=true, fb=true})
			posnSkin(this)
			skinBtns()
			self:SecureHook(this, "Toggle", function(fObj, _)
				posnSkin(fObj)
				skinBtns()
			end)

			self:Unhook(this, "OnShow")
		end)

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

	aObj.blizzLoDFrames[ftype].SubscriptionInterstitialUI = function(self) -- ??
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

	aObj.blizzFrames[ftype].TalkingHead = function(self)
		if not self.prdb.TalkingHead or self.initialized.TalkingHead then return end
		self.initialized.TalkingHead = true

		self:SecureHookScript(_G.TalkingHeadFrame, "OnShow", function(this)
			this.BackgroundFrame.TextBackground:SetTexture(nil)
			this.PortraitFrame.Portrait:SetTexture(nil)
			this.MainFrame.Model.PortraitBg:SetTexture(nil)
			self:skinObject("frame", {obj=this.MainFrame, fType=ftype, kfs=true, bd=11, ng=true, cbns=true, ofs=-15, y2=14})
			if self.modBtns then
				this.MainFrame.CloseButton:GetNormalTexture():SetTexture(nil)
			end

			self:SecureHook(this, "UpdateShownState", function(fObj)
				fObj.BackgroundFrame.TextBackground:SetTexture(nil)
				fObj.PortraitFrame.Portrait:SetTexture(nil)
				fObj.MainFrame.Model.PortraitBg:SetTexture(nil)
				fObj.MainFrame.CloseButton:GetNormalTexture():SetTexture(nil)
			end)

			local function clrFrame(...)
				-- handle in combat
				if _G.InCombatLockdown() then
				    aObj:add2Table(aObj.oocTab, {clrFrame, {...}})
				    return
				end
				local r, _,_,_ = ...
				if r == 0 then -- use light background (Island Expeditions, Voldun Quest, Dark Iron intro)
					_G.TalkingHeadFrame.MainFrame.sf:SetBackdropColor(.75, .75, .75, .75)
					_G.TalkingHeadFrame.MainFrame.CloseButton:SetNormalFontObject(self.modUIBtns.fontBX)
				else
					_G.TalkingHeadFrame.MainFrame.sf:SetBackdropColor(.1, .1, .1, .75)
					_G.TalkingHeadFrame.MainFrame.CloseButton:SetNormalFontObject(self.modUIBtns.fontX)
				end
			end
			clrFrame(this.TextFrame.Text:GetTextColor())
			self:SecureHook(this.TextFrame.Text, "SetTextColor", function(_, ...)
				clrFrame(...)
			end)

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzLoDFrames[ftype].TorghastLevelPicker = function(self)
		if not self.prdb.TorghastLevelPicker or self.initialized.TorghastLevelPicker then return end
		self.initialized.TorghastLevelPicker = true

		self:SecureHookScript(_G.TorghastLevelPickerFrame, "OnShow", function(this)
			for cBtn in this.gossipOptionsPool:EnumerateActive() do
				cBtn.RewardBanner.Reward.RewardBorder:SetTexture(nil)
			end
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
			this:DisableDrawLayer("BACKGROUND")
			_G.TutorialFrameTop:SetTexture(nil)
			_G.TutorialFrameBottom:SetTexture(nil)
			local MAX_TUTORIAL_VERTICAL_TILE = 30
			for i = 1, MAX_TUTORIAL_VERTICAL_TILE do
				_G["TutorialFrameLeft" .. i]:SetTexture(nil)
				_G["TutorialFrameRight" .. i]:SetTexture(nil)
			end
			_G.TutorialTextBorder:SetAlpha(0)
			self:skinObject("scrollbar", {obj=_G.TutorialFrameTextScrollFrame.ScrollBar, fType=ftype})
			-- stop animation before skinning, otherwise textures reappear
			_G.AnimateMouse:Stop()
			_G.AnimateCallout:Stop()
			self:skinObject("frame", {obj=this, fType=ftype, cb=true, y1=-11, x2=1})
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

			local function resetSF()
				-- use the same frame level & strata as TutorialFrame so it appears above other frames
				_G.TutorialFrame.sf:SetFrameLevel(_G.TutorialFrame:GetFrameLevel())
				_G.TutorialFrame.sf:SetFrameStrata(_G.TutorialFrame:GetFrameStrata())
			end
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
			self:skinObject("glowbox", {obj=this, fType=ftype})
			-- move Arrow textures to align with frame border
			self:moveObject{obj=this.ArrowUP, y=-2}
			self:moveObject{obj=this.ArrowDOWN, y=2}
			self:moveObject{obj=this.ArrowRIGHT, x=-2}
			self:moveObject{obj=this.ArrowLEFT, x=2}

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.HelpPlateTooltip)

		self:SecureHookScript(_G.PingSystemTutorial, "OnShow", function(this)
			this.Bg:SetAlpha(0)
			self:skinObject("frame", {obj=this, fType=ftype, cb=true, bg=true, ofs=0, y1=-1, y2=-2})

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].TutorialManager = function(self)
		if not self.prdb.TutorialManager or self.initialized.TutorialManager then return end
		self.initialized.TutorialManager = true

		-- TutorialMainFrame_Frame
		-- TutorialSingleKey_Frame
		-- TutorialWalk_Frame
		-- TutorialPointerFrame
		self:RawHook(_G.TutorialPointerFrame, "_GetFrame", function(this, parentFrame)
			local frame = aObj.hooks[this]._GetFrame(this, parentFrame)
			self:skinObject("glowbox", {obj=frame.Content, fType=ftype})
			frame.Glow:SetBackdrop(nil)
			return frame
		end, true)
		if _G.TutorialPointerFrame_1
		and not _G.TutorialPointerFrame_1.sf
		then
			self:skinObject("glowbox", {obj=_G.TutorialPointerFrame_1.Content, fType=ftype})
			_G.TutorialPointerFrame_1.Glow:SetBackdrop(nil)
		end
		-- TutorialKeyboardMouseFrame_Frame

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

	-- accessed via the Great Vault in Oribos/Valdrakken & Dornogal
	aObj.blizzLoDFrames[ftype].WeeklyRewards = function(self)
		if not self.prdb.WeeklyRewards or self.initialized.WeeklyRewards then return end
		self.initialized.WeeklyRewards = true

		self:SecureHookScript(_G.WeeklyRewardsFrame, "OnShow", function(this)
			self:keepFontStrings(this.BorderContainer)
			self:skinObject("frame", {obj=this.HeaderFrame, fType=ftype, kfs=true, fb=true, ofs=1, clr="topaz"})
			for _, frame in _G.pairs{"RaidFrame", "MythicFrame", "PVPFrame", "WorldFrame"} do
				this[frame].Border:SetTexture(nil)
				self:skinObject("frame", {obj=this[frame], fType=ftype, fb=true, ofs=14, clr="topaz"})
			end
			if this.Overlay then
				self:skinObject("frame", {obj=this.Overlay, fType=ftype, kfs=true, rns=true})
			end
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, rns=true, cbns=true, ofs=-5, y2=-5, clr="sepia"})
			if self.modBtns then
				self:skinStdButton{obj=this.SelectRewardButton, sechk=true}
			end
			self:SecureHook(this, "Refresh", function(fObj, _)
				for _, frame in _G.pairs(fObj.Activities) do -- .ConcessionFrame contents
					if frame.ItemFrame then
						frame.ItemFrame:DisableDrawLayer("BORDER")
						if self.modBtnBs then
							self:addButtonBorder{obj=frame.ItemFrame, fType=ftype, relTo=frame.ItemFrame.Icon, clr={_G.EPIC_PURPLE_COLOR:GetRGBA()}}
						end
					end
					self:skinObject("frame", {obj=frame, fType=ftype, kfs=true, fb=true, ofs=-1, x1=0, y1=0})
					self:clrBBC(frame.sf, frame.unlocked or frame.hasRewards and "sepia" or "grey")
				end
			end)

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.WeeklyRewardExpirationWarningDialog, "OnShow", function(this)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, rns=true, ofs=0})
			this.WarningIcon:SetAlpha(1)

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].WorldMap = function(self)
		if not self.prdb.WorldMap.skin or self.initialized.WorldMap then return end
		self.initialized.WorldMap = true

		self:SecureHookScript(_G.WorldMapFrame, "OnShow", function(this)
			if not _G.C_AddOns.IsAddOnLoaded("Mapster")
			and not _G.C_AddOns.IsAddOnLoaded("AlleyMap")
			then
				self:keepFontStrings(this)
				self:moveObject{obj=this.BorderFrame.CloseButton, x=-2}
				-- make sure map textures are displayed by setting Frame Strata to "LOW"
				self:skinObject("frame", {obj=this.BorderFrame, fType=ftype, kfs=true, bg=true, sfs="LOW", rns=true, cb=true, ofs=2, x1=-3, x2=0})
			end
			this.BorderFrame.Tutorial.Ring:SetTexture(nil)
			for _, oFrame in _G.pairs(this.overlayFrames) do
				-- FloorNavigation
				if oFrame.Arrow then
					self:skinObject("ddbutton", {obj=oFrame, fType=ftype})
				-- Tracking Options/Pin Button
				elseif oFrame.IconOverlay then
					oFrame:DisableDrawLayer("BACKGROUND")
					oFrame.Border:SetTexture(nil)
					if self.modBtns then
						self:skinStdButton{obj=oFrame, fType=ftype, ofs=-2, clr="gold"}
						if oFrame.ActiveTexture then -- TrackingPin
							self:SecureHook(oFrame, "Refresh", function(bObj)
								self:clrBtnBdr(bObj, "gold")
							end)
						end
					end
				-- ShowLegend
				elseif oFrame.ResetButton then
					oFrame:DisableDrawLayer("BACKGROUND")
					oFrame.Border:SetTexture(nil)
					aObj.modUIBtns:skinCloseButton{obj=oFrame.ResetButton, fType=ftype, noSkin=true}
					if self.modBtns then
						self:skinStdButton{obj=oFrame, fType=ftype, ofs=-2, clr="gold"}
					end
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
						self:addButtonBorder{obj=oFrame.SpellButton, fType=ftype}
					end
				-- ZoneTimer
				elseif oFrame.TimeLabel then
					_G.nop()
				-- ThreatFrame
				elseif oFrame.Eye then
					_G.nop()
				-- ActivityTracker overlay (BLHC)
				elseif oFrame.BountyDropdown then
					oFrame.IconBorder:SetTexture(nil)
					self:skinObject("ddbutton", {obj=oFrame.BountyDropdown, fType=ftype, noSF=true, y1=-2, x2=-2, y2=2, clr="gold"})
				-- NavBar
				elseif oFrame.home then
					self:skinNavBar(oFrame)
				-- SidePanelToggle
				elseif oFrame.CloseButton then
					if self.modBtnBs then
						self:addButtonBorder{obj=oFrame.CloseButton, fType=ftype, clr="gold"}
						self:addButtonBorder{obj=oFrame.OpenButton, fType=ftype, clr="gold"}
					end
				--@debug@
				else
					aObj:Debug("Unhandled WMF overlayFrame: [%s, %s]", oFrame)
					_G.Spew("overlayFrames", oFrame)
				--@end-debug@
				end
			end
			if self.modBtns then
				self:skinOtherButton{obj=this.BorderFrame.MaximizeMinimizeFrame.MaximizeButton, font=self.fontS, text=self.nearrow}
				self:skinOtherButton{obj=this.BorderFrame.MaximizeMinimizeFrame.MinimizeButton, font=self.fontS, text=self.swarrow}
			end

			self:Unhook(this, "OnShow")
		end)

	end

end

aObj.SetupRetail_UIFramesOptions = function(self)

	local optTab = {
		["Adventure Map"]                = true,
		["Anima Diversion UI"]           = true,
		["Azerite Item Toasts"]          = true,
		["Boss Banner Toast"]            = true,
		["Chat Channels UI"]             = true,
		["Class Trial"]                  = {suff = "Frames"},
		["Console"]                      = {suff = "Frame"},
		["Contribution"]                 = {suff = "Frame"},
		["Covenant Toasts"]              = true,
		["Death Recap"]                  = {suff = "Frame"},
		["Delves UI"]                    = _G.GetExpansionLevel() >= _G.LE_EXPANSION_WAR_WITHIN and true or nil,
		["Destiny Frame"]                = true,
		["Edit Mode"]                    = true,
		["Event Toast Manager"]          = {suff = "Frame"},
		["Expansion Landing Page"]       = true,
		["Garrison UI"]                  = true,
		["Help Tip"]                     = {desc = "Help Tips"},
		["Islands Party Pose UI"]        = true,
		["Islands Queue UI"]             = true,
		["Level Up Display"]             = true,
		["Loss Of Control"]              = {suff = "Frame"},
		["Major Factions"]               = {suff = "UI"},
		["New Player Experience"]        = true,
		["Obliterum UI"]                 = true,
		["Order Hall UI"]                = true,
		["Pet Battle UI"]                = true,
		["Player Choice"]                = {suff = "Frame"},
		["PVP Match"]                    = {suff = "Frame"},
		["Quest Map"]                    = true,
		["Quest Session"]                = {suff = "Frames"},
		["Scrapping Machine UI"]         = true,
		["Soulbinds"]                    = {suff = "Frame"},
		["Spell Flyout"]                 = true,
		["Splash Frame"]                 = {desc = "What's New Frame"},
		["Subscription Interstitial UI"] = {width = "double"},
		["Talking Head"]                 = true,
		["Torghast Level Picker"]        = {suff = "Frame"},
		["Tutorial Manager"]             = true,
		["Warfronts Party Pose UI"]      = true,
		["Weekly Rewards"]               = {suff = "Frame"},
		["Zone Ability"]                 = true,
	}
	self:setupFramesOptions(optTab, "UI")
	_G.wipe(optTab)

	self.optTables["UI Frames"].args.MainMenuBar.args.altpowerbar = {
		type = "toggle",
		order = 3,
		name = self.L["Alternate Power Bars"],
		desc = _G.strjoin(" ", self.L["Toggle the skin of the"], self.L["Alternate Power Bars"]),
	}
	self.db.defaults.profile.MainMenuBar.altpowerbar = true
	if self.db.profile.MainMenuBar.altpowerbar == nil then
		self.db.profile.MainMenuBar.altpowerbar = true
	end
	self.optTables["UI Frames"].args.MainMenuBar.args.extraab = {
		type = "toggle",
		order = 5,
		name = self.L["Extra Action Button"],
		desc = _G.strjoin(" ", self.L["Toggle the skin of the"], self.L["Extra Action Button"]),
	}
	self.db.defaults.profile.MainMenuBar.extraab = true
	if self.db.profile.MainMenuBar.extraab == nil then
		self.db.profile.MainMenuBar.extraab = true
	end

end
