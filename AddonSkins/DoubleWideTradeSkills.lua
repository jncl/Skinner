
function Skinner:DoubleWideTradeSkills()
	if not self.db.profile.TradeSkill then return end
	
	local function skinDWTS()
	
		Skinner:keepFontStrings(TradeSkillFrame)
		TradeSkillFrame:SetHeight(TradeSkillFrame:GetHeight() * Skinner.FyMult)
		Skinner:moveObject(TradeSkillFrameTitleText, nil, nil, "+", 12)
		Skinner:moveObject(TradeSkillFrameCloseButton, "+", 28, "+", 8)
		Skinner:moveObject(TradeSkillRankFrame, "-", 40, "+", 20)
		TradeSkillRankFrameBorder:SetAlpha(0)
		Skinner:glazeStatusBar(TradeSkillRankFrame, 0)
		Skinner:moveObject(TradeSkillFrameAvailableFilterCheckButton, "-", 38, "+", 12)
		Skinner:skinEditBox(TradeSkillFrameEditBox, {9})
		Skinner:removeRegions(TradeSkillExpandButtonFrame)
		Skinner:moveObject(TradeSkillExpandButtonFrame, "-", 6, "+", 12)
		Skinner:skinDropDown(TradeSkillSubClassDropDown)
		Skinner:skinDropDown(TradeSkillInvSlotDropDown)
		Skinner:moveObject(TradeSkillSkill1, "-", 6, "+", 12)
		Skinner:removeRegions(TradeSkillListScrollFrame)
		Skinner:moveObject(TradeSkillListScrollFrame, "+", 35, "+", 12)
		Skinner:skinScrollBar(TradeSkillListScrollFrame)
		Skinner:removeRegions(TradeSkillDetailScrollFrame)
		Skinner:moveObject(TradeSkillDetailScrollFrame, "+", 2, "+", 12)
		Skinner:skinScrollBar(TradeSkillDetailScrollFrame)
		Skinner:moveObject(TradeSkillInputBox, "-", 5, nil, nil)
		Skinner:skinEditBox(TradeSkillInputBox)
		Skinner:moveObject(TradeSkillCancelButton, "+", 26, "-", 70)
		Skinner:applySkin(TradeSkillFrame)
		
	end
	
	self:SecureHook("TradeSkillFrame_LoadUI", function()
		skinDWTS()
		self:Unhook("TradeSkillFrame_LoadUI")
	end)
	
end
