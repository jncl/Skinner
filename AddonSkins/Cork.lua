local _, aObj = ...
if not aObj:isAddonEnabled("Cork") then return end
local _G = _G

aObj.addonsToSkin.Cork = function(self) -- v 7.1.0.62-Beta

	-- tooltip
	_G.C_Timer.After(0.1, function()
		self.ttHook[_G.Corkboard] = true
		self:add2Table(self.ttList, _G.Corkboard)
	end)

	-- anchor
	self.RegisterCallback("Cork", "UIParent_GetChildren", function(_, child)
		if child:IsObjectType("Button")
		and _G.Round(child:GetHeight()) == 24
		then
			self:skinObject("frame", {obj=child, kfs=true})
			self.UnregisterCallback("Cork", "UIParent_GetChildren")
		end
	end)

	-- config
	self.RegisterCallback("Cork", "IOFPanel_Before_Skinning", function(_, panel)
		if panel.name ~= "Cork" then return end
		self.iofSkinnedPanels[panel] = true

		-- find tab buttons
		_G.CorkFrame.Tabs = {} -- store on Button
		for _, child in _G.ipairs{panel:GetChildren()} do
			if child:IsObjectType("Button") then
				if child.OrigSetText then
					aObj:add2Table(_G.CorkFrame.Tabs, child)
				elseif _G.Round(child:GetHeight()) < 20 then
					child:SetHeight(20)
				end
			end
		end
		self:skinObject("tabs", {obj=_G.CorkFrame, tabs=_G.CorkFrame.Tabs, lod=true, offsets={x1=6, y1=0, x2=-6, y2=0}, regions={5}, track=false, func=aObj.isTT and function(tObj)
			aObj:SecureHookScript(tObj, "OnClick", function(this)
				for _, tab in _G.pairs(_G.CorkFrame.Tabs) do
					if tab == this then
						aObj:setActiveTab(tab.sf)
					else
						aObj:setInactiveTab(tab.sf)
					end
				end
			end)
		end})

		self.UnregisterCallback("Cork", "IOFPanel_Before_Skinning")
	end)

end
