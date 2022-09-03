local _, aObj = ...
if not aObj:isAddonEnabled("Altoholic") then return end
local _G = _G

if aObj.isRtl then
	aObj.addonsToSkin.Altoholic = function(self) -- v 9.1.007

		self:SecureHookScript(_G.AltoholicFrame, "OnShow", function(this)
			self:skinObject("editbox", {obj=this.SearchBox, si=true})
			self:skinObject("tabs", {obj=this, tabs=this.Tabs, lod=self.isTT and true})
			self:skinObject("frame", {obj=this, kfs=true, ri=true, rns=true, cb=true, x2=3, y2=-1})

			self:Unhook(this, "OnShow")
		end)

		self.mmButs["Altoholic"] = _G.AltoholicMinimapButton

		self:SecureHookScript(_G.AltoMessageBox, "OnShow", function(this)
			self:skinObject("editbox", {obj=this.UserInput})
			self:skinObject("frame", {obj=this, kfs=true, rb=true})
			if self.modBtns then
				self:skinStdButton{obj=this.Button1}
				self:skinStdButton{obj=this.Button2}
			end

			self:Unhook(this, "OnShow")
		end)

	end

	local function skinSlider(frame)
		frame:DisableDrawLayer("BACKGROUND")
		frame:DisableDrawLayer("BORDER")
		aObj:skinObject("slider", {obj=frame.ScrollBar})
	end
	local function skinMenuList(frame)
		if aObj.modBtns then
			for _, btn in _G.pairs(frame.Buttons) do
				btn:DisableDrawLayer("BACKGROUND")
				aObj:skinObject("frame", {obj=btn})
			end
		end
	end
	local function skinExpandBtns(frame)
		for i = 1, frame.ScrollFrame.numRows do
			aObj:skinExpandButton{obj=frame[frame.ScrollFrame.rowPrefix .. i].Collapse, sap=true}
			aObj:SecureHook(frame[frame.ScrollFrame.rowPrefix .. i].Collapse, "SetCollapsed", function(this)
				aObj:checkTex{obj=this}
			end)
			aObj:SecureHook(frame[frame.ScrollFrame.rowPrefix .. i].Collapse, "SetExpanded", function(this)
				aObj:checkTex{obj=this}
			end)
		end
	end
	local function skinNextPrev(frame)
		aObj:addButtonBorder{obj=frame.NextPage, ofs=-2, x1=1, clr="gold"}
		aObj:addButtonBorder{obj=frame.PrevPage, ofs=-2, x1=1, clr="gold"}
		aObj:SecureHook(frame, "SetPage", function(_, _)
			aObj:clrBtnBdr(frame.NextPage, "gold")
			aObj:clrBtnBdr(frame.PrevPage, "gold")
		end)
	end
	local function skinRowItems(frame)
		for i = 1, frame.ScrollFrame.numRows do
			for j = 1, 12 do
				aObj:addButtonBorder{obj=frame[frame.ScrollFrame.rowPrefix .. i]["Item" .. j]}
			end
		end
	end
	aObj.lodAddons.Altoholic_Summary = function(self)

		self:SecureHookScript(_G.AltoholicFrame.TabSummary, "OnShow", function(this)
			this.CategoriesList.Background:SetTexture(nil)
			skinSlider(this.CategoriesList.ScrollFrame)
			if self.modBtns then
				skinMenuList(this.CategoriesList)
				self:skinExpandButton{obj=this.ToggleView, sap=true}
				self:SecureHookScript(this.ToggleView, "OnClick", function(bObj)
					self:checkTex{obj=bObj}
				end)
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=this.RealmsIcon}
				self:addButtonBorder{obj=this.FactionIcon}
				self:addButtonBorder{obj=this.LevelIcon}
				self:addButtonBorder{obj=this.ProfessionsIcon}
				self:addButtonBorder{obj=this.ClassIcon}
				self:addButtonBorder{obj=this.MiscIcon}
				self:addButtonBorder{obj=this.BankIcon}
				self:addButtonBorder{obj=this.RequestSharing}
				self:addButtonBorder{obj=this.AltoholicOptionsIcon}
				self:addButtonBorder{obj=this.DataStoreOptionsIcon}
			end
			for _, hdr in _G.pairs(this.HeaderContainer.SortButtons) do
				hdr:DisableDrawLayer("BACKGROUND")
				self:skinObject("frame", {obj=hdr})
			end
			this.Background:DisableDrawLayer("BACKGROUND")
			skinSlider(this.Summary.ScrollFrame)
			if self.modBtns then
				skinExpandBtns(this.Summary)
			end
			-- ContextualMenu (DropDown?)
			-- TODO: try to skin dropdown list(s) when displayed

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.AltoholicFrame.TabSummary)

	end

	aObj.lodAddons.Altoholic_Characters = function(self)

		self:SecureHookScript(_G.AltoholicFrame.TabCharacters, "OnShow", function(this)
			this.CategoriesList.Background:SetTexture(nil)
			skinSlider(this.CategoriesList.ScrollFrame)
			if self.modBtns then
				skinMenuList(this.CategoriesList)
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=this.BagsIcon}
				self:addButtonBorder{obj=this.QuestsIcon}
				self:addButtonBorder{obj=this.TalentsIcon}
				self:addButtonBorder{obj=this.AuctionIcon}
				self:addButtonBorder{obj=this.MailIcon}
				self:addButtonBorder{obj=this.SpellbookIcon}
				self:addButtonBorder{obj=this.ProfessionsIcon}
				self:addButtonBorder{obj=this.GarrisonIcon}
				self:addButtonBorder{obj=this.CovenantIcon}
			end
			for _, hdr in _G.pairs(this.HeaderContainer.SortButtons) do
				hdr:DisableDrawLayer("BACKGROUND")
				self:skinObject("frame", {obj=hdr})
			end
			this.Background:DisableDrawLayer("BACKGROUND")
			-- ContextualMenu (DropDown?)

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.AltoholicFrame.TabCharacters)

	end

	aObj.lodAddons.Altoholic_Search = function(self)

		self:SecureHookScript(_G.AltoholicFrame.TabSearch, "OnShow", function(this)
			this.CategoriesList.Background:SetTexture(nil)
			skinSlider(this.CategoriesList.ScrollFrame)
			if self.modBtns then
				skinMenuList(this.CategoriesList)
				self:skinStdButton{obj=this.Reset}
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=this.LocationIcon}
				self:addButtonBorder{obj=this.RarityIcon}
				self:addButtonBorder{obj=this.EquipmentIcon}
				self:addButtonBorder{obj=this.ProfessionsIcon}
				self:addButtonBorder{obj=this.SearchOptionsIcon}
			end
			self:skinObject("editbox", {obj=this.MinLevel, inset=2, x2=4})
			self:skinObject("editbox", {obj=this.MaxLevel, inset=2, x2=4})
			for _, hdr in _G.pairs(this.HeaderContainer.SortButtons) do
				hdr:DisableDrawLayer("BACKGROUND")
				self:skinObject("frame", {obj=hdr})
			end
			this.Background:DisableDrawLayer("BACKGROUND")
			-- ContextualMenu (DropDown?)
			-- TODO: try to skin dropdown list(s) when displayed
			skinSlider(this.Panels.Search.ScrollFrame)
			if self.modBtnBs then
				for i = 1, this.Panels.Search.ScrollFrame.numRows do
					self:addButtonBorder{obj=this.Panels.Search[this.Panels.Search.ScrollFrame.rowPrefix .. i].Item}
				end
			end

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.AltoholicFrame.TabSearch)

	end

	aObj.lodAddons.Altoholic_Guild = function(self)

		self:SecureHookScript(_G.AltoholicFrame.TabGuild, "OnShow", function(this)
			this.CategoriesList.Background:SetTexture(nil)
			skinSlider(this.CategoriesList.ScrollFrame)
			if self.modBtns then
				skinMenuList(this.CategoriesList)
			end
			for _, hdr in _G.pairs(this.HeaderContainer.SortButtons) do
				hdr:DisableDrawLayer("BACKGROUND")
				self:skinObject("frame", {obj=hdr})
			end
			this.Background:DisableDrawLayer("BACKGROUND")
			skinSlider(this.Panels.Members.ScrollFrame)
			if self.modBtns then
				skinExpandBtns(this.Panels.Members)
			end
			if self.modBtnBs then
				for i = 1, 19 do
					self:addButtonBorder{obj=this.Panels.Members.Equipment["Item" .. i]}
				end
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=this.Panels.Bank.MenuIcons.GuildIcon}
				self:addButtonBorder{obj=this.Panels.Bank.MenuIcons.TabsIcon}
				self:addButtonBorder{obj=this.Panels.Bank.MenuIcons.UpdateIcon}
				self:addButtonBorder{obj=this.Panels.Bank.MenuIcons.RarityIcon}
				for _, row in _G.pairs(this.Panels.Bank.ItemRows) do
					for _, btn in _G.pairs(row.Items) do
						self:addButtonBorder{obj=btn}
					end
				end
				for _, tab in _G.pairs(this.Panels.Bank.TabButtons) do
					self:addButtonBorder{obj=tab}
				end
			end
			-- ContextualMenu
			-- TODO: try to skin dropdown list(s) when displayed

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.AltoholicFrame.TabGuild)

	end

	aObj.lodAddons.Altoholic_Achievements = function(self)

		self:SecureHookScript(_G.AltoholicFrame.TabAchievements, "OnShow", function(this)
			this.CategoriesList.Background:SetTexture(nil)
			skinSlider(this.CategoriesList.ScrollFrame)
			if self.modBtns then
				skinMenuList(this.CategoriesList)
			end
			this.SelectRealm.Button:SetWidth(24)
			self:skinObject("dropdown", {obj=this.SelectRealm})
			-- TODO: skin DropDownList
			-- ClassIcons ?
			if self.modBtnBs then
				skinNextPrev(this)
			end
			this.Background:DisableDrawLayer("BACKGROUND")
			-- ContextualMenu (DropDown?)
			-- TODO: try to skin dropdown list(s) when displayed
			skinSlider(this.Panels.Achievements.ScrollFrame)
			if self.modBtnBs then
				skinRowItems(this.Panels.Achievements)
			end

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.AltoholicFrame.TabAchievements)

	end

	aObj.lodAddons.Altoholic_Agenda = function(self)

		self:SecureHookScript(_G.AltoholicFrame.TabAgenda, "OnShow", function(this)
			this.CategoriesList.Background:SetTexture(nil)
			skinSlider(this.CategoriesList.ScrollFrame)
			if self.modBtns then
				skinMenuList(this.CategoriesList)
			end
			this.Background:DisableDrawLayer("BACKGROUND")
			if self.modBtnBs then
				self:addButtonBorder{obj=this.Panels.Calendar.NextMonth, ofs=-2, x1=1, clr="gold"}
				self:addButtonBorder{obj=this.Panels.Calendar.PrevMonth, ofs=-2, x1=1, clr="gold"}
			end
			skinSlider(this.Panels.Calendar.EventList.ScrollFrame)

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.AltoholicFrame.TabAgenda)

	end

	aObj.lodAddons.Altoholic_Grids = function(self)

		self:SecureHookScript(_G.AltoholicFrame.TabGrids, "OnShow", function(this)
			this.CategoriesList.Background:SetTexture(nil)
			skinSlider(this.CategoriesList.ScrollFrame)
			if self.modBtns then
				skinMenuList(this.CategoriesList)
			end
			this.SelectRealm.Button:SetWidth(24)
			self:skinObject("dropdown", {obj=this.SelectRealm})
			-- TODO: skin DropDownList
			-- ClassIcons ?
			if self.modBtnBs then
				skinNextPrev(this)
			end
			this.Background:DisableDrawLayer("BACKGROUND")
			-- ContextualMenu (DropDown?)
			-- TODO: try to skin dropdown list(s) when displayed
			self:add2Table(self.ttList, this.BuildingLevelTooltip)
			skinSlider(this.Panels.Grids.ScrollFrame)
			if self.modBtnBs then
				skinRowItems(this.Panels.Grids)
			end

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.AltoholicFrame.TabGrids)

	end

	local function skinKids(frame)
		for _, child in _G.ipairs{frame:GetChildren()} do
			if child:IsObjectType("CheckButton")
			and aObj.modChkBtns
			then
				aObj:skinCheckButton{obj=child}
			elseif child:IsObjectType("EditBox") then
				aObj:skinObject("editbox", {obj=child})
			elseif aObj:isDropDown(child) then
				child.Button:SetWidth(24)
				aObj:skinObject("dropdown", {obj=child})
			elseif child:IsObjectType("Slider") then
				aObj:keepFontStrings(aObj:getChild(child, 1))
				aObj:skinObject("slider", {obj=child})
			elseif child:IsObjectType("Button")
			and aObj.modBtns
			then
				if not child.Toggle then
					aObj:skinStdButton{obj=child}
				else
					aObj:skinExpandButton{obj=child, sap=true}
				end
			end
		end
	end
	local function skinContainer(frame)
		skinSlider(frame.ScrollFrame)
		aObj:skinObject("frame", {obj=frame, ofs=3, x2=1, fb=true})
	end
	aObj.lodAddons.Altoholic_Options = function(self)

		self:SecureHookScript(_G.AltoholicFrame.TabOptions, "OnShow", function(this)
			this.CategoriesList.Background:SetTexture(nil)
			skinSlider(this.CategoriesList.ScrollFrame)
			if self.modBtns then
				skinMenuList(this.CategoriesList)
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=this.URLIcon1}
				self:addButtonBorder{obj=this.URLIcon2}
				self:addButtonBorder{obj=this.URLIcon3}
				self:addButtonBorder{obj=this.URLIcon4}
			end
			self:skinObject("editbox", {obj=this.URL})
			this.Background:DisableDrawLayer("BACKGROUND")
			for key, panel in _G.pairs(this.Panels) do
				skinKids(panel)
				if key == 20 then -- SharingAuthorizations
					skinContainer(panel.CharactersContainer)
				elseif key == 21 -- SharingContent
				or key == 22 -- SharingProcess
				then
					skinContainer(panel.ContentContainer)
					for i = 1, panel.ContentContainer.ScrollFrame.numRows do
						if self.modBtns then
							self:skinExpandButton{obj=panel.ContentContainer.ScrollFrame:GetRow(i).Collapse, sap=true}
						end
						if self.modChkBtns then
							self:skinCheckButton{obj=panel.ContentContainer.ScrollFrame:GetRow(i).Check}
						end
					end
				end
			end

			self:Unhook(this, "OnShow")
		end)
		self:checkShown(_G.AltoholicFrame.TabOptions)

	end
