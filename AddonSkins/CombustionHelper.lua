local aName, aObj = ...
if not aObj:isAddonEnabled("CombustionHelper") then return end

function aObj:CombustionHelper()

	self:addSkinFrame{obj=CombustionFrame}
	self:glazeStatusBar(FFBbar, 0,  nil)
	self:glazeStatusBar(Pyrobar, 0,  nil)
	self:glazeStatusBar(Ignbar, 0,  nil)
	self:glazeStatusBar(LBbar, 0,  nil)
	self:glazeStatusBar(Combubar, 0,  nil)
	self:glazeStatusBar(Critbar, 0,  nil)

	-- Living Bomb Tracker
	self:addSkinFrame{obj=LBtrackFrame}
	self:glazeStatusBar(LBtrack1Bar, 0,  nil)
	self:glazeStatusBar(LBtrack2Bar, 0,  nil)
	self:glazeStatusBar(LBtrack3Bar, 0,  nil)
	self:glazeStatusBar(LBtrack4Bar, 0,  nil)
	self:glazeStatusBar(LBtrack5Bar, 0,  nil)

	-- Options tooltip frame
	self:addSkinFrame{obj=CombuOptionsTooltipFrame}

end
