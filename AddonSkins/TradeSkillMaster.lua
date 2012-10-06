local aName, aObj = ...
if not aObj:isAddonEnabled("TradeSkillMaster") then return end

function aObj:TradeSkillMaster()

	local bbc ={}
	bbc.r, bbc.g, bbc.b, bbc.a = unpack(self.bbColour)

	-- hook this to skin ScrollingTables
	self:RawHook(TSMAPI, "CreateScrollingTable", function(this, ...)
		local sT = self.hooks[this].CreateScrollingTable(this, ...)
		sT.sf = self:addSkinFrame{obj=sT.frame}
		self:skinScrollBar{obj=sT.scrollframe}
		self:removeRegions(_G[sT.frame:GetName().."ScrollTrough"], {1, 2}) -- hide as textures are updated
		return sT
	end, true)
	-- hook these to skin frames, buttons etc
	local btn, btnPrnt
	self:RawHook(TSMAPI.GUI, "CreateButton", function(this, ...)
		btn = self.hooks[this].CreateButton(this, ...)
		self:skinButton{obj=btn, x1=-2, y1=2, x2=2, y2=-2}
		return btn
	end, true)
	local eBox
	local iBox
	self:RawHook(TSMAPI.GUI, "CreateInputBox", function(this, ...)
		iBox = self.hooks[this].CreateInputBox(this, ...)
		self:skinEditBox{obj=iBox, regs={9}}
		return iBox
	end, true)
	-- these are from the AuctionGUI
	local GUI = TSMAPI:GetGUIFunctions()
	local bar
	self:RawHook(GUI, "AddHorizontalBar", function(this, ...)
		bar = self.hooks[this].AddHorizontalBar(this, ...)
		bar.texture:SetVertexColor(bbc.r, bbc.g, bbc.b, 1)
		return bar
	end, true)
	self:RawHook(GUI, "AddVerticalBar", function(this, ...)
		bar = self.hooks[this].AddVerticalBar(this, ...)
		bar.texture:SetVertexColor(bbc.r, bbc.g, bbc.b, 1)
		return bar
	end, true)
	self:RawHook(GUI, "CreateEditBox", function(this, ...)
		eBox = self.hooks[this].CreateEditBox(this, ...)
		self:skinEditBox{obj=eBox, regs={9}}
		return eBox
	end, true)
	local frame
	local icon
	self:RawHook(GUI, "CreateIcon", function(this, ...)
		icon = self.hooks[this].CreateIcon(this, ...)
		if self.modBtnBs then
			self:addButtonBorder{obj=icon}
		end
		return icon
	end, true)


	-- hook this to skin the TSM Auction frame
	self:SecureHook(TSMAuctionFrame, "Show", function(this)
		self:addSkinFrame{obj=this, kfs=true, ofs=5, x1=0}
		this.SetBackdrop = function() end
		self:Unhook(TSMAuctionFrame, "Show")
	end)

	-- skin modules
	for _, module in pairs{"Accounting", "AuctionDB", "Auctioning", "Crafting", "Destroying", "ItemTracker", "Mailing", "Shopping", "Warehousing", "WoWAuction"} do
		if IsAddOnLoaded("TradeSkillMaster_"..module) then
			self:checkAndRunAddOn("TradeSkillMaster_"..module)
		end
	end

end

function aObj:TradeSkillMaster_Accounting()
	-- body
end

function aObj:TradeSkillMaster_AuctionDB()
	-- body
end

function aObj:TradeSkillMaster_Auctioning()
	-- body
end

function aObj:TradeSkillMaster_Crafting()

	local TSM_C = LibStub("AceAddon-3.0"):GetAddon("TradeSkillMaster_Crafting", true)

	local Vendor = TSM_C:GetModule("Vendor", true)
	if Vendor then
		self:SecureHook(Vendor, "CreateMerchantBuyButton", function(this)
			self:skinButton{obj=this.merchantButton}
			self:Unhook(Vendor, "CreateMerchantBuyButton")
		end)
	end

	local Crafting = TSM_C:GetModule("Crafting", true)
	if Crafting then
		local function skinButton(btn)
			aObj:skinButton{obj=btn}
			btn:SetBackdrop(nil)
		end
		self:SecureHook(Crafting, "CreateCraftMangementWindow", function(this)
			skinButton(Crafting.openCloseButton)
			self:skinScrollBar{obj=Crafting.frame.craftingScroll}
			skinButton(Crafting.frame.noCrafting.button)
			skinButton(Crafting.craftNextButton)
			skinButton(Crafting.restockQueueButton)
			skinButton(Crafting.onHandQueueButton)
			skinButton(Crafting.clearQueueButton)
			skinButton(Crafting.clearFilterButton)
			self:skinScrollBar{obj=Crafting.frame.shoppingScroll}
			self:skinScrollBar{obj=Crafting.frame.queuingScroll}
			if self.modBtns then
				for i = 1, #Crafting.queuingRows do
					self:skinButton{obj=Crafting.queuingRows[i].button, mp=true}
				end
				self:SecureHook(Crafting, "UpdateQueuing", function(this)
					for i = 1, #Crafting.queuingRows do
						self:checkTex(Crafting.queuingRows[i].button)
					end
				end)
			end
			if self.modBtnBs then
				for k, v in pairs(Crafting.frame.professionBar.icons) do
					self:addButtonBorder{obj=v, relTo=v.image}
				end
			end
			self:Unhook(Crafting, "CreateCraftMangementWindow")
		end)
	end

end

function aObj:TradeSkillMaster_Destroying()
	-- body
end

function aObj:TradeSkillMaster_ItemTracker()
	-- body
end

function aObj:TradeSkillMaster_Mailing()
	-- body
end

function aObj:TradeSkillMaster_Shopping()
	-- body
end

function aObj:TradeSkillMaster_Warehousing()
	-- body
end

function aObj:TradeSkillMaster_WoWAuction()
	-- body
end
