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
		if self.isMnln then
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
						aObj:skinCheckButton{obj=element.Enabled, size=24}
					end
				end
			end
			_G.ScrollUtil.AddAcquiredFrameCallback(this.ScrollBox, skinElement, aObj, true)
			self:skinObject("ddbutton", {obj=this.Dropdown, fType=ftype})
			self:skinObject("editbox", {obj=this.SearchBox, fType=ftype, si=true})
		else
			for i = 1, _G.MAX_ADDONS_DISPLAYED do
				if self.modBtns then
					self:skinStdButton{obj=_G["AddonListEntry" .. i .. "Load"]}
				end
				if self.modChkBtns then
					self:skinCheckButton{obj=_G["AddonListEntry" .. i .. "Enabled"], size=24}
				end
			end
			self:skinObject("slider", {obj=_G.AddonListScrollFrame.ScrollBar, fType=ftype, rpTex="background"})
			self:skinObject("ddbutton", {obj=this.Dropdown, fType=ftype})
		end
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true, x2=self.isClsc and 1})
		if self.modBtns then
			self:skinStdButton{obj=this.CancelButton}
			self:skinStdButton{obj=this.OkayButton}
			self:skinStdButton{obj=this.EnableAllButton}
			self:skinStdButton{obj=this.DisableAllButton}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.AddonList.ForceLoad or _G.AddonListForceLoad, size=24}
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].AlertFrames = function(self)
	if not self.prdb.AlertFrames or self.initialized.AlertFrames then return end
	self.initialized.AlertFrames = true

	--@debug@
	local dontDebug = {
		["Achievement"]            = true,
		["Criteria"]               = true,
		["DungeonCompletion"]      = true,
		["GarrisonFollower"]       = true,
		["GarrisonMission"]        = true,
		["GarrisonTalent"]         = true,
		["Loot"]                   = true,
		["LootUpgrade"]            = true,
		["MoneyWon"]               = true,
		["MonthlyActivity"]        = true,
		["NewCosmetic"]            = true,
		["NewMount"]               = true,
		["NewPet"]                 = true,
		["NewRecipeLearned"]       = true,
		["NewToy"]                 = true,
		["SkillLineSpecsUnlocked"] = true,
		["WorldQuestComplete"]     = true,
	}
	--@end-debug@

	local alertType = {
		["Achievement"]           = {ofs = 0, nt = {"Background"}, stc = "Unlocked", icon = {obj = "Icon", ddl = {"border", "overlay"}, tex = "Texture"}},
		["Criteria"]              = {ofs = -8, y1 = -6, nt = {"Background"}, stc = "Unlocked", icon = {obj = "Icon", ddl = {"border", "overlay"}, tex ="Texture"}},
		["DigsiteComplete"]       = {ofs = -10, ddl = {"background"}},
		["DungeonCompletion"]     = {ofs = -8, ddl = {"background", "border", "overlay"}, sdla = "dungeonTexture", icon = {tex = "dungeonTexture"}},
		["GarrisonBuilding"]      = {ofs = -10, ddl = {"background", "border", "overlay"}},
		["GarrisonFollower"]      = {ofs = -8, y1 = 0, ddl = {"background"}, nt = {"FollowerBG"}, nt2 = {PortraitFrame = "LevelBorder"}, stn2 = {PortraitFrame = "PortraitRing"}},
		["GarrisonMission"]       = {ofs = -10, y1=-6, ddl = {"background", "border"}},
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
		-- N.B. Appears in XML file but not in LUA file (used by NewPet, NewMount, NewToy, NewRuneforge & NewCosmetic alerts templates)
		-- ["Item"]               = {ofs = -8, ddl = {"background"}, ib = true},
	}
	if self.isMnln then
		alertType["Achievement"].y1         = -15
		alertType["Achievement"].y2         = 12
		alertType["EntitlementDelivered"]   = {ofs = -10}
		alertType["GuildRename"]            = {ofs = -10}
		alertType["Loot"].icon              = {obj = "lootItem", stn = {"SpecRing"}, ib = true, tex =  "Icon"}
		alertType["MonthlyActivity"]        = {ofs = 0, nt = {"Background"}, stc = "Unlocked", icon = {obj = "Icon", ddl = {"border", "overlay"}, tex ="Texture"}}
		alertType["NewCosmetic"]            = {ofs = -8, y1 = -12, ddl = {"background"}, ib = true, iq = _G.Enum.ItemQuality.Epic}
		alertType["NewRuneforgePower"]      = {ofs = -8, ddl = {"background"}, ib = true, iq = _G.Enum.ItemQuality.Legendary}
		alertType["NewToy"]                 = {ofs = -8, y1 = -12, ddl = {"background"}, ib = true}
		alertType["NewWarbandScene"]        = {ofs = -8, y1 = -12, ddl = {"background"}, ib = true}
		alertType["RafRewardDelivered"]     = {ofs = -10}
		alertType["Scenario"].y1            = -8
		alertType["Scenario"].y2            = 8
		alertType["SkillLineSpecsUnlocked"] = {ofs = 0, ddl = {"background"}}
	else
		alertType["Achievement"].y1         = -10
		alertType["Achievement"].y2         = 10
		alertType["Loot"].stn               = {"SpecRing"}
		alertType["Loot"].ib                = true
		alertType["StorePurchase"]          = {ofs = -12, ddl = {"background"}}
	end
	if aObj.isMnlnPTRX then
		-- TODO: Check on Icon Border etc
		alertType["HousingItemEarned"]		= {ofs = -8, ddl = {"background", "border"}, stn = {"Divider"}, icon = {obj = "Icon"}}
	end

	local adj, tbl, itemQuality = {}
	local function skinAlertFrame(type, frame)
		tbl = alertType[type]
		--@debug@
		aObj:Debug("skinAlertFrame: [%s, %s, %s]", type, frame)
		if not dontDebug[type] then
			_G.Spew("AlertFrames", tbl)
			_G.Spew("AlertFrames", frame)
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
				frame[tex]:SetAlpha(0)
			end
		end
		if tbl.nt2 then
			for key, tex in _G.pairs(tbl.nt2) do
				frame[key][tex]:SetAlpha(0)
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
		adj.x1 = tbl.x1 or tbl.ofs * -1
		adj.y1 = tbl.y1 or tbl.ofs
		adj.x2 = tbl.x2 or tbl.ofs
		adj.y2 = tbl.y2 or tbl.ofs * -1
		-- handle GuildAchievement size changes
		if type =="Achievement"
		and _G.select(12, _G.GetAchievementInfo(frame.id))
		then
			adj.y1 = 0
			adj.y2 = 0
		end
		aObj:skinObject("frame", {obj=frame, fType=ftype, x1=adj.x1, y1=adj.y1, x2=adj.x2, y2=adj.y2, ncc=true})
		-- add button border if required
		if aObj.modBtnBs then
			itemQuality = tbl.iq
			if frame.hyperlink then -- Loot Won & Loot Upgrade Alerts
				if frame.isCurrency then
					itemQuality = _G.C_CurrencyInfo.GetCurrencyInfoFromLink(frame.hyperlink).quality
				else
					itemQuality = _G.select(3, _G.C_Item.GetItemInfo(frame.hyperlink))
				end
			elseif type == "NewPet" then
				itemQuality = _G.select(5, _G.C_PetJournal.GetPetStats(frame.petID)) - 1 -- rarity value - 1
			elseif type == "NewToy" then
				itemQuality = _G.select(6, _G.C_ToyBox.GetToyInfo(frame.toyID))
				-- TODO: Item has a quality iconborder atlas
			elseif type == "Item" then
				--@debug@
				aObj:Debug("Item Alert Border Atlas: [%s, %s]", frame.IconBorder:GetAtlas())
				--@end-debug@
			end
			if not tbl.icon then
				if frame.Icon then
					frame.Icon:SetDrawLayer("BORDER")
					if not tbl.nis then
						aObj:addButtonBorder{obj=frame, fType=ftype, relTo=frame.Icon}
					end
				end
				if tbl.ib then
					frame.IconBorder:SetTexture(nil)
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
					frame = frame[tbl.icon.obj or "Icon"]
				end
				aObj:addButtonBorder{obj=frame, fType=ftype, relTo=frame[tbl.icon.tex]}
			end
			if itemQuality then
				aObj:setBtnClr(frame, itemQuality)
			end
		end
	end
	for type, _ in _G.pairs(alertType) do
		local sysName = "AlertSystem"
		if type == "NewCosmetic"
		or type == "HousingItemEarned"
		then
			sysName = "AlertFrameSystem"
		end
		self:SecureHook(_G[type .. sysName], "setUpFunction", function(frame, _)
			skinAlertFrame(type, frame)
		end)
		for frame in _G[type .. sysName].alertFramePool:EnumerateActive() do
			skinAlertFrame(type, frame)
		end
	end

	-- hook this to remove rewardFrame rings
	self:SecureHook("StandardRewardAlertFrame_AdjustRewardAnchors", function(frame)
		if frame.RewardFrames then
			for _, rf in _G.pairs(frame.RewardFrames) do
				rf:DisableDrawLayer("OVERLAY") -- reward ring
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

	-- hook this to stop gradient texture whiteout
	if _G.C_AddOns.IsAddOnLoaded("Overachiever") then
		self:RawHook(_G.AlertFrame, "AddAlertFrame", function(this, frame)
			local ocScript = frame:GetScript("OnClick")
			if ocScript
			and ocScript == _G.OverachieverAlertFrame_OnClick
			then
				-- stretch icon texture
				frame.Icon.Texture:SetTexCoord(-0.04, 0.75, 0.0, 0.555)
				skinAlertFrame("Achievement", frame)
			end
			self.hooks[this].AddAlertFrame(this, frame)
		end, true)
	end

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

		if _G.C_AddOns.IsAddOnLoaded("Capping") then
			if _G.type(self["Capping_ModMap"]) == "function" then self:Capping_ModMap() end
		end

		if _G.C_AddOns.IsAddOnLoaded("Mapster") then
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
			self:skinObject("ddbutton", {obj=this.FilterButton, fType=ftype, filter=true})
			self:moveObject{obj=_G.CalendarCloseButton, y=14}
			self:adjHeight{obj=_G.CalendarCloseButton, adj=-2}
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
				if not self.isMnln then
					self:addButtonBorder{obj=_G.CalendarFilterButton, es=14, x1=3, y1=0, x2=3, y2=0}
				end
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
			self:skinObject("ddbutton", {obj=this.EventTypeDropdown, fType=ftype})
			self:skinObject("ddbutton", {obj=this.HourDropdown, fType=ftype})
			self:skinObject("ddbutton", {obj=this.MinuteDropdown, fType=ftype})
			self:skinObject("ddbutton", {obj=this.AMPMDropdown, fType=ftype})
			self:skinObject("ddbutton", {obj=this.DifficultyOptionDropdown, fType=ftype})
			self:skinObject("ddbutton", {obj=this.CommunityDropdown, fType=ftype})
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
			self:skinObject("ddbutton", {obj=this.CommunityDropdown, fType=ftype})
			self:skinObject("ddbutton", {obj=this.RankDropdown, fType=ftype})
			self:skinObject("editbox", {obj=_G.CalendarMassInviteMinLevelEdit, fType=ftype})
			self:skinObject("editbox", {obj=_G.CalendarMassInviteMaxLevelEdit, fType=ftype})
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
				self:skinStdButton{obj=_G.CalendarEventPickerCloseButton}
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
			for _, cBubble in _G.pairs(_G.C_ChatBubbles.GetAllChatBubbles(false)) do
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
	local function OnValueChanged(_, _, value)
		unRegisterEvents()
		if value ~= 2 then -- either All or ExcludeParty
			registerEvents()
			skinChatBubbles()
		end
	end
	_G.Settings.SetOnValueChangedCallback("PROXY_CHAT_BUBBLES", OnValueChanged)

end

aObj.blizzFrames[ftype].ChatConfig = function(self)
	if not self.prdb.ChatConfig or self.initialized.ChatConfig then return end
	self.initialized.ChatConfig = true

	self:SecureHookScript(_G.ChatConfigFrame, "OnShow", function(this)
		if self.isMnln then
			self:removeNineSlice(this.Border)
		end
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, hdr=true, ofs=-4, y1=0})
		if self.modBtns then
			self:skinStdButton{obj=this.DefaultButton, fType=ftype}
			self:skinStdButton{obj=this.RedockButton, fType=ftype}
			if not self.isMnln then
				self:skinStdButton{obj=this.ToggleChatButton, fType=ftype}
			end
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
			local ctmtabs = {}
			local function skinTabs(ctm)
				for tab in ctm.tabPool:EnumerateActive() do
					aObj:add2Table(ctmtabs, tab)
					if tab:GetID() == _G.CURRENT_CHAT_FRAME_ID then
						tab:GetFontString():SetTextColor(1, 1, 1)
					else
						tab:GetFontString():SetTextColor(_G.NORMAL_FONT_COLOR.r, _G.NORMAL_FONT_COLOR.g, _G.NORMAL_FONT_COLOR.b)
					end
				end
				aObj:skinObject("tabs", {obj=ctm, tabs=ctmtabs, fType=ftype, upwards=true, ignoreHLTex=false, offsets={x1=0, y1=aObj.isTT and -10 or -12, x2=0, y2=aObj.isTT and -5 or 0}, regions={8, 9, 10, 11}, noCheck=true, func=setTabState})
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
			cBox = cBox:gsub("CheckBox", "Checkbox")
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
						aObj:skinCheckButton{obj=box, fType=ftype}
						if suffix == "ColorClasses" then
							box:SetHeight(24)
						end
					end
				end
			end
		end

		self:SecureHookScript(_G.ChatConfigChatSettings, "OnShow", function(fObj)
			self:skinObject("frame", {obj=_G.ChatConfigChatSettingsLeft, fType=ftype, kfs=true, rns=true, fb=true, ofs=0})
			if not self.isMnln then
				self:skinObject("frame", {obj=_G.ChatConfigChatSettingsClassColorLegend, fType=ftype, kfs=true, rns=true, fb=true, ofs=0})
			end
			if self.modChkBtns then
				for i = 1, #_G.CHAT_CONFIG_CHAT_LEFT do
					skinCB("ChatConfigChatSettingsLeftCheckBox" .. i)
				end
			end

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(_G.ChatConfigChatSettings)

		self:SecureHookScript(_G.ChatConfigChannelSettings, "OnShow", function(fObj)
			self:skinObject("frame", {obj=_G.ChatConfigChannelSettingsLeft, fType=ftype, kfs=true, rns=true, fb=true, ofs=0})
			if not self.isMnln then
				self:skinObject("frame", {obj=_G.ChatConfigChannelSettingsClassColorLegend, fType=ftype, kfs=true, rns=true, fb=true, ofs=0})
			end
			local function skinLeft(frame)
				for i = 1, #frame.checkBoxTable do
					skinCB(frame:GetName() .. "CheckBox" .. i)
				end
			end
			skinLeft(_G.ChatConfigChannelSettingsLeft)
			self:SecureHook("ChatConfig_CreateCheckboxes", function(frame, _)
				skinLeft(frame)
			end)
			if not self.isMnln then
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
					self:skinCheckButton{obj=_G[frame:GetName() .. (self.isMnln and "Checkbox" or "CheckBox") .. i], fType=ftype}
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
			self:skinObject("tabs", {obj=fObj, prefix="CombatConfig", numTabs=#_G.COMBAT_CONFIG_TABS, fType=ftype, lod=self.isTT and true, upwards=true, offsets={y1=-8, y2=self.isTT and -5 or 0}, regions={4, 5}, track=false})
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
				if self.isMnln then
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
					self:addButtonBorder{obj=_G.ChatConfigMoveFilterUpButton, es=12, ofs=-5, x2=-6, y2=7}
					self:addButtonBorder{obj=_G.ChatConfigMoveFilterDownButton, es=12, ofs=-5, x2=-6, y2=7}
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

	if _G.C_AddOns.IsAddOnLoaded("NeonChat")
	or _G.C_AddOns.IsAddOnLoaded("Chatter")
	or _G.C_AddOns.IsAddOnLoaded("Prat-3.0")
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
		if self.isMnln then
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
	self:skinObject("tabs", {obj=_G.FloatingChatFrameManager, tabs=fcfTabs, fType=ftype, lod=self.isTT and true, upwards=true, ignoreHLTex=false, regions={7, 8, 9, 10, 11}, offsets={x1=1, y1=-10, x2=-1, y2=-3}, track=false, func=function(tab) tab.sf:SetAlpha(tab:GetAlpha()) tab.sf:Hide() end})
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
		if self.isMnln then
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

aObj.blizzLoDFrames[ftype].DebugTools = function(self)
	if not self.prdb.DebugTools or self.initialized.DebugTools then return end
	self.initialized.DebugTools = true

	local function skinTAD(frame)
		aObj:skinObject("editbox", {obj=frame.FilterBox, fType=ftype, si=true})
		aObj:skinObject("scrollbar", {obj=frame.LinesScrollFrame.ScrollBar, fType=ftype, x1=aObj.isClsc and 1 or nil, x2=not aObj.isMnln and 5 or nil})
		aObj:skinObject("frame", {obj=frame.ScrollFrameArt, fType=ftype, rns=true, fb=true, x2=not self.isMnln and -10})
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
				if aObj.modFCBtns then
					aObj:clrBtnBdr(frame.OpenParentButton)
				end
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
				if aObj.modFCBtns then
					aObj:clrBtnBdr(frame.NavigateBackwardButton)
					aObj:clrBtnBdr(frame.NavigateForwardButton)
				end
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

	self.ttHook[_G.FrameStackTooltip] = "OnUpdate"
	_G.C_Timer.After(0.1, function()
		self:add2Table(self.ttList, _G.FrameStackTooltip)
		_G.FrameStackTooltip:SetFrameLevel(20)
	end)

end

if not aObj.isClscERA then
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
end

aObj.blizzLoDFrames[ftype].EventTrace = function(self)
	if not self.prdb.EventTrace or self.initialized.EventTrace then return end
	self.initialized.EventTrace = true

	local function skinMenuBtn(btn)
		aObj:skinStdButton{obj=btn, fType=ftype, y1=2, y2=-3}
		aObj.modUIBtns:chgHLTex(btn, btn.MouseoverOverlay)
	end
	self:SecureHookScript(_G.EventTrace, "OnShow", function(this)
		self:skinObject("editbox", {obj=this.Log.Bar.SearchBox, fType=ftype, si=true})
		self:skinObject("scrollbar", {obj=this.Log.Events.ScrollBar, fType=ftype})
		self:skinObject("scrollbar", {obj=this.Log.Search.ScrollBar, fType=ftype})
		self:skinObject("scrollbar", {obj=this.Filter.ScrollBar, fType=ftype})
		if self.isMnln then
			self:skinObject("ddbutton", {obj=this.SubtitleBar.OptionsDropdown, fType=ftype, filter=true})
		end
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true, x2=aObj.isMnln and 3 or 1})
		if self.modBtns then
			skinMenuBtn(this.SubtitleBar.ViewLog)
			skinMenuBtn(this.SubtitleBar.ViewFilter)
			if not self.isMnln then
				self:skinStdButton{obj=this.SubtitleBar.OptionsDropDown, fType=ftype}
			end
			skinMenuBtn(this.Log.Bar.MarkButton)
			skinMenuBtn(this.Log.Bar.PlaybackButton)
			skinMenuBtn(this.Log.Bar.DiscardAllButton)
			skinMenuBtn(this.Filter.Bar.CheckAllButton)
			skinMenuBtn(this.Filter.Bar.UncheckAllButton)
			skinMenuBtn(this.Filter.Bar.DiscardAllButton)
		end

		self:Unhook(this, "OnShow")
	end)
	if self.modBtns
	or self.modChkBtns
	then
		self:SecureHook(_G.EventTraceLogEventButtonMixin, "Init", function(this, _)
			if self.modBtns then
				self:skinCloseButton{obj=this.HideButton, fType=ftype, noSkin=true}
			end
		end)
		self:SecureHook(_G.EventTraceFilterButtonMixin, "Init", function(this, _)
			if self.modBtns then
				self:skinCloseButton{obj=this.HideButton, fType=ftype, noSkin=true}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=this.CheckButton, fType=ftype, ofs=-1}
			end
		end)
	end
	self:checkShown(_G.EventTrace)

	-- tooltip
	_G.C_Timer.After(0.1, function()
		self:add2Table(self.ttList, _G.EventTraceTooltip)
	end)

end

if not aObj.isClscERA then
	aObj.blizzFrames[ftype].GhostFrame = function(self)
		if not self.prdb.GhostFrame or self.initialized.GhostFrame then return end
		self.initialized.GhostFrame = true

		self:SecureHookScript(_G.GhostFrame, "OnShow", function(this)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true})
			_G.RaiseFrameLevelByTwo(this) -- make it appear above other frames
			if self.modBtnBs then
				self:addButtonBorder{obj=_G.GhostFrameContentsFrame, relTo=_G.GhostFrameContentsFrameIcon}
			end

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.GhostFrame)

	end
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
				local kRegions = _G.CopyTable(self.ebRgns, true)
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
							self:addButtonBorder{obj=btn, fType=ftype, ibt=true}
						else
							self:clrButtonFromBorder(btn)
						end
					end
				end
			end)
		end
		if not self.isClscERA then
			self:skinObject("editbox", {obj=_G.GuildItemSearchBox, fType=ftype, si=true})
			this.MoneyFrameBG:DisableDrawLayer("BACKGROUND")
		end
		self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true})
		-- Tabs (side)
		for _, tab in _G.pairs(this.BankTabs) do
			tab:DisableDrawLayer("BACKGROUND")
			if self.modBtnBs then
				 self:addButtonBorder{obj=tab.Button, fType=ftype, relTo=tab.Button.IconTexture, ofs=3, x2=2}
			end
		end
		if self.isMnln then
			self:skinObject("scrollbar", {obj=_G.GuildBankInfo.ScrollFrame.ScrollBar, fType=ftype})
			self:skinObject("scrollbar", {obj=this.Log.ScrollBar, fType=ftype})
		else
			self:skinObject("slider", {obj=_G.GuildBankInfo.ScrollFrame.ScrollBar, fType=ftype, rpTex="artwork"})
			self:skinObject("slider", {obj=this.Log.ScrollBar, fType=ftype, rpTex="artwork"})
		end
		if not self.isClsc then
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, hdr=true, cb=true, y1=self.isClsc and -11, x2=self.isClsc and 1, y2=self.isClsc and 3 or -2})
		else
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, hdr=true, cb=true, x2=1, y2=-2})
		end
		if self.modBtns then
			self:skinStdButton{obj=this.DepositButton, fType=ftype, x1=0} -- don't overlap withdraw button
			self:skinStdButton{obj=this.WithdrawButton, fType=ftype, schk=true, x2=0} -- don't overlap deposit button
			self:skinStdButton{obj=this.BuyInfo.PurchaseButton, fType=ftype, schk=true}
			self:skinStdButton{obj=this.Info.SaveButton, fType=ftype}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.GuildBankPopupFrame, "OnShow", function(this)
		self:adjHeight{obj=this, adj=20}
		if self.isMnln then
			self:skinIconSelector(this, ftype)
		else
			self:removeRegions(_G.BorderBox, {1, 2, 3, 4, 5, 6, 7, 8})
			self:skinObject("editbox", {obj=this.EditBox, fType=ftype})
			self:adjHeight{obj=this.ScrollFrame, adj=20} -- stretch to bottom of scroll area
			self:skinObject("slider", {obj=this.ScrollFrame.ScrollBar, fType=ftype, rpTex="background"})
			for _, btn in _G.pairs(this.Buttons) do
				btn:DisableDrawLayer("BACKGROUND")
				if self.modBtnBs then
					self:addButtonBorder{obj=btn, relTo=btn.Icon}
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
		if not self.isMnln then
			this.TitleContainer.TitleBg:SetTexture(nil)
		end
		self:removeInset(this.Browser.BrowserInset)
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, hdr=true, ri=true, rns=true, cb=true, x1=2, x2=2, y2=0})

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

