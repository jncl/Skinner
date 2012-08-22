local aName, aObj = ...
if not aObj:isAddonEnabled("QuestHelper2") then return end

function aObj:QuestHelper2()

	if _G.QuestHelper2_Collection_LicenseAccepted ~= "GPL3" then
		-- first time notice frame
		local ftn = self:findFrame2(UIParent, "Frame", "CENTER", UIParent, "CENTER", 0, 0)
		self:addSkinFrame{obj=ftn, kfs=true}
	end

	-- Tracker frame
	local qht = self:addSkinFrame{obj=QuestHelper2_Tracker, ofs=1, rt=true}
	qht:Hide()

	-- hook this to handle showing/hiding the QuestHelper2_Tracker skin frame
	local rb = self:getChild(QuestHelper2_Tracker, 4) -- route button
	self:SecureHook(QuestHelper2_Tracker, "SetScript", function(this, handler, ...)
		if handler then
			if rb:GetAlpha() == 1 then
				qht:Show()
			else
				qht:Hide()
			end
		end
	end)

	-- WorldMap tooltip
	if self.db.profile.Tooltips.skin then
		if self.db.profile.Tooltips.style == 3 then QuestHelper2_MapOverlayTooltip:SetBackdrop(self.Backdrop[1]) end
		self:SecureHookScript(QuestHelper2_MapOverlayTooltip, "OnShow", function(this)
			self:skinTooltip(this)
		end)
	end

	-- Flight Time status bar
	if QuestHelper2.settings.flight_timer_shown then
		local ftf = self:findFrame2(UIParent, "Frame", 46, 0)
		self:getRegion(ftf, 2):SetTexture(self.sbTexture)
		self:getRegion(ftf, 3):SetTexture(self.sbTexture)
	end

end
