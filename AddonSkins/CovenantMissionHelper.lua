local _, aObj = ...
if not aObj:isAddonEnabled("CovenantMissionHelper") then return end
local _G = _G

aObj.addonsToSkin.CovenantMissionHelper = function(self) -- v 0.1

	self:SecureHook(_G.MissionHelper, "createMissionHelperFrame", function(this)
		local mainFrame = _G.MissionHelperFrame
		self:keepFontStrings(mainFrame.RaisedFrameEdges)
		self:skinObject("frame", {obj=mainFrame.missionHeader, kfs=true, fb=true, clr="grey"})
		mainFrame.resultHeader.BaseFrameBackground:SetTexture(nil)
		self:keepFontStrings(mainFrame.resultInfo.RaisedFrameEdges)
		self:skinObject("frame", {obj=mainFrame.resultInfo, kfs=true, fb=true, y2=-6, clr="grey"})
		self:keepFontStrings(mainFrame.combatLogFrame.RaisedFrameEdges)
		self:skinObject("frame", {obj=mainFrame.combatLogFrame, kfs=true, fb=true, y2=-6, clr="grey"})
		self:skinObject("slider", {obj=mainFrame.combatLogFrame.CombatLogMessageFrame.ScrollBar, x1=-1, x2=0.5, y1=5, y2=-10})
		mainFrame.buttonsFrame.bg:SetTexture(nil)
		mainFrame.Tabs = {_G.MissionHelperTab1, _G.MissionHelperTab2}
		self:skinObject("tabs", {obj=mainFrame, tabs=mainFrame.Tabs, lod=true, track=false})
		if self.isTT then
			self:SecureHook("MissionHelperFrame_SelectTab", function(tab)
				for _, btn in _G.pairs(tab:GetParent().Tabs) do
					if btn == tab then
						self:setActiveTab(btn.sf)
					else
						self:setInactiveTab(btn.sf)
					end
				end
			end)
		end
		self:skinObject("frame", {obj=mainFrame, kfs=true, y2=-6, clr="sepia"})
		if self.modBtns then
			self:skinStdButton{obj=mainFrame.buttonsFrame.BestDispositionButton}
			self:skinStdButton{obj=mainFrame.buttonsFrame.predictButton}
			self:SecureHook(mainFrame.buttonsFrame.BestDispositionButton, "Disable", function(this, _)
				self:clrBtnBdr(this)
			end)
			self:SecureHook(mainFrame.buttonsFrame.BestDispositionButton, "Enable", function(this, _)
				self:clrBtnBdr(this)
			end)
			self:SecureHook(mainFrame.buttonsFrame.predictButton, "Disable", function(this, _)
				self:clrBtnBdr(this)
			end)
			self:SecureHook(mainFrame.buttonsFrame.predictButton, "Enable", function(this, _)
				self:clrBtnBdr(this)
			end)
		end
		mainFrame = nil

		self:Unhook(thmainFrameis, "OnShow")
	end)

	if self.modBtnBs then
		self:SecureHook(_G.MissionHelperFrame, "updateMissionHeader", function(this, missionInfo)
			for _, btn in _G.pairs(this.missionHeader.Rewards) do
				self:removeRegions(btn, {1}) -- background shadow
				if self.modBtnBs then
					self:addButtonBorder{obj=btn, relTo=btn.Icon, reParent={btn.Quantity}, ofs=2}
					self:clrButtonFromBorder(btn)
				end
			end
		end)
	end

end
