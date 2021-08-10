local _, aObj = ...
if not aObj:isAddonEnabled("VenturePlan") then return end
local _G = _G

aObj.addonsToSkin.VenturePlan = function(self) -- v 4.16a

	self.RegisterCallback("VenturePlan", "CovenantMissionFrame_Skinned", function(this)
		-- wait for frames to be created
		_G.C_Timer.After(0.1, function()
			-- MissionList
			local frame = self:getLastChild(_G.CovenantMissionFrame.MissionTab)
			self:getChild(frame, 1):DisableDrawLayer("BACKGROUND") -- scrollframe
			self:getChild(frame, 3):DisableDrawLayer("BACKGROUND") -- resource counter
			self:getChild(frame, 4):DisableDrawLayer("BACKGROUND") -- companion counter
			self:getChild(frame, 5):DisableDrawLayer("BACKGROUND") -- progress counter
			self:getChild(frame, 7):DisableDrawLayer("BACKGROUND") -- ? button
			if self.modBtns then
				self:skinStdButton{obj=self:getChild(frame, 6)} -- send tentative parties button
			end
			-- Missions
			self:skinObject("frame", {obj=self:getChild(self:getChild(frame, 1), 1), kfs=true, fb=true, clr="sepia"})
			local mFrame = self:getChild(frame, 1):GetScrollChild()
			for _, btn in _G.ipairs{mFrame:GetChildren()} do
				-- skinMissionBtn(btn)
				self:getRegion(btn, 5):SetTextColor(self.BT:GetRGB()) -- Description
				self:getChild(btn, 1):GetFontString():SetTextColor(self.BT:GetRGB()) -- ExpireTime
				for _, fs in _G.pairs{self:getChild(btn, 4):GetRegions()} do -- statLine
					fs:SetTextColor(self.BT:GetRGB())
				end
				local pBar = self:getChild(btn, 5) -- ProgressBar
				self:removeRegions(pBar, {1, 2, 3, 4, 5, 6, 7, 8, 9})
				pBar.Fill:SetTexture(self.sbTexture)
				pBar.Fill:SetVertexColor(self.sbClr:GetRGBA())
				pBar.bg = pBar:CreateTexture(nil, "BACKGROUND", nil, -1)
				pBar.bg:SetTexture(self.sbTexture)
				pBar.bg:SetVertexColor(self.sbClr:GetRGBA())
				pBar.bg:SetAllPoints()
				pBar = nil
				self:removeRegions(self:getChild(btn, 9), {2, 4, 6, 8, 10}) -- Board Group Ring textures
				self:removeRegions(btn, {1, 2, 4})
				self:skinObject("frame", {obj=btn, fb=true, y1=-22, clr="grey"})
				if self.modBtns then
					self:skinStdButton{obj=self:getChild(btn, 6)} -- ViewButton
					self:skinCloseButton{obj=self:getChild(btn, 8), noSkin=true} -- TentativeClear
				end
				if self.modBtnBs then
					self:addButtonBorder{obj=self:getChild(btn, 7), ofs=0, y2=-1} -- DoomRunButton
				end
			end
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
					aObj:getRegion(f2, 9):SetTexture(nil) -- AbilitiesB[1]
					aObj:getRegion(f2, 11):SetTexture(nil) -- AbilitiesB[2]
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
