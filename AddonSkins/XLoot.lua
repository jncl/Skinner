local aName, aObj = ...
if not aObj:isAddonEnabled("XLoot") then return end
local _G = _G

function aObj:XLoot()

	-- skin anchors
	self.RegisterCallback("Xloot", "UIParent_GetChildren", function(this, child)
		if child:IsObjectType("Button")
		and child:GetName() == nil
		and self:getInt(child:GetWidth()) == 175
		and self:getInt(child:GetHeight()) == 20
		and child.close
		and child.close.parent == child
		then
			self:addSkinFrame{obj=child, nb=true, x2=3}
			child.close:SetSize(16, 18)
			self:skinButton{obj=child.close, cb=true}
		end
	end)

	-- skin frame
	if _G.XLootFrame then self:addSkinFrame{obj=_G.XLootFrame} end

end

