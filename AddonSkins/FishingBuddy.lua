local _, aObj = ...
if not aObj:isAddonEnabled("FishingBuddy") then return end
local _G = _G

local function skinCBs(objPrefix)
	local obj
	for i = 1, 20 do
		obj = _G[objPrefix .. i]
		if obj then
			aObj:skinCheckButton{obj=obj}
		end
	end
	obj = nil
end

aObj.addonsToSkin.FishingBuddy = function(self) -- v 1.16.5/0.7.5.5/0.7.3 Beta 5

	self:SecureHookScript(_G.FishingBuddyFrame, "OnShow", function(this)
		self:skinObject("tabs", {obj=this, tabs=this.Tabs, lod=self.isTT and true})
		self:skinObject("frame", {obj=this, kfs=true, ri=true, rns=true, cb=true, ofs=2, x2=1, y2=-5})

		self:Unhook(this, "OnShow")
		if self.isTT then
			-- force corrct tab to be indicated
			this:Hide()
			this:Show()
		end
	end)

	self:SecureHookScript(_G.FishingLocationsFrame, "OnShow", function(this)
		_G.FishingLocationExpandButtonFrame:DisableDrawLayer("BACKGROUND")
		self:skinSlider{obj=_G.FishingLocsScrollFrame.ScrollBar, rt="background"}
		-- m/p buttons
		if self.modBtns then
			self:skinStdButton{obj=_G.FishingLocationsSwitchButton}
			self:SecureHook(_G.FishingBuddy.Locations, "Update", function(...)
				for i = 1, 22 do
					self:skinExpandButton{obj=_G["FishingLocations" .. i], onSB=true, plus=true}
				end
				self:skinExpandButton{obj=_G.FishingLocationsCollapseAllButton, onSB=true, plus=true}
			end)
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.FishingBuddyOptionSLZ}
		end

		self:Unhook(this, "OnShow")
	end)

	if not self.isRtl then
		self:SecureHookScript(_G.FishingOutfitFrameTab, "OnShow", function(this)
			for _, btn in _G.ipairs{this.Outfit:GetChildren()} do
				if btn:GetName():find("Skill") then break end
				if btn:IsObjectType("CheckButton")
				and self.modChkBtns
				then
					self:skinCheckButton{obj=btn}
				elseif btn:IsObjectType("Button") then
					btn:DisableDrawLayer("BACKGROUND")
					if btn ~= _G.FBOutfitFrameAmmoSlot then
						if self.modBtnBs then
							self:addButtonBorder{obj=btn, ibt=true, clr="grey"}
						end
					else
						btn:DisableDrawLayer("OVERLAY")
						btn:GetNormalTexture():SetTexture(nil)
						btn:GetPushedTexture():SetTexture(nil)
						if self.modBtnBs then
							self:addButtonBorder{obj=btn, reParent={btn.Count, self:getRegion(btn, 4)}, clr="grey"}
							_G[btn:GetName() .. "IconTexture"] = _G.CharacterAmmoSlotIconTexture
						end
					end
				end
			end
			if self.modBtns then
				self:skinStdButton{obj=this.Switch}
			end
			self:makeMFRotatable(_G.FBOutfitFrameModelFrame)
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

			self:Unhook(this, "OnShow")
		end)
	end

	self:SecureHookScript(_G.FishingOptionsFrame, "OnShow", function(this)
		self:keepFontStrings(this)
		self:skinObject("slider", {obj=_G.FishingBuddyOption_MaxVolumeSlider})
		self:skinObject("dropdown", {obj=_G.FBOutfitManagerMenu})
		self:skinObject("dropdown", {obj=_G.FBMouseEventMenu})
		self:skinObject("dropdown", {obj=_G.FBEasyKeysMenu})
		if self.isRtl then
			self:skinObject("dropdown", {obj=_G.FishingBobbers})
			self:skinObject("dropdown", {obj=_G.FishingPets})
		end
		-- Tabs (side)
		local tabObj
		for i = 1, 6 do -- allow for 6 tabs (inc. Tracking plugin)
			tabObj = _G["FishingOptionsFrameTab" .. i]
			if tabObj then
				self:removeRegions(tabObj, {1}) -- N.B. other regions are icon and highlight
				if self.modBtnBs then
					self:addButtonBorder{obj=tabObj}
				end
			end
		end
		tabObj = nil
		if self.modChkBtns then
			skinCBs("FishingOptionsFrameOpt")
		end
		
		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.FishingWatchFrame, "OnShow", function(this)
		self:keepRegions(_G.FishingWatchTab, {4, 5}) -- N.B. region 4 is text, 5 is highlight
		self:skinObject("frame", {obj=_G.FishingWatchTab, noBdr=self.isTT, x1=2, y1=-4, x2=-2, y2=0})
		if self.isTT then
			self:setActiveTab(_G.FishingWatchTab.sf)
		end
		
		self:Unhook(this, "OnShow")
	end)

end

if aObj.isRtl then
	aObj.addonsToSkin.FB_OutfitDisplayFrame = function(self) -- v 1.9.8

		-- FishingOutfit Frame
		for _, child in _G.ipairs{_G.FBOutfitFrame:GetChildren()} do
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

		if self.modBtns then
			 self:skinStdButton{obj=_G.FishingOutfitFrameTab.Switch}
		end

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
end
