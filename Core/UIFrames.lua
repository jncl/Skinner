local _, aObj = ...

local _G = _G

local ftype = "u"

aObj.blizzFrames[ftype].AddonList = function(self)
	if not self.prdb.AddonList or self.initialized.AddonList then return end
	self.initialized.AddonList = true

	self:SecureHookScript(_G.AddonList, "OnShow", function(this)
		self:removeMagicBtnTex(this.CancelButton)
		self:removeMagicBtnTex(this.OkayButton)
		self:removeMagicBtnTex(this.EnableAllButton)
		self:removeMagicBtnTex(this.DisableAllButton)
		if self.isRtl then
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
					if aObj.modBtns then
						aObj:skinStdButton{obj=element.LoadAddonButton}
					end
					if aObj.modChkBtns then
						aObj:skinCheckButton{obj=element.Enabled}
					end
				end
			end
			_G.ScrollUtil.AddAcquiredFrameCallback(this.ScrollBox, skinElement, aObj, true)
		else
			for i = 1, _G.MAX_ADDONS_DISPLAYED do
				if self.modBtns then
					self:skinStdButton{obj=_G["AddonListEntry" .. i .. "Load"]}
				end
				if self.modChkBtns then
					self:skinCheckButton{obj=_G["AddonListEntry" .. i .. "Enabled"]}
				end
			end
			self:skinObject("slider", {obj=_G.AddonListScrollFrame.ScrollBar, fType=ftype, rpTex="background"})
		end
		self:skinObject("dropdown", {obj=_G.AddonCharacterDropDown, fType=ftype, x2=109})
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true, x2=self.isClsc and 1})
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

aObj.blizzFrames[ftype].AlertFrames = function(self)
	if not self.prdb.AlertFrames or self.initialized.AlertFrames then return end
	self.initialized.AlertFrames = true

	--@debug@
	local dontDebug = {
		["Achievement"]        = true,
		["Criteria"]           = true,
		["GarrisonTalent"]     = true,
		["Loot"]               = true,
		["LootUpgrade"]        = true,
		["MoneyWon"]           = true,
		["NewCosmetic"]        = true,
		["NewMount"]           = true,
		["NewPet"]             = true,
		["NewRecipeLearned"]   = true,
		["NewToy"]             = true,
		["WorldQuestComplete"] = true,
	}
	--@end-debug@

	local alertType = {
		["Achievement"]           = {ofs = 0, nt = {"Background"}, stc = "Unlocked", icon = {obj = "Icon", ddl = {"border", "overlay"}, tex ="Texture"}},
		["Criteria"]              = {ofs = -8, y1 = -6, nt = {"Background"}, stc = "Unlocked", icon = {obj = "Icon", ddl = {"border", "overlay"}, tex ="Texture"}},
		["DigsiteComplete"]       = {ofs = -10, ddl = {"background"}},
		["DungeonCompletion"]     = {ofs = -8, ddl = {"background", "border", "overlay"}, sdla = "dungeonTexture", icon = {tex = "dungeonTexture"}},
		["GarrisonBuilding"]      = {ofs = -10, ddl = {"background", "border", "overlay"}},
		["GarrisonFollower"]      = {ofs = -8, ddl = {"background"}, nt = {"FollowerBG"}, nt2 = {PortraitFrame = "LevelBorder"}, stn2 = {PortraitFrame = "PortraitRing"}},
		["GarrisonMission"]       = {ofs = -10, ddl = {"background", "border"}},
		["GarrisonRandomMission"] = {ofs = -10, ddl = {"background"}, sdlb = "MissionType"},
		["GarrisonShipFollower"]  = {ofs = -8, ddl = {"background"}, nt = {"FollowerBG"}},
		["GarrisonShipMission"]   = {ofs = -10, ddl = {"background"}},
		["GarrisonTalent"]        = {ofs = -10, ddl = {"background"}},
		["GuildChallenge"]        = {ofs = -10, ddl = {"background", "border", "overlay"}},
		["HonorAwarded"]          = {ofs = -8, ddl = {"background"}, ib = true},
		["Invasion"]              = {ofs = -8, ddl = {"background"}, sdla = "Icon"},
		["LegendaryItem"]         = {ofs = -20, x1 = 24, x2 = -4, ddl = {"background"}, stn = {"Background", "Background2", "Background3"}, iq = _G.Enum.ItemQuality.Legendary},
		["Loot"]                  = {ofs = -10, y1 = -12, y2 = 12, ddl = {"background"}},
		["LootUpgrade"]           = {ofs = -12, ddl = {"background"}, stn = {"BaseQualityBorder", "UpgradeQualityBorder"}},
		["MoneyWon"]              = {ofs = -8, ddl = {"background"}, ib = true},
		["NewMount"]              = {ofs = -8, ddl = {"background"}, ib = true, iq = _G.Enum.ItemQuality.Epic},
		["NewPet"]                = {ofs = -8, ddl = {"background"}, ib = true},
		["NewRecipeLearned"]      = {ofs = -4, ddl = {"background"}, nis=true},
		["Scenario"]              = {ofs = -12, ddl = {"background", "border", "overlay"}, sdla = "dungeonTexture", icon = {tex = "dungeonTexture"}},
		["WorldQuestComplete"]    = {ofs = -6, ddl = {"background", "border"}, sdla = "QuestTexture", icon = {tex = "QuestTexture"}},
	}
	-- N.B. Appears in XML file but not in LUA file (used by NewPet, NewMount, NewToy, NewRuneforge & NewCosmetic alerts templates)
	-- ["Item"]                  = {ofs = -8, ddl = {"background"}, ib = true},
	if self.isRtl then
		alertType["Achievement"].y1         = -15
		alertType["Achievement"].y2         = 12
		alertType["Scenario"].y1            = -8
		alertType["Scenario"].y2            = 8
		alertType["EntitlementDelivered"]   = {ofs = -10}
		alertType["Loot"].icon              = {obj = "lootItem", stn = {"SpecRing"}, ib = true, tex =  "Icon"}
		alertType["NewCosmetic"]            = {ofs = -8, y1 = -12, ddl = {"background"}, ib = true, iq = _G.Enum.ItemQuality.Epic}
		alertType["NewRuneforgePower"]      = {ofs = -8, ddl = {"background"}, ib = true, iq = _G.Enum.ItemQuality.Legendary}
		alertType["NewToy"]                 = {ofs = -8, y1 = -12, ddl = {"background"}, ib = true}
		alertType["RafRewardDelivered"]     = {ofs = -10}
		alertType["SkillLineSpecsUnlocked"] = {ofs = 0, ddl = {"background"}}
		alertType["MonthlyActivity"]        = {ofs = 0, nt = {"Background"}, stc = "Unlocked", icon = {obj = "Icon", ddl = {"border", "overlay"}, tex ="Texture"}}
	else
		alertType["Achievement"].y1         = -10
		alertType["Achievement"].y2         = 10
		alertType["Achievement"].stn        = {"OldAchievement"}
		alertType["Loot"].stn               = {"SpecRing"}
		alertType["Loot"].ib                = true
		alertType["StorePurchase"]          = {ofs = -12, ddl = {"background"}}
	end
	local function skinAlertFrame(type, frame)
		aObj:Debug("skinAlertFrame: [%s, %s, %s]", type, frame)
		local tbl = alertType[type]
		--@debug@
		if not dontDebug[type] then
			-- _G.Spew("", frame)
			_G.Spew("AlertFrames", tbl)
		end
		--@end-debug@
		-- Stop animations
		if frame.animIn then
			frame.animIn:Stop()
			frame.waitAndAnimOut:Stop()
		end
		if tbl.ddl then
			for _, ddl in _G.pairs(tbl.ddl) do
				frame:DisableDrawLayer(ddl)
			end
		end
		if tbl.nt then
			for _, tex in _G.pairs(tbl.nt) do
				aObj:nilTexture(frame[tex], true)
			end
		end
		if tbl.nt2 then
			for key, tex in _G.pairs(tbl.nt2) do
				aObj:nilTexture(frame[key][tex], true)
			end
		end
		if tbl.stn then
			for _, tex in _G.pairs(tbl.stn) do
				frame[tex]:SetTexture(nil)
			end
		end
		if tbl.stn2 then
			for key, tex in _G.pairs(tbl.stn2) do
				frame[key][tex]:SetTexture(nil)
			end
		end
		if tbl.sdla then
			if type == "Invasion" then
				frame.Icon = aObj:getRegion(frame, 2)
			end
			frame[tbl.sdla]:SetDrawLayer("ARTWORK")
		end
		if tbl.sdlb then
			frame[tbl.sdlb]:SetDrawLayer("BORDER")
		end
		if tbl.stc then
			frame[tbl.stc]:SetTextColor(aObj.BT:GetRGB())
		end
		-- setup offset as required
		tbl.x1  = tbl.x1 or tbl.ofs * -1
		tbl.y1  = tbl.y1 or tbl.ofs
		tbl.x2  = tbl.x2 or tbl.ofs
		tbl.y2  = tbl.y2 or tbl.ofs * -1
		aObj:skinObject("frame", {obj=frame, fType=ftype, x1=tbl.x1, y1=tbl.y1, x2=tbl.x2, y2=tbl.y2})
		-- add button border if required
		if aObj.modBtnBs then
			local itemQuality = tbl.iq
			if frame.hyperlink then -- Loot Won & Loot Upgrade Alerts
				if frame.isCurrency then
					itemQuality = _G.C_CurrencyInfo.GetCurrencyInfoFromLink(frame.hyperlink).quality
				else
					itemQuality = _G.select(3, _G.GetItemInfo(frame.hyperlink))
				end
			elseif type == "NewPet" then
				itemQuality = _G.select(5, _G.C_PetJournal.GetPetStats(frame.petID)) - 1 -- rarity value - 1
			elseif type == "NewToy" then
				itemQuality = _G.select(6, _G.C_ToyBox.GetToyInfo(frame.toyID))
				-- TODO: Item has a quality iconborder atlas
			elseif type == "Item" then
				aObj:Debug("Item Alert Border Atlas: [%s, %s]", frame.IconBorder:GetAtlas())
			end
			if not tbl.icon then
				frame.Icon:SetDrawLayer("BORDER")
				if tbl.ib then
					frame.IconBorder:SetTexture(nil)
				end
				if not tbl.nis then
					aObj:addButtonBorder{obj=frame, relTo=frame.Icon}
				end
			else
				if tbl.icon.ddl then
					for _, ddl in _G.pairs(tbl.icon.ddl) do
						frame[tbl.icon.obj or "Icon"]:DisableDrawLayer(ddl)
					end
				end
				if tbl.icon.stn then
					for _, tex in _G.pairs(tbl.icon.stn) do
						frame[tbl.icon.obj or "Icon"][tex]:SetTexture(nil)
					end
				end
				if tbl.icon.ib then
					frame[tbl.icon.obj or "Icon"].IconBorder:SetTexture(nil)
				end
				-- change Icon object here, used for button border and quality colour
				if tbl.icon.obj then
					frame = frame[tbl.icon.obj]
				end
				aObj:addButtonBorder{obj=frame, fType=ftype, relTo=frame[tbl.icon.tex]}
			end
			if itemQuality then
				aObj:setBtnClr(frame, itemQuality)
			else
				if not tbl.nis then
					aObj:clrBtnBdr(frame)
				end
			end
		end
	end
	for type, _ in _G.pairs(alertType) do
		local sysName = "AlertSystem"
		if type == "NewCosmetic" then
			sysName = "AlertFrameSystem"
		end
		-- aObj:Debug("AlertFrameSystem: [%s, %s]", type)
		self:SecureHook(_G[type .. sysName], "setUpFunction", function(frame, _)
			skinAlertFrame(type, frame)
		end)
		for frame in _G[type .. sysName].alertFramePool:EnumerateActive() do
			skinAlertFrame(type, frame)
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
				skinAlertFrame("Achievement", frame)
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
			if self.isClscERA then
				frame.sf.tfade:SetGradientAlpha(self:getGradientInfo())
			else
				frame.sf.tfade:SetGradient(self:getGradientInfo())
			end
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
		this.BorderFrame:DisableDrawLayer("BORDER")
		this.BorderFrame:DisableDrawLayer("ARTWORK")
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, fb=true, ofs=2, x1=-5, y1=6, bba=(1.0 - _G.BattlefieldMapOptions.opacity)})
		if self.modBtns then
			self:skinCloseButton{obj=this.BorderFrame.CloseButton, fType=ftype, noSkin=true}
		end

		-- change the skinFrame's opacity as required
		self:SecureHook(this, "RefreshAlpha", function(fObj)
			_G.C_Timer.After(0.05, function()
				fObj.sf:SetAlpha(1.0 - _G.BattlefieldMapOptions.opacity)
			end)
		end)

		if _G.IsAddOnLoaded("Capping") then
			if _G.type(self["Capping_ModMap"]) == "function" then self:Capping_ModMap() end
		end

		if _G.IsAddOnLoaded("Mapster") then
			local mBM = _G.LibStub:GetLibrary("AceAddon-3.0", true):GetAddon("Mapster", true):GetModule("BattleMap", true)
			if mBM then
				local function updBMVisibility(db)
					if db.hideTextures then
						this.sf:Hide()
					else
						this.sf:Show()
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

