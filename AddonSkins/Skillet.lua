
function Skinner:Skillet()
	if not self.db.profile.TradeSkillUI then return end

	self:SecureHook(Skillet, "ShowTradeSkillWindow", function()
		SkilletRankFrameBorder:Hide()
		self:glazeStatusBar(SkilletRankFrame, 0)
		self:skinDropDown{obj=SkilletRecipeGroupDropdown}
		self:skinDropDown{obj=SkilletSortDropdown}
		self:skinEditBox(SkilletFilterBox, {9})
		self:skinScrollBar{obj=SkilletSkillList, size=3}
		self:applySkin(SkilletSkillListParent)
		self:applySkin(SkilletReagentParent)
		self:skinEditBox(SkilletItemCountInputBox, {9})
		self:skinScrollBar{obj=SkilletQueueList, size=3}
		self:applySkin(SkilletQueueParent)
		self:addSkinFrame{obj=SkilletFrame, kfs=true}
		self:Unhook(Skillet, "ShowTradeSkillWindow")
	end)

-->>--	SkilletShoppingList
	self:SecureHook(SkilletShoppingList, "Show", function(this)
		self:skinScrollBar{obj=SkilletShoppingListList, size=3}
		self:applySkin(SkilletShoppingListParent)
		self:addSkinFrame{obj=SkilletShoppingList, kfs=true}
		self:Unhook(SkilletShoppingList, "Show")
	end)

-->>--	SkilletRecipeNotes Frame
	self:SecureHook(SkilletRecipeNotesFrame, "Show", function(this)
		self:skinScrollBar{obj=SkilletNotesList, size=3}
		self:applySkin(SkilletRecipeNotesFrame)
		self:Unhook(SkilletRecipeNotesFrame, "Show")
	end)
	self:SecureHook(Skillet, "RecipeNote_OnClick", function(this, button)
		self:skinEditBox{obj=self:getChild(button, 2), regs={9}} -- skin EditBox
		self:Unhook(Skillet, "RecipeNote_OnClick")
	end)
	
-->>--	Tooltip
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then SkilletTradeskillTooltip:SetBackdrop(self.backdrop) end
		self:SecureHookScript(SkilletTradeskillTooltip, "OnShow", function(this)
			self:skinTooltip(SkilletTradeskillTooltip)
		end)
	end

end
