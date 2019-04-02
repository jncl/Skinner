local aName, aObj = ...
if not aObj:isAddonEnabled("AuctionMaster") then return end
local _G = _G

aObj.addonsToSkin.AuctionMaster = function(self) -- v 8.1.0

	local vendor = _G.vendor

	local function skinSortBtns(tab1, tab2)
		local table = tab2 and vendor[tab1][tab2].itemTable.cols or vendor[tab1].itemTable.cols
		for _, obj in _G.pairs(table) do
			if obj.sortButton.sortId then
				aObj:keepRegions(obj.sortButton, {4, 5, 6}) -- N.B. region 4 is text, 5 is arrow, 6 is highlight
				aObj:addSkinFrame{obj=obj.sortButton, ft="a", kfs=true, nb=true, bd=6}
				aObj:adjHeight{obj=obj.sortButton, adj=1}
			else
				obj.sortButton.sb:Hide()
			end
		end
		local obj = tab2 and vendor[tab1][tab2].itemTable or vendor[tab1].itemTable
		if obj.upperList
		or obj.cfg.size == 100
		or not obj.sortFrame
		then
			return
		end
		-- find and remove background frame's texture
		local kids = {obj.sortFrame:GetChildren()}
		for _, child in _G.ipairs(kids) do
			if child:IsObjectType("Frame") then
				self:removeRegions(child, {1})
			end
		end
		kids = nil
	end
	local function skinCmdBtns(frame)
		for _, child in _G.ipairs{frame:GetChildren()} do
			if child:IsObjectType("Button") then
				self:skinStdButton{obj=child}
			end
		end
	end
	-- logo
	vendor.AuctionHouse.logo:SetScale(0.7)
	self:moveObject{obj=vendor.AuctionHouse.logo, x=10, y=-14}
	-- button
	if self.modBtns then
		self:skinStdButton{obj=vendor.AuctionHouse.but, ofs=-1}
	end

	-- OwnAuctions Tab
	self:skinStatusBar{obj=vendor.OwnAuctions.statusBar, fi=0}
	skinSortBtns("OwnAuctions")
	self:removeRegions(vendor.OwnAuctions.itemTable.cmdFrame, {1}) -- background
	self:removeRegions(vendor.OwnAuctions.itemTable.innerFrame, {1}) -- background
	if self.modBtns then
		skinCmdBtns(vendor.OwnAuctions.itemTable.cmdFrame)
		self:skinStdButton{obj=_G.AMOwnAuctionsClose}
	end

	-- Seller Tab
	self:keepFontStrings(vendor.Seller.frame)
	skinSortBtns("Seller")
	self:removeRegions(vendor.Seller.itemTable.cmdFrame, {1}) -- background
	self:removeRegions(vendor.Seller.itemTable.innerFrame, {1}) -- background
	if self.modBtns then
		self:skinStdButton{obj=self:getChild(vendor.Seller.frame, 2)} -- Edit button
		self:skinStdButton{obj=vendor.Seller.createBut}
		skinCmdBtns(vendor.Seller.itemTable.cmdFrame)
		self:skinStdButton{obj=vendor.Seller.closeBut}
	end
	if self.modBtnBs then
		self:addButtonBorder{obj=vendor.Seller.itemBut}
	end
	self:skinEditBox{obj=vendor.Seller.stackDropDown.editBox, regs={6}}
	self:skinEditBox{obj=vendor.Seller.countDropDown.editBox, regs={6}}
	self:skinMoneyFrame{obj=vendor.Seller.startPriceBut, moveSEB=true, moveGEB=true}
	self:skinMoneyFrame{obj=vendor.Seller.buyoutPriceBut, moveSEB=true, moveGEB=true}
	self:skinStatusBar{obj=vendor.Seller.statusBar, fi=0}

	-->>-- inventorySeller subframe
	skinSortBtns("Seller", "inventorySeller")
	self:removeRegions(vendor.Seller.inventorySeller.itemTable.innerFrame, {1})

	-->>-- Item Settings frame (press edit button to display)
	self:addSkinFrame{obj=self:getChild(vendor.ItemSettings.frame, 3), ft="a", kfs=true, nb=true} -- type frame
	if self.modBtns then
		self:skinCloseButton{obj=self:getChild(vendor.ItemSettings.frame, 1)} -- close button
	end
	if self.modBtnBs then
		self:addButtonBorder{obj=vendor.ItemSettings.icon, ofs=0}
	end
	self:addSkinFrame{obj=vendor.ItemSettings.frame, ft="a", kfs=true, nb=true, y1=-6}
	-- general panel
	self:skinEditBox{obj=vendor.ItemSettings.settingsFrames[1].stacksize, regs={6}}
	self:skinEditBox{obj=vendor.ItemSettings.settingsFrames[1].amount, regs={6}}
	self:skinDropDown{obj=vendor.ItemSettings.settingsFrames[1].duration.dropdown, y2=0}
	self:addSkinFrame{obj=vendor.ItemSettings.settingsFrames[1], ft="a", kfs=true, nb=true}
	if self.modBtns then
		self:skinStdButton{obj=vendor.ItemSettings.settingsFrames[1].revert}
		self:skinStdButton{obj=vendor.ItemSettings.settingsFrames[1].edit}
	end
	-- price calculation panel
	self:skinDropDown{obj=vendor.ItemSettings.settingsFrames[2].pricingModel.dropdown, y2=0}
	self:skinDropDown{obj=vendor.ItemSettings.settingsFrames[2].pricingModifier.dropdown, y2=0}
	self:skinMoneyFrame{obj=vendor.ItemSettings.settingsFrames[2].money, moveSEB=true, moveGEB=true}
	self:adjWidth{obj=_G[vendor.ItemSettings.settingsFrames[2].money:GetName() .. "Gold"], adj=10}
	self:addSkinFrame{obj=vendor.ItemSettings.settingsFrames[2], ft="a", kfs=true, nb=true}
	if self.modBtns then
		self:skinStdButton{obj=vendor.ItemSettings.settingsFrames[2].revert}
		self:skinStdButton{obj=vendor.ItemSettings.settingsFrames[2].edit}
	end

	-- Search Tab (labelled Scan)
	self:skinStatusBar{obj=vendor.SearchTab.statusBar, fi=0}
	self:skinEditBox{obj=vendor.SearchTab.nameEdit, regs={6}, noHeight=true, move=true, x=-2}
	self:skinEditBox{obj=vendor.SearchTab.minLevel, regs={6}, noHeight=true, move=true, x=-2}
	self:skinEditBox{obj=vendor.SearchTab.maxLevel, regs={6}, noHeight=true, x=-4}
	self:adjHeight{obj=vendor.SearchTab.nameEdit, adj=6}
	self:adjHeight{obj=vendor.SearchTab.minLevel, adj=6}
	self:adjHeight{obj=vendor.SearchTab.maxLevel, adj=6}
	self:skinMoneyFrame{obj=vendor.SearchTab.maxPrice, moveSEB=true, moveGEB=true}
	self:moveObject{obj=vendor.SearchTab.maxPrice, y=4}
	if self.modBtnBs then
		self:addButtonBorder{obj=self:getChild(vendor.SearchTab.frame, 9), x1=6, y1=-4, x2=-4, y2=6} -- reset button
		self:addButtonBorder{obj=vendor.SearchTab.scan} -- texture is changed depending upon status
	end
	skinSortBtns("SearchTab")
	self:removeRegions(vendor.SearchTab.itemTable.cmdFrame, {1}) -- background
	self:removeRegions(vendor.SearchTab.itemTable.innerFrame, {1}) -- background
	if self.modBtns then
		self:skinStdButton{obj=vendor.SearchTab.search}
		self:skinStdButton{obj=vendor.SearchTab.stop}
		skinCmdBtns(vendor.SearchTab.itemTable.cmdFrame)
		self:skinStdButton{obj=_G.AMSearchTabClose}
	end
	if self.modChkBtns then
		self:skinCheckButton{obj=vendor.SearchTab.bid}
		self:skinCheckButton{obj=vendor.SearchTab.buyout}
		self:skinCheckButton{obj=vendor.SearchTab.usable}
		self:skinCheckButton{obj=vendor.SearchTab.unique}
		self:skinCheckButton{obj=vendor.SearchTab.exactMatch}
	end
	-- saved searches
	self:skinSlider{obj=vendor.SearchTab.searchList.scrollFrame.ScrollBar}--, rt="artwork", wdth=-4, size=3, hgt=-10}
	self:addSkinFrame{obj=vendor.SearchTab.searchList.frame, ft="a", kfs=true, nb=true}
	if self.modChkBtns then
		for i = 1, #vendor.SearchTab.searchList.rows do
			self:skinCheckButton{obj=vendor.SearchTab.searchList.rows[i].check}
		end
	end
	if self.modBtns then
		self:skinStdButton{obj=vendor.SearchTab.searchList.save, ofs=0}
	end
	if self.modBtnBs then
		self:addButtonBorder{obj=vendor.SearchTab.searchList.rename, ofs=0}
		self:addButtonBorder{obj=self:getChild(vendor.SearchTab.searchList.frame, 14), ofs=0} -- plus button
		self:addButtonBorder{obj=vendor.SearchTab.searchList.delete, ofs=-5, x1=9, y2=10}
	end

	-- Sniper config buttons & frames
	local snipers = vendor.Sniper:GetSnipers()
	for i = 1, #snipers do
		self:addSkinFrame{obj=snipers[i].config.frame, ft="a", kfs=true, nb=true}
		if snipers[i].config.minProfit then
			self:skinMoneyFrame{obj=snipers[i].config.minProfit}
		end
		if self.modChkBtns then
		self:skinCheckButton{obj=self:getChild(_G["AMSniperRow" .. i], 1)}
			if snipers[i].config.bid then
				self:skinCheckButton{obj=snipers[i].config.bid}
				self:skinCheckButton{obj=snipers[i].config.buyout}
			end
		end
		if self.modBtns then
			self:skinStdButton{obj=self:getChild(snipers[i].config.frame, 2)} -- ok button
			self:skinStdButton{obj=self:getChild(snipers[i].config.frame, 3)} -- cancel button
		end
		if self.modBtnBs then
			self:addButtonBorder{obj=self:getChild(_G["AMSniperRow" .. i], 2), ofs=4}
		end
	end

-->>-- VendorScanDialog frame(s)
	self:RawHook(vendor.ScanDialog, "new", function(this)
		local instance = self.hooks[this].new(this)
		self:addSkinFrame{obj=instance.frame, ft="a", kfs=true, nb=true}
		if self.modBtnBs then
			self:addButtonBorder{obj=instance.itemIcon}
		end
		return instance
	end, true)

	-- hook this to determine when the sort buttons get updated
	self:SecureHook(vendor.GuiTools, "GetNextId", function(this)
		if not vendor.OwnAuctions.itemTable.cols[1].sortButton then
			_G.C_Timer.After(0.1, function() skinSortBtns("OwnAuctions") end)
		elseif not vendor.Seller.itemTable.cols[1].sortButton then
			_G.C_Timer.After(0.1, function() skinSortBtns("Seller") end)
		elseif not vendor.Seller.inventorySeller.itemTable.cols[1].sortButton then
			_G.C_Timer.After(0.1, function() skinSortBtns("Seller", "inventorySeller") end)
		elseif not vendor.SearchTab.itemTable.cols[1].sortButton then
			_G.C_Timer.After(0.1, function() skinSortBtns("SearchTab") end)
		end
	end)

end