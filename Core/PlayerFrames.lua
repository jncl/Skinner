local _, aObj = ...

local _G = _G

local ftype = "p"

if not aObj.isClscERA then
	aObj.blizzLoDFrames[ftype].AchievementUI = function(self)
		if not self.prdb.AchievementUI.skin or self.initialized.AchievementUI then return end
		self.initialized.AchievementUI = true

		self:SecureHookScript(_G.AchievementFrame, "OnShow", function(this)
			local function skinSB(statusBar, type)
				aObj:moveObject{obj=_G[statusBar .. type], y=-3}
				aObj:moveObject{obj=_G[statusBar .. "Text"], y=-3}
				_G[statusBar .. "Left"]:SetAlpha(0)
				_G[statusBar .. "Right"]:SetAlpha(0)
				_G[statusBar .. "Middle"]:SetAlpha(0)
				aObj:skinObject("statusbar", {obj=_G[statusBar], fi=0, bg=_G[statusBar .. "FillBar"]})
			end
			local function skinCategories()
				for _, btn in _G.pairs(_G.AchievementFrameCategoriesContainer.buttons) do
					btn.background:SetAlpha(0)
				end
			end
			local function skinBtn(btn)
				if btn.NineSlice then
					aObj:removeNineSlice(btn.NineSlice)
				end
				btn:DisableDrawLayer("BACKGROUND")
				btn:DisableDrawLayer("BORDER")
				btn:DisableDrawLayer("ARTWORK")
				if btn.hiddenDescription then
					btn.hiddenDescription:SetTextColor(aObj.BT:GetRGB())
				end
				aObj:nilTexture(btn.icon.frame, true)
				aObj:secureHook(btn, "Desaturate", function(bObj)
					if bObj.sbb then
						bObj.sbb:SetBackdropBorderColor(bObj:GetBackdropBorderColor())
						bObj.icon.sbb:SetBackdropBorderColor(bObj:GetBackdropBorderColor())
					end
				end)
				aObj:secureHook(btn, "Saturate", function(bObj)
					if bObj.sbb then
						bObj.sbb:SetBackdropBorderColor(bObj:GetBackdropBorderColor())
						bObj.icon.sbb:SetBackdropBorderColor(bObj:GetBackdropBorderColor())
					end
					if bObj.description then
						bObj.description:SetTextColor(aObj.BT:GetRGB())
					end
				end)
				-- if aObj.modBtns then
					-- TODO: PlusMinus is really a texture NOT a button
					-- aObj:SecureHook("AchievementButton_UpdatePlusMinusTexture", function(btn)
						-- if not btn.id then return end
						-- if btn:IsShown() then
							-- btn.collapsed
							-- btn.saturatedStyle
							-- check for both, one of each and none to determine colour
							-- testure used is: Interface\AchievementFrame\UI-Achievement-PlusMinus
						-- end
					-- end)
				-- end
				if aObj.modBtnBs then
					aObj:addButtonBorder{obj=btn.icon, relTo=btn.texture, x1=3, y1=0, x2=-3, y2=6}
					aObj:addButtonBorder{obj=btn, ofs=0}
				end
				if aObj.modChkBtns
				and btn.tracked
				then
					aObj:skinCheckButton{obj=btn.tracked, fType=ftype}
				end
			end
			local function cleanButtons(frame, type)
				if aObj.prdb.AchievementUI.style == 1 then return end -- don't remove textures if option not chosen
				-- remove textures etc from buttons
				local btnName
				for _, btn in _G.pairs(frame.buttons) do
					btnName = btn:GetName() .. (type == "Comparison" and "Player" or "")
					skinBtn(_G[btnName])
					if type == "Summary" then
						if not _G[btnName].tooltipTitle then
							_G[btnName]:Saturate()
						end
					elseif type == "Comparison" then
						-- force update to colour the Player button
						if _G[btnName].completed then
							_G[btnName]:Saturate()
						end
						-- Friend
						btn = _G[btnName:gsub("Player", "Friend")]
						skinBtn(btn)
						-- force update to colour the Friend button
						if btn.completed then
							btn:Saturate()
						end
					end
				end
			end
			self:keepFontStrings(_G.AchievementFrameHeader)
			self:moveObject{obj=_G.AchievementFrameHeaderTitle, x=-60, y=-25}
			self:moveObject{obj=_G.AchievementFrameHeaderPoints, x=40, y=-5}
			_G.AchievementFrameHeaderShield:SetAlpha(1)
			self:skinObject("slider", {obj=_G.AchievementFrameCategoriesContainerScrollBar, fType=ftype, rpTex="background"})
			self:skinObject("frame", {obj=_G.AchievementFrameCategories, fType=ftype, kfs=true, rns=true, fb=true, y1=0})
			-- hook these to stop Categories skinFrame from changing
			self:SecureHook(_G.AchievementFrameCategoriesContainerScrollBar, "Show", function(_)
				_G.AchievementFrameCategories.sf:SetPoint("BOTTOMRIGHT", _G.AchievementFrameCategories, "BOTTOMRIGHT", 24, -2)
			end)
			self:SecureHook(_G.AchievementFrameCategoriesContainerScrollBar, "Hide", function(_)
				_G.AchievementFrameCategories.sf:SetPoint("BOTTOMRIGHT", _G.AchievementFrameCategories, "BOTTOMRIGHT", 2, -2)
			end)
			self:SecureHook("AchievementFrameCategories_Update", function()
				skinCategories()
			end)
			skinCategories()
			if self.isRtl then
				self:getChild(_G.AchievementFrameAchievements, 2):ClearBackdrop()
			end
			self:skinObject("frame", {obj=_G.AchievementFrameAchievements, fType=ftype, kfs=true, fb=true, y1=0, y2=-2})
			self:skinObject("slider", {obj=_G.AchievementFrameAchievementsContainerScrollBar, fType=ftype})
			if self.prdb.AchievementUI.style == 2 then
				-- remove textures etc from buttons
				cleanButtons(_G.AchievementFrameAchievementsContainer, "Achievements")
				-- hook this to handle objectives text colour changes
				self:SecureHookScript(_G.AchievementFrameAchievementsObjectives, "OnShow", function(fObj)
					if fObj.completed then
						for _, child in _G.ipairs{fObj:GetChildren()} do
							for _, reg in _G.ipairs{child:GetChildren()} do
								if reg:IsObjectType("FontString") then
									reg:SetTextColor(self.BT:GetRGB())
								end
							end
						end
					end
				end)
				-- hook this to remove icon border used by the Objectives mini panels
				self:RawHook("AchievementButton_GetMeta", function(...)
					local obj = self.hooks.AchievementButton_GetMeta(...)
					obj:DisableDrawLayer("BORDER")
					if self.modBtnBs then
						self:addButtonBorder{obj=obj, es=12, relTo=obj.icon}
					end
					return obj
				end, true)
			end
			-- glaze any existing progress bars
			local function glazeProgressBar(pBar)
				_G[pBar]:DisableDrawLayer("ARTWORK")
				aObj:skinObject("statusbar", {obj=_G[pBar], fi=0, bg=_G[pBar .. "BG"]})
			end
			for i = 1, 10 do
				if _G["AchievementFrameProgressBar" .. i] then
					glazeProgressBar("AchievementFrameProgressBar" .. i)
				end
			end
			-- hook this to skin StatusBars used by the Objectives mini panels
			self:RawHook("AchievementButton_GetProgressBar", function(...)
				local obj = self.hooks.AchievementButton_GetProgressBar(...)
				glazeProgressBar(obj:GetName())
				return obj
			end, true)
			-- hook this to colour the metaCriteria & Criteria text
			self:SecureHook("AchievementObjectives_DisplayCriteria", function(objectivesFrame, id, _)
				if not id then return end
				if not objectivesFrame.completed then return end
				for _, child in _G.ipairs{objectivesFrame:GetChildren()} do
					if child.label then -- metaCriteria
						if _G.select(2, child.label:GetTextColor()) == 0 then -- completed criteria
							child.label:SetTextColor(_G.HIGHLIGHT_FONT_COLOR:GetRGB())
						end
					elseif child.name then -- criteria
						if _G.type(child.name) == "table" then
							if _G.select(2, child.name:GetTextColor()) == 0 then -- completed criteria
								child.name:SetTextColor(_G.HIGHLIGHT_FONT_COLOR:GetRGB())
							end
						end
					end
					if child.sbb then
						self:clrBtnBdr(child.sbb, not child.check:IsShown() and "disabled")
					end
				end
			end)
			self:moveObject{obj=_G.AchievementFrameCloseButton, y=6}
			-- this is not a standard dropdown
			self:moveObject{obj=_G.AchievementFrameFilterDropDown, y=-7}
			-- skin the dropdown frame
			if self.prdb.TabDDTextures.textureddd then
				local tex = _G.AchievementFrameFilterDropDown:CreateTexture(nil, "BORDER")
				tex:SetTexture(self.itTex)
				tex:SetSize(110, 19)
				tex:SetPoint("RIGHT", _G.AchievementFrameFilterDropDown, "RIGHT", -3, 4)
				self:skinObject("frame", {obj=_G.AchievementFrameFilterDropDown, fType=ftype, ng=true, x1=-7, y1=1, x2=1, y2=7})
				if self.modBtnBs then
				    self:addButtonBorder{obj=_G.AchievementFrameFilterDropDownButton, es=12, ofs=-2, x1=1}
				end
			end
			if self.isRtl then
				-- Search function
				self:skinObject("editbox", {obj=this.searchBox, fType=ftype, si=true, six=5, ofs=-2, y1=-4, y2=4})
				self:moveObject{obj=this.searchBox, y=-8}
				self:skinObject("statusbar", {obj=this.searchProgressBar, fi=0, bg=this.searchProgressBar.bg})
			end
			self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true, ignoreHLTex=false, regions={7, 8, 9, 10}, offsets={x1=11, y1=self.isTT and 2 or -3, x2=-12, y2=-7}})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, y1=7, x2=0, y2=-2})

			if self.isRtl then
				self:SecureHookScript(this.searchPreviewContainer, "OnShow", function(fObj)
					self:adjHeight{obj=fObj, adj=((4 * 27) + 30)}
					for i = 1, 5 do
						fObj["searchPreview" .. i]:SetNormalTexture(nil)
						fObj["searchPreview" .. i]:SetPushedTexture(nil)
						fObj["searchPreview" .. i].iconFrame:SetTexture(nil)
						if self.modBtnBs then
							self:addButtonBorder{obj=fObj["searchPreview" .. i], relTo=fObj["searchPreview" .. i].icon}
						end
					end
					fObj.showAllSearchResults:SetNormalTexture(nil)
					fObj.showAllSearchResults:SetPushedTexture(nil)
					self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, y1=4, y2=2})
					_G.LowerFrameLevel(fObj.sf)

					self:Unhook(fObj, "OnShow")
				end)

				self:SecureHookScript(this.searchResults, "OnShow", function(fObj)
					fObj.scrollFrame:SetPoint("BOTTOMRIGHT", fObj.bottomRightCorner, "RIGHT", -26, 8)
					self:skinObject("slider", {obj=fObj.scrollFrame.scrollBar, fType=ftype})
					for _, btn in _G.pairs(fObj.scrollFrame.buttons) do
						btn:SetNormalTexture(nil)
						btn:SetPushedTexture(nil)
						btn.iconFrame:SetTexture(nil)
						if self.modBtnBs then
							self:addButtonBorder{obj=btn, relTo=btn.icon}
						end
					end
					self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, cb=true, x1=-8, y1=-1, x2=1})

					self:Unhook(fObj, "OnShow")
				end)
			end

			self:SecureHookScript(_G.AchievementFrameStats, "OnShow", function(fObj)
				self:skinObject("slider", {obj=_G.AchievementFrameStatsContainerScrollBar, fType=ftype})
				_G.AchievementFrameStatsBG:SetAlpha(0)
				if self.isRtl then
					self:getChild(fObj, 3):ClearBackdrop()
				else
					self:removeNineSlice(self:getChild(fObj, 3).NineSlice)
				end
				self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, fb=true, y1=0, y2=-2})
				local function skinStats()
					for _, btn in _G.pairs(_G.AchievementFrameStatsContainer.buttons) do
						btn.background:SetTexture(nil)
						btn.left:SetAlpha(0)
						btn.middle:SetAlpha(0)
						btn.right:SetAlpha(0)
					end
				end
				skinStats()
				-- hook this to skin buttons
				self:SecureHook("AchievementFrameStats_Update", function()
					skinStats()
				end)

				self:Unhook(fObj, "OnShow")
			end)

			self:SecureHookScript(_G.AchievementFrameSummary, "OnShow", function(fObj)
				_G.AchievementFrameSummaryBackground:SetAlpha(0)
				_G.AchievementFrameSummaryAchievementsEmptyText:SetText() -- remove 'No recently completed Achievements' text
				_G.AchievementFrameSummaryAchievementsHeaderHeader:SetAlpha(0)
				self:skinObject("slider", {obj=_G.AchievementFrameAchievementsContainerScrollBar, fType=ftype})
				-- remove textures etc from buttons
				cleanButtons(_G.AchievementFrameSummaryAchievements, "Summary")
				-- Categories SubPanel
				self:keepFontStrings(_G.AchievementFrameSummaryCategoriesHeader)
				for i = 1, self.isRtl and 12 or 8 do
					skinSB("AchievementFrameSummaryCategoriesCategory" .. i, "Label")
				end
				if self.isRtl then
					self:getChild(fObj, 1):ClearBackdrop()
				else
					self:removeNineSlice(self:getChild(fObj, 1).NineSlice)
				end
				self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, fb=true, y1=-1, y2=-2})
				skinSB("AchievementFrameSummaryCategoriesStatusBar", "Title")

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(_G.AchievementFrameSummary)

			self:SecureHookScript(_G.AchievementFrameComparison, "OnShow", function(fOBj)
				_G.AchievementFrameComparisonBackground:SetAlpha(0)
				_G.AchievementFrameComparisonDark:SetAlpha(0)
				_G.AchievementFrameComparisonWatermark:SetAlpha(0)
				-- Header
				self:keepFontStrings(_G.AchievementFrameComparisonHeader)
				_G.AchievementFrameComparisonHeaderShield:SetAlpha(1)
				-- move header info
				_G.AchievementFrameComparisonHeaderShield:ClearAllPoints()
				_G.AchievementFrameComparisonHeaderShield:SetPoint("RIGHT", _G.AchievementFrameCloseButton, "LEFT", -10, -1)
				_G.AchievementFrameComparisonHeaderPoints:ClearAllPoints()
				_G.AchievementFrameComparisonHeaderPoints:SetPoint("RIGHT", _G.AchievementFrameComparisonHeaderShield, "LEFT", -10, 1)
				_G.AchievementFrameComparisonHeaderName:ClearAllPoints()
				_G.AchievementFrameComparisonHeaderName:SetPoint("RIGHT", _G.AchievementFrameComparisonHeaderPoints, "LEFT", -10, 0)
				-- Container
				self:skinObject("slider", {obj=_G.AchievementFrameComparisonContainerScrollBar, fType=ftype})
				-- Summary Panel
				if self.isRtl then
					self:getChild(fOBj, 5):ClearBackdrop()
				else
					self:removeNineSlice(self:getChild(fOBj, 5).NineSlice)
				end
				self:skinObject("frame", {obj=fOBj, fType=ftype, kfs=true, fb=true, y1=0, y2=-2})
				for _, type in _G.pairs{"Player", "Friend"} do
					if self.isRtl then
						_G["AchievementFrameComparisonSummary" .. type]:ClearBackdrop()
					else
						self:removeNineSlice(_G["AchievementFrameComparisonSummary" .. type].NineSlice)
					end
					_G["AchievementFrameComparisonSummary" .. type .. "Background"]:SetAlpha(0)
					skinSB("AchievementFrameComparisonSummary" .. type .. "StatusBar", "Title")
				end
				-- remove textures etc from buttons
				cleanButtons(_G.AchievementFrameComparisonContainer, "Comparison")
				self:skinObject("slider", {obj=_G.AchievementFrameComparisonStatsContainerScrollBar, fType=ftype})
				local function skinComparisonStats()
					for _, btn in _G.pairs(_G.AchievementFrameComparisonStatsContainer.buttons) do
						if btn.isHeader then
							btn.background:SetAlpha(0)
						end
						btn.left:SetAlpha(0)
						btn.left2:SetAlpha(0)
						btn.middle:SetAlpha(0)
						btn.middle2:SetAlpha(0)
						btn.right:SetAlpha(0)
						btn.right2:SetAlpha(0)
					end
				end
				self:SecureHook("AchievementFrameComparison_UpdateStats", function()
					skinComparisonStats()
				end)
				self:SecureHook(_G.AchievementFrameComparisonStatsContainer, "Show", function()
					skinComparisonStats()
				end)

				self:Unhook(fOBj, "OnShow")
			end)
			self:checkShown(_G.AchievementFrameComparison)

			-- send message when UI is skinned (used by AchieveIt skin)
			self:SendMessage("AchievementUI_Skinned", self)

			self:Unhook(this, "OnShow")
		end)

	end