aObj.blizzFrames[ftype].HelpPlate = function(self)
	if not self.prdb.Tutorial or self.initialized.HelpPlate then return end
	self.initialized.HelpPlate = true

	self:SecureHookScript(_G.HelpPlateTooltip, "OnShow", function(this)
		this:DisableDrawLayer("BORDER") -- hide Arrow glow textures
		self:skinObject("glowbox", {obj=this, fType=ftype})
		-- move Arrow textures to align with frame border
		if self.isClscERA then
			self:moveObject{obj=this.ArrowUP, y=-2}
			self:moveObject{obj=this.ArrowDOWN, y=2}
			self:moveObject{obj=this.ArrowRIGHT, x=-2}
			self:moveObject{obj=this.ArrowLEFT, x=2}
		else
			self:moveObject{obj=this.ArrowUp, y=-2}
			self:moveObject{obj=this.ArrowDown, y=2}
			self:moveObject{obj=this.ArrowRight, x=-2}
			self:moveObject{obj=this.ArrowLeft, x=2}
		end

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.HelpPlateTooltip)

end

aObj.blizzFrames[ftype].ItemText = function(self)
	if not self.prdb.ItemText or self.initialized.ItemText then return end
	self.initialized.ItemText = true

	local function skinITFrame(frame)
		aObj:skinObject("statusbar", {obj=_G.ItemTextStatusBar, fi=0})
		if aObj.isMnln then
			aObj:skinObject("scrollbar", {obj=_G.ItemTextScrollFrame.ScrollBar, fType=ftype})
			aObj:skinObject("frame", {obj=frame, fType=ftype, kfs=true, ri=true, rns=true, cb=true, x2=3})
		else
			aObj:skinObject("slider", {obj=_G.ItemTextScrollFrame.ScrollBar, fType=ftype, rpTex={"background", "artwork"}})
			if not self.isClsc then
				aObj:skinObject("frame", {obj=frame, fType=ftype, kfs=true, x1=10, y1=-12, x2=-31, y2=60})
				if aObj.modBtns then
					aObj:skinCloseButton{obj=_G.ItemTextCloseButton}
				end
			else
				aObj:skinObject("frame", {obj=frame, fType=ftype, kfs=true, cb=true, x2=1})
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
		_G.ItemTextPageText:SetTextColor("P", self.BT:GetRGB())
		_G.ItemTextPageText:SetTextColor("H1", self.HT:GetRGB())
		_G.ItemTextPageText:SetTextColor("H2", self.HT:GetRGB())
		_G.ItemTextPageText:SetTextColor("H3", self.HT:GetRGB())
		if skinITFrame then
			skinITFrame(this)
		end
	end)

