local _, aObj = ...
if not aObj:isAddonEnabled("BetterBags") then return end
local _G = _G

aObj.addonsToSkin.BetterBags = function(self) -- v0.1.89

	local bBag = _G.LibStub("AceAddon-3.0"):GetAddon("BetterBags", true)
	if not bBag then return end

	local skinBtn = _G.nop
	if self.modBtnBs then
		function skinBtn(btn)
			aObj:addButtonBorder{obj=btn, ibt=true}
			aObj:clrButtonFromBorder(btn)
		end
		local cV
		local function skinCVBtns(bagType)
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
		events:RegisterMessage("item/NewButton", function(_, _, button)
			if aObj.isRtl then
				button.ItemSlotBackground:SetAlpha(0)
			else
				_G.SetItemButtonTexture(button, nil)
			end
		end)
	end

	local function skinFrame(frame)
		if frame.Bg then
			frame.Bg:SetTexture(nil)
		end
		if frame.TitleContainer
		and frame.TitleContainer.TitleBg
		then
			frame.TitleContainer.TitleBg:SetTexture(nil)
		end
		if frame.search then
			aObj:skinObject("editbox", {obj=frame.search.textBox, si=true})
		end
		aObj:skinObject("frame", {obj=frame, kfs=true, cb=true, bg=true})
	end
	local function handleBag(bagObj)
		aObj:SecureHookScript(bagObj.frame, "OnShow", function(this)
			skinFrame(aObj:getLastChild(this)) -- decorator frame

			aObj:Unhook(this, "OnShow")
		end)

		aObj:SecureHookScript(bagObj.slots.frame, "OnShow", function(this)
			skinFrame(aObj:getLastChild(this)) -- decorator frame

			aObj:Unhook(this, "OnShow")
		end)
		if aObj.modBtnBs then
			local function skinBagSlots(frame)
				for _, cell in _G.ipairs(frame.content.cells) do
					skinBtn(cell.frame, cell.empty)
					if cell.canBuy then
						aObj:clrBBC(cell.frame.sbb, "red")
					end
					if cell.empty then
						if aObj.isRtl then
							cell.frame.ItemSlotBackground:SetTexture(nil)
						else
							_G.SetItemButtonTexture(cell.frame, nil)
						end
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
				skinFrame(aObj:getLastChild(this)) -- decorator frame

				aObj:Unhook(this, "OnShow")
			end)
			if aObj.modBtnBs then
				local info
				local function skinCurBtns(frame)
					for _, cell in _G.ipairs(frame.content.cells) do
						aObj:addButtonBorder{obj=cell.frame, relTo=cell.icon, clr="grey"}
						if aObj.isRtl then
							info = _G.C_CurrencyInfo.GetCurrencyListInfo(cell.index)
						else
							info = {_G.GetCurrencyListInfo(cell.index)}
						end
						cell.frame.sbb:SetShown(not (info.isHeader or info[2]))
					end
				end
				aObj:SecureHook(bagObj.currencyFrame, "Update", function(this)
					skinCurBtns(this)
				end)
				skinCurBtns(bagObj.currencyFrame)
			end
		end
		if bagObj.themeConfigFrame then
			aObj:SecureHookScript(bagObj.themeConfigFrame.frame, "OnShow", function(this)
				skinFrame(aObj:getLastChild(this)) -- decorator frame

				aObj:Unhook(this, "OnShow")
			end)
		end
		if bagObj.sectionConfigFrame then
			aObj:SecureHookScript(bagObj.sectionConfigFrame.frame, "OnShow", function(this)
				skinFrame(aObj:getLastChild(this)) -- decorator frame

				aObj:Unhook(this, "OnShow")
			end)
		end

	end

	handleBag(bBag.Bags.Backpack)
	handleBag(bBag.Bags.Bank)

	local searchBox = bBag:GetModule("SearchBox", true)
	self:SecureHook(searchBox, "CreateBox", function(this)
		self:skinObject("editbox", {obj=this.textBox, si=true})

		self:Unhook(this, "OnShow")
	end)

	self:SecureHookScript(_G.BetterBagsSearchFrame, "OnShow", function(this)
		self:skinObject("frame", {obj=this})

		self:Unhook(this, "OnShow")
	end)

end
