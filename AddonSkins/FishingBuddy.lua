local aName, aObj = ...
if not aObj:isAddonEnabled("FishingBuddy") then return end

function aObj:FishingBuddy()

	self:addSkinFrame{obj=FishingBuddyFrame, kfs=true, x1=10, y1=-13, x2=-31, y2=69}
-->>--	Locations Frame
	self:keepFontStrings(FishingLocationsFrame)
	self:keepFontStrings(FishingLocationExpandButtonFrame)
	self:skinScrollBar{obj=FishingLocsScrollFrame}
	-- m/p buttons
	if self.modBtns then
		-- hook to manage changes to button textures
		self:SecureHook(FishingBuddy.Locations, "Update", function(...)
			for i = 1, 21 do
				self:checkTex(_G["FishingLocations"..i])
			end
			self:checkTex(FishingLocationsCollapseAllButton)
		end)
	end
	for i = 1, 21 do
		self:skinButton{obj=_G["FishingLocations"..i], mp=true}
	end
	-- mp button is already skinned
	local btn = self.sBtn[FishingLocationsCollapseAllButton]
	btn:SetAllPoints(FishingLocationsCollapseAllButton:GetNormalTexture())
	btn:SetNormalFontObject(self.modUIBtns.fontP)
	btn:SetText(self.modUIBtns.minus)

-->>--	Options Frame
	self:keepFontStrings(FishingOptionsFrame)
	if not FishingBuddyOption_EasyCastKeys then
		self:SecureHook(FishingBuddy, "Initialize", function(this)
			self:Debug("FB_Initialize")
			self:skinDropDown{obj=FishingBuddyOption_EasyCastKeys}
			self:Unhook(FishingBuddy, "Initialize")
		end)
	else
		self:skinDropDown{obj=FishingBuddyOption_EasyCastKeys}
	end
	self:skinDropDown{obj=FBOutfitManagerMenu}
	-- Pets
	self:skinDropDown{obj=FishingPetFrame}
	self:skinScrollBar{obj=FishingPetsMenu}
	self:addSkinFrame{obj=FishingPetsMenuHolder, kfs=true}

	local tabObj, tabSF
-->>-- FishingWatch Tab
	self:keepRegions(FishingWatchTab, {4, 5}) -- N.B. region 4 is text, 5 is highlight
	tabSF = self:addSkinFrame{obj=FishingWatchTab, noBdr=self.isTT, x1=2, y1=-4, x2=-2, y2=0}
	if self.isTT then self:setActiveTab(tabSF) end

-->>-- Tabs (side)
	for i = 1, 6 do -- allow for 5 tabs (inc. Outfit & Tracking plugins)
		tabObj = _G["FishingBuddyOptionTab"..i]
		if tabObj then
			self:removeRegions(tabObj, {1}) -- N.B. other regions are icon and highlight
		end
	end

-->>--	Tabs (bottom)
	for i = 1, FishingBuddyFrame.numTabs do
		tabObj = _G["FishingBuddyFrameTab"..i]
		self:keepRegions(tabObj, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		tabSF = self:addSkinFrame{obj=tabObj, noBdr=self.isTT, x1=6, y1=-2, x2=-6, y2=2}
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end
    self.tabFrames[FishingBuddyFrame] = true

end

if aObj:isAddonEnabled("FB_OutfitDisplayFrame") then
	function aObj:FB_OutfitDisplayFrame()

		self:keepFontStrings(FishingOutfitFrame)
		self:skinButton{obj=FishingOutfitSwitchButton}
		self:makeMFRotatable(FishingOutfitFrameModel)

	end
end

if aObj:isAddonEnabled("FB_TrackingFrame") then
	function aObj:FB_TrackingFrame()

		self:keepFontStrings(FishingTrackingFrame)
		self:skinScrollBar{obj=FishingTrackingScrollFrame}

	end
end