end

if not aObj.isClscERA then
	aObj.blizzFrames[ftype].LFDFrame = function(self)
		if not self.prdb.PVEFrame or self.initialized.LFDFrame then return end
		self.initialized.LFDFrame = true

		self:SecureHookScript(_G.LFDRoleCheckPopup, "OnShow", function(this)
			self:removeNineSlice(this.Border)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true})
			if self.modBtns then
				self:skinStdButton{obj=_G.LFDRoleCheckPopupAcceptButton, schk=true}
				self:skinStdButton{obj=_G.LFDRoleCheckPopupDeclineButton}
			end

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.LFDRoleCheckPopup)

		self:SecureHookScript(_G.LFDReadyCheckPopup, "OnShow", function(this)
			self:removeNineSlice(this.Border)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true})
			if self.modBtns then
				self:skinStdButton{obj=this.YesButton}
				self:skinStdButton{obj=this.NoButton}
			end

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.LFDReadyCheckPopup)

		-- LFD Parent Frame (now part of PVE Frame)
		self:SecureHookScript(_G.LFDParentFrame, "OnShow", function(this)
			self:keepFontStrings(this)
			self:removeInset(this.Inset)
			-- LFD Queue Frame
			_G.LFDQueueFrameBackground:SetAlpha(0)
			self:skinRoleBtns("LFD")
			self:skinObject("ddbutton", {obj=_G.LFDQueueFrame.TypeDropdown, fType=ftype})
			_G.LFDQueueFrameRandomScrollFrameChildFrame.MoneyReward.NameFrame:SetTexture(nil)
			self:removeMagicBtnTex(_G.LFDQueueFrameFindGroupButton)
			self:skinObject("scrollbar", {obj=_G.LFDQueueFrame.Specific.ScrollBar, fType=ftype})
			local function skinDungeonLine(...)
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
						aObj:skinExpandButton{obj=element.expandOrCollapseButton, sap=true}
					end
					if aObj.modChkBtns then
						aObj:skinCheckButton{obj=element.enableButton}
					end
				end
			end
			_G.ScrollUtil.AddAcquiredFrameCallback(_G.LFDQueueFrame.Specific.ScrollBox, skinDungeonLine, aObj, true)
			if self.isMnln then
				self:getRegion(_G.LFDQueueFrame.Follower, 3):SetTexture(nil) -- divider line
				self:skinObject("scrollbar", {obj=_G.LFDQueueFrame.Follower.ScrollBar, fType=ftype})
				_G.ScrollUtil.AddAcquiredFrameCallback(_G.LFDQueueFrame.Follower.ScrollBox, skinDungeonLine, aObj, true)
			end
			if self.modBtns then
				self:skinStdButton{obj=_G.LFDQueueFrameFindGroupButton, schk=true}
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=_G.LFDQueueFrameRandomScrollFrameChildFrame.MoneyReward, fType=ftype, libt=true}
				self:SecureHook("LFDQueueFrameRandom_UpdateFrame", function()
					local fName = "LFDQueueFrameRandomScrollFrameChildFrame"
					for i = 1, _G[fName].numRewardFrames do
						if _G[fName .. "Item" .. i] then
							_G[fName .. "Item" .. i .. "NameFrame"]:SetTexture(nil)
							self:addButtonBorder{obj=_G[fName .. "Item" .. i], fType=ftype, libt=true}
						end
					end
				end)
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].LFGFrame = function(self)
		if not self.prdb.PVEFrame or self.initialized.LFGFrame then return end
		self.initialized.LFGFrame = true

		self:SecureHookScript(_G.LFGDungeonReadyPopup, "OnShow", function(this) -- a.k.a. ReadyCheck, also used for Island Expeditions
			self:SecureHookScript(_G.LFGDungeonReadyStatus, "OnShow", function(fObj)
				self:removeNineSlice(fObj.Border)
				self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, ofs=0})
				if self.modBtns then
					self:skinOtherButton{obj=_G.LFGDungeonReadyStatusCloseButton, text=self.modUIBtns.minus, noSkin=true}
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(_G.LFGDungeonReadyStatus)

			self:SecureHookScript(_G.LFGDungeonReadyDialog, "OnShow", function(fObj)
				self:removeNineSlice(fObj.Border)
				fObj.SetBackdrop = _G.nop
				fObj.instanceInfo:DisableDrawLayer("BACKGROUND")
				self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, rpc=true, ofs=-5, y2=10}) -- use rpc=true to make background visible
				if self.modBtns then
					self:skinOtherButton{obj=_G.LFGDungeonReadyDialogCloseButton, text=self.modUIBtns.minus, noSkin=true}
					self:skinStdButton{obj=fObj.enterButton}
					self:skinStdButton{obj=fObj.leaveButton}
				end

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

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(_G.LFGDungeonReadyDialog)

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.LFGDungeonReadyPopup)

		-- hook new button creation
		self:RawHook("LFGRewardsFrame_SetItemButton", function(...)
			local frame = self.hooks.LFGRewardsFrame_SetItemButton(...)
			_G[frame:GetName() .. "NameFrame"]:SetTexture(nil)
			if self.modBtnBs then
				self:addButtonBorder{obj=frame, fType=ftype, libt=true}
			end
			return frame
		end, true)

		self:SecureHookScript(_G.LFGInvitePopup, "OnShow", function(this)
			self:removeNineSlice(this.Border)
			self:skinObject("frame", {obj=this, fType=ftype})
			if self.modBtns then
				self:skinStdButton{obj=_G.LFGInvitePopupAcceptButton}
				self:skinStdButton{obj=_G.LFGInvitePopupDeclineButton}
			end
			if self.modChkBtns then
				for _, btn in _G.pairs(this.RoleButtons) do
					self:skinCheckButton{obj=btn.checkButton}
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

			self:SecureHookScript(this.CategorySelection, "OnShow", function(fObj)
				self:removeInset(fObj.Inset)
				self:removeMagicBtnTex(fObj.FindGroupButton)
				self:removeMagicBtnTex(fObj.StartGroupButton)
				if self.modBtns then
					self:skinStdButton{obj=fObj.StartGroupButton, sechk=true}
					self:skinStdButton{obj=fObj.FindGroupButton, sechk=true}
				end
				self:SecureHook("LFGListCategorySelection_AddButton", function(frame, _)
					for _, btn in _G.pairs(frame.CategoryButtons) do
						btn.Cover:SetTexture(nil)
					end
				end)

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.CategorySelection)

			self:removeInset(this.NothingAvailable.Inset)

			self:SecureHookScript(this.SearchPanel, "OnShow", function(fObj)
				self:skinObject("editbox", {obj=fObj.SearchBox, fType=ftype, si=true})
				if self.isMnln then
					self:skinObject("ddbutton", {obj=fObj.FilterButton, fType=ftype, filter=true})
				end
				self:skinObject("frame", {obj=fObj.AutoCompleteFrame, fType=ftype, kfs=true, ofs=4})
				self:removeInset(fObj.ResultsInset)
				if not self.isMnln then
					self:skinObject("dropdown", {obj=_G.LFGListLanguageFilterDropDownFrame, fType=ftype})
				end
				self:skinObject("scrollbar", {obj=fObj.ScrollBar, fType=ftype})
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
						if elementData.startGroup then
							if aObj.modBtns then
								aObj:skinStdButton{obj=aObj:getChild(element, 1), fType=ftype}
							end
						else
							element.ResultBG:SetTexture(nil)
							if aObj.modBtns then
								aObj:skinStdButton{obj=element.CancelButton}
							end
						end
					end
				end
				_G.ScrollUtil.AddAcquiredFrameCallback(fObj.ScrollBox, skinElement, aObj, true)
				-- hook this to colour text
				local appStatus, pendingStatus, isAppFinished, searchResultInfo
				self:SecureHook("LFGListSearchEntry_Update", function(lObj)
					_, appStatus, pendingStatus, _ = _G.C_LFGList.GetApplicationInfo(lObj.resultID)
					isAppFinished = _G.LFGListUtil_IsStatusInactive(appStatus) or _G.LFGListUtil_IsStatusInactive(pendingStatus)
					searchResultInfo = _G.C_LFGList.GetSearchResultInfo(lObj.resultID)

					if searchResultInfo.isDelisted
					or isAppFinished
					then
						-- LFG_LIST_DELISTED_FONT_COLOR for both
						lObj.Name:SetTextColor(aObj.DT:GetRGB())
						lObj.ActivityName:SetTextColor(aObj.DT:GetRGB())
					elseif searchResultInfo.numBNetFriends > 0
					or searchResultInfo.numCharFriends > 0
					or searchResultInfo.numGuildMates > 0
					then
						-- BATTLENET_FONT_COLOR for name
						lObj.ActivityName:SetTextColor(aObj.BT:GetRGB())
					else
						lObj.Name:SetTextColor(aObj.HT:GetRGB())
						lObj.ActivityName:SetTextColor(aObj.BT:GetRGB())
					end
				end)
				self:removeMagicBtnTex(fObj.BackButton)
				self:removeMagicBtnTex(fObj.SignUpButton)
				if self.modBtns then
					if not self.isMnln then
						self:skinStdButton{obj=fObj.FilterButton, fType=ftype}
					end
					self:skinStdButton{obj=fObj.ScrollBox.StartGroupButton, schk=true}
					self:skinStdButton{obj=fObj.BackButton}
					self:skinStdButton{obj=fObj.BackToGroupButton}
					self:skinStdButton{obj=fObj.SignUpButton, schk=true}
				end
				if self.modBtnBs then
					if not self.isMnln then
						self:addButtonBorder{obj=fObj.FilterButton, ftype=ftype, ofs=1}
					end
					self:addButtonBorder{obj=fObj.RefreshButton, ofs=-2, clr="gold"}
				end

				self:Unhook(fObj, "OnShow")
			end)

			self:SecureHookScript(this.ApplicationViewer, "OnShow", function(fObj)
				fObj:DisableDrawLayer("BACKGROUND")
				self:removeInset(fObj.Inset)
				for _ ,type in _G.pairs{"Name", "Role", "ItemLevel", "Rating"} do
					self:removeRegions(fObj[type .. "ColumnHeader"], {1, 2, 3})
					if self.modBtns then
						 self:skinStdButton{obj=fObj[type .. "ColumnHeader"]}
					end
				end
				self:skinObject("scrollbar", {obj=fObj.ScrollBar, fType=ftype})
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
							aObj:skinStdButton{obj=element.DeclineButton}
							aObj:skinStdButton{obj=element.InviteButton}
							aObj:skinStdButton{obj=element.InviteButtonSmall}
						end
					end
				end
				_G.ScrollUtil.AddAcquiredFrameCallback(fObj.ScrollBox, skinElement, aObj, true)
				self:removeMagicBtnTex(fObj.RemoveEntryButton)
				self:removeMagicBtnTex(fObj.EditButton)
				if self.modBtns then
					self:skinStdButton{obj=fObj.RemoveEntryButton}
					self:skinStdButton{obj=fObj.EditButton}
					self:skinStdButton{obj=fObj.BrowseGroupsButton}
				end
				if self.modBtnBs then
					 self:addButtonBorder{obj=fObj.RefreshButton, ofs=-2, clr="gold"}
				end
				if self.modChkBtns then
					 self:skinCheckButton{obj=fObj.AutoAcceptButton}
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.ApplicationViewer)

			self:SecureHookScript(this.EntryCreation, "OnShow", function(fObj)
				self:removeInset(fObj.Inset)
				local ecafd = fObj.ActivityFinder.Dialog
				self:removeNineSlice(ecafd.Border)
				self:skinObject("editbox", {obj=ecafd.EntryBox, fType=ftype})
				self:skinObject("scrollbar", {obj=ecafd.ScrollBar, fType=ftype})
				self:skinObject("frame", {obj=ecafd.ScrollBox, fType=ftype, kfs=true, fb=true, ofs=4})
				self:removeNineSlice(ecafd.BorderFrame.NineSlice)
				self:skinObject("frame", {obj=ecafd, fType=ftype, kfs=true})
				if self.modBtns then
					self:skinStdButton{obj=ecafd.SelectButton}
					self:skinStdButton{obj=ecafd.CancelButton}
				end
				self:skinObject("editbox", {obj=fObj.Name, fType=ftype})
				self:skinObject("editbox", {obj=fObj.PvpItemLevel.EditBox, fType=ftype})
				self:skinObject("editbox", {obj=fObj.PVPRating.EditBox, fType=ftype})
				self:skinObject("editbox", {obj=fObj.MythicPlusRating.EditBox, fType=ftype})
				self:skinObject("ddbutton", {obj=fObj.GroupDropdown, fType=ftype})
				self:skinObject("ddbutton", {obj=fObj.ActivityDropdown, fType=ftype})
				self:skinObject("ddbutton", {obj=fObj.PlayStyleDropdown, fType=ftype})
				self:skinObject("frame", {obj=fObj.Description, fType=ftype, kfs=true, fb=true, ofs=6})
				self:skinObject("editbox", {obj=fObj.ItemLevel.EditBox, fType=ftype})
				self:skinObject("editbox", {obj=fObj.VoiceChat.EditBox, fType=ftype})
				self:removeMagicBtnTex(fObj.ListGroupButton)
				self:removeMagicBtnTex(fObj.CancelButton)
				if self.modBtns then
					self:skinStdButton{obj=fObj.ListGroupButton, sechk=true}
					self:skinStdButton{obj=fObj.CancelButton}
				end
				if self.modChkBtns then
					self:skinCheckButton{obj=fObj.ItemLevel.CheckButton}
					self:skinCheckButton{obj=fObj.PvpItemLevel.CheckButton}
					self:skinCheckButton{obj=fObj.PVPRating.CheckButton}
					self:skinCheckButton{obj=fObj.MythicPlusRating.CheckButton}
					self:skinCheckButton{obj=fObj.VoiceChat.CheckButton}
					self:skinCheckButton{obj=fObj.CrossFactionGroup.CheckButton}
					self:skinCheckButton{obj=fObj.PrivateGroup.CheckButton}
				end

				self:Unhook(fObj, "OnShow")
			end)

			self:Unhook(this, "OnShow")
		end)

		-- LFGListApplication Dialog
		self:SecureHookScript(_G.LFGListApplicationDialog, "OnShow", function(this)
			self:removeNineSlice(this.Border)
			self:skinObject("scrollbar", {obj=this.Description.ScrollBar, fType=ftype})
			self:skinObject("frame", {obj=this.Description, fType=ftype, kfs=true, fb=true, ofs=6})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true})
			if self.modBtns then
				self:skinStdButton{obj=this.SignUpButton, fType=ftype, schk=true}
				self:skinStdButton{obj=this.CancelButton, fType=ftype}
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
			self:skinObject("frame", {obj=this, fType=ftype})
			if self.modBtns then
				self:skinStdButton{obj=this.AcceptButton}
				self:skinStdButton{obj=this.DeclineButton}
				self:skinStdButton{obj=this.AcknowledgeButton}
			end

			self:Unhook(this, "OnShow")
		end)

	end
