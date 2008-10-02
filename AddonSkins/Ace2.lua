
function Skinner:Ace2()

	-- Skin the AceAddon Donation Frame
	self:OpenDonationFrame()
	AceAddon20Frame:Hide()
	self:keepFontStrings(AceAddon20FrameScrollFrame)
	self:skinScrollBar(AceAddon20FrameScrollFrame)
	self:applySkin(AceAddon20Frame)
	-- Skin the AceAddon About Frame
	self:PrintAddonInfo()
	AceAddon20AboutFrame:Hide()
	self:applySkin(AceAddon20AboutFrame)

end
