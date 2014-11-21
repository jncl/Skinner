local aName, aObj = ...
if not aObj:isAddonEnabled("MinimapButtonFrame") then return end
local _G = _G

function aObj:MinimapButtonFrame()

	self:skinButton{obj=_G.MinimapButtonFrameDragButton}
	self:addSkinFrame{obj=_G.MinimapButtonFrame, nb=true}
	self:skinButton{obj=_G.MBFRestoreButton}
	self:addSkinFrame{obj=_G.MBFRestoreButtonFrame, nb=true}

	-- create a button skin
	_G.MBFAddSkin("Skinner", nil, nil, 35)

	_G.MinimapButtonFrame.SetBackdropColor = function() end
	_G.MinimapButtonFrame.SetBackdropBorderColor = function() end

end
