local aName, aObj = ...
if not aObj:isAddonEnabled("BossInfo") then return end

function aObj:BossInfo()

	self:addSkinFrame{obj=BossInfoFrame}
	self:addSkinFrame{obj=BossInfoOptions}
	-- tooltip
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then BossInfoTip:SetBackdrop(self.Backdrop[1]) end
		self:SecureHookScript(BossInfoTip, "OnShow", function(this)
			self:skinTooltip(this)
		end)
	end

end
