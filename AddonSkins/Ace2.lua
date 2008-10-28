
function Skinner:Ace2()

	-- Skin the AceAddon Donation Frame
	self:SecureHook(LibStub("AceAddon-2.0").prototype, "OpenDonationFrame", function()
		self:keepFontStrings(AceAddon20FrameScrollFrame)
		self:skinScrollBar(AceAddon20FrameScrollFrame)
		self:applySkin(AceAddon20Frame)
		self:Unhook(LibStub("AceAddon-2.0").prototype, "OpenDonationFrame")
	end)
	
	-- Skin the AceAddon About Frame
	self:SecureHook(LibStub("AceAddon-2.0").prototype, "PrintAddonInfo", function()
		self:applySkin(AceAddon20AboutFrame)
		self:Unhook(LibStub("AceAddon-2.0").prototype, "PrintAddonInfo")
	end)

end
