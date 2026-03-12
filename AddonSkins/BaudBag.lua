local _, aObj = ...
if not aObj:isAddonEnabled("BaudBag") then return end
local _G = _G

aObj.addonsToSkin.BaudBag = function(self) -- v 12.0.0.2
	if not self.db.profile.ContainerFrames.skin then return end

	local bsTab
	self:SecureHook(_G.BaudBag, "Container_Updated", function(this, bagSet, _)
		for i = 1, this.Sets[bagSet.Id].MaxContainerNumber do
			bsTab = this.Sets[bagSet.Id].Containers[i]
			self:keepFontStrings(bsTab.Frame.Backdrop.Textures)
			if not bsTab.Frame.Backdrop.sf then
				self:skinObject("frame", {obj=bsTab.Frame.Backdrop, kfs=true, ofs=0})
				if self.modBtns then
					self:skinCloseButton{obj=bsTab.Frame.CloseButton}
					self:skinExpandButton{obj=bsTab.Frame.MenuButton, sap=true, plus=true}
				end
			end
		end
	end)
	self:skinObject("frame", {obj=_G.BaudBagContainer1_1BagsFrame, ofs=0})
	self:skinObject("frame", {obj=_G.BaudBagContainer2_1BagsFrame, ofs=0})
	if self.modBtns then
		self:skinStdButton{obj=_G.BaudBagBankSlotPurchaseButton, sechk=true}
	end
	if self.modBtnBs then
		self:addButtonBorder{obj=_G.BaudBagContainer1_1.BagsButton, ofs=-1, x1=0, y1=-1}
		self:addButtonBorder{obj=_G.BaudBagContainer2_1.BagsButton, ofs=-1, x1=0, y1=-1}
	end
	-- SearchFrame
	self:skinObject("editbox", {obj=_G.BaudBagSearchFrame.EditBox, ofs=4})
	self:skinObject("frame", {obj=_G.BaudBagSearchFrame.Backdrop, kfs=true, ofs=0, y2=23})
	if self.modBtns then
		self:skinCloseButton{obj=_G.BaudBagSearchFrame.CloseButton}
	end
	-- hook this to remove search frame textures each time it is displayed
	self:SecureHook("BaudBagSearchFrame_ShowFrame", function(_)
		self:keepFontStrings(_G.BaudBagSearchFrame.Backdrop.Textures)
	end)

	local function skinCB(cBtn)
		aObj:skinCheckButton{obj=cBtn}
		cBtn:SetWidth(26)
	end
	local function skinContainers()
		for i = 1, 7 do
			aObj:skinCheckButton{obj=_G["BaudBagOptionsJoinCheck" .. i]}
			aObj:skinObject("frame", {obj=_G["BaudBagOptionsContainer" .. i], kfs=true, fb=true, ofs=0})
		end
	end
	self.RegisterCallback("BaudBag", "SettingsPanel_DisplayCategory", function(_, panel)
		if panel.name ~= "Baud Bag" then return end
		self.spSkinnedPanels[panel] = true

		self:skinObject("slider", {obj=panel.GroupGlobal.Slider1})
		if self.modBtns then
			self:skinStdButton{obj=panel.GroupGlobal.ResetPositionsButton}
		end
		if self.modChkBtns then
			skinCB(panel.GroupGlobal.CheckButton1)
			skinCB(panel.GroupGlobal.CheckButton2)
			skinCB(panel.GroupGlobal.CheckButton3)
			skinCB(panel.GroupGlobal.CheckButton4)
			skinCB(panel.GroupGlobal.CheckButton5)
			skinCB(panel.GroupGlobal.CheckButton6)
		end

		self:skinObject("tabs", {obj=panel.GroupContainer, tabs=panel.GroupContainer.tabButtons, ignoreSize=true, lod=self.isTT and true, upwards=true, regions={4}, offsets={x1=6, y1=-6, x2=-6, y2=-6}, track=false, func=self.isTT and function(tab)
				aObj:SecureHook(tab, "UpdateAtlas", function(tObj)
					if tObj:IsSelected() then
						aObj:setActiveTab(tObj.sf)
					else
						aObj:setInactiveTab(tObj.sf)
					end
				end)
			end})
		skinContainers()
		self:skinObject("editbox", {obj=panel.GroupContainer.BagSet.NameInput})
		self:skinObject("slider", {obj=panel.GroupContainer.BagSet.Slider1})
		self:skinObject("slider", {obj=panel.GroupContainer.BagSet.Slider2})
		self:skinObject("frame", {obj=panel.GroupContainer.BagSet, kfs=true, fb=true, ofs=0})

		if self.modBtns then
			self:skinStdButton{obj=panel.GroupContainer.BagSet.BackgroundSelection.Dropdown, ignoreHLTex=true, sechk=true, y1=1, y2=-1}
			self:skinStdButton{obj=panel.GroupContainer.BagSet.ResetPositionButton}
		end
		if self.modChkBtns then
			skinCB(panel.GroupContainer.BagSet.EnabledCheck)
			self:moveObject{obj=panel.GroupContainer.BagSet.LinkedSet, x=50}
			skinCB(panel.GroupContainer.BagSet.CloseAllCheck)
			skinCB(panel.GroupContainer.BagSet.CheckButton1)
			skinCB(panel.GroupContainer.BagSet.CheckButton2)
			skinCB(panel.GroupContainer.BagSet.CheckButton3)
		end

		self.UnregisterCallback("BaudBag", "SettingsPanel_DisplayCategory")
	end)

end
