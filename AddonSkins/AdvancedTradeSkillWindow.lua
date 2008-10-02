
function Skinner:AdvancedTradeSkillWindow()
	if not self.db.profile.TradeSkill then return end

	self:keepFontStrings(ATSWFrame)
	ATSWFrame:SetWidth(ATSWFrame:GetWidth() -30)
	ATSWFrame:SetHeight(ATSWFrame:GetHeight() -10)
	self:moveObject(ATSWFrameTitleText, nil, nil, "+", 8)
	self:moveObject(ATSWFrameCloseButton, "+", 28, "+", 8)
	self:keepFontStrings(ATSWRankFrame)
	self:keepFontStrings(ATSWRankFrameBorder)
	self:moveObject(ATSWRankFrame, "+", 4, "+", 5)
	self:glazeStatusBar(ATSWRankFrame, 0)
	self:keepFontStrings(ATSWListScrollFrame)
	self:skinScrollBar(ATSWListScrollFrame)
	self:keepFontStrings(ATSWExpandButtonFrame)
	self:keepFontStrings(ATSWInvSlotDropDown)
	self:keepFontStrings(ATSWSubClassDropDown)
	self:keepFontStrings(ATSWQueueScrollFrame)
	self:skinScrollBar(ATSWQueueScrollFrame)
	self:skinEditBox(ATSWInputBox)
	ATSWInputBox:SetWidth(ATSWInputBox:GetWidth() + 6)
	self:moveObject(ATSWInputBox, "-", 6, nil, nil)
	self:skinEditBox(ATSWFilterBox)
	self:applySkin(ATSWFrame)

	-- Reagent Frame
	self:keepFontStrings(ATSWReagentFrame)
	ATSWReagentFrame:SetWidth(ATSWReagentFrame:GetWidth() * self.FxMult + 20)
	ATSWReagentFrame:SetHeight(ATSWReagentFrame:GetHeight() * self.FyMult)
	self:moveObject(ATSWReagentFrameCloseButton, "+", 28, "+", 8)
	self:applySkin(ATSWReagentFrame)

	-- Options Frame
	ATSWOptionsFrame:SetWidth(ATSWOptionsFrame:GetWidth() * self.FxMult + 30)
	self:applySkin(ATSWOptionsFrame)

	-- Continue Frame
	self:applySkin(ATSWContinueFrame)

	-- Tooltips
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then ATSWTradeskillTooltip:SetBackdrop(self.backdrop) end
		self:HookScript(ATSWTradeskillTooltip, "OnShow", function(this)
			self.hooks[ATSWTradeskillTooltip].OnShow(this)
			self:skinTooltip(ATSWTradeskillTooltip)
		end)
	end

	-- AutoBuyButton Frame
	self:applySkin(ATSWAutoBuyButtonFrame)

	-- Shopping List Frame
	self:keepFontStrings(ATSWShoppingListFrame)
	ATSWShoppingListFrame:SetWidth(ATSWShoppingListFrame:GetWidth() * self.FxMult + 20)
	ATSWShoppingListFrame:SetHeight(ATSWShoppingListFrame:GetHeight() * self.FyMult)
	self:keepFontStrings(ATSWSLScrollFrame)
	self:skinScrollBar(ATSWSLScrollFrame)
	self:applySkin(ATSWShoppingListFrame)

	-- Custom Sorting Frame
	self:keepFontStrings(ATSWCSFrame)
	ATSWCSFrame:SetWidth(ATSWFrame:GetWidth())
	self:moveObject(ATSWCSFrameCloseButton, "+", 28, "+", 8)
	self:removeRegions(ATSWCSUListScrollFrame)
	self:skinScrollBar(ATSWCSUListScrollFrame)
	self:removeRegions(ATSWCSSListScrollFrame)
	self:skinScrollBar(ATSWCSSListScrollFrame)
	self:skinEditBox(ATSWCSNewCategoryBox)
	self:applySkin(ATSWCSFrame)
-->>--	All Reagent List Frame
	self:keepFontStrings(ATSWAllReagentListFrame)
	self:moveObject(ATSWAllReagentListFrameCloseButton, "+", 30, "-", 4)
	self:keepFontStrings(ATSWAllReagentListCharDropDown)
	self:applySkin(ATSWAllReagentListFrame)
-->>--	Scan Delay Frame
	self:keepFontStrings(ATSWScanDelayFrame)
	self:glazeStatusBar(ATSWScanDelayFrameBar, 0)
	self:applySkin(ATSWScanDelayFrame)

end
