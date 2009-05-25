
function Skinner:Outfitter()
	if not self.db.profile.CharacterFrames then return end

	local function skinOutfitterTabs(tabId)

		for i = 1, OutfitterFrame.numTabs do
			if i == OutfitterFrame.selectedTab then Skinner:setActiveTab(_G["OutfitterFrameTab"..i])
			else Skinner:setInactiveTab(_G["OutfitterFrameTab"..i]) end
		end

	end

	if self.db.profile.TexturedTab then
		--  Handle new and old versions
		if type(Outfitter['ShowPanel']) == "function" then
			self:SecureHook(Outfitter, "ShowPanel", function(tabId)
--				self:Debug("Outfitter:ShowPanel: [%s]", tabId)
				skinOutfitterTabs(tabId)
			end)
		else
			self:SecureHook(Outfitter_ShowPanel, function(tabId)
--				self:Debug("Outfitter_ShowPanel: [%s]", tabId)
				skinOutfitterTabs(tabId)
			end)
		end
	end

	local function skinOutfitBars(this, ...)

		-- handle no Bars showing
		if not this.Bars then return end

		for i = 1, #this["Bars"] do
			local oBar = _G["OutfitterOutfitBar"..i]
			if not Skinner.skinFrame[oBar] then
				self:addSkinFrame{obj=oBar, kfs=true, x1=-2, y1=3, x2=0, y2=1}
			end
		end
		for i = 1, 2 do
			local dBar = this["DragBar"..i]
			if dBar and not Skinner.skinFrame[dBar] then
				Skinner:addSkinFrame{obj=dBar, kfs=true, x1=-2, y1=3, x2=0, y2=1}
				if not dBar.Vertical then dBar:SetWidth(20)
				else dBar:SetHeight(20) end
				-- hook this to handle an Orientation change
				Skinner:SecureHook(dBar, "SetVerticalOrientation", function(this, pVertical)
--					Skinner:Debug("O.OB._DB_SVO : [%s, %s, %s]", this, pVertical, this:GetWidth())
					if not this.Vertical then this:SetWidth(20)
					else this:SetHeight(20) end
				end)
			end
		end

	end

 	-- hook these to handle the Outfit Bars
	self:SecureHook(Outfitter.OutfitBar, "UpdateBar", function(this, ...)
		skinOutfitBars(this, ...)
	end)
	self:SecureHook(Outfitter.OutfitBar, "DragBar_OnClick", function(this)
		if OutfitBarSettingsDialog then
			self:applySkin(OutfitBarSettingsDialog)
			self:Unhook(Outfitter.OutfitBar, "DragBar_OnClick")
		end
	end)

	-- hook this to skin additional Shopping tooltips
	self:SecureHook(Outfitter._ExtendedCompareTooltip, "AddShoppingLink", function(this, ...)
		for i = 1, #this.Tooltips do
			if self.db.profile.Tooltips.skin then
				if self.db.profile.Tooltips.style == 3 and not self.skinned[this.Tooltips[i]] then
					this.Tooltips[i]:SetBackdrop(self.Backdrop[1])
				end
				self:skinTooltip(this.Tooltips[i])
			end
		end
	end)

-->>--	Outfitter Frame
	self:SecureHook(OutfitterFrame, "Show", function(this, ...)
		self:getChild(OutfitterFrame, 8):SetAlpha(0) -- hide band on the left
		self:addSkinFrame{obj=OutfitterFrame, kfs=true, y1=2, x2=2, y2=-2}
		self:Unhook(OutfitterFrame, "Show")
	end)

-->>--	Main Frame
	self:keepRegions(OutfitterMainFrame, {2, 3}) -- N.B. region 2 is text, 3 is background texture
	self:removeRegions(OutfitterMainFrameScrollbarTrench)
	self:keepFontStrings(OutfitterMainFrameScrollFrame)
	self:skinScrollBar(OutfitterMainFrameScrollFrame)