end
aObj.blizzFrames[ftype].Buffs = function(self)
	if not self.prdb.Buffs or self.initialized.Buffs then return end
	self.initialized.Buffs = true

	if self.modBtnBs then
		local function skinBuffBtn(btn)
			if btn
			and not btn.sbb
			then
				aObj:addButtonBorder{obj=btn, reParent={btn.count, btn.duration}, ofs=3, clr="grey"}
			end
		end
		-- skin current Buffs
		for i = 1, _G.BUFF_MAX_DISPLAY do
			skinBuffBtn(_G["BuffButton" .. i])
		end
		-- if not all buff buttons created yet
		if not _G.BuffButton32 then
			-- hook this to skin new Buffs
			self:SecureHook("AuraButton_Update", function(buttonName, index, _)
				if buttonName == "BuffButton" then
					skinBuffBtn(_G[buttonName .. index])
				end
			end)
		end
	end

	-- Debuffs already have a coloured border
	-- Temp Enchants already have a coloured border

end

aObj.blizzFrames[ftype].CastingBar = function(self)
	if not self.prdb.CastingBar.skin or self.initialized.CastingBar then return end
	self.initialized.CastingBar = true

	if _G.IsAddOnLoaded("Quartz")
	or _G.IsAddOnLoaded("Dominos_Cast")
	then
		self.blizzFrames[ftype].CastingBar = nil
		return
	end

	local cbFrame
	for _, type in _G.pairs{"", "Pet"} do
		cbFrame = _G[type .. "CastingBarFrame"]
		cbFrame.Border:SetAlpha(0)
		self:changeShield(cbFrame.BorderShield, cbFrame.Icon)
		cbFrame.Flash:SetAllPoints()
		cbFrame.Flash:SetTexture(self.tFDIDs.w8x8)
		if self.prdb.CastingBar.glaze then
			self:skinObject("statusbar", {obj=cbFrame, fi=0, bg=self:getRegion(cbFrame, 1)})
		end
		-- adjust text and spark in Classic mode
		if not cbFrame.ignoreFramePositionManager then
			cbFrame.Text:SetPoint("TOP", 0, 2)
			cbFrame.Spark.offsetY = -1
		end
	end

	-- hook this to handle the CastingBar being attached to the Unitframe and then reset
	self:SecureHook("CastingBarFrame_SetLook", function(castBar, look)
		castBar.Border:SetAlpha(0)
		castBar.Flash:SetAllPoints()
		castBar.Flash:SetTexture(self.tFDIDs.w8x8)
		if look == "CLASSIC" then
			castBar.Text:SetPoint("TOP", 0, 2)
			castBar.Spark.offsetY = -1
		end
	end)

