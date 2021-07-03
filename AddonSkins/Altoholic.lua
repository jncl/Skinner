local _, aObj = ...
if not aObj:isAddonEnabled("Altoholic") then return end
local _G = _G

local function skinMenuItems(frameName, cnt, text)
	local itm
	for i = 1, cnt do
		itm = frameName[(text or "MenuItem") .. i]
		if itm then
			aObj:keepRegions(itm, {3, 4}) -- N.B. region 3 is the highlight, 4 is the text
			aObj:skinObject("frame", {obj=itm})
		end
	end
	itm = nil
end
local function skinSortBtns(btnArray)
	local btn
	for i = 1, btnArray.numButtons do
		btn = btnArray["Sort" .. i]
		if i == 1 then
			aObj:moveObject{obj=btn, y=6}
		end
		aObj:keepRegions(btn, {4, 5, 6}) -- N.B. region 6 is the highlight, 4 is the text & 5 is the arrow
		aObj:skinObject("frame", {obj=btn, y1=-1, x2=-1, y2=-3})
	end
	btn = nil
end
local function skinScrollBar(scrollFrame)
	scrollFrame:DisableDrawLayer("ARTWORK")
	aObj:skinObject("slider", {obj=scrollFrame.ScrollBar})
end
local function UIDDM_SetButtonWidth(frame, width)
	frame.Button:SetWidth(width)
	frame.noResize = 1
end
local function skinDDMLists()
	-- aObj:Debug("skinDDMLists fired")
	local frame = _G.EnumerateFrames()
	while frame do
		if frame.IsObjectType -- handle object not being a frame !?
		and frame:IsObjectType("Button")
		and frame:GetName() == nil
		and frame:GetParent() == nil
		and frame:GetFrameStrata("FULLSCREEN_DIALOG")
		then
			if frame.maxWidth
			and frame.numButtons
			then
				-- aObj:Debug("skinDDMLists: [%s, %s, %s, %s]", frame, frame.maxWidth, frame.numButtons, frame:GetFrameStrata())
				-- remove old backdrops
				aObj:getChild(frame, 1):SetBackdrop(nil)
				aObj:getChild(frame, 2):SetBackdrop(nil)
				aObj:skinObject("frame", {obj=frame, kfs=true})

				-- hook the list toggle function
				if not aObj:IsHooked(frame, "Toggle") then
					aObj:SecureHook(frame, "Toggle", function(this, frame, val1, val2)
						-- aObj:Debug("skinDDMLists Toggle: [%s, %s, %s, %s]", this, frame, val1, val2)
						skinDDMLists()
					end)
				end
			end
		end
		frame = _G.EnumerateFrames(frame)
	end
	frame = nil
end