if not aObj.isClscERA then
	aObj.blizzLoDFrames[ftype].Calendar = function(self)
		if not self.prdb.Calendar or self.initialized.Calendar then return end
		self.initialized.Calendar = true

		self:SecureHookScript(_G.CalendarFrame, "OnShow", function(this)
			_G.CalendarTodayFrame:DisableDrawLayer("BORDER")
			self:keepFontStrings(_G.CalendarFilterFrame)
			self:moveObject{obj=_G.CalendarCloseButton, y=14}
			self:adjHeight{obj=_G.CalendarCloseButton, adj=-2}
			self:skinObject("frame", {obj=_G.CalendarContextMenu, fType=ftype}) -- pseudo tooltip
			self:skinObject("frame", {obj=_G.CalendarInviteStatusContextMenu, fType=ftype}) -- pseudo tooltip
			-- remove texture from day buttons
			for i = 1, 7 * 6 do
				_G["CalendarDayButton" .. i]:GetNormalTexture():SetTexture(nil)
			end
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ofs=-2, x2=2, y2=-4})
			if self.modBtns then
				self:skinCloseButton{obj=_G.CalendarCloseButton}
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=_G.CalendarPrevMonthButton, ofs=-1, y1=-2, x2=-2, clr="gold", schk=true}
				self:addButtonBorder{obj=_G.CalendarNextMonthButton, ofs=-1, y1=-2, x2=-2, clr="gold", schk=true}
				self:addButtonBorder{obj=_G.CalendarFilterButton, es=14, x1=3, y1=0, x2=3, y2=0, clr="grey"}
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.CalendarViewHolidayFrame, "OnShow", function(this)
			self:removeNineSlice(this.Border)
			self:removeRegions(_G.CalendarViewHolidayCloseButton, {5})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, hdr=true, ofs=-3})
			if self.modBtns then
				self:skinCloseButton{obj=_G.CalendarViewHolidayCloseButton}
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.CalendarViewRaidFrame, "OnShow", function(this)
			self:removeNineSlice(this.Border)
			self:removeRegions(_G.CalendarViewRaidCloseButton, {5})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, hdr=true, ofs=-3})
			if self.modBtns then
				self:skinCloseButton{obj=_G.CalendarViewRaidCloseButton}
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.CalendarViewEventFrame, "OnShow", function(this)
			self:removeNineSlice(this.Border)
			self:skinObject("frame", {obj=_G.CalendarViewEventDescriptionContainer, fType=ftype, fb=true})
			self:skinObject("scrollbar", {obj=_G.CalendarViewEventDescriptionContainer.ScrollBar, fType=ftype})
			self:skinObject("scrollbar", {obj=_G.CalendarViewEventInviteList.ScrollBar, fType=ftype})
			self:keepFontStrings(_G.CalendarViewEventInviteListSection)
			self:skinObject("frame", {obj=_G.CalendarViewEventInviteList, fType=ftype, fb=true})
			self:removeRegions(_G.CalendarViewEventCloseButton, {5})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, hdr=true, ofs=-3})
			if self.modBtns then
				self:skinCloseButton{obj=_G.CalendarViewEventCloseButton, fType=ftype}
				self:skinStdButton{obj=_G.CalendarViewEventAcceptButton, fType=ftype, schk=true}
				self:skinStdButton{obj=_G.CalendarViewEventTentativeButton, fType=ftype, schk=true}
				self:skinStdButton{obj=_G.CalendarViewEventDeclineButton, fType=ftype, schk=true}
				self:skinStdButton{obj=_G.CalendarViewEventRemoveButton, fType=ftype, schk=true}
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.CalendarCreateEventFrame, "OnShow", function(this)
			self:removeNineSlice(this.Border)
			_G.CalendarCreateEventIcon:SetAlpha(1) -- show event icon
			self:skinObject("editbox", {obj=_G.CalendarCreateEventTitleEdit, fType=ftype})
			self:skinObject("dropdown", {obj=_G.CalendarCreateEventCommunityDropDown, fType=ftype})
			self:skinObject("dropdown", {obj=_G.CalendarCreateEventTypeDropDown, fType=ftype})
			self:skinObject("dropdown", {obj=_G.CalendarCreateEventHourDropDown, fType=ftype, x2=-6})
			self:skinObject("dropdown", {obj=_G.CalendarCreateEventMinuteDropDown, fType=ftype, x2=-6})
			self:skinObject("dropdown", {obj=_G.CalendarCreateEventAMPMDropDown, fType=ftype})
			self:skinObject("dropdown", {obj=_G.CalendarCreateEventDifficultyOptionDropDown, fType=ftype})
			self:skinObject("frame", {obj=_G.CalendarCreateEventDescriptionContainer, fType=ftype, fb=true})
			self:skinObject("scrollbar", {obj=_G.CalendarCreateEventDescriptionContainer.ScrollBar, fType=ftype})
			self:keepFontStrings(_G.CalendarCreateEventInviteListSection)
			self:skinObject("frame", {obj=_G.CalendarCreateEventInviteList, fType=ftype, fb=true})
			self:skinObject("editbox", {obj=_G.CalendarCreateEventInviteEdit, fType=ftype})
			_G.CalendarCreateEventMassInviteButtonBorder:SetAlpha(0)
			_G.CalendarCreateEventRaidInviteButtonBorder:SetAlpha(0)
			_G.CalendarCreateEventCreateButtonBorder:SetAlpha(0)
			self:removeRegions(_G.CalendarCreateEventCloseButton, {5})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, hdr=true, cb=true, ofs=-2})
			if self.modBtns then
				self:skinCloseButton{obj=_G.CalendarCreateEventCloseButton, fType=ftype}
				self:skinStdButton{obj=_G.CalendarCreateEventInviteButton, fType=ftype, schk=true}
				self:skinStdButton{obj=_G.CalendarCreateEventMassInviteButton, fType=ftype, schk=true}
				self:skinStdButton{obj=_G.CalendarCreateEventRaidInviteButton, fType=ftype, schk=true}
				self:skinStdButton{obj=_G.CalendarCreateEventCreateButton, fType=ftype, schk=true}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=_G.CalendarCreateEventAutoApproveCheck}
				self:skinCheckButton{obj=_G.CalendarCreateEventLockEventCheck}
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.CalendarMassInviteFrame, "OnShow", function(this)
			self:removeNineSlice(this.Border)
			self:skinObject("dropdown", {obj=_G.CalendarMassInviteCommunityDropDown, fType=ftype})
			self:skinObject("editbox", {obj=_G.CalendarMassInviteMinLevelEdit, fType=ftype})
			self:skinObject("editbox", {obj=_G.CalendarMassInviteMaxLevelEdit, fType=ftype})
			self:skinObject("dropdown", {obj=_G.CalendarMassInviteRankMenu, fType=ftype})
			self:removeRegions(_G.CalendarMassInviteCloseButton, {5})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, hdr=true, cb=true, ofs=-3, y2=20})
			if self.modBtns then
				self:skinCloseButton{obj=_G.CalendarMassInviteCloseButton, fType=ftype}
				self:skinStdButton{obj=_G.CalendarMassInviteAcceptButton, fType=ftype, schk=true}
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.CalendarEventPickerFrame, "OnShow", function(this)
			self:removeNineSlice(this.Border)
			self:skinObject("scrollbar", {obj=this.ScrollBar, fType=ftype})
			self:removeRegions(_G.CalendarEventPickerCloseButton, {7})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, hdr=true, ofs=-3})
			if self.modBtns then
				self:skinCloseButton{obj=_G.CalendarEventPickerCloseButton}
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.CalendarTexturePickerFrame, "OnShow", function(this)
			self:removeNineSlice(this.Border)
			self:skinObject("scrollbar", {obj=this.ScrollBar, fType=ftype})
			_G.CalendarTexturePickerCancelButtonBorder:SetAlpha(0)
			_G.CalendarTexturePickerAcceptButtonBorder:SetAlpha(0)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, hdr=true, ofs=-3})
			if self.modBtns then
				self:skinStdButton{obj=_G.CalendarTexturePickerCancelButton}
				self:skinStdButton{obj=_G.CalendarTexturePickerAcceptButton}
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.CalendarClassButtonContainer, "OnShow", function(this)
			for i = 1, _G.MAX_CLASSES do -- allow for the total button
				self:removeRegions(_G["CalendarClassButton" .. i], {1}) -- background
				self:addButtonBorder{obj=_G["CalendarClassButton" .. i]}
			end
			_G.CalendarClassTotalsButton:SetSize(20, 20)
			self:skinObject("frame", {obj=_G.CalendarClassTotalsButton, fType=ftype, kfs=true})

			self:Unhook(this, "OnShow")
		end)

	end
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
				aObj:skinObject("frame", {obj=cBubble, fType=ftype, kfs=true, ba=aObj.prdb.ChatBubbles.alpha, ng=true, ofs=-8})
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
	if not aObj.isRtl then
		local func
		if not self.isClsc then
			func = "InterfaceOptionsDisplayPanelChatBubblesDropDown_SetValue"
		else
			func = "InterfaceOptionsSocialPanelChatBubblesDropDown_SetValue"
		end
		-- hook this to handle changes
		self:SecureHook(func, function(_, value)
			-- unregister events
			unRegisterEvents()
			if value ~= 2 then -- either All or ExcludeParty
				registerEvents()
				skinChatBubbles()
			end
		end)
	else
		local function OnValueChanged(_, _, value)
			unRegisterEvents()
			if value ~= 2 then -- either All or ExcludeParty
				registerEvents()
				skinChatBubbles()
			end
		end
		_G.Settings.SetOnValueChangedCallback("PROXY_CHAT_BUBBLES", OnValueChanged)
	end

