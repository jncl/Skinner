local _, aObj = ...
if not aObj:isAddonEnabled("Altoholic") then return end
local _G = _G

aObj.addonsToSkin.Altoholic = function(self) -- v 9.1.002

	self:SecureHookScript(_G.AltoholicFrame, "OnShow", function(this)
		self:skinObject("editbox", {obj=this.SearchBox, si=true})
		self:skinObject("tabs", {obj=this, tabs=this.Tabs, lod=self.isTT and true})
		self:skinObject("frame", {obj=this, kfs=true, ri=true, rns=true, cb=true, x2=3, y2=-1})
		
		self:Unhook(this, "OnShow")
	end)

	self:add2Table(self.ttList, _G.AltoTooltip)
	
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
	aObj:SecureHook(frame, "SetPage", function(this, _)
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
aObj.lodAddons.Altoholic_Summary = function(self) -- v 9.1.002

	self:SecureHookScript(_G.AltoholicFrame.TabSummary, "OnShow", function(this)
		this.CategoriesList.Background:SetTexture(nil)
		skinSlider(this.CategoriesList.ScrollFrame)
		if self.modBtns then
			skinMenuList(this.CategoriesList)
			self:skinExpandButton{obj=this.ToggleView, sap=true}
			self:SecureHookScript(this.ToggleView, "OnClick", function(this)
				self:checkTex{obj=this}
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

aObj.lodAddons.Altoholic_Characters = function(self) -- v 9.1.002

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
		-- TODO: try to skin dropdown list(s) when displayed

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.AltoholicFrame.TabCharacters)

end

aObj.lodAddons.Altoholic_Search = function(self) -- v 9.1.002

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

aObj.lodAddons.Altoholic_Guild = function(self) -- v 9.1.002

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

aObj.lodAddons.Altoholic_Achievements = function(self) -- v 9.1.002

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

aObj.lodAddons.Altoholic_Agenda = function(self) -- v 9.1.002

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

aObj.lodAddons.Altoholic_Grids = function(self) -- v 9.1.002

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
aObj.lodAddons.Altoholic_Options = function(self) -- v 9.1.002

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

