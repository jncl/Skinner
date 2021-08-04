local _, aObj = ...
if not aObj:isAddonEnabled("CovenantMissionHelper") then return end
local _G = _G

aObj.addonsToSkin.CovenantMissionHelper = function(self) -- v 0.1

	local function skinMHF(frame)
		aObj:keepFontStrings(frame.RaisedFrameEdges)
		aObj:skinObject("frame", {obj=frame.missionHeader, kfs=true, fb=true, clr="grey"})
		frame.resultHeader.BaseFrameBackground:SetTexture(nil)
		aObj:keepFontStrings(frame.resultInfo.RaisedFrameEdges)
		aObj:skinObject("frame", {obj=frame.resultInfo, kfs=true, fb=true, y2=-6, clr="grey"})
		aObj:keepFontStrings(frame.combatLogFrame.RaisedFrameEdges)
		aObj:skinObject("frame", {obj=frame.combatLogFrame, kfs=true, fb=true, y2=-6, clr="grey"})
		aObj:skinObject("slider", {obj=frame.combatLogFrame.CombatLogMessageFrame.ScrollBar, x1=-1, x2=0.5, y1=5, y2=-10})
		frame.buttonsFrame.bg:SetTexture(nil)
		frame.Tabs = {frame.ResultTab, frame.CombatLogTab}
		aObj:skinObject("tabs", {obj=frame, tabs=frame.Tabs, lod=self.isTT and true, noCheck=true, track=false})
		if aObj.isTT then
			aObj:secureHook("MissionHelperFrame_SelectTab", function(tab)
				for _, btn in _G.pairs(tab:GetParent().Tabs) do
					if btn == tab then
						aObj:setActiveTab(btn.sf)
					else
						aObj:setInactiveTab(btn.sf)
					end
				end
			end)
		end
		aObj:skinObject("frame", {obj=frame, kfs=true, y2=-5, clr="sepia"})
		if aObj.modBtns then
			aObj:skinStdButton{obj=frame.buttonsFrame.BestDispositionByPercentButton}
			aObj:skinStdButton{obj=frame.buttonsFrame.BestDispositionByMinPercentButton}
			aObj:SecureHook(frame, "disableBestDispositionButton", function(this)
				aObj:clrBtnBdr(this.buttonsFrame.BestDispositionByPercentButton)
				aObj:clrBtnBdr(this.buttonsFrame.BestDispositionByMinPercentButton)
			end)
			aObj:SecureHook(frame, "enableBestDispositionButton", function(this)
				aObj:clrBtnBdr(this.buttonsFrame.BestDispositionByPercentButton)
				aObj:clrBtnBdr(this.buttonsFrame.BestDispositionByMinPercentButton)
			end)
			aObj:skinStdButton{obj=frame.buttonsFrame.predictButton}
			aObj:SecureHook(frame.buttonsFrame.predictButton, "Disable", function(this, _)
				aObj:clrBtnBdr(this)
			end)
			aObj:SecureHook(frame.buttonsFrame.predictButton, "Enable", function(this, _)
				aObj:clrBtnBdr(this)
			end)
		end
	end

	-- handle the fact the frame is created anew each time the mission frame is opened
	self:RawHook(_G.MissionHelper, "createMissionHelperFrame", function(this)
		local frame = self.hooks[this].createMissionHelperFrame(this)
		skinMHF(frame)
		return frame
	end, true)

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
