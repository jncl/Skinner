local _, aObj = ...

local _G = _G

local ftype = "p"

if aObj.isMorC then
	aObj.blizzLoDFrames[ftype].AchievementUI = function(self)
		if not self.prdb.AchievementUI.skin or self.initialized.AchievementUI then return end
		self.initialized.AchievementUI = true

		local skinAchievementsObjectives, skinCategories, skinBtn, cleanButtons = _G.nop, _G.nop, _G.nop, _G.nop
		if aObj.isMnln then
			function skinAchievementsObjectives()
				local afao = _G.AchievementFrameAchievementsObjectives
				for frame in afao.pools:EnumerateActiveByTemplate("AchievementCriteriaTemplate") do
					if frame.Check:IsShown() then
						frame.Name:SetTextColor(_G.HIGHLIGHT_FONT_COLOR:GetRGB())
					end
				end
				for bar in afao.pools:EnumerateActiveByTemplate("AchievementProgressBarTemplate") do
					aObj:skinObject("statusbar", {obj=bar, regions={1, 3, 4, 5}, fi=0})
				end
				for frame in afao.pools:EnumerateActiveByTemplate("MiniAchievementTemplate") do
					frame.Border:SetTexture(nil)
					if aObj.modBtnBs then
						aObj:addButtonBorder{obj=frame, fType=ftype, relTo=frame.Icon, reParent={frame.Shield, frame.Points}, clr=frame.saturatedStyle and "sepia" or "grey"}
					end
				end
				for btn in afao.pools:EnumerateActiveByTemplate("MetaCriteriaTemplate") do
					btn.Border:SetTexture(nil)
					if btn.Check:IsShown() then
						btn.Label:SetTextColor(_G.HIGHLIGHT_FONT_COLOR:GetRGBA())
					end
					if aObj.modBtnBs then
						aObj:addButtonBorder{obj=btn, fType=ftype, relTo=btn.Icon, clr=btn.Check:IsShown() and "sepia" or "grey"}
					end
				end
			end
		else
			skinAchievementsObjectives = _G.nop
			function skinCategories()
				for _, btn in _G.pairs(_G.AchievementFrameCategoriesContainer.buttons) do
					btn.background:SetAlpha(0)
				end
			end
			function skinBtn(btn)
				if btn.NineSlice then
					aObj:removeNineSlice(btn.NineSlice)
				end
				btn:DisableDrawLayer("BACKGROUND")
				btn:DisableDrawLayer("BORDER")
				btn:DisableDrawLayer("ARTWORK")
				if btn.hiddenDescription then
					btn.hiddenDescription:SetTextColor(aObj.BT:GetRGB())
				end
				-- btn.icon.frame:SetAlpha(0)
				btn.icon.frame:SetTexture(nil)
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
					aObj:addButtonBorder{obj=btn.icon, fType=ftype, relTo=btn.texture, x1=3, y1=0, x2=-3, y2=6}
					aObj:addButtonBorder{obj=btn, fType=ftype, ofs=0}
				end
				if aObj.modChkBtns
				and btn.tracked
				then
					aObj:skinCheckButton{obj=btn.tracked, fType=ftype}
				end
			end
			function cleanButtons(frame, type)
				if aObj.prdb.AchievementUI.style == 1 then return end -- don't remove textures if option not chosen
				-- remove textures etc from buttons
				local btnName
				for _, btn in _G.pairs(frame.buttons) do
					aObj:SecureHook(btn, "Desaturate", function(bObj)
						if bObj.sbb then
							bObj.sbb:SetBackdropBorderColor(bObj:GetBackdropBorderColor())
							bObj.icon.sbb:SetBackdropBorderColor(bObj:GetBackdropBorderColor())
						end
					end)
					aObj:SecureHook(btn, "Saturate", function(bObj)
						if bObj.sbb then
							bObj.sbb:SetBackdropBorderColor(bObj:GetBackdropBorderColor())
							bObj.icon.sbb:SetBackdropBorderColor(bObj:GetBackdropBorderColor())
						end
						if bObj.description then
							bObj.description:SetTextColor(aObj.BT:GetRGB())
						end
					end)
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
		end
		local bName
		local function skinAchievement(btn)
			-- handle in combat
			if _G.InCombatLockdown() then
			    aObj:add2Table(aObj.oocTab, {skinAchievement, {btn}})
			    return
			end
			if not btn.sf then
				btn:DisableDrawLayer("BACKGROUND")
				btn:DisableDrawLayer("BORDER")
				btn:DisableDrawLayer("ARTWORK")
				aObj:skinObject("frame", {obj=btn, fType=ftype, rns=true, fb=true, ofs=0, clr={btn:GetBackdropBorderColor()}})
				if aObj.isMnln then
					if btn.HiddenDescription then
						btn.HiddenDescription:SetTextColor(_G.HIGHLIGHT_FONT_COLOR:GetRGB())
					end
					if btn.Description then
						if btn.saturatedStyle then
							btn.Description:SetTextColor(_G.HIGHLIGHT_FONT_COLOR:GetRGB())
						else
							btn.Description:SetTextColor(.6, .6, .6, 1)
						end
					end
					btn.Icon:DisableDrawLayer("BORDER")
					btn.Icon:DisableDrawLayer("OVERLAY")
					if aObj.modBtnBs then
						aObj:addButtonBorder{obj=btn.Icon, fType=ftype, ofs=-3, y1=0, y2=6, clr={btn:GetBackdropBorderColor()}}
					end
				else
					btn.icon.frame:SetTexture(nil)
					bName = btn:GetName()
					if _G[bName .. "Description"] then
						_G[bName .. "Description"]:SetTextColor(.6, .6, .6, 1)
					end
					if aObj.modBtnBs then
						aObj:addButtonBorder{obj=btn.icon, fType=ftype, relTo=btn.texture, x1=3, y1=0, x2=-3, y2=6, clr={btn:GetBackdropBorderColor()}}
					end
				end
				if aObj.modChkBtns
				and btn.Tracked
				then
					aObj:skinCheckButton{obj=btn.Tracked, fType=ftype, size=20}
				end
				aObj:SecureHook(btn, "Desaturate", function(bObj)
					if bObj.sf then
						bObj.sf:SetBackdropBorderColor(bObj:GetBackdropBorderColor())
					end
					if aObj.isMnln then
						if bObj.Icon.sbb then
							bObj.Icon.sbb:SetBackdropBorderColor(bObj:GetBackdropBorderColor())
						end
					end
				end)
				aObj:SecureHook(btn, "Saturate", function(bObj)
					if bObj.sf then
						bObj.sf:SetBackdropBorderColor(bObj:GetBackdropBorderColor())
					end
					if aObj.isMnln then
						if bObj.Icon.sbb then
							bObj.Icon.sbb:SetBackdropBorderColor(bObj:GetBackdropBorderColor())
						end
						if bObj.Description then
							bObj.Description:SetTextColor(_G.HIGHLIGHT_FONT_COLOR:GetRGB())
						end
					else
						bName = btn:GetName()
						if _G[bName .. "Description"] then
							_G[bName .. "Description"]:SetTextColor(_G.HIGHLIGHT_FONT_COLOR:GetRGB())
						end
					end
				end)
				if btn.Expand then
					aObj:SecureHook(btn, "Expand", function(bObj, height)
						if not bObj.collapsed
						and bObj:GetHeight() == height
						then
							return
						end
						skinAchievementsObjectives()
					end)
				end
			end
			skinAchievementsObjectives()
		end

		self:SecureHookScript(_G.AchievementFrame, "OnShow", function(this)
			self:moveObject{obj=_G.AchievementFrameCloseButton, x=1, y=8}
			self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true, ignoreHLTex=false, regions={7, 8, 9, 10}, offsets={x1=6, x2=-2, y2=-7}})
			if self.isMnln then
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, y1=7, x2=0, y2=-1})
			else
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, y1=9, x2=1, y2=-2})
			end

			self:SecureHookScript(this.Header or _G.AchievementFrameHeader, "OnShow", function(fObj)
				self:keepFontStrings(fObj)
				if aObj.isMnln then
					self:moveObject{obj=fObj.Title, x=-60, y=-25}
					self:moveObject{obj=fObj.Points, x=40, y=-5}
					fObj.Shield:SetAlpha(1)
				else
					self:moveObject{obj=_G.AchievementFrameHeaderTitle, x=-60, y=-25}
					self:moveObject{obj=_G.AchievementFrameHeaderPoints, x=40, y=-5}
					_G.AchievementFrameHeaderShield:SetAlpha(1)
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.Header or _G.AchievementFrameHeader)

			if self.isMnln then
				self:SecureHookScript(this.HeaderDetails, "OnShow", function(fObj)
					self:keepFontStrings(fObj)
					self:moveObject{obj=fObj.Filters.FilterDropdown, y=-6}
					self:skinObject("ddbutton", {obj=fObj.Filters.FilterDropdown, fType=ftype, filter=true})
					self:skinObject("editbox", {obj=fObj.Filters.SearchBox, fType=ftype, si=true, y1=-4, y2=4})
					self:skinObject("statusbar", {obj=fObj.Filters.SearchBox.SearchProgressBar, fType=ftype, fi=0, bg=fObj.Filters.SearchBox.SearchProgressBar.bg})
					if self.modBtns then
						self:skinStdButton{obj=fObj.Back, fType=ftype, sechk=true}
					end

					self:SecureHookScript(fObj.Filters.SearchBox.SearchPreviewContainer, "OnShow", function(frame)
						self:adjHeight{obj=frame, adj=((4 * 27) + 30)}
						for _, btn in _G.ipairs(frame.searchPreviews) do
							self:removeRegions(btn, {5, 6})
							btn.IconFrame:SetTexture(nil)
							if self.modBtnBs then
								self:addButtonBorder{obj=btn, relTo=btn.Icon}
							end
						end
						frame.ShowAllSearchResults:SetNormalTexture("")
						frame.ShowAllSearchResults:SetPushedTexture("")
						self:skinObject("frame", {obj=frame, fType=ftype, kfs=true, ofs=4, y2=2})
						_G.LowerFrameLevel(frame.sf)

						self:Unhook(fObj.Filters.SearchBox.SearchPreviewContainer, "OnShow")
					end)

					self:Unhook(this.HeaderDetails, "OnShow")
				end)
				self:checkShown(this.HeaderDetails)
			end

			self:SecureHookScript(this.Categories or _G.AchievementFrameCategories, "OnShow", function(fObj)
				if self.isMnln then
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
							element.Button:DisableDrawLayer("BACKGROUND")
						end
					end
					_G.ScrollUtil.AddAcquiredFrameCallback(fObj.ScrollBox, skinElement, aObj, true)
				else
					self:SecureHook("AchievementFrameCategories_Update", function()
						skinCategories()
					end)
					skinCategories()
					self:skinObject("slider", {obj=_G.AchievementFrameCategoriesContainerScrollBar, fType=ftype, rpTex="background"})
				end
				self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, rns=true, fb=true, y1=0})

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.Categories or _G.AchievementFrameCategories)

			self:SecureHookScript(_G.AchievementFrameAchievements, "OnShow", function(fObj)
				if self.isMnln then
					fObj.Background:SetTexture(nil)
					self:removeNineSlice(self:getChild(fObj, 3).NineSlice)
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
							skinAchievement(element)
						end
					end
					_G.ScrollUtil.AddAcquiredFrameCallback(fObj.ScrollBox, skinElement, aObj, true)
					self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, rns=true, fb=true, ofs=0, y2=-2})
					self:SecureHookScript(_G.AchievementFrameAchievementsObjectives, "OnShow", function(_)
						skinAchievementsObjectives()
					end)
				else
					self:removeNineSlice(self:getChild(fObj, 2).NineSlice)
					self:skinObject("slider", {obj=_G.AchievementFrameAchievementsContainerScrollBar, fType=ftype})
					self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, rns=true, fb=true, ofs=0, x1=-2, y2=-2})
					if self.prdb.AchievementUI.style == 2 then
						-- remove textures etc from buttons
						cleanButtons(_G.AchievementFrameAchievementsContainer, "Achievements")
						-- hook this to handle objectives text colour changes
						self:SecureHookScript(_G.AchievementFrameAchievementsObjectives, "OnShow", function(frame)
							if frame.completed then
								for _, child in _G.ipairs{frame:GetChildren()} do
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
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(_G.AchievementFrameAchievements)

			self:SecureHookScript(_G.AchievementFrameStats, "OnShow", function(fObj)
				if self.isMnln then
					self:getChild(fObj, 1):DisableDrawLayer("BACKGROUND")
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
							element.Background:SetTexture(nil)
							aObj:removeRegions(element, {2, 3, 4})
						end
					end
					_G.ScrollUtil.AddAcquiredFrameCallback(fObj.ScrollBox, skinElement, aObj, true)
					self:removeNineSlice(self:getChild(fObj, 4).NineSlice)
					self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, fb=true, ofs=0, x1=2, y2=-2})
				else
					_G.AchievementFrameStatsBG:SetAlpha(0)
					self:removeNineSlice(self:getChild(fObj, 3).NineSlice)
					self:skinObject("slider", {obj=_G.AchievementFrameStatsContainerScrollBar, fType=ftype})
					local function skinStats()
						for _, btn in _G.pairs(_G.AchievementFrameStatsContainer.buttons) do
							btn.background:SetTexture(nil)
							btn.left:SetAlpha(0)
							btn.middle:SetAlpha(0)
							btn.right:SetAlpha(0)
						end
					end
					skinStats()
					self:SecureHook("AchievementFrameStats_Update", function()
						skinStats()
					end)
					self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, fb=true, ofs=0, x1=-2, y2=-2})
				end

				self:Unhook(fObj, "OnShow")
			end)

			local function skinSummaryAchievements()
				for _, btn in _G.ipairs(_G.AchievementFrameSummaryAchievements.buttons) do
					skinAchievement(btn)
				end
			end
			local function skinSB(statusBar, moveText)
				if moveText then
					aObj:moveObject{obj=_G[statusBar].Label or _G[statusBar .. "Label"] or _G[statusBar .. "Title"], y=-3}
					aObj:moveObject{obj=_G[statusBar].Text or _G[statusBar .. "Text"], y=-3}
				end
				aObj:skinObject("statusbar", {obj=_G[statusBar], regions={3, 4, 5}, fi=0, bg=_G[statusBar .. "FillBar"]})
			end
			self:SecureHookScript(_G.AchievementFrameSummary, "OnShow", function(fObj)
				fObj:DisableDrawLayer("BACKGROUND")
				self:skinObject("frame", {obj=self:getChild(fObj, 1), fType=ftype, kfs=true, fb=true, ofs=0, x1=-2, y2=-2})
				_G.AchievementFrameSummaryAchievementsHeaderHeader:SetTexture(nil)
				self:SecureHook("AchievementFrameSummary_UpdateAchievements", function(...)
					skinSummaryAchievements()
					if _G.select("#", ...) == 0 then
						_G.AchievementFrameSummaryAchievementsEmptyText:Hide()
					end
				end)
				skinSummaryAchievements()
				_G.AchievementFrameSummaryAchievementsEmptyText:Hide()
				local catName = "AchievementFrameSummaryCategories"
				_G[catName .. "HeaderTexture"]:SetTexture(nil)
				self:moveObject{obj=_G[catName .. "StatusBarTitle"], y=-3}
				self:moveObject{obj=_G[catName .. "StatusBarText"], y=-3}
				skinSB(catName .. "StatusBar")
				for i = 1, self.isMnln and 12 or 8 do
					skinSB(catName .. "Category" .. i, true)
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(_G.AchievementFrameSummary)

			self:SecureHookScript(_G.AchievementFrameComparison, "OnShow", function(fObj)
				fObj:DisableDrawLayer("BACKGROUND")
				fObj:DisableDrawLayer("ARTWORK")
				if self.isMnln then
					self:removeRegions(_G.AchievementFrameComparisonHeader, {1, 2, 3})
					_G.AchievementFrameComparisonHeader.Shield:ClearAllPoints()
					_G.AchievementFrameComparisonHeader.Shield:SetPoint("RIGHT", _G.AchievementFrameCloseButton, "LEFT", -10, -3)
					_G.AchievementFrameComparisonHeader.Points:ClearAllPoints()
					_G.AchievementFrameComparisonHeader.Points:SetPoint("RIGHT", _G.AchievementFrameComparisonHeader.Shield, "LEFT", -10, 0)
					_G.AchievementFrameComparisonHeaderName:ClearAllPoints()
					_G.AchievementFrameComparisonHeaderName:SetPoint("RIGHT", _G.AchievementFrameComparisonHeader.Points, "LEFT", -20, 0)
					self:removeNineSlice(self:getChild(fObj, 5).NineSlice)
					self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, rns=true, fb=true, ofs=0, x2=-20, y2=-2})
					for _, type in _G.pairs{"Player", "Friend"} do
						self:removeNineSlice(fObj.Summary[type].NineSlice)
						self:removeRegions(fObj.Summary[type], {1})
						skinSB(fObj.Summary[type].StatusBar:GetName(), true)
						-- self:moveObject{obj=fObj.Summary[type].StatusBar.Title, y=-3}
						-- self:moveObject{obj=fObj.Summary[type].StatusBar.Text, y=-3}
						-- self:skinObject("statusbar", {obj=fObj.Summary[type].StatusBar, regions={3, 4, 5}, fi=0})
					end
					self:skinObject("scrollbar", {obj=fObj.AchievementContainer.ScrollBar, fType=ftype})
					local function skinAchieve(...)
						local _, element, new
						if _G.select("#", ...) == 2 then
							element, _ = ...
						elseif _G.select("#", ...) == 3 then
							element, _, new = ...
						else
							_, element, _, new = ...
						end
						if new ~= false then
							skinAchievement(element.Player)
							aObj:removeNineSlice(element.Friend.NineSlice)
							skinAchievement(element.Friend)
						end
					end
					_G.ScrollUtil.AddAcquiredFrameCallback(fObj.AchievementContainer.ScrollBox, skinAchieve, aObj, true)
					self:skinObject("scrollbar", {obj=fObj.StatContainer.ScrollBar, fType=ftype})
					local function skinStat(...)
						local _, element, new
						if _G.select("#", ...) == 2 then
							element, _ = ...
						elseif _G.select("#", ...) == 3 then
							element, _, new = ...
						else
							_, element, _, new = ...
						end
						if new ~= false then
							element.Background:SetTexture(nil)
							aObj:removeRegions(element, {2, 3, 4, 5 ,6, 7})
						end
					end
					_G.ScrollUtil.AddAcquiredFrameCallback(fObj.StatContainer.ScrollBox, skinStat, aObj, true)
				else
					self:removeRegions(_G.AchievementFrameComparisonHeader, {1, 2})
					_G.AchievementFrameComparisonHeaderShield:ClearAllPoints()
					_G.AchievementFrameComparisonHeaderShield:SetPoint("RIGHT", _G.AchievementFrameCloseButton, "LEFT", -10, -3)
					_G.AchievementFrameComparisonHeaderPoints:ClearAllPoints()
					_G.AchievementFrameComparisonHeaderPoints:SetPoint("RIGHT", _G.AchievementFrameComparisonHeaderShield, "LEFT", -10, 0)
					_G.AchievementFrameComparisonHeaderName:ClearAllPoints()
					_G.AchievementFrameComparisonHeaderName:SetPoint("RIGHT", _G.AchievementFrameComparisonHeaderPoints, "LEFT", -20, 0)
					self:removeNineSlice(self:getChild(fObj, 5).NineSlice)
					self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, rns=true, fb=true, ofs=0, x1=-2, y2=-2})
					for _, type in _G.pairs{"Player", "Friend"} do
						self:removeNineSlice(_G["AchievementFrameComparisonSummary" .. type].NineSlice)
						self:removeRegions(_G["AchievementFrameComparisonSummary" .. type], {1})
						skinSB("AchievementFrameComparisonSummary" .. type .. "StatusBar", true)
						if type == "Friend" then
							self:removeBackdrop(_G["AchievementFrameComparisonSummary" .. type])
						end
					end
					self:skinObject("slider", {obj=_G["AchievementFrameComparisonContainerScrollBar"], fType=ftype, rpTex="background"})
					cleanButtons(_G.AchievementFrameComparisonContainer, "Comparison")
					self:skinObject("slider", {obj=_G["AchievementFrameComparisonStatsContainerScrollBar"], fType=ftype, rpTex="background"})
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
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(_G.AchievementFrameComparison)

			if self.isMnln then
				self:SecureHookScript(this.SearchResults, "OnShow", function(fObj)
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
							aObj:removeRegions(element, {6, 7,})
							element.IconFrame:SetTexture(nil)
							if aObj.modBtnBs then
								aObj:addButtonBorder{obj=element, relTo=element.Icon}
							end
						end
					end
					_G.ScrollUtil.AddAcquiredFrameCallback(fObj.ScrollBox, skinElement, aObj, true)

					self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, cb=true, x1=-8, y1=-1, x2=4})

					self:Unhook(this.SearchResults, "OnShow")
				end)
			end

			-- let AddOn skins know when when UI is skinned (used by AchieveIt & Krowi_AchievementFilter skins)
			self.callbacks:Fire("AchievementUI_Skinned", self)
			-- remove all callbacks for this event
			self.callbacks.events["AchievementUI_Skinned"] = nil

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzLoDFrames[ftype].ArchaeologyUI = function(self)
		if not self.prdb.ArchaeologyUI or self.initialized.ArchaeologyUI then return end
		self.initialized.ArchaeologyUI = true

		self:SecureHookScript(_G.ArchaeologyFrame, "OnShow", function(this)
			self:moveObject{obj=this.infoButton, x=-25}
			self:skinObject("ddbutton", {obj=this.RaceFilterDropdown, fType=ftype})
			_G.ArchaeologyFrameRankBarBackground:SetAllPoints(this.rankBar)
			_G.ArchaeologyFrameRankBarBorder:Hide()
			self:skinObject("statusbar", {obj=this.rankBar, fi=0, bg=_G.ArchaeologyFrameRankBarBackground})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true, x1=30, x2=3})

			self:keepFontStrings(this.summaryPage) -- remove title textures
			_G.ArchaeologyFrameSummaryPageTitle:SetTextColor(self.HT:GetRGB())
			for i = 1, _G.ARCHAEOLOGY_MAX_RACES do
				this.summaryPage["race" .. i].raceName:SetTextColor(self.BT:GetRGB())
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=this.summaryPage.prevPageButton, ofs=0, clr="disabled"}
				self:addButtonBorder{obj=this.summaryPage.nextPageButton, ofs=0, clr="disabled"}
				self:SecureHook(this.summaryPage, "UpdateFrame", function(fObj)
					self:clrPNBtns(fObj:GetName())
				end)
			end

			self:keepFontStrings(this.completedPage) -- remove title textures
			this.completedPage.infoText:SetTextColor(self.BT:GetRGB())
			this.completedPage.titleBig:SetTextColor(self.HT:GetRGB())
			this.completedPage.titleTop:SetTextColor(self.BT:GetRGB())
			this.completedPage.titleMid:SetTextColor(self.BT:GetRGB())
			this.completedPage.pageText:SetTextColor(self.BT:GetRGB())
			for i = 1, _G.ARCHAEOLOGY_MAX_COMPLETED_SHOWN do
				this.completedPage["artifact" .. i].artifactName:SetTextColor(self.HT:GetRGB())
				this.completedPage["artifact" .. i].artifactSubText:SetTextColor(self.BT:GetRGB())
				this.completedPage["artifact" .. i].border:Hide()
				_G["ArchaeologyFrameCompletedPageArtifact" .. i .. "Bg"]:Hide()
				if self.modBtnBs then
					self:addButtonBorder{obj=this.completedPage["artifact" .. i], relTo=this.completedPage["artifact" .. i].icon}
				end
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=this.completedPage.prevPageButton, ofs=0, clr="disabled"}
				self:addButtonBorder{obj=this.completedPage.nextPageButton, ofs=0, clr="disabled"}
				self:SecureHook(this.completedPage, "UpdateFrame", function(fObj)
					self:clrPNBtns(fObj:GetName())
				end)
			end

			self:removeRegions(this.artifactPage, {2, 3, 7, 9}) -- title textures, backgrounds
			if self.modBtns then
				self:skinStdButton{obj=this.artifactPage.backButton}
				self:skinStdButton{obj=this.artifactPage.solveFrame.solveButton}
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=this.artifactPage, relTo=this.artifactPage.icon, ofs=1}
			end
			self:getRegion(this.artifactPage.solveFrame.statusBar, 1):Hide() -- BarBG texture
			self:skinObject("statusbar", {obj=this.artifactPage.solveFrame.statusBar, fi=0})
			this.artifactPage.solveFrame.statusBar:SetStatusBarColor(0.75, 0.45, 0, 0.7)
			this.artifactPage.historyTitle:SetTextColor(self.HT:GetRGB())
			this.artifactPage.historyScroll.child.text:SetTextColor(self.BT:GetRGB())
			self:skinObject("scrollbar", {obj=this.artifactPage.historyScroll.ScrollBar, fType=ftype})

			self:removeRegions(this.helpPage, {2, 3}) -- title textures
			this.helpPage.titleText:SetTextColor(self.HT:GetRGB())
			_G.ArchaeologyFrameHelpPageDigTex:SetTexCoord(0.05, 0.885, 0.055, 0.9) -- remove texture surrounds
			_G.ArchaeologyFrameHelpPageDigTitle:SetTextColor(self.HT:GetRGB())
			_G.ArchaeologyFrameHelpPageHelpScrollHelpText:SetTextColor(self.BT:GetRGB())

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.ArcheologyDigsiteProgressBar, "OnShow", function(this)
			this:DisableDrawLayer("BACKGROUND")
			this.BarBorderAndOverlay:SetTexture(nil)
			self:skinObject("statusbar", {obj=this.FillBar, fi=0})

			self:Unhook(this, "OnShow")
		end)

		-- N.B. DigsiteCompleteToastFrame is managed as part of the Alert Frames skin

	end
end

aObj.blizzFrames[ftype].Buffs = function(self)
	if not self.prdb.Buffs or self.initialized.Buffs then return end
	self.initialized.Buffs = true

	if self.modBtnBs then
		local function skinBuffBtn(btn)
			-- ignore privateAuraAnchor(s)
			if not btn:GetDebugName():find("AuraContainer") then
				return
			end
			if btn.auraType == "Buff"
			or btn.auraType == "Debuff"
			or btn.auraType == "DeadlyDebuff"
			or btn.auraType == "TempEnchant"
			then
				aObj:addButtonBorder{obj=btn, fType=ftype, relTo=btn.Icon, ofs=3, clr=btn.Border and {btn.Border:GetVertexColor()} or "grey", ccat=true}
				if btn.Border then
					btn.Border:SetAlpha(0)
				end
			end
		end
		local function skinBuffs(frame)
			for _, buff in _G.pairs(frame.auraFrames) do
				if frame.auraInfo then
					skinBuffBtn(buff)
				end
			end
		end
		for _, frame in _G.pairs{_G.BuffFrame, _G.DebuffFrame, self.isMnln and _G.ExternalDefensivesFrame or nil} do
			-- allow time for buffs to appear
			_G.C_Timer.After(0.25, function()
				skinBuffs(frame)
			end)
			-- N.B. DON'T hook the UpdateAuraButtons function as it causes many Secret Values errors
		end
		self:SecureHookScript(_G.DeadlyDebuffFrame, "OnShow", function(this)
			skinBuffBtn(this.Debuff)

			self:Unhook(this, "OnShow")
		end)
	end

	-- N.B.The AuraButtonTooltip cannot be skinned as it has a ScopeModifier forbidden=true

end

if not aObj.isMnln then
	aObj.blizzFrames[ftype].CastingBar = function(self)
		if not self.prdb.CastingBar.skin or self.initialized.CastingBar then return end
		self.initialized.CastingBar = true

		local cBar
		for _, prefix in _G.pairs{"Player", aObj.isClsc and "OverlayPlayer" or nil} do
			cBar = _G[prefix .. "CastingBarFrame"]
			if aObj.isClsc
			or aObj.isClscBCA
			then
				self:RawHook(cBar.Border, "SetTexture", function(this, _)
					self.hooks[this].SetTexture(this, nil)
				end, true)
				self:RawHook(cBar, "SetStatusBarTexture", function(this, _)
					self.hooks[this].SetStatusBarTexture(this, self.sbTexture)
				end, true)
			end
			cBar.Border:SetTexture(nil)
			cBar.Flash:SetTexture(nil)
			if self.prdb.CastingBar.glaze then
				self:skinObject("statusbar", {obj=cBar, fType=ftype, regions={2}, fi=0, bg=self:getRegion(cBar, 1)})
			end
		end

	end
end

