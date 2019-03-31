local aName, aObj = ...
if not aObj:isAddonEnabled("Altoholic") then return end
local _G = _G

local function skinMenuItems(frameName, cnt, text)

	local itm
	for i = 1, cnt do
		itm = frameName[(text or "MenuItem") .. i]
		aObj:keepRegions(itm, {3, 4}) -- N.B. region 3 is the highlight, 4 is the text
		aObj:applySkin(itm)
	end
	itm = nil

end
local function skinSortBtns(btnArray)

	local btn
	for i = 1, btnArray.numButtons do
		btn = btnArray["Sort" .. i]
		if i == 1 then aObj:moveObject{obj=btn, y=6} end
		aObj:adjHeight{obj=btn, adj=5}
		aObj:keepRegions(btn, {4, 5, 6}) -- N.B. region 6 is the highlight, 4 is the text & 5 is the arrow
		aObj:applySkin(btn)
	end
	btn = nil

end
local function skinScrollBar(scrollFrame)

	scrollFrame:DisableDrawLayer("ARTWORK")
	aObj:skinSlider{obj=scrollFrame.ScrollBar, size=3}

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
				aObj:addSkinFrame{obj=frame, ft="a", kfs=true, nb=true}

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

aObj.addonsToSkin.Altoholic = function(self) -- r190

	-- Main Frame
	self:skinEditBox{obj=_G.AltoholicFrame_SearchEditBox, regs={9}}
	if self.modBtns then
		self:skinStdButton{obj=_G.AltoholicFrame_ResetButton}
		self:skinStdButton{obj=_G.AltoholicFrame_SearchButton}
	end
	self:addSkinFrame{obj=_G.AltoholicFrame, ft="a", kfs=true, y1=-11, x2=0, y2=4}
	-- Tabs
	self:skinTabs{obj=_G.AltoholicFrame}

	-- Message Box
	if self.modBtns then
		self:skinStdButton{obj=_G.AltoMessageBox.ButtonYes}
		self:skinStdButton{obj=_G.ButtonNo} -- N.B. not prefixed !
	end
	self:addSkinFrame{obj=_G.AltoMessageBox, ft="a", kfs=true, nb=true, x1=6, y1=-6, x2=-6, y2=6}

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
	self:addSkinFrame{obj=_G.AltoholicFrameSharingClients, ft="a", kfs=true, nb=true}
	skinScrollBar(_G.AltoholicFrameSharedContent.ScrollFrame)
	-- SharedContent option menu panel
	self:addSkinFrame{obj=_G.AltoholicFrameSharedContent, ft="a", kfs=true, nb=true}
	if self.modBtns then
		self:skinExpandButton{obj=_G.AltoholicSharedContent_ToggleAll, sap=true}
		for i = 1, 14 do
			if self.modBtns then
				self:skinExpandButton{obj=_G["AltoholicFrameSharedContentEntry" .. i .. "Collapse"], sap=true, plus=true}
			end
		end
	end
	if self.modChkBtns then
		for i = 1, 14 do
			self:skinCheckButton{obj=_G["AltoholicFrameSharedContentEntry" .. i .. "Check"]}
		end
	end

	self:skinEditBox{obj=_G.AltoAccountSharing_AccNameEditBox, regs={9}}
	self:skinEditBox{obj=_G.AltoAccountSharing_AccTargetEditBox, regs={9}}
	skinScrollBar(_G.AltoholicFrameAvailableContent.ScrollFrame)
	if self.modBtns then
		self:skinExpandButton{obj=_G.AltoAccountSharing_ToggleAll, sap=true, plus=true}
		for i = 1, 10 do
			self:skinExpandButton{obj=_G["AltoholicFrameAvailableContentEntry" .. i .. "Collapse"], sap=true, plus=true}
		end
	end
	self:addSkinFrame{obj=_G.AltoholicFrameAvailableContent, ft="a", kfs=true, nb=true}
	if self.modBtns then
		self:skinStdButton{obj=_G.AltoAccountSharing_InfoButton}
		self:skinStdButton{obj=_G.AltoAccountSharing_SendButton}
		self:skinStdButton{obj=_G.AltoAccountSharing_CancelButton}
	end
	self:addSkinFrame{obj=_G.AltoAccountSharing, ft="a", kfs=true, nb=true}

	-- Calendar option menu panel
	UIDDM_SetButtonWidth(_G.AltoholicCalendarOptions_WarningType1, 24)
	UIDDM_SetButtonWidth(_G.AltoholicCalendarOptions_WarningType2, 24)
	UIDDM_SetButtonWidth(_G.AltoholicCalendarOptions_WarningType3, 24)
	UIDDM_SetButtonWidth(_G.AltoholicCalendarOptions_WarningType4, 24)

	-- minimap button
	self.mmButs["Altoholic"] = _G.AltoholicMinimapButton

