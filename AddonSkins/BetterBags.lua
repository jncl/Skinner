local _, aObj = ...
if not aObj:isAddonEnabled("BetterBags") then return end
local _G = _G

aObj.addonsToSkin.BetterBags = function(self) -- v 0.1.7

	local bBag = _G.LibStub("AceAddon-3.0"):GetAddon("BetterBags", true)
	if not bBag then return end

	local const, skinBtn, skinCVBtns = _G.nop, _G.nop, _G.nop
	if self.modBtnBs then
		const = bBag:GetModule("Constants", true)
		function skinBtn(btn, empty)
			aObj:addButtonBorder{obj=btn, ibt=true}
			if aObj.isRtl then
				btn.ItemSlotBackground:SetAlpha(0)
			else
				if empty then
					_G.SetItemButtonTexture(btn, nil)
				end
			end
			aObj:clrButtonFromBorder(btn)
		end
		local cV
		function skinCVBtns(bagType)
			cV = bBag.Bags[bagType].currentView
			local data
			for _, item in _G.pairs(cV.itemsByBagAndSlot) do
				data = item.button.data or item.data
				skinBtn(item.button.button or item.button, data.isItemEmpty)
			end
			if cV.freeSlot then
				skinBtn(cV.freeSlot.button, cV.freeSlot.data.isItemEmpty)
			end
			if cV.freeReagentSlot then
				skinBtn(cV.freeReagentSlot.button)
			end
		end
		local events = bBag:GetModule("Events", true)
		events:RegisterMessage("items/RefreshBackpack/Done", function(_, _)
			skinCVBtns("Backpack")
		end)
		events:RegisterMessage("items/RefreshBank/Done", function(_, _)
			skinCVBtns("Bank")
		end)
	end

	local function handleBag(bagObj)
		aObj:SecureHookScript(bagObj.frame, "OnShow", function(this)
			aObj:skinObject("frame", {obj=this, kfs=true, cb=true, y1=aObj.isRtl and -1 or nil, x2=aObj.isClsc and 1 or 0})
			if aObj.isRtl then
				aObj:getRegion(this.PortraitContainer, 1):SetAlpha(1) -- portrait texture
			else
				aObj:getRegion(this, 18):SetAlpha(1) -- menu button texture
			end
			if aObj.modBtnBs then
				skinCVBtns(bagObj.kind == const.BAG_KIND.BACKPACK and "Backpack" or "Bank")
			end

			aObj:Unhook(this, "OnShow")
		end)

		aObj:SecureHookScript(bagObj.slots.frame, "OnShow", function(this)
			aObj:skinObject("frame", {obj=this, kfs=true, cb=true, x2=1})

			aObj:Unhook(this, "OnShow")
		end)
		if aObj.modBtnBs then
			local function skinBagSlots(frame)
				for _, cell in _G.ipairs(frame.content.cells) do
					skinBtn(cell.frame, cell.empty)
					if cell.canBuy then
						aObj:clrBBC(cell.frame.sbb, "red")
					end
				end
			end
			aObj:SecureHook(bagObj.slots, "Draw", function(fObj)
				skinBagSlots(fObj)
			end)
			skinBagSlots(bagObj.slots)
		end

		if bagObj.currencyFrame then
			aObj:SecureHookScript(bagObj.currencyFrame.frame, "OnShow", function(this)
				self:skinObject("frame", {obj=this, kfs=true})

				self:Unhook(this, "OnShow")
			end)
			if aObj.modBtnBs then
				local info
				local function skinCurBtns(frame)
					for _, cell in _G.ipairs(frame.content.cells) do
						aObj:addButtonBorder{obj=cell.frame, relTo=cell.icon, clr="grey"}
						info = _G.C_CurrencyInfo.GetCurrencyListInfo(cell.index)
						cell.frame.sbb:SetShown(not info.isHeader)
					end
				end
				aObj:SecureHook(bagObj.currencyFrame, "Update", function(this)
					skinCurBtns(this)
				end)
				skinCurBtns(bagObj.currencyFrame)
			end
		end

	end

	handleBag(bBag.Bags.Backpack)
	handleBag(bBag.Bags.Bank)

	local search = bBag:GetModule("Search", true)
	self:SecureHookScript(search.searchFrame.frame, "OnShow", function(this)
		this:DisableDrawLayer("BORDER")
		self:skinObject("frame", {obj=this, kfs=true})

		self:Unhook(this, "OnShow")
	end)

end
