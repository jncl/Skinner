local _, aObj = ...
if not aObj:isAddonEnabled("VenturePlan") then return end
local _G = _G

aObj.addonsToSkin.VenturePlan = function(self) -- v 4.12a

	local function skinMissionBtn(btn)
		aObj:getRegion(btn, 5):SetTextColor(aObj.BT:GetRGB()) -- Description
		for _, fs in _G.pairs{aObj:getChild(btn, 4):GetRegions()} do -- stats
			fs:SetTextColor(aObj.BT:GetRGB())
		end
		aObj:getChild(btn, 1):GetFontString():SetTextColor(aObj.BT:GetRGB()) -- expiretime
		local pBar = aObj:getChild(btn, 5)
		aObj:removeRegions(pBar, {1, 2, 3, 4, 5, 6, 7, 8, 9})
		pBar.Fill:SetTexture(aObj.sbTexture)
		pBar.Fill:SetVertexColor(aObj.sbClr:GetRGBA())
		pBar.bg = pBar:CreateTexture(nil, "BACKGROUND", nil, -1)
		pBar.bg:SetTexture(aObj.sbTexture)
		pBar.bg:SetVertexColor(aObj.sbClr:GetRGBA())
		pBar.bg:SetAllPoints()
		pBar = nil
		aObj:removeRegions(btn, {1, 2, 4})
		aObj:skinObject("frame", {obj=btn, fb=true, y1=-22, clr="grey"})
		if aObj.modBtns then
			aObj:skinStdButton{obj=aObj:getChild(btn, 6)}
		end
		if aObj.modBtnBs then
			aObj:addButtonBorder{obj=aObj:getChild(btn, 8), ofs=0, y2=-1} -- doom button
		end
	end
	self.RegisterCallback("VenturePlan", "CovenantMissionFrame_Skinned", function(this)
		-- wait for frames to be created
		_G.C_Timer.After(0.1, function()
			-- MissionList
			local frame = self:getLastChild(_G.CovenantMissionFrame.MissionTab)
			self:getChild(frame, 1):DisableDrawLayer("BACKGROUND") -- scrollframe
			self:getChild(frame, 4):DisableDrawLayer("BACKGROUND")
			self:getChild(frame, 5):DisableDrawLayer("BACKGROUND")
			self:getChild(frame, 6):DisableDrawLayer("BACKGROUND")
			self:getChild(frame, 7):DisableDrawLayer("BACKGROUND")
			if self.modBtns then
				self:skinStdButton{obj=self:getChild(frame, 8)}
			end
			-- Missions
			self:skinObject("frame", {obj=self:getChild(self:getChild(frame, 1), 1), kfs=true, fb=true, clr="sepia"})
			local mFrame = self:getChild(frame, 1):GetScrollChild()
			for _, btn in _G.ipairs{mFrame:GetChildren()} do
				skinMissionBtn(btn)
			end
			-- CopyBox
			local cBox = self:getChild(frame, 3)
			cBox.Intro:SetTextColor(self.BT:GetRGB())
			self:skinObject("editbox", {obj=cBox.FirstInputBox})
			cBox.FirstInputBoxLabel:SetTextColor(self.BT:GetRGB())
			self:skinObject("editbox", {obj=cBox.SecondInputBox})
			cBox.SecondInputBoxLabel:SetTextColor(self.BT:GetRGB())
			cBox.VersionText:SetTextColor(self.BT:GetRGB())
			self:skinObject("frame", {obj=cBox, kfs=true})
			if self.modBtns then
				self:skinStdButton{obj=cBox.ResetButton}
				self:skinCloseButton{obj=cBox.CloseButton2}
			end
			cBox = nil
			-- FollowerList
			frame = _G.CovenantMissionFrame.MissionTab.MissionPage.Board
			if self.modBtnBs then
				self:addButtonBorder{obj=self:getPenultimateChild(frame), ofs=1} -- Cursed Adventurer's Guide
				self:addButtonBorder{obj=self:getLastChild(frame), ofs=1} -- Cursed Tactical Guide
			end
			self:SecureHookScript(frame, "OnShow", function(this)
				local fList = self:getLastChild(_G.CovenantMissionFrame)
				local function skinFLB(btn)
					local f2 = aObj:getLastChild(btn)
					aObj:getRegion(btn, 1):SetTexture(nil) -- PortraitR
					aObj:getRegion(f2, 5):SetTexture(nil) -- HealthFrameR
					aObj:getRegion(f2, 7):SetTexture(nil) -- RoleB
					aObj:getRegion(f2, 8):SetTexture(nil) -- AbilitiesB[1]
					aObj:getRegion(f2, 10):SetTexture(nil) -- AbilitiesB[2]
				end
				-- troops
				skinFLB(self:getChild(fList, 1))
				skinFLB(self:getChild(fList, 2))
				-- companions
				for i = 4, 20 do
					skinFLB(self:getChild(fList, i))
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