elseif _G.C_LFGList.GetPremadeGroupFinderStyle
and _G.C_LFGList.GetPremadeGroupFinderStyle() == _G.Enum.PremadeGroupFinderStyle.Vanilla then
	aObj.blizzFrames[ftype].GroupFinder = function(self)
		if not self.prdb.PVEFrame or self.initialized.LFGList then return end
		self.initialized.LFGList = true

		self:SecureHookScript(_G.LFGParentFrame, "OnShow", function(this)
			_G.LFGParentFramePortraitIcon:SetTexture(nil)
			self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, ignoreSize=true, lod=self.isTT and true})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ofs=-11, x2=-29, y2=70})
			if self.modBtns then
				self:skinCloseButton{obj=self:getChild(this, 1), fType=ftype}
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.LFGListingFrame, "OnShow", function(this)
			self:keepFontStrings(this)
			for _, btn in _G.pairs(this.SoloRoleButtons.RoleButtons) do
				btn.Background:SetTexture(nil)
				if self.modChkBtns then
					self:skinCheckButton{obj=btn.CheckButton, fType=ftype}
				end
				self:skinCheckButton{obj=this.NewPlayerFriendlyButton.CheckButton, fType=ftype}
			end
			this.GroupRoleButtons.RoleIcon.Background:SetTexture(nil)
			-- .RoleDropDown
			if self.modBtns then
				self:skinStdButton{obj=this.BackButton, fType=ftype, sechk=true}
				self:skinStdButton{obj=this.PostButton, fType=ftype, sechk=true}
				self:skinStdButton{obj=this.GroupRoleButtons.RolePollButton, fType=ftype, schk=true}
			end

			self:SecureHookScript(this.CategoryView, "OnShow", function(fObj)
				for _, btn in _G.pairs(fObj.CategoryButtons) do
					btn.Cover:SetTexture(nil)
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.CategoryView)

			self:SecureHookScript(this.ActivityView, "OnShow", function(fObj)
				fObj:DisableDrawLayer("OVERLAY")
				self:skinObject("scrollbar", {obj=fObj.ScrollBar, fType=ftype})
				local function skinElement(...)
					local _, element
					if _G.select("#", ...) == 2 then
						element, _ = ...
					else
						_, element, _ = ...
					end
					if aObj.modBtns then
						aObj:skinExpandButton{obj=element.ExpandOrCollapseButton, fType=ftype, onSB=true}
					end
					if aObj.modChkBtns then
						aObj:skinCheckButton{obj=element.CheckButton, fType=ftype}
					end
				end
				_G.ScrollUtil.AddInitializedFrameCallback(fObj.ScrollBox, skinElement, aObj, true)
				self:skinObject("frame", {obj=fObj.Comment, fType=ftype, kfs=true, fb=true, ofs=6})
				fObj.Comment.EditBox.Instructions:SetTextColor(self.BT:GetRGB())

				self:Unhook(fObj, "OnShow")
			end)

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.LFGBrowseFrame, "OnShow", function(this)
			self:keepFontStrings(this)
			self:skinObject("dropdown", {obj=this.CategoryDropDown, fType=ftype})
			self:skinObject("dropdown", {obj=this.ActivityDropDown, fType=ftype})
			self:skinObject("scrollbar", {obj=this.ScrollBar, fType=ftype})
			if self.modBtns then
				self:skinStdButton{obj=this.SendMessageButton, fType=ftype, sechk=true}
				self:skinStdButton{obj=this.GroupInviteButton, fType=ftype, sechk=true}
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=this.RefreshButton, fType=ftype, clr="gold", ofs=-2, x1=1}
			end
			-- tooltip
			_G.C_Timer.After(0.1, function()
			    self:add2Table(self.ttList, _G.LFGBrowseSearchEntryTooltip)
			end)

			self:Unhook(this, "OnShow")
		end)

	end
end

