local aName, aObj = ...
if not aObj:isAddonEnabled("BattlePetCount") then return end
local _G = _G

aObj.addonsToSkin.BattlePetCount = function(self) -- v 1.8.16

	if self.db.profile.Tooltips.skin then
		local function skinTooltip(tt)
			tt.X_BPC2.sf = aObj:addSkinFrame{obj=tt.X_BPC2}
			aObj:add2Table(aObj.pbtt, tt.X_BPC2.sf)
		end
		-- hook these to skin the tooltip
		self:SecureHook("BattlePetTooltipTemplate_SetBattlePet", function(this, ...)
			if this.X_BPC2 then
				skinTooltip(this)
			else
				_G.C_Timer.After(0.2, function() skinTooltip(this) end)
			end
			self:Unhook("BattlePetTooltipTemplate_SetBattlePet")
		end)
		self:SecureHook("PetBattleUnitTooltip_UpdateForUnit", function(this, ...)
			if this.X_BPC2 then
				skinTooltip(this)
			else
				_G.C_Timer.After(0.2, function() skinTooltip(this) end)
			end
			self:Unhook("PetBattleUnitTooltip_UpdateForUnit")
		end)
	end

	self:removeInset(self:getChild(PetBattleFrame.ActiveEnemy, 2))

end