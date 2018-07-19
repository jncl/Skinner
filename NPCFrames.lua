local aName, aObj = ...

local _G = _G
local ftype = "n"

local pairs = _G.pairs

-- The following function is used by the GossipFrame & QuestFrame functions
local function setupQuestDisplayColours()

	_G.NORMAL_QUEST_DISPLAY = "|cff" .. aObj:RGBPercToHex(aObj.HTr, aObj.HTg, aObj.HTb) .. "%s|r"
	_G.TRIVIAL_QUEST_DISPLAY = "|cff" .. aObj:RGBPercToHex(aObj.BTr, aObj.BTg, aObj.BTb) .. "%s (low level)|r"
	_G.IGNORED_QUEST_DISPLAY = "|cff" .. aObj:RGBPercToHex(aObj.ITr, aObj.ITg, aObj.ITb) .. "%s (ignored)|r"

end

aObj.blizzLoDFrames[ftype].AlliedRacesUI = function(self)
	if not self.db.profile.AlliedRacesUI or self.initialized.AlliedRacesUI then return end
	self.initialized.AlliedRacesUI = true

	self:SecureHookScript(_G.AlliedRacesFrame, "OnShow", function(this)
		this.ModelFrame:DisableDrawLayer("BORDER")
		this.ModelFrame:DisableDrawLayer("ARTWORK")
		this.RaceInfoFrame.ScrollFrame.Child.RaceDescriptionText:SetTextColor(self.BTr, self.BTg, self.BTb)
		this.RaceInfoFrame.ScrollFrame.Child.ObjectivesFrame.Description:SetTextColor(self.BTr, self.BTg, self.BTb)
		this.RaceInfoFrame.ScrollFrame.Child.ObjectivesFrame.HeaderButton:DisableDrawLayer("BACKGROUND")
		this.RaceInfoFrame.ScrollFrame.Child.ObjectivesFrame:DisableDrawLayer("BACKGROUND")
		self:skinSlider{obj=this.RaceInfoFrame.ScrollFrame.ScrollBar, rt="background", wdth=-5}
		this.RaceInfoFrame.ScrollFrame.ScrollBar.ScrollUpBorder:SetBackdrop(nil)
		this.RaceInfoFrame.ScrollFrame.ScrollBar.ScrollDownBorder:SetBackdrop(nil)
		this.RaceInfoFrame.ScrollFrame.ScrollBar.Border:SetBackdrop(nil)
		this.RaceInfoFrame.AlliedRacesRaceName:SetTextColor(self.HTr, self.HTg, self.HTb)
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, y1=2, x2=1}
		if self.modBtnBs then
			self:addButtonBorder{obj=this.ModelFrame.AlliedRacesMaleButton, ofs=0}
			self:addButtonBorder{obj=this.ModelFrame.AlliedRacesFemaleButton, ofs=0}
		end
		for ability in this.abilityPool:EnumerateActive() do
			ability.Text:SetTextColor(self.BTr, self.BTg, self.BTb)
			self:getRegion(ability, 3):SetTexture(nil) -- Border texture
			self:addButtonBorder{obj=ability, relTo=ability.Icon}
		end
		for bullet in this.bulletPool:EnumerateActive() do
			bullet.Text:SetTextColor(self.BTr, self.BTg, self.BTb)
		end
		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzLoDFrames[ftype].AuctionUI = function(self)
	if not self.prdb.AuctionUI or self.initialized.AuctionUI then return end
	self.initialized.AuctionUI = true

	local function skinBtn(btnName, idx)
		aObj:keepFontStrings(_G[btnName .. idx])
		_G[btnName .. idx .. "Highlight"]:SetAlpha(1)
		_G[btnName .. idx .. "ItemNormalTexture"]:SetAlpha(0) -- texture changed in code
		if aObj.modBtnBs then
			aObj:addButtonBorder{obj=_G[btnName .. idx .. "Item"], reParent={_G[btnName .. idx .. "Count"], _G[btnName .. idx .. "Stock"]}}
			aObj:colourBtnBorder(_G[btnName .. idx .. "Item"])
		end
	end

	self:SecureHookScript(_G.AuctionFrame, "OnShow", function(this)
		-- hide filter texture when filter is clicked
		self:SecureHook("FilterButton_SetUp", function(button, ...)
			_G[button:GetName() .. "NormalTexture"]:SetAlpha(0)
		end)

		self:skinTabs{obj=this, lod=true}
		self:addSkinFrame{obj=_G.AuctionFrame, ft=ftype, kfs=true, hdr=true, x1=10, y1=-11, y2=5}

		-- AuctionFrame Browse
		for i = 1, _G.NUM_FILTERS_TO_DISPLAY do
			self:keepRegions(_G["AuctionFilterButton" .. i], {3, 4}) -- N.B. region 3 is the highlight, 4 is the text
			self:addSkinFrame{obj=_G["AuctionFilterButton" .. i], ft=ftype, aso={bd=5}}
		end
		self:skinSlider{obj=_G.BrowseFilterScrollFrame.ScrollBar, rt="artwork"}
		self:skinSlider{obj=_G.BrowseScrollFrame.ScrollBar, rt="artwork"}
		for _, type in pairs{"Quality", "Level", "Duration", "HighBidder", "CurrentBid"} do
			self:keepRegions(_G["Browse" .. type .. "Sort"], {4, 5, 6}) -- N.B. region 4 is the text, 5 is the arrow, 6 is the highlight
			self:addSkinFrame{obj=_G["Browse" .. type .. "Sort"], ft=ftype, aso={bd=5}}
		end
		for i = 1, _G.NUM_BROWSE_TO_DISPLAY do
			if _G["BrowseButton" .. i].Orig then break end -- Auctioneer CompactUI loaded
			skinBtn("BrowseButton", i)
		end
		for _, type in pairs{"Name", "MinLevel", "MaxLevel"} do
			self:skinEditBox{obj=_G["Browse" .. type], regs={6, type == "Name" and 7 or nil}, mi=true} -- 6 is text, 7 is icon
			self:moveObject{obj=_G["Browse" .. type], x=type == "MaxLevel" and -6 or -4, y=type ~= "MaxLevel" and 3 or 0}
		end
		self:skinDropDown{obj=_G.BrowseDropDown, x2=109}
		self:skinCheckButton{obj=_G.IsUsableCheckButton}
		self:skinCheckButton{obj=_G.ShowOnPlayerCheckButton}
		self:addButtonBorder{obj=_G.BrowsePrevPageButton, ofs=-2, y1=-3, x2=-3}
		self:addButtonBorder{obj=_G.BrowseNextPageButton, ofs=-2, y1=-3, x2=-3}
		self:skinMoneyFrame{obj=_G.BrowseBidPrice, moveSEB=true}
		self:skinStdButton{obj=_G.BrowseSearchButton}
		self:skinStdButton{obj=_G.BrowseResetButton}
		self:skinCheckButton{obj=_G.ExactMatchCheckButton}
		_G.BrowseBidButton:DisableDrawLayer("BORDER")
		self:skinStdButton{obj=_G.BrowseBidButton}
		_G.BrowseBuyoutButton:DisableDrawLayer("BORDER")
		self:skinStdButton{obj=_G.BrowseBuyoutButton}
		_G.BrowseCloseButton:DisableDrawLayer("BORDER")
		self:skinStdButton{obj=_G.BrowseCloseButton}

		self:SecureHookScript(_G.BrowseWowTokenResults, "OnShow", function(this)
			this.Token:DisableDrawLayer("BACKGROUND")
			self:skinStdButton{obj=this.Buyout}
			self:skinStdButton{obj=_G.StoreButton, x1=14, y1=2, x2=-14, y2=2}
			self:Unhook(this, "OnShow")
		end)
		self:SecureHookScript(_G.WowTokenGameTimeTutorial, "OnShow", function(this)
			this.LeftDisplay.Label:SetTextColor(self.HTr, self.HTg, self.HTb)
			this.LeftDisplay.Tutorial1:SetTextColor(self.BTr, self.Tg, self.Tb)
			this.RightDisplay.Label:SetTextColor(self.HTr, self.HTg, self.HTb)
			this.RightDisplay.Tutorial1:SetTextColor(self.BTr, self.Tg, self.Tb)
			self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true, ofs=1, y1=2, y2=220}
			self:Unhook(this, "OnShow")
		end)
		self:Unhook(this, "OnShow")

		-- AuctionFrame Bid
		for _, type in pairs{"Quality", "Level", "Duration", "Buyout", "Status", "Bid"} do
			self:keepRegions(_G["Bid" .. type .. "Sort"], {4, 5, 6}) -- N.B. region 4 is the text, 5 is the arrow, 6 is the highlight
			self:addSkinFrame{obj=_G["Bid" .. type .. "Sort"], ft=ftype, aso={bd=5}}
		end
		for i = 1, _G.NUM_BIDS_TO_DISPLAY do
			skinBtn("BidButton", i)
		end
		self:skinSlider{obj=_G.BidScrollFrame.ScrollBar, rt="artwork"}
		self:skinMoneyFrame{obj=_G.BidBidPrice, moveSEB=true}
		_G.BidCloseButton:DisableDrawLayer("BORDER")
		_G.BidBuyoutButton:DisableDrawLayer("BORDER")
		_G.BidBidButton:DisableDrawLayer("BORDER")
		self:skinStdButton{obj=_G.BidBidButton}
		self:skinStdButton{obj=_G.BidBuyoutButton}
		self:skinStdButton{obj=_G.BidCloseButton}
		self:Unhook(this, "OnShow")

		-- AuctionFrame Auctions
		for _, type in pairs{"Quality", "Duration", "HighBidder", "Bid"} do
			self:keepRegions(_G["Auctions" .. type .. "Sort"], {4, 5, 6}) -- N.B. region 4 is the text, 5 is the arrow, 6 is the highlight
			self:addSkinFrame{obj=_G["Auctions" .. type .. "Sort"], ft=ftype, aso={bd=5}}
		end
		self:skinSlider{obj=_G.AuctionsScrollFrame.ScrollBar, rt="artwork"}
		for i = 1, _G.NUM_AUCTIONS_TO_DISPLAY do
			skinBtn("AuctionsButton", i)
		end
		if not self.modBtnBs then
			self:resizeEmptyTexture(self:getRegion(_G.AuctionsItemButton, 2))
		else
			self:getRegion(_G.AuctionsItemButton, 2):SetAlpha(0) -- texture is changed in blizzard code
			self:addButtonBorder{obj=_G.AuctionsItemButton}
		end
		self:skinEditBox{obj=_G.AuctionsStackSizeEntry, regs={6}, noWidth=true} -- 6 is text
		self:skinEditBox{obj=_G.AuctionsNumStacksEntry, regs={6}, noWidth=true} -- 6 is text
		self:skinDropDown{obj=_G.PriceDropDown}
		self:skinMoneyFrame{obj=_G.StartPrice, moveSEB=true}
		self:skinMoneyFrame{obj=_G.BuyoutPrice, moveSEB=true}
		self:skinDropDown{obj=_G.DurationDropDown}
		self:skinStdButton{obj=_G.AuctionsStackSizeMaxButton}
		self:skinStdButton{obj=_G.AuctionsNumStacksMaxButton}
		self:skinStdButton{obj=_G.AuctionsCreateAuctionButton}
		self:skinStdButton{obj=_G.AuctionsCancelAuctionButton}
		self:skinStdButton{obj=_G.AuctionsCloseButton}
		self:Unhook(this, "OnShow")

		self:SecureHookScript(_G.AuctionProgressFrame, "OnShow", function(this)
			this:DisableDrawLayer("BACKGROUND")
			this:DisableDrawLayer("ARTWORK")
			self:keepFontStrings(_G.AuctionProgressBar)
			self:moveObject{obj=_G.AuctionProgressBar.Text, y=-2}
			self:skinStatusBar{obj=_G.AuctionProgressBar, fi=0}
			self:Unhook(this, "OnShow")
		end)

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzLoDFrames[ftype].AzeriteRespecUI = function(self)
	if not self.db.profile.AzeriteRespecUI or self.initialized.AzeriteRespecUI then return end
	self.initialized.AzeriteRespecUI = true

	self:addButtonBorder{obj=_G.AzeriteRespecFrame.ItemSlot}
	_G.AzeriteRespecFrame.ButtonFrame:DisableDrawLayer("BORDER")
	self:removeMagicBtnTex(_G.AzeriteRespecFrame.ButtonFrame.AzeriteRespecButton)
	self:skinStdButton{obj=_G.AzeriteRespecFrame.ButtonFrame.AzeriteRespecButton}
	_G.AzeriteRespecFrame.ButtonFrame.MoneyFrameEdge:DisableDrawLayer("BACKGROUND")
	self:addSkinFrame{obj=_G.AzeriteRespecFrame, ft=ftype, kfs=true, ofs=1, y1=2}

	self:skinCloseButton{obj=_G.AzeriteRespecFrame.HelpBox.CloseButton}