aObj.blizzLoDFrames[ftype].MacroUI = function(self)
	if not self.prdb.MacroUI or self.initialized.MacroUI then return end
	self.initialized.MacroUI = true

	self:SecureHookScript(_G.MacroFrame, "OnShow", function(this)
		-- Top Tabs
		self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true, upwards=true, offsets={x1=1, y1=-6, x2=-1, y2=-2}, func=function(tab) tab:SetFrameLevel(20) end})
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
					aObj:addButtonBorder{obj=element, fType=ftype, relTo=element.Icon}
				end
			end
			_G.ScrollUtil.AddAcquiredFrameCallback(this.MacroSelector.ScrollBox, skinElement, aObj, true)
		end
		if self.isMnln then
			self:skinObject("scrollbar", {obj=_G.MacroFrameScrollFrame.ScrollBar, fType=ftype})
		else
			self:skinObject("slider", {obj=_G.MacroFrameScrollFrame.ScrollBar, fType=ftype})
		end
		self:skinObject("frame", {obj=_G.MacroFrameTextBackground, fType=ftype, kfs=true, rns=true, fb=true, ofs=0, x2=1})
		_G.MacroFrameSelectedMacroButton:DisableDrawLayer("BACKGROUND")
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, hdr=true, ri=true, rns=true, cb=true, x2=1})
		if self.modBtns then
			self:skinStdButton{obj=_G.MacroEditButton, fType=ftype, schk=true}
			self:skinStdButton{obj=_G.MacroCancelButton, fType=ftype}
			self:skinStdButton{obj=_G.MacroSaveButton, fType=ftype}
			self:skinStdButton{obj=_G.MacroDeleteButton, fType=ftype, schk=true}
			self:skinStdButton{obj=_G.MacroNewButton, fType=ftype, schk=true, sechk=true, x2=-2}
			self:skinStdButton{obj=_G.MacroExitButton, fType=ftype, x1=2}
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.MacroFrameSelectedMacroButton, fType=ftype, relTo=_G.MacroFrameSelectedMacroButtonIcon}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.MacroPopupFrame, "OnShow", function(this)
		self:skinIconSelector(this, ftype)

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].MailFrame = function(self)
	if not self.prdb.MailFrame or self.initialized.MailFrame then return end
	self.initialized.MailFrame = true

	self:SecureHookScript(_G.MailFrame, "OnShow", function(this)
		self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype})
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, cb=true, x2=self.isMnln and 3 or 1})
		local miName, miBtn
		for i = 1, _G.INBOXITEMS_TO_DISPLAY do
			miName = "MailItem" .. i
			miBtn = _G["MailItem" .. i].Button
			self:keepFontStrings(_G[miName])
			miBtn:DisableDrawLayer("BACKGROUND")
			if self.modBtnBs then
				self:addButtonBorder{obj=miBtn, relTo=miBtn.Icon, reParent={_G[miName .. "ButtonCODBackground"], _G[miName .. "ButtonCount"], miBtn.IconOverlay, miBtn.IconOverlay2 and miBtn.IconOverlay2}}
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

		self:SecureHookScript(_G.SendMailFrame, "OnShow", function(fObj)
			self:keepFontStrings(fObj)
			if self.isMnln then
				_G.SendMailScrollFrame:DisableDrawLayer("BACKGROUND")
				self:skinObject("scrollbar", {obj=_G.SendMailScrollFrame.ScrollBar, fType=ftype})
				_G.SendMailBodyEditBox:SetTextColor(self.prdb.BodyText.r, self.prdb.BodyText.g, self.prdb.BodyText.b)
			else
				_G.MailEditBox.ScrollBox.EditBox:SetTextColor(self.BT:GetRGB())
				_G.MailEditBox:DisableDrawLayer("BACKGROUND")
				self:skinObject("scrollbar", {obj=_G.MailEditBoxScrollBar, fType=ftype, x1=1, x2=5})
			end
			for _, btn in _G.pairs(fObj.SendMailAttachments) do
				if not self.modBtnBs then
					self:resizeEmptyTexture(self:getRegion(btn, 1))
				else
					btn:DisableDrawLayer("BACKGROUND")
					self:addButtonBorder{obj=btn, reParent={btn.Count, btn.IconOverlay, btn.IconOverlay2 and btn.IconOverlay2}}
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
				self:SecureHook("SendMailFrame_Update", function()
					for i = 1, _G.ATTACHMENTS_MAX_SEND do
						if not _G.HasSendMailItem(i) then
							self:clrBtnBdr(fObj.SendMailAttachments[i], "grey")
						end
					end
				end)
			end

			self:Unhook(fObj, "OnShow")
		end)
		self:SecureHookScript(_G.OpenMailFrame, "OnShow", function(fObj)
			if self.isMnln then
				_G.OpenMailScrollFrame:DisableDrawLayer("BACKGROUND")
				self:skinObject("scrollbar", {obj=_G.OpenMailScrollFrame.ScrollBar, fType=ftype})
			else
				self:skinObject("slider", {obj=_G.OpenMailScrollFrame.ScrollBar, fType=ftype, rpTex={"background", "overlay"}})
			end
			_G.OpenMailBodyText:SetTextColor("P", self.BT:GetRGB())
			self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, ri=true, cb=true})
			if self.modBtns then
				self:skinStdButton{obj=_G.OpenMailReportSpamButton, schk=true}
				self:skinStdButton{obj=_G.OpenMailCancelButton}
				self:skinStdButton{obj=_G.OpenMailDeleteButton}
				self:skinStdButton{obj=_G.OpenMailReplyButton, schk=true}
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=_G.OpenMailLetterButton, fType=ftype, ibt=true}
				self:addButtonBorder{obj=_G.OpenMailMoneyButton, fType=ftype, ibt=true}
				for _, btn in _G.pairs(fObj.OpenMailAttachments) do
					self:addButtonBorder{obj=btn, fType=ftype, ibt=true}
				end
			end
			-- Invoice Frame Text fields
			local fields = {"ItemLabel", "Purchaser", "SalePrice", "Deposit", "HouseCut", "AmountReceived", "NotYetSent", "MoneyDelay"}
			if not self.isMnln then
				self:add2Table(fields, "BuyMode")
			end
			for _, type in _G.pairs(fields) do
				_G["OpenMailInvoice" .. type]:SetTextColor(self.BT:GetRGB())
			end
			if self.isMnln then
				_G.OpenMailSalePriceMoneyFrame.Count:SetTextColor(self.BT:GetRGB())
				_G.ConsortiumMailFrame.OpeningText:SetTextColor(self.BT:GetRGB())
				_G.ConsortiumMailFrame.CrafterText:SetTextColor(self.BT:GetRGB())
				_G.ConsortiumMailFrame.CommissionReceived:SetTextColor(self.BT:GetRGB())
				_G.ConsortiumMailFrame.CrafterNote:SetTextColor(self.BT:GetRGB())
				_G.ConsortiumMailFrame.ConsortiumNote:SetTextColor(self.BT:GetRGB())
				_G.ConsortiumMailFrame.CommissionPaidDisplay.CommissionPaidText:SetTextColor(self.BT:GetRGB())
			end

			self:Unhook(fObj, "OnShow")
		end)

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].MainMenuBar = function(self)
	if self.initialized.MainMenuBar then return end
	self.initialized.MainMenuBar = true

	-- this is done here as other AddOns may require it to be skinned
	if self.modBtnBs then
		self:addButtonBorder{obj=_G.MainMenuBarVehicleLeaveButton, fType=ftype, schk=true}
	end

	if self.isClsc then
		self:SecureHookScript(_G.TalentMicroButtonAlert, "OnShow", function(this)
			self:skinObject("glowbox", {obj=this, fType=ftype})

			self:Unhook(this, "OnShow")
		end)
	end

	if _G.C_AddOns.IsAddOnLoaded("Dominos")
	or _G.C_AddOns.IsAddOnLoaded("Bartender4")
	then
		self.blizzFrames[ftype].MainMenuBar = nil
		return
	end

	if self.prdb.MainMenuBar.skin then
		if self.isMnln then
			if not aObj.isMnlnPTRX then
				self:SecureHookScript(_G.MainMenuBar, "OnShow", function(this)
					this.BorderArt:SetTexture(nil)
					this.EndCaps:DisableDrawLayer("OVERLAY")

					self:Unhook(this, "OnShow")
				end)
				self:checkShown(_G.MainMenuBar)
			else
				self:SecureHookScript(_G.MainActionBar, "OnShow", function(this)
					this.BorderArt:SetTexture(nil)
					this.EndCaps:DisableDrawLayer("OVERLAY")

					self:Unhook(this, "OnShow")
				end)
				self:checkShown(_G.MainActionBar)
			end

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
				local function skinMultiBarBtns(type)
					local bName
					for i = 1, _G.NUM_MULTIBAR_BUTTONS do
						bName = "MultiBar" .. type .. "Button" .. i
						if _G[bName] then
							aObj:skinActionBtn(_G[bName], ftype)
						end
					end
				end
				for i = 1, _G.NUM_ACTIONBAR_BUTTONS do
					self:skinActionBtn(_G["ActionButton" .. i], ftype)
				end
				skinMultiBarBtns("BottomLeft")
				skinMultiBarBtns("BottomRight")
				skinMultiBarBtns("Left")
				skinMultiBarBtns("Right")
				skinMultiBarBtns("5")
				skinMultiBarBtns("6")
				skinMultiBarBtns("7")
				skinMultiBarBtns("8")
			end
		else
			local skinABBtn, skinMultiBarBtns = _G.nop, _G.nop
			if self.modBtnBs then
				function skinABBtn(btn)
					btn.Border:SetAlpha(0) -- texture changed in blizzard code
					btn.FlyoutBorder:SetTexture(nil)
					btn.FlyoutBorderShadow:SetTexture(nil)
					if aObj:canSkinActionBtns() then
						_G[btn:GetName() .. "NormalTexture"]:SetTexture(nil)
						aObj:addButtonBorder{obj=btn, fType=ftype, sabt=true, rpA=true, ofs=3}
					end
				end
				function skinMultiBarBtns(type)
					local bName
					for i = 1, _G.NUM_MULTIBAR_BUTTONS do
						bName = "MultiBar" .. type .. "Button" .. i
						if not _G[bName].noGrid then
							_G[bName .. "FloatingBG"]:SetAlpha(0)
						end
						skinABBtn(_G[bName])
					end
				end
			end
			self:SecureHookScript(_G.MainMenuBar, "OnShow", function(this)
				_G.ExhaustionTick:GetNormalTexture():SetTexture(nil)
				_G.ExhaustionTick:GetHighlightTexture():SetTexture(nil)
				_G.MainMenuExpBar:DisableDrawLayer("OVERLAY")
				_G.MainMenuExpBar:SetSize(self.isClsc and 1014 or 1012, 14)
				self:moveObject{obj=_G.MainMenuExpBar, x=self.isClsc and 2 or 1, y=2}
				self:moveObject{obj=_G.MainMenuBarExpText, y=-2}
				self:skinObject("statusbar", {obj=_G.MainMenuExpBar, fType=ftype, bg=self:getRegion(_G.MainMenuExpBar, 6), other={_G.ExhaustionLevelFillBar}})
				_G.MainMenuBarMaxLevelBar:DisableDrawLayer("BACKGROUND")
				_G.MainMenuBarArtFrame:DisableDrawLayer("BACKGROUND")
				_G.MainMenuBarLeftEndCap:SetTexture(nil)
				_G.MainMenuBarRightEndCap:SetTexture(nil)
				local rwbSB = _G.ReputationWatchBar.StatusBar
				self:removeRegions(rwbSB, {1, 2, 3, 4, 5, 6, 7, 8, 9})
				rwbSB:SetSize(1011, 8)
				self:moveObject{obj=rwbSB, x=1, y=2}
				self:skinObject("statusbar", {obj=rwbSB, fType=ftype, bg=rwbSB.Background, other={rwbSB.Underlay, rwbSB.Overlay}})
				if self.modBtnBs then
					for i = 1, _G.NUM_ACTIONBAR_BUTTONS do
						skinABBtn(_G["ActionButton" .. i])
					end
					self:addButtonBorder{obj=_G.ActionBarUpButton, fType=ftype, ofs=-4, clr="gold"}
					self:addButtonBorder{obj=_G.ActionBarDownButton, fType=ftype, ofs=-4, clr="gold"}
					skinMultiBarBtns("BottomLeft")
					skinMultiBarBtns("BottomRight")
				end

				self:Unhook(this, "OnShow")
			end)
			self:checkShown(_G.MainMenuBar)

			if self.modBtnBs then
				skinMultiBarBtns("Right")
				skinMultiBarBtns("Left")
				for _, bName in _G.pairs(_G.MICRO_BUTTONS) do
					self:addButtonBorder{obj=_G[bName], fType=ftype, es=24, ofs=2, y1=-18, reParent={_G[bName].QuickKeybindHighlightTexture}}
				end
				local function abb2Bag(bag)
					aObj:addButtonBorder{obj=bag, fType=ftype, ibt=true, ofs=3, clr=bag.icon:GetVertexColor()}
				end
				abb2Bag(_G.MainMenuBarBackpackButton)
				for i = 0, 3 do
					abb2Bag(_G["CharacterBag" .. i .. "Slot"])
				end
				self:addButtonBorder{obj=_G.KeyRingButton, fType=ftype, ofs=2}
			end
		end
	end

	if not aObj.isClscERA then
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
		if aObj.isMnln then
			for _, frame in _G.pairs{_G.StanceBar, _G.PetActionBar, _G.PossessActionBar} do
				self:SecureHookScript(frame, "OnShow", function(this)
					for _, btn in _G.pairs(this.actionButtons) do
						self:skinActionBtn(btn, ftype)
					end

					self:Unhook(this, "OnShow")
				end)
				self:checkShown(frame)
			end
		else
			self:SecureHookScript(_G.StanceBarFrame, "OnShow", function(this)
				self:keepFontStrings(this)
				if self.modBtnBs then
					for _, btn in _G.pairs(this.StanceButtons) do
						self:addButtonBorder{obj=btn, fType=ftype, abt=true, sft=true, ofs=3, x1=-4}
					end
				end

				self:Unhook(this, "OnShow")
			end)
			self:checkShown(_G.StanceBarFrame)
			-- TODO: change button references when PetActionButtonTemplate & ActionButtonTemplate are fixed
			self:SecureHookScript(_G.PetActionBarFrame, "OnShow", function(this)
				self:keepFontStrings(this)
				if self.modBtnBs then
					local bName
					for i = 1, _G.NUM_PET_ACTION_SLOTS do
						bName = "PetActionButton" .. i
						_G[bName .. "NormalTexture2"]:SetTexture(nil)
						self:addButtonBorder{obj=_G[bName], fType=ftype, abt=true, sft=true, reParent={_G[bName .. "AutoCastable"], _G[bName .. "Shine"]}, ofs=3, x2=2}
					end
				end

				self:Unhook(this, "OnShow")
			end)
			self:checkShown(_G.PetActionBarFrame)
			if not self.isClscERA then
				self:SecureHookScript(_G.PossessBarFrame, "OnShow", function(this)
					self:keepFontStrings(this)
					if self.modBtnBs then
						for i = 1, _G.NUM_POSSESS_SLOTS do
							self:addButtonBorder{obj=_G["PossessButton" .. i], fType=ftype, abt=true, sft=true, ofs=3}
						end
					end

					self:Unhook(this, "OnShow")
				end)
				self:checkShown(_G.PossessBarFrame)
			end
		end
	end

end

aObj.blizzFrames[ftype].Menu = function(self) -- Dropdown Menus
	if not self.prdb.Menu or self.initialized.Menu then return end
	self.initialized.Menu = true

	local ddMenus, mixin = {}
	for i = 1, 10 do
		mixin = "MenuStyle" .. i .. "Mixin"
		if _G[mixin] then
			self:RawHook(_G[mixin], "Generate", function(menu)
				if not _G.tContains(ddMenus, menu) then
					aObj:skinObject("scrollbar", {obj=menu.ScrollBar, fType=ftype})
					aObj:skinObject("frame", {obj=menu, fType=ftype, ofs=3})
					aObj:add2Table(ddMenus, menu)
				end
			end, true)
		end
	end

end

