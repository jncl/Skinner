local aName, aObj = ...
if not aObj:isAddonEnabled("TradeSkillMaster") then return end

function aObj:TradeSkillMaster()

	local bbc ={}
	bbc.r, bbc.g, bbc.b, bbc.a = unpack(self.bbColour)

	-- hook this to skin ScrollingTables
	self:RawHook(TSMAPI, "CreateScrollingTable", function(this, ...)
		local sT = self.hooks[this].CreateScrollingTable(this, ...)
		if not self.skinFrame[sT.frame] then self:addSkinFrame{obj=sT.frame} end
		self:skinScrollBar{obj=sT.scrollframe}
		self:removeRegions(_G[sT.frame:GetName().."ScrollTrough"], {1, 2}) -- hide as textures are updated
		return sT
	end, true)
	-- hook this to skin frames
	self:SecureHook(TSMAPI, "RegisterForColorChanges", function(this, frame)
		self:addSkinFrame{obj=frame}
		if frame.bg
		and frame.bg.SetBackdrop
		then
			frame.bg:SetBackdrop(nil)
		end
	end)
	-- hook these to skin frames, buttons etc
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
	local btn, btnPrnt
	self:RawHook(GUI, "CreateButton", function(this, ...)
		btn = self.hooks[this].CreateButton(this, ...)
		self:skinButton{obj=btn, x1=-3, y1=3, x2=3, y2=-3}
		btn.border:SetTexture(nil)
		-- if button's parent has a backdrop and it's not skinned remove the backdrop
		btnPrnt = btn:GetParent()
		if btnPrnt.SetBackdrop
		and not self.skinFrame[btnPrnt]
		then
			btnPrnt:SetBackdrop(nil)
		end
		return btn
	end, true)
	local eBox
	self:RawHook(GUI, "CreateEditBox", function(this, ...)
		eBox = self.hooks[this].CreateEditBox(this, ...)
		self:skinEditBox{obj=eBox, regs={9}}
		return eBox
	end, true)
	local frame
	self:RawHook(GUI, "CreateRightClickFrame", function(this, ...)
		frame = self.hooks[this].CreateRightClickFrame(this, ...)
		self:addSkinFrame{obj=frame}
		return frame
	end, true)
	local icon
	self:RawHook(GUI, "CreateIcon", function(this, ...)
		icon = self.hooks[this].CreateIcon(this, ...)
		if self.modBtnBs then
			self:addButtonBorder{obj=icon}
		end	
		return icon
	end, true)
	local iBox
	self:RawHook(GUI, "CreateInputBox", function(this, ...)
		iBox = self.hooks[this].CreateInputBox(this, ...)
		self:skinEditBox{obj=iBox, regs={9}}
		return iBox
	end, true)

	-- add border to Icons if required
	if self.modBtnBs then
		local TSM = LibStub("AceAddon-3.0"):GetAddon("TradeSkillMaster", true)
		local function addBorder(obj)
			for _, child in ipairs{TSM.Frame.frame:GetChildren()} do
				if child:IsObjectType("Button")
				and child.image
				and not child.sknrBdr
				then
					aObj:addButtonBorder{obj=child, relTo=child.image}
				end
			end
		end
		addBorder()
		self:SecureHook(TSM, "BuildIcons", function(this)
			addBorder()
		end)
	end
	-- Auction Frame (Tab)
	self:addSkinFrame{obj=TSMAuctionFrame, kfs=true, x1=10, y1=-11, y2=4}

	-- skin modules
	for _, module in pairs{"Accounting", "AuctionDB", "Auctioning", "Crafting", "Destroying", "ItemTracker", "Mailing", "Shopping", "Warehousing"} do
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

	local TSM_S = LibStub("AceAddon-3.0"):GetAddon("TradeSkillMaster_Shopping", true)
	local Search = TSM_S:GetModule("Search", true)
	if Search then
		local point, relTo, relPoint, xOfs, yOfs
		self:SecureHook(Search, "Show", function(this)
			this.searchBar.editBox:SetHeight(24)
			self:moveObject{obj=this.searchBar.editBox, y=-6}
			-- reposition buttons as editbox size has changed
			for k, v in pairs{"button", "savedSearchesButton", "dealfindingSearchButton"} do
				local btn = this.searchBar[v]
				point, relTo, relPoint, xOfs, yOfs = btn:GetPoint(1)
				btn:SetPoint(point, relTo, relPoint, xOfs, yOfs + 7)
				point, relTo, relPoint, xOfs, yOfs = btn:GetPoint(2)
				btn:SetPoint(point, relTo, relPoint, xOfs, yOfs - 5)
			end
			self:Unhook(Search, "Show")
		end)
	end

end

function aObj:TradeSkillMaster_Warehousing()
	-- body
end
