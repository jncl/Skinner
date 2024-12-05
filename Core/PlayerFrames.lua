local _, aObj = ...

local _G = _G

local ftype = "p"

if not aObj.isClscERA then
	aObj.blizzLoDFrames[ftype].AchievementUI = function(self)
		if not self.prdb.AchievementUI.skin or self.initialized.AchievementUI then return end
		self.initialized.AchievementUI = true

		local skinAchievementsObjectives, skinCategories, skinBtn, cleanButtons
		if aObj.isRtl then
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
			skinCategories = _G.nop
			-- skinBtn = _G.nop
			cleanButtons = _G.nop
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
				aObj:nilTexture(btn.icon.frame, true)
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
				if aObj.isRtl then
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
					aObj:nilTexture(btn.Icon.frame, true)
					if aObj.modBtnBs then
						aObj:addButtonBorder{obj=btn.Icon, fType=ftype, ofs=-3, y1=0, y2=6, clr={btn:GetBackdropBorderColor()}}
					end
				else
					bName = btn:GetName()
					if _G[bName .. "Description"] then
						_G[bName .. "Description"]:SetTextColor(.6, .6, .6, 1)
					end
				end
				if aObj.modChkBtns
				and btn.Tracked
				then
					aObj:skinCheckButton{obj=btn.Tracked, fType=ftype}
					btn.Tracked:SetSize(20, 20)
				end
				aObj:SecureHook(btn, "Desaturate", function(bObj)
					if bObj.sf then
						bObj.sf:SetBackdropBorderColor(bObj:GetBackdropBorderColor())
					end
					if aObj.isRtl then
						if bObj.Icon.sbb then
							bObj.Icon.sbb:SetBackdropBorderColor(bObj:GetBackdropBorderColor())
						end
					end
				end)
				aObj:SecureHook(btn, "Saturate", function(bObj)
					if bObj.sf then
						bObj.sf:SetBackdropBorderColor(bObj:GetBackdropBorderColor())
					end
					if aObj.isRtl then
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
			if self.isRtl then
				self:skinObject("editbox", {obj=this.SearchBox, fType=ftype, si=true, y1=-4, y2=4})
				self:moveObject{obj=this.SearchBox, y=-8}
				self:skinObject("statusbar", {obj=this.searchProgressBar, fi=0, bg=this.searchProgressBar.bg})
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, y1=7, x2=0, y2=-1})
			else
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, y1=9, x2=1, y2=-2})
			end
			if self.modBtnBs then
				self:moveObject{obj=_G.AchievementFrameFilterDropdown, y=-6}
				self:skinObject("ddbutton", {obj=_G.AchievementFrameFilterDropdown, fType=ftype, filter=true})
			end

			self:SecureHookScript(this.Header or _G.AchievementFrameHeader, "OnShow", function(fObj)
				self:keepFontStrings(fObj)
				if aObj.isRtl then
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

			self:SecureHookScript(this.Categories or _G.AchievementFrameCategories, "OnShow", function(fObj)
				if self.isRtl then
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
				if self.isRtl then
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
				if self.isRtl then
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
				for i = 1, self.isRtl and 12 or 8 do
					skinSB(catName .. "Category" .. i, true)
				end

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(_G.AchievementFrameSummary)

			self:SecureHookScript(_G.AchievementFrameComparison, "OnShow", function(fObj)
				fObj:DisableDrawLayer("BACKGROUND")
				fObj:DisableDrawLayer("ARTWORK")
				if self.isRtl then
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

			if self.isRtl then
				self:SecureHookScript(this.SearchPreviewContainer, "OnShow", function(fObj)
					self:adjHeight{obj=fObj, adj=((4 * 27) + 30)}
					for _, btn in _G.ipairs(fObj.searchPreviews) do
						self:removeRegions(btn, {5, 6})
						btn.IconFrame:SetTexture(nil)
						if self.modBtnBs then
							self:addButtonBorder{obj=btn, relTo=btn.Icon}
						end
					end
					fObj.ShowAllSearchResults:SetNormalTexture("")
					fObj.ShowAllSearchResults:SetPushedTexture("")
					self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, ofs=4, y2=2})
					_G.LowerFrameLevel(fObj.sf)

					self:Unhook(fObj, "OnShow")
				end)

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

					self:Unhook(fObj, "OnShow")
				end)
			end

			-- let AddOn skins know when when UI is skinned (used by AchieveIt skin)
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

	aObj.blizzFrames[ftype].CharacterFrames = function(self)
		if not self.prdb.CharacterFrames or self.initialized.CharacterFrames then return end
		self.initialized.CharacterFrames = true

		self:SecureHookScript(_G.CharacterFrame, "OnShow", function(this)
			self:removeInset(this.InsetRight)
			self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, rp=true, cb=true, x2=self.isClsc and 1 or 3})
			if self.isClsc then
				if self.modBtnBs then
					self:addButtonBorder{obj=_G.CharacterFrameExpandButton, fType=ftype, ofs=-2, x1=1, clr="gold"}
				end
			end

			self:Unhook(this, "OnShow")
		end)

		if self.isRtl then
			-- other adddons reparent this (e.g. DejaCharacterStats)
			self:SecureHookScript(_G.CharacterStatsPane, "OnShow", function(this)
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

		self:SecureHookScript(_G.PaperDollFrame, "OnShow", function(this)
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
					self:skinStdButton{obj=fObj.EquipSet}
					self:skinStdButton{obj=fObj.SaveSet, schk=true}
					self:SecureHook("PaperDollEquipmentManagerPane_Update", function()
						self:clrBtnBdr(fObj.EquipSet)
						self:clrBtnBdr(fObj.SaveSet)
					end)
				end

				self:Unhook(fObj, "OnShow")
			end)
			_G.CharacterModelScene:DisableDrawLayer("BACKGROUND")
			_G.CharacterModelScene:DisableDrawLayer("BORDER")
			_G.CharacterModelScene:DisableDrawLayer("OVERLAY")
			local function skinSlot(btn)
				btn:DisableDrawLayer("BACKGROUND")
				if aObj.modBtnBs then
					aObj:addButtonBorder{obj=btn, fType=ftype, ibt=true, reParent={btn.ignoreTexture}}
					-- force quality border update
					_G.PaperDollItemSlotButton_Update(btn)
					if self.isRtl then
						-- RankFrame
						aObj:changeTandC(btn.RankFrame.Texture)
						btn.RankFrame.Texture:SetSize(20, 20)
						btn.RankFrame.Label:ClearAllPoints()
						btn.RankFrame.Label:SetPoint("CENTER", btn.RankFrame.Texture)
						if btn.SocketDisplay then -- MoP Remix
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
			for i = 1, #_G.PaperDollItemsFrame.EquipmentSlots do
				skinSlot(_G.PaperDollItemsFrame.EquipmentSlots[i])
			end
			for i = 1, #_G.PaperDollItemsFrame.WeaponSlots do
				skinSlot(_G.PaperDollItemsFrame.WeaponSlots[i])
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.GearManagerPopupFrame, "OnShow", function(this)
			self:skinIconSelector(this, ftype)

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.ReputationFrame, "OnShow", function(this)
			self:keepFontStrings(this)
			if self.isRtl then
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
						if elementData.isHeader
						and not elementData.isChild
						then
							aObj:keepFontStrings(element)
							aObj:changeHdrExpandTex(element.Right)
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
					end
				end
				_G.ScrollUtil.AddAcquiredFrameCallback(this.ScrollBox, skinElement, aObj, true)
				self:SecureHookScript(this.ReputationDetailFrame, "OnShow", function(fObj)
					self:removeNineSlice(fObj.Border)
					self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, ofs=-3})
					if self.modBtns then
						self:skinCloseButton{obj=fObj.CloseButton}
						self:skinStdButton{obj=fObj.ViewRenownButton, fType=ftype, clr="gold", sechk=true}
						self:adjHeight{obj=fObj.ViewRenownButton, adj=4}
						-- .ToggleCollapseButton
					end
					if self.modChkBtns then
						self:skinCheckButton{obj=fObj.AtWarCheckbox}
						self:skinCheckButton{obj=fObj.MakeInactiveCheckbox, sechk=true}
						self:skinCheckButton{obj=fObj.WatchFactionCheckbox}
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
						self:skinCloseButton{obj=_G.ReputationDetailCloseButton}
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
		if self.isRtl then
			self:SecureHookScript(_G.TokenFrame, "OnShow", function(this)
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
						if elementData.isHeader then
							if elementData.currencyListDepth == 0 then
								aObj:keepFontStrings(element)
								aObj:changeHdrExpandTex(element.Right)
								if element.elementData then -- BUGFIX: #183
									element:RefreshCollapseIcon() -- force texture change
								end
							else
								if aObj.modBtns then
									aObj:skinExpandButton{obj=element.ToggleCollapseButton, fType=ftype, onSB=true}
								end
							end
						end
					end
				end
				_G.ScrollUtil.AddAcquiredFrameCallback(this.ScrollBox, skinCurrency, aObj, true)
				if self.modBtnBs then
					self:addButtonBorder{obj=this.CurrencyTransferLogToggleButton, fType=ftype}
				end

				self:SecureHookScript(_G.CurrencyTransferLog, "OnShow", function(fObj)
					self:skinObject("scrollbar", {obj=fObj.ScrollBar, fType=ftype})
					self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, cb=true})

					self:Unhook(fObj, "OnShow")
				end)

				self:SecureHookScript(_G.TokenFramePopup, "OnShow", function(fObj)
					fObj.Border:DisableDrawLayer("BACKGROUND")
					self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, cb=not self.isRtl and true, ofs=-3, x1=0})
					if self.modBtns then
						if self.isRtl then
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

				self:Unhook(_G.TokenFrame, "OnShow")
			end)
			self:checkShown(_G.TokenFrame)
		end

	end

	aObj.blizzLoDFrames[ftype].Collections = function(self)
		if not self.prdb.Collections or self.initialized.Collections then return end
		self.initialized.Collections = true

		self:SecureHookScript(_G.CollectionsJournal, "OnShow", function(this)
			self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true, selectedTab=this.selectedTab})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, rns=true, cb=true, x2=self.Rtl and 3 or 1, y2=-2})

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.MountJournal, "OnShow", function(this)
			self:removeInset(this.LeftInset)
			self:removeInset(this.RightInset)
			if self.isRtl then
				self:removeInset(this.BottomLeftInset)
				self:removeRegions(this.SlotButton, {1, 3})
			end
			self:skinObject("ddbutton", {obj=this.FilterDropdown, fType=ftype, filter=true})
			self:skinObject("editbox", {obj=this.searchBox, fType=ftype, si=true})
			self:removeInset(this.MountCount)
			self:keepFontStrings(this.MountDisplay)
			self:keepFontStrings(this.MountDisplay.ShadowOverlay)
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
					_G.C_Timer.After(0.05, function()
						element.sbb:SetBackdropBorderColor(element.icon:GetVertexColor())
					end)
				end
			end
			_G.ScrollUtil.AddAcquiredFrameCallback(this.ScrollBox, skinElement, aObj, true)
			self:removeMagicBtnTex(this.MountButton)
			if self.modBtns then
				if self.isRtl then
					self:skinStdButton{obj=this.BottomLeftInset.SuppressedMountEquipmentButton, fType=ftype}
				else
					self:skinStdButton{obj=_G.MountJournalFilterButton, fType=ftype}
				end
				self:skinStdButton{obj=this.MountButton, fType=ftype, sechk=true}
			end
			if self.modBtnBs then
				if self.isRtl then
					self:addButtonBorder{obj=this.SlotButton, fType=ftype, relTo=this.SlotButton.ItemIcon}
					self:addButtonBorder{obj=this.ToggleDynamicFlightFlyoutButton, fType=ftype, ofs=3}
					this.ToggleDynamicFlightFlyoutButton:SetFrameLevel(10)
					self:addButtonBorder{obj=this.SummonRandomFavoriteButton, fType=ftype, ofs=3}
				else
					self:addButtonBorder{obj=this.MountDisplay.ModelScene.RotateLeftButton, ofs=-3}
					self:addButtonBorder{obj=this.MountDisplay.ModelScene.RotateRightButton, ofs=-3}
				end
				self:addButtonBorder{obj=this.MountDisplay.InfoButton, relTo=this.MountDisplay.InfoButton.Icon, clr="white"}
			end
			if self.modChkBtns
			and self.isRtl
			then
				self:skinCheckButton{obj=this.MountDisplay.ModelScene.TogglePlayer}
			end

			if self.isRtl then
				self:SecureHookScript(this.DynamicFlightFlyout, "OnShow", function(fObj)
					self:skinObject("frame", {obj=fObj.Background, fType=ftype, kfs=true, ofs=0, y1=4})
					if self.modBtnBs then
						self:addButtonBorder{obj=fObj.OpenDynamicFlightSkillTreeButton, fType=ftype}
						self:moveObject{obj=fObj.OpenDynamicFlightSkillTreeButton, x=1.5}
						self:addButtonBorder{obj=fObj.DynamicFlightModeButton, fType=ftype}
						self:moveObject{obj=fObj.DynamicFlightModeButton, x=1.5}
					end

					self:Unhook(fObj, "OnShow")
				end)
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.PetJournal, "OnShow", function(this)
			self:removeInset(this.PetCount)
			self:removeInset(this.LeftInset)
			self:removeInset(this.RightInset)
			if self.isRtl then
				self:skinMainHelpBtn(this)
				_G.PetJournalHealPetButtonBorder:SetTexture(nil)
				self:removeInset(this.PetCardInset)
			else
				self:removeMagicBtnTex(this.SummonButton)
			end
			self:skinObject("ddbutton", {obj=this.FilterDropdown, fType=ftype, filter=true})
			self:skinObject("editbox", {obj=this.searchBox, fType=ftype, si=true})
			if self.modBtns then
				if not self.isRtl then
					self:skinStdButton{obj=_G.PetJournalFilterButton, fType=ftype}
					self:skinStdButton{obj=this.SummonButton}
				end
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
					if aObj.isRtl then
						aObj:changeTandC(element.dragButton.levelBG)
					end
					if aObj.modBtnBs then
						if aObj.isRtl then
							aObj:addButtonBorder{obj=element, relTo=element.icon, reParent={element.dragButton.levelBG, element.dragButton.level, element.dragButton.favorite}}
						else
							aObj:addButtonBorder{obj=element, relTo=element.icon}
						end
					end
				end
				if aObj.modBtnBs then
					_G.C_Timer.After(0.05, function()
						aObj:clrButtonFromBorder(element)
					end)
				end
			end
			_G.ScrollUtil.AddAcquiredFrameCallback(this.ScrollBox, skinElement, aObj, true)
			if self.isRtl then
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
				if self.modBtnBs then
					self:addButtonBorder{obj=pc.PetInfo, relTo=pc.PetInfo.icon, reParent={pc.PetInfo.levelBG, pc.PetInfo.level, pc.PetInfo.favorite}}
				end
				self:skinObject("statusbar", {obj=pc.HealthFrame.healthBar, regions={1, 2, 3}, fi=0})
				self:skinObject("statusbar", {obj=pc.xpBar, regions={2, 3, 4, 5, 6, 7, 8, 9, 10, 11}, fi=0})
				self:keepFontStrings(pc)
				self:skinObject("frame", {obj=pc, fType=ftype, fb=true, ofs=4})
				for i = 1, 6 do
					pc["spell" .. i].BlackCover:SetAlpha(0) -- N.B. texture is changed in code
					if self.modBtnBs then
						self:addButtonBorder{obj=pc["spell" .. i], relTo=pc["spell" .. i].icon}
					end
				end
				if self.modBtnBs then
					self:SecureHook("PetJournal_UpdatePetLoadOut", function()
						for i = 1, 3 do
							self:clrButtonFromBorder(_G.PetJournal.Loadout["Pet" .. i], "qualityBorder")
						end
					end)
					self:SecureHook("PetJournal_UpdatePetCard", function(fObj)
						self:clrButtonFromBorder(fObj.PetInfo, "qualityBorder")
					end)
				end
				self:removeMagicBtnTex(this.FindBattleButton)
				self:removeMagicBtnTex(this.SummonButton)
				self:removeRegions(this.AchievementStatus, {1, 2})
				if self.modBtns then
					self:skinStdButton{obj=this.FindBattleButton}
					self:skinStdButton{obj=this.SummonButton, sechk=true}
				end
				if self.modBtnBs then
					self:addButtonBorder{obj=this.HealPetButton, fType=ftype, sft=true, ca=1}
					self:addButtonBorder{obj=this.SummonRandomFavoritePetButton, fType=ftype, ofs=3, ca=1}
				end
			else
				this.PetCard.PetBackground:SetAlpha(0)
				this.PetCard.ShadowOverlay:SetAlpha(0)
				if self.modBtnBs then
					self:addButtonBorder{obj=this.PetCard.PetInfo, relTo=this.PetCard.PetInfo.icon, reParent={this.PetCard.PetInfo.favorite}}
					self:addButtonBorder{obj=this.PetCard.modelScene.RotateLeftButton, ofs=-3}
					self:addButtonBorder{obj=this.PetCard.modelScene.RotateRightButton, ofs=-3}
				end
			end

			self:Unhook(this, "OnShow")
		end)

		if self.isRtl then
			local function skinTTip(tip)
				tip.Delimiter1:SetTexture(nil)
				tip.Delimiter2:SetTexture(nil)
				tip:DisableDrawLayer("BACKGROUND")
				aObj:skinObject("frame", {obj=tip, fType=ftype, ofs=0})
			end
			skinTTip(_G.PetJournalPrimaryAbilityTooltip)
			skinTTip(_G.PetJournalSecondaryAbilityTooltip)
		end

		local skinPageBtns, skinCollectionBtn
		if self.modBtnBs then
			function skinPageBtns(frame)
				aObj:addButtonBorder{obj=frame.PagingFrame.PrevPageButton, ofs=-2, y1=-3, x2=-3}
				aObj:addButtonBorder{obj=frame.PagingFrame.NextPageButton, ofs=-2, y1=-3, x2=-3}
				aObj:clrPNBtns(frame.PagingFrame, true)
				aObj:SecureHook(frame.PagingFrame, "Update", function(this)
					aObj:clrPNBtns(this, true)
				end)
			end
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
				self:skinStdButton{obj=_G.ToyBoxFilterButton, ftype=ftype}
			end
			if self.modBtnBs then
				skinPageBtns(this)
				self:SecureHook("ToySpellButton_UpdateButton", function(fObj)
					skinCollectionBtn(fObj)
				end)
			end

			self:Unhook(this, "OnShow")
		end)

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
				if not self.isRtl then
					self:skinStdButton{obj=this.FilterButton, ftype=ftype}
				end
			end
			if self.modBtnBs then
				skinPageBtns(this)
				if self.isRtl then
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

		if not self.isClscERA then
			self:SecureHookScript(_G.WardrobeCollectionFrame, "OnShow", function(this)
				if self.isRtl then
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
					if not self.isRtl then
						self:skinStdButton{obj=this.FilterButton, ftype=ftype}
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
							skinPageBtns(fObj)
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

					if self.isRtl then
						local SetsDataProvider = _G.CreateFromMixins(_G.WardrobeSetsDataProviderMixin)
						self:SecureHookScript(this.SetsCollectionFrame, "OnShow", function(fObj)
							self:removeInset(fObj.LeftInset)
							self:keepFontStrings(fObj.RightInset)
							self:removeNineSlice(fObj.RightInset.NineSlice)
							self:skinObject("scrollbar", {obj=fObj.ListContainer.ScrollBar, fType=ftype})
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
								local displayData = elementData
								if elementData.hiddenUntilCollected
								and not elementData.collected
								then
									local variantSets = _G.C_TransmogSets.GetVariantSets(elementData.setID)
									if variantSets then
										displayData = variantSets[1]
									end
								end
								local topSourcesCollected, topSourcesTotal = SetsDataProvider:GetSetSourceTopCounts(displayData.setID)
								local setCollected = displayData.collected or topSourcesCollected == topSourcesTotal
								if element.IconFrame.sbb then
									if setCollected then
										aObj:clrBtnBdr(element.IconFrame, "gold")
									else
										aObj:clrBtnBdr(element.IconFrame, topSourcesCollected == 0 and "grey")
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
						self:SecureHookScript(this.SetsTransmogFrame, "OnShow", function(fObj)
							self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, rns=true, fb=true, x1=x1Ofs, y1=y1Ofs, x2=x2Ofs, y2=y2Ofs})
							if self.modBtnBs then
								skinPageBtns(fObj)
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

			self:SecureHookScript(_G.WardrobeFrame, "OnShow", function(this)
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, rns=true, cb=true, x2=3, y2=-1})

				self:Unhook(this, "OnShow")
			end)

			-- used by Transmog as well as Appearance
			self:SecureHookScript(_G.WardrobeTransmogFrame, "OnShow", function(this)
				this:DisableDrawLayer("ARTWORK")
				self:removeInset(this.Inset)
				self:skinObject("ddbutton", {obj=this.OutfitDropdown, fType=ftype})
				if self.isRtl then
					this.ModelScene.ControlFrame:DisableDrawLayer("BACKGROUND")
				end
				for _, btn in _G.pairs(this.SlotButtons) do
					btn.Border:SetTexture(nil)
					if self.modBtnBs then
						 self:addButtonBorder{obj=btn, fType=ftype, ofs=-2}
					end
				end
				self:skinObject("ddbutton", {obj=this.SpecDropdown, fType=ftype, noSF=true, ofs=1, y1=1, y2=0})
				if self.modBtns then
					self:skinStdButton{obj=this.OutfitDropdown.SaveButton, sechk=true}
					self:skinStdButton{obj=this.ApplyButton, fType=ftype, ofs=0, sechk=true}
				end
				if self.modBtnBs then
					if self.isRtl then
						self:addButtonBorder{obj=this.ModelScene.ClearAllPendingButton, fType=ftype, relTo=this.ModelScene.ClearAllPendingButton.Icon, ofs=5}
					end
				end
				if self.modChkBtns then
					self:skinCheckButton{obj=this.ToggleSecondaryAppearanceCheckbox, fType=ftype}
				end

				self:Unhook(this, "OnShow")
			end)

		end

		if self.isClsc
		and _G.C_AddOns.IsAddOnLoaded("MountsJournal")
		then
			self.callbacks:Fire("Collections_Skinned")
		end

	end