if aObj.isMorCorF then
	aObj.blizzFrames[ftype].CharacterFrames = function(self)
		if not self.prdb.CharacterFrames or self.initialized.CharacterFrames then return end
		self.initialized.CharacterFrames = true

		self:SecureHookScript(_G.CharacterFrame, "OnShow", function(this)
			if _G.InCombatLockdown() then
			    self:add2Table(self.oocTab, {self.checkShown, {self, this}})
			    return
			end

			if not self.isFrvr then
				self:removeInset(this.InsetRight)
				self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true})
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, rp=true, cb=true, x2=self.isClsc and 1 or 3})
				if self.isClsc then
					if self.modBtnBs then
						self:addButtonBorder{obj=_G.CharacterFrameExpandButton, fType=ftype, ofs=-2, x1=1, clr="gold"}
					end
				end
			else
				this.LeftPaneHost:DisableDrawLayer("BACKGROUND")
				this.RightPaneHost:DisableDrawLayer("BACKGROUND")
				this.RightPaneHost.StoneBg:SetAlpha(0)
				self:getChild(this.RightPaneHost, 1):DisableDrawLayer("OVERLAY") -- divider texture
				_G.CharacterStatsPaneScrollBox:DisableDrawLayer("BORDER")
				_G.CharacterStatsPaneScrollBox.ClassBackground:SetAlpha(0)
				local function skinStatElement(...)
					local _, element
					if _G.select("#", ...) == 2 then
						element, _ = ...
					else
						_, element, _ = ...
					end
					aObj:getRegion(element, 1):SetTexture(nil)
				end
				self:skinObject("scrollbar", {obj=_G.CharacterStatsPaneScrollBox.ScrollBar, fType=ftype})
				_G.ScrollUtil.AddInitializedFrameCallback(_G.CharacterStatsPaneScrollBox.ScrollBox, skinStatElement, aObj, true)
				_G.CharacterStatsPanePetScrollBox:DisableDrawLayer("BORDER")
				self:skinObject("scrollbar", {obj=_G.CharacterStatsPanePetScrollBox.ScrollBar, fType=ftype})
				_G.ScrollUtil.AddInitializedFrameCallback(_G.CharacterStatsPanePetScrollBox.ScrollBox, skinStatElement, aObj, true)
				self:skinObject("sidetabs", {obj=this.ModeTabs, tabs="Tabs", fType=ftype})
				-- .TabIndicators [inherits="GamepadTabIndicatorsTemplate"]
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, rns=true, rp=true, cb=true, x1=-5, y1=2, x2=1, y2=-3})
				if self.modBtnBs then
					self:addButtonBorder{obj=this.RightPaneToggleButton, fType=ftype, ofs=-2, x1=1, clr="gold"}
				end
			end

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.CharacterFrame)

		if self.isMorF then
			-- other adddons reparent this (e.g. DejaCharacterStats)
			self:SecureHookScript(_G.CharacterStatsPane, "OnShow", function(this)
				if _G.InCombatLockdown() then
				    self:add2Table(self.oocTab, {self.checkShown, {self, this}})
				    return
				end

				this.ClassBackground:SetTexture(nil)
				this.ItemLevelFrame.Background:SetTexture(nil)
				this.ItemLevelCategory:DisableDrawLayer("BACKGROUND")
				this.AttributesCategory:DisableDrawLayer("BACKGROUND")
				this.EnhancementsCategory:DisableDrawLayer("BACKGROUND")
				self:SecureHook("PaperDollFrame_UpdateStats", function()
					for statLine in _G.CharacterStatsPane.statsFramePool:EnumerateActive() do
						statLine:DisableDrawLayer("BACKGROUND")
					end
				end)
				_G.PaperDollFrame_UpdateStats()

				self:Unhook(this, "OnShow")
			end)
		else
			self:SecureHookScript(_G.CharacterStatsPane, "OnShow", function(this)
				self:skinObject("scrollbar", {obj=this.ScrollBar, fType=ftype})
				for i = 1, 7 do
					_G["CharacterStatsPaneCategory" .. i].BgTop:SetTexture(nil)
					_G["CharacterStatsPaneCategory" .. i].BgBottom:SetTexture(nil)
					_G["CharacterStatsPaneCategory" .. i].BgMiddle:SetTexture(nil)
					_G["CharacterStatsPaneCategory" .. i].BgMinimized:SetTexture(nil)
				end

				self:Unhook(this, "OnShow")
			end)
		end
		self:checkShown(_G.CharacterStatsPane)

		self:SecureHookScript(_G.PaperDollFrame, "OnShow", function(this)
			if _G.InCombatLockdown() then
			    self:add2Table(self.oocTab, {self.checkShown, {self, this}})
			    return
			end

			if not self.isFrvr then
				_G.PaperDollSidebarTabs.DecorLeft:SetAlpha(0)
				_G.PaperDollSidebarTabs.DecorRight:SetAlpha(0)
				for i = 1, #_G.PAPERDOLL_SIDEBARS do
					_G["PaperDollSidebarTab" .. i].TabBg:SetAlpha(0)
					_G["PaperDollSidebarTab" .. i].Hider:SetAlpha(0)
					-- use a button border to indicate the active tab
					self.modUIBtns:addButtonBorder{obj=_G["PaperDollSidebarTab" .. i], relTo=_G["PaperDollSidebarTab" .. i].Icon, ofs=i==1 and 3 or 1, clr="selected"} -- use module function here to force creation
				end
				-- hook this to manage the active tab
				self:SecureHook("PaperDollFrame_UpdateSidebarTabs", function()
					for i = 1, #_G.PAPERDOLL_SIDEBARS do
						if _G["PaperDollSidebarTab" .. i]
						and _G["PaperDollSidebarTab" .. i].sbb
						then
							_G["PaperDollSidebarTab" .. i].sbb:SetShown(_G.GetPaperDollSideBarFrame(i):IsShown())
						end
					end
				end)
				-- handle in combat
				if _G.InCombatLockdown() then
				    self:add2Table(self.oocTab, {_G.PaperDollFrame_UpdateSidebarTabs, {nil}})
				else
					_G.PaperDollFrame_UpdateSidebarTabs()
				end
			else
				if self.modBtnBs then
					for _, btn in _G.pairs(_G.PaperDollSidebarTabs.Tabs) do
						self:addButtonBorder{obj=btn, fType=ftype, clr="sepia", ofs=0}
					end
				end
				this.TopBackgroundStripHost:DisableDrawLayer("ARTWORK")
			end

			self:SecureHookScript(this.TitleManagerPane, "OnShow", function(fObj)
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
						element:DisableDrawLayer("BACKGROUND")
					end
				end
				_G.ScrollUtil.AddAcquiredFrameCallback(fObj.ScrollBox, skinElement, aObj, true)

				self:Unhook(fObj, "OnShow")
			end)

			self:SecureHookScript(this.EquipmentManagerPane, "OnShow", function(fObj)
				if self.isFrvr then
					fObj:DisableDrawLayer("BORDER")
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
						element:DisableDrawLayer("BACKGROUND")
						if aObj.modBtnBs then
							aObj:addButtonBorder{obj=element, relTo=element.icon}
						end
					end
				end
				_G.ScrollUtil.AddAcquiredFrameCallback(fObj.ScrollBox, skinElement, aObj, true)
				if self.modBtns then
					self:skinStdButton{obj=fObj.EquipSet, schk=true}
					self:skinStdButton{obj=fObj.SaveSet, schk=true}
					if self.isFrvr then
						self:skinStdButton{obj=fObj.NewSet}
					end
				end

				self:Unhook(fObj, "OnShow")
			end)

			_G.CharacterModelScene:DisableDrawLayer("BACKGROUND")
			_G.CharacterModelScene:DisableDrawLayer("BORDER")
			if not self.isFrvr then
				_G.CharacterModelScene:DisableDrawLayer("OVERLAY")
			else
				self:skinObject("frame", {obj=_G.PetPaperDollFrameExpBar, fType=ftype, kfs=true, fb=true, ofs=-2})
				_G.PetPaperDollFrameExpBar.Fill:SetAlpha(1)
				if self.modBtnBs then
					self:addButtonBorder{obj=_G.PetPaperDollPetHappinessInfo, fType=ftype, clr="gold"}
				end
			end

			local function skinSlot(btn)
				if not aObj.isFrvr then
					btn:DisableDrawLayer("BACKGROUND")
				else
					btn.BorderFrame:DisableDrawLayer("BACKGROUND")
				end
				if aObj.modBtnBs then
					aObj:addButtonBorder{obj=btn, fType=ftype, ibt=true, reParent={btn.ignoreTexture}}
					-- force quality border update
					_G.PaperDollItemSlotButton_Update(btn)
					if self.isMorF then
						if self.isMnln then
							-- RankFrame
							aObj:changeTandC(btn.RankFrame.Texture)
							btn.RankFrame.Texture:SetSize(20, 20)
							btn.RankFrame.Label:ClearAllPoints()
							btn.RankFrame.Label:SetPoint("CENTER", btn.RankFrame.Texture)
						end
						if btn.SocketDisplay then
							for _, socket in _G.ipairs(btn.SocketDisplay.Slots) do
								socket.Slot:SetTexture(nil)
								aObj:addButtonBorder{obj=socket, fType=ftype, es=8, ofs=0}
							end
						end
					end
				end
			end
			if self.modBtnBs then
				self:SecureHook("PaperDollItemSlotButton_Update", function(btn)
					if btn.sbb then
						if not _G.GetInventoryItemTexture("player", btn:GetID()) then
							self:clrBtnBdr(btn, "grey")
							btn.icon:SetTexture(nil)
						end
					end
				end)
			end
			if not self.isFrvr then
				for i = 1, #_G.PaperDollItemsFrame.EquipmentSlots do
					skinSlot(_G.PaperDollItemsFrame.EquipmentSlots[i])
				end
				for i = 1, #_G.PaperDollItemsFrame.WeaponSlots do
					skinSlot(_G.PaperDollItemsFrame.WeaponSlots[i])
				end
			else
				for i = 1, #this.ItemsFrame.EquipmentSlots do
					skinSlot(this.ItemsFrame.EquipmentSlots[i])
				end
				for i = 1, #this.ItemsFrame.WeaponSlots do
					skinSlot(this.ItemsFrame.WeaponSlots[i])
				end
				_G.CharacterAmmoSlot:DisableDrawLayer("BACKGROUND")
				self:addButtonBorder{obj=_G.CharacterAmmoSlot, fType=ftype, ofs=3}
				_G.PaperDollItemSlotButton_Update(_G.CharacterAmmoSlot)
			end

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.PaperDollFrame)

		self:SecureHookScript(_G.GearManagerPopupFrame, "OnShow", function(this)
			if _G.InCombatLockdown() then
			    self:add2Table(self.oocTab, {self.checkShown, {self, this}})
			    return
			end

			self:skinIconSelector(this, ftype)

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.GearManagerPopupFrame)

		if self.isClsc then
			self:SecureHookScript(_G.PetPaperDollFrame, "OnShow", function(this)
				if _G.InCombatLockdown() then
				    self:add2Table(self.oocTab, {self.checkShown, {self, this}})
				    return
				end

				self:skinObject("statusbar", {obj=_G.PetPaperDollFrameExpBar, fType=ftype, regions={1, 2}, fi=0})
				_G.PetModelFrameShadowOverlay:DisableDrawLayer("OVERLAY")
				self:makeMFRotatable(_G.PetModelFrame)
				if self.modBtnBs then
					self:addButtonBorder{obj=_G.PetPaperDollPetInfo, fType=ftype, ofs=1, x2=0, clr="gold"}
				end
			end)
			self:checkShown(_G.PetPaperDollFrame)
		end

		local skinBar
		if self.isFrvr then
			function skinBar(fObj)
				_G.RunNextFrame(function()
					aObj:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, fb=true, ofs=0})
					fObj.Fill:SetAlpha(1)
				end)
			end
		end
		self:SecureHookScript(_G.ReputationFrame, "OnShow", function(this)
			if _G.InCombatLockdown() then
			    self:add2Table(self.oocTab, {self.checkShown, {self, this}})
			    return
			end

			self:keepFontStrings(this)
			if self.isMorF then
				self:skinObject("ddbutton", {obj=this.filterDropdown, fType=ftype})
				self:skinObject("scrollbar", {obj=this.ScrollBar, fType=ftype})
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
						if not aObj.isFrvr then
							if elementData.isHeader
							and not elementData.isChild
							then
								aObj:changeHdrExpandTex(element)
								element:Initialize(elementData) -- force texture change
							else
								element.Content.ReputationBar.LeftTexture:SetAlpha(0)
								element.Content.ReputationBar.RightTexture:SetAlpha(0)
								aObj:skinObject("statusbar", {obj=element.Content.ReputationBar, fi=0})
								if elementData.isHeader
								and aObj.modBtns
								then
									aObj:skinExpandButton{obj=element.ToggleCollapseButton, fType=ftype, onSB=true}
								end
							end
						else
							if elementData.isHeader then
								aObj:getRegion(element, 1):SetTexture(nil)
							elseif element.Content
							and element.Content.ReputationBar
							then
								skinBar(element.Content.ReputationBar)
							end
						end
					end
				end
				_G.ScrollUtil.AddAcquiredFrameCallback(this.ScrollBox, skinElement, aObj, true)
				if self.isFrvr then
					self:getPenultimateChild(this.ScrollBox):DisableDrawLayer("OVERLAY") -- Top Line Texture
					self:getLastChild(this.ScrollBox):DisableDrawLayer("OVERLAY") -- Bottom Line Texture
				end
				self:SecureHookScript(this.ReputationDetailFrame, "OnShow", function(fObj)
					if self.isMnln then
						self:skinObject("scrollbar", {obj=fObj.ScrollingDescriptionScrollBar, fType=ftype})
					end
					if not self.isFrvr then
						self:removeNineSlice(fObj.Border)
						self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, ofs=-3})
						if self.modBtns then
							self:skinCloseButton{obj=fObj.CloseButton}
							self:adjHeight{obj=fObj.ViewRenownButton, adj=4}
							-- .ToggleCollapseButton
						end
					else
						self:skinObject("scrollbar", {obj=fObj.DescriptionScrollBar, fType=ftype})
						skinBar(fObj.StandingBar)
					end
					if self.modBtns then
						self:skinStdButton{obj=fObj.ViewRenownButton, fType=ftype, sechk=true}
					end
					if self.modChkBtns then
						self:skinCheckButton{obj=fObj.AtWarCheckbox, fType=ftype}
						self:skinCheckButton{obj=fObj.MakeInactiveCheckbox, fType=ftype, sechk=true}
						self:skinCheckButton{obj=fObj.WatchFactionCheckbox, fType=ftype}
					end

					self:Unhook(fObj, "OnShow")
				end)
				self:checkShown(this.ReputationDetailFrame)
			else
				self:skinObject("slider", {obj=_G.ReputationListScrollFrame.ScrollBar, fType=ftype, rpTex="background"})
				for i = 1, _G.NUM_FACTIONS_DISPLAYED do
					_G["ReputationBar" .. i .. "Background"]:SetAlpha(0)
					_G["ReputationBar" .. i .. "ReputationBarLeftTexture"]:SetAlpha(0)
					_G["ReputationBar" .. i .. "ReputationBarRightTexture"]:SetAlpha(0)
					self:skinObject("statusbar", {obj=_G["ReputationBar" .. i .. "ReputationBar"], fi=0})
					if self.modBtns then
						self:skinExpandButton{obj=_G["ReputationBar" .. i .. "ExpandOrCollapseButton"], fType=ftype, onSB=true}
					end
				end
				self:SecureHookScript(_G.ReputationDetailFrame, "OnShow", function(fObj)
					self:removeNineSlice(fObj.Border)
					self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, ofs=-3})
					if self.modBtns then
						self:skinCloseButton{obj=_G.ReputationDetailCloseButton, fType=ftype}
					end
					if self.modChkBtns then
						self:skinCheckButton{obj=_G.ReputationDetailAtWarCheckbox or _G.ReputationDetailAtWarCheckBox, fType=ftype}
						self:skinCheckButton{obj=_G.ReputationDetailInactiveCheckbox or _G.ReputationDetailInactiveCheckBox, fType=ftype}
						self:skinCheckButton{obj=_G.ReputationDetailMainScreenCheckbox or _G.ReputationDetailMainScreenCheckBox, fType=ftype}
					end

					self:Unhook(fObj, "OnShow")
				end)
			end

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.ReputationFrame)

		 -- Currency Tab
		if self.isMorF then
			self:SecureHookScript(_G.TokenFrame, "OnShow", function(this)
				if _G.InCombatLockdown() then
				    self:add2Table(self.oocTab, {self.checkShown, {self, this}})
				    return
				end

				self:keepFontStrings(this)
				self:skinObject("ddbutton", {obj=this.filterDropdown, fType=ftype})
				self:skinObject("scrollbar", {obj=this.ScrollBar, fType=ftype})
				local function skinCurrency(...)
					local _, element, elementData, new
					if _G.select("#", ...) == 2 then
						element, elementData = ...
					elseif _G.select("#", ...) == 3 then
						element, elementData, new = ...
					else
						_, element, elementData, new = ...
					end
					if new ~= false then
						if not aObj.isFrvr then
							if elementData.isHeader then
								if elementData.currencyListDepth == 0 then
									aObj:changeHdrExpandTex(element)
									if element.elementData then -- BUGFIX: #183
										element:UpdateCollapsedState(element:IsCollapsed())
									end
								else
									if aObj.modBtns then
										aObj:skinExpandButton{obj=element.ToggleCollapseButton, fType=ftype, onSB=true}
									end
								end
							end
						else
							if element.StateIcon then
								aObj:getRegion(element, 1):SetTexture(nil)
								-- .StateIcon
							else
								-- .ToggleCollapseButton
							end
						end
					end
				end
				_G.ScrollUtil.AddAcquiredFrameCallback(this.ScrollBox, skinCurrency, aObj, true)
				if self.isFrvr then
					self:getPenultimateChild(this.ScrollBox):DisableDrawLayer("OVERLAY") -- Top Line Texture
					self:getLastChild(this.ScrollBox):DisableDrawLayer("OVERLAY") -- Bottom Line Texture
				else
					if self.modBtnBs then
						self:addButtonBorder{obj=this.CurrencyTransferLogToggleButton, fType=ftype}
					end
				end

				self:SecureHookScript(_G.CurrencyTransferLog, "OnShow", function(fObj)
					self:skinObject("scrollbar", {obj=fObj.ScrollBar, fType=ftype})
					self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, cb=true})

					self:Unhook(fObj, "OnShow")
				end)

				if not self.isFrvr then
					self:SecureHookScript(_G.TokenFramePopup, "OnShow", function(fObj)
						fObj.Border:DisableDrawLayer("BACKGROUND")
						fObj.Border:DisableDrawLayer("BORDER")
						self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, cb=not self.isMnln and true, ofs=-3})
						if self.modBtns then
							if self.isMnln then
								-- FIXME: CloseButton skinned here as it has a prefix of '$parent.', bug in XML file
								self:skinCloseButton{obj=self:getPenultimateChild(fObj), fType=ftype}
								self:skinStdButton{obj=fObj.CurrencyTransferToggleButton, fType=ftype, sechk=true}
							end
						end
						if self.modChkBtns then
							self:skinCheckButton{obj=fObj.InactiveCheckbox or fObj.InactiveCheckBox, fType=ftype}
							self:skinCheckButton{obj=fObj.BackpackCheckbox or fObj.BackpackCheckBox, fType=ftype}
						end

						self:Unhook(fObj, "OnShow")
					end)
				else
					self:SecureHookScript(_G.TokenDetailFrame, "OnShow", function(frame)
						if self.modBtnBs then
							self:addButtonBorder{obj=frame.CurrencyTransferLogToggleButton, fType=ftype}
						end
						if self.modChkBtns then
							self:skinCheckButton{obj=frame.InactiveCheckbox, fType=ftype}
							self:skinCheckButton{obj=frame.BackpackCheckbox, fType=ftype}
						end

						self:Unhook(_G.TokenDetailFrame, "OnShow")
					end)
					self:checkShown(_G.TokenDetailFrame)
				end

				self:Unhook(_G.TokenFrame, "OnShow")
			end)
		else
			self:SecureHookScript(_G.TokenFrame, "OnShow", function(this)
				if _G.InCombatLockdown() then
				    self:add2Table(self.oocTab, {self.checkShown, {self, this}})
				    return
				end

				self:keepFontStrings(this)
				self:skinObject("slider", {obj=_G.TokenFrameContainerScrollBar, fType=ftype, rpTex="background"})
				for _, btn in _G.pairs(_G.TokenFrameContainer.buttons) do
					btn.categoryLeft:SetTexture(nil)
					btn.categoryRight:SetTexture(nil)
					if btn.categoryMiddle then
						btn.categoryMiddle:SetTexture(nil)
					end
				end

				self:Unhook(this, "OnShow")
			end)

			self:SecureHookScript(_G.TokenFramePopup, "OnShow", function(this)
				if this.Border then
					self:keepFontStrings(this.Border)
				end
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, ofs=-6})
				if self.modChkBtns then
					self:skinCheckButton{obj=_G.TokenFramePopupInactiveCheckbox, fType=ftype}
					self:skinCheckButton{obj=_G.TokenFramePopupBackpackCheckbox, fType=ftype}
				end

				self:Unhook(this, "OnShow")
			end)

			self:SecureHookScript(_G.BackpackTokenFrame, "OnShow", function(this)
				this:DisableDrawLayer("BACKGROUND")

				self:Unhook(this, "OnShow")
			end)
		end
		self:checkShown(_G.TokenFrame)

		if self.isFrvr then
			local function skinRow(row)
				for _, tex in _G.pairs{"Background", "IconSlot"} do
					if row[tex] then
						row[tex]:SetTexture(nil)
					end
				end
				if aObj.modBtnBs
				and row.IconSlot
				then
					aObj:addButtonBorder{obj=row, fType=ftype, relTo=row.Icon}
				end
			end
			self:SecureHookScript(_G.SkillsFrame, "OnShow", function(this)
				if _G.InCombatLockdown() then
				    self:add2Table(self.oocTab, {self.checkShown, {self, this}})
				    return
				end

				self:skinObject("scrollbar", {obj=this.ScrollBar, fType=ftype})
				local function skinSkill(...)
					local _, element, elementData
					if _G.select("#", ...) == 2 then
						element, elementData = ...
					else
						_, element, elementData = ...
					end
					if elementData.isHeader then
						aObj:getRegion(element, 1):SetTexture(nil)
					elseif element.Content
					and element.Content.SkillsBar
					then
						skinBar(element.Content.SkillsBar)
					end
				end
				_G.ScrollUtil.AddInitializedFrameCallback(this.ScrollBox, skinSkill, aObj, true)
				self:getPenultimateChild(this.ScrollBox):DisableDrawLayer("OVERLAY") -- Top Line Texture
				self:getLastChild(this.ScrollBox):DisableDrawLayer("OVERLAY") -- Bottom Line Texture

				self:SecureHookScript(this.SkillDetailFrame, "OnShow", function(fObj)
					fObj.Divider:SetTexture(nil)
					self:skinObject("scrollbar", {obj=fObj.DescriptionScrollBar, fType=ftype})
					-- .Content
					-- .Footer
					skinBar(fObj.RankBar)
					for row in fObj.rowPools:EnumerateActive() do
						skinRow(row)
					end
					self:RawHook(fObj, "AcquireRow", function(sPane, template)
						local row = self.hooks[sPane].AquireRow(sPane, template)
						skinRow(row)
						return row
					end, true)

					self:Unhook(this.SkillDetailFrame, "OnShow")
				end)
				self:checkShown(this.SkillDetailFrame)

				self:Unhook(_G.SkillsFrame, "OnShow")
			end)
			self:checkShown(_G.SkillsFrame)

			self:SecureHookScript(_G.PVPRankFrame, "OnShow", function(this)
				if _G.InCombatLockdown() then
				    self:add2Table(self.oocTab, {self.checkShown, {self, this}})
				    return
				end

				this.MainInfoFrame.Line:SetTexture(nil)
				-- .RankProgressBarDisplay
					-- .DropDown
					-- .NextRewardLevel
				self:SecureHookScript(this.DetailFrame, "OnShow", function(fObj)
					fObj.Divider:SetTexture(nil)
					self:skinObject("scrollbar", {obj=fObj.DescriptionScrollBar, fType=ftype})
					-- .Content
					-- .Footer
					for row in fObj.rowPools:EnumerateActive() do
						skinRow(row)
					end

					self:Unhook(this.DetailFrame, "OnShow")
				end)
				self:checkShown(this.DetailFrame)

				self:Unhook(_G.PVPRankFrame, "OnShow")
			end)
			self:checkShown(_G.PVPRankFrame)

			self:SecureHookScript(_G.StatisticsFrame, "OnShow", function(this)
				if _G.InCombatLockdown() then
				    self:add2Table(self.oocTab, {self.checkShown, {self, this}})
				    return
				end

				self:skinObject("scrollbar", {obj=this.ScrollBar, fType=ftype})
				local function skinElement(...)
					local _, element, elementData
					if _G.select("#", ...) == 2 then
						element, elementData = ...
					else
						_, element, elementData = ...
					end
					--@debug@
					-- _G.Spew("", element)
					-- _G.Spew("", elementData)
					--@end-debug@
					if element.StateIcon then
						aObj:getRegion(element, 1):SetTexture(nil)
						-- .StateIcon
					else
						-- .ToggleCollapseButton
					end
				end
				_G.ScrollUtil.AddInitializedFrameCallback(this.ScrollBox, skinElement, aObj, true)
				self:getPenultimateChild(this.ScrollBox):DisableDrawLayer("OVERLAY") -- Top Line Texture
				self:getLastChild(this.ScrollBox):DisableDrawLayer("OVERLAY") -- Bottom Line Texture

				self:Unhook(_G.StatisticsFrame, "OnShow")
			end)
			self:checkShown(_G.StatisticsFrame)
		end

	end
end

if aObj.isMorF then
	aObj.blizzLoDFrames[ftype].CharacterCustomize = function(self)
		if not self.prdb.CharacterCustomize or self.initialized.CharacterCustomize then return end

		if not _G.CharCustomizeFrame
		or not _G.BarberShopFrame
		then
			_G.RunNextFrame(function()
				self.blizzLoDFrames[ftype].CharacterCustomize(self)
			end)
			return
		end

		self.initialized.CharacterCustomize = true

		self:SecureHookScript(_G.CharCustomizeFrame, "OnShow", function(this)
			local skinBtnTemplate = _G.nop
			if self.isMnln then
				self:SecureHook(this, "UpdateAlteredFormButtons", function(fObj)
					local buttonPool = fObj:GetAlteredFormsButtonPool()
					for btn in buttonPool:EnumerateActive() do
						btn.Ring:SetTexture(nil)
					end
				end)
				function skinBtnTemplate(template)
					if this.pools:GetPool(template) then
						for btn in this.pools:GetPool(template):EnumerateActive() do
							if btn.Ring then
								btn.Ring:SetTexture(nil)
							end
						end
					end
				end
				if self.modBtnBs then
					self:addButtonBorder{obj=this.RandomizeAppearanceButton, fType=ftype, ofs=-4, x1=5, y2=5, clr="gold"}
				end
			else
				self:skinObject("frame", {obj=this.CustomizeOptionsContainerFrame, fType=ftype, kfs=true, ofs=0, clr="brownish"})
				self:skinObject("frame", {obj=this.SmallButtons, fType=ftype, kfs=true, ofs=-4, clr="brownish"})
				if self.modBtnBs then
					self:addButtonBorder{obj=this.CustomizeOptionsContainerFrame.RandomizeAppearanceButton, fType=ftype, ofs=-4, x1=5, y2=5, clr="brownish"}
				end
			end
			self:SecureHook(this, "UpdateOptionButtons", function(_, _)
				if self.isMnln then
					for type in _G.pairs{"Category", "AlteredForm", "AlteredFormSmall", "ConditionalModel", "BodyType"} do
						skinBtnTemplate("CharCustomize" .. type .. "ButtonTemplate")
					end
				end
				for slider in this.sliderPool:EnumerateActive() do
					self:skinObject("slider", {obj=slider.ScrollBar, fType=ftype})
				end
				if self.modBtns then
					for ddObj in this.dropdownPool:EnumerateActive() do
						self:skinStdButton{obj=ddObj.Dropdown, fType=ftype, ignoreHLTex=true, sechk=true, y1=1, y2=-1}
						self:skinStdButton{obj=ddObj.IncrementButton, fType=ftype, sechk=true, ofs=1}
						self:skinStdButton{obj=ddObj.DecrementButton, fType=ftype, sechk=true, ofs=1}
						if ddObj.Dropdown.WarningTexture
						and ddObj.Dropdown.WarningTexture:GetAlpha() == 0
						then
							ddObj.Dropdown.WarningTexture:Hide()
						end
					end
				end
				if self.modChkBtns then
					for cBtn in this.pools:GetPool("CustomizationOptionCheckButtonTemplate"):EnumerateActive() do
						self:skinCheckButton{obj=cBtn.Button, fType=ftype}
					end
				end
			end)
			if self.modBtns then
				self:skinStdButton{obj=_G.BarberShopFrame.CancelButton, fType=ftype, ofs=0}
				self:skinStdButton{obj=_G.BarberShopFrame.ResetButton, fType=ftype, sechk=true, ofs=0}
				self:skinStdButton{obj=_G.BarberShopFrame.AcceptButton, fType=ftype, sechk=true, ofs=0}
			end
			if self.modBtnBs then
				for _, btn in _G.pairs(this.SmallButtons.ControlButtons) do
					self:addButtonBorder{obj=btn, fType=ftype, ofs=-4, x1=5, y2=5, clr=self.isFrvr and "brownish" or "gold", sechk=true}
				end
				-- self:SecureHook(this, "UpdateZoomButtonStates", function(fObj)
				-- 	self:clrBtnBdr(fObj.SmallButtons.ZoomOutButton, self.isFrvr and "brownish" or "gold", sechk=true)
				-- 	self:clrBtnBdr(fObj.SmallButtons.ZoomInButton, self.isFrvr and "brownish" or "gold", sechk=true)
				-- end)
			end
			if self.isFrvr then
				if self.modChkBtns then
					self:skinCheckButton{obj=_G.BarberShopFrame.SDToggleButton, fType=ftype}
				end
			end

			_G.RunNextFrame(function()
			    self:add2Table(self.ttList, ftype, _G.CustomizationNoHeaderTooltip)
			    if self.isFrvr then
					self:clrBBC(_G.CustomizationNoHeaderTooltip.sf, "brownish")
			    end
			end)

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.CharCustomizeFrame)

	end
