local aName, aObj = ...
if not aObj:isAddonEnabled("Altoholic") then return end
local _G = _G

local function skinMenuItms(frameName, cnt)

	local itm
	for i = 1, cnt do
		itm = frameName["MenuItem" .. i]
		aObj:keepRegions(itm, {3, 4}) -- N.B. region 3 is the highlight, 4 is the text
		aObj:applySkin(itm)
	end

end
local function skinSortBtns(btnName, cnt)

	local btn
	for i = 1, cnt do
		btn = _G[btnName..i]
		if i == 1 then aObj:moveObject{obj=btn, y=6} end
		aObj:adjHeight{obj=btn, adj=3}
		aObj:keepRegions(btn, {4, 5, 6}) -- N.B. region 6 is the highlight, 4 is the text & 5 is the arrow
		aObj:applySkin(btn)
	end

end
function aObj:Altoholic()

-->>-- Main Frame
	self:skinEditBox{obj=_G.AltoholicFrame_SearchEditBox, regs={9}}
	self:addSkinFrame{obj=_G.AltoholicFrame, kfs=true, y1=-11, y2=3}
	-- Tabs
	self:skinTabs{obj=_G.AltoholicFrame}

-->>-- Message Box
	self:addSkinFrame{obj=_G.AltoMsgBox, kfs=true, x1=6, y1=-6, x2=-6, y2=6}

-->>-- Tooltip
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then _G.AltoTooltip:SetBackdrop(self.backdrop) end
		self:SecureHookScript(_G.AltoTooltip, "OnShow", function(this)
			self:skinTooltip(_G.AltoTooltip)
		end)
	end

-->>-- Account Sharing option menu panel (buttons and panels)
	-- make sure icons are visible by changing their draw layer
	_G.AltoholicAccountSharingOptions.IconNever:SetDrawLayer("OVERLAY")
	_G.AltoholicAccountSharingOptions.IconAsk:SetDrawLayer("OVERLAY")
	_G.AltoholicAccountSharingOptions.IconAuto:SetDrawLayer("OVERLAY")

	self:skinScrollBar{obj=_G.AltoholicFrameSharingClientsScrollFrame}
	self:addSkinFrame{obj=_G.AltoholicFrameSharingClients}
	self:skinScrollBar{obj=_G.AltoholicFrameSharedContentScrollFrame}
-->>-- SharedContent option menu panel
	self:skinButton{obj=_G.AltoholicSharedContent_ToggleAll, mp2=true}
	self:addSkinFrame{obj=_G.AltoholicFrameSharedContent}
	for i = 1, 14 do
		self:skinButton{obj=_G["AltoholicFrameSharedContentEntry" .. i .. "Collapse"], mp2=true}
	end

-->>-- Account Sharing frame
	self:skinEditBox{obj=_G.AltoAccountSharing_AccNameEditBox, regs={9}}
	self:skinButton{obj=_G.AltoAccountSharing_ToggleAll, mp2=true}
	self:skinEditBox{obj=_G.AltoAccountSharing_AccTargetEditBox, regs={9}}
	self:skinScrollBar{obj=_G.AltoholicFrameAvailableContentScrollFrame}
	for i = 1, 10 do
		self:skinButton{obj=_G["AltoholicFrameAvailableContentEntry" .. i .. "Collapse"], mp2=true}
	end
	self:addSkinFrame{obj=_G.AltoholicFrameAvailableContent}
	self:addSkinFrame{obj=_G.AltoAccountSharing}

end

function aObj:Altoholic_Summary() -- LoD

	if self.modBtns then
		-- skin minus/plus buttons
		for i = 1, 14 do
			self:skinButton{obj=_G["AltoholicFrameSummaryEntry" .. i .. "Collapse"], mp2=true}
			self:skinButton{obj=_G["AltoholicFrameBagUsageEntry" .. i .. "Collapse"], mp2=true}
			self:skinButton{obj=_G["AltoholicFrameActivityEntry" .. i .. "Collapse"], mp2=true}
			self:skinButton{obj=_G["AltoholicFrameSkillsEntry" .. i .. "Collapse"], mp2=true}
		end
	end
	self:skinScrollBar{obj=_G.AltoholicFrameSummaryScrollFrame}

