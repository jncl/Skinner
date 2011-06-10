local aName, aObj = ...
if not aObj:isAddonEnabled("DockingStation") then return end

function aObj:DockingStation()

	-- create Skinner profile, copy from Default profile and update
	if DockingStationSettings
	and DockingStationSettings.profiles
	and not DockingStationSettings.profiles.Skinner
	then
		DockingStationSettings.profiles.Skinner = CopyTable(DockingStationSettings.profiles.Default)
	end
	local dsDBp, c = DockingStationSettings.profiles.Skinner.panels
	for k, v in pairs(dsDBp) do
		dsDBp[k].bgTexture = self.db.profile.StatusBar.texture
		dsDBp[k].bgInset = self.db.profile.BdInset
		c = self.db.profile.Backdrop
		dsDBp[k].bgColorR = c.r
		dsDBp[k].bgColorG = c.g
		dsDBp[k].bgColorB = c.b
		dsDBp[k].bgColorA = c.a
		dsDBp[k].borderTexture = self.bdbTex
		dsDBp[k].borderSize = self.db.profile.BdEdgeSize
		c = self.db.profile.ClassColours and RAID_CLASS_COLORS[self.uCls] or self.db.profile.BackdropBorder
		dsDBp[k].borderColorR = c.r
		dsDBp[k].borderColorG = c.g
		dsDBp[k].borderColorB = c.b
		dsDBp[k].borderColorA = c.a
		dsDBp[k].iconSize = 0.7
	end

end

function aObj:DockingStation_Config()

	--	look through all InterfaceOptionsFrame children backwards
	for i = InterfaceOptionsFrame:GetNumChildren(), 1, -1  do
		local child = select(i, InterfaceOptionsFrame:GetChildren())
		local point, relTo, relPoint, xOfs, yOfs = child:GetPoint()
		if point == "LEFT"
		and relTo == InterfaceOptionsFrame
		and relPoint == "RIGHT"
		and xOfs == -13
		and yOfs == 0 then
			self:addSkinFrame{obj=child, x1=4, y1=-4, x2=-4, y2=4}
			self:skinSlider(self:getChild(child, 1)) -- skin the slider
			break
		end
	end

end
