local aName, aObj = ...
if not aObj:isAddonEnabled("FishingBuddy") then return end
local _G = _G

function aObj:FishingBuddy()

	self:addSkinFrame{obj=_G.FishingBuddyFrame, kfs=true, ri=true, bgen=1, ofs=2, y2=-4} -- N.B. bgen=1 so locations frame mp buttons aren't skinned here

-->>--	Locations Frame
	self:keepFontStrings(_G.FishingLocationsFrame)
	self:keepFontStrings(_G.FishingLocationExpandButtonFrame)
	self:skinScrollBar{obj=_G.FishingLocsScrollFrame}
	-- m/p buttons
	if self.modBtns then
		-- hook to manage changes to button textures
		self:SecureHook(_G.FishingBuddy.Locations, "Update", function(...)
			for i = 1, 21 do
				self:checkTex(_G["FishingLocations"..i])
			end
			self:checkTex(_G.FishingLocationsCollapseAllButton)
		end)
		-- skin location mp buttons
		for i = 1, 21 do
			self:skinButton{obj=_G["FishingLocations"..i], mp=true}
		end
		-- CollapseAll button
		self:skinButton{obj=_G.FishingLocationsCollapseAllButton, mp=true}
	end

-->>--	Options Frame
	self:keepFontStrings(_G.FishingOptionsFrame)
	self:skinDropDown{obj=_G.FBOutfitManagerMenu}
	self:skinDropDown{obj=_G.FBMouseEventMenu}
	self:skinDropDown{obj=_G.FBEasyKeysMenu}
	-- Pets
	self:skinDropDown{obj=_G.FishingPetFrame}
	self:skinSlider{obj=_G.FishingPetsMenu.ScrollBar}
	self:addSkinFrame{obj=_G.FishingPetsMenuHolder, kfs=true}

	local tabObj, tabSF
-->>-- FishingWatch Tab
	self:keepRegions(_G.FishingWatchTab, {4, 5}) -- N.B. region 4 is text, 5 is highlight
	tabSF = self:addSkinFrame{obj=_G.FishingWatchTab, noBdr=self.isTT, x1=2, y1=-4, x2=-2, y2=0}
	if self.isTT then self:setActiveTab(tabSF) end

-->>-- Tabs (side)
	for i = 1, 6 do -- allow for 6 tabs (inc. Outfit & Tracking plugins)
		tabObj = _G["FishingBuddyOptionTab"..i]
		if tabObj then
			self:removeRegions(tabObj, {1}) -- N.B. other regions are icon and highlight
		end
	end

-->>-- Tabs (bottom)
	self:skinTabs{obj=_G.FishingBuddyFrame}

end

if aObj:isAddonEnabled("FB_OutfitDisplayFrame") then
	function aObj:FB_OutfitDisplayFrame()

		self:keepFontStrings(_G.FishingOutfitFrame)
		self:skinButton{obj=_G.FishingOutfitSwitchButton}
		self:makeMFRotatable(_G.FishingOutfitFrameModel)

	end
end

if aObj:isAddonEnabled("FB_TrackingFrame") then
	function aObj:FB_TrackingFrame()

		self:keepFontStrings(_G.FishingTrackingFrame)
		self:skinScrollBar{obj=_G.FishingTrackingScrollFrame}

	end
end
