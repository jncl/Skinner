local _, aObj = ...
if not aObj:isAddonEnabled("Reputable") then return end
local _G = _G

aObj.addonsToSkin.Reputable = function(self) -- v 1.08-bcc

	local function skinFrame()
		local frame = _G.ReputableGUI
		-- Tabs (menuBTNs)
		aObj:skinObject("slider", {obj=frame.scrollFrameMenu.ScrollBar})
		aObj:skinObject("slider", {obj=frame.scrollFrameMain.ScrollBar})
		aObj:skinObject("frame", {obj=frame, ofs=1})
		if aObj.modBtns then
			 aObj:skinCloseButton{obj=frame.closeBTN}
			 aObj:skinStdButton{obj=frame.settingsBTN}
		end
		if aObj.modChkBtns then
			aObj:skinCheckButton{obj=frame.showCompletedQuests, ofs=-6}
			aObj:skinCheckButton{obj=frame.showExaltedDailies, ofs=-6}
		end
	end
	for name, button in _G.pairs(self.DBIcon.objects) do
		if name == "Reputable" then
			self:SecureHookScript(button, "OnClick", function(this, btn)
				if btn == "LeftButton" then
					skinFrame()
				end
				self:Unhook(this, "OnClick")
			end)
			break
		end
	end
	
	self.RegisterCallback("Reputable", "IOFPanel_Before_Skinning", function(this, panel)
		if panel.name ~= "Reputable" then return end
		self.iofSkinnedPanels[panel] = true

		self:skinObject("slider", {obj=panel.scrollFrame.ScrollBar})
		for _, child in _G.pairs{panel.scrollChild:GetChildren()} do
			if child:IsObjectType("CheckButton")
			and self.modChkBtns
			then
				self:skinCheckButton{obj=child, ofs=-6}
			elseif self:isDropDown(child) then
				self:skinObject("dropdown", {obj=child})
			end
		end
		
		self.UnregisterCallback("Reputable", "IOFPanel_Before_Skinning")
	end)
	
	-- tooltip
	_G.C_Timer.After(0.1, function()
		self:add2Table(self.ttList, _G.showRewardTooltip1)
		self:add2Table(self.ttList, _G.showRewardTooltip2)
	end)

end