end

aObj.blizzFrames[ftype].CompactFrames = function(self)
	if not self.prdb.CompactFrames or self.initialized.CompactFrames then return end
	self.initialized.CompactFrames = true

	if _G.IsAddOnLoaded("Tukui")
	or _G.IsAddOnLoaded("ElvUI")
	then
		self.blizzFrames[ftype].CompactFrames = nil
		return
	end

	local function skinUnit(unit)
		-- handle in combat
		if _G.InCombatLockdown() then
		    aObj:add2Table(aObj.oocTab, {skinUnit, {unit}})
		    return
		end
		if aObj:hasTextInTexture(unit.healthBar:GetStatusBarTexture(), "RaidFrame")
		or unit.healthBar:GetStatusBarTexture():GetTexture() == 423819 -- interface/raidframe/raid-bar-hp-fill.blp
		then
			unit:DisableDrawLayer("BACKGROUND")
			unit.horizDivider:SetTexture(nil)
			unit.horizTopBorder:SetTexture(nil)
			unit.horizBottomBorder:SetTexture(nil)
			unit.vertLeftBorder:SetTexture(nil)
			unit.vertRightBorder:SetTexture(nil)
			aObj:skinObject("statusbar", {obj=unit.healthBar, fi=0, bg=unit.healthBar.background})
			aObj:skinObject("statusbar", {obj=unit.powerBar, fi=0, bg=unit.powerBar.background})
		end
	end
	local function skinGrp(grp)
		aObj:skinObject("frame", {obj=grp.borderFrame, fType=ftype, kfs=true, ofs=1, y1=-1, x2=-4, y2=4})
		local grpName = grp:GetName()
		for i = 1, _G.MEMBERS_PER_RAID_GROUP do
			skinUnit(_G[grpName .. "Member" .. i])
		end
	end

	-- Compact Party Frame
	self:SecureHook("CompactPartyFrame_OnLoad", function()
		self:skinObject("frame", {obj=_G.CompactPartyFrame.borderFrame, fType=ftype, kfs=true})

		self:Unhook("CompactPartyFrame_OnLoad")
	end)
	-- hook this to skin any new CompactRaidGroup(s)
	self:SecureHook("CompactRaidGroup_UpdateLayout", function(frame)
		skinGrp(frame)
	end)

	-- Compact RaidFrame Container
	-- handle AddOn being disabled
	if not self:checkLoadable("Blizzard_CompactRaidFrames") then
		return
	end

	local function skinCRFCframes()
		for type, fTab in _G.pairs(_G.CompactRaidFrameContainer.frameUpdateList) do
			for _, frame in _G.pairs(fTab) do
				if type == "normal" then
					if frame.borderFrame then -- group or party
						skinGrp(frame)
					else
						skinUnit(frame)
					end
				elseif type == "mini" then
					skinUnit(frame)
				end
			end
		end
	end
	-- hook this to skin any new CompactRaidFrameContainer entries
	self:SecureHook("FlowContainer_AddObject", function(container, _)
		if container == _G.CompactRaidFrameContainer then -- only for compact raid frame objects
			skinCRFCframes()
		end
	end)
	-- skin any existing unit(s) [mini, normal]
	skinCRFCframes()
	self:skinObject("frame", {obj=_G.CompactRaidFrameContainer.borderFrame, fType=ftype, kfs=true, ofs=1, y1=-1, x2=-4, y2=4})

	-- Compact RaidFrame Manager
	self:SecureHookScript(_G.CompactRaidFrameManager, "OnShow", function(this)
		self:moveObject{obj=this.toggleButton, x=5}
		this.toggleButton:SetSize(12, 32)
		this.toggleButton.nt = this.toggleButton:GetNormalTexture()
		this.toggleButton.nt:SetTexCoord(0.22, 0.5, 0.33, 0.67)
		-- hook this to trim the texture
		self:RawHook(this.toggleButton.nt, "SetTexCoord", function(tObj, x1, x2, _)
			self.hooks[tObj].SetTexCoord(tObj, x1 == 0 and x1 + 0.22 or x1 + 0.26, x2, 0.33, 0.67)
		end, true)
		-- Display Frame
		_G.CompactRaidFrameManagerDisplayFrameHeaderBackground:SetTexture(nil)
		_G.CompactRaidFrameManagerDisplayFrameHeaderDelineator:SetTexture(nil)
		this.displayFrame.filterOptions:DisableDrawLayer("BACKGROUND")
		self:skinObject("dropdown", {obj=this.displayFrame.profileSelector, fType=ftype})
		self:skinObject("frame", {obj=this.containerResizeFrame, fType=ftype, kfs=true})
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ofs=0})
		if self.modBtns then
			for i = 1, 8 do
				self:skinStdButton{obj=this.displayFrame.filterOptions["filterGroup" .. i]}
			end
			self:skinStdButton{obj=this.displayFrame.lockedModeToggle, fType=ftype}
			self:skinStdButton{obj=this.displayFrame.hiddenModeToggle, fType=ftype}
			self:skinStdButton{obj=this.displayFrame.convertToRaid, fType=ftype}
			self:skinStdButton{obj=this.displayFrame.leaderOptions.readyCheckButton, fType=ftype}
			if not self.isClscERA then
				self:skinStdButton{obj=this.displayFrame.leaderOptions.rolePollButton, fType=ftype}
			end
			if self.isRtl then
				for _, type in _G.pairs{"Tank", "Healer", "Damager"} do
					self:skinStdButton{obj=this.displayFrame.filterOptions["filterRole" .. type]}
				end
				this.displayFrame.leaderOptions.countdownButton:DisableDrawLayer("ARTWORK") -- alpha values are changed in code
				this.displayFrame.leaderOptions.countdownButton.Text:SetDrawLayer("OVERLAY") -- move draw layer so it is displayed
				self:skinStdButton{obj=this.displayFrame.leaderOptions.countdownButton, fType=ftype}
				self:skinStdButton{obj=_G.CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton, fType=ftype}
				_G.CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:GetNormalTexture():SetAlpha(1) -- icon
			end
			self:SecureHook("CompactRaidFrameManager_UpdateOptionsFlowContainer", function(fObj)
				-- handle button skin frames not being created yet
				if fObj.displayFrame.leaderOptions.readyCheckButton.sb then
					self:clrBtnBdr(fObj.displayFrame.leaderOptions.readyCheckButton)
					if not self.isClscERA then
						self:clrBtnBdr(fObj.displayFrame.leaderOptions.rolePollButton)
					end
					if self.isRtl then
						self:clrBtnBdr(fObj.displayFrame.leaderOptions.countdownButton)
					end
				end
			end)
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=this.displayFrame.everyoneIsAssistButton}
			_G.RaiseFrameLevel(this.displayFrame.everyoneIsAssistButton) -- so button border is visible
		end

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.CompactRaidFrameManager)

