local aName, aObj = ...
if not aObj:isAddonEnabled("BonusRollPreview") then return end
local _G = _G

aObj.addonsToSkin.BonusRollPreview = function(self) -- v70300.44-Release

	-- Handle
	_G.BonusRollPreviewHandle:DisableDrawLayer("BACKGROUND")
	_G.BonusRollPreviewHandle:DisableDrawLayer("BORDER")

	-- need to adjust texture as per CompactRaidFrameManager
	local point, relTo, relPoint, xOfs, yOfs = _G.BonusRollPreviewHandle:GetPoint()
	if (relTo == _G.BonusRollFrame and point == "BOTTOM")
	then
		_G.BonusRollPreviewHandle.Arrow:SetTexCoord(0.8, 0.7, 1, 0.7 ,0.8, 0.3, 1, 0.3) -- point up
	else
		_G.BonusRollPreviewHandle.Arrow:SetTexCoord(1, 0.3, 0.8, 0.3 ,1, 0.7, 0.8, 0.7) -- point down
	end
	self:SecureHook(_G.BonusRollPreviewHandle, "SetPoint", function(this, point, relTo, relPoint, xOfs, yOfs)
		if (relTo == _G.BonusRollFrame and point == "BOTTOM")
		then
			this.Arrow:SetTexCoord(0.8, 0.7, 1, 0.7 ,0.8, 0.3, 1, 0.3) -- point up
		else
			this.Arrow:SetTexCoord(1, 0.3, 0.8, 0.3 ,1, 0.7, 0.8, 0.7) -- point down
		end
	end)

	-- Hotspot
	-- SpecButtons
	self:SecureHookScript(_G.BonusRollPreviewSpecButtons, "OnShow", function(this)
		local kids = {_G.BonusRollPreviewSpecButtons:GetChildren()}
		for i = 1, #kids do
			self:removeRegions(kids[i], {3}) -- icon ring
		end
		kids = nil
	end)

end
