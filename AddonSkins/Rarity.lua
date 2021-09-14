local _, aObj = ...
if not aObj:isAddonEnabled("Rarity") then return end
local _G = _G

aObj.addonsToSkin.Rarity = function(self) -- v 1.0 (r710-release-6)

	-- change StatusBar texture
	_G.Rarity.db.profile.bar.texture = self.prdb.StatusBar.texture
	_G.Rarity.barGroup:SetTexture(self.LSM:Fetch("statusbar", _G.Rarity.db.profile.bar.texture))
	-- change AnchoredTrackingBar title height
	_G.Rarity.db.profile.bar.height = 18
	_G.Rarity.barGroup:SetHeight(_G.Rarity.db.profile.bar.height)
	
	-- skin AnchoredTrackingBar title button
	self:skinObject("frame", {obj=_G.Rarity.barGroup.button, y1=0})
	
	-- FauxAchievementPopup
	if _G.Rarity.db.profile.showAchievementToast then
		self:SecureHook(_G.AlertFrame.alertFrameSubSystems[#_G.AlertFrame.alertFrameSubSystems], "setUpFunction", function(frame, _)
			self:nilTexture(frame.Background, true)
			frame.Unlocked:SetTextColor(self.BT:GetRGB())
			if frame.OldAchievement then
				frame.OldAchievement:SetTexture(nil)
			end
			frame.Icon:DisableDrawLayer("BORDER")
			frame.Icon:DisableDrawLayer("OVERLAY")
			self:skinObject("frame", {obj=frame, ofs=0, y1=frame.Shield and -15 or -8, y2=frame.Shield and 10 or 8}) -- adjust if Achievement Alert
			if self.modBtnBs then
				self:addButtonBorder{obj=frame.Icon, relTo=frame.Icon.Texture}
			end
		end)
	end

end