end

aObj.blizzLoDFrames[ftype].Communities = function(self)
	if not self.prdb.Communities or self.initialized.Communities then return end

	--> N.B.these frames can't be skinned, as the XML has a ScopedModifier element saying forbidden="true"
		-- CommunitiesAddDialog
		-- CommunitiesCreateDialog

	if not _G.CommunitiesFrame then
		_G.C_Timer.After(0.1, function()
			self.blizzLoDFrames[ftype].Communities(self)
		end)
		return
	end

	self.initialized.Communities = true

	self:SecureHookScript(_G.CommunitiesFrame, "OnShow", function(this)
		self:keepFontStrings(this.PortraitOverlay)
		local tabs = {"ChatTab", "RosterTab", "GuildBenefitsTab", "GuildInfoTab"}
		for _, tabName in _G.pairs(tabs) do
			this[tabName]:DisableDrawLayer("BORDER")
			if self.modBtnBs then
				self:addButtonBorder{obj=this[tabName]}
			end
		end
		self:moveObject{obj=this.ChatTab, x=1}
		self:skinObject("ddbutton", {obj=this.StreamDropdown, fType=ftype})
		self:skinObject("ddbutton", {obj=this.CommunitiesListDropdown, fType=ftype})
		self:skinObject("editbox", {obj=this.ChatEditBox, fType=ftype, y1=-6, y2=6})
		self:moveObject{obj=this.AddToChatButton, x=-6, y=-6}
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true, x1=-5})
		if self.modBtns then
			self:skinStdButton{obj=this.InviteButton, fType=ftype, sechk=true}
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=this.AddToChatButton, ofs=1, clr="gold"}
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
			self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, ofs=-6, x2=self.isRtl and -4 or 2})
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

		self:skinObject("ddbutton", {obj=this.GuildMemberListDropdown, fType=ftype})
		self:skinObject("ddbutton", {obj=this.CommunityMemberListDropdown, fType=ftype})
		if self.modBtns then
			self:skinStdButton{obj=this.GuildLogButton, fType=ftype}
		end

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
					aObj:addButtonBorder{obj=element, fType=ftype, relTo=element.Icon}
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

	self:SecureHookScript(_G.CommunitiesAvatarPickerDialog, "OnShow", function(this)
		if not aObj.isClscERA then
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
		else
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
		end
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ofs=-4})

		self:Unhook(this, "OnShow")
	end)

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

	self:SecureHookScript(_G.CommunitiesGuildLogFrame, "OnShow", function(this)
		self:skinObject("scrollbar", {obj=this.Container.ScrollFrame.ScrollBar, fType=ftype})
		self:skinObject("frame", {obj=this.Container, fType=ftype, kfs=true, fb=true})
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, ofs=-5})
		if self.modBtns then
			 self:skinStdButton{obj=self:getChild(this, 3)} -- bottom close button
		end

		self:Unhook(this, "OnShow")
	end)

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

