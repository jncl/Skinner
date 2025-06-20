local _, aObj = ...
if not aObj:isAddonEnabled("Krowi_AchievementFilter") then return end
local _G = _G

aObj.addonsToSkin.Krowi_AchievementFilter = function(self) -- v 84.0

	local function skinAlertFrame(frame)
		frame.animIn:Stop()
		frame.waitAndAnimOut:Stop()
		frame.Background:SetTexture(nil)
		frame:DisableDrawLayer("OVERLAY")
		aObj:skinObject("frame", {obj=frame, ofs=-6, y2=8})
		frame.Unlocked:SetTextColor(aObj.BT:GetRGB())
		if aObj.modBtnBs then
			frame.Icon:DisableDrawLayer("OVERLAY")
			aObj:addButtonBorder{obj=frame.Icon, relTo=frame.Icon.Texture}
		end
	end
	if self.prdb.AlertFrames then
		_G.C_Timer.NewTicker(0.1, function(ticker)
			for _, afs in _G.ipairs_reverse(_G.AlertFrame.alertFrameSubSystems) do
				if afs.alertFramePool then
					if _G.strfind(afs.alertFramePool:GetTemplate(), "KrowiAF_EventReminderAlertFrame_") then
						self:secureHook(afs, "setUpFunction", function(frame, _)
							skinAlertFrame(frame)
						end)
						ticker:Cancel()
						break
					end
				end
			end
		end, 20)
	end

	local function skinK_AF()
		local delay, sTmr
		local function skinSideBtns()
		    local i = 1
		    while _G["KrowiAF_AchievementFrameSideButton" .. i] do
		        skinAlertFrame(_G["KrowiAF_AchievementFrameSideButton" .. i])
		        i = i + 1
		    end
			if not sTmr then
				delay = 0.5
			-- elseif sTmr:IsCancelled() then
			-- 	delay = 1
			else
				delay = 30
			end
			sTmr = _G.C_Timer.NewTimer(delay, function() skinSideBtns() end)
		end
		-- skin any AchievementFrameSideButtons if they exist
		skinSideBtns()
	    _G.hooksecurefunc(_G.AchievementFrame, "Show", function(_)
			skinSideBtns()
		end)
	    _G.hooksecurefunc(_G.AchievementFrame, "Hide", function(_)
			sTmr:Cancel()
		end)

		local function skinAchievement(btn)
			btn:DisableDrawLayer("BACKGROUND")
			btn:DisableDrawLayer("BORDER")
			btn:DisableDrawLayer("ARTWORK")
			if btn.Description then
				btn.Description:SetTextColor(aObj.BT:GetRGB())
				aObj:rawHook(btn.Description, "SetTextColor", function(tObj, _)
					aObj.hooks[tObj].SetTextColor(tObj, aObj.BT:GetRGB())
				end, true)
			end
			if btn.hiddenDescription then
				btn.HiddenDescription:SetTextColor(aObj.BT:GetRGB())
				aObj:rawHook(btn.hiddenDescription, "SetTextColor", function(tObj, _)
					aObj.hooks[tObj].SetTextColor(tObj, aObj.BT:GetRGB())
				end, true)
			end
			-- Summary Achievement
			if btn.Icon.Border then
				btn.Icon.Border:SetTexture(nil)
			end
			-- MiniAchievement/MetaCriteria
			if btn.Border then
				aObj:nilTexture(btn.Icon.Border, true)
			end
			if btn.Glow then
				btn.Glow:SetTexture(nil)
			end
			aObj:secureHook(btn, "SetBackdropBorderColor", function(bObj, _)
				if bObj.sbb then
					bObj.sbb:SetBackdropBorderColor(bObj:GetBackdropBorderColor())
					bObj.Icon.sbb:SetBackdropBorderColor(bObj:GetBackdropBorderColor())
				end
			end)
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=btn.Icon, relTo=btn.Texture, ofs=-3, y1=0, y2=6, clr=btn:GetBackdropBorderColor()}
				aObj:addButtonBorder{obj=btn, ofs=0, clr=btn:GetBackdropBorderColor()}
			end
			if aObj.modChkBtns
			and btn.Tracked
			then
				btn.Tracked:SetSize(20, 20)
				aObj:skinCheckButton{obj=btn.Tracked}
			end
		end
		-- hook these to skin the Achievement objectives
		for _, method in _G.pairs{"GetTextCriteria", "GetMeta", "GetProgressBar"} do
			self:RawHook(_G.KrowiAF_AchievementsObjectives, method, function(this, index)
				local frame = self.hooks[this][method](this, index)
				if method ~= "GetProgressBar" then
					aObj:rawHook(frame.Label, "SetTextColor", function(fObj, r, g, b, _)
						local label = aObj.hooks[fObj].SetTextColor(fObj, r, g, b, _)
						if r == 0
						and g == 0
						and b == 0
						then
							aObj.hooks[fObj].SetTextColor(fObj, _G.HIGHLIGHT_FONT_COLOR:GetRGBA())
						end
						return label
					end, true)
				else
					if not aObj.sbGlazed[frame] then
						aObj:skinObject("statusbar", {obj=frame, regions={1, 3, 4, 5}, fi=0})
					end
				end
				return frame
			end, true)
		end

		if _G.AchievementFrame.Header.Title then
			self:moveObject{obj=_G.AchievementFrame.Header.Title, x=-20}
		else
			self:moveObject{obj=_G.AchievementFrameHeaderTitle, x=-20}
		end
		self:moveObject{obj=_G.KrowiAF_AchievementFrameFilterButton, x=0, y=-5}
		_G.KrowiAF_AchievementFrameCalendarButton:GetNormalTexture():SetAtlas("ui-hud-calendar-1-up")
		_G.KrowiAF_AchievementFrameCalendarButton:GetNormalTexture():SetTexCoord(0, 1, 0, 1)
		_G.KrowiAF_AchievementFrameCalendarButton:GetPushedTexture():SetAtlas("ui-hud-calendar-1-down")
		_G.KrowiAF_AchievementFrameCalendarButton:GetPushedTexture():SetTexCoord(0, 1, 0, 1)
		_G.KrowiAF_AchievementFrameCalendarButton:GetHighlightTexture():SetAtlas("ui-hud-calendar-1-mouseover")
		_G.KrowiAF_AchievementFrameCalendarButton:SetSize(19, 18)
		self:moveObject{obj=_G.KrowiAF_AchievementFrameCalendarButton, x=7, y=-5}
		if self.modBtns then
			self:skinStdButton{obj=_G.KrowiAF_AchievementFrameFilterButton, ofs=0, y2=-2, clr="grey"}
			self:skinStdButton{obj=_G.KrowiAF_SearchOptionsMenuButton, ofs=0, x1=-1, clr="grey"}
		end
		self:moveObject{obj=_G.KrowiAF_AchievementFrameCalendarButton, x=10, y=0}
		self:moveObject{obj=_G.KrowiAF_AchievementFrameBrowsingHistoryNextAchievementButton, x=0, y=20}
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.KrowiAF_AchievementFrameBrowsingHistoryPrevAchievementButton,  clr="grey", ofs=-2, x1=1}
			self:addButtonBorder{obj=_G.KrowiAF_AchievementFrameBrowsingHistoryNextAchievementButton,  clr="grey", ofs=-2, x1=1}
		end
		self:skinObject("editbox", {obj=_G.KrowiAF_SearchBoxFrame, si=true, y1=-4, y2=4})

		-- TODO: handle search options menu button

		self:SecureHookScript(_G.KrowiAF_SearchPreviewContainer, "OnShow", function(this)
			for _, btn in _G.pairs(this.Buttons) do
				btn:GetNormalTexture():SetTexture(nil)
				btn:GetPushedTexture():SetTexture(nil)
			end
			self:skinObject("frame", {obj=this, kfs=true, x1=-5, x2=5})
			-- the frame has only a default height
			self:adjHeight{obj=this, adj=27 * #this.Buttons}

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.KrowiAF_SearchResultsFrame, "OnShow", function(this)
			self:skinObject("slider", {obj=this.Container.ScrollBar, rpTex="background"})
			for _, btn in _G.pairs(this.Container.buttons) do
				btn:GetNormalTexture():SetTexture(nil)
				btn:GetPushedTexture():SetTexture(nil)
				if self.modBtnBs then
					self:addButtonBorder{obj=btn, relTo=btn.icon, clr="grey", ofs=3, y1=4}
				end
			end
			self:skinObject("frame", {obj=this, kfs=true, cb=true, x2=3, y2=1})

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.KrowiAF_AchievementCalendarFrame, "OnShow", function(this)
			self:moveObject{obj=this.CloseButton, x=-7, y=13}
			for _, dayBtn in _G.pairs(this.DayButtons) do
				dayBtn:GetNormalTexture():SetTexture(nil)
				if self.modBtnBs then
					for _, btn in _G.pairs(dayBtn.AchievementButtons) do
						self:addButtonBorder{obj=btn, clr="grey"}
					end
				end
			end
			self:skinObject("frame", {obj=this, kfs=true, cb=true, x1=7, y1=-3, x2=-5, y2=-1})
			if self.modBtnBs then
				self:addButtonBorder{obj=this.PrevMonthButton, ofs=-1, y1=-2, x2=-2, clr="gold", schk=true}
				self:addButtonBorder{obj=this.NextMonthButton, ofs=-1, y1=-2, x2=-2, clr="gold", schk=true}
			end

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.KrowiAF_AchievementCalendarFrameSideFrame, "OnShow", function(this)
			self:removeNineSlice(this.Border)
			self:skinObject("scrollbar", {obj=this.AchievementsFrame.ScrollBar})
			local function skinCSF(...)
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
			_G.ScrollUtil.AddAcquiredFrameCallback(this.AchievementsFrame.ScrollBox, skinCSF, aObj, true)
			self:skinObject("frame", {obj=this, kfs=true, hdr=true, cb=true, ofs=0})

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.KrowiAF_DataManagerFrame, "OnShow", function(this)
			this.CharacterList.ColumnDisplay:DisableDrawLayer("BACKGROUND")
			this.CharacterList.ColumnDisplay:DisableDrawLayer("BORDER")
			this.CharacterList.ColumnDisplay:DisableDrawLayer("ARTWORK")
			self:skinColumnDisplay(this.CharacterList.ColumnDisplay)
			self:skinObject("scrollbar", {obj=this.CharacterList.ScrollBar})
			local function skinCL(...)
				local _, element
				if _G.select("#", ...) == 2 then
					element, _ = ...
				else
					_, element, _ = ...
				end
				element:GetNormalTexture():SetTexture(nil)
				if aObj.modChkBtns then
					aObj:skinCheckButton{obj=element.HeaderTooltip}
					aObj:skinCheckButton{obj=element.EarnedByAchievementTooltip}
					aObj:skinCheckButton{obj=element.MostProgressAchievementTooltip}
					aObj:skinCheckButton{obj=element.IgnoreCharacter}
				end
			end
			_G.ScrollUtil.AddInitializedFrameCallback(this.CharacterList.ScrollBox, skinCL, aObj, true)
			self:skinObject("frame", {obj=this, kfs=true, cb=true, x1=1, x2=3})
			if self.modBtns then
				self:skinStdButton{obj=this.Import}
			end

			self:Unhook(this, "OnShow")
		end)

		local function skinTextFrame()
			local frame = _G.KrowiAF_TextFrame
			aObj:skinObject("frame", {obj=frame, cb=true})
			if aObj.modBtns then
				aObj:skinStdButton{obj=frame.Button1}
			end
		end
		self:SecureHookScript(_G.KrowiAF_DataManagerFrame.Import, "OnClick", function(this)
			skinTextFrame()
			self:Unhook(this, "OnClick")
		end)
		self:SecureHook(_G.KrowiAF_CharacterListEntryExportCharacterMixin, "OnClick", function(this)
			skinTextFrame()
			self:Unhook(this, "OnClick")
		end)

		self:SecureHookScript(_G.KrowiAF_AchievementsFrame, "OnShow", function(this)
			self:removeNineSlice(this.Border.NineSlice)
			self:skinObject("scrollbar", {obj=this.ScrollBar})
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
			_G.ScrollUtil.AddAcquiredFrameCallback(this.ScrollBox, skinElement, aObj, true)
			self:skinObject("frame", {obj=this, kfs=true, y1=0, y2=0})

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.KrowiAF_CategoriesFrame, "OnShow", function(this)
			self:removeNineSlice(this.Border.NineSlice)
			self:skinObject("scrollbar", {obj=this.ScrollBar})
			local function skinElement(...)
				local _, element
				if _G.select("#", ...) == 2 then
					element, _ = ...
				elseif _G.select("#", ...) == 3 then
					_, element, _ = ...
				end
				element:DisableDrawLayer("BACKGROUND")
			end
			_G.ScrollUtil.AddInitializedFrameCallback(this.ScrollBox, skinElement, aObj, true)
			self:skinObject("frame", {obj=this, kfs=true, y1=0, y2=0})

			self:Unhook(this, "OnShow")
		end)

		local function skinStatusBar(sBar)
			aObj:removeRegions(sBar, {1, 2, 3, 4, 5, 6, 7, 8, 9})
			for _, ftex in _G.pairs(sBar.Fill) do
				ftex:SetTexture(aObj.sbTexture)
			end
			sBar.Background:SetTexture(aObj.sbTexture)
			sBar.Background:SetVertexColor(aObj.sbClr:GetRGBA())
		end
		self:SecureHookScript(_G.KrowiAF_SummaryFrame, "OnShow", function(this)
			self:removeNineSlice(self:getChild(this, 1).NineSlice)
			this.Achievements.Header.Texture:SetTexture(nil)
			this.Categories.Header.Texture:SetTexture(nil)
			self:removeNineSlice(this.AchievementsFrame.Border.NineSlice)
			self:skinObject("scrollbar", {obj=this.AchievementsFrame.ScrollBar})
			local function skinElement(...)
				local _, element
				if _G.select("#", ...) == 2 then
					element, _ = ...
				elseif _G.select("#", ...) == 3 then
					_, element, _ = ...
				end
				skinAchievement(element)
				element.Description:SetTextColor(self.BT:GetRGB())
				if element.sbb then
					element.sbb:SetBackdropBorderColor(element:GetBackdropBorderColor())
					element.Icon.sbb:SetBackdropBorderColor(element:GetBackdropBorderColor())
				end
			end
			_G.ScrollUtil.AddInitializedFrameCallback(this.AchievementsFrame.ScrollBox, skinElement, aObj, true)
			skinStatusBar(this.TotalStatusBar)
			self:skinObject("frame", {obj=this.AchievementsFrame, kfs=true, fb=true})
			self:skinObject("frame", {obj=this, kfs=true, y1=0, y2=0})

			self:Unhook(this, "OnShow")
		end)

		-- hook this to skin status bars
		self:RawHook(_G.KrowiAF_SummaryFrame, "GetStatusBar", function(this, index)
			local sBar = self.hooks[this].GetStatusBar(this, index)
			skinStatusBar(sBar)
			return sBar
		end, true)

		-- Tooltip StatusBar
		for _, child in _G.ipairs_reverse{_G.GameTooltip:GetChildren()} do
			if child:GetName()
			and child:GetName():find("Krowi_ProgressBar")
			then
				child:DisableDrawLayer("BACKGROUND")
				child:DisableDrawLayer("OVERLAY")
				child.TextRight:SetDrawLayer("ARTWORK")
				child.TextLeft:SetDrawLayer("ARTWORK")
				for _, tex in _G.pairs(child.Fill) do
					tex:SetTexture(aObj.sbTexture)
				end
				break
			end
		end
	end

	self.RegisterCallback("Krowi_AchievementFilter", "AchievementUI_Skinned", skinK_AF, self)

	-- TODO: Skin Tutorials frame(s)

end