end

if aObj.isMorCorF then
	aObj.blizzLoDFrames[ftype].Collections = function(self)
		if not self.prdb.Collections or self.initialized.Collections then return end
		self.initialized.Collections = true

		self:SecureHookScript(_G.CollectionsJournal, "OnShow", function(this)
			if self.isMorC then
				self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true, selectedTab=this.selectedTab})
			else
				self:skinObject("sidetabs", {obj=this.TabContainer, tabs="Tabs", fType=ftype})
			end
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, rns=true, cb=true, x2=self.Rtl and 3 or 1, y2=-2})

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.CollectionsJournal)

		self:SecureHookScript(_G.MountJournal, "OnShow", function(this)
			self:removeInset(this.LeftInset)
			self:removeInset(this.RightInset)
			if self.isMnln then
				self:removeInset(this.BottomLeftInset)
				self:removeRegions(this.SlotButton, {1, 3})
			end
			self:skinObject("ddbutton", {obj=this.FilterDropdown, fType=ftype, filter=true})
			self:skinObject("editbox", {obj=this.searchBox, fType=ftype, si=true})
			self:removeInset(this.MountCount)
			self:keepFontStrings(this.MountDisplay)
			this.MountDisplay.ShadowOverlay:DisableDrawLayer("OVERLAY")
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
					element:DisableDrawLayer("BACKGROUND")
					if aObj.modBtnBs then
						aObj:addButtonBorder{obj=element, fType=ftype, relTo=element.icon, reParent={element.favorite}}
					end
				end
				if aObj.modBtnBs then
					_G.RunNextFrame(function()
						element.sbb:SetBackdropBorderColor(element.icon:GetVertexColor())
					end)
				end
			end
			_G.ScrollUtil.AddAcquiredFrameCallback(this.ScrollBox, skinElement, aObj, true)
			self:removeMagicBtnTex(this.MountButton)
			if self.modBtns then
				if self.isMnln then
					self:skinStdButton{obj=this.BottomLeftInset.SuppressedMountEquipmentButton, fType=ftype}
				else
					self:skinStdButton{obj=_G.MountJournalFilterButton, fType=ftype}
				end
				self:skinStdButton{obj=this.MountButton, fType=ftype, sechk=true}
			end
			if self.modBtnBs then
				if self.isMnln then
					self:addButtonBorder{obj=this.ToggleDynamicFlightFlyoutButton, fType=ftype, rpA=true, ofs=4}
					this.ToggleDynamicFlightFlyoutButton:SetFrameLevel(10)
					self:addButtonBorder{obj=this.SlotButton, fType=ftype, relTo=this.SlotButton.ItemIcon}
				else
					self:addButtonBorder{obj=this.MountDisplay.ModelScene.RotateLeftButton, ofs=-3}
					self:addButtonBorder{obj=this.MountDisplay.ModelScene.RotateRightButton, ofs=-3}
				end
				if self.isMnln then
				self:addButtonBorder{obj=this.SummonRandomFavoriteSpellFrame.Button, fType=ftype, sft=true, ofs=3}
				end
				self:addButtonBorder{obj=this.MountDisplay.InfoButton, relTo=this.MountDisplay.InfoButton.Icon, clr="white"}
			end
			if self.modChkBtns
			and self.isMnln
			then
				self:skinCheckButton{obj=this.MountDisplay.ModelScene.TogglePlayer}
			end

			if self.isMnln then
				self:SecureHookScript(this.DynamicFlightFlyoutPopup, "OnShow", function(fObj)
					self:skinObject("frame", {obj=fObj.Background, fType=ftype, kfs=true, ofs=5, y1=-2, y2=0})
					if self.modBtnBs then
						self:addButtonBorder{obj=fObj.OpenDynamicFlightSkillTreeButton, fType=ftype}
						self:addButtonBorder{obj=fObj.DynamicFlightModeButton, fType=ftype}
					end

					self:Unhook(fObj, "OnShow")
				end)
			end

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.MountJournal)

		self:SecureHookScript(_G.PetJournal, "OnShow", function(this)
			self:removeInset(this.PetCount)
			self:removeInset(this.LeftInset)
			self:removeInset(this.RightInset)
			self:skinMainHelpBtn(this)
			self:removeInset(this.PetCardInset)
			self:skinObject("ddbutton", {obj=this.FilterDropdown, fType=ftype, filter=true})
			self:skinObject("editbox", {obj=this.searchBox, fType=ftype, si=true})
			self:removeMagicBtnTex(this.SummonButton)
			if self.modBtns then
				self:skinStdButton{obj=this.SummonButton, sechk=true}
			end
			-- PetList
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
					aObj:removeRegions(element, {1, 4}) -- background, iconBorder
					aObj:changeTandC(element.dragButton.levelBG)
					if aObj.modBtnBs then
						aObj:addButtonBorder{obj=element, relTo=element.icon, reParent={element.dragButton.levelBG, element.dragButton.level, element.dragButton.favorite}, clr=element.iconBorder:GetVertexColor()}
					end
				end
			end
			_G.ScrollUtil.AddAcquiredFrameCallback(this.ScrollBox, skinElement, aObj, true)
			self:keepFontStrings(this.loadoutBorder)
			self:moveObject{obj=this.loadoutBorder, y=8} -- battle pet slots title
			-- Pet LoadOut Plates
			local lop
			for i = 1, 3 do
				lop = this.Loadout["Pet" .. i]
				self:removeRegions(lop, {1, 2, 5})
				-- use module function here to force creation
		        self.modUIBtns:addButtonBorder{obj=lop, relTo=lop.icon, reParent={lop.levelBG, lop.level, lop.favorite}, clr="disabled"}
				self:changeTandC(lop.levelBG)
				self:keepFontStrings(lop.helpFrame)
				lop.healthFrame.healthBar:DisableDrawLayer("OVERLAY")
				self:skinObject("statusbar", {obj=lop.healthFrame.healthBar, fi=0})
				self:skinObject("statusbar", {obj=lop.xpBar, regions={2, 3, 4, 5, 6, 7, 8, 9, 10, 11}, fi=0})
				self:skinObject("frame", {obj=lop, fType=ftype, fb=true, x1=-4, y1=0, y2=-4})
				for j = 1, 3 do
					self:removeRegions(lop["spell" .. j], {1, 3}) -- background, blackcover
					if self.modBtnBs then
						self:addButtonBorder{obj=lop["spell" .. j], relTo=lop["spell" .. j].icon, reParent={lop["spell" .. j].FlyoutArrow}, clr="disabled"}
					end
				end
			end
			-- PetCard
			local pc = this.PetCard
			self:changeTandC(pc.PetInfo.levelBG)
			pc.PetInfo.qualityBorder:SetAlpha(0)
			self:skinObject("statusbar", {obj=pc.HealthFrame.healthBar, regions={1, 2, 3}, fi=0})
			self:skinObject("statusbar", {obj=pc.xpBar, regions={2, 3, 4, 5, 6, 7, 8, 9, 10, 11}, fi=0})
			self:skinObject("frame", {obj=pc, fType=ftype, kfs=true, fb=true, ofs=4})
			for i = 1, 6 do
				pc["spell" .. i].BlackCover:SetAlpha(0) -- N.B. texture is changed in code
				if self.modBtnBs then
					self:addButtonBorder{obj=pc["spell" .. i], relTo=pc["spell" .. i].icon}
				end
			end
			self:removeMagicBtnTex(this.FindBattleButton)
			self:removeRegions(this.AchievementStatus, {1, 2})
			if self.modBtns then
				self:skinStdButton{obj=this.FindBattleButton}
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=pc.PetInfo, relTo=pc.PetInfo.icon, reParent={pc.PetInfo.levelBG, pc.PetInfo.level, pc.PetInfo.favorite}}
				self:addButtonBorder{obj=this.HealPetSpellFrame.Button, fType=ftype, sft=true, ofs=4}
				self:addButtonBorder{obj=this.SummonRandomPetSpellFrame.Button, fType=ftype, sft=true, ofs=4}
				self:SecureHook("PetJournal_UpdatePetLoadOut", function()
					for i = 1, 3 do
						self:clrButtonFromBorder(_G.PetJournal.Loadout["Pet" .. i], "qualityBorder")
					end
				end)
				self:SecureHook("PetJournal_UpdatePetCard", function(fObj)
					self:clrButtonFromBorder(fObj.PetInfo, "qualityBorder")
				end)
			end

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.PetJournal)

		local function skinTTip(tip)
			tip.Delimiter1:SetTexture(nil)
			tip.Delimiter2:SetTexture(nil)
			tip:DisableDrawLayer("BACKGROUND")
			aObj:skinObject("frame", {obj=tip, fType=ftype, ofs=0})
		end
		if not self.isFrvr then
			skinTTip(_G.PetJournalPrimaryAbilityTooltip)
			skinTTip(_G.PetJournalSecondaryAbilityTooltip)
		end

		local skinCollectionBtn
		if self.modBtnBs then
			function skinCollectionBtn(btn)
				if btn.sbb then
					if btn.slotFrameUncollected:IsShown() then
						aObj:clrBtnBdr(btn, "grey")
					else
						aObj:clrBtnBdr(btn)
					end
				end
			end
		end

		self:SecureHookScript(_G.ToyBox, "OnShow", function(this)
			self:removeRegions(this.progressBar, {2, 3})
			self:skinObject("statusbar", {obj=this.progressBar, fi=0})
			self:skinObject("editbox", {obj=this.searchBox, fType=ftype, si=true})
			self:skinObject("ddbutton", {obj=this.FilterDropdown, fType=ftype, filter=true})
			self:removeInset(this.iconsFrame)
			self:keepFontStrings(this.iconsFrame)
			local btn
			for i = 1, 18 do
				btn = this.iconsFrame["spellButton" .. i]
				btn.slotFrameCollected:SetTexture(nil)
				btn.slotFrameUncollected:SetTexture(nil)
				if self.modBtnBs then
					self:addButtonBorder{obj=btn, reParent={btn.new}, sft=true, ofs=0}
				end
			end
			if self.modBtns then
				self:skinStdButton{obj=_G.ToyBoxFilterButton, fType=ftype}
			end
			if self.modBtnBs then
				self:skinPageBtns(this)
				self:SecureHook("ToySpellButton_UpdateButton", function(fObj)
					skinCollectionBtn(fObj)
				end)
			end

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.ToyBox)

		self:SecureHookScript(_G.HeirloomsJournal, "OnShow", function(this)
			self:skinObject("statusbar", {obj=this.progressBar, fi=0})
			self:removeRegions(this.progressBar, {2, 3})
			self:skinObject("editbox", {obj=this.SearchBox, fType=ftype, si=true})
			self:skinObject("ddbutton", {obj=this.FilterDropdown, fType=ftype, filter=true})
			self:skinObject("ddbutton", {obj=this.ClassDropdown, fType=ftype})
			self:removeInset(this.iconsFrame)
			self:keepFontStrings(this.iconsFrame)
			-- 18 icons per page ?
			self:SecureHook(this, "LayoutCurrentPage", function(fObj)
				for _, frame in _G.pairs(fObj.heirloomHeaderFrames) do
					frame:DisableDrawLayer("BACKGROUND")
					frame.text:SetTextColor(self.HT:GetRGB())
				end
				for _, frame in _G.pairs(fObj.heirloomEntryFrames) do
					frame.slotFrameCollected:SetTexture(nil)
					frame.slotFrameUncollected:SetTexture(nil)
					-- ignore btn.levelBackground as its texture is changed when upgraded
					if self.modBtnBs then
						self:addButtonBorder{obj=frame, sft=true, ofs=0, reParent={frame.new, frame.levelBackground, frame.level}}
						skinCollectionBtn(frame)
					end
				end
			end)
			if self.modBtns then
				if not self.isMnln then
					self:skinStdButton{obj=this.FilterButton, fType=ftype}
				end
			end
			if self.modBtnBs then
				self:skinPageBtns(this)
				if self.isMnln then
					self:SecureHook(this, "UpdateButton", function(_, button)
						skinCollectionBtn(button)
						if button.levelBackground:GetAtlas() == "collections-levelplate-black" then
							self:changeTandC(button.levelBackground)
						end
					end)
				end
			end

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.HeirloomsJournal)

		-- a.k.a. Appearances
		self:SecureHookScript(_G.WardrobeCollectionFrame, "OnShow", function(this)
			if self.isMnln then
				this.InfoButton.Ring:SetTexture(nil)
			end
			self:skinObject("ddbutton", {obj=this.FilterButton, fType=ftype, filter=true})
			self:skinObject("ddbutton", {obj=this.ClassDropdown, fType=ftype})
			self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true, upwards=true, offsets={x1=2, y1=-4, x2=-2, y2=-4}})
			self:skinObject("editbox", {obj=this.searchBox, fType=ftype, si=true})
			_G.RaiseFrameLevelByTwo(this.searchBox) -- raise above SetsCollectionFrame when displayed on it
			self:skinObject("statusbar", {obj=this.progressBar, fi=0})
			self:removeRegions(this.progressBar, {2, 3})
			if self.modBtns then
				if not self.isMnln then
					self:skinStdButton{obj=this.FilterButton, fType=ftype}
					_G.RaiseFrameLevelByTwo(this.FilterButton) -- raise above SetsCollectionFrame when displayed on it
				end
			end
			local x1Ofs, y1Ofs, x2Ofs, y2Ofs = -4, 2, 7, -5

			if _G.C_AddOns.IsAddOnLoaded("BetterWardrobe") then
				self.callbacks:Fire("WardrobeCollectionFrame_OnShow")
			else
				local function updBtnClr(btn)
					local atlas = btn.Border:GetAtlas()
					if atlas:find("uncollected", 1, true) then
						aObj:clrBtnBdr(btn, "grey")
					elseif atlas:find("unusable", 1, true) then
						aObj:clrBtnBdr(btn, "unused")
					else
						aObj:clrBtnBdr(btn, "gold", 0.75)
					end
				end
				self:SecureHookScript(this.ItemsCollectionFrame, "OnShow", function(fObj)
					self:skinObject("ddbutton", {obj=fObj.WeaponDropdown, fType=ftype})
					self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, rns=true, fb=true, x1=x1Ofs, y1=y1Ofs, x2=x2Ofs, y2=y2Ofs})
					if self.modBtnBs then
						self:skinPageBtns(fObj)
						for _, btn in _G.pairs(fObj.Models) do
							self:removeRegions(btn, {2}) -- background & border
							self:addButtonBorder{obj=btn, reParent={btn.NewString, btn.Favorite.Icon, btn.HideVisual.Icon}, ofs=6}
							updBtnClr(btn)
						end
						self:SecureHook(fObj, "UpdateItems", function(icF)
							for _, btn in _G.pairs(icF.Models) do
								updBtnClr(btn)
							end
						end)
					end

					self:Unhook(fObj, "OnShow")
				end)
				self:checkShown(this.ItemsCollectionFrame)

				-- colour code copied from Blizzard_Wardrobe_Sets.lua
				local IN_PROGRESS_FONT_COLOR = _G.CreateColor(0.251, 0.753, 0.251)
				local SetsDataProvider = _G.CreateFromMixins(_G.WardrobeSetsDataProviderMixin)
				self:SecureHookScript(this.SetsCollectionFrame, "OnShow", function(fObj)
					self:removeInset(fObj.LeftInset)
					self:keepFontStrings(fObj.RightInset)
					self:removeNineSlice(fObj.RightInset.NineSlice)
					self:skinObject("scrollbar", {obj=fObj.ListContainer.ScrollBar, fType=ftype})
					local displayData, variantSets, topSourcesCollected, topSourcesTotal, setCollected, colour
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
							element:DisableDrawLayer("BACKGROUND")
							if aObj.modBtnBs then
								 aObj:addButtonBorder{obj=element.IconFrame, fType=ftype, relTo=element.IconFrame.Icon, reParent={element.IconFrame.Favorite}}
							end
						end
						displayData = elementData
						if elementData.hiddenUntilCollected
						and not elementData.collected
						then
							variantSets = _G.C_TransmogSets.GetVariantSets(elementData.setID)
							if variantSets then
								displayData = variantSets[1]
							end
						end
						topSourcesCollected, topSourcesTotal = SetsDataProvider:GetSetSourceTopCounts(displayData.setID)
						setCollected = displayData.collected or topSourcesCollected == topSourcesTotal
						colour = topSourcesCollected == 0 and _G.GRAY_FONT_COLOR or IN_PROGRESS_FONT_COLOR
						if element.IconFrame.sbb then
							if setCollected then
								aObj:clrBtnBdr(element.IconFrame, "gold")
								element.Label:SetTextColor(aObj.BT:GetRGB())
							else
								aObj:clrBtnBdr(element.IconFrame, topSourcesCollected == 0 and "grey")
								element.Label:SetTextColor(colour.r, colour.g, colour.b)
							end
						end
					end
					_G.ScrollUtil.AddAcquiredFrameCallback(fObj.ListContainer.ScrollBox, skinElement, aObj, true)
					fObj.DetailsFrame:DisableDrawLayer("BACKGROUND")
					fObj.DetailsFrame:DisableDrawLayer("BORDER")
					self:skinObject("ddbutton", {obj=fObj.DetailsFrame.VariantSetsDropdown, fType=ftype})
					self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, fb=true, x1=x1Ofs, y1=y1Ofs, x2=x2Ofs, y2=y2Ofs})

					self:Unhook(fObj, "OnShow")
				end)
				if not self.isMorCorF then
					self:SecureHookScript(this.SetsTransmogFrame, "OnShow", function(fObj)
						self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, rns=true, fb=true, x1=x1Ofs, y1=y1Ofs, x2=x2Ofs, y2=y2Ofs})
						if self.modBtnBs then
							self:skinPageBtns(fObj)
							for _, btn in _G.pairs(fObj.Models) do
								self:removeRegions(btn, {2}) -- background & border
								self:addButtonBorder{obj=btn, fType=ftype, reParent={btn.Favorite.Icon}, ofs=6}
								updBtnClr(btn)
							end
						end

						self:Unhook(fObj, "OnShow")
					end)
				end
			end

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.WardrobeCollectionFrame)

		if not self.isMorCorF then
			self:SecureHookScript(_G.WardrobeFrame, "OnShow", function(this)
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, rns=true, cb=true, x2=3, y2=-1})

				self:Unhook(this, "OnShow")
			end)
			self:checkShown(_G.WardrobeFrame)
			-- used by Transmog as well as Appearance
			self:SecureHookScript(_G.WardrobeTransmogFrame, "OnShow", function(this)
				this:DisableDrawLayer("ARTWORK")
				self:removeInset(this.Inset)
				self:skinObject("ddbutton", {obj=this.OutfitDropdown, fType=ftype})
				if self.isMnln then
					this.ModelScene.ControlFrame:DisableDrawLayer("BACKGROUND")
				end
				for _, btn in _G.pairs(this.SlotButtons) do
					btn.Border:SetTexture(nil)
					if self.isClsc then
						btn.StatusBorder:SetTexture(nil)
						btn.HiddenVisualCover:SetScale(0.8) -- make it fit within button border
					end
					if self.modBtnBs then
						 self:addButtonBorder{obj=btn, fType=ftype, ofs=-1}
					end
				end
				self:skinObject("ddbutton", {obj=this.SpecDropdown, fType=ftype, noSF=true})
				if self.modBtns then
					self:skinStdButton{obj=this.OutfitDropdown.SaveButton, sechk=true}
					self:skinStdButton{obj=this.ApplyButton, fType=ftype, ofs=0, sechk=true}
				end
				if self.modBtnBs then
					if self.isMnln then
						self:addButtonBorder{obj=this.ModelScene.ClearAllPendingButton, fType=ftype, relTo=this.ModelScene.ClearAllPendingButton.Icon, ofs=5}
					elseif self.isClsc then
						self:addButtonBorder{obj=this.Model.ClearAllPendingButton, fType=ftype, relTo=this.Model.ClearAllPendingButton.Icon}
					end
				end
				if self.modChkBtns then
					self:skinCheckButton{obj=this.ToggleSecondaryAppearanceCheckbox, fType=ftype}
				end

				self:Unhook(this, "OnShow")
			end)
			self:checkShown(_G.WardrobeTransmogFrame)
		end

		if self.isMnln then
			-- a.k.a. Campsites
			self:SecureHookScript(_G.WarbandSceneJournal, "OnShow", function(this)
				self:removeInset(this.IconsFrame)
				self:keepFontStrings(this.IconsFrame)
				for _, view in _G.pairs(this.IconsFrame.Icons.ViewFrames) do
					for _, child in _G.ipairs_reverse{view:GetChildren()} do
						child.Border:SetTexture(nil)
						self:skinObject("frame", {obj=child, fType=ftype, fb=true, ofs=4, x1=-3, clr="grey"})
					end
				end
				self:skinPageBtns(this.IconsFrame.Icons.Controls)
				if self.modChkBtns then
					self:skinCheckButton{obj=this.IconsFrame.Icons.Controls.ShowOwned.Checkbox, fType=ftype, size=24}
				end

				self:Unhook(this, "OnShow")
			end)
			self:checkShown(_G.WarbandSceneJournal)
		end

		if self.isClsc
		and _G.C_AddOns.IsAddOnLoaded("MountsJournal")
		then
			self.callbacks:Fire("Collections_Skinned")
		end

	end
end

if aObj.isMorF then
	aObj.blizzFrames[ftype].ContainerFrames = function(self)
		if _G.C_AddOns.IsAddOnLoaded("LiteBag") then
			self.blizzFrames[ftype].ContainerFrames = nil
			return
		end

		if not self.prdb.ContainerFrames.skin or self.initialized.ContainerFrames then return end
		self.initialized.ContainerFrames = true

		local function skinBag(frame, id)
			aObj:skinObject("frame", {obj=frame, fType=ftype, kfs=true, cbns=true})
			-- Add gear texture to portrait button for settings
			local cfpb = frame.PortraitButton
			cfpb.gear = cfpb:CreateTexture(nil, "artwork")
			cfpb.gear:SetTexture(self.tFDIDs.gearWhl)
			cfpb.gear:SetPoint("TOPLEFT", frame, "TOPLEFT", 3, -3)
			cfpb:SetSize(18, 18)
			cfpb.Highlight:ClearAllPoints()
			cfpb.Highlight:SetPoint("center")
			cfpb.Highlight:SetSize(22, 22)
			aObj:SecureHook(frame, "UpdateItems", function(this)
				aObj:skinItemSlots(this, ftype)
			end)
			aObj:skinItemSlots(frame, ftype)
			-- Backpack
			if id == 0 then
				aObj:skinObject("editbox", {obj=_G.BagItemSearchBox, fType=ftype, si=true, ca=true})
				frame.MoneyFrame.Border:DisableDrawLayer("BACKGROUND")
				if aObj.modBtnBs then
					aObj:addButtonBorder{obj=_G.BagItemAutoSortButton, ofs=0, y1=1}
				end
			end
		end

		self:SecureHook("ContainerFrame_GenerateFrame", function(frame, _, id)
			-- skin the frame if required
			if not frame.sf then
				-- handle in combat
				if _G.InCombatLockdown() then
				    self:add2Table(self.oocTab, {skinBag, {frame, id}})
				    return
				else
					skinBag(frame, id)
				end
			end
		end)

		if _G.ContainerFrameSettingsManager.TokenTracker then
			_G.ContainerFrameSettingsManager.TokenTracker.Border:DisableDrawLayer("BACKGROUND")
		end

	end
end

