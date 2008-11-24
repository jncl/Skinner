
function Skinner:AckisRecipeList()
	if not self.db.profile.TradeSkillUI then return end

	local ARL
	if LibStub("AceAddon-3.0") then ARL = LibStub("AceAddon-3.0"):GetAddon("Ackis Recipe List", true) end
	if not ARL then return end

	self:SecureHook(ARL, "CreateFrame", function()
		self:Debug("ARL CreateFrame: [%s]", ARL.Frame.skinned)
		if not ARL.Frame.skinned then
			ARL.bgTexture:SetAlpha(0)
			self:moveObject(ARL.Frame.HeadingText, nil, nil, "-", 7)
			self:moveObject(ARL_CloseXButton, "-", 5, "+", 6)
			self:moveObject(ARL_CloseButton, nil, nil, "+", 2)
			self:removeRegions(ARL_RecipeScrollFrame)
			self:skinScrollBar(ARL_RecipeScrollFrame)
			self:glazeStatusBar(ARL_ProgressBar, 0)
			self:applySkin(ARL.Frame)
			-- flyaway frame
			self:keepFontStrings(ARL.Flyaway)
			ARL.flyTexture:SetAlpha(0)
			ARL.Frame.skinned = true
		end
	end)

	self:SecureHook(ARL, "ShowScanButton", function()
		-- If the scan button parent is the TradeSkill Frame then move the button
		local sbParent = ARL.ScanButton:GetParent():GetName()
		self:Debug("ARL_ASB [%s]", sbParent)
		if sbParent == "TradeSkillFrame" then
			self:moveObject(ARL.ScanButton, "-", 6, "+", 4)
		end
	end)

end
