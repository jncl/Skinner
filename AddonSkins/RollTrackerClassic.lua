local aName, aObj = ...
if not aObj:isAddonEnabled("RollTrackerClassic") then return end
local _G = _G

aObj.addonsToSkin.RollTrackerClassic = function(self) -- v 1.72

	self:SecureHookScript(_G.RollTrackerClassicMainWindow, "OnShow", function(this)

		self:skinSlider{obj=_G.RollTrackerClassicFrameRollScrollFrame.ScrollBar}
		self:addSkinFrame{obj=this, ft="a", kfs=true, ofs=0}
		_G.RollTrackerClassicMainWindowCloseButton:SetSize(28, 28)
		if self.modBtns then
			self:skinStdButton{obj=_G.RollTrackerClassicMainWindowLootTable}
			self:skinStdButton{obj=_G.RollTrackerClassicFrameHelperButton}
			self:skinStdButton{obj=_G.RollTrackerClassicFrameRollButton}
			self:skinStdButton{obj=_G.RollTrackerClassicFramePassButton}
			self:skinStdButton{obj=_G.RollTrackerClassicFrameGreedButton}
			self:skinStdButton{obj=_G.RollTrackerClassicFrameAnnounceButton}
			self:skinStdButton{obj=_G.RollTrackerClassicFrameClearButton}
			self:skinStdButton{obj=_G.RollTrackerClassicFrameNotRolledButton}
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.RollTrackerClassicMainWindowSettingsButton, es=10, ofs=0, y1=1, y2=-1}
		end

		self:Unhook(this, "OnShow")
	end)

	-- minimap button
	self.mmButs["RollTrackerClassic"] = _G.Lib_GPI_Minimap_RollTrackerClassic

end