end

aObj.blizzLoDFrames[ftype].ItemSocketingUI = function(self)
	if not self.prdb.ItemSocketingUI or self.initialized.ItemSocketingUI then return end
	self.initialized.ItemSocketingUI = true

	-- copy of GEM_TYPE_INFO from Blizzard_ItemSocketingUI.xml
	local gemTypeInfo = {
		Yellow          = {textureKit="yellow", r=0.97, g=0.82, b=0.29},
		Red             = {textureKit="red", r=1, g=0.47, b=0.47},
		Blue            = {textureKit="blue", r=0.47, g=0.67, b=1},
		Hydraulic       = {textureKit="hydraulic", r=1, g=1, b=1},
		Cogwheel        = {textureKit="cogwheel", r=1, g=1, b=1},
		Meta            = {textureKit="meta", r=1, g=1, b=1},
		Prismatic       = {textureKit="prismatic", r=1, g=1, b=1},
		PunchcardRed    = {textureKit="punchcard-red", r=1, g=0.47, b=0.47},
		PunchcardYellow = {textureKit="punchcard-yellow", r=0.97, g=0.82, b=0.29},
		PunchcardBlue   = {textureKit="punchcard-blue", r=0.47, g=0.67, b=1},
		Domination      = {textureKit="domination", r=1, g=1, b=1},
		Cypher          = {textureKit="meta", r=1, g=1, b=1},
	}
	self:SecureHookScript(_G.ItemSocketingFrame, "OnShow", function(this)
		self:skinObject("slider", {obj=_G.ItemSocketingScrollFrame.ScrollBar, fType=ftype, rpTex="artwork"})
		if self.isRtl then
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true, x2=3})
		else
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, x1=10, y1=-12, x2=-4, y2=30})
			if self.modBtns then
				self:skinCloseButton{obj=_G.ItemSocketingCloseButton, fType=ftype}
			end
		end
		if self.modBtns then
			self:skinStdButton{obj=_G.ItemSocketingSocketButton, fType=ftype, schk=true}
			this.Sockets = this.Sockets or {_G.ItemSocketingSocket1, _G.ItemSocketingSocket2, _G.ItemSocketingSocket3}
			for _, socket in _G.ipairs(this.Sockets) do
				socket:DisableDrawLayer("BACKGROUND")
				socket:DisableDrawLayer("BORDER")
				self:skinObject("button", {obj=socket, fType=ftype, bd=10, ng=true}) -- ≈ fb option for frame
			end
			local function colourSockets()
				local numSockets = _G.GetNumSockets()
				for i, socket in _G.ipairs(_G.ItemSocketingFrame.Sockets) do
					if i <= numSockets then
						local clr = gemTypeInfo[_G.GetSocketTypes(i)]
						socket.sb:SetBackdropBorderColor(clr.r, clr.g, clr.b)
					end
				end
			end
			-- hook this to colour the button border
			self:SecureHook("ItemSocketingFrame_Update", function()
				colourSockets()
			end)
			colourSockets()
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].LootFrames = function(self)
	if not self.prdb.LootFrames.skin or self.initialized.LootFrames then return end
	self.initialized.LootFrames = true

	self:SecureHookScript(_G.LootFrame, "OnShow", function(this)
		for i = 1, _G.LOOTFRAME_NUMBUTTONS do
			_G["LootButton" .. i .. "NameFrame"]:SetTexture(nil)
			if self.modBtnBs then
				self:addButtonBorder{obj=_G["LootButton" .. i]}
			end
		end
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true})
		if self.modBtnBs then
			self:SecureHook("LootFrame_Update", function()
				for i = 1, _G.LOOTFRAME_NUMBUTTONS do
					if _G["LootButton" .. i].quality then
						_G.SetItemButtonQuality(_G["LootButton" .. i], _G["LootButton" .. i].quality)
					end
				end
			end)
			self:addButtonBorder{obj=_G.LootFrameDownButton, ofs=-2, clr="gold"}
			self:addButtonBorder{obj=_G.LootFrameUpButton, ofs=-2, clr="gold"}
		end

		self:Unhook(this, "OnShow")
	end)

	local function skinGroupLoot(frame)

		frame:DisableDrawLayer("BACKGROUND")
		frame:DisableDrawLayer("BORDER")
		if not aObj.isRtl then
			local fName = frame:GetName()
			_G[fName .. "SlotTexture"]:SetTexture(nil)
			_G[fName .. "NameFrame"]:SetTexture(nil)
			_G[fName .. "Corner"]:SetAlpha(0)
			frame.Timer:DisableDrawLayer("ARTWORK")
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=frame, relTo=frame.Icon, reParent={frame.Count}}
			end
		end
		aObj:skinObject("statusbar", {obj=frame.Timer, fi=0, bg=frame.Timer.Background})
		-- hook this to show the Timer
		aObj:secureHook(frame, "Show", function(this)
			this.Timer:SetFrameLevel(this:GetFrameLevel() + 1)
		end)

		frame:SetScale(aObj.prdb.LootFrames.size ~= 1 and 0.75 or 1)
		if aObj.isRtl then
			frame.IconFrame.Border:SetAlpha(0)
		end
		if aObj.modBtns then
			aObj:skinCloseButton{obj=frame.PassButton}
		end
		if aObj.prdb.LootFrames.size ~= 3 then -- Normal or small
			aObj:skinObject("frame", {obj=frame, fType=ftype, kfs=true, cb=true, x1=-3, y2=-3})
		else -- Micro
			aObj:moveObject{obj=frame.IconFrame, x=95, y=5}
			frame.Name:SetAlpha(0)
			frame.NeedButton:ClearAllPoints()
			frame.NeedButton:SetPoint("TOPRIGHT", "$parent", "TOPRIGHT", -34, -4)
			frame.PassButton:ClearAllPoints()
			frame.PassButton:SetPoint("LEFT", frame.NeedButton, "RIGHT", 0, 2)
			frame.GreedButton:ClearAllPoints()
			frame.GreedButton:SetPoint("RIGHT", frame.NeedButton, "LEFT")
			if aObj.isRtl then
				frame.DisenchantButton:ClearAllPoints()
				frame.DisenchantButton:SetPoint("RIGHT", frame.GreedButton, "LEFT", 2, 0)
			end
			aObj:adjWidth{obj=frame.Timer, adj=-30}
			frame.Timer:ClearAllPoints()
			frame.Timer:SetPoint("BOTTOMRIGHT", "$parent", "BOTTOMRIGHT", -10, 13)
			aObj:skinObject("frame", {obj=frame, fType=ftype, kfs=true, cb=true, x1=97, y2=8})
		end

	end
	for i = 1, _G.NUM_GROUP_LOOT_FRAMES do
		self:SecureHookScript(_G["GroupLootFrame" .. i], "OnShow", function(this)
			skinGroupLoot(this)

			self:Unhook(this, "OnShow")
		end)
	end

	self:SecureHookScript(_G.MasterLooterFrame, "OnShow", function(this)
		this:DisableDrawLayer("BACKGROUND")
		this.Item.NameBorderLeft:SetTexture(nil)
		this.Item.NameBorderRight:SetTexture(nil)
		this.Item.NameBorderMid:SetTexture(nil)
		this.Item.IconBorder:SetTexture(nil)
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true})
		if self.modBtns then
			 self:skinCloseButton{obj=self:getChild(this, 3)} -- unamed close button
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=this.Item, relTo=this.Item.Icon}
		end

		self:Unhook(this, "OnShow")
	end)

	if self.isRtl then
		self:SecureHookScript(_G.BonusRollFrame, "OnShow", function(this)
			self:removeRegions(this, {1, 2, 3, 5})
			self:skinObject("statusbar", {obj=this.PromptFrame.Timer, fi=0})
			self:skinObject("frame", {obj=this, fType=ftype, bg=true})
			if self.modBtnBs then
				 self:addButtonBorder{obj=this.PromptFrame, relTo=this.PromptFrame.Icon, reParent={this.SpecIcon}}
			end

			self:Unhook(this, "OnShow")
		end)
		self:SecureHookScript(_G.BonusRollLootWonFrame, "OnShow", function(this)
			this:DisableDrawLayer("BACKGROUND")
			if this.SpecRing then this.SpecRing:SetTexture(nil) end
			self:skinObject("frame", {obj=this, fType=ftype, ofs=-10, y2=8})

			self:Unhook(this, "OnShow")
		end)
		self:SecureHookScript(_G.BonusRollMoneyWonFrame, "OnShow", function(this)
			this:DisableDrawLayer("BACKGROUND")
			if this.SpecRing then this.SpecRing:SetTexture(nil) end
			self:skinObject("frame", {obj=this, fType=ftype, ofs=-8, y2=8})

			self:Unhook(this, "OnShow")
		end)
	end

