local aName, aObj = ...
if not aObj:isAddonEnabled("FishingBuddy") then return end
local _G = _G

local function skinCBs(objPrefix)
	for i = 1, 20 do
		obj = _G[objPrefix .. i]
		if obj then
			aObj:skinCheckButton{obj=obj}
		end
	end
end

aObj.addonsToSkin.FishingBuddy = function(self) -- v 1.9.8

	--	Locations Frame
	self:skinStdButton{obj=_G.FishingLocationsSwitchButton}
	self:skinCheckButton{obj=_G.FishingBuddyOptionSLZ}
	_G.FishingLocationExpandButtonFrame:DisableDrawLayer("BACKGROUND")
	self:skinSlider{obj=_G.FishingLocsScrollFrame.ScrollBar, rt="background"}
	-- m/p buttons
	if self.modBtns then
		local function checkTex(obj)
			local nTex = obj:GetNormalTexture() and obj:GetNormalTexture():GetTexture() or nil
			if nTex then
				if nTex:find("MinusButton") then
					aObj:changeMinusPlusTex(obj, true)
				else
					aObj:changeMinusPlusTex(obj, false)
				end
			end
			nTex = nil
		end
		-- hook to manage changes to button textures
		self:SecureHook(_G.FishingBuddy.Locations, "Update", function(...)
			for i = 1, 22 do
				checkTex(_G["FishingLocations" .. i])
			end
			checkTex(_G.FishingLocationsCollapseAllButton)
		end)
	end

	--	Options Frame
	self:keepFontStrings(_G.FishingOptionsFrame)
	-- General Tab
	self:skinSlider{obj=_G.FishingBuddyOption_MaxVolumeSlider}
	self:skinDropDown{obj=_G.FBOutfitManagerMenu}
	-- Fishing Tab
	self:skinDropDown{obj=_G.FBMouseEventMenu}
	self:skinDropDown{obj=_G.FBEasyKeysMenu}
	self:skinDropDown{obj=_G.FishingBobbers}
	-- Watcher Tab
	-- Fishing Fun Tab
	self:skinDropDown{obj=_G.FishingPets}
	-- About Tab

	-- Tabs (side)
	local tabObj
	for i = 1, 6 do -- allow for 6 tabs (inc. Tracking plugin)
		tabObj = _G["FishingOptionsFrameTab" .. i]
		if tabObj then
			self:removeRegions(tabObj, {1}) -- N.B. other regions are icon and highlight
			self:addButtonBorder{obj=tabObj}
		end
	end
	tabObj = nil

	if self.modChkBtns then
		-- hook this to skin checkbuttons
		self:SecureHook(_G.FishingOptionsFrame, "LayoutOptions", function(this, options)
			skinCBs("FishingOptionsFrameOpt")
			self:Unhook(this, "LayoutOptions")
		end)
	end

	-- Tabs (bottom)
	self:skinTabs{obj=_G.FishingBuddyFrame}
	-- make tabs appear above skin frame
	for i = 1, _G.FishingBuddyFrame.numTabs do
		_G.RaiseFrameLevel(_G["FishingBuddyFrameTab" .. i])
	end

	self:addSkinFrame{obj=_G.FishingBuddyFrame, ft="a", kfs=true, ri=true, ofs=2, x2=1, y2=-5}

	-- FishingWatch Frame
	self:keepRegions(_G.FishingWatchTab, {4, 5}) -- N.B. region 4 is text, 5 is highlight
	local tabSF = self:addSkinFrame{obj=_G.FishingWatchTab, ft="a", nb=true, noBdr=self.isTT, x1=2, y1=-4, x2=-2, y2=0}
	if self.isTT then self:setActiveTab(tabSF) end
	tabSF = nil

end

aObj.addonsToSkin.FB_OutfitDisplayFrame = function(self) -- v 1.9.8

	-- FishingOutfit Frame
	for _, child in ipairs{_G.FBOutfitFrame:GetChildren()} do
		if child:GetName():find("Skill") then break end
		if child:IsObjectType("CheckButton") then
			self:skinCheckButton{obj=child}
		elseif child:IsObjectType("Button") then
			child:DisableDrawLayer("BACKGROUND")
			if self.modBtnBs then
				self:addButtonBorder{obj=child, ibt=true}
			end
		end
	end
	_G.FBOutfitFrameModel:DisableDrawLayer("BACKGROUND")
	_G.FBOutfitFrameModel:DisableDrawLayer("BORDER")
	_G.FBOutfitFrameModel:DisableDrawLayer("OVERLAY")
	_G.FBOutfitFrameModel.controlFrame:DisableDrawLayer("BACKGROUND")

	self:skinStdButton{obj=_G.FishingOutfitFrameTab.Switch}

	-- Tabs (side)
	local tabObj
	for i = 1, 2 do
		tabObj = _G["ManagedOutfitsTab" .. i]
		if tabObj then
			self:removeRegions(tabObj, {1}) -- N.B. other regions are icon and highlight
			self:addButtonBorder{obj=tabObj}
		end
	end
	tabObj = nil

	-- tooltip
	_G.C_Timer.After(0.1, function()
		self:add2Table(self.ttList, _G.FishingOutfitTooltip)
	end)

	-- Options
	if self.modChkBtns then
		-- hook this to skin checkbuttons
		self:SecureHook(_G.OptionsOutfits, "LayoutOptions", function(this, options)
			skinCBs("OptionsOutfitsOpt")
			self:Unhook(this, "LayoutOptions")
		end)
	end

end

aObj.addonsToSkin.FB_TrackingFrame = function(self) -- v 1.9.1

	_G.FishingTrackingFrame:DisableDrawLayer("BACKGROUND")

	-- _G.FishingTrackingChooser
	self:skinSlider{obj=_G.FishingTrackingScrollFrame.ScrollBar, rt="background"}--, wdth=-4, size=3, hgt=-10}

	-- option tab
	for i = 1, 16 do
		self:skinCheckButton{obj=_G["FishingTracking" .. i .. "Hourly"]}
		self:skinCheckButton{obj=_G["FishingTracking" .. i .. "Weekly"]}
	end

	-- Tabs (side)
	local tabObj
	for i = 1, 3 do
		tabObj = _G["ManagedLocationsTab" .. i]
		if tabObj then
			self:removeRegions(tabObj, {1}) -- N.B. other regions are icon and highlight
			self:addButtonBorder{obj=tabObj}
		end
	end
	tabObj = nil

	-- Options
	if self.modChkBtns then
		-- hook this to skin checkbuttons
		self:SecureHook(_G.OptionsLocations, "LayoutOptions", function(this)
			skinCBs("OptionsLocationsOpt")
			self:Unhook(this, "LayoutOptions")
		end)
	end

end
