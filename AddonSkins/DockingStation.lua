local aName, aObj = ...
if not aObj:isAddonEnabled("DockingStation") then return end
local _G = _G

aObj.addonsToSkin.DockingStation = function(self) -- v 0.5.15

	-- create Skinner profile, copy from Default profile and update
	if _G.DockingStationSettings
	and _G.DockingStationSettings.profiles
	and not _G.DockingStationSettings.profiles.Skinner
	then
		_G.DockingStationSettings.profiles.Skinner = _G.CopyTable(_G.DockingStationSettings.profiles.Default)
	end
	local dsDBp, c = _G.DockingStationSettings.profiles.Skinner.panels
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
		c = self.db.profile.ClassClrBd and _G.RAID_CLASS_COLORS[self.uCls] or self.db.profile.BackdropBorder
		dsDBp[k].borderColorR = c.r
		dsDBp[k].borderColorG = c.g
		dsDBp[k].borderColorB = c.b
		dsDBp[k].borderColorA = c.a
		dsDBp[k].iconSize = 0.7
	end
	dsDBp, c = nil, nil

end

aObj.lodAddons.DockingStation_Config = function(self) -- v 0.5.15

	local frame = self:findFrame2(_G.InterfaceOptionsFrame, "Frame", "LEFT", _G.InterfaceOptionsFrame, "RIGHT", -13, 0)
	self:addSkinFrame{obj=frame, ft="a", kfs=true, nb=true, ofs=-4}
	self:skinSlider(self:getChild(frame, 1))
	frame = nil

	-- DON'T skin any option frames
	self.RegisterCallback("DockingStation_Config", "IOFPanel_Before_Skinning", function(this, panel)
		if panel.name == "DockingStation"
		or panel.parent == "DockingStation"
		then
			self.iofSkinnedPanels[panel] = true
		end
	end)

end
