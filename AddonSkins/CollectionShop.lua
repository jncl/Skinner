local aName, aObj = ...
if not aObj:isAddonEnabled("CollectionShop") then return end
local _G = _G

aObj.addonsToSkin.CollectionShop = function(self) -- v 3.05

	-- skin frame components after AuctionUI is loaded
	self.RegisterCallback("CollectionShop", "Auction_House_Show", function(this)
		-- AuctionFrameCollectionShop
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.AuctionFrameCollectionShop_FlyoutPanelButton, ofs=-2, x1=1}
			self:addButtonBorder{obj=_G.AuctionFrameCollectionShop_OptionsButton}
			self:addButtonBorder{obj=_G.AuctionFrameCollectionShop_ModeSelectionButton}
			self:addButtonBorder{obj=_G.AuctionFrameCollectionShop_BuyoutsMailButton}
			self:addButtonBorder{obj=_G.AuctionFrameCollectionShop_ModeSelectionFrame_MountsModeButton, es=24}
			self:addButtonBorder{obj=_G.AuctionFrameCollectionShop_ModeSelectionFrame_PetsModeButton, es=24}
			self:addButtonBorder{obj=_G.AuctionFrameCollectionShop_ModeSelectionFrame_ToysModeButton, es=24}
			self:addButtonBorder{obj=_G.AuctionFrameCollectionShop_ModeSelectionFrame_AppearancesModeButton, es=24}
			self:addButtonBorder{obj=_G.AuctionFrameCollectionShop_ModeSelectionFrame_RecipesModeButton, es=24}
		end
		if self.modChkBtns then
			 self:skinCheckButton{obj=_G.AuctionFrameCollectionShop_UndressCharacterCheckButton}
			 self:skinCheckButton{obj=_G.AuctionFrameCollectionShop_LiveCheckButton}
		end
		if self.modBtns then
			self:skinStdButton{obj=_G.AuctionFrameCollectionShop_ScanButton}
			self:skinStdButton{obj=_G.AuctionFrameCollectionShop_ShopButton}
			self:skinStdButton{obj=_G.AuctionFrameCollectionShop_BuyAllButton}
			self:skinStdButton{obj=_G.AuctionFrameCollectionShop_CloseButton}
		end
		for _, type in pairs{"Name", "Lvl", "Category", "ItemPrice", "PctItemValue"} do
			self:keepRegions(_G["AuctionFrameCollectionShop_" .. type .. "SortButton"], {4, 5, 6}) -- N.B. region 4 is the text, 5 is the arrow, 6 is the highlight
			self:addSkinFrame{obj=_G["AuctionFrameCollectionShop_" .. type .. "SortButton"], ft="a", nb=true, aso={bd=5}}
		end

		-- ScrollFrame
		self:skinSlider{obj=_G.AuctionFrameCollectionShop_ScrollFrame.ScrollBar, rt="artwork"}
		if self.modBtnBs then
			for i = 1, 9 do
				self:addButtonBorder{obj=_G["AuctionFrameCollectionShop_ScrollFrameButton" .. i], relTo=_G["AuctionFrameCollectionShop_ScrollFrameButton" .. i .. "_IconTexture"]}
				_G.RaiseFrameLevel(_G["AuctionFrameCollectionShop_ScrollFrameButton" .. i].sbb)
				self:SecureHook(_G["AuctionFrameCollectionShop_ScrollFrameButton" .. i .. "_NameText"], "SetTextColor", function(this, r, g, b)
					this:GetParent():GetParent().sbb:SetBackdropBorderColor(r, g, b)
				end)
			end
		end

		-- FlyoutPanel
		self:skinEditBox{obj=_G.AuctionFrameCollectionShop_FlyoutPanel_NameSearchEditbox, regs={6, 7}, mi=true, noWdth=true} -- 6 is text
		self:addSkinFrame{obj=_G.AuctionFrameCollectionShop_FlyoutPanel, ft="a", kfs=true, x1=-4, y1=2, x2=1, y2=-6}
		self:skinSlider{obj=_G.AuctionFrameCollectionShop_FlyoutPanel_ScrollFrame.ScrollBar, rt="artwork"}
		if self.modBtns then
			self:skinStdButton{obj=_G.AuctionFrameCollectionShop_FlyoutPanel_ToggleCategories}
			self:skinStdButton{obj=_G.AuctionFrameCollectionShop_FlyoutPanel_UncheckAll}
			self:skinStdButton{obj=_G.AuctionFrameCollectionShop_FlyoutPanel_CheckAll}
		end
		-- ScrollFrame
		if self.modChkBtns then
			for i = 1, 16 do
				self:skinCheckButton{obj=_G["AuctionFrameCollectionShop_FlyoutPanel_ScrollFrameButton" .. i .. "_Check"]}
			end
		end

		-- BuyoutFrame
		self:skinEditBox{obj=_G.AuctionFrameCollectionShop_DialogFrame_BuyoutFrame_SelectedOwnerEditbox, regs={6}} -- 6 is text
		if self.modBtns then
			self:skinStdButton{obj=_G._G.AuctionFrameCollectionShop_DialogFrame_BuyoutFrame_CancelButton}
			self:skinStdButton{obj=_G._G.AuctionFrameCollectionShop_DialogFrame_BuyoutFrame_BuyoutButton}
		end

	end)

	-- Options frame
	self:SecureHookScript(_G.CollectionShopOptionsMainFrame, "OnShow", function(this)
		-- Options Tab
		if self.modChkBtns then
			self:skinCheckButton{obj=_G.CollectionShopOptionsMainFrameTab1SubFrameAuctionsWonReminderCheckButton}
			self:skinCheckButton{obj=_G.CollectionShopOptionsMainFrameTab1SubFrameAutoselectAfterAuctionUnavailableCheckButton}
		end
		for i = 1, 5 do
			self:skinEditBox{obj=_G["CollectionShopOptionsMainFrameTab1SubFrameMaxItemPriceMode" .. i .. "Editbox"], regs={6}} -- 6 is text
			self:skinEditBox{obj=_G["CollectionShopOptionsMainFrameTab1SubFrameTSMItemValueSourceEditbox"], regs={6}} -- 6 is text
		end
		-- Buyouts Tab
		for _, type in pairs{"Name", "Mode", "ItemPrice"} do
			self:removeRegions(_G["CollectionShopOptionsMainFrameTab2SubFrame" .. type .. "ColumnHeaderButton"], {1, 2, 3})
			self:addSkinFrame{obj=_G["CollectionShopOptionsMainFrameTab2SubFrame" .. type .. "ColumnHeaderButton"], ft="a", nb=true, aso={bd=5}}
		end
		if self.modBtns then
			self:skinStdButton{obj=_G.CollectionShopOptionsMainFrameTab2SubFrameRefreshButton}
		end
		self:skinSlider{obj=_G.CollectionShopOptionsMainFrameTab2SubFrameScrollFrame.ScrollBar, rt="artwork"}
		-- GetAll Scan Data Tab
		self:skinDropDown{obj=_G.CollectionShopOptionsMainFrameTab3SubFrameRealmDropDownMenu}
		if self.modBtns then
			self:skinStdButton{obj=_G.CollectionShopOptionsMainFrameTab3SubFrameDeleteDataButton}
		end
		-- Help Tab

		self:addSkinFrame{obj=_G.CollectionShopOptionsMainFrame, ft="a", kfs=true, ri=true, ofs=2, x2=1}
		-- Tabs
		self:skinTabs{obj=_G.CollectionShopOptionsMainFrameSubFrameHeader, ignore=true, up=true, lod=true, x1=0, y1=-4, x2=0, y2=-4}
		self:Unhook(this, "OnShow")
	end)

end