-->>-- Summary tab
	skinMenuItms(_G.AltoholicTabSummary, 6)
	skinSortBtns("AltoholicTabSummary_Sort", 9)
	self:skinButton{obj=_G.AltoholicTabSummaryToggleView, mp2=true, plus=true}
	self:skinDropDown{obj=_G.AltoholicTabSummary_SelectLocation}
	_G.UIDropDownMenu_SetButtonWidth(_G.AltoholicTabSummary_SelectLocation, 24)

	if self.modBtnBs then
		self:addButtonBorder{obj=_G.AltoholicTabSummary_OptionsDataStore}
		self:addButtonBorder{obj=_G.AltoholicTabSummary_Options}
		self:addButtonBorder{obj=_G.AltoholicTabSummary_RequestSharing}
	end

	self:skinScrollBar{obj=_G.AltoholicFrameBagUsageScrollFrame}
	self:skinScrollBar{obj=_G.AltoholicFrameSkillsScrollFrame}
	self:skinScrollBar{obj=_G.AltoholicFrameActivityScrollFrame}
	self:skinScrollBar{obj=_G.AltoholicFrameCurrenciesScrollFrame}

end

function aObj:Altoholic_Characters() -- LoD

 	-- Icons on LHS
 	-- Characters
	self:skinDropDown{obj=_G.AltoholicTabCharacters.SelectRealm}
	_G.UIDropDownMenu_SetButtonWidth(_G.AltoholicTabCharacters.SelectRealm, 24)
	skinSortBtns("AltoholicTabCharacters_Sort", 4)

	-- Icons at the Top in Character View
	if self.modBtnBs then
		self:addButtonBorder{obj=_G.AltoholicTabCharacters.MenuIcons.CharactersIcon}
		self:addButtonBorder{obj=_G.AltoholicTabCharacters.MenuIcons.BagsIcon}
		self:addButtonBorder{obj=_G.AltoholicTabCharacters.MenuIcons.QuestsIcon}
		self:addButtonBorder{obj=_G.AltoholicTabCharacters.MenuIcons.TalentsIcon}
		self:addButtonBorder{obj=_G.AltoholicTabCharacters.MenuIcons.AuctionIcon}
		self:addButtonBorder{obj=_G.AltoholicTabCharacters.MenuIcons.MailIcon}
		self:addButtonBorder{obj=_G.AltoholicTabCharacters.MenuIcons.SpellbookIcon}
		self:addButtonBorder{obj=_G.AltoholicTabCharacters.MenuIcons.ProfessionsIcon}
	end
	-- Characters
	-- Containers
	self:skinScrollBar{obj=_G.AltoholicFrameContainersScrollFrame}
	-- Quests
	self:skinScrollBar{obj=_G.AltoholicFrameQuestsScrollFrame}
	for i = 1, 14 do
		self:skinButton{obj=_G["AltoholicFrameQuestsEntry" .. i .. "Collapse"], mp2=true}
	end
	-- Talents/Glyphs
	self:skinDropDown{obj=_G.AltoholicFrameTalents_SelectMember}
	-- AuctionsHouse
	self:skinScrollBar{obj=_G.AltoholicFrameAuctionsScrollFrame}
	-- Mailbox
	self:skinScrollBar{obj=_G.AltoholicFrameMailScrollFrame}
	-- SpellBook/Mounts/Companions/Glyphs
	local btn, btnName
	for i = 1, 12 do
		btnName = "AltoholicFrameSpellbook_SpellIcon" .. i
		btn = _G[btnName]
		btn:DisableDrawLayer("BACKGROUND")
		btn:DisableDrawLayer("BORDER")
		_G[btnName .. "SlotFrame"]:SetAlpha(0)
		btn.UnlearnedFrame:SetAlpha(0)
		btn.TrainFrame:SetAlpha(0)
		btn.RequiredLevelString:SetTextColor(self.BTr, self.BTg, self.BTb)
		btn.SeeTrainerString:SetTextColor(self.BTr, self.BTg, self.BTb)
	end
	local function clrTxt()
		for i = 1, 12 do
			btn = "AltoholicFrameSpellbook_SpellIcon" .. i
			btn.SpellName:SetTextColor(aObj.HTr, aObj.HTg, aObj.HTb)
			btn.SpellSubName:SetTextColor(aObj.BTr, aObj.BTg, aObj.BTb)
		end
	end
	self:makeMFRotatable(_G.AltoholicFramePetsNormal_ModelFrame)
	-- hook this to colour Spell text
	self:SecureHook(_G.Altoholic.Spellbook, "Update", function(this)
		clrTxt()
	end)
	-- hook this to colour Glyph text
	self:SecureHook(_G.Altoholic.Spellbook, "UpdateKnownGlyphs", function(this)
		clrTxt()
	end)
	-- Professions
	self:skinButton{obj=_G.AltoholicFrameRecipesInfo_ToggleAll, mp2=true}
	for i = 1, 14 do
		self:skinButton{obj=_G["AltoholicFrameRecipesEntry" .. i .. "Collapse"], mp2=true}
	end
	self:skinScrollBar{obj=_G.AltoholicFrameRecipesScrollFrame}

