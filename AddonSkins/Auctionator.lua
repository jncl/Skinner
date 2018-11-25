local aName, aObj = ...
if not aObj:isAddonEnabled("Auctionator") then return end
local _G = _G

local function skinAuctionUI()

-->>-- AuctionUI panelsaObj
	aObj:skinEditBox{obj=_G.Atr_Search_Box, regs={6}}
	aObj:skinExpandButton{obj=_G.Atr_Adv_Search_Button, sap=true, plus=true}
	if aObj.modChkBtns then
		aObj:skinCheckButton{obj=_G.Atr_Exact_Search_Button}
	end
	-- item drag & drop frame
	aObj:addSkinFrame{obj=_G.Atr_HeadingsBar, ft="a", kfs=true, nb=true, y1=-19, y2=19}
	aObj:addSkinFrame{obj=_G.Atr_Hilite1, ft="a", kfs=true, nb=true}
	-- scroll frame below heading bar
	aObj:skinSlider{obj=_G.AuctionatorScrollFrame.ScrollBar}
	if aObj.modBtns then
		aObj:skinStdButton{obj=_G.Atr_Search_Button}
		aObj:skinStdButton{obj=_G.Auctionator1Button}
		aObj:skinStdButton{obj=_G.Atr_FullScanButton}
		aObj:moveObject{obj=_G.Atr_FullScanButton, y=-2}
		aObj:skinStdButton{obj=_G.Atr_AddToSListButton, x2=-1}
		aObj:skinStdButton{obj=_G.Atr_RemFromSListButton, x2=0}
		aObj:skinStdButton{obj=_G.Atr_SrchSListButton}
		aObj:skinStdButton{obj=_G.Atr_MngSListsButton}
		aObj:skinStdButton{obj=_G.Atr_NewSListButton}
		aObj:skinStdButton{obj=_G.Atr_Buy1_Button}
		aObj:skinStdButton{obj=_G.Atr_Back_Button}
		aObj:skinStdButton{obj=_G.Atr_SaveThisList_Button}
		aObj:skinStdButton{obj=_G.Atr_CancelSelectionButton, x1=3, x2=-1}
		aObj:skinStdButton{obj=_G.AuctionatorCloseButton}
	end

	-- Tabs
	aObj:skinTabs{obj=_G.Atr_ListTabs, up=true, lod=true, x1=4, y1=-4, x2=4, y2=-4}

	-- Buy
	aObj:skinDropDown{obj=_G.Atr_DropDownSL}
	-- Sell
	aObj:skinSlider{obj=_G.Atr_Hlist_ScrollFrame.ScrollBar}
	aObj:addSkinFrame{obj=_G.Atr_Hlist, ft="a", kfs=true, nb=true, x1=-4, x2=8}
	aObj:skinMoneyFrame{obj=_G.Atr_StackPrice, noWidth=true, moveSEB=true, moveGEB=true}
	aObj:skinMoneyFrame{obj=_G.Atr_ItemPrice, noWidth=true, moveSEB=true, moveGEB=true}
	aObj:skinMoneyFrame{obj=_G.Atr_StartingPrice, noWidth=true, moveSEB=true, moveGEB=true}
	if aObj.modBtns then
		aObj:skinStdButton{obj=_G.Atr_CreateAuctionButton}
	end
	aObj:skinEditBox{obj=_G.Atr_Batch_NumAuctions, regs={6}}
	aObj:skinEditBox{obj=_G.Atr_Batch_Stacksize, regs={6}}
	aObj:moveObject{obj=_G.Atr_Batch_Stacksize, x=-8}
	aObj:skinDropDown{obj=_G.Atr_Duration}
	-- More...
	if aObj.modBtns then
		aObj:skinStdButton{obj=_G.Atr_CheckActiveButton}
	end

-->>-- Error Frame
	aObj:addSkinFrame{obj=_G.Atr_Error_Frame, ft="a", kfs=true, nb=true}
-->>-- Confirm Frame
	aObj:addSkinFrame{obj=_G.Atr_Confirm_Frame, ft="a", kfs=true, nb=true}
-->>-- Buy_Confirm Frame
	aObj:skinEditBox{obj=_G.Atr_Buy_Confirm_Numstacks, regs={9}}
	aObj:addSkinFrame{obj=_G.Atr_Buy_Confirm_Frame, ft="a", kfs=true, nb=true}
-->>-- CheckActives Frame
	aObj:addSkinFrame{obj=_G.Atr_CheckActives_Frame, ft="a", kfs=true, nb=true}

-->>-- FullScan Frame
	if aObj.modBtns then
		aObj:skinStdButton{obj=_G.Atr_FullScanStartButton}
		aObj:skinStdButton{obj=_G.Atr_FullScanDone}
	end
	aObj:addSkinFrame{obj=_G.Atr_FullScanFrame, ft="a", kfs=true, nb=true, y1=4}

-->>-- Search Dialog
	aObj:skinEditBox{obj=_G.Atr_AS_Searchtext, regs={6}}
	aObj:skinDropDown{obj=_G.Atr_ASDD_Class, x2=110}
	aObj:skinDropDown{obj=_G.Atr_ASDD_Subclass, x2=110}
	aObj:skinEditBox{obj=_G.Atr_AS_Minlevel, regs={6}}
	aObj:moveObject{obj=_G.Atr_AS_Minlevel, x=-8}
	aObj:skinEditBox{obj=_G.Atr_AS_Maxlevel, regs={6}}
	aObj:skinEditBox{obj=_G.Atr_AS_MinItemlevel, regs={6}}
	aObj:skinEditBox{obj=_G.Atr_AS_MaxItemlevel, regs={6}}
	if aObj.modBtns then
		aObj:skinStdButton{obj=_G.Atr_Adv_Search_ResetBut}
		aObj:skinStdButton{obj=_G.Atr_Adv_Search_OKBut}
		aObj:skinStdButton{obj=_G.Atr_Adv_Search_CancelBut}
	end
	aObj:addSkinFrame{obj=_G.Atr_Adv_Search_Dialog, ft="a", kfs=true, nb=true, ofs=-10, y1=4}

