local _, aObj = ...
if not aObj:isAddonEnabled("TLDRMissions") then return end
local _G = _G

aObj.addonsToSkin.TLDRMissions = function(self) -- v9.2-138

	self:SecureHookScript(_G.TLDRMissionsFollowerList, "OnShow", function(this)
		function skinFollower(frame)
			frame.BG:SetTexture(nil)
			if frame.AbilitiesBG then
				frame.AbilitiesBG:SetTexture(nil)
			end
			if frame.PortraitFrame then
				frame.PortraitFrame.TroopStackBorder1:SetTexture(nil)
				frame.PortraitFrame.TroopStackBorder2:SetTexture(nil)
				aObj:nilTexture(frame.PortraitFrame.PuckBorder, true)
				frame.PortraitFrame.PortraitRingQuality:SetTexture(nil)
				frame.PortraitFrame.PortraitRingCover:SetTexture(nil)
				aObj:changeTandC(frame.PortraitFrame.LevelCircle)
				aObj:changeTex2SB(frame.PortraitFrame.HealthBar.Health)
				frame.PortraitFrame.HealthBar.Border:SetTexture(nil)
			end
			if aObj.modBtnBs then
				for _, fObj in _G.pairs(frame.Counters) do
					aObj:addButtonBorder{obj=fObj, fType=ftype, relTo=frame.Icon, clr="white"}
				end
			end
		end
		self:skinObject("editbox", {obj=this.SearchBox, fType=ftype, si=true})
		self:moveObject{obj=this.SearchBox, x=-10}
		self:removeRegions(this, {1, 2, not this.isLandingPage and 3})
		self:skinObject("slider", {obj=this.listScroll.scrollBar, fType=ftype, y1=-2, y2=2})
		self:skinObject("frame", {obj=this.listScroll, fType=ftype, fb=true, ofs=6, y1=5, y2=-8, clr="sepia"})
		if not this.listScroll.buttons then
			self:SecureHook(this, "Initialize", function(this, _)
				for _, btn in _G.pairs(this.listScroll.buttons) do
					skinFollower(btn.Follower)
				end
				self:Unhook(this, "Initialize")
			end)
		else
			for _, btn in _G.pairs(this.listScroll.buttons) do
				skinFollower(btn.Follower)
			end
		end

		self:Unhook(this, "OnShow")
	end)

	if self.modBtns then
		self:skinStdButton{obj=_G.TLDRMissionsToggleButton, clr="grey"}
		self:skinStdButton{obj=_G.TLDRMissionsShortcutButton, clr="grey"}
	end

	self:SecureHookScript(_G.TLDRMissionsFrame, "OnShow", function(this)
		local fName = this:GetName()
		self:skinObject("tabs", {obj=this, prefix=this:GetName(), ignoreSize=true, lod=self.isTT and true, upwards=true, regions={7}, offsets={x1=6, y1=0, x2=-6, y2=2}})
		self:skinObject("slider", {obj=this.MinimumTroopsSlider})
		self:skinObject("slider", {obj=this.LowerBoundLevelRestrictionSlider})
		self:skinObject("slider", {obj=this.AnimaCostLimitSlider})
		self:skinObject("slider", {obj=this.SimulationsPerFrameSlider})
		self:skinObject("editbox", {obj=this.MaxSimulationsEditBox})
		self:skinObject("slider", {obj=this.DurationLowerSlider})
		self:skinObject("slider", {obj=this.DurationHigherSlider})
		self:skinObject("frame", {obj=this, kfs=true, cb=true, ofs=0})
		if self.modBtns then
			self:skinStdButton{obj=this.CalculateButton, sechk=true}
			self:skinStdButton{obj=this.AbortButton, sechk=true}
			self:skinStdButton{obj=this.SkipCalculationButton, sechk=true}
			self:skinStdButton{obj=this.StartMissionButton, sechk=true}
			self:skinStdButton{obj=this.SkipMissionButton, sechk=true}
			self:skinStdButton{obj=this.CompleteMissionsButton, sechk=true}
		end
		local btnNames = {"Gold", "Anima", "FollowerXPItems", "PetCharms", "AugmentRunes", "Reputation", "FollowerXP", "CraftingCache", "Runecarver", "Campaign", "Gear", "SanctumFeature", "AnythingForXP", "Sacrifice", "FollowerXPSpecialTreatment", "FollowerXPSpecialTreatmentAlgorithm"}
		for _, bName in _G.pairs(btnNames) do
			if _G["TLDRMissions" .. bName .. "AnimaCostDropDown"] then
				self:keepFontStrings(_G["TLDRMissions" .. bName .. "AnimaCostDropDown"])
			end
			if _G["TLDRMissions" .. bName .. "DropDown"] then
				self:keepFontStrings(_G["TLDRMissions" .. bName .. "DropDown"])
			end
		end
		if self.modBtnBs then
			 for _, bName in _G.pairs(btnNames) do
				 if _G["TLDRMissions" .. bName .. "AnimaCostDropDown"] then
					 self:addButtonBorder{obj=_G["TLDRMissions" .. bName .. "AnimaCostDropDownButton"], clr="grey", ofs=-1, x1=0, y1=0}
				 end
				 if _G["TLDRMissions" .. bName .. "DropDown"] then
					 self:addButtonBorder{obj=_G["TLDRMissions" .. bName .. "DropDownButton"], clr="grey", ofs=-1, x1=0, y1=0}
				 end
			 end
		end
		if self.modChkBtns then
			 for _, bName in _G.pairs(btnNames) do
				 if _G[fName .. bName .. "CheckButton"] then
					 self:skinCheckButton{obj=_G[fName .. bName .. "CheckButton"]}
				 end
			 end
			self:skinCheckButton{obj=_G[fName .. "AutoShowButton"]}
			self:skinCheckButton{obj=_G[fName .. "AllowProcessingAnywhereButton"]}
			self:skinCheckButton{obj=_G[fName .. "AutoStartButton"]}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.TLDRMissionsFrame.ProfileTabButton, "OnClick", function(this)
		self.RegisterCallback("TLDRMissions", "UIParent_GetChildren", function(this, child)
			if child.height
			and child.height == 500
			and child.width
			and child.width == 700
			and child:GetNumChildren() == 7
			then
				self:skinAceOptions(child)
				self.UnregisterCallback("TLDRMissions", "UIParent_GetChildren")
			end
		end)
		self:scanUIParentsChildren()

		self:Unhook(this, "OnClick")
	end)

	self.RegisterCallback("TLDRMissions", "IOFPanel_Before_Skinning", function(this, panel)
		if panel.name ~= "TLDRMissions" then return end
		self.iofSkinnedPanels[panel] = true

		self:skinAceOptions(panel.obj)

		self.UnregisterCallback("TLDRMissions", "IOFPanel_Before_Skinning")
	end)

end
