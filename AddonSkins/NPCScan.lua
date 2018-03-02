local aName, aObj = ...
if not aObj:isAddonEnabled("NPCScan") then return end
local _G = _G

aObj.addonsToSkin.NPCScan = function(self) -- v 7.3.5.3

	local function skinTargetButton()
		aObj.RegisterCallback("_NPCScan", "UIParent_GetChildren", function(this, child)
			if child.DismissButton
			and child.killedTextureFrame
			and not child.sf
			then
				-- aObj:Debug("Target Button found: [%s]", child)
				aObj:rmRegionsTex(child, {3, 4})
				child.DismissButton:Hide()
				aObj:addSkinFrame{obj=child, kfs=true, ft="a", nb=true, ofs=-8}
			end
		end)
		aObj:scanUIParentsChildren()
	end

	-- Register to know when Targeting buttons are used
	self:RegisterMessage("NPCScan_DetectedNPC", skinTargetButton)

end
