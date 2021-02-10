local _, aObj = ...
if not aObj:isAddonEnabled("CovenantMissionHelper") then return end
local _G = _G

aObj.addonsToSkin.CovenantMissionHelper = function(self) -- v 0.1

	self:SecureHook(_G.MissionHelper, "createMissionHelperFrame", function(this, _)
		local mFrame = this.missionHelperFrame
		mFrame.resultHeader.BaseFrameBackground:SetTexture(nil)
		self:keepFontStrings(mFrame.RaisedFrameEdges)
		self:keepFontStrings(mFrame.resultInfo.RaisedFrameEdges)
		self:skinObject("frame", {obj=mFrame.resultInfo, kfs=true, fb=true})
		self:keepFontStrings(mFrame.combatLogFrame.RaisedFrameEdges)
		self:skinObject("frame", {obj=mFrame.combatLogFrame, kfs=true, fb=true})
		self:skinObject("slider", {obj=mFrame.combatLogFrame.CombatLogMessageFrame.ScrollBar, x1=-1, x2=0.5, y1=5, y2=-10})
		self:skinObject("frame", {obj=mFrame, kfs=true, y2=-6})
		if self.modBtns then
			self:skinStdButton{obj=mFrame.resultInfo.BestDispositionButton}
			self:skinStdButton{obj=mFrame.resultInfo.predictButton}
		end

		mFrame = nil

		-- N.B. DON'T unhook this as it called for each mission ???
		-- self:Unhook(_G.MissionHelper, "createMissionHelperFrame")
	end)

end