-->>--	Outfitter Tabs
	for i = 1, #Outfitter.cPanelFrames do
		local tabName = _G["OutfitterFrameTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		-- nil out the OnShow script to stop the tabs being resized
		tabName:SetScript("OnShow", nil)
		tabName:SetWidth(tabName:GetTextWidth() + 30)
		_G[tabName:GetName().."HighlightTexture"]:SetWidth(tabName:GetTextWidth() + 30)
		if self.db.profile.TexturedTab then self:applySkin(tabName, nil, 0, 1)
		else self:applySkin(tabName) end
		if i == 1 then
			self:moveObject(tabName, nil, nil, "+", 4)
			self:setActiveTab(tabName)
		else
			self:moveObject(tabName, "-", 10, nil, nil)
			self:setInactiveTab(tabName)
		end
	end

-->>--	New Outfit Panel
	self:skinEditBox{obj=OutfitterNameOutfitDialogName, regs={15, 16}}
	self:moveObject{obj=OutfitterNameOutfitDialogTitle, y=-6}
	self:skinDropDown{obj=OutfitterNameOutfitDialogAutomation}
	self:skinDropDown{obj=OutfitterNameOutfitDialogCreateUsing}
	-- align the dropdowns
	OutfitterNameOutfitDialogCreateUsingMiddle:SetWidth(OutfitterNameOutfitDialogAutomationMiddle:GetWidth())
	self:addSkinFrame{obj=OutfitterNameOutfitDialog, kfs=true, hdr=true, x1=10, y1=4, y2=4}

-->>--	ChooseIcon Dialog
	self:getChild(OutfitterChooseIconDialog, 1):SetBackdrop(nil) -- remove textures from anonymous frame
	self:keepFontStrings(OutfitterChooseIconDialogIconSetMenu)
	self:skinEditBox{obj=OutfitterChooseIconDialogFilterEditBox, regs={6}}
	self:skinScrollBar{obj=OutfitterChooseIconDialogScrollFrame}
	self:addSkinFrame{obj=OutfitterChooseIconDialog, x1=12, y1=-12, x2=-16, y2=16}

-->>--	EditScriptDialog Frame
	if OutfitterEditScriptDialog then
		self:keepFontStrings(OutfitterEditScriptDialogPresetScript)
		self:keepFontStrings(OutfitterEditScriptDialogSourceScript)
		self:skinScrollBar{obj=OutfitterEditScriptDialogSourceScript, noRR=true}
		self:keepFontStrings(OutfitterEditScriptDialog)
		self:applySkin(OutfitterEditScriptDialog)
		-- Tabs
		self:keepRegions(OutfitterEditScriptDialogTab1, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		if self.db.profile.TexturedTab then self:applySkin(OutfitterEditScriptDialogTab1, nil, 0, 1)
		else self:applySkin(OutfitterEditScriptDialogTab1) end
		self:moveObject(OutfitterEditScriptDialogTab1, nil, nil, "+", 4)
		self:setActiveTab(OutfitterEditScriptDialogTab1)
		self:keepRegions(OutfitterEditScriptDialogTab2, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		if self.db.profile.TexturedTab then self:applySkin(OutfitterEditScriptDialogTab2, nil, 0, 1)
		else self:applySkin(OutfitterEditScriptDialogTab2) end
		self:moveObject(OutfitterEditScriptDialogTab2, "+", 8, nil, nil)
		self:setInactiveTab(OutfitterEditScriptDialogTab2)
		if self.db.profile.TexturedTab then
			-- Hook these to manage the Tabs
			self:SecureHook(OutfitterEditScriptDialog, "SetPanelIndex", function(this, pIndex)
--				self:Debug("Outfitter_ESD_SetPanelIndex: [%s, %s]", this:GetName(), pIndex)
				self:setInactiveTab(OutfitterEditScriptDialogTab1)
				self:setInactiveTab(OutfitterEditScriptDialogTab2)
				if this.selectedTab == 1 then self:setActiveTab(OutfitterEditScriptDialogTab1)
				else self:setActiveTab(OutfitterEditScriptDialogTab2) end
				end)
		end
	end

-->>-- QuickSlots frame
	self:SecureHook(Outfitter, "InitializeQuickSlots", function()
		self:keepFontStrings(OutfitterQuickSlots)
		self:applySkin(OutfitterQuickSlots)
		self:SecureHook(OutfitterQuickSlots, "Show", function(this)
			self:moveObject(OutfitterQuickSlotsButton0, "+", 1, "-", 1)
		end)
		self:Unhook(Outfitter, "InitializeQuickSlots")
	end)
	
-->>-- Outfit Bars
	self:ScheduleTimer(skinOutfitBars, 1, Outfitter.OutfitBar) -- wait for a second before skinning the Outfit Bars

end