end

aObj.blizzFrames[ftype].BankFrame = function(self)
	if not self.prdb.BankFrame or self.initialized.BankFrame then return end
	self.initialized.BankFrame = true

	self:SecureHookScript(_G.BankFrame, "OnShow", function(this)
		self:skinEditBox{obj=_G.BankItemSearchBox, regs={6, 7}, mi=true, noHeight=true, noMove=true} -- 6 is text, 7 is icon
		self:skinStdButton{obj=_G.BankFramePurchaseButton}
		self:removeInset(_G.BankFrameMoneyFrameInset)
		_G.BankFrameMoneyFrameBorder:DisableDrawLayer("BACKGROUND")
		self:skinTabs{obj=this, x1=6, y1=0, x2=-6, y2=2}
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, x1=-3, y1=2, x2=1, y2=-4}
		self:keepFontStrings(_G.BankSlotsFrame)

		-- ReagentBankFrame
		_G.ReagentBankFrame:DisableDrawLayer("ARTWORK") -- bank slots texture
		_G.ReagentBankFrame:DisableDrawLayer("BACKGROUND") -- bank slots shadow texture
		_G.ReagentBankFrame:DisableDrawLayer("BORDER") -- shadow textures
		_G.ReagentBankFrame.UnlockInfo:DisableDrawLayer("BORDER")
		_G.RaiseFrameLevelByTwo(_G.ReagentBankFrame.UnlockInfo) -- hide the slot button textures
		self:skinStdButton{obj=_G.ReagentBankFrameUnlockInfoPurchaseButton}
		self:skinStdButton{obj=_G.ReagentBankFrame.DespositButton}

		if self.modBtnBs then
			self:addButtonBorder{obj=_G.BankItemAutoSortButton, ofs=0, y1=1}
			-- add button borders to bank items
			for i = 1, 28 do
				self:addButtonBorder{obj=_G["BankFrameItem" .. i], ibt=true, reParent={_G["BankFrameItem" .. i].IconQuestTexture}}
				-- force quality border update
				_G.BankFrameItemButton_Update(_G["BankFrameItem" .. i])
				if not _G["BankFrameItem" .. i].hasItem then
					_G["BankFrameItem" .. i].sbb:SetBackdropBorderColor(0.5, 0.5, 0.5, 1)
				end
			end
			-- add button borders to bags
			for i = 1, _G.NUM_BANKBAGSLOTS do
				self:addButtonBorder{obj=_G.BankSlotsFrame["Bag" .. i], ibt=true}
			end
			-- add button borders to reagent bank items
			self:SecureHookScript(_G.ReagentBankFrame, "OnShow", function(this)
				for i = 1, this.size do
					self:addButtonBorder{obj=this["Item" .. i], ibt=true, reParent={this["Item" .. i].IconQuestTexture}}
					-- force quality border update
					_G.BankFrameItemButton_Update(this["Item" .. i])
					if not this["Item" .. i].hasItem then
						this["Item" .. i].sbb:SetBackdropBorderColor(0.5, 0.5, 0.5, 0.25)
					end
				end
				self:Unhook(this, "OnShow")
			end)
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzLoDFrames[ftype].BarbershopUI = function(self)
	if not self.prdb.BarbershopUI or self.initialized.Barbershop then return end
	self.initialized.Barbershop = true

	self:SecureHookScript(_G.BarberShopFrame, "OnShow", function(this)
		for i = 1, #this.Selector do
			self:addButtonBorder{obj=self:getChild(this.Selector[i], 1), ofs=-2}
			self:addButtonBorder{obj=self:getChild(this.Selector[i], 2), ofs=-2}
		end
		self:keepFontStrings(_G.BarberShopFrameMoneyFrame)
		self:skinStdButton{obj=_G.BarberShopFrameOkayButton}
		self:skinStdButton{obj=_G.BarberShopFrameCancelButton}
		self:skinStdButton{obj=_G.BarberShopFrameResetButton}
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, x1=35, y1=-32, x2=-32, y2=42}

		-- Banner Frame
		self:keepFontStrings(_G.BarberShopBannerFrame)
		_G.BarberShopBannerFrameCaption:ClearAllPoints()
		_G.BarberShopBannerFrameCaption:SetPoint("CENTER", this, "TOP", 0, -46)
		_G.BarberShopBannerFrame:SetParent(this) -- make text appear above skinFrame

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzLoDFrames[ftype].BlackMarketUI = function(self)
	if not self.prdb.BlackMarketUI or self.initialized.BlackMarketUI then return end
	self.initialized.BlackMarketUI = true

	self:SecureHookScript(_G.BlackMarketFrame, "OnShow", function(this)
		-- move title text
		self:moveObject{obj=self:getRegion(this, 22), y=-4}
		-- HotDeal frame
		self:keepFontStrings(this.HotDeal)
		if self.modBtnBs then
			self:addButtonBorder{obj=this.HotDeal.Item, reParent={this.HotDeal.Item.Count, this.HotDeal.Item.Stock}}
			self:colourBtnBorder(this.HotDeal.Item)
		end

		-- column headings
		for _, type in pairs{"Name", "Level", "Type", "Duration", "HighBidder", "CurrentBid"} do
			obj =
			self:keepFontStrings(this["Column" .. type])
			self:addSkinFrame{obj=this["Column" .. type], ft=ftype, aso={bd=5}}
		end
		self:skinSlider{obj=_G.BlackMarketScrollFrameScrollBar, wdth=-4}
		this.MoneyFrameBorder:DisableDrawLayer("BACKGROUND")
		self:skinMoneyFrame{obj=_G.BlackMarketBidPrice}
		self:skinStdButton{obj=this.BidButton}
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-2}

		local function skinSFButtons(scrollFrame)
			for i = 1, #scrollFrame.buttons do
				self:removeRegions(scrollFrame.buttons[i], {1, 2, 3})
				scrollFrame.buttons[i].Item:GetNormalTexture():SetTexture(nil)
				scrollFrame.buttons[i].Item:GetPushedTexture():SetTexture(nil)
				if self.modBtnBs then
					self:addButtonBorder{obj=scrollFrame.buttons[i].Item, reParent={scrollFrame.buttons[i].Item.Count, scrollFrame.buttons[i].Item.Stock}}
					self:colourBtnBorder(scrollFrame.buttons[i].Item)
				end
			end
		end
		self:SecureHook("BlackMarketScrollFrame_Update", function(this)
			skinSFButtons(_G.BlackMarketScrollFrame)
		end)

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzLoDFrames[ftype].FlightMap = function(self)
	if not self.prdb.FlightMap or self.initialized.FlightMap then return end

	if not _G.FlightMapFrame then
		_G.C_Timer.After(0.1, function()
			self.blizzLoDFrames[ftype].FlightMap(self)
		end)
		return
	end

	self.initialized.FlightMap = true

	self:SecureHookScript(_G.FlightMapFrame, "OnShow", function(this)
		self:keepFontStrings(this.BorderFrame)
		self:moveObject{obj=_G.FlightMapFrameCloseButton, x=3, y=1}
		self:addSkinFrame{obj=this, ft=ftype, ofs=4, y1=3}
		this.sf:SetFrameStrata("LOW") -- allow map textures to be visible

		-- hook this to remove ZoneLabel background texture
		for dP, _ in pairs(this.dataProviders) do
			if dP.ZoneLabel then
				dP.ZoneLabel.TextBackground:SetTexture(nil)
				-- hook this to handle when Map re-opened
				self:SecureHook(dP.ZoneLabel.dataProvider, "RefreshAllData", function(this, fromOnShow)
					this.ZoneLabel.TextBackground:SetTexture(nil)
				end)
				break
			end
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].GossipFrame = function(self)
	if not self.prdb.GossipFrame or self.initialized.GossipFrame then return end
	self.initialized.GossipFrame = true

	setupQuestDisplayColours()

	self:SecureHookScript(_G.GossipFrame, "OnShow", function(this)
		self:keepFontStrings(_G.GossipFrameGreetingPanel)
		_G.GossipGreetingText:SetTextColor(self.HTr, self.HTg, self.HTb)
		self:skinStdButton{obj=_G.GossipFrameGreetingGoodbyeButton}
		self:skinSlider{obj=_G.GossipGreetingScrollFrame.ScrollBar, rt="artwork"}
		for i = 1, _G.NUMGOSSIPBUTTONS do
			self:getRegion(_G["GossipTitleButton" .. i], 3):SetTextColor(self.BTr, self.BTg, self.BTb)
		end
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-2}

		-- NPCFriendshipStatusBar
		self:removeRegions(_G.NPCFriendshipStatusBar, {1, 3, 4, 5 ,6})
		self:skinStatusBar{obj=_G.NPCFriendshipStatusBar, fi=0, bgTex=self:getRegion(_G.NPCFriendshipStatusBar, 7)}

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].GuildRegistrar = function(self)
	if not self.prdb.GuildRegistrar or self.initialized.GuildRegistrar then return end
	self.initialized.GuildRegistrar = true

	self:SecureHookScript(_G.GuildRegistrarFrame, "OnShow", function(this)
		self:keepFontStrings(_G.GuildRegistrarGreetingFrame)
		_G.AvailableServicesText:SetTextColor(self.HTr, self.HTg, self.HTb)
		self:skinStdButton{obj=_G.GuildRegistrarFrameGoodbyeButton}
		self:getRegion(_G.GuildRegistrarButton1, 3):SetTextColor(self.BTr, self.BTg, self.BTb)
		self:getRegion(_G.GuildRegistrarButton2, 3):SetTextColor(self.BTr, self.BTg, self.BTb)
		_G.GuildRegistrarPurchaseText:SetTextColor(self.BTr, self.BTg, self.BTb)
		self:skinStdButton{obj=_G.GuildRegistrarFrameCancelButton}
		self:skinStdButton{obj=_G.GuildRegistrarFramePurchaseButton}
		self:skinEditBox{obj=_G.GuildRegistrarFrameEditBox}

		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-2}

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzLoDFrames[ftype].ItemUpgradeUI = function(self)
	if not self.prdb.ItemUpgradeUI or self.initialized.ItemUpgradeUI then return end
	self.initialized.ItemUpgradeUI = true

	self:SecureHookScript(_G.ItemUpgradeFrame, "OnShow", function(this)
		this.HorzBar:SetTexture(nil)
		this.MissingDescription:SetTextColor(self.BTr, self.BTg, self.BTb)
		this.NoMoreUpgrades:SetTextColor(self.BTr, self.BTg, self.BTb)
		this.TitleTextLeft:SetTextColor(self.BTr, self.BTg, self.BTb)
		this.TitleTextRight:SetTextColor(self.BTr, self.BTg, self.BTb)

		this.ItemButton.IconTexture:SetAlpha(0)
		this.ItemButton:DisableDrawLayer("BACKGROUND")
		-- this.ItemButton.Grabber:SetTexture(nil)
		-- this.ItemButton.TextFrame:SetTexture(nil)
		-- this.ItemButton.TextGrabber:SetTexture(nil)
		self:addButtonBorder{obj=this.ItemButton, relTo=this.ItemButton.IconTexture, ofs=1}
		this.ItemButton.Frame:SetTexture(nil)
		this.ItemButton.ItemName:SetTextColor(self.BTr, self.BTg, self.BTb)
		this.ItemButton.MissingText:SetTextColor(self.BTr, self.BTg, self.BTb)

		this.ButtonFrame:DisableDrawLayer("BORDER", 2)
		-- this.ButtonFrame.ButtonBorder:SetTexture(nil)
		-- this.ButtonFrame.ButtonBottomBorder:SetTexture(nil)
		_G.ItemUpgradeFrameMoneyFrame:DisableDrawLayer("BACKGROUND")
		self:removeMagicBtnTex(_G.ItemUpgradeFrameUpgradeButton)
		self:skinStdButton{obj=_G.ItemUpgradeFrameUpgradeButton}
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ofs=2, x2=1}

		-- hook this to hide the ItemButton texture if empty
		self:SecureHook("ItemUpgradeFrame_Update", function()
			local icon = _G.GetItemUpgradeItemInfo()
			if icon then
				_G.ItemUpgradeFrame.ItemButton.IconTexture:SetAlpha(1)
			else
				_G.ItemUpgradeFrame.ItemButton.IconTexture:SetAlpha(0)
			end
			icon = nil
		end)
		-- hook this to remove background texture from stat lines
		self:SecureHook("ItemUpgradeFrame_GetStatRow", function(index, tryAdd)
			if _G.ItemUpgradeFrame.LeftStat[index] then _G.ItemUpgradeFrame.LeftStat[index].BG:SetTexture(nil) end
			if _G.ItemUpgradeFrame.RightStat[index] then _G.ItemUpgradeFrame.RightStat[index].BG:SetTexture(nil) end
		end)

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].MerchantFrame = function(self)
	if not self.prdb.MerchantFrame or self.initialized.MerchantFrame then return end
	self.initialized.MerchantFrame = true

	self:SecureHookScript(_G.MerchantFrame, "OnShow", function(this)
		self:skinTabs{obj=this, lod=true} -- do first otherwise error when TradeSkillMaster Addon is loaded
		self:skinDropDown{obj=_G.MerchantFrameLootFilter}
		self:removeInset(_G.MerchantExtraCurrencyInset)
		_G.MerchantExtraCurrencyBg:DisableDrawLayer("BACKGROUND")
		self:removeInset(_G.MerchantMoneyInset)
		_G.MerchantMoneyBg:DisableDrawLayer("BACKGROUND")
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-6}
		if self.modBtnBs then
			self:removeRegions(_G.MerchantPrevPageButton, {2})
			self:addButtonBorder{obj=_G.MerchantPrevPageButton, ofs=-2, y1=-3, x2=-3}
			self:removeRegions(_G.MerchantNextPageButton, {2})
			self:addButtonBorder{obj=_G.MerchantNextPageButton, ofs=-2, y1=-3, x2=-3}
		end

		-- Items/Buyback Items
		for i = 1, _G.math.max(_G.MERCHANT_ITEMS_PER_PAGE, _G.BUYBACK_ITEMS_PER_PAGE) do
			_G["MerchantItem" .. i .. "NameFrame"]:SetTexture(nil)
			if not self.modBtnBs then
				_G["MerchantItem" .. i .. "SlotTexture"]:SetTexture(self.esTex)
			else
				_G["MerchantItem" .. i .. "SlotTexture"]:SetTexture(nil)
				self:addButtonBorder{obj=_G["MerchantItem" .. i .. "ItemButton"], ibt=true}
			end
		end
		_G.MerchantBuyBackItemNameFrame:SetTexture(nil)
		if self.modBtnBs then
			_G.MerchantBuyBackItemSlotTexture:SetTexture(nil)
			self:addButtonBorder{obj=_G.MerchantBuyBackItemItemButton, ibt=true}
			-- remove surrounding border (diff=0.01375)
			self:getRegion(_G.MerchantRepairItemButton, 1):SetTexCoord(0.01375, 0.2675, 0.01375, 0.54875)
			_G.MerchantRepairAllIcon:SetTexCoord(0.295, 0.54875, 0.01375, 0.54875)
			_G.MerchantGuildBankRepairButtonIcon:SetTexCoord(0.57375, 0.83, 0.01375, 0.54875)
			self:addButtonBorder{obj=_G.MerchantRepairAllButton}
			self:addButtonBorder{obj=_G.MerchantRepairItemButton}
			self:addButtonBorder{obj=_G.MerchantGuildBankRepairButton}
		else
			_G.MerchantBuyBackItemSlotTexture:SetTexture(self.esTex)
		end

		self:Unhook(this, "OnShow")
	end)

	-- display limited availability item's stock count even when zero
	self:SecureHook("SetItemButtonStock", function(button, numInStock)
		if numInStock == 0
		and not button == _G.MerchantBuyBackItemItemButton
		then
			_G[button:GetName() .. "Stock"]:SetFormattedText(_G.MERCHANT_STOCK, numInStock)
			_G[button:GetName() .. "Stock"]:Show()
		end
	end)

