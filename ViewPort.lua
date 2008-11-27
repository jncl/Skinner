
function Skinner:ViewPort()
	if not self.db.profile.ViewPort.shown or self.initialized.ViewPort then return end
	self.initialized.ViewPort = true

	local xOfs = self.db.profile.ViewPort.left * self.db.profile.ViewPort.XScaling
	local yOfs = self.db.profile.ViewPort.top * self.db.profile.ViewPort.YScaling
	local xOfs2 = self.db.profile.ViewPort.right * self.db.profile.ViewPort.XScaling
	local yOfs2 = self.db.profile.ViewPort.bottom * self.db.profile.ViewPort.YScaling
--	self:Debug("VP [%s, %s, %s, %s]", xOfs, -yOfs, -xOfs2, yOfs2)
	WorldFrame:SetPoint("TOPLEFT", xOfs, -yOfs)
	WorldFrame:SetPoint("BOTTOMRIGHT", -xOfs2, yOfs2)

	if self.db.profile.ViewPort.overlay then
		ViewportOverlay = WorldFrame:CreateTexture(nil, "BACKGROUND")
		ViewportOverlay:SetTexture(self.db.profile.ViewPort.r or 0, self.db.profile.ViewPort.g or 0, self.db.profile.ViewPort.b or 0, ba or self.db.profile.ViewPort.a or 1)
		ViewportOverlay:SetPoint("TOPLEFT", UIParent, "TOPLEFT", -1, 1)
		ViewportOverlay:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 1, -1)
	end

end

function Skinner:ViewPort_top()
	if not self.db.profile.ViewPort.shown then return end

	WorldFrame:SetPoint("TOPLEFT", (self.db.profile.ViewPort.left * self.db.profile.ViewPort.XScaling), -(self.db.profile.ViewPort.top * self.db.profile.ViewPort.YScaling))
	WorldFrame:SetPoint("TOPRIGHT", -(self.db.profile.ViewPort.right * self.db.profile.ViewPort.XScaling), -(self.db.profile.ViewPort.top * self.db.profile.ViewPort.YScaling))

end

function Skinner:ViewPort_bottom()
	if not self.db.profile.ViewPort.shown then return end

	WorldFrame:SetPoint("BOTTOMLEFT", (self.db.profile.ViewPort.left * self.db.profile.ViewPort.XScaling), (self.db.profile.ViewPort.bottom * self.db.profile.ViewPort.YScaling))
	WorldFrame:SetPoint("BOTTOMRIGHT", -(self.db.profile.ViewPort.right * self.db.profile.ViewPort.XScaling), (self.db.profile.ViewPort.bottom * self.db.profile.ViewPort.YScaling))

end

function Skinner:ViewPort_left()
	if not self.db.profile.ViewPort.shown then return end

	local xOfs = self.db.profile.ViewPort.left * self.db.profile.ViewPort.XScaling
	local yOfs = self.db.profile.ViewPort.top * self.db.profile.ViewPort.YScaling
	WorldFrame:SetPoint("TOPLEFT", xOfs, -yOfs)

end

function Skinner:ViewPort_right()
	if not self.db.profile.ViewPort.shown then return end

	local xOfs2 = self.db.profile.ViewPort.right * self.db.profile.ViewPort.XScaling
	local yOfs2 = self.db.profile.ViewPort.bottom * self.db.profile.ViewPort.YScaling
	WorldFrame:SetPoint("BOTTOMRIGHT", -xOfs2, yOfs2)

end

function Skinner:ViewPort_reset()

	self.initialized.ViewPort = nil
	WorldFrame:ClearAllPoints()
	WorldFrame:SetPoint("TOPLEFT", 0, -0)
	WorldFrame:SetPoint("BOTTOMRIGHT", -0, 0)

end

