local aName, aObj = ...
if not aObj:isAddonEnabled("BaudBag") then return end
local _G = _G

aObj.addonsToSkin.BaudBag = function(self) -- v 7.3.2
	if not self.db.profile.ContainerFrames.skin then return end

	-- hook this to skin the bag frames
	self:SecureHook("BaudBagUpdateContainer", function(Container)
		local cName = Container:GetName()
		_G[cName .. "BackdropTextures"]:Hide()
		if not _G[cName].Backdrop.sf then
			self:addSkinFrame{obj=_G[cName].Backdrop, ft="a", nb=true}
			self:skinCloseButton{obj=_G[cName].CloseButton}
			self:skinExpandButton{obj=_G[cName].MenuButton, sap=true, plus=true}
			-- hook this to skin the Search Frame
			self:SecureHookScript(_G[cName].SearchButton, "OnClick", function(this, ...)
				if not _G.BaudBagSearchFrame.Backdrop.sf then
					self:skinEditBox{obj=_G.BaudBagSearchFrame.EditBox, regs={6}, noHeight=true}
					self:adjHeight{obj=_G.BaudBagSearchFrame.EditBox, adj=10}
					self:skinCloseButton{obj=_G.BaudBagSearchFrame.CloseButton}
					self:addSkinFrame{obj=_G.BaudBagSearchFrame.Backdrop, ft="a", nb=true, y1=1, y2=25}
				end
				_G.BaudBagSearchFrame.EditBox:SetPoint("TOPLEFT", -3, 23)
				self:keepFontStrings(_G.BaudBagSearchFrameBackdropTextures)
			end)
			-- DepositButton
			-- UnlockInfo
		end
	end)
	self:skinDropDown{obj=_G.BaudBagContainerDropDown, x2=-10}
	self:addSkinFrame{obj=_G.BaudBagContainer1_1BagsFrame, ft="a", nb=true}
	self:addSkinFrame{obj=_G.BaudBagContainer2_1BagsFrame, ft="a", nb=true}
	if self.modBtnBs then
		self:addButtonBorder{obj=_G.BaudBagContainer1_1.BagsButton, ofs=-1, x1=0, y1=-1}
		self:addButtonBorder{obj=_G.BaudBagContainer2_1.BagsButton, ofs=-1, x1=0, y1=-1}
		self:skinStdButton{obj=_G.BaudBagBankSlotPurchaseButton}
	end

	-- Options Frame
	-- register callback to indicate already skinned
	self.RegisterCallback("BaudBag", "IOFPanel_Before_Skinning", function(this, panel)
		if panel.name ~= "Baud Bag" then return end
		self.iofSkinnedPanels[panel] = true
		self.UnregisterCallback("BaudBag", "IOFPanel_Before_Skinning")
	end)

	self:skinCheckButton{obj=_G.BaudBagOptions.GroupGlobal.CheckButton1}
	self:skinCheckButton{obj=_G.BaudBagOptions.GroupGlobal.CheckButton2}
	self:skinDropDown{obj=_G.BaudBagOptions.GroupContainer.SetSelection, x2=-9}
	self:skinCheckButton{obj=_G.BaudBagOptions.GroupContainer.EnabledCheck}
	self:skinCheckButton{obj=_G.BaudBagOptions.GroupContainer.CloseAllCheck}
	-- self:addSkinFrame{obj=_G.BaudBagOptions.GroupContainer.BagFrame, ft="a"}
	self:skinEditBox(_G.BaudBagOptions.GroupContainer.NameInput, {6})
	self:skinDropDown{obj=_G.BaudBagOptions.GroupContainer.BackgroundSelection, x2=-9}
	self:skinCheckButton{obj=_G.BaudBagOptionsGroupContainerCheckButton1}
	self:skinCheckButton{obj=_G.BaudBagOptionsGroupContainerCheckButton2}
	self:skinCheckButton{obj=_G.BaudBagOptionsGroupContainerCheckButton3}
	self:skinCheckButton{obj=_G.BaudBagOptionsGroupContainerCheckButton4}
	self:skinSlider{obj=_G.BaudBagOptionsGroupContainerSlider1, hgt=-4}
	self:skinSlider{obj=_G.BaudBagOptionsGroupContainerSlider2, hgt=-4}

	for i = 1, _G.NUM_BANKBAGSLOTS + 2 do
		if i ~= 1 then -- first bag doesn't have a checkbox
			self:skinCheckButton{obj=_G["BaudBagOptionsJoinCheck" .. i]}
		end
		self:addSkinFrame{obj=_G["BaudBagOptionsContainer" .. i], ft="a"}
	end

end
