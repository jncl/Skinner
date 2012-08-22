if not Skinner:isAddonEnabled("ProfessionTabs") then return end

function Skinner:ProfessionTabs()

	self:RawHook(ProfessionTabs, "CreateTab", function(this, ...)
		local tab = self.hooks[this].CreateTab(this, ...)
		self:removeRegions(tab, {1})
		-- fix for misplacement of button on TradeSkillFrame
		if tab:GetParent() == TradeSkillFrame
		or tab:GetParent() == TradeFrame
		and ceil(select(4, tab:GetPoint())) == -32
		then
			self:moveObject{obj=tab, x=32}
		end
		self:addButtonBorder{obj=tab, sec=true}
		return tab
	end, true)

end
