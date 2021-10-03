local _, aObj = ...
if not aObj:isAddonEnabled("AdvancedInterfaceOptions") then return end
local _G = _G

aObj.addonsToSkin.AdvancedInterfaceOptions = function(self) -- v 1.6.0

	local cnt = 0
	self.RegisterMessage("AdvancedInterfaceOptions", "IOFPanel_Before_Skinning", function(_, panel)
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
			self:removeNineSlice(bFrame.NineSlice)
			self:skinObject("slider", {obj=self:getChild(bFrame, 3)})
		end

		if cnt == 6 then
			self.UnregisterMessage("AdvancedInterfaceOptions", "IOFPanel_Before_Skinning")
		end
	end)

end
