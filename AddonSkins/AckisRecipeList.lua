
function Skinner:AckisRecipeList()
	if not self.db.profile.TradeSkill and self.db.profile.CraftFrame then return end

	local ARL
	if LibStub("AceAddon-3.0") then ARL = LibStub("AceAddon-3.0"):GetAddon("Ackis Recipe List", true) end
	if not ARL then return end

	self:SecureHook(ARL, "CreateFrame", function()
		if not ARL.Frame.skinned then
			self:keepFontStrings(ARL.Frame.Header)
			self:moveObject(ARL.Frame.Header.Text, nil, nil, "-", 7)
			ARL.Frame.ScrollFrame:SetHeight(ARL.Frame.ScrollFrame:GetHeight() + 10)
			self:keepFontStrings(ARL.Frame.ScrollFrame)
			self:skinScrollBar(ARL.Frame.ScrollFrame)
			self:glazeStatusBar(ARL.Frame.ProgressBar, 0)
			ARL.Frame.ProgressBarBorder:Hide()
			self:applySkin(ARL.Frame)
			ARL.Frame.skinned = true
		end
		-- Resize & move the frame if required
		local sbParent = ARL.ScanButton:GetParent()
		if sbParent:GetName() == "TradeSkillFrame" or sbParent:GetName() == "CraftFrame" then
			ARL.Frame:SetHeight(sbParent:GetHeight())
			self:moveObject(ARL.Frame, "+", 36, "-", 30)
		end
	end)

	self:SecureHook(ARL, "ShowScanButton", function()
		-- If the scan button parent is the TradeSkill or Craft Frame then move the button
		local sbParent = ARL.ScanButton:GetParent():GetName()
--		self:Debug("ARL_ASB [%s]", sbParent)
		if sbParent == "TradeSkillFrame" or sbParent == "CraftFrame" then
			self:moveObject(ARL.ScanButton, "-", 6, "+", 4)
		end
	end)

end