aObj.addonsToSkin.Altoholic = function(self) -- r200/r191

	-- Main Frame
	self:skinObject("editbox", {obj=_G.AltoholicFrame_SearchEditBox})
	self:skinObject("tabs", {obj=_G.AltoholicFrame, prefix=_G.AltoholicFrame:GetName(), numTabs=7})
	self:skinObject("frame", {obj=_G.AltoholicFrame, kfs=true, cb=true, y1=-11, x2=0, y2=self.isClsc and 6 or 2})
	if self.modBtns then
		self:skinStdButton{obj=_G.AltoholicFrame_ResetButton}
		self:skinStdButton{obj=_G.AltoholicFrame_SearchButton}
	end

	self:skinObject("frame", {obj=_G.AltoMessageBox, kfs=true, ofs=-6})
	if self.modBtns then
		self:skinStdButton{obj=_G.AltoMessageBox.ButtonYes}
		self:skinStdButton{obj=_G.ButtonNo} -- N.B. not prefixed !
	end

	-- Tooltip
	_G.C_Timer.After(0.1, function()
		self:add2Table(self.ttList, _G.AltoTooltip)
	end)

	-- Account Sharing option menu panel (buttons and panels)
	-- make sure icons are visible by changing their draw layer
	_G.AltoholicAccountSharingOptions.IconNever:SetDrawLayer("OVERLAY")
	_G.AltoholicAccountSharingOptions.IconAsk:SetDrawLayer("OVERLAY")
	_G.AltoholicAccountSharingOptions.IconAuto:SetDrawLayer("OVERLAY")
	skinScrollBar(_G.AltoholicFrameSharingClients.ScrollFrame)
	self:skinObject("frame", {obj=_G.AltoholicFrameSharingClients, kfs=true, fb=true, ofs=0})
	skinScrollBar(_G.AltoholicFrameSharedContent.ScrollFrame)
	-- SharedContent option menu panel
	self:skinObject("frame", {obj=_G.AltoholicFrameSharedContent, kfs=true, fb=true, ofs=0})
	if self.modBtns then
		self:skinExpandButton{obj=_G.AltoholicSharedContent_ToggleAll, sap=true}
		for i = 1, 14 do
			self:skinExpandButton{obj=_G["AltoholicFrameSharedContentEntry" .. i .. "Collapse"], sap=true}
		end
		self:SecureHookScript(_G.AltoholicSharedContent_ToggleAll, "OnClick", function(this, button)
			self:checkTex{obj=this}
		end)
		self:SecureHook(_G.Altoholic.Sharing.Content, "Update", function(this)
			local btn
			for i = 1, 14 do
				btn = _G["AltoholicFrameSharedContentEntry" .. i .. "Collapse"]
				if btn:IsShown() then
					self:checkTex{obj=btn}
				end
			end
			btn = nil
		end)
	end
	if self.modChkBtns then
		for i = 1, 14 do
			self:skinCheckButton{obj=_G["AltoholicFrameSharedContentEntry" .. i .. "Check"]}
		end
	end

	self:removeBackdrop(_G.AltoAccountSharing.Backdrop)
	self:skinObject("editbox", {obj=_G.AltoAccountSharing_AccNameEditBox})
	self:skinObject("editbox", {obj=_G.AltoAccountSharing_AccTargetEditBox})
	skinScrollBar(_G.AltoholicFrameAvailableContent.ScrollFrame)
	self:skinObject("frame", {obj=_G.AltoholicFrameAvailableContent, kfs=true, fb=true, ofs=0})
	self:skinObject("frame", {obj=_G.AltoAccountSharing, kfs=true})
	if self.modBtns then
		self:skinExpandButton{obj=_G.AltoAccountSharing_ToggleAll, sap=true, plus=true}
		for i = 1, 10 do
			self:skinExpandButton{obj=_G["AltoholicFrameAvailableContentEntry" .. i .. "Collapse"], sap=true, plus=true}
		end
		self:SecureHookScript(_G.AltoAccountSharing_ToggleAll, "OnClick", function(this, button)
			self:checkTex{obj=this}
		end)
		self:SecureHook(_G.Altoholic.Sharing.AvailableContent, "Update", function(this)
			local btn
			for i = 1, 10 do
				btn = _G["AltoholicFrameAvailableContentEntry" .. i .. "Collapse"]
				if btn:IsShown() then
					self:checkTex{obj=btn}
				end
			end
			btn = nil
		end)
		self:skinStdButton{obj=_G.AltoAccountSharing_InfoButton}
		self:skinStdButton{obj=_G.AltoAccountSharing_SendButton}
		self:skinStdButton{obj=_G.AltoAccountSharing_CancelButton}
	end
	if self.modChkBtns then
		self:skinCheckButton{obj=_G.AltoAccountSharing_CheckAll}
	end

	-- Calendar option menu panel
	UIDDM_SetButtonWidth(_G.AltoholicCalendarOptions_WarningType1, 24)
	UIDDM_SetButtonWidth(_G.AltoholicCalendarOptions_WarningType2, 24)
	UIDDM_SetButtonWidth(_G.AltoholicCalendarOptions_WarningType3, 24)
	UIDDM_SetButtonWidth(_G.AltoholicCalendarOptions_WarningType4, 24)

	-- minimap button
	self.mmButs["Altoholic"] = _G.AltoholicMinimapButton

end

