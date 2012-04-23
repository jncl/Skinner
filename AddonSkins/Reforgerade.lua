local aName, aObj = ...
if not aObj:isAddonEnabled("Reforgerade") then return end

function aObj:Reforgerade()

	self:skinScrollBar{obj=ExportScroll}
	self:addSkinFrame{obj=ReforgeradeInputFrame.frame}
	if self.modBtnBs then
		self:addButtonBorder{obj=ReforgeradeConfigButton, ofs=-3}
		for i = 1, 19 do
			self:addButtonBorder{obj=ReforgeradeInputFrame.SlotBackground[i], ofs=4}
		end
	end
	-- Tooltip
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then ReforgeradeInputFrame.Tooltip:SetBackdrop(self.Backdrop[1]) end
		self:SecureHookScript(ReforgeradeInputFrame.Tooltip, "OnShow", function(this)
			self:skinTooltip(this)
		end)
	end

end
