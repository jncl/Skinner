local aName, aObj = ...
if not aObj:isAddonEnabled("MinimapButtonFrame") then return end
local _G = _G

aObj.addonsToSkin.MinimapButtonFrame = function(self) -- v 3.1.10h

	self:skinStdButton{obj=_G.MinimapButtonFrameDragButton}
	self:addSkinFrame{obj=_G.MinimapButtonFrame, ft="a", kfs=true, nb=true, rp=true} -- reparent to fix error
	self:skinStdButton{obj=_G.MBFRestoreButton}
	self:addSkinFrame{obj=_G.MBFRestoreButtonFrame, ft="a", kfs=true, nb=true}

	-- create a button skin & make it the default
	_G.MBFAddSkin("Skinner", nil, nil, 35)
	_G.bachMBF.db.profile.currentTexture = "Skinner"

	_G.MinimapButtonFrame.SetBackdropColor = _G.nop
	_G.MinimapButtonFrame.SetBackdropBorderColor = _G.nop

	self.mmButs["MBF"] = _G.MiniMapMailFrameDisabled

	-- add this to bypass skinning of About panel
	self.aboutPanels["MinimapButtonFrame"] = true

end
