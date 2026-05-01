local _, aObj = ...
if not aObj:isAddonEnabled("RCPT") then return end
local _G = _G

aObj.addonsToSkin.RCPT = function(self) -- v 2.0.0

	self.RegisterCallback("RCPT", "SettingsPanel_DisplayCategory", function(_, panel)
		if panel.name ~= "RCPT" then return end
		self.spSkinnedPanels[panel] = true

		local function skinKids(frame)
			for _, child in _G.ipairs_reverse{frame:GetChildren()} do
				if child:IsObjectType("CheckButton")
				and aObj.modChkBtns
				then
					aObj:skinCheckButton{obj=child}
				elseif aObj:isDropDown(child) then
					aObj:skinObject("dropdown", {obj=child})
				elseif child:IsObjectType("EditBox") then
					aObj:skinObject("editbox", {obj=child--[[, y1=-4, y2=4]]})
				elseif child:IsObjectType("Slider") then
					aObj:skinObject("slider", {obj=child})
				elseif child:IsObjectType("Button")
				and aObj.modBtnBs
				then
					aObj:skinStdButton{obj=child}
				elseif child:IsObjectType("Frame") then
					skinKids(child)
				end
			end
		end

		skinKids(_G.RCPTOptionsPanelScrollChild)

		self.UnregisterCallback("RCPT", "SettingsPanel_DisplayCategory")
	end)

end

aObj.lodAddons.RCPT_PullTimers = function(self) -- v 2.0.0

	self:add2Table(self.createFrames, {func = function(fObj)
	    _G.RunNextFrame(function()
			self:skinObject("frame", {obj=fObj, kfs=true})
			if self.modBtns then
				self:skinStdButton{obj=fObj.btnDefer}
				self:skinStdButton{obj=fObj.btnRestart}
				self:skinStdButton{obj=fObj.btnSkip}
				self:skinStdButton{obj=fObj.btnStop}
			end
	    end)
	end}, "RCPTPullStatusFrame")

end

aObj.lodAddons.RCPT_TalentCheck = function(self) -- v 2.0.0

	self:add2Table(self.createFrames, {func = function(fObj)
	    _G.RunNextFrame(function()
			self:skinObject("frame", {obj=fObj, kfs=true})
			if self.modBtns then
				self:skinStdButton{obj=fObj.changeBtn}
				self:skinStdButton{obj=fObj.readyBtn}
				self:skinStdButton{obj=fObj.notReadyBtn}
				self:skinStdButton{obj=fObj.collapseBtn}
				self:moveObject{obj=fObj.collapseBtn, y=3}
			end
	    end)
	end}, "RCPTReadyOverlay")

	self:add2Table(self.createFrames, {func = function(fObj)
	    _G.RunNextFrame(function()
			self:skinObject("frame", {obj=fObj, kfs=true})
	    end)
	end}, "RCPTReadyMiniOverlay")

	self:SecureHookScript(_G.RCPTTalentCheckFrame, "OnShow", function(this)
		self:skinObject("frame", {obj=this, kfs=true})

		self:Unhook(this, "OnShow")
	end)
	self:checkShown(_G.RCPTTalentCheckFrame)

end
