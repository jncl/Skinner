local _, aObj = ...
if not aObj:isAddonEnabled("Atlas") then return end
local _G = _G

aObj.addonsToSkin.Atlas = function(self) -- v1.49.02/v1.49.01

	self:SecureHookScript(_G.AtlasFrame, "OnShow", function(this)
		self:skinObject("dropdown", {obj=_G.AtlasFrameDropDownType})
		self:skinObject("dropdown", {obj=_G.AtlasFrameDropDown})
		self:removeRegions(this, {1, 2, 3, 4})
		self:skinObject("editbox", {obj=_G.AtlasSearchEditBox, y1=-4, y2=4})
		self:skinObject("slider", {obj=_G.AtlasScrollBar.ScrollBar})
		self:skinObject("frame", {obj=this, cb=true, x1=10, y1=-10})
		if self.modBtns then
			-- TODO: skin LockButton
			-- self:skinStdButton{obj=_G.AtlasFrameLockButton}
			self:skinStdButton{obj=_G.AtlasFrameOptionsButton}
			self:skinStdButton{obj=_G.AtlasSwitchButton}
			self:skinStdButton{obj=_G.AtlasSearchButton}
			self:skinStdButton{obj=_G.AtlasSearchClearButton}
			-- .AdventureJournalMap
			-- .AdventureJournal
			-- .AtlasLoot
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=this.NextMap, ofs=-2, x1=1, clr="gold"}
			self:addButtonBorder{obj=this.PrevMap, ofs=-2, x1=1, clr="gold"}
			self:skinOtherButton{obj=_G.AtlasFrameSizeUpButton, font=self.fontS, text=self.nearrow}
			self:skinOtherButton{obj=_G.AtlasFrameCollapseButton, font=self.fontS, text=self.larrow}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.AtlasFrameLarge, "OnShow", function(this)
		self:skinObject("dropdown", {obj=_G.AtlasFrameLargeDropDownType})
		self:skinObject("dropdown", {obj=_G.AtlasFrameLargeDropDown})
		self:removeRegions(this, {1, 2, 3, 4, 5, 6})
		-- .ZoneName
		-- BossButtonFrame
		self:skinObject("frame", {obj=this, cb=true, x1=10, y1=-10})
		if self.modBtns then
			-- TODO: skin LockButton
			-- self:skinStdButton{obj=_G.AtlasFrameLargeLockButton}
			self:skinStdButton{obj=_G.AtlasFrameLargeOptionsButton}
			-- .AdventureJournalMap
			-- .AdventureJournal
			-- .AtlasLoot
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=this.NextMap, ofs=-2, x1=1, clr="gold"}
			self:addButtonBorder{obj=this.PrevMap, ofs=-2, x1=1, clr="gold"}
			self:skinOtherButton{obj=_G.AtlasFrameLargeSizeDownButton, font=self.fontS, text=self.swarrow}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.AtlasFrameSmall, "OnShow", function(this)
		self:skinObject("dropdown", {obj=_G.AtlasFrameSmallDropDownType})
		self:skinObject("dropdown", {obj=_G.AtlasFrameSmallDropDown})
		self:removeRegions(this, {1, 2, 3, 4})
		-- .ZoneName
		self:skinObject("frame", {obj=this, cb=true, x1=10, y1=-10})
		if self.modBtns then
			-- TODO: skin LockButton
			-- self:skinStdButton{obj=_G.AtlasFrameSmallLockButton}
			self:skinStdButton{obj=_G.AtlasFrameSmallOptionsButton}
			-- .AdventureJournalMap
			-- .AdventureJournal
			-- .AtlasLoot
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=this.NextMap, ofs=-2, x1=1, clr="gold"}
			self:addButtonBorder{obj=this.PrevMap, ofs=-2, x1=1, clr="gold"}
			self:skinOtherButton{obj=_G.AtlasFrameSmallExpandButton, font=self.fontS, text=self.rarrow}
			self:skinOtherButton{obj=_G.AtlasFrameSmallSizeUpButton, font=self.fontS, text=self.nearrow}
		end

		self:Unhook(this, "OnShow")
	end)

	_G.AtlasToggleFromWorldMap.Border:SetTexture(nil)

	if self.modBtnBs then
		self.RegisterCallback("Atlas", "EncounterJournal_Skinned", function(_, _)
			if _G.AtlasToggleFromEncounterJournal then
				_G.AtlasToggleFromEncounterJournal:GetNormalTexture():SetTexture([[Interface\WorldMap\WorldMap-Icon]])
				_G.AtlasToggleFromEncounterJournal:SetScale(0.5)
				self:addButtonBorder{obj=_G.AtlasToggleFromEncounterJournal}
				self:moveObject{obj=_G.AtlasToggleFromEncounterJournal, x=-30, y=-15}
			end
		end)
	end

end
