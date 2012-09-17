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

	local frame = self:findFrame2(InterfaceOptionsFrame, "Frame", "LEFT", InterfaceOptionsFrame, "RIGHT", -13, 0)
	self:addSkinFrame{obj=frame, ofs=-4}
	self:skinSlider(self:getChild(frame, 1)) -- skin the slider

end
