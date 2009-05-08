
function Skinner:Ace2()

	if LibStub("AceAddon-2.0").prototype.OpenDonationFrame then
		-- Skin the AceAddon Donation Frame
		self:SecureHook(LibStub("AceAddon-2.0").prototype, "OpenDonationFrame", function()
			self:skinScrollBar{obj=AceAddon20FrameScrollFrame}
			self:addSkinFrame{obj=AceAddon20Frame}
			self:Unhook(LibStub("AceAddon-2.0").prototype, "OpenDonationFrame")
		end)
	end
	
	-- Skin the AceAddon About Frame
	self:SecureHook(LibStub("AceAddon-2.0").prototype, "PrintAddonInfo", function()
		self:addSkinFrame{obj=AceAddon20AboutFrame}
		self:Unhook(LibStub("AceAddon-2.0").prototype, "PrintAddonInfo")
	end)

end