end

aObj.blizzFrames[ftype].ChatConfig = function(self)
	if not self.prdb.ChatConfig or self.initialized.ChatConfig then return end
	self.initialized.ChatConfig = true

	self:SecureHookScript(_G.ChatConfigFrame, "OnShow", function(this)
		if self.isRtl then
			self:removeNineSlice(this.Border)
		end
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, hdr=true, ofs=-4, y1=0})
		if self.modBtns then
			self:skinStdButton{obj=this.DefaultButton, fType=ftype}
			self:skinStdButton{obj=this.RedockButton, fType=ftype}
			self:skinStdButton{obj=_G.CombatLogDefaultButton, fType=ftype}
			self:skinStdButton{obj=_G.TextToSpeechDefaultButton, fType=ftype}
			self:skinStdButton{obj=_G.ChatConfigFrameCancelButton, fType=ftype}
			self:skinStdButton{obj=_G.ChatConfigFrameOkayButton, fType=ftype}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.TextToSpeechCharacterSpecificButton, fType=ftype}
		end

		self:SecureHookScript(_G.ChatConfigCategoryFrame, "OnShow", function(fObj)
			self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, rns=true, fb=true, ofs=0})

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(_G.ChatConfigCategoryFrame)

		self:SecureHookScript(this.ChatTabManager, "OnShow", function(fObj)
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
			-- Top Tabs
			local tabSkin = self.skinTPLs.new("tabs", {obj=fObj, fType=ftype, upwards=true, ignoreHLTex=false, offsets={x1=0, y1=self.isTT and -10 or -12, x2=0, y2=self.isTT and -5 or 0}, regions={8, 9, 10, 11}, noCheck=true, func=setTabState})
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
			skinTabs(fObj)
			self:SecureHook(fObj, "UpdateSelection", function(frame, _)
				skinTabs(frame)
			end)

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.ChatTabManager)

		self:SecureHookScript(_G.ChatConfigBackgroundFrame, "OnShow", function(fObj)
			self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, rns=true, fb=true, ofs=0})

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(_G.ChatConfigBackgroundFrame)

		local function skinCB(cBox)
			if _G[cBox].NineSlice then
				aObj:removeNineSlice(_G[cBox].NineSlice)
			end
			if aObj.modChkBtns then
				local box
				for _, suffix in _G.pairs{"", "Check", "ColorSwatch", "ColorClasses"} do
					box = _G[cBox .. suffix]
					if box
					and box:IsObjectType("CheckButton")
					then
						aObj:skinCheckButton{obj=box}
						if suffix == "ColorClasses" then
							box:SetHeight(24)
						end
					end
				end
			end
		end

		self:SecureHookScript(_G.ChatConfigChatSettings, "OnShow", function(fObj)
			if self.isClsc then
				self:skinObject("frame", {obj=_G.ChatConfigChatSettingsClassColorLegend, fType=ftype, kfs=true, rns=true, fb=true, ofs=0})
			end
			self:skinObject("frame", {obj=_G.ChatConfigChatSettingsLeft, fType=ftype, kfs=true, rns=true, fb=true, ofs=0})
			if self.modChkBtns then
				for i = 1, #_G.CHAT_CONFIG_CHAT_LEFT do
					skinCB("ChatConfigChatSettingsLeftCheckBox" .. i)
				end
			end

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(_G.ChatConfigChatSettings)

		self:SecureHookScript(_G.ChatConfigChannelSettings, "OnShow", function(fObj)
			if self.isClsc then
				self:skinObject("frame", {obj=_G.ChatConfigChannelSettingsClassColorLegend, fType=ftype, kfs=true, rns=true, fb=true, ofs=0})
			end
			self:skinObject("frame", {obj=_G.ChatConfigChannelSettingsLeft, fType=ftype, kfs=true, rns=true, fb=true, ofs=0})
			local function skinLeft(frame)
				for i = 1, #frame.checkBoxTable do
					skinCB(frame:GetName() .. "CheckBox" .. i)
				end
			end
			skinLeft(_G.ChatConfigChannelSettingsLeft)
			self:SecureHook("ChatConfig_CreateCheckboxes", function(frame, _)
				skinLeft(frame)
			end)
			if not self.isRtl then
				self:skinObject("frame", {obj=_G.ChatConfigChannelSettingsAvailable, fType=ftype, kfs=true, rns=true, fb=true, ofs=0})
				if self.modBtns then
					local box
					local function skinAvail()
						for idx, _ in _G.ipairs(_G.ChatConfigChannelSettingsAvailable.boxTable) do
							box = _G["ChatConfigChannelSettingsAvailableBox" .. idx]
							aObj:removeNineSlice(box.NineSlice)
							aObj:skinStdButton{obj=box.Button, ofs=0}
						end
					end
					skinAvail()
					self:SecureHook("ChatConfig_CreateBoxes", function(_)
						skinAvail()
					end)
				end
			else
				for i = 1, #_G.CHAT_CONFIG_CHANNEL_LIST do
					skinCB("ChatConfigChannelSettingsLeftCheckBox" .. i)
				end
			end

			self:Unhook(fObj, "OnShow")
		end)

		self:SecureHookScript(_G.ChatConfigOtherSettings, "OnShow", function(fObj)
			for i = 1, #_G.CHAT_CONFIG_OTHER_COMBAT do
				skinCB("ChatConfigOtherSettingsCombatCheckBox" .. i)
			end
			self:skinObject("frame", {obj=_G.ChatConfigOtherSettingsCombat, fType=ftype, kfs=true, rns=true, fb=true, ofs=0})
			for i = 1, #_G.CHAT_CONFIG_OTHER_PVP do
				skinCB("ChatConfigOtherSettingsPVPCheckBox" .. i)
			end
			self:skinObject("frame", {obj=_G.ChatConfigOtherSettingsPVP, fType=ftype, kfs=true, rns=true, fb=true, ofs=0})
			for i = 1, #_G.CHAT_CONFIG_OTHER_SYSTEM do
				skinCB("ChatConfigOtherSettingsSystemCheckBox" .. i)
			end
			self:skinObject("frame", {obj=_G.ChatConfigOtherSettingsSystem, fType=ftype, kfs=true, rns=true, fb=true, ofs=0})
			for i = 1, #_G.CHAT_CONFIG_CHAT_CREATURE_LEFT do
				skinCB("ChatConfigOtherSettingsCreatureCheckBox" .. i)
			end
			self:skinObject("frame", {obj=_G.ChatConfigOtherSettingsCreature, fType=ftype, kfs=true, rns=true, fb=true, ofs=0})

			self:Unhook(fObj, "OnShow")
		end)

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

		self:SecureHookScript(_G.ChatConfigCombatSettings, "OnShow", function(fObj)
			-- Top Tabs
			self:skinObject("tabs", {obj=_G.ChatConfigCombatSettings, prefix="CombatConfig", numTabs=#_G.COMBAT_CONFIG_TABS, fType=ftype, lod=self.isTT and true, upwards=true, offsets={y1=-8, y2=self.isTT and -5 or 0}, regions={4, 5}, track=false})
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

			self:SecureHookScript(_G.ChatConfigCombatSettingsFilters, "OnShow", function(frame)
				if self.isRtl then
					self:skinObject("scrollbar", {obj=frame.ScrollBar, fType=ftype})
				else
					_G.ChatConfigCombatSettingsFiltersScrollFrameScrollBarBorder:Hide()
					self:skinObject("slider", {obj=_G.ChatConfigCombatSettingsFiltersScrollFrameScrollBar, fType=ftype})
				end
				self:skinObject("frame", {obj=_G.ChatConfigCombatSettingsFilters, fType=ftype, kfs=true, rns=true, fb=true, ofs=0, x2=-22})
				_G.LowerFrameLevel(_G.ChatConfigCombatSettingsFilters) -- make frame appear below tab texture
				if self.modBtns then
					self:skinStdButton{obj=_G.ChatConfigCombatSettingsFiltersDeleteButton}
					self:skinStdButton{obj=_G.ChatConfigCombatSettingsFiltersAddFilterButton}
					self:skinStdButton{obj=_G.ChatConfigCombatSettingsFiltersCopyFilterButton}
				end
				if self.modBtnBs then
					self:addButtonBorder{obj=_G.ChatConfigMoveFilterUpButton, es=12, ofs=-5, x2=-6, y2=7, clr="grey"}
					self:addButtonBorder{obj=_G.ChatConfigMoveFilterDownButton, es=12, ofs=-5, x2=-6, y2=7, clr="grey"}
				end

				self:Unhook(frame, "OnShow")
			end)
			self:checkShown(_G.ChatConfigCombatSettingsFilters)

			self:SecureHookScript(_G.CombatConfigMessageSources, "OnShow", function(frame)
				for i = 1, #_G.COMBAT_CONFIG_MESSAGESOURCES_BY do
					skinCB("CombatConfigMessageSourcesDoneByCheckBox" .. i)
				end
				self:skinObject("frame", {obj=_G.CombatConfigMessageSourcesDoneBy, fType=ftype, kfs=true, rns=true, fb=true, ofs=0})
				for i = 1, #_G.COMBAT_CONFIG_MESSAGESOURCES_TO do
					skinCB("CombatConfigMessageSourcesDoneToCheckBox" .. i)
				end
				self:skinObject("frame", {obj=_G.CombatConfigMessageSourcesDoneTo, fType=ftype, kfs=true, rns=true, fb=true, ofs=0})

				self:Unhook(frame, "OnShow")
			end)
			self:checkShown(_G.CombatConfigMessageSources)

			self:SecureHookScript(_G.CombatConfigMessageTypes, "OnShow", function(frame)
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

				self:Unhook(frame, "OnShow")
			end)

			self:SecureHookScript(_G.CombatConfigColors, "OnShow", function(frame)
				for i = 1, #_G.COMBAT_CONFIG_UNIT_COLORS do
					self:removeNineSlice(_G["CombatConfigColorsUnitColorsSwatch" .. i].NineSlice)
				end
				self:skinObject("frame", {obj=_G.CombatConfigColorsUnitColors, fType=ftype, kfs=true, rns=true, fb=true, ofs=0})
				self:skinObject("frame", {obj=_G.CombatConfigColorsHighlighting, fType=ftype, kfs=true, rns=true, fb=true, ofs=0})
				self:skinObject("frame", {obj=_G.CombatConfigColorsColorizeUnitName, fType=ftype, kfs=true, rns=true, fb=true, ofs=0})
				self:skinObject("frame", {obj=_G.CombatConfigColorsColorizeSpellNames, fType=ftype, kfs=true, rns=true, fb=true, ofs=0})
				self:skinObject("frame", {obj=_G.CombatConfigColorsColorizeDamageNumber, fType=ftype, kfs=true, rns=true, fb=true, ofs=0})
				self:skinObject("frame", {obj=_G.CombatConfigColorsColorizeDamageSchool, fType=ftype, kfs=true, rns=true, fb=true, ofs=0})
				self:skinObject("frame", {obj=_G.CombatConfigColorsColorizeEntireLine, fType=ftype, kfs=true, rns=true, fb=true, ofs=0})
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

				self:Unhook(frame, "OnShow")
			end)

			self:SecureHookScript(_G.CombatConfigFormatting, "OnShow", function(frame)
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

				self:Unhook(frame, "OnShow")
			end)

			self:SecureHookScript(_G.CombatConfigSettings, "OnShow", function(frame)
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

				self:Unhook(frame, "OnShow")
			end)

			self:Unhook(fObj, "OnShow")
		end)

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
		if self.isRtl then
			self:skinObject("scrollbar", {obj=_G["ChatFrame" .. i].ScrollBar, fType=ftype})
		end
		self:skinObject("frame", {obj=_G["ChatFrame" .. i], fType=ftype, ofs=6, y1=_G["ChatFrame" .. i] == _G.COMBATLOG and 30, x2=27, y2=-9})
	end

	-- CombatLog Quick Button Frame & Progress Bar
	if self.prdb.CombatLogQBF then
		if _G.CombatLogQuickButtonFrame_Custom then
			_G.CombatLogQuickButtonFrame_Custom:DisableDrawLayer("BACKGROUND")
			self:skinObject("frame", {obj=_G.CombatLogQuickButtonFrame_Custom, fType=ftype, ofs=0, x1=-3, x2=3})
			self:adjHeight{obj=_G.CombatLogQuickButtonFrame_Custom, adj=4}
			self:skinObject("statusbar", {obj=_G.CombatLogQuickButtonFrame_CustomProgressBar, fi=0, bg=_G.CombatLogQuickButtonFrame_CustomTexture})
		else
			self:skinObject("statusbar", {obj=_G.CombatLogQuickButtonFrameProgressBar, fi=0, bg=_G.CombatLogQuickButtonFrameTexture})
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

aObj.blizzFrames[ftype].ChatTabs = function(self)
	if not self.prdb.ChatTabs or self.initialized.ChatTabs then return end
	self.initialized.ChatTabs = true

	local fcfTabs = {}
	for i = 1, _G.NUM_CHAT_WINDOWS do
		self:add2Table(fcfTabs, _G["ChatFrame" .. i .. "Tab"])
		self:SecureHook(_G["ChatFrame" .. i .. "Tab"], "SetParent", function(this, parent)
			if this.sf then
				if parent == _G.GeneralDockManager.scrollFrame.child then
					this.sf:SetParent(_G.GeneralDockManager)
				else
					this.sf:SetParent(this)
					this.sf:SetFrameLevel(1) -- reset frame level so that the texture is behind text etc
				end
			end
		end)
		-- hook this to manage alpha changes when chat frame fades in and out
		self:SecureHook(_G["ChatFrame" .. i .. "Tab"], "SetAlpha", function(this, alpha)
			if this.sf then
				this.sf:SetAlpha(alpha)
			end
		end)
	end
	-- Top Tabs
	self:skinObject("tabs", {obj=_G.FloatingChatFrameManager, tabs=fcfTabs, fType=ftype, lod=self.isTT and true, upwards=true, ignoreHLTex=false, regions={7, 8, 9, 10, 11}, offsets={x1=1, y1=self.isTT and -10 or -12, x2=-1, y2=self.isTT and -3 or -1}, track=false, func=function(tab) tab.sf:SetAlpha(tab:GetAlpha()) tab.sf:Hide() end})
	if self.isTT then
		self:SecureHook("FCF_Tab_OnClick", function(this, _)
			for i = 1, _G.NUM_CHAT_WINDOWS do
				self:setInactiveTab(_G["ChatFrame" .. i .. "Tab"].sf)
			end
			self:setActiveTab(this.sf)
		end)
	end

	if self.prdb.ChatTabsFade then
		-- hook this to show/hide the Tab's skin frame
		self:SecureHook("FCFTab_UpdateColors", function(this, selected)
			if this.sf then
				this.sf:SetShown(selected)
			end
		end)
		_G.ChatFrame1Tab.sf:Show()
	end

end

aObj.blizzFrames[ftype].CinematicFrame = function(self)
	if not self.prdb.CinematicFrame or self.initialized.CinematicFrame then return end
	self.initialized.CinematicFrame = true

	self:SecureHookScript(_G.CinematicFrame, "OnShow", function(this)
		if self.isRtl then
			self:removeNineSlice(this.closeDialog.Border)
		end
		-- raidBossEmoteFrame ?
		self:skinObject("frame", {obj=this.closeDialog, fType=ftype})
		if self.modBtns then
			self:skinStdButton{obj=_G.CinematicFrameCloseDialogConfirmButton}
			self:skinStdButton{obj=_G.CinematicFrameCloseDialogResumeButton}
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].CoinPickup = function(self)
	if not self.prdb.CoinPickup or self.initialized.CoinPickup then return end
	self.initialized.CoinPickup = true

	self:SecureHookScript(_G.CoinPickupFrame, "OnShow", function(this)
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, x1=9, y1=-12, x2=-6, y2=12})

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].ColorPicker = function(self)
	if not self.prdb.ColorPicker or self.initialized.ColorPicker then return end
	self.initialized.ColorPicker = true

	self:SecureHookScript(_G.ColorPickerFrame, "OnShow", function(this)
		if self.isRtl then
			self:removeNineSlice(this.Border)
		end
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
		if self.isRtl then
			self:removeNineSlice(this.Border)
		end
		self:skinObject("slider", {obj=_G.OpacityFrameSlider, fType=ftype})
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ofs=-1})

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzLoDFrames[ftype].DebugTools = function(self)
	if not self.prdb.DebugTools or self.initialized.DebugTools then return end
	self.initialized.DebugTools = true

	local function skinTAD(frame)
		aObj:skinObject("editbox", {obj=frame.FilterBox, fType=ftype, si=true})
		aObj:skinObject("scrollbar", {obj=frame.LinesScrollFrame.ScrollBar, fType=ftype})
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

	-- tooltip
	self.ttHook[_G.FrameStackTooltip] = "OnUpdate"
	_G.C_Timer.After(0.1, function()
		self:add2Table(self.ttList, _G.FrameStackTooltip)
		_G.FrameStackTooltip:SetFrameLevel(20)
	end)

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
		aObj:skinObject("scrollbar", {obj=this.Log.Events.ScrollBar, fType=ftype})
		aObj:skinObject("scrollbar", {obj=this.Log.Search.ScrollBar, fType=ftype})
		aObj:skinObject("scrollbar", {obj=this.Filter.ScrollBar, fType=ftype})
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

