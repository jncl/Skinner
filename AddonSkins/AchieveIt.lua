local _, aObj = ...
if not aObj:isAddonEnabled("AchieveIt") then return end
local _G = _G

aObj.addonsToSkin.AchieveIt = function(self) -- v 9.1.5.00

	self:SecureHookScript(_G.MuffinWhatsNewFrame, "OnShow", function(this)
		self:removeBackdrop(_G.MuffinWhatsNewHeaderFrame)
		self:moveObject{obj=_G.MuffinWhatsNewTitleText, y=-24}
		self:skinObject("frame", {obj=this, kfs=true, ofs=0})
		if self.modBtns then
			self:skinStdButton{obj=_G.MuffinWhatsNewFrameOkButton}
		end

		self:Unhook(this, "OnShow")
	end)

	self.RegisterCallback("AchieveIt", "AchievementUI_Skinned", function(_, _)
		if self.modBtns then
			self:skinStdButton{obj=_G.AchieveIt_Locate_Button, ofs=-4, y1=-2, y2=-1}
		end
	end)

end
