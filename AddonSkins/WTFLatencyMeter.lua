local aName, aObj = ...
if not aObj:isAddonEnabled("WTFLatencyMeter") then return end

function aObj:WTFLatencyMeter()

	WTFLatencyMeter.mainFrame.frmText:SetTexture(nil)
	self:addSkinFrame{obj=WTFLatencyMeter.mainFrame, x1=3, y1=-10, x2=-18, y2=9}
	-- update bar textures and rotate them
	self:getRegion(self:getChild(WTFLatencyMeter.mainFrame, 3), 1):SetTexture(self.sbTexture)
	self:getRegion(self:getChild(WTFLatencyMeter.mainFrame, 3), 1):SetRotation(math.pi/2)
	self:getRegion(self:getChild(WTFLatencyMeter.mainFrame, 4), 1):SetTexture(self.sbTexture)
	self:getRegion(self:getChild(WTFLatencyMeter.mainFrame, 4), 1):SetRotation(math.pi/2)
	
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then WTFLatencyMeter.tooltip:SetBackdrop(self.Backdrop[1]) end
		self:SecureHookScript(WTFLatencyMeter.tooltip, "OnShow", function(this)
			self:skinTooltip(this)
		end)
	end

end
