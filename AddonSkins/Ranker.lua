local _, aObj = ...
if not aObj:isAddonEnabled("Ranker") then return end
local _G = _G

aObj.addonsToSkin.Ranker = function(self) -- v 2025.03.21.01

	self:SecureHookScript(_G.Ranker.MainFrame, "OnShow", function(this)
		self:skinObject("slider", {obj=this.ScrollBar})
		self:moveObject{obj=_G.RankerWhatIfRankList, y=-2}
		self:skinObject("dropdown", {obj=_G.RankerWhatIfRankList})
		self:skinObject("editbox", {obj=_G.RankerWhatIfRankProgressBox})
		self:skinObject("dropdown", {obj=_G.RankerObjective})
		self:skinObject("dropdown", {obj=_G.RankerObjectiveMaxRank})
		self:skinObject("dropdown", {obj=_G.RankerLimit})
		self:skinObject("dropdown", {obj=_G.RankerLimitMaxRank})
		self:skinObject("frame", {obj=this, kfs=true, ri=true, cb=true, x1=-4, x2=1, y2=-1})

		self:Unhook(this, "OnShow")
	end)

	if self.modBtns then
		self:skinStdButton{obj=_G.RankerToggleButton}
		self:skinStdButton{obj=_G.RankerWhatIfButton}
	end

	self.RegisterCallback("Ranker", "SettingsPanel_DisplayCategory", function(this, panel)
		if not panel == _G.RankerFrame then return end
		self.spSkinnedPanels[panel] = true

		if self.modChkBtns then
			self:skinCheckButton{obj=_G.RankerFrame.buttonShowWindowByDefault, ofs=-6}
			self:skinCheckButton{obj=_G.RankerFrame.buttonUseCurrentHonorWhenModeling, ofs=-6}
			self:skinCheckButton{obj=_G.RankerFrame.buttonKnowsboutMinimumHK, ofs=-6}
			self:skinCheckButton{obj=_G.RankerFrame.buttonHideHelpfulInformation, ofs=-6}
			self:skinCheckButton{obj=_G.RankerFrame.buttonAutoPromote, ofs=-6}
		end

		self.UnregisterCallback("Ranker", "SettingsPanel_DisplayCategory")
	end)

end
