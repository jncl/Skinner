local _, aObj = ...
if not aObj:isAddonEnabled("ExtendedCharacterStats") then return end
local _G = _G

aObj.addonsToSkin.ExtendedCharacterStats = function(self) -- v 2.5.0
	if not self.prdb.CharacterFrames then return end

	self:SecureHookScript(_G.ECS_StatsFrame, "OnShow", function(this)

		self:skinSlider{obj=this.ScrollFrame.ScrollBar}
		self:addSkinFrame{obj=_G.ECS_StatsFrame, ft="a", kfs=true, x2=1, y2=-5}
		if self.modBtns then
			self:skinStdButton{obj=this.configButton}
			self:skinStdButton{obj=_G.ECS_ToggleButton}
		end
		self:moveObject{obj=this, x=-2, y=1}

		self:Unhook(this, "OnShow")
	end)

end