end

aObj.blizzFrames[ftype].CompactFrames = function(self)
	if not self.prdb.CompactFrames or self.initialized.CompactFrames then return end
	self.initialized.CompactFrames = true

	if _G.C_AddOns.IsAddOnLoaded("Tukui")
	or _G.C_AddOns.IsAddOnLoaded("ElvUI")
	then
		self.blizzFrames[ftype].CompactFrames = nil
		return
	end

	-- handle AddOn being disabled
	if not self:checkLoadable("Blizzard_CompactRaidFrames") then
		return
	end

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
		self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ofs=0, y2=-40})

		self:SecureHookScript(this.displayFrame, "OnShow", function(fObj)
			self:keepFontStrings(fObj)
			fObj.filterOptions:DisableDrawLayer("BACKGROUND")
			if self.isRtl then
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
				if self.isRtl then
					for _, type in _G.pairs{"Tank", "Healer", "Damager"} do
						self:skinStdButton{obj=fObj.filterOptions["filterRole" .. type]}
					end
					self:skinStdButton{obj=_G.parentBottomButtonsLeavePartyButton, fType=ftype}
					self:skinStdButton{obj=_G.parentBottomButtonsLeaveInstanceGroupButton, fType=ftype}
				else
					self:skinStdButton{obj=fObj.hiddenModeToggle, fType=ftype}
					self:skinStdButton{obj=fObj.convertToRaid, fType=ftype}
					self:skinStdButton{obj=fObj.leaderOptions.readyCheckButton, fType=ftype}
					if not self.isClscERA then
						self:skinStdButton{obj=fObj.leaderOptions.rolePollButton, fType=ftype}
					end
					self:SecureHook("CompactRaidFrameManager_UpdateOptionsFlowContainer", function()
						local frame = _G.CompactRaidFrameManager
						-- handle button skin frames not being created yet
						if frame.displayFrame.leaderOptions.readyCheckButton.sb then
							self:clrBtnBdr(frame.displayFrame.leaderOptions.readyCheckButton)
							if not self.isClscERA then
								self:clrBtnBdr(frame.displayFrame.leaderOptions.rolePollButton)
							end
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

	-- Don't skin Group & Unit frames as it causes errors
	if self.isRtl then
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

if not aObj.isClscERA then
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
			this.navBar:DisableDrawLayer("BACKGROUND")
			this.navBar:DisableDrawLayer("BORDER")
			this.navBar.overlay:DisableDrawLayer("OVERLAY")
			self:skinNavBarButton(this.navBar.home)
			this.navBar.home.text:SetPoint("RIGHT", -20, 0)
			self:skinObject("editbox", {obj=this.searchBox, fType=ftype, si=true})
			self:skinObject("ddbutton", {obj=this.LootJournalViewDropdown, fType=ftype})
			self:skinObject("tabs", {obj=this, tabs=this.Tabs, selectedTab=this.selectedTab, fType=ftype, lod=self.isTT and true, offsets={x1=-1, y1=2, x2=1, y2=1}, regions=self.isRtl and {7, 8, 9, 10, 11} or {10, 21}, track=false, func=function(tab) tab:SetFrameLevel(20) end})
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
					self:moveObject{obj=frame.overviewTab, x=7}

					self:Unhook(frame, "OnShow")
				end)
				self:checkShown(fObj.info)

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(this.encounter)

			if self.isRtl then
				-- a.k.a. Traveler's Log
				local function changeHCI(bObj)
					if bObj:GetElementData():IsCollapsed() then
						bObj.HeaderCollapseIndicator:SetAtlas("ui-hud-minimap-zoom-in")
					else
						bObj.HeaderCollapseIndicator:SetAtlas("ui-hud-minimap-zoom-out")
					end
				end
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
							self:addButtonBorder{obj=frame.RewardItem, fType=ftype, relTo=frame.RewardItem.Icon, reParent={frame.RewardCurrency}, ibt=true}
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
					if not self.isRtl then
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
					self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, fb=true, x1=-8, y1=6, x2=8, y2=-5})

					self:Unhook(fObj, "OnShow")
				end)
				self:checkShown(this.LootJournal)

				self:SecureHookScript(this.LootJournalItems, "OnShow", function(fObj)
					fObj:DisableDrawLayer("BACKGROUND")
					if self.isRtl then
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
					self:skinObject("frame", {obj=fObj, fType=ftype, kfs=true, fb=true, x1=-8, y1=6, x2=8, y2=-5})

					self:Unhook(fObj, "OnShow")
				end)
			end
			-- let AddOn skins know when when UI is skinned (used by Atlas skin)
			self.callbacks:Fire("EncounterJournal_Skinned", self)
			-- remove all callbacks for this event
			self.callbacks.events["EncounterJournal_Skinned"] = nil

			self:Unhook(this, "OnShow")
		end)

		-- this is a frame NOT a GameTooltip
		self:SecureHookScript(_G.EncounterJournalTooltip, "OnShow", function(this)
			self:skinObject("frame", {obj=this, fType=ftype})
			-- TODO: .Item1.tooltip

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].EquipmentFlyout = function(self)
		if not self.prdb.EquipmentFlyout or self.initialized.EquipmentFlyout then return end
		self.initialized.EquipmentFlyout = true

		-- Used by RuneForgeUI/ItemUpgrades/EquipmentFlyoutuipmentManager
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
			self:skinObject("frame", {obj=this.buttonFrame, fType=ftype, ofs=5, x2=7, clr="gold"})
			self:skinObject("frame", {obj=this.NavigationFrame, fType=ftype, kfs=true, x1=0, y2=1, clr="gold"})
			if self.modBtnBs then
				self:addButtonBorder{obj=this.NavigationFrame.PrevButton, fType=ftype, ofs=-2, x1=1, clr="gold", schk=true}
				self:addButtonBorder{obj=this.NavigationFrame.NextButton, fType=ftype, ofs=-2, x1=1, clr="gold", schk=true}
			end

			self:Unhook(this, "OnShow")
		end)

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
	if self.isRtl then
		gemTypeInfo["Hydraulic"]       = {textureKit = "hydraulic", r = 1, g = 1, b = 1}
		gemTypeInfo["Cogwheel"]        = {textureKit = "cogwheel", r = 1, g = 1, b = 1}
		gemTypeInfo["PunchcardRed"]    = {textureKit = "punchcard-red", r = 1, g = 0.47, b = 0.47}
		gemTypeInfo["PunchcardYellow"] = {textureKit = "punchcard-yellow", r = 0.97, g = 0.82, b = 0.29}
		gemTypeInfo["PunchcardBlue"]   = {textureKit = "punchcard-blue", r = 0.47, g = 0.67, b = 1}
		gemTypeInfo["Domination"]      = {textureKit = "domination", r = 1, g = 1, b = 1}
		-- gemTypeInfo["Cypher"]          = {textureKit = "meta", r = 1, g = 1, b = 1}
		gemTypeInfo["Tinker"]          = {textureKit = "punchcard-red", r = 1, g = 0.47, b = 0.47}
		-- gemTypeInfo["Primordial"]      = {textureKit = "meta", r = 1, g = 1, b = 1}
		gemTypeInfo["Fragrance"]       = {textureKit = "hydraulic", r = 1, g = 1, b = 1}
	end
	-- setup default for missing entry
	_G.setmetatable(gemTypeInfo, {__index = function(t, k)
		--@debug@
		_G.assert(false, "Missing GEM_TYPE_INFO entry for ", k)
		--@end-debug@
		return t["Meta"]
	end})

	self:SecureHookScript(_G.ItemSocketingFrame, "OnShow", function(this)
		if self.isRtl then
			self:skinObject("scrollbar", {obj=_G.ItemSocketingScrollFrame.ScrollBar, fType=ftype})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ri=true, rns=true, cb=true, x2=3})
		else
			self:skinObject("slider", {obj=_G.ItemSocketingScrollFrame.ScrollBar, fType=ftype, rpTex="artwork"})
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

aObj.blizzFrames[ftype].MirrorTimers = function(self)
	if not self.prdb.MirrorTimers.skin or self.initialized.MirrorTimers then return end
	self.initialized.MirrorTimers = true

	local objName, obj, objBG, objSB
	if not self.isRtl then
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
				self:nilTexture(timer.TextBorder, true)
				self:nilTexture(timer.Border, true)
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
		if not self.isRtl then
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

aObj.blizzFrames[ftype].RolePollPopup = function(self)
	if not self.prdb.RolePollPopup or self.initialized.RolePollPopup then return end
	self.initialized.RolePollPopup = true

	self:SecureHookScript(_G.RolePollPopup, "OnShow", function(this)
		self:removeNineSlice(this.Border)
		self:skinObject("frame", {obj=this, fType=ftype, cb=true, ofs=5})
		if self.modBtns then
			self:skinStdButton{obj=this.acceptButton, schk=true}
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
		self:skinObject("moneyframe", {obj=_G.TradePlayerInputMoneyFrame, moveIcon=true})
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

end
