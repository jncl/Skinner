local aName, aObj = ...
if not aObj:isAddonEnabled("Altoholic") then return end
local _G = _G

local function skinMenuItms(itmName, cnt)

	local itm
	for i = 1, cnt do
		itm = _G[itmName..i]
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
	for i = 1, _G.AltoholicFrame.numTabs do
		local tabObj = _G["AltoholicFrameTab"..i]
		self:keepRegions(tabObj, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		local tabSF = self:addSkinFrame{obj=tabObj, noBdr=self.isTT, x1=6, y1=0, x2=-6, y2=2}
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end
	self.tabFrames[_G.AltoholicFrame] = true

-->>-- Message Box
	self:addSkinFrame{obj=_G.AltoMsgBox, kfs=true, x1=6, y1=-6, x2=-6, y2=6}

-->>--	Tooltip
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then _G.AltoTooltip:SetBackdrop(self.backdrop) end
		self:SecureHookScript(_G.AltoTooltip, "OnShow", function(this)
			self:skinTooltip(_G.AltoTooltip)
		end)
	end

-->>-- Account Sharing option menu panel (buttons and panels)
	-- make sure icons are visible by changing their draw layer
	_G.AltoholicAccountSharingOptionsIconNever:SetDrawLayer("OVERLAY")
	_G.AltoholicAccountSharingOptionsIconAsk:SetDrawLayer("OVERLAY")
	_G.AltoholicAccountSharingOptionsIconAuto:SetDrawLayer("OVERLAY")
	self:skinScrollBar{obj=_G.AltoholicFrameSharingClientsScrollFrame}
	self:addSkinFrame{obj=_G.AltoholicFrameSharingClients}
	self:skinScrollBar{obj=_G.AltoholicFrameSharedContentScrollFrame}
-->>-- SharedContent option menu panel
	self:skinButton{obj=_G.AltoholicSharedContent_ToggleAll, mp2=true}
	self:addSkinFrame{obj=_G.AltoholicFrameSharedContent}
	for i = 1, 10 do
		self:skinButton{obj=_G["AltoholicFrameSharedContentEntry"..i.."Collapse"], mp2=true}
	end

-->>-- Account Sharing frame
	self:skinEditBox{obj=_G.AltoAccountSharing_AccNameEditBox, regs={9}}
	self:skinButton{obj=_G.AltoAccountSharing_ToggleAll, mp2=true}
	self:skinEditBox{obj=_G.AltoAccountSharing_AccTargetEditBox, regs={9}}
	self:skinScrollBar{obj=_G.AltoholicFrameAvailableContentScrollFrame}
	for i = 1, 10 do
		self:skinButton{obj=_G["AltoholicFrameAvailableContentEntry"..i.."Collapse"], mp2=true}
	end
	self:addSkinFrame{obj=_G.AltoAccountSharing}

end

function aObj:Altoholic_Summary() -- LoD

	if self.modBtns then
		-- skin minus/plus buttons
		for i = 1, 14 do
			self:skinButton{obj=_G["AltoholicFrameSummaryEntry"..i.."Collapse"], mp2=true}
			self:skinButton{obj=_G["AltoholicFrameBagUsageEntry"..i.."Collapse"], mp2=true}
			self:skinButton{obj=_G["AltoholicFrameActivityEntry"..i.."Collapse"], mp2=true}
			self:skinButton{obj=_G["AltoholicFrameSkillsEntry"..i.."Collapse"], mp2=true}
		end
	end

-->>-- Summary tab
	skinMenuItms("AltoholicTabSummaryMenuItem", 5)
	skinSortBtns("AltoholicTabSummary_Sort", 8)
	self:skinButton{obj=_G.AltoholicTabSummaryToggleView, mp2=true, plus=true}
	self:skinDropDown{obj=_G.AltoholicTabSummary_SelectLocation}
	self:skinScrollBar{obj=_G.AltoholicFrameSummaryScrollFrame}
	self:skinScrollBar{obj=_G.AltoholicFrameBagUsageScrollFrame}
	self:skinScrollBar{obj=_G.AltoholicFrameSkillsScrollFrame}
	self:skinScrollBar{obj=_G.AltoholicFrameActivityScrollFrame}
	self:skinScrollBar{obj=_G.AltoholicFrameCurrenciesScrollFrame}

	if self.modBtnBs then
		self:addButtonBorder{obj=_G.AltoholicTabSummary_RequestSharing}
		self:addButtonBorder{obj=_G.AltoholicTabSummary_Options}
		self:addButtonBorder{obj=_G.AltoholicTabSummary_OptionsDataStore}
	end

end

function aObj:Altoholic_Characters() -- LoD

 	-- Icons on LHS
 	-- Characters
	self:skinDropDown{obj=_G.AltoholicTabCharacters_SelectRealm}
	skinSortBtns("AltoholicTabCharacters_Sort", 4)

	-- Icons at the Top in Character View
	if self.modBtnBs then
		self:addButtonBorder{obj=_G.AltoholicTabCharacters_CharactersIcon}
		self:addButtonBorder{obj=_G.AltoholicTabCharacters_BagsIcon}
		self:addButtonBorder{obj=_G.AltoholicTabCharacters_QuestsIcon}
		self:addButtonBorder{obj=_G.AltoholicTabCharacters_TalentsIcon}
		self:addButtonBorder{obj=_G.AltoholicTabCharacters_AuctionIcon}
		self:addButtonBorder{obj=_G.AltoholicTabCharacters_MailIcon}
		self:addButtonBorder{obj=_G.AltoholicTabCharacters_SpellbookIcon}
		self:addButtonBorder{obj=_G.AltoholicTabCharacters_ProfessionsIcon}
	end
	-- Characters
	-- Containers
	self:skinScrollBar{obj=_G.AltoholicFrameContainersScrollFrame}
	-- Quests
	self:skinScrollBar{obj=_G.AltoholicFrameQuestsScrollFrame}
	-- Talents/Glyphs
	self:skinDropDown{obj=_G.AltoholicFrameTalents_SelectMember}
	-- AuctionsHouse
	self:skinScrollBar{obj=_G.AltoholicFrameAuctionsScrollFrame}
	-- Mailbox
	self:skinScrollBar{obj=_G.AltoholicFrameMailScrollFrame}
	-- SpellBook/Mounts/Companions/Glyphs
	local btn, btnName
	for i = 1, 12 do
		btnName = "AltoholicFrameSpellbook_SpellIcon"..i
		btn = _G[btnName]
		btn:DisableDrawLayer("BACKGROUND")
		btn:DisableDrawLayer("BORDER")
		_G[btnName.."SlotFrame"]:SetAlpha(0)
		btn.UnlearnedFrame:SetAlpha(0)
		btn.TrainFrame:SetAlpha(0)
		btn.RequiredLevelString:SetTextColor(self.BTr, self.BTg, self.BTb)
		btn.SeeTrainerString:SetTextColor(self.BTr, self.BTg, self.BTb)
	end
	local function clrTxt()

		for i = 1, 12 do
			btnName = "AltoholicFrameSpellbook_SpellIcon"..i
			btn = _G[btnName]
			btn.SpellName:SetTextColor(self.HTr, self.HTg, self.HTb)
			btn.SpellSubName:SetTextColor(self.BTr, self.BTg, self.BTb)
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
	self:skinScrollBar{obj=_G.AltoholicFrameRecipesScrollFrame}

end

function aObj:Altoholic_Search() --LoD

	self:skinScrollBar{obj=_G.AltoholicSearchMenuScrollFrame}
	self:skinEditBox{obj=_G.AltoholicTabSearch_MinLevel, regs={9}}
	self:skinEditBox{obj=_G.AltoholicTabSearch_MaxLevel, regs={9}}
	self:skinDropDown{obj=_G.AltoholicTabSearch_SelectRarity}
	self:skinDropDown{obj=_G.AltoholicTabSearch_SelectSlot}
	self:skinDropDown{obj=_G.AltoholicTabSearch_SelectLocation}
	self:skinScrollBar{obj=_G.AltoholicFrameSearchScrollFrame}
	skinMenuItms("AltoholicTabSearchMenuItem", 15)
	skinSortBtns("AltoholicTabSearch_Sort", 8)

end

function aObj:Altoholic_Guild() -- LoD

	-- Icons at the Top
	if self.modBtnBs then
		self:addButtonBorder{obj=_G.AltoholicFrameGuildBank_GuildIcon}
		self:addButtonBorder{obj=_G.AltoholicFrameGuildBank_TabsIcon}
		self:addButtonBorder{obj=_G.AltoholicFrameGuildBank_UpdateIcon}
		self:addButtonBorder{obj=_G.AltoholicFrameGuildBank_RarityIcon}
	end
	skinMenuItms("AltoholicTabGuildMenuItem", 2)
	for i = 1, 14 do
		self:skinButton{obj=_G["AltoholicFrameGuildMembersEntry"..i.."Collapse"], mp2=true}
	end
	skinSortBtns("AltoholicTabGuild_Sort", 5)

end

function aObj:Altoholic_Achievements() -- LoD

	self:skinScrollBar{obj=_G.AltoholicAchievementsMenuScrollFrame}
	self:skinScrollBar{obj=_G.AltoholicFrameAchievementsScrollFrame}
	self:skinDropDown{obj=_G.AltoholicTabAchievements_SelectRealm}
	skinMenuItms("AltoholicTabAchievementsMenuItem", 15)

end

function aObj:Altoholic_Agenda() -- LoD

	skinMenuItms("AltoholicTabAgendaMenuItem", 5)

end

function aObj:Altoholic_Grids() -- LoD

	self:skinDropDown{obj=_G.AltoholicFrameGridsRightClickMenu}
	self:skinScrollBar{obj=_G.AltoholicFrameGridsScrollFrame}
	-- TabGrids
	self:skinDropDown{obj=_G.AltoholicTabGrids_SelectView}
	self:skinDropDown{obj=_G.AltoholicTabGrids_SelectRealm}

end
