local _, aObj = ...
if not aObj:isAddonEnabled("ExtendedCharacterStats") then return end
local _G = _G

aObj.addonsToSkin.ExtendedCharacterStats = function(self) -- v 3.2.1
	if not self.prdb.CharacterFrames then return end

	self:SecureHookScript(_G.ECS_StatsFrame, "OnShow", function(this)
		self:skinObject("slider", {obj=this.ScrollFrame.ScrollBar})
		self:skinObject("frame", {obj=this, kfs=true, ri=true, cb=true})
		if self.modBtns then
			self:skinStdButton{obj=this.configButton}
			self:skinStdButton{obj=_G.ECS_ToggleButton}
		end
		self:moveObject{obj=this, x=-2, y=1}

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.ECSConfigFrame, "OnShow", function(this)
		self:skinAceOptions(this)

		self:Unhook(this, "OnShow")
	end)

end
