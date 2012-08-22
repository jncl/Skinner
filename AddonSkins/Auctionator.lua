local aName, aObj = ...
if not aObj:isAddonEnabled("Auctionator") then return end

function aObj:Auctionator()

	if self.Auctionator_Config then
		self:Auctionator_Config()
	end

	if IsAddOnLoaded("Blizzard_AuctionUI") then
		self:Auctionator_AuctionUI()
	end

end


function aObj:Auctionator_AuctionUI()

-->>-- AuctionUI panels
	self:skinEditBox{obj=Atr_Search_Box, regs={9}}
	-- item drag & drop frame
	self:addSkinFrame{obj=Atr_Hilite1, kfs=true}
	self:addSkinFrame{obj=Atr_HeadingsBar, kfs=true, y1=-19, y2=19}
	-- scroll frame below heading bar
	self:skinScrollBar{obj=AuctionatorScrollFrame}
	local tabObj, tabSF
	for i = 1, Atr_ListTabs.numTabs do
		tabObj = _G["Atr_ListTabsTab"..i]
		self:keepRegions(tabObj, {7, 8}) -- N.B. region 7 is text, 8 is highlight
		-- self:moveObject{obj=self:getRegion(tabObj, 8), y=3}
		tabSF = self:addSkinFrame{obj=tabObj, noBdr=self.isTT, y1=-4, x2=4, y2=-4}
		tabSF.up = true
		if i == 1 then
			if self.isTT then self:setActiveTab(tabSF) end
		else
			if self.isTT then self:setInactiveTab(tabSF) end
		end
	end
	self.tabFrames[Atr_ListTabs] = true

	-- Buy
	self:skinDropDown{obj=Atr_DropDownSL}
	-- Sell
	self:skinScrollBar{obj=Atr_Hlist_ScrollFrame}
	self:addSkinFrame{obj=Atr_Hlist, kfs=true, x1=-4, x2=8}
	self:skinMoneyFrame{obj=Atr_StackPrice, noWidth=true, moveSEB=true, moveGEB=true}
	self:skinMoneyFrame{obj=Atr_ItemPrice, noWidth=true, moveSEB=true, moveGEB=true}
	self:skinMoneyFrame{obj=Atr_StartingPrice, noWidth=true, moveSEB=true, moveGEB=true}
	self:skinEditBox{obj=Atr_Batch_NumAuctions, regs={9}}
	self:skinEditBox{obj=Atr_Batch_Stacksize, regs={9}}
	self:skinDropDown{obj=Atr_Duration}
	-- More...

-->>-- Error Frame
	self:addSkinFrame{obj=Atr_Error_Frame, kfs=true}
-->>-- Confirm Frame
	self:addSkinFrame{obj=Atr_Confirm_Frame, kfs=true}
-->>-- Buy_Confirm Frame
	self:skinEditBox{obj=Atr_Buy_Confirm_Numstacks, regs={9}}
	self:addSkinFrame{obj=Atr_Buy_Confirm_Frame, kfs=true}
-->>-- CheckActives Frame
	self:addSkinFrame{obj=Atr_CheckActives_Frame, kfs=true}
-->>-- FullScan Frame
	self:addSkinFrame{obj=Atr_FullScanFrame, kfs=true, y1=4}
-->>-- Search Dialog
	self:skinEditBox{obj=Atr_AS_Searchtext, regs={9}}
	self:skinDropDown{obj=Atr_ASDD_Class}
	self:skinDropDown{obj=Atr_ASDD_Subclass}
	self:skinEditBox{obj=Atr_AS_Minlevel, regs={9}}
	self:skinEditBox{obj=Atr_AS_Maxlevel, regs={9}}
	self:skinEditBox{obj=Atr_AS_MinItemlevel, regs={9}}
	self:skinEditBox{obj=Atr_AS_MaxItemlevel, regs={9}}
	self:addSkinFrame{obj=Atr_Adv_Search_Dialog, kfs=true, ofs=-10, y1=4}

end

function aObj:Auctionator_Config()

	-- Basic Options
	self:skinDropDown{obj=AuctionatorOption_Deftab, x2=110}
	-- Tooltips
	self:skinDropDown{obj=Atr_tipsShiftDD, x2=110}
	self:skinDropDown{obj=Atr_deDetailsDD, x2=30}
	-- Undercutting panel
	self:skinMoneyFrame{obj=UC_5000000_MoneyInput, noWidth=true, moveSEB=true, moveGEB=true}
	self:skinMoneyFrame{obj=UC_1000000_MoneyInput, noWidth=true, moveSEB=true, moveGEB=true}
	self:skinMoneyFrame{obj=UC_200000_MoneyInput, noWidth=true, moveSEB=true, moveGEB=true}
	self:skinMoneyFrame{obj=UC_50000_MoneyInput, noWidth=true, moveSEB=true, moveGEB=true}
	self:skinMoneyFrame{obj=UC_10000_MoneyInput, noWidth=true, moveSEB=true, moveGEB=true}
	self:skinMoneyFrame{obj=UC_2000_MoneyInput, noWidth=true, moveSEB=true, moveGEB=true}
	self:skinMoneyFrame{obj=UC_500_MoneyInput, noWidth=true, moveSEB=true, moveGEB=true}
	-- Selling
	self:addSkinFrame{obj=Atr_Stacking_List, kfs=true}
	-- Memorize Frame (popout)
	self:skinEditBox{obj=Atr_Mem_EB_itemName, regs={9}}
	self:skinDropDown{obj=Atr_Mem_DD_numStacks, x2=-15}
	self:skinEditBox{obj=Atr_Mem_EB_stackSize, regs={9}}
	self:addSkinFrame{obj=Atr_MemorizeFrame, kfs=true}
	-- Database
	self:skinDropDown{obj=Atr_scanLevelDD, x2=-70}
	self:skinEditBox{obj=Atr_ScanOpts_MaxHistAge, regs={9}}
	-- Clears
	-- Shopping Lists
	self:addSkinFrame{obj=Atr_ShpList_Frame}
	-- Shopping List edit frame (popout)
	self:skinScrollBar{obj=Atr_ShpList_Edit_FrameScrollFrame}
	self:addSkinFrame{obj=Atr_ShpList_Edit_Frame, kfs=true}

	-- disable changes to InterfaceOptionsFrame(s) backdrop
	Atr_MakeOptionsFrameOpaque = function() end

	self.Auctionator_Config = nil

end
