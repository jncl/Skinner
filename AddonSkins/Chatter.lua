
function Skinner:Chatter()

	if Chatter:GetModule("Chat Copy") then
		self:removeRegions(ChatterCopyScroll)
		self:skinScrollBar(ChatterCopyScroll)
		self:applySkin(ChatterCopyFrame)
	end

	-- disable Chatter module if enabled
	if self.db.profile.ChatFrames then
		if Chatter:GetModule("Borders/Background").enabledState then
			Chatter.db.profile.modules["Borders/Background"] = false
			Chatter:DisableModule("Borders/Background")
		end
	end

	-- set the Chatter EditBox values to match the Skinner ones
	local ebp = Chatter:GetModule("Edit Box Polish")
	ebp.db.profile.background = "Blizzard ChatFrame Background"
	ebp.db.profile.border = self.db.profile.ChatEditBox.style == 1 and "Blizzard Tooltip" or "Skinner EditBox/ScrollBar Border"
	local c = ebp.db.profile.backgroundColor
	c.r, c.g, c.b, c.a = unpack(self.bColour)
	local c = ebp.db.profile.borderColor
	c.r, c.g, c.b, c.a = unpack(self.bbColour)
	ebp.db.profile.inset = 4
	ebp.db.profile.tileSize = 16
	ebp.db.profile.edgeSize = 16

	-- then apply these changes to the ChatEditBox
	ebp:SetBackdrop()

	-- apply the fade/gradient to the ChatEditBox
	self:applyGradient(ChatFrameEditBox)

end
