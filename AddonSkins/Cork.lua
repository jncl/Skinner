local aName, aObj = ...
if not aObj:isAddonEnabled("Cork") then return end
local _G = _G

aObj.addonsToSkin.Cork = function(self) -- v 7.1.0.62-Beta

	-- anchor
	self.RegisterCallback("Cork", "UIParent_GetChildren", function(this, child)
		if child:IsObjectType("Button")
		and _G.Round(child:GetHeight()) == 24
		then
			self:addSkinFrame{obj=child, ft="a", kfs=true, nb=true, x1=-2}
			self.UnregisterCallback("Cork", "UIParent_GetChildren")
		end
	end)

	-- tooltip
	_G.C_Timer.After(0.1, function()
		self:add2Table(self.ttList, _G.Corkboard)
	end)

	-- register callback to indicate already skinned by tekKonfig
	self.RegisterCallback("Cork", "IOFPanel_Before_Skinning", function(this, panel)
		if panel.name ~= "Cork" then return end
		self.iofSkinnedPanels[panel] = true
		self.UnregisterCallback("Cork", "IOFPanel_Before_Skinning")
	end)

	-- register callback to skin Tabs (not handled by tekKonfig)
	self.RegisterCallback("Cork", "IOFPanel_After_Skinning", function(this, panel)
		if panel.name ~= "Cork" then return end
		for _, child in _G.ipairs{panel:GetChildren()} do
			if child:IsObjectType("Button")
			and child.OrigSetText
			then
				-- hide textures (changed in code)
				child.left:SetAlpha(0)
				child.right:SetAlpha(0)
				child.middle:SetAlpha(0)
				self:addSkinFrame{obj=child, ft="a", nb=true, noBdr=aObj.isTT, x1=6, y1=0, x2=-6, y2=-1}
				if self.isTT then
					child.sf.ignore = true
					if child:IsEnabled() then
						self:setInactiveTab(child.sf)
					else
						self:setActiveTab(child.sf)
					end
					self:secureHook(child.left, "SetTexture", function(this, tex)
						if self:hasTextInTexture(this, "InActiveTab", true) then
							self:setInactiveTab(this:GetParent().sf)
						else
							self:setActiveTab(this:GetParent().sf)
						end
					end)
				end
			end
		end
		self.UnregisterCallback("Cork", "IOFPanel_After_Skinning")
	end)

end
