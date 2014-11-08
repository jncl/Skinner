if not Skinner:isAddonEnabled("Grid") then return end

function Skinner:Grid()

	if not Grid.enabledState then return end

	local GridLayout = Grid:GetModule("GridLayout")

	GridLayout.db.profile.borderTexture = Skinner.db.profile.BdBorderTexture
	GridLayout.db.profile.BorderR = Skinner.db.profile.BackdropBorder.r
	GridLayout.db.profile.BorderG = Skinner.db.profile.BackdropBorder.g
	GridLayout.db.profile.BorderB = Skinner.db.profile.BackdropBorder.b
	GridLayout.db.profile.BorderA = Skinner.db.profile.BackdropBorder.a
	GridLayout.db.profile.BackgroundR = Skinner.db.profile.Backdrop.r
	GridLayout.db.profile.BackgroundG = Skinner.db.profile.Backdrop.g
	GridLayout.db.profile.BackgroundB = Skinner.db.profile.Backdrop.b
	GridLayout.db.profile.BackgroundA = Skinner.db.profile.Backdrop.a
	-- apply changes
	GridLayout:UpdateColor()

	-- Tab
	local tabObj = GridLayout.frame.tab
	self:keepRegions(tabObj, {4}) -- N.B. region 4 is text
	local tabSF = self:addSkinFrame{obj=tabObj, noBdr=self.isTT, x1=-3, y1=1, y2=-2}
	tabSF.ignore = true -- don't resize tab
	if self.isTT then self:setActiveTab(tabSF) end

end
