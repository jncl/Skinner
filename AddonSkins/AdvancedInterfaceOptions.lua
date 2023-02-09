local _, aObj = ...
if not aObj:isAddonEnabled("AdvancedInterfaceOptions") then return end

aObj.addonsToSkin.AdvancedInterfaceOptions = function(self) -- v 1.8.4

	local cnt = 0
	self.RegisterCallback("AdvancedInterfaceOptions", "IOFPanel_Before_Skinning", function(_, panel)
		if panel.name ~= "AdvancedInterfaceOptions"
		and panel.parent ~= "AdvancedInterfaceOptions"
		or self.iofSkinnedPanels[panel]
		then
			return
		end

		cnt = cnt + 1
		if panel.name == "AdvancedInterfaceOptions" then
			self.iofDD["AIOQuestSorting"] = 109
			self.iofDD["AIOActionCamMode"] = 109
		elseif panel.name == "Floating Combat Text" then
			self.iofDD["AIOfctFloatMode"] = 109
		elseif panel.name == "CVar Browser" then
			local bFrame = self:getChild(panel, 2)
			self:keepFontStrings(bFrame)
			self:removeInset(bFrame)
			self:skinObject("slider", {obj=bFrame.scrollbar})
		end

		if cnt == 6 then
			self.UnregisterCallback("AdvancedInterfaceOptions", "IOFPanel_Before_Skinning")
		end
	end)

end
