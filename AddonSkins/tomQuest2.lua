local _G = _G

function Skinner:tomQuest2()

	local tq2 = LibStub("AceAddon-3.0"):GetAddon("tomQuest2", true)

	local ver = GetAddOnMetadata("tomQuest2", "Version")
--	self:Debug("tq2 ver: [%s]", ver)
	if ver == "3.3 beta 5" then self:tq233beta5(tq2) end

	local prdb = tq2.db.profile
	local tq2QTT = tq2.displayFrames.questsTooltip
	local tq2QT = tq2.displayFrames.questsTracker
	local tq2AT = tq2.displayFrames.achievementsTracker
--	self:Debug("tq2: [%s, %s, %s]", tq2QTT, tq2QT, tq2AT)
	-- skin Sliders
	self:skinSlider{obj=tq2QTT.slider, size=4}
	self:skinSlider{obj=tq2QT.slider, size=4}
	self:skinSlider{obj=tq2AT.slider, size=4}
	-- skin the tooltip if required
	if self.db.profile.Tooltips.skin then
		tq2.framesBackDrop.questsTooltip = CopyTable(self.backdrop)
		prdb.questsTooltip.backDropColor = CopyTable(self.bColour)
		prdb.questsTooltip.borderColor = CopyTable(self.bbColour)
		self:addSkinFrame{obj=tq2QTT}
	end
	-- skin the Quest & Achievement Trackers if required
	if self.db.profile.WatchFrame then
		tq2.framesBackDrop.questsTracker = CopyTable(self.backdrop)
		prdb.questsTracker.backDropColor = CopyTable(self.bColour)
		prdb.questsTracker.borderColor = CopyTable(self.bbColour)
		self:addSkinFrame{obj=tq2QT}
		tq2.framesBackDrop.achievementsTracker = CopyTable(self.backdrop)
		prdb.achievementsTracker.backDropColor = CopyTable(self.bColour)
		prdb.achievementsTracker.borderColor = CopyTable(self.bbColour)
		prdb.achievementsTracker.statusBarTexture = self.db.profile.StatusBar.texture
		self:addSkinFrame{obj=tq2AT}
	end

	-- hook this to skin the Parent frame and its sub panels
	self:SecureHook(tq2, "displayQuestInformations", function(this, qid)
		if this.moduleState["informations"] then
			local tq2PF = tomQuest2ParentFrame
			local tq2QL = tomQuest2ParentFrame.ql
			local tq2LH = tomQuest2ParentFrame.lh
			-- Parent Frame
			self:skinAllButtons{obj=tq2PF, tx=0}
			self:addSkinFrame{obj=tq2PF, x1=3, y1=-3, x2=-3, y2=3}
			prdb.backDropColor = CopyTable(self.bColour)
			prdb.borderColor = CopyTable(self.bbColour)
			-- Quest Log sub panel
			self:moveObject{obj=tq2QL.title, y=-5}
			self:skinScrollBar{obj=tq2QL.scroll}
			if LightHeaded then
				-- LightHeaded sub panel
				self:moveObject{obj=tq2LH.title, y=-5}
				self:skinScrollBar{obj=tq2LH.scroll}
			end
		end
		self:Unhook(tq2, "displayQuestInformations")
	end)

	-- hook this to change text colour before level number added
	self:RawHook(tq2, "QUEST_GREETING", function(this)
		for i = 1, MAX_NUM_QUESTS do
			local text = self:getRegion(_G["QuestTitleButton"..i], 3)
			text:SetTextColor(self.BTr, self.BTg, self.BTb)
		end
		self.hooks[tq2].QUEST_GREETING(this)
	end, true)

	-- hook this to handle collapse buttons
	if self.db.profile.Buttons then
		local function skinBtn(btn)

			if btn.cellType == "header"
			or btn.cellType == "questsTooltip"
			or btn.cellType == "questsTracker"
			or btn.cellType == "achievementsTracker"
			then
				if not btn.skin then
					local nTex = btn.iconTexture:GetTexture()
					self:skinButton{obj=btn, mp3=true, tx=0, plus=nTex:find("PlusButton") and true or nil}
				end
				btn:SetScale(0.85)
				btn:SetWidth(15)
				btn:SetHeight(15)
				btn.iconTexture:SetAlpha(0)
				if not self:IsHooked(btn.iconTexture, "SetTexture") then
					self:RawHook(btn.iconTexture, "SetTexture", function(this, iconTex)
--						self:Debug("SetTexture: [%s, %s, %s]", btn, this, iconTex)
						self.hooks[this].SetTexture(this, iconTex)
						this:SetAlpha(0)
						if iconTex:find("MinusButton") then
							btn:SetText(self.minus)
						elseif iconTex:find("PlusButton") then
							btn:SetText(self.plus)
						end
					end, true)
				end
			end

		end
		self:RawHook(tq2, "getButton", function(this, ...)
--			self:Debug("tq2 getButton: [%s, %s]", this, ...)
			local btn = self.hooks[this].getButton(this, ...)
			skinBtn(btn)
			return btn
		end, true)
		self:SecureHook(tq2, "recycleButton", function(this, btn)
--			self:Debug("recycleButton: [%s, %s, %s]", this, btn, btn.cellType)
			if btn.skin then
				btn:SetText("")
				btn:SetBackdrop(nil)
				btn:SetBackdropColor(nil)
				btn:SetBackdropBorderColor(nil)
				if btn.tfade then btn.tfade:SetTexture(nil) end
				btn:GetFontString():ClearAllPoints()
				btn:GetFontString():SetPoint("CENTER", btn, "CENTER")
				btn.skin = nil
			end
		end)
		-- skin existing m/p buttons
		for i = 1, tq2.numButtons do
			skinBtn(_G["tomQuest2Button"..i])
		end
		skinBtn(tq2.tooltipHeaderButton)
	end