aObj.blizzLoDFrames[ftype].GMChatUI = function(self)
	if not self.prdb.GMChatUI or self.initialized.GMChatUI then return end
	self.initialized.GMChatUI = true

	self:SecureHookScript(_G.GMChatFrame, "OnShow", function(this)
		self:skinObject("frame", {obj=_G.GMChatTab, fType=ftype, kfs=true, noBdr=self.isTT, y2=-4})
		if self.prdb.ChatFrames then
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, ofs=-4, y2=-8})
		end
		this:DisableDrawLayer("BORDER")
		if self.prdb.ChatEditBox.skin then
			if self.prdb.ChatEditBox.style == 1 then -- Frame
				local kRegions = _G.CopyTable(self.ebRgns)
				self:add2Table(kRegions, 12)
				self:keepRegions(this.editBox, kRegions)
				self:skinObject("frame", {obj=this.editBox, fType=ftype, ofs=2, y2=0})
			elseif self.prdb.ChatEditBox.style == 2 then -- Editbox
				self:skinObject("editbox", {obj=this.editbox, fType=ftype})
			else -- Borderless
				self:removeRegions(this.editBox, {6, 7, 8})
				self:skinObject("frame", {obj=this.editBox, fType=ftype, noBdr=true, x1=5, y1=-4, x2=-5, y2=2})
			end
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.GMChatStatusFrame, "OnShow", function(this)
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, rns=true})

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzLoDFrames[ftype].GuildBankUI = function(self)
	if not self.prdb.GuildBankUI or self.initialized.GuildBankUI then return end
	self.initialized.GuildBankUI = true

	self:SecureHookScript(_G.GuildBankFrame, "OnShow", function(this)
		this.Emblem:Hide()
		for _, col in _G.pairs(this.Columns) do
			col:DisableDrawLayer("BACKGROUND")
		end
		if self.modBtnBs then
			self:SecureHook(this, "Update", function(fObj)
				for _, col in _G.pairs(fObj.Columns) do
					for _, btn in _G.pairs(col.Buttons) do
						if not btn.sbb then
							self:addButtonBorder{obj=btn, ibt=true, clr="grey", ca=0.85}
						else
							self:clrButtonFromBorder(btn)
						end
					end
				end
			end)
		end
		if self.isRtl then
			self:skinObject("editbox", {obj=_G.GuildItemSearchBox, fType=ftype, si=true})
			this.MoneyFrameBG:DisableDrawLayer("BACKGROUND")
		end
		self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true})
		-- Tabs (side)
		for _, tab in _G.pairs(this.BankTabs) do
			tab:DisableDrawLayer("BACKGROUND")
			if self.modBtnBs then
				 self:addButtonBorder{obj=tab.Button, relTo=tab.Button.IconTexture, ofs=3, x2=2}
			end
		end
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, hdr=true, cb=true, y1=self.isClsc and -11, x2=self.isClsc and 1, y2=self.isClsc and 3 or -1})
		if self.modBtns then
			if self.isClsc then
				self:skinCloseButton{obj=self:getChild(this, 11), fType=ftype}
			end
			self:skinStdButton{obj=this.DepositButton, fType=ftype, x1=0} -- don't overlap withdraw button
			self:skinStdButton{obj=this.WithdrawButton, fType=ftype, schk=true, x2=0} -- don't overlap deposit button
			self:skinStdButton{obj=this.BuyInfo.PurchaseButton, fType=ftype, schk=true}
			self:skinStdButton{obj=this.Info.SaveButton, fType=ftype}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.GuildBankPopupFrame, "OnShow", function(this)
		self:adjHeight{obj=this, adj=20}
		if self.isRtl then
			self:skinIconSelector(this)
		else
			self:removeRegions(_G.BorderBox, {1, 2, 3, 4, 5, 6, 7, 8})
			self:skinObject("editbox", {obj=this.EditBox, fType=ftype})
			self:adjHeight{obj=this.ScrollFrame, adj=20} -- stretch to bottom of scroll area
			self:skinObject("slider", {obj=this.ScrollFrame.ScrollBar, fType=ftype, rpTex="background"})
			for _, btn in _G.pairs(this.Buttons) do
				btn:DisableDrawLayer("BACKGROUND")
				if self.modBtnBs then
					self:addButtonBorder{obj=btn, relTo=btn.Icon, clr="grey"}
				end
			end
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, hdr=true, ofs=-6})
			if self.modBtns then
				self:skinStdButton{obj=this.CancelButton}
				self:skinStdButton{obj=this.OkayButton}
			end
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].HelpFrame = function(self)
	if not self.prdb.HelpFrame or self.initialized.HelpFrame then return end
	self.initialized.HelpFrame = true

	self:SecureHookScript(_G.HelpFrame, "OnShow", function(this)
		self:removeInset(this.Browser.BrowserInset)
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, hdr=true, ri=true, rns=true, cb=true, x1=not self.isRtl and 0, x2=self.isRtl and 3 or 1})

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

