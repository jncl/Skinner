
function Skinner:FishingBuddy()

	self:addSkinFrame{obj=FishingBuddyFrame, kfs=true, x1=10, y1=-13, x2=-31, y2=69}
-->>--	Locations Frame
	self:keepFontStrings(FishingLocationsFrame)
	self:keepFontStrings(FishingLocationExpandButtonFrame)
	self:skinScrollBar{obj=FishingLocsScrollFrame}
-->>--	Options Frame
	self:keepFontStrings(FishingOptionsFrame)
	self:skinDropDown{obj=FishingBuddyOption_EasyCastKeys}
	self:skinDropDown{obj=FishingBuddyOption_OutfitMenu}
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

		for i = 1, FishingBuddyFrame.numTabs do
			local tabName = _G["FishingBuddyFrameTab"..i]
			if Skinner.db.profile.TexturedTab then
				if i == FishingBuddyFrame.selectedTab then
					Skinner:setActiveTab(tabName)
				else
					Skinner:setInactiveTab(tabName)
				end
			end
			if i == 1 then Skinner:moveObject{obj=tabName, x=4}
			else Skinner:moveObject{obj=tabName, x=14} end
		end

	end

	for i = 1, FishingBuddyFrame.numTabs do
		local tabName = _G["FishingBuddyFrameTab"..i]
		local tabNameText = _G["FishingBuddyFrameTab"..i.."Text"]
		self:keepRegions(tabName, {7, 8}) -- N.B. region 7 is the Text, 8 is the highlight
		if self.db.profile.TexturedTab then self:applySkin(tabName, nil, 0, 1)
		else self:applySkin(tabName) end
		self:moveObject(tabNameText, nil, nil, "-", 2)
	end
	-- hook these to handle tab movement
	self:SecureHook("ToggleFishingBuddyFrame", function(target)
		fbTabs()
	end)
	self:SecureHook("FishingBuddyFrameTab_OnClick", function()
		fbTabs()
	end)
	self:SecureHook("FishingBuddyFrame_OnShow", function()
		fbTabs()
	end)

end
