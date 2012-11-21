local aName, aObj = ...
if not aObj:isAddonEnabled("ProfessionTabs") then return end


local function skinTabs(obj)

	if obj:IsObjectType("CheckButton")
	and obj.name
	and obj.tooltip
	then
		aObj:removeRegions(obj, {1})
		aObj:addButtonBorder{obj=obj, sec=true}
	end

end

function aObj:ProfessionTabs_TSF()

	local owner = ATSWFrame or MRTSkillFrame or SkilletFrame or TradeSkillFrame
	-- skin ProfessionTabs on TradeSkill or similar frame
	for _, child in ipairs{owner:GetChildren()} do
		skinTabs(child)
	end

end

function aObj:ProfessionTabs_TF()

	-- skin TradeFrame buttons
	for _, child in ipairs{TradeFrame:GetChildren()} do
		skinTabs(child)
	end

end
