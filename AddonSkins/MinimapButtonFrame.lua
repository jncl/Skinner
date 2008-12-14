
function Skinner:MinimapButtonFrame()

	self:applySkin(MBFRestoreButtonFrame)
	self:applySkin(MinimapButtonFrame)

	-- create a button skin
	MBFAddSkin("Skinner", nil, nil, 35)
	
	self:RawHook(MinimapButtonFrame, "SetBackdropColor", function() end, true)
	self:RawHook(MinimapButtonFrame, "SetBackdropBorderColor", function() end, true)

end