aObj.blizzFrames[ftype].MenuFrames = function(self)
	if not self.prdb.MenuFrames or self.initialized.MenuFrames then return end
	self.initialized.MenuFrames = true

	self:SecureHookScript(_G.GameMenuFrame, "OnShow", function(this)
		if self.isMnln then
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
		if self.isMnln then
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

	if _G.C_AddOns.IsAddOnLoaded("SexyMap")
	or _G.C_AddOns.IsAddOnLoaded("BasicMinimap")
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
	if not self.isMnln then
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
	_G.Minimap:SetMaskTexture(self.isMnln and self.tFDIDs.w8x8 or [[Interface\Buttons\WHITE8X8]])
	-- use a backdrop with no Texture otherwise the map tiles are obscured
	self:skinObject("frame", {obj=_G.Minimap, fType=ftype, bd=8, ofs=5})
	if self.prdb.Minimap.gloss then
		_G.RaiseFrameLevel(_G.Minimap.sf)
	else
		_G.LowerFrameLevel(_G.Minimap.sf)
	end

	if self.isMnln then
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
	if self.isMnln then
		ignBtn["ExpansionLandingPageMinimapButton"] = true
		ignBtn[_G.Minimap.ZoomIn]                   = true
		ignBtn[_G.Minimap.ZoomOut]                  = true
	else
		ignBtn["MinimapZoomIn"]                     = true
		ignBtn["MinimapZoomOut"]                    = true
		ignBtn["GameTimeFrame"]                     = true
		ignBtn["MiniMapTracking"]                   = true
		ignBtn["MiniMapWorldMapButton"]             = true
		ignBtn["LFGMinimapFrame"]                   = true -- ClassicERA
		ignBtn["MiniMapLFGFrame"]                   = true -- Classic
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

	_G.MiniMapMailIcon:SetTexture(self.tFDIDs.tMB)
	_G.MiniMapMailIcon:ClearAllPoints()
	if self.isMnln then
		_G.MiniMapMailIcon:SetPoint("CENTER", _G.MinimapCluster.MailFrame)
		_G.ExpansionLandingPageMinimapButton.AlertBG:SetTexture(nil)
		local anchor = _G.AnchorUtil.CreateAnchor("TOPLEFT", "MinimapBackdrop", "TOPLEFT", -10, -200)
		anchor:SetPoint(_G.ExpansionLandingPageMinimapButton, true)
		self:SecureHook(_G.ExpansionLandingPageMinimapButton, "UpdateIconForGarrison", function(this)
			anchor:SetPoint(this, true)
		end)
		self:SecureHook(_G.ExpansionLandingPageMinimapButton, "SetLandingPageIconOffset", function(this, _)
			anchor:SetPoint(this, true)
		end)
	else
		_G.MiniMapMailIcon:SetPoint("CENTER", _G.MiniMapMailFrame)
		_G.MiniMapMailFrame:SetSize(26, 26)
		self:moveObject{obj=_G.MiniMapMailFrame, y=-4}
		_G.MiniMapBattlefieldFrame:SetSize(28, 28)
		self:moveObject{obj=_G.MiniMapTracking, x=-8}
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
			self:addButtonBorder{obj=_G.MiniMapTracking, fType=ftype, bd=10, ofs=1, x1=3, y1=-3}
			self:moveObject{obj=_G.MiniMapTracking, x=-2}
			if _G.LFGMinimapFrame then
				self:skinObject("frame", {obj=_G.LFGMinimapFrame, fType=ftype, kfs=true, ofs=-1})
				self:moveObject{obj=_G.LFGMinimapFrame, x=-30, y=6}
			end
		elseif self.isClsc then
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
			-- Calendar button
			makeBtnSquare(_G.GameTimeFrame, 0.1, 0.31, 0.16, 0.6)
			_G.GameTimeFrame:SetNormalFontObject(_G.GameFontWhite) -- allow for font OUTLINE to be seen
			_G.MiniMapTrackingBackground:SetTexture(nil)
			_G.MiniMapTrackingButtonBorder:SetTexture(nil)
			if not minBtn then
				_G.MiniMapTracking:SetScale(0.9)
				self:skinObject("frame", {obj=_G.MiniMapTrackingButton, fType=ftype, bd=10, ofs=0})
				-- TODO: Background alpha is 0
			end
			self:skinObject("frame", {obj=_G.MiniMapLFGFrame, fType=ftype, kfs=true, ofs=0})
			if not self.isClsc then
				_G.MiniMapWorldBorder:SetTexture(nil)
			end
			_G.MiniMapWorldMapButton:DisableDrawLayer("OVERLAY") -- border texture
			_G.MiniMapWorldMapButton:ClearAllPoints()
			_G.MiniMapWorldMapButton:SetPoint("LEFT", _G.MinimapZoneTextButton, "RIGHT", -4, 0)
			self:skinOtherButton{obj=_G.MiniMapWorldMapButton, font=self.fontP, text="M", noSkin=minBtn}
		end
	end
	_G.TimeManagerClockButton:DisableDrawLayer("BORDER")
	_G.TimeManagerClockButton:SetSize(36, 14)
	if not _G.C_AddOns.IsAddOnLoaded("SexyMap") then
		self:moveObject{obj=_G.TimeManagerClockTicker, x=-1, y=1}
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
			if _G.C_AddOns.IsAddOnLoaded(addon) then
				skinMMBtn("Loaded Addons btns", obj)
			end
		end
	end)

	-- skin any moved Minimap buttons if required
	if _G.C_AddOns.IsAddOnLoaded("MinimapButtonFrame") then
		mmKids(_G.MinimapButtonFrame)
	end
	-- show the Bongos minimap icon if required
	if _G.C_AddOns.IsAddOnLoaded("Bongos") then
		_G.Bongos3MinimapButton.icon:SetDrawLayer("ARTWORK")
	end

	local function skinDBI(_, dbiBtn, name)
		dbiBtn:SetSize(24, 24)
		-- DON'T move icons with multiple points
		if dbiBtn.icon:GetNumPoints() == 1 then
			aObj:moveObject{obj=dbiBtn.icon, x=-3, y=3}
		end
		-- FIXME: this is to move button off the minimap, required until LibDBIcon is fixed
		if aObj.isMnln then
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
			self:changeLock(_G.MovePadLock)
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
		if self.isMnln then
			self:removeNineSlice(this.CloseDialog.Border)
		end
		self:skinObject("frame", {obj=this.CloseDialog, fType=ftype})
		if self.modBtns then
			self:skinStdButton{obj=this.CloseDialog.ConfirmButton}
			self:skinStdButton{obj=this.CloseDialog.ResumeButton}
		end

		self:Unhook(this, "OnShow")
	end)

end

if not aObj.isClscERA then
	aObj.blizzFrames[ftype].OverrideActionBar = function(self) -- a.k.a. Vehicle UI
		if not self.prdb.OverrideActionBar or self.initialized.OverrideActionBar then return end
		self.initialized.OverrideActionBar = true

		if _G.C_AddOns.IsAddOnLoaded("Dominos")
		or _G.C_AddOns.IsAddOnLoaded("Bartender4")
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
				self:addButtonBorder{obj=this.PitchUpButton, clr="sepia"}
				self:addButtonBorder{obj=this.PitchDownButton, clr="sepia"}
				self:addButtonBorder{obj=this.LeaveButton, clr="sepia"}
				if self:canSkinActionBtns() then
					local MAX_ALT_SPELLBUTTONS = 6
					for i = 1, MAX_ALT_SPELLBUTTONS do
						self:addButtonBorder{obj=this["SpellButton" .. i], sabt=true}
					end
				end
			end

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.OverrideActionBar)

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
end

if _G.PTR_IssueReporter then
	aObj.blizzFrames[ftype].PTRFeedback = function(self)
		if not self.prdb.PTRFeedback or self.initialized.PTRFeedback then return end
		self.initialized.PTRFeedback = true

		local function skinFrame(frame, ofs, border)
			if frame.Border then
				aObj:removeBackdrop(frame.Border)
			end
			if frame.Background then
				frame.Background:SetTexture(nil)
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
				self:skinCloseButton{obj=self:getChild(_G.PTR_IssueReporter.StandaloneSurvey.SurveyFrame, 2), fType=ftype, noSkin=true}
				self:skinStdButton{obj=self:getChild(_G.PTR_IssueReporter.StandaloneSurvey.SurveyFrame, 3), fType=ftype, ofs=-1, clr="blue"}
			end

			self:Unhook(_G.PTR_IssueReporter, "GetStandaloneSurveyFrame")
		end)

		self:SecureHook(_G.PTR_IssueReporter, "BuildSurveyFrameFromSurveyData", function(surveyFrame, _, _)
			skinFrame(surveyFrame)
			for _, frame in _G.ipairs(surveyFrame.FrameComponents) do
				if not aObj.isMnln then
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
						self:skinCheckButton{obj=checkBox, fType=ftype, clr="blue"}
					end
				-- elseif frame.FrameType == "StandaloneQuestion" then
				-- elseif frame.FrameType == "ModelViewer" then
				-- elseif frame.FrameType == "IconViewer" then
				end
			end
		end)

	end
end

if not aObj.isClscERA then
	aObj.blizzFrames[ftype].PVEFrame = function(self)
		if not self.prdb.PVEFrame or self.initialized.PVEFrame then return end
		self.initialized.PVEFrame = true

		local groupFrames
		if _G.PVEFrame.ScenariosEnabled and _G.PVEFrame:ScenariosEnabled() then
			groupFrames = { "LFDParentFrame", "ScenarioFinderFrame", "RaidFinderFrame", "LFGListPVEStub" }
		else
			groupFrames = { "LFDParentFrame", "RaidFinderFrame", "LFGListPVEStub" }
		end
		if self.isClsc then
			groupFrames[4] = "ScenarioFinderFrame"
		end

		self:SecureHookScript(_G.PVEFrame, "OnShow", function(this)
			self:keepFontStrings(this.shadows)
			if not self.isClscERA then
				self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype})
			end
			-- GroupFinder Frame
			for i = 1, #groupFrames do
				_G.GroupFinderFrame["groupButton" .. i].bg:SetTexture(nil)
				_G.GroupFinderFrame["groupButton" .. i].ring:SetTexture(nil)
				self:changeTex(_G.GroupFinderFrame["groupButton" .. i]:GetHighlightTexture())
				-- make icon square
				self:makeIconSquare(_G.GroupFinderFrame["groupButton" .. i], "icon")
			end
			-- hook this to change selected texture
			self:SecureHook("GroupFinderFrame_SelectGroupButton", function(index)
				for i = 1, #groupFrames do
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
					for i = 1, #groupFrames do
						if _G.GroupFinderFrame["groupButton" .. i].sbb then
							self:clrBtnBdr(_G.GroupFinderFrame["groupButton" .. i], "gold")
						end
					end
				end)
			end

			self:Unhook(this, "OnShow")
		end)

	end
end

aObj.blizzFrames[ftype].QueueStatusFrame = function(self)
	if not self.prdb.QueueStatusFrame or self.initialized.QueueStatusFrame then return end
	self.initialized.QueueStatusFrame = true

	self:SecureHookScript(_G.QueueStatusFrame, "OnShow", function(this)
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, rns=true})
		-- change the colour of the Entry Separator texture
		local function clrEntry(frame)
			local r, g, b, _ = self.bbClr:GetRGBA()
			for sEntry in frame.statusEntriesPool:EnumerateActive() do
				sEntry.EntrySeparator:SetColorTexture(r, g, b, 0.75)
			end
		end
		self:SecureHook(_G.QueueStatusFrame, "Update", function(fObj)
			clrEntry(fObj)
		end)
		clrEntry(this)

		-- handle SexyMap's use of AnimationGroups to show and hide frames
		if _G.C_AddOns.IsAddOnLoaded("SexyMap") then
			local rtEvt
			local function checkForAnimGrp()
				if _G.QueueStatusMinimapButton
				and _G.QueueStatusMinimapButton.sexyMapFadeOut
				then
					rtEvt:Cancel()
					rtEvt = nil
					aObj:SecureHookScript(_G.QueueStatusMinimapButton.sexyMapFadeOut, "OnFinished", function(_)
						_G.QueueStatusFrame.sf:Hide()
					end)
				end
			end
			rtEvt = _G.C_Timer.NewTicker(0.2, function() checkForAnimGrp() end)
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].ReportFrame = function(self)
	if not self.prdb.ReportFrame or self.initialized.ReportFrame then return end
	self.initialized.ReportFrame = true

	self:SecureHookScript(_G.ReportFrame, "OnShow", function(this)
		self:removeNineSlice(this.Border)
		self:skinObject("ddbutton", {obj=this.ReportingMajorCategoryDropdown, fType=ftype})
		self:skinObject("frame", {obj=this.Comment, fType=ftype, kfs=true, fb=true, ofs=6})
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, cb=true, ofs=-3})
		if self.modBtns then
			self:skinStdButton{obj=this.ReportButton, fType=ftype, sechk=true}
			self:SecureHook(this, "MajorTypeSelected", function(fObj, _, _)
				for catBtn in fObj.MinorCategoryButtonPool:EnumerateActive() do
					self:skinStdButton{obj=catBtn, fType=ftype, clr="black"}
				end
			end)
		end

		self:Unhook(this, "OnShow")
	end)

end

if not aObj.isClscERA then
	aObj.blizzFrames[ftype].ScenarioFinderFrame = function(self)
		if not self.prdb.PVEFrame or self.initialized.ScenarioFinderFrame then return end
		self.initialized.ScenarioFinderFrame = true

		self:SecureHookScript(_G.ScenarioFinderFrame, "OnShow", function(this)
			self:removeInset(this.Inset)
			this.Queue.Bg:SetAlpha(0)
			self:skinObject("ddbutton", {obj=this.Queue.Dropdown, fType=ftype})
			self:skinObject("scrollbar", {obj=this.Queue.Random.ScrollFrame.ScrollBar, fType=ftype})
			-- .Queue.PartyBackfill
			-- .Queue.CooldownFrame
			if self.isMnln then
				self:skinObject("slider", {obj=this.Queue.Specific.ScrollFrame.ScrollBar, fType=ftype, rpTex={"background"}})
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
			else
				self:skinObject("scrollbar", {obj=this.Queue.Specific.ScrollBar, fType=ftype})
				local function skinElement(...)
					local _, element
					if _G.select("#", ...) == 2 then
						element, _ = ...
					else
						_, element, _ = ...
					end
					if aObj.modBtns then
						aObj:skinExpandButton{obj=element.expandOrCollapseButton, sap=true}
					end
					if aObj.modChkBtns then
						aObj:skinCheckButton{obj=element.enableButton}
					end
				end
				_G.ScrollUtil.AddInitializedFrameCallback(this.Queue.Specific.ScrollFrame, skinElement, aObj, true)
				this.Queue.Random.ScrollFrame.Child.MoneyReward.NameFrame:SetTexture(nil)
				self:removeMagicBtnTex(_G.ScenarioQueueFrameFindGroupButton)
				if self.modBtnBs then
					self:addButtonBorder{obj=this.Queue.Random.ScrollFrame.Child.MoneyReward, fType=ftype, libt=true}
				end
			end
			if self.modBtns then
				self:skinStdButton{obj=_G.ScenarioQueueFrameFindGroupButton, fType=ftype}
			end

			self:Unhook(this, "OnShow")
		end)

	end
