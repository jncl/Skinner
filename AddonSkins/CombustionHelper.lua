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

	-- make sure LBtrackFrame doesn't overlap the CombustionFrame
	local point, relTo, relPoint, xOfs, yOfs
	local function moveLBTF()

		point, relTo, relPoint, xOfs, yOfs = LBtrackFrame:GetPoint()
		xOfs = aObj.round2(xOfs)
		yOfs = aObj.round2(yOfs)
		xOfs = xOfs == -6 and -4 or xOfs == 6 and 4 or 0
		yOfs = yOfs == -6 and -4 or yOfs == 6 and 4 or 0
		LBtrackFrame:SetPoint(point, relTo, relPoint, xOfs, yOfs)

	end
	self:SecureHook("CombustionFrameresize", function()
		if combulbtracker then
			moveLBTF()
		end
	end)
	if combulbtracker then
		moveLBTF()
	end

	-- Options tooltip frame
	self:addSkinFrame{obj=CombuOptionsTooltipFrame}

end