end

function Skinner:tq233beta5(tq2) -- 3.3 beta 5

	local qTrkr = tq2:GetModule("questsTracker", true)
	local aTrkr = tq2:GetModule("achievementTracker", true)
	-- hook this to handle collapse buttons
	if self.db.profile.Buttons then
		self:RawHook(tq2, "getCollapseButton", function(this)
			local btn = self.hooks[this].getCollapseButton(this)
--			self:Debug("getCollapseButton: [%s]", btn)
			if not self:IsHooked(btn.iconTexture, "SetTexture") then
				self:RawHook(btn.iconTexture, "SetTexture", function(this, iconTex)
--					self:Debug("SetTexture: [%s, %s, %s]", btn, this, iconTex)
					self.hooks[this].SetTexture(this, iconTex)
					this:SetAlpha(1) -- show texture
					if not iconTex:find("Icons") then -- it's a m/p button
						if not btn.skin then self:skinButton{obj=btn, mp3=true, tx=0, ty=0} end
						this:SetAlpha(0)
						if iconTex:find("MinusButton") then
							btn:SetText(self.minus)
						elseif iconTex:find("PlusButton") then
							btn:SetText(self.plus)
						end
					end
				end, true)
			end
			return btn
		end, true)
		self:SecureHook(tq2, "recycleButton", function(this, btn)
--			self:Debug("recycleButton: [%s, %s, %s]", this, btn, btn.type)
			if btn.type == "collapse" then
				btn:SetText("")
				btn:SetBackdrop(nil)
				btn:SetBackdropColor(nil)
				btn:SetBackdropBorderColor(nil)
				if btn.tfade then btn.tfade:SetTexture(nil) end
				btn.skin = nil
			end
		end)
		-- force existing buttons to be skinned
		if qTrkr then
			qTrkr:updateQuestsTracker() -- force update
		end
		if aTrkr then
			aTrkr:updateAchievementTracker() -- force update
		end
	end

	-- Parent Frame
	local info = tq2:GetModule("informations", true)
	if info then
		self:SecureHook(info, "createLhGUI", function(this)
			self:moveObject{obj=tomQuest2LhFrame.title, y=-5}
			self:skinScrollBar{obj=tomQuest2LhScrollFrame}
			self:skinAllButtons{obj=tomQuest2LhFrame, tx=0}
			self:addSkinFrame{obj=tomQuest2LhFrame, x1=3, y1=-3, x2=-3, y2=3}
			self:Unhook(info, "createLhGUI")
		end)
		self:SecureHook(info, "createQlGUI", function(this)
			self:moveObject{obj=tomQuest2QlFrame.title, y=-5}
			self:skinScrollBar{obj=tomQuest2QlScrollFrame}
			self:skinAllButtons{obj=tomQuest2QlFrame, tx=0}
			self:addSkinFrame{obj=tomQuest2QlFrame, x1=3, y1=-3, x2=-3, y2=3}
			self:Unhook(info, "createQlGUI")
		end)
		self:SecureHook(info, "lockUnlockQlFrame", function()
			if tomQuest2ParentFrame then
				self:skinAllButtons{obj=tomQuest2ParentFrame}
				self:addSkinFrame{obj=tomQuest2ParentFrame}
				-- hook these to show/hide the individual skinFrames
				self:SecureHook(tomQuest2ParentFrame, "Show", function()
					self.skinFrame[tomQuest2LhFrame]:Hide()
					self.skinFrame[tomQuest2QlFrame]:Hide()
				end)
				self:SecureHook(tomQuest2ParentFrame, "Hide", function()
					self.skinFrame[tomQuest2LhFrame]:Show()
					self.skinFrame[tomQuest2QlFrame]:Show()
				end)
				self:Unhook(info, "lockUnlockQlFrame")
			end
		end)

		info.db.profile.backDropColor = CopyTable(self.bColour)
		info.db.profile.borderColor = CopyTable(self.bbColour)
	end

	-- find the tracker anchors and skin them
	if qTrkr or aTrkr then
		local kids = {UIParent:GetChildren()}
		for _, child in ipairs(kids) do
			if child:IsObjectType("Button") and child:GetName() == nil then
				if floor(child:GetHeight()) == 24 and child:GetFrameStrata() == "MEDIUM" then
					local r, g, b, a = child:GetBackdropColor()
					if  ("%.2f"):format(r) == "0.09"
					and ("%.2f"):format(g) == "0.09"
					and ("%.2f"):format(b) == "0.19"
					and ("%.1f"):format(a) == "0.5" then
						self:addSkinFrame{obj=child, x1=-2, x2=2} -- tracker anchor frame
					end
				end
			end
		end
		kids = nil
	end

	-- skin the Quest & Achievement Trackers if required
	if self.db.profile.WatchFrame then
		if qTrkr then
			qTrkr.db.profile.backDropColor = CopyTable(self.bColour)
			qTrkr.db.profile.borderColor = CopyTable(self.bbColour)
		end
		if aTrkr then
			aTrkr.db.profile.backDropColor = CopyTable(self.bColour)
			aTrkr.db.profile.borderColor = CopyTable(self.bbColour)
			aTrkr.db.profile.statusBarTexture = self.db.profile.StatusBar.texture
			aTrkr:updateAchievementTracker() -- force update
		end
	else
		-- if LibQTip skin is loaded then flag them to be ignored
		if self.ignoreLQTT then
			self.ignoreLQTT["tomQuest2Tracker"] = true
			self.ignoreLQTT["tomQuest2Achievements"] = true
		end
	end

	local qG = tq2:GetModule("questsGivers", true)
	if qG then
		-- hook this to change text colour before level number added
		self:RawHook(qG, "QUEST_GREETING", function(this)
			for i = 1, MAX_NUM_QUESTS do
				local text = self:getRegion(_G["QuestTitleButton"..i], 3)
				text:SetTextColor(self.BTr, self.BTg, self.BTb)
			end
			self.hooks[qG].QUEST_GREETING(this)
		end, true)
	end

end
