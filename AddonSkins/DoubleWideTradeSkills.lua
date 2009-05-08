
function Skinner:DoubleWideTradeSkills()
	if not self.db.profile.TradeSkillUI then return end
	
	local function skinDWTS()
	
		TradeSkillRankFrameBorder:SetAlpha(0)
		Skinner:glazeStatusBar(TradeSkillRankFrame, 0)
		Skinner:skinEditBox{obj=TradeSkillFrameEditBox, regs={9}}
		Skinner:removeRegions(TradeSkillExpandButtonFrame)
		Skinner:skinDropDown{obj=TradeSkillSubClassDropDown}
		Skinner:skinDropDown{obj=TradeSkillInvSlotDropDown}
		Skinner:skinScrollBar{obj=TradeSkillListScrollFrame}
		Skinner:skinScrollBar{obj=TradeSkillDetailScrollFrame}
		Skinner:skinEditBox{obj=TradeSkillInputBox}
		Skinner:addSkinFrame{obj=TradeSkillFrame, kfs=true, x1=10, y1=-12, x2=-32, y2=71}
		
	end
	
	self:SecureHook("TradeSkillFrame_LoadUI", function()
		skinDWTS()
		self:Unhook("TradeSkillFrame_LoadUI")
	end)
	
end
