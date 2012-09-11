local aName, aObj = ...
if not aObj:isAddonEnabled("ProfessionTabs") then return end

function aObj:ProfessionTabs()

	print("ProfessionTabs loaded")

	-- skin TradeSkillFrame buttons
	for _, child in ipairs{TradeSkillFrame:GetChildren()} do
		if child:IsObjectType("CheckButton")
		and child.name
		and child.tooltip
		then
			self:removeRegions(child, {1})
			self:addButtonBorder{obj=child, sec=true}
		end
	end
	-- skin TradeFrame buttons
	for _, child in ipairs{TradeFrame:GetChildren()} do
		if child:IsObjectType("CheckButton")
		and child.name
		and child.tooltip
		then
			self:removeRegions(child, {1})
			self:addButtonBorder{obj=child, sec=true}
		end
	end

end
