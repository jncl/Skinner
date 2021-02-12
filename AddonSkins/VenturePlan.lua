local _, aObj = ...
if not aObj:isAddonEnabled("VenturePlan") then return end
local _G = _G

aObj.addonsToSkin.VenturePlan = function(self) -- v 4.08

	self.RegisterCallback("VenturePlan", "CovenantMissionFrame_Skinned", function(this)
		-- wait for frames to be created
		_G.C_Timer.After(0.1, function()
			-- MissionList
			local frame = self:getLastChild(_G.CovenantMissionFrame.MissionTab)
			frame.ResourceCounter:DisableDrawLayer("BACKGROUND")
			frame.ProgressCounter:DisableDrawLayer("BACKGROUND")
			frame.LogCounter:DisableDrawLayer("BACKGROUND")
			-- Missions
			for _, btn in _G.pairs(frame.MissionList.Missions) do
				btn.Description:SetTextColor(self.BT:GetRGB())
				for _, fs in _G.pairs{btn.statLine:GetRegions()} do
					fs:SetTextColor(self.BT:GetRGB())
				end
				btn.ExpireTime:GetFontString():SetTextColor(self.BT:GetRGB())
				self:removeRegions(btn.ProgressBar, {1, 2, 3, 4, 5, 6, 7, 8, 9})
				btn.ProgressBar.Fill:SetTexture(self.sbTexture)
				btn.ProgressBar.Fill:SetVertexColor(aObj.sbClr:GetRGBA())
				btn.ProgressBar.bg = btn.ProgressBar:CreateTexture(nil, "BACKGROUND", nil, -1)
				btn.ProgressBar.bg:SetTexture(self.sbTexture)
				btn.ProgressBar.bg:SetVertexColor(self.sbClr:GetRGBA())
				btn.ProgressBar.bg:SetAllPoints()
				self:removeRegions(btn, {1, 2, 4})
				self:skinObject("frame", {obj=btn, fb=true, y1=-22, clr="grey"})
				if self.modBtns then
					self:skinStdButton{obj=btn.ViewButton}
				end
				if self.modBtnBs then
					self:addButtonBorder{obj=btn.DoomRunButton, ofs=0, y2=-1}
				end
			end
			self:keepFontStrings(self:getChild(frame.MissionList, 1)) -- RaisedBorder frame
			self:skinObject("frame", {obj=frame.MissionList, kfs=true, fb=true, ofs=0, y1=5, y2=-4, clr="grey"})
			-- CopyBox
			frame.CopyBox.Intro:SetTextColor(self.BT:GetRGB())
			self:skinObject("editbox", {obj=frame.CopyBox.FirstInputBox})
			frame.CopyBox.FirstInputBoxLabel:SetTextColor(self.BT:GetRGB())
			self:skinObject("editbox", {obj=frame.CopyBox.SecondInputBox})
			frame.CopyBox.SecondInputBoxLabel:SetTextColor(self.BT:GetRGB())
			frame.CopyBox.VersionText:SetTextColor(self.BT:GetRGB())
			self:skinObject("frame", {obj=frame.CopyBox, kfs=true})
			if self.modBtns then
				self:skinStdButton{obj=frame.CopyBox.ResetButton}
				self:skinCloseButton{obj=frame.CopyBox.CloseButton2}
			end
			-- FollowerList
			frame = _G.CovenantMissionFrame.MissionTab.MissionPage.Board
			if self.modBtnBs then
				self:addButtonBorder{obj=self:getLastChild(frame), ofs=1} -- Cursed Adventuer's Guide
			end
			self:SecureHookScript(frame, "OnShow", function(this)
				local fList = self:getLastChild(_G.CovenantMissionFrame)
				local function skinFLB(btn)
					btn.PortraitR:SetTexture(nil)
					btn.RoleB:SetTexture(nil)
					btn.AbilitiesB[1]:SetTexture(nil)
					btn.AbilitiesB[2]:SetTexture(nil)
					btn.HealthFrameR:SetTexture(nil)
				end
				for _, btn in _G.pairs(fList.troops) do
					skinFLB(btn)
				end
				for _, btn in _G.pairs(fList.companions) do
					skinFLB(btn)
				end
				self:skinObject("frame", {obj=fList, kfs=true, fb=true, clr="sepia"})

				fList = nil
				self:Unhook(this, "OnShow")
			end)

			frame = nil
		end)

		self.UnregisterCallback("VenturePlan", "CovenantMissionFrame_Skinned")
	end)

end
