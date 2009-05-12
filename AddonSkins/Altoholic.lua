
function Skinner:Altoholic()

	self:keepFontStrings(AltoholicFrame)
	self:moveObject(AltoholicFrameName, nil, nil, "+", 10)
	self:moveObject(AltoholicFrameCloseButton, nil, nil, "+", 10)
	self:skinEditBox(AltoholicFrame_SearchEditBox, {9})
	self:applySkin(AltoholicFrame)
	
-->>-- Message Box
	self:applySkin(AltoMsgBox)

-->>--	Other Frames
	for _, v in pairs({"Activity", "Auctions", "BagUsage", "Containers", "Equipment", "GuildMembers", "GuildProfessions", "GuildBankTabs", "Mail", "Quests", "Recipes", "Reputations", "Search", "Skills", "Summary"}) do
		local rcmObj = _G["AltoholicFrame"..v.."RightClickMenu"]
		local sfObj = _G["AltoholicFrame"..v.."ScrollFrame"]
		if rcmObj then self:skinDropDown(rcmObj) end
		self:removeRegions(sfObj)
		self:skinScrollBar(sfObj)
	end

-->>--	Tabbed Frames
	local obj
	-- Summary tab
	self:skinDropDown(AltoholicTabSummary_SelectLocation)
	for i = 1, 7 do -- menu items
		obj = _G["AltoholicTabSummaryMenuItem"..i]
		self:keepRegions(obj, {3, 4}) -- N.B. region 3 is the highlight, 4 is the text
		self:applySkin(obj)
	end
	for i = 1, 8 do -- sort headers
		obj = _G["AltoholicTabSummary_Sort"..i]
		if i == 1 then self:moveObject(obj, nil, nil, "+", 6) end
		obj:SetHeight(obj:GetHeight() + 3)
		self:keepRegions(obj, {4, 5, 6}) -- N.B. region 6 is the highlight, 4 is the text & 5 is the arrow
		self:applySkin(obj)
	end
	-- Characters tab
	self:skinDropDown(AltoholicTabCharacters_SelectRealm)
	self:skinDropDown(AltoholicTabCharacters_SelectChar)
	for i = 1, 4 do -- sort headers
		obj = _G["AltoholicTabCharacters_Sort"..i]
		if i == 1 then self:moveObject(obj, nil, nil, "+", 6) end
		obj:SetHeight(obj:GetHeight() + 3)
		self:keepRegions(obj, {4, 5, 6}) -- N.B. region 6 is the highlight, 4 is the text & 5 is the arrow
		self:applySkin(obj)
	end
	-- Container View
	self:skinDropDown(AltoholicFrameContainers_SelectContainerView)
	self:moveObject(AltoholicFrameContainers_SelectContainerView, nil, nil, "+", 8)
	self:skinDropDown(AltoholicFrameContainers_SelectRarity)
	-- Companions/Mounts View
	self:skinDropDown(AltoholicFramePets_SelectPetView)
	self:moveObject(AltoholicFramePets_SelectPetView, nil, nil, "+", 8)
	AltoholicFramePetsNormal_ModelFrameRotateLeftButton:Hide()
	AltoholicFramePetsNormal_ModelFrameRotateRightButton:Hide()
	self:makeMFRotatable(AltoholicFramePetsNormal_ModelFrame)
	-- Search Tab
	self:removeRegions(AltoholicSearchMenuScrollFrame)
	self:skinScrollBar(AltoholicSearchMenuScrollFrame)
	self:skinEditBox(AltoholicTabSearch_MinLevel, {9})
	self:skinEditBox(AltoholicTabSearch_MaxLevel, {9})
	self:skinDropDown(AltoholicTabSearch_SelectRarity)
	self:moveObject(AltoholicTabSearch_SelectRarity, nil, nil, "+", 3)
	self:skinDropDown(AltoholicTabSearch_SelectSlot)
	self:moveObject(AltoholicTabSearch_SelectSlot, nil, nil, "+", 3)
	self:skinDropDown(AltoholicTabSearch_SelectLocation)
	self:moveObject(AltoholicTabSearch_SelectLocation, nil, nil, "+", 3)
	for i = 1, 15 do
		obj = _G["AltoholicTabSearchMenuItem"..i]
		self:keepRegions(obj, {3, 4}) -- N.B. region 3 is the highlight, 4 is the text
		self:applySkin(obj)
	end
	for i = 1, 8 do
		obj = _G["AltoholicTabSearch_Sort"..i]
		if i == 1 then self:moveObject(obj, nil, nil, "+", 4) end
		obj:SetHeight(obj:GetHeight() + 2)
		self:keepRegions(obj, {4, 5, 6}) -- N.B. region 6 is the highlight, 4 is the text & 5 is the arrow
		self:applySkin(obj)
	end
	-- GuildBank tab
	self:skinDropDown(AltoholicTabGuildBank_SelectGuild)
	self:moveObject(AltoholicTabGuildBank_SelectGuild, nil, nil, "+", 8)
	for i = 1, 6 do
		obj = _G["AltoholicTabGuildBankMenuItem"..i]
		self:keepRegions(obj , {3, 4}) -- N.B. region 3 is the highlight, 4 is the text
		self:applySkin(obj)
	end
	-- Achievements tab
	self:removeRegions(AltoholicFrameAchievementsScrollFrame)
	self:skinScrollBar(AltoholicFrameAchievementsScrollFrame)
	self:removeRegions(AltoholicAchievementsMenuScrollFrame)
	self:skinScrollBar(AltoholicAchievementsMenuScrollFrame)
	for i = 1, 15 do
		obj = _G["AltoholicTabAchievementsMenuItem"..i]
		self:keepRegions(obj , {3, 4}) -- N.B. region 3 is the highlight, 4 is the text
		self:applySkin(obj)
	end
	-- Options tab
	for i = 1, 5 do
		obj = _G["AltoholicTabOptionsMenuItem"..i]
		self:keepRegions(obj , {3, 4}) -- N.B. region 3 is the highlight, 4 is the text
		self:applySkin(obj)
	end

-->>-- Tabs
	local numTabs = 6
	for i = 1, numTabs do
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
		self:SecureHook(Altoholic.Tabs, "OnClick", function(this, ...)
			for i = 1, numTabs do
				local tabObj = _G["AltoholicFrameTab"..i]
				if i == AltoholicFrame.selectedTab then self:setActiveTab(tabObj)
				else self:setInactiveTab(tabObj) end
			end
		end)
	end

-->>--	Tooltip
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then AltoTooltip:SetBackdrop(self.backdrop) end
		self:SecureHookScript(AltoTooltip, "OnShow", function(this)
			self:skinTooltip(AltoTooltip)
		end)
	end

end
