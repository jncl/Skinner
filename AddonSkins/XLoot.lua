local aName, aObj = ...
if not aObj:isAddonEnabled("XLoot") then return end
local _G = _G

function aObj:XLoot()

	-- skin anchors
	self.RegisterCallback("Xloot", "UIParent_GetChildren", function(this, child)
		if child.hide
		and child.label
		then
			self:addSkinFrame{obj=child, nb=true}
		end
	end)

	-- skin frame
	if _G.XLootFrame then self:addSkinFrame{obj=_G.XLootFrame} end

end

