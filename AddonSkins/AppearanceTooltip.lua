local aName, aObj = ...
if not aObj:isAddonEnabled("AppearanceTooltip") then return end
local _G = _G

aObj.addonsToSkin.AppearanceTooltip = function(self) -- v18

	-- tooltip
	_G.AppearanceTooltipTooltip:DisableDrawLayer("BACKGROUND")
	_G.C_Timer.After(0.1, function()
		self:add2Table(self.ttList, _G.AppearanceTooltipTooltip)
	end)

	-- config
	self.RegisterCallback("AppearanceTooltip", "IOFPanel_After_Skinning", function(this, panel)
		if panel.name ~= "AppearanceTooltip" then return end
		for _, child in ipairs{panel:GetChildren()} do
			if child:IsObjectType("Frame") then
				child:SetBackdrop(nil)
				for _, grandchild in ipairs{child:GetChildren()} do
					if aObj:isDropDown(grandchild) then
						-- apply specific adjustment if required
						aObj:skinDropDown{obj=grandchild}
					elseif grandchild:IsObjectType("CheckButton") then
						aObj:skinCheckButton{obj=grandchild}
					end
				end
			end
		end
		self.UnregisterCallback("AppearanceTooltip", "IOFPanel_After_Skinning")
	end)

end