aObj.blizzLoDFrames[ftype].Communities = function(self)
	if not self.prdb.Communities or self.initialized.Communities then return end

	--> N.B.these frames can't be skinned, as the XML has a ScopedModifier element saying forbidden="true"
		-- CommunitiesAddDialog
		-- CommunitiesCreateDialog

	if not _G.CommunitiesFrame then
		_G.RunNextFrame(function()
			self.blizzLoDFrames[ftype].Communities(self)
		end)
		return
	end

	self.initialized.Communities = true

	self:SecureHookScript(_G.CommunitiesFrame, "OnShow", function(this)
		self:keepFontStrings(this.PortraitOverlay)
		local tabs = {"ChatTab", "RosterTab", "GuildBenefitsTab", "GuildInfoTab", self.isFrvr and "GuildPreferredPlaySettingsTab"}
		for _, tabName in _G.pairs(tabs) do
			this[tabName]:DisableDrawLayer("BORDER")
			if self.modBtnBs then
				self:addButtonBorder{obj=this[tabName]}
			end
		end
		self:moveObject{obj=this.ChatTab, x=1}
		self:skinObject("ddbutton", {obj=this.StreamDropdown, fType=ftype})
		self:skinObject("ddbutton", {obj=this.GuildMemberListDropdown, fType=ftype})
		self:skinObject("ddbutton", {obj=this.CommunityMemberListDropdown, fType=ftype})
		-- .CommunitiesCalendarButton
		self:skinObject("ddbutton", {obj=this.CommunitiesListDropdown, fType=ftype})
		self:skinObject("editbox", {obj=this.ChatEditBox, fType=ftype, y1=-6, y2=6})
		self:moveObject{obj=this.AddToChatButton, x=-6, y=-6}
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true, x1=-5, x2=self.isFrvr and 4})
		if self.modBtns then
			self:skinStdButton{obj=this.InviteButton, fType=ftype, sechk=true}
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=this.AddToChatButton, ofs=1, clr="gold"}
			self:skinStdButton{obj=this.GuildLogButton, fType=ftype}
		end

		self:SecureHookScript(this.MaximizeMinimizeFrame, "OnShow", function(fObj)
			fObj:DisableDrawLayer("BACKGROUND")
			if self.modBtns then
				self:skinOtherButton{obj=fObj.MaximizeButton, font=self.fontS, text=self.nearrow}
				self:skinOtherButton{obj=fObj.MinimizeButton, font=self.fontS, disfont=self.fontDS, text=self.swarrow}
				if self.modFCBtns then
					self:SecureHook(this, "UpdateMaximizeMinimizeButton", function(frame)
						self:clrBtnBdr(frame.MaximizeMinimizeFrame.MinimizeButton)
					end)
				end
			end

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.MaximizeMinimizeFrame)

		self:SecureHookScript(this.CommunitiesList, "OnShow", function(fObj)
			fObj:DisableDrawLayer("BORDER")
			fObj:DisableDrawLayer("ARTWORK")
			fObj.FilligreeOverlay:DisableDrawLayer("ARTWORK")
			fObj.FilligreeOverlay:DisableDrawLayer("OVERLAY")
			fObj.FilligreeOverlay:DisableDrawLayer("BORDER")
			self:removeInset(fObj.InsetFrame)
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
					aObj:removeRegions(element, {1})
					aObj:changeTex(element.Selection, true)
					element.Selection:SetHeight(60)
					element.IconRing:SetAlpha(0) -- texture changed in code
					aObj:changeTex(element:GetHighlightTexture())
					element:GetHighlightTexture():SetHeight(60)
				end
			end
			_G.ScrollUtil.AddAcquiredFrameCallback(fObj.ScrollBox, skinElement, aObj, true)

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.CommunitiesList)

		self:SecureHookScript(this.MemberList, "OnShow", function(fObj)
			self:removeInset(fObj.InsetFrame)
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
					aObj:removeRegions(element.ProfessionHeader, {1, 2, 3}) -- header textures
				end
			end
			_G.ScrollUtil.AddAcquiredFrameCallback(fObj.ScrollBox, skinElement, aObj, true)
			if self.modChkBtns then
				 self:skinCheckButton{obj=fObj.ShowOfflineButton, hf=true}
			end

			self:SecureHookScript(fObj.ColumnDisplay, "OnShow", function(frame)
				self:skinColumnDisplay(frame)
			end)
			self:checkShown(fObj.ColumnDisplay)

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.MemberList)

		self:SecureHookScript(this.Chat, "OnShow", function(fObj)
			self:removeInset(fObj.InsetFrame)
			self:skinObject("scrollbar", {obj=fObj.ScrollBar, fType=ftype})
			if self.modBtns then
				self:skinStdButton{obj=_G.JumpToUnreadButton, fType=ftype}
			end

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.Chat)

		self:SecureHookScript(this.InvitationFrame, "OnShow", function(fObj)
			self:removeInset(fObj.InsetFrame)
			fObj.IconRing:SetTexture(nil)
			self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, ofs=0})
			if self.modBtns then
				self:skinStdButton{obj=fObj.AcceptButton, fType=ftype}
				self:skinStdButton{obj=fObj.DeclineButton, fType=ftype}
			end

			self:Unhook(fObj, "OnShow")
		end)

		self:SecureHookScript(this.TicketFrame, "OnShow", function(fObj)
			self:removeInset(fObj.InsetFrame)
			fObj.IconRing:SetTexture(nil)
			self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, ofs=0})
			if self.modBtns then
				self:skinStdButton{obj=fObj.AcceptButton, fType=ftype}
				self:skinStdButton{obj=fObj.DeclineButton, fType=ftype}
			end

			self:Unhook(fObj, "OnShow")
		end)

		self:SecureHookScript(this.EditStreamDialog, "OnShow", function(fObj)
			self:removeNineSlice(fObj.BG)
			self:skinObject("editbox", {obj=fObj.NameEdit, fType=ftype, y1=-4, y2=4})
			fObj.NameEdit:SetPoint("TOPLEFT", fObj.NameLabel, "BOTTOMLEFT", -4, 0)
			self:skinObject("frame", {obj=fObj.Description, fType=ftype, kfs=true, fb=true, ofs=7})
			self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true})
			if self.modBtns then
				self:skinStdButton{obj=fObj.Accept, fType=ftype, sechk=true}
				self:skinStdButton{obj=fObj.Delete, fType=ftype}
				self:skinStdButton{obj=fObj.Cancel, fType=ftype}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=fObj.TypeCheckbox or fObj.TypeCheckBox, fType=ftype}
			end

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.EditStreamDialog)

		self:SecureHookScript(this.NotificationSettingsDialog, "OnShow", function(fObj)
			self:skinObject("ddbutton", {obj=fObj.CommunitiesListDropdown, fType=ftype})
			self:skinObject("scrollbar", {obj=fObj.ScrollFrame.ScrollBar, fType=ftype})
			self:removeNineSlice(fObj.Selector)
			self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, ofs=-6, x2=self.isMnln and -4 or 2})
			if self.modBtns then
				self:skinStdButton{obj=fObj.ScrollFrame.Child.NoneButton}
				self:skinStdButton{obj=fObj.ScrollFrame.Child.AllButton}
				self:skinStdButton{obj=fObj.Selector.CancelButton}
				self:skinStdButton{obj=fObj.Selector.OkayButton}
			end
			if self.modChkBtns then
				 self:skinCheckButton{obj=fObj.ScrollFrame.Child.QuickJoinButton}
			end

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.NotificationSettingsDialog)

		self:SecureHookScript(this.CommunitiesControlFrame, "OnShow", function(fObj)
			if self.modBtns then
				self:skinStdButton{obj=fObj.CommunitiesSettingsButton, fType=ftype, sechk=true}
				self:skinStdButton{obj=fObj.GuildRecruitmentButton, fType=ftype, sechk=true}
				self:skinStdButton{obj=fObj.GuildControlButton, fType=ftype}
			end

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.CommunitiesControlFrame)

		self:SecureHookScript(this.ApplicantList, "OnShow", function(fObj)
			fObj:DisableDrawLayer("BACKGROUND")
			fObj:DisableDrawLayer("ARTWORK")
			self:skinObject("scrollbar", {obj=fObj.ScrollBar, fType=ftype})
			self:removeNineSlice(fObj.InsetFrame.NineSlice)
			fObj.InsetFrame.Bg:SetTexture(nil)
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
						aObj:skinStdButton{obj=element.CancelInvitationButton}
						aObj:skinStdButton{obj=element.InviteButton}
					end
				end
			end
			_G.ScrollUtil.AddAcquiredFrameCallback(fObj.ScrollBox, skinElement, aObj, true)

			self:SecureHookScript(fObj.ColumnDisplay, "OnShow", function(frame)
				self:skinColumnDisplay(frame)
			end)
			self:checkShown(fObj.ColumnDisplay)

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.ApplicantList)

		local function skinReqToJoin(frame)
			frame.MessageFrame:DisableDrawLayer("BACKGROUND")
			frame.MessageFrame.MessageScroll:DisableDrawLayer("BACKGROUND")
			aObj:skinObject("frame", {obj=frame.MessageFrame, fType=ftype, kfs=true, fb=true, ofs=4})
			aObj:skinObject("frame", {obj=frame.BG, fType=ftype, kfs=true})
			if aObj.modBtns then
				 aObj:skinStdButton{obj=frame.Apply}
				 aObj:skinStdButton{obj=frame.Cancel}
				 aObj:SecureHook(frame, "EnableOrDisableApplyButton", function(fObj)
					 aObj:clrBtnBdr(fObj.Apply, "", 1)
				 end)
			end
			if aObj.modChkBtns then
				aObj:SecureHook(frame, "Initialize", function(fObj)
					for spec in fObj.SpecsPool:EnumerateActive() do
						aObj:skinCheckButton{obj=spec.Checkbox or spec.CheckBox, fType=ftype}
					end
				end)
			end
		end
		local function skinCFGaCF(frame)
			frame:DisableDrawLayer("BACKGROUND")
			aObj:skinObject("ddbutton", {obj=frame.OptionsList.ClubFilterDropdown, fType=ftype})
			aObj:skinObject("ddbutton", {obj=frame.OptionsList.ClubSizeDropdown, fType=ftype})
			aObj:skinObject("ddbutton", {obj=frame.OptionsList.SortByDropdown, fType=ftype})
			aObj:skinObject("editbox", {obj=frame.OptionsList.SearchBox, fType=ftype, si=true, y1=-6, y2=6})
			aObj:moveObject{obj=frame.OptionsList.Search, x=3, y=-4}
			if aObj.modBtns then
				aObj:skinStdButton{obj=frame.OptionsList.Search}
			end
			if aObj.modChkBtns then
				aObj:skinCheckButton{obj=frame.OptionsList.TankRoleFrame.Checkbox or frame.OptionsList.TankRoleFrame.CheckBox, fType=ftype}
				aObj:skinCheckButton{obj=frame.OptionsList.HealerRoleFrame.Checkbox or frame.OptionsList.HealerRoleFrame.CheckBox, fType=ftype}
				aObj:skinCheckButton{obj=frame.OptionsList.DpsRoleFrame.Checkbox or frame.OptionsList.DpsRoleFrame.CheckBox, fType=ftype}
			end

			for _, btn in _G.pairs(frame.GuildCards.Cards) do
				btn:DisableDrawLayer("BACKGROUND")
				aObj:skinObject("frame", {obj=btn, fType=ftype, y1=5})
				if aObj.modBtns then
					aObj:skinStdButton{obj=btn.RequestJoin}
				end
				aObj:SecureHook(btn, "SetDisabledState", function(fObj, shouldDisable)
					if shouldDisable then
						aObj:clrBBC(fObj.sf, "disabled")
					else
						aObj:clrBBC(fObj.sf, "gold")
					end
				end)
			end
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=frame.GuildCards.PreviousPage, ofs=-2, y1=-3, x2=-3, clr="disabled"}
				aObj:addButtonBorder{obj=frame.GuildCards.NextPage, ofs=-2, y1=-3, x2=-3, clr="disabled"}
			end

			aObj:skinObject("scrollbar", {obj=frame.CommunityCards.ScrollBar, fType=ftype})
			local function skinCardElement(...)
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
					element.LogoBorder:SetTexture(nil)
					aObj:skinObject("frame", {obj=element, fType=ftype, ofs=3, x2=-10})
				end
			end
			_G.ScrollUtil.AddAcquiredFrameCallback(frame.CommunityCards.ScrollBox, skinCardElement, aObj, true)

			for _, btn in _G.pairs(frame.PendingGuildCards.Cards) do
				btn:DisableDrawLayer("BACKGROUND")
				aObj:skinObject("frame", {obj=btn, fType=ftype, y1=5})
				if aObj.modBtns then
					aObj:skinStdButton{obj=btn.RequestJoin}
				end
				aObj:SecureHook(btn, "SetDisabledState", function(fObj, shouldDisable)
					if shouldDisable then
						aObj:clrBBC(fObj.sf, "disabled")
					else
						aObj:clrBBC(fObj.sf, "gold")
					end
				end)
			end
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=frame.PendingGuildCards.PreviousPage, ofs=-2, y1=-3, x2=-3, clr="gold"}
				aObj:addButtonBorder{obj=frame.PendingGuildCards.NextPage, ofs=-2, y1=-3, x2=-3, clr="gold"}
			end

			aObj:skinObject("scrollbar", {obj=frame.PendingCommunityCards.ScrollBar, fType=ftype})
			local function skinPendingElement(...)
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
					element.LogoBorder:SetTexture(nil)
					aObj:skinObject("frame", {obj=element, fType=ftype, ofs=3, x2=-10})
				end
			end
			_G.ScrollUtil.AddAcquiredFrameCallback(frame.PendingCommunityCards.ScrollBox, skinPendingElement, aObj, true)

			skinReqToJoin(frame.RequestToJoinFrame)

			aObj:removeInset(frame.InsetFrame)
			frame.InsetFrame.Bg:SetTexture(nil)
			aObj:removeInset(frame.DisabledFrame)
			frame.DisabledFrame:DisableDrawLayer("BACKGROUND")

			-- Tabs (RHS)
			aObj:moveObject{obj=frame.ClubFinderSearchTab, x=1}
			aObj:removeRegions(frame.ClubFinderSearchTab, {1})
			aObj:removeRegions(frame.ClubFinderPendingTab, {1})
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=frame.ClubFinderSearchTab}
				aObj:addButtonBorder{obj=frame.ClubFinderPendingTab}
				aObj:SecureHook(frame, "UpdatePendingTab", function(fObj)
					aObj:clrBtnBdr(fObj.ClubFinderPendingTab)
				end)
			end
		end

		self:SecureHookScript(this.GuildFinderFrame, "OnShow", function(fObj)
			skinCFGaCF(fObj)
			if self.modBtnBs then
				self:SecureHook(fObj.GuildCards, "RefreshLayout", function(frame, _)
					self:clrBtnBdr(frame.PreviousPage, "gold")
					self:clrBtnBdr(frame.NextPage, "gold")
				end)
			end

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.GuildFinderFrame)

		self:SecureHookScript(this.CommunityFinderFrame, "OnShow", function(fObj)
			skinCFGaCF(fObj)

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.CommunityFinderFrame)

		self:SecureHookScript(this.ClubFinderInvitationFrame, "OnShow", function(fObj)
			fObj.WarningDialog.BG.Bg:SetTexture(nil)
			self:removeNineSlice(fObj.WarningDialog.BG)
			self:skinObject("frame", {obj=fObj.WarningDialog, fType=ftype, kfs=true, ofs=0})
			if self.modBtns then
				self:skinStdButton{obj=fObj.WarningDialog.Accept, fType=ftype}
				self:skinStdButton{obj=fObj.WarningDialog.Cancel, fType=ftype}
			end
			self:removeInset(fObj.InsetFrame)
			fObj.IconRing:SetTexture(nil)
			self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, ofs=0})
			if self.modBtns then
				self:skinStdButton{obj=fObj.AcceptButton, fType=ftype}
				self:skinStdButton{obj=fObj.ApplyButton, fType=ftype, sechk=true}
				self:skinStdButton{obj=fObj.DeclineButton, fType=ftype}
			end

			self:Unhook(fObj, "OnShow")
		end)

		self:SecureHookScript(this.GuildBenefitsFrame, "OnShow", function(fObj)
			fObj:DisableDrawLayer("OVERLAY")
			self:keepFontStrings(fObj.Perks)
			self:skinObject("scrollbar", {obj=fObj.Perks.ScrollBar, fType=ftype})
			local function skinPerk(...)
				local _, element
				if _G.select("#", ...) == 2 then
					element, _ = ...
				else
					_, element, _ = ...
				end
				aObj:keepFontStrings(element)
				element.Icon:SetAlpha(1)
				if aObj.modBtnBs then
					aObj:addButtonBorder{obj=element, fType=ftype, relTo=element.Icon, clr="white"}
				end
				aObj:keepFontStrings(element.NormalBorder)
				aObj:keepFontStrings(element.DisabledBorder)
			end
			_G.ScrollUtil.AddInitializedFrameCallback(fObj.Perks.ScrollBox, skinPerk, aObj, true)
			self:keepFontStrings(fObj.Rewards)
			self:skinObject("scrollbar", {obj=fObj.Rewards.ScrollBar, fType=ftype})
			local function skinReward(...)
				local _, element
				if _G.select("#", ...) == 2 then
					element, _ = ...
				else
					_, element, _ = ...
				end
				aObj:skinObject("frame", {obj=element, fType=ftype, kfs=true, clr="sepia"})
				element.Icon:SetAlpha(1)
				if aObj.modBtnBs then
					aObj:addButtonBorder{obj=element, fType=ftype, relTo=element.Icon}
					-- colour based on guild reputation level
					if element.sbb then
						if element.Icon:IsDesaturated() then
							aObj:clrBBC(element.sbb, "disabled")
						else
							element.sbb:SetBackdropBorderColor(element.Icon:GetVertexColor())
						end
					end
				end
			end
			_G.ScrollUtil.AddInitializedFrameCallback(fObj.Rewards.ScrollBox, skinReward, aObj, true)
			fObj.FactionFrame.Bar:DisableDrawLayer("BORDER")
			fObj.FactionFrame.Bar.Progress:SetTexture(self.sbTexture)

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.GuildBenefitsFrame)

		self:SecureHookScript(this.GuildDetailsFrame, "OnShow", function(fObj)
			fObj:DisableDrawLayer("OVERLAY")
			self:removeRegions(fObj.Info, {2, 3, 4, 5, 6, 7, 8, 9, 10})
			self:skinObject("scrollbar", {obj=fObj.Info.MOTDScrollFrame.ScrollBar, fType=ftype})
			self:skinObject("scrollbar", {obj=fObj.Info.DetailsFrame.ScrollBar, fType=ftype})
			fObj.News:DisableDrawLayer("BACKGROUND")
			self:skinObject("scrollbar", {obj=fObj.News.ScrollBar, fType=ftype})
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
					element.header:SetTexture(nil)
				end
			end
			_G.ScrollUtil.AddAcquiredFrameCallback(fObj.News.ScrollBox, skinElement, aObj, true)
			self:keepFontStrings(fObj.News.BossModel)
			self:removeRegions(fObj.News.BossModel.TextFrame, {2, 3, 4, 5, 6}) -- border textures

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.GuildDetailsFrame)

		if self.isFrvr then
			self:SecureHookScript(this.GuildPreferredPlaySettingsFrame, "OnShow", function(fObj)
				self:skinObject("ddbutton", {obj=fObj.LocaleDropdown, fType=ftype})
				self:skinObject("ddbutton", {obj=fObj.DatacenterDropdown, fType=ftype})
				if self.modBtns then
					self:skinStdButton{obj=fObj.LocaleApplyButton, fType=ftype, sechk=true}
					self:skinStdButton{obj=fObj.DatacenterApplyButton, fType=ftype, sechk=true}
				end

				self:Unhook(this.GuildPreferredPlaySettingsFrame, "OnShow")
			end)
			self:checkShown(this.GuildPreferredPlaySettingsFrame)
		end

		self:SecureHookScript(this.GuildNameAlertFrame, "OnShow", function(fObj)
			self:skinObject("glowbox", {obj=fObj, fType=ftype})

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.GuildNameAlertFrame)

		self:SecureHookScript(this.GuildNameChangeFrame, "OnShow", function(fObj)
			fObj:DisableDrawLayer("BACKGROUND")
			self:skinObject("editbox", {obj=fObj.EditBox, fType=ftype})
			if self.modBtns then
				self:skinStdButton{obj=fObj.Button}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=fObj.CloseButton}
			end

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.GuildNameChangeFrame)

		self:SecureHookScript(this.CommunityNameChangeFrame, "OnShow", function(fObj)
			self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, cbns=true, ofs=0})
			if self.modBtns then
				self:skinStdButton{obj=fObj.Button, fType=ftype}
			end

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.CommunityNameChangeFrame)

		self:SecureHookScript(this.GuildPostingChangeFrame, "OnShow", function(fObj)
			self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, cbns=true, ofs=0})
			if self.modBtns then
				self:skinStdButton{obj=fObj.Button, fType=ftype}
			end

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.GuildPostingChangeFrame)

		self:SecureHookScript(this.CommunityPostingChangeFrame, "OnShow", function(fObj)
			self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, cbns=true, ofs=0})
			if self.modBtns then
				self:skinStdButton{obj=fObj.Button, fType=ftype}
			end

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.CommunityPostingChangeFrame)

		self:SecureHookScript(this.RecruitmentDialog, "OnShow", function(fObj)
			self:skinObject("ddbutton", {obj=fObj.ClubFocusDropdown, fType=ftype})
			self:skinObject("ddbutton", {obj=fObj.LookingForDropdown, fType=ftype})
			self:skinObject("ddbutton", {obj=fObj.LanguageDropdown, fType=ftype})
			fObj.RecruitmentMessageFrame:DisableDrawLayer("BACKGROUND")
			fObj.RecruitmentMessageFrame.RecruitmentMessageInput:DisableDrawLayer("BACKGROUND")
			self:skinObject("frame", {obj=fObj.RecruitmentMessageFrame, fType=ftype, kfs=true, fb=true, ofs=3})
			self:skinObject("editbox", {obj=fObj.MinIlvlOnly.EditBox, fType=ftype})
			fObj.MinIlvlOnly.EditBox.Text:ClearAllPoints()
			fObj.MinIlvlOnly.EditBox.Text:SetPoint("Left", fObj.MinIlvlOnly.EditBox, "Left", 6, 0)
			self:skinObject("frame", {obj=fObj.BG, fType=ftype, kfs=true, ofs=0})
			if self.modBtns then
				self:skinStdButton{obj=fObj.Accept}
				self:skinStdButton{obj=fObj.Cancel}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=fObj.ShouldListClub.Button}
				self:skinCheckButton{obj=fObj.MaxLevelOnly.Button}
				self:skinCheckButton{obj=fObj.MinIlvlOnly.Button}
			end

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(this.RecruitmentDialog)

		-- N.B. hook DisplayMember rather than OnShow script
		self:SecureHook(this.GuildMemberDetailFrame, "DisplayMember", function(fObj, _)
			self:removeNineSlice(fObj.Border)
			self:skinObject("ddbutton", {obj=fObj.RankDropdown, fType=ftype})
			self:skinObject("frame", {obj=fObj.NoteBackground, fType=ftype, fb=true, ofs=0})
			self:skinObject("frame", {obj=fObj.OfficerNoteBackground, fType=ftype, fb=true, ofs=0})
			self:adjWidth{obj=fObj.RemoveButton, adj=-4}
			self:adjWidth{obj=fObj.GroupInviteButton, adj=-4}
			self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, cb=true, ofs=-5, x2=0})
			if self.modBtns then
				self:skinStdButton{obj=fObj.RemoveButton, fType=ftype, sechk=true}
				self:skinStdButton{obj=fObj.GroupInviteButton, fType=ftype, sechk=true}
			end

			self:Unhook(fObj, "DisplayMember")
		end)
		self:checkShown(this.GuildMemberDetailFrame)

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.CommunitiesFrame)

	self:SecureHookScript(_G.CommunitiesSettingsDialog, "OnShow", function(this)
		self:keepFontStrings(this.BG)
		this.IconPreviewRing:SetAlpha(0)
		self:skinObject("editbox", {obj=this.NameEdit, fType=ftype})
		self:skinObject("editbox", {obj=this.ShortNameEdit, fType=ftype})
		self:skinObject("frame", {obj=this.MessageOfTheDay, fType=ftype, kfs=true, fb=true, ofs=8})
		self:skinObject("frame", {obj=this.Description, fType=ftype, kfs=true, fb=true, ofs=8})
		self:skinObject("editbox", {obj=this.MinIlvlOnly.EditBox, fType=ftype})
		this.MinIlvlOnly.EditBox.Text:ClearAllPoints()
		this.MinIlvlOnly.EditBox.Text:SetPoint("Left", this.MinIlvlOnly.EditBox, "Left", 6, 0)
		self:skinObject("ddbutton", {obj=this.ClubFocusDropdown, fType=ftype, sechk=true})
		self:skinObject("ddbutton", {obj=this.LookingForDropdown, fType=ftype, sechk=true})
		self:skinObject("ddbutton", {obj=this.LanguageDropdown, fType=ftype, sechk=true})
		self:skinObject("frame", {obj=this, fType=ftype, ofs=-10})
		if self.modBtns then
			self:skinStdButton{obj=this.ChangeAvatarButton}
			self:skinStdButton{obj=this.Delete}
			self:skinStdButton{obj=this.Accept}
			self:skinStdButton{obj=this.Cancel}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=this.CrossFactionToggle.CheckButton, fType=ftype}
			self:skinCheckButton{obj=this.ShouldListClub.Button, fType=ftype}
			self:skinCheckButton{obj=this.AutoAcceptApplications.Button, fType=ftype, sechk=true}
			self:skinCheckButton{obj=this.MaxLevelOnly.Button, fType=ftype, sechk=true}
			self:skinCheckButton{obj=this.MinIlvlOnly.Button, fType=ftype, sechk=true}
		end

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.CommunitiesSettingsDialog)

	self:SecureHookScript(_G.CommunitiesAvatarPickerDialog, "OnShow", function(this)
		if self.isClscERA then
			this.ScrollFrame:DisableDrawLayer("BACKGROUND")
			if self.modBtnBs then
				for i = 1, 5 do
					for j = 1, 6 do
						self:addButtonBorder{obj=this.ScrollFrame.avatarButtons[i][j], fType=ftype}
					end
				end
			end
			if self.modBtns then
				self:skinStdButton{obj=this.CancelButton}
				self:skinStdButton{obj=this.OkayButton}
			end
		else
			self:removeNineSlice(this.Selector)
			self:skinObject("scrollbar", {obj=this.ScrollBar, fType=ftype})
			local function skinElement(...)
				local _, element
				if _G.select("#", ...) == 2 then
					element, _ = ...
				else
					_, element, _ = ...
				end
				if self.modBtnBs then
					self:addButtonBorder{obj=element, fType=ftype}
				end
			end
			_G.ScrollUtil.AddInitializedFrameCallback(this.ScrollBox, skinElement, aObj, true)
			if self.modBtns then
				self:skinStdButton{obj=this.Selector.CancelButton}
				self:skinStdButton{obj=this.Selector.OkayButton}
			end
		end
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ofs=-4})

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.CommunitiesAvatarPickerDialog)

	self:SecureHookScript(_G.CommunitiesTicketManagerDialog, "OnShow", function(this)
		self:skinObject("ddbutton", {obj=this.ExpiresDropdown, fType=ftype})
		self:skinObject("ddbutton", {obj=this.UsesDropdown, fType=ftype})
		this.InviteManager.ArtOverlay:DisableDrawLayer("OVERLAY")
		self:skinColumnDisplay(this.InviteManager.ColumnDisplay)
		self:skinObject("scrollbar", {obj=this.InviteManager.ScrollBar, fType=ftype})
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
				aObj:skinStdButton{obj=element.CopyLinkButton}
				if aObj.modBtnBs then
					 aObj:addButtonBorder{obj=element.RevokeButton, ofs=0}
				end
			end
		end
		_G.ScrollUtil.AddAcquiredFrameCallback(this.InviteManager.ScrollBox, skinElement, aObj, true)
		self:skinObject("frame", {obj=this.InviteManager, fType=ftype, kfs=true, fb=true, ofs=-4, x2=-5, y2=-5})
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, y1=-8, y2=6})
		if self.modBtns then
			self:skinStdButton{obj=this.LinkToChat, fType=ftype, sechk=true}
			self:skinStdButton{obj=this.Copy, fType=ftype, sechk=true}
			self:skinStdButton{obj=this.GenerateLinkButton}
			self:skinStdButton{obj=this.Close}
		end
		if self.modBtnBs then
			 self:addButtonBorder{obj=this.MaximizeButton, ofs=0, clr="gold"}
		end

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.CommunitiesTicketManagerDialog)

	self:SecureHookScript(_G.CommunitiesGuildTextEditFrame, "OnShow", function(this)
		self:skinObject("scrollbar", {obj=this.Container.ScrollFrame.ScrollBar, fType=ftype})
		self:skinObject("frame", {obj=this.Container, fType=ftype, kfs=true, fb=true})
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, ofs=-5})
		if self.modBtns then
			self:skinStdButton{obj=_G.CommunitiesGuildTextEditFrameAcceptButton}
			self:skinStdButton{obj=self:getChild(_G.CommunitiesGuildTextEditFrame, 4)} -- bottom close button, uses same name as previous CB
		end

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.CommunitiesGuildTextEditFrame)

	self:SecureHookScript(_G.CommunitiesGuildLogFrame, "OnShow", function(this)
		self:skinObject("scrollbar", {obj=this.Container.ScrollFrame.ScrollBar, fType=ftype})
		self:skinObject("frame", {obj=this.Container, fType=ftype, kfs=true, fb=true})
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, ofs=-5})
		if self.modBtns then
			 self:skinStdButton{obj=self:getChild(this, 3)} -- bottom close button
		end

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.CommunitiesGuildLogFrame)

	self:SecureHookScript(_G.CommunitiesGuildNewsFiltersFrame, "OnShow", function(this)
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, ofs=-5})
		if self.modChkBtns then
			self:skinCheckButton{obj=this.GuildAchievement}
			self:skinCheckButton{obj=this.Achievement}
			self:skinCheckButton{obj=this.DungeonEncounter}
			self:skinCheckButton{obj=this.EpicItemLooted}
			self:skinCheckButton{obj=this.EpicItemPurchased}
			self:skinCheckButton{obj=this.EpicItemCrafted}
			self:skinCheckButton{obj=this.LegendaryItemLooted}
		end

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.CommunitiesGuildNewsFiltersFrame)

end

aObj.blizzFrames[ftype].CompactFrames = function(self)
	-- handle AddOn being disabled
	if not self:checkLoadable("Blizzard_CompactRaidFrames") then
		aObj.blizzFrames[ftype].CompactFrames = nil
		return
	end

	if not self.prdb.CompactFrames.skin or self.initialized.CompactFrames then return end
	self.initialized.CompactFrames = true

	self:SecureHookScript(_G.CompactRaidFrameManager, "OnShow", function(this)
		if _G.InCombatLockdown() then
		    self:add2Table(self.oocTab, {self.checkShown, {self, this}})
		    return
		end

		if self.isMorF then
			_G.nop()
			-- TODO: skin Toggle button texture
			-- .toggleButtonForward
			-- .toggleButtonBack
		else
			self:moveObject{obj=this.toggleButton, x=5}
			this.toggleButton:SetSize(12, 32)
			this.toggleButton.nt = this.toggleButton:GetNormalTexture()
			this.toggleButton.nt:SetTexCoord(0.22, 0.5, 0.33, 0.67)
			-- hook this to trim the texture
			self:RawHook(this.toggleButton.nt, "SetTexCoord", function(tObj, x1, x2, _)
				self.hooks[tObj].SetTexCoord(tObj, x1 == 0 and x1 + 0.22 or x1 + 0.26, x2, 0.33, 0.67)
			end, true)
		end
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ofs=0, x1=-6, x2=-2})

		self:SecureHookScript(this.displayFrame, "OnShow", function(fObj)
			self:keepFontStrings(fObj)
			fObj.filterOptions:DisableDrawLayer("BACKGROUND")
			if self.isMorF then
				self:skinObject("ddbutton", {obj=fObj.ModeControlDropdown, fType=ftype})
				self:skinObject("ddbutton", {obj=fObj.RestrictPingsDropdown, fType=ftype})
			else
				self:skinObject("dropdown", {obj=fObj.profileSelector, fType=ftype})
				self:skinObject("frame", {obj=fObj.containerResizeFrame, fType=ftype, kfs=true})
				if self.modBtns then
					self:skinStdButton{obj=fObj.lockedModeToggle, fType=ftype}
				end
			end
			-- TODO: skin .raidMarkers frame
			if self.modBtns then
				for i = 1, _G.MAX_RAID_GROUPS do
					self:skinStdButton{obj=fObj.filterOptions["filterGroup" .. i]}
				end
				if self.isMorF then
					for _, type in _G.pairs{"Tank", "Healer", "Damager"} do
						self:skinStdButton{obj=fObj.filterOptions["filterRole" .. type]}
					end
					self:skinStdButton{obj=_G.CompactRaidFrameManagerLeavePartyButton, fType=ftype}
					self:skinStdButton{obj=_G.CompactRaidFrameManagerLeaveInstanceGroupButton, fType=ftype}
				else
					self:skinStdButton{obj=fObj.hiddenModeToggle, fType=ftype}
					self:skinStdButton{obj=fObj.convertToRaid, fType=ftype}
					self:skinStdButton{obj=fObj.leaderOptions.readyCheckButton, fType=ftype}
					self:skinStdButton{obj=fObj.leaderOptions.rolePollButton, fType=ftype}
					self:skinStdButton{obj=fObj.editMode, fType=ftype}
					self:skinStdButton{obj=fObj.leaderOptions.countdownButton, fType=ftype}
					self:SecureHook("CompactRaidFrameManager_UpdateOptionsFlowContainer", function()
						-- handle button skin frames not being created yet
						if fObj.leaderOptions.readyCheckButton.sb then
							self:clrBtnBdr(fObj.leaderOptions.readyCheckButton)
							self:clrBtnBdr(fObj.leaderOptions.rolePollButton)
						end
					end)
				end
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=fObj.everyoneIsAssistButton}
				_G.RaiseFrameLevel(fObj.everyoneIsAssistButton) -- so button border is visible
			end

			self:Unhook(fObj, "OnShow")
		end)

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.CompactRaidFrameManager)

	-- Don't skin Group & Unit frames as they causes errors
	if self.isMorF then
		return
	end

	local function skinUnit(unit)
		-- handle in combat
		if _G.InCombatLockdown() then
		    aObj:add2Table(aObj.oocTab, {skinUnit, {unit}})
		    return
		end
		if unit.healthBar then
			if aObj:hasTextInTexture(unit.healthBar:GetStatusBarTexture(), "RaidFrame")
			or unit.healthBar:GetStatusBarTexture():GetTexture() == 423819 -- interface/raidframe/raid-bar-hp-fill.blp
			then
				unit:DisableDrawLayer("BACKGROUND")
				unit.horizDivider:SetTexture(nil)
				unit.horizTopBorder:SetTexture(nil)
				unit.horizBottomBorder:SetTexture(nil)
				unit.vertLeftBorder:SetTexture(nil)
				unit.vertRightBorder:SetTexture(nil)
				if aObj.prdb.CompactFrames.sbars then
					aObj:skinObject("statusbar", {obj=unit.healthBar, fi=0, bg=unit.healthBar.background})
					aObj:skinObject("statusbar", {obj=unit.powerBar, fi=0, bg=unit.powerBar.background})
				end
			end
		end
	end
	local grpName
	local function skinGrp(grp)
		aObj:skinObject("frame", {obj=grp.borderFrame, fType=ftype, kfs=true}) --, ofs=1, y1=-1, x2=-4, y2=4})
		grpName = grp:GetName()
		if grpName ~= "CompactPartyFrame" then
			for i = 1, _G.MEMBERS_PER_RAID_GROUP do
				skinUnit(_G[grpName .. "Member" .. i])
			end
		end
	end
	-- hook this to skin any new CompactRaidGroup(s)
	self:SecureHook("CompactRaidGroup_UpdateLayout", function(frame)
		skinGrp(frame)
	end)

	-- Compact RaidFrame Container
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

