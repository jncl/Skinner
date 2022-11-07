local _, aObj = ...
if not aObj:isAddonEnabled("Krowi_AchievementFilter") then return end
local _G = _G

aObj.addonsToSkin.Krowi_AchievementFilter = function(self) -- v 45.4

	local afsbs, skinAlertFrame = {}, _G.nop

	if self.prdb.AlertFrames then
		function skinAlertFrame(frame)
			frame.animIn:Stop()
			frame.waitAndAnimOut:Stop()
			frame.Background:SetTexture(nil)
			frame:DisableDrawLayer("OVERLAY")
			aObj:skinObject("frame", {obj=frame, ofs=-2})
			frame.Unlocked:SetTextColor(aObj.BT:GetRGB())
			if aObj.modBtnBs then
				frame.Icon:DisableDrawLayer("OVERLAY")
				aObj:addButtonBorder{obj=frame.Icon, relTo=frame.Icon.Texture}
			end
		end

		_G.C_Timer.NewTicker(0.1, function(ticker)
			for _, afs in _G.ipairs_reverse(_G.AlertFrame.alertFrameSubSystems) do
				if afs.alertFramePool then
					if _G.strfind(afs.alertFramePool.frameTemplate, "KrowiAF_AlertFrame_") then
						self:SecureHook(afs, "setUpFunction", function(frame, _)
							skinAlertFrame(frame)
							if _G["AchievementFrameSideButton" .. frame.Event.Id] then
								skinAlertFrame(_G["AchievementFrameSideButton" .. frame.Event.Id])
							else
								self:add2Table(afsbs, "AchievementFrameSideButton" .. frame.Event.Id)
							end
						end)
						ticker:Cancel()
						break
					end
				end
			end
		end, 20)

	end

	local function skinK_AF()
		if _G.AchievementFrame.Header.Title then
			self:moveObject{obj=_G.AchievementFrame.Header.Title, x=-20}
		else
			self:moveObject{obj=_G.AchievementFrameHeaderTitle, x=-20}
		end
		self:moveObject{obj=_G.KrowiAF_AchievementFrameFilterButton, x=0, y=-5}
		if self.modBtns then
			self:skinStdButton{obj=_G.KrowiAF_AchievementFrameFilterButton, ofs=0, clr="grey"}
		end
		self:moveObject{obj=_G.KrowiAF_AchievementCalendarButton, x=10, y=0}
		self:skinObject("editbox", {obj=_G.KrowiAF_SearchBoxFrame, si=true, y1=-4, y2=4})

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

		self:SecureHookScript(_G.KrowiAF_CalendarSideFrame, "OnShow", function(this)
			self:removeNineSlice(this.Border)
			self:skinObject("frame", {obj=this, kfs=true, hdr=true, cb=true, ofs=0})

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.KrowiAF_DataManagerFrame, "OnShow", function(this)
			this.CharacterList.ColumnDisplay:DisableDrawLayer("BACKGROUND")
			this.CharacterList.ColumnDisplay:DisableDrawLayer("BORDER")
			this.CharacterList.ColumnDisplay:DisableDrawLayer("ARTWORK")
			for hdr in this.CharacterList.ColumnDisplay.columnHeaders:EnumerateActive() do
				hdr:DisableDrawLayer("BACKGROUND")
				self:skinObject("frame", {obj=hdr, ofs=0})
			end
			self:removeInset(this.CharacterList.InsetFrame)
			self:skinObject("slider", {obj=this.CharacterList.ScrollFrame.ScrollBar, rpTex="background"})
			for _, entry in _G.pairs(this.CharacterList.ScrollFrame.buttons) do
				if self.modChkBtns then
					entry:GetNormalTexture():SetTexture(nil)
					self:skinCheckButton{obj=entry.HeaderTooltip}
				end
			end
			self:skinObject("frame", {obj=this, kfs=true, cb=true, x1=1, x2=3})

			self:Unhook(this, "OnShow")
		end)

		local function skinAchievevment(btn)
			btn:DisableDrawLayer("BACKGROUND")
			btn:DisableDrawLayer("BORDER")
			btn:DisableDrawLayer("ARTWORK")
			if btn.hiddenDescription then
				btn.HiddenDescription:SetTextColor(self.BT:GetRGB())
			end
			aObj:nilTexture(btn.Icon.Border, true)
			aObj:secureHook(btn, "Desaturate", function(bObj)
				if bObj.sbb then
					bObj.sbb:SetBackdropBorderColor(bObj:GetBackdropBorderColor())
					bObj.Icon.sbb:SetBackdropBorderColor(bObj:GetBackdropBorderColor())
				end
			end)
			aObj:secureHook(btn, "Saturate", function(bObj)
				if bObj.sbb then
					bObj.sbb:SetBackdropBorderColor(bObj:GetBackdropBorderColor())
					bObj.Icon.sbb:SetBackdropBorderColor(bObj:GetBackdropBorderColor())
				end
				if bObj.Description then
					bObj.Description:SetTextColor(self.BT:GetRGB())
				end
			end)
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=btn.Icon, relTo=btn.Texture, x1=3, y1=0, x2=-3, y2=6}
				aObj:addButtonBorder{obj=btn, ofs=0}
			end
			if aObj.modChkBtns
			and btn.Tracked
			then
				aObj:skinCheckButton{obj=btn.Tracked}
			end
		end
		self:SecureHookScript(_G.KrowiAF_AchievementsFrame, "OnShow", function(this)
			self:removeNineSlice(this.Border.NineSlice)
			self:skinObject("slider", {obj=this.ScrollFrame.ScrollBar, rpTex="background"})
			for _, btn in _G.pairs(this.ScrollFrame.buttons) do
				skinAchievevment(btn)
			end
			self:skinObject("frame", {obj=this, kfs=true, y1=0, y2=0})

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.KrowiAF_CategoriesFrame, "OnShow", function(this)
			self:skinObject("slider", {obj=this.ScrollFrame.ScrollBar, rpTex="background"})
			for _, btn in _G.pairs(this.ScrollFrame.buttons) do
				btn:DisableDrawLayer("BACKGROUND")
			end
			self:skinObject("frame", {obj=this, kfs=true, y1=0, y2=0})

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.KrowiAF_AchievementFrameSummaryFrame, "OnShow", function(this)
			self:removeNineSlice(self:getChild(this, 1).NineSlice)
			this.Achievements.Header.Texture:SetTexture(nil)
			this.Categories.Header.Texture:SetTexture(nil)
			self:skinObject("slider", {obj=this.ScrollFrameBorder.ScrollFrame.ScrollBar, rpTex="background"})
			self:skinObject("frame", {obj=this.ScrollFrameBorder, kfs=true})
			for _, btn in _G.pairs(this.ScrollFrameBorder.ScrollFrame.buttons) do
				skinAchievevment(btn)
				btn.Description:SetTextColor(self.BT:GetRGB())
				if btn.sbb then
					btn.sbb:SetBackdropBorderColor(btn:GetBackdropBorderColor())
					btn.Icon.sbb:SetBackdropBorderColor(btn:GetBackdropBorderColor())
				end
			end
			self:skinObject("frame", {obj=this, kfs=true, y1=0, y2=0})

			self:Unhook(this, "OnShow")
		end)

		-- skin any AchievementFrameSideButtons if they exist
		for _, fName in _G.ipairs(afsbs) do
			if _G[fName] then
				skinAlertFrame(_G[fName])
			end
		end
		_G.wipe(afsbs)

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

end