end

function aObj:Altoholic_Search() --LoD

	skinMenuItms(_G.AltoholicTabSearch, 15)
	self:skinScrollBar{obj=_G.AltoholicSearchMenuScrollFrame}
	self:skinEditBox{obj=_G.AltoholicTabSearch.MinLevel, regs={9}}
	self:skinEditBox{obj=_G.AltoholicTabSearch.MaxLevel, regs={9}}
	self:skinDropDown{obj=_G.AltoholicTabSearch.SelectRarity}
	_G.UIDropDownMenu_SetButtonWidth(_G.AltoholicTabSearch.SelectRarity, 24)
	self:skinDropDown{obj=_G.AltoholicTabSearch.SelectSlot}
	_G.UIDropDownMenu_SetButtonWidth(_G.AltoholicTabSearch.SelectSlot, 24)
	self:skinDropDown{obj=_G.AltoholicTabSearch.SelectLocation}
	_G.UIDropDownMenu_SetButtonWidth(_G.AltoholicTabSearch.SelectLocation, 24)
	self:skinScrollBar{obj=_G.AltoholicFrameSearchScrollFrame}
	skinSortBtns("AltoholicTabSearch_Sort", 8)

end

function aObj:Altoholic_Guild() -- LoD

	skinMenuItms(_G.AltoholicTabGuild, 2)
	skinSortBtns("AltoholicTabGuild_Sort", 5)
	for i = 1, 14 do
		self:skinButton{obj=_G.AltoholicTabGuild.Members["Entry" .. i].Collapse, mp2=true}
	end
	-- Icons at the Top
	if self.modBtnBs then
		self:addButtonBorder{obj=_G.AltoholicTabGuild.Bank.MenuIcons.GuildIcon}
		self:addButtonBorder{obj=_G.AltoholicTabGuild.Bank.MenuIcons.TabsIcon}
		self:addButtonBorder{obj=_G.AltoholicTabGuild.Bank.MenuIcons.UpdateIcon}
		self:addButtonBorder{obj=_G.AltoholicTabGuild.Bank.MenuIcons.RarityIcon}
	end

end

function aObj:Altoholic_Achievements() -- LoD

	self:skinDropDown{obj=_G.AltoholicTabAchievements.SelectRealm}
	_G.UIDropDownMenu_SetButtonWidth(_G.AltoholicTabAchievements.SelectRealm, 24)
	skinMenuItms(_G.AltoholicTabAchievements, 15)
	self:skinScrollBar{obj=_G.AltoholicTabAchievements.ScrollFrame}
	self:skinScrollBar{obj=_G.AltoholicFrameAchievementsScrollFrame}

end

function aObj:Altoholic_Agenda() -- LoD

	skinMenuItms(_G.AltoholicTabAgenda, 5)

end

function aObj:Altoholic_Grids() -- LoD

	self:skinDropDown{obj=_G.AltoholicFrameGridsRightClickMenu}
	self:skinScrollBar{obj=_G.AltoholicFrameGridsScrollFrame}
	-- TabGrids
	self:skinDropDown{obj=_G.AltoholicTabGrids.SelectRealm}
	_G.UIDropDownMenu_SetButtonWidth(_G.AltoholicTabGrids.SelectRealm, 24)

	-- hook this to resize button
	self:RawHook("UIDropDownMenu_SetButtonWidth", function(frame, size)
		if frame == _G.AltoholicTabGrids.SelectView then
			size = 24
		end
		return self.hooks.UIDropDownMenu_SetButtonWidth(frame, size)
	end, true)
	self:skinDropDown{obj=_G.AltoholicTabGrids.SelectView}

end