aObj.lodAddons.Altoholic_Summary = function(self)

	skinMenuItems(_G.AltoholicTabSummary, 10)
	skinSortBtns(_G.AltoholicTabSummary.SortButtons)
	skinScrollBar(_G.AltoholicFrameSummary.ScrollFrame)
	-- N.B. when toggle is clicked the entries are toggled but the texture remains the same
	if self.modBtns then
		self:skinExpandButton{obj=_G.AltoholicTabSummary.ToggleView, sap=true}
		self:SecureHookScript(_G.AltoholicTabSummary.ToggleView, "OnClick", function(this)
			self:checkTex{obj=this}
		end)
		-- skin minus/plus buttons
		for i = 1, 14 do
			self:skinExpandButton{obj=_G.AltoholicFrameSummary["Entry" .. i].Collapse, sap=true}
			self:SecureHook(_G.AltoholicFrameSummary["Entry" .. i].Collapse, "Toggle", function(this)
				self:checkTex{obj=this}
			end)
		end
	end
	if self.modBtnBs then
		self:addButtonBorder{obj=_G.AltoholicTabSummary.RealmsIcon}
		self:addButtonBorder{obj=_G.AltoholicTabSummary.FactionIcon}
		self:addButtonBorder{obj=_G.AltoholicTabSummary.LevelIcon}
		self:addButtonBorder{obj=_G.AltoholicTabSummary.ProfessionsIcon}
		self:addButtonBorder{obj=_G.AltoholicTabSummary.ClassIcon}
		self:addButtonBorder{obj=_G.AltoholicTabSummary.DataStoreOptionsIcon}
		self:addButtonBorder{obj=_G.AltoholicTabSummary.AltoholicOptionsIcon}
		self:addButtonBorder{obj=_G.AltoholicTabSummary.RequestSharing}
	end

	self:SecureHook(_G.AltoholicTabSummary.ContextualMenu, "Toggle", function(_)
		skinDDMLists()
	end)

end

