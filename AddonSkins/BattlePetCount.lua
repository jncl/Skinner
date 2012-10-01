local aName, aObj = ...
if not aObj:isAddonEnabled("BattlePetCount") then return end

function aObj:BattlePetCount()

	if self.db.profile.Tooltips.skin then
		local function skinTooltip(bpc)
			bpc.X_BPC.sf = aObj:addSkinFrame{obj=bpc.X_BPC}
			aObj:add2Table(aObj.pbtt, bpc.X_BPC.sf)
			aObj:Unhook("PetBattleUnitFrame_UpdateDisplay")
			aObj:Unhook("PetBattleUnitTooltip_UpdateForUnit")
		end
		-- hook these to skin the tooltip
		self:SecureHook("BattlePetTooltipTemplate_SetBattlePet", function(this, ...)
			if this.X_BPC then
				skinTooltip(this)
			else
				self:ScheduleTimer(skinTooltip, 0.2, this)
			end
		end)
		self:SecureHook("PetBattleUnitTooltip_UpdateForUnit", function(this, ...)
			if this.X_BPC then
				skinTooltip(this)
			else
				self:ScheduleTimer(skinTooltip, 0.2, this)
			end
		end)
	end

	self:removeInset(self:getChild(PetBattleFrame.ActiveEnemy, 2))

end