aObj.blizzFrames[ftype].ItemText = function(self)
	if not self.prdb.ItemText or self.initialized.ItemText then return end
	self.initialized.ItemText = true

	local function skinITFrame(frame)
		aObj:skinObject("scrollbar", {obj=_G.ItemTextScrollFrame.ScrollBar, fType=ftype, rpTex=not aObj.isRtl and {"background", "artwork"} or nil})
		aObj:skinObject("statusbar", {obj=_G.ItemTextStatusBar, fi=0})
		if aObj.isRtl then
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
		skinITFrame = nil
	end
	self:SecureHookScript(_G.ItemTextFrame, "OnShow", function(this)
		if not self.isRtl then
			_G.ItemTextPageText:SetTextColor(self.BT:GetRGB())
		end
		_G.ItemTextPageText:SetTextColor("P", self.BT:GetRGB())
		_G.ItemTextPageText:SetTextColor("H1", self.HT:GetRGB())
		_G.ItemTextPageText:SetTextColor("H2", self.HT:GetRGB())
		_G.ItemTextPageText:SetTextColor("H3", self.HT:GetRGB())
		if skinITFrame then
			skinITFrame(this)
		end
	end)

end

aObj.blizzLoDFrames[ftype].MacroUI = function(self)
	if not self.prdb.MacroUI or self.initialized.MacroUI then return end
	self.initialized.MacroUI = true

	self:SecureHookScript(_G.MacroFrame, "OnShow", function(this)
		-- Top Tabs
		self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true, upwards=true, offsets={x1=1, y1=-6, x2=-1, y2=self.isTT and -2 or 3}, func=function(tab) tab:SetFrameLevel(20) end})
		if self.isClscERA then
			self:skinObject("frame", {obj=_G.MacroButtonScrollFrame, fType=ftype, kfs=true, fb=true, ofs=12, y1=10, x2=31})
			self:skinObject("slider", {obj=_G.MacroButtonScrollFrame.ScrollBar, fType=ftype, rpTex="artwork"})
		else
			self:skinObject("scrollbar", {obj=this.MacroSelector.ScrollBar, fType=ftype})
			self:skinObject("frame", {obj=this.MacroSelector, fType=ftype, kfs=true, fb=true, ofs=6, y1=10, x2=2})
			if self.modBtnBs then
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
						aObj:addButtonBorder{obj=element, fType=ftype, relTo=element.Icon, clr="grey"}
					end
				end
				_G.ScrollUtil.AddAcquiredFrameCallback(this.MacroSelector.ScrollBox, skinElement, aObj, true)
			end
		end
		self:skinObject("scrollbar", {obj=_G.MacroFrameScrollFrame.ScrollBar, fType=ftype})
		self:skinObject("frame", {obj=_G.MacroFrameTextBackground, fType=ftype, kfs=true, rns=true, fb=true, ofs=0, x2=1})
		_G.MacroFrameSelectedMacroButton:DisableDrawLayer("BACKGROUND")
		if self.isClscERA then
			for i = 1, _G.MAX_ACCOUNT_MACROS do
				_G["MacroButton" .. i]:DisableDrawLayer("BACKGROUND")
				if self.modBtnBs then
					self:addButtonBorder{obj=_G["MacroButton" .. i], relTo=_G["MacroButton" .. i .. "Icon"], clr="grey", ca=0.85}
				end
			end
		end
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, hdr=true, ri=true, rns=true, cb=true})
		if self.modBtns then
			self:skinStdButton{obj=_G.MacroEditButton, fType=ftype, schk=true}
			self:skinStdButton{obj=_G.MacroCancelButton, fType=ftype}
			self:skinStdButton{obj=_G.MacroSaveButton, fType=ftype}
			self:skinStdButton{obj=_G.MacroDeleteButton, fType=ftype, schk=true}
			self:skinStdButton{obj=_G.MacroNewButton, fType=ftype, schk=true, sechk=true, x2=-2}
			self:skinStdButton{obj=_G.MacroExitButton, fType=ftype, x1=2}
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.MacroFrameSelectedMacroButton, relTo=_G.MacroFrameSelectedMacroButtonIcon, clr="grey", ca=0.85}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.MacroPopupFrame, "OnShow", function(this)
		if  self.isRtl then
			self:skinIconSelector(this)
		else
			self:adjHeight{obj=this, adj=20} -- so buttons don't overlay icons
			self:removeRegions(this.BorderBox, {1, 2, 3, 4, 5, 6, 7, 8})
			self:skinObject("editbox", {obj=_G.MacroPopupEditBox, fType=ftype})
			self:adjHeight{obj=_G.MacroPopupScrollFrame, adj=20} -- stretch to bottom of scroll area
			self:skinObject("slider", {obj=_G.MacroPopupScrollFrame.ScrollBar, fType=ftype, rpTex="background"})
			if self.isClsc then
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
					self:addButtonBorder{obj=_G["MacroPopupButton" .. i], relTo=_G["MacroPopupButton" .. i .. "Icon"], clr="grey", ca=0.85}
				end
			end
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].MailFrame = function(self)
	if not self.prdb.MailFrame or self.initialized.MailFrame then return end
	self.initialized.MailFrame = true

	self:SecureHookScript(_G.MailFrame, "OnShow", function(this)
		self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype})
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, cb=true, x2=self.isRtl and 3 or 1})
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
			self:skinStdButton{obj=_G.OpenAllMail, fType=ftype, schk=true}
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
		if self.isRtl then
			_G.SendMailScrollFrame:DisableDrawLayer("BACKGROUND")
			_G.SendMailBodyEditBox:SetTextColor(self.prdb.BodyText.r, self.prdb.BodyText.g, self.prdb.BodyText.b)
		else
			_G.MailEditBox.ScrollBox.EditBox:SetTextColor(self.BT:GetRGB())
			_G.MailEditBox:DisableDrawLayer("BACKGROUND")
			self:skinObject("scrollbar", {obj=_G.MailEditBoxScrollBar, fType=ftype})
		end
		for _, btn in _G.pairs(_G.SendMailFrame.SendMailAttachments) do
			if not self.modBtnBs then
				self:resizeEmptyTexture(self:getRegion(btn, 1))
			else
				btn:DisableDrawLayer("BACKGROUND")
				self:addButtonBorder{obj=btn, clr="grey"}
			end
		end
		self:skinObject("editbox", {obj=_G.SendMailNameEditBox, fType=ftype, regions={4, 5, 6}})
		self:skinObject("editbox", {obj=_G.SendMailSubjectEditBox, fType=ftype, regions={4, 5, 6}})
		self:skinObject("moneyframe", {obj=_G.SendMailMoney, moveIcon=true, moveGEB=true, moveSEB=true})
		self:removeInset(_G.SendMailMoneyInset)
		_G.SendMailMoneyBg:DisableDrawLayer("BACKGROUND")
		if self.modBtns then
			self:skinStdButton{obj=_G.SendMailMailButton, fType=ftype, schk=true}
			self:skinStdButton{obj=_G.SendMailCancelButton, fType=ftype}
		end
		if self.modBtnBs then
			self:SecureHook("ClickSendMailItemButton", function(id, rb)
				if id
				and rb
				then
					self:clrBtnBdr(_G.SendMailFrame.SendMailAttachments[id], "grey")
				end
			end)
		end
		--	Open Mail Frame
		_G.OpenMailScrollFrame:DisableDrawLayer("BACKGROUND")
		_G.OpenMailBodyText:SetTextColor("P", self.BT:GetRGB())
		self:skinObject("frame", {obj=_G.OpenMailFrame, fType=ftype, kfs=true, ri=true, cb=true})
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
			for _, btn in _G.pairs(_G.OpenMailFrame.OpenMailAttachments) do
				self:addButtonBorder{obj=btn, ibt=true}
			end
		end
		-- Invoice Frame Text fields
		local fields = {"ItemLabel", "Purchaser", "SalePrice", "Deposit", "HouseCut", "AmountReceived", "NotYetSent", "MoneyDelay"}
		if not self.isRtl then
			self:add2Table(fields, "BuyMode")
		end
		for _, type in _G.pairs(fields) do
			_G["OpenMailInvoice" .. type]:SetTextColor(self.BT:GetRGB())
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].MenuFrames = function(self)
	if not self.prdb.MenuFrames or self.initialized.MenuFrames then return end
	self.initialized.MenuFrames = true

	self:SecureHookScript(_G.GameMenuFrame, "OnShow", function(this)
		if self.isRtl then
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
		if self.isRtl then
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

	-- hook this to handle Jostle Library
	if _G.LibStub:GetLibrary("LibJostle-3.0", true) then
		self:RawHook(_G.MinimapCluster, "SetPoint", function(this, point, relTo, relPoint, _)
			self.hooks[this].SetPoint(this, point, relTo, relPoint, -6, -18)
		end, true)
	end

	-- Cluster Frame
	if not self.isRtl then
		_G.MinimapBorderTop:Hide()
		_G.MinimapZoneTextButton:ClearAllPoints()
		_G.MinimapZoneTextButton:SetPoint("BOTTOMLEFT", _G.Minimap, "TOPLEFT", 0, 5)
		_G.MinimapZoneTextButton:SetPoint("BOTTOMRIGHT", _G.Minimap, "TOPRIGHT", 0, 5)
		_G.MinimapZoneText:ClearAllPoints()
		_G.MinimapZoneText:SetPoint("CENTER")
		self:skinObject("button", {obj=_G.MinimapZoneTextButton, fType=ftype, x1=-5, x2=5})
	end

	-- Minimap
	-- use file path for non Retail versions otherwise the minimap has a green overlay
	_G.Minimap:SetMaskTexture(self.isRtl and self.tFDIDs.w8x8 or [[Interface\Buttons\WHITE8X8]])
	-- use a backdrop with no Texture otherwise the map tiles are obscured
	self:skinObject("frame", {obj=_G.Minimap, fType=ftype, bd=8, ofs=5})
	if self.prdb.Minimap.gloss then
		_G.RaiseFrameLevel(_G.Minimap.sf)
	else
		_G.LowerFrameLevel(_G.Minimap.sf)
	end

	if self.isRtl then
		-- N.B. copied from SexyMap
		-- Removes the circular "waffle-like" texture that shows when using a non-circular minimap in the blue quest objective area.
		_G.Minimap:SetArchBlobRingScalar(0)
		_G.Minimap:SetArchBlobRingAlpha(0)
		_G.Minimap:SetQuestBlobRingScalar(0)
		_G.Minimap:SetQuestBlobRingAlpha(0)
		-- Difficulty indicators
		-- .InstanceDifficulty
			-- .Instance
				-- .Border
			-- .Guild
				-- .Border
				-- .Instance
			-- .ChallengeMode
				-- .Border
	else
		if self.isClscERA then
			if self.modBtns then
				_G.RaiseFrameLevelByTwo(_G.MinimapToggleButton)
				self:moveObject{obj=_G.MinimapToggleButton, x=-8, y=1}
				self:skinCloseButton{obj=_G.MinimapToggleButton, noSkin=true}
			end
		end
	end

	self:keepFontStrings(_G.MinimapBackdrop)
	self:moveObject{obj=_G.BuffFrame, x=-40}

end

aObj.blizzFrames[ftype].MinimapButtons = function(self)
	if not self.prdb.MinimapButtons.skin or self.initialized.MinimapButtons then return end
	self.initialized.MinimapButtons = true

	if not self.modBtns then return end

	local minBtn = self.prdb.MinimapButtons.style
	local ignBtn = {
		["OQ_MinimapButton"] = true,
	}
	if not self.isRtl then
		ignBtn["GameTimeFrame"]                    = true
		ignBtn["GarrisonLandingPageMinimapButton"] = true
		ignBtn["MiniMapTracking"]                  = true
		ignBtn["MiniMapWorldMapButton"]            = true
		ignBtn["MinimapZoomIn"]                    = true
		ignBtn["MinimapZoomOut"]                   = true
		ignBtn["QueueStatusMinimapButton"]         = true
	else
		ignBtn[_G.Minimap.ZoomIn]  = true
		ignBtn[_G.Minimap.ZoomOut] = true
	end
	local function mmKids(mmObj)
		local objName, objType
		for _, obj in _G.ipairs{mmObj:GetChildren()} do
			objName, objType = obj:GetName(), obj:GetObjectType()
			-- aObj:Debug("mmKids: [%s, %s, %s, %s]", obj, objName, objType)
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
						if aObj:hasAnyTextInName(reg, {"Icon", "icon"})
						or aObj:hasTextInTexture(reg, "Icon")
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

	if self.isClscERA then
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
		self:moveObject{obj=_G.MiniMapTrackingFrame, x=-15}
		if not minBtn then
			self:skinObject("frame", {obj=_G.MiniMapTrackingFrame, fType=ftype, bd=10, ofs=0})
		end
	else
		if self.isClsc then
			-- Calendar button
			makeBtnSquare(_G.GameTimeFrame, 0.1, 0.31, 0.16, 0.6)
			_G.GameTimeFrame:SetNormalFontObject(_G.GameFontWhite) -- allow for font OUTLINE to be seen
			_G.MiniMapTrackingBackground:SetTexture(nil)
			_G.MiniMapTrackingButtonBorder:SetTexture(nil)
			self:moveObject{obj=_G.MiniMapTracking, x=-4}
			if not minBtn then
				_G.MiniMapTracking:SetScale(0.9)
				self:skinObject("frame", {obj=_G.MiniMapTracking, fType=ftype, bd=10, ofs=0})
			end
			_G.MiniMapBattlefieldFrame:SetSize(28, 28)
		end
		-- skin any moved Minimap buttons if required
		if _G.IsAddOnLoaded("MinimapButtonFrame") then
			mmKids(_G.MinimapButtonFrame)
		end
		-- show the Bongos minimap icon if required
		if _G.IsAddOnLoaded("Bongos") then
			_G.Bongos3MinimapButton.icon:SetDrawLayer("ARTWORK")
		end
	end

	_G.MiniMapMailIcon:SetTexture(self.tFDIDs.tMB)
	_G.MiniMapMailIcon:ClearAllPoints()
	if not self.isRtl then
		_G.MiniMapMailIcon:SetPoint("CENTER", _G.MiniMapMailFrame)
		_G.MiniMapMailFrame:SetSize(26, 26)
		self:moveObject{obj=_G.MiniMapMailFrame, y=-4}
		_G.MiniMapWorldBorder:SetTexture(nil)
		_G.MiniMapWorldMapButton:ClearAllPoints()
		_G.MiniMapWorldMapButton:SetPoint("LEFT", _G.MinimapZoneTextButton, "RIGHT", -4, 0)
		self:skinOtherButton{obj=_G.MiniMapWorldMapButton, font=self.fontP, text="M", noSkin=minBtn}
		if _G.IsAddOnLoaded("SexyMap")
		or self.isClsc
		then
			_G.MiniMapWorldMapButton:DisableDrawLayer("OVERLAY") -- border texture
		end
		-- Zoom Buttons
		local btn, txt, xOfs, yOfs
		for _, suff in _G.pairs{"In", "Out"} do
			btn = _G["MinimapZoom" .. suff]
			if suff == "In" then
				txt = self.modUIBtns.plus
				if self.isClscERA then
					xOfs, yOfs = 9, -24
				else
					xOfs, yOfs = 14, -12
				end
			else
				txt = self.modUIBtns.minus
				if self.isClscERA then
					xOfs, yOfs = 19, -12
				else
					xOfs, yOfs = 20, -10
				end
			end
			self:moveObject{obj=btn, x=xOfs, y=yOfs}
			self:skinOtherButton{obj=btn, text=txt, noSkin=minBtn}
			if not minBtn then
				local function clrZoomBtns()
					for _, suffix in _G.pairs{"In", "Out"} do
						btn = _G["MinimapZoom" .. suffix]
						aObj:clrBBC(btn.sb, btn:IsEnabled() and "gold" or "disabled")
					end
				end
				self:SecureHookScript(btn, "OnClick", function(_)
					clrZoomBtns()
				end)
				_G.C_Timer.After(0.5, function()
					clrZoomBtns()
				end)
				self:RegisterEvent("MINIMAP_UPDATE_ZOOM", clrZoomBtns)
			end
		end
	else
		_G.MiniMapMailIcon:SetPoint("CENTER", _G.MinimapCluster.MailFrame)
		-- ExpansionLandingPageMinimapButton
		_G.ExpansionLandingPageMinimapButton.AlertBG:SetTexture(nil)
		local anchor = _G.AnchorUtil.CreateAnchor("TOPLEFT", "MinimapBackdrop", "TOPLEFT", -10, -200)
		anchor:SetPoint(_G.ExpansionLandingPageMinimapButton, true)
		self:SecureHook(_G.ExpansionLandingPageMinimapButton, "UpdateIconForGarrison", function(this)
			anchor:SetPoint(this, true)
		end)
	end
	_G.TimeManagerClockButton:DisableDrawLayer("BORDER")
	_G.TimeManagerClockButton:SetSize(36, 14)
	if not _G.IsAddOnLoaded("SexyMap") then
		self:moveObject{obj=_G.TimeManagerClockTicker, x=-3, y=-1}
	end

	-- skin Minimap children, allow for delayed addons to be loaded (e.g. Baggins)
	_G.C_Timer.After(0.5, function()
		mmKids(_G.Minimap)
	end)

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
			aObj:skinObject("button", {obj=mmBtn})
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
		-- FIXME: this is to move button off the minimap, required until LibDBIcon is fixed
		if aObj.isRtl then
			aObj:moveObject{obj=dbiBtn, x=-36, y=0}
			dbiBtn.SetPoint = _G.nop
		end
		skinMMBtn("LibDBIcon btn", dbiBtn, name)
	end
	self.DBIcon:RegisterCallback("LibDBIcon_IconCreated", skinDBI)
	for name, button in _G.pairs(self.DBIcon.objects) do
		skinDBI(nil, button, name)
	end

end

aObj.blizzLoDFrames[ftype].MovePad = function(self)
	if not self.prdb.MovePad or self.initialized.MovePad then return end
	self.initialized.MovePad = true

	self:SecureHookScript(_G.MovePadFrame, "OnShow", function(this)
		_G.MovePadRotateLeft.icon:SetTexture(self.tFDIDs.rB)
		_G.MovePadRotateRight.icon:SetTexture(self.tFDIDs.rB)
		_G.MovePadRotateRight.icon:SetTexCoord(1, 0, 0, 1) -- flip texture horizontally
		self:skinObject("frame", {obj=this, fType=ftype})
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
		self:skinObject("frame", {obj=this.CloseDialog, fType=ftype})
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
		-- aObj:Debug("skinNamePlate: [%s, %s]", frame, frame:IsForbidden())
		if not frame -- happens when called again after combat and frame doesn't exist any more
		or frame:IsForbidden()
		then
			return
		end
		if _G.InCombatLockdown() then
		    aObj:add2Table(aObj.oocTab, {skinNamePlate, {frame}})
		    return
		end
		local nP = frame.UnitFrame or aObj:getChild(frame, 1)
		if nP
		and nP.healthBar
		and not nP.classNamePlatePowerBar
		then
			local nHb, nCb = nP.healthBar, nP.castBar or nP.CastBar
			nHb.border:DisableDrawLayer("ARTWORK")
			if not aObj.isRtl then
				aObj:skinObject("statusbar", {obj=nHb, bg=nHb.background})
				if aObj.isClsc then
					aObj:nilTexture(nCb.Border, true)
					aObj:nilTexture(nCb.BorderShield, true)
					aObj:skinObject("statusbar", {obj=nCb, bg=aObj:getRegion(nCb, 1)})
				end
			else
				aObj:skinObject("statusbar", {obj=nHb, bg=nHb.background, other={nHb.myHealPrediction, nHb.otherHealPrediction}})
				if nCb then
					aObj:skinObject("statusbar", {obj=nCb, bg=nCb.Background, hookFunc=true})
				end
			end
			-- N.B. WidgetContainer objects managed in UIWidgets code
		end
	end
	self:SecureHook(_G.NamePlateDriverFrame, "OnNamePlateAdded", function(_, namePlateUnitToken)
		local namePlate = _G.C_NamePlate.GetNamePlateForUnit(namePlateUnitToken, _G.issecure())
		if namePlate then
			skinNamePlate(namePlate)
		end
	end)
	for _, frame in _G.pairs(_G.C_NamePlate.GetNamePlates(_G.issecure())) do
		skinNamePlate(frame)
	end

	-- Class Nameplate Frames
	if self.isRtl then
		local mF = _G.ClassNameplateManaBarFrame
		if mF then
			mF.Border:DisableDrawLayer("BACKGROUND")
			self:skinObject("statusbar", {obj=mF, bg=mF.background, other={mF.ManaCostPredictionBar, mF.FeedbackFrame.BarTexture}})
		end
		for _, chi in _G.pairs(_G.ClassNameplateBarWindwalkerMonkFrame.Chi) do
			chi:DisableDrawLayer("BACKGROUND")
		end
		self:skinObject("statusbar", {obj=_G.ClassNameplateBrewmasterBarFrame, fi=0})
		for _, rune in _G.pairs(_G.ClassNameplateBarPaladinFrame.Runes) do
			rune.OffTexture:SetTexture(nil)
		end
		for _, rune in _G.pairs(_G.DeathKnightResourceOverlayFrame.Runes) do
			rune.EmptyRune:SetTexture(nil)
		end
		-- ClassNameplateBarDracthyrFrame
		for combo in _G.ClassNameplateBarDruidFrame.classResourceButtonPool:EnumerateActive() do
			combo:DisableDrawLayer("BACKGROUND")
		end
		-- ClassNameplateBarMageFrame
		for combo in _G.ClassNameplateBarRogueFrame.classResourceButtonPool:EnumerateActive() do
			combo:DisableDrawLayer("BACKGROUND")
		end
		for shard in _G.ClassNameplateBarWarlockFrame.classResourceButtonPool:EnumerateActive() do
			shard.ShardOff:SetTexture(nil)
		end
	end

	-- tooltip
	_G.C_Timer.After(0.1, function()
		self:add2Table(self.ttList, _G.NamePlateTooltip)
	end)

end

if not aObj.isClscERA then
	aObj.blizzFrames[ftype].OverrideActionBar = function(self) -- a.k.a. Vehicle UI
		if not self.prdb.OverrideActionBar or self.initialized.OverrideActionBar then return end
		self.initialized.OverrideActionBar = true

		if _G.IsAddOnLoaded("Dominos")
		or _G.IsAddOnLoaded("Bartender4")
		then
			self.blizzFrames[ftype].OverrideActionBar = nil
			return
		end

		self:SecureHookScript(_G.OverrideActionBar, "OnShow", function(this)
			this:DisableDrawLayer("OVERLAY")
			this:DisableDrawLayer("BACKGROUND")
			this:DisableDrawLayer("BORDER")
			this.PitchButtonBG:SetDrawLayer("BORDER")
			this.pitchFrame:DisableDrawLayer("BORDER")
			this.leaveFrame:DisableDrawLayer("BACKGROUND")
			this.leaveFrame:DisableDrawLayer("BORDER")
			this.xpBar:DisableDrawLayer("ARTWORK")
			self:skinObject("statusbar", {obj=this.xpBar, bg=aObj:getRegion(this.xpBar, 1)})
			self:skinObject("frame", {obj=this, fType=ftype, x1=144, y1=6, x2=-142, y2=-2})
			if self.modBtnBs then
				self:addButtonBorder{obj=this.PitchUpButton}
				self:addButtonBorder{obj=this.PitchDownButton}
				self:addButtonBorder{obj=this.LeaveButton}
				for i = 1, 6 do
					self:addButtonBorder{obj=this["SpellButton" .. i], sabt=true}
				end
			end

			self:Unhook(this, "OnShow")
		end)

	end
end

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
			if _G.PTR_IssueReporter[name] then
				_G.PTR_IssueReporter[name]:SetPushedTexture("")
				self:removeBackdrop(_G.PTR_IssueReporter[name].Border)
				self:skinObject("button", {obj=_G.PTR_IssueReporter[name], fType=ftype, clr="blue"})
			end
		end

		self:SecureHook(_G.PTR_IssueReporter, "GetStandaloneSurveyFrame", function(_)
			skinFrame(_G.PTR_IssueReporter.StandaloneSurvey, 2) -- header frame
			skinFrame(_G.PTR_IssueReporter.StandaloneSurvey.SurveyFrame)
			if self.modBtns then
				self:skinCloseButton{obj=self:getChild(_G.PTR_IssueReporter.StandaloneSurvey.SurveyFrame, 2), noSkin=true}
				self:skinStdButton{obj=self:getChild(_G.PTR_IssueReporter.StandaloneSurvey.SurveyFrame, 3), ofs=-1, clr="blue"}
			end

			self:Unhook(_G.PTR_IssueReporter, "GetStandaloneSurveyFrame")
		end)

		self:SecureHook(_G.PTR_IssueReporter, "BuildSurveyFrameFromSurveyData", function(surveyFrame, _, _)
			skinFrame(surveyFrame)
			for _, frame in _G.ipairs(surveyFrame.FrameComponents) do
				if not aObj.isRtl then
					skinFrame(frame, 2, true)
				else
					if frame.IsObjectType
					and frame:IsObjectType("Frame")
					then
						skinFrame(frame, 2, true)
					end
				end
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
	self:checkShown(_G.BasicMessageDialog)

	self:SecureHookScript(_G.ScriptErrorsFrame, "OnShow", function(this)
		if self.isRtl then
			self:skinObject("scrollbox", {obj=this.ScrollFrame.ScrollBar, fType=ftype})
		else
			self:skinObject("slider", {obj=this.ScrollFrame.ScrollBar, fType=ftype})
		end
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ofs=-1, y1=-2})
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

--> N.B. The following frame can't be skinned, as the XML has a ScopedModifier element saying forbidden="true"
	-- SocialUI

aObj.blizzFrames[ftype].StackSplit = function(self)
	if not self.prdb.StackSplit or self.initialized.StackSplit then return end
	self.initialized.StackSplit = true

	self:SecureHookScript(_G.StackSplitFrame, "OnShow", function(this)
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ofs=-10, x2=-8})
		if self.modBtns then
			if self.isRtl then
				self:skinStdButton{obj=_G.StackSplitFrame.OkayButton, fType=ftype}
				self:skinStdButton{obj=_G.StackSplitFrame.CancelButton, fType=ftype}
			else
				self:skinStdButton{obj=_G.StackSplitOkayButton, fType=ftype}
				self:skinStdButton{obj=_G.StackSplitCancelButton, fType=ftype}
			end
		end
		self.callbacks:Fire("StackSplit_skinned")
		-- remove all callbacks for this event
		self.callbacks.events["StackSplit_skinned"] = nil

		self:Unhook(this, "OnShow")
	end)

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
			self:skinObject("moneyframe", {obj=_G[objName .. "MoneyInputFrame"], moveIcon=true})
			_G[objName .. "ItemFrameNameFrame"]:SetTexture(nil)
			self:skinObject("frame", {obj=this, fType=ftype, ofs=-6})
			if self.modBtns then
				self:skinStdButton{obj=this.button1, fType=ftype, schk=true, sechk=true, y1=2}
				self:skinStdButton{obj=this.button2, fType=ftype, schk=true, sechk=true, y1=2}
				self:skinStdButton{obj=this.button3, fType=ftype, schk=true, y1=2}
				self:skinStdButton{obj=this.button4, fType=ftype, schk=true, y1=2}
				self:skinStdButton{obj=this.extraButton, fType=ftype, schk=true, y1=2}
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
	if self.isRtl then
		self:SecureHookScript(_G.PetBattleQueueReadyFrame, "OnShow", function(this)
			self:removeNineSlice(this.Border)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true})
			if self.modBtns then
				self:skinStdButton{obj=this.AcceptButton}
				self:skinStdButton{obj=this.DeclineButton}
			end

			self:Unhook(this, "OnShow")
		end)
	else
		self:SecureHook(_G.PlayerReportFrame, "InitiateReport", function(this, _)
			skinReportFrame(this)

			self:Unhook(this, "InitiateReport")
		end)
	end