end

aObj.blizzFrames[ftype].LootHistory = function(self)
	if not self.prdb.LootHistory or self.initialized.LootHistory then return end
	self.initialized.LootHistory = true

	self:SecureHookScript(_G.LootHistoryFrame, "OnShow", function(this)
		this:DisableDrawLayer("BACKGROUND")
		this.Divider:SetTexture(nil)
		self:skinObject("slider", {obj=this.ScrollFrame.ScrollBar, fType=ftype, rpTex="background"})
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, ofs=-1})
		local function skinItemFrames(obj)
			for _, frame in _G.pairs(obj.itemFrames) do
				frame.Divider:SetTexture(nil)
				frame.NameBorderLeft:SetTexture(nil)
				frame.NameBorderRight:SetTexture(nil)
				frame.NameBorderMid:SetTexture(nil)
				frame.ActiveHighlight:SetTexture(nil)
				if aObj.modBtns then
					if not frame.ToggleButton.sb then
						aObj:skinExpandButton{obj=frame.ToggleButton, plus=true}
					end
				end
			end
		end
		-- hook this to skin loot history items
		self:SecureHook("LootHistoryFrame_FullUpdate", function(fObj)
			skinItemFrames(fObj)
		end)
		-- skin existing itemFrames
		skinItemFrames(this)

		self:skinObject("dropdown", {obj=_G.LootHistoryDropDown, fType=ftype})

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].MirrorTimers = function(self)
	if not self.prdb.MirrorTimers.skin or self.initialized.MirrorTimers then return end
	self.initialized.MirrorTimers = true

	local objName, obj, objBG, objSB
	for i = 1, _G.MIRRORTIMER_NUMTIMERS do
		objName = "MirrorTimer" .. i
		obj = _G[objName]
		objBG = self:getRegion(obj, 1)
		objSB = _G[objName .. "StatusBar"]
		self:removeRegions(obj, {3})
		obj:SetHeight(obj:GetHeight() * 1.25)
		self:moveObject{obj=_G[objName .. "Text"], y=-2}
		objBG:SetWidth(objBG:GetWidth() * 0.75)
		objSB:SetWidth(objSB:GetWidth() * 0.75)
		if self.prdb.MirrorTimers.glaze then
			self:skinObject("statusbar", {obj=objSB, fi=0, bg=objBG})
		end
	end

	if self.isRtl then
		-- Battleground/Arena/Island Expeditions Start Timer
		local function skinTT(timer)

			if not aObj.sbGlazed[timer.bar] then
				_G[timer.bar:GetName() .. "Border"]:SetTexture(nil) -- animations
				aObj:skinObject("statusbar", {obj=timer.bar, fi=0})
			end

		end
		self:SecureHook("StartTimer_SetGoTexture", function(timer)
			skinTT(timer)
		end)
		-- skin existing timers
		for _, timer in _G.pairs(_G.TimerTracker.timerList) do
			skinTT(timer)
		end
	end

