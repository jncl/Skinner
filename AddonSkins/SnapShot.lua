local aName, aObj = ...
if not aObj:isAddonEnabled("SnapShot") then return end

function aObj:SnapShot()

	self:makeMFRotatable(SnapShotModel)
	self:addSkinFrame{obj=SnapShotFrame, kfs=true, x1=10, y1=-11, x2=-32, y2=71}
	if self.modBtnBs then
		for i = 1, 19 do
			local btn = _G["SnapShotItem"..i]
			self:addButtonBorder{obj=btn}
		end
	end
	-- About Frame (doesn't seem to be used)
	self:addSkinFrame{obj=SnapShotAboutFrame, kfs=true, hdr=true}
	-- Tooltip
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then SnapShotTooltip:SetBackdrop(self.Backdrop[1]) end
		self:SecureHookScript(SnapShotTooltip, "OnShow", function(this)
			self:skinTooltip(this)
		end)
	end

end
