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
	aObj:skinSlider{obj=scrollFrame.ScrollBar}

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
				aObj:addSkinFrame{obj=frame}

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

	skinScrollBar(_G.AltoholicFrameSharingClients.ScrollFrame)
	self:addSkinFrame{obj=_G.AltoholicFrameSharingClients}
	skinScrollBar(_G.AltoholicFrameSharedContent.ScrollFrame)
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
	skinScrollBar(_G.AltoholicFrameAvailableContent.ScrollFrame)
	for i = 1, 10 do
		self:skinButton{obj=_G["AltoholicFrameAvailableContentEntry" .. i .. "Collapse"], mp2=true}
	end
	self:addSkinFrame{obj=_G.AltoholicFrameAvailableContent}
	self:addSkinFrame{obj=_G.AltoAccountSharing}

end

function aObj:Altoholic_Summary() -- LoD

	skinMenuItems(_G.AltoholicTabSummary, 6)
	skinSortBtns(_G.AltoholicTabSummary.SortButtons)
	self:skinButton{obj=_G.AltoholicTabSummary.ToggleView, mp2=true}

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
		-- skin minus/plus buttons
		for i = 1, 14 do
			self:skinButton{obj=_G.AltoholicFrameSummary["Entry" .. i].Collapse, mp2=true}
		end
	end

	self:SecureHook(_G.AltoholicTabSummary.ContextualMenu, "Toggle", function(this, frame, val1, val2)
		-- aObj:Debug("AltoholicTabSummary.ContextualMenu Toggle: [%s, %s, %s, %s]", this, frame, val1, val2)
		skinDDMLists()
	end)

end

function aObj:Altoholic_Characters() -- LoD

 	-- Icons on LHS
 	-- Characters
	self:skinDropDown{obj=_G.AltoholicTabCharacters.SelectRealm}
	UIDDM_SetButtonWidth(_G.AltoholicTabCharacters.SelectRealm, 24)
	skinSortBtns(_G.AltoholicTabCharacters.SortButtons)

	-- Icons at the Top in Character View
	if self.modBtnBs then
		for _, v in pairs{"Characters", "Bags", "Quests", "Talents", "Auction", "Mail", "Spellbook", "Professions", "Garrison"} do
			self:addButtonBorder{obj=_G.AltoholicTabCharacters.MenuIcons[v .. "Icon"]}
		end
	end

	skinDDMLists()

	-- Characters
	-- Containers
	skinScrollBar(_G.AltoholicFrameContainers.ScrollFrame)
	-- Quests
	skinScrollBar(_G.AltoholicFrameQuestsScrollFrame)
	for i = 1, 14 do
		self:skinButton{obj=_G["AltoholicFrameQuestsEntry" .. i .. "Collapse"], mp2=true}
	end
	-- Talents/Glyphs
	-- AuctionsHouse
	skinScrollBar(_G.AltoholicFrameAuctionsScrollFrame)
	-- Mailbox
	skinScrollBar(_G.AltoholicFrameMail.ScrollFrame)
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
			btn = _G["AltoholicFrameSpellbook_SpellIcon" .. i]
			btn.SpellName:SetTextColor(aObj.HTr, aObj.HTg, aObj.HTb)
			btn.SpellSubName:SetTextColor(aObj.BTr, aObj.BTg, aObj.BTb)
		end
	end
	self:makeMFRotatable(_G.AltoholicFramePetsNormal_ModelFrame)
	-- hook this to colour Spell text
	self:SecureHook(_G.Altoholic.Spellbook, "Update", function(this)
		clrTxt()
	end)
	if self.modBtnBs then
		self:addButtonBorder{obj=_G.AltoholicFrameSpellbookPrevPage, ofs=-2}
		self:addButtonBorder{obj=_G.AltoholicFrameSpellbookNextPage, ofs=-2}
		self:addButtonBorder{obj=_G.AltoholicFramePetsNormalPrevPage, ofs=-2}
		self:addButtonBorder{obj=_G.AltoholicFramePetsNormalNextPage, ofs=-2}
	end
	-- Professions
	self:skinButton{obj=_G.AltoholicFrameRecipesInfo_ToggleAll, mp2=true}
	for i = 1, 14 do
		self:skinButton{obj=_G["AltoholicFrameRecipesEntry" .. i .. "Collapse"], mp2=true}
	end
	skinScrollBar(_G.AltoholicFrameRecipesScrollFrame)
	-- Garrison
	skinScrollBar(_G.AltoholicFrameGarrisonMissions.ScrollFrame)
	local frame
	for i = 1, _G.AltoholicFrameGarrisonMissions.ScrollFrame.numRows do
		frame = _G.AltoholicFrameGarrisonMissions.ScrollFrame:GetRow(i)
		self:addButtonBorder{obj=frame.Type, relTo=frame.Type.Icon}
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

function aObj:Altoholic_Search() --LoD

	skinMenuItems(_G.AltoholicTabSearch, _G.AltoholicTabSearch.ScrollFrame.numRows, "Entry")
	skinScrollBar(_G.AltoholicTabSearch.ScrollFrame)
	self:skinEditBox{obj=_G.AltoholicTabSearch.MinLevel, regs={9}}
	self:skinEditBox{obj=_G.AltoholicTabSearch.MaxLevel, regs={9}}
	self:skinDropDown{obj=_G.AltoholicTabSearch.SelectRarity}
	_G.UIDropDownMenu_SetButtonWidth(_G.AltoholicTabSearch.SelectRarity, 24)
	self:skinDropDown{obj=_G.AltoholicTabSearch.SelectSlot}
	_G.UIDropDownMenu_SetButtonWidth(_G.AltoholicTabSearch.SelectSlot, 24)
	self:skinDropDown{obj=_G.AltoholicTabSearch.SelectLocation}
	_G.UIDropDownMenu_SetButtonWidth(_G.AltoholicTabSearch.SelectLocation, 24)
	skinScrollBar(_G.AltoholicFrameSearch.ScrollFrame)
	skinSortBtns(_G.AltoholicTabSearch.SortButtons)

end

function aObj:Altoholic_Guild() -- LoD

	skinMenuItems(_G.AltoholicTabGuild, 2)
	skinSortBtns(_G.AltoholicTabGuild.SortButtons, 5)
	skinScrollBar(_G.AltoholicTabGuild.Members.ScrollFrame)
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
	UIDDM_SetButtonWidth(_G.AltoholicTabAchievements.SelectRealm, 24)

	skinMenuItems(_G.AltoholicTabAchievements, _G.AltoholicTabAchievements.ScrollFrame.numRows, "Entry")
	skinScrollBar(_G.AltoholicTabAchievements.ScrollFrame)
	skinScrollBar(_G.AltoholicFrameAchievements.ScrollFrame)

	skinDDMLists()

end

function aObj:Altoholic_Agenda() -- LoD

	skinMenuItems(_G.AltoholicTabAgenda, 5)

end

function aObj:Altoholic_Grids() -- LoD

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