end

aObj.blizzLoDFrames[ftype].RaidUI = function(self)
	if not self.prdb.RaidUI or self.initialized.RaidUI then return end
	self.initialized.RaidUI = true

	-- N.B. accessed via Raid tab on Friends Frame

	-- N.B. Pullout functionality commented out, therefore code removed from this function

	self:moveObject{obj=_G.RaidGroup1, x=3}

	-- Raid Groups
	for i = 1, _G.MAX_RAID_GROUPS do
		_G["RaidGroup" .. i]:DisableDrawLayer("BACKGROUND")
		self:skinObject("frame", {obj=_G["RaidGroup" .. i], fType=ftype, fb=true})
	end
	-- Raid Group Buttons
	for i = 1, _G.MAX_RAID_GROUPS * 5 do
		_G["RaidGroupButton" .. i]:SetNormalTexture(nil)
		self:skinObject("button", {obj=_G["RaidGroupButton" .. i], fType=ftype, subt=true--[[, bd=7]], ofs=1})
	end
	-- Raid Class Tabs (side)
	for i = 1, _G.MAX_RAID_CLASS_BUTTONS do
		self:removeRegions(_G["RaidClassButton" .. i], {1}) -- 2 is icon, 3 is text
	end

	if not self.isRtl then
		if self.modBtns then
			self:skinStdButton{obj=_G.RaidFrameReadyCheckButton, fType=ftype}
		end
	end