end

aObj.blizzFrames[ftype].Settings = function(self)
	if not self.prdb.Settings or self.initialized.Settings then return end
	self.initialized.Settings = true

	self:SecureHookScript(_G.SettingsPanel, "OnShow", function(this)
		this.Bg:DisableDrawLayer("BACKGROUND")
		this.NineSlice.Text:SetDrawLayer("ARTWORK")
		-- Top tabs
		self:skinObject("tabs", {obj=this, tabs=this.tabsGroup.buttons, fType=ftype, ignoreSize=true, lod=self.isTT and true, upwards=true, regions={4}, offsets={x1=6, y1=-10, x2=-6, y2=-6}, track=false})
		if self.isTT then
			local function setTabState(_, _, idx)
				for key, tab in _G.pairs(this.tabsGroup.buttons) do
					aObj:setInactiveTab(tab.sf)
					if key == idx then
						aObj:setActiveTab(tab.sf)
					end
				end
			end
			this.tabsGroup:RegisterCallback(_G.ButtonGroupBaseMixin.Event.Selected, setTabState, aObj)
		end
		self:skinObject("editbox", {obj=this.SearchBox, fType=ftype, si=true})
		self:skinObject("scrollbar", {obj=this.CategoryList.ScrollBar, fType=ftype})
		local function skinCategory(...)
			local _, element, new
			if _G.select("#", ...) == 2 then
				element, _ = ...
			elseif _G.select("#", ...) == 3 then
				element, _, new = ...
			else
				_, element, _, new = ...
			end
			if new ~= false then
				if element.Background then
					element.Background:SetAlpha(0) -- texture changed in code
				end
				-- Button
				if element.Toggle then
					if aObj.modBtnBs then
						aObj:skinExpandButton{obj=element.Toggle, fType=ftype, noddl=true, noHook=true, plus=true, ofs=-2}
						aObj:SecureHook(element, "SetExpanded", function(bObj, expanded)
							if expanded then
								bObj.Toggle:SetText(aObj.modUIBtns.minus)
							else
								bObj.Toggle:SetText(aObj.modUIBtns.plus)
							end
						end)
					end
				end
			end
		end
		_G.ScrollUtil.AddAcquiredFrameCallback(this.CategoryList.ScrollBox, skinCategory, aObj, true)
		self:skinObject("frame", {obj=this.CategoryList, fType=ftype, fb=true, ofs=4, y1=12, y2=-7})
		self:getRegion(this.Container.SettingsList.Header, 2):SetTexture(nil)
		self:skinObject("scrollbar", {obj=this.Container.SettingsList.ScrollBar, fType=ftype})
		local function skinCommonElements(element)
			if aObj.modBtns then
				if element.Button then
					aObj:skinStdButton{obj=element.Button, fType=ftype, sechk=true}
				elseif element.NewButton then -- RaidProfiles
					aObj:skinStdButton{obj=element.NewButton, fType=ftype, sechk=true}
					aObj:skinStdButton{obj=element.DeleteButton, fType=ftype, sechk=true}
				elseif element.CustomButton then
					aObj:skinStdButton{obj=element.CustomButton, fType=ftype}
				elseif element.OpenAccessButton then
					aObj:skinStdButton{obj=element.OpenAccessButton, fType=ftype}
				elseif element.PushToTalkKeybindButton then
					aObj:skinStdButton{obj=element.PushToTalkKeybindButton, fType=ftype}
				elseif element.Buttons then
					for _, btn in _G.ipairs(element.Buttons) do
						aObj:skinStdButton{obj=btn, fType=ftype}
					end
				elseif element.ToggleTest then
					aObj:addButtonBorder{obj=element.ToggleTest, fType=ftype, ofs=1}
				end
				if element.Control -- N.B. Retail
				and element.Control.Dropdown
				then
					aObj:skinStdButton{obj=element.Control.Dropdown, fType=ftype, ignoreHLTex=true, sechk=true, y1=1, y2=-1}
					-- N.B. Popouts are Dropdown Menu list frames
				elseif element.DropDown -- N.B. Classic & ClassicERA
				and element.DropDown.Button
				then
					aObj:skinStdButton{obj=element.DropDown.Button, fType=ftype, ignoreHLTex=true, sechk=true, ofs=-6}
					aObj:removeNineSlice(element.DropDown.Button.Popout.Border)
					aObj:skinObject("frame", {obj=element.DropDown.Button.Popout, fType=ftype, kfs=true, ofs=0, y2=20})
				end
			end
			if aObj.modBtns then
				if element.Control -- N.B. Retail
				and element.Control.DecrementButton
				then
					aObj:skinStdButton{obj=element.Control.IncrementButton, fType=ftype, sechk=true, ofs=1}
					aObj:skinStdButton{obj=element.Control.DecrementButton, fType=ftype, sechk=true, ofs=1}
				elseif element.DropDown
				and element.DropDown.DecrementButton
				then
					aObj:skinStdButton{obj=element.DropDown.IncrementButton, fType=ftype, sechk=true, ofs=1}
					aObj:skinStdButton{obj=element.DropDown.DecrementButton, fType=ftype, sechk=true, ofs=1}
				end
			end
			if aObj.modChkBtns
			and element.Checkbox
			or element.CheckBox
			then
				aObj:skinCheckButton{obj=element.Checkbox or element.CheckBox, fType=ftype}
			end
			if element.SliderWithSteppers then
				aObj:skinObject("slider", {obj=element.SliderWithSteppers.Slider, fType=ftype, y1=-12, y2=12})
			end
		end
		local function skinSetting(...)
			local _, element, elementData, new
			if _G.select("#", ...) == 2 then
				element, elementData = ...
			elseif _G.select("#", ...) == 3 then
				element, elementData, new = ...
			else
				_, element, elementData, new = ...
			end
			if new ~= false then
				local name = elementData.data.name
				if name == "Push to Talk Key" then
					_G.C_Timer.After(0.1, function()
						skinCommonElements(element)
					end)
				elseif element.EvaluateVisibility then -- handle ExpandableSection(s)
					if name == "Graphics Quality" then
						_G.C_Timer.After(0.1, function()
							aObj:skinObject("tabs", {obj=element, tabs=element.tabsGroup.buttons, fType=ftype, ignoreSize=true, lod=aObj.isTT and true, upwards=true, regions={4}, offsets={x1=6, y1=-10, x2=-6, y2=-6}, track=false})
							if aObj.isTT then
								local function setTabState(_, _, idx)
									for key, tab in _G.pairs(element.tabsGroup.buttons) do
										aObj:setInactiveTab(tab.sf)
										if key == idx then
											aObj:setActiveTab(tab.sf)
										end
									end
								end
								element.tabsGroup:RegisterCallback(_G.ButtonGroupBaseMixin.Event.Selected, setTabState, aObj)
							end
						end)
						aObj:skinObject("frame", {obj=element, fType=ftype, kfs=true, fb=true, y1=-27, x2=-20})
						for _, control in _G.pairs(element.BaseQualityControls.Controls) do
							skinCommonElements(control)
						end
						for _, control in _G.pairs(element.RaidQualityControls.Controls) do
							skinCommonElements(control)
						end
					else
						-- keybindings
						aObj:removeRegions(element.Button, {1, 2, 3})
						aObj:changeHdrExpandTex(element.Button.Right)
						aObj:SecureHook(element, "EvaluateVisibility", function(eObj, _)
							for _, control in _G.ipairs(eObj.Controls) do
								skinCommonElements(control)
							end
						end)
					end
				else
					skinCommonElements(element)
				end
				if element.VUMeter then
					aObj:skinObject("frame", {obj=element.VUMeter, fType=ftype, kfs=true, rns=true, fb=true})
				end
			end
		end
		_G.ScrollUtil.AddAcquiredFrameCallback(this.Container.SettingsList.ScrollBox, skinSetting, aObj, true)
		self:skinObject("frame", {obj=this.Container, fType=ftype, fb=true, x1=-14, y1=12, y2=-8})
		-- .InputBlocker
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, rns=true, ofs=1})
		if self.modBtns then
			self:skinCloseButton{obj=this.ClosePanelButton, fType=ftype}
			self:skinStdButton{obj=this.Container.SettingsList.Header.DefaultsButton, fType=ftype}
			self:skinStdButton{obj=this.CloseButton, fType=ftype}
			self:skinStdButton{obj=this.ApplyButton, fType=ftype, sechk=true}
		end

		if self.isMnln then
			self:SecureHookScript(this.QuestTextPreview, "OnShow", function(fObj)
				self:skinObject("frame", {obj=fObj, fType=ftype, ofs=-5})
				-- N.B. make sure skin frame is behind frame textures
				_G.RaiseFrameLevel(fObj)
				_G.LowerFrameLevel(fObj.sf)

				self:Unhook(fObj, "OnShow")
			end)
			self:SecureHookScript(this.AccessibilityFontPreview, "OnShow", function(fObj)
				self:skinObject("frame", {obj=fObj, fType=ftype, ofs=-5})

				self:Unhook(fObj, "OnShow")
			end)
		end

		self:Unhook(this, "OnShow")
	end)

	-- tooltip
	_G.C_Timer.After(0.5, function()
		self:add2Table(self.ttList, _G.SettingsTooltip)
	end)

	-- hook this to skin AddOns Settings panels
	self:SecureHook(_G.SettingsPanel, "DisplayCategory", function(this, category)
		-- aObj:Debug("SP DisplayCategory#1: [%s, %s]", category, category.name)
		local layout = this:GetLayout(category)
		if layout:GetLayoutType() == _G.SettingsLayoutMixin.LayoutType.Canvas then
			local frame = layout:GetFrame()
			-- aObj:Debug("SP DisplayCategory#2: [%s, %s]", frame.name, frame.parent)
			-- let AddOn skins know when the panel is displayed
			self.callbacks:Fire("SettingsPanel_DisplayCategory", frame, category)
			--[===[@non-debug@
			self.callbacks:Fire("IOFPanel_Before_Skinning", frame, category)
			self.callbacks:Fire("IOFPanel_After_Skinning", frame, category)
			--@end-non-debug@]===]
		end
	end)

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
		self:skinObject("scrollbar", {obj=this.ScrollFrame.ScrollBar, fType=ftype})
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