end

aObj.blizzFrames[ftype].Petition = function(self)
	if not self.prdb.Petition or self.initialized.Petition then return end
	self.initialized.Petition = true

	self:SecureHookScript(_G.PetitionFrame, "OnShow", function(this)
		_G.PetitionFrameCharterTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
		_G.PetitionFrameCharterName:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G.PetitionFrameMasterTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
		_G.PetitionFrameMasterName:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G.PetitionFrameMemberTitle:SetTextColor(self.HTr, self.HTg, self.HTb)
		for i = 1, 9 do
			_G["PetitionFrameMemberName" .. i]:SetTextColor(self.BTr, self.BTg, self.BTb)
		end
		_G.PetitionFrameInstructions:SetTextColor(self.BTr, self.BTg, self.BTb)

		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-2}

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].PetStableFrame = function(self)
	if not self.prdb.PetStableFrame or self.initialized.PetStableFrame then return end
	self.initialized.PetStableFrame = true

	self:SecureHookScript(_G.PetStableFrame, "OnShow", function(this)

		_G.PetStableFrameModelBg:Hide()
		this.LeftInset:DisableDrawLayer("BORDER")
		_G.PetStableActiveBg:Hide()
		this.BottomInset:DisableDrawLayer("BORDER")
		_G.PetStableFrameStableBg:Hide()
		self:makeMFRotatable(_G.PetStableModel)
		_G.PetStableModelShadow:Hide()
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true, y1=2, x2=1}
		if self.modBtnBs then
			self:addButtonBorder{obj=_G.PetStableNextPageButton, ofs=0}
			self:addButtonBorder{obj=_G.PetStablePrevPageButton, ofs=0}
			self:addButtonBorder{obj=_G.PetStablePetInfo, relTo=_G.PetStableSelectedPetIcon}
			self:addButtonBorder{obj=_G.PetStableDiet, ofs=0, x2=-1}
		end
		-- slots
		for i = 1, _G.NUM_PET_ACTIVE_SLOTS do
			_G["PetStableActivePet" .. i].Border:Hide()
			if not self.modBtnBs then
				self:resizeEmptyTexture(_G["PetStableActivePet" .. i].Background)
			else
				_G["PetStableActivePet" .. i].Background:Hide()
				self:addButtonBorder{obj=_G["PetStableActivePet" .. i]}
			end
		end
		for i = 1, _G.NUM_PET_STABLE_SLOTS do
			if not self.modBtnBs then
				self:resizeEmptyTexture(_G["PetStableStabledPet" .. i].Background)
			else
				_G["PetStableStabledPet" .. i].Background:Hide()
				self:addButtonBorder{obj=_G["PetStableStabledPet" .. i]}
			end
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzLoDFrames[ftype].QuestChoice = function(self)
	if not self.prdb.QuestChoice or self.initialized.QuestChoice then return end
	self.initialized.QuestChoice = true

	self:SecureHookScript(_G.QuestChoiceFrame, "OnShow", function(this)
		this.DummyString:SetTextColor(self.BTr, self.BTg, self.BTb)
		-- for i = 1, 4 do
		for _, choice in pairs(this.Options) do
			choice.Header.Background:SetTexture(nil)
			choice.Header.Text:SetTextColor(self.HTr, self.HTg, self.HTb)
			choice.OptionText:SetTextColor(self.BTr, self.BTg, self.BTb)
			self:addButtonBorder{obj=choice.Rewards.Item, relTo=choice.Rewards.Item.Icon}
			choice.Rewards.Item.Name:SetTextColor(self.BTr, self.BTg, self.BTb)
			choice.Rewards.ReputationsFrame.Reputation1.Faction:SetTextColor(self.BTr, self.BTg, self.BTb)
			self:moveObject{obj=choice.Header, y=15}
			self:skinStdButton{obj=choice.OptionButtonsContainer.OptionButton1}
			self:skinStdButton{obj=choice.OptionButtonsContainer.OptionButton2}
		end
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ofs=-13, y1=-13}
		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].QuestFrame = function(self)
	if not self.prdb.QuestFrame or self.initialized.QuestFrame then return end
	self.initialized.QuestFrame = true

	setupQuestDisplayColours()

	self:SecureHookScript(_G.QuestFrame, "OnShow", function(this)
		self:RawHook("QuestFrame_SetTitleTextColor", function(fontString, ...)
			fontString:SetTextColor(self.HTr, self.HTg, self.HTb)
		end, true)
		self:RawHook("QuestFrame_SetTextColor", function(fontString, ...)
			fontString:SetTextColor(self.BTr, self.BTg, self.BTb)
		end, true)

		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true, x1=-3, y1=2, x2=1, y2=-2}

		--	Reward Panel
		self:keepFontStrings(_G.QuestFrameRewardPanel)
		self:skinStdButton{obj=_G.QuestFrameCompleteQuestButton}
		self:skinSlider{obj=_G.QuestRewardScrollFrame.ScrollBar, rt="artwork"}

		--	Progress Panel
		self:keepFontStrings(_G.QuestFrameProgressPanel)
		_G.QuestProgressTitleText:SetTextColor(self.HTr, self.HTg, self.HTb)
		_G.QuestProgressText:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G.QuestProgressRequiredMoneyText:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G.QuestProgressRequiredItemsText:SetTextColor(self.HTr, self.HTg, self.HTb)
		self:skinStdButton{obj=_G.QuestFrameGoodbyeButton}
		self:skinStdButton{obj=_G.QuestFrameCompleteButton}
		self:skinSlider{obj=_G.QuestProgressScrollFrame.ScrollBar, rt="artwork"}
		local btnName
		for i = 1, _G.MAX_REQUIRED_ITEMS do
			btnName = "QuestProgressItem" .. i
			_G[btnName .. "NameFrame"]:SetTexture(nil)
			self:addButtonBorder{obj=_G[btnName], libt=true}
		end
		btnName = nil
		self:SecureHook("QuestFrameProgressItems_Update", function()
			local r, g ,b = _G.QuestProgressRequiredMoneyText:GetTextColor()
			-- if red colour is less than 0.2 then it needs to be coloured
			if r < 0.2 then
				_G.QuestProgressRequiredMoneyText:SetTextColor(self.BTr - r, self.BTg - g, self.BTb - b)
			end
			r, g, b = nil, nil, nil
		end)

		--	Detail Panel
		self:keepFontStrings(_G.QuestFrameDetailPanel)
		self:skinStdButton{obj=_G.QuestFrameDeclineButton}
		self:skinStdButton{obj=_G.QuestFrameAcceptButton}
		self:skinSlider{obj=_G.QuestDetailScrollFrame.ScrollBar, rt="artwork"}

		--	Greeting Panel
		self:keepFontStrings(_G.QuestFrameGreetingPanel)
		self:keepFontStrings(_G.QuestGreetingScrollChildFrame) -- hide Horizontal Break texture
		self:skinStdButton{obj=_G.QuestFrameGreetingGoodbyeButton}
		self:skinSlider{obj=_G.QuestGreetingScrollFrame.ScrollBar, rt="artwork"}
		if _G.QuestFrameGreetingPanel:IsShown() then
			_G.GreetingText:SetTextColor(self.BTr, self.BTg, self.BTb)
			_G.CurrentQuestsText:SetTextColor(self.HTr, self.HTg, self.HTb)
			_G.AvailableQuestsText:SetTextColor(self.HTr, self.HTg, self.HTb)
		end

		self:Unhook(this, "OnShow")
	end)

	-- QuestNPCModel
	self:SecureHookScript(_G.QuestNPCModel, "OnShow", function(this)
		self:keepFontStrings(_G.QuestNPCModelTextFrame)
		self:skinSlider{obj=_G.QuestNPCModelTextScrollFrame.ScrollBar}
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ofs=4, y2=-81} -- similar to GuildNewsBossModel
		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].QuestInfo = function(self)
	if not self.prdb.GossipFrame
	and not self.prdb.QuestFrame
	and not self.prdb.QuestMap
	or self.initialized.QuestInfo
	then
		return
	end
	self.initialized.QuestInfo = true

	local function skinRewards(frame)

		if frame.Header:IsObjectType("FontString") then -- QuestInfoRewardsFrame
			frame.Header:SetTextColor(self.HTr, self.HTg, self.HTb)
		end
		frame.ItemChooseText:SetTextColor(self.BTr, self.BTg, self.BTb)
		frame.ItemReceiveText:SetTextColor(self.BTr, self.BTg, self.BTb)
		frame.PlayerTitleText:SetTextColor(self.BTr, self.BTg, self.BTb)
		if frame.XPFrame.ReceiveText then -- QuestInfoRewardsFrame
			frame.XPFrame.ReceiveText:SetTextColor(self.BTr, self.BTg, self.BTb)
		end
		-- RewardButtons
		for i = 1, #frame.RewardButtons do
			frame.RewardButtons[i].NameFrame:SetTexture(nil)
			if self.modBtnBs
			and not frame.RewardButtons[i].sbb then
				aObj:addButtonBorder{obj=frame.RewardButtons[i], libt=true}
			end
		end
		-- SpellReward
		for spellBtn in frame.spellRewardPool:EnumerateActive() do
			spellBtn.NameFrame:SetTexture(nil)
			spellBtn:DisableDrawLayer("OVERLAY")
			self:addButtonBorder{obj=spellBtn, relTo=spellBtn.Icon}
		end
		-- FollowerReward
		for flwrBtn in frame.followerRewardPool:EnumerateActive() do
			flwrBtn.BG:SetTexture(nil)
			flwrBtn.PortraitFrame.PortraitRing:SetTexture(nil)
			flwrBtn.PortraitFrame.LevelBorder:SetAlpha(0) -- texture changed
			if flwrBtn.PortraitFrame.PortraitRingCover then
				flwrBtn.PortraitFrame.PortraitRingCover:SetTexture(nil)
			end
		end
		for spellLine in frame.spellHeaderPool:EnumerateActive() do
			spellLine:SetVertexColor(aObj.BTr, aObj.BTg, aObj.BTb)
		end

	end
	local function updateQIDisplay()

		-- headers
		_G.QuestInfoTitleHeader:SetTextColor(aObj.HTr, aObj.HTg, aObj.HTb)
		_G.QuestInfoDescriptionHeader:SetTextColor(aObj.HTr, aObj.HTg, aObj.HTb)
		_G.QuestInfoObjectivesHeader:SetTextColor(aObj.HTr, aObj.HTg, aObj.HTb)
		-- other text
		_G.QuestInfoDescriptionText:SetTextColor(aObj.BTr, aObj.BTg, aObj.BTb)
		_G.QuestInfoQuestType:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G.QuestInfoObjectivesText:SetTextColor(aObj.BTr, aObj.BTg, aObj.BTb)
		_G.QuestInfoGroupSize:SetTextColor(aObj.BTr, aObj.BTg, aObj.BTb)
		_G.QuestInfoRewardText:SetTextColor(aObj.BTr, aObj.BTg, aObj.BTb)
		local r, g, b = _G.QuestInfoRequiredMoneyText:GetTextColor()
		_G.QuestInfoRequiredMoneyText:SetTextColor(aObj.BTr - r, aObj.BTg - g, aObj.BTb - b)
		-- skin rewards
		skinRewards(_G.QuestInfoFrame.rewardsFrame)

		-- Objectives
		local obj, r, g, b
		for i = 1, #_G.QuestInfoObjectivesFrame.Objectives do
			obj = _G.QuestInfoObjectivesFrame.Objectives[i]
			r, g ,b = obj:GetTextColor()
			-- if red colour is less than 0.2 then it needs to be coloured
			if r < 0.2 then
				obj:SetTextColor(aObj.BTr - r, aObj.BTg - g, aObj.BTb - b)
			end
		end
		obj, r, g, b = nil, nil, nil, nil

		-- QuestInfoSpecialObjectives Frame
		_G.QuestInfoSpellObjectiveLearnLabel:SetTextColor(aObj.BTr, aObj.BTg, aObj.BTb)
		_G.QuestInfoSpellObjectiveFrameNameFrame:SetTexture(nil)
		_G.QuestInfoSpellObjectiveFrameSpellBorder:SetTexture(nil)
		aObj:addButtonBorder{obj=_G.QuestInfoSpellObjectiveFrame, relTo=_G.QuestInfoSpellObjectiveFrame.Icon}

		-- QuestInfoSeal Frame
		if _G.QuestInfoSealFrame.sealInfo
		and _G.QuestInfoSealFrame.sealInfo.text
		then
			_G.QuestInfoSealFrame.Text:SetText(_G.RGBToColorCode(aObj.HTr, aObj.HTg, aObj.HTb) .. _G.QuestInfoSealFrame.sealInfo.text:sub(11))
		end

	end

	self:SecureHook("QuestInfo_Display", function(...)
		updateQIDisplay()
	end)

	self:SecureHookScript(_G.QuestInfoFrame, "OnShow", function(this)
		updateQIDisplay()
		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.QuestInfoTimerFrame, "OnShow", function(this)
		_G.QuestInfoTimerText:SetTextColor(self.BTr, self.BTg, self.BTb)
		_G.QuestInfoAnchor:SetTextColor(self.BTr, self.BTg, self.BTb)
		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.QuestInfoRequiredMoneyFrame, "OnShow", function(this)
		-- QuestInfoRequiredMoneyFrame
		self:SecureHook("QuestInfo_ShowRequiredMoney", function()
			local r, g ,b = _G.QuestInfoRequiredMoneyText:GetTextColor()
			-- if red value is less than 0.2 then it needs to be coloured
			if r < 0.2 then
				_G.QuestInfoRequiredMoneyText:SetTextColor(self.BTr - r, self.BTg - g, self.BTb - b)
			end
			r, g, b = nil, nil, nil
		end)

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.QuestInfoRewardsFrame, "OnShow", function(this)
		this.XPFrame.ReceiveText:SetTextColor(self.BTr, self.BTg, self.BTb)
		-- SkillPointFrame
		local spf = this.SkillPointFrame
		spf.NameFrame:SetTexture(nil)
		self:addButtonBorder{obj=spf, relTo=spf.Icon, reParent={spf.CircleBackground, spf.CircleBackgroundGlow, spf.ValueText}}
		spf = nil
		-- HonorFrame
		local hf = this.HonorFrame
		hf.NameFrame:SetTexture(nil)
		self:addButtonBorder{obj=hf, relTo=hf.Icon, reParent={hf.Count}}
		hf = nil
		-- ArtifactXPFrame
		local axp = this.ArtifactXPFrame
		axp.NameFrame:SetTexture(nil)
		self:addButtonBorder{obj=axp, relTo=axp.Icon, reParent={axp.Count}}
		axp = nil
		-- QuestInfoPlayerTitleFrame
		self:addButtonBorder{obj=_G.QuestInfoPlayerTitleFrame, relTo=_G.QuestInfoPlayerTitleFrame.Icon}
		self:removeRegions(_G.QuestInfoPlayerTitleFrame, {2, 3, 4,}) -- NameFrame textures

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.MapQuestInfoRewardsFrame, "OnShow", function(this)
		-- other rewards
		for _, type in pairs{"XPFrame", "HonorFrame", "ArtifactXPFrame", "MoneyFrame", "SkillPointFrame", "TitleFrame"} do
			this[type].NameFrame:SetTexture(nil)
			if type ~= "SkillPointFrame" then
				self:addButtonBorder{obj=this[type], relTo=this[type].Icon, reParent={this[type].Count}}
			else
				self:addButtonBorder{obj=this[type], relTo=this[type].Icon, reParent={this[type].CircleBackground, this[type].CircleBackgroundGlow, this[type].ValueText}}
			end
		end

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].Tabard = function(self)
	if not self.prdb.Tabard or self.initialized.Tabard then return end
	self.initialized.Tabard = true

	self:SecureHookScript(_G.TabardFrame, "OnShow", function(this)
		self:makeMFRotatable(_G.TabardModel)
		_G.TabardFrameCostFrame:SetBackdrop(nil)
		self:keepFontStrings(_G.TabardFrameCustomizationFrame)
		for i = 1, 5 do
			self:keepFontStrings(_G["TabardFrameCustomization" .. i])
			if self.modBtnBs then
				self:addButtonBorder{obj=_G["TabardFrameCustomization" .. i .. "LeftButton"], ofs=-2}
				self:addButtonBorder{obj=_G["TabardFrameCustomization" .. i .. "RightButton"], ofs=-2}
			end
		end

		self:keepRegions(this, {8, 29, 30, 31 ,32, 33, 34}) -- N.B. region 8, 33 & 34 are text, 29-32 are icon texture
		self:removeInset(_G.TabardFrameMoneyInset)
		_G.TabardFrameMoneyBg:DisableDrawLayer("BACKGROUND")
		self:skinStdButton{obj=_G.TabardFrameAcceptButton}
		self:skinStdButton{obj=_G.TabardFrameCancelButton}
		self:addSkinFrame{obj=this, ft=ftype, ri=true, x1=-3, y1=2, x2=1, y2=-2}

		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzFrames[ftype].TaxiFrame = function(self)
	if not self.prdb.TaxiFrame or self.initialized.TaxiFrame then return end
	self.initialized.TaxiFrame = true

	self:SecureHookScript(_G.TaxiFrame, "OnShow", function(this)
		self:removeRegions(this, {1, 2, 3}) -- 1st 3 overlay textures
		this:DisableDrawLayer("BORDER")
		self:addSkinFrame{obj=this, ft=ftype, x1=-3, y1=2, x2=1, y2=-2}
		-- resize map to fit skin frame
		this.InsetBg:SetPoint("TOPLEFT", 0, -24)
		this.InsetBg:SetPoint("BOTTOMRIGHT", 0 ,0)
		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzLoDFrames[ftype].TrainerUI = function(self)
	if not self.prdb.TrainerUI or self.initialized.TrainerUI then return end
	self.initialized.TrainerUI = true

	self:SecureHookScript(_G.ClassTrainerFrame, "OnShow", function(this)
		_G.ClassTrainerStatusBarLeft:SetAlpha(0)
		_G.ClassTrainerStatusBarRight:SetAlpha(0)
		_G.ClassTrainerStatusBarMiddle:SetAlpha(0)
		_G.ClassTrainerStatusBarSkillRank:SetPoint("CENTER", _G.ClassTrainerStatusBar) -- Blizzard bug
		self:skinStatusBar{obj=_G.ClassTrainerStatusBar, fi=0, bgTex=_G.ClassTrainerStatusBarBackground}
		self:skinDropDown{obj=_G.ClassTrainerFrameFilterDropDown}
		self:removeMagicBtnTex(_G.ClassTrainerTrainButton)
		self:skinStdButton{obj=_G.ClassTrainerTrainButton}
		_G.ClassTrainerFrame.skillStepButton:GetNormalTexture():SetTexture(nil)
		self:addButtonBorder{obj=this.skillStepButton, relTo=this.skillStepButton.icon}
		self:skinSlider{obj=_G.ClassTrainerScrollFrameScrollBar, wdth=-4}
		for i = 1, #this.scrollFrame.buttons do
			this.scrollFrame.buttons[i]:GetNormalTexture():SetTexture(nil)
			self:addButtonBorder{obj=this.scrollFrame.buttons[i], relTo=this.scrollFrame.buttons[i].icon}
		end
		self:removeInset(this.bottomInset)
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, ri=true, y1=2, x2=1, y2=-2}
		self:Unhook(this, "OnShow")
	end)

end

aObj.blizzLoDFrames[ftype].VoidStorageUI = function(self)
	if not self.prdb.VoidStorageUI or self.initialized.VoidStorageUI then return end
	self.initialized.VoidStorageUI = true

	self:SecureHookScript(_G.VoidStorageFrame, "OnShow", function(this)
		for _, type in pairs{"Deposit", "Withdraw", "Storage", "Cost"} do
			_G["VoidStorage" .. type .. "Frame"]:DisableDrawLayer("BACKGROUND")
			_G["VoidStorage" .. type .. "Frame"]:DisableDrawLayer("BORDER")
		end
		self:skinStdButton{obj=_G.VoidStorageTransferButton}
		self:skinCloseButton{obj=_G.VoidStorageBorderFrame.CloseButton}
		self:keepFontStrings(_G.VoidStorageBorderFrame)
		self:skinStdButton{obj=_G.VoidStorageHelpBoxButton}
		self:skinStdButton{obj=_G.VoidStoragePurchaseButton}
		self:addSkinFrame{obj=_G.VoidStoragePurchaseFrame, ft=ftype, kfs=true}
		self:addSkinFrame{obj=this, ft=ftype, kfs=true, y1=2, x2=1}
		self:skinEditBox{obj=_G.VoidItemSearchBox, regs={6, 7}, mi=true, noHeight=true, noMove=true} -- 6 is text, 7 is icon
		for i = 1, 2 do
			_G.VoidStorageFrame["Page" .. i]:DisableDrawLayer("BACKGROUND")
			self:addButtonBorder{obj=_G.VoidStorageFrame["Page" .. i]}
		end
		self:Unhook(this, "OnShow")
	end)

end