end

if aObj.isMorF then
	aObj.blizzFrames[ftype].DamageMeter = function(self)
		if not self.prdb.DamageMeter or self.initialized.DamageMeter then return end
		self.initialized.DamageMeter = true

		local function skinEntry(frame)
			for _, tex in _G.pairs(frame.StatusBar.BackgroundRegions) do
				tex:SetTexture(nil)
			end
			aObj:skinObject("statusbar", {obj=frame.StatusBar, fType=ftype, fi=0})
		end
		local function skinSessionWindow(frame)
			frame.Header:SetTexture(nil)
			if aObj.modBtns then
				aObj:skinOtherButton{obj=frame.MinimizeButton, fType=ftype, text=frame.isMinimized and aObj.plus or aObj.minus, size=32}
				aObj:SecureHook(frame, "SetMinimized", function(fObj, _)
					local minimizeButton = fObj:GetMinimizeButton()
					if fObj:IsMinimized() then
						minimizeButton:SetText(aObj.plus)
					else
						minimizeButton:SetText(aObj.minus)
					end
				end)
			end
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=frame.SettingsDropdown, fType=ftype, es=12, ofs=-2, y1=1, y2=5}
				aObj:addButtonBorder{obj=frame.SessionDropdown, fType=ftype, rpA=true, es=12, x1=-3, y1=3, x2=4, y2=-3}
				aObj:addButtonBorder{obj=frame.DamageMeterTypeDropdown, fType=ftype, es=12, ofs=-1, y1=0, y2=2}
			end
			local function skinPlayerEntry(...)
				local _, element
				if _G.select("#", ...) == 2 then
					element, _ = ...
				else
					_, element, _ = ...
				end
				skinEntry(element)
			end
			aObj:skinObject("scrollbar", {obj=frame.MinimizeContainer.ScrollBar, fType=ftype})
			_G.ScrollUtil.AddInitializedFrameCallback(frame.MinimizeContainer.ScrollBox, skinPlayerEntry, aObj, true)
			skinEntry(frame.MinimizeContainer.LocalPlayerEntry)

			aObj:SecureHookScript(frame.MinimizeContainer.SourceWindow, "OnShow", function(srcWindow)
				aObj:skinObject("scrollbar", {obj=srcWindow.ScrollBar, fType=ftype})
				aObj:skinObject("frame", {obj=srcWindow, fType=ftype, kfs=true, ofs=-6, y2=8})
				local function skinSpellEntry(...)
					local _, element
					if _G.select("#", ...) == 2 then
						element, _ = ...
					else
						_, element, _ = ...
					end
					skinEntry(element)
				end
				_G.ScrollUtil.AddInitializedFrameCallback(srcWindow.ScrollBox, skinSpellEntry, aObj, true)

			    aObj:Unhook(srcWindow, "OnShow")
			end)

		end
		_G.DamageMeter:ForEachSessionWindow(function(sessionWindow)
			skinSessionWindow(sessionWindow)
		end)

		self:SecureHook(_G.DamageMeter, "SetupSessionWindow", function(_, _, windowData, _)
			skinSessionWindow(windowData.sessionWindow)
		end)

	end
end

if aObj.isMorC then
	aObj.blizzLoDFrames[ftype].EncounterJournal = function(self) -- a.k.a. Adventure Guide/Dungeon Journal
		if not self.prdb.EncounterJournal or self.initialized.EncounterJournal then return end
		self.initialized.EncounterJournal = true

		-- used by both Encounters & Loot sub frames
		-- TODO: make a Utility function (also used by NovaRaidCompanion skin)
		local function skinFilterBtn(btn)
			btn:DisableDrawLayer("BACKGROUND")
			btn:GetNormalTexture():SetTexture(nil)
			btn:GetPushedTexture():SetTexture(nil)
			aObj.modUIBtns:skinStdButton{obj=btn, x1=-11, y1=-2, x2=11, y2=2, clr="gold"} -- use module function so button appears
		end
		self:SecureHookScript(_G.EncounterJournal, "OnShow", function(this)

			self:skinNavBar(this.navBar)
			this.navBar.home.text:SetPoint("RIGHT", -20, 0)
			self:skinObject("editbox", {obj=this.searchBox, fType=ftype, si=true})
			self:skinObject("ddbutton", {obj=this.LootJournalViewDropdown, fType=ftype})
			self:skinObject("tabs", {obj=this, tabs=this.Tabs, selectedTab=this.selectedTab, fType=ftype, lod=self.isTT and true, offsets=not self.isClsc and {x1=-1, y1=2, x2=1, y2=1} or nil, regions=not self.isClscERA and {7, 8, 9, 10, 11} or {10, 21}, track=false, func=function(tab) tab:SetFrameLevel(20) end})
			if self.isTT then
				self:SecureHook("EJ_ContentTab_Select", function(id)
					for i, tab in _G.pairs(this.Tabs) do
						if i == id then
							self:setActiveTab(tab.sf)
						else
							self:setInactiveTab(tab.sf)
						end
					end
				end)
			end
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true})

			self:SecureHookScript(this.searchBox.searchPreviewContainer, "OnShow", function(fObj)
				for _, btn in _G.pairs(fObj:GetParent().searchButtons) do
					btn:GetNormalTexture():SetTexture(nil)
					btn:GetPushedTexture():SetTexture(nil)
				end
				fObj:GetParent().showAllResults:GetNormalTexture():SetTexture(nil)
				fObj:GetParent().showAllResults:GetPushedTexture():SetTexture(nil)
				self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true})
				-- adjust skinframe as parent frame is resized when populated
				fObj.sf:SetPoint("TOPLEFT", fObj.topBorder, "TOPLEFT", -2, 2)
				fObj.sf:SetPoint("BOTTOMRIGHT", fObj.botRightCorner, "BOTTOMRIGHT", 1, 4)

				self:Unhook(fObj, "OnShow")
			end)

			self:SecureHookScript(this.searchResults, "OnShow", function(fObj)
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
						aObj:removeRegions(element, {1})
						element:GetNormalTexture():SetAlpha(0)
						element:GetPushedTexture():SetAlpha(0)
						if aObj.modBtnBs then
							 aObj:addButtonBorder{obj=element, relTo=element.icon}
						end
					end
				end
				_G.ScrollUtil.AddAcquiredFrameCallback(fObj.ScrollBox, skinElement, aObj, true)
				fObj:SetFrameLevel(25) -- make it appear above tabs
				self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, cb=true, ofs=6, y1=1})

				self:Unhook(fObj, "OnShow")
			end)

			self:SecureHookScript(this.instanceSelect, "OnShow", function(fObj)
				fObj.bg:SetAlpha(0)
				if self.isMnln then
					fObj.evergreenBg:SetAlpha(0)
					if self.modBtnBs then
						self:addButtonBorder{obj=fObj.GreatVaultButton, fType=ftype, ofs=-1, x2=-2, y2=2, relTo=fObj.GreatVaultButton.Icon}
					end
				end
				self:skinObject("ddbutton", {obj=fObj.ExpansionDropdown, fType=ftype})
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
						if aObj.modBtnBs then
							aObj:addButtonBorder{obj=element, fType=ftype, relTo=element.bgImage, ofs=1}
						end
					end
				end
				_G.ScrollUtil.AddAcquiredFrameCallback(fObj.ScrollBox, skinElement, aObj, true)

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.instanceSelect)

			self:SecureHookScript(this.encounter, "OnShow", function(fObj)
				-- Instance frame
				fObj.instance.loreBG:SetTexCoord(0.06, 0.70, 0.08, 0.58)
				fObj.instance.loreBG:SetSize(370, 308)
				fObj.instance:DisableDrawLayer("ARTWORK")
				self:moveObject{obj=fObj.instance.mapButton, x=-20, y=-18}
				if self.modBtnBs then
					self:addButtonBorder{obj=fObj.instance.mapButton, relTo=fObj.instance.mapButton.texture, x1=2, y1=-1, x2=-2, y2=1}
				end
				self:skinObject("scrollbar", {obj=fObj.instance.LoreScrollBar, fType=ftype})
				fObj.instance.LoreScrollingFont:GetFontString():SetTextColor(self.BT:GetRGB())

				self:SecureHookScript(fObj.info, "OnShow", function(frame)
					frame:DisableDrawLayer("BACKGROUND")
					frame.encounterTitle:SetTextColor(self.HT:GetRGB())
					frame.instanceButton:GetNormalTexture():SetTexture(nil)
					frame.instanceButton:SetHighlightTexture(self.tFDIDs.ejt)
					frame.instanceButton:GetHighlightTexture():SetTexCoord(0.68945313, 0.81054688, 0.33300781, 0.39257813)
					self:skinObject("scrollbar", {obj=frame.BossesScrollBar, fType=ftype})
					local function skinBossesElement(...)
						local _, element, new
						if _G.select("#", ...) == 2 then
							element, _ = ...
						elseif _G.select("#", ...) == 3 then
							element, _, new = ...
						else
							_, element, _, new = ...
						end
						if new ~= false then
							element:GetNormalTexture():SetTexture(nil)
							element:GetPushedTexture():SetTexture(nil)
						end
					end
					_G.ScrollUtil.AddAcquiredFrameCallback(frame.BossesScrollBox, skinBossesElement, aObj, true)
					self:skinObject("ddbutton", {obj=frame.difficulty, fType=ftype})
					self:skinObject("scrollbar", {obj=frame.detailsScroll.ScrollBar, fType=ftype})
					frame.detailsScroll.child.description:SetTextColor(self.BT:GetRGB())
					frame.overviewScroll.child.overviewDescription.Text:SetTextColor("P", self.BT:GetRGB())
					frame.overviewScroll.child.loreDescription:SetTextColor(self.BT:GetRGB())
					frame.overviewScroll.child.header:SetTexture(nil)
					-- Hook this to skin headers
					local function skinHeader(header)
						header.button:DisableDrawLayer("BACKGROUND")
						header.overviewDescription.Text:SetTextColor("H1", aObj.HT:GetRGB())
						if header.description:GetText() then
							local newText, upd = aObj:removeColourCodes(header.description:GetText()) -- handle embedded colour code
							if upd then
								header.description:SetText(newText)
							end
							header.description:SetTextColor(aObj.BT:GetRGB())
						end
						header.descriptionBG:SetTexture(nil)
						header.descriptionBGBottom:SetTexture(nil)
						aObj:getRegion(header.button.portrait, 2):SetTexture(nil)
						for _, bObj in _G.pairs(header.Bullets) do
							bObj.Text:SetTextColor("P", aObj.BT:GetRGB())
						end
					end
					self:SecureHook("EncounterJournal_ToggleHeaders", function(ejH, _)
						if ejH.isOverview then
							for _, header in _G.ipairs(fObj.overviewFrame.overviews) do
								skinHeader(header)
							end
						else
							for _, header in _G.ipairs(fObj.usedHeaders) do
								skinHeader(header)
							end
						end
					end)
					-- Loot Frame
					self:skinObject("scrollbar", {obj=frame.LootContainer.ScrollBar, fType=ftype})
					self:skinObject("ddbutton", {obj=frame.LootContainer.filter, fType=ftype})
					self:skinObject("ddbutton", {obj=frame.LootContainer.slotFilter, fType=ftype})
					frame.LootContainer.classClearFilter:DisableDrawLayer("BACKGROUND")
					local function skinLootElement(...)
						local _, element, new
						if _G.select("#", ...) == 2 then
							element, _ = ...
						elseif _G.select("#", ...) == 3 then
							element, _, new = ...
						else
							_, element, _, new = ...
						end
						if new ~= false then
							if element.armorType then -- ignore divider(s)
								element:DisableDrawLayer("BORDER")
								element.armorType:SetTextColor(self.BT:GetRGB())
								element.slot:SetTextColor(self.BT:GetRGB())
								element.boss:SetTextColor(self.BT:GetRGB())
								if aObj.modBtnBs then
									aObj:addButtonBorder{obj=element, relTo=element.icon}
								end
							end
						end
					end
					_G.ScrollUtil.AddAcquiredFrameCallback(frame.LootContainer.ScrollBox, skinLootElement, aObj, true)
					-- Model Frame
					self:keepFontStrings(frame.model)
					local function skinCreatureBtn(cBtn)
						local hTex
						if cBtn
						and not cBtn.sknd
						then
							cBtn.sknd = true
							cBtn:GetNormalTexture():SetTexture(nil)
							hTex = cBtn:GetHighlightTexture()
							hTex:SetTexture(aObj.tFDIDs.ejt)
							hTex:SetTexCoord(0.68945313, 0.81054688, 0.33300781, 0.39257813)
						end
					end
					-- creature(s)
					for _, cBtn in _G.ipairs(frame.creatureButtons) do
						skinCreatureBtn(cBtn)
					end
					-- hook this to skin additional buttons
					self:SecureHook("EncounterJournal_GetCreatureButton", function(index)
						if index > 9 then return end -- MAX_CREATURES_PER_ENCOUNTER
						skinCreatureBtn(_G.EncounterJournal.encounter.info.creatureButtons[index])
					end)
					-- Tabs (side)
					self:skinObject("tabs", {obj=frame, tabs={frame.overviewTab, frame.lootTab, frame.bossTab, frame.modelTab}, fType=ftype, ignoreHLTex=false, ng=true, regions={4, 5, 6}, offsets={x1=9, y1=-6, x2=-6, y2=6}, track=false})
					if not self.isClsc then
						self:moveObject{obj=frame.overviewTab, x=7}
					end

					self:Unhook(frame, "OnShow")
				end)
				self:checkShown(fObj.info)

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.encounter)

			if self.isMnln then
				local function changeHCI(bObj)
					if bObj:GetElementData():IsCollapsed() then
						bObj.HeaderCollapseIndicator:SetAtlas("ui-hud-minimap-zoom-in")
					else
						bObj.HeaderCollapseIndicator:SetAtlas("ui-hud-minimap-zoom-out")
					end
				end
				-- a.k.a. Traveler's Log
				self:SecureHookScript(this.MonthlyActivitiesFrame, "OnShow", function(fObj)
					fObj:DisableDrawLayer("BACKGROUND")
					fObj:DisableDrawLayer("BORDER")
					fObj.HelpButton.Ring:SetTexture(nil)
					fObj.ThresholdContainer:DisableDrawLayer("OVERLAY")
					for _, frame in _G.pairs(fObj.thresholdFrames) do
						frame.RewardItem.CircleMask:SetShown(false)
						if frame:GetParentKey() == "Threshold5"
						and self.modBtnBs
						then
							self:addButtonBorder{obj=frame.RewardItem, fType=ftype, ncc=true, relTo=frame.RewardItem.Icon, ibt=true}
							frame.RewardCurrency:SetParent(frame.RewardItem.sbb)
						end
					end
					fObj.FilterList:DisableDrawLayer("BACKGROUND")
					self:skinObject("scrollbar", {obj=fObj.FilterList.ScrollBar, fType=ftype})
					self:skinObject("scrollbar", {obj=fObj.ScrollBar, fType=ftype})
					self:keepFontStrings(fObj.ThemeContainer)

					local currentTime, frameClr
					local function skinActivities(...)
						local _, element, elementData
						if _G.select("#", ...) == 2 then
							element, elementData = ...
						elseif _G.select("#", ...) == 3 then
							_, element, elementData = ...
						end
						if element.HeaderCollapseIndicator then
							changeHCI(element)
							aObj:secureHook(element, "UpdateButtonState", function(bObj)
								changeHCI(bObj)
							end)
						end
						element:GetNormalTexture():SetAlpha(0)
						frameClr = "default"
						if elementData.data.eventStartTime ~= nil
						and elementData.data.eventEndTime ~= nil
						then
							currentTime = _G.GetServerTime()
							if currentTime < elementData.data.eventStartTime
							or currentTime > elementData.data.eventEndTime
							then
								frameClr = "disabled"
							else
								element.TextContainer.NameText:SetTextColor(aObj.BT:GetRGB())
							end
						end
						if elementData.data.completed then
							element.TextContainer.NameText:SetTextColor(aObj.BT:GetRGB())
							element.TextContainer.ConditionsText:SetTextColor(aObj.BT:GetRGB())
						end
						aObj:skinObject("frame", {obj=element, fType=ftype, ofs=-2, y2=4, fb=true})
						aObj:clrBBC(element.sf, frameClr)
					end
					_G.ScrollUtil.AddInitializedFrameCallback(fObj.ScrollBox, skinActivities, aObj, true)

					self:Unhook(fObj, "OnShow")
				end)
				self:checkShown(this.MonthlyActivitiesFrame)

				self:SecureHookScript(this.JourneysFrame, "OnShow", function(fObj)
					self:keepFontStrings(fObj.BorderFrame)
					self:skinObject("scrollbar", {obj=fObj.ScrollBar, fType=ftype})
					local function skinJourney(...)
						local _, element, elementData
						if _G.select("#", ...) == 2 then
							element, elementData = ...
						else
							_, element, elementData = ...
						end
						if elementData.category then
							-- JourneysListCategoryNameTemplate
							_G.nop()
						elseif elementData.divider then
							-- JourneysListCategoryDividerTemplate
							element.CategoryDivider:SetTexture(nil)
						elseif elementData.isRenownJourney then
							-- RenownCardButtonTemplate
							aObj:skinObject("frame", {obj=element, fType=ftype, kfs=true, fb=true, ofs=-4, x2=-7, y2=7})
							if aObj.modChkBtns then
								aObj:skinCheckButton{obj=element.WatchedFactionToggleFrame.WatchFactionCheckbox, fType=ftype}
							end
						else
							-- JourneyCardButtonTemplate
							element.JourneyCardProgressBar.JourneyCardProgressBarFrame:SetTexture(nil)
							aObj:skinObject("statusbar", {obj=element.JourneyCardProgressBar, fType=ftype, fi=0, bg=element.JourneyCardProgressBar.JourneyCardProgressBarBG})
							aObj:skinObject("frame", {obj=element, fType=ftype, kfs=true, fb=true, ofs=-4, x2=-7, y2=8})
						end
					end
					_G.ScrollUtil.AddInitializedFrameCallback(fObj.JourneysList, skinJourney, aObj, true)

					local function skinRewards(frame)
						-- JourneyProgressRewardCardTemplate
						for reward in frame.rewardPool:EnumerateActive() do
							reward.RewardCardBG:SetTexture(nil)
							reward.RewardCardBGGlow:SetTexture(nil)
							aObj:skinObject("frame", {obj=reward, fType=ftype, fb=true, ofs=-3, y1=-1})
						end
					end
					self:SecureHookScript(fObj.JourneyProgress, "OnShow", function(frame)
						frame.DividerTexture:SetTexture(nil)
						frame.ProgressDetailsFrame.JourneyLevelBar:SetTexture(nil)
						frame.ProgressDetailsFrame.JourneyLevelBg:SetTexture(nil)
						local drpb = frame.DelveRewardProgressBar
						drpb.DelveRewardProgressBarFrame:SetTexture(nil)
						self:skinObject("statusbar", {obj=drpb, fType=ftype, fi=0, bg=drpb.DelveRewardProgressBarBG})
						-- TODO: skin .RenownTrackFrame.ClipFrame entries to remove border around level #
						skinRewards(frame)
						self:SecureHook(frame, "OnTrackUpdate", function(_, _, _, _, _)
							skinRewards(frame)
						end)
						if self.modBtns then
							self:skinStdButton{obj=frame.OverviewBtn, fType=ftype}
							self:skinStdButton{obj=frame.LevelSkipButton, fType=ftype, clr="gold"}
						end

						self:skinRewardTrackFrameElements(frame.EncounterRewardProgressFrame, ftype)
						self:SecureHook(frame, "SetupRewardTrack", function(erpf)
							self:skinRewardTrackFrameElements(erpf, ftype)
						end)
						self:skinObject("frame", {obj=frame.DelvesCompanionConfigurationFrame.CompanionConfigBtn, fType=ftype, kfs=true, fb=true, x1=1, y1=-2, x2=-4, y2=6})
						frame.DelvesCompanionConfigurationFrame.CompanionConfigBtn.Icon:SetAlpha(1)

						self:Unhook(frame, "OnShow")
					end)
					self:checkShown(fObj.JourneyProgress)

					self:SecureHookScript(fObj.JourneyOverview, "OnShow", function(frame)
						frame.DividerTexture:SetTexture(nil)
						frame.DividerGlowTexture:SetTexture(nil)
						if self.modBtns then
							self:skinStdButton{obj=frame.OverviewBtn, fType=ftype}
						end

						self:Unhook(frame, "OnShow")
					end)

					self:Unhook(fObj, "OnShow")
				end)
				self:checkShown(this.JourneysFrame)

				self:SecureHookScript(this.suggestFrame, "OnShow", function(fObj)
					local ejsfs
					for i = 1, _G.AJ_MAX_NUM_SUGGESTIONS do
						ejsfs = fObj["Suggestion" .. i]
						ejsfs.bg:SetTexture(nil)
						ejsfs.iconRing:SetTexture(nil)
						ejsfs.centerDisplay.title.text:SetTextColor(self.HT:GetRGB())
						ejsfs.centerDisplay.description.text:SetTextColor(self.BT:GetRGB())
						if i == 1 then
							ejsfs.reward.text:SetTextColor(self.BT:GetRGB())
						end
						ejsfs.reward.iconRing:SetTexture(nil)
						if self.modBtns then
							if i ~= 1 then
								self:skinStdButton{obj=ejsfs.centerDisplay.button}
							else
								self:skinStdButton{obj=ejsfs.button}
							end
						end
						if self.modBtnBs
						and i == 1
						then
							self:addButtonBorder{obj=ejsfs.prevButton, ofs=-2, y1=-3, x2=-3, clr="gold"}
							self:addButtonBorder{obj=ejsfs.nextButton, ofs=-2, y1=-3, x2=-3, clr="gold"}
							self:SecureHook("EJSuggestFrame_RefreshDisplay", function()
								local frame = _G.EncounterJournal.suggestFrame.Suggestion1
								self:clrBtnBdr(frame.prevButton, "gold")
								self:clrBtnBdr(frame.nextButton, "gold")
							end)
						end
					end

					self:Unhook(fObj, "OnShow")
				end)
				self:checkShown(this.suggestFrame)

				self:SecureHookScript(this.LootJournal, "OnShow", function(fObj)
					self:skinObject("scrollbar", {obj=fObj.ScrollBar, fType=ftype})
					if not self.isMnln then
						skinFilterBtn(fObj.ClassDropDownButton)
						skinFilterBtn(fObj.RuneforgePowerFilterDropDownButton)
					end
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
							element.Background:SetTexture(nil)
							element.BackgroundOverlay:SetAlpha(0)
						end
					end
					_G.ScrollUtil.AddAcquiredFrameCallback(fObj.ScrollBox, skinElement, aObj, true)

					self:Unhook(fObj, "OnShow")
				end)
				self:checkShown(this.LootJournal)

				self:SecureHookScript(this.LootJournalItems, "OnShow", function(fObj)
					fObj:DisableDrawLayer("BACKGROUND")
					if self.isMnln then
						self:skinObject("ddbutton", {obj=fObj.ItemSetsFrame.ClassDropdown, fType=ftype})
					else
						skinFilterBtn(fObj.ItemSetsFrame.ClassButton)
					end
					self:skinObject("scrollbar", {obj=fObj.ItemSetsFrame.ScrollBar, fType=ftype})
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
							element.Background:SetTexture(nil)
						end
					end
					_G.ScrollUtil.AddAcquiredFrameCallback(fObj.ItemSetsFrame.ScrollBox, skinElement, aObj, true)

					self:Unhook(fObj, "OnShow")
				end)

				self:SecureHookScript(this.TutorialsFrame, "OnShow", function(fObj)
					fObj.Contents:DisableDrawLayer("BACKGROUND")
					fObj.Contents.Header:SetTextColor(self.HT:GetRGB())
					fObj.Contents.Divider:SetTexture(nil)
					fObj.Contents.Description:SetTextColor(self.BT:GetRGB())
					if self.modBtns then
						self:skinStdButton{obj=fObj.Contents.StartButton, fType=ftype}
					end

					self:Unhook(fObj, "OnShow")
				end)
				self:checkShown(this.TutorialsFrame)
			end
			-- let AddOn skins know when when UI is skinned (used by Atlas skin)
			self.callbacks:Fire("EncounterJournal_Skinned", self)
			-- remove all callbacks for this event
			self.callbacks.events["EncounterJournal_Skinned"] = nil

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.EncounterJournal)

		-- this is a frame NOT a GameTooltip
		self:SecureHookScript(_G.EncounterJournalTooltip, "OnShow", function(this)
			self:skinObject("frame", {obj=this, fType=ftype})
			-- TODO: .Item1.tooltip

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.EncounterJournalTooltip)

	end
end

if aObj.isMorCorF then
	aObj.blizzFrames[ftype].EquipmentFlyout = function(self)
		if not self.prdb.EquipmentFlyout or self.initialized.EquipmentFlyout then return end
		self.initialized.EquipmentFlyout = true

		-- Used by RuneForgeUI/ItemUpgrades/EquipmentManager
		self:SecureHook("EquipmentFlyout_UpdateItems", function(_)
			for i = 1, _G.EquipmentFlyoutFrame.buttonFrame.numBGs do
				_G.EquipmentFlyoutFrame.buttonFrame["bg" .. i]:SetAlpha(0)
			end
			if self.modBtnBs then
				for _, btn in _G.ipairs(_G.EquipmentFlyoutFrame.buttons) do
					self:addButtonBorder{obj=btn, fType=ftype, ibt=true, reParent={btn.UpgradeIcon}}
					if self.isClsc then
						if btn.location >= _G.EQUIPMENTFLYOUT_FIRST_SPECIAL_LOCATION then
							self:clrBtnBdr(btn, "grey")
						end
					end
				end
			end
		end)

		self:SecureHookScript(_G.EquipmentFlyoutFrame, "OnShow", function(this)
			if _G.InCombatLockdown() then
			    self:add2Table(self.oocTab, {self.checkShown, {self, this}})
			    return
			end

			self:skinObject("frame", {obj=this.buttonFrame, fType=ftype, ofs=2, x2=5, clr="gold"})
			self:skinObject("frame", {obj=this.NavigationFrame, fType=ftype, kfs=true, x1=0, y2=1, clr="gold"})
			if self.modBtnBs then
				self:addButtonBorder{obj=this.NavigationFrame.PrevButton, fType=ftype, ofs=-2, x1=1, clr="gold", schk=true}
				self:addButtonBorder{obj=this.NavigationFrame.NextButton, fType=ftype, ofs=-2, x1=1, clr="gold", schk=true}
			end

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.EquipmentFlyoutFrame)

	end
end