aObj.blizzFrames[ftype].StackSplit = function(self)
	if not self.prdb.StackSplit or self.initialized.StackSplit then return end
	self.initialized.StackSplit = true

	self:SecureHookScript(_G.StackSplitFrame, "OnShow", function(this)
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ofs=-10, x2=-8})
		if self.modBtns then
			if self.isMnln then
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
		local nTex
		self:SecureHook("StaticPopup_Show", function(_)
			for i = 1, 4 do
				nTex = _G["StaticPopup" .. i .. "CloseButton"]:GetNormalTexture()
				if self:hasTextInTexture(nTex, "HideButton") then
					_G["StaticPopup" .. i .. "CloseButton"]:SetText(self.modUIBtns.minus)
				elseif self:hasTextInTexture(nTex, "MinimizeButton") then
					_G["StaticPopup" .. i .. "CloseButton"]:SetText(self.modUIBtns.mult)
				end
			end
		end)
	end

	-- Frame layout found in GameDialog.xml
	for i = 1, 4 do
		self:SecureHookScript(_G["StaticPopup" .. i], "OnShow", function(this)
			-- .ProgressBarBorder
			-- .ProgressBarFill
			self:keepFontStrings(this.BG)
			-- .CoverFrame
			this.Separator:SetTexture(nil)
			self:skinObject("editbox", {obj=this.EditBox, fType=ftype, mi=true, mix=12, regions={}, ofs=0})
			-- .Dropdown
			-- .MoneyFrame
			self:skinObject("moneyframe", {obj=this.MoneyInputFrame, moveIcon=true})
			this.ItemFrame.NameFrame:SetTexture(nil)
			-- if this.insertedFrame then
			-- 	this.insertedFrame.ItemFrame.NameFrame:SetTexture(nil)
			-- 	if self.modBtnBs then
			-- 		self:addButtonBorder{obj=this.insertedFrame.ItemFrame.Item, fType=ftype, libt=true}
			-- 		if this.insertedFrame.AlsoItemsFrame.pool then
			-- 			for btn in this.insertedFrame.AlsoItemsFrame.pool:EnumerateActive() do
			-- 				self:addButtonBorder{obj=btn, fType=ftype, clr="white"}
			-- 			end
			-- 		end
			-- 	end
			-- end
			-- N.B. Close Button handled above, offset is to allow DarkOverlay to overlay skin frame border as well
			self:skinObject("frame", {obj=this, fType=ftype, ofs=-4})
			if self.modBtns then
				for _, btn in _G.pairs(this.ButtonContainer.Buttons) do
					self:skinStdButton{obj=btn, fType=ftype, schk=true, sechk=true, y=2}
				end
				self:skinStdButton{obj=this.ExtraButton, fType=ftype, schk=true, y1=2}
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=this.ItemFrame.Item, fType=ftype, ibt=true}
			end

			self:Unhook(this, "OnShow")
		end)
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
	if self.isMnln then
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
		self:skinObject("ddbutton", {obj=_G.TextToSpeechFrameTtsVoiceDropdown, fType=ftype})
		self:skinObject("ddbutton", {obj=_G.TextToSpeechFrameTtsVoiceAlternateDropdown, fType=ftype})
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
		self:skinObject("ddbutton", {obj=this.AlarmTimeFrame.HourDropdown, fType=ftype})
		self:skinObject("ddbutton", {obj=this.AlarmTimeFrame.MinuteDropdown, fType=ftype})
		self:skinObject("ddbutton", {obj=this.AlarmTimeFrame.AMPMDropdown, fType=ftype})
		self:skinObject("editbox", {obj=_G.TimeManagerAlarmMessageEditBox, fType=ftype})
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true, x2=self.isMnln and 3 or 1})
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.TimeManagerStopwatchCheck, fType=ftype, y1=2, y2=-4}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.TimeManagerAlarmEnabledButton, fType=ftype}
			self:skinCheckButton{obj=_G.TimeManagerMilitaryTimeCheck, fType=ftype}
			self:skinCheckButton{obj=_G.TimeManagerLocalTimeCheck, fType=ftype}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.StopwatchFrame, "OnShow", function(this)
		self:keepFontStrings(_G.StopwatchTabFrame)
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, y1=-16, x2=-1, y2=2})
		if self.modBtns then
			self:skinCloseButton{obj=_G.StopwatchCloseButton, fType=ftype, noSkin=true}
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.StopwatchResetButton, fType=ftype, ofs=-1, x1=0, clr="gold"}
			self:addButtonBorder{obj=_G.StopwatchPlayPauseButton, fType=ftype, ofs=-1, x1=0, clr="gold"}
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.ttDelay = 0.05
aObj.blizzFrames[ftype].Tooltips = function(self)
	if not self.prdb.Tooltips.skin or self.initialized.Tooltips then return end
	self.initialized.Tooltips = true

	if _G.C_AddOns.IsAddOnLoaded("TinyTooltip")
	and not self.prdb.DisabledSkins["TinyTooltip"]
	then
		_G.setmetatable(self.ttList, {__newindex = function(_, _, tTip)
			tTip = _G.type(tTip) == "string" and _G[tTip] or tTip
			self.callbacks:Fire("Tooltip_Setup", tTip, "init")
		end})
		return
	end

	local func
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
			if self.isMnln then
				self.ttHook[tTip] = "OnShow"
			else
				self.ttHook[tTip] = "OnUpdate"
			end
		end
		-- hook Show function for tooltips as required
		-- handle specified function if required [QuestMapFrame.QuestsFrame.CampaignTooltip uses this]
		if self.ttHook[tTip] then
			if tTip:HasScript(self.ttHook[tTip])
			then
				func = "SecureHookScript"
			else
				func = "SecureHook"
			end
			self[func](self, tTip, self.ttHook[tTip], function(this)
				_G.C_Timer.After(self.ttDelay, function() -- slight delay to allow for the tooltip to be populated
					self:applyTooltipGradient(this.sf)
				end)
			end)
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
		if aObj.isMnlnPTRX then
			-- if it has a CompareHeader then skin it
			if tTip.CompareHeader then
				self:skinObject("frame", {obj=tTip.CompareHeader, fType=tTip.fType, kfs=true, bd=13, noBdr=true, x1=-1, y2=-10})
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
	if self.isMnln then
		-- self:add2Table(toolTips, _G.GameNoHeaderTooltip) -- N.B. defined in GameTooltip.xml but NOT referenced in code
		self:add2Table(toolTips, _G.GameSmallHeaderTooltip)
		self:add2Table(toolTips, _G.NamePlateTooltip) -- N.B. Done here as Nameplate skinning function is disabled
	else
		self:add2Table(toolTips, _G.SmallTextTooltip)
	end
	for _, tTip in _G.ipairs(toolTips) do
		if self.isMnln then
			if self:hasTextInName(tTip, "ShoppingTooltip") then
				self.ttHook[tTip] = "SetShown"
			end
		end
		if self.isMnln then
			-- use this hook to prevent GameTooltip gradient overflow, fixes #243
			if tTip == _G.GameTooltip then
				self.ttHook[tTip] = "Show"
			end
		end
		addTooltip(tTip)
	end
	if self.modBtns then
		self:skinCloseButton{obj=self.isMnln and _G.ItemRefTooltip.CloseButton or _G.ItemRefCloseButton, noSkin=true}
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

end

-- These DropDownMenus are still used by TipTac amongst other AddOns
aObj.blizzFrames[ftype].UIDropDownMenu = function(self)
	if not self.prdb.UIDropDownMenu or self.initialized.UIDropDownMenu then return end
	self.initialized.UIDropDownMenu = true

	for i = 1, _G.UIDROPDOWNMENU_MAXLEVELS do
		self:SecureHookScript(_G["DropDownList" .. i], "OnShow", function(this)
			self:skinObject("ddlist", {obj=this, fType=ftype})

			self:Unhook(this, "OnShow")
		end)
	end

	self:SecureHook("UIDropDownMenu_CreateFrames", function(_)
		if not _G["DropDownList" .. _G.UIDROPDOWNMENU_MAXLEVELS].sf then
			self:skinObject("ddlist", {obj=_G["DropDownList" .. _G.UIDROPDOWNMENU_MAXLEVELS], fType=ftype})
		end
	end)

	-- hook these to colour Dropdowns when Disabled/Enabled
	self:SecureHook("UIDropDownMenu_DisableDropDown", function(dropDown)
		self:checkDisabledDD(dropDown, true)
	end)
	self:SecureHook("UIDropDownMenu_EnableDropDown", function(dropDown)
		self:checkDisabledDD(dropDown, false)
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
			or (tcr == 0.19 and tcg == 0.05 and tcb == 0.01) -- WarboardUI/Ally choice in Nazjatar (Horde)
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
	local regs, tcr
	local function skinWidget(wFrame, wInfo)
		-- handle in combat
		if _G.InCombatLockdown() then
		    aObj:add2Table(aObj.oocTab, {skinWidget, {wFrame, wInfo}})
		    return
		end
		-- aObj:Debug("skinWidget: [%s, %s, %s, %s, %s, %s, %s]", wFrame, wFrame:GetDebugName(), wFrame.widgetType, wFrame.widgetTag, wFrame.widgetSetID, wFrame.widgetID, wInfo)

		if wFrame.widgetType == 0 then -- IconAndText (World State: ICONS at TOP)
			-- N.B. DON'T add buttonborder to Icon(s)
			_G.nop()
		elseif wFrame.widgetType == 1 then -- CaptureBar (World State: Capture bar on RHS)
			-- DON'T change textures as it doesn't really improve it
			_G.nop()
		elseif wFrame.widgetType == 2 then -- StatusBar
			-- background & border textures
			if aObj.isMnln then
				regs = {2, 3, 4, 5, 6, 7}
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
			_G.nop()
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
					aObj:clrBtnBdr(wFrame, "grey")
				else
					aObj:clrBtnBdr(wFrame)
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
			aObj:skinObject("frame", {obj=wFrame, fType=ftype, kfs=true, ofs=-4, x1=7, x2=-7, clr="red"})
		elseif wFrame.widgetType == 12 then -- TextureAndText
			-- .Background
			wFrame.Foreground:SetTexture(nil)
			setTextColor(wFrame.Text)
		-- N.B. Classic ONLY has 12 UIWidgets
		elseif wFrame.widgetType == 13 then -- SpellDisplay
			wFrame.Spell.Border:SetTexture(nil)
			tcr = setTextColor(wFrame.Spell.Text)
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=wFrame.Spell, relTo=wFrame.Spell.Icon, reParent={wFrame.Spell.StackCount}}
				if tcr == 0.5 then
					aObj:clrBtnBdr(wFrame.Spell, "grey")
				end
			end
		elseif wFrame.widgetType == 14 then -- DoubleStateIconRow
			-- TODO: add button borders if required
			_G.nop()
		elseif wFrame.widgetType == 15 then -- TextureAndTextRow
			for entryFrame in wFrame.entryPool:EnumerateActive() do
				-- .Background
				-- .Foreground
				setTextColor(entryFrame.Text)
			end
		elseif wFrame.widgetType == 16 then -- ZoneControl
			_G.nop()
		elseif wFrame.widgetType == 17 then -- CaptureZone
			_G.nop()
		elseif wFrame.widgetType == 18 then -- TextureWithAnimation
			_G.nop()
		elseif wFrame.widgetType == 19 then -- DiscreteProgressSteps
			_G.nop()
		elseif wFrame.widgetType == 20 then -- ScenarioHeaderTimer
			wFrame.Frame:SetTexture(nil)
			aObj:skinObject("statusbar", {obj=wFrame.TimerBar, fi=0, bg=wFrame.TimerBar.BG})
		elseif wFrame.widgetType == 21 then -- TextColumnRow
			_G.nop()
		elseif wFrame.widgetType == 22 then -- Spacer
			_G.nop()
		elseif wFrame.widgetType == 23 then -- UnitPowerBar
			_G.nop()
		elseif wFrame.widgetType == 24 then -- FillUpFrames (Dragonriding Vigor)
			wFrame.DecorLeft:SetAlpha(0)
			wFrame.DecorRight:SetAlpha(0)
			for sBar in wFrame.fillUpFramePool:EnumerateActive() do
				sBar.Frame:SetAlpha(0)
			end
		elseif wFrame.widgetType == 25 then -- TextWithSubtext
			_G.nop()
		elseif wFrame.widgetType == 26 then -- MapPinAnimation
			_G.nop()
		elseif wFrame.widgetType == 27 then -- ItemDisplay
			wFrame.Item.NameFrame:SetTexture(nil)
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=wFrame.Item, relTo=wFrame.Item.Icon, reParent={wFrame.Item.Count}}
				aObj:clrButtonFromBorder(wFrame.Item)
			end
		elseif wFrame.widgetType == 28 then -- TugOfWar
			_G.nop()
		elseif wFrame.widgetType == 29 then -- ScenarioHeaderDelves
			aObj:skinObject("frame", {obj=wFrame, fType=ftype, kfs=true, ofs=-2, x1=7, x2=-7, clr="sepia"})
		elseif wFrame.widgetType == 30 -- ButtonHeader
		and aObj.isMnlnPTRX
		then
			wFrame:DisableDrawLayer("BORDER")
			for btn in wFrame.buttonPool:EnumerateActive() do
					aObj:skinStdButton{obj=btn, fType=ftype, ofs=-8, clr="grey"}
			end
		end
	end

	if self.isMnln then
		self:SecureHookScript(_G.UIWidgetCenterDisplayFrame, "OnShow", function(this)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, rns=true})
			if self.modBtnBs then
				self:skinStdButton{obj=this.CloseButton, fType=ftype}
			end

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.UIWidgetCenterDisplayFrame)

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
		if aObj.isMnlnPTRX then
			self:SecureHookScript(_G.UIWidgetBelowMinimapContainerFrame, "OnShow", function(this)

				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ofs=-2, y1=-20, x2=0, clr="gold"})

				self:Unhook(this, "OnShow")
			end)
			self:checkShown(_G.UIWidgetBelowMinimapContainerFrame)
		end
	else
		self:SecureHook(_G.UIWidgetManager, "CreateWidget", function(this, widgetID, _, widgetType)
			skinWidget(this.widgetIdToFrame[widgetID], this.widgetVisTypeInfo[widgetType].visInfoDataFunction(widgetID))
		end)
	end

end
