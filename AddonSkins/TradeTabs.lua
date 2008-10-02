
function Skinner:TradeTabs()
	if not self.db.profile.TradeSkill then return end

	local function skinTradeTabs(frame, xAdj, xOfs)

--		Skinner:Debug("skinTradeTabs: [%s, %s, %s]", frame:GetName(), xAdj, xOfs)

		local prev

		for i = 1, select("#", frame:GetChildren()) do
			local obj = select(i, frame:GetChildren())
			if obj:GetName() == nil and obj:IsObjectType("CheckButton") and obj.hideFrame then
				Skinner:removeRegions(obj, {1}) -- N.B. other regions are icon and highlight
				if not prev then Skinner:moveObject(obj, xAdj, xOfs, "+", 14)
				else Skinner:moveObject(obj, nil, nil, "+", 8, prev) end
				prev = obj
			end
			frame.ttskinned = true
		end

	end

	local frame, xAdj, xOfs

	if IsAddOnLoaded("Skillet") and not SkilletFrame.ttskinned then
		frame, xAdj, xOfs = SkilletFrame, "-", 2
		skinTradeTabs(frame, xAdj, xOfs)
	else
		xAdj, xOfs = "+", 30
		if TradeSkillFrame and not TradeSkillFrame.ttskinned then
			skinTradeTabs(TradeSkillFrame, xAdj, xOfs)
		end
		if CraftFrame and not CraftFrame.ttskinned then
			skinTradeTabs(CraftFrame, xAdj, xOfs)
		end
	end

end
