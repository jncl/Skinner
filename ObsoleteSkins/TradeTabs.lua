if not Skinner:isAddonEnabled("TradeTabs") then return end

function Skinner:TradeTabs() -- LoD
	if not self.db.profile.TradeSkillUI then return end

	local function skinTradeTabs(frame)

		for _, child in ipairs{frame:GetChildren()} do
			if child:GetName() == nil and child:IsObjectType("CheckButton") then
				Skinner:removeRegions(child, {1}) -- N.B. other regions are icon and highlight
			end
		end

	end

	if IsAddOnLoaded("Skillet") then
		skinTradeTabs(SkilletFrame)
	else
		skinTradeTabs(TradeSkillFrame)
	end

end
