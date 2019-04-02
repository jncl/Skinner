local aName, aObj = ...
if not aObj:isAddonEnabled("AuctionLite") then return end
local _G = _G

aObj.addonsToSkin.AuctionLite = function(self) -- v 1.8.16

	-- Buy tab
	self:skinEditBox{obj=_G.BuyName, regs={6}}
	self:skinEditBox{obj=_G.BuyQuantity, regs={6}}
	self:skinDropDown{obj=_G.BuyAdvancedDropDown}
	self:skinSlider{obj=_G.BuyScrollFrame.ScrollBar, rt="artwork"}
	if self.modBtns then
		self:skinStdButton{obj=_G.BuyCancelSearchButton}
		self:skinStdButton{obj=_G.BuyApproveButton}
		self:skinStdButton{obj=_G.BuyCancelPurchaseButton}
		self:skinStdButton{obj=_G.BuyScanButton}
		self:skinStdButton{obj=_G.BuySearchButton}
		self:skinStdButton{obj=_G.BuyCancelAuctionButton}
		self:skinStdButton{obj=_G.BuyBuyoutButton}
		self:skinStdButton{obj=_G.BuyBidButton}
	end
	if self.modBtnBs then
		self:addButtonBorder{obj=_G.BuySummaryButton, ofs=0}
		self:addButtonBorder{obj=_G.BuyAdvancedButton, ofs=0}
	end

	-- Sell tab
	self:skinSlider{obj=_G.SellScrollFrame.ScrollBar, rt="artwork"}
	self:skinDropDown{obj=_G.SellRememberDropDown}
	self:skinEditBox{obj=_G.SellStacks, regs={6}}
	self:skinEditBox{obj=_G.SellSize, regs={6}}
	self:skinMoneyFrame{obj=_G.SellBidPrice}
	self:skinMoneyFrame{obj=_G.SellBuyoutPrice}
	if self.modBtns then
		self:skinStdButton{obj=_G.SellStacksMaxButton}
		self:skinStdButton{obj=_G.SellSizeMaxButton}
		self:skinStdButton{obj=_G.SellCreateAuctionButton}
	end
	if self.modBtnBs then
		self:addButtonBorder{obj=_G.SellRememberButton, ofs=4, x1=-9, x2=0}
		self:addButtonBorder{obj=_G.SellItemButton}
	end

end