end

aObj.blizzFrames[ftype].TextToSpeechFrame = function(self)
	if not self.prdb.TextToSpeechFrame or self.initialized.TextToSpeechFrame then return end
	self.initialized.TextToSpeechFrame = true

	self:SecureHookScript(_G.TextToSpeechFrame, "OnShow", function(this)
		self:skinObject("dropdown", {obj=_G.TextToSpeechFrameTtsVoiceDropdown, fType=ftype})
		self:removeNineSlice(self:getChild(_G.TextToSpeechFrameTtsVoicePicker, 1).NineSlice)
		self:skinObject("scrollbar", {obj=_G.TextToSpeechFrameTtsVoicePicker.ScrollBar, fType=ftype})
		self:skinObject("dropdown", {obj=_G.TextToSpeechFrameTtsVoiceAlternateDropdown, fType=ftype})
		self:SecureHook("TextToSpeechFrame_UpdateAlternate", function()
			self:checkDisabledDD(_G.TextToSpeechFrameTtsVoiceAlternateDropdown)
		end)
		self:removeNineSlice(self:getChild(_G.TextToSpeechFrameTtsVoiceAlternatePicker, 1).NineSlice)
		self:skinObject("scrollbar", {obj=_G.TextToSpeechFrameTtsVoiceAlternatePicker.ScrollBar, fType=ftype})
		self:skinObject("slider", {obj=_G.TextToSpeechFrameAdjustRateSlider, fType=ftype})
		self:skinObject("slider", {obj=_G.TextToSpeechFrameAdjustVolumeSlider, fType=ftype})
		if self.modBtns then
			self:skinStdButton{obj=_G.TextToSpeechFramePlaySampleButton, fType=ftype}
			self:skinStdButton{obj=_G.TextToSpeechFramePlaySampleAlternateButton, fType=ftype, sechk=true}
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
		if not aObj.isRtl then
			self:removeRegions(_G.TimeManagerAlarmEnabledButton, {6, 7})
		else
			self:removeRegions(_G.TimeManagerAlarmEnabledButton, {4, 5})
		end
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true, x2=self.isRtl and 3 or 1})
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

	if _G.IsAddOnLoaded("TinyTooltip")
	and not self.prdb.DisabledSkins["TinyTooltip"]
	then
		_G.setmetatable(self.ttList, {__newindex = function(_, _, tTip)
			tTip = _G.type(tTip) == "string" and _G[tTip] or tTip
			self.callbacks:Fire("Tooltip_Setup", tTip, "init")
		end})
		return
	end

	local delay = 0.025
	-- using a metatable to manage tooltips when they are added in different functions
	_G.setmetatable(self.ttList, {__newindex = function(tab, _, tTip)
		-- get object reference for tooltip, handle either strings or objects being passed
		tTip = _G.type(tTip) == "string" and _G[tTip] or tTip
		-- store using tooltip object as the key
		_G.rawset(tab, tTip, true)
		-- skin here so tooltip initially skinned
		self:skinObject("tooltip", {obj=tTip, ftype=tTip.ftype})
		-- ensure tooltip gradient updated
		if not self.ttHook[tTip] then
			if self.isRtl then
				self.ttHook[tTip] = "OnShow"
			else
				self.ttHook[tTip] = "OnUpdate"
			end
		end
		-- hook Show function for tooltips as required
		-- handle specified function if required [QuestMapFrame.QuestsFrame.CampaignTooltip uses this]
		if self.ttHook[tTip] then
			if self.ttHook[tTip]:find("^On%u")
			and tTip:HasScript(self.ttHook[tTip])
			then
				self:SecureHookScript(tTip, self.ttHook[tTip], function(this)
					_G.C_Timer.After(delay, function() -- slight delay to allow for the tooltip to be populated
						self:applyTooltipGradient(this.sf)
					end)
				end)
			else
				self:SecureHook(tTip, self.ttHook[tTip], function(this)
					_G.C_Timer.After(delay, function() -- slight delay to allow for the tooltip to be populated
						self:applyTooltipGradient(this.sf)
					end)
				end)
			end
		end
		-- if it has an ItemTooltip then add a button border
		if tTip.ItemTooltip
		and self.modBtnBs
		then
			self:addButtonBorder{obj=tTip.ItemTooltip, relTo=tTip.ItemTooltip.Icon}
		end
		-- glaze the Status bar(s) if required
		if self.prdb.Tooltips.glazesb then
			if tTip.GetName -- named tooltips only
			and tTip:GetName()
			then
				local ttSB = _G[tTip:GetName() .. "StatusBar"]
				if ttSB
				and not ttSB.Bar then -- ignore ReputationParagonTooltip
					self:skinObject("statusbar", {obj=ttSB, fi=0})
				end
			end
			if tTip.statusBar2 then
				self:skinObject("statusbar", {obj=tTip.statusBar2, fi=0})
			end
		end
	end})

	-- add tooltips to table
	local function addTooltip(tTip)
		tTip:DisableDrawLayer("OVERLAY")
		tTip.ftype = ftype
		aObj:add2Table(aObj.ttList, tTip)
	end
	local toolTips = {
		_G.GameTooltip,
		_G.EmbeddedItemTooltip,
		_G.ItemRefTooltip,
		_G.ItemRefShoppingTooltip1,
		_G.ItemRefShoppingTooltip2,
		_G.ShoppingTooltip1,
		_G.ShoppingTooltip2,
	}
	if self.isRtl then
		-- self:add2Table(toolTips, _G.GameNoHeaderTooltip) -- N.B. defined in GameTooltip.xml but NOT referenced in code
		self:add2Table(toolTips, _G.GameSmallHeaderTooltip)
	else
		self:add2Table(toolTips, _G.SmallTextTooltip)
	end
	for _, tTip in _G.ipairs(toolTips) do
		if self:hasTextInName(tTip, "ShoppingTooltip") then
			self.ttHook[tTip] = "SetShown"
		end
		addTooltip(tTip)
	end
	if self.modBtns then
		self:skinCloseButton{obj=self.isRtl and _G.ItemRefTooltip.CloseButton or _G.ItemRefCloseButton, noSkin=true}
	end

	-- skin status bars
	if self.prdb.Tooltips.glazesb then
		self:SecureHook("GameTooltip_AddStatusBar", function(this, _)
			for statusBar in this.statusBarPool:EnumerateActive() do
				self:skinObject("statusbar", {obj=statusBar, regions={2}, fi=0, nilFuncs=true})
			end
		end)
		self:SecureHook("GameTooltip_AddProgressBar", function(this, _)
			for progressBar in this.progressBarPool:EnumerateActive() do
				self:skinObject("statusbar", {obj=progressBar.Bar, regions={1, 2, 3, 4, 5}, fi=0, bg=self:getRegion(progressBar.Bar, 7), nilFuncs=true})
			end
		end)
	end

	-- TODO: Find out and fix why GameTooltip sometimes doesn't adjust it's gradient when it appears in the BLH corner.

