local _, aObj = ...
if not aObj:isAddonEnabled("BankItems") then return end
local _G = _G

aObj.addonsToSkin.BankItems = function(self) -- v2.55 (Classic)
	if not self.db.profile.BankFrame then return end

	local BAGNUMBERS = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 100}
	self:SecureHookScript(_G.BankItems_Frame, "OnShow", function(this)

		-- Container frames (bank bags, equipped items & player's bags)
		local name
		for _, i in _G.ipairs(BAGNUMBERS) do
			name = "BankItems_ContainerFrame" .. i
			self:addSkinFrame{obj=_G[name], ft="a", kfs=true, x1=6, y1=-5, x2=-3, y2=-2}
			if self.modBtnBs then
				for j = 1, 36 do
					self:addButtonBorder{obj=_G[name .. "Item" .. j], ibt=true, clr="grey"}
				end
			end
		end
		name = nil
		self:skinDropDown{obj=_G.BankItems_UserDropdown}
		self:addSkinFrame{obj=this, ft="a", kfs=true, nb=true, ofs=-11, x1=20, x2=-53}
		if self.modBtns then
			self:skinCloseButton{obj=_G.BankItems_CloseButton}
			self:skinStdButton{obj=_G.BankItems_OptionsButton}
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.BankItems_ExportButton, ofs=-2, y1=-3, x2=-3, clr="gold"}
			self:addButtonBorder{obj=_G.BankItems_SearchButton, ofs=-2, y1=-3, x2=-3, clr="gold"}
			-- Item Slot buttons
			for i = 1, 24 do
				self:addButtonBorder{obj=_G["BankItems_Item" .. i], ibt=true, clr="grey"}
			end
			-- Bag Slots buttons
			for _, i in _G.ipairs(BAGNUMBERS) do
				self:addButtonBorder{obj=_G["BankItems_Bag" .. i], ibt=true, clr="grey"}
			end
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.BankItems_ShowAllRealms_Check}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.BankItems_OptionsFrame, "OnShow", function(this)

		self:skinDropDown{obj=_G.BankItems_BehaviorDropDown}
		self:skinSlider{obj=_G.BankItems_ButtonRadiusSlider}
		self:skinSlider{obj=_G.BankItems_ButtonPosSlider}
		self:skinSlider{obj=_G.BankItems_TransparencySlider}
		self:skinSlider{obj=_G.BankItems_ScaleSlider}
		self:addSkinFrame{obj=this, ft="a", kfs=true, nb=true, hdr=true}
		if self.modBtns then
			self:skinStdButton{obj=_G.BankItems_OptionsFrameDone}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.BankItems_OptionsFrame_LockWindow}
			self:skinCheckButton{obj=_G.BankItems_OptionsFrame_MinimapButton}
			self:skinCheckButton{obj=_G.BankItems_OptionsFrame_WindowStyle}
			self:skinCheckButton{obj=_G.BankItems_OptionsFrame_BagParent}
		end

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.BankItems_ExportFrame, "OnShow", function(this)

		self:skinSlider{obj=_G.BankItems_ExportFrame_ScrollScrollBar}
		self:skinEditBox{obj=_G.BankItems_ExportFrame_SearchTextbox, regs={6}} -- 6 is text
		self:moveObject{obj=_G.BankItems_ExportFrame_SearchAllRealms, x=6}
		self:addSkinFrame{obj=this, ft="a", kfs=true, nb=true}
		if self.modBtns then
			self:skinStdButton{obj=_G.BankItems_ExportFrameButton}
			self:skinStdButton{obj=_G.BankItems_ExportFrame_ResetButton}
		end
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.BankItems_ExportFrame_ShowBagPrefix}
			self:skinCheckButton{obj=_G.BankItems_ExportFrame_GroupData}
			self:skinCheckButton{obj=_G.BankItems_ExportFrame_SearchAllRealms}
		end

		self:Unhook(this, "OnShow")
	end)

end
