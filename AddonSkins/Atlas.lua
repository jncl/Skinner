local _, aObj = ...
if not aObj:isAddonEnabled("Atlas") then return end
local _G = _G

aObj.addonsToSkin.Atlas = function(self) -- v3.15.9

	self:SecureHookScript(_G.AtlasFrame, "OnShow", function(this)
		self:skinObject("ddbutton", {obj=_G.AtlasFrameDropDownType})
		self:skinObject("ddbutton", {obj=_G.AtlasFrameDropDown})
		self:removeInset(this.MapFrame)
		-- make sure map texture is visible
		this.MapFrame:SetFrameStrata("HIGH")
		_G.AtlasFrameCollapseButton:SetFrameStrata("HIGH")
		self:removeInset(_G.AtlasFrameTopInset)
		self:removeInset(_G.AtlasFrameBottomInset)
		self:skinObject("scrollbar", {obj=_G.AtlasFrameBottomInset.ScrollBox.registeredScrollBar, x1=2, x2=4})
		self:skinObject("ddbutton", {obj=_G.AtlasFrameSwitchDropdown})
		self:skinObject("editbox", {obj=_G.AtlasSearchEditBox, si=true, y1=-4, y2=4})
		self:skinObject("frame", {obj=this, kfs=true, cb=true, y1=5})
		if self.modBtns then
			_G.AtlasFrameCloseButton:SetSize(28, 28)
			-- TODO: skin LockButton
			-- self:skinStdButton{obj=_G.AtlasFrameLockButton}
			self:skinStdButton{obj=_G.AtlasFrameOptionsButton}
			self:skinOtherButton{obj=_G.AtlasFrameCollapseButton, font=self.fontS, text=self.larrow}
			self:skinStdButton{obj=_G.AtlasFrameSwitchButton}
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.AtlasFrameLFGButton, clr="gold", ofs=-1, x1=0}
			self:addButtonBorder{obj=_G.AtlasFramePrevNextContainer.NextMap, ofs=-2, x1=1, clr="gold", schk=true}
			self:addButtonBorder{obj=_G.AtlasFramePrevNextContainer.PrevMap, ofs=-2, x1=1, clr="gold", schk=true}
			self:addButtonBorder{obj=this.AdventureJournalMap}
			self:addButtonBorder{obj=this.AdventureJournal}
			self:addButtonBorder{obj=this.AtlasLoot}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.AtlasFrameSmall, "OnShow", function(this)
		self:skinObject("ddbutton", {obj=_G.AtlasFrameSmallDropDownType})
		self:skinObject("ddbutton", {obj=_G.AtlasFrameSmallDropDown})
		self:removeInset(this.MapFrame)
		-- make sure map texture is visible
		this.MapFrame:SetFrameStrata("HIGH")
		_G.AtlasFrameSmallExpandButton:SetFrameStrata("HIGH")
		self:skinObject("ddbutton", {obj=_G.AtlasFrameSmallSwitchDropdown})
		self:skinObject("frame", {obj=this, kfs=true, cb=true--[[, x1=10, y1=-10]]})
		if self.modBtns then
			-- TODO: skin LockButton
			-- self:skinStdButton{obj=_G.AtlasFrameSmallLockButton}
			self:skinStdButton{obj=_G.AtlasFrameSmallOptionsButton}
			self:skinOtherButton{obj=_G.AtlasFrameSmallExpandButton, font=self.fontS, text=self.rarrow}
			self:skinStdButton{obj=_G.AtlasFrameSmallSwitchButton}
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.AtlasFrameSmallPrevNextContainer.NextMap, ofs=-2, x1=1, clr="gold", schk=true}
			self:addButtonBorder{obj=_G.AtlasFrameSmallPrevNextContainer.PrevMap, ofs=-2, x1=1, clr="gold", schk=true}
			self:addButtonBorder{obj=this.AdventureJournalMap}
			self:addButtonBorder{obj=this.AdventureJournal}
			self:addButtonBorder{obj=this.AtlasLoot}
		end

		self:Unhook(this, "OnShow")
	end)


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

	if _G.Atlas.WorldMap
	and _G.AtlasToggleFromWorldMap
	then
		_G.AtlasToggleFromWorldMap.Border:SetTexture(nil)
	end

end
