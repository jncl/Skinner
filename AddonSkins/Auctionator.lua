local _, aObj = ...
if not aObj:isAddonEnabled("Auctionator") then return end
local _G = _G

aObj.addonsToSkin.Auctionator = function(self) -- v 8.3.0.5

	self.RegisterCallback("Auctionator", "Auction_House_Show", function(this)

		if _G.Auctionator.State.SplashScreenRef then
			_G.Auctionator.State.SplashScreenRef.Bg:SetTexture(nil)
			self:removeNineSlice(_G.Auctionator.State.SplashScreenRef.NineSlice)
			self:skinSlider{obj=_G.Auctionator.State.SplashScreenRef.ScrollFrame.ScrollBar}
			self:addSkinFrame{obj=_G.Auctionator.State.SplashScreenRef, ft="a", kfs=true, nb=true, ri=true}
			if self.modBtns then
				self:skinCloseButton{obj=_G.Auctionator.State.SplashScreenRef.Close}
			end
			if self.modChkBtns then
				self:skinCheckButton{obj=_G.Auctionator.State.SplashScreenRef.HideCheckbox.CheckBox}
			end
		end

		-- Tabs
		if _G.Auctionator.State.TabFrameRef then
			for key, tab in pairs(_G.Auctionator.State.TabFrameRef.Tabs) do
				aObj:Debug("Auctionator Tab: [%s, %s, %s, %s]", key, tab, tab.displayMode, tab.ahTabIndex)
				self:keepRegions(tab, {7, 8})
				self:addSkinFrame{obj=tab, ft=ftype, kfs=true, nb=true, noBdr=self.isTT, x1=6, y1=0, x2=-6, y2=2}
				if self.isTT then
					self:setInactiveTab(tab.sf)
					-- add to table to display tab textures (handle mismatched index)
					_G.AuctionHouseFrame.tabsForDisplayMode[tab.displayMode] = tab.ahTabIndex == 4 and tab.ahTabIndex or tab.ahTabIndex - 1
				end
				-- change highlight texture
				local ht = tab:GetHighlightTexture()
				ht:SetTexture([[Interface\PaperDollInfoFrame\UI-Character-Tab-Highlight]])
				ht:ClearAllPoints()
				ht:SetPoint("TOPLEFT", 8, 2)
				ht:SetPoint("BOTTOMRIGHT", -8, 0)
				ht = nil
			end
		end

		_G.AuctionatorShoppingListFrame.Bg:SetTexture(nil)
		self:removeNineSlice(_G.AuctionatorShoppingListFrame.NineSlice)
		self:skinDropDown{obj=_G.AuctionatorShoppingListFrame.ListDropdown}
		_G.AuctionatorShoppingListFrame.ScrollList.ScrollFrame.ArtOverlay:DisableDrawLayer("OVERLAY")
		self:removeInset(_G.AuctionatorShoppingListFrame.ScrollList.InsetFrame)
		self:skinSlider{obj=_G.AuctionatorShoppingListFrame.ScrollList.ScrollFrame.scrollBar, wdth=-4}
		self:skinSlider{obj=_G.AuctionatorShoppingListFrame.ResultsListing.ScrollFrame.scrollBar, wdth=-4}
		self:getChild(_G.AuctionatorShoppingListFrame, 8).Bg:SetTexture(nil) -- Background for Add & Search buttons
		for _, child in ipairs{_G.AuctionatorShoppingListFrame.ResultsListing.HeaderContainer:GetChildren()} do
			self:keepRegions(child, {4, 5, 6}) -- N.B. regions 4 is text, 5 is highlight, 6 is arrow
			self:addSkinFrame{obj=child, ft="a", kfs=true, nb=true, ofs=1, x1=-2, x2=2}
		end
		if self.modBtns then
			self:skinStdButton{obj=_G.AuctionatorShoppingListFrame.CreateList}
			self:skinStdButton{obj=_G.AuctionatorShoppingListFrame.DeleteList}
			self:skinStdButton{obj=_G.AuctionatorShoppingListFrame.Rename}
			self:skinStdButton{obj=_G.AuctionatorShoppingLists_AddItem}
			self:skinStdButton{obj=_G.AuctionatorShoppingListFrame.ManualSearch}
		end

		_G.AuctionatorConfigFrame.Bg:SetTexture(nil)
		self:removeNineSlice(_G.AuctionatorConfigFrame.NineSlice)
		self:skinEditBox{obj=_G.AuctionatorConfigFrame.DiscordLink.InputBox, regs={6}} -- 6 is text
		self:skinEditBox{obj=_G.AuctionatorConfigFrame.BugReportLink.InputBox, regs={6}} -- 6 is text
		self:skinEditBox{obj=_G.AuctionatorConfigFrame.TechnicalRoadmap.InputBox, regs={6}} -- 6 is text
		if self.modBtns then
			self:skinStdButton{obj=_G.AuctionatorConfigFrame.ScanButton}
			self:skinStdButton{obj=_G.AuctionatorConfigFrame.OptionsButton}
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
