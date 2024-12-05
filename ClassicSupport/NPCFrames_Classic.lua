if _G.WOW_PROJECT_ID == _G.WOW_PROJECT_MAINLINE then return end

local _, aObj = ...

local _G = _G

aObj.SetupClassic_NPCFrames = function()
	local ftype = "n"

	aObj.blizzLoDFrames[ftype].AuctionUI = function(self)
		if not self.prdb.AuctionUI or self.initialized.AuctionUI then return end
		self.initialized.AuctionUI = true

		local function skinBtn(btnName, idx)
			aObj:keepFontStrings(_G[btnName .. idx])
			_G[btnName .. idx .. "Highlight"]:SetAlpha(1)
			_G[btnName .. idx .. "ItemNormalTexture"]:SetAlpha(0) -- texture changed in code
			if aObj.modBtnBs then
				aObj:addButtonBorder{obj=_G[btnName .. idx .. "Item"], reParent={_G[btnName .. idx .. "Count"], _G[btnName .. idx .. "Stock"], _G[btnName .. idx .. "IconOverlay"]}}
			end
		end
		self:SecureHookScript(_G.AuctionFrame, "OnShow", function(this)
			-- hide filter texture when filter is clicked
			self:SecureHook("FilterButton_SetUp", function(button, _)
				_G[button:GetName() .. "NormalTexture"]:SetAlpha(0)
			end)
			self:skinObject("tabs", {obj=this, prefix=this:GetName(), fType=ftype, lod=self.isTT and true})
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, hdr=true, cb=true, x1=10, y1=-11, x2=3, y2=8})
			self:moveObject{obj=_G.AuctionFrameCloseButton, x=3}

			self:SecureHookScript(_G.AuctionFrameBrowse, "OnShow", function(fObj)
				for i = 1, _G.NUM_FILTERS_TO_DISPLAY do
					self:keepRegions(_G["AuctionFilterButton" .. i], {3, 4}) -- N.B. region 3 is the highlight, 4 is the text
					self:skinObject("frame", {obj=_G["AuctionFilterButton" .. i], fType=ftype, bd=5, y2=-1}) -- FIXME: y1=1, y2=1
				end
				self:skinObject("slider", {obj=_G.BrowseFilterScrollFrame.ScrollBar, fType=ftype, rpTex="artwork"})
				self:skinObject("slider", {obj=_G.BrowseScrollFrame.ScrollBar, fType=ftype, rpTex="artwork"})
				for _, type in _G.pairs{"Quality", "Level", "Duration", "HighBidder", "CurrentBid"} do
					self:keepRegions(_G["Browse" .. type .. "Sort"], {4, 5, 6}) -- N.B. region 4 is the text, 5 is the arrow, 6 is the highlight
					self:skinObject("frame", {obj=_G["Browse" .. type .. "Sort"], fType=ftype, bd=5, x2=-2})
				end
				self:skinObject("frame", {obj=_G.BrowsePriceOptionsFrame, fType=ftype, kfs=true, ofs=0})
				for i = 1, _G.NUM_BROWSE_TO_DISPLAY do
					if _G["BrowseButton" .. i].Orig then break end -- Auctioneer CompactUI loaded
					skinBtn("BrowseButton", i)
				end
				for _, type in _G.pairs{"Name", "MinLevel", "MaxLevel"} do
					self:skinObject("editbox", {obj=_G["Browse" .. type], fType=ftype})
					self:moveObject{obj=_G["Browse" .. type], x=type == "MaxLevel" and -6 or -4, y=type ~= "MaxLevel" and 3 or 0}
				end
				self:skinObject("ddbutton", {obj=_G.BrowseDropdown, fType=ftype--[[, x2=109]]})
				self:skinObject("moneyframe", {obj=_G.BrowseBidPrice, moveIcon=true})
				_G.BrowseBidButton:DisableDrawLayer("BORDER")
				_G.BrowseBuyoutButton:DisableDrawLayer("BORDER")
				_G.BrowseCloseButton:DisableDrawLayer("BORDER")
				if self.modBtns then
					self:skinStdButton{obj=_G.BrowseSearchButton, fType=ftype, schk=true}
					self:skinStdButton{obj=self:getPenultimateChild(_G.BrowsePriceOptionsFrame), fType=ftype} -- Done button
					self:skinStdButton{obj=_G.BrowseCloseButton, fType=ftype}
					self:skinStdButton{obj=_G.BrowseBuyoutButton, fType=ftype, schk=true}
					self:skinStdButton{obj=_G.BrowseBidButton, fType=ftype, schk=true}
					self:skinStdButton{obj=_G.BrowseResetButton, fType=ftype, schk=true}
				end
				if self.modBtnBs then
					self:addButtonBorder{obj=_G.BrowsePriceOptionsButtonFrame.Button, fType=ftype, ofs=-2, x1=1, clr="gold"}
					self:addButtonBorder{obj=_G.BrowsePrevPageButton, fType=ftype, schk=true, ofs=-2, y1=-3, x2=-3}
					self:addButtonBorder{obj=_G.BrowseNextPageButton, fType=ftype, schk=true, ofs=-2, y1=-3, x2=-3}
					self:SecureHookScript(_G.BrowseSearchButton, "OnUpdate", function(_, _)
						if _G.CanSendAuctionQuery("list") then
							self:clrPNBtns("Browse")
						end
					end)
					self:SecureHook("AuctionFrameBrowse_Update", function()
						if _G.AuctionFrame_DoesCategoryHaveFlag("WOW_TOKEN_FLAG", _G.AuctionFrameBrowse.selectedCategoryIndex) then
							return
						end
						for i = 1, _G.NUM_BROWSE_TO_DISPLAY do
							if _G["BrowseButton" .. i .. "Item"].sbb then
								_G["BrowseButton" .. i .. "Item"].sbb:SetBackdropBorderColor(_G["BrowseButton" .. i .. "Name"]:GetVertexColor())
							end
						end
					end)
				end
				if self.modChkBtns then
					self:skinCheckButton{obj=_G.IsUsableCheckButton, fType=ftype}
					self:skinCheckButton{obj=_G.ShowOnPlayerCheckButton, fType=ftype}
				end

				-- WoW Token
				self:SecureHookScript(_G.BrowseWowTokenResults, "OnShow", function(frame)
					frame.Token:DisableDrawLayer("BACKGROUND")
					if self.modBtns then
						self:skinStdButton{obj=frame.Buyout, fType=ftype}
						self:skinStdButton{obj=_G.StoreButton, fType=ftype, x1=14, y1=2, x2=-14, y2=2}
					end

					self:Unhook(frame, "OnShow")
				end)
				self:SecureHookScript(_G.WowTokenGameTimeTutorial, "OnShow", function(frame)
					frame.LeftDisplay.Label:SetTextColor(self.HT:GetRGB())
					frame.LeftDisplay.Tutorial1:SetTextColor(self.BT:GetRGB())
					frame.RightDisplay.Label:SetTextColor(self.HT:GetRGB())
					frame.RightDisplay.Tutorial1:SetTextColor(self.BT:GetRGB())
					self:skinObject("frame", {obj=frame, fType=ftype, kfs=true, ri=true, rns=true, cb=true, ofs=1, y1=2, y2=220})

					self:Unhook(frame, "OnShow")
				end)

				self:Unhook(fObj, "OnShow")
			end)
			self:checkShown(_G.AuctionFrameBrowse)

			self:SecureHookScript(_G.AuctionFrameBid, "OnShow", function(fObj)
				for _, type in _G.pairs{"Quality", "Level", "Duration", "Buyout", "Status", "Bid"} do
					self:keepRegions(_G["Bid" .. type .. "Sort"], {4, 5, 6}) -- N.B. region 4 is the text, 5 is the arrow, 6 is the highlight
					self:skinObject("frame", {obj=_G["Bid" .. type .. "Sort"], fType=ftype, bd=5, x2=-2})
				end
				for i = 1, _G.NUM_BIDS_TO_DISPLAY do
					skinBtn("BidButton", i)
				end
				self:skinObject("slider", {obj=_G.BidScrollFrame.ScrollBar, fType=ftype, rpTex="artwork"})
				self:skinObject("moneyframe", {obj=_G.BidBidPrice, moveIcon=true})
				_G.BidCloseButton:DisableDrawLayer("BORDER")
				_G.BidBuyoutButton:DisableDrawLayer("BORDER")
				_G.BidBidButton:DisableDrawLayer("BORDER")
				if self.modBtns then
					self:skinStdButton{obj=_G.BidBidButton, fType=ftype}
					self:skinStdButton{obj=_G.BidBuyoutButton, fType=ftype}
					self:skinStdButton{obj=_G.BidCloseButton, fType=ftype}
					self:SecureHook("AuctionFrameBid_Update", function()
						self:clrBtnBdr(_G.BidBidButton)
						self:clrBtnBdr(_G.BidBuyoutButton)
					end)
				end

				self:Unhook(fObj, "OnShow")
			end)

			self:SecureHookScript(_G.AuctionFrameAuctions, "OnShow", function(fObj)
				for _, type in _G.pairs{"Quality", "Duration", "HighBidder", "Bid"} do
					self:keepRegions(_G["Auctions" .. type .. "Sort"], {4, 5, 6}) -- N.B. region 4 is the text, 5 is the arrow, 6 is the highlight
					self:skinObject("frame", {obj=_G["Auctions" .. type .. "Sort"], fType=ftype, bd=5, x2=-2})
				end
				self:skinObject("slider", {obj=_G.AuctionsScrollFrame.ScrollBar, fType=ftype, rpTex="artwork"})
				for i = 1, _G.NUM_AUCTIONS_TO_DISPLAY do
					skinBtn("AuctionsButton", i)
				end
				self:skinObject("editbox", {obj=_G.AuctionsStackSizeEntry, fType=ftype, ofs=0})
				self:skinObject("editbox", {obj=_G.AuctionsNumStacksEntry, fType=ftype, ofs=0})
				self:skinObject("dropdown", {obj=_G.PriceDropDown})
				self:skinObject("moneyframe", {obj=_G.StartPrice, moveIcon=true})
				self:skinObject("moneyframe", {obj=_G.BuyoutPrice, moveIcon=true})
				if self.modBtns then
					self:skinStdButton{obj=_G.AuctionsStackSizeMaxButton, fType=ftype}
					self:skinStdButton{obj=_G.AuctionsNumStacksMaxButton, fType=ftype}
					self:skinStdButton{obj=_G.AuctionsCreateAuctionButton, fType=ftype, schk=true}
					self:skinStdButton{obj=_G.AuctionsCancelAuctionButton, fType=ftype, x2=-1}
					self:skinStdButton{obj=_G.AuctionsCloseButton, fType=ftype}
					self:SecureHook("AuctionFrameAuctions_Update", function()
						self:clrBtnBdr(_G.AuctionsCancelAuctionButton)
					end)
					if _G.C_AddOns.IsAddOnLoaded("Leatrix_Plus")
					and _G.LeaPlusDB["AhExtras"] == "On"
					then
						self:skinStdButton{obj=self:getLastChild(_G.AuctionFrameAuctions)}
					end
				end
				if not self.modBtnBs then
					self:resizeEmptyTexture(self:getRegion(_G.AuctionsItemButton, 2))
				else
					self:getRegion(_G.AuctionsItemButton, 2):SetAlpha(0) -- texture is changed in blizzard code
					self:addButtonBorder{obj=_G.AuctionsItemButton}
				end
				if _G.C_AddOns.IsAddOnLoaded("Leatrix_Plus")
				and _G.LeaPlusDB["AhExtras"] == "On"
				and self.modChkBtns
				then
					self:skinCheckButton{obj=self:getPenultimateChild(_G.AuctionFrameAuctions)}
					self:skinCheckButton{obj=self:getChild(_G.AuctionFrameAuctions, _G.AuctionFrameAuctions:GetNumChildren() - 2)}
				end

				self:Unhook(fObj, "OnShow")
			end)

			self:Unhook(this, "OnShow")
		end)

		self:SecureHookScript(_G.AuctionProgressFrame, "OnShow", function(frame)
			frame:DisableDrawLayer("ARTWORK")
			self:keepFontStrings(_G.AuctionProgressBar)
			self:moveObject{obj=_G.AuctionProgressBar.Text, y=-2}
			self:skinObject("statusbar", {obj=_G.AuctionProgressBar, fi=0, bg=_G.AuctionProgressBarFill})

			self:Unhook(frame, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].BankFrame = function(self)
		if not self.prdb.BankFrame or self.initialized.BankFrame then return end
		self.initialized.BankFrame = true

		self:SecureHookScript(_G.BankFrame, "OnShow", function(this)
			self:keepFontStrings(_G.BankSlotsFrame)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, ofs=-11, x2=self.isClsc and 16 or -33, y2=90})
			if self.modBtns then
				self:skinCloseButton{obj=_G.BankCloseButton, fType=ftype}
				self:skinStdButton{obj=_G.BankFramePurchaseButton, fType=ftype}
			end
			if self.modBtnBs then
				self:SecureHook("BankFrameItemButton_Update", function(btn)
					if not btn.hasItem then
						self:clrBtnBdr(btn, "grey")
					end
				end)
				-- add button borders to bank items
				for i = 1, _G.NUM_BANKGENERIC_SLOTS do
					self:addButtonBorder{obj=_G.BankSlotsFrame["Item" .. i], fType=ftype, ibt=true}
					-- force quality border update
					_G.BankFrameItemButton_Update(_G.BankSlotsFrame["Item" .. i])
				end
				-- add button borders to bag slots
				for i = 1, _G.NUM_BANKBAGSLOTS do
					self:addButtonBorder{obj=_G.BankSlotsFrame["Bag" .. i], fType=ftype, ibt=true}
				end
				self:SecureHook("UpdateBagSlotStatus", function()
					for i = 1, _G.NUM_BANKBAGSLOTS do
						_G.BankSlotsFrame["Bag" .. i].sbb:SetBackdropBorderColor(_G.BankSlotsFrame["Bag" .. i].icon:GetVertexColor())
					end
				end)
				-- colour button borders
				_G.UpdateBagSlotStatus()
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzFrames[ftype].PetStableFrame = function(self)
		if not self.prdb.PetStableFrame or self.initialized.PetStableFrame then return end
		self.initialized.PetStableFrame = true

		self:SecureHookScript(_G.PetStableFrame, "OnShow", function(this)
			self:makeMFRotatable(_G.PetStableModel)
			_G.PetStableCurrentPetBackground:SetTexture(nil)
			_G.PetStableStabledPet1Background:SetTexture(nil)
			_G.PetStableStabledPet2Background:SetTexture(nil)
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, x1=10, y1=-11, x2=-31, y2=71})
			if self.modBtns then
				self:skinCloseButton{obj=_G.PetStableFrameCloseButton, fType=ftype}
				self:skinStdButton{obj=_G.PetStablePurchaseButton, fType=ftype}
				self:SecureHook("PetStable_Update", function()
					self:clrBtnBdr(_G.PetStablePurchaseButton)
				end)
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=_G.PetStablePetInfo, ofs=1, x2=0, clr="gold"}
				-- TODO: use white border
				self:addButtonBorder{obj=_G.PetStableCurrentPet, clr="white"}
				local btn
				for i = 1, _G.NUM_PET_STABLE_SLOTS do
					btn = _G["PetStableStabledPet" .. i]
					self:addButtonBorder{obj=btn}
					self:SecureHook(_G["PetStableStabledPet" .. i .. "Background"], "SetVertexColor", function(tObj, ...)
						tObj:GetParent().sbb:SetBackdropBorderColor(...)
					end)
				end
			end

			self:Unhook(this, "OnShow")
		end)

	end

	if aObj.isClsc then
		aObj.blizzLoDFrames[ftype].ReforgingUI = function(self)
			if not self.prdb.ReforgingUI or self.initialized.ReforgingUI then return end
			self.initialized.ReforgingUI = true

			self:SecureHookScript(_G.ReforgingFrame, "OnShow", function(this)
				_G.ReforgingFrameItemButton:DisableDrawLayer("BACKGROUND")
				_G.ReforgingFrameItemButton:DisableDrawLayer("OVERLAY")
				self:removeMagicBtnTex(_G.ReforgingFrameRestoreButton)
				self:removeMagicBtnTex(_G.ReforgingFrameReforgeButton)
				self:keepFontStrings(_G[this:GetName() .. "ButtonFrame"])
				self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, x2=1})
				if self.modBtns then
					self:skinStdButton{obj=_G.ReforgingFrameRestoreButton, fType=ftype, schk=true}
					self:skinStdButton{obj=_G.ReforgingFrameReforgeButton, fType=ftype, schk=true}
				end
				if self.modBtnBs then
					self:addButtonBorder{obj=_G.ReforgingFrameItemButton, fType=ftype, clr="bronze"}
				end

				self:Unhook(this, "OnShow")
			end)

		end
	end

	aObj.blizzFrames[ftype].TaxiFrame = function(self)
		if not self.prdb.TaxiFrame or self.initialized.TaxiFrame then return end
		self.initialized.TaxiFrame = true

		self:SecureHookScript(_G.TaxiFrame, "OnShow", function(this)
			self:removeRegions(this, {1, 2 ,3 ,4 ,5}) -- keep the map texture(s)
			self:skinObject("frame", {obj=this, fType=ftype, x1=10, y1=-11, x2=-32, y2=62})
			if self.modBtns then
				self:skinCloseButton{obj=_G.TaxiCloseButton, fType=ftype}
			end

			self:Unhook(this, "OnShow")
		end)

	end

	aObj.blizzLoDFrames[ftype].TrainerUI = function(self)
		if not self.prdb.TrainerUI or self.initialized.TrainerUI then return end
		self.initialized.TrainerUI = true

		self:SecureHookScript(_G.ClassTrainerFrame, "OnShow", function(this)
			self:skinObject("ddbutton", {obj=this.FilterDropdown, fType=ftype, filter=true})
			self:removeMagicBtnTex(_G.ClassTrainerTrainButton)
			self:keepFontStrings(_G.ClassTrainerExpandButtonFrame)
			_G.ClassTrainerSkillIcon:DisableDrawLayer("BACKGROUND")
			self:skinObject("slider", {obj=_G.ClassTrainerListScrollFrame.ScrollBar, fType=ftype, rpTex="background"})
			self:skinObject("slider", {obj=_G.ClassTrainerDetailScrollFrame.ScrollBar, fType=ftype, rpTex="background"})
			local x2, y2 = -32, 71
			if _G.C_AddOns.IsAddOnLoaded("Leatrix_Plus")
			and _G.LeaPlusDB["EnhanceTrainers"] == "On"
			then
				x2, y2 = -33, 49
				if self.isClscERA
				and self.modBtns
				then
					self:skinStdButton{obj=_G.LeaPlusGlobalTrainAllButton, sechk=true} -- Train All button
				end
			end
			self:skinObject("frame", {obj=this, fType=ftype, kfs=true, cb=true, x1=10, y1=-11, x2=x2, y2=y2})
			if self.modBtns then
				self:skinStdButton{obj=_G.ClassTrainerTrainButton, fType=ftype, schk=true}
				self:skinStdButton{obj=_G.ClassTrainerCancelButton, fType=ftype}
				self:skinExpandButton{obj=_G.ClassTrainerCollapseAllButton, fType=ftype, onSB=true}
				for i = 1, _G.CLASS_TRAINER_SKILLS_DISPLAYED do
					self:skinExpandButton{obj=_G["ClassTrainerSkill" .. i], onSB=true}
				end
				self:SecureHook("ClassTrainerFrame_Update", function()
					self:checkTex(_G.ClassTrainerCollapseAllButton)
					for i = 1, _G.CLASS_TRAINER_SKILLS_DISPLAYED do
						self:checkTex{obj=_G["ClassTrainerSkill" .. i]}
					end
					self:clrBtnBdr(_G.ClassTrainerCollapseAllButton)
				end)
			end
			if self.modBtnBs then
				self:addButtonBorder{obj=_G.ClassTrainerSkillIcon, fType=ftype}
			end

			self:Unhook(this, "OnShow")
		end)

	end

end

aObj.SetupClassic_NPCFramesOptions = function(self)

	local optTab = {
		["Auction UI"]            = true,
		["PetStableFrame"]        = {desc = "Stable Frame"},
		["Reforging UI"]		  = self.isClsc and true or nil,
	}
	self:setupFramesOptions(optTab, "NPC")
	_G.wipe(optTab)

end
