local aName, aObj = ...
if not aObj:isAddonEnabled("XLoot") then return end

function aObj:XLoot()

	-- skin anchors
	for _, child in pairs{UIParent:GetChildren()} do
		if child:GetName() == nil then
			if child:IsObjectType("Button") then
				local height, width = self:getInt(child:GetHeight()), self:getInt(child:GetWidth())
				if height == 20
				and width == 175
				then
					if child.close and child.close.parent == child then
						self:addSkinFrame{obj=child, nb=true, x2=3}
						child.close:SetSize(16, 18)
						self:skinButton{obj=child.close, cb=true}
					end
				end
			end
		end
	end
	
	-- skin frame
	if XLootFrame then self:addSkinFrame{obj=XLootFrame} end
	
end

