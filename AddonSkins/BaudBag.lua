local aName, aObj = ...
if not aObj:isAddonEnabled("BaudBag") then return end
local _G = _G

aObj.addonsToSkin.BaudBag = function(self) -- v 8.1.0
	if not self.db.profile.ContainerFrames.skin then return end

	-- hook this to skin the bag frames
	self:SecureHook(_G.BaudBag, "Container_Updated", function(this, bagSet, containerId)
		-- aObj:Debug("BaudBag Container_Updated: [%s, %s, %s]", this, bagSet, containerId)
		local bsTab
		for i = 1, this.Sets[bagSet.Id].MaxContainerNumber do
			bsTab = this.Sets[bagSet.Id].Containers[i]
			self:keepFontStrings(bsTab.Frame.Backdrop.Textures)
			if not bsTab.sknd then
				self:addSkinFrame{obj=bsTab.Frame.Backdrop, ft="a", kfs=true, nb=true, ofs=0}
				if self.modBtns then
					self:skinCloseButton{obj=bsTab.Frame.CloseButton}
					self:skinExpandButton{obj=bsTab.Frame.MenuButton, sap=true, plus=true}
				end
				bsTab.sknd = true
			end
		end
	end)

	self:SecureHook("BaudBagSearchFrame_ShowFrame", function(ParentContainer, Scale, Background)
		-- remove searchframe textures each time it is displayed
		self:keepFontStrings(_G.BaudBagSearchFrame.Backdrop.Textures)
	end)

	self:skinDropDown{obj=_G.BaudBagContainerDropDown, x2=-10}
	self:addSkinFrame{obj=_G.BaudBagContainer1_1BagsFrame, ft="a", nb=true, ofs=0}
	self:addSkinFrame{obj=_G.BaudBagContainer2_1BagsFrame, ft="a", nb=true, ofs=0}
	if self.modBtns then
		self:skinStdButton{obj=_G.BaudBagBankSlotPurchaseButton}
	end
	if self.modBtnBs then
		self:addButtonBorder{obj=_G.BaudBagContainer1_1.BagsButton, ofs=-1, x1=0, y1=-1}
		self:addButtonBorder{obj=_G.BaudBagContainer2_1.BagsButton, ofs=-1, x1=0, y1=-1}
	end

	-- SearchFrame
	self:skinEditBox{obj=_G.BaudBagSearchFrame.EditBox, regs={6}}
	-- move editbox and stop it moving
	_G.BaudBagSearchFrame.EditBox:SetPoint("TOPLEFT", 0, 22)
	_G.BaudBagSearchFrame.EditBox.SetPoint = _G.nop
	-- N.B. use bg=true to ensure bagslot icons are above the skinframe
	self:addSkinFrame{obj=_G.BaudBagSearchFrame.Backdrop, ft="a", kfs=true, nb=true, bg=true, ofs=0, y2=23}
	if self.modBtns then
		self:skinCloseButton{obj=_G.BaudBagSearchFrame.CloseButton}
	end

	-- Options Frame
	-- register callback to indicate already skinned
	self.RegisterCallback("BaudBag", "IOFPanel_Before_Skinning", function(this, panel)
		if panel.name ~= "Baud Bag" then return end
		self.iofSkinnedPanels[panel] = true
		self.UnregisterCallback("BaudBag", "IOFPanel_Before_Skinning")
	end)

	self:skinDropDown{obj=_G.BaudBagOptions.GroupContainer.SetSelection, x2=-9}
	self:skinEditBox(_G.BaudBagOptions.GroupContainer.NameInput, {6})
	self:skinDropDown{obj=_G.BaudBagOptions.GroupContainer.BackgroundSelection, x2=-9}
	self:skinSlider{obj=_G.BaudBagOptionsGroupGlobalSlider1, hgt=-4}
	self:skinSlider{obj=_G.BaudBagOptionsGroupContainerSlider1, hgt=-4}
	self:skinSlider{obj=_G.BaudBagOptionsGroupContainerSlider2, hgt=-4}
	if self.modChkBtns then
		self:skinCheckButton{obj=_G.BaudBagOptions.GroupGlobal.CheckButton1}
		self:skinCheckButton{obj=_G.BaudBagOptions.GroupGlobal.CheckButton2}
		self:skinCheckButton{obj=_G.BaudBagOptions.GroupGlobal.CheckButton3}
		self:skinCheckButton{obj=_G.BaudBagOptions.GroupGlobal.CheckButton4}
		self:skinCheckButton{obj=_G.BaudBagOptions.GroupContainer.EnabledCheck}
		self:skinCheckButton{obj=_G.BaudBagOptions.GroupContainer.CloseAllCheck}
		self:skinCheckButton{obj=_G.BaudBagOptionsGroupContainerCheckButton1}
		self:skinCheckButton{obj=_G.BaudBagOptionsGroupContainerCheckButton2}
		self:skinCheckButton{obj=_G.BaudBagOptionsGroupContainerCheckButton3}
	end

	for i = 1, _G.NUM_BANKBAGSLOTS + 2 do
		if self.modChkBtns then
			if i ~= 1 then -- first bag doesn't have a checkbox
				self:skinCheckButton{obj=_G["BaudBagOptionsJoinCheck" .. i]}
			end
		end
		self:addSkinFrame{obj=_G["BaudBagOptionsContainer" .. i], ft="a", kfs=true, nb=true, ofs=0}
	end

end