if aObj.isMorF then
	aObj.blizzFrames[ftype].FriendsFrame = function(self)
		if not self.prdb.FriendsFrame or self.initialized.FriendsFrame then return end
		self.initialized.FriendsFrame = true

		local function addTabBorder(frame)
			aObj:skinObject("frame", {obj=frame, fType=ftype, chkfb=true, x1=0, y1=-81, x2=1, y2=0})
		end
		self:SecureHookScript(_G.FriendsFrame, "OnShow", function(this)
			if _G.InCombatLockdown() then
			    self:add2Table(self.oocTab, {self.checkShown, {self, this}})
			    return
			end

			if self.isMnln then
				self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true})
			else
				self:skinObject("tabs", {obj=this, tabs=this.Tabs, fType=ftype, ignoreSize=true, lod=self.isTT and true, upwards=true})
			end
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true, x2=3, y2=-2})

			self:SecureHookScript(_G.FriendsTabHeader, "OnShow", function(fTH)
				_G.FriendsFrameBattlenetFrame:DisableDrawLayer("BACKGROUND")
				self:skinObject("ddbutton", {obj=_G.FriendsFrameStatusDropdown, fType=ftype})
				-- Top Tabs
				self:skinObject("tabs", {obj=fTH.TabSystem, pool=true, fType=ftype, upwards=true, offsets={x1=1, y1=0, x2=-1, y2=-4}, track=false, regions=self.isFrvr and {15}})
				if self.modBtnBs then
					self:addButtonBorder{obj=_G.FriendsFrameBattlenetFrame.BroadcastButton, fType=ftype, ofs=-2, x1=1}
					self:addButtonBorder{obj=_G.FriendsFrameBattlenetFrame.ContactsMenuButton, fType=ftype, clr="gold", ofs=-2, x1=1}
				end
				self:SecureHookScript(_G.FriendsFrameBattlenetFrame.BroadcastFrame, "OnShow", function(fObj)
					self:keepFontStrings(fObj.Border)
					fObj.EditBox:DisableDrawLayer("BACKGROUND")
					self:skinObject("editbox", {obj=fObj.EditBox, fType=ftype})
					self:moveObject{obj=fObj.EditBox.PromptText, x=5}
					self:adjHeight{obj=fObj.EditBox, adj=-6}
					self:skinObject("frame", {obj=fObj, fType=ftype, ofs=-10})
					if self.modBtns then
						self:skinStdButton{obj=fObj.UpdateButton, fType=ftype}
						self:skinStdButton{obj=fObj.CancelButton, fType=ftype}
					end

					self:Unhook(fObj, "OnShow")
				end)
				self:SecureHookScript(_G.FriendsFrameBattlenetFrame.UnavailableInfoFrame, "OnShow", function(fObj)
					self:skinObject("frame", {obj=fObj, fType=ftype, rns=true})

					self:Unhook(fObj, "OnShow")
				end)

				self:Unhook(fTH, "OnShow")
			end)
			self:checkShown(_G.FriendsTabHeader)

			self:SecureHookScript(_G.FriendsListFrame, "OnShow", function(fObj)
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
						if element.background then
							element.background:SetAlpha(0)
							if aObj.modBtnBs then
								aObj:addButtonBorder{obj=element.travelPassButton, fType=ftype, schk=true, ofs=0, y1=3, y2=-2}
								aObj:addButtonBorder{obj=element.summonButton, fType=ftype, schk=true}
							end
						end
					end
				end
				_G.ScrollUtil.AddAcquiredFrameCallback(fObj.ScrollBox, skinElement, aObj, true)
				addTabBorder(fObj)
				if self.modBtns then
					self:skinStdButton{obj=_G.FriendsFrameAddFriendButton, fType=ftype, x1=1}
					self:skinStdButton{obj=_G.FriendsFrameSendMessageButton, fType=ftype}
					self:skinStdButton{obj=self:getChild(fObj.RIDWarning, 1), fType=ftype}
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(_G.FriendsListFrame)

			self:SecureHookScript(_G.RecentAlliesFrame, "OnShow", function(fObj)
				self:skinObject("scrollbar", {obj=fObj.List.ScrollBar, fType=ftype})
				addTabBorder(fObj)

				self:Unhook(fObj, "OnShow")
			end)

			self:SecureHookScript(this.IgnoreListWindow, "OnShow", function(fObj)
				self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, rns=true, cb=true, ofs=0})
				if self.modBtns then
					self:skinStdButton{obj=fObj.UnignorePlayerButton, fType=ftype, schk=true}
				end
				self:skinObject("scrollbar", {obj=fObj.ScrollBar, fType=ftype})
				-- local function skinElement(...)
				-- 	local _, element, elementData
				-- 	if _G.select("#", ...) == 2 then
				-- 		element, elementData = ...
				-- 	else
				-- 		_, element, elementData = ...
				-- 	end
				-- end
				-- _G.ScrollUtil.AddInitializedFrameCallback(fObj.ScrollBox, skinElement, aObj, true)

				self:Unhook(fObj, "OnShow")
			end)

			if self.isMnln then
				self:SecureHookScript(_G.WhoFrame, "OnShow", function(fObj)
					self:removeInset(_G.WhoFrameListInset)
					for i = 1, 4 do
						_G["WhoFrameColumnHeader" .. i]:DisableDrawLayer("BACKGROUND")
						if i == 2 then
							self:skinObject("ddbutton", {obj=_G.WhoFrameDropdown, fType=ftype, ofs=0})
							_G.WhoFrameDropdown:SetPoint("BOTTOMRIGHT", 0, -2)
						else
							self:skinObject("frame", {obj=_G["WhoFrameColumnHeader" .. i], fType=ftype})
						end
					end
					self:moveObject{obj=_G.WhoFrameColumnHeader4, x=2}
					_G.WhoFrameEditBox.Backdrop:SetTexture(nil)
					self:skinObject("editbox", {obj=_G.WhoFrameEditBox, fType=ftype, mi=true, mix=12, x1=-5, y1=-4, y2=4})
					self:skinObject("scrollbar", {obj=fObj.ScrollBar, fType=ftype})
					if self.modBtns then
						self:skinStdButton{obj=_G.WhoFrameGroupInviteButton, fType=ftype, schk=true}
						self:skinStdButton{obj=_G.WhoFrameAddFriendButton, fType=ftype, schk=true}
						self:skinStdButton{obj=_G.WhoFrameWhoButton, fType=ftype}
					end

					self:Unhook(fObj, "OnShow")
				end)
			end

			_G.RunNextFrame(function()
				self:add2Table(self.ttList, ftype, _G.FriendsTooltip)
			end)

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.FriendsFrame)

		self:SecureHookScript(_G.AddFriendFrame, "OnShow", function(this)
			if _G.InCombatLockdown() then
			    self:add2Table(self.oocTab, {self.checkShown, {self, this}})
			    return
			end

			self:removeNineSlice(this.Border)
			self:skinObject("editbox", {obj=_G.AddFriendNameEditBox, fType=ftype})
			self:moveObject{obj=_G.AddFriendNameEditBoxFill, x=5}
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true})
			if self.modBtns then
				self:skinStdButton{obj=_G.AddFriendInfoFrameContinueButton}
				self:skinStdButton{obj=_G.AddFriendEntryFrameAcceptButton}
				self:skinStdButton{obj=_G.AddFriendEntryFrameCancelButton}
				self:SecureHookScript(_G.AddFriendNameEditBox, "OnTextChanged", function(_)
					self:clrBtnBdr(_G.AddFriendEntryFrameAcceptButton)
				end)
			end

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.AddFriendFrame)

		self:SecureHookScript(_G.FriendsFriendsFrame, "OnShow", function(this)
			if _G.InCombatLockdown() then
			    self:add2Table(self.oocTab, {self.checkShown, {self, this}})
			    return
			end

			self:removeNineSlice(this.Border)
			self:skinObject("ddbutton", {obj=this.FriendsDropdown, fType=ftype})
			self:removeBackdrop(this.ScrollFrameBorder)
			self:skinObject("scrollbar", {obj=this.ScrollBar, fType=ftype})
			self:skinObject("frame", {obj=this, fType=ftype})
			if self.modBtns then
				self:skinStdButton{obj=this.SendRequestButton, fType=ftype, schk=true}
				self:skinStdButton{obj=this.CloseButton, fType=ftype}
			end

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.FriendsFriendsFrame)

		self:SecureHookScript(_G.RecruitAFriendFrame, "OnShow", function(this)
			if _G.InCombatLockdown() then
			    self:add2Table(self.oocTab, {self.checkShown, {self, this}})
			    return
			end

			this.RewardClaiming:DisableDrawLayer("BACKGROUND")
			this.RewardClaiming.NextRewardButton.IconBorder:SetTexture(nil)
			self:removeInset(this.RewardClaiming.Inset)
			this.RecruitList.Header:DisableDrawLayer("BACKGROUND")
			self:removeInset(this.RecruitList.ScrollFrameInset)
			self:skinObject("scrollbar", {obj=this.RecruitList.ScrollBar, fType=ftype})
			this.SplashFrame.Description:SetTextColor(self.BT:GetRGB())
			self:skinObject("frame", {obj=this.SplashFrame, fType=ftype, ofs=2, y1=4, y2=-5})
			addTabBorder(this)
			if self.modBtns then
				self:skinStdButton{obj=this.RewardClaiming.ClaimOrViewRewardButton, fType=ftype}
				self:skinStdButton{obj=this.RecruitmentButton, fType=ftype}
				self:skinStdButton{obj=this.SplashFrame.OKButton, fType=ftype}
			end

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.RecruitAFriendFrame)

		self:SecureHookScript(_G.RecruitAFriendRewardsFrame, "OnShow", function(this)
			if _G.InCombatLockdown() then
			    self:add2Table(self.oocTab, {self.checkShown, {self, this}})
			    return
			end

			this:DisableDrawLayer("BACKGROUND")
			self:skinObject("frame", {obj=this.Border, fType=ftype, kfs=true, ofs=-4})
			if self.modBtns then
				self:skinCloseButton{obj=this.CloseButton, fType=ftype}
			end
			if self.modBtnBs then
				for reward in this.rewardPool:EnumerateActive() do
					self:addButtonBorder{obj=reward.Button, fType=ftype, clr="sepia"}
				end
			end

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.RecruitAFriendRewardsFrame)

		self:SecureHookScript(_G.RecruitAFriendRecruitmentFrame, "OnShow", function(this)
			if _G.InCombatLockdown() then
			    self:add2Table(self.oocTab, {self.checkShown, {self, this}})
			    return
			end

			self:skinObject("editbox", {obj=this.EditBox, fType=ftype})
			self:adjHeight{obj=this.EditBox, adj=-6}
			self:skinObject("frame", {obj=this.Border, fType=ftype, kfs=true, ofs=-4})
			if self.modBtns then
				self:skinCloseButton{obj=this.CloseButton, fType=ftype}
				self:skinStdButton{obj=this.GenerateOrCopyLinkButton, fType=ftype, schk=true, sechk=true}
			end

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.RecruitAFriendRecruitmentFrame)

		self:SecureHookScript(_G.QuickJoinFrame, "OnShow", function(this)
			if _G.InCombatLockdown() then
			    self:add2Table(self.oocTab, {self.checkShown, {self, this}})
			    return
			end

			self:skinObject("scrollbar", {obj=this.ScrollBar, fType=ftype})
			self:removeMagicBtnTex(this.JoinQueueButton)
			if self.modBtns then
				self:skinStdButton{obj=this.JoinQueueButton, fType=ftype, x2=0, schk=true}
			end

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.QuickJoinFrame)

		self:SecureHookScript(_G.QuickJoinRoleSelectionFrame, "OnShow", function(this)
			if _G.InCombatLockdown() then
			    self:add2Table(self.oocTab, {self.checkShown, {self, this}})
			    return
			end

			self:removeNineSlice(this.Border)
			self:skinObject("frame", {obj=this, fType=ftype, cb=true, ofs=-5})
			if self.modBtns then
				self:skinStdButton{obj=this.AcceptButton, fType=ftype}
				self:skinStdButton{obj=this.CancelButton, fType=ftype}
			end
			if self.modChkBtns then
				for _, btn in _G.pairs(_G.QuickJoinRoleSelectionFrame.Roles) do
					self:skinCheckButton{obj=btn.CheckButton, fType=ftype}
				end
			end

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.QuickJoinRoleSelectionFrame)

	end

	aObj.blizzFrames[ftype].GuildInvite = function(self)
		if not self.prdb.GuildInvite or self.initialized.GuildInvite then return end
		self.initialized.GuildInvite = true

		self:SecureHookScript(_G.GuildInviteFrame, "OnShow", function(this)
			if _G.InCombatLockdown() then
			    self:add2Table(self.oocTab, {self.checkShown, {self, this}})
			    return
			end

			_G.GuildInviteFrameTabardBorder:SetTexture(nil)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true})
			if self.modBtns then
				self:skinStdButton{obj=_G.GuildInviteFrameJoinButton}
				self:skinStdButton{obj=_G.GuildInviteFrameDeclineButton}
			end

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.GuildInviteFrame)

	end

	aObj.blizzLoDFrames[ftype].InspectUI = function(self)
		if not self.prdb.InspectUI or self.initialized.InspectUI then return end
		self.initialized.InspectUI = true

		self:SecureHookScript(_G.InspectFrame, "OnShow", function(this)
			self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true})

			-- let AddOn skins know when when UI is skinned (used by oGlow skin)
			self.callbacks:Fire("InspectUI_Skinned", self)
			self.callbacks.events["InspectUI_Skinned"] = nil

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.InspectFrame)

		self:SecureHookScript(_G.InspectPaperDollFrame, "OnShow", function(this)
			_G.InspectModelFrame:DisableDrawLayer("BACKGROUND")
			_G.InspectModelFrame:DisableDrawLayer("BORDER")
			_G.InspectModelFrame:DisableDrawLayer("OVERLAY")
			_G.InspectModelFrame.controlFrame:DisableDrawLayer("BACKGROUND")
			self.RegisterCallback("IPDF", "IPDIF_GetChildren", function(_, child, _)
				if self:hasTextInName(child, "Slot")
				and self.modBtnBs
				then
					child:DisableDrawLayer("BACKGROUND")
					self:addButtonBorder{obj=child, fType=ftype, ibt=true}
				elseif self:hasTextInDebugNameRE(child, "InspectTalents$")
				and self.modBtns
				then
					self:skinStdButton{obj=child, fType=ftype, sechk=true}
					if _G.C_AddOns.IsAddOnLoaded("BetterCharacterPanel") then
						child:SetSize(102, 24)
						child.Text:SetPoint("CENTER", 0, 0)
						self:moveObject{obj=child, x=-15, y=35}
						child.LeftHighlight:SetTexture(nil)
						child.RightHighlight:SetTexture(nil)
						child.MiddleHighlight:SetTexture(nil)
					end
				end
			end)
			self:scanChildren{obj=_G.InspectPaperDollItemsFrame, cbstr="IPDIF_GetChildren"}
			if self.modBtns then
				self:skinStdButton{obj=this.ViewButton}
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
		self:checkShown(_G.InspectPaperDollFrame)

		self:SecureHookScript(_G.InspectPVPFrame, "OnShow", function(this)
			this.BG:SetTexture(nil)
			for _, slot in _G.ipairs(this.Slots) do
				slot.Border:SetTexture(nil)
				self:makeIconSquare(slot, "Texture", "gold")
			end

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.InspectPVPFrame)

		-- N.B. InspectTalentFrame now replaced by new TalentUI

		self:SecureHookScript(_G.InspectGuildFrame, "OnShow", function(this)
			_G.InspectGuildFrameBG:SetAlpha(0)
			this.Points:DisableDrawLayer("BACKGROUND")

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.InspectGuildFrame)

	end
end

aObj.blizzLoDFrames[ftype].ItemSocketingUI = function(self)
	if not self.prdb.ItemSocketingUI or self.initialized.ItemSocketingUI then return end
	self.initialized.ItemSocketingUI = true

	-- copy of GEM_TYPE_INFO from Blizzard_ItemSocketingUI.lua
	local gemTypeInfo = {
		["Yellow"]          = {textureKit = "yellow", r = 0.97, g = 0.82, b = 0.29},
		["Red"]             = {textureKit = "red", r = 1, g = 0.47, b = 0.47},
		["Blue"]            = {textureKit = "blue", r = 0.47, g = 0.67, b = 1},
		["Meta"]            = {textureKit = "meta", r = 1, g = 1, b = 1},
		["Prismatic"]       = {textureKit = "prismatic", r = 1, g = 1, b = 1},
	}
	if self.isMnln then
		gemTypeInfo["Hydraulic"]       = {textureKit = "hydraulic", r = 1, g = 1, b = 1}
		gemTypeInfo["Cogwheel"]        = {textureKit = "cogwheel", r = 1, g = 1, b = 1}
		gemTypeInfo["PunchcardRed"]    = {textureKit = "punchcard-red", r = 1, g = 0.47, b = 0.47}
		gemTypeInfo["PunchcardYellow"] = {textureKit = "punchcard-yellow", r = 0.97, g = 0.82, b = 0.29}
		gemTypeInfo["PunchcardBlue"]   = {textureKit = "punchcard-blue", r = 0.47, g = 0.67, b = 1}
		gemTypeInfo["Domination"]      = {textureKit = "domination", r = 1, g = 1, b = 1}
		gemTypeInfo["Cypher"]          = _G.CopyTable(gemTypeInfo["Meta"], true)
		gemTypeInfo["Tinker"]          = _G.CopyTable(gemTypeInfo["PunchcardRed"], true)
		gemTypeInfo["Primordial"]      = _G.CopyTable(gemTypeInfo["Meta"], true)
		gemTypeInfo["Fragrance"]       = _G.CopyTable(gemTypeInfo["Hydraulic"], true)
		gemTypeInfo["SingingThunder"]  = _G.CopyTable(gemTypeInfo["Yellow"], true)
		gemTypeInfo["SingingSea"]      = _G.CopyTable(gemTypeInfo["Blue"], true)
		gemTypeInfo["SingingWind"]     = _G.CopyTable(gemTypeInfo["Red"], true)
		gemTypeInfo["Fiber"]           = _G.CopyTable(gemTypeInfo["Hydraulic"], true)
	end
	-- setup default for missing entry
	_G.setmetatable(gemTypeInfo, {__index = function(t, k)
		--@debug@
		_G.assert(false, "Missing GEM_TYPE_INFO entry for " .. k)
		--@end-debug@
		return t["Meta"]
	end})

	local numSockets, clr
	local function colourSockets(frame)
		numSockets = _G.C_ItemSocketInfo.GetNumSockets()
		for i, socket in _G.ipairs(frame.SocketingContainer.SocketFrames) do
			if socket.sb
			and i <= numSockets
			then
				clr = gemTypeInfo[_G.C_ItemSocketInfo.GetSocketTypes(i)]
				socket.sb:SetBackdropBorderColor(clr.r, clr.g, clr.b)
			end
		end
	end
	self:SecureHookScript(_G.ItemSocketingFrame, "OnShow", function(this)
		if _G.InCombatLockdown() then
		    self:add2Table(self.oocTab, {self.checkShown, {self, this}})
		    return
		end

		self:skinObject("scrollbar", {obj=_G.ItemSocketingScrollFrame.ScrollBar, fType=ftype})
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true, x2=3})
		if self.modBtns then
			self:skinStdButton{obj=this.SocketingContainer.ApplySocketsButton, fType=ftype, schk=true}
			for _, socket in _G.ipairs(this.SocketingContainer.SocketFrames) do
				socket:DisableDrawLayer("BACKGROUND")
				socket:DisableDrawLayer("BORDER")
				self:skinObject("button", {obj=socket, fType=ftype, bd=10, ng=true})
			end
			self:SecureHook("ItemSocketingFrame_Update", function()
				colourSockets(this)
			end)
			colourSockets(this)
		end

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.ItemSocketingFrame)

end

if aObj.isMorF then
	aObj.blizzFrames[ftype].LootFrames = function(self)
		if not self.prdb.LootFrames.skin or self.initialized.LootFrames then return end
		self.initialized.LootFrames = true

		self:SecureHookScript(_G.LootFrame, "OnShow", function(this)
			if _G.InCombatLockdown() then
			    self:add2Table(self.oocTab, {self.checkShown, {self, this}})
			    return
			end

			this.Bg:DisableDrawLayer("BACKGROUND")
			self:removeNineSlice(this.NineSlice)
			self:skinObject("scrollbar", {obj=this.ScrollBar, fType=ftype})
			self:keepFontStrings(this.ScrollBox.Shadows)
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
					if element.Item then
						element.NameFrame:SetTexture(nil)
						element.BorderFrame:SetAlpha(0)
						element.HighlightNameFrame:SetTexture(nil)
						element.PushedNameFrame:SetTexture(nil)
						if element.QualityStripe then
							element.QualityStripe:SetTexture(nil)
						end
						if aObj.modBtnBs then
							aObj:addButtonBorder{obj=element.Item, fType=ftype, ibt=true, ofs=3, y2=-2}
						end
					end
				end
			end
			_G.ScrollUtil.AddAcquiredFrameCallback(this.ScrollBox, skinElement, aObj, true)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, rns=true, x1=4})
			if self.modBtns then
				self:skinCloseButton{obj=this.ClosePanelButton, fType=ftype}
			end

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.LootFrame)

		local function skinGroupLoot(frame)
			frame:DisableDrawLayer("BACKGROUND")
			frame:DisableDrawLayer("BORDER")
			aObj:skinObject("statusbar", {obj=frame.Timer, fi=0, bg=frame.Timer.Background})
			-- hook this to show the Timer
			aObj:SecureHook(frame, "Show", function(fObj)
				fObj.Timer:SetFrameLevel(fObj:GetFrameLevel() + 1)
			end)
			frame:SetScale(aObj.prdb.LootFrames.size ~= 1 and 0.75 or 1)
			frame.IconFrame.Border:SetAlpha(0)
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=frame.IconFrame, fType=ftype, relTo=frame.IconFrame.Icon}
				-- TODO: colour the item border
			end
			-- if aObj.modBtns then
			-- 	aObj:skinCloseButton{obj=frame.PassButton}
			-- end
			if aObj.prdb.LootFrames.size ~= 3 then -- Normal or small
				aObj:skinObject("frame", {obj=frame, fType=ftype, kfs=true, x1=-3, y2=-3})
			else -- Micro
				aObj:moveObject{obj=frame.IconFrame, x=95, y=5}
				frame.Name:SetAlpha(0)
				frame.NeedButton:ClearAllPoints()
				frame.NeedButton:SetPoint("TOPRIGHT", "$parent", "TOPRIGHT", -34, -4)
				frame.PassButton:ClearAllPoints()
				frame.PassButton:SetPoint("LEFT", frame.NeedButton, "RIGHT", 0, 2)
				frame.GreedButton:ClearAllPoints()
				frame.GreedButton:SetPoint("RIGHT", frame.NeedButton, "LEFT")
				frame.DisenchantButton:ClearAllPoints()
				frame.DisenchantButton:SetPoint("RIGHT", frame.GreedButton, "LEFT", 2, 0)
				aObj:adjWidth{obj=frame.Timer, adj=-30}
				frame.Timer:ClearAllPoints()
				frame.Timer:SetPoint("BOTTOMRIGHT", "$parent", "BOTTOMRIGHT", -10, 13)
				aObj:skinObject("frame", {obj=frame, fType=ftype, kfs=true, x1=97, y2=8})
			end
		end
		local NUM_GROUP_LOOT_FRAMES = 4
		for i = 1, NUM_GROUP_LOOT_FRAMES do
			self:SecureHookScript(_G["GroupLootFrame" .. i], "OnShow", function(this)
				if _G.InCombatLockdown() then
				    self:add2Table(self.oocTab, {self.checkShown, {self, this}})
				    return
				end

				skinGroupLoot(this)

				self:Unhook(this, "OnShow")
			end)
			self:checkShown(_G["GroupLootFrame" .. i])
		end

		self:SecureHookScript(_G.GroupLootHistoryFrame, "OnShow", function(this)
			if _G.InCombatLockdown() then
			    self:add2Table(self.oocTab, {self.checkShown, {self, this}})
			    return
			end

			this.Bg:DisableDrawLayer("BACKGROUND")
			self:skinObject("ddbutton", {obj=this.EncounterDropdown, fType=ftype})
			self:skinObject("scrollbar", {obj=this.ScrollBar, fType=ftype})
			local function skinHistory(...)
				local _, element, elementData
				if _G.select("#", ...) == 2 then
					element, elementData = ...
				else
					_, element, elementData = ...
				end
				if elementData.lootListID then
					element.BackgroundArtFrame.NameFrame:SetTexture(nil)
					element.BackgroundArtFrame.BorderFrame:SetAlpha(0)
					aObj:skinObject("frame", {obj=element, fType=ftype, kfs=true})
					if aObj.modBtnBs then
						aObj:addButtonBorder{obj=element.Item, fType=ftype, ibt=true}
					end
				end
			end
			_G.ScrollUtil.AddInitializedFrameCallback(this.ScrollBox, skinHistory, aObj, true)
			this.Timer.Background:SetTexture(self.sbTexture)
			this.Timer.Background:SetVertexColor(self.sbClr:GetRGBA())
			this.Timer.Fill:SetTexture(self.sbTexture)
			this.Timer.Border:SetTexture(nil)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ofs=0, y1=-1})
			if self.modBtns then
				self:skinCloseButton{obj=this.ClosePanelButton, fType=ftype}
			end

			self:SecureHookScript(this.PerfectAnimFrame, "OnShow", function(fObj)
				fObj.BackgroundArtFrame.NameFrame:SetTexture(nil)
				fObj.BackgroundArtFrame.BorderFrame:SetAlpha(0)
				self:skinObject("frame", {obj=fObj, fType=ftype, fb=true})
				if self.modBtnBs then
					self:addButtonBorder{obj=fObj.Item, fType=ftype, ibt=true}
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.PerfectAnimFrame)

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.GroupLootHistoryFrame)

		-- BonusRollFrame
		self:SecureHookScript(_G.BonusRollFrame, "OnShow", function(this)
			if _G.InCombatLockdown() then
			    self:add2Table(self.oocTab, {self.checkShown, {self, this}})
			    return
			end

			self:removeRegions(this, {1, 2, 3, 5})
			self:skinObject("statusbar", {obj=this.PromptFrame.Timer, fi=0})
			self:skinObject("frame", {obj=this, fType=ftype, bg=true})

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.BonusRollFrame)

		self:SecureHookScript(_G.MasterLooterFrame, "OnShow", function(this)
			if _G.InCombatLockdown() then
			    self:add2Table(self.oocTab, {self.checkShown, {self, this}})
			    return
			end

			self:removeRegions(this.Item, {2, 3, 4, 5})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true})
			if self.modBtns then
				 self:skinCloseButton{obj=self:getChild(this, 4), fType=ftype} -- unamed close button
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=this.Item, fType=ftype, relTo=this.Item.Icon}
				-- TODO: colour the item border
			end

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.MasterLooterFrame)

	end
end

aObj.blizzFrames[ftype].MirrorTimers = function(self)
	if not self.prdb.MirrorTimers.skin or self.initialized.MirrorTimers then return end
	self.initialized.MirrorTimers = true

	local objName, obj, objBG, objSB
	if not self.isMorF then
		local numMirrorTimerTypes = 3
		for i = 1, numMirrorTimerTypes do
			objName = "MirrorTimer" .. i
			obj = _G[objName]
			self:removeRegions(obj, {3})
			obj:SetHeight(obj:GetHeight() * 1.25)
			self:moveObject{obj=_G[objName .. "Text"], y=-2}
			objBG = self:getRegion(obj, 1)
			objBG:SetWidth(objBG:GetWidth() * 0.75)
			objSB = _G[objName .. "StatusBar"]
			objSB:SetWidth(objSB:GetWidth() * 0.75)
			if self.prdb.MirrorTimers.glaze then
				self:skinObject("statusbar", {obj=objSB, fi=0, bg=objBG})
			end
		end
	else
		for _, timer in _G.pairs(_G.MirrorTimerContainer.mirrorTimers) do
			if timer.StatusBar then
				self:removeRegions(timer, {1, 4}) -- TextBorder & Border
				if self.prdb.MirrorTimers.glaze then
					self:skinObject("statusbar", {obj=timer.StatusBar, fi=0, bg=self:getRegion(timer, 2), hookFunc=true})
				end
			end
		end
		if self.prdb.MirrorTimers.glaze then
			self:SecureHook(_G.MirrorTimerContainer, "SetupTimer", function(this, timer, _)
				local actTimer = this:GetActiveTimer(timer)
				if timer == "EXHAUSTION" then
					actTimer.StatusBar:SetStatusBarColor(self:getColourByName("yellow"))
				elseif timer == "BREATH" then
					actTimer.StatusBar:SetStatusBarColor(self:getColourByName("light_blue"))
				elseif timer == "DEATH" then
					actTimer.StatusBar:SetStatusBarColor(self:getColourByName("blue"))
				else -- FEIGNDEATH
					actTimer.StatusBar:SetStatusBarColor(self:getColourByName("yellow"))
				end
			end)
		end
		-- Battleground/Arena/Island Expeditions Start Timer
		local function skinTT(timer)
			_G[timer.bar:GetName() .. "Border"]:SetTexture(nil) -- animations
			if aObj.prdb.MirrorTimers.glaze then
				if not aObj.sbGlazed[timer.bar]	then
					aObj:skinObject("statusbar", {obj=timer.bar, fi=0, bg=aObj:getRegion(timer.bar, 1)})
				end
				timer.bar:SetStatusBarColor(aObj:getColourByName("red"))
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