else
	local function skinMenuItems(frameName, cnt, text)
		local itm
		for i = 1, cnt do
			itm = frameName[(text or "MenuItem") .. i]
			if itm then
				aObj:keepRegions(itm, {3, 4}) -- N.B. region 3 is the highlight, 4 is the text
				aObj:skinObject("frame", {obj=itm})
			end
		end
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
					-- remove old backdrops
					aObj:getChild(frame, 1):SetBackdrop(nil)
					aObj:getChild(frame, 2):SetBackdrop(nil)
					aObj:skinObject("frame", {obj=frame, kfs=true})

					-- hook the list toggle function
					if not aObj:IsHooked(frame, "Toggle") then
						aObj:SecureHook(frame, "Toggle", function(_, _, _, _)
							skinDDMLists()
						end)
					end
				end
			end
			frame = _G.EnumerateFrames(frame)
		end
	end

	aObj.addonsToSkin.Altoholic = function(self) -- v 2.5.007/r191

		-- Main Frame
		self:skinObject("editbox", {obj=_G.AltoholicFrame_SearchEditBox})
		self:skinObject("tabs", {obj=_G.AltoholicFrame, prefix=_G.AltoholicFrame:GetName(), numTabs=7})
		self:skinObject("frame", {obj=_G.AltoholicFrame, kfs=true, cb=true, y1=-11, x2=0, y2=6})
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

		-- minimap button
		self.mmButs["Altoholic"] = _G.AltoholicMinimapButton

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
			self:SecureHookScript(_G.AltoholicSharedContent_ToggleAll, "OnClick", function(this, _)
				self:checkTex{obj=this}
			end)
			self:SecureHook(_G.Altoholic.Sharing.Content, "Update", function(_)
				local btn
				for i = 1, 14 do
					btn = _G["AltoholicFrameSharedContentEntry" .. i .. "Collapse"]
					if btn:IsShown() then
						self:checkTex{obj=btn}
					end
				end
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
			self:SecureHookScript(_G.AltoAccountSharing_ToggleAll, "OnClick", function(this, _)
				self:checkTex{obj=this}
			end)
			self:SecureHook(_G.Altoholic.Sharing.AvailableContent, "Update", function(_)
				local btn
				for i = 1, 10 do
					btn = _G["AltoholicFrameAvailableContentEntry" .. i .. "Collapse"]
					if btn:IsShown() then
						self:checkTex{obj=btn}
					end
				end
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

		-- Other Option frames
		self:skinObject("slider", {obj=_G.AltoholicHelp_ScrollFrameScrollBar})
		self:skinObject("slider", {obj=_G.AltoholicSupport_ScrollFrameScrollBar})
		self:skinObject("slider", {obj=_G.AltoholicWhatsNew_ScrollFrameScrollBar})

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
			self:SecureHook(_G.Altoholic.Pets, "GoToPreviousPage", function(_)
				self:clrBtnBdr(_G.AltoholicFramePetsNormalPrevPage, "gold")
				self:clrBtnBdr(_G.AltoholicFramePetsNormalNextPage, "gold")
			end)
			self:SecureHook(_G.Altoholic.Pets, "GoToNextPage", function(_)
				self:clrBtnBdr(_G.AltoholicFramePetsNormalPrevPage, "gold")
				self:clrBtnBdr(_G.AltoholicFramePetsNormalNextPage, "gold")
			end)
			self:SecureHook(_G.Altoholic.Pets, "SetSinglePetView", function(_)
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

	end
end
