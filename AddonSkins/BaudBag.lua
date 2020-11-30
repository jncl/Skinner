local aName, aObj = ...
if not aObj:isAddonEnabled("BaudBag") then return end
local _G = _G

aObj.addonsToSkin.BaudBag = function(self) -- v 9.0.5
	if not self.db.profile.ContainerFrames.skin then return end

	-- hook this to skin the bag frames
	self:SecureHook(_G.BaudBag, "Container_Updated", function(this, bagSet, containerId)
		-- aObj:Debug("BaudBag Container_Updated: [%s, %s, %s]", this, bagSet, containerId)
		local bsTab
		for i = 1, this.Sets[bagSet.Id].MaxContainerNumber do
			bsTab = this.Sets[bagSet.Id].Containers[i]
			self:keepFontStrings(bsTab.Frame.Backdrop.Textures)
			if not bsTab.Frame.Backdrop.sf then
				-- self:addSkinFrame{obj=bsTab.Frame.Backdrop, ft="a", kfs=true, nb=true, ofs=0}
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
		self:skinStdButton{obj=_G.BaudBagBankSlotPurchaseButton}
		self:SecureHook("BaudBagBankBags_UpdateContent", function(_)
			self:clrBtnBdr(_G.BaudBagBankSlotPurchaseButton)
		end)
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
	-- Options Frame
	-- register callback to indicate already skinned
	self.RegisterCallback("BaudBag", "IOFPanel_Before_Skinning", function(this, panel)
		if panel.name ~= "Baud Bag" then return end
		self.iofSkinnedPanels[panel] = true

		self:skinObject("dropdown", {obj=_G.BaudBagOptions.GroupContainer.SetSelection, x2=-11})
		self:skinObject("editbox", {obj=_G.BaudBagOptions.GroupContainer.NameInput})
		self:skinObject("dropdown", {obj=_G.BaudBagOptions.GroupContainer.BackgroundSelection, x2=-11})
		self:skinObject("slider", {obj=_G.BaudBagOptionsGroupGlobal.Slider1})
		self:skinObject("slider", {obj=_G.BaudBagOptionsGroupContainer.Slider1})
		self:skinObject("slider", {obj=_G.BaudBagOptionsGroupContainer.Slider2})
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
			self:skinObject("frame", {obj=_G["BaudBagOptionsContainer" .. i], kfs=true, ofs=0})
		end

		self.UnregisterCallback("BaudBag", "IOFPanel_Before_Skinning")
	end)

end