end

aObj.lodAddons.Altoholic_Summary = function(self)

	skinMenuItems(_G.AltoholicTabSummary, 6) -- ? 7 CurrentMode
	skinSortBtns(_G.AltoholicTabSummary.SortButtons)
	if self.modBtns then
		self:skinExpandButton{obj=_G.AltoholicTabSummary.ToggleView, sap=true}
	end
	-- N.B. when toggle is clicked the entries are toggled but the texture remains the same

	skinScrollBar(_G.AltoholicFrameSummary.ScrollFrame)

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
	if self.modBtns then
		-- skin minus/plus buttons
		for i = 1, 14 do
			self:skinExpandButton{obj=_G.AltoholicFrameSummary["Entry" .. i].Collapse, sap=true}
			self:SecureHook(_G.AltoholicFrameSummary["Entry" .. i].Collapse, "Toggle", function(this)
				self:checkTex{obj=this}
			end)
		end
	end

	self:SecureHook(_G.AltoholicTabSummary.ContextualMenu, "Toggle", function(this, frame, val1, val2)
		-- aObj:Debug("AltoholicTabSummary.ContextualMenu Toggle: [%s, %s, %s, %s]", this, frame, val1, val2)
		skinDDMLists()
	end)

end

aObj.lodAddons.Altoholic_Characters = function(self)

 	-- Icons on LHS
 	-- Characters
	skinSortBtns(_G.AltoholicTabCharacters.SortButtons)

	-- Icons at the Top in Character View
	if self.modBtnBs then
		for _, v in _G.pairs{"Characters", "Bags", "Quests", "Talents", "Auction", "Mail", "Spellbook", "Professions", "Garrison"} do
			self:addButtonBorder{obj=_G.AltoholicTabCharacters.MenuIcons[v .. "Icon"]}
		end
	end

	skinDDMLists()

	-- Characters
	-- Containers
	skinScrollBar(_G.AltoholicFrameContainers.ScrollFrame)

	-- Quests
	skinScrollBar(_G.AltoholicTabCharacters.QuestLog.ScrollFrame)
	-- N.B. following code commented out as Quests not being displayed atm ...
	-- for i = 1, 14 do
	-- self:skinExpandButton{obj=_G["AltoholicFrameQuestsEntry" .. i .. "Collapse"], sap=true, plus=true}
	-- end

	-- Talents/Glyphs

	-- AuctionsHouse
	skinScrollBar(_G.AltoholicFrameAuctionsScrollFrame)

	-- Mailbox
	skinScrollBar(_G.AltoholicFrameMail.ScrollFrame)

	-- SpellBook
	self:makeMFRotatable(_G.AltoholicFramePetsNormal_ModelFrame)
	-- hook this to skin Spell buttons
	self:SecureHook(_G.AltoholicTabCharacters.Spellbook, "Update", function(this)
		local btn
		for i = 1, 12 do
			btn = this["SpellIcon" .. i]
			btn:DisableDrawLayer("BACKGROUND")
			btn.Slot:SetAlpha(0)
			btn.SpellName:SetTextColor(self.HTr, self.HTg, self.HTb)
			btn.SubSpellName:SetTextColor(self.BTr, self.BTg, self.BTb)
			if self.modBtnBs then
				self:addButtonBorder{obj=btn, relTo=btn.Icon}
			end
		end
		btn = nil
	end)
	if self.modBtnBs then
		self:addButtonBorder{obj=_G.AltoholicTabCharacters.Spellbook.PrevPage, ofs=-2}
		self:addButtonBorder{obj=_G.AltoholicTabCharacters.Spellbook.NextPage, ofs=-2}
		self:addButtonBorder{obj=_G.AltoholicFramePetsNormalPrevPage, ofs=-2}
		self:addButtonBorder{obj=_G.AltoholicFramePetsNormalNextPage, ofs=-2}
	end

	-- Professions
	-- self:skinExpandButton{obj=_G.AltoholicTabCharacters.RecipesInfo_ToggleAll, sap=true, plus=true}
	-- for i = 1, 14 do
	-- 	self:skinExpandButton{obj=_G["AltoholicFrameRecipesEntry" .. i .. "Collapse"], sap=true, plus=true}
	-- end
	skinScrollBar(_G.AltoholicTabCharacters.Recipes.ScrollFrame)
	if self.modBtnBs then
		self:addButtonBorder{obj=_G.AltoholicTabCharacters.Recipes.LinkButton, x2=-3}
	end
	self:skinEditBox{obj=_G.AltoholicTabCharacters.Recipes.SearchBox, regs={6}} -- 6 is text

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
	end

