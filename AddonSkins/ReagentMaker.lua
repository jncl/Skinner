local aName, aObj = ...
if not aObj:isAddonEnabled("ReagentMaker") then return end

function aObj:ReagentMaker()

	if self.db.profile.Tooltips.skin then
		self:add2Table(self.ttList, "ReagentMaker_tooltipRecipe")
	end

end
