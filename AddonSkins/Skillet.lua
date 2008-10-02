
function Skinner:Skillet()
	if not self.db.profile.TradeSkill and self.db.profile.CraftFrame then return end

	self:SecureHook(Skillet, "ShowTradeSkillWindow", function()
		self:keepFontStrings(SkilletFrame)
		SkilletRankFrameBorder:Hide()
		self:glazeStatusBar(SkilletRankFrame, 0)
		self:applySkin(SkilletSkillListParent)
		self:keepFontStrings(SkilletSkillList)
		self:keepFontStrings(SkilletSortDropdown)
		self:skinScrollBar(SkilletSkillList)
		self:skinEditBox(SkilletFilterBox, {9})
		self:applySkin(SkilletReagentParent)
		self:skinEditBox(SkilletItemCountInputBox, {9})
		self:applySkin(SkilletQueueParent)
		self:applySkin(SkilletFrame)
		self:Unhook(Skillet, "ShowTradeSkillWindow")
	end)

-->>--	Move the Buy Button
	self:SecureHook(SkilletMerchantBuyFrame, "Show", function(this)
		self:moveObject(SkilletMerchantBuyFrame, "-", 40, "+", 14)
	end)

-->>--	SkilletShoppingList
	self:SecureHook(SkilletShoppingList, "Show", function(this)
		self:removeRegions(SkilletShoppingList, {1, 2})
		self:keepFontStrings(SkilletShoppingListList)
		self:skinScrollBar(SkilletShoppingListList)
		self:applySkin(SkilletShoppingList)
		self:applySkin(SkilletShoppingListParent)
		self:Unhook(SkilletShoppingList, "Show")
	end)

-->>--	SkilletRecipeNotes Frame
	self:SecureHook(SkilletRecipeNotesFrame, "Show", function(this)
		self:applySkin(SkilletRecipeNotesFrame)
		self:Unhook(SkilletRecipeNotesFrame, "Show")
	end)

-->>--	Tooltip
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then SkilletTradeskillTooltip:SetBackdrop(self.backdrop) end
		self:HookScript(SkilletTradeskillTooltip, "OnShow", function(this)
			self.hooks[SkilletTradeskillTooltip].OnShow(this)
			self:skinTooltip(SkilletTradeskillTooltip)
		end)
	end

end
