
function Skinner:LilSparkysWorkshop()

	if self.db.profile.Tooltips.skin then
		self:SecureHookScript(LSW_Tooltip, "OnShow", function(this)
			self:skinTooltip(LSW_Tooltip)
		end)
		if self.db.profile.Tooltips.style == 3 then LSW_Tooltip:SetBackdrop(self.backdrop) end
	end

end