end

aObj.lodAddons.Altoholic_Search = function(self)

	skinMenuItems(_G.AltoholicTabSearch, _G.AltoholicTabSearch.ScrollFrame.numRows, "Entry")
	skinScrollBar(_G.AltoholicTabSearch.ScrollFrame)
	self:skinEditBox{obj=_G.AltoholicTabSearch.MinLevel}
	self:skinEditBox{obj=_G.AltoholicTabSearch.MaxLevel}
	self:skinDropDown{obj=_G.AltoholicTabSearch.SelectRarity}
	UIDDM_SetButtonWidth(_G.AltoholicTabSearch.SelectRarity, 24)
	self:skinDropDown{obj=_G.AltoholicTabSearch.SelectSlot}
	UIDDM_SetButtonWidth(_G.AltoholicTabSearch.SelectSlot, 24)
	self:skinDropDown{obj=_G.AltoholicTabSearch.SelectLocation}
	UIDDM_SetButtonWidth(_G.AltoholicTabSearch.SelectLocation, 24)
	skinScrollBar(_G.AltoholicFrameSearch.ScrollFrame)
	skinSortBtns(_G.AltoholicTabSearch.SortButtons)

end

aObj.lodAddons.Altoholic_Guild = function(self)

	skinMenuItems(_G.AltoholicTabGuild, 2)
	skinSortBtns(_G.AltoholicTabGuild.SortButtons, 5)
	skinScrollBar(_G.AltoholicTabGuild.Members.ScrollFrame)
	for i = 1, 14 do
		self:skinExpandButton{obj=_G.AltoholicTabGuild.Members["Entry" .. i].Collapse, sap=true, plus=true}
	end
	-- Icons at the Top
	if self.modBtnBs then
		self:addButtonBorder{obj=_G.AltoholicTabGuild.Bank.MenuIcons.GuildIcon}
		self:addButtonBorder{obj=_G.AltoholicTabGuild.Bank.MenuIcons.TabsIcon}
		self:addButtonBorder{obj=_G.AltoholicTabGuild.Bank.MenuIcons.UpdateIcon}
		self:addButtonBorder{obj=_G.AltoholicTabGuild.Bank.MenuIcons.RarityIcon}
	end

	-- TODO skin guild bank tabs & buttons

end

aObj.lodAddons.Altoholic_Achievements = function(self)

	self:skinDropDown{obj=_G.AltoholicTabAchievements.SelectRealm}
	UIDDM_SetButtonWidth(_G.AltoholicTabAchievements.SelectRealm, 24)

	skinMenuItems(_G.AltoholicTabAchievements, _G.AltoholicTabAchievements.ScrollFrame.numRows, "Entry")
	skinScrollBar(_G.AltoholicTabAchievements.ScrollFrame)
	skinScrollBar(_G.AltoholicTabAchievements.Achievements.ScrollFrame)

	skinDDMLists()

end

aObj.lodAddons.Altoholic_Agenda = function(self)

	skinMenuItems(_G.AltoholicTabAgenda, 5)

end

aObj.lodAddons.Altoholic_Grids = function(self)

	self:skinDropDown{obj=_G.AltoholicFrameGridsRightClickMenu}
	skinScrollBar(_G.AltoholicFrameGrids.ScrollFrame)
	-- TabGrids
	self:skinDropDown{obj=_G.AltoholicTabGrids.SelectView}
	self:RawHook(_G.AltoholicTabGrids.SelectView, "SetButtonWidth", function(this, width)
		-- do nothing so it remains 24
	end, true)
	self:skinDropDown{obj=_G.AltoholicTabGrids.SelectRealm}
	UIDDM_SetButtonWidth(_G.AltoholicTabGrids.SelectRealm, 24)

	skinDDMLists()

end
