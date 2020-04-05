local _, aObj = ...
if not aObj:isAddonEnabled("Auctionator") then return end
local _G = _G

aObj.addonsToSkin.Auctionator = function(self) -- v 8.3.0

	self.RegisterCallback("Auctionator", "Auction_House_Show", function(this)

		if self.modBtns then
			-- N.B. both buttons are named the same [AuctionatorToggle]
			for _, btn in _G.ipairs{_G.AuctionatorButtonFrame:GetChildren()} do
				self:skinStdButton{obj=btn}
			end
		end

		self:removeNineSlice(_G.AuctionatorShoppingLists.NineSlice)
		self:skinDropDown{obj=_G.AuctionatorShoppingLists_ListDropDown}
		_G.AuctionatorShoppingLists.ScrollList.ScrollFrame.ArtOverlay:DisableDrawLayer("OVERLAY")
		self:removeInset(_G.AuctionatorShoppingLists.ScrollList.InsetFrame)
		self:skinSlider{obj=_G.AuctionatorShoppingLists.ScrollList.ScrollFrame.scrollBar, wdth=-4}
		self:addSkinFrame{obj=_G.AuctionatorShoppingLists, ft="a", kfs=true, nb=true, ri=true, x1=-1, y2=-3}
		if self.modBtns then
			self:skinCloseButton{obj=_G.AuctionatorShoppingLists_CloseButton}
			self:skinStdButton{obj=_G.AuctionatorShoppingLists_CreateList}
			self:skinStdButton{obj=_G.AuctionatorShoppingLists_DeleteList}
			self:skinStdButton{obj=_G.AuctionatorShoppingLists_AddItem}
			self:skinStdButton{obj=_G.AuctionatorShoppingLists_ListSearch}
		end

		self.UnregisterCallback("Auctionator", "Auction_House_Show")
	end)

	-- skin Config panels are required
	local pCnt = 0
	self.RegisterCallback("Auctionator_Config", "IOFPanel_Before_Skinning", function(this, panel)
		if self:hasTextInName(panel, "AuctionatorConfig")
		and not self.iofSkinnedPanels[panel]
		then
			self.iofSkinnedPanels[panel] = true
			pCnt = pCnt + 1
		end
		if pCnt == 6 then
			self.UnregisterCallback("Auctionator_Config", "IOFPanel_Before_Skinning")
		end
	end)

	-- register callback to skin elements
	self.RegisterCallback("Auctionator_Config", "IOFPanel_After_Skinning", function(this, panel)
		local function skinKids(panel)

			for _, child in _G.ipairs{panel:GetChildren()} do
				if child:IsObjectType("CheckButton")
				and aObj.modChkBtns
				then
					aObj:skinCheckButton{obj=child}
				elseif child:IsObjectType("EditBox") then
					aObj:skinEditBox{obj=child, regs={1, 6}} --1 & 6 are text
				elseif child:IsObjectType("Frame") then
					skinKids(child)
				end
			end

		end

		if self:hasTextInName(panel, "AuctionatorConfig")
		and not panel.sknd
		then
			skinKids(panel)
			panel.sknd = true
		end
		if pCnt == 6 then
			self.UnregisterCallback("Auctionator_Config", "IOFPanel_After_Skinning")
			pCnt = nil
		end
	end)

end
