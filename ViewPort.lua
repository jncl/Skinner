
function Skinner:ViewPort()
	if not self.db.profile.ViewPort.shown or self.initialized.ViewPort then return end
	self.initialized.ViewPort = true

	local dbVP = self.db.profile.ViewPort
	WorldFrame:SetPoint("TOPLEFT", (dbVP.left * dbVP.XScaling), -(dbVP.top * dbVP.YScaling))
	WorldFrame:SetPoint("BOTTOMRIGHT", -(dbVP.right * dbVP.XScaling), (dbVP.bottom * dbVP.YScaling))

	if dbVP.overlay then
		ViewportOverlay = WorldFrame:CreateTexture(nil, "BACKGROUND")
		ViewportOverlay:SetTexture(dbVP.r or 0, dbVP.g or 0, dbVP.b or 0, dbVP.a or 1)
		ViewportOverlay:SetPoint("TOPLEFT", UIParent, "TOPLEFT", -1, 1)
		ViewportOverlay:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 1, -1)
	end

end

function Skinner:ViewPort_top()
	if not self.db.profile.ViewPort.shown then return end

	local dbVP = self.db.profile.ViewPort
	WorldFrame:SetPoint("TOPLEFT", (dbVP.left * dbVP.XScaling), -(dbVP.top * dbVP.YScaling))
	WorldFrame:SetPoint("TOPRIGHT", -(dbVP.right * dbVP.XScaling), -(dbVP.top * dbVP.YScaling))

end

function Skinner:ViewPort_bottom()
	if not self.db.profile.ViewPort.shown then return end

	local dbVP = self.db.profile.ViewPort
	WorldFrame:SetPoint("BOTTOMLEFT", (dbVP.left * dbVP.XScaling), (dbVP.bottom * dbVP.YScaling))
	WorldFrame:SetPoint("BOTTOMRIGHT", -(dbVP.right * dbVP.XScaling), (dbVP.bottom * dbVP.YScaling))

end

function Skinner:ViewPort_left()
	if not self.db.profile.ViewPort.shown then return end

	local dbVP = self.db.profile.ViewPort
	WorldFrame:SetPoint("TOPLEFT", (dbVP.left * dbVP.XScaling), -(dbVP.top * dbVP.YScaling))

end

function Skinner:ViewPort_right()
	if not self.db.profile.ViewPort.shown then return end

	local dbVP = self.db.profile.ViewPort
	WorldFrame:SetPoint("BOTTOMRIGHT", -(dbVP.right * dbVP.XScaling), (dbVP.bottom * dbVP.YScaling))

end

function Skinner:ViewPort_reset()

	self.initialized.ViewPort = nil
	WorldFrame:ClearAllPoints()
	WorldFrame:SetPoint("TOPLEFT")
	WorldFrame:SetPoint("BOTTOMRIGHT")

end

