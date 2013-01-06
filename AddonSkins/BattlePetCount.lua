local aName, aObj = ...
if not aObj:isAddonEnabled("BattlePetCount") then return end

function aObj:BattlePetCount()

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
				self:ScheduleTimer(skinTooltip, 0.2, this)
			end
			aObj:Unhook("BattlePetTooltipTemplate_SetBattlePet")
		end)
		self:SecureHook("PetBattleUnitTooltip_UpdateForUnit", function(this, ...)
			if this.X_BPC2 then
				skinTooltip(this)
			else
				self:ScheduleTimer(skinTooltip, 0.2, this)
			end
			aObj:Unhook("PetBattleUnitTooltip_UpdateForUnit")
		end)
	end

	self:removeInset(self:getChild(PetBattleFrame.ActiveEnemy, 2))

end