end

aObj.addonsToSkin.Auctionator = function(self) -- v 4.0.19

	self:SecureHook("Atr_OnAuctionHouseShow", function()
		skinAuctionUI()
		self:Unhook(this, "Atr_OnAuctionHouseShow")
	end)

	self:SecureHookScript(_G.Atr_Error_Frame, "OnShow", function(this)
		if self.modBtns then
			self:skinStdButton{obj=self:getChild(this, 1)}
		end
		self:addSkinFrame{obj=this, ft="a", kfs=true,  nb=true}
		self:Unhook(this, "OnShow")
	end)

	-- register callback to indicate already skinned
	local pCnt = 0
	self.RegisterCallback("Auctionator_Config", "IOFPanel_Before_Skinning", function(this, panel)
		if panel.name == "Auctionator"
		or panel.parent == "Auctionator"
		and not self.iofSkinnedPanels[panel]
		then
			self.iofSkinnedPanels[panel] = true
			pCnt = pCnt + 1
		end
		if pCnt == 9 then
			self.UnregisterCallback("Auctionator_Config", "IOFPanel_Before_Skinning")
		end
	end)

	-- register callback to skin elements
	self.RegisterCallback("Auctionator_Config", "IOFPanel_After_Skinning", function(this, panel)
		local xOfs, bd
		local function skinKids(panel)

			for _, child in _G.ipairs{panel:GetChildren()} do
				if aObj:isDropDown(child) then
					xOfs = _G.Round(child:GetWidth())
					xOfs = xOfs == 40 and 109 or xOfs == 180 and 29 or xOfs == 220 and -70 or nil
					aObj:skinDropDown{obj=child, x2=xOfs}
				elseif child:IsObjectType("Slider") then
					aObj:skinSlider{obj=child, hgt=-4}
				elseif child:IsObjectType("CheckButton")
				and aObj.modChkBtns
				then
					aObj:skinCheckButton{obj=child}
				elseif child:IsObjectType("EditBox") then
					aObj:skinEditBox{obj=child, regs={6, child:GetName():find("UC_")and 7 or nil}} -- 6 is text
				elseif child:IsObjectType("Button")
				and aObj.modBtns
				then
					-- handle list buttons
					if child:GetNumRegions() == 5 then
						aObj:skinStdButton{obj=child}
					end
				elseif child:IsObjectType("Frame") then
					skinKids(child)
					-- add a frame if required
					bd = child:GetBackdrop()
					if bd and bd.edgeFile ~= "" then
						aObj:addSkinFrame{obj=child, ft="a", nb=true}
					end
				end
			end

		end

		if panel.name == "Auctionator"
		or panel.parent == "Auctionator"
		and not panel.sknd
		then
			panel:SetBackdrop(nil)
			skinKids(panel)
			panel.sknd = true
		end
		if pCnt == 9 then
			self.UnregisterCallback("Auctionator_Config", "IOFPanel_After_Skinning")
			pCnt = nil
		end
	end)

	self:SecureHookScript(_G.Atr_MemorizeFrame, "OnShow", function(this)
		self:skinEditBox{obj=_G.Atr_Mem_EB_itemName, regs={6}} -- 6 is text
		self:skinDropDown{obj=_G.Atr_Mem_DD_numStacks}
		self:skinEditBox{obj=_G.Atr_Mem_EB_stackSize, regs={6}} -- 6 is text
		if self.modBtns then
			self:skinStdButton{obj=_G.Atr_Mem_Forget}
			self:skinStdButton{obj=self:getChild(this, 5)}
			self:skinStdButton{obj=self:getChild(this, 6)}
		end
		self:addSkinFrame{obj=this, ft="a", kfs=true, nb=true}
		self:Unhook(this, "OnShow")
	end)
	self:SecureHookScript(_G.Atr_ConfirmClear_Frame, "OnShow", function(this)
		if self.modBtns then
			self:skinStdButton{obj=_G.Atr_ClearConfirm_Cancel}
			self:skinStdButton{obj=self:getChild(this, 2)}
		end
		self:addSkinFrame{obj=this, ft="a", kfs=true, nb=true}
		self:Unhook(this, "OnShow")
	end)
	self:SecureHookScript(_G.Atr_ShpList_Edit_Frame, "OnShow", function(this)
		self:skinSlider{obj=_G.Atr_ShpList_Edit_FrameScrollFrame.ScrollBar, rt="artwork"}--, wdth=-4, size=3, hgt=-10}
		if self.modBtns then
			self:skinStdButton{obj=self:getChild(this, 2)} -- Cancel button
			self:skinStdButton{obj=_G.Atr_ShpList_ImportSaveBut}
			self:skinStdButton{obj=_G.Atr_ShpList_SaveBut}
			self:skinStdButton{obj=_G.Atr_ShpList_SelectAllBut}
		end
		self:addSkinFrame{obj=this, ft="a", kfs=true, nb=true}
		self:Unhook(this, "OnShow")
	end)
	self:SecureHookScript(_G.Atr_SList_Conflict_Frame, "OnShow", function(this)
		if self.modBtns then
			self:skinStdButton{obj=_G.Atr_SList_Conflict_OKAY}
		end
		self:addSkinFrame{obj=this, ft="a", kfs=true, nb=true}
		self:Unhook(this, "OnShow")
	end)

end