end

aObj.blizzFrames[ftype].ReadyCheck = function(self)
	if not self.prdb.ReadyCheck or self.initialized.ReadyCheck then return end
	self.initialized.ReadyCheck = true

	self:SecureHookScript(_G.ReadyCheckFrame, "OnShow", function(this)
		self:skinObject("frame", {obj=_G.ReadyCheckListenerFrame, fType=ftype, kfs=true, x1=32})
		if self.modBtns then
			self:skinStdButton{obj=_G.ReadyCheckFrameYesButton}
			self:skinStdButton{obj=_G.ReadyCheckFrameNoButton}
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].TradeFrame = function(self)
	if not self.prdb.TradeFrame or self.initialized.TradeFrame then return end
	self.initialized.TradeFrame = true

	self:SecureHookScript(_G.TradeFrame, "OnShow", function(this)
		if self.isRtl then
			this.RecipientOverlay.portrait:SetAlpha(0)
			this.RecipientOverlay.portraitFrame:SetTexture(nil)
		end
		self:removeInset(_G.TradeRecipientItemsInset)
		self:removeInset(_G.TradeRecipientEnchantInset)
		self:removeInset(_G.TradePlayerItemsInset)
		self:removeInset(_G.TradePlayerEnchantInset)
		self:removeInset(_G.TradePlayerInputMoneyInset)
		self:removeInset(_G.TradeRecipientMoneyInset)
		self:skinObject("moneyframe", {obj=_G.TradePlayerInputMoneyFrame, moveGEB=true})
		_G.TradeRecipientMoneyBg:DisableDrawLayer("BACKGROUND")
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true, x2=1})
		if self.modBtns then
			self:skinStdButton{obj=_G.TradeFrameTradeButton}
			self:skinStdButton{obj=_G.TradeFrameCancelButton}
		end
		if self.modBtnBs then
			for i = 1, _G.MAX_TRADE_ITEMS do
				for _, type in _G.pairs{"Player", "Recipient"} do
					_G["Trade" .. type .. "Item" .. i .. "SlotTexture"]:SetTexture(nil)
					_G["Trade" .. type .. "Item" .. i .. "NameFrame"]:SetTexture(nil)
					self:addButtonBorder{obj=_G["Trade" .. type .. "Item" .. i .. "ItemButton"], ibt=true}
				end
			end
		end

		self:Unhook(this, "OnShow")
	end)

end
