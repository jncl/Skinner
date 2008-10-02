
function Skinner:RecipeBook()

-->>-- Main Frame
	self:keepFontStrings(RBUI_MainFrame)
	self:moveObject(RBUI_MainFrame_TitleText, nil, nil, "-", 6)
	self:moveObject(RBUI_MainFrameCloseButton, "+", 6, "+", 6)
	self:applySkin(RBUI_MainFrame, true)
	-- Tabs
	for i = 1, 5 do
		local tabName = _G["RBUI_MainFrameTab"..i]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		if i == 1 then self:moveObject(tabName, "+", 10, "-", 2)
		else self:moveObject(tabName, "+", 10, nil, nil) end
		if self.db.profile.TexturedTab then self:applySkin(tabName, nil, 0)
		else self:applySkin(tabName) end
	end

	if self.db.profile.TexturedTab then
		for i = 1, 5 do
			local tabName = _G["RBUI_MainFrameTab"..i]
			self:setInactiveTab(tabName)
		end
		self:setActiveTab(RBUI_MainFrameTab1)
		self:SecureHook(RBUI, "MainFrame_OnUpdate", function(this)
			for i = 1, 5 do
				local tabName = _G["RBUI_MainFrameTab"..i]
				if i == RBUI_MainFrame.selectedTab then self:setActiveTab(tabName)
				else self:setInactiveTab(tabName) end
			end
		end)
	end

-->>-- Search Frame (Tab 1)
	self:skinEditBox(RBUI_SearchFrame_EDIT_SearchFor, {9})
	self:keepFontStrings(RBUI_SearchFrame_ResultsScrollFrame)
	self:skinScrollBar(RBUI_SearchFrame_ResultsScrollFrame)
-->>-- Skill Frame (Tab 2)
	self:skinEditBox(RBUI_SkillFrame_EDIT_Filter, {9})
	self:keepFontStrings(RBUI_SkillFrame_DD_SortType)
	self:keepFontStrings(RBUI_SkillFrame_ScrollFrame)
	self:skinScrollBar(RBUI_SkillFrame_ScrollFrame)
-->>-- Skill Tracking Sub Frame
	self:keepFontStrings(RBSkillTrackFrame)
	self:applySkin(RBSkillTrackFrame)
-->>-- Sharing Frame (Tab 3)
	self:keepFontStrings(RBUI_SharingFrame_WhoScrollFrame)
	self:skinScrollBar(RBUI_SharingFrame_WhoScrollFrame)
	self:skinFFToggleTabs("RBUI_SharingFrameTab", 3)
-->>-- Banking Frame (Tab 4)
	self:keepFontStrings(RBUI_BankingFrame_ItemScrollFrame)
	self:skinScrollBar(RBUI_BankingFrame_ItemScrollFrame)
-->>-- Options Frame (Tab 5)

-->>-- Tooltips
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then
			RecipeBookInfoTooltip:SetBackdrop(self.backdrop)
			RecipeBookUITooltip:SetBackdrop(self.backdrop)
		end
		self:skinTooltip(RecipeBookInfoTooltip)
		self:skinTooltip(RecipeBookUITooltip)
	end

end