aObj.lodAddons.Altoholic_Characters = function(self)

 	-- Icons on LHS
 	-- Characters
	skinSortBtns(_G.AltoholicTabCharacters.SortButtons)
	-- Icons at the Top in Character View
	if self.modBtnBs then
		for _, btn in _G.pairs{_G.AltoholicTabCharacters.MenuIcons:GetChildren()} do
			self:addButtonBorder{obj=btn}
		end
	end
	skinDDMLists()
	-- Characters
	-- Containers
	skinScrollBar(_G.AltoholicFrameContainers.ScrollFrame)
	-- Quests
	skinScrollBar(_G.AltoholicTabCharacters.QuestLog.ScrollFrame)
	-- Talents
	-- AuctionsHouse
	skinScrollBar(_G.AltoholicFrameAuctionsScrollFrame)
	-- Mailbox
	skinScrollBar(_G.AltoholicFrameMail.ScrollFrame)
	-- SpellBook
	self:makeMFRotatable(_G.AltoholicFramePetsNormal_ModelFrame)
	self:SecureHook(_G.AltoholicTabCharacters.Spellbook, "Update", function(this)
		local btn
		for i = 1, 12 do
			btn = this["SpellIcon" .. i]
			btn:DisableDrawLayer("BACKGROUND")
			btn.Slot:SetAlpha(0)
			btn.SpellName:SetTextColor(self.HT:GetRGB())
			btn.SubSpellName:SetTextColor(self.BT:GetRGB())
			if self.modBtnBs then
				self:addButtonBorder{obj=btn, relTo=btn.Icon}
			end
		end
		btn = nil
	end)
	if self.modBtnBs then
		self:addButtonBorder{obj=_G.AltoholicTabCharacters.Spellbook.PrevPage, ofs=-2}
		self:addButtonBorder{obj=_G.AltoholicTabCharacters.Spellbook.NextPage, ofs=-2}
		self:SecureHook(_G.AltoholicTabCharacters.Spellbook, "SetPage", function(this, _)
			self:clrBtnBdr(this.PrevPage, "gold")
			self:clrBtnBdr(this.NextPage, "gold")
		end)
		self:addButtonBorder{obj=_G.AltoholicFramePetsNormalPrevPage, ofs=-2}
		self:addButtonBorder{obj=_G.AltoholicFramePetsNormalNextPage, ofs=-2}
		self:SecureHook(_G.Altoholic.Pets, "GoToPreviousPage", function(this)
			self:clrBtnBdr(_G.AltoholicFramePetsNormalPrevPage, "gold")
			self:clrBtnBdr(_G.AltoholicFramePetsNormalNextPage, "gold")
		end)
		self:SecureHook(_G.Altoholic.Pets, "GoToNextPage", function(this)
			self:clrBtnBdr(_G.AltoholicFramePetsNormalPrevPage, "gold")
			self:clrBtnBdr(_G.AltoholicFramePetsNormalNextPage, "gold")
		end)
		self:SecureHook(_G.Altoholic.Pets, "SetSinglePetView", function(this)
			self:clrBtnBdr(_G.AltoholicFramePetsNormalPrevPage, "gold")
			self:clrBtnBdr(_G.AltoholicFramePetsNormalNextPage, "gold")
		end)
	end
	-- Professions
	skinScrollBar(_G.AltoholicTabCharacters.Recipes.ScrollFrame)
	self:skinObject("editbox", {obj=_G.AltoholicTabCharacters.Recipes.SearchBox})
	self:moveObject{obj=_G.AltoholicTabCharacters.Recipes.SearchBox, x=50}
	self:moveObject{obj=_G.AltoholicTabCharacters.Recipes.LinkButton, x=50}
	if self.modBtnBs then
		self:addButtonBorder{obj=_G.AltoholicTabCharacters.Recipes.LinkButton, x2=-3}
	end
	if not self.isClsc then
		-- Garrison
		skinScrollBar(_G.AltoholicTabCharacters.GarrisonMissions.ScrollFrame)
		if self.modBtnBs then
			local frame
			for i = 1, _G.AltoholicTabCharacters.GarrisonMissions.ScrollFrame.numRows do
				frame = _G.AltoholicTabCharacters.GarrisonMissions.ScrollFrame:GetRow(i)
				self:addButtonBorder{obj=frame.MissionType, relTo=frame.MissionType.Icon}
				-- TODO if these are removed followers aren't visible
				-- for j = 1, 3 do
				-- 	frame["Follower" .. j]:DisableDrawLayer("BACKGROUND")
				-- end
				for j = 1, 2 do
					self:addButtonBorder{obj=frame["Reward" .. j], relTo=frame["Reward" .. j].Icon}
				end
			end
			frame = nil
		-- Covenant
		end
	end

end

aObj.lodAddons.Altoholic_Search = function(self)

	skinMenuItems(_G.AltoholicTabSearch, _G.AltoholicTabSearch.ScrollFrame.numRows, "Entry")
	skinScrollBar(_G.AltoholicTabSearch.ScrollFrame)
	self:skinObject("editbox", {obj=_G.AltoholicTabSearch.MinLevel})
	self:skinObject("editbox", {obj=_G.AltoholicTabSearch.MaxLevel})
	self:skinObject("dropdown", {obj=_G.AltoholicTabSearch.SelectRarity})
	UIDDM_SetButtonWidth(_G.AltoholicTabSearch.SelectRarity, 24)
	self:skinObject("dropdown", {obj=_G.AltoholicTabSearch.SelectSlot})
	UIDDM_SetButtonWidth(_G.AltoholicTabSearch.SelectSlot, 24)
	self:skinObject("dropdown", {obj=_G.AltoholicTabSearch.SelectLocation})
	UIDDM_SetButtonWidth(_G.AltoholicTabSearch.SelectLocation, 24)
	skinScrollBar(_G.AltoholicFrameSearch.ScrollFrame)
	skinSortBtns(_G.AltoholicTabSearch.SortButtons)

end

