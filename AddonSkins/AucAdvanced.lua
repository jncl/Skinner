
function Skinner:AucAdvanced()
	if not self.db.profile.AuctionFrame then return end

	if IsAddOnLoaded("EnhTooltip") then self:checkAndRunAddOn("EnhTooltip") end

	if UIParentHealthBar then
		UIParentHealthBar:SetBackdrop(nil)
		self:glazeStatusBar(UIParentHealthBar, 0)
	end

	if type(self["AucExtras"]) == "function" then self:AucExtras() end

end

function Skinner:AucUtilBigPicture()

	self:keepFontStrings(BPCharSelectBoxButton:GetParent())
	if not SelectBoxMenu.skinned then
		self:applySkin(SelectBoxMenu.back)
		SelectBoxMenu.skinned= true
	end
	self:applySkin(BPFrame_Char)
	self:applySkin(BPFrame_GBL)
	self:applySkin(BigPictureBaseFrame)

end
