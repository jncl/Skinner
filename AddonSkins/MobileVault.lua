
function Skinner:MobileVault()
	if not self.db.profile.GuildBankUI then return end

	local mvFrames = {MobileVault.anchor, MobileVault.anchor.bg} -- , MobileVault.Bottom
	for _, v in pairs(mvFrames) do
		v:SetWidth(v:GetWidth() + 10)
		self:applySkin(v)
	end
	MobileVault.anchor.bg:SetHeight(MobileVault.anchor.bg:GetHeight() - 10)
	self:moveObject(MobileVault.anchor.bg, nil, nil, "-", 7)
	self:moveObject(MobileVault.Bottom, nil, nil, "-", 2)

-->>--	Tabs
	for i = 1, 6 do
		local tabObj = MobileVault.tab_buttons[i]
		self:keepRegions(tabObj, {1}) -- N.B. region 1 is the Icon
		self:applySkin(tabObj)
		self:Hook(tabObj, "SetBackdropColor", function() end, true)
		self:Hook(tabObj, "SetBackdropBorderColor", function() end, true)
	end

end
