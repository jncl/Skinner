
function Skinner:Altoholic()

	self:keepFontStrings(AltoholicFrame)
	self:moveObject(AltoholicFrameName, nil, nil, "+", 10)
	self:moveObject(AltoholicFrameCloseButton, nil, nil, "+", 10)
	self:skinEditBox(AltoholicFrame_SearchEditBox, {9})
	self:skinEditBox(AltoholicFrame_MinLevel, {9})
	self:skinEditBox(AltoholicFrame_MaxLevel, {9})
	self:skinDropDown(RarityDropDownMenu)
	self:skinDropDown(SlotsDropDownMenu)
	self:applySkin(AltoholicFrame)
	-- Tabs
	for i = 1, 5 do
		local tabObj = _G["AltoholicFrameTab"..i]
		if i == 1 then
			self:moveObject(tabObj, nil, nil, "-", 4)
		else
			self:moveObject(tabObj, "+", 4, nil, nil)
		end
		self:keepRegions(tabObj, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		if self.db.profile.TexturedTab then
			self:applySkin(tabObj, nil, 0, 1)
			if i == 1 then self:setActiveTab(tabObj)
			else self:setInactiveTab(tabObj) end
		else self:applySkin(tabObj) end
	end
	if self.db.profile.TexturedTab then
		self:SecureHook(Altoholic, "Tab_OnClick", function()
			for i = 1, 5 do
				local tabObj = _G["AltoholicFrameTab"..i]
				if i == AltoholicFrame.selectedTab then self:setActiveTab(tabObj)
				else self:setInactiveTab(tabObj) end
			end
		end)
	end

-->>--	Other Frames
	for _, v in pairs({"Summary", "Auctions", "BagUsage", "Containers", "Equipment", "Mail", "Quests", "Recipes", "Reputations", "Search", "Skills"}) do
		local rcmObj = _G["AltoholicFrame"..v.."RightClickMenu"]
		local sfObj = _G["AltoholicFrame"..v.."ScrollFrame"]
		if rcmObj then self:skinDropDown(rcmObj) end
		self:removeRegions(sfObj)
		self:skinScrollBar(sfObj)
	end

-->>--	Tabbed Frames
	for i = 1, 3 do
		self:keepRegions(_G["AltoholicTabSummaryMenuItem"..i], {3, 4}) -- N.B. region 3 is the highlight, 4 is the text
		self:applySkin(_G["AltoholicTabSummaryMenuItem"..i])
	end
	self:skinDropDown(AltoholicTabCharacters_SelectRealm)
	self:skinDropDown(AltoholicTabCharacters_SelectChar)
	self:skinDropDown(AltoholicTabCharacters_View)
	self:removeRegions(AltoholicSearchMenuScrollFrame)
	self:skinScrollBar(AltoholicSearchMenuScrollFrame)
	self:skinEditBox(AltoholicTabSearch_MinLevel, {9})
	self:skinEditBox(AltoholicTabSearch_MaxLevel, {9})
	self:skinDropDown(AltoholicTabSearch_SelectRarity)
	self:skinDropDown(AltoholicTabSearch_SelectSlot)
	self:skinDropDown(AltoholicTabSearch_SelectLocation)
	for i = 1, 15 do
		self:keepRegions(_G["AltoholicTabSearchMenuItem"..i], {3, 4}) -- N.B. region 3 is the highlight, 4 is the text
		self:applySkin(_G["AltoholicTabSearchMenuItem"..i])
	end
	self:skinDropDown(AltoholicTabGuildBank_SelectGuild)
	for i = 1, 15 do
		self:keepRegions(_G["AltoholicTabOptionsMenuItem"..i], {3, 4}) -- N.B. region 3 is the highlight, 4 is the text
		self:applySkin(_G["AltoholicTabOptionsMenuItem"..i])
	end

-->>--	Tooltip
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then AltoTooltip:SetBackdrop(self.backdrop) end
		self:skinTooltip(AltoTooltip)
	end

end