end

aObj.blizzFrames[ftype].UIDropDownMenu = function(self)
	if not self.prdb.UIDropDownMenu or self.initialized.UIDropDownMenu then return end
	self.initialized.UIDropDownMenu = true

	local function skinDDList(frame)
		local fName = frame:GetName()
		if self.isRtl then
			self:keepFontStrings(frame.Border)
		end
		if not self.isRtl
		or _G.IsAddOnLoaded("TipTac")
		then
			aObj:removeBackdrop(_G[fName .. "Backdrop"])
		end
		aObj:removeBackdrop(_G[fName .. "MenuBackdrop"])
		aObj:removeNineSlice(_G[fName .. "MenuBackdrop"].NineSlice)
		aObj:skinObject("frame", {obj=frame, fType=ftype, kfs=true, ofs=self.isRtl and -4 or -6})
	end

	for i = 1, _G.UIDROPDOWNMENU_MAXLEVELS do
		self:SecureHookScript(_G["DropDownList" .. i], "OnShow", function(this)
			skinDDList(this)

			self:Unhook(this, "OnShow")
		end)
	end

	self:SecureHook("UIDropDownMenu_CreateFrames", function(_)
		if not _G["DropDownList" .. _G.UIDROPDOWNMENU_MAXLEVELS].sf then
			skinDDList(_G["DropDownList" .. _G.UIDROPDOWNMENU_MAXLEVELS])
		end
	end)

