local aName, aObj = ...
if not aObj:isAddonEnabled("AuctionMaster") then return end

function aObj:AuctionMaster()

	local function skinSortBtns(tab1, tab2)
		local table = tab2 and vendor[tab1][tab2].itemTable.cols or vendor[tab1].itemTable.cols
		for _, obj in pairs(table) do
			if obj.sortButton.sortId then
				aObj:keepRegions(obj.sortButton, {4, 5, 6}) -- N.B. region 4 is the text, 5 is the arrow, 6 is the highlight
				aObj:addSkinFrame{obj=obj.sortButton, nb=true, bd=6}
				aObj:adjHeight{obj=obj.sortButton, adj=1}
			else
				obj.sortButton.sb:Hide()
			end
		end
	end

	-- logo
	vendor.AuctionHouse.logo:SetScale(0.7)
	self:moveObject{obj=vendor.AuctionHouse.logo, x=10, y=-14}
	
	-- OwnAuctions Tab
	self:glazeStatusBar(vendor.OwnAuctions.statusBar, 0,  nil)
	skinSortBtns("OwnAuctions")
	self:skinAllButtons{obj=vendor.OwnAuctions.itemTable.cmdFrame}
	self:removeRegions(vendor.OwnAuctions.itemTable.innerFrame, {1})
	
	-- Seller Tab
	self:keepFontStrings(vendor.Seller.frame)
	skinSortBtns("Seller", "inventorySeller")
	self:removeRegions(vendor.Seller.inventorySeller.itemTable.innerFrame, {1})
	self:addButtonBorder{obj=vendor.Seller.itemBut}
	self:skinDropDown{obj=vendor.Seller.durationDropDown.button}
	self:addButtonBorder{obj=_G[vendor.Seller.stackDropDown.button:GetName() .. "Button"], es=12, ofs=-2}
	self:skinEditBox{obj=vendor.Seller.stackDropDown.editBox, regs={9}}
	self:skinDropDown{obj=vendor.Seller.prizingDropDown.button}
	self:addButtonBorder{obj=_G[vendor.Seller.countDropDown.button:GetName() .. "Button"], es=12, ofs=-2}
	self:skinEditBox{obj=vendor.Seller.countDropDown.editBox, regs={9}}
	self:skinMoneyFrame{obj=vendor.Seller.startPriceBut, moveSEB=true, moveGEB=true}
	self:skinMoneyFrame{obj=vendor.Seller.buyoutPriceBut, moveSEB=true, moveGEB=true}
	self:glazeStatusBar(vendor.Seller.statusBar, 0,  nil)
	
	-->>-- Item Settings frame (press edit button to display)
	self:addSkinFrame{obj=self:getChild(vendor.ItemSettings.frame, 3), nb=true} -- type frame
	self:skinButton{obj=self:getChild(vendor.ItemSettings.frame, 1), cb=true} -- close button
	self:addButtonBorder{obj=vendor.ItemSettings.icon, ofs=0}
	self:addSkinFrame{obj=vendor.ItemSettings.frame, nb=true, y1=-6}
	-- general panel
	self:skinEditBox{obj=vendor.ItemSettings.settingsFrames[1].stacksize, regs={9}}
	self:skinEditBox{obj=vendor.ItemSettings.settingsFrames[1].amount, regs={9}}
	self:skinDropDown{obj=vendor.ItemSettings.settingsFrames[1].duration.button}
	self:addSkinFrame{obj=vendor.ItemSettings.settingsFrames[1]}
	self:skinButton{obj=vendor.ItemSettings.settingsFrames[1].revert}
	self:skinButton{obj=vendor.ItemSettings.settingsFrames[1].edit}
	-- price calculation panel
	self:skinDropDown{obj=vendor.ItemSettings.settingsFrames[2].pricingModel.button}
	self:skinDropDown{obj=vendor.ItemSettings.settingsFrames[2].pricingModifier.button}
	self:skinMoneyFrame{obj=vendor.ItemSettings.settingsFrames[2].money, moveSEB=true, moveGEB=true}
	self:adjWidth{obj=_G[vendor.ItemSettings.settingsFrames[2].money:GetName() .. "Gold"], adj=10}
	self:addSkinFrame{obj=vendor.ItemSettings.settingsFrames[2], nb=true}
	self:skinButton{obj=vendor.ItemSettings.settingsFrames[2].revert}
	self:skinButton{obj=vendor.ItemSettings.settingsFrames[2].edit}
	
	-- Search Tab (labelled Scan)
	self:glazeStatusBar(vendor.SearchTab.statusBar, 0,  nil)
	self:skinEditBox{obj=vendor.SearchTab.nameEdit, regs={9}, noHeight=true, move=true, x=-2}
	self:skinEditBox{obj=vendor.SearchTab.minLevel, regs={9}, noHeight=true, move=true, x=-2}
	self:skinEditBox{obj=vendor.SearchTab.maxLevel, regs={9}, noHeight=true, x=-4}
	self:adjHeight{obj=vendor.SearchTab.nameEdit, adj=6}
	self:adjHeight{obj=vendor.SearchTab.minLevel, adj=6}
	self:adjHeight{obj=vendor.SearchTab.maxLevel, adj=6}
	self:skinDropDown{obj=vendor.SearchTab.rarity.button}
	self:skinDropDown{obj=vendor.SearchTab.maxRarity.button}
	self:skinDropDown{obj=vendor.SearchTab.classIndex.button}
	self:skinDropDown{obj=vendor.SearchTab.subclassIndex.button}
	self:addButtonBorder{obj=self:getChild(vendor.SearchTab.frame, 9), x1=6, y1=-4, x2=-4, y2=6} -- reset button
	self:skinMoneyFrame{obj=vendor.SearchTab.maxPrice, moveSEB=true, moveGEB=true}
	self:moveObject{obj=vendor.SearchTab.maxPrice, y=4}
	self:addButtonBorder{obj=vendor.SearchTab.scan} -- texture is changed depending upon status
	self:skinDropDown{obj=scanSpeed.button} -- N.B. not referenced by parent
	skinSortBtns("SearchTab")
	self:skinAllButtons{obj=vendor.SearchTab.itemTable.cmdFrame}
	self:removeRegions(vendor.SearchTab.itemTable.innerFrame, {1})
	-- saved searches
	self:addSkinFrame{obj=vendor.SearchTab.searchList.frame}
	self:addButtonBorder{obj=vendor.SearchTab.searchList.rename, ofs=0}
	self:addButtonBorder{obj=self:getChild(vendor.SearchTab.searchList.frame, 14), ofs=0} -- plus button
	self:addButtonBorder{obj=vendor.SearchTab.searchList.delete, ofs=-5, x1=9, y2=10}
	
	-- Sniper config buttons & frames
	local snipers = vendor.Sniper:GetSnipers()
	for i = 1, #snipers do
		local btn = self:getChild(_G["AMSniperRow" .. i], 2)
		self:addButtonBorder{obj=btn, ofs=4}
		self:addSkinFrame{obj=snipers[i].config.frame, kfs=true}
		if snipers[i].config.minProfit then self:skinMoneyFrame{obj=snipers[i].config.minProfit} end
	end
	
-->>-- VendorScanDialog frame(s)
	self:RawHook(vendor.ScanDialog, "new", function(this)
		local instance = self.hooks[this].new(this)
		self:addSkinFrame{obj=instance.frame, kfs=true}
		self:addButtonBorder{obj=instance.itemIcon}
		return instance
	end, true)
	
	-- hook this to determine when the sort buttons get updated
	self:SecureHook(vendor.GuiTools, "GetNextId", function(this)
		if not vendor.OwnAuctions.itemTable.cols[1].sortButton then
			self:ScheduleTimer(skinSortBtns, 0.1, "OwnAuctions")
		elseif not vendor.Seller.inventorySeller.itemTable.cols[1].sortButton then
			self:ScheduleTimer(skinSortBtns, 0.1, "Seller", "inventorySeller")
		elseif not vendor.SearchTab.itemTable.cols[1].sortButton then
			self:ScheduleTimer(skinSortBtns, 0.1, "SearchTab")
		end
	end)	

end