if aObj.isMorF then
	aObj.blizzFrames[ftype].ObjectiveTracker = function(self)
		if  not self.prdb.ObjectiveTracker.popups
		and not self.prdb.ObjectiveTracker.headers
		and not self.prdb.ObjectiveTracker.skin
		and not self.prdb.ObjectiveTracker.modules
		and not self.prdb.ObjectiveTracker.animapowers
		and not self.prdb.ObjectiveTracker.rewards
		then
			return
		end
		self.initialized.ObjectiveTracker = true

		local skinAutoPopUp = _G.nop
		if self.prdb.ObjectiveTracker.popups then
			function skinAutoPopUp(block)
				aObj:skinObject("frame", {obj=block.Contents, fType=ftype, kfs=true})
				block.Contents.Exclamation:SetAlpha(1)
				block.Contents.QuestionMark:SetAlpha(1)
				if block.popUpType == "COMPLETE" then
					block.Contents.QuestionMark:Show()
				else
					block.Contents.Exclamation:Show()
				end
			end
		end

		self:SecureHookScript(_G.ObjectiveTrackerFrame, "OnShow", function(this)
			if _G.InCombatLockdown() then
			    self:add2Table(self.oocTab, {self.checkShown, {self, this}})
			    return
			end

			if self.prdb.ObjectiveTracker.headers then
				this.Header.Background:SetTexture(nil)
				if self.modBtnBs then
					self:skinExpandButton{obj=this.Header.MinimizeButton, onSB=true}
				end
			end
			if self.prdb.ObjectiveTracker.skin then
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, x1=-20, y1=4, x2=12, y2=-4})
			end

			-- search for [inherits="ObjectiveTrackerModuleTemplate]
			--[[
				AchievementObjectiveTracker
				AdventureObjectiveTracker
				BonusObjectiveTracker
				CampaignQuestObjectiveTracker
				InitiativeTasksObjectiveTracker (stripped down version of Monthly Activities Objective Tracker) [C_NeighborhoodInitiative]
				MonthlyActivitiesObjectiveTracker
				ProfessionsRecipeTracker
				QuestObjectiveTracker
				ScenarioObjectiveTracker
				UIWidgetObjectiveTracker
				WorldQuestObjectiveTracker
			]]
			local function skinBar(bar)
				-- aObj:Debug("skinBar: [%s, %s]", bar, bar.template)
				if bar.template == "BonusTrackerProgressBarTemplate"
				or bar.template == "ScenarioProgressBarTemplate"
				then
					for _, tex in _G.pairs{"IconBG", "BarFrame", "BarFrame2", "BarFrame3", "BarGlow", "Sheen", "Starburst"} do
						bar.Bar[tex]:SetTexture(nil)
					end
					for _, frame in _G.pairs{"Flare1", "Flare2", "SmallFlare1", "SmallFlare2", "FullBarFlare1", 'FullBarFlare2'} do
						bar[frame]:DisableDrawLayer("ARTWORK")
					end
					aObj:skinObject("statusbar", {obj=bar.Bar, fi=0, bg=bar.Bar.BarBG})
				elseif bar.template == "ObjectiveTrackerProgressBarTemplate"
				or bar.template == "ObjectiveTrackerTimerBarTemplate"
				then
					aObj:removeRegions(bar.Bar, {1, 2, 3}) -- Border textures
					aObj:skinObject("statusbar", {obj=bar.Bar, fi=0, bg=aObj:getPenultimateRegion(bar.Bar)})
				end
			end
			local ignoredStageBlocks = {
				[842] = true, -- Delves
			}
			local modName
			local function skinModule(module, _)
				modName = module:GetName()
				if aObj.prdb.ObjectiveTracker.headers then
					module.Header.Background:SetTexture(nil)
				end
				if module.hasContents
				and self.prdb.ObjectiveTracker.modules
				then
					if modName == "ScenarioObjectiveTracker" then
						for _, block in _G.pairs(module.FixedBlocks) do
							if block == module.ObjectivesBlock then
								if block.spellFramePool
								and aObj.modBtnBs
								then
									for spell in block.spellFramePool:EnumerateActive() do
										aObj:addButtonBorder{obj=spell, fType=ftype, relTo=spell.Icon, reParent={spell.cooldown}, ccat=true}
									end
								end
							elseif block == module.StageBlock then
								-- aObj:Debug("skinModule wSID: [%s, %s]", block.widgetSetID)
								if not ignoredStageBlocks[block.widgetSetID] then
									aObj:skinObject("frame", {obj=block, fType=ftype, kfs=true, ofs=0, x2=-12, y2=8, clr="sepia"})
								end
								-- N.B. widgets skinned in UIWidgets function
							elseif block == module.TopWidgetContainerBlock
							or block == module.BottomWidgetContainerBlock
							then
								_G.nop()
							elseif block == module.MawBuffsBlock then
								-- Blizzard_MawBuffs.xml
								if aObj.prdb.ObjectiveTracker.animapowers then
									aObj.modUIBtns:skinStdButton{obj=block.Container, fType=ftype, ignoreHLTex=true, ofs=-9, x1=12, x2=-2, clr="turq", ca=0.65} -- use module, treat like a frame
									block.Container.SetWidth = _G.nop
									block.Container.SetHighlightAtlas = _G.nop
									aObj:secureHook(block.Container, "UpdateListState", function(bObj, _)
										aObj:clrBtnBdr(bObj)
									end)
									aObj:skinObject("frame", {obj=block.Container.List, fType=ftype, kfs=true, ofs=-9, x1=0, x2=-16, clr="turq", ca=0.65})
									aObj:secureHook(block.Container.List, "Update", function(bObj, _)
										for mawBuff in bObj.buffPool:EnumerateActive() do
											mawBuff.Border:SetTexture(nil)
										end
									end)
								end
							elseif block == module.TieredEntranceTraitsBlock then
								aObj:skinObject("frame", {obj=block.Container, fType=ftype, kfs=true, ofs=0, clr="grey"})
							elseif block == module.ChallengeModeBlock then
								aObj:skinObject("statusbar", {obj=block.StatusBar, fi=0, bg=block.TimerBG, other={block.TimerBGBack}})
								aObj:removeRegions(block, {3}) -- challengemode-timer atlas
								aObj:skinObject("frame", {obj=block, fType=ftype, y2=7})
								aObj:secureHook(block, "SetUpAffixes", function(blk, _)
									for affix in blk.affixPool:EnumerateActive() do
										affix.Border:SetTexture(nil)
									end
								end)
							elseif block == module.ProvingGroundsBlock then
								block.BG:SetTexture(nil)
								block.GoldCurlies:SetTexture(nil)
								aObj:skinObject("statusbar", {obj=block.StatusBar, fi=0})
								aObj:removeRegions(block.StatusBar, {1}) -- border
								block.CountdownAnimFrame.BGAnim:SetTexture(nil)
								block.CountdownAnimFrame.BorderAnim:SetTexture(nil)
								aObj:skinObject("frame", {obj=block, fType=ftype, x2=41})
							end
						end
					end
					if module.usedBlocks then
						for template, blocks in _G.pairs(module.usedBlocks) do
							if template:find("AutoQuestPopUp") then
								for _, block in _G.pairs(blocks) do
									skinAutoPopUp(block)
								end
							end
						end
					end
					if module.usedProgressBars then
						for _, pBar in _G.pairs(module.usedProgressBars) do
							skinBar(pBar)
						end
					end
					if module.usedTimerBars then
						for _, tBar in _G.pairs(module.usedTimerBars) do
							skinBar(tBar)
						end
					end
					if module.usedRightEdgeFrames
					and aObj.modBtnBs
					then
						for _, frame in _G.pairs(module.usedRightEdgeFrames) do
							if frame.template:find("ItemButton") then
								-- N.B.: can cause ADDON_ACTION_FORBIDDEN when clicked
								aObj:addButtonBorder{obj=frame, fType=ftype, ofs=4, clr="gold"}
							elseif frame.template:find("FindGroupButton") then
								aObj:addButtonBorder{obj=frame, fType=ftype, ofs=-1, x1=0, clr="gold"}
							end
						end
					end
				end
			end
			for _, module in _G.pairs(this.modules) do
				skinModule(module)
				self:SecureHook(module, "LayoutContents", function(fObj)
					skinModule(fObj, true)
				end)
			end

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.ObjectiveTrackerFrame)

		if self.prdb.ObjectiveTracker.rewards then
			local function skinRewards(reward)
				for btn in reward.framePool:EnumerateActive() do
					btn.ItemBorder:SetTexture(nil)
					if aObj.modBtnBs then
						aObj:addButtonBorder{obj=btn, fType=ftype, relTo=btn.ItemIcon}
					end
				end
			end
			self:SecureHook(_G.ObjectiveTrackerManager, "ShowRewardsToast", function(this, _, _, _, _, _)
				for rewardsToast in this.rewardsToastPool:EnumerateActive() do
					rewardsToast:DisableDrawLayer("ARTWORK")
					rewardsToast:DisableDrawLayer("BORDER")
					skinRewards(rewardsToast)
				end
			end)

			self:SecureHookScript(_G.ObjectiveTrackerTopBannerFrame, "OnShow", function(this)
				this:DisableDrawLayer("BACKGROUND")
				this:DisableDrawLayer("BORDER")
				this:DisableDrawLayer("OVERLAY")
				this.Filigree:SetDrawLayer("OVERLAY")

				self:Unhook(this, "OnShow")
			end)

			self:SecureHookScript(_G.ScenarioRewardsFrame, "OnShow", function(this)
				if _G.InCombatLockdown() then
				    self:add2Table(self.oocTab, {self.checkShown, {self, this}})
				    return
				end

				this:DisableDrawLayer("ARTWORK")
				this:DisableDrawLayer("BORDER")
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true})
				skinRewards(this)
				self:SecureHook(this, "DisplayRewards", function(fObj, _, _)
					skinRewards(fObj)
				end)

				self:Unhook(this, "OnShow")
			end)
			self:checkShown(_G.ScenarioRewardsFrame)
		end
	end

	aObj.blizzLoDFrames[ftype].PlayerSpells = function(self)
		if not self.prdb.PlayerSpells or self.initialized.PlayerSpells then return end
		self.initialized.PlayerSpells = true

		self:SecureHookScript(_G.PlayerSpellsFrame, "OnShow", function(this)
			if _G.InCombatLockdown() then
				self:add2Table(self.oocTab, {self.checkShown, {self, this}})
				return
			end

			self:skinObject("tabs", {obj=this.TabSystem, pool=true, fType=ftype, ignoreSize=true, track=false})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, rns=true, rp=true, cb=true, y1=0, x2=1})

			self:SecureHookScript(this.MaximizeMinimizeButton, "OnShow", function(fObj)
				fObj:DisableDrawLayer("BACKGROUND")
				if self.modBtns then
					self:skinOtherButton{obj=fObj.MaximizeButton, fType=ftype, font=self.fontS, text=self.nearrow}
					self:skinOtherButton{obj=fObj.MinimizeButton, fType=ftype, font=self.fontS, disfont=self.fontDS, text=self.swarrow}
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.MaximizeMinimizeButton)

			self:SecureHookScript(this.SpecFrame, "OnShow", function(fObj)
				if _G.InCombatLockdown() then
					self:add2Table(self.oocTab, {self.checkShown, {self, fObj}})
					return
				end

				fObj.Background:SetTexture(nil)
				fObj.BlackBG:SetTexture(nil)
				local function skinSpecFrames()
					for specContentFrame in fObj.SpecContentFramePool:EnumerateActive() do
						specContentFrame:DisableDrawLayer("BORDER")
						specContentFrame:DisableDrawLayer("OVERLAY")
						-- add border around SpecImage
						aObj.modUIBtns:addButtonBorder{obj=specContentFrame, fType=ftype, relTo=specContentFrame.SpecImage}
						self:skinObject("frame", {obj=specContentFrame, fType=ftype, chkfb=true, y2=-4})
						if specContentFrame.specIndex == fObj:GetCurrentSpecIndex() then
							self:clrBtnBdr(specContentFrame, "orange")
							if specContentFrame.sf then
								self:clrBBC(specContentFrame.sf, "orange")
							end
						else
							self:clrBtnBdr(specContentFrame, "grey")
							if specContentFrame.sf then
								self:clrBBC(specContentFrame.sf, "grey")
							end
						end
						if aObj.modBtns then
							aObj:skinStdButton{obj=specContentFrame.ActivateButton, fType=ftype, schk=true}
						end
					end
				end
				skinSpecFrames()
				self:SecureHook(fObj, "UpdateSpecFrame", function(_)
					if not _G.C_SpecializationInfo.IsInitialized() then
						return
					end
					skinSpecFrames()
				end)
				self:SecureHook(fObj, "UpdateSpecContents", function(_)
					if _G.GetNumSpecializations(false, false) == 0 then
						return
					end
					skinSpecFrames()
				end)

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.SpecFrame)

			self:SecureHookScript(this.TalentsFrame, "OnShow", function(fObj)
				if _G.InCombatLockdown() then
					self:add2Table(self.oocTab, {self.checkShown, {self, fObj}})
					return
				end

				if self.isMnln then
					fObj.BlackBG:SetTexture(nil)
					fObj.BottomBar:SetTexture(nil)
				else
					fObj.Background:SetTexture(nil)
					fObj:DisableDrawLayer("OVERLAY")
					self:skinObject("tabs", {obj=fObj.TabSystem, pool=true, fType=ftype, ignoreSize=true, track=false, offsets={x1=2, y1=2, x2=-2, y2=-4}})
					self:SecureHook(fObj, "RefreshTreeHeaders", function(frame)
						for hdr in frame.treeHeaderPool:EnumerateActive() do
							self:makeIconSquare(hdr, "Icon", "sepia", {hdr.TextBackground, hdr.Text})
							hdr.MainRing:SetTexture(nil)
							self:changeTandC(hdr.TextBackground)
							hdr.Divider:SetTexture(nil)
						end
					end)
					fObj:UpdateTreeCurrencyInfo(true)
					-- TODO: skin buttons in .ButtonsParent
				end
				local htc = fObj.HeroTalentsContainer
				htc.HeroSpecButton.Border:SetTexture(nil)
				htc.HeroSpecButton.BorderHover:SetTexture(nil)
				-- TODO: Only hide these textures when a spec is selected
				if not htc:IsDisplayingHeroSpecChoices() then
					htc.HeroSpecButton.ChoiceBorder:SetTexture(nil)
					htc.HeroSpecButton.ChoiceBorderHover:SetTexture(nil)
				else
					self:SecureHook(htc, "UpdateHeroSpecButton", function(frame)
						if not htc:IsDisplayingHeroSpecChoices() then
							htc.HeroSpecButton.ChoiceBorder:SetTexture(nil)
							htc.HeroSpecButton.ChoiceBorderHover:SetTexture(nil)
						end
						self:Unhook(frame, "UpdateHeroSpecButton")
					end)
				end
				self:changeTandC(htc.CurrencyFrame.Background)
				-- .CollapseButton is displayed when Hero Spec hasn't been selected
				self:skinObject("frame", {obj=htc.PreviewContainer, fType=ftype, kfs=true, fb=true, ofs=-26, y1=-45, clr="grey"})
				self:skinObject("frame", {obj=htc.ExpandedContainer, fType=ftype, kfs=true, fb=true, ofs=-26, y1=-45})
				self:skinObject("frame", {obj=htc.CollapsedContainer, fType=ftype, kfs=true, fb=true, ofs=-26, y1=-45})
				-- .HeroTalentsUnlockedAnimFrame

				self:skinObject("ddbutton", {obj=fObj.LoadSystem.Dropdown, fType=ftype})
				self:skinObject("editbox", {obj=fObj.SearchBox, fType=ftype, si=true, y1=-4, y2=4})
				self:skinSearchPreviewContainer(fObj.SearchPreviewContainer)
				self:skinObject("ddbutton", {obj=fObj.SearchOptionsDropdown, fType=ftype, noSF=true, ofs=0, clr="gold"})
				if self.modBtns then
					self:skinStdButton{obj=fObj.ApplyButton, fType=ftype, sechk=true, ofs=2}
					self:skinStdButton{obj=fObj.InspectCopyButton, fType=ftype}
				end
				if self.isMnln then
					fObj.WarmodeButton.Ring:SetAlpha(0)
					self:SecureHookScript(fObj.PvPTalentList, "OnShow", function(frame)
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
								element.Border:SetTexture(nil)
								element.Selected:SetTexture(nil)
								element.SelectedOtherCheck:SetTexture(nil)
							end
							if aObj.modBtnBs then
								aObj:addButtonBorder{obj=element, fType=ftype, relTo=element.Icon, clr=(elementData.selectedHere or elementData.selectedOther) and "yellow" or "green"}
								if element.sbb then
									aObj:clrBtnBdr(element, (elementData.selectedHere or elementData.selectedOther) and "yellow" or "green")
								end
							end
						end
						_G.ScrollUtil.AddAcquiredFrameCallback(frame.ScrollBox, skinElement, aObj, true)
						self:skinObject("frame", {obj=frame, fType=ftype, kfs=true, ofs=6})

						self:Unhook(frame, "OnShow")
					end)
				else
					fObj.ClassCurrencyDisplay.Border:SetTexture(nil)
				end

				self:SecureHookScript(_G.HeroTalentsSelectionDialog, "OnShow", function(frame)
					for spec in frame.SpecContentFramePool:EnumerateActive() do
						spec.ColumnDivider:SetTexture(nil)
						-- TODO: make the SpecImage square ?
						spec.SpecImageBorder:SetTexture(nil)
						spec.SpecImageBorderSelected:SetTexture(nil)
						for _, texArray in _G.pairs{"ActivatedLeftFrames", "ActivatedRightFrames"} do
							for _, tex in _G.ipairs(spec[texArray]) do
								tex:SetTexture(nil)
							end
						end
						self:skinObject("frame", {obj=spec, fType=ftype, fb=true})
						if self.modBtns then
							self:skinStdButton{obj=spec.ActivateButton, fType=ftype}
							self:skinStdButton{obj=spec.ApplyChangesButton, fType=ftype, sechk=true}
						end
					end
					self:skinObject("frame", {obj=frame, fType=ftype, kfs=true, cb=true, x1=2})

					self:Unhook(frame, "OnShow")
				end)

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.TalentsFrame)

			local elementData, btn
			local function skinSpells()
				for _, view in _G.pairs(_G.PlayerSpellsFrame.SpellBookFrame.PagedSpellsFrame.ViewFrames) do
					for _, spell in _G.ipairs(view:GetLayoutChildren()) do
						if spell.GetElementData then
							elementData = spell:GetElementData()
							spell.Backplate:SetTexture(nil)
							if elementData.isHeader then
								spell.Text:SetTextColor(aObj.HT:GetRGB())
								spell.Border:SetTexture(nil)
							else
								spell.Name:SetTextColor(aObj.HT:GetRGB())
								spell.SubName:SetTextColor(aObj.BT:GetRGB())
								spell.RequiredLevel:SetTextColor(aObj.BT:GetRGB())
								btn = spell.Button
								btn.Border:SetAtlas(nil)
								btn.BorderShadow:SetTexture(nil)
								btn.BorderSheen:SetTexture(nil)
								-- fix for #177 ADDON_ACTION_FORBIDDEN AddOn 'Skinner' tried to call the protected function 'CastSpellByID()'
								aObj:secureHook(spell, "UpdateVisuals", function(sObj)
									sObj.Button.Border:SetAtlas(nil)
								end)
								if aObj.modBtnBs then
									aObj:addButtonBorder{obj=btn, fType=ftype, relTo=btn.Icon, rpA=true, ofs=3, sba=true}
								end
							end
						end
					end
				end
			end
			self:SecureHookScript(this.SpellBookFrame, "OnShow", function(fObj)
				if _G.InCombatLockdown() then
					self:add2Table(self.oocTab, {self.checkShown, {self, fObj}})
					return
				end

				fObj:DisableDrawLayer("BACKGROUND")
				fObj.HelpPlateButton.Ring:SetTexture(nil)
				if self.isMnln then
					self:skinObject("tabs", {obj=fObj.CategoryTabSystem, pool=true, fType=ftype, ignoreSize=true, track=false})
				else
					-- 7 is icon, 8 is IconMask, 10 is SquareBackgroundActive, 15 is Text
					for _, tab in _G.ipairs(fObj.CategoryTabSystem.tabs) do
						self:keepRegions(tab, {7, 8, 10, 15})
					end
				end
				self:getRegion(fObj.AssistedCombatRotationSpellFrame, 2):SetTexture(nil)
				self:skinObject("editbox", {obj=fObj.SearchBox, fType=ftype, si=true, y1=-4, y2=4})
				self:skinSearchPreviewContainer(fObj.SearchPreviewContainer)
				self:skinObject("frame", {obj=fObj.PagedSpellsFrame, fType=ftype, kfs=true, fb=true, x1=0, y1=self.isFrvr and -4 or 8, x2=self.isFrvr and 2 or 3, y2=-4})
				skinSpells()
				fObj.PagedSpellsFrame:RegisterCallback(_G.PagedContentFrameBaseMixin.Event.OnUpdate, skinSpells, aObj)
				self:skinPageBtns(fObj.PagedSpellsFrame)
				if self.modBtnBs then
					if self.isFrvr then
						self:addButtonBorder{obj=fObj.SettingsDropdown, fType=ftype, ofs=0, y1=2, y2=4, relTo=fObj.SettingsDropdown.Icon, clr="gold"}
					end
					self:addButtonBorder{obj=fObj.AssistedCombatRotationSpellFrame.Button, fType=ftype, sft=true, ofs=4}
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.SpellBookFrame)

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.PlayerSpellsFrame)

		self:SecureHookScript(_G.ClassTalentLoadoutCreateDialog, "OnShow", function(fObj)
			self:removeNineSlice(fObj.Border)
			self:skinObject("editbox", {obj=fObj.NameControl.EditBox, fType=ftype, y1=-10, y2=10})
			self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, ofs=-3})
			if self.modBtns then
				self:skinStdButton{obj=fObj.AcceptButton, fType=ftype, sechk=true}
				self:skinStdButton{obj=fObj.CancelButton, fType=ftype}
			end

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(_G.ClassTalentLoadoutCreateDialog)

		self:SecureHookScript(_G.ClassTalentLoadoutImportDialog, "OnShow", function(fObj)
			self:removeNineSlice(fObj.Border)
			self:skinObject("frame", {obj=fObj.ImportControl.InputContainer, fType=ftype, kfs=true, fb=true, ofs=6})
			self:skinObject("editbox", {obj=fObj.NameControl.EditBox, fType=ftype, y1=-10, y2=10})
			self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, ofs=-3})
			if self.modBtns then
				self:skinStdButton{obj=fObj.AcceptButton, fType=ftype, sechk=true}
				self:skinStdButton{obj=fObj.CancelButton, fType=ftype}
			end

			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(_G.ClassTalentLoadoutImportDialog)

		self:SecureHookScript(_G.ClassTalentLoadoutEditDialog, "OnShow", function(fObj)
			self:removeNineSlice(fObj.Border)
			self:skinObject("editbox", {obj=fObj.NameControl.EditBox, fType=ftype, y1=-10, y2=10})
			self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, ofs=-3})
			if self.modBtns then
				self:skinStdButton{obj=fObj.AcceptButton, fType=ftype, sechk=true}
				self:skinStdButton{obj=fObj.DeleteButton, fType=ftype}
				self:skinStdButton{obj=fObj.CancelButton, fType=ftype}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=fObj.UsesSharedActionBars.CheckButton, fType=ftype}
			end
			self:Unhook(fObj, "OnShow")
		end)
		self:checkShown(_G.ClassTalentLoadoutEditDialog)

	end

	local skinHdrs, skinNISpinner, skinQualityDialog, skinReagentBtn, skinReagentBtns, skinRecraftSlot = _G.nop, _G.nop, _G.nop, _G.nop, _G.nop, _G.nop
	aObj.blizzLoDFrames[ftype].ProfessionsTemplates = function(self)
		if not self.prdb.Professions or self.initialized.ProfessionsTemplates then return end
		self.initialized.ProfessionsTemplates = true

		self:RawHook("OpenProfessionsItemFlyout", function(...)
			local flyout = self.hooks.OpenProfessionsItemFlyout(...)
			self:skinObject("frame", {obj=flyout, fType=ftype, kfs=true, rns=true, ofs=0})
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
						-- TODO: sort out item colour issue
						if not element.sbb then
							self:addButtonBorder{obj=element, fType=ftype, ibt=true, relTo=element.Icon}
						else
							self:clrButtonFromBorder(element)
						end
					end
				end
				_G.ScrollUtil.AddAcquiredFrameCallback(flyout.ScrollBox, skinElement, aObj, true)
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=flyout.HideUnownedCheckbox, fType=ftype}
			end

			self:Unhook("OpenProfessionsItemFlyout")
			return flyout
		end, true)

		if self.modBtnBs then
			function skinReagentBtn(btn, ignTex)
				ignTex = ignTex or false
				if btn.CropFrame then
					btn.CropFrame:SetTexture(nil)
					-- show Normal/Pushed texture if CropFrame shown
					if btn.CropFrame:IsShown() then
						ignTex = true
					end
				end
				if btn.SlotBackground then
					btn.SlotBackground:SetTexture(nil)
				end
				if not btn.sbb then
					aObj:addButtonBorder{obj=btn, fType=ftype, ibt=true, relTo=btn.Icon, reParent={btn.ColorOverlay, btn.HighlightTexture, btn.QualityOverlay, btn.InputOverlay}, ignTex=ignTex}
				end
			end
			function skinReagentBtns(sfFrame)
				for slot in sfFrame.reagentSlotPool:EnumerateActive() do
					skinReagentBtn(slot.Button)
					if aObj.modChkBtns
					and slot.Checkbox
					then
						aObj:skinCheckButton{obj=slot.Checkbox, fType=ftype}
					end
				end
				if sfFrame.extraSlotFrames then
					for _, slot in _G.pairs(sfFrame.extraSlotFrames) do
						if slot.Button
						and (slot == sfFrame.salvageSlot
						or slot == sfFrame.enchantSlot)
						then
							skinReagentBtn(slot.Button)
						end
					end
				end
			end
		end

		function skinHdrs(frame)
			for hdr in frame.tableBuilder:EnumerateHeaders() do
				hdr:DisableDrawLayer("BACKGROUND")
				aObj:skinObject("frame", {obj=hdr, fType=ftype, ofs=1})
			end
		end

		function skinNISpinner(ebObj)
			ebObj:DisableDrawLayer("BACKGROUND")
			aObj:skinObject("editbox", {obj=ebObj, fType=ftype, chginset=false, ofs=0, x1=-6})
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=ebObj.IncrementButton, ofs=0, x2=-1, clr="gold", sechk=true}
				aObj:addButtonBorder{obj=ebObj.DecrementButton, ofs=0, x2=-1, clr="gold", sechk=true}
			end
		end

		function skinQualityDialog(frame)
			for _, c in _G.pairs(frame.containers) do
				skinReagentBtn(c.Button)
				skinNISpinner(c.EditBox)
			end
			aObj:skinObject("frame", {obj=frame, fType=ftype, kfs=true, rns=true})
			if aObj.modBtns then
				aObj:skinCloseButton{obj=frame.ClosePanelButton, fType=ftype}
				aObj:skinStdButton{obj=frame.CancelButton, fType=ftype}
				aObj:skinStdButton{obj=frame.AcceptButton, fType=ftype, sechk=true}
			end
		end

		function skinRecraftSlot(frame)
			frame.Background:SetAlpha(0)
			frame.InputSlot.BorderTexture:SetAlpha(0)
			skinReagentBtn(frame.InputSlot, true)
			frame.OutputSlot.ItemFrame:SetTexture(nil)
			skinReagentBtn(frame.OutputSlot)
		end

	end

	aObj.blizzLoDFrames[ftype].Professions = function(self)
		if not self.prdb.Professions or self.initialized.Professions then return end
		self.initialized.Professions = true

		local function skinSchematicForm(frame)
			skinRecraftSlot(frame.recraftSlot)
			aObj:removeRegions(frame.RecipeLevelBar, {1, 2, 3})
			aObj:skinObject("statusbar", {obj=frame.RecipeLevelBar, fi=0})
			aObj:skinObject("ddbutton", {obj=frame.RecipeLevelDropdown, fType=ftype})
			aObj:skinObject("frame", {obj=frame.Details.QualityMeter.Border, fType=ftype, kfs=true, fb=true, x2=0, y2=3})
			aObj:skinObject("frame", {obj=frame.Details, fType=ftype, kfs=true, fb=true, x1=3, y1=-14, x2=-5, y2=21})
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=frame.Details.CraftingChoicesContainer.ConcentrateContainer.ConcentrateToggleButton, fType=ftype, x2=1, sechk=true}
				skinReagentBtns(frame)
				aObj:SecureHook(frame, "Init", function(fObj, _)
					skinReagentBtns(fObj)
				end)
			end
			if aObj.modChkBtns then
				aObj:skinCheckButton{obj=frame.TrackRecipeCheckbox, fType=ftype, nh=true}
				aObj:skinCheckButton{obj=frame.AllocateBestQualityCheckbox, fType=ftype, nh=true}
			end
		end
		local function skinCraftingOutputLog(frame)
			aObj:keepFontStrings(frame.ScrollBox.Shadows)
			aObj:skinObject("scrollbar", {obj=frame.ScrollBar, fType=ftype})
			local function skinLine(...)
				local _, element, new
				if _G.select("#", ...) == 2 then
					element, _ = ...
				elseif _G.select("#", ...) == 3 then
					element, _, new = ...
				else
					_, element, _, new = ...
				end
				if new ~= false then
					element.ItemContainer.NameFrame:SetAlpha(0)
					element.ItemContainer.BorderFrame:SetAlpha(0)
					if aObj.modBtnBs then
						aObj:addButtonBorder{obj=element.ItemContainer.Item, fType=ftype, ibt=true}
					end
				end
			end
			_G.ScrollUtil.AddAcquiredFrameCallback(frame.ScrollBox, skinLine, aObj, true)
			aObj:skinObject("frame", {obj=frame, fType=ftype, kfs=true, rns=true})
			if aObj.modBtns then
				aObj:skinCloseButton{obj=frame.ClosePanelButton, fType=ftype}
			end
		end
		local function skinRecipeList(rList)
			rList.Background:SetTexture(nil)
			aObj:removeNineSlice(rList.BackgroundNineSlice)
			aObj:skinObject("ddbutton", {obj=rList.FilterDropdown, fType=ftype, filter=true})
			aObj:skinObject("editbox", {obj=rList.SearchBox, fType=ftype, si=true})
			aObj:skinObject("scrollbar", {obj=rList.ScrollBar, fType=ftype})
			local function skinRecipeEntry(...)
				local _, element, elementData
				if _G.select("#", ...) == 2 then
					element, elementData = ...
				else
					_, element, elementData = ...
				end
				if elementData.data.categoryInfo then
					-- element:GetNormalTexture():GetTexture():SetTexture(nil)
					aObj:keepFontStrings(element)
					aObj:skinObject("statusbar", {obj=element.RankBar, regions={1, 2, 3}, fi=0})
				elseif elementData.isDivider then
					aObj:keepFontStrings(element)
				-- elseif elementData.data.recipeInfo then
				end
			end
			_G.ScrollUtil.AddInitializedFrameCallback(rList.ScrollBox, skinRecipeEntry, aObj, true)
		end
		local function skinProfessionsFrame()
			local this = _G.ProfessionsFrame
			_G.RunNextFrame(function()
				self:skinObject("tabs", {obj=this.TabSystem, pool=true, fType=ftype, ignoreSize=true, selectedTab=1, track=false})
			end)
			if self.isFrvr then
				this.Bg:SetTexture(nil)
				this.TopTileStreaks:SetTexture(nil)
				this.ProfessionsOverviewTab.Background:SetTexture(nil)
				self:skinObject("button", {obj=this.ProfessionsOverviewTab, fType=ftype, x1=-3, y1=-2, x2=-4, y2=2})
				self:skinObject("sidetabs", {obj=this, tabs="rightProfessionTabs", fType=ftype})
				-- .TabIndicators [inherits="GamepadTabIndicatorsTemplate"]
			end
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true})
			if not self.isFrvr then
				if self.modBtns then
					self:skinOtherButton{obj=this.MaximizeMinimize.MaximizeButton, font=self.fontS, text=self.nearrow}
					self:skinOtherButton{obj=this.MaximizeMinimize.MinimizeButton, font=self.fontS, text=self.swarrow}
				end
			end

			self:SecureHookScript(this.CraftingPage, "OnShow", function(fObj)
				self:keepFontStrings(fObj)
				fObj.TutorialButton.Ring:SetTexture(nil)
				fObj.GearSlotDivider:DisableDrawLayer("ARTWORK")
				self:skinObject("ddbutton", {obj=fObj.RankBar.ExpansionDropdownButton, fType=ftype, noSF=true, bx1=-5, by1=3, bx2=1, by2=-3})
				skinRecipeList(fObj.RecipeList)
				self:skinObject("frame", {obj=fObj.RecipeList, fType=ftype, kfs=true, fb=true, ofs=4, x2=0})
				self:keepFontStrings(fObj.SchematicForm)
				-- fObj.SchematicForm.Background:SetAlpha(0)
				-- fObj.SchematicForm.MinimalBackground:SetAlpha(0)
				self:removeNineSlice(fObj.SchematicForm.NineSlice)
				skinSchematicForm(fObj.SchematicForm)
				aObj:skinObject("frame", {obj=fObj.SchematicForm, fType=ftype, fb=true, ofs=4, x2=self.isFrvr and 1 or 5, y2=0})
				fObj.RankBar.Border:SetTexture(nil)
				skinNISpinner(fObj.CreateMultipleInputBox)
				self:skinObject("scrollbar", {obj=fObj.GuildFrame.Container.ScrollBar, fType=ftype})
				self:skinObject("frame", {obj=fObj.GuildFrame.Container, fType=ftype, kfs=true, rns=true, fb=true})
				if self.modBtns then
					self:skinStdButton{obj=fObj.CreateAllButton, fType=ftype, sechk=true}
					self:skinStdButton{obj=fObj.CreateButton, fType=ftype, sechk=true}
					self:skinStdButton{obj=fObj.ViewGuildCraftersButton, fType=ftype, sechk=true}
				end
				if self.modBtnBs then
					self:addButtonBorder{obj=fObj.ConcentrationDisplay, fType=ftype, relTo=fObj.ConcentrationDisplay.Icon, ofs=3}
					self:addButtonBorder{obj=fObj.LinkButton, fType=ftype--[[, ofs=-2, x1=0, y1=-4]]}
					for _, btn in _G.pairs(fObj.InventorySlots) do
						btn.NormalTexture:SetTexture(nil)
						self:addButtonBorder{obj=btn, fType=ftype, ibt=true}
						self:clrButtonFromBorder(btn)
					end
				end

				self:SecureHookScript(fObj.SchematicForm.QualityDialog, "OnShow", function(frame)
					skinQualityDialog(frame)

					self:Unhook(frame, "OnShow")
				end)

				self:SecureHookScript(fObj.CraftingOutputLog, "OnShow", function(frame)
					skinCraftingOutputLog(frame)

					self:Unhook(frame, "OnShow")
				end)

				self:Unhook(fObj, "OnShow")
			end)

			if self.isMnln then
				self:SecureHookScript(this.SpecPage, "OnShow", function(fObj)
					local function skinTabs(tabsPool)
						for tab in tabsPool:EnumerateActive() do
							aObj:keepFontStrings(tab)
							if not aObj.isTT then
								aObj:skinObject("frame", {obj=tab, fType=ftype})
							else
								aObj:skinObject("frame", {obj=tab, fType=ftype, noBdr=true, y2=0})
								if tab.isSelected then
									aObj:setActiveTab(tab.sf)
								else
									aObj:setInactiveTab(tab.sf)
								end
							end
							tab.sf.ignore = true
						end
					end
					self:SecureHook(fObj, "InitializeTabs", function(frame, _)
							skinTabs(frame.tabsPool)
					end)
					skinTabs(fObj.tabsPool)
					if self.isTT then
						local function TabSelectedCallback(_, selectedID)
							for tab in fObj.tabsPool:EnumerateActive() do
								if tab.sf then
									aObj:setInactiveTab(tab.sf)
									if tab.traitTreeID == selectedID then
										aObj:setActiveTab(tab.sf)
									end
								end
							end
						end
						_G.EventRegistry:RegisterCallback("ProfessionsSpecializations.TabSelected", TabSelectedCallback, self)
					end
					fObj.PanelFooter:DisableDrawLayer("OVERLAY")
					self:skinObject("frame", {obj=fObj.TreeView, fType=ftype, kfs=true, rns=true, fb=true, y1=4, x2=-38})
					fObj.DetailedView.UnspentPoints.CurrencyBackground:SetAlpha(0)
					self:skinObject("frame", {obj=fObj.DetailedView, fType=ftype, kfs=true, rns=true, fb=true, y1=4})
					fObj.VerticalDivider:DisableDrawLayer("OVERLAY")
					fObj.TopDivider:DisableDrawLayer("OVERLAY")
					fObj.TreePreview.PathIcon.Ring:SetTexture(nil)
					self:skinObject("frame", {obj=fObj.TreePreview, fType=ftype, fb=true, y1=5})
					if self.modBtns then
						self:skinStdButton{obj=fObj.ApplyButton, fType=ftype, sechk=true, ofs=2}
						self:skinStdButton{obj=fObj.UnlockTabButton, fType=ftype, sechk=true, ofs=2}
						self:skinStdButton{obj=fObj.ViewTreeButton, fType=ftype, ofs=2}
						self:skinStdButton{obj=fObj.BackToPreviewButton, fType=ftype, ofs=2}
						self:skinStdButton{obj=fObj.ViewPreviewButton, fType=ftype, ofs=2}
						self:skinStdButton{obj=fObj.BackToFullTreeButton, fType=ftype, ofs=2}
						self:skinStdButton{obj=fObj.DetailedView.UnlockPathButton, fType=ftype, sechk=true}
						self:skinStdButton{obj=fObj.DetailedView.SpendPointsButton, fType=ftype, sechk=true}
					end

					self:Unhook(fObj, "OnShow")
				end)

				self:SecureHookScript(this.OrdersPage, "OnShow", function(fObj)
					self:SecureHook(fObj, "SetupTable", function(frame, _)
						skinHdrs(frame)
					end)
					skinHdrs(fObj)

					self:SecureHookScript(fObj.BrowseFrame, "OnShow", function(frame)
						self:skinObject("tabs", {obj=frame, tabs=frame.orderTypeTabs, fType=ftype, ignoreSize=true, lod=self.isTT and true, offsets={y2=-4}, track=false})
						if self.isTT then
							self:SecureHook(fObj, "SetCraftingOrderType", function(frmObj, orderType)
								for _, typeTab in _G.ipairs(frmObj.BrowseFrame.orderTypeTabs) do
									if typeTab.orderType == orderType then
										self:setActiveTab(typeTab.sf)
									else
										self:setInactiveTab(typeTab.sf)
									end
								end
							end)
						end
						self:skinObject("frame", {obj=frame, fType=ftype, kfs=true, fb=true, ofs=-1, y1=-90})
						skinRecipeList(frame.RecipeList)
						-- frame.RecipeList.Background:SetTexture(nil)
						-- self:removeNineSlice(frame.RecipeList.BackgroundNineSlice)
						-- self:skinObject("ddbutton", {obj=frame.RecipeList.FilterDropdown, fType=ftype, filter=true})
						-- self:skinObject("editbox", {obj=frame.RecipeList.SearchBox, fType=ftype, si=true})
						-- self:skinObject("scrollbar", {obj=frame.RecipeList.ScrollBar, fType=ftype})
						-- local function skinRecipeElement(...)
						-- 	local _, element, new
						-- 	if _G.select("#", ...) == 2 then
						-- 		element, _ = ...
						-- 	elseif _G.select("#", ...) == 3 then
						-- 		element, _, new = ...
						-- 	else
						-- 		_, element, _, new = ...
						-- 	end
						-- 	if new ~= false then
						-- 		element:DisableDrawLayer("BACKGROUND")
						-- 		if element.RankBar then
						-- 			aObj:skinObject("statusbar", {obj=element.RankBar, regions={1, 2, 3}, fi=0})
						-- 		end
						-- 	end
						-- end
						-- _G.ScrollUtil.AddAcquiredFrameCallback(frame.RecipeList.ScrollBox, skinRecipeElement, aObj, true)
						frame.OrderList.Background:SetTexture(nil)
						self:removeNineSlice(frame.OrderList.NineSlice)
						self:skinObject("scrollbar", {obj=frame.OrderList.ScrollBar, fType=ftype})
						frame.OrdersRemainingDisplay.Background:SetTexture(nil)
						if self.modBtns then
							self:skinStdButton{obj=frame.FavoritesSearchButton, fType=ftype, ofs=-2, clr="gold"}
							self:skinStdButton{obj=frame.SearchButton, fType=ftype}
							self:skinStdButton{obj=frame.BackButton, fType=ftype}
						end

						self:Unhook(frame, "OnShow")
					end)
					self:checkShown(fObj.BrowseFrame)

					self:SecureHookScript(fObj.OrderView, "OnShow", function(frame)
						-- DON'T skin RankBar
						frame.RankBar.Border:SetTexture(nil)
						self:skinObject("ddbutton", {obj=frame.RankBar.ExpansionDropdownButton, fType=ftype, noSF=true, bx1=-5, by1=3, bx2=1, by2=-3})
						self:removeNineSlice(frame.OrderInfo.NineSlice)
						frame.OrderInfo.NoteBox.Background.Border:SetTexture(nil)
						self:skinObject("frame", {obj=frame.OrderInfo.NoteBox, fType=ftype, fb=true, y1=-18})
						frame.OrderInfo.NPCRewardsFrame.Background:SetTexture(nil)
						self:skinObject("frame", {obj=frame.OrderInfo, fType=ftype, kfs=true, fb=true, x1=-5})
						self:removeNineSlice(frame.OrderDetails.NineSlice)
						skinSchematicForm(frame.OrderDetails.SchematicForm)
						self:skinObject("frame", {obj=frame.OrderDetails.FulfillmentForm.NoteEditBox, fType=ftype, kfs=true, fb=true, x1=20, y1=-18, x2=-20})
						self:skinObject("frame", {obj=frame.OrderDetails, fType=ftype, kfs=true, fb=true, x2=4})
						self:skinObject("frame", {obj=frame.DeclineOrderDialog.NoteEditBox, fType=ftype, kfs=true, fb=true, x1=30, y1=-28, x2=-30})
						self:skinObject("frame", {obj=frame.DeclineOrderDialog, fType=ftype, kfs=true})
						if self.modBtns then
							self:skinStdButton{obj=frame.OrderInfo.BackButton, fType=ftype}
							self:skinStdButton{obj=frame.OrderInfo.StartOrderButton, fType=ftype, sechk=true}
							self:skinStdButton{obj=frame.OrderInfo.DeclineOrderButton, fType=ftype}
							self:skinStdButton{obj=frame.OrderInfo.ReleaseOrderButton, fType=ftype}
							self:skinStdButton{obj=frame.CreateButton, fType=ftype, schk=true, sechk=true}
							self:skinStdButton{obj=frame.CompleteOrderButton, fType=ftype,}
							self:skinStdButton{obj=frame.StartRecraftButton, fType=ftype}
							self:skinStdButton{obj=frame.StopRecraftButton, fType=ftype}
							self:skinStdButton{obj=frame.DeclineOrderDialog.CancelButton, fType=ftype}
							self:skinStdButton{obj=frame.DeclineOrderDialog.ConfirmButton, fType=ftype}
						end
						if self.modBtnBs then
							self:addButtonBorder{obj=frame.ConcentrationDisplay, fType=ftype, relTo=frame.ConcentrationDisplay.Icon, ofs=3}
							self:addButtonBorder{obj=frame.OrderInfo.SocialDropdown, fType=ftype, clr="gold", y1=1, y2=-1}
							for _, btn in _G.pairs(frame.OrderInfo.NPCRewardsFrame.RewardItems) do
								self:addButtonBorder{obj=btn, fType=ftype, ibt=true}
							end
						end

						self:SecureHookScript(frame.CraftingOutputLog, "OnShow", function(col)
							skinCraftingOutputLog(col)

							self:Unhook(col, "OnShow")
						end)

						self:Unhook(frame, "OnShow")
					end)

					self:Unhook(fObj, "OnShow")
				end)
			else
				self:SecureHookScript(this.BookPage, "OnShow", function(fObj)
					local function skinProfFrame(frame, x2Ofs)
						frame.StatusBar.Border:SetTexture(nil)
						self:skinObject("ddbutton", {obj=frame.StatusBar.ExpansionDropdownButton, fType=ftype, noSF=true, bx1=-5, by1=3, bx2=1, by2=-3})
						-- .GamepadUnlearnButton
						aObj:skinObject("frame", {obj=frame, fType=ftype, kfs=true, fb=true, ofs=-3, x2=x2Ofs, clr="sepia"})
						if aObj.modBtnBs then
							for _, btn in _G.pairs(frame.spellButtons) do
								aObj:addButtonBorder{obj=btn, sft=true}
							end
							if frame.UnlearnButton then
								aObj:addButtonBorder{obj=frame.UnlearnButton, fType=ftype, relTo=frame.UnlearnButton.Icon, y2=-1, clr="grey"}
							end
						end
					end
					skinProfFrame(fObj.ProfessionsContentFrame["PrimaryProfession1"])
					skinProfFrame(fObj.ProfessionsContentFrame["PrimaryProfession2"])
					skinProfFrame(fObj.ProfessionsContentFrame["SecondaryProfession1"])
					skinProfFrame(fObj.ProfessionsContentFrame["SecondaryProfession2"])
					skinProfFrame(fObj.ProfessionsContentFrame["SecondaryProfession3"], -2)

					self:Unhook(this.BookPage, "OnShow")
				end)
				self:checkShown(this.BookPage)
			end

			_G.EventRegistry:UnregisterCallback("ProfessionsFrame.Show", self)
		end
		_G.EventRegistry:RegisterCallback("ProfessionsFrame.Show", skinProfessionsFrame, self)

	end

	aObj.blizzLoDFrames[ftype].ProfessionsCustomerOrders = function(self)
		if not self.prdb.Professions or self.initialized.ProfessionsCustomerOrders then return end

		if not _G.ProfessionsCustomerOrdersFrame then
			_G.C_Timer.After(0.1, function()
				self.blizzLoDFrames[ftype].ProfessionsCustomerOrders(self)
			end)
			return
		end

		self.initialized.ProfessionsCustomerOrders = true

		self:SecureHookScript(_G.ProfessionsCustomerOrdersFrame, "OnShow", function(this)
			self:removeInset(this.MoneyFrameInset)
			self:removeNineSlice(this.MoneyFrameBorder)
			self:skinObject("tabs", {obj=this, tabs=this.Tabs, fType=ftype, lod=self.isTT and true, track=false})
			if self.isTT then
				self:SecureHook(this, "SelectMode", function(fObj, mode)
					for idx, tab in _G.ipairs(fObj.Tabs) do
						if idx == mode then
							self:setActiveTab(tab.sf)
						else
							self:setInactiveTab(tab.sf)
						end
					end
				end)
			end
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, rns=true, cb=true, y2=1})

			self:SecureHookScript(this.Form, "OnShow", function(fObj)
				self:removeRegions(fObj, {1}) -- RecipeHeader
				self:skinObject("frame", {obj=fObj.LeftPanelBackground, fType=ftype, kfs=true, rns=true, fb=true, x1=-5})
				self:skinObject("frame", {obj=fObj.RightPanelBackground, fType=ftype, kfs=true, rns=true, fb=true, x2=5})
				self:skinObject("ddbutton", {obj=fObj.MinimumQuality.Dropdown, fType=ftype})
				self:skinObject("ddbutton", {obj=fObj.OrderRecipientDropdown, fType=ftype})
				self:skinObject("editbox", {obj=fObj.OrderRecipientTarget, fType=ftype})
				self:skinObject("frame", {obj=fObj.PaymentContainer.NoteEditBox, fType=ftype, kfs=true, fb=true, ofs=-16})
				self:skinObject("editbox", {obj=fObj.PaymentContainer.TipMoneyInputFrame.CopperBox, fType=ftype, y2=4})
				self:skinObject("editbox", {obj=fObj.PaymentContainer.TipMoneyInputFrame.SilverBox, fType=ftype, y2=4})
				self:skinObject("editbox", {obj=fObj.PaymentContainer.TipMoneyInputFrame.GoldBox, fType=ftype, y2=4})
				self:skinObject("ddbutton", {obj=fObj.PaymentContainer.DurationDropdown, fType=ftype})
				if self.modBtns then
					self:skinStdButton{obj=fObj.BackButton, fType=ftype}
					self:skinStdButton{obj=fObj.PaymentContainer.ListOrderButton, fType=ftype, sechk=true}
					self:skinStdButton{obj=fObj.PaymentContainer.CancelOrderButton, fType=ftype, sechk=true}
				end
				if self.modBtnBs then
					self:addButtonBorder{obj=fObj.OrderRecipientDisplay.SocialDropdown, fType=ftype, ofs=1, x1=-1}
					self:addButtonBorder{obj=fObj.PaymentContainer.ViewListingsButton, fType=ftype, ofs=1, x1=-1}
					skinRecraftSlot(fObj.RecraftSlot)
					self:SecureHook(fObj, "UpdateReagentSlots", function(frame)
						skinReagentBtns(frame)
					end)
					skinReagentBtns(fObj)
				end
				if self.modChkBtns then
					self:skinCheckButton{obj=fObj.TrackRecipeCheckbox.Checkbox, fType=ftype, nh=true}
					self:skinCheckButton{obj=fObj.AllocateBestQualityCheckbox, fType=ftype, nh=true}
				end

				self:SecureHookScript(fObj.QualityDialog, "OnShow", function(frame)
					skinQualityDialog(frame)

					self:Unhook(frame, "OnShow")
				end)

				self:SecureHookScript(fObj.CurrentListings, "OnShow", function(frame)
					skinHdrs(frame)
					self:removeNineSlice(frame.OrderList.NineSlice)
					self:skinObject("scrollbar", {obj=frame.OrderList.ScrollBar, fType=ftype})
					frame.OrderList.Background:SetTexture(nil)
					self:skinObject("frame", {obj=frame, fType=ftype, kfs=true, rns=true, ofs=0})
					if self.modBtns then
						self:skinStdButton{obj=frame.CloseButton, fType=ftype}
					end

					self:Unhook(frame, "OnShow")
				end)

				self:Unhook(fObj, "OnShow")
			end)

			self:SecureHookScript(this.BrowseOrders, "OnShow", function(fObj)
				self:skinObject("editbox", {obj=fObj.SearchBar.SearchBox, fType=ftype, si=true})
				self:skinObject("ddbutton", {obj=fObj.SearchBar.FilterDropdown, fType=ftype, filter=true})
				if self.modBtns then
					self:skinStdButton{obj=fObj.SearchBar.FavoritesSearchButton, fType=ftype, ofs=-2}
					self:skinStdButton{obj=fObj.SearchBar.SearchButton, fType=ftype, schk=true}
				end

				self:SecureHook(fObj, "SetupTable", function(frame, _)
					skinHdrs(frame)
				end)
				skinHdrs(fObj)

				self:SecureHookScript(fObj.CategoryList, "OnShow", function(frame)
					frame:DisableDrawLayer("BACKGROUND")
					self:removeNineSlice(frame.NineSlice)
					self:skinObject("scrollbar", {obj=frame.ScrollBar, fType=ftype})
					local function skinCategory(...)
						local _, element, elementData
						if _G.select("#", ...) == 2 then
							element, elementData = ...
						elseif _G.select("#", ...) == 3 then
							_, element, elementData = ...
						end
						aObj.modUIBtns:skinStdButton{obj=element, fType=ftype, ignoreHLTex=true}
						element.sb:ClearAllPoints()
						element.sb:SetShown(true)
						if elementData.data.isSpacer then
							for _, region in _G.ipairs(element.spacerRegions) do
								region:SetShown(false)
							end
							element.sb:SetShown(false)
						elseif elementData.data.categoryInfo then
							if elementData.data.categoryInfo.type == _G.Enum.CraftingOrderCustomerCategoryType.Primary then
								element.sb:SetPoint("TOPLEFT", element, "TOPLEFT", -2, 2)
								element.sb:SetPoint("BOTTOMRIGHT", element, "BOTTOMRIGHT", -4, -1)
							elseif elementData.data.categoryInfo.type == _G.Enum.CraftingOrderCustomerCategoryType.Secondary  then
								element.sb:SetPoint("TOPLEFT", element, "TOPLEFT", 10, 1)
								element.sb:SetPoint("BOTTOMRIGHT", element, "BOTTOMRIGHT", -4, -1)
							elseif elementData.data.categoryInfo.type == _G.Enum.CraftingOrderCustomerCategoryType.Tertiary  then
								element.sb:SetShown(false)
							end
						else -- Start Recrafting Order button
							element.sb:SetPoint("TOPLEFT", element, "TOPLEFT", -2, 2)
							element.sb:SetPoint("BOTTOMRIGHT", element, "BOTTOMRIGHT", -4, -1)
						end
					end
					_G.ScrollUtil.AddInitializedFrameCallback(frame.ScrollBox, skinCategory, aObj, true)

					self:Unhook(frame, "OnShow")
				end)
				self:checkShown(fObj.CategoryList)

				self:SecureHookScript(fObj.RecipeList, "OnShow", function(frame)
					frame.Background:SetTexture(nil)
					self:removeNineSlice(frame.NineSlice)
					self:skinObject("scrollbar", {obj=frame.ScrollBar, fType=ftype})

					self:Unhook(frame, "OnShow")
				end)
				self:checkShown(fObj.RecipeList)

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.BrowseOrders)

			self:SecureHookScript(this.MyOrdersPage, "OnShow", function(fObj)
				fObj.OrderList.Background:SetTexture(nil)
				skinHdrs(fObj)
				self:removeNineSlice(fObj.OrderList.NineSlice)
				self:skinObject("scrollbar", {obj=fObj.OrderList.ScrollBar, fType=ftype})
				if self.modBtnBs then
					self:addButtonBorder{obj=fObj.RefreshButton, fType=ftype, ofs=-2, x1=1, clr="gold", sechk=true}
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.MyOrdersPage)

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.ProfessionsCustomerOrdersFrame)
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
		if not self.isMnln then
			_G["RaidGroupButton" .. i]:SetNormalTexture("")
		else
			_G["RaidGroupButton" .. i]:GetNormalTexture():SetTexture(nil)
		end
		self:skinObject("button", {obj=_G["RaidGroupButton" .. i], fType=ftype, subt=true--[[, bd=7]], ofs=1})
	end
	-- Raid Class Tabs (side)
	for i = 1, _G.MAX_RAID_CLASS_BUTTONS do
		self:removeRegions(_G["RaidClassButton" .. i], {1}) -- 2 is icon, 3 is text
	end

	if not self.isMnln then
		if self.modBtns then
			self:skinStdButton{obj=_G.RaidFrameReadyCheckButton, fType=ftype}
		end
	end