end

aObj.blizzFrames[ftype].UIWidgets = function(self)
	if not self.prdb.UIWidgets or self.initialized.UIWidgets then return end
	self.initialized.UIWidgets = true

	local function setTextColor(textObject)
		aObj:rawHook(textObject, "SetTextColor", function(this, r, g, b, a)
			local tcr, tcg, tcb = aObj:round2(r, 2), aObj:round2(g, 2), aObj:round2(b, 2)
			-- aObj:Debug("SetTextColor: [%s, %s, %s, %s, %s]", this, tcr, tcg, tcb)
			if (tcr == 0.41 or tcr == 0.28 and tcg == 0.02 and tcb == 0.02) -- Red
			or (tcr == 0.08 and tcg == 0.17 or tcg == 0.16 and tcb == 0.37) -- Blue
			or (tcr == 0.19 and tcg == 0.05 and tcb == 0.01) -- WarboardUI/Ally choicee in Nazjatar (Horde)
			then
				aObj.hooks[this].SetTextColor(this, aObj.BT:GetRGBA())
			elseif (tcr == 0 and tcg == 0 and tcb == 0) then -- Black
				aObj.hooks[this].SetTextColor(this, _G.HIGHLIGHT_FONT_COLOR:GetRGB())
			else
				aObj.hooks[this].SetTextColor(this, r, g, b, a)
			end
			return tcr
		end, true)
		return textObject:SetTextColor(textObject:GetTextColor())
	end
	-- Documentation in UIWidgetManagerSharedDocumentation.lua (UIWidgetVisualizationType)
	local function skinWidget(wFrame, wInfo)
		-- handle in combat
		if _G.InCombatLockdown() then
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
			local regs
			-- background & border textures
			if self.isRtl then
				regs = {2, 3, 4, 8, 9, 10}
			else
				regs = {1, 2, 3, 5, 6 ,7}
			end
			aObj:skinObject("statusbar", {obj=wFrame.Bar, regions=regs, fi=0, nilFuncs=true})
			if aObj:getChild(wFrame.Bar, 1) then
				aObj:removeRegions(aObj:getChild(wFrame.Bar, 1), {1})
			end
			setTextColor(wFrame.Bar.Label)
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
			wFrame.Foreground:SetTexture(nil)
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
		elseif wFrame.widgetType == 21 then -- TextColumnRow
		elseif wFrame.widgetType == 22 then -- Spacer
		elseif wFrame.widgetType == 23 then -- UnitPowerBar
		elseif wFrame.widgetType == 24 then -- FillUpFrames (Dragonriding Vigor)
			wFrame.DecorLeft:SetAlpha(0)
			wFrame.DecorRight:SetAlpha(0)
			for sBar in wFrame.fillUpFramePool:EnumerateActive() do
				sBar.Frame:SetAlpha(0)
			end
		elseif wFrame.widgetType == 25 then -- TextWithSubtext
		end
	end

	if self.isRtl then
		self:SecureHookScript(_G.UIWidgetCenterDisplayFrame, "OnShow", function(this)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, rns=true})
			if self.modBtnBs then
				self:skinStdButton{obj=this.CloseButton, fType=ftype}
			end

			self:Unhook(this, "OnShow")
		end)
		local function hookAndSkinWidgets(widgetContainer)
			-- aObj:Debug("hookAndSkinWidgets: [%s, %s, %s]", widgetContainer:IsForbidden(), widgetContainer:IsForbidden() or widgetContainer:GetDebugName())
			-- DON'T skin NamePlate[n].* widgets as they cause Clamping Errors if they are initially skinned
			if widgetContainer:IsForbidden()
			or widgetContainer:GetDebugName():find("^NamePlate%d+%.")
			then
				return
			end
			aObj:SecureHook(widgetContainer, "UpdateWidgetLayout", function(this)
				for widget in this.widgetPools:EnumerateActive() do
					skinWidget(widget, _G.UIWidgetManager:GetWidgetTypeInfo(widget.widgetType))
				end
			end)
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

	self:skinObject("slider", {obj=_G.UnitPopupVoiceSpeakerVolume.Slider, fType=ftype})
	self:skinObject("slider", {obj=_G.UnitPopupVoiceMicrophoneVolume.Slider, fType=ftype})
	self:skinObject("slider", {obj=_G.UnitPopupVoiceUserVolume.Slider, fType=ftype})

end
