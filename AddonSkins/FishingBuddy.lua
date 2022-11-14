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
end

aObj.addonsToSkin.FishingBuddy = function(self) -- v 1.19 Beta 2/0.8.4

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
		if not self.isRtl then
			_G.FishingLocationExpandButtonFrame:DisableDrawLayer("BACKGROUND")
			self:skinObject("slider", {obj=_G.FishingLocsScrollFrame.ScrollBar, rpTex="background"})
		else
			self:skinObject("scrollbar", {obj=this.ScrollBar})
			if self.modBtns then
				local function skinElement(...)
					local _, element
					if _G.select("#", ...) == 2 then
						element, _ = ...
					elseif _G.select("#", ...) == 3 then
						_, element, _ = ...
					end
					self:skinExpandButton{obj=element.Container.ExpandOrCollapseButton, onSB=true, plus=true}
				end
				_G.ScrollUtil.AddInitializedFrameCallback(this.ScrollBox, skinElement, aObj, true)
			end
		end
		if self.modBtns then
			self:skinStdButton{obj=_G.FishingLocationsSwitchButton}
			-- m/p buttons
			if not aObj.isRtl then
				self:SecureHook(_G.FishingBuddy.Locations, "Update", function(_)
					for i = 1, 22 do
						self:skinExpandButton{obj=_G["FishingLocations" .. i], onSB=true}
					end
					self:skinExpandButton{obj=_G.FishingLocationsCollapseAllButton, onSB=true}
				end)
			end
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
			-- tooltip
			_G.C_Timer.After(0.1, function()
				self:add2Table(self.ttList, _G.FishingOutfitTooltip)
			end)
			-- Options
			if self.modChkBtns then
				-- hook this to skin checkbuttons
				self:SecureHook(_G.OptionsOutfits, "LayoutOptions", function(fObj, _)
					skinCBs("OptionsOutfitsOpt")
					self:Unhook(fObj, "LayoutOptions")
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
		if self.modChkBtns then
			self:SecureHook(_G.FishingBuddy, "OptionsUpdate", function(this, _)
				skinCBs("FishingOptionsFrameOpt")
			end)
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

		-- tooltip
		_G.C_Timer.After(0.1, function()
			self:add2Table(self.ttList, _G.FishingOutfitTooltip)
		end)

		-- Options
		if self.modChkBtns then
			-- hook this to skin checkbuttons
			self:SecureHook(_G.OptionsOutfits, "LayoutOptions", function(this, _)
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
