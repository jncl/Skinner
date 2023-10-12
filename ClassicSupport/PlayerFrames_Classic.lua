local _, aObj = ...

local _G = _G
-- luacheck: ignore 631 (line is too long)

aObj.SetupClassic_PlayerFrames = function()
	local ftype = "p"

	if aObj.isClsc then
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
				if self.modBtnBs then
					self:addButtonBorder{obj=_G.AchievementFrameFilterDropDownButton, fType=ftype, es=12, ofs=-2, x1=1}
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
				self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true, ignoreHLTex=false, regions={7, 8, 9, 10}, offsets={x1=10, x2=-11, y2=-8}})
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, y1=7, x2=0--[[, y2=0]]})

				self:SecureHookScript(_G.AchievementFrameStats, "OnShow", function(fObj)
					self:skinObject("slider", {obj=_G.AchievementFrameStatsContainerScrollBar, fType=ftype})
					_G.AchievementFrameStatsBG:SetAlpha(0)
					self:removeNineSlice(self:getChild(fObj, 3).NineSlice)
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
					for i = 1, 8 do
						skinSB("AchievementFrameSummaryCategoriesCategory" .. i, "Label")
					end
					self:removeNineSlice(self:getChild(fObj, 1).NineSlice)
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
					self:removeNineSlice(self:getChild(fOBj, 5).NineSlice)
					self:skinObject("frame", {obj=fOBj, fType=ftype, kfs=true, fb=true, y1=0, y2=-2})
					for _, type in _G.pairs{"Player", "Friend"} do
						self:removeNineSlice(_G["AchievementFrameComparisonSummary" .. type].NineSlice)
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

				-- let AddOn skins know when when UI is skinned (used by AchieveIt skin)
				self.callbacks:Fire("AchievementUI_Skinned")
				-- remove all callbacks for this event
				self.callbacks.events["AchievementUI_Skinned"] = nil

				self:Unhook(this, "OnShow")
			end)
			self:checkShown(_G.AchievementFrame)

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

		if self:isAddOnLoaded("Quartz")
		or self:isAddOnLoaded("Dominos_Cast")
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
				self:skinObject("statusbar", {obj=cbFrame, fi=0, bg=self:getRegion(cbFrame, 1), nilFuncs=true})
			end
			-- adjust text and spark in Classic mode
			if not cbFrame.ignoreFramePositionManager then
				cbFrame.Text:SetPoint("TOP", 0, 2)
				cbFrame.Spark.offsetY = -1
			end
		end

		local function setLook(castBar, look)
			castBar.Border:SetAlpha(0)
			castBar.Flash:SetAllPoints()
			castBar.Flash:SetTexture(self.tFDIDs.w8x8)
			if look == "CLASSIC" then
				castBar.Text:SetPoint("TOP", 0, 2)
				castBar.Spark.offsetY = -1
			end
		end
		-- hook this to handle the CastingBar being attached to the Unitframe and then reset
		self:SecureHook("CastingBarFrame_SetLook", function(castBar, look)
			setLook(castBar, look)
		end)

	end

	aObj.blizzFrames[ftype].CharacterFrames = function(self)
		if not self.prdb.CharacterFrames or self.initialized.CharacterFrames then return end
		self.initialized.CharacterFrames = true

		-- skin tabs here, so they show correct textures when selected
		self:skinObject("tabs", {obj=_G.CharacterFrame, prefix=_G.CharacterFrame:GetName(), fType=ftype, lod=self.isTT and true})

		self:SecureHookScript(_G.CharacterFrame, "OnShow", function(this)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, x1=10, y1=-12, x2=-31, y2=74})

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.PaperDollFrame, "OnShow", function(this)
			self:keepFontStrings(this)
			self:makeMFRotatable(_G.CharacterModelFrame)
			_G.CharacterAttributesFrame:DisableDrawLayer("BACKGROUND")
			if self.isClsc then
				self:skinObject("dropdown", {obj=_G.PlayerTitleDropDown, fType=ftype, y1=5, y2=13})
				self:skinObject("dropdown", {obj=_G.PlayerStatFrameLeftDropDown, fType=ftype})
				self:skinObject("dropdown", {obj=_G.PlayerStatFrameRightDropDown, fType=ftype})
			end
			if self.modBtnBs then
				for i = 1, 5 do
					self:addButtonBorder{obj=_G["MagicResFrame" .. i], es=24, ofs=2, x1=-1, y2=-4, clr="grey"}
				end
			end
			for _, btn in _G.pairs{_G.PaperDollItemsFrame:GetChildren()} do
				-- handle non button children [ECS_StatsFrame]
				if btn:IsObjectType("Button") then
					if btn ~= _G.GearManagerToggleButton then
						btn:DisableDrawLayer("BACKGROUND")
						if btn.ignoreTexture then
							if self.modBtnBs then
								self:addButtonBorder{obj=btn, ibt=true, reParent={btn.ignoreTexture}, clr="grey"}
							end
						else
							btn:DisableDrawLayer("OVERLAY")
							btn:GetNormalTexture():SetTexture(nil)
							btn:GetPushedTexture():SetTexture(nil)
							if self.modBtnBs then
								self:addButtonBorder{obj=btn, reParent={self:getRegion(btn, 4)}, clr="grey"}
							end
						end
						if btn == _G.CharacterAmmoSlot then
							btn.icon = _G.CharacterAmmoSlotIconTexture
						end
						if self.modBtnBs then
							_G.PaperDollItemSlotButton_Update(btn)
						end
					else
						if self.modBtnBs then
							self:addButtonBorder{obj=btn, fType=ftype, x1=1, x2=-1, clr="grey"}
						end
					end
				end
			end
			self:SecureHook("PaperDollItemSlotButton_Update", function(btn)
				-- ignore buttons with no border
				if btn.sbb then
					if not btn.hasItem then
						self:clrBtnBdr(btn, "grey")
						btn.icon:SetTexture(nil)
					else
						btn.sbb:SetBackdropBorderColor(btn.icon:GetVertexColor())
					end
				end
			end)

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.PetPaperDollFrame, "OnShow", function(this)
			local function skinPetFrame()
				aObj:skinObject("statusbar", {obj=_G.PetPaperDollFrameExpBar, regions={1, 2}, fi=0})
				aObj:makeMFRotatable(_G.PetModelFrame)
				_G.PetAttributesFrame:DisableDrawLayer("BACKGROUND")
				if aObj.modBtns then
					aObj:skinStdButton{obj=_G.PetPaperDollCloseButton, fType=ftype}
				end
				if aObj.modBtnBs then
					aObj:addButtonBorder{obj=_G.PetPaperDollPetInfo, ofs=1, x2=0, clr="gold"}
					for i = 1, _G.NUM_PET_RESISTANCE_TYPES do
						aObj:addButtonBorder{obj=_G["PetMagicResFrame" .. i], es=24, ofs=2, y1=3, y2=-4, clr="grey"}
					end
				end
			end
			self:keepFontStrings(this)
			if self.isClscERA then
				skinPetFrame()
			else
				-- Top Tabs
				self:skinObject("tabs", {obj=this, prefix=this:GetName(), numTabs=3, fType=ftype, lod=self.isTT and true, offsets={x1=6, y1=-6, x2=-6, y2=0}})
				self:SecureHookScript(_G.PetPaperDollFramePetFrame, "OnShow", function(fObj)
					skinPetFrame()
					self:skinObject("frame", {obj=fObj, fType=ftype, fb=true, x1=12, y1=-65, x2=-33, y2=76})

					self:Unhook(fObj, "OnShow")
				end)
				self:checkShown(_G.PetPaperDollFramePetFrame)
				self:SecureHookScript(_G.PetPaperDollFrameCompanionFrame, "OnShow", function(fObj)
					self:removeRegions(_G.PetPaperDollFrameCompanionFrame, {1, 2})
					self:makeMFRotatable(_G.CompanionModelFrame)
					self:skinObject("frame", {obj=fObj, fType=ftype, fb=true, x1=12, y1=-65, x2=-33, y2=76})
					if self.modBtns then
						self:skinStdButton{obj=_G.CompanionSummonButton, fType=ftype}
					end
					if self.modBtnBs then
						for i = 1, _G.NUM_COMPANIONS_PER_PAGE do
							self:addButtonBorder{obj=_G["CompanionButton" .. i], fType=ftype, sft=true, clr="grey"}
						end
						self:addButtonBorder{obj=_G.CompanionPrevPageButton, ofs=-2, y1=-3, x2=-3}
						self:addButtonBorder{obj=_G.CompanionNextPageButton, ofs=-2, y1=-3, x2=-3}
						self:clrPNBtns("Companion")
						self:SecureHook("PetPaperDollFrame_SetCompanionPage", function(_)
							self:clrPNBtns("Companion")
						end)
					end

					self:Unhook(fObj, "OnShow")
				end)
				self:checkShown(_G.PetPaperDollFrameCompanionFrame)
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.ReputationFrame, "OnShow", function(this)
			self:keepFontStrings(this)
			local awc
			for i = 1, _G.NUM_FACTIONS_DISPLAYED do
				if self.modBtns then
					if self.isClscERA then
						self:skinExpandButton{obj=_G["ReputationHeader" .. i], fType=ftype, onSB=true}
						self.modUIBtns:checkTex{obj=_G["ReputationHeader" .. i]}
						self:skinObject("statusbar", {obj=_G["ReputationBar" .. i], regions={1, 2}, fi=0})
						awc = self:getRegion(_G["ReputationBar" .. i .. "AtWarCheck"], 1)
						awc:SetTexture(self.tFDIDs.cbSC)
						awc:SetTexCoord(0, 1, 0, 1)
						awc:SetSize(32, 32)
					else
						self:skinExpandButton{obj=_G["ReputationBar" .. i .. "ExpandOrCollapseButton"], fType=ftype, onSB=true}
						self.modUIBtns:checkTex{obj=_G["ReputationBar" .. i .. "ExpandOrCollapseButton"]}
						self:skinObject("statusbar", {obj=_G["ReputationBar" .. i .. "ReputationBar"], regions={3, 4}, fi=0})
						self:removeRegions(_G["ReputationBar" .. i], {1, 2, 3})
					end
				end
			end
			self:skinObject("slider", {obj=_G.ReputationListScrollFrame.ScrollBar, fType=ftype, rpTex="background"})
			self:skinObject("frame", {obj=_G.ReputationDetailFrame, fType=ftype, kfs=true, x1=6, y1=-6, x2=-6, y2=6})
			if self.modBtns then
				self:skinCloseButton{obj=_G.ReputationDetailCloseButton, fType=ftype}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=_G.ReputationDetailAtWarCheckBox, fType=ftype}
				self:skinCheckButton{obj=_G.ReputationDetailInactiveCheckBox, fType=ftype}
				self:skinCheckButton{obj=_G.ReputationDetailMainScreenCheckBox, fType=ftype}
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.SkillFrame, "OnShow", function(this)
			self:keepFontStrings(this)
			_G.SkillFrameExpandButtonFrame:DisableDrawLayer("BACKGROUND")
			for i = 1, _G.SKILLS_TO_DISPLAY do
				if self.modBtns then
					 self:skinExpandButton{obj=_G["SkillTypeLabel"  .. i], fType=ftype, onSB=true, minus=true}
				end
				_G["SkillRankFrame"  .. i .. "BorderNormal"]:SetTexture(nil)
				self:skinObject("statusbar", {obj=_G["SkillRankFrame"  .. i], fi=0, other={_G["SkillRankFrame"  .. i .. "FillBar"]}})
			end
			self:skinObject("slider", {obj=_G.SkillListScrollFrame.ScrollBar, fType=ftype, rpTex="artwork"})
			self:skinObject("slider", {obj=_G.SkillDetailScrollFrame.ScrollBar, fType=ftype, rpTex="artwork"})
			self:removeRegions(_G.SkillDetailStatusBar, {1})
			self:skinObject("statusbar", {obj=_G.SkillDetailStatusBar, fi=0, other={_G.SkillDetailStatusBarFillBar}})
			if self.modBtns then
				self:skinExpandButton{obj=_G.SkillFrameCollapseAllButton, fType=ftype, onSB=true, minus=true}
				self:skinStdButton{obj=_G.SkillFrameCancelButton, fType=ftype}
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=_G.SkillDetailStatusBarUnlearnButton, fType=ftype, ofs=-4, x1=6, y2=7, clr="grey"}
			end

			self:Unhook(this, "OnShow")
		end)

		if self.isClscERA then
			self:SecureHookScript(_G.HonorFrame, "OnShow", function(this)
				self:keepFontStrings(this)
				self:skinObject("statusbar", {obj=_G.HonorFrameProgressBar, fi=0})

				self:Unhook(this, "OnShow")
			end)
		else
			self:SecureHookScript(_G.PaperDollFrameItemFlyout, "OnShow", function(this)
				self:skinObject("frame", {obj=this.buttonFrame, fType=ftype, kfs=true, clr="gold", x2=4})
				if self.modBtnBs then
					self:SecureHook("PaperDollFrameItemFlyout_Show", function(_)
						for i = 1, #_G.PaperDollFrameItemFlyout.buttons do
							self:addButtonBorder{obj=_G.PaperDollFrameItemFlyout.buttons[i], fType=ftype, ibt=true, clr="grey"}
						end
					end)
				end

				self:Unhook(this, "OnShow")
			end)
			self:SecureHookScript(_G.GearManagerDialog, "OnShow", function(this)
				if self.modBtnBs then
					local btn
					for i = 1, _G.MAX_EQUIPMENT_SETS_PER_PLAYER do
						btn = _G["GearSetButton" .. i]
						btn:DisableDrawLayer("BACKGROUND")
						if self.modBtnBs then
							self:addButtonBorder{obj=btn, fType=ftype, clr="grey", ca=0.85}
						end
					end
				end
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ofs=-2 ,x1=3, x2=-1})
				if self.modBtns then
					self:skinCloseButton{obj=_G.GearManagerDialogClose, fType=ftype}
					self:skinStdButton{obj=_G.GearManagerDialogDeleteSet, fType=ftype, schk=true}
					self:skinStdButton{obj=_G.GearManagerDialogEquipSet, fType=ftype, schk=true}
					self:skinStdButton{obj=_G.GearManagerDialogSaveSet, fType=ftype, schk=true}
				end

				self:SecureHookScript(_G.GearManagerDialogPopup, "OnShow", function(fObj)
					self:skinObject("editbox", {obj=_G.GearManagerDialogPopupEditBox, fType=ftype})
					self:skinObject("slider", {obj=_G.GearManagerDialogPopupScrollFrame.ScrollBar, fType=ftype, rpTex="background"})
					self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, ofs=-4, x1=3})
					if self.modBtns then
						self:skinStdButton{obj=fObj.CancelButton}
						self:skinStdButton{obj=fObj.OkayButton}
						self:SecureHook("GearManagerDialogPopupOkay_Update", function()
							self:clrBtnBdr(fObj.OkayButton)
						end)
					end
					local bName
					for i = 1, _G.NUM_GEARSET_ICONS_SHOWN do
						bName = "GearManagerDialogPopupButton" .. i
						_G[bName]:DisableDrawLayer("BACKGROUND")
						if self.modBtnBs then
							self:addButtonBorder{obj=_G[bName], relTo=_G[bName .. "Icon"], clr="grey", ca=0.85}
						end
					end

					self:Unhook(fObj, "OnShow")
				end)

				self:Unhook(this, "OnShow")
			end)
		end

	end

	aObj.blizzFrames[ftype].ContainerFrames = function(self)
		if not self.prdb.ContainerFrames.skin or self.initialized.ContainerFrames then return end
		self.initialized.ContainerFrames = true

		local function skinBag(frame, _)
			aObj:skinObject("frame", {obj=frame, fType=ftype, kfs=true, cb=true, x1=8, y1=-4, x2=-3})
			-- resize and move the bag name to make it more readable
			local objName = frame:GetName()
			_G[objName .. "Name"]:SetWidth(137)
			aObj:moveObject{obj=_G[objName .. "Name"], x=-17}
			if aObj.modBtns then
				_G[objName .. "AddSlotsButton"]:DisableDrawLayer("OVERLAY")
				aObj:skinStdButton{obj=_G[objName .. "AddSlotsButton"], fType=ftype}
			end
			if aObj.modBtnBs then
				-- skin the item buttons
				local bo
				for i = 1, _G.MAX_CONTAINER_ITEMS do
					bo = _G[objName .. "Item" .. i]
					aObj:addButtonBorder{obj=bo, ibt=true, reParent={bo.JunkIcon, bo.UpgradeIcon, bo.flash, bo.NewItemTexture, bo.BattlepayItemTexture}}
				end
				-- update Button quality borders
				_G.ContainerFrame_Update(frame)
			end
		end
		self:SecureHook("ContainerFrame_GenerateFrame", function(fObj, id)
			-- skin the frame if required
			if not fObj.sf then
				skinBag(fObj, id)
			end
		end)

		if self.modBtns then
			self:SecureHookScript(_G.BagHelpBox, "OnShow", function(this)
				self:skinCloseButton{obj=this.CloseButton, fType=ftype, noSkin=true}

				self:Unhook(this, "OnShow")
			end)
		end

	end

	local function skinaTS(parent)
		if aObj:isAddOnLoaded("alaTradeSkill") then
			aObj:keepFontStrings(parent.frame.TextureBackground)
			parent.frame.TabFrame:ClearAllPoints()
			parent.frame.TabFrame:SetPoint("BOTTOM", parent, "TOP", 0, -13)
			aObj:skinObject("frame", {obj=parent.frame.TabFrame, fb=true})
			aObj:skinObject("frame", {obj=parent.frame.ProfitFrame, kfs=true, ofs=0})
			aObj:skinObject("frame", {obj=parent.frame.SetFrame, kfs=true, ofs=0, y1=2})
			aObj:skinObject("slider", {obj=parent.frame.SetFrame.PhaseSlider})
		end
	end
	aObj.blizzLoDFrames[ftype].CraftUI = function(self)
		if not self.prdb.CraftUI or self.initialized.CraftUI then return end
		self.initialized.CraftUI = true

		self:SecureHookScript(_G.CraftFrame, "OnShow", function(this)
			if self.isClsc then
				self:skinObject("dropdown", {obj=_G.CraftFrameFilterDropDown, fType=ftype})
				if self.modChkBtns then
					self:skinCheckButton{obj=_G.CraftFrameAvailableFilterCheckButton, fType=ftype}
				end
			end
			self:skinObject("statusbar", {obj=_G.CraftRankFrame, fi=0, bg=_G.CraftRankFrameBackground})
			_G.CraftRankFrameBorder:GetNormalTexture():SetTexture(nil)
			self:keepFontStrings(_G.CraftExpandButtonFrame)
			self:keepFontStrings(_G.CraftDetailScrollChildFrame)
			local x1, y1, x2, y2
			if self:isAddOnLoaded("Leatrix_Plus")
			and _G.LeaPlusDB["EnhanceProfessions"] == "On"
			then
				x1, y1, x2, y2 = 10, -11, -33, 49
			else
				x1, y1, x2, y2 = 10, -11, -31, 71
			end
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, x1=x1, y1=y1, x2=x2, y2=y2})
			if self.modBtnBs then
				self:addButtonBorder{obj=_G.CraftIcon, clr="gold"}
			end
			if not self:isAddOnLoaded("alaTradeSkill") then
				self:skinObject("slider", {obj=_G.CraftListScrollFrameScrollBar, fType=ftype, rpTex="background"})
				self:skinObject("slider", {obj=_G.CraftDetailScrollFrameScrollBar, fType=ftype, rpTex="background"})
				for i = 1, _G.MAX_CRAFT_REAGENTS do
					_G["CraftReagent" .. i].NameFrame:SetTexture(nil)
					if self.modBtnBs then
						self:addButtonBorder{obj=_G["CraftReagent" .. i], fType=ftype, libt=true}
					end
				end
				if self.modBtns then
					self:skinCloseButton{obj=_G.CraftFrameCloseButton, fType=ftype}
					self:skinExpandButton{obj=_G.CraftCollapseAllButton, fType=ftype, onSB=true}
					self:skinStdButton{obj=_G.CraftCreateButton, fType=ftype, schk=true}
					self:skinStdButton{obj=_G.CraftCancelButton, fType=ftype}
				end
			else
				skinaTS(this)
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].DressUpFrame = function(self)
		if not self.prdb.DressUpFrame or self.initialized.DressUpFrame then return end
		self.initialized.DressUpFrame = true

		if self:isAddOnLoaded("DressUp") then
			self.blizzFrames[ftype].DressUpFrame = nil
			return
		end

		self:SecureHookScript(_G.SideDressUpFrame, "OnShow", function(this)
			_G.SideDressUpModel.controlFrame:DisableDrawLayer("BACKGROUND") -- model controls background
			self:removeRegions(_G.SideDressUpModelCloseButton, {5}) -- corner texture
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, x1=1, y1=-3, x2=-2})
			if self.modBtns then
				self:skinStdButton{obj=_G.SideDressUpModelResetButton, fType=ftype}
				self:skinCloseButton{obj=_G.SideDressUpModelCloseButton, fType=ftype}
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.DressUpFrame, "OnShow", function(this)
			self:makeMFRotatable(_G.DressUpModelFrame)
			if self.prdb.DUTexture then
				self:removeRegions(this, {1, 2, 3 ,4, 5})
			else
				self:keepFontStrings(this)
			end
			self:skinObject("frame", {obj=this, fType=ftype, cb=true, x1=10, y1=-11, x2=-33, y2=71})
			if self.modBtns then
				self:skinStdButton{obj=_G.DressUpFrameCancelButton, fType=ftype}
				self:skinStdButton{obj=this.ResetButton, fType=ftype}
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].FriendsFrame = function(self)
		if not self.prdb.FriendsFrame or self.initialized.FriendsFrame then return end
		self.initialized.FriendsFrame = true

		self:SecureHookScript(_G.FriendsFrame, "OnShow", function(this)
			self:skinObject("dropdown", {obj=_G.FriendsDropDown, fType=ftype})
			self:skinObject("dropdown", {obj=_G.TravelPassDropDown, fType=ftype})
			self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, cb=true, x2=1, y2=self.isClscERA and -1 or -2})

			self:SecureHookScript(_G.FriendsTabHeader, "OnShow", function(fObj)
				_G.FriendsFrameBattlenetFrame:DisableDrawLayer("BACKGROUND")
				self:skinObject("frame", {obj=_G.FriendsFrameBattlenetFrame.BroadcastFrame.ScrollFrame, fType=ftype, kfs=true, fb=true, ofs=4})
				if self.modBtns then
					self:addButtonBorder{obj=_G.FriendsFrameBattlenetFrame.BroadcastButton, ofs=-2, x1=1, y1=-1}
					self:skinStdButton{obj=_G.FriendsFrameBattlenetFrame.BroadcastFrame.ScrollFrame.UpdateButton, fType=ftype}
					self:skinStdButton{obj=_G.FriendsFrameBattlenetFrame.BroadcastFrame.ScrollFrame.CancelButton, fType=ftype}
				end
				_G.FriendsFrameBattlenetFrame.BroadcastFrame:DisableDrawLayer("BACKGROUND")
				self:skinObject("frame", {obj=_G.FriendsFrameBattlenetFrame.BroadcastFrame, fType=ftype, ofs=-10})
				self:skinObject("frame", {obj=_G.FriendsFrameBattlenetFrame.UnavailableInfoFrame, fType=ftype})
				self:skinObject("dropdown", {obj=_G.FriendsFrameStatusDropDown, fType=ftype})
				_G.FriendsFrameStatusDropDownStatus:SetAlpha(1) -- display status icon
				self:skinObject("editbox", {obj=_G.FriendsFrameBroadcastInput, fType=ftype})
				_G.FriendsFrameBroadcastInputFill:SetTextColor(self.BT:GetRGB())
				-- Top Tabs
				self:skinObject("tabs", {obj=fObj, prefix=fObj:GetName(), numTabs=2, fType=ftype, lod=self.isTT and true, upwards=true, offsets={x1=0, y1=-5, x2=0, y2=-4}})
				_G.RaiseFrameLevel(fObj)

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(_G.FriendsTabHeader)

			self:SecureHookScript(_G.FriendsListFrame, "OnShow", function(fObj)
				_G.FriendsFrameFriendsScrollFrame.PendingInvitesHeaderButton.BG:SetTexture(nil)
				self:skinObject("slider", {obj=_G.FriendsFrameFriendsScrollFrame.scrollBar, fType=ftype, rpTex="background"})
				local btn
				for i = 1, _G.FRIENDS_FRIENDS_TO_DISPLAY do
					btn = _G["FriendsFrameFriendsScrollFrameButton" .. i]
					btn.background:SetAlpha(0)
					if self.modBtnBs then
						self:addButtonBorder{obj=btn, relTo=btn.gameIcon, ofs=0, clr="grey"}
						self:SecureHook(btn.gameIcon, "Show", function(bObj)
							bObj:GetParent().sbb:Show()
						end)
						self:SecureHook(btn.gameIcon, "Hide", function(bObj)
							bObj:GetParent().sbb:Hide()
						end)
						self:SecureHook(btn.gameIcon, "SetShown", function(bObj, show)
							bObj:GetParent().sbb:SetShown(bObj, show)
						end)
						btn.sbb:SetShown(btn.gameIcon:IsShown())
						self:addButtonBorder{obj=btn.travelPassButton, fType=ftype, schk=true, ofs=0, y1=3, y2=-2}
						self:addButtonBorder{obj=btn.summonButton, fType=ftype, schk=true}
					end
				end
				self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, fb=true, ofs=0, y1=-81, x2=-1, y2=self.isClscERA and 1 or 0})
				if self.modBtns then
					self:skinStdButton{obj=_G.FriendsFrameAddFriendButton, fType=ftype, x1=1}
					self:skinStdButton{obj=_G.FriendsFrameSendMessageButton, fType=ftype}
					self:skinStdButton{obj=self:getChild(fObj.RIDWarning, 1), fType=ftype} -- unnamed parent frame
					for invite in _G.FriendsFrameFriendsScrollFrame.invitePool:EnumerateActive() do
						self:skinStdButton{obj=invite.DeclineButton, fType=ftype}
						self:skinStdButton{obj=invite.AcceptButton, fType=ftype}
					end
				end
				if self.modBtnBs then
					self:addButtonBorder{obj=_G.FriendsFrameFriendsScrollFrame.PendingInvitesHeaderButton}
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(_G.FriendsListFrame)

			self:SecureHookScript(_G.IgnoreListFrame, "OnShow", function(fObj)
				fObj:DisableDrawLayer("BACKGROUND")
				self:skinObject("slider", {obj=_G.FriendsFrameIgnoreScrollFrame.ScrollBar, fType=ftype})
				self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, fb=true, ofs=0, y1=-81, x2=-1})
				if self.modBtns then
					self:skinStdButton{obj=_G.FriendsFrameIgnorePlayerButton, fType=ftype, x1=1}
					self:skinStdButton{obj=_G.FriendsFrameUnsquelchButton, fType=ftype}
					self:SecureHook("IgnoreList_Update", function()
						self:clrBtnBdr(_G.FriendsFrameUnsquelchButton)
					end)
				end

				self:Unhook(fObj, "OnShow")
			end)

			self:SecureHookScript(_G.WhoFrame, "OnShow", function(fObj)
				self:removeInset(_G.WhoFrameListInset)
				for i = 1, 4 do
					_G["WhoFrameColumnHeader" .. i]:DisableDrawLayer("BACKGROUND")
					if i ~= 2 then -- column 2 is really a dropdown
						self:skinObject("frame", {obj=_G["WhoFrameColumnHeader" .. i], fType=ftype, ofs=0})
					end
				end
				self:moveObject{obj=_G.WhoFrameColumnHeader4, x=4}
				self:skinObject("dropdown", {obj=_G.WhoFrameDropDown, fType=ftype})
				self:moveObject{obj=_G.WhoFrameDropDown, y=1}
				self:removeInset(_G.WhoFrameEditBoxInset)
				self:skinObject("editbox", {obj=_G.WhoFrameEditBox, fType=ftype})
				self:adjHeight{obj=_G.WhoFrameEditBox, adj=-10}
				if not self.isElvUI then
					_G.WhoFrameEditBox:SetWidth(_G.WhoFrameEditBox:GetWidth() + 24)
					self:moveObject{obj=_G.WhoFrameEditBox, x=11, y=6}
				end
				self:skinObject("slider", {obj=_G.WhoListScrollFrame.ScrollBar, fType=ftype, rpTex="background"})
				if self.modBtns then
					self:skinStdButton{obj=_G.WhoFrameGroupInviteButton, fType=ftype}
					self:skinStdButton{obj=_G.WhoFrameAddFriendButton, fType=ftype}
					self:skinStdButton{obj=_G.WhoFrameWhoButton, fType=ftype}
					self:SecureHook("WhoList_Update", function()
						self:clrBtnBdr(_G.WhoFrameGroupInviteButton)
						self:clrBtnBdr(_G.WhoFrameAddFriendButton)
					end)
				end

				self:Unhook(fObj, "OnShow")
			end)

			if self.modBtns then
				self:SecureHook("GuildStatus_Update", function()
					if _G.GuildFrame.sf then
						self:clrBtnBdr(_G.GuildFrameControlButton)
						self:clrBtnBdr(_G.GuildFrameAddMemberButton)
					end
					if _G.GuildMemberDetailFrame.sf then
						self:clrBtnBdr(_G.GuildMemberRemoveButton)
						self:clrBtnBdr(_G.GuildMemberGroupInviteButton)
						self:clrBtnBdr(_G.GuildFramePromoteButton)
						self:clrBtnBdr(_G.GuildFrameDemoteButton)
					end
				end)
			end
			self:SecureHookScript(_G.GuildFrame, "OnShow", function(fObj)
				self:keepFontStrings(fObj)
				_G.GuildFrameLFGFrame:DisableDrawLayer("BACKGROUND")
				for i = 1, 4 do
					_G["GuildFrameColumnHeader" .. i]:DisableDrawLayer("BACKGROUND")
					_G["GuildFrameGuildStatusColumnHeader" .. i]:DisableDrawLayer("BACKGROUND")
					self:skinObject("frame", {obj=_G["GuildFrameColumnHeader" .. i], fType=ftype, ofs=0})
					self:skinObject("frame", {obj=_G["GuildFrameGuildStatusColumnHeader" .. i], fType=ftype, ofs=0})
				end
				self:skinObject("slider", {obj=_G.GuildListScrollFrame.ScrollBar, fType=ftype, rpTex="background"})
				if self.modBtns then
					self:skinStdButton{obj=_G.GuildFrameImpeachButton, fType=ftype}
					self:skinStdButton{obj=_G.GuildFrameControlButton, fType=ftype, schk=true}
					self:skinStdButton{obj=_G.GuildFrameAddMemberButton, fType=ftype, schk=true}
					self:skinStdButton{obj=_G.GuildFrameGuildInformationButton, fType=ftype}
				end
				if self.modBtnBs then
					self:addButtonBorder{obj=_G.GuildFrameGuildListToggleButton, ofs=-2, clr="gold"}
				end
				if self.modChkBtns then
					self:skinCheckButton{obj=_G.GuildFrameLFGButton, fType=ftype}
				end

				self:Unhook(fObj, "OnShow")
			end)

			self:SecureHookScript(_G.GuildControlPopupFrame, "OnShow", function(fObj)
				self:skinObject("dropdown", {obj=_G.GuildControlPopupFrameDropDown, fType=ftype})
				_G.UIDropDownMenu_SetButtonWidth(_G.GuildControlPopupFrameDropDown, 24)
				self:skinObject("editbox", {obj=_G.GuildControlPopupFrameEditBox, fType=ftype, regions={3, 4}, y1=-4, y2=4})
				if self.isClsc then
					self:skinObject("editbox", {obj=_G.GuildControlWithdrawGoldEditBox, fType=ftype, y1=-4, y2=4})
					self:skinObject("editbox", {obj=_G.GuildControlWithdrawItemsEditBox, fType=ftype, y1=-4, y2=4})
					for i = 1, 6 do
						self:keepFontStrings(_G["GuildBankTabPermissionsTab" .. i])
					end
					self:skinObject("frame", {obj=_G.GuildControlPopupFrameTabPermissions, fType=ftype, fb=true})
					if self.modBtns then
						self:skinCheckButton{obj=_G.GuildControlTabPermissionsViewTab, fType=ftype}
						self:skinCheckButton{obj=_G.GuildControlTabPermissionsDepositItems, fType=ftype}
						self:skinCheckButton{obj=_G.GuildControlTabPermissionsUpdateText, fType=ftype}
					end
					if self.modChkBtns then
						self:skinCheckButton{obj=_G.GuildControlPopupFrameCheckbox15, fType=ftype} -- Repair
						self:skinCheckButton{obj=_G.GuildControlPopupFrameCheckbox16, fType=ftype} -- Withdraw Gold
					end
					self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, ofs=-4, y2=25})
				else
					self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, ofs=-4})
				end
				if self.modBtns then
					self:skinStdButton{obj=_G.GuildControlPopupFrameCancelButton, fType=ftype}
					self:skinStdButton{obj=_G.GuildControlPopupAcceptButton, fType=ftype, schk=true}
					self:skinExpandButton{obj=_G.GuildControlPopupFrameAddRankButton, fType=ftype, plus=true, ofs=0}
					self:skinExpandButton{obj=_G.GuildControlPopupFrameRemoveRankButton, fType=ftype, ofs=0}
					self:SecureHook("GuildControlPopupFrameRemoveRankButton_OnUpdate", function()
						self:clrBtnBdr(_G.GuildControlPopupFrameRemoveRankButton)
					end)
				end
				if self.modChkBtns then
					for i = 1, _G.GUILD_NUM_RANK_FLAGS do
						self:skinCheckButton{obj=_G["GuildControlPopupFrameCheckbox" .. i], fType=ftype}
					end
				end

				self:Unhook(fObj, "OnShow")
			end)

			self:SecureHookScript(_G.GuildInfoFrame, "OnShow", function(fObj)
				self:moveObject{obj=fObj, y=-2}
				self:skinObject("slider", {obj=_G.GuildInfoFrameScrollFrame.ScrollBar, fType=ftype, rpTex="artwork"})
				self:skinObject("frame", {obj=_G.GuildInfoTextBackground, fb=true})
				self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, ofs=-2})
				if self.modBtns then
					self:skinCloseButton{obj=_G.GuildInfoCloseButton, fType=ftype}
					self:skinStdButton{obj=_G.GuildInfoSaveButton, fType=ftype}
					self:skinStdButton{obj=_G.GuildInfoCancelButton, fType=ftype}
					self:skinStdButton{obj=_G.GuildInfoGuildEventButton, fType=ftype}
				end

				self:Unhook(fObj, "OnShow")
			end)

			self:SecureHookScript(_G.GuildMemberDetailFrame, "OnShow", function(fObj)
				fObj:DisableDrawLayer("OVERLAY")
				self:skinObject("frame", {obj=_G.GuildMemberNoteBackground, fType=ftype, fb=true})
				self:skinObject("frame", {obj=_G.GuildMemberOfficerNoteBackground, fType=ftype, fb=true})
				self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, ofs=0})
				if self.modBtns then
					self:skinCloseButton{obj=_G.GuildMemberDetailCloseButton, fType=ftype}
					self:skinStdButton{obj=_G.GuildMemberRemoveButton, fType=ftype, schk=true}
					self:skinStdButton{obj=_G.GuildMemberGroupInviteButton, fType=ftype, schk=true}
					self:skinStdButton{obj=_G.GuildFramePromoteButton, fType=ftype, schk=true}
					self:skinStdButton{obj=_G.GuildFrameDemoteButton, fType=ftype, schk=true}
				end

				self:Unhook(fObj, "OnShow")
			end)

			if self.isClsc then
				self:SecureHookScript(_G.GuildEventLogFrame, "OnShow", function(fObj)
					self:skinObject("frame", {obj=_G.GuildEventFrame, fType=ftype, kfs=true, fb=true, ofs=0})
					self:skinObject("slider", {obj=_G.GuildEventLogScrollFrame.ScrollBar, fType=ftype})
					self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, rns=true, ofs=-6})
					if self.modBtns then
						self:skinCloseButton{obj=_G.GuildEventLogCloseButton, fType=ftype}
						self:skinStdButton{obj=_G.GuildEventLogCancelButton, fType=ftype}
					end

					self:Unhook(fObj, "OnShow")
				end)
			end

			-- tooltip
			_G.C_Timer.After(0.1, function()
				self:add2Table(self.ttList, _G.FriendsTooltip)
			end)

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.AddFriendFrame, "OnShow", function(this)
			self:skinObject("editbox", {obj=_G.AddFriendNameEditBox, fType=ftype})
			self:skinObject("slider", {obj=_G.AddFriendNoteFrameScrollFrame.ScrollBar, fType=ftype})
			self:skinObject("frame", {obj=_G.AddFriendNoteFrame, fType=ftype, kfs=true, fb=true})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true})
			if self.modBtns then
				self:skinStdButton{obj=_G.AddFriendInfoFrameContinueButton, fType=ftype}
				self:skinStdButton{obj=_G.AddFriendEntryFrameAcceptButton, fType=ftype, clr="disabled"}
				self:skinStdButton{obj=_G.AddFriendEntryFrameCancelButton, fType=ftype}
				self:SecureHookScript(_G.AddFriendNameEditBox, "OnTextChanged", function(_)
					self:clrBtnBdr(_G.AddFriendEntryFrameAcceptButton)
				end)
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.FriendsFriendsFrame, "OnShow", function(this)
			self:skinObject("dropdown", {obj=_G.FriendsFriendsFrameDropDown, fType=ftype})
			self:skinObject("frame", {obj=_G.FriendsFriendsList, fType=ftype, fb=true})
			self:skinObject("slider", {obj=_G.FriendsFriendsScrollFrame.ScrollBar, fType=ftype})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true})
			if self.modBtns then
				self:skinStdButton{obj=_G.FriendsFriendsSendRequestButton, fType=ftype}
				self:skinStdButton{obj=_G.FriendsFriendsCloseButton, fType=ftype}
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.BattleTagInviteFrame, "OnShow", function(this)
			self:skinObject("frame", {obj=this, fType=ftype})
			if self.modBtns then
				self:skinStdButton{obj=self:getChild(this, 1), fType=ftype} -- Send Request
				self:skinStdButton{obj=self:getChild(this, 2), fType=ftype} -- Cancel
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.ChannelFrame, "OnShow", function(this)
			self:removeInset(this.LeftInset)
			self:removeInset(this.RightInset)
			self:skinObject("slider", {obj=this.ChannelList.ScrollBar, fType=ftype})
			self:skinObject("slider", {obj=this.ChannelRoster.ScrollFrame.scrollBar, fType=ftype})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, cb=true, x1=-5, x2=1, y2=-1})
			-- Create Channel Popup
			self:skinObject("editbox", {obj=_G.CreateChannelPopup.Name, fType=ftype, y1=4, y2=-4})
			self:skinObject("editbox", {obj=_G.CreateChannelPopup.Password, fType=ftype, y1=4, y2=-4})
			self:skinObject("frame", {obj=_G.CreateChannelPopup, fType=ftype, kfs=true, cb=true})
			if self.modBtns then
				self:skinStdButton{obj=_G.CreateChannelPopup.OKButton, fType=ftype}
				self:skinStdButton{obj=_G.CreateChannelPopup.CancelButton, fType=ftype}
				self:skinStdButton{obj=this.NewButton, fType=ftype}
				self:skinStdButton{obj=this.SettingsButton, fType=ftype}
				self:skinCloseButton{obj=this.Tutorial.CloseButton, fType=ftype, noSkin=true}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=_G.CreateChannelPopup.UseVoiceChat, fType=ftype}
			end

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
			self:skinObject("frame", {obj=this, fType=ftype, cbns=true})
			if self.modBtns then
				self:skinStdButton{obj=this.AcceptButton, fType=ftype}
			end
			self:hookSocialToastFuncs(this)

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.VoiceChatChannelActivatedNotification, "OnShow", function(this)
			self:skinObject("frame", {obj=this, fType=ftype, cbns=true})
			self:hookSocialToastFuncs(this)

			self:Unhook(this, "OnShow")
		end)

	end

	if aObj.isClsc then
		aObj.blizzLoDFrames[ftype].GlyphUI = function(self)
			if not self.prdb.GlyphUI or self.initialized.GlyphUI then return end
			self.initialized.GlyphUI = true

			self:SecureHookScript(_G.GlyphFrame, "OnShow", function(this)
				self:removeRegions(this, {1})
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, x1=10, y1=-12, x2=-31, y2=75})

				self:Unhook(this, "OnShow")
			end)
			self:checkShown(_G.GlyphFrame)

		end
	end

	local function colourBtn(btn)
		if btn.sbb then
			btn.sbb:SetBackdropBorderColor(_G[btn:GetName() .. "Slot"]:GetVertexColor())
		end
	end
	local function skinTalentBtns(frame)
		local fName = frame:GetName()
		local btn
		for i = 1, _G.MAX_NUM_TALENTS do
			btn = _G[fName .. "Talent" .. i]
			_G[fName .. "Talent" .. i .. "Slot"]:SetTexture(nil)
			_G[fName .. "Talent" .. i .. "RankBorder"]:SetTexture(nil)
			aObj:addButtonBorder{obj=btn, ibt=true, reParent={_G[fName .. "Talent" .. i .. "Rank"]}}
			colourBtn(btn)
		end
		local funcName
		if aObj.isClsc then
			funcName = "TalentFrame_Update"
		else
			funcName = "PlayerTalentFrame_Update"
		end
		if not aObj:IsHooked(funcName) then
			aObj:SecureHook(funcName, function(fObj)
				local fObjName = fObj and fObj:GetName() or "PlayerTalentFrame"
				for i = 1, _G.MAX_NUM_TALENTS do
					colourBtn(_G[fObjName .. "Talent" .. i])
				end
			end)
		end
	end
	aObj.blizzLoDFrames[ftype].InspectUI = function(self)
		if not self.prdb.InspectUI or self.initialized.InspectUI then return end
		self.initialized.InspectUI = true

		self:SecureHookScript(_G.InspectFrame, "OnShow", function(this)
			self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, x1=10, y1=-12, x2=-31, y2=74})

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.InspectPaperDollFrame, "OnShow", function(this)
			_G.InspectModelFrame:DisableDrawLayer("BACKGROUND")
			_G.InspectModelFrame:DisableDrawLayer("BORDER")
			_G.InspectModelFrame:DisableDrawLayer("OVERLAY")
			self:makeMFRotatable(_G.InspectModelFrame)
			this:DisableDrawLayer("BORDER")
			for _, btn in _G.ipairs{_G.InspectPaperDollItemsFrame:GetChildren()} do
				btn:DisableDrawLayer("BACKGROUND")
				if self.modBtnBs then
					self:addButtonBorder{obj=btn, ibt=true, clr="grey"}
				end
			end
			if self.modBtnBs then
				self:SecureHook("InspectPaperDollItemSlotButton_Update", function(btn)
					if not btn.hasItem then
						self:clrBtnBdr(btn, "grey")
						btn.icon:SetTexture(nil)
					end
				end)
			end

			self:Unhook(this, "OnShow")
		end)

		if self.isClscERA then
			self:SecureHookScript(_G.InspectHonorFrame, "OnShow", function(this)
				self:removeRegions(this, {1, 2, 3, 4, 5, 6, 7, 8})

				self:Unhook(this, "OnShow")
			end)
		else
			self:SecureHookScript(_G.InspectPVPFrame, "OnShow", function(this)
				self:keepFontStrings(this)
				-- TODO: skin PVPTeam buttons

				self:Unhook(this, "OnShow")
			end)
			self:SecureHookScript(_G.InspectTalentFrame, "OnShow", function(this)
				this:DisableDrawLayer("BACKGROUND")
				this:DisableDrawLayer("BORDER")
				-- Top Tabs
				self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true, offsets={x1=4, y1=-4, x2=-4, y2=-1}})
				_G.InspectTalentFramePointsBar:DisableDrawLayer("BACKGROUND")
				_G.InspectTalentFramePointsBar:DisableDrawLayer("BORDER")
				self:skinObject("frame", {obj=_G.InspectTalentFrameScrollFrame, fType=ftype, kfs=true, fb=true, x1=-11, y1=10, x2=32, y2=-5})
				self:skinObject("slider", {obj=_G.InspectTalentFrameScrollFrame.ScrollBar, fType=ftype, rpTex="artwork"})
				if self.modBtns then
					self:skinCloseButton{obj=_G.InspectTalentFrameCloseButton, fType=ftype}
				end
				if self.modBtnBs then
					skinTalentBtns(this)
				end

				self:Unhook(this, "OnShow")
			end)
		end

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
			local fName = frame:GetName()
			_G[fName .. "SlotTexture"]:SetTexture(nil)
			_G[fName .. "NameFrame"]:SetTexture(nil)
			_G[fName .. "Corner"]:SetAlpha(0)
			frame.Timer:DisableDrawLayer("ARTWORK")
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=frame, relTo=frame.Icon}
			end
			aObj:skinObject("statusbar", {obj=frame.Timer, fi=0, bg=frame.Timer.Background})
			-- hook this to show the Timer
			aObj:secureHook(frame, "Show", function(this)
				this.Timer:SetFrameLevel(this:GetFrameLevel() + 1)
			end)

			frame:SetScale(aObj.prdb.LootFrames.size ~= 1 and 0.75 or 1)
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

	end

	aObj.blizzFrames[ftype].SpellBookFrame = function(self)
		if not self.prdb.SpellBookFrame or self.initialized.SpellBookFrame then return end
		self.initialized.SpellBookFrame = true

		self:SecureHookScript(_G.SpellBookFrame, "OnShow", function(this)
			this.numTabs = 3
			-- Side Tabs
			self:skinObject("tabs", {obj=this, prefix=this:GetName(), suffix="Button", fType=ftype, lod=self.isTT and true, offsets={x1=13, y1=-14, x2=-13, y2=16}, regions={1, 3}, track=false})
			if self.isTT then
				local function setTab(bookType)
					local tab
					for i = 1, this.numTabs do
						tab = _G["SpellBookFrameTabButton" .. i]
						if tab.bookType == bookType then
							self:setActiveTab(tab.sf)
						else
							self:setInactiveTab(tab.sf)
						end
					end
				end
				-- hook to handle tabs
				self:SecureHook("ToggleSpellBook", function(bookType)
					setTab(bookType)
				end)
				-- set correct tab
				setTab(this.bookType)
			end
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, x1=10, y1=-12, x2=-31, y2=73})
			if self.modBtns then
				self:skinCloseButton{obj=_G.SpellBookCloseButton, fType=ftype}
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=_G.SpellBookPrevPageButton, ofs=-2, y1=-3, x2=-3}
				self:addButtonBorder{obj=_G.SpellBookNextPageButton, ofs=-2, y1=-3, x2=-3}
				self:clrPNBtns("SpellBook")
				self:SecureHook("SpellBookFrame_UpdatePages", function()
					self:clrPNBtns("SpellBook")
				end)
			end
			if not self.isRtl then
				if self.modChkBtns then
					self:skinCheckButton{obj=_G.ShowAllSpellRanksCheckBox, fType=ftype}
				end
			end
			-- Spellbook Panel
			local function updBtn(btn)
				-- handle in combat
				if _G.InCombatLockdown() then
				    aObj:add2Table(aObj.oocTab, {updBtn, {btn}})
				    return
				end
				if aObj.modBtnBs
				and btn.sbb -- allow for not skinned during combat
				then
					if not btn:IsEnabled() then
						btn.sbb:Hide()
					else
						btn.sbb:Show()
					end
					aObj:clrBtnBdr(btn)
				end
				local spellString, subSpellString = _G[btn:GetName() .. "SpellName"], _G[btn:GetName() .. "SubSpellName"]
				if _G[btn:GetName() .. "IconTexture"]:IsDesaturated() then -- player level too low, see Trainer, or offSpec
					spellString:SetTextColor(_G.DISABLED_FONT_COLOR:GetRGB())
					subSpellString:SetTextColor(_G.DISABLED_FONT_COLOR:GetRGB())
					btn.RequiredLevelString:SetTextColor(_G.DISABLED_FONT_COLOR:GetRGB())
					btn.SeeTrainerString:SetTextColor(_G.DISABLED_FONT_COLOR:GetRGB())
				else
					spellString:SetTextColor(aObj.HT:GetRGB())
					subSpellString:SetTextColor(aObj.BT:GetRGB())
				end
			end
			_G.SpellBookPageText:SetTextColor(self.BT:GetRGB())
			local btn
			for i = 1, _G.SPELLS_PER_PAGE do
				btn = _G["SpellButton" .. i]
				btn:DisableDrawLayer("BACKGROUND")
				btn:GetNormalTexture():SetTexture(nil)
				if self.modBtnBs then
					self:addButtonBorder{obj=btn, sft=true, reParent={_G["SpellButton" .. i .. "AutoCastable"]}}
				end
				updBtn(btn)
			end
			-- hook self to change text colour as required
			self:SecureHook("SpellButton_UpdateButton", function(splBtn)
				updBtn(splBtn)
			end)
			-- Tabs (side)
			for i = 1, _G.MAX_SKILLLINE_TABS do
				self:removeRegions(_G["SpellBookSkillLineTab" .. i], {1}) -- N.B. other regions are icon and highlight
				if self.modBtnBs then
					self:addButtonBorder{obj=_G["SpellBookSkillLineTab" .. i]}
				end
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzLoDFrames[ftype].TalentUI = function(self)
		if not self.prdb.TalentUI or self.initialized.TalentUI then return end
		self.initialized.TalentUI = true

		self:SecureHookScript(_G.PlayerTalentFrame, "OnShow", function(this)
			local fName = this:GetName()
			self:moveObject{obj=_G.PlayerTalentFrameTitleText, y=-2}
			if self.isClscERA then
				_G.PlayerTalentFrameRoleButton:SetNormalTexture(self.tFDIDs.lfgIR)
				_G.PlayerTalentFrameRoleButton.cover:SetTexture(self.tFDIDs.lfgIR)
			end
			self:skinObject("tabs", {obj=this, prefix=fName, fType=ftype, lod=self.isTT and true})
			self:skinObject("slider", {obj=_G[fName .. 'ScrollFrameScrollBar'], fType=ftype, rpTex="artwork"})
			-- keep background Texture
			self:skinObject("frame", {obj=this, fType=ftype, cb=true, x1=10, y1=-12, x2=-31, y2=74})
			self:removeRegions(this, {1, 3, 4, 5, 6})
			self:keepFontStrings(_G.PlayerTalentFramePointsBar)
			_G.PlayerTalentFramePreviewBar:DisableDrawLayer("BORDER")
			_G.PlayerTalentFramePreviewBarFiller:DisableDrawLayer("BACKGROUND")
			if self.modBtns then
				self:skinStdButton{obj=_G.PlayerTalentFrameResetButton, fType=ftype, schk=true}
				self:skinStdButton{obj=_G.PlayerTalentFrameLearnButton, fType=ftype, schk=true}
			end
			for i = 1, 3 do
				self:removeRegions(_G["PlayerSpecTab" .. i], {1}) -- N.B. other regions are icon and highlight
				if self.modBtnBs then
					self:addButtonBorder{obj=_G["PlayerSpecTab" .. i]}
				end
			end
			if self.modBtnBs then
				skinTalentBtns(this)
			end

			self:Unhook(this, "OnShow")
		end)

	end

	if aObj.isClsc then
		aObj.blizzFrames[ftype].TokenUI = function(self)
			if not self.prdb.TokenUI or self.initialized.TokenUI then return end
			self.initialized.TokenUI = true

			self:SecureHookScript(_G.TokenFrame, "OnShow", function(this)
				self:keepFontStrings(this)
				self:skinObject("slider", {obj=_G.TokenFrameContainerScrollBar, fType=ftype, rpTex="background"})
				self:getChild(this, 4):Hide() -- CloseButton
				if self.modBtns then
					self:skinStdButton{obj=_G.TokenFrameCancelButton, fType=ftype}
				end
				for i = 1, #_G.TokenFrameContainer.buttons do
					_G.TokenFrameContainer.buttons[i].categoryLeft:SetTexture(nil)
					_G.TokenFrameContainer.buttons[i].categoryRight:SetTexture(nil)
				end

				self:Unhook(this, "OnShow")
			end)

			self:SecureHookScript(_G.TokenFramePopup, "OnShow", function(this)
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, ofs=-6})
				if self.modChkBtns then
					self:skinCheckButton{obj=_G.TokenFramePopupInactiveCheckBox, fType=ftype}
					self:skinCheckButton{obj=_G.TokenFramePopupBackpackCheckBox, fType=ftype}
				end

				self:Unhook(this, "OnShow")
			end)

			self:SecureHookScript(_G.BackpackTokenFrame, "OnShow", function(this)
				this:DisableDrawLayer("BACKGROUND")

				self:Unhook(this, "OnShow")
			end)

		end
	end

	aObj.blizzLoDFrames[ftype].TradeSkillUI = function(self)
		if not self.prdb.TradeSkillUI or self.initialized.TradeSkillUI then return end
		self.initialized.TradeSkillUI = true

		self:SecureHookScript(_G.TradeSkillFrame, "OnShow", function(this)
			if self.isClsc then
				if self.modChkBtns then
					self:skinCheckButton{obj=_G.TradeSkillFrameAvailableFilterCheckButton, fType=ftype}
				end
				self:skinObject("editbox", {obj=_G.TradeSkillFrameEditBox, fType=ftype})
			end
			self:skinObject("statusbar", {obj=_G.TradeSkillRankFrame, fi=0, bg=_G.TradeSkillRankFrameBackground})
			if self.isClscERA then
				_G.TradeSkillRankFrameBorder:GetNormalTexture():SetTexture(nil)
			else
				_G.TradeSkillRankFrameBorder:SetTexture(nil)
			end
			self:keepFontStrings(_G.TradeSkillExpandButtonFrame)
			self:keepFontStrings(_G.TradeSkillDetailScrollChildFrame)
			local btnName
			for i = 1, _G.MAX_TRADE_SKILL_REAGENTS do
				btnName = "TradeSkillReagent" .. i
				_G[btnName .. "NameFrame"]:SetTexture(nil)
				if self.modBtnBs then
					 self:addButtonBorder{obj=_G[btnName], libt=true, clr="grey"}
				end
			end
			self:skinObject("editbox", {obj=_G.TradeSkillInputBox, fType=ftype})
			if self.modBtnBs then
				self:addButtonBorder{obj=_G.TradeSkillSkillIcon, clr="gold"}
			end
			local x1, y1, x2, y2
			if self:isAddOnLoaded("Leatrix_Plus")
			and _G.LeaPlusDB["EnhanceProfessions"] == "On"
			then
				x1, y1, x2, y2 = 10, -11, -33, 49
			else
				x1, y1, x2, y2 = 10, -11, -32, 70
			end
			if not self:isAddOnLoaded("alaTradeSkill") then
				self:skinObject("dropdown", {obj=_G.TradeSkillInvSlotDropDown, fType=ftype})
				self:skinObject("dropdown", {obj=_G.TradeSkillSubClassDropDown, fType=ftype})
				self:skinObject("slider", {obj=_G.TradeSkillListScrollFrame.ScrollBar, fType=ftype, rpTex="background"})
				self:skinObject("slider", {obj=_G.TradeSkillDetailScrollFrame.ScrollBar, fType=ftype, rpTex="background"})
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, x1=x1, y1=y1, x2=x2, y2=y2})
				if self.modBtns then
					self:skinExpandButton{obj=_G.TradeSkillCollapseAllButton, fType=ftype, onSB=true}
					for i = 1, _G.TRADE_SKILLS_DISPLAYED do
						self:skinExpandButton{obj=_G["TradeSkillSkill" .. i], onSB=true}
						self:checkTex{obj=_G["TradeSkillSkill" .. i]}
					end
					self:SecureHook("TradeSkillFrame_Update", function()
						for i = 1, _G.TRADE_SKILLS_DISPLAYED do
							self:checkTex{obj=_G["TradeSkillSkill" .. i]}
						end
					end)
					self:skinStdButton{obj=_G.TradeSkillCreateAllButton, fType=ftype, ofs=0}
					self:skinStdButton{obj=_G.TradeSkillCreateButton, fType=ftype, ofs=0}
					self:skinStdButton{obj=_G.TradeSkillCancelButton, fType=ftype, ofs=0}
					self:SecureHook("TradeSkillFrame_SetSelection", function(_)
						self:clrBtnBdr(_G.TradeSkillCreateButton)
						self:clrBtnBdr(_G.TradeSkillCreateAllButton)
					end)
				end
				if self.modBtnBs then
					self:addButtonBorder{obj=_G.TradeSkillDecrementButton, ofs=0, clr="gold"}
					self:addButtonBorder{obj=_G.TradeSkillIncrementButton, ofs=0, clr="gold"}
				end
			else
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, x1=4, y1=y1, x2=x2, y2=y2})
				skinaTS(this)
			end

			self:Unhook(this, "OnShow")
		end)

	end

	if aObj.isClsc then
		aObj.blizzFrames[ftype].WatchFrame = function(self)
			if not self.prdb.WatchFrame or self.initialized.WatchFrame then return end
			self.initialized.WatchFrame = true

			if self.modBtnBs then
				self:addButtonBorder{obj=_G.WatchFrameCollapseExpandButton, es=12, ofs=0, x1=-1}
				local function skinQuestBtns()
					local bName
					for i = 1, _G.WATCHFRAME_NUM_ITEMS do
						bName = "WatchFrameItem" .. i
						self:addButtonBorder{obj=_G[bName], fType=ftype, reParent={_G[bName .. "HotKey"], _G[bName .. "Count"], _G[bName .. "Stock"]}, clr="grey"}
					end
					return 0, 0, 0
				end
				_G.WatchFrame_AddObjectiveHandler(skinQuestBtns)
			end

		end
	end

end

aObj.SetupClassic_PlayerFramesOptions = function(self)

	local optTab = {
		["Craft UI"]       = true,
		["Glyph UI"]       = self.isClsc and true or nil,
		["Talent UI"]      = true,
		["Token UI"]       = self.isClsc and true or nil,
		["Trade Skill UI"] = true,
		["Watch Frame"]    = self.isClsc and true or nil,
	}
	self:setupFramesOptions(optTab, "Player")
	_G.wipe(optTab)

end
