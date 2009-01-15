
function Skinner:GuildBankSearch()
	if not self.db.profile.GuildBankUI then return end
	
	self:moveObject(GBS.FilterButton, "-", 30, "+", 36)
	self:keepFontStrings(GBS)
	local gbsP = GBS.Pane
	self:moveObject(self:getRegion(gbsP, 1), "+", 6, "+", 2) -- title text
	self:moveObject(gbsP.ClearButton, "+", 4, "+", 2)
	self:getRegion(gbsP.CloseButton, 4):SetAlpha(0) -- hide close button background
	self:skinEditBox(gbsP.NameEditBox, {9})
	self:skinDropDown(gbsP.QualityMenu)
	self:skinEditBox(gbsP.ItemLevelMinEditBox, {9})
	self:skinEditBox(gbsP.ItemLevelMaxEditBox, {9})
	self:skinEditBox(gbsP.ReqLevelMaxEditBox, {9})
	self:skinEditBox(gbsP.ReqLevelMinEditBox, {9})
	self:applySkin(GBSCategorySection)
	self:skinDropDown(gbsP.TypeMenu)
	self:skinDropDown(gbsP.SubTypeMenu)
	self:skinDropDown(gbsP.SlotMenu)
	self:applySkin(GBS)
	-- hook this to move the tabs
	self:SecureHookScript(GBS, "OnShow", function(this)
		GuildBankTab1:ClearAllPoints();
		GuildBankTab1:SetPoint( "TOPLEFT", this, "TOPRIGHT", -2, -16 );
	end)

end