end

aObj.blizzFrames[ftype].ReadyCheck = function(self)
	if not self.prdb.ReadyCheck or self.initialized.ReadyCheck then return end
	self.initialized.ReadyCheck = true

	self:SecureHookScript(_G.ReadyCheckFrame, "OnShow", function(this)
		if _G.InCombatLockdown() then
		    self:add2Table(self.oocTab, {self.checkShown, {self, this}})
		    return
		end

		self:skinObject("frame", {obj=_G.ReadyCheckListenerFrame, fType=ftype, kfs=true, x1=32})
		if self.modBtns then
			self:skinStdButton{obj=_G.ReadyCheckFrameYesButton}
			self:skinStdButton{obj=_G.ReadyCheckFrameNoButton}
		end

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.ReadyCheckFrame)

end

aObj.blizzFrames[ftype].RolePollPopup = function(self)
	if not self.prdb.RolePollPopup or self.initialized.RolePollPopup then return end
	self.initialized.RolePollPopup = true

	self:SecureHookScript(_G.RolePollPopup, "OnShow", function(this)
		if _G.InCombatLockdown() then
		    self:add2Table(self.oocTab, {self.checkShown, {self, this}})
		    return
		end

		self:removeNineSlice(this.Border)
		self:skinObject("frame", {obj=this, fType=ftype, cb=true, ofs=5})
		if self.modBtns then
			self:skinStdButton{obj=this.acceptButton, schk=true}
		end
		-- N.B. CAN'T skin the RoleButtons.checkButton as they use radio button textures

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.RolePollPopup)

end

aObj.blizzFrames[ftype].TradeFrame = function(self)
	if not self.prdb.TradeFrame or self.initialized.TradeFrame then return end
	self.initialized.TradeFrame = true

	self:SecureHookScript(_G.TradeFrame, "OnShow", function(this)
		if _G.InCombatLockdown() then
		    self:add2Table(self.oocTab, {self.checkShown, {self, this}})
		    return
		end

		if self.isMorF then
			this.RecipientOverlay.portrait:SetAlpha(0)
			this.RecipientOverlay.portraitFrame:SetTexture(nil)
		end
		self:removeInset(_G.TradeRecipientItemsInset)
		self:removeInset(_G.TradeRecipientEnchantInset)
		self:removeInset(_G.TradePlayerItemsInset)
		self:removeInset(_G.TradePlayerEnchantInset)
		self:removeInset(_G.TradePlayerInputMoneyInset)
		self:removeInset(_G.TradeRecipientMoneyInset)
		self:skinObject("moneyframe", {obj=_G.TradePlayerInputMoneyFrame, fType=ftype})
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
					self:addButtonBorder{obj=_G["Trade" .. type .. "Item" .. i .. "ItemButton"], fType=ftype, ibt=true}
				end
			end
		end

		self:Unhook(this, "OnShow")
	end)
	 self:checkShown(_G.TradeFrame)

end
