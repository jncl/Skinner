
function Skinner:FishingBuddy()

	FishingBuddyFrame:SetWidth(FishingBuddyFrame:GetWidth() * self.FxMult)
	FishingBuddyFrame:SetHeight(FishingBuddyFrame:GetHeight() * self.FyMult)
	self:keepFontStrings(FishingBuddyFrame)
	self:moveObject(FishingBuddyNameFrame, nil, nil, "-", 20)
	self:moveObject(FishingBuddyCloseButton, "+", 28, "+", 10)
	self:applySkin(FishingBuddyFrame)
-->>--	Locations Frame
	self:keepFontStrings(FishingLocationsFrame)
	self:keepFontStrings(FishingLocationExpandButtonFrame)
	self:moveObject(FishingLocationsSwitchButton, nil, nil, "+", 20)
	self:keepFontStrings(FishingLocsScrollFrame)
	self:skinScrollBar(FishingLocsScrollFrame)
-->>--	Options Frame
	self:keepFontStrings(FishingOptionsFrame)
	self:keepFontStrings(FishingBuddyOption_EasyCastKeys)
	self:keepFontStrings(FishingBuddyOption_ClockOffset)
	self:skinDropDown(FishingBuddyOption_OutfitMenu)
	FishingBuddyOption_MinimapPosSlider:ClearAllPoints()
	FishingBuddyOption_MinimapPosSlider:SetPoint("BOTTOM", FishingOptionsFrame, "BOTTOM", 8, 30)
-->>--	Fishing Extravaganza Frame
	self:applySkin(FishingExtravaganzaFrame)
-->>--	FishingWatch Tab
	self:keepRegions(FishingWatchTab, {4, 5}) -- N.B. region 4 is the Text, 5 is the Highlight
	if self.db.profile.TexturedTab then self:applySkin(FishingWatchTab, nil, 0, 1)
	else self:applySkin(FishingWatchTab) end
	self:moveObject(FishingWatchTab, nil, nil, "-", 4)
	self:moveObject(FishingWatchTabText, nil, nil, "+", 4)
	local FWTTH = self:getRegion(FishingWatchTab, 5) -- Text Highlight
	self:moveObject(FWTTH, nil, nil, "+", 4)
	FWTTH:SetWidth(FWTTH:GetWidth() - 20)

-->>--	Tabs
	local function fbTabs()

--		Skinner:Debug("fbTabs")

		for i = 1, 4 do
			local tabName = _G["FishingBuddyFrameTab"..i]
			if Skinner.db.profile.TexturedTab then
				if i == FishingBuddyFrame.selectedTab then
					Skinner:setActiveTab(tabName)
				else
					Skinner:setInactiveTab(tabName)
				end
			end
			if i == 1 then Skinner:moveObject(tabName, nil, nil, "-", 69)
			else Skinner:moveObject(tabName, "+", 14, nil, nil) end
		end

	end

	for i = 1, 4 do
		local tabName = _G["FishingBuddyFrameTab"..i]
		local tabNameText = _G["FishingBuddyFrameTab"..i.."Text"]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		if self.db.profile.TexturedTab then self:applySkin(tabName, nil, 0, 1)
		else self:applySkin(tabName) end
		self:moveObject(tabNameText, nil, nil, "-", 2)
	end
	-- hook these to handle tab movement
	self:SecureHook("ToggleFishingBuddyFrame", function(target)
--		self:Debug("TFBF:[%s]", target)
		fbTabs()
	end)
	self:SecureHook("FishingBuddyFrameTab_OnClick", function()
--		self:Debug("FBFT_OC")
		fbTabs()
	end)
	self:SecureHook("FishingBuddyFrame_OnShow", function()
--		self:Debug("FBF_OS")
		fbTabs()
	end)

end

function Skinner:FBOutfitDisplayFrame()

	self:keepFontStrings(FishingOutfitFrame)
	self:moveObject(FishingOutfitSwitchButton, nil, nil, "+", 20)
	self:moveObject(FishingOutfitFrameHeadSlot, "-", 6, "+", 10)
	self:moveObject(FishingOutfitFrameHandsSlot, "-", 6, "+", 10)
	self:moveObject(FishingOutfitFrameMainHandSlot, nil, nil, "-", 64)
	FishingOutfitFrameModelRotateLeftButton:Hide()
	FishingOutfitFrameModelRotateRightButton:Hide()
	self:makeMFRotatable(FishingOutfitFrameModel)

end

function Skinner:FBTrackingFrame()

	self:keepFontStrings(FishingTrackingFrame)

end
