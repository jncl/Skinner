if not Skinner:isAddonEnabled("AckisRecipeList") then return end
-- thanks to pompachomp for the updates

function Skinner:AckisRecipeList()
	if not self.db.profile.TradeSkillUI then return end

	local ARL = LibStub("AceAddon-3.0"):GetAddon("Ackis Recipe List", true)
	if not ARL then return end

	self:SecureHookScript(ARL_MainPanel, "OnShow", function(this)
		ARL.Frame.backdrop:SetAlpha(0)
		self:moveObject{obj=ARL.Frame.mode_button, y=-9}
		self:skinDropDown{obj=ARL_DD_Sort}
		self:skinEditBox{obj=ARL_SearchText or ARL.Frame.search_editbox, regs={9}} -- ARL.Frame.search_editbox is the new name of the old ARL_SearchText in an arl alpha
		self:skinScrollBar{obj=ARL.Frame.scroll_frame}
		self:glazeStatusBar(ARL.Frame.progress_bar, 0)
		-- buttons
		self:addSkinFrame{obj=ARL.Frame, y1=-9, x2=2, y2=-4}
		-- Flyaway frame (used when Filters button is clicked)
		self:addSkinFrame{obj=ARL.Frame.filter_menu, kfs=true, bg=true, x2=2}
		--	minus/plus buttons
		for _, btn in pairs(ARL.Frame.scroll_frame.state_buttons) do
			self:skinButton{obj=btn, mp2=true, plus=true}
			btn.text:SetJustifyH("CENTER")
		end
		self:Unhook(ARL_MainPanel, "OnShow")
	end)

	-- TextDump frame
	self:skinScrollBar{obj=ARLCopyScroll}
	self:addSkinFrame{obj=ARLCopyFrame}

	-- button on Tradeskill frame
	self:skinButton{obj=ARL_ScanButton or ARL.scan_button} -- ARL.scan_button is the new name of the old ARL_ScanButton in an arl alpha

-->>-- Tooltip
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then arlSpellTooltip:SetBackdrop(self.Backdrop[1]) end
		self:SecureHookScript(arlSpellTooltip, "OnShow", function(this)
			self:skinTooltip(this)
		end)
	end

end
