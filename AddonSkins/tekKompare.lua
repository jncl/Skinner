
function Skinner:tekKompare()
	if not self.db.profile.Tooltips.skin then return end

	self:HookScript(ItemRefTooltip, "OnTooltipSetItem", function(this, ...)
		self.hooks[this].OnTooltipSetItem(this, ...)
		self:SecureHook(tekKompareTooltip1, "Show", function(this)
			if self.db.profile.Tooltips.style == 3 then tekKompareTooltip1:SetBackdrop(self.backdrop) end
			self:skinTooltip(tekKompareTooltip1)
			self:Unhook(tekKompareTooltip1, "Show")
		end)
		self:SecureHook(tekKompareTooltip2, "Show", function(this)
			if self.db.profile.Tooltips.style == 3 then tekKompareTooltip2:SetBackdrop(self.backdrop) end
			self:skinTooltip(tekKompareTooltip2)
			self:Unhook(tekKompareTooltip2, "Show")
		end)
		self:Unhook(ItemRefTooltip, "OnTooltipSetItem")
	end)

end
