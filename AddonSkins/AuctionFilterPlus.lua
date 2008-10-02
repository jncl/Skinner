
function Skinner:AuctionFilterPlus()

	self:SecureHook("AuctionFilterPlus_OnEvent", function()
		self:moveObject(afp_FlyoutButton, "-", 8, "+", 8)
		self:Unhook("AuctionFilterPlus_OnEvent")
	end)

	self:keepFontStrings(afp_FlyoutFrame)
	self:keepFontStrings(BrowseBuyoutSort)
	self:applySkin(BrowseBuyoutSort)
	self:keepFontStrings(BrowseNameSort)
	self:applySkin(BrowseNameSort)
	self:applySkin(afp_FlyoutFrame)

end