aObj.lodAddons.Altoholic_Guild = function(self)

	skinMenuItems(_G.AltoholicTabGuild, 2)
	skinSortBtns(_G.AltoholicTabGuild.SortButtons, 5)
	skinScrollBar(_G.AltoholicTabGuild.Members.ScrollFrame)
	if self.modBtns then
		local btn
		for i = 1, 14 do
			btn = _G.AltoholicTabGuild.Members["Entry" .. i].Collapse
			self:skinExpandButton{obj=btn, sap=true}
			if btn:IsShown() then
				self:checkTex{obj=btn}
			end
			self:SecureHookScript(btn, "OnClick", function(this)
				if this:IsShown() then
					self:checkTex{obj=this}
				end
			end)
		end
		btn = nil
	end
	if not self.isClsc then
		-- Bank
		if self.modBtnBs then
			for _, btn in _G.pairs(_G.AltoholicTabGuild.Bank.TabButtons) do
				self:addButtonBorder{obj=btn}
			end
			self:addButtonBorder{obj=_G.AltoholicTabGuild.Bank.MenuIcons.GuildIcon}
			self:addButtonBorder{obj=_G.AltoholicTabGuild.Bank.MenuIcons.TabsIcon}
			self:addButtonBorder{obj=_G.AltoholicTabGuild.Bank.MenuIcons.UpdateIcon}
			self:addButtonBorder{obj=_G.AltoholicTabGuild.Bank.MenuIcons.RarityIcon}
		end
		self:SecureHook(_G.AltoholicTabGuild.Bank.ContextualMenu, "Toggle", function(_)
			skinDDMLists()
		end)
	end

end

aObj.lodAddons.Altoholic_Achievements = function(self)

	self:skinObject("dropdown", {obj=_G.AltoholicTabAchievements.SelectRealm})
	UIDDM_SetButtonWidth(_G.AltoholicTabAchievements.SelectRealm, 24)
	skinMenuItems(_G.AltoholicTabAchievements, _G.AltoholicTabAchievements.ScrollFrame.numRows, "Entry")
	skinScrollBar(_G.AltoholicTabAchievements.ScrollFrame)
	skinScrollBar(_G.AltoholicTabAchievements.Achievements.ScrollFrame)
	skinDDMLists()
	if self.modBtnBs then
		self:addButtonBorder{obj=_G.AltoholicTabAchievements.PrevPage, ofs=-2, x1=1}
		self:addButtonBorder{obj=_G.AltoholicTabAchievements.NextPage, ofs=-2, x1=1}
		self:SecureHook(_G.AltoholicTabAchievements, "SetPage", function(this, _)
			self:clrBtnBdr(this.PrevPage, "gold")
			self:clrBtnBdr(this.NextPage, "gold")
		end)
		_G.AltoholicTabAchievements:SetPage(1)
	end

end

aObj.lodAddons.Altoholic_Agenda = function(self)

	skinMenuItems(_G.AltoholicTabAgenda, 5)
	if self.modBtnBs then
		self:addButtonBorder{obj=_G.AltoholicTabAgenda.Calendar.PrevMonth, ofs=-2, x1=1, clr="gold"}
		self:addButtonBorder{obj=_G.AltoholicTabAgenda.Calendar.NextMonth, ofs=-2, x1=1, clr="gold"}
	end

end

aObj.lodAddons.Altoholic_Grids = function(self)

	self:skinObject("dropdown", {obj=_G.AltoholicFrameGridsRightClickMenu})
	skinScrollBar(_G.AltoholicFrameGrids.ScrollFrame)
	self:skinObject("dropdown", {obj=_G.AltoholicTabGrids.SelectView})
	_G.AltoholicTabGrids.SelectView.SetButtonWidth = _G.nop
	self:skinObject("dropdown", {obj=_G.AltoholicTabGrids.SelectRealm})
	UIDDM_SetButtonWidth(_G.AltoholicTabGrids.SelectRealm, 24)
	skinDDMLists()
	if not self.isClsc
	and self.modBtnBs
	then
		self:addButtonBorder{obj=_G.AltoholicTabGrids.PrevPage, ofs=-2, x1=1, clr="gold"}
		self:addButtonBorder{obj=_G.AltoholicTabGrids.NextPage, ofs=-2, x1=1, clr="gold"}
		self:SecureHook(_G.AltoholicTabGrids, "SetPage", function(this, _)
			self:clrBtnBdr(this.PrevPage, "gold")
			self:clrBtnBdr(this.NextPage, "gold")
		end)
		_G.AltoholicTabGrids:SetPage(1)
	end